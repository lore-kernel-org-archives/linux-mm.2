Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18A2C87FD3
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 07:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A236B0092; Mon,  4 Aug 2025 03:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA6B6B0093; Mon,  4 Aug 2025 03:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737C16B0095; Mon,  4 Aug 2025 03:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 666876B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:39:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DAEDBE5AB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:39:11 +0000 (UTC)
X-FDA: 83738274102.11.023A7DE
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6A911140002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:39:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GFH9Nhv6;
	spf=pass (imf26.hostedemail.com: domain of fengwei_yin@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=fengwei_yin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754293146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLUQ2YmpOeF4iBTFxFURlyjSpp1p8WA2sdCUCNZyHcw=;
	b=mg7//WUh8dZwrWZjo+IlVyVWCdUA7hz8bBkAWza1Pzo5FFVm+qdNNqIAccySo2WwJpF3+R
	KLR0kxnanWVWGpyoUsr1LMP0z7N+6agHavEO3yNnDGGYjNsWDEtVYE64Mm+gg3tTkqf73A
	LHLGuOo4gqRbxR/lYcwq0Gxq5fOeKp8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754293146; a=rsa-sha256;
	cv=none;
	b=kgKCflP5MzLqTvOodECtNhhIdTJbPqIGXRhBzqU3a0jYBcvGTD0AuEBRQ6m1r9ebFreFOZ
	MxKVWCRMvaSxOv0hxgAu+pZOx+Zh1xmYnnruIKQpkzJF/yWuhk7RxKjXLMDFp7L4NjsWgV
	inOs8Bj4++Bq+YxlXEA6QeRbqnA5dc8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GFH9Nhv6;
	spf=pass (imf26.hostedemail.com: domain of fengwei_yin@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=fengwei_yin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754293142; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VLUQ2YmpOeF4iBTFxFURlyjSpp1p8WA2sdCUCNZyHcw=;
	b=GFH9Nhv6Kr8kldIZJwMIQI1senNGvq1osGvMY3ExhmP4B2K9q1/Upw7K2044alEfrqulUy/Zmb7n5gsjpYL960RcNM9StTWpsad0fK4scjvrNOl0fEiIHKOWDqVHR4KzxooC3wO4J1IN2TMK6awvP1gxXGoHai8rDmdJ7FdkYuE=
Received: from 30.21.176.60(mailfrom:fengwei_yin@linux.alibaba.com fp:SMTPD_---0Wkwpm7d_1754293140 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 04 Aug 2025 15:39:00 +0800
Message-ID: <4c035c88-c268-40fc-9930-b5cc73fd49fb@linux.alibaba.com>
Date: Mon, 4 Aug 2025 15:38:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] binfmt_elf: remove the 4k limitation of program header
 size
To: Ismael Luceno <ismael@iodev.co.uk>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, zhourundong.zrd@linux.alibaba.com
References: <xd6zp5ytq6iakxkqoqqtseomgu5oohau4ynj3xbo7ejohpv7dv@skp2v7awzab4>
 <aI2KQaWpPLSAqdXg@pirotess> <202508021029.7CC8B334@keescook>
 <aI7zDXb2VpuaHHYi@pirotess>
 <6653242a-5b08-48ff-a126-9e9367633420@linux.alibaba.com>
 <aJBfDKr1-7L7GGgH@pirotess>
From: Yin Fengwei <fengwei_yin@linux.alibaba.com>
In-Reply-To: <aJBfDKr1-7L7GGgH@pirotess>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A911140002
X-Stat-Signature: hheh57bbexgz7hyzko7axrgmj7kgzbjp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754293144-111042
X-HE-Meta: U2FsdGVkX1+rVf+5ilb2rrPtXjCj0X8elnCJbprT302UJdQBPom4XbgmBlvG2p2Tj59/99L0IeBpqpiwAS9zGTnqQcO4CjprmGNJAZHho/tucOvFKHafKvNRC9Wn2baTBerMEI2QgM65Azedt5gAmk0IWzc4z8pWM4WfG+E+4K6ThMgMXk9rdodJQJQzi0GH4JS+jHUkHBFL4pHxg49M6r0xJEJvm26tsliZ2WMlGNZjm049zwCVGUHU8ntRMbcxEKkj9YPPDgO28f+3OGYCi0B4qu5o2DrDgM4Ge/PgCONQnNnq5bsucQ5VFuwCdH+Z/0/FLrw82bHlSTz+ykkbjC+8z57VvwTzbI2afoOC1ELhDdONmL8Ce5XnaswRpB6iYtQAOMBenQ2ctgdpFtasUfsboBL3mIOlbsV9I+fPq611aRUa55ftNb9r9WNoTtwsfPd57KT68EMbvQgEnKRO+tCMvPxRSY9HLamgBLzgHWNnGKq7L61OS8yFsN41yBEMqvPNK4oZTtOc8n5VasReG7blIzu6toy2e6455dJid0KcTi+92uvt7YgZmSbfMrUr7wW9+O7Nq2tq0oN6HTHMUZUu6jvusEW807CFFEyUbJXS8Xe5lILJVqdSS9ZL0zaxx6ZZ6BcebCFQc1yYHjwuYLkyjTEnEe1tvxwVu+xtBfETm1srinVLDTje08KpPznweQkQR9J32sJ1vLbrbJi5GpcmUWdJycpeeMdzR6P+spkrID5gbI9NU5T7nVe6VGXjfGBuGiFmdSTSufEVzH3K2fWY3a9h181Zuj8F/rPXXUebolMaKQkJWbHeKZK043BGVUgnzrAcZ7gd/EA7E2IlYJr6kogSko0veA986/XDVw8P3QfDkadAnM6hU/mSxFdV2fvPjNiXYXZHppUKNurVeC47d0lxuvf1sNVmQ5j1bdM/c/NPhWQ3a5hdRkYKs3ANZq8yFL48E5s/LWuVeMT
 PKAPxup6
 u/FKJm0HDxfwS78t3s69Ss83ZDdiioVhQt8gDx1eIWpgwG455FNPpfxGGMKiLugLAI1OR2AGpFhviauUpdTFhT8gDy4TOJbzlUOaVEQD88E0L51ZlfAf00quYPVo0LvMOqyl4jZmWjQNoL2q7AtkzzTd/unYfDh3MQNhlnDJcUK13C4pKbdIcvh7Wjvh3nwfth+eeirnNsxhuNYOBIgyL1mQTGzNRqJFc8Of0ukgkuEoOKuiR6niMSu+3PeeejNo6fqCgMVxOh2HBcqe/smxbcav2l6Eg+pqW/DQlPCEofx5sLgVMXddNZyXC8UkhFLLIA1w35p5fuU3DHZcrRLACDN8Pp7SglUQni5Ng2dHK5cdIhCxiw15YO5ldlFVcpdO6QfdVUBBSEQ77o30=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/8/4 15:19, Ismael Luceno 写道:
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
OK.

> 
> I'm not aware of any system with an MMU doing that but, I think on
> RISC-V it's implementation-defined.
But resitriction of 4K can NOT prevent cross-page multi-byte reads as
well. Say if the phdrs is on 2K offset, the size of entries is
larger than 2K. Right?

Regards
Yin, Fengwei


