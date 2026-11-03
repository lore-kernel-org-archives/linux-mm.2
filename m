Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DB6606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dj0/szuO
Received: by kanga.kvack.org (Postfix)
	id 59B546B05B1; Tue,  3 Nov 2026 07:22:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D046B05B2; Tue,  3 Nov 2026 07:22:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43BE26B05B3; Tue,  3 Nov 2026 07:22:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10AF96B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:22:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1BD62140385
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:22:03 +0000 (UTC)
X-FDA: 85393719726.21.F1E8E60
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 25BF44000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:22:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Dj0/szuO";
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793708521;
	b=L4rgjwczfemN5dtGT/4IN3ZdnLFRv822Oy1v78yAn7pL8L9gVpf3y8+WNUK6aDdH3lLxS4
	01HY5mkuJSlF1N7pDEbHQbeqNhIcN8gRAXD2R1dWiwuidub0ZYFFMHz5PC4M8UYx8Aniby
	Jnd5zdI9HEqs+xAbtb4ODd9XYzwpxdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793708521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOzzqdK9OoTPF7w8+dGv8CzGaoXQjJup2f2zEoi38v8=;
	b=s7xtqugUDyJhagIFro9sBLX4fSu5u9K1IEGfx8zcReXM0EDo/TtGmgKNYZ8VJ8Wti3L2Km
	tCYFk0OMqcvUk3Pcjph4Ou9ghpP0HNo4yaovAk7LQLHp7PLlffycz4/xR+yjpQ6mA0Kxlf
	KgzdtULJaP1nR0sw5DAzvKVpCd8opes=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Dj0/szuO";
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so3226057f8f.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 04:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793708519; x=1794313319; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DOzzqdK9OoTPF7w8+dGv8CzGaoXQjJup2f2zEoi38v8=;
        b=Dj0/szuO5v7wvJbvjSfHlab1ZAsNGY71vuqc5qFlkrFEsbnRDzrAT1gQzbJA2tNHmT
         GwpUjtvsmxN9OPoIL5Wkbdu4/D0ehbohQaS15GFwQLt+uv0EysplcT4vZQeikyccSBf3
         vR9TmZ9yKuRmI7B4a0cIIbFvOduXbRr3in12TOStF1PBEOlnrwoG0VxWZiYkiIx2a+Rx
         EuAxKN21jYGyNCwy1WxLGqHNoBV46gPhIQa8+kWUEydheW2ufdAm7+zJzeYtVu9+TJC2
         U5wTGdQXtx3HT7D32xXaKRgJ1qY9cT8HtthK+EecYZsDcnAftCl/1mArfm8iYHzEef3b
         GXLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793708519; x=1794313319;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DOzzqdK9OoTPF7w8+dGv8CzGaoXQjJup2f2zEoi38v8=;
        b=hZKwGA2bsti/c70EsqmIYuChgz7HzTzg1NxRl9xZUFcZ6sMKuGyrrM0LTzJAfXdPuy
         kTA+HYNY1PS4XowHMbNnUM5rPYILG0+IocG2gE6DNLwZUlkR4QIVFGzTG9+HXjO9LhI8
         hKrP7b51Y/+n6VTUPQmLYMinj0UWkaCBKPEmKF+KXZJup7R1il1tn9oYFzqUKqQkiCai
         3FsEjjJTTTQs9/bWdO+Ig++Kwwnmf8bxxnna3lxADI8f7XSgcNqUuXaX/F2wpBE8gOBB
         0N5V8gdleL1coOSgdwSm7eoI0WjZJnFBNr7MEQx7dach8fdukLMFJbxQ0fWMwUdyRxjb
         6VFw==
X-Forwarded-Encrypted: i=1; AKwUvBxw2ZCl8IlDyxNyKxOgbFY6JKWWiA7PQ8OtUppaMSs7TbOxSDZVPmCYDupoLs4DgZXBotLJsu8uBg==@kvack.org
X-Gm-Message-State: APuU4Z/35cMrvt+Fl3bzTE3sQDz5ijgnZ+HAyeoatn+E/fzOV1VQMTpS
	AXK6Oq6pQWa8iuC+pr1CEgm5R/4bMEDTIiV6soILskBJR8Sy53XuBw6s
