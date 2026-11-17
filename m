Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DECA8606D807
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=dAHGJJBy
Received: by kanga.kvack.org (Postfix)
	id 101E86B00EF; Tue, 17 Nov 2026 11:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B20A6B05BA; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83F86B00EF; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A81D26B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3585580523
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
X-FDA: 85445116008.22.8CDF028
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5CFA114000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=dAHGJJBy;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932242;
	b=rDu5ly0cNqMh2EkhSOWSo79ocHvBYMOXctUdx6O6wDestfAm/NR1MRXuDt2MIQXDvtsiOQ
	0EEYZm2PSJhDixt8OKcDUhblJOtB/MOX5vP8dx+IY5lg3/W+hF+c+FRUg9nEovTz1gVQST
	Is+t5J+6GOsPTDrLGr7TAvfgPNyPZLM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=dAHGJJBy;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5ObJtDP34I/BMfHer6YxrOqpSiQsGpA7S8X4Rx45Ro=;
	b=56hXtrQEpQhB+t+nRy2zTBmPA0dSiydfRzxNI/i/aBmSRFMoodrGSkP/fJLyve21Fab5HB
	aeGhgNCcSqKScHbIWKMQH1Oohh21i9n50cxYZAkmvEaXl7RrAtRa/VLzsneYiYz/A4t53u
	/bG1S8gCoUYoLACd5KBcEP15co2QdRU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932241;
	bh=J5ObJtDP34I/BMfHer6YxrOqpSiQsGpA7S8X4Rx45Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAHGJJByTy4EHpW5ej+bdYloHhOBu2GBE4ssFO3r+UHxSeQ4MY4O7+YwycJk/tEps
	 OrX88u+pLS4veb+ki3/QKoXO4/bR2rsV6lppLyZ/xB281s2DfSuTv1e+2BMWh7X2Mi
	 61QAnCNi9mENrqE42GFxcjILKfrEUy3NfLv0ftdbqmnYsn3htVIaIIaOqH6PHOXFxh
	 DpzsXi3FN1R0vgqDDw7s68uwUNlqZq51AJceX6vUmHy4LP9w6nYBPTT1mevY58eCKS
	 3V1i53pVcZ14nG6DI+4ziIomLJT6dRAG8PjWo6b4RE+JVTSyewWk4XU+0Rk9ELWVJ1
	 3pG4Z3U5neg8Q==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHj3vvxzRWZ;
	Tue, 17 Nov 2026 11:17:21 -0500 (EST)
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
Subject: [PATCH 01/17] sched/mmcid: Give a CID to a task that joins its mm while running
Date: Tue, 17 Nov 2026 11:17:01 -0500
Message-Id: <87f01a2eacf8aeea751d8f48b3aab752d825a4bf.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5CFA114000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9d4xabst4buhdb3fn8s1srhmuw1rmgju
X-Rspam-User: 
X-HE-Tag: 1794932242-207611
X-HE-Meta: U2FsdGVkX1+r4G2xmClOslLwQ8TH/UGCqeRFGLZoaG/FffSlZjnu5hpnnfnH2haRoeU0ZvtPr8U7r65+L+zeXQG+/mXYOT0Y2N5NhdcorrEgVvlg4JG6VqfoqfxW0ps2iSZkXfvhVdniF96X4O2NrBhe5KVXfqRHOIkMaD1LpKSJLbY7AWWi0DQ+8lBRFHQgndg7S/6ml4lsEFFSSrvqvcFV+cW7zWunmkiU1A7I4zG423z34nZvmA6QBXolII48slqfhrVXE9BxmDTYXY4vdEGZBo+s6a5X/HUW3vw9IlCem160LG3XTFviiYLjA9P1bp2hrgaRdBQDasD19LxGa4KjsuY1RZTynIJQ5HZEOmkfzE1+iE5Z64xSDBU3ZmtDyBuYYUzpbOCzOGw1EM4MV74mTLq6Xgk0dUxDbftOpKeFNbvfdBK/Xa7yvRDzzj9jq7NdKa1O4WLWzHmZnIZcRXGeKsS1FhUK24McdCGZrSNceyUV/ZIpEjLuT1FQxm4zfpILxLCnTFw/3gR76TavFFwkkoiryp46bkbl2qY0U2Azl7FdxYECvl3uLXZjjhlJn0A3PordYJcj9Skv06qHicafWOgy6M0PB3wOVYBM2r0gelvj9q7pxZgpikYmNJrWy6cflv25lui/hvBnq+QNv6pQzMfKi1POBpwyRaeaWhvUk/47KN/yPqqzfRPsiQa84eZbr9SxpgrGIiEFJckCzOSvXvn9e/q4OyUT0foiSz1udvPnS4tPGf8J2HA35g1ikf5W7AU1uZA1uDgGPT0VNBlE9NUbkR3eGWNhhe9HMSp9/ns3KLEalzIXMhWrUukHBgNonkTFUMDg63wvW5se0FFwGY1o1SrUlJnrnggdvbGwFeRmNdjM1xN1wEFa08N2VbUkuGjctl7i5mdNRneV46VLGlPKgtHHsrgw2Yp81aM03WeJBQzG2W5TBDcHindIQZ5qUw/q8VKUn5d/cir
 bQCFFPWN
 z+Q39nFwli8Pg1WaoIpNcza+42qZoaSvHWE1XL3c3mnYCOtU8nOLT5xm27UlmHHNfnBzVXWeg8nzSRREEjIQeX6KYFbYM1Lozga5xmyK31YYT/xyzJrjCS4LzHNF4FA/6KwaSxUfAjjZreCeVPMmYk+E/2OEFr8y4deK6fMB/RMnrITTX+zTONAAimmDS4qWIlOHjCABIkmmUAaCEhgWo7Q2M67jlhM0hPaMImvzBXCoVEDJtYuh/P9ao/AG+aRZqwSP/4t3K/PDzVqZ3NOHdO9lDaIJlD9itr5covrd0d3E97vL1UjazT5ekHp0/38UvFoCv8bnHA0CIIfkDBx7wG1pSBlT/yJabNE/x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sched_mm_cid_fork() makes a task a user of the CIDs of its mm. In per
