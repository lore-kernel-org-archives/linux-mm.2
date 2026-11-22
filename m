Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F48606A334
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V/Zo18nh
Received: by kanga.kvack.org (Postfix)
	id C0A666B05B1; Sat, 21 Nov 2026 21:13:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBAF6B05B2; Sat, 21 Nov 2026 21:13:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1456B05B3; Sat, 21 Nov 2026 21:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F52B6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:13:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E70A340639
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:33 +0000 (UTC)
X-FDA: 85461133506.23.2C10E37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51F3F100003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/Zo18nh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313612;
	b=GpZH4YpiWG+sHL671iyc8w+4NM8nVxQDxTrStx+72SmYS/A+e1Nk0M+8XJZoGVifxOGRZ6
	3dROppl0Nw6pC3wQvH5mb8vHogCzcw3irWKgspDxFatXm+gs4pPmVbiAMou4cQXbTrzkQE
	Li1jI4+xVF1B64hzqcVLPOwYs+V0udk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6onxn2SinNI7aDwblXFHgIt801pm4vHKztESGvGpEJI=;
	b=yhO+NxxWfes+SkKFJYGTQ/oLa8UhddD4Nj1CLWZKyHvgw6xQQqr12WGAvtjDgEwoi5tfCO
	9o6eMNrSat/aiIQXeXq8Q6bmuMD9C7AXRuhIwaXhdBNUWiy5Q8+nW9G2SylAe7uF6sThTw
	h5NBLoLDuJLdoxKqbZT8QEzNPA5nVao=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/Zo18nh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79885455B0;
	Sun, 22 Nov 2026 02:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68491F000C6;
	Sun, 22 Nov 2026 02:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313611;
	bh=6onxn2SinNI7aDwblXFHgIt801pm4vHKztESGvGpEJI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=V/Zo18nhbvS+GdkUZnSRduvKQP7SwU1hnOnfyDwKPrDeF9kw0HnG6Fmytp4RuPcc4
	 HfjdoGTbczc9OOYW1q0xE+1zzoPmoit/tUtcvaC/jc8PZtJ3DParoZ8dzgaFLOkCOt
	 96THICVwPgRWc/b8UGWlzqRA+D6MBHzOzWkVM2AYcUoe7cQYP1p5TcsL7AqVTox6cl
	 m8NDk35Dy5mxDQz6qWa6daqB6ki8PtmASiGB+KWQJt3q2xnl+WNbTlvE3F4HZkvPcQ
	 AvwHVxHJFcsyUwb/RkJgxHxkSeidwB7YiGU9KENXXAas4XWXe2rNgkjx0W15n/Urz1
	 xi3VlQHaKI2TQ==
