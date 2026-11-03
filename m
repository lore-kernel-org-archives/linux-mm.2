Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64C0606A336
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=KIpQTFXv
Received: by kanga.kvack.org (Postfix)
	id 0D2306B05CC; Tue,  3 Nov 2026 03:01:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9986B05CD; Tue,  3 Nov 2026 03:01:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01A96B05CE; Tue,  3 Nov 2026 03:01:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D22DB6B05CC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:01:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 705D94035B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:21 +0000 (UTC)
X-FDA: 85393062762.09.CCD757A
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6B90818000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=KIpQTFXv;
	spf=pass (imf24.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692879;
	b=q2PHb1KjdwB88Y+QthGfx0lezx34uhWla7juPfXZUxUF1q1vzrxhHn66FUCe6es+z43qCW
	eEswwRB4HLZ2JiGrQa3FpweWsO8zwMOlU7trX19knW/oV3mWLS+XVcMsso+KsB2OG9C594
	Lzs9ayxSEm3m1ZQouAatpkmJkIHk0iw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=KIpQTFXv;
	spf=pass (imf24.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7czWU74VCUPrnLnmq02o91EF357Keqvg3cH2LY97Lm4=;
	b=K5DNc1JIH3SGUiINZaRUADiVQ9HlBSfYV6+JKC1B5/YjoAG5DXfJVcMeUWL9dbM2vCvZ78
	Y26xMaNY7evC7aMndCiZpPTO/OGGC7VHeAzbchAZBB+SlzVR7KdSfGoJ7WGJNN+GcXViqi
	4WGkdzl6W0O6aN59d403ezC13XDO4Fo=
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2508D3F46B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692878;
	bh=7czWU74VCUPrnLnmq02o91EF357Keqvg3cH2LY97Lm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=KIpQTFXvm6hxRGjKvYp9zJeXovq8su7N468Ad4dgwMJaWz9vEaiOCGDkokJUQKlkb
	 kECqOQ8JiLh/N3CLC272DWKKdaTs2IwG7u1pymBuoOp7KnuJa61ZKjlL7JpEJJ/oBI
	 M2x2FK1Vef0DBnEU16eNMNz/9g4J2daFucqUFZKnXdT1wyuVSL+Qe8lIbb8WLnWTi9
	 yeiOtyJ3t+Gbm8YpbO+6fbo7JqKOm8vqXkIdlcyOUgS7RWL381WJazqlbnlmGlWbD0
	 zas6THNsJF8KmcgAJflFxVi2NcpYPQZuZ3NJmlnxMpcAlib3/Oiu3SD9NVgqeLIlLk
	 kJvWKYgLC7FA9JkjorLJQFYcOiU4hySf+0VPqj34sfzMWsP9wHsXM9EnGs+Xx8hKAX
	 VMk57eIMda7ykl+uvIKwmW3eWgFGmLZ1jQHlVvnoKWmOKxeb4VNwjiOOVMemB0ZOqG
	 dCb5HaXihGq1KkdHN73W+MCCLiRTtY5P7Fs493WyyFpOQYOsAgjby9L4Cd1ZjN8V0T
	 z1W7rVOG+CQvrleZzhb0P1pW/4G50yyxmgIk5IHxOawk5VInOEcEqhCSnN4RcArTS0
	 p+YyAYfwOUINszRm0HzDETQzcslRddeadcEvHXcA4QHKpWUkqLmu8w8HvtAynhW35q
	 IUEW6GMs+1HV8eERJBSlEMRk=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35cbea41088so5375051eec.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 00:01:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692876; x=1794297676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7czWU74VCUPrnLnmq02o91EF357Keqvg3cH2LY97Lm4=;
        b=DpJU5aMyG6pu4FwVkgIXJkfrTS86L0wzQ7BAMx72B9bxMNnBnhFrAh/xmOLX1Tlu7B
         U0YfNQ354AFJ7aN3ufsnxgSZ6igATuSbyd9lFh49FVwMH5Gu3H8v/XnX0OWTDqG1SKH2
         fPW72a4Y+W/veU5sirC8c27JDsacpYRKDOrwUanxy7H0EhJH9yzL5oBFHuz4WZ1/I9b6
         JkHipJzW9TG1jBnJlg+KNWohXr+e3f615XY6C2xI5EmgSYmDia9t2SJxnBijrSIcZYaV
         Lq+xRExR3eGc7FkAyYwWkGiNO29Fimu8y+TuX+N4xEQ97dD53QNZ3u8IY0vLi8zDg67e
         NLow==
X-Forwarded-Encrypted: i=1; AKwUvBxPE5lGIz3/quewRajCtXnqq4tkIuwwYXQLlNBl8XgIYZoXgk1I55A638PrTflrSJg+eo447huILw==@kvack.org
X-Gm-Message-State: APuU4Z9Z7tCD1M9ZpVvz0XcFCW+CYQHonuzlvGHVtY3GuDWkwPuTffQQ
	cNdmr/OhezUsr9OMo08v9tXEKdZ/ocQl2+pyqmoZQb1cCkw3JGdDeOnwfYvz6Ga5pKLZo23k4FA
	yQOrcK1LaeldqfrjEK1rNca6rVZ7KcJF3IXs4j71tYEE5ljwayKaHGCa6rNDtS5ykca6c
X-Gm-Gg: AYBFou1vEsy+jbXqoDBUQEPDklY64AQ8YMtk/kzP5nD0qrvneRxX8k/kiyBJHmiZghj
	qdNkag+4FcriAYpA58eP8+PzAi2pnTayx9EC9w3i2btTlA90dJVGNGzoYIOomi6PlvI8h22SmVx
	qGWk4R4N5cTemUveu4+/hJnId2zLn+AY5+JkHaxuvTcxA1crtD3Z89o+B+EHTU7Z5REu5VOKJa4
	aB1dqzav/uN85H8GiOO2UNj3/moPD2vs1yc9z8XNKrderyfZyYCjrmw4P6pjpVnP+8+QDOC5/ji
	jUDTRLEo02CAV510BY5tV8ybmmdKPGLHqYNnMpTDqTNKt1Mr5lLDgOiQSjsuxdohzpAv+nOf+QF
	zsem8/UYX1/bVf386Zqc0x7/XOsRTmCV4dvL0ij8Ilx9VV7p6nvVRQz53hIpwAh9GsweAsq82wU
	wcFL7JEzXZgGOCtbhzoA==
X-Received: by 2002:a05:7300:8813:b0:36c:49a7:86ac with SMTP id 5a478bee46e88-36c49a78c8cmr1128092eec.37.1793692876458;
        Tue, 03 Nov 2026 00:01:16 -0800 (PST)
X-Received: by 2002:a05:7300:8813:b0:36c:49a7:86ac with SMTP id 5a478bee46e88-36c49a78c8cmr1128033eec.37.1793692875819;
        Tue, 03 Nov 2026 00:01:15 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:01:15 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 6/6] cgroup/cpuset: Don't make a forking task wait for memory migration
Date: Tue,  3 Nov 2026 20:59:40 +1300
Message-ID: <20261103075940.110308-7-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ufnm99yy6fujs7g5riyqn8p9ggozewy6
X-Rspamd-Queue-Id: 6B90818000E
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793692879-48308
X-HE-Meta: U2FsdGVkX18InWOKAC0OQuS1akQKdEBNmo9O9eNsQBfbxAiy1FUKiU8I/VkgrTvoBb0Xef2BFM2OME1las//NTtro2sA4RGzHUJW7igg/fMg39OkfD/COwmivobKooqOgVfh8BXRZYnmD821WDRU0CsoDjHmz5h0DE+XdAckUQrpe92bMs8ChavjR3xGZnv4mmq0NzC7/BQuRNNgxC29+lsMdhKAEuS9RWpJgeIMbTPR/zU2+Xf57YbM+gRo1iCix5zzEQTd+yJDYOD3eIAfUco6hdJpyu8OXWAaF2+HYROgyLMnuruZw1CnwzHx2pwO8wlzOTzYQfGwta0cez33WH1pcRonUta/WGdqP9gIN9qfZf9+UC7flndECcXhgoDVC4l0pIsjXqaRvahoq/w5vV1fd83aN2AlAW+Xw3JvjC9K3sIKjqJ5peGDr2knPIsY7kWsTLA4LICP6wYou5hga7UHnjWaMPGTLt3elyK9DitmoGSaNV7Cp8UJZM47MLTKb4dZ6Ke0PcSwkA1ztJL8EID8gqUeI7RiaFiPWRJjagDez0iyaCmjxVqvmgVOU/fqEonzeTFt+AX4olCiQY5z6v6xQSsPU27VfT5jA3Lsf2g1nEAvpnFWN020Ad0Vm6gZcG5GcZxrO4t/IZ/a01ULEaVMAJAM6w9BZNU5Cq9LrGTece1IOpyS3LtkLjlNbDx9EqC7Dfwo8ymH2OW2Sds94qn45FYziYTT5xWeoEnT59wHyioZkp923H8RYkiRz5+41KH4/Pu7LIzGJJHMK5ohKIbzDgv71hBBKr9PvPCsKNdQFhPhHio0Z6Gzg2YzGfE72iBm+XNoGmZYDU2nSI6zEtceoYmtcw04jk0kOuT/TY4hMMvMs5xG45TEpxDx0i6P9UrNaTXW+rOsW5e+53yIgcP9IDiOyjskpQimX6yoyr3Sfg4/OUhNLFGVVCbG1XqborLqB7CZ0N1H3x9dKSn
 XMBx0tVt
 WnNV6A9ZmVVOzGhCQqrMlKnJEuAEj/Fu7EQTL90tWkKfnuygF5UwWRE5NiFSIBtAqefo6VZGPP8G3ynO+qpTms3mUaIvU0t7kiUETZ8fN3n4CeCasCtcY/g3jVArAQXj8BBb1CArQjNtqt4CMje51U8DCwcg+ZVKXQmDMLJnh2gzFGLiocUyUCVGJNHdaRuCu+z9sh1YLaSV8R076Ja+vhE4St8GgAztGQQ1oD61DgliGLxGY47Lxhnss+IHvECZXKa0LkSmiySIP+ikdYxU1+yLO5tBxYdghV+KYUpcWDdYIRKQqyxQ/G6MSqHq7ikGj4N3WH2XLff1xP1Ots3m5vJa/J7+dbXb+OVSPgcnbsUJyJNmszzHdyXUrjYlt9rVJLKiX4CSkuJrg2b8XR7f6sIhTG+RDuMSTCjZqfo3adoTdSPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caron Wills <caron.wills@pulsar.com>

Since commit 65e510cd30d0 ("cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm()
calls inside cpuset_attach_task()") a CLONE_INTO_CGROUP fork into a cpuset that
differs from the parent's goes through cpuset_attach_task(), which queues a
memory migration of the child's mm and sets attach_ctx.task_work_queued, and
cpuset_fork() then schedules flush_migrate_mm_task_workfn() on the *parent*.
Two things are wrong with that:

 - task_work_queued is set whenever is_memory_migrate(cs) is true, which
   on cgroup v2 is always, even when cpuset_migrate_mm() queued nothing
   because the nodemasks were equal. The parent then flushes
   cpuset_migrate_mm_wq for no reason of its own.

 - cpuset_migrate_mm_wq is a single ordered workqueue, so the flush waits
   for every migration queued by anyone, not just this fork's. systemd
   forks services with CLONE_INTO_CGROUP, and as soon as one slice carries
   a cpuset setting every top-level slice has a cpuset of its own, so PID 1
   blocks in flush_workqueue() on every service start for as long as some
   unrelated cpuset.mems migration takes. On the AWS systems of
   LP: #2165410 that is minutes, during which logind cannot create
   sessions and SSH logins fail.

Make cpuset_migrate_mm() report whether it queued work and only set
task_work_queued in that case, and don't schedule the flush from
cpuset_fork() at all: the forking task is neither the cpuset.mems writer
nor the cgroup.procs writer for whom the synchronous semantics were
introduced by commit e93ad19d0564 ("cpuset: make mm migration asynchronous"),
and nothing depends on the child's pages having moved before the parent
returns from fork(). The migration itself still runs, in the background.

Fixes: 65e510cd30d0 ("cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm() calls inside cpuset_attach_task()")
Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 kernel/cgroup/cpuset.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 439b55a310fe..b331689eab24 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2704,26 +2704,32 @@ static void cpuset_migrate_mm_workfn(struct work_struct *work)
 	kfree(mwork);
 }
 
-static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
+/*
+ * Returns true if migration work was queued, in which case the caller may
+ * want to flush cpuset_migrate_mm_wq before returning to userspace.
+ */
+static bool cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 							const nodemask_t *to)
 {
 	struct cpuset_migrate_mm_work *mwork;
 
 	if (nodes_equal(*from, *to)) {
 		mmput(mm);
-		return;
+		return false;
 	}
 
 	mwork = kzalloc_obj(*mwork);
-	if (mwork) {
-		mwork->mm = mm;
-		mwork->from = *from;
-		mwork->to = *to;
-		INIT_WORK(&mwork->work, cpuset_migrate_mm_workfn);
-		queue_work(cpuset_migrate_mm_wq, &mwork->work);
-	} else {
+	if (!mwork) {
 		mmput(mm);
+		return false;
 	}
+
+	mwork->mm = mm;
+	mwork->from = *from;
+	mwork->to = *to;
+	INIT_WORK(&mwork->work, cpuset_migrate_mm_workfn);
+	queue_work(cpuset_migrate_mm_wq, &mwork->work);
+	return true;
 }
 
 static void flush_migrate_mm_task_workfn(struct callback_head *head)
@@ -3376,9 +3382,9 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 		 * migrate mm from.
 		 */
 		if (is_memory_migrate(cs)) {
-			cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
-					  &attach_ctx.nodemask_to);
-			attach_ctx.task_work_queued = true;
+			if (cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
+					      &attach_ctx.nodemask_to))
+				attach_ctx.task_work_queued = true;
 		} else {
 			mmput(mm);
 		}
@@ -3887,8 +3893,13 @@ static void cpuset_fork(struct task_struct *task)
 	attach_ctx.task_work_queued = false;
 	attach_ctx.old_cs = oldcs;
 	cpuset_attach_task(cs, task);
-	if (attach_ctx.task_work_queued)
-		schedule_flush_migrate_mm();
+	/*
+	 * Unlike a cpuset.mems or cgroup.procs writer, the forking task has
+	 * no business waiting for the child's pages to be migrated, and a
+	 * flush of the ordered cpuset_migrate_mm_wq would make it wait for
+	 * every migration anyone queued. Let the migration run in the
+	 * background.
+	 */
 
 	dec_attach_in_progress_locked();
 	mutex_unlock(&cpuset_mutex);
-- 
2.55.0


