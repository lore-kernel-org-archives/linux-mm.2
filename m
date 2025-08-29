Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BBBACA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 10:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B077E8E000A; Fri, 29 Aug 2025 06:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF878E0001; Fri, 29 Aug 2025 06:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A71F8E000A; Fri, 29 Aug 2025 06:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8473B8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:06:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2C14119684
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:06:31 +0000 (UTC)
X-FDA: 83829365382.28.0F6B43C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 69A6E14000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:06:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X2NbUJL9;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756461989; a=rsa-sha256;
	cv=none;
	b=G2BXOsd2xHIyy/d71QHmNJ16BVNlWZ9snfu1vGmLN275NrPCZeJImzMFj9XLA6EeOHKBlc
	G58YGhfjHtlUyfL01FbnvZvjJSjR0SZGjvMY8PT2FOw0862xTHK8rV2gJ7bfDP6R39CNNn
	oUnQSTJZSCp8qnHnL/z3ph6qMEUu5n0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X2NbUJL9;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756461989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lPHoMHV5vJS1QZV5L+lWiiTGuBUarel82A4quq5C180=;
	b=Z1PpzYZsa6nU1wOnc/g1TqNGObqalVKIm0g4FghujnE/s1Bx2ZxPuwiuZU9lLR4mNqgDWU
	qumnlOugsneKmrQ6FxQHxYa0eyvu1D5ktHvSeKsp/mI0lxV/qY0w3K2tNn6pbYupBmNT07
	Y7l3UxAUyQH0eDDhOMJ6XZA8rv7RirU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756461988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lPHoMHV5vJS1QZV5L+lWiiTGuBUarel82A4quq5C180=;
	b=X2NbUJL9bJHXuV7eFDPLEXzYckKovoNtSRH8sORqAv9vimX0X32VEDKOIBVPMznGdpXYoO
	X57JAEYB0QsZo29AZTtUbuLEe8Zyt4Cpo2R9Zdb+zoqlazX3FyyctVla77iDrPmlBWzN4v
	Mo1p3ap9YvAATSGfXbwpeewFXZTAAQE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-P_ktyvIjOCyCibBi_b8I_g-1; Fri, 29 Aug 2025 06:06:26 -0400
X-MC-Unique: P_ktyvIjOCyCibBi_b8I_g-1
X-Mimecast-MFC-AGG-ID: P_ktyvIjOCyCibBi_b8I_g_1756461985
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c9bf5c8b12so1099875f8f.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756461985; x=1757066785;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lPHoMHV5vJS1QZV5L+lWiiTGuBUarel82A4quq5C180=;
        b=qJervJ4Op6tl23+ulbRnuKJq73UzPpE9XSWKkMrxyqWS+VwnM/YX6BQ5dU3mnCVzoO
         RJe7ALj6odj6PE+yEoQgDUJILO3Ufke5DQHMPw/RBovE02xnyQTRom7IVLJ3TR8f9TvI
         ugKW3YtFtTC4rDM7CSAgcCIp90qEK06jalUgAzMsUpOVkVTR3OcpNm4RjscYrZkEG7vy
         MKN0XTT04AAb5R675mzVleN/Ab2sNvECyT3zVYgwTdx8IrYpTVRBcieFRUfmRMGPHpN8
         +rEp1Utaz+dfkoYI1YT5CJHTE1nVsUeNkQqoijbuoUkeJDsZUQXJQR2uYrNaW77N1Y/y
         Wt6w==
X-Forwarded-Encrypted: i=1; AJvYcCWHGg+ekubAMjAtUlwKxtbV7FLh0UOb9gTvOKVoKD276UCgBL1ypGcHozfjRulrWXoGg/276xKj9w==@kvack.org
X-Gm-Message-State: AOJu0YwsGihxKGt5X5Xs/mUjUydrgtM70zO9oj+XR0bwsZTjcUPGV7cK
	Pgu9sVSt24mul4DTa8SYZGyr+3XbZ5pgo+JWgDxBeNxDTQwyhIrCK6ortVpbE6fhgW0nR/x42XV
	+qpkCwCcdAauzRnyYb5xPDdlPf0c4/kuaaE8MOf15m9W85qkhdSp/
