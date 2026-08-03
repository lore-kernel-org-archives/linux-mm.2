Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F079C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDFD76B0092; Mon,  3 Aug 2026 10:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F826B0095; Mon,  3 Aug 2026 10:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A585C6B009B; Mon,  3 Aug 2026 10:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73C396B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:03:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13C2D140734
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:03:00 +0000 (UTC)
X-FDA: 85060124520.03.4B6494F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34A431C001F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:02:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSturGiZ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785765778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1E7dQ4aPZaIdq3SbmqgAHM9kCwev2hzByfcmJn3dpw=;
	b=ZZ9vTSgED4/gV+0nzsvUplBBCl0Erxm70jxsYu4UAjxnNw2xMW8JeLGa3QAwaFXiYpxZlR
	JU4lYa1MYM1tR+hjBE9ZFAgr1u6reieYxBQy7ftU36M0k24k4LhKAxrjGGOQPXN9U/LRTr
	zhfydtnFmXyEuX4KKl9proFEB4vUyk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785765778;
	b=gVN3FbJN2rfmEz2/q9K3dCTMT9FF7SojkGk/jPcg2NgOjlhAhLugBHsbhUZlJDi5s81BOJ
	O1c8RuUVpqIHn0chm/MbgcoitiS0TGDjF/WHD8f41ddYB56Z8QuBwFeGwp92ushkUnRhl5
	CirxLfyGauU73/qyAYpRqoO5+fIZsp8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSturGiZ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A11344043;
	Mon,  3 Aug 2026 14:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B07C1F000E9;
	Mon,  3 Aug 2026 14:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785765777;
	bh=T1E7dQ4aPZaIdq3SbmqgAHM9kCwev2hzByfcmJn3dpw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fSturGiZDOvtsXwaLNuF1cO1Im0uBGa354NwhqDC8M5d/qTsUxw1udoKLC54YCerx
	 xT5pICzoM6YeHh4pTQURX0OvjgHTEvKdruMiu+xmZgPar+SXZGTbnEzQgZmIV9AToi
	 nG7eNzHrJARTpUI5nj7ZtPYznsg6LshS6EdqSrjk/3KSvRdxTM+wQ5QSEkgvHOxzFM
	 ruj+hzz/2bsg5p8WW2Ok+rT/+W+m2Ck5LU3CftpAP4Ct24z4DIWzTbMmK0kEBmuk9d
	 mcrofLr8Pc5bZkK2wbnAqLH+Rrdx+GwjpcafR1QUHMYhtk1l3q9ilhNeMMNq+hT0Y1
	 1TQ2mG266LeNQ==
