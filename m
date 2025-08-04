Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E2FC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 02:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF226B007B; Sun,  3 Aug 2025 22:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0873D6B0088; Sun,  3 Aug 2025 22:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06036B0089; Sun,  3 Aug 2025 22:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E16EF6B007B
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 22:13:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 749031A0B6E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:13:10 +0000 (UTC)
X-FDA: 83737452540.11.CEA9200
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6FEEE40003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:13:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oyL7WSds;
	spf=pass (imf04.hostedemail.com: domain of fengwei_yin@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=fengwei_yin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754273588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOhE5iGHrZ4xjSv36/UXuUcfl5os1bpqTbIaxe2NUiE=;
	b=DYHMhgdRQUHH7KOwyyf7jEsaVz5DQICNZ16kbZkZ/lpMsdnYhH3PQWiXhXa59yX69MVTMH
	ho/iugAotK4ySazWFAxWmL+npJrGaw2GQFIZez6e/VNoYC4KqX+dxWR6uxUtQVjqc428E5
	QQLUiJYfV8ONx6s2+2AkHgzSZMd6oqA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oyL7WSds;
	spf=pass (imf04.hostedemail.com: domain of fengwei_yin@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=fengwei_yin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754273588; a=rsa-sha256;
	cv=none;
	b=zycMT8AIHrGu4BJBYsb8jhq4PfDaLxXgwIAaNQX0QgmNwvOVjrmMdFIMZzREjPnrRBhYVB
	xMyv5Vf/B9K/oZMfyLrWhsmDIEnVotpw45Cqzqx481b7ES4BlrkmrHk+nk07uF7UUgsS0y
	rVM/r0iK8DFswXUsjq60mEZ11t8vO5I=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754273584; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fOhE5iGHrZ4xjSv36/UXuUcfl5os1bpqTbIaxe2NUiE=;
	b=oyL7WSdsoFW8AcvsoBs20GmwdhpKnTokq85VhGMQENTGhvMaxlwOW8YFNzkL8uyVcDJCAZxjHUk+9fLfglDczI7xbFNRURtOCpzXqvKWWCFb6GfFRuEBqO8D1AKdLGbBHWLsqGp2+WEOfaneKYESQzDOQ0qyOWKdIIVMHXiVpw0=
Received: from 30.21.176.60(mailfrom:fengwei_yin@linux.alibaba.com fp:SMTPD_---0WktbLhr_1754273572 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 04 Aug 2025 10:13:03 +0800
Message-ID: <6653242a-5b08-48ff-a126-9e9367633420@linux.alibaba.com>
Date: Mon, 4 Aug 2025 10:12:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] binfmt_elf: remove the 4k limitation of program header
 size
To: Ismael Luceno <ismael@iodev.co.uk>, Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 zhourundong.zrd@linux.alibaba.com, fengwei_yin@linux.alibaba.com
References: <xd6zp5ytq6iakxkqoqqtseomgu5oohau4ynj3xbo7ejohpv7dv@skp2v7awzab4>
 <aI2KQaWpPLSAqdXg@pirotess> <202508021029.7CC8B334@keescook>
 <aI7zDXb2VpuaHHYi@pirotess>
From: Yin Fengwei <fengwei_yin@linux.alibaba.com>
In-Reply-To: <aI7zDXb2VpuaHHYi@pirotess>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FEEE40003
X-Rspamd-Server: rspam06
X-Stat-Signature: wcokg1gs5sxdbo7r7zfo4w7oepi1k8hm
X-HE-Tag: 1754273587-883901
X-HE-Meta: U2FsdGVkX1+oG/kbG0NIocEjIVW4vzflGD852mh+wKTQ0Vpf0P74kB5s5P5rS2u+5BDuVuRsbtGh5vdlUaAnn5f4bUQtVxskaJGwpkVZHI7cY1eElCyNRl0qhcwAUk0y9TEQDBkH/PY+e1FBQZbZggXeOEGiEKEG6EV/38MzqEL7Qj49ekI0G9J00Xq+Nvxyl75amRDtDS0Bo4rN7wJ6/JIR/l50AP9Dg7f6P1T0+7KubCGZUIPYodHbMPWc1QTs+LgOrjEy7J7N/UiP/08Hvq0RIZS0box0kP7D+Md8HB3ks2CxqCoEw0Ox4kRCnH1rjy/ocbOQJlm236/4hBry+tFEUkml+jQoO/XICmjSWBYWPZ5ijYX0EjCqPtmPmxbJqMljbd0Ht6C6hp7rNpx2x9mTO6lmy5M0BCkkN1HNdyovZc8oQ5CGJS674EMaKuiwUs8klcG20xy3P1T1xHEWBp8+Suz6yM0DzAix6gOan+74+ICE9x4VCxt1zunrsVGVAPB2LwtHsAgtLzvuW8vy05r12ImK0IrF5Av6ATUTZNkATiaxTrJBeEciIwRJlB9phz9y+A5ezo4yQy1DAXEv5tC4BVIIn47G/Wwg9s03o20FCU8oG4keBEhzHyPPzZuaeuuZRFmmaSgMA2aC0thBJLWeadZR3X4VMG1Hz3pqrfS3nQ/TbdC3wlet5sbshWOIOwX9/kJF/31iVf8rzcHh6AJa7A7YV7GZiTdTGjznQa9qfOOejMKqU6tak122d9QFq3yTI0VnCvGrOeJOp8D32hfJ+Z511G9Z4MjeVZyGX/SmvwLbo8lIislijSvQWYRUWaRPNX/OZe3PPXLD8rJ7myzAS2MvC+nVd4hz0pFJJzJYYuzGTlw2BWINAIXpK/BGzX/wpYVrZT6i3cMVaK7ux21wGldqJmpQmP92CkqGPpDwZAffDFO4yrnnsspnXMEZnwH14Hq6LG3Of+ARq5t
 lVFG8/4V
 LC13xC4ZZ3EwfXs6qtmcR6/d80zstZL2dykJsIXrBVSjkUnhRtlyyP/o5lUJmgG3A0QjgXB1iYiam0J41NJOAnn/4xBRQ14lQFRFHCWd8tFanKTFwVnF7eogJwuOlliAS9MaeOrmRVwuS4G+fDmf1Ta3LtbPJBhUL3NfGCI+z/7u3tBqTclp5zuSI5g75hAxTDp6Dylg3h7mwE+ZffYCP7y1wvhWte1z3UoYbqMdaH83JC/uPXzoKcoe5Mul52zonaiQfqPsAAxZKMjicg7Y0bShz0AGQiojhUtdqpnPAVqDLu0+N6jL9anRpIZu+mv0t4h2BgQ1scjXOa7t2lK70KwN9hkSXtS0t6Qex5HDDyeQo+ewG6GoJNrUvgOyed3U32677MM1TjnPJuBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/8/3 13:28, Ismael Luceno 写道:
> On 02/Aug/2025 10:29, Kees Cook wrote:
>> On Sat, Aug 02, 2025 at 05:47:13AM +0200, Ismael Luceno wrote:
>>> On Sat, Jul 19, 2025 at 17:17:09 +0800, YinFengwei wrote:
>>>> On Thu, Jul 17, 2025 at 04:31:50PM +0800, Kees Cook wrote:
>>>>> On Thu, 17 Jul 2025 19:01:08 +0800, fengwei_yin@linux.alibaba.com wrote:
>>>>>> We have assembly code generated by a script. GCC successfully compiles
>>>>>> it. However, the kernel cannot load it on an ARM64 platform with a 4K
>>>>>> page size. In contrast, the same ELF file loads correctly on the same
>>>>>> platform with a 64K page size.
>>>>>>
>>>>>> The root cause is the Linux kernel's ELF_MIN_ALIGN limitation on the
>>>>>> program headers of ELF files. The ELF file contains 78 program headers
>>>>>> (the script inserts many holes when generating the assembly code). On
>>>>>> ARM64 with a 4K page size, the ELF_MIN_ALLIGN enforces a maximum of 74
>>>>>> program headers, causing the ELF file to fail. However, with a 64K page
>>>>>> size, the ELF_MIN_ALIGN is relaxed to over 1,184 program headers, allowing
>>>>>> the file to run correctly.
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied to for-next/execve, thanks!
>>>> Cook, thanks a lot.
>>>>
>>>> Regards
>>>> Yin, Fengwei
>>>>
>>>>>
>>>>> [1/1] binfmt_elf: remove the 4k limitation of program header size
>>>>>        https://git.kernel.org/kees/c/8030790477e8
>>>>>
>>>>> Take care,
>>>
>>> Hi,
>>>
>>> I noticed this removal and wonder whether it could be a problem on
>>> smaller platforms.
>>>
>>> IIRC that code has been there since ELF support was added in one
>>> form or another; and the idea behind it was to simplify the code
>>> by ensuring no cross-page reads could happen, as these could cause
>>> undefined behaviours or read abort exceptions.
>>
>> I didn't see a place where that would happen -- the reads aren't done on
>> a single page. If you see something that I missed, please let me know!
> 
> The offset to the phdrs can point anywhere and the entries are
> arbitrarily sized, thus it can be unaligned, so we can be potentially
> reading at an entry right between two pages.

The read buffer are managed in kernel. Why cross-page read can cause
undefined behaviors or read abort?

Does smaller platforms have special behavior in this situation? Like
can't do cross-page read against the buffer allocated by kmalloc?


Regards
Yin, Fengwei


