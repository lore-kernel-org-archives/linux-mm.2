Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C7F606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FA969aNu
Received: by kanga.kvack.org (Postfix)
	id 421A66B06F5; Tue, 24 Nov 2026 08:53:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3842B6B06F7; Tue, 24 Nov 2026 08:53:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274096B06F8; Tue, 24 Nov 2026 08:53:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCBB66B06F5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:53:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC7171C461F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:11 +0000 (UTC)
X-FDA: 85470154182.01.FCFDBA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1B208C0007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FA969aNu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528390;
	b=2pjBJS+JIGUnTEwBGkYD0OvbBsC566/ob9GBGpCse5jMoBZhgli6HDC/OThBpaKgk3MZOF
	jtz36IVsSX0NsyvLm3lT99yNCsWf1fi83tsM9VRdBNiL9+tR5VtLKlBsl1Lrjmxb/rZeND
	juMTfEKC0RhYyxrD/8mVeV1wWIpNQUs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgQKXZiGb5tBZBQ3K08NnOpAN072dn/neONJ7jc4HhM=;
	b=2uEDQbbCmDXRhRjjGfB0YbjBOak8fgVeV25ji4mXQYxd5fkScMGmnu16BFiLmuM6dtHq/D
	IuW3Lu0T7toSwYQ4y4BUQLBoB87+W40SnYZYnJ5zwyNh7dS33y3yDIN+X76McuLaiWRWn5
	W7SeM2PjxUvURhgQdvFwC4PljxWz/CM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FA969aNu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 623034580E;
	Tue, 24 Nov 2026 13:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3751F00A19;
	Tue, 24 Nov 2026 13:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528389;
	bh=sgQKXZiGb5tBZBQ3K08NnOpAN072dn/neONJ7jc4HhM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FA969aNuoUfYrCw580vZYFdb+V4E+YyjNSSdoOajzUkWYW+Au+vSXG4kF2jrHL3M/
	 TJBCbpp7XldUXu5ie3fkMOxuk7+qFtYgPw7x5GSScU6d5BTvsTQeiPt0UvyXrEqxU5
	 gUNqMcIDynHlqso6f1xb3ET6petdCz38IDn4i00PZTf9ri22atoGSkWb42PEzZAsy9
	 NL9DScw5nvgrRze1oDft5YcYz8tCAbRVqZbBbYx/rxSkXoyh6fDxzBwLoLIuiHOpIB
	 lAlyeJISbDi7N07gcnuUMOngsO8IrGeGdPYEQZLP2pCUlOl4E1oekSKMWDIQQybuFk
	 UwXExaJDlewdw==
