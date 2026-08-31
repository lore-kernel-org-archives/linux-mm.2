Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E4BC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645936B0092; Mon, 31 Aug 2026 04:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BDF6B0095; Mon, 31 Aug 2026 04:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B726B009F; Mon, 31 Aug 2026 04:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29A0D6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:42:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 896DBC03E1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:42:36 +0000 (UTC)
X-FDA: 85160923512.07.4A33AA2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3837880006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:42:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HF5smGEZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of junjie.cao@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=junjie.cao@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788165754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bG18/UuJ8sPW01vYMzFFFIcN9AfCWu3aTjE90c0NCI=;
	b=UZPjH02arEeAj9LpWflOzCASpTJjeGalyS1y8YK2feo3NMemyoMAzWfprJL+nyV6E6dcEP
	/ItXDc71bA1N3G2tL1gzaKVmIn18E0nn+rz2RFQ1CYBB8EOsEIrEFJaGXWJp5PxRD4HvpS
	2zLnhYaywK6ffDK7vF1kXqgxyxpdyTY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HF5smGEZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of junjie.cao@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=junjie.cao@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788165754;
	b=CbGIH5gvyoYr/r3vXWZJbwieI+Vl+gL4/loHg8ys0nzWgPq4/MQ+Tzbu5eYPvF9chGaLVY
	+GBo1tYtO/TyZP/hbkTScRljdxrEPSSTVd5wpNBFqxn9FD3/hBng7l8paLecTOTKmupfzx
	0cHIVKoi1L5GFKE3uaoyaMyx9Uh7ukI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788165754; x=1819701754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AnnLzZQASW3ffm7HTAuT/jmzPEia7UpYkcE3pF7Rkko=;
  b=HF5smGEZjIHWZZBvEmo6jYnTyMtkxyG9kWmNE27JIdPgVRcMC16dB7tN
   NLTNsis00p4UgA054TFpuRDMvfohT3/4jxaVkQUtxrmCV/WKsE0B7GHuz
   mOHhoZbNF0aFcXK6Wn+ywkNe/C+82euKfXg9r8YMQCis9W3SYHt8vWe7D
   Ta3/k1cFb3oWKqrC+e+oBwbx2U6uxWnqIUas4keW0iiib/11EGIJr8+u0
   L2HMBbY5wSRv8t2d7oaFcIdcA6l1GIJlq8it0A09xdsVx3ZtTOn6ZND6C
   3TMvfa62OlGrbOsfLyI3SbVnDeF7UEykr7mTQc2o6R96xZr/8GNsY9URn
   Q==;
X-CSE-ConnectionGUID: 2N3SqdSlTCmDs+1nLrPm2Q==
X-CSE-MsgGUID: +s9qMvqhSTKX58pHCpgh1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="88420964"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="88420964"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:41:43 -0700
X-CSE-ConnectionGUID: G0af2RCzRaqI7TbIqJ/Gmg==
X-CSE-MsgGUID: +StTUGGuSV+FSzs8rhOhVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="269326210"
Received: from junjie-desk-dev.bj.intel.com (HELO junjie-desk-dev.tail2c02c1.ts.net) ([10.238.152.71])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:41:37 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: syzbot+2642f347f7309b4880dc@syzkaller.appspotmail.com
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	mhocko@suse.com,
	muchun.song@linux.dev,
	netdev@vger.kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	hdanton@sina.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	vinicius.gomes@intel.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in exit_to_user_mode_loop
Date: Mon, 31 Aug 2026 16:41:31 +0800
Message-ID: <20260831084131.410457-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6887ebf4.a00a0220.b12ec.00ae.GAE@google.com>
References: <6887ebf4.a00a0220.b12ec.00ae.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3837880006
X-Stat-Signature: p116fzqiekfnsyd4whdo9bwtood7ik1f
X-Rspam-User: 
X-HE-Tag: 1788165753-202352
X-HE-Meta: U2FsdGVkX19zgJvwwo138XIkuqAmJ/nxeh/ZRZD5iXotX+If13C/pcwF+GUU8MwTcN8qYaaHumbJEa6omiZGPILBxBIzkJQnioYNTwnF2s2/KU+uflvQSA6vmY+8zJBDjETSSAlvZZ/gp7d7ODS+BDPO52YlUQOyvPDNmF4vW4P+i8jq5frhf8hDJ73cjR3Fqvso2C4cZth3sany3RdAjVSBOTjtovVhi9jQvMxqrqeurKByJiw5BuB/dHepAWwoqf0Z/HYU4gQD0Xy5clhCK2BScUKTIplBwVs0NRyQgzu9ESAuQXbzZasLpn0yd/L+vy+CKmWl39+C5+ewpFqwUEK4WpTu2EipnHbSbY5z3KiV7Pd2V4OQYWsEZGxm1EcDdw3Tz/quI+aqn5Eea6KHJtc0UQr9iAEcVJ8djSc4IyCJVH9EeZVwuGk/X3okX6ZM+MwvHhQ9j1ucDS+SmrWojRX0eR4yxOivz+9KbNpbM54QXJeke7vae2fcuReeHg6AKmz+PSO8kmZD6gpbVRhJbywO2aZ8/IU6/w9J49W5TrTC0BAjN2GF60ziUuDs0zbSXR6Aj3wCS7C37KsWYFC9NKg3oJ2SmYxgSyJn5Fdv2l2sCojjo0OTzhuVR/W6uMyMblW0Wfg3Od/tZLBj/lQnFl8mX3P9lTN0TA5SCNTypeYKoDpJsr6VqWCEWRt6Zo4zdHUpCpSuwN30qEGABw3NbzJnh57ZBVvr0F1fmrsniif+HqgKBGjjPMMESCGUL/c+vM8Po9rm5s5LcQZ31BVt4OVGlDnkfWNNpuceRlMVPz3t2Y7sfpG2aHw1xpk9IQsx/VC76FJSfLVzY47/uUMbRbNsfVmP68cWy80BHNkDbRh7ngizxt81SBhFCQ+uf/K7FMo/T5hJfkEkbE3qhuWQURPNDb9kpN6MQw7O/JIT3cwsw/rlD85V6GjEQDvseDI531ICIoc8m4ZqM64dtNV
 LY62vII+
 X9Bb8Xj09d8DPzOo05M7vqBEnteKSf19CpXblDhzKT0ko8kRzkrdVM685IMqwdG3Sbs0X0KST4adR7PuH9YXucHiGdN4qxe3Up+YgPYvb60KV3dc0gZ4Y56Yp9xtvy5RgFR/SUFO/3a6/f1J6/6sedKScLWYPxxXrUlfGcCEcPAuSrvig1byjUcUMjqTWgFK1+BLJa7mY9HyRDsPEWOUrva36O5jOzbpcsKZUBCiU9IEFhbZFMGu2stfvKvrNfCjpYKxtsDewDyyDjNQg8rgGm77zcd89de4cYv+NED2zCyOA5h5s94oA2pf39PKlTZNXFn5+kN+BgZ8ieA8+tTdYQjysHeJTkcbepSDtrfjRQrijEsGPcS1U834SRiEF5P7tsPxN9Qsqk/q6wUa7eBi2smuL6Q==
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

