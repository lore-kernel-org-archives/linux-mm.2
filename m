Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2398C98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C865D6B00A7; Thu, 24 Sep 2026 01:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C369A6B00A9; Thu, 24 Sep 2026 01:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25ED6B00AA; Thu, 24 Sep 2026 01:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFF46B00A7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:02:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D9C7A5327
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:02:22 +0000 (UTC)
X-FDA: 85247459724.26.3D6A433
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8918E140003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:02:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kiI1am/1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXNEueqMCRREz5N5CQfkfW8XWDi10Z7xuAbrRSHchSQ=;
	b=3FoeO7JIN1c9jL22Mac0q+cGL1iVQg0CAITUimFrIwx4tXyokab3jw3bFzYHv4TbSRL5dX
	e/0EjHe41reoREto0W8wSgcsox1oBXT/5tL0TGoN6ck/uhUuGQEOCecRJS4CoP+f32/FSg
	Vlh3nMBwPmAV8mRP7fvWKkWoTbxZ6Kg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kiI1am/1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226140;
	b=TUUeT6xZ+cffTFr55HMLdSGWNWp6rsqnRoHEp9jeUj/EA8eCOaNbYKqvde8lSxKs0ZjAlM
	DGbSz+0oudPmhZlvKMxnSpXW4QKnXUHjSTwkqPWa4BPhjdolhYvhLeq314A+3YSv0PQ9TL
	0OUpYDAFy2W9CPSow14t0nQ4igRMUZg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE73E600AA;
	Thu, 24 Sep 2026 05:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19541F000FF;
	Thu, 24 Sep 2026 05:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790226139;
	bh=lXNEueqMCRREz5N5CQfkfW8XWDi10Z7xuAbrRSHchSQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=kiI1am/1zZpTnT6AGoHTLhMiXC9JBLSCbNvSU5M7JPO8QoiKdxRBHH9YblcEcPN5j
	 56TaAjcDpskHwyVNwfaSHxwsxMHxoRvSgjFKAs0dheI7GyjamX7uMKE2Swzx9c6b35
	 +pePpMV4ml5Pc7sJfMUExEFkuiQTjdQory2R8r2U0miBbitqNf9w2joN7AwPzc6ot/
	 v8V0SGQhBg5ljmk3BKRFu1JMFzkfS2+ZjhQ+hX8RKYslPiymizgIHX0GhPyNuY2ZU+
	 N8ay4u5jKbWI5Cbq/O8Rr7f1VoBMgc30zH0KuGIjKZ0lcO9N2CAaY69AtsaeL6GC/4
	 Q2C75UwjOrJNA==
