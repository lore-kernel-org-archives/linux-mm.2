Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35CA9CA1001
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BBDC6B0024; Fri, 29 Aug 2025 07:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E2D6B0027; Fri, 29 Aug 2025 07:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6696B0028; Fri, 29 Aug 2025 07:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 449496B0024
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:57:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14F10BAAFF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:57:49 +0000 (UTC)
X-FDA: 83829645858.20.F1E705B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7B76DA0004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:57:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EOEqnbO8;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756468666; a=rsa-sha256;
	cv=none;
	b=XaIQc9OxUzCRYGPYkAKuk9Jsxq5Zkxar3aECtEMDVcDSA4uqQguumyg65NBEZa3JzmIRo5
	eytA72Yk8mS1dqKO7mfyJfm+xw3S6PD5tomRZpAspA07EmDFIdItNDitXWPvFHb+Z5W/Dv
	9cDRiH6IU9sNcx3/q9obRZDutftBZd8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EOEqnbO8;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hoDokfG1MQmzSDgEaptCicCjaaQpWxY2iqh8txE4sWo=;
	b=eLFWVVBtXi9ucqaMYhTQmO6y8zHlPiEeI6QGC6W/5gpA9rxV2xryTEsMpvqF1pwS9G93UG
	8Szb4dUZZ4Gnbm+N0AkVMr3qSjdG/DkSSfW61oe3RyGBO8VDYJM3rPov9qqj0dCFRJFudP
	y28RD7H3ROPKPoHE0PgX03tfYsXSSpU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756468665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hoDokfG1MQmzSDgEaptCicCjaaQpWxY2iqh8txE4sWo=;
	b=EOEqnbO8ryNH9EsKaoELVQE3qqEFosYW3FpSBWCsvNvO5fV0l+uIr5oo/EKEfp5+PtyIPO
	8z2YiWNwUIzhbqcU72Xkvz0jZi/YEpDysg6CKe5wHmJZ7+xXOl1/7wZLVdmAfwU4VaiAEI
	GQ7q141L/b5EfZyzdlx5b9uoEBiUV1k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-FPuFqZr8MGmTosVxrmNGqg-1; Fri, 29 Aug 2025 07:57:27 -0400
X-MC-Unique: FPuFqZr8MGmTosVxrmNGqg-1
X-Mimecast-MFC-AGG-ID: FPuFqZr8MGmTosVxrmNGqg_1756468646
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b7f0d1449so4064955e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756468646; x=1757073446;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hoDokfG1MQmzSDgEaptCicCjaaQpWxY2iqh8txE4sWo=;
        b=STKR/zRxTEozVgl7/6Z572ZnRSX5CY/BZrRCdpHuczUzWjKRCFCONi4Hgs1CcbFIfy
         OwSikqefZRED+QHPOAj3CXogcP2MIs/UNvszkN7Exy/12vlya8vYMii3Idfe6rF+4wrl
         Nbs0oWFOQnaWgRqwMEN8WdvNDrEaReI4m8+7tf/yrSa1KN9csx/ussY0+FYEK4jmt9Ox
         Lq53nP95qmDv1tf5lrvAZRMtsVF5gtPQtPNg6XuM0lQen1C13WTFMnIRwBrvjESmctS0
         /K6S27G92xQmOGjc/Xri2pPOZfF7hNlpWunx9LVbQzbqqW8hMEcbT48jixijdhsIgoC1
         sxLw==
X-Forwarded-Encrypted: i=1; AJvYcCUgDFKWyCB+A3mDmEABTX2QMu8Y91SF8XztiT3I5ID9ySXa8p5koSQOl7uZ00hthIYRWpgvOgC5Kw==@kvack.org
X-Gm-Message-State: AOJu0Yx788KbPDdNO4dNpWTXZgS+dDiFIVmTe4GNsli/TDKnbvhjSNr1
	o4MzOB7OLwI4AYLK8fIXdNFLq43a+zKWBbIEAa5ypOC3Z0VgdWLtfySh1Iu9DShH91hKxdbelsM
	Ex5nTI0a1vtJf5E0FrDSvjjMCiOaUd49CkblWwG5bhT95LCzqMX9G
