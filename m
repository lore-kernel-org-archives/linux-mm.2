Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90B4C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88AD6B0092; Wed, 16 Sep 2026 02:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3EF6B0096; Wed, 16 Sep 2026 02:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C8E6B0098; Wed, 16 Sep 2026 02:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81E496B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:43:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F076CA5C46
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:43:57 +0000 (UTC)
X-FDA: 85218685314.27.224262E
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id A773EA0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:43:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="d0XGnh/e";
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541036;
	b=T3cj9/vk4oCPy6rEx6Tx0xn4/GydPrATbPjLFgQhTd0aB1AvTXc3Ahoi6lckpgmUs8IpCI
	8td4sfPWQHZ9CenmmR0ePZ16wj+ZoSvS7r4QCMNwsIza0R/tvchuRPdi00k904LnENbx/l
	xMD4qArgxhgioCMlBk17AqaaH2gV7Gg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="d0XGnh/e";
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OKh9ewKICcZ4B1bMy6j7dzmXfE4aXD+pSJoYMr6des=;
	b=7O1Q4tuyQcsC/HTF4rHy61xJr/+OzxxmfVJCMnF5pBMW3HFSkrn558iGULnxPd7Wsoh6N2
	pOTHJINAEaCWwEZEqY6LM4B+m4tDIKxfxA+yWxFFfOzWF+P8VkPqw2pBaw9sOALvYD2xsr
	8DqBnNUiWXiEKC1ryGpyHuIEzThuWzs=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d90ba1d807so6831745ad.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541034; x=1790145834; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1OKh9ewKICcZ4B1bMy6j7dzmXfE4aXD+pSJoYMr6des=;
        b=d0XGnh/e0ek5XrrZwYub2zhP2bJviNJlMvBQ+CKJWxNcTmJsB4USegVAw3k3RXCaUx
         m5InVHlGYYZSo97ME6q+JGAPcIFAmqIEfA0ktOhJy3xqKE1iSrNwewNkaoYBtNRLr73y
         CBZ+sBlPfs4Zc2uYQ5Kgq0M1Bnl4px60RgRNjnzv2FPm78pgYUbfuUNvI29LgKUz8sZK
         RJTxoiLJfEM4VNwXAPqAKXjVGNuZYgV0sf3DGYuNKc+oq7QljKLYf/nIrQezQ5f4ejrt
         ILPfCKgxrbuRXRtbsTxo5jGV8+eOuseiMjws+xqftZXEdvkekhH5U5XxMclQLstPvr51
         vnFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541034; x=1790145834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1OKh9ewKICcZ4B1bMy6j7dzmXfE4aXD+pSJoYMr6des=;
        b=rNKqqYw+2mjFluGPaB78T+KAdy361ARVNrkKgM2b7zBZPfbg80JjaGku+PsnC86CnD
         ARjFOhAtKseSuLFZinA3Gig5hwOUWI5Jti/cuYJeWGtZKEcUY5CGXKeFGdhoNW4uCAZy
         IUE7GzUe7RuDbVt/lEP3tQQghSVhzKqXDiwPiDQrUnGxKMJxRPitK6Ci0qvReIQQSmOo
         7JuCcNRTibybQI49Oss5kkgjt8SM1RfnzVyfXVl5p7wn2ptGLO0xAIMdl4FcOPKPNOqe
         OjO3+SW6g20q62eWWXjQwOtQ5w8bEuwK9XL+qRwMTuxpbcXU41Tz3GopYhuAII3Nmesp
         2qxQ==
X-Gm-Message-State: AFuF++lQwNMO0bngVwf8mYBnr4F6WRJGrkuiJ7MuL2ZT2Zd1tRITDDTQ
	SfnjKdZvdVjo2b41AquiVBFh3/R+X+MBBg66x01SOW2ucnUgOYRiRc5ripdwsihkQxU=
