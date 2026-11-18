Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A3C606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aANdbQzD
Received: by kanga.kvack.org (Postfix)
	id DE3BE6B05B3; Wed, 18 Nov 2026 11:17:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94826B05B4; Wed, 18 Nov 2026 11:17:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D0A6B05B8; Wed, 18 Nov 2026 11:17:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90D926B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:17:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A76112076C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:17:42 +0000 (UTC)
X-FDA: 85448745564.06.EB72ED4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 711D11C0007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:17:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aANdbQzD;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018660;
	b=4FcTRQ4pfBOr9LJhXeMq32ZgiN5tGZgakhklsPhZxdh9Xx7LgE8FlzwWTryieHDntQKLmv
	XqORY/jdMJPFEWZhUK8TEkvJgz4M6c5Cc7kN2q36TMERG35SaQNIQtFFV2k1TYl7EDABN6
	pWG28y3LzpPk2P8TyGz77xBEogO1zy0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aANdbQzD;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018660;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InHTzzK6ZC7JR1Wha0zAXjzGbM36Wf2d3IDb9mp3/tY=;
	b=tQP7CFSlOdwXxmmK3P2tuTxlczIAjE9fILV4dGKM7XsNGhjKGxwW8WJ2l5CnDi82CLPuLM
	IdehORcu1LvkzYA8QkctKElSuhdSO5kDQ20ts4OHo4Ps81IbVkTB4c8OdBURCf6SD22UFc
	gpaIKKk/Dj1djmyMUonEMy7QOG9pZvQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC0826283A;
	Wed, 18 Nov 2026 16:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874FD1F000C5;
	Wed, 18 Nov 2026 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018659;
	bh=InHTzzK6ZC7JR1Wha0zAXjzGbM36Wf2d3IDb9mp3/tY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aANdbQzDO+NBL3W9S+L+5PHqyuWzXxIMJkEYgTx2lHDw94Wx9jkCSD7dVnG4hWDvw
	 WSY8EeDsJKYbWZGgFxaocvTa+/Jq+8ogy8DS+3uULIdTMPbgT5bkjY4Q3fZajNqlET
	 cRkSTBccMbylr5E4bm8iYc+QCUjoto0VJnppe+HVaLmpZ//D50bFnP7hGTQjZlvBsm
	 I8W7me/CYlflU+D2ff6TbaXuFuoRxgt0f13NnjHUz+s5TWoryt3yQzgbxDi7mXuWIH
	 oAaHXJhHfVQNW77OWNA7oIg4GU7XBxxIsoiZTz4Qsrt3WIey2XeH7zpgTzLy9Z+30f
	 68T9yk0Wo8TmA==
Message-ID: <sashiko-outbox-221445@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/17] sched/mmcid: Give no concurrency ID to user
 workers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, tglx@kernel.org, peterz@infradead.org
Cc: mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, paulmck@kernel.org, boqun@kernel.org, shuah@kernel.org, kees@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, oleg@redhat.com, bestswngs@gmail.com, xmei5@asu.edu, xujiakai24@mails.ucas.ac.cn, linux-mm@kvack.org
In-Reply-To: <11039c504295ef6ee0eef55981993d8f5d1f40ce.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
 <11039c504295ef6ee0eef55981993d8f5d1f40ce.1794932121.git.mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 16:17:38 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 711D11C0007
