Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB3B2C624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73A26B0098; Mon, 31 Aug 2026 21:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24666B0099; Mon, 31 Aug 2026 21:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39DA6B009B; Mon, 31 Aug 2026 21:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B28BB6B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:41:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BBAE1A0120
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:41:41 +0000 (UTC)
X-FDA: 85163491602.11.B79CE79
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B7601C0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:41:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eUWOyVaB;
	spf=pass (imf21.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=junjie.cao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788226899;
	b=WEdwR3RPmsj3BlJnc2WhQsCxl1E5YNgb5IgL1PETsmqcBJSetirta2CUVk3nt+5zh1h/jV
	Xp8z1HIlWb3iGwNlfDwi7EYQa57JXDSrg3wLBzbpRZumSc34MX2egbzniQ8d/n+w9QLugx
	NcmHGcSQA1/YqUbdGSVozqgPANVr50Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eUWOyVaB;
	spf=pass (imf21.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=junjie.cao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788226899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDED742WU6dFLUsV6ZuIQG7q2j3YSt4PAsv7+Cv64UU=;
	b=jS1kBm6gtu/ocrSQGFUzrbCnYRPKln7ICl67jiRK0QlGA2YjQbSjJKE3TkuUsElSibqpop
	L0IWL/778NH75v/pTa7rBmq0INZsq5UslQhE5VxFeudNMevH0TpMLx1FvUDpUWv9/FlC7k
	jzE69KBtKJ0cMBNVtMQtmMM6kISLn28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788226898; x=1819762898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RtYKfymBNp9KvWTyDmEZgzY+yJgX+7+dkVBS2iKKpbg=;
  b=eUWOyVaBxeHOYj4vQhudXmOijy37Tejs0AyUoWvSGgaWXrtbqeIqZe91
   OB3V/dY0Ax2vT+/FGw4y8QDA7wJ0GQ5z0EPBKnSgZOQAxqq9mSwXF/wa5
   PwaAhxZh75+f+rggPfRVH/78omjDye97tTgrHpa2cGzwKIs8YFcjzz/3z
   xy7rMYE4Ln6ksRgp8cG+Tevv7rI6Meia0b4EcNeGrMOZVxhoHn42R2hZB
   780Uq64Vmm/VcrmWmEdZP4sF1+PdKdpkpWqKTmDr7sXallO+kbOMr/Rp/
   rOhl9SaaSoinTVXoVqOHbP0eEfu5Nqv/+fP5yiNLJKlvJRpxuDguCbODe
   g==;
X-CSE-ConnectionGUID: AxIvKAvMQgC7cfXhAOFebg==
X-CSE-MsgGUID: V7+2RrUISBey7vTUSQTY3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="106164227"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="106164227"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 18:41:37 -0700
X-CSE-ConnectionGUID: w0xN6VRxTLOv7Xs4WkDBiQ==
X-CSE-MsgGUID: pSVfuqpDQJ2jaJx/Lyc8zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="273136025"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 18:41:32 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com
Cc: gregkh@linuxfoundation.org,
	tj@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	akpm@linux-foundation.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	vinicius.gomes@intel.com
Subject: Re: [syzbot] [kernfs?] [mm?] INFO: rcu detected stall in kernfs_fop_open (7)
Date: Tue,  1 Sep 2026 09:41:17 +0800
Message-ID: <20260901014117.416981-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <68880766.050a0220.3cc461.000f.GAE@google.com>
References: <68880766.050a0220.3cc461.000f.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B7601C0002
X-Stat-Signature: mtrj68ipdc5hsgsmi3ubpfurymc1gdjb
X-HE-Tag: 1788226898-31354
X-HE-Meta: U2FsdGVkX19JADc3PsAQoCkAPE0aYMdAdNiWEnU2B0poNbfuV2WjvuZQ0Wgl8sx5h7FNElBi6V5wMQ6wZfgQ4AAdorj8+d9ZRwX4beSDdM7wmPx3KC2dQL5zzWBDsYXREuQvSfuzebx6PBVhUtnmbkdXDfxIhoWbay/NjFWDGTw4EJs+OX1WcoI+AuxEYtTfUoS9B/ha2MYHooSwPesFgajpP/dwYp29Hy/adzcsDIXMOX2Baw7YI+YI3Q+bDkUmmk6NxOZACqKGgsOrpwKt1Qw2JhCfLB/OXYv2qhb5X9jxiRatl5hvHh2e3Nrm5KujDIwc2MNVmXezit3nkEz0bDuD82esElwWP3rsRUPRGr1NRSKYCOdVeHbCKwd+4zSRRG30SYnCmGYRyv2uB2L/CP0KhuU4OPI0mwiWVMYjbLHcDtu5YrjOTwfJkjB5SQ9Rbtt/iE0orBrYwU8HIJ/pFlSnExE7u/MzJ2NU4EKD/zj/ejcgLMVacDUk13kSxC1ot7eGbjb0IUPfjL+3YFK2PYpKOnAIQ/ZKBmvXquNIwyebxXxsDJu4OeoiHdkWgFNs9woQFmV7xis4q/gOJ1okpYivIvP+yzqcoqKpVN2PQ2BGp1q7JH/OBYWSn78g1BD/fnG6S96reFTJ2x4C33Ohjxo359h4rjAcGNkrWbSoRh8f6EkwjiCE9QEpM87d7JYfz1fMnU4DbxaxRSEZTRuJMW7KpUcxr2FTXpNFDJsWXzXwpcht14CPwMay2Uip8Guo9ssBpYy5STCheRTQjS5O3VVRyiuI6bu4rRsbtqSquGD5LoWlUmYkxPA/K2wLj8cKL3hVIsOoBlFvzG8QdgySmemIbnsa68F9hK3lQVhqyPWrnaPl5s8s76EjX0ZNIcVIac2CizOR0EBHg49bGlKhJWr78Si1CWo6NDS4uExCsNhk4IXndEChkhRIGOlgohyvMBa4YuvKBY5+7I0lSnu
 HbX+C20Y
 ilLanzVoqUyM9uHeYBHnBkpuntwlVCkSRzD0K5l0ZEKTfgxKvindgkwTloEeFBvyP71EA+lJf4cbd6tGhTPqE73sww7gTaLajTyoQ4vfmEDp+W7AR43Fxw917NItl2Rz7Iw5Qq1UfbEKQu/YeMI63lidkOXR6bVQqfLnsJXILfUcz1QbW8GyhqMFdG+5UtHzdpJW/6R9l0cZBYpvNPjR/Vs+8miTURwKvp+ZHLiM6nFWS+w+I1PJSC3Fb/SmlFgu1bLS8/jNVEUYuvCIkYHnq6ndqTV/O8HGlbM7Iw56o7JB2iTWYKi7Jo5g3gz4GZ5UPX46FRiE+J9r1igFqt/0TVjTepfeC06exDKxNFTg+qVBcpMH9OmmSqHjRy3marJX7ga/O5rqWWbxWHouQeSNkt2z6hA==
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

