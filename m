Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61F2CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 13:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292A38E0002; Fri, 29 Aug 2025 09:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B9F8E0001; Fri, 29 Aug 2025 09:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BCE78E0002; Fri, 29 Aug 2025 09:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC1698E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:09:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A535BB1A8
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:09:54 +0000 (UTC)
X-FDA: 83829827508.27.2A9D5CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8A6A140015
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:09:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W77Nk43K;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756472992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMW9HLrWQaKZG+KlEEwhYfHDFt7S0jSgL0MHJQucZHQ=;
	b=rAaPH/aPXii2+FzsW1YU6NWVeopWsnWYqBS2s/gfvSFbN+egFBogsqBxzmTxTLPYi8bbVN
	0jVOQLM6rsL4v6xE6ZT9zx5HU59YiFsQus3Pbn6HtcDaz0x2MHQnJiGnvM639vxEAGaHQN
	bGIgLCUPsc+wOIAfr5Kc/p6POZAi5Ao=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W77Nk43K;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756472992; a=rsa-sha256;
	cv=none;
	b=OZkgjCeZ31SxXh4degG5J2qa94HX3Y5JLIxULs0JNxIwgkJSsjkVeZRkvMIyPFUZoqADGD
	QQtUJacDqz2/js/mNAm8qT+CSf5GvzPNjrrOAq3CVAYgfFpFSj05rBUd/swW2v4wLvopSP
	dvJ2YeKvrj249Z/6a6zZnVRq7iISBSU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756472991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GMW9HLrWQaKZG+KlEEwhYfHDFt7S0jSgL0MHJQucZHQ=;
	b=W77Nk43KwapZ/PN0ppI9OkDMdzLsFzdvdC/b/yuaZStPv6TCKRiXmhD2gEpACpEqlmSoKQ
	fy9xiqvIe1vDK8ht/CfBha8BW6l+aSX7H/TeOc7MddY2QJvJrVVLKSezxtvsS8nnv4OHpT
	nov6559jhkbkP27pl4yoFG8ggSJpcFc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-6KvbjWlpNQ--hl98T3MBEQ-1; Fri, 29 Aug 2025 09:09:49 -0400
X-MC-Unique: 6KvbjWlpNQ--hl98T3MBEQ-1
X-Mimecast-MFC-AGG-ID: 6KvbjWlpNQ--hl98T3MBEQ_1756472989
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3cf48ec9fc1so629665f8f.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:09:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756472989; x=1757077789;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GMW9HLrWQaKZG+KlEEwhYfHDFt7S0jSgL0MHJQucZHQ=;
        b=b4MfCAc9tNYA8dijOMRFHqtakweWfDWV59kKtktKNmiI6yydA52PmYE6d7THyRSYg9
         4iV4OKCClak9DPIijTctJogAYGaa00+9b/TwaPaOVrQtqzyRYQYHF/M0MkNxbjpDpJ0B
         zE4aubbjyE/8T/xGG4pbFosafl/FbuKRSH9Z9tltJH9ZdOaeKidsUw67dUPiMpI3vXQp
         M7qazT70VvF3lZcmrKUG9pjZvT8U9sb074fIgGCtfWSxnIRL+IyOdyiMDxBKbMJv+/+2
         dXYDd4jI7JTvCFq+W5j5bWRVzEp5Jt31O8GBn3aLKVs6jonfZ1BR+lhnU+EvMJVeEfVI
         zxeg==
X-Forwarded-Encrypted: i=1; AJvYcCVnSc+SEaTGBMiSbumDV07W/3JtXAsmgLpZ/+YYQ5h8AKISwJiHxoOqND68iKx9IamvjDa9v6f3lw==@kvack.org
X-Gm-Message-State: AOJu0YxwT50g/A8sgG3o7Sk9OHDwyx9V6SpmE6Jv5t65fBevqhpwZuAN
	Jj4SyNYtGpa7choXae27WhUaWaN+rsffe7H/VC6C4cGCxwaaSeWhu41H6PTeKC/epAecmDg19Jw
	EK24Q12VDZG4lutCV8mMEQga3IzYvRIfhcfXhDLLEfq9j2UH3nw+m
