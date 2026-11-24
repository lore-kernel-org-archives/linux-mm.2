Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B74606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kho9japU
Received: by kanga.kvack.org (Postfix)
	id E5BD86B06FD; Tue, 24 Nov 2026 08:53:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E347D6B06FF; Tue, 24 Nov 2026 08:53:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D492A6B0700; Tue, 24 Nov 2026 08:53:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0536B06FD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:53:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB277A0C0D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:25 +0000 (UTC)
X-FDA: 85470154770.09.DF56B03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 53A7C4000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kho9japU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528404;
	b=if+5lUJL53Aof9aIVLH7imXZiKLCExmALAyzp0/dt3LWqnp8Ty0wjYvsIISlUEkHoiE9Fd
	bQuxYsitWXXYjQQ7LE5ArkpyApNhq9DtA/7CQYma2z/F/txKVJ92shUgvJLZuGO+li2qc5
	xCV074aSmgVxa2f83gvbtHG3jduDC4g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528404;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvrlI1buZ3E0IRhzK+P1F1aEhLGiGloUS49EF6BcS/M=;
	b=53rs7P7PCse3304r6HB2e73AqSbSqQrKPG0K30Awm4K2Z4p+RTfeISAC7W7+irSeGGhgO+
	RWAoSg+4POq2RcaFUrYGaOHtO1jP4XhUGd/1pcGTvElg7tQFAR/XknaDyoQi+qBzLzvZHH
	H/TvXk4h1IpFxUrEa3h4P5EBr3h99gs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kho9japU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0DE0623F2;
	Tue, 24 Nov 2026 13:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A001F000C6;
	Tue, 24 Nov 2026 13:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528402;
	bh=HvrlI1buZ3E0IRhzK+P1F1aEhLGiGloUS49EF6BcS/M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kho9japUfI5hDILsBuhf1RvYUh3RdAm113beEsgXkXArnLIfYvkbX3UfhbBJPpENY
	 pbHaL7iNYOzjnKeJCqiio8iPtnSt/YPOXD11PPejVFik7/inKO6oa2vKq12B64xsDO
	 zG6QaBDQVtF2GXzdF6RYD4Fok2hk3nMI/WXwXDFnXDOyaUUsiGk0Dp2cMDJ3MAdKTm
	 yoyuPwYTCUCHi3j/fPpHqX23aleEwYpt+7aMVebsm+yx6gV+vCsMGyMUWUjTZXRrxw
	 CzYx7fKU+LDKTdnlrKolrlZIoIrsxUmgqc66tWF9Q6SEMFh5biK7+mDaxtJnQUeUZq
	 fpJqNoBiXSvZg==
Message-ID: <sashiko-outbox-231265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/11] vDSO: Automatically enable VDSO_CHECK
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhvbWFzIFdlacOfc2NodWg=?= <thomas.weissschuh@linutronix.de>, "Paul
 Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>, "Nathan
 Chancellor" <nathan@kernel.org>, "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>, "Bill
 Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>, "Kees
 Cook" <kees@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, "Richard
 Weinberger" <richard@nod.at>, "Anton Ivanov" <anton.ivanov@cambridgegreys.com>, "Johannes
 Berg" <johannes@sipsolutions.net>, "Russell King" <linux@armlinux.org.uk>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Huacai Chen" <chenhuacai@kernel.org>, "WANG
 Xuerui" <kernel@xen0n.name>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Thomas
 Bogendoerfer" <tsbogend@alpha.franken.de>, "Miguel Ojeda" <ojeda@kernel.org>, "Alex
 Gaynor" <alex.gaynor@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Christophe
 Leroy" <chleroy@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Nicolas
 Schier" <nsc@kernel.org>
Cc: linux-mm@kvack.org, linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org, "Jan
 Stancek" <jstancek@redhat.com>, "Arnaldo Carvalho de Melo" <acme@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>
In-Reply-To: <20261123-vdso-absolute-reloc-v6-11-161e218dd217@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
 <20261123-vdso-absolute-reloc-v6-11-161e218dd217@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:53:20 +0000
