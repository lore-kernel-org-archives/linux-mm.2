Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DB9606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 07:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aUa37rW1
Received: by kanga.kvack.org (Postfix)
	id D9A476B05B3; Sun,  8 Nov 2026 02:44:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC476B05B4; Sun,  8 Nov 2026 02:44:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BECBB6B05B5; Sun,  8 Nov 2026 02:44:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8657D6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:44:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 274B31C3C02
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:44:02 +0000 (UTC)
X-FDA: 85411163124.27.44D91E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7990FA0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:44:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUa37rW1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794123840;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXCPeO3Cu6ZPx5gS1AzpZnHWW6O2eFdMyDyLFjjerps=;
	b=G5hfKPibZi+Crjjstg++/UR+Z2niW8fxoaF88NtIVTbWE+uCfi/k82sbuwEAu4G5ctQMHs
	5frsYuOsKkFTu6UMVcVSaePk25vLedwG7Z/wGunzvSKOVMBrusvh6V0fJV2NEDlKExavj1
	uAN9oSYhu+2py7O/bKvGaZ8Q6smXWcE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUa37rW1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794123840;
	b=GIc4Oh2eswtsgrYFrVoFrP2ottlkLXHsdSx3BZ4wTwNOyX/GHRHccGhuwb3ZTDy9ytVMCr
	dNLBQiC+AGdixBzYWEAHUmg3CpshDt2IDz6Wqfwplk5Va08C3bd59NyPx9hN9XQGePuAtg
	V5kqJ/l0zgj6kmldPsAgjhc6fhx8Cto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C57CA42A55;
	Sun,  8 Nov 2026 07:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BC81F0089F;
	Sun,  8 Nov 2026 07:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794123839;
	bh=aXCPeO3Cu6ZPx5gS1AzpZnHWW6O2eFdMyDyLFjjerps=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aUa37rW1bUQ+YpnmV8YzfEdNqettTVSpVPUx3M5KsoIKwX/ArS8imfkcJCWJAmVf2
	 B1nVte5FM9nfH3cpeS8s7WiuMKTl0JCmLgj4RPL8+dHedLkZM1kyuQ9zQTTbSiflv9
	 OefgknYqcjAgoZuFU+eC+uyMTfCLGtGJEQKrnJ8ZSvlpNJL8vcBfGaV71d0pDe4y75
	 cincQDRUQ+BztHLShRJ9NHGzHpqF6xOV7cEcByg0mNmpDlfLgyF/iZS+apecoHeuIj
	 M1rqwesUvzN/xL2Y9RdGCVjvzmHxdbd7LYeYCvj1/HfHJ5UuplMTsh4pnwjTmNxRh2
	 vpdF7a/RA5+uQ==
Message-ID: <sashiko-outbox-203636@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] arm64: alternatives: Make branch and ADRP offset
 helpers noinst
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jisheng Zhang" <jszhang@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Andrey
 Ryabinin" <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Tejun Heo" <tj@kernel.org>, "Dennis
 Zhou" <dennis@kernel.org>, "Christoph Lameter" <cl@gentwo.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261107071339.17467-5-jszhang@kernel.org>
References: <20261107071339.17467-1-jszhang@kernel.org>
 <20261107071339.17467-5-jszhang@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 07:43:58 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7990FA0002
