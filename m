Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B81CC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078B06B008A; Mon, 31 Aug 2026 04:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050636B009B; Mon, 31 Aug 2026 04:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8816B009D; Mon, 31 Aug 2026 04:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C39D26B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:41:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34496403F4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:41:27 +0000 (UTC)
X-FDA: 85160920614.21.F60CF47
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id D11F8180002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:41:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JiNRi14O;
	spf=pass (imf16.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=junjie.cao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788165685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bG18/UuJ8sPW01vYMzFFFIcN9AfCWu3aTjE90c0NCI=;
	b=WfooI3Y7HxS9QTOWpO51sCZy1exJifRzsbt/Qu9wfIutJYO9627omiA+HWdQr8++VEh5Ds
	0nt9J87ZA1nRU67a/zfxdvCJYWsKFERzmGElu8m82rKrvlLp59yh5EBxRw6ZZ2UkuXR0No
	3ZEg7kJlNS3kzJnrSVrC2DejdXiF4X8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JiNRi14O;
	spf=pass (imf16.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=junjie.cao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788165685;
	b=S7ZxXCA9MyiOUhRQ0OXZ1HnrU2uzSD724A6VWwkyyFu1LANyAXjOOKviBz74urgSyKydm6
	k7Ic9s5D13gi3vhe88LP2SgXOeqRr2kqZE9395PFmizYas27BpbMxNW4AEWGf4W4cYIZGu
	F/ge5CWyeOHno5agBAJTahfmRPwltnU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788165685; x=1819701685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AnnLzZQASW3ffm7HTAuT/jmzPEia7UpYkcE3pF7Rkko=;
  b=JiNRi14Ou/bnHVAjl8GqyozRkd/gdQaGCRM6KEvw1j+1CSh+7dw34eZi
   krIgSWJQlYaiXkRAk8hb7azWLk64A4B7ZhRdFT74I+B+nqf7V9cdewd3w
   CK42zAHAUuckXukS1DEa+vFcc+RoYM5vFA8SbR+JiMKinX10mRpz5v8f8
   T/Pq/SwbmkvuILhxCUK+uVj55A1BScukAYYvnNImhLekgf1Y7wGIqWhKG
   OiQ9LhAeLqo88mU82+PwPje3moEVLw5boufWQfytwb4vMRRkeBLcXopih
   8tIPorKh9ceHX3wqSNVq1WGBNOHDdyfpMSHHUHgPB4ZrCLqACHnOot1wH
   A==;
X-CSE-ConnectionGUID: I2I/QwE3SaCHy0KYtiVWuA==
X-CSE-MsgGUID: 7G3emzNXTvSr8Bj2folWGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="92377458"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="92377458"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:41:23 -0700
X-CSE-ConnectionGUID: x3cXeIogRP+9WYIvzuUX6Q==
X-CSE-MsgGUID: W9En3HfcRAO15TxpsdsfNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="274009046"
Received: from junjie-desk-dev.bj.intel.com (HELO junjie-desk-dev.tail2c02c1.ts.net) ([10.238.152.71])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:41:18 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com
Cc: liam.howlett@oracle.com,
	akpm@linux-foundation.org,
	bigeasy@linutronix.de,
	david@kernel.org,
	harry.yoo@oracle.com,
	jannh@google.com,
	jpoimboe@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	riel@surriel.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	vinicius.gomes@intel.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
Date: Mon, 31 Aug 2026 16:41:12 +0800
Message-ID: <20260831084112.410440-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6945a977.a70a0220.207337.011c.GAE@google.com>
References: <6945a977.a70a0220.207337.011c.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ka1zkp54tquwqz3bofp9pdu9hth6yqir
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D11F8180002
X-Rspam-User: 
X-HE-Tag: 1788165684-700914
X-HE-Meta: U2FsdGVkX18P/Dc6ylVXtYgJfT60xWXhC8Hbd6RaCN+JvHk4Jx1K2PE7J5pWsJZ7BjTRgbKAOoq3s+04DhCLkhwe3BH5zs9Qq0tNzH/hSnJh89QF8vXhGZ4u9wK1+aKBxG6Djn19ImQPtl53RxWBilY6MyKJdvKOgs5xyYzEGVPvGoF9vTSPZLRhNBIPybg1mdHv36QeXYuq2fgoC9RA5zoVgqEczMOJFjkfXSq8GHqxFHXhcFNYBAMrjrd852tEnedaI4inKGlaa+s/1n+WFiqeegRdfU8Ed+xYQkC51hx85SrxqtI9mlus1htPcoYA68Qjv6CQ0uK9vjjCg/xQMhzCrUqd/ZZ2n9HRQ8g/iYfyvn5zcqBwnyxx3ABZnbq619gojJwgNlu5zxg61R9CaHfr6/85CAOyn70i0Q4J3Msyd+1HvLtrdjrfXw1AQ4r3JfwoM1ZF8eyzCllua9XEsJVoDJTY9S5//dJH4BoV5EzccnDcPxc45NrkexSMMl733otEhv48s7Odd2JKC7ONAanfEaaxKIvg2HqhKecQSYeKXef21dxBgQboN0w5DyAlpwhNdtcIUffAuXXNRKSEIbwcU4VeXIFOBN9B644BO8kJ1bpDnVASDlkFeKxl9ECcB0oQmXjmz8N45k7u8LNdGQAs0RbGQfnGNrXg1zW+3Roto9yA5zo1AI+pvB48atrcXokyAt3q3R+o37a8pDAITdN6zqapqTj5ZUl4BsIynxelaw9hICGd7wpDqVSddLIMQi4CAUfUxvc2DGkQXCsnH7uh0zul85MWuG7Zld7f5kK0Xs2luSwg7WyP5yrNPijF3aBKDAycJYndR+wTHgnXFveVn9D5R09oUZqP0jnM0VfWo/Tbs3q0h7+aHHJcSnbquw7+xCePCb4jTCWPUQqLWN8b5hfpTuH6jciBBUYCPfwJdpmcG2Lcy1q5LyELhsPl27CwcPPllmGrW9E7nWu
 5mEeKny0
 xQNJhFgplPqhBnn9gQ5ba/lJVaI88LpSSz2mdyzjx7jw9hJkBToDLfq3LNJh9QdbfT893YmBFFXiA0f1LtRhS8wEL1pWSsZFnJrc6u0ZPGD5gm/s7TN/IHMDYe6Vmyw6WobvM06cYOJQZWCDC8Mz5P9kZAeLkWWsA9X5HAU1/O7dbh9tIVHzIIc2r84eq4afmfVnmr6/MiBuwrwaUPd/sg0NRrpfJvAjxXt6XXW4malyP5vwoyTfGTuE3yoyw3U1XzoJ3+GrxZrWLlUVgaD/iKAc4TyeyEl14YRAP8ZvMNnpTdlYgmTcKnnP361RLn0x/sMeHxp6FdqbAYidO/Y9DaBUaJMo6mZwV7KnQBPZdsE5NwdQHXZPNfRhTTAYN2VcnmrRd1f/MiU0WOavVKFGqnBtZzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git a8455260b2e9c024d1872ac1c094793d55a7e537

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 39ac5b97aa3a..901dfd2484e1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -83,6 +83,10 @@ struct sched_gate_list {
 	s64 cycle_time;
 	s64 cycle_time_extension;
 	s64 base_time;
+	/* min(cycle_time, sum of intervals): the software schedule restarts
+	 * the list after the last entry even when cycle_time is not up yet.
+	 */
+	s64 period;
 };
 
 struct taprio_sched {
@@ -871,12 +875,13 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 }
 
 static bool should_restart_cycle(const struct sched_gate_list *oper,
-				 const struct sched_entry *entry)
+				 const struct sched_entry *entry,
+				 ktime_t end_time)
 {
 	if (list_is_last(&entry->list, &oper->entries))
 		return true;
 
-	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
+	if (ktime_compare(end_time, oper->cycle_end_time) == 0)
 		return true;
 
 	return false;
@@ -925,8 +930,9 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
-	int tc;
+	ktime_t end_time, next_start, now;
+	int budget, tc;
+	s64 behind;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -952,23 +958,49 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		goto first_run;
 	}
 
-	if (should_restart_cycle(oper, entry)) {
-		next = list_first_entry(&oper->entries, struct sched_entry,
-					list);
-		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
-						    oper->cycle_time);
-	} else {
-		next = list_next_entry(entry, list);
+	now = hrtimer_cb_get_time(timer);
+	end_time = entry->end_time;
+	behind = ktime_sub(now, end_time);
+
+	/* Behind, e.g. delayed timer or stepped clock: skip whole periods
+	 * arithmetically and walk at most one more to the entry covering
+	 * now, instead of replaying the backlog one expiry at a time. The
+	 * cap bounds the walk; a leftover is picked up by the next expiry.
+	 */
+	if (unlikely(behind >= oper->period)) {
+		s64 jump = div64_s64(behind, oper->period) * oper->period;
+
+		end_time = ktime_add_ns(end_time, jump);
+		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time, jump);
 	}
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+	budget = 2 * oper->num_entries;
+	do {
+		if (should_restart_cycle(oper, entry, end_time)) {
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+							    oper->period);
+		} else {
+			next = list_next_entry(entry, list);
+		}
+
+		next_start = end_time;
+		end_time = ktime_add_ns(next_start, next->interval);
+		end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+		entry = next;
+	} while (unlikely(ktime_compare(end_time, now) <= 0) && budget--);
 
