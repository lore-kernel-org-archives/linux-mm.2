Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71FA5C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001676B0446; Thu, 13 Aug 2026 05:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5356B0447; Thu, 13 Aug 2026 05:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D956B0448; Thu, 13 Aug 2026 05:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA5F66B0446
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:29:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1870E80542
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:29:45 +0000 (UTC)
X-FDA: 85095723930.15.758B4BE
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf28.hostedemail.com (Postfix) with ESMTP id E99F2C0007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:29:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A7VPEwK3;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ATMbrusjlb34cLSI2dZa+yv/tW9w79/dds6SKkcTF28=;
	b=H66BPYHv94k4tsG+PUVIsNZnr6LlD58y97IeOSJiyXMTp2mGv8HIZua9EhaEYOxQ+fpoOw
	d7aHb6gbBv5QPVV9YZSkBFMbGVIUppwJ0nQhx+4s9elQgIQxZP+aK6B9ToRCKTpWaltWEZ
	SMsL4D72Do1V2aPgZGmyM66F43MwEik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613383;
	b=0MiZoluGBe5uaHTG7Gq9F30DTZyinPFIc7RaLW2qWiI/aLx55W+XA0CQevQ5uCT/VTfjgf
	7JHtkOjIlao+7s7jAeOVql5jIKF/gVDa7DSFMV8cPMoN13M3z1iV/h8ZOzyWeq1dTSd+77
	SE8gaob3lMA/Y8dcJgkORwYcWBj1esg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A7VPEwK3;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zhgOHw63AcUJAplbKIEJvv7m1p0z7+bYI1CwdCRIEhw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786613381; v=1; x=1787218181;
 b=A7VPEwK3Wz5RL+CW2vF7LPXMowGqs+S5V0avNHRuEztvLfVrFKsrxsfmb+7j/TcAi1AksJUo
 soe1xP5CW0ynJpu/pjyBalu6Yom6viE9PaukrZoZCoVUavJH6I8mvgLNflVI+bwampc+5GoqTHj
 9w1t5MhA39mJXRVBXbvXje/A=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 40f498756c1e9c2b;
	Thu, 13 Aug 2026 09:29:41 +0000
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/oom_kill: simplify remaining RCU sections with scoped_guard(rcu)
Date: Thu, 13 Aug 2026 17:29:32 +0800
Message-Id: <20260813092933.562028-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4if4wjkd3q8t7gx1ro64swngzojw61w1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E99F2C0007
X-HE-Tag: 1786613382-461529
X-HE-Meta: U2FsdGVkX1/5aaL0G4Nam1bEhilS8M7siB4WhmBvYIvLF6KXiXKc6K8WSMgw6CpauIeGdS84pNugM3SwK5I76A5xcxop9SY+vfgEQn6BTvNJg706KiRk+hUhZ0TzG+OERZKOBHuzN6YPJmy6ubSeqpjtH4XPp9oZvb1RJeuilFcZ1g69eGaGOtnXqBeZkocRLcB19meSEhCvzroH9peaMa3pSgcatgsZH3VPizUwPYswZg52hulLHT8Lj9BslM4Bw9gabxanLXixSv805kophBc0zAUFD2bWLNK/g55rWXEkO6zrIqo24gMCSj7U9yUvl6X/BjNl9zTThOGNFRWfeXJSW2FpGE/rd5LUImfuZr3nCqnb4zh7F3x1wJ5BP0aOUjPjFzhz4mx7538BmuNjLhN5Q2TIktl+7Y4EWf7UwO9N1gXOQKGtt2QQYhy11NdKZNTJOGKqDEOaqITEKO5/RROr6DmMwzclWpW4I8WxGqjDU833bXCYiLGciVyB/qUbBCF+Fvlbp+q0hjdP1v4b4MC42cgc6vb/8Gvr1X2YiAcQt1nN9XWsSTQfaE+UQsK/W65PDWMTV6MSokseoKk3LrLu2alIqEEDT0RUhzmVK4sjgcRRLT7VoRrv8i4cXPHI4kIa9cZH0oW4RQPZrlbgxgN4cje2FlYtdc4eEvZqGjfbYlo8EA2ayUKYDwhh5mx5gWY3i/d5XWuzgZt/6O/7dpyXn4jeZ2+vtJtnmgcMBnf1ocM5wX7mh++u5MeQemQLxuSbZyCqhNtmbx5iYdZzVNPqWyhRRIhGODVvjkc4S5yv+Tj/OgIluU4xngsM9ijWuFCV2Cw+lJzaQM/I8TlFj0CvVHjtojgZ2sj/ItRgmEAEfkUYyOx5UQX7VrorjCjO4jNrKSHisStAz4DLEq8gmT0bpXHawGPaXL/3k5Q8gBQMsJ6JdDJDUbUJAJFWnlnE1HvFTj/RleV9bENclwY
 oDPedeg3
 N5ECuIpPRyUkUMXdRVnEDUfMRYxrZkxPCFOVgapBYvFZd7V/1AcdJc5BWApuRVvEX6YTW3sdXRBG9Ak9/eaHWw8NQuQifkcLbABGPF53A6VYkBpVSW5FfAPuq/7VneCTraNdJZJT1zN1P2kPgZQvLIHl7ZcKITZCbPb+uSqTreSeHWURybIyGO0j/75AIJN8ZV+MUlU7ZHIFz50WBXerbIGyJefBlc4/h9hrjF/sN8P3e88SJGmtl1u1LhVMhgHfMbxISFHedW0FZT6rabPFm9no+85wmoowmzBtyfydJ0ZWHL0CyegwByR14tau+tZsjBqe+NIjysO983OQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the remaining manual rcu_read_lock()/rcu_read_unlock() pairs