Message-ID: <007258ed-3fd7-4d90-b909-6fdda15e0485@kernel.org>
Date: Mon, 3 Aug 2026 16:02:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/15] mm/rmap: track whether the page VMA mapped pgoff
 is anonymous
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-7-e8ecfefea812@kernel.org>
 <1b48cf7d-8906-43d4-a85d-5cfad10a12ac@kernel.org> <anCcMvnsux22LaWU@lucifer>
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
In-Reply-To: <anCcMvnsux22LaWU@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 34A431C001F
X-Stat-Signature: ocsha77nmb5ofgnakp3soxww86dxbd5g
X-HE-Tag: 1785765778-34694
X-HE-Meta: U2FsdGVkX1/wIfJkLIdAAcMDEh/Hi3RApBmBjFCA2f1Ua5QaahpFNsVu4kTTkvvLAXl0bgaIXR2AJ/dLeQ8j2m0Oduor1gGs/6/kHuTtyAaKyEXa6c86wYEPHl5TlB4ya1Gw8X3bEeennoogT1YhxzSdaVqMXKy4zf7Pu5pJCkBt1VFp5XuThYUX/V/X0BXzkxP6GTjiIJ4DD6GNg+vSRlIfCwi3rUmxgzULiHcuyLY8yVHvzstPrpy17vqGDYcmkEVNfdu/l7a4wHW94ORrrL73MqQluNDoOqU0LWZ72i/f8T+MX3dZXC6TVvz522Gsxn7qSwrg0t/C2gnozB5IPh4MOZvTcYsWVLY+XG1R7eRPC86Vmi2xcwOdDoyLCDUxLF6uJ2qz92ASQ0ZZVyuymS/wRFa4WnyzVJS+PcbKGxL1c7IRWtK8E66u2a8q7eQx4PbwvGMEfiY4T/YEmRJuWjysPM5Fha/E6qslSkfjniqj/M8mLoPYtjn6uLbmusoFF4yFI6nYxm2uycllmjZ4YQHhm+ZDaNGkyjlLOwdxekqP5zxztoAIz5DfVEvsQu6yfazt4U0G4uG0wBUGkMVih2BWm6H4jOd6JrZkYyhSy3b/73rqloM5QFJvPHqaq6YI9VzCq4PZuAWmW7FNC+vZhYEU/CJZTii+0bZeZHT4+ZTgwc/aIJ/J04N4k+GBykEK1/RjDnYrEUJGPwOV8xKv+yfrZjFw1I6Tm9oA16CMOMSjrBfLO+EmBU1vIUX0m1zw4+FHiLcUJirlZiLcurHkezeK1a96JHPOL/uwtiSDyA5WOkaX9AZzCJWHdLuHg2PdYMEAdf9OsCEIBeRZQ63Oiu56YcHpNw3dAt4iJzADm+XfP86Ei6bPceU/smTFXtMAbJxVKnDfwLFPhYvWFkDDY4yE8TLq1/MjL7IWrTRD+lQoXi0vJqSBy1j+ddHMnsfgBRj9HPaSir+J2T7owab
 5fw5rRLL
 cdlze3viNvMB2KdNhlS8lNwyobC9lUzNvClmhDrkMdBjmt+RMaZ6tq4I88/2ztzUjVZYqJ47FXrhierxDMQGVdsZbH1lkhXTwoLDtWfIM9WHbqjCu52bR/y+18tVyXCSbji7olbsKkFK9AYbcgfwEC64QJPgLkUroezYpkZtPxgzsXMXSi7ymdCF1hXUkuLHxtR/CmGSWYF+K2nTatkN+B1u0R1Id6zNJQkW/nwDXPNDjUgJNV6A3wlfFG+w8YcABg3wp1823zGCS9EAOPAd6YO+cm1ZX9iftVy3feoNhNwEcKNZi+1icDZ/UmrHavBFMf4VfNfRIkyIW3DDihA58ffaMMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 15:51, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 12:57:44PM +0200, David Hildenbrand (Arm) wrote:
>>>  /*
>>> - * Then at what user virtual address will none of the range be found in vma?
>>> + * At what user virtual address will none of the range be found in vma?
>>>   * Assumes that vma_address() already returned a good starting address.
>>>   */
>>>  static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
>>>  {
>>> -	struct vm_area_struct *vma = pvmw->vma;
>>> -	pgoff_t pgoff;
>>> +	const struct vm_area_struct *vma = pvmw->vma;
>>> +	const pgoff_t pgoff = pvmw->pgoff;
>>> +	pgoff_t pgoff_vma_start;
>>>  	unsigned long address;
>>> +	pgoff_t pgoff_end;
>>>
>>>  	/* Common case, plus ->pgoff is invalid for KSM */
>>>  	if (pvmw->nr_pages == 1)
>>>  		return pvmw->address + PAGE_SIZE;
>>>
>>> -	pgoff = pvmw->pgoff + pvmw->nr_pages;
>>> +	pgoff_vma_start = vma_start_pgoff(vma);
>>> +	pgoff_end = pgoff + pvmw->nr_pages;
>>>  	address = vma->vm_start +
>>> -		((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
>>> +		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
>>>  	/* Check for address beyond vma (or wrapped through 0?) */
>>>  	if (address < vma->vm_start || address > vma->vm_end)
>>>  		address = vma->vm_end;
>>
>> Am I wrong or are all all changes here completely irrelevant for this patch?
>>
>> You mention
>>
>> "This is necessary in order to determine the correct VMA page
>> offset in vma_address_end() when pvmw->nr_pages > 1."
>>
>> But I don't spot an effective change here.
> 
> As per commit message:
> 
> 	This is laying the groundwork for eventually using anonymous page offsets
> 	as the index for all anonymous folios.
> 
> 	No functional change intended.
> 
> I cannot enable an effective change here, because if I did I'd break the kernel
> and introduce a bisection hazard.

You can just throw in a patch that cleans that up and avoids messing with confusing pgoff?

-- 
Cheers,

David

