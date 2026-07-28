Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5207FC54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8376B0093; Tue, 28 Jul 2026 15:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A616B0096; Tue, 28 Jul 2026 15:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F906B0098; Tue, 28 Jul 2026 15:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA9A76B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:03:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EBF31204B5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:03:08 +0000 (UTC)
X-FDA: 85039108056.01.5B7121D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4F701140018
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:03:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/xhKUbc";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785265386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+pfR1z05NTPFWfdFSQ0JuF5em6RSzjw4mvOAmMCMbj4=;
	b=Rl9ow5yKtwBS5LymYxnt7FYXjKhRsoApnb2rb7koSHML1y/Ug1ZfeRBJsZl1F6otP7fUMK
	nMaLuFcBujZ35oCzya20BRBYVTfoQuvVNtreXDpZDmr0XtZzOqEyui92J7bcf58iuPbE80
	v+LD+XlWRb3rmSNyNbkgdKBByYBuqDE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/xhKUbc";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785265386;
	b=pXYSExfTCnhxxoBVs1y4DtlWm12FViMm4x1aqbBau8S27/iVWpejvfAtWPATup6NW2cUah
	7ql7Tv2QdlKBuHtDknZXNPzBaDPIUodPymgoaf6iaIj1oZQi03+QWHwDIFSuavEMAh3grU
	FEI8nzjEW65LKltfcR0Py+WG2heOv+c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 798054334B;
	Tue, 28 Jul 2026 19:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63DC1F000E9;
	Tue, 28 Jul 2026 19:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785265385;
	bh=+pfR1z05NTPFWfdFSQ0JuF5em6RSzjw4mvOAmMCMbj4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O/xhKUbcCdVoY66tu9JDYVPT5NzoLMi7b7MxhA3oaUu7nM8TZSw0Es+p51YGYxltW
	 AfzW+EZt1q94wokngKnBu62sqk25+9UjsbzOtPJNERBH/e3zIRcC+mjVTFwoZL4rrb
	 Zd67QJloCcoWErMUWvVo45MUY4i+3tEFQcJD4vnDaYjd/vltErj6FgmHWokUwheUSc
	 APmaCYGhBakjexd+ya6zmUManlzcvZlLaywL6bAd85wNk90G48X6894NPynpWN4c2M
	 s6SsbQPUpsZfT2/GYokgs9n/wY/OGpNWnxRttBgmA5hpj6DvImHaFd94gifqkJnuyR
	 zI4Xnr5RwhiEg==
Message-ID: <f0e39f91-8dd1-4d9d-8d4e-da5d608a7148@kernel.org>
Date: Tue, 28 Jul 2026 21:02:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes 0/2] mm/huge_memory: fix huge_zero_pfn race
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>,
 Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>,
 Yang Shi <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hengbin Zhang <uqbarz@gmail.com>, stable@vger.kernel.org
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
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
In-Reply-To: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F701140018
X-Stat-Signature: sj15g56zodc8ikju7z9bgogwqpdo81jx
X-HE-Tag: 1785265386-290476
X-HE-Meta: U2FsdGVkX1/NfcfUL2jODTFqyftQ0eUFdtbf6shqNMTOWQOCv+DWN5rNgRIWh98Z7x8wQi65AMcGz45Z2oyKifLpg8ZuR6QD4e+0fSWUkEVKiCNLc2lGjbdSe0Eju1JPUT8JKyTSbajNdSkJ+19Dvqa+RN9xdMbUu3/xFUehi0MVbD3DSIEYCdQarfoAdiZ5rusmkAWBtd06ELswDt6sFvt5KXjgQScKcAvdYrA8K25XrV71cY/rhq3+sT/YmrIU+xWzLfRN0e4nUbGsBXdfEvyA+AkTPUuby8TjEEkd6HaJLSUa+mTgI56/BB2gklXdYcvIc5qXj07sGQ8z/YM9Qs2C3Y68a0utr8+z6m4+ktaNCc93xwYExSy0sz0fZPdaiohJKfkVkxhLZqW+6KUqaiH8DVLoQjEk4gHcvryTTxGXpGHyUTHSNiy/lsAIwGkZw/5JLM4F6Ez05gv97sbTPYLbPAQVt6IqG/kWPK2O89O3XO1wSg3qgsz+zQ3iBuUHjPevam1iJHlcJO4j54Rpl4CN54vH8yXCnPy+RlywTrP7m4FZVK+KkFaKc90fFqUn0kUQ1gCTijxkO3U6m0pXGgwJq8JBAMKRhgscrCJqWqkSNCHz8KzkHmopuJJXRJtl3QfbH2eIlroAnskG9mANfgACuwflgyDxTtClnz4cbcNYiP5OuGmANRxkQKx1Y1zJ0H+gbXjFqwCQGBFcYYMkWqlc2EF/CqhCSP0Hi9Kq7gTbKFMgdLlIBcq1pkj6iZP1UrkoBKGZsB6sQknX+6LCFkVl3g61yjIxnABPWVsxerXm2Bop4uRF4nSeYb3T2VNf5JGEYRVXR6+ggHa/jiH0XMmN1C0cqvNh5N0Y+OjpUwBQ3R6eQohWsmskZFjEko7so4WY8PPkM06V1+ntQeR5ljod/z6JMnZA6ONUnaM+LpHQxtoTHOYSiQdvuIjOXP+ppDRBmNWxJ/C8ucz3ezU
 mf3hZk5K
 Jm+P8Z4K6it87EDVewGuo2/+lkBH6VaswmaOiwVn8NESLzqGIM2pOrWACF3VLhUSnX1A9PdLxZaPDtJEMfEb6z6S4nkZ0a+dIk2xUAUv0D3RFfIPdJMTCGihlMdlplRFdMfobwgAWGPZTlugGlcaHNfGqUb5TnFC2Y0Fz+sfzpf7HPy/zsysbEEZ1Ywy0fntXGT/Ns2EzD7fE3vonpq5711MebWnzEpRQ8uyjvzl/DZGCbIXaXeucKdE/N4mVgYc9xAcDnTbnUMFV1YWaA4blNo6IwvktyMxuIYf8a2N+Ohlb0t9BQlVrc2u1dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 14:05, Lorenzo Stoakes (ARM) wrote:
> There is a subtle race in the reference-counted huge_zero_folio
> implementation.
> 
> The fast path atomic logic fails to account for the fact that the
> shrinker (which drops the final huge_zero_refcount pin) can overwrite
> huge_zero_pfn with the ~0UL sentinel value in shrink_huge_zero_folio_scan()
> after a racing get_huge_zero_folio() installed a valid value there.
> 
> This results in huge_zero_folio being correctly set but huge_zero_pfn being
> set incorrectly and thus is_huge_zero_pfn() and consequently
> is_huge_zero_pmd() will misidentify the huge zero folio as being an
> ordinary THP folio.
> 
> This can result in the huge zero folio being split and otherwise treated
> incorrectly.
> 
> The solution to this is very subtle as there is an atomic fast path, and
> thus ordering in weakly ordered architectures has to be treated very
> carefully.
> 
> As a result, this series first reworks the
> CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic so it is separated from the
> refcounted code in order to make the subsequent fix reasonably
> understandable.

For at least somewhat easier backports, can we reverse the order?

The spinlock+proper ordering should be possible without #1, or am I missing
something important?

-- 
Cheers,

David

