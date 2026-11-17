Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CFAD60A381D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=QJaqZd/l
Received: by kanga.kvack.org (Postfix)
	id 2FDFB6B05B8; Tue, 17 Nov 2026 11:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4376B05BA; Tue, 17 Nov 2026 11:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C6D6B05BE; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B44A66B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 361E6C04EC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
X-FDA: 85445116008.23.FF333A6
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id A6FBC180009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="QJaqZd/l";
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NL0ww0G+wkmoUTIEcewt6rKahuqp+HU09ouoVDjGSdk=;
	b=77QBcTRsb7IQyDLN87AJReitNkrgSHp5DVaigj3XGYevEXJxVvZ2rsg7bFZlnQHpTM32qj
	ybSZ8WhJTD9DKcVk6VYq9FU5oNDOn3mKGcAu+eBQxl36DhVqSW63trsu4jPT7O6wNQav87
	PVl/MDhViNRtA3mwe0FiABVU1jnhG/k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="QJaqZd/l";
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932242;
	b=lsAd5lLajRe1nya5x4Rdpi215zfYcMV9yDmQg3KQRkIX3IchFoss2aftwYgH5T8q2dzXUo
	D/gwNtCKUb2YTy0QMf36J80U2izdzpg4/AX7sCU0CjPB8atmytW4/jRZDJuw1/XRpmivBj
	IcScduKwn/wTNofiLWwCiZbQr+46Rns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932242;
	bh=NL0ww0G+wkmoUTIEcewt6rKahuqp+HU09ouoVDjGSdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJaqZd/lswb28KJv7VuKyyLVEX8putQ5zU6mfysWA403rCRMa/X3Q698mgVSM4CiH
	 61fjO4PRzFKG15uPcSInZMDf+JK97wLq1ngAZJK5UN96395jOviS6yY8I5M3t9LwVc
	 Drxtn40SvAxWCzTdADnlyyF0rWyJ2AesbvIi9fG7iKuaCEJjlJm36FP3fESgR8iVVR
	 76j8KgOsxI5nT/DuxccDsOHLX+4vVtcL6+WZRpkA3lDwXdk2auc9HCU58szXyHhV15
	 2fHTDun3rNrAvmHV/1RacMLz6THjAMEWVrZTDcEaxHJuYC8Mu7TzSA0nlcwC01Ie5e
	 QD7nW9Y0oMJfw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHk0XfczRmr;
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
Subject: [PATCH 04/17] sched/mmcid: Let a running joiner take its CID after the fixups
Date: Tue, 17 Nov 2026 11:17:04 -0500
Message-Id: <f1b450d79e9ae67134ed3451b4af33e71cc5dd74.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A6FBC180009
X-Stat-Signature: tbt89jsmrh7ouib47htcsj7sjpmeot6j
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794932242-740776
X-HE-Meta: U2FsdGVkX1/DF4Sza2M27MCFpmg78M1CQBuNQl0pMxXYvxJtdMCLrB7bqalXSAKhL1X3erpjgFO5RKB0AsekTVhl4OoIOmom8RJvb01wqg+R3Mf1b0E1EL3+GShn+2v2Rut3dOHwCBdxSXFZRL1BEuF0raPh/9utz3s3a/0POg1FxDVHVp/qPz0Zq4vJdNa2XJxbLloTqGJ0SgKR0JQc8ZpyDRHb6tYjFMArytP6oD7UVmvL5TaM5Yyzw3ejVcql4xNmRpRin1TxXZ7YlHnYuCTbqAWxsIJoN0GN3c4GqV9Uk8lAJSd0nWloEXXieqbkWxOk+jhJoZgW3jgjLhRNU3UbdYhY3yC8oT+AAD7TSLXySumXyopkFQMSCYjmiPvAdk+Vt3nXl0wHV0ZLIttuiz9/0t0FWBaFM0FDeL+6VNECBAlKYHGhU0J6mRRYykqhZDEeen5e1bWSrwpXTaqHvNS8GzXNUDybOzvrwVR+U7PIQVk9sfinLS79B3bsna8HJhHRCQqTjEVac/b3N2VuaKKakhqIZz84SdSmR7ooYL2Kg+MU1hfsbQj1JNX+fyBXSGaJMmrqbHUrWS7xtTkhT4LvN6WYhLBpRwfJcjJa5JMotooAsWfRSp3IBoujvPb7fOESx1gFH6e12qeo9Kg2KSjkDG4bZfCyuaEjN5LxBdkXcMK5cfvhAKZWHbop/KcXpUCGlXs5vf/Pa0N8GQWJHTZz6vNVzovy8YrVyl8xYPwomhSgUhqfP28OJn7seqOu1h55p5OKozqkDtSuUC8xZ5d1UzXCJCDyEUUD83Do5fwV+XHpu43Fb/HVTEbhFvnrWc44063gYRkKfG/2qiVjtUYksWy4mw2ehvAVklZKsH1hm3oUmf6gNmR/JZvxzjPLFTW+3Tca5JNOv6JkQPSxhaXwVQHmLiRwPhOmpXXx6UDcb/5xAG4C9DL50qeFMTAxnzSI79YOxmEoljpSfpD
 OOWaSB/B
 jNHU4d/x51esNAEsjV2A2/W77UPmmZ0UfKQgjLKl2PlumAmb9dpLGWADldk10fIUsthBF1vJrOFk824GuEoL9qCXQaqH6tH6GiOfb6vocXFusoB0V04wSDoL4+SaPB1VgoEAmKWzT+sWoKMQsg8AEVLcTtg7okHZrB2twnHVbyUT2zEECxH35T5kLtKDpflEbDAqeRWUfqrIkmUgEFsoV2HAfQ5VnTGMHgQD/Dls7W2sAdmt9L2ZBCfxnESqU53BhTLFxbSQ8K9IaUH45Jo6/QTfrjvdf/Rj4vxatLGNNJgAfqGyd1Skh8yrXvSKs3igyefhVtqC3unq/Ndc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The switch to per CPU mode relies on the new user not running yet. The
