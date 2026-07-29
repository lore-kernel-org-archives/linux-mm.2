Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB59C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ABAA6B00AD; Wed, 29 Jul 2026 09:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789DE6B00AE; Wed, 29 Jul 2026 09:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A696B00AF; Wed, 29 Jul 2026 09:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0CB6B00AD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:59:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6C12A1817
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:09:19 +0000 (UTC)
X-FDA: 85041240438.11.5F76989
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 170FE100005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:09:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kHm4g95i;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785316158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Uy0pOrdkhzK0M9CY3hsMn6y+kM1Fs/laTbpwbDQnRs=;
	b=GYsfpoWEcCpwetfplLVcaNqCL4pMldgq3qluw1aHgalW5YzRnvl1XJHNgi543MMz9S98SN
	dX5IZEtXq19HezrUJ/mG87ZZ0woY79iLG7DMnGaja/l3CIUzVXMp4CLucI+CTskEUkMxqU
	ppsviUQo5oTJEyhzqG2u8J/S2aLvaLs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kHm4g95i;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785316158;
	b=xLPplNLDJgnByf5we1b2TO2rOCEofFoZbkz1yE2tthYhIJ6EBfnMkyqRvYCEKkB9iEfly2
	2g9cvqDnJVZGT2J9+7wIdUyZ66Pl9EQpFx3KzKMKcT7SZk9tRdUKa/SUn1VbrOlJXSq1H0
	cO3ezsNaFXgp5uDPxLzUmMgPSfZBhYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43EDC41608;
	Wed, 29 Jul 2026 09:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342751F00A3A;
	Wed, 29 Jul 2026 09:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785316157;
	bh=8Uy0pOrdkhzK0M9CY3hsMn6y+kM1Fs/laTbpwbDQnRs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kHm4g95iXPj0+7CcbEndKo5Cmwr0OJ4j8dH9O+xkrjEsshiEjbEF9lfFNlqTqTLK8
	 ZPukWNmo5L/titQ44aNFLsDHdugoMbfyiWwVQvbm7L3AXaehg6CzKR45l6O5kvMHNj
	 QdycLwkgJYCYjUH68UpYstuIw79gKZx6fuUyOPlEnzjHXD5jjccy1ySk2+tQ+FV8fr
	 XXrRmwLIMWDRZcoGzN9/nSG799gjR5YQzgzcNOc8qcDp/eNNsW2n3RMvNi/kRgIOwZ
	 XLGCpa/eAupHceEzz78l0vOxYomQnRlA33wCJWjjFEtXNp8zBfxXwckUq+rjsrxHzE
	 gKP+5boihabJA==
