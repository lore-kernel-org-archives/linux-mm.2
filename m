Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A10EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720D46B009D; Fri, 10 Jul 2026 07:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D10E6B009F; Fri, 10 Jul 2026 07:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7146B00A0; Fri, 10 Jul 2026 07:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE4C6B009D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:13:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D06C61A0405
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:13:07 +0000 (UTC)
X-FDA: 84972605214.01.D596A9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1B0994000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:13:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eypDgINp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783681986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZb7/pxxnbIVqETA1OR+i/G8TlRTT+kWkE9kl8/ZZJs=;
	b=1OXr/EmfbeD919rx0a5M3639FVy9kAwV9RUSAxQYfqiTQ7gfXBAXEjxDKy2Qx8+VZRo61q
	dLIsrZdbh5rUpWznLBh3cR0Kq8OQdnK/MzHQhWKinPUuRsCMCybk30N/MnwKcUhcROJ8jo
	nI0txQ/KVXf7Lv2lOrP+MX//G9x4kZU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eypDgINp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783681986;
	b=uMbwLtJBktG32WO6fqAo6L2QtaOSwJvWFfjWTlY9CkJqN412JKYsWgNAN659eEDbgHG8x6
	koKTvmk4dMr4+WIzP8xbfb5QLsqle4YYC9ty+kVpaEk5KOBzlWAfwVD70x9k7b5059O2v3
	KAe6yrxCCAubJov3B284zGnABHgnc7I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50A6E408A8;
	Fri, 10 Jul 2026 11:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE811F000E9;
	Fri, 10 Jul 2026 11:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783681985;
	bh=rZb7/pxxnbIVqETA1OR+i/G8TlRTT+kWkE9kl8/ZZJs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eypDgINp0YdZSkwT6QCh0FbLMJo85+mqtUroPW/6IRw22kqEQ2ySxdu4J8QOfr0g7
	 EZzmELJ7RVhIYkkdmP+ofS9JM3ph5iB2q9bdqlTRsJaJHmxj7Acw5izjDSjjeC4+7I
	 PeI8qNFGgv1uQV9DbviVpHveHPVFlGD17PwtTHdEHZ0+TyxYVb5Vvl9C+fugqk7Y+b
	 GLIytksWVWA9VN9DFFYdryepbQuAbqn89bLIsO0Gk0s7QmgEPBjUI1Di+4Y3JxeRVT
	 aFSfUCtIbGOdF9q+Hu5QEMW6O6GleavmbtzR/LxLjHuntxhYIgKkdgF5OmY1b5Nsty
	 PfSvPYt42OYDw==
Message-ID: <75cfd24a-1372-4c55-9e1c-a3ac374c1011@kernel.org>
Date: Fri, 10 Jul 2026 13:12:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: remove obsolete hugetlb vmemmap test
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 muchun.song@linux.dev
References: <20260710092427.3459121-1-songmuchun@bytedance.com>
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
In-Reply-To: <20260710092427.3459121-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B0994000A
X-Stat-Signature: odoci6dywpynrcuzz96xigjqghcn7trs
X-HE-Tag: 1783681985-223113
X-HE-Meta: U2FsdGVkX1+cYe86SwCOrbAdB7e+9oanO5jsEyseybizsq+wN3iv4CaNTh7R6AIHEDXA6S/wPiAXuptgAaSUp8zMxP7TmW0Jk3/bkvEjaSnnJ/VknGAfJfUGHcYVl/N7arVVk5dPtZyWt1/NnSZ9k5O6sgUVh834YnKA6Lc/fLoh3aXxIFQMH/Dlg4GaWqhy/3YFwl4c4vST0zKzY2EmIqEoB7hy1OLOOX6R/l0qXTNe0IQ3fquJOXgMI/riO/LC7LXS7ld02Vy4Gr3fqlrjzKEYfObffsImFwngJ6uL6IA39HLZmT43elitJlVd1pmGHr5jbZ/9JP/qOZc684TywqaUED/BtBN0Ofv2kJWNIa5MMONy71n/hG1/f1oaw2RQeLBADxpchH/Be/lYdT+WUyXrltTO+x1s0og6NE+N/8uG/ehXzhAicJVpAuM/YepL5VSRwQYMFLP5aOJG3iCSPAK0lFgxquorgobLcfd/RUB1TRCFPkg0KE76zpMRwPtLwY4xVef0yTrl4LQzhflGgTcbniHB3vHt5ZO+aS6XkjkB9ECxnczUaaBrimUHiiWLcDMGFsQ5iSASXOlhnJ192GnaZ5r/iLpnh+Q/+v51kv5i1V+q0JhjGfk8254qyAGSe8m2FzywhmFLVV+y4w1fFjhnresN2R1Y+jBk1hL1cYQ2vOURPAWXRMbjsDSUIl5WviSqX5AmbLdqe9igVldk/hUrDKhOW1IZ+458MT71TCm4e4v+Qkw9f9LdK7e5IfPfcTEwhb1Nb4eQbwOpUbmc2RIQuc38yAKvE56xlGUnHT8FXWUysox0Eo+S/SjZcFsiaF9wgODClxJbvHIzHjUuwFvj5QLHiIrf10yO7LtSWH50u7C50FUvMNm9HaYST0O3TgaYdXq1cXDPAzDV7eT8vU3ergdUQiJn1g99WRiBXsRyXMG6yATjLDr/girPFmuexPMN7r6+eodOWe3RFVW
 AufU8A2F
 ekn3LHfI4XPYp3EKegO4MESlipiuTCYMJOgQbBwiqnfKfs6c5fJvlYn26ZXg3eWzFgK8Wd1G4riF5aUgsj8W4CAScsq37ixKDapJCeN2CWckSJ+sBmfx+ibkSYrkZHFAckSMMyakmOlMEZQ0biKzdT/RdbrXokycznuG3xqO5CycxcyST7J9wE8QcH0UcxL7kviyzq62dJjlrL5M5iOTHIRPdwE2yzYJi2QD3gDIuT0Ov9rEHuk7eO8TN4uqpgUj6/zEkMOp6VlidmbrqOx/41ancw+1lTAzjPVFDPeAtK04VkTXRyo/1H2j75Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 11:24, Muchun Song wrote:
> The hugetlb vmemmap selftest was added to check the old HVO
> layout where tail vmemmap pages reused the head page.  That
> assumption no longer matches the current HVO mapping layout.
> 
> HVO now keeps a private backing page for the head vmemmap page
> and remaps redundant tail vmemmap pages to a shared read-only
> backing page.  The old page flag check is therefore testing an
> obsolete implementation detail rather than the current ABI or
> behavior.
> 
> Remove the stale test and its build, run, and ignore entries.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

