Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB41CCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D7B6B009D; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973316B009F; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6657F6B0098; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 397B56B0099
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04CDB1A0142
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:57 +0000 (UTC)
X-FDA: 84716346036.25.EE46732
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id 57AB2140004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=S0tTfhhq;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXh5ZvP6dVP8BqXhtS/Fexk+RZAZUZTT8D7jz6e5LRI=;
	b=GSGFOYXfeL708/aCo7OAREQLzrbu+jhD6s906vqajzSYTlwYCDBEHUXmVopqAUL14Sd/dC
	bu9ydsctQXREFX54yLjzGuCH471Mr4bdJMRIEOQ5hgvV7s7DzRdjgonNqivkVkN+RQmySC
	yMW84mPI7CnP5MajL5LN31bu8Aa9ScM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=S0tTfhhq;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580576; a=rsa-sha256;
	cv=none;
	b=HOEDC+dGrPiFu2Q2Bw455M4ni+0h3Y+YMNjvWzGEL6qZ8bklHyEnzs3uc43fRC83xALjhj
	OhSejIY1SLqbGsljCGpe5DR0AaBeaV/Y2tQEtYz+Tf/cwzYoG5g1h7x4vUpdLl9DTfFt6g
	julBuwWt1PiYI93lBs1fgE5cQRG+UZw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IXh5ZvP6dVP8BqXhtS/Fexk+RZAZUZTT8D7jz6e5LRI=; b=S0tTfhhqAgCt2WFehsBw07QggW
	yT8CYNUStmN8Gx/IERPm7MgxUwIrj/F1tyaYPeaei07jAhrfMNkaqMWhklgsZ96kuSbjcsoxWxQY2
	zWTslGIGGhmHskPnUL+k/6+ICjN8d2hjvnBX4nS3mHrWaBLUzCYCChZ+XrpYaXlIc4WXTZEJ15kwF
	aZCuJCilPFSSM2XmjOKzYyZoQQ3ATEGKLVCEjK4ZwqIpmBx0MefkBP/MLDeB3FQZIY5qgSzwzXPms
	/KpMtOGxpgn9ZcCiWQXRYLvJ6a4FotP/miOLUAlcmxGAzjsZNY7viTiY/RIbkb34yNxGFbBrMAHQp
	I4jyGF7w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-2mAC;
	Thu, 30 Apr 2026 16:22:40 -0400
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
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 10/45] mm: page_alloc: support superpageblock resize for memory hotplug
Date: Thu, 30 Apr 2026 16:20:39 -0400
Message-ID: <20260430202233.111010-11-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57AB2140004
X-Stat-Signature: uhuhoubqmzoh5u83fcmgucimynenniem
X-HE-Tag: 1777580576-524682
X-HE-Meta: U2FsdGVkX1+hDqYGCujFBeRj5qoc8+6sg8Y+/5OFg0as2qyRGnh/cDAtAWOKh3suy87/0dPTFg5tArEHYCWQJuQjDuModn68SV/czZ0Bk9pz5djAGk9YvLfBqH+HUmPhPKQpbqxn+ndMZiApZiTqu3q7Q2ORLEzfr5YnSxOAOZ3aYJhRQYB2V6kCRYChyeBGjwytQ2xFXsSoeEe0kt7o/pnDYFHH7xTq2JN6n4qVR3YaGtC3sG7NurULupcUpPRJOpSWfe9n35kgvOmMn8B2mgsqPmjW3n8mH/bILM6LwL6Di9W9ZNiP+UYxWjL0jmWut9tR0/Hv3CO4JzP7EvFw7qYrWaalQ0X7QelXka4R7+71TqnTuAPZ48OlEqZCKQz7qhvCDBxHd1HqITiXtyAv6QTO1zdApcWGsbYUScwAvNfQkZ/nDrKVgVX+QRrsfBLYkSIfhcmA0x1Srcj0kcwIL5bOuXu+YQJSWcsT4qDIDKPUqnfDiqnps9MENrQD6wa0fpDkRslmD1OWA+jyQW6NxRc95pJamcViAtHLlPE/8n+knthHYxn/xS4xD/C6HIes9pQsRG7p6Y9H1UpD41h+WA39qjsnuj7h1yg7SbQvKrgFpK1JoX5MS9RqqeBqwIV/bxqzSN/iDqkH3xTrk9HgfR7HDWPcAyXpuw4Q10Yi2xIOPteCqXY/OBDEZD1gDdH0G+PhhUMzKcf2wTrNOYGTyNvkDcD6rW6Fx2B2QS0ZVxk39y6Tv7dZu6XFwCuDE1U7ZI2C50TnmBmxMIXq9sxpYB/9jDSmbsz/38Nm8Zo+XdxFKyEDRQUuQIkQL8t7laU914diqcgv/8rzR4HmBcdVK/24O9kMmeLNyIlu5oZPCzgMxsEoojrOhk7xNWGVgvci0jM8GnlHqHXy7fIirx6/4YIynr7gxJMTJu8r/YW5r1cfBz1FTPFpTqJGkqwkuBHC9XR5tW6JVrG7ullT7i4
 4F/qgdXb
 ZWTZjwh0RQ38vjK+uMrv3x71/z6FIlQPgCh24Tqk+7UQESBbI4gItxlO/Ss6/GY4DxJpYbluZstlp+VNziCTUV8WezIGIduBnXra89BwLysP6Dl2mz0c9Ft0/R60qtHbKcOg0IbtB7jMJXKSWkuuwbx0ftYPDr3laMhThtLpfq/q2P/L/vLhKQqgftcEzZVTHIYscL4HWghhk6yIpC6dt7bI9PFVLGpCWds/sledML7xCdogXLKojOcbv2TfgnvStPKSBb+SyPBbvN6nn3VVMqQ/R6+o79tGtWYhi3qs5SVqL+1ytA1L8q2drwJot46rKG4hyx2tuyJjk407lvHyb/lX/kPY8v4S8q4kgBiW4hEkgGIQNFnWNp8FiFUVyFEwPdriJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

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
index a0e8ce4b7b79..c17ea237fe13 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -960,6 +960,7 @@ struct zone {
 	struct superpageblock	*superpageblocks;
 	unsigned long		nr_superpageblocks;
 	unsigned long		superpageblock_base_pfn; /* 1GB-aligned base */
+	bool			spb_kvmalloced; /* true if from kvmalloc (hotplug) */
 
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
diff --git a/mm/internal.h b/mm/internal.h
index bb0e0b8a4495..163ef96fa777 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1025,6 +1025,10 @@ void init_cma_reserved_pageblock(struct page *page);
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+void resize_zone_superpageblocks(struct zone *zone);
+#endif
+
 struct cma;
 
 #ifdef CONFIG_CMA
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc805029da51..e21fdb4f27db 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -760,6 +760,10 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
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
index 1fb62342d1c6..c5cf90de4d62 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1606,6 +1606,144 @@ static void __init setup_superpageblocks(struct zone *zone)
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
2.52.0