+	/* next can be the entry already published as q->current_entry (a
+	 * single-entry schedule, or a catch-up of whole periods), so the
+	 * close times and budgets below are rewritten in place while
+	 * taprio_dequeue_from_txq() may be reading them.
+	 */
 	for (tc = 0; tc < num_tc; tc++) {
 		if (next->gate_duration[tc] == oper->cycle_time)
 			next->gate_close_time[tc] = KTIME_MAX;
 		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
+			next->gate_close_time[tc] = ktime_add_ns(next_start,
 								 next->gate_duration[tc]);
 	}
 
@@ -1130,6 +1162,8 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
 				 struct netlink_ext_ack *extack)
 {
+	struct sched_entry *entry;
+	ktime_t cycle = 0;
 	int err = 0;
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
@@ -1152,13 +1186,10 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 	if (err < 0)
 		return err;
 
-	if (!new->cycle_time) {
-		struct sched_entry *entry;
-		ktime_t cycle = 0;
-
-		list_for_each_entry(entry, &new->entries, list)
-			cycle = ktime_add_ns(cycle, entry->interval);
+	list_for_each_entry(entry, &new->entries, list)
+		cycle = ktime_add_ns(cycle, entry->interval);
 
+	if (!new->cycle_time) {
 		if (cycle < 0 || cycle > INT_MAX) {
 			NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
 			return -EINVAL;
@@ -1172,6 +1203,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		return -EINVAL;
 	}
 
+	new->period = min(new->cycle_time, cycle);
 	taprio_calculate_gate_durations(q, new);
 
 	return 0;