X-Stat-Signature: yiociyi9ug7ozndqs13bhm159rciq17x
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795018660-252552
X-HE-Meta: U2FsdGVkX1+yLuRMErY09ko9K30xZkwY8JYjq2LzD+VcpGAP24EgF8yf9VJZcKDyXklsuGo8OhLE02y8pVfAfp4n3Wvl4Qlt3hn/GakQpNZNXuh60vpMqJm0XUuzMGXd6nJDWtmcxKF9D0XzgI3E8z5H+xRcUWCWq0uNdOyaO4KTei5FUDn4ZEYmf8eZnE6+TOwgLydBh65CMEArY9b8nTznj0S4LDvN9tkVApQb0WYMDSCELau0NiOlZHr0vI1WW86Tbt6nAdF1ScGcK/QZYYlVutbIjbO6pLz4ShEKBnbe64ZjXAEnoU7X/SH3M4bN3Az4p04aSMWhXT8IXACkEzraveeFM656Eg9zGhwh/hrZ962b9eHtYicn9RiHTpv58YGYRyml10J+oHanv3AQgeFGxS1K+CbVrcrnOKXBqlPKTbpWjTvX/rr8cFmXzZ65OYNMXrcKQDgQKYOjSPoxVw3gF8mxbaBu/3x7M572LdgXpK9XPzAIjveDJ3CJ0szHCs9m8gpNOt4l53wgTT3rsR7g0DvI4X/L3yWAzA3JldhDhYRrg7gtMtevO0FxVy+9tanMnmjap4kzg4gKu/nUPpgc3G4gDjkmuWOz3MyaTO+FJ4IXeJee7X12U5UyLmX0vccVHwCU/vLA3s36ct04+EEByltzqhny51MorPfn5zTPkOZx3xNCRd/5bLW7gFDxti2rrYvQsnCMB+i9BMkOWBJpwzXVdz1KMtsdEFTtk+hHG+fmlWrjDc17zSZ7kdF6YDQaZIzBAz1sFyIj+fFoQBRJnZ7nR9MSWwourMUzWHcwuNNx1n0isM+rEG42YRO+zHDtwAcDP3+Q1ZJg2hMtopO73b0sxsZD7gfZiZwTKXmpGHdKdD1f7esf4qtPYDNZbHHIGfXNZ0pr73W167/w9QpDOxbja30P7aKiSK5e8Dfyh9rxSFcQ6LwKzCh7YDi55gFDzKdtmsAMBrrX6d2
 WnuFMdBf
 F3VVXS9lDiMIMU82Mt6lKO4HEbMPXK0RPoDEEHZFRsaAA0VUzO2LU0pQ7GxhavTaqR6PwOu8qVkD7kubmb3d68Nuh0PhUVR02sF42SL7U/5/QI0CA/Wxh4pfZCb/5AFz31LLQ4B/1WGBFVkdi6bYFJDoMbN4y23OL4za8xbOsdKZ4J9MXa6npDoLwj/FnwVEP0F4mwAq8OcxRd0Zb+dIob92qa/cej5vZMJJep520/CQUfv4JL+eJftG+NQeeJgcKYQZBwnYpODlBMguVlxKvdAlWJ2hrfE8iFn1GgmDM6WO7Is/KrvyJKIWbODG8EbVANC3XWmLFQVWbpcdv5Egin3KicmnYDNn1v40bcq/kKbqxDmzpuH4IrF3yTpvacQscDkbikCuAKSRjv2OqUTROJxNSPYxKj+yC/keSfxvjTFK9YEEjRArYHSzMZsE0Uy/qruXQS2qMkODwpia34TUkSsxwF53JwKB34RsvUOS/R48tMLjRqSzZM8X7K5g4CgiYgjz7aO9OJrVszsNNWtJqMRbG4d6fHOb6dNbjafBHpJimIvZWzpuQE62UTK4e1JBs8bKLLcZC5f2NWBB7+C2CfX3evGIXFu97Fa8abkQEcByFd2SflU8RuXA62g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] sched/mmcid: PF_USER_WORKER affinity updates still widen
  mm_cpus_allowed()
--

commit 2c82f544b589f4baafbe2b43fe16613e89fb4361
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

sched/mmcid: Give no concurrency ID to user workers

This commit skips PF_USER_WORKER tasks in sched_mm_cid_fork() so that
io_uring and vhost worker threads do not consume concurrency IDs or
count toward mm_cid user accounting.

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index f2a981d418ebe..7e213e88ac286 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -11000,7 +11000,11 @@ static void sched_mm_cid_fork(struct task_struct=
 *t)
>  	struct mm_struct *mm =3D t->mm;
>  	bool percpu =3D false, flip =3D false;
> =20
> -	if (!mm)
> +	/*
> +	 * A user worker (io_uring, vhost) never returns to user space and
> +	 * has no rseq area. It needs no CID.
> +	 */
> +	if (!mm || (t->flags & PF_USER_WORKER))
>  		return;
> =20
>  	WARN_ON_ONCE(t->mm_cid.cid !=3D MM_CID_UNSET);

[Severity: Medium]
Can affinity updates on a PF_USER_WORKER task still widen
mm_cpus_allowed(p->mm)?

Although sched_mm_cid_fork() leaves t->mm_cid.active unset for user
workers, t->mm remains set and set_cpus_allowed_common() still passes p->mm
to mm_update_cpus_allowed() without checking whether the task is a user
worker:

kernel/sched/core.c:set_cpus_allowed_common() {
	cpumask_copy(&p->cpus_mask, ctx->new_mask);
	p->nr_cpus_allowed =3D cpumask_weight(ctx->new_mask);
	mm_update_cpus_allowed(p->mm, ctx->new_mask);
}

For example, when a process is restricted by a cpuset (leaving
p->user_cpus_ptr NULL) and creates an io_uring with IORING_SETUP_SQPOLL,
io_sq_thread() calls set_cpus_allowed_ptr(current, cpu_online_mask).
Because current->user_cpus_ptr is NULL, __set_cpus_allowed_ptr() leaves
ctx->new_mask unmasked and mm_update_cpus_allowed() merges cpu_online_mask
into mm_cpus_allowed(p->mm).  That permanently inflates
mm->mm_cid.nr_cpus_allowed, max_cids and pcpu_thrs, which can switch the mm
out of per-CPU mode and hand user threads CIDs larger than the number of
CPUs they can run on.

Should set_cpus_allowed_common() skip mm_update_cpus_allowed() when
p->flags & PF_USER_WORKER (or when !p->mm_cid.active)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794932121.gi=
t.mathieu.desnoyers@efficios.com?part=3D2

