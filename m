Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACCE4C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9AA6B00AC; Mon, 21 Sep 2026 16:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9D46B00AD; Mon, 21 Sep 2026 16:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72166B00AE; Mon, 21 Sep 2026 16:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 803116B00AC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:00:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E56E1C2178
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:56 +0000 (UTC)
X-FDA: 85238837712.17.819EEE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 41BEC180016
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T5IMW0BP;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwyBwRForlDJQnveIzB8Y6RYc+5OT4f8Qi/OV+McEOM=;
	b=eJqB+mNQFbtSYVykOqTZiY7wturxGZf1PLuLa4Nfi4if/EBSZaV8GJqbRASpWkMyqw/o7l
	fABgb1OxXeqSPYOFHFQtDrolBy+5rLLQGTLBqsprb4a1bHJR1BULl1UoMopYaZpOln552G
	Bkd5nfEayf4DMvzQfRIV0lvAqlMDPzw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020854;
	b=LhLVq5KCzk78vVUw7zp+85cPf+TOylIphT4YOzaTJRTJskgMr/zHjWT4YnZpNkYsRpdfYU
	Siw10wKaNeB7sD2ZF+RELd0I7+kVqVprxmu2B7xgeG2gZUdjSmRBff8GYUYtnOk13W1IXL
	SpXqmpY8S3g7jsNeCcRvMBev5F3BAqo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T5IMW0BP;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9652B406C5;
	Mon, 21 Sep 2026 20:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033791F000FF;
	Mon, 21 Sep 2026 20:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020853;
	bh=nwyBwRForlDJQnveIzB8Y6RYc+5OT4f8Qi/OV+McEOM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T5IMW0BPHepTvBlGz/FCLKDCkabRE/4OBx4krrRKgGhjjVw4VZ7ljtWpfETow1Foe
	 xfJCWDD4BEybD4K8awP78HneQy1KJhcUsopNseIdHZ8mXcw5G7wn6H+HYnO+++skth
	 b7MGDUmHiC7fPPuZN0WmEGfGxEMD/EPkHgFFug1p/yWZGdlULy5FbWrfk2mOdpVbYS
	 Pa/6h70MFF5yOx6C3S0FmIkGSoiEQL2a3o9wAttrm8DVw36oZaxIz234/H4x9AOIIb
	 HCi2m0UtF1dm/O1t9NM7QZrZNUiQLZfInH59nTXQgJvSYNYDuWbQmsqYBl7tPe8Nrx
	 mqhXlY1CUs+Zw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:59:02 +0200
Subject: [PATCH v2 10/13] mm/sparse: remove SECTION_MARKED_PRESENT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-10-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8047; i=david@kernel.org;
 h=from:subject:message-id; bh=Kj43xG8ptu7m5f83Ilnopm8xJGaEKq2XJfrEsdD2UAU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rQFbX66n61c6pB6UMoGEb/ac8nKsYltbD8vrDv2a
 +ZRrerrHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzkahvDP/POFy/lLXTFf6yV
 77yvIu14b8YBtrquVxwLbFjPT288s4uRoUVQVHRn09ve5p9T5ByaGf41ZO4PWlLtfFVZwIHjsoI
 mEwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 41BEC180016
