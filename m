Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D0FC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50046B0092; Tue,  8 Sep 2026 07:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B273C6B0093; Tue,  8 Sep 2026 07:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16406B0095; Tue,  8 Sep 2026 07:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3646B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:48:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 185F21A05A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:48:53 +0000 (UTC)
X-FDA: 85190423346.27.5E759B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 58BE420008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:48:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4yNB+iH;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788868131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3fsDMUp6iZPwqWolrjkrZvy70fQS6FinWdQXIMSMow=;
	b=g59g8qkYFDs/K5rxApvq0bDsTjzeXiFokQdaF8bW2mgwKEakqNUBpjBvhAMNr8HDM5GpU/
	juW7Dtj5LKPaJuB0RzemHsSEwOwdDGxFzBMaf/U6lJfqh8+edp8XLaJwKeQS+Rx+OVgtrK
	RAk8fmXkbgtuS0YUPo003//eqi1W6p8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788868131;
	b=Uk0++oi18fO6u8Oe8Bf1v81hzxkLtOtj2RhFyk5/C4P0HYIyWXT0dj28oOwl4XNBMM1/dg
	n/IPZ63HzevpjiPIyDbBO9Vz1koxF/mqqgd4HEeNnDCDos0WMrroHTREelxtBc8ucv3nhS
	uQHyboqFouTRsPt0nOdf4YXTb/UWVTE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4yNB+iH;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 389C44072C;
	Tue,  8 Sep 2026 11:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5B91F00A3D;
	Tue,  8 Sep 2026 11:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788868130;
	bh=E3fsDMUp6iZPwqWolrjkrZvy70fQS6FinWdQXIMSMow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D4yNB+iHgYWM2xH5dEAI8mPSRYWnnNFm5P6il2ewjQLawqqHvZ0iRVtiPpend37Ov
	 BVgRiJpLfeZphjBvLOtdJquXE28iPZ5jAq9L3m73yktY98VNQiyduG1fGDmCvwVCFb
	 OvLVA5AbLLz20lLr4HCl1/Zo5X94Rj/pLMSJKZwrZUn0ZKKRR25TKJf8kMmj58VhYa
	 5EFv/GYUk2Cp8uy7bb9mBwcWZI3nmjTc/K2o4v2pW1t25PbkazcJ2hQMXvqOr6CMwB
	 BUgOfOJLNEmKpyPmA+NEmQzK8n1wSEEyA1X9FSj7HVQHwoVA4qOIzR04Pl5WRk30g8
	 HA2wuKBfwd1Vg==
