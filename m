Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642FA606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 10:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cL2X3L7l
Received: by kanga.kvack.org (Postfix)
	id 7AA496B05B0; Sat, 28 Nov 2026 05:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75AB26B05B1; Sat, 28 Nov 2026 05:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6713E6B05B2; Sat, 28 Nov 2026 05:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44B666B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 05:28:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A8511405CF
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 10:28:11 +0000 (UTC)
X-FDA: 85484152782.25.ABCFBBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8AE37180005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 10:28:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cL2X3L7l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795861689;
	b=mFxwJmMTgRsmWA55/nFJp28F8SPjY9CkDcpUoewdNRexN24QL/nde7YIWQWzNdPraMjtDm
	aVYmuGx67I84/ZpIMJz5sRUfG5vKeBjAsfWqI3Aibl1sn67hWRh6ZPg3uKQZnzw8O3HwaU
	wtEoibx3RolCR5aO1xc4MZh3tmxUpiE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795861689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Lskh+N7JQvWM1QZ5Sr9CMmPwP72CT3UqVM90SLhC8k=;
	b=GxPP72ntF5iarrcH7xn1d3p/yW1RB4bGJPvtNVSXak2X635x8Yec5QzmfRM8Kuqyy76xBC
	tFu56OgWGJB5x5IxD8CzOXF+G9AVZ6Fd3KOmCvZapnDMtL22Bwbil1yFoHv5NlmJyTECQ1
	Rh/D27JoHHxFDba4OyBdfI875tUJF4I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cL2X3L7l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 212B0611D1;
	Sat, 28 Nov 2026 10:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79F21F00897;
	Sat, 28 Nov 2026 10:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795861688;
	bh=9Lskh+N7JQvWM1QZ5Sr9CMmPwP72CT3UqVM90SLhC8k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=cL2X3L7lNbnr6CCN3wycQ7lBD4D0QUrGFLYnKkWeFpFCi2ohet7l2y6F+B+7o47cC
	 ZhG5JHdwZejbSpHHqqKzoBza+HyuJmbhTRvApnRcbcka5rLnEzHtk86rRaf7PwrnKu
	 xw6T2wXwMxpw6CfNf2cdijFqJR6Mw2zjiHnLiJzkQB+mE1dWmiBuKMaR4im/KvjPgC
	 yONscOLVeaJjIZGw5a2mSY5OV5qCOmN8aS77IEWxJy5rKnKeGxNkyKX5V60kp9Xe2k
	 WNLoN/HQqLHE7JhBdT26jm6MLZfs0iK4P2FcVigb6mTnrEI8VhHJlSsEKd7xlegWvW
	 JYeTqwNC6okbw==
From: Thomas Gleixner <tglx@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, mingo@redhat.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, paulmck@kernel.org, boqun@kernel.org,
 shuah@kernel.org, kees@kernel.org, viro@zeniv.linux.org.uk,
 brauner@kernel.org, jack@suse.cz, oleg@redhat.com, bestswngs@gmail.com,
 xmei5@asu.edu, xujiakai24@mails.ucas.ac.cn, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, Dominik
 Maier <dmnk@google.com>
Subject: Re: [PATCH 00/17] sched/mmcid: fixes for execve, mode switches and
 affinity
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
Date: Sat, 28 Nov 2026 11:28:05 +0100
Message-ID: <87bj79s11m.ffs@fw13>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: mkcdrynm3b4q7s56h68spi4xn9mthg6d
X-Rspamd-Queue-Id: 8AE37180005
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795861689-745968
X-HE-Meta: U2FsdGVkX1/lSlDwWJm3eIrJCUIQi+pbH8Uy/3gg4Z/ckLKZjPxVicvrn2MjvkkpT1jfzPKg8TaJSXvNz00vDJfVwo1PMVl3B8XZzpGIO0CR7q/IofUAs+T5oMytImyfFjT4dmeHNgqhFOmRwBVCrhg8YDkfcnVPKpOeY7ULuoZbfqqOXN8UkRAWXq0Je9OyllEvQ9hx5RrmAbFf+eWHRKopMUjowP2zx93DADae1nnZntvvH67bQztUiolyYJ32mWCrL43mPOE48YZ6ldbr2DA9M/X2IIgyDVyw+VL/EyUy84IBUI4ugoDOERa1f/5SjUzwZuz/eEex+Z2FYJ0h3Mz8YcYIa8sAQwHRgSka9xys1rWtvCOQ86T2vbp+WwnZMs7HwkblRuiktZ8hvC3PqCTGIgW1xM9etKV8HPI7V3XMtrXpRLUa+3GKxC/++P2DtGFwNs4RFMIz0EkQgYZ1mUcc/W8GDUB8RGg0ETcSnqgY6yEzT16S15y++3ymUrqVWpURO8H4zfpFzB9Ov0+R2qxjr6JhaMgS3bYIcCfp51DOc6cGxcml1AAvqaH7D/qcfu/ONJf3OTGtsUNVZpTyKjlvthc5t5CH0T+Q8vpXyn9tBKA3OYJvwu7Htesw/4cEZEg8du4hTj24+vCwSruquNUYMoYEHS/UTEvl5ypyG3CKUIthkPCdf7lLk3oytAR+kDgrQu4ZE71y15l2U9IatEgXR/oLTYjiQVPQNN8cmE9A+VAdL2NH0J4NeztFN5/4k4MlH91jVPO0L07ygiO30AUCdmmo2I/PJMRjNY+7CQRjqzfhdRqgyPeBIFbzhqLm8HAnua26W8i7aCuTFM2Zg/o4J7A235iicds6B3SabR7TRf/5CU9+PajmH4qrdpMgcu3+Dvkm4yXpbOyv+AkBMb5g3fV7AJ8OU2WWyoWyIFiLBwMX+v1pYGlf+8VRcjd9Q8mELVyPHJ/ZD2hOMOn
 I1/cMk6l
 vQ7puEhIxC09T284effr+6Ch/tgrFcse+TbYxcJXB5n0lHp/3fV5bhbfnRUKHTeZh2YphQ9cGCSFJLtfakIPgBB5/dQRzKGukPooJehOhsgQxCyrxBz9KhM2qIloGY1PAHEKXgqOYVGfdjeRtbd2iQHTfxj8lKlTp6hagk6blfM/E0xFpXAlWIC2G6E4t0OJRUd0OAUFxaC6AI1tSJAxqGLLgPzCPbLwZFBAT7idY8nr+D26LejFbyuEj0YZWj2Fk+1XH1fT6izcKkPSOpqLdCoyHZBnGUOtxyBtohAJT/dho2IRt1138PVj93lPEgGLriMEf9BoYf5+q/M7iP5XBbi4fMuqbfwA0v37EMmnvyfSRpSkN6IOenXWi8kOmG23JalMFOEdMiax1ZqMXvx+TjJIBpY9lzJk2/D8YLGzFvLLMoqBsajGyiaHhQLaHxBDlmt+tC2/r8gAlz1Ms99bB2CN7LL3cPbYZsmwQm1lawUfXFEOrDeBo6J3AsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17 2026 at 11:17, Mathieu Desnoyers wrote:
> This series fixes six problems of the rseq concurrency IDs (mm_cid),
> and adds selftests for them. I looked for cases the existing tests do
> not reach:
> - a thread count that goes up and down;
> - exit, fork and a failed execve();
> - affinity changes made by another process.
>
> The fixes come first, and all six are marked for stable:
>
>   1  Give a CID to a task that joins its mm while running. A failed
>      execve() then no longer returns to user space with an mm_cid of
>      0x80000000.
>   2  Give no CID to io_uring and vhost workers, so that they do not
>      take IDs from the threads of the process.
>   3  Reset the stale per CPU state of an mm when its first user joins.
>      A machine with two or three CPUs no longer locks up after a failed
>      execve().
>   4  Keep a running joiner inactive until the fixups are done, so that
>      it cannot loop in mm_get_cid() while it holds mm_cid.mutex.
>   5  Add the allowed CPUs of the first user to the mm when it joins.
>      An affinity change by another task during execve() is then not
>      lost. 
>   6  Fix the use after free of the old mm in set_cpus_allowed_common().

#1, #3 and #4 are all caused by the fact that the exec()'ing task
disables MM CID right at the beginning of exec(). But that can be
completely avoided because the only requirement to deactivate it is when
the task is about to switch to the new MM, i.e. after all other threads
are torn down.

So instead of adding duct tape and haywire in the MM CID core code we
really should fix the underlying problem. See untested patch below.

#6 is incomplete vs. exec() switching MMs because the new MM is visible
before MMCID has been initialized on it. I look into that seperately.

Thanks,

        tglx
---
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1171,6 +1171,21 @@ int begin_new_exec(struct linux_binprm *
 	 */
 	posixtimer_exec();
 
+	/*
+	 * Remove the task from the MM CID management which is associated to the
+	 * original MM. This is done here to avoid leaving and rejoining the MM
+	 * CID management _before_ all threads of the the process have been
+	 * terrminated.
+	 *
+	 * On success the task invokes sched_mm_cid_after_execve() in
+	 * bprm_execve().
+	 *
+	 * In case that the below fails, the task will not return to user space
+	 * because bprm->point_of_no_return is set so there is no point to bring
+	 * the task back into MM CID management.
+	 */
+	sched_mm_cid_before_execve(current);
+
 	/* see the comment in check_unsafe_exec() */
 	current->fs->in_exec = 0;
 
@@ -1853,7 +1868,6 @@ static int bprm_execve(struct linux_binp
 	 */
 	check_unsafe_exec(bprm);
 	current->in_execve = 1;
-	sched_mm_cid_before_execve(current);
 
 	sched_exec();
 
@@ -1866,7 +1880,14 @@ static int bprm_execve(struct linux_binp
 	if (retval < 0)
 		goto out;
 
+	/*
+	 * Reactivating MM CID is only required for the success case. The
+	 * exec()'ing task deactivates MM CID after bprm->point_of_no_return has
+	 * been set true, so any failure after that point will prevent the task
+	 * from going back to user space.
+	 */
 	sched_mm_cid_after_execve(current);
+
 	rseq_execve(current);
 	/* execve succeeded */
 	current->in_execve = 0;
@@ -1885,7 +1906,6 @@ static int bprm_execve(struct linux_binp
 	if (bprm->point_of_no_return && !fatal_signal_pending(current))
 		force_fatal_sig(SIGSEGV);
 
-	sched_mm_cid_after_execve(current);
 	rseq_force_update();
 	current->in_execve = 0;
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11166,7 +11166,7 @@ void sched_mm_cid_exit(struct task_struc
 	cancel_work_sync(&mm->mm_cid.work);
 }
 
-/* Deactivate MM CID allocation across execve() */
+/* Deactivate MM CID allocation across execve() switching MM */
 void sched_mm_cid_before_execve(struct task_struct *t)
 {
 	sched_mm_cid_exit(t);


