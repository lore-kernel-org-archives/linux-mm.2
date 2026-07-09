Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD216C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FAC6B00A3; Thu,  9 Jul 2026 13:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7AE6B00A4; Thu,  9 Jul 2026 13:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6A56B00A5; Thu,  9 Jul 2026 13:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0A76B00A3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C366E1C1F05
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:07 +0000 (UTC)
X-FDA: 84969949134.07.2719780
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 308571C0011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IccSNhjY;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mc07LIN06reXb1mRXRVR0d4cmBqcpz+nSq+c6qEbD74=;
	b=D9C1SvSSjVb7/J3/bDNGLF/s50/IBHpzfGsY0tfnyPz2E9jfjHbX2Zb2X9tAqwsCBxBxaA
	W3FRKtevaIv3uPDDMJRMNsjBQ9UAOphADKiMfSPMIahPIh8vXtArZwoA2JQmGtNYbk8DhI
	aUWi/iJNnJvRUcq+DQfwmvUlNHAiQas=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IccSNhjY;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618746;
	b=n4kIAL9als9VjD5uTmV8yT9+tBa7UrnKCH8SsC07D2ikyrG5KuY20mDpeyx16R/OfJ+dV8
	vdD0lzKwLaYjGPdWNnrA8MuhVyBcFzLNjLwuX/JQboFOqz+AxtdHebsw5F6C8w0ijc78u5
	Uh2cvLp6OiuLaM8WMc04KDBFc2Ix3PE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C34E66138B;
	Thu,  9 Jul 2026 17:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D501F00AC4;
	Thu,  9 Jul 2026 17:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618745;
	bh=Mc07LIN06reXb1mRXRVR0d4cmBqcpz+nSq+c6qEbD74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IccSNhjYeJaqPSf8ag53sGrW6ORxiXj47H8CbBQoNXzqKwasA711GRVEy5o5lXvK6
	 IZek62dhMYpXoIAy4GQQEHSpmu3hHrC9BgXIxcD/+hquTUAS1cMK5wM0QvHqAJ9YS6
	 XwnwBbpn+uvulYUwB/M2Z4dogeA4NehcezY3B+/xgHbIxIxNGadJyIBVcHMY3pFQMZ
	 Cjlt7sAJGLAyTqwLVcvYdH2kg2XEQU9PV7xBzsudHhO/bzkQErmpLztm00PA+I1hqH
	 SZ3vF0SWv5S3XlHxCmhaf1rtKRYzyjObVdrWFdJyufjt3u3+AgTG6gnaffS/z7afSA
	 nlZ5Nq0yx2sxQ==
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
Subject: [PATCH v3 13/21] kho: expose kho_scratch_overlap() to kexec_handover.h
Date: Thu,  9 Jul 2026 19:38:02 +0200
Message-ID: <20260709173821.429921-14-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 308571C0011
X-Stat-Signature: twftdtkju5qygodhk16q5c854fk69mgy
X-HE-Tag: 1783618746-734883
X-HE-Meta: U2FsdGVkX18Gte2xtIzji7gnlRBQDjck3wiXGW5m+9DzP7tbzkJTAuH8p9Eut7p5j7SDj/cbI87oJwg2QlQ2rpQaKOtINn6s8zNnnXHiXPMMO24Mh7zRvCuL81TdieTfZ9hVdhkERQXYXHuqSWVoqM39hU/lr7vvo6tYtJMIyg47MperhgdBQF4HHS4MG+lb+b02OZoDSWErPhMM//hrGiem0cpIA4SjtlIbWuoazGFYvyDH5LpEQlwh5VTcC0vnZ/IF5qpHBQpaKx+2F3r47Q2InDK0pypTRLbBFS+hDgQGwp1RRCHXVm1qA5ZjgG/dQhV2zAfrJjSGPWIU1D7ASBeqYCZlfuaLpORnbkg1JEHwpsbb8IYLE/SzacJBV6o2rC3iBqEO1FPzH9pKlsvcOElqtSqBpqoK6sJzO8aOb8PzxYaFq5vRQxd8mqJQEt5X435GbcLUPXLWLbLjyP9T0v4Qf9fGoftyczNEHkk8FTO3KmyurFJUhxrjUTxyVcQkMgvO7rUIXo9My2AHsGR/zHz1YuJrftMs+pcnnohbkulxlGJ4aHUciMlriyVJp65a0KKWlmfclabYPHF+zUKmjHbKrT80xq/3XZPH0PMMuec+29jKo2r/3ADy8F9KHdBMTdkZmQX5uNMiHzEVgAJs8f+uTz9NHN7AfQe0cT3HEhnj2jfYJrfzedvIXjbEikl/rrVHMN3j2YRhu+/s+4DCIiBDczjjm6XB1dX2ObqppkAg0MhW9RG79YDt6ggLDZjrqVNV1mjtl8OOfbyWTOvZQB2jX5nk3CmgOJAjOqD5WyOma3u+NpfvNW8QAFhodcomcN8JcDXHQZ9whcyKYMkdrTsfzYRyy+46cOjNmTfV2n3X4aQY6YH/bCg9sH0sDAiaMUeaOI/601Ux+UwzpzzpA0v9a/+ouw8oxNHs+/Yda4hDbLmtpypPD/AzdCes5eDG5bFvtxFD1Z/w15Nb57g
 PXPNZ2hd
 PY5B5ECOhJ8DlCxh1Xs+bS1WsIUmeloU2fzasm8fNAcy/qk3zskYC8xXqTx88A9w4Joqs+gL3bkfjya+c9DYsb9HIbwRZTq4NOyXKZMPSX7IWpBhsKawaJ4FDCZT2PqSRwpVB3Zd1mjv3jBfYIga+ejZXHVOt/xcEN/JxEom6fiP8JTU7QUq5cd9ugZ5HKuWL59+D3bcxxWDFBMPF8wo936XmUOXIq3FPEP6qkjLFK+Pt7CfNHNZHN0hi6n0cA9xPuDTrOmVTCYdx8vD4Wx/VP233IB/tZf8sfMmiuTRZIelLXFt/UbWt1rjRWTzOh3yAPCjf+ryvCrNA4gcmOxRfDjvPXg==
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
-- 
2.55.0.141.g00534a21ce-goog


