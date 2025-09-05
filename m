Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D84CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40AD8E0015; Fri,  5 Sep 2025 09:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F184D8E0009; Fri,  5 Sep 2025 09:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DD78E0015; Fri,  5 Sep 2025 09:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE39B8E0009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:35:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 794B2C01DE
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:35:05 +0000 (UTC)
X-FDA: 83855292570.28.EF20D16
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7929040012
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:35:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/nPyn0I";
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757079303;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BkdIDYEs3n/1rabog/8RZvJo/R1/y+A/HldPG5Tl8U=;
	b=n5kkNhbTdXhRt+18DPKNZZo7rL6l0LmDfhT2k37Va9wjxFZoPQxs+0GWdQMykVwS1Zssyf
	KY9vEMEAKsrVGcW0NJP+JHacYuN4LWjv/5nzzyNQf3/XwtBHyeInMxC7hzd2iZK0VBS+9Z
	gkX40wxbrHDIB6yef43PSQyefvJ3WNs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/nPyn0I";
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757079303; a=rsa-sha256;
	cv=none;
	b=K+Zgot2WRsO7OGinOEgxf1UU/Ni2566+GQQ6U9+bsNCR26KYTtd1YR+QBCKO3oAaRcIH71
	MkzpDqPOD2s558TioKJnRNkWQlhIsd28lyvf+LVJwTbOq0D7ojuVknK78yi9WgYnxgxDWc
	tlReE1mbGJkW8fbvBvA66Fu47rUtrfI=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b045d56e181so316276966b.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 06:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757079302; x=1757684102; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5BkdIDYEs3n/1rabog/8RZvJo/R1/y+A/HldPG5Tl8U=;
        b=B/nPyn0IyD9jIfkHiwkHiEjNYd3VIzHIVAqiQqSHplIf7YitCdMTKFOXh6inOhst16
         IofdOaSQtzGvElpjicZ5pGaiAy+5X12yyn74tmD0JFLUViBnd5OPOybmz5vJIi5Ai9b3
         T9RN8eK1I0dxWsmoBsMl+jDeO7+ZbY95BAg00fnbYCpU2tXOPBSpvNoMwwRcelRfQOaP
         F5ai5oQByntJuDObxN39dtNCijV2oFtH4+ghg5fMshTlc9rMNDL8a+y44AWy9R4OZlms
         FdUWKF3pw+QGtsj/M9GouqzThQ8SY7oXSiknl1H11NRP2LY29QKHDpmb3AZuj/AuXwaV
         m3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757079302; x=1757684102;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5BkdIDYEs3n/1rabog/8RZvJo/R1/y+A/HldPG5Tl8U=;
        b=plLRVAfOhJElYBvx7Qgjd3aiLGGz0TfCaPkwXFDVS8oJgItWIZISvfA/2Y0XClPbDt
         MntRbGkPfOokXVe1G3yZOE+0lr1VIEadkPivF+SFleo0BSMQ4S/LDVUpjslFUCp2z0vA
         2BnVZkw3TG2jmFXDIJ/p0VJfROihJoPtcbEq+rSSlcUHQmLf7PAIfygl+dHdr9NGJ8dQ
         WLNL6FWwocV3uevMgT+Z2ltf8SwkpmPEErc8BYDizuwwcAJZ3OM0oLAEsoUa1qd7MTBO
         y5xxFOtEHnAh7NuA3RyWvW1g3h4Fh/58/IJR9Hv1acxGECXRt50oYH69wIXm+dc/Q1Ii
         HMlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpQE+aaHUyiZxoEcZDhRb7bGJ8B6ngJfXpnza7odtJZVXYWD1WbN1GM7xW/seVX7s6JC3+ahh6iw==@kvack.org
X-Gm-Message-State: AOJu0YyVDofmUWUGPpKM3elEIwtGE/X72x6eXy04hkpC1n+UIkCjSeNn
	aJVkd6RD6gZLPsgL70F4mJByK8Ttg1l91NtG1FqvbGHz+0qjSYptU04U