X-Gm-Gg: AYBFou29TjQ3DkkTzQtvM+1W2zHOqsQTuMy9wZZvxZUtzIxaqnFItxbqjMbLg+AAOmr
	BwitfnpacJPpbOOkF9TOqoJXsAH4sbbsSSznwqV6irOJvqByamzBG+aqfvsE0d+qkFvIIn46RyP
	42LEdotoaHeEMrX3GV5ryzSbo2x4cZzQ7TP8/EEX4eGjDEvXDR6SMelUJw1AWFneX3senx8r6zr
	JF0vlBWdlxtfbp82JeEjUnQkeqO6VzSW/Cigj6fIkFgzTBl/qBdp0CtYm/oYBT2drxAGTpu9nm2
	m96kq0giqxSR3GUmJlrPCkbMbsSyGCk7gX3yXbhejpHzGGCtZPo4V/3yPDcMQL6Rr3yIvwd7UmV
	ql9LTX49tLA5fOAj8N2NvEN+2N3R9bB40nRLkhtHI1RO9E9dXiB0y54KgU2D13GmHClH7iaBzlb
	S+Dj3d8yEBF3xDPas1ikPW53RJSYzCEL1YO8gimLQ5C0j0vV3/EuN0eDuWQYEXIhIorakhmIFfI
	vAJNQewvyAZExBhnQGHabOMS1f0nA==
X-Received: by 2002:a17:903:1983:b0:2d9:4871:393d with SMTP id d9443c01a7336-2dd8e77e51fmr32018845ad.21.1789541034351;
        Tue, 15 Sep 2026 23:43:54 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:43:53 -0700 (PDT)
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
Subject: [PATCH v4 01/11] mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
Date: Wed, 16 Sep 2026 14:43:31 +0800
Message-ID: <20260916064341.1825793-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A773EA0005
X-Stat-Signature: fctct9hhs868cfe9ysbnk3t1ddheb6k9
X-HE-Tag: 1789541035-911583
X-HE-Meta: U2FsdGVkX19mBy2eG6ATXbb0V9i89PSsJJD+6qC9BHmU53hd6wIFPrl2gVb+jj3+VhmVCikaObChRCl+3BYIoRMtfy576GX3P3ycLPpWo2AfDG/8Zp0vt/jyjx8v8gHBV29XySzYr9gpPBuCXy/rD0rRxEc4KsqH2VEK8s9RvjhgQnat1uy5UK88UZPYDBT+/RQ7Eg+NWe5IABAWZOHjqZR4p2sXWUffPuhxomc9wR4NkFtkscMttgfvceYTnI3yFnRiLzOwwiEjFrfAYw8sgJE/thkN2c7zMNYGvIo7IcREBELK2b1Jp8VXJQakPoc108FY55L2Rf5UMz3wpfPMSsQJRkyFYMaqldF86AAwkaFP3W4KwenUOrUGuzSPOIcv2cxwTcb6Mf5o3ibFw9145/U1Ep5cyoXnJHQBh2Bcb/ll3iVtgnFz+b46uiw7vzGboDfD2elDKXvB8AGDwQIZGziUn22MY76jp8HfMP7fQkLw+fIp31dFp8X6OKYDfAXvWBDJ5tBlCUcgoULnouHkTJoa9z1kH9fL0gwXy2V1x93WMsnHCv3Y/Mnt/7/DVxskWE9rpisVsEu1JF8uLDnI9xMssd2EqvM34gy0Ac16a3OX3hdVGrjpjofjTcgRoMV3AdRxu9+58bkh4j2KkBlffjSL1/06puMR+6P1Cf/BofjsijNc5UM93V+ADrvFugE/633f5yfEcB5RD/0IZrQXzv7gAWbkR4OJQ3h3Ei4VZfUQcdNfabv+TK20jMADyQY7hABOo7urSA30YJPeJ8AoLz33gHiZf624MQ87467bdbdu+8o0Rr2aIA0/VpKhFnL52bPoCz15A5TWxrf0qBIl8x0WfV/oQMOZ566tabFBCVHomqtkxbTFNbdcBPZm8CIYPg0q2UosfA3Va7WfLB1LnL7863D9JPsFhTvkQNaaBYbNKcgzZPJSFMz4FXrDYuP9jcfKAJNYrpCLEVLNth2
 8IpNPL6m
 /urTPrLP7dLl8Qakr9B1PEN+gMEXy4rm1vFKFBkVn1OOiwBBTEx/eD2X/dMAjsH25p1EtR9sxqwAMhO6G9dxr7FQ9T9zJBz2pZmE+w+VU4u3LA94CitdtwIiIAHwoW8g3u1d8PzD3bgXfcjEL7aZe0phzxjbAGyTQa/70UC6Erm/AoZp+wmtQ6intuMsUB53IIHZz9TzpMD6lZMWN7Y5/vFWmslgfhLgzUJ4EEWi5fb/jKWTflXCAw2rz/k4qovkNmTXbGldoOqJ19peqMc2RX6DCxGi/SDfgDikDwzHXg69dKfaIpFbkUjtlrPvl6NWhcDYsR1kB4qkke5puKOOgx88wwayiiwBBYQtUj5kohl0udk6CTyOVTXfRDuc8O4fEgkYw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The section-based vmemmap optimization infrastructure is still guarded by
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it also can be used by device
DAX. Introduce CONFIG_VMEMMAP_OPTIMIZATION as a common config for the
shared infrastructure.

Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
DEV_DAX when the architecture opts in to DAX vmemmap optimization, and
use it to guard the generic sparse-vmemmap state and helpers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v4:
- Rename SPARSEMEM_VMEMMAP_OPTIMIZATION to VMEMMAP_OPTIMIZATION
  (suggested by Mike Rapoport)
