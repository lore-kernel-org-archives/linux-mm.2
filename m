Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2C3606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DFskeiZS
Received: by kanga.kvack.org (Postfix)
	id B4EFF6B06F9; Tue, 24 Nov 2026 08:53:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25BD6B06FB; Tue, 24 Nov 2026 08:53:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B596B06FC; Tue, 24 Nov 2026 08:53:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 618B06B06F9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:53:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E780EA0C30
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:17 +0000 (UTC)
X-FDA: 85470154434.16.D4A4EA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5327B180003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFskeiZS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528396;
	b=wQjoeybaTVYxkTWwuU/Rj8wkg3Yreude+OS96Xrt3QLpQeM/LVhbpjVeLLr8kGzqKY3EyP
	jJ8aKE9EtZ39bKji5Rdoev5Gd+5+u6nrEHRotf9ES2YSVdBScf01NOFPbqR4GCGLfmR+XA
	nHgU460JxZKE8DxNq0D5azBKwcphqdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528396;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8VuKYHsB4+QDN1OuGMMGRMKrc7oMUOuGmeu/s/80zI=;
	b=nJCbjx1AziLOObFni2qdhkd26Q58TFHsJsq8RdtDc/PiNOURrTY5bYcGUqRx4Qcfef352K
	6CRQqP48MB1WdUU1e2fSelUsZ7KXFt7Lj5lHmjTls1ITc3lijdTiMqk+Emb27X4VCMONMC
	CDoTt+TIxoszSiA3HM/TG3zIIU5Yo4U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFskeiZS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE7D2620C2;
	Tue, 24 Nov 2026 13:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72AF1F000C6;
	Tue, 24 Nov 2026 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528395;
	bh=j8VuKYHsB4+QDN1OuGMMGRMKrc7oMUOuGmeu/s/80zI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DFskeiZSZSaGoVbhpd1h3zBuer2BkhTy9kP95ojqLHs3nKCQBWicJh9tF6KyPkWf+
	 XlSd6oKg8IeYUa5xajwCcuWokix5WhDP3kooszRlH3u/5NoTgLfUGRT2qH95ZX+V78
	 X+/4yGjj2RSeqaHDGJax6zw9DrGJzkZaCZ9V7HpXn1gRvvF/Vf+2pSFlICI81whzlO
	 1MwDZESPKvsL/4r0G1AqEme4Cdqh+d6xr97QPXqKolLAcGbahgTbJLsqxLRXDoD1bx
	 D6/TtT8mlZg7Q9OZ0eR+uyKSdR/NIC1iLyqKiQ/qFAg9pLjF0TzkCO8VuZfgT2F4Zw
	 Nb5b7OJDff93g==
Message-ID: <sashiko-outbox-231261@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/11] LoongArch: vDSO: Enable the vdsocheck tool
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
In-Reply-To: <20261123-vdso-absolute-reloc-v6-7-161e218dd217@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
 <20261123-vdso-absolute-reloc-v6-7-161e218dd217@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:53:12 +0000
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 5327B180003
X-Stat-Signature: 1j4mwou6wrfpuadrb7cbdsa5wnzwwf3j
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795528396-137085
X-HE-Meta: U2FsdGVkX18S4Qn3kf4T32FGp5B2tZ5QYME8J5CQPedD3O3D+nzc1jQpmnx2gylAv/XkZ/pvfOFsMcrFDpQOhnKc3pJDmg6qRDjJ0wL2Slef1J0DJX+aBoiSuSFATqUR3cgTljFYhZviZoA9M9/e9ba3UNdQD1q+GcQOdS53DGo8wOQqW9Rs9J0Uv7HLjWYbbhJ94JlfUlqaHLzwico7VvhRq9NvLgaG9KgBmiwhoTMu77wHPCu/0Mx2oevkj3cBk6wo1Lulkdzji5l3ojUcG4/WuY8dCTC4Yi5vySw5JTtyfXkO+fUyhSTw0irIa6qeaJh/V44Y/CUCzI9VtYP513dqfY4y5Jku48GHqKrfng8DgrJ/D+EwL883lf1iHc6+YdXhe851b8ixX/a0J6QZfaW2sVubKAGcsDVoU9tIsx6pJ2JLl79PtK1tp20Mc8+r3gNWBSYtqIK1/Tq8UPK69hnL8c1YyJxEJtpnJa3JEpUsoJ2M1JnHTT1TuwkQw2aSMNIWCyYMJycr/flX9QxtpQClScnOa5gp5wg46xuaN6mXRlKGVGdaQF4+JcqFhIfeZwHBqdWjryT1yZkq9o519/IqE8m5oFN6VHFO+RjhYLgMyD6VwVeRQQol6EF1sILztdyhvVfjmFwJc0hjTxxr5ttORoCJ5V9wE0TXjnRK/vvh3sx9qc6XZo4irRORZ8TlWF0e13fwyKgF1dnciZGCOGmStf2tAXd6BA7dI6nDBiD/Hfh6B3tbT7uA3Kk61Yxp9gtCxTMa/pRITXU0PCARUvxXQuDHbtkIBPGmCoBS8/FOg2R6dnytcclirtn714isVYAlxz37Nkx9MYPYlpF2jrDBF2UzgwzUDsKI5+9mc5wJZ6nnSExakcYQrLsvudBqRFj+n596/Pxw6z9d5xfdvGmFGEfmDS2UF3Z5m5ZfY/q7zZt0uvZzLQARtnVxXdXnimWjJh0SDJKu3v7WVP8
 TGr05bxT
 l3e8CQAPUWC3jJsyhwaKRYC7MNBrgI6Je5hG1gVbnIePJOQQjvHP33Ynmyw1hs37mK72WHtj164oI/Y5IMkK7NvNWE9Bvvy6aB7raDUaE7eA+mIMrXRqveSvf0vsNCu/9ZoUxXZ8fT4lyal6cvZehgOvnzIVSegzcYG8BPvI1+gfRbi1QrCht6StvnaSBqwFlLJTIxPhMf7vfNV//UHfUmvtuKBbX5JdQyNmHQR9DgTphMPv9reoC3sjAA05Fvs8cpGS7zc9crQBkSZbUK20HtkcZlncs4B08vucMzwis0yailF7tMXdVrBIeE0q9hzC76ZGJJpjI9UjELnubz2bjMqLNOQUn5S5BBW2XIJkZ81JFroIJ5sqsJHzJ+/IwhPrPC6orWwwBx7mzqYjY29Ofmqf5w8qDJqsqktTo6U9N8a8kkhSDPpTDUjq2agSpTIu+WRjsHHD6d3UVUZI5h4aZoj/Z+dQqPZwB7dOk85F5Wt5XWWC1OimlhYCiWx3hOfFLmFMTt6tFXMYuWEfi7TQ1xbaOidcBpaAG/qSR/ilegf+NBoj8twL9miyZoF22ku9G7YbnAbq8Edq1xJ4d9duLhLT83o30ZSsfXHfHn77+E/OaO8p7u325mXAvh+mwIIK6/oQPCf0wUzaRZ+jiGaacFLXwAwc7vCfln5nOmxhEuxfqf2Mh/2lfppIJYWgILmHviE9xD2NkUEXu0hr0495tWEjWszAfr68mfAtZIV9H+Mofo8a4UvefPHNFBSq0VmgKkM0nadDYV0nfWrSCSLumh8sj96mifplheDM38tN9/676G5GNmcDmQds2sDjqFc/6AGPgl1a0VUCzRJwC5ZzDor84radmMEsADwasqtJ6mrKzY7hXUhFBxv+bhxvSV3rDq1bMvn/lvvnl4us=
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
- [Medium] LoongArch: vDSO: wrong R_LARCH_PCADD_LO12 value in vdsocheck
- [Medium] LoongArch: vDSO: missing relax and eh_frame relocations in
  vdsocheck