X-Gm-Gg: ASbGncuekjn88PoSXUODbzrSf8zKo1jmH1Pz+0V/LVLlm7DnBUvKCJLoQ/VWScWATfm
	EZYHRQ2N39zYI/2sozm5ALIwsoAzXGTTut/EfvQEk4q/x8QN1C8bdGVxExJoeTKuofNbKuPE3jf
	nTspeUlDf7ZvmfSMOcI1SEwESBdiziFuWDdE7mWoVz2qnNykL0TVzkYYAgKxJOEkdePssadhXNh
	8vD4qQwplPPKhTmLcsSFgxe9si/YNPT1JBJ4C6XYnkEk+ANHA5UUtXay7BJ2oC8eXq/nOLtcdi5
	ygNQAXoQlp7Wpmgtx/QscLfTyqnZ+hOfm6Hw03zObTiGAcG8GZMHiAefkMIXY3rDWfaYoxh7P+l
	y+uvykNf9eXyxYBdSDxrRP4A+/A==
X-Google-Smtp-Source: AGHT+IHDFusZm2qgvus4Spg2jq8nE5DaWjLI70ezr8ffZrKFXfL7OL0L4Eso3kbY+yJ5O4V7VzGxIQ==
X-Received: by 2002:a17:907:72d6:b0:b04:6bb6:c91d with SMTP id a640c23a62f3a-b046bb6cb5cmr993120966b.1.1757079301578;
        Fri, 05 Sep 2025 06:35:01 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04323984ffsm1157875366b.64.2025.09.05.06.35.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Sep 2025 06:35:00 -0700 (PDT)
Date: Fri, 5 Sep 2025 13:35:00 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/page_alloc: check the correct buddy if it is a
 starting block
Message-ID: <20250905133500.kwg34fshukg573mh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250904020654.28689-1-richard.weiyang@gmail.com>
 <83f5643f-7a6f-4954-a989-4d76a206d0a9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83f5643f-7a6f-4954-a989-4d76a206d0a9@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: itnhe5fr9pzzgjqj5sg44d73qcfk4c91
X-Rspam-User: 
X-Rspamd-Queue-Id: 7929040012
X-Rspamd-Server: rspam05
X-HE-Tag: 1757079303-639995
X-HE-Meta: U2FsdGVkX19T2NunsYCF+llJTTiXk5tSonJR40wZZa4NI9XLkFvFOKd9tEAYx6EMNrjgJjMjlrtPdRnPQUbaCNvJ/5vfLT8s4CPDSGup8SFSv58mqRQRLOgcrJMdHsV7+Pp928iTTvmjDKL29n8X9lmMern7b2a8of3f4B8dcrvgO6U4T4Lke7KQvLZGf3Lt19YH/D1wPiuLVXBXwkQXZhT75n5Nx0ldeIA5Q4GL8P9l7UxcxZlpQWqVkCZBRzXm1eK2CkvGlQY0Q1hHe0FeP/9Blv9LYQBCRt5ezzxbGmBRL9XF8HaBKB6EZV4ZdDDpd8G3fCfth4q37RiJdUhlnsYdAAcP7EyojngvvJBDXz5QgAHN8mK2ahTQehQnQRfIlH3ZIyK5fsoYMJ/TgtpDz7gSv56FiVnj18EhUI//eepc05FaU9NGPLWaer70nch5c7xqg8/a6i16GgBRL5BFufVLg3TlKHFp97lxzxBQgwqPu2Ac5w2FQLWEh6Hoq52tGVfYv7HngGU6lbMAVnRaps7qem+LyjW3no+3msCbHVQxQCPN7H+T0xBUvQmCDV2k1V1mINjecGqRA4FLPL7ptVqd+gxx7ec6NUZFFEhDgbxCHH3CHpMx2U59vuV7qcDb66XuW/z+y7hPEPt+JWkzTRBAYIXZrAJRpYHyBhviFpbqPISuD6GWaVfVQYFAQopSb1EtWdDWaGhOuYZGjOLGpW8LfXLBibU1Pkn6LrgZcU/g9kcK3Lecj+AHPZfJJqsDsBtWEvVDABq6eGXn1XPIO0fVBt/ZZdslUEPAd52+adzwZQr+R+VB6LsUBvXdSjlBy1s2PyI8gCAHcethkdG32YSwScXU8Y+5P0IFFKq+a8iTgI/2OTTuekfZrPbR4W/RX/y2aHXlQVX8MlctE1V9zvbIIEBnwBGQo+WW0x79VsKSacI4tn/wQzqhQ+2IsiePQ2GrQCRF6uoVadlHCRt
 ZrIV9b9C
 /KzGDGTMaBOE2KRzJcRqU2QVNXJGRHjk9BKrkugOOAe3H3pexQyvs/pR3NUwvJhvpiw8u46K96x+cHu6P+SDxkL8txKO+4ywNrAGPZMl74I62KsAjgnFZwi9/v6QHDsRLN+2Qn1rlmy1ech1TxY4VfAnpG0pC1g5vNP2CX9wfzJkfhfh3vpTQ7ZBdpWEud1A00ZpIjNY7vURCqOAmDW8pTZGWkTWnVTDaN7drBJtKOw81PMqiXIVpDCMaFDt3xG1NS1zlrZfG0/OZo7/sVdhrQfzfdNWBJxvyBqRYCH91/GA5NiFy5teLNsplN3WaE3mCIbUBe2u9DvBDnvuD8Hf9xSL0C+ZxIe14Ru0Is3uAoNjd7FSTqwEJtTBIGMdDYqXIFlrA1cPyvvWfo4+1clcv372bamUXUmb0Si2afjaoDzNXg9mhTUvf7c6PzlJupVGM6jnFXQ+8ria4TqwhYK1+B7UMPgUYSYnHvJV0lNI+NTLKawzzpTOt1w7FDv5gu/yVD7dkCwj+ldBdvJ+FFUK20mvHN21eFTZqzoPJZXTh7Kq1G8ON/IpKrdQY/bimVVxke/vunfKr+5ACO7sbwk6NQyQDwXdSNRPsxXYhbKuGfWbyWWzOEYgs11qHFlLkY4va0dsr/cgSS4eGo3zjm7CPlcv3/znOGhcF5pp+WhhKL+NsD1i/EIxHILW5MIG4kaEM1af517hFBhZ0KsKhMhOZu5HT52PcFbnms1L03B27Z+4fOBy71EKoVQmJVmz6t7Fjq+kYZ0BhNjIijwC5MoUvISZ7iwsbqLc1JByDiuvEORh5eSP2SNhdLoXdp4d6NPQ9kapZ0lalnnX2j5V7ua3kupmThW5mkC3Baz1PMyZHSQi2UKi46jvHacNayKQYXxgMFUTbNv4exuRnrhXpYOLadOrZdQx5lQR/35Hkl0eN6Q2MPD2eE+LEIHUbsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 11:40:42AM +0200, David Hildenbrand wrote:
>On 04.09.25 04:06, Wei Yang wrote:
>> find_large_buddy() search buddy based on start_pfn, which maybe
>> different from page's pfn, e.g. when page is not pageblock aligned,
>> because prep_move_freepages_block() always align start_pfn to pageblock.
>> 
>> This means when we found a starting block at start_pfn, it may check
>> on the wrong page theoretically.
>> 
>> The good news is the page passed to __move_freepages_block_isolate() has
>> only two possible cases:
>> 
>>    * page is pageblock aligned
>>    * page is __first_valid_page() of this block
>> 
>> So it is safe for the first case, and it won't get a buddy larger than
>> pageblock for the second case.
>> 
>> To eliminate the ambiguity, unify the handling for starting/tail block.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> 
>> ---
>> Tried memory online/offine, which looks good.
>> ---
>>   mm/page_alloc.c | 17 ++++-------------
>>   1 file changed, 4 insertions(+), 13 deletions(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 5183a646fa09..453cd361386c 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -2093,6 +2093,7 @@ static bool __move_freepages_block_isolate(struct zone *zone,
>>   	unsigned long start_pfn, pfn;
>>   	int from_mt;
>>   	int to_mt;
>> +	struct page *buddy;
>>   	if (isolate == get_pageblock_isolate(page)) {
>>   		VM_WARN_ONCE(1, "%s a pageblock that is already in that state",
>> @@ -2107,10 +2108,10 @@ static bool __move_freepages_block_isolate(struct zone *zone,
>>   	if (pageblock_order == MAX_PAGE_ORDER)
>>   		goto move;
>> -	/* We're a tail block in a larger buddy */
>>   	pfn = find_large_buddy(start_pfn);
>> -	if (pfn != start_pfn) {
>> -		struct page *buddy = pfn_to_page(pfn);
>> +	buddy = pfn_to_page(pfn);
>
>While at it, can you please rename "pfn" to "buddy_pfn" ?
>

Ok. 

>> +	/* We're a part of a larger buddy */
>> +	if (PageBuddy(buddy) && buddy_order(buddy) > pageblock_order) {
>>   		int order = buddy_order(buddy);
>
>Yes, I think this should work.
>

@Andrew, looks I will send a v2 with updated changelog. Thanks

-- 
Wei Yang
Help you, Help me