X-Gm-Gg: ASbGncu1alg3CXNkxeMPKjrUU4OOO/Gv14LPwNuEtrIs5OOyY5PJjGPyUVjqQ82BEa0
	2Pl1XB4DeWPuXH25a1+4BVNIH2mrfgML16qmeFdqMaSl2Ht5R9tbYUMWZOHGfLCgvqRkh7geOnD
	7tN0XxE8C/z3n2UxbmOz0NCIR2q6hzXDGM8+2M6o2Cg9q83tql0W6/+fPqwEwzBnKgd5HmK6lsP
	ChZGK1yoJ7vyEVkLax+gMfGrtfoIReO7uIzFaP9MvW4j7OpzvDT3ZCSuCKtyE2XLIFRdrojXtNl
	YrmpAwfzwCiKblKYmmLfI4XdKlRerUia8yCz2hCTf+1KS/GV/agi4Ber/CLpOe6CNNuj8Iz+YBW
	KLpibnblgA3EZsywt92Sw0PAHc2xpCr66OTTePyt4UoPoCzcIa+9beuCn48aBmWUb
X-Received: by 2002:a05:6000:2082:b0:3ce:663a:c92f with SMTP id ffacd0b85a97d-3ce663af648mr3716832f8f.25.1756461984545;
        Fri, 29 Aug 2025 03:06:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+cEIb1Z4u6pTtqsfT89DbTAZZhLHMJCnkgKmDWXX/Q7MNQLWv1cM4WZiGdQoi1AW0dJ7LMQ==
X-Received: by 2002:a05:6000:2082:b0:3ce:663a:c92f with SMTP id ffacd0b85a97d-3ce663af648mr3716770f8f.25.1756461983963;
        Fri, 29 Aug 2025 03:06:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b74950639sm85846585e9.17.2025.08.29.03.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 03:06:23 -0700 (PDT)
