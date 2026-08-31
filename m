Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B03BC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4AD76B009F; Mon, 31 Aug 2026 04:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21976B00A0; Mon, 31 Aug 2026 04:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11336B00A1; Mon, 31 Aug 2026 04:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE2E6B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:42:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D8771A041B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:42:53 +0000 (UTC)
X-FDA: 85160924226.04.00D134B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf29.hostedemail.com (Postfix) with ESMTP id 87E86120006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:42:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NuL98E4D;
	spf=pass (imf29.hostedemail.com: domain of junjie.cao@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=junjie.cao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788165771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XulvYGT1XgPT2hqf7DXRX/4cLPs0Snuf01uZUlrmk8s=;
	b=pBKK6jmF6ryXaf1NlFWv3iYEuvgFk4O6N0gYllmMRr1RzeEL8J9Z6+j0zO2a7NXcX1i3RJ
	1jKkzjsA1XBlFBMKG+q46qfUAb1o9S+FWcWi6z74bCO58nvo7mFKZHoHc9YeQAIV7FXfLS
	+jXT4fzMkcEgM80Pa/94gGgodRnV8TE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788165771;
	b=E63EYguzOYKZiRuUeL0/r7fOMdkecpfc/I8TBn4qC2d2hBIUnenOB1wrrXkZQdxFptSndC
	XO6R73q7T08kC5lgEVwsMuk0yTHZpVTrWX87gLa4nyLpsDqfTZXdZMWbLHOe6W3wcxi0bp
	frAg1hS6ayYSdjL4i/qvW/Muni999U4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NuL98E4D;
	spf=pass (imf29.hostedemail.com: domain of junjie.cao@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=junjie.cao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788165771; x=1819701771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lHmdDF02yFT66UBYvYHsfNddxjkgE25gdJ6h30WIAHM=;
  b=NuL98E4DR9K7r+aTWFZgpme9hj5+K5/qOT243xeGqqzcRrFh+qAip2Eb
   BzQ9P5QrN4q1NqKLV0Rvb2qI+MijgJfww/4wu0GU6pklzl15zx4Kzy8Uc
   0CyiJ7gahXrVcMhbpPfdxcHIZQMP38GdIRVAFjVlnC66UEldAjlKfuyo3
   adl+vbopvygnUCX8beiZ/k7env1LpVBoanuOGH6KLYTwCrubSYphzI54P
   vXY8dzeO3K6XGFmEsJuV7Z6UlQXXwDPZeZuFXdv2QQA4vGygPHkO0FeZu
   yLTEUINjqUxWwlcZK+PTAUBj9qZBe3tp6WOBjHb/eOiyLTIAYf2fctRQ3
   A==;
X-CSE-ConnectionGUID: 5aTUbFyjRmKTcN4XUl2rVQ==
X-CSE-MsgGUID: CA16HNSFSB2ZPHpXq5R+wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="88421093"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="88421093"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:42:10 -0700
X-CSE-ConnectionGUID: 6+hsm4tSSCiMxbAeVSbiJA==
X-CSE-MsgGUID: vBtDvO+CTbiJvfGMfKdOUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="269326248"
Received: from junjie-desk-dev.bj.intel.com (HELO junjie-desk-dev.tail2c02c1.ts.net) ([10.238.152.71])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:42:05 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com
Cc: akpm@linux-foundation.org,
	dvyukov@google.com,
	elver@google.com,
	glider@google.com,
	jannh@google.com,
	kasan-dev@googlegroups.com,
	liam.howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	netdev@vger.kernel.org,
	pfalcato@suse.de,
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
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in __mmap_complete
Date: Mon, 31 Aug 2026 16:41:59 +0800
Message-ID: <20260831084159.410474-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6a934778.4d659fcc.734b4.002f.GAE@google.com>
References: <6a934778.4d659fcc.734b4.002f.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u3zr9xh9fo68qfons3hk7tj6gbi7ehup
X-Rspamd-Queue-Id: 87E86120006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788165770-682450
X-HE-Meta: U2FsdGVkX1/le7HarpprZ2h/grJig3pNeCRECGr1pNmScexehfBvwFbdLb2MQYIRHdCagBcfbBKnnJQLLoQ1YT6XCIlBR3Mmo6+wUZXWEjmYbMdOCmOXlWU/QktYMq0bTZEDadudtwKBXZbJMX72dckNAZQ7SfFQUMO1oDXFkYI3Lrrny/uqyI+4+l58hcMq9WhLr70nn8SIGrmwqLRVSbICXyC2hRmoz1tlwtULkcjZcnaeeZS4TrFQCuAFw81dK2sQnxQ1GjYMq/Yu4AQKIU+ExK2AzTUQ83AmB7Y1XKojp07/wyQXTRDKJvMict3PKkcdMFy5JX4+0xubpiO1heN2o4ds4MwZYJYpSp4mQ3ct+XD1VVxtORGmY3GqUhVwcx+G8supnvL73hSkINwmg2MwSCsG9DWA+YygIK4S7vUuKSrGOiUNxkxOaCLCyZhcNm7dU3ZVAsDoBnHJHxJtApQbHUyRWeWvVTZVsH3DwyWG5Oa6ExEDozWZAlAjI0aSfNOl6KWvGcMP4c4wmgf1ZP4Pf+NcqcA+fGvgSh7gpCQI0CmIYnmCQg2fYhIlB4f6EYgaei/DiPsmxhG/c8LZa7f+7Vtvj5Qy5Moxn8MEYdtpVXvjJlROairBTd3aLMDcOmqbB6e4SDA3KczFXDHrQpfno41w35gysNDOAudoRTekYBHz+B1KM91Dj2a3CBKQ3t1646q63bTHvDfWYhdigEMj4zbXXttzINh2jSXIco/e/A78F5AvEpNosmZzk/UpImfHIOrOMNKX4kz1ge8/zPHa7jA92sxb2sr5lK+oSljwKhjs760tDaKUikxdANsPF3bSqrFhmx5vfeD4EA3GUM2cWW47j7+504IOH0Uux1X0SjBrZ7ikSaPfA7i79avAgfbQ88K30uneMRjuceZoErfBDrkSJTRxME01qQGiqQo++umTBVUzD81l+LSh/QFAGHIINv7egg+HzsxG/HF
 Rddgk5tk
 AbIBlRKlbz9ExJPeldJ6DAlp9Q6uNeMel+aAgGAYFuJqnfo/7K4pGSSZr1r8O7hVd8igXkb/iPinSZ2d1JmXZKa3r8IZE0xdWOlaoHJpRUB248q7IHmVLHA5fMrFsKFRdA28/p9OUMivaPjbe6uO0+YYWjsmyTfMA26GQqSRskuj3GpjiHn/qK24hQFr4o7f4OiIDpwlBL+oqWXYjZCZ0HPVgZJht0aKBF/urVdXl+Mh1b0VpNM7ioHanaY9ve2/7EYmsGfKBqY+WTLraahuIYE9mOkhJ0Vzp4M5berQqqzQ+Bgsl66szEVyCLXTwKTEYHPx1Ep+Ei1KUz6orQ2qimJxw/6l/54lyYOvlDBc+dTFidvoK4UIjTLd4/MMbYSKq2vcz84urFwbgELg0dGoUYjtkZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git 1bb784eb6e38fd73143f021608e4ef3095d0c0d7

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

