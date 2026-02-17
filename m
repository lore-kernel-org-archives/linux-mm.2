Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC14E9A03B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE126B0089; Tue, 17 Feb 2026 16:04:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BBF6B008A; Tue, 17 Feb 2026 16:04:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078A16B008C; Tue, 17 Feb 2026 16:04:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E9F9E6B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:04:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95D641B45E9
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:04:44 +0000 (UTC)
X-FDA: 84455177688.18.C0712BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A16AE40002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:04:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N39gBlZp;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771362282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXP9Cd+6vi6yUZNRPpTobHBeWoNCjtANA+MdXi1cdiY=;
	b=XJeJP52kE8DPLHaRaTQfwwCLXTT/QQLggiBlym5exf7Z9ZKRoxXbxZ1KYakGmg+YjGqioa
	/35raZsNqArPWj3FoCncxI8564gnKJR77johDeamIxbT56sr1k6laN5dLCyMgWuXlXASn5
	yDoTaeMeHgAFMUcZXzJjFkROEq5mMJo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N39gBlZp;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771362282; a=rsa-sha256;
	cv=none;
	b=HwmPrBc7aRdJ4alnxUniw12Bf0bD/qTLnzHWS+x6WNI2APMrTWLItvz06hdQpSgHWgJNAI
	BWT8ixbwhgW0xchYxC8oiEBDQHoYAF0LpK36oTSG8O/hsNMStDll0By3EeAt1nXxMOjgGP
	1uf4YnmY/q9s9HS68Inc/B9wMM0Q384=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A206542A22;
	Tue, 17 Feb 2026 21:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD8AC4CEF7;
	Tue, 17 Feb 2026 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771362281;
	bh=0IGrsALVOasfOEjCAr9RVEVjJsnB1TJkFz2czaNIFZk=;
	h=Date:From:To:References:Cc:Subject:In-Reply-To:From;
	b=N39gBlZp8G7QwzHgp2lBy7tB/3hXBuKoUC9oUniAtB/hq9DOo37ureWaHJgBwe/on
	 jzOYx24Wr6hHs8j7ex5wJeb4XgZwBy7hLH79GJcCcPi6My8Tjvl1UeOlbFZ+fa0kG2
	 d6xjxGG1iAaHxURXpH3qaKKzTlA51C+mfFbM3DXReaxOTTZK7M60X7QJPGRppLaSmh
	 BS9Dz+oMRjWoGSk4Lv5tEAAt2vOf6MUBTOwMRK727nZhAGVC5gNfLESJBb5EieYSsG
	 kMWXONb1Gnz6IIP75Kq+FLJ+xNvTCa7mOU94RAwMMTc8v5kdxWY7svtIz1JV2WukIS
	 UI6GwYMMRv4VQ==