Message-ID: <547145e0-9b0e-40ca-8201-e94cc5d19356@redhat.com>
Date: Fri, 29 Aug 2025 12:06:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/36] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 SeongJae Park <sj@kernel.org>, Alexander Potapenko <glider@google.com>,
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
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-7-david@redhat.com>
 <f195300e-42e2-4eaa-84c8-c37501c3339c@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f195300e-42e2-4eaa-84c8-c37501c3339c@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tW-S2QsuB3ytR4S7X6Mw3NzOoPcvaYnjQ7M85pPHiEU_1756461985
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 69A6E14000C
X-Stat-Signature: c4h4faezxfoa37kpd4jtsfb3cdiftn16
X-Rspam-User: 
X-HE-Tag: 1756461989-485212
X-HE-Meta: U2FsdGVkX1+oXBvV+jhzvBSoBBx3uDC9xwPxMqzoeb1/L1aHQZ3hhcXjsxJPZQ3Abz7ksSH2T5NcWn8MXccsul8yPUOrfAVzl+Df0GAkdA2AeJNtm9CNck588uEeloFATw5qSeMHpPvlag0M6VV4I68eOFgVk6+E6Z1bD4UoVhL2dkRpX7N2f13qQF7uyyfBSOqfNH7bMtDtyYcPCZ4xhQW/aGPS0h7z6gw7Cuu/6VPOB53vPPcr+K02IUhrcgCiBHKTs1fqyPqt02fnoiWeYpGj03Z+6Gg+osLilJzmB57ULD8slQ7y4QUxU5hozg7yLm/zhXJA67Nx9a0vqCehv3eYSG1UyygG2SkMua3KtmuUOqMKOoxFTLdbBenoTVL0KuWx2gOkQvaXsLyztwjihTa9gm5BhluOqQuzNG/r1Osmf7cZ20XjJsvgdFA0QvUD0Xy/AagzuuJX0td7K5lAxRKiaktZ1NWE+FKWpGKQxt+LJTxef0ZiFI8xTp7PZSa8iCfpX+DY39JjeZYtbfDjUVOpAc21cXvWUSAMfRBsdDyQo/a4weWpaWh//LD3p1VjiNcfYiUv6QnPBE6KUeOXa2lgiFJvrm4pNxhP5ZSwxB4mg2zpp4R0y5LJvAFogBR/FhfSbsc5KslTom5oqFwn+G7sAwUUNE3I0Pi/Mg8edbDO60kApSQ4+vFDpjXL7dahKGM+072dV3ySu8ShSOZMQ4BzK5cfSEpf/Fc0KxPkvX2xF8Vku4j6hApr0b96eBiwbqcs3vx2oCrBc97ozPp5nLhKa2o8cIS40njqMtI46x8MAunH/TURFV6OsJ1c9MfZvn46xGRvenDo6i7Dt1bTbrbx5h4SDdGQtpVBbTe14tpxx726JtZMpxVI+/ZAjUbsiNnvkkXjgiDBQELTDz7/WHu/A1orlKJANm0w4tOes1RoN8+s3Df8zAux5+3q0PSQHjDkAUgJuB2Nl4ALGeb
 ECFcSPuC
 ATbITct6Qt+b5vC+4B+35rtn/D0ofR1bE884JdY1xI2LGwCpV27X3I4X8eK4AmfR9mP8MSjl0kRmznWVpkDoaRECGBPQp8aI7vNZJeLNQ4FBrX8LLAtmQENbXbXd5M/9m3HP4gAS8giFED192FtE1xkD+ofyyQNlQpkPEkfrjbtpfnKXheurqoOrVYkPekmSwZa5M1cNbhzHvOEIIEm2Z7cKIbpPbklQGXShcPZfPu/sUNLfiu7sbi1JKhPZA+CD1UbkEQqIO3HQAcmwFDDVguB1aRF5SFSCFGePn8QGEKtJLtKTP+mPX87+cfw/EUBiyakTImwBCC8tq9NpFm9+gAKYIAk6Wq412sakfDms7B5P48JaXKWpNkbVPGgJp1CCkfUR1HkxQwnHCJnIrKrtgQvfO8hQYcOIp7apPcFMOBFV9HPGvCQJEJROZ0IcSgoSJHusOjSzxcMwruRct3ZGhfCIvrOAEISONSc+YC6PDzRtjyqeHM+5bKIX7mdXzTfnFS66kr0D4+FmdgnDX+j/lOjpiSA2RbZrqjlDOU6rMX3FwJBut5BhJEPfT+PstjiSIjiC1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 16:37, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:10AM +0200, David Hildenbrand wrote:
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
> Some nits, but overall LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
> 
> BIT()?

I don't think we want to use BIT whenever we convert from order -> folio 
-- which is why we also don't do that in other code.

BIT() is nice in the context of flags and bitmaps, but not really in the 
context of converting orders to pages.

One could argue that maybe one would want a order_to_pages() helper 
(that could use BIT() internally), but I am certainly not someone that 
would suggest that at this point ...  :)

> 
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
> 
> Possibly not worth it for a one off, but be nice to have this as a helper function, like:
> 
> static bool is_valid_order(gfp_t gfp_mask, unsigned int order)
> {
> 	return !(gfp_mask & __GFP_COMP) || order <= MAX_FOLIO_ORDER;
> }
> 
> Then makes this:
> 
> 	if (WARN_ON_ONCE(!is_valid_order(gfp_mask, order)))
> 		return -EINVAL;
> 
> Kinda self-documenting!

I don't like it -- especially forwarding __GFP_COMP.

is_valid_folio_order() to wrap the order check? Also not sure.

So I'll leave it as is I think.

Thanks for all the review!

-- 
Cheers

David / dhildenb


