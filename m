Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1371606A8A6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=cBfVwpF8
Received: by kanga.kvack.org (Postfix)
	id 9DCA66B05BF; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2576B05BD; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1616B05BF; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 590DF6B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4E771A04E2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:25 +0000 (UTC)
X-FDA: 85445116050.01.EE0ACCC
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5F7764000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=cBfVwpF8;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFMHS3iTvPTL4lMx2nmha2rZYOE4qD7+sjyLqjHBK9M=;
	b=dvrHymMBurotsxD0Yo4xzY4ftEcN/9c0nIoxCHirZLlpemS5/JWEV7ppylG/xe+21aj0be
	ed3IPNCOMiB0ghpQbSRTiMlWfpzGm2YXnVLcKpH1N4CvZt3G1Iv9TltYelZ8dsOtU+0VTT
	/ia9A8pt7pUVoEWvLN/OtjFcUoW3deo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932244;
	b=M58+KKG8btILMrg2Vq7bNj3IsDzmRcbqc0zf2A4lgeaI3lgoxJBkhyEyKDRLU7DRebB/KX
	7LwA915kHlDEfnr1xVImEly4n3+34Vmcqit/RVfNG+sYiSsF9ir5Nu8rtnHWHevmbuE2P1
	EkPZhudh9ZgTIdskStnDHA7OJB9VzbQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=cBfVwpF8;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932242;
	bh=zFMHS3iTvPTL4lMx2nmha2rZYOE4qD7+sjyLqjHBK9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBfVwpF8LlRC3OTMgX6+oDFqBNpDY8KWRQ6HBfMaygd0svmS1ia7iA6eVvdLQU9ii
	 pCs/Hgyas869jQa4aA6jCkyTzVpRL3Cn54vlo5giTk0VlLxkf2rHqmC9L+SoOUEF8W
	 yt1V6N3MYEamoPkacy07uGkb24mooxD5PuLm4oPrM8yBkt3xQTtnVC/61u2hrJW5TZ
	 3+BzMdkL3zk3FKmbdaUGCerP9xkMg6wToKsdHrJjQpqMF8l03JU3ay0osVecUWjLvS
	 WMZcPbcVWj0S9JJEHVQa9ZGvPPvDuBtUsRLzDXr4lx4MX8VJ4Jbs1zXaIJ3snvhX5q
	 oGrXNuUxNoGdA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHk1ppWzRcG;
	Tue, 17 Nov 2026 11:17:22 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: tglx@kernel.org,
	peterz@infradead.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	paulmck@kernel.org,
	boqun@kernel.org,
	shuah@kernel.org,
	kees@kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	oleg@redhat.com,
	bestswngs@gmail.com,
	xmei5@asu.edu,
	xujiakai24@mails.ucas.ac.cn,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 05/17] sched/mmcid: Take the allowed CPUs of the first user when it joins
