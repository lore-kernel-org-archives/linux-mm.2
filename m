Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC088C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 09:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715276B007B; Sat, 25 Jul 2026 05:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7176B0088; Sat, 25 Jul 2026 05:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5BD6B008A; Sat, 25 Jul 2026 05:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 288EA6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:40:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96778C0259
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 09:40:31 +0000 (UTC)
X-FDA: 85026803862.01.3480DC7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6F26320005
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 09:40:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="YFWn/ySZ";
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784972429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHA8P7kRLT1NS4gl6vbrYN3lxv6i1SjPtVoTSYTfhmU=;
	b=uzlyoe33p9whu1gF4gxxqcXrn3qZdcYpX53TZmW2Ka6I27ps2wjaiTCxoLfeQ9czgtxuWj
	ndCRJEELIAIFsF/894w7NpDoP4qDFwW/5fUXetd4QV9ZDv0MRx1MpoMsaPg32nq3Sxfcem
	C0a0V/qeW7IIhLNaOeOMQtEMP5PoQDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784972429;
	b=PGkudu0h/WllvG8SCCkByaUSRccjJ5lVqBoQXBGAxCmuFBnyamAESu5NMaqBpsbppJm9sN
	fqAKE+6iB5tNBfqT+/IHINPLOpDhlFe4IiKHP5kJ87o6NhqBqr7ZH9rmm5HnP4hcDECq//
	68Jgfq9RnD0tGXEq7HyLCogYQlkKNyY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="YFWn/ySZ";
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2C051476;
	Sat, 25 Jul 2026 02:40:23 -0700 (PDT)
