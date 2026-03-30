Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9FD8FF4959
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C4E6B0092; Mon, 30 Mar 2026 03:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316386B0095; Mon, 30 Mar 2026 03:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DDB66B0096; Mon, 30 Mar 2026 03:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0657D6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:33:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A31BEBB328
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:33:56 +0000 (UTC)
X-FDA: 84601915272.28.C5D604D
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id DF7D9C000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:33:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=spRTJFfK;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774856034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdzzH7H/GkudVa2tdoWUwQl2ViEHXCkef0lUwTSCo+g=;
	b=NMANV9GOWr/FQsJ0bJ8ZaZp41LcoOR0rkU8D2nd0tLM2P4N+2VY2bj2bW/kUwq+lj2Dg2p
	hxrJdDRp6NtLdejNkn0QGESBWDpsieEVC4yUZ8WU+UZo/CJJ9sbhq75YLldzMxCLycB+CJ
	EvsLBN9h86gU3TgvvIl2fLiDQXy/+t4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774856034; a=rsa-sha256;
	cv=none;
	b=FQrvdvfHJLy+UO9sV6m/rnnjkCrK5Br302lwYED1RR189Wr62PN51SkyHkmSLc9EG3VAww
	i1iF1CjoyYLsGycF70K+EvWPO0XPtYnDAgghfZEarLbLINTnUUm0G5jDPiZKz4NKZGff3j
	l04+RAAL5aOLO+RrqfKZtWgmeLWcLjM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=spRTJFfK;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YdzzH7H/GkudVa2tdoWUwQl2ViEHXCkef0lUwTSCo+g=;
	b=spRTJFfKb5YS9Fgtlsmc83KTFl1CAK1R5AFFAktOk1dRwlqmF3/f7IkRoAkKV8qwPiovGf3Yt
	Cdos1RhwYm3LApuY0V5tzS4taWmp4jjN4syMPkrrC10zkYho8PW/8d6Y8GMdMOmoCtWAHOdLY0y
	ZsBhuOa6i+b8o9L5sXNhbLw=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fkjWc6C4rzcbN8;
	Mon, 30 Mar 2026 15:27:40 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id A6BEA4056D;
	Mon, 30 Mar 2026 15:33:41 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:33:41 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:33:40 +0800
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
 <31cc7bed-c30f-489c-3ac3-4842aa00b869@huawei.com>
 <CACw3F50BwnLJW75EXgz0t5g+eUhr+wKgJ3YfRFq5208N5KfaiA@mail.gmail.com>
 <a0d25caf-a18b-e3d8-e74f-fc18fa85252e@huawei.com>
 <CACw3F51+bAm03nvucV54bkThnYc-4ewgqGzq_c5i6oMmnGdEtw@mail.gmail.com>
 <a3ff8c7b-69c1-fecc-3564-ecaa3e8a7e67@huawei.com>
 <CACw3F53qr1Af=r__SNxU1ohr69s8apHqHz9tcEHg1hDSLsk5TQ@mail.gmail.com>
 <6b304954-f3d1-5581-5937-1464caf85ab1@huawei.com>
 <CACw3F52K3TTjtmaEsWLcei_ThKwHyn8xj=_4-vpiZhd-ciFU2A@mail.gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <5e0fc743-eb44-b69f-01a2-da7b6f2eca8d@huawei.com>
