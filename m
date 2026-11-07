Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DE1606A336
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=OMCtjcn3
Received: by kanga.kvack.org (Postfix)
	id 163F06B05B3; Fri,  6 Nov 2026 21:29:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115146B05B4; Fri,  6 Nov 2026 21:29:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003146B05B5; Fri,  6 Nov 2026 21:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C97706B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:29:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FDF012029D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:26 +0000 (UTC)
X-FDA: 85406741532.21.E7695BF
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf31.hostedemail.com (Postfix) with ESMTP id 29F2220003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OMCtjcn3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zC+O0MAETpzKUpVryru1gwlXYZ84tyqVBeTZILJyTdo=;
	b=6MKsdYybKQqadppwUWZImLyNifcvUyCei8dDoPuzPTrxCo2wFCbqvykvHflhrOwl0gc2W8
	C1F7BLsx3jZRFYG0lb0kGXkTsV57K80xg12FsJJbUWVYHoSK/V2cOh3SaSy+heUoQezo88
	NcCPVlfthZgQq/+AT2YcpAz5+QcL6PA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OMCtjcn3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018564;
	b=BC4/KflVuSnH4kfDG3i8zdg+0ITjM6z9cLQ3d8sp1uMq2sEcCXsTx8EJB2MWZ1BVEgh+C9
	8KvtAeJ43tKhmUpfNyFU+p0ib8ZCplzUWIgzo3I/K6lvG4Gcfd/6TatF/kcJSUPT2P1mxp
	sxuNqO77vDMfjMbjbUfh9/Vtlt195Ok=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-36cad25b8b0so2024681eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018563; x=1794623363; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zC+O0MAETpzKUpVryru1gwlXYZ84tyqVBeTZILJyTdo=;
        b=OMCtjcn39VAqC2n0yMACvjKFMCCO0rG5EO8WYLMfN99c978SZ7DOQ2jyfj6QKvaO3R
         B4txIhJPs0hJbnicsTl5vLXTdhzGu1EAUIuCGoJ/nNfOv/UMhaAuLlVtKVfAmHp4AGFZ
         KBlJ26bRJgE62bnGdi9pNcZtPWi/xDAVsohYC93vU+mMJvnuXISfC3RQRepxtTtTsH8h
         bxPkOPUo1vrmqYno+1DpnPRcrDIFMO+9TOxvg+rWPFp1IzLRbRkGbBRZk59/xvlbalg6
         ElnOqZgm7v3l/zFHnbq+8eeJ2aUGhfqk7Kb5ZrFUrswNhi9FmGA5SgMR4cVm47wZLg0w
         3C/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018563; x=1794623363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zC+O0MAETpzKUpVryru1gwlXYZ84tyqVBeTZILJyTdo=;
        b=O49bn6/b5X60vZSdGKApVg3/9kZxzoah1WPSfWdBgQc7FJoy1VskGoV3rxReZv4iuu
         JfzhnRFYv09xc6si9ZonO32AfyLeXDyoOCX3PXZzkU6U8d5wkRbnVhRj1M7PI87yoSWw
         4C+EYXds9OtF9aEzH5zT4z4DdVNOKIRafU+YEY6rlADtrJ9mTPLoGtNDWmmtt/swzJ0Z
         g8I78l0f7kxYbGO5GLl+TsbrrtGEUtoEQq1pJAgP9qQabxUpQNk6bKIL3yMJp0aI4wU2
         tLsrnUqYSvM91ipC48xBK3yGtOPpvo+3j1gTgsWVtemxL5Z7jNXzaT3U8RGfMr5monGn
         ezgQ==
X-Forwarded-Encrypted: i=1; AL+hErHfnpJFD8HS60DmaQHiLHTJOCkR9xRapdEPglTZ9tc6REZWDrNN+OyGwyCUKuG0Q9LRipfvbnWQ2A==@kvack.org
X-Gm-Message-State: APuU4Z+sAsYvozCQzX2KGQwY0M+291YONIUoxwa1Hua2bDH25f7b2ms+
	C3RlFXIbslNvHu/2yemT7kbLjx6C5nCtnmj9iS9U59g+mQjdco6N1dVssFlgd58tVTw=
