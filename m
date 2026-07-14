Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49D6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C07F6B00A0; Tue, 14 Jul 2026 08:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A6F6B00A2; Tue, 14 Jul 2026 08:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED7F6B00A3; Tue, 14 Jul 2026 08:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB016B00A0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:55:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF26BA037A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:55:31 +0000 (UTC)
X-FDA: 84987378462.16.2031E92
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E995AA000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:55:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lfdYVF5s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784033730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qAAK0pjZHrMW+ANrBUb9F/mBa8ig/34mJKgws6c344=;
	b=dP4Z8kPu7JkzBkxzFdnUN2BxL+Rp4E282RWygUNsTDPSD+Cr/m18Gkvc7oF/76apSdEIRm
	0ARJxuxjJOgFe7sQNNMzX1glAx6EIEUQyYkSG9zlgq1mp2v+QADxaWghfEzZUjkDaSE3Bt
	CUT6SLCNQl9MvVz3tsFw1X/9vNqJwm8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lfdYVF5s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784033730;
	b=y1YsUb493mjBcdOqLAo7Ua7sAqFvoAU9FAEoQdt3xDsj+MBvVANK2U87gas5kJqswBJqWL
	o926BJMOm1nqT55mVk2FB/PP3V6pBbiPuaVAk8dwdIz9Ga7KQTROoGdMvWOyn4dfIGQMH4
	VCuvVOv3Nj0KbjRFNPz0083zbZ0iOJ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD90E400D0;
	Tue, 14 Jul 2026 12:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5DC1F000E9;
	Tue, 14 Jul 2026 12:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784033728;
	bh=/qAAK0pjZHrMW+ANrBUb9F/mBa8ig/34mJKgws6c344=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lfdYVF5spJHi4dYPtwzfJ7m+ChSz6RuxvUSVw08nQgYdnUI047Kj7IdV7Q2cEwNFc
	 tNrD39I9lyyi/PIb3IO/hcPSubQC778wvG5tqmGx4SXLGBYd1JxW89QbaDYCSco3Ad
	 S61sQ5DKCzkKelkozuXrv+7VygKYJiMn3EcJdaSdUG4LLeY5kbkIm9nyoJxpzQpeHI
	 WPsNQdks78VYRvnoJiclMAwdsaydufnX5gc7gPOREcS0xlZNBZL3DBiFKczmTMcpBS
	 BqhJNeSU1604aXpPtKp231D1tG6JE2K2K9fGm2NPYHdMve8qSKZjrzDHhMlK4PmIU3
	 Ii95mYfjsWwBA==
Message-ID: <d4afd345-d18b-42e8-a6ca-d7018350420a@kernel.org>
Date: Tue, 14 Jul 2026 14:55:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: mincore: remove special handling for VM_PFNMAP
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Liam R . Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
 <20260710120052.103886-2-wangkefeng.wang@huawei.com>
 <1bd96ae4-f59d-4103-a700-f9478e88c05b@kernel.org>
 <8b94da35-a9f1-4729-bd1c-151da2f333ce@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8b94da35-a9f1-4729-bd1c-151da2f333ce@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6hndnsbofpqjdccgs5o6isz95uy6epz4
X-Rspamd-Queue-Id: E995AA000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784033729-510801
X-HE-Meta: U2FsdGVkX18kuEJuiidMie4QYZxwEYKD8fVHSor5US/uwDJxVY6jWEjBkgyhaT48HftOcQdS9ZKJ2JuLtVT2QWdcBqiu8DNV/DNe3k8Whz+f0f3Y3DXgBku7N5WUK1A/uSlBXNkmUnFBhkGitlNCsSICU08qRXxpyUQ0SF3cjUt9mYanw3UYuO/SUaVd/XZw6JvzfK86IoZemyFej1sW8luC242rL/CVM4WU+w5HcstoXcd+P8UjlIReMN6Et7pIyKde279HVAW0F3Idz2pZgXks8X2ErL5krMiu+rTOXitIlz8NnrO9AbcRdYc1HJNUKT993RwxdkDSoz5ZdeqN9U0hCN3NlNJB/lHowY2CinUJYb/re/5B08gi6mwG4mwP83X1AxXT49qQUJTy6nzHOaW5UClruU0N1ok5g3DMEy93aLzT4ZigopS6iATX36MITGPfGt5/XzZHpe5JMX1NksOWbhXx6tq9t7cBCEdQ47P/p02NXzJNhudUyBC8D0sEnQn8NahSdD1QnBV6/BPAzd9LE9iZ3EOit4iSiM0xOwRsKI1GkSyeteT7Xou4cXZqQh0gRMTlFWNGngQRQYxfPN9AjGgoPh30Rhf0nvZLh8D79scHZs+kd0qjPHyHS22EFTisyimIQLclZyVvcdjPkqPcFZB6rO7hFsKbHDJGmtDGf3+7rowsvBGkiCm6uXpS8tubjAwb9Fhaky1vdob5Fwl+92dP4L+FNy9R97RMJrRASI6gSHAxR3PdE5jmOD8+FpwmbvYZNzqBP68Iyd5HLAMvg9kFtLj9ZoVu8m8+VsNo0DDhLbSADs/gmQsIEsUhAbASk3MYrjZwwfPMIRqiiErctD3wRBi7dDNvNLs8r70b+vWEzcnLzoLt/aKlldizSLFdBEfB+PF+jD7P6DEkbGACwVccMmcEge+vxT2EXpJ/OwJYaGyOuIurORSe2uqPb8KNM9kxhzSVeNfENLT
 oruBmK/x
 8DU3yie65a+8Fuz01Q3CsAqcXf5jPUwW/i6rvVoxQNDjtEuaknazWxUS3wCH7GM3gLqj/PJ26+fs77bGZaPA7qLFsLhEoMMCyx5Ximx9HWSjCLifKm4ipIR7kxS8Zjxow1JU8nR8RfpvJgG+vy7xMuepEBFlxDCfqovMAqpN2WKDdrVasLdm5+qYAUnzl3K8i4mjAEbIwYoWj7uNGT17LIBq6lBi6cChvcd5oewTU3XeG1Yxola4LlGY0JvSuDCFJZBeS3x/zJT5eFWgnB0muwp0xXpwZpCveoG0suwWpzKiufi+87E671pHRhsUO/5Mjq0bIF/eyePMs2DYOFC8tX851swjF24zjcV/r8GA1rYBwO5MWoNrSpphodMhn13I2FaGl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 04:47, Kefeng Wang wrote:
> 
> 
> On 7/10/2026 8:07 PM, David Hildenbrand (Arm) wrote:
>> On 7/10/26 14:00, Kefeng Wang wrote:
>>> As David pointed out, "it’s hard to believe that someone depends
>>> on pages in VM_PFNMAP to *not* be present", so remove the historical
>>> behavior that always reports VM_PFNMAP pages as non-resident.
>>> Instead, make them now reported as resident by checking the
>>> VMA_PFNMAP_BIT, simplifying the code.
>>>
>>> Link: https://lore.kernel.org/linux-
>>> mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>>   mm/mincore.c | 10 +---------
>>>   1 file changed, 1 insertion(+), 9 deletions(-)
>>>
>>> diff --git a/mm/mincore.c b/mm/mincore.c
>>> index 53b982803771..0eb832ee0a30 100644
>>> --- a/mm/mincore.c
>>> +++ b/mm/mincore.c
>>> @@ -219,7 +219,7 @@ static inline bool can_do_mincore(struct vm_area_struct
>>> *vma)
>>>   {
>>>       if (vma_is_anonymous(vma))
>>>           return true;
>>> -    if (!vma->vm_file)
>>> +    if (!vma->vm_file || vma_test(vma, VMA_PFNMAP_BIT))
>>>           return false;
>>>       /*
>>>        * Reveal pagecache information only for non-anonymous mappings that
>>> @@ -259,14 +259,6 @@ static long do_mincore(unsigned long addr, unsigned long
>>> pages, unsigned char *v
>>>           return pages;
>>>       }
>>>   -    /*
>>> -     * mincore historically reports PFNMAP mappings as non-resident.
>>> -     */
>>> -    if (vma->vm_flags & VM_PFNMAP) {
>>> -        __mincore_unmapped_range(addr, end, vma, vec);
>>> -        return (end - addr) >> PAGE_SHIFT;
>>> -    }
>>> -
>>>       err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
>>>       if (err < 0)
>>>           return err;
>>
>>
>> What about MAP_PRIVATE PFN mappings with anonymous pages in there that could
>> have migration entries?
>>
>> I'd assume that we'd want to scan the thing and simply mark present ptes as ...
>> present.
>>
> 
> Sorry for the late, thanks for your review, the current modification is
> not very reasonable. After reconsidering the original Sahiko report, if
> we want to remove the special handling of the PFNMAP and not split the
> PUD page, we can add pud_entry processing and skip the PUD huge page,
> and mark pud as resident, the change is as follows,

Yes, that sounds correct.

> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 53b982803771..dc976713ee5b 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -160,6 +160,25 @@ static int mincore_unmapped_range(unsigned long addr,
> unsigned long end,
>         return 0;
>  }
> 
> +static int mincore_pud_range(pud_t *pud, unsigned long addr, unsigned long end,
> +                       struct mm_walk *walk)
> +{
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +       int nr = (end - addr) >> PAGE_SHIFT;
> +       unsigned char *vec = walk->private;
> +       spinlock_t *ptl;
> +
> +       ptl = pud_trans_huge_lock(pud, walk->vma);
> +       if (!ptl)
> +               return 0;
> +
> +       spin_unlock(ptl);
> +       memset(vec, 1, nr);
> +       walk->action = ACTION_CONTINUE;
> +#endif

Do we really need the lock?

pud = pudp_get(pudp);
if (!pud_none() && (!pud_present(pud) || pud_leaf(pud)))
	...

I'd prefer not using more of the pud_trans_huge() stuff directly.

I'm not really a friend of pmd_is_huge() either, but maybe we should just add a
pud_is_huge() and use that here.

-- 
Cheers,

David

