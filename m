Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D230E6BF1F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D856B0005; Fri, 30 Jan 2026 10:38:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7C56B0089; Fri, 30 Jan 2026 10:38:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BFEC6B008A; Fri, 30 Jan 2026 10:38:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45C9A6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:38:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F3651A0643
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:38:08 +0000 (UTC)
X-FDA: 84389036256.03.55FB6AC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id B9BE0C0006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:38:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SHvf7+2I;
	spf=pass (imf10.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769787486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8BEGb3dr7aMka5d2kWYRSkQcPvTVi2+Y6uTOVuF55I=;
	b=UQa30+2m4rCXyZMYY+5PjJin5zkuCtKC5DHV2ZIrW1Fre/+53aqyNPKGb23pmOvKiDo1bM
	9BtzL250RMD2XCJg8x81Ruteb5PsDiW7CFdPYwtCVl23pxHJQqzV7l+791OUXFBXn/tAIh
	kg+oWBDk4ae2lCchlFNbn83lbB1SojA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SHvf7+2I;
	spf=pass (imf10.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769787486; a=rsa-sha256;
	cv=none;
	b=WLId9mk89+jbv71twTDToCZGCZGiFX1k5854zvGfNngx0G/NJUDxU8Vp1Y2//zqu43dYVx
	zP4tG1JJgNOu4m3aFsPVr0VXh5PZEPI3oXYXOHAbKSzIN+a79IXnPNNcMyP81GnFZvB+7q
	KjPlNSmSAre8pJA3+NjPGLyFRdcvM5g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769787485; x=1801323485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XukClm9fljIpYlDSCYiTs15l3rVEQBWBcp4lxswkTpI=;
  b=SHvf7+2IUUBx783YdjnzoSQNbGy054+DudCA82l5lrLmvW2OfDvAgO/l
   UZ/vsuVMhn5OA83cmxQxoSrivC7nVzhDvIKDettA8hvwmCmG8ySn6ECdq
   lzgCf4wak3Lhxod9KxBUiTP7HPej9VGzNMa7mITv3M5seTkANF0BJlIIu
   MwS4ifAu3BBLepEQnU0AeDUVk6zRIpiXUUWG/owtwSLEWzm4IsC+ysRqy
   vIpHB9X2bCS3jt8v6FQghuG7WySSK5vsyfG1NYV/1WjPGqzZfq8MdSmI4
   nxD+4L9BWHe4Gx7HErnSuOXUJELTkvwVi8pPfrhlTOt9aw7T4FQ2KctLa
   w==;
X-CSE-ConnectionGUID: tK9o73/DT3Gwp033eanESg==
X-CSE-MsgGUID: wUgiLpQ4RYiSgoRbt+aulA==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="71124790"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="71124790"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 07:38:04 -0800
X-CSE-ConnectionGUID: 6N7nEZH/TO2QUHEZtC8fCA==
X-CSE-MsgGUID: rEwis8p7Tce3oimMej6sRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="208989121"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa007.jf.intel.com with ESMTP; 30 Jan 2026 07:38:00 -0800
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
Subject: [PATCH v9 1/2] mm/memory hotplug/unplug: Add online_memory_block_pages() and offline_memory_block_pages()
Date: Sat, 31 Jan 2026 00:37:55 +0800
Message-ID: <20260130163756.2674225-2-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260130163756.2674225-1-tianyou.li@intel.com>
References: <20260130163756.2674225-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 5ugceef9pb8io8wkgicas4mw66fhcosf
X-Rspamd-Queue-Id: B9BE0C0006
X-Rspam-User: 
X-HE-Tag: 1769787485-85305
X-HE-Meta: U2FsdGVkX1+OLUg5GE5bfQENLcwQgOBdXwJBQMGZS3ceb2AkNuRtM07lFXmppdAzoBZGFLItvOePQiio7vubtgDDBIvQk5x77sF83uk3g7vUmVUQc725XFv5CVimN3bUfyHIBR1+dIeH1jhyxSPH/Tiwxipa1m5kVYgMy9iC7WL45yyFdGreDuDbvOYhAauyjGXfzYo7Y1QK1BD7VO9eruXP8LJwh2BxzLAQQ6kgF5R7UOykwJz6PSfcIZtXS6LktYq8sDdCIDbJry6bZhtdpC0IN+WAjjHiFatLal8LHbs9NzvA5YtkQ8HJOIZVIqkd/aSKfQf96i9gutdrLvQjchCGjyvquuW/1MWWIhoQSWfNnLb3Rs7YzRH+mss2jQgpv5pCbyAc4q6xJEUXZazkMTjd/59gnwXjXMo2j8GO4e4Es9etf2q6sTugR0wfOUW6x351pfSVoC6szO6Nnn7vQ8eysWBWAm8cNv9jKzVRmLLS8YsGlMaxpgHKz7d0otH5638lj0FaZs45f/7AOU/UG5xuoVq+oRcuXPhFj/pLbuO0nfYV+pzfoDQ2CcVweW2i2lCjeJqU0eziSnTkosQJnICW/yc2MKRUzCwls5RMSK6nqMQWEtJ64JiiDsXE4OcOZbNfX5gLokmHXA7Y6MlbimSVl6vOeXhg5aT6abmX85ONlB2CfPxYNRKxkcPntcY964M1F9GRkrBlQU/845XFwTDLTq2fZ6PkQcRv52wDUksXX9/N6ifpX4man+58NFjJcxGqifObZ8dtnM78Pm/JSFXwes7wB+J5O4haz3oYd45qZCBVxzayGqN6gQbOtbLlZP7M3hMO5A5qtTAze1Csc632qMv1LEiG7z3vMCAsriliJbX/mmos+oOCciYdluR0Stuvke7fj8VqTZtlfogH2maKhuo6G/mZ+x0t9RphKSnKtgjlsK/Fr3YNagq1EsAZ9YasBMopsOXWAnpz3uh
 8ZidH0Jq
 6ncJzkREjO0KMAig3qYWLUKAy68D439GWPPG73rcniN2uArTV4WCUkipaK+nhbwftpCFkjwytSd8YOmj4/l4bNR3rZz3KMlsWbrkuCvxGjM7mX6oa2mwdcCITvIEqEj5hF+JWoHXctJVmyAGVb+Bo3ARKj58n8J5UwrwJj0kAluomVM3qCiXKT9RsasljPZUFupVZjZdsbzj5Jgg0JVXdCLD3NaP6GqXCNSf52MchQQdOaG2oA/BeTKnEtcpi9aCJ45eY9oC8gk9soFH3KPov8xvJ525YYhUQF49pTcrGHq3hkdGYX3ntKw+et3iO3A1YXg4LO3nSIKR7QXQ=
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

Furthermore, move most of memory_block_online() to the new function
mhp_block_online(struct memory_block *block) and correspondingly
memory_block_offline() to mhp_block_offline(struct memory_block *block).

Tested-by: Yuan Liu <yuan1.liu@intel.com>
Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
---
 drivers/base/memory.c          | 115 +---------------------------
 include/linux/memory_hotplug.h |  13 +---
 include/linux/mm.h             |   6 ++
 mm/memory_hotplug.c            | 132 ++++++++++++++++++++++++++++++++-
 4 files changed, 141 insertions(+), 125 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 751f248ca4a8..40f014c5dbb1 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -209,115 +209,6 @@ int memory_notify(enum memory_block_state state, void *v)
 	return blocking_notifier_call_chain(&memory_chain, state, v);
 }
 
-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
-static unsigned long memblk_nr_poison(struct memory_block *mem);
-#else
-static inline unsigned long memblk_nr_poison(struct memory_block *mem)
-{
-	return 0;
-}
-#endif
-
-/*
- * Must acquire mem_hotplug_lock in write mode.
- */
-static int memory_block_online(struct memory_block *mem)
-{
-	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
-	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
-	unsigned long nr_vmemmap_pages = 0;
-	struct zone *zone;
-	int ret;
-
-	if (memblk_nr_poison(mem))
-		return -EHWPOISON;
-
-	zone = zone_for_pfn_range(mem->online_type, mem->nid, mem->group,
-				  start_pfn, nr_pages);
-
-	/*
-	 * Although vmemmap pages have a different lifecycle than the pages
-	 * they describe (they remain until the memory is unplugged), doing
-	 * their initialization and accounting at memory onlining/offlining
-	 * stage helps to keep accounting easier to follow - e.g vmemmaps
-	 * belong to the same zone as the memory they backed.
-	 */
-	if (mem->altmap)
-		nr_vmemmap_pages = mem->altmap->free;
-
-	mem_hotplug_begin();
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
-	mem_hotplug_done();
-	return ret;
-}
-
-/*
- * Must acquire mem_hotplug_lock in write mode.
- */
-static int memory_block_offline(struct memory_block *mem)
-{
-	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
-	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
-	unsigned long nr_vmemmap_pages = 0;
-	int ret;
-
-	if (!mem->zone)
-		return -EINVAL;
-
-	/*
-	 * Unaccount before offlining, such that unpopulated zone and kthreads
-	 * can properly be torn down in offline_pages().
-	 */
-	if (mem->altmap)
-		nr_vmemmap_pages = mem->altmap->free;
-
-	mem_hotplug_begin();
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
-	mem_hotplug_done();
-	return ret;
-}
-
 /*
  * MEMORY_HOTPLUG depends on SPARSEMEM in mm/Kconfig, so it is
  * OK to have direct references to sparsemem variables in here.
@@ -329,10 +220,10 @@ memory_block_action(struct memory_block *mem, unsigned long action)
 
 	switch (action) {
 	case MEM_ONLINE:
-		ret = memory_block_online(mem);
+		ret = mhp_block_online(mem);
 		break;
 	case MEM_OFFLINE:
-		ret = memory_block_offline(mem);
+		ret = mhp_block_offline(mem);
 		break;
 	default:
 		WARN(1, KERN_WARNING "%s(%ld, %ld) unknown action: "
@@ -1243,7 +1134,7 @@ void memblk_nr_poison_sub(unsigned long pfn, long i)
 		atomic_long_sub(i, &mem->nr_hwpoison);
 }
 
-static unsigned long memblk_nr_poison(struct memory_block *mem)
+unsigned long memblk_nr_poison(struct memory_block *mem)
 {
 	return atomic_long_read(&mem->nr_hwpoison);
 }
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f2f16cdd73ee..8783a11da464 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -12,6 +12,7 @@ struct zone;
 struct pglist_data;
 struct mem_section;
 struct memory_group;
+struct memory_block;
 struct resource;
 struct vmem_altmap;
 struct dev_pagemap;
@@ -106,11 +107,7 @@ extern void adjust_present_page_count(struct page *page,
 				      struct memory_group *group,
 				      long nr_pages);
 /* VM interface that may be used by firmware interface */
-extern int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
-				     struct zone *zone);
-extern void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages);
-extern int online_pages(unsigned long pfn, unsigned long nr_pages,
-			struct zone *zone, struct memory_group *group);
+extern int mhp_block_online(struct memory_block *block);
 extern unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		unsigned long end_pfn);
 