X-Gm-Gg: ASbGnctw4a3pLwuK7M06lMCV0932V2EyEAx/woaeH7PFFPXAdlz/A64+oUH1u8gLLWi
	b7BXuYWfc9TCK3qPxaES51wvBPh0GTLQdUnhl6Oc0f7dAhz4EigCr7JWHydTp9wiLlyTGLJ9hMV
	OJrVSxa5aROBetVsHNAPTMC4CgmKmubbC2YbnRsdHGAcUTvCaYkFYS6C6Qutv4W3S64G+gIB6eJ
	HKk0yvcMeL1jx70Q5B6XmpQX29HvG/xurhlvo8ymR5XpqaZAraUtgW1OohbsWzj7tCcUdJnKHVD
	3ENSUhlKx1XLboXFyBPFG3OxRAdl+G151vhltlnzomiT1VpJd4cUz9cWG1gjOCpsAapJ0fc7ag5
	5uZsfB00Suzla5mvCIuHBGQv4YiRn32BdNbO/rTBa0cex2kP+Apv9uPYWrwShKDs=
X-Received: by 2002:a05:600c:348d:b0:45b:80ab:3359 with SMTP id 5b1f17b1804b1-45b80ab35acmr15394665e9.0.1756468645758;
        Fri, 29 Aug 2025 04:57:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG95+220rsAfy23meKWNy4rnKbzYvRZ5zPoY4wdVrGBgRqoKPVywzJTjIuqBTuNai4wkDfQaw==
X-Received: by 2002:a05:600c:348d:b0:45b:80ab:3359 with SMTP id 5b1f17b1804b1-45b80ab35acmr15394435e9.0.1756468645290;
        Fri, 29 Aug 2025 04:57:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6b99sm116739135e9.4.2025.08.29.04.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 04:57:24 -0700 (PDT)
