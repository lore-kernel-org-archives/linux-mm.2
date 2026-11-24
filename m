Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6F1606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSw53pwm
Received: by kanga.kvack.org (Postfix)
	id C86A16B06FB; Tue, 24 Nov 2026 08:53:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10306B06FD; Tue, 24 Nov 2026 08:53:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8856B06FE; Tue, 24 Nov 2026 08:53:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78DE06B06FB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:53:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D8E41C46AB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:22 +0000 (UTC)
X-FDA: 85470154644.20.01E5325
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id D130720008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSw53pwm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528401;
	b=FMPzMZxZuXRrtwoQ1xhsjB8ScnJauXzDPlKhYDgBtLftf/RlW46YxDLyYTiaxaJZvD9DVm
	sDSE66D9rUmSQGk1mVxg2WQK00dP0JPuygYMDCKgNsrg7s96HWgKbmOE8ewdI6J0SyY1HX
	mn7hnwTD77SG2cfBGAiekve5xLQRWTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528401;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDRW3UODYLDeDsSDV5ah2aP06esfAD4UXbPE12d0+4c=;
	b=qoLXaRMTpl3n2bfr6HDS3A2q2pXqluI7QCTrijgKBKRTG7OsVyp0Zsx0syepNTHtrhuJhX
	AkZEi8B/rF/AB2DfrhhKAXOqJqKYqtwIj1+CCU0n+2md3vWVX6u48zma8gn2vjWFNXknGw
	qZQOmOL7iPvZCjmB4Lar6nSjgPZgXyA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSw53pwm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BF0D43A9C;
	Tue, 24 Nov 2026 13:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2081F000E0;
	Tue, 24 Nov 2026 13:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528399;
	bh=IDRW3UODYLDeDsSDV5ah2aP06esfAD4UXbPE12d0+4c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kSw53pwmEmiFYNYQPpy68ECmj5Bx1omrwn06yw/ZMC7D3YfAL++Pgtj4yPP4TW6P/
	 tQxAvw/YPdI9ZWzlmRE5CpRzYDsV3NtxN/9DXisBwyazQLgN30UrBfAb+IHagdGCNb
	 389oGJ3NK08Vhr/hJb28oH/MbIG8lp/xtPbAwdj7wpXIVNCG0cjQr29tg7e5GXtzub
	 QjJEE44jWffKFWS1mTHpzAnorVZgbgiLktq9jgJuPAjl3QwkTUckYlC+M6S9OYMhRA
	 0juoxRmEnabSi0OiKqRcMezUKcq9AmAavHrrI1vgcCU1dH9M47jDNHLNJMphFO2leY
	 I05I0qdrrccKA==
Message-ID: <sashiko-outbox-231263@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/11] MIPS: vdso: Enable the vdsocheck tool
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
In-Reply-To: <20261123-vdso-absolute-reloc-v6-9-161e218dd217@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
 <20261123-vdso-absolute-reloc-v6-9-161e218dd217@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:53:15 +0000