Message-ID: <d0d62d7d-8701-4692-89b9-84dff71a7cf0@kernel.org>
Date: Wed, 29 Jul 2026 11:09:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
 <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
 <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
 <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
 <amh1nZVVaaZSGD3M@gmail.com>
 <20260728122016.30752d36c3b3c3af231efa9d@linux-foundation.org>
 <44f81bea-d64a-4f73-8665-46652a928c83@kernel.org>
 <amkn21ftNme48Vbl@gmail.com>
 <f83d5b26-b369-489b-a305-1eb5ec6fccfb@kernel.org>
 <amm72Bu9qmWLI-9b@gmail.com>
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
In-Reply-To: <amm72Bu9qmWLI-9b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 170FE100005
X-Stat-Signature: abkihnhjqg4f6arp99hup7xanequp73p
X-HE-Tag: 1785316157-680779
X-HE-Meta: U2FsdGVkX1/on4pdYWgUSDrioxLbjPiljv55CoFIA0hJco2x3x5mtk3rlQ4TtxQ2yuZlmK5LqS6y7CbVkKpTquT0w+M2FFqfBRASxkDyAiO938HIlcQPUU/rDwJFQpFiKCycKCz8jPDQNyUHcN+YkBd0zo9NIb8MuPnLo2yGqp2mJ5/LbwO0TIFKrHCI3IA/8Ah6vou5GmfXsRhZHx5tnstpu/vrVGWhb7DFkH74LUcXDfzVf9ABuUPKI5DG6l6KARPMj6ehAKFUdXM9liikKbl0MMNilCw3YOrCq6KztZ9Q9f5HmUuACNjeduvWjwdEMijVslncEQrpAPTETotdcbEs9+vtvIPWrPri81oXpKY9+u3fWaDUhz1g4f+HV1edJg3WcQcQydmW7bMU/gQ9lbfgVgtvoMc7i1EHQYi3SnuYN7F6ENOKftWJulW+Lx5GU+qPs1ZilNoD5zz6VyOjbzGnEAxT6ujjQxTTiZPi0KpukWnknS8b/C9SChl+qwzMrON3Jv8u1zUXwoxn+Kadr60NVTMwdtihJPv5TSXYe4dGPJOd1ZEUl0v1qDKFMlrbEXSO8KEQ/J83qvPQeRIeytFV3rH0bS2Gm6ub+dE6OvFWeg4nCZyZtZ/caiEQlEEbWz1SxgpZ2c3pPxfuspPftKjXZ6+OQvIMkQNddXssJ3pafhlMCTyc/p0wUmZxd/Vem+uDX2I3izAI844XA8tlhqd5kduTRUnKy7HNnF2u4kSnB8NugBAjr3Q9OhpTCpCY5WUUnwCCePP81nr0pS/TxGNTkzMiFYgyPM3mIBESlSJi5lYrTBY0WFbF2ITpah84XWO95SnAGS2RrDVfIlfxYH298e4kc7QLeuIuDpDUITkXkpHAzcD1GN3DcEm+NTzR7QGuAEp8LhRim/tjDMYSxPlh4QyT/QGM/wCSe/96QcV31MPKk3znslm948EWQ5/8EI98nzfX35g1LMBcnJz
 x7+fxmDP
 qxtscpvTeXIr2SHA45riw1QJ7MxTkTWk8wYtLETw3G4Hf1Xmu2i94lF5feADX4I6/kJlVqU7jULgGs2NFSC/uyXCPKvqm8nwGUFfP8m2cP1i4XRB6BMOmNFUypy/HWJKqQpERit+TAJ/uDDQ53h73gNBmAvS+YbrNZYU4g0RnK9L9WBpKptvXieoqppPuR9inVHI+YPfqqn955aVwY1rZ+6q5eYzbLam2V2zriRDRGyI82KPnqkExPSg50ZkT79kyqWr71S5cGQDOm1XWQNLotvkdGG5Du5jfdlHrhfVFQOAPkmUuoYCLkyNqdzgi0V96zja0pwEjArfeiJ8kCw04TFPCYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 10:53, Breno Leitao wrote:
> On Wed, Jul 29, 2026 at 09:25:16AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/29/26 00:07, Breno Leitao wrote:
>>> I have a draft of the selftest in C already and I will give it more bake
>>> time, and I will submit it until EOW.
>>
>> IMHO there is no need to rush this test here, we could merge it after the main work.
>>
>> We neglected our selftests quite a bit in the past, and that is biting us now.
>>
>> That's why I push back hard now (sorry) against stuff that is different than the
>> rest and not easy to maintain.
>>
>> I know, hwpoison-panic is a destructive test, but I really don't think we should
>> just merge mostly unreviewed bash tests that will just bitrot.
>>
>> Which makes me wonder now: should this actually be a selftest? It's nothing one
>> would just want to run in a CI. It will crash your machine.
>>
>> Maybe this should just be a tool in tools/mm? I really think so. So having a
>> nice C-level hwpoison-panic.c in tools/mm might be the way to go.
> 
> Agreed. In v6 [0] I actually removed the selftest entirely, since the value
> wasn't clear and it seemed like an ugly duckling.
> 
> It seems tools/mm would be a good fit, and make a better home for this
> type of "test".
> 
> Given more changes coming in memory failure (at least from my side
> [1][2]), I think it would be a good idea to create a subdirectory
> (tools/mm/memory-failure) and keep these semi-destructive tools in there. Is
> this the right direction?

Makes sense to me.

> 
>> So let's rather make this test well maintainable and have it properly reviewed
>> than rushing something suboptimal.
> 
> Sounds good. I'll move this to tools/mm and resubmit. Given Andrew has
> removed the selftest from mm-unstable while keeping the rest of the
> series (which is fully reviewed and frictionless), so I'll focus on the
> test tool now and send it separately.

Avoid bash scripts, please :)

-- 
Cheers,

David

