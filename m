Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDFECDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912016B0093; Mon, 22 Jun 2026 10:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C24C6B0099; Mon, 22 Jun 2026 10:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C2A6B009B; Mon, 22 Jun 2026 10:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 056396B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:20:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70A0F1401B0
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:20:39 +0000 (UTC)
X-FDA: 84907759398.14.ADABB2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A2442100003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:20:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izEH+IML;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138037;
	b=0r3DE0NAH3lGnqZW0OqjKVQl3b+gOiHo+vMFQTgrTf0Ib0MW3Uw3DCocbUr6MDiHL8tjZC
	eNfLhrOtw6KGx/nwwmFUs1o/t8+2+YtUtnjaTkcfWCzZeLbUbpd24G6Plu0K2Q6rEw0nlX
	m1yq4C3IKjnhrVifAZy7mYDyeExSJrQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izEH+IML;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+Xb3taXT85TT7EwmxpsyqZV0XfoZmQOVxpqJeSH654=;
	b=QYhMOMvBfHg3zYzuYbysqaEM419OrtnTq+xVvCFyw+TMUYeVIEELI7oCc5CD74PgdClDVI
	JaShlL6Vaoy+hqfmAeC11Ph6bLbB6/7UXJHaABir1zAjOtRX/MTjyCiV1vN8ClPnuZ5AG0
	TsjUSCXZ+7ok334WxbZPbb5pjrEkX54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06C15601F3;
	Mon, 22 Jun 2026 14:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606EF1F000E9;
	Mon, 22 Jun 2026 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138036;
	bh=o+Xb3taXT85TT7EwmxpsyqZV0XfoZmQOVxpqJeSH654=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=izEH+IMLy43MqEQDUiW/ddt1sXlIm6bygQ1FyUWsVv9rM9xwKCGswy4pzOhgv8BHH
	 CdKj9uG7LcZO14MM077GtN6Si52AWmOtNc3A6LOCh8uGMMuRdwRhp/PsCRfmyqNw9a
	 JFTv6QmITyZMnGO22xhG3Pvgnk4ykHN40fBflWJtbqMhNWoqVaWRbisSpzAYMfo63n
	 fP2a9oYqnVkja77/ToK0Uh8A1A+OPrtnwwc/CentJDmXlyKQTn9lVJ37srGZXRdQ8a
	 AqeG9rXV+9QN3j8sdm61lD8rFgR7TfUbU5TXvrE1jc+SU7ATiXLi/s4dpGAAjqo3VJ
	 j8cR7Z+QatKzQ==
Message-ID: <6621c832-b399-40f9-b4b6-4519d6c4e0de@kernel.org>
Date: Mon, 22 Jun 2026 16:20:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: page_ext: add count limit to page_ext_iter_next to
 prevent invalid PFN access
To: Ketan <ketan.kishore@oss.qualcomm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Luiz Capitulino <luizcap@redhat.com>
Cc: kernel@oss.qualcomm.com, stable@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>
References: <20260622-page_ext-v2-1-135d4cfbc42f@oss.qualcomm.com>
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
In-Reply-To: <20260622-page_ext-v2-1-135d4cfbc42f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fc8qyqqfp4ayf1of8spfhcg5yhejf66d
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A2442100003
X-HE-Tag: 1782138037-618736
X-HE-Meta: U2FsdGVkX1+CEuFdAoZq3rnjmka6hHZKzjmGxi+eJ+LXB7CtCFgevgI3z1un6n2SCfH6ZZlrqxueFhNZO1EgkM5eqFnm8Bc66MG6DSk7QQH6wWFB87oPxd1LiHcNKBKWak+qIccoVPmAdfhR0ewW8m81B0q6+G0YfCIaP7+TOeSzYv8gLlYMAVTuMdaB27crXLV3Japo922cNlYGo7Ej2XQDgOzYvD7pJEaIfbTMv3n7eB2pl/WKtQnktJ5ZkgD+LI7H/XnQoRaYECAFZR10YmhGKbcpnT+j6uH4vCEQTab00s4bsiaKu7230ZpQZ/dxZK8Vfxx3341+dAa7E5xO42WwEegxndV4L+PwdCB3yyO39S8ZJInwUV7F9yj+KiNihehP26TsDGSVjXc15rybEOG8UmxTO1Efl+b0ZHrUoIvMF5uJkJPJw+pBWdSWEvgtVMPiFVdIiUTsHtnr+f+0l2Kk//RhF1/fveFRU3wApKxQSewsMUPLULZtqBGWQvVQvqbcQGOeMyd0xE9lZ13XU6kV9oGHOvAmZzRZmf5yXcJl+mMnpySgN2OmPDy10css4j+K88A6Jt24Uh86WzHqAI5GCGjgzvZpHYJEwGJ/s2lRiktbP2pnfOeiMyKxkmVQrZl+ORjVkcA6qEBNatnfp5zOhu3UY0KAskLq7noWB7MXm3Kpbj9HXmPx69PE9viYqUHCEpKKyKV8m9ZIotDic2/mt7BNEzZhLcfo6v+l5WM8EO9Zcoa2K8rXI6NCErHqd8jwBIPeaJ2uN0XYk6Q+DywLzV6STpPDTSpLEXC94zM2BZSeit5V6KOM2kuxBtbvSONUVwU6JfBRQm7cg2/01hQx1sWb4dya1USLk3034NtODUWLSZFeKAI7EtbMn2EjD21cohf9MM90mhKUcNwSyRr8LOKaFWuFWo7KZBktD5LkMcYlzl3ZLNOUAp0ZHHaotXLImNdLtoSrLeKy5ch
 D5pkmliT
 uVfg9xahOSrKtRwb+zhQNGJdD+07tUN19SPC/iAOz/aJXF5V5HOvUkdN9Cexui9U+6LvNWzeQLTYGO0H5tO39nE88LpdLBitRZITrvCLu1oCh18ke4LHdYciVcHLa+JlX9oD42bVRX4MaH9eBQAN3BdGQuAlYzXYF9wiSYoVucwB3jaesTOJu+JEjQEYqhy85UHa/CDSJUsbxWkm4yTzcDoA7e7nBuWj9aYrRrSmvCNwOJUcAtchonobBC14HL3ej/gOpgK5eX5hn0KQv3e4uFa0+gpWXjuwCU49qnCv4OkhALl0NK7dcFP3XxfKHKGO7oPO/xiaCidBe64/w/gq01MRic5yxDzW2eLALGTNhetPprvNKbflmfteGv3E0umwxPJKo2MYMfUXUUBjjV+Z4kDOFb9X2499A3LqoLuNPF50zU9N3AVHh9P0CfwVlp/DxIFwXf4E3RVppvcPSH+tij4lyUc5aZWkaOHO/EisZB/lv3Awmo4kcu/Zl/cIO3TTi8jLQu1E2d0lke6oMVR69gwFlv446XILmF1MM8w+Eeu4+DiQ9+kyY0XPkep7+F1ScsJNZUd35X0n4VGyzL0Yq8mCKKq3c8zN4xAnhh3h9RZUhu5iX+bBo2Iil98rnpVmutu2aI7fQ44ZNuG1Gew4W52APjjaR7jerbKXcHyWbEYfNpTgCtqYjFK4p0KwDs83VdR74yE2ZbkeIWgMCOxTgcf1AFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 16:14, Ketan wrote:
> The page_ext iteration API does not validate if the PFN still
> belongs to a valid section while advancing the iterator. When
> dynamically adding memory in the hotplug path, it can lead to a
> NULL pointer dereference during page_ext_lookup at the boundary
> of the last valid section when iterator count equals __pgcount.
> 
> The for_each_page_ext() macro calls page_ext_iter_next() as its
> loop increment. for_each_page_ext() does a
> "__page_ext = page_ext_iter_next(&__iter)" at the end. This
> causes page_ext_iter_next() to increment iter->index past
> __pgcount and call page_ext_lookup(start_pfn + __pgcount).
> During memory hotplug (online), the PFN at start_pfn + __pgcount
> may belong to a section that has not yet been initialized,
> causing page_ext_lookup() to trigger a NULL pointer dereference.
> 
> [   14.555124][  T846] Call trace:
> [   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
> [   14.555127][  T846]  page_ext_lookup+0x30/0x3c
> [   14.555129][  T846]  __reset_page_owner+0x11c/0x260
> [   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
> [   14.571204][  T846]  __free_pages_core+0x78/0xf0
> [   14.571206][  T846]  generic_online_page+0x14/0x24
> [   14.597782][  T846]  online_pages+0x178/0x30c
> [   14.597784][  T846]  memory_block_change_state+0x284/0x32c
> [   14.597787][  T846]  memory_subsys_online+0x4c/0x64
> [   14.597789][  T846]  device_online+0x88/0xb0
> [   14.597791][  T846]  online_memory_block+0x30/0x40
> [   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
> [   14.597794][  T846]  add_memory_resource+0x280/0x298
> [   14.656161][  T846]  add_memory+0x60/0x98
> 
> Move the iteration boundary enforcement inside the iterator
> functions, so callers cannot inadvertently access beyond the
> requested range.
> 
> Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")
> Cc: stable@vger.kernel.org
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
> ---
> Changes in v2:
> - Incorporated comments from David and Matthew to check for invalid PFN
>   in page_ext iterator rather than checking for NULL section in
>   page_ext_lookup.
> - Minor improvement in commit description to include the issue with
>   page_ext_iter_next
> - Link to v1: https://patch.msgid.link/20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com
> 
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> To: "Liam R. Howlett" <liam@infradead.org>
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Mike Rapoport <rppt@kernel.org>
> To: Suren Baghdasaryan <surenb@google.com>
> To: Michal Hocko <mhocko@suse.com>
> To: Luiz Capitulino <luizcap@redhat.com>
> Cc: kernel@oss.qualcomm.com
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/page_ext.h | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> index 61e876e255e8..4f7d7a8709de 100644
> --- a/include/linux/page_ext.h
> +++ b/include/linux/page_ext.h
> @@ -120,14 +120,18 @@ struct page_ext_iter {
>   * page_ext_iter_begin() - Prepare for iterating through page extensions.
>   * @iter: page extension iterator.
>   * @pfn: PFN of the page we're interested in.
> + * @count: maximum number of page extensions to return.
>   *
>   * Must be called with RCU read lock taken.
>   *
>   * Return: NULL if no page_ext exists for this page.
>   */
>  static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
> -						unsigned long pfn)
> +		unsigned long pfn, unsigned long count)
>  {
> +	if (count == 0)

Nit: !count, but we can keep it as is. Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

