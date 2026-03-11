Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D74F2FD88F9
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 04:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13AAC6B0093; Wed, 11 Mar 2026 00:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1C06B0095; Wed, 11 Mar 2026 00:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25EF6B0096; Wed, 11 Mar 2026 00:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD0F16B0093
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:56:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5593759A9C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:56:27 +0000 (UTC)
X-FDA: 84532571214.28.716FEE3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 83C2F80012
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:56:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773204985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Se1ojWA+3hlBR7Amx6VKpGIjPAM1tcSgKCDNIviHObI=;
	b=Udw2J8Hzvphe3C1b6ZHe3YF7Yg0BiahIPvKa3EOH9NIsYuAqXCaXxfD9SZ0rHvwYLfPgpX
	9ibTwSaxAImqsubFpD5p7NjiPAW3j0Rik8H5Bj/Hrys2Lrl8Sz1MqThSghEGgvhTzeNTPo
	BhyFxxXPGenaTO/vQJlIty94WqNf5go=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773204985; a=rsa-sha256;
	cv=none;
	b=AZ/o5Y1wblQK7fyZX4Rzn4h+FoPOjMB6wZfKlrQw1ldHSFtC8MovTeRBjzDxa+pGOb9tC4
	emQkbGDw/lEzszcS39SxP9tUowkanbtpMrDqILwOsdUaEtBMnjR5JqqMXOcn9Au0ebCNav
	ysf9ONulLz/0LDGXLIwhjqGAGteK690=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21107165C;
	Tue, 10 Mar 2026 21:56:18 -0700 (PDT)
