Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391B0C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 13:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D06A6B008C; Mon, 20 Jul 2026 09:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B1C6B0092; Mon, 20 Jul 2026 09:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F400A6B0093; Mon, 20 Jul 2026 09:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C40756B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:27:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 499528018E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:27:36 +0000 (UTC)
X-FDA: 85009232112.14.1B3CDCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5CC0A1C000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:27:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqZDfWIc;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784554054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfMWAhcurd9jnYRxbBfW+WW2HYwNyjSiwyQlHcyO4g4=;
	b=rj0PUggPVT+JX6Y/ordXiVI1RpmH+4HdHWh/kQODrEb8bSK7iCRU01yWIQc8fO7lbmnk3p
	bWsMCimB1fR3duP+f7tRht8K7ebXLmF08kklvzC7cpbFxoAD1hMTZ5GCvibNJUFDbMoBqY
	BICo35YuQXS8PONNqKE42y9fUPaPZ6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784554054;
	b=izZk3xsaI4CCkYKrHaFQYfaJBjV23EvWfGCA3TVpI0WSvU1K3uQKd58lyCSJRX3HSjCMSd
	PfskTVA0bpHz6VH3XNNY0YQZ6omRepPxY9TSvl6rOzn0ZCjGKEBHf1ETWO+4hN+GasUsUG
	6akKDgooRmW8H5MnADHsvrY/4JtTqVc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqZDfWIc;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C14143484;
	Mon, 20 Jul 2026 13:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC121F000E9;
	Mon, 20 Jul 2026 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784554053;
	bh=IfMWAhcurd9jnYRxbBfW+WW2HYwNyjSiwyQlHcyO4g4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SqZDfWIcZaJBcTK+HOIlUOuEiofdKVF8LskZnsDfzMC1Il+YrL4W4RepuurErIeq2
	 OcbHPuKQd9gVbhA+Ey2jtwg869y7ALQBkvH6uejDa1S/RZ30yPruiG/M2eXGIE+yYL
	 6lvxyToZN8H2U//LxAetwqhPAJjGiTP47vxQtb9odvAxwCYwuW++zQb3S6r9cx8mNC
	 WZ6+Vx8BTqUpXDlmMPpPuBvGsxuQwv08bLOjm6GEsnflTqGJhcy2U2KuLXbmpQ55rj
	 kzjY2Sp5q7G2nrGol7vEZlHmJ5bXYO5ZLwIP7tWlSAHEAurJSfGuSNhJuixxfKrOam
	 bM7/FEG9W8o2A==
Message-ID: <40b8e68a-49d5-4d08-9ac4-4f23533d7ccf@kernel.org>
Date: Mon, 20 Jul 2026 14:27:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] mm: vmscan: add a helper to identify file-backed
 executable folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 ljs@kernel.org, hannes@cmpxchg.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
 <2ee74f9f98ac45a2f0db0ceb018e086bdb671d17.1784509721.git.baolin.wang@linux.alibaba.com>
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
In-Reply-To: <2ee74f9f98ac45a2f0db0ceb018e086bdb671d17.1784509721.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CC0A1C000B
X-Stat-Signature: wbgn7jx6p7by1jn43xqeg5ysenzw969z
X-Rspam-User: 
X-HE-Tag: 1784554054-596791
X-HE-Meta: U2FsdGVkX1/ft5uf41N1Hp0qzMfX0WVmxprwbT35R3PVsdKmr4nJQNPEKAnd9ac8dOpdQmtPpYRAoaf+tGbEE3yA1dnlqwqvLNZJSn7RaZM4oLAqBeEnjRlR6tecsh4AxFaUXMwK1u4KuNA53yhwTvuaQJuAdObohRv1RhoKUNWcFAVNErznDD0F7EhqF+HVKoH/PMsGG1DO5f0/WDnizVTisjnOhnoXAHsgEcX7H5hn/ry9rrUv5YTdgVrEp/09/NPkcOrSO0alHV+AbMEh8QGb2HBYm90U4xNc6o2Up46XPe8yy5ooLlvJj2DK3okjFLtlPh/+sT/he5rg/df9V/IjG206UfPdsLXAIVxuJbr6l4omXBSq8Pu/CxXkq/GtkDXsbT/Z15gdAsdmtpMpvEKpelHFmwCQOWg0Ej0AXO5OEkmRJyXmLfEaQZVCwbifSPwLOFquQxXBEGSzchjO9DBXmZxPVAIEQBthmDaKatW8c5qTsGU/XU5EO32rYlYfK8KAivwy3MLfKNRDF73Y09EXvSao6lMk2zxihsvxnn9HqlQaIHyL2oYb3InY8fUklzvUi1FGipMfWbKskJbTYCjAMSVGT2eHeAkKfBQBeZxqeAjtHEJq/XQf+ZriWY1ERE0s8HA12F/n84Lkm079UUcEmEyl7HunxHwzEj3uVjqTTKExojLXwCGwQ1JNX7QtdG/x3tAKARl7pDdQ6PQidF5Hs3ARMNscM0VuvdOdL4C83cpRl1s8SIANtJd16XHQ2WF6mfahsXGn4GYKdsVmkqhPKXM1/MzbATjXTfwOpq4B5TBfYZRKu8MFSwQ/Vn+GQ2tLLwfyk0cxBZQM9ijEYXhybXuj013WsbND+OY+AL+AvyZNiZ4Zs0bZvvHnWmv3jncLt25O3BgJ6EgUjRKYxSkuztDqJYm6q5NlfD9c/VFc+lATl7TNdPg+4Iqbftjf/YO8ZN3Da/uBupuEGRZ
 yKA7C5En
 CeMEzpp5UiXAA1DUndd6sLpyHRglaFvsGhLHtvdtC3+f7+gvXv2wG/tRmjF6GE8yCn56//6+3+ADrNsT+8DXOkG5Ea6thDeU8r1VuoQFmj46ucclIXn1IWdAl90koHmtXsz+kqsmkj8Ie1Cnyv0pZVdwmQX5ylg3Ea46+d/IbkWqvujdCltHf/8vr2MBxcT56QfRkOgIri6kkiQO6jTgMXKTo/KdS5w7xGPpv+WUTEFFYAS6eIhkf0vXc8banASAy2zjIRKPuXWVozPLNzYgphVYwIokHgRz89p25tcIClBmi/L1OFBAUQBjsKdYL6LS8OBpQKwjP52flBGkMoVZfWnYk8cIoXEyxvzQULy3Yg1eR44J/vIoasPzIneTp91eG29Aes6T+8izLWgu3T8XqCVin4l3KLUyqiby4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 12:12, Baolin Wang wrote:
> Add a helper to identify file-backed executable folios to avoid
> duplicate code.
> 
> No functional changes.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