comment above the code says so: the new user is not visible in the
system, and the task that forks it runs the fixup.

A failed execve() is missed. It rejoins its mm in
sched_mm_cid_after_execve(): the new user is the running task, and it
runs the fixup itself. If it is preempted before the fixup is done,
mm_get_cid() can loop forever at its schedule in, with the runqueue
lock held.

In the diagram below, the machine has two possible CPUs. A and B are
threads of one process, which is in per task mode with two CIDs. C is
the vfork() child of B. A holds mm_cid.mutex from sched_mm_cid_fork(A)
on.

  CPU 0                                     CPU 1

  A: execve()
     sched_mm_cid_before_execve()
       A leaves, users = 1
                                            B: vfork()
                                               sched_mm_cid_fork(C)
                                                 users = 2
                                                 C takes the last CID
  A: execve() fails
     sched_mm_cid_after_execve()
       sched_mm_cid_fork(A)
         users = 3, switch to per CPU mode
         A is active and has no CID
  A is preempted
  A is scheduled in
     mm_cid_schedin(A)
       mm_get_cid() loops:
       B and C hold both CIDs
                                            C: exit()
                                               sched_mm_cid_exit()
                                                 waits for mm_cid.mutex,
                                                 which A holds

Nothing ends the loop. Only the fixup could free a CID, and A is the
task that runs it.

A guest with two CPUs hangs on this sequence when a SCHED_FIFO task
wakes every 50us on CPU 0 to preempt A. CPU 0 stays in __schedule() and
CPU 1 in queued_spin_lock_slowpath(). With this change the same guest
completes 20000 attempts.

Fix this by keeping a running joiner inactive until the fixups are done.
A schedule in gives it no CID before that. sched_mm_cid_fork() then
marks it active, and it takes its CID under the runqueue lock.

Fixes: 653fda7ae73d ("sched/mmcid: Switch over to the new mechanism")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/core.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ab68e8605eed..510cd775723b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11054,7 +11054,16 @@ static void sched_mm_cid_fork(struct task_struct *t)
 			return;
 		}
 
-		if (!sched_mm_cid_add_user(t, mm)) {
+		flip = sched_mm_cid_add_user(t, mm);
+		/*
+		 * A running joiner takes no CID at a schedule in before the
+		 * fixups are done. The users it joins can hold every CID
+		 * until then, and the fixups are its own work.
+		 */
+		if (t == current)
+			t->mm_cid.active = 0;
+
+		if (!flip) {
 			if (!cid_on_cpu(mm->mm_cid.mode))
 				t->mm_cid.cid = mm_get_cid(mm);
 			break;
@@ -11064,7 +11073,6 @@ static void sched_mm_cid_fork(struct task_struct *t)
 		 * Handle the mode change and transfer current's CID. A
 		 * running joiner has no CID yet. It takes one below.
 		 */
-		flip = true;
 		percpu = cid_on_cpu(mm->mm_cid.mode);
 		if (!percpu)
 			mm_cid_transit_to_task(current, pcp);
@@ -11077,18 +11085,16 @@ static void sched_mm_cid_fork(struct task_struct *t)
 			mm_cid_fixup_tasks_to_cpus();
 		} else {
 			mm_cid_fixup_cpus_to_tasks(mm);
-			/*
-			 * A running joiner may have taken a CID at a
-			 * schedule in. If not, it takes one below.
-			 */
+			/* A running joiner takes its CID below. */
 			if (t != current)
 				t->mm_cid.cid = mm_get_cid(mm);
 		}
 	}
 
-	/* A running joiner with no CID takes one now, see above. */
+	/* The running joiner takes part from here on, see above. */
 	if (t == current) {
 		guard(task_rq_lock)(t);
+		t->mm_cid.active = 1;
 		if (t->mm_cid.cid == MM_CID_UNSET)
 			mm_cid_schedin(t);
 	}
-- 
2.47.3


