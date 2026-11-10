Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7ABF606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Agik7w5d
Received: by kanga.kvack.org (Postfix)
	id 6490A6B05C3; Tue, 10 Nov 2026 11:02:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620D06B05C4; Tue, 10 Nov 2026 11:02:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F2C6B05C5; Tue, 10 Nov 2026 11:02:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5316B05C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC07080970
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:53 +0000 (UTC)
X-FDA: 85419677826.08.53DB17F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id EAC10C000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Agik7w5d;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326572;
	b=DXzMB1pck7dhKTmy5d88dRVVUvCOZKfITaa1hRYYC8UOIg0PpqC8aSyFuUEw1+wtLnuaca
	lkb0G/U7VR33ajw6BYAmg8M3CC8+/pSiKjMMvKiaYfribG4KOSlRl3CMZwoU2ulL6tjaMl
	uIyE3cG0GK98KBUPotl/NZH/4nqYpak=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Agik7w5d;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326572;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnOoIVuK0MLvJp2d3uWvodbAGJh/L8/H8DuO7SZ2I4c=;
	b=U+EkuKcqCvQrH5YmoVy5899p3jqddnm81Q19QtwdOM6dzHMnnjHxFF+xMdq3KEdUEADLLy
	jGkiDNBW5s+ePofEdwnGSdEyiIooB9w8HQC6CBil9cdwySMfvYKfVVwxwqGlOgN4b2K5Kt
	AZHqsivNsQSAfzAT+EcnVJhaHoNJ0j4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29405411DF;
	Tue, 10 Nov 2026 16:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB1F1F0089F;
	Tue, 10 Nov 2026 16:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326571;
	bh=jnOoIVuK0MLvJp2d3uWvodbAGJh/L8/H8DuO7SZ2I4c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Agik7w5dmbIJj8OG8/g5Xw1ajZeP3mTx6BfgArcOmvZ+28fVda2ZtLwKf1Zgp50Dl
	 gCtgUeFpUeI9sOGq2/uaod2T+tAp4mdgxta1Tg9I1UdnAWkeVzlJjlyIwGrUMjnuER
	 LHyqwMvSkrNEDOOE+Qsavl0iA9OQjbA/CPUEDS6JBZ+n5GWNi2wxmrGCTonLzNImHO
	 kC46n4IPgHlGiZLVhyYiom/pzQRzwScMj0Ou6vrj/tXcPdCsX/fp0MNBovVvcWsMv4
	 HT6zLOlPBzeq2XGUenigemGq79Zam7gNJXn169z9EhBcGVuw8Vs/ZEjrtRXyEqdX5r
	 fQeiCK5vLzJUw==
Message-ID: <sashiko-outbox-207321@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v10 07/22] arm64: Initialize POR_EL1 register on
 cpu_resume()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kevin Brodsky" <kevin.brodsky@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ard Biesheuvel" <ardb+git@google.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJh?=
 =?utf-8?b?bmQgKEFybSk=?= <david@kernel.org>, "Jann Horn" <jannh@google.com>, "Jeff
 Xu" <jeffxu@chromium.org>, "Joey Gouly" <joey.gouly@arm.com>, "Kees Cook" <kees@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, "Linus Walleij" <linusw@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Mark Brown" <broonie@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Maxwell Bland" <mbland@motorola.com>,
 =?utf-8?b?TWlrZSBSYXBvcG9ydCAoSUJNKQ==?= <rppt@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Pierre
 Langlois" <pierre.langlois@arm.com>, =?utf-8?b?UGllcnJlLUNsw6ltZW50IFRv?=
 =?utf-8?b?c2k=?= <ptosi@google.com>, "Quentin Perret" <qperret@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Yang Shi" <yang@os.amperecomputing.com>, "Yeoreum
 Yun" <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org, "Ira Weiny" <iweiny@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>
