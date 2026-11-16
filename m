Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50288606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HwjzLPrS
Received: by kanga.kvack.org (Postfix)
	id 76B206B05BD; Mon, 16 Nov 2026 07:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7429F6B05BE; Mon, 16 Nov 2026 07:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F6A6B05BF; Mon, 16 Nov 2026 07:49:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6766B05BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:49:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C752A120134
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:26 +0000 (UTC)
X-FDA: 85440963132.28.E92EA40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3CE77100004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwjzLPrS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3u1YbP0glgrlPVSZVLO7Md+O8bEthJ8oEllh+tqqYIs=;
	b=ug9EyG95jThRgOj1q6onpBHimAq5S4qiq0hsuML/v7EdHcbRYslCEKC7gQ7MK+zVhz5an3
	7L9yXOQ09QLrx1VvQkIfaucn3UNkoF/xKahzLLQBiEEsmXXFwBg3PtdedbeKh4g5PD7flT
	32BW6PUL3qu/G9jbdPqSlG4buiMup0o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwjzLPrS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833365;
	b=K+PWbOwa2g4E+Nk1/Xv45B+zrseq51T67tvCfUj/SSRCG3Q88PL9WbcrzoLpqBT9jzSXrT
	xNw3Sqty8HmI1aTXUJ7rW3IOEiEBVKhKZ4e++LMLyCQXivrLsrrdNoma2GQuaxPIAYaH+w
	Ez2MDh0OaZ4T0xIUH2OqjUTVQCx2kUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE3D5612ED;
	Mon, 16 Nov 2026 12:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA631F000C4;
	Mon, 16 Nov 2026 12:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833364;
	bh=3u1YbP0glgrlPVSZVLO7Md+O8bEthJ8oEllh+tqqYIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwjzLPrSZpfGTVk4lN0Ho9oJpr0gZLkBoAC029OaRpb2ldn3xDllvh2HnLoT94Fb/
	 TDYQNRfyLKplvKQWdKlBl5GUJFKxnE1srWWg1c5WgPjV0cA3xM96ik5Y34iJ6OfNWM
	 tbRUmyufSXh88UFfS0u89a2YfwULjV+IbEEPsLcfzSubqsmHTOJaFp8XR9Tk53cMv8
	 y3jkV6Qv3iRMqD1R5bOMquB7vTnY7u7ucMjlf7xKmSttLEz4PA7bTmoUBx4o45yMCr
	 9JeOqh6bWP2quBFFxZQDDDTkeDpCk6/CFlsdoY4DOMT0fwCQe0ZnOIVph7buF6qLKK
	 E1ytUvDgbIMqQ==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v3 07/10] ARM: defconfig: turn off highmem in favor of CONFIG_VMSPLIT_2G_OPT
Date: Mon, 16 Nov 2026 13:48:29 +0100
Message-ID: <20261116124832.662455-8-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116124832.662455-1-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3CE77100004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ox1kkieiwqwsojg9pyyrbgp8nibwj7sd
X-HE-Tag: 1794833365-485751
X-HE-Meta: U2FsdGVkX1//V4rMPAmhdlFd8/IA1UMKVhIT4V9PMMiaph0pYjEqxW6KBJ+yV+QdXhWT6osXNCr8aFho+Pl0VAfmHbENJNLbcIIi4DhQABfwHiG7KIThRFS7OAolBXVHnE+PEDXUrBnlQNXO59umg813Z0h6CI/WZlN/PcpVC7d0s6JEPMHdMKHPiHZLOWX/mpZr5mngzwTY1APpBYbVu/4hLDQF981O0uxelxQYqCyNYw/y0p8c7QVhojjkof5prdbpyqjmgx4olZV4ooMGcd6aQsUpE1qtOOSTqGCWc+Z59kMy7PjariUV7nJ76JNQA1K9arDczjWKPZdLsZ/xmu7Z13WJ4a9VzpsGjS+9jI6DTlf08D8BiLIt5/zfXpxytMmkh3MyUAYeJGLtcrcyJ0tYgtZUXlBlc8+qWy0MtgXQNVbRcTK/v3X8TGf9uXrO6KyQKMXMy+SQCBjP0VLSHCYvr0PW2O1MN2usOXkAQb8k58BIefM5c1WHTAAwxiYH1OoT8NtpwFoEDDdZuurRugLLlMrJk3SCvbg6/VLif72Wow4D6GLO7SafQVq9a2aIfvY4jQEFj9Z2s4J4mcwkTDp+ZNjMjitLGfKFRo9UHbJfBmk/oELmsMGQya/0nCn16WhadFhhnBvsxX6bAS/0gxKF2XlU2JMzEv3hPFERWznDNN2sEOZXHeUgNdhYjHWhQIt3OhNJK9Gbnw5xbTd3fxmHCAJ655oJT79ij6TMidDpQV30gxjR+9xuxvthv50GMLIk/etcjIKIuTE6i7QCccmymE8kWZ6zOAowiF9hBpmLGyYFH8LElGvpkreEgStwtpjarQeRrsab2y/7K0HRbHi6moXS5h/wsJhMvcgeMprCmvo5tO01+zutiRzxAsQRqVACWUEit2X/CZ/EopxfvqzlXcccTFBtKlwNuAuAymo+reD25v4WDVsFn/510/l9J0kv8QqggMp+kKtzcrL
 g9fX8XWY
 hsPKhiCs2Q7XaRpb2jC+0dpbtt1oLlvkb1OUddB8zI6JXDoOFk9kmNOYH3+GW6aEd8YG0wekdrym4YQVRnwezV8IdxKLddAk28RjIfHztUq8xNZuIgoo5tY0ordmwW3QvD0U0WK2ULIE9YLR/CdRdU/rgGFDeVi2w8gXWgzstF1TCxpnGwJqF5mLTbVghBi0u8nQdYkWhR3xVaewH8ub3f+etnYpIBHQHctL15v1fgrpUEDxk8G4hFlLcNh3ls2MTifgs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

