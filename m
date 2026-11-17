Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AEA4606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Czs8bkSq
Received: by kanga.kvack.org (Postfix)
	id 2C9AF6B05B1; Tue, 17 Nov 2026 02:06:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E976B05BD; Tue, 17 Nov 2026 02:06:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168446B05BE; Tue, 17 Nov 2026 02:06:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA3066B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F24FF12037A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:51 +0000 (UTC)
X-FDA: 85443728622.20.DDCC091
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 558E9180002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Czs8bkSq;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899210;
	b=24jWHJ0VbNY+xO+qC3jg7dOw8Xdbv2TN+C96xazWctSm2rE5ztD212HQP7Ik4fZr3O3R2Y
	TX8yIta97q04o0NrEvJ7GCVAdiD2AP+nzU7AHVBg12r9CbgCE/rBVsAwImaC6wRDpT8UNf
	7NNpa+OAQWpIrtVqWWbEDalZtkE3drI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Czs8bkSq;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPqr0Kb8/zLLbXQWePyEB3+zBFb98bC3Fi1OiT7G+kU=;
	b=Rc+B+VQN3qaEIaTflr1cbNd5KjKPVIiEdSZ3CYUp+Kq4WGT7xgsJQs6z8IlKAyXkAoq4Dr
	nTGX1JsLkIgfq1IONtIGGzfb4lxdzSYlseYOqTrtqtqcM6MV6yXNyp+oilUiBNeGRYMraZ
	1rx0Zu2/rdN06o49Z6jphEPCo5NZ8do=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96D341476;
	Mon, 16 Nov 2026 23:06:46 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE8C53F882;
	Mon, 16 Nov 2026 23:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899209; bh=gdVTWnm9aG0Cay0F+b7IneTsiFz5Oxc1mfFiGUFXEI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Czs8bkSqNqmqyO2k1vt9iXnL/MSq8J6IWx3r/NJZX2lBiySrLwt/TzpnkKIi+/54U
	 hXrfGa5FnQri67gW6m2wltZcur5mrhKJ0wJ2fBZCiHI85naU0rHtAXsW8lxjtWFD7l
	 13kHnuQKOelzKd006uSxoYMQkGbixqev7KKCg2SU=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 07/14] arm64/mm: Enable pgtable geometry for FEAT_D128
Date: Tue, 17 Nov 2026 12:36:06 +0530
Message-ID: <20261117070613.1183243-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ih4hkt1yfx9xkkwwyjn8juiagxuqa84b
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 558E9180002
X-HE-Tag: 1794899210-337265
X-HE-Meta: U2FsdGVkX1/nPQBkjg8WtaSLksYXJyB77zJRewLEQo5wu3yLWyRijAOTknY71CdvSV5ewVb5HYxuB03Rta1HANTw9sDzui3mckF5jn1l0B4rwItqZRdd+AoLFiNKerMQNnUZjMBTeL/fth182UI3bKRDm5h3t7mwQmW73t/xpZIuUlfv9mzwuzIDWQjyV3AJVXmUCp5Eh5WlH7VIyRXO0uNuoBYBtu+DfQMZr35jPPhyfPXefSnqsGbex/Dmn/Rv8JmA1ZtCwKkON8sLud3810Oux63s+kz0Uhq+YU8DCbOXNuyj4TTjqUoVY6LRIgjFi59WfwczvNR4HXj85/WTE9YpKg6BNp4c689TFD6mHaHR3Wdk9hBZwzEMtrwJGK+MB5wmtwDiPlSaYEIamxHRGN6V//y2xL9fQbBsUR/AUYfvjbnFU+Uem7Dmk/OVYUPvGsU5Ow6IFrzV3NBL9jDIf1QI2/TXs7TNIKnGHz2uNMhLLIb6g0I0+kIw0T58rj2lcfY6wE2Z4iPKA+08qsNg+ATolRth/UYW609rT9xmiI9TQ0jxc79HUfkaj2qBkNHjfBwd4ZnoejSUoN1dWx7lryzqoVkr4FKaZ2DOGCrc/cqTVGaTkaKwHVsYGZ5IkANY4k6rU1Jm+Kzsv53l7BPnLLXnZ8cSNs7Yc4QRS35r15eWqIeDmxQF2fy02qFkkR9+h/HLsiDD18qhrGNCCMvKVbyBmkl7hh+GU/gPSuNOpu4szKfQw6yp9Y1AL7EHqcloLuDfzP5PyLh7sVklvcT8yxYbFkollO3arxJfwnM+k5xLMhf0mEtmdVax9XshP1XaLcQ+kjrlrKZzetgWarCDwe7r/pch4AGFYSZHuVf8zeqO7BItq3XwOeDl6zzMYpdMUiHNfWpTjrp8NZ6JxtZFMPa7jXzQvlbNXyUEacF/zjBiZPBnmgLEAYqpxhmX4LgjdkfVNDqgxJx/BGHlxx9
 lNoe/XDb
 K1w3UiEuaYkKONcf8/hSEqAP+V/bxdVGMCyqfqgVfICCFINnlHePsMwrU7k945/1qmxN8Qkh3vve2rHER+Tqu5zUzqo7KequX8sONmpwLOGIbdqtzPiuVQvIoVPdo8wNuk7IUtNEIZzU5Ne8tke9ngIAuO7+CQg9k+ahx2+1AuGEkxOojA492WKFaJkNB1bTAX8pGV/HGL9XuGxiy2eeP0atsREDrBfvUkNxdIZkcFPmOi1HFPbcXy63NIOUMwX9jtin+SxNA1UBagvr5W4lx2sCBH5CHgKkoZ6YYkvk2wnbjcN5mN053VgEULVgm8plwD3Imb4h2PuhWaDNZsclYuh3nutZajdssDIkQRttpuuQFphL74tm+y7hqzUq+uqDaitW/FAKQj9ptWnHphC/mibbP1VSVG6kKx+HXvLnOyhkhxZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 9b08b2457a555..e54cff118f8a8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -280,14 +280,18 @@ config MMU
 
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
@@ -366,6 +370,16 @@ config FIX_EARLYCON_MEM
 
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
@@ -1697,7 +1711,7 @@ config ARM64_PA_BITS
 
 config ARM64_LPA2
 	def_bool y
-	depends on ARM64_PA_BITS_52 && !ARM64_64K_PAGES
+	depends on ARM64_PA_BITS_52 && !ARM64_64K_PAGES && !ARM64_D128
 
 config NR_CPUS
 	int "Maximum number of CPUs (2-4096)"
@@ -2369,6 +2383,19 @@ config ARM64_HAFT
 
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
index 72f31800c7030..1ee1a6d9db6d4 100644
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
index 290aefcf0f0f1..bd31211624d4d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1081,6 +1081,8 @@ static inline bool pgtable_l4_enabled(void) { return false; }
 
 static __always_inline bool pgtable_l5_enabled(void)
 {
+	if (IS_ENABLED(CONFIG_ARM64_D128))
+		return true;
 	if (!alternative_has_cap_likely(ARM64_ALWAYS_BOOT))
 		return vabits_actual == VA_BITS;
 	return alternative_has_cap_unlikely(ARM64_HAS_VA52);
-- 
2.43.0


