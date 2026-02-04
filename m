Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F4CE9D41C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 17:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491E46B009E; Wed,  4 Feb 2026 12:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F896B009F; Wed,  4 Feb 2026 12:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D986B00A1; Wed,  4 Feb 2026 12:12:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 21C5E6B009E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:12:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5847B79BD
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:12:45 +0000 (UTC)
X-FDA: 84407418690.21.5CF2C97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DCF961C0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:12:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J4KeQgPV;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770225164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZQMhdquv2NS/PLqUiw38q/qvlItLTMZJWdvTP+LyhA=;
	b=5V/aGT4KF6/xRak93NVyTjaKPnScvDjPwQfW+Jf+rzE8lBMKGwQd86t+7YZ0YA/YMQGZFx
	tA3pZsNXMtnFsmRXBztynJMY33LIdTAp2IM9RM36SJTX7z1Gbmf0zbkqPHDP0esaIZfnkm
	9G/8xOXJ8HGzE/I4vq917JpXMiHKd7E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J4KeQgPV;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770225164; a=rsa-sha256;
	cv=none;
	b=hbnh3FidQ3vbwLgo4QXiZO9/fAUo+KOshkm+ElxNiZGJ1mgW468cZZvy/k4hx1FHTe7SxG
	CGFH8t5otZJID0ex+Q7g8AVeraxSltzp9VzVfYHnz4wBe/gnI2wwuenWRvBDMsrhFUFJX6
	pkZPj0IIVplUZ0cxzNfLBAKnoH3maH0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF807402E7;
	Wed,  4 Feb 2026 17:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB9DC4CEF7;
	Wed,  4 Feb 2026 17:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770225162;
	bh=DDox9iqfp0i4JC/6NcCt6752mDlSxPpB0Hn6t8QtWDg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J4KeQgPVE2hE46eWU/JJEsLoTYy+n1udO+5vPv7pV6dITFlmyku5Q7UI6/Pqt9PBI
	 WccdtQSU5v7TRTA5xv3dj8Dy04VSWdOEUg3VqbxDONyFhXxcHPx9FUAFKeH9Czj6+i
	 SG8yRtBsk586nBcliYGLpcUUp//d32MCzyax0zWAgEWkblzmBoAjcnsq17agPUtlR1
	 ZQUqvj1Oh43Z72XGk88R6cobm3wtiP6m+QrjUQyI2vurjy6ttYYvhjrUfZ2thoKlQE
	 l8+WgBTWdXePjRCITX0DBW0SuUWSKMUCRpgDakEBx2rU6U2IgQwhTQbl1PTU6TJec3
	 a4G3ytIKEUUWg==
