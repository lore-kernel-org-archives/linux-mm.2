Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47530D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCCF6B03FA; Tue, 20 Jan 2026 08:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA486B03FC; Tue, 20 Jan 2026 08:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CA6C6B03FD; Tue, 20 Jan 2026 08:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88CEF6B03FA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:33:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4788F1A05B9
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:33:42 +0000 (UTC)
X-FDA: 84352434684.04.651D6C9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id F1E234000C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:33:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TdP4HPmm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768916020; a=rsa-sha256;
	cv=none;
	b=3QVH21mosd8mh2LrO6zM2eRt+XKNWosCEIY2fth5qXlf2RJemnqqmnkUp/9IH7+RZ2viSE
	zkiFSXH0g7LxmvqAr9bEVTyBNM24v2kyrtvFK7DyStmiARRnHc0x0eFk03PG4FEUR2xwvA
	XwXwFliQXxjTg6K6ph00J29F7ER1W6U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TdP4HPmm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768916020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOyRdhwzrW5Im4s/4QWGOZvKrykBQrVjwPx3561besY=;
	b=XVclT8SfWt9XiqEduxMogVIgSYeIb5eAsnbohJan3SG9sKEaGMzsJX0j28N6NSbZRaZhr7
	tP/M9V7G5NgDQlimSLZMvNeeWhPB1Xgy7lVsglkuiNE/Ls4pj73GMpmOcLGOSc1kKr+Ksd
	AEywxRvoChdsNuNrDrifuPpJO+leSrg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768916020; x=1800452020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sGg98/0mfkXeZaIF7/NLUeUNQ16GKxKIfCu6nxC+d64=;
  b=TdP4HPmmEfRTsUt8FX6qLRWshvfcFv4CHm6bxkmKUhSXiEmNy7WeR7Wi
   W4h38rjk4AjYl4eGisRw6MsaprDXM1k57YXAAjvMwdw/HZ1QcwPIci0p2
   O6cdaMVxB2DSRTPB7EjB7D6Bze3fNajZxHee7ap/Bay24/gXQAYRxeYHq
   PjiZn3Dhh6fHieg6wIa7rGXybNP24PXMqsOXF2ldqAdEg5WATavTYiksO
   LIXWknARLAljoCAUwIcjcffG4cAdhE5mn2G3FwwbwKM7+cLw+SJkXkHpv
   ykSAiJMHtbqoclPqHH+LxgJAcwu3wr4bw9SM7h7yh9v8G4lLXHNYDlICL
   g==;
X-CSE-ConnectionGUID: JTQtqwoGRUmL4K1KuBZonA==
X-CSE-MsgGUID: +H7pMErfSX2hWlEcfukiEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="81494862"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="81494862"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 05:33:39 -0800
X-CSE-ConnectionGUID: S+MvX06HQgqHMRKQsNBUiQ==
X-CSE-MsgGUID: Gz9yuQqbR9q/M8E47MMh+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210272049"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa003.jf.intel.com with ESMTP; 20 Jan 2026 05:33:35 -0800
From: Tianyou Li <tianyou.li@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 2/3] mm/memory hotplug/unplug: Add online_memory_block_pages() and offline_memory_block_pages()
Date: Tue, 20 Jan 2026 22:33:45 +0800
Message-ID: <20260120143346.1427837-3-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260120143346.1427837-1-tianyou.li@intel.com>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1E234000C
X-Rspamd-Server: rspam06
X-Stat-Signature: zyd8ywexe85qntnhggbun1gi1bkaui3z
X-Rspam-User: 
X-HE-Tag: 1768916019-501050
X-HE-Meta: U2FsdGVkX197w7K0q3HAe6J6BTjWOiRlTr5a/kEFugAKe4zQiuW1ysuYvoqKOHRxlkxR/LdofGQPj7tBtqvog5XmH64XJxvx1ZoPCexqGe6ChvE2WEt91KPt18v60HuEmEpzEqWBZRkmoU+5yc2lJwK4EKjCfDnbUjWi6SYhTxt/5v4zXn+3AgzC+l47/ZOccM1K6NzK/jurNEPqznJo1eky2x2tpDcMwwGAbS82/nSlqfbJkhjw4cECgiAvuB538FhFECYt6LB0EShHq7OuioS9/PICmYGnMDyOkVRRPCKo1HKCWOg5gNG7XwQko1pBLZcqc4+ddwzQW1gNP+lWzLl1SLmuZuLhtJ4DYv3yBY1/MCMgiAI+oOtKPq3o6jCfNV7bkfC9bqql3jaM0tWgFabr4T5IglnQrHr6jwuP77AZwNf4WmbEFDJm5RI1vUzMCptr/uP1ytT7EHyiLrAPMXALvB6lHis51daA9SiGDACNwcLlwN79N51U0Ru41UtA1Nsd3R8/KSrM21UJPwMdbBnED38HjhOvADpf+8VUF0QZZviLXLkCwdv1ivoa8nJ0mpAK2LDis7F76meBus2jHBgafV9NSiG2qSsgl5wVuzhbB7ylwQzGXXfs47jr1puiJVnioW+PNg667zXKBli2alXFVyYrrizDyrOZDY9rv1Mzq/hqfH8/1YxyQyQKbgXFKbkn9HEuNJt2rugjxfr0gzRNwfnF6ypIa/athDj34JiOycx7af2oFAyOp+yuwkNgjXM4xSemfwrvOJPYXnE2W+oK/MrrZiI3MXh2i7wGiYgrSFvXY3XGal/5PVu4y9wBXnvkcrn9RjprgBlX3SXwF1IcUxL3DMdCX967qBEMjRZF+a1co3IBI2qC4YS2kQEnuUlGF2SqEdPBW78HjdCvl0iXqcHbP2mLzqr7kW7Zuvdo+RIBXfO5Dw6kiAcCWdXV2QPAvTXGGXBX0rMsPkZ
 JkGPI9QB
 ZR2aZNLFEK8W3KLDjDLIjF9Q2bvVGHbcIuwM1K2Sdj9/sfiZwpcA1IbWdKfLhdJWn9sCOmKrN0NtvTyZyycG4Fc+1yGe0dKLCtQ2rnEzR1LfFFAy8YeH0zCjBqNhGrMIudJXsMl10vDlGcDfJJF5gZ4dms6zD2LphVegfrpCWo4naPvwiWV7kjgtDiK81fXaDOgOzW5wGctidO57HDD/k51V93B41klYzBgAnwkxW1AU9JtaSSHewWo6yuyu8ZF1v0z2KbA2ruQm0Omq2RN6qQWOimWh3s1ipjhm5xpBcKtkyAehydovFZXOdUbi4suj/XJ034pO6KugGZXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Encapsulate the mhp_init_memmap_on_memory() and online_pages() into
