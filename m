Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9951F606A8A5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M4gd8OWh
Received: by kanga.kvack.org (Postfix)
	id B62B66B05BB; Thu, 12 Nov 2026 10:03:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13F46B05BC; Thu, 12 Nov 2026 10:03:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A295E6B05BD; Thu, 12 Nov 2026 10:03:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80B7E6B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:03:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0ED2B1C3E6E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:03:08 +0000 (UTC)
X-FDA: 85426784856.16.3B4E8E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 168DC10000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:03:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4gd8OWh;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794495786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7K9NJVRHkkfPoN7dlOGzjvSobTAnpjtwzm4XPW/Q2Zk=;
	b=luqLSxGpx4hr+4Qp28IF4bZZAs9wyZtivo4j2e70uyh8rolG975uJf3ycsgLGIzsPpx8UY
	fC8T6vM1NLrWEb9CFF6T7/uwe3N7snlhomFLP+n/PZQ+giru5LpNBNqeCWM5AoF2NDMONa
	l98jrlwvjIxBFbyTj67xT1Bsah7Y3Rc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794495786;
	b=4NINf2bxDT+JTgGg7ILEh/PiwXFDYd+4r0FtV1rM6pc1CSi/jzKw7ZROCNEnugccqX9tmb
	qtPtQH2c58ObbJzVpCcC3fCiZ7xOSXuiJWsLvmRgW9vqPtwQTWP/L5OmLxavZ9M5ihsl9R
	F51ypF3KaxGWNXMQAbPfbP9DmMK9nHk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4gd8OWh;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8ADDB60E7F;
	Thu, 12 Nov 2026 15:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30C91F00A06;
	Thu, 12 Nov 2026 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794495785;
	bh=7K9NJVRHkkfPoN7dlOGzjvSobTAnpjtwzm4XPW/Q2Zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M4gd8OWhuhCUm2RCHTG19SJR+Da/kGIIzr30q38JmfIyFEdwGgkXEBSFpTctG7UcT
	 S/ZzgkXA0/a8YDAdRrbn7Sgi8cJMgE9Pxh6GSTU5TfuG7iqjO3LbgtUxZCHmOF4bk8
	 wSjX7rLlOx30FQ33QK1ajCfqZkLBHPVkDKZ5rJfXth6VsZixQjymwb0JYWVGYX5Opm
	 A7vcUf1saG9qHwg3/HDw6LljAy85DIrPPAIbSe2rDOFHjB/jHahLuOPngEyCDc1SOS
	 JuSHS1oi2U2jpncNJ0nI+HKjurqAXMDMVeZhtweTmgEDBJImEuSC0kkzdEyRscl2My
	 CUhpx4oG6bXNQ==
Date: Thu, 12 Nov 2026 15:03:03 +0000
From: Harry Yoo <harry@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH v2] mm: list_lru: fix NULL deref when a folio moves to
 the root memcg
