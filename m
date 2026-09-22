Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFD7C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71CA6B0098; Tue, 22 Sep 2026 14:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25836B009B; Tue, 22 Sep 2026 14:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13426B009D; Tue, 22 Sep 2026 14:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0886B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:59:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CA81A0608
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:59:48 +0000 (UTC)
X-FDA: 85242312456.28.C82C51A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 788694000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:59:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XJ/vawll";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790103586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvjbyhwP7sQygXV0SHBpWSjy/p6q5mZqHBy2YHaDbcM=;
	b=ERkWFQLmJsgrmc0KkNDSm0VScb+U+yNqrIrsCFtHmr/U2NJ0II5HJb3GCyuQMuhbvzUP2T
	y0MCbQFCabHWt+AxwuZEV+r7xc1cwPDIyQ7WAnkxnjZeGoBZ0WhFgv2wRFLezp7TDQU9O5
	oV0iFuhgTT9kcg5GiVUSLoe1+hHegU4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XJ/vawll";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790103586;
	b=5tX9KIbeZk0er25ooD97rVqFnVXr7YTou5BcXyEULONVbeQLs8eE6LBUI3cwXsox+RAZDu
	z4svFi50PcExTET+3q/UBtAJlBiUOTtnCMYAHpk/FpgC+whuedmK3uGPyYnKacBNw6fgVq
	VRrWfHt+h85tl+cRQ0AYJtj7l/YmDxs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37304447B2;
	Tue, 22 Sep 2026 18:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3F21F000FF;
	Tue, 22 Sep 2026 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790103585;
	bh=AvjbyhwP7sQygXV0SHBpWSjy/p6q5mZqHBy2YHaDbcM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XJ/vawllytAbPYs8p9gupcoh65VusCSetitLW/T3z5kxZQimzbMtjSspkFQXH+rhO
	 ReEgxG47Mz3+OOtvGqsxJVMtX5BllLLfXWRGCpmRvjxpkn2g7OfbWWMUNuXPOPqRkP
	 F6EwgkNyVZ3yDfcUWCxtktji6mk0OmK5QE4nX0zxOaFe6gWmlfdHNn9eFhFHauH9wW
	 Q9KMn3wKvTfK6KB85kqheOC4eUJIrewDVvPimIwjjrCagcgplwfCWvB1e7rzBsiEJB
	 s8HdyAOf4C4WaKevKFVILiOZs/dresHyf0hKH9EDWJQTnytWh18ZlagYBwDejxTPUi
	 PR6x6LMGTzKgA==
