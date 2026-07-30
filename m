Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B00C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0206B009F; Thu, 30 Jul 2026 09:57:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60FA6B00A0; Thu, 30 Jul 2026 09:57:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D7B6B00A2; Thu, 30 Jul 2026 09:57:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B06406B009F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:57:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46A13120177
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:57:29 +0000 (UTC)
X-FDA: 85045595418.19.647DC42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6FBABC0012
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:57:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XxA18yci;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785419847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8ceSBqux0H7VIJwsDpuwa3ukdal2lQ5X0wxbf29WX8=;
	b=LeEWGq7A2v6efx0uHp6j+qcnbUI6xSXc9boNbbgS9TtNeAfzZKIzZ9VYlMyoyj1vkqqULp
	defHELXV+Ldhudr5wGKW1pbGpwlvEK/LsmiSls9oRz6N0wvaXbboDhJxcYifkRBugwE+47
	rpzYmiove74fTXpn/+siqfS8bBLMWjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785419847;
	b=Pl2MxF8LO8Kc7yWCXrZ4J496cewShFOPHyw76r/ZIjvPkYhshuW4Ex0i/eP2gpZKsGZWWv
	NqcOiZ1qfl3ux0DXBHQUEQ1ZmwHMMKAkC7YIJm7lNYPJ6Ewg4XndCIXzQYYSQbwKQW1CSF
	Ovi43A5qDPSVbPerW/NBT1pyM6RkIiA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XxA18yci;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98F0E40582;
	Thu, 30 Jul 2026 13:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351851F00A3A;
	Thu, 30 Jul 2026 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785419846;
	bh=w8ceSBqux0H7VIJwsDpuwa3ukdal2lQ5X0wxbf29WX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XxA18yciqUYS1WA6zjNMhFTANc8TD7U2p5JCl8KmQh6/EIsr4P7X54DPuoQ5XpO4M
	 KMfq5fUvoRwuWLQvplt/9mBCE4qbtKHpNDxXKEWEZACTRvasuo3FrfEqDxMpB305pg
	 tOyPokjkH9oejHw1SCe3bhp/rJfy+n0SDR/ZR35pda/EStaLoSsxUdwR6lQ7YAVR45
	 ixSyZR7Jz+juvrKGmL3If5t7wPdjd9BlrL6QjBIx0RCA5wcEepdNQP/QGQibX6dR+M
	 3v50eCjP4YM3J59av9blCRlrNm5z5gN0FQFI4Df9Sh2FijbydewCAq8fBsfkn3ViDJ
	 4dVmSCox7U4QQ==
Message-ID: <d4f87684-7727-4c74-95e9-159196fbb16c@kernel.org>
Date: Thu, 30 Jul 2026 15:57:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlb: Use invalidate_lock instead of fault_mutex
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
References: <20260730131431.3613545-1-willy@infradead.org>
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
In-Reply-To: <20260730131431.3613545-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FBABC0012
X-Stat-Signature: j1ibszgig7t4uibex4j1xzmas3qagzxi
X-HE-Tag: 1785419847-839341
X-HE-Meta: U2FsdGVkX1/S2C2e7CbElWxY0DcImkYvlY5xDli8tSpUTEiu5KTo1zaFpjQjNs4Wk0AwtALNVUa9iKsQmMu7RiQ9s0n9LMQa67ffxc0F7ny4MW+36gn5b6VfVB/BJ6lnFuug5SGbmljz8+D7OalRcBS9wpY13Y6Qi7HoGytHXPbd9UjifhbxVlxjs5kskHsutB5LQYk//PtCTCPzj5di0CLwGGrjzMwsAL+ICkHU9KxzmqZHa9Dts58zFXFCipKwvwll/fM1hBzaogzwDEF6rR4C4H8yDBRsdin4odMt9d+i41/QHbzD7C3ouQHaUD2Ga/4570yHZhk25+YN7D8KLTRG7CiBWN7garQ5DHKsRE5fFYFI8XYrt9QkarXGfnKibeqlJexsrUaqSRExc23Y/ohcsileTl2gHoyu0KhdbimtvpglsDPTV/cWP1Z79xWlRrLU2GQGfe/lMAemUsklbug7+LOvaRjnGD37XqseIfj4KyEHu9pFBMy9WOLmRM6V/FJ0eAXiCSNfpCL8DA/TCSd3WqyGBAgpI2SZq2ZzwNWVovDeV25pQYi/9nYQqNjne+YUo8EOJm02BTIu7aol9pDcpvuErwSBsVj3ys2HVeyn38XmAsxWSzZBSNvHJfnzHnynNolJkSSncUL2UxaKKx1qXJpTEpC6kizass5JnkGoWfAiladY0tk+HMh2xBBKH9xsXBLAlNDfcsYz+VPsfxlDny82n8AGtMazF4UckQ3BPYPsmKiLObaAx/QIWNIhi4hZ9RAoio5y1uZ9qNpDMgQfBIz4x58Lk7T64RIroNy139D01bJO0ExNcUvAPQ9P12jWNHqTCiAbzQYY+i1Go+RgZJrgEJuv/xK0DF6blQLdYq00unyB8lMFz03snXpOXo3GsIlgzlgzlC47/+cMR/qBhlscstLhZ0L2vEfsNhdEIQXGX4zt0eEkG6ztpKir7Zl1JDTP4+fH1NlmrJW
 PPlEgkcd
 hUpA0hk0IRKPZd+mcM2ZupU1p37eh/xmrZqXlvXh1NyJxS87rkQUJrVNHz470pXgBJJix8UhRPOGz3FnucXiL0zv8JhZiCQFS82t90g1G5Qh5DBfhh1jCt6tSIzfqFjD1r/EDFrZLQxmOg80Bzv41OXDd6Mjd7lKNStQLg+B6CzgwkNB1cOgidsrUOi+rNSNWVvwv2FKWv1LwfmaqQeX1fdfJnpTCwWfO0/UtrWt3JLdaY9GMV3EcNVaNNGjMW35bpkwl7WYACQvye+mgIWIBeOmTqJSwVIiLo5PmnXDxQtsOAAORRr38Mvw8ykfqlGQdYVloTnk94PFz4vozWTUbPUVOdyoodPHXWuWQIcl9MSaHSlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 15:14, Matthew Wilcox (Oracle) wrote:
> Since commit 730633f0b7f9 in 2021, we've had a per-mapping

checkpatch. pl likely wants this to be written as

commit 730633f0b7f9 ("mm: Protect operations adding pages to page cache with
invalidate_lock")

> invalidate_lock which is used in much the same way as the hugetlb
> fault_mutex.  This is a fairly naive conversion; all acquisitions
> are in exclusive mode.  It may be possible to relax some of these
> uses to shared mode, but I shall leave that for a future patch.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
> I've run the libhugetlb test suite against this, and it includes
> a test called fallocate_stress.sh, so I hope this works correctly.

Do we know why we ended up using this hashed locking instead of just allocating
one for the mapping?

Almost seems to easy that I wonder if we are missing something important :)

-- 
Cheers,

David