X-Stat-Signature: na8y5697crhsmynyinofsiti1irriakq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794123840-287949
X-HE-Meta: U2FsdGVkX1+dKhE7mkiH9Ps3HI2Wn5rta7hi5hAcT8CoKV9OdPUKFATwlPfu1lfW0Ri9LsAAfNiakXbZ5HS/6DVEHGq/DfFD9g2xn+/ud8/APQ8MEdk5eZDnZGM24asBtH9zwh0LM4D2HrR8DlTjekbg4JsRZF7pwJChmfySjhuXlWX+QmUfN+K5QgB2JOYz7O0oa9XVmbBWXb0c97I1tFg3nc5culzdAWTCRnxqoWhHLRJ1LfaZ+pIvpn33ivblDMGuxRHO7YCeVENsgr2PraDLk3SyEfkAKx2dzHqBs550wDQJBy1kE3oBms52p5ve4sQWMsy5BCcD+eacj1AbrUx8yWKtQZ9V57kxGU0Ava8A8cfHwQvtbwA3LoC7jZNbCKebkq5jb1dJ6tpHuRB8RH3xbMVjbsj+XpEWqxG2UqVYCgS36HRzx6RGbtnDJDH6dOsM3UWhmh5VAeQdhkwiRpde1w4DdycFZwuLml8SgD4rI3FO58qBkNbfVo9tR1fRKtXRHwNbT0Gg6NMEAoKVDTrIOmnmXH9OEyZA/sZn1KwdTfH4rZmNzSedC3QVPxYRZjLT5lq/xQuvx8o2eHvUDUx9o0nZNGkb/36RtSPJgQ46gc+f0EkaS7bLOatEsV+mfx7/vjNe/a8++tZvvhVnprVOGGck2tSTmFXNBWnZFh8qsheArtJ93Pg8SZ+s8Ar0sNiaCbsKH6S67klfCmL5syA5kVVaXbG7iHFSYXgxWx/03jISpSEgIFtu7CMZHCINj3aJXoBBcnQVqcpqbP2gA6Yv8U2fryhpiF/pAktPonmBnowuRDa8B65B/BX8cSd44xvwCiPNfWG1ZHLmDXg5FfbFaC/5n8m5dtk6o8l0HceninTkN/5Fup4Ex58XT2zlvl07uOTmfZQZsWRnrAPdJ9iIpZHu6/EjVUFJbf+o41LjBn0LXjg9gF09E6bs6woL5gxGSmPrFpo9dPwqtW9
 agJWtpyV
 K9jc02NPVHKJq+NlxaOuz5mqAGSIid/KQYiyF4rk9Ae0kiAkpdyr0pIJ5njpnq7anMMpUbgbQ8JgX/wtHFPZpeDKmHtMD00kbmJbIwly98qn46VH10AuCT4gph/gCQLNahjKNSE3Umdd/tsMB/466PH2Oa89BDqW1h01tD+TTAA3ellU82cdKS+o0D5pI2AeAoNeqzPoQ1TMAKFvsNQXFv1H3wBwxe9VaA0OxgBc0hlwbtMG5pKRZJoBKJn4OwyPppD+FsopyUsyn5ryMEQxZ3Zn8iVfsoSr0eMgYmIAIqc4rsZ8Lb62OQRxsfuN5Pds06nT18Z68m994xRnZ+r0yvno1QC2ebU3TvDhB8Xh+741HFE8Jo0+K0NeKxE+8C6JmTUUMKcXqeap6RJ7Rx4CCCTWZ37gpedPlGKS4yYQoE0rUFEm/UjNuKRNFDU5IvwAu3rM8VqWQVLb4J21BpjbnIySmL9x5ZDW4sboVVHQbHOegVwplN008CiU4aFH7JNu+G4d4MKEf5N+gwW8nuQ4+5QBkRL4pJKbyJm5j0kVavSNX1LMDfQYF9E/XUBBI5HMX6kWEv0gUoQFf1ppKoiuo10at4cga1MzTyjKniTEV1FDfIkhmfFASQoNIhg/6a8/IK4Uwy7bhPZ6ru3zCmLTDCqAP0OXz9IQgPsA3
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
- [Medium] arm64: insn: branch profiling instrumentation in noinstr
  offset helpers
--

commit b08429609214cdffaa257c9ef953b28e179973db
Author: Jisheng Zhang <jszhang@kernel.org>

arm64: alternatives: Make branch and ADRP offset helpers noinst

This commit marks the branch and ADRP offset helpers noinstr and introduces
__always_inline immediate encoding and decoding helpers so that
patch_alternative() does not call instrumentable code while modifying
instructions.

> diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
> index e70ac02385153..b98610fcab32e 100644
> --- a/arch/arm64/lib/insn.c
> +++ b/arch/arm64/lib/insn.c

[ ... ]

