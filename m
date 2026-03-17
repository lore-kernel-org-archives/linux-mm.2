Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91954FD877D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06AB56B00B4; Tue, 17 Mar 2026 10:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F8A6B00B5; Tue, 17 Mar 2026 10:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CB06B00B6; Tue, 17 Mar 2026 10:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5D7E6B00B4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:15:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9261A1A015A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:15:50 +0000 (UTC)
X-FDA: 84555753660.28.243E924
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id B5B5D1C0011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:15:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N8mYGV8q;
	spf=pass (imf21.hostedemail.com: domain of 3E2K5aQoKCBI4u3s705A20y66y3w.u64305CF-442Dsu2.69y@flex--mclapinski.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3E2K5aQoKCBI4u3s705A20y66y3w.u64305CF-442Dsu2.69y@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENui0Js8tkhd80bmpMrXzJoFIzd5GZKUFokCk0GUoAI=;
	b=x10YWilUPNU0FgbN3YLPlg0Dc4GMYHvFoAojMKfw2yI9unZ0XkbyYs1oXxs+VrG6arOkoe
	KiwSMhlR/5q/iasG/ZykVDwA8nbG5gLGKLbCUlbe42NWlVAcYggadad+m8zvzIA1TYWk11
	UDm/8z/2wj7BD86SheP7z3VSknvQxQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756948; a=rsa-sha256;
	cv=none;
	b=MsN8cJ+Rw2GLWAgMAUjA75GxLFflbnkpvjyowOCK84JmpiMmeNmmtzedKHnZv5JlgiVRo9
	QmpphmXNsQxadPiwaK7ucOerjx1CiVdbKUi/hodkliI+NuRXhnUoswIl8meMdg/sWzxNqw
	Skj9qqEPg9pLzdhQ4/dvARDseIuw2oo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N8mYGV8q;
	spf=pass (imf21.hostedemail.com: domain of 3E2K5aQoKCBI4u3s705A20y66y3w.u64305CF-442Dsu2.69y@flex--mclapinski.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3E2K5aQoKCBI4u3s705A20y66y3w.u64305CF-442Dsu2.69y@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-66142e571c9so5863109a12.3
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773756947; x=1774361747; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ENui0Js8tkhd80bmpMrXzJoFIzd5GZKUFokCk0GUoAI=;
        b=N8mYGV8qXGuTSpkKGRRL0KXbh6wsbW2soFA2tV1jKxmS/gjz09fwDpIeyzbkfH9AFo
         TVyAq82OqqSyQIn9Khe9OUySIMDSBBRiNKrQW++dk/5IOFw29bjK/lLGndohFzYxl3Lu
         q2HLm1E9bTXjTE4n2DqkCCMLsaemUroFWePHU0QVhzEdxk86WMNYTzy2KKPD87fWuuFo
         CmseIxA2eT1wBN9fFiCLy8M2cd+DaWvy8wV94KBtc9BJ/gu+Ao+zeawNVh+lvg87qcbN
         aileGBVhd/YiIXh84GFXowNH6p8WFCTA52ADvOgm6W5cfUergVmt4kEyg2EmXfKL0YYh
         /zXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756947; x=1774361747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENui0Js8tkhd80bmpMrXzJoFIzd5GZKUFokCk0GUoAI=;
        b=Co2c2xPZzeq0MBQEPdVeURBB33jYGc/WqYJDSa+7G733OW2B8jnaO2fImLajfeq6/P
         z4A7vCoKDeO4O1l85XgfVhFnANQLGfc8eZBsfIBS85EiNyAtfVXCdQeb0T5/C8sAz8ZW
         T9WHLZgpI9ed/kL5We7y44kEe24v4vb1jYg/GGJQtd4XSZsxEBTGQ9ZXbL7tph+UFTeo
         3wU8uiAz4z2sGPlhKJ9Io5sFjVfNmI9RCtvwHHlaNeumx0x7QMaqC7aGMjFRIwxl2VYq
         tiG2l/MUyarU1HQJ2LcqvGgj1TrREJPwlB/gZa0EcynneiKPnpH7dO31YIZvV5c08kJE
         sq7w==
X-Forwarded-Encrypted: i=1; AJvYcCVMkstSOPNNYskpW5JqliZ69ua5ij8j+zQyBnmT6dRR/Bdr6aF34d7oX8+uVSRlQSmIds8zw0aJfA==@kvack.org
X-Gm-Message-State: AOJu0Yx1jovfanBV33mZlkyUmHVRtw5/HU+A3B8egZDmuLeac4nkyMZr
	QRcScw0yOCuwowfwRIuZAz3mC7I4u88amJLrkMnnB4thQh8fEeg97Ca9ofLcrHnssd7TrtksEHf
	ykdRSbw9+GO+WGZyD1SWIew==
X-Received: from edew21-n1.prod.google.com ([2002:a05:6402:a215:10b0:662:4e97:3bc9])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:26c5:b0:667:5318:2bc9 with SMTP id 4fb4d7f45d1cf-66753182f33mr1449370a12.15.1773756947028;
 Tue, 17 Mar 2026 07:15:47 -0700 (PDT)
Date: Tue, 17 Mar 2026 15:15:33 +0100
In-Reply-To: <20260317141534.815634-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317141534.815634-3-mclapinski@google.com>
Subject: [PATCH v7 2/3] kho: fix deferred init of kho scratch
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: sk8jf7edpr5u58d4n8gzi1immeg5zpby
X-Rspam-User: 
X-Rspamd-Queue-Id: B5B5D1C0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1773756948-148714
X-HE-Meta: U2FsdGVkX18Wcc7kIy/0ozFFr0XfFaQyo8NNNL8i18hE3aCV+SwJYykI22NXVN4IaIJcoU8+lE14biXVyxg0fWX5+eI87bsl0MDTLR7mrC3c8xw//Mxpp+hAqxj1U1eishP3FN2qXN908Ij7B2hYCWCZtC495GfHkWmxeR/OK4jyMXbK+ys/mVLrJE/BAwGGRytcmwPbD8exhlFh4h8XSFn0k1TUtdSA2fKb+orYcEnH9BnzdRbkhvncmptOc/wzKxwRLOfzGrxryX8twg26DfxoPHwbfUhxsBEsSC+wvkdNn4rQX5fwDgObly+TeIyKgqKQ096buYB/XBWt3YetVPuRoa2l1gHd6pVxTXKCUTq1lE9zPn3uAF5gtm4F3B0DXeFfE54BqTQSzpksz87DI+02RKnevG8TGKYBIM5UwhycyO9d0mNfdoKYVkWPp8kQ4PCFHw/BV7G/+4l8H99xDLkY592CExTW5gphhDbR2gG/VTLqs/JNgjr7n5/v/vX21R6IOFwuJWvEqZXxP6DNWnln6Bf2cYs8H/RPowWY8NHYzMtzNLRFb1yaJE/viIL4eQlJ3HgFrrncCXH3uOFZGm4tCd0bNjLEYLgbOMcyqi6VbFECJjDt+SsV+oGz92i0468QrPyPS6xh91b6oTHnJdI3F5kRFpoUyL4wwmE9xFjgTOYS/d7N0UXiZWy9pgmgc54N/Crvnwab7iCOWDr9BGAYW5+GnBXYQqETofPDfij+eYfkALo1nRNi3d+htbaJonRgmG1sRaIyFEaywn+CCGF8SKwoBTNoQieVONsptg7V4SSIfUtx2YZx9CYSjsPd8XQab5eOhB7v64cRiZjiVYQxyFReMEfNQzjblW4pT3YxqHecwpcKMpBVhPmCgI/5cVlZHyjYNGKNHNgrBNbNyemtV/PFI0LAXFjC4W3NeaY1x13Gq4/wHeZLKdMDSXSDFt1/eRD0glF0WFmELpT
 MH7nHleQ
 h9NR+17eePHY3EVNJy07tTdPR2tLl1ldsCGQ3yJlNXpy53ljZvLlx3JNZ6bN4hihA6ehcNMnnAdipb280ST2JBZIf1rPnlmhmZrkIbUKFScZfB2MuIYmoK20FM2+06clgd0TBkdp0FmalS0EuI8/8F56ttFrtfEnLDL9od8DKqSKx1TkUkh0OzIjXNa6jL0BpQsyw0cGk/QBeLoAEmeJwrxZgyNvaiGqCfCgNamw2KmM2HMuysFvZUAme2GnleTutoaa0TwX4eOcWJZqC5VY74E7h/0baQSoXRO5oPTf3jCWIBkvgt+s7Ysm7dXA/JexHxBnZ577zQ92HYQUJckwCLV9iZmrN3g6L2snACazFrEULNKzaAHk3/MhKI9nHAR4zKnE+er1+S8t9eRCKzIIVlZS+BmjNpZ9Nr46npPH7H35mruSw/5+IwIgbg2gwXxT9QxdDPhgdsqAvyCr8NbT5oB3FH3uERr888QNjnR/oRbHNCtWg7aVpRVjUyevNG70tJmchzyzTqY2O06KlswFOsetgjjVIOCXFc2y4dkCpyDPQg9l8kvJrzvnK80e6WPfz6aHU/BLEaUETLuc5HphVF6IityVCOFBpLHRFO+q/Jekl/noYysgaHJs13p5VyOgGRKv5ZudqpYpxCtBE25pud8OwWYd09oyXa1ma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, if DEFERRED is enabled, kho_release_scratch will initialize
the struct pages and set migratetype of kho scratch. Unless the whole
scratch fit below first_deferred_pfn, some of that will be overwritten
either by deferred_init_pages or memmap_init_reserved_pages.

To fix it, I modified kho_release_scratch to only set the migratetype
on already initialized pages. Then, modified init_pageblock_migratetype
to set the migratetype to CMA if the page is located inside scratch.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
 include/linux/memblock.h           |  2 --
 kernel/liveupdate/kexec_handover.c | 10 ++++++----
 mm/memblock.c                      | 22 ----------------------
 mm/page_alloc.c                    |  7 +++++++
 4 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 6ec5e9ac0699..3e217414e12d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -614,11 +614,9 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-void memmap_init_kho_scratch_pages(void);
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline void memmap_init_kho_scratch_pages(void) {}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index c9b982372d6e..e511a50fab9c 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1477,8 +1477,7 @@ static void __init kho_release_scratch(void)
 {
 	phys_addr_t start, end;
 	u64 i;
-
-	memmap_init_kho_scratch_pages();
+	int nid;
 
 	/*
 	 * Mark scratch mem as CMA before we return it. That way we
@@ -1486,10 +1485,13 @@ static void __init kho_release_scratch(void)
 	 * we can reuse it as scratch memory again later.
 	 */
 	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
+			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
 		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
 		ulong end_pfn = pageblock_align(PFN_UP(end));
 		ulong pfn;
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+		end_pfn = min(end_pfn, NODE_DATA(nid)->first_deferred_pfn);
+#endif
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
 			init_pageblock_migratetype(pfn_to_page(pfn),
@@ -1500,8 +1502,8 @@ static void __init kho_release_scratch(void)
 void __init kho_memory_init(void)
 {
 	if (kho_in.scratch_phys) {
-		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
+		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 
 		if (kho_mem_retrieve(kho_get_fdt()))
 			kho_in.fdt_phys = 0;
diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..ae6a5af46bd7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_only(void)
 {
 	kho_scratch_only = false;
 }
-
-__init void memmap_init_kho_scratch_pages(void)
-{
-	phys_addr_t start, end;
-	unsigned long pfn;
-	int nid;
-	u64 i;
-
-	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
-		return;
-
-	/*
-	 * Initialize struct pages for free scratch memory.
-	 * The struct pages for reserved scratch memory will be set up in
-	 * reserve_bootmem_region()
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
-		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
-			init_deferred_page(pfn, nid);
-	}
-}
 #endif
 
 /**
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee81f5c67c18..5ca078dde61d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -55,6 +55,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/mmzone_lock.h>
+#include <linux/kexec_handover.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
 
+	/*
+	 * Mark KHO scratch as CMA so no unmovable allocations are made there.
+	 */
+	if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
+		migratetype = MIGRATE_CMA;
+
 	flags = migratetype;
 
 #ifdef CONFIG_MEMORY_ISOLATION
-- 
2.53.0.851.ga537e3e6e9-goog