@@ -261,8 +258,7 @@ static inline void pgdat_resize_init(struct pglist_data *pgdat) {}
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern void try_offline_node(int nid);
-extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
-			 struct zone *zone, struct memory_group *group);
+extern int mhp_block_offline(struct memory_block *block);
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
@@ -270,8 +266,7 @@ extern int offline_and_remove_memory(u64 start, u64 size);
 #else
 static inline void try_offline_node(int nid) {}
 
-static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
-				struct zone *zone, struct memory_group *group)
+static inline int mhp_block_offline(struct memory_block *block)
 {
 	return -EINVAL;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..967605d95131 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4377,6 +4377,7 @@ static inline void num_poisoned_pages_sub(unsigned long pfn, long i)
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
 extern void memblk_nr_poison_inc(unsigned long pfn);
 extern void memblk_nr_poison_sub(unsigned long pfn, long i);
+extern unsigned long memblk_nr_poison(struct memory_block *mem);
 #else
 static inline void memblk_nr_poison_inc(unsigned long pfn)
 {
@@ -4385,6 +4386,11 @@ static inline void memblk_nr_poison_inc(unsigned long pfn)
 static inline void memblk_nr_poison_sub(unsigned long pfn, long i)
 {
 }
+
+static inline unsigned long memblk_nr_poison(struct memory_block *mem)
+{
+	return 0;
+}
 #endif
 
 #ifndef arch_memory_failure
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c8f492b5daf0..62d6bc8ea2dd 100644
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
@@ -1254,6 +1254,74 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	return ret;
 }
 
+static int online_memory_block_pages(unsigned long start_pfn, unsigned long nr_pages,
+			unsigned long nr_vmemmap_pages, struct zone *zone,
+			struct memory_group *group)
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
+/*
+ * Must acquire mem_hotplug_lock in write mode.
+ */
+int mhp_block_online(struct memory_block *mem)
+{
+	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
+	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
+	unsigned long nr_vmemmap_pages = 0;
+	struct zone *zone;
+	int ret;
+
+	if (memblk_nr_poison(mem))
+		return -EHWPOISON;
+
+	zone = zone_for_pfn_range(mem->online_type, mem->nid, mem->group,
+				  start_pfn, nr_pages);
+
+	/*
+	 * Although vmemmap pages have a different lifecycle than the pages
+	 * they describe (they remain until the memory is unplugged), doing
+	 * their initialization and accounting at memory onlining/offlining
+	 * stage helps to keep accounting easier to follow - e.g vmemmaps
+	 * belong to the same zone as the memory they backed.
+	 */
+	if (mem->altmap)
+		nr_vmemmap_pages = mem->altmap->free;
+
+	mem_hotplug_begin();
+	ret = online_memory_block_pages(start_pfn, nr_pages, nr_vmemmap_pages,
+					zone, mem->group);
+	if (!ret)
+		mem->zone = zone;
+	mem_hotplug_done();
+
+	return ret;
+}
+
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t *hotadd_init_pgdat(int nid)
 {
@@ -1896,7 +1964,7 @@ static int count_system_ram_pages_cb(unsigned long start_pfn,
 /*
  * Must be called with mem_hotplug_lock in write mode.
  */
-int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
+static int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 			struct zone *zone, struct memory_group *group)
 {
 	unsigned long pfn, managed_pages, system_ram_pages = 0;
@@ -2101,6 +2169,62 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	return ret;
 }
 
+static int offline_memory_block_pages(unsigned long start_pfn,
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
+/*
+ * Must acquire mem_hotplug_lock in write mode.
+ */
+int mhp_block_offline(struct memory_block *mem)
+{
+	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
+	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
+	unsigned long nr_vmemmap_pages = 0;
+	int ret;
+
+	if (!mem->zone)
+		return -EINVAL;
+
+	/*
+	 * Unaccount before offlining, such that unpopulated zone and kthreads
+	 * can properly be torn down in offline_pages().
+	 */
+	if (mem->altmap)
+		nr_vmemmap_pages = mem->altmap->free;
+
+	mem_hotplug_begin();
+	ret = offline_memory_block_pages(start_pfn, nr_pages, nr_vmemmap_pages,
+					 mem->zone, mem->group);
+	if (!ret)
+		mem->zone = NULL;
+	mem_hotplug_done();
+
+	return ret;
+}
+
 static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
 {
 	int *nid = arg;
-- 
2.47.1


