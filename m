Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D23C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCED66B00C8; Sun, 26 Jul 2026 18:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57826B00C9; Sun, 26 Jul 2026 18:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8986B00CA; Sun, 26 Jul 2026 18:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B48D6B00C8
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:24:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C51BD1405C2
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:24:04 +0000 (UTC)
X-FDA: 85032356808.27.8041515
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1EEB010000D
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:24:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gp0zrloS;
	spf=pass (imf05.hostedemail.com: domain of 3AYlmaggKCAgriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3AYlmaggKCAgriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Chyleu130Eb8yPQcw/b+s0bA2+dtNy+Kj0RL2vaeLoc=;
	b=pAZXH1vfUdCcapyHi6+/UWL63kGAyVgPtv8sQNugvlZMmThCZlcxX29lpiLoIzDpVAxOqb
	bd499l5SgaiT9I+jvzjADjW18u2pdbmg8GKLRVCz+SCIsQNIDGXitA6Upb6+wL5NRdiTSl
	NuGCgqdTDRl834fxIdPhNhR0019A6hc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104643;
	b=27zJsSRBjOcDuD+GBGO08XUcjGHOqm/Cf2ZYnqlIpNbtakUWyJno8cBiHMfNs+tlF3fDyU
	QOwIF5p4e2Cya+EXIEYkelBUQu7yCTW9bhC8a2Rhu2k08LzxL8eSgxdjiFiOPBQdXIE//4
	By6tosMSrkMa2XQhSIlFqjkibvd8AGI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gp0zrloS;
	spf=pass (imf05.hostedemail.com: domain of 3AYlmaggKCAgriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3AYlmaggKCAgriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c16711b9473so211370066b.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104642; x=1785709442; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Chyleu130Eb8yPQcw/b+s0bA2+dtNy+Kj0RL2vaeLoc=;
        b=Gp0zrloS2fA/ZA6MzCqk2f21apDsmmXasITE20FqJfn2YJVL1/NnC3NXmL59HcnD6c
         /00I34rSXbCUUg7aZS/VqhBlkGeXleNFeGy3eLTsov8cbMvIfnmVR6MwIE7sBxbHEbFw
         dm7IWDvSQcGj8Y9NmGe7SUdQT5pzldmPE20v426pW01gTefoVdXE9r/38BoXAe/MJjew
         qjL6MiaNEKkIJOIajqohxSuAnor0YNenWQu91lTxA5nUGQ0TtK0trjBkUCNdqVOo1rKy
         o1H9Fy3DTJUrFIKF/9azRGYIBUkPrUH1nByTOFxn7P4CW5FjQT9DT/KIUQql/a9hYOgN
         wEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104642; x=1785709442;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Chyleu130Eb8yPQcw/b+s0bA2+dtNy+Kj0RL2vaeLoc=;
        b=E4lrGSXxvqNJ4Z2QS9fNaxvyTMKaswpc46bi5hWmIQIAjovN/jWZhjHNtNkBgaJxpa
         nN7Ie+kHsVt09swE0KJkW2RrppAh5YMkSyq5ltJg+pkWWMEDigXg6jiL5ZhsAzFgq6Af
         /1kMcXXoz3YEDbW7tYqeuuJQPdQ1P5C2IIKJR+L2GpyGjJOa64Y826KrriYdFjFPLfeb
         HT0HusYOXmiBAmPLWrSE5g0ARyxs3M0NwH2QEyhNKuWHT2gkmlFI2UR412gInfEiiaBL
         X0nL6Vz/uCW+jUqgWzxJLznrww4zpBoE7K2GXrpkkR9RRT4o4K63UevVgBqpKipc8nGT
         3cWg==
X-Gm-Message-State: AOJu0YxUXRpD4scT4Pk7zieEQcizSwO+toOO/Z0SPL5l6i7DRrrFN1w4
	5pa3G6VATx1IWw0mTwyutq2X6c07bL4LMjeWJyyHYU08g7Z+IIewRWf26g75zH6nQYqRIHugZ/D
	rBp9jOWgTy6cnAw==
X-Received: from ejqm4.prod.google.com ([2002:a17:906:5804:b0:c12:3a41:5220])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c06:b0:c1c:2aa5:322b with SMTP id a640c23a62f3a-c1f1ed4a956mr280278766b.2.1785104641284;
 Sun, 26 Jul 2026 15:24:01 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:59 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-26-6f5729aa9832@google.com>
Subject: [PATCH v3 26/26] mm: add fast path for AS_NO_DIRECT_MAP
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1EEB010000D
X-Stat-Signature: mmu9ghaj9yhhfd1rrzgahofx3rr3mbyy
X-HE-Tag: 1785104642-592196
X-HE-Meta: U2FsdGVkX18IMhh+zffUuzep9QDk2oZURIRnzoREQJNAeNGBrOC6YYWvFO6CVs+kjAjinsczq7TbowrA3wwidwWzXfurWwdyF1QauFjxqdaBrRMKgandcCXjWcVhn+UpWlQV95Dyv0yYsGM3K2fXiXmH0j9ZdjlSO82CYpeSfxWG779ohZRrS8Fl2aokQ3W+nEl4nZAERIXP2f+mAzKt9cXcEd613xed/ndN2WkGWr+bYuTqd33XYQnvRzVa43z5qncRMs0RuiYAgS18eLyXCJNIeDTEfFU6BcR6sSBx55tXSIMUUh4EJYAKlXvdKAacGay18gQ0ZOMZejIl4C8bZtWroxkxlEU2waHLyNFpTGJdFXanrHOj/C9QHWWIboliAf9VPvktaHf06fq0XfE1sGPDBtbRG4zAu5PC9B7RttDq5sh6vXfKw6lU2SJ2BMnnLNTuNBEItknQArqJt5WyQGbnSbsH4i30FFLBEsYG8VPFR9bDa1wOs9TO5m27hwo4KfYeaeC0mbHKQQFAl2qdTgHZ8+R7jdOZVGUiKtMrye0SKhV+ULU1yl853xD7445q9AOEBDLJFxOnwO+aNMNLygiUq7vUl9WXyYJM6VzrckzFt+gG/Ja1vfYC9tDjuGcO+daPcN5Hp6eYnMk0zOwqk9E0lHg44wQ2v6TH/t+hQzXsEIV/6WHwnocKSVSNjgi/Taqec8jS8gvWJS1nBStlti7cO31kNRYQ4HUY+/hsRD+jhSH1IATEMLPcNBjL+c7WETNVb5P27G+NDtXWq5PAlhrzASJv+IVnEEpPdmMk+bl8GUid/Z4Vm/mxYluWA7hkNVAkr+TZEJxHqaO72rxT/RO+2oaPqfuz/ieG5AHGmR9+OFVBGmnkuKBtDoU8VapxPDoqEpLHMXdOA6Lx1Y3+hMIRj0EDp5XVQtOe7Z04JAmxs5LXKAocqwyyxGv5qqehIGQ/x22+CGpQk5gDrLb
 0DJQJo2j
 qehwVcosFY12yddjZznUXG2/gtGW2szahjwViCRbTTWEWQQNwgxD1wSWZJlzFn9wWbqLlhOQuXfLXwsYTGufFT2wpQTM8uwn51cZrMCCt48h5QEXYL1ItCtYvFXRnnyGP9fLtu3iGHs+cDLFjYJeKDXfwqHWgU/ADt1QJDzfJbuOX35gsQEQIzAkupwgJkDf59GNuyGh9FndpM1JZ+l1XHVdukPu2wGfk+iKLeOzmSiHyuHaNas8sxEZO/LloOp6SJJVRt2BloqQNxRao0uZFOPTEwAwaCdZWDTmZPswON+4Sm2iEoO48vyQTiLbrlrl1ALQwZ8qvFnzBmIL/KzXnkz/yY87QPc4yd3njQVV+gErUlFo6OlczGO1cM2ptsn0aIFS4ruTpBkFQqgWPPmQ/rf4ErkYIpLpcSlnBf+FcKMIoSI1oKYe2XPQ8wjHLf/suQu+pHqTLUHagwcq4ObHZH1a9uwuH/LAiJngcnK1Zl9yVTBRNcD4Fc3fuKO20GmEUfVRX9H38mc01+4/QafJRMUMxXfBhI8ySGFVF0Y+Xn1lPebKY1ZHcqM7mDafekftBhcKA8MnrjFf0kUVE7Fdp/ai6tnEhcG/FX5modth/9JUs2BfzB4I5hJs6h4tK1VHc//V/vz8Uiv+CBaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently AS_NO_DIRECT_MAP maps and unmaps pages on-demand, which means
there is no control over the batching of TLB flushes. Where it's
supported, this patch switches it to use ALLOC_UNMAPPED instead. This
means that pages are provided by the allocator that are already absent
from the direct map, so TLB flushes are maximally amortised.

The tricky bit is that those pages need to be zeroed. The solution comes
from the mermap, which allows zeroing the pages before mapping them into
userspace, without mapping them in the direct map.

Any system that can set_direct_map_*() can also use ALLOC_UNMAPPED, but
the mermap is arch-specific and not supported everywhere, so the slow
path needs to stick around as a fallback for those systems.

Zeroing logic needs to differ between the fast and slow path:

- The fastpath must use the mermap while the slowpath can just zero via
  the direct map.

- The existing usecase for AS_NO_DIRECT_MAP zeroes folios before freeing
  them. That's because they've been restored to the direct map so they
  are now vulnerable to sidechannel attacks and other read
  vulnerabilities. That re-mapping doesn't happen in the ALLOC_UNMAPPED
  case so zeroing isn't needed there.

The upshot of all the above is that it becomes very inconvenient for
AS_NO_DIRECT_MAP's _users_ to zero the pages. With ALLOC_UNMAPPED it's
not possible for the page allocator itself to zero the pages. So, this
leaves the page cache in the middle as the natural place to handle
zeroing.

Rather than create any complex semantics, this patch just tacks
the currently-desired zeroing logic on as a side-effect
AS_NO_DIRECT_MAP. Later, if users arise that have different zeroing
requirements, more AS_ flags could be added, or this logic could be
shuffled elsewhere to afford the necessary flexibility.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mermap.h  |   2 +
 include/linux/pagemap.h |  38 ++++++++++++-----
 mm/Kconfig              |  14 ++++++-
 mm/filemap.c            | 108 ++++++++++++++++++++++++++++++++++++++++++------
 mm/internal.h           |  39 +++++++++++++++++
 mm/mermap.c             |  37 +++++++++++++++++
 mm/page_alloc.c         |   6 +++
 mm/page_alloc.h         |   3 ++
 mm/secretmem.c          |   6 ---
 9 files changed, 222 insertions(+), 31 deletions(-)

diff --git a/include/linux/mermap.h b/include/linux/mermap.h
index 5457dcb8c9789..762a23b909f9c 100644
--- a/include/linux/mermap.h
+++ b/include/linux/mermap.h
@@ -28,6 +28,8 @@ static inline void *mermap_addr(struct mermap_alloc *alloc)
 	return (void *)alloc->base;
 }
 
+void mermap_clear_folio(struct folio *folio);
+
 /*
  * arch_mermap_flush_tlb() is called before a part of the local CPU's mermap
  * region is remapped to a new address. No other CPU is allowed to _access_ that
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 011f6e34859cc..16a41dca15c15 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -211,7 +211,12 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
-	AS_NO_DIRECT_MAP = 11,	/* Folios in the mapping are not in the direct map */
+	AS_NO_DIRECT_MAP = 11,	/* Folios in the mapping are not in the direct map.
+				   They are also zeroed before being added to the mapping, but
+				   this is separate from and incompatible with __GFP_ZERO. They
+				   are also zeroed again on removal if they get restored to the
+				   direct map. */
+	AS_MERMAP_STALE = 12,	/* A folio in the mapping may require a mermap TLB flush. */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -362,20 +367,13 @@ static inline gfp_t mapping_gfp_constraint(const struct address_space *mapping,
 	return mapping_gfp_mask(mapping) & gfp_mask;
 }
 
-/*
- * This is non-atomic.  Only to be used before the mapping is activated.
- * Probably needs a barrier...
- */
-static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
-{
-	m->gfp_mask = mask;
-}
-
 static inline void mapping_set_no_direct_map(struct address_space *mapping)
 {
 	WARN_ON(!can_set_direct_map());
 	/* folio_zap_direct_map() doesn't support large folios. */
 	WARN_ON(mapping_max_folio_order(mapping));
+	/* Incompatible with ALLOC_UNMAPPED. */
+	WARN_ON(mapping_gfp_mask(mapping) & __GFP_ZERO);
 	set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
 }
 
@@ -389,6 +387,26 @@ static inline bool vma_has_no_direct_map(const struct vm_area_struct *vma)
 	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
 }
 
