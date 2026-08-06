Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6410C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB12F6B0095; Thu,  6 Aug 2026 09:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87DE6B0096; Thu,  6 Aug 2026 09:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E146B0098; Thu,  6 Aug 2026 09:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A61526B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:59:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44DFFA250C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:59:58 +0000 (UTC)
X-FDA: 85071003276.08.CC1C088
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 80FE2180005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:59:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4xWYZCq;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786024796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sw8U9YfDFLEcwjMIF2sCsT+Tw/SwYWWnQdQB9Vxn/M=;
	b=N66B2PEiDFTv/mn58aEmM4dxSM/3L/oQ6QznHJGLW+g+g4bSk/zFT1d6t9Hd/XzFJrh+V/
	mtymoI+n0U+Yp/zV2rR6ayTWnf+qBTE3KHjBrE5vG6XQC6SgWmWK+ep7rU8VTNuqkI3LN0
	YVavGD+vC7N2Yw2ScSkI9JuTNFiGxoY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786024796;
	b=HGXbKs6oE9K0ELlSvECmGzyPHCGwo3zF7F5cIo0CzxMEYq7zq71jNA2Py+8Qb9umECQpGp
	NQtfbNdAIvhjz0BZP9y/9AcKZkwG0es6hZK5Gzq8PIj8eNlWh6CyYFP1qxidtKhuPb9DeY
	Xt0tyvRxubUnPIwaE6BQBOfyuUJMq2c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4xWYZCq;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10B9D60A9D;
	Thu,  6 Aug 2026 13:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B30A1F00A3E;
	Thu,  6 Aug 2026 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786024795;
	bh=4sw8U9YfDFLEcwjMIF2sCsT+Tw/SwYWWnQdQB9Vxn/M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O4xWYZCqQddxHiiTdAB6D2+Uhe5VooRnXLEXY8fQNGq+IWlmg1SXKapBr8RFWNjbq
	 CGmk3rZ0zZ9IqhNz6lWu/8QqOhuDaL3gRIfmMJQGhQvedily2IXBPHPvTAUrCoeYg9
	 9yrRoRpLraeXgyxlMAC+V0nWEA9qMQv2EwbzBcXuOilD3kdNaRbuNXgV6yLO7k/uaR
	 R/d2Oy//qDgGpvyvvk3zaj/+K/tK3SQ7oe46fs4jgFYW9M7Gp4qJHXdbnabIHV2V8Q
	 Lnf7PksBGss5j9wgPHCSkx05G9shkhoDPmsddc+2tlByQAs+TbZkLgMH3S2WTBTYWm
	 KOdVFQugojJaQ==
Message-ID: <2f1a505a-3568-47c7-8b6e-1fc8f02fb112@kernel.org>
Date: Thu, 6 Aug 2026 15:59:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 4/4] mm/shmem: split large folios only on -E2BIG
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org,
 youngjun.park@lge.com, baolin.wang@linux.alibaba.com, hughd@google.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-5-xueyuan.chen21@gmail.com>
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
In-Reply-To: <20260730122304.2496440-5-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 80FE2180005
X-Stat-Signature: w65mus4yjna89hdy9ijn3mwja4gjg7dx
X-Rspam-User: 
X-HE-Tag: 1786024796-912355
X-HE-Meta: U2FsdGVkX18tB4DcQjXyLS8HVerLc1ZHHzvXzI6IFjNVcPY40zZfiidGNLEsw4adfJEI19WCF+Ckj/H+J2oFcLhVSJkAhKEJ4Inq5bRv8iEMtKUOiUZ5opZ4vucrpL1eyaWqr1IcckxBd8xEa+2LRUlECGm0n/1y+1lrEcNPi972BK4eb61nmksefRE3Is0syuD5sexkGOmc4/7fWI44eMJU1psCAzMeGh7UP5Nhajjq0QjJOBUS+XbSR72ass4kKHJh3azbDMdMOG3ToqF7wKoyLr5+lfY8vDvWf6baKkdpbrFJaSOmFh1CciaFh8HMDxUVeN4QipUXp2H31n/8mAi23I8tmGOEb/bQD/QMXQWJwrgZW72H4n9sGsGVJ2RjqqpgZ4rSWj95kgRxPyblIfbJgZzb97hLKT5fweTkiSoUoWMB0aBR+IwLcqaxMPbBRB8maq9FIIB0oydiwi5CqnpvwM+/sENFeRx2vVPbvF9aHEsWvx/8BfErzFLbZaea8TFKpCnGh5OxNfDxdCS85lyu+yIEL8M2Zhu/mneeNCU+u0kZv4moqIO+2xSLw11ilTVl+KNQT+kGzMZAhjV+Zwbk2Tsc2UNRnFd9rRnmfLPzbXralP9aq1ZNFOjUfzq1UbLJ+eHGSzx6miTWYrHYHWIAm9zGHYrzmXnY9a/Ndnt/pkua/YxaM6Ml5Oka+BP4EyY0AwxIxaSbovsR2a0AIWmyqffDaTpqicWVwk2A3I6nN1gpzt0kxbJBvJyBhbW7UInIP1cuH0o8YX0EgVdbONZFEpFZBdlUsh/HCrBLBju/sTCUZWTQA9kz95r1A4dcunpJpwp6tPP4LAXW5qJ+d2Yuw+T9bjbTmLtiocKW/RzksVBeXUip6PnpQ7A985z3o0CW6JIGGBsk3ojoK3zsi0hHyWSGJCBYFaszQiuVIxVkSqMPp6tvW3C+5YLfhdhNqGe42mECLr6xJ/O5LFV
 SfVxMJVH
 11KOU7DaavLsNd2dvpWSS/Jz8BLUNaZ3AkEYGxecVJrmsd54vGg3v8E8CQNDdJj8/r9vxqYDchdtkjYk6c/Bxb9ztK5rA5toV53moBkjhX5oRsqWDQJEZAoFRwALeFELAI65y4SsOU48lkBpLbV+RttaJ8vBc22IeGg/5d4OxbgSw2eNNuanH4q3XZ+Xcrhmg2i61mQmyU3OuJzF5OZAoJmnKyQuYB+yBe/Eu2SlANoAd61PSBqLKNo0o5Bu+XMi6N1EApS2OJyLKp7yg2p3PQsECHK4u783a6NfJLW4v7bvpv6fkkEkhHFvXfPnAWeR/GdKTRYAIuoMvXcF5SIyIOCzDmTkjWoGECvhAF2mduDvbLsEIlXu50SWVUoPsS7Y41WQstOTf9sHjsD+3V/ecaX47pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 14:23, Xueyuan Chen wrote:
> shmem_writeout() currently splits a large folio on every
> folio_alloc_swap() failure. With the refined return-value contract, only
> -E2BIG indicates that splitting might allow smaller folios to be swapped
> out.
> 
> Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
> redirty and reactivate the folio as before.
> 
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

