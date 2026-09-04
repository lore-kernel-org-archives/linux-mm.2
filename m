Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC12FC79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E43D6B008C; Fri,  4 Sep 2026 07:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894726B0092; Fri,  4 Sep 2026 07:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9B46B0095; Fri,  4 Sep 2026 07:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47EF76B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:25:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB6E6120CBB
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:25:36 +0000 (UTC)
X-FDA: 85175849472.28.A716130
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2842D40003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:25:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNate+tZ;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788521135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0Hx9IkcnC9yI6FW6UAfMW2/eWJ/9yUrVjzbboHYdGE=;
	b=LXXmMCFAM3K5/f1DOFrz54/i1TxOAc8oEmu0s425EkEqXc1EOSdxfevEQxohMfb674Ds5z
	+wjDsbwKcjCbNZgHNhhUeuOqDjk9iJ3UKKwmtXTSt1caafBYqjek4UTGGDzlnWcZYqJPHF
	E5jPQv1nrb3D9fQ95x1IHQUnjnE0rrQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNate+tZ;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788521135;
	b=1qjhEK7MerY4rV6hBPZfpsAl+iuvG/T0W5pwDoSo1w30jDLTFl9SI1AJ5jRmGeSz9BrFY/
	TwSuXjKJnYWRBwN8EIwcpqEhSWgCgRhl9iR9jNkhla2ACTh0CneTnU7IHORda7iQga81g1
	nQvDS5M+aCsMCr39mBWmSpqWZNesPv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9142D60211;
	Fri,  4 Sep 2026 11:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6171F00A3E;
	Fri,  4 Sep 2026 11:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521134;
	bh=g0Hx9IkcnC9yI6FW6UAfMW2/eWJ/9yUrVjzbboHYdGE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=oNate+tZINO21Z6rg2gAhqOHaOa7D1PgqzmZzm2o6lRjp3omI6uQffc0CGFaskXlf
	 Wtl9cu5fXZANV+j+tFjFoM/rb2zKKBP3PDs8HNLSyPixA5Utz0GTLtzZE8aZmEZMSP
	 yGovCdsGIfXGKPTFJ8G9MOsyI45QuD9S/HxSp0+0mzh583UhGvOm+P1+xM2f1KVXo/
	 GbYVXXFJa4E4bJxc4tWnr16zdzIYL0NkN6jEQ4mzNU0nvdApj0myCN8t9dWvLiWc2I
	 VSHVUruLva3cE0Vij86eSa3ANebkNzkL92AoYKz6n18YK+pANCVPisCpvycPJFPUNz
	 lVxRqTKgIkqBw==
Content-Type: multipart/mixed; boundary="===============8006556704449721133=="
MIME-Version: 1.0
Message-Id: <9c166c8436f504519e6c236cf6c6c1c08981610fc3b9ff6c47c7cd084e304de8@mail.kernel.org>
In-Reply-To: <7d8b77dc99ffe99a7bef874a257472fdaaf07e1c.1788516769.git.zhuhui@kylinos.cn>
References: <7d8b77dc99ffe99a7bef874a257472fdaaf07e1c.1788516769.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v7 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri,  4 Sep 2026 11:25:33 +0000 (UTC)
X-Stat-Signature: ymd95asmwutfsxqsdpfscf9zyqoj6m84
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2842D40003
X-Rspam-User: 
X-HE-Tag: 1788521135-799987
X-HE-Meta: U2FsdGVkX19JWggwX0gxHb8jB2sAbYn3SBPgEUyXuoc+dVK8ToMvefyYVVfyoR+JBakKeecyCFGn16YsGVGck1shoXrfMUqUB2ybg1xrFAtXQiTyxAuGLDS7d59N4HekZkEPu3Y1EVkcExLc+Ica4pBQp0nVLMlokmIZ0Lbd2VgLSTsjcuJFOcGafoihYHcUqxY4rju/UrJYe17K+TzZKxUU39Nk8UmYLXq65VHF7lsikElWsI1r1ml3i1wezVJTETcOQ6rCoN9u8qsZf1OIaSO2MtOsdv5g5dfDlNuQmHeP3hpIKwigvVX/fY36uFXUBekczIgJtIsid9h7Ck5Lzl6n7PO79pDe6g6yXJuYTrpnVrjQLqOuG+eBzcIh5hqeoRPn6L05Xpu5I5Pwk3xEhFxBkdHlLijQhogr/UL+ayi+KVZw15j/nzx+QrBuHqDdpZjFLnradfy3pB00S+A5Fj51QE1OvQ1CSXznJiYoEgH+iczwTgVT/cAV7E5ySYaHoNx3ih8HR4JdbB2J+Kn3d+9Sjrai0FOiZOtqdiIB7xKOxznmmATFMzgz78HhbRt0nzGKmp6Jv0Z/3+8VUxbrLt+8L5iw8j0/SnlKi3Fsko8Q+xqNXQJchU2idIzrTN8mVCSZiZH0ZSGHTc5po/f4jiM3V4oXJT7CVtjgwRX5VO/GqjBf2mrNA7uuSR0625PVmJmo9ioRUbF89LT1f7AlznxNR2X7+6/z+Vn8mzBgdzeEhLnFYFEsbXAShadeGellKQ6zFx7wlxYfolGw7yUBOTnhg5f+bosj/+1zE1UGAkYDDxzWqkGijFZizeHl5EXkei8ESnAO7g3+yuCvDgVff1Az8tPTCq+FfJ/OFATdHrNN2KXWy0Sep7YoLMrCrpq72GEwZhSznH4HdfAVLboLHNaMyWkzbIz7aBkJNcBtkcwKAAhbnlFvPM2q+66n6h2vCvpy/OWzs4bOfbIKxWU
 OcGYNefv
 hz666EQ4h3cz/4TYbfQ47Iq0GPUDSSi7afnBFPVZ9AZrI4PPW5ChYeKjlvvsEdvA6ESEqpFx7Bap2s66oob2b1UkYvY2ldoihzgQ0egJK15n2FHfAOHU0djH38rbavOfDTN2arOYBnxW5JliZ/edTDbpbVW04YxvmmN8C+PQRTVBIeTJ8jRosfZCgqzhnpTQe/3MZWU5cV8PyLUAsOQOQKCmMP4QynAQxkqX6aKMliHzRHo/7Ohz3fq5CXHgFM9Q/x9xovyOi6IWJX7Jf3pSU3BsfDdqLBytlm28jrFyf32QIyAazBapYoa/R0vlg/V/+7Af6Men87cRbfUWBQQTAL8fwgM9KPWYG+WnbiyCUGx981n1O8nwvkuBXrGcgMh2L9cVniBoea13snDoPggN+BU0n3/kB9O2pDuZX52yMyJhV14DmrSOIlTLfDox7A68M2yHzzcz+Anz5Clxi50D54lc63Ykno7msZz2d2G+Ks8V0RqgaWMIfitmoNWQOpZEUSSnCbQYaThs7H8CfQOZlV9g2UbZYBaZkh1wR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8006556704449721133==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d76477..92f35ba66309e 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -6,6 +6,7 @@
