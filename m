Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF12C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D8E6B00B1; Mon,  7 Sep 2026 23:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DFD6B00B2; Mon,  7 Sep 2026 23:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153A66B00B3; Mon,  7 Sep 2026 23:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D24096B00B1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55AF340380
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:07 +0000 (UTC)
X-FDA: 85189100934.06.79C5346
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id E9738180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LP+jZHTZ;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836645;
	b=rlG2yWGD/Xc4gjnWA9TnoDgQALV9o4yTyLbVg8sda0hWqlSn1k2H2Jh+e5CfxS4m0/aHhm
	VmFMEhdSZTN6Bu6XdHXSe63W7OSa3UUAHu3Zt+jth86VYl/gIqb9J+la+SaLUFntmLcBaM
	jZPBmtm3lX25paO6azfBfvQ9AjZ/1eY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjEcqTpfVMGQsEndFVux5pizoY7o64l8tWT5aAqDG0w=;
	b=0SOZIBWS4i8gV6Y6+e0lUoNTkhEqKxki4JZ3IGmK/LyDTceIouysNCZF7ZQAYxDwmGnbCk
	qCg9B2r9cyt4+qjYKtaS5tEtDtTN+PH8AGAOI0Ac5v44t93sPezEh86ZnuoeS8vAE/F1EW
	ZjZA4A5lVsiV+hIIyt29v7ixtYxc93Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LP+jZHTZ;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84e27035206so3755554b3a.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836643; x=1789441443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vjEcqTpfVMGQsEndFVux5pizoY7o64l8tWT5aAqDG0w=;
        b=LP+jZHTZyg6IAqulmomUjsKmCAsyNxVxdCXa58HZyiQByyogmEWFF3fs3VQScwN+Wu
         1637TIWMCSOrtcraNPXEvM+n2usiEQ0n9yR2jVQL/nSMnyKaYDevwtsrJSzBoDEz+TDW
         lnq3LYqKHa5u/AsjkkUqt2yprZmvO0lAWpMsFxDRd7zvqALIxoiYXuQ071Ve8NOTKaRE
         V4jbByj0kELiyKgML5ocJ2DNH/qUL2e0pINn8ElaF1557737rlMg1e4k5IM7x0dOgEmb
         h0GkI3BtahQ3owKNpjazYdrCerLFTxyVstglNhsXurdCwp45kezGPCFyqwEbIzTuSGKm
         pzBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836643; x=1789441443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vjEcqTpfVMGQsEndFVux5pizoY7o64l8tWT5aAqDG0w=;
        b=hvHwE+dlTAIpo7vB39c1sUGUHp8QNN7k68b4iOR8DlkohCzzRDIwJB2RkGc92tAqP5
         uo4nT2xd14QxjvEjeEd/ylyNVKsWOl67E8SrNzs+xpYF/rqKb6e7+kZuRsY0m23xA7hW
         LBW+12PHUYh5ZzxIHEN0PwDayPKrapNLjMJiAcCnt0rFprInFXCrHL6DIyYHYwrvYyhj
         FzGkzf55q6BtnqZUxpvX1BjmWuC18r/5ohvNT9JIeZJuejBYnIf9Zxzqfa4hQawPdlkY
         YrQOuynnUWSfDi922WYwmbvXJhdRUHN+GnsV4tj2LLMlj2pyN1iyice5w/Of+2GwzkCB
         XmoA==
X-Gm-Message-State: AFuF++ma2bU+t0GgcPrYtQabH9eO44pBP6hQ630+fQV5fDuqP5LAGBIE
	IWklx9S0qKhA56SVwwnquoAe16qV9GgFPm9pDO5TWrrFADCg+uI2mO4y4I1XTk8MEh4=
X-Gm-Gg: AYBFou2KAkSukiqTsd2nCCliZehs8HyfkZ6zIBLHeb0QsmoLf8XAOEniEwAMigiKcgA
	nXjYC9xCcGvAeJgiwJHFFc2d9cRDLsZd5vJ9w/oo3rV8oZpWwPZ3n4uW71BlOrh/x8HdiHZmOGc
	ooCqBj9l/QwrABRcRqVqFOrU7Uzv9gtIFk3Iu9C+w1wQbf2kU2uYfegBWcb1qjaFH85KeFNdnzs
	K/C2D01a4+WiReRpwQv2yxyi0E2WY4rl8QvUR3E2JB1LaXLg7ZiP0rjjnSU3iBWQZHMqs4fXAhb
	FgCd7vIPBUrKeNfTvTUW3EAcsSpmdZq4Yp/Tl6kkJ1kIkR3t2wHSdL3cPpg+amGEFUIUiEBmUB7
	CmYE80hDJ4mZMoHhPykrpk3g1Pi/fDQFolzT9F8YPsfYPPt2iPQTmXGwiE/poeHYgw8qa32F6UB
	/ctkis35ZEp4qzjENzRFdfvXjB31DRGeuV4pB6lrNHiPAcgVHOPXMIhJNG9b5dljeKc0vM1goMt
	F1so3P4H9Xy6ieIOh1quV7i
