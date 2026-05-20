Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D02CCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2D06B00A0; Wed, 20 May 2026 11:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47EEC6B00A3; Wed, 20 May 2026 11:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7816B00A1; Wed, 20 May 2026 11:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 020D76B00A0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF9771A0371
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:46 +0000 (UTC)
X-FDA: 84788110092.04.7468FC5
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id C5ACD4001C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=lLaK9KSw;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nz5aqOVAk4HZQUBK+B668PusNEBvbV/K+dHsAIcLF6E=;
	b=gk1+nbMe74ZcxyUX32ULRvSC79Kcp17e1h72QhSYzV6jlQMy7BPeN08jRDDQU9KYFtYZbj
	No1VhL2AFaE+uNLxSfK2GL4YvZCoO3S8/b/9nihQ+NUzMFL3OQozK/KOPiZ5q4htFZQtWM
	cGmv3PjuB3GeQ+45qQvSwgJ7I4pRIJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289244; a=rsa-sha256;
	cv=none;
	b=RQ/zCjV13zO9Efw8ZqiSdLii28fuQD4rxQKJIet3eLjSje3nTh5c1x+4fXSXGMMqvwvVSx
	z967OjIB3dcYGDMpOXOEXGb0QTheUtChk/3DmnEfAXdrDFfudVyCAMTtMq+TTZqOLIcDtM
	Y35PBQC6QPXka5vMk5TiWd1d67pXBjk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=lLaK9KSw;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Nz5aqOVAk4HZQUBK+B668PusNEBvbV/K+dHsAIcLF6E=; b=lLaK9KSwr9B0+Ln0fPn71YTk0v
	7nWKTiBemGexrkmtUwG361FY6TI4Kt9zoF2A83StwBtG+Nn/4kPLM5oOV7MMawHneyz+RwW/a+7gL
	P4o2wlFqorkDkfbLr7y5pkHBBxU7KCr6lbnLTXfYUvfUVgehWqq1MfkXwfu3mn1yoFHqjNpc8YIuk
	XJ6+y0FNEe3uj84h0D6BkFhWHUDKsJ6y9OVDiWREOrAfmnBEXf3A2aavc/vASO7oYxDINOsVYEfWb
	2nsp+70I+nVGDXwuoapDn86AE9fCflAnsBh6NXa8+f6Z5kVhd8ge6M101OQhVyI65szdI4Fj8iD+b
	gPerttPw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-15DG;
	Wed, 20 May 2026 11:00:28 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 09/40] mm: page_alloc: support superpageblock resize for memory hotplug
Date: Wed, 20 May 2026 10:59:15 -0400
Message-ID: <20260520150018.2491267-10-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C5ACD4001C
X-Stat-Signature: 954dm1gnboch31ctf3yrrutmspijg3yj
X-Rspam-User: 
X-HE-Tag: 1779289244-386346
X-HE-Meta: U2FsdGVkX1+HtgHFsrQtXuehqOfTRUJJS5UkJFN8dTG+coE9YMnXT9nkNuFIbMixvi3UhC8MEsfEasmQ0dBniiEkDQxG82v1suWwd22RnkK7va1jBIUOCoOq3Axyo4RJNzTVNgdOhDDb6Fu6S05FXNGBYIbdXvQzHv7M4d3XOCyDBeJGR/Jltrz1ek0SpRHkQinScxazMmKeybvmtHMmMAaigomh1sDbM7HEMjmGOjkTx2mTyZUZC7jndQlqVzhkjuxAJJSSLjGOXABRMXe/6IL1U5Sf3XDN2oT5FmEF39SukPUmsK+GZ7dlnaVkRTzDUu9pseOkC4BIfJYFjN3NmO4XPS54u0bObOQLN2gAe3aEPDGRoA/rcDkLer5qYfNK//UBUO/DVy3HcW4rl2syUkpfMvdrU/Z590BqA/d69CNNFyawEvCCYhVgj6yRAO++WlxzHupPAQgfqhHVe3v/JwqyXbsX5tUhh4Tr6jyVOKZyIx21k57yCP83mcH+nd9XQUOeOTqISYVVHInS7jGq3Wi0yMy4BtASby6obwQyLc4vpaYMByfedR1IbRp15hkXbfkGr+3PyMLx5FgZM/8E6oNKmPbK+wf3Yc5K69D+oFdDH+wnt2+WdMsbc1Lz18ZNrL0HUEaKgaYIr8SnYUimdMbpBL5NkxElElA1nk4OzVxuSFj03SeewC4TxNpql2ZPER125hnrfkV3JAfpFC6jpd/fNkCjr/dPB5lWZGhERwkvphXfwVj9dntIGM172KyI4xqXKR/Fer8TwnxVjwL3LQuw+hY49HXOB4Vh/zLPMCfCjNxgmIZnbk078gZMKSEFGHWiDN+ozKJzfsWDO7byNq6fZv+E3hGhB4ZrgsOJLDiJ4kpUsgxVW3YHcD+7UShxftUA0vCdnBVYIhkkubRTzhng2tp5/iHlN+SkfbtaxqKkKuW7AzhXe598pF36KfEalXuma1DkJ53gOkE8g3m
 YfJPRbRt
 QhNm2u941GGGjRW0xE8JytwFHQuCoxvSkpIHkQZnE8eBZQlsBiCfH6DmHVZtgdfOKEIzFluEUEIyvqUSuhh7WiHqgVasxZm5KLHN/v1znwD1+MbQjsJwOGFCQrevddBzQZUIU4hTBcxmQCNoe7Yv9S05nK3F2ytaBo/5M02Uj27FFd3vwFg0AxOnCgUwacsE/GImpkhQ4xmZpNf7s0DcvstRvJDbmnzXt3ZHONX4kh9m4Hsg8q1H0o6yQkpt/roavKXVwIphOrfyFEOGhXwVNCoZjJvadN4AFhFSPvBZyfoq7e40n7C+UkbRRmYwIsz+6tu87
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

