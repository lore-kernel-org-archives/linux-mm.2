Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54139F417E3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EDC96B0005; Mon,  9 Mar 2026 10:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4706B0088; Mon,  9 Mar 2026 10:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6DF6B0089; Mon,  9 Mar 2026 10:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6EB6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:39:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1041A1C091
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:39:35 +0000 (UTC)
X-FDA: 84526783110.22.D94BF95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 28B6410000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:39:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1RRaJsj;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773067173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ax2e3nDwsvw9ILVHvWERWqTLhgIowHpeGr3SQn+CkPI=;
	b=6II4ecECWR+5A25k6BaRIZ4J3XmSJ2dQCarfFhrLPV86c+3JSko9z74vT7YqULU80BYcfT
	ZQqJczXu2OwxsPbN34TwfJUa0p4KD7DQsFN1yfGAS8L3Gp9ZEH5rSZkUDxSCjizOLbwLMK
	FAIusUX9Q9xmhgGAzSniKhE5rOZU+8Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1RRaJsj;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773067173; a=rsa-sha256;
	cv=none;
	b=A98DvhYh93/UAFolbJXZ+vjdzN5Jes7EnTdRHWkf9Xfe55iEL9RaUb6T52IpsEAWmaxgxW
	OKGyxmgNLKBSWuMFsHpj6rNE4Ow03GYYzO1XKKhNqguzhiaR6yvGdbTwixwWFDcQzHsS2b
	nVPU021T52y9Sc9+QD+W2N4nScs77IY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EEF0D443B2;
	Mon,  9 Mar 2026 14:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54697C2BCB4;
	Mon,  9 Mar 2026 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773067171;
	bh=9PukcKOFazN0dG+ZH11NZrXPlcPN2/bdDpO63eNNTeM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J1RRaJsjFoPPzLLr+uhbPsnz4s6HEiGtDUliOig0I6SGfRKOs6wSvlzLJb4/GiJhD
	 O87gKny2z+59fQSrPq0OpUbuXNOz2YjE+3mJ8tXxiuvSKRaG9x4hYFcAjcX8aKOq8W
	 +KOuL/Lnlo6fJKFqOw5ouWYPRW1vccwAW9VyGXFoFV+PF98W9TEHARAXUiTcqhiaJp
	 2eynJFn5+FPYRGCrD3lTK2oWYT1Lb6D2CjwpquUhL7AYCnK52bv49oSzW/pzMXI0j8
	 t2k414mb6oDPC8cJb/Ivs5I8kOhx+bHIC8miqqFrQJUOTr8l9DuiaI/FzvE+dgtkH+
	 kXI+vX0aZe5Tg==
Message-ID: <92376758-5bb5-4391-8904-cd0e2f72acf8@kernel.org>
Date: Mon, 9 Mar 2026 15:39:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] arm64: mm: implement the architecture-specific
 test_and_clear_young_ptes()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
 <7f891d42a720cc2e57862f3b79e4f774404f313c.1772778858.git.baolin.wang@linux.alibaba.com>
 <6305e05e-2911-42b0-b6f5-7fdde787b778@kernel.org>
 <c607b6fd-a682-4400-a7fd-abe83152db10@linux.alibaba.com>
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
In-Reply-To: <c607b6fd-a682-4400-a7fd-abe83152db10@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 28B6410000B
X-Stat-Signature: sg3qgzxgns6wmu6k474mykjy8nk4e9ta
X-Rspam-User: 
X-HE-Tag: 1773067172-895362
X-HE-Meta: U2FsdGVkX1+jskurnE9ZIgD8GaB9R/L8tA4zzIbm5Rx9c6hPMzXdeVaEPL7zi81tKGcHqLp/UFtlkTeiz76js+1xJTgE2DQZBhBGrmBxqMDRiOMVX3Dg17VMWzciCAC1dvn7+LJtcSrvwD32F1nQVW/jESgRqeY/lvvbZ0izz/pBhKpIzajSPCE5WWp+hKGaV6IOproyA8132IRL3/xejqEVsSsLovdBDQzlNcNfcyVkpUuoB330H2D27tgtHo2oW3rQfOp1bUYQvdy43aKMCq8FzRX8dkNuy9aKUwYInhGjXKBlGMa/8vSFI0q/07G1lOGEll3IrKr927Gz6XZSwrTo7IMcUujlJxA+c8PB3YkH5whNDVSz/CYtze5NZDax9kMIDiel+tz8VTmQG3/IX3QLjtLqj97TNWTdzsY8VMOmF9utsU9bNr0mjBW8URZZcB7iGTETCnn40+BR9dGC3tbqDUiESSN7VZcozl2pHOf2MEbFYwqOnJZ2hqda3QsxYqBbGG+1Z4vjbrUM3NrrJtCKjTgvOKFOv7ldmTAshB8+yyRR+NTmDxP3zB+ILEmp6+RcaHS7Zh/vUX67uUIxoOrkZkcMsR9F3qCLZNu6L4hn8Z44LP4WOIvLic9UDDYZXI+MbYW1wSkuKmWb/9GKqv/CFgOo+pxUpLqQpNXuLCXYQ/wUgl6PVEN/cVTcYFuWp7J1bUx3tuw+MKSaPHuoqIPjZ1hZQYa7Tm6Isg9ZojTEctAIQybKS0K8Bci4JMql/bFwRU975d0WIsK2NYFIRIb/PuNAtgLHkfKvXeJlfdIUzqxac0yJOgbSyBNsezEcb1JRroyvhugVaMJG7hImUgWS5K1Jd+IdJJu60GvGFianhbEqYch4UAKY5QhPkAdkMRF8GuDFi/XcdpGMt+bJdOkQ6xU29DWzhhQAqgdUBAl8c5gKO5d2QgSXL1ETJVxhbZd4zP8YpDq/1xOxaY/
 6QxCnmmC
 A6+tlQQ/xulhiwwo/EfYjWWBbNzy1kgnSmBoMEj0kTFaGMCCBYzFXzlA5dEUBSYG+KHZztGS85hdFnRCSBRuFKWAU9PRSeMEU4NraqmxIK60b4hswsc0HzsihZnmq8T6anDtXdWLD+U6Zvt0HWdI+nmxuCRs9s28CIvFuGEn6zIXeTS24+RVD6gaAC6+Khp9VZIQIwn5O5F4SNi5wO7WeBB0/pxZoetLp2Nz/n42U+uyjCNQyRxZYfG7pCsjPEwTAqmr7Z7cWna4pHtO5w+Pe5Fw6LGefH3TNG7eW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> (b) The first pte is !pte_cont(), but some others in there are?
> 
> IMO they can’t be handled in a single batch. Since the folio_pte_batch()
> will group consecutive !cont PTEs into one batch and consecutive cont
> PTEs into another (assume all PTEs belong to a single large folio),
> because their PTE entries have different CONT bits.
Interesting, thanks. I thought that folio_pte_batch() would be able to
batch that.

But yes, pte_batch_hint() relies on the CONT bit still being set after a
ptep_get(). I wonder whether we should document somewhere that the arm
implementation depends on that.

This might be something to look into in the future. (make
folio_pte_batch() ignore cont information when comparing and make the
arm implementation be able to deal with that).

Assume we unmapped the last page of a large folio. Ideally, we'd be able
to process the remaining THP pieces (all ptes) in a single operation. I
guess right now it would be two.

-- 
Cheers,

David