Received: from [10.164.11.99] (unknown [10.164.11.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 354C13F86F;
	Sat, 25 Jul 2026 02:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784972427; bh=65XZfVffm0RKIEz/C/W4KYgIhSA+aKRV1kbxBpLGH2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YFWn/ySZO34odXGS/hZ1LontckFFcbvMpjRBnIwfDoI3NeZWo2FNmR+tpF9Y7a/XA
	 nEfYNUG/lkdpGiI5wlQcit1T5EekH56T8vxmT7HQb/7eNX1yJz3+Cd2EKmiFW9A9OT
	 PCj9HcbMc/0P0H4HpZCdWWUkRJCupOSFRj4yo3A4=
Message-ID: <fd898e51-2b97-4ac8-98fc-0398d3778796@arm.com>
Date: Sat, 25 Jul 2026 15:10:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] mm/swapfile: add batched version of folio_put_swap
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260723070905.3422276-1-dev.jain@arm.com>
 <20260723070905.3422276-3-dev.jain@arm.com>
 <CAGsJ_4wyRz01Z+Zv6RdiRJabsBm+0+obsqOW7v-h03OOzHcx+g@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4wyRz01Z+Zv6RdiRJabsBm+0+obsqOW7v-h03OOzHcx+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6F26320005
X-Stat-Signature: h6g3cbm6mwgfesmg19erxu6riegujohn
X-Rspam-User: 
X-HE-Tag: 1784972429-75933
X-HE-Meta: U2FsdGVkX1+6i3TkRi6+NjIcirzRqhgVsywZ4CblOWPzCHSg4RO8OT8RQ9wIbRe2xa7tQFH7fA9BJC5ko7v7rUw1WaVYKXQQL9G37ODljy8UgC/avhviinfKQ4TTeJPM1JqagOEBeAQnsEKDMU1yAILLiFK7X7js0+fw4/W9pypJ6qTFDWhwqt0ekSJKd1t3ddjnlB8jPqngEPHsGrRkxmYPl/UHxaY3yUH/pbFoDzYWJCYXztdlNkZmiLAPqtK0V0B/qNuXTo3btwzL5Sss3VfaIH1F1AKPoEqbSuQS/37t/oERax8cofKuRKLQItBcVARz3OYBA8cgXbnVJ2yRtqFNJRAe8Aa84EcmOVWe3x2wBQ6Tif0wKTu8OyY2DbnIWBFXFcfAJ2JqRflwnF6GWQXBdDJGk9J6Kc9g4E2M5nk/HGK7OpugvuXquXcvfwtdBZYye+AF9lmg9lfqY/OR+7lBi9L55hWgbDcfryneF6twJaardFyX7xt9ygqGfRqSRXtzhzUjrg2rN1ZczH5VkhAzC8f7v6CTJz3UWVGym2A2bbcuRM3NpTvJoXJqKxJXHBtgz7hohbsWt0ONDDePqBpHKc2Po0NEmaXHVOxQ+zWVNuuXpNHs3WGUPpyRGcg4AQqBGxKEauHvzZ31ZqdJZj3y5bqja4vnyeffOJ4X3Cf/nfj/xAPDf6YtiFzCdJWBu01Uvv8Bwk7OeeS4vC6Wgu5hXE+QdVYJJQ8QMnKn92RQi+pualK1mIqTQzx6OIGQbfpl09ttl4kk1oVCE08+bvKsprPtFHkiIeMt+pLN31Nwk+hf0b6OJSY9d7BOgMWBKyiQ2QkgLWpMjK2XV8426yqPdTQa4YW3CC3EDBfVYlqaiv8DS2b52vQ8kPMmkWUck1AjaxLTIIf6/e0m0KjKNq3nr4Q7B1lHTBeNCwNPn1alWVwslfgWdVeEe7nKHeq75/2bJMIwfOT3Kk5DY2P
 EEb+61+D
 DKvsmPjNGX/czuG2P1lvwnL8T/1aG4JKOVBFcljtlBvU1afVVZ6GJwBDzh+8TcwHHqman0fQ+ZQdl0etBrv6c6x2bVWzU8KTIRIII5lHBqcOEFgUZt6umGzquBAAWH3dpNMfN+ZlUdThzG3oPNdZRhMNJzEf+ZDSbLWa3aqHTvJbz9e/ls9puKePc8lf/CsoqM09SGFT5hsTwrtcUIvL+QF1ER6WvRZyggQAzCt0+9+UeDsA/fPLIGrv/rXYxkMuup8c48055FxfBeS8aXRWOc4lM4XCuomlQPSvOnve7GdzNcq9sBaIKDWQUexTh4S3e23JKVOgcOldG+V7X9W0N52OnlldfQaizAMws+rAtpVBPSgTvwHZ7MHQOHDNZ4vHY/cKNNdLAXbim5ok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/07/26 10:23 am, Barry Song wrote:
> On Thu, Jul 23, 2026 at 3:09 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> Add folio_put_swap_pages to handle a batch of consecutive pages. Note
>> that folio_put_swap already can handle a subset of this: nr_pages == 1 and
>> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
>>
>> Currently we have a not-so-nice logic of passing in subpage == NULL if
>> we mean to exercise the logic on the entire folio, and subpage != NULL if
>> we want to exercise the logic on only that subpage. Remove this
>> indirection: the caller invokes folio_put_swap_pages() if it wants to
>> operate on a range of pages in the folio (i.e nr_pages may be anything
>> between 1 and folio_nr_pages()), and invokes folio_put_swap() if it
>> wants to operate on the entire folio.
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks for your review.


> 
> [...]
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index a620d425ec95e..d88df15018268 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5198,7 +5198,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>         if (unlikely(folio != swapcache)) {
>>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
>>                 folio_add_lru_vma(folio, vma);
>> -               folio_put_swap(swapcache, NULL);
>> +               folio_put_swap(swapcache);
>>         } else if (!folio_test_anon(folio)) {
>>                 /*
>>                  * We currently only expect !anon folios that are fully
>> @@ -5207,12 +5207,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>                 VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
>>                 VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>>                 folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
>> -               folio_put_swap(folio, NULL);
>> +               folio_put_swap(folio);
>>         } else {
>>                 VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
>>                 folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
>>                                          rmap_flags);
>> -               folio_put_swap(folio, nr_pages == 1 ? page : NULL);
>> +               folio_put_swap_pages(folio, page, nr_pages);
> 
> Yes. In do_swap_page(), `page` points to the first page of the
> large folio.
>         if (folio_test_large(folio) && folio_test_swapcache(folio)) {
>                 ...
>                 page = &folio->page;
>         }
> 
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -1817,27 +1817,25 @@ int folio_dup_swap_pages(struct folio *folio, struct page *page,
>>  }
>>
>>  /**
>> - * folio_put_swap() - Decrease swap count of swap entries of a folio.
>> + * folio_put_swap_pages() - Decrease swap count of swap entries of a folio.
>>   * @folio: folio with swap entries bounded, must be in swap cache and locked.
>> - * @page: if not NULL, only decrease the swap count of this page.
>> + * @page: the first page in the folio to decrease the swap count for.
>> + * @nr_pages: the number of pages in the folio to decrease the swap count for.
>>   *
>>   * This won't free the swap slots even if swap count drops to zero, they are
>>   * still pinned by the swap cache. User may call folio_free_swap to free them.
>>   * Context: Caller must ensure the folio is locked and in the swap cache.
>>   */
>> -void folio_put_swap(struct folio *folio, struct page *page)
>> +void folio_put_swap_pages(struct folio *folio, struct page *page,
>> +               unsigned long nr_pages)
>>  {
>>         swp_entry_t entry = folio->swap;
>> -       unsigned long nr_pages = folio_nr_pages(folio);
>>         struct swap_info_struct *si = __swap_entry_to_info(entry);
>>
>>         VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>>         VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
>>
>> -       if (page) {
>> -               entry.val += folio_page_idx(folio, page);
>> -               nr_pages = 1;
>> -       }
>> +       entry.val += folio_page_idx(folio, page);
>>
>>         swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
> 
> Maybe a guard against potential overflow would help? also in patch 1?
> 
> idx = folio_page_idx(folio, page);
> 
> VM_WARN_ON_FOLIO(idx + nr_pages > folio_nr_pages(folio), folio);

We had this discussion before and I am struggling to recall that - I think
there are currently both cases, the batched helpers not doing the sanity checking but
documenting it (I haven't documented it in this one, and in set_softleaf_ptes
too, will audit later), or doing the sanity checking.

But I also recall the expectation is that CONFIG_DEBUG_VM is not used in production
kernels, so I can put this in v2.

> 
> Best Regards
> Barry


