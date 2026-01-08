Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403E1D185FE
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 14:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF916B0088; Thu,  8 Jan 2026 09:32:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78DDB6B0089; Thu,  8 Jan 2026 09:32:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F196B0092; Thu,  8 Jan 2026 09:32:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 539766B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:32:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E460188517
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:32:53 +0000 (UTC)
X-FDA: 84309038226.21.24309D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1DC5280015
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:32:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j0rcOouU;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767882772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+fo4oqqy3XvCbNxaVIYZbVpnfs/PKyazstkZfcDtaA=;
	b=HvaZETILOEnuLAhudzpjXZ4d/F4a7Kjt+yY4GwVXIWzPSJgcNpUnghbz+uLfp9zizBBvbE
	weKo8PkpcstLNiXpJm6ov02S9hUdqseUapbj/AmUGwqPHQ1Qh1whbsdZn27mli31J5hu0G
	8WtD7mjs0eCabyYDy1tG/va7RI/GGDI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j0rcOouU;
	spf=pass (imf30.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767882772; a=rsa-sha256;
	cv=none;
	b=o5PGv04UzjXUzIn2Eh6B35oV5/l7x1M0PBNOQ/RpQEKaegmlLIUzd07KuLqZj36AaMt5FB
	oNUpFoU3ShJs5fSSSe/8ScQeMAo8e/V5mcTz3ES9z6N/S/EPyFOa+T3UX1wU/t5aARlWYL
	KojtbJe4uA3qPJE7va0MAOnpvyb7EOo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F45042B02;
	Thu,  8 Jan 2026 14:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FF6C116C6;
	Thu,  8 Jan 2026 14:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767882770;
	bh=byixFr826bNoUVfEfgOc5fuYDNsV3ya0YDlGYcfLm10=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=j0rcOouUnJyejWkw7PDWaIAj/5BtvE4hHQdaZmaVtE/hZtTZbFy76PldBmv4P627j
	 H+ztR6CF6o64VyyjgrSzH7nCBbDkF6r1z7L6MyPI2f7XxMJvJ8cixlvP2ZyzeUwYXT
	 6jnTsNFv2BhH4ogRxYQBjHyzigb4Whsv5cc0gbfTEWDSoxlnBvbpnLyMtwMkwChxfE
	 JixMwVX/P2D3FzKpmEMYXQN7CnqUAQEBSMa+XIMQU+F25Chjo0nC0PTV0Jx8fYxrmW
	 443vFAl1eEVCvRBFkylhCddVemPhe8rXnZ5ZE/pSyQ8eG1phLLG5wDP+XTz/qPpRcS
	 HkcT+AYac7lmg==
Message-ID: <9ea6abb3-4b5d-4da5-9dcf-21ec520d1bca@kernel.org>
Date: Thu, 8 Jan 2026 15:32:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] arch/*: increase lowmem size to avoid highmem use
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Andreas Larsson <andreas@gaisler.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Linus Walleij <linus.walleij@linaro.org>,
 Matthew Wilcox <willy@infradead.org>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Michal Simek <monstr@monstr.eu>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nishanth Menon <nm@ti.com>, Lucas Stach <l.stach@pengutronix.de>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-2-arnd@kernel.org>
 <6089e76b-80aa-4254-af70-12b96d115a2e@kernel.org>
Content-Language: fr-FR
In-Reply-To: <6089e76b-80aa-4254-af70-12b96d115a2e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 7x3ipc7nubogz81uh5b65j4tjydua4xw
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DC5280015
X-HE-Tag: 1767882771-230478
X-HE-Meta: U2FsdGVkX194HUKVSFWd3li46upQygn9Zj33x3Z7Q1pxrhWF0/6neAkBoaNLR7NSash4hAgCz6Qcugu0xfMvBovfdb/Z8tiYBM58VYX/zmMQr6vuAC10anjHBq6d6GpK0Famq7VRj908sgF36eHajjBPx6yiN7v62drbb0fPUrSJ/q/CBykRxCx94CfNxlgZ4z1wBS7/S+d/xMtd6gnd1BHfNMUrO7RwAswd1PKsAJRyGqD2rJUhdFDUx1VtvwJB6/DM4wvMnf1XJrEDV+jDHlhSS72qQgEyJUC3+HqXZtU3lmmCrlQ2pJHB7+gJxP37REirM38VHINgbInVTMsMRSjigAcwYKFllMJnqelM1UbtT6k4D5avsDfENvRXJRRFcuVzi0a8DYJ3tjUB4SfitJkp0UBoB5pzP1srWC2hsycWToim8G5lW7fekCEfKAgyxxxBCVfXUOrgYGyM17zbhHIptqdzPhTkfDZnl30TGSX2Obb2ZV/3/ftkbPXF2NNOI5J1CBj8Tw37g8a+WsMfUpeiCE4k4J2WBpT8g4VKVpdomY7Li+1orvjtcKI0NLaW2v7Hr0CreoOdGsmPwWFkbW9Qv2GKD+pSf2uosfvz8Q9pt81FjQdAhcwLJTdMD2TDlvtVJMLrrLpOzO4fSeiPY7W4/AUrpbtKXpeNPR/Aq0vJz3ANG43UQdAS+brR3+sQ+h20vUWLv3zu5vS33msUSr24AJkucq6yNTa3cZ5MoTCLN5lUFr1ia+lOMnVaA3k4BJV+AwWN6e5CsiyVIxceJW4YjXmuoErmW/LCL8Id3WY15LTRZlFgzLNGKYiqIoQnW3S2/tEBh5/qcBfaG6fNdcdClhnQfYJls187zMsrS7PAoVGBjx0aKQKjW8j7B8XGb/inxJA/3LUNHGOfmUxe5ZP9zq0zWHMugEn+0Bjr1RM1xhIi/6Vh/wJlMK3pQUn7k5yyRWQFhbAKIVW/LlS
 ZKPOY/y8
 XKSR6HJH7h5H53miWh1qFI+3MB0RrFx80dXx8Sw5i62cswQDz1sLWxvb+mzTmi6PRct8tKYMBWLAvgVwKar4FDICIZVtu4iv/BEgCYUmS3blDb5lfBx/T3c+qFa9TF+q18HIL4gt8yjH+ce+797TZSZNngpL6lPHLuqxecZRZ4KS8VIUtxeHnjfXs7+sdyNkoIy4vQr5c0NPLqwdcLmuTWetCPPGqDB9P3uETmqWgg1luoRONAZ4Xdb08eGf9ERfMmPg5f+Is8s943mH98Ft1uE1hM57BR2DPvwSlWjFYar0tDULUuAvjGi+zNH65NAJJF9sMH4FSwg6MOT4u2xGXEpaQ5k5yADmIZY3y1lfcIxMcDnc4QeR7y8OB5S6VezuqlLbCwfIRgS9n3YEMLEVRqGrHwOPIZ8mdxHWktXLAI5pvcW+pA2zgKPYxG4JCbZjP97e5b7tFVYWtjE3jV8vdJNuE048rk84laf9chnasbNGlzjJ4XOcImOb3Ex4RhpfSCtpVavEEOeUhQ5V/f8Wtkx8ecBVGnMoi7XtdWSLnKAntGeJQM2Xbc63dbaHrNIL0/N8Y5BByTqHzLixKEjimKR4EDwv3rIK4CKGPLz1+LHeqVX6ciFRKL2N7ZCVvky+rQ47qae2Lhpj9YPhTJphELwxuPC6BsJtYJdgfZDO57Z+Gmca0x+UTqirNWP1rgkfTi6We3DpsKlhhvg7Dc4Nml+b+MS5bLk30xmn5/T6YSrOQ8lTcsV1nKrcfG9B2L4tlwct0DO22AdrTWUoBzUWF8XnfJ2jL6wxyMYzTRqaoymtixpWGHnfuPzJJMIAcaImfg0zTwN27MpbP967NP+Q0Zr8i+kAimuKJlC6/UkoJq0eEPAQw63kO4J4fLaiHGnvP7fTUJPo3TpbWmj6hUWT7foyE+bbDrjPl2VHbY6AHsjkuK39h4sW8Nb03CE3XNH5QvCiJ7jjUNlCISIzk5CDKvO9Z6phW
 n8JaEL/u
 aMOtYVqGiebE3l3Av+s+00NWvSA7VKAZZ6l28i+lXw5cppro8BIiFKOX+icOveYRGviV1VyPYsZBxe5IUss46svznhZQv41iYKDm2OKIr0/UmLwdNtGiWpq+a+rIrrkZh5wZBoz27WsAJ4XSyFvea1449NfbVCGu19iY6oRKwVnb6Mf6GEUYAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 24/12/2025 à 12:35, Christophe Leroy (CS GROUP) a écrit :
> 
> 
> Le 19/12/2025 à 17:15, Arnd Bergmann a écrit :
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> Most of the common 32-bit architectures (x86, arm, powerpc) all use the
>> default virtual memory layout that was already in place for i386 systems
>> in the 1990s, using exactly 3GiB of user TASK_SIZE, with the upper 1GiB
>> of addresses split between (at most 896MiB) lowmem and vmalloc.
>>
>> Linux-2.3 introduced CONFIG_HIGHMEM for large x86 server machines that
>> had 4GiB of RAM or more, with the VMSPLIT_3G/2G/1G options added in
>> v2.6.16 for machines that had one or two gigabytes of memory but wanted
>> to avoid the overhead from managing highmem. Over time, similar options
>> appeared on other 32-bit architectures.
>>
>> Twenty years later, it makes sense to reconsider the default settings,
>> as the tradeoffs have changed a bit:
>>
>>   - Configurations with more than 2GiB have become extremely rare,
>>     as any users with large memory have moved on to 64-bit systems.
>>     There were only ever a few Laptop models in this category: Apple
>>     Powerbook G4 (2005), Macbook (2006), IBM Thinkpad X60 (2006), Arm
>>     Chromebooks based on Exynos 5800 (2014), Tegra K1 (2014) and RK3288
>>     (2015), and manufacturer support for all of these has ended in 2020
>>     or (much) earlier.
>>     Embedded systems with more than 2GiB use additional SoCs of a
>>     similar vintage: Intel Atom Z5xx (2008), Freescale QorIQ (2008),
>>     Marvell Armada XP (2010), Freescale i.MX6Q (2011), LSI Axxia (2013),
>>     TI Keystone2 (2014), Renesas RZ/G1M (2015). Most boards based on
>>     these have stopped receiving kernel upgrades. Newer 32-bit chips
>>     only support smaller memory configurations, though in particular the
>>     i.MX6Q and Keystone2 families have expected support cycles past 2035.
>>     While 32-bit server installations used to support even larger memory,
>>     none of those seem to still be used in production on any 
>> architecture.
>>
>>   - While general-purpose distributes for 32-bit targets were common,
>>     it was rather risky to change the CONFIG_VMSPLIT setting because
>>     there is always a possibility of running into device driver bugs or
>>     applications that need a large virtual memory size. Presumably
>>     a lot of these issues have been resolved now, so most setups should
>>     be fine using a custom vmsplit instead of highmem now.
>>
>>   - As fewer users test highmem, the expectation is that it will
>>     increasingly break in the future, so getting users to change the
>>     vmsplit means that even if there is a bug to fix initially,
>>     it improves the situation in the long run.
>>
>>   - Highmem will ultimately need to be removed, at least for the page
>>     cache and most other code using it today. In a previous discussion, I
>>     had suggested doing this as early as 2029, but based on the 
>> discussions
>>     since ELC, the plan is now to leave highmem-enabled page cache as an
>>     option until at least 2029, at which point remaining users will have
>>     the choice between no longer updating kernels or using a 
>> combination of
>>     a custom vmsplit and zram/zswap. Changing the defaults now should 
>> both
>>     speed up the highmem deprecation and make it less painful for users.
>>
>>   - The most VM space intensive applications tend to be web browsers,
>>     specifcally Chrome/ChromeOS and Firefox. Both have now stopped
>>     providing binary updates, but Firefox can still be built from source.
>>     Testing various combinations on Debian/armhf, I found that Firefox 
>> 140
>>     can still show complex websites with VMSPLIT_2G_OPT with and without
>>     HIGHMEM, though it failed for me both with the small address space
>>     of VMSPLIT_1G and the small lowmem of VMSPLIT_3G_OPT when HIGHMEM
>>     is disabled.
>>     This is likely to get worse with future versions, so embedded users
>>     may still be forced to migrate to specialized browsers like WPE 
>> Webkit
>>     when HIGHMEM pagecache is finally removed.
>>
>> Based on the above observations and the discussion at the kernel summit,
>> change the defaults to the most appropriate values: use 1GiB of lowmem on
>> non-highmem configurations, and either 2GiB or 1.75GiB of lowmem on 
>> highmem
>> builds, depending on what is available on the architecture.  As ARM_LPAE
>> and X86_PAE builds both require a gigabyte-aligned vmsplit, those get
>> to use VMSPLIT_2G. The result is that the majority of previous highmem
>> users now only need lowmem. For platform specific defconfig files that
>> are known to only support up to 1GiB of RAM, drop the CONFIG_HIGHMEM line
>> as well as a simplification.
>>
>> On PowerPC and Microblaze, the options have somewhat different names but
>> should have the same effect. MIPS and Xtensa cannot support a larger
>> than 512MB of lowmem but are limited to small DDR2 memory in most
>> implementations, with MT7621 being a notable exception. ARC and C-Sky
>> could support a configurable vmsplit in theory, but it's not clear
>> if anyone still cares.
>> SPARC is currently limited to 192MB of lowmem and should get patched
>> to behave either like arm/x86 or powerpc/microblaze to support 2GiB
>> of lowmem.
>>
>> There are likely going to be regressions from the changed defaults,
>> in particular when hitting previously hidden device driver bugs
>> that fail to set the correct DMA mask, or from applications that
>> need a large virtual address space.
>> Ideally the in-kernel problems should all be fixable, but the previous
>> behavior is still selectable as a fallback with CONFIG_EXPERT=y
>>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: x86@kernel.org
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>> Cc: linuxppc-dev@lists.ozlabs.org
>> Cc: Michal Simek <monstr@monstr.eu>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: linux-mm@kvack.org
>> Cc: Richard Weinberger <richard@nod.at>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Nishanth Menon <nm@ti.com>
>> Cc: Andreas Larsson <andreas@gaisler.com>
>> Cc: Lucas Stach <l.stach@pengutronix.de>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>   arch/arm/Kconfig                            |  5 ++++-
>>   arch/arm/configs/aspeed_g5_defconfig        |  1 -
>>   arch/arm/configs/dove_defconfig             |  2 --
>>   arch/arm/configs/mv78xx0_defconfig          |  2 --
>>   arch/arm/configs/u8500_defconfig            |  1 -
>>   arch/arm/configs/vt8500_v6_v7_defconfig     |  3 ---
>>   arch/arm/mach-omap2/Kconfig                 |  1 -
>>   arch/microblaze/Kconfig                     |  9 ++++++---
>>   arch/microblaze/configs/mmu_defconfig       |  1 -
>>   arch/powerpc/Kconfig                        | 17 +++++++++++------
>>   arch/powerpc/configs/44x/akebono_defconfig  |  1 -
>>   arch/powerpc/configs/85xx/ksi8560_defconfig |  1 -
>>   arch/powerpc/configs/85xx/stx_gp3_defconfig |  1 -
> 
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> 
> Be aware that it will likely trivialy conflict with https:// 
> lore.kernel.org/linuxppc- 
> dev/6a2575420770d075cd090b5a316730a2ffafdee4.1766574657.git.chleroy@kernel.org/
> 
> Another point is that it will increase the overall memory usage when 
> people activate KASAN as KASAN reserves 1/8 of RAM for lowmem memory. I 
> think we need to look at the impact on available virtual memory, because 
> 1/8 of 2G is 256M which is the size of the last segment shared by KASAN 
> shadow mem and vmalloc.

After testing I see two problems.

First one is on powerpc e500, increasing CONFIG_LOWMEM_SIZE is not 
enough, CONFIG_LOWMEM_CAM_NUM also need to be increased, otherwise 
additional lowmem is not mapped because e500 linux port is not designed 
to handle additional lowmem with standard pages.

For some details see commit 49e3d8ea6248 ("powerpc/fsl_booke: Enable 
STRICT_KERNEL_RWX")

Second one is with KASAN, as anticipated above in my first response. 
With a 2G+ kernel memory space, the KASAN shadow mem is 256M+, which 
means we get an overlap between lowmem space [0x70000000-0xefffffff] and 
KASAN shadow mem [0xee000000-0xffffffff].
So when KASAN is enabled, either change CONFIG_PAGE_OFFSET and 
CONFIG_TASK_SIZE to 0x60000000 instead of 0x70000000, or reduce 
CONFIG_LOWMEM_SIZE from 0x80000000 to 0x70000000.

Christophe


