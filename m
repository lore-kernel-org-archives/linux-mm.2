Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C92CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7506B0093; Mon,  5 Oct 2026 06:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A276B0095; Mon,  5 Oct 2026 06:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775BE6B0096; Mon,  5 Oct 2026 06:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1AF6B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:28:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8EC7A01DB
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:27:59 +0000 (UTC)
X-FDA: 85288197078.07.09B1BF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3C1D9140005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:27:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKGrAF3Y;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791196078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YV0ahyh+qROmkFhWhWDlwwYmMNujGqoOPIW1A6VxBOk=;
	b=hwEgL3gg01+H8HFFe6KWJyP6kjWN7cWzk/YaMhtBR7g0KM2uvj0mNKGFH4T3eyLBXLik3m
	11+rpSri6Z+keO7lGu84SmGn7j7uoIpv7ufDuBbPoxt+EY4pO/E9/TcIzF8hYWr/cLU9S5
	HtEQpa2o+6hK6hH72zALcs2Obbueu+g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKGrAF3Y;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791196078;
	b=whBi7GVCDPpfPyW4IthXA9LV2649ag059XZxMnBUx9+L2JVG629qw3BHjwNf+kRJKCOduZ
	xyYF5moCf+XeWCY9LLAHLcF8/5z45txN1h5GNB6DFRN1ibBv71xjaXmPVrUWDiWVHZUMFG
	4CpLaXnJugoniyU2rhEV5f+rRUyintc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA7AC6022E;
	Mon,  5 Oct 2026 10:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3291F000FF;
	Mon,  5 Oct 2026 10:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791196076;
	bh=YV0ahyh+qROmkFhWhWDlwwYmMNujGqoOPIW1A6VxBOk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oKGrAF3Y6UveLrA2UOY5wx0zRSLKy04JzXsiOxj3ysMaZPU993WGae1/63tiWDXuP
	 StuarUNmsSOtX8r+bhrwT7f76+/Ej4S0PuDqW48GA2hdZiKejogy7nZLg4/rIAkM1V
	 1mde+oIHX9VOk5yzlXz8e7Rjqv8uD5VER42XZoR5D5bJ6r+RvcrM1ZS01NXWIE75Ox
	 x4xyDy5KgbHYLxmsY6c3XTK1IFNOCxux1W7wISTv+yyuwofen4r+m/Cl84l102VPW5
	 RxvtZNU8JJR/pQEXXTPzJAZ85feEKmEQokKl3zjvM+7ePNjY+AbnDav77u3sKEo8AL
	 UcRX5TS64TU5w==