Content-Type: multipart/mixed; boundary="===============5311084438262854122=="
MIME-Version: 1.0
Message-Id: <99204600993999e8ff4929b758720dafe0a6c2b4c2d5c1e03ede485e9d2e9747@mail.kernel.org>
In-Reply-To: <de7adb6bafa3b808e29c0630f7ed9a2003e5e447.1790222105.git.zhuhui@kylinos.cn>
References: <de7adb6bafa3b808e29c0630f7ed9a2003e5e447.1790222105.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next 2/2] samples/bpf: Add memcg async reclaim example
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,david@kernel.org,baohua@kernel.org,geliang@kernel.org,davem@davemloft.net,kuba@kernel.org,hawk@kernel.org,john.fastabend@gmail.com,sdf@fomichev.me,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org,netdev@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 24 Sep 2026 05:02:15 +0000 (UTC)
X-Stat-Signature: dira7jtksw6rt6b51t96djtarnmut8ew
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8918E140003
X-HE-Tag: 1790226140-662905
X-HE-Meta: U2FsdGVkX18nBx8kPoGkW7sCKqlmcFuHRQ9on+IVwiK78b40cuRyPr4D1lutqyzn0i9N0fdPg3aFcCoCog2547X2nhTOqQvGbF0w20Lr0jCXFOWkRGU6mEybF6ONCqGehH2+C0Z0hSo0gGl8E5Kej+tiNmYuCmJyT6LcWWV2AZvOOO1oD0eQ9VimzR++ON6tQ2B3lmNMoTRY4TSdYNwQsrA/9l28veGwfCM63IrA00sdyqT8mwS5GKBounfEGENTRvnSz5r6HYXdYZYyH4m8Q48w9NSXZYB//gw+UHdIt5XwpKG/po5KTmetL6YOkptmPI2POsfnAxIRH/gOipPgDJd37R3FngtJWGg44z4IiuYb35mmVgbodN9iPCUUNF7+Op0M0KkShUEfgkdANGvUNr78T6VwCxQuH/DCeGU5Isc5kyb5E6SgWT38y3Pp2z9qndAdGyt82XQvpHfyF+8vxJYa74jKGnb6FKIIliKoZSkZ8037Ja/dS4zA8BYi+EAR8yaVLuazMDkeIO690O+ReBrQzo/9y5difZNI4EuBW5WTUc9iHu/Np77PtyCjLtsUC/hPB1bif8yO1LQvaDuXcw66lyy3DvtH6Ngin6ley65nwbn6mnPGmsjSmZUVcJlkfTw6Se+DVLyv0PL8mxKME5bkH7NmQMCeB/ArORMIGhx3oCILVsPo33pRmAR+bsHGhUT3QKWdQ+Yy/J91U5gHgFyRIrY4CtFN+ZVVWMCsO9mDVUphm/lGd53t0LBEHqpDAs/ghGVaAzF8Y0tqt+N4BYAj0Y3U4L0aNoe5bdsRoWT6fV2y021G+QA/cNNcyXVtJuchSk8U9ngvKf2Sr41FzTdNV0l/SXcp1IQpbxkaG00JscSMpkmGQohoZro8NoNUPZLPoP/Ua+tyJ0w/CSJhMYr6AzXp7NW93nAh2zsViR411VNeMBgz1LXnPPc26f0BKG5cdMbOkT3Nw2qYdNQ
 Ay5jliI9
 6Rv3JYaz5teEvgNOkl7zmWUEbsOnaVe5ps/5LubuSpoM2/4jGCfpdc0UbNl8et0gXYJ9JXEC/pw6YhMVnmVkqDDcr0/mMOemIFeM3dAmUPBvE7f7MwUN0D2pZSKdAYZf7TmrjejctFJOob9CBXSlc3c5VcL5VHbdx7VlXxSqheZpLDeI4i0TsueUStNn+uGwGN7X8ZXzyLgqcZFz+cki1O3DR7QF9oXszYksq+SRV9LQRVTWURlofCg+VAqr6BjpYtUMK56QbKk/4PQ94974U4kbUIWW1vQFRHF4Za/Muhm0xSDCYHxBsubHNnZQBOvXcf3w+pMa+UyPSJZZ0rRvI7ZMbhm0kePeddCdA5Ck6gAFqT0DjdwPp2fhi57MczKt2gsuvVJPwme9ygu9mnI+PPjMwkyNCSTUvIXAV+EhlHc896jvoeNMAsnqVzXSNvpGnGHbQsWP9sProMKOPkBUtV1Ehclz/+PuS29w+kLh1SlIBtxMYqY3TAn+Rmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5311084438262854122==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/samples/bpf/memcg_async_reclaim.h b/samples/bpf/memcg_async_reclaim.h
> new file mode 100644
> index 000000000000..96fe03d12912
> --- /dev/null
> +++ b/samples/bpf/memcg_async_reclaim.h
> @@ -0,0 +1,39 @@

[ ... ]

