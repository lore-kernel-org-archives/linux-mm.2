Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3630660A261F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B7lfJLX5
Received: by kanga.kvack.org (Postfix)
	id 534006B05EF; Fri, 13 Nov 2026 13:58:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B6B6B05F0; Fri, 13 Nov 2026 13:58:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB056B05F1; Fri, 13 Nov 2026 13:58:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 157AE6B05EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:58:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8E84A6E94
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:58:36 +0000 (UTC)
X-FDA: 85431007032.21.18FD556
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id F35C440007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:58:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B7lfJLX5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HGeEfIDbBHhrKlnUlvruB5x/9z02TagTkMS4moQX50=;
	b=mX2zIYMroXc9m3OYX98SBNMx567xOiLgYV4LrDMfQAPZffetopanO+cMU924EDMVS7xSWy
	P2ge1dr3qTp+vucqibTaQi8DoKpHd7rlpcQkfDiR/5SwUxyH8YLoUqh2aI3FG6J8KNzYWK
	xr+l3WEjAkN437FdnI7B3WGvCv+1KWI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596315;
	b=zZi8xhIPN+mpkdPyjHTBMDuvkqbBuEhiOeKEBRCVQ3qCS/TquLnrTe9OmidOV7M0JmY2u3
	aIr45VV7sL0Zxpt3kXFKqpIzPwTg08jZTsVfR+GCzb1Vu7S98SZCfN0Ka+mhGv7SO2COta
	2EBB2mgMDhiFndXgP0t1EkgyQ21Fw18=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B7lfJLX5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2143340B5A;
	Fri, 13 Nov 2026 18:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965A81F000C4;
	Fri, 13 Nov 2026 18:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596314;
	bh=4HGeEfIDbBHhrKlnUlvruB5x/9z02TagTkMS4moQX50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B7lfJLX5++LlxUciYSI76JIOR6unoh5c5NhwiL/l4RaJE1J3W4GYKLDWCbiYUUQiX
	 lhP6ZNL6VXTHFrN8wbgaIoSbt3k6uGOj5Tl3kFMKuEfg3zfk2SjIGd7Pl1b8yLMIXK
	 shnk7LKSH9MuCAkDd4mxiRdM/0nRBsqZIdg2Nq5JLRbiHST7b8uYTEAG17IgGUfoKP
	 PvrA19WXmsDnsqpo0fyRD6KBprGkcBN1G/Ww++h8qFYnVUC85labd9qIVakpEPTfb1
	 FZNCCdQqCBuC9uLw1PIBwZR7zjzEBvxHdYSo8L5WA2iU03SH8Cv3aiXBZSZyk4F+2T
	 Sm8lqMtKFJOtw==
