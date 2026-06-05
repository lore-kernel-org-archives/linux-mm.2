Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 902B5CD8C83
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0343E6B00A1; Fri,  5 Jun 2026 14:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24596B00A2; Fri,  5 Jun 2026 14:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA12B6B00A3; Fri,  5 Jun 2026 14:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9B566B00A1
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 744EF1C1211
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:44 +0000 (UTC)
X-FDA: 84846712608.04.1F58ABD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9AFEC000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCVRNwyb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LOiNopfyqH+evMdJ4RgcQZeJWf2liHs2K6IwtzYjoWE=;
	b=Z1DHYrRH3FgJXDYELQc1BQB5P0uXmxSCqQ8jyNit7WymWjwmJpMoLMcMrLUfKT1pKkDKoZ
	2URcQGq40bXG8pKgOJqNqQSs8QyvetinjdUwj7Q1KellNI1BBbNhIjk49phGG3XfSDSsZO
	VK5RZfBVmXMngdxiLvb+yMAQmL8sZUo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCVRNwyb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684542;
	b=Sx4qRbxJDuI8LdLJZTQC+asfWWSCIgu702TPLbayxdB8J8NoEQv4G+z/OaS8YQ/xTIw96F
	dmeF5rsUtpimB46KsjV+OAdBNsjrmWra9zMKXetg1fDgbexJgfemK2wDEMdzXjtIoSNZqO
	iMxCWbZsS76vpRKdRiy1n17xd5db3eY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1941243BE7;
	Fri,  5 Jun 2026 18:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB0A1F00899;
	Fri,  5 Jun 2026 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684542;
	bh=LOiNopfyqH+evMdJ4RgcQZeJWf2liHs2K6IwtzYjoWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCVRNwyby+ygQUpFDO97aU/NeI3sJPjkf8B7Mrxw243tA405VrgkDHfzpVkBBL75D
	 sCr3NTa3AYl5JZTLxRwqzRbnanUFMoh/VLphQ/GLQzn/4gznLTDZWd2iaQAQoc+RGh
	 Mf/kq93HkUIqFIr1IWwHSPNVZ4jHg8gQz1vNXBMjbnx2HktU968oZ8H2jk7/8hges9
	 NvBQBbNXrvbyrsHM4bGiVPxBTCQLW6LMLNM6TQQ+u6adVZHnf6wzo57oKx3m7Q6+pi
	 HKoIhKEVOIUyk/hFcoDJxNyFviWxzqFUNXy5mVs0zWcdGGtC7RRpOtDav5xI7xVF7p
	 xS1nTEabVjOdA==
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
Subject: [PATCH v2 12/18] kho: export kho_scratch_overlap()
Date: Fri,  5 Jun 2026 20:34:45 +0200
Message-ID: <20260605183501.3884950-13-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: tfzqqikfgu6yfmum7611h4z8fzaxgpri
X-Rspamd-Queue-Id: C9AFEC000A
X-HE-Tag: 1780684542-633772
X-HE-Meta: U2FsdGVkX19RjeNl5pYVeyGev9mXOjICYIbfRApihppVW4FDuWTs2cIMnJL++i8OvqoEOhzB/7HdoKtQ0ibf0DR0W5yotzC9Sj/ua8p2261G0VZwhbevgYkTai4qWYhBu7tSY/5BvPfPdMO/3udNg5gO7mIFQhhGdFCaf53sYu97D7HXgQYa5z9Nr2aiZYSvCeZsnRY6MnRANtm35mpLNC+QhTy/jXblw0Xz1nMxeKKBf3nTdid+GwUMJwImRhMfcefJkuMvHkdBbXIu+BQGR3xSFZI98pqwPWpxTS98sFn2iXoOm7CW93RkkhN+kvDdhhxnIDVN0wTn4Ap6GBERvHhZ5P/I45d3NyY8AoB468tkZkvjx8YfsGEoatnuW/R39gQ6IsuKIH1Nv2sDAH1Oz37iZ3ZAzDTPsJK3qtDfKXj6m8WyUBFwOxlPKsAbaIUDZQY2Gby2N/WLi480wEjoRom1pq0s++5pbL7gq+bEAkEZBsazasS13QEQzy92DBgwhpfTX48Xk+JMNoAnDsr+8N3Ats4ansBNhIr0e2UT2ZFr+unesSWglhizq7mUsuJz3KQ5Sx829pt7heNpRQuB0p1/jBV5pt11MvOgEw9KBxdp7V23qrofI3ZijN33Dob6wV6UQUdpJg6/OhPA+5UVG/ZRDWaTh2l0vlBzX0e7Y6iHTGIZ8meVMXSqAG8crEoOX/tst+HLz7vmNVpGAY5K+zU781G6CyRRNQ79HbLdMBbh+VavJKPUNpljUNISk7YgkwpFN0LkAM54Oxk49u147MusFpL3EoMs/9r6g9Pk7Z7dsJwjgCznjZwfkAvMlj1wNkk7FC4Tat5vxQpFtXl/1tUtFNUIYVtaeURbLoLEtKFMI/8rzgJGx+RodmJ5Dr/+TnKMEGl/4GGr6eD1fOW4DWkklMwAFKxj7PjRsl2ipEfvdXJVIZPUjkqLC5RzzlsLxGLV1pFgaP2RWn+37iO
 Sqr+dOOQ
 qb1t84xWfNS6JwoYi3CYg3Ti7bFrMGFIp0lAigTlv3HGu0Ky8FKnewlJgTBxpfAyohPjbIbWRP71Yv+M84p0C2eLqKlctChzKBuZbvFpfpzrBSmo60IZ//5cTnj7UJvVvF7JGB7LIxy61rb9njJ50EoN3IiCpqwvUPGIlui2QWHmwhBoDbf7YVS3yz8Y4Yw15Yb7bPPYeHxj/r9zi8O2Ty1yt1awiTirBvBZOxSxJhtlyFNMc7Dsf/rkykiZJW8H0v/yIYdLn6VRDRGMaamI6J56c37RpaYki1GwHBoTELlzz0nlagJIBtwrNho4y9CPqeTKv82QNcTqOLDGmHcVbxFfHQQ==
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

