Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D934CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A258E000C; Fri, 29 Aug 2025 11:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871688E0001; Fri, 29 Aug 2025 11:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760B58E000C; Fri, 29 Aug 2025 11:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 621448E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:03:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BA191407DC
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:03:15 +0000 (UTC)
X-FDA: 83830113150.23.6FB4369
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7127810000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:03:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=faB8axSp;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756479792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNfFvDK/InbGYpz7hUnx7wVGBM0fCoifXZYcngqomxM=;
	b=DOnSOjnpWAq1ZUUAuc0xMp5ANhwnI56cqE5PzHAKgYGS2jND+GR8Z8gCgE8uLKLwYwTZFW
	afMOukKSATZnREn3Kd94apbq9bviJkS3ZBW0ISy+WubxYJGnzm7ff6pH/H3zIIaXZ3ipKw
	CatjgFzTltgRBfFK8LNcvUt1+gbrEJ0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=faB8axSp;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756479792; a=rsa-sha256;
	cv=none;
	b=tOkZuXxagUp0goSXX3BQNb1zOKdtcIFM4CzeFwrUOCR20fbrTN0btxqUmYi3GazklrssGw
	YmTSmwNJv6V/2SPeUVxwgJgDz8l01QNQUqcm4waL/RFiuyhIOYodj9Cokuk/7ggOs8a2sr
	uiIVM2fn40EhsL11bZZgiyzr/Mfrq98=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756479791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XNfFvDK/InbGYpz7hUnx7wVGBM0fCoifXZYcngqomxM=;
	b=faB8axSpqeoWrDURi67YdcpySXGPG80b0ki3iOZyucHAGyDiHNoSikMi3Ww3g7zjzpo3k4
	LQb9EaBrW/BT7G/KXL2jrG+AOCKWzgAH+RTbV0A+IoZNgzvMdFPa/2uAXfzMnYBK+1s0Sb
	vuvB6JpZ699ZjGPvjlOBCHEBDQtHdys=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-I4RbkA0nMamxA3qw3HdPpg-1; Fri, 29 Aug 2025 11:03:10 -0400
X-MC-Unique: I4RbkA0nMamxA3qw3HdPpg-1
X-Mimecast-MFC-AGG-ID: I4RbkA0nMamxA3qw3HdPpg_1756479789
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b7d485153so12436675e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756479789; x=1757084589;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNfFvDK/InbGYpz7hUnx7wVGBM0fCoifXZYcngqomxM=;
        b=npuaX6FxPgy3vHvHD+WBbDUk29Bob3hkDrI2JzXx5nCuhXn5r2a3JYIsJKrCtHcgnn
         qyzjlHfm44Wfzt8HB4/p+yxS0gSJJYYccdcro5wsD5vray93mw/ITXVsnLbZ7VqMAAgj
         XcV2T2ZCUb/KXPfQ6EqqTNppapYyfvv6a2VUZrshVkf9kp+ZJlCRdX+7/e5+idLzoOOb
         SCpk/O4DNj2R7cK1s4oZf2r59Qpty3MpegH05COpkPapGIxShrK9VvL91HIrt39cLyyY
         Z6Krl7njAUx9zqvKQ4qw7NkJTkwHwvawPGhkbEBiB1PB+pR/eGPq+38pilYeQYDSwJHK
         ctPA==
X-Forwarded-Encrypted: i=1; AJvYcCXA2qL748AJXGQof37EgcQcJdhMw6pBaIzD5PejvjVnpVmhHaCEF2nsH9SDX5T3tKmX3Cojb/fltQ==@kvack.org
X-Gm-Message-State: AOJu0YzJzzgxfp5obaQCX4e06S38IrAbhJeFYAVCoWpZdecBJ7b3C7j5
	RlWAXMgCCFJZfhZjLr3tIiJUwDyG9HYjoU//x+kFqVqny+KcPGYogpcZdvNH4B5rRTC+7qVyw6+
	sWLg/4PghkRYCjVZKcg/Itjvq7iDt6I9VYoDxoI2/VOwnWbrVbDGbSL3HNz5Z
