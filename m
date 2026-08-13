Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04980C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0BCC6B03F7; Thu, 13 Aug 2026 04:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBC2A6B03F9; Thu, 13 Aug 2026 04:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAEC56B03FA; Thu, 13 Aug 2026 04:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97B9D6B03F7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:25:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C76C120590
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:25:01 +0000 (UTC)
X-FDA: 85095560802.28.B47F5AE
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3BDF0140006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:24:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cgofhNGh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olz8czTGt9Myorg9Ej6EStVuWMdLaEwvC+90rEKHcaE=;
	b=JX/AYcHrZKx65xccquPpELsZs4PzXMzRu5stWefjovP9R0/Uzyq1J3moNpZU3O63hFwjND
	+JkT98N4r1PXDdvG2GFvw+PZK/uK3HA016nBWYyYBfel75WzEOwMwXPIrWD9aLEat3kOc7
	suEWp3p2lZ9Zt/krztmVbXYeHudpLfo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cgofhNGh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609499;
	b=nqN5wvubyXJDOZ59lkhSLtw4UkagHMdW1H9HP2DPZNI/ScugrZpL9XfP1Zis1su8gPaG3F
	JSOedSCwkPgueHqLq5yrTBnltLFFREnEXq1uL1e+1Q3HunbC8FiKsKe5hKmshviP2qe8Ac
	p/gkI+fTHYWqVee2WEteKHpesU9U8wA=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47fe89fb333so1026316f8f.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609498; x=1787214298; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=olz8czTGt9Myorg9Ej6EStVuWMdLaEwvC+90rEKHcaE=;
        b=cgofhNGh0lYF2+0jOflgSkTNpq198VqNHzqk8TnjEh92pd21NDxd+M4jaRek9Z1wuX
         9H/jKzq/3AtGJq4QLKyeBVetkVopd3ohOuFJz99nrYya8v9sFJaFCQyOxZHXpVpdoNwk
         Vob26XGL2BrGIKn9Q8f7BFYW75mRAT5X29onrZmyEpHSaP/uanNyLNg0Ou6vwaM3a5GJ
         33g92dzs2HK3svMkIcunnYTwlSf5s3WQ5a79bzxxzCxTCZuCe7xNLb4DfRJFCWXTT7A5
         NHcHyHjAVQwuzCeV7/YdY71TiSoFdILjq+fO57Xu1DolV6YNfprm1EczHfF1xl8w2exP
         ucrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609498; x=1787214298;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=olz8czTGt9Myorg9Ej6EStVuWMdLaEwvC+90rEKHcaE=;
        b=bCkWHvxLs+TGEbEpX8FfdBVFvjULIjLdS/SP0ZCCUfWxzXARAbjOrzLHDToLNyDZ9h
         32CvM3bJmohc15qj4ZAmGimZXWC2Huqzg9bnMlIV1fnN+iQqHjmIJemVtLwxKz4zxnnJ
         z1P+YxRMtmZfZ7h7seJjZ4OKBC/G4Z4axxuoEhjjeiBUlQ0qpXQi5lChSz9Q4wTzxsPX
         k0RKkhAL/y+fdwv6dOIlQefMLCeda6MfITT8bpqSCFjehIA6nGykHQfZvuotBtBwmpQO
         UAU2d71dyTvtz8SCzlmgXDnrJjYo6SkJFacb7t/rAQDDCPWrZzfzcI377lVMj2W50Sax
         LYRA==
X-Forwarded-Encrypted: i=1; AHgh+RoA+BgZ7AlIe9HvZAHdWo4+h8dD1VF13zgUoFmc1zVLw+BEb1IElEqBFLdfmifRxVy3MqKFsjcCwQ==@kvack.org
X-Gm-Message-State: AOJu0YyNBMMXZbCkrIelE/03OufsPpuhK7fQq/rHcWVadoE03Pu9gFiE
	agPLjI/0ty0jKSemiNzMkbgAWqCEgfX/vRqgn/RaTYdNBMoflEkecgFv3R8eMF3gnsU=
