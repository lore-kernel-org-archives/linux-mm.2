Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B77E60A261D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WbH3djcK
Received: by kanga.kvack.org (Postfix)
	id AF7426B00EF; Wed, 18 Nov 2026 14:10:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8EE6B05B0; Wed, 18 Nov 2026 14:10:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997EC6B05B5; Wed, 18 Nov 2026 14:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 703F16B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:10:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC5C9A089A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:10:34 +0000 (UTC)
X-FDA: 85449181188.09.D614A1B
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id EDA47C000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:10:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WbH3djcK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795029033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVQ48tYQcgbZ0/KEDLqaISGszEZvhwKB3BC0TwvqE4M=;
	b=ENvczg/jrA6yGg0YISwFU3Mq9x3c+jqo1xU7BfGuukdiCXzhWcNWRfO5B2UszIKhXpD1bo
	fSJ52BL7hZcnI5fvvhQqilUMn6jOsE001Kvi+6w5DHU89YgvHnkR7JvzKbqcVmPEheTDPC
	Hs6CNkQ4JuTjG1rbT1RfYRHddw9NxVU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WbH3djcK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795029033;
	b=jXtH2X/BhCqDubF0F8nIll3hMKmCqZv4CkX/VFwSdsYLKHfeXytIV/XVP2PIJomvIMvcNh
	6M9MiyeI5aAb/1K/VA7sQ7ebufjHp/MmOy1Y365fXcb/8uWoA06D5YOJcNH8761nDR8Fdo
	lHcDzsYxH970lDPXw5P2RDt8korGE5w=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b7ddb99db4so2025794a12.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795029031; x=1795633831; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iVQ48tYQcgbZ0/KEDLqaISGszEZvhwKB3BC0TwvqE4M=;
        b=WbH3djcKCEI9A8hgnfx5GA6aL2Yo3E8ox7aKPlTGWI/XUSZpR5Xxxts8v/18MpL9c0
         KVzTRnt5bIhaO3E5QcDhdYbDTmJXB0j63lyx13V2DvaJfYC/fDy7lt29E6C+kHf++PQv
         FWks36xVSjyRLjMJK2zn0Xhcb0xJYs3ugLgBxKJnoYPoRCOWY822vusPM2rfwyMLyNlX
         UF1YbsfDTSKG6ZoQtMTmxsMsh7eR+YA3o3D6wvRi3GS5c1eDhU+Oy9rfWO9Nuq40UGX7
         jWiXj3S/oOn+o6hymrlhJFqmw7ntUVJDKy8pvoE+g8MpRWEYedliBxkH3vkWb33wZfba
         ERYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795029031; x=1795633831;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iVQ48tYQcgbZ0/KEDLqaISGszEZvhwKB3BC0TwvqE4M=;
        b=cyO6LPiUG55ulATFX1r3r8PRf2mw/CzU9HE84hCbw0y99JuSIWZCcBgYwtriiWyNIQ
         P9sS53aiXTH0o3xxOPGKrdenKMzyR9BHbNWl0Rmx42pUu0o9WpEOxbXG9Qt4j9rbcCRi
         Y2trPPDqG/+iqOMWKgITkqZ7m8bxegREx9e1ZOYOX5mMaAspTEXDZ1jy/AeF0QPdn0ew
         OoZAakcLmCMkOKy5XzWTXt5C8gWkPCXdA2u5gCKUBgQYtCDqRIHaZQuQ+rbPl09aoRkc
         yrKPkrJBCaBm2E/zMmrtdfYcQZExFfEVoyjWm4ACqL9UNA5OSZV+FXcpmct+0Snzc6yv
         9mfg==