In-Reply-To: <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:02:49 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EAC10C000A
X-Stat-Signature: 1cxtuhyqwnwnpfi8y6x5zkwywn6jd8is
X-Rspam-User: 
X-HE-Tag: 1794326571-878162
X-HE-Meta: U2FsdGVkX19e1Jd3knFrowd8QCrBm1Snk8vxY556lZxa4J4Rfu/qbcNf2C7XcR5oGd6mMDtt0C9yFm/E/1z9La1Oel2FKcVvIk6FN1HLd6e/0iv5xlI6v/NtPzSDxLlqHvHoZerJJiiF2BciTFbNEkBsC89KqDbrhGKJgPiJuMEfsCaK/F6FXt+OTH/FLNbakJnlVbbYpEVZgNRyVgrNPn1//2fSYzMOmi3oCCg/5AkZ1EZAJy64GNacyUqTQLFMzxhsDnYN9Lvlvde9SMb/RwdqBYnEC0RZtQLniYRXZ3eISSBygPyZ4a2KdcS30OyW0P9x/vQ2un7+2YX6DmrTwsRMIYm/ZrpJIs/FHQJN0Bxla3V19hFMevFS6CASiJ/3fGaDOUoSB1MhzyOxAbH+tXnqH+bpe5AoEAGoblqcfTg3lNDa1m0ADHR+Eh4BUOEdI7fIoFsZgcBuo7Lg9vJKZLfGbqZ4rYV118XnllFO9pDPV+1X3su/WSX1v9ghC2yp2YJkBfIHW6kg4GbQy7Dk1ZAsc2G9SyAx8/HhR0kVbNXcCvVI5RRH8lO/7+7GWGoenEykSDBXxHIu2WlFY6PACIDUgTPwKFprnARATPQ01uDFPZGKPsp0LLRIrbdXm/6RTYCz3uSYJeFOMDa4+ZSwQcb80YZZ9GLehEMyrdJ4l5rrqBzthb/73ahean7/wKRX1P7fRYZhW5yH5cwGebkCHvpkHNskJaHX/mim0/t9dGWJuUOX1ty6zsf3aH+SYZtV/YroeYMLElEevEGVL3j0yNOi9EKRTzk/NRu2tecfKnkjqqhTN4L3FtcxoucqCSi6peEyPyWkq3zwZegp9JZ7xlrLByLhNFktmU5qBh8mtwwIbrQsfZ8m8ExJUEcEhAdubUIUE72Lt9xFEuxmzhY2BzahdJcSWVziAP63CC3/L+981GwqbSFPobUYWf/K9I/m6LvlVG9zCNBOdEDZEdG
 LsVcMkGK
 TJDiBCc0EUM1xLf+v+rSm6pPk3ptBRWhuwFpN5XX7QjZeyIWQRmOKttXRZaZfdZMKaXGsBjGWkubcWZm9AqCLDGuGAMUNmMblfLJ3ByyL1TE21UluTl+0+02aImagsXHGT1AqBO/judi7+npsiFwDMJeyTz8HjLDR1RqnNGTCoQl2vVpgaLVXBl4L6UDPEf5GOg+ggaefGQbUkcETvZKWBzxH2RgLh/GQLedax9NjxaQp7AGY6jM/jHGJ8jeSrGHC9tdi/jSNZzfQvEuE0U7ex+uoOck59lFiVl6onUR7nzHzy/9CoqDG+Pckod8ByOydI2mBtZrWZJhYHt2I//xsu/d0aewtFsQ7GkPyd9AmapeoqBRoxpWCqcme5wFlwvCpAqDQBD3Fp224JdOKC3Ime7NlQ/1BOomgNlslrW6RFwSb9k6RgyFIWai8d1KkmihKTgHQss5NGRzMXFylYm1qrrO0URjooC4XlnpH1FbjDVJZaBnfqijGJQmuHLrYkTYpldDx0+5FwMUHFQcLwnRkv2Rpzw6nOiYkRfeIJ6ZAmCTgwNR2icnNDF/1NdWKbXL9QdUn0Ea/2OlAlvP1oakGsuvxMnybEg/TVKDvbFxk9RY1QMAkBrNn/d7XqIFMmJxJBliA93VkE4KLAo30X5GCC45irEG9qN9Rkiox6OTw0U/+sAH05enW/twzL3wvIzQRbyQAhKPQWZ0ANrfAPfsIKEgCocGb7wHbNdwfYDm5DvLOMmudFhGjelI7CFIksilOTO/eK3SYsDDMa8LsbjCLDeupWQ==
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
- [Low] arm64: unconfirmed ordering of SYS_POR_EL1 and REG_TCR2_EL1 in
  _cpu_resume()
--

commit 5fdafa429ecfc231981525c4af268a477f615016
Author: Yeoreum Yun <yeoreum.yun@arm.com>

arm64: Initialize POR_EL1 register on cpu_resume()

This commit initializes POR_EL1 to POR_EL1_INIT in _cpu_resume() before
calling cpu_do_resume() since POR_EL1 resets to an unknown value across
cpu_suspend().

> diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
> index f093cdf71be11..e0a6ad85cd242 100644
> --- a/arch/arm64/kernel/sleep.S
> +++ b/arch/arm64/kernel/sleep.S
[ ... ]
> @@ -134,6 +135,17 @@ SYM_FUNC_START(_cpu_resume)
>  	/* load sp from context */
>  	ldr	x2, [x0, #CPU_CTX_SP]
>  	mov	sp, x2
> +
> +#ifdef CONFIG_ARM64_POE
> +alternative_if_not ARM64_HAS_S1POE
> +	b	.Lskip_por_set
> +alternative_else_nop_endif
> +	mov_q	x2, POR_EL1_INIT
> +	msr_s	SYS_POR_EL1, x2
> +	/* isb can be skipped since cpu_do_resume() will do it. */

[Severity: Low]
Can the indirect effect of writing REG_TCR2_EL1 in cpu_do_resume() take
effect before this unsynchronized write to SYS_POR_EL1 when no isb
separates the two system register writes?

This rests on an ARM architecture detail that the review could not confirm
from the kernel source.  The MMU is already enabled when _cpu_resume()
runs, and cpu_do_resume() restores REG_TCR2_EL1 (with TCR2_EL1_POE set
once commit "arm64: Enable kpkeys" enables stage-1 POE at EL1) and
performs further instruction fetches and memory loads before the final
isb:

arch/arm64/mm/proc.S:cpu_do_resume() {
    ...
alternative_if ARM64_HAS_TCR2
	ldr	x2, [x0, #104]
	msr	REG_TCR2_EL1, x2
alternative_else_nop_endif
alternative_if ARM64_SME
	ldr	x2, [x0, #112]
	msr_s	SYS_TPIDR2_EL0, x2
alternative_else_nop_endif
    ...
	ptrauth_keys_install_kernel_nosync x14, x1, x2, x3
	isb
	ret
}

If the architecture permits enabling stage-1 permission overlay in
REG_TCR2_EL1 to take effect on those intervening fetches or loads before
the write to SYS_POR_EL1 takes effect, the CPU could evaluate kernel
permission overlays against the unknown reset value of POR_EL1 and trigger
a fatal EL1 permission fault during resume.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-kpkeys-v10=
-0-aa6c4d9603bc@arm.com?part=3D7

