Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E87A8C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A16C6B009F; Mon, 31 Aug 2026 21:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378B06B00A0; Mon, 31 Aug 2026 21:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6456B00A1; Mon, 31 Aug 2026 21:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2FEB6B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:43:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFB5180320
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:43:23 +0000 (UTC)
X-FDA: 85163495886.02.4F59428
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD65E1C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:43:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S0AJrrZR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=junjie.cao@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788227001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDED742WU6dFLUsV6ZuIQG7q2j3YSt4PAsv7+Cv64UU=;
	b=KrRnEz7/3NU3VfysvvDsOHlgtuFVyGYfm5YroyvWZe/nvj9WwhpykejPpZPVeQ+IoPfYNp
	gCEvbufl2k0HUN9sPWRy5FrF12WKbH4OWOCRHPSno6jwi6C+kEg+R1kZIVxdU+JRpWedvN
	2Z6GDi7iz/leIGP+wK7/pBmwjYbirFo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S0AJrrZR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=junjie.cao@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788227001;
	b=nmmcYhJVNoSzR/qd+8pRZrPL9IywpBQvNUyXfjqpGbuAtRfyqCOe2xLpC7zEgB/YEC9Xnv
	MkQx8ZaApIgnhq1p49Q9EJZW8cPlC0ilpxhh5/Ggd1LcoS/vh4GChHid9MkYx9K6eTONkm
	98z5+qOtReGPc9imu8lWPNtkm0NZJpo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788227001; x=1819763001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RtYKfymBNp9KvWTyDmEZgzY+yJgX+7+dkVBS2iKKpbg=;
  b=S0AJrrZRMgnNa9eYQNem3xkfs/L3xmkiheIiq5AAf0Ug9hAqVhtyJ3xo
   vNCNswl0HkwjHsJLJ+lQnaOMGsWgoahkYLfeLFzDGSIo+wVcFDG3n6NXP
   AQUvzUSHN6klasF9vLWwuBdsMwwWFtU2n5lSetFyWOCmZKdvgJ8HDWQId
   iRIHY2br6fQmG1JvJshQ80QX5EOSagPk86XWq2ZNrhK3KbBtEDSXW/zqv
   fraf9XWAMEiy8oKmJHW4sMnoXuZg7jNxLMHsrVnHhQ6Vjof5vT67W0jQJ
   QDg4WAwkdVUXeE5KOyBjNgV43kbxnPtNbWLoclSvDuPwqGtmQFsWS6afd
   A==;
X-CSE-ConnectionGUID: 6xrciyTvRT+KAeYooaj9GA==
X-CSE-MsgGUID: 48MkpbmLSxWLb8zj6oLGTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="106164305"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="106164305"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 18:43:19 -0700
X-CSE-ConnectionGUID: qBb9qxWMQLydzmJilke+1g==
X-CSE-MsgGUID: JA2nDKJhT02Nus7N07a2Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="273136121"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 18:43:11 -0700
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
Date: Tue,  1 Sep 2026 09:43:03 +0800
Message-ID: <20260901014303.417027-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6887ebf4.a00a0220.b12ec.00ae.GAE@google.com>
References: <6887ebf4.a00a0220.b12ec.00ae.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wyaddemqskwwmh6efkqfqdmx454f7ubp
X-Rspamd-Queue-Id: DD65E1C0007
X-HE-Tag: 1788227000-802004
X-HE-Meta: U2FsdGVkX190LmfvtQUWpBx21r1IRlh8vm0RC1PQB2bIn5rkW8jQDhPim9UC7zABwojcOw9L7jH0q2wLN8RDYYx+x1YAmGsYMWmaBAkBs+oi2rw/nXMnC3hilkU/r8qApxoZOD9bQBhSlhGnmLKLnnXYy5t1HBlxntiejDXrIHQ5/t30/Vbsrem2aRcNnLQyE+u42StvxNGn6ECW5KievIQ4+nkB3eVZsy2Uo595gllQ4IUph0VqT/2oB2tbF54ydYoLcUPScJnGYFDCBLrDn+6ZTyFaXdPQZBN7Z342mLFGAh4ZFk0xFIGAOeW+Fll/Ky3BYsC6vX+mibsHsgPp7vsW2y1okDUaXKtTrqhKmF9xM/fTiRraoHbuVQeWYMkxaRBNNbHm5Dn9mj1Z/IuxeXLKPuK/4/cog7ftn05zi6g9SUmjkG5AQJ53us+ia2B4qkZXHg+9QYK8gIgmSgTIJxuXsb/gSKsepQNsHtP6kghbsZ2W1rnPPn8F4cWpqyiedbf3UREWVMHPYXFhZoD+dn1V+uFPT7LAIh+zVryuTHGUqpwNQ3cJOAPWHW+LMoYkHfuYnDZJtFZL6gYA62RMGvniSwQgO9kg5GjNpjy0RbUVMJnY9WbYSO+mubs20Ym6Tlr+mDyTiRg/TEjn8r9sIAIhvq8ObbKHPcs60M1+hgNAazfpVgPyTodsviF95j3v4losai83kyG/RnTE9yDHJWSmJHCcbj7HAv1tA92zUjG6rBI8Yv5yz3BiErREti3fcvPWtU/UGgQ7fQtxZ4EAAnTdHFaZhXqAl04V/gcEj8ov9VrZLnTI6kWAviUUnsBDFpB67LfJaMwKvE/lfliAh1/jF6z4SwcqISjdqMhAAWoPhew1sPCJaShP6wt1Jb++o2kqJh3QqXVArfXA2bq6GKqSySVtILMIaJwz0rFcgRVLlSzQ0j8oSFzeyhNicdPU9cqgLkT1vP5R2md3eUB
 xXFVTSL0
 PsQuFbz7brL8Roxupqm9FNcIhvCcIeq5JWYLPvmk4BZ0eUrqSUohtp4pa/ywoeusUfqPotmIvlyM0Jrshk8FBoqidwQn0Nu1dt3CwV1+gDvo/KyWMONafDP2GMQbDiUg3cPBRXi1T9CULCwfjtnt4u5B6BWZ3KVHkVncDaGgu81O1szq9aO8cJcE01a6h/OLjVaDTTcLkTtvHRN+CJ3PnQU20Ajh6WSAxar0ykRkvhgxLnHnOMPGXxO9b5ZiLnoz1s6ILzn2JgkmKaMAWmno7aCoAOka9ICwqx2suRZ9+ODBIvRGBay/kPibxbXDdvG63tabiiKvQkNkhkc3bvTY6PzkV5CKcJs7ZUhgN/EtRk2laR3mX4+InJL20bDnzSLaYIEduDx/bSz7j2GJIrY7kAeJ6ZQ==
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