X-Rspamd-Queue-Id: 53A7C4000A
X-Stat-Signature: c3e18d7aizb47opmnfu1ex7hsz1aceng
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795528404-921199
X-HE-Meta: U2FsdGVkX1+o9yAO6G/pqaIRch09CsM+OdDBZye0QWO9T102FI54bSFN5CEi9iBfF5+l8LFdwQ4nWuVXUkvTZmIs80cuZmsL6/le2Ls3BNHVVqxg1tlp6d/r8qYi9EkfTxIPSCgsRTNlQclVQ7HoqZe9TZ1I4wzQ07PtjX0lmIB9esLiSJvOONWNFS3gvORqTrkrYbdaxUmISnj1pPWwinhSd34XYqE8j6NMkBFE2oElXVGwPTkyKev+La+iMHDg9Hx/fADXnH0eRUvbkX3IVR01nbZGooq+EqugIH9FxLuI1dqoTcEijxeJZqAtTOGbNEDFeoCLLtEGYqvSlSaPvSUG5Gl2K4CohlxEFPIVS85eMTBWwgqj6WHqmK1uj3ldNYOWB8ZfM3z/WHAAyNISiMHiUdoJY9Ft5xh2a17KMABIrHkt+Dba4OLTYQmDQkIvrpHgh0VxVs2QnmQ2IwKgnj62xwgdxxAYuj2fLJ7Di2ZC4GtBEMKO1qZkGjgv6Cf9nXuH140K68kuUxcNoeNJr0yNC7aqdIRbPu6yL/7QXjSPOMFCCUGQZvWkAE0CkHl8n6AovIi6iFysozJPJqRXZBKt1SaoYRyLrs1LKRe2HzgnO2bMBthJVlhX5PYv8n/3mHrFF8mbui9jzspSJ2QcDxM8tmpsmBmINp+6gfYUgUTY2mH5s883R3wDtxi4LyUixyEF5nLs7lOX6CvgZsU8CsAcTCEVUd2YAeiMKQg8+i6eeL8ChKwxOpXONsjWZosbaBX6Mcpfmh9BErxCpa7cRZCdzS8XeJxbTT6Tz3PKllnfF2Gwmas86jHKU4ObiqxWK1qMy7m32gYXCl8dRAsbTF2KJpNsPb7RJOm5L6urDgVmc76i2walGDrIHUs7/qMYPEvjmsPuaiPeHIUeU5vZ6VY6g/qbDNzRyLpGbOTM1pJtcFx0E2JmZLNJdeyUjHdACzELlinGTEcLxXnplFm
 5pnLdH6Y
 O1B8k/DaueUYV5Hm+yWvIfWlwNOzCperi1llOOyAG+bG2KnBQaV0l+aJ0eQzqrRTln/LBSL7twvXD/zqEc5iZITRXfdpni+IkivQQqLGRUw6pOduvYPE55vvMJth12biMUHiGuXVwtrnhVN+cPnMV/X9vum+CZVMi3edpO7Vcvb7qLUCcV7K2xxERijKhGH5dmTnVS61OBPjvjIMs/kJyuVQx6MWsD3Mcgbnl2O4Zf3aZ/czCO6tpb5ejCrssgB7WMVFICKjhLkAULtMv95XkFMCFv5WNZaxsJ0pbYapWsFWWxb+xK9FgXc0v+H26H7dPzcdQliFyGrMK2MCZ3LlL3E/WCF/eKadpjw42iSdszIClQjqZkqyuZIcgg2UmXnIHGtF7b/dBo0WwGa9ijOIPvvQ/LmvJAihmN2hPzAiQFVlseQwp7AK9xc31cPjOLxm6rEv3QsQbxm1dIQnXM1x/iHTVNjGuvl9WTB/Szgkmm+EZFePL8D1DmLOUl6/u9ELZ6Q+Un1075JgXtVbWG2M19pWChhMVJM3gzK5PTC2Y36rpyoyEtrKSt0Gf2/O+5nijZMll+8pYtaz5Z78foBv9Fu9ei9MV3Q5kxInh50Zb6MwAZIojcXD40Ba2XvE4EK8vtb2KOCh7YKgGcZ7k//EoReSjd76z9DggdIoy6BYeH5gt6BL8LPYRvNDUaCjdLxQiEqyx2kXe6c0402yb0C3noDKYEMeumytfI4b/QHU52LV4lvD38NxhzsStJau4uVftK2Eu+oGmcXFYxXmM40njhuzUSN/OBX2KnfQF/SJk32Ryxh70sja0uhX9IUq38ca6hq+U2N7D5a6ae+jvtFH5AWdhFQZJPQHTwQgXtLygjsgh1og4BahUOU3ZmHlNflBwcpFEK+zd5xnfG1JtxZA00ARIUEPE+kvj5rrJKxngyqUEgkXd1187RBMKZlo6VxBFKSRPhSEr5gZKI2/gAwTVw31rf8/F
 IE7CumbF
 +gZggLigCerlsdFoDLwEeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] vdso: VDSO_CHECK disabled on 32-bit RISC-V and some MIPS
  configs
