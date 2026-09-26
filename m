Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB041C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3FD16B008C; Sat, 26 Sep 2026 05:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17866B0092; Sat, 26 Sep 2026 05:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08B96B0093; Sat, 26 Sep 2026 05:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8B6B6B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:33:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BBF81405A2
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:33:58 +0000 (UTC)
X-FDA: 85255401756.17.97F65C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9FD9E20006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:33:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUSlc8t7;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790415236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCcW/ZPw25GmUZrPOb3+ehUaMoYgZH3e76aMfED5nvs=;
	b=BX0iVI5MOTwrhMYLOL/l6IDDuq/jrhgowDuBoL2rF5IIT+coK93Mdkg2LXnngctPu/T1Qa
	41hu6lYMdsuksvFeKn2shZL00+BHNYWQydGpfDkKpr2wIPhcCl1AprQ1BMklB0NxFkuuO+
	MpkVcu1k1LYgdVUMpjy5/UkrA3JPkdc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUSlc8t7;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790415236;
	b=0OtA+aHSA7XT4VK88kyEfM/l3c0+M8YyQw/Y3eh4vD9LzUpih+DDh1KniyATvc/MYMKleL
	C9KWx1k7gj0HepnsEAFSx6wS7pYwehli17g5aCMOEx0dLSjoZMt3zrO/d+MvK8tBiwBaMS
	cYNgxebxEEHgHFT209NvnHDBNIMCSIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F9EA6020C;
	Sat, 26 Sep 2026 09:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0551F000FF;
	Sat, 26 Sep 2026 09:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790415235;
	bh=TCcW/ZPw25GmUZrPOb3+ehUaMoYgZH3e76aMfED5nvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HUSlc8t7QXy1cY3RRymjf62JIOHvq3PoASk7SIXmW2dsy+3mfad8WoWoc25IV96Jh
	 wR+CM7YVvTD2zHMjiwxDaF21FcCVu7gto/ginWxK2zFOjHoAK0GwyG4tzYNdT0EVeb
	 7rr0lICv6UiEkh15WPYZa7NRgXOibXM11yjHZbHjEQAznOftc9du8QtQujPzPTV9eo
	 fKzB0SkehufejYMXeak9R3+R/RnmU6FVBcbKaquJ169EHy5E+w6gUwmaQ9ir4IESph
	 ofBNTr+jxG1jpZwkLD8Z0NsqvlymvYUTac61mwm2rDGgGXWTXxEjo0KvWddOA8qSzp
	 sVmjCdK1YFagw==
