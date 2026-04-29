Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED6B1FF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 05:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297FA6B008A; Wed, 29 Apr 2026 01:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248D26B008C; Wed, 29 Apr 2026 01:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138286B0092; Wed, 29 Apr 2026 01:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 019306B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:50:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 802ED1C0C7E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:50:49 +0000 (UTC)
X-FDA: 84710519418.18.9B7EC3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C143DC000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:50:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MZKhV/Et";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777441847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amXxFikcXn9z1H9iMZSxzB7M7d6ZFi86+HBFciBZVuI=;
	b=UWub5ziNp889/vCvcXHUIPSGHDHLjbqya1vk20A3isUIP+Cw8sn9wLMqV0BypnEZuDCzdw
	rr+5VqF/+ZMJaMOXB7NZL5KYMh+zdSdYS0BicZfs4Ec6Eczk0NmhydRDMLyeexVU3arkQO
	BUuglqUnaEWeH4ThpYCCJmGBI16uEVM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MZKhV/Et";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777441847; a=rsa-sha256;
	cv=none;
	b=Rbzl6hcyNM4UVrfTmqz4eZgUvyGkuf/vnXuY57pPERqMi8NDWJvNMMuEuklAxTbfLwwEzx
	6f2gNpWOYvr9jobroT7EJROTVJhxuVYSAIx+YqD8moGDKY/78h/LHM2nV/P3qnUy2JVWt1
	Z11cqXQkRkoDoMQ7qs9IhkFr4LclAbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1E8260018;
	Wed, 29 Apr 2026 05:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20ECC19425;
	Wed, 29 Apr 2026 05:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777441846;
	bh=s9ptXCgubBcilTQq+jJNC4q9MUiGMDrj0CZmPpJpgd4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MZKhV/EtmFdCWSgx8/5k65xynUZO3G1bEjmVHu9QPtxdA4JTY9baaFnA/PUDsa0rF
	 DihnGNjXrdDJ/Ypmp13hSRN5hMlwYgg0V4gw3BWkenzNq+4ubqX5FXn4JUv00WLD3O
	 eJ0/c4+pBIEbAIS8gF9coMrZe0vVryYPRiTc8zYpNQavWQMzX+GQvtvyZy8Cw1KQrJ
	 y5r1LpsQgrRLguy/+VNmBIoVLeT1lB7ha2DbOUWeoXS9Y5wNuv4A/+BznGJsY6wzxJ
	 cIOXhfz1GXAQyExcSUKCHMHekOl6qeJ90AXDpLsVgH4+VeT0Fb3cHfMEpQVwlQJE7C
	 FiHTHcDeUcyjw==
