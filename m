Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC6F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bAFr4ZXC
Received: by kanga.kvack.org (Postfix)
	id CB3706B05C2; Tue, 10 Nov 2026 11:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89B46B05C3; Tue, 10 Nov 2026 11:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0966B05C4; Tue, 10 Nov 2026 11:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 922926B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D3FD120951
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:51 +0000 (UTC)
X-FDA: 85419677742.08.5E3FF2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C1EA940015
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAFr4ZXC;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326569;
	b=PnXU8Qor1HSzvBUMuN7AC1IdMOSiOjLU1xDafg5JTcl6bxCMlXlBsA7PS5s8X3DctV/xUQ
	nDaEaPBFC/EL6n13jlKfOe/8NYOXxOPJTKaxlQuZsGTSRLyMsehwhgCgZFqJ+h+cqjmlDc
	FCA9h8enYDGWhq5bjeuaMbeI3A0k4pw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAFr4ZXC;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326569;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRdlngYCbpP7+D/8MWAcEfmgNsifvh1ppWHXoqoj5yc=;
	b=aQDjZ/TU4J093sLlGlyoEtW9KZIEhiAdX5f0UtSQGbr80ZhUaeVMNcCUNY/Ndu8O5JMVUO
	tKIyLCvaDz6BuCwRXgZiVZ9YQSM0cl37vjeGGsEgNYf20al1HXDZK8aQEOPyR62OMHlcDO
	BsAdHdMOYYR2H8HLUR+RbRM+lc6DUjA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CABB63A53;
	Tue, 10 Nov 2026 16:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735C21F0089F;
	Tue, 10 Nov 2026 16:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326569;
	bh=rRdlngYCbpP7+D/8MWAcEfmgNsifvh1ppWHXoqoj5yc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bAFr4ZXCG8GnWFkUHAfQN3J+08BStKdPuw2n2AGhIH+oanzLqgAg/5XII5soTHE0T
	 RzEQzgOg0a4XNG45epLMr8XG4x3TVXXtjJ1cUWQPoJf9cgAnRkbNm9NteS27b0xeFq
	 itVsgY8U8IRwEAFAw+gd+3JC7BrU0ehUXa42WE/vjRsRdNFQ02QJ4jwDUnaKN/7M2M
	 4G+pPgmupWqEN9igTDKu9r+cKhl7CRtiAdArOIMTBFKDydVVXEsYajZFWxDcC0iMc5
	 T/D2GwJmpXkd5fWPEmuZIYFxvXKQx3hHwuU5/ltFCpEk5n6fvIY3YmiVUJDNGwBu1Y
	 6MWW6htDElP+Q==
Message-ID: <sashiko-outbox-207318@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v10 04/22] arm64: Implement asm/kpkeys.h using POE
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
In-Reply-To: <20261109-kpkeys-v10-4-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-4-aa6c4d9603bc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:02:47 +0000
X-Stat-Signature: qyimd3ktxus19hc1ptrjkx4sa1eus8ta
X-Rspamd-Queue-Id: C1EA940015
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794326569-569087
X-HE-Meta: U2FsdGVkX18HOLnOu9dyTA7ciOXLQe1CtE3uyHzNxh34aJ4ZEuNDoP6J+XGps73WJPIrub/3zX/+Md8T3phmkcwePjKBjT63vqPzwteJ/xFJgRLuH//0YOUbxZDpWiA4rU03o9P2E9LWtFrGKdiQZQ+Lgs/ZD58U+ph+ROQfbq0Ow6NEzpS16xUcCJJSD0WiqD6BT1Lyh6z0DCEBSM8HcN4hZs/rROF7ekeAhUUqRzRSz74nD6SmxoHUD/87jnCy6z3HYFCCU+iOPkxb+W8oEDjXbjHUPZ6vQMV2Y6wEwpuSS1Kf3FG3mUcqjL6bVGMqYC/i0bgr+1iY4DFzVNjG78mjdJy3fS5LBYDIW4R5imUCOiiqsExL5KJUic52WlgNzw/OTzN/BBZNW1CShhsQvXBepyT7HnFgNwdlsn2hB/6ofau3u08WIbmVkbniBsEi0PmsYGih1vCqlfNkN9WfegaScxsVGqCmQau9Ml6cnSBFQj9b8zCatR+mJrRL6PCJ1vKND8ynuYgmHuTLaTefCDbJ9iyoa9K6iG92rc0gjmU4tGtrV3ryBGweyAnoCQNXCSAi2/BkcyBMKAPFjArLMijhrrE1pDD8XkM62dy+aajxcP1lz1CspVmfWVnbKHD7cyKq2CaoTafSXZ/4tZH0cLCeOMSo5P0FlI3vKpYiJkc8bXZtMEywBmjOre1MUAnasuQN5TZ9gYVwyMLt+VOKo63K/TgEcXXRK7pOXwdZlt2BknVcv/uHXCJNeN+iCc3tXojJEilvCPcA9QB/sX0ZISMLXuVdacFFgjJPTz89WN6CUjLTya5zgFQBU0BBVnkZmLWgSfHZOGSAwUFx6A4Ba9AvKe9km0pR8c1+VEw44yf4mYwjghLgFG2omqS4W6+7yi3qdcPVgUjGdnKqlLUmf8Tif0rjVJGCEliZb55Euy8k+kY4Nr4UUMUJKDxjBuZgAw1I4ct/9JjAuMfEMqP
 phvsQFEe
 Dcx3JPXuCxTgd3e7k1OP0gcMa50HdMMDnleNiS+9JqsqfgDBTgyjV65+NHlrByUBsQtGyHupMwvPEY380/E0pLkxkellWVsCrbqEQi7OWA+Ot0MzeBGcCfkVCB4WgFBcWYQiAhoPeTnbdO7rkjb1o3UQfFKriYs6d0aYwD2SEbF3m1FjMJEfK1lJshN8UQuF3Otz6IEdnHiFnlzHKlmzkg2Ci7JiLyHcTNpRAr41sMtd0Jl1iVLO3r3yf4YGSvNzIezcQI41lFThz/0dJ+a2hT53rJTcpaJ0wz1meFrUHXtrcZf//3FvpGkGbfX9ugvImvW89vIwsnvee66Emmq5hgSoBGMG57aHssmupApJ/AHE2N1CPTL3WUeOFNn/FxTcpqVAhEm/xw9QFTJkqEg3LyfzXLYgmUVkGPBLjwpy4x0SItZ75Yeas2BiZn6p3ibSUmJQgspallijiKYVhlRUwIIpHRuBIU4YS9qzP+zmtkOTB8nESPjmOCfMttx2tvYu3n3fWbrt76+E5Rqb5lhf2yORzURA0439nKNEGLwcQMrNOo56QXmZDHc7PHz5cZmebu8akOQkJ+9CBW6dg60jb6o6M1DdmJ8RYKtyQlmFtIQK8WB4PH4i9cWeZg6dsxqlKDpreORIOBnVJBjQQoeycu9RtWt5aeYS9b/nesrA2mVZNuv0vAZY/tnncmxpWjjoZ8riUCvzjPAzfSauR/nTJeT2oXKKd6nEpP+rt7uE/2lUGLhc=
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
- [Medium] arm64: kpkeys: mismatched CONFIG_ARM64_POE guard in
  asm/kpkeys.h
