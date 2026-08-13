Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B5BBC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C616B0374; Wed, 12 Aug 2026 23:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923B36B0375; Wed, 12 Aug 2026 23:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8148E6B0376; Wed, 12 Aug 2026 23:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 606316B0374
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:26:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4488A04F9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:26:54 +0000 (UTC)
X-FDA: 85094809548.21.405D328
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id AE7FB1C0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:26:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1ADqhLp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786591613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KIhs0hpYw6CMgRl+G6nqKrAdx8GUUFyok/Fu+OSrVAg=;
	b=YhLKvMTsKMqHSie3MerHnyfu4fXGUEEIYOx3uH+Af4N4jdjLC6BuoU3mn8zwlpit6lFvPN
	AcgbEIvHWrggNQ/MH6xLUrVBIMXUNiB5ttKKMQd8IBtIQ+ZX72QLemgVN5VOy3JPWUmDhL
	iqqi3VbO/4tXKpWTzFEdVVDuUynCgGc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1ADqhLp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786591613;
	b=TXgJOYfbnqK8v+/z+vPmbRrRdZ9jzHm+Ax24o7WQWP5La+Fmr67NHQbO4GPXCN8d+5rghM
	YpDf7PruV8zTppdjy/JXrbezbl6Gbqhk8ngL1AFmaoTLtEzQgGTfXyO10PLysfg1g3WjqC
	Ux8A0X4cernBEmNmGIGpRLV5gIhs1Ic=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zXqX3xtuvlWxgzbVzwt5N7dofujH4OIOZtshciguoJg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786591610; v=1; x=1787196410;
 b=m1ADqhLpBEehg5KN78jOKx1iCXB/FzalMYLZKDItkZyuoOVQQq7Bd//gD08zd1lmkbKkSrUM
 m9gwgGu38vwizbrjXnaNBIhpIn92MAvBY6XLY+gIme0iaY9KEE/GhPdjUdRL9ddGIUX+3CadWVT
 KCME7c+ckGb81tdlvkWQvagI=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id a81e386923b95674;
	Thu, 13 Aug 2026 03:26:40 +0000
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/oom_kill: simplify remaining RCU sections with guard(rcu)
Date: Thu, 13 Aug 2026 11:26:33 +0800
Message-Id: <20260813032634.344946-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE7FB1C0003
X-Stat-Signature: wc6p1ym19157zz4b8wkcmxup8pfg7oog
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786591612-678569
X-HE-Meta: U2FsdGVkX1+M7UnHI15X3j7BNOM2nR7chhaDIS4rJ2xjqwDwu2Gtntlzgg520Ojy0kLs77si/CV3x8LP2UbcRpYd+SdhG5NZC2jC1PuaFomWeyXbHB/8ehZou08J1uNyQ9OId3bu7XistE4Sq6HadKk3qr+/pO47htZD3LOFTh2UrDUQxnX5P+97oGM+TNH09Lu5Vmn+3qVy/WuUdDNJZf8LqlIVXxTBvUuETFY/5xw3/QligyFA372/bnHy3xgLcPIwquR2H7NtdTVDD3Q4rXkYtbn3x/cOK8Se7AV2WyloKT1RAPZAN89w7BLm+K2IISfiwgY9nwCkDx+pX9BjPKnqT1Y1T3EJBP+o7Lg9IhDaJLQyX5/pN3+ZeTlSGVMjiS2YR6l7/frvzW872t4/0Z4lDrKoaGL3Vata7uHgA6DYNo9AOdGUfjB5M2pK2DkUxTLPdJbLMnKDy5m5gtQyy2OnYLQ0yopdu16YxM39SAqnJ7/m8ZwSXQe3ErptK6YXo4EJkdJjLnu2/w8qPJ7Bt3gsYbYFmaBCglEMow9PNv0TsKn6akzMmn+08BzEl2ZR1898R1RwiS61rEwnFkvqxVj206pEhelPlvdUP/pujfMZWThcPhxG4fqI9/Olxsu2jLDkg5G2kheYrhqfAL0Aq7gO+hLUAbm8sEf6cn0+CsuACOBOKPo9xsNSR7KbKyrWVsMc7zy/NssYP0O3FkIptkFvYbJxK4sSxeF62I/V9yk9xan3/arLl8OnJts2raO5B69Cr11b1D7CVoxwHo7rXuUFR41w3CdbQ4ibhPa9SqGYFF4xqxZNRzH3hEu2VRe0ohEsfppKdTJIagzcEzsHliYv7pelLFpHotX8I8mYikYYjtBdh+7pdN+qWFlx/MNhXnwClu72TtBt2bsznPKFvhH3rBdckr631I303FsUZexDDwjI8pd2aTcarZD/wk1MD6HmQMv/DcdIf25r2cI
 p6RbjWYJ
 wkfAKGdoM0qZ1S9CZAGPpQA6VEWIB9HPdNrNvEXnxEieK4b+XA3TLiKMFLtlVkFCcf+tkaiIcKC2zDSCgzHes4Q37V26l0/suQvgoF8h6Jq+rnyWpow1iKuTv/KmgboA5EPmPWSKGdrbg6hLb9fCHYgjVNdbJh1aOWguNFruQuqPEjIxGflRKdk2bxhExaoTIo7biPlY7X961KQ/S0yCiliWXu0Dk7TsifS0dvjmlmJiMWcsUygRDg0V5D3EqtiQghXbg6UijvKaOJwOG37fFPoftvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the remaining manual rcu_read_lock()/rcu_read_unlock() pairs
