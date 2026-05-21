Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E37CD4F5E
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 10:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D57F6B0088; Thu, 21 May 2026 06:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7865E6B008A; Thu, 21 May 2026 06:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C346B008C; Thu, 21 May 2026 06:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58AD76B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:05:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B6681A0581
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:05:10 +0000 (UTC)
X-FDA: 84790993980.22.78EE023
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 780A818000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:05:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1dDc0sC;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779357908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbLOgZd32iQehtszHcbB7d5lQJ2qz4nSY8UqPK6VTos=;
	b=nclroFfXCo+pDXIjMWbCs5p53lEUZxJX3Hkuy91MIEzcAvybjiw/i79UZIXXj9byFrBAw3
	9Nse7CvQejZCqDLtsufVZOnAhCs3F91USSYYsEwueMlF5insUgtjmSN79RtyujyYPoBghz
	KnWKLyMrbXNJtBr7YTN8PR37/7YXADQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1dDc0sC;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779357908; a=rsa-sha256;
	cv=none;
	b=yB+Sl7Hea75FKbG0QStEXmw6kPzbqg1FxXcpZgarSvlrpmnhyw4SSJg8R7HYSN0gnHbBR5
	kffE1FJHMxvU6AQhFH5L30y36EIrq+ZQ00keYhRVXp3pHJ0TQjqOKeYy+QURfFMCytX337
	gLsFBoSqVvb2YkUxFc8toaAppCK5Bzs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED5A060172;
	Thu, 21 May 2026 10:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BD21F000E9;
	Thu, 21 May 2026 10:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779357907;
	bh=SbLOgZd32iQehtszHcbB7d5lQJ2qz4nSY8UqPK6VTos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B1dDc0sCNPw50Ljvuc1RZhrqFYi2fmcE+cIHJ7P/bYfcZuKcRv9wYXlH1i4buuzlo
	 paksh1t5tvw4ixy2VNpvXckUQVsr/u/0P4MIW1NfD9EPknsquVHKP+PIzH4mMbA8nG
	 45ImzHMgccUtqdXF4bvZMfs2LT07M6LG8Cm504GepUZHPpuQCN3gXg20dY8AxJVoEG
	 tlL0d4a9yFc42umUlU2zZIlHJ66vvjyzDG4aZsOOLjKYlUiveyNJiSp9jnEBsRVYfk
	 ePDu9x/4ziC61YBltddi6a2fZJHmSHHsJ1dBhZ8FbxWXxZeEX+MsVmQDIN/SRtxUsH
	 S0BevJdXtW9mg==
Date: Thu, 21 May 2026 12:05:01 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v3 4/4] exec_state: relocate dumpable information
Message-ID: <20260521-teleobjektiv-sparen-a52b4ef25781@brauner>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-4-69f895bc1385@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260520-work-task_exec_state-v3-4-69f895bc1385@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 780A818000C
X-Stat-Signature: xpxkjbay8tpqp4t3cjmufc13iekc3jf5
X-HE-Tag: 1779357908-306566
X-HE-Meta: U2FsdGVkX18mhnQWLluuIP8N/c6epT5k56g2SG9rmxOn/GBzzQMFhcD3hsEEfEYDaPCqpcjNV1lRn0o8MPdfxkEgtl7Ol4j57O2t4J3OdPI/7g877BMbpW4rKcwzE4s4h0whIbmt0fdEfx3CYNEsCU9cs5tZtf8R+USUgmo+6g5COHva950K4LKSN6ZKmHuqoMudnq+MKIe1SKQboKazkoy/m7CLtJE8Mr0KV9kKBIro8XQu+YGj+qM1a5IRk2PhAaH8VkDPtZT+jiFZCNgQPfaZXcYhJFFyAHm9Kghu+eruI5S2BCCX8exaoGRQkl9Ld3XmfGVIdQ0G1yDDpKiU7jhMzi/krcoWdIjg+Kih6OAeTLL3OUNBhV/kXvhWwy3Uw/mt7+hB3T1Hgc10NdUNdUyiGmZccmj6LPddOUaHSBOXwPEmrBcO3FqSMxTjGvuT+xZqNX+pv/xg+9hE1Or+UrXZ3q+CRSy2anQvwg1Gh3EKYrZ/16W+5+OS3E4iNdanoLoeAQsL4/dzvPTLQ8BGrTz45I8PQhWsjzygRf13d/CtgUx5lX5yuaFpmXK6oTPqxoTxj7ZFCIzZBvng9Teeams7bm3qVHBBYMMrTCa0rZ9g4vLbnSIgHRpF/Et8xRTi31NS/Z2XtH7a/VEAkGc7QDn3zkwtkDDaqVmLj7D5308dkUYaoWh2XNn6iOVmq+8iv4IMXMURaYysCiIptsCrLryVDalPMAFW6V6NQW5tAB+hBC3npCpqU2Y1Ws2getM7BmVqWuYO6X9c42uuR1XV7SXEmTUoAEQBCOzhiR3xqQSTBwVx5+/jZBGR0APRyfdt1BfXSUkqFF+Hb3MhI9jOwoXSTBqfrZ6wOc9TOnivcgcLc1S99cBUHeQD6NpJpXW6Ra0p0dFCaazxj46KJ3pKJei4YDX8rR7KsSJdJI8lJv0BCJZighzxVscvs84DBuXOCP0QXYR01OO6Kfr6zNW
 cpb4t8d+
 U3vfZQ4b4rXewlNwmPmumTXAx5EyS3Xxf/MDnYGMRvcJxqtyhRNJk+Aqt4eoutYNC/JHUtOQNj28QQXM04E86hqRY5Ob1SErZvMwK46Qelwqo4scSo+PGzzwym1RDLVKdA67xS/YwuFPzzSSj/xienEm5yY/8+JyqdfCarH6oV/FBlztiZ2x7vENtHCaPg/kK2sTb6cFL94EefcPgXqsgSI3rCeO63vHlykc2ra4ENMij7rqyhse+2nvEPXO+Wgr8w0JEOILXCcUuE4rDlkkHKogWWnFYnQptHbk62QmkTIEovvOjAxcMiKFw1/nB3nf3iK8sN3/ClvC9TKK9bcjLAFIN4GuCeT6Ar/lD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -384,8 +384,7 @@ int commit_creds(struct cred *new)
