Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48573C79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471DB6B00A4; Wed,  9 Sep 2026 09:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442BC6B00A5; Wed,  9 Sep 2026 09:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3317D6B00A6; Wed,  9 Sep 2026 09:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6946B00A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:35:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A192A01EB
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:20 +0000 (UTC)
X-FDA: 85194320400.15.57F517E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A0929A000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZLwWhoX;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBGQrCMxkvE0QOzXeJ7kYvO7SCxKh2lg8AgTwyZfi+M=;
	b=lDEGVoAtM78NKy075sV9s81Lqgk9/WeBqi2W/2xIHOOujJ2+HEGh2LYGVad66k4/nwMnQi
	KZcfB2uLCmskfdYdXpSCNCI0IfC798MqKpury+6C3PpkM0Q1ucNR1zzk3nDm4n0CxolufM
	Xbkn3eG3hb7a6cZnQZGaXQ/HaclLKxk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZLwWhoX;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960918;
	b=gwZv0aLq4Z4pQO2xbPgo0LVmwy4qYowLoQThfuO+jm4pQvbrYl6MIU6xsug7SWACUtuFwn
	CVZ+Bh5XEhZPwffKLKCWO6vAzCfEmmXDVQ94Cl7Xw1egYrocWV/ec6FdtHkyTR8Aqk931/
	z+FZadSVY/PSaKczz5gtP+EYspGrT9Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DECF60216;
	Wed,  9 Sep 2026 13:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138B71F00A3A;
	Wed,  9 Sep 2026 13:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960917;
	bh=fBGQrCMxkvE0QOzXeJ7kYvO7SCxKh2lg8AgTwyZfi+M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UZLwWhoX3lWXrf9WsF1UKXoWEIfmH/rvUBRquWmhTYW9CJp/XO7wzmfIN/Zqm651z
	 x9tPEWZZsqskkE9Pya7FExW89tjSqX5Jz8JUew/6l9EnDQkxNnxCLPJffLyQfRM3e0
	 nm7XhHmm0h6G0L4UTrJiLLKWRIRKfs5gSv34GfMtTly1fb360I15kX4fY5Br424rm1
	 sHh+rG7H3Nh7lpShT9PSjfplcTeAAaC2wxJGq1V4nYMSdueS1D0rVtMrLmvpM58odx
	 bAuBZys9lGRDF4X3jTIq85yBIFNN0BFk35Kk6HsgAW3+uShbg5BFBIztNtPC1ioSJE
	 p7THdbyIJIL8A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:33:02 +0200
Subject: [PATCH 09/12] mm/sparse: remove SECTION_MARKED_PRESENT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-9-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7818; i=david@kernel.org;
 h=from:subject:message-id; bh=pAqijJ/xtGVhn3ym5mqreVDB8QMgyWcSahLMC88vLlA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJpis8LDdZLhL67vVoh9SsSqed1RveiSuZVebFLcog
 fn9b+M9HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzELoGRYaaaEkPmwSkW+g9O
 ahZu/nh96Q62ILObQrXLO60S5q5/G8Dwmz3O6dIh2Vv7JJb/ab9yxlp/66dv3ZwNf/zXnwzP+/R
 0AxMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A0929A000A
X-Stat-Signature: be41p66anibsjca3oz8rht33a4344595
X-Rspam-User: 
X-HE-Tag: 1788960918-565546
X-HE-Meta: U2FsdGVkX1/ewya3jD3kMbS852zUPd2vUaND9XuBJksWH90gtGmu8ce5/O0JTCg/DfnDlnr1zgmVzNWQXlxY93Dw3VuckXUGX9NqoyXWLOOfmhBq/vnzByhCWrC1cwsfXEis1GgrPfM3fazQ6eNRjZZt5KA+z1gGqxtll3P/GV8DPg5Tgw2jHNkRhUl7N/paT9zZ2QKzOmxKOADbRZ6YTAepGvCRYuhujnRMJ03mSTAz18VXgM4visLTSQKdq+PbuUD8X4nqIDmpcRksp3KlJDWBR5DWm2N8LN6n6qC9lQqLs1Jw2nmZyY9Oe0fuwjrqTomLoWemsLnlR1/8XgEmoSLqfrQtanOVjWF2VxKVyGpaShW6q1kzJnZRXQDTVm9TO7z8/tSoMUzOJk9oJtxVDJMgmf2URP8Se1S0Ov59ohbPY06gGIbMz2rTBordN7TERaJbrf6+FLTxtw02V7ePyZAWef8dLcd5h5twjdxqKvS8/+nyd0NFFEbA9O9ad/ZsS4jUxLblz1ra8muGVSJyMak9Anv9JXMoSi889V4IguTU3sFKh03zhfqZ/4AmiVWtVM3vFyCC6q0V8PMtEgLzGgEFJ/b2IpsbJV5kBy6+w+v+pBa3gJ2MqcewEDDzkw1BYziN1HXbe5oKxwWoYWqLIcK3urb75weQ6BA2UavCDwEfXD7Q53x2ZaL15g7rB+MymSSWkTXReWNCBd/CJ/nVFeOHTliocg57464CpqrhYkbiXu5QczJ3/nH4SWgvBpIn05Oz2Vka31YnrJRI2/yWOkpOxVqXQEOB3+pavCyd2dXiCdGza7o4x86sI77AMS8+ttEljPeoBdvuYc3AdgPSX7TM/fnFC5I1xR6xbMVbys709pJXTQzWULcA57C1sJ1+72Xg3RtBrvlrNfKhsztaS3DNol93RVsu4+aPp0smdsFOJCu2Li29ZnyYcLrdxg75VsiHQoRKz1Vw1eY6kIO
 4d/6UNGQ
 2sW9zvlbK5sEAnns3LdSkJTHz+lqtC9JG5gA35DL6CW6WNIVsCOj5CWdOUz8mLdScWUWeXlNwh5NvDoZq7KmjZmLl82Sg/9kBYTWvM/Kf9eC5NptHuJuKTTBDJNZKbtHYWskjx6VyFBPzfq7bBrWcOkxUXJGiTL5OmE1QaRBoEofcYETPxgJC7FyXFevQjE+RK86jy6QhSJKPA8tEBRba16tqTUUFwVPHCNtmf2ZGVmAAkw7HiV+YLWB6uYMgc9r6FAEPZesociCF9GL1W5Ijsu5wVBUA1hZJF845QuMQnfvzsR5/L3ZATspS5wOEvNWrYxC5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All present section iterators run before memory hotplug added any
