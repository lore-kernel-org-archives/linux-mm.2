Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D64FE81BDE
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FC96B0005; Mon,  9 Feb 2026 11:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9956B0089; Mon,  9 Feb 2026 11:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612906B008A; Mon,  9 Feb 2026 11:20:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 534EC6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:20:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DC148A440
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:20:40 +0000 (UTC)
X-FDA: 84425431440.19.4D50861
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C2AA180010
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:20:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+NxrIrM;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770654038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8oQyJeAeS4QjpR8IUO8VU4QCthnqJw+IAvNL0Umy1w=;
	b=nOQUv0hQEy2wFdaOFN7rlG94mqPI+p/69EziKvYb/zkhm3BHfT+yAVGkh8mlLHql+znUsZ
	IP0Lktpf+AVRW89Ae0Kt56b7QHWrP6TO4+xTfzk3wpzodz6rF+SH37YMpnqnOLIo8wYgjE
	uwX+tW5j5kjCNw7ZEDI9O2Kz7g4fDoo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+NxrIrM;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770654038; a=rsa-sha256;
	cv=none;
	b=GF8bQh/dPpZAMSLW3yM4hcEam7s7ex3u78cBP0XZuYcd1H5o48cKBeJ41YFu1+hqIBm4e1
	mjh0JwHz+J0Osqatn9LWedokHpUUsUMRd7NUAoY0OaqbhCDirn8ZFmDjmePlKAPw8AaoSF
	lenLtCUsJQ1NzYlvOtgmLDsRrlGm/x0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7EB260131;
	Mon,  9 Feb 2026 16:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5E1C116C6;
	Mon,  9 Feb 2026 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770654037;
	bh=nrLNw+FxvZHojX8ryLVPAy3U5gCQbGmv9uX9Z6FB9EU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=N+NxrIrM7kH02l5iDsHLo+ECn6R/kHcPbqfB3y3/J473sQscuaCu38HiYOxwaehtS
	 gBAB+r+pW/ABoVOgdn41WKBSjqowY0Mlmf5bYxlSG4Cglc37eFaIByHTIt16NGCPAv
	 SXwXoSDXptTF2nd1Htk3tzC9XZUt1nfBVazrug/1S2uwcVMjOq2UQJxfIwIto/mWa+
	 f174nOxtpsWId1rVGD5uJk1djaIvWFhj0/PR7JkdiD9lraBwWh07UDvnjOAkyjH5h/
	 GeoOLYe8AfLMf4ywXuagSMh4uYIeDHTqNjWxN5x/9CDlD9b4g7fLHhvIRa+9+UP4eT
	 Hp6I+TqsjrAHw==
