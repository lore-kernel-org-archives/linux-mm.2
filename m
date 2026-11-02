Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EAD606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d6GzueEm
Received: by kanga.kvack.org (Postfix)
	id 958E36B05B1; Mon,  2 Nov 2026 08:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909756B05B3; Mon,  2 Nov 2026 08:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FF56B05B4; Mon,  2 Nov 2026 08:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61D1D6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:39:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04BD4120C80
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:39:25 +0000 (UTC)
X-FDA: 85390285932.09.7B6ACB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 36C2A80004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:39:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6GzueEm;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793626764;
	b=qc79bZOXDI1EVcB3owwWAgBN9ru96+kHaHNt/M2FYTt0QOk7TJGaxq00E4/BjosW/Mfo09
	bOmB7mAcj1BWM+jrT6QjBd2R/F3adxzZw0do6cpF/92gKaD1O6VQ1QsAmPoBAzehh+aQ7r
	u7z+OJD2OuuZeYI+9sNK8J3MHROHzJc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6GzueEm;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793626764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/MiW9VNy80Q9uOkhpysUgXCib54TiZt5zURlJeuqHs=;
	b=hc/+EQT92ouQ7vDrfgy53aOqH7Gyky/MQXOpFWbq7x5lAUdhOhmO3Pa9RlAFwU+5sBajqd
	nOlEdrIeYVVdiMP5ry8sY2zlohWQrXA90kQMpOJ0uHYSlRCkZGGsyLFF5W2k5msJWUXP8O
	7AKdPGz1llkV8LwJpk4gkwq8AQpBY68=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C720B60619;
	Mon,  2 Nov 2026 13:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1786C1F00A1F;
	Mon,  2 Nov 2026 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793626763;
	bh=R/MiW9VNy80Q9uOkhpysUgXCib54TiZt5zURlJeuqHs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d6GzueEmMKMkMK7IGQLKu4z2aDrM1ElQKly5fKX1CcgzASh85t2PTWjmF/dTm95Bi
	 Plo+StlOCBkHEkhQ3Rmxfsw7v4fC3zZ+gIu0Vexsenaw8l/f5lEvm7prcARz5CeWWV
	 cN/axK8q93lO9gn6VbprsWVgP6SVoVDm/9wFnOThSHl3VR2up97iuvqJZTMqFfRTt3
	 6zZiGOUepKl3XkMZIrtGi7bhyIKBIqHZ1AE30SqDA+lpu5J8Z/WXVKevcRTvr1l6sh
	 lTnAIWB2Io3z5+x4OUz48h/q/nqMN2ptSp6rqEwmJrBqsho0WZeLq6lPsRYhmxcsu0
	 /f5TqV5UF5GZg==
