Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA95FCA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C921A6B0088; Wed, 30 Sep 2026 10:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C2B6B008C; Wed, 30 Sep 2026 10:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4496B0093; Wed, 30 Sep 2026 10:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77AE16B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:39:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9FFC1407EE
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:39:40 +0000 (UTC)
X-FDA: 85270687320.17.4FEF6A9
Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com [74.125.228.97])
	by imf12.hostedemail.com (Postfix) with ESMTP id CD12340003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:39:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SKP3dk29;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.97 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790779178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zIgRBEcUOotWURvolQ5JIFyn/MboxYU1izn9qFVjOk=;
	b=DjJs9ton3MfOHUsgfHp2HIZecX2HtcoFcRtfvmFwxdafjlatOTSAFS4nzr5vs+N/joeeo4
	6XH6nlRqmEPnJIObamJjuUpgnwFDLgy3shzcXl+wGNMNrvC2Tbhh1KhevPCYVhuQm7Svt+
	BXMarucLccomN4I41F8xnCRedoso7fc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SKP3dk29;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.97 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790779178;
	b=rw1lWQcWxMc9ZxZcUFCXOb0qlULiQnaNG6oHoGz1oKBgRa+Fe8bEbyXJbngc5tkkEuqUMc
	F+5cHoGgzjNuSnnlKmRabP5GJinXMhVb+BPabTSIP87KewnPeCA0sTo3JYwhfQQsLfI7Sz
	ag1Ym2iltSlJIgpGvUSBWbweElUIoA4=
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ab0d9260baso5983137a12.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790779177; x=1791383977; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8zIgRBEcUOotWURvolQ5JIFyn/MboxYU1izn9qFVjOk=;
        b=SKP3dk29oKPRE53gDiC6j3VInW6XuWQRtQob7/2Mk0JxBU3MxvjGo7da8nldmKffDa
         MSDdnAsVSduINyy15zuz7Fl0cghqDpMSvp1X8Iz+YN3+7IHPtjFfFyu3PZPhsqc1QXP5
         Cn/o/kM33ED8ERaxXDNN+hneQh0xhWH8/EqgWulHH9P7xg44CDmMSYPpNG2/StVX8D3Y
         vGpY1T15Sg6OGNZp3IlxmrVH52fjJnIg8l2d5qV4IhK0I0BLYB7EBzMW5s0cC897yd4/
         JHzDoT0UA9spXVxXoCz8JcpbUPGPK10fB0x1Dg4wbHeK4rAHqWjZHKFqPBd8XXxXaMck
         G8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790779177; x=1791383977;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8zIgRBEcUOotWURvolQ5JIFyn/MboxYU1izn9qFVjOk=;
        b=mvu/0l3LrwwKmZGpKdWGIzjtSOqnDD+KL/O4MJQIljtAa6Nw1FHz8l21VM5tLhzn3R
         jWcp2wts+ELVFJqXi0NcSTD6tfhiH9kC8OU7bGF1E5Ld/l2lTWfb5ibtNkCiL1+T5YGO
         6rNx7BLVwT0jn7yBkd2AqMiw62c0I14G5QfT+8IY7MpUtwPmnecg8LzBGc5V0GFbm1IC
         2ih02+uDWbFrak7NAM3l5cJ3cbfM+YIYvGYPaATti1qP7RM+WilTD1Ct5u5YfaVrVt4f
         TOGBbfkys2zJVpb73duGOxWFdw86Oy+ThTvQH78QlIgekvOAigWwd54v/REhZiqIa1rI
         OcTg==
X-Forwarded-Encrypted: i=1; AKwUvBzNeNo1tr3WI01MVTu2uz5xUJW8m5C79DxV6d9+vK5svM/cNI5ZRImVydAHDD+6HswhaIum/5fdGg==@kvack.org
X-Gm-Message-State: AFuF++nRHPxe06etcIYbGQS0oloZ3vdFUGejcpRreLiKYWHAuJcztRm9
	g0UuBqM2/EIYsl2Ug3/TMnWJWK2SpMQ4CNWbwZnWHeX0InsKuACo8/uv
