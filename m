Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C747D715DE
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 10:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53CD16B05A3; Sat, 24 Jan 2026 05:16:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEBD6B05A4; Sat, 24 Jan 2026 05:16:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A1B6B05A5; Sat, 24 Jan 2026 05:16:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FD146B05A3
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:16:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73D16B75F7
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:16:05 +0000 (UTC)
X-FDA: 84366451890.24.5180BE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9F79C160004
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:16:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BG+9wd2o;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769249763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/5NPMb0LZF5TbTdERpsT57n+ZMmWhyHLzllN9jVgX4=;
	b=zn/4QFUWI5uXJ0ptVfifGhOZ9TLXYEIJRACStDBwK4IT2KSDO3B2vAJlvcqH5k1+pq/XQv
	ccZiXKSUx2bRAmgX0exdzTNUggJo3vtjWiZnm9JV9wyvPBSQQg2DuouINq2qrDT0k9zm1i
	id8vy15/RBzs8+0i+igR2eKNSc/Kis8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BG+9wd2o;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769249763; a=rsa-sha256;
	cv=none;
	b=jlcK46JeTQoOM2lOMvCxfofUYnpL4Qm6td5U5MSIW73HhYqh0NO67WALt7MSrGQm/wQ0ss
	OBWGvQwHARjRLzvYIvbMo6/3l84zVYY0uL3Uqq1nO4eBZN14oFYAI9XNpNBYXpW5li8XGB
	v+/m0fXewyN7ZPkvw+PDnHkGhDFgthc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7ED6843C9A;
	Sat, 24 Jan 2026 10:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D83BC116D0;
	Sat, 24 Jan 2026 10:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769249762;
	bh=UPTxfV10NFGsFNMLbllwwGihhByrD9Chz5Ya/aU4aSQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BG+9wd2ovrMG5pu7KsxBmuHPlYw48y+qEQuXSOmuaQ786O9ubyptVjzd3TPikqKEV
	 MtPvuwrKZtwGgD5G4X1PGRfnjjFohKmYb3O3Y4u5BFFb01X2hKPytrs6tuQ52Dm9nS
	 fmDIq7vs8J8McangAIFv826LCzRZLNgtf/9d3q8GVASVYzXNiEOedwA61U/TSPBRLw
	 B/uNVy9iMafbxhVtHeEUGbMQNxTqlAJ8n51n6Tyk+R2myqLHAu834xSBnmo1UVELl7
	 eeika37+zLOWSlLAtg5QwuglP1fRf1menyZ0BPn8+f6CDzm2bJ29YHmoNsPqWpbZ5/
	 er2PErNhz4kjQ==
