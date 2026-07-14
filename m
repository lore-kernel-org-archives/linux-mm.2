Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C58F0C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA436B00BF; Tue, 14 Jul 2026 10:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2996B00E5; Tue, 14 Jul 2026 10:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4666B00E6; Tue, 14 Jul 2026 10:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60FAC6B00BF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:45:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED0D214039C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:45:27 +0000 (UTC)
X-FDA: 84987655494.10.2A6F07B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1DA3A1C0006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:45:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tq3T3WYw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784040326;
	b=w7xjEL9b/q/ExaPmFUf8NNjZIfr01+7eQlZ+VC85VdY9ucLzBfxCjaoEB/aR+oxsC6fX8X
	un1yg8CdVkoXn0ak42+mcVj1ezupUVNJB503KBHpZPUb9yP0MLh9qqgl5mnMWXVAWwnp28
	r/P58DpQpj1r8jMXgEoG1QpMcsDrKI0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tq3T3WYw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784040326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I85TG8G71SurHcnaD/AffNzsz8EcXcLUZCpLlNiyXBg=;
	b=uyHVpNPQ6LT/NzVTkehn4Dzlzil8eKzXBybJ8oXIKAdq/YPYGaJy2tNX9uUENbe8qztzT2
	+E7nL1ckCLrF6Kd6XFn//f9cuGcV4xbeK31v2M72AqJfeIH7yVW0FX6wp1J9U4eC9QBrXv
	Pb1abk9GE6NBIBmCDxDOWJtWlqJDQoo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66848437A3;
	Tue, 14 Jul 2026 14:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B0D1F000E9;
	Tue, 14 Jul 2026 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784040325;
	bh=I85TG8G71SurHcnaD/AffNzsz8EcXcLUZCpLlNiyXBg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tq3T3WYwKoKQg+9YumM0zfPUO8fHlffqNp3mvCdKMkPTgR4zsJFnev0DZdVW1IYOE
	 Q3J6uW7wlN3RNZBJ1V5VwWuGAJ3J10gwexv8smjCP5ghcXM4jfz9pUvX3xi2NflGOK
	 97UEFos8z3Ule/5YWDVimSdU1Wcg948o9uywf043yLPBfR6GRBiBbZc4wwgy4vMmHT
	 vPBkalSkcEv0iVHctjGHXjcap59Cs1QVqdTrDcll5tQftsfBVNHjtXYII2YZPdBAoD
	 rJR1sMI5ghQT0I3tNblsh9CcB4kiAwq2DM8JIgTUWLAaw1rBMXPRiSwrKXmAvHYQu2
	 1L5AqYqPE2RoA==
Message-ID: <e92aba5d-b726-4d50-b789-315b11515e9b@kernel.org>
Date: Tue, 14 Jul 2026 16:45:22 +0200
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
 <d4afd345-d18b-42e8-a6ca-d7018350420a@kernel.org>
 <ac0fd6d3-b429-44f8-922b-cfdba2d0154f@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <ac0fd6d3-b429-44f8-922b-cfdba2d0154f@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DA3A1C0006
