Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7C0606A6B9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LsR2Wh+5
Received: by kanga.kvack.org (Postfix)
	id 6AC3E6B05B2; Mon, 23 Nov 2026 14:38:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D776B05B3; Mon, 23 Nov 2026 14:38:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D356B05B4; Mon, 23 Nov 2026 14:38:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3074F6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:38:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3FA7A7ECF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:38:43 +0000 (UTC)
X-FDA: 85467396126.28.9A78676
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04A72C0007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:38:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LsR2Wh+5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795462722;
	b=kK9BXUAwVpoA5C1E9raSeiX/KzmF1sPbEx2lvwrQDcLBMaSQFJQkoGLG+KslCjKAoXRNuQ
	hRg9xN82YpdDaRT6/Vuh+cT8z4hOjX0u1fgBpEqRqV2bVjJuyuy3nMe0Wp3Gl66w+PMmrC
	oJP2Ti/JMtCsnam/UCZxMmJ+Yj1WcoY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795462722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DaLrAjJERB9nEFU7eyItkBxKjBtjK0prxAqaKWShPw=;
	b=wHQElsgTNmA0MXH3zC/PE6MsjAq5xcCjOe9RU1RRT0cWPJouZ1rQuQQ31sVbhvTwDX+edw
	rA7WA8zhzyKp4hMAKUXFYHMj3UMdb8vXrAICcgW4vwaE0H9x5R59LiDvp4MM1dq3X4M0Oe
	bOufAWDRHFl0Ep5V1eyijyroFG5sE6g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LsR2Wh+5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECDA841AA3;
	Mon, 23 Nov 2026 19:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019511F000D0;
	Mon, 23 Nov 2026 19:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795462720;
	bh=0DaLrAjJERB9nEFU7eyItkBxKjBtjK0prxAqaKWShPw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LsR2Wh+5JU4k7rgs/Pxd+WRv7lmJ7zsASZ+wbZcpBeBuS2ShH+1SXGW2ZVCuSv7Za
	 +m63aZ1smrwrwk/ajOfbjQs3Knr136/sZ9XM7brd+DHdevDn/rONMER1Tk54o0MSM+
	 ZsBG3yS0AzDvZhImULsg9eFVbw9hddxVBGSYS9TySyA++XoKrQJbMSYPbvO5GgUNWF
	 ueumWEOw7W9d3EZlZhikorcZqydHztD/F/0K33LA7lBQhZ7k6cdX+0PQMh4oabAFVK
	 ZOt46kv/GnuUx2JAsIMNV1oLlG002sm3xGPZfKQOYCsSppBkj7dORmhmFL8ROPFF8L
	 P+FaWNW7Cn2aA==
