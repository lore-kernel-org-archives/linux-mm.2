Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C44EEC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6346B013C; Wed, 29 Jul 2026 10:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58EE6B013A; Wed, 29 Jul 2026 10:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D336B013B; Wed, 29 Jul 2026 10:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A85266B0137
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:52:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 670C34069F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:02 +0000 (UTC)
X-FDA: 85041736164.23.78C67E0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id C3F86100006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="poShl7/C";
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327960;
	b=nJRxf3iorrFP2WQ7LihRjU/Snidv5NyS9Ys6NxCqVNHKWNTv5gryNnvFTUj9Wid3VdZLnx
	PEHHk61IpDIn+OsnvF6Vj4XhiGIGbD7Nx7BnS90yztH8yN9nQDgS/KMgGdFr0+LPBsbp4d
	QXtvDSwXrv3XQBHW/5L+TeMR1Rq5kKI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="poShl7/C";
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37I4p+14SN67lJMhjI6MUIXQ+F4uqsps4FeFBf9DI4U=;
	b=JpTrRu0cMv9GhoO8FOVKYQzncIQWQvYXHOkjrLnt7G1sXrpFy3wae61sUqI99F3F6x//bQ
	xe5lbJ7nFh3Mgeuz2ApvtNlw6BGu1wfwrq2tLOa4hsKYS9CexQU8rTPkCbAPnu119Q2nB/
	cKSUS9cJkeQ0niOPin0hSMYcQTFuPOY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC3101688;
	Wed, 29 Jul 2026 05:25:54 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 554883F66F;
	Wed, 29 Jul 2026 05:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327958; bh=VTKBMFW5Mnz57QNJKTDJbWnOWHAX7bKlcJ+yuVcS998=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poShl7/CJFvntlzNBTkc2HuGtHJUex8MlV7gkWYgMmmlJN8I2OBQbXykyKN5DIW+D
	 OHTLjYq0R5BZYaWxX6NeT6vzvau4PY69vt1BCt/xZkFQDfPGegj9fGaSMdsiGoumwA
	 E4q/S0lXkRbYCJ3y5RhzJuQWXBHrb0+MwbrCXxVs=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/17] arm64/mm: Enable pgtable geometry for FEAT_D128
Date: Wed, 29 Jul 2026 17:54:47 +0530
Message-ID: <20260729122452.3797443-13-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3F86100006
X-Stat-Signature: tpkhjo7emy56ufa5bpwpohrh7oys6pqr
X-Rspam-User: 
X-HE-Tag: 1785327960-755590
X-HE-Meta: U2FsdGVkX18aEXmeNnINscJnEi7pol6qhL+eHx4ik0q1a+jadP28bzQu0LL6d3Op53o8iwoslhiWPbuAQZ/d6eZ+fQl6yqRqRswrxb3udUGywL4qxkpZsN4qY2iyn+OpaLQ8G2Q+qwYVgP7yRqJNtyAtIQED+sxt1UyL+rG/GRkd11BDl/UNpzrqzEVA7n5LPr9tee0nFxKvQewO5ZDZeXguoZbvSMy4wDDRvpNm+KJI6J7weaFDZ/myPOikjBmi9TwoyDZMKufOZb0XpaXxGYRFxMU2IWoA1EzMAbWMOiaScZ5Gucyf4/3JzyyuJ7OoenjBuuHGlpzF/f6GKjEVSDxGQtYfBK74+cilicS85RReRzwxnyMWS9xcOx1eV188qIWIj8WjM3n/pYs7nJDxuaFsN8Dhc7mwldJ1PV8WEPJvw8OA3wccgzpwr2i9paQD/vNmLVHB+G32bCdBclyYqlOmnkTIFxMP+WyCCkTwKU1dvQ3PoY54O12vJqOgv5oeBtWq9AOFkRkiM7PtcozlFT01JUcDBqnrH1zGF2+bg1pwRbQnObO9IQH0hGjK2rmcVixmIDq9Vjph2UrmNzicSrRsZRjPB+GzJzK+gWlm0yJeqpj5atTwzcQZnq1l5jyg6YCEqP1pb/t+y7iFelOxXYEcEPB3gcK56+9tuszPl8C/qEucT3G36gVDvy6aqWbd8RxOGKxQpI7PrrEJ9pnEktzOv/IFjW3+WrbJKeCwvyawgCADC/5LUk0n5ctHZoFutpuTpsczrGzC9+yDMNgRzEHpu1UQw2AQ+UAOhcLq9PCCT1F0kXOrgkyEGMBqpREFJy0B0tzRB9DcnzJHt9U6ae4ZKyIj0myJkZrz0NFfi5cxs55ne9XByLJZQNTmwELUShuELUv/y1UeIrDFybwsyfOzZdgahEOQlZeYQub07focMgYIsc1Va5NvylUHpUQ9lfdLsqKkbn8Qdfsrwjr
 5Zll/njn
 O+0GWPrJhb+OGyAO73uo6dNZoXqWmPjj1uJw+pwWoZGwJ2QV/PM8gGROw7y0XuRTr0G3MDXMBtJUI2uTcSlcgmkRIQtSrzBnJRjbdqSShvIHoSqQ8wNOJOmRDVzn6g+kqME46rxM306Qc1W2IiRnCHJ2UMOWZkmmtAZg0cttQqVm4rPUYFBkbOlHCtJyTHPBgKp1GO+g8J+Ukf0Oar4ayzEkzhgpChS5jl5lpOzzsII0BiHpER+vOcYfhuBGVrlaU9eEtVt96v5OmGMWNhEqP47deT+CuslpEncVypOuUwhzu6X0efEGeS4QurRvnVLOJFYgGeKpHRC9HT8QM2bXvxXisYMYBiRf0Ey6NS7mHaUKRRdBMvBPWdEsPVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add build time support for FEAT_D128 page tables with a new Kconfig option
