Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B46C7CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432C36B009D; Wed, 27 May 2026 07:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BB46B009F; Wed, 27 May 2026 07:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F94A6B00A1; Wed, 27 May 2026 07:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3CC36B009D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCD6540597
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:08 +0000 (UTC)
X-FDA: 84812925456.25.B60F11D
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf27.hostedemail.com (Postfix) with ESMTP id A67F64000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880087; a=rsa-sha256;
	cv=none;
	b=DHEuBoT/A82P4kEUWieny1jwY8KqJIk///bbSGYMV4TT4uaonr7BVBuZSnE0KtxQ2hVLrx
	ttGG8k5NLnC8EiKm5trxSKkrQiq7feK6TI5zkbqyfYdq/mI8zLCW9voh09/2KX6Ibj+jCK
	bou2IHyQKpgRFVqIQaH0n2k27ak9WUk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUX2yDBDCxvUtmgZ52mDesAvbH3a9GaxxXPq8bIxSs4=;
	b=EzD1IoxhCeCO0pMC7AjVPDNhOF5EOHIj3KgJRp89WRnVKUNfBWprGd+TLl3kjU4cuf+zrE
	91f8uBpfwZq4O9LYK6k4e3Zhkx0IvF1Zie0bA8Znt+Jrxou3E6FncRiP7gRgYiLdHGaMkl
	xOF/C4JCuM0vG/6oeoe+Hg9o6R0dLtc=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gQRdP2F6tzYl7vQ;
	Wed, 27 May 2026 19:06:33 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:59 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:58 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 07/15] mm: replace direct FOLIO_MAPPING_ANON usage with helpers
Date: Wed, 27 May 2026 19:01:39 +0800
Message-ID: <20260527110147.17815-8-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Queue-Id: A67F64000A
X-Rspamd-Server: rspam03
X-Stat-Signature: byygqtjf6z6fyas6ph51yrfz35t5rcta
X-HE-Tag: 1779880086-600680
X-HE-Meta: U2FsdGVkX1/rSnANWF+eNZGidIVfKzToUmSNgV9WiFSptbREP/nUKu+k/5A9/QzoH3TPElI2DsZJMIaBG1O7Wuox6I/pwiOQvotT3bE+uxQ7x4btaN7xRRHOExIh9ey15tV+3rRCnsnbvr5XtusFSKirBKzTkG6l3r9EYW6c1YmTMlrcbd/vkbnav0+jDwnNVKi16pXabQNMU2n6lXxaAndUGol9J3rGnPOTHmCbWKjAJRTV/iemXo+LVTw1G8cLoU5ADy8mZDmDk1T6Nj5RcH/8aor0tYGYUgzd3+Z7hswGTOa2OLx4metjVeHtCqAYChojm1fAZ1b7f3KfH0JTaCiubbEnpbqmW5VgUVB5Iv0ULR8IUFQlpBRpjOfY+yjmzzonzZewb4bONi3CJKW3J6bi+K4MCrB2kdqxikaamX2vTlyExeWty+Qa6Xm5Zc9qdbtu716nTmCRsMVFgeyxgVyKwBLsgpDExJrOuwOARQwzB5m9YnFHMuozqRO1Q7SotKLOhUAf46iu1cqNyS5H3dZND6jjKI51+Ny+qzbaj90QzkwtK/4DWx6SL92xqHiydFeUKMwWXpddwmTqtu/s4N4ly0hgA1gZH9NI3M4TGBso6knNMXvNM87IYCF2MKvDBtR+TLFFb5pGCCB/7hqOGvBn/eqMLnu+ekLg8n3vMnXZweRNiP/MoTjhzcGxqEk/fTrKx27oLXfao693doYfXveYbZ4l+NNdZyhlW2cViVyU0ef/pUONXHqcbbZxi9YQS/1LtLLgnADtf971XSZNHi8HqkLtD9JY0QbpWPMdpKAWFoORhbtcPr1LETSvBWgKQGVbnzJe18j3sNj2D1GTgI/3aVvlgtDsFgmdRqeh4qBevNF7CXGgwKEwh3D1WythhcDPvVmLGTohxFCduUjqaGM+wNeOFDtHjYrcnjsLbuw38oJziORTREqDF6K5aGi2gS6XX47cM5AM8vNuvdM
 KjWvfuAI
 bwH43ZdBc6WN8zPz0VJdL1d1nyUp0LJaPNV9yRgdzmwOt/foMcByB71zHuHJSg6LJAOCwgSc14F1kQmO9w3MdCPgxc41bTAf9rTqWJjhZkOKbR6sP/gpGR24pUTeqJabPdBbFH/LeWXySuWQffA5SB9fAECnmC5d0ee7kc/R8qVIHj5yIy2ex5Nx6dpjREaXcaVGj6Pz8K0+Yj4LqqIdyM3xuEt7IykERBsY4SSUvxfRPVrkt1lW46RXQaBlidwk0T/d8MogYzovApWk32V24sZOT4NPQ2qF36rgO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace direct uses of FOLIO_MAPPING_ANON in external modules with