Date: Sat, 26 Sep 2026 10:33:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2] arch, mm: promote DEBUG_WX to CHECK_WX
Message-ID: <areRZcE9woh-KgMt@gremlin>
References: <20260926-direct-map-verify-wx-v2-1-efcd64a6b74a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926-direct-map-verify-wx-v2-1-efcd64a6b74a@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9FD9E20006
X-Stat-Signature: hz586awbbahp1bq1pxrpqy6wf5aszmj4
X-Rspam-User: 
X-HE-Tag: 1790415236-516902
X-HE-Meta: U2FsdGVkX18Yzusp4FY9LuQN4J40CUHN7y97xHAl+h95cEL4/0Rw+ewFv5PVclmgfSDWjren/TUrZbYim208F8MpebBzZOLcTBnIVTnk6n4kHe0bZBtu/AlsSG/PJK5hEUf6Nwo01/HeVFDLxrkEG0ACknMRJUx7DmTNvP9LafKbVSJPBr5Efb3JeNEu21qpcLQ1gv1QwQbgghL1wG/6rBXj8EPfCeFqUZeKJ4x6bzmYbhahuhD9Y6SBXlGZI6C3qrFxHok4ifM8wuPECgYhWmFCQgZf3HP6Z+nOIY1ZZ5RaHQ8fSuRGJPFudpeutfWho14pagxcWgzZR+Fyf6dbCmRNiBTTjITxTtC3SrGB4s8Ikpb6uGEFV2pc7NAWBS/eKYFJmO06hhI8kRvVpPMAKyd6EIYG9QpeuaL/J18wCyWbjVNzkFa4EbNZYmpbh7D9/k8txWXiEQ5KWJKMl4J41aDWpHWRkEcsOQax/3UE8KpmghBJfOO2aaCXWT/4VLHlgtA38ffsAXjWBNGvJ8FyVhQTp+bnXBRcm2q+9w86iPtc46ZpeR+h5K24P7yruzytjQBd723T/39s5iST3W2ZQrVvsc3in8Kx0V5nY6hDvSTFN9IusIVdcizKJCxcwaY36q+UUwENTst+VRAlmd0Qck4X42dDEbWJ+gh4KqNsCfVAvdMuhqw8kV+roYIHM1j6WAD/9JJF0wmMhE9NPSPS6evmdr/4YrIJUBxN4DqPqghwqoavpzqzPDYUEtsgHVdn2Y2uTSIgKE51wSko/VKrzZx1dtTuXhPYICItiFdyIpmuOpkXshE2h7oIhYyslIVoc00XMbQu43kVwLATwx5yz3000qVowi58EZweB8e6MQN+ajLrKsS2I/xN7gh6E2rgflwuMTd5dZg4wnT/aKcV/s1d0DBU2FLVBJcWRMHRaM9cxaBxFPAv5OwBMwcEc6gMGkhogd9W2BLwHfbO98F
 4UXmdk2p
 +Nxga6s/XceWw3C8qAfk9NmkyFl8TX1B4IVI1w9rN8SSfHkSpe9NUuNw2jpK2+JiiBf0cJyz/wEixJzaU9lsvrCFTuTyzDgxvH21v8kSQgSDfFchSatFYRwmK7XMVGcgcXDQUvpuQ3IOiibLSEAWBkUsW+/eiczreJnmia7WVpvcag0J5XJFayIdVXcEcwJ3exMnXGYpZfvuTPkLdwcfHN7Xl3j21iCCnYe2pxKoOQ2KWO1hcjLA4nhKgeB7Hp2SMwVFNYc6NIQlWtrVlMvamg7YStVe4FoQz6B87H5fD5eYH9Zifprvua2ne0skE+2q4lFAZkTWpSylBnFUNWBnzsVRTiD2hwpQW5EkHJsH/bBL5VXux2lqjKyP3QVjU93r6Ua5nJ70ZVRQnHEnjy6bRNo4dT26SvqXdEb2LiPMYvDuvzecMCXzrIzyz2UGTxw9ov8RSYqwNvSZv2Pd0kMk7bnYn2gUjy5IKLqW49Tfdvbdfh9xHs2LLNpHt0YSrxe4tN4qyDFVg1hGelniy/36X25PXrNVx9LHjpTXAs5VH5cVZBQi6izH45+zAag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 12:29:29PM +0300, Mike Rapoport (Microsoft) wrote:
> Verification that the kernel does not have writable + executable
> mappings is about detecting security risks rather than a pure debug
> feature.
>
> Major distribution configurations enable it in their kernels as well as
> defconfigs of most architectures that have ARCH_HAS_DEBUG_WX.
>
> Rename relevant generic configuration options to use CHECK_WX and move
> their definitions from mm/Kconfig.debug to mm/Kconfig.
>
> Rename *debug_checkwx() funcitons and macros to *pgtable_checkwx().
>
> For arm that does not widely enable it, only rename its variants of the
> config options.
>
> Enabling CHECK_WX adds a few kilobytes to the kernel binary and while
> the added size can be slightly reduced with churny updates of
> architecture implementations of ptdump, the core functionality takes
> most of the added size. It cannot be moved to .init.text because the
> verification has to happen after init sections are freed.
>
> With this, make generic CHECK_WX default to STRICT_KERNEL_RWX while
> still leaving users targeting small kernels the possibility to opt-out.
>
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

