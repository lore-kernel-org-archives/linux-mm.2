Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E69C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09276B008C; Fri,  4 Sep 2026 04:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B9E6B0092; Fri,  4 Sep 2026 04:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A8D6B0095; Fri,  4 Sep 2026 04:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 600926B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:30:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA181140BA7
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:38 +0000 (UTC)
X-FDA: 85175408556.29.55EE7FC
Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id CB9FB4000A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dr+1EDEp;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788510637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMsntPxvM0gm/b0AT8rN4oY9d2qwKPEc1G38sV827II=;
	b=Nqq2vuUird806xPC3FsnV02CncpkXFOe3jEfv/y9ubO1qRc86zFJHddOEUMVcERMTsWVne
	lm0GOB4MAsC4muZlpwjPqoWng4s9EmnJwLehNKcbQHW4h571tzckyo399kroevHUipGXDR
	o5weIPKk2VV1GHsbI+jEhfAZC1TBDi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788510637;
	b=o21GPESarOuUNR1HR8kC7a5wgEunacoav5koRgX2sI/7Hws6qXTo64MWrEQfQMaT5ra6bb
	QWINcvu4gJbN8Strgn7XAlXlFE8p5HxA822hZzUFXAX2yLzOSKtaobsieyTqJo/WyN39xf
	8Im6n2JVWaUqB0l6tOlyDzKS7ih6zQw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dr+1EDEp;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xI+T+eXGD7eKBa0m1TDUjuBJ5Swlbo+f7ZmwsrX8pGo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788510635; v=1; x=1789115435;
 b=dr+1EDEpBWgQI0VnHPTz9unjpAU77XTN+K9apqe9BZxQ54+tKGoNgqzz8xmjm3+YJsDsvkOi
 IePLTbSpLt5ajXlQF9eiF11taaAB6Q3tND/ZL7JX2birMlcbAUpMe+OUK/1Zw/rKJpKOT8cS7Ha
 RZtZAEFP2qGHxHnAfQufoFqM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4c1715947a22fdab;
	Fri, 04 Sep 2026 08:30:35 +0000
X-Mizu-Trace-ID: 4c1715947a22fdab
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] mm/oom_kill: convert process/thread iterators to for_each_*_rcu
Date: Fri,  4 Sep 2026 16:29:54 +0800
Message-Id: <20260904083001.553587-3-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260904083001.553587-1-ye.liu@linux.dev>
References: <20260904083001.553587-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bg6r7678us6u46xkprd4g4bybstqs1ta
X-Rspamd-Queue-Id: CB9FB4000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788510636-609067
X-HE-Meta: U2FsdGVkX1/BCGKrdhMz8CLeGF2L26DPwnU6s23BtsIp1UmR1ayjNDY95zCNNuHxVSmOGBWbvdWUkw2PaJN5v+BOZQNlQf+WpSIZBH+qWwDkYRqZ5mbUo1iPSdqaNKXF4LR1ozzYaexoqOOVA3RVHT7d9DI8Bo7MHGDfyRCkKe0TBCBNad7mfqTJjtLh2mtCzCr+PYe4e0O5ziueP6u3iyRplvGwymND8u3P+mh2rXq64d9Y2ymzrmcOnp7spxyt6+7An0rskoQTKluB3iaGl68QU8BiC+/MjyUYyU5dFIRkxOIOzqfGDqZdVWJPwmj51cUo5jlcBtyWI1ajZxAmCG4e8Piz44XdEv2S9D2/D8H7pCycEQ1YUfZgthLasxBHmEpNLDVlBnrECG9DrOfMTgGrH6SQ5GRlok6FX+2kDz5Pf/EkMO33WQwxFb0vRJKCgj1GvOrYB5r+2uGdkVIeRChP8JW87yZBQJRIzgldz7gyoP6ZPtAtKbjhk6lkxqnk7MgxnrstT0cxnSRrTBaX3HXAQddj/K6IRk/ctzxLQ4z0AkzZJcQBz3FaUFFP34dWJjS5t085/REsxTKG8LjMHBWfkda2ta4smCSFhPWo/bJqfhc/wOYipDDhaDT/VEBm+xKnK5iFZ3Y62vejNb4YaNPZqDT7tBcuLEydVn/6/eY1K37yCxi8k4BczAnoo/O609TDlcIkJUKmk3EhdZ8u9tGZxWPuOFebX3iHxaQl/bZGVJj8eCqmeqeVmSzY31VMnkRSdPMvLZzHJsjUsR1r3BWvbzpqGkH/ihkkHrE74AV8lR5Yaih8WqeIX/HSl5tD1aEYZWIDsm9u3ii4Q5MKE/X8n4ogd6Ke1bI0bhplVaCYO2X/6Julb54SV4Yion2qQ2WTKGO39OuNXH617DXhLHBPagX8z9UP22Z/7fGNDI9gpOv/TEREJ5IcQ94H9Qae+E6WNI6LXQRD2UYjAe5
 NK2+3qOw
 QBqGEgAM4FaF1N/bACmv6vw4600ulHfYcv2b+HAqPEpEGftDEocjWPFwH6m2MKvhOq+E9dr7d576xKvOr8rofOi3i8jjXZX0Fs+PqAPR6m0DAAJkhh27XZJmQH2AUw2WYogZGnvMx6eFNZFc/efLiXVMZ2ZG6xQsYrzPaabLnlOcxIQR612Eii1tMtYtnKpgUIoO10Vvo+ynDvDGf8/MxNM92xHyTE9u62Uk6Xn2UDYUb/WmxzJPnMtFwL9Iegu7cx0PvUGG7zeGv6lGSYWEbC38leg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pairs wrapping
