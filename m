Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545E3EA4E07
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3196A6B008A; Mon,  2 Mar 2026 09:28:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F12A6B008C; Mon,  2 Mar 2026 09:28:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F41E6B0092; Mon,  2 Mar 2026 09:28:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 105226B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:28:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D6F31B5C2D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:28:23 +0000 (UTC)
X-FDA: 84501353286.30.41ACF3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id AE9F514000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:28:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+0g6yjn;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772461701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H25MjrcFYnqNOtIzpF4yT2ROxg8z3gYJIY7rHwkWz/o=;
	b=8KY9WDakOw/EhKuuowgb90fdVWGXElyiroihjfoKWa9pOTVg3vNDDsJU7V0ycoztVpESW/
	TdaVgl8ke4aG1T0AFhwwQmxMbxNqdWmHD49HRLlnqgsI3yzsQea+Esn1oMxu2jj7YiG7rI
	84F6XAzHcDUW19LKeoDxRexa3OewfMA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+0g6yjn;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772461701; a=rsa-sha256;
	cv=none;
	b=R/NDNhTpEMKi9ALnOmhPfYnhdNokLm9A0AnqYTRQFLI9I7PyiI4+4C2ULWmMVhR1N1+qU6
	kFJ1pFWNOqtW7ZEG9A/wdg7OiTsti9ncTRmRAvlreZ8k/r78HOUS/e2gjVeBeWg1FPBHN1
	5vF/ndFYWPc1AlfyVJ4tug+WEqnMIlw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A968944355;
	Mon,  2 Mar 2026 14:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E98C19423;
	Mon,  2 Mar 2026 14:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772461700;
	bh=NHChwr26MecOHxxoRdWaM4AmCzT0wwXCZr7gSsRU8c0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d+0g6yjnQCN4aYh+WOUT93XZp/DuyCrZCxG65S61sRopnERaQHTmssaV+0HlzK2QQ
	 PfLvTTJS2Ao0k8ZVxHfflUOHTWdTvao6ajK8n2zU0tjL9S+P4r6ZeGa6Ev32KzGDcg
	 B9ynwUmY+vWB1pb1vc9rhM/ntTlp3bUax1d0heIA1uhvjTTchr+8XRR3e+LgTdgTtZ
	 NGMB7msNIPRRIE2t1V8U3k2bycORDwl+Luo2H1OAkvbGau8eQcM6hqZc5EKdgljTf7
	 bMmWssD/fmrGgcp2zLZ2h1mcl/YaUbPSAW78re+Chm1TsHRhNfvkbYi/ETVqjttG1b
	 NzJEqWcLONsYw==
Message-ID: <64fa6a73-8952-4ee1-b7c3-8b0ebef3ea78@kernel.org>
Date: Mon, 2 Mar 2026 15:28:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix a folio_split() race condition with
 folio_try_get()
