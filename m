Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870EF1099B47
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1D76B00EF; Fri, 20 Mar 2026 18:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9EF6B00F3; Fri, 20 Mar 2026 18:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07636B00F4; Fri, 20 Mar 2026 18:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF2696B00EF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 693E1160395
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:32 +0000 (UTC)
X-FDA: 84567846384.15.13B21FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B82AA18000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IHLJ7uy8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhaoYTTPLtVHbgALS5/K0z1LYMcB3auYjAQ9rtaeCjk=;
	b=CJj+tZK8WG0ArDJpzHDoFy/jw8LUjHqJv3bx21MdeeFjlaSUzdXWRGeLuHmmt5KiptUXVO
	TAar9SEpgdPVIJBvv8gNxyPQC+ympA4rwgIw9Z7rXQzxu5Ye0nMbq5O7c5cQVclyuYhCMf
	oj3nTUAjCWwN0g86jUcLIPNzAC7RJzs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IHLJ7uy8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044870; a=rsa-sha256;
	cv=none;
	b=osggnMByCoxwsrFCuYO9sDhmpRUtTQwYvV6nmCtOPJ3o6Os8aa47HaL482kOUKchvtKopG
	53GwQCyXQ6PDQlWnob2UVHJmeEXnIb4Xbpsop0oBDjPWamXWXFiKi+aMAFtGfQSTa0QNs5
	CpdX16zLXebNqG8zAei2+Mi7AY6R2W4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 448866014C;
	Fri, 20 Mar 2026 22:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBCBC2BC87;
	Fri, 20 Mar 2026 22:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044870;
	bh=96Y5hAnwqjZz29h98raybd4EwBxokxu/LgenBd+sLbQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IHLJ7uy8oSWAv0WFrwtVAb5aqpsuUpirtjWzxOOeikkn8Cnj9WwzIvvRij484C45D
	 sDFL5mLdqScUm2fzsvdEC1JdLzvfsyk36kWc35PHmbWLs9cVbdiJLPGF62cKICafDO
	 FvnFCZhQ8o637F4GYescmIZk/JpTP9gIjiPNGg/V4UZUriDHGypjOdxwvdW0FCR0K/
	 1WFbCMNsgJnoktrK7x7yyswl4f1lMAvZ7eR9vfmwjEr8qzpMoFgMx8wbw1VC/InmpH
	 XRuHYmRJ+fUci09hGRGZwOpykKU7rmJk/cRic01Os9XnQTPnJfW0X7UsPtpQ+w+21D
	 OWMtzKPIBKBBg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:43 +0100
Subject: [PATCH v2 11/15] mm: prepare to move subsection_map_init() to
 mm/sparse-vmemmap.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-11-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B82AA18000B
