Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDECFCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5276B0092; Thu, 25 Jun 2026 04:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77106B0093; Thu, 25 Jun 2026 04:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940E66B0095; Thu, 25 Jun 2026 04:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 676386B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:53:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD0CB1A05E9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:53:06 +0000 (UTC)
X-FDA: 84917820372.26.1BA9906
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 194DC8000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:53:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ny3+96Q8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782377585;
	b=JVSnNGujdQHZ8dL7VLZ9s9OFY+9xrbarv4zZWp8MJuClqVZCkr5Rw/8yVIaEAwg5kI1sCy
	+TsOznKLp3l2NUEhZBKEa1ZDwNgSRumAgdy4SsOg0J3fpXlRTSS60bMzbZwgVKiCBUv9W+
	71U8uQiL/jw3/HBervQ+8ZXyVmt8R+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLx3IBHsPMEa3ayTkaqgtzXNiSbpIZDnD6UXI7qOc/Q=;
	b=nKsLWXw57YMyJY0gKpQr68fJrpkkgNuCOfJ470Twm9XkaDFNHIZa6AKwaO14sTbq+xSGfF
	GfaXHpEuZDIkpMDHtH6143BbXcx0iV+Gt99HScvN3qD38t7qNvO/vGh2IA5r8opVoYZr5J
	ajA3uoLi99VxamK4khOCf1PVh0qIC18=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ny3+96Q8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 93E4360217;
	Thu, 25 Jun 2026 08:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D2E1F000E9;
	Thu, 25 Jun 2026 08:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782377584;
	bh=MLx3IBHsPMEa3ayTkaqgtzXNiSbpIZDnD6UXI7qOc/Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ny3+96Q84XPcCILi6zX0gD+uw6+B2onPQCRtSd94xIALW4x+1pz1jAXGYuSpe5uRU
	 kT8K3wa/nBCOVwLhPm2PE1QnbPsgxN2yDKIs2SbjQyS/CmbY2mHJeAXUydlf6HQrd9
	 tv8YQTwsFAp9YegUovy+L8nuAPBey+FEiM8kxUGn7Rud32dQy3bxGX95ZJ7j8dY0Sf
	 9058YtrCPLgvYbYb/gUnkq01D8rGket2i1b8du1tCtfOFR4uwlyRY4k4FP4s66O0Cx
	 CttFwV8o8o6MOBWjypnoXMdXyPtx+W3BQNgnK7MU4nwNfvfpZEEeiXEqxNZKwzNbwB
	 NT9iz09mRBrVA==
Message-ID: <4f43c837-0f9a-4302-a3d7-f252d84ea390@kernel.org>
Date: Thu, 25 Jun 2026 10:52:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: refactor finish_fault
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624102047.144543-1-sarthak.sharma@arm.com>
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
In-Reply-To: <20260624102047.144543-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 194DC8000A
X-Rspam-User: 
X-Stat-Signature: 3m4ongw1yuqgsgy34iygcp5pasc9yjtd
X-HE-Tag: 1782377584-228466
X-HE-Meta: U2FsdGVkX1+i+Ot2gbSI2sKoRkc0jgcJ7Zgi+51I6TCAlxV12fLDChHG1p4PfSbPR3iAEvnNCv6epkQwtoMdHfTx5kOItdA+YTvl5ugnx5biX7stDcG6nfzOQbbatpFPPTr9pbVwQizSNvX+Qf5+OgE9c4pWQk06PWIRMarogfz5JWqHiX9l6Dca8GA9HEkKX8jaKd8FObAHS0mlw5PLMoubdhdO+1jcMHmvIQgSThs8hlkRbC6uWbp801ULYLpKHZq/D/3/c0MH5C29NojrHmIJX6ET4yFSeyui+zVUUDpblcxXOIVQiqnpRjAa9YD236b4xHbS4/qasVpjMWWWB5XEhWsR8S+zr8gsXAHXni2iyaOMqFsSfDFpeHmaG3O5gADuejVpM0IcM1If5YB1me3NsLxyuvAPVIhR8P4Uagmr116yuyaHID7E32qstfQ86IsgS9bx4b6vsm+D6FZX/61Y5Dmc5VzCf5rFpwZDJncz/nW72Xru86+okT7bCw6wEB6Vs/R2+79LE3Q4aq37cpZRj4ftmr7y8Ut7GPt20vR8mvDK2AxCWsgKS8lznDoZJLNK4a1E00wh67CBV9mr46+DXyaNhOmLbiaci4b8BcvFLPgOLaBQMmDo0jgQSS60OSYMimuciUANaOytPDJwW9HEYNH3Wy5QB4KjFBS5F8pz6ZRpzPavz9bb4couu4eb+fggz9KpLqGsWu2Zq/qFKc0wnSuaac4ghKEWkocuX9VixklH/UOZUPxYy3G6sz2MaB3fV3NgS3CyzI15+NI0GT6bSYHBk64nVurbf9ZIgkuzdzNXXT7MhfVTRwBOQJc8V1evJ76UUUr4SsbenXf86qg9BmuDa3Z8a6/QIFE3sMnIArV+9LOZ6rPGI2jw4j9VTzL5LH5BZ9+tFiGnOxB54wpmJ2uwhR6muGZKWr+QNwNXUeppAjVf1zVmyfk8VBcsUsUsyNhRhh35nol/txr
 ylRf/BvS
 Rggz425gqXxAET5I+JxQ+QRIqi++z9YCbJCc9dkmu5g13kVetVv5xb/4fN8kdgBkwiNlzcIdlvsE7svn9eifB3CLLs6+3Q7vk8YgmbGYM3krG/lJsxPa7IkxWxqe/Q4pk92aGP5LwhgGDHNKBSgT3MH7ewB/e9ZByj4mL32fDzJiYHf63vZ3crTdAipkwZbxz9cipRLtYyJVPLIyTfXrqMN+aXZVVEsqp/deBHAlTSoP4iHVBLa1PBtgZGnRxHiXb9qka5l2J3i3QsycFobf9IpAVdsLEtEjUElUz2TgGVjeP+0rBnnt4OZotIu+OJhTNnR2Q3NKZCAZOPCX4XMLeXRaSHkUDRk6isvA6RZL8TSb8owJivo4BlDrS6/IkdNjGb1WR3BC5MIudWlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 12:20, Sarthak Sharma wrote:
> finish_fault() currently has a goto fallback implementation
> where we try to map a large folio with PTEs. If that cannot be
> installed, we goto fallback and go through the fallback mapping
> path again. This looks weird and is tough to comprehend.
> 
> Remove the goto fallback implementation and try to map the
> whole folio if allowed. If the whole folio cannot be mapped,
> fall back to single page mapping without repeating the whole
> function.
> 
> The cleanup of finish_fault() was suggested by David in [1].
> 
> [1] https://lore.kernel.org/all/3684c55a-6581-4731-b94a-19526f455a1e@kernel.org/
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
> Tested this patch by running mm selftests on baseline and patched 7.1
> kernels. No regressions were observed.

This goes into the right direction, but I think we can do better.

For example, we know that we always have to fallback to a single PTE with
userfaultfd (incl. not mapping a PMD-sized folio by PMDs).

Let me find some time to play with this myself.

-- 
Cheers,

David

