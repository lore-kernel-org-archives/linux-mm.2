Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A68D35175
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB5C6B0005; Wed,  1 Apr 2026 06:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C0C6B0088; Wed,  1 Apr 2026 06:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B736B0089; Wed,  1 Apr 2026 06:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24E196B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:52:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6671160808
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:52:26 +0000 (UTC)
X-FDA: 84609673092.30.4A635FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C8DA84000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:52:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dru08UI0;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775040744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uHNK8men8KTEINJKE6QlNq7BhDezKdwsa8MqGQv070=;
	b=RYIKLzNj0bAHlqzkcVgsIA8DWjuwsNYKqAXIgcJEM8uyy+RE8wvZDdY1f9klG7/A02p2Wc
	qswLDb4S9ScegIXOEsMDSn4AuPinkXZjyIXEebmAzNlfqjfwY5Yx1bhkjYj+y8gSgd2RJ3
	YTkgbtAU+K2vURAUUvGNEbt5y5GSQyo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dru08UI0;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775040745; a=rsa-sha256;
	cv=none;
	b=z/VoRZWdVvKOCJiFlAQVL2aWA8hUhspMI+iVW3dMv5SUAT0+adAQPjEJ0Zt+A/I6dLmT0B
	4rc6v5PVGcCvPZ3vvLv6k55MjX0+yIuLYjMXASwa4uCZKv3r6fuFo1vSasEq7tlt/87723
	k0piP3giiAuNf9WpGaAPEH5D6F2EB6Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 95D3B4082E;
	Wed,  1 Apr 2026 10:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2699BC4CEF7;
	Wed,  1 Apr 2026 10:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775040743;
	bh=7eNw3TxRt2f7CALy41ojguRmYDMXKZ+2KH/2ZcV1NOs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Dru08UI0SlP+Zwr0Te9QbJF+/b46qG2ViXXUiJYjswDkYhjhSWdbmpJXK7G1WHlkD
	 6di7HCe5TFwgqXb+Ge0z4hdZnhdpK68ez7YcCpurn5ZWoryFnp4cKUX6jZqlmR4pmA
	 0TtgvpeaYYCg9D81Yo5gopS05svvPQGIv1YSyrFeLlSajQ3GFxf0ITZPT+KcVXniS3
	 pDXGxjWW4kHhTkBJb33IddJvGYDMrQQ8l11VHigcsqW8SCPjDi7NsU+7dOmfR6mvah
	 4ZG19BEuNK+xRB/jZQWYBIZ6bzuvJN33/FKM382xZ+ynvXr8YRAgTVt/fDrTsGXtXJ
	 33ow31PSjJAew==
