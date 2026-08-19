Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2EDDC5DF87
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493A66B00A3; Wed, 19 Aug 2026 05:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46AB56B00A4; Wed, 19 Aug 2026 05:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A326B00A5; Wed, 19 Aug 2026 05:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD906B00A3
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01A681404B8
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:20 +0000 (UTC)
X-FDA: 85117556202.14.2ACD995
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2CADD1C0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q0PylrEZ;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4XhcWcLOxh7vr8ZmuE0kXQ1fb1jPl0YDGFVXv1M41Y=;
	b=RBStF4ui+MKkDN2BvfcGkODnIgxgh9L3t4+S8M+FCWoTr9W1HLyJMzlYat/K+Kaw8Wp9LI
	5t6gY/rei/LToqTRugTQoKdFKjbvcvD0Nz87XAlGb2JmoSjsRDmanN6e/3R7AmuMxM7Lbf
	RjdSEiTsqtJbgq+rU9Aq0paBtjlXhpI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q0PylrEZ;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133199;
	b=Zbb4UI02u1HPjii6QN7uHQI3WL/jGfAQ4qmk9M9lZnQBH1nmc4LVJRDgDqNhlUftM6xw60
	PO8IR7EEArwN/bKiT45xJIh7zRLPJKlnjL5vLj0K4MLdDByY/hkwzAKJU65So9Tfjku1NX
	kYRb/KAu/AwM/K+LJzxyF4j5irFE3PM=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cab973140bso10378675ad.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133198; x=1787737998; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s4XhcWcLOxh7vr8ZmuE0kXQ1fb1jPl0YDGFVXv1M41Y=;
        b=Q0PylrEZyezROwr0miwWVwdx9yg0IWbAeMtUXenJ8jaRyCpevWAj5G+LaO4ouGiyX0
         G29CJ5xWdqf1/kt7cUDH1SDO4CZlTe+C1tDMBK18yvhZZM8vBwN98BpOGWx63KOTwGvi
         13Qh9D8Eqk/1Zw59Xj6INa8hsXQmeppIIGtQUKFNS2k4xo9LbFI4TB42yLd0TFlmnXyb
         0OZuleYR0gJyRJLrCLyFzfA/NrTGqj3klYDcUSEd5JCjEL6hp+18BGLMrZA0Y4tMl5xC
         lvWh0cr7SDUodG6dujojfV9b2NK7Py2/JbCQYJnym0RYQOJCTaK3MeNzS7Eve4E5lxyp
         UJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133198; x=1787737998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s4XhcWcLOxh7vr8ZmuE0kXQ1fb1jPl0YDGFVXv1M41Y=;
        b=kyFIbb9z6gef9gKDLU+8eHU0HfSd4/uWFwj68qzqzNAdNaik+U/XnyC7kPf6334r3T
         hAk8bLbql9bNw3ApfVSFb8e1R1o52VfHGkO3Qn0v50EazQmOKK4dVg0Hh2v0c/CDScD8
         CIpohfCRXyzQYNuwgOepxCHFc1yh7xyhhWOY5mmstM0oxcjDDwpmPQuKNT9LfFzhjFTt
         DipLTJjA/PFjm3pct5J41BLV/4QD8Xywt0A6aEsSKgS0/s2tCaV0yr+R8Yii+3gq9+vO
         g8RqrMLOdiTCQtMYD1bQT70+UpdgDFvCg+KfyggzooSDY+x20VmPHVenriXq5adglSYn
         4q4Q==
X-Forwarded-Encrypted: i=1; AHgh+Rrf4PkNMX28lwK3eowPqTkOnodhmYOfzYV8KAq0thGVOJz7P+9y8qFHQ+1IRJPjerERFUkM0TYDJw==@kvack.org
X-Gm-Message-State: AFuF++lERfFxOfdedr/ko96jPKpmHQzQxiWLEQNXLP4SYhLuIiJIF0s+
	nBc1IVetLG4/dXqxV/Id/oGtClOoENedJgHD3GsY1/QPooR2Rr/pqNyyzXADc8ONO7o=
X-Gm-Gg: AR+sD13saSO4Ase+/6t0L0zUwnQV5u3aeQvHQorwI6F52xjPG1qZE3oQllnc6QLmw3p
	zhvtDLPGQ9f85l17WqPhe6mvkzbZwYI1JHDpsZUGwacbeD4xi+CpGpBEtt4q8sMGRRPDGd0YYqE
	DV8LCsWjudTD2SLwkxO2XGGlGoGNEH4Ahe+4cGKlf8C9Q3Cv47dhkbdft222blSUwTis/w2k8w1
	5ISXXiz14ljCLNCT01cMXvuan4i+DMSlzStjIu6LSolqExVrMcc+ICh++yZKluvtZznLQnooAUa
	ng7ZOCEOnkDaQ0UQUd3UI8shmfvqBH4zZgQQdkHsjWBE5IZtF2nUsKFyo2gmBDB14RDpEhx9gEX
	EmmxXvjsOHaTfwktgllKyxisb9j+hgrCFDeGGND0OK6eOmpxbQj8toU1zMiqArAuHfW9lUPs3oQ
	8SeEKfgldSzalWIIRUewE4LhLgKZCRkVyDcsojXyg7EgKhEk8WgoOltcZesI60VPgvlj3RCEo4n
	dK3FtA4oIgqVXIQEJM8vtEfAbU1iv8HHO32
X-Received: by 2002:a17:902:d4c4:b0:2d3:89fb:35fb with SMTP id d9443c01a7336-2d5fd3df2bbmr55030125ad.0.1787133197688;
        Wed, 19 Aug 2026 02:53:17 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:17 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 05/17] mm/sparse-vmemmap: support section-based vmemmap accounting
