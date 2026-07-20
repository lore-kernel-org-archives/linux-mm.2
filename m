Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A3EC44527
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC256B00C3; Mon, 20 Jul 2026 05:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3B46B00C6; Mon, 20 Jul 2026 05:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3AC6B00CE; Mon, 20 Jul 2026 05:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF5216B00C3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:44:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A8AC14072F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:44:28 +0000 (UTC)
X-FDA: 85008669816.29.7E240E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 863D780008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:44:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uoks8aMO;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJdgOgKGAT1CSJsO4REplq4ch5FATYh7SfBJqMlWH0A=;
	b=GzUCGb3rAb4LF7WmBf3Kb3uFnYUFdlXaMdIq82j9w6qk25Uiiz6R2KO7DC/08yM2Qfq+XR
	vut528DCKpd+c/y2+5BowCoCrLWBtMBcV8PsWX7M7yoTU0MACE1QMgojCKpuPqFnmQcOQO
	Olf8lN5n8hHFEN/kgT3ZXtuP4l00fFo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uoks8aMO;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540666;
	b=3BpFgqTp9L/qJ74PpxjMywtjgmy1daAOp9m/W9EEXpF59Dd9w0pizqvdR0CK+KP36L7c1g
	MNINs31tRqHiAGidfbZTk6/0jgKdUtwIrR5PVK1mdG5yGOpFNqK/Qt5LJj/B90+wf7a4Pc
	MaO7B78H5Bc1IUWTtI/J9sk29dceXQQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0468F60A83;
	Mon, 20 Jul 2026 09:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8F01F00A3A;
	Mon, 20 Jul 2026 09:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540665;
	bh=LJdgOgKGAT1CSJsO4REplq4ch5FATYh7SfBJqMlWH0A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Uoks8aMONAGVPbnyVCd43r//Ov68jjgFFZfnckuXJWQKk+2WEYy+MXXY5LyYPsBJ1
	 b5unPiWEPRZYHOa0u8Y+WMzSiOIK+Vv+KHyk39Z5rUrF0sq4ZIHuA4+pzogLDyx0fC
	 /tkzWLKSa+ZTN5mYXfapsS8x1NxtY6FQmFElOGOApOnTTGpQSF159Pq/jwurPBNN8G
	 1zwVqE4nhoTa5l6qyC/JHowXQmGppLu7ADKFqQlZNASZbHv1KB2cu8dXEiUgXiiNO5
	 j3J/xn5vXlU1vy6OT+cDbi2rZyavnadEjZn0HkiigvZuqs2F6GZ8hW81NfPcGVMWBg
	 Ty03Zwiy7ZnCg==
Message-ID: <59292ba2-e0cc-4e50-bb26-be9c15843a41@kernel.org>
Date: Mon, 20 Jul 2026 10:44:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/3] mm/damon: introduce DAMOS_SPLIT action
To: Lian Wang <lianux.mm@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
Cc: sj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, npache@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 daichaobing@sangfor.com.cn, wangkefeng.wang@huawei.com,
 gutierrez.asier@huawei-partners.com, zengheng4@huawei.com,
 kasong@tencent.com, corbet@lwn.net, skhan@linuxfoundation.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 lianux.wang@processmission.com, kunwu.chan@linux.dev