X-Gm-Gg: AYBFou377LQOtkZZta/mvDGNiF6FkS2itfihNG9HWCP03WAjPH9Ef88Mq3rsQlvge/V
	4vl0bSl4f04skh+RECYzGrwp5HcnYu7z50cT2ytgizb43tmOPOQzarur2rKNQ7XThBPSqXISEUl
	Mq1k0CsfX663LlveVmDU2gIsPckrD19iJ87e+tYdubJD2yo9acTDeWVS/Os5QYLEc6IxAE6sveD
	JB3aN0+BJBtuXSu59+FgXEuqKDg7mYpuKKiA1G0Whb9nqDkvMFvAza9NXEK0Qmx373HXXFhtvLu
	maJ69Y2J2Dty1Jt5qjwse0OiLH71RXD/ROkL4yDNpA4zyjD3uYmhDxBEjEZR0Z5pqOUjUmU97VG
	uTN9XTh+lynAtlqlWVzsKrfb7cxIQp2dqFLvrxR2lPfJLZmsZZkQRXNpJ2ZsRAZhIMR0WVfo4LU
	lc8hn2Zs3fn4hCOcxrbTTAs4ammxPMFH7w1LdfFUwUyad6oasS/EDI0c1oOwWQxX56hRQzOaAWY
	hs84u743WYwRAt6HttSB20pXdJk/CfnaoQ+nOB9C/0ifewRRsL2cWnvmzAx2Md3uNpHSUzFrt0A
	hBq1WaVNUA+K8s0wQre2yEM=
X-Received: by 2002:a05:6000:24c5:b0:48e:6264:c373 with SMTP id ffacd0b85a97d-48e6e4f5798mr31061860f8f.14.1793708519379;
        Tue, 03 Nov 2026 04:21:59 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71bae25dsm22412110f8f.59.2026.11.03.04.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 04:21:58 -0800 (PST)
Message-ID: <b1c86bc9-24e8-4c87-b2a7-2eefbdd96c12@gmail.com>
Date: Tue, 3 Nov 2026 13:21:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: respect cpuset restrictions for surplus
 allocations
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <d1e41a65970ced879715a73ce2607de7ad102fb2.1793692578.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <d1e41a65970ced879715a73ce2607de7ad102fb2.1793692578.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: jprs8bzzksu5guwxoubirwcq33tqwjzf
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 25BF44000A
X-HE-Tag: 1793708520-992518
X-HE-Meta: U2FsdGVkX1+IQDilBe+BaNXXxW7KkoxyQIoYef5T9COK4gdMWzNfEuO8IY/KNM3PjFDlXhDwrt1qeqJnB7hbEAP/DDbcK9ixP2feNOiZCZW3HdduJb1qkRmy64A+v+mmstyspnQmxELTJAS1E/Zlr68BpGpza5ztykH+nuv/5gQrunFFguXpJ0zq7fiNeRCtF0Oy2k0ubgXdU7gZlDdJDkiJwAAK9fibTOCFPX0LC88JcYqgf8Fi+u/9r+sRGgs3Wlzq51GuKcPbcpRxc46s4Py3YMdZEKVz65U6TIPSNZics/VOz4b34meMdj5DGGuOtViT2LAfC+lLQzQV3s0QuvCANA06E3I87ECdQd94wBsUTD7Xsnj3BKv3apYYmdTErU5xWDt+uQCgMuhWs4R+WPkwH8i1/XBrUYXIh1StB17iuEuyjIS+HnDJLpoj05w5omjskCcPGTX96FFnfosUvrrI1OzZaHQT6ebCIVD+wT3d2RI9nsP5EkCko2GslvRFMcuqNA1rtr6rFQxP9PkL8nqKSQgDg5BsK9Bk+d+XePfakEp4iTT1XEMF1ZLeeqfddxbiNEdeZEdgKHVN4THVHwAOZnnI2O5X4zfqMw5bbLmd1LpOoNiiMS9ki+tS+Dy1m5iwlMxp/f4777PD0UMcrXS2t0i/0FB2sYTulCWwl70DEKci8rLf7xOAIi4b9GiE2dJ47SW1ai7hFUR1vkcJLv2pUXl3V/4tYJ0jnOtYVc5WE2iRC91fDUX4VSyB+zkZlYXApH6FbJGKCRTcJ+DNW7M0KgiO6JY/+JkGsb+bABxsRMmVktpSdVm2B87tV8t1ravKvhKQAZ0lj5U334Kb8BBxKenNud22CQqOCXPdoPv230kgyFzhR6+giD+UUcvExL+xiUGir3BZEwYn9OTtVjcaXEHAKqUSeSwZrowbqf3C4W51iZeg34twHVSyKti9yy2jaLFGBpdFc0c6I7w
 Y+XdkikE
 pqPibw2S7z7d8/GUsDieGDpbppnO/PBz6A91pJOWQVtDm8G2nwRsPJliUDgxM5BqcTnNgwh7pw5uqvN/+InWbzPbgcHNvUXqUcwOJZbKEEPQ2c8oR9TCxjyjXLXg4gqs2Wo5q+14ERhBZ0sQ0v8nXcDGf8CDnLznLilOO44bWn8/v++r0631pCerQzejWCbHgijn4UYTy124Bf5Khxb3t3g9BZ4nst0Ay8QGbnRDu4F135eJi5118ENUb/QsXq5T6Zv35XY/lHvtavICwtlNXFe8w1VTNwtmuYmp5m9aU8Lm4kaXgwDJlby51ParNu7UfiKbaquVNkPpXiVaprme2SDsn+7v27WJAqCRVrcjdbtwLu/VdaLgm6ZxoY7USLqnviwRTKse0rEekpKGu7nORSSOp4S0wdkhnZn/gkYLqmNXl7vcfGMDBDV/XQ4Y5eFZRifId51t7uT1jzlJMvat2iJ86ezpFRtTitYH6DtyWo0nOegCN8Y+YivppalZLtu87qy2orQIvAyVf9PX0FF8qD9GILA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 9:01 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Gigantic surplus allocations can escape the faulting task's cpuset.