X-Stat-Signature: y488aebe4g6zscydod58fq1iae8bpshi
X-Rspam-User: 
X-HE-Tag: 1790020854-615063
X-HE-Meta: U2FsdGVkX1+OUa8H+3qp+JHU537SsY5Uwj+vjdEkZe8hbW/9Usx9IlgKXlT+T41cv76qc4B5L223UbFX8zX35YC3g5/outsSdvFxQdDQlQ7GBvtgqX9fvVYXXOKAItQVpMUSs1sRYTOX/m9obn8uxM3kukDyGJ+pewjqZ2JURq6KpMXj7AIY6n8o0lD+nXBub1SDZ2IQNJBgcP7GVDvhuXvAw9FpW9EWQnItG2UfW6JwJsmdmNx2HyuedQRzuc0fSnfpBFrZw5Z6vebroqi1EBofGCaRmzimQydwAYu+qKOpPcFyapjeMtxFSNjedjo8Ad65jxcd0jzfzlleTbjKQUA6FkJQp4aS2NxJEnGDHhz3b19UCaRw7O46UskoVq8+8eN9dLYEEZHycH8ITzYGk6PLzes8G++7Td/7EGjSaFRFYK1q8GUpdxu4BSvJFCwQIBuoVSgY+ckad1qA3QUnwcoiB8lPyK0NAVpjDxQSbfaEPQbsPkcaqGqXMJeEBkVmr0nw8OWXulOqmVVhXvr6/VP89Hk+Vv16UMdBL/jGKTSibzOotD5PtJiPznD5SdI9mrLtAsq7PtXFs9U58n5EJXgca6BqqDmIMR+rp6+Mn/OAq2HZS8o8okDnNFQ+nv5k3xBAg2EzkEAQfRYNidennCwoWXe+78FEw5hbR7MEKzBm8st1JY+N/vI1JIw/Z2KMS+s73T3R5xrpcOJ5dVqHnX7sc7JeO2DwjYJraTTdv8lDoVIy69yhhq/dj6EPffg6QeJyF8U3tKP+/7ko44384LUimcr9LU6RULLSBkoYfDXuSNVTdlttX0G4ZDb4TFae5SNDvr/oryBXlgHgC7y0uuTJhKbrSkFzUS5uE8EnLvGe7x+eZSAaODBuZZZ3btYET7ffEYyjYVZ0wO9AmRtYWx1GW0F0jv6CP+XTj13gQj8CCj6l5lm7GDTq9QuogByYxtHd+9MnYnlA10PI0nu
 1TgMxf4e
 S3MKcnQdmfYWwrJdSl6eQWcKPoHUhcpt6qLlpKUJGmq5X0uDdd0co5C8aFsdt+HpNtQ6HtI+Zf3jSon8LdPIt3IpEbTXadBCJBfBzjaNa3Qy4fR67jC0v5RPvMb7LlWCalaVp04pAmwSb23M2PIZu20V3VJRqgGomRDGJEIYFIue9v5yCLVhoWt2cHUsMabbX/ELhec6rkBGk7osY8eedkSWVjkoMPpWuC8bY4PqLu8msS5Ejg6NQr62Z5yo2M0ol6R/OPdn6hpTm+ExqTJdOPFhsONkhlwTvJhwpSCS6XCl3erg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All present section iterators run before memory hotplug added any
further memory sections, Therefore, we can simply use the SECTION_IS_EARLY
flag by setting that flag earlier in sparse_sections_init().

Get rid of SECTION_MARKED_PRESENT entirely and rename
for_each_present_section_nr() to for_each_early_section_nr().

Take care of the .clang-format for_each_present_section_nr() handling.

No functional change intended.

Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 .clang-format          |  2 +-
 drivers/base/memory.c  |  2 +-
 include/linux/mmzone.h | 27 ++++++++++-----------------
 mm/sparse-vmemmap.c    |  1 -
 mm/sparse.c            | 17 ++++++++---------
 mm/sparse.h            |  6 ------
 6 files changed, 20 insertions(+), 35 deletions(-)

diff --git a/.clang-format b/.clang-format
index 5ef5743b77c95..395292ab2ac63 100644
--- a/.clang-format
+++ b/.clang-format
@@ -282,6 +282,7 @@ ForEachMacros:
   - 'for_each_dpcm_fe'
   - 'for_each_drhd_unit'
   - 'for_each_dss_dev'
+  - 'for_each_early_section_nr'
   - 'for_each_efi_memory_desc'
   - 'for_each_efi_memory_desc_in_map'
   - 'for_each_element'
@@ -403,7 +404,6 @@ ForEachMacros:
   - 'for_each_possible_cpu_wrap'
   - 'for_each_present_blessed_reg'
   - 'for_each_present_cpu'
-  - 'for_each_present_section_nr'
   - 'for_each_prime_number'
   - 'for_each_prime_number_from'
   - 'for_each_probe_cache_entry'
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5eead3346f1e3..b0338de2f1d82 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -972,7 +972,7 @@ void __init memory_dev_init(void)
 	 * block so that it can be covered.
 	 */
 	block_id = ULONG_MAX;
