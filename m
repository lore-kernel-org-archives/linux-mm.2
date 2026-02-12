Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBBD7EDF038
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 05:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3676B0005; Thu, 12 Feb 2026 00:33:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250C96B0089; Thu, 12 Feb 2026 00:33:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126316B008A; Thu, 12 Feb 2026 00:33:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 007646B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:33:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A189B140583
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:33:17 +0000 (UTC)
X-FDA: 84434686434.03.33D4237
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CCC9940004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:33:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnRt4bNT;
	spf=pass (imf11.hostedemail.com: domain of dinguyen@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dinguyen@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770874396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRzyQacyUh/08e1S92m/JTc0FNNqNKr3dxJ1j03blI8=;
	b=AgSmuMINUD2r2IfZdIbK6DzrL8XNcQuOKewQK6Q0IFT1faGOgL1uF2yvx0fg5Tb/ixhx8Y
	02HroEV1eAUG041WdsKiSD8thC8KxEAZYwNfuwUAB5IcgKX8IHj+BKEKFVY2lp9ROXGbtR
	LAWs2upOhTYk0u2WkXxXhFgZzz0Eywc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnRt4bNT;
	spf=pass (imf11.hostedemail.com: domain of dinguyen@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dinguyen@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770874396; a=rsa-sha256;
	cv=none;
	b=PbDfWeWK/m94pQKLtV+H0pj6z81yEoJI8dXJH5OSGQkOZEGXQsjpxhfggGUk7ltN/7UIZs
	27/PRvHp8/ea2n5JD9QmoO5fRuZDDaXidrdHbR7FNufsvIuFF0zzBpU4v1d2JBx0N1iH8D
	qzsS3UEDQIq6+dOlzYY2LoMQ5iFVNEQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 97C9B4151B;
	Thu, 12 Feb 2026 05:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D227FC4CEF7;
	Thu, 12 Feb 2026 05:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770874394;
	bh=xWdXZIArybbo9Rgxccq3nL2HLMDxrTRxGRMmTyJ92Ek=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fnRt4bNTruqGWDCex4UgCYs5xfFXruN8Lon65hP9g22+WBdZKtSwF7Vlpe0Cerco4
	 bvwxt2r8yj+pM8xOwU8CRkM4OmUaUA/+Tzc72yQC0G+UVZeUmzyMyMPGyxL/xNIa4X
	 +/VC+HyZKbjW0nnljKGakLZZFB897pqnLw9d71EIpoTCJ5wnD5VHVMEklBRL/Jcabq
	 Mwmjfv/JZu6GfI7SyoqZ+mxEsaOK/PQXeGkhDnmh+ztI8JZFzkYG9tnpHFUHqIR6N4
	 w+N5IHX73Du91X+qNAEJ7TQrDCCl9z1LnQGwJBdYZfNUoF2uBKOsddFYGgsxivKLws
	 KFvp/8rynpEOQ==
Message-ID: <0b420450-a85f-4f7c-93c2-4d2de37d257b@kernel.org>
Date: Wed, 11 Feb 2026 23:33:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] arch, mm: consolidate empty_zero_page
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
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
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-4-rppt@kernel.org>
From: Dinh Nguyen <dinguyen@kernel.org>
In-Reply-To: <20260211103141.3215197-4-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CCC9940004
X-Rspamd-Server: rspam07
X-Stat-Signature: 4f4zw7irgx1tu9s7c9gpchsyi4rbug7q
X-HE-Tag: 1770874395-467685
X-HE-Meta: U2FsdGVkX19c3oU2X0g0Ly8wZewax15F5noJEIxkmh83n5wyDul1VXsj/LI41apS0RKQWd+TULDFUXN5rBPFfP3rGMR0Efep4o0aaNweoMZWbHcLEVTGhqyZrLfztR2o9TlqIMu/xyJd3wVSPMqJWL8FcA+WJGmfAp5FnMdMCALYZ24OdAkmwDxu6gq6yX3USgUuR01k1+Tfcwt3o3qfdR17ryb5tBx/E1a4YcuITufTUW6XdMhGaRpXNQSmCBk4oz2pCs0FxcHPR28z0sQ6+PlmMGYwykgts2vejg9fYomz0hIXiJ0DimVoWGbBGBXQzsycpsF1AUSBj+A9vQe4wwuAahrWkB8PPg19+6JcHwKk1bssWVIzsjnZ+VLzXIAOtM9YIMZu20y3njGmvTh0xbYRlRB10nha4nRPiayZ5omzmNjfTfRCGT9Mv+j63ghOHbxpi/DwIZy8Ln9OyrKDJtheFj18bb4Bvxu6aFH22mpi3d/O2dXsm1q5S4v7wZG8XfFF8o5FugKTU45sXuJFnOMHaa4Mldx/bUT5wYr8NXeGxUG5G/2gVqfih7aNwDR5omT3WS0wa8A0ndX4NH8MstMC/ny4VF9DE43Hoa8oYXm76j2DuAZta5AQJycStj52T9VMLIjw1Eo0JIP8CnQaLWJeniSlD0wCvP9MWG9kwwCzvfOPLtpKqJ4Rf/jaP3ZHuKYpCCCRy0/5pdbSsK0X/h33vfYPNMG/dnSMHM7TkyraOTeIIIbOrxON6bwMA1rrHWTcpkPn5BL+QcCqesbna8BBB+ol98mciYdOd+/CKSQ0uadey8d+ThHFfqdcZZNWTaHWHwWp0UaWGJ+JygSBXIqh+TlN/yAJQOr5GgtezetyQx4zHsxMgKHBxx2wgcpmVTTAgR5C0DoroaGvrqcH9agXxX8Q2e8YjJXd3b9221+XNbqJqCJu8wiilEd9DWOnuecumDunB27q0kfyIbM
 k0y29IuU
 AGB+HvG2IiKPgkxtDvCrYG7F9yZyjatTys1eAWe+kc1tE6CdsLbp13vZAZ435uUKWJabJKAIwG4QezDVpehoyHQxH7Ks/g/x3P3siIB+8kPTK2IPniOASq16HA6kAcqCAEBcvez7tnzxNLAhmwmZN78eq+8RhoZ49ELT52K1oDCdCDgBT2wz9gTprtgKEh78erqLPRUSdKkvQCEWQ2vMijyfS3id3CBdmz88G+XXzJiRord4+CDGIeR59g7janDQ07//cRKtjaHOINaBjRp+32IITWS1sdoycgiqntZtcM4GaatckZsORFH/OtBdQGRUqQojbreL6Gw4TR66ZGGQ25HFfUiLrR3gniKx/MbCsN1R1/M5PxoQps248g2/9Rif7MPHRhWDdcQ29ZLvai48WOWLHKyNW6FWXZyhC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/11/26 04:31, Mike Rapoport wrote:
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
> * m68k/parisc/um: allocated empty_zero_page from memblock,
>    although they do not support zero page coloring and having it in BSS
>    will work fine.
> * sparc64 can have empty_zero_page in BSS rather allocate it, but it
>    can't use virt_to_page() for BSS. Keep it's definition of ZERO_PAGE()
>    but instead of allocating it, make mem_map_zero point to
>    empty_zero_page.
> * sh: used empty_zero_page for boot parameters at the very early boot.
>    Rename the parameters page to boot_params_page and let sh use the generic
>    empty_zero_page.
> * hexagon: had an amusing comment about empty_zero_page
> 
> 	/* A handy thing to have if one has the RAM. Declared in head.S */
> 
>    that unfortunately had to go :)
> 
> Acked-by: Helge Deller <deller@gmx.de>   # parisc
> Tested-by: Helge Deller <deller@gmx.de>  # parisc
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

>   arch/nios2/include/asm/pgtable.h          |  7 -------
>   arch/nios2/kernel/head.S                  | 10 ----------
>   arch/nios2/kernel/nios2_ksyms.c           |  1 -

For nios2,

Acked-by: Dinh Nguyen <dinguyen@kernel.org>