As with v1, looks sensible to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
> - add rename of *debug_checkwx() to *pgtable_checkwx()
> - Link to v1: https://patch.msgid.link/20260925-direct-map-verify-wx-v1-1-7fd2f7d6d23b@kernel.org
> ---
>  arch/arm/Kconfig.debug               |  2 +-
>  arch/arm/configs/aspeed_g4_defconfig |  2 +-
>  arch/arm/configs/aspeed_g5_defconfig |  2 +-
>  arch/arm/configs/shmobile_defconfig  |  2 +-
>  arch/arm/include/asm/ptdump.h        |  6 +++---
>  arch/arm/mm/init.c                   |  2 +-
>  arch/arm64/Kconfig                   |  2 +-
>  arch/powerpc/Kconfig                 |  2 +-
>  arch/powerpc/configs/ppc64_defconfig |  2 +-
>  arch/powerpc/mm/ptdump/ptdump.c      |  2 +-
>  arch/riscv/Kconfig                   |  2 +-
>  arch/s390/Kconfig                    |  2 +-
>  arch/s390/configs/debug_defconfig    |  2 +-
>  arch/s390/configs/defconfig          |  2 +-
>  arch/s390/mm/dump_pagetables.c       |  2 +-
>  arch/x86/Kconfig                     |  2 +-
>  arch/x86/configs/x86_64_defconfig    |  2 +-
>  arch/x86/include/asm/pgtable.h       |  6 +++---
>  arch/x86/mm/pti.c                    |  2 +-
>  include/linux/ptdump.h               |  4 ++--
>  init/main.c                          |  2 +-
>  kernel/configs/debug.config          |  2 +-
>  mm/Kconfig                           | 41 ++++++++++++++++++++++++++++++++++++
>  mm/Kconfig.debug                     | 39 ----------------------------------
>  24 files changed, 68 insertions(+), 66 deletions(-)
>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 366f162e147d..abcf14f10276 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -17,7 +17,7 @@ config ARM_PTDUMP_DEBUGFS
>  	  kernel.
>  	  If in doubt, say "N"
>
> -config ARM_DEBUG_WX
> +config ARM_CHECK_WX
>  	bool "Warn on W+X mappings at boot"
>  	depends on MMU
>  	select ARM_PTDUMP_CORE
> diff --git a/arch/arm/configs/aspeed_g4_defconfig b/arch/arm/configs/aspeed_g4_defconfig
> index f86dd4ce7d0d..2c9d5a644ae9 100644
> --- a/arch/arm/configs/aspeed_g4_defconfig
> +++ b/arch/arm/configs/aspeed_g4_defconfig
> @@ -249,7 +249,7 @@ CONFIG_DEBUG_INFO_REDUCED=y
>  CONFIG_GDB_SCRIPTS=y
>  CONFIG_STRIP_ASM_SYMS=y
>  CONFIG_DEBUG_FS=y
> -CONFIG_ARM_DEBUG_WX=y
> +CONFIG_ARM_CHECK_WX=y
>  CONFIG_SCHED_STACK_END_CHECK=y
>  CONFIG_PANIC_ON_OOPS=y
>  CONFIG_PANIC_TIMEOUT=-1
> diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
> index 45b937419dbd..1327a09e163a 100644
> --- a/arch/arm/configs/aspeed_g5_defconfig
> +++ b/arch/arm/configs/aspeed_g5_defconfig
> @@ -300,7 +300,7 @@ CONFIG_DEBUG_INFO_REDUCED=y
>  CONFIG_GDB_SCRIPTS=y
>  CONFIG_STRIP_ASM_SYMS=y
>  CONFIG_DEBUG_FS=y
> -CONFIG_ARM_DEBUG_WX=y
> +CONFIG_ARM_CHECK_WX=y
>  CONFIG_SCHED_STACK_END_CHECK=y
>  CONFIG_PANIC_ON_OOPS=y
>  CONFIG_PANIC_TIMEOUT=-1
> diff --git a/arch/arm/configs/shmobile_defconfig b/arch/arm/configs/shmobile_defconfig
> index 6f9696e9fe17..cc22e22b989e 100644
> --- a/arch/arm/configs/shmobile_defconfig
> +++ b/arch/arm/configs/shmobile_defconfig
> @@ -225,4 +225,4 @@ CONFIG_CMA_SIZE_MBYTES=64
>  CONFIG_PRINTK_TIME=y
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_DEBUG_FS=y
> -CONFIG_ARM_DEBUG_WX=y
> +CONFIG_ARM_CHECK_WX=y
> diff --git a/arch/arm/include/asm/ptdump.h b/arch/arm/include/asm/ptdump.h
> index 46a4575146ee..3c5245220ecf 100644
> --- a/arch/arm/include/asm/ptdump.h
> +++ b/arch/arm/include/asm/ptdump.h
> @@ -32,10 +32,10 @@ void ptdump_check_wx(void);
>
>  #endif /* CONFIG_ARM_PTDUMP_CORE */
>
> -#ifdef CONFIG_ARM_DEBUG_WX
> -#define arm_debug_checkwx() ptdump_check_wx()
> +#ifdef CONFIG_ARM_CHECK_WX
> +#define arm_pgtable_checkwx() ptdump_check_wx()
>  #else
> -#define arm_debug_checkwx() do { } while (0)
> +#define arm_pgtable_checkwx() do { } while (0)
>  #endif
>
>  #endif /* __ASM_PTDUMP_H */
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 0cc1bf04686d..c515faf22eeb 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -403,7 +403,7 @@ static int __mark_rodata_ro(void *unused)
>  void mark_rodata_ro(void)
>  {
>  	stop_machine(__mark_rodata_ro, NULL, NULL);
> -	arm_debug_checkwx();
> +	arm_pgtable_checkwx();
>  }
>
>  #else
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b5a51b0ef944..7e120fb21c58 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -11,7 +11,7 @@ config ARM64
>  	select ACPI_MCFG if (ACPI && PCI)
>  	select ACPI_SPCR_TABLE if ACPI
>  	select ACPI_PPTT if ACPI
> -	select ARCH_HAS_DEBUG_WX
> +	select ARCH_HAS_CHECK_WX
>  	select ARCH_BINFMT_ELF_EXTRA_PHDRS
>  	select ARCH_BINFMT_ELF_STATE
>  	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 2580e27e4328..7c1fe5b4cd41 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -130,7 +130,7 @@ config PPC
>  	select ARCH_HAS_CURRENT_STACK_POINTER
>  	select ARCH_HAS_DEBUG_VIRTUAL
>  	select ARCH_HAS_DEBUG_VM_PGTABLE
> -	select ARCH_HAS_DEBUG_WX		if STRICT_KERNEL_RWX
> +	select ARCH_HAS_CHECK_WX		if STRICT_KERNEL_RWX
>  	select ARCH_HAS_DEVMEM_IS_ALLOWED
>  	select ARCH_HAS_DMA_MAP_DIRECT 		if PPC_PSERIES
>  	select ARCH_HAS_DMA_OPS			if PPC64
> diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
> index 1eb8e3457e8b..5c33f0bba0e3 100644
> --- a/arch/powerpc/configs/ppc64_defconfig
> +++ b/arch/powerpc/configs/ppc64_defconfig
> @@ -393,7 +393,7 @@ CONFIG_MAGIC_SYSRQ=y
>  CONFIG_PAGE_OWNER=y
>  CONFIG_PAGE_POISONING=y
>  CONFIG_DEBUG_RODATA_TEST=y
> -CONFIG_DEBUG_WX=y
> +CONFIG_CHECK_WX=y
>  CONFIG_DEBUG_STACK_USAGE=y
>  CONFIG_DEBUG_VM=y
>  # CONFIG_DEBUG_VM_PGTABLE is not set
> diff --git a/arch/powerpc/mm/ptdump/ptdump.c b/arch/powerpc/mm/ptdump/ptdump.c
> index 0d499aebee72..3451351b756b 100644
> --- a/arch/powerpc/mm/ptdump/ptdump.c
> +++ b/arch/powerpc/mm/ptdump/ptdump.c
> @@ -191,7 +191,7 @@ static void note_prot_wx(struct pg_state *st, unsigned long addr)
>  	if (!pte_write(pte) || !pte_exec(pte))
>  		return;
>
> -	WARN_ONCE(IS_ENABLED(CONFIG_DEBUG_WX),
> +	WARN_ONCE(IS_ENABLED(CONFIG_CHECK_WX),
>  		  "powerpc/mm: Found insecure W+X mapping at address %p/%pS\n",
>  		  (void *)st->start_address, (void *)st->start_address);
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index d6c2dbf8455c..05e33d4d5efa 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -29,7 +29,7 @@ config RISCV
>  	select ARCH_HAS_CURRENT_STACK_POINTER
>  	select ARCH_HAS_DEBUG_VIRTUAL if MMU
>  	select ARCH_HAS_DEBUG_VM_PGTABLE
> -	select ARCH_HAS_DEBUG_WX
> +	select ARCH_HAS_CHECK_WX
>  	select ARCH_HAS_DELAY_TIMER
>  	select ARCH_HAS_ELF_CORE_EFLAGS if BINFMT_ELF && ELF_CORE
>  	select ARCH_HAS_FAST_MULTIPLIER
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 4b51bc6e8948..11b76f2b0f80 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -92,7 +92,7 @@ config S390
>  	select ARCH_HAS_CURRENT_STACK_POINTER
>  	select ARCH_HAS_DEBUG_VIRTUAL
>  	select ARCH_HAS_DEBUG_VM_PGTABLE
> -	select ARCH_HAS_DEBUG_WX
> +	select ARCH_HAS_CHECK_WX
>  	select ARCH_HAS_DEVMEM_IS_ALLOWED
>  	select ARCH_HAS_DMA_OPS if PCI
>  	select ARCH_HAS_ELF_RANDOMIZE
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index 3dae71474333..68d53c0bc8db 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -841,7 +841,7 @@ CONFIG_DEBUG_PAGEALLOC=y
>  CONFIG_SLUB_DEBUG_ON=y
>  CONFIG_PAGE_OWNER=y
>  CONFIG_DEBUG_RODATA_TEST=y
> -CONFIG_DEBUG_WX=y
> +CONFIG_CHECK_WX=y
>  CONFIG_PTDUMP_DEBUGFS=y
>  CONFIG_DEBUG_OBJECTS=y
>  CONFIG_DEBUG_OBJECTS_SELFTEST=y
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index 6f5722634b4d..8e5cfc695121 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -820,7 +820,7 @@ CONFIG_DEBUG_INFO_DWARF4=y
>  CONFIG_GDB_SCRIPTS=y
>  CONFIG_DEBUG_SECTION_MISMATCH=y
>  CONFIG_MAGIC_SYSRQ=y
> -CONFIG_DEBUG_WX=y
> +CONFIG_CHECK_WX=y
>  CONFIG_PTDUMP_DEBUGFS=y
>  CONFIG_DEBUG_MEMORY_INIT=y
>  CONFIG_PANIC_ON_OOPS=y
> diff --git a/arch/s390/mm/dump_pagetables.c b/arch/s390/mm/dump_pagetables.c
> index 89badbe72ae7..a23a0bd4d8a8 100644
> --- a/arch/s390/mm/dump_pagetables.c
> +++ b/arch/s390/mm/dump_pagetables.c
> @@ -86,7 +86,7 @@ static void note_prot_wx(struct pg_state *st, unsigned long addr)
>  	 */
>  	if (addr == PAGE_SIZE && (nospec_uses_trampoline() || !cpu_has_bear()))
>  		return;
> -	WARN_ONCE(IS_ENABLED(CONFIG_DEBUG_WX),
> +	WARN_ONCE(IS_ENABLED(CONFIG_CHECK_WX),
>  		  "s390/mm: Found insecure W+X mapping at address %pS\n",
>  		  (void *)st->start_address);
>  	st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 15fd9ec5ecac..170cfcb06174 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -110,7 +110,7 @@ config X86
>  	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
>  	select ARCH_HAS_SYSCALL_WRAPPER
>  	select ARCH_HAS_UBSAN
> -	select ARCH_HAS_DEBUG_WX
> +	select ARCH_HAS_CHECK_WX
>  	select ARCH_HAS_ZONE_DMA_SET if EXPERT
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
>  	select ARCH_HAVE_EXTRA_ELF_NOTES
> diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
> index 269f7d808be4..e6896aeb77d8 100644
> --- a/arch/x86/configs/x86_64_defconfig
> +++ b/arch/x86/configs/x86_64_defconfig
> @@ -263,7 +263,7 @@ CONFIG_SECURITY_SELINUX_BOOTPARAM=y
>  CONFIG_PRINTK_TIME=y
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_MAGIC_SYSRQ=y
> -CONFIG_DEBUG_WX=y
> +CONFIG_CHECK_WX=y
>  CONFIG_DEBUG_STACK_USAGE=y
>  CONFIG_SCHEDSTATS=y
>  CONFIG_BLK_DEV_IO_TRACE=y
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index d551120a7c88..ef0252a09c28 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -41,10 +41,10 @@ void ptdump_walk_user_pgd_level_checkwx(void);
>  #define pgprot_encrypted(prot)	__pgprot(cc_mkenc(pgprot_val(prot)))
>  #define pgprot_decrypted(prot)	__pgprot(cc_mkdec(pgprot_val(prot)))
>
> -#ifdef CONFIG_DEBUG_WX
> -#define debug_checkwx_user()	ptdump_walk_user_pgd_level_checkwx()
> +#ifdef CONFIG_CHECK_WX
> +#define pgtable_checkwx_user()	ptdump_walk_user_pgd_level_checkwx()
>  #else
> -#define debug_checkwx_user()	do { } while (0)
> +#define pgtable_checkwx_user()	do { } while (0)
>  #endif
>
>  extern spinlock_t pgd_lock;
> diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
> index 598f553cc871..31055ee6f1de 100644
> --- a/arch/x86/mm/pti.c
> +++ b/arch/x86/mm/pti.c
> @@ -688,5 +688,5 @@ void pti_finalize(void)
>  	pti_clone_entry_text(true);
>  	pti_clone_kernel_text();
>
> -	debug_checkwx_user();
> +	pgtable_checkwx_user();
>  }
> diff --git a/include/linux/ptdump.h b/include/linux/ptdump.h
> index 240bd3bff18d..af18d1459b2f 100644
> --- a/include/linux/ptdump.h
> +++ b/include/linux/ptdump.h
> @@ -31,9 +31,9 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
>  void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd);
>  bool ptdump_check_wx(void);
>
> -static inline void debug_checkwx(void)
> +static inline void pgtable_checkwx(void)
>  {
> -	if (IS_ENABLED(CONFIG_DEBUG_WX))
> +	if (IS_ENABLED(CONFIG_CHECK_WX))
>  		ptdump_check_wx();
>  }
>
> diff --git a/init/main.c b/init/main.c
> index 31f2bf54976a..a87a3d52f3e2 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1535,7 +1535,7 @@ static void mark_readonly(void)
>  		flush_module_init_free_work();
>  		jump_label_init_ro();
>  		mark_rodata_ro();
> -		debug_checkwx();
> +		pgtable_checkwx();
>  		rodata_test();
>  	} else if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX)) {
>  		pr_info("Kernel memory protection disabled.\n");
> diff --git a/kernel/configs/debug.config b/kernel/configs/debug.config
> index 307c97ac5fa9..ac878669c193 100644
> --- a/kernel/configs/debug.config
> +++ b/kernel/configs/debug.config
> @@ -50,7 +50,7 @@ CONFIG_DEBUG_NET=y
>  # CONFIG_DEBUG_PAGEALLOC is not set
>  # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
>  # CONFIG_DEBUG_RODATA_TEST is not set
> -# CONFIG_DEBUG_WX is not set
> +# CONFIG_CHECK_WX is not set
>  # CONFIG_KFENCE is not set
>  # CONFIG_PAGE_POISONING is not set
>  # CONFIG_SLUB_STATS is not set
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 604c58199acb..ffbc641cc31f 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1511,6 +1511,47 @@ config LAZY_MMU_MODE_KUNIT_TEST
>
>  	  If unsure, say N.
>
> +config ARCH_HAS_CHECK_WX
> +	bool
> +
> +config CHECK_WX
> +	bool "Warn on W+X mappings at boot"
> +	default STRICT_KERNEL_RWX
> +	depends on ARCH_HAS_CHECK_WX
> +	depends on ARCH_HAS_PTDUMP
> +	depends on MMU
> +	select PTDUMP
> +	help
> +	  Generate a warning if any W+X mappings are found at boot.
> +
> +	  This is useful for discovering cases where the kernel is leaving W+X
> +	  mappings after applying NX, as such mappings are a security risk.
> +
> +	  Look for a message in dmesg output like this:
> +
> +	    <arch>/mm: Checked W+X mappings: passed, no W+X pages found.
> +
> +	  or like this, if the check failed:
> +
> +	    <arch>/mm: Checked W+X mappings: failed, <N> W+X pages found.
> +
> +	  Note that even if the check fails, your kernel is possibly
> +	  still fine, as W+X mappings are not a security hole in
> +	  themselves, what they do is that they make the exploitation
> +	  of other unfixed kernel bugs easier.
> +
> +	  There is no runtime or memory usage effect of this option
> +	  once the kernel has booted up - it's a one time check.
> +
> +	  If in doubt, say "Y".
> +
> +config ARCH_HAS_PTDUMP
> +	bool
> +
> +config PTDUMP
> +	bool
> +
> +
>  source "mm/damon/Kconfig"
>
>  endmenu
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 15dca19dd07d..75b44e4a6e36 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -180,45 +180,6 @@ config DEBUG_RODATA_TEST
>  	help
>  	  This option enables a testcase for the setting rodata read-only.
>
> -config ARCH_HAS_DEBUG_WX
> -	bool
> -
> -config DEBUG_WX
> -	bool "Warn on W+X mappings at boot"
> -	depends on ARCH_HAS_DEBUG_WX
> -	depends on ARCH_HAS_PTDUMP
> -	depends on MMU
> -	select PTDUMP
> -	help
> -	  Generate a warning if any W+X mappings are found at boot.
> -
> -	  This is useful for discovering cases where the kernel is leaving W+X
> -	  mappings after applying NX, as such mappings are a security risk.
> -
> -	  Look for a message in dmesg output like this:
> -
> -	    <arch>/mm: Checked W+X mappings: passed, no W+X pages found.
> -
> -	  or like this, if the check failed:
> -
> -	    <arch>/mm: Checked W+X mappings: failed, <N> W+X pages found.
> -
> -	  Note that even if the check fails, your kernel is possibly
> -	  still fine, as W+X mappings are not a security hole in
> -	  themselves, what they do is that they make the exploitation
> -	  of other unfixed kernel bugs easier.
> -
> -	  There is no runtime or memory usage effect of this option
> -	  once the kernel has booted up - it's a one time check.
> -
> -	  If in doubt, say "Y".
> -
> -config ARCH_HAS_PTDUMP
> -	bool
> -
> -config PTDUMP
> -	bool
> -
>  config PTDUMP_DEBUGFS
>  	bool "Export kernel pagetable layout to userspace via debugfs"
>  	depends on DEBUG_KERNEL
>
> ---
> base-commit: 93f51579e7df248780214094418f205253383cc5
> change-id: 20260925-direct-map-verify-wx-b81bda879781
>
> --
> Sincerely yours,
> Mike.
>

--
Cheers, Lorenzo

