Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AAD3606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JvLdvSJ4
Received: by kanga.kvack.org (Postfix)
	id 99FC46B06F1; Tue, 24 Nov 2026 08:53:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950D76B06F3; Tue, 24 Nov 2026 08:53:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8660C6B06F4; Tue, 24 Nov 2026 08:53:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59E576B06F1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:53:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2E13A8855
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:04 +0000 (UTC)
X-FDA: 85470153888.21.A45DBB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4371340009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JvLdvSJ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528383;
	b=JxKP/hsWmjm4UX1hyuPO/VL0JzryT7Uhnm/ulmTvk8zOyMypSjkKY/X7g3dgoW4aWilkYy
	OLqxdo64WKZbs8Wzh6iDUxuyiblyGJjH/HzIUE2DkoNTkDjDY/xI84YkBdoAClL+KToI/c
	8o4joXbPSrNLk1cvhGICa/e5sZdRu2Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528383;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWvMadnd77P5qOWpO7fx2KjLWBvQbyvwlTf6Vj6EPJU=;
	b=KoRZgqLesZ7IAsiuE9crGQ41FXbNq8kQGKe45sdOP4nUvW6JOHlGpeOSkbxd/FoQu0B3Ph
	hXy1lmyyzm/N3K4wVSHfY1Z1a6HheR15ZZu2mYvpF/E93YkliVTz3FZz6AXl8VrWFACvW+
	XpX0+E3QfbbxQoXzLc7S54eIR5MlVRg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JvLdvSJ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 586E04244C;
	Tue, 24 Nov 2026 13:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B70B1F000CF;
	Tue, 24 Nov 2026 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528382;
	bh=DWvMadnd77P5qOWpO7fx2KjLWBvQbyvwlTf6Vj6EPJU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JvLdvSJ4ZQRhtMSVhYEQM8sCZYPJ08nvGnxURU9+rKpeQyJI0XxcQb+ZbrYwxQs5R
	 I+H308Vtx5KLDh4cToEa+cc2bPxZA6WcwV2VHLGaPcqT4I1xOpom7DXjNCXGdEQssz
	 /ZlyRghZvzRVqe/fXLNdQFXzPlOY/dZMD3VvrCXPP5VR4f3HK9kIzru3hDeSwprB+i
	 XKsHPRKmJ0THk6BoBKoUe5ccURiPstHFROGqKnjMY7LYuSRkiTuJm8SovGuqCctLcu
	 r8jx4jXKc9iJ9msojTtXGPo2RQWVsQ+U0Bhs2fYe26Z2QdrFNoEn4Qvo0SYp6/cw7e
	 Fa3xgHRVdKfzg==
