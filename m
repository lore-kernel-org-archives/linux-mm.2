Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFDACAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 07:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BBEE8E000B; Tue, 23 Sep 2025 03:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393A38E0001; Tue, 23 Sep 2025 03:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D04B8E000B; Tue, 23 Sep 2025 03:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 188E98E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:06:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD9AFC08C8
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:06:21 +0000 (UTC)
X-FDA: 83919631362.26.E9804B4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB5BC80008
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:06:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758611180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9PcTxkODncIYaf2ie+BWlNn2fNYK4Em8fP/tkP68fII=;
	b=XK9xSlga8H05iGw+PVFGJpphr5lHlJU7h1NH8aYOrt38yowMJ5GKNtiJ0gtiEDAebPvJQp
	O5C4SuYS5zlorzOAia5fS6f/DDwmmrRA4s5CU+WL3WqXJoaGJTxriY1fnatirOwRM1bS2j
	12uRG4/VT6KnOcFww5VMPuSzuwYYn0k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758611180; a=rsa-sha256;
	cv=none;
	b=gzkcYx2kFR6RfJVwfBOrL28a5y6gdPCcMnWLEnGOKpXn1oWb/ruM/smJPoysN+KldOP1qN
	GPdb64EhAZFXmPTYCw12I8peo777KOzGpbm7+pvSITumK6ppM5mnLDoxWxU5m0yBy9hqif
	I06mQJ8SlKc1JHYPaDmxZji5FlQ2JNY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB43F497;
	Tue, 23 Sep 2025 00:06:10 -0700 (PDT)
Received: from [10.163.43.74] (unknown [10.163.43.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 568D53F66E;
	Tue, 23 Sep 2025 00:06:15 -0700 (PDT)
Message-ID: <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
Date: Tue, 23 Sep 2025 12:36:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, david@redhat.com,
 linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zw8tshcawrrk975agydioy7q5n89x8tj
X-Rspam-User: 
X-Rspamd-Queue-Id: EB5BC80008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758611179-778554
X-HE-Meta: U2FsdGVkX1/zQdK1qp3GWdZKIiXgLh6LdPq9x/TRnyfROFEjFqXpnfe3TuO+/NOApLRFWbwQ2jwdk9jIyudb1xcbaqMADSiuDt35iWFNX9U2jAoVj0phIuGvskHAwQ1rlln48jsONZG1C0O19xncOtEFFYz5VfZXMe1W4XneUh8ZsvtRcVxhbK0N1pIde3mPdce0MnH+k0ZLm0p+0Evtf2KI0CehAxkxHRFlekcu6H6jbNzq3OR3T5VfBZnsTH8thPk0f7B+K/ZgsY3xiP6tuwN5Z2ve6C8aMLOXozCTuV4uCvP/XPdwxsEfZG6XWdkWCUvG+3xQaiFGaVrWUSDdyhOWwaBOwjTQqrPQC11WvUAPreLmwvUdA+5i5mBBMJEORVkT9h3RfcoTxtSz1vjs58U8vBgWAWqup1Yk5KXlE8K81zRAeWwTG0CcQe0JEb0XSlRzAaRDK7iPnZmXoYwNrlGIK7CYpa6RC2opyvbMAHlc5xYYWz1TOSB+4zeUDay4lsyOkVm6Jg6qEZq6HYUpjy+N2M8qD480HncLbTgLVrOw6LpJZ7GkGUjcoaH9IAYtlNA6yYeXjQP3TKUWUac0aXUjUOhOQLjKgd5JQpBOXGPBvFp3D1ZGbMKE2weyheyu5InQb/AkTeaa54foWoOiT+7zpP8spmhmbY+BTTBijRHXQB5X7lL4iqJJ1NoZqryoRSO08LXnyLpHd2KnBkaRWtNxvtGUrla6vygEuPicWrj5TWM1vRkBJeakZ030eHeJQAH5wNOXfj1ohmwSrq6ZMMTAHuAThPeeibViSgmpJtNMTcV9oNnBCH9z3AzJwe0Lor94pveLPufqAq0pxER+ZZ5dIcsXSoZC5q5zk75V2oWUNv4L65yPCFRu0fRvm5BZAyMktMqEHYjwZjyXVzK6SKwP2ih69ekX/sDHaGj+wB5y73re7mFGX0h9ahwrG9EwPpX0WUJKh9hx+BFHk5A
 rjrXXO+p
 8mZEcAApoGI+ftuyVAUMMwGIL80PwI0S3pXKDJR/pEOzsrgskuLtYPQ/ynPFKXVXUwFgAv7qIYg3IIi9TZSg9NmTJtyDHgRdPppJQumprtFsV/F3OhxrdRPkgQuJjh73vEGJA6rwMtz/eeRQzg6YHplNhtyxkKDyCJ7A5ZhKnO6/NyzCcWWTi+omHsz9GXvT5hXATcPzeXy10yHeXUgMwsRkC1iwVbhqvF1wyBPs7n6l1ARPOF3KA2eBFsaul7/rfU2KdKaDTtS9gKPEr5sKb37cLH9fhqMq492qGt+y6DIyb+U5RDr2EFediugcCmhRQLde9QkYAk/8IP72cIBoxtrzjSdWeeHeqXv59EJb9H4gLHqjR9RgpSd8ew/XUJ788Y72QZRKOK4xp+p2d48RU8/KVpJ8u0Nb+yGQZesfNLGN1ZPZmRsKbTsXr8nwRYgQYiaRXKdSnFOaX5vhBlcp5VAupW3CxojiPReM56tyLIxupRFW+7MRKXshIF5BvcpUFSNzX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/09/25 7:16 AM, Zi Yan wrote:
> On 22 Sep 2025, at 20:19, Wei Yang wrote:
> 
>> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
>> introduced generic method for alloc_contig_pages(). But the alignment
>> calculation seems wrong.
>>
>> Since ALIGN() only accept power of two value, while nr_pages could be
>> any positive one, the result is not defined.
> 
> The result would not be any value lower than zone->zone_start_pfn,
> so the worst case is getting an unaligned PFN range. I guess
> most of the time nr_pages would be power of 2.

Agreed.

Also as Dev had pointed out earlier, this function gives no
guarantee on alignment of non-power-of-2 requests. Hence I
don't have a strong opinion either way, but does it really
qualify for a "Fixes:" tag ?
> 
>>
>> Use roundup() to calculate the correct alignment.
>>
>> Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Brendan Jackman <jackmanb@google.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/page_alloc.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index a1bcc1e003c7..a17a6014e3db 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7095,7 +7095,7 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>>  					gfp_zone(gfp_mask), nodemask) {
>>  		spin_lock_irqsave(&zone->lock, flags);
>>
>> -		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
>> +		pfn = roundup(zone->zone_start_pfn, nr_pages);
>>  		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>>  			if (pfn_range_valid_contig(pfn, nr_pages)) {
>>  				/*
>> -- 
>> 2.34.1
> 
> LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> Best Regards,
> Yan, Zi


