Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A67606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UrMQqI1g
Received: by kanga.kvack.org (Postfix)
	id 09AA76B05BD; Sat, 21 Nov 2026 21:14:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B166B05BE; Sat, 21 Nov 2026 21:14:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C2C6B05BF; Sat, 21 Nov 2026 21:14:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C403C6B05BD
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:14:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E39C14063E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:14:11 +0000 (UTC)
X-FDA: 85461135102.25.37FA4DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A61F9140007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:14:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UrMQqI1g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313649;
	b=AdlBl4lPcbhoUYmn9EZRAETDpisqhIhxofNo3GrWYpr/vQRoKkbbu10IhO5PjSyF9wKOta
	lVWlJoQOF+hfMj4X4hlU0D30Ssz/hwudcxMI3E0FdaIMkCOK806Qpxmh5TlIUUEOwr6LYT
	e1vhbjEnnDZ4PSEoax8kSECq7hf37RU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGkV5IvqRbWZza57W8pwFxFV6A6gni/+uOQ6Mx1vB6E=;
	b=vECUgNZgUP5BHbp21CxcIDMKYcuDl74TAkLAUeLU4wcKpguExcSWL5XXTArAwSnp2QJwx3
	M9CbCHJy0SC+6VViYyInWq10Cc+42geWEdPGdD31oVFPXZ87jU9JPjJlSjjmpYm6vj1Yfi
	k3aGmKDmFtCa7l9ovaHffoSoJg42+28=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UrMQqI1g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 391316146D;
	Sun, 22 Nov 2026 02:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8B71F000D2;
	Sun, 22 Nov 2026 02:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313649;
	bh=cGkV5IvqRbWZza57W8pwFxFV6A6gni/+uOQ6Mx1vB6E=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=UrMQqI1gERAVF9Rw130xSdAu4KNhRVPEMIF+LQbIq4vclZ9OFR+nOGIsxEzhB/+DS
	 rXJVxEZeJiech9JiNW49jUQU6Yhs2nlpwVTh51wTClecfSla7sgQI1ranCFuA47V+b
	 exCEw/MQnkRWmA2fKib+RZzjoQywc4nS1EGqgRrbylS3iSb8sLNTZrg05oa4WgfDvu
	 0OMhk58lbfal1qf0wbvOsGkSiCqtOK5+vkLG/Zex5UDM7F2pXqH2wJEqPmT4kJRHY3
	 mQqGBuZk4oQw9rx6sDCK+ytGMhKBJha6aA80ZKdA0/BbfeloRq0tPcw8pdlYsgZ+nb
	 hhZ0D4CzEc6Vw==
Content-Type: multipart/mixed; boundary="===============3571640751418729453=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <9dea540cf8e18ede2f8471a0a677bfd6dba4a416739a03a462e6797da6a0c51f@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-18-jarkko@kernel.org>
References: <20261122011809.2667684-18-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 17/26] fork: Support CLONE_INTO_USERLAND in clone3()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:14:05 +0000 (UTC)
X-Stat-Signature: p4aqiq5rmmbh38sssc8pueucrw8hi6xe
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A61F9140007
X-HE-Tag: 1795313649-183951
X-HE-Meta: U2FsdGVkX18FeCmnb+hrGzgXazV0p4Ebii4VuklkfIFPlihZFcqzCpFrMFsnbYaDW585/7Iz96YDjVGInB6HXJ2PA5rvbdj32082txxGogJvBpSSB0NXRpg/XaU0Vzq8WOB7hOKZ9ZRuZDs//dCk8Yv5ZsOp/9rP/9TTVwlasSY7fRiTwBRzSd6jh40Ih2AM88yS/AM1VG3AmS/P3HWEhBwjAh9N6eBwJciaocBSGsILu/CRZMFFa/4ucTFmDg7Hi24b6S6/4glwpj8WAAknAVUjXx14pnu/mXa5olsrevKuUHO1ZDSvU/x84HcXF+0kmZDeqwQhHQSMD+EfanqQV3nSNr8Vp4Pcn9aaWX/C8b4Gw/Ll0uxRN+nSPQsD+HTky8B88KownG/iDfq/97Qky2E+i7L/2V1E/dkvDEQE43hoAkdW+dm/AfCI0tC7B+O0Y0rLcv7JW+jc9WTpT2oAdcgOGpUfvdXaYmquEmUkeqrmPpLUpLVmptXdOdWZme/ayAEuOs6AzJEBGXvtBDdy2GAABBi8xvE8OfSfzgNl+LXAPFWHUYKw807xMIb9Qw2Y1/sFSm5wBUOZNJB9QNefudoDx5V0oTsf8k2hRJCvHe9CFa7150e/5s3V/BOIlYiu5WnWMW43G+i7HlrbviejX/rR69ysM+yQ/l7BAJQeF+mUgPXq+bZ82Fkn3Q8ynv1W9csTY/fGSlZ28l5A5F2VSNz+AEU85BiT+ADnljPcOQ3+uImm1Yrqt6rMe2x//+ZJ5yoZCwWc+a6RkcKDKjuzc+cZraTuPTabsdW6mI6L4ESoEDtzRueSb0KFw+lDIi3JGqh9caZi37qxO8mS7PXZyjJQsKo6kGOD+E/Yi2PJfQtLr9z4JjwfKRcIcfBdVN0wBAGjPX3q2CgK04xGZtONi1v5WwH8YPTBpJd5dgcDX24eoKj5JgmKm5cj7x90CQC95pCIUQ5YmJ44/5/UBZB
 CTmoIQgr
 PEm3OvJpktNQSE5UulaiPRpOE07TgIAkMoxI3mBB/pJguV3LVlYwMgdoQBhLa1DM3rN5x4dQ7Kco9k1iaD75bBPY7n3aLd0lhEHyesnGM2E0t2CcVjLHfCQdFG/B6CDVF1QJhdC70kvGYyPwRHnXKFxa2CVc3N1PTa9m7aHQB5cd2rNQ0tJvFR64EIm2/5EntFNBJUgZjkrmkyWN6UK/60eXbULOLgW+g7Vky53KtibKkBpfvPqWNzP5JCylGU6jFAZcGu1tlBHiVt9Yc77yloIUuwywxTh3yArUG2H6fXO1em5N6m55hoEXgXT70JFng2MP+b28UECs8dJTGShoU2TBFTcEWh4EVH7pu4z63eQjY0WlIQ7TmKi/g3AA6PgZlA14aOFmtOcCNAXvIJbCrSQPyXH8tpYR2GJG5+za5l0spBzBLzMPPmyexH0YnflTr1KBEEd5K5AgEdnjQ1bu+YhM+Sb7/g5Sn3Xrb3ukgf2UzGJpLOLdouG/KOjaESxLOUacJP2fnMBTcYeAx20tXOGaauj3lzhBy+edVh5zpyTC9JNlmozobTkjfuDWLfh93cmX86ZVJFinaQa6NA/W3rc7gEZJ0mH2mp1SQLNRl0yJRnHo17aOsTsxwxQuCxN1IkIo6cv1pDHfZfoGmwPbrkMTg4mK1C63Wqqs3lH7sXof9MIN4nK5BQohQOMD6RbTvgfiE0WJfehhwMe03wMxXsYbWj5zthQefkZHB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============3571640751418729453==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fork: Support CLONE_INTO_USERLAND in clone3()