Date: Fri, 13 Nov 2026 18:58:24 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Andreas Larsson <andreas@gaisler.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Matthew Wilcox <willy@infradead.org>, 
	Malin Jonsson <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Michal Simek <monstr@monstr.eu>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Nishanth Menon <nm@ti.com>, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v2 5/6] arch/*: increase lowmem size to avoid highmem use
Message-ID: <avddvZcf6bpbpFcU@gremlin>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-6-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-6-arnd@kernel.org>
X-Stat-Signature: 4k3gi8b4wrxa9fgyzjhuyjyzkbm8rrp1
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F35C440007
X-HE-Tag: 1794596314-998265
X-HE-Meta: U2FsdGVkX19EOLRT5VCDyyqMrSZQ050rp3FMmHMWAUdhaVIOE7Wi3lWlFqrwfE7eA0qL8u99UGpM6+5NxXnCWm2cS4EMPwDeF3ROFRxMLMPARidQDCR6iTCC8JPopQK/yCs9DiPwcwkiSEWXC3YAATXpwgFskD2TTBwWH5guWJL0jJO+TPeGEo53ckkdyspsLEfk6mKflk1GFSQGITMcJuHhaET0U10YOyUeYxp9CpeVX8cZvzsSJttE1aT3yUVV/MTudQlnVigROQm3GE72o+unItKqgRM/L2I69vHyuUzznN/GTRyPKdDFcjkr1R9JI1hQBiVFVVroG97C8A25ooVvmPdt2dJ4dlN47JxQf8Lzdu2I7VUerW27PyS6kX/9l6rHP6tkztDRu//bdv4y21mnCfnaCx6Vlz69b2ZGyg3cQUPQ+xSSvTI4hlhYcAteXHwqV+l3iEslc9dLPROfRZWEYLwAQKeB9mD71eKCdNgoS5Q9pZ20dp6G3beh5HcUPhuAIR6nx4cQNUGOX/5uX9fK74Oixcta5ybvo1A6a218LVwqcW1PBHEGn+Lo8VEGBjxss9+FFOkZHynDomghyXKEht/mIh+6MCaBdXqzvILbWIFlOZA2wOkkmhvILOORNppO7RxuXbePgjchGitL/zdumq5pQDK9x/LDcsYjJibIUQFGFzJ4GHHiXg0Mj4EJywh6dHYCb2xqUa/XB7VUgLktfBy4a5yrCr6BAsBfxx2BstPUtOvUwQrNuXeltULczWSM4zkG1haG1gBA9lfpih3Oh7zz2bYB4t4hI1/3T52bR6j9hmdlU4noACsw6N1SVNw/g4LhJJEUL0xe4U5KCqPt0zmz4+ufdpU/xNQfvygiM1+we9thvofdkEdO2DpL8AGune8clHwvqoZwaZhJ7ngP/gBNAslEEFyzl6UR2sKCkOw7t0IVgH/xkR4VNCmecvQfTXQTQjm6w+hhjbB
 VAf+FcLr
 mQIaRIQZ1Vcz5BJHluCSHt5dJIY+9jUjo/FfGFF2DVt61mN7T8YUMVDOLIz7dDa9coVQAleRTGmLL6IgzXrb4ZO/Ig7EGeKr1//Mfy4IrurIP2928MVRiTyAUsIM28QMjDBpcgdD/v4d7wEBcW2G8TqZTX4b0oMgm1ls0bIdPjDMQ50AilGLbWYgBgPGVGo8FeUL5XVK/lVgYehgXPr8z9bRuhTeA8XxVLxj++PiXou4UrPUjwUhd6isyvYtyeoMaHYAZ2lXVPEREIv6rgcqO0oy5tBkha48LZSK5xSp9ObdeFN+/dVs7/CXXqYYgZRAQ2Lh7Vv61VF0+P8Htz/x5+bm2j1r/+0LMF3VJR8qjUPQsYRG9W8BJRhpWVFZ5zpVdJSe9bttrQEuAdd8q95XSwHPLT9dKwZe13ukz3FfEQ2wnrS2s+/jz5WNHZT3r8FjRAZPdoGK0dWU1ihy0b3uBc6BMKJtGI6rL66fL8MSyJRMu4IwQsv7OLUjgp/0a7ivbprcI21m4soQWSVeiFea8L8P3hiTXPrkBvEANOIfQHlhy27j1/lYf2kUt4rmwqlKWl07ND/u8OguZAO8l88PrdRER5NizJ5fuFqbDOaZUsYCPsWshQp7+OO6aBafN4n00wlYsczTHAnkCA7pl+7GleRhfComDmTQ9/EPIh8VwG3i8OGBzWs7MNaEG13BCgQ0yzVmA5p+h9azPvEcOhn0XOnMrQfLEabZn9mkjdvwxkXTShwwqtokio4tkFbFSdAYOX/W6uRMc9YzNbaWmZOReid6J29FwH+sagjBnZRq1rCnYfLGrpzAvEoaZsiIHwXhkCvuOy9g90OlH3lH+es8O7BS8LdO0Z8jyJ+cQk+/9+jpZ1oQ68wTYNQY0QSinicWMsnWiq6ChypG8Y1Z+Wrk0IH/G2rZ5w2nDLCJ8E8S4R2JDrPAtrO0dwnJQVLc06D+vQP2JVqB/6e5vx14tHbh+tWK2inXa
 ChTOegXn
 a1Ubfm7nF++Csu2xJ12mapnKcNf+ofYh1urN4GRaHwr3vjLsI4itMkOma12l6FWAXcsDBtNDaD8YLeYzWlmMPA/Ijb+kXUN8qCNzaU1bq7LH/+J5j/OCAnJ1MBYnIidUv3D+4iTvB91UXrNVhREAl6Q+qEEOw8mN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:27PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Most of the common 32-bit architectures (x86, arm, powerpc) all use the
> default virtual memory layout that was already in place for i386 systems
> in the 1990s, using exactly 3GiB of user TASK_SIZE, with the upper 1GiB
> of addresses split between (at most 896MiB) lowmem and vmalloc.
>
> Linux-2.3 introduced CONFIG_HIGHMEM for large x86 server machines that
> had 4GiB of RAM or more, with the VMSPLIT_3G/2G/1G options added in
> v2.6.16 for machines that had one or two gigabytes of memory but wanted
> to avoid the overhead from managing highmem. Over time, similar options
> appeared on other 32-bit architectures.
>
> Twenty years later, it makes sense to reconsider the default settings,
> as the tradeoffs have changed a bit:
>
>  - Configurations with more than 2GiB have become extremely rare,
>    as any users with large memory have moved on to 64-bit systems.
>    There were only ever a few Laptop models in this category: Apple
>    Powerbook G4 (2005), Macbook (2006), IBM Thinkpad X60 (2006), Arm
>    Chromebooks based on Exynos 5800 (2014), Tegra K1 (2014) and RK3288
>    (2015), and manufacturer support for all of these has ended in 2020
>    or (much) earlier.
>    Embedded systems with more than 2GiB use additional SoCs of a
>    similar vintage: Intel Atom Z5xx (2008), Freescale QorIQ (2008),
>    Marvell Armada XP (2010), Freescale i.MX6Q (2011), LSI Axxia (2013),
>    TI Keystone2 (2014), Renesas RZ/G1M (2015). Most boards based on
>    these have stopped receiving kernel upgrades and later 32-bit chips
>    only support smaller memory configurations, though in particular the
>    i.MX6Q and Keystone2 families have expected support cycles past 2035.
>    While 32-bit server installations used to support even larger memory,
>    none of those seem to still be used in production on any architecture.
>
>  - While general-purpose distributes for 32-bit targets were common,
>    it was rather risky to change the CONFIG_VMSPLIT setting because
>    there is always a possibility of running into device driver bugs or
>    applications that need a large virtual memory size. Presumably
>    a lot of these issues have been resolved now, so most setups should
>    be fine using a custom vmsplit instead of highmem now.
>
>  - As fewer users test highmem, the expectation is that it will
>    increasingly break in the future, so getting users to change the
>    vmsplit means that even if there is a bug to fix initially,
>    it improves the situation in the long run.
>
>  - Highmem will ultimately need to be removed, at least for the page
>    cache and most other code using it today. In a previous discussion, I
>    had suggested doing this as early as 2029, but based on the discussions
>    since ELC, the plan is now to leave highmem-enabled page cache as an
>    option until at least 2029, at which point remaining users will have
>    the choice between no longer updating kernels or using a combination of
>    a custom vmsplit and zram/zswap. Changing the defaults now should both
>    speed up the highmem deprecation and make it less painful for users.
>
>  - The most VM space intensive applications tend to be web browsers,
>    specifcally Chrome/ChromeOS and Firefox. Both have now stopped
>    providing binary updates.
>    Testing various combinations on Debian/armhf, I found that Firefox 140
>    can still show complex websites with VMSPLIT_2G_OPT with and without
>    HIGHMEM, though it failed for me both with the small address space
>    of VMSPLIT_1G and the small lowmem of VMSPLIT_3G_OPT when HIGHMEM
>    is disabled.
>    This is likely to get worse with future versions, so embedded users
>    may still be forced to migrate to specialized browsers like WPE Webkit
>    when HIGHMEM pagecache is finally removed.
>
> Based on the above observations and the discussion at the kernel summit,
> change the defaults to the most appropriate values: use 1GiB of lowmem on
> non-highmem configurations, and either 2GiB or 1.75GiB of lowmem on highmem
> builds, depending on what is available on the architecture.  As ARM_LPAE
> and X86_PAE builds both require a gigabyte-aligned vmsplit, those get
> to use VMSPLIT_2G. The result is that the majority of previous highmem
> users now only need lowmem. For platform specific defconfig files that
> are known to only support up to 1GiB of RAM, drop the CONFIG_HIGHMEM line
> as well as a simplification.
>
> On PowerPC and Microblaze, the options have somewhat different names but
> should have the same effect. MIPS and Xtensa cannot support a larger
> than 512MB of lowmem but are limited to small DDR2 memory in most
> implementations, with MT7621 being a notable exception. ARC and C-Sky
> could support a configurable vmsplit in theory, but it's not clear
> if anyone still cares.
> SPARC is currently limited to 192MB of lowmem and should get patched
> to behave either like arm/x86 or powerpc/microblaze to support 2GiB
> of lowmem.
>
> There are likely going to be regressions from the changed defaults,
> in particular when hitting previously hidden device driver bugs
> that fail to set the correct DMA mask, or from applications that
> need a large virtual address space.
> Ideally the in-kernel problems should all be fixable, but as a fallback,
> the previous behavior is still selectable based on CONFIG_EXPERT=y.
>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: linux-mm@kvack.org
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Andreas Larsson <andreas@gaisler.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Very nice, thanks! :)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm/Kconfig                            |  5 ++++-
>  arch/arm/configs/aspeed_g5_defconfig        |  1 -
>  arch/arm/configs/u8500_defconfig            |  1 -
>  arch/arm/configs/vt8500_v6_v7_defconfig     |  2 --
>  arch/arm/mach-omap2/Kconfig                 |  1 -
>  arch/microblaze/Kconfig                     |  9 ++++++---
>  arch/microblaze/configs/mmu_defconfig       |  1 -
>  arch/powerpc/Kconfig                        | 14 +++++++++-----
>  arch/powerpc/configs/44x/akebono_defconfig  |  1 -
>  arch/powerpc/configs/85xx/ksi8560_defconfig |  1 -
>  arch/powerpc/configs/85xx/stx_gp3_defconfig |  1 -
>  arch/x86/Kconfig                            |  4 +++-
>  12 files changed, 22 insertions(+), 19 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index fc66d52d847e..797705a94b28 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1025,7 +1025,8 @@ config BL_SWITCHER_DUMMY_IF
>  choice
>  	prompt "Memory split"
>  	depends on MMU
> -	default VMSPLIT_3G
> +	default VMSPLIT_2G if HIGHMEM || ARM_LPAE
> +	default VMSPLIT_3G_OPT
>  	help
>  	  Select the desired split between kernel and user memory.
>
> @@ -1034,8 +1035,10 @@ choice
>
>  	config VMSPLIT_3G
>  		bool "3G/1G user/kernel split"
> +		depends on !HIGHMEM || EXPERT
>  	config VMSPLIT_3G_OPT
>  		depends on !ARM_LPAE
> +		depends on !HIGHMEM || EXPERT
>  		bool "3G/1G user/kernel split (for full 1G low memory)"
>  	config VMSPLIT_2G
>  		bool "2G/2G user/kernel split"
> diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
> index 1327a09e163a..7f077c667478 100644
> --- a/arch/arm/configs/aspeed_g5_defconfig
> +++ b/arch/arm/configs/aspeed_g5_defconfig
> @@ -27,7 +27,6 @@ CONFIG_SMP=y
>  # CONFIG_ARM_CPU_TOPOLOGY is not set
>  CONFIG_VMSPLIT_2G=y
>  CONFIG_NR_CPUS=2
> -CONFIG_HIGHMEM=y
>  CONFIG_UACCESS_WITH_MEMCPY=y
>  CONFIG_VFP=y
>  CONFIG_NEON=y
> diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
> index 2fe25f5eb9a5..b284c2c31758 100644
> --- a/arch/arm/configs/u8500_defconfig
> +++ b/arch/arm/configs/u8500_defconfig
> @@ -6,7 +6,6 @@ CONFIG_KALLSYMS_ALL=y
>  CONFIG_ARCH_U8500=y
>  CONFIG_SMP=y
>  CONFIG_NR_CPUS=2
> -CONFIG_HIGHMEM=y
>  CONFIG_ARM_APPENDED_DTB=y
>  CONFIG_ARM_ATAG_DTB_COMPAT=y
>  CONFIG_CMDLINE="root=/dev/ram0 console=ttyAMA2,115200n8"
> diff --git a/arch/arm/configs/vt8500_v6_v7_defconfig b/arch/arm/configs/vt8500_v6_v7_defconfig
> index 2925a1f1dbb6..1f6dca21d569 100644
> --- a/arch/arm/configs/vt8500_v6_v7_defconfig
> +++ b/arch/arm/configs/vt8500_v6_v7_defconfig
> @@ -8,8 +8,6 @@ CONFIG_ARM_ERRATA_720789=y
>  CONFIG_ARM_ERRATA_754322=y
>  CONFIG_ARM_ERRATA_775420=y
>  CONFIG_HAVE_ARM_ARCH_TIMER=y
> -CONFIG_HIGHMEM=y
> -CONFIG_HIGHPTE=y
>  CONFIG_ARM_APPENDED_DTB=y
>  CONFIG_ARM_ATAG_DTB_COMPAT=y
>  CONFIG_VFP=y
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index f0f1d7a8640c..d145e448a6b8 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -135,7 +135,6 @@ config ARCH_OMAP2PLUS_TYPICAL
>  	bool "Typical OMAP configuration"
>  	default y
>  	select AEABI
> -	select HIGHMEM if !CPU_CACHE_VIVT
>  	select I2C
>  	select I2C_OMAP
>  	select MENELAUS if ARCH_OMAP2
> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> index 9063a91cfb41..8ce8d108bfd7 100644
> --- a/arch/microblaze/Kconfig
> +++ b/arch/microblaze/Kconfig
> @@ -164,7 +164,8 @@ config LOWMEM_SIZE_BOOL
>
>  config LOWMEM_SIZE
>  	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
> -	default "0x30000000"
> +	default "0x80000000" if HIGHMEM
> +	default "0x40000000"
>
>  config MANUAL_RESET_VECTOR
>  	hex "Microblaze reset vector address setup"
> @@ -190,7 +191,8 @@ config KERNEL_START_BOOL
>
>  config KERNEL_START
>  	hex "Virtual address of kernel base" if KERNEL_START_BOOL
> -	default "0xc0000000"
> +	default "0x70000000" if HIGHMEM
> +	default "0xb0000000"
>
>  config TASK_SIZE_BOOL
>  	bool "Set custom user task size"
> @@ -204,7 +206,8 @@ config TASK_SIZE_BOOL
>
>  config TASK_SIZE
>  	hex "Size of user task space" if TASK_SIZE_BOOL
> -	default "0x80000000"
> +	default "0x70000000" if HIGHMEM
> +	default "0xb0000000"
>
>  config MB_MANAGER
>  	bool "Support for Microblaze Manager"
> diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
> index 7f9b19d0d9db..19a13d3ece5c 100644
> --- a/arch/microblaze/configs/mmu_defconfig
> +++ b/arch/microblaze/configs/mmu_defconfig
> @@ -15,7 +15,6 @@ CONFIG_XILINX_MICROBLAZE0_USE_FPU=2
>  CONFIG_HZ_100=y
>  CONFIG_CMDLINE_BOOL=y
>  CONFIG_CMDLINE_FORCE=y
> -CONFIG_HIGHMEM=y
>  CONFIG_MODULES=y
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_PARTITION_ADVANCED=y
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index c3b6cd655606..31e68cd32a10 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -489,6 +489,7 @@ menu "Kernel options"
>  config HIGHMEM
>  	bool "High memory support"
>  	depends on PPC32
> +	depends on PPC_BOOK3S_32 || PPC_85xx || 44x
>  	select KMAP_LOCAL
>
>  source "kernel/Kconfig.hz"
> @@ -1190,7 +1191,8 @@ config LOWMEM_SIZE_BOOL
>
>  config LOWMEM_SIZE
>  	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
> -	default "0x30000000"
> +	default "0x80000000" if HIGHMEM
> +	default "0x40000000"
>
>  config LOWMEM_CAM_NUM_BOOL
>  	bool "Set number of CAMs to use to map low memory"
> @@ -1242,7 +1244,8 @@ config PAGE_OFFSET_BOOL
>
>  config PAGE_OFFSET
>  	hex "Virtual address of memory base" if PAGE_OFFSET_BOOL
> -	default "0xc0000000"
> +	default "0x70000000" if HIGHMEM
> +	default "0xb0000000"
>
>  config KERNEL_START_BOOL
>  	bool "Set custom kernel base address"
> @@ -1258,8 +1261,9 @@ config KERNEL_START_BOOL
>  config KERNEL_START
>  	hex "Virtual address of kernel base" if KERNEL_START_BOOL
>  	default PAGE_OFFSET if PAGE_OFFSET_BOOL
> -	default "0xc2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
> -	default "0xc0000000"
> +	default "0x72000000" if HIGHMEM && CRASH_DUMP && !NONSTATIC_KERNEL
> +	default "0xb2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
> +	default PAGE_OFFSET
>
>  config PHYSICAL_START_BOOL
>  	bool "Set physical address where the kernel is loaded"
> @@ -1295,7 +1299,7 @@ config TASK_SIZE_BOOL
>  config TASK_SIZE
>  	hex "Size of maximum user task space" if TASK_SIZE_BOOL
>  	default "0x80000000" if PPC_8xx
> -	default "0xc0000000"
> +	default PAGE_OFFSET
>
>  config MODULES_SIZE_BOOL
>  	bool "Set custom size for modules/execmem area"
> diff --git a/arch/powerpc/configs/44x/akebono_defconfig b/arch/powerpc/configs/44x/akebono_defconfig
> index bdb0e6ece6ec..cc1e3da5f8f5 100644
> --- a/arch/powerpc/configs/44x/akebono_defconfig
> +++ b/arch/powerpc/configs/44x/akebono_defconfig
> @@ -14,7 +14,6 @@ CONFIG_MODULE_UNLOAD=y
>  CONFIG_PPC_47x=y
>  # CONFIG_EBONY is not set
>  CONFIG_AKEBONO=y
> -CONFIG_HIGHMEM=y
>  CONFIG_HZ_100=y
>  CONFIG_IRQ_ALL_CPUS=y
>  # CONFIG_COMPACTION is not set
> diff --git a/arch/powerpc/configs/85xx/ksi8560_defconfig b/arch/powerpc/configs/85xx/ksi8560_defconfig
> index 9cb211fb6d1e..f2ac1fc41303 100644
> --- a/arch/powerpc/configs/85xx/ksi8560_defconfig
> +++ b/arch/powerpc/configs/85xx/ksi8560_defconfig
> @@ -9,7 +9,6 @@ CONFIG_PARTITION_ADVANCED=y
>  CONFIG_KSI8560=y
>  CONFIG_CPM2=y
>  CONFIG_GEN_RTC=y
> -CONFIG_HIGHMEM=y
>  CONFIG_BINFMT_MISC=y
>  CONFIG_MATH_EMULATION=y
>  # CONFIG_SECCOMP is not set
> diff --git a/arch/powerpc/configs/85xx/stx_gp3_defconfig b/arch/powerpc/configs/85xx/stx_gp3_defconfig
> index 0a42072fa23c..1033977711d6 100644
> --- a/arch/powerpc/configs/85xx/stx_gp3_defconfig
> +++ b/arch/powerpc/configs/85xx/stx_gp3_defconfig
> @@ -7,7 +7,6 @@ CONFIG_MODULES=y
>  CONFIG_MODVERSIONS=y
>  # CONFIG_BLK_DEV_BSG is not set
>  CONFIG_STX_GP3=y
> -CONFIG_HIGHMEM=y
>  CONFIG_BINFMT_MISC=m
>  CONFIG_MATH_EMULATION=y
>  CONFIG_PCI=y
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58dce0b66179..18b3eeebb7ce 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1410,7 +1410,9 @@ config HIGHMEM4G
>
>  choice
>  	prompt "Memory split" if EXPERT
> -	default VMSPLIT_3G
> +	default VMSPLIT_2G_OPT if HIGHMEM && !X86_PAE
> +	default VMSPLIT_2G if X86_PAE
> +	default VMSPLIT_3G_OPT
>  	depends on X86_32
>  	help
>  	  Select the desired split between kernel and user memory.
> --
> 2.53.0
>

--
Cheers, Lorenzo