Content-Type: multipart/mixed; boundary="===============4694831360438668141=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <5bdbcf00cb4e4471bbae9999b2dd8ee652650653ac4182840c5c0d416229d7ef@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-12-jarkko@kernel.org>
References: <20261122011809.2667684-12-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 11/26] userland: Track init lifecycle via copy_process() and pid_namespace
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:27 +0000 (UTC)
X-Stat-Signature: 64cx7uo6gbzyoyrnq1cc8gpn1hyn3i8e
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 51F3F100003
X-HE-Tag: 1795313612-454058
X-HE-Meta: U2FsdGVkX1/PY+lRQqEjxcPqR5gUnjgzAyz0HPVB3UU54RK6fBMM7emZDJUHbvgsrF7Wvmx2M2mOT3WFjVkT3Qvm4kbc+VJIr/kC2BYwvTHTVjpB9KuR+yV7vAuSDCtqQ2k0IG9DCZnuFSymVIPIrFz+uIkicpIESYKl5Dapku8mjkiUAgHWCtjArMaoL9i7tcHxmpzZ7EwpHFIPMXzLxZriMKM9aLRz1RGyfXEtr3BgYPQ53v3liI2BNbUwNJuvcLhB7lBCm712X0x1VkvEDuQIyHXFfR27KRMepzwJALO6THcLNRqBU9ifRN+ubDwLOJ16g2zLqayOcWae+s/H9yzN0YCSHbv7SLiP/9AdBapHP28d7d+cVyXqnSN4Bnd1dwItVjqsdB5FMjMYcF+Am9q7/Tch2RiytBGQsh3mJ+YOlaHPHFgFLpTcHzHvxK08YZfyv0LaG3xW1p32QhFF4tyBt9Qia9+rFkVFnU7NEqZjH6907VW4LfVoHgHXcLnoimxu6BVaBjxU8Ijao798MVbKTDUUXbN6It9ztzPvNtYbADOXb3fvUajzJXQp09IbMGh6n5L5nQ6QKDKpOdFOjD8FR6Ts+jLj5G8sIVPb6maaf9Jwuv5qSQPqLL6uhs4L1X/rKCrWX13Cwv54FV3CurIznWMC++L2ST45f40diJNcpQb9St03xHpdMmwsMTaSDKEoacyLJ8aYg/0//v+9zj2bZWlks4eHmpqbenwD7pW08jJniLSggk3ujLnT2lzDBkSjhUcx/SIqHfIKyLZwUoFiyVvmrNapL6Ujs6jF+qfZzpILEjwYmcFDTbrc8z5jqkZ+DpRwQ/2rfj8lm2CT6nmb3TNKHRsoykOtb2g6Yyiq9tdifMAnxBSrqw0vXryLnnkUAScbxVlLSnuwXvIPbmOflynpN6hfTPb0oGspnDbFp8VSxYgTRomylLSMqFHKeccvgZBsURqCxtzliQa
 sp+UnbMt
 8rlRNPcbdHrphzcLmDvGeLKloexvw6T1WsFwyf4+D44QFnlWPNq4zmj6f3mJYhmcQsj8wb0cP+bzKZ/EEODCqVz8o+k/DqnSCdTLJrlU01lAns2R/aS0hJTbBWvH/X6Q0Yq89grtMJk9ZzDa01bQHKO65C6lVsyjhprCjyeGMs/P47FHjRFZFo20OTMSgShfeuTB0CMEpxg4uc/cPbVnDr17jorn3xIICj4uPePzXT46WqiVp7mt9NsrcG63K4dxNCwhmVwY/tl13A3JW4ja66xte48+ADf9YlkylW8WjV4oVXVm5I/oGAJHJFmDugM6hWGi2AjthGWyFu4w1LQmItU2C+ZJuSQfP6GwzcxTJHvagdoC3HzjFE1widcjZE69hHM0louuBcSBRXrZidKL1KX3AIw4NlLUFQWWh9d5NiHLYLpWe4fBH01xRscSeX4ev+SaISay7lBExEXrgR8EWMjbqFsyiN9gbpBQ6WInZZzr+hxwjQhmM4MAHj35o7YbNXRKwGPoDLjxIakIGT0E5KMrn6Uhrh5V3a4Bld18Nqydz4PZ+0vGEO481Os0u+ETBQXN0XzC5o0IMofpUJ9x8EiA0GwkDF6kxs5xSRyvjvbJEMJtx3W7Sy+Zon5ITZJHv+Ns1JhegQNKar0BBAgdqWgOk+0k0cr57TZ35vBMi/lJ7N99mcFZvVd09+RYKoFOe/XhlR9sc/QddX6A16y6aRWeJH2o1vg8uzRKJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============4694831360438668141==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Track init lifecycle via copy_process() and pid_namespace

TL;DR: userland_copy() may take c->lock inside siglock and tasklist_lock,
while c->lock is taken with IRQs enabled elsewhere; this could trigger a
lockdep report and a possible deadlock once CLONE_INTO_USERLAND goes live.

> diff --git a/kernel/fork.c b/kernel/fork.c
> --- a/kernel/fork.c
> +++ b/kernel/fork.c

