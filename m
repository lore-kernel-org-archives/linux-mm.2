Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88323F3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED06E6B0096; Sun,  5 Apr 2026 08:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81176B0098; Sun,  5 Apr 2026 08:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96876B0099; Sun,  5 Apr 2026 08:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB7756B0096
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:54:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8134F13BFAB
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:03 +0000 (UTC)
X-FDA: 84624494766.08.A85D766
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9ED2C1C000E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CTgRG7S4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393641; a=rsa-sha256;
	cv=none;
	b=gynDjMxjaqwZMQsGtx+d3X3HLzwgVzptGWuhj9joandvUcbfLJilgf8wqVCG1Jk/+s/ivc
	QXpms5dohTcM2WN2gCUxrklrApv+amFbWQGHaotWR7MmevqF66FBPksZvpuGrpMO1ZrD5J
	R5KN6MmuV200SrS61NdRt80TXX58l7E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CTgRG7S4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDmw/QSiGpmicKvHs3oRyZcvGRBcNXeGZ4EHaUFkJWQ=;
	b=zxKF2k2/7zSBT5ddLsRqyecj0T7Cl72NssFbEtkIohjfPgfuQD4IV1CGMXAIR+PLnPI6yc
	VCPr7vB6CLhAVExuFO12rsD1qri5lGqxpTKXaIGB+dsqq6BGDzrmv0zFguumwnWdxZN5Bi
	zcdVrOXRyaITQ1Whx42P6+Zq/XohJc8=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so2874842a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393640; x=1775998440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XDmw/QSiGpmicKvHs3oRyZcvGRBcNXeGZ4EHaUFkJWQ=;
        b=CTgRG7S4gNWNDvLwtojwuVUOIaT/G/taiH2vXQVyl9ahe5xYjn9evWsjLcZOfGCs59
         MVTb8wrRKxx0gRpPatbPdSTDkDxDTe818dyhHEOwoo/TaoBOTQ4BVjykucBysU6+Zl8U
         wJLGcfXb7r5Qk+OsveKB4OtmHIvRVVowUGH2bOJxRmEGAW/3KwYQmGyDIm8odAmVZMRJ
         45JN+kYy1Qj03jJdBlohknyaKR7dZYMSQPO7nZgxP77AL3YrHG7lW2n9g6ZGSS6xTU4i
         Qgh/nbenqqzcmGM0Ji5j40iDFWzDZaVd+LXDJj1fiwUbfRW8LRuUJvs95gik0YZp32vi
         ILtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393640; x=1775998440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XDmw/QSiGpmicKvHs3oRyZcvGRBcNXeGZ4EHaUFkJWQ=;
        b=JMyZLaSo5elRnuNBtzWT1lRbklsbyngSXZqKonogt8cANYBVR3X6bQlYjwx+Cg8CtC
         FZCSB6XsTDfHb7EZxL54HwYbY0uop7v7fvQXvbgbmy7tiqcY6QHwxugrZ6bRUN008yBq
         ucCpJcyW0673hfRbdgIE1OpAwArnZaFggTsQtU9m108401CioPUlvMQhMeNE/f+OQZAU
         gRvECBJPhfpPo9BvQbn7I60q4ZE68XdlyHLQLD2aJuQDzOPBTcbqmkjSYxx4NEsgs+K6
         hKVyqEg49e2b0354P0LgYUwZuUqZkPSAhsIJ0TYBiecvJykx9aQrogX3YHW6Q/40Xjk5
         MknA==
X-Forwarded-Encrypted: i=1; AJvYcCWou/inF/nW+2bCyvXe8upvC7HBfXhGJZSBuWfmdGK6bZppG1Crl0og3YEkEb0TO0NDf2T3g8BNQw==@kvack.org
X-Gm-Message-State: AOJu0YynlgLgv8xtp77M2ERa+PTUXT+/7QjMFs8NZ1ALFO1PRFTtSHak
	bLkP+1dV3Xm1qqOTdUXP9rfAoQT9Vh04hI9lURM13TJGxIVfGFBz0Gk1TZu8HpFVfZ8=
X-Gm-Gg: AeBDiesgQ+JqA8iVSPBcc1xEeAnzFN7TFohWW0PrPpQiwnuevOGRDNDX+mLQFgmZ6mn
	zHdOa5/vOK7JHDt7o9KCRliqbE5FRlgSL/k4nOdr5Hq1uXJ3Ny4Ngk5TAbQ80kuxbgUHkUg9wg0
	x7Kpu0IsIWh2XrSQuwai+QkqH4ERuxv8wjAjadrP3g6ZjtpmUX17hhAzQE4xSV2rO/obbpY4CLL
	5gydpq6fZcR2OpQRXafndM3YO9YZ6oKSKOYpWui7OL+XAOC8Cbgn+sqz2tBY8so+ERen8RFz8qS
	VPsRL1OA+GOidDoLyobTiPyTDQhXWAaHB3huOfyHLSVrO4fd4/OkDZUvLJw3lXM+Q1PLZub6MhE
	cwBKsXq9z0p2oaR15JD/2CAMvs5h0gMP5QhfzMvObhSm1bXJ/0bG7v1tpkCtxRnCvoZyXLx2Rmz
	qTQ0eLGGJXO12/rYfi3SjH3bfSFXvTLeb6d/uYXfVNjV0=
