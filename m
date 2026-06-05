Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75797CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC1F6B0005; Fri,  5 Jun 2026 14:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893E36B0088; Fri,  5 Jun 2026 14:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A93E6B008C; Fri,  5 Jun 2026 14:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 687786B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:07:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 247664023B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:07:21 +0000 (UTC)
X-FDA: 84846641082.20.69D652E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3ABCD4000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:07:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=alsX+KfK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780682839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Nhf4jMO4wZRRzTPNpV/mvbXK0GYYQL5VEX2HgG0GMc=;
	b=OOx+QQ6MRosbgJqEeXBE0eKNv2bHAWO2VBShsBiPBzEnlQ/g7qE3HPA/yDiDkcVfymEC4R
	Nn/dy9uCvgZ48thtVPjObu9WXEy3D1rdhL8QIVmS7paTsf4QIK6Gyb0Q5lHlj8AL9Nyg75
	3Ux/BQ7N1z6SrMR/s+juCZR+uQENqCQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=alsX+KfK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780682839;
	b=U5D9K4NvnI0xwUv8J8kMecAQlPtRnBmO0J90cBxlTYuEtMVobW2RNvDwwMq36DbMuKCO4l
	z6zKsHgVTPKVHWBtbViuzuKfVS1eiHZnVEDxd6a7YKawi9booZcqgo8FUj7zJz5dkywbOX
	GXAmlDHpKkzOLA1mXMXsBomY6OUEqAc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3800D4348E;
	Fri,  5 Jun 2026 18:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07371F00893;
	Fri,  5 Jun 2026 18:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780682838;
	bh=/Nhf4jMO4wZRRzTPNpV/mvbXK0GYYQL5VEX2HgG0GMc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=alsX+KfKpBh3DHmOFR5AfpAGL8a8etxlfDAQgLlShE1jlMui4LaKD9+wiWQ42voDK
	 1xswb8uIL6om3S/gp1xwoeb6UEV8V6IWwkyfi/D9E9zDXUSCioSbKg2AHA+ZrY0BFE
	 2KZS4fs3fhWH8FIlfVJojSt6RX0bDEHEVF7OVAvL9h5+zR4sBRDLw10YjMYHjRWVgn
	 LXwdC3Lvd34Oo6pG+yR6gf6mEfv/QDjo+K/VcfEBfifFGZZYnQsb2tocaaxiIlJQfy
	 HTJTIbHVLR3z0JuQ/r1Hfi/yguSuZcybRH5O8fSD4DHd+AMDmED9H+IOjsNtAauyay
	 1dFEy9B6/ISyw==
