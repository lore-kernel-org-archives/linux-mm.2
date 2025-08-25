Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A57D2CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 09:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64498E0009; Mon, 25 Aug 2025 05:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A152D8E0001; Mon, 25 Aug 2025 05:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92AEA8E0009; Mon, 25 Aug 2025 05:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9928E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:40:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FA7883E64
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:40:53 +0000 (UTC)
X-FDA: 83814785586.23.474611A
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1454A140005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:40:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf23.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756114851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0PCMP2DJBUtl6uDh+HQlNBdAOpBQeWcYe8UpTkRt06E=;
	b=MInJhie1jQIDexlwicch/l/thiJvey/hjpjRQUykNvSSPdw0Ny49WEcbvdxfQKkVce2gD+
	PSH0Qjarqzbe/eFsyyMIwHUzc61nvnuVPJmuNbBudNpe+92JQigj+MBT80jLcaAWckl+Hj
	0CLqG24JWLoVOqKEhf1TdIbPjmGwvZg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf23.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756114851; a=rsa-sha256;
	cv=none;
	b=wsyxvJRds9WIliJEdsc9FwpgdAzfJKoiISVy8gj88gi84taggROJXph9mE5cPiPs/dyaNF
	ZNVykg1VuKE426aggQGUV9b0yvIwUwnGIRp0Nk7q43ob3QHPVl5SbjE5zDbyUU2yCNvTP1
	gsqsQx13GO1lrfbYQq1Uyd3GO/o4O1A=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c9QlP1HkLz9sSh;
	Mon, 25 Aug 2025 11:40:49 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xXbQBsr7Ehxm; Mon, 25 Aug 2025 11:40:49 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c9QlP04NMz9sSc;
	Mon, 25 Aug 2025 11:40:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id D6B268B765;
	Mon, 25 Aug 2025 11:40:48 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id gtwn_B0_QRlE; Mon, 25 Aug 2025 11:40:48 +0200 (CEST)
Received: from [10.25.207.160] (unknown [10.25.207.160])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 763DD8B764;
	Mon, 25 Aug 2025 11:40:48 +0200 (CEST)
Message-ID: <16679d56-5ee0-469d-a11c-475a45a1c2b9@csgroup.eu>
Date: Mon, 25 Aug 2025 11:40:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/10] powerpc/uaccess: Implement masked user access
To: Gabriel Paubert <paubert@iram.es>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>,
 Davidlohr Bueso <dave@stgolabs.net>, Andre Almeida <andrealmeid@igalia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Laight <david.laight.linux@gmail.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
 <647f1b1db985aec8ec1163bf97688563ae6f9609.1755854833.git.christophe.leroy@csgroup.eu>
 <aKwnMo7UllLZkOcK@lt-gp.iram.es>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <aKwnMo7UllLZkOcK@lt-gp.iram.es>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4szjgq1icaz5bz1cdh1no7bric7msrpg
X-Rspam-User: 
X-Rspamd-Queue-Id: 1454A140005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756114850-852612
X-HE-Meta: U2FsdGVkX19DuoGK9CQIDzNTs120fiHwD9hv6DK4iub/CJujas9KJfEcDTJY5ccf6hOXVXht1k0CcSi/IqJAs2RjmWJ+kvqhwN9QHqrd+0/yAr/z7K5aheE+/l3gBUA66iOfyh1ciEEYwebWDi6aqBsBK9uWc17SpSAo018hVF5IVSYQoCqQo7dxt62zWtN6ww97YkL/jlJ1PDR0o4gO1VHtfwrCVKNM0X23bp/NS98CuPwgmhMuT22zR6jRhSa9NcCNxNTqm8YYKyuAo3RG9zFPjrhVhDXZlrum/fUW5E63BUn2oJq/ECV6wZihUilxhFdPiH67sZxbNEU4ZWvzfm+dEkqTuYWHJSjnv/hMfmndSzA51jbJ45VUsx/HBRxgR4p1pCuCV0ikzUrLJg99nQsJXg7ISGIBhEkI+wM+v+Z/WBT/J7gzOF2EA2Zk93TLJc3qLhXttoCsa6uhEqxkzDyBeINxVVdCivQexK2lMMsQeeiXndwq3hl9Mgl4naUIyaoxbtCfMBDbYU6Is5lKKDXWtWZU6BqI5QdkUxO+eU2YH//HpWOGIoUJD+Zjx+Hr5Da0/vP+AZbT4+AM91VwKj8lxfvLJmffa1WvgOD+SLHumFaXZstcNtaKHWA7QVtK1xKDg2TXqjAtdUs768LnwmAv7DAWNK1yqBHY2VtpDSgw0sfg+mDLP2sk19cYURnJH5q6C7Pm7vFnar56RTYLEiq4i9/KIjODpOD9I45/EtqiKQur/MFsGcppviCnc80jvfMix+NcuPQI3wUBjTE7R7JYqnKbxEOTlEZSmmFwqw8JJGJomq6qB+J8bMCgbNu/ewoyn0QsBjnmMH69zXjvN10ok/Yk72/bRru/hjHxIqb4xS9kh5Gje14bpdqhnqGlLcJm9X2XsPqZjZC0Jj59scLzK9CW2/p0J0iotVU1zewBS6iC1lKTQJFe23leN4j5CMN9P2myXWQJA0psY/q
 d2jzACT6
 LANzHwkENrLsJSKBpAD295SHh9/Q7bowA+T40j6lm3EBPUqQoJg20kz4EcnPnX+6mB39WiLy8RLJGbchAH9VH54o0jEo3r24cM2hbLVn+4dxThX0Jpr/G9omBXKcvwil6+mh7xYkoXWv0jogc5D9opXuxFa7RkBxnUhLP1lodU4XTyYNza5KN13jRtwXaDPfWf4QZODCQaxl7ivYd0g844Rw1t4zkUMySDm3eteCsUoM9SpHmUgqLbUEZWE9lHHSfBglv+Yh/tBAh4oJC6a6WjPUBZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gabriel,