Message-ID: <22431471-b569-4ade-9881-387debada00b@kernel.org>
Date: Mon, 9 Feb 2026 17:20:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
 <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
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
In-Reply-To: <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yke36kqzfd79pa7dezxdtfdrdkrkim3i
X-Rspamd-Queue-Id: 6C2AA180010
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770654038-618282
X-HE-Meta: U2FsdGVkX1/bI8JnTeZOdqmfNpnatQ1VIcG9dwzmhGtk2Y0dUDKr5fmmSfMM2XbaIOfxpEgYGmjgxwvp5IyIbUtAJCyeoxkwaQ/F1EbM0Q6pbf5UbPboCmn0S9cQ60x+T5S3vIigjlBQ3jsAD2WXuLCOjjEI3l1sEtekoLdvpuy4DuVB1nwtJ4Z5fhUzb4+s6tS7EYnXd4EnYg7m2+PC4BVD7BYrJXh3xfPaAvUgbWZk8W/7v5KQ1qI8MXuPas9UYwLGVvV5PBhvns1wcdCZoipJKJ3SAzWbaio0wWy0k1Do2jI8YDJvROfqx5UQNL1WYIxfQzlkcrf8pPNuANAL6VE5OEQMfzLZ72vc1yh56FUrM/IdC8G0PEfjUs1S0EsHgfcjD/DvJ7G1QLNIQT+WaSr7Oj16A+9wnyFDBnKdeq20G1Dxql+t7g0F6WxNkM2f1ZgjUEMRfx6t17OV6qR3pr/D4elw05BYPEeRAe0R9OPMgMpll7IYVAwTcb4lJeSnzaR0yy4RxzqETiK9R6hkl+uNC6sTlgQ5z1IMqcxBNLdb0jB+47C1uQWwX64xVFTIkuFepXpMrq+d0FVmmK+7hlDzRb3srMf/3ebIy5fB7DGxZiQaD1qsVClOY+saRMywo71M+f6o5VS/PQIgZQqMYFpBavYMDE6x42cBB0lNZKsFdSxbMc3b+hof8DpON4Y2/5JoqebgieyichB1AVbU3fFpaZj9tHIl+Ii5TphNOvX67DrkRYPuyd7LdZRItM5ghqpzg9o2uIaasa1Icl1t8Q4pqkkOPfcKCZd/+FxYaqI/VzcUkrRfrQZPrORMock/L1Z1FJbTwggocB4O32yNCtKzZF8WawcjYY83dZoe+iycAN3aW4G360gZwcI/91OuGtBFHOxeKQaLEu9Wl03DQNDFFvl5zUqsLR3Mkr4n85U6Dxw7fjY8d0phSYql38p6qWj2NJf8e7smMvxbIv1
 CEJyu9eX
 KfJiwvNMwxrxffu0129LUf4yUM7wcFS5GLK9OfKDV3+iMY5MtfftZaw+qVa5CfTA/w1Yc5QnK4VTkYkk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 17:16, David Hildenbrand (Arm) wrote:
>>> I recall that freeing pages with page->private set was allowed. Although
>>> I once wondered whether we should actually change that.
>>
>> But if that is allowed, we can end up with tail page's private non zero,
>> because that free page can merge with a lower PFN buddy and its ->private
>> is not reset. See __free_one_page().
> 
> Right. Or someone could use page->private on tail pages and free non- 
> zero ->private that way.
> 
> [...]
> 
>>
>> For the issue reported by Mikhail[2], the page comes from vmalloc(), 
>> so it will not be split.
>> For other cases, a page/folio needs to be compound to be splittable 
>> and prep_compound_tail()
>> sets all tail page's private to 0. So that check is not that useful.
> 
> Thanks.
> 
>>
>> And the issue we are handling here is non compound high order page 
>> allocation. No one is
>> clearing ->private for all pages right now.
> 
> Right.
> 
>>
>> OK, I think we want to decide whether it is OK to have a page with set 
>> ->private at
>> page free time.
> 
> Right. And whether it is okay to have any tail->private be non-zero.
> 
>> If no, we can get this patch in and add a VM_WARN_ON_ONCE(page->private)
>> to catch all violators. If yes, we can use Mikhail's original patch, 
>> zeroing ->private
>> in split_page() and add a comment on ->private:
>>
>> 1. for compound page allocation, prep_compound_tail() is responsible 
>> for resetting ->private;
>> 2. for non compound high order page allocation, split_page() is 
>> responsible for resetting ->private.
> 
> Ideally, I guess, we would minimize the clearing of the ->private fields.
> 
> If we could guarantee that *any* pages in the buddy have ->private 
> clear, maybe
> prep_compound_tail() could stop clearing it (and check instead).
> 
> So similar to what Vlasta said, maybe we want to (not check but actually 
> clear):
> 
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e4104973e22f..4960a36145fe 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1410,6 +1410,7 @@ __always_inline bool free_pages_prepare(struct 
> page *page,
>                                  }
>                          }
>                          (page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +                       set_page_private(page + i, 0);
>                  }
>          }

Thinking again, maybe it is indeed better to rework the code to not 
allow freeing pages with ->private on any page. Then, we only have to 
zero it out where we actually used it and could check here that all
->private is 0.

I guess that's a bit more work, and any temporary fix would likely just do.

-- 
Cheers,

David

