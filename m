Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6031C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B522C6B0099; Wed,  9 Sep 2026 13:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29A26B009B; Wed,  9 Sep 2026 13:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40A06B009D; Wed,  9 Sep 2026 13:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87E5C6B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:06:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 732A1A02EC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:06:19 +0000 (UTC)
X-FDA: 85194852078.11.405F347
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E6CD40006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:06:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IggdMfSa;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788973577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=If0/S6KcKK48ZbdSVC4TjnVNIBdTzJOLF8VEmurBkLA=;
	b=54tW8viQW2Wu8itq0hR0eWit/clCd1Z9QJHCQ1ajlkfiplry2h3aWrRMRZpEYr1Yk6EgxS
	e/fd3hgC6lF0CLNDO5OK7CKED2hioEntDwIJpLguhfQ9A2QMlh4X9BRJWyMVOv9gSiErQX
	QXHObAmKyFEDZTGhDtiIkUzvvY2yGmE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788973577;
	b=0YxpfLeIPLMUbfo5s5yyAr2FZicYZdzSFGaAC0GuIAs+Q4vHhRJXiFIXs8dYokz4yhgSvP
	bomw49SRJOqjeFezMEkHbEww6MPG5MAnWHacr6zgghwNkM7IdxQEHdnDpNSCynk3IPUC8l
	+3N0TrUgPQOw0OMZLW8qhxZu0VvqNoI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IggdMfSa;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E96F743CE3;
	Wed,  9 Sep 2026 17:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169751F00893;
	Wed,  9 Sep 2026 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788973575;
	bh=If0/S6KcKK48ZbdSVC4TjnVNIBdTzJOLF8VEmurBkLA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IggdMfSaHa7Q8elzFmjHlZkkyzf6XOy7XdsBUbbfeImPOd47OZIfAxxU9DwlogF+8
	 XVPM5EulM7RmsQpjdvUgg1VHyA3anBumcALCcFT9qK8ioW2IsgWpqf7007MFKBwKZl
	 XAalbdg6lmmOW52HgKdOXnxn45DJ61z5W/NZsxyrMNRZV5jXiz+pQZHWxDsds/BAbk
	 aJNGeXInh832Pfew4X72X/tfrqyGkIiF2Iqmk8Vjwsqz4Lr8idkwEHGD9QmztS90dO
	 O7C3bLNpHmDdGaVZaWaq7kFMRCxdhc+GSDdXV3OlPNCoME9IIzvIhLhwOmK00I0OeR
	 9oh4YvC3GtBow==
Message-ID: <1d5011f8-26a1-41e1-bb9d-8d72c08b8fe9@kernel.org>
Date: Wed, 9 Sep 2026 19:06:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] proc/task_mmu: remove unnecessary helpers
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-2-surenb@google.com>
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
In-Reply-To: <20260907063918.3432401-2-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7oadhfd5993j1jydfqy7gumfjp6swd3x
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E6CD40006
X-Rspamd-Server: rspam03
X-HE-Tag: 1788973577-181773
X-HE-Meta: U2FsdGVkX1/FRa6IxwgzQn8QsToTICw9j+nzpKxJ3A0utfZSHaVXETru+dyAnP7r4/5PfYKm3SM6virkPRp37ldc87YgTgr2aRnlk2WF6Y9vQ4HQsd5v1At4gdxckyDlrH8IHSUkPfwJvq3Obb4x0mdyT7jLIOuA8qkVo4AyqM3WiSPg59PVcwi5bXijZOapMRZn4Ys7uAZcaTjPFeTcSSiUiUJvOa9Em3Au8LrzHFLZUaExnH35PNpjDYTZTKMzBB/1YFNiJYkmG1pPXSq2TcMSIjFHS4FuL3twhtTBii7rHiqduhkfItQSSO9uFFL2JmPqDYQiCnDXn95AmM0hy99zQIzLtys8Q1taDT5bF1A5JQl6yImLvo2dIlU7UvFG3aRP3SuF6zhvnFZITvu4vnOP0mTkqbYX0i30spbLUGe/FTLXQZg+2N+KopQhHJyquDnIatZpl9daubXBaE+t+MfpS5b3JkDv9cBs33w1DYl9kHa+1FsEtMfInzyDU1kJIXFw0aKzsd9VETzu+bzf6dT8xs/sRVk52SN4hST7eGjn0rsBTnSPQnsDUD1rMVEwWSVR13h7cQCH0p+Wpbauge8ziqUneyvHedtHbKL/u8KZiDUbkzpe77HL2KEq9H6+hMvmEWoBwvs131GkdRXJBQyRBFKKkC4//8sO/ZBaFz6pI5WBjVk0dsEMBID1/B9cz6rnfwr9iStC3x4bxX7Eus1zAp4y6XheZL9cga8U828etbiJvqpMeyVqoU8U0mF8HPbei3vuK6NTia6/yx9Khc0J7CGrWGKFCgHTcX6eRsl58QCSXOLp1J/BJrbO8DzFX/RGTvE/vfgDckXzpYEP65ukBzZEk/1u2b3aAj7XrUYNtTLGrcxmdljlvd3/7ifu5JnoUs5ncZBQFSXnS8ROZUsg1QuvfknvH8J4JOKbW/Pz+nuF0nSI7tsnC1w7FzOno6pQCAGQ74bQcDefF+E
 RDEgyA8x
 DmsuM4SYgknplvmbrzWFXHrDeyGGRaWiC3qf2RuGKodVPeUKO5jbtFS/LWmJLV6o7kVOyxITp4rkoS5Hx+hAmEe8zqmmChtCFum8Fj25NNqABvbhySNf0Hn3rTj0+CdPYWpy9uIbCHPx1d6IQy5mstxrZpIiYHjG18tLO9oNSdrojV9zmdCrfRjn3oPuHjt090jrqmmuLKiSD45053eaxZhNYwYduz/iziBep3HbK32ndMdkX+veal0FFGDjV77ujA8RLsuOsOiGlVDxF9mypGyAFONoz+88MCAr6FAlCf8UmXGdWVW+ErEprH7/Cgyb1ZgvgK/NJQtcDTLTP1dFttvjZrSXFsSnDmmpF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 08:39, Suren Baghdasaryan wrote:
> When per-vma locks were behind a config option, a number of helper
> functions were needed to simplify the locking code. Now that these
> locks are universally available, we can do a little cleanup.
> Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
> query_vma_teardown() helpers.
> 
> No functional change intended.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---

As Usama says, this could get picked up early independent of the rest (maybe
even as part of the other patch set)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