X-Stat-Signature: fsn4t5b3ustai9ha4b4onim1z4idtk5e
X-Rspam-User: 
X-HE-Tag: 1774044870-523401
X-HE-Meta: U2FsdGVkX1+3AqXkqEhPq6TmC1x92KOoH4AAavJy5TNO4mQ2YmN1IGcIjN7enpaUHPcRfB8e8oAZmTn7kZGpH6LhRuP7VRsg46eUm+FO0nOLOoGNlXuY31OqE09ouUtfW2MEfc6ADh+AN+j040cav/h5x4Q3FE3ZdwUQZCf7uZk9fs1KRrda33vFjlyCychic3F9/t4ZjnG4d5T1zEGLW0TFe+tSPbRExLTs7WlbVL0qKN+Pujejr6xZcWGFYaY0Par8b1tCOPYHffHDVbLzX9Q4gQMNFOnkn2Y0whcVISPVJbGm2FX+kCFLUWVD+bU+i6tf7zf3HuG1j/wWRL0C5HRTXWYpbTfuNvOlaeTAueyyCstJCkHm7Hugn2q3vB0LhzlYK+XJLfqUwUSLZlcYYiAaWlAknskJ8HPxyyRSdXtK5RKtAG0lyWQGNZLyX/jQFD+4rspT+lMJGEJ9tjCNic4F+Tbcis9IE36h3d8wN1RejfwSY/OcoODcXRkLS6u1PqDQiN/yrTfOkCUQSG7x2S6fDh5mWg7RUpnq1MJGMmPjNQGA60OswD85w17pkKknwUdoRUX44hKltk3EtaWBdfvgAj1ETWGLqTLQHmt32MjN6ZInRL3tl7Cb7gZtmQnnsS4GTEM0NWbdOrahZNazifrQva8YNKKBt6UvfPWn8ww4g3v0nmbhMhVlUX3iQEte9AU4Oily9OTbofo9tHqkvGsvXxLu2Wv95rtypj6N4vagnbfWVXBzLpwOlVWfdTV7u19ZzPnikBuZJ/YuwvOLyhIHeYSkTrwmBQZh07sO4i1YWJBqZoH00XGoHFxNM71Wx4vO9ezXztG1rX9tShe3LOAaxPbFxRWnpuL/tRqhhnOcTQWhzmaHMdphoelJbUt8LlTw486Ns9NTVTc8I3ZjaEv78Kglw0kCujkY9FBFxgWJd/PwaYai2hCeo5geQA2ZgxGecwhg1b+XtWsXTzi
 xBXzxwAv
 stPMUQWRmlyNI85RrMzKwa4CuEH1Q+Hn6SjveE+PGzrPTBZ5UHzVIZWJq1vk+50MQNkbdWTY3VOgAD2j5m8crWdfzNzMS1sLeNUStxvp1YWRKbjaw86/+pVrqcu+LqqYBSmuCfUdi2rEeibJCLaljUKqI9LUEFPWXSZrxsfD4H+E35EDdJH+ategqpYH20oluyaUPK0eA7T2DNSxeToMHQCdBxPZp8af+OiCdp31+qCpsJ1i69FFFqRar7j6lCOwgV/tA69wHMmB1la4ZShWQfn0tAzQLS6cydekDkwUDELwK7KLTr5bcR8h597c4FdYdx8OS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to move subsection_map_init() to mm/sparse-vmemmap.c.

To prepare for getting rid of subsection_map_init() in mm/sparse.c
completely, use a static inline function for !CONFIG_SPARSEMEM_VMEMMAP.

While at it, move the declaration to internal.h and rename it to
"sparse_init_subsection_map()".

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmzone.h |  3 ---
 mm/internal.h          | 12 ++++++++++++
 mm/mm_init.c           |  2 +-
 mm/sparse.c            |  6 +-----
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7bd0134c241c..b694c69dee04 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2002,8 +2002,6 @@ struct mem_section_usage {
 	unsigned long pageblock_flags[0];
 };
 
-void subsection_map_init(unsigned long pfn, unsigned long nr_pages);
-
 struct page;
 struct page_ext;
 struct mem_section {
@@ -2396,7 +2394,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
-#define subsection_map_init(_pfn, _nr_pages) do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
 /*
diff --git a/mm/internal.h b/mm/internal.h
index f98f4746ac41..5f5c45d80aca 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -960,12 +960,24 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
 		unsigned long, enum meminit_context, struct vmem_altmap *, int,
 		bool);
 
+/*
+ * mm/sparse.c
+ */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
+#else
+static inline void sparse_init_subsection_map(unsigned long pfn,
+		unsigned long nr_pages)
+{
+}
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 969048f9b320..3c5f18537cd1 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1898,7 +1898,7 @@ static void __init free_area_init(void)
 		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
 			(u64)start_pfn << PAGE_SHIFT,
 			((u64)end_pfn << PAGE_SHIFT) - 1);
-		subsection_map_init(start_pfn, end_pfn - start_pfn);
+		sparse_init_subsection_map(start_pfn, end_pfn - start_pfn);
 	}
 
 	/* Initialise every node */
diff --git a/mm/sparse.c b/mm/sparse.c
index e2048b1fbf5f..c96ac5e70c22 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -185,7 +185,7 @@ static void subsection_mask_set(unsigned long *map, unsigned long pfn,
 	bitmap_set(map, idx, end - idx + 1);
 }
 
-void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
+void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
 {
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
@@ -207,10 +207,6 @@ void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
 		nr_pages -= pfns;
 	}
 }
-#else
-void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
-{
-}
 #endif
 
 /* Record a memory area against a node. */

-- 
2.43.0


