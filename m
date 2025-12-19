Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 647D0E66880
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75386B00C6; Fri, 19 Dec 2025 11:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15946B00C8; Fri, 19 Dec 2025 11:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C8F6B00CA; Fri, 19 Dec 2025 11:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96B2F6B00C6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:16:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DEABB729B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:16:50 +0000 (UTC)
X-FDA: 84236724180.06.317655C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id CD79C1C0012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:16:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cu2dCyJi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766161008; a=rsa-sha256;
	cv=none;
	b=7Ok/X1684j8D308SEtqPAwQIYVpmXZxE69Yz2kZ+6yP4L++9Mz9VZ0DifqmS6h0scs6l7/
	W2XQXO1olG9T2tDasT+xIlVf0CNoODZr0xqcxh7QIh0cgTDVw3fcNW9XcflEP5X82GCQJE
	OUG1Wty00UTPrtOQObWtS4u0+gNx+Vk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cu2dCyJi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766161008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01cMqftZsswJxQ3FrQQhcZuowTNtnEI5y+kOuc6pxjw=;
	b=OKGGHiKdp8JRALrUOL+jr4XtQITLknXMOgHyZTU3V4YpmG0BdiTPAoN+OI5hGUOvmF8UwT
	Cz4HihMbTxe7l779noUDKL5ytS/AncErjc0RhqQ5DetR+ilWOJwK3m+qlvmPRKCuwWCTMY
	2+F1ftGiiB2z6zO8asGTV8lXtME7L+o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 030AD41A3A;
	Fri, 19 Dec 2025 16:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9ACC4CEF1;
	Fri, 19 Dec 2025 16:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766161007;
	bh=47hL5I2ijXMcmF1JU7EI3Nhpa9ZQCp3egcgt0wmJuoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cu2dCyJigvnIJ4mGAhXUE+8LQLSdMxxsf9j1n6iwtD4VW3+uKb8f1+ydeAa7BQ8zQ
	 S+h9zdfukpR/1sKyw8Nv2b86nr52SGY6JZoNsmB5Wlxv/HpNKUZ1oXRuc0+whL4nPQ
	 n8M07pw863419mdts5E4xVdf+QQ2GL+hgz0UuwBsKdv5/oe1ChTaWfxhmL2BLv8sjy
	 7Ck7DTgFi+BX8xgYCywqy7IxdyCa5XadbES2il8LMaf0eu342WX+CZTNt8Tb22655s
	 bKaqIzztqrF73J1cLSW9sVWu65aIlAguqbxhWwd5aHrU7UWeTQGhofmrZ2lJaFtSVA
	 ZF79v11xxcRBQ==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Matthew Wilcox <willy@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH 2/4] ARM: add CONFIG_VMSPLIT_2G_OPT option