Message-ID: <sashiko-outbox-231258@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/11] arm64: vdso: Enable the vdsocheck tool
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
In-Reply-To: <20261123-vdso-absolute-reloc-v6-4-161e218dd217@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
 <20261123-vdso-absolute-reloc-v6-4-161e218dd217@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:53:06 +0000
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: ggwhd5y58nkwiatitm86jjtgoj9x6d1a
X-Rspamd-Queue-Id: 1B208C0007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795528389-611990
X-HE-Meta: U2FsdGVkX1/w2My0WNQrmFvCMes+IwzIVHAS4QYhhz6ft/FxJio8MpEoDvIuS8CF5vNxklirZetxv75OnxgRF0HPvW+cEHsJ7Ms+BEeY04tulmu+Ni6Wspu47KUikp6mctX9IxNpLGqPUUVNAhqyk1Owmc5k6owcr91xX6tRPGGkRCyiI/pMQ34VjdK38f0LUtSQawUCaaD/1Fz9DTtPvtwvUcZijASnG+/Ffout6hkdqhaUI1leMoye8L4gYxhVbDiGffTElIs7eSd/2fDkoFTknO24iSr7i03gV8ReqW6HyGocd4CSNDSLrBayNTIe25gUcPG3lCEdbIXaKBIlhVIK4nLPb26WxJcnB2HXW/KedVu3Shg2u3dubLyJ04LVfmnSGqvuiowRArDfQyoXYW9mXItwk1/ri+6bvbs80jjEs2eWKiCU7TbTsZGZLltmtkJUn8AyvcYF5yISx6COXhdxftpocnoI8KIKjhb0dYU1V3biw3fMQVa/i6B1531ehV9EyCWFKebPQCQjIKrxTmFp8uAYoliaPxC3lZvH0YcluJT4Ma4LdILOj6qafbGL7/FtwcnA8Hx0D3YEoYKgTNVxlhpgI4pyuOHazwOLgX7YxH8x1/WUJSAd655OdEqlCIN3NcsPrCTRxY2c44b0ew/I1PwzOBUpoyhjrFSJn4yeeOPRo5LXH3oiCl/nFY+Zxjr+1wU3P7wj+t+PoBGGIY60/V/jextJWlltQUDsuwU1b99vtevLNxzJUKziFaf6AbX3262vyhOZlCXmLJoQMBKNsD9TZ7gobRggUlIOTn9uNV2iZebfVOCHliiSLM7pfkq+YFfI4hiqkbQjzhumGSAjS7acCM1opRzV9O+ReSWIJLpGgcWIOv/ccsBETpUTfneYdIotL0oectlnExnEx0eX84e7EyZ05uvvS/KFicsJxxm/6mZ10J+uksWvY712fcP7lLsctGTbJ4UdZWY
 HDRnu4mc
 vZ0vAemUdo8rSjSuHdKiVoTmE+cWD6Dh2UuFXb9NuOX2qAYsqTGG6CEjx9UcKEIybtEQb8hSzelMt1wxduOneCugo/MtgaH8bTbL7D440ksf/Al8zMfib0LhScYb8GDrZO/rgcTVsD7MsLQQNbOpCCilXY62G7dYRg/az5nqZJ+uTrEyGi4BaoeJJrkMM0owlSSYwg0BVbmtomroKHtqNysFb1CQEInwSaFmvWEQAixTF/Hr/MOhaihRNPmHlhccGq94piBSpp1IyUzSpZs9Vi2DpxXOLbu0oZs6Nqg8wiiurs4GQ4K/rmCehqFf3TDpS0MtJEXn7f2KOzgguWMTu5aI7Mnrk3shIRPGRPwzf4KD0aa6AXhSXa9xL1EO1D+l8/9+qrN9M0Ha0eU6PHl9MBpTBP2zArw/8n9TXwc2KoOOF+vIP20sXZKvy5MpL/+nU9iazVV+PkKCD9ojb5xK5sWmMDRuaoXK4WSdNX5tvWtqgNpdWMeiKOd0Jc8HmjBKxYKDtUOtailvw3Ne4bKi2p0v01wd989emhSc3ZO24EjY5zR51sUnEdepH2Eft/DlKEyNjmpXmWvkxQhLxbI7zs8Ibcbdcp++sDi7Ss9nii+JnyDWXezcfajoirxfkdCtHvK628CZO7SmKtYIDlIofDQetla4CxeEDlxpsX9brHfpcZTzva6s7dnxt1d1jTB7n1Jhdm6XNUwwHyeAW9wMev8tQpHL7BbprttJV8+qr5Lj+M6J2Khq6UQ+rEsNf6iuHkg2X38AQUrcVjBGn0dOTB3xrDZcmhhlPqpW4RUh7E+RAWLtlZ9JzU9oG1+jppyEQL6+0pOHSm2jo7IlYd5T+uJfuvIeO5vMsGt6D/IQERvYij/Pzbjt+cBtB8eh7VAvQRXu99hTGwWIeU1Gjv/UutJmMyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] arm64: vdso: missing EM_ARM relocations in
  allowed_relocations_for_machine()
- [Low] arm64: vdso32: missing $(vdsocheck) prerequisite for vdso.so.raw
  target
- [Low] vdso: vdsocheck: missing R_AARCH64_JUMP26 in
  allowed_relocations_for_machine()
- [Low] vdso: vdsocheck: rejection of R_*_NONE relocations in
  validate_linked_dso()
--

commit c6172b0bea62f3a614a6024ef180d13da9b4e5c7
Author: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

arm64: vdso: Enable the vdsocheck tool

This commit enables the vdsocheck tool on arm64 by selecting VDSO_CHECK,
updating the arm64 vDSO Makefile link rule, and adding allowed AArch64 obje=
ct
file relocations to vdsocheck.

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b5a51b0ef9440..1caaf4737f027 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -258,6 +258,7 @@ config ARM64
>  	select TRACE_IRQFLAGS_NMI_SUPPORT
>  	select HAVE_SOFTIRQ_ON_OWN_STACK
>  	select USER_STACKTRACE_SUPPORT
> +	select VDSO_CHECK