X-Gm-Gg: ASbGncsgmhE46+yTh6I9iQ9mgydVkKghsz3bIN3SbugURFs67ERclaKKwftrM6rWPVE
	dR4QjUHz6kKLU7RloJ2y8jrbA3nWCMQIPHKobO67NHbBThe0mnJdgOzoePrKlcroUJrlGt7KpBq
	tuA6jGTcr9EVxJ20D0GBuVazsunjWcc5twnfYycqjYHlKpHuNl5+jUEHVb/D6GVxlLTDvD+dLmc
	DCDw8oC9c9WMIS/b7RGHGTjc+Z2jLZrAWW/UGnxV/BRUYp4n2ZtqrP+4mVTSyHTuvlRr/k6+wRg
	+VgH6qTZAg5P4J6YDx1OprTYofjs1SbG518BzJXBhSwMfCcjfxEM6+oqPlJ4/m2xlZz3JYZ9uEe
	ZbYdsQnwmE8SmOrPuykcj2fm8BKjtsBbkuSO/qdsBDJUTkcsBwO0tTS2a3Ulb1ZTt
X-Received: by 2002:a05:600c:46cd:b0:45b:75d6:73c5 with SMTP id 5b1f17b1804b1-45b7631191emr63877205e9.18.1756479788993;
        Fri, 29 Aug 2025 08:03:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGikMHhze19oU7j9Z8WXvy9UKdfjn+TUWuWpcko8WMcBWDfVJcAonsPeRL4wy1QqmkB93j00w==
X-Received: by 2002:a05:600c:46cd:b0:45b:75d6:73c5 with SMTP id 5b1f17b1804b1-45b7631191emr63876935e9.18.1756479788506;
        Fri, 29 Aug 2025 08:03:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66b6985bsm87177855e9.2.2025.08.29.08.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 08:03:07 -0700 (PDT)
Message-ID: <8a6c0cca-c0cf-4511-86f0-df0b9e2c179b@redhat.com>
Date: Fri, 29 Aug 2025 17:03:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][v3] mm/hugetlb: Retry to allocate for early boot hugepage
 allocation
