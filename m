Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87820EA3F16
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 07:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4AF06B0005; Tue, 10 Feb 2026 02:31:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8406B0088; Tue, 10 Feb 2026 02:31:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFAC56B0089; Tue, 10 Feb 2026 02:31:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD91A6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:31:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFD231B3355
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:31:39 +0000 (UTC)
X-FDA: 84427727118.08.164C5B1
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf06.hostedemail.com (Postfix) with ESMTP id 68B83180005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:31:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QqAZweSc;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770708698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnPhcm04RgXUByNiUINhP/lHOk9f0CuIXS0OCcNO/mI=;
	b=5Ihs2ctMk+wLyoYPdi56K5P+NqtMjqjsv2jgCtYdrVClcGcMC04pFOu/xtjXyxsaRfb/AP
	h0xbTmmS71XwWyRFWOeJ3qIXPxKFapAkNiA9wZGT/ZXwfeMySfIaoM617RI7MWBYlUOqpb
	kK1PLmTHPeaxxzxN4YR90ETiv8TMkbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770708698; a=rsa-sha256;
	cv=none;
	b=eYBXb47CwC0TiQ/l86kUSrHYpOu8FZ6YycGw8w6qUlRs3nmEKfnOQ3wZ/6ONcbJW6vGZWB
	cajIqqqIaGhQ1hAgq77VmrwUkyRWxgswP5n56X/GbBcrmYtMfDoavX6aLBHlU5xnV9Ta55
	yvq8+a+EwxkS529dcgTFGnk7uatLdtM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QqAZweSc;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JnPhcm04RgXUByNiUINhP/lHOk9f0CuIXS0OCcNO/mI=;
	b=QqAZweScfKIM0otUDQqRMBYp4ndRK7LYYcRAz9om1y/6VCdCqZmLRdebrW1x/l1F6G7yJZcbL
	dW3H7vlomSaq0K2bkM43blnD/hAM7e4DQ1uvAda6EULhNQR29GEe3l67MEjd906ROoaUqHRH6yr
	wZ/sZSH0NHCUEjNIWYH7sDc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4f9Cn040KTz1T4JY;
	Tue, 10 Feb 2026 15:27:00 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 430AB4036C;
	Tue, 10 Feb 2026 15:31:31 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Feb 2026 15:31:31 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Feb 2026 15:31:29 +0800
Subject: Re: [PATCH v3 1/3] mm: memfd/hugetlb: introduce memfd-based userspace
 MFR policy
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <nao.horiguchi@gmail.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <osalvador@suse.de>, <rientjes@google.com>,
	<duenwen@google.com>, <jthoughton@google.com>, <jgg@nvidia.com>,
	<ankita@nvidia.com>, <peterx@redhat.com>, <sidhartha.kumar@oracle.com>,
	<ziy@nvidia.com>, <david@redhat.com>, <dave.hansen@linux.intel.com>,
	<muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<william.roche@oracle.com>, <harry.yoo@oracle.com>, <jane.chu@oracle.com>
References: <20260203192352.2674184-1-jiaqiyan@google.com>
 <20260203192352.2674184-2-jiaqiyan@google.com>
 <7ad34b69-2fb4-770b-14e5-bea13cf63d2f@huawei.com>
 <CACw3F50PwJ+sSOX0wySQgBzrEW2XOctxuX5jM37OG0HS_kHdbQ@mail.gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <31cc7bed-c30f-489c-3ac3-4842aa00b869@huawei.com>
