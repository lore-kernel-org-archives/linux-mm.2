Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F5D606A8A3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zytor.com header.i=@zytor.com header.a=rsa-sha256 header.s=2026102901 header.b=hLvlflTf
Received: by kanga.kvack.org (Postfix)
	id 706056B05B1; Fri, 13 Nov 2026 13:36:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE2B6B05B2; Fri, 13 Nov 2026 13:36:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4F66B05B3; Fri, 13 Nov 2026 13:36:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38D466B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:36:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B5FFA74BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:36:03 +0000 (UTC)
X-FDA: 85430950206.18.770E5C1
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf14.hostedemail.com (Postfix) with ESMTP id 44F3A100005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:36:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026102901 header.b=hLvlflTf;
	spf=pass (imf14.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794594962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQM0Eqevi39I6efnAGJWX6sTdbneZiskdiEz4iTSbVI=;
	b=HY3V25ejmyqcPLoSGHNcEgdomAApR2FLZSzKRvLEdPEtJfkDxeKIybzOq6trlXS4KyoiBL
	KxVTm4v9viqFQLgo5s8VGY9kIayuSFNHRM7gdvnm6f6mbOtOS8KaeBeWgtznU2NhNUVRVU
	LMZd98J0iq7FZ/H1zeAxn2TKNWog5JI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794594962;
	b=OAx1n/O9sdGdG+unXGfiaSBT+uE1WPzE0yVq0LdScqSEqF7BBurI7ELGhbSq9gbFgMuzL0
	IAluNnAoCa2lbfVgufLyk2urdSvg/xwl1wL9wYe3VaYhcbxi09J/DDmQCOe7sag5C/JOCV
	m1yGzrhwt/2ssq4R3VqvqSH5T8a2mRA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026102901 header.b=hLvlflTf;
	spf=pass (imf14.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6ADIZ7Zg3211036
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 13 Nov 2026 10:35:07 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6ADIZ7Zg3211036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026102901; t=1794594911;
	bh=pQM0Eqevi39I6efnAGJWX6sTdbneZiskdiEz4iTSbVI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=hLvlflTfffn5LaAa0wRWOAvYk5UifUP+pjXOmX/93UO0UhzRCep+sbvbwfddgzlAC
	 h5BBWoIhclq+G1VgtjwLQ+B5R01ig8NyPqojI3Wz3ZaLZ8wQskFT47zwqV5d6v5ZuR
	 ++6zUKnQ7zkU64MG/7mwtydh7nHn+8uHf+tvT83u6RHKaikan66a5ff6kagEwUjT6T
	 wF2EGFPPPfazqVUKiCgQrhjM6wvrwZnqlJ894bW4P2fxwjsGMnz5v0ZbbBjaawFPvP
	 xMZRXrRzSO1ilqEF5JsHoWGoJyxIm0ZEudA+2Q4covflSecvFJpB4/bJdhoEII4bzQ
	 hajFWIgK02jvg==
Date: Fri, 13 Nov 2026 10:35:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org
CC: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Larsson <andreas@gaisler.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David Hildenbrand (Arm)" <david@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Malin Jonsson <malin.jonsson@est.tech>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>, Michal Simek <monstr@monstr.eu>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Nishanth Menon <nm@ti.com>, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v2 5/6] arch/*: increase lowmem size to avoid highmem use
User-Agent: K-9 Mail for Android
In-Reply-To: <20261112112528.1116405-6-arnd@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org> <20261112112528.1116405-6-arnd@kernel.org>
Message-ID: <9DD8B891-A7DC-4B2B-ADA8-E6EB1590A10A@zytor.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fb4dhz9fmx8kjppouu3a94qxkk8rkggc
X-Rspamd-Queue-Id: 44F3A100005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794594960-58413
X-HE-Meta: U2FsdGVkX18RCnKnQJgscTUSfvC8hhDu8pbSqjsRfAZ4RDyY5DqzP+WAkgNOU4xbKMVXZPSN2g9tHEjz/l5FKBFHOUveGvqwNtggrAnaT0WLZESqPIKOZ5w62Ytsa3B/VeGZU9teGgRdtXYOgpS1dB5ZtZVMVke2QmjrlUS3eiHrFgLhGZTMoE9/+QXKVu7cyaTqpqFEHVJ5uc9WAGXfLNw+JTe9AbGP7AxYEK1ENE+78GzUxAHHMuwjvpJVc/wNngUC7ti3WWYjhc5g9GTjZwdlq9lFPidQVVF8PjZSpbLMPpSDisuvaktbgKPPkaGNck8IZENz4mOWaIKmNt9eF+b+MC02IZ2tUCA7BkZkORk4wiQTUjdeodO8nj3MujVNnY6lu0DTAND3knGIzY1ooOcQaM2inv7M9XrOS/sBoZuFsBKexvS3kuA5MM4lrSZn3/eheAyc+yFs6IuVADsHh2UWSJLgxmtR7s7NZWcNtqLO4ZYH+1medWtkiSpsYEDuVTRYdAfawFmi+PWs2YgTvaSE8KKivDanwXQeOsv/cH4bFFndYwadYB2RMydFRwf+VMvwQfB8T4O0cSFuFdpsed3B6LzqWHomeuzsLTWHQyjQxF+3pd3YHwXcxq0H30R2vaLEF47DOlaS3y/cY5H6r9lR6ewflVOTVK5rI9wknv6KaUJvPXJAto86vm3M6yqN+dJ1MXMbRS+Rvw6ST+0TxdB7cn12TkAFEhh8Al5fGOZP+Gtv1ultbG0Oo21aH3AADTskYLlinPFqzWperQ/l92GtStR/o8f83sia4SZ0opwy2iS+YNRMIwuMF5ilwmzAHoOh4VaFTWuD6edFD6AlRnRRLb+7q1ZsMA3wLJ9s+sP2zcLsIVtwY5d+bwZv1zo465Nb1eLXnAytgFn2LNydg1SVYb77TV5ZNy+MPqmL5GiTwBB9lUZ9qwZYMMq9kOnyYE3pzdkmt3Xcn1skFzo
 RqVvmoqw
 Y1C0Q/ZmvJDC0gxvJ1SjMHISzHLlb2TMPkQIrHRSeSbcNhrQgVc0M7K4DOYobW7NdJeI1OclPOSDhJfZ9Q2W9+PLXW24423snu3M1TuXy9jeAGgzxG+MSc5QiVE8+O35t/aVN2zwkYuEjJI5h8aRGTQInbEeyVIYrXkO1/okcqr+/1/v1RV+QiKuwtt7VRMPohRzaMqmjs+5ptIH6ASxCPw4oiSYTCGJBV1/zmbWTM4lAw7OhgGK+GPDL4r+1Nq0L0nuryg+iLxiodhBaCa0w18nUXp/g8P1EGRG9JDKaLPo2lESrcT/ORspt6XBahX0Y2TRIOoQNuePj2AM8pGSQSqpz0GQg/qgWcQ/tA2+KMg7HZnn1SEjljBdDc6U+i6AlCP+yLaBaQuXb0YRa/GFN16fQ+Fpx8CuVXiA/jrvYCwPrPnCa5NOBUqKBIZHMGlSXWg8OJ8E3Hlig0OqOLC96I/AR2zBe3BOKsnwr6O8OC42pS+0WtyAvkSfebnAkCn+2aWR9wzyxvZyrfIbBcXWrmZqHfepqQy1AYMF5UC75sR66sUSsiw32gOqalbqI1PPtX6V/n2OKRh5atEB5WhHDbwU+39ROJVsvEbTM6D+LLE+MIJx/0vopqJImAvef3D9ULo3jl5cO5+ijemsFR6MlmRAnywdb7SHrYfxse8gkchIQXDadB6XZaitjE/FoMGZvIJf1Jy9L2WKOwAFDwXePlYp5SMpeeoJoqMV6G0PHObSBAh/oAv7vrZYSGJulm+2sYuubqCXzD3PAKNjfmcV9msRe7t/rdbkaKGYO7jq4NnGV7MyinTMn40pSY4Knc3YPJIM4TTdx9/NETpXpqV6lUClVqru5nsmkN1RWSkZr/Nw3Qtcd8iBsMZj6BNdR6g60A2US2QTnIadv3y3wwqzK+VF7f8AgPAZEUVP5wumNBGKbuVB7VOIoil/QZAOoGlKN48+jwl2PJsl22mVkrfZAxIggD/Oo
 zqh8jQXx
 xDRWyFo4nX1GmvX+2W9h/ikaZ0q2Wtx0uzLCoVh3pNnKooRQYVW6ETweu43o/2wnvioZbWorkvtsv4frpBMJaX//fds2u0mNrdOam51RCd53QHDHQ72J57S9uvdsrnp7OnIaq+4cTn90YJP/oUNGag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On November 12, 2026 3:25:27 AM PST, Arnd Bergmann <arnd@kernel=2Eorg> wrot=
e:
>From: Arnd Bergmann <arnd@arndb=2Ede>
>
>Most of the common 32-bit architectures (x86, arm, powerpc) all use the
>default virtual memory layout that was already in place for i386 systems
>in the 1990s, using exactly 3GiB of user TASK_SIZE, with the upper 1GiB
>of addresses split between (at most 896MiB) lowmem and vmalloc=2E
>
>Linux-2=2E3 introduced CONFIG_HIGHMEM for large x86 server machines that
>had 4GiB of RAM or more, with the VMSPLIT_3G/2G/1G options added in
>v2=2E6=2E16 for machines that had one or two gigabytes of memory but want=
ed
>to avoid the overhead from managing highmem=2E Over time, similar options
>appeared on other 32-bit architectures=2E
>
>Twenty years later, it makes sense to reconsider the default settings,
>as the tradeoffs have changed a bit:
>
> - Configurations with more than 2GiB have become extremely rare,
>   as any users with large memory have moved on to 64-bit systems=2E
>   There were only ever a few Laptop models in this category: Apple
>   Powerbook G4 (2005), Macbook (2006), IBM Thinkpad X60 (2006), Arm
>   Chromebooks based on Exynos 5800 (2014), Tegra K1 (2014) and RK3288
>   (2015), and manufacturer support for all of these has ended in 2020
>   or (much) earlier=2E
>   Embedded systems with more than 2GiB use additional SoCs of a
>   similar vintage: Intel Atom Z5xx (2008), Freescale QorIQ (2008),
>   Marvell Armada XP (2010), Freescale i=2EMX6Q (2011), LSI Axxia (2013),
>   TI Keystone2 (2014), Renesas RZ/G1M (2015)=2E Most boards based on
>   these have stopped receiving kernel upgrades and later 32-bit chips
>   only support smaller memory configurations, though in particular the
>   i=2EMX6Q and Keystone2 families have expected support cycles past 2035=
=2E
>   While 32-bit server installations used to support even larger memory,
>   none of those seem to still be used in production on any architecture=
=2E
>
> - While general-purpose distributes for 32-bit targets were common,
>   it was rather risky to change the CONFIG_VMSPLIT setting because
>   there is always a possibility of running into device driver bugs or
>   applications that need a large virtual memory size=2E Presumably
>   a lot of these issues have been resolved now, so most setups should
>   be fine using a custom vmsplit instead of highmem now=2E
>
> - As fewer users test highmem, the expectation is that it will
>   increasingly break in the future, so getting users to change the
>   vmsplit means that even if there is a bug to fix initially,
>   it improves the situation in the long run=2E
>
> - Highmem will ultimately need to be removed, at least for the page
>   cache and most other code using it today=2E In a previous discussion, =
I
>   had suggested doing this as early as 2029, but based on the discussion=
s
>   since ELC, the plan is now to leave highmem-enabled page cache as an
>   option until at least 2029, at which point remaining users will have
>   the choice between no longer updating kernels or using a combination o=
f
>   a custom vmsplit and zram/zswap=2E Changing the defaults now should bo=
th
>   speed up the highmem deprecation and make it less painful for users=2E
>
> - The most VM space intensive applications tend to be web browsers,
>   specifcally Chrome/ChromeOS and Firefox=2E Both have now stopped
>   providing binary updates=2E
>   Testing various combinations on Debian/armhf, I found that Firefox 140
>   can still show complex websites with VMSPLIT_2G_OPT with and without
>   HIGHMEM, though it failed for me both with the small address space
>   of VMSPLIT_1G and the small lowmem of VMSPLIT_3G_OPT when HIGHMEM
>   is disabled=2E
>   This is likely to get worse with future versions, so embedded users
>   may still be forced to migrate to specialized browsers like WPE Webkit
>   when HIGHMEM pagecache is finally removed=2E
>
>Based on the above observations and the discussion at the kernel summit,
>change the defaults to the most appropriate values: use 1GiB of lowmem on
>non-highmem configurations, and either 2GiB or 1=2E75GiB of lowmem on hig=
hmem
>builds, depending on what is available on the architecture=2E  As ARM_LPA=
E
>and X86_PAE builds both require a gigabyte-aligned vmsplit, those get
>to use VMSPLIT_2G=2E The result is that the majority of previous highmem
>users now only need lowmem=2E For platform specific defconfig files that
>are known to only support up to 1GiB of RAM, drop the CONFIG_HIGHMEM line
>as well as a simplification=2E
>
>On PowerPC and Microblaze, the options have somewhat different names but
>should have the same effect=2E MIPS and Xtensa cannot support a larger
>than 512MB of lowmem but are limited to small DDR2 memory in most
>implementations, with MT7621 being a notable exception=2E ARC and C-Sky
>could support a configurable vmsplit in theory, but it's not clear
>if anyone still cares=2E
>SPARC is currently limited to 192MB of lowmem and should get patched
>to behave either like arm/x86 or powerpc/microblaze to support 2GiB
>of lowmem=2E
>
>There are likely going to be regressions from the changed defaults,
>in particular when hitting previously hidden device driver bugs
>that fail to set the correct DMA mask, or from applications that
>need a large virtual address space=2E
>Ideally the in-kernel problems should all be fixable, but as a fallback,
>the previous behavior is still selectable based on CONFIG_EXPERT=3Dy=2E
>
>Cc: Russell King <linux@armlinux=2Eorg=2Euk>
>Cc: linux-arm-kernel@lists=2Einfradead=2Eorg
>Cc: Thomas Gleixner <tglx@linutronix=2Ede>
>Cc: Ingo Molnar <mingo@redhat=2Ecom>
>Cc: Borislav Petkov <bp@alien8=2Ede>
>Cc: Dave Hansen <dave=2Ehansen@linux=2Eintel=2Ecom>
>Cc: x86@kernel=2Eorg
>Cc: "H=2E Peter Anvin" <hpa@zytor=2Ecom>
>Cc: Madhavan Srinivasan <maddy@linux=2Eibm=2Ecom>
>Cc: Michael Ellerman <mpe@ellerman=2Eid=2Eau>
>Cc: Nicholas Piggin <npiggin@gmail=2Ecom>
>Cc: Christophe Leroy (CS GROUP) <chleroy@kernel=2Eorg>
>Cc: linuxppc-dev@lists=2Eozlabs=2Eorg
>Cc: Michal Simek <monstr@monstr=2Eeu>
>Cc: Andrew Morton <akpm@linux-foundation=2Eorg>
>Cc: David Hildenbrand <david@kernel=2Eorg>
>Cc: Lorenzo Stoakes <lorenzo=2Estoakes@oracle=2Ecom>
>Cc: Liam R=2E Howlett <Liam=2EHowlett@oracle=2Ecom>
>Cc: Vlastimil Babka <vbabka@suse=2Ecz>
>Cc: Mike Rapoport <rppt@kernel=2Eorg>
>Cc: Suren Baghdasaryan <surenb@google=2Ecom>
>Cc: Michal Hocko <mhocko@suse=2Ecom>
>Cc: Matthew Wilcox <willy@infradead=2Eorg>
>Cc: linux-mm@kvack=2Eorg
>Cc: Richard Weinberger <richard@nod=2Eat>
>Cc: Linus Walleij <linus=2Ewalleij@linaro=2Eorg>
>Cc: Nishanth Menon <nm@ti=2Ecom>
>Cc: Andreas Larsson <andreas@gaisler=2Ecom>
>Cc: Lucas Stach <l=2Estach@pengutronix=2Ede>
>Signed-off-by: Arnd Bergmann <arnd@arndb=2Ede>
>---
> arch/arm/Kconfig                            |  5 ++++-
> arch/arm/configs/aspeed_g5_defconfig        |  1 -
> arch/arm/configs/u8500_defconfig            |  1 -
> arch/arm/configs/vt8500_v6_v7_defconfig     |  2 --
> arch/arm/mach-omap2/Kconfig                 |  1 -
> arch/microblaze/Kconfig                     |  9 ++++++---
> arch/microblaze/configs/mmu_defconfig       |  1 -
> arch/powerpc/Kconfig                        | 14 +++++++++-----
> arch/powerpc/configs/44x/akebono_defconfig  |  1 -
> arch/powerpc/configs/85xx/ksi8560_defconfig |  1 -
> arch/powerpc/configs/85xx/stx_gp3_defconfig |  1 -
> arch/x86/Kconfig                            |  4 +++-
> 12 files changed, 22 insertions(+), 19 deletions(-)
>
>diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>index fc66d52d847e=2E=2E797705a94b28 100644
>--- a/arch/arm/Kconfig
>+++ b/arch/arm/Kconfig
>@@ -1025,7 +1025,8 @@ config BL_SWITCHER_DUMMY_IF
> choice
> 	prompt "Memory split"
> 	depends on MMU
>-	default VMSPLIT_3G
>+	default VMSPLIT_2G if HIGHMEM || ARM_LPAE
>+	default VMSPLIT_3G_OPT
> 	help
> 	  Select the desired split between kernel and user memory=2E
>=20
>@@ -1034,8 +1035,10 @@ choice
>=20
> 	config VMSPLIT_3G
> 		bool "3G/1G user/kernel split"
>+		depends on !HIGHMEM || EXPERT
> 	config VMSPLIT_3G_OPT
> 		depends on !ARM_LPAE
>+		depends on !HIGHMEM || EXPERT
> 		bool "3G/1G user/kernel split (for full 1G low memory)"
> 	config VMSPLIT_2G
> 		bool "2G/2G user/kernel split"
>diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspe=
ed_g5_defconfig
>index 1327a09e163a=2E=2E7f077c667478 100644
>--- a/arch/arm/configs/aspeed_g5_defconfig
>+++ b/arch/arm/configs/aspeed_g5_defconfig
>@@ -27,7 +27,6 @@ CONFIG_SMP=3Dy
> # CONFIG_ARM_CPU_TOPOLOGY is not set
> CONFIG_VMSPLIT_2G=3Dy
> CONFIG_NR_CPUS=3D2
>-CONFIG_HIGHMEM=3Dy
> CONFIG_UACCESS_WITH_MEMCPY=3Dy
> CONFIG_VFP=3Dy
> CONFIG_NEON=3Dy
>diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_de=
fconfig
>index 2fe25f5eb9a5=2E=2Eb284c2c31758 100644
>--- a/arch/arm/configs/u8500_defconfig
>+++ b/arch/arm/configs/u8500_defconfig
>@@ -6,7 +6,6 @@ CONFIG_KALLSYMS_ALL=3Dy
> CONFIG_ARCH_U8500=3Dy
> CONFIG_SMP=3Dy
> CONFIG_NR_CPUS=3D2
>-CONFIG_HIGHMEM=3Dy
> CONFIG_ARM_APPENDED_DTB=3Dy
> CONFIG_ARM_ATAG_DTB_COMPAT=3Dy
> CONFIG_CMDLINE=3D"root=3D/dev/ram0 console=3DttyAMA2,115200n8"
>diff --git a/arch/arm/configs/vt8500_v6_v7_defconfig b/arch/arm/configs/v=
t8500_v6_v7_defconfig
>index 2925a1f1dbb6=2E=2E1f6dca21d569 100644
>--- a/arch/arm/configs/vt8500_v6_v7_defconfig
>+++ b/arch/arm/configs/vt8500_v6_v7_defconfig
>@@ -8,8 +8,6 @@ CONFIG_ARM_ERRATA_720789=3Dy
> CONFIG_ARM_ERRATA_754322=3Dy
> CONFIG_ARM_ERRATA_775420=3Dy
> CONFIG_HAVE_ARM_ARCH_TIMER=3Dy
>-CONFIG_HIGHMEM=3Dy
>-CONFIG_HIGHPTE=3Dy
> CONFIG_ARM_APPENDED_DTB=3Dy
> CONFIG_ARM_ATAG_DTB_COMPAT=3Dy
> CONFIG_VFP=3Dy
>diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
>index f0f1d7a8640c=2E=2Ed145e448a6b8 100644
>--- a/arch/arm/mach-omap2/Kconfig
>+++ b/arch/arm/mach-omap2/Kconfig
>@@ -135,7 +135,6 @@ config ARCH_OMAP2PLUS_TYPICAL
> 	bool "Typical OMAP configuration"
> 	default y
> 	select AEABI
>-	select HIGHMEM if !CPU_CACHE_VIVT
> 	select I2C
> 	select I2C_OMAP
> 	select MENELAUS if ARCH_OMAP2
>diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
>index 9063a91cfb41=2E=2E8ce8d108bfd7 100644
>--- a/arch/microblaze/Kconfig
>+++ b/arch/microblaze/Kconfig
>@@ -164,7 +164,8 @@ config LOWMEM_SIZE_BOOL
>=20
> config LOWMEM_SIZE
> 	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
>-	default "0x30000000"
>+	default "0x80000000" if HIGHMEM
>+	default "0x40000000"
>=20
> config MANUAL_RESET_VECTOR
> 	hex "Microblaze reset vector address setup"
>@@ -190,7 +191,8 @@ config KERNEL_START_BOOL
>=20
> config KERNEL_START
> 	hex "Virtual address of kernel base" if KERNEL_START_BOOL
>-	default "0xc0000000"
>+	default "0x70000000" if HIGHMEM
>+	default "0xb0000000"
>=20
> config TASK_SIZE_BOOL
> 	bool "Set custom user task size"
>@@ -204,7 +206,8 @@ config TASK_SIZE_BOOL
>=20
> config TASK_SIZE
> 	hex "Size of user task space" if TASK_SIZE_BOOL
>-	default "0x80000000"
>+	default "0x70000000" if HIGHMEM
>+	default "0xb0000000"
>=20
> config MB_MANAGER
> 	bool "Support for Microblaze Manager"
>diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/conf=
igs/mmu_defconfig
>index 7f9b19d0d9db=2E=2E19a13d3ece5c 100644
>--- a/arch/microblaze/configs/mmu_defconfig
>+++ b/arch/microblaze/configs/mmu_defconfig
>@@ -15,7 +15,6 @@ CONFIG_XILINX_MICROBLAZE0_USE_FPU=3D2
> CONFIG_HZ_100=3Dy
> CONFIG_CMDLINE_BOOL=3Dy
> CONFIG_CMDLINE_FORCE=3Dy
>-CONFIG_HIGHMEM=3Dy
> CONFIG_MODULES=3Dy
> CONFIG_MODULE_UNLOAD=3Dy
> CONFIG_PARTITION_ADVANCED=3Dy
>diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>index c3b6cd655606=2E=2E31e68cd32a10 100644
>--- a/arch/powerpc/Kconfig
>+++ b/arch/powerpc/Kconfig
>@@ -489,6 +489,7 @@ menu "Kernel options"
> config HIGHMEM
> 	bool "High memory support"
> 	depends on PPC32
>+	depends on PPC_BOOK3S_32 || PPC_85xx || 44x
> 	select KMAP_LOCAL
>=20
> source "kernel/Kconfig=2Ehz"
>@@ -1190,7 +1191,8 @@ config LOWMEM_SIZE_BOOL
>=20
> config LOWMEM_SIZE
> 	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
>-	default "0x30000000"
>+	default "0x80000000" if HIGHMEM
>+	default "0x40000000"
>=20
> config LOWMEM_CAM_NUM_BOOL
> 	bool "Set number of CAMs to use to map low memory"
>@@ -1242,7 +1244,8 @@ config PAGE_OFFSET_BOOL
>=20
> config PAGE_OFFSET
> 	hex "Virtual address of memory base" if PAGE_OFFSET_BOOL
>-	default "0xc0000000"
>+	default "0x70000000" if HIGHMEM
>+	default "0xb0000000"
>=20
> config KERNEL_START_BOOL
> 	bool "Set custom kernel base address"
>@@ -1258,8 +1261,9 @@ config KERNEL_START_BOOL
> config KERNEL_START
> 	hex "Virtual address of kernel base" if KERNEL_START_BOOL
> 	default PAGE_OFFSET if PAGE_OFFSET_BOOL
>-	default "0xc2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
>-	default "0xc0000000"
>+	default "0x72000000" if HIGHMEM && CRASH_DUMP && !NONSTATIC_KERNEL
>+	default "0xb2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
>+	default PAGE_OFFSET
>=20
> config PHYSICAL_START_BOOL
> 	bool "Set physical address where the kernel is loaded"
>@@ -1295,7 +1299,7 @@ config TASK_SIZE_BOOL
> config TASK_SIZE
> 	hex "Size of maximum user task space" if TASK_SIZE_BOOL
> 	default "0x80000000" if PPC_8xx
>-	default "0xc0000000"
>+	default PAGE_OFFSET
>=20
> config MODULES_SIZE_BOOL
> 	bool "Set custom size for modules/execmem area"
>diff --git a/arch/powerpc/configs/44x/akebono_defconfig b/arch/powerpc/co=
nfigs/44x/akebono_defconfig
>index bdb0e6ece6ec=2E=2Ecc1e3da5f8f5 100644
>--- a/arch/powerpc/configs/44x/akebono_defconfig
>+++ b/arch/powerpc/configs/44x/akebono_defconfig
>@@ -14,7 +14,6 @@ CONFIG_MODULE_UNLOAD=3Dy
> CONFIG_PPC_47x=3Dy
> # CONFIG_EBONY is not set
> CONFIG_AKEBONO=3Dy
>-CONFIG_HIGHMEM=3Dy
> CONFIG_HZ_100=3Dy
> CONFIG_IRQ_ALL_CPUS=3Dy
> # CONFIG_COMPACTION is not set
>diff --git a/arch/powerpc/configs/85xx/ksi8560_defconfig b/arch/powerpc/c=
onfigs/85xx/ksi8560_defconfig
>index 9cb211fb6d1e=2E=2Ef2ac1fc41303 100644
>--- a/arch/powerpc/configs/85xx/ksi8560_defconfig
>+++ b/arch/powerpc/configs/85xx/ksi8560_defconfig
>@@ -9,7 +9,6 @@ CONFIG_PARTITION_ADVANCED=3Dy
> CONFIG_KSI8560=3Dy
> CONFIG_CPM2=3Dy
> CONFIG_GEN_RTC=3Dy
>-CONFIG_HIGHMEM=3Dy
> CONFIG_BINFMT_MISC=3Dy
> CONFIG_MATH_EMULATION=3Dy
> # CONFIG_SECCOMP is not set
>diff --git a/arch/powerpc/configs/85xx/stx_gp3_defconfig b/arch/powerpc/c=
onfigs/85xx/stx_gp3_defconfig
>index 0a42072fa23c=2E=2E1033977711d6 100644
>--- a/arch/powerpc/configs/85xx/stx_gp3_defconfig
>+++ b/arch/powerpc/configs/85xx/stx_gp3_defconfig
>@@ -7,7 +7,6 @@ CONFIG_MODULES=3Dy
> CONFIG_MODVERSIONS=3Dy
> # CONFIG_BLK_DEV_BSG is not set
> CONFIG_STX_GP3=3Dy
>-CONFIG_HIGHMEM=3Dy
> CONFIG_BINFMT_MISC=3Dm
> CONFIG_MATH_EMULATION=3Dy
> CONFIG_PCI=3Dy
>diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>index 58dce0b66179=2E=2E18b3eeebb7ce 100644
>--- a/arch/x86/Kconfig
>+++ b/arch/x86/Kconfig
>@@ -1410,7 +1410,9 @@ config HIGHMEM4G
>=20
> choice
> 	prompt "Memory split" if EXPERT
>-	default VMSPLIT_3G
>+	default VMSPLIT_2G_OPT if HIGHMEM && !X86_PAE
>+	default VMSPLIT_2G if X86_PAE
>+	default VMSPLIT_3G_OPT
> 	depends on X86_32
> 	help
> 	  Select the desired split between kernel and user memory=2E

The usage of 32-but kernels has certainly drifted, but I do remember us ha=
ving tried this at one point and having to revert it=2E

Then again, it is kind of valid to squeeze the users here: these days if y=
ou have that kind of constraints the answer really is "use a 64-bit CPU, si=
lly=2E" As the price of memory is expected to remain high for much of the r=
emaining decade, the cost-benefit tradeoff for not using your gigabytes of =
memory well versus the incremental cost of a 64-bit CPU should make the cho=
ice trivial=2E

That leaves *very* memory-constrained systems (< 1 GiB) and legacy systems=
 as the main target=2E Legacy systems presumably will want to change as lit=
tle as possible, which means at least leaving the current split as an optio=
n (and will then be picked up by their previous kernel config, even); for t=
he severely memory-constrained systems it doesn't matter all that much=2E=
=20

One advantage of reducing the split line is that for architectures with gi=
gabyte split lines you actually get to fit *all* of a 1 GiB RAM in the virt=
ual space, helping systems with exactly 1 GiB as pushing a few hundred MiB =
into highmem probably is more expensive than that memory is worth!