+/*
+ * This is non-atomic.  Only to be used before the mapping is activated.
+ * Probably needs a barrier...
+ */
+static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
+{
+	WARN_ON(mask & __GFP_ZERO && mapping_no_direct_map(m));
+	m->gfp_mask = mask;
+}
+
+static inline void mapping_set_mermap_stale(struct address_space *m)
+{
+	set_bit(AS_MERMAP_STALE, &m->flags);
+}
+
+static inline bool mapping_grab_mermap_stale(struct address_space *m)
+{
+	return test_and_clear_bit(AS_MERMAP_STALE, &m->flags);
+}
+
 /*
  * There are some parts of the kernel which assume that PMD entries
  * are exactly HPAGE_PMD_ORDER.  Those should be fixed, but until then,
diff --git a/mm/Kconfig b/mm/Kconfig
index bdd3e083520c0..7f01d90e10ef0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1341,6 +1341,7 @@ config SECRETMEM
 	default y
 	bool "Enable memfd_secret() system call" if EXPERT
 	depends on ARCH_HAS_SET_DIRECT_MAP
+	select PAGECACHE_NO_DIRECT_MAP
 	help
 	  Enable the memfd_secret() system call with the ability to create
 	  memory areas visible only in the context of the owning process and
@@ -1507,12 +1508,19 @@ config MM_LOCAL_REGION
 	bool
 	depends on ARCH_SUPPORTS_MM_LOCAL_REGION
 
+# This doesn't directly enable any code, it just exists to combine other
+# features - anything that needs AS_NO_DIRECT_MAP should "select" this config
+# and, wherever the platform supports it, that will change the default of those
+# other features which make AS_NO_DIRECT_MAP more efficient.
+config PAGECACHE_NO_DIRECT_MAP
+	bool
+
 config ARCH_SUPPORTS_MERMAP
 	bool
 	select ARCH_SUPPORTS_MM_LOCAL_REGION
 
 config MERMAP
-	bool
+	def_bool PAGECACHE_NO_DIRECT_MAP
 	depends on ARCH_SUPPORTS_MERMAP
 	select MM_LOCAL_REGION
 
@@ -1528,7 +1536,9 @@ config MERMAP_KUNIT_TEST
 	  If unsure, say N.
 
 config PAGE_ALLOC_UNMAPPED
-	bool
+	# It doesn't actually depend on the mermap, but with current usecases
+	# one isn't useful without the other.
+	def_bool MERMAP
 	depends on !HIGHMEM
 
 config PAGE_ALLOC_KUNIT_TEST
diff --git a/mm/filemap.c b/mm/filemap.c
index bf62fee570d8b..db66cd6466330 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/dax.h>
 #include <linux/fs.h>
+#include <linux/mermap.h>
 #include <linux/set_memory.h>
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
@@ -242,13 +243,56 @@ static void filemap_free_folio(const struct address_space *mapping,
 	folio_put_refs(folio, folio_nr_pages(folio));
 }
 
-#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
+/* Fast version: pages are already unmapped, but need zeroing. */
+#if defined(CONFIG_MERMAP)
+static inline int prep_add_unmapped_folio(struct address_space *mapping,
+					  struct folio *folio)
+{
+	int err;
+
+	if (!mapping_no_direct_map(mapping))
+		return 0;
+
+	err = mermap_mm_prepare(current->mm);
+	if (err)
+		return err;
+
+	mermap_clear_folio(folio);
+	mapping_set_mermap_stale(mapping);
+	return 0;
+}
+
+static inline void prep_remove_unmapped_folio(struct address_space *mapping,
+					      struct folio *folio_ignored)
+{
+	if (!mapping_no_direct_map(mapping))
+		return;
+
+	/* Folio is not going back in the direct map so no need to zero it here. */
+
+	mapping_check_flush_mermap(mapping);
+}
+
+static inline void prep_remove_unmapped_batch(struct address_space *mapping,
+					      struct folio_batch *fbatch)
+{
+	prep_remove_unmapped_folio(mapping, NULL);
+}
+/* Slow version: zap and flush direct map on-demand. */
+#elif defined(CONFIG_ARCH_HAS_SET_DIRECT_MAP)
 static inline int prep_add_unmapped_folio(struct address_space *mapping,
 					  struct folio *folio)
 {
 	if (!mapping_no_direct_map(mapping))
 		return 0;
 
+	/*
+	 * Note under this configuration, we could have just allocated with
+	 * __GFP_ZERO. But for consistency with the ALLOC_UNMAPPED version it's
+	 * forbidden, so zero manually.
+	 */
+	folio_zero_segment(folio, 0, folio_size(folio));
+
 	return folio_zap_direct_map(folio);
 }
 