> +struct reclaim_cfg {
> +	/* Cgroup whose refaults are watched, i.e. the one under pressure. */
> +	__u64 monitor_cgroup_id;
> +	/* Cgroup that gets reclaimed from when the monitor refaults. */
> +	__u64 target_cgroup_id;
> +	/* Refault delta per tick that starts a reclaim round. */
> +	__u64 refault_threshold;
> +	/* Monitor tick period, in nanoseconds. */
> +	__u64 interval_ns;
> +	/* Bytes requested per bpf_wq callback. */
> +	__u64 batch_bytes;
> +	/* Callbacks per reclaim round. */
> +	__u64 max_batches;
                ^^^^

Does this comment accurately describe max_batches? The BPF side does not
count callbacks. It uses max_batches only to size a byte budget and keeps
requeueing until that budget is spent:

samples/bpf/memcg_async_reclaim.bpf.c:reclaim_work_fn() {
    elem->remaining = elem->max_batches * elem->batch_bytes;
    ...
    if (nr >= elem->remaining)
        elem->remaining = 0;
    else
        elem->remaining -= nr;
    if (elem->remaining)
        bpf_wq_start(&elem->work, 0);
}

bpf_proactive_reclaim() limits each pass to MEMCG_CHARGE_BATCH (64 pages),
which is 256 KiB with 4K pages.

With --batch 1M --max-batches 32 each callback reclaims at most about 256
KiB, so the round runs at least 128 callbacks, not 32. A partial reclaim
also adds callbacks. An overshoot, or a zero return that ends the round,
gives fewer.

Two other comments in the same patch describe it correctly: the .bpf.c
comment says "a clamped batch only means a round needs more callbacks,
because remaining is decremented by the bytes actually reclaimed", and the
loader says "One round budgets max_batches * batch_bytes". The header,
which documents the BPF/userspace interface, contradicts both.

The same wording is in the --max-batches help text in
memcg_async_reclaim_user.c.

Suggested wording: "Round budget, in units of batch_bytes."

> diff --git a/samples/bpf/memcg_async_reclaim_user.c b/samples/bpf/memcg_async_reclaim_user.c
> new file mode 100644
> index 000000000000..d5296fd0fab1
> --- /dev/null
> +++ b/samples/bpf/memcg_async_reclaim_user.c
> @@ -0,0 +1,1141 @@

[ ... ]

> +static void session_stop(struct session *s)
> +{
> +	unsigned long long failures, last_err;
> +
> +	if (!s->skel)
> +		return;
> +
> +	ring_buffer__free(s->rb);
> +	s->rb = NULL;
                ^^^^

In bench mode the reclaim_events ring buffer is never consumed, so the
event counters and --verbose output do not work there. s->called,
s->skipped_dying and s->target_gone are only updated from
on_reclaim_event(), and that callback only runs from ring_buffer__poll().

The only caller of ring_buffer__poll() is session_poll(), and the only
caller of session_poll() is do_watch().

do_bench() goes session_start() -> run_workload() -> session_stop(), and
session_stop() calls ring_buffer__free(s->rb) without a final
ring_buffer__consume().

So every bench run prints "events: called=0 skipped_dying=0 target_gone=0"
even when the "total:" line read from .bss shows calls=N > 0.

> +	failures = s->skel->bss->timer_failures;
> +	last_err = s->skel->bss->last_reclaim_err;
> +
> +	printf("\nran for %.1fs\n", now_sec() - s->start);
> +	print_counters(s, "total:");
> +	printf("events: called=%llu skipped_dying=%llu target_gone=%llu\n",
> +	       s->called, s->skipped_dying, s->target_gone);
> +	if (failures)
> +		printf("WARNING: monitor timer rearm failed %llu time(s), reclaim stopped early\n",
> +		       failures);
> +	if (last_err)
> +		printf("WARNING: bpf_proactive_reclaim() last failed with -%llu\n",
> +		       last_err);

The -v option, which usage() lists under "Common options" as "print every
reclaim event", prints nothing in bench mode.

The same missing final drain also drops any watch-mode events that arrive
between the last session_poll() and session_stop().

Should do_bench() poll or consume the ring buffer while the workload runs,
or should session_stop() call ring_buffer__consume(s->rb) before freeing
it?

[ ... ]

> +static int do_watch(struct options *o)
> +{
> +	struct session s = {};
> +	__u64 monitor_id, target_id;
> +	double next_stats, deadline = 0;
> +	int ret = 1;

[ ... ]

> +	while (!READ_ONCE(exiting)) {
> +		double now = now_sec();
> +		int wait_ms;
> +
> +		if (deadline && now >= deadline)
> +			break;
> +
> +		wait_ms = (int)((next_stats - now) * 1000);
> +		if (wait_ms < 0)
> +			wait_ms = 0;
> +
> +		if (session_poll(&s, wait_ms)) {
                    ^^^^

The --duration option is only checked once per statistics interval, so
watch mode can run well past the requested time.

wait_ms is computed only from next_stats and is never clamped to the
deadline. session_poll() keeps calling ring_buffer__poll() in 200 ms
slices until the whole wait_ms is used up, and it only returns early on a
signal or an error.

For example, with the default --stats 10 and --duration 3, nothing is
checked until about 10 s have passed on an idle system, so the program runs
for about 10 s instead of 3 s. With -s 60 -D 5 it runs for about 60 s.

usage() says "-D, --duration SEC    stop after SEC seconds".

Should wait_ms be limited to min(next_stats, deadline) - now?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35955613591
--===============5311084438262854122==--