References: <20260720030327.80153-1-lianux.mm@gmail.com>
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
In-Reply-To: <20260720030327.80153-1-lianux.mm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jwxf136rg1bz91eucb1r5rz55sos35me
X-Rspamd-Queue-Id: 863D780008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784540666-558777
X-HE-Meta: U2FsdGVkX1/Ok96CEmHn/a5CeTbzl59jj7/aB98lepT9yxPuHrhhoFs4nC2pdBK8n/F+7C4UWq+rLpvVoCg3PD/Tw4A+bo7LVzFi1Abl86TM47fkIobOlLmjwtuK6JSRWQjXKPQutFGnvR7kx5IDx9HhKC96VDfRjCuVdyT20Qgdeuxme9lVTicL2FjcKSfUusD93moQqXTn9liZkjSFVnF9wx0581rucNwzWf5G7IGShIjm3BwYx+1znSiNGpyW2pOW1dMlq9igdscSV56eGSuyfu/vPPMQVJs9By1/2/p3CnJjQ/EgB10s3a3wZ8EN9V2h3nZyI+oxA+ue0q2kFwTqp0ekHoOV6MwV8SfzWeZMjd1YH5+nfrMCkkgr6HHIa29EKXMMzSP9EnDC5VAhr1b8LF18I5z/YFxRL19AikzKDMOzCnrHK6VqXHhb/k6yQ6QoEE/apQxB3N0fQWkVoPGFufXNeHKFiE+NPoKboATLnGvkJbL3uQLHzceQUjxJc50wAtFj+/KElFBfbkh7X89ZZtFBllb86PbonNvYoLSPOYNvfyf4sdMHfahKXSdjmQLmcbc6GzWPSksJPZuHja3ydx9QbFt1tw6YVcwz4SUaJkuzWAqyWrDFgQhfy+HUZm0IdFX9CqV/eZn2f3xjj0mynMTrcLHEtusjdlDw2PrcDX+G1m/vkD8UAVZzxUHK/aOooYyFHKLz4GE+MJv54XqKczdKJbfznUsIE1kDBBAwiTbWwHtOZFbY+R4j+UcgkvqFVTyeDH+T418es1p9qqiDsHPcZMkoPwphsgSzLVnQ2r/kae/M2Ei44BtW0uJUiBIGz3M9kkDs/oIpG+jd/lAQlWGlawxFUOPBylGzr9U+uDQFxSatqN7x+gPOthatRtkTEyCJnI/N5KMoRBQT1+ezM3R3ld1N3JOZPP7jxY6o3Gkqwbwz6JDnLJuBs29ZaJlpZQKjmj4pNJHixyi
 8bW7NLKF
 GjhHPAjj7BnyVbM4QWhcTuajWeD/iPTHRc5dX3tY9rQBeldlTG3iO9+HUe+dpXkqay5RX1qh0dWtFYSnn+vioOORrlmokFCo7pAeLb0Ghcjhks34jh0q67huL84UnY8snK/rqHaNZZB7Z4ZhMaQPKJi4ze/biSJqMasVB8il84a8f+n/CzFm37TKwCFgSn/pe8oN5SofM13lCSQOm6EpK2ZrDPg2DxbwEmF5FFEkt69jrebynFoIb9kGDj2tbxG4P1m9l/cCYGFP7Y8X8UoxsRSzmC9j9z9tkcPpNZ6jXbjM4FgPVRzvhBKwoDaVSVm1L121Vn9WPK6RhSyorOKGsOf7GzMt71gLPv8joTyf/6wjT6/Rk/E2Ozm5DOvjmGfIXxtfwJQgmRbckMWa4XVSypUMux3a088t1HCWxWfhmJbm8Dus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 04:03, Lian Wang wrote:
> DAMOS_SPLIT splits large folios in a target region down to a
> configured target order, using the existing split_folio_to_order().
> No new core-mm code or exported symbols are introduced.
> 
> Based on mm-unstable at 61cccb8363fc ("mm/swap, PM: hibernate:
> atomically replace hibernation pin").
> 
> Different addresses within a PMD-mapped folio resolve to the same
> PMD Accessed bit.  Accesses to a small part of the folio can
> therefore coarsen DAMON's observed hot set relative to the actual
> working set.
> 
> DAMOS already provides promotion actions (HUGEPAGE, COLLAPSE) but
> has no corresponding demotion action.  DAMOS_SPLIT fills this gap.
> It is a mechanism, not a policy -- it does not decide which folios
> to split.  Selection is left to DAMON's existing access patterns,
> filters, and future probe/PMU signals.
> 
> target_order selects the split target: 0 for order-0 base pages,
> or a supported smaller mTHP order.  Both anonymous and file-backed
> folios are supported.  The locking follows split_huge_pages_in_pid()
> in mm/huge_memory.c.
> 
> Tests
> =====
> 
> damos_split.py (VM + Kunpeng 920):
>   anon THP -> order-0 split: PASS
> 
> sangfor_exp.py (Kunpeng 920, tmpfs, 4096 MiB):
> 
>   - Created a 4 GiB PMD-mapped tmpfs workload.
>   - Applied DAMOS_SPLIT with target_order=0.
>   - ShmemPmdMapped dropped from 4194304 KiB to 0 in every round.
>   - Repeated for five rounds without functional failures.
> 
> The functional selftest (damos_split.py) is included in this series.
> Additional experiment scripts and raw results are available on
> request.  Performance characterization using masim [1] and KMB [2]
> is in progress.
> 
> [1] https://github.com/sjp38/masim
> [2] https://gitee.com/OpenCloudOS/kernel-multi-bench

Hi,

you give no real motivation and evaluation why this is required or why this
gives the user any benefit.

HUGEPAGE + COLLAPSE is clear: give me THPs in a size not controlled by user
space, because the expectation is that this memory will be performance sensitive.

A SPLIT with an explicit order is not really want we want and it does not fit
the existing primitives.

-- 
Cheers,

David

