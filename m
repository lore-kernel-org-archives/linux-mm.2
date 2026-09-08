Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69115C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A0E6B0099; Tue,  8 Sep 2026 05:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861636B009B; Tue,  8 Sep 2026 05:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777F46B009D; Tue,  8 Sep 2026 05:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59FB36B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:01:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6DECA04C1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:01:14 +0000 (UTC)
X-FDA: 85190000868.23.7EF98CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3BF811C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:01:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f83UuFnG;
	spf=pass (imf21.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858073;
	b=OxOKHflz2iex0ShQwANQJSjW/oGwexZBaYvgUyrKVliUOhQ98Y0DNOBty29j4BqlmaEyiK
	LLz2/HpGo6asqFdMFbh6n+WLpSefp85z9mUucwZqpauSdN3MLD4hYjOfO+0up3QJlXNdl2
	m7wraIGJ7CufLNVGYzvcg4/amXB6iAQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f83UuFnG;
	spf=pass (imf21.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gw6uq3WoFDGFRXHX5w46jvhy16/noKc2NTzTXodoE8A=;
	b=CekpMPZV0RVoD4qEIBYD3Y+TXbodocXuWB1DGQ4IiEa2VOFXMgLl/4wCsRxO/eIq/aYtTw
	kme6/uO/ZT5lxLaHqZqZNridh7Gbzts8N2xCN6SnEzUKjoxNXpBnFtqsC65+aVowLn4wQZ
	PPdYjj+t7o+H7OpKFpHx/dUJVnb7xfY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2F2A60A9D;
	Tue,  8 Sep 2026 09:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32141F00A3A;
	Tue,  8 Sep 2026 09:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858072;
	bh=gw6uq3WoFDGFRXHX5w46jvhy16/noKc2NTzTXodoE8A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f83UuFnG2Ca/NIEjfDrXHeoFRlnHHZpsg6wFetI10F3cQyUjArbK42hgG7Zxex4/s
	 3n5zZu9KkJ8dQxHTmVqB83udBP8YhBTSDsyRdMErALYpUYjulzhr6oGyq5X7IeS2MN
	 EWxFsYnacMcuz5tJFBTbZAf9tMz+RnlOTNhnRLhdadOeXHk0h+wn50SECkFRbxVslO
	 f7Ig1YtXoYtaZhrD1KEcBCtAna7hL00y1ZjgmW4/d0yWZBbhpb2lMH7Bv47zh1k7nI
	 CEirgVNGd9giuxhLxrRDAZzVqimdNslxWSYeJo/LDlSLy8epheEmJ4uqQpNMU7Oumx
	 oYzy9KZ7DvXJQ==
Message-ID: <060be36f-5e8d-4596-a4e6-844e5930baac@kernel.org>
Date: Tue, 8 Sep 2026 11:00:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/24] elf, uapi: Add a header for relocation constants
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Nicolas Schier <nsc@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
 Arnaldo Carvalho de Melo <acme@redhat.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-1-3a93791af1cf@linutronix.de>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260908-vdso-absolute-reloc-v5-1-3a93791af1cf@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3tj87rksg6xta8srkino6ox5w4cuk7ej
X-Rspamd-Queue-Id: 3BF811C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788858073-988670
X-HE-Meta: U2FsdGVkX1+kkkC3yeZnAVIph6LnFa3l/92YpSxtTepNDLRjKLy2S5D4FvV39JlTc+B/mmInEV6Kfm/S8CkFlZNmcdFIWcjN/BL19yBYbNAkXwSxqsE7erDE38V7if1wqACgtupOylyReYlvOeaSxq6Kf9lVdVckRO8yuW9P1J8aLtQLGF07vve5x2H/DpfigOHlkC1+kHOWHr4p/QKbshDZdzZnMrd21P6r09ggQdkRmhTDdwVr9s8GFu4Mgl2X5TaCHHM0dNF9VbGLN4QuagD3KFBziVrnJGxDl8MHybA+mmaQ6nC0mS/40lXNAbsY0h49DBMGNLQmu4to6hkUY+lPyMLALvmyckq+WZ0+JoSBe6m2/Rfap/+QJp4G10bSgkeB9QfVhJZYM5NX8KI5OFBqSB2VOI0tWC73JLXGsruMevjnVsVE15zyznE6GbyTl/rgVg1bXbrba+PLo5jRUD8CqHdzQZlA2U1vrc6OVmgd/UpGdwadCjR8G/d1jlelsr7W3nLk41Q+AIj3aIMIiRfJZ+VvaidQ8ILk13QhBIUbeeE6dQL42/spcY2uVwNQFdjZ3wrd+ylFb3KEljqVFlP5kJPxGFdnSISd4cb6zK+EVUDpkDR97O7h+YfwCboM4a8wslQ9S+8Z6DmDbDwwEuBX7g+21MgMh6wwZusasR3awDhI5wrjmYK9y1y0z+XycmenesKDs2WGMQpEkLHBW0Poi14tL5bdWQojyNwf+qRuj2ixKqKAw9gNHQfzCpEq93pjgUY/MhvkFOeKV70BT0AfFd7Okf5B+Y/P7nR8Fkb+SxDRsqgpyx02lnajWCKfPiTK2pHAD+IzpzVpOKgmWZg8Qb8FtJZRsJBBVU+TLVGI65kiyP6oDkhWuX0ZuxQ5pZKbmQ8i2818ADJJXTfz/S5omWp+RcZUVn0kHXw4wco/TWJODEgqbXiVfjiuXa6yRc4Gh7sS5RE0e7ZoU2X
 vUqNkA43
 MAJgKZX9q++4DWqyfGOVtazTllBFOHd7klu4HvnzPSfcQodNVuprmr1y7Y1Ff5TiAkj0YEGhxMel+/DiQoTEorVcZ6eY5ywNQdcZTedMLekIwvib+0ksuHODZbZ+0qEhQLCOTtHsmgbsD468gBnWnja2pJiY+ATmQXYB9PzVudi/acDhaMdE+SuwEdmOWyRgnwMwU8jjw8HS7d1iLM4XwsjwxHxRq1EARbxxPDdBq8QesqegnXK3Cw3P+f4dwxOcsz26gxirET78oYDF3yWP8sLbAhJFLMnQs0fCPgSMIQO1vICgzvj/V5rZwJY4bJjNRmVIpoYAz9oNI57V5itwIZvvrIa0j18yKGLiSI0lj6zROq3QY8d8XlNOH+BTZ3sPbdZzFaPNtWQNPzQPmHhHpKcA9YGdxbvUhgPlVvVuQBwVmrrHYwnzeITgNV67t8el6i+rtQqEzJSWXLQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 08/09/2026 à 08:33, Thomas Weißschuh a écrit :
> While the numeric constants for relocations are architecture specific,
> it is still useful to get access to them from other architectures.
> Also the definitions are useful for userspace in general.
> For example tools processing elf files during a kernel cross-compilation
> can make use of them.
> 
> Introduce a dedicated header for them, similar to the elf-em.h header.
> For now the header is empty but it will be filled step by step in
> upcomming commits.
> 
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   include/uapi/linux/elf-r.h | 5 +++++
>   include/uapi/linux/elf.h   | 1 +
>   2 files changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
> new file mode 100644
> index 000000000000..2c382c8a4807
> --- /dev/null
> +++ b/include/uapi/linux/elf-r.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_ELF_R_H
> +#define _UAPI_LINUX_ELF_R_H
> +
> +#endif /* _UAPI_LINUX_ELF_R_H */
> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index ee30dcd80901..b3e312255552 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -4,6 +4,7 @@
>   
>   #include <linux/types.h>
>   #include <linux/elf-em.h>
> +#include <linux/elf-r.h>
>   
>   /* 32-bit ELF base types. */
>   typedef __u32	Elf32_Addr;
> 