i.e CONFIG_ARM64_D128. When selected, PTE types become 128 bits wide and
PTE bits are mapped to their new locations. Besides the basic page table
geometry is also updated since each table page now holds half the number
of entries (aka PTRS_PER_PXX) as it did previously. Similarly update the
geometry relevant macros ARM64_CONT_[PTE|PMD]_SHIFT, PGTABLE_LEVELS, and
PTDESC_ORDER.

Although for now config ARM64_D128 remains disabled while all the required
dependencies are getting created in subsequent patches.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/Kconfig                     | 37 ++++++++++++++++++++++----
 arch/arm64/include/asm/pgtable-hwdef.h |  4 +++
 arch/arm64/include/asm/pgtable.h       |  2 ++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919..8459d43afd45 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -283,14 +283,18 @@ config MMU
 
 config ARM64_CONT_PTE_SHIFT
 	int
-	default 5 if PAGE_SIZE_64KB
-	default 7 if PAGE_SIZE_16KB
+	default 4 if PAGE_SIZE_64KB && ARM64_D128
+	default 5 if PAGE_SIZE_64KB && !ARM64_D128
+	default 6 if PAGE_SIZE_16KB && ARM64_D128
+	default 7 if PAGE_SIZE_16KB && !ARM64_D128
 	default 4
 
 config ARM64_CONT_PMD_SHIFT
 	int
-	default 5 if PAGE_SIZE_64KB
-	default 5 if PAGE_SIZE_16KB
+	default 6 if PAGE_SIZE_64KB && ARM64_D128
+	default 5 if PAGE_SIZE_64KB && !ARM64_D128
+	default 4 if PAGE_SIZE_16KB && ARM64_D128
+	default 5 if PAGE_SIZE_16KB && !ARM64_D128
 	default 4
 
 config ARCH_MMAP_RND_BITS_MIN
@@ -361,6 +365,16 @@ config FIX_EARLYCON_MEM
 
 config PGTABLE_LEVELS
 	int
+	default 4 if ARM64_D128 && ARM64_4K_PAGES && ARM64_VA_BITS_39
+	default 5 if ARM64_D128 && ARM64_4K_PAGES && ARM64_VA_BITS_48
+	default 5 if ARM64_D128 && ARM64_4K_PAGES && ARM64_VA_BITS_52
+	default 3 if ARM64_D128 && ARM64_16K_PAGES && ARM64_VA_BITS_36
+	default 4 if ARM64_D128 && ARM64_16K_PAGES && ARM64_VA_BITS_47
+	default 4 if ARM64_D128 && ARM64_16K_PAGES && ARM64_VA_BITS_48
+	default 4 if ARM64_D128 && ARM64_16K_PAGES && ARM64_VA_BITS_52
+	default 3 if ARM64_D128 && ARM64_64K_PAGES && ARM64_VA_BITS_42
+	default 3 if ARM64_D128 && ARM64_64K_PAGES && ARM64_VA_BITS_48
+	default 3 if ARM64_D128 && ARM64_64K_PAGES && ARM64_VA_BITS_52
 	default 2 if ARM64_16K_PAGES && ARM64_VA_BITS_36
 	default 2 if ARM64_64K_PAGES && ARM64_VA_BITS_42
 	default 3 if ARM64_64K_PAGES && (ARM64_VA_BITS_48 || ARM64_VA_BITS_52)
@@ -1540,7 +1554,7 @@ config ARM64_PA_BITS
 
 config ARM64_LPA2
 	def_bool y
-	depends on ARM64_PA_BITS_52 && !ARM64_64K_PAGES
+	depends on ARM64_PA_BITS_52 && !ARM64_64K_PAGES && !ARM64_D128
 
 choice
 	prompt "Endianness"
@@ -2233,6 +2247,19 @@ config ARM64_HAFT
 
 endmenu # "ARMv8.9 architectural features"
 
+menu "ARMv9.3 architectural features"
+
+config ARM64_D128
+	bool
+	default n
+	help
+	  ARMv9.3 introduces FEAT_D128, which provides a 128 bit page
+	  table format, along with related instructions.
+
+	  If unsure, say Y.
+
+endmenu # "ARMv9.3 architectural features"
+
 menu "ARMv9.4 architectural features"
 
 config ARM64_GCS
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 72f31800c703..1ee1a6d9db6d 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -7,7 +7,11 @@
 
 #include <asm/memory.h>
 
+#ifdef CONFIG_ARM64_D128
+#define PTDESC_ORDER 4
+#else
 #define PTDESC_ORDER 3
+#endif
 
 /* Number of VA bits resolved by a single translation table level */
 #define PTDESC_TABLE_SHIFT	(PAGE_SHIFT - PTDESC_ORDER)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 50d673474f47..ed5ea7d31c0a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1128,6 +1128,8 @@ static inline bool pgtable_l4_enabled(void) { return false; }
 
 static __always_inline bool pgtable_l5_enabled(void)
 {
+	if (IS_ENABLED(CONFIG_ARM64_D128))
+		return true;
 	if (!alternative_has_cap_likely(ARM64_ALWAYS_BOOT))
 		return vabits_actual == VA_BITS;
 	return alternative_has_cap_unlikely(ARM64_HAS_VA52);
-- 
2.43.0


