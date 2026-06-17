Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED9ECD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D15B6B008A; Wed, 17 Jun 2026 05:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3820E6B0093; Wed, 17 Jun 2026 05:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A296B0095; Wed, 17 Jun 2026 05:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF4096B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:42:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D895165904
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:42:50 +0000 (UTC)
X-FDA: 84888915300.12.D5C5A3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB19E140002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:42:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e00WLGFJ;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781689368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MM09kvmX/Dy87FUT0EyogMRDLec0+XBI8U1zURJrec8=;
	b=gQk1+FTWVCqjQZVNCIsHT4FMPf4V+gmZ1XGAzYGQUaLdi8LraBs5EUyHJE1a1IuU5F922L
	TeC3fsp4Y+00nYCmXjxtDNOX4d+ShaV8NSxT4OItNqCPqtFe0EoGD73JhaNdz43k1+86yK
	N/lX1vI+y/9RLan/HMGZpTeWngGyheQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e00WLGFJ;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781689368;
	b=zadCzoridGYpjfXZQ1kNft3VNj8riPQrZ7V8hjRbe6ZDc1nHU9+zhtiECv8sCUqTAInoVI
	Zu7AEayOVXjq1ME1wevBBhJZTZAldOf7it5gMKGI4PU36pNm5iIGX8GvAT6r6LHoO1o7ZQ
	Ih2WaCvYpFAVyMA67Y+Hy3tBjRF2ioA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCE41431F8;
	Wed, 17 Jun 2026 09:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360961F000E9;
	Wed, 17 Jun 2026 09:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781689367;
	bh=MM09kvmX/Dy87FUT0EyogMRDLec0+XBI8U1zURJrec8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e00WLGFJlnwL6SU8u5diDh8unAwZ6/h1/bvYyV++QY16qBZUTQxmnZFAemrs5+gJp
	 RXEUtVLdX3ob02F5tJXKXeRGp8XAou+qPomHFwhWsqTdyTmr7EuHG75bYKDRuPqPip
	 +lmbC3x+8Jgf83A1vD7ootg3sxoLIR1fcJOoF4Jpy2lYwZ0QJ7fM53tVEjHeKN9XPM
	 eXk7Xqypr/g++fkO6mLdR1I0KfRc21FRljosw56wGadXRb2bFlqEuSzTmRWten1BLn
	 Cmmtp0Sq28bRwp8vkgGCSwO9QkqZ0EM3FHjye74zSXEUglsBcevZNvD904lOr/sCkL
	 FTFh6FB+xlQ6A==
Message-ID: <dd66797a-6fc5-4c31-ac43-d767560f3029@kernel.org>
Date: Wed, 17 Jun 2026 11:42:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
To: Suren Baghdasaryan <surenb@google.com>, Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
References: <20260616190300.1509639-1-riel@surriel.com>
 <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
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
In-Reply-To: <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB19E140002
X-Stat-Signature: nk6t7gqu8xge5e69atdqmzzg495uhrit
X-Rspam-User: 
X-HE-Tag: 1781689368-641970
X-HE-Meta: U2FsdGVkX18tfA/JfbTbLj5lEE5ho0ZC5HkQ3pdIYlT6KGCkjE/qUrdLLClQzo10qQt+dX/cS2YGbiscYD1TK++w1c114LhmbAjb6QjHqwyLIaqd7K5oWsbgTeFP6+2+eaCHasI4If+muxZbPloAV8ScU5wSvTPiAxsKDSxMEiL7u6cCJqyacQ2aZUp7fwe9AFdxVgpQankXwZD9r/b9DL5Rv+Dg4DtJCASUsbh2fCngHOje7DlnHOfWipWcFku2AjJyTm/wQb6tpcTxrD177v40hfnvY4FBW7i5JKDJMCXbm+4LuZ7q5HpKWN7BPn+NiVDaUUIB+KSMNIgPObOYzNikRs1GvSD4g2sW6ailzhMGEJZYt7oNrTI5SCa+i5BJI3/9yN4Vaaz7nzG+gZIRdfFPwd5g8OyEsA2sWD8t3UpRTWr6YeMMAom1eDCXoETfxrEcgkjpFJwRGIV6t0S81D3VFrqzziVNs5YyaLns/lta88qCZi0NDtoGh9As6k/dHKshBi+GNg9GeKNH9SZH84lmSlhsbxPIi4uQ31Qde9nmYBTCfcSUZkW5nflMA59D5yCPAMvvmjZNWVbBL/mYlvIaJBaMxL2IIyFu7VcklkUcB/bog+wLluo7udxl+bjK25ziVWPxaEKYNk/hCj8hONoOXKZs4gCHkewmktd1uaaQSKczY5C3R7jIJp89Sg4W8PXpLgGRXxqvg87rbfS13pT8hYyj+aFQyMEJ4L1HZt2ToAN+YrOZLVcht2CfNuteijoh7m9P73EuZi4iao4E69JelFpZSUYLSjFIWX0YGVA23ygcWiBPA1RfzpRwlNXbMEDVunOF88VggfwR1PbGPNY0A7grBTVRwY7Lza/Nhpz4YL3aYsMqWKL7SlRfgZtRiCDp2Vvkkk6f5jp8LVwt1+mYuG8Avzous4RnmNwaaBNU5FUkXR49uezwEWlSAc7p86RP1WZXFBP6k+HwRTP
 nm4hWzKz
 exYAxk5kdh3zIvI9ostvB/ZoXxdvGkCNuV+t3pxkk07pSjXH09t33obmmNLw4J7J8R2xUePkWuXmox4dkB8dHuQPoTRvBKSWLGvRudg2uv8p4uECXZC0DbTrOVBg1nFNt8r7loYBMKL17sVMndr/P2XgUw5XJe2UIAbEn9WkhjDKXb82jsHfZxyBp4oIknPf9dPHIouzk3SyQhcUGjhuli7g5ch8eol6xz2g1/Zpjvg8jWo5dnLMf1SISkepBfeyi7xGBhXzC7CRfo8E/AES/Nv+ya9jhxHCRiYEEV4uu4ZJ3KJihlzu12pX8G5Y2VjKTq55qjRimJ4hYUXrz5gNw9BvAkze3zRKv8kXCjvqh/LIcjtZEbl0w0fStqiSsZLKbtvT+AqEcRDOMzAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 03:10, Suren Baghdasaryan wrote:
> On Tue, Jun 16, 2026 at 12:04 PM Rik van Riel <riel@surriel.com> wrote:
>>
>> Sometimes processes can get stuck with the mmap_lock held for
>> a long time. This slows down, and can even prevent system monitoring
>> tools from assessing and logging the situation, because they themselves
>> end up getting stuck on the mmap_lock.
>>
>> However, with the introduction of per-VMA locks, we can improve the
>> reliability of system monitoring, and generally speed up __access_remote_vm
>> under mmap_loc contention, by adding a fast path that does not require
>> the process-wide mmap_lock.
>>
>> This fast path is only compiled in and used when it is safe to do so,
>> meaning a kernel with per-VMA locks, RCU pgae table freeing, the VMA
>> is not hugetlbfs, iomap, pfnmap, etc...
>>
>> The code seems to work, but could still use some more cleaning up
>> and benchmarking.
> 
> Thanks for the patchset Rik!
> Previously when I looked into using per-VMA locks in
> access_remote_vm(), the biggest hurdle was get_user_pages_remote(),
> which required mmap_lock. Your implementation avoids altogether and
> keeps the code much simpler than what I expected.

But, wouldn't we, in general, also want to teach GUP to just work with per-VMA
locks?

-- 
Cheers,

David