Date: Tue, 10 Feb 2026 15:31:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACw3F50PwJ+sSOX0wySQgBzrEW2XOctxuX5jM37OG0HS_kHdbQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 68B83180005
X-Stat-Signature: cgwk4d53qfn9eab1rhmzubosy43y3kxz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770708696-617362
X-HE-Meta: U2FsdGVkX18zcxEcS/19/WUK/Po/vnM/OjNAx/+75J2ca26sZiY11TyHIBqWKKcb0zd/8dLFT02YPGnENjC5l/vnScsDxrqORmv2wtDn4S3ZiATbhTMYsc+Ntqu+8t2QV7oOLEIAnGXZI045G7+nlpOKJNzrmuY8MVw3QjtmawhFcHYBljBLTM8y6oKC1GAk1UxTm4o6GhK4XGC99J4lwTTGL+NB7+GXevw6CyK7fC2vMlAa0BmgXrOrB2wCbmRGGnGiiG4moqTqwLQ0gqg8RLg7ShuHzXUt+VbJ1FKBSpo5vqtxxwgg49t4y0rifpsyiB0bXDNP2PIR8qdO5OvbmRimIO52zA5Ng5SFhfjFwO6ORcBDuPJTn6pgIk7aqdEj1fihjIiy6SK03XcSMVdbXas8eT9oFe3HtVk4fFLDMbYUxcKzww8C/aJlNb1DzdLtuheXFL/7BJb95ZZ/M4kQi+BwS/ByW6NUTqjcRS0Njwrhiqq954BsWCQjATn14+5+2UxU/KdrxMiV/AGbt5/xWKrQepVZ5q3+58/HFhVr/H3WF8Vb0H1j72snJZwbGL8BPe2RsTUnJ+JppWb7u2ZHbvF9qgRHlvYTCzGGeiAKvXJ0kjOuhC4WJbEOObS2b1DW9PSFDwvDMkOARZuIxAQuK2ouSKF6oFdIdtOWGpX/iyJeOd2Qa7nAgmHQYw5TjGjq+I5zFLEXU72PMdlyFJtEHk8tjn0Rh8VNR0sb3uKaqXv0X76zqiyasoU3g9K4I0SL0uiFsf70wIRZF/mib10xaem1Z3B/t+GSFBJfzQrNgWRbWjsvZoiyJNe0uKCqm182pKqZorgfpTDCeTkgNthjvoTsTQuWJXNvfNuOfS6HpMNjaGkOjgE0yx93+8S9LihEtjE3PFFoKq6fVpmQmpO4kg4s4lTiDeqkTokkHddehiN1yvsm0lOAii/wZaVFgGpM/8md3eN2ovSwuKTAbY9
 /utq5F5H
 MTv2NsiDL8tTHtFpSryY2GTo3neZXDMLBMkFuZB8MXHOY5ujHnFYMTMn/r1Ly7dI34YbSuP5wTSA6E4Gae2FGcj0cuQA7oC9CvfsG7FarmkZ+jcGJ/1ivvYqz15MkTy7CG6/m1ozzjU6/dwJJUTgGPNf3c68hlKEeJY977pG11wWouL2gdVCYwtGWlcX9YtTkOwZnL0oAlQ7qD4QOKhQcg0sQrAnSZ4lMCdNbXVh9ujfYfwhR9kVEFQNm/Oxp0/YD9vOmQQdWR8M6lt0gunWB+jhMlLgY6GpeXozrQZs1KnWZROX/kOuRk+CAnsZbp9pAv9mDLo7NghE21K41hklUG/zZkn1DO4EINJQ5Csi8ApCTtzJBtAlB1qrxRlbHul8Pq3yNRe3IWy9ASVhaVdSPiiuVqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/10 12:47, Jiaqi Yan wrote:
> On Mon, Feb 9, 2026 at 3:54 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>
>> On 2026/2/4 3:23, Jiaqi Yan wrote:
>>> Sometimes immediately hard offlining a large chunk of contigous memory
>>> having uncorrected memory errors (UE) may not be the best option.
>>> Cloud providers usually serve capacity- and performance-critical guest
>>> memory with 1G HugeTLB hugepages, as this significantly reduces the
>>> overhead associated with managing page tables and TLB misses. However,
>>> for today's HugeTLB system, once a byte of memory in a hugepage is
>>> hardware corrupted, the kernel discards the whole hugepage, including
>>> the healthy portion. Customer workload running in the VM can hardly
>>> recover from such a great loss of memory.
>>
>> Thanks for your patch. Some questions below.
>>
>>>
>>> Therefore keeping or discarding a large chunk of contiguous memory
>>> owned by userspace (particularly to serve guest memory) due to
>>> recoverable UE may better be controlled by userspace process
>>> that owns the memory, e.g. VMM in the Cloud environment.
>>>
>>> Introduce a memfd-based userspace memory failure (MFR) policy,
>>> MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memfd,
>>> but the current implementation only covers HugeTLB.
>>>
>>> For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memfd,
>>> whenever it runs into a new UE,
>>>
>>> * MFR defers hard offline operations, i.e., unmapping and
>>
>> So the folio can't be unpoisoned until hugetlb folio becomes free?
> 
> Are you asking from testing perspective, are we still able to clean up
> injected test errors via unpoison_memory() with MFD_MF_KEEP_UE_MAPPED?
> 
> If so, unpoison_memory() can't turn the HWPoison hugetlb page to
> normal hugetlb page as MFD_MF_KEEP_UE_MAPPED automatically dissolves

We might loss some testability but that should be an acceptable compromise.