--

commit 6f45a834f4b090307d508db166b798a5f825afea
Author: Kevin Brodsky <kevin.brodsky@arm.com>

arm64: Implement asm/kpkeys.h using POE

This commit implements the arm64 kpkeys headers and context-switching
helpers using the Permission Overlay Extension (POE) and POR_EL1.

> diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpk=
eys.h
> new file mode 100644
> index 0000000000000..4f9bdb369b47e
> --- /dev/null
> +++ b/arch/arm64/include/asm/kpkeys.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __ASM_KPKEYS_H
> +#define __ASM_KPKEYS_H
> +
> +#include <linux/kpkeys_types.h>
> +
> +#include <asm/barrier.h>
> +#include <asm/cpufeature.h>
> +#include <asm/por.h>
> +
> +/*
> + * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can =
also be
> + * used in assembly.
> + */
> +#define POR_EL1_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
> +
> +#ifndef __ASSEMBLY__
> +
> +static inline bool arch_supports_kpkeys(void)
> +{
> +	return system_supports_poe();
> +}
> +
> +#ifdef CONFIG_ARM64_POE
> +
> +static inline u64 por_set_kpkeys_context(u64 por, enum kpkeys_ctx ctx)
> +{
> +	por =3D por_elx_set_pkey_perms(por, 0, POE_RWX);
> +
> +	return por;
> +}
> +
> +static __always_inline void __kpkeys_set_pkey_reg_nosync(u64 pkey_reg)
> +{
> +	/*
> +	 * Writing to POR_EL1 potentially affects all memory accesses, so
> +	 * use barrier() to ensure load/store instructions cannot be reordered
> +	 * past the write.
> +	 */
> +	barrier();
> +	write_sysreg_s(pkey_reg, SYS_POR_EL1);
> +	barrier();
> +}
> +
> +static __always_inline
> +bool arch_kpkeys_enter_context(enum kpkeys_ctx ctx,
> +			       struct arch_kpkeys_state *state)
> +{
> +	const u64 prev_por =3D read_sysreg_s(SYS_POR_EL1);
> +	const u64 new_por =3D por_set_kpkeys_context(prev_por, ctx);
> +
> +	if (prev_por =3D=3D new_por)
> +		return false;
> +
> +	state->por =3D prev_por;

[Severity: Medium]
Should this block be guarded by CONFIG_ARCH_HAS_KPKEYS instead of
CONFIG_ARM64_POE?

include/linux/kpkeys_types.h only includes <asm/kpkeys_types.h> (for
struct arch_kpkeys_state) and defines enum kpkeys_ctx when
CONFIG_ARCH_HAS_KPKEYS is enabled:

include/linux/kpkeys_types.h:
    #ifdef CONFIG_ARCH_HAS_KPKEYS
    #include <asm/kpkeys_types.h>
    #endif

    #if defined(CONFIG_ARCH_HAS_KPKEYS) && !defined(__ASSEMBLY__)

    enum kpkeys_ctx {
    	KPKEYS_CTX_DEFAULT =3D 0,
    	KPKEYS_CTX_COUNT,
    };

Because CONFIG_ARM64_POE is enabled by default on arm64 and does not
select ARCH_HAS_KPKEYS until the later commit "arm64: Enable kpkeys",
when commit "arm64: Context-switch POR_EL1" includes <asm/kpkeys.h> in
arch/arm64/kernel/process.c, the build fails with incomplete type errors
for enum kpkeys_ctx and struct arch_kpkeys_state, breaking bisection.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-kpkeys-v10=
-0-aa6c4d9603bc@arm.com?part=3D4