in oom_cpuset_eligible(), select_bad_process(), dump_tasks(),
task_will_free_mem(), and __oom_kill_process() with scoped_guard(rcu)
for consistency and simpler control flow.  scoped_guard(rcu) limits
the RCU critical section to the loop body rather than the entire
remaining function scope, making the protected region explicit and
safer for future changes.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
v2:
 - Use scoped_guard instead of guard.
 - Link：https://lore.kernel.org/all/20260813032634.344946-1-ye.liu@linux.dev/

 mm/oom_kill.c | 124 +++++++++++++++++++++++++-------------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5f372f6e26fa..0e8982e5be51 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -94,27 +94,27 @@ static bool oom_cpuset_eligible(struct task_struct *start,
 	bool ret = false;
 	const nodemask_t *mask = oc->nodemask;
 
-	rcu_read_lock();
-	for_each_thread(start, tsk) {
-		if (mask) {
-			/*
-			 * If this is a mempolicy constrained oom, tsk's
-			 * cpuset is irrelevant.  Only return true if its
-			 * mempolicy intersects current, otherwise it may be
-			 * needlessly killed.
-			 */
-			ret = mempolicy_in_oom_domain(tsk, mask);
-		} else {
-			/*
-			 * This is not a mempolicy constrained oom, so only
-			 * check the mems of tsk's cpuset.
-			 */
-			ret = cpuset_mems_allowed_intersects(current, tsk);
+	scoped_guard(rcu) {
+		for_each_thread(start, tsk) {
+			if (mask) {
+				/*
+				 * If this is a mempolicy constrained oom, tsk's
+				 * cpuset is irrelevant.  Only return true if its
+				 * mempolicy intersects current, otherwise it may be
+				 * needlessly killed.
+				 */
+				ret = mempolicy_in_oom_domain(tsk, mask);
+			} else {
+				/*
+				 * This is not a mempolicy constrained oom, so only
+				 * check the mems of tsk's cpuset.
+				 */
+				ret = cpuset_mems_allowed_intersects(current, tsk);
+			}
+			if (ret)
+				break;
 		}
-		if (ret)
-			break;
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -368,11 +368,11 @@ static void select_bad_process(struct oom_control *oc)
 	else {
 		struct task_struct *p;
 
-		rcu_read_lock();
-		for_each_process(p)
-			if (oom_evaluate_task(p, oc))
-				break;
-		rcu_read_unlock();
+		scoped_guard(rcu) {
+			for_each_process(p)
+				if (oom_evaluate_task(p, oc))
+					break;
+		}
 	}
 }
 
@@ -430,14 +430,14 @@ static void dump_tasks(struct oom_control *oc)
 		struct task_struct *p;
 		int i = 0;
 
-		rcu_read_lock();
-		for_each_process(p) {
-			/* Avoid potential softlockup warning */
-			if ((++i & 1023) == 0)
-				touch_softlockup_watchdog();
-			dump_task(p, oc);
+		scoped_guard(rcu) {
+			for_each_process(p) {
+				/* Avoid potential softlockup warning */
+				if ((++i & 1023) == 0)
+					touch_softlockup_watchdog();
+				dump_task(p, oc);
+			}
 		}
-		rcu_read_unlock();
 	}
 }
 
@@ -894,17 +894,17 @@ static bool task_will_free_mem(struct task_struct *task)
 	 * are dying as well to make sure that a) nobody pins its mm and
 	 * b) the task is also reapable by the oom reaper.
 	 */
-	rcu_read_lock();
-	for_each_process(p) {
-		if (!process_shares_mm(p, mm))
-			continue;
-		if (same_thread_group(task, p))
-			continue;
-		ret = __task_will_free_mem(p);
-		if (!ret)
-			break;
+	scoped_guard(rcu) {
+		for_each_process(p) {
+			if (!process_shares_mm(p, mm))
+				continue;
+			if (same_thread_group(task, p))
+				continue;
+			ret = __task_will_free_mem(p);
+			if (!ret)
+				break;
+		}
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -960,29 +960,29 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	 * That thread will now get access to memory reserves since it has a
 	 * pending fatal signal.
 	 */
-	rcu_read_lock();
-	for_each_process(p) {
-		if (!process_shares_mm(p, mm))
-			continue;
-		if (same_thread_group(p, victim))
-			continue;
-		if (is_global_init(p)) {
-			can_oom_reap = false;
-			mm_flags_set(MMF_OOM_SKIP, mm);
-			pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
-					task_pid_nr(victim), victim->comm,
-					task_pid_nr(p), p->comm);
-			continue;
+	scoped_guard(rcu) {
+		for_each_process(p) {
+			if (!process_shares_mm(p, mm))
+				continue;
+			if (same_thread_group(p, victim))
+				continue;
+			if (is_global_init(p)) {
+				can_oom_reap = false;
+				mm_flags_set(MMF_OOM_SKIP, mm);
+				pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
+						task_pid_nr(victim), victim->comm,
+						task_pid_nr(p), p->comm);
+				continue;
+			}
+			/*
+			 * No kthread_use_mm() user needs to read from the userspace so
+			 * we are ok to reap it.
+			 */
+			if (unlikely(p->flags & PF_KTHREAD))
+				continue;
+			do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
 		}
-		/*
-		 * No kthread_use_mm() user needs to read from the userspace so
-		 * we are ok to reap it.
-		 */
-		if (unlikely(p->flags & PF_KTHREAD))
-			continue;
-		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
 	}
-	rcu_read_unlock();
 
 	if (can_oom_reap)
 		queue_oom_reaper(victim);
-- 
2.25.1