Message-ID: <177704e1-03b3-4791-9a69-9b83b72d61d5@kernel.org>
Date: Fri, 5 Jun 2026 20:07:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v19 00/14] khugepaged: add mTHP collapse
 support
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260605161422.213817-1-npache@redhat.com>
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
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3ABCD4000A
X-Stat-Signature: hktf8som5zge7hbn1gzoaf9jqz8p6j6m
X-HE-Tag: 1780682839-353588
X-HE-Meta: U2FsdGVkX1/c7EYgAjwHicdSuguutGHBNWPBgmWfEREjTfFPXpEngLTBjX0YfSBCv3swAYENTJ6lHgnYfeEHbg0sWXgB3OOHEZXlD72Z7hHR/aXeh0+XRBQ8Xc/4w1/vBX1uasRy/pl0kL+NsazBWJX87cJyZSeyXqW5YnD16qWFA3Wyh8b5Ce/Qii81N22tXmF2ZJoYbDUACNk2sblbQuyyc04r4siRzmvd39a0a5F9FrD875DkuXJObVGhZ+vfiOQoElbnJyCN7y5JpRxWhyGWqNJ6+vtVC/W6QDGPRo5NTpJLR3o1Jcbn3b4U+KX9GrhXgZjE1dB4N63zsvo3f/uVA7XTJD4yNuqoP/4Ks7CqBS+aRd68sT64Cs80aSVU7nLvSUVxoRkUS3BsrryKLh32dBeUTn2t1YiGJ96vQey4pBpsB3vmdjb8FID5oF8xV9erEY1yvng+YMbz+u8cP8bjWm3EVMSQU0nBuvttczPHRrKPwNd6ZKM9HwlI9njh4jXl3pQhtm+Xi7TErzFgcCmfPJVhjMFKNNTK3L+Seq8armmOg38pBZCBBfBAi21AKP1DOUVypPc1hZtoT6FdluFNJSyys4b5Jz5vgRWG+PwUVerZ69AprNFx1aoLf1kjsNJZsWz8GZv6w+X6DSBwJOstg+fiN66B6ksFaeTggF8RqPmU49dN4NKRGPNmddOS56pNpFgDUbI1SLfD0fEFT/otu+08BbaSaCPZY2RjNK0xm7ZIMJlWwLuDcBEDXL+7ngUOxSF5THr6GCIYdHCU8i7eIpLn8MVAWZW+T+S/D3If1ziE6uIxBhEO/khHwoj82VYW8Ds9AmSGi9MQNNZTkRX+En+Q7TgiAKUNkorOdmn+WHSYRQbJeogzklHuj1YWlFK7tMylfh5vFa/huiu0R7LB8GiUDZo0GvTs4Eus0UBNnyikb5EQinSHVwxfl2eCumqSl5KFzudmQX5IGhq
 U8vaOLpu
 2dHL27NtX4Ms1ozoQASE6sDUOO/FzZKU2+Ty5fIvX+NpdlnhfmC5PmWLGhpNJ5j3Y8IvGEcgTbox1B0L7ZqbsPzwxtsP3JI39hL6lp3neEUXm9wV47vYqaY9ZkbDcNSn9qDcEAR/Xsz9PdCojnbpx3sUS7DAA3kNNCm9eRUKU/y0Flz7EPqphE6sB7XiTkPNV+7pCMiqGHEMhjBeNqcxFsakvbEyzjdO2+56QGhM51Qpq323egPb64rIgeUiayUdSMSF/5Qi7O4E6ZzFTCskJgxKSTCn85+rc7jK9VSjqKGceFzcjGn1sA/RyHoGxsUQPdZ4PyUjklMoqCRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 18:14, Nico Pache wrote:
> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.
> 
> To achieve this we generalize the khugepaged functions to no longer depend
> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> pages that are occupied (!none/zero). After the PMD scan is done, we use
> the bitmap to find the optimal mTHP sizes for the PMD range. The
> restriction on max_ptes_none is removed during the scan, to make sure we
> account for the whole PMD range in the bitmap. When no mTHP size is
> enabled, the legacy behavior of khugepaged is maintained.
> 
> We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
> (ie 511). If any other value is specified, the kernel will emit a warning
> and mTHP collapse will default to max_ptes_none=0. If a mTHP collapse is
> attempted, but contains swapped out, or shared pages, we don't perform
> the collapse.
> It is now also possible to collapse to mTHPs without requiring the PMD THP
> size to be enabled. These limitations are to prevent collapse "creep"
> behavior. This prevents constantly promoting mTHPs to the next available
> size, which would occur because a collapse introduces more non-zero pages
> that would satisfy the promotion condition on subsequent scans.
> 
> Patch 1-2:   Generalize hugepage_vma_revalidate and alloc_charge_folio
>              for arbitrary orders.
> Patch 3:     Rework max_ptes_* handling into helper functions
> Patch 4:     Generalize __collapse_huge_page_* for mTHP support
> Patch 5:     Require collapse_huge_page to enter/exit with the lock dropped
> Patch 6:     Generalize collapse_huge_page for mTHP collapse
> Patch 7:     Skip collapsing mTHP to smaller orders
> Patch 8-9:   Add per-order mTHP statistics and tracepoints
> Patch 10:    Introduce collapse_possible_orders helper functions
> Patch 11-13: Introduce bitmap and mTHP collapse support, fully enabled
> Patch 14:    Documentation
> 

Went through it and didn't find any blockers. Let's wait for Lorenzo's assessment.

If he also doesn't find anything major, I think we can move forward with merging
it and handle smaller things as follow-ups.

-- 
Cheers,

David