for_each_process()/for_each_thread() loops with for_each_process_rcu()
and for_each_thread_rcu(), so that the RCU read-side critical section
is scoped to the loop body.

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/oom_kill.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5f372f6e26fa..8dd025965810 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -94,8 +94,7 @@ static bool oom_cpuset_eligible(struct task_struct *start,
 	bool ret = false;
 	const nodemask_t *mask = oc->nodemask;
 
-	rcu_read_lock();
-	for_each_thread(start, tsk) {
+	for_each_thread_rcu(start, tsk) {
 		if (mask) {
 			/*
 			 * If this is a mempolicy constrained oom, tsk's
@@ -114,7 +113,6 @@ static bool oom_cpuset_eligible(struct task_struct *start,
 		if (ret)
 			break;
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -368,11 +366,9 @@ static void select_bad_process(struct oom_control *oc)
 	else {
 		struct task_struct *p;
 
-		rcu_read_lock();
-		for_each_process(p)
+		for_each_process_rcu(p)
 			if (oom_evaluate_task(p, oc))
 				break;
-		rcu_read_unlock();
 	}
 }
 
@@ -430,14 +426,12 @@ static void dump_tasks(struct oom_control *oc)
 		struct task_struct *p;
 		int i = 0;
 
-		rcu_read_lock();
-		for_each_process(p) {
+		for_each_process_rcu(p) {
 			/* Avoid potential softlockup warning */
 			if ((++i & 1023) == 0)
 				touch_softlockup_watchdog();
 			dump_task(p, oc);
 		}
-		rcu_read_unlock();
 	}
 }
 
@@ -894,8 +888,7 @@ static bool task_will_free_mem(struct task_struct *task)
 	 * are dying as well to make sure that a) nobody pins its mm and
 	 * b) the task is also reapable by the oom reaper.
 	 */
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rcu(p) {
 		if (!process_shares_mm(p, mm))
 			continue;
 		if (same_thread_group(task, p))
@@ -904,7 +897,6 @@ static bool task_will_free_mem(struct task_struct *task)
 		if (!ret)
 			break;
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -960,8 +952,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	 * That thread will now get access to memory reserves since it has a
 	 * pending fatal signal.
 	 */
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rcu(p) {
 		if (!process_shares_mm(p, mm))
 			continue;
 		if (same_thread_group(p, victim))
@@ -982,7 +973,6 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 			continue;
 		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
 	}
-	rcu_read_unlock();
 
 	if (can_oom_reap)
 		queue_oom_reaper(victim);
-- 
2.25.1


