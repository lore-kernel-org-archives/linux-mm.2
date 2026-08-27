Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7085BC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777546B008C; Thu, 27 Aug 2026 07:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728596B0092; Thu, 27 Aug 2026 07:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665526B0095; Thu, 27 Aug 2026 07:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 447096B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:37:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A59FB40399
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:37:56 +0000 (UTC)
X-FDA: 85146850152.21.B549E1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 13966180009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:37:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TsvQtx4U;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787830675;
	b=sVzhp1caKhEia75DmLEgetUIw91JedRyM4/7jVJ1r06L4TuXka/1u9CTE3I/kTkTxvpZvH
	Ydhj8rmeKM+507DnxuZUKA3G6dNlLV2n7CtxOjlbj7tcewXGuYQ69x+JHcAniqrGHypP4n
	7qQxit02E7tO6+Sjs2Q7v52bSgjHu3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787830675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56nzedIl1+mqwm0MbyDV8FH62QOyf8pSMLBlCAE1uY4=;
	b=RMyOb8kasSbWT8g5xZ5UytSW3wZ2TXQE+WtGeKtj6Zrlxpk+rn2GMi8bEZAy2sUwnI56fh
	pg7whktP5KRsO85Mz3mKE1f7OyNTaTUmR/CiBW7P+f0XgjMO05mrBJFt3Cd4QM9L49zJa8
	lci8cPRDscqtB2z4PScagRDisnG+GGk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TsvQtx4U;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FABB600D2;
	Thu, 27 Aug 2026 11:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A031F000E9;
	Thu, 27 Aug 2026 11:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787830674;
	bh=56nzedIl1+mqwm0MbyDV8FH62QOyf8pSMLBlCAE1uY4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TsvQtx4UmwiBwQJyqnqf7vqt0wHEgs9lR0xSuJwmUZcAdcUBfk/uwsHpakk4nXeNg
	 bplu7fVdV2KWEzJrWFRQdfNT+mbfwNP80IXOw+rIpxrJzNpYgal1OnJapZ5kfO/zW6
	 bIN0ovtrC48XGESwLFG4w3KTlO5A70WHeYerd3ybW49Ekpq19PAZS51D3lk4ZaD+EP
	 1OAVjw5S+Th7nAD69efUHzmzuicBNLG1rRBcb5c12uD3cNiVPN/su7jEW6wUpA3mFv
	 AJlPj+8EcgkVwtnyls+mmTaHFutSD/69m95sSFzlRF++bE2GV3NP2IywxTRzh+LfIv
	 0+pRkJhrfVdIg==
