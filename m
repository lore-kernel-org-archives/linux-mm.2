Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12172C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6C16B009D; Mon, 31 Aug 2026 21:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D9D6B009E; Mon, 31 Aug 2026 21:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D3F6B009F; Mon, 31 Aug 2026 21:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC1C66B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:43:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BF781602B9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:43:05 +0000 (UTC)
X-FDA: 85163495130.07.B3F1819
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf04.hostedemail.com (Postfix) with ESMTP id A370640005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:43:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CPrw+X8a;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=junjie.cao@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788226983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDED742WU6dFLUsV6ZuIQG7q2j3YSt4PAsv7+Cv64UU=;
	b=yPp6IPhhqBW6cOVO3MH73EvxXaZ3PTlZvumAGsPaNmquOvLXOO4YeCUzEjO1mtE3N9n5jJ
	ToFFZsMc9+xaANhBMtgnRn7xv0SziRVsBw3whp/UeQToj2Xg2uBuMjo0t+DSUXxcm7hq00
	5JHcoEfD1QPkNNr+qnmhOJShEdlPzMM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788226983;
	b=YurTr/HnRx5plCGvKkxU+A9i5HF0C31i8IPA1QfLZEXiDZncWGpFFIhTUGgKfKmmD0tkdW
	O/lhM3VEiIjGnLOOr+sGRUs1eVBrGVeZ4YOJzuNFijW04RaHOSnDevxOmdOFXrthvOsHBO
	gqgsIjrM2mvYvH5QNiRhSANwu+NUzvM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CPrw+X8a;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=junjie.cao@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788226983; x=1819762983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RtYKfymBNp9KvWTyDmEZgzY+yJgX+7+dkVBS2iKKpbg=;
  b=CPrw+X8aKKEOMiSlXHWGPV1GTscKu/pFZCTN86e5gA47i/MUMewHJpO8
   qJLZP19tsSr0bGhCqKrtkdl5DrX4o6v24+HANq46xrD3FKMlV2PDiFC5k
   8V52bwUO6XKXmhVNrnuF3zpj8iPyHMmzmK7ZoUdjXgl+8NNF7gZ0TvxVW
   pWXTd3WcvxJYJAMw8l8qEl0UgQC6Jv1cKH9Qk2UKXLskscz7RGITLs1mP
   uexbdkLejZKF5UlqYr1JhMSbkt97nrUFA+C+tzVpYkB5SzWu15uz0zI5H
   Wel+h7AVTKUMUjeC9macYAQhmueC3qF7C8Z6ZN+H4symwPjnpF9n+4IvN
   w==;
X-CSE-ConnectionGUID: lb9xC/pBQq2ptQb8aOKG/Q==
X-CSE-MsgGUID: D8+ss5PlS0S89J5tGomF0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="88519586"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="88519586"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 18:43:01 -0700
X-CSE-ConnectionGUID: wUvbxqnkQwyeT8xTBiDrwQ==
X-CSE-MsgGUID: UPdEJpoEToqzE47lqLdClg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="268998276"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 18:42:51 -0700
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
Date: Tue,  1 Sep 2026 09:42:42 +0800
Message-ID: <20260901014242.417011-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6945a977.a70a0220.207337.011c.GAE@google.com>
References: <6945a977.a70a0220.207337.011c.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A370640005
X-Stat-Signature: 95h5h73h8s6zmrko89qwasgyismmwzyn
X-Rspam-User: 
X-HE-Tag: 1788226982-506457
X-HE-Meta: U2FsdGVkX1+fbm8UCwRICpimiyzUuDYOy2ARzIe7LPT78SqbdgROJHKJA/UAyPKIJglP6XZPPUqGbNAch2kdLFZkwxKAf6pi0o/EsImapkHPpbegksuKAsjtSsKszWuDcIlk9uPpQjZoUlwCPmAYwrDFjVkh6XUSeGJaUy8gDgHOAYLTF9m84eC/rZ22jTkAK2dsHqPer1Gmd5dIVzO5+XAgtLZL2hcb72Iow+OLFCDqxJG0vZKWGvQUlLFt+IEyH1NO6HhW4V8QGrHmTjIgM0Ja8tW2p50Pj9AUWw5PkGcOZjZCeRQj1/r6vAKXZ5lR38hvFCPXYDqx+sxF1RwT51Ac5XWT0on6F3F335Cld5+xwoQmO8dS79nRPAaFgCG1mKb7pc+TPro/dOk5gHJUwaUUSEbuULRyofqlh2VUgzAfj5639JZJuETrhv+K9fHU7ZCojGshoiQWPksEH/MaAxhDFiECFqGGJvloaFuqcw88tRC8UZZ8ghPpEo4BEYqGv1kPP8dDPAPC/X/PEXIXRuWgo0z/kgopCeNHL/nkrZO0RowSKZzWRjO/TtvW8g1r3x3GhmJitl/lRSKuQaXYEZI9rlFCjmvVCq8Hm+WYOB0HM+xUw09kqPkz53n85ElOyS4KcKISqqbn1bS82yoKSg2lMIBmHZmzHMMS4h3c7lmWN6BVYqgJ3YN+TYLC/bm/0N+7WCUpvETvrd+T3LzbHjb+ZznHWHFSYlt8H0JhLxuTplv/KfM9+OINXM2frffLcear1szIa/k/ahC5gAxihDEiZEA0QxGxvAff3apyGnubH6y30UvqntUXZU0xix2cMbTUGdPuE6mGX6Jnvfb2lg307cV0139j1FJY4I2gJUAyd2QU3tocgIlByfnqQfcz68n26G+aosgCxSOu0/HsEEcMo2DeQef8TgA16uN25hG0OhM7BEZ8OI2WwS3F3vXrlsh2xCw3HWfjia0qH/Y
 rXj0Vlbi
 bm2gKxRjP7LsTNZtwuSQSD6X21WlFubPUOA/MeBL9giJ0Rq8LBZ3baFAv6OOJK8RMs3Qrj3pr/GiRcMWc0nTnaVY2ByxLZssguQcnmoUCKGZ6mvfyiCAm5E+1dBMCEb5hq29lAnQJHcQAA5N0P9Kpgi7k8vhtUsF2MNfm8DMP7f/vC3Y1HxPngW1KWszm1xdcp/JzfGy4MY54G193vhCGWcZix7Z2KlCTeCdr0Bz70XctdTnQlNEVosU9FqdHa5yMl+uWLBQKVtX+nIGR/rdD1cXkgpUL4NLM7Zd8Ms6pujknzovQKxH0PYVG3U7ugVXziCXgwwNIbeHHRwJOU3MDHxOIFG5oIVzDqNvMGxBxAqSrsySo7xm0FxW1AMaWhhLYXbx9hSWPPnHIAC2yK7uxAD0scw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git abdf623ddb75b24659018d3952d8f61937306ae5

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

