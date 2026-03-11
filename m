Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F549FD88FF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC0E6B0005; Wed, 11 Mar 2026 01:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D396B0089; Wed, 11 Mar 2026 01:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555546B008A; Wed, 11 Mar 2026 01:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 333776B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:42:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C84651A05F4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:42:35 +0000 (UTC)
X-FDA: 84532687470.17.F11D442
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id DE179A0007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:42:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773207754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TPWL8IHakCDrGk4GrX5mt90fMBK5Itw2smcu/YkJV70=;
	b=nzMgSVkFQso5zvDXKOFBjaic8v9iWsfLhQn5NocisHFqCdkRaxZIN/dEmS/I4KGoS9eFRT
	yO3JXWBzwwe6+p8sag/3RtNyYHH4c4urasScxZrKZUYKBLTi4O0sjSRjx8xC7XOfdNHN+l
	NNBjm74fpzJ7xmVugn1n9Eq35ywuvZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773207754; a=rsa-sha256;
	cv=none;
	b=fpIKTbPstMCEitijXByxVVdMMRXMIQU7A0vXKC3mPOMtEib1pzAxnkdFYPcbHfzm0ZHVfh
	LlMdjR3zEYm4IKizJ5KhzhDDiR2e6KOmg7sRYspvQQmCibnvunG9/HCI3leIvvdaZmBHAM
	0vmFDoH6B9kgxDWS2L/pbfp5O2vlC+w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77595165C;
	Tue, 10 Mar 2026 22:42:26 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB7473F7BD;
	Tue, 10 Mar 2026 22:42:24 -0700 (PDT)
Message-ID: <26631dbf-1a3e-4d30-9a07-ff64319cbf2f@arm.com>
Date: Wed, 11 Mar 2026 11:12:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] mm/swapfile: Make folio_dup_swap batchable
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
 <20260310073013.4069309-7-dev.jain@arm.com>
 <18928285-20c6-4cd9-842f-c0aef91421a2@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <18928285-20c6-4cd9-842f-c0aef91421a2@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE179A0007
X-Stat-Signature: tx8j816ti8i5or7wefd454ca4x8r39zw
X-Rspam-User: 
X-HE-Tag: 1773207753-754859
X-HE-Meta: U2FsdGVkX18sCPTY5PRuF/+u477H90aSSheHDzN97h4yj5lkTgtzul8cnfqpQhRTIy3Nu2EKEk8NiRwwBEDEotTdsKr+zZMGWLW/ma9lMhvjVBS8eOigBU6gzbvkcq/DF45mWTvDRZK4it5owhR1dMdpPIzgMsxDFtYUI2DoIksTbXb+ybmdekxeQ9nPGYP7SMrl96eYh0m15RqTkL93y9G39Aw+MduIGhhZIdulSQ6iVlAByBGlsXoRZrCflZZHMTxmIoW3p/QUxxE1h9n3W+S0bsY32SuqhZs0pSLL1ltnK0VFeuOEwQjOMK2EhKSsvI+1zji1kOKpbrsJmaALvtFzwULINFp/I/ZYAUxRne1FiHR4CPEdp59YOWCheg3yHSwfBg4HIEBRLvxdHSAY9976/zX/Q8XvkV8O6UE2/KYglxZgqj5dOrQWXBxVUhuX65U0Bu/emBT9SJXz2desZiIdkHF6/EAvFPr2mb49FORNjluaBioIraeYAx2VxUq6ExJvNjvgKQXwfLe6kQrxQr+0E9HUHdgPFOtVn3tbTCP6s8jEcibdRHLo1sApDLlANfmeokKSmjfGFyTpTUmrZIMkiPNc7oF2nmcZYsbiyI2eq6/fampvY8dU8NiygO/w1FLLB+pnOavzxyfSL7qMI5aYj1MHkqvN13Y6lD0wlDtYrvWQyQk8qABEU9ZaKKiLOL8rsk4gz4d+WEJkuA82WUe3vWiWLy+PJ3lGmNKha/JBfFwnIpcHdMspvt67+7yMhzpDuATdobNaUeDi00uqOyl5nh2PaPNL+PFGhtibAEVcCqJtF9D+7VBgpZS/FjYbB8kcqfe2yTT8j1RRANqx5QmtOzxBBDbSc6bpt1SC03LB2vGjKNR528gGcHIIMzmM0Eb65OpBo1Hjexj/9Qprb2H3+0J5EJv/yQWG4ekB2hS5fGsW/17ERpzObgHMj0vBKkRHHKyO5HsqaKpUfMW
 FjwacPwA
 D3roSHHvpRVgkkbenPQAQG7r50OPz1EXAD473JGvLFI98T5uZFEVQB/5dYfKQUHFBDNx0megHYZfFcKgYDzoQtpcyNyTmaJ/VegmEypKcdwbZcpU4U2nhS0Q3lLPMwZmHo/pp8fXIjYHmASJ+xa9sI0GpvH7OxOj5kjqdZMs8Kh1TtCtq/DPFbnHlJRlezbqMaqO8ng0gPl3YbxIRW5rKxd8ZClSB5KfN+hTUr8byb4k8LzoDpIMx6OKfZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 2:19 pm, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 10, 2026 at 01:00:10PM +0530, Dev Jain wrote:
>> Teach folio_dup_swap to handle a batch of consecutive pages. Note that
>> folio_dup_swap already can handle a subset of this: nr_pages == 1 and
>> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
>>
>> Currently we have a not-so-nice logic of passing in subpage == NULL if
>> we mean to exercise the logic on the entire folio, and subpage != NULL if
>> we want to exercise the logic on only that subpage. Remove this
>> indirection, and explicitly pass subpage != NULL, and the number of
>> pages required.
> 
> You've made the interface more confusing? Now we can update multiple subpages
> but specify only one? :)
> 
> Let's try to actually refactor this into something sane... see below.
> 
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c     |  2 +-
>>  mm/shmem.c    |  2 +-
>>  mm/swap.h     |  5 +++--
>>  mm/swapfile.c | 12 +++++-------
>>  4 files changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index dd638429c963e..f6d5b187cf09b 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2282,7 +2282,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  				goto discard;
>>  			}
>>
>> -			if (folio_dup_swap(folio, subpage) < 0) {
>> +			if (folio_dup_swap(folio, subpage, 1) < 0) {
>>  				set_pte_at(mm, address, pvmw.pte, pteval);
>>  				goto walk_abort;
>>  			}
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 5e7dcf5bc5d3c..86ee34c9b40b3 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1695,7 +1695,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>  			spin_unlock(&shmem_swaplist_lock);
>>  		}
>>
>> -		folio_dup_swap(folio, NULL);
>> +		folio_dup_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
>>  		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
>>
>>  		BUG_ON(folio_mapped(folio));
>> diff --git a/mm/swap.h b/mm/swap.h
>> index a77016f2423b9..d9cb58ebbddd1 100644
>> --- a/mm/swap.h
>> +++ b/mm/swap.h
>> @@ -206,7 +206,7 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>>   */
>>  int folio_alloc_swap(struct folio *folio);
>> -int folio_dup_swap(struct folio *folio, struct page *subpage);
>> +int folio_dup_swap(struct folio *folio, struct page *subpage, unsigned int nr_pages);
>>  void folio_put_swap(struct folio *folio, struct page *subpage);
>>
>>  /* For internal use */
>> @@ -390,7 +390,8 @@ static inline int folio_alloc_swap(struct folio *folio)
>>  	return -EINVAL;
>>  }
>>
>> -static inline int folio_dup_swap(struct folio *folio, struct page *page)
>> +static inline int folio_dup_swap(struct folio *folio, struct page *page,
>> +				 unsigned int nr_pages)
>>  {
>>  	return -EINVAL;
>>  }
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index 915bc93964dbd..eaf61ae6c3817 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -1738,7 +1738,8 @@ int folio_alloc_swap(struct folio *folio)
>>  /**
>>   * folio_dup_swap() - Increase swap count of swap entries of a folio.
>>   * @folio: folio with swap entries bounded.
>> - * @subpage: if not NULL, only increase the swap count of this subpage.
>> + * @subpage: Increase the swap count of this subpage till nr number of
>> + * pages forward.
> 
> (Obviously also Kairui's point about missing entry in kdoc)
> 
> This is REALLY confusing sorry. And this interface is just a horror show.
> 
> Before we had subpage == only increase the swap count of the subpage.
> 
> Now subpage = the first subpage at which we do that? Please, no.
> 
> You just need to rework this interface in general, this is a hack.
> 
> Something like:
> 
> int __folio_dup_swap(struct folio *folio, unsigned int subpage_start_index,
> 		     unsigned int nr_subpages)
> {
> 	...
> }
> 
> ...
> 
> int folio_dup_swap_subpage(struct folio *folio, struct page *subpage)
> {
> 	return __folio_dup_swap(folio, folio_page_idx(folio, subpage), 1);
> }
> 
> int folio_dup_swap(struct folio *folio)
> {
> 	return __folio_dup_swap(folio, 0, folio_nr_pages(folio));
> }
> 
> Or something like that.


I get the essence of the point you are making.

Since most callers of folio_put_swap mean it for entire folio, perhaps
we can have folio_put_swap for these callers, and the ones which are
not sure can call folio_put_swap_subpages? Same for folio_dup_swap.
And since we are calling it folio_put_swap_subpages, we can retain
the subpage parameter?

> 
> We're definitely _not_ keeping the subpage parameter like that and hacking on
> batching, PLEASE.
> 
>>   *
>>   * Typically called when the folio is unmapped and have its swap entry to
>>   * take its place: Swap entries allocated to a folio has count == 0 and pinned
>> @@ -1752,18 +1753,15 @@ int folio_alloc_swap(struct folio *folio)
>>   * swap_put_entries_direct on its swap entry before this helper returns, or
>>   * the swap count may underflow.
>>   */
>> -int folio_dup_swap(struct folio *folio, struct page *subpage)
>> +int folio_dup_swap(struct folio *folio, struct page *subpage,
>> +		   unsigned int nr_pages)
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
>> +	entry.val += folio_page_idx(folio, subpage);
>>
>>  	return swap_dup_entries_cluster(swap_entry_to_info(entry),
>>  					swp_offset(entry), nr_pages);
>> --
>> 2.34.1
>>
> 
> Thanks, Lorenzo


