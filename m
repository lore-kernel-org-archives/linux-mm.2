Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01302CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 09:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443D76B000C; Fri, 29 Aug 2025 05:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B046B000D; Fri, 29 Aug 2025 05:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309E36B0022; Fri, 29 Aug 2025 05:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F83C6B000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:58:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D428EBA5E0
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:58:58 +0000 (UTC)
X-FDA: 83829346356.23.57D0C96
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6C3D140004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:58:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W+rbOoLL;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756461536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIYlE8yYA+z63gvbmepekc4lArepb/yuA3iZBVH5fy4=;
	b=TqqkV4mLBLn2eSL9I+0vJhO2k0O1SalNxFuw+S+dcsiCSU3+oJD54+UmyPXZJjYZIto1Fy
	6qG2RHNiirEXNuefLK7jZkEtpa6ZDCttGmZ4SbYccmwf3hlJVGhzO37R3/J/3IH1n/Jhdr
	QvBguaFlxlnwFhlByTUuJRce3Tg7jgA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756461536; a=rsa-sha256;
	cv=none;
	b=VWvLBWuznJEA+t64ih9V7an6k/1WFu1/xrG/aO0A/m3mwoP09yK+fGgPWUOOTie15NvrPa
	6BCM1U21P2qs3skypAXnp9pvGquhNSd2a6VKkPAcLBTSiLfxiMRAxKTVW5DDiH9PETan8h
	2rOLh4hWcAyNjeE4xtmoyaovPl4aLK0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W+rbOoLL;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756461535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CIYlE8yYA+z63gvbmepekc4lArepb/yuA3iZBVH5fy4=;
	b=W+rbOoLLBOHeoQKHG1uoVQDKp5ikl9iEU4IlEGMWryohinqWcu7/ySKkCiHCw3C45WyvGV
	fLPlqNEYIblJgMxm9Dqw7DDx1diIBZQygHxQhR10bxTKTf7SdMRKghONU3aVuXi/W0U9wN
	SlQiiD/cHUpjAietTfF0AtNYQqt5iFM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-Nh2ele4ONmC1r81s71WMaw-1; Fri, 29 Aug 2025 05:58:54 -0400
X-MC-Unique: Nh2ele4ONmC1r81s71WMaw-1
X-Mimecast-MFC-AGG-ID: Nh2ele4ONmC1r81s71WMaw_1756461533
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b7a0d1a71so12207315e9.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756461533; x=1757066333;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CIYlE8yYA+z63gvbmepekc4lArepb/yuA3iZBVH5fy4=;
        b=P/FyweMgztOdbYu7a2FImXoOBCHYewCowyd7u4+eL46BXMbzQJPaGF/g13cZx+MNuw
         SvsD4orPg4VWiL3CEwIme2WAC7e9VrJGBUBDVdLEbffdNjS50XXmy1fgnQ/SVvg+TCU1
         ngbaQITRzcZWQQwknykSz8Y1Nz4A9VJYWQefB40heGnEBMRD/RRnz9vRHprkeDuDLYk8
         GANB77MrVvu+phKIKXv9Epyju4Ou5t1xUww+0DjquCQUI7y2xCDvvtZ7yx3L8QiwzMXo
         1+Kon/K3R0PkI2zHHy+0IJVXUugnTP7TXstn7MaE/nDa77iwjkevQAUCcy+iXC5F3RDO
         /67g==
X-Forwarded-Encrypted: i=1; AJvYcCUGseWbHbeWQ62tAvhylY0IrblBIc1uOwd6ujNSaZvhFfnGEn6MmT8D2983nk67RSqIjMt2W0yzVw==@kvack.org
X-Gm-Message-State: AOJu0Yxp0hxSWKHheVXDvjzP/anUGSd114d3fObxbfeYypR/rI+6ycmJ
	47aCCAjCGa8eeKhYwjbz6MJuh2Bq2osl4R4tlo+DA0ZKf1NRYv2/DXEhzE/raOFNRUhow2UY4iI
	45KNd9nto2cgKEiKo10oV+6XBJWnPfQM1PifnvKRYt8xFLoo5HzD8