The multi_v7_defconfig and omap2plus_defconfig attempt to support a
broad range of hardware. This is at odds with the setting for highmem
being slowly phased out on the one hand but still enabled by means of
CONFIG_ARCH_OMAP2PLUS_TYPICAL, leading to a default CONFIG_VMSPLIT_2G_OPT
split.

None of the upstream OMAP2+ DTS files actually list more than 2GiB
of RAM, so it seems fine to just turn off highmem by default and use
CONFIG_VMSPLIT_2G_OPT from the defconfig to still support the same
hardware but not require highmem.

This also changes multi_v7_defconfig, which currently supports all sorts
of ARMv7 systems except those that require LPAE.

The best comprimise I can think of again is to use VMSPLIT_2G_OPT in
place of highmem. Compared to highmem configurations, this should be
an improvement on most machines with 2GiB of installed memory for the
lower overhead and complexity, but it does degrade machines that rely
on highmem to access all memory, as well as reduce the available user
address space (1.75GiB instead of the traditional 3GiB).

For aspeed_g5_defconfig, the decision is trivial, as there are no
4GiB configurations we need to support, but g6 is known to use
up to 2GiB.

If you run into problems on production machines with the new default,
with the absence of highmem, or the smaller user area, please complain.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/configs/aspeed_g5_defconfig | 3 +--
 arch/arm/configs/lpae.config         | 1 +
 arch/arm/configs/multi_v7_defconfig  | 1 +
 arch/arm/configs/omap2plus_defconfig | 1 +
 arch/arm/mach-omap2/Kconfig          | 1 -
 5 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
index 1327a09e163a..060797cc6726 100644
--- a/arch/arm/configs/aspeed_g5_defconfig
+++ b/arch/arm/configs/aspeed_g5_defconfig
@@ -25,9 +25,8 @@ CONFIG_MACH_ASPEED_G6=y
 # CONFIG_CACHE_L2X0 is not set
 CONFIG_SMP=y
 # CONFIG_ARM_CPU_TOPOLOGY is not set
-CONFIG_VMSPLIT_2G=y
+CONFIG_VMSPLIT_2G_OPT=y
 CONFIG_NR_CPUS=2
-CONFIG_HIGHMEM=y
 CONFIG_UACCESS_WITH_MEMCPY=y
 CONFIG_VFP=y
 CONFIG_NEON=y
diff --git a/arch/arm/configs/lpae.config b/arch/arm/configs/lpae.config
index 1ab94da8345d..535696d6de96 100644
--- a/arch/arm/configs/lpae.config
+++ b/arch/arm/configs/lpae.config
@@ -1,3 +1,4 @@
 # Help: Enable Large Physical Address Extension mode
 CONFIG_ARM_LPAE=y
 CONFIG_VMSPLIT_2G=y
+CONFIG_HIGHMEM=y
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 069d5a49f01c..c3e427ce8d88 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -103,6 +103,7 @@ CONFIG_ARCH_VEXPRESS_TC2_PM=y
 CONFIG_ARCH_WM8850=y
 CONFIG_ARCH_ZYNQ=y
 CONFIG_SMP=y
+CONFIG_VMSPLIT_2G_OPT=y
 CONFIG_NR_CPUS=16
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 5791953b75ff..b00789279f25 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -36,6 +36,7 @@ CONFIG_POWER_AVS_OMAP_CLASS3=y
 CONFIG_ARM_THUMBEE=y
 CONFIG_ARM_ERRATA_411920=y
 CONFIG_SMP=y
+CONFIG_VMSPLIT_2G_OPT=y
 CONFIG_NR_CPUS=2
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 79f8afe3a6bf..d145e448a6b8 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -135,7 +135,6 @@ config ARCH_OMAP2PLUS_TYPICAL
 	bool "Typical OMAP configuration"
 	default y
 	select AEABI
-	select HIGHMEM
 	select I2C
 	select I2C_OMAP
 	select MENELAUS if ARCH_OMAP2
-- 
2.53.0


