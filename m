Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0782A606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n6V6vDa4
Received: by kanga.kvack.org (Postfix)
	id 24DAC6B06F3; Tue, 24 Nov 2026 08:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224B06B06F5; Tue, 24 Nov 2026 08:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113B96B06F6; Tue, 24 Nov 2026 08:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6AF36B06F3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:53:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63F76120B4E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:09 +0000 (UTC)
X-FDA: 85470154098.26.D157EFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9D1FD10000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6V6vDa4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528387;
	b=tDEw2A1Qr5+ufl0c/QL0n59LElhmKINVYvUt3mQzT64GY42CnyHV/To0G30rAqocNEsXX/
	J74q4Td7Fgm/nPqO4255J8tTKmMswDBIaAab45NXm/K6KOQwAsgz91h12BNMfanFp7v4LV
	nNIo1n1cyL46tUMnN4M/RoWbBfqHFWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528387;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuyrmrAt5zZMoD0IMFZe5saEEp+/G3mC1MLq3BDmO4E=;
	b=RBlWSPyP0vundsuRuJzWHNR5ErZKl3rMiHOR/epo3vMA5FHERjFX8qnOEFkLO6+IMr/0YA
	cWW42p7N7nthuOLG7XK1tKCe4Z6rkTUCUqmNy0+HLu+Mrt4tfJL6DMpxZTgUuXvAs412TP
	J65YMT7M4tVz+F7I7W7oWcjxrRmF7XY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6V6vDa4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9E96618FF;
	Tue, 24 Nov 2026 13:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4361F000E6;
	Tue, 24 Nov 2026 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528385;
	bh=MuyrmrAt5zZMoD0IMFZe5saEEp+/G3mC1MLq3BDmO4E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n6V6vDa4OshPnLfFFF8xa6u+VXwPjEo3Xz2P+tsGKYAW2FdXHlCeUQD99f1+/WRMP
	 JuJdbs5N62yF5u7bjvgjRhGUTtwh4jJZl3YBYjlGTj60qkqatb03/BHk/lyQizEMUi
	 Qt3aFzd4HQyxO7LvjwZy75dOh6kcmjt7oOACTdJe1/VHWXiL492uRl1unpuAp7Q98T
	 bxtwBCy3rFgG402XiPBlq2yUKNqJkoOjYsjNtvoXumqPC6USC/oe9QKb35HFwbBsql
	 Oa2mOCfBel/xzZ9Hg5oMid2JyNRmgBvPfijgRDSybD+6ueSni0qhcFStFpmW7+mEbV
	 5pD92OWOIRaUA==