further memory sections, Therefore, we can simply use the SECTION_IS_EARLY
flag by setting that flag earlier in sparse_prepare_early_sections().

Get rid of SECTION_MARKED_PRESENT entirely and rename
for_each_present_section_nr() to for_each_early_section_nr().

Also update the gdb script to use the updated value for
SECTION_IS_EARLY.

No functional change intended.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/base/memory.c   |  2 +-
 include/linux/mmzone.h  | 27 ++++++++++-----------------
 mm/sparse-vmemmap.c     |  1 -
 mm/sparse.c             | 17 ++++++++---------
 mm/sparse.h             |  6 ------
 scripts/gdb/linux/mm.py |  2 +-
 6 files changed, 20 insertions(+), 35 deletions(-)

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
index e0fac344f6ac2..62cff59dd80c4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2084,7 +2084,6 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
  * accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
  */
 enum {
-	SECTION_MARKED_PRESENT_BIT,
 	SECTION_HAS_MEM_MAP_BIT,
 	SECTION_IS_ONLINE_BIT,
 	SECTION_IS_EARLY_BIT,
@@ -2094,7 +2093,6 @@ enum {
 	SECTION_MAP_LAST_BIT,
 };
 
-#define SECTION_MARKED_PRESENT		BIT(SECTION_MARKED_PRESENT_BIT)
 #define SECTION_HAS_MEM_MAP		BIT(SECTION_HAS_MEM_MAP_BIT)
 #define SECTION_IS_ONLINE		BIT(SECTION_IS_ONLINE_BIT)
 #define SECTION_IS_EARLY		BIT(SECTION_IS_EARLY_BIT)
@@ -2111,16 +2109,6 @@ static inline struct page *__section_mem_map_addr(struct mem_section *section)
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
@@ -2136,6 +2124,11 @@ static inline int valid_section_nr(unsigned long nr)
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
@@ -2315,20 +2308,20 @@ static inline unsigned long next_valid_pfn(unsigned long pfn, unsigned long end_
 
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
index e62e6aa07f126..5aba058df6b67 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -890,7 +890,6 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
-	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
diff --git a/mm/sparse.c b/mm/sparse.c
index 2d0f2db34f4cf..344acaaed94db 100644
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
@@ -231,7 +230,7 @@ static void __init sparse_metadata_init_nid(int nid,
 	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	for_each_present_section_nr(start_section_nr, section_nr) {
+	for_each_early_section_nr(start_section_nr, section_nr) {
 		unsigned long pfn = section_nr_to_pfn(section_nr);
 		struct page *mem_map;
 
@@ -246,18 +245,18 @@ static void __init sparse_metadata_init_nid(int nid,
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
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
index a3af4967fd5c5..03351f2467e34 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -114,12 +114,6 @@ static inline void sparse_init_one_section(struct mem_section *ms,
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
diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index 193a88d763abf..73d637d28c8e6 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -76,7 +76,7 @@ class x86_page_ops():
             self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
         except:
             self.SECTION_HAS_MEM_MAP = 1 << 0
-            self.SECTION_IS_EARLY = 1 << 3
+            self.SECTION_IS_EARLY = 1 << 2
 
         self.SUBSECTION_SHIFT = 21
         self.PAGES_PER_SUBSECTION = 1 << (self.SUBSECTION_SHIFT - self.PAGE_SHIFT)

-- 
2.43.0


