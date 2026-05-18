Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0019CD4F48
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CFE56B0005; Mon, 18 May 2026 04:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7FF6B0092; Mon, 18 May 2026 04:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE186B0093; Mon, 18 May 2026 04:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1716B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:07:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 017CE120805
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:07:56 +0000 (UTC)
X-FDA: 84779812194.09.183BBFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1BC1740005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:07:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KzJJPHAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779091675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnFENPN1cl28DDnpZhSaloc1r2FmwuDhsafk0pYCSzY=;
	b=YLQS8QU2Mh/Sr5lxIa6iA8moYu1qWzuDfVk2uSLVQ04lS8bt3OBkloefhZqYRYUiO2Cah3
	PSJ608g0p+uxpVWHLtKHO4cGSZGOwcjFORxDL2oAQASA10GocyHAgqEs4Bwmq+6unsTvzy
	HgMQfEX6NRguWOeLuReI5Y9Q7yWHtB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779091675; a=rsa-sha256;
	cv=none;
	b=B5TIjhwT4BFrAa5gg6WZK8ijmEyIEeoq4PW6c+SBY/mG2AKZxhKU1KfYKF66Xzu3hRBj8Y
	XbyfOY7eGjq15wjlLsx30qSZWF36Nq6GFai/sqL264yvKWyzcMkppcxGePZQOM97xoYAaD
	0X4KVVKXunBNMRwBOJVum5DUN3TAOOw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KzJJPHAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0476B42DA2;
	Mon, 18 May 2026 08:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFCEC2BCB7;
	Mon, 18 May 2026 08:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779091673;
	bh=f3s71y9fZtkdUU8EDqgHsrGFOFj1SW6ZW7p89xOqcCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KzJJPHAJIISUt1FdYf58bAeIYkOcE1zUWlLODgXPpZ6n6rAbaIvb9XzZ/frk9NDQr
	 NhEuLaZtWyHIvNgDA9kqn+SHDn/nwwoiBzH8m8AUG1XEDBC+Bl3vQXuOMP9NyNT8TK
	 1GHQBbCu5hM2bu3P3pFrUuIM7p716NVAWcw2nr7tmWZqoPVCaF+5evQYvWoRIWlnrj
	 yuohzEkfN9T1OO/tdBLZIjTLDNP41t1MW+VChRB6QEuQlYBVPV5B/BDTc8bN6Czaqr
	 K//s6/0fpGmC+qtOz2RKiWfqAAIcxm0Wk8JALWOzlXEmoUQRdAGmzZRwa/jeF1mnhs
	 mTnOlDeXqlCPQ==
