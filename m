Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2629BCD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9756B008A; Mon, 25 May 2026 23:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8776B008C; Mon, 25 May 2026 23:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89106B0093; Mon, 25 May 2026 23:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C97F56B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:06:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79A5A4020D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:06:24 +0000 (UTC)
X-FDA: 84808082688.17.1A86078
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB63A1A0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:06:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=OC5EvF4w;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779764782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfDY2IiT45P+FJBgGvgzHm5+IszONppt2AHImYdZuBA=;
	b=P22nMUaAhaH2G0KY364ZNCQERMtiwU/AGnl+dghcd9cAZiMh9s/KwQzZB2b4bvEkUxvsOe
	Grga8XZemNxagjNFkLnnC2CQfnqKdBl9W1oomzVVYT7lr7X0REFLL52F9x3gxXbtM1QHnR
	F7homvc+O2ZoAe4UqcOif2W6qo1V1+8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=OC5EvF4w;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779764782; a=rsa-sha256;
	cv=none;
	b=w+BYihhjq7aHheKSR2BZzJ4u+BMXjxuYweO4dfHx4FkgEY865hNQC6NfYngCi3VpAAqZl/
	mQfTxeLCTBujdbF+XDiPQKLukUtVFVdCs8qMLW5dhxeD7sSSr8sm948w/0x1VrT637wdT4
	gfhDFwpR1H+0jiW9nUHwF0X5hSyYe2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9229260121;
	Tue, 26 May 2026 03:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B591F000E9;
	Tue, 26 May 2026 03:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779764782;
	bh=RfDY2IiT45P+FJBgGvgzHm5+IszONppt2AHImYdZuBA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=OC5EvF4wBxmneLV7PaZ1qF+c+hH3vOkIXj4TsGtO2YqCAMk1GmrHrsknGPMUWCsdx
	 LPoad9Sb97LT05O2Ygzt+TGOkkZJ7VIKxB8PeMLMsFEbCT1qPvmNQ4OZbeB2Tr5nbg
	 cmRv4Ma5vYn6kPk109g7DLCOEjDWMuQ+oXjTN66SYz05eUJmVBvx227JVcK4HUEAlt
	 ntTkKfdS5t0f6E+Lq7/c3iy2nWKyznnnNSRPraSoKZZG9jf8B+OMjss9tEsaRmNZbZ
	 Mt8QbXe3+WrYv+ECtL/TBcWNlmX5+SYwnGAxCu5tRrEMCP20zgEB4Fpc+sk7tFj+ga
	 XNwBqleyGfAJQ==
Content-Type: multipart/mixed; boundary="===============6143565898584063114=="
MIME-Version: 1.0
Message-Id: <2da837791c9752c4a4db41a233bb631a8af042fa2fc900e3cdfff0c2a352de15@mail.kernel.org>
In-Reply-To: <13b10d91aff4307580d1a601f1592efe42a92b05.1779760876.git.zhuhui@kylinos.cn>
References: <13b10d91aff4307580d1a601f1592efe42a92b05.1779760876.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v7 07/11] mm/bpf: Add bpf_try_to_free_mem_cgroup_pages kfunc
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, inwardvessel@gmail.com,
	akpm@linux-foundation.org, shuah@kernel.org, davem@davemloft.net,
	kuba@kernel.org, hawk@kernel.org, sdf@fomichev.me,
	kpsingh@kernel.org, chen.dylane@linux.dev, yatsenko@meta.com,
	leon.hwang@linux.dev, a.s.protopopov@gmail.com, ameryhung@gmail.com,
	tklauser@distanz.ch, eyal.birger@gmail.com, rongtao@cestc.cn,
	haoluo@google.com, peterz@infradead.org, ojeda@kernel.org,
	nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, willemb@google.com, kerneljasonxing@gmail.com,
	paul.chaignon@gmail.com, chenridong@huaweicloud.com,
	lance.yang@linux.dev, jiayu@kvack.org, an.chen@linux.dev,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,baohua@kernel.org,zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 26 May 2026 03:06:21 +0000 (UTC)