X-Rspamd-Queue-Id: D130720008
X-Stat-Signature: znxnx1wsncdg33k8xboect37c58kbewd
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795528400-640174
X-HE-Meta: U2FsdGVkX188YZXFtzx4CUHG6ck+0hgDaT4g8xPHcTXnJm0Wm6Rg8/tCYGuKZ7XGgHaPY4DUdegvE6dPi4hWh0AwcRu12LsBx/cwnozUqkcQhl8nNQY14/IIV4w6vlZWOIGvTIA66mzGUJcF7DhXYsaNdnRNL50bW7YoZWlgiMPSXviIBSbXjcO4C1V/+OLPTnxSdQ3uE6MIBz6mvwMS2BHSsKgv2ZPxvlBZqkNuVKR2rxlhDpnfycNFUzRAOxK98FBtDg1KTSu1SB8t/rChKxyv+AcJX3UOwpIO56F5Z7y9yLc87NGMIwJfyt6eg1nULTM16Kyx7aT+0RzmsZp2rOrF1lMt7+VFegwgoiiJtPbgn1CZlzjPkrDTze0KYLT/I7F5e3EkAoXidO11gAIY0L0pRAm8ZvkvyCDAqxTxd4FkIsOmKNgMUeryzCLDj+K7qTP90kTpJuqNzZqUo6vAL7XLSEu95LU0s9mYW+J0CZ3oa2QxcI0o5a80+CvKl7AXBq+hg7Hb1QEI2pjOUB9/uXIadT1MF1fUGhSrEttJhCpvSrIDfuBiyGvKrtPRdvyXe/CJ34BW3xMVzwud4D31T/j9sYD4VjsO303wEljsAL3SfkpNw+PdysHOst6I3htdczzuCaqYwEYoCc8H4mlw/pUpNKWsO7uxgo6jv9XvmQ6Xg4a0et+HJGg0mB3fQ0e7ENoXY+biMZHJ2yrA1I2JK7LJ7I/lkoe7sTqiMD2mjHQxI+eFgV5SdoMnWYjtsg9eBEkQp+n5xlVedGUnV1LYbWsm0r4Zx/xahv1KBtobUtVHArAvn0e9UyVB66wqR+0cZMvEbMlfd90p97Ng8TZah8H+1N9z+c2CVIFNeyEALPjeafneKpG1OFpc3RqHdnkL05jE12hjcdsQwhblZw0FgTsg5SnpIPmsjGQB1JmGgZtYwunrHp7DPjN/Dhm4rJL8Uhq5NQN4x3tarwzvMcW
 Z5mPtZqs
 JV32zLadUEwdSAJL274TPkuOUgTGTYrx5TS2Wy3SLSF2JjHmYhAIMny6fAJVrY4oitAPIVmHglhSB/8Bfd8UO6iIdgLI9dzUO6DxC0IBEhtZfa2ZwlI/aOUuyEvh/VSQ5kXVEYz14ASt17YMsiC4VDJWm1sX0XRRftvD3SCiTjyixV9mstqBmGmxhEKItQsavyfwZ+TyACHRAkZl0smzAt/d6Kh2Al+5ad5Nh9qUgK5u/BwjaizisEUzjUGyd6zpAH+C/C/dtE8ThTz6O0qeVFqjL00i5bKIiNS57bMHRSliwphFkGj5KFAB09xi1jKxlDRNvzjcHOVvlTqtrwVWukEnqIbWjgO3bozfhblCsZew3uLZy6UIHNsJ6eut7W1Sd4j0NIEDO74Tne+7qGvC2xFYN1N5WN6hqZjQVn1qL1xE2wcxIzdLKJXhDRFXHnqWcb2dQJg7IVeTkDoSnhoT59LwrMwUJbkIyX7bh3UGxlnNcRVX+iQ4YCZlc+YgKhNCdtMLftNuhuCjzm0XYCDeT0PP5HWT4l2nj3h7P/VTPWMCkOG0sRYrIM/rH2x+SwZVERRB4fzlaOKmX6DrA+rjF2oTpNSLVG7hiQPNm7R3CGkexJZRaSTSt1+kYl8k7rTmZW+3g76SyzPyfvYGyVBlBZW0UNYNH0mqLr2WgpQPLf5gfqQcb8dNoPJY1Q7SU5McBYYThYaylC//kEZ5YF3RKtTygLZgCR2dsxOA/ox1wPD6z0jTUaR6E0vVuUnwiB4qJqu2HTD6K5oBF4glcI1P28g1XLUUmMUy9F+Fn036luH7Fb+pNLszH5KP1hB0WtjKt/lgn6W4BHjwXn/HtV20KcNXgH/rygwXuiY2KoJvVboADgADJmVd6s/TLK4evkjjXRddrVMFPB60GiFgNiQuwrCpEKA==
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
- [Low] vdso: vdsocheck misparses 64-bit MIPS ELF64 r_info relocations
--

commit 2aab3cbfe50b7d8f9c6cf9cb786fc8880a6ac472
Author: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

MIPS: vdso: Enable the vdsocheck tool

This commit enables the vdsocheck tool for MIPS and defines the allowed
object file relocations for EM_MIPS in vdsocheck.

> diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
> index 1ef3f240f886f..120d8fa551e6e 100644
> --- a/lib/vdso/check/vdsocheck.rs
> +++ b/lib/vdso/check/vdsocheck.rs
> @@ -157,6 +157,21 @@ fn allowed_relocations_for_machine(machine: u16) -> =
Option<AllowedRelocations<'s
>              ..Default::default()
>          }
>          .into(),
> +        bindings::EM_MIPS =3D> AllowedRelocations {
> +            ignored_object_file_sections: &[".rel.pdr", ".rela.pdr"],
> +            in_object_file: &[
> +                10,  /* R_MIPS_PC16 */
> +                60,  /* R_MIPS_PC21_S2 */
> +                61,  /* R_MIPS_PC26_S2 */
> +                62,  /* R_MIPS_PC18_S3 */
> +                63,  /* R_MIPS_PC19_S2 */
> +                64,  /* R_MIPS_PCHI16 */
> +                65,  /* R_MIPS_PCLO16 */
> +                248, /* R_MIPS_PC32 */
> +            ],
> +            ..Default::default()
> +        }
> +        .into(),
>          _ =3D> None,
>      }
>  }

[Severity: Low]
Does vdsocheck misparse 64-bit EM_MIPS relocation entries in
RelSectionIterator::next() and RelaSectionIterator::next()?

lib/vdso/check/elf.rs:RelSectionIterator::next() {
    ...
            ClassAlternative::Elf64(iter) =3D> iter.next().map(|n| {
                let type_ =3D n.r_info.to_cpu(iter.byteorder) as u32;
                Self::Item { type_ }
            }),
    ...
}

Unlike standard ELF64 where r_info is ((r_sym << 32) | r_type), the 64-bit
MIPS ELF ABI lays out the 8-byte r_info region as a 32-bit r_sym at byte
offsets 0..3 followed by 1-byte r_ssym, r_type3, r_type2, and r_type
fields at byte offsets 4..7 (see Elf64_Mips_R_Info in
arch/mips/include/asm/elf.h and get_rel_type_and_sym() in
scripts/mod/modpost.c).

On 64-bit little-endian MIPS (such as 64r6el_defconfig),
n.r_info.to_cpu(iter.byteorder) as u32 reads bytes 0..3, returning r_sym
instead of r_type and causing vdsocheck to fail the build when validating
64-bit vDSO object files whose symbol indices do not match the allowed
relocation numbers.  On 64-bit big-endian MIPS, it packs r_ssym, r_type3,
r_type2, and r_type into a single u32 instead of checking the individual
relocation slots.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-vdso-absol=
ute-reloc-v6-0-161e218dd217@linutronix.de?part=3D9