Message-ID: <ae9989b0-3797-4246-a2d2-985d7053d222@kernel.org>
Date: Mon, 5 Oct 2026 12:27:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix NULL pointer dereference in
 fixup_user_fault()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: neganhat@gmail.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261004125601.c06953a6f0660df9859b0c2a@linux-foundation.org>
 <20261005021957.5254-1-lance.yang@linux.dev>
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
In-Reply-To: <20261005021957.5254-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3C1D9140005
X-Stat-Signature: 5jq7ruy8eqddy43g374ah58bousuhgr9
X-Rspam-User: 
X-HE-Tag: 1791196078-818123
X-HE-Meta: U2FsdGVkX1/dsS2af7/gUQeoIJzZST9vAoxzDqFMm+6RA2aHtxUtMmRcXB41+27OE852z43c9V0VpLc9O4v17lrBXT5c2S9U+MJORWW5fyQ3rQbEJEel4aCVrQqTX0NVRJ4JcHBFT0KsYzzIkH7d86CUIY+m6Z65ynJtDyueyhFRf8agOhbA3mVJ39gd9Eom40XhBrltBsPRdW+TVZcoUNGGP4l2Ng1EQBmU6VYsMlTYaB33Pk5TZpqEhHKvVOkmX/Nc1HKMSVTskorRSE9iHz3DMDvc6nNWp+YoLimkA3eqUMzOBRfPAedE3/nuzKTgpKqulOTm1EjtFWNf4O27VQ6VhZEdgDWVaZf9p43G0UzX9WcZcifXdvmKjYs5gvRCtlM8iJm25pV2s7vBFrJ+xWnANfUjWaJVTsZ3iFAplfRO1ls00UAjtnTfrhhEF2a2vJvFWiQV+3ohGeYQzYITdDjUgyvu1t0kaDRCrlpcbMdXbe/izCQoJsJXgI47AiyeraUr1+W7oFzQ55flgKocf+miHrXkwkjiIyckaQSS563BVM3XBT9ov/F6PpTq5TJd9MVkeRVyVohoYkc8Dbw2+eFDVylY/0VJ73uIBtTYnDdRSqUhloXie9c/B/7Dka+KEfnbT7KkZCms00EmkZdIaWkEaM2DM+1olkFTYsUw0eq63FP/2nQwISzuZeXNhkTNLTnWAyx+mXGiqbWobgXUoX8AeNnc0lJyvxCNGMV4wlokbgORKMv4+xRFQLKvHmRSwsCUL69/j1SjYmZ4SONh8hy3cSPVt5urZu2S/ft71XvVEakhdzDI5SB7C4C/LuUt/iWIqTYqbVhrz+4XMGeAiJ3j5p9IsTBoUtfXaanaLV3U08rDcORiSSzwmfz1ht2xRlHrRGiIIrMVq5p09vQMDmXlsksuJObnzx2LnsU9SaAye8EC5kGl5iwGOJ74P+NNMTLuUvDUXy3eYwL1nwh
 LFb037Ys
 iqCzWOtMQ49mh/TVSFLIwCx51ZIQOSYLKdefP04lLLQYXSQBtc1ekRSMowKL5+qI7qCwfK47gkzvk99c06ClYvA1dt+nhDVDZ4W56OFoLa9DNDaHLnfvGt4Z8IatqNSvBZ/B43+JnyJPEzAsWEyvKN3PFV0HAm3wvdSkgIJiH8s+LKZTRLlpYVCE8PaiXtbU2/9GZdosUMLQeezAcbpKLmBaiyQ9odoBJUBGLRWAL00KIJiIpBKZT9p5+Dc9OSrB3W8bKW8G8CZkaMOqCMwob39n345e/5J4mSePuFvi6KuCwhr28Sq3QKW86R9aauEu6bUYNKz5WniQ0opY6l6lCLj2WPP7jonpdmCI5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/5/26 04:19, Lance Yang wrote:
> 
> On Sun, Oct 04, 2026 at 12:56:01PM -0700, Andrew Morton wrote:
>> On Sun,  4 Oct 2026 02:48:46 +0700 Nguyen Duy Nhat Anh <neganhat@gmail.com> wrote:
>>
>>> In fixup_user_fault(), the 'unlocked' parameter is checked for NULL
>>> early on, allowing callers to pass NULL if they do not track whether the
>>> mmap lock was dropped.
>>>
>>> However, if handle_mm_fault() returns VM_FAULT_COMPLETED, line 1597
>>> dereferences 'unlocked' directly (*unlocked = true) without checking
>>> if it is NULL. Callers like s390's pci_mmio.c pass NULL for 'unlocked',
>>> leading to a kernel NULL pointer dereference when VM_FAULT_COMPLETED
>>> occurs.
>>>
>>> Fix this by checking if 'unlocked' is non-NULL before assigning to it.
>>
>> This code is too subtle so you aren't the first to attempt to "fix" it.
>>
>> The key hint is in the kerneldoc:
>>
>> * @unlocked:	did we unlock the mmap_lock while retrying, maybe NULL if caller
>> *		does not allow retry. If NULL, the caller must guarantee
>> *		that fault_flags does not contain FAULT_FLAG_ALLOW_RETRY.
>>
>> Trace through the
>> FAULT_FLAG_ALLOW_RETRY/VM_FAULT_COMPLETED/VM_FAULT_RETRY logic
>> to confirm that the null deref is a cant-happen.
> 
> IIUC, that's indeed a can't-happen :)

https://lore.kernel.org/linux-mm/c44e5924-091f-43ed-8cff-34e87c3d9763@kernel.org/

People should stop trusting tool output and use their brain ;)

If you did mmap_read_lock() and wouldn't have a way to indicate that to the user
something would be seriously messed up.

-- 
Cheers,

David