Date: Wed, 19 Aug 2026 17:51:27 +0800
Message-ID: <20260819095140.17252-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2CADD1C0008
X-Stat-Signature: j1g7tqznxhs8oanrijgef7qyuwcs3zsw
X-Rspam-User: 
X-HE-Tag: 1787133199-734894
X-HE-Meta: U2FsdGVkX1+y706a5cjDXYuXODZlsXW/EtxBaojHRTL0b2pzL0Pb1NutO8FNmqWp/VWzCa8H+yZtvS8MNDdBusYs3ghE3yCSiKhuCvzqxCrSJmkyQZui1XXZzciyTke+5Fpu5ua/PIMYhRhOwa5EA1CpBA85ueBCpviHWfQL7fdwqF2WekvNRUU6lRROxt/2gWMtFj9wH+G6ZQHGypwkRXidLBemdnIvLSxqzOcuMXHkf9tbRASHLY9UUTOaiLms6IAVhtIn/Dq2iuTfGZDVnh5P0jiS44bApdUxc+JDUCBpgIc7A5328ofzrl3rb44WwYLgni6Eg5uzszJuNjVKl+ZqMVEA5iN5i4LX1L6lU1dy/EITAil3ou+uSQDMGb87nTn6qyXGzjgQGAO0c3Xu5OBXFEhqImAcE2g+JQm0cZUL/dzfDAeoDYZKsjV0kB5IPJi5InctunwYXQbyCqLeh7oXYbXyImUopKdGLf2TzsUlIDfaL3rrV7kezOMEUxCOJ0xXAxSJAFbBvot3Wo5E7qLUpxTKEFkW30icbAciJwVowv7JvYN71mL9C7+/X1pa4qVnwQgF2v/2CimU+HrpIL5ik5xyebAjh1bSe7FzAjL5GsLMx+gpKfDecMvbCIIdhUKW1Hpu85yRrVMsTpNtH8Xcjldw0lXFAHeZDbkcwLgOauYTTh/jxZdlcvN05EYDD5IpimPqphikCJ+TEXcP9NUKi3/82/o3NQz/Ao8G4iJdeLCRq6XLHdC6tyb+64tIY+LyNJztGR4cprLdziPqgJAzsHpSHoXZAQCYA2ZIi6deC7qJyO2Ng5TjNl6/h6y4Q1+QqexbsncQibVHukEfkOegKcxbSlENaS7kX0uQrVvq7d4Gv6uCzd+5XJYysxU9L+MQa2E/TxRDitWSKEPM/BBRnUhiWSErPOec/fLXZJzf8mwRMyzsSEBICvUBxUIr59uK+VevlQrkPDBcnaT
 vl+LwRBt
 uB9JcG2OFKsxTz6aZePIOIviVc6dYpaBqFleLPCe7u8/KdO8i+ioE0a+MEdZe2FeJpWvte9rC6DUdLkEHTxz5gHlclvm9TF3L9Hf+YavssvjtB5OtNstsxNJIZgjRsW+xgrG9P8NiB/GaPiyp6CM9JDkg7BUwRnuMS5t2xw3n7gG3oPc642IGNrR25j+RTajukoFlmqb7oKfMI6mu9Uxl3ZDLoq1uSQ4GQRhsRLXXSefUyiWWafsLTQtNpU5k56lrVZHtoJ71YXs3JHd21IVubqwumSYMXNldD5sT2oi6Kc8f5qANzx86sbhz5EEIMtoZDlro569UI+qTLDrVJAW7KCLZtl8W8EfItO+82us7uIphSrHBjJRYiLvjTQPU4BpE8W0f8XgvzyrV1OE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() can account ordinary sections and DAX sections,
but section-based vmemmap optimization keeps its compound order in struct
mem_section and retains a different number of vmemmap pages.

Teach section_nr_vmemmap_pages() to recognize section-based optimized
sections and calculate their vmemmap page count from the section order
and the HVO retained page count.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v3:
- Add vmemmap_optimizable_order() for order-based optimization checks

v2:
- Remove an unnecessary vmemmap_can_optimize() call to simplify the code
  (suggested by Mike Rapoport).
- Rewrite the commit message for better understanding.
---
 include/linux/mmzone.h |  6 ++++--
 mm/sparse-vmemmap.c    | 10 ++++++----
 mm/sparse.h            | 16 ++++++++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index df31cac12311..177455d98064 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -107,8 +107,10 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/* The number of struct pages covered by the retained vmemmap pages with HVO enabled. */
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(PAGE_SIZE / sizeof(struct page))
+/* The number of retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_PAGES		1
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
+	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 107215cf8488..b7abc5494bb9 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -649,24 +649,26 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
-	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+		return vmemmap_pages * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return VMEMMAP_RESERVE_NR;
+		return vmemmap_pages;
 
 	return 0;
 }
diff --git a/mm/sparse.h b/mm/sparse.h
index 1fcda8a1c270..02ed0f34eac8 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -43,6 +43,17 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
 	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
 }
 
+static inline bool vmemmap_optimizable_order(unsigned int order)
+{
+	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+		return false;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
+}
+
 /*
  * mm/sparse.c
  */
@@ -86,6 +97,11 @@ static inline size_t mem_section_usage_size(void)
 	return struct_size_t(struct mem_section_usage, pageblock_flags,
 			     BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS));
 }
+
+static inline bool section_vmemmap_optimizable(const struct mem_section *ms)
+{
+	return vmemmap_optimizable_order(section_order(ms));
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
-- 
2.54.0