- Collect Acked-by from Mike Rapoport

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
index bc3e549795c3..72a92cb9b53d 100644
--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
+++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,7 +11,7 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
-#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#undef CONFIG_VMEMMAP_OPTIMIZATION
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 602f9a0839a9..f50c6b32d826 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -8,6 +8,8 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
+	depends on ZONE_DEVICE
+	select VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/fs/Kconfig b/fs/Kconfig
index d1c210c6508f..1454b7fe9641 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
+	select VMEMMAP_OPTIMIZATION
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c49ef99b4413..070ce27e9cd3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5175,6 +5175,9 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 	unsigned long nr_pages;
 	unsigned long nr_vmemmap_pages;
 
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
 	if (!pgmap || !is_power_of_2(sizeof(struct page)))
 		return false;
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index acd94cecc0d3..56403841e887 100644
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
+	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
+	 is_power_of_2(sizeof(struct page)) ?			\
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
 /* The number of retained vmemmap pages with HVO enabled. */
@@ -116,7 +116,8 @@
 #define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
 	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
 #define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
-	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
+	((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 &&	\
+	  IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION)) ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -1155,7 +1156,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
@@ -2019,7 +2020,7 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 	/*
 	 * Normally, sections hold regular (order-0) pages. However, for
 	 * sections with HVO enabled, this tracks the compound page order
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 86dd0470da11..7080a6a1a79e 100644
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
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	return is_power_of_2(sizeof(struct page));
diff --git a/mm/Kconfig b/mm/Kconfig
index bc7befafb47b..0fa2eb76e4f2 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -461,6 +461,10 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config VMEMMAP_OPTIMIZATION
+	bool
+	depends on SPARSEMEM_VMEMMAP
+
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
diff --git a/mm/sparse.h b/mm/sparse.h
index d3a71ef4fad0..d8c08a388e4e 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -10,7 +10,7 @@
 
 #include <linux/mmzone.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
 	return section->compound_page_order;
@@ -75,7 +75,7 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
 
 static inline bool vmemmap_optimizable_order(unsigned int order)
 {
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	if (!is_power_of_2(sizeof(struct page)))
-- 
2.54.0


