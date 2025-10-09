Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C0CBCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 12:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411E38E0076; Thu,  9 Oct 2025 08:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3038E0002; Thu,  9 Oct 2025 08:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D84B8E0076; Thu,  9 Oct 2025 08:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C64F8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:40:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA7CB1608A7
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:40:30 +0000 (UTC)
X-FDA: 83978534220.29.70F9E1B
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf12.hostedemail.com (Postfix) with ESMTP id C7F6A4001B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:40:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nt9cwhoA;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760013628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nix9HhEL/c4sG03TDLv98d2k5tXJxnYpgmXPJuGY7No=;
	b=X2SSS8MkPFDZQotZZ/nYDRYSI8YYqRweUjr002m9RAVJEqk7NR5MdbPsINXTv7otmGgaF4
	069Em7n9myckkIAJrgjP3kj8en5M6EubQNL1ehsRpAYWNYWNBcpv9nuQN8nZebPHbMhiKV
	+smaZf2NL9wecyB9nVQL5AcuUPY2TiY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760013628; a=rsa-sha256;
	cv=none;
	b=LwHMvjAyxKfc+JE5SXH0F2Sb+H7dQ8wcdlZ5jXBmD1/eNzc/Rq+VkXnjfPSN8De1Fkkl67
	Ay3lrnI849wjeQs3DtBh8K9Lye+Ti8yqqTybbeUrkO8ILrCxOZdwpClq8EjhhZAJZOrKjb
	LBOdYwlRJYxR16rgUyPOB2Z0QE+JGJI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nt9cwhoA;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Nix9HhEL/c4sG03TDLv98d2k5tXJxnYpgmXPJuGY7No=;
	b=nt9cwhoAzHmYm1BIa0qGecNB1UoM90kxaDHOtHEmePWoKnnPv9fYSwKffKz+XDZ+ruXXikJ1M
	EWDC1WZHnlDTgK+ioJuE0aL05lXgc4mVHtK5morgA6jslU7HdctdCE+sFoV23l54lX7gJDVgvNB
	BZNfIK75FaAbKySs1kgCmos=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cj8bP6G53zKm9W;
	Thu,  9 Oct 2025 20:40:01 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7B49A1A016C;
	Thu,  9 Oct 2025 20:40:18 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Oct 2025 20:40:17 +0800
Message-ID: <4280197e-1605-4944-8627-0aca66aa7b40@huawei.com>
Date: Thu, 9 Oct 2025 20:40:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] mm: cma: add __cma_release()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-7-wangkefeng.wang@huawei.com>
 <4a4321e2-53bb-4fe5-988b-5b5eb57a855b@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <4a4321e2-53bb-4fe5-988b-5b5eb57a855b@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: 5bz6hracom63jp8y6aqc8kpfqmrxyn8f
X-Rspam-User: 
X-Rspamd-Queue-Id: C7F6A4001B
X-HE-Tag: 1760013626-539648
X-HE-Meta: U2FsdGVkX1/Ldc6Y/GL1pTcp1w9iX6nlMdgVI02alUCKADwry3ba2PXoMR50O//gk8BDNnjovflNSslkLdWzo6l1Iu1zX76K/SIrAmYlJFlPwBXjE/Is9lFEOCvDq4rSSE23RrpGROyiAXxm1Yg3+HJ4xoHbIhbegLLJgHTKVPDQTxmQckqYfypT6O3oD4wCQBi9vIySZogQbyw2o5uh/dYqxFhpDSG67zIa+FzODS+MNmsCm0ShwcD7GGfvCzosP6dRClgxa9T4E2kVNeQ7U5qXvy8fE7mMif+g3+lBXftWrOHIEMd6LM/y8oeB7L1iVW3MBvg4p8mAGAI05OdGRpvXzg8O7RtSHeFk2JpUAd/9IeSlw/bJa0V9JL4pN1L3sguHdRfAjuoLakUCM0SGe5V1ZcpTD6tKtnztt0WAzgnto055c+TvOiep+L/mldU0xq7WJjbQ5xkwbebK/HNZSxHDx2LzvPNQ/LpTb7TFbf6SOSH+WqyZ8PlUo7wWrr7tsdBVx9Ct+Xv1D1R2657O8kPSxhbA/QRrrbAIxhRdJQTLEEOwOwr4G6GuWYj71csBi4j9lWbrrETUktPThB1FgANkDwtKWgeFcNhW9ZZPdPUXhnIOZ2OKvTAyByehYXvRU9c0bonLXUUHW4+ScjJ5czwmGHCsYacZzbkftI1Qu1Onc8gXZj70rBDPiFcIfUuxp3GzSVZPx3L1QMiKOdCEIihduJpopu+fcYh/OZ686TstB8x/fpSJbrM1TagzkqIe+Yq1ZPz83q3U2NBLnQj0jBk77ZJgqPuDeW7nXnrkm1TuhMgdc7VaR9ZqqXHYbUW7Up2V5kyYtCvhELId8zR/7CxkYH8L4GyJ/SdID+iO4LEvXPMoiII2KnH/YpPaNAKYAfTd7Z1zeRkD+m6htxzn18iAnPiwDiUHEIxtgs1afU2HDhI/85U04K+DCH1OQeF90DlQcfO3+pkNhSTjP1P
 njf4xEj2
 faXwC7CBRTXG7Vd+ZcwF7cz+rM858LjLW7aaAFEKzbnATE4CnYwMD8hz6+Nta+PlLgxEfFATq4Alrj9WIH45a2I36Tmun4tOqv3C6JRTGg1iAsXA9qD7Q7AtLoc4xmlRyfsUc6Nz5mIVTvSPUNsTxrSXEHYIf0gNqkav06yEd0hSa2qQJiASeHBmukFDU58DKIXMz8vcTavN/9GU8HQ0Oo+E42dU0Gz9lvkBjNVB/1+IGETzcbiBj0MDtDAm8oZ6XGV1bTiVG4VRP0NfPw0BDVkOW3FvbgGkU9PVmKnx58Lkwi+3Hlvdujf+86MPKJMx1Sb6PVoHT0m9dkOK+sNYBZdHDiH+JQoXorlFn/SOh1O9Vbazz15cWDcAze5y9pWs0q7fMU8z+sosqFcXayGeQhFzh7BFL0LegmLAqtt7loi9zrr3wUYhF3pw9NA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 18:15, David Hildenbrand wrote:
> On 18.09.25 15:19, Kefeng Wang wrote:
>> Kill cma_pages_valid() which only used in cma_release(), also
>> cleanup code duplication between cma pages valid checking and
>> cma memrange finding, add __cma_release() helper to prepare for
>> the upcoming frozen page release.
>>
>> Reviewed-by: Jane Chu <jane.chu@oracle.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/cma.h |  1 -
>>   mm/cma.c            | 57 ++++++++++++---------------------------------
>>   2 files changed, 15 insertions(+), 43 deletions(-)
>>
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index 62d9c1cf6326..e5745d2aec55 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -49,7 +49,6 @@ extern int cma_init_reserved_mem(phys_addr_t base, 
>> phys_addr_t size,
>>                       struct cma **res_cma);
>>   extern struct page *cma_alloc(struct cma *cma, unsigned long count, 
>> unsigned int align,
>>                     bool no_warn);
>> -extern bool cma_pages_valid(struct cma *cma, const struct page 
>> *pages, unsigned long count);
>>   extern bool cma_release(struct cma *cma, const struct page *pages, 
>> unsigned long count);
>>   extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), 
>> void *data);
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 813e6dc7b095..2af8c5bc58dd 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -942,34 +942,36 @@ struct folio *cma_alloc_folio(struct cma *cma, 
>> int order, gfp_t gfp)
>>       return page ? page_folio(page) : NULL;
>>   }
>> -bool cma_pages_valid(struct cma *cma, const struct page *pages,
>> -             unsigned long count)
>> +static bool __cma_release(struct cma *cma, const struct page *pages,
>> +              unsigned long count)
>>   {
>>       unsigned long pfn, end;
>>       int r;
>>       struct cma_memrange *cmr;
>> -    bool ret;
>> +
>> +    pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, 
>> count);
>>       if (!cma || !pages || count > cma->count)
>>           return false;
>>       pfn = page_to_pfn(pages);
>> -    ret = false;
>>       for (r = 0; r < cma->nranges; r++) {
>>           cmr = &cma->ranges[r];
>>           end = cmr->base_pfn + cmr->count;
>> -        if (pfn >= cmr->base_pfn && pfn < end) {
>> -            ret = pfn + count <= end;
>> +        if (pfn >= cmr->base_pfn && pfn < end && pfn + count <= end)
> 
> Are you afraid of overflows here, or why can't it simply be
> 
>      if (pfn >= cmr->base_pfn && pfn + count <= end)
> 
> But I wonder if we want to keep here
> 
>      if (pfn >= cmr->base_pfn && pfn < end)
> 
> And VM_WARN if the area does not completely fit into the range. See below.
> 
> 
>>               break;
>> -        }
>>       }
>> -    if (!ret)
>> -        pr_debug("%s(page %p, count %lu)\n",
>> -                __func__, (void *)pages, count);
>> +    if (r == cma->nranges)
>> +        return false;
> 
> Would we want to warn one way or the other in that case? Is it valid 
> that someone tries to free a wrong range?

The original cma_pages_valid() check start pfn whether it is in cma
range or not, and the range must be within the complete cma range.
The repeatedly check "VM_BUG_ON(pfn + count > end)" in cma_release()
is never performed since we return early after cma_pages_valid().

> 
> Note that the original code had this pr_debug() in case no range for the 
> start pfn was found (IIUC, it's confusing) and this  VM_BUG_ON(end_pfn > 
> cmr->base_pfn + cmr->count) in case a range was found but it would not 
> completely match the

So the VM_BUG_ON is not useful,
> 
> You're not discussing that behavioral change in the changelog, and I 
> think we would want to keep some sanity checks, likely in a 
> VM_WARN_ON_ONCE() form.
> 
> 

But for the error path, adding some debug info is better, a quick diff
based on this patch, what do you think?


diff --git a/mm/cma.c b/mm/cma.c
index 2af8c5bc58dd..88016f4aef7f 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -959,12 +959,19 @@ static bool __cma_release(struct cma *cma, const 
struct page *pages,
         for (r = 0; r < cma->nranges; r++) {
                 cmr = &cma->ranges[r];
                 end = cmr->base_pfn + cmr->count;
-               if (pfn >= cmr->base_pfn && pfn < end && pfn + count <= end)
-                       break;
+               if (pfn >= cmr->base_pfn && pfn < end) {
+                       if (pfn + count <= end)
+                               break;
+
+                       VM_WARN_ON_ONCE(1);
+               }
         }

-       if (r == cma->nranges)
+       if (r == cma->nranges) {
+               pr_debug("%s(no cma range match the page %p)\n",
+                        __func__, (void *)pages);
                 return false;
+       }

         free_contig_range(pfn, count);
         cma_clear_bitmap(cma, cmr, pfn, count);