X-Forwarded-Encrypted: i=1; AL+hErGlTj291w7Hh6sLVR3mWVYKwTlCafvi8KGrTp1aduCBIuTSmBvnTTYnYxebVG7+5bbZaOhBPwSPlA==@kvack.org
X-Gm-Message-State: APuU4Z8FWeFSCK72jOysa6Yrsmak+t3+lR/8mRuMyjaEqcXYRUkH90IS
	HkneBMbvVBzdpE4GlXyqHlp/+A4Mfjn2SVEhVmLeqtdkLXpNtKG05Zz5
X-Gm-Gg: AYBFou0HoI8qE13c0YMwivXX4YVTISgCxBHN7NEm0inW83V6qPDUJC70AZ9XmE2knF3
	5gstyy3IC0sw5Qa3dYAayHGw00Myn2N8W+yZsENA06VlFCGnzyW5vnOysAI1KAGoEzyxhriRIkS
	2ZBk7BiOMyVqMzWPqJep5RTS0PLN1MXIPj9pqMkKLJQMskds4MTH3uWX7d5QI5JKU6qg00Ah9rz
	lo+OZHyMhSRTujN750RUy6+kH8ak/dgUDVRCe8CR2Sqw/2re2XAFWDSwcm8iwOp8BlandzvhOiA
	vJbFLNT6styOmfohFuyqq9/RXcut/82glFOt1UagRO9pLfBbihxu7e6xQkNcz6yqiDhB6+YKyON
	STLtypGF2bY4lh2PZjx+s7TC5Hvvyzq9YwPQ/3n33KEBNCUsaTn7M1xz6mc4U2yT9Oyd2jxptK4
	kBdLkuVkyCfWD22GGRWRjUTV8D/rEtELAk17+woOuxeZGXzW1Aq0wEOw/7rG+uNmYnZIpvnlgNa
	BqpcWt28BoqUAqtmy3oc/aZgS33xwq6AZ/wjrO4Ufw2/c0IamkUaOVeAmWRuVMGImatcQ==
X-Received: by 2002:a05:6402:1d4b:b0:6b8:80e3:d58a with SMTP id 4fb4d7f45d1cf-6b887eb1272mr2966644a12.23.1795029031397;
        Wed, 18 Nov 2026 11:10:31 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b888ef9423sm1460511a12.3.2026.11.18.11.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 11:10:30 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 18 Nov 2026 20:10:28 +0100
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 03/11] mm/vmalloc: reject an unaligned range in
 vmap_page_range()
