Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB96DC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E756B008C; Tue,  8 Sep 2026 05:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E656F6B0092; Tue,  8 Sep 2026 05:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C2B6B009E; Tue,  8 Sep 2026 05:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B61326B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:10:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1B3F80473
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:10:08 +0000 (UTC)
X-FDA: 85190023296.15.6BC43B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1ADDB1C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:10:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAE45L0T;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0gSNJNsFiBELJzc2W3yE5oEemx5pk46RuJIr17mKUU=;
	b=12BGdRcIe+3THT4nJniX4sxwj04UfhnigSgW7QqIN2qN0dUmbq5aJ8nuJKdxVcDii6lakb
	ZKX4dTOrmxQqoFT0Ozo0/O64OLjAIwbeCRpsa6rJmVp7edSaep/k/rYpc6aKfcVjRyXZkx
	lZPIig9sWNEnRH9cyTFCMvW/EysAzbI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858607;
	b=hoyeLCxZP5Pfn1EfMmy0Iyfro61wRjj7Y5fRjsQ8ztlMS5k4KKCvGXxDbLUXs9y8H+OW62
	oBmHVQbFcO3SYUN+Mrp8nN9G0dIPCuuPn6QEBxeOT8GdsZGQmrndNbQB17sp+BVzkFoKVE
	wCzOXyN6OEwVwia972kCCqbcNNguwnA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAE45L0T;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8375160A98;
	Tue,  8 Sep 2026 09:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569471F00A3A;
	Tue,  8 Sep 2026 09:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858606;
	bh=R0gSNJNsFiBELJzc2W3yE5oEemx5pk46RuJIr17mKUU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DAE45L0Ti7ZzN2J9EggKEpXt9EOFC/xe7EhCLBEAgKZ1EKM0gpJTm6lUAH9Rv1Y/l
	 Qb9gt8wqAJzrDQsE15lcnh+2LUSKHF7Y85tsfXTkApAmKRChoYKRr7LNH1NO5zCDxA
	 DgSV71bDNblo942RePIiEaOET6DD2BAm6jQXNwGXYyYXCVrrPfTDwooEAWl2+nKYnh
	 ROImd7jwopGGxZDYzhcgEHbseuZcsu9rqsTTi0oEx18R978jIBC68KJY6GiEvY9ucn
	 ZPViZj8X62xbMqmZxsQcKY9LdenN66zHgBKx4TLNgSPHoQy5QHpClKrY1uem3vgjH+
	 BNFhyDw3+tpqw==
Message-ID: <41c824f9-aa04-49a4-9d0a-9ffba7b014b4@kernel.org>
Date: Tue, 8 Sep 2026 11:09:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/24] tools headers UAPI: Sync ELF headers with the
 kernel sources
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
 <20260908-vdso-absolute-reloc-v5-11-3a93791af1cf@linutronix.de>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260908-vdso-absolute-reloc-v5-11-3a93791af1cf@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1ADDB1C0002