X-Gm-Gg: ASbGnctL2IS7s4vI4RMKSb5EVcTL+FRayYPeCm/ZYk5uaUxNvjyBn5zmL357SHiJbfR
	AXSFo39z8GFmNBFZgQu3j3Yk6nmEozuhX3tQSdv6/TNF3vdIqKZwzTZlyFeDdxC1hdffg9wgYmG
	Fm/MpaMxesse7phMXtVaauiCdwV6z9HST2gHiJfUJMsC0mEOA8K7s1ZrDruMb44to0at6fnd23o
	XcoTxUfILmvKO6jLlbR+IC64szirkAnxtSXiIOrkZ/iQybp8o6DsVT/qTidQ5uLj9atBmdoimvY
	lvdVyW1CWrNW87r0xHd28AMAsrM4uMlY75aVDcUDZNa25Dxngf3rY+kqoXsKxKTNDB08oHfwLbi
	0q/v0t7m8vR15dBSNjYKFi7SFQGNR7kmzwmYPWLtfhSohp2ktM87cAhd3kIhOF5Be
X-Received: by 2002:a05:6000:4023:b0:3d0:d6e6:5d96 with SMTP id ffacd0b85a97d-3d0d6e6642emr1463754f8f.38.1756472988548;
        Fri, 29 Aug 2025 06:09:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2EE1FdffCNgqV63lR4bEMYpCijk6Rt1WA7Ibu/9lrj3Iet7fHqrTgMv1xYGinJ39Wr3I/NQ==
X-Received: by 2002:a05:6000:4023:b0:3d0:d6e6:5d96 with SMTP id ffacd0b85a97d-3d0d6e6642emr1463686f8f.38.1756472987991;
        Fri, 29 Aug 2025 06:09:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d12c90a01bsm906716f8f.31.2025.08.29.06.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 06:09:47 -0700 (PDT)
Message-ID: <4f6e66a1-1747-402e-8f1a-f6b7783fc2e5@redhat.com>
Date: Fri, 29 Aug 2025 15:09:45 +0200
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
 <547145e0-9b0e-40ca-8201-e94cc5d19356@redhat.com>
 <34edaa0d-0d5f-4041-9a3d-fb5b2dd584e8@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <34edaa0d-0d5f-4041-9a3d-fb5b2dd584e8@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GbpkfKuv8s5UqqWJac3aa3nDrN61VqiDR3x3w864d_Q_1756472989
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8A6A140015
X-Stat-Signature: 9b9ebafmqs5pmia3whqbpcpufo4cxo6h
X-Rspam-User: 
X-HE-Tag: 1756472991-733895
X-HE-Meta: U2FsdGVkX1+vUAFHOSNbe/tJ60W5YHMpEvr03lD6Sl5jAMsCrBgQ62FNtHaBjUGaqf4dCbj5PnKjGfB++ao6Nxcymd0q4TKS49BxE6wJo0VRlCGKf/UnRvwrgPH+ej8BpvREkjbXlItxZEcPXZYYIufz2vM5PaSo7aGaWqadtiAFHnefyEj0ki/y5lGZBqdd/e2jvoji0SJSA+Y7fdrzeLgV/+OQmc8zyFoboqs2f+Gt8GYHuETqOc6ln6Qq1B5UezwDJt8v/Wzq5zzcmslk/h/XMg0bo1/Tyyf0ok+2tGtzIwdyOvWwPgbGqonRGD5CK/1qFBh5Pf0NKuezwObaN5gbSOc3/Daf1S51BhBfTvIrqo76rSb2ydCZhQQJcWBxQH6V+i4O9H9L5/cvlHDryN1LyED/tLkHGSCop21cx7kdr59BNgyHovIwVCLgzNAFjoI0LrncnItylDfdcazIyqakHNIs4mo94KmUt+yvBt0/QMBm613PN3l38dFvom46QL8aIVYTozjeKcXV0psWhGLEHjYIM0G5lriTGCr6Un5v7W93O6vs6x2rtucOxikimT0p6e03lODbZ2FsTPnirixUdNakMVRN/3Wcz+MuTmyl6s/Y49MnFaB2Z1l84KpZSCZ0GlKkkzp2jbmli2MyYy1ZnawhNajoDPI3wG1bwyWFMWtQ4nDK4iL5FrpXtToQPlEhqe0oYFom88/9K37qgMuoJI5Qd86Gw6TmjvNTWVIoW62p89QndZodG+dctapVnHs5ORrkdO2EjMR3bVBcWWcwTmha3ulje6L6EHuj/k4k0xkZeIUz2XjlX+wJxNeGG8hAnVZDaNCq0c0b2nEKajYgIEQHPzoTcx8sDLtUGKZkBhGq4cwPk6YTT84yX+wJbWPE7pFEYGT6XwQXpiRYaDCAA7NgjiWG5GVyXfwl8Mrkhw2hQTDSn8k2FtMVscUz7e/BYd0kA+1sdYd/+22
 GR0gZuNh
 ribXx0aF3kj9IYDUzma2Sf93MK5F5DHtJSLJvwMNSKe2d49yu9++LLokfuaXFxDu5RuqjV+/UnpQ81y0bMQFsi7APbar4C5iZE1xFpKyJzTDSuK5KYUP5ozxH40NbxRPsZfxwomb+ZufZgGt6zcIf/cZuW2bCwxIFpIxHrJQ/S19R6UTVB0jVp6OdWOC6l37n3i8WMl+rxhQiwAJDO2NiQmKs9JMJJRKtJ9ZiY20z5vfJEZ4tWj0gdd0agVAnNa2YdpYwGkWVt8BVy9MG7Xrc8dnK7I2Z3mFHCn3TM+VqqYXqjOWlJYUfqAGCl12ANCQshc9UJYZ+2K2QzQX1nJ1m4tZD8FG8nsZFJIQ62xjXgCS4YKYJJWC3/UTpIC0U3Yy3hWzjEm24cEYQdIVxABEO01+cjquE5anr+7sFNTpTon6vfe9vbVrY34kBvYs/Qbi94meucwHg+WdZ7/2muo6py51/LgJbYqZYkG3L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> It seems a bit arbitrary, like we open-code this (at risk of making a mistake)