X-Gm-Gg: AYBFou2b267v48p2e0NJCMNj/M6hbdv8qjOI1otaL1/X1wLWi9B5vkVLAUK4GYytoXs
	gyCl1OaRq5WUhm5/vet7GcNOF540KQROTE+BbPJgonUb56vRhMnCyjzeCGWgFXHrZvwLftD3UpT
	9BDI1RXdbPzvzjXsNMVzHOvfyhKVIFdcILksjIL9TDKXraGSJlIov2tlkA91d5aqVI/0iBkfzpu
	uJtIfBl8uOCLAIqGer9cYUv1GPq10iTBvb3rRAviiqCEP090tzqzjIswDhikzm99PpwkZ+QIZ06
	uKgwhuAgy6hmo7J3cKebHMP1JFMSYPAk+KiS+GQcAteFPykyd7gh3XghSWtFMDeqLiw7c1kKx6M
	fACuJ7vpwOgFRJbHLpr1ASfB0pxaZumLIAIkGTtrTWe439/4Kwi3F6dr3AMia1QbnB8g6po62sC
	luxdJTKfU+0MmzJTXU4/5RKPjL+hbuUjdeiVIAVuSEru4kUPaWPhiQ0wcOFqAZvulcSGkY2Q92u
	gyrMIMklQKkXdO0pV4WloXcXq6ZsWbhr8WNexfAtiyhPMh0lrL7G1KfqYz6UgeV/F9ZnlThWcMJ
	E6WFnGMyQJCEvgg+kDe3ExayiLXXscrcbmQ4jOqGwCmud8MmxqQbFLypG0Vc
X-Received: by 2002:a05:7301:460f:b0:36a:1846:5c75 with SMTP id 5a478bee46e88-36f723ebb86mr5806216eec.3.1794018562611;
        Fri, 06 Nov 2026 18:29:22 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:29:21 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 02/13] mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization macros
