Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E562606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KyGYc/76
Received: by kanga.kvack.org (Postfix)
	id 3E7AD6B05C1; Mon,  9 Nov 2026 07:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BEA66B05C2; Mon,  9 Nov 2026 07:19:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5536B05C3; Mon,  9 Nov 2026 07:19:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C00D6B05C1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:19:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B2AA1A068C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:19:55 +0000 (UTC)
X-FDA: 85415487150.20.F776294
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB8754000D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:19:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KyGYc/76";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794226793;
	b=LVITLw0NnHJ3dr0b2i9toAuPOZevRx1xbnqmUJ4CgNL5y5GjLiUhSIreRxKSUX3Ja03Kdi
	Db5xhdH0/wJYCr7bvqtJUHwvBos7ligtcuk8vvX/EJqZ3QCotis+sWfYElGYDBHE9HmsTd
	KePX4tpQ5jtZXE+uFgvyxFvcXR84H+E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KyGYc/76";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794226793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLrnHUnuKxQDgIYEl6JMV7NCbKmlJCyRBq3Hpd3l8qU=;
	b=6HsJhftpA3edBM9AXDHCyVSImXj1YLDvbiSGR/uQUybOv75Nn9+oh4ng5iQASBzkjf9S1w
	AktDYlZo2K+b5t9Uvciq4RREZpgolhe+N1mwhL1t3RTf+vKF9EZ+NUSVtec4ENQo0sqWqG
	AfWO2gQhvThxddJmi0NjIJ6S994uwao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18BE063186;
	Mon,  9 Nov 2026 12:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DD81F0089F;
	Mon,  9 Nov 2026 12:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794226792;
	bh=TLrnHUnuKxQDgIYEl6JMV7NCbKmlJCyRBq3Hpd3l8qU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KyGYc/76GpP5BOnBgF73ZQIJKAkOkBJyhzHx4Ac3QfYr6X0EIaFq/auDlW7eisMMv
	 CybW5T1K81veFCKgaLPoy6WKdB++hUXsaNGE5kWnUJNyTh2QL3ev2lQLGNKZVJEvIn
	 wETeFrjSf1Ydu2J2NAK1Aou7oVmi2yQ8KBwOY33ZzcZxy+3+Ba9aBCFvBVikwfHPZv
	 dT3Vn/aJa92pRJLx0VQvuoTBNNKGIankU5/+ElKinJYWWr0s7/HNpMR7uvxMU56sFr
	 C0nmuzTLIore/qamzALbP8qReUp8QmrjqC5/c2IoWUfAxzG2TOWvfgqr96376iNFs/
	 9amIjWQgqfyBQ==
Message-ID: <3b00799f-2fef-44bc-b798-79273c5c0ca7@kernel.org>
Date: Mon, 9 Nov 2026 13:19:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: fix softlockup in do_pages_move() with
 huge page arrays