Message-ID: <49a274cf-56f7-4d16-aa49-b2e5b8eae196@kernel.org>
Date: Tue, 22 Sep 2026 20:59:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev,
 hannes@cmpxchg.org, baohua@kernel.org, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <46914256-508a-4737-86b9-a43be7e628a7@kernel.org>
 <CAJnrk1aMitdNO8kDgMF2tAE_1N_sc1JsuhOTqqiWrHxue61bPw@mail.gmail.com>
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
In-Reply-To: <CAJnrk1aMitdNO8kDgMF2tAE_1N_sc1JsuhOTqqiWrHxue61bPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bocpbkmuopg4ykretr649fiwisaz1nn8
X-Rspamd-Queue-Id: 788694000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790103586-30608
X-HE-Meta: U2FsdGVkX18OCWHGf7jAIqfMpnoZdV0SgxMxJSbtQjZzcZQcFW/fKEXcA8uHFLus5eMK4uZEGwzjbDhtJLkXdPnU+9XuWbItpeWqp7KL4LIdOXjZkQe5c7LbaqsIDiVzRqsRbxEnY5j5jLUH4PuAAFDJlTrtc78YEoiXFOoXlmt4QykrrdK/rF8MW3o30zseUgwf314cZpTZcdNIOQUOxst+Z3oCC9nYquKHrBren7NEGYrbqYMcWI8r5Z4ytBYUOXsPl3In3ozFu6byHWPNdotwZnVJiY/WtCtQxIeSXf4SggtqlH6U/ZJRmQkbS04qEP0k1zEkXrItH6uB59x5D4iDBT1kLCzJwM/vGjXOqJnkW+aPR7kLDzF/O0jRGG0XEYKNShQjgc0QsQ3oPBbpYLAusx6lOKAbZcvEUEx2hpeDUD/QJrCROE2lYMvvRRNSUQieFBlznEfQLrwlTVE99Y3DBeBLzFNBuJ+wL/HfjN7YuLinA3FPinA7mosGxnfuwyTB2weqxln6rzFoZ9mmKh7ngGZ778hpaj+VNssQmg/W4P9kUgRR3mBwEvGU+INDu3ROcXzSJl/rMjYqu+5aueVuZg3IDw+8QzpggUlVaxmWOVmD+zXwpIDqQ8kVZkpKaLZOUsQwLrxt5wEttORCQ4kCxipJbeBI8W5jHDZFTEUtk2IdZNqzpjiNFf+VrWtsNvAjVNWSpX1npmmA8DuAu57no5BsRa9L0+yNgEYG7Vq/BwU0mlHK9fgipZ3Bj1HBok1NNBtpoHiOhepcklx5j1AgH9OVMZl5ZnGsFTj5F/MfbVVuqVjcbuidm2sxp2OQa2pykOyPv8xc5JtXgiJAsk6vbSKWEcoLwEAZlZfQdovk1RK8tI+zE1aFnRw22qCTclsmrZw0nmpCcxknYStOME7pnTkBdi6Tf9/LNN+02ITDZ62YIfxyZ9nBsf3+U13peqtXnT2szwc7KAdQxRT
 HD+rPUmq
 D8xf4m1khfaYrb4EedqCHvqOTyxIRMwS2WA93jEjZRu/CN9E5o8F9cthO1DURw55tgMGJrQsZd2TB0fmNqYe0rTo5fd3l/2kd5NespxIHnAI2dvOtW8DpoezERytk7lhToKD+/C1YC3JUAoCQjkjMVpCj/f9wiITaQPFw4F3kJms3CLLtWMhQauaC6+oTEU2AZGUOIKFrPAlG6Fu03Zvk/WCBCcAxRVLIDz6WiqdAg9mNQ1kRETgg9gk8TzbdbniYfn35uyGBKCI2GK0sgP8X7nBzLX+UP0njwU/L5ZmnxqeJcE9pwCWZRT8Jrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 22:33, Joanne Koong wrote:
> On Mon, Sep 21, 2026 at 3:23 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/17/26 00:44, Joanne Koong wrote:
>>> PMD-sized THPs that are mostly zero-filled are reclaimed under memory
>>> pressure by the deferred split shrinker, but this is not done for mTHP
>>> folios. At Meta we would like to deploy 2M THP=always on arm64 with 64k
>>> base pages, as 2M provides the contpte benefits while the PMD size there
>>> (512M) is too big to use. However, 2M THP=always causes memory regressions
>>> unless the unused portions of those folios can be broken down and
>>> reclaimed.
>>>
>>> v1 did two things. It scaled khugepaged_max_ptes_none down per folio order and
>>> it queued every anonymous mTHP folio. David objected to the scaling since
>>> collapse had already rejected proportional scaling as either letting the memory
>>> footprint creep or being confusing to reason about. David and Barry separately
>>> objected to the queuing, which adds list_lru lock contention on every anonymous
>>> fault, and hurts lower-order use cases such as Android's order-2-only
>>> configuration. Johannes suggested keeping khugepaged_max_ptes_none absolute and
>>> simply not queuing folios that could never exceed it, which addresses both.
>>>
>>> Read as an absolute count, khugepaged_max_ptes_none also implies the
>>> smallest folio that takes part in underused splitting. A 2M folio on 64k
>>> base pages is 32 pages, so the knob has to be set below 32 for those to
>>> be queued at all, and any folio with no more pages than the value stays off
>>> the queue entirely.
>>>
>>> Patch 1 makes thp_underused() folio-size aware. Today it only ever sees
>>> PMD-sized folios, so it assumes HPAGE_PMD_NR pages throughout. Patch 3
>>> breaks that assumption, so patch 1 generalizes it first. No functional
>>> changes are introduced.
>>>
>>> Patch 2 keeps folios that can never be found underused off the deferred
>>> split queue, as suggested by Johannes. This changes/optimizes existing
>>> behavior. With the default khugepaged/max_ptes_none, PMD folios are queued
>>> today and then dropped again by the first scan without ever having been
>>> splittable. After this patch they are not queued at all.
>>
>> I think we discussed queuing folios once the value changes and you would
>> actually be able to split some. Was there a good reason why that idea was dropped?
>>
> 
> Hi David,
> 
> I have a paragraph about this in the commit message of patch 2:
> 

Ah, okay, I only skimmed the cover letter so far.

-- 
Cheers,

David

