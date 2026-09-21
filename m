Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B06BCC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890416B0099; Mon, 21 Sep 2026 05:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867326B00E3; Mon, 21 Sep 2026 05:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756976B00E4; Mon, 21 Sep 2026 05:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDB76B0099
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:21:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFDDD1605FE
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:21:56 +0000 (UTC)
X-FDA: 85237227432.08.DB3D31C
Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7285C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:21:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jWsbvQJn;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJvGzrlhftO3zllLvxRTmCzkdMfsIaNzSFi2S0UU1+8=;
	b=zO5+EnwtQPlL4MDrAFpzqG0Jhxo05y942J4ruWiiooEZOodQFXlxrh5/HnqKrBwp7aatJB
	vSaxR2pGMimWXP23G+Eg0X6nHaETd+PwY3tDSH3YidXpbcGNP7UKHqJnv0AXCMAARkXFQ3
	wxMCbZowvpQJ0Lt7rLd1vqIJ1Whksto=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jWsbvQJn;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982515;
	b=WK4prFw0zs1GL1BwlENgMMPxzRsxc1rvMsZfymDTb6IjNkP2SwRXjkLlZpBViq8rFZsMza
	UVFGmxCnSEumxkg7Ce/nBiFhwDiqA8FEd5UrSQno0OfmTi8tI6sVi6SYzHhdvVIzGiMQjJ
	swokB2fNNWiriKxmg6UFcHQ852jUOFU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ftt2VmSueNigEmRUzim7RcAInXHUvUyDkJasA+sP/sI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982513; v=1; x=1790587313;
 b=jWsbvQJno9CuCyQVTZB9lhN7qsOidsqwQTyAIOnMC7/GD/rn2vKIe+LgRS26jI5FcznCU58R
 mIUL3pOsfkgA9Jr6AuJrp73cNcmcaSTvjS0o1R5wKXId1z/TjWu1fFmM0N1QApAjsWPJrdeFXv3
 L2EIteOtnYoad3rIZ50U9dg0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 63f02883ed771dab;
	Mon, 21 Sep 2026 09:21:53 +0000
X-Mizu-Trace-ID: 63f02883ed771dab
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com
Subject: [PATCH v4 02/15] mm/oom_kill: convert process/thread iterators to for_each_*_rculock
Date: Mon, 21 Sep 2026 17:20:48 +0800
Message-Id: <20260921092101.89285-3-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: c9o8yhxf7o3pxffgk9r1oxrse7k3fr7t
X-Rspamd-Queue-Id: D7285C0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789982514-505610
X-HE-Meta: U2FsdGVkX18VpRotKNQngRETkERPtz5SB4xVOmjLSzHKryVsgka5Rr4YDmSKYazIgM+Ga4Z/uObtq0QWNKZzxe4YQ1doNU+KO+6Y5K3XyvCCCLUwzh2nREY6iFgg8GdCXw3OXQE2V3Egg4lGLvARPX3jZSr52uH6fA/lqZkX+zy+b0gQA2hxchcnr7FBGdSZrvpUVBzBhaDxo0N6PO/IIkceEoZTyn0v8DeqJaIeAvqeAH3UatJ4skNJrDuv+oEHUNGtneDlxkXERIQqR4EKG4IvFQOh3fJ+qdrzGz4Fr44qdbdQruls1sb4wRQ4S6EDqABF+WyPwuHXj1bd4HnTfU9+quxR0Kx/EhorVcN7kd1/+iiQclzb1ni+4vnHsw0Rb3ujJ9mEzr93xLQ8XhkcV20uWeUWdThUvGsRid+QndjV7srS0VNqkxuGWXNta4yGAkycpQaKoKOlCPjkNOmOtt//+WAN/WeXOXqeEBwuizj3k7gxfHEw33257HSzp8aH3yYf9D5DWUkhv96ekQbB/tmBZaiJXMou6L40TV9RW5tkDsNcHxKV54mMijeoDxIDJqXvhohLOkHjzpnjxbmA4XAtC5eo58wHYd4kl0wn9xtz6CB3X1A0Yug51Vpwl50sSHOSiOCxMdEQ2Eyy+VrzYBJkFckHuf5iSLpmK8ikEDSOUKGj/Nl2ql8B/EJXy0y9pF5QCQtaRdXJK8xxbZhSGTRM4gtMpHNm6YE8ITEz0M+mqN9GxhDzZUPY0F1lZzq9SaI7J7G7YdzZATUTFqRcTgq7g/5Lb/pJudxdX/UZKts7xHCDGrTZ2VQ1caYaN60UsZU7MUvMfLBSq2BXxgi8S9GidFyoiTxNRwBnvvFmDFNeOpsZzk/s9uBgpic+OYwHYmZRISVAAQQaYmBnZSB2O5aimqBDMzcQV4wubkbPZcT0i0M+onh1Un0QPnoDEo3Kwve499g/f4AcfwHqK+B
 JYkpWyIa
 jA116JfWa6h3VuSnFgzU8+8VeO7rXAO2VceLwb8E+O1GcmGTiG+tCZWiKssR1MwKNwtbiAc1gzZLR+WjFdanl9spb6pYZLGJMomz10OjxGZqud1Hd/TmVFrT3hql/O6ZGUwfOrDQ7Vbl30L0ZGnQvcBt+g3VcZzbdKKQXoR/fkd4WNghfwFTFBbhGypyHiWAXS+1qvhdS7dRd0ARe+NBd1t0VOUcA++bsQm47Oc7oGVecqY8G+vMLvJxiU0qWWTwU+kFexJi4k2b1UXDkYxAaCMW3BnzrIX7rIeRVWLmuc++s+jg9w9/tb3XnCU2pRfoSlvBjbW5Nfa0zuyQ8DqUbIwUfdB6ODGt5BbZl2aSxnfJI3XnWz90Ns0JBCFYpfxrd+8wCkuPVzrSNnPkjDoRUErHFWVG9CJUemEYCwU9My5tkBGoK/OeH/vmNsCjE7klVbehCk5ANMGbxf4x7VUc6qCVyR3R5y0P/8tko4J1IUkoyxIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pairs wrapping
for_each_process()/for_each_thread() loops with for_each_process_rculock()
and for_each_thread_rculock(), which scope the RCU read lock to the
loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/oom_kill.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5f372f6e26fa..ef2e1c423c1d 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -94,8 +94,7 @@ static bool oom_cpuset_eligible(struct task_struct *start,
 	bool ret = false;
 	const nodemask_t *mask = oc->nodemask;
 
-	rcu_read_lock();
-	for_each_thread(start, tsk) {
+	for_each_thread_rculock(start, tsk) {
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
+		for_each_process_rculock(p)
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
+		for_each_process_rculock(p) {
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
+	for_each_process_rculock(p) {
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
+	for_each_process_rculock(p) {
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