Message-ID: <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
Date: Wed, 4 Feb 2026 18:12:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
To: =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
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
In-Reply-To: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DCF961C0004
X-Stat-Signature: uqy3rqtbqn8ndgkxg7xy5s6cgffmw7kr
X-Rspam-User: 
X-HE-Tag: 1770225163-557505
X-HE-Meta: U2FsdGVkX18qcthEAeiNbAVogwSe55ZkkwGf57gmOMhRhz7EL1Upntx8pIr3SDvmGDjL0BfqeGdkNNn/iv/fYRNTw8qJeksM6K3pZbar7nrzEzanxvHULXqlJOSQ379OtB+BiGi0kP/lpdfVHUW/Rnwsm2ccWcaUOzv2IhCI5RQKbJcrSGKYOrHUlMGIj7hvIUHfqKCOGWUFOAMC0viL+C3I8TNTkoOWJDIDmH5V9sgssbS698eq9h0M3OXL8WmwMpv2nFIhffQGOFcdVBJLLLtKntJyYTMqRiXw4/hqMgixhjmvXpyK+HALvSuF0ENDAN/sg+yGlqnN41zQcHgwiwaDIou9JTNhUcxeHpT21c4pOGs319qVxUAQQCNlR01jMuc1/A/ypmFyH/AOevDGdIjJSFIcZxHphXyXwrLqUUu01NjUtR13rwRHXQeZ6Angy/4PMRE60wI9pYsdRJcNPkREfO1tKq5dYL0Ja+Bdlnl0ez1TTKzbgktvWY0bNteOTFPF/JjxzARShcOmCCyYUAFffC+tYxmJmueoeg4IndtI2Kg36Ffo9OUxR5cCBPOBUo+G6j4rtLmKAcovuLHiGu8f/lQgcT5bk7LQaM5VKtBymoITybjk5wdez+1JltsnvBioTfIwMFb3qQkJT/noYmqzg8u0ujc/dl6jkOX0olWz7PiMDmfkCu7KUYGDU5joOdxpKbngQyZzcXTY0pUDdfnma2TapBqEGguMgJMVZocLFxcuHa7ilPI0gUB/iPgzy3pRVpeqTENaV98klM0Y05LB8r+3K85X/N7c3xqb1xspTsrny/POZJuOg8JAf180NBqtY2ICK8zKJZUlEhs9djn1JTVmFHDAykSbjAzc5AcLewj03bf1xcZqy7bKNaWBjukcajbEe/MDa/8iqz5zxnxnQyjRaT4b3XEeoP/SYEcowSzijkACBQ/BAn7u/H6U/BP6aZjB0V1zBEKliTz
 jF6/2ADM
 aTur0saUkkru3hHzMqejlrMDZ40YtXfqQ9De9rYj8ZqwyuRzvUwbj1xjS9UTNJXz6k69YdwF1ZJ3aS7B0DpkRovogBdzEPBRLa4lH6Fy3EaLIONzu8lCdKuCL4N4pJfzEE0rv2m3rmNBv98H1Hn+QOiXRjJOV5miCx7fNxhEV3kIh0KEAr4ZILv+l1l46Iqa3/eUzfKmBUYtvHwOtJaWh1U1EH/9edIHqhetMFhzwxMNUZ/c7sIi8OpZMm5jbuTlMGVumUarxuU6/hF7fyL7Wdzv9XB0H6+FK6waIsC88nc2nBUrHND37nwAjhQDS2bG0EpMcZArgoDtS/4OeOcWlQe+/P0jhf/shFoIZ+NVpzIwLGsOk/Ju8CWTcU2Hdi5c62qtkrYrIyg20b3k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 13:49, 是参差 wrote:
> Hi,
> I’m reporting a reproducible WARNING triggered in the hwpoison / memory_failure path when injecting a hardware-poison event via madvise(MADV_HWPOISON).
> 
> The warning is triggered by a syzkaller C reproducer that:
> maps a file-backed region with MAP_FIXED, touches related VMAs, and then
> calls madvise() with MADV_HWPOISON over a large range.
> The kernel reports a VM_WARN_ON_ONCE_FOLIO(1) from memory_failure() and points to include/linux/huge_mm.h:635, suggesting an unexpected folio/page state encountered while handling a poisoned compound/huge folio.
> 
> The target page appears to be a compound head page (order:3) already marked hwpoison. memory_failure() seems to reach a branch that unconditionally warns (VM_WARN_ON_ONCE_FOLIO(1) at include/linux/huge_mm.h:635), which usually indicates an “unreachable”/unexpected folio type or state transition in the huge/compound folio handling logic during hwpoison processing.
> 
> This looks like a kernel-side invariant violation rather than a pure userspace misuse, since the warning is emitted from an unconditional VM_WARN_ON_ONCE_FOLIO(1) site.
> 
> Reproducer:
> C reproducer: https://pastebin.com/raw/UxennX2B
> console output: https://pastebin.com/raw/wrhKRwZY
> kernel config: https://pastebin.com/raw/dP93yBLn
> 
> Kernel:
> 
> HEAD commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
> 
>   git tree: torvalds/linux
> 
> kernel version: 6.19.0-rc7  (QEMU Ubuntu 24.10)

@Zi Yan, this is weird.

We run into the VM_WARN_ON_ONCE_FOLIO(1, folio); in min_order_for_split(),
which is only active with !CONFIG_TRANSPARENT_HUGEPAGE.

But how do we get a large folio in that case? folio_test_large(folio) succeeded.

I think we rules out hugetlb before in that function.


Looking into the full console output, this is an order-3 folio (fully mapped).

How do we end up with a large folio here? I am only aware of that happening when something would
allocate an order-3 compound page (not a folio) and map it into the page tables. Yes, that
is nasty and can still happen, not sure yet though whether that is really what the reproducer
triggers.