To: lirongqing <lirongqing@baidu.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, giorgitchankvetadze1997@gmail.com
References: <20250829095241.2651-1-lirongqing@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250829095241.2651-1-lirongqing@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iIZiTH2hiHNh3uJ8Y70Ce2V7osrv316oTNzmtcALYXo_1756479789
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i9ne69ay5fc16zj8f1ow4qf8pohmduiq
X-Rspam-User: 
X-Rspamd-Queue-Id: 7127810000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756479792-872348
X-HE-Meta: U2FsdGVkX1+WIt/tjIyUAB4i2mRZHEbpkR0rDe0IByMOZms88lgoXGJ8VeVXRpzj343GvoP0VoqtC8le1SGS4OXCGLJTxQNXUNFag/RHSYd2yxNf+S+3E8XhJpxcabR2ybHVlXuAnWZc0w8NFyYdi/fwJ0bhRSyz63xRm0V88FfHR+qsVkCOGtPniRg/sJOuB7/6DHYl+9oR5M01qYfovADcD2YZuIfIj7cb5WObQBdEnrEMX6ZjeHo+MEsF+PAXcWyeegK3429EGRCX64FplVqIhC+j4Gj+wAxNB8VMhWgwgbpoyG9jL9Y6e0kNZ+D24sPg9IvVnzWiPezMu2b2SRqgxOtEZs6wXIg+71SOvkQMFCQ/2yiLDKfgF0JvAzD5phRMwKJ8ZHQn2+Unw0UtEbInov1xaeKaLomLp6X8g33qnJBLw0AKGfNSxmmaMDpkx3RS8ve2yTPRUInjG9nosP2L6wLv9aoOgvcI3HIid69xt3h+SB96tRx3v0tUSJd2VGkHGgK91OFX51XfTgDEnvVOi9F4uY02lc92WqXIwQiW6np4p9WL9LRrG8FdzZGMV7g45hy5BoE8eGBXzTM05GIO8gRd08dEmdN7r2uZ8LX7IrCpBvd3CqQeLslpAah2f5b0Vzepsekv2p6gqZiWQ0R5NXLb5OgcaNywKD5TILDYVlKecOd5AuMiYmXkO3oasODiBcbB7PzJIC9dssGQfQA3Fzv9WgG9/ruCYD2xLF3eWhDwJrNXQSKEvZScED+RnXk6PPkJGXL3+kQdmyN1cf/fqLcaTqw0gKmqe29fexAnpqE8Q2AF/DbO6pev3Cb5EsQ3jEyYriVUtd4XMqLqzp1HOXrNIXxhSoxKCAcCcWVJOq4BhE6s+jmfAKhtW2FmdcPAqvEw1NF4C1pOyt53cOVMJDK259lmn5DLrr4VCrmGY7jScn8Zh15duuEjKgCxdn6bSXFt2CCF/w2pkTt
 Ulq+NAUK
 92n9sMK8O9ZFk/T8Fopy4SzYTWfPH52c+qydShRIC+QijUVkLwesW+2VwcE3xEkb4AENi2FmS+qel3O6q4nT11P4aJTRVwWrlcn6EEGFyQOH+TqbhNmimsSZ+lWeAqFkd6LhP07jooSugSSIVwQ55eH84CAYPq4jUj202kBx/03JMNeaMHZU6efDVMGj+kQxIg8UUJLy8Qtzc0iANEiWzBsofOAltkd3IOMpbz+h3NISBBjs/y5RDkM3lCvAAhjHVyvprsAsypQjASLL7GbESE3DymsLEqy/RJ17CIsGM3hydMVqu1xkgpLMd2kW3WQ93gHeQwVeF8hNmsIVG5CD3c8M+E+bNAaxeaWlRJTTWBm1qrApTA2Fje4GNjnuRZOyB7gWvNdBQiNs+wMFClJXMl4WLqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 11:52, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> In cloud environments with massive hugepage reservations (95%+ of system
> RAM), single-attempt allocation during early boot often fails due to
> memory pressure.
> 
> Commit 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages") intensified
> this by deferring page frees, increase peak memory usage during allocation.
> 
> Introduce a retry mechanism that leverages vmemmap optimization reclaim
> (~1.6% memory) when available. Upon initial allocation failure, the system
> retries until successful or no further progress is made, ensuring reliable
> hugepage allocation while preserving batched vmemmap freeing benefits.
> 
> Testing on a 256G machine allocating 252G of hugepages:
> Before: 128056/129024 hugepages allocated
> After:  Successfully allocated all 129024 hugepages
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> Diff with v2: auto retry mechanism
> Diff with v1: add log if two-phase hugepage allocation is triggered
> 		add the knod to control split ratio
> 
>   mm/hugetlb.c | 27 +++++++++++++++++++++++----
>   1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b..18e54ea 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3589,10 +3589,9 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
>   
>   	unsigned long jiffies_start;
>   	unsigned long jiffies_end;
> +	unsigned long remaining;
>   
>   	job.thread_fn	= hugetlb_pages_alloc_boot_node;
> -	job.start	= 0;
> -	job.size	= h->max_huge_pages;
>   
>   	/*
>   	 * job.max_threads is 25% of the available cpu threads by default.
> @@ -3616,10 +3615,30 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
>   	}
>   
>   	job.max_threads	= hugepage_allocation_threads;
> -	job.min_chunk	= h->max_huge_pages / hugepage_allocation_threads;
>   
>   	jiffies_start = jiffies;
> -	padata_do_multithreaded(&job);
> +	do {
> +		remaining = h->max_huge_pages - h->nr_huge_pages;
> +
> +		job.start     = h->nr_huge_pages;
> +		job.size      = remaining;
> +		job.min_chunk = remaining / hugepage_allocation_threads;
> +		padata_do_multithreaded(&job);
> +
> +		if (h->nr_huge_pages == h->max_huge_pages)
> +			break;
> +
> +		/*
> +		 * Retry allocation if vmemmap optimization is available, the
> +		 * optimization frees ~1.6% of memory of hugepages, this reclaimed
> +		 * memory enables additional hugepage allocations

As I said, please remove any calculation details about the vmemmap. 
That's not the place to have such calculations easily become stale.

Something like the following:

/*
  * Retry only if the vmemmap optimization might have been able to free
  * some memory back to the system.
  */

> +		 */
> +		if (!hugetlb_vmemmap_optimizable(h))
> +			break;
> +
> +	/* Continue if progress was made in last iteration */

Comment wrongly indented.

> +	} while (remaining != (h->max_huge_pages - h->nr_huge_pages));

Why would you want to retry if you allocated all pages (IOW the common 
case)?

E.g.,

remaining == 1
h->max_huge_pages == 1
h->nr_huge_pages == 1

while (1 != 1 -1) -> while (1 != 0)


you should probably do

do {
	...
	
	/* Stop if there is no progress */
	if (remaining == h->max_huge_pages - h->nr_huge_pages)
		break;
} (h->max_huge_pages != h->nr_huge_pages);

-- 
Cheers

David / dhildenb