Date: Sat,  7 Nov 2026 10:27:45 +0800
Message-ID: <20261107022756.77731-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 29F2220003
X-Stat-Signature: xn5qf8mgzgiu1izbb6jjfgotmo7azcjj
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794018564-652640
X-HE-Meta: U2FsdGVkX19jwXgJW/mA2NuIX9E/C7MrtAsf/s45nrZdfVsCVqbkBy0Pq5gr+3xw95eRsck9dMoV2WNI2NAx5yGtQZ/ReDMfmzhq/FwdF/4FWN9TFtmj4mQEk16BFfIRXYl2t18kxQxFfGce/6Rmo4HNFw1vPJ1mm2bMoKUZRZgab8cRCTJSvLxnwnnmKaOejvn3MPpXk9t4OssN5d8NzvPXrmzkoHX03uQrGEM25EObvbTrYY42RFQPJpkavqP9zKMtK86y7vk2tdzo2CAYSa+GkK24SiwG6w8B+ECawNDYNjXIYqLSu7Oh2uMUmcAZSkl+rqWncwdjEsI5jDgumT8RY9iYxRkRn6hO7gNvN3Bcpw12VpAt+P/eQs1eaxBmd0f5EjbBP8t5WJ4K+4QJE+9Y5UV/PqjR7x2NtSRTv4Gr4L+iEfA09Q4eQ91hF2lmN8uV5wUNbB9v4m3x3QFy4IiK7i925KcFrIrux09MZ+pdxvzTGiDo4mq7Qg0uQBeci4wHYXM1rNCvIgTNTso4ZtrsF8+Q+dJM+DT/CIQZAv65PxxGz/2IN4Hpf/SWh2KKG+ZiSJeIhdTn5qAzUs7vFHPDA4yyejw2JyQK+E7pVPqOXnbcMYU89OJDv1dvk9C/56TLLp1FdesFtrq7eIOxtQlpgXD/0n5OoGMQAKjOXirtIA3wxxc5AqhZzvyFff/7c+WeK+K2F28rnAVercgXtQ2QYkbscpYhRMkuK+L26MkfaWXBs6t8A9tu24mf6X7O08Z4GqEYugeChYvPuEd1KCqNOw6cWvQ+s9xVoUp8fIRnduHw71UXakC+57bGaDOlUjoxw75Uw49GLm6uJ1De7afu7cQgMT2GanhMHTaTGWk3A9693nUtKgCc5LNkA5olESGJZ3Oq1zXSLVi+wqHt6/ZQqPN1cWXPa9IeFatjxfj+WlEgmBEkxGIQlc0uPYZxBEoHXxE7j64JuREpRy+
 gTZ+yLa0
 HxD3tlrnGtNR0tjLyndBtQBnGORHuloHVgSa5t+wnbybKvxmlOVnKAN3hdFc9o1WjAP7mR9ZhoZlXgjLO8xyMWkRPBpMUSnU1xZ8uRTc9wmeoZy8MjhPhfcIw2zc9GHhhCMmpEqG7QCHrR3eURB4oh71/U9vzvduuqVsUmGGzm7Lkh6b2Pg6Uvd+WEp0TyG0JxZ9IfQB7Mr/KQu+7XM/vNNzOluLhBeRDfUwav3Mf3WM8YBWNqWzeDX7kYDBckyxyxb9VTTrZZV1JYFiWHWMOEaqnEUsmykkz/ufYcdHhia1nmu3yFN2Yf5Y2rNHywVUHauYuj6reMG7/JGSixc44ffnpRJra0AJNOpR2toOKhDSGbSYkPO1KgH5COdt/Y7Q90PVwF4RO9DB7lOh0EIIOfF4gYyOHtGJedSWrBbMFtNJFR3QmFgcJLn0Y1sZ5a7YJldcV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap optimization is no longer HugeTLB-specific, so the remaining
HugeTLB-local reserve macros are redundant.

Replace them with the generic definitions to remove duplication and keep
the HugeTLB vmemmap code aligned with the common optimization macros.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 include/linux/vmemmap-optimization.h |  4 ++--
 mm/hugetlb.c                         |  4 ++--
 mm/hugetlb_vmemmap.c                 |  6 +++---
 mm/hugetlb_vmemmap.h                 | 10 ++--------
 4 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index fa9e9abd6656..065840f3c241 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -27,8 +27,8 @@
 
 /* The number of retained vmemmap pages with HVO enabled. */
 #define VMEMMAP_OPTIMIZATION_PAGES		1
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
-	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_SIZE		(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE)
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(VMEMMAP_OPTIMIZATION_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ff9dbfbc7a96..7c26be15a741 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3301,7 +3301,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * be no contention.
 			 */
 			hugetlb_folio_init_tail_vmemmap(folio, h,
-					HUGETLB_VMEMMAP_RESERVE_PAGES,
+					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
 					pages_per_huge_page(h));
 		}
 		hugetlb_bootmem_init_migratetype(folio, h);
@@ -3341,7 +3341,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		WARN_ON(folio_ref_count(folio) != 1);
 
 		hugetlb_folio_init_vmemmap(folio, h,
-					   HUGETLB_VMEMMAP_RESERVE_PAGES);
+					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 7fcc97b12773..e51f079f43e1 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -408,7 +408,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
+	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -677,8 +677,8 @@ static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
+	/* VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index d717d0d10960..d057e8b12bf1 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,13 +9,7 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-
-/*
- * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/mm/vmemmap_dedup.rst.
- */
-#define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
-#define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
+#include <linux/vmemmap-optimization.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
@@ -37,7 +31,7 @@ static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
  */
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
-	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
+	int size = hugetlb_vmemmap_size(h) - VMEMMAP_OPTIMIZATION_SIZE;
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
-- 
2.54.0