Message-ID: <av34JPIcIOVdF0kL@milan>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-4-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116071325.263682-4-hao.ge@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EDA47C000A
X-Stat-Signature: 1con3ttdtr9wwzbor4n6o5hdissqcpih
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795029032-358773
X-HE-Meta: U2FsdGVkX1/qaIYQ+NnDxgKn9EC1bYUdcRuBIgCJTvTdMDGqOrSt1aG22H64O1TSk1GFOayTa3tl7aRvBCR/u4s1Zj9dilsNyU760Nj4FrJIQx/kUjnTNey4afcnwTd52DK7QKoNiBWyH5GwtC0IbAadglHc8Ly3pNCHG7O2GLdIBIcXbf+XWIzgeSM7SACPxaeOD8BCMtidLoFCJM5qFAouHmbQze3gG75uYkaNEHhfyXhdP18+Uuor0a8sgXBNYm7CPt6hjZZb9dihgA6TBcdf6qSj++bZfM3LUy+Zal6oHZzvQ0wWjLvUgsMCYACPBl8ClUOWPsHQ7tsFoBE2HyxacF08bcSNbNVs6O7daofN39gqNoVOM9u1wPsdUmwMHde9iTwSCrz7vwjnJ4mLKSeH2qSTpDP9m5FJv5Uw379l81Vcy80oBgQbLsLTxjTViV1bKdHey6WCnEoK8XtHMGxhmwEEKL+k7TY0lsgtd+87MWzMhAQY0cGwwLVw7ZOucIr/fif72sMeyqUZzJ8h+l3Ew67BIbISN+ga6QsS6iAF3BQy29P5lZXtMLhGJmp10i+s1NrduvvdBZGWTJIyYL7MsZ5n4+STA7HFZhhcBKvkmpFzyYt2ip22E0cfVWA6xpF8K6Ws9ihp6AomK6s6YV3ur0e05O5VVxiw7WXTcBUlwrQPsQ5pOxLLr7fXcsSgiqHyew4icPy7226gjtE0sAI58deBOeocPN3lJe4uZi2P5lsvxQA5oYXkZHoYRCKOaI+iyM+um3wv/d0r4pfqHqH/3SR1UOuVZBr7QZ3/3EF11TPKJfyiE4JpYhd/dOirXsMeP1FH39QfwkNWKHCogQZNkx29Wd2sAV5JsqR56pVHs7h5peGxeo4x5LUzDIRykZdbAgvojEEu2inxR0Yl123qZucg7GOFhIPHwhQIQoAIiQcURoBloujw+Sa8jXh+8URjRg6wN1EyHGX1JeM
 KQ2uuKf8
 duHA5MSy/qCeVglA3b8yv4++VI7OuMcNNA1LY1ESzTsjPEWxtnm4J5J5vYv9uBu8hZj6Io9mv5IhGrim+Cp4jdu436yhA8V8gV1/ADxAA8utLg/Wjk249Z3GwO6/GuD7JypzihlAbT5v+qLNbOsc9QKrKnShiifM+3RK5Ie1OboCMhcGoKiRklH+CcIReOD5/ZAqInxebjz5qiwy9LlPqldxV6b05NCZGC/HohOOum66a5ll6Eetyo/TJcunbJ2JddHGDGxozbSdvlTEg+POUJboQkWXSPht9FUUBHZSKpzeF7FEJj5W+zP2QRfZU2adVtB4vSo9JG9ee95rpABHPMxqkxz+sME6I1HkMSvNRxZQrh4dHhospqHDq1VeJDl76wSHT9YBcPd8ZedQ6BIPRyaovg9gRHIBdREcz2wKXPIqX/eevpKYDZsobk2tzdl8KYSB0/E5bpPyFpoLLdTlp7ijCk2valu2tZdXGHTbJh41FQadeOEA0trLsnXf/+rspuLieLlEhWgP+vTNWlKKAJZ2x4hEsHy901AXpsCPfKF+7S5rCOFGJbEHnt4Ipk7nE2Zls+bucg6dLB8cXmJ2KrG1FM26vw1pwXc3+G1Y+0IHm9N9RZ9romV7Q4I4EsNAqckqYh/39OizwNfqbE9H3/5uRXH8ZNflaLhvL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 03:13:17PM +0800, Hao Ge wrote:
> commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
> PAGE_SIZE aligned") put the check in vmap_pte_range(), which is too
> late, because the upper levels may already have installed page tables
> for a range that is rejected anyway.
> 
> The pte loop maps whole pages and stops only when addr lands exactly
> on end. An unaligned end lets addr jump over it and the loop keeps
> mapping past the range. An unaligned start maps the page below the
> range and usually misses end too. Such a range is never a legitimate
> request.
> 
> vmap_range_noflush() has a single caller, vmap_page_range(). Warn on
> addr and end there and bail out with -EINVAL before any page table is
> installed, and drop the check from vmap_pte_range().
> 
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 3c0d9e69b886..a168f6f20f4f 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -125,9 +125,6 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	unsigned long size;
>  	unsigned int nr_pages;
>  
> -	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> -		return -EINVAL;
> -
>  	pfn = phys_addr >> PAGE_SHIFT;
>  	pte = pte_alloc_kernel_track(pmd, addr, mask);
>  	if (!pte)
> @@ -369,6 +366,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>  {
>  	int err;
>  
> +	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
> +		return -EINVAL;
> +
>  	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>  				 ioremap_max_page_shift);
>  	flush_cache_vmap(addr, end);
> -- 
> 2.25.1
> 
LGTM,

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

