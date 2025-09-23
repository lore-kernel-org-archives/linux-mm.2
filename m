Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED77CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 06:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20CE88E000A; Tue, 23 Sep 2025 02:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC4F8E0001; Tue, 23 Sep 2025 02:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2CF8E000A; Tue, 23 Sep 2025 02:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDFE78E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:47:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74B0C85581
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:47:57 +0000 (UTC)
X-FDA: 83919584994.09.EA1CD0C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 75B6D40006
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:47:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758610075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9csw7dw7XZXmLl6ExHbTwzheBQS94NzRfll27MS3TRg=;
	b=YiGVR2TYNhZMzXL8qKda+DrRvrubUQGouhLJ6ek5fSayBvGSorMcvWK+MyYVWM15AFGb9I
	PFEdBYBKQo52VuI2KJiaIgKvN45uCi3uHnACG8axUNj1fGQifJ7MZTGYfKPvXJowZHlzNi
	qs8SLeXi303kSsDCZ0u9Ny8vQ/teo4k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758610075; a=rsa-sha256;
	cv=none;
	b=cw8Bh36LZmLqKMqj10Q+hdE9xpNGIpTnCaDGCkZhbV11uQL+tGb2IQSg8CpLhHtVCzs2j2
	NlB/9+NXTVB/vruzL2Z0YQY3H7QD62Plt6bczjVhcbD7WGAlD/uLjxVS0Pc8towgUljvfK
	CzIOlGZohF7DXKywln0NRQ736H6XGG4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B979497;
	Mon, 22 Sep 2025 23:47:46 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2ACA73F694;
	Mon, 22 Sep 2025 23:47:50 -0700 (PDT)
Message-ID: <fbbdd325-a8c4-46b3-b303-a8082a11548e@arm.com>
Date: Tue, 23 Sep 2025 12:17:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
 anshuman.khandual@arm.com
Cc: linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250923001943.2479-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 75B6D40006
X-Rspamd-Server: rspam05
X-Stat-Signature: zuxpj15n4gdqeoup6nzo6crom4pnt1jm
X-Rspam-User: 
X-HE-Tag: 1758610075-788169
X-HE-Meta: U2FsdGVkX1+rGZAaY+bfmeMWg9vNviSGQgNqWRWXJrQA6EeoNEaZRE9J1nSe/sqPJojl1TWwrY4qrVagKccQPhsrawxHXKCIHxOCM4Gffxxks9L3YTXZ2+WuvmsVDG8+zTR8um9UbM58nLsBWAjGjhgsGJpGVtBp4vR6e6WhjgNUsUQpiNUqTyx+hS97sRozYMKKxa/ChpC0v7a8tVzd8Wd0uHxkXVq/w4RpyYuj1/SCZIokLzVzZuklayvS1oWIWyGzxUQwgMH8catCdBYKogvCDusTc3ZwdYPE3/66AwA8ChO2uJN6X89JZcLyERpLOE974u7lf/j7AA99XQMJM/oXIy2GDhraB6ESwGscoyr4fum7Qerpgo5HEdsMjiAnzyXE7N7DoFWNyUpn9YBZ8h5E6vzxtbnOYV5B1whstYz5eB4zUa5cHtcLvtQJq4J0O6oaP9KoRPA7pDPYNLq+ku5TvF55HJE7EpYWlHVaVKWwD/QAqYjB/TxtMtXwiuOp8hfQhgdMNIBl/1U122TVZuPWn1P3dUKymy9YAst508gr2D7gkVcO6B9IQ6Ur1t9lwQK5d8uhlPMMRcc5Ei5URJENy2r4Ny7syN4Kw+XW0wmucQSRvEA8/gvMFmoVpi5WEwVWLprisPBzoRikQ0YFZtm0DLrVF0ZGxqoHl6Qta6Oi60aDnSUCpLHPm09fSt33lJyNdT9G12ytvtpX4dJJatumgY9buR7ohV8mg6gWwdbkuTCUqt+neOEZkiB2TzbVD57vjUXztyqWsf1ve2bKh0sR6TI+QILkSq/8iaBCSC7McTAXk9NsfM94jBj3Dwbx3tXYGWcRsl9k34P55HT160si1e4nFdz3HTN4b7tzt1lerMyIQING6TrFf7fEo08Vso6r/XK2kz6/+XEPTEgoYPGIOAW+4d1tmFSXBFyAT73wN5IHCNgUeskBgoks9+pkq4DZJUzmo/glBgc7Eof
 St7gTRMX
 TIdiBq8KGsOGiJFom81y11UQpizvdm2mJTOPJlkSD+rY2ROz5dcED4hQzS5zGcqdT6AzxhsoqHL2DqJfOoXQ6PLnYRW4C8LQIGs120wJn2NIqZNflg5FmwpwzQiHXdVuwS3Pb5KFQ4fJnihK0gNtMQDjiy5l4p4hJWHxzLG9RLOuAWZKZdbz1mIb0jWCRTd8+tDrp6RlIid5rT9TW8lKbMVkUtKdTKCgiH7hsOFWw3K2VrVcF4ISOscNFUgf6VMamHFP1B9xiKhnK9h9cwv7MOsUvlxJ3U4c5nPI4lgl30O7W+WTczHRaLWqc2sTQ1DtHhTzJT3RQ91q56gWkZhyAIavWPoMaQILFNk0MjjpnNfepYpC8v15nvKAgd9LZ4fpGhRrMm0BsGFvoZdOtpNHaOBfqOZ8m0TrgcyP9Ew2eBtDKqtyT5oNGEOWEXojmvccxyAxamgQC16QL2X0pGh1RYojMNxGWvyUj1yuqy8O0WFsLv5fBxAjHcrZw7bYWF6bxYWi0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 23/09/25 5:49 am, Wei Yang wrote:
> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
> introduced generic method for alloc_contig_pages(). But the alignment
> calculation seems wrong.
>
> Since ALIGN() only accept power of two value, while nr_pages could be
> any positive one, the result is not defined.
>
> Use roundup() to calculate the correct alignment.
>
> Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")

The ALIGN() statement was even before this, but not sure if a potential
caller with non-power-of-2 nr_pages was present then.

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>   mm/page_alloc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a1bcc1e003c7..a17a6014e3db 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7095,7 +7095,7 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>   					gfp_zone(gfp_mask), nodemask) {
>   		spin_lock_irqsave(&zone->lock, flags);
>   
> -		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
> +		pfn = roundup(zone->zone_start_pfn, nr_pages);
>   		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>   			if (pfn_range_valid_contig(pfn, nr_pages)) {
>   				/*

The kernel-doc above alloc_contig_pages_noprof reads:

"If nr_pages is a power of two, then allocated range is always guaranteed
to be aligned to same nr_pages." This means that the function gives no
guarantee on alignment of non-power-of-2 requests - and why should it?
It doesn't make any sense to align pfn to 7 if nr_pages is 7.