Message-ID: <sashiko-outbox-231255@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 01/11] vdso: Add the vdsocheck tool
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
In-Reply-To: <20261123-vdso-absolute-reloc-v6-1-161e218dd217@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
 <20261123-vdso-absolute-reloc-v6-1-161e218dd217@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:52:59 +0000
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 4371340009
X-Stat-Signature: 1sd4wpgwmbndhi8fz8q553zz1zre9y83
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795528383-510491
X-HE-Meta: U2FsdGVkX1/M8ZCGgUVIsIm3Hwv9y0bZOoBRmNuWb0+hsHKIfwD1i4Ps4thsNn6T0zZR8+kLLy56wbvQtp5WHes7GLPAzk3KXG2VYkmBIcE/62MzjGY7BYXPSrdpUJy4pA6NsNn4JDrp6XASOI73g3ibsGir9du+R3NR6PRQBjEwfFHBnRyULDPqJicN4iAWCiPoSc/8GYMOExT0kiMoiE0YPlk8MTAO5iJK7uKGUKMUHyuWqIncpUe1AEdB58uaGthSFyqkc8/fFQuaRAxMdB+gMVDwNZTXU5Zagg5vDnviwKXisexLPT0mCzWu6Y85IT1hogY3AjbK79fcJBviFvlK91BLsySxlUrmHS4ujU+ZsquuvJso8GiCRHi8p3hyiLs8MjDYX0HcOrOiXSYqXCLHzMe2CmVCx4KZ7YVFj+MVtrgZ7OOI6yEjIb3/Hi8v4xcW9eNBaXqoB4A8qd1zQzAkkumLmhWCzZ/bzYMQVKpICSe8rnPgO3v5oU7j0TgQebffupo8PK8dgpmqDdq9kdZ+iVZa6Xn8JdWF3DCOF1GYGMtEIvoNyAMssEW/r7B0jqCiaSaSjDDlJ66vmtSB5Q8h3+lFwcwybxmqGgamA003d/cSOrWD6toc0cRU3bT7pPtwf3CTtW+E2sCtfFxmh6ZMlFMuVr/6QGbcZDvhJYVg69+XNbIcLa+jU1bdmgZ3dxcD+GijHrlsOKh58Cj1i83jQ1ypnRcMpLlhJrxqfbwE1PI4J4vwm7vOFO+6T784q6K2YDx2TXi6CWuz5wMlGNX7vGeWLss9gVXBTkjvNbgT/sz5yexbl8J0PVon49D/cWGJZ4YL3MmpAFuQwyOalD35xj8Cr3OmF3BNiGbFbEgIZnP8oYxpSZIHKooyta5SfzCzV7pciTWYdh7DvqMpKv4E7V4xAfI14TYwCNR4rgoBTb3Li+w87o+ZYoI0KcdP2czub6/y1EvytJWWbIU
 RZPVSYow
 WUEAjoCen+Re82gQvsM9moXW2XfoL6ocYfG+CCWsBeLBDy7z1/v8mfmNLjCTqVtKqCtpMHHEg3Z5Fxw9ijXJkMJjm37kca3Oh12symu9Yo0LdBPNTamLDvy5JOVAQwVHNmKQIJq8ctog5o98ugyF0Hjr1hO030UHQ8uuWyRwc52Z9+rWnwAg8E7f432ZHeIqb03QGpCzp99GdxjbaJXsA7+jpZnpsxilxjYQGExijRkqRlDOelcrJx0NiccrX9km99uh374YUOok0Y6QIYih+ZOmfnrDG4ovQgo6moP1EjKwQb6/JPgwuoSawQqAhy3+RAusD6q81JL2CsWSwCqkErtInYl/g2YEUFBz9qQZs3J4G57J6fAXh/Ijm9pVO9hAjoJqRLZ3IHKpUBY2JlH57dxwbXPRHhe0iTTVgEQd2qPiMGrv4dRdsgQNN3lfAkuIBIutvbwU3X52uNWdMAu2SaWQLB1W9Oo29MfzK7U1Q27WHH4wJRZ6U4TJ2cFSWw3GxYWqbOMmg3G7j0bQJmbr+AGpA4HdGtX+dTywctgwWyzK08mVhZOaZXBST7VfNjbpOewZpdXiH8qQG8Fcdy27kh1/ppI/etf2v4bjjXuIH4vFYNu+R1ot2zMZgla9QTcoiFLTNV9fPIYTnSSU/r5BIdBXzGFLY6CET6A6tNBjpXr9aSoZimXGnsWTJskkApgd2ifH9BNEVHY3kc1dXPZkfdp85vuMO7iFjwZu+bCyIEp5y1goIRTuj56dCCrGp2xjCDraw/820N7CND6sXCh7DH1/CCgJ8VMvH0rjAWL4Iu5Sm0nZ8zrlteU79wjPt4pd9ZmDq33wpg2uAplKLCnskdvejJ6vvGgS+58NVFjbx7MxLYdrxj0swB+H222IIZBn4CeeAePzvrfEF77vWElKgeTJ9UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [Medium] vdso: vdsocheck uses Rust 1.87 APIs breaking 1.85.0 minimum
  version
- [Medium] vdso: unchecked slice in get_data_subslice() and SHT_NOBITS
  slicing
- [Medium] vdso: missing include/uapi in HOSTBINDGEN_FLAGS and + on
  host_rustlib
- [Medium] vdso: validate_linked_dso() rejects SHT_REL/SHT_RELA with
  R_*_NONE
- [Low] vdso: missing scripts_basic prerequisite on vdsocheck Makefile
  target
- [Low] vdso: vdsocheck main() prints errors to stdout instead of stderr
--

commit ba87ba62d5b7688443f8778322978989d53ab4f8
Author: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

vdso: Add the vdsocheck tool

