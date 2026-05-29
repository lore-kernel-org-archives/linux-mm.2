Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCC5CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B326B008C; Fri, 29 May 2026 04:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2B86B0092; Fri, 29 May 2026 04:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07FC6B0095; Fri, 29 May 2026 04:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD67C6B008C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:52:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F40E1C2B80
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:52:56 +0000 (UTC)
X-FDA: 84819842352.02.233F35C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 76FD120004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:52:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kly1uSR1;
	spf=pass (imf03.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780044774; a=rsa-sha256;
	cv=none;
	b=ieeS2mjS1p6i30iv+D2/H3SV8UUmROdtB6DWMXIA2m8ZLWmFVjNAsQZoLic8JOlTJZYjWj
	///wIfgYldVnH8tZJRxiEC25Gh4jeocuQZTT3r0eylck/EW+SlF0Vav3isvL4N/NOMI3NX
	iZ6AKUZYmSDHBjp2CA2ZKx2fY207u5Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kly1uSR1;
	spf=pass (imf03.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780044774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwfWO5ylsSIxckFIR6JvOs3hi0LSk9IH+1TJ7RISKWU=;
	b=Jjt0lUMnVz22wAXJROdldXs2h/Xr2EPc/9QtgP6Kwn8dtxO4UBey+J/LksghSWCHXAHyla
	MOeqiQ5n8T+43//tE51mYnYPU/GlkM+/3NCfD4YIJl9ulD6DaDYZ9k64gSCFc3V0vjdvi9
	iXpvNdgqMYE/rkEByo3Pv4V6+Faxsk8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B57440A0E;
	Fri, 29 May 2026 08:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2B61F00893;
	Fri, 29 May 2026 08:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780044773;
	bh=bwfWO5ylsSIxckFIR6JvOs3hi0LSk9IH+1TJ7RISKWU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kly1uSR1H7SUbGt+pgv1Du70uRlv9LbWIZlTPKTyZbdCZ9nDIli84ih+5Mv4c+jsE
	 8c9m5PwrcPCTpzCrmeT/YzD3dBYPjIN+hiY0DBulWa9uqcxr1chJPtPkEoIxrl2UaH
	 nIZmLZU8boYKEwogyUeSu3rj+QRlq4KP5q+kVpLJdntJYg2rr/8d0Dddj0wjvOZwKF
	 ytGTr/oFMLyvcL6uKxVlc7I+MkwDV4c6NbaNiGlSeWmpqASTC+1Y/6lyA9IhczaKuW
	 dHVo/6j10Rv2fsOD2Ad1MHCSWpPIkMirRkQlIT/Pb9xQQVhABfPuKAyh8KhzNuDWyu
	 XbrL6H11zlYFQ==
Message-ID: <98ebf7d1-244f-4fbc-afc4-3e8940df5422@kernel.org>
Date: Fri, 29 May 2026 10:52:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] tty: serial: men_z135_uart: replace __get_free_page()
 with kmalloc()
To: Mike Rapoport <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-serial@vger.kernel.org
References: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
 <20260528-b4-tty-v1-3-9da9f7aec5f2@kernel.org>
 <18bb4a45-c26b-4a89-b598-a844d3aadafa@kernel.org>
 <ahlRqd3e94ojSfWE@kernel.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <ahlRqd3e94ojSfWE@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 76FD120004
X-Rspamd-Server: rspam03
X-Stat-Signature: ybjq59ytooby3xe7rz18qgbq7te4cuf8
X-HE-Tag: 1780044774-608982
X-HE-Meta: U2FsdGVkX19QJxB5joGhKJDimsB+Xw548gBYGyDkdO27DdT4MmZHu09PbGbT/ejhoIma9v4uVyN26tTP9VMMxj/dCZfOC4R/Noi6Vi5QG3CKHw4RlEo7EqM7JVoS7nzc2rQqznaKwz66pr3iUjijGW9CzbFKYij12otHoNAnY7Ln+omvIAYQ6P4K/PljqWMihx1UsziXzb0EvbNVG2LCxgoKJBuFWbtNWv2MgvEahvmTDeePkSlrtGXExckiTA0trcWTizNzXGsOQoLHTtCtzBMGiSmqF+yP2hIsAa02LcXl5ghbwFbWKHk9ApH4C7huKnJ4vxhIaPXS9IHPzL07hRf5SKmPAle/JlBZSMAKg2hI6WOjtn9GKRGDMVnQcohNKGZ/N8zlbxJx1w0jsv2+myjxwt6wTaZjfOAXmoFijCLm3UHltbA7nfeAK4EbkHVgy267uMb6S2M2F5zvTsYSbWe3P30ji8VE3xf1+d1JfN9aEGVEIao9huc7Bnne7g5FMqhi09LlyN3zEaiyLaRdljpJqORRuq8ka5H9qftUZGMXUVae3iuv9/k7D4aC8clnruKN0QpgsH+pcMn4w82Xn6o4EwNVq0h7FUOK4KsI+H2+AawQHktuw5cHsIT4McTpXK63HviFy9sglWDos+sjYhXkV5PG/HNzZxvMwFlNrSQp4UaVQTiWhu7xGnjhhB0tJ66xDyBtlEIe650ARTweJfc5BxXAVfkQmPyR1xZDacysQ1W6Vcyxvjkh3Jyv7UuuTk8gxZH6VGcGLngF+YFY6srfJBq5XXNhxtzOnfYuHcZ7nEu66jqEFMsxZ7y6PMS2lMv9c0SSh+2bmmgA2W/HaLw0NkxU6i+yZGX1PlPGychAeCDNRj9UK6Vc16kMYnGCowomf/aqE4XyrVxOn50RHPJLaYwCY2AB5r0bf8MHJ5Qsv1NMCKp52CTWXhptLvOCGz3iimvcAjfd9Gd4Hbv
 CpMDGLTO
 Rx01m6R3X+E5TI+nvsJp2+V+4axwbASdMpF0CWrKy3PjOpeymz9HdB3joRYYM63upDOdA246LEkJRwhji8Qkf5FpZPGwfJRwsNdh7SxQpn3Q8tCBhpOch8hZusB7OH0d8C2Jl1/kJnpuvuTqq6noWV+ULkEOJ4E91a0gC+w+JJS7gyH0YWk95YUokCOdgLw1n/OCD3zwZFTEgPSrMbcVfJ0Q5Jn+WGfU0nOa8Lp5QU44MzxPVswaJih7WoKxTRo9ShbxQZwtywWd9mMbVbpHFyhmY0XnyjWVNWvVRWmXLjX+fNdpmkRq1tO6jQGuLPgPY+lmBLdIPLGfJ6clwX9J3bfI7LzucV+QlWYLB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29. 05. 26, 10:43, Mike Rapoport wrote:
> On Fri, May 29, 2026 at 09:47:33AM +0200, Jiri Slaby wrote:
>> On 28. 05. 26, 12:24, Mike Rapoport (Microsoft) wrote:
>>> men_z135_probe() allocates a receive staging buffer filled by the
>>> CPU via memcpy_fromio() from the device MMIO region.
>>>
>>> This buffer can be allocated with kmalloc() as there's nothing special
>>> about it to go directly to the page allocator.
>>>
>>> kmalloc() provides a better API that does not require ugly casts and
>>> kfree() does not need to know the size of the freed object.
>>>
>>> Replace use of __get_free_page() with kmalloc() and free_page() with
>>> kfree().
>>>
>>> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>    drivers/tty/serial/men_z135_uart.c | 7 ++++---
>>>    1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
>>> index 6fad57fee912..9c32b01edc9e 100644
>>> --- a/drivers/tty/serial/men_z135_uart.c
>>> +++ b/drivers/tty/serial/men_z135_uart.c
>>> @@ -17,6 +17,7 @@
>>>    #include <linux/bitops.h>
>>>    #include <linux/mcb.h>
>>> +#include <linux/slab.h>
>>>    #define MEN_Z135_MAX_PORTS		12
>>
>> This one is misplaced.
> 
> Do you mean an empty line is missing? Or there's particular order of
> includes here?

You added it after an empty line -- along to #defines. You should had 
added it along #includes instead -- before the empty line.

>> thanks,
>> -- 
>> js
>> suse labs
> 


-- 
js
suse labs