> it. unpoison_memory(pfn) can probably still turn the HWPoison raw page
> back to a normal one, but you already lost the hugetlb page.
> 
>>
>>>   dissolving. MFR still sets HWPoison flag, holds a refcount
>>>   for every raw HWPoison page, record them in a list, sends SIGBUS
>>>   to the consuming thread, but si_addr_lsb is reduced to PAGE_SHIFT.
>>>   If userspace is able to handle the SIGBUS, the HWPoison hugepage
>>>   remains accessible via the mapping created with that memfd.
>>>
>>> * If the memory was not faulted in yet, the fault handler also
>>>   allows fault in the HWPoison folio.
>>>
>>> For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
>>> when userspace process truncates its hugepages:
>>>
>>> * When the HugeTLB in-memory file system removes the filemap's
>>>   folios one by one, it asks MFR to deal with HWPoison folios
>>>   on the fly, implemented by filemap_offline_hwpoison_folio().
>>>
>>> * MFR drops the refcounts being held for the raw HWPoison
>>>   pages within the folio. Now that the HWPoison folio becomes
>>>   free, MFR dissolves it into a set of raw pages. The healthy pages
>>>   are recycled into buddy allocator, while the HWPoison ones are
>>>   prevented from re-allocation.
>>>
>> ...
>>
>>>
>>> +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
>>> +{
>>> +     int ret;
>>> +     struct llist_node *head;
>>> +     struct raw_hwp_page *curr, *next;
>>> +
>>> +     /*
>>> +      * Since folio is still in the folio_batch, drop the refcount
>>> +      * elevated by filemap_get_folios.
>>> +      */
>>> +     folio_put_refs(folio, 1);
>>> +     head = llist_del_all(raw_hwp_list_head(folio));
>>
>> We might race with get_huge_page_for_hwpoison()? llist_add() might be called
>> by folio_set_hugetlb_hwpoison() just after llist_del_all()?
> 
> Oh, when there is a new UE while we releasing the folio here, right?

Right.

> In that case, would mutex_lock(&mf_mutex) eliminate potential race?

IMO spin_lock_irq(&hugetlb_lock) might be better.

> 
>>
>>> +
>>> +     /*
>>> +      * Release refcounts held by try_memory_failure_hugetlb, one per
>>> +      * HWPoison-ed page in the raw hwp list.
>>> +      *
>>> +      * Set HWPoison flag on each page so that free_has_hwpoisoned()
>>> +      * can exclude them during dissolve_free_hugetlb_folio().
>>> +      */
>>> +     llist_for_each_entry_safe(curr, next, head, node) {
>>> +             folio_put(folio);
>>
>> The hugetlb folio refcnt will only be increased once even if it contains multiple UE sub-pages.
>> See __get_huge_page_for_hwpoison() for details. So folio_put() might be called more times than
>> folio_try_get() in __get_huge_page_for_hwpoison().
> 
> The changes in folio_set_hugetlb_hwpoison() should make
> __get_huge_page_for_hwpoison() not to take the "out" path which
> decrease the increased refcount for folio. IOW, every time a new UE
> happens, we handle the hugetlb page as if it is an in-use hugetlb
> page.

See below code snippet (comment [1] and [2]):

int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
				 bool *migratable_cleared)
{
	struct page *page = pfn_to_page(pfn);
	struct folio *folio = page_folio(page);
	int ret = 2;	/* fallback to normal page handling */
	bool count_increased = false;

	if (!folio_test_hugetlb(folio))
		goto out;

	if (flags & MF_COUNT_INCREASED) {
		ret = 1;
		count_increased = true;
	} else if (folio_test_hugetlb_freed(folio)) {
		ret = 0;
	} else if (folio_test_hugetlb_migratable(folio)) {

		   ^^^^*hugetlb_migratable is checked before trying to get folio refcnt* [1]

		ret = folio_try_get(folio);
		if (ret)
			count_increased = true;
	} else {
		ret = -EBUSY;
		if (!(flags & MF_NO_RETRY))
			goto out;
	}

	if (folio_set_hugetlb_hwpoison(folio, page)) {
		ret = -EHWPOISON;
		goto out;
	}

	/*
	 * Clearing hugetlb_migratable for hwpoisoned hugepages to prevent them
	 * from being migrated by memory hotremove.
	 */
	if (count_increased && folio_test_hugetlb_migratable(folio)) {
		folio_clear_hugetlb_migratable(folio);

		^^^^^*hugetlb_migratable is cleared when first time seeing folio* [2]

		*migratable_cleared = true;
	}

Or am I miss something?

> 
>>
>>> +             SetPageHWPoison(curr->page);
>>
>> If hugetlb folio vmemmap is optimized, I think SetPageHWPoison might trigger BUG.
> 
> Ah, I see, vmemmap optimization doesn't allow us to move flags from
> raw_hwp_list to tail pages. I guess the best I can do is to bail out
> if vmemmap is enabled like folio_clear_hugetlb_hwpoison().

I think you can do this after hugetlb_vmemmap_restore_folio() is called.

Thanks.
.