Message-ID: <02784e9a-d934-44c3-ae24-a83a1bcf678d@kernel.org>
Date: Sat, 24 Jan 2026 11:15:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable] arch, mm: consolidate empty_zero_page
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260124095628.668870-1-rppt@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260124095628.668870-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9F79C160004
X-Stat-Signature: 4xqicendicxndu59g6u1jq5p9pjpmcz4
X-Rspam-User: 
X-HE-Tag: 1769249763-806213
X-HE-Meta: U2FsdGVkX1/OOcKm+ff72rc4V+OYRQxL0vtRMo4xinuNaKHTgT5+s4MxJA+rr54uIzJ3FGnJBhRj4piUnye/9ofiLTg1bVvT9fiqVRi5SCTm4wJjRlsCs5Q7WU3yobzGPl1ZhxidSCxmmOxdUUAB+4zFDJqY5odp50g3xP+8Gp1d6x4Hj64daSu8bab7vQsXA0Y1REpA1fQurDk9SupqDo1BqEK6gT3R7+SwlKinlx1y8fV3bAtGNXV8BlfDioWAbzXIYCyCmxf5/IMzNUzSsf0vgX78E0j7s/VNENQWlKb/Om1/XqzIdARVxSWwXL7EP19gbpvG4drnO7MD+CvDgMmSVWHr71ZedNLD7pMUeiAvlT+tCWrM4c1dS6lm7w/cGkMt2ztXj6YiU8JtexAxcZBVaJcwV5PcYQ2fvsMas1kAzG8dNJ6fMJhFnTSoHIlWigKPq/f7cLBv4njpiUzTisxFWbZv7rASS1BWHXx40f2c6Kwp04PzW85JJvcEPpTXGMmJb8Y5VokmO1PXl7Sc06W+k/cgLz5+OusqXeg7lZYjYHrJRDfCnVBA2D0mrfKhO8zZ2snru2PEif+LR/4Pjc/o6WKJzOASGrrUkQLiMJpAqMiaM/2waCUsTbZZ+Di60Flo2gYvcHl1k3Nbp3z8bs36jWoo5h2Ew1a49bVmNfz2Gxnds1j8y8qa6it2KSRkIe5qT+yUgMZfZsiRCLgUzjDcPBlELmdDeKwTUN722UlOtqj+AoPr+462+rQLZn8qnaIZYkMNvHOESavaOdU1+SSBVC9guScUBtsWPxRqdhB6xJqqajE//nE7x0Cu9+wthgSVwhZUdz1tOAH9ajSnTWdWxN7pxo8luGsigBvueDQexfBfQHX/3/YMihNxdgpXzBt0cHMYnlv33WbXiuU4WjNpWMJtwa6z/n5Gfi2A5Za/NCTaTePBRGRvPTkkhb35el6DadPrPF9fgHQ2rUP
 fKLtBSxK
 HedxP6RnuiI7+38M2UhHD/x5AyuUBOvpfHbLYENiH9l/2sstL4P8bHbchbtJTKKhRScOH0QP+7rDT2RO0NxeWaHSMIglmUXFiyGkgdhTyN0CvNj30zR4qEExdDrHtAAg3LigQkx6v0vhu7ppErvxvMJ2pM9KJk5QAbsTs9cxTa+Bd8qmnzeLyKt15h2jeM1AK5JAI4nLaWo5SaKtBCsaNHEx88W0dV1lO5NB2I/tZipU8QlZ4j6hlhstf3HILBymwaRH6SEJJ92m4JbDqLP+7dfqqs+CRkpoJn6tTg6wTIvCdDr1fHu+z7FNwVpGrhx+eFGR5YGrFF4lS1hIiutu3YbwDCZiuv2eLi7Rj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 24/01/2026 à 10:56, Mike Rapoport a écrit :
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> ZERO_PAGE() to 4.
> 
> Every architecture defines empty_zero_page that way or another, but for the
> most of them it is always a page aligned page in BSS and most definitions
> of ZERO_PAGE do virt_to_page(empty_zero_page).
> 
> Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to the
> core MM and drop these definitions in architectures that do not implement
> colored zero page (MIPS and s390).
> 
> ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> inline causes severe pain in header dependencies.
> 
> For the most part the change is mechanical, with these being noteworthy:
> 
> * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boot
>    parameters. Switching to a generic empty_zero_page removes the aliasing
>    and keeps ZERO_PGE for boot parameters only
> * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
>    ZERO_PAGE() is kept intact.
> * m68k/parisc/sparc64/um: allocated empty_zero_page from memblock,
>    although they do not support zero page coloring and having it in BSS
>    will work fine.
> * sh: used empty_zero_page for boot parameters at the very early boot.
>    Rename the parameters page to boot_params_page and let sh use the generic
>    empty_zero_page.
> * hexagon: had an amusing comment about empty_zero_page
> 
> 	/* A handy thing to have if one has the RAM. Declared in head.S */
> 
>    that unfortunately had to go :)
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   arch/alpha/include/asm/pgtable.h          |  6 ------
>   arch/arc/include/asm/pgtable.h            |  3 ---
>   arch/arc/mm/init.c                        |  2 --
>   arch/arm/include/asm/pgtable.h            |  9 ---------
>   arch/arm/mm/mmu.c                         |  7 -------
>   arch/arm/mm/nommu.c                       |  7 -------
>   arch/arm64/include/asm/pgtable.h          |  1 -
>   arch/arm64/mm/mmu.c                       |  7 -------
>   arch/csky/include/asm/pgtable.h           |  3 ---
>   arch/csky/mm/init.c                       |  3 ---
>   arch/hexagon/include/asm/pgtable.h        |  6 ------
>   arch/hexagon/kernel/head.S                |  5 -----
>   arch/hexagon/kernel/hexagon_ksyms.c       |  1 -
>   arch/loongarch/include/asm/pgtable.h      |  9 ---------
>   arch/loongarch/mm/init.c                  |  3 ---
>   arch/m68k/include/asm/pgtable_mm.h        |  9 ---------
>   arch/m68k/include/asm/pgtable_no.h        |  7 -------
>   arch/m68k/mm/init.c                       |  9 ---------
>   arch/m68k/mm/mcfmmu.c                     |  2 --
>   arch/m68k/mm/motorola.c                   |  6 ------
>   arch/m68k/mm/sun3mmu.c                    |  2 --
>   arch/microblaze/include/asm/pgtable.h     | 10 ----------
>   arch/microblaze/kernel/head.S             |  4 ----
>   arch/microblaze/kernel/microblaze_ksyms.c |  2 --
>   arch/nios2/include/asm/pgtable.h          |  7 -------
>   arch/nios2/kernel/head.S                  | 10 ----------
>   arch/nios2/kernel/nios2_ksyms.c           |  1 -
>   arch/openrisc/include/asm/pgtable.h       |  4 ----
>   arch/openrisc/kernel/head.S               |  3 ---
>   arch/openrisc/kernel/or32_ksyms.c         |  1 -
>   arch/openrisc/mm/init.c                   |  3 ---
>   arch/parisc/include/asm/pgtable.h         | 11 -----------
>   arch/parisc/mm/init.c                     |  6 ------
>   arch/powerpc/include/asm/pgtable.h        |  6 ------
>   arch/powerpc/mm/mem.c                     |  3 ---

