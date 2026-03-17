Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6486FFED9EF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF646B00A5; Tue, 17 Mar 2026 12:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59496B00A6; Tue, 17 Mar 2026 12:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48466B00A7; Tue, 17 Mar 2026 12:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1E06B00A5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A58F1C5B9
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:45 +0000 (UTC)
X-FDA: 84556161690.13.8073349
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AA41C1C0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KmWEQkLl;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMUd+SYWs8B2q4ls48305Lry3I8nGAJg9tthGQC4bOk=;
	b=Y7BTHG3fNhd8fYNpa4GMEHqBf8BslYZdMRzrrU4C5P63j7ZrjkRGu901nYsPMwnX2agumk
	JBWD8QbLMhB5y7EG1WU8v/5BNOErmX59iL6ng9koigNNb+s8yzCe7o3EwAcq8A+Dlav0SY
	g7HgmQKl9durvCNxPTXZHoXfzqMhsO8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KmWEQkLl;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766663; a=rsa-sha256;
	cv=none;
	b=WeTSkyb6qMsgdJFwhnmZa7lnmhNygUAzs1e7DPWPNBxCDuw0HV9TvnwGYTspgKlNePcD8Y
	Z7I8KU7viw+e8WH1ysNqZAgSNvTndYxyIj6psdBvkd78r+cQ/PZJYPis2WVXQARrWHH+M0
	pYjTKlYKIrb+ldA9csqkqosIHaCl1Oo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB3B2443E3;
	Tue, 17 Mar 2026 16:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16983C19424;
	Tue, 17 Mar 2026 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766662;
	bh=t9H4ODpg5R9njK15JZW6Bi4180ghG2kDbMh/t4uFB5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmWEQkLlFIjSPQY6yvikDH1PeDIr1/5cT7bLQciS8NbHXDZqmdvmajSV63q3bc2Lp
	 cekuWl/0KKVBqGfTb5TDH8N9Xia066PNeWOJTKNTmKRDkJ6khtp8r/hI2pWZil1oPo
	 IbYkOH07uW+2PiEzjJDhD0KdJqT2UQqh/yBiVv4IJw93+K8vtYgDq1IDglC+kbq89V
	 63IwLnQkYDS8Z+CK5PuzThH1cQyUTE5EHxIKzhyV6Us7IKlCzkwmtTNMHz9kf3D3zk
	 PN3WKrd11bXAX1UkLT4AYWkpKiobdnePmBdxkfIc3FqzO94Eu1hI4Ftzll0msAKtJ2
	 pQAtDXr1ruXCw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 10/14] mm: prepare to move subsection_map_init() to mm/sparse-vmemmap.c
Date: Tue, 17 Mar 2026 17:56:48 +0100
Message-ID: <20260317165652.99114-11-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 961g8dbshr85axwpk8wk1wpyggjgbbdx
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: AA41C1C0005
X-HE-Tag: 1773766663-453322
X-HE-Meta: U2FsdGVkX19shuu58bH9r9J4TFG5mg+29ysg11sthe9gUk8GPE+z0v9NciJ21sHlR6qH6ov1jzHJZZEUOXr5kbTrX6aJOCfkM1Q0hyWK3huNIp0mZvi1V5p/ea5rYOGitoQ3ReWqX9UuF91VA/bpxWdLJ1ZNENjpKDxR+d5QKRrcNZ1s95WnnQBiwgASc7Kw2W4x+nAjZaSIt/ncwAEg/yfIOyYwptEmIyOw+1rpnL/jPwkU2yueNWI7QfibySmlI0RXO8ceV8EqvktmMZ0ycNc12pXUboZLcvnR8BVk3Uaj5SYxW5VP4/+ijgOBn9cn9Y2z12rWgl/wnPdeHJk4i0tBWlvVEBbFwbHFR5RPJ0FMgZEWuassik/2wseGGHXVJtWNMetu7GOHFcjyVo9P+wuuLvMJFqARuIzE4B0rhVsnYJv05QPNf5miOxa1myeiYDeKAvysdkx2hobqwfKBih0Glsubg3vkZ6b5AMaA8PNYTD3z73g9lZH6fLU6UL3593T9TNOkcv8HqPr+3t8dR0m2c7cpk05OnOEbdCZEaKt2X4SNRzM2Kd+lhNGYlasFb1cqDib/YpXMhpCAYMht5n9PGyy8n+c0xtExd/z1eXnRz9jNsp4Y+TfMxMFFVRhjb4IbsQjQZ07271jNDe5E/yqa9dHnvyVZ62ViGcHLky9Ajljh+pe3NSZTXroSGqReXapV/6vv79slOxds81XXONTxWa/GjlzhP3i7hh+qj6f5ixrG65kin1BRTiV4061XD9fkGi4/qQIz0PNtqnGAItCHwinCkQ4Omd03R++PVCyJ4Rcytv+l0fti1AG4hIsOnmh63n40hFl0iP+QE2jdxr8VFuHfBmpGiQzu25MHZil5GW84uVJrVvfNK8pYInja5FJ2R1hXb20yvs/I/Y0Tn+DnxLmUUOhdEnqfLomuTO9BRdlYBb29hGZbFq6q5wq5BfvvFoGNOIi6MhfvDzJ
 6CMlatP0
 o0oW0fJHBMGJTusdCC3/Oa0dYvBfEXzyd25zG0YqefPQkmHb4WavG69Wupp8vxUxfn/mFGt9oY9TlP8n094vrjrL1b9bnU0St37BEPDBBdoAh42e6TxsN9V4q9Wrp4vmQxvMe2xqPpitz1ZUbu1hLrRgB8ipkvrJ203oTbDfC1r3ctjpsvUNNUhlCrZl7ZCYTaSgWwLG1G/Ogwpauf006MSJSmvUqIVO4VHl1siJECnEyfKACVEj44PO4tmPup5KjZe7EzeaHzfNE4YDv78scKoxSqWuVAVuA/bDO1GeE6r0mB1DZ3rI1p3V/ET1NR08dQZaY
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
index b57c81e99340..7b0bfea73a9b 100644
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


