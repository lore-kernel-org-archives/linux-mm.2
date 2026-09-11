Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0996FC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBDD96B008C; Fri, 11 Sep 2026 01:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95DE6B0092; Fri, 11 Sep 2026 01:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3086B0093; Fri, 11 Sep 2026 01:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3B7A6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:03:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FF7C1A0746
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:36 +0000 (UTC)
X-FDA: 85200288432.29.8DBDBAD
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 157A540004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jcnJ6NIw;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYLeiWTXnovMqWiY32MdZegt5FI43o4EiONe9mBHAYI=;
	b=Kg4dViV4bsRwlQYBNcKUocBwo5mLcBAQgPJfYSrv2cH2ODaEklPmB708bLAcQRESyFN7WI
	KqP5qU1lT5OCsA2daxAjL3Dx0Vk0KUCoEhfxdNHlH1wPDpfDifhE2NUJMXtR1CIi3tgkwi
	YRGxR4y3Wx3/rTq6JFtkrIl8VUJSLKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103014;
	b=ceURw9YT7oCeHqc/Tl7IsVZa2l7EqlCVK9BECaXbQNvTQtAA14PeZbWeSOKZ7B2Gw56EyE
	Bip4q33fMls6Hr+fxC86GtnotPWdVLw/erUVVJTfmfhF0bp37wG4cnJFPpGN5lIHclXGCR
	JDBxYTaBHQRHiVl3QTGwQtXooGs+YN8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jcnJ6NIw;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc4aa02a269so532206a12.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103012; x=1789707812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EYLeiWTXnovMqWiY32MdZegt5FI43o4EiONe9mBHAYI=;
        b=jcnJ6NIw8iTyJwkWfsny9K2cgLnEys7Iyb6SN5C7wpUmWcdGaqqui3RQp9qtDB12jd
         hKY6wNlFohATHG9xIqmHJCKqFq4qvaA4+RYBW5N0zXbgsrIm5tTsNmgk6ID6Vidan0ib
         BNqexxpLMROm5P5SFeugO4eFVP2dxuyz6SSn6tq2M5jBvy6exwteEcyRDh/xn5tlPCpf
         woR8lofJRh4SfnL15+SfYbExW7pQ5Ol8QXwzatnjSKO/Qx21DOngkIo6TYK4OVzFckGZ
         n3GWR9inPjw1HzqM6oam8QpfQwQHiDPK8iOCO3tbNf9cBnvCi16UsvF9JlvzIwgt9Yp3
         Kp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103012; x=1789707812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EYLeiWTXnovMqWiY32MdZegt5FI43o4EiONe9mBHAYI=;
        b=YVtCU+i28hF9rdP4EKZfTLpUnt9hJIuH613Uz2rmbbfdCh6U6PFSuFjtBI2ankeOfD
         8zQnti6GWIodmbmLACcuk72oJN84PLYOERo0r1gyt/lumT2cxxdf4l8Q8fkVVwL1TDI4
         2f9xZ42XRjNLNwijYnBFnbYmf3bm6ebN4opb0NmbpcX7v1p97gNY7NMNTzpEnHTxbdRP
         LexhFruYlTQLKekMgESstGPSNbsGSaOwPGN9tT/ykjqG4eTjEaFn5tmIJgWVqUXydgfc
         KbqN9kDZ97karcNx6SLJmVei/GggPI7K4UwJaGp9BoNBMmffQjPOXioxOIX9lmGBY8jB
         kL1Q==
X-Gm-Message-State: AFuF++l77WHO98TBC1QIorBQq6+j1RQ13tzcz18p94BIiHdsqIPJNtCD
	lQzyn+Ee8hy1tBlsA3/LqH5g0gNXeHMGyG4ZVcVUHckarH6XTsBtC2+dpE1F5a75lqE=
