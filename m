Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DAD3FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEF6B6B00B1; Mon, 27 Apr 2026 14:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0D56B00B3; Mon, 27 Apr 2026 14:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E396B00B5; Mon, 27 Apr 2026 14:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFEDB6B00B1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:21:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 471491B7F37
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:21:23 +0000 (UTC)
X-FDA: 84705153246.27.9C3D0D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4B9904000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:21:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J2scZpbK;
	spf=pass (imf17.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777314081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRL0edEqnjRKMMuAf8kNDWGdxE3K4+zobIK6wBqidRA=;
	b=oiRmNdXT0KCS16aTnlxdsXNowuu1FgMO4+KQZ1zav3kuj6P53YOSCvGFRMMcv+/vf1MHp3
	JD96GAUTfbiUfdkyZV/PDlu/T5Myv93+4PLleAvHl6+zfiHUC2J2sonyYOiFdv9qQhNQOX
	RarXZv7Xs8OBjzNMCK44W056ETrwgic=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J2scZpbK;
	spf=pass (imf17.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777314081; a=rsa-sha256;
	cv=none;
	b=5U3pYvAS482GjYkWCkSEavmO+Y+x/rFlCp51Hf54qRFdp/SwOpXuRNZ5zmvAltYycIIObA
	61W+rufOyisp6PrbqAAtmYtRzELIdtJxPKnQXXGZqEMapj3eZZtvJ01vqx5N6DMOy4oaBS
	z2wvECTCM+92KhFxugZDRP8fwpVXmU0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46E9540246;
	Mon, 27 Apr 2026 18:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCCFC2BCB5;
	Mon, 27 Apr 2026 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777314053;
	bh=fSfdZ5/fBIJBn92+lTQ8RknrFiSruKk4Zm5FPbyuhQI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J2scZpbKenpOejPaCkxdr8Fr6c4RornKyxLjF0dKFYhSlw+matCdj3SDWlLeqEo9E
	 a373XI9Iold2YwxLkAFI1OVkbxbR9JLgxu/comiCZJeBJjQK8IiPFbF3a0OQIu5zFJ
	 z32D8XDVz5Fo00XfpR09lc3WO+fPx7ont3FOA+TL4jxGM7w1J5Z2cHWcv2Vi05coRU
	 6lIPjD/Eh4XtMiOh4PUlJfQ+hbcnF50oIaF0Y5is14Jb9Uy7pNbq6e4WVWxwPn3QZF
	 F5175xYuXBtUSK+HvgeuPZTDTXog5e6524IUP62vgqpWl/U/vR5Pqvo+DbOYeGkne+
	 cSOzK+yVIhXWw==
Message-ID: <63a4d0f6-0eb3-48cd-9f98-bf7b223b2606@kernel.org>
Date: Mon, 27 Apr 2026 20:20:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 David Laight <david.laight.linux@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 dmaengine@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
 linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-x25@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-sound@vger.kernel.org,
 sound-open-firmware@alsa-project.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-arch@vger.kernel.org
References: <cover.1777306795.git.chleroy@kernel.org>
 <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
 <ae-j2_QirCySZD02@yury>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <ae-j2_QirCySZD02@yury>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B9904000F
X-Stat-Signature: 31teoehcxwwbh8yerh6og9twp4mag6rb
X-HE-Tag: 1777314081-923993
X-HE-Meta: U2FsdGVkX19xorvlPH++of4uHwIJb74XAVQVj8Ys49x6BiObbg0FchzfKzq1vIrbmY2juBa6oocI8qsRkUygLxyPRSYUF+GQJzXSHUa9bwDOPMSY+jhPn5gWkHz2ji4Yif7/gFURsT5wW/Z3gYIiWLAJAX2uSXNFdYcCYfDDegfdETIpRADngBXtkNnQwVST2DJXezDNNcNqO7CRj4o3nmAKrCWBTyRymQzm9mjXO9UhdJcuHFleGnAcyom+SRR+/tZfU2E6ezVROY6EMY7SbZa46N/dtyTwiIjOZZjzRKJ3M1RuJ6LyWjD60AcbqfcwrgQD/2f6b8WpxvIKwa2HZp+kmOCVDxsv6b6sQ0E6B6eIoNH6N8lBVgzai6L85eoo4QRXAhQI/Dm3yIHs7/JvaRb5VPtVQY7sEYk5HUHkyO0jteVn1Eq2jC0QXIo9eYVuc0hSlXqRr5RT7DVVeytDUBJ0grOTzrBIpxEOyD37u3lb9zFNKCAg4UNxxvztvIo0P3Lw1gWFBQaigVVeS5701ulmy3fYqQsYGwoieCgGVF+zs1UDGiGyLOuoLY0Vli5POMNswbGUjCW2pElQawHe+okVn+11tq+eOqCNOSWOBixQwJM53MIO0/2ePxUzqE6rZHJyCnlk8zyAmXxMzWdBQdawFA7WezO7BIhUlRZTM7r9Y9W7a8xqK1oYvS33DjvOTYLGkiCfe/kgjN2wi1v4BRwOOTn6u4w/0nD7goHU19m64mT1tGDKXkcDB+jdorLPd7Ut7ak9QlyeBtSXTsBmjbbyUguxTHl7Xp0AloFjtRak0wKApj7Uh8VvtBtkwtrZlEtlfrVK5VxpgGhVUTeZBs7cgTFGOIQhxpM+xtUGkcJTnn7voy+ITeLS8Z+Vr8ruW678dddC0IJSikxHfKjmXwA0HIXa9J06Ej5sP+QI3Zyg1ziH7WAH5b5/2yAkDoqYMKeGDH+E4+VXND5VoBO
 S2w3hMU7
 K9sJbbjccgI1dGr1JbYaa9ONxe97ouGI//o4THeTKPCj1hMHocLlA8ziCJzoNdkA3UKjKPEjhYvYNk3sXWrMIP1EUedqMGw6i12q79xaaEur2mlA7HMMvJ9cpzWZ0a+pCCMdU8NUPCCBHHCY7sMaHTjI9vXZrWBm9HZkUcWV6XbJbfQWT0mD6dSuLe4dlDlXwzVFDoYi4iN3Mhaazmhq9uRj0ULqn9Uk4uQm8DBBWJbvm7x7yahGP/JGTKmEziHaNPpbljz+k905yOVMPJ3IUFnvxV3VXEtOriBAEBvSu47WjcgdSSbMxiUXeSLrPihoI7nvpKXUGyvJwO17zSRmf4VaIBdD25ljHUjbgp7o45mUmlGiidrssSP2VNXQYc4ih2dWnmcfWdprKrkt+KrX5oLQadguLMpFh7hFGMXlGT49+SDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 27/04/2026 à 19:58, Yury Norov a écrit :
> On Mon, Apr 27, 2026 at 07:13:48PM +0200, Christophe Leroy (CS GROUP) wrote:
>> At the time being, x86 and arm64 are missing unsafe_copy_from_user().
> 
> No, they don't. They (should) rely on a generic implementation from
> linux/uaccess.h, like every other arch, except for  PPC and RISCV.
> 
> But they #define arch_unsafe_get_user, and the unsafe_copy_from_user()
> becomes undefined conditionally on that.
> 
> So please, fix that bug instead of introducing another arch flavor.
> We'd always choose generic version, unless there's strong evidence
> that arch one is better.

But they both implement the exact same unsafe_copy_to_user(). What is 
the difference here ?

Should that function become generic too ?

Christophe

> 
> 
> Thanks,
> Yury
>   
>> Add it.
>>
>> Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>> ---
>>   arch/x86/include/asm/uaccess.h | 29 ++++++++++++++++++++++++-----
>>   1 file changed, 24 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
>> index 3a0dd3c2b233..10c458ffa399 100644
>> --- a/arch/x86/include/asm/uaccess.h
>> +++ b/arch/x86/include/asm/uaccess.h
>> @@ -598,7 +598,7 @@ _label:									\
>>    * We want the unsafe accessors to always be inlined and use
>>    * the error labels - thus the macro games.
>>    */
>> -#define unsafe_copy_loop(dst, src, len, type, label)				\
>> +#define unsafe_put_loop(dst, src, len, type, label)				\
>>   	while (len >= sizeof(type)) {						\
>>   		unsafe_put_user(*(type *)(src),(type __user *)(dst),label);	\
>>   		dst += sizeof(type);						\
>> @@ -611,10 +611,29 @@ do {									\
>>   	char __user *__ucu_dst = (_dst);				\
>>   	const char *__ucu_src = (_src);					\
>>   	size_t __ucu_len = (_len);					\
>> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
>> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
>> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
>> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
>> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
>> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
>> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
>> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
>> +} while (0)
>> +
>> +#define unsafe_get_loop(dst, src, len, type, label)				\
>> +	while (len >= sizeof(type)) {						\
>> +		unsafe_get_user(*(type __user *)(src),(type *)(dst),label);	\
>> +		dst += sizeof(type);						\
>> +		src += sizeof(type);						\
>> +		len -= sizeof(type);						\
>> +	}
>> +
>> +#define unsafe_copy_from_user(_dst,_src,_len,label)			\
>> +do {									\
>> +	char *__ucu_dst = (_dst);					\
>> +	const char __user *__ucu_src = (_src);				\
>> +	size_t __ucu_len = (_len);					\
>> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
>> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
>> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
>> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
>>   } while (0)
>>   
>>   #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
>> -- 
>> 2.49.0
>>