>  	    !uid_eq(old->fsuid, new->fsuid) ||
>  	    !gid_eq(old->fsgid, new->fsgid) ||
>  	    !cred_cap_issubset(old, new)) {
> -		if (task->mm)
> -			set_dumpable(task->mm, suid_dumpable);
> +		task_exec_state_set_dumpable(suid_dumpable);

When looking at this I wondered how the hell I ended up removing the mm
check and that was from one of the prior versions. So this check should
stay and I want to leave an explanation why.

So the check is obviously needed for two cases:

(1) kthreads

    Afaict, we don't have any kthreads that do commit_creds(). I think
    that is system call path only.

    (1.1) But kthreads are created with CLONE_VM and thus all start out
	  with kthread->mm == NULL and with task->exec_state shared as
	  well. So having them end up in commit_creds() with the
	  task->mm check is fine as we won't do anything.

    (1.2) kthreads that make use of kthread_use_mm() may _not_ call
	  commit_creds() in any form because they would alter
	  dumpability for all other kernel threads because while they
	  have assumed a new mm, they have not assumed a new exec_state.

(2) user mode helpers

    User mode helpers are created with CLONE_VM and are created as a
    child of a kernel threads but aren't actual kernel threads (in the
    sense that they aren't marked as such, +/- a few other details
    irrelevant to this).

    So at fork() time their umh->mm == NULL and the exec_state is shared
    with all other kthreads as well.

    user mode helpers _do_ commit_creds() but before they went through
    exec so umh->mm still is NULL and shared exec_state with other
    kthreads is unchanged.

    All umh's go through exec and afterwards they will have both a
    separate mm and a separate exec state and so it's all fine.

So I'm going to fold the following diff which asserts the invariant that
altering global exec_state is not supported:

diff --git a/include/linux/sched/exec_state.h b/include/linux/sched/exec_state.h
index 23fe4b55e010..9b61782510b8 100644
--- a/include/linux/sched/exec_state.h
+++ b/include/linux/sched/exec_state.h
@@ -16,6 +16,8 @@ struct task_exec_state {
        struct rcu_head         rcu;
 };

+extern struct task_exec_state init_task_exec_state;
+
 struct task_exec_state *alloc_task_exec_state(struct user_namespace *user_ns);
 void put_task_exec_state(struct task_exec_state *exec_state);
 struct task_exec_state *task_exec_state_rcu(const struct task_struct *tsk);
diff --git a/init/init_task.c b/init/init_task.c
index 47a651b05058..8cad78da469c 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -59,7 +59,7 @@ static struct sighand_struct init_sighand = {
 };

 /* init to 2 - one for init_task, one to ensure it is never freed */
-static struct task_exec_state init_task_exec_state = {
+struct task_exec_state init_task_exec_state = {
        .count          = REFCOUNT_INIT(2),
        .dumpable       = TASK_DUMPABLE_OWNER,
        .user_ns        = &init_user_ns,
diff --git a/kernel/cred.c b/kernel/cred.c
index dceb9fa4a4b4..3df4e15bd67f 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -384,7 +384,9 @@ int commit_creds(struct cred *new)
            !uid_eq(old->fsuid, new->fsuid) ||
            !gid_eq(old->fsgid, new->fsgid) ||
            !cred_cap_issubset(old, new)) {
-               task_exec_state_set_dumpable(suid_dumpable);
+               /* mm-less tasks share init_task's exec_state */
+               if (task->mm)
+                       task_exec_state_set_dumpable(suid_dumpable);
                task->pdeath_signal = 0;
                /*
                 * If a task drops privileges and becomes nondumpable,
diff --git a/kernel/exec_state.c b/kernel/exec_state.c
index 814a475fc786..2b7d0262d0f4 100644
--- a/kernel/exec_state.c
+++ b/kernel/exec_state.c
@@ -95,6 +95,9 @@ void task_exec_state_set_dumpable(enum task_dumpable value)
                value = TASK_DUMPABLE_OFF;

        exec_state = rcu_dereference_protected(current->exec_state, true);
+       /* mm-less tasks share init_task's exec_state; never mutate it */
+       if (WARN_ON_ONCE(exec_state == &init_task_exec_state))
+               return;
        WRITE_ONCE(exec_state->dumpable, value);
 }