X-Gm-Gg: AYBFou2ACLfA6OVj+aepUN5WjzPSE16A0SP/Kso0GxoXSBCbg2kez6NPRPjvDZcCCM5
	aSwg3Chfs04DxGb/XHE2hakIHoPlpcxPSHlFu2NM0YdK2nCvjTSpog+RX1hS9Ah1JO1JztROsGi
	bcpOypj3gkeN2sHDiERF1mi8V71Y1U+mn2B2y50Lby8c+Aa0uptGDaVzdqJJOFhL5rziBbI/P5T
	mg0XZy+CSffLrW7uyqoJmv7KObMH1M7D/dqTfePoUwoTY+gvDoMYhUInPtbhTLjLteLF9JoIeFB
	vKKoussuxd4z5aXtMGK6zssTLnjn2qHETwI2AieEzMhi9K6EBsBSPTGJLlDB29ozy9oChkxOXKY
	m0WleGyCc3txFC7DsloZSew09JKRx0lulpUp/EJ9ra4Ajzi/PNMY4YNUrC2icCcqwIO0xHdN4Nc
	vu1g0STV3XOHQfLQx+OiGkfcV7PWaZcMCwa7rtMPVaMNsMbXB6yWIw8AE2NU0XV5SS1npQ4MTWe
	SsT4PYZFCPlZ7kgRqDq9hSHymnU9AYtOy+o
X-Received: by 2002:a17:90b:278c:b0:398:e6b6:acc2 with SMTP id 98e67ed59e1d1-39d9c1b4d9amr3909895a91.12.1789103011605;
        Thu, 10 Sep 2026 22:03:31 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.03.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:03:31 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 01/11] mm/sparse-vmemmap: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
Date: Fri, 11 Sep 2026 13:02:18 +0800
Message-ID: <20260911050228.58884-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: r87g4s4z3y5yhxaurg3dnp6su41g6njy
X-Rspamd-Queue-Id: 157A540004
X-HE-Tag: 1789103012-568691
X-HE-Meta: U2FsdGVkX1+rwt0M+8IE4oPpOP2ocmYg0H3IL3KM9e8v460LlFjE9BU5GvIaSr+RgLNyjCZNJgozSVM7yIjJ4b0z6Sh+MycuN1LNN4MleePu480wHGxGCvC2uaBgs6g22c5PJ+10wZQ3gZkdaYVpyWoojxpaqdhDJiTgfL2YbuM6GdgvthGaXecsp7StfkpMzZrpRF3fFnhxDJdoHo7zwqvoSDH8J+/DrOK/BEvPx4ES+44l+iCwl1fAh3A2gAQhk5YPGu2Tp6AW26zGqbELPQ1l2f/DtzoZnrxXKdRh2IzRtpGhXTSwH/LTi83G89jPkHewRJ2QcUSmH9ADP+FAPPKWmfCEFYsCwOe34aPh31nf8Hb4hy+2MzD+15Glwd3q1t73QmScLl9+SWG1hZzYbUFRgNdWTcDLt73J7X1UCjkYWJ2Ur77HMnPJvmTqZCh6c/XbFLHj3rJliFVwo1DAB6WFG4iJi63Pi0j1X4jWVCx58EAzdAufsi28gULulIuNIVkkXx3jEdAZH46waBvW543k5wrjQ2+/9NWE7JXJo/GOt2rEHVqzb2T1G1EZZq6G4jLSRuMtYuvR6L21cquQVfhtg/6NNwyR/TfM9qLh2Vao9rbK+OnAP9PrHJsl2eIJkvbZ0UoNFVMpIv5BE5Ita+dqxP5dOytFU44MEk4eY9nVDfkw6Az5uTLJS+kIKrQzV/k708U7/ad0tXt+0rp10OwUcpZE5JVzaywzzivYk/lSVHXTmkFOqMw2SoZoi6n4eK2AuIiU7f9vvT9avvcqji63E/vBPdQDveXMHiodudnL8wid7wmHBBsX1rQvnO1F/SNHm+ZmCqEkYBdDfB+gTUZ0NhAPBmZTbNQHvzbXi34GZC/iJOSmUeiubiF+Gog/R7ztXq7VWqiQHLOrNZEaee8ZygSDfYRpecDfZMe5bWvnxrQk8g6/8ZQeBTAS+COU7tXmbvmd6byli/7ra5H
 bB97ItNs
 7q8V3tJCCvd/izQ9f7aAz3dIgnTE3ICvksM8PUo/y7w0dfip6vKw9nwzv9yfRuLwnlQD30zjJ1b3RmW3qX6VVDAAC1TDxFP7wZJ+avm0xt6zcWi8kVN2bjjoh5ieZKfk//p0gPVPg0akVJG0/RW2vfeTZHbm5dHCeY5cU73iRwu34PJvCTnl+FM560EvcSCjDX+CQbGbmsUQtNO38hd3I7xhJRAvvYxiz3cyKQrIOxeGkaEVd/ddzF3yk6eEc5XmHD+xGwysZz9ioej7N25mxr8L5okqn/1oiizeoSlnvYytenRa1/MbLuHb+1mWVyCbu721qBas+kwP6ndp3LFtF/Luaqu+q0ZvnAS94wlz2iDYTUyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The section-based vmemmap optimization infrastructure is still guarded by
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it also can be used by device
DAX. Introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION as a common config
for the shared infrastructure.

Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
DEV_DAX when the architecture opts in to DAX vmemmap optimization, and
use it to guard the generic sparse-vmemmap state and helpers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Fix SPARSEMEM_VMEMMAP_OPTIMIZATION being selected without SPARSEMEM_VMEMMAP
  reported by Sashiko.