> in some places but not others.

[...]

>>
>> One could argue that maybe one would want a order_to_pages() helper (that
>> could use BIT() internally), but I am certainly not someone that would
>> suggest that at this point ...  :)
> 
> I mean maybe.
> 
> Anyway as I said none of this is massively important, the open-coding here is
> correct, just seems silly.

Maybe we really want a ORDER_PAGES() and PAGES_ORDER().

But I mean, we also have PHYS_PFN() PFN_PHYS() and see how many "<< 
PAGE_SIZE" etc we are using all over the place.

> 
>>
>>>
>>>> +
>>>>    /*
>>>>     * compound_nr() returns the number of pages in this potentially compound
>>>>     * page.  compound_nr() can be called on a tail page, and is defined to
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index baead29b3e67b..426bc404b80cc 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>>>>    int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>>>    			      acr_flags_t alloc_flags, gfp_t gfp_mask)
> 
> Funny btw th
> 
>>>>    {
>>>> +	const unsigned int order = ilog2(end - start);
>>>>    	unsigned long outer_start, outer_end;
>>>>    	int ret = 0;
>>>>
>>>> @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>>>    					    PB_ISOLATE_MODE_CMA_ALLOC :
>>>>    					    PB_ISOLATE_MODE_OTHER;
>>>>
>>>> +	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
>>>> +		return -EINVAL;
>>>
>>> Possibly not worth it for a one off, but be nice to have this as a helper function, like:
>>>
>>> static bool is_valid_order(gfp_t gfp_mask, unsigned int order)
>>> {
>>> 	return !(gfp_mask & __GFP_COMP) || order <= MAX_FOLIO_ORDER;
>>> }
>>>
>>> Then makes this:
>>>
>>> 	if (WARN_ON_ONCE(!is_valid_order(gfp_mask, order)))
>>> 		return -EINVAL;
>>>
>>> Kinda self-documenting!
>>
>> I don't like it -- especially forwarding __GFP_COMP.
>>
>> is_valid_folio_order() to wrap the order check? Also not sure.
> 
> OK, it's not a big deal.
> 
> Can we have a comment explaining this though? As people might be confused
> as to why we check this here and not elsewhere.

I can add a comment.

-- 
Cheers

David / dhildenb


