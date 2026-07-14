Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835F9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A906B0099; Mon, 13 Jul 2026 22:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63AA46B009E; Mon, 13 Jul 2026 22:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505776B009F; Mon, 13 Jul 2026 22:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE1A6B0099
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:47:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FBC2A026D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:47:51 +0000 (UTC)
X-FDA: 84985847142.03.BC5933D
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57887C0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:47:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uZu0mxL9;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783997269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzrwMqxp5cjDNCPjRbZdcbyNqnyuVxQWfkLUQ9tLImY=;
	b=Ve2pTXBy2W7MocRq9MRkGUCMUdw1AT1mAVZlLLE1CT5HfsUbKKy1fuRLY7qhG61L4CviL6
	B7prsYOjr2rw115qYmYw0NW/pukBKzy19svfQTCFMAExt4C6f4GLLTdH36ofTz1vDxsZsn
	KBjG2ZfFOWbmxyukMosZSXslJqagKzg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uZu0mxL9;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783997269;
	b=6TwllK1qCAeZQc4vyiUB960acyw/S5Lg8yVkGiLaKWavTUZ92lhwVuUiaPmouaRrxxhWjO
	r0VEXqTLuA+33CwDiTqBC4zacSmXO1pH+JfHalXKXkU20XqQjmZtlZ9n7xwL65HRx1mjhf
	vQX9xegkuMj2HiPIe5CVd5R63c5eL+8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OzrwMqxp5cjDNCPjRbZdcbyNqnyuVxQWfkLUQ9tLImY=;
	b=uZu0mxL9OUD36Yz8hG9hNyZ3A8Rq/EZ+8J715icfxu4ftuqi/mKGVJa6r1PbPcyJ/3doxMFhK
	VHyv/cr9XZbBuTvQywVzJvhPlw9Rmaiejk7I5EsG5tDoJteT/PVDcITyIK6Ww798i9+dW84OIEt
	bDdrtcHg6mua29DuX/d4Qnc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gzk520VRLzcb0T;
	Tue, 14 Jul 2026 10:38:30 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id B2E7F4057D;
	Tue, 14 Jul 2026 10:47:43 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Jul 2026 10:47:42 +0800
Message-ID: <8b94da35-a9f1-4729-bd1c-151da2f333ce@huawei.com>
Date: Tue, 14 Jul 2026 10:47:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: mincore: remove special handling for VM_PFNMAP
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, "Liam R . Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
 <20260710120052.103886-2-wangkefeng.wang@huawei.com>
 <1bd96ae4-f59d-4103-a700-f9478e88c05b@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <1bd96ae4-f59d-4103-a700-f9478e88c05b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 57887C0003
X-Stat-Signature: hi9wjaz9ydbfwz5q6gp14xoqenchhakx
X-HE-Tag: 1783997268-365263
X-HE-Meta: U2FsdGVkX1/qZJ/KrBqpQW60bayaEzt5YC7UX0IEeQ6CPUlViJ26PhNOnMTkNlO0UOnyF2M9Gy/QmTN34aRfe6d/4CvMEKVS8Ubcyz432voywV90Z1CKxVVqbAYP9DQHnlKu/8M1/BuFWzVLGS8bwEATwA2+al62hnfUXeFOg1LZ8bOGUIiwWsPyibV5qTtN2OvJl9ms1WBJltl0mhP976llGrT41nrIshj5FwccWXDq0xfe72P8THxxRw1tp6OSn3Eed3F2qBzKrGzNMx3oModFj3ve/z5e1uiIbHXr0HaOPMU/FtmNqZNOPnhTWUzobYunx8ig4eHiO4RbxOBudIqAHNbivyuYuhg5M02QxmHPTiUukwMu0JJ+Re3KnLSbhqwBlyBwgB7r9JyeEmiUFATB+tY6N7b9VO5TSKFamN+sIbNvg0OhtEvVrT/kXqqMx0IOajLMEh3Gssfc+BNEPEuPWQK4OAc2DUGfPpqefRHeHL0mv4m57poBzoppBm2Ok8MR7cM5DJ0zU6xeElLBlI10w+KI6WTKl3B30Prmpf2Hx7zN2uB8TW6uBdOgLErZoIVEg9I/YaA5YSgWpmGb32rO94gV6bLMNAwFB/82dG/W0amXb6BRvYUhLry7PiQ+eeSjHXqiDTAkUgKt01cLuUArdplakvOS3Iwxp6wtS7l3eglLM7CicKWEPTGUjT6do8D6myJHaVEz0GqiOMnnKtqbs77Rtx1zXgeMicRMhTNYGcnFhpTvxsHOTAXrUEFd5Kic03rRvAXekKaiLotFRn4KqIZvQMEZ7uSlC7kAPMfLsBOvp8vFQ3mB2927TE/7s3pe1XWNEd+/JAVyu5Y8HlaC7SFidkPJnEyRLygcsouSsCmMj1cf6z1uNDYLvcGjjoR0po+CvKo82H7R7t8zfW+xh0ZDCpktoRzXFuXODzcMQZNaNtRE3awb+25RV3UjO9y7NOFRKgmzuD1e5wo
 3MF3D4Dm
 KnHxTPiuWnKHuu//1gmKP4Eu7IhK/f1uqaFgP5ualMrfcVysNs89qOml1uvIJdZcbVt3Ospl0TUzqJ6CTBAbxGEO5+f2KO5fUDzx8I5wgiT5raH5inpxj/WO9RuZ2m7rSU8GfDpO94WTfnTC0hq4rdT3pkD72eHqYAI+B3mNEL4RYzObqnZa+eG0paeCd/asbQuvLAx3Rb7JNP119GuiD/ZQq330sgFLMYTOu2po2hS+zfJ4K+zbUotY65pTykq1RyKlgbhkWv2M0ZPWbTChvS1+g+E0bM27P4DSUcEQsywF866ioZLQe7S0MwC1UMyg2rVsZiv3qN5ugbqc5fkY5kk/niflHUsCPz+GuCeT7V23L5V5DfSO9PuHPUl0XEGXbBEQLgkKRJPqdetrDKHJXZkvi2iwbmGlC7Y7UmMecCsqPPsPmMymIo7siRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/10/2026 8:07 PM, David Hildenbrand (Arm) wrote:
> On 7/10/26 14:00, Kefeng Wang wrote:
>> As David pointed out, "it’s hard to believe that someone depends
>> on pages in VM_PFNMAP to *not* be present", so remove the historical
>> behavior that always reports VM_PFNMAP pages as non-resident.
>> Instead, make them now reported as resident by checking the
>> VMA_PFNMAP_BIT, simplifying the code.
>>
>> Link: https://lore.kernel.org/linux-mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/mincore.c | 10 +---------
>>   1 file changed, 1 insertion(+), 9 deletions(-)
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index 53b982803771..0eb832ee0a30 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -219,7 +219,7 @@ static inline bool can_do_mincore(struct vm_area_struct *vma)
>>   {
>>   	if (vma_is_anonymous(vma))
>>   		return true;
>> -	if (!vma->vm_file)
>> +	if (!vma->vm_file || vma_test(vma, VMA_PFNMAP_BIT))
>>   		return false;
>>   	/*
>>   	 * Reveal pagecache information only for non-anonymous mappings that
>> @@ -259,14 +259,6 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>>   		return pages;
>>   	}
>>   
>> -	/*
>> -	 * mincore historically reports PFNMAP mappings as non-resident.
>> -	 */
>> -	if (vma->vm_flags & VM_PFNMAP) {
>> -		__mincore_unmapped_range(addr, end, vma, vec);
>> -		return (end - addr) >> PAGE_SHIFT;
>> -	}
>> -
>>   	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
>>   	if (err < 0)
>>   		return err;
> 
> 
> What about MAP_PRIVATE PFN mappings with anonymous pages in there that could
> have migration entries?
> 
> I'd assume that we'd want to scan the thing and simply mark present ptes as ...
> present.
> 

Sorry for the late, thanks for your review, the current modification is
not very reasonable. After reconsidering the original Sahiko report, if
we want to remove the special handling of the PFNMAP and not split the
PUD page, we can add pud_entry processing and skip the PUD huge page,
and mark pud as resident, the change is as follows,

diff --git a/mm/mincore.c b/mm/mincore.c
index 53b982803771..dc976713ee5b 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -160,6 +160,25 @@ static int mincore_unmapped_range(unsigned long 
addr, unsigned long end,
         return 0;
  }

+static int mincore_pud_range(pud_t *pud, unsigned long addr, unsigned 
long end,
+                       struct mm_walk *walk)
+{
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+       int nr = (end - addr) >> PAGE_SHIFT;
+       unsigned char *vec = walk->private;
+       spinlock_t *ptl;
+
+       ptl = pud_trans_huge_lock(pud, walk->vma);
+       if (!ptl)
+               return 0;
+
+       spin_unlock(ptl);
+       memset(vec, 1, nr);
+       walk->action = ACTION_CONTINUE;
+#endif
+       return 0;
+}
+
  static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned 
long end,
                         struct mm_walk *walk)
  {
@@ -232,6 +251,7 @@ static inline bool can_do_mincore(struct 
vm_area_struct *vma)
  }

  static const struct mm_walk_ops mincore_walk_ops = {
+       .pud_entry              = mincore_pud_range,
         .pmd_entry              = mincore_pte_range,
         .pte_hole               = mincore_unmapped_range,
         .hugetlb_entry          = mincore_hugetlb,
@@ -259,14 +279,6 @@ static long do_mincore(unsigned long addr, unsigned 
long pages, unsigned char *
v
                 return pages;
         }

-       /*
-        * mincore historically reports PFNMAP mappings as non-resident.
-        */
-       if (vma->vm_flags & VM_PFNMAP) {
-               __mincore_unmapped_range(addr, end, vma, vec);
-               return (end - addr) >> PAGE_SHIFT;
-       }
-
         err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
         if (err < 0)
                 return err;

But more changes are needed, do you think this is appropriate,
or should we keep things as they are, any better suggestions?
Thanks.