Export kho_scratch_overlap(). Since it is now used by non-debug code,
move it out of kexec_handover_debug.c and into kexec_handover.c. Gate
the overlap checks in kho_preserve_folio() and kho_preserve_pages() by
IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) instead.

Since kexec_handover_debug.c is now empty, delete it.

No functional changes.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kexec_handover.h              |  7 ++++++
 kernel/liveupdate/Makefile                  |  1 -
 kernel/liveupdate/kexec_handover.c          | 22 ++++++++++++++++--
 kernel/liveupdate/kexec_handover_debug.c    | 25 ---------------------
 kernel/liveupdate/kexec_handover_internal.h |  9 --------
 5 files changed, 27 insertions(+), 37 deletions(-)
 delete mode 100644 kernel/liveupdate/kexec_handover_debug.c

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 8968c56d2d73..3740c14d970d 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -40,6 +40,8 @@ void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+
+bool kho_scratch_overlap(phys_addr_t phys, size_t size);
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -116,6 +118,11 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
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
index d2f779cbe279..dc352839ccf0 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -7,7 +7,6 @@ luo-y :=								\
 		luo_session.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 8ab2c7e234e1..a66f23a35389 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -766,6 +766,22 @@ static phys_addr_t __init scratch_size_node(int nid)
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
@@ -963,7 +979,8 @@ int kho_preserve_folio(struct folio *folio)
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 
-	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
+	    WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
 
 	return kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
@@ -1040,7 +1057,8 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
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
-- 
2.54.0.1032.g2f8565e1d1-goog


