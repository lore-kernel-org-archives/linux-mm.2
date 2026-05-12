Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 473FDCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E28C6B0093; Tue, 12 May 2026 02:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B99D6B0095; Tue, 12 May 2026 02:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7C16B0096; Tue, 12 May 2026 02:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4796B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:07:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2A6A402B6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:07:41 +0000 (UTC)
X-FDA: 84757736322.04.E4B9E80
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D92791C0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:07:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IWhIlYkj;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6YerbKGy0Izs+egO8DEPz7wuzPVQ9+S1p98108jEdE=;
	b=ImzCkmHudKMjBh1GXYbGj1imcjYrchDiMJwPjIfys2xGwk4yIkMdpAOXQ5bi2YKnDDaj61
	YqQcuJq/5WJRNDfLGk4CrAzAbTym7p5yREzzpSVfau5pxozwRlBQMYQqqsT21oTB5YypVp
	zxbEpSNvreOiPe5QwDR3R3JpSXgMAig=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IWhIlYkj;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566060; a=rsa-sha256;
	cv=none;
	b=cwDQWSYOGsHfUtO7o5+RgXOrfaFagKzzhYa7NtxJjhTuIDMTXtzL/S1aC8mX9r9QYzsI8i
	yWDWLrokofwgX39pDP0LU28Da42rL8HCuVhtvPWW08AlPy21FEOt+Sxb5ZHjTitQxuK4IY
	K8abO3I2h+ADbnK4BZ7WyTq92YG1RQo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 046FF14BF;
	Mon, 11 May 2026 23:07:33 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 411C93F7B4;
	Mon, 11 May 2026 23:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778566058; bh=9zpM7qKKZXHe+FhT3iNnsFsnYglQawNj7Jl2iPY8FuA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IWhIlYkj7qNFhRubazVtb962dfKqnU2ziInLb4tN7UYp7Hl7nyngsQcBnhGDGguFq
	 XmaF/P/+IEsuAkSLQbfDDPIL4G2uMibNEWgoDXJ/pS5fblp7xo/P7MrMZ5zhOOuzxW
	 wuHy84WGrIwj+NvKRBvFPW4TMUNcD+jC71uUiIEg=
Message-ID: <72d09e59-47f9-4faf-8cd9-0d168895a4c0@arm.com>
Date: Tue, 12 May 2026 11:37:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] mm/swapfile: Add batched version of folio_dup_swap
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-7-dev.jain@arm.com>
 <871d9a91-2d14-4dbb-934d-b52c12dae7cd@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <871d9a91-2d14-4dbb-934d-b52c12dae7cd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D92791C0005
X-Stat-Signature: iybynktppy8fb7fbzu4dwwrcjrkac1es
X-HE-Tag: 1778566059-366772
X-HE-Meta: U2FsdGVkX1/+7NY1xcx2P1/49jVFPhSqApz3YgVsMlSRCg2gb7cGdV6ePNZOCjZOXM09C+vGMb/I7dwB3qbUx+0L6czCny/PsjDJ+JENTsHCWf210hRRjcJx02nbi4TtCObfa9hdhPBG/03eyG8Y/j75CCuAhNGhIi29uxdXr3Ko7jFumJCQCd/v2RKbgzHi0FtJEdI7jb8JWXVATqu24onPSU/ptQoL+HIjGutbCEeSZrURX5kYTUhDPE8ALAdY0a/DZdQV2TjPqyIyY6isyv3k18TSqO1XWZtXk+MK0LfBCW79lHxKoISIYHzRuOlIM7uYaexGCaxQG0A1wfRNR75WeumLiAAnaGbpprIRXidvRaGSB50ke8AtnxkaV9WXHUvP1xjpBFDXw6qYzSg6Pq82hO+WAXGBXRCtuc4GFB36a/h7cw1S/e0nDe2XkQw+8/1qs24oH6clJRi1IJWTpzQkvNtJB0Bp9zcUOsj4cKnE1XEgRiDoFno/1UQ/Fq3M39aOD9GtKrmwUeqq4tp35KyXQAbNkSPBFSLX59sH1XJqWerrbxdjbDoLbt3A4tUlzd5BY9iIP880D1A+pg//ze75ywGz3IqBDgChIfQhMzCaleAdnKOfTdDu0ljMkd8sy7Ria2ZFYi4W/cgFJ8LOavomK7SvhyHm0sjCV/YWoc2dG1wvYMu3vK9hhMquBckYYiQYKLp+O6//kB+kgro4J8Jft1nxTDtWgqidMA4b7VfNEWEh3FiPwKi9MU1jb4OTCYmn2ViwePDzlkvHbrbs3Ehmwss9Ifdy5cA3EvToYj6l1NUm23vzFWlQEIy3aIBgKH8vDo3OvYnwxxshTSfmYCq/Q97VHKJnfwnfSVnPJ7KcRodl3mEzmmIk0RG1+HFwUjMLiN/SDkgXs1qId4EwI9MSxGHfQ8no8SLAJli0D7BssysgQMRfFFGeoo2O3nwmUCvuC0cxbnkl2/jQPLT
 YSqJAj1E
 D7xdNLfwrVDMOjKG7phqZHkpqw0Ha7MmnH7hirbrU0YixxmOKp4LZKNTNYTnTMqnYzp9S4jdGy8XXJtT1oFdRVu077XrVW9DiP16MdxgYwJIOYvTH++AQdQOV9g/I+lqndmuJKfCXSHpQV6FQ+V0/CSGG6vnDXcFVuZPSs8d9FrRS3HeYZ16vOqQcAzxVjZ88LqJVjU1OQvfV8AFeAI8C22j0Hdp4WBiy7Crn+NRVz9tEnSCF36qIVSRtd2UjRuARPYD5Se7AZ5nIcscxqp4xPmLxBVw+lSzXGkGrOPnOADtyy4S9fKnz52SbWx7Of9iokfljWCoOBc1lKp7VRvc8o+sgsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 1:15 pm, David Hildenbrand (Arm) wrote:
> On 5/6/26 11:45, Dev Jain wrote:
>> Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
>> that folio_dup_swap already can handle a subset of this: nr_pages == 1 and
>> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
>>
>> Currently we have a not-so-nice logic of passing in subpage == NULL if
>> we mean to exercise the logic on the entire folio, and subpage != NULL if
>> we want to exercise the logic on only that subpage. Remove this
>> indirection: the caller invokes folio_dup_swap_pages() if it wants to
>> operate on a range of pages in the folio (i.e nr_pages may be anything
>> between 1 till folio_nr_pages()), and invokes folio_dup_swap() if it
>> wants to operate on the entire folio.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c     |  2 +-
>>  mm/shmem.c    |  2 +-
>>  mm/swap.h     | 12 ++++++++++--
>>  mm/swapfile.c | 20 ++++++++++++--------
>>  4 files changed, 24 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 25813e3605991..352ba77d90f67 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2314,7 +2314,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  				goto finish_unmap;
>>  			}
>>  
>> -			if (folio_dup_swap(folio, subpage) < 0) {
>> +			if (folio_dup_swap_pages(folio, subpage, 1) < 0) {
> 
> Can you throw in a patch to rename subpage -> page first?

Sure.

> 
>>  				set_pte_at(mm, address, pvmw.pte, pteval);
>>  				goto walk_abort;
>>  			}
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index bab3529af23c5..5e4f521399847 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1698,7 +1698,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>  			spin_unlock(&shmem_swaplist_lock);
>>  		}
>>  
>> -		folio_dup_swap(folio, NULL);
>> +		folio_dup_swap(folio);
>>  		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
>>  
>>  		BUG_ON(folio_mapped(folio));
>> diff --git a/mm/swap.h b/mm/swap.h
>> index a77016f2423b9..3c25f914e908b 100644
>> --- a/mm/swap.h
>> +++ b/mm/swap.h
>> @@ -206,7 +206,9 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>>   */
>>  int folio_alloc_swap(struct folio *folio);
>> -int folio_dup_swap(struct folio *folio, struct page *subpage);
>> +int folio_dup_swap(struct folio *folio);
>> +int folio_dup_swap_pages(struct folio *folio, struct page *page,
>> +			 unsigned long nr_pages);
>>  void folio_put_swap(struct folio *folio, struct page *subpage);
>>  
>>  /* For internal use */
>> @@ -390,7 +392,13 @@ static inline int folio_alloc_swap(struct folio *folio)
>>  	return -EINVAL;
>>  }
>>  
>> -static inline int folio_dup_swap(struct folio *folio, struct page *page)
>> +static inline int folio_dup_swap(struct folio *folio)
>> +{
>> +	return -EINVAL;
>> +}
>> +
> 
> Much cleaner.
> 
> Can we have a common folio_dup_swap() function instead that does what the
> variant below does? (call folio_dup_swap_pages())

I am guessing you are saying to simply remove the folio_dup_swap stub because
we have a stub for folio_dup_swap_pages anyways, I'll do that.

> 
>> +static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
>> +		unsigned long nr_pages)
>>  {
>>  	return -EINVAL;
>>  }
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index c7e173b93e11d..28daf92839e77 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -1740,9 +1740,10 @@ int folio_alloc_swap(struct folio *folio)
>>  }
>>  
>>  /**
>> - * folio_dup_swap() - Increase swap count of swap entries of a folio.
>> + * folio_dup_swap_pages() - Increase swap count of swap entries of a folio.
>>   * @folio: folio with swap entries bounded.
>> - * @subpage: if not NULL, only increase the swap count of this subpage.
>> + * @page: the first page in the folio to increase the swap count for.
>> + * @nr_pages: the number of pages in the folio to increase the swap count for.
>>   *
>>   * Typically called when the folio is unmapped and have its swap entry to
>>   * take its place: Swap entries allocated to a folio has count == 0 and pinned
>> @@ -1756,23 +1757,26 @@ int folio_alloc_swap(struct folio *folio)
>>   * swap_put_entries_direct on its swap entry before this helper returns, or
>>   * the swap count may underflow.
>>   */
>> -int folio_dup_swap(struct folio *folio, struct page *subpage)
>> +int folio_dup_swap_pages(struct folio *folio, struct page *page,
>> +		unsigned long nr_pages)
>>  {
>>  	swp_entry_t entry = folio->swap;
>> -	unsigned long nr_pages = folio_nr_pages(folio);
>>  
>>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>>  	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
>>  
>> -	if (subpage) {
>> -		entry.val += folio_page_idx(folio, subpage);
>> -		nr_pages = 1;
>> -	}
>> +	entry.val += folio_page_idx(folio, page);
>>  
>>  	return swap_dup_entries_cluster(swap_entry_to_info(entry),
>>  					swp_offset(entry), nr_pages);
>>  }
>>  
>> +int folio_dup_swap(struct folio *folio)
>> +{
>> +	return folio_dup_swap_pages(folio, folio_page(folio, 0),
>> +				    folio_nr_pages(folio));
>> +}
> 
> Can you add simplistic kerneldoc for folio_dup_swap() as well, and mostly just
> link to folio_dup_swap_pages() ?

Okay.

> 


