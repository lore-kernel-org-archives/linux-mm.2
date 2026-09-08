Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 085F9C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ACA06B00AD; Tue,  8 Sep 2026 05:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1366E6B00AE; Tue,  8 Sep 2026 05:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0290D6B00AF; Tue,  8 Sep 2026 05:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB9EE6B00AD
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:21:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 598D3C049E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:21:40 +0000 (UTC)
X-FDA: 85190052360.04.4C2D4D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B63D41C0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:21:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xn9XtBCz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4k7jM/SARicUfiyID/Zb58FTA6TVrqfjgQqXrSbBJmY=;
	b=cr2S9IVN8URVAT6Sm8wR8BLwDf97L5sn/Wja+VdIc4mml8Kr9m3BijbSnR0E6JzJwfrZ+I
	JqUyT69wRJimmMZZ6pum3xJGtEbhM4vCKlunuDpsoQWBEcoWmVYOH2HVqPlHAM/QCRkdNn
	9e11MKeMUHSNXda/AjFzF0uzZOcEAcQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xn9XtBCz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859298;
	b=cfs17f0AIGbVX7DPDQNMQhD3yQD5AsE+kfw8Tes7lhdm8Y/62Q0Y7eErstgQne+eB5uLMD
	k16WRkS1QLJOgLXDtMZfkMDdxhFOoJ6RC04oKCm6a49vW+7GFEcy4KnkhrkScxwCSIwNrX
	UExEg2lu1KzGUvFgBMnqVDxJLOc2TSM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5366660A97;
	Tue,  8 Sep 2026 09:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E861F00A3A;
	Tue,  8 Sep 2026 09:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859298;
	bh=4k7jM/SARicUfiyID/Zb58FTA6TVrqfjgQqXrSbBJmY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xn9XtBCzNs8WX9mak5mpG8XRdy2i0zrbMydZ5LMlt1Qe6xYAL3LuxfUX8Atn2wQI5
	 1axnL/wqewpo705igfKNy8cNCn9+Zo3sUO5bgJKNWeixiHCJ40tMpOcHYPd0ztKnwc
	 thks3bDKvUFN5YfpBP21ImCqeVd4BuB9bshirgyOkT8qYPLl5IHF7GtOgYNVJtKM5z
	 OWEfgEV7HLlzD0xSV0FLDhASxeMC0R5k+YiWCZlY18vuOZyNV5jOxZq4lBnvbHCbuK
	 MWgRGux7fP8nPYbQvR4llwvXew14x5qlJam3L6qpRO9Kd3dID9dgWciFsi7Ok948U+
	 EV4LzEuy2wGQQ==
Message-ID: <9a27f318-2ab0-4f5e-8e87-daaa85dbc297@kernel.org>
Date: Tue, 8 Sep 2026 11:21:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/24] powerpc/elf: Add 32-bit REL16 relocation
 definitions
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
 <20260908-vdso-absolute-reloc-v5-16-3a93791af1cf@linutronix.de>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260908-vdso-absolute-reloc-v5-16-3a93791af1cf@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: p5t88se4zopuqwu7n31r4u83dfthzck9