Message-ID: <e06c0bdd-4d5c-4d08-8bbf-a26c4b38c6ae@kernel.org>
Date: Mon, 2 Nov 2026 14:39:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: avoid unsafe anon rmap dereference in KSM merge
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zhao Gongyi <zhaogongyi@bytedance.com>
References: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org>
 <54e20549-ca49-4d86-90fd-9f5e483d362d@kernel.org> <auiHNPkbB0p7-2GI@gremlin>
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
In-Reply-To: <auiHNPkbB0p7-2GI@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 36C2A80004
X-Stat-Signature: 5am7mgwzbtdxpdkdyhtm4z3u57cmz9ym
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793626764-400740
X-HE-Meta: U2FsdGVkX1/lwiEwQPS2gVrQccAzA7cuDEP2i/JS9OogeiAV1E4uzc7QA0rjqIFHIn/IbIsfTUyWxOm18k2JMK5dZGnC3DVAEPugFgeUGU0E0AVpG1vjRzq340CqrUNUeULd41ClhKQ5aK1VWtrsn6OgnMJXxbQtetHjHpxEruXVyR1PpDzaydjzCtdtntCSC0bvV0W8JMrKcQMySmTHpbPVOFfbZXkMuCA17wmTvu2eMKsMNqZdWGigyeVwVU1y3C1yclUx+PTr6SMOS0zY1OuG+N1AG7s2U6/974jPJ9lWx72stnHWxrL+lGxbL3nNMIXSQ2epUqK0j4/KhBMkYpDvqEYDOluInWFK+zexu7eepqR+ehgKnKnXpStuzfgPdMZlG/dXidZ9XRbwimO9vFViw+jr1BTEF6Dmg4/LUj/jffmjGgJMmlYRrRvnetpjdrx9VoiNFSzs1JX7BFQeshDFZ3Olc3MDqQ/YPEXC9YgVmp4XLDSL3/Fqyz6nQcsuZEf/IKID5iXR/UGuzZMw+D3LPC2DNtf8g0sNYdHDTG0p8Aud7WcKTdB6nQvxmdGdkiWUBhQ1kfNXGLS+1ccnzUcBeQr+0Ry2JpAddWm/DQw8LxILULZRRgCw6xn+F2Cb15f9qMclkoWtHO8AS084a6XoO3nCDdw04v2AvGbCHI/163e8vFUMF1CZiyUJCnDrbz6Jn5eu8MBPK6Xcx96gnU92TfS56LauJJDilAHkYdXYJIRHgBRrUYV8CaMLIF71HUcGqnpVawYoEQdjxL5rFjV0cgGxGDxi4opw8x8PotZ8uVVL611FXZC9+cuTwPZCb6WPmRYqUi0OtjQ9xzmTh/whpYConNdTdcbT0zL6mQArSJeaoxGVxPTus15dv7oMZg2Ofy+5SDcxAwy4zcyc2ryb7Iw4A1fOJWBQF83mUrth8dPoe5vJ57LwU85GogBmignXAtb+pbiDeryBm7R
 80jXN9hr
 GAYfpUzF5WSxgybnM33FL+apMPzKkG6erdN2MRoBccHxH734qEricHmpjVD5qqi0fU18i2anDNjowDLB/pmp+wg4qqu53juYqKR+rT3GU1+HIrWafJh1TbMCEKCSOGwkUnKwSKNo8fwmFaY3siWrorqnxlgfK2E53bFREvxnS7OvXukj4RVUigejkLYCESVQfIM0nAmYMNJxRC5D9V5gi9obd0t15fqgZbi2vyfO4T6m4BGfXDPaB4zGnzI0BpdqRbpWin+pN92Wo7O4w5Y7KDy5CwK920Yrx/JILXSD8x4F9tus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 13:55, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 02, 2026 at 01:49:02PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/2/26 13:32, Lorenzo Stoakes (ARM) wrote:
