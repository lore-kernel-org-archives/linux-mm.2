Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C2C9CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767CF6B0005; Wed, 20 May 2026 01:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F446B0095; Wed, 20 May 2026 01:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655AC6B0096; Wed, 20 May 2026 01:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 549A36B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:30:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFDC0C04BC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:30:15 +0000 (UTC)
X-FDA: 84786672390.12.0DFFA21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4AD1B4000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:30:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4doIfpx;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779255014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MH//zPs3PGDwchgJ8XRn+tdJgskudOstKxcq+geZWBs=;
	b=Ee6bzfGTw34A7No72FMjxDUqRZZWwiVTngeE1jaRMlXKL7zenZb37U1k8rBjw/+HHs5Zbe
	WQq5o7YIS8ppSXrxWUSHQ2cMkyxP30HvB4ZfmvtV9ehAxHfCgl7tC/ckQjq8mwanX9tUuc
	P9crMJ0l7wWOlJbnC12bxB+CXVEwJJM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4doIfpx;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779255014; a=rsa-sha256;
	cv=none;
	b=acLOIPRLicDyImMHjd4YFSOvxCjS2TXDjdFVnJnKvdZ43ykrCMZl8JPO9UnYsKQiOwANmx
	2tkCKBYd+al3AIIh40b+O7T1shkfRmXGgqNNTTH0AlVA69j+bt4ft33VDueYbtzY8imnAQ
	1qPEgZXpvVtW2y8f0bGj1LHRIaVAkxo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B797860120;
	Wed, 20 May 2026 05:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B939C1F000E9;
	Wed, 20 May 2026 05:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779255013;
	bh=MH//zPs3PGDwchgJ8XRn+tdJgskudOstKxcq+geZWBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R4doIfpxAFXz3tTNl2MS+umUjyrcNGL5VriESi8fqSrx6VYlQSm16kWkp7r5BRWWb
	 uQfOsvP6urPnEJphOtgW6vm4kLiFzjmAQK+wbZY1J7NDk7sJXxVStDgNkiMoVsAS8h
	 HSkHCD+TvCNRsLPKOei5IR2Bq+WG8fmzyMyVf4pxjBhSfTAZg/x7WvJhCFJi105RoD
	 peO37EwJRWBeOke2idUO2Pr3JuwdV/iQsqJiYfoh7tVrGkXfLu8lv+pUGhzi39mHty
	 /DSl8POhZc01tqUGCY4qcSnkWPex3PTBd/RWwfzjeD+M0CqfE/R8s91HJjx4uyymDI
	 3xoz0myuwtz1w==
Message-ID: <c656720f-15ff-4bfe-91af-855d2ceeaad9@kernel.org>
Date: Wed, 20 May 2026 07:30:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new] Documentation/admin-guide/mm: Fix typos in
 transhuge.rst
To: Leon Hwang <leon.hwang@linux.dev>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260520051751.74396-1-leon.hwang@linux.dev>
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
In-Reply-To: <20260520051751.74396-1-leon.hwang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4AD1B4000A
X-Rspam-User: 
X-Stat-Signature: uwc7bg83aa9gyafh1gzkb58ackifya7z
X-HE-Tag: 1779255014-223877
X-HE-Meta: U2FsdGVkX1//aH5J10TIjc1GUkdsGwNRNLfr8YED0bHzFGqg/l7ivWPm9qLUkudeoFsucErbcBcAuHjufZ/hgpQtfwCvs4t4u6GCqygoS5GqFPvdKz9CuBims3GwdZfCtL8QCbhgyQIe3lQ+Ta/MqHquyxtPz4N6TuoCcf1eQly2SDmQiHRKQGz80a39pJd0nwyGFLKxvZbnDpH9vMwEvnyw2xLLiS7NAzlXF1jiwCWyc5GCqthYP424vWlNBwR/sv2kKXkivBqaomI8aewF32QVscLdolJkDqgriKbrAeS22sYu47MRLaakZcIZVnzYlDgxS6LWW9xlfDb/9yUrx7WKYRIb0hBg+rW3XmsLPHibDy/XO1Od9bRB46fUIvrRy5BL3P7GmBbs7T2PZkx2YVpyJluxuOfDBjqHQRRe8UgKPKKfh0JL0CHUwXpfjOb+/40p++FvuVrZL/OjJfUOUQ6MrbINswF+vC/gzEj5MMg/nTNZNl12rOasrxUY6+m2YV6QBkCT2tXwSqQLMx22+2KNhxmzc7/lVe++gL3iMl54Kl+r7XdEg79UcKPLHYEFZyOBJGjPGIeCN7vfsFwILEdOwSg66jyWY0Yc2mKJd6VHY979mEqhciB4Iuu1BuvfC8gW4G2rxWY3WHWCMsJik8cZDId6MXtJdEIlC23EOJM50FfzPhSDnuppnOU4Swc+8soUbv5o26ujMJacBtKjkvpk7h22Ag6ISQ7Q1KmsZuPoGoQZTVg2qbkVKcTFixuW84Jw0RZBP+InT9rVPsXt01jcSFA9kW8Jwq1kfNYMgb8SL10PmI83kUXWMF7A49mD0VppIsLm6CEcTbnGp+AnvFL37qXEeAUjOf+BnjPm5CxLzi0i/tEzVspDiyBevUChqDWqtmhUPEplQc331zlZ0yd5knFObeHsP9YHjq8cP+E1JIz2dEOltFSljPcC+EUAb0Rh6najP/5NJkBdY7P
 526/rfks
 AxwKp5cDEu6zfd7TI+b8+sYlej7F6llKOaqZL5r5IffyYbucQtd4swkgsCrEyMRAiFWj28+Pipb1HGgh4QxzR7aKX0nvhRsAjGP6GK/SfEijGsayklawrFK/AOjfKjx+WSZnQQx6OI4AJ7FGwODK1YxvEkDLkFSptSGNK4659BPpsMTsryuDPupHXJp4SHAnRqO5TQB8dyheRyO5qE48MxKR5AQhe2TV530W/YsN5f+t8F/nopFHwtuJBqHZGOl9l0Dlmtb7W3jnhH9qu9HdQa/7tZfmdEqrIDJuW3TWhuIs0tfrdUjsbkqJrsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 07:17, Leon Hwang wrote:
> Fix these two typos:
> 
> 1. approporiately -> appropriately
> 2. presure -> pressure
> 
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