X-Rspamd-Queue-Id: B63D41C0004
X-HE-Tag: 1788859298-237645
X-HE-Meta: U2FsdGVkX18fBQshQ9sJtQ5JGXkoqZJa3xtldZx5H+ik05QVx1Dfj1mxEKLFA4gIoBCrfcowOcR5adR/ASPW4lngjvKKCzOIOgpH3pFdeC8JHteySshdByoqjxA3DWMiv0v+zDurye/WdoT0+Xoq21fw5OLmIuq8dU/QYU6hP5xwmCEge/wlBFnMHp3wr3QcUdtvFxcOTi3grU9fBo/B0mtni/Dh3/wKl94jINPhhrZfIovhjOYdajwDfWhwC25Obx5rEUycIvLO+muF/g8+E+iOnLFRaVYOOYvYfD5iRT8QEpfoPrN2YFGjkVRsFRsYbAkFaP+iKqXyGvZ4xL6B5kdiyE197aFjjUSZZtIZGhxzZOH3/LglHZABTZDpPyte5GieS1Y4eFfEikt9xpFYNvPR082MojLP/L0zxSYAa9inH5CJiWeIFP1DGRAEUB16CWSZruv5vA2dUX31P9ZipSy9D2eoh5iMsulNZwxlr3d0zAVzA+mWDYqQK0MFYhcDvGaO7ZWopPKtk+nzOvgjdlgaCnjNcDzz5ssPDan9a3elZtyFOwwuQbp3ghzDoCQvQ+txtyCNzoTExLbd9mXZzG4aryRKUr5yMe5j8usowTdssr7+KPw81+eJyUyIHKWAtrwvBegQM2nPo0+w36QSHSGBcu23xeE3rUuc0O0FNI1h1rCNj4qw8Q2l7WIPOEXKIMxVmC0FKuTO5qqWcCgZvkCxIl9fLzeTeooHd+WA9Y/gwGHnl4HCuGzLjdeU+IGzNQqXpEIFbkWUtSYXF7TIIXytUsGgCL7E9ioIX6jH134MHOiR51jqI35wSpw72oC23uad/qX1nkCA5jXB3/hZx0Lz0NslkUoeKiW6ZpqYT3hmq7P2DlYaMVVomjRKOUyFKTsxzuC59jPV/q73z8B4V3y3myLw4EEgMhmUhFDQPL4av3PHbevjVlGD/Ls3qt5/BAs2Go+GlUltMxkJkEr
 I6reOnMZ
 EwlzlgVd7ivZIMIGHFTlRy95dzW7GUOvFQx684nuEbMJIbHAU8r1uqLWVRU5PP7F4dT/sfR06Tn0JRBlx9OAqapYDiVxoDmXik5mCsOTkIub50D7VH0RuxSybTd7f2GtsDYQ35pTKIR7qpx6vfsNIwNFVNxqFgNnGNlfV0MN2q7jNwBPUIKO8YjJiGUbEIM4LZoI9pSITkx5YVh9A0mjNVJLpXKKMsaNyWDmTFr2DipI/CAYLNj16eqlnNlZVHZNpozhr0C/kqx5aJMQ/NQ5zCcrQ0v5l9HGsYgOdPegIuHbWGH2rlH+DDbbZ3jeZ/ikYfqLIvBD39gS8Lk49uzQWSY7LwDepZ4Fyq639ocY5CzehB23YE2knB3YbM6XVPgW3ncGsLKfRCAAO9+UWS+pNJnD9yZZc7Jf2bzli
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 08/09/2026 à 08:33, Thomas Weißschuh a écrit :
> These are used by userspace and are necessary for the vdsocheck tool.
> They share the numbers with their 64-bit variants.
> 
> Also update the copy in tools/ so they can be used by vdsocheck.
> 
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   include/uapi/linux/elf-r.h       | 7 ++++++-
>   tools/include/uapi/linux/elf-r.h | 7 ++++++-
>   2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
> index 72fc9045a5d4..170888422400 100644
> --- a/include/uapi/linux/elf-r.h
> +++ b/include/uapi/linux/elf-r.h
> @@ -182,8 +182,13 @@
>   #define R_PPC_GOT_DTPREL16_HI	93 /* half16*	(sym+add)@got@dtprel@h */
>   #define R_PPC_GOT_DTPREL16_HA	94 /* half16*	(sym+add)@got@dtprel@ha */
>   
> +#define R_PPC_REL16		249
> +#define R_PPC_REL16_LO		250
> +#define R_PPC_REL16_HI		251
> +#define R_PPC_REL16_HA		252
> +
>   /* keep this the last entry. */
> -#define R_PPC_NUM		95
> +#define R_PPC_NUM		253
>   
>   /* PowerPC64 relocations defined by the ABIs */
>   #define R_PPC64_NONE    R_PPC_NONE
> diff --git a/tools/include/uapi/linux/elf-r.h b/tools/include/uapi/linux/elf-r.h
> index 72fc9045a5d4..170888422400 100644
> --- a/tools/include/uapi/linux/elf-r.h
> +++ b/tools/include/uapi/linux/elf-r.h
> @@ -182,8 +182,13 @@
>   #define R_PPC_GOT_DTPREL16_HI	93 /* half16*	(sym+add)@got@dtprel@h */
>   #define R_PPC_GOT_DTPREL16_HA	94 /* half16*	(sym+add)@got@dtprel@ha */
>   
> +#define R_PPC_REL16		249
> +#define R_PPC_REL16_LO		250
> +#define R_PPC_REL16_HI		251
> +#define R_PPC_REL16_HA		252
> +
>   /* keep this the last entry. */
> -#define R_PPC_NUM		95
> +#define R_PPC_NUM		253
>   
>   /* PowerPC64 relocations defined by the ABIs */
>   #define R_PPC64_NONE    R_PPC_NONE
> 


