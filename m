Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A13F60A2603
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MBQBoKup
Received: by kanga.kvack.org (Postfix)
	id BCCC76B05B5; Mon, 26 Oct 2026 05:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D316B05B6; Mon, 26 Oct 2026 05:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1EC66B05B7; Mon, 26 Oct 2026 05:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5656B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01BA4140670
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:07 +0000 (UTC)
X-FDA: 85364283816.08.5E757CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 188F4140009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MBQBoKup;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZqjNhLUtMM9qzCfqbSSbYtLAIMBnXc3isIanFGM8jk=;
	b=0ITPIUrsb8EhBtNUE1mVFdwVhR3H+2HyUAL5/iEFtUf22ZgD3F6w663/p6R+/xR7aSs2Pb
	Z8xccLpeZs94/9vj2tOkR5bN2Cm7RhabO+oPkBOHE6xwO9ZETtQ7DN7U5/Fw59cDKAFneV
	PhVyf07ab6B77Vquss/yY4pv6T8OFCg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MBQBoKup;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007666;
	b=CUneRHc6ND+NAVA7pZQqkpeXsfA4lqBI383PIGTOScdTZS1lOcB0p/gCyiadiEeVakHYPe
	28aXqfytChWfZJgwxX7vbFZOj8o6GbapDRvY+pWVwMonV9aYSJoMZriUY4ccSXh3ZiUaT1
	zin1+suUG+ALvFVJ/rWMaFKqgBYICQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D3BC43A0B;
	Mon, 26 Oct 2026 09:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAD41F01828;
	Mon, 26 Oct 2026 09:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007665;
	bh=tZqjNhLUtMM9qzCfqbSSbYtLAIMBnXc3isIanFGM8jk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MBQBoKupOvPboBHAGShCa2KQHrEqsjR/MrgjtQuP2sCUGgdjYOu9EegxmvwTqeS0A
	 BhyCWDRazJkTCdvKvi93Chg2Dt9yUC3zjnKvtF8cj2a4zGLqh5ZI6f8JR+LbqZAri9
	 pjdttV/hbpEzrBaTLLeHdF7nRVgYcdVsz67gdzy+qo+ccnK2foO3SKTNOayx62tWdr
	 B0iw3aidemCTPsAIvkYeMn4HjnRBFXQ7HfWuv2F6iQ02aXFnU/W0VSqZm5u3ao3vNC
	 Zh9tR/ItbPiOGYbq8CnVXm7Zb27eTS7lH4NUtCOpOAUjhch2Ric3mQEgBHXljExawj
	 jywrQTpbflAcw==
Message-ID: <1c0141e8-3033-4f59-b247-34dee14cbb1f@kernel.org>
Date: Sun, 25 Oct 2026 13:34:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Zhao Gongyi <zhaogongyi@bytedance.com>, catalin.marinas@arm.com,
 will@kernel.org, Ryan Roberts <Ryan.Roberts@arm.com>
