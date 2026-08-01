Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75241C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B646B009F; Sat,  1 Aug 2026 04:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13696B00A0; Sat,  1 Aug 2026 04:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50D36B00A1; Sat,  1 Aug 2026 04:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F36F6B009F
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35A9B1A0269
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:27 +0000 (UTC)
X-FDA: 85052076774.02.9543950
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A74AC100009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Izkr+3BS;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GA/494sNcrbhXmU+JtLyr3LcrZHS+XbcfR8p0tV2EoY=;
	b=kjYlVrr7rcT391ywaIhNVJobKVflz7fSjOTkTPiVAgFT9J9PxGf2Pb5HgdusKRWsx0DYyu
	KmgaKkS3SXXGrzbPoL8fOzjTqpskeIt75LqoQB0Iq7nirBQAD9oeOyslVgIttogoWJewng
	/eDyW1E2rfZW7fiJrTnLRXRVqwcfj3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574165;
	b=Ucs9/M9rlrNGPDkct7RwuM4obJbzTCgTpzmZGEFGqANrjaCGEZL/4PKqO6uJ1e2FhXuJPd
	WbjfMx/YNJRFIDuan5Z0G9tP2sR+Fl7rWUHzSy3RM9jhfLGwdqDbjoucMWXC7OvKYQ5Y/a
	ZlyuTMVDdrgYZDDL/SBbQto0Yx2MR0M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Izkr+3BS;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57A7660AA8;
	Sat,  1 Aug 2026 08:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6421F00AC4;
	Sat,  1 Aug 2026 08:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574165;
	bh=GA/494sNcrbhXmU+JtLyr3LcrZHS+XbcfR8p0tV2EoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Izkr+3BSvz3jsRWtis72ekvU3JOBU04LIrcrLSpVnx/m3omZ+eAvoDeifAb/MSX0a
	 zfgzwp5kqwRB4tKQk6R18H+2u5bXO0/ngJADnH4oJ/MEUQLfkUA1xs7b3PiIrprmKR
	 z6hRJScx2zLauaPeMtQda7ILCNqxxMjvY/mxNuWym8LBWuS1q/UH6du+vzIZKwS1V5
	 MstPHLTvyq283ezKSx2J2UjRbEhoHfPDkt5LijVPLR9WFAfJRKp5FZ/8n3PMTxHqwV
	 m87O2fJNjba/BIPaXq84tfH+ndIAZIin6ovyZb/41wnnxKPoHIk8Cwitf0q72/u7PN
	 26ydEsyZHl8HQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 13/22] kho: expose kho_scratch_overlap() to kexec_handover.h
Date: Sat,  1 Aug 2026 10:48:22 +0200
Message-ID: <20260801084833.1897543-14-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A74AC100009
X-Stat-Signature: 9j44q6jkw8fxqzoo688h9nq4rr9j6txp
X-Rspam-User: 
X-HE-Tag: 1785574165-472736
X-HE-Meta: U2FsdGVkX18t+pM8IIIJXe1X2X1NN6qOxvypvSmL0FFMD3hgDUBZIMdhz8UaQGdwrdsd7u8ZK2piJuZ24jv61jploI59XDPN6tN30tUJxfH7G79+vJvInbnWMExpPw5kP3yXSrrDEwJGbbEAnO8CAlgm/xaiwcp6Mu/8PyYcfDY1aV7oq+/XiC14UUO4hQKla7ieluLFlyzcqgEohxoZKI+Gqow2IsvGixVEqz/PVGa5LE5m+2Z/oyddiOTqXfZEYAw4uqp6TmFuw/Tm/siXWD992nCmu3Q/Q+vXsek3OBLJqZmvxcYLM356oVJANZPdr8rTcCjtdRwDYXuNfJMn5ntIzY6o8GhMzA3tpXuk4djD/fLxZK8q23L6thAgdAwV9wsPhQcU9Wt59e+pVfgHp7cU/2KCLmLLm22tE5hnQrQg8a0HjJryCUoVH55QB1GsadxVHBCpubHocb/OHF3/SanszpuoQ9ZMY4NW5jVHYM0vIq7hIrc04J65yv6/6hBdTZ5LDwYpe3dz7Sy7Q1Nn+O6q2xKqhfQvNXuryTqMCUZYIPWtahQAL5zWTxlS4FGIAY2Yp96XNzbLW6unq2Ad3hb1w11qIadjriMt56puHmwN8A8fcjDBAUoMWyWjKsqfu4FtLyL7fL4ThWRLhZLUP3hSxbo9X5VaPgbTaIuN6kDQMVCYhIZujbYOytRAIyne9P4FhlCzbJKOK5vIDRaFVdrzac09k77fsrcS+lJJ4FcAGRAJJc3e1RShmBWFiIcP3pAKVQc9s6fRUyPUpUkLoAUg3PJsbW9TA2SEYRClO/obgq2w0vMUBkXIcv1L8e3n8EgYokTWKswLiYgUjGY6C7IWcQP0tMYu2WVci/3kHkuRtR39XR1Hi+7ckSgsB3dRmK+mQeYhsCEMm4Bmq+p6a8JcmxfnswvCZWkT1b5piuzcXu0IkvN1cOS4fk4S7kOsgVxYLejdzgkOSoXZB77
 Tr7Y8A1k
 a7AF+SjLuj8aa6Hxu55xsnHpsy3+9u1gBnp91B7HvuDNPRtLe42Wo030xNWZA+sRHBHOnc60A15DyuroblYeuUjLWgyv3hz+OgJ0YwvMGbDfve39QPKdnEB6iwfrpJRakVVTttNZiQEzYl0ZydTIRS7Kwx1agGgvYhJw/iXeB+bWWwrGoCRxt9JWXzc96YvokMOfUCl5NL2Rs3tWOEBILZD7PtT65TRTS6US2sIZNjpc8w7uz4/EXUC5LoGnMRRmy6474SuibRUkB8GVwhYkLNBtuhiQelAg/V3q7kEijFEHzLg7VGSXHh3Uzv8MjpbAkR+SEggPZGtmWOpX8rLHpwdk6tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Support for discovering memory blocks with no preserved memory will be
