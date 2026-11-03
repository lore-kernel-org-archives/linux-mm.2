Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9CF606D819
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 00:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OE3lDGfV
Received: by kanga.kvack.org (Postfix)
	id 11A516B05B2; Mon,  2 Nov 2026 19:22:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4506B05B3; Mon,  2 Nov 2026 19:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0596B05B4; Mon,  2 Nov 2026 19:22:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B59216B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:22:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3876B801A5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:22:33 +0000 (UTC)
X-FDA: 85391906586.09.C7BF1A5
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7816780002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:22:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OE3lDGfV;
	spf=pass (imf02.hostedemail.com: domain of christian.aurichzm@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=christian.aurichzm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793665351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gDbE7ZuFqAKZjgxEyRxAPTBHYtB2q95PfpD2xmbuaDw=;
	b=xWoclMnqaNwYPtNfF2fHd1lVCG1jkb/uTNI9TBtjtJVoDoyypUM8/JGmwWOZqp3gF2qyu1
	8XRJv3owj+M0iLTtkgX1YtJ75Mc3cTk8atwmzwnicJMi1WGi4Rn0kjwzgaMW+jdkb7HbWP
	umOTHnXJEBcgI1/OF6qeVYaLhy4pjhg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793665351;
	b=bur4Kk8NEYEHOoMSDMz5FAwECjdCPtWMIuUhcI9+0dQX80L1+yCfc2pokChxmjnZWD8yTT
	tVoNjTLLivfdDZ/Z3W8H+j/X/GB7s+xVnmdk0hoGneQg9OiYfq4QdmZxD2THZC8l2gzXyn
	SI4wXbDK7zm6KXRWlvHwsJXfc7GNqW0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OE3lDGfV;
	spf=pass (imf02.hostedemail.com: domain of christian.aurichzm@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=christian.aurichzm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7cbbb7b90efso853951137.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 16:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793665350; x=1794270150; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gDbE7ZuFqAKZjgxEyRxAPTBHYtB2q95PfpD2xmbuaDw=;
        b=OE3lDGfVGJsNEG0FwHbx8eO1/Y3yHQ2qaq4u3zIQnT7T4UljVwmC5VqFFgYQBNkaT9
         vqhXrrBDzYiJEjRdjTN6tuVTwe0ZlQrPk0vxTQxilJTxwbDBA4/K/YvxPF8O9CwP5wHc
         3y5JSzpd5MXnDKEGJAtsmbGJw2oBV2px/UbGDtnJ3vxnOI6/ic/ElJsWYkcbdCFNeTNx
         wPYW7ENUK/7L2UANJsxdU8CzmnWI3BsYqXE79nxEyXS4TwqPGTh8uMOhvGG80EqGLCX5
         zSUeLzk/OUH8CnPijHSgWt5B0NVuKI2Qj/84uIf9EeE0+bLtwJDGqxOq2HK2p6IFzt2L
         +fig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793665350; x=1794270150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gDbE7ZuFqAKZjgxEyRxAPTBHYtB2q95PfpD2xmbuaDw=;
        b=JPZVT5dk8qn2I9MdM5Gh3oImnNkd6VzqyTu8WvPhDOu9J9r4ATil337Gs+/o99XcmI
         HByni4i0AH85Q/XV+TkGl4Y/i8bN4SdO1bWqvreyTrDnZRiaDDNlUYrEqfove6VBKT8A
         gwpH2i7Mm917EqV1YiYhPhGKIYyBl95yDQx1hHi21Acf/Mhw3m4hkiXKcWA7j6XZOp9A
         6ftXdKViAKdd69gkyJ4PlBsH9Mjv4Fmlcvd0RQ5smc5F2d8NovsE43Bb9M7gTGWSRMHe
         UAAM69YjvnHWnCXB1JXqSCtNjdPxR9wsTXEfKNca/DmIKfwqF7VOqbwG+ZAQYxdrYiDA
         JTwA==
X-Forwarded-Encrypted: i=1; AKwUvBzS5D/w7lsEXE97r2PYyka9f0U9ivnnYvMtSHC1MFTzHHrVP0xmEqyJGItC4OyWFXjp2T5PwSWErA==@kvack.org
X-Gm-Message-State: APuU4Z9Os8D8fz52fn2u6NOKEkvS4NfzZCS6jS0QY9xDFwkm3EsZHQAd
	fqlXN1SfNax3W2IY4KiK5QZKpAMa4oBMWFg3TMbi236ZHS/2JiGXXWmq
X-Gm-Gg: AYBFou3EGA1ZfC8bqIxLGVTjxP613J7dx8mNrGrqHbX8qrHVbHfSnO0+dC+jwUuZJFC
	xWJ6wEjLSybsPm8Kk+O7Hps7Q0+A39zbbyboEhRG9BlgUjpILrZsTyiH48pY+lMpcQIZioZSdDs
	jpmeVdQnXPkeJ/U4Ur1i691886lnUeSdulvKYHMSjoDHvn9Tg7Ss/RJYngLBTfT3Ll6Bkhdvo0S
	/71NpjTJNvfmLqfYhEODLsccKSaspPUgKyyxbQtk6zI1XYqCDRplK5Tp2IPgwt7ipg5Lqnbi7mM
	VLlD6EEs5QY5rumXGhERVp8dF8Lggo4W7BtuQHYouYpc2fN8T1K8VvqfZSSDejUvXKq2w3ClWHk
	xFIRXtUITdTK/ZEoDOjqgBQLbetUWmU0/+T10sjx0Iwa//bC3gklP+TeihbGx0gZ6+JTY10WysM
	9RyuIWLoBPLbboiCryNfR3zs8k8uND4eh/orrli6sY/4Cunkt2KXFgGvEXRgXHi7i8S4J+CHhcJ
	CoOdK2cqf5j3b9kXeTfA2rpZefvm3yT3Wk0TtXOhbKLYqufYaCwlA601PCDBA0M5SdqsJZ8PT+0
	vCteXOaCP3ZAJY/OC0cMgMpQ3HSAD3s/7qLIMn0=
X-Received: by 2002:a05:6102:3e84:b0:7c3:9daf:f949 with SMTP id ada2fe7eead31-7d072658ceamr4113731137.30.1793665350135;
        Mon, 02 Nov 2026 16:22:30 -0800 (PST)
Received: from bridge.. ([2804:14d:ba6b:8339:ade5:3173:4b5f:f40d])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec76ec2e49sm8580338e0c.2.2026.11.02.16.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 16:22:29 -0800 (PST)
From: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
Subject: [PATCH] fork: Don't let copy_exec_state() fail before rt_mutex_init_task()
Date: Mon,  2 Nov 2026 21:21:57 -0300
Message-ID: <20261103002157.219277-1-christian.aurichzm@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7816780002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: i3ra9zg6e1uiwhh6xpj51g3xa73p4hma
X-Rspam-User: 
X-HE-Tag: 1793665351-443161
X-HE-Meta: U2FsdGVkX18sFx9O2Mjm1esvO0HeoMBpmCOTc+n52+CsjIcot6Bc4M7jwDXqDoiAhw8boR0BpXnelXr4DkC6m2MwLarDQTFwfezobDJ3QM4tEhazvs+BD3R/gnrzs3bNXak60f4UiQY9xtomaHGw3FJ6QI++oF+AYtCTt9cqbbtuXLjMrQRTVR7PlF9oGO0u/EpUStis60xTeIVbUQdAT3bT9nqbMGOzpU/CL+Cqnvzc74s2tpcOD+2g1Y/NgQ3i0PgNG33OhzPux1KfZQDkoucgltf5+zgZ2y26vtyu7tfxPMGga0nGtxe27XwoZ2v+nBUc28q9wO7JDDkQjOQu5uNegwcKCYBGkRu9CbM+haDhVdze2l3ED7Sm70vJPQd4I0yKVCqjYVN0C4A6k/u2ngJqgSrBDGdMiIRe0TYBZDTvchZ9kl9L+MoQzStS0VcIi2o1q13mL6QTDzma/OsnPHrvjcTnYO8U3Wgx9L351cYwqX1F2f/Czdqk/ShQkeTe8qASP4G1S1j/lmhyhGAjzAALq6DfADLfH1Hk1W0POsmMa03DTM0QryK9OXmXUYarmgjh+hiNjlTTtU4ypgWgKAzNVEA3+Tranpk+5n6rcjbAn0IA52URI4vuhVGyhAAYSMdCA1R9g/ts0iEKSWDdMi7Ju/a6yyJAcu7YlASzBl7nGlyoDg6K1ISNBuV+jMpOCBdaSkFRe64TBvmiU4aSl/BiEvuF+35JVTxTnEQ1hMmNHbcwv1f/uH9mLi8K+wjV10TZJPjixSX6n4OYhkF1m4wBwnITFPfn/NHBAg8h0SMZN4HoOGSP9c2ITSrnj78vAWWwdMdCfMPRBLEasTl3I/ajYrCF+pe3xMuRsTsB2pZTiLEc9nDwzaDDWH5KQXvxarRT4qoiaECLG1IqWpmqN04v3NIYaol9ZItotdyz/PpaFOJqU8Qv7bo0MVr8nlqqWZhi0J9cmvvJSvfYgN3
 3nuuwLVK
 qTDFL0Q4+ijichbXuxRXoVudi+MdIj36wf8tcmjQ3AHpmUDW6JcfbV6HtQrTlypyvJYazQUf+jQC73qZmMgnLrwIZxpM32Rm6CQXgr2YUtmdh1t9tYqWE5zzBL2w9q7ozO9c4OLcL/ZP4JCmH37COWPY1WqEZVyy2RELGqa67x31vffgkVWfPrUPZpu99lw53Is9dGK4hORP5IBv8ByGGoB6GHvI/u4OHjMVm0VKt4FZuqdNJKGbnXykgrV1Ci9tNyn191gt26Ot5m33jNeH8JJ5dKiOux4f6ttjkpQEx9TBuicKUUnq5rKYrtwPaPGcyJY79FeR/Q6ji6p+ENkX/nLskLQI6MytwMenzENWcLSEQSiLogvmaMMn9zZ0c54cm4vNgIhc5+TNUWe2MMcNzysUB+fm22zETWDFk+bHAtroQ+u0inydklsHPtftTnLLx72rbTnYKVW6HdQOZeKmO9ahB+ulctiAU5sjpZZtqC6rgVCc2hRB27CqiyuhZ/grVRqpG8qpfoXVazyUstEAZYaQe/oRHJKmG47XH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 6b1c66c9cca9 ("exec_state: relocate dumpable information"),
copy_exec_state() can fail before rt_mutex_init_task() has reset the PI
state that dup_task_struct() copied from the parent. If the allocation
fails while the parent owns an rt_mutex with waiters, such as a
contended PI futex, free_task() finds the parent's waiters in the child
and warns with CONFIG_DEBUG_RT_MUTEXES=y:

  DEBUG_LOCKS_WARN_ON(!RB_EMPTY_ROOT(&task->pi_waiters.rb_root))
  WARNING: kernel/locking/rtmutex_api.c:538 at rt_mutex_debug_task_free+0x7c/0xa0, CPU#0: repro/75
  Call Trace:
   free_task+0x34/0x80
   copy_process+0x5e6/0x2550
   kernel_clone+0xd7/0x420

This also turns lock debugging off until reboot, or panics with
panic_on_warn.

Commit 08cacffeef8f ("ftrace: fork: Initialize function graph state
before copy_exec_state()") fixed the same problem for the function graph
stack. Move copy_exec_state() down to just before copy_creds(). That
restores the order from before 6b1c66c9cca9, where copy_creds() was the
first step that could fail.

Fixes: 6b1c66c9cca9 ("exec_state: relocate dumpable information")
Signed-off-by: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
---

Notes:
    Reproduced in QEMU with failslab on the task_exec_state cache while the
    forking thread holds a PI futex another thread is waiting on. With this
    patch the fork just fails with -ENOMEM.
    
    Based on v7.4-rc1.

 kernel/fork.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8b108ed37152..fc12100e24d6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2147,9 +2147,6 @@ __latent_entropy struct task_struct *copy_process(
 	 * free the parent's ret_stack.
 	 */
 	ftrace_graph_init_task(p);
-	retval = copy_exec_state(clone_flags, p);
-	if (retval)
-		goto bad_fork_free;
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
 		p->flags |= PF_KTHREAD;
@@ -2177,6 +2174,13 @@ __latent_entropy struct task_struct *copy_process(
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
+	/*
+	 * First fallible op. Must run after rt_mutex_init_task(), so error
+	 * paths never see the parent's PI waiters.
+	 */
+	retval = copy_exec_state(clone_flags, p);
+	if (retval)
+		goto bad_fork_free;
 	retval = copy_creds(p, clone_flags);
 	if (retval < 0)
 		goto bad_fork_free;
-- 
2.43.0