Message-ID: <sashiko-outbox-231257@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/11] ARM: vdso: Enable the vdsocheck tool
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
In-Reply-To: <20261123-vdso-absolute-reloc-v6-3-161e218dd217@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
 <20261123-vdso-absolute-reloc-v6-3-161e218dd217@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:53:03 +0000
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D1FD10000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hdsdiqtgra3ewgiem1514a7wad1czhmz
X-HE-Tag: 1795528387-758162
X-HE-Meta: U2FsdGVkX197fcysFEd9uCmPAo2TmVK1R1XIC5+lYJkEwkn84dC7ciGqpHWIaxYnoBuz2szdIOIWYowIQ1mACyX6Y8g8XklQEnuZZEZ8mvaky0Tbp+ZFyeHXk8FVnov5TBQ5wrTud6aJD547okJP+nNW/QhA4/NxDgoHgxuHRXpiBDxeO50kf+geyngCFB9raK5jlP1WVdcm0oz8tDTJgCEpbmKogv9C5eqYYzsHYkCFXWUcNBW5jPKuued95qBF/sUFmkW8KZABwBz4iPhIJ0hqcLUR0mFPHPVMn1qov6oDULJ5rn2780cl6lpuCP3YvY5S+2n94MK2JBrTAnGHZMUA3z0lGQr3xO1j0JSo5Wno+kYMoDRaLgrSzqbZfW1AfOf1bTtrIywUvQhk1SO+AxoWhGkWKCmsJ6PK7eYZn4WmUxu2qpev8kji/iGY0MyOXJTdIZ1k07l4DDy7r72SEASMw2aOI7R65e8KMQPFqE794deeEc0uRA/e37CZm8JYnPJiCBCsD58/GzMJ+d8PbK9KBtryRTldUIEUOY9oTvCKczdwZSAK4cwLu6/ISxzbs9xfp+O+4zZ54nwNo9aqrtKCzUlXaeLiWpvWZ+uP6KVgYDJ/2o2t4hunjT8jJ8qBJBnNpXABn7obUpEVT9G2kNOmEIzzp2A9JI8+DQdD6Hrs5pu6M9DEsST/09bHTuFSNqLRGobUdZn1LPtHVjIripXMl43wehvsfzFphSRRMd/zNa2FGJaiy93IJD701kMTlouVXwlo4uwbaCc5R+qd1/lTMFBuq0Cp1MrsrzjfV4DrwsFBlV8zXikBF85jCR++KslGpAYMk+IB+SBzlpY5Dohal0gssZmfnoeHXUXbPqosyDCkFCIu4Flif9SfjHFPw3LqC2VC4I1HREgve89eu+I6HyDEVLCitXYEy5G1Bl5w5cwi6aTb3mlnazAdJu7nXOAdyri4ociLBfzEVUs
 7F1SrO/y
 bE2KBh7vNJCqmsIkr/oRbR75L1iLBtUWX4kAp6djXngzHeG/6FVDlVbZ2cdOW2Ztdql358N2g7ndzmm8WxFeft4AxQ9KzLpIJ+QdxSvaZPzURip1ltPEH0ZTmF8hSgAs67Ps/sjPVnVI8uFCL5q4T4baVmKk12202PwCI7QxbiqgFHhUEGRH2a9bqeZR8Aca+DZckBeBSaqT6dclH+4pIkuXaPyBcRnjP/gO4KztAMYXNsDA1ISdHHLVxMLdgaPDc0xPeZA9MoPjac9XvSTx6TEjFW6XRFckMEjgiw9mEFzJlC5qBdsgTjPOWx/Ss3XlraDBJHrWSVSYz47E78L8MbbphPqYxr/5/JeHDangKmxINkMjnsF4wLnTSzJFxCtXOVr7vgkJEn3q2ACi3S07xFc+1DPDd/24E3HQLSR1Sa3grtjWk2NJg7C0GZMpBB/YWVhTWEIORCsz9I2LjSYe8sXZPv3NdmWAryIbr8wPLdlGWYOaIIeh16zMHh66vv2BrWtoFroxwUQuuXs8CEFYIOPuzyY112fejM2gu3Mb9xD+AHCNuSQpUJT/oLrcaiDekcMnwSilZphgGvBYwNXZ7m3X0eF3hsTPJEemiFK6iXU9tu8juW15Rs5ICyzXCkGQ0LV26+5L6VBlewwLbiKIim7va4EWDB2nw+vS2i9NACMLGLR7i1LgOU3LWi0F4AyVlDiA3BG6u5rko5q6FIpzBNivyz6HbTwIaicaeDRbTbIPeACFAQlk/vLEwt00T0YwGdUKiaKKJHUF3NB/UZan9obWxkn7Oytgo+aXWFcD9E3zxI53l0NDfJBvL7lWy6KUcxplR9FARwtXyNyhkZTBh0ihEcTlCVj4GIdUPXNAn0UUFC/IY2IOxZLSSLz6F7h9jJDaU9Ym31ACtO9E=
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
- [High] ARM: vdso: incomplete EM_ARM allowlist in
  allowed_relocations_for_machine()
--

commit cb0c70494d3f8ce1bc0651e74508d837c36a4e17
Author: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

ARM: vdso: Enable the vdsocheck tool

This commit enables the vdsocheck build-time validation tool for 32-bit ARM
vDSO builds and defines the allowed ELF object relocations for EM_ARM.

> diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
> index 8cd8c7f3fec85..e28ee59a900dd 100644
> --- a/lib/vdso/check/vdsocheck.rs
> +++ b/lib/vdso/check/vdsocheck.rs
> @@ -48,6 +48,15 @@ fn allowed_relocations_for_machine(machine: u16) -> Op=
tion<AllowedRelocations<'s
>              ..Default::default()
>          }
>          .into(),
> +        bindings::EM_ARM =3D> AllowedRelocations {
> +            in_object_file: &[
> +                0,  /* R_ARM_NONE */
> +                3,  /* R_ARM_REL32 */
> +                42, /* R_ARM_PREL31 */
> +            ],
> +            ..Default::default()
> +        }
> +        .into(),
>          _ =3D> None,
>      }
>  }

[Severity: High]
Does the bindings::EM_ARM allowlist omit valid PC-relative relocations emit=
ted
for arch/arm/vdso/vgettimeofday.o?

When building with Clang (or with CONFIG_THUMB2_KERNEL=3Dy), accessing the
hidden vdso_u_time_data symbol under -march=3Darmv7-a -fPIC uses movw/movt =
pairs
with R_ARM_MOVW_PREL_NC (45) and R_ARM_MOVT_PREL (46) in ARM mode, or
R_ARM_THM_MOVW_PREL_NC (49) and R_ARM_THM_MOVT_PREL (50) in Thumb-2 mode.  =
In
addition, when static helpers in lib/vdso/gettimeofday.c are not inlined (s=
uch
as with CONFIG_DEBUG_SECTION_MISMATCH=3Dy), intra-object calls and tail jum=
ps
emit R_ARM_CALL (28), R_ARM_JUMP24 (29), R_ARM_THM_CALL (10), and
R_ARM_THM_JUMP24 (30).  All of these resolve at static link time without
producing dynamic relocations, but vdsocheck rejects vgettimeofday.o and fa=
ils
the build.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-vdso-absol=
ute-reloc-v6-0-161e218dd217@linutronix.de?part=3D3