added in coming patches. These areas will also be marked as scratch to
allow allocations from them. Memblock will switch to looking through the
scratch array to decide the right migratetype.

Expose kho_scratch_overlap() to KHO users. Since it is now used by
non-debug code, move it out of kexec_handover_debug.c and into
kexec_handover.c. Gate the overlap checks in kho_preserve_folio() and
kho_preserve_pages() by IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) instead.

Since kexec_handover_debug.c is now empty, delete it.

Add a stub for kho_scratch_overlap() to memblock tests to make sure it
compiles. It will be used in memblock by a coming commit.

No functional changes.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kexec_handover.h              |  7 ++++++
 kernel/liveupdate/Makefile                  |  1 -
 kernel/liveupdate/kexec_handover.c          | 22 ++++++++++++++++--
 kernel/liveupdate/kexec_handover_debug.c    | 25 ---------------------
 kernel/liveupdate/kexec_handover_internal.h |  9 --------
 tools/testing/memblock/internal.h           |  5 +++++
 6 files changed, 32 insertions(+), 37 deletions(-)
 delete mode 100644 kernel/liveupdate/kexec_handover_debug.c

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 48a9793c2b76..40cb95a80981 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -36,6 +36,8 @@ void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+
+bool kho_scratch_overlap(phys_addr_t phys, size_t size);
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -112,6 +114,11 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
 }
+
+static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	return false;
+}
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index eec9d3ae07eb..d9f469462556 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -8,7 +8,6 @@ luo-y :=								\
 		luo_session.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 04bfcbf9cc55..b3b97a6ff9c8 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -765,6 +765,22 @@ static phys_addr_t __init scratch_size_node(int nid)
 	return round_up(size, CMA_MIN_ALIGNMENT_BYTES);
 }
 
+bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	phys_addr_t scratch_start, scratch_end;
+	unsigned int i;
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+
+		if (phys < scratch_end && (phys + size) > scratch_start)
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * kho_reserve_scratch - Reserve a contiguous chunk of memory for kexec
  *
@@ -962,7 +978,8 @@ int kho_preserve_folio(struct folio *folio)
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 
-	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
+	    WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
 
 	return kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
@@ -1039,7 +1056,8 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 	unsigned long failed_pfn = 0;
 	int err = 0;
 
-	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
+	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
+	    WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
 					nr_pages << PAGE_SHIFT))) {
 		return -EINVAL;
 	}
diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
deleted file mode 100644
index 6efb696f5426..000000000000
--- a/kernel/liveupdate/kexec_handover_debug.c
+++ /dev/null
@@ -1,25 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * kexec_handover_debug.c - kexec handover optional debug functionality
- * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
- */
-
-#define pr_fmt(fmt) "KHO: " fmt
-
-#include "kexec_handover_internal.h"
-
-bool kho_scratch_overlap(phys_addr_t phys, size_t size)
-{
-	phys_addr_t scratch_start, scratch_end;
-	unsigned int i;
-
-	for (i = 0; i < kho_scratch_cnt; i++) {
-		scratch_start = kho_scratch[i].addr;
-		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
-
-		if (phys < scratch_end && (phys + size) > scratch_start)
-			return true;
-	}
-
-	return false;
-}
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 0399ff107775..805d2a76c388 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -41,13 +41,4 @@ static inline void kho_debugfs_blob_remove(struct kho_debugfs *dbg,
 					   void *blob) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
-#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
-bool kho_scratch_overlap(phys_addr_t phys, size_t size);
-#else
-static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
-{
-	return false;
-}
-#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
-
 #endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index b6b1d147fd75..e86bb9000b22 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -66,4 +66,9 @@ static inline void init_deferred_page(unsigned long pfn, int nid)
 
 #define __SetPageReserved(p)	((void)(p))
 
+static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+
 #endif
-- 
2.55.0.571.g244d577d93-goog


