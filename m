Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89595C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851E86B008C; Mon, 20 Jul 2026 05:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802E86B0092; Mon, 20 Jul 2026 05:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719376B0093; Mon, 20 Jul 2026 05:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4876B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:30:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C439EA07A7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:30:09 +0000 (UTC)
X-FDA: 85008633738.16.74A1116
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0148210000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:30:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fyLxYwAI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jiYeVsnBdIvFuQsIGCzuuAuxcFGL3XUJywevOqwgEe4=;
	b=1SGYm9TvfNwzQPXGXnUEM4ff9hOtlIt8By4swxsa9jNBU5z4oJURbXjVV3l24VS0mYrCGn
	Qn1atQaxHZ3xvClg8wCGLBiA13pm4zkcGmKRn9DggW5UgokicgLSSPCjPsmgFjvLdk8Gjt
	A0IwfPPHDnXbrp8gdACnSXbmcR4mmRo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fyLxYwAI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539808;
	b=s+6QBm0hc7A/2sCajTlmOR+B3GB8TxJlbe0ZIrg4erc+25p9mpayGjExbMKckUT9mH6l2Q
	Y4K8/A8id9xSKf6oTa225bBEUMo8LDx1eW0aZ2h6gQcFS2gy9pI4JaeiLSXFIyMhFDOeEc
	g/EWKke1rYFsHruRGvEmWxq92Qi0ktM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B15F435A8;
	Mon, 20 Jul 2026 09:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AB91F000E9;
	Mon, 20 Jul 2026 09:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784539807;
	bh=jiYeVsnBdIvFuQsIGCzuuAuxcFGL3XUJywevOqwgEe4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fyLxYwAIg5Ni1Hk+A0p2yIhUb7gIsYKAJdb8yjiUhm8CLIdJ5Vh1hd96FbCNZLwm8
	 5pUAFO+AygfYbbH0pW5ennR/j97lDiGgd3TAm0sZDRtqa6IB4/J+qF1QH+GtoQNe8M
	 P3w+i6/wRs2FHfUOF7UkvcPSZlrTNo7MvWBIrDwugfBrQIropv3e4IRaEnlkqcX8BP
	 yyJBXPb97xkn/l0eO4kTKcpNzzi4+T8r1y3YJu7bPFcu/n8PFohsRYw9hd0444di1p
	 C9JIyU/OHWOM8pJVXrjlRMPEKZafOIb53Wky/6b11EUnAGpO8bhmkFzMUOKRTbt/6F
	 /gsWbWCSXzcOQ==