Message-ID: <3fc697d4-9193-4350-8264-f38ebc4836cc@kernel.org>
Date: Wed, 29 Apr 2026 07:50:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix freeing of PMD-sized vmemmap pages
To: Lance Yang <lance.yang@linux.dev>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, rppt@kernel.org, jgg@ziepe.ca, baolu.lu@linux.intel.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
 <20260429021224.39916-1-lance.yang@linux.dev>
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
In-Reply-To: <20260429021224.39916-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C143DC000D
X-Stat-Signature: z599eh5dk7h4f37pksndngmx77ozknf6
X-HE-Tag: 1777441847-268968
X-HE-Meta: U2FsdGVkX182HD+28PAycVfa8eOSCdxUzKXf5tkJA8ha00M+XaeB6xUcqPvNB1hoK+jvM7GeGpowImG4E0Qadd4RpY7mWc8rJOG63+W41XpkZGtSB4NA30cVLroZUhHXajL5Z5W67ZXxFAiy3e3GB81Mnqm8f/rrRhH21yWCLzIZLpXNV96qIld33HEpZTiFSrcTxWxqN43aNz1JsN8Qm4SJxLMyHlge0WZCJepXjpGspg7Qi7rPzwoj6lSXIv3L4zNZmTAGl86anl5ZLHWdUANLCGC+FylMfcxaPK9mf5YZG8JFRzG+BUrGhPCWmhkrzjEbnHw5vojAi0rwEwSluusI13y9ZhyWWauBBCxsMwazb2fpyJQ9fdy2ay6VG15ICPrmnDVE1Xrch/ZtrewN8IZ9BYIuVP6ArbyIejU1xmxGLGg8qahiBHkFYa+w7sPfV4e0A3a0eKfIB+p89Suu5E5LHTQTQC+pOf3WxYDzNoNj6Ak2W2bRSgPjRHG92CHs6SLHhs43BbUPx0o04NeC2gGB9PzHwCAeD7S77Z+9W20Mn7VuXNa+SwkjuC1bqa3a45qB020NLlJYW+SOQVIPnAzwEYkeHkar5bHxAghtdue78kESZ8AK3prGxpnZr8LjdF5cuaUyyT88PyIOEo3aCVgvBL1zBNyGG0uI9l3a9f/HTB0eweSttKYaMwRZ64pd+N/7BQGumXr+WTAJU8xGdxMDbYGCdM8Cff4U1pIyEag3qypXwn/fcSJiVYER5lETDtx2y4KWM+RNbs97L2MowaCQuW/R5WagpT2WtB3x1PeWSG4zjFi+PCKfotkhocEo5cNOZ3JcFohL/OZL0SZyXarqB9Fleh9CmZcqIVVUuXcxj6RQqV/PBbvFIZ0M37UuFHwK50b4AL15fAwJsX1olOocl5TGGeCB3Dw5O0XApybrUugBBdse7D+ZZ1d/ip9HmkdGhoR40BblDJo7O8b
 bony3aCM
 ertPluwN/z1cchgRYxHUPAU6T3EwNtjplEohCh8xhAMHqI3ZKvL8qhQBbcneAPlm3wplWg2pHjcOMExUnOZw2b0xdR6+foXAkbFOafsPwEFuhLRZLBGcfrxYL2RDL3qJUJZV3pxmnXj6pY/fjwkcOtzihZ6SDeXD7kuwJytlvtfiWalLcU1s1aqRG8LtWp01NAmNnYL/QxLx1Chmo0gsOgcPLAKFNqUh4FiC37FOyVO6+iaOsK6anXhXzDdf4yWmuW6As
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 04:12, Lance Yang wrote:
> 
> On Tue, Apr 28, 2026 at 12:29:36PM +0200, David Hildenbrand (Arm) wrote:
>> In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
>>from freeing non-boot page tables through __free_pages() to
>> pagetable_free().
>>
>> However, the function is also called to free vmemmap pages.
>>
>> Given that vmemmap pages are not page tables, already the page_ptdesc(page)
>> is wrong. But worse, pagetable_free() calls
>>
>> 	__free_pages(page, compound_order(page));
>>
>> As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
>> except for HVO, which doesn't apply here -- we will only free the first
>> page when freeing a PMD-sized vmemmap page, leaking the other ones.
>>
>> Fix it by properly decoupling pagetable and vmemmap freeing.
>> free_pagetable() no longer has to mess with SECTION_INFO, as only the
>> vmemmap is marked like that in register_page_bootmem_memmap().
>>
>> While at it, just wire up the altmap parameter for remove_pte_table().
>> Also, the indentation in remove_pmd_table() is messed up, let's fix that
>> while touching it.
> 
> One thing I'm not sure about is passing altmap down into
> remove_pte_table().
> 
> Do we actually know that a non-NULL altmap means that the vmemmap
> backing page came from that altmap?

I thought with an altmap we'd never get into the situation of allocating outside
the altmap.

But you're right that sub-section hotplug might actually trigger this.


> 
> On x86 we still have in vmemmap_populate():
> 
> 	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
> 		err = vmemmap_populate_basepages(start, end, node, NULL);
> 
> So for smaller-than-section vmemmap ranges, even if the caller has an
> altmap, the backing pages are allocated from normal memory. But with
> this fix the PTE removal path would now call vmem_altmap_free() just
> because altmap is non-NULL, and would not free the actual backing page,
> IIUC :)
> 
> Maybe free_vmemmap_pages() should first check that the backing page is
> really inside the altmap range before using vmem_altmap_free()?

Probably I'll just leave it as is for now, and simply pass "NULL" for the PTE
case like we effectively did before.

Thanks!


-- 
Cheers,

David