Date: Fri, 19 Dec 2025 17:15:57 +0100
Message-Id: <20251219161559.556737-3-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251219161559.556737-1-arnd@kernel.org>
References: <20251219161559.556737-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CD79C1C0012
X-Stat-Signature: 1f1ywoucs5m11xa78rg5zmjbjcqpc75c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766161008-407367
X-HE-Meta: U2FsdGVkX18t5wC46lkg6S5hIErdw3G2NGmc/dr+lEzNZFldKUslF6Tsm2bmFaU2sRigaYznIBPOg5o4BQLVZB5kSeCfbxeIGiZCeEKkRD5j1H7nOzMXNvOWfTMiWMSjZkXjEZXThWD0pV/UW2glNHhQFtNUl36hWSlTTp2zXTFzH1Ib7fB6Giv1F1/zFVR4/qgmcgr+1PyKzSVAos0hjsHQKd+ykd3WXHKMb1n5sxrtDMvndTmgSXiD1ajv4vmRsUHaGPwj7lwTukn1rNw9mJemVjB/ukFYxa1lnfTtVmWZbPhpjlaeMeVuBFOdmqxE0Gb4YpzHnO5ldL1VtgxxU3H2+tH9QwHvvr3AYLHvwuQNIaMltb2+5uBM5DOnI7K25p5UDySFMTuFAycVn8CQ/OBT4g5Sa+dzmrEcF++XRHak2NuUaM2SkuWH83r1TKb3n2b43hfLSRbcTfn278RvtLKhZTPJDS8oV8IB+3ksDZsKHvaNrpDulKOqU8lqCbCDtgL15ds/TnRm0b7OJTnsIJ69CB2AiGYYB2ja+Nwzz4TAZmws0ZvoQaLFheXza/JHfRWSBsPUwkGCkK+v7p0wpv44JcALyJTPNiQ0ZSvKJ+5W0Zz2TXWICWN+LYqkE1UgMrqg0Iized/1MyaJgI1iln216iyznz7xueZmYyEgyrb3JSRpqaUnu05uTRtGiZSNm4Z0P//hvk4S4VTPnopXWgSIJe/aEv5fB7f0diJJTh/wfCzokPKvEwn2hUoV9N7WrZl0KGdhZnFDUqoqv10/ET+cd2VHm1HIJ6zLlAJRn7BDKphnolkUEoXVSh9nBJIGl03DzbWPTglOq2uP+vp0DlwMpoo54Cxkxp2v2E597PlI71yNL/bu+haEh6zv2igvx2KPvPToB6LrweV5Umdx9AMoCbFOqoACQQI/1i1gjyu6Y/f6339L6YqxVpHNCQ4bbRrKujykppp1Bhc4I8K
 6mGV3zDF
 +ubYG8yM9aK37iZcbCekiadOd1FfJXGUvo6MEFPaWDvGT6pDJ1khIms/QpTDjGWHLunMA/vPK2O01QlcGPCMRlQ5YF59DcDBXeMVmY2ZSFSjwXC8OVbITHGNW/8HwNy0HHV1oqmKFFLX5e2Na+dS5rbM/MKZUyNt7pYt94Aj9plcCJl+akgXKPBdjz4d9HAKbxbxquipMXiOPBVBEDTgTpcM76LIuQHjpS2i1CZR37/KRZpBLw+dXCZqqj4LJ35XgHYGP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

Unlike x86 and powerpc, there is currently no option to use exactly 2GiB
of lowmem on Arm. Since 2GiB is still a relatively common configuration
on embedded systems, it makes sense to allow this to be used in
non-highmem builds.

Add the Kconfig option and make this the default for non-LPAE builds
with highmem enabled instead of CONFIG_VMSPLIT_2G.  LPAE still requires
the vmsplit to be on a gigabyte boundary, so this is only available for
classic pagetables at the moment, same as CONFIG_VMSPLIT_3G_OPT.

Tested in qemu -M virt, both with and without HIGHMEM enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7c0ac017e086..921ea61aa96e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1009,7 +1009,8 @@ config BL_SWITCHER_DUMMY_IF
 choice
 	prompt "Memory split"
 	depends on MMU
-	default VMSPLIT_2G if HIGHMEM || ARM_LPAE
+	default VMSPLIT_2G if ARM_LPAE
+	default VMSPLIT_2G_OPT if HIGHMEM
 	default VMSPLIT_3G_OPT
 	help
 	  Select the desired split between kernel and user memory.
@@ -1026,6 +1027,9 @@ choice
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
 		bool "2G/2G user/kernel split"
+	config VMSPLIT_2G_OPT
+		depends on !ARM_LPAE
+		bool "2G/2G user/kernel split (for full 2G low memory)"
 	config VMSPLIT_1G
 		bool "1G/3G user/kernel split"
 endchoice
@@ -1034,6 +1038,7 @@ config PAGE_OFFSET
 	hex
 	default PHYS_OFFSET if !MMU
 	default 0x40000000 if VMSPLIT_1G
+	default 0x70000000 if VMSPLIT_2G_OPT
 	default 0x80000000 if VMSPLIT_2G
 	default 0xB0000000 if VMSPLIT_3G_OPT
 	default 0xC0000000
@@ -1042,6 +1047,7 @@ config KASAN_SHADOW_OFFSET
 	hex
 	depends on KASAN
 	default 0x1f000000 if PAGE_OFFSET=0x40000000
+	default 0x4f000000 if PAGE_OFFSET=0x70000000
 	default 0x5f000000 if PAGE_OFFSET=0x80000000
 	default 0x9f000000 if PAGE_OFFSET=0xC0000000
 	default 0x8f000000 if PAGE_OFFSET=0xB0000000
-- 
2.39.5


