Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11CD4EA4FA5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0AE6B0088; Mon, 23 Feb 2026 06:04:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388536B0089; Mon, 23 Feb 2026 06:04:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A2B6B008A; Mon, 23 Feb 2026 06:04:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 154076B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:04:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEFB51B6A36
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:04:20 +0000 (UTC)
X-FDA: 84475437480.12.EF479DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EC6D040008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:04:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnnC2bua;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771844659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHDN7EtcnbRkj581NosQCPvwrcxan8TZLSppIVbz1TU=;
	b=DceBtzGk1iqjiJhu93ZPq4fwR29s/QDfZYG8zcVRm/QNInm1a8MCJbD+WQHN15pPInUwiP
	v0fQjMRAKxu3HtqVw01JSqkvJuUHoVy3hCWwLPC7uwFCsvEipZjard+AIB3eDI5UB/9sTm
	ChmOLx6/khsiqvBkDzReggPeIzLKXNg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnnC2bua;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771844659; a=rsa-sha256;
	cv=none;
	b=slZj7sM6kb78cwpEImdt0SIIbWqo3yUXNU84k9zWSZSk+hBE9M0esJBVXvr3uJsRmdn0Qv
	3EpjMOlfbZTEIFgGJdXDb5hS5KnrRg9nuH5JePZkY5JRxKRdNcqlV1Dpx5+Dy+zE6/vAdV
	DXOf/YHe/BIaGDCumDZopeFO3u1VLDc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B7503444D2;
	Mon, 23 Feb 2026 11:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14365C116D0;
	Mon, 23 Feb 2026 11:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771844657;
	bh=FZFBzPGnCrTrHRLYhwz+nC6ayAg7fWR/PZthCgu0blc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qnnC2buaIz1PDJpLSfkIu4EawSFF3eyeGDuHOV1ld9q2Fxw8PCPVzVVPa1RDvuY4o
	 xLRanYMyaEqK4anXJBnA6KP6JJOnLHFi2u+Jhar1VOU/kAgpNAv/Rmc+Bi0yhlfuav
	 WxzXe4+nuSZ/3jd7OSgRcG3992pm9pjEoHhYTCzpJSRCEeLxhB8Kv+SahGfXr8bzGR
	 cDapua6G+oFcrXLfyK/sTE9gm9hpsEgUOHzjfQa/W/aAzY4th4zgN7joUYP64KQJON
	 MFWIXRvODDLv7sPInJl5vKQnNB0/5uAEwudpQdZKCdc3Dmqr0m6jlJZK+8uP00yN5Y
	 2PrW7yc20TeBg==
Message-ID: <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
Date: Mon, 23 Feb 2026 12:04:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kalesh Singh <kaleshsingh@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
 <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
 <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
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
In-Reply-To: <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b4shxdzdzg1boq4yqfusf5jxh4qs8i7a
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: EC6D040008
X-HE-Tag: 1771844658-516182
X-HE-Meta: U2FsdGVkX1/hWk7gn3wkcPIZGPQntQzvxB7jlyf3BBTclOHOYhyxiYIs0eJlUQDT6sO+zY0jR0cQQLb3GwCmv8Q7sK8XKRnhZUQUu18YvpzNi2NEh8y31D5Oq2Yod09d+LKooVlXVJjWtj8vvJiD6Kh3p4308hj7TGwSe2QgHt3k7SYh7GoF3rbxZKoFlLM/Eu3f/KWQtUQf+Y4yQlu7nsi51Hj+w06yOhfguL1qRu6aQu7af9oIfKK1WLqLo5V6+EOYMsxBOXc3olLwuPzVDLMAplhyIAkclmEELunK7nps0iD8kr+ls7LyusiVARnrJCco/jF72ISF0mQebmCNT5CogIUV/qTdLQJ8W2w0pONQxYc8c3umgJsu3KhMBl/xiAWjZDaO6BXY/39fsgozJ4DOBpqR+jA+28VcvgyeAJk5L1UON06PE32nBxhtkNwkCP+8mGHLjqZMSS/18TZyfytaQiV3MUKWNWUUCCuLjDLwchvuXMXSYXP7UcSxUry2Iw1GGahm9a3UDh+ytdDxaakPxXAXWZj0glzgekO6r2ZjFAy4UxYVJMliSa799/llxMBLsjuTgKNcFi6YNCjNQ0dnBwY0bzxiATvn/YckRQSOacJkSPsxedI0OKkjbSu5PjDHxnNsEOkF+irhzchz7zxQ3P/uxCOB3vI12QDlGLgW9dBDtj+6gYSL4+xuxWUtGKitubQS1SRXPcSWRuQrOVv0r3p2Dxaar+gt1QVsksn9DBhWLSrDfkStIkKVUuKykVyatUK+bcBwGbw6rrcMu3w/AVfBqyoNZB6MYL6f1j1vmQSCRz3iASDwvh8jcaTb0f/na7vMUm4zPU3MRSonyusHxdtwoKtraBdt7gyBGxkKCDf2VZm+mU2jQvLog0WVH7Ve1lDUc5+qw476u9sSS+JflnLlVRPUgmy3xovGIWcpM9TbFO5HTI9/7wALF0KaweA8tJVh6fBDjxTf/D7
 cph9ASsr
 7+qtz4FlnvSbUuEQBR46Az5eYuBnsglQFO10Qi8t9GsmUoBBYu/FwSvPblLw66o8Lj6IEGPnz1nOX/WqIyhdDnAXJ8N9KIeeI4vdKmbM7wNpITfDIfFz1FBbjFMBwZMZ1y8/BVWg7XMqj+I+6Kk9xSlnJnx+aUKuezNgLKykrJ/YXe+N0aAyQLLv1t9CXWHTm5icLl60OnU53FOfDUhVBuG32sogDtZtbcSzDlKwnGEm8/nAYI377d/cyQTTplF1+w3F/nJrhRA5P3b3BEUBlhFk1oSl9xy6mwEgJuuMP0Bfv07IlnqJYcEhwxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/20/26 20:33, Kalesh Singh wrote:
> On Fri, Feb 20, 2026 at 8:30 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/20/26 13:07, Kiryl Shutsemau wrote:
>>>
>>> Well, it will drastically limit the adoption. We have too much legacy
>>> stuff on x86.
>>
>> I'd assume that many applications nowadays can deal with differing page
>> sizes (thanks to some other architectures paving the way).
>>
>> But yes, some real legacy stuff, or stuff that ever only cared about
>> intel still hardcodes pagesize=4k.
> 
> I think most issues will stem from linkers setting the default ELF
> segment alignment (max-page-size) for x86 to 4096. So those ELFs will
> not load correctly or at all on the larger emulated granularity.

Right, I assume that they will have to be thought about that, and 
possibly, some binaries/libraries recompiled.

-- 
Cheers,

David

