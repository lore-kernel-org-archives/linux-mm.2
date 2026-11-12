Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5338606B347
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JETWMfWj
Received: by kanga.kvack.org (Postfix)
	id 7AE656B05CB; Thu, 12 Nov 2026 06:26:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E9A6B05CC; Thu, 12 Nov 2026 06:26:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69D006B05CD; Thu, 12 Nov 2026 06:26:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39E3F6B05CB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:26:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA3734054E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:25:59 +0000 (UTC)
X-FDA: 85426237638.27.165CB2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E834520002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:25:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JETWMfWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FD/V4+e8O0iqTKVI3Ylc4RORwqMbtboEEa/TKhMeE7M=;
	b=sGwGNb7yA4qn9C4KxheCqDZFLixoXZ1wSJzszZehaA0wrafMYTAlkAn3P8PjO6Kdhe0Prk
	fw4WFBhpmjxPaEqlLE5sdqyj5Bio9OZJcnIqS9UFM4tSbEPDTbqLxvbv8fLJv91AtN8MN1
	Qf/zkunm5s1LO0DMebEJkkXCz16rrvg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JETWMfWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482758;
	b=7yblQfu1yCF1h18/Rw7K/gjKzQUAOQIJPnX7sXILYu66PlJCYCHCtQ3HAINBS0DJ5EkCNR
	oSoldlkqu3847FshgdwtyP7lf7i/rP83JfOhushDUVUyYpBy1cu488GEkTS/cPkfwo88uz
	k7975CDZXy+BK6Yno33B0ceckSYvLKA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D21247A1E;
	Thu, 12 Nov 2026 11:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662A91F00A05;
	Thu, 12 Nov 2026 11:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794482757;
	bh=FD/V4+e8O0iqTKVI3Ylc4RORwqMbtboEEa/TKhMeE7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JETWMfWjkKeINJWiPkhAD/QsItp30dH2rFFfUxvvsc0JyhM1taj1AERUtJ/N3Cjs3
	 AwYVFzZ/m6zQ7KYBU+YiTIl9hTHpftthT74h5Nr4oeuYEHYYSiIf3AXVs+RKZKKHrV
	 mIOmMwkG2K3nP1x7rGrbfTQKpZOVBqfxi9f/LcxqS5J0K6eBwmu7A8mogUZQyc4cgy
	 znPGEVxp9AgLlfDVNExZSLItcLclY123hZKVh9JoHVE3H6OQiccRm+Ibc4Tk7V2+rw
	 AM4h3/ZJfG+Yk80QegP3t50LRsE3vQEfEM9YcerbVpZJF++E9cU7QgrbnSemDfJFmG
	 qhJVBLKkuZ+CQ==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v2 3/6] ARM: drop CONFIG_HIGHPTE support