Content-Type: multipart/mixed; boundary="===============4363785558182586070=="
MIME-Version: 1.0
Message-Id: <d9d1848356ba38a47eaf5f8ca43ea8e2ec61baa5fd28ce23c5888babb260374f@mail.kernel.org>
In-Reply-To: <5dfdc7800469eac4e9a240f2422ba65d4ef4c4ba.1787826402.git.zhuhui@kylinos.cn>
References: <5dfdc7800469eac4e9a240f2422ba65d4ef4c4ba.1787826402.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v5 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 27 Aug 2026 11:37:53 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 13966180009
X-Stat-Signature: spxwu7nmag3rjftspybrxqjz6t9xg3ei
X-HE-Tag: 1787830674-852677
X-HE-Meta: U2FsdGVkX18oOBRa/mf4WUgWr01cn0PGYBje7V6bcSTKe0eQwLhLow0AT7ucUZkERBcgxjmbOv4RM4PkKEHVW5na+UkLLmO/NU2bYYN+Vb3u4BNbAZ3P27oSCkKZehyXc2G/OIrgI0CORkekBwFbjSJiKq9ZgCH1HS8u8WjXdY0svYp2CzmwtKrli/SxjE9g+0r7LQwr/FuCLwTzycOizUXjx36Xmt67XrBnZpN7Ke4eB8i4kd1tboFeGNPXxbtN0XPnc3AVg4wrpgZ1bjTAMecN7Qef76Op0/al9xVeXKtrQ+hVXe7CnUOTgH0Ulu0FlOJw2a0ESBqdtYP84bsaBt28efomCisAiM7NAQ2PSKmfUk9zZ2032Pb1jleCbMSM0InfUGubVhZCuOjt9RV9+hCGxjN/PobmU/l1KH5CH43K629SjmZTVLbzthosaiGpAdK2aFJk14d+GM3Uaf7ZfQ7jiXBaxpJPgvkg+u78BEn/stsizgJ+jo3MIQCHvqdb2rVFF9ZbwOuuUB9T2CeWvgFF+/Zon7CsscRay8oXtIRSKzRu8xaei8N74Y9B/U4/mkGYar53EchH+pIbaPn2z8bx3ULfP15ozW2izKrvptPvgcUUEFkBEghaQHnWiYM0pgGUgwvaqFVMUlYj334esvhfFeovhEySZ+XlBrnUB8brRmdxr/1RSj7tkoHiEOQXtgWePA+h5RXX1Gid8Nm8s8VD/hgPWYS0a6P5kzSA5t1IOjqubU49UmSARgqZcTb9yZwhno/BKk+uIQfhJvqVXSeEHPPKRS6ULpHX2p9iA8stPRRKQ1O/XTnr9TFc3ahsmvWM7AiqA+43V0jYJe+OSJk10kZBhFpcOswd+EIas2HNQkG4GvgkoKm8rsyyYY4kdjUglpUZoMhYCMU/OTt1ZPomOJJwVhb6MdCL6RIucp7rGBWmycnPmRnB5nvX8LTKUS0zE6nYttlqTPGxa6x
 29TeNiIn
 MJZV1KMmVwSBKRDXLBSpkH0V+BJwV5F1pChhoh1E0Vf7017yN1JnbSvWLUh6CIGSmlOcjJa1oqVxWNsegcPQ6CMNqovZHXHQZuJkbpsM5MJJtFsrCLKPUwd3dq4KP3pTEo0v4Up3ge5cBJEzD3GlpY8JBaFgbJrW3EkUZf4zzLp/J/SN3dNfUxblpvPy94pkyfN0sfxnzC53ghjzvar7SqhVHyD92AtSkjkteEk/gBZrnaxt57og1XM6C/48MLqxucWdGe+aoe5iuw6lyPNGDUGOfXBqndZ2i0YCkTROeYqGgVUJeHIn0uajTqDyiKMtOzb+b/5av6eE5OzYnHuDmXvFWcclRW2uMq0SBEELNIsvuTU/jt0oU3hE6xo2+1guZ9bhbXxiqNzv1U8F7Uv+ydajSui0ZuWUD92XMdlGkLpFFSsMMW/qBYnEijARR/jOpetySASrlRLD9+o9ibJxPUoGqoKxqKbxHBU5tUxPBAFV9DI9pFUtXDBQjL4/6N1IY1HM9ND6tuVq1ZpVydYG4rrBI1Qt0G/xgxaLV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4363785558182586070==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mm/bpf: Add bpf_proactive_reclaim kfunc
>
> Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
> proactive reclaim pass on a given memory cgroup, similar to a write
> to memory.reclaim but without retrying until the target is reached.
>
> The kfunc refuses to reclaim if the calling task is already in a
> reclaim context, as a nested reclaim would corrupt the outer reclaim
> state.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

This isn't a bug, but could the changelog say why this kfunc is needed -
the intended consumer, and why a single non-retrying pass is preferred
over what a write to memory.reclaim does - rather than restating what the
function does?

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d76477..297ff7f050427 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> @@ -159,6 +160,49 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  	mem_cgroup_flush_stats(memcg);
>  }
>
> +/*
> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
> + * current->reclaim_state, so a nested call would corrupt the outer
> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
> + * reclaim_state is also checked because it is installed slightly
> + * before PF_MEMALLOC.
> + */
> +static bool bpf_in_reclaim_context(void)
> +{
> +	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
> +}
> +
> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> + *                         cgroup
> + * @memcg: the target memory cgroup to reclaim from
> + * @size:  the amount of memory to reclaim, in bytes
> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * memory.reclaim, but without retrying until @size is reached.
> + * Must not be called with a filesystem lock held: the reclaim path
> + * may deadlock on it via filesystem shrinkers.
> + *
> + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
> + * smaller than a page or the task is already in a reclaim context.
> + */
> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> +						unsigned long size)
> +{
> +	unsigned long nr_reclaimed;
> +
> +	if (size < PAGE_SIZE || unlikely(bpf_in_reclaim_context()))
> +		return 0;
> +
> +	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, size / PAGE_SIZE,
> +						    GFP_KERNEL,
> +						    MEMCG_RECLAIM_MAY_SWAP |
> +						    MEMCG_RECLAIM_PROACTIVE,
> +						    NULL);
> +
> +	return nr_reclaimed * PAGE_SIZE;
> +}
> +
>  __bpf_kfunc_end_defs();
>
>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> @@ -172,6 +216,8 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
>
> +BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
> +

This isn't a bug, but would it be worth extending
tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c (or adding a small
test) to exercise bpf_proactive_reclaim?  The sibling kfuncs registered in
the same set (bpf_get_mem_cgroup, bpf_mem_cgroup_flush_stats,
bpf_mem_cgroup_page_state, bpf_mem_cgroup_vm_events) are all exercised by
that test, and a test would pin down the byte units and the 'returns 0'
cases.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33064477499
--===============4363785558182586070==--

