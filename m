Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370C0C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8BB8E0006; Mon,  4 Aug 2025 10:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9198E0001; Mon,  4 Aug 2025 10:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898498E0006; Mon,  4 Aug 2025 10:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 784118E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:01:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16986135785
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:01:54 +0000 (UTC)
X-FDA: 83739238548.17.5FCA7FA
Received: from out30-76.freemail.mail.aliyun.com (out30-76.freemail.mail.aliyun.com [115.124.30.76])
	by imf15.hostedemail.com (Postfix) with ESMTP id 05AFCA001A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:01:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=aliyun.com header.s=s1024 header.b=szsqOJow;
	dmarc=pass (policy=quarantine) header.from=aliyun.com;
	spf=pass (imf15.hostedemail.com: domain of nh26223@aliyun.com designates 115.124.30.76 as permitted sender) smtp.mailfrom=nh26223@aliyun.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754316112; a=rsa-sha256;
	cv=none;
	b=TyLJTfZYUzXYbgtGMRqD65X34yOz76Bi4UNkOxwY7NDYaDRWhyxWTqSCsuh10zEqmGmPC/
	JiLBNe7qI4MvZGUXTbpbzW7gV4vkaBxhV1Q+yIDWilHhMLhvEAal3TnB0jOD433rbn+7ak
	9UV9eh1e9ykYL3QO3DRYWitTGSAnzI4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=aliyun.com header.s=s1024 header.b=szsqOJow;
	dmarc=pass (policy=quarantine) header.from=aliyun.com;
	spf=pass (imf15.hostedemail.com: domain of nh26223@aliyun.com designates 115.124.30.76 as permitted sender) smtp.mailfrom=nh26223@aliyun.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754316112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ku/VomndLtGQKDrKw+e9juFdT0fnLx6nbOVCwGpLQYg=;
	b=ixfR0UMtPBqkF3OvaTaOoiJdbdz/YYNYscvvVcMnJk6LQmzVXbS8MYkKxuGGLqGGr4QieC
	OBk6g0m3giBZkezI4JOPEc6YEWMhB/xbC7SYJiOM57FYWUrajmW2aSpGRDpHtxD/u6hksD
	5mHvTrqY/Q+Dvv1I3CnQHYJq5npv3k0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1754316108; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ku/VomndLtGQKDrKw+e9juFdT0fnLx6nbOVCwGpLQYg=;
	b=szsqOJowbYT0N8VnoCuJ4aWdkflG0FmufcUcYxJZRKTzkB9XLHd9fcKQeLHXWDrlpQuCeAMJzFvm0o9EdyZ8PIujXzqD7NwXJj+yPe6oaj+Y6myZJXH7xp5Oenw3VBRpuH332s3kGlFzuQBcWmNchPMQ8xUgRFR/GYFcc+D4yWg=
Received: from 192.168.71.146(mailfrom:nh26223@aliyun.com fp:SMTPD_---0Wl.8Zr5_1754316041 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 04 Aug 2025 22:01:46 +0800
Message-ID: <b98058f0-79fd-4dc5-af7f-d37941eb5707@aliyun.com>
Date: Mon, 4 Aug 2025 22:00:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] binfmt_elf: remove the 4k limitation of program header
 size
To: Ismael Luceno <ismael@iodev.co.uk>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, zhourundong.zrd@linux.alibaba.com
References: <xd6zp5ytq6iakxkqoqqtseomgu5oohau4ynj3xbo7ejohpv7dv@skp2v7awzab4>
 <aI2KQaWpPLSAqdXg@pirotess> <202508021029.7CC8B334@keescook>
 <aI7zDXb2VpuaHHYi@pirotess>
 <6653242a-5b08-48ff-a126-9e9367633420@linux.alibaba.com>
 <aJBfDKr1-7L7GGgH@pirotess>
