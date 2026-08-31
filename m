Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46915C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6496B008C; Mon, 31 Aug 2026 04:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7DFE6B009B; Mon, 31 Aug 2026 04:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6FA96B009D; Mon, 31 Aug 2026 04:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEC1F6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:41:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BF6514043C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:41:02 +0000 (UTC)
X-FDA: 85160919564.14.A55AB9A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf24.hostedemail.com (Postfix) with ESMTP id F3F68180003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:40:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DcBCrs8E;
	spf=pass (imf24.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=junjie.cao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788165660;
	b=mlKJuhz8tQnkLzd8UAsdwZPOJq4+xJ1zindUWkxD7MpTX9u8CyiljEjIdInD5Io2+jRGF+
	GXTm/io/tMbFSnKn68sEJacKg1NxhTLukqXys/F9CkS7vild9OsKVilc9zUANHkRVNSZOW
	2cH45l46a95T/PQDWRlxFxghcBIM4s8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788165660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bG18/UuJ8sPW01vYMzFFFIcN9AfCWu3aTjE90c0NCI=;
	b=SyAGU0DR1WLYUBRATrVOp1/zdlPvuQgO5CsBs8rsdiqSUXsycpR6qRP+XoFPlSvnsWhHML
	G6cdExkQqJioDYoV+2jwsN4dq8D5BP0sb1gO6zeGBKBILZAFngAcW4KZvFq3SXBCKBV4LL
	mLZzcsy++lPXU9HIqvM1A6gLLUQ3diA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DcBCrs8E;
	spf=pass (imf24.hostedemail.com: domain of junjie.cao@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=junjie.cao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788165659; x=1819701659;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AnnLzZQASW3ffm7HTAuT/jmzPEia7UpYkcE3pF7Rkko=;
  b=DcBCrs8EVvmhHZtvlPgdbz5ZzX6uVbsdryidSa+9uSkpgXlBfvr9ifEa
   UsecYlVuVckELDvZk8XIOJTuTmMZHAn/zKmgHoXw9TwXn1YR3/1hzBed5
   OUjPCky6h/+M3ms/6QWB4bGbdR17F2O3iEJYUcgydRV+DPBSC9PpnfH4T
   CGNQgDbfsNhUuUU3SwzyuG550dga+xePstf/rXAZflgUOurADc6X1p5xU
   pwjydwDNY/1RN7G85E8O+4rX54HKig2vjqR21Rxag4lGkDsifoSE63E6u
   14r0jVAdk1eUk2yvSt8U5cBhtWw5DdF2B5GhSMH/LVGeV82kIixCMxZ/A
   g==;
X-CSE-ConnectionGUID: gyuGFT6JSQm/VwJUY3rBtA==
X-CSE-MsgGUID: xSvMFXrfQTCPBJiZPu4J4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="92377411"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="92377411"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:40:58 -0700
X-CSE-ConnectionGUID: H6RuDwXiQ8W7wzUiQmJoqg==
X-CSE-MsgGUID: S7Snd/52RUep+iJmvdBldg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="274008905"
Received: from junjie-desk-dev.bj.intel.com (HELO junjie-desk-dev.tail2c02c1.ts.net) ([10.238.152.71])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:40:54 -0700
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
Date: Mon, 31 Aug 2026 16:40:48 +0800
Message-ID: <20260831084048.410424-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <68880766.050a0220.3cc461.000f.GAE@google.com>
References: <68880766.050a0220.3cc461.000f.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F3F68180003
X-Stat-Signature: qhduma5uyhk9enoujxod7bx1o4q53yq9
X-HE-Tag: 1788165658-242437
X-HE-Meta: U2FsdGVkX1+7WK+yl/Mym4+S7JFuO+FEGUjSR/+p75SJ3/MvDH5L8m3MdxgCNTjE9A+eoY+r+fCXbVAId+be3m+ttEwaanu6ioRLwYBdENwFXKCstNfJKgfowNqkGzNgoLpqw44ByJ9i+d7qdll0cZ/quNFWZxVyk+YD1MmWYqL8/4B4IOP0Ce0AsvnG9wuqU3omZ8t8mnPXsgsaAd8DjPvF1AK2TXEKRb/eHQ2xHzuhktQdY+83nIl3xfQCnMHkkmdlMM97XjYU/EjYkjBFSzDpy4aIhd22vjPweEloOD2LhrrtGtLHC5hLb/bLfUqIYI3UOp3lchmo7fxedkOwP5mZJ7oAOYrNs6kc+rNViQ6fAfOpvkAwreKM9cFdxeSVyeROaMApuVg9bS9Bz4ZKX+Q/S3sGwd2D1Ydk1WLV4qZBMdBg1zTWwOrfpKK85+U9zd61/s8OrdIDI/7Fl/Gbb3vU3agnyLiLNZz4atBmAdZJwbLfIF6jfr+ueVffCWzRWDpcKGfimbfDRAEeFG5EEU0G60CBqLgyw6cmWlKI9Sv0ca789nTciTJZzjUCHiWkwgXpZFToeSWS4xj8ZKUFfFf46TFdxTTCzbY/YWJPySHde50veaXK7vAiZnnkiMRDOzaoHX/Z/by1sowqVcZkLU/WmFLCzK75kYkbhIi9vq23C98ZQCYPRc8n4bst0x36RKrCIHLS8AVNAKVCst9FnB558TT2zF1eJuXU4Q3wl4HU9jKr2U81ZDVZ7T6uzbq72eAlkTqdVgbHmlA+tBzlcCVC9Cwrhab6fNpQuzLl+Ut/c75sJu7sdnIA9DRd3Sha9w49BGbCeD9xVFsoi+GJ4QQWSZ8k5uWvDwjIxRBrW8FER4Ye1c7TRv2+9Ey8QlxxTABl5kswgg0Cy6dEsB9Zpues7o4xxxBiceWYUJQLc5OJzojCHHz7pyScOY3bAbW9GR2jutCdaHqdDFJuXAh
 DKV8ANky
 2t8JNus6Ov99diVkUjBcJ9Y2mF+3tYhycMENhyGqVIIjMJ2/hDSN6uzl78GH4/c2dw+k/Y7uChSbRr5ltqRWianFL4VzKCzz7UV6j3n0JVU8bb3uAgwtr7LWJbAHr3QsHDCT29ogjlnPZkcItTe0FIj+r4MEHyP/64r8MdKImOl2dR0cbqkyUEpoUHkJRtfpaQE3HeTDxgxn4+1Cj5hhr/rJVi7leM0T7bE76qTbB2w7MmbWDyXhq/KrsTIZr9aTFRzzaY62kRbrdArAXXiJ62BQf1XzeTFzbuQQOUJB6t8Db2298sOaAoifwrjEB9ZngcB0l+eDddH7sGlhJRkSxZEdXnu1Ro5JAtjmEUROPus6Krc5cUER3Qdbov7QARxth3YJBapIVlj4aK4vUr7yZ7zbzsg==
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