Date: Tue, 17 Nov 2026 11:17:05 -0500
Message-Id: <df251e85248861597f9e35ec0e3edbe188993c6a.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F7764000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6eed8ry9eyg7uqo5kpmhq5qx6hekpccx
X-HE-Tag: 1794932244-863393
X-HE-Meta: U2FsdGVkX18UbKhslAR3OmTyq2sBQBGn/vuCX0t4uonJvrvBOlcxTQ8qgCgFTTCQ8mOY1H7TXHe8HRG40KGM9ImfZXToBzNjbevkNCMMxXVXVk/BH/QNKSfisgvJojKCA64kys/Sz178iZDjKA/tBTcEaLyl7QLkd4gcS1pJSyjI2vU8Rugt67ziRV+55Dl9CsjoqGAL1Xq+cLueDs7DLr9BpGcGUbyZ0KIgqpUUgdypm9kcW3R+VGEymqTvgn4m0NCv8p6U7zjbdX6btaDcPJgSBkrrMiJq5PycrcXZlfZma5K3ZA3p0pbNzMDU7AR/kdD/YafeVh6gNBF5pUDBsj1d8K+bJrbiihrAW7zY1r/FXuLQQj9hjcXFYdZAzkJH+uz+ZSB4IHk3Dy6cuWYCnKjiDqYbZxavLNSSStY+AHM+C/UES/cqf+ts4nsu/IiN6+kx5pB0+atgpcEflcJDCQeBtWky4szez6o1MHPzlsDbu5noMVGAnJGus+ZOljUu+5ph4ViMoFzC/7GdceisrnG7pdSId5U5cRJ9pCDpSrg6F3TRPQNcffUfs0LvgicAPLqEPlNb4txdwCoa6D105Pitgunfj+hKX/z3Knom3JCvTWto7enFl3cJqfkJqo2Q+5OFbRcXkDBdgU5C5mHIH2WqrtCBqtaIJ7UI4dpwmOCpTS7dLpvVZ+iKPwn3mJNuo7NQcQ1f0gd4qw/YxHb5STrJXNWWQFon+NP8wmZr2wdemcxUhPusSNX4u1z/YHGZPsv6yhOB218EEMHyJex4yDMy0FIgq1yejdQZgiD38gdp2aAI22jMkgL1RU7p/F384UG49s0cz2Q0CYupyeouTgLLBJGG1FRq9AiYW9uOEIU6u8lGLvwl7a84AoGkLY5BZ+WoeIzjQYkBXP+RuW3gGsbanZMhWD5bI4TBAtY2+VI65AONcLGFHa/HmP6IuHDpcvGyEf5J5C1+dHOHZ+l
 rs3YoSYJ
 /PY+Nu2IZxjQT1QZrFpdfn7jvqNG/Kst1uRPS38rKS23xVByRaM20DXq0Gl961lHxRGy3OuQ8zL1uwzkS2iwAXsXU5mifKOkN/Z4AkDiHql5FIdNWW6yRMIqEe/oolHJ00zTKfa02jpaOk2iZ6OUwqGp6FmrW1KqSshZ46Re9Onv/uM/EJg68HbuYn2Zifde7d+tb3YlRRzOumWXwIWDXvxllgoSV3/8+OIQ5UeQSTu4GeBxyExXJPFWs2Ra3Xzm5o3FCmBXU3KG3boZKx7AcjyHuoldMBZptgiJ3REPcfi7c3Ciqw+Uu0Ccf94+Y+diVktP4kEMYcs6VtfwuYKMnRFCyt6T7ByhH44fN6LOSuCZrMb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The CIDs of an mm are sized from the CPUs its threads are allowed on.
mm_init_cid() copies the allowed CPUs of the task into a new mm. Later
changes reach the mm through mm_update_cpus_allowed(). It uses the mm
the task points to, and ignores an mm with no user.

An affinity change between mm_init_cid() and the join of the first user
is lost. In this example, P is a task allowed on one CPU, and H is
another task:

  P                                     H

  execve()
    exec_mmap()
      mm_init_cid()
        copies the allowed CPUs of P
                                        sched_setaffinity(P, all CPUs)
                                          mm_update_cpus_allowed()
                                            the new mm has no user:
                                            ignored
    sched_mm_cid_after_execve()
      P joins the new mm, which
      counts one allowed CPU

From reading the code, a fork() child has the same window between
dup_mm() and sched_mm_cid_fork().

The new mm then stays sized for the CPUs allowed at that time. A
process that starts on one CPU and is widened to 64 CPUs during its
execve() switches to per CPU mode with its second thread. In testing,
two threads of such a process read mm_cid 0 and 63. The IDs stay below
the number of possible CPUs. They are no longer compact.

Fix this by adding the allowed CPUs of the first user to the mm when it
joins. Hold t->pi_lock for that, as an affinity change holds it. A
concurrent change is then in t->cpus_mask already, or it finds the user
and updates the mm itself.

Fixes: b0c3d51b54f8 ("sched/mmcid: Provide precomputed maximal value")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/core.c | 65 +++++++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 510cd775723b..456b76e823b3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10833,24 +10833,17 @@ static bool mm_update_max_cids(struct mm_struct *mm)
 	return true;
 }
 