helper functions in preparation for ANON_VMA_LAZY.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 fs/proc/page.c             |  6 ++----
 include/linux/page-flags.h | 15 ++++++++++++---
 include/linux/pagemap.h    |  2 +-
 mm/gup.c                   |  6 ++----
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..93ddfda9fa1d 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -148,7 +148,6 @@ u64 stable_page_flags(const struct page *page)
 	const struct folio *folio;
 	struct page_snapshot ps;
 	unsigned long k;
-	unsigned long mapping;
 	bool is_anon;
 	u64 u = 0;
 
@@ -163,8 +162,7 @@ u64 stable_page_flags(const struct page *page)
 	folio = &ps.folio_snapshot;
 
 	k = folio->flags.f;
-	mapping = (unsigned long)folio->mapping;
-	is_anon = mapping & FOLIO_MAPPING_ANON;
+	is_anon = folio_test_anon(folio);
 
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
@@ -173,7 +171,7 @@ u64 stable_page_flags(const struct page *page)
 		u |= 1 << KPF_MMAP;
 	if (is_anon) {
 		u |= 1 << KPF_ANON;
-		if (mapping & FOLIO_MAPPING_KSM)
+		if (!PageAnonNotKsm(page))
 			u |= 1 << KPF_KSM;
 	}
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index c0cc43118877..50c80a1e2c7c 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -720,15 +720,20 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemmap_self_hosted)
 #define FOLIO_MAPPING_ANON_VMA_LAZY	FOLIO_MAPPING_ANON_KSM
 #define FOLIO_MAPPING_FLAGS	(FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM)
 
-static __always_inline bool folio_test_anon(const struct folio *folio)
+static __always_inline bool mapping_is_anon(unsigned long mapping)
 {
 #ifdef CONFIG_ANON_VMA_LAZY
-	return ((unsigned long)folio->mapping & FOLIO_MAPPING_FLAGS) != 0;
+	return (mapping & FOLIO_MAPPING_FLAGS) != 0;
 #else
-	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0;
+	return (mapping & FOLIO_MAPPING_ANON) != 0;
 #endif
 }
 
+static __always_inline bool folio_test_anon(const struct folio *folio)
+{
+	return mapping_is_anon((unsigned long)folio->mapping);
+}
+
 static __always_inline bool folio_test_lazyfree(const struct folio *folio)
 {
 	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
@@ -738,7 +743,11 @@ static __always_inline bool PageAnonNotKsm(const struct page *page)
 {
 	unsigned long flags = (unsigned long)page_folio(page)->mapping;
 
+#ifdef CONFIG_ANON_VMA_LAZY
+	return (flags & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_KSM;
+#else
 	return (flags & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_ANON;
+#endif
 }
 
 static __always_inline bool PageAnon(const struct page *page)
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..746939872ac4 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -507,7 +507,7 @@ static inline pgoff_t mapping_align_index(const struct address_space *mapping,
 static inline bool mapping_large_folio_support(const struct address_space *mapping)
 {
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
-	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
+	VM_WARN_ONCE(mapping_is_anon((unsigned long)mapping),
 			"Anonymous mapping always supports large folio");
 
 	return mapping_max_folio_order(mapping) > 0;
diff --git a/mm/gup.c b/mm/gup.c
index ad9ded39609c..69dda325b082 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2740,7 +2740,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 	bool reject_file_backed = false;
 	struct address_space *mapping;
 	bool check_secretmem = false;
-	unsigned long mapping_flags;
 
 	/*
 	 * If we aren't pinning then no problematic write can occur. A long term
@@ -2792,9 +2791,8 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 		return false;
 
 	/* Anonymous folios pose no problem. */
-	mapping_flags = (unsigned long)mapping & FOLIO_MAPPING_FLAGS;
-	if (mapping_flags)
-		return mapping_flags & FOLIO_MAPPING_ANON;
+	if (mapping_is_anon((unsigned long)mapping))
+		return true;
 
 	/*
 	 * At this point, we know the mapping is non-null and points to an
-- 
2.17.1