[Severity: Medium]
Does selecting VDSO_CHECK break arm64 builds when CONFIG_COMPAT_VDSO and
CONFIG_RUST_IS_AVAILABLE are enabled?

Selecting VDSO_CHECK activates cmd_vdso_check in lib/vdso/Makefile.include =
for
arch/arm64/kernel/vdso32/ as well.  That directory compiles vgettimeofday.c
with -fPIC -march=3Darmv8-a (and -mthumb by default under
CONFIG_THUMB2_COMPAT_VDSO).  When __arch_get_vdso_u_time_data() materializes
the address of vdso_u_time_data with Clang, or when the compiler emits
intra-object branches, vgettimeofday.o contains PC-relative ARMv8-A and
Thumb-2 relocations such as R_ARM_THM_MOVW_PREL_NC (49), R_ARM_THM_MOVT_PREL
(50), R_ARM_MOVW_PREL_NC (45), R_ARM_MOVT_PREL (46), R_ARM_THM_CALL (10),
R_ARM_THM_JUMP24 (30), R_ARM_CALL (28), and R_ARM_JUMP24 (29).

In lib/vdso/check/vdsocheck.rs, allowed_relocations_for_machine() only allo=
ws
R_ARM_NONE (0), R_ARM_REL32 (3), and R_ARM_PREL31 (42) for bindings::EM_ARM,
so vdsocheck rejects arch/arm64/kernel/vdso32/vgettimeofday.o with
ValidationError::InvalidRelocation.

> diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Mak=
efile
> index 7dec05dd33b70..9fac0e54097dc 100644
> --- a/arch/arm64/kernel/vdso/Makefile
> +++ b/arch/arm64/kernel/vdso/Makefile
> @@ -61,7 +61,7 @@ targets +=3D vdso.lds
>  CPPFLAGS_vdso.lds +=3D -P -C -U$(ARCH)
> =20
>  # Link rule for the .so file, .lds has to be first
> -$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
> +$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
>  	$(call if_changed,vdsold_and_vdso_check)

[Severity: Low]
Should $(obj)/vdso.so.raw in arch/arm64/kernel/vdso32/Makefile also list
$(vdsocheck) as a prerequisite?

arch/arm64/kernel/vdso32/Makefile runs $(cmd_vdso_check) via
$(call if_changed,vdsold_and_vdso_check), and cmd_vdsold already filters $^=
 to
%.lds and %.o, but without $(vdsocheck) in the target prerequisites Kbuild
will not re-run the check on the compat vDSO when vdsocheck is rebuilt.

[ ... ]

> diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
> index e28ee59a900dd..0d5ceaca34d7c 100644
> --- a/lib/vdso/check/vdsocheck.rs
> +++ b/lib/vdso/check/vdsocheck.rs
> @@ -57,6 +57,18 @@ fn allowed_relocations_for_machine(machine: u16) -> Op=
tion<AllowedRelocations<'s
>              ..Default::default()
>          }
>          .into(),
> +        bindings::EM_AARCH64 =3D> AllowedRelocations {
> +            in_object_file: &[
> +                260, /* R_AARCH64_PREL64 */
> +                261, /* R_AARCH64_PREL32 */
> +                262, /* R_AARCH64_PREL16 */
> +                273, /* R_AARCH64_LD_PREL_LO19 */
> +                274, /* R_AARCH64_ADR_PREL_LO21 */
> +                283, /* R_AARCH64_CALL26 */
> +            ],
> +            ..Default::default()
> +        }
> +        .into(),

[Severity: Low]
Should the bindings::EM_AARCH64 list also allow 282 (R_AARCH64_JUMP26)?

R_AARCH64_CALL26 (283) covers 26-bit PC-relative BL calls, while tail-call
optimization or unconditional branches between functions in an object file
emit B instructions with R_AARCH64_JUMP26 (282), which would otherwise fail
validation with ValidationError::InvalidRelocation.

[Severity: Low]
Can validate_linked_dso() reject valid linked vDSOs when the linker emits
R_*_NONE dynamic relocations?

lib/vdso/Makefile.include notes that some GNU ld ports emit unneeded R_*_NO=
NE
relocations and filters them out with grep -v _NONE when vdsocheck is not
used.  When vdsocheck is enabled, validate_linked_dso() rejects any
elf::Section::Rel or elf::Section::Rela section outright without ignoring
R_*_NONE entries.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-vdso-absol=
ute-reloc-v6-0-161e218dd217@linutronix.de?part=3D4

