Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2CE6C79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3AE6B0095; Wed,  9 Sep 2026 10:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B851F6B00AC; Wed,  9 Sep 2026 10:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D176B00AD; Wed,  9 Sep 2026 10:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77ABC6B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:06:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AF2240227
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:06:53 +0000 (UTC)
X-FDA: 85194399906.27.8901709
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6DA2B180002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:06:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jy5PQ6A4;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FR+7pa9LwLkwiguZhNawLcP+YYzJNH9nHx9g6zcIIqo=;
	b=wA2gaJQbceQYfGsgLx7m3R07sA/giory1Dn9RoW9zoQCIrP/SkY+Gj6cBmkkKGMbzGsP6Y
	eBKJGAbWg5Uwep+2PVlt+2EgwXboK9EBhTHqF8/qs8u65kKe62LLmxJS7jgZvmelQZPW9N
	wRQUQugTls61q8xxpNJdzMuiA5AXnIw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962811;
	b=0ncKpmnA4BLv5yLCW/t4yoHjoe/6DlcXve6DUpajDwNTjA8IyPjk7KfrhLO2J3VnafVK1L
	P6ygTn5bAqzDfgKtWsoxVXmx67JMQGn9maRFVso7gbcBeBQHJPX3dOhG5lPGoA5Xs9JSPr
	Z/YAxkNIBwi7k7MRVz5JZKrdp9yidqw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jy5PQ6A4;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 098D96020C;
	Wed,  9 Sep 2026 14:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4ED1F00A3D;
	Wed,  9 Sep 2026 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962810;
	bh=FR+7pa9LwLkwiguZhNawLcP+YYzJNH9nHx9g6zcIIqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jy5PQ6A4YSE1RykG0zJz9SnpqYHGFZ5nvPFmy74Kav172ISEdr2CjmR4Vqf0EaJU6
	 zRB8gEpXGfNksV4pslTnCRt0LEXWd7O3iaLyNVpNqLhD7F6HGcbgZ3fM7zqdR2QckS
	 67N+0aci8ikzhdqbt4KQG/u4QljVLEihCPdEv5gy1MA1cN/GWy++ou2t6Ucv4un+vc
	 d+ZGU5LBZ4B9FKLf0cULE/80gPf5O9Qax2H3iCV8gvOuyYFTXsD9JUkTqbtGRINnYE
	 sowzc7rpdDCrgvJ03vWm8uvTlZxIM89KSC9AmCRP49qvlyHNYjb9ScTUw+SqTiVHgf
	 8q8ht0UFxWYag==
Message-ID: <95b88b81-c970-41db-90ee-1efaae7420b8@kernel.org>
Date: Wed, 9 Sep 2026 16:06:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/8] arm64: mte: pass the swap entry to mte_save_tags()
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-7-ee6d01dfa5e1@columbia.edu>
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
In-Reply-To: <20260908-folio_swap_entry-v2-7-ee6d01dfa5e1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m5awzwkhsepcafnqkmfej841a9wrfsc3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DA2B180002
X-Rspamd-Server: rspam03
X-HE-Tag: 1788962811-3413
X-HE-Meta: U2FsdGVkX19u9zr8iYQTm0MJwRK3lNNdsE1XYeDqmAt+rD34o34g4s9HjGYImhPknM/cmAf/KC4REyFPrvyKE35ceRAD1LSsa/E3F1+9oE7X6ADWhy8k+FLC9yIOTXg0K3D8BM8RyxP6pZLR/c8ZL/4ZfpIXc0seLkbI61yizeQDL5AJFlFDMfTgrUHpcL9jBojOsXIo5aWmiyOJ5BnXosyVvYtqiEWxx/NzkOvuno9ucsMEmFTe9lpue02u0UafuxKT4Ri8pgYTyOt7U/nsmwvDWbT3MLHTc1SG9Il44vLyrHX7J0CONaq4aNGcT4U3IlxWmjhMf3FDzArvXxfpUTWPScZwJaCZFp+qGDV/ZkwcoOOBWPmiXx3eLe8nMAlpvPqL1yrzgbOKUdHMInVoxtVbYM2llT8N5IyMbYQaMJG31DSI3CD3S+hLkwkawe7fNtyY58OVJcawLEHU4/RXvG+Txh9dqMzTYxiut3EaqaUNoTzufuwaJAKtuiw7MqfctCpB2WOq+UJBldCIiDwZ1J9qKNyy2DZI8q1o5xjcKkmEHeNKSDa57QDMV6ygN6hOfhrtDxYfJbeFU5ofs7q+1JF/VV4P2ETKgdYJpBQ3EEFB1KnAMIkR41t29AAF/U5u6/87RUwBnund/YQnnyrgWjgVaWzw6U7C2w+2HkFkDVLgdXbORghEIP0RzwXyPDd71heT7UMMJwgjYOLmuBYHrupD9/BmK77bBY+ErSXspIuYw5ZKQg2khilEqVJVf80D7ChYgMz844T/Y1i7nSv6FeqS1S9NFdAtKmu/XTgU1lLhG96kJ7xVng4hP7naWNHEVFsL8Zr+O4IeH9BW3YDsJPqqkM/6fdy8dFHtmR0jGi/8NU95gXbKeCEWiuG93mvtq7bBZn+k7E3/5+MaKtKdl+zJFIDfr1mCcGIKQTGvcwASknlNNqv2KdZ6gnuCuaUqjuLwnbH/Qd0lDBNNli0
 rtBNf5l0
 qwYOWELfhmQO1ukYHZCt02mU5MmU0U/foLPIiAdI+AEjn2zzTPegZ7JhbSMnjOyggLpyoBpR3UuLaMbZK3hnkGkiak2R7nAUa3GjSJQZNAWehXF8U3zoAyu0NZEfSWG5Fp/JRr7c3R7+aWZARZIiqgK6mxebxHRpcqTP9GgJRV0K2oYRzk64r4Ob5ElOdSDhcnY+MTIHamaN8dfxYGEmKiEahgThY+xkftizV3glzwpNUwYesk/kzyUamg7djWbxnkcjUtsgPFLRdqekpYUw1lG/g5zWoZbdFsENqWFxlFcDrnW+XbH5iQkGwAcMdseHVMgJNJLL2sw/B3Uw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 17:16, Tal Zussman wrote:
> arch_prepare_to_swap() derives a page from the folio only for
> mte_save_tags() to recompute the folio's swap entry from that page.
> Pass the entry in directly with folio_swap_entry(), matching
> mte_restore_tags(), and move the page_mte_tagged() check into the
> caller so we only compute the entry for tagged pages.
> 
> __mte_invalidate_tags() loses its only user, so remove it and call
> mte_invalidate_tags() directly in the error path. This removes two
> calls to compound_head().
> 
> No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