X-Gm-Gg: ASbGncs/JfR06Beljwr6L8mUkC4pv7TpR/qmnf2IPpyLIxPoBSsYB3c7ytL01g+G6lR
	XJF340wc1RcO4oIZr3pScS8E8al6khmm1Lx49bfs1QZkpo58QI2KTDDFgg8THYpjTfggpqjbbxn
	xyijlAx3VCx3v0P5tYemHsfD4eaugRs2UQ//gjmNTodTi+6pLTo/QpbNxIK6l1Gr0NKFbq1aqzo
	Q7ASqwHvKSXEk1mf1+6ycXb2qcdEAl/L0qVSbCOvXPnqTzdCxlZMIC00Yepzq7YH7lFB1GusiUN
	2HV6HM1AhyWzZZbD6744nxUqU4H4c+J0Wc+KSzIxmEr3Dh32YoNK6VZhKcsdQIwYZWALCM5Wer9
	OkQqyyzULfn5Ya07u6/V3C57G0aPQI3up1SXX0pcQ0U+w2S/LA2ziAmSpVOtb2UkS
X-Received: by 2002:a05:600c:35d0:b0:45b:7f72:340 with SMTP id 5b1f17b1804b1-45b7f720599mr16993875e9.25.1756461532924;
        Fri, 29 Aug 2025 02:58:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHP3EE2Ifsg5AHoStp93/zw+u97m2nZeBURa8lzMoGajSkuEytfaWCGtF8d2bBvl4JzWz9L2g==
X-Received: by 2002:a05:600c:35d0:b0:45b:7f72:340 with SMTP id 5b1f17b1804b1-45b7f720599mr16993185e9.25.1756461532358;
        Fri, 29 Aug 2025 02:58:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7271cd01sm102235695e9.23.2025.08.29.02.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 02:58:51 -0700 (PDT)
Message-ID: <6a2e2ba2-e5ea-4744-a66e-790216c1e762@redhat.com>
Date: Fri, 29 Aug 2025 11:58:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/36] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 SeongJae Park <sj@kernel.org>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-7-david@redhat.com>
 <3hpjmfa6p3onfdv4ma4nv2tdggvsyarh7m36aufy6hvwqtp2wd@2odohwxkl3rk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3hpjmfa6p3onfdv4ma4nv2tdggvsyarh7m36aufy6hvwqtp2wd@2odohwxkl3rk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -M5F7LKob19IxQth1b1zZf82s0eCdgKP1RqLQN_i1xU_1756461533
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C3D140004
X-Stat-Signature: yy1gt3n6yd3twph6ua6m6s1i96hupiks
X-HE-Tag: 1756461536-893192
X-HE-Meta: U2FsdGVkX1+3CsrJt3A0FL0EZUocfxWyPEzGSImWUG8Oo+4SKSXePHCCKPLC8jhsI5Fv0fZ342KjcAVs9Kdxv8P4wTgqxoFqV6N5Rif5TrBsY7dpjndkuMk42D7ekjdEi3fddbeWmrEB4LNKOjI/uO8QIKuFtjXEu7Sxa4GGq9sMBhwQXoh0FICmTNGdUJEP7eL3PXrflejjN/47TTi9qcIlt1sDZjvGzKuxQSbHN7Vd1yvWcmHM70VJ8cKApBFxznDoP/GpK/aSSnNtH/bSq0ICi5DCayCY2Gctwt9HWFwYnMY5ynsybH3kdfyuj0/pHtAdI+ITFKsDUdXpNU1lirRAKSyYMAADsuiSEJhZ+DWnM85wsP5D2x3n4GUXFDaAI1bWYg7Ig8au+Mwrpblvax4PqFsEtXAyOGSwjEprm8gRjIuom85M9gc4UokHcUs8ydg8pwkygYiyG6W2F2RWWoCp7g7wGlWJWtnHOiWEueo4urumFw+KoybICrgkOIrzydHe9AoKsigSCK1RJENaKknJTBZ53+up2MGIjLta9lsnKWy+J1qRHyUAb/xJSne1HeU6SSB1m/ncHeYNBSP4ERWMU7BkCIbxs49zXfX0lsR96dQFp8ji4rzjzpjJt51zPWD8SCXkyZyhEyEbPXTVk1JHF4rQKDMJxDoBbOYvWkiLkHI1Qd8y17aIrRkuDOPfPudzEhHOQeluSXCIeYrSIQ2lwNLro4I8g/jevlRyIhAUzhJM1x7vt/PsOz6op37jd+HSzLpqzmmwueUgbIuP1x22nsHr9hSkeeq9liorDIvIvb3duhIXXDr3fKXtJ6q5LVdNM1frK70ckG9qi3kg0SbuRXDmDZxma0b++RwdpKlHc2HWXcn/sh6IvhEjOnAJivbu2GUuc4p+OPfNRPRcs35SvQZLRqshvsUAXT11Q0c8vaMK1tO3i55yARXpZ55J+lBdA6r1dYsQ0mC/tVj
 pv5PBwgK
 kTpdyn2WyZG8bznvwlY1zxZQz+HcQJzGDFkmCmKj+RxB46KxZ/zXLyy9bSTKKaSlOg4Oadb1GAvq8aHZ9LBy6H8aQpSThFfReIluhmHUFBDR1G3Q+UeWstAZViMCH3TdMxVjoI7x9ALFwYmpA8l8GcKF1aRIBGiPJqeV3QrMMq9+ImhJXhPZbMYOSflaIArVrEAy+1D2yorpEsgy4f8iMKaDR9vCtPjvKoF0fRIcr+Aah0THCZ7qcnmAG3a9jMUpGdMrI61t9mTVlUMJGrh+7B4K78xo6UrNEsCdkI9nWVI0ne4g3l7mRXzwHGkfjjIsEm6xlgTKd92wMWOhiGvPntU6T1alFkc7jyXx0QyIsTfi3jBv0ULihSYK5u3hceGNfobtZKsBLSPILjoUoFFa6LfrZSUac2gh5ykuOuuiSnhk5ApgFtVT490q5yvCGdIXbyTGggYU8/jNcULZOQpvsd7uQAa98IJcivWOAP9ka1Z3hyMCq3JBFGsLrXAHZ+FBpjJNthoBlV+pA19B2HsoODOSL8RibbaJk8Ya3SEpLHieMbdBEdyJAK6PP4SVFPop7PCdU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 02:33, Liam R. Howlett wrote:
> * David Hildenbrand <david@redhat.com> [250827 18:04]:
>> Let's reject them early, which in turn makes folio_alloc_gigantic() reject
>> them properly.
>>
>> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
>> and calculate MAX_FOLIO_NR_PAGES based on that.
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: SeongJae Park <sj@kernel.org>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> Nit below, but..
> 
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> 
>> ---
>>   include/linux/mm.h | 6 ++++--
>>   mm/page_alloc.c    | 5 ++++-
>>   2 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 00c8a54127d37..77737cbf2216a 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
>>   
>>   /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>> -#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
>> +#define MAX_FOLIO_ORDER		PUD_ORDER
>>   #else
>> -#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
>> +#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
>>   #endif
>>   
>> +#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
>> +
>>   /*
>>    * compound_nr() returns the number of pages in this potentially compound
>>    * page.  compound_nr() can be called on a tail page, and is defined to
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index baead29b3e67b..426bc404b80cc 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>>   int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   			      acr_flags_t alloc_flags, gfp_t gfp_mask)
>>   {
>> +	const unsigned int order = ilog2(end - start);
>>   	unsigned long outer_start, outer_end;
>>   	int ret = 0;
>>   
>> @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   					    PB_ISOLATE_MODE_CMA_ALLOC :
>>   					    PB_ISOLATE_MODE_OTHER;
>>   
>> +	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
>> +		return -EINVAL;
>> +
>>   	gfp_mask = current_gfp_context(gfp_mask);
>>   	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>>   		return -EINVAL;
>> @@ -6947,7 +6951,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   			free_contig_range(end, outer_end - end);
>>   	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>>   		struct page *head = pfn_to_page(start);
>> -		int order = ilog2(end - start);
> 
> You have changed this from an int to a const unsigned int, which is
> totally fine but it was left out of the change log.  

Considered to trivial to document, but I can add a sentence about that.

> Probably not really
> worth mentioning but curious why the change to unsigned here?

orders are always unsigned, like folio_order().

Thanks!

-- 
Cheers

David / dhildenb


