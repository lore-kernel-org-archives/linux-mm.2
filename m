Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01B6EB4913
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7756B0005; Thu, 12 Feb 2026 07:21:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E766B0089; Thu, 12 Feb 2026 07:21:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B964F6B008A; Thu, 12 Feb 2026 07:21:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA3186B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:21:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 430321A0106
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:21:20 +0000 (UTC)
X-FDA: 84435714720.04.96C485F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 84C90140008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:21:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YBd+dY2L;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770898878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJ/CTTskL9dAmX5YELQxKPbLjNBe3hCo1TjvwTC6t9I=;
	b=xBCLzn9ssLXlx6f+Jfwg+uNhbBjbkca0hebnRxyT0+odCNqQLYI06/y8J1kIKHssvRmF+2
	KJbpMs5U56bV4vmXS1wg/SG7pVeRYhrPuip4XVE3zBLTZgeLim/o+5sB84Bum5llC83cZG
	Mn6JuIjAWX2Oxpt9Y1O45eGiVL8f8wA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YBd+dY2L;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770898878; a=rsa-sha256;
	cv=none;
	b=L7Idaxvo/1K1ASV8TVoPppB9lYNoT6X5yEvdrtw4plelENZ6VfyF1XZ0QoVnrNcJeq+8SL
	e9IL+dY/eK6N/ZWJKgz/sP5JjWM7LEfWu33pUBuHkQt+xwH0gxIymqgWdyp6eyUqtMaXlZ
	TXiiNm/gilfPqgKtKp0LOxNMUSGQpI0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D127860051;
	Thu, 12 Feb 2026 12:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9FCC19422;
	Thu, 12 Feb 2026 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770898877;
	bh=urP4z9jVhRJ598unQRLo9pS+XZ2qvKaFELJUEkdOJR8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YBd+dY2L8dcZD/RG1CKqIDwjI5F+dsiagft+Jt+z0ZrBbYQ4zTDNA9xAfQzlyJzAg
	 6hzGPTV/w7tTQ8ifJHIJzJtFgJ9ORcxu2oLyo9CFHrQLFbJ77++db/6Ar2evW9wU12
	 SBAZzqKmEupSOmbs1iXS9046heDaaQVlkgpev1Iv4hClWY2JWDZk2I1u6Iublf9/BR
	 HC0MZmt57vaNw+orAJ2O9fUcEJYzTRS1N8ITnKR3zaq8oCmUIeicQQGO0MIBEck8D8
	 fUcxZok+XwpnFDwj69a6fLEIBdtTXsnM/rLna1naUCHMX70DVyJ1ib3wwT0FQGj9dz
	 7psYVoCzpUJnw==