online_memory_block_pages(). Thus we can further optimize the
set_zone_contiguous() to check the whole memory block range, instead
of check the zone contiguous in separate range.

Correspondingly, encapsulate the mhp_deinit_memmap_on_memory() and
offline_pages() into offline_memory_block_pages().

Tested-by: Yuan Liu <yuan1.liu@intel.com>
Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
---
 drivers/base/memory.c          | 53 ++++++---------------------
 include/linux/memory_hotplug.h | 18 +++++-----
 mm/memory_hotplug.c            | 65 +++++++++++++++++++++++++++++++---
 3 files changed, 80 insertions(+), 56 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 751f248ca4a8..ea4d6fbf34fd 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -246,31 +246,12 @@ static int memory_block_online(struct memory_block *mem)
 		nr_vmemmap_pages = mem->altmap->free;
 
 	mem_hotplug_begin();
-	if (nr_vmemmap_pages) {
-		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
-		if (ret)
-			goto out;
-	}
-
-	ret = online_pages(start_pfn + nr_vmemmap_pages,
-			   nr_pages - nr_vmemmap_pages, zone, mem->group);
-	if (ret) {
-		if (nr_vmemmap_pages)
-			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
-		goto out;
-	}
-
-	/*
-	 * Account once onlining succeeded. If the zone was unpopulated, it is
-	 * now already properly populated.
-	 */
-	if (nr_vmemmap_pages)
-		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
-					  nr_vmemmap_pages);
-
-	mem->zone = zone;
-out:
+	ret = online_memory_block_pages(start_pfn, nr_pages, nr_vmemmap_pages,
+					zone, mem->group);
+	if (!ret)
+		mem->zone = zone;
 	mem_hotplug_done();
+
 	return ret;
 }
 
@@ -295,26 +276,12 @@ static int memory_block_offline(struct memory_block *mem)
 		nr_vmemmap_pages = mem->altmap->free;
 
 	mem_hotplug_begin();
-	if (nr_vmemmap_pages)
-		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
-					  -nr_vmemmap_pages);
-
-	ret = offline_pages(start_pfn + nr_vmemmap_pages,
-			    nr_pages - nr_vmemmap_pages, mem->zone, mem->group);
-	if (ret) {
-		/* offline_pages() failed. Account back. */
-		if (nr_vmemmap_pages)
-			adjust_present_page_count(pfn_to_page(start_pfn),
-						  mem->group, nr_vmemmap_pages);
-		goto out;
-	}
-
-	if (nr_vmemmap_pages)
-		mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
-
-	mem->zone = NULL;
-out:
+	ret = offline_memory_block_pages(start_pfn, nr_pages, nr_vmemmap_pages,
+					 mem->zone, mem->group);
+	if (!ret)
+		mem->zone = NULL;
 	mem_hotplug_done();
