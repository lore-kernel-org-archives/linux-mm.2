Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5C6606A337
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fFzBs088
Received: by kanga.kvack.org (Postfix)
	id 9DABF6B05B2; Mon, 16 Nov 2026 07:48:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98B146B05B3; Mon, 16 Nov 2026 07:48:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8916B05B4; Mon, 16 Nov 2026 07:48:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF7C6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:48:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA72F801A2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:48:55 +0000 (UTC)
X-FDA: 85440961830.01.75EF48F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4DF15140009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:48:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fFzBs088;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3qZ4d2EoZJBj/rnIT9ZqfnQg+sRwjETd54Rn6zh5+0=;
	b=u/8HfEztfe6Zdj+1wy5vpnXlm0fnB2HIaTwmDK5o9l9lclUGLm62G3y6JR1NeCXfL6eJdw
	HmB6d8VWakpK2boqlT1+BO4xWxYcCPbGihhFtqre9hOzli8ZW28TqdzmucbXhKcXKrIWYq
	3vaPaYP35FxGiyQfxuZjwS6xH+CefB4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fFzBs088;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833334;
	b=CQX28s4fvdFh3iwwFh9VhToc8gOq8aqu6A01wRehSZ5F4hDWPj2NZlusFrwhHhZx2sy9f4
	su5Pk5QYy98HBZjU52xkB5XpCn/bwQoiBsato8SxARMUqXOf7FpzmV80WBnfF+cseiPo3W
	g1s/sc5tCldCvbVbsfyhMG3F8gWJ3OQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C114A6232C;
	Mon, 16 Nov 2026 12:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC6A1F000CB;
	Mon, 16 Nov 2026 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833333;
	bh=D3qZ4d2EoZJBj/rnIT9ZqfnQg+sRwjETd54Rn6zh5+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFzBs088shoTy3rQRvERnUcPbLSDcUJs3516Kbm99pGIrHAGI+mzI+Fjroy1FZoRR
	 SLSxvUR24Ur9ZMnFUaeM6262CXVoWN+NN6FX3EIesA4PFthJY3GJ963+oBQQcnI5+X
	 CxF7nKZzUvWmnMkXLlJ9xJTVUsMKwtlsaRKBJYfJqHGajc8KhKS8Zw151NxBITLk11
	 3f3u+37vYLIpx96RN2dwX3SMGSQ8S06BuVxY5BqJzeFXIzW4GspoVOEMp6v36vSW7x
	 txORGSJshkejNfxqwzDAw5iWblqJrgB37F54/PpRUDzR1w8ESpUpWt/STu40kxByij
	 vtGN4WXjhlbeQ==
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
Subject: [PATCH v3 02/10] ARM: drop CONFIG_HIGHPTE support
Date: Mon, 16 Nov 2026 13:48:24 +0100
Message-ID: <20261116124832.662455-3-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116124832.662455-1-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4DF15140009
X-Stat-Signature: 1qksq9xn18y51drc67oys4aq3epditqp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794833334-390992
X-HE-Meta: U2FsdGVkX1/yEN7dftnXanFbZAcDOw9zsQ+slsfPBFuWCiIMTUj0NXgx0KqOLqs+GB9BZ+W9oLRms4twiYjE9mj69fyXb8ooX9qP9QtEnnmKHXSH/kULd3lN+/+gMXnnzB2pM+csS/q1661+1bTkIA0Isr+DPuE2ETGS960ILFWnm4l13IRCYBQhMw6hhkhl4TLUQZMTldPV2aRA2yzBvdiJ6YXZjZe3j4iIB0GpvPY7Lr1VTt+UBCHUb6ECtFvjWJipG4hMK81oMIkaYTk4p76XY9ETIJbiSjTtiP3uh/yV/DZIXh4xXNBGPirzRacvj8dE5ZeX1IiWj3Hi1pXY+/B3LA78PtVOJTBMdxJvG2AAPqRMyb4zYh2v3veZrE+bFkUfSJPOBOmbOxSY+EBlhX8GuuDs9hibaXDMOiGA9L/SxpU21b8Vgv0ZxLYZriHWLTNFPwrAggGAdrCCCnlRGgQwRRhawcq7SvOb24lhi8D1bvzBeY0EkO5CHWEETxJvlE2hzXYXkroe7ZIDDwF9eyMQTcm+G352EsNmrymnPAohIiMpcEc/EAn8GYbH28LhBQo3BfWF0Zs0YvkUGbLCuQy7YGqVCUgR4SBEh6/Tt4ttDAFckUJQs7PYmmM4V/K8zu7A8M4l8bYRi6jFzRltTIs7Cp+JEngBiME4LjL8D8ubbEZ1UEve7wdM6o0MhnRkko2RfLd3+ULCL+NdDGC1JDCAIi08oS2a9HqliqOQE/8NXFZjp5Ay3ZhpzxFwADvj2iR8NVJYNot2T2wlQXXBBFBU7p+zrmQSAjVRqXj83HFAfaQJhTYg0Svjp70YnFMJvU0fyqtqzn5dMdpZrf3nCaSwpzPsN0r9z4t4k89pvbwFR1J2+hWw9iuqTuBYKW/k0lLY4a9aHP/h9SsEjc4s4ithY4E6oAr3fqpKNdS2REB1FWML8m6ZbudS/ULvB98sJGqS6EmIYPG5qm9a7l3
 2I09ceke
 03Ks3piXyZ0E3aRvQBPkal6sCDOHruJRN2Vu+BfzqT1Srnxldy+E/2roeZw3GITjjEcCWZi1Cb9OypLdNVVvGRXtP7boKkeLFWd7PxBmVofU4efBVdsBn3Vf5MePADMeG+vguHnAUl4wyCDwJC76T2fGe6Ok4ZGBac33zaysB/fwY2D5BPcW9SaQJ1FDwL+NnGr/jOUPeVxR9MPh4PCrxxt5drF1/3UG5WuvJTlTQPDx1MHxqFHtO2kRC1gST1mDyM2dbRQinnezuIclnephw4PvqRvblAV4wFAQ4
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
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig                        | 11 -----------
 arch/arm/configs/vt8500_v6_v7_defconfig |  1 -
 arch/arm/include/asm/pgalloc.h          | 13 +++----------
 3 files changed, 3 insertions(+), 22 deletions(-)

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
diff --git a/arch/arm/configs/vt8500_v6_v7_defconfig b/arch/arm/configs/vt8500_v6_v7_defconfig
index 2925a1f1dbb6..33a81c5a84d0 100644
--- a/arch/arm/configs/vt8500_v6_v7_defconfig
+++ b/arch/arm/configs/vt8500_v6_v7_defconfig
@@ -9,7 +9,6 @@ CONFIG_ARM_ERRATA_754322=y
 CONFIG_ARM_ERRATA_775420=y
 CONFIG_HAVE_ARM_ARCH_TIMER=y
 CONFIG_HIGHMEM=y
-CONFIG_HIGHPTE=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_VFP=y
diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index a17f01235c29..b01d817fecf3 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -85,22 +85,15 @@ pte_alloc_one_kernel(struct mm_struct *mm)
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
-	if (!pte)
-		return NULL;
-	if (!PageHighMem(pte))
+	pte = __pte_alloc_one(mm, GFP_PGTABLE_USER);
+	if (pte)
 		clean_pte_table(page_address(pte));
+
 	return pte;
 }
 
-- 
2.53.0


