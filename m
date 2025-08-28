Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96328CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C483F8E000B; Thu, 28 Aug 2025 04:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1FF96B002E; Thu, 28 Aug 2025 04:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35958E000B; Thu, 28 Aug 2025 04:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A34786B002D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:43:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41ABE853A6
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:43:56 +0000 (UTC)
X-FDA: 83825528472.30.2AC8B94
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 615DF120002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:43:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yQGwJWz0;
	spf=pass (imf29.hostedemail.com: domain of elver@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756370634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLT2osl3N94HJBBJWKPAk2avCo16Lo88yw1WJjz/wsM=;
	b=yFOAK3Tz7vz8ZS5Qi4nNLRABrFBnYzpsJimnTGKcapX2S5L9d6gLM1FZ173K89bdlzDCTl
	uq5vVYc7oStNHEjaJjY10tFpWWzo/Psv3UVFY5mXhaLNWWH97TGsZmf030H6XwTxrwXxE6
	sgfVo+JAYTMKrjxe5hjYSa9PhRmsBnM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756370634; a=rsa-sha256;
	cv=none;
	b=SvPluRAg7b8og+oYPg1IBBb+Mteo8rd+skXWfEkTf4OLygNhVh/IP4ZPQo9ZilUjJs7bCT
	RTWFAQYSra+voidPDH8rK9ByhkqpAreDCfhdgkjNTFNQKOV9nTDIQZINwV5vCMKXDTZvkc
	zzMnkuOUwgPzUZE7/HCM+oHqb3PGkZc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yQGwJWz0;
	spf=pass (imf29.hostedemail.com: domain of elver@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-248d5074ff7so3596675ad.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756370633; x=1756975433; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jLT2osl3N94HJBBJWKPAk2avCo16Lo88yw1WJjz/wsM=;
        b=yQGwJWz0j5q2UDFyzvAbskZurGOk5fag1bGIgUN04ielO620HoB4S62tk3ZywixmJO
         PKJOkL7WbWCHU5Ucpg4S0b5XU34ivK5Jz3N+XAanbV1PwQXBdIRrgtJLG7/iGKhMKg3u
         sL5flQIl3dMY8+qGI9+XLBHgSva3A+KY4aXWyzYhGp7eu83Q9oco9/R3rfjKhWC3GjvI
         uI4LH0THgbShAtqjmhAbTwTQfNonn02Ip7tHMDrj9nlyfH498yXe6tgAyu5yzHdNe4te
         zXyxc8lfs2TTASCC1XzqSW3ne39/sAcs/nWLtafFxfUK5iIrZ9tq9jM4PtBtUL58sah3
         7bfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756370633; x=1756975433;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jLT2osl3N94HJBBJWKPAk2avCo16Lo88yw1WJjz/wsM=;
        b=wIyT8+puRZdK4tnidb5qfla5fbRBs/dpvpt/S2Lb6x51OctA66ip9gXEOQu8iOgDNw
         nhRnaz/sPFLUV+oSq6IGEW23c4HYBLW/Em5v7JUbno+KXkVYNZh6k8+HMhetGk6vxCDY
         RQohYQw9gITqzpTB8Q9JuFpvC/34NnRM6AQfbtEcUVmd5J3pLdz/5Td+EuxIpPrj8Qxm
         MWzBWdEAvpCUpGfKL7s4VijZCcqFlta/yyMXXqFp6a+JrP3IfGDAbhyNDjJzgIWsuo0u
         wEljawHr0kx6LWfaiwKIjWZVRUTFDUn0WG+/8Wp6sWW9aajrDCQIu22K6ctF6Flkx14z
         ESag==
X-Forwarded-Encrypted: i=1; AJvYcCWXGXdVfPeNfmkTj5cA9HMEyCy2D/C4Ou8SbButRv2h4kR6ulWzs9UpTGtS8QAvZF5dRf5JTpURiw==@kvack.org
X-Gm-Message-State: AOJu0Yyz9HgLmil1hiGzn7sjEJhwcPKw02r6KsmkcxXN0919vRGYcGBn
	i1rxIeeIUkQOOZhovdIMBX8R0DvpeCcYtHCEVkfOJwita92foJ9dcZRAsAkIGlqVROzf/9YCDH+
	3tUffUWSEKAN1BCuEvLMaXkiyaSoEP0I/xOSy2PzW
X-Gm-Gg: ASbGncsDVVN1wem6L2rdjyaYW0WbLKtpIG24OktP0VmbQZLVpWm8AfV0PrcyuvX9lGU
	kgfNRIPqv8zgFOGXPG+O+7KZtcmvqClgMkrK0eUy5SfvpA7zQeI3u9AXytbPCPjF8KquZpurSBg
	N9tb83FO4W09WUJX8mo/f369qeOL7quFXXw19D0kFzEPLNIF3yJVKg6kNVlnazkapEWE9icox8q
	dEjvCASIVISpuUaKan2F8XWkPg=
X-Google-Smtp-Source: AGHT+IGJmjz+YHPyNxr90AMhiQNNDQu9deq8PWwNfyq+zFWi/YcgUyPYkmS3VX3aACMgtkUmoKeOvBcyBRDmMb3NDeE=
X-Received: by 2002:a17:903:3d06:b0:248:8063:a8b4 with SMTP id
 d9443c01a7336-2488063abcbmr89508125ad.22.1756370632768; Thu, 28 Aug 2025
 01:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250827220141.262669-1-david@redhat.com> <20250827220141.262669-35-david@redhat.com>
In-Reply-To: <20250827220141.262669-35-david@redhat.com>
From: Marco Elver <elver@google.com>
Date: Thu, 28 Aug 2025 10:43:16 +0200
X-Gm-Features: Ac12FXwMzUnIHp_v7uH0kV3Hu6ram9vqgPmCMZ3TyuNNAlhDfe6K8rTgx1FpO8k
Message-ID: <CANpmjNP8-dM-cizCfsVOUNDS2jBaY6d=0Wx8OGen5RbXgaqcfQ@mail.gmail.com>
Subject: Re: [PATCH v1 34/36] kfence: drop nth_page() usage
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, 
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 615DF120002
X-Stat-Signature: b8kykdzgtonyshe8izwq3ykqmn1ixd7z
X-HE-Tag: 1756370634-34177
X-HE-Meta: U2FsdGVkX18QERPg2Ru4MFMxunvrxVRnpSBraTS3WverJDvsVobkg6jpU1JdNEh/77KuOjEqkAimgx+ZdwB22plJ7RhH4sSHmkqe6sLklalT1lqom3cCkHB2J0PDbLJWgaYeRkjdXGO53RNozoMlcSUitQJyUVnfHYjBw1bkaBcesStCKiUALMzPyOobFZv2o88URgE22fAsPnp3/CzblwNQ4vPBt+1VLVF23aurvPNx5u/76HJGhHSSZmEtR4/YWFJo5JfxKYRJxAJH9Hno1cpargjqAZiVPJiA6dYHH3Llsdoo3oIUKfREYjdWqHaqAZ5e5/Nsie4NjgnxvZ9akEw67QJ2RTPptUIg9icHSbuinTkasazPPmOhiQ4SbA0a1I7d+3YGglQdUlykY5EZZhudVCtNiKhNuQGAGzQ/499ZG3EZgcmC/Y9HE0B/uZfpJfZPMRPXo2QKnhfX551ih6t8S+FAo/W+OE/W+x3PMP/Ozqh50tcLif4QLImHhfgsgIUPPY3kgWRCZg4NdyfTbf5Lnp6NtmzDVLUvcaHf6KpdZ24IYMOXOgqOLNPPLPwudx5C/McyZl8eUAe7xjacgBJqSwrLyP5GE5kdqKiy5O3/f4OHFPRXSynfimkk9/MzhzscsORsI/KqDcYq9oZt7jm8m1328A/uEmt3TGQT6h1jRbAWNb7zg86hAdaAL3Af8VkiBMYt4Wi6RTO3x2SWaKAMVaBAssbjUbHLYe2rsKS/Whx03fnxItrLehBQ9N6hw/qRhThRhDxvvlFIS+nD+/ryno7VQYug4dRQ21EMLU7DnSR3YY0eTnbQtZr5l7mBonPqXsw0yKAREv29GNiTOV/HNdAjM6q7PypCvIjoVjuAwMfLUhAAuE5lJyhkSYiQJ31jrvQCzVY6rLn2g8ozbr5F3zyAdu8j7k0Ore91dks4kQC9CZ7AQG6ETemlCf3O5bDnjNxXq/l8Fr5NmM5
 xC5XhZ9w
 AShkCY/yFiPVotB8q5AZrpA4Rtc+PZooj7AO6ji7dq/fw/hsyz9wYrNAmA/AYRVps3OFfc/NTh5WQpeaBHO7oLRyFw/gUS/DrTN9zprtQmn4yCNDU3TtHcCm98sqOUs0v0RxAzW3upYZyfbe6KqVZVS70xwZ5mfluOqMMOTzuA0CD8SizNgDF/eWrIyNA7Szs4n7cnNi7eo3qlQfoFwpBPJNwuHKuLEKZTW5xyl6czZ1DTL74FX9qPItH16t0wHWYnNi/JNqh/h8mDpCHGRVrDDdtXopVzNmP1Aqzp+q2xjltJ/r1fN/Z88EQFCevMHZ0n0Kmx0hlx88j/E4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 Aug 2025 at 00:11, 'David Hildenbrand' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> We want to get rid of nth_page(), and kfence init code is the last user.
>
> Unfortunately, we might actually walk a PFN range where the pages are
> not contiguous, because we might be allocating an area from memblock
> that could span memory sections in problematic kernel configs (SPARSEMEM
> without SPARSEMEM_VMEMMAP).
>
> We could check whether the page range is contiguous
> using page_range_contiguous() and failing kfence init, or making kfence
> incompatible these problemtic kernel configs.
>
> Let's keep it simple and simply use pfn_to_page() by iterating PFNs.
>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Marco Elver <elver@google.com>

Thanks.

> ---
>  mm/kfence/core.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 0ed3be100963a..727c20c94ac59 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -594,15 +594,14 @@ static void rcu_guarded_free(struct rcu_head *h)
>   */
>  static unsigned long kfence_init_pool(void)
>  {
> -       unsigned long addr;
> -       struct page *pages;
> +       unsigned long addr, start_pfn;
>         int i;
>
>         if (!arch_kfence_init_pool())
>                 return (unsigned long)__kfence_pool;
>
>         addr = (unsigned long)__kfence_pool;
> -       pages = virt_to_page(__kfence_pool);
> +       start_pfn = PHYS_PFN(virt_to_phys(__kfence_pool));
>
>         /*
>          * Set up object pages: they must have PGTY_slab set to avoid freeing
> @@ -613,11 +612,12 @@ static unsigned long kfence_init_pool(void)
>          * enters __slab_free() slow-path.
>          */
>         for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
> -               struct slab *slab = page_slab(nth_page(pages, i));
> +               struct slab *slab;
>
>                 if (!i || (i % 2))
>                         continue;
>
> +               slab = page_slab(pfn_to_page(start_pfn + i));
>                 __folio_set_slab(slab_folio(slab));
>  #ifdef CONFIG_MEMCG
>                 slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
> @@ -665,10 +665,12 @@ static unsigned long kfence_init_pool(void)
>
>  reset_slab:
>         for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
> -               struct slab *slab = page_slab(nth_page(pages, i));
> +               struct slab *slab;
>
>                 if (!i || (i % 2))
>                         continue;
> +
> +               slab = page_slab(pfn_to_page(start_pfn + i));
>  #ifdef CONFIG_MEMCG
>                 slab->obj_exts = 0;
>  #endif
> --
> 2.50.1
>
> --
> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20250827220141.262669-35-david%40redhat.com.

