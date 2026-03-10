Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1151FCC9DB
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EFDD6B008C; Tue, 10 Mar 2026 04:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C46F6B0092; Tue, 10 Mar 2026 04:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7166B0093; Tue, 10 Mar 2026 04:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF7C26B008C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:50:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 804C388E11
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:50:16 +0000 (UTC)
X-FDA: 84529531632.27.B2B2FC8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90C4B18000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:50:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773132614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pFtYnp02cguLN7jzQawh5ValF68OK9G0qnxxVk8SPLg=;
	b=z9wkC4+QKZb6WlxHy7xc1IECrFv7LOf5NlqXg7OPUVJ5p6hQbq6QrSSlBkWrEN0Wki/riW
	9EWuBeEeYSzMsaZTUU+y19AejT0inRU7rtGtFKWVgICKMhynD8UcRJ5vmNzUP46o9nV6yK
	a2LjOkKHaGgLAFpm8klAsTiQOHo3iVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773132614; a=rsa-sha256;
	cv=none;
	b=NNtFIMw3yJS5HmxbViZFstETItPu9AeApT3Gwr23nA11GH4V28hAvb7DHswy5BY3TO+hUw
	xvuwZUgAD53wkhr/t087XZ+ROJB4HputyTjl00fskEyGAqOy6isuCiUPT5pxkHz+yUzBxG
	rU7v51CwpekMYgOqWuYS5wxHBkR7auc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CB9B169C;
	Tue, 10 Mar 2026 01:50:07 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02EFD3F7BD;
	Tue, 10 Mar 2026 01:50:04 -0700 (PDT)
Message-ID: <373b96e7-fda3-4ea2-8089-521dba064307@arm.com>
Date: Tue, 10 Mar 2026 14:20:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] mm/swapfile: Make folio_put_swap batchable
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 david@kernel.org, hughd@google.com, chrisl@kernel.org, weixugc@google.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com,
 jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org,
 willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-8-dev.jain@arm.com>
 <CAMgjq7Dhjvg2tNbESyCqaEo9OrmWhdeTHyXiuyTzoTWcDRX+ag@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAMgjq7Dhjvg2tNbESyCqaEo9OrmWhdeTHyXiuyTzoTWcDRX+ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 90C4B18000F
X-Stat-Signature: erp4aopktw6jpwgdym4ygjwktxxer9ze
X-Rspam-User: 
X-HE-Tag: 1773132614-532736
X-HE-Meta: U2FsdGVkX1+ArhlSqhp6vDUrsGbJ2bEfE5cNSM0tvpHNdSLjNc5bQA8qTCEULulu6A3p4rXpCCx4ujqWJazHN0IiLKxBoRwW0A37/uaP7kHxB1cQbLsp1Lgzf0/2strZz4JOFFmnX4Se+nINkCEGjr1bS6iAcdgRs7lkoyRAB8vA75/QR2KN3ESczB9OVFCbUsaNtHrzXnHnM51Z9jGr1hry+j1ImG9JWLmUQx41wkKxq+sovpAloSH4enYZ/o0HIuxMfKRly6l9UGbpAwr6IuCowXEGLnfm1+hrQkAetALAb9xfxiLrBk8Q5qc4wvTzfCgkZ/afq++e+Kt0OQc5fy2CY0BpuyDM8wGNWXuszv6qHbQtvVClLVahymb8K6I87QM0z150SwURW4xjAhvA12AKrffTFhlt1Q0+mvMRduHBZIc66EWNQf7XRODXiJX6I1+iqHPqkg8UmfxZve5hexw3+m9o5fqcAoABefHFO59VdxvLJa18TW/NTkcXtciEik3HwwW0Q5RxEicoEHAmI0IdMqhkgFb6ygq/mU/WxxOwHP70mf4B8/nRe673kwMIbF9dgJ/hfXi4Y9YJxnfcnooAvEXuS3wnHT/pXVYWurojSskbFVhGGN3OOtLoUR9roi+bSXFaxWUkl+chDEqxrOY3Ta+gP5mxLG3kfdjm3G/0WmiizrML3UrvuvtUgf3qXgx8R57dnigMKBdf01BTaG24uxp/LWBPjx5bDLA7Xj+RrQ4Y5jwdVSLSqtS298i+ZlsDv18p6xjFz3ptvELEmFAri8Q0JqChrHjPPI49Zq8qKgBj+eVBZVoGu9dPuowr9GLJGcY4l2LvEcrorYh9CSC0EKy/s4QAA3kkcjF9xN7jsKW2QtjlLje9SVSo3ORafIdfbdhdQd4kpPOttzazmoX9sGNEuZxR7jyEtSg5VdqTVZe5osqCSm5cnCob2+pW6xq/uof3ugSnKszBnBy
 VwHkwPBL
 4jM4u5yXda8lZRGgFpYLix44dRE/eYzptdcrfGe/El0gzYfGu9Rg0egPWxTWAZuVPHhHn8pZxY90jmBpkaPcOLAjtsDz+vS+rpVLnhx6lpxhqkHNFl0nKAe826iPumbG7amg6gbHO/MPa6QHdBhoKHyxi8O53b8pn1rA1sMepAO0r1zHw6RY3tFpkVSFqfXs7YnXh894PTBKpDSCubs4UGOkpkh7oKK3Mvd4LguNFHzis/r/ZCacGzuatKgZM0f8S9/T3cyhJv2wTYqd3ljndGfGcz2XLcOtHiGmlgVhnlMYWPmUA7XKUcIlKbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 1:59 pm, Kairui Song wrote:
> On Tue, Mar 10, 2026 at 3:47 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> Teach folio_put_swap to handle a batch of consecutive pages. Note that
>> folio_put_swap already can handle a subset of this: nr_pages == 1 and
>> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
>>
>> Currently we have a not-so-nice logic of passing in subpage == NULL if
>> we mean to exercise the logic on the entire folio, and subpage != NULL if
>> we want to exercise the logic on only that subpage. Remove this
>> indirection, and explicitly pass subpage != NULL, and the number of
>> pages required.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/memory.c   |  6 +++---
>>  mm/rmap.c     |  4 ++--
>>  mm/shmem.c    |  6 +++---
>>  mm/swap.h     |  5 +++--
>>  mm/swapfile.c | 13 +++++--------
>>  5 files changed, 16 insertions(+), 18 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 768646c0b3b6a..8249a9b7083ab 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5002,7 +5002,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>         if (unlikely(folio != swapcache)) {
>>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
>>                 folio_add_lru_vma(folio, vma);
>> -               folio_put_swap(swapcache, NULL);
>> +               folio_put_swap(swapcache, folio_page(swapcache, 0), folio_nr_pages(swapcache));
>>         } else if (!folio_test_anon(folio)) {
>>                 /*
>>                  * We currently only expect !anon folios that are fully
>> @@ -5011,12 +5011,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>                 VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
>>                 VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>>                 folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
>> -               folio_put_swap(folio, NULL);
>> +               folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
>>         } else {
>>                 VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
>>                 folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
>>                                          rmap_flags);
>> -               folio_put_swap(folio, nr_pages == 1 ? page : NULL);
>> +               folio_put_swap(folio, page, nr_pages);
>>         }
>>
>>         VM_BUG_ON(!folio_test_anon(folio) ||
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index f6d5b187cf09b..42f6b00cced01 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2293,7 +2293,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>                          * so we'll not check/care.
>>                          */
>>                         if (arch_unmap_one(mm, vma, address, pteval) < 0) {
>> -                               folio_put_swap(folio, subpage);
>> +                               folio_put_swap(folio, subpage, 1);
>>                                 set_pte_at(mm, address, pvmw.pte, pteval);
>>                                 goto walk_abort;
>>                         }
>> @@ -2301,7 +2301,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>                         /* See folio_try_share_anon_rmap(): clear PTE first. */
>>                         if (anon_exclusive &&
>>                             folio_try_share_anon_rmap_pte(folio, subpage)) {
>> -                               folio_put_swap(folio, subpage);
>> +                               folio_put_swap(folio, subpage, 1);
>>                                 set_pte_at(mm, address, pvmw.pte, pteval);
>>                                 goto walk_abort;
>>                         }
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 86ee34c9b40b3..d9d216ea28ecb 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1716,7 +1716,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>                 /* Swap entry might be erased by racing shmem_free_swap() */
>>                 if (!error) {
>>                         shmem_recalc_inode(inode, 0, -nr_pages);
>> -                       folio_put_swap(folio, NULL);
>> +                       folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
> 
> I just realized that we already have a nr_pages variable available
> here, maybe you can just use that?
> 
> Feel free to ignore this if it might touch more code.
> 
>>                 }
>>
>>                 /*
>> @@ -2196,7 +2196,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
>>
>>         nr_pages = folio_nr_pages(folio);
>>         folio_wait_writeback(folio);
>> -       folio_put_swap(folio, NULL);
>> +       folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
>>         swap_cache_del_folio(folio);
>>         /*
>>          * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
>> @@ -2426,7 +2426,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>         if (sgp == SGP_WRITE)
>>                 folio_mark_accessed(folio);
>>
>> -       folio_put_swap(folio, NULL);
>> +       folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
> 
> Same here, nr_pages seems good enough?

Yup, thanks for your observation.



