Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51D4606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QwblkD/w
Received: by kanga.kvack.org (Postfix)
	id B00836B06F7; Tue, 24 Nov 2026 08:53:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1916B06F9; Tue, 24 Nov 2026 08:53:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A01E6B06FA; Tue, 24 Nov 2026 08:53:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61A8C6B06F7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:53:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8879A88B2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:14 +0000 (UTC)
X-FDA: 85470154308.19.C566425
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34A85A0005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QwblkD/w";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528393;
	b=rjfyFeHpes+XNuES86iTL5uld3Z7yM/4WxrEzoS7UFGeTK210K5k44edlDB5t3X4uhc/cA
	Q/ao3+/vO+gAZcqmBQ+qEkSkPHLvwkWp19q8CvgRd6fICpeyJ652qpt3P5NnOob1QxV4yw
	xqrJdHw9JEwmzybx5HwTWP30U8NW67o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528393;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGzthS/oSecoEAl06XI+zoE8510Hx1H6SJxp/B0Wigw=;
	b=4hPEn1WhTzUTVKBRzP7X71FAIzPaWiEm3HyDx6n4R7H9tugKYi6ZmlAlBcIpHnPIPnZfDo
	8fNX06MHptfqDUZ0Iq56EE/9tPuzAaGxm7ohkd+lk8ctJkAHnv18LCX82Z42VF7qqSdA1z
	K3Uiwxcpd2GU5aTiqr2r7T3Dhw4fa08=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QwblkD/w";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78EFF41350;
	Tue, 24 Nov 2026 13:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F6F1F000E0;
	Tue, 24 Nov 2026 13:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528392;
	bh=CGzthS/oSecoEAl06XI+zoE8510Hx1H6SJxp/B0Wigw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QwblkD/wTsvFPj9DlvP2mZak8aRfXqeZm5me6PO0oOZM4v7hQ+bxkWPFAxoTT8mg/
	 jPQKnCFDs6oQ+u2ArzzEJMMkxxxN7S5/31PRC+NxBJhk+i/mN0UZiiFurEgI0yrabr
	 xBc1K2ffMcX81w503jm/uF13WHY63tIJmd6ehI6b5aMn77wcmWwAVOoOdon1K/X3ME
	 Nr/C0qQ1Si1PAXsCyhJVerrJ9fQtHu4nmbflZzvvVgRw+OoWcrIK0+tkkocYShM9H3
	 x23H90UQ1Tou2N9SxgJYvycDUUMBxofLaItEWKOUdmHqKpTNAg5P3GB+lD5QxZSjBd
	 TsgEvyY+V845A==
Message-ID: <sashiko-outbox-231259@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/11] powerpc/vdso: Enable the vdsocheck tool
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
In-Reply-To: <20261123-vdso-absolute-reloc-v6-5-161e218dd217@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
 <20261123-vdso-absolute-reloc-v6-5-161e218dd217@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:53:09 +0000
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 34A85A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: cnikhnosnqe8n66x43r7kfks9iudx1me
X-HE-Tag: 1795528393-595348
X-HE-Meta: U2FsdGVkX1/ICyQGY5irda5d3HlOwyBGElRXt0gVGw9H390zkfF73e/GOg9B+SDe6McyNpDwZOlmIdBuu/TZEaSRdGqMr6GwqCYjL2zMPwbDdGUQaSsdl4I5dwKaG6El6svq3LAXkY6O8X6gtgOQsFK5y6nYeK//3Xe8WL0DRhPPl93Ats7ONMPEIlIO/O4RdBMayu3TLTRX1w/HajV0kuQX5Xzhg2ol4BC7FhkX/g3ctkzQblpezR2KfmRZugJX36YuzPXCaediZkmyohD8AGQauYg5Hsn4h07nEcRc1s1VLAUpFSaxC1R9l6XGdGLPH0Wz3hoKJaAMtZY08fAsHgrujZx8lixCWQlnLleXUX8tMtGeRl8AXqWZcq+aw4sN2DBh1Wksp6cfpIj4N8Yw1Wn1YK/6A0YcffTZnNDk3SAEBA4ZgK+jRtAEX6v3WggM2XilhIHP+Dn6kycbrdEPfBDVO9xozm3khL5RTyuPrbeq0x4ijDeYdmNOx7uLVviOKv5qkIBI+pJMoSvV1+PhNqkzLymfcHt2ugPWkN+61/kFlTn5tq01w3imG5VoK/egEGBkPK1V0qKHhQEeRpfjewPPYxiTOgrdM8SG3eB46vcj6LwxMMRSfvicCPlL7BsRR83low5wcy+jMBdTqCExcxFg15aBDeuMR5fSQb/vnRgkbyo/saQ5qR2Ok9PUZx8wRkF3qeuV+LUuq44xSdPxPUwPS2v8H5/jTOLpoiCbq5xz4R1ZvjgzV5GE41YkIqIUHxTKZCbEv3KTzU5Wybq6dY+9utiu5UAMK8Ynddx4Fb87AXDjS8ZKUv8K8aSiEv9K7xlD27eckLUtoxbbw410Vk1KKUaLRjy9RCEKJT5HUxwWsRscqBsS1Pq2F9pMEOjz9gYRQWqtqA2pUNiQSKh1MEXHJnqimvHzCMcn+gTIWUuh7KgpJLcoqYh/kB6HFmhNjVmuv027c4QOMhlvcQw
 NxRi6WyS
 V3nfhbtYsJ6/J6YhmSLUu9le8AglVuHSfL5wNf7TKGW/k7xHK9bypqXnYpdl3bKMh0G5VW9YbTb33fZYP+VlAYyvztfst9Lpd2p39lwEbfcL9NiCO0/0/f+3V2llwsVHnmTXYAYsj/WvKj7dBU/Vdp43sL3gmNZw+y/yE3x2Cw8u/vdbOWn0TPAMb2yvzmm5469zKMvNldX1KL3hltCftUfLb/z3Rx9p0g01arglqXno2ssYNj18A2Ll64j8hNItvECkpQi4/rs5t6/tdYc/xDV0H+6R9djN9sybN5nS7Ojbs6El0XY4pz00S47H51FsAZF/vbkOclH1HzH6dlda6K2IU5b3B/x8xP+1Xy3+jZbBdbqZdjt1TXODOT5e/voKx5jbmTZyxjMaTVCVu2rjG+Vz9Gm45yQpsblKEvPTigA3+UOaZkwx9t/gVMNgh3pq27AnJMyVziWXohxe5LPFbaA3L+C44Z4fOPfIK6RzgRGRxt8uyxabydv315LCT8JcWZobXI0Q/aycBJUC3ZdSSNHUQujSIidq8Q7bTgJrixgvOdDYW6BOHSS1n6pJFWZNKVzAH0QFAf95Y2E1PH+pMH0qus14E3b3I6q1PQpbLSJCRLM5leh9ZCi1ORYUuNDfcy+xV7GX71CGvU9YME5JswA9lG6gR2K+rLW/wgVay6COXRHQeO5rF8waiL01Xmc+sfUnOl31z81zZ5VyMBXrdLZkL+yvhkT5pCrj2fNZx7OzirZ2/AIFltRoujaGyiNxOVTRuaF6JJkBUp5fP872zIyIb+4i7LOAeuOyZjL71HnpmZq13NsQze4LkfevOk0KqGmbeY2HdIKI2GQ3V7qVyCD33gGjhvtp8/rpP+oCYYL2419TNg29aCCkMuxWT8bkRN4hq6nWyzZARzRT1gdYCFZWnhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] powerpc/vdso: missing PCREL relocations in
  allowed_relocations_for_machine()