X-Stat-Signature: zqn4d8mof8ooxgaq33wirpag1dfd1k5w
X-Rspamd-Queue-Id: EB63A1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779764782-493438
X-HE-Meta: U2FsdGVkX18LjnwnPbejPs1FNVtyCr+xYtXdEVkyHpEdAUyq0ko8aSDONAYAhv4EwzP371VsGdD8LBBfMnuMln82sILcIvw77QU9jsRQ5LXkY9cQFS0IuGjJFtFAJqfHNgxZy0ioRDDXZL2SU5ZdE9qBkFWzEDrva7nbmMRKVaHjNmexp4dWxIzPaSiKvIXXs682rWvxKFXsSXVNDtPo/5zTSRJH+SOWP/mWCJNAXxr/GgZWQL7xsn0oaxxCJ0GIlJMNL9gbgqyXzN772m0bc6rDTgdXG69wuBogThKaPyLGQfzSjl0xTtD1iss29R3QUyR447PmTkjPRWxMpsV4x9y2AOr6xQnJV8wJRkIlgHfsKe7LYbMP9NCMLk+ymW93UqfNfJiBkzN4rl7fCZdFn9inwd7OSdqAiLyohrGUgFfXgPY3iCt8bWw+6wt3y2dRkBOEYtCGTzEB0e0rccd7KzGvc/4eXavBs0W4wdVZrtpbWS/kkedjCCFpGmQ0rWjLmijKHdHMMYZ6zUUnL5DYGxxjciTHPxXOPhKd6GYVKW46v6qO+pDh50bYZTkFDbS7uK4Tp3spaYF6WK87+ymqP+rDG+0ftecvoepQ6dXCu815RIZ+OciOsRz0cF6Jp69O5QFUvFI7fa6EGnstqzJZ7llGTFysJIPohCEmLETQhzVaq2Gqxh4JqT6lgEkjHXhifVUtJ6tF5XkNntE7D15ucrPRP/vVBu2lHwuiFtQGVxn5xiy5a51s9vKna/l0RJSh7nwTVPmubwpcOTQyuO3xYjenl9TNcpn+T3HKMrZK2iFdCfkqMVeqTq2HTt4dN57ahkj5pU0Kb2dqzhvNSp+MY/BDsLx14KYnuvpoPa5CrQ+pWYUpayLTuqq1rGt4xHG8HVcLU1a7jMPzrXL6nmyk/clYbERBqLv1z+Dx91Ddq6HutLFY47NHNeGikDhRWr1fyQuPTXM5iBRwVx+5WNf
 hh9arWYe
 q5/R4slhWUlmLlvzjOAtjC0AOhlOC0oiLznKFm4uFh0PUI0an+9ZUGE0saUimYw1itx/RYfjk/U9CuQbGFy/0sxK3tTmr4HX7RQtgl3499j1beOPisMP/e5MlgEH2bwh99miG9LfEBCn6Idv5vUmLjt6nrXagRAffiY3MXSiXrz3jaDLU0dsz2hbJHdrepXhjxTDKoadr8QXVU9Acdtol7+l9TigFS+ACignNfSj7FQwRmwOLBBmfU6ByfFLgAFnAdVbcZyqEUr899+PBUwD9/5gjGBuRj4LqH0advn9sLRigdSjKY22XnP8pcUECWXzZmTwtVDl7dndHzIUJ+2soPAorK3bixE2x7YjP6JCENyGWG0IvgEqj//1Wr8mtF5yY3AIdMkypP1Csrn+xmtqgt+04AKYN2+Zd2uIuDy1MkOWv6zaIaWQ9iO4w/1U5vfaPKvtIqJ6iCmBJwi2SPhcOAXMi74IsvQHFhXtqHL++bzUPd7Uxf9UtwlgKPSiaG5lbOVPeQTEt1I5+DgQNYNPgB5iOdDjz1sg51mOrryewXOmY6kgnU7FzPBSPD8ATOaJKRI7bpH1FRwG59M+11PSgOD0F5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6143565898584063114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 1f726a7b22e3..0353c8736aa5 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> @@ -162,6 +163,60 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  	mem_cgroup_flush_stats(memcg);
