Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA59DFA0C39
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AEBA6B0092; Wed, 15 Apr 2026 02:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186306B0093; Wed, 15 Apr 2026 02:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C9A6B0098; Wed, 15 Apr 2026 02:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA31D6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:43:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74B148B585
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:43:34 +0000 (UTC)
X-FDA: 84659849148.17.9EE81EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8CAB520008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:43:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NmG1V1Qh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776235412; a=rsa-sha256;
	cv=none;
	b=yipKeyrwmbf4Qo0eiEbWjzCuHMYnsl505r1f2xJktQdTL2+2SBXhfpHn0T69IMrJIru4G8
	GWwUmvaDaxPLGHo+dOQnQ865P4zhAYI+mEApysYSui6umirc9gNMxw3B13eJJDsefsxS+C
	+i7qvmcYiMxhJeyN1e/uLCIMegn9Jxk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NmG1V1Qh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776235412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6HjAjcgcE6PNwReVnTSdYqGCc9ebXbnfh6z+tasmI8=;
	b=RKZ37docaSAin6/gisIoC1PM0pxb7AFUhrYmd/Ai9YeLooy3FUcMsMfr4+hrSxEc2mLDCI
	yKTVBSXb0p4y8kUiEx1U5i6aFO4MtWe3K0Kzh5IkYC6i9KcezrWJtfILXMwEFeCwirNBPV
	NMZ6rYvr2/CHDNA37HGVnG0A49BaRME=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7742F403A8;
	Wed, 15 Apr 2026 06:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC3EC19424;
	Wed, 15 Apr 2026 06:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776235411;
	bh=3l4dmsvsnQyxf5GbIefFkBoRTtzYmP3a/BJez1WWJU0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NmG1V1Qh8X51h9yFFz/RGI1o84gKp7RHsiOopESELjzBD3f9G2epzFGKqLdlrBBvM
	 85BRNDv9YgePWTAd/mWHoOfcVqkZ9t54hSGyPy5okYzBxuCsVMlJue+y2wSJhbVhIb
	 lb1DnIaWF178QVSBg4jx+V4/OFjaBNwtpoh3Tr4lJfjGJizmbNJlvTEiLyH2ILDjm+
	 9pOpGMDHM1wUUHlqTgOAicNu6S/pI86hh/KXo0HpBVSU8mvpdrsn1yE6nfT23v28aD
	 LJpZNPtQ4Ce9RQkXbclJOLPdj0XzY6SczhKB/CIS9XrbEQGTKPU35O7cIRgQtYcfwt
	 Wv24vurrRB4xg==
Message-ID: <0758843e-8f75-4c82-b9c0-25fab502e62f@kernel.org>
Date: Wed, 15 Apr 2026 08:43:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 07/38] treewide: Consolidate cycles_t
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
References: <20260410120044.031381086@kernel.org>
 <20260410120318.045532623@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260410120318.045532623@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8CAB520008