X-Received: by 2002:a05:6a00:808:b0:84e:d5e6:a085 with SMTP id d2e1a72fcca58-86164adae77mr35546667b3a.0.1788836643380;
        Mon, 07 Sep 2026 20:04:03 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.03.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:02 -0700 (PDT)
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
Subject: [PATCH v2 01/11] mm/sparse-vmemmap: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
Date: Tue,  8 Sep 2026 11:03:25 +0800
Message-ID: <20260908030335.96549-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E9738180002
X-Stat-Signature: 5hf9xhj5cu5zx6dy7qfpqwwrh7p9ahhw
X-HE-Tag: 1788836644-57565
X-HE-Meta: U2FsdGVkX1+ysnZhY4cVE8UxWMmSIy4vyB9qPWNMq0CyfKsZxSEFOkYhpFNgE/2sCTmWxbtuYhJwgkWhWe+R0ImsjqAUzzyQfncAex2gWJnvnACUbZ3kAl26/Hb+wMl+bmPi/xl60eu7+Gh17PhNqBiCT05CDiy+cxIP41mwCoGOHMIhWn6EL/LvS4TIg4tR3jMCYSjgwJ3vVy7JOqkb6R5jjLnBAQKkwoHWiJXdpz0OC+oSv2Umo8+IFYM3It3Dgt7yn87TybQv9Lv9J4LliuVOiepN4xqoZSnBzMD9q9p1Z6cczEQ9t23xrIcyt4VubXvGGa7oPpfR1yh6uwvooTd5Bu2YWI5Jh6S+CXw5Kobyx2mDte8wdXN9fTjrD/VAwy6fDX2JeIz/FGNXgO+nLZ7T/mmsOKXeYf9F6HmD0dwIfCNM44y8I6sX0VsWgzjQDKnx/aHWfJtUQydjWKvVyUfP54G6cEsLM93+lSZIoI8dPTPGf9xTaNp2VlTn7HJm68rJOO+NHb4NOBUcCzQ7DHlgngtDeqvTPROzuFSlVhBv9Ixwxi1RAjeXjH/VMWGiHMstQAh155fYu1GQwtyRu8d52b5q4DEHqHkQh8uuMzm1CfKx4trEUP/IDChtzKD7w05C1Z/fSX46qhulhOJ/DJoGF44uky6mQj5uQ5GiYz7xtnbad9ztFrtsK4j4gl53lb+tVTIbmlpzZ0dl/j+na76Vugf4iIZbhtihDgndCNIXtnF6/uVArM1dXR6VqDZZydzVxV0ILN221761MmlPe0OVbuNGHsUNOKXqq9VpbxS6cF3rnyXoQ3I+RpnqZ9XGSlL/wjymj+TLME1cIFzrnJJBj8RDhY6GfF43QFNT57kjR46cIuJkt9CUJjPho+32t8Pd9STTdDEYbYjB2W8YIyym2spIv8SiBavQMHLzWAiQ/5BTeWAXnoiJRBra6g6R043ds4IwrvVMXhEp5uB
 v6FLg4MK
 4zCR9y1UlSgDnznxk+L7i1TGxr4lpx5THDpdzLYV8QSMHCxYEgIAEbJNoNVCEpmWaceSO7K+Q0Ar/N66HxprasBnkIIkqEThcMKfJOYMGjAPdmnPVD1WBExKQ6mjzVRKdOPTfF1RvBhB9Bdpxu2/yDv+l44rXejhc/zckX7YSv5In9e8Bt+i56AITEGcsTwfckcWZxGgbH+z4hmwtKX3aHBHeUcbOw21zTkhjgzA2sWxm35aYNkRr6iPzb5MAjGL4pqtGDyiq+IkVn7474ak70ViVJRP29k1WOwCjpyyhGISQXi7fsNFY3bOD3RXbo/p2IDozKNhlGvVBOghxovoXgrwqupQrPE4MJthq+4Wzc30FQ5o=
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
index c9ae7991a8b2..e9b54ea0eff0 100644
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
index 79163b7d795a..288b32dcc350 100644
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
index 049272aba84e..b408d15baf7b 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -10,7 +10,7 @@
 
 #include <linux/mmzone.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_order(const struct mem_section *section)
 {
 	return section->order;
@@ -72,7 +72,7 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
 
 static inline bool vmemmap_optimizable_order(unsigned int order)
 {
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	if (!is_power_of_2(sizeof(struct page)))
-- 
2.54.0