X-Received: by 2002:a17:90a:d005:b0:35d:9d28:e897 with SMTP id 98e67ed59e1d1-35de699f483mr8490321a91.28.1775393640457;
        Sun, 05 Apr 2026 05:54:00 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:54:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 06/49] mm/mm_init: fix uninitialized pageblock migratetype for ZONE_DEVICE compound pages
Date: Sun,  5 Apr 2026 20:51:57 +0800
Message-Id: <20260405125240.2558577-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fdqwpdznn5tsw64rfkhygux9fci9477k
X-Rspamd-Queue-Id: 9ED2C1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775393641-960628
X-HE-Meta: U2FsdGVkX1+Ih4Us5BahFgKC2RLzCRa5E+X2HnAHW6nMDc/ZcuaFq7LLDzd/ogdynpfdGvhKCbZ0kye8d/39x5pNdZ4LtYFJKUmD8Xdh2f4DlCq6GbiWWvtaVVjBPPqY2dyuGG2sNARJCCdsyVYh4WLzSWw1KZ3qHhCqjPyQxb7ti7MONy1vELlP7nX6bpp04X2tpCIFqi65SP6xGWCZyb8MH06kK069XVnUtc0ORIFvKBgUEmr/FLyWt3+kqpy4LRkxpsjVZvA7d51/3CpFyk9i+h0Mlhq1dHYSyKT8TrvhxTZTPqdjXZzXJBeQ1osbmVyDz9zzcBgkqzbHEFlZfwr5oSsDzx1Ej36ubJyY7njrD9JweoI9mbyxBzeGfohENajBsmV/tpH8fQevV51gIjE5AJFPiGiJgNIjODpoYcCPjOIH7InU6Ui4ckUc3qDmDXXZwc5RsyCx7G5uxuoVnuAM4xui//Bna6yyw4ELaf0Pw3+YsF23xBQiHZAd0e42Bd1sr2InNuHHY6bWlCTRkS294vsAonhj27lJJceq4dkPy2j25b2IU8GtIQuRn41CFYLGz0VpXG8oxMvNNoPa0y81QtIA9gJCLOqT2mpfT34Gp1NF9vEXgkVVKmkyD5S/3ddyzDFKGM865K6kwlha0UfXN9Z3A/82WLYqQM4L2hYvycHfIbEekIWCKGzCTaIa/5xJ8utSmXh+nEMyy+1ExWDva0/jopA3IqCBpMcg1pCK/jtf7bTniYb7WrgAdpoLqSIK/xBNMHzlyE4vgImj0kmPpDSV1CjH1v+Er4YCzo9p3lZ+yYAMJeco8EbHVHLw+cc2tN/NEPQPQwxdbCwlCZnPrLekMZ3032l/Qn7YaeO5+PFbAybS7TSTEAYLumapxOD8HedR5eraI3KO6h5Pe1FPMD0a5veVBbulKCIUJGkl/Cv+NALuMYQWWHxu1DOrlDIKH7NSw8pac+Ye+4u
 rtGlwuEI
 QFfOku6Ccuh4xsbtM95MgRyhDAZqz4Xm3e+20ZWnlEQhXklREDDiSXJVO6x3HWyXASJIkenDEfcp5eap+zgwKjcLGMl4Onp+xs4+YgL4+P94RVRDNluyu6Q6Pe6IzNpXJfNejAeOHyNpve8y5uF4aLvXD/27Y42/6tE/ng5gcoB7jloJnjnvWKeL8BeSHwGjCJ9G1/MaaX5hz69IFgh2uDQPydN2fumEHWrrP4d+O0BAgFpZM3ZAnZl/Ej9z9QIINSeMIlk60D/RMdYFM5aQYtzUcsG/YWrX3rnznCsKWQzAHZwqDqwiORdcZ6hgDAZz9F8jpT6jQQ07XPp2Mou6EIjtMhtae/ZTg2O1UIi86b30uknA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, memmap_init_zone_device() only initialized the migratetype
of the first pageblock of a compound page. If the compound page size
exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
subsequent pageblocks in the compound page would remain uninitialized.

This patch moves the migratetype initialization out of
__init_zone_device_page() and into a separate function
pageblock_migratetype_init_range(). This function iterates over the
entire PFN range of the memory, ensuring that all pageblocks are correctly
initialized.

Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9a44e8458fed..4936ca78966c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,6 +674,18 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
+static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
+						       unsigned long nr_pages,
+						       int migratetype)
+{
+	unsigned long end = pfn + nr_pages;
+
+	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
+		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
+		cond_resched();
+	}
+}
+
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
@@ -1011,21 +1023,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
 
-	/*
-	 * Mark the block movable so that blocks are reserved for
-	 * movable at startup. This will force kernel allocations
-	 * to reserve their blocks rather than leaking throughout
-	 * the address space during boot when many long-lived
-	 * kernel allocations are made.
-	 *
-	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
-	 * because this is done early in section_activate()
-	 */
-	if (pageblock_aligned(pfn)) {
-		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
-		cond_resched();
-	}
-
 	/*
 	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
 	 * directly to the driver page allocator which will set the page count
@@ -1122,6 +1119,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 
+		cond_resched();
+
 		if (pfns_per_compound == 1)
 			continue;
 
@@ -1129,6 +1128,18 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(altmap, pgmap));
 	}
 
+	/*
+	 * Mark the block movable so that blocks are reserved for
+	 * movable at startup. This will force kernel allocations
+	 * to reserve their blocks rather than leaking throughout
+	 * the address space during boot when many long-lived
+	 * kernel allocations are made.
+	 *
+	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
+	 * because this is done early in section_activate()
+	 */
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
-- 
2.20.1


