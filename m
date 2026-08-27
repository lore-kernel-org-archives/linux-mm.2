Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC1CC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D32476B0099; Thu, 27 Aug 2026 12:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09796B009B; Thu, 27 Aug 2026 12:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F2B6B009D; Thu, 27 Aug 2026 12:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96CF26B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:01:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1441D160496
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:01:51 +0000 (UTC)
X-FDA: 85147515222.14.F1BC283
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2DF6F40012
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:01:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkPaP01m;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787846509;
	b=AZtAmR58r9R0X4dULpezt+MHLW2SCm32a8YdkMXGijMgYbBplyQX2qMirXM3qAzr6GmOAO
	ZW5gYmTGql+NJbXUKnLGi34r7byi8XZajRhFDzvtlVewc1oXFU86y+qUKLwmp5Gs6nDXm9
	0CZDBFPlUmGcijBLL0YrrGCA3DNmO+k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkPaP01m;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787846509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVEc9cONeTRQMyk8TlG3ju57heJPzFf5Awx6TSVRadk=;
	b=gDcs+V8bNK43qmvt+KmfAVgRwLmXeVLg5IA4qNfzMbAGitUGs3PAe12tAOO+boLPtSdWUS
	bOJsVGAYoeO8Pj61Us1qI4NZ/YXhqeXOYlL2NbDtWiT9XUqJ+6kj22PZ4yCNAdyOWs3mYh
	FUhB0p/RVKxgoWRCBSCIg8zAGmG/blg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35BBB41316;
	Thu, 27 Aug 2026 16:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25661F000E9;
	Thu, 27 Aug 2026 16:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787846508;
	bh=FVEc9cONeTRQMyk8TlG3ju57heJPzFf5Awx6TSVRadk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EkPaP01mbHkLh6p7qcxofpb4QZGagA9Ann99xgNtY4Qy1oS1r8/aTYyN/Q9F/2KUc
	 Agp4+MYDYWxsofTrvwgKbg3gxkgn/Jh92+txiE68leNT3V4rIvksXtrNXMxPBMauZV
	 I4G0Ialf0yPF/9MBF5Py52CiWaOdLDyYzMeoCNG+KrsyQaAdiaoiPIUV+aw0T9bW9Q
	 LfsYviWvhmcB9bT1DDGOoVOr0bYY81tEmypIarMm65u1gk9RUJ6awwu8L4j7ppuZeg
	 pGwsckzLukkHBVFxo9w1Q/wlbku72Va+XTTi1+pSBvw/22bOeGjddSyBE3zFI+jzfb
	 JnrRUUgAefNOA==
Message-ID: <122d0350-f5e3-4615-b02e-e4e86792486a@kernel.org>
Date: Thu, 27 Aug 2026 18:01:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
To: Kiryl Shutsemau <kirill@shutemov.name>, kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
 <apBK55hfvYtGDpiB@thinkstation>
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
In-Reply-To: <apBK55hfvYtGDpiB@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2DF6F40012
X-Stat-Signature: tkrx8cptt694fm7kartchrjfypideqoj
X-HE-Tag: 1787846508-539851
X-HE-Meta: U2FsdGVkX1+kdrjbgeKgBNHj4fZAdPANeudhp2xV3lIT2uK4eoiSoQ4w5cYn9v8GR7++wfQu1fsOUiA7oAS7fbgLWWG0IUy3slxsu1GJ7quIUXfwIVyG0w6sxzu0RjimWbXn4Ee4PUrkMHoKaYOaDXjNIf3cQ310M2hbjNtE/gBRj5M3UFQc6q5fvCho47ic3uNHCeEF21bSwiGP4521aP24C3cZNmLLnFdkXX/biE0ozGM+NiotiKcRSYgvwKuNYMFfF96CYG4iFkIElrYxOIOL8SkmB6tbeDgK0h/59d2w+YofPL4kMg/l/5ZrY4qOZ2PPnowTcOgjt+j3QSaOtAVjG9KGS/pOAXeQer0tqBtBHiEJwcIyRzyn4IAx3GuNWI567ZSFUcI3uxSZpYxSrRttVsiJpwK6dlFIvtjH8xscNdfuBaN0DmBi5gycdvWronsGORGc0A3a8l5JDhdixdeQgDOk9CATgngMHgbbm9iPuN2jOlsmnX4iUfLdYK0ShqHuVcDjECVdQVFz1lpwA5vFAA62FNI7t91xhIShHdSqcmsRvAgLGsRLK9lBc9FQK1OrMz/mSkP02n3rKkUuzeK8ofIPEm3ssibdgJ8IrWVnSdLsZs0X/Dev0SMdMj1wMzlXzA7TW3KLvCIPZDCg26R4cLsIByU58ts7MBJyyPV9MX4XixTrKhAbbjPAjhlsOY+eczhmVX+hnBlF4gPhlEsdRmn7k5V3+J9WAqp4ncVIr0J/mAzvkDtxKKSigxGxS/UxwF4uBi7RwReh7wFClIrc3zBFgzzCHKsbQOkHCNrmr73jpt6JefD2UWzaGJaYzXmk4z2Csfq2rEmrbhl2i0hOmDJsSWKjiyTkqGDQ40e12vWSTqbRd77+9mQ+iL69DuvYdOXwGDABLmF8lKkGxU2s94DG1MUJbfUVn/BkJRL0Yx9Lg0NI8kVGVdzisZHHLRKMO92rOg6Zf99m2eg
 iCyT2LjI
 tyXZgXOHAUvBKB6KBAAAsie3HkALfPyPmgZgjd0RcGuwq8iaJyZum+E9zBT6T0J6dQrMfgepxQxtzcrCvAhmJD/LAHI4nzPVzjYYx47NjDVVBdumJE1yft/KWY46E4U5m+RVlo8PKCY3uOgNtokmdEQEWsOQophBGF/sZQPnZ0Z7GSRKphiSzLL7UFkJDMeNqV/paxwhQx5qz/L1jyZRRElv/Nkx1GjxnFyflySy8oV1BMF+0SDGxurHJK6cDqKDQcaWaYpr+G0VyREgdoR/ujLl/YfiNCgEYzn5Oq/TVhK1AJttNx+Y+fvXGHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 16:36, Kiryl Shutsemau wrote:
> On Fri, Aug 21, 2026 at 02:55:15AM +0800, Kairui Song via B4 Relay wrote:
>> @@ -3886,11 +3889,11 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>>  	 * TODO: this will also currently refuse folios without a mapping in the
>>  	 * swapcache (shmem or to-be-anon folios).
>>  	 */
>> -	if (!folio->mapping && !folio_test_anon(folio))
>> +	if (!folio->mapping && !is_anon)
> 
> Just noticed, !folio->mapping is always !is_anon as folio_test_anon() is
> encoded in folio->mapping.

Ack. folio_mapping() behaves differently in that sense. confusing :)

-- 
Cheers,

David

