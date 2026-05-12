Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C316CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7E06B008A; Tue, 12 May 2026 06:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57E46B008C; Tue, 12 May 2026 06:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B464A6B0092; Tue, 12 May 2026 06:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A32B26B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:35:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F36081C108C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:35:12 +0000 (UTC)
X-FDA: 84758410464.06.72541A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 158EE2000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:35:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RfC32sDL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778582111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVH0/eBESpCbti/TSQueudjEnP2Q2LMx/jTgEXDBpNg=;
	b=2F7ka7MUT5EFtARuOTsfbbcMSbEDnHCUpu2JcD7BmhBU9pcJIwyNM074eLkM1FHKQH2wct
	UtB4/sR0Fkxt61uCLJgvt8QJ8l8bw0O0fv0j1BZowI49oKwYUuJleW5gYWYF0aPzEQkbUh
	wxpHljCcyG7LKj+V9LE2KhxEG0F+hKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778582111; a=rsa-sha256;
	cv=none;
	b=dVObfh10PLPEl2C4CzxcdnZkg/uNUaiRnIbzv7a5btMxFMvYyRM+l/tvKMs4p8J9vNx86y
	5jHEjgVsyba0hgr7V7kZKIUIWgtBIsPfIA7BpEKnRz1a6DNbWyaQyGKClSkC3j40r3xt6e
	uq3WlF8jM06Zy/OlP1Zdnejzenxibuc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RfC32sDL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5AB643DCE;
	Tue, 12 May 2026 10:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC44EC2BCB0;
	Tue, 12 May 2026 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778582109;
	bh=YPu8Z+j4KcVGZgpltOWtgETB3YVZ1/sBoGGX8leTjPQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RfC32sDL3NtG3+/o+07Lq/rjstQv2xyLocAqV9oPXSA4nBVibyrg6/bcfKYfiaN4G
	 lBRQX9cppyKT71GeqZcH8XZlgEHif37s//+6yMXWAKJG0PPyBLbRNvpWoMprC3dTu9
	 tVqR4WQObWLcRiGO86tKbXFN6igpw7VYOluC5Lde5wMP5htyRb2Rj26cpO34B/Tx96
	 2OkXskeL6dckpJ5x81YuGBXNM+TuQXGZbaF8PDfmR0mU/T36Eez3YBdxVKTFY9LYPi
	 NA+smvuFGXBrxiD76lFQxLbMYpGiD0hFHK6eVeSx5tQrsagk2z8++qRYyQfXI7cHWs
	 TOjBuXnORV31w==
Message-ID: <220524ba-e39a-4d7f-b44f-d4e2e7132397@kernel.org>
Date: Tue, 12 May 2026 12:35:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: avoid unnecessary #PF on mTHP allocation race
To: Wandun Chen <chenwandun1@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20260512095031.1333997-1-chenwandun@lixiang.com>
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
In-Reply-To: <20260512095031.1333997-1-chenwandun@lixiang.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 158EE2000A
X-Rspamd-Server: rspam04
X-Stat-Signature: xpzsb9n8766u5a7bqgr4joy8aqa9c34f
X-HE-Tag: 1778582110-788176
X-HE-Meta: U2FsdGVkX18KIhLfuKCJfABzCIzonAcwQuhijTl5nBO955/HQdJmofyxiD1Vq9p5GofqLIy5hOIa5BqXIkOv5GOESOntKkqlV22n2yFgKhPtTEJ/P30rsTzpCwMbSrIPprNNQFkk8cbyZ0tOqNmzAjIofjqjFgwye6DH69qOnoG7Pk0UVrw5gg0vPkd2IWinqDGIhLloVQATfLS50iCVflvN3DXPoBkhHteyjS9hYqe4BMlAcQRbOeTLbNr9qB2d7d5rCibS68NHpw7rcxgeW6YuVv+DknCAyoQA1zl9qYndt20Aonu/3piYeUbtnTwR/cEjdy23wfoT3CpBX2Zv8/R5EeR4kjtOAqDrBJNNNr4+VzQjoz77NJH+4mM6hk40ZNMPfM2BbpD/6Bdi2buF4b+xz8ITmalqH/jGX9VzOwf06Rdw1krEAMSs8RfwCTl+BfDGZl7VCUnJ2QuxreaC6/i7/xGMth4kgloiZpxEI9IiHfTdnZ/95geh1ri6xzaFU5Oz5m/4tPUaIokK4vAt/C1o/sov4OKnZ1W4nzGkesDVpPCv3y1gZTQRjHGK6n63i2i8RDfYZki5rHU73p7NPPwOtQSYbDFn56WPF7EP/5LZB+ufn5JGn3lxOfmAb4ObOFBdhj8PAtcupWIBbBjMdEtE2C7tEMVqNOkmQ4I1xB6/mhpoWAADZb5QEAVBKMW8RNGa3ZXiSBQNYGrk8/f3DpLgwErP1LVPTLUeEkbXcho0noNwBH812Aho3bnSCdOVqfrovHceGkZGZuoSAzdJY5q9XbIiYW37AJABWhs3MlDO8/9Tw7qw21rmWr1s4MQw1DU+OUm+uVLhf60oYueEPs5rUFbw5yXfvyXYAkgSlrKQJy7ty9kO6cvKg80ydRL7F9zEA94ow+aj+aezdNrbqpF5JcFoNdh0++XqTJ69Y5CEouryqmmB3XF1RS4eJ7r8QwvvNvy+Qgb5QL4EI8l
 yYMYI030
 vJy+xyHeT08X9cAfxV7flWubOsEBk9S9CyvJn9UPwPmIgoBxjYBhNn7xRXd/dCcxtXQxpEOjf5TYoiRxAvireA0SS/VkuysMf+ok28A43Uw1LwesNM3d3d+RmTAmwORarpKn43Vbnu4LvNObELDObZDtol9oOydaIhN71BloxUKsVYN4jiw6k+D2hYz3gF0OPDuzFkowOjhf1JLMBz6Eu3c/vjsxymcNkeJfcyLqetF7VGeMLzjjnWQIuxnDGBncfS0Gs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 11:50, Wandun Chen wrote:
> When an mTHP folio is allocated in do_anonymous_page() and the target
> pte range is not fully empty, current code would release the folio
> and return.
> 
> This results an illusion that a page fault has already been processed
> even if the fact is vmf->address itself is still pte_none(). Another
> page fault will be triggered again.

Yes. Why is that a problem?

-- 
Cheers,

David