Content-Language: en-US
From: Yin Fengwei <nh26223@aliyun.com>
In-Reply-To: <aJBfDKr1-7L7GGgH@pirotess>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 05AFCA001A
X-Stat-Signature: 6pt8tsgnyk5grn7twe6u5cwp9am81mba
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754316110-414798
X-HE-Meta: U2FsdGVkX18W9pn5y+8BEfP52dREGptqXkKNWkaIeYE0D6JSK3AP3x933TpWZxQ4D0+3hZ+QNN+iFzy11/+ub0ML1cTxsh8cWYUfGAP67dZgWz9MwZ/JmYyGgCORsPWHux1+c9oGxKtzc4ZtDyOtIuHF6G6JqfMoi67459RRtkL87tZOQtzaMFCHHZa14k8ns6uYtNrAT8b9XZU8oH3MBpm6i9hCWakJrG6Z3yw9aizFeN8H6Z+nkZKcCW28PQxA4y8oAK5IdD21Wi47rdhlB65Ylxb/jWAdWXp5035lPQLGCUW2fNuZA+CMO/+Tz1Es74dwZ6RY8LCWILl85kF1DWqCI0H7vaHvc/MXbqgFYyD9zfgt4LWIvC/0Yt5XkQBqarzJTZLQeIUZ/VZuRe5pzp9rE4v0Q3XmmYuBcUgsbSOVjLGGx77PUmkc/fZUGHqWvboZPFzaWJd7DEUFzqam6iXPAaOQWjRGew+HRHpMtx1yNuXNuEKWhjQH4nQwYAFZGum9FGUdHAWMA3GfZs0PPDXgGwpaBpDDKZ92O4497cvEi13+8cirXoEmTH6N/7SuNuuutHQvzs2YMq7H70VZdNasCsH4nLRTBNf1vgawt5po/z540UEfNApYyOTsLSMu22ek3fMfWq0CyKMfaNHnPkOqHHOUtf1OSKxkvhIIMMQ21IfEvpnpykNcK4n6p+cv18jFrd2b+5iUJDp4L2pLhkCicTFn5VLA+uaJX/kz8KBFprYs0yPHTqJPEx+xFUu2pwSx9I/unG4cjhiwPkhS8jaSFFD81/qoHNIjmpPp5foI8AucJ1pO3Blzwe98pBAU6M4msNRMoV2vMuWb8TNkeLfIdpEzsiK5BgBEB7MjiHXSJWilSbJ5CKxabDLQ6wmA07jNXLMxi+DqIR2t3q3DqLlagCW8Fb3/Tmblq7D313KQA6W9UOiu978ZwhyAQ9eN9hmExk7PKRX2l1kwQyD
 tJIiuV6w
 2T53KWoVEAJf13r3NJJXIFCZjlrC0LJtuxJRoyJMi9tCOxK7tNgIRKLKUQPa0NXPqFoPTugKnUdHHIumt4E4+5ZUwvBUuzuBy5LvrtEINFRrli1l9twYiDWOpsZHqzCC1PXMkFoFGhEa5cKoVaZPv1zZNuW3ScnvljQJmHQuUv8bz5tnAE/mZFdH2U4q7KvcUeAL+o2y5BPNotvx93BfL1bTsVUFV/jFyBHnpbAsKQXA/YdsSzq8mvawKo7BU/IOYcYCBbx1ciWKzscRvg5cctFn+LkkPtqPPt0+t/uFxvVfQoZ6uq73ScPO1qt+hspXAJyenNJtz0Wnyg0/851Eg572yg/LsP1DzUvrh73ojo9O4wgzg74huwR2+vsIQjmXysv4KWi0HcWYVBcLx9R2x66ZtRWqOBTI2QJaqHIYLT9ol6qDbcQP1IdgHjeAkzxFkoyWr0IOdctDMS9+9oSs2k1jKnakF/aIXYUPE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000004, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/4 15:19, Ismael Luceno wrote:
> On 04/Aug/2025 10:12, Yin Fengwei wrote:
>>
>>
>> 在 2025/8/3 13:28, Ismael Luceno 写道:
>>> On 02/Aug/2025 10:29, Kees Cook wrote:
>>>> On Sat, Aug 02, 2025 at 05:47:13AM +0200, Ismael Luceno wrote:
>>>>> On Sat, Jul 19, 2025 at 17:17:09 +0800, YinFengwei wrote:
>>>>>> On Thu, Jul 17, 2025 at 04:31:50PM +0800, Kees Cook wrote:
>>>>>>> On Thu, 17 Jul 2025 19:01:08 +0800, fengwei_yin@linux.alibaba.com wrote:
>>>>>>>> We have assembly code generated by a script. GCC successfully compiles
>>>>>>>> it. However, the kernel cannot load it on an ARM64 platform with a 4K
>>>>>>>> page size. In contrast, the same ELF file loads correctly on the same
>>>>>>>> platform with a 64K page size.
>>>>>>>>
>>>>>>>> The root cause is the Linux kernel's ELF_MIN_ALIGN limitation on the
>>>>>>>> program headers of ELF files. The ELF file contains 78 program headers
>>>>>>>> (the script inserts many holes when generating the assembly code). On
>>>>>>>> ARM64 with a 4K page size, the ELF_MIN_ALLIGN enforces a maximum of 74
>>>>>>>> program headers, causing the ELF file to fail. However, with a 64K page
>>>>>>>> size, the ELF_MIN_ALIGN is relaxed to over 1,184 program headers, allowing
>>>>>>>> the file to run correctly.
>>>>>>>>
>>>>>>>> [...]
>>>>>>>
>>>>>>> Applied to for-next/execve, thanks!
>>>>>> Cook, thanks a lot.
>>>>>>
>>>>>> Regards
>>>>>> Yin, Fengwei
>>>>>>
>>>>>>>
>>>>>>> [1/1] binfmt_elf: remove the 4k limitation of program header size
>>>>>>>         https://git.kernel.org/kees/c/8030790477e8
>>>>>>>
>>>>>>> Take care,
>>>>>
>>>>> Hi,
>>>>>
>>>>> I noticed this removal and wonder whether it could be a problem on
>>>>> smaller platforms.
>>>>>
>>>>> IIRC that code has been there since ELF support was added in one
>>>>> form or another; and the idea behind it was to simplify the code
>>>>> by ensuring no cross-page reads could happen, as these could cause
>>>>> undefined behaviours or read abort exceptions.
>>>>
>>>> I didn't see a place where that would happen -- the reads aren't done on
>>>> a single page. If you see something that I missed, please let me know!
>>>
>>> The offset to the phdrs can point anywhere and the entries are
>>> arbitrarily sized, thus it can be unaligned, so we can be potentially
>>> reading at an entry right between two pages.
>>
>> The read buffer are managed in kernel. Why cross-page read can cause
>> undefined behaviors or read abort?
>>
>> Does smaller platforms have special behavior in this situation? Like
>> can't do cross-page read against the buffer allocated by kmalloc?
> 
> Pretty much anything MMU-less will fault at cross-page multi-byte reads.
> 
> I'm not aware of any system with an MMU doing that but, I think on
> RISC-V it's implementation-defined.

Checked the doc "The RISC-V Instruction Set Manual Volume I" - 17.1.1
Momory Model Primitives. The misaligned memory operations (I suppose
the cross-page multi-byte access you concerned will trigger misaligned
memory first) will be emulated by byte access. So not a problem for
Risc-V IMHO.


For MMU-less system, is it possible a 64bit system? If not, the phdr
size is 4 * 8 = 32bit. There is no cross page multi-byte access. If
it's 64 bit, it's very unlikely that it has ELF with more than 73
program headers. I am kind of sure that we are fine here.

If this is really a concern, we can add 4K restriction only for
noMMU. Thanks.


Regards
Yin, Fengwei