--

commit 7179dbe5f048cacac134800666e4651c26c46665
Author: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

vDSO: Automatically enable VDSO_CHECK

This commit selects VDSO_CHECK from GENERIC_GETTIMEOFDAY and VDSO_GETRANDOM
in lib/vdso/Kconfig and removes the per-architecture VDSO_CHECK selects.

[ ... ]

> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 9a3ce550c95dc..e2eb9627bd14c 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -107,7 +107,6 @@ config MIPS
>  	select TRACE_IRQFLAGS_SUPPORT
>  	select ARCH_HAS_ELFCORE_COMPAT
>  	select HAVE_ARCH_KCSAN if 64BIT
> -	select VDSO_CHECK
> =20
>  config MIPS_FIXUP_BIGPHYS_ADDR
>  	bool

[ ... ]

> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index f580d2afecf7e..f8e26c4bed2ba 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -229,7 +229,6 @@ config RISCV
>  	select THREAD_INFO_IN_TASK
>  	select TRACE_IRQFLAGS_SUPPORT
>  	select UACCESS_MEMCPY if !MMU
> -	select VDSO_CHECK if MMU
>  	select VDSO_DATASTORE if MMU
>  	select VDSO_GETRANDOM if MMU && 64BIT
>  	select USER_STACKTRACE_SUPPORT

[ ... ]

> diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
> index 559f5534831e5..741de1abe9237 100644
> --- a/lib/vdso/Kconfig
> +++ b/lib/vdso/Kconfig
> @@ -6,6 +6,7 @@ config VDSO_DATASTORE
>  config GENERIC_GETTIMEOFDAY
>  	bool
>  	select VDSO_DATASTORE
> +	select VDSO_CHECK
>  	help
>  	  This is a generic implementation of gettimeofday vdso.
>  	  Each architecture that enables this feature has to
> @@ -21,6 +22,7 @@ config GENERIC_VDSO_OVERFLOW_PROTECT
>  config VDSO_GETRANDOM
>  	bool
>  	select VDSO_DATASTORE
> +	select VDSO_CHECK
>  	help
>  	  Selected by architectures that support vDSO getrandom().

[Severity: Medium]
Does selecting VDSO_CHECK only from GENERIC_GETTIMEOFDAY and VDSO_GETRANDOM
leave VDSO_CHECK disabled on 32-bit RISC-V and on MIPS configurations
without MIPS_GENERIC_GETTIMEOFDAY?

On RISC-V, both GENERIC_GETTIMEOFDAY and VDSO_GETRANDOM depend on MMU &&
64BIT, while 32-bit MMU builds only select VDSO_DATASTORE and still build
arch/riscv/kernel/vdso/ using cmd_vdso_check from lib/vdso/Makefile.include.
Selecting VDSO_CHECK from VDSO_DATASTORE would cover 32-bit RISC-V as well.

On MIPS, arch/mips/vdso/ is built unconditionally and runs cmd_vdso_check,
but GENERIC_GETTIMEOFDAY is only selected when MIPS_GENERIC_GETTIMEOFDAY is
enabled (which depends on CSRC_R4K || CLKSRC_MIPS_GIC), and MIPS does not
select VDSO_DATASTORE or VDSO_GETRANDOM.  When MIPS_GENERIC_GETTIMEOFDAY is
disabled, VDSO_CHECK will no longer be enabled and the build will skip
vdsocheck.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-vdso-absol=
ute-reloc-v6-0-161e218dd217@linutronix.de?part=3D11