>>> When KSM examines candidate VMAs in scan_get_next_rmap_item(), it
>>> accumulates (mm, address) pairs in ksm_rmap_item objects, assigning them
>>> via get_next_rmap_item(), pinning folios via a page walk in
>>> ksm_next_page_pmd_entry().
>>>
>>> Throughout this operation, scan_get_next_rmap_item() holds mmap read lock,
>>> which it drops afterwards.
>>>
>>> After the mmap lock is dropped the VMAs might be freed and remapped where
>>> the VMA belonging to the folio was previously mapped.
>>>
>>> mremap()'s ability to change where anon folios are mapped is dealt with by
>>> KSM by essentially avoiding the problem - prep_move_vma() unshares KSM
>>> folios, and the scanning logic is tolerant of concurrent remaps, discarding
>>> stale ksm_rmap_item objects and allocating new ones at the new address.
>>>
>>> This doesn't account for a new VMA being mapped over an old one where a
>>> folio was previously mapped, so KSM accounts for this by checking things at
>>> the page table level.
>>>
>>> However, once an anon_vma's reference count reaches zero, it is freed, but
>>> nothing clears folio->mapping, which is where the KSM pin interacts badly
>>> with the current KSM implementation.
>>>
>>> page_address_in_vma() is consistently used to look up the folio's address,
>>> but page_address_in_vma() explicitly states:
>>>
>>> "It is the caller's responsibility to check the page is actually within the
>>> VMA."
>>>
>>> And KSM violates this, as it cannot know this to be true. This results in
>>> this function performing a use-after-free:
>>>
>>> 		struct anon_vma *anon_vma = folio_anon_vma(folio);
>>>
>>> 		...
>>>
>>> 		if (!vma_has_anon_rmap(vma) || !anon_vma ||
>>> 		    vma->anon_vma->root != anon_vma->root)
>>> 			return -EFAULT;
>>>
>>> As anon_vma->root is dereferenced when anon_vma can already have been
>>> freed.
>>>
>>> This is currently benign in practice, as anon_vma's are slab-allocated
>>> objects so this will always be within the direct mapping and arbitrary
>>> memory will be treated as if it were a pointer to be compared.
>>>
>>> This either results in an -EFAULT or a spurious match, which will be
>>> rejected at the page table level.
>>>
>>> However we mustn't UAF even if it's harmless, and KASAN rightly flags this.
>>>
>>> It turns out we don't even need to use page_address_in_vma() as we already
>>> know the folio's address, it simply needs to be passed through.
>>>
>>> This change therefore updates KSM to do this, sidestepping the issue
>>> altogether.
>>>
>>> Explicitly check for KSM folios in try_to_merge_one_page(), which are
>>> already merged, and by definition never have an anon_vma.
>>>
>>> This was previously handled implicitly by page_address_in_vma() as
>>> folio_anon_vma() returns NULL for those.
>>>
>>> In many cases cmp_and_merge_page() will reject these, but it's possible for
>>> KSM folios to fall into the unstable tree there, so eliminate that
>>> possibility by checking for that early.
>>>
>>> This maintains existing behaviour.
>>>
>>> The bug was introduced by commit 21d0d443cdc1 ("rmap: resurrect
>>> page_address_in_vma anon_vma check") which first dereferenced
>>> folio->mapping unsafely, but commit b8c8ba73c68b ("slub: Introduce
>>> CONFIG_SLUB_RCU_DEBUG") made it visible with CONFIG_SLUB_RCU_DEBUG enabled.
>>>
>>> Fixes: 21d0d443cdc1 ("rmap: resurrect page_address_in_vma anon_vma check")
>>> Reported-by: Zhao Gongyi <zhaogongyi@bytedance.com>
>>> Closes: https://lore.kernel.org/all/20261031182256.40205-1-zhaogongyi@bytedance.com/
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>> David - this seems benign in practice, so I'm not sure whether a backport
>>> is required here.
>>
>> Ok, thanks. Is there a similar problem as with the other anon_vma->root issue
>> where a false positive match could be problematic?
>>
>> I suspect not.
> 
> No, as it checks stuff at the page table level later.
> 
>>
>> In that case I would pick this for the next merge window after a couple of days.
> 
> Yup, this is far from urgent.
> 
>>
>> [...]
>>
>>>  {
>>>  	struct folio *folio = page_folio(page);
>>>  	pte_t orig_pte = __pte(0);
>>> @@ -1515,7 +1507,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
>>>  	if (page == kpage)			/* ksm page forked */
>>>  		return 0;
>>>
>>> -	if (!folio_test_anon(folio))
>>> +	if (!folio_test_anon(folio) || folio_test_ksm(folio))
>>>  		goto out;
>> Okay, that makes sense. We don't have to check under the folio lock as KSM
>> doesn't merge concurrently.
>>
>> Do we want to assert in write_protect_page() that we are not getting called with
>> a KSM folio, similar to what we do with large folios in there?
> 
> Sure could do. I wonder whether that existing check should just be a
> VM_WARN_ON_ONCE() anyway, seems a bit silly to if (WARN_ON_ONCE(...)) return
> err; there.

Just what I was thinking.

> 
> Do you want a respin for that or happy to add?
I can fix that up when applying. If there are more requests for changes, let's
do a resend.

-- 
Cheers,

David