To: Lance Yang <lance.yang@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Bas van Dijk <bas@dfinity.org>, Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260228010614.2536430-1-ziy@nvidia.com>
 <d9e30bef-621f-444a-a1b0-510c50927d9b@linux.dev>
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
In-Reply-To: <d9e30bef-621f-444a-a1b0-510c50927d9b@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE9F514000F
X-Stat-Signature: g5c5oda8gd9xo7u3pikskq4ppfzzyx1s
X-Rspam-User: 
X-HE-Tag: 1772461701-228185
X-HE-Meta: U2FsdGVkX18teSQ9Epn49Ti+rg5tfk6cfSUHJuyl+JNo2QvGntR2hTdMSKiE7WwOA5O9U5Fp1d6FeW66b7dYwiSz2R7e9gP51QbCMQw9K6efH05ohQopfY6KOElipf39jsRXj6eY8DxdMgFgvBV79ryJMmDfZ2ei1fx5CLpW9QZvpq9cZZ5oXjQwkVtAa8TTQwFU739RAvMs+2S9+r9kcEErCfzOeMp6nLgMc/z6fUm7JyqoKgcrvot2GpUrc+GCF8P5gwR0xrkoLM//FY2lFI4e3dlZ29fpvHjBfAdDT6OaaF4YqtlptOQTNb2rjN+RTKbD4BM5cX1r5WAp3ghaFkSajsuMbL7IT/OjMEgZwE50w/gcnHkJuq5zGPsPFu+krDqmTlPkVTrhzuF9TqYaARnS+X8i9990SLB7duPL20EF/NknGe/qjZfAa13hmapK4cRpcvljk892rQaeA+8LBgY5UAiiGQmkgLTesN8Esae5fPRDt1zpMY7GKbJxVtOEKJtBvAi1VfBFyLl1vequcx7MPmgWhJjiJBenMEggvCLfLr14SHHs3aMxERbJTapezwizPcFuQeG8s+nJ7MVWJN1tuZmgMeQ6x9wERVJfA+6081cKk+D6KTpc36mKLx8aQtCNzOawZFZQeKNDbSL+bvHPO57Bdsvq2OX0zIFkpEIv5diAe7yAthM0llPIdhaIm9TN2hg5rZaBwxyS40iYezBFBQ5nk/RD37P3rDW5Ie6KGlQeDx6SEitKYLLSPcm1TEdXnOAzIHaTWryAqlcQ4jtF1ncmtvob5XWZKtvPgifDL4wM3GnKCkOAaIOhViAmAIjsOcPq3wQibqr4tN89oVrur8OFKK3eNcHQ7WsMT2dm4sdwUg/y7+PhvBZJk5n50FL9iHVGd1vic6D2LwgfKPD7ufaSmKExwiJIuiB5Vlhc0gAFGfiXTrkmxvNqKonpeqUreMzFzXHoaI0eJ2y
 4oEnXQuh
 GfLQVPi6WNmQN0Bd7I1Zl3/aaZIv59lqPpEt9UyZ1JmGD4fY+zu+dXHOZsYX3Yz+cWU/8QSsKv72npe2ZiGHX0jdXQ5k+d8BXem6r3CUvv7Gyx2Aw2qILwEUSr3D088ajw8qXUpUEIT3+ym+XgTPGMwlADQusiSVK2k0qt0AL6r2rknn2GasVfDX4CgvzayvRnrOzGKoARX791JJpG8Wa+8FgQRt2SIjwq4A9e3oTrWbRckbxD0sQsdxeZ8YjMIF37+7pRZ8sGjwUHZA9DZzxJE5Bx11Q4fhxnlibj7idpWla6jH2eW3fmJi5j/eZghi5Efxivvij8h2XplJntLF2ZbS3kHs+mEO+Xyvpz2HxPiMQ44Bx8KyDfngIjpqpfmDuaaTH9wcv2+wwmC7P3anSz1ygeITK+GMb0b43nNixkZ7pXrjqgOMJ+AvU6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/28/26 04:10, Lance Yang wrote:
> 
> 
> On 2026/2/28 09:06, Zi Yan wrote:
>> During a pagecache folio split, the values in the related xarray
>> should not
>> be changed from the original folio at xarray split time until all
>> after-split folios are well formed and stored in the xarray. Current use
>> of xas_try_split() in __split_unmapped_folio() lets some after-split
>> folios
>> show up at wrong indices in the xarray. When these misplaced after-split
>> folios are unfrozen, before correct folios are stored via
>> __xa_store(), and
>> grabbed by folio_try_get(), they are returned to userspace at wrong file
>> indices, causing data corruption.
>>
>> Fix it by using the original folio in xas_try_split() calls, so that
>> folio_try_get() can get the right after-split folios after the original
>> folio is unfrozen.
>>
>> Uniform split, split_huge_page*(), is not affected, since it uses
>> xas_split_alloc() and xas_split() only once and stores the original folio
>> in the xarray.
>>
>> Fixes below points to the commit introduces the code, but
>> folio_split() is
>> used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
>> truncate operation").
>>
>> Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used)
>> functions for folio_split()")
>> Reported-by: Bas van Dijk <bas@dfinity.org>
>> Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-
>> sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Cc: <stable@vger.kernel.org>
>> ---
> 
> Thanks for the fix!
> 
> I also made a C reproducer and tested this patch - the corruption
> disappeared.

Should we link that reproducer somehow from the patch description?

-- 
Cheers,

David