>   */
>
>  #include <linux/memcontrol.h>
> +#include <linux/swap.h>
>  #include <linux/bpf.h>
>
>  __bpf_kfunc_start_defs();

[ ... ]

> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> + *                         cgroup
> + * @memcg: the target memory cgroup to reclaim from
> + * @size:  the amount of memory to reclaim, in bytes, clamped to
> + *         MEMCG_CHARGE_BATCH (64 pages)
> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * memory.reclaim, but without retrying until @size is reached.
> + *
> + * @size is clamped so that one call is a bounded unit of work, matching
> + * the memory.high workqueue fallback in high_work_func(). To reclaim
> + * more, call this kfunc repeatedly instead of passing a larger @size.
> + *
> + * This kfunc is restricted to BPF_PROG_TYPE_SYSCALL to ensure it runs
> + * in a clean process context. The SYSCALL program can schedule the
> + * actual reclaim work via bpf_wq or timers, which also execute in
> + * safe process context (workqueue, task_work).

Does the kernel-doc accurately describe when this kfunc can be called?

The doc says "bpf_wq or timers" can call this kfunc and attributes "safe
process context (workqueue, task_work)" to both. bpf_timer callbacks run
in softirq context (HRTIMER_MODE_REL_SOFT in kernel/bpf/helpers.c), not
process context, and the verifier rejects the documented pattern:

kernel/bpf/verifier.c:is_async_cb_sleepable() {
    /* bpf_timer callbacks are never sleepable. */
    if (bpf_helper_call(insn) && insn->imm == BPF_FUNC_timer_set_callback)
            return false;

which then causes check_kfunc_call() to reject the KF_SLEEPABLE kfunc:

    if (sleepable && !in_sleepable(env)) {
            verbose(env, "program must be sleepable to call sleepable kfunc %s\n", func_name);
            return -EACCES;

So a bpf_timer callback calling bpf_proactive_reclaim() fails verification
regardless of the program being marked sleepable.

The commit message says "A SYSCALL program can still drive reclaim
asynchronously through bpf_wq or task_work callbacks", and the block
comment above BTF_KFUNCS_START(bpf_memcontrol_reclaim_kfuncs) says "The
bpf_wq and task_work callbacks that a SYSCALL program schedules run as the
same program type". Only the kernel-doc substitutes "timers" for
task_work, so the three descriptions disagree.

The follow-up selftest (5ed7b6799588 "selftests/bpf: Add memcg async
reclaim test") demonstrates the actual constraint: its bpf_timer callback
wq_timer_cb() only calls bpf_wq_start()/bpf_timer_start(), and
bpf_proactive_reclaim() is called solely from the bpf_wq callback
reclaim_work_fn().

Could "or timers" be dropped (or reworded to "a bpf_timer callback can
only kick a bpf_wq; the kfunc itself must be called from the bpf_wq or
task_work callback") so the kernel-doc matches both the verifier and the
other two descriptions in the patch?

> + *
> + * When reclaim is driven from a bpf_wq, call this kfunc once per
> + * callback and requeue the same work item for the next batch rather
> + * than looping inside the callback: a long-running callback stalls
> + * other work on the shared workqueue, and because lru_lock is held with
> + * interrupts disabled the resulting contention also delays IPI
> + * handling. Give each target memcg its own bpf_wq item, so that
> + * reclaiming one memcg neither serializes behind nor piles up on top of
> + * another. Deciding whether to submit the next batch is up to the BPF
> + * program, which can stop at any point, e.g. once the target cgroup is
> + * dying.

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33864052510
--===============8006556704449721133==--

