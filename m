Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17FDCCD4F5B
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 02:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDB76B008A; Tue, 19 May 2026 22:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD926B008C; Tue, 19 May 2026 22:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EABD6B0092; Tue, 19 May 2026 22:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF736B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:45:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F4E640010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:45:23 +0000 (UTC)
X-FDA: 84786256926.10.E62E29C
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf28.hostedemail.com (Postfix) with ESMTP id 508C3C000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:45:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rsbXVopE;
	spf=pass (imf28.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779245121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITcZIjs6cfJQdcTR6lonEEJhWi9+Qwto61+SzN6fl3I=;
	b=Vsbo+ubQY9u5PamqvEvdqyStDGQm0bWlUVeJeb5J2l93edxf5NNAM3xAKw1v3kOWAoWiL5
	DR8sY+GhoxUdWd9IMwFkhpduf3LragJ6VO/hOmW2xQDTKcQXA92W8XyOCuCH6cfeSKh+B9
	phdflDdBHJW++tzsEgY8m3cNNZ6uyJY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rsbXVopE;
	spf=pass (imf28.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779245121; a=rsa-sha256;
	cv=none;
	b=ZBIsjq+5yrVMhDRYONCiUbxrlQzeoCINb1+Y88lqgu/Uf94CFlGKJmomU2/HCPRyxRESEd
	U7K9aF3JA/SNb5InjVOwbh6qsz/1lgrO/3uOeGuf8X/w8X/aYs6zPizAeWg+IF0u4NXh7a
	rpXjglkomsSpYDbWLXUb1MGhgPv5ik4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ITcZIjs6cfJQdcTR6lonEEJhWi9+Qwto61+SzN6fl3I=;
	b=rsbXVopEtEDev2MnXGPKUq4c4AtLmSXimYMvIF5/e5SZlCPV0V0NZt9Hk7r2mhOmIS7Gm/c9e
	Ijf7XKpZw0mAjZXDzhrgI0BRbxou5T/FiHusjBeCVFn+UPjgY1R2RmLM/3V9c7V+9wUDvxFde5X
	3t4FjzcmwcTK8qij5XfnKhc=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gKwgL04NLz1prLd;
	Wed, 20 May 2026 10:37:34 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id B0C382025F;
	Wed, 20 May 2026 10:45:17 +0800 (CST)
Received: from [10.174.177.15] (10.174.177.15) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 20 May 2026 10:45:16 +0800
Message-ID: <5f58f798-1bb5-45bf-a0c2-7d9794d6ad67@huawei.com>
Date: Wed, 20 May 2026 10:45:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
To: <wangkefeng.wang@huawei.com>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <mike.kravetz@oracle.com>
References: <20260520020128.3506168-1-mawupeng1@huawei.com>
 <07873271-6671-4092-becb-7b2cef4217a1@huawei.com>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <07873271-6671-4092-becb-7b2cef4217a1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.15]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Stat-Signature: 5q57ww1mc7up5ex585rr9x7969yd8wrq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 508C3C000A
X-Rspam-User: 
X-HE-Tag: 1779245121-11669
X-HE-Meta: U2FsdGVkX1+OM+E7ZIjkpa9OiTPqUaGj3XSv3QA8joaQFACDNeCnngvJkPr5YW0/TYc8tjbegviSiAoDHdfcPlET44B97FzOlKGDeiXdesXKgAt9OF6IiAqStL5kquAsXf3PpSNQD9zUtRUQQOGWffVL9vUDmWyF2Bes1E9OxtEMkk6D901RSdmC20nrEcUlwzD9uL1KmknvhBYHAWni/sDm6eDodPYviFAeA+KBA/Qa26pYWkpHUNcnWkXs1iowFdVcGKl0wc1lzOI2MHemxOKe/H4ci0Eun0cQDuYO3DCw7xhNHDXW8qIKQ3IWt9u0tMFH4mIy/bh0sRK+e7aGXuTfWgLFuA6VSC/HPYqteyn/yd7EHyCOUPp2V6HYoPpGLyj/L25q9YzBOika24mka3kD7V1YuQJIcBl+KhzbKLHFaNLoRnuSOwCvmGsw8PtjtDLSA+aOrUcE+S7NU1BTTTtpn6sB6obGfeWj1m7Q5B2kqdyp5SULp+511GEszy7OHyBbSKmr7ZcanLPWmchUBfFhU8j/hDVneHVvqSkLarmJZF6j+0dajNMADLIViicgw+cvH78rAvZ1RafXpPAQzYYYIuueHwco86Gbm3dMq+aoVp14ded2VLqw34oh220FFn0FlXlmiqC8Igsw1mGyrZH4QWTlNKE2voAxCaCUqrYeOMkIEvyxZiwtQPEw8uOWpg6Vt38l+pKtN+XYDKslnmRuxFt9NPOXASDWH8jke+H7ZtZNxeDcWPcT3BYg4CxZA3a8SWve5CPMdDbNqq/75tEuyFSTKaVL6B9XE2SL0K7GLoF8+PuxHEypWyznvMjXpkTn5i9jiaKpJHBbVrhAo5ZF2Zi380zRWUGBJemmrg0vyuJdtaqpE/qinr0pJOYaBzQSlgZMrLgQVlMXs21J7REv/4uXcTdFaTfblzZYsidRGqqj7oYONpGLctGFLGTkCa0smJd+IYuXgyOKfgO
 IXfOTMCa
 kiAC87MmSpSZRJKObGDZzI0W9hYNil4z+zMt8b/Yw3kJR5i5Nt2iIO4Qj965EBarA/V8WC9iIKeZzWutjQpgcKXFjukb4rVgOBcCOlZCk61n0IEJyypvoAkzly8orCQYgWlDx1DMTFCsTqAjcjL6/AzJa2+Rgtcb8PxrVl0mMDa+O5dsgF69JVjqaWEU16c9BV+XP6LPVmS+x1KqDBGKjCy3oK2mGzpAd3pL1+nQnurA8W2qYSxCcTI+wnAnHA+4RWdyRK9YyLIM8f0DeSldjMcsaH6+QmZWAv1/JqeErYLp9d0bYdDVq1CpFun1KeBEfcmgroKan+Uz2PNaFHkyUgrC5OoUS9bryMoDEtVdXrBbLuGDqPWfitTASkCkS3RMWeX2jWz0Cz4p88mc8Nt4C6W6WJXlIZqlUfoQbf7XTIe+fUU3mkQLcKCHfFkIwdlIXjitadY4lKPXVryV+dySdXAW/usi5NFPTfTjZhvLClQVWaM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 周三 2026-5-20 10:40, Kefeng Wang wrote:
> You should remove the v3 since this is the first version for mainline.

Thanks for reewing.

Sorry for my mistack, it will be removed next time.

> 
> On 5/20/2026 10:01 AM, Wupeng Ma wrote:
>> madvise(MADV_HWPOISON) can trigger a recursive spinlock self-deadlock
>> (AA deadlock) on hugetlb_lock due to a race with concurrent folio
>> unmapping.  The race scenario:
>>
>>    Thread 1 (madvise MADV_HWPOISON)          Thread 2 (unmap)
>>    -------------------------------          -----------------
>>    madvise_inject_error()
>>      get_user_pages_fast()  <- refcount++
>>      memory_failure(MF_COUNT_INCREASED)
>>        get_huge_page_for_hwpoison()
>>          spin_lock_irq(&hugetlb_lock)
>>          // refcount == 2 (gup + map)
>>          // MF_COUNT_INCREASED path:
>>          count_increased = true
>>                                             zap_pte_range()
>>                                               page_remove_rmap()
>>                                               put_page()  <- drops map ref
>>                                               // refcount: 2 -> 1
>>          hugetlb_update_hwpoison()
>>            -> MF_HUGETLB_FOLIO_PRE_POISONED
>>            -> goto out
>>          out:
>>            folio_put(folio)  <- drops gup ref
>>              // refcount: 1 -> 0
>>              free_huge_folio()
>>                spin_lock_irq(&hugetlb_lock)  <- AA DEADLOCK
>>
>> When Thread 2's put_page() drops the mapping reference while Thread 1
>> holds hugetlb_lock, the folio refcount drops to 1.  The subsequent
>> folio_put() at the out: label frees the folio, and free_huge_folio()
>> attempts to re-acquire the non-recursive hugetlb_lock on the same CPU,
>> resulting in an AA self-deadlock.
>>
>> The same deadlock can also occur on the folio_try_get() path: when a
>> migratable folio is found and folio_try_get() succeeds (refcount rises
>> to refcount+1), a concurrent unmap and a hugetlb_update_hwpoison()
>> returning pre-poisoned status will land at out: where folio_put() again
>> may free the folio under hugetlb_lock.
>>
>> Fix this by removing the hugetlb_lock wrapper from hugetlb.c and
>> moving the lock acquisition directly into get_huge_page_for_hwpoison()
>> (formerly __get_huge_page_for_hwpoison) in memory-failure.c.  Place
>> spin_unlock_irq() before folio_put() at the out: label so that the
>> folio is always released outside the lock, preventing any recursive
>> lock acquisition.  
> 
> 
> The following comment is not useful and correct for this version.

Thanks for reviewing. 

Will be removed in later version.

> 
> Remove the now-incorrect "Called from hugetlb code
>> with hugetlb_lock held" comment, and update the stale
>> __get_huge_page_for_hwpoison declarations in include/linux/mm.h.
>>
> 
> The change is lgtm,  Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> 
>> Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
>> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
>> ---
>>   include/linux/hugetlb.h |  8 --------
>>   include/linux/mm.h      |  8 --------
>>   mm/hugetlb.c            | 11 -----------
>>   mm/memory-failure.c     |  8 ++++----
>>   4 files changed, 4 insertions(+), 31 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 65910437be1ca..aa3eb42e0a01a 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -153,8 +153,6 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
>>                           long freed);
>>   bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
>>   int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
>> -int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> -                bool *migratable_cleared);
>>   void folio_putback_hugetlb(struct folio *folio);
>>   void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
>>   void hugetlb_fix_reserve_counts(struct inode *inode);
>> @@ -422,12 +420,6 @@ static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
>>       return 0;
>>   }
>>   -static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> -                    bool *migratable_cleared)
>> -{
>> -    return 0;
>> -}
>> -
>>   static inline void folio_putback_hugetlb(struct folio *folio)
>>   {
>>   }
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index abb4963c1f064..46e5936dabaa8 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4602,8 +4602,6 @@ extern int soft_offline_page(unsigned long pfn, int flags);
>>    */
>>   extern const struct attribute_group memory_failure_attr_group;
>>   extern void memory_failure_queue(unsigned long pfn, int flags);
>> -extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> -                    bool *migratable_cleared);
>>   void num_poisoned_pages_inc(unsigned long pfn);
>>   void num_poisoned_pages_sub(unsigned long pfn, long i);
>>   #else
>> @@ -4611,12 +4609,6 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
>>   {
>>   }
>>   -static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> -                    bool *migratable_cleared)
>> -{
>> -    return 0;
>> -}
>> -
>>   static inline void num_poisoned_pages_inc(unsigned long pfn)
>>   {
>>   }
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 327eaa4074d39..4c99bb868ad08 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -7170,17 +7170,6 @@ int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison
>>       return ret;
>>   }
>>   -int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> -                bool *migratable_cleared)
>> -{
>> -    int ret;
>> -
>> -    spin_lock_irq(&hugetlb_lock);
>> -    ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
>> -    spin_unlock_irq(&hugetlb_lock);
>> -    return ret;
>> -}
>> -
>>   /**
>>    * folio_putback_hugetlb - unisolate a hugetlb folio
>>    * @folio: the isolated hugetlb folio
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index ee42d43613097..28522180cf7f8 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1966,10 +1966,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>>       folio_free_raw_hwp(folio, true);
>>   }
>>   -/*
>> - * Called from hugetlb code with hugetlb_lock held.
>> - */
>> -int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> +static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>                    bool *migratable_cleared)
>>   {
>>       struct page *page = pfn_to_page(pfn);
>> @@ -1977,6 +1974,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>       bool count_increased = false;
>>       int ret, rc;
>>   +    spin_lock_irq(&hugetlb_lock);
>>       if (!folio_test_hugetlb(folio)) {
>>           ret = MF_HUGETLB_NON_HUGEPAGE;
>>           goto out;
>> @@ -2013,8 +2011,10 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>           *migratable_cleared = true;
>>       }
>>   +    spin_unlock_irq(&hugetlb_lock);
>>       return ret;
>>   out:
>> +    spin_unlock_irq(&hugetlb_lock);
>>       if (count_increased)
>>           folio_put(folio);
>>       return ret;
> 