+
 	return ret;
 }
 
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f2f16cdd73ee..1f8d5edd820d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -106,11 +106,9 @@ extern void adjust_present_page_count(struct page *page,
 				      struct memory_group *group,
 				      long nr_pages);
 /* VM interface that may be used by firmware interface */
-extern int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
-				     struct zone *zone);
-extern void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages);
-extern int online_pages(unsigned long pfn, unsigned long nr_pages,
-			struct zone *zone, struct memory_group *group);
+extern int online_memory_block_pages(unsigned long start_pfn,
+		unsigned long nr_pages, unsigned long nr_vmemmap_pages,
+		struct zone *zone, struct memory_group *group);
 extern unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		unsigned long end_pfn);
 
@@ -261,8 +259,9 @@ static inline void pgdat_resize_init(struct pglist_data *pgdat) {}
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern void try_offline_node(int nid);
-extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
-			 struct zone *zone, struct memory_group *group);
+extern int offline_memory_block_pages(unsigned long start_pfn,
+		unsigned long nr_pages, unsigned long nr_vmemmap_pages,
+		struct zone *zone, struct memory_group *group);
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
@@ -270,8 +269,9 @@ extern int offline_and_remove_memory(u64 start, u64 size);
 #else
 static inline void try_offline_node(int nid) {}
 
-static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
-				struct zone *zone, struct memory_group *group)
+static inline int offline_memory_block_pages(unsigned long start_pfn,
+		unsigned long nr_pages, unsigned long nr_vmemmap_pages,
+		struct zone *zone, struct memory_group *group)
 {
 	return -EINVAL;
 }
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c8f492b5daf0..8793a83702c5 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1085,7 +1085,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 		group->present_kernel_pages += nr_pages;
 }
 
-int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
+static int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 			      struct zone *zone)
 {
 	unsigned long end_pfn = pfn + nr_pages;
@@ -1116,7 +1116,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 	return ret;
 }
 
-void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages)
+static void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages)
 {
 	unsigned long end_pfn = pfn + nr_pages;
 
@@ -1139,7 +1139,7 @@ void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages)
 /*
  * Must be called with mem_hotplug_lock in write mode.
  */
-int online_pages(unsigned long pfn, unsigned long nr_pages,
+static int online_pages(unsigned long pfn, unsigned long nr_pages,
 		       struct zone *zone, struct memory_group *group)
 {
 	struct memory_notify mem_arg = {
@@ -1254,6 +1254,37 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	return ret;
 }
 
+int online_memory_block_pages(unsigned long start_pfn,
+		unsigned long nr_pages, unsigned long nr_vmemmap_pages,
+		struct zone *zone, struct memory_group *group)
+{
+	int ret;
+
+	if (nr_vmemmap_pages) {
+		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
+		if (ret)
+			return ret;
+	}
+
+	ret = online_pages(start_pfn + nr_vmemmap_pages,
+			   nr_pages - nr_vmemmap_pages, zone, group);
+	if (ret) {
+		if (nr_vmemmap_pages)
+			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
+		return ret;
+	}
+
+	/*
+	 * Account once onlining succeeded. If the zone was unpopulated, it is
+	 * now already properly populated.
+	 */
+	if (nr_vmemmap_pages)
+		adjust_present_page_count(pfn_to_page(start_pfn), group,
+					  nr_vmemmap_pages);
+
+	return ret;
+}
+
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t *hotadd_init_pgdat(int nid)
 {
@@ -1896,7 +1927,7 @@ static int count_system_ram_pages_cb(unsigned long start_pfn,
 /*
  * Must be called with mem_hotplug_lock in write mode.
  */
-int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
+static int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 			struct zone *zone, struct memory_group *group)
 {
 	unsigned long pfn, managed_pages, system_ram_pages = 0;
@@ -2101,6 +2132,32 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	return ret;
 }
 
+int offline_memory_block_pages(unsigned long start_pfn,
+		unsigned long nr_pages, unsigned long nr_vmemmap_pages,
+		struct zone *zone, struct memory_group *group)
+{
+	int ret;
+
+	if (nr_vmemmap_pages)
+		adjust_present_page_count(pfn_to_page(start_pfn), group,
+					  -nr_vmemmap_pages);
+
+	ret = offline_pages(start_pfn + nr_vmemmap_pages,
+			    nr_pages - nr_vmemmap_pages, zone, group);
+	if (ret) {
+		/* offline_pages() failed. Account back. */
+		if (nr_vmemmap_pages)
+			adjust_present_page_count(pfn_to_page(start_pfn),
+						  group, nr_vmemmap_pages);
+		return ret;
+	}
+
+	if (nr_vmemmap_pages)
+		mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
+
+	return ret;
+}
+
 static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
 {
 	int *nid = arg;
-- 
2.47.1


