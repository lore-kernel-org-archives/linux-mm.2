Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB40C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4AD06B00A6; Sun,  6 Sep 2026 23:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB176B00A7; Sun,  6 Sep 2026 23:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C706B00A9; Sun,  6 Sep 2026 23:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63DCE6B00A6
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:51:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDBFC160690
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:03 +0000 (UTC)
X-FDA: 85185590406.01.E39E40E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 191E2140004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fl8VqLvm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLxnyG2dbvc/QV1X8MTxe0+N1cXi1qBEfSgBEC7WBcw=;
	b=LCjG84GVkblMH9c02sg2+kN7aLyY5k55MpHr/aM9nc3cMARmlZvHr3GT6a3rjE6der1rXD
	Cu4hShVEaUGXkvyQdekPygtJzG2YUbwAN4eBWgk2R2+cXAGqNIyUimHUT5Pc4qE0U6mrX2
	gQVjRiWZEBUhiaiXjssoUvF9FZjjjdw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fl8VqLvm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753062;
	b=gTzkvMuN+a1YgZ/wmKEai06rk/tOcM7qqnhHbQpfHVp3w9B0NvQ3sSIc3OTjbwYcty4lu4
	KENvNJwu4cnDiTI+c74UQYxIEKW0Hgc6RXnBBWoj+LbWCrTLCXOMfcI/erat5/LLw4bOmO
	9AxrdHrxk9UVfZFpqhwVJxL6i9RSunI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FD881477;
	Sun,  6 Sep 2026 20:50:57 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7793E3F7B4;
	Sun,  6 Sep 2026 20:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753061; bh=6wa5MsZMcn+Z3nxdy5kbv2HZNFuqAlAuRxAc1QrQTkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fl8VqLvmTQZwKkcHorxP+8qDbRaaOF5rpdgiICuln2/D8a52ywJZ2eGm7xYrWI17b
	 lPolpJsYANXrx5502C20P7O6olCTgsRw8X+lqFvgMPBR7Kq/CtPR4KZhbgShkCAeNg
	 832RVk5IAZkPgsN2eikujbI3fztFJ587Xr01fJzE=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 07/14] arm64/mm: Enable pgtable geometry for FEAT_D128
Date: Mon,  7 Sep 2026 09:20:22 +0530
Message-ID: <20260907035030.2839978-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nrr8hht1k8jh31r8zyqmtobcufm8bqqh
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 191E2140004
X-Rspam-User: 
X-HE-Tag: 1788753061-664624
X-HE-Meta: U2FsdGVkX18DupALhx1xpWh4boXQla7/VqYFodVOr5mbme/ldG9nlYUqO45U+2yStUidxeXyzhBFifJwfW5QjJRu1Ow43VrVXtHuFJB/fC2RjsBcdTdbsBXNWng+wSU3K+ri80YrdUd69FVQkW54HOSwuC6YFrrzTuWeTZSsgGS+V46QE1k3tSZDVVhodTu3mJ64s8PYQrdzR1MFe4gAs94jwLfgkHQZK1M1RziHiTERTA25QHPiTkFIn2svRsWDC+oq4iVXHC7uVkjZhsvjumiIUQt8lFL9/O3O0KyCN7ftzFnuj6Mmjq3HaHC2RgbxW+CL50fyT0dLT8dfxYm/lvLKftRNT+xFiPouR396gaZD8YGWTitCJ1AHpkyQGdjnZeJRV0VjHqzDG3MERBclRJPRL48+k26t+wnXUO0OaaXt1eJgAhoK4VUV3J8Ap59nNAIG2OV0r1yZPiYrUx//IeFB8RPK6AQ/L7AzICxZzoKNMGOcIzPefb4H8TN2J/wN2YyeuPDlvRe0OVoRGnXV4WgFol+lN+jGlgveFu0jH9ZqtSZ/21yakEK2p+sNz0n545RRGL9fA0xgM4cZ9LlFluelFIY7c/UK0xRFxeP8+Ma9nAZbHjguK22VDgrU18Xdpooc8tHg04uk4O2tclF/yzoorDbbW2cP7ULtt9hDAuPI1y5QXftD8clBi5dMzg/32TsT9knVewRl7OaViWHKfzYjObNGqA2GNoVU+zURDW0yL7TZ+F83QCyn+99qlorVL40+JiUZlkOTugGSDwOIJ4TIECgb3cl2Rs/59Cdx1PXi8ChoGgRsjNlGkFZrKb18oTgpBfHPCtyqOxuZcB7VEjbAZA9rlxC+U8gtY3fxFN3w6dNm6hShqSVqvB39V1zm9iwDI+YX2DrzPZTy7pJe72QbqbeQ/U3KLIIS6RKS/zI2Egf6lAYI5h28fuT+DK/VdoEuFxOF+cEnJtuWaAV
 hcNXJ1Ly
 6D9MXeJIEpPlSMtPxTaROp6cBEjZiGBnvyqiIt+CKLF3CljCtO0ngDS3sz6V9jr+zhrn1IxZgB2/9K97iSodzxQm59WvLOT1KlbB/bBgth99UokS7CnDX3+xeAc0fpGdOMzBdAYLyI1xwbPT3RSFUkgFtcGMqY0f9e8DuM/H7k+9mxHyLgd0itmU9qLzYBTyIzsJbLNIRezAVea2nnziBXXdoM2SnZ4DufLqI5rl5hINtSblm50GtdE7Cvly0FTRnUDVXfxifDUXGSV1lNu/ur8174m/u2EL28VaIf9oW3D2BYZ/sLqTz7kprr58CymrfpP+8bGNilYUq7+LEedJtXNRnGgTPCBB753H9ZA3q55f14EISidpO9hXsHHY+i5xoRMVzFVv4/kVf12eniOtBgk2E3GrJhxl32xQw9CsLsXi1PTo=
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
index b5a51b0ef944..306e6c803471 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -284,14 +284,18 @@ config MMU
 
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
@@ -362,6 +366,16 @@ config FIX_EARLYCON_MEM
 
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
@@ -1594,7 +1608,7 @@ config ARM64_PA_BITS
 
 config ARM64_LPA2
 	def_bool y
-	depends on ARM64_PA_BITS_52 && !ARM64_64K_PAGES
+	depends on ARM64_PA_BITS_52 && !ARM64_64K_PAGES && !ARM64_D128
 
 choice
 	prompt "Endianness"
@@ -2289,6 +2303,19 @@ config ARM64_HAFT
 
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
index 7a5d6a14bb52..4b534be3f288 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1075,6 +1075,8 @@ static inline bool pgtable_l4_enabled(void) { return false; }
 
 static __always_inline bool pgtable_l5_enabled(void)
 {
+	if (IS_ENABLED(CONFIG_ARM64_D128))
+		return true;
 	if (!alternative_has_cap_likely(ARM64_ALWAYS_BOOT))
 		return vabits_actual == VA_BITS;
 	return alternative_has_cap_unlikely(ARM64_HAS_VA52);
-- 
2.43.0


