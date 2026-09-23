Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69ED4C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5692A6B0093; Wed, 23 Sep 2026 06:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541416B0096; Wed, 23 Sep 2026 06:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4561C6B0098; Wed, 23 Sep 2026 06:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFFE6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:24:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A37CC14053D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:24:50 +0000 (UTC)
X-FDA: 85244643540.02.BBE2B13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F28A51A0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:24:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpOMLrJt;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790159089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytkhLFeElfVPBsukpabe8slF4KeBj+GfJ/6CohjWEXY=;
	b=tttYjZCjMUuky1qx/AFj6pzS2jcVFzXp717FCz5AWFdWntwUT7QvMBd/torg2zuTIblVCk
	SUvlmAgT0hgBwmQ5ZC/JdOi6MIBb/OugRskOnLlUNlG+gwAUjT1AxcaqEi9RivVWwoESKR
	UXi+bbmnEuNngeCrTZvjry9jIArISu8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790159089;
	b=3ClPQOPD8G2Quwj4uZUdI1qFmi3k7TD+bfjwe7OCb1W6jrI1F77uhZcwBTsfff+WHYoY2v
	1tzqxa1YTuR96p8Z1Tm3H0eLRQyb+zfU6BYiRY8b24mWsud07uk/8yTg8YrsSQ4I+GPJWN
	7wNJnIO1pQb+0Y8llVusBIvJuLiZ8Sk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpOMLrJt;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71ECB601FB;
	Wed, 23 Sep 2026 10:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AA61F000FF;
	Wed, 23 Sep 2026 10:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790159088;
	bh=ytkhLFeElfVPBsukpabe8slF4KeBj+GfJ/6CohjWEXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SpOMLrJtP9axVwXjkGFayVrvhJ/jv+v91G4KvRUZKKFlfySjUkjy2Jv37KwcVWE9h
	 OdmJpsUg33iQSuIb1PkURFL4saPNW7Xt5d2SMBGSnJRGgk2MuLBlw2Ym/MJ+K89Zhj
	 tqDRW/I2HXZSw2rCzoOpRt/844ycGW1CSLe+TZID9bBoS5d6U2cFpE8pegkltHclEF
	 IndMs5vjVDySCqv6jqakzGVsfdYZxPR2K/amWRvoVUWSXswACj/vfvHS2YAw1GWEVI
	 B4ebwdAA8g1MPUhlUeGdIifSethVOPlQ7LNgW1Vc0nbq/YayH8Hp4OXsn4rh2VFm9j
	 bGUyJhlNgHYOg==
Message-ID: <5f950806-3e76-4a16-9511-a23719125f4b@kernel.org>
Date: Wed, 23 Sep 2026 12:24:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] hibernation: make hibernation unavailable when
 debug_pagealloc is on
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
 Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-5-7f7dfae3dbe0@kernel.org>
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
In-Reply-To: <20260917-hibernation-v1-5-7f7dfae3dbe0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F28A51A0002
X-Stat-Signature: 3wrghpyjeu7czdxs889rkrs3o5j5xwg3
X-HE-Tag: 1790159088-936591
X-HE-Meta: U2FsdGVkX1/j0sQWTBhaw/HE5eQ6iZ5852/xsjegJru6t1RB4F5lqPIPN3D7UaLnso4h7+3dAcOidsw0TtOgTa1Oa9w3gj7LKAxE24vWTyL+GCG857sRaD3bIq/KSqnuTSeoIdFrLUSctQHhrxS/vLPosnsW1WiU5asNKERmLZ7dWOiWUVKr4IipuWOg3d7ZqJk4eaG2QvJ1kgMPBRmx2XEAfoWHbbTOWOuyeQzJKqvPXEIc7G/IXyu0iJ464JMBTzK9+ZKyKX+LwuyAnfbLq6I+V8/n7R0XJ334QxiELDlhGYojO+2xNgL9ijgTRft0ROchk10gS0eUA3wtC6cPMGv6u7XQJ0KUdNwrZcRVDxNWURl8MV+pVyZXo3hY86KkjkztcU3zST1rAOSUI4306gcx3gndBaaIUt/V2owEPrGibpNsYZzFlJofI/8A/+yYiXEFe0Dl3C/nCbKIDi52zg7+XglsZP4gjDP3vdFyig8XlZ22cc9z9U0Ih4bdW+FIwFVx+aZXYR53ZejzIy3Nh+TuXjh23AcZXBDNEEMnmlMXzbbiKzHxbOM3hG8Xsi27gvNgubQs+aqozG8NrxEYMmTVBNK9mXotI4L5fsj9Mm3IMPvelHGUj+AmJ6kzjkWNrXaShi+BVlCEW+IusO0nT4TyDt2NaJlxFbQfSmvtgHqSrCgTGBdSunmHOU0nU0F4Aa54zfsIraw1rRfl3XvgWxgLVCXTYYI1S+ytZxs3j9yrF7YK9GT+Mtcy2KhCI7WVF42u+z4PoSdWTQ8Eil8O/IqM2B/oDV1Gzql/kBRENbhwvp8ZuuTZ6Pnvt6T/T3vnYFVknV5vfWZpL9ZgZcCejuITafKm5nneLI1nMCf/0NB//aNmFJpf45QIV6vLHs+7taFFqdQLl/p6xxG7PVRsfI5RAKOniR4xlxLbMxkpz5ugs5EeegfWflpjsB62orNvu/jPB7vMqpj4izutyTT
 k4Wka7ZH
 i1QaMuXHRoRwbmsEYxkz09qo5UXO3eS2+pMj1doh6QM/3W/XkZ/H3kP1dBWtUUoRrsPdl8N8NGl4MD+4XEaDsxxl+BwXQYv1b6eQtFFZMASdzgH1dM4LtidfJZybOclKR2G+2JYRv6i/XVc2/tdgI53hlaMrff047+9ih8fBKvOTcwP+CVe5PJ1Eije3fchKi7pycSLYHKjFy3UT94Exg4ybzA53VDMLs7lZL4GiJfNATX6WA1MWMB6rjcrhoe8zs+8GrpqGiI79+9HFCOWQY8we7tfvmo6dYfoHXT1zo11bjCrH1T1Dezj2VdwTAmCEyJd2N6Ub8ZTGhuFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