Message-ID: <62404b4a-d8a5-480b-8e22-a406b3e31471@kernel.org>
Date: Thu, 12 Feb 2026 13:21:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 yang.yang29@zte.com.cn, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
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
In-Reply-To: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 84C90140008
X-Stat-Signature: 5minfo1whjerw3p18yghrz8wubeztr4k
X-Rspam-User: 
X-HE-Tag: 1770898878-882124
X-HE-Meta: U2FsdGVkX1+RS76ZcFT/6Z8cRFna7//Ly/Y5DJuUBvCAS+anXxCvLZ0/HLIiNU5wncnDy+gB5c9BDbCIwimh/SSOc+c7x1lvOB13b84YwDHVi9P1u8OUiqhXWTm4l1trt9eg37Nk0GpcEpdiClum1pMho7MMHoat0fE6pZd62K/Dx/HJI2Iv+31Onhdmgma9bCLQQ2V4WakUVWZtrVQY/muPa/o5ODF5PI3WheUw2iiIw9rjNniPhq74hOfY0DbBLK4U3/lTuZwHHiHEBQZI5E+Da4Gwq1+U4dpaMq8uihww9kovZnv9bnDZo2JzKKW3YyKd/GrK2nCpRjLfkn+6SUpYE72DVm2SKuewrhCgoLSvWQZzPoDOE0yTC2Stymplck9ZScP2/i6TDKTGzvvr7QWCMInRfM+7BBE7nbCgA4/gcJB0zopyS44HNfA40+Ma79EKb1reUejB9i3cyYZ+odMj0oCPUSFkrv/+LclsO3aA7h4uDucC0W8x00rCZANu0WDT7QJWcHZ1NynKkCyPBQ4qG1dmTQMRC/ni/xh8WNe44sj0+JZvbh/Og2QgMxAkdjSpwlIDip/vbJWSe8mJO6CHvTsFM0ygAovVyav98TxOVDbX8U96VCYt6oEYXSOoqxpMQk+u9kItl3+JPPKl7zuardLZKbSg1/oGhEmKzCDbrwWK2O2U7zH1cOHIZ0aFwXWlz/CgoRQV+xR51V8NZ8C5VnuI7OI/kXax70RCspKKguDzLj3TVgDJkGaXyRPLVRxacS4Ij9ISilF3hZeKHlMmZvgzV6Nlz5dh+vv9S8of6X20a1v51axcv5ql49qSQxBYCy5aZJC8vDX9ijWlCuzIaBVqlfhR3moZRmlNlKszvAs6JsqftEfcReq9AFL0D9qX8qd1w/ADG984QnzuH1tiMznC0l9p4Zz18/UxWuPyycZwWw3WMtU4j2TZzAmU2hD9s+JmEvHvcHATR4j
 URfcPh5h
 hu41lPG7ejvI0CNh887Ye32Fks3Qfn6cJ8SRfoYsF3L8wbfgrTgrUUWAMyjzIVs2bC5xhbbx1CIJ/1N91iC3GVZhZfIrOX4KmFiS7dMskPNHXhv+whVgvCPQuKYM+1VtUwnMPw0oP5j3+KkXP8DYEZYS+VEOj1H3Y6YWYmShwkCQAbW0sKsk+AV1kCXGMU6MSWgh0bKwqL0RLeRy0bP/NEbY3tcbvxIiM+va9LxAKA1vXTjGFl69hUfY2aWGnA5fC6OBx8Xe27CXPO6wJ7B6U6MpQlbE6qxq8izkLj1HUPyPCyVr6d/BAfQEdaabfQvsZek+R8LnnRtGNx10QZn0EVpn1GPyCPneuArD2+i6Ws2qPk2x9TveTX3zxJ9cKF5LKFAz/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 12:30, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Problem
> =======
> When available memory is extremely tight, causing KSM pages to be swapped
> out, or when there is significant memory fragmentation and THP triggers
> memory compaction, the system will invoke the rmap_walk_ksm function to
> perform reverse mapping. However, we observed that this function becomes
> particularly time-consuming when a large number of VMAs (e.g., 20,000)
> share the same anon_vma. Through debug trace analysis, we found that most
> of the latency occurs within anon_vma_interval_tree_foreach, leading to an
> excessively long hold time on the anon_vma lock (even reaching 500ms or
> more), which in turn causes upper-layer applications (waiting for the
> anon_vma lock) to be blocked for extended periods.
> 
> Root Cause
> ==========
> Further investigation revealed that 99.9% of iterations inside the
> anon_vma_interval_tree_foreach loop are skipped due to the first check
> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
> number of loop iterations are ineffective. This inefficiency arises because
> the pgoff_start and pgoff_end parameters passed to
> anon_vma_interval_tree_foreach span the entire address space from 0 to
> ULONG_MAX, resulting in very poor loop efficiency.
> 
> Solution
> ========
> In fact, we can significantly improve performance by passing a more precise
> range based on the given addr. Since the original pages merged by KSM
> correspond to anonymous VMAs, the page offset can be calculated as
> pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
> defining:
> 
> 	pgoff = rmap_item->address >> PAGE_SHIFT;
> 
> Performance
> ===========
> In our real embedded Linux environment, the measured metrcis were as
> follows:
> 
> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
>              and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
>              in a loop of anon_vma_interval_tree_foreach.
> 
> The result is as follows:
> 
>           Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> Before:  228.65       22169                 22168                    0
> After :   0.396        3                     0                       2
> 
> The referenced reproducer of rmap_walk_ksm can be found at:
> https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/
> 
> Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