[  451.810860] Injecting memory failure for pfn 0xfe28 at process virtual address 0x200000000000
[  451.812878] page: refcount:10 mapcount:1 mapping:0000000000000000 index:0xffff88800fe2e600 pfn:0xfe28
[  451.814740] head: order:3 mapcount:8 entire_mapcount:0 nr_pages_mapped:8 pincount:0
[  451.816263] flags: 0x200044(referenced|head|hwpoison|zone=0)
[  451.817414] raw: 0000000000200044 0000000000000000 dead000000000122 0000000000000000
[  451.818924] raw: ffff88800fe2e600 0000000000000000 0000000a00000000 0000000000000000
[  451.820422] head: 0000000000200044 0000000000000000 dead000000000122 0000000000000000
[  451.821835] head: ffff88800fe2e600 0000000000000000 0000000a00000000 0000000000000000
[  451.823276] head: 0000000000000003 ffffea00003f8a01 0000000800000007 00000000ffffffff
[  451.824701] head: ffff88800fe29e00 0000000000000000 0000000000000000 0000000000000008
[  451.826113] page dumped because: VM_WARN_ON_ONCE_FOLIO(1)

> 
> 
> head: 0000000000000003 ffffea00003f8a01 0000000800000007 00000000ffffffff
> head: ffff88800fe29e00 0000000000000000 0000000000000000 0000000000000008
> page dumped because: VM_WARN_ON_ONCE_FOLIO(1)
> ------------[ cut here ]------------
> WARNING: include/linux/huge_mm.h:635 at min_order_for_split include/linux/huge_mm.h:635 [inline], CPU#0: syz.3.7564/25556
> WARNING: include/linux/huge_mm.h:635 at min_order_for_split include/linux/huge_mm.h:633 [inline], CPU#0: syz.3.7564/25556
> WARNING: include/linux/huge_mm.h:635 at memory_failure+0x22e8/0x2950 mm/memory-failure.c:2434, CPU#0: syz.3.7564/25556
> CPU: 0 UID: 0 PID: 25556 Comm: syz.3.7564 Not tainted 6.19.0-rc7 #1 VOLUNTARY
> Hardware name: QEMU Ubuntu 24.10 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:min_order_for_split include/linux/huge_mm.h:635 [inline]
> RIP: 0010:min_order_for_split include/linux/huge_mm.h:633 [inline]
> RIP: 0010:memory_failure+0x22e8/0x2950 mm/memory-failure.c:2434
> Code: ff 84 db 0f 85 f1 f5 ff ff e9 36 fe ff ff e8 3f 55 ce ff 48 c7 c6 e0 f7 ee 85 4c 89 f7 e8 90 b6 ed ff c6 05 13 35 04 06 01 90 <0f> 0b 90 e9 aa ee ff ff e8 eb 15 fe ff e9 65 e1 ff ff e8 a1 15 fe
> RSP: 0018:ffff888000b7fa00 EFLAGS: 00010216
> RAX: 00000000000066f1 RBX: 0000000000000000 RCX: ffffc90004fbb000
> RDX: 0000000000080000 RSI: ffff888029a3c500 RDI: 0000000000000002
> RBP: ffffea00003f8a00 R08: fffffbfff0ddc501 R09: ffffffff819105e0
> R10: 0000000000000001 R11: ffff888000b7f7e7 R12: 000000000000fe28
> R13: ffffea00003f8a00 R14: ffffea00003f8a00 R15: ffffea00003f8a08
> FS:  00007f3d36d7f6c0(0000) GS:0000000000000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3d384a3828 CR3: 00000000589a9000 CR4: 0000000000350ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> Call Trace:
>   <TASK>
>   madvise_inject_error mm/madvise.c:1489 [inline]
>   madvise_do_behavior.part.0+0x137/0x3c0 mm/madvise.c:1927
>   madvise_do_behavior+0x41d/0x5d0 mm/madvise.c:979
>   do_madvise+0x134/0x1b0 mm/madvise.c:2030
>   __do_sys_madvise mm/madvise.c:2039 [inline]
>   __se_sys_madvise mm/madvise.c:2037 [inline]
>   __x64_sys_madvise+0xa8/0x110 mm/madvise.c:2037
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xa9/0x320 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x4b/0x53
> RIP: 0033:0x7f3d3831ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3d36d7f038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f3d38555fa0 RCX: 00007f3d3831ebe9
> RDX: 0000000000000064 RSI: 0000000000600000 RDI: 0000200000000000
> RBP: 00007f3d383a1e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3d38556038 R14: 00007f3d38555fa0 R15: 00007ffe8f52e9d8
>   </TASK>
> ---[ end trace 0000000000000000 ]---


-- 
Cheers,

David