> @@ -1299,23 +1316,23 @@ u32 aarch64_insn_gen_adr(unsigned long pc, unsign=
ed long addr,
>   * signed value (so it can be used when computing a new branch
>   * target).
>   */
> -s32 aarch64_get_branch_offset(u32 insn)
> +s32 noinstr aarch64_get_branch_offset(u32 insn)
>  {
>  	s32 imm;
> =20
>  	if (aarch64_insn_is_b(insn) || aarch64_insn_is_bl(insn)) {
> -		imm =3D aarch64_insn_decode_immediate(AARCH64_INSN_IMM_26, insn);
> +		imm =3D __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_26, insn);
>  		return (imm << 6) >> 4;
>  	}
> =20
>  	if (aarch64_insn_is_cbz(insn) || aarch64_insn_is_cbnz(insn) ||
>  	    aarch64_insn_is_bcond(insn)) {
> -		imm =3D aarch64_insn_decode_immediate(AARCH64_INSN_IMM_19, insn);
> +		imm =3D __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_19, insn);
>  		return (imm << 13) >> 11;
>  	}
> =20
>  	if (aarch64_insn_is_tbz(insn) || aarch64_insn_is_tbnz(insn)) {
> -		imm =3D aarch64_insn_decode_immediate(AARCH64_INSN_IMM_14, insn);
> +		imm =3D __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_14, insn);
>  		return (imm << 18) >> 16;
>  	}
> =20
> @@ -1327,35 +1344,35 @@ s32 aarch64_get_branch_offset(u32 insn)
>   * Encode the displacement of a branch in the imm field and return the
>   * updated instruction.
>   */
> -u32 aarch64_set_branch_offset(u32 insn, s32 offset)
> +u32 noinstr aarch64_set_branch_offset(u32 insn, s32 offset)
>  {
>  	if (aarch64_insn_is_b(insn) || aarch64_insn_is_bl(insn))
> -		return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_26, insn,
> +		return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_26, insn,
>  						     offset >> 2);
> =20
>  	if (aarch64_insn_is_cbz(insn) || aarch64_insn_is_cbnz(insn) ||
>  	    aarch64_insn_is_bcond(insn))
> -		return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_19, insn,
> +		return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_19, insn,
>  						     offset >> 2);
> =20
>  	if (aarch64_insn_is_tbz(insn) || aarch64_insn_is_tbnz(insn))
> -		return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_14, insn,
> +		return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_14, insn,
>  						     offset >> 2);
> =20
>  	/* Unhandled instruction */
>  	BUG();
>  }
> =20
> -s32 aarch64_insn_adrp_get_offset(u32 insn)
> +s32 noinstr aarch64_insn_adrp_get_offset(u32 insn)
>  {
>  	BUG_ON(!aarch64_insn_is_adrp(insn));
> -	return aarch64_insn_decode_immediate(AARCH64_INSN_IMM_ADR, insn) << 12;
> +	return __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_ADR, insn) << 1=
2;
>  }
> =20
> -u32 aarch64_insn_adrp_set_offset(u32 insn, s32 offset)
> +u32 noinstr aarch64_insn_adrp_set_offset(u32 insn, s32 offset)
>  {
>  	BUG_ON(!aarch64_insn_is_adrp(insn));
> -	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_ADR, insn,
> +	return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_ADR, insn,
>  						offset >> 12);
>  }

[Severity: Medium]
Can these four noinstr helpers still call into ftrace_likely_update() when
CONFIG_TRACE_BRANCH_PROFILING is enabled?

Although f22c81bebf8b ("arm64: Disable branch profiling for all arm64 code")
added -DDISABLE_BRANCH_PROFILING to arch/arm64/Kbuild, arch/arm64/lib/ is
built via libs-y in arch/arm64/Makefile rather than arch/arm64/Kbuild, so
arch/arm64/lib/insn.o is compiled without DISABLE_BRANCH_PROFILING.

As a result, the generic BUG_ON() in aarch64_insn_adrp_get_offset() and
aarch64_insn_adrp_set_offset() expands to unlikely(), and the if statements
in aarch64_get_branch_offset() and aarch64_set_branch_offset() are
instrumented under CONFIG_PROFILE_ALL_BRANCHES.  When patch_alternative()
calls these helpers while patching live instructions before cache
maintenance completes, they call the instrumentable ftrace_likely_update().

Passing -DDISABLE_BRANCH_PROFILING in arch/arm64/lib/Makefile (or defining
DISABLE_BRANCH_PROFILING in arch/arm64/lib/insn.c) would prevent branch
profiling instrumentation here.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107071339.1746=
7-1-jszhang@kernel.org?part=3D4

