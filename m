Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E54C606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f/z4jqrB
Received: by kanga.kvack.org (Postfix)
	id C45836B05B8; Mon, 16 Nov 2026 07:03:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DA36B05B9; Mon, 16 Nov 2026 07:03:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34B16B05BA; Mon, 16 Nov 2026 07:03:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4116B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:03:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AEEE80941
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:03:37 +0000 (UTC)
X-FDA: 85440847674.23.9BB8C2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5609E2000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:03:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/z4jqrB";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794830615;
	b=7muhFmrdSCCqQlSUSJT0S5seJrCTw6SzeHEKxW6ggNDUyRh6InOREiovB9kWVni7/8Nkqt
	a24/wGJklL7qznJaiCktBQXwz2wagsdPZJ5Ppz3xupbnCKPmwTYb6Al4npjHHeAVVKnqQz
	fy87ZuzenrmwT+D8dz2peJA9IqApBBA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/z4jqrB";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794830615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qk7HxbpsztRM/SVPWGewM+JRDnoptO688QVDd7CbAqE=;
	b=ABdVJ8BPE91Fud342zVmxs8uydi84fK4SfbwnqCli+FssCuIJh3E+LOE20iOgVxQK+7OpJ
	QFHeRzq5ssWscKAJtIvs4xDkxHu8AneuaDIIPrBQFYO1gtoH31vqAmyqOBdjlBiuBS7K5P
	kDHys5qGNBs+z/6GCaAWtuKQn59Xtpg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38442430DE;
	Mon, 16 Nov 2026 12:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801BA1F000C4;
	Mon, 16 Nov 2026 12:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830614;
	bh=qk7HxbpsztRM/SVPWGewM+JRDnoptO688QVDd7CbAqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f/z4jqrBq5sw1KBxJGO6AVrcacfvVVHseBi0owkw7PA1Z2mOroNLonZB5FJal9uWN
	 W9x9OPaWlpeNZ48dAgS5EeTyUILFHzRqOwd6rUvdaKmCZEBs10E0oMU1q3AgXu4JNB
	 ZVBG+cdpvla1aKDhckEnv4AI0GKjAMMCXp930duBpqQ4mUskTzeQpQUK5UkzkX06uE
	 vp3yHRe/Uw3mMh7ei2IRVvswKJ9RJgPZvqdBoH898K/Hv98wOnnvbhIpj1na7iNOMk
	 bx4GpYVdsDT+PK5APsKASdAySQpqfi4FOgQKtrNUFUrk8mOJ92JkwzAidFegKDpjRH
	 XhaD6V/4qBX4g==
Message-ID: <9e66d5f7-ee81-4204-8d62-b06d26a00623@kernel.org>
Date: Mon, 16 Nov 2026 13:03:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <16bb1a14-04f4-4524-9882-20d452175a3d@kernel.org>
 <d1856861-62d7-4bc0-a8b7-39ccfc064f34@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d1856861-62d7-4bc0-a8b7-39ccfc064f34@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xz4k73daf393ruq61i9pcetzgqc8ffc3
