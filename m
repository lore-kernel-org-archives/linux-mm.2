Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9255AC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7E86B016C; Wed, 29 Jul 2026 10:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278BD6B016E; Wed, 29 Jul 2026 10:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18EA66B016F; Wed, 29 Jul 2026 10:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1F126B016C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 627B0A1B1F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:58 +0000 (UTC)
X-FDA: 85042116516.10.1A28C5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C656D40013
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMjy1Xq3;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqM0rNbMk1BcoQ/S0xf/ryjBOK9Jcmu6nULmW4L2RMk=;
	b=Kvz0VBFkZIs2GD9uZHpL73NiQjpaAY6sYQjEbwXEnxH7IaCfdLz1XqPrZrIpMXwLDvFU+m
	rmORTVR7HJYFZTPVp+b9HB7We+jAy7/CoQfJX3wB8KqjMIdT7j2wpC8QqxLpe2AKKD+DXB
	MFWXRO/XWXMnHME/NrjVYyu1LzTYmys=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMjy1Xq3;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337016;
	b=keYOLqFFnXXaIZwCExqAvJzofewfsy6rVtoVX8ncwOg2rI1nk+tZvNU7MvpIrQKQ3xg9q0
	1/onFtP49ueZJXp0mPXcFUPwhYjIRkZ+qo7Ru10ZZfNQWx3c0vM/tHohdfpAB5liFwSXFf
	Nwh2VoyEckO/uhuuwknmYf54h19gUlk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55FEC60A84;
	Wed, 29 Jul 2026 14:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62111F000E9;
	Wed, 29 Jul 2026 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337016;
	bh=HqM0rNbMk1BcoQ/S0xf/ryjBOK9Jcmu6nULmW4L2RMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMjy1Xq3+FUtzp1THEp6WVIndq/H0whS9Axz5tO6h3w1F3H9gkPs0oWmyw1hAiQ25
	 mFz9o9Dpv7ZwWGHpdi6NbbXT7T+uXhbYYBzEiAYC+qkYOqFmEQjDEdrXlRlzjb7GfC
	 5jhq9djHdUO6nw3MKrGrfVCHqWub+P6I1qWdD0QoTY4L4fxgeEoNtHG7ly7nqmb06k
	 Ly+fV699hgOZsfectezWf5XYc1DlgEYHu+NSU8PIoHIFNNKvlBnHYX8TGTud5t510O
	 QDSGPkS9A/Tuvm5hfc13VeF4VkpQpqB+LH8im/+zfF9BHnL4nHBh1Zu0bB7cHFuhd4
	 ymoyD5oDXRc5w==
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
Subject: [PATCH v5 13/22] kho: expose kho_scratch_overlap() to kexec_handover.h
Date: Wed, 29 Jul 2026 16:55:58 +0200
Message-ID: <20260729145610.2827231-14-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C656D40013
X-Stat-Signature: ewdiduh57a3km3ttficpkju5pj9yx49j
X-HE-Tag: 1785337016-461662
X-HE-Meta: U2FsdGVkX1/CObWvp4yrJdkpzWBXQrq18KJn8FSaOK1ekt8ZL+QAAhN8G3nVag4+NC/oGq5fcaY+CzdeV/+YWFPh0dzMtexbZot0Z/MDiU7/WQzmywptLmNfBc1YqyqTYPst8m6osI/DD1GBc0Z0bgpvqsFWcMpTZ9WcwI+qctPfOXNthl2dwxIO5evEFro66IaJRdovik4QvTxGpaHTf6j+Em6yU5O21x0jUecwbAR+Dzo58hUnMMU42xbv5O1U/odH+TcQjrdmGw5Y0aLaWuqCuG/OR1Wp7b1771NuoHMmjvcU3GMBUKfnm2pYXSWHhXa9ifUoI2BxenhWsqVuNSzg8ikCXwc6SN9gB411myhCzMtaADuKvuD5WXTwhadtACxR6ofw1CIJAYW+shMsRa4JykHERozaGmY8XYxV7U0vvm282W2seaAcHxPT0Intxbdyot/tlLbdvB1CQZG2A8S6zHa0EU9OZ5BfKwUgCbXN6oVmggfZLM+PMymY39BfbHl/MDaZDAoIu0uOXc433J2YmRHl+7wJ0ObszqUBTA7kotKqX/RmfZZdUI+U06kj68yPDlPZE47Do73OZm5RsbMRZ8asshbQWAT8L7Hys3awIP0x0XgrGPbkIPPV/7JrUgeIUhs8nDbvobSiz0MlNWfIiV9/GmVNQBWmPmI9d6DG4pfV3q9TTWnsK4zbR6aC8udIOlJ+wn8KksD/mVkUL0VTzwc8+95R6ujrlmbQIrVqBe/QVPN0SycPStIp2H10YZwve/WVnN+xGXr5vD8NlZDsULwF948mwug5SVEZbGNjDkwf3+GdGGjUU2/gOnHakh6Zece1RdI/2iV+6Myb9D0lhjEcD6uoVbuGYjtjLkuIj8L/pmjE/IMOcuWy+aGQsmZVvBlSInjR+K2bRT5LP83Wm1OaJ09558p6gp+VEf2ZoY/Pq4I3mxb/RvuPmjV6yTTcJu6AyQE8P7QvrA9
 dpfG6mvg
 kMac0uEyT9pO/7vxkshS3ELcE9oP4B2xxOIKvB4JcUo1+Uak5BjB9n2Y6POamvWr1nRLR5VGkeSvRcdguRwd+YfaISpJ8IZsiwMEg7rs8MwOUHD1QCNGDwpnlN/XLQ8rI3EstrzYFYCs1gkxSrPoYJw7pEG5BUadp2NCCUBgGuh3ep06PgL6jx26Boi35zWyoca0EUYp4ntYmZk0k/upmJ0pDACsXMs09dw80KgzNxv9186E09cEiwClz+aDQryWHCE+SufdHlozFa/P57PPBayVFXCLeDILmcHoLrEStYYivV4ZrMBc2TKFTuwkiUqmbri6kzDMifrxOnZ27UM8xwYY/Ig==
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
2.55.0.508.g3f0d502094-goog