For powerpc:

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

>   arch/riscv/include/asm/pgtable.h          |  7 -------
>   arch/riscv/mm/init.c                      |  4 ----
>   arch/sh/include/asm/pgtable.h             |  8 --------
>   arch/sh/include/asm/setup.h               |  3 ++-
>   arch/sh/kernel/head_32.S                  |  4 ++--
>   arch/sh/kernel/sh_ksyms_32.c              |  1 -
>   arch/sh/mm/init.c                         |  1 -
>   arch/sparc/include/asm/pgtable_32.h       |  8 --------
>   arch/sparc/include/asm/pgtable_64.h       |  3 ---
>   arch/sparc/include/asm/setup.h            |  2 --
>   arch/sparc/kernel/head_32.S               |  7 -------
>   arch/sparc/mm/init_32.c                   |  4 ----
>   arch/sparc/mm/init_64.c                   | 15 ---------------
>   arch/um/include/asm/pgtable.h             |  9 ---------
>   arch/um/include/shared/kern_util.h        |  1 -
>   arch/um/kernel/mem.c                      | 16 ----------------
>   arch/um/kernel/um_arch.c                  |  1 -
>   arch/x86/include/asm/pgtable.h            |  8 --------
>   arch/x86/kernel/head_32.S                 |  4 ----
>   arch/x86/kernel/head_64.S                 |  7 -------
>   arch/xtensa/include/asm/pgtable.h         |  4 ----
>   arch/xtensa/kernel/head.S                 |  3 ---
>   arch/xtensa/kernel/xtensa_ksyms.c         |  2 --
>   include/linux/pgtable.h                   |  8 ++++++++
>   mm/mm_init.c                              |  9 +++++++++
>   60 files changed, 21 insertions(+), 296 deletions(-)
> 

