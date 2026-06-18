Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D49CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B013B6B00BC; Thu, 18 Jun 2026 05:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2606B00BE; Thu, 18 Jun 2026 05:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953DB6B00BF; Thu, 18 Jun 2026 05:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28A086B00BC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:12:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51AF516656A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:55:16 +0000 (UTC)
X-FDA: 84892273032.10.EC43A4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 980C240007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:55:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hR68x+AP;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781769314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkAdqSMgT4IE675E96Ud/DGR3xfZxz5Ydu1hH9Sk92I=;
	b=PQpsPtYV3RgWxO6c2/8lkDZ0nQXOGdiKKnJ4rppqffUrQHclZGSdptU2vVEwHj2rfexgci
	gBpkRcHTwxAY8htLABiotI8ILIn3nb1YITEtE+TEE++P5lSZrWFv1FVa4Ty/Aef/5OJb89
	9HeAbpMXWGDNK7BVIEph/BA5xTaupek=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hR68x+AP;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781769314;
	b=muRIfcKIpncC1Ie0zM4NS+KxcxBqgVk/RkEXk90NhR7ww1KtVcTSk5c305pwjN466NTeoc
	qBL+TKhX5vfzgHpigAvFyOW933UCkVt3aiHVQcgo/OAbdgyNLRRZyK7kVMtx89WVn3GTpv
	nKaRO8ohfEEdsic05enChzzk5ChcQwg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E3CB60120;
	Thu, 18 Jun 2026 07:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7461F000E9;
	Thu, 18 Jun 2026 07:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781769313;
	bh=EkAdqSMgT4IE675E96Ud/DGR3xfZxz5Ydu1hH9Sk92I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hR68x+APscYPTTUaaeyVnTYO1e8f8HwElrVN+2G6wh91nB+LwsFxXXXIejmWEdWDp
	 /l9MGTfHL/0VF3THyK+v+ac54bbE5/lIu4RBxr/g/NMKCjJm0TTBxEhHSVIuX2d8hv
	 gpYTFyDUcAVjTIStNCVJWFT70x08K7Ueo29nH8xyG1FIBfPZ4elpycbbouH5JLA0f9
	 zGSwLwPQybL54Ij5H2cTM5v9c2Kq0nshQZ4bfWYZeDNH/oLuRrZNI+AKs1lu/oMC+K
	 w3FsFRymcTRQg1xLP9J+CC8XWaEtRssmH7OEoR8NDsenQkYURPBLPhr4irtGhCxTjX
	 dRWQSXdVcPQWA==
Message-ID: <d6259e43-e507-48a4-a048-93b5df2f1b62@kernel.org>
Date: Thu, 18 Jun 2026 09:55:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: Lance Yang <lance.yang@linux.dev>, dev.jain@arm.com
Cc: akpm@linux-foundation.org, ljs@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, hughd@google.com, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
 <20260618074449.24974-1-lance.yang@linux.dev>
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
In-Reply-To: <20260618074449.24974-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 980C240007
X-Stat-Signature: 7x45eri1t7jcgu1sz3r59rx44acy91s5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781769314-564715
X-HE-Meta: U2FsdGVkX186qx7O6EJJVY5bNoZlnYJi5HVqoO6qZwKnxC6jsaTRL75GVi8TgGl7c6jjh4VJqo17qJStmIdhOQFuyoofj3tDgxrBQCdJF3nPQHQIwQA6Z3AfcNsNuLIVarXXa7/DIQQH3M0tXKv9/+4vy9z8P2R8xyKOov34Rk2SfCCdcnn05ZAP6e35suT8v9Y6rhI7+HOdfzBttUTeks1tL3vdd5mfTEAcmN4pak/aeqBskiSfJ9cAde2qJ23UB1ZpoyhhLHxh1EC7FYIpMt991W3/29aGT+vjjKKGmen+mVb5wVJFrpoo7PNtNBWp2WY5++LneupL9PWCvxy/JiebhdWcVfnYG8RSUG9DqABcZZJC+asf14vs6JIMcny6mPBbrieOptO26SsFd/UizLXAgm67bxVz1L89DQ358gf9EuOpA5cVF54bA2Ihfk5tysmwDIrgrUqM5LZYxj/dG/p6288Ru511sda9EE6kJTgrWTFybF0mxdUmebMStWxhuY7aEC/ExJtBLYWm3rR3U+fwmT6RG3XdvGKB3kFxOSaWNYcsayG2NV8UEk6/zUjFK8qO/t6DyD8FZhCy52d7isiThZDxphBisxHVLZFkpHqUUY2pC5NEkcTYn0Q0Udd39jCDNTzU/XEq38nR6O66tlM7NKmQSwoYxuPwr9+T7fnXtwdRc3amgWThEQD8F9hB3u1W2pC1CGGiJu7CNRN0v7zfYDKm2MB23Ns82m21uCRrhVJfT11rngcqYcjjNxLyQqWn9fev3rvBVe3+FJKD6Cxfj4lb0l4p9QBIqdTf7HSFebfNQ96NAY6dKMEj4M0zr45oL0wmNTSwMrQEpUecgMuHBa5XWlq+BHCpWwfAm14KrMn9oj5weOmUUOMvTrBaShCnfaIaCkUEZZf/B3hZ8O0pSuGjYQFMw4Fvaz253Z0N19gvg2E23H5M/Kdi/HPvd/D/gSmDeDbIXjVq8kr
 P+SqHZN6
 U1TI6thRflnVAcgNS5u2EgYRbwyjpYSqO1PGh42FZqbPBPF28yOzn49GM5xnFwj+VJQByvUT2x6F0DOdlOZugV+We7+j1Eh2s6yd0ccZe+3FlshQKjFsm8XZwSdlj3Gv7QJMzoKGZmK2cS4DAuuNn3Bx9ZI7UNm1MRg4QoBc5PK2+G81zkIV7WTxAOs0oml2hT3W+iEHiGvANHvHClWZbVskNlYm/2eVeLO7QxnW+0v0+/swWOk6JZ6CW3p9AgRVoUikG6GQIME2PcnwgumUgyRsmtivHfHEg87gZAnhQ5GAw16MKC6vqhyq7GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 	return __rste_to_pte(pte_val(*ptep));
> }
> 
>>> +	VM_WARN_ON(!pte_present(pteval));
>>> +	subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
>>
>> No need for subpages.
> 
> So plain ptep_get() can feed raw huge-entry bits into pte_pfn(), and the
> derived subpage can be wrong.

Good question which impact that might have in practice?

-- 
Cheers,

David