Received: from [10.164.148.48] (unknown [10.164.148.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C532F3F73B;
	Tue, 10 Mar 2026 21:56:14 -0700 (PDT)
Message-ID: <5b44d878-b187-4764-8c67-51ae690b4b91@arm.com>
Date: Wed, 11 Mar 2026 10:26:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] mm/rmap: batch unmap folios belonging to uffd-wp VMAs
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
 <20260310073013.4069309-6-dev.jain@arm.com>
 <00f65edd-5b16-4f9e-a9fa-b923eba052b7@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <00f65edd-5b16-4f9e-a9fa-b923eba052b7@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83C2F80012
X-Stat-Signature: 934k9hdt6saxwzabt4ehtj7kdup7adr3
X-Rspam-User: 
X-HE-Tag: 1773204985-203196
X-HE-Meta: U2FsdGVkX19kU1rTLOXV4/Qu/7qze9YNgyDW/Ysgd8UYKH5R+CCNwWgZyDyz8aFXQ1nyq2KCS7SAuDxF47GU/QMAzh4id/xJnoXTVtVrtdiBjyud3SnFFoHc3LyqFwdPrer2OJoi4zHFK1Dc3YOYMEP2/Jx2BmSGw12CRcEHWNFs4ByMXzBeYcpgCsTAR06M9VSWv+G+jthQCABY0CCUSKqlZ5oaFjNEdDy1ahVJyjVsSrEUrmGrAy/j7NJ8UU+rHCYTs0+mSg8BoCiZp5W3nDfl1uUti/8VOadA3TYChSHAxElSf+Ougfvjyl4BYIMaz+qhcxA5JLVayid8azHO4V7K8Dzi7UeQXpeGbR7GNq413BwrXrrCdR0PqK4SqhX2Qrww/SB7LJG8hkiC7xEl8qbV1i7IbYZ04CGU2GZ5hGczCHjcLbce8b91gdlN9/TBwlC7coB4ogalK2aQZiI03y1Y+rXwV2Y1DiQU7fLpGl5IE0EuAeURZAhjHiReC9dPKL6268ceSqSZQyN7myCLqiHWP2TKV3dXYntgPMqgJv0q3VUJVLD4z53MDsgPQNfQKrTEK6u0Ng4VJ8m9ITQglRVH+Rl6yLWyJKPT5x5iQKVk2WBumoceOGU0BqcuYRhuBhoY5hkdI+/Z5OeF2vaw7mqKmev4F74xMy8gkSs0ko0FgHVbSIexAOQ2HIR3SyeXXPbGaoYN4hR/cKn5uOYyKlDQ6VEg9Ix9/aLtGZNvTYWJtJDckteVEZ/FWcQxv3eCdpg03HJVjelg/Vg9h/9RDABFLIlG4bc8sT3j2W5WgewrP4HLQA1o4rSBWrx3AoHKTquqzoYx/JtWfMuQEJPBU+JIj2D6KSv/F2uUY++x+pO4O3VAH5iQmTGRKSKu9/lJCMl7IjjaofkN/AxAc1bPlRgTRBps9ZUbnuhxCkPKhxdbq04k/TTOlOSGX33Fl+HAdzReLJF4Voo191h/M24
 tL/4y0J8
 VTT5vftd9GbtOFdybrSBpOgu4q3DU61s3asS5bNL9qjviRlAPwrffc1Lo/Mt4MDxf/q1LbuHC1vncgwPlLXrSXJwQk6IQFpFELg17upMv0m8BMLnp6TtMWQE8LW7E7yL4pHHuD8Oxqvvy8HYRB3bSEMwlRWkmUzUTi0i1120M2Me+vDRSNwFAv/uA6J1Egq9NfJ8Z688yZcCCLBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 2:04 pm, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 10, 2026 at 01:00:09PM +0530, Dev Jain wrote:
>> The ptes are all the same w.r.t belonging to the same type of VMA, and
>> being marked with uffd-wp or all being not marked. Therefore we can batch
>> set uffd-wp markers through install_uffd_wp_ptes_if_needed, and enable
>> batched unmapping of folios belonging to uffd-wp VMAs by dropping that
>> condition from folio_unmap_pte_batch.
>>
>> It may happen that we don't batch over the entire folio in one go, in which
>> case, we must skip over the current batch. Add a helper to do that -
>> page_vma_mapped_walk_jump() will increment the relevant fields of pvmw
>> by nr pages.
>>
>> I think that we can get away with just incrementing pvmw->pte
>> and pvmw->address, since looking at the code in page_vma_mapped.c,
>> pvmw->pfn and pvmw->nr_pages are used in conjunction, and pvmw->pgoff
>> and pvmw->nr_pages (in vma_address_end()) are used in conjunction,
>> cancelling out the increment and decrement in the respective fields. But
>> let us not rely on the pvmw implementation and keep this simple.
> 
> This isn't simple...
> 
>>
>> Export this function to rmap.h to enable future reuse.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  include/linux/rmap.h | 10 ++++++++++
>>  mm/rmap.c            |  8 +++-----
>>  2 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> index 8dc0871e5f001..1b7720c66ac87 100644
>> --- a/include/linux/rmap.h
>> +++ b/include/linux/rmap.h
>> @@ -892,6 +892,16 @@ static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
>>  		spin_unlock(pvmw->ptl);
>>  }
>>
>> +static inline void page_vma_mapped_walk_jump(struct page_vma_mapped_walk *pvmw,
>> +		unsigned int nr)
> 
> unsigned long nr_pages... 'nr' is meaningless and you're mixing + matching types
> for no reason.
> 
>> +{
>> +	pvmw->pfn += nr;
>> +	pvmw->nr_pages -= nr;
>> +	pvmw->pgoff += nr;
>> +	pvmw->pte += nr;
>> +	pvmw->address += nr * PAGE_SIZE;
>> +}
> 
> I absolutely hate this. It's extremely confusing, especially since you're now
> going from looking at 1 page to nr_pages - 1, jump doesn't really mean anything
> here, you're losing sight of the batch size and exposing a silly detail to the
> caller, and I really don't want to 'export' this at this time.
> 
> If we must have this, can you please make it static in rmap.c at least for the
> time being.
> 
> Or perhaps instead, have a batched variant of page_vma_mapped_walk(), like
> page_vma_mapped_walk_batch()?
> 
> I think that makes a lot more sense...
> 
> I mean I kind of hate the pvmw interface in general, this is a hack to handle
> batching clamped on to the side of it, let's figure out how to do this sensibly
> and do what's needed rather than adding yet more hacks-on-hacks please.
> 
>> +
>>  /**
>>   * page_vma_mapped_walk_restart - Restart the page table walk.
>>   * @pvmw: Pointer to struct page_vma_mapped_walk.
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index a7570cd037344..dd638429c963e 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1953,9 +1953,6 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>  	if (pte_unused(pte))
>>  		return 1;
>>
>> -	if (userfaultfd_wp(vma))
>> -		return 1;
>> -
>>  	/*
>>  	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>>  	 * upgrading write permissions for ptes that were not originally
>> @@ -2235,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  		 * we may want to replace a none pte with a marker pte if
>>  		 * it's file-backed, so we don't lose the tracking info.
>>  		 */
>> -		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
>> +		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
>>
>>  		/* Update high watermark before we lower rss */
>>  		update_hiwater_rss(mm);
>> @@ -2359,8 +2356,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  		 * If we are sure that we batched the entire folio and cleared
>>  		 * all PTEs, we can just optimize and stop right here.
>>  		 */
>> -		if (nr_pages == folio_nr_pages(folio))
>> +		if (likely(nr_pages == folio_nr_pages(folio)))
> 
> Please don't add random likely()'s based on what you think is likely(). This
> kind of thing should only be done based on profiling.

Okay.

> 
>>  			goto walk_done;
>> +		page_vma_mapped_walk_jump(&pvmw, nr_pages - 1);
> 
> (You're now passing a signed long to an unsigned int...!)

Will fix all instances of nr_pages to unsigned long.

> 
> 
>>  		continue;
>>  walk_abort:
>>  		ret = false;
>> --
>> 2.34.1
>>
> 
> Thanks, Lorenzo