This commit adds a Rust host build tool, vdsocheck, along with Kbuild
rules to validate that vDSO object files and the linked vDSO shared object
do not contain invalid relocations.

[Severity: Low]
In Makefile (at the vdsocheck target, lines 1575-1577), does the vdsocheck
target need a dependency on scripts_basic?

Building bindings.rs, libbindings.rlib, and vdsocheck in
lib/vdso/check/Makefile uses if_changed_dep, which runs
scripts/basic/fixdep. In a parallel build from a clean tree (or via make
vdsocheck), vdsocheck can run before scripts_basic finishes and fail with a
missing fixdep binary.

[Severity: Medium]
In lib/vdso/check/Makefile (lines 18-24), can building bindings.rs fail
when the host lacks kernel UAPI headers or has an older
/usr/include/linux/elf-em.h?

tools/include/uapi/linux/elf.h includes <linux/types.h> (which includes
<asm-generic/int-ll64.h>) and <linux/elf-em.h>, which reside in
$(srctree)/include/uapi rather than $(srctree)/tools/include/uapi. Passing
only -I$(srctree)/tools/include/uapi in HOSTBINDGEN_FLAGS causes bindgen to
fall back to the host's /usr/include.

Also on line 24, the $(call if_changed_dep,host_rustlib) rule for
$(obj)/libbindings.rlib is missing a leading '+' prefix, so GNU Make closes
the jobserver file descriptors and rustc emits a jobserver warning that
fails the build under CONFIG_WERROR=3Dy.

[Severity: Medium]
In lib/vdso/check/elf.rs, inside get_data_subslice() (lines 87-96) and
SectionHeaderIterator::next() (lines 355-374), can get_data_subslice()
panic on out-of-bounds slices or on SHT_NOBITS sections?

get_data_subslice() checks start.checked_add(size) for integer overflow,
but then directly indexes &data[start..end] without checking end <=3D
data.len(), panicking instead of returning Err(ParseError::IndexOutOfRange)
when a section or header extends past the end of the file. In addition,
SectionHeaderIterator::next() unconditionally calls get_data_subslice() for
every section header using sh_offset and sh_size. Because SHT_NOBITS
sections (such as .bss) occupy no space in the file, their sh_offset +
sh_size can legitimately exceed file_data.len() and trigger a panic. Using
data.get(start..end).ok_or(ParseError::IndexOutOfRange) and passing a size
of 0 when sh_type =3D=3D bindings::SHT_NOBITS would avoid this.

[Severity: Medium]
In lib/vdso/check/elf.rs (SectionEntityIterator::new(), line 285) and
lib/vdso/check/vdsocheck.rs (main(), lines 134, 139, and 150), does this
fail to build on Rust 1.85.x and 1.86.x?

The minimum supported Rust version in Documentation/process/changes.rst is
1.85.0, and KBUILD_HOSTRUSTFLAGS passes -Zallow-features=3D to disallow
unstable features in host tools. However, usize::is_multiple_of() in
SectionEntityIterator::new() and OsStr::display() on the OsString values in
main() were only stabilized in Rust 1.87.0, causing E0658 compilation
errors on older supported compilers.

[Severity: Medium]
In lib/vdso/check/vdsocheck.rs (validate_linked_dso(), lines 78-92), does
validate_linked_dso() reject linked vDSOs that contain only R_*_NONE
relocations?

As noted in the comment above cmd_vdso_check in lib/vdso/Makefile.include
and in commit aff69273af61 ("vdso: Improve cmd_vdso_check to check all
dynamic relocations"), some GNU ld ports emit trailing R_*_NONE (type 0)
dynamic relocations in .rel.dyn or .rela.dyn, which the readelf fallback
explicitly filters out. validate_linked_dso() rejects any SHT_REL or
SHT_RELA section unconditionally without checking whether its entries are
all R_*_NONE.

[Severity: Low]
In lib/vdso/check/vdsocheck.rs (main(), lines 134, 139, and 150), should
these error messages use eprintln!() instead of println!()?

Silent kernel builds (make -s) redirect stdout of build commands to
/dev/null, so printing fatal errors to stdout hides the failure diagnostic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-vdso-absol=
ute-reloc-v6-0-161e218dd217@linutronix.de?part=3D1

