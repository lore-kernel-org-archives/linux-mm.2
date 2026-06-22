Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEAB9CDB46C
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 03:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC8F6B008C; Sun, 21 Jun 2026 23:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ADD26B0092; Sun, 21 Jun 2026 23:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA396B0093; Sun, 21 Jun 2026 23:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6BC6B008C
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 23:23:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D28931C3120
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:23:22 +0000 (UTC)
X-FDA: 84906103044.19.9C1B48B
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf17.hostedemail.com (Postfix) with ESMTP id F2DFB40002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:23:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wqKD5UdR;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782098599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tsqHPip2P3LiSD3rz1kuSHiYcQw8l/wT4JyEGYte04=;
	b=uq5qua2QFT2byE8ghMR9UT+wUiK0KyxxBk+UUjpvwwBwMX9j6J4MROoYUwVwhHuKgD0fgV
	tLGFwdD2HWRMB9o5Nnrts1W+WMLtSyCqBlIRkosgMagyUxgPr6k/dDguM45G05QoE9zIbr
	5lpMCTcqgouBdn9mDV6R43oMH1mYfPc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wqKD5UdR;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782098599;
	b=KKlrZ5zjZqnIltBNAqaf01WA5WxtEM8P4Lw/OLpmgX04euTdwI921C+7CKu5Pmb4JB2Yaq
	v2BLmDHYhx9avkq8gA/2z9AbpYcBFbQimVX7n19GZ/dtzPuC9U2O2MgV2O9pjV2+qgb2AC
	hsQXWP51dEmlsM6FXjMr7Q6Sh4tydXI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0tsqHPip2P3LiSD3rz1kuSHiYcQw8l/wT4JyEGYte04=;
	b=wqKD5UdR2S2lFXYriHkiqlnJDry5o26mv+qpULNlmhYReVWIjSCHzphpKT2dV6mTLCT0tmf3E
	yLv391wMjb8dKRGJ99pcR1lUjFC96vh5X10aRR2YcuT7p6uWjjrXBIz9hAjk78MZRGtLtT2hZzI
	ymqva5xLJdFXCQEkhz9BVx0=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gkCwM4vpwzRhvh;
	Mon, 22 Jun 2026 11:14:11 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 4C7BE20226;
	Mon, 22 Jun 2026 11:23:14 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Jun 2026 11:23:12 +0800
Message-ID: <e7244b54-d794-4e46-88e7-69204da2b60d@huawei.com>
Date: Mon, 22 Jun 2026 11:23:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
To: Pedro Falcato <pfalcato@suse.de>, "David Hildenbrand (Arm)"
	<david@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, "Liam
 R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
 <ajPZlxq5z1hyo1kE@pedro-suse>
 <42e167b2-5676-45fd-8f3a-738d2f4f6623@huawei.com>
 <ajP9bQhmvR9OX0VE@pedro-suse>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <ajP9bQhmvR9OX0VE@pedro-suse>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F2DFB40002
X-Rspam-User: 
X-Stat-Signature: bsqcad5g7m6kqtri1a1qi6fa6h6qhj9k
X-HE-Tag: 1782098597-906506
X-HE-Meta: U2FsdGVkX18b+GafRnaowkADlk5yrRDER20gLYDnqSXhiVhN8ZOnpD1VrV9W7LRgo0dQeutqyG82seaoPFE1maKcr2XOhuFLsz2vtN9RJGNOGTzXBGUl/nS1hfhDxFLKwwiv86Ld6EHCNHDk9JSR2ruSNMRyRMHF7LkJsxWjZOY59ggYnL6HR0vn9x+VlN2nG5uSOe9iscMlJNAbNSB1JKEJxVixe516/1xLBh6DF9nX6tw6elXUtqPuKO/6nOqifAaSLA2TbvXNfESQ08wnngeIpv1uIB3FEtZ8Hp3KPW2cmbg3zFNCbICD8cziH9s6CbdWsRUpewmX8pkhJ9MXKczth7NFQKvvRMGXvZCEh9eMU0or6O4peeFCye6zU9CPtVk2IKp8rceYZ899tZaXDD0eW9+BAVW4C+BjaPuSsod2tUmWuPJmVlulCW8pj0MSlvjtSgSUtIFSPqTRILXQ1+PpYWTj3sntUCqBtEGpJR4XXMYixyTSqfglKfHsABidamlR/mG51AZ522BwGlXFxxpaJ+HJU68q6xR9THmOOlVlIW08HCaH/NdovuIu57kpJrAml/GCVhqapSUvCIlMdjU/fkNCmABznjlqaJjwhW8qW2wgde5Dni6XmsxQmlD1tEXOohVRkIyNN2nAiHsfDjBVBF7LHnR/TV2WMxKD8E9SwD1I8uqLUYzUbwyS+m7PQl5Vl/HCG3BVh67uCFfryFq/09Ei15gEx5qlKCQFdMOpy7XHQqBq/70RHEfGOaIItkMHktgNPVmdbBWtJzFuULcmm42V+YeYYNshQM9hEhnhTfmsTUCM4vm3B0cKUbKjjvpeqyEcLUDrGrjaIDaELBS22CP9gwojYKMj1jjdtoEmnb2m14mEeRAuUztQJ2HGWGOaa5IUER6/+CrNzhANdfw7wvuQ2xkQ7qG74o6YJLrjrLZ8hJ51D4CULhPYQSux8jHWYFwTtCz0SJPeSu7
 9sgMjT04
 gsXVUkth1cxrmJ5u3mxs7MKsqY6CijAyIy4pvHhGBhamb2TY1xDlosdIc0zKZa6Z86kjKfp8Rco3isS4fntnLoVVaPdgjk7gxa+Dfz4o7DywjIHGe9aG9F6iInzopGC4jagChIac6IYGUWzrnvC5nEOkETjWIdYLxQMpvduPZ7wVERi2lW2tnX3r9/b678trgaL3A7u2YujCVptmxrIqiA0g3g43DJ0+ngs2CWdqzQs7CzdagT8R/xrfreT9YykuT/U9wrtPB9CFElOQ1d7TJM0jNNtOD5JuEeAu3seXeXi2T0usI3qcSKX06zIhDOfiStentkW58i76tcLn9qNxJDkUcbVZcm0vlXr6/FqAp20bYXlFLOMZMa4mjRs1kcLOx11zz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/2026 11:02 PM, Pedro Falcato wrote:
> On Thu, Jun 18, 2026 at 09:01:08PM +0800, Kefeng Wang wrote:
>>
>>
>> On 6/18/2026 7:49 PM, Pedro Falcato wrote:
>>> Please CC reviewers properly!
>>>
>>
>> Oh, I will put more reviewes to cc list.
>>
>>> On Thu, Jun 18, 2026 at 05:28:42PM +0800, Kefeng Wang wrote:
>>>> The do_mincore() uses walk_page_range() to walk the page table.
>>>> Fortunately, the caller always passes start/end that falls within
>>>> a single VMA, so it's safe to use the walk_page_range_vma() in
>>>> do_mincore() to eliminate an unnecessary find_vma() lookup.
>>>>
>>>> Unlike walk_page_range(), walk_page_range_vma() does not call
>>>> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
>>>
>>> Why not? Can we fix that instead? I really don't like having this open
>>> coded in callers. Are there callers of walk_page_range_vma() that expect
>>> to look at PFNMAP mappings as well? From what I can see, the callers all
>>> seem to operate on folios (and/or anonymous memory).
>>
>> As you said, all the other callers don't operate VM_PFNMAP， so we don't
>> want to add walk_page_test() into walk_page_range_vma(). This hack is to
>> preserve the original behavior, but as David said[1], we could add a
>> follow-up patch to remove the special handling to see if anyone screams,
>> and this indeed changed some behaviors, so it's better to handle it with
>> another patch.
> 
> Yes, I agree, I'm 95% sure no one is invoking mincore() on PFNMAP mappings.
> 
> So, if we're keeping this check for this patch:
> 
>>>>
>>>> diff --git a/mm/mincore.c b/mm/mincore.c
>>>> index 296f2e3922b5..0c6731ae6c4d 100644
>>>> --- a/mm/mincore.c
>>>> +++ b/mm/mincore.c
>>>> @@ -259,7 +259,21 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>>>>    		memset(vec, 1, pages);
>>>>    		return pages;
>>>>    	}
>>>> -	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
>>>> +
>>>> +	/*
>>>> +	 * walk_page_range_vma() does not call walk_page_test(), which
>>>> +	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
>>>> +	 * page table walk. Without this check, PFNMAP PTEs would be
>>>> +	 * treated as present by mincore_pte_range(), changing the returned
>>>> +	 * residency status from the historical "not resident" to "resident".
>>>> +	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
>>>> +	 */
> 
> I would rather we amend this comment to something like:
> 
> 	/* mincore (historically) reports PFNMAP mappings as non-resident. */
> 
> because we don't need to explain internal differences in walk_page_range
> functions in a random comment in mincore. And perhaps attempt a separate

Hope Andrew can fix the comments when pickup patches.

> PFNMAP check removal patch as part of the series, or as a follow up (so if
> it does matter, we can simply revert that patch instead of this conversion).
> 

I will send it separately, along with other mincore optimizations.

> In any case,
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> 

Thanks.