- Add an explicit DEV_DAX dependency on ZONE_DEVICE
- Collect Acked-by from Qi Zheng
---
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  2 +-
 drivers/dax/Kconfig                           |  2 ++
 fs/Kconfig                                    |  1 +
 include/linux/mm.h                            |  3 +++
 include/linux/mmzone.h                        | 13 +++++++------
 include/linux/page-flags.h                    |  5 ++---
 mm/Kconfig                                    |  4 ++++
 mm/sparse.h                                   |  4 ++--
 8 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
index bc3e549795c3..5f8424eade2b 100644
--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
+++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,7 +11,7 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
-#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#undef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 602f9a0839a9..6250954b0fa7 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -8,6 +8,8 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
+	depends on ZONE_DEVICE
+	select SPARSEMEM_VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/fs/Kconfig b/fs/Kconfig
index d1c210c6508f..9b32ce79cc80 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
+	select SPARSEMEM_VMEMMAP_OPTIMIZATION
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c49ef99b4413..a2ebe87e7654 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5175,6 +5175,9 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 	unsigned long nr_pages;
 	unsigned long nr_vmemmap_pages;
 
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
+		return false;
+
 	if (!pgmap || !is_power_of_2(sizeof(struct page)))
 		return false;
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index acd94cecc0d3..97511f651ebc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -102,9 +102,9 @@
  *
  * HVO which is only active if the size of struct page is a power of 2.
  */
-#define MAX_FOLIO_VMEMMAP_ALIGN \
-	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
-	 is_power_of_2(sizeof(struct page)) ? \
+#define MAX_FOLIO_VMEMMAP_ALIGN					\
+	(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION) &&	\
+	 is_power_of_2(sizeof(struct page)) ?			\
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
 /* The number of retained vmemmap pages with HVO enabled. */
@@ -116,7 +116,8 @@
 #define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
 	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
 #define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
-	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
+	((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 &&	\
+	  IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -1155,7 +1156,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
@@ -2019,7 +2020,7 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 	/*
 	 * Normally, sections hold regular (order-0) pages. However, for
 	 * sections with HVO enabled, this tracks the compound page order
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 86dd0470da11..462e89e05548 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -208,14 +208,13 @@ enum pageflags {
 static __always_inline bool compound_info_has_mask(void)
 {
 	/*
-	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
-	 * makes a difference.
+	 * Limit mask usage to HVO where it makes a difference.
 	 *
 	 * The approach with mask would work in the wider set of conditions,
 	 * but it requires validating that struct pages are naturally aligned
 	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
 	 */
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	return is_power_of_2(sizeof(struct page));
diff --git a/mm/Kconfig b/mm/Kconfig
index bc7befafb47b..c180d40cd671 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -461,6 +461,10 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config SPARSEMEM_VMEMMAP_OPTIMIZATION
+	bool
+	depends on SPARSEMEM_VMEMMAP
+
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
diff --git a/mm/sparse.h b/mm/sparse.h
index d3a71ef4fad0..3151d4db7575 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -10,7 +10,7 @@
 
 #include <linux/mmzone.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
 	return section->compound_page_order;
@@ -75,7 +75,7 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
 
 static inline bool vmemmap_optimizable_order(unsigned int order)
 {
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	if (!is_power_of_2(sizeof(struct page)))
-- 
2.54.0