X-Gm-Gg: AR+sD11i50Yc9JXn7qnU7fc5eTKM73e5ToKVwHblPrdLaCDPFivTuKo2wcLz7B6IxaQ
	mx/e2neM03O+l0NhKU562JkO/fX+ooPp9aKj+t/0/0GxQ6YCAwCzDoTed823p5rXagMnAwAzPOG
	ddnTU8gH8nRPx9/6YUlOCKbmorAIrJMcsP+g79x5vgWvUE6/3h/I7DfML4GXFbvG7QNeSiRBb1H
	3eQ/lUDf3aoDTcHEb5tN5RxSffLakSBoErJ48+qkjRnrVzgu7il96CJmFYENPStE7/GUb6dlfTK
	+XyGT8OVTrUfm2PDdEoJil8Gb4XCAZ5K4qBYZdhfnzFX33oVvxYqPSEf+NiA2SfjC9U6K1Kf9i8
	DpZkte4fIsAkGtJNSgWqHVEQ/6WzGohqsmojB9aljTeWZF0mDamUF9/7EwTnSu834WYOAdH3pnf
	Hfz1G3SfA9+Ce4PVU14iFhFpM6TwOM1Ru0MMLaG5knYzHvDnIyxvW2WenXmGUAdkxZ/s39CsQRd
	H9yTPsPPQ==
X-Received: by 2002:a5d:45c8:0:b0:481:4dcd:aefa with SMTP id ffacd0b85a97d-48159ca6290mr4320423f8f.6.1786609498024;
        Thu, 13 Aug 2026 01:24:58 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5af19fsm4502301f8f.24.2026.08.13.01.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:24:57 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:24:56 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] memcg: remove mem_cgroup_shrink_node()
Message-ID: <an1_WBpFCiYL2Flr@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-4-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-4-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Stat-Signature: q7bi7kqnzk7tgz44kre988be8yf4968m
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3BDF0140006
X-HE-Tag: 1786609499-79862
X-HE-Meta: U2FsdGVkX1/ovpRSYKvuyJwJNCMbQvRfjZyx3dl5A7txLe181A9KJLBkA4C1UJlOXQTK8oufsIk/WW1o6oFKpeVB5MyiDN61caMq3cKGIpWlsv5d2bvdm9NI3zjiOgrOeN3E7EcoY6gMmiiWERq/umpG47miNQIjp28PYOzoc54crxvdmHqDUTWljHs90zjGEqPCV1U1ZapGDLKGwY+u/UK80p7DUvYwWx8o+ocn3Snd/q58LgupmoH+X3nlkb+Y7WIGsZBSua33V7XIYDGbq8xGdhOqdIjk2P6Apzth2/Ejoccj88JGTrxxa8ZlOCp4Melk2aQ4aOWYBQusN3vefhu8iUkCKllWogMoqXOiSuWCg1QMRDT2l/rqtxq39zF43vd3mpSjv++YfKCms7ATZlYkcAYvVPGko7C7CWNSVOr0THPyO3Qdm9iFaR291QTDvKstNGMsEyfoMMV5GQPNJ/koaUowvFeSVHbGrqk7a6VAH6pRSS5LXOrKE4a5EbUT9ykCbgx8WXBMBawO8E+vjKSnGNivxbr5Jhfhy7OwdLz1Y3zoL0LLnryBIn1coLEPtFpHIAxd6cyenUzo5/kAarJKDtYCsGZRR2xrmxd3EZrsFtipnEfEm1Yc91kFVIgXyHsz/yiTg/cbzyNNc8aSlULmyiuDFZxXjfPMMDR6qN3AweFDG/qmBROqkf+t/jyYOcNuiVRIYrlz7m68LTNsa7lsjt/j65XWmYzPwcX0aowEzpuAK8aOij1uTqO1NahiWedxRNiiP1Wxb8dRDH9NO1xHHlj+Al8Rq0QZ45DXgYQa8x+myGaewZAPWBKdWUxnXis0iSEd/Zkobg+l1IvzhrD0S+Dsl3wdjFciUPv6al5uMtImgJRpR/t2kW7yp9Q9fSlD7m0BlZEthomR1trsQz5Yw9RFJ/AIxWToLlW+7A7YN9zqbe0JWE80bEA5oJd4jNlQ2xZ/L2pYCJguN4K
 81i66KDs
 nNvfMjczExvcF4zlwgQi5qiynYf93qSU3uSVAjTj7zLN21esuVBUMnOAJ0yH9fzw+AqM1yt85SuRxVaufTCluz3/DLd3PcKRrUjyy5Nxv9hNRD4hdXVj5zwjhQWnjz+cFDSUvQoR0+gO+fX9RrcUvAcui+ESjV9ziM1ZW+cWXcVHH6cn5lTFttdRf77VutfrOgKCDkVLOZS7qmMvPA2f9kxBi69OIAB7S8mUXsBYYj3L7H4MdiqhyT4ruBB8xpcHSxQ3IHHMFQP8swRyJfxqzrlNCfOjaUb+0iBgEuXMz0rbPTM+Y2xo39KcxZ0oRJCRsTtccPtTQVN3vkMi0EDgnidTE028eu9Voj9iawv1Kh2IZlIfOpGxibzE+jQNX+kolz/PWoZTbz7jAUhoSAp/DcqpzDX2WaNqtBB8vgKm4E0Hj6uYBRZrrof41O50/8GNDU3RCJ6I8i5ty/RYsRk8/EmYaAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 13:31:57, Shakeel Butt wrote:
> Its only caller was soft limit reclaim, which is gone.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/internal.h |  4 ----
>  mm/vmscan.c   | 41 -----------------------------------------
>  2 files changed, 45 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 678ce8d03515..b2315bdb7350 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -85,10 +85,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   gfp_t gfp_mask,
>  					   unsigned int reclaim_options,
>  					   int *swappiness);
> -unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
> -				     gfp_t gfp_mask, bool noswap,
> -				     pg_data_t *pgdat,
> -				     unsigned long *nr_scanned);
>  
>  #ifdef CONFIG_NUMA
>  extern int sysctl_min_unmapped_ratio;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 032b14793d91..790b50c78a2e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6795,47 +6795,6 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  
>  #ifdef CONFIG_MEMCG
>  
> -/* Only used by soft limit reclaim. Do not reuse for anything else. */
> -unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
> -						gfp_t gfp_mask, bool noswap,
> -						pg_data_t *pgdat,
> -						unsigned long *nr_scanned)
> -{
> -	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	struct scan_control sc = {
> -		.nr_to_reclaim = SWAP_CLUSTER_MAX,
> -		.target_mem_cgroup = memcg,
> -		.may_writepage = 1,
> -		.may_unmap = 1,
> -		.reclaim_idx = MAX_NR_ZONES - 1,
> -		.may_swap = !noswap,
> -	};
> -
> -	WARN_ON_ONCE(!current->reclaim_state);
> -
> -	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
> -			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
> -
> -	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.gfp_mask,
> -						      sc.order,
> -						      memcg);
> -
> -	/*
> -	 * NOTE: Although we can get the priority field, using it
> -	 * here is not a good idea, since it limits the pages we can scan.
> -	 * if we don't reclaim here, the shrink_node from balance_pgdat
> -	 * will pick up pages from other mem cgroup's as well. We hack
> -	 * the priority and make it zero.
> -	 */
> -	shrink_lruvec(lruvec, &sc);
> -
> -	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, memcg);
> -
> -	*nr_scanned = sc.nr_scanned;
> -
> -	return sc.nr_reclaimed;
> -}
> -
>  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   unsigned long nr_pages,
>  					   gfp_t gfp_mask,
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