in oom_cpuset_eligible(), select_bad_process(), dump_tasks(),
task_will_free_mem(), and __oom_kill_process() with guard(rcu)() for
consistency and simpler control flow.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/oom_kill.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4b5c70aaece4..8bbb5ca00bb6 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -94,7 +94,7 @@ static bool oom_cpuset_eligible(struct task_struct *start,
 	bool ret = false;
 	const nodemask_t *mask = oc->nodemask;
 
-	rcu_read_lock();
+	guard(rcu)();
 	for_each_thread(start, tsk) {
 		if (mask) {
 			/*
@@ -114,7 +114,6 @@ static bool oom_cpuset_eligible(struct task_struct *start,
 		if (ret)
 			break;
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -368,11 +367,10 @@ static void select_bad_process(struct oom_control *oc)
 	else {
 		struct task_struct *p;
 
-		rcu_read_lock();
+		guard(rcu)();
 		for_each_process(p)
 			if (oom_evaluate_task(p, oc))
 				break;
-		rcu_read_unlock();
 	}
 }
 
@@ -430,14 +428,13 @@ static void dump_tasks(struct oom_control *oc)
 		struct task_struct *p;
 		int i = 0;
 
-		rcu_read_lock();
+		guard(rcu)();
 		for_each_process(p) {
 			/* Avoid potential softlockup warning */
 			if ((++i & 1023) == 0)
 				touch_softlockup_watchdog();
 			dump_task(p, oc);
 		}
-		rcu_read_unlock();
 	}
 }
 
@@ -894,7 +891,7 @@ static bool task_will_free_mem(struct task_struct *task)
 	 * are dying as well to make sure that a) nobody pins its mm and
 	 * b) the task is also reapable by the oom reaper.
 	 */
-	rcu_read_lock();
+	guard(rcu)();
 	for_each_process(p) {
 		if (!process_shares_mm(p, mm))
 			continue;
@@ -904,7 +901,6 @@ static bool task_will_free_mem(struct task_struct *task)
 		if (!ret)
 			break;
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -960,7 +956,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	 * That thread will now get access to memory reserves since it has a
 	 * pending fatal signal.
 	 */
-	rcu_read_lock();
+	guard(rcu)();
 	for_each_process(p) {
 		if (!process_shares_mm(p, mm))
 			continue;
@@ -982,7 +978,6 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 			continue;
 		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
 	}
-	rcu_read_unlock();
 
 	if (can_oom_reap)
 		queue_oom_reaper(victim);
-- 
2.25.1