Date: Mon, 30 Mar 2026 15:33:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACw3F52K3TTjtmaEsWLcei_ThKwHyn8xj=_4-vpiZhd-ciFU2A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: DF7D9C000F
X-Stat-Signature: aj8c63pdrtqgznqb66kwazgfh4dip6bp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774856032-67513
X-HE-Meta: U2FsdGVkX1/LqzEAG0iXdbSyDRupz7ow/L4FmHoDLJqsKH4A2QCc4UqlAYtm5FTn6hxXg6l5JMljoFLPJ0bskjt8SVXrrLpWrDL/Pe4WEWvL4Dt6k6gqOrjhB42NcF4Ij9McGz6Bs9RBNM3KGGhZOpZ+0SxxhUz1B3o+mzgukJp928ID1zkLT+3Pq4+5OLM60qjuP182TtrAmqmau0EsnZ4uSVLTAmpwpe6+t0C8ojW6fpxofpnus8mdHA1pRfim7DK2Za1oM75ELyWNzB5R4WwgLfYnQjVnQiZGlw8RSfR6o3YtpaLw3QH4AqeBHFjkPWYBdClswxjuzg1BOKEm6xPahSau/oAH9d0uytEv76x69+WrpFnTE0Yd76MCG/oqN/p2G0owDhyy2nJ55vHR3QCu/xlg1yBN/Dui9j91mcOexOWXKBTjjZxfAwEqlg1ETxDN0xs/MuRhCm7oRExtMnB/ha4UG/jzbLkBvfxp5sddbrhh4e/PHGIn0sl/H7ljhgb34ZEUlHT7QtA2G14c9XI7uLiI8rxG51aXUig20b5kUUJrFvKqR7Ce8LoT86TPIVbXFnLTpPDQggiJCsiT9hrBhBcH5paoOWXFEiCcWut2+mfQOZCPKqyoyz8H0mXXi5brAVfcY3NDo87tOGNJrx9tIr2Ieixxn2IJ3VKRW9BmdAkP2/spOPVwBLrcPl26o3K4PqkTt31OHZJAOoVvpjOYSs9zyWTKVd6mu/oF6/Y+ov/Rhz6eU28mK1jP818okdGgmixzDDUSFbCgKHUdczXlDzEK/xkN1pbN69JNmG0a0J21eDNjpMyaXXB+4x2Z+sVN3hHFC24t39Gh4pkmLesrJDLYDNin/M/t0Q9Kp9giEojPeQxno8q7nHpBcMyqdSrwGlMsPEo8O+/RgOimavQWUhgA2G9zQC+nl7ErXJVi58QUFIipxPnV5FDRMvm8z3agX1ZEnj3RJvklInk
 vEmGHirc
 WDChLzDd8BkKFDfYEHfAvAoqXNPuELUBsKZ+VX+i5TL5v0ztZLaIf9FRJ4L3CmO9YrMheUQiOgI920HYc9pBJbXqD417holfA+lvSBrAnXamGAw9Rr4IqifgFDlsuMCYUr9Nl91x9dI0rwrJvJeRiRrFndmB4UVmaszXEWNBm52/1E+YHhyYpjzr46FXfWih3vfKRDDlfbWIYTFhTn9Mz4lQrHvooDjU0GxCH6knUjEvzhuNmcAHxjEJS0vheg0j9dLMAT9eAueAmFS1q+ucnb4DTa7LMHKD/VsSNqLOjGGvgmdBBId7eYuheQxBc1AfoNWYsrBAitZ2mMDeLFYUCfzWdaoAK6iwYduvyml2wIkpo15LdCGeII7DEwh+BumQ13TVPLyFgQUDMJCO+eEJ73HicWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/23 6:04, Jiaqi Yan wrote:
> On Mon, Mar 9, 2026 at 7:21 PM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>
>> On 2026/3/9 23:47, Jiaqi Yan wrote:
>>> On Mon, Mar 9, 2026 at 12:41 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>>
>>>> On 2026/3/9 12:53, Jiaqi Yan wrote:
>>>>> On Mon, Feb 23, 2026 at 11:30 PM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>>>>
>>>>>> On 2026/2/13 13:01, Jiaqi Yan wrote:
>>>>>>> On Mon, Feb 9, 2026 at 11:31 PM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>>>>>>
>>>>>>>> On 2026/2/10 12:47, Jiaqi Yan wrote:
>>>>>>>>> On Mon, Feb 9, 2026 at 3:54 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>>>>>>>>
>>>>>>>>>> On 2026/2/4 3:23, Jiaqi Yan wrote:
>>>>>>>>>>> Sometimes immediately hard offlining a large chunk of contigous memory
>>>>>>>>>>> having uncorrected memory errors (UE) may not be the best option.
>>>>>>>>>>> Cloud providers usually serve capacity- and performance-critical guest
>>>>>>>>>>> memory with 1G HugeTLB hugepages, as this significantly reduces the
>>>>>>>>>>> overhead associated with managing page tables and TLB misses. However,
>>>>>>>>>>> for today's HugeTLB system, once a byte of memory in a hugepage is
>>>>>>>>>>> hardware corrupted, the kernel discards the whole hugepage, including
>>>>>>>>>>> the healthy portion. Customer workload running in the VM can hardly
>>>>>>>>>>> recover from such a great loss of memory.
>>>>>>>>>>
>>>>>>>>>> Thanks for your patch. Some questions below.
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Therefore keeping or discarding a large chunk of contiguous memory
>>>>>>>>>>> owned by userspace (particularly to serve guest memory) due to
>>>>>>>>>>> recoverable UE may better be controlled by userspace process
>>>>>>>>>>> that owns the memory, e.g. VMM in the Cloud environment.
>>>>>>>>>>>
>>>>>>>>>>> Introduce a memfd-based userspace memory failure (MFR) policy,
>>>>>>>>>>> MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memfd,
>>>>>>>>>>> but the current implementation only covers HugeTLB.
>>>>>>>>>>>
>>>>>>>>>>> For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memfd,
>>>>>>>>>>> whenever it runs into a new UE,
>>>>>>>>>>>
>>>>>>>>>>> * MFR defers hard offline operations, i.e., unmapping and
>>>>>>>>>>
>>>>>>>>>> So the folio can't be unpoisoned until hugetlb folio becomes free?
>>>>>>>>>
>>>>>>>>> Are you asking from testing perspective, are we still able to clean up
>>>>>>>>> injected test errors via unpoison_memory() with MFD_MF_KEEP_UE_MAPPED?
>>>>>>>>>
>>>>>>>>> If so, unpoison_memory() can't turn the HWPoison hugetlb page to
>>>>>>>>> normal hugetlb page as MFD_MF_KEEP_UE_MAPPED automatically dissolves
>>>>>>>>
>>>>>>>> We might loss some testability but that should be an acceptable compromise.
>>>>>>>
>>>>>>> To clarify, looking at unpoison_memory(), it seems unpoison should
>>>>>>> still work if called before truncated or memfd closed.
>>>>>>>
>>>>>>> What I wanted to say is, for my test hugetlb-mfr.c, since I really
>>>>>>> want to test the cleanup code (dissolving free hugepage having
>>>>>>> multiple errors) after truncation or memfd closed, so we can only
>>>>>>> unpoison the raw pages rejected by buddy allocator.
>>>>>>>
>>>>>>>>
>>>>>>>>> it. unpoison_memory(pfn) can probably still turn the HWPoison raw page
>>>>>>>>> back to a normal one, but you already lost the hugetlb page.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>   dissolving. MFR still sets HWPoison flag, holds a refcount
>>>>>>>>>>>   for every raw HWPoison page, record them in a list, sends SIGBUS
>>>>>>>>>>>   to the consuming thread, but si_addr_lsb is reduced to PAGE_SHIFT.
>>>>>>>>>>>   If userspace is able to handle the SIGBUS, the HWPoison hugepage
>>>>>>>>>>>   remains accessible via the mapping created with that memfd.
>>>>>>>>>>>
>>>>>>>>>>> * If the memory was not faulted in yet, the fault handler also
>>>>>>>>>>>   allows fault in the HWPoison folio.
>>>>>>>>>>>
>>>>>>>>>>> For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
>>>>>>>>>>> when userspace process truncates its hugepages:
>>>>>>>>>>>
>>>>>>>>>>> * When the HugeTLB in-memory file system removes the filemap's
>>>>>>>>>>>   folios one by one, it asks MFR to deal with HWPoison folios
>>>>>>>>>>>   on the fly, implemented by filemap_offline_hwpoison_folio().
>>>>>>>>>>>
>>>>>>>>>>> * MFR drops the refcounts being held for the raw HWPoison
>>>>>>>>>>>   pages within the folio. Now that the HWPoison folio becomes
>>>>>>>>>>>   free, MFR dissolves it into a set of raw pages. The healthy pages
>>>>>>>>>>>   are recycled into buddy allocator, while the HWPoison ones are
>>>>>>>>>>>   prevented from re-allocation.
>>>>>>>>>>>
>>>>>>>>>> ...
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
>>>>>>>>>>> +{
>>>>>>>>>>> +     int ret;
>>>>>>>>>>> +     struct llist_node *head;
>>>>>>>>>>> +     struct raw_hwp_page *curr, *next;
>>>>>>>>>>> +
>>>>>>>>>>> +     /*
>>>>>>>>>>> +      * Since folio is still in the folio_batch, drop the refcount
>>>>>>>>>>> +      * elevated by filemap_get_folios.
>>>>>>>>>>> +      */
>>>>>>>>>>> +     folio_put_refs(folio, 1);
>>>>>>>>>>> +     head = llist_del_all(raw_hwp_list_head(folio));
>>>>>>>>>>
>>>>>>>>>> We might race with get_huge_page_for_hwpoison()? llist_add() might be called
>>>>>>>>>> by folio_set_hugetlb_hwpoison() just after llist_del_all()?
>>>>>>>>>
>>>>>>>>> Oh, when there is a new UE while we releasing the folio here, right?
>>>>>>>>
>>>>>>>> Right.
>>>>>>>>
>>>>>>>>> In that case, would mutex_lock(&mf_mutex) eliminate potential race?
>>>>>>>>
>>>>>>>> IMO spin_lock_irq(&hugetlb_lock) might be better.
>>>>>>>
>>>>>>> Looks like I don't need any lock given the correction below.
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> +
>>>>>>>>>>> +     /*
>>>>>>>>>>> +      * Release refcounts held by try_memory_failure_hugetlb, one per
>>>>>>>>>>> +      * HWPoison-ed page in the raw hwp list.
>>>>>>>>>>> +      *
>>>>>>>>>>> +      * Set HWPoison flag on each page so that free_has_hwpoisoned()
>>>>>>>>>>> +      * can exclude them during dissolve_free_hugetlb_folio().
>>>>>>>>>>> +      */
>>>>>>>>>>> +     llist_for_each_entry_safe(curr, next, head, node) {
>>>>>>>>>>> +             folio_put(folio);
>>>>>>>>>>
>>>>>>>>>> The hugetlb folio refcnt will only be increased once even if it contains multiple UE sub-pages.
>>>>>>>>>> See __get_huge_page_for_hwpoison() for details. So folio_put() might be called more times than
>>>>>>>>>> folio_try_get() in __get_huge_page_for_hwpoison().
>>>>>>>>>
>>>>>>>>> The changes in folio_set_hugetlb_hwpoison() should make
>>>>>>>>> __get_huge_page_for_hwpoison() not to take the "out" path which
>>>>>>>>> decrease the increased refcount for folio. IOW, every time a new UE
>>>>>>>>> happens, we handle the hugetlb page as if it is an in-use hugetlb
>>>>>>>>> page.
>>>>>>>>
>>>>>>>> See below code snippet (comment [1] and [2]):
>>>>>>>>
>>>>>>>> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>>>>>>>                                  bool *migratable_cleared)
>>>>>>>> {
>>>>>>>>         struct page *page = pfn_to_page(pfn);
>>>>>>>>         struct folio *folio = page_folio(page);
>>>>>>>>         int ret = 2;    /* fallback to normal page handling */
>>>>>>>>         bool count_increased = false;
>>>>>>>>
>>>>>>>>         if (!folio_test_hugetlb(folio))
>>>>>>>>                 goto out;
>>>>>>>>
>>>>>>>>         if (flags & MF_COUNT_INCREASED) {
>>>>>>>>                 ret = 1;
>>>>>>>>                 count_increased = true;
>>>>>>>>         } else if (folio_test_hugetlb_freed(folio)) {
>>>>>>>>                 ret = 0;
>>>>>>>>         } else if (folio_test_hugetlb_migratable(folio)) {
>>>>>>>>
>>>>>>>>                    ^^^^*hugetlb_migratable is checked before trying to get folio refcnt* [1]
>>>>>>>>
>>>>>>>>                 ret = folio_try_get(folio);
>>>>>>>>                 if (ret)
>>>>>>>>                         count_increased = true;
>>>>>>>>         } else {
>>>>>>>>                 ret = -EBUSY;
>>>>>>>>                 if (!(flags & MF_NO_RETRY))
>>>>>>>>                         goto out;
>>>>>>>>         }
>>>>>>>>
>>>>>>>>         if (folio_set_hugetlb_hwpoison(folio, page)) {
>>>>>>>>                 ret = -EHWPOISON;
>>>>>>>>                 goto out;
>>>>>>>>         }
>>>>>>>>
>>>>>>>>         /*
>>>>>>>>          * Clearing hugetlb_migratable for hwpoisoned hugepages to prevent them
>>>>>>>>          * from being migrated by memory hotremove.
>>>>>>>>          */
>>>>>>>>         if (count_increased && folio_test_hugetlb_migratable(folio)) {
>>>>>>>>                 folio_clear_hugetlb_migratable(folio);
>>>>>>>>
>>>>>>>>                 ^^^^^*hugetlb_migratable is cleared when first time seeing folio* [2]
>>>>>>>>
>>>>>>>>                 *migratable_cleared = true;
>>>>>>>>         }
>>>>>>>>
>>>>>>>> Or am I miss something?
>>>>>>>
>>>>>>> Thanks for your explaination! You are absolutely right. It turns out
>>>>>>> the extra refcount I saw (during running hugetlb-mfr.c) on the folio
>>>>>>> at the moment of filemap_offline_hwpoison_folio_hugetlb() is actually
>>>>>>> because of the MF_COUNT_INCREASED during MADV_HWPOISON. In the past I
>>>>>>> used to think that is the effect of folio_try_get() in
>>>>>>> __get_huge_page_for_hwpoison(), and it is wrong. Now I see two cases:
>>>>>>> - MADV_HWPOISON: instead of __get_huge_page_for_hwpoison(),
>>>>>>> madvise_inject_error() is the one that increments hugepage refcount
>>>>>>> for every error injected. Different from other cases,
>>>>>>> MFD_MF_KEEP_UE_MAPPED makes the hugepage still a in-use page after
>>>>>>> memory_failure(MF_COUNT_INCREASED), so I think madvise_inject_error()
>>>>>>> should decrement in MFD_MF_KEEP_UE_MAPPED case.
>>>>>>> - In the real world: as you pointed out, MF always just increments
>>>>>>> hugepage refcount once in __get_huge_page_for_hwpoison(), even if it
>>>>>>> runs into multiple errors. When
>>>>>>
>>>>>> This might not always hold true. When MF occurs while hugetlb folio is under isolation(hugetlb_migratable is
>>>>>> cleared and extra folio refcnt is held by isolating code in that case), __get_huge_page_for_hwpoison won't get
>>>>>> extra folio refcnt.
>>>>>>
>>>>>>> filemap_offline_hwpoison_folio_hugetlb() drops the refcount elevated
>>>>>>> by filemap_get_folios(), it only needs to decrement again if
>>>>>>> folio_ref_dec_and_test() returns false. I tested something like below:
>>>>>>>
>>>>>>>     /* drop the refcount elevated by filemap_get_folios. */
>>>>>>>     folio_put(folio);
>>>>>>>     if (folio_ref_count(folio))
>>>>>>>         folio_put(folio);
>>>>>>>     /* now refcount should be zero. */
>>>>>>>     ret = dissolve_free_hugetlb_folio(folio);
>>>>>>
>>>>>> So I think above code might drop the folio refcnt held by isolating code.
>>>>>
>>>>> Hi Miaohe, thanks for raising the concern. Given two things below
>>>>> - both folio_isolate_hugetlb() and get_huge_page_for_hwpoison() are
>>>>> guarded by hugetlb_lock.
>>>>> - hugetlb_update_hwpoison() only folio_test_set_hwpoison() for
>>>>> non-isolated folio after folio_try_get() succeeds.
>>>>>
>>>>> as long as folio_test_set_hwpoison() is true here, this refcount
>>>>> should never come from folio_isolate_hugetlb(). What do you think?
>>>>>
>>>>
>>>> Let's think about below scenario. When __get_huge_page_for_hwpoison() encounters an
>>>> isolated hugetlb folio:
>>>>
>>>> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>>>                                  bool *migratable_cleared)
>>>> {
>>>>         struct page *page = pfn_to_page(pfn);
>>>>         struct folio *folio = page_folio(page);
>>>>         bool count_increased = false;
>>>>         int ret, rc;
>>>>
>>>>         if (!folio_test_hugetlb(folio)) {
>>>>                 ret = MF_HUGETLB_NON_HUGEPAGE;
>>>>                 goto out;
>>>>         } else if (flags & MF_COUNT_INCREASED) {
>>>>                 ret = MF_HUGETLB_IN_USED;
>>>>                 count_increased = true;
>>>>         } else if (folio_test_hugetlb_freed(folio)) {
>>>>                 ret = MF_HUGETLB_FREED;
>>>>         } else if (folio_test_hugetlb_migratable(folio)) {
>>>>
>>>>                    ^^^^*Since hugetlb_migratable is cleared for the isolated hugetlb folio*
>>>>
>>>>                 if (folio_try_get(folio)) {
>>>>                         ret = MF_HUGETLB_IN_USED;
>>>>                         count_increased = true;
>>>>                 } else {
>>>>                         ret = MF_HUGETLB_FREED;
>>>>                 }
>>>>         } else {
>>>>
>>>>                   ^^^^*Code will reach here without extra refcnt increased*
>>>>
>>>>                 ret = MF_HUGETLB_RETRY;
>>>>                 if (!(flags & MF_NO_RETRY))
>>>>                         goto out;
>>>>         }
>>>>
>>>>         *Code will reach here after retry*
>>>
>>> You are right, thanks for pointing that out. Let me think about more
>>> how to handle this.
> 
> I was struggling to find a good fix, as I really don't want to memoize
> into the folio that if memory_failure has elevated a refcount.
> 
>>>
>>>>         rc = hugetlb_update_hwpoison(folio, page);
>>>>         if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
>>>>                 ret = rc;
>>>>                 goto out;
>>>>         }
>>>>
>>>> So hugetlb_update_hwpoison() will be called even for folio under isolation
>>>> without folio_try_get(). Or am I miss something?
>>>
>>> Just a random question: if MF never increments a hugepage's refcount,
>>
>> MF will hold hugetlb folio's refcount unless it's freed or isolated.
> 
> A random thought. For an isolated hugetlb folio, if it becomes
> hwpoison (after __get_huge_page_for_hwpoison() failed with retries),
> and then `folio_putback_hugetlb()` is called, should we block setting
> migratable and putting it back to hugepage_activelist? IWO, make it
> forever isolated and just decrement refcount:
> 
>  void folio_putback_hugetlb(struct folio *folio)
>  {
>         spin_lock_irq(&hugetlb_lock);
> -       folio_set_hugetlb_migratable(folio);
> -       list_move_tail(&folio->lru,
> &(folio_hstate(folio))->hugepage_activelist);
> +       if (!folio_test_hwpoison(folio)) {
> +               folio_set_hugetlb_migratable(folio);
> +               list_move_tail(&folio->lru,
> &(folio_hstate(folio))->hugepage_activelist);
> +       }

Will it also block the hugetlb folio from being freed and dissolved later
when last folio refcnt is gone?

>         spin_unlock_irq(&hugetlb_lock);
>         folio_put(folio);
> 
> (Maybe the event "become hwpoison => folio_putback_hugetlb()" can never happen?)
> 
> If so, as a side effect, I can use folio_putback_hugetlb() to
> decrement the refcount even if we are uncertain that the residue
> refcount is whether from memory_failure or folio_isolate_hugetlb().

What if the caller of folio_isolate_hugetlb() has called folio_putback_hugetlb() before
us? Can we tell that apart?

Thanks.
.