>  }
>
> +/**
> + * bpf_try_to_free_mem_cgroup_pages - attempt to reclaim pages from
> + *                                    a memory cgroup
> + * @memcg:           the target memory cgroup to reclaim from
> + * @nr_pages:        the number of pages to reclaim
> + * @gfp_mask:        GFP flags controlling the reclaim behavior
> + * @reclaim_options: bitmask of MEMCG_RECLAIM_* flags to tune
> + *                   reclaim strategy
> + * @swappiness:      swappiness override value, or a sentinel to use
> + *                   the default
> + *
> + * BPF-facing wrapper around try_to_free_mem_cgroup_pages() that
> + * validates and translates the @swappiness argument before
> + * delegating to the core reclaim path.
> + *
> + * The @swappiness parameter follows these semantics:
> + *   - Values in [MIN_SWAPPINESS, SWAPPINESS_ANON_ONLY] are passed
> + *     through as an explicit swappiness override.
> + *   - Values below MIN_SWAPPINESS are treated as "use the system
> + *     default"; the override pointer is set to NULL and the cgroup's
> + *     own swappiness setting takes effect.
> + *   - Values above SWAPPINESS_ANON_ONLY are rejected as invalid.
> + *   - If @reclaim_options does not include MEMCG_RECLAIM_PROACTIVE,
> + *     the @swappiness override is ignored entirely by the core
> + *     reclaim path and the system default is used regardless.
> + *
> + * Swap usage during reclaim is gated on @reclaim_options: swap is
> + * considered only when MEMCG_RECLAIM_MAY_SWAP is set.  Without this
> + * flag, reclaim is restricted to file-backed pages regardless of the
> + * @swappiness value or the cgroup's swappiness setting.
> + *
> + * Return:
> + *   The number of pages actually reclaimed on success, or -%EINVAL
> + *   if @swappiness exceeds SWAPPINESS_ANON_ONLY.
> + */
> +unsigned long bpf_try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,

Should this function have the __bpf_kfunc annotation?  Every other kfunc
in this file (bpf_get_root_mem_cgroup, bpf_get_mem_cgroup,
bpf_put_mem_cgroup, bpf_mem_cgroup_vm_events, bpf_mem_cgroup_usage,
bpf_mem_cgroup_memory_events, bpf_mem_cgroup_page_state,
bpf_mem_cgroup_flush_stats) has it.

Documentation/bpf/kfuncs.rst section 2.5 states that kfunc definitions
should always be annotated with the __bpf_kfunc macro to prevent the
compiler from inlining the kfunc or the function being elided in an LTO
build as it's not used elsewhere in the kernel.

> +					       unsigned long nr_pages,
> +					       gfp_t gfp_mask,
> +					       unsigned int reclaim_options,
> +					       int swappiness)
> +{
> +	int *swapiness_ptr;
> +
> +	if (swappiness > SWAPPINESS_ANON_ONLY)
> +		return -EINVAL;

How can BPF callers detect this error?  The function returns
'unsigned long' (matching try_to_free_mem_cgroup_pages()'s page count),
but here it returns -EINVAL.

Implicit conversion of -EINVAL (int -22) to unsigned long produces
0xFFFFFFFFFFFFFFEA -- a very large positive value, not a negative error
code.  The kernel-doc above explicitly states "or -%EINVAL if
@swappiness exceeds SWAPPINESS_ANON_ONLY", which is impossible for an
unsigned return.

A BPF caller cannot distinguish the error from a real reclaim count via
'if (ret < 0)' because ret is unsigned.  The sample BPF program later
in the series (samples/bpf/memcg.bpf.c in commit 8dcfd8aa3316) checks
'bpf_try_to_free_mem_cgroup_pages(...) <= 0' which would only match 0
and would silently treat the giant 'error' value as 'many pages
reclaimed'.

Should this either return 'long' instead (so callers can branch on
negative), or use a clearly defined sentinel like (unsigned long)-1
(as the other kfuncs in this file do for errors)?

> +	else if (swappiness < MIN_SWAPPINESS)
> +		swapiness_ptr = NULL;
> +	else
> +		swapiness_ptr = &swappiness;
> +
> +	return try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask,
> +					    reclaim_options, swapiness_ptr);
> +}

[ ... ]

> @@ -175,6 +230,8 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
>
> +BTF_ID_FLAGS(func, bpf_try_to_free_mem_cgroup_pages, KF_SLEEPABLE)
> +
>  BTF_KFUNCS_END(bpf_memcontrol_kfuncs)


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26429228214
--===============6143565898584063114==--

