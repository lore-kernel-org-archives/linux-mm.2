Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD24112584E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2AE6B0005; Wed, 11 Mar 2026 12:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C886B008A; Wed, 11 Mar 2026 12:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4BF26B008C; Wed, 11 Mar 2026 12:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85F1B6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:17:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DA6F1402D3
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:17:33 +0000 (UTC)
X-FDA: 84534287586.08.1305E53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 53E0E4000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:17:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EUHkHmHA;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773245851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kD71w3Tt2gAVVnQx1xZBWCzmCRvDqufDuFeX4uRT9S8=;
	b=N1Mu3wVXmHLZeGocTz0mb7IBSxIPEUOHX0I2TQeRBES6Fyjk5qbZ3fvTOLUXyDFETYiVyU
	X5ocvgJP87xhxFPzOYh0xEaX09/MDV2QNt0wDWlNswNuXxEcY5PY7rYhYj0moe4kk6Xh6V
	KS7CFtO/vRa42To04+1JnOmLzlrZf84=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773245851; a=rsa-sha256;
	cv=none;
	b=H8j7qwIoGFwJqcSmGlBzfj03YuSMiQRbzS6WnlYiqjTSLshPeKi0Yw1FsE22H/qsRFzBO7
	zO3AbJFfLRZRzuYWaINb+UBMWmggjKQulQObP0b07jOG9DaiPnMTjHGYqnGMt7AJKbqKsk
	J3jCWJww1QRK1gsQ1/KqdrMbpVk0lSE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EUHkHmHA;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF19460054;
	Wed, 11 Mar 2026 16:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12584C4CEF7;
	Wed, 11 Mar 2026 16:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773245850;
	bh=SMV6uQqezP3PptD11R5vFFjM355S5GJqJsDLElTabEs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EUHkHmHAlvf9oARFvmypdAOk4mXIA/6eyWzkR5ucFZcpSbq4S6PYyKp2ptx8OgdzQ
	 x7Q0uy0uq0W+yFs4cIvtVjeq3CvRwLkgoitwsbK3Vpr/fGvx2nE6uZ8SJqUGzkpJ/B
	 vgBBGzVIQGKst9fOKwRC05CG75zFzYDOH6JzB4VhB+MWjPMMjF4MjrY4IFmID4nVgm
	 atyo0VpND+VF9wsm4zh5XQpt1VkYY66+M/P+qZJ3+hTJ+YqRU/rlwn/jHXqpNykVbS
	 yeYD8t9sBD6Huby5vNTy6WGkpvNovDYGGqWr++Drmkyti9nqxn7cVUAODs44XLQ3GE
	 Wt5zTxL0KtYdQ==
