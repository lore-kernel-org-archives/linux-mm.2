Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE56C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F4E6B00C7; Fri, 26 Jun 2026 11:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7CB6B00C8; Fri, 26 Jun 2026 11:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924FF6B00C9; Fri, 26 Jun 2026 11:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3DA6B00C7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:21:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0705D1C2DA8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:21:46 +0000 (UTC)
X-FDA: 84922428612.20.196873D
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6C5E78000F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:21:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QU91VQVH;
	spf=pass (imf02.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782487304;
	b=AEOMaRHs4tuUBxi3d6XXdmQAn3DtQmHAaoAgbRoPDS6IIKHFgZvnsHIXrHUXtGb3gP5utF
	KwAh4DWroTaK1vGudtmsP5tvksCZwVTiCvsqCl56yDHY165CjtaH+bafcdZqG5QkKxpmfx
	gcTOO6KkQrH3VkQ9AoCUty4eUT2bKxA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782487304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNCYKVE27VxWpXYAGmlJv6SQuDIxBX7azTaR5qeDO3Q=;
	b=Dvk8QlTngVi2UPz1tBlJAEwHY+Of5sp7n7mL+sA2zaurlHhvI+VV964YqEbCQFsKdNPI+2
	3tt1TiRYGgATCJZE6Uae8n/BqldJqP7AvmmAMj2DKC++N8BFwjLL1q8uc7Hk0awFf87+Cv
	RplThhp7GeIJBaXvmi6lWEfZfcXXFxQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QU91VQVH;
	spf=pass (imf02.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aNCYKVE27VxWpXYAGmlJv6SQuDIxBX7azTaR5qeDO3Q=;
	b=QU91VQVHMndMS9qxF8aJB9IQwCEIwl6VigT5OLl0Rm1znin7o97+hcGwytUjx92i1OYtaiCkL
	eJ0FDRt0OPtdgQhKcTPgv0adxSL6aorzCnaEFN0yXSFRJvQZF5UNlNBAFv9zy+7CBxBfu5jLTC7
	vn2v6vVxTFNZ85Xm0utkzB4=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gmzhF3vDczpStK;
	Fri, 26 Jun 2026 23:13:17 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 011AA40561;
	Fri, 26 Jun 2026 23:21:37 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Jun 2026 23:21:35 +0800
Message-ID: <1b34ac03-edf7-4219-a334-1e7b7292129b@huawei.com>
Date: Fri, 26 Jun 2026 23:21:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
To: Andrew Morton <akpm@linux-foundation.org>, Alistair Popple
	<apopple@nvidia.com>, Gregory Price <gourry@gourry.net>
CC: Pedro Falcato <pfalcato@suse.de>, "David Hildenbrand (Arm)"
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett"
	<liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
 <ajPZlxq5z1hyo1kE@pedro-suse>
 <42e167b2-5676-45fd-8f3a-738d2f4f6623@huawei.com>
 <ajP9bQhmvR9OX0VE@pedro-suse>
 <e7244b54-d794-4e46-88e7-69204da2b60d@huawei.com>
 <20260624193852.2a1ac8a187978e4baa75f47e@linux-foundation.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260624193852.2a1ac8a187978e4baa75f47e@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 6C5E78000F
X-Stat-Signature: crwcqrfdbk8yiqckndy3t1meysqeo1sn
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782487302-44308
X-HE-Meta: U2FsdGVkX18uoqfBCOD9KvCWxxRGbA5VDsFhmroP96Gc+q1vWbpU+eVho9RpHKxls+S8O21677cq4kxE/43jTUwRS7jJzs+gQApFCuXam3/t5wQM1T0qszLdxXM6xlhpOGbb2ebvY3DCzrF2RLawjqMaPJQKyez2lpKXMCc6guXMa3PDiAeaFSmToqQrFFoTxjlaZGv5LiEIcUp2qgzI2cevtrC8Bo85Nm+GUJzBEOM6kcbcMl/D11iuRceZd9B+dp8H/IPkTjIjLl29OHYx7y0cYGTQ+noxnwb7MVPizsZWHz0JKOxH8/2wk3S888eyjj9b40jniDLqbqsldYG8MCmnvnSqBZdr/EFAG9gmb24yzajVo98C1lK1r6vNetNz9pjpmeovAj+0wat7dZgSOS/tLmYZRHpKlpVj4YiMNQFs6U0V+kdSm2179t2r4tFYbPHr+9xGSbsRPMFRH/KmGk9ty2GR4QBFYuFb/t4VaciE+xObYAeFJCNMyqW7f/SJ6NE87a0Vj5KScKDa4yiBY2StHuHMIENKJ9UrFFT33PkG3PYbKbokuvFsmsqf6eI8stpXYS9cjEWfymVq40Kt8UWGkPTJHx+DBK8/vM+jPjU9+vRo3NjsvHfvrigBsfuR45zdhtd1zQ15iuY77rjGDDRp9l4UqN/l76cWmUqYCxe4ykwLgxzZX1LOY4Lb6BI97buP39t26F9s/ZzeYwtGtI+InGXZBqGlYOsfF5KBqOMdE3dZ5OtoALvF9h9vn9LuMH/omd79KUdblGKnRlncXTq6R1GINl6pkvd/47lZC5eyTF2d6k3DRXigIXR5299neYq6znMUGxFKM+K+97t/K4mGujJpzkm/8DkmpXD/9gASogtGl9Kg+NpTVBfUkALavbjVsuJ1yPw1f9zXCp3Am52a5vkwf6MIwGz9bt5ROZsfmLxrDmFlS6wvyt9yvfmo5mtiaT+rGDGmw8fathR
 8wiDWsvt
 jmjRIDw+63o6kXiRL5jfinWlJeVF7QrqXymDrLh6xQy62Junhr1rChREX0fK20u1I6QvhjdJCnIfdK5s7koVMn2OfENd7asEiNaVPI0NE0FDAXoTF+hpbeLrddXaIrkaVWJ5tBRWmncC6ACTsqdedTPy37A9G38yueF3frxBBZSWGZ/8g2gF/IXf+mbaqCGZqr1eyhCZWo0eImtnWuijbHpoPlX4u2GYbm6GYhsUL/ICwgOmKMBzf0GLQOiQ2fm2zEEL47sVETh0cFAKcPozqNgO3g3BR75S9XLqAgqCI/OvzwNLbWu3brQSxCWZZj6uoHt1S6U/sBV2543IWVweX4wOWuzfCaluipxQxHJuTCcL7rSSzA1rr1cDU+kXYXqLWE806k0zOakZ+aJPK6uaM0nbScVnYxxR2NGbjMThKUV3NWJGb70h6GOU/CYgX5dqeU2N9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/25/2026 10:38 AM, Andrew Morton wrote:
> On Mon, 22 Jun 2026 11:23:11 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>>>>>> -	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * walk_page_range_vma() does not call walk_page_test(), which
>>>>>> +	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
>>>>>> +	 * page table walk. Without this check, PFNMAP PTEs would be
>>>>>> +	 * treated as present by mincore_pte_range(), changing the returned
>>>>>> +	 * residency status from the historical "not resident" to "resident".
>>>>>> +	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
>>>>>> +	 */
>>>
>>> I would rather we amend this comment to something like:
>>>
>>> 	/* mincore (historically) reports PFNMAP mappings as non-resident. */
>>>
>>> because we don't need to explain internal differences in walk_page_range
>>> functions in a random comment in mincore. And perhaps attempt a separate
>>
>> Hope Andrew can fix the comments when pickup patches.
> 
> I added this:
> 
> --- a/mm/mincore.c~mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
> +++ a/mm/mincore.c
> @@ -261,12 +261,7 @@ static long do_mincore(unsigned long add
>   	}
>   
>   	/*
> -	 * walk_page_range_vma() does not call walk_page_test(), which
> -	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
> -	 * page table walk. Without this check, PFNMAP PTEs would be
> -	 * treated as present by mincore_pte_range(), changing the returned
> -	 * residency status from the historical "not resident" to "resident".
> -	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
> +	 * mincore historically reports PFNMAP mappings as non-resident.
>   	 */
>   	if (vma->vm_flags & VM_PFNMAP) {
>   		__mincore_unmapped_range(addr, end, vma, vec);
> _
> 

Thanks.

> 
> Sashiko is OK with your patchset, but it might have found four(!)
> pre-existing issues:
> 
> 	https://sashiko.dev/#/patchset/20260618092845.3905740-1-wangkefeng.wang@huawei.com
> 

Sorry for the late, this is pre-existing issue, I am not familiar with
zone devices, so just focus on my changes and the subsequent
changes related to mincore.. After a quick review, most of them are not
issues based on my understanding.

+ CC Alistair and Gregroy for migrate_device.c, also Zi could you help
to check it?

1. mlock.c, ACTION_AGAIN
2. migrate_device.c, goto again array overrun / double counting
3. migrate_device.c, softleaf_to_folio VM_WARN
4. migrate_device.c, pte_pfn / pte_dirty on non-present PTE

I think issue 4 is real issue, a quick fix is

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 554754eb26ff..3ccc4fc1015c 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -401,7 +401,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
                         bool anon_exclusive;
                         pte_t swp_pte;

-                       flush_cache_page(vma, addr, pte_pfn(pte));
+                       if (pte_present(pte))
+                               flush_cache_page(vma, addr, pte_pfn(pte));
                         anon_exclusive = folio_test_anon(folio) &&
                                           PageAnonExclusive(page);
                         if (anon_exclusive) {
@@ -422,8 +423,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
                         migrate->cpages++;

                         /* Set the dirty flag on the folio now the pte 
is gone. */
-                       if (pte_dirty(pte))
+                       if (pte_present(pte)) {
+                               if (pte_dirty(pte))
+                                       folio_mark_dirty(folio);
+                       } else if 
(softleaf_is_device_private_write(entry)) {
                                 folio_mark_dirty(folio);
+                       }

                         /* Setup special migration page table entry */
                         if (mpfn & MIGRATE_PFN_WRITE)

But as I said, I am not familiar with it, just a thought.