X-Stat-Signature: nae911nqmbr39iajot6umdfij1aypohb
X-HE-Tag: 1788858606-31524
X-HE-Meta: U2FsdGVkX1+3xEuwWN2gDANKsOf2BgiLvfzNWkctL8Jf/qvvZOZO2Lh1NGDjUlhlt+fYS9qQz9iMvJAG1DzI7KNNPZpwfwzDaxg1PdijQXA/ofMJQy+JZiW51R3zVidkVixMheKFJs9HST9l1fnhaXTiQdjPrnXMhnAW6v0Qt6rQ3EWYfSd68Iyq0ZdXwK4LlhWzriiRGc9Cp6iveB/Y92+L0784LXqqL/uohZy8mFBT7xX8UwQDuckVBcIFETZzfJyDuzLZC9qr5ODtiMoHouaS8ACsa8K0ufvfH65SXsz58qZsxZMfdwwkcp2H3H+/WlAeYSyRp+kS+LyBLjTdVHfpbaj/TORGQXohNlfnW2KX1vEAutt9ETaExw6Blhav7UyUK3N+V7hX1gja9Mj+f95xYOS6EygiABYLNRtd7/vFWuuXoZmfsdOzSdeE94/QK8QpaDqfIHzx8ul07uuNmcHiNutslRRDCSiE81ceJYUOGZnMK5OLxqVczzT+Ir0Z1EgLfiHb2NGpXlrkL73u6NxLgOB3Ypw698KIU5JVG7f09+P6WSbJoFcTjf+GA6Vdx+/fK3I3SG8QGNAdB+HvypQXv1HBTxn9EQp93Xc6mneG0nz9oFr4LKvSHc4d62MlZwNFZ/uxZR6bL1nYKr8uYO5bnSbNzxiuQtRV7eC4btrslRraszqfTuYfXXyEWUveTKKM3UEF3jisW4DF6B7rOmeS07iZr3AMUZ/FfghrcFfJmDGOF1liOFw1LFhmTpzExcX8AVmRibnpcmtwaArdQqPooOYMYEaEmodmB7TNP4AG/OYAwmUCuSQkZfYzG5Avoj4+jw1nklZusopDJ6KlAc2aPTLzglAjh+Zf4Hx23RDkFer96OGXWkY96BjGTMkyWaodHiGWHo4ObAxsFch7c6Gn9CSAVs5FBCfjENx6iiNdSER7b7tH9LhPQXGX/NSrp7U9DAPaLW/yQoCI7BT
 Ha1e3PHw
 PNeaIijAd8zImOMNUGG6r5qjd7ZRfpGesypWsckpIPnwdvu0msfzt/vBpzPFHslFUKmevN0NGw3BgIwmOAl8M7Wq+cILBpN0WXnmgdZaO17SfSRQrNPhsO7Fr+Q1dYJIhmtWL70tkLHMrw70dqqYB5KUUbH7WSOdrh2Ru6MP/6XRuOy2AYIXw6lxP8MkjXC/dh/eFyDslz02EYyTNtl4vExRAxeBNGFSd22J5I4IwMLpF1Ykgv0qQSEiw9Th3we4Vc8CypqMJtFT1h45xGwXO6EgB7wcGOSPZAVfpe00yquaEphQsINekfarQAvFX4//YL2xVgkTK9Yn1CNNZ/nORQeTdy7zQk8eX8MElXT5F9b/H4UevNftXXDyg7wsbDjST6qodzFwDqbxBAEgeAPswtXLTawsz8Y/0cXUC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 08/09/2026 à 08:33, Thomas Weißschuh a écrit :
> Pick up changes from the UAPI ELF header files.
> This picks up general changes to elf.h, elf-em.h which was forgotten
> previously and the new elf-r.h.
> 
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> 
> ---
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>   tools/include/uapi/linux/elf-em.h |  71 ++++
>   tools/include/uapi/linux/elf-r.h  | 696 ++++++++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/elf.h    | 112 +++++-
>   3 files changed, 868 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/include/uapi/linux/elf-em.h b/tools/include/uapi/linux/elf-em.h
> new file mode 100644
> index 000000000000..ef38c2bc5ab7
> --- /dev/null
> +++ b/tools/include/uapi/linux/elf-em.h
> @@ -0,0 +1,71 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _LINUX_ELF_EM_H
> +#define _LINUX_ELF_EM_H
> +
> +/* These constants define the various ELF target machines */
> +#define EM_NONE		0
> +#define EM_M32		1
> +#define EM_SPARC	2
> +#define EM_386		3
> +#define EM_68K		4
> +#define EM_88K		5
> +#define EM_486		6	/* Perhaps disused */
> +#define EM_860		7

Add a comment that it is /* Intel 80860 */ to avoid confusion with 
powerpc 860

> +#define EM_MIPS		8	/* MIPS R3000 (officially, big-endian only) */
> +				/* Next two are historical and binaries and
> +				   modules of these types will be rejected by
> +				   Linux.  */
> +#define EM_MIPS_RS3_LE	10	/* MIPS R3000 little-endian */
> +#define EM_MIPS_RS4_BE	10	/* MIPS R4000 big-endian */
> +

