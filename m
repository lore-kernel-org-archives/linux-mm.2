Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C0A6C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C596B00B8; Fri,  3 Jul 2026 10:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3E86B00BA; Fri,  3 Jul 2026 10:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9B26B00BB; Fri,  3 Jul 2026 10:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18F776B00B8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:50:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AA7EC0841
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:50:51 +0000 (UTC)
X-FDA: 84947752302.05.7B84A91
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id A672A180007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:50:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UDBNB8/0";
	spf=pass (imf16.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783090250;
	b=FfJOeIMb3K/i5N5acbc8MPscOGmmKUeeVtltdmEGH4/y712tkgW2DnoVAreXh251NC1Uua
	7bR4V3MuM7gP6q8jaM54qaj4V6sN8JZyNT3DQZ/nIG2tzmPYlhQIu6lszw2pVBRja2Czjh
	emsJSeeA2STuiXvBr+n4gWofEUHJYz8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783090250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXlZY4gPG+zU33k3H0xm4g/0VaNA0tr7HNt5303WUBg=;
	b=NiCBbyEkHNoPENPqkTvADi8s1+8LJRoQbQNK3FYN383hcyZOkxK81zgwbi7hVs7CWit05v
	5uJ0iG58bF/045qh2YER+e9Tpgfjbqnn8YCXz5XnQtXbBhW7Bcnx5TxjXloYttB0ZrA4Ro
	7fA8MxaWobMBoPb9sX9/wZXC2cKxPwE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UDBNB8/0";
	spf=pass (imf16.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <8f75dc18-dd4c-4989-a76c-eec6cc513ccf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783090246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CXlZY4gPG+zU33k3H0xm4g/0VaNA0tr7HNt5303WUBg=;
	b=UDBNB8/0B1x3/BrOa/t8tH6XYsteLhqIKb6sFPxo+8voiJoXwSGbGVTm7m2V2fKjxbZfG5
	wYXqGIpNv/UsD7//6L9xKs/IvOligQC3lhghGNicG75MZUNKdc91kSBysgQAuIKoLqiQ3k
	zeQenTliY3QJ+tbtFUjK7MHFfZ7WXFo=
Date: Fri, 3 Jul 2026 22:50:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Alice Ryhl <aliceryhl@google.com>, Douglas Anderson <dianders@chromium.org>,
 Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>,
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20260703022507.187457-1-leon.hwang@linux.dev>
 <akeDk49-pPgUDek1@pedro-suse>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <akeDk49-pPgUDek1@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A672A180007
X-Stat-Signature: ig181rgobgszb6gwxmiat6j59ktnfn77
X-HE-Tag: 1783090249-991430
X-HE-Meta: U2FsdGVkX1//DmtG/oU329uTvW+iRfQ+nCeIdaJ40y3URdeRUYL9Ak81vkJG8xWNNIZo3NJCEoof2kX9WKWc50xJrZFs8rt/RJfAoipDuhQ/7dtsVd0svuTzcNv+cYZX63A6S2u7OCgqN+Nklcny9OAS9+GvpszQKCPW0APDbaEkioTISLUnievCq/DVsaAQprdLDjtleMWfU4IyP3P1925S8C9YkTTCkxHrIUNWNvJdLyKbYHDzmji7Jdq0XZ7a2MOSPgL4SmgAQCe7Wbqtetogop5mn3b+GRDqK4yMAvYDYXmdDVyRCegE2TjkHyIxPi/mI4d38RUni8swAYHCPNx+NUgmN25TOBCQhHm+6yCtwF9evGEj4v946m1dC2WYTp8jydk2ll/YCshTRGEYH0wMCvTqavsMhtSprsdiurjX90GTvn1KStIk0/Ip0KqFpJT+CttfYrGmlST6hu7WJgFT2ZzsCnRiw5jAxhcVUdBTZ4v0PhRPYhPux2cKvs63sImHfWw+Y4MiYIcM9kxMjxKDf9YcWDBr8s3uudBV5l+q+KYhShPkbup0rLIulf19+JgPA5JVyfjJIQU3519CoQ8Qc8pGeJw80FH6OhbemQqzlcnKqPvAZgwFx+N4jEEDQwuioipKJdfh6nTXJa/hHF0XP8vQbsyXpTJ64AwEhDnZe28nhwjx9Ul97JhFofciH/AxU8B6ARhoSMYfmuJKPrn/eIXW6VE0K61RX9YDP3ZB5/1TnFuDMF6riUzT8KiKiX4NV3hs8aFLZbO32og/AR1tuQ+qJrn2rGf9Y9ScNOm+s7PecirdLmZoKlpAVqgmpJqe1nwM1n9Q2Kd9Vjem0MyXTKazI8wErgm1k1E0uiRNvxe0NURT1yZXhAQk5L5uTmqu81wJf1OmMV8nlZ/S47dGNSCZ8e0JUcJkTKyLcHS+0wvilUEA6J9LqmNPSifvp1z1x6CfkoewCpSzy+8
 lbgqC1L5
 jqfu0GSOayrELrW1HU8rwBNhxdh3lUOgYOSebo+RS5yKXMtCttTDKHTi3KYn3ZI0v41LnPa6DrpVk3MSj5Rm0ixHwLyweNBZt4BoLH1wdA/di1uEz/inuu0FUPikaszeBTJUzTxe7RiM+4xmpxFEFQGPoNyJtrdpbkEZ0AaJzm5LSn5utRo+LEtfBm/GRw+WzTC7lGJedItGHAtRsCdH7HmlWPz2d2HUgjikMc66GaNKCc68NOe5T9/pr6TqYT3JOHqaPmKEyQxIqxPiJtTQjgoS2dh9zqpY5HnXX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/3 17:44, Pedro Falcato wrote:
> On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
>> mseal.o is built only for 64-bit kernels, so 32-bit kernels fall back
>> to sys_ni_syscall() and return -ENOSYS rather than -EPERM.
>>
>> Document the -EINTR return from mmap_write_lock_killable(), fix the
>> CONFIG_MSEAL_SYSTEM_MAPPINGS typo, and describe system mappings in
>> terms of VM_SEALED_SYSMAP.
>>
>> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
>> ---
>>  Documentation/userspace-api/mseal.rst | 18 ++++++++++--------
>>  init/Kconfig                          |  2 +-
>>  mm/mseal.c                            |  4 ++--
>>  3 files changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/Documentation/userspace-api/mseal.rst b/Documentation/userspace-api/mseal.rst
>> index ea9b11a0bd89..1f1cf206670c 100644
>> --- a/Documentation/userspace-api/mseal.rst
>> +++ b/Documentation/userspace-api/mseal.rst
>> @@ -50,8 +50,10 @@ mseal syscall signature
>>           * The start address (``addr``) is not allocated.
>>           * The end address (``addr`` + ``len``) is not allocated.
>>           * A gap (unallocated memory) between start and end address.
>> -      - **-EPERM**:
>> -         * sealing is supported only on 64-bit CPUs, 32-bit is not supported.
>> +      - **-EINTR**:
>> +         * Interrupted while waiting for the mmap write lock.
>> +      - **-ENOSYS**:
>> +         * The kernel does not implement ``mseal()``.
>>  
>>     **Note about error return**:
>>        - For above error cases, users can expect the given memory range is
> 
> Honestly, this whole thing needs to be deleted. We need a proper manpage.

$ man mseal
No manual entry for mseal

When searching "mseal manual" using Google, this doc is the first entry.

So, this change is worthy.

> 
>> @@ -62,7 +64,8 @@ mseal syscall signature
>>          memory range could happen. However, those cases should be rare.
>>  
>>     **Architecture support**:
>> -      mseal only works on 64-bit CPUs, not 32-bit CPUs.
>> +      mseal is built only for 64-bit kernels. 32-bit kernels return
>> +      ``-ENOSYS``.
> 
> This LGTM.
> 
>>  
>>     **Idempotent**:
>>        users can call mseal multiple times. mseal on an already sealed memory
>> @@ -131,20 +134,19 @@ Use cases
>>  - Chrome browser: protect some security sensitive data structures.
>>  
>>  - System mappings:
>> -  The system mappings are created by the kernel and includes vdso, vvar,
>> +  The system mappings are created by the kernel and include vdso, vvar,
>>    vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
>>  
>>    Those system mappings are readonly only or execute only, memory sealing can
>> -  protect them from ever changing to writable or unmmap/remapped as different
>> +  protect them from ever changing to writable or unmapped/remapped as different
>>    attributes. This is useful to mitigate memory corruption issues where a
>>    corrupted pointer is passed to a memory management system.
> 
> Also LGTM.
> 
>>  
>>    If supported by an architecture (CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS),
>> -  the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
>> -  architecture.
>> +  CONFIG_MSEAL_SYSTEM_MAPPINGS seals mappings marked with VM_SEALED_SYSMAP.
> 
> VM_SEALED_SYSMAP isn't meaningful to userspace.


Got it. Will drop this change.

> 
>>  
>>    The following architectures currently support this feature: x86-64, arm64,
>> -  loongarch and s390.
>> +  loongarch, riscv, and s390.
> 
> This is also useless, every 64-bit architecture will support this.


Do you mean dropping this sentence, or this change?

> 
>>  
>>    WARNING: This feature breaks programs which rely on relocating
>>    or unmapping system mappings. Known broken software at the time
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 5230d4879b1c..12bb39f637b1 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -2112,7 +2112,7 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>>  	  from a kernel perspective.
>>  
>>  	  After the architecture enables this, a distribution can set
>> -	  CONFIG_MSEAL_SYSTEM_MAPPING to manage access to the feature.
>> +	  CONFIG_MSEAL_SYSTEM_MAPPINGS to manage access to the feature.
>>  
>>  	  For complete descriptions of memory sealing, please see
>>  	  Documentation/userspace-api/mseal.rst
>> diff --git a/mm/mseal.c b/mm/mseal.c
>> index 9781647483d1..0464c7b94ab9 100644
>> --- a/mm/mseal.c
>> +++ b/mm/mseal.c
>> @@ -132,8 +132,8 @@ static int mseal_apply(struct mm_struct *mm,
>>   *   addr is not a valid address (not allocated).
>>   *   end (start + len) is not a valid address.
>>   *   a gap (unallocated memory) between start and end.
>> - *  -EPERM:
>> - *  - In 32 bit architecture, sealing is not supported.
>> + *  -EINTR:
>> + *   interrupted while waiting for the mmap write lock.
>>   * Note:
>>   *  user can call mseal(2) multiple times, adding a seal on an
>>   *  already sealed memory is a no-action (no error).
> 
> And this whole header needs to be deleted as well. No one's looking at
> kernel code for documentation (and if they are, we did a horrendous job
> at actually documenting the thing).
> 


Just to confirm, do you mean removing the entire function comment above
do_mseal()?

Thanks,
Leon