[ ... ]

> @@ -2573,12 +2574,14 @@ __latent_entropy struct task_struct *copy_process(
>  		attach_pid(p, PIDTYPE_PID);
> +		if (thread_group_leader(p))
> +			userland_copy(p, pid, NULL);
>  		nr_threads++;
>  	}
>  	total_forks++;
>  	hlist_del_init(&delayed.node);
>  	spin_unlock(&current->sighand->siglock);

[ ... ]

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c
> @@ -82,6 +82,49 @@ static const struct file_operations userland_fops = {

[ ... ]

> +void userland_copy(struct task_struct *tsk, struct pid *pid, struct userland *c)
> +{
> +	if (likely(!c || !is_child_reaper(pid)))
> +		return;
> +
> +	scoped_guard(spinlock, &c->lock) {
> +		if (c->state != USERLAND_FORKING)
> +			return;
> +		refcount_inc(&c->usage);

Can this nest c->lock inside siglock and tasklist_lock in an unsafe way?

userland_copy() is called from copy_process() while tasklist_lock is held
for write with interrupts disabled, and while current->sighand->siglock is
held:

    attach_pid(p, PIDTYPE_PID);
    if (thread_group_leader(p))
        userland_copy(p, pid, NULL);
    nr_threads++;
    ...
    spin_unlock(&current->sighand->siglock);
    write_unlock_irq(&tasklist_lock);

siglock is taken from hard interrupt context.  For example, the ITIMER_REAL
timer uses a non-soft hrtimer, and it_real_fn() -> kill_pid_info() ->
do_send_sig_info() -> lock_task_sighand() takes siglock in hardirq.  So
holding siglock while acquiring c->lock records a siglock -> c->lock
dependency.

Every other acquisition of c->lock in the series uses plain
scoped_guard(spinlock, ...) with interrupts enabled: userland_release(),
userland_exit(), and, from later commits, userland_prepare_fork(),
userland_finish_fork(), userland_waitid(), userland_get_nsfd() and
userland_share_nsfd().  That makes c->lock hardirq-unsafe while it is
nested under a hardirq-safe lock, and lockdep should report "HARDIRQ-safe ->
HARDIRQ-unsafe lock order detected" the first time a userland is
bootstrapped on a CONFIG_PROVE_LOCKING kernel.

It also looks like a real deadlock:

CPU0: a second clone3(CLONE_INTO_USERLAND) caller in
userland_prepare_fork() (or waitid(P_USERLAND), or USERLAND_SHARE_NSFD on
the same userland) holds c->lock with IRQs enabled.

CPU1: the bootstrapping parent is in copy_process() holding tasklist_lock
(write) and its siglock, and spins in userland_copy() on c->lock.

CPU0: takes the parent's ITIMER_REAL (or a posix-timer) hrtimer interrupt,
and it_real_fn() spins on the parent's siglock, which CPU1 holds.

Neither CPU can make progress.  This looks reachable without privilege,
since userland_open() creates its own user namespace and the caller holds
CAP_SYS_ADMIN/CAP_SYS_CHROOT there.

In this commit the call passes NULL, so userland_copy() returns early.  The
path becomes live with 498ccb2ffbc4 ("fork: Support CLONE_INTO_USERLAND in
clone3()"), which changes the call to userland_copy(p, pid, args->userland).
I don't see a later commit in the series that addresses this; at 942764a55437
every c->lock user still uses scoped_guard(spinlock, ...).

Should c->lock be taken IRQ-safe everywhere (spinlock_irq/spinlock_irqsave),
or should the FORKING->RUNNING commit happen outside the tasklist_lock and
siglock section?

> +		ns_of_pid(pid)->userland = c;
> +		WRITE_ONCE(c->init_pid, get_pid(pid));
> +		WRITE_ONCE(c->state, USERLAND_RUNNING);
> +	}
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============4694831360438668141==--

