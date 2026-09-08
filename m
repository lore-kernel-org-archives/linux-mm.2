Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB296C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1093E6B00BE; Mon,  7 Sep 2026 23:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFF16B00BF; Mon,  7 Sep 2026 23:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F385B6B00C0; Mon,  7 Sep 2026 23:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFAF66B00BE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B5F6120350
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:47 +0000 (UTC)
X-FDA: 85189102614.01.08F903F
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 94CE7120006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dmvjFgVN;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Uns/ZJlTRrXsZn1DdaJluablabo4P2O8/HR8HKp5bE=;
	b=nheG07gl4+D8CRsAQkpj+wmsnj6XNvglZtHg9XQUrnOSDLmNhKyANOThubr1ieJ3j1++t7
	2LKfjWRxKmnrtfTsxsj7da3mnYLf5p/UwMvNeh70d15QvigvKHQMjcYeTQvHRl6c+VWV5U
	b4vk7HFkbxIQlJbqHSP4+zYLfYTnZB8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836685;
	b=mCQBlaRUKYIvkHait+X4QxHU4tHzGiLvSuQPp6U+xySyNKEo4m4kH4SVIoNZyUA3FP1RoT
	pmtZQmaxL5HoN0FeFhVgWk435IIlfIh13Hd0HvFF35TguqEHPUg16vSG4OTle7TEKIOh5V
	uh+CJOJxALAUoaD5bf5wC0MF2fFSeHU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dmvjFgVN;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84e27035206so3756011b3a.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836684; x=1789441484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Uns/ZJlTRrXsZn1DdaJluablabo4P2O8/HR8HKp5bE=;
        b=dmvjFgVN6uaFh3zCtl0KmeY4Mx0MWgtlCjUU9p/Xno9OWoezbN67MNeM7oOdfhaYfi
         RcuoqgZVyOcinmRiXF6iF+EVV+HVe2o92cPJG6Hw4rGPPauoMI1VVbEVnRgFMMbeu77s
         JIaphW9b8ZG5IZHLikiQLCJYFcdegN6pWaW6jLHDD8baeok9rq0+5jfxbFG6k6k7+Dgb
         ZKQsyksvhUWL9tZ72+asFFNbtxqcjX2DF5Aa7LbhcteQ6s7BJWJLcdaGmTYA0ekg9Tvw
         w/Q5dyaXlZMC3ZpBDJ8np1y6djI5ZEjLBlcJBzrv+2bCm6nf8wImBMQoGbYnKZr+j9Wk
         s1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836684; x=1789441484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Uns/ZJlTRrXsZn1DdaJluablabo4P2O8/HR8HKp5bE=;
        b=FoKOYGtw2gbUYcM15XgR9acJX6dJ0D4R9+IFTLAc3ii1NuuvIgnnFwNaCgeANgz2B9
         gxNgb89zAcYcQENfySBWwHqlpJNGdo1QN0A4lsCdsEi8fUmKVe1q+s+/DAcY6dcbj5Vx
         On/c9A7KnNB9aUkRX1HOjWGNjGM2BGtYA4GrQZQFVZIIKXQ7Pif0ReSedmeKoMu/jRBw
         VMAFiy50zelgjUAEDofVVr7jc4M8f2UlDDzJU0WU26TI9sSuvkrntrLSVY1P3qyi6pcI
         Zk1HpcZFcird2dFUSdsGge7XebbSVpd+7/hbuOV0QRsMgJwmeGRZ5PABn1IylCAZEKy3
         N37w==
X-Gm-Message-State: AFuF++my25x7G+23H9dtFga+92Rp6SdtocwYjc5Pk2hcvsuje5J8e7Yr
	XcfrBkDBY7G5Zime6+tRVSbBx1cziCiih7BlzYLVsCNWdAuyPCTVYG3EgeP+yL1JVHM=
X-Gm-Gg: AYBFou3XtM3iC53mnil40zyzHbGxqd39R4LOvXdXW6VEitx0FKOtGqbDNNFgCV0BxW+
	QWrN7agoIisMoxaPei3tA12YsOjgTE4hFqp8gpAI892ithIOL1V57+RHdUQhUqNgmXcAmYI3ez4
	9vRG/Coot44NSM+wVoiXq+JxFbAjbGQfvt02E3+JkIOdDm7O33KlLrsT3O/CWDIZ49b8j4uqpUO
	oDUInsecCrRUoZObjmXVBK/j7GV1BBjWUy5YFdsOHTQXcbiEXvPzgeEs6BrjUA0Q81wcL5vpEzV
	r3EkRvL63whBX7wzeszwp2kz+dB+8STBu296ZFPoiFRPpG+BoZqIsKb6P69INJ/81j1k4hIviYC
	Rf2AbxK0sTMbXi0kAcT7zBY1shUo3FdJoDW5vPKZrkBY/d2uWa0MTSimL3jGhKiEQI6+aO+AP7s
	RdEI3wE7pMJn/wt0qhSFWfW1bu10BCBMP3eMABimoDrJEdKbO2mgDmpRl8opqvhT94tFxPQT+7T
	+Woik0O5of6/eOApcHIz2YbPw==