setup_superpageblocks() is __init-only and uses memblock_alloc_node(), so
hotplugged memory that extends a zone's span has no superpageblock
coverage.  Pages in those regions would bypass superpageblock steering
entirely.

Add resize_zone_superpageblocks() which is called from
move_pfn_range_to_zone() after the zone span has been updated. It allocates
a new superpageblock array with kvmalloc_node() covering the full zone
span, copies existing superpageblocks (fixing up list head pointers), and
initializes new superpageblocks for the added range.

Use round-up division for partial pageblock counting to match
init_one_superpageblock().

ZONE_DEVICE is excluded since device pages should not participate in anti-
fragmentation steering.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |   1 +
 mm/internal.h          |   4 ++
 mm/memory_hotplug.c    |   4 ++
 mm/mm_init.c           | 138 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 147 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e3eac971a76a..19190328e0c7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1057,6 +1057,7 @@ struct zone {
 	struct superpageblock	*superpageblocks;
 	unsigned long		nr_superpageblocks;
 	unsigned long		superpageblock_base_pfn; /* 1GB-aligned base */
+	bool			spb_kvmalloced; /* true if from kvmalloc (hotplug) */
 
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
diff --git a/mm/internal.h b/mm/internal.h
index c8404cb00b08..6a089bc4aa09 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1101,6 +1101,10 @@ void init_cma_reserved_pageblock(struct page *page);
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+void resize_zone_superpageblocks(struct zone *zone);
+#endif
+
 struct cma;
 
 #ifdef CONFIG_CMA
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a943ec57c85..b7c30dfdce8e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -752,6 +752,10 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	resize_zone_range(zone, start_pfn, nr_pages);
 	resize_pgdat_range(pgdat, start_pfn, nr_pages);
 
+	/* Grow superpageblock array to cover the new zone span */
+	if (!zone_is_zone_device(zone))
+		resize_zone_superpageblocks(zone);
+
 	/*
 	 * Subsection population requires care in pfn_to_online_page().
 	 * Set the taint to enable the slow path detection of
diff --git a/mm/mm_init.c b/mm/mm_init.c
index de02a6087c21..ad1cbc2b4498 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1592,6 +1592,144 @@ static void __init setup_superpageblocks(struct zone *zone)
 					zone_start, zone_end);
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+/**
+ * resize_zone_superpageblocks - grow superpageblock array for memory hotplug
+ * @zone: zone whose span has been extended by hotplug
+ *
+ * Called from move_pfn_range_to_zone() after resize_zone_range() has
+ * updated the zone's span.  Allocates a new superpageblock array covering
+ * the full zone span, copies existing superpageblocks (fixing up list heads),
+ * and initializes new superpageblocks for the added range.
+ *
+ * Must be called under mem_hotplug_lock (write).  No concurrent
+ * allocations can occur since the hotplugged pages are not yet online.
+ */
+void __meminit resize_zone_superpageblocks(struct zone *zone)
+{
+	unsigned long zone_start = zone->zone_start_pfn;
+	unsigned long zone_end = zone_start + zone->spanned_pages;
+	unsigned long new_sb_base, new_nr_sbs;
+	unsigned long old_offset;
+	struct superpageblock *old_sbs;
+	struct superpageblock *new_sbs;
+	bool old_kvmalloced;
+	size_t alloc_size;
+	unsigned long i;
+	int nid = zone_to_nid(zone);
+
+	if (!zone->spanned_pages)
+		return;
+
+	new_sb_base = ALIGN_DOWN(zone_start, SUPERPAGEBLOCK_NR_PAGES);
+	new_nr_sbs = (ALIGN(zone_end, SUPERPAGEBLOCK_NR_PAGES) - new_sb_base) >>
+		     SUPERPAGEBLOCK_ORDER;
+
+	/* Already covered? */
+	if (zone->superpageblocks &&
+	    new_sb_base == zone->superpageblock_base_pfn &&
+	    new_nr_sbs == zone->nr_superpageblocks)
+		return;
+
+	alloc_size = new_nr_sbs * sizeof(struct superpageblock);
+	new_sbs = kvmalloc_node(alloc_size, GFP_KERNEL | __GFP_ZERO, nid);
+	if (!new_sbs) {
+		pr_warn("Failed to allocate %zu bytes for zone %s superpageblocks\n",
+			alloc_size, zone->name);
+		return;
+	}
+
+	/*
+	 * Copy existing superpageblocks to their new position.
+	 * The old array covers [old_base, old_base + old_nr * SB_SIZE).
+	 * The new array covers [new_base, new_base + new_nr * SB_SIZE).
+	 * old_base >= new_base always (zone can only grow).
+	 */
+	if (zone->superpageblocks) {
+		old_offset = (zone->superpageblock_base_pfn - new_sb_base) >>
+			     SUPERPAGEBLOCK_ORDER;
+		memcpy(&new_sbs[old_offset], zone->superpageblocks,
+		       zone->nr_superpageblocks * sizeof(struct superpageblock));
+
+		/*
+		 * Fix up list_head pointers that were self-referencing
+		 * (empty lists) or pointing into the old array.
+		 */
+		for (i = old_offset; i < old_offset + zone->nr_superpageblocks; i++) {
+			struct superpageblock *sb = &new_sbs[i];
+
+			if (list_empty(&sb->list))
+				INIT_LIST_HEAD(&sb->list);
+			else
+				list_replace(&zone->superpageblocks[i - old_offset].list,
+					     &sb->list);
+		}
+	}
+
+	/* Initialize new superpageblocks (slots not covered by old array) */
+	for (i = 0; i < new_nr_sbs; i++) {
+		struct superpageblock *sb = &new_sbs[i];
+		bool is_old = false;
+
+		if (zone->superpageblocks) {
+			old_offset = (zone->superpageblock_base_pfn - new_sb_base) >>
+				     SUPERPAGEBLOCK_ORDER;
+			if (i >= old_offset &&
+			    i < old_offset + zone->nr_superpageblocks)
+				is_old = true;
+		}
+
+		if (is_old)
+			continue;
+
+		init_one_superpageblock(sb, zone,
+					new_sb_base + (i << SUPERPAGEBLOCK_ORDER),
+					zone_start, zone_end);
+	}
+
+	/*
+	 * Update existing superpageblocks whose nr_reserved may have
+	 * increased due to the zone span growing into them.
+	 */
+	if (zone->superpageblocks) {
+		old_offset = (zone->superpageblock_base_pfn - new_sb_base) >>
+			     SUPERPAGEBLOCK_ORDER;
+		for (i = old_offset; i < old_offset + zone->nr_superpageblocks; i++) {
+			struct superpageblock *sb = &new_sbs[i];
+			unsigned long sb_start = sb->start_pfn;
+			unsigned long sb_end = sb_start + SUPERPAGEBLOCK_NR_PAGES;
+			unsigned long pb_start = max(sb_start, zone_start);
+			unsigned long pb_end = min(sb_end, zone_end);
+			u16 new_pbs = (pb_end > pb_start) ?
+				((pb_end - pb_start + pageblock_nr_pages - 1) >>
+				 pageblock_order) : 0;
+			u16 old_pbs = sb->nr_free + sb->nr_unmovable +
+				sb->nr_reclaimable + sb->nr_movable +
+				sb->nr_reserved;
+
+			if (new_pbs > old_pbs)
+				sb->nr_reserved += new_pbs - old_pbs;
+		}
+	}
+
+	/* Swap in the new array */
+	old_sbs = zone->superpageblocks;
+	old_kvmalloced = zone->spb_kvmalloced;
+	zone->superpageblocks = new_sbs;
+	zone->nr_superpageblocks = new_nr_sbs;
+	zone->superpageblock_base_pfn = new_sb_base;
+	zone->spb_kvmalloced = true;
+
+	/*
+	 * The boot-time array was allocated with memblock_alloc, which
+	 * is not individually freeable after boot.  Only kvfree arrays
+	 * from previous hotplug resizes.
+	 */
+	if (old_sbs && old_kvmalloced)
+		kvfree(old_sbs);
+}
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-- 
2.54.0