X-Stat-Signature: n4ensjpk6uzrojtgoi7ee9361uida9fq
X-Rspam-User: 
X-HE-Tag: 1776235412-292131
X-HE-Meta: U2FsdGVkX1/t4HWph7gJYZhN4G2DSZiujvrmCzaa9LHw0GeGTj2FRdSJSToFjLxegYirpED7TKZi+ELQa4EPltURn2F4TpIcFEzPvUbwFoaVPE7mdKnZcjbWMwOBiQaUnuZ1X5lMktD3nWneyCXRLuFXtMLPyUaGcuRzUA7uNMR7x9I22Im2cSmY5JgK75VGPC/gdpAHTN+kBe6DO6eTpa/2GXZTgWmIZhSp/YZN4KUK79YQ6Tp7Ah/96ikz83QiIW8/VIlFSJC03Jyv1fSrz7Ywzbc7PFynritMEeUSeIPGMlroAqOOo8qjv7eh+h/RFvdngviAKpHweXV9RW1DjgqVziuXWV4N53OBs+9gDi7gbr5jHGpaK2QKd32bK54Tr+9TD4XtB1Z3IofSiqdXmkNCGNbzqLtJ5pUW/UTn2TkXeEjwd0ioyC2ytbiwiYfDaYGW4t8bUBchSUqnJ2Ll05GACegar2WKbOkEHqsun6gbCf18IFXkjS1K5oeFZ6ExuFkTKydeXYdwGs6Rbiubf2+o1lSObnkUvT+j8vUd2veKcAK07iRLjA33EdX3aUZ01E7HMKgpYFg1jHCjx4r5fg91CKKgHMLUB19uo/lPdJa9I/GtS3OurA/EEDtcIcTunkvJr68OjpusH0Eh9x75dVxVYW5O3e9gxm2a6xJ2bzTUtUGxsuMvPQ9RhEyBIFW1JsB8uGDJTDheRliEF9RC/Lj2Z6ltDVeOpnA4dq92N1XR8W1CokIpDN2d54g54eXRapzyuN5R+oO2ZcIc1I0rjiMjS/kkRWc51jnh1noENYTO9i1VxrRuVRpjxRzELEgQX288GqTjN4iwBd365ERODCNHPnFTgv6FkTI2OY9y1a6CykBXdZOIlCsDNZ1ZVFu80/2hsa59B9W0GKJJ+gFnxUJzPCA1sByQ+kGUb/ArImrTQflNnGCyMi3QV3zsjJnNwQeKmHFvlsCuLePg7bn
 V5uBP7OO
 17IMIhFu6piqTEJnNKk1kxhAnvzIzgWEssuxskjzK1wE78QDGG086VBvG6melI+eFJmFeJFCBuEbqOipCMcdk1QzaJ79JomDjhzxXjgaGjixLsrKG8mCA1KR5fo40ruBonksl0DUr7o5kCeqdG5ptl0fKF4aP/cHaU1v1d+bvPusuWX533wae9XKUrOrL4zvNBGd41AGCe3rwL2ho5E7Wpwei6ddwuREaA4bVTYCluD3IMHqbKEoGEOkCM+pySfK3Yf7etzUuyo5jesC5jQu1bDGcOCIRGrUDKIju7o9HP81POJNXbChwmR31KXfzbu6B3lf/owyxY5AGz7jByn41v7HGdUvTheKj3rTBqr+SuUE8PW400wlPOKFd3QRCP/OnBLjeN0GT+e4lsL54jUxrsv0OVx+3dyypCpbSbBp5JOn43BY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 10/04/2026 à 14:19, Thomas Gleixner a écrit :
> Most architectures define cycles_t as unsigned long execpt:
> 
>   - x86 requires it to be 64-bit independent of the 32-bit/64-bit build.
> 
>   - parisc and mips define it as unsigned int
> 
>     parisc has no real reason to do so as there are only a few usage sites
>     which either expand it to a 64-bit value or utilize only the lower
>     32bits.
> 
>     mips has no real requirement either.
> 
> Move the typedef to types.h and provide a config switch to enforce the
> 64-bit type for x86.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> ---
>   arch/Kconfig                       |    4 ++++
>   arch/alpha/include/asm/timex.h     |    3 ---
>   arch/arm/include/asm/timex.h       |    1 -
>   arch/loongarch/include/asm/timex.h |    2 --
>   arch/m68k/include/asm/timex.h      |    2 --
>   arch/mips/include/asm/timex.h      |    2 --
>   arch/nios2/include/asm/timex.h     |    2 --
>   arch/parisc/include/asm/timex.h    |    2 --
>   arch/powerpc/include/asm/timex.h   |    4 +---
>   arch/riscv/include/asm/timex.h     |    2 --
>   arch/s390/include/asm/timex.h      |    2 --
>   arch/sparc/include/asm/timex_64.h  |    1 -
>   arch/x86/Kconfig                   |    1 +
>   arch/x86/include/asm/tsc.h         |    2 --
>   include/asm-generic/timex.h        |    1 -
>   include/linux/types.h              |    6 ++++++
>   16 files changed, 12 insertions(+), 25 deletions(-)
> 
> --- a/arch/powerpc/include/asm/timex.h
> +++ b/arch/powerpc/include/asm/timex.h
> @@ -11,9 +11,7 @@
>   #include <asm/cputable.h>
>   #include <asm/vdso/timebase.h>
>   
> -typedef unsigned long cycles_t;
> -
> -static inline cycles_t get_cycles(void)
> +ostatic inline cycles_t get_cycles(void)

What is 'ostatic' ?

>   {
>   	return mftb();
>   }