X-Received: by 2002:a05:6a00:3494:b0:857:726d:2e95 with SMTP id d2e1a72fcca58-8616a96c426mr38438397b3a.18.1788836684381;
        Mon, 07 Sep 2026 20:04:44 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:43 -0700 (PDT)
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
Subject: [PATCH v2 10/11] mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Tue,  8 Sep 2026 11:03:34 +0800
Message-ID: <20260908030335.96549-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 94CE7120006
X-Stat-Signature: gdzxbo6n68o33ppetg8j8kkn6bumy7a1
X-HE-Tag: 1788836685-239244
X-HE-Meta: U2FsdGVkX197/dAoV7i8rTydaKQnF/b7qwfZZsNGlynuGhjDh/0CHvQ2Zc0hF8SDgQJ5I1ZXmI6iB1UXFfyitfnuROWmQKfZB4f3KRUQ3QdjDhRoJbvl04/zetpFWCE8rzvDEx1DUXY1CwbTjjRU85ocwk2HQWtWeKeRefJAri+Tigs36l85dyU6LvaCf2+GtRHi9t3KUXNWugBHFEBhMbI+KDlAp3L92ZVsF2efC5OMVS9sJqQzKq/fq/OCU57N7sQaTRGp0PDKvTI2lGvYz4mjNO0xHuP3j2zcx7U+EcXDtj7DcbdGS00pGHa/SJwmKT0aKCc+Ylv9xbt3sczixV3+lPia473MXgT7gI/vkmnkpt5pakn1S8Bm+lQi9PF9/p3DHQrL/MD7TAjvBV2QQL4RNtlIvlnxsYoaxhpZhbC3F5kSH19DRppoRI3gT/ekfNGxj2Iu/bw3175yaw5bUCeuldCcNnbE7V1/FE977Z4LFWxlokbZgQxeVj4Xq+GAoiJ22ScHITczHMfwnSzxjPlhnK3RRxtRn8cFAcSNTMN76rNq89Td4/r3ikU3Pm/hcU4dKAxPycyyZnZG3UcO7DOfA3KiAXHYD8SM1huYK8r/j2/RqSCT99qlCUR9xBOLlbdniKrNygc0ufzXsD9SIjlH+C8jVvvHC0NVVWVIBEWAhUadEgrUd1mwzQdqccs/itojBF4JJo+uE9OZAYdUo+TPHByJcWeN0AiM6mPJi2GGVmyJmklSxFbXDUQXQ/a7eHyhTk3ai1SRvA6/BMGN9QPS1PiLSlmG+k3/Hdtz5yxD0bOrd1kke71VhaVdJveZHpvu3vRNs6XKhLItz/R7rQSgH+jaa0UYP4ET9bhZ/RqgbB0oJF5FfLahWEzICa8VCFtty/qOcGyA0g3iBSoIXUr3oZislTUFFiiAaBRdF4l9iJAmVl1tolUyUzx68NpDpRF0NGNPFePbmUDxw+i
 OHeeqnyN
 NrqPFa/jb+Lv/LxUeB8HDc+qNmv7311flgUByScAbGEyr4OF5wMRNgVTaU8CbXv6o5/EZKjG0sVTsRcqyJeoFmJXYgKbIpCrZANVd3EThYln1wKgoF3l7X8WFp09GUu+4ZJhxvWZLngwgsHvHKVWeCsuHh5UhIejKD5zKCEd4atv4mj1nSsq3i2gaOM5Rcq5Bux2Gz9zcQOy3jmPN6JuodMmFRTdS4QdKFibGvjqqXotqzuky0YoiGW/mQSKIRFZfTCHgJuMF328ntbSIDYe7kFxXjwnUJc+GgOqvZ93sALCLBGIn7Fie5MTsRRoLFydAc5vRiLuSfdaOz9OZdX29olTNL7ucLex8VHkO2fDOZhDU+P4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() no longer uses the altmap or pgmap
arguments, so drop them from the helper and its callers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 10 ++++------
 mm/sparse.c         |  3 +--
 mm/sparse.h         |  6 ++----
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e655d9d1348f..4950ac2a1c01 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -131,8 +131,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_order(ms);
@@ -637,7 +636,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -648,7 +647,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -658,8 +657,7 @@ static void free_map_bootmem(struct page *memmap)
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							NULL, NULL));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 	vmemmap_free(start, end, NULL);
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 9349ed6326c0..adf057f54c0f 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -251,8 +251,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 						nid, NULL, NULL);
 		if (!map)
 			panic("Failed to allocate memmap for section %lu\n", pnum);
-		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							       NULL, NULL));
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
 					SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
diff --git a/mm/sparse.h b/mm/sparse.h
index e511d99fc26b..5d0f407bde7e 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -70,12 +70,10 @@ static inline void sparse_sections_init(void) {}
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
-int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
 #else
 static inline void sparse_init_subsection_map(void) {}
-static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 }
-- 
2.54.0


