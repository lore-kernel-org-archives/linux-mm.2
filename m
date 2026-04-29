Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63F7FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100076B008A; Wed, 29 Apr 2026 06:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0CD6B008C; Wed, 29 Apr 2026 06:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1CE6B0092; Wed, 29 Apr 2026 06:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC8F96B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:25:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8176FA00B7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:25:39 +0000 (UTC)
X-FDA: 84711211998.05.EA1E8E3
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 223AAA0008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:25:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=syDuJ2eb;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777458337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ubnPqyEuUH+bb9tWP9+TOUp+n6C5onOR58LCuBDEiw=;
	b=6+KFc9LEwzKx9e6cZO15QzhdE8ItsRnoYdgm5OmLL+qgFgeWYyvGTiBv1d05KHIUnePvAw
	yvLDyYOZNmlpn1cOJCq5reHDLgly6SVB5bpqpsFsfEV49BwYBKuQarGlXBpaBizl5lfHRg
	P/VwGrAN/QYJdOklHgUS3ErXfRERiiw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=syDuJ2eb;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777458337; a=rsa-sha256;
	cv=none;
	b=JVyNPYuyByn9AW/TXEHnuA/PXDfun2j6tBbMDdFGlcXjfZU+BkpdhPd7QScEhUK9GiA9NY
	S/tigSI2icTeq0trORys/S67mt9yReVB26mcGWYNKwUJ2b8efiOZ/eJjcnQVyh+wbuEKk5
	3V23J1h75hsGcp1ltdU3j45zLTySrWs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777458333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ubnPqyEuUH+bb9tWP9+TOUp+n6C5onOR58LCuBDEiw=;
	b=syDuJ2ebh9z2sjffREH58o0aT6Ajjew8W5I8ReEUtvp2EQkdghmYv8iT9JcU1iX87oMIbX
	D+xmbMoFNHgWVKDoL6XEe6kPFjJgAeA5FQrv1tK/6uUbSyjmFqItMdxDS/n3eJA5ihtrWC
	pDy1LXDxeyfrSgRVjezaD0bM6Fa+Scc=
From: Usama Arif <usama.arif@linux.dev>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	dmaengine@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-fsi@lists.ozlabs.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-wpan@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-staging@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-x25@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-sound@vger.kernel.org,
	sound-open-firmware@alsa-project.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
Date: Wed, 29 Apr 2026 03:25:19 -0700
Message-ID: <20260429102520.1617327-1-usama.arif@linux.dev>
In-Reply-To: <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nz186cnqw4adp7e7gu1u565muztqf5a5
X-Rspamd-Queue-Id: 223AAA0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777458335-103334
X-HE-Meta: U2FsdGVkX18lxFZJODhWQPkrAApNumTNiVYf1O2mAF7PgR+zpCDPe6bt694BA8+t/650s9CDMW3vulP58clV4wG594JQqH3FzmEuGYOLoeIusAFeLBcJZk9jSsLilg51NY0+V7upKUBczm6sqahYJGJe5gsk+gCBoop7LQFtFkzUehDGlc9KngLFURvS0FAnjFqkV1CxyiCkiM6JOS0fXJcD/uVJFZRf1bDLAG2RHhO3xMb4kSAqfsWhh60LD/oDkvZBiahAEkqyr7BBcctiyR6+4UZdkgAaZDsBi5kl/oEACFWQB/IIBIZzwhDdN0iWif50YOEY8SYPv1EVdUwPnpIwQqh55fg2xKGq+rzkeIEltQfGYIw/0G+0/NniixWwNVW1YJ63c762hPJUwW7yfGeSYZpN+Y4ZRo1z3IF6pR26hfOpX47AeHEafSYB3Jqg8WThsmXNQwIlxN47VFLfhAGv4KMBB4wunweP0z/NoxWjk7lFp+TzzaBcnFEQtS62yfbh2ha32aBx0nVZ3cJRHm/VFiD3ONJ2d5Ri0koKjN2tG0Z8Wc0ZRop0CROubx69/we8kGWyofsGOdyd+TkhVraU59bgj5EBKnt/zds/MbhaDfn8yP+gh4u2RohoCaUhOx/EJCDHJMGJllV0rx8yA2Ej++YntUDhFSof5JDjr2mTgvodiuQyWJCyfqTX0uH5ektbj//SNiA7oI7+5QTTYWRoYH60vREyjInKUdBzutmzCnCwpbIGUnyzWq8qrVNNI3MHWpllXPrzAW4ua5Ku0fuRB5F9klxInkPhDUEsTSVtHqBILB0Z0eeLdjEa12vD1CmwschqKAbBoLsdu04S1Brx2in9XwRD6TxNg15TDwmPjb3oqGLl272oUXnJ0gQ0EW/cviX7R74nlyuakSnrN4GbnR1leXKC3+CpSIP697w/H/PJ/oTs9bRHBAvKcrCLQ22fqAZjxE4fbaHy0Fe
 V8eirOQB
 2YUA0tAmIF1Z5DVYx/leURSsBcVnnxPdQiH3mENLhbGXQOs0zdpG7KN/YFJBaDnCe1MWjQ/H3MzoGBioAr0wH+Yu9Iw7mHYAoxFNdqev/rzxRJqGa/EN5eq5qz/JE91b+aMHTW0Ps1nTdwdVnizHk7tC8cYoplmAB8Wuf1swPQYeqBkmgzNz2A4/0vN9RSqX0XATl1HZEvhxL3bcuBPsAa12S5gx2iUD7/qKMiA7El4sARerGnBclxvpE4PIyrYGbtPgg2fwELqhfgLuRhwor/sPZbkEjLcWmu0ncPe1eUPLHUDFW/pKGY51t3dByngSUNJlzaKFFZgyzGtYqzikAvWTiFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 19:13:48 +0200 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org> wrote:

> At the time being, x86 and arm64 are missing unsafe_copy_from_user().
> 
> Add it.
> 
> Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> ---
>  arch/x86/include/asm/uaccess.h | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> index 3a0dd3c2b233..10c458ffa399 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -598,7 +598,7 @@ _label:									\
>   * We want the unsafe accessors to always be inlined and use
>   * the error labels - thus the macro games.
>   */
> -#define unsafe_copy_loop(dst, src, len, type, label)				\
> +#define unsafe_put_loop(dst, src, len, type, label)				\
>  	while (len >= sizeof(type)) {						\
>  		unsafe_put_user(*(type *)(src),(type __user *)(dst),label);	\
>  		dst += sizeof(type);						\
> @@ -611,10 +611,29 @@ do {									\
>  	char __user *__ucu_dst = (_dst);				\
>  	const char *__ucu_src = (_src);					\
>  	size_t __ucu_len = (_len);					\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
> +} while (0)
> +
> +#define unsafe_get_loop(dst, src, len, type, label)				\
> +	while (len >= sizeof(type)) {						\
> +		unsafe_get_user(*(type __user *)(src),(type *)(dst),label);	\

Hi,

Just wanted to check if src and dst need to be swapped? Same for arm64 patch.

> +		dst += sizeof(type);						\
> +		src += sizeof(type);						\
> +		len -= sizeof(type);						\
> +	}
> +
> +#define unsafe_copy_from_user(_dst,_src,_len,label)			\
> +do {									\
> +	char *__ucu_dst = (_dst);					\
> +	const char __user *__ucu_src = (_src);				\
> +	size_t __ucu_len = (_len);					\
> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
>  } while (0)
>  
>  #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
> -- 
> 2.49.0
> 
> 