Message-ID: <eff8badd-0ddd-4a5f-a2ef-0e3ded39687a@redhat.com>
Date: Fri, 29 Aug 2025 13:57:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/36] mm: limit folio/compound page sizes in
 problematic kernel configs
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-12-david@redhat.com>
 <baa1b6cf-2fde-4149-8cdf-4b54e2d7c60d@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <baa1b6cf-2fde-4149-8cdf-4b54e2d7c60d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: trk6BhEjYD1arh4FSTdiqIJJgW11A-xjmjQG5H42Snc_1756468646
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B76DA0004
X-Stat-Signature: ipfzqzsifbhtaa9af8foqq5ecdx9cwkq
X-Rspam-User: 
X-HE-Tag: 1756468666-105248
X-HE-Meta: U2FsdGVkX1/H7YtFYG1oZZQsjZ//zRsIEC+xFPV/RyxKPKt8pPjtfcynUeoc9pPQzD4DVhFQ9AcUcfiYj6orKjAe3wf+rqNle+DHv9oI+e/xXKy4OBMtGKUcHbxmevl9oP1YyRhHDMWOdXdyw46jaSRorI5hbEfn1MH42VfVLsMMp6bcUeNHHhUjaeog5mX8i8Pltnf3pYOQdptS7OO6ZaMJFo5PJ5aZXde/50aChTsxXi1RB7fRAqAqMzCszdGO9eD3u5hNqnzzwAbGRakcOwNwDx/90gtrudDru2zD8mFUCrWr0m9LGFdXJA2NysMmIvVImzaRcdW6Dn7eTRcfE3Ti+MY6s8L6XL9Mh0UPR8+qPZSWqz+h+A990CoVfq3H9KdnjViz0ebB7GXAa4YOQ4a+KrR/GSQhRYfR+T7UuUfOnNmVwszg1AkQYqn74N5kw5Qin1Cn8w1iEg0GJsfQmn0QjbKfFOInH6tpVKMGq9FyZCEbl1bEa1TOmQELaYjkH5SOymtf/m4SzWegQe40rLdvtlz969GrXQP1C6+kizorAsGCYSqq5C3xoi5Z3Cg14eZy5u4CTvZyXjhAE7vEcr2jQjysR97sV+RV/pF5uTSe6SEcjH6dMBBjbWo+DoJQqM5agx+sgkiUrEv6qm+WwDQxbJk9qQPSmah0FMxJpY7M8Of63hngXF9HZUOXxO8Xu7m+MVCjMPNcLrXe6j8TWZHAOXxRTz2Omm2oOuVAm/wJ0kRU6kDI2ja1scGtG3ktsaElRtolyO+I4yoskosgwDb4yt7Aefn8nPlY1psf8nwoCoUnCaqfI+Mp5CZFHzipCPTBX8z4fFliHZygAsCtLM51i1opv3sllUrqLNkPSM8RCHFrUbMxTUQ+vgZBjzUstE0mK75PlqtyQS7zOZdWXHkeKpjJ3tJLJjV5ErpNWjE4vG+b5DH+1L238hJBRBnSzEjKi9TBvof5AGPwdZz
 xUGkGlvz
 RAUwUg+3RqWqeVJH3vJsekrh7wvv/BzvgD4PxXyMpsTf3aXfxdkDc+fD6K9PxwUw9Mz8iR+jGDvJV3VvQVOb/s56s3kHkgvbBGf0j5LLW/+epZfLn5VRl4r3HlCbazCo2m1gu3dD4g+4Tve14UW7xSQvlRlYn/85/lz+PEUaxWH0vdV9w5um4VUyD5wTu187JkghdKun7NljvHntaXrfimRiCeRtT3VYvLGJ0z0zJ0NscNUgSDbVXK6xc31e1mrdbt+upq25t9jPUFVkHPi7B177kJa3uW3Qt8Q37ww0+EJJZMfc7HEIYNnirl+erkNanmPjBNeBny3A8Va86h9+iVSMtu7igjPGTNCz13sx+EJeewergQjm1qX1t6DIO0M9nxmxzrSaliJAjeL39rjpdAtrYG4Vxa5aYz8sFfApccCw4W+4T1qx6K6eJnx76MWng2Sy7ee3znsqp/pM7bUwiyx/ZpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 17:10, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:15AM +0200, David Hildenbrand wrote:
>> Let's limit the maximum folio size in problematic kernel config where
>> the memmap is allocated per memory section (SPARSEMEM without
>> SPARSEMEM_VMEMMAP) to a single memory section.
>>
>> Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
>> but not SPARSEMEM_VMEMMAP: sh.
>>
>> Fortunately, the biggest hugetlb size sh supports is 64 MiB
>> (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
>> (SECTION_SIZE_BITS == 26), so their use case is not degraded.
>>
>> As folios and memory sections are naturally aligned to their order-2 size
>> in memory, consequently a single folio can no longer span multiple memory
>> sections on these problematic kernel configs.
>>
>> nth_page() is no longer required when operating within a single compound
>> page / folio.
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> Realy great comments, like this!
> 
> I wonder if we could have this be part of the first patch where you fiddle
> with MAX_FOLIO_ORDER etc. but not a big deal.

I think it belongs into this patch where we actually impose the 
restrictions.

[...]

>> +/*
>> + * Only pages within a single memory section are guaranteed to be
>> + * contiguous. By limiting folios to a single memory section, all folio
>> + * pages are guaranteed to be contiguous.
>> + */
>> +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> 
> Hmmm, was this implicit before somehow? I mean surely by the fact as you say
> that physical contiguity would not otherwise be guaranteed :))

Well, my patches until this point made sure that any attempt to use a 
larger folio would fail in a way that we could spot now if there is any 
offender.

That is why before this change, nth_page() was required within a folio.

Hope that clarifies it, thanks!

-- 
Cheers

David / dhildenb