Message-ID: <3249f38f-b1e4-4483-b4c2-156e184175d5@kernel.org>
Date: Mon, 18 May 2026 10:07:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260518063656.3721056-1-dev.jain@arm.com>
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
In-Reply-To: <20260518063656.3721056-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BC1740005
X-Rspamd-Server: rspam04
X-Stat-Signature: b6j85gam6gm6bqkahpi9qzg7kb7euing
X-HE-Tag: 1779091674-579440
X-HE-Meta: U2FsdGVkX18ZianNTICy+BDYlTzRf/5w+yVBLlxdaBoL/iHZv7DZT8PyT8OJUyuW9B5IT9XkFgfqMuS0EfjiP31aiep7KecGNkZ8ZG+GOycSPKuo+GCvQUbsvQIg1TxUNRgZW+GAZ3hhw9wmLstXmeS/Zl2WATyoaKcFL51lX0dv5Osvw8u5vkd7JFO5rfpgqx1AJnS8ElClqJMqH7qFfFsXRRRvx9qdI0CvoxfQvRcTn9euL472GCvg+TzU0L5qMGg0RP+Tsa0x54cwZ9472pXYNNUk/ccFrI6idOoIpYz6NFnBAXW6eRUd3hHbsZdVjAnh520WQq+mmSyWRyqSIaLLeliHnN1cOCawTu6FNq6rYdCaaKCr9wCxLyM0Cc6aw/ti+lDty1Lhw7eWAQ2BjbZk/5FSaupOmKRgxfcVSwshMqyp5oOnoD3x/0oo3AL33jswFNBi0p89asqXSrVcb+HwjaJ8l++GZlo1DiXW8mjFhoKWsUMnPp48aGpphvixKv3GI+SUAObhtzmB2HNkn91FHHx1R0ZagiHWd+SRKHC65UiFnDijaASO+1QIR92ame4+KYwryUG+TdFpw2DWwyan8gtno1wsDYP3BIXNiV8Lmn8ESKmvLaFj9O/vH4EgafLGOmpwPWLNYQj0zoaI7HVyRIBrydb+RTmEf4fLYZwBUCVWILTnWFazSxlYcjY+/5T8kA9npFhsd27ua/dtahZ3cCkeLLX6FzwSgVae7bELjt7alEI/v3bdbe4Mz4k9viuVdP+etrmPbKqzCvBPx7wpqyXObDfKIHaY4RKTr+6CLo6aaC7ipVe+WMZAO4XCpeug89xKtYS9ggF36t2kyPPmpx9CmDNOr+/5LMtOggAyedYXegtN4XEaJ3uxZK34BZLT0Ijbcp+JvGtx55mmxMV13ARx5kcLnw0sH/zwuadJGV9roGS27PK+t+SU+nJnJr8WLmBehiVJ2obcDeI
 WYAdfGjl
 U4etK6kc6A5cjKySnE/axymzLH4jd0NZIfNWoB+qhuAVvz7984AvaeahVumcymLYetMIiVcrZhUJljf15qWTNi/v1LczXT+mkzD+B96llIrO249/7lGetHDSl/AskKYkmgrJ1ERmzl1f0V4LbYN07x5UY2En7OtDCaB1L205VMI2zv2se7dBWdhp+gZIDtO1OKeCR6A4R6L8er2OZg4+WoIwNZ4AlfQFX+12zT4q8L31jZJK5fP/q8j6aRX/h70je3AYiLJIfzA+Og9aqfuI1IeXyNrKaFzhp01V0/daF6aiF1ItnQMDI/n9QIQqNGu2kOFzhG2jACNQD43hVeLjL1myBy1nUAj5BodkT1+/VjvjuuG5dLGUYw1urZ3FuB7F7mVSI44Hj0/nhE24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 08:36, Dev Jain wrote:
> Initialize nr_pages to 1 at the start of each loop iteration, like
> folio_referenced_one() does.
> 
> Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
> can be reused on a later iteration that does not run
> folio_unmap_pte_batch() again.
> 
> mmap a 64K large folio with MAP_ANONYMOUS | MAP_DROPPABLE, then call
> madvise(MADV_FREE), then make the last page device-exclusive via
> HMM_DMIRROR_EXCLUSIVE.
> 
> Trigger node reclaim through sysfs. Now, in try_to_unmap_one(), we will
> first clear the first 15 out of 16 entries mapping the lazyfree folio.
> This will set nr_pages to 15. In the next pvmw walk, this nr_pages gets
> reused on a device-exclusive pte, thus potentially corrupting folio
> refcount/mapcount.
> 
> At the moment, I have a userspace program which can make the kernel spit
> out a trace, but the blow up is in folio_referenced_one(), because there
> are existing bugs in the interaction between device-private and rmap
> (which too I am investigating). I did a one liner kernel change to avoid
> going into folio_referenced_one(), and the kernel blows up at
> folio_remove_rmap_ptes in try_to_unmap_one which is what I wanted. 
> 
> Note that the bug is there not since file folio batching but lazyfree folio
> batching, since device-exclusive only works for anonymous folios.
> 
> Userspace visible effect is simply kernel crashing somewhere due to
> refcount/mapcount corruption.
> 
> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Acked-by: Barry Song <baohua@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

-- 
Cheers,

David