Date: Thu, 12 Nov 2026 12:25:25 +0100
Message-ID: <20261112112528.1116405-4-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112112528.1116405-1-arnd@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E834520002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 36s7xhexywriwq5m6p1orx9j8iwbqw57
X-HE-Tag: 1794482757-956636
X-HE-Meta: U2FsdGVkX19KUkcswNWUIq+gJD3VyjigCCsaPaV9Orkd2yn1I874aG0jvMQ9AV7xtQ8RPMm/jpszK6Qa66T7cAmy2/M48xuKn3WY1wt5jqTd4F9D1qH/Xo7qlix2WwpJh0qYDam7XXhfCjeumOT7xOVX0RHvRMuvuRTyiR/BomHWRSuele97NPYhHeTiwWucAvTF0ntePU/xO4W4Zzxu+E7LhY2IMveFNxA04WdDGGYViPRoqaq3cLVjaSds6ijxzcvi2sXW/ypm83GkKThBP5rofmbkyMG+QGvsdGbYS1olhWY20ycm+FnSv+ANQ9SHmsjO7Xd7n63QxifAwHwncDh0Y5CxFOMOKTuMIQmFrxQaHVlImThyrZ1LcKrGpu1/o6llvZk463zBmwpUAVNPCcRz7m/LOMFF1ur6spBE2J2yySmhtED4STLUGGfnBiOFrqAD2z9YnoPNV3bW00mjNXvpw1LGj+wAWEQwR4vjaWe7y5NpWI02RR/35ZwlECRz4B25CeTNKaCkbSo7ub+D9OJL4ZnQ9zy5kXqKzTnDkarO6LH0v8nm1Kqe3kE13zs83RSwc6iQTCO8nDfngj7G07+cTE+LY2YohLzYDMR6Xv+n1yyuI2W9c7wEu4zIkuzMhgZIez4ETcUP8yyfoeGtpm6S62M3FZbDh8GESDQzwC65RhK8G1SaHtSPT7P090KRY54xvIFnYMsNpt8W/goNOw1WiEmslS8igc79rhR/Txmyq+JmpC6v/UiCfiNJesh6gr+n47pKBxlgpb1LEC7PjcBfrOGccrMbT5rriWm3Ce0Cfsa/aoBTNn/+z/fwVEDzy9CtwF/AOlrzfR5MYmP76rBil8mLTCiUMehdAxRUlN06ktDCWC1vBO1KSdyH0x1WDsjhks5CIXug6FNkz1T/hgpbiPykim+ILvDLLfDgk55fN2x84JTB2iVEVXY16aewfA+BP4aNNVRYfrgVGz/
 ua2y+80w
 anAD1kBMrA9a8zXZlzhaZITyn/f7d1BXhxaCui2DWOiq150WhMWdafiJiTIu4GhvcNAslQekDgPDfxH1KD662Ov1mL9HWqTHIAQc2QSXCHwOn+dSgQx8u2FdBy+y9Lx1PpOBbriKVbwGP3aBN5TyHWXmIjqI/EWpwJr6YIBTbFN0K4vjdxf3eopnPY6qbXRndde7jiHQAVLgi3wiHW3jsent+K0NVvloGuS7fnJqCn2szBIK5gpfUk2sQmW2n3dSYx3EE+5L9nC02KniCbOdddXNfdtUqnk5e12mA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

CONFIG_HIGHPTE was added in linux-2.6.32, a few years before 64-bit
support. At the time it made sense, as the CONFIG_ARM_LPAE option allowed
systems with 16GB of memory that made lowmem a particularly scarce
resource, and the HIGHPTE implementation gave feature parity with 32-bit
x86 and frv machines.

Since Arm is the last architecture remaining that uses this, and almost
no 32-bit machines support more than 4GB of RAM, the cost of continuing
to maintain HIGHPTE seems unjustified, so remove it here to allow
simplifying the generic page table handling.

Link: https://lore.kernel.org/lkml/20241204103042.1904639-8-arnd@kernel.org/T/#u
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I sent a patch to drop HIGHPTE support on x86 today, see
https://lore.kernel.org/lkml/20241210144945.2325330-9-arnd@kernel.org/T/#u

If that one gets merged, we can merge this one instead of the one
that makes HIGHPTE depend on !PREEMPT_RT, but if we decide against
the x86 change, then we probably don't want this one either.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig               | 11 -----------
 arch/arm/include/asm/pgalloc.h |  8 +-------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fd01ccab9c12..fc66d52d847e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1225,17 +1225,6 @@ config HIGHMEM
 
 	  If unsure, say n.
 
-config HIGHPTE
-	bool "Allocate 2nd-level pagetables from highmem" if EXPERT
-	depends on HIGHMEM && !PREEMPT_RT
-	default y
-	help
-	  The VM uses one page of physical memory for each page table.
-	  For systems with a lot of processes, this can use a lot of
-	  precious low memory, eventually leading to low memory being
-	  consumed by page tables.  Setting this option will allow
-	  user-space 2nd level page tables to reside in high memory.
-
 config ARM_PAN
 	bool "Enable privileged no-access"
 	depends on MMU
diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index a17f01235c29..ef6cb3e6d179 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -85,18 +85,12 @@ pte_alloc_one_kernel(struct mm_struct *mm)
 	return pte;
 }
 
-#ifdef CONFIG_HIGHPTE
-#define PGTABLE_HIGHMEM __GFP_HIGHMEM
-#else
-#define PGTABLE_HIGHMEM 0
-#endif
-
 static inline pgtable_t
 pte_alloc_one(struct mm_struct *mm)
 {
 	struct page *pte;
 
-	pte = __pte_alloc_one(mm, GFP_PGTABLE_USER | PGTABLE_HIGHMEM);
+	pte = __pte_alloc_one(mm, GFP_PGTABLE_USER);
 	if (!pte)
 		return NULL;
 	if (!PageHighMem(pte))
-- 
2.53.0