X-Rspamd-Queue-Id: 5609E2000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794830615-10003
X-HE-Meta: U2FsdGVkX194iGsNCJTd+hyP/TxQYClF+F5yRz6JE4pe6zOEyR3WFS/qnvSNyBS5RIZEq+GAeT/z/qPZYzIlJ8PsiExjBX41t+FtW6Di2qVTvbY2MqYTewkreNPzYsJc7hEGA7O7Xd33fIXRAATafbhB4ajmM2l+vRLerT2kMBM5iU6UOhjoqQzLsuGYL70OmaiXroje1g00FDtPib+O/OVwHenQsQvtVUZNQVIgzjHXTZy1XdVnJOl3K7tw/2jFRIuZ00FdpeGyXiABGishEg/Jh3VnHecThgQJe4+EmZZZwiU/CGHpeZz13J7RcMpZFK5yQtJT+Z/cj5QpVqm5XLmVuMPFI/SD+0e83IcXIagyy2x1BFCgaVVU1qNcVhl9RptTW14iiPVSqnlNq6P0GxKe35cVDlIG+ETHA2Z89e8Wzjbx5HFIy5VAykrNltx3fG+m3Cf3FnLUmLKs4Rc3/CRoRALNIQqWKEP/HjeWqHM8AVdg92ewfGbKNpKotfnTh10m4dyrXU1GcJaarCWsbLIe2Ru+kdYOZzYT03JDW6xCPNsLUMXcSx1wQd8lhdAgcLZ8bDe5rbKQt1B9jZQU29/ffIXSCQb4hazWCaMZyWlBxdscb+Ag7Xr3DM3HGP4gQRWV3jQaiJp0OuspN0QLz90FaC4a9kY7uDu4BZlZoVWG0Ia4j6QXf6EL9YJR3glCTqEzenx31E4VzTNwCdUa+rj278eCu49Gjd2iRl4L9n0g6VntM6vT7rhbpJQuodfOvpjqDCsfPaA3jTJYoIhzTCvW6tnrLYMJTXuhCCuwv1eVMXvcryc/gQn+IGgpAtnNbI24ow095Inwn1uCVgX86XPBQQM33rsyHrMsbR0DVtAkZHySYMaeoiNgT9fpeRIJUnBuWWd78py2H4iyK5Nzxnr3DeVGWc4jGJH5PNA6q1gxOXxlU89roXcHvoe4PH2a8iCumXnDOG7MAai+H8x
 dDs6uEu4
 c1lyFnlFf9Z5dxBn2Y/MBZKwD+ny48W+ifo2VM2kPNtbcLpJs83Ce/6StJfVdJd1sE6vRgqtMn5eQMDzz1MF/N/C1Ocv2l9smzd0XtGCwyq8HplYOgILv9rTuUut+vdT+p2VSXXCSWtZJVYm1flCky50oHTn8MuHSDzHkhXAD0od5t/pXTPwBlKwf+csQUb8uzFa1srh9rVMOn/BEVgkusLji8ero1QEsDUWGvHo1XWb6LmR4cgX/oLrAD7HmngSXh7t1z2B/FGwC9eFRfLmFQ0tvL7kmNri5dCfaSAGfzT+XkHTzxq9W/KzfAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 04:44, Baolin Wang wrote:
> 
> 
> On 11/14/26 1:39 AM, David Hildenbrand (Arm) wrote:
>> On 11/5/26 03:56, Baolin Wang wrote:
>>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
>>> with concurrent page table reclamation via zap_empty_pte_table().
>>>
>>> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
>>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
>>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
>>> and try_to_migrate(), the other callers do not perform post-walk accounting
>>> checks, so the race has no observable impact on them.
>>>
>>> For migration, the race can cause unnecessary retries. For reclaim via
>>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>>> fact already unmapped (as shown below), which may lead to unexpected OOM
>>> or increased refaults.
>>>
>>> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
>>> --------------------------------    --------------------------------
>>> folio_lock(F)
>>> try_to_unmap(F, TTU_SYNC)
>>>                                      zap_pte_range(full PMD range)
>>>                                        spin_lock(ptl)
>>>                                        clear PTEs
>>>                                        zap_empty_pte_table()
>>>                                          spin_trylock(pml)
>>>                                          pmd_clear()
>>>                                          spin_unlock(pml)
>>>
>>>    page_vma_mapped_walk()
>>>      observe !pmd_present(pmde)
>>>      nr_pages < HPAGE_PMD_NR
>>>      skip synchronization
>>>      return false
>>>
>>> try_to_unmap() returns
>>> folio_mapped(F) == true
>>> nr_unmap_fail += folio_nr_pages(F)
>>>                                      tlb_flush_mmu_tlbonly()
>>>                                      tlb_flush_rmaps()
>>>                                        remove F's rmaps
>>>                                      spin_unlock(ptl)
>>>
>>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
>>> has already moved the PMD clear operation (via zap_empty_pte_table()) to
>>> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
>>> use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
>>> issues on weakly ordered CPUs.
>>>
>>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   mm/page_vma_mapped.c | 5 +----
>>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>>
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index e6b6170c2f4f..8797467b6f0c 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>   			spin_unlock(pvmw->ptl);
>>>   			pvmw->ptl = NULL;
>>>   		} else if (!pmd_present(pmde)) {
>>> -			if ((pvmw->flags & PVMW_SYNC) &&
>>> -			    thp_vma_suitable_order(vma, pvmw->address,
>>> -						   PMD_ORDER) &&
>>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>>> +			if (pvmw->flags & PVMW_SYNC)
>>>   				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>>   
>>>   			goto next_pmd;
>>
>> Baolin, how to proceed with that? Are you intending a resend? Including some of
>> the performance impact and ways forward to optimize?
> 
> I hope we can merge this fix first if no other objections. As I replied 
> to Barry, whether to set TTU_SYNC for small folios should be done in a 
> separate patch (this is a pre-existing issue) with proper measurement 
> (though it may be hard to measure the actual impact). What do you think?

Can you update the patch description to include some of the performance aspects
and planned next steps?

-- 
Cheers,

David