Cc: dev.jain@arm.com, baolin.wang@linux.alibaba.com, lance.yang@linux.dev,
 mark.rutland@arm.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
 <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org>
 <e0f60526-bb95-4d39-9a7a-72cdf32ca5b6@bytedance.com>
 <cc2e3af6-bb56-41b1-9cde-151797c3068d@kernel.org>
 <3b57c214-6a43-4fc7-a531-fb5eac196465@bytedance.com>
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
In-Reply-To: <3b57c214-6a43-4fc7-a531-fb5eac196465@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 188F4140009
X-Stat-Signature: upzuzajrczgmzhe7w75151s1rfrktwuq
X-Rspam-User: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793007665-626640
X-HE-Meta: U2FsdGVkX1/85a83z0fjML+27JDhr4107seUqBzNDH7V/E+weMtiI1Dm8wcmZ9DAqVH9aPVuL574I/Dntsj1fecnbgA9K3Pwppns1fOWc0akxJYwQGPAyNU2FiAQ1W4yZD1l/TP35ywDWDRNAN/gFlQD1uCiHaE5dpGB4TgOuNDHB1QvHECsh2JUYtCxGYjD4+CKR3Ar3HNkljO8HIuhnkPSkVGEI8RUd0BB4MY9IcUawxo0CLQPPb4hJVPWp+s4q9mOyANAAOzgE+gman8cHUPkQ6FCYE5kiFGknjg0/PxXrj7ecnTkweaNkHBC4ercGsLBWO24lGYNQZfd/8q2SkWPXE4OC0grWo3yBkpEcZgY4o2Fl+p3ZpFxMBTu7qVO0FSFeRF3MYJwlOH7XQ5mvJgrX5d1AEVzAgkbxeQu4r2fbCpjUnoF354vAXBEFatzorbXeOT7FU9Pb5QjKiMfpOLjkxCHwlzXRPMWby/ylX2vOCMQGQNVxCmZJoumHrBYH0HZkrpjAwXj1zeS8LIP6K+EgGfg60ZS+6+kz9WuUhBov1Yw4SPYl0DbXmZtkmYEkqtSzgadsV6jzVMB8Xwn3cjP/b3wVNsUOU723Rj9IXaO6E6SYhgLxGDMCYhLSgNlQ46W7l1X+04Ss+X1rCyd+jpWQQ1u1KOIUP0z8LEotVl5GeBJCUyrehlV/w3CZuS5bgMN3kLZlXF7/WLL8BG5rv5VdJv8hbEyBO3UUOgdUGJ2J62wk81almqCS8t+iGT/Wb81USbHRW3qyOkHl1o+tMKehLpuGu/AviNghwUHR95jJMRLwiD6eNbSJlMCuBmXlblzkSrq8rkLJpamqSHs40urx4B2aiEPuKhMl8+W/ScFl+HPYliR5FoEg5qrtY7fdoWhCeEFRDeHAJS3Z/kARvjMY9lBNp7tRx7V1AjS+AHOl9c18L6HwcNYVM0LYhf+q3Mp2GZAb252E9CSQI/
 qkELsy1V
 /Vid/4KWjcM40W4eUM/DYa5a2ugewzW1goSo49OgpaniMYmcxVVkfh0hvkkYDjVtRBHunIyKPmMgE3lrUpSHqpe+kuorpPpp9QEQ1oxIKpj1JckPQncfVjanWTnLXgh1OmDMquKL3KsHE70PsL5QnS/HcgBStkzM+7RcnYoBCZOyeXvZAXVPZr7p5OO39nhCb7YXJpiiTbI+z1EL32PSQOQTCxooB2RQcqv0Nzvel3tXovyJNuTLf3393LmeOHKd4B7QKrF4gIm99tfNY9MgofkLeivJnyrIZ1I+kap9CBIeMfe2tZ6QT2mF8xS1Jh97E8OyJtBq4H3dzFItQ3d7ClPVsiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/24/26 18:00, Zhao Gongyi wrote:
> On 10/24/26 4:55 AM, David Hildenbrand (Arm) wrote:
>>
>> Hi,
>>
>> sorry for the late reply.
>>
>> If we have the spare PTE bit, why shouldn't we just use it?
>>
>> It will make batching over PTEs faster. And we care about that for present PTEs.
>>
>> So I don't quite see why the stable fix couldn't just do it right away? Do you
>> have a prototype that shows that it would require significant code changes?
>>
> 
> Hi David,
> 
> I tried a small prototype that keeps PTE_CONT on present-invalid PTEs.
> It leaves contpte_set_ptes() unchanged and makes contpte_try_unfold()
> recognize pte_present(pte) && pte_cont(pte), instead of checking only
> pte_valid_cont(pte).
> 
> With this change, the guard-marker reproducer passed 100 iterations
> in an arm64 QEMU/KVM guest running a KASAN-enabled kernel. The fork
> and PMD-split probes passed five runs each, with no warnings or KASAN
> reports. In the earlier A/B test, the unmodified kernel failed on the
> first guard-marker iteration.
> 
> The prototype makes the reported reproducer pass with a small change
> while retaining PTE_CONT. I therefore cannot point to evidence that
> fixing this failure requires significant code changes.

Can you paste the code here for easy review if that it the right approach?

-- 
Cheers,

David