> CMA and the contiguous allocator trust the supplied nodemask without
> checking the current cpuset.
> 
> For example, a shared HugeTLB VMA has MPOL_BIND={0,1}, and T is a
> non-leader thread. With surplus allocation enabled and no eligible free
> HugeTLB folio, the following sequence can occur:
> 
>   CPU0 (cgroup v1 migration)       CPU1 (thread T)
>   -------------------------       ---------------
>   cpuset_attach_task(..., T)
>     T->mems_allowed = {0}
>     /* Non-leader: skip
>        mpol_rebind_mm(). */
>                                   /* Fault; VMA policy is still {0,1}. */
>                                   policy_nodemask()
>                                     /* {0,1} intersects {0}. */
>                                     nodemask = {0,1}
>                                   hugetlb_cma_alloc_frozen_folio()
>                                     /* node0 fails; node1 succeeds. */
> 
> The 1 GiB folio is allocated on node1 despite T being restricted to node0.
> 
> Intersect the interpreted policy with the current cpuset before surplus
> allocation, preserving MPOL_BIND and MPOL_PREFERRED_MANY fallback rules.
> Apply the restriction at the policy-aware entry point to preserve
> per-node pool management semantics.
> 
> If the cpuset changes during allocation, rebuild the mask and revalidate
> any allocated folio against the current constraints. Keep it if it is
> still eligible: freeing an HVO-optimized folio can defer returning its
> range to CMA, so discarding a usable folio can cause a needless allocation
> failure. Only release the folio and allocate again if it is no longer
> eligible.
> 
> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> Cc: stable@vger.kernel.org
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  mm/hugetlb.c | 38 +++++++++++++++++++++++++++++++-------
>  1 file changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ce9c8e57b8e5c..6fd6e58ace869 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2181,22 +2181,46 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
>  		gfp_t gfp_mask, struct mempolicy_interpreted *mpoli)
>  {
>  	struct folio *folio = NULL;
> -	nodemask_t *nodemask = mpoli->nodemask;
> +	nodemask_t alloc_nodemask;
> +	unsigned int cpuset_mems_cookie;
> +
> +retry:
> +	cpuset_mems_cookie = read_mems_allowed_begin();
> +	alloc_nodemask = cpuset_current_mems_allowed;
> +	if (mpoli->mode == MPOL_BIND && mpoli->nodemask &&
> +	    nodes_intersects(*mpoli->nodemask, alloc_nodemask))
> +		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);
> +
> +	if (folio) {
> +		if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> +			goto retry;
> +
> +		if (node_isset(folio_nid(folio), alloc_nodemask))
> +			return folio;
> +
> +		/* Balance free_huge_folio()'s decrement before caller accounting */
> +		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
> +		free_huge_folio(folio);
> +		folio = NULL;
> +	}

the page allocator only retries when the allocation fails, why does this
need to drop a folio that raced with a cpuset change? retrying only on
!folio would make this whole block go away, with the check at the end as:

        if (!folio &&
            unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
                goto retry;

>  
>  	if (mpoli->mode == MPOL_PREFERRED_MANY) {
>  		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
>  
> +		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);
>  		folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
> -						    nodemask);
> +						    &alloc_nodemask);
>  
> -		/* Fallback to all nodes if page==NULL */
> -		nodemask = NULL;
> +		/* Fallback to all nodes allowed by the current cpuset */
> +		alloc_nodemask = cpuset_current_mems_allowed;
>  	}
>  
> -	if (!folio) {
> +	if (!folio)
>  		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, mpoli->nid,
> -						    nodemask);
> -	}
> +						    &alloc_nodemask);
> +
> +	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> +		goto retry;
>  
>  	return folio;
>  }


-- 
cheers,
jose a. p-a