--

commit 2fb850dc718e09234a1d0b974829df4ce1c9ae9b
Author: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

LoongArch: vDSO: Enable the vdsocheck tool

This commit selects VDSO_CHECK for LoongArch, wires vdsocheck into the
LoongArch vDSO Makefile, and adds the allowed object file relocations for
EM_LOONGARCH.

> diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
> index 37455d3261109..7952ad6ba72b1 100644
> --- a/lib/vdso/check/vdsocheck.rs
> +++ b/lib/vdso/check/vdsocheck.rs
> @@ -122,6 +122,32 @@ fn allowed_relocations_for_machine(machine: u16) -> =
Option<AllowedRelocations<'s
>              ..Default::default()
>          }
>          .into(),
> +        bindings::EM_LOONGARCH =3D> AllowedRelocations {
> +            in_object_file: &[
> +                47,  /* R_LARCH_ADD8 */
> +                48,  /* R_LARCH_ADD16 */
> +                49,  /* R_LARCH_ADD24 */
> +                50,  /* R_LARCH_ADD32 */
> +                51,  /* R_LARCH_ADD64 */
> +                52,  /* R_LARCH_SUB8 */
> +                53,  /* R_LARCH_SUB16 */
> +                54,  /* R_LARCH_SUB24 */
> +                55,  /* R_LARCH_SUB32 */
> +                56,  /* R_LARCH_SUB64 */
> +                64,  /* R_LARCH_B16 */
> +                65,  /* R_LARCH_B21 */
> +                66,  /* R_LARCH_B26 */
> +                71,  /* R_LARCH_PCALA_HI20 */
> +                72,  /* R_LARCH_PCALA_LO12 */
> +                73,  /* R_LARCH_PCALA64_LO20 */
> +                74,  /* R_LARCH_PCALA64_HI12 */
> +                99,  /* R_LARCH_32_PCREL */

[Severity: Medium]
Should EM_LOONGARCH also allow R_LARCH_RELAX (100), R_LARCH_ALIGN (102),
R_LARCH_ADD6 (105), and R_LARCH_SUB6 (106)?

arch/loongarch/vdso/Makefile overrides KBUILD_CFLAGS and KBUILD_AFLAGS for
$(obj-vdso) using ccflags-vdso and cflags-vdso, which drops -mno-relax and
-mthin-add-sub from arch/loongarch/Makefile while enabling
-fasynchronous-unwind-tables.  As a result, toolchains with linker
relaxation enabled by default emit R_LARCH_RELAX and R_LARCH_ALIGN in the
vDSO objects, and .rela.eh_frame uses R_LARCH_ADD6 and R_LARCH_SUB6 for
DW_CFA_advance_loc, causing vdsocheck to fail the build.

> +                128, /* R_LARCH_PCADD_HI20 */
> +                128, /* R_LARCH_PCADD_LO12 */

[Severity: Medium]
Should R_LARCH_PCADD_LO12 be 129 instead of 128?  In
arch/loongarch/include/asm/elf.h, R_LARCH_PCADD_HI20 is 128 and
R_LARCH_PCADD_LO12 is 129, so any vDSO object using pcaddi-based
PC-relative addressing (where the two relocations are emitted as a pair)
will be rejected by vdsocheck with an InvalidRelocation error on 129.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-vdso-absol=
ute-reloc-v6-0-161e218dd217@linutronix.de?part=3D7