X-Rspam-User: 
X-Stat-Signature: x7qppk6yhzt7jsgxsapdypsf6a1xy966
X-Rspamd-Server: rspam03
X-HE-Tag: 1784040325-340114
X-HE-Meta: U2FsdGVkX1/o0iSX2czYU4kD5WHNif//i7G0Jo5JKO8ObJ+oVniLhqITCEPC4XdUQfLFjNhIxMRH99OPMdc8EQbxiyOBSnXUQP3hQJRkRNRxM4t5GV9hf5JwN0KYpsN4E7H0yCeW//lJBp9clFAdwObEf5ZwyuSE/6NC+8IAYFhTLToeJruJ9gJaQJjvud7y017iUpjp6LC7ri2U/tmK1VXmPCJpK4bUCZCtl1mm63R8300naz7P2vopgV5a2r9/1uWjJiySLsr6ugCZni9FUItEOs6F6CAhCf58s+Z4EGrEJZ7oxd6LEHC3tqDUNGzdbTxCwpzOUgy5T1ZtzcZXz7MMuICphkDi1QSeYtnqIiBIJHmszsCZCAlkb6pk8s6eyqXbaatW/Hs044pMJeX5G9R7oyaHo0i5/yk6p82MyzoycWAMHmc3l0HmFQ4aE8AAR11cPRxQoJ3o/AgSmJaJBN3OG88wjvRJLgwrrXqRgrXvEiQuwbipuAN+eGyeWn942ilPx8SxTbq4QfEN7B39aTjCd5SLYvWyyrPUhbaGWZ9jA5dsBGKfFK0TaLY0P4ZWL+QIpXPl+NjooHDQKOUrZ2yJ+taOuL0h1fbCwVAsmfeE3KSbjfvtLw3vEnMVDEN8KtGac09ed+I1m/E5qDQji+yk6M8cit1iDK+Mk/p+9Xku0DOl8v9AUMniHkwfH9D0w1pyZkKQoORJ2U+px3SpwZgrpWT384CeaBMUABCqoJHFCxHatf2KaO0KUOG8XgkEN2ZFwFWFaALW9MOmVkSgmZO+Dilpz5ALD0jRa+uEVSMfFGsCfuiJAkQr3uYrTMbzoBATt1yQHdVgrqHZz7MMwhNAJ8OayFHuL7aMQZLgpo866OMF5QPnja/LtWuFrf20KQxercUbg8RNvEypfIs2bvAyfvVNbi1zNjAovVOC1FvAXALT7rjM76u7krkTXtx+GDqWOtMkTxBYLGtDXoF
 a8WdwE8c
 jS0LnNeQnUj4VbgjYrr0YF+GDAtVVbSpT93Is0IyD+7swyKQGqIjcqmzjx35d6ym8LREFL8jAJsSOEY7bKWsOVK1H9ZrpJpvQvxMhjmqvcQM/l9ENazdF2YY2ciWTQVfUxcUUgkt0uiQKB6C2KwzTzKsvkH52kYybo0o3xfL5AogQ+A5S0eUGkNiGAAALKEhLOxt4/mFwH3ilSKHsJodpl6XJqPGbTk+20a94bR4s9c39fL4GXg2DFVyAcd9ZO7+d7Juua4AwDMRx8/IKpDbUgjoKh4rt8NUCNMY/TUaSe+Gk3lEOhqMK6lIzqoR3fPZSv4wul5TSg3Ca61s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 16:42, Kefeng Wang wrote:
> 
> 
> On 7/14/2026 8:55 PM, David Hildenbrand (Arm) wrote:
>> On 7/14/26 04:47, Kefeng Wang wrote:
>>>
>>>
>>>
>>> Sorry for the late, thanks for your review, the current modification is
>>> not very reasonable. After reconsidering the original Sahiko report, if
>>> we want to remove the special handling of the PFNMAP and not split the
>>> PUD page, we can add pud_entry processing and skip the PUD huge page,
>>> and mark pud as resident, the change is as follows,
>>
>> Yes, that sounds correct.
>>
>>>
>>> diff --git a/mm/mincore.c b/mm/mincore.c
>>> index 53b982803771..dc976713ee5b 100644
>>> --- a/mm/mincore.c
>>> +++ b/mm/mincore.c
>>> @@ -160,6 +160,25 @@ static int mincore_unmapped_range(unsigned long addr,
>>> unsigned long end,
>>>          return 0;
>>>   }
>>>
>>> +static int mincore_pud_range(pud_t *pud, unsigned long addr, unsigned long end,
>>> +                       struct mm_walk *walk)
>>> +{
>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>> +       int nr = (end - addr) >> PAGE_SHIFT;
>>> +       unsigned char *vec = walk->private;
>>> +       spinlock_t *ptl;
>>> +
>>> +       ptl = pud_trans_huge_lock(pud, walk->vma);
>>> +       if (!ptl)
>>> +               return 0;
>>> +
>>> +       spin_unlock(ptl);
>>> +       memset(vec, 1, nr);
>>> +       walk->action = ACTION_CONTINUE;
>>> +#endif
>>
>> Do we really need the lock?
>>
>> pud = pudp_get(pudp);
>> if (!pud_none() && (!pud_present(pud) || pud_leaf(pud)))
>>     ...
>>
>> I'd prefer not using more of the pud_trans_huge() stuff directly.
>>
>> I'm not really a friend of pmd_is_huge() either, but maybe we should just add a
>> pud_is_huge() and use that here.
> 
> To make it clear，let's introduce a pud_is_huge helper，
> still use pud_trans_huge(() in it,

yes.

That's what I would do, maybe people reading along have better ideas.

-- 
Cheers,

David