TL;DR: In clone3(CLONE_INTO_USERLAND), userland_copy() takes c->lock under
tasklist_lock and siglock, but c->lock is taken elsewhere with interrupts
enabled. This may deadlock system-wide, and lockdep may report it.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 2fceacc17e8a..3dd2c098bf32 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c

[ ... ]

> @@ -2578,7 +2599,7 @@ __latent_entropy struct task_struct *copy_process(
>  		}
>  		attach_pid(p, PIDTYPE_PID);
>  		if (thread_group_leader(p))
> -			userland_copy(p, pid, NULL);
> +			userland_copy(p, pid, args->userland);
>  		nr_threads++;
>  	}
>  	total_forks++;

Before this patch userland_copy() was always called with a NULL userland and
returned immediately.  Now the bootstrapping CLONE_INTO_USERLAND child
reaches this in copy_process() while holding write_lock_irq(&tasklist_lock)
and spin_lock(&current->sighand->siglock):

    void userland_copy(struct task_struct *tsk, struct pid *pid,
                       struct userland *c)
    {
        if (likely(!c || !is_child_reaper(pid)))
            return;
        scoped_guard(spinlock, &c->lock) {
            ...

sighand->siglock is taken from hard interrupt context, for example
it_real_fn() -> kill_pid_info() -> lock_task_sighand(), and
posix_timer_fn() -> posix_timer_queue_signal().

Every other user of c->lock takes it with a plain spin_lock() and interrupts
enabled: userland_prepare_fork(), userland_finish_fork(), userland_waitid(),
userland_get_nsfd(), userland_share_nsfd(), userland_release() and
userland_exit().

Can this produce a HARDIRQ-safe -> HARDIRQ-unsafe lock order report from
lockdep on the first bootstrap clone3(CLONE_INTO_USERLAND)?

It also looks like a real deadlock is possible:

CPU0
  thread T2 of process P, in userland_prepare_fork() or waitid(P_USERLAND),
  holds c->lock with interrupts enabled
  hrtimer interrupt for P's ITIMER_REAL runs it_real_fn()
    spins on P->sighand->siglock

CPU1
  thread T1 of process P, in copy_process(), holds tasklist_lock for write
  and P->sighand->siglock
    userland_copy() spins on c->lock

Neither CPU can make progress, and since tasklist_lock is write-held, fork,
exit and wait stall system-wide.

Should c->lock be taken with spin_lock_irq()/irqsave at every site, or should
the FORKING -> RUNNING transition move out of the tasklist_lock/siglock
section, for example into userland_finish_fork()?  I did not find a later
patch in the series (up to 942764a55437) that changes this.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============3571640751418729453==--