CPU mode the new user gets no CID there. It takes the CID of its CPU
when it is scheduled in.

This relies on the new user not running yet. That holds for a fork()
child. A successful execve() joins a new mm as its first user, and the
first user gets a CID directly.

A failed execve() is missed. bprm_execve() leaves the mm in
sched_mm_cid_before_execve(). Its error path rejoins the same mm in
sched_mm_cid_after_execve(). If the execve() fails before
begin_new_exec() kills the other threads, they are still users of the
mm. The mm can then be in per CPU mode. The task is running, so it
returns to user space with no schedule in. Its CID is still
MM_CID_UNSET, and rseq_force_update() makes the kernel write it to the
rseq area. User space reads an mm_cid of 0x80000000 until its next
context switch. A program that indexes per-CID data with it would read
out of bounds.

An execve() of a file that no binfmt handler recognises fails in that
window. In testing, with 20 threads on a machine with 8 CPUs:

  mm_cid 2147483648 (0x80000000) after a failed execve, round 0

Fix this by giving a running joiner its CID in sched_mm_cid_fork(). It
takes the CID a schedule in would give it, under the runqueue lock.

The switch back to per task mode has the same problem. Since
commit 7dbc307b6c72 ("sched/mmcid: Fix affinity-triggered switch back to
per-task mode"), a join can do the switch that an affinity change
queued. For a running joiner:

 1. sched_mm_cid_fork() runs mm_cid_fixup_cpus_to_tasks().
 2. The joiner is preempted. It takes a CID at its schedule in.
 3. sched_mm_cid_fork() allocates a CID for the new user. That
    overwrites the CID of step 2.

The bit of the first CID stays set in the bitmap, with no owner. In
testing, three threads on two CPUs then read an mm_cid of 3 or more.
Leave that allocation to a joiner that is not running. A running joiner
takes its CID as above if it has none.

Fixes: 653fda7ae73d ("sched/mmcid: Switch over to the new mechanism")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/core.c | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1a088d4576f5..f2a981d418eb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10986,10 +10986,19 @@ static bool sched_mm_cid_add_user(struct task_struct *t, struct mm_struct *mm)
 	return mm_update_max_cids(mm);
 }
 
+/*
+ * Make @t a user of the CIDs of its mm. Called on fork(2) and on
+ * execve(2). A failed execve(2) rejoins the mm it left.
+ *
+ * In per CPU mode a new user gets no CID here. It takes the CID of its
+ * CPU when it is scheduled in. A task that joins while it is running
+ * returns to user space before that, so it takes its CID here. This is
+ * the case of a failed execve(2) when the mm has other users.
+ */
 static void sched_mm_cid_fork(struct task_struct *t)
 {
 	struct mm_struct *mm = t->mm;
-	bool percpu;
+	bool percpu = false, flip = false;
 
 	if (!mm)
 		return;
@@ -11012,10 +11021,14 @@ static void sched_mm_cid_fork(struct task_struct *t)
 		if (!sched_mm_cid_add_user(t, mm)) {
 			if (!cid_on_cpu(mm->mm_cid.mode))
 				t->mm_cid.cid = mm_get_cid(mm);
-			return;
+			break;
 		}
 
-		/* Handle the mode change and transfer current's CID */
+		/*
+		 * Handle the mode change and transfer current's CID. A
+		 * running joiner has no CID yet. It takes one below.
+		 */
+		flip = true;
 		percpu = cid_on_cpu(mm->mm_cid.mode);
 		if (!percpu)
 			mm_cid_transit_to_task(current, pcp);
@@ -11023,11 +11036,25 @@ static void sched_mm_cid_fork(struct task_struct *t)
 			mm_cid_transit_to_cpu(current, pcp);
 	}
 
-	if (percpu) {
-		mm_cid_fixup_tasks_to_cpus();
-	} else {
-		mm_cid_fixup_cpus_to_tasks(mm);
-		t->mm_cid.cid = mm_get_cid(mm);
+	if (flip) {
+		if (percpu) {
+			mm_cid_fixup_tasks_to_cpus();
+		} else {
+			mm_cid_fixup_cpus_to_tasks(mm);
+			/*
+			 * A running joiner may have taken a CID at a
+			 * schedule in. If not, it takes one below.
+			 */
+			if (t != current)
+				t->mm_cid.cid = mm_get_cid(mm);
+		}
+	}
+
+	/* A running joiner with no CID takes one now, see above. */
+	if (t == current) {
+		guard(task_rq_lock)(t);
+		if (t->mm_cid.cid == MM_CID_UNSET)
+			mm_cid_schedin(t);
 	}
 }
 
-- 
2.47.3