Message-ID: <98acd21e-a97e-4299-a206-639ed9fd29d8@kernel.org>
Date: Mon, 23 Nov 2026 20:38:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: don't drop a folio whose swap write failed
To: mt4022@columbia.edu, Andrew Morton <akpm@linux-foundation.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Kairui Song <kasong@tencent.com>
Cc: Chris Mason <mason@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Tal Zussman <tz2294@columbia.edu>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261123-shmem-swap-write-failed-v1-1-41a0115dfbf1@columbia.edu>
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
In-Reply-To: <20261123-shmem-swap-write-failed-v1-1-41a0115dfbf1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 04A72C0007
X-Stat-Signature: 97abgdskq3ba79q6ba16cnck59pc56jb
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795462721-580350
X-HE-Meta: U2FsdGVkX18Yi6uDpUCFyeXmEL0uXLImhG23xiTI8utGFUEi3prhxEEbSiRI2m8a5slRb8pvksFfMrS/5lvoWdtz7d+KOHVEoRr5UTSiqRR0g+zZZxWObd9FHSmpM7r6msuD7a6RG1zW1iYfrOjzG/llGoAhWQWlwFikxId68M7+q6NBMNCVI3aYx55ysGF8kO1w0y1bXDb2htxMim8TC9v1Gad3ANPozj1jzpx1M7ww5hs/geaI4BWtd2z0h+/lsor9tyyUdtvUV8PS1aH6KpHnMesNfKt/2iYaQ2QhlhizUnORDFlRH0S+ivdEfXj0J4gXx3YurGPGp64ZCPQAV4nAc76VCUaEjxp8jUMl4Q4cU+3vIaJNKpDUXKXOXZDzAm3THVTjT145R5x6DbFhLKX30PH0AYyuyiVYL7cVVLlbXwno/PedqHVHS8DEjXLwi26/AF7VA5NUw8ysJLzvQs8AcMn6Nu+2327EKLKBb1hewu38BEXWtq/YzXgHHet+KJJvGlDSDryLZ5jjNWYQ0BEsZz7ykIb+v7fpBYmlJKZ8shtLhoFPx8cRwr+Z27v1GhSvhe/MXtQ+7sHh7LlpMxvhb2J5qOm3j+U/j98n+LaD0EFkkbCZV5tmToBakM3EBMgzz+GzgKeG8ICA/BzGU/g+Oul75v0bZYILW4QCv41HRgw28euKVVQNt62/UfwuQD/27SLRsRSCmLHUQxRusta4L9AaRm09IPYQ/LgXXhZv+zQ2LuxItDILbQJKXDc8LUIDVGQBVZgtgQY/HVoY5j8tCvUy+0QYcWPXxyihLzZHYpINrsgdp8jqmu/QXTGEaCzdDkOb6fZTQJg19Xz49kcOtNt4W1e5E8EBLrk18inbt4H3rfV9t1CRjD8YO9JgD8NVH+/FFZ2YTVjO/8MRkOd7qHuWYvW8pw6iFxOqIkOR6FmJZhq9diocXuQqECpU5PBA1ZyKnMscYnWYyCt
 MVa41TAz
 2ILvPzea2e0Gxjkn3564AvGGFhiPdMDLrbWf9DKX8DRK+mmpMkuSijzB0BtrP0AWa0/BxzTcbHTvaJbLLnJ/lYxvmwMmZ6HIhQHB/fcs2qgDeT6O+uBOBf8OQZbG1fb16onzz1VietuoHq8WJ0VoTIMSeu+f5+5Gef2aqT/ENuGTlPSd+oqbXeBqttRD2C2/2ec4mdjNEecgk2IPKYVTGZhgwcR8l5b17GAbkNQ6gSRUZnzVGu6ACFcV9/9zQeljK7Ns2mLHdhJrEYQP1NlLPc4DvS5A3eCA8mBCc4EryZyuOeh7cdMpnEqI9ExpbceHirMT0EJG32m9nuRadgJogjcA3eErlRzYwxOakCkCm0lOrPJQ/lNsLCkp8GEB8f+mPsBZf9orjnNQ4VvBMm3HsVil0gwoGYvhAot09GYig3m41FYbAaxwoGen+d9eA8Bfg8WgxDkQ2c9WZVeVLUyGawedarZsNwFGfKUEmhT80RMqlbi4zVzU4Jvd44BBFxbCPmhbB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 18:21, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> shmem_swapin_folio() drops a large folio that does not fit the mapping
> from the swap cache if the folio is neither dirty nor under writeback.
> The folio can belong to another file and be under swap writeback, when
> the swap entry was freed and reused before the swap cache lookup.
> 
> Swap write completion does not take the folio lock.  On a failed write,
> swap_write_end() marks the folio dirty and then ends writeback.  Since
> dirty is tested first, the folio can look clean and written:
> 
>   CPU0 (swapin of file Y)             CPU1 (swapout of file X)
>   -----------------------             ------------------------
>   shmem_swapin_folio()
>     folio_test_dirty() == false
>                                       swap_write_end(), failed write
>                                         folio_mark_dirty()
>                                         folio_end_writeback()
>     folio_test_writeback() == false
>     swap_cache_del_folio()
>     /* X's data is lost */
> 
> The next swapin of X reads the slot whose write failed.
> 
> Test writeback first.  Both flags are in folio->flags.  If the
> writeback test sees the write ended, the dirty test then sees the dirty
> bit set before it.
> 
> With the fix, a folio whose swap write failed stays in the swap cache.
> 
> Fixes: fc2c19648d68 ("mm/shmem: fix swapin livelock on a mismatched large swap cache folio")
> Suggested-by: Chris Mason <mason@kernel.org>

Nest to make that a Reported-by:

I'll wait a bit before I pick that up. But it will be a v7.4 hotfix.

-- 
Cheers,

David

