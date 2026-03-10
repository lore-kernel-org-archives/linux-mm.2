Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 810A7FCC9AA
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 02:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3A26B0088; Mon,  9 Mar 2026 22:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BAE46B0089; Mon,  9 Mar 2026 22:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7226B008A; Mon,  9 Mar 2026 22:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48E636B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 22:21:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4F77160422
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:21:55 +0000 (UTC)
X-FDA: 84528552990.10.1FF5847
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf10.hostedemail.com (Postfix) with ESMTP id 19BF7C0004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:21:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cvKNfoE0;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773109313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXjGztx/BX5wcnPp0cQJ/8oe6dfejXu8ICgIm66QIN8=;
	b=zyO+9gMsODNwtB78RG4Uthu3Nx8ihE36XaSpw0j39cMTaxWtquSvSBAyPPE9W4/+rWK/mB
	Q5pGnjgI7XDGWzyCd0VJJIAWru/s0Ip/vZxzW0Y6dXhOOigJ7Pg29TdnCsoksXbrFwhTFp
	vF2YVz7iQM77PVJBvXG1n1Q+ynxjbUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773109313; a=rsa-sha256;
	cv=none;
	b=OD2rNzYA2IXZFTRGtVyqAnocSg+IrkuPqMT0KZQIGnP0gwvC8C/I4jM6dOckT3ouHKaQ6s
	yR6TfmEIkBzYEof/PTIQ+llCnBVUMzy1mvL0hU9Ba2XSgrDF4M+i0wauG7eTB0Ebr3NEEZ
	IpTtgxNcMl51bGwo04aUMHnIahuzGC4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cvKNfoE0;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AXjGztx/BX5wcnPp0cQJ/8oe6dfejXu8ICgIm66QIN8=;
	b=cvKNfoE0tUgJu+WaN6nim0UwxI2ppxxOA1o+CTA3EKkeTKw9atxxP61gYVuljCbxU9Vf2fCRY
	f+LtdqaqZM7yIjxHoqvbdeiMepbIlFh5PV+ZgBDm2qW4rMAKaZI9fOGe5hUlEjMAU2Vf6pPX6uP
	xI2zM5LqqE8dl4FBjIT6pN4=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fVHZD67v5z1K9Cg;
	Tue, 10 Mar 2026 10:16:52 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1ED414056C;
	Tue, 10 Mar 2026 10:21:45 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 10:21:44 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 10:21:43 +0800
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
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6b304954-f3d1-5581-5937-1464caf85ab1@huawei.com>
Date: Tue, 10 Mar 2026 10:21:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACw3F53qr1Af=r__SNxU1ohr69s8apHqHz9tcEHg1hDSLsk5TQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: fwz4ebi4kj9uhaj78wtdu813sp33o4ww
X-Rspam-User: 
X-Rspamd-Queue-Id: 19BF7C0004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773109311-896006
X-HE-Meta: U2FsdGVkX19q2SyJEQFIOs+SPDLPdFJSlEpKKd1lBJ49EY25eGEznhkQkWRGK4RqAzofNBGq+SgrIWcY2ZZLl6EoK9+onuF+ylvKnKRaQ/Bk2028S+Mx5sFCNMYK4/G0KNhNjO7C+whTlctHsy4960/9i/JQsyjteAFxdvlTfWKMQcBeyL58iwEgprYxHOSQ/6Z3AiImKsNSthFEvMvKJQMSKDNQgmUpJzM/d9UiukSwRcEiimv4DyEI1InJb2Of2pzXAholGyBLm6uYdYpjAj828cR1kjD5GO60gfJdCZmtYOhECXymDTICImJCyJhjSjN+88q3t8YdKU1kxnsWFzOH1UuyEyACvT8Vd7V98/Wwu68KYlHtKLk/4cR0SR4jb/1eXC7nbxHQmMe6QSJbiShIWN/p4y+xGJQFWEUnMhx2h0Cwc0qXVlweNtidphT1krdxD+wv6B4v/bW9X3VAwdEXS0CJs8mlcgK5aKnmwZ8kgqz/BLawHJ71ekriquURkPQpseJzRxSprQyPCBBAl6V20zOuV10PqAvnl7pX5kXN+ul3NdV9/CETJ6sOhjLCI3gNJv7Knu+40UffxbkzxMf0axJ+zgKbmO1Md0FTbc3spD1Yxtccstu67s49FFiYs4bChJIsK/+zU4fARHRsgJ6H2jzTJRR8mIH7x3b7mPPhHiZ77yzEszcNYaUl60oPsB4bJ64PRcA0VjEw4nvoLn1pEUK5NpEaXAjCDH/bPEXX2UIGs2IwduobRTYk+nETE2gr/6poexAI7bjXiPt4ZFFpyzhJET0Rmnnp/yPSVcU9RxhBY0EvX9BhsCnV90WUpAchyznKCubOE2etHLm2/eFZp1FKitqGi0PQnbGhgk/llsagL6gL/dqHuqbE05NB/oluU1Je/KKWCPxy908X02o+Qt0VBwFGGpweHGkz8nPVHsD+X+fADYSeTcObh791ZhHAqD++0Z6Ad2NSqrK
 XORHmCpy
 kczDMSgJ9o7lX4R8trHXUOrSJpaTz42eihMAFykQ9LXAjpMIvDBqRNyyzfmy4r0Sib1qaXq55mZv4fO9l1ifKQX2Gxh1lcgYV3joid9uT4lkuMSM02RWxZHnrdzVJK9X75mBfQZeuWm5PankBODAatOJzve8yDX93kWaLReWD4kFBilsL+bmC0KUPq9SeFxYyMIDql7XN3RqjoXw66+rV+Drdwp3JDx/y/prapwCvBZD3lqKi23nT7OSYBndI6wtcqqhqiTWfzEYGUZvuwdci/KU6YrKa8F6kgQ9La4hprvuuci8fbMFvBkM9hnzCxuMrPNi/9iQSe0+BROrT79EWZDrsNO8xTfPLZKm/aFzTPCY7/m7E04FlZ5Zhjkal6GAGXs/QU2CmLsilohZvu7E6XQqDPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/9 23:47, Jiaqi Yan wrote:
> On Mon, Mar 9, 2026 at 12:41 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>
>> On 2026/3/9 12:53, Jiaqi Yan wrote:
>>> On Mon, Feb 23, 2026 at 11:30 PM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>>
>>>> On 2026/2/13 13:01, Jiaqi Yan wrote:
>>>>> On Mon, Feb 9, 2026 at 11:31 PM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>>>>
>>>>>> On 2026/2/10 12:47, Jiaqi Yan wrote:
>>>>>>> On Mon, Feb 9, 2026 at 3:54 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>>>>>>
>>>>>>>> On 2026/2/4 3:23, Jiaqi Yan wrote:
>>>>>>>>> Sometimes immediately hard offlining a large chunk of contigous memory
>>>>>>>>> having uncorrected memory errors (UE) may not be the best option.
>>>>>>>>> Cloud providers usually serve capacity- and performance-critical guest
>>>>>>>>> memory with 1G HugeTLB hugepages, as this significantly reduces the
>>>>>>>>> overhead associated with managing page tables and TLB misses. However,
>>>>>>>>> for today's HugeTLB system, once a byte of memory in a hugepage is
>>>>>>>>> hardware corrupted, the kernel discards the whole hugepage, including
>>>>>>>>> the healthy portion. Customer workload running in the VM can hardly
>>>>>>>>> recover from such a great loss of memory.
>>>>>>>>
>>>>>>>> Thanks for your patch. Some questions below.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Therefore keeping or discarding a large chunk of contiguous memory
>>>>>>>>> owned by userspace (particularly to serve guest memory) due to
>>>>>>>>> recoverable UE may better be controlled by userspace process
>>>>>>>>> that owns the memory, e.g. VMM in the Cloud environment.
>>>>>>>>>
>>>>>>>>> Introduce a memfd-based userspace memory failure (MFR) policy,
>>>>>>>>> MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memfd,
>>>>>>>>> but the current implementation only covers HugeTLB.
>>>>>>>>>
>>>>>>>>> For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memfd,
>>>>>>>>> whenever it runs into a new UE,
>>>>>>>>>
>>>>>>>>> * MFR defers hard offline operations, i.e., unmapping and
>>>>>>>>
>>>>>>>> So the folio can't be unpoisoned until hugetlb folio becomes free?
>>>>>>>
>>>>>>> Are you asking from testing perspective, are we still able to clean up
>>>>>>> injected test errors via unpoison_memory() with MFD_MF_KEEP_UE_MAPPED?
>>>>>>>
>>>>>>> If so, unpoison_memory() can't turn the HWPoison hugetlb page to
>>>>>>> normal hugetlb page as MFD_MF_KEEP_UE_MAPPED automatically dissolves
>>>>>>
>>>>>> We might loss some testability but that should be an acceptable compromise.
>>>>>
>>>>> To clarify, looking at unpoison_memory(), it seems unpoison should
>>>>> still work if called before truncated or memfd closed.
>>>>>
>>>>> What I wanted to say is, for my test hugetlb-mfr.c, since I really
>>>>> want to test the cleanup code (dissolving free hugepage having
>>>>> multiple errors) after truncation or memfd closed, so we can only
>>>>> unpoison the raw pages rejected by buddy allocator.
>>>>>
>>>>>>
>>>>>>> it. unpoison_memory(pfn) can probably still turn the HWPoison raw page
>>>>>>> back to a normal one, but you already lost the hugetlb page.
>>>>>>>
>>>>>>>>
>>>>>>>>>   dissolving. MFR still sets HWPoison flag, holds a refcount
>>>>>>>>>   for every raw HWPoison page, record them in a list, sends SIGBUS
>>>>>>>>>   to the consuming thread, but si_addr_lsb is reduced to PAGE_SHIFT.
>>>>>>>>>   If userspace is able to handle the SIGBUS, the HWPoison hugepage
>>>>>>>>>   remains accessible via the mapping created with that memfd.
>>>>>>>>>
>>>>>>>>> * If the memory was not faulted in yet, the fault handler also
>>>>>>>>>   allows fault in the HWPoison folio.
>>>>>>>>>
>>>>>>>>> For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
>>>>>>>>> when userspace process truncates its hugepages:
>>>>>>>>>
>>>>>>>>> * When the HugeTLB in-memory file system removes the filemap's
>>>>>>>>>   folios one by one, it asks MFR to deal with HWPoison folios
>>>>>>>>>   on the fly, implemented by filemap_offline_hwpoison_folio().
>>>>>>>>>
>>>>>>>>> * MFR drops the refcounts being held for the raw HWPoison
>>>>>>>>>   pages within the folio. Now that the HWPoison folio becomes
>>>>>>>>>   free, MFR dissolves it into a set of raw pages. The healthy pages
>>>>>>>>>   are recycled into buddy allocator, while the HWPoison ones are
>>>>>>>>>   prevented from re-allocation.
>>>>>>>>>
>>>>>>>> ...
>>>>>>>>
>>>>>>>>>
>>>>>>>>> +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
>>>>>>>>> +{
>>>>>>>>> +     int ret;
>>>>>>>>> +     struct llist_node *head;
>>>>>>>>> +     struct raw_hwp_page *curr, *next;
>>>>>>>>> +
>>>>>>>>> +     /*
>>>>>>>>> +      * Since folio is still in the folio_batch, drop the refcount
>>>>>>>>> +      * elevated by filemap_get_folios.
>>>>>>>>> +      */
>>>>>>>>> +     folio_put_refs(folio, 1);
>>>>>>>>> +     head = llist_del_all(raw_hwp_list_head(folio));
>>>>>>>>
>>>>>>>> We might race with get_huge_page_for_hwpoison()? llist_add() might be called
>>>>>>>> by folio_set_hugetlb_hwpoison() just after llist_del_all()?
>>>>>>>
>>>>>>> Oh, when there is a new UE while we releasing the folio here, right?
>>>>>>
>>>>>> Right.
>>>>>>
>>>>>>> In that case, would mutex_lock(&mf_mutex) eliminate potential race?
>>>>>>
>>>>>> IMO spin_lock_irq(&hugetlb_lock) might be better.
>>>>>
>>>>> Looks like I don't need any lock given the correction below.
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>> +
>>>>>>>>> +     /*
>>>>>>>>> +      * Release refcounts held by try_memory_failure_hugetlb, one per
>>>>>>>>> +      * HWPoison-ed page in the raw hwp list.
>>>>>>>>> +      *
>>>>>>>>> +      * Set HWPoison flag on each page so that free_has_hwpoisoned()
>>>>>>>>> +      * can exclude them during dissolve_free_hugetlb_folio().
>>>>>>>>> +      */
>>>>>>>>> +     llist_for_each_entry_safe(curr, next, head, node) {
>>>>>>>>> +             folio_put(folio);
>>>>>>>>
>>>>>>>> The hugetlb folio refcnt will only be increased once even if it contains multiple UE sub-pages.
>>>>>>>> See __get_huge_page_for_hwpoison() for details. So folio_put() might be called more times than
>>>>>>>> folio_try_get() in __get_huge_page_for_hwpoison().
>>>>>>>
>>>>>>> The changes in folio_set_hugetlb_hwpoison() should make
>>>>>>> __get_huge_page_for_hwpoison() not to take the "out" path which
>>>>>>> decrease the increased refcount for folio. IOW, every time a new UE
>>>>>>> happens, we handle the hugetlb page as if it is an in-use hugetlb
>>>>>>> page.
>>>>>>
>>>>>> See below code snippet (comment [1] and [2]):
>>>>>>
>>>>>> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>>>>>                                  bool *migratable_cleared)
>>>>>> {
>>>>>>         struct page *page = pfn_to_page(pfn);
>>>>>>         struct folio *folio = page_folio(page);
>>>>>>         int ret = 2;    /* fallback to normal page handling */
>>>>>>         bool count_increased = false;
>>>>>>
>>>>>>         if (!folio_test_hugetlb(folio))
>>>>>>                 goto out;
>>>>>>
>>>>>>         if (flags & MF_COUNT_INCREASED) {
>>>>>>                 ret = 1;
>>>>>>                 count_increased = true;
>>>>>>         } else if (folio_test_hugetlb_freed(folio)) {
>>>>>>                 ret = 0;
>>>>>>         } else if (folio_test_hugetlb_migratable(folio)) {
>>>>>>
>>>>>>                    ^^^^*hugetlb_migratable is checked before trying to get folio refcnt* [1]
>>>>>>
>>>>>>                 ret = folio_try_get(folio);
>>>>>>                 if (ret)
>>>>>>                         count_increased = true;
>>>>>>         } else {
>>>>>>                 ret = -EBUSY;
>>>>>>                 if (!(flags & MF_NO_RETRY))
>>>>>>                         goto out;
>>>>>>         }
>>>>>>
>>>>>>         if (folio_set_hugetlb_hwpoison(folio, page)) {
>>>>>>                 ret = -EHWPOISON;
>>>>>>                 goto out;
>>>>>>         }
>>>>>>
>>>>>>         /*
>>>>>>          * Clearing hugetlb_migratable for hwpoisoned hugepages to prevent them
>>>>>>          * from being migrated by memory hotremove.
>>>>>>          */
>>>>>>         if (count_increased && folio_test_hugetlb_migratable(folio)) {
>>>>>>                 folio_clear_hugetlb_migratable(folio);
>>>>>>
>>>>>>                 ^^^^^*hugetlb_migratable is cleared when first time seeing folio* [2]
>>>>>>
>>>>>>                 *migratable_cleared = true;
>>>>>>         }
>>>>>>
>>>>>> Or am I miss something?
>>>>>
>>>>> Thanks for your explaination! You are absolutely right. It turns out
>>>>> the extra refcount I saw (during running hugetlb-mfr.c) on the folio
>>>>> at the moment of filemap_offline_hwpoison_folio_hugetlb() is actually
>>>>> because of the MF_COUNT_INCREASED during MADV_HWPOISON. In the past I
>>>>> used to think that is the effect of folio_try_get() in
>>>>> __get_huge_page_for_hwpoison(), and it is wrong. Now I see two cases:
>>>>> - MADV_HWPOISON: instead of __get_huge_page_for_hwpoison(),
>>>>> madvise_inject_error() is the one that increments hugepage refcount
>>>>> for every error injected. Different from other cases,
>>>>> MFD_MF_KEEP_UE_MAPPED makes the hugepage still a in-use page after
>>>>> memory_failure(MF_COUNT_INCREASED), so I think madvise_inject_error()
>>>>> should decrement in MFD_MF_KEEP_UE_MAPPED case.
>>>>> - In the real world: as you pointed out, MF always just increments
>>>>> hugepage refcount once in __get_huge_page_for_hwpoison(), even if it
>>>>> runs into multiple errors. When
>>>>
>>>> This might not always hold true. When MF occurs while hugetlb folio is under isolation(hugetlb_migratable is
>>>> cleared and extra folio refcnt is held by isolating code in that case), __get_huge_page_for_hwpoison won't get
>>>> extra folio refcnt.
>>>>
>>>>> filemap_offline_hwpoison_folio_hugetlb() drops the refcount elevated
>>>>> by filemap_get_folios(), it only needs to decrement again if
>>>>> folio_ref_dec_and_test() returns false. I tested something like below:
>>>>>
>>>>>     /* drop the refcount elevated by filemap_get_folios. */
>>>>>     folio_put(folio);
>>>>>     if (folio_ref_count(folio))
>>>>>         folio_put(folio);
>>>>>     /* now refcount should be zero. */
>>>>>     ret = dissolve_free_hugetlb_folio(folio);
>>>>
>>>> So I think above code might drop the folio refcnt held by isolating code.
>>>
>>> Hi Miaohe, thanks for raising the concern. Given two things below
>>> - both folio_isolate_hugetlb() and get_huge_page_for_hwpoison() are
>>> guarded by hugetlb_lock.
>>> - hugetlb_update_hwpoison() only folio_test_set_hwpoison() for
>>> non-isolated folio after folio_try_get() succeeds.
>>>
>>> as long as folio_test_set_hwpoison() is true here, this refcount
>>> should never come from folio_isolate_hugetlb(). What do you think?
>>>
>>
>> Let's think about below scenario. When __get_huge_page_for_hwpoison() encounters an
>> isolated hugetlb folio:
>>
>> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>                                  bool *migratable_cleared)
>> {
>>         struct page *page = pfn_to_page(pfn);
>>         struct folio *folio = page_folio(page);
>>         bool count_increased = false;
>>         int ret, rc;
>>
>>         if (!folio_test_hugetlb(folio)) {
>>                 ret = MF_HUGETLB_NON_HUGEPAGE;
>>                 goto out;
>>         } else if (flags & MF_COUNT_INCREASED) {
>>                 ret = MF_HUGETLB_IN_USED;
>>                 count_increased = true;
>>         } else if (folio_test_hugetlb_freed(folio)) {
>>                 ret = MF_HUGETLB_FREED;
>>         } else if (folio_test_hugetlb_migratable(folio)) {
>>
>>                    ^^^^*Since hugetlb_migratable is cleared for the isolated hugetlb folio*
>>
>>                 if (folio_try_get(folio)) {
>>                         ret = MF_HUGETLB_IN_USED;
>>                         count_increased = true;
>>                 } else {
>>                         ret = MF_HUGETLB_FREED;
>>                 }
>>         } else {
>>
>>                   ^^^^*Code will reach here without extra refcnt increased*
>>
>>                 ret = MF_HUGETLB_RETRY;
>>                 if (!(flags & MF_NO_RETRY))
>>                         goto out;
>>         }
>>
>>         *Code will reach here after retry*
> 
> You are right, thanks for pointing that out. Let me think about more
> how to handle this.
> 
>>         rc = hugetlb_update_hwpoison(folio, page);
>>         if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
>>                 ret = rc;
>>                 goto out;
>>         }
>>
>> So hugetlb_update_hwpoison() will be called even for folio under isolation
>> without folio_try_get(). Or am I miss something?
> 
> Just a random question: if MF never increments a hugepage's refcount,

MF will hold hugetlb folio's refcount unless it's freed or isolated.

> what does the folio_put() in me_huge_page() (when mapping = null) do?
> Is it dropping for something other than MF?

For isolated hugetlb folio, MF_HUGETLB_RETRY will be returned and code won't reach here.
Thanks.
.