Le 25/08/2025 à 11:04, Gabriel Paubert a écrit :
> [Vous ne recevez pas souvent de courriers de paubert@iram.es. D?couvrez pourquoi ceci est important ? https://aka.ms/LearnAboutSenderIdentification ]
> 
> Hi Christophe,
> 
> On Fri, Aug 22, 2025 at 11:58:06AM +0200, Christophe Leroy wrote:
>> Masked user access avoids the address/size verification by access_ok().
>> Allthough its main purpose is to skip the speculation in the
>> verification of user address and size hence avoid the need of spec
>> mitigation, it also has the advantage of reducing the amount of
>> instructions required so it even benefits to platforms that don't
>> need speculation mitigation, especially when the size of the copy is
>> not know at build time.
>>
>> So implement masked user access on powerpc. The only requirement is
>> to have memory gap that faults between the top user space and the
>> real start of kernel area.
>>
>> On 64 bits platforms the address space is divided that way:
>>
>>        0xffffffffffffffff      +------------------+
>>                                |                  |
>>                                |   kernel space   |
>>                                |                  |
>>        0xc000000000000000      +------------------+  <== PAGE_OFFSET
>>                                |//////////////////|
>>                                |//////////////////|
>>        0x8000000000000000      |//////////////////|
>>                                |//////////////////|
>>                                |//////////////////|
>>        0x0010000000000000      +------------------+  <== TASK_SIZE_MAX
>>                                |                  |
>>                                |    user space    |
>>                                |                  |
>>        0x0000000000000000      +------------------+
>>
>> Kernel is always above 0x8000000000000000 and user always
>> below, with a gap in-between. It leads to a 4 instructions sequence:
>>
>>    80: 7c 69 1b 78     mr      r9,r3
>>    84: 7c 63 fe 76     sradi   r3,r3,63
>>    88: 7d 29 18 78     andc    r9,r9,r3
>>    8c: 79 23 00 4c     rldimi  r3,r9,0,1
>>
>> This sequence leaves r3 unmodified when it is below 0x8000000000000000
>> and clamps it to 0x8000000000000000 if it is above.
>>
> 
> This comment looks wrong: the second instruction converts r3 to a
> replicated sign bit of the address ((addr>0)?0:-1) if treating the
> address as signed. After that the code only modifies the MSB of r3. So I
> don't see how r3 could be unchanged from the original value...

Unless I'm missing something, the above rldimi leaves the MSB of r3 
unmodified and replaces all other bits by the same in r9.

This is the code generated by GCC for the following:

	unsigned long mask = (unsigned long)((long)addr >> 63);

	addr = ((addr & ~mask) & (~0UL >> 1)) | (mask & (1UL << 63));


> 
> OTOH, I believe the following 3 instructions sequence would work,
> input address (a) in r3, scratch value (tmp) in r9, both intptr_t:
> 
>          sradi r9,r3,63  ; tmp = (a >= 0) ? 0L : -1L;
>          andc r3,r3,r9   ; a = a & ~tmp; (equivalently a = (a >= 0) ? a : 0)
>          rldimi r3,r9,0,1 ; copy MSB of tmp to MSB of a
> 
> But maybe I goofed...
> 

 From my understanding of rldimi, your proposed code would:
- Keep r3 unmodified when it is above 0x8000000000000000
- Set r3 to 0x7fffffffffffffff when it is below 0x8000000000000000

Extract of ppc64 ABI:

rldimi RA,RS,SH,MB

The contents of register RS are rotated 64 left SH bits.
A mask is generated having 1-bits from bit MB
through bit 63− SH and 0-bits elsewhere. The rotated
data are inserted into register RA under control of the
generated mask.