Message-ID: <d379aae2-4249-4c6a-a748-5419d4f74f34@kernel.org>
Date: Tue, 8 Sep 2026 13:48:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-4-949b64a9f755@kernel.org>
 <2b0f5877-e71a-4824-adeb-5af2dd8b0269@kernel.org>
 <ap_tjOTR48tja_8e@kernel.org>
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
In-Reply-To: <ap_tjOTR48tja_8e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58BE420008
X-Stat-Signature: qdnwzsqwkgctic4wncqdpt8cijzksgki
X-Rspam-User: 
X-HE-Tag: 1788868131-554049
X-HE-Meta: U2FsdGVkX18ZCADwe9f0iI7aqU8f1ZjIumqI894HvvcsKy4H+3LCDppVbYyJJ6HWP5DDOW36KaTKL+zaz75Jjr4+B0ElXApYGf4/TnVty+jZbVXtom+d8qENCrtsu0HwmWjJ/LJBzpiF31EWQYy5/3ccJU3Hvz/nvtYVG+ZZhSEJBBIuM5TlzfFMM6EkAqm5nVwX8r9scCvlIkZmy/purpzdEz19/FmyxKvo4peUuqWEJ/qJBPydnK2cPKVcLzCCxl1SfYO2f8JLWBbPm70ecN3hQgEiI3StGX2W8k5tnl1WyrsmIo1PXOG9/4xuGRz9kQ0W1bg8c9ouyRCOZMBSKyFEC7Xo79PSNi2TADwobvw35kFkCMIJwsEFzifbxU9eNtDBn6DYTdcjyuEdmvz07CMt1AYOmZqFiEEcS6kT/pr1UgsGKki/zSQKzohDcUuJZ35TfjBIPqRpMW0aZxYig6gEqcCNYMD1DHFgjurM2m1Q+PN0coehnEoYFvv2Gnm8zHWvSrHXaUn4+XmbLUUXyAAMPlgv1130q37H8z0eAaTvoTPNRjUzFm+EDFBKB61Z5c8R2KgGg8o8+a4y14XxRymbzY8/1y+fJZUeGhjCgNSoopjTcZGSi0nSNbysE9Ow1D6K1de3WGSKJqqADfwEMgX+2rE8GHnudwIfz2efJtXraNaZ7ckhXdFF3ib6cWRuTISIsRvjSnNAraUe/x78t8vE8Po8kp7Fu2tni4/Fws6ZIM3m8bGwJ3Hp9LMEWjFDG/BtQNr9X1TuaaT6Ci37LrEoE0OngwxW9FGm24oQf1GsrUrluF8GGuzyaSdFaecS1EI2gMqRlTdKB9WGIPAbw2hh5rmfZtASuaPxbMdd4wiBarhS/EKJ0+Rcuny1v6YHA6SViZcFjjQJifdZK+eDCd0Tnaz1XsmT8V38sckDVc2SreoNH+qkgJJdE8BTX+h3CkZpHfNVeAChdrsA/Ff
 IRnR/CRF
 rZxtfd9AO/tuWS13KEhvVK8ZPQJqw77eD7um4CHomJVKV2tMp0w5A6m0dqLFdOzCyKn9Gdj9oK4haESb7mSFc9n2IRPCWIXV9LCA2aYKV6CQ+0KkQJvFCp7hjsb861AtNpTDHVCuwk5Bf10OpE2dFU3Fz4eFPFTIWTmJI4KBhZsWeEPkzHfvX0nxoFm/ja86GIbN/Z2UukUSGF+eQZNRUzY9DWHQwAU0xAAkF/XtBtMz8CFdSKOAQcQJenlBk0EIFcCYmwkXPF4cDQs2kx06xVAJ8XRVhPF6LvS/afFNRYcLqmBMuUK0Ns2RVLm4vgR3lNG2s7A62uNEurs8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 13:12, Mike Rapoport wrote:
> On Tue, Sep 08, 2026 at 12:41:48PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/3/26 11:28, Mike Rapoport (Microsoft) wrote:
>>> set_area_direct_map() always updates direct map alias permissions in
>>> single page increments.
>>>
>>> For HUGE_VMAP areas it's suboptimal. Not only the loop in
>>> set_area_direct_map() needlessly has more iterations (e.g times 512 on
>>> x86), but it also causes fragmentation of the direct map that could be
>>> avoided for the HUGE_VMAP areas populated with large pages.
>>>
>>> All pages in an area are always of the same order: either same-order
>>> large pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were
>>> successfully allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is
>>> cleared or when huge pages allocation fails and fallback path is taken.
>>>
>>> Instead of updating the direct map permissions for every order-0 page in
>>> an area, use the area's page_order as the loop increment and update the
>>> large pages in one call to set_direct_map_{invalid,default}_noflush().
>>>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>  mm/vmalloc.c | 13 ++++++++-----
>>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index 5506b180f5c27..6ed6c160abed7 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -3367,12 +3367,15 @@ static inline void set_area_direct_map(const struct vm_struct *area,
>>>  				       int (*set_direct_map)(struct page *page,
>>>  							     unsigned int nr))
>>>  {
>>> -	unsigned long i;
>>> +	unsigned int nr = (1U << vm_area_page_order(area));
>>> +
>>> +	for (unsigned long i = 0; i < area->nr_pages; i += nr) {
>>> +		if (page_address(area->pages[i])) {
>>> +			int err = set_direct_map(area->pages[i], nr);
>>
>> Do we really expect some pages to have a directmap and others not?
> 
> Every page in the area can be allocated separately and
> __vmalloc_area_node() has
> 
> 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> 		gfp_mask |= __GFP_HIGHMEM;
> 
> so generally speaking yes :)

Ah, I was thinking in terms of HUGE_VMAP, because there we sure would expect
all-or-nothing, right?

-- 
Cheers,

David