Message-ID: <1147ca8f-166a-4236-98b4-0a37442cae1d@kernel.org>
Date: Mon, 20 Jul 2026 10:30:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] fs: stable_page_flags(): use folio_test_*()
 helpers
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, luizcap@redhat.com, willy@infradead.org,
 linmiaohe@huawei.com, svetly.todorov@memverge.com, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260720033021.4091944-1-tujinjiang@huawei.com>
 <20260720033021.4091944-3-tujinjiang@huawei.com>
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
In-Reply-To: <20260720033021.4091944-3-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0148210000A
X-Stat-Signature: 7y9qbp9ofcj6a9mikbqmdwabgwh5fybt
X-Rspam-User: 
X-HE-Tag: 1784539807-167725
X-HE-Meta: U2FsdGVkX19OfPLpFhKgAIVxtkJyQr0omeym9s9CUEQsdB1iMydVc5nblO9aMU7KtTxULaXvLEakB7AZodD4PyQGPqZuLgNHbA7uuo34PMyJW0NQ3K48CXOt/Uaruxd7Mp3mzpbvjJMGNzDGyYVHykkMLpYXgswsykehK6wjUaq+PQiapGgZJiVCYq3b+bBznYSFkwjQSeRGjJuhmAZkm7Rkn4QUH3dhH1bBXOqgMhil4nEZDkPScMSP/XcUxWj3jqG1IkhHTHnrBC7hR0bDPfqLbcvxyg3NNP3AZrTzSAHPojUQuRUPnK7DNJSnJTVseHCtypY3/DOZd31ZmzyzoqvQaN5EPp5Z6KjzUsuvyxmtoYOcq6J2NXso1AGP2cy7L06LX35FTlGukzky6yIP1TXPssP7X8QfqKTIk5YD32xxjyAmTgYHZX36l6AkXUdYZ3yWfwgeEd7kltnNASasY32CcGEuRZaKJjQ20cgfd8VGChLEA8mE+zds+MJjBnD8aF8kdd58GN+Oh1Tf4qxtFrdIMHSQn6JdR1FPR9G4TvCaw9LFcvZjiiHD+VCrL9FTw7pLbZ2JXnvJyGM/c7VEv2oM8zaeP60qmEfRalNMfxZoY3IB20TsoWIuywZ6cI49RTSaNcr/Ih8UClURB2/Lj4yCNLUoKJoOAPEqndOY3H9bQIVaK8sRL8nwFM8tF7IsIF+MsQ7ngFXNpi4LQLDsgaKpj+Xt9JNPInsm68ySLdZgw6Lnba1PIvLqs0mj1UbamOdIpZ9KOjMRXd8JGOusEVdnn8Y4hZBVR7iA8zJNx6az8Nbc7GvdBbaTdwnXPgXvmcCF8OfqjANbl8ZUSiouuR1MyZNIbWFWJ2+/wswM5FJaTy0LUl9S++JaQea/bY1gfySQduJ2JAG+T6HBaBkrZ/j0k4WsdklZlR5qla6O48b40FlVSPEX4uASQApNdZgS+7p7HHGwg+GfS7bfoDj
 eeeRVi1S
 JbhpdoFpCXmUI9spJdyHWvFuZNwAEt9uOrlLAUbXotXzcDEjOs2qvaAYeMNjoFAwOvuZFg5m7wJl/nIJ8nWyfaYtqF90/NM2yfAoYs5hUReo3ugW9u6y7jpAlRcAci0aqNW8n6TC3txeiAF4vZm9Bftz4QdcLoT209TMO2eZ7sIDR9d2dC64BcWzpypMmJKv4w86LWe6VI+AKhYGQW5JCndMIP7cdHj3MFMr77Mf94tvCaOtfFRynNvwAa23xcnAcF47GuuPnDyedekdTEJUyuZ57oXVduiJNXVEHzbBZWAwmuOYcSNXmN+i1BjQT+ix/hpt5VJBz1LsBo7vohkjlbXFEVnrV1W4vhvi7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 04:30, Jinjiang Tu wrote:
> Since commit 304daa8132a9 ("maps4: add /proc/kpageflags interface"),
> /proc/kpageflags directly operates on page->flags to determine page status.
> Later, commit 177975495914 ("proc: export more page flags in
> /proc/kpageflags") started using page helper functions when exposing new
> flags, leading to a mix of both approaches.
> 
> For tail pages, the original code did not return corresponding status.
> commit 0a71649cb724 ("/proc/kpageflags: return KPF_SLAB for slab tail
> pages") and commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for
> "tail" buddy pages") made tail slab/buddy pages also return corresponding
> status. Then commit dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
> made all tail pages return the same status as their head page, except for
> hwpoison and mapped flags. It also cached the folio's flags and operate on
> the flags directly to avoid concurrency issues if using folio_test_*()
> helpers.
> 
> Since commit 476d87d6a061 ("fs: stable_page_flags(): use snapshot_page()"),
> we can now safely switch to folio_test_*() helpers instead of directly
> operating on flags, which is more readable and consistent with the rest of
> the kernel. Only convert cfolio-specific flags (i.e., anon, ksm, swapcache)
> to folio_test_*() helpers, which reduces redundant code. Keep others
> unchanged due to they aren't folio-specific flags or coverting them doesn't
> cleanup.
> 
> No functional change is intended.
> 
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