Message-ID: <9115acdf-edf8-4abf-a59c-8980c1375e67@kernel.org>
Date: Wed, 11 Mar 2026 17:17:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: BUG: Bad page state in process kworker/u32:1
To: Tj <tj.iam.tj@proton.me>
Cc: linux-mm@kvack.org
References: <4df99438-637c-4919-96dd-1fbe6dce70cb@proton.me>
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
In-Reply-To: <4df99438-637c-4919-96dd-1fbe6dce70cb@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53E0E4000D
X-Stat-Signature: fofqdpwx1ufjjyprw3mstpfbeyqj7ib6
X-HE-Tag: 1773245851-389409
X-HE-Meta: U2FsdGVkX1+7aZ7+j5rskEyAHIvGdgQgb5Ib3kpd5wXKTxnS0YijUVOS4V+1Vk65Sn10wYiB3ZuaOzjXCmRfUrKJZGqYvNUFGaiMP/wZicsFbSb+eTJ6PmRB67bOFzMY7/ANi4eqIrcB78onK7FyZofbLir8VqPkL6x0s4l4WBTs5V89QNCo6aq28kMinIcNYoHSNSRFHiDpBl/gSoq3JjzikmVw09sMICrlsDmZg7oHOJRCbffcmCirqlwBCrl1kWHVk8p27+T9CuNHFnBiH+FTNLwNC4c6IrYNoHzQm+tj+yEBkk7RjPHaG1sdfQiQrC0waMHdLt/y92Z0bzz1igfPGhTSQPj6J5tr9eyeuJ7I8By13C3a5xI670e/fqHVtLD07jqn2X4Vfpk2gx3srI3q5q3GoyOBF03HTgAkBXbhLdRyGNW6NHXP95iXFW4X9+k38DMhi36z2iuYt93xfucCaXS7BcI0lv/zKCaKukq1kY2Wn3aIElzZ3I+Wm8SSA+an455QGxAN0+1dtdRT1z7ELXc20sbquJaMYithANS+8ZAxIqkgSCxbuMCMr1geIAscr1/IvEm5DuNzWDFQIfw1A4zHs/absuSfPByC6Cb1nRz7JTZXh9HZRwwq1T/KWNJ7eJB/jVzaK/tnPkZLgvmGgA/VZi1TC3QQkRtvS/hJT05B4MUwuhSz7PYCOWBUI2ueuJ0sv18ki8cR+YRYdbVHZkkYf6AFeUVKIxoL7TcQRER+bCz9tOLDihrstUK3L7G2ccONzCWo3Iu2HwSpOfMIC4gf0dKN236Ffs1tLmhWsj6dnfLieG6FLnnfpe9h69oWTqZSwjJ5zn/ZkjXu/JuJeDXW0RCIh3+Hf/o/IrN9uagNMZFLusNzDKr7zhCIz6kxaq3Ur5jWETTFUYqc+54FDjC1LEXfYeY2xsDj8XoPe2rurThz4N0gnp76jR8HB06P4htBJWlxBiSc8f3
 9ysaA642
 U9qVKuCmP3B269I6erfV6dspSQsKqs+uwmAyIA7PTrw0r4oM/qD+Y9tW6JneHUSTFo3OkbXkc2/UAg0auls6l+0X2cZwhKMi1OZuXQNwXn5cUcUWbHNfHWCQWpmYWfQ+4FJ8bCMw1W0iqEqtKmKA/lkTvfbQkCy/y57PVxoA2mDy6N4xS5BtJNJbO8sA7cbTF8RqaA/9ptBa/iqZTaH5VD6hcMM9p51EJW9cqaD4vP4ly41xbU5tQszUwJISOvfm5qn+B1UrU6MD6xNeAsEmYO+VXOYsKiBaqARE5Etl/h4L4Vxg2fHQy/HsK6lLMyN0h+5XQV5aeU827USE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 17:12, Tj wrote:
> On arm64, Qualcomm sdm845, an attempt to allocate and release a CMA for 
> DMA fails. It seems to be caused by the recent commit 9bda131c6093e9c4 
> "mm: cma: add cma_alloc_frozen{_compound}()" where cma_alloc() now calls 
> set_page_refcounted() but cma_release() or its callees do not undo it, 
> resulting in:
> 
> kernel: BUG: Bad page state in process kworker/u32:1  pfn:f4b00
> kernel: page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 
> pfn:0xf4b00
> kernel: flags: 0x1ffe00000000000(node=0|zone=0|lastcpupid=0xfff) CMA
> kernel: raw: 01ffe00000000000 fffffdffc1d2c048 ffff800080353608 
> 0000000000000000
> kernel: raw: 0000000000000000 0000000000000000 00000001ffffffff 
> 0000000000000000
> kernel: page dumped because: nonzero _refcount
> 
> I've enabled pr_debug plus added in my own pr_info()s to track the 
> callers. The following shows, first, my manual dump_stack() in 
> __cma_alloc_frozen() in order to understand the callers, and immediately 
> after the BUG.

This might be fixed by

commit f4355d6bb39fc8e53d772fa0654c8441b214e349
Author: Zi Yan <ziy@nvidia.com>
Date:   Tue Feb 24 22:12:31 2026 -0500

    mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
    
    When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP.  Putting any
    statement with side effect inside it is incorrect.  Collect all
    !put_page_testzero() results and check the sum using WARN instead after
    the loop.  It restores the same check in free_contig_range() before commit
    e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
    the commit prior to the Fixes one.
    
    Link: https://lkml.kernel.org/r/20260225031231.2352011-1-ziy@nvidia.com

Can you double-check?

-- 
Cheers,

David