-static inline void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpumask *affmsk)
+static void __mm_update_cpus_allowed(struct mm_struct *mm, const struct cpumask *affmsk)
 {
+	struct mm_mm_cid *mc = &mm->mm_cid;
 	struct cpumask *mm_allowed;
-	struct mm_mm_cid *mc;
 	unsigned int weight;
 
-	if (!mm || !READ_ONCE(mm->mm_cid.users))
-		return;
+	lockdep_assert_held(&mc->lock);
 	/*
 	 * mm::mm_cid::mm_cpus_allowed is the superset of each threads
 	 * allowed CPUs mask which means it can only grow.
 	 */
-	mc = &mm->mm_cid;
-	guard(raw_spinlock)(&mc->lock);
-	/* Might have raced with exit() */
-	if (!mm->mm_cid.users)
-		return;
-
 	mm_allowed = mm_cpus_allowed(mm);
 	weight = cpumask_weighted_or(mm_allowed, mm_allowed, affmsk);
 	if (weight == mc->nr_cpus_allowed)
@@ -10876,6 +10869,20 @@ static inline void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpu
 	irq_work_queue(&mc->irq_work);
 }
 
+static inline void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpumask *affmsk)
+{
+	/* The first user takes the allowed CPUs of its task when it joins */
+	if (!mm || !READ_ONCE(mm->mm_cid.users))
+		return;
+
+	guard(raw_spinlock)(&mm->mm_cid.lock);
+	/* Might have raced with exit() */
+	if (!mm->mm_cid.users)
+		return;
+
+	__mm_update_cpus_allowed(mm, affmsk);
+}
+
 static inline void mm_cid_complete_transit(struct mm_struct *mm, unsigned int mode)
 {
 	/*
@@ -11017,6 +11024,28 @@ static void sched_mm_cid_cleanup_execve(struct task_struct *t, struct mm_struct
 	cpumask_copy(mm_cpus_allowed(mm), &t->cpus_mask);
 }
 
+/*
+ * Make @t the first user of the CIDs of its mm.
+ *
+ * mm_init_cid() copied the allowed CPUs of @t before @t was a user. An
+ * affinity change since then did not reach the mm. Add the allowed CPUs
+ * of @t again. Hold t->pi_lock, which every affinity change takes. A
+ * concurrent change is then in t->cpus_mask already, or it finds the
+ * user.
+ */
+static void sched_mm_cid_add_first_user(struct task_struct *t, struct mm_struct *mm)
+{
+	guard(raw_spinlock_irq)(&t->pi_lock);
+	guard(raw_spinlock)(&mm->mm_cid.lock);
+
+	sched_mm_cid_cleanup_execve(t, mm);
+	sched_mm_cid_add_user(t, mm);
+	__mm_update_cpus_allowed(mm, &t->cpus_mask);
+	t->mm_cid.cid = mm_get_cid(mm);
+	/* Required for execve() */
+	__this_cpu_write(mm->mm_cid.pcpu->cid, t->mm_cid.cid);
+}
+
 /*
  * Make @t a user of the CIDs of its mm. Called on fork(2) and on
  * execve(2). A failed execve(2) rejoins the mm it left.
@@ -11041,19 +11070,15 @@ static void sched_mm_cid_fork(struct task_struct *t)
 	WARN_ON_ONCE(t->mm_cid.cid != MM_CID_UNSET);
 
 	guard(mutex)(&mm->mm_cid.mutex);
+	/* The mutex keeps other users from joining or leaving */
+	if (!mm->mm_cid.users) {
+		sched_mm_cid_add_first_user(t, mm);
+		return;
+	}
+
 	scoped_guard(raw_spinlock_irq, &mm->mm_cid.lock) {
 		struct mm_cid_pcpu *pcp = this_cpu_ptr(mm->mm_cid.pcpu);
 
-		/* First user ? */
-		if (!mm->mm_cid.users) {
-			sched_mm_cid_cleanup_execve(t, mm);
-			sched_mm_cid_add_user(t, mm);
-			t->mm_cid.cid = mm_get_cid(mm);
-			/* Required for execve() */
-			pcp->cid = t->mm_cid.cid;
-			return;
-		}
-
 		flip = sched_mm_cid_add_user(t, mm);
 		/*
 		 * A running joiner takes no CID at a schedule in before the
-- 
2.47.3