@@ -259,6 +303,7 @@ static inline void prep_remove_unmapped_folio(struct address_space *mapping,
 		return;
 
 	folio_restore_direct_map(folio);
+	folio_zero_segment(folio, 0, folio_size(folio));
 }
 
 static inline void prep_remove_unmapped_batch(struct address_space *mapping,
@@ -267,26 +312,31 @@ static inline void prep_remove_unmapped_batch(struct address_space *mapping,
 	if (!mapping_no_direct_map(mapping))
 		return;
 
-	for (int i = 0; i < folio_batch_count(fbatch); i++)
-		folio_restore_direct_map(fbatch->folios[i]);
+	for (int i = 0; i < folio_batch_count(fbatch); i++) {
+		struct folio *folio = fbatch->folios[i];
+
+		folio_restore_direct_map(folio);
+		folio_zero_segment(folio, 0, folio_size(folio));
+	}
 }
+/* AS_NO_DIRECT_MAP unsupported. */
 #else
 static inline int prep_add_unmapped_folio(struct address_space *mapping, struct folio *folio)
 {
-	VM_WARN_ON(mapping_no_direct_map(mapping));
+	VM_WARN_ON(!IS_ENABLED(CONFIG_PAGE_ALLOC_UNMAPPED) && mapping_no_direct_map(mapping));
 	return 0;
 }
 
 static inline void prep_remove_unmapped_folio(struct address_space *mapping,
 					      struct folio *folio)
 {
-	VM_WARN_ON(mapping_no_direct_map(mapping));
+	VM_WARN_ON(!IS_ENABLED(CONFIG_PAGE_ALLOC_UNMAPPED) && mapping_no_direct_map(mapping));
 }
 
 static inline void prep_remove_unmapped_batch(struct address_space *mapping,
 					      struct folio_batch *fbatch)
 {
-	VM_WARN_ON(mapping_no_direct_map(mapping));
+	VM_WARN_ON(!IS_ENABLED(CONFIG_PAGE_ALLOC_UNMAPPED) && mapping_no_direct_map(mapping));
 }
 #endif
 
@@ -1055,31 +1105,53 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 EXPORT_SYMBOL_GPL(filemap_add_folio);
 
 #ifdef CONFIG_NUMA
-struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *policy)
+static inline
+struct folio *__filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *policy, unsigned int alloc_flags)
 {
 	int n;
 	struct folio *folio;
 
 	if (policy)
-		return folio_alloc_mpol_noprof(gfp, order, policy,
-				NO_INTERLEAVE_INDEX, numa_node_id());
+		return __folio_alloc_mpol_noprof(gfp, order, policy,
+				NO_INTERLEAVE_INDEX, numa_node_id(), alloc_flags);
 
 	if (cpuset_do_page_mem_spread()) {
 		unsigned int cpuset_mems_cookie;
 		do {
 			cpuset_mems_cookie = read_mems_allowed_begin();
 			n = cpuset_mem_spread_node();
-			folio = folio_alloc_node_noprof(gfp, order, n);
+			folio = __folio_alloc_node_noprof(gfp, order, n, alloc_flags);
 		} while (!folio && read_mems_allowed_retry(cpuset_mems_cookie));
 
 		return folio;
 	}
-	return folio_alloc_noprof(gfp, order);
+
+	if ((gfp & __GFP_THISNODE))
+		return __folio_alloc_noprof(gfp, order, numa_node_id(), NULL, alloc_flags);
+
+	return __folio_alloc_mpol_noprof(gfp, order, get_task_policy(current),
+			NO_INTERLEAVE_INDEX, numa_node_id(), alloc_flags);
+}
+
+struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *policy)
+{
+	return __filemap_alloc_folio_noprof(gfp, order, policy, ALLOC_DEFAULT);
 }
 EXPORT_SYMBOL(filemap_alloc_folio_noprof);