Message-ID: <fe6afcc3-7539-4650-863b-04d971e89cfb@kernel.org>
Date: Tue, 17 Feb 2026 22:04:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: lsf-pc@lists.linux-foundation.org
References: <c3bb0140-942d-49d2-bdc3-210b55435356@kernel.org>
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
Cc: linux-mm@kvack.org
Subject: [LSF/MM/BPF TOPIC] Towards removing CONFIG_PAGE_MAPCOUNT
In-Reply-To: <c3bb0140-942d-49d2-bdc3-210b55435356@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A16AE40002
X-Rspamd-Server: rspam02
X-Stat-Signature: wfehrq8e9gt9rsc8uxe6nycjihicfbni
X-HE-Tag: 1771362282-102186
X-HE-Meta: U2FsdGVkX1/mfN+d0yW5IEGd7C+mRgDq5qYhTRsANeamE+RHiIUBSe2T5JL5eaYXGioYODeiOqaesfr+sS862KcfadREw6kbGUFU104UXUIgZmlplpdnBBmEqMM+uWfNP7Eakk0GBqu/0dMQ1sC8QGgy23V+A5aT9BSDHcS9hryd4Ac8CZqLxzXe89dI8+f0DOhAC/Z1Dd5ymTjgZLh5mi9a8HnngflobPo5jVOEzl0ihqGlebXTJNR+mM789D152xzR5tObuLRvwiVHHEhhvGmeavsuOMCLobYUFD9OMI2bK/ieQX/GFsGKNO50nd5rFD110zOR9WyCY6A4Gl3CF40z6l5lOeHcULESaIB4cyPL4lVQpE+omAZQg9EShjWDezChgVVgBAxuc2PH+Ic0cqN7QTmEM6Uk2dec9zR58gVOe9MuCd2dQEcxnrlQuhr6aA6bilqTph6VU/DR80dVPzEkY7KIsrzjfTUHQliGTRJCpmEez6r3EPrA9oWtEAEx7MmyuPUQ0BFPeqq+reLv3tDTNtm37GpyCVzZ425fDtxbV2LkFtqYwhr2RqOGhNaWe1gk3r6PsIpUat4EhCS1DSGi9BeiBn4bw1k/296Kli6jRHFQmf8QE4iCy7WaAUmNIGpXhY0ynQsnhPqZel/8d4dpyUoYxuq1UVNuPpeE1Z1fgP2RHf581L0USSZ32dxpcl6UxcEL0MieyWObd59kv/iJ8VINRk0TG745UpVwv82qREWHeUpWdrfDL0hIcwJHwUSJtRJUwLyI6POVQ7o7AUZ/+/xPoQqMoim/4wbKVocoDPaeqaoCS2i3uLOOiZ41ycqXNyxWqOnnDTyueIUtosFeTcvP40taNO1OJRep7hbmnFtg1I9frDjnT1vYhU3zhGN5KtMlav539/Bwu/z8GXcKwQWVzm0YEGWUAJt/+AQA/zXigLMvDR3joIpDiAIYkwi7CVTwi+sjHpMIw0K
 V0tOkEVD
 iTrGeqmNUeDs1DAd9578LbVdsrVcXosyR556/g9LZjwU0IUOqwEHu6Lb0CM3ItiEqs1YwftCe1jF8QDCpTCp8jtfptxq5nMhtXNL/PfQQfHCN21VEWkhOcVoUVqrhyvDk0mMeojZnbHvePWm7A8IbI64igC45QNzlGMhM1Tij/ZIwLUJlPqX/MbF7fHNF8xiWMHvNDLYyN9wSfZ4qEAquBe9hTzwruyC4Vp0FZlprZLlaqaPkslZab9NpueRVmbdb4So8b/ytQRqx6Vvh9VhMGnSLNegRwi6iomXjWL/oIKrOhMiYCvRlKRTl9RP0Oyza7bIVUq7AuIprB679SsVoOjSxtRoc2jOhPPVgCFAk1YylNPs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

although I like mapcounts very much, I'd rather prefer to not have 
mapcount work on my todo list.

We now have CONFIG_NO_PAGE_MAPCOUNT in the kernel that doesn't touch any 
mapcount values of tail pages, which is great. But we still have 
CONFIG_PAGE_MAPCOUNT around, being used as default.


To make my dream come true, some things I have in mind are still 
pending. In particular, I want to:

(a) Support mapping of folios > PMD through PMDs.

(b) Get rid of CONFIG_PAGE_MAPCOUNT to stop messing with
     page->_mapcount on tail pages and to cleanup the rmap code.

(c) Better detect partially-mapped anon folios with
     CONFIG_NO_PAGE_MAPCOUNT.

+ some other small things.


I discussed some of these challenges at LSF/MM 2024 [1], before we had 
CONFIG_NO_PAGE_MAPCOUNT. No we have it and we can discuss the next steps.


Sorting out (a) is fairly easy once we removed CONFIG_PAGE_MAPCOUNT: 
we'll primarily have to split folio->_entire_mapcount into 
folio->_pmd_mapcount and folio->_pud_mapcount.

Sorting out (b) requires switching to CONFIG_NO_PAGE_MAPCOUNT first, 
which will imply some imprecision with large folios to:

(1) Process memory stats: Pss + Uss accounting like "Pss" and "Shared_"
     vs "Private_" in /proc/$PID/smaps and /proc/$PID/smaps_rollup

(2) PM_MMAP_EXCLUSIVE flag in /proc/$PID/pagemap

(3) System memory stats: "mapped" memory like "AnonPages", "Mapped"
     and "Shmem" in /proc/meminfo

And some other smaller things. While I think that all changes here 
should be fine, I want to be a bit careful and have a discussion on how 
to tackle it without realizing in a couple of releases that some use 
cases still require CONFIG_PAGE_MAPCOUNT.

Sorting out (c) is a harder nut to crack, and I wonder to which degree 
we care and whether I am being too careful. I have some ideas that I 
want to discuss. One idea is to just remove the deferred split lists and 
let memory reclaim deal with that: but that one might be discussed in 
another session I'll propose around the deferred split lists.


[1] https://lwn.net/Articles/1013649/

-- 
Cheers,

David