X-Gm-Gg: AYBFou27fqtECEDrrmA3fgZni3P1YAoRQ/CUPZ9P8ey8xqQdJmbFIpRHl/ZNH2gAKb3
	KF8joOzXJvNPFS4si7s8uEfzExSlVMTRIoBLf8lT9dipkbDi0qahxcLo3ne8dkRVCQEhJhZiPFN
	fOA7rV6r6AIBudDph34b2ab2woMfnKBxVcqJeZ/wAyKg3S3mswZDM3JBvMYt+g2l5ldMn7hIwrS
	9Q209safHeuTIfsoQ8gqQLRZBIl5eRm7iefeExWsNrz6l0jFdqac7+ZfW8/W/gRdQOa3WkrdCY/
	GH94lGkWCwp5TRoyADVCnndZrQBecluGeUM4C0+StKRRUsRay+7CKTmx+iJRLEm7su0Kk8YDh1X
	J1P5chFjATYmigVjWEzf6LmXfmiO5p42AETTkM6HOyxVtFPzebydJk1Weh4cOV2HN0zfnBxELDR
	aDgU8ZWtf2n1nXPD3lZEJSRItnx/Kf+ZxuDxU=
X-Received: by 2002:a17:907:2d24:b0:c29:5172:6151 with SMTP id a640c23a62f3a-c2e23de355amr130161966b.45.1790779177087;
        Wed, 30 Sep 2026 07:39:37 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31cf0d6esm13604766b.37.2026.09.30.07.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 07:39:36 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 30 Sep 2026 16:39:33 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org,
	chleroy@kernel.org, david@kernel.org, dev.jain@arm.com,
	jiangwen6@xiaomi.com, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v9 06/10] mm/vmalloc: extract vmap_set_ptes() to
 consolidate PTE mapping logic
Message-ID: <ar0fJcjNmGGV6uFu@milan>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-7-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923062832.479455-7-jiangwen6@xiaomi.com>
X-Stat-Signature: ez4gbjfxepep6wufx38r65yrfsnoryq3
X-Rspamd-Queue-Id: CD12340003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790779178-513724
X-HE-Meta: U2FsdGVkX19lYbunZ78ngLQkqJ2M90FT0XIfrgTbUtmatCRd/KQUr5qY51CeaJA+6f78hBgHk+CsVY5Ryu928cibA3vw2kqlSvWHWOOuHdYiH5X4QPGXNEzvoZbWp+Fw2qq6tN3AaQzXVqNfm4hff/bZnwui6rzSKUVEHb5sIsYLO1MJZtL3Zk0Q7U/bnIg9l3nS8FPweeLaQasonCwfY3H9naKuF3SOBrOFNFA9FFVH/qwz12KQQ+9a6Y5dmNz6y0QLtpdOV0bv28KrzBWKqyFa+FCf9KlPLfURTu8hoydIBWxO2jYyQBiATgRQ/6gE6yf/c7txUr5EZNbqVXZzjaAgsXqPV0TQAsIeiHkKj6PQafUmt6+vXa7HdX0b/q+BKrZdZWBfrn57EKgiQuDfaOhlwdWgWnGWf+xB19XpNvIlxaforkeLBZMbl+9khiGtOyvsc5l+3GQ3flNvRp2ILKEsYRSEOCFgKwLKRrGqlDimRfF9HOwAmhqACZvrZ7HobMSDgsUKvXB6gXMHma8uqAPaX1IjNw11rS5NGpJom2q1sAZed9sQutRO71GcudutcZv4t0DYLiNG6rZG2PZ6yUBHUL4vUB7OYLZMkjh95TfVyL+gHtBHGVXNZa6qHYdehGou5JuPbgwBfXU02EiJB4tMCFSOOY5dBZTNI2ZOzYKrXgHwsKVbswVKRrsybkmflZitBxNk4mHvKCVjGwps/g6d9x7XJSJvR2u8uKxpnqSU9iCAZ+pkM7uBP8FN8KAv2vf8ENq/KcJPsJspwDwRjrX+pP5QAlJy9KCxmvC0cKqcs2b7mPAY2jVysWxuCH57wLm7Tr8NoHPLilL0K9EixE82o67NQoSN9yNQkqF38erJGhYV1Ot0yYNLjs/DP8C/28o1BAdYQS2wyu9tQ8tCKTZRjfYqkkEI7XHlbkNXX4Mzzx5wdXp1aSuHq1Qs03xaTWw3K6asO8CVu3HzVE8
 j1W/Zoti
 YAuIsLBjEBzIOOiwbenuLNS7ePpMoOU0Xk13rn7g0pT6IoR73we2bNQflQ4+Z3k+9MbPOl4i+NO6HCazy3HpqqJxestYMQqvP+Tv+uUaNbrIabqdNqQ9BU7bTwhdQp45N92jBSFHU2UGMCb6wSabaeDbxZwYVJFPsqUdOJPoqMHaWArBXqriN5miVPJYIK3ovj71qVLQ5XZNllSBMT1wDwLPHxp1/ZGu890I43N6X0odNDX32ULhRfUZ8x9jJrMftwPcvi3OLmHhL5tgj0+HQ0DYibb+Xr8CVboeCypFGNoCb7nRzEr/2TXiKPLRIc7ZE56z3s1Vm02XG7PZsiZPFrv9dajoIUQIuzAnfJlG61C+FFWoin6UvBxZw1EXlufoyeVj7a/NqZ7wWV6u4BYkw2jBj2zgoax8Y9Vomzpusy3Wy7ddsn3cIjApFhz1LZmHZUel5TXBBtZ5ASHhEn0MUF/8fCKug0AjW0XHqHdu8XqGo3q4DHbv793lWQTY6G7pqQaYNLQi0opdYE85Sv5GxXMsbLQDR4bfXLQijgziS3rE8k92HrZ4rw69IqZdc9UjF+BVfljJKb+/cLJtd6AnItBv2RLH9XwFC/hFCmkK7/aJ7EBUubKnECpal2TrlNRxjM1KjpqGv37k8X3RF+36cQRoM02JaE0yQqFVr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 02:28:28PM +0800, Wen Jiang wrote:
> Extract the common PTE mapping logic from vmap_pte_range() into a
> shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
> PTE mappings in a single function, preparing for the next patch which
> will extend vmap_pages_pte_range() to also use this helper.
> 
> No functional change.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> ---
>  mm/vmalloc.c | 36 +++++++++++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index fb757d95bde25..d475e52110e4a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -92,6 +92,29 @@ struct vfree_deferred {
>  static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
>  
>  /*** Page table manipulation functions ***/
> +
> +/*
> + * Try contiguous mappings at the PTE level for arches which support them, and if
> + * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
> + *
> + * Return: mapping size.
> + */
> +static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
> +		unsigned long addr, unsigned long end, u64 pfn,
> +		pgprot_t prot, unsigned int max_page_shift)
> +{
> +	unsigned long size;
> +
> +	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> +	if (size != PAGE_SIZE) {
> +		pte_set_huge(ptep, addr, PFN_PHYS(pfn), prot, size);
> +		return size;
> +	}
> +
> +	set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, prot));
> +	return PAGE_SIZE;
> +}
> +
>  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			phys_addr_t phys_addr, pgprot_t prot,
>  			unsigned int max_page_shift, pgtbl_mod_mask *mask)
> @@ -100,6 +123,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	u64 pfn;
>  	struct page *page;
>  	unsigned long size;
> +	unsigned int steps;
>  
>  	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>  		return -EINVAL;
> @@ -120,15 +144,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			BUG();
>  		}
>  
> -		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> -		if (size != PAGE_SIZE) {
> -			pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
> -			pfn += PFN_DOWN(size);
> -			continue;
> -		}
> -		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> -		pfn++;
> -	} while (pte += PFN_DOWN(size), addr += size, addr != end);
> +		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> +		steps = PFN_DOWN(size);
> +	} while (pte += steps, pfn += steps, addr += size, addr != end);
>
#define PFN_DOWN(x)	((x) >> PAGE_SHIFT) - how many pages covers the size.
Replace steps by nr_pages or nr_ptes?

--
Uladzislau Rezki