-	for_each_present_section_nr(0, nr) {
+	for_each_early_section_nr(0, nr) {
 		if (block_id != ULONG_MAX && memory_block_id(nr) == block_id)
 			continue;
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a3937577fbfb2..73d9781cc1510 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2085,7 +2085,6 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
  * accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
  */
 enum {
-	SECTION_MARKED_PRESENT_BIT,
 	SECTION_HAS_MEM_MAP_BIT,
 	SECTION_IS_ONLINE_BIT,
 	SECTION_IS_EARLY_BIT,
@@ -2095,7 +2094,6 @@ enum {
 	SECTION_MAP_LAST_BIT,
 };
 
-#define SECTION_MARKED_PRESENT		BIT(SECTION_MARKED_PRESENT_BIT)
 #define SECTION_HAS_MEM_MAP		BIT(SECTION_HAS_MEM_MAP_BIT)
 #define SECTION_IS_ONLINE		BIT(SECTION_IS_ONLINE_BIT)
 #define SECTION_IS_EARLY		BIT(SECTION_IS_EARLY_BIT)
@@ -2112,16 +2110,6 @@ static inline struct page *__section_mem_map_addr(struct mem_section *section)
 	return (struct page *)map;
 }
 
-static inline int present_section(const struct mem_section *section)
-{
-	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
-}
-
-static inline int present_section_nr(unsigned long nr)
-{
-	return present_section(__nr_to_section(nr));
-}
-
 static inline int valid_section(const struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
@@ -2137,6 +2125,11 @@ static inline int valid_section_nr(unsigned long nr)
 	return valid_section(__nr_to_section(nr));
 }
 
+static inline int early_section_nr(unsigned long nr)
+{
+	return early_section(__nr_to_section(nr));
+}
+
 static inline int online_section(const struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
@@ -2326,20 +2319,20 @@ static inline unsigned long next_valid_pfn(unsigned long pfn, unsigned long end_
 
 #endif
 
-static inline unsigned long next_present_section_nr(unsigned long section_nr)
+static inline unsigned long next_early_section_nr(unsigned long section_nr)
 {
 	while (++section_nr <= __highest_used_section_nr) {
-		if (present_section_nr(section_nr))
+		if (early_section_nr(section_nr))
 			return section_nr;
 	}
 
 	return -1;
 }
 
-#define for_each_present_section_nr(start, section_nr)		\
-	for (section_nr = next_present_section_nr(start - 1);	\
+#define for_each_early_section_nr(start, section_nr)		\
+	for (section_nr = next_early_section_nr(start - 1);	\
 	     section_nr != -1;					\
-	     section_nr = next_present_section_nr(section_nr))
+	     section_nr = next_early_section_nr(section_nr))
 
 /*
  * These are _only_ used during initialisation, therefore they
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e89efb67e8e6d..f0db433e0f10b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -864,7 +864,6 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (!section_vmemmap_optimizable(ms))
 		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	__section_mark_present(ms, section_nr);
 	__highest_used_section_nr = max(section_nr, __highest_used_section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
diff --git a/mm/sparse.c b/mm/sparse.c
index a0f50ca5acf5a..5d2d9f95d4024 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -170,13 +170,14 @@ static void __init mminit_validate_memmodel_limits(unsigned long *start_pfn,
  */
 unsigned long __highest_used_section_nr;
 
-static inline unsigned long first_present_section_nr(void)
+static inline unsigned long first_early_section_nr(void)
 {
-	return next_present_section_nr(-1);
+	return next_early_section_nr(-1);
 }
 
 void __init sparse_sections_init(void)
 {
+	const unsigned long flags = SECTION_IS_EARLY | SECTION_IS_ONLINE;
 	unsigned long pfn, start_pfn, end_pfn, section_nr;
 	int i, nid;
 
@@ -196,9 +197,7 @@ void __init sparse_sections_init(void)
 				continue;
 
 			set_section_nid(section_nr, nid);
-			ms->section_mem_map = sparse_encode_early_nid(nid) |
-							SECTION_IS_ONLINE;
-			__section_mark_present(ms, section_nr);
+			ms->section_mem_map = sparse_encode_early_nid(nid) | flags;
 		}
 	}
 	__highest_used_section_nr = section_nr;
@@ -230,7 +229,7 @@ static void __init sparse_metadata_init_nid(int nid,
 	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	for_each_present_section_nr(start_section_nr, section_nr) {
+	for_each_early_section_nr(start_section_nr, section_nr) {
 		const unsigned long pfn = section_nr_to_pfn(section_nr);
 		struct page *mem_map;
 
@@ -244,18 +243,18 @@ static void __init sparse_metadata_init_nid(int nid,
 			      section_nr);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
-					mem_map, usage, SECTION_IS_EARLY);
+					mem_map, usage, 0);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
 
 static void __init sparse_metadata_init(void)
 {
-	unsigned long start_section_nr = first_present_section_nr();
+	unsigned long start_section_nr = first_early_section_nr();
 	int nid_begin = sparse_early_nid(__nr_to_section(start_section_nr));
 	unsigned long section_nr, nr_sections = 1;
 
-	for_each_present_section_nr(start_section_nr + 1, section_nr) {
+	for_each_early_section_nr(start_section_nr + 1, section_nr) {
 		const int nid = sparse_early_nid(__nr_to_section(section_nr));
 
 		if (nid == nid_begin) {
diff --git a/mm/sparse.h b/mm/sparse.h
index c396d5c05cfc8..19664d702af84 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -42,12 +42,6 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	ms->usage = usage;
 }
 
-static inline void __section_mark_present(struct mem_section *ms,
-		unsigned long section_nr)
-{
-	ms->section_mem_map |= SECTION_MARKED_PRESENT;
-}
-
 static inline size_t mem_section_usage_size(void)
 {
 	return struct_size_t(struct mem_section_usage, pageblock_flags,

-- 
2.43.0


