Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F30D9C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 11:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04576B0096; Fri, 25 Sep 2026 07:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4FA6B0098; Fri, 25 Sep 2026 07:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA35E6B0099; Fri, 25 Sep 2026 07:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B27D26B0096
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:00:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46706140631
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:00:40 +0000 (UTC)
X-FDA: 85251991440.26.D0D339C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4450AA0009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:00:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaqtgpTC;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790334038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSBvmNS7ZrGQmp0x6AI9LjYH8484eEgbwZLrKBALkwo=;
	b=RfJLSuQ9yhRfHtuLXDqsvww6uN13bjbpMfz3Iz+uYu8nezQRy4OKQLoWd0ZzhcdozOgfF3
	MvZ775CM+LEwe+gsBP/eBhSPJmVtWeKbN+1y2ql1h9/qCrCHMZMXjYLOWp6M6Ce40t+M9f
	XI+AaWzdn4vVEur4GrNdDkfOGrX4Uis=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaqtgpTC;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790334038;
	b=czwXrU0xekqISJfgOw83CO2X9IuP3oB8FEoJqTA29wAVKFgRYrguFCC4jEMk0Le9xAfHzP
	v2TvVQ0lhvf9tLmVEjMpfcTnysE1R6d79KyP6FVLoyMRbfXASSUnHxUSMdsRo7bmOTx0sl
	j3w1VYMAva7nyhXd0bq5/U5AYt0ntsA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0275E4034C;
	Fri, 25 Sep 2026 11:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71CA1F000FF;
	Fri, 25 Sep 2026 11:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790334036;
	bh=XSBvmNS7ZrGQmp0x6AI9LjYH8484eEgbwZLrKBALkwo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iaqtgpTC57Sh0JN58cp22Qidd2SWU+IqRCF21YNdtRjwz2nLkEkCdPCKkKbNjyvh4
	 evtY/NxHNsbko26zoZztfgAgv1VG+ZdAAv4Oovra4smkT6QzB17j7i82mwCF8HOGDq
	 no99NpY1ZWoYSLMbMdfzfCpeuty3CMkuQJQ/fFkSx/WhkjzHMa1QRfHD8PWKbYeB2k
	 BJK6hrdq4lZ0+67kSsPLA/RD6EwBP0SCLPa9qBBPC2We2VqhREwvk3A3JO5MmO1Gdt
	 dthhuVLNyPU7G2L0/DunkYXtDWHba6N/z1IFHZRKiPuGSfAsiC30UXmHrofaNU1zKj
	 m6ZB//6T/YdQg==
Message-ID: <d57e00ba-f34c-4d30-adcd-aed02f9a0d30@kernel.org>
Date: Fri, 25 Sep 2026 13:00:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] hibernation, KFENCE: explicitly map/unmap KFENCE
 pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-4-7f7dfae3dbe0@kernel.org>
 <fec1931b-1173-4e14-b74a-7b3987a9b7bc@kernel.org>
 <arP0-maAEi5yeNnl@kernel.org>
 <d568a29b-5745-4214-96d3-1b635cd46c15@kernel.org>
 <arVJm8CiLG6vpy9-@kernel.org>
 <c01aa1e3-f2cd-4b28-8e6a-8e8a1c36c641@kernel.org>
 <arY_058nsjb_Ie1l@kernel.org>
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
In-Reply-To: <arY_058nsjb_Ie1l@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4450AA0009
X-Stat-Signature: djtgezm1jot9mhjfiig9jy94qixiono6
X-HE-Tag: 1790334038-610535
X-HE-Meta: U2FsdGVkX1/QG6wKcDLvRiq9vRM0yDiCeA0/ey2KsmbHXrXLu8wP9hMgFBr4iPiVJGxM0rvy7AQ836sSpVZ+97u9eklElEN5KLksB/x1snX3npUIfFTsLGDkn7TUV4wkr8FULDG3F9pLiUrqhmsfgHPjl3x5Ale6FUuiBGSw3zzUUmBZgHIfAvVmR9nsSEp2a82aYao3Pzf584mJeY7XjtHfSxvrsjNLlLSaN+KWdCoOWrm2v3eIZvEf/0tAbq7RmzsNYb4jzMVhNNyjk0Sqxk8imkWjrDqjO9Che43c055PA5W/ENTxn0GLxEONJArtPvaXIqd32QoMXbGw9ra3aDZtaB12S74zqBO4USMmwmxACUzMiT+Lcw+L8l18TfjD6yetR4sIsIoDf6hSluwiHJ4oWWZhivOLwacVdPss+Yg5BxZKk2JiQX/KCpNMw/6gKl0bOPx/sfhndaZNRIQ+aCsJ6R9Oqnl02dcY2yWp+CIIbERpd2lJgxQNn+28meOr0GKQmv4icGfDmMgoBmacuoZOEOgVTVzexVpyra5rkN50w8Gj1rqZAp3ZIiuq93pLwp4NkCW7LpG4CZbnvOZwoVw6+Ck+yqwZ6HygV+e3g7HLmoa4cVRMW+NOULmQe1yGRdxHgA/XhxZLgYmOn/r7HiUaxrbmZMaqpJimcxv87PRxDLT3JecnllrS5RJClIzdTjp1x+T1uV0zQN5LxqWkZqQFwkr1MLjTxrw/wZpnTTXr/iKoAibMgHfToMEgWd38YoxZoTrW+47qeWlAtf3fGRUgoedmvJWvOfeaURk3NKzBS2tke6SrxJAFK7rG11tGbLP0y6H0AalrqcVbLWSz/adZvVMrwTLB+U1I936I1noyL6PY3srVk7Sa7ictPCyBpFlDEX1r/aJas3tve3EUo6sxecSt3zLQ1MuHMEwcLMChT9ATQ8TzCYq81VMzw0ufzAW/uTSCeF42bknT8hd
 w6OLi6qm
 kN0GlR08olKcvzGNqDiH3c5HMKs1WATKYriUM3A+eubcHPfiScJFf8wgJBI92770r7FWDKQDtQP6h6c72or16RTWa0cVOzSGOGDT5ksOHb2HBVzQO7YRW8w7OrLVSHyCQIFr/xupxtfYbWCEsKU35kVS5h9fw9xyVzq60pi5mZTIJYxGsWLOBYwQWj0kR3iaDCvPKYWGI2BA0Vq9w9Y47OimDxPF4Y4mpcrtqjzAcd+V2oo8gydUXjIeXEvYHS8/Evkmd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 11:33, Mike Rapoport wrote:
> On Thu, Sep 24, 2026 at 08:49:13PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/24/26 18:02, Mike Rapoport wrote:
>>>
>>> They are not necessarily in direct map :)
>>> loongarch does not have direct map, but still supports kfence
>>
>> Ugh :D
>>
>> But where are the pages mapped/unmapped then?
> 
> loongarch remaps them into vmalloc address space and sets page->virtual for
> page_address() to work.

Okay, so it's really not about the direct map in the traditional sense.

kfence_map_page_if_protected()
kfence_unmap_page_if_protected()

Maybe something like that? Anyhow, pick one and let's move forward :)

-- 
Cheers,

David