Message-ID: <avXR40QjHujG_H5P@thinkstation>
References: <20261112061231.2469026-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112061231.2469026-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam06
X-Stat-Signature: dpy483kpoaw8gmrnh9n3dyn3rfhmodwe
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 168DC10000D
X-Rspam-User: 
X-HE-Tag: 1794495785-236673
X-HE-Meta: U2FsdGVkX1/3rY0pbPhTXYuGOsuvPrzcwoBKMmOPSUgZ4DQhlpsrZ/m2EOXD/s3bWDkh2GTMBh9iINbcaJOQ4gBxLuu5AaY6ezNLcA+42HqTwRACokCyPt4XRBf8WrEyw/i+dS6AwR0Ma7LEDmIHHK9d47/VAJ+RJKYuKHMUqAYSWqj4U/VJt/qEC7D0bHSvCWQlIGmGJvNgFy5jiYiVUJ1ClQ+5i9AJqIWQAPoZj9Ns8q/d2q3XnfkWTnxrZlJdZaRPtwvogPMc4QSzp5ikTetokIXC+XkSia4B7WURVumrzW9/eeeow4KO3FnST3wImuItH4wsIeFklflqT2s5Bu8jQGNkYKVi1AQHwtgaR5cQiV7kUpbyFdQcHKyITZNEUpv3CaGG8nLuRhbcNWOwOEcEtk+jfJCMgR5xnMO29N7aDDdbYY1yzZQSNhmMx8gDFxkCz8wNy2cObYg9nSZWdzHmfCqT23syFaCbH8II9sZGY0/S+CXCWxzAZW7UCZTCNi3bVXFz+8KRzoj5z57k66v5Jw2MhK0jfEc/Pwqkk7awSqJtprzt4UoE2G/m5GgI3EHntuuXtLqPlLNEV7OHwIuEFvRLQQB4bXBQUbMYgY10yhpdF4qWJRD+VS6YZ/wIr1fqBD/5tIJ/vC2m4tAE8Fdhtogu0kngsDqp4rTEHsaLAATTpW/OhflcTL4TXDKZ+EASN/7UV2c4OI/bGsV/RG+mrIfga2B2A6Z3MrvC7us9SNRQKu9FvJrLUQ8tG3CAF3xQ5I4ASi26e2hp5aNpcc8MViObKGLZRaZPMqxSPWA4hft5LMuRWA3Gfl1fxvCid0RxgGL38JLXPOFvNmbNJ331XO6uGMnDxKKrC6KFg7A4c20aM03Bc/65fmtEN98N5l7LU5tCiKjroal+IkEBBv59Tp5XpQHH4OKJ3ar9CmYzAl8tM3+D13h5xE/38oDwTL1MZ1jYdTJ//ozEran
 5osgsBAt
 wCuIOhsi6irAN6gK0BPUOJgZjQpLD4TyENki6vo1alIoMgWzbKE/R3+TN7/z/kLt8lktC6Iq+yPwJYVSKFgFVC06fWcqQBKgvW5tUp4NymTX2KuYmQSE3MPg0MgrSDgZfrn/Oh4yj/PxDNTd111PqMuXqnIhtZW2l4UErgUh2TdICgK98IuYcLuQE4XHout42k+SbyFhuqi7FZGYEfmMAJA2NbvE+71bghXU0QvMRIC2R58T6Fxm6kknmNx8KWEI5fpbzwuXbwEzxH2JLiYw/GHqvk2WSXrTZlH7UDgaOV59zdEc4zN4b5dWgCBSSEszOpXZgx0eLjOEv4u3+O/NvtcCIxQ97Y1ADE34i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:12:31PM -0800, Shakeel Butt wrote:
> folio_memcg_list_lru_alloc() makes sure that a folio's memcg has its
> own lists in a list_lru, such as the THP deferred split queue. It looks
> up the folio's memcg twice: a fast path under RCU checks if the lists
> exist, and a slow path takes a reference and allocates them. The fast
> path returns early for the root memcg, which uses the global lists.
> The slow path does not check for the root.
>
> The memcg can change between the two lookups: when a cgroup is
> removed, its folios are moved to the parent memcg. If the folio is
> moved up to the root in between, the slow path gets the root, and
> __memcg_list_lru_alloc() dereferences the root's parent, which is NULL.
> 
> Users see a NULL pointer dereference oops while a THP is allocated,
> such as in a page fault, in khugepaged or at swap-in. tmpfs huge pages
> are affected too, and for them the oops can also happen in reclaim,
> for example in kswapd. The task that hits the oops is killed, or the
> machine panics if panic_on_oops is set.
> 
> The race is narrow: the folio has to be moved up to the root right
> between the two lookups. For example, its cgroup is directly below the
> root and is removed, or has its memory controller disabled, at that
> moment.
> 
> Fix it by checking memcg_list_lru_allocated() again in the slow path,
> like the fast path does. It returns true for the root, which needs no
> lists of its own.
> 
> Fixes: ae64f07a6a40 ("mm: list_lru: introduce folio_memcg_list_lru_alloc()")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

The fix looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

> Changes in v2:
> - Check memcg_list_lru_allocated() instead of mem_cgroup_is_root(), like
>   the fast path does, and update the comment to match (Muchun).
> - Link to v1: https://lore.kernel.org/20261112024140.648088-1-shakeel.butt@linux.dev
> 
>  mm/list_lru.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index d1d256822ccc..ca8de3793166 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -645,9 +645,16 @@ int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
>  	if (likely(res))
>  		return 0;
>  
> -	/* Allocation may block, pin the memcg */
> +	/*
> +	 * Allocation may block, so pin the memcg. If the folio's cgroup
> +	 * was removed after the check above, the folio has moved up to a
> +	 * parent memcg. That memcg may already have its lists, or may be
> +	 * the root, which uses the global lists and has no parent. So
> +	 * check again before allocating.
> +	 */
>  	memcg = get_mem_cgroup_from_folio(folio);
> -	res = __memcg_list_lru_alloc(memcg, lru, gfp);
> +	if (!memcg_list_lru_allocated(memcg, lru))
> +		res = __memcg_list_lru_alloc(memcg, lru, gfp);
>  	mem_cgroup_put(memcg);

I was wondering how we make sure reparenting doesn't happen after this,
but apparently it's fine as __memcg_list_lru_alloc() populates all
list_lrus from the memcg up to the hierarchy before the root.

-- 
Cheers,
Harry / Hyeonggon

