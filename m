Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B0E6FCC9DE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34946B0088; Tue, 10 Mar 2026 04:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C096B0089; Tue, 10 Mar 2026 04:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38846B008C; Tue, 10 Mar 2026 04:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BFA606B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:32:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 495E21604F2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:32:01 +0000 (UTC)
X-FDA: 84529485642.13.B8EC239
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id D341440002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:31:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773131519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4bzPpsAY3fr5nElRbxkMnRtybJXoNauNyYzrjHRz5M=;
	b=yAUThp+6m1u174G+KPrPRUjlX56iwAQPb7D0eG3Pg8BSW96XJUj7nGYQelazsjbJWwDyOt
	7KlHtuafcmehpzyTsK+lX6K3FYzOuZhHGvKAjW5Xf8thlRjMGfAngmTm2TThAfjjAN6MEp
	Rpn/TyHQILKa7eH5BWGByx/ez9o+wvw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773131519; a=rsa-sha256;
	cv=none;
	b=Llex8LmNjbyMtJGbxn2XxoTAUrM5pfEQ3JBmbNl89+A8i+rgjfrDgADhPQMPJjit9Z9Pg3
	ErBeNQEjhp0tpGseGqZ+yxElfrpY4g/WhUlUHrEhThrhRvXmCYCKSAFzAo1ruYsMYAkuFV
	gQzPWpDoWSK+/96zifpFxONguloNnCU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC948169C;
	Tue, 10 Mar 2026 01:31:49 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E5263F7BD;
	Tue, 10 Mar 2026 01:31:47 -0700 (PDT)
Message-ID: <58b3878a-24fe-4ed1-a870-604b44da71f7@arm.com>
Date: Tue, 10 Mar 2026 14:01:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 david@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com,
 kas@kernel.org, willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-3-dev.jain@arm.com>
 <92b8f168-b135-4c2b-a0be-36c8f8079684@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <92b8f168-b135-4c2b-a0be-36c8f8079684@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w9a9tayjpkautw4pfdtpq6fbyk9o1sfs
X-Rspam-User: 
X-Rspamd-Queue-Id: D341440002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773131518-114205
X-HE-Meta: U2FsdGVkX1934W4AocgMAYzkRRp0vECSQQdpn2fzv7UARGOBbzBee5KQPEfBYqU6U6pj7kPt1DPnXo6cVQnYr9Uq8V2B8YiPZr3CkPTKqpo1GVUSdVnmQxkaQOLC2YiwUmxDPVDH36KgeUxRZeGvIRHHkadpBZBHyEs1myjG3Yr/JtrJlxlnbYjSjh/qmKG8+UdpcsP3vDpDATQ+3SIE/KtPsEogX/ohpG5OGmlwnTuP6vU+8aqqAgyONuxbi3DIy9PnGAhXycqxWuWcXNUoVFvv3/bixOmYU6tzUsi2E/0UdSZ0qSnGVtKEyB4EBBylALxiteyUm2EkR0BBIINZO5N2DZ6R7Pzo2q5wVKvM2G4JwWNFv6a/8E+EM6HAldHP1shpC+1Qfftub3dbn2iNL0EN5/Oq6yOSC86nof0dhewYnHS9XLjQzGZQyEkFktHY1pFkHOz37w62fHw3mvZzPnxeUgIpc3klfS85LhJwYKojMtgjMNa5PZMLVNP0yZgDjXYFwDwcAPULkYybG16oHM6giU6BQqIOIxtmHUHLIiFcVyW79CYN1qGQZzhdmWYDGOi9UsAX8RJWpO/zG2JBn/rGAf24PgQNkq3o38lqjeIXaYiy895hHILmU08JC3VMwuTngQ1TuRPfTQ8Waz2t3kQVJApt+10K5/0BBuYe7brmHr85kXV7iSqAK5o6gIa6hlly1FlWEcy+9cOZb+U7yY6BxcYEKKMxPQqY5oKXheJec45KQ4LdlOZvY7Q4Xka82BUsjlsolNmoMA6VM3i7iUbGIbbcZPDLU6Ju3fm91FvzDFTI8VC7gJnYAdEJ+a4S/ecgasqPsBK1CA6wXlY+r020l1XtfiyfCTxGMtMlhegfhtb9RA+WgoBjFTXhGU6ZtIb2B9dZVpFLG22lkUgzyJwZC1qbKXaKU12dGL+tQnvFOnFhD23kdRcGXZuuVHHUgojrTP4/D3eJA9SgxnS
 4uKhZnkI
 E4izgEubRYWdyMHNoUMdzmH3ScZYTturn3RaHPOCoP/Fm2mOUGbm2PaDEL+mxXBr3Xy2YRF49NsTBGyOBAOXotwOL8qcE9ME5qtor4a7opvylSssfVkY53TgQ1FPQsJS4YphOKGWb6Cjp/8pGSj6F1kcvhj94kdr6odIePqJIpvipf8C8xNcWROJ2m1nb5Wc1prjuMKLH1+Jqm3ZiASGwJq+ir74dOIF+KEadlGXN6r7z/jKHg4y7X0/uXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 1:40 pm, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 10, 2026 at 01:00:06PM +0530, Dev Jain wrote:
>> Initialize nr_pages to 1 at the start of the loop, similar to what is being
>> done in folio_referenced_one(). It may happen that the nr_pages computed
>> from a previous call to folio_unmap_pte_batch gets reused without again
>> going through folio_unmap_pte_batch, messing up things. Although, I don't
>> think there is any bug right now; a bug would have been there, if in the
>> same instance of a call to try_to_unmap_one, we end up in the
>> pte_present(pteval) branch, then in the else branch doing pte_clear() for
>> device-exclusive ptes. This means that a lazyfree folio has some present
>> entries and some device entries mapping it. Since a pte being
>> device-exclusive means that a GUP reference on the underlying folio is
>> held, the lazyfree unmapping path upon witnessing this will abort
>> try_to_unmap_one.
> 
> Dude, paragraphs. PARAGRAPHS :) this is one dense set of words.
> 
> It's also a very compressed 'stream of consciousness' hard-to-read block here.

Sure :) I'll try to break this down.

> 
> I'm not sure it's really worth having this as a separate commit either, it's
> pretty trivial.

Hmm...well, as I explain above, it's not trivial for me :) it is difficult
for me to reason here whether nr_pages can be reused without a reset in
a future iteration.

> 
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 087c9f5b884fe..1fa020edd954a 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1982,7 +1982,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  	unsigned long end_addr;
>>  	unsigned long pfn;
>>  	unsigned long hsz = 0;
>> -	long nr_pages = 1;
>> +	long nr_pages;
>>  	int ptes = 0;
>>
>>  	/*
>> @@ -2019,6 +2019,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  	mmu_notifier_invalidate_range_start(&range);
>>
>>  	while (page_vma_mapped_walk(&pvmw)) {
>> +		nr_pages = 1;
>> +
> 
> This seems valid but I really hate how we default-set it then in some branch set
> it to something else.
> 
> But I think fixing that would be part of a bigger cleanup...
> 
>>  		/*
>>  		 * If the folio is in an mlock()d vma, we must not swap it out.
>>  		 */
>> --
>> 2.34.1
>>