- [High] powerpc/vdso: unignored .rela.opd in
  allowed_relocations_for_machine()
--

commit 52616a4e4f7df565d936b44f34a023f9e1864af3
Author: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

powerpc/vdso: Enable the vdsocheck tool

This commit enables the vdsocheck build-time validation tool for 32-bit and
64-bit PowerPC vDSO objects and defines their allowed ELF relocation types.

> diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
> index 0d5ceaca34d7c..da58ff220eab6 100644
> --- a/lib/vdso/check/vdsocheck.rs
> +++ b/lib/vdso/check/vdsocheck.rs
> @@ -69,6 +69,33 @@ fn allowed_relocations_for_machine(machine: u16) -> Op=
tion<AllowedRelocations<'s
>              ..Default::default()
>          }
>          .into(),
> +        bindings::EM_PPC =3D> AllowedRelocations {
> +            in_object_file: &[
> +                10,  /* R_PPC_REL24 */
> +                11,  /* R_PPC_REL14 */
> +                26,  /* R_PPC_REL32 */
> +                249, /* R_PPC_REL16 */
> +                250, /* R_PPC_REL16_LO */
> +                251, /* R_PPC_REL16_HI */
> +                252, /* R_PPC_REL16_HA */
> +            ],
> +            ..Default::default()
> +        }
> +        .into(),
> +        bindings::EM_PPC64 =3D> AllowedRelocations {
> +            in_object_file: &[
> +                10,  /* R_PPC64_REL24 */
> +                11,  /* R_PPC64_REL14 */
> +                26,  /* R_PPC64_REL32 */
> +                44,  /* R_PPC64_REL64 */
> +                249, /* R_PPC64_REL16 */
> +                250, /* R_PPC64_REL16_LO */
> +                251, /* R_PPC64_REL16_HI */
> +                252, /* R_PPC64_REL16_HA */
> +            ],
> +            ..Default::default()
> +        }
> +        .into(),
>          _ =3D> None,
>      }
>  }

[Severity: High]
Does the bindings::EM_PPC64 entry break 64-bit vDSO builds when
CONFIG_PPC_KERNEL_PCREL is enabled?

With CONFIG_PPC_KERNEL_PCREL=3Dy, CFUNC() appends @notoc in
arch/powerpc/include/asm/ppc_asm.h, so cvdso_call in gettimeofday.S and
getrandom.S emits R_PPC64_REL24_NOTOC (116).  In addition,
vgettimeofday-64.o and vgetrandom-64.o are compiled with KBUILD_CFLAGS
(which includes -mpcrel) and emit R_PPC64_REL24_NOTOC (116) and
R_PPC64_PCREL34 (132), causing vdsocheck to reject the object files and fail
the build.

[Severity: High]
Will vdsocheck also fail the build on 64-bit big-endian kernels using ELFv1
(CONFIG_PPC64_ELF_ABI_V1=3Dy)?

Under -mabi=3Delfv1, the compiler emits function descriptors in .opd for the
global C functions in vgettimeofday-64.o and vgetrandom-64.o, producing a
.rela.opd section with R_PPC64_ADDR64 (38) and R_PPC64_TOC (51) relocations.
Although arch/powerpc/kernel/vdso/vdso64.lds.S discards *(.opd) during the
final link, vdsocheck runs on the intermediate object files first and
rejects .rela.opd unless it is listed in ignored_object_file_sections.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-vdso-absol=
ute-reloc-v6-0-161e218dd217@linutronix.de?part=3D5