Message-ID: <db246b9b-2cc4-4aff-b92b-537ca27c47c0@kernel.org>
Date: Wed, 1 Apr 2026 12:52:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: update stale locking comment in do_anonymous_page()
To: Aditya Sharma <adi.sharma@zohomail.in>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org
References: <20260331142936.229667-1-adi.sharma@zohomail.in>
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
In-Reply-To: <20260331142936.229667-1-adi.sharma@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C8DA84000E
X-Stat-Signature: efkc19hsfcjdzmwkmzesmk1iokdyw43c
X-Rspamd-Server: rspam06
X-HE-Tag: 1775040744-692685
X-HE-Meta: U2FsdGVkX195yLqpAKiHY4sWlEVMa7VW76biu4bfRsnmXpo3E7a+Oq6fcUB08SeSaI55DFZFME+GcFOFZpcbSV5vamp4dST3aZBmipyodEkOy3ZvpG+tuochuR3ir14W6kgYSelHPBubI7ox9yGQv9T69n52npsdmdXcQ0CMSDLj5pI90Y+A5+nPbLasA8+Qdoic23/FItBdKOQTvBQFRIBRzzzY2Ba/I0AMKdORgOFYIJhKktatFTZSFkHHgTK4s7DxpZy7kwdw+2x9s3YBFxmDnqzyBseyPJuDpcLbzOfpL2G++DfxcKrOKvJhW+rLRY0mqARdV+bn/kMuuEG5CMZTxXuN39UXwzuiLg192kJZtRMVVlKHnf6gCbqU3HdONRDlbNMyYh6euFlhF1ZKXS9Tkcr0m4bql77pKjU1YFLns9eV25t0WhXTvbwlzrbmuKx3MYO5DrQ7MuYqAZ5o6dUaNZkPOinCfX3eiNzLZ/8Tjt/E2yAK4xjOC0GUvz1D8+h3XLcURByPtvfU1Jmf8bkX6hJ+M+xPhz1H/+lH6gQQUeDXYkREhtU4N0+ELIXdkuAXjTszWOVyKvo6HPXLZNWBcjm9AHcE25xxbxWD6ss9qEIkRP7VqhAa4YsaN8JkWcqWL31oyLbq+19H3p5E+WMpGtN+2hXbH7ceEqPvmjtFQHy5icb+frBp25Lb4AT4UOPWzlYzZBKbgCMLv/wCz0wN3amjCsLTyXmAak7AWOF/FmmZyLj8pbmkLpWGbPOgFAYBGSxb9qHN4VJZ5jbEWZQadUOvuvWM2vrpXOxgJIRmVNaM8W+RO2vq3NuroqW/DVOJwz69w3zetAYgMVP8tPpwXz0sI/IqzEJgm2G0jJxVnBXKkS1XCArEQn6zdFjQYHjGkmklrCgUwTX5QmpMDvVf0EwfoVyZ6tQCVJJ22S6A8sG6GpmXpAq6LdkRjR8dEZYsgIz+BPDKPX+IjmQ
 yy0dVUiF
 Rpi5FjSwxIzd1CV71o9l2Pc5NIpQ1ukk+y3QeBsxC5eisE6ABtxiwcUSpznalN/ZJ6zJcEprbq0yDOirlQ6/QyLpBH2SkCS4jUzxry1Tg8Mbod0jgcg1Mj9wWye4saynfelQ+6sq4n7Od1bs8hpJTwz8lt+KCsVn/S3DgKdXZko7hpnuJyTUiTqvvvHpFN1SBC3oG4sa/4p4iYzUfdk9GOopHfdWfobYzXbfKy66ul+94euegcm04Ut9D0vru2Bw/QYKVFcnf2EsNNNbdxhoasbsn2jwuho8MzXqWzGCHaT+MeMq5jNf7LEccxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 16:29, Aditya Sharma wrote:
> The comment above do_anonymous_page() dates back to 2005 and describes
> the pre-per-VMA-lock world where mmap_lock was always held on entry.
> Since CONFIG_PER_VMA_LOCK was introduced (6.4), the fault handler now
> has a fast path that enters holding only a per-VMA read lock, with
> mmap_lock not held at all.
> 
> Update the comment to describe both entry contexts accurately.
> 
> Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
> ---
>  mm/memory.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index c65e82c86..cc8dbbaea 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5210,9 +5210,25 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  }
>  
>  /*
> - * We enter with non-exclusive mmap_lock (to exclude vma changes,
> - * but allow concurrent faults), and pte mapped but not yet locked.
> - * We return with mmap_lock still held, but pte unmapped and unlocked.
> + * We enter in one of two locking contexts:
> + *
> + * 1) VMA lock path (FAULT_FLAG_VMA_LOCK set):
> + *    Entered holding a read lock on the faulting VMA (vma_start_read),
> + *    but NOT holding mmap_lock. This is the fast path introduced with
> + *    per-VMA locking (CONFIG_PER_VMA_LOCK). If this function cannot
> + *    complete the fault (e.g. needs to wait on I/O or encounters a
> + *    condition requiring the mm lock), it must return VM_FAULT_RETRY
> + *    and the caller will fall back to the mmap_lock path below.
> + *
> + * 2) mmap_lock path (FAULT_FLAG_VMA_LOCK not set):
> + *    Entered holding a non-exclusive (read) lock on mmap_lock, which
> + *    excludes VMA tree modifications but allows concurrent faults on
> + *    other VMAs. No per-VMA lock is held.
> + *
> + * In both cases, on entry the pte is mapped but not yet locked.
> + * On return, the pte is unmapped and unlocked, and whichever of
> + * the above locks was held on entry is still held (mmap_lock is
> + * not dropped, VMA read lock is not dropped, rather, the caller releases it).
>   */
>  static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  {

Was this AI generated?

I don't think we want to have such a wall of text for each and every
function that can be called with VMA lock or mmap lock in read mode.

-- 
Cheers,

David

