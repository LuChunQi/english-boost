#!/bin/bash
# 计算英语练习 Day 编号（仅周一三五推送）
# 从2026-06-01开始，只计算推送日

START=2026-06-01
TODAY=$(date +%Y-%m-%d)
DOW=$(date +%u)  # 1=周一 7=周日

# 只在周一(1)、周三(3)、周五(5)才有效
if [[ "$DOW" != "1" && "$DOW" != "3" && "$DOW" != "5" ]]; then
  echo "SKIP"
  exit 0
fi

# 期末暂停：6月20-25日
MONTH=$(date +%m)
DAY=$(date +%d)
if [[ "$MONTH" == "06" ]] && [[ "$DAY" -ge 20 ]] && [[ "$DAY" -le 25 ]]; then
  echo "EXAM_BREAK"
  exit 0
fi

# 计算从开始日期到今天，有多少个周一/周三/周五
START_SEC=$(date -d "$START" +%s)
TODAY_SEC=$(date -d "$TODAY" +%s)
TOTAL_DAYS=$(( (TODAY_SEC - START_SEC) / 86400 ))

COUNT=0
for i in $(seq 0 $TOTAL_DAYS); do
  D=$(date -d "$START + $i days" +%Y-%m-%d)
  DW=$(date -d "$D" +%u)
  # 检查是否在期末暂停期
  DM=$(date -d "$D" +%m)
  DD=$(date -d "$D" +%d)
  SKIP=false
  if [[ "$DM" == "06" ]] && [[ "$DD" -ge 20 ]] && [[ "$DD" -le 25 ]]; then
    SKIP=true
  fi
  if [[ "$DW" == "1" || "$DW" == "3" || "$DW" == "5" ]] && [[ "$SKIP" == "false" ]]; then
    COUNT=$((COUNT + 1))
  fi
done

printf "day-%02d" "$COUNT"