> Back in 2008 when commit 8a235efad548a ("Hibernation: Handle
> DEBUG_PAGEALLOC on x86") enabled coexistence of hibernation and
> DEBUG_PAGEALLOC, the world was simpler, the combination was only supported
> on x86 and a non-present page in the direct map meant that the page was
> free and debug_pagealloc removed its mapping.
> 
> Nowadays there are more architectures with inconsistent views of how the
> direct map should be managed, there are more debug mechanisms in MM that
> can either drop a page from the direct map (e.g. KFENCE) or require that a
> page must be mapped immediately after resume (e.g. init_on_free).
> 
> The latter constraint is particularly nasty, because enabling
> debug_pagealloc and PAGE_POISON at the same time simply breaks resume:
> 
>   BUG: unable to handle page fault for address: ffff888000100000
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0002) - not-present page
>   PGD 4f0c067 P4D 4f0c067 PUD 4f0d067 PMD 4f0e067 PTE 800fffffffeff020
>   Oops: Oops: 0002 [#1] SMP DEBUG_PAGEALLOC NOPTI
>   CPU: 0 UID: 0 PID: 477 Comm: bash Not tainted 7.3.0-rc3-00090-g4a613f1d9124 #1 PREEMPT(full)
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
>   RIP: 0010:__kernel_poison_pages+0x45/0x70
>   Code: 89 fa 48 c1 e6 06 48 01 fe 48 89 d1 48 2b 0d 9a ed 87 01 48 83 c2 40 48 c1 f9 06 48 c1 e1 0c 48 03 0d 97 ed 87 01 48 8d 79 08 <48> 89 01 48 83 e7 f8 48 89 81 f8 0f 00 00 48 29 f9 81 c1 00 10 00
>   RSP: 0018:ffffc900017dfd78 EFLAGS: 00010086
>   RAX: aaaaaaaaaaaaaaaa RBX: 0000000000000000 RCX: ffff888000100000
>   RDX: ffffea0000004040 RSI: ffffea0000004040 RDI: ffff888000100008
>   RBP: 0000000000000000 R08: ffff888130fcada0 R09: 00000000723e0de4
>   R10: 0000000096ad9215 R11: 00000000db907bcf R12: 0000000000000005
>   R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
>   FS:  00007f8f2243e780(0000) GS:ffff8882e8e13000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: ffff888000100000 CR3: 0000000140679000 CR4: 0000000000750ef0
>   PKRU: 55555554
>   Call Trace:
>    <TASK>
>    clear_or_poison_free_pages+0xd1/0xe0
>    hibernation_snapshot+0x548/0x5a0
>    hibernate.cold+0xcb/0x321
>    state_store+0xc3/0xd0
>    kernfs_fop_write_iter+0x163/0x240
>    vfs_write+0x21f/0x550
>    ksys_write+0x70/0xf0
>    do_syscall_64+0xb1/0x590
>    ? __irq_exit_rcu+0x40/0x110
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   RIP: 0033:0x7f8f224d0687
>   Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
>   RSP: 002b:00007ffe7bbe0910 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
>   RAX: ffffffffffffffda RBX: 00007f8f2243e780 RCX: 00007f8f224d0687
>   RDX: 0000000000000005 RSI: 000055e3e53135d0 RDI: 0000000000000001
>   RBP: 000055e3e53135d0 R08: 0000000000000000 R09: 0000000000000000
>   R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000005
>   R13: 00007f8f226295c0 R14: 00007f8f22626e80 R15: 0000000000000000
>    </TASK>
>   Modules linked in:
>   CR2: ffff888000100000
> 
> It's possible to build a complex infrastructure involving a new page flag
> and/or page_type to allow robust hibernation and restore with
> debug_pagealloc enabled.
> 
> This infrastructure requires a proper detection whether it is safe to
> temporarily remap a page to include it in the hibernation snapshot because
> relying on kernel_page_present() is too permissive and may include pages
> that were deliberately removed from the direct map for security reasons.
> 
> This complexity does not seem justified to deal with an esoteric use case
> of hibernating a system that runs with debug_pagealloc enabled.
> 
> Make hibernation unavailable when debug_pagealloc is enabled and simplify
> hibernate_{map,unmap}_page() that don't need to deal with debug_pagealloc
> anymore.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