+#else
+static inline
+struct folio *__filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *policy, unsigned int alloc_flags)
+{
+	return __folio_alloc_noprof(gfp, order, numa_node_id(), NULL, alloc_flags);
+}
 #endif
 
+#define __filemap_alloc_folio(...)				\
+	alloc_hooks(__filemap_alloc_folio_noprof(__VA_ARGS__))
+
 /*
  * filemap_invalidate_lock_two - lock invalidate_lock for two mappings
  *
@@ -1986,6 +2058,15 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 	return folio;
 }
 
+static inline unsigned int mapping_alloc_flags(struct address_space *mapping)
+{
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+	if (IS_ENABLED(CONFIG_MERMAP) && mapping_no_direct_map(mapping))
+		return ALLOC_UNMAPPED;
+#endif
+	return ALLOC_DEFAULT;
+}
+
 /**
  * __filemap_get_folio_mpol - Find and get a reference to a folio.
  * @mapping: The address_space to search.
@@ -2074,7 +2155,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			err = -ENOMEM;
 			if (order > min_order)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
-			folio = filemap_alloc_folio(alloc_gfp, order, policy);
+			folio = __filemap_alloc_folio(alloc_gfp, order, policy,
+						mapping_alloc_flags(mapping));
 			if (!folio)
 				continue;
 
diff --git a/mm/internal.h b/mm/internal.h
index 089c53bf9a336..eea26ee57f765 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -255,6 +255,43 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 	return err;
 }
 
+#ifdef CONFIG_MERMAP
+static inline void mapping_check_flush_mermap(struct address_space *mapping)
+{
+	/*
+	 * Note this flush is hugely over-aggressive: only the mermap region
+	 * needs flushing, but assume that flushing the whole address space is
+	 * faster. Also only certain mm's (most of the time, just current->mm)
+	 * actually have stale entries, but assume the benefit of tracking that
+	 * would be minimal.
+	 *
+	 * Probably more important: the TLB has likely already been flushed
+	 * anyway for unrelated reasons since the mermap got used. If/when this
+	 * is shown to matter, the simplistic address space flag will need to be
+	 * replaced with something more deeply integrated into other TLB
+	 * flushing logic to enable proper amortisation.
+	 */
+	if (mapping_grab_mermap_stale(mapping))
+		flush_tlb_all();
+}
+
+/*
+ * VMA is being closed, i.e. mm might be losing logical access to the contents.
+ * For AS_NO_DIRECT_MAP, the folios were mermapped so stale TLB entries need to
+ * be removed to prevent CPU sidechannel leaks.
+ */
+static inline void vma_check_flush_mermap(struct vm_area_struct *vma)
+{
+	if (!vma->vm_file || !vma->vm_file->f_mapping ||
+	    !mapping_no_direct_map(vma->vm_file->f_mapping))
+		return;
+
+	mapping_check_flush_mermap(vma->vm_file->f_mapping);
+}
+#else
+static inline void vma_check_flush_mermap(struct vm_area_struct *vma) { }
+#endif
+
 /*
  * If the VMA has a close hook then close it, and since closing it might leave
  * it in an inconsistent state which makes the use of any hooks suspect, clear
@@ -262,6 +299,8 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
  */
 static inline void vma_close(struct vm_area_struct *vma)
 {
+	vma_check_flush_mermap(vma);
+
 	if (vma->vm_ops && vma->vm_ops->close) {
 		vma->vm_ops->close(vma);
 
diff --git a/mm/mermap.c b/mm/mermap.c
index 2bead38eadfe8..2ac1d59c1b1cd 100644
--- a/mm/mermap.c
+++ b/mm/mermap.c
@@ -336,3 +336,40 @@ void mermap_mm_teardown(struct mm_struct *mm)
 
 	free_percpu(mm->mermap.cpu);
 }
+
+/*
+ * Zero a folio via the mermap.
+ *
+ * This should be decoupled from the mermap implementation; it could be moved
+ * outside mermap.c if a better place arises to put it.
+ */
+void mermap_clear_folio(struct folio *folio)
+{
+	unsigned int numpages = folio_nr_pages(folio);
+	struct page *page = folio_page(folio, 0);
+	void *mermap;
+
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHMEM));
+
+	/* Fast path: single mapping (may fail under preemption). */
+	scoped_guard(migrate) {
+		mermap = mermap_get(page, numpages << PAGE_SHIFT, PAGE_KERNEL_NOGLOBAL);
+		if (mermap) {
+			void *buf = kasan_reset_tag(mermap_addr(mermap));
+
+			for (int i = 0; i < numpages; i++)
+				clear_page(buf + (i << PAGE_SHIFT));
+			mermap_put(mermap);
+			return;
+		}
+	}
+
+	/* Slow path, map each page individually (always succeeds). */
+	for (int i = 0; i < numpages; i++) {
+		scoped_guard(preempt) {
+			mermap = mermap_get_reserved(page + i, PAGE_KERNEL_NOGLOBAL);
+			clear_page(kasan_reset_tag(mermap_addr(mermap)));
+			mermap_put(mermap);
+		}
+	}
+}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f39b6af3a6b73..4f923a7a18459 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5902,6 +5902,12 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 	return page_rmappable_folio(page);
 }
 
+struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid,
+					unsigned int alloc_flags)
+{
+	return __folio_alloc_noprof(gfp, order, nid, NULL, alloc_flags);
+}
+
 struct folio *folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
 	return __folio_alloc_noprof(gfp, order, nid, NULL, ALLOC_DEFAULT);
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index be83a974edc2b..c4bf3a83c68d5 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -282,6 +282,9 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
 
+struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid,
+					unsigned int alloc_flags);
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
diff --git a/mm/secretmem.c b/mm/secretmem.c
index c043c53687d95..798f1766bdc27 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -111,14 +111,8 @@ static int secretmem_migrate_folio(struct address_space *mapping,
 	return -EBUSY;
 }
 
-static void secretmem_free_folio(struct folio *folio)
-{
-	folio_zero_segment(folio, 0, folio_size(folio));
-}
-
 static const struct address_space_operations secretmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
-	.free_folio	= secretmem_free_folio,
 	.migrate_folio	= secretmem_migrate_folio,
 };
 

-- 
2.54.0