To: shao.mingyin@zte.com.cn, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261108142831046W_fbNCAFfuY0BjHPCCHgi@zte.com.cn>
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
In-Reply-To: <20261108142831046W_fbNCAFfuY0BjHPCCHgi@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CB8754000D
X-Stat-Signature: jpb5iwfwjt4oyiknzk1rnz6hbpuz4zeb
X-Rspam-User: 
X-HE-Tag: 1794226793-850885
X-HE-Meta: U2FsdGVkX19oi6R35/QE6qd/z0ZvldxIdFxOZdqMo7ASP44msZEKpweCiJPyEnSnGNb0usEYuTjE2s5JbR+3k66D+ACM5bTt1dcfxKA5XKq6Y9pr5pI2vI0OecEHZFtbspdKNt+IDDtwcwVFttzhv8DFiGKYuoe7dvHvBu1yO2B0SnCgWO8+UlOXht0SzWGJCORB7rDI6TXXLTzUw7vPOhfHpWxt32BAyzLnVkJeHuvd7yQZmAnO+LYFziv15ujpk4LUjQwiKXltjg77MRuziYTLdP8pZronWk8hGwZybqnLYYOt2HYUMpYKr3jRgjxyJL2GlWR0LvcEakdYWTpfkvwCfAeobf4830CRVnmQ94uq0+wiVoHbFwGDay54FwmODCPgBd8QVLQZFU/X/R+xyaKWCD6Nv6njcoDf6r/YU/Ym+cQD4WMoycNq+NSBA+TaaSc3scKwc+2EuiIstNAayBKR6C+Qo4tqQbP3mYnUvntzO9BcRrz6acKU+OX3Tez9nudi9B2Wz3WNITHpid3vXh6WXmjQZmxFgyLpEr2LYPWrTmGHcR38sb/pxI6olUQ02m5S6w12IbRrF0CR+J5u98Xn+bwaIfLQCCqvfTrJ+Ww2/J5UPwN7kDdaXUoOgytzFF4PywL0EMPbev+bK2ows+W0fKqbW77vGTxXAo+Snbo6wTzbPYy3uAKdjUWS2yPtXQfvXSLXc9oMJw5/arkRzR4pafUAls6TExKZHCpmYypGtpqd+ParZGtzCWQ0znYNTTsm+n9/J+doSAM0xprGcZo+Gbu27SlIH1XnceV+mAqahDVy3UljxedLZLUGBtT42CmOKNupgXTAJaGICKtwyRicVhyMLjcqBKKetZjimoI77w4+ZRGrkQ9FVCsgqj6NJhQqBO1M56ALM28+kfZx5jytRpi7WpRWvbSgEUd70i6fcFV1xcSp8aoNmoG6m6014pTw1PpDNTTqseYUHzR
 QMs96k+F
 qmXJDC4nedWZKwtdDGzNfMAsLPZT5NU3o1cWR3PuxsBkdTbE//Uym6QA8dC8PsyjcunFUNHFM/qnSVFaEqKwYgs0jSl4/OPb3tl3cdYxuiPbAuwItDbZhepm2zLtH3gQVqnx+M/JhkoZyMaMbDQP6745BBGSaleBPODwV5tJto7VXk6YV/aKiUERmmpA+V8mCYIUQa+sdx3tcv3+sT42AkXCh6j2+ngPU8aUzDeshV4N1kSHsenw2DusciSfTw4ydKAvB4CB3SRKDuOA6xYK2ZUu1yhoPxClPnPRpeBgA6NWADUTxVL73EASRSgtFxu7lRhcMQSnLw71xdBjr0WAcnzGkPJ6xNk0vjXF2wOQ4Mkv3RLGmCvwpiUYoJipv1LyQDriLpsfb1F4bJoR7qQxq9DaXrJigy7kTv5HPXWaOE64H7nUAFlnLcQ8YxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/8/26 07:28, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
> 
> mm/migrate: fix softlockup in do_pages_move() with huge page arrays
> 
> do_pages_move() walks the array one page at a time.  An entry naming the
> node its page is already on is never queued, so the loop runs without a
> voluntary preemption point on a non-preemptible kernel; the existing
> cond_resched() calls in the migration code are only reached after a
> folio has been queued.  nr_pages comes straight from the syscall.
> 
> A 6.6.60 x86_64 kernel with CONFIG_PREEMPT_NONE=y and CONFIG_NUMA=y
> reproduces this under QEMU TCG: 50 million entries pointing at a page
> already on the target node keep the CPU in do_pages_move() for 42.9 s and
> trip the softlockup watchdog; with this patch the same call completes in
> 44.3 s without a softlockup.
> 
> Add cond_resched() so that long calls yield periodically.
> do_pages_stat() had the same problem; it was fixed by 8e934ab44389.  In
> current mainline only alpha, hexagon and classic m68k can select
> PREEMPT_NONE and they cannot enable CONFIG_NUMA, so this mainly targets
> pre-v7.0 stable kernels.

I hat that we have to care about this, and I'll probably increasingly hard push
back against such effective stable-only fixes in the future.

In particular if it wasn't even encountered in practice but required a QEMU TCG
instance to even trigger it ...

-- 
Cheers,

David

