Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C840FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C9D8E002F; Wed, 10 Sep 2025 12:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B61B8E0005; Wed, 10 Sep 2025 12:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4BC8E002F; Wed, 10 Sep 2025 12:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0601D8E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF8C01389E1
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:40 +0000 (UTC)
X-FDA: 83873826120.21.5225B12
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id C15AF1C0009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z+x02et9;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520578;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXr0Gr+eyBH1J2ZOC4B1nLxnwl36iHb/5ARHAVX+lWM=;
	b=P2Qv0ecQEEybnh0RMuuRsRtJmfKa5W4FM55uvhRTYDDC7Eimz3atHdEiWXtqUVkonNq0YU
	L0Dns0tEIBoqPxrWvkh1C522bkS1sUdL/xptp5Dg6WPa+YddqxApePGAzre57fTVGxFOQx
	4kFRXieZmkLAOfv+t2nOvg9Kz6cPdB0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z+x02et9;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520578; a=rsa-sha256;
	cv=none;
	b=CAefJ0DlYV/1oD4+u+iUDtvBs/KTkobVBM/iZ/rsOW+sUShLdP5pjVtkIZ1Lc5diySdWTD
	UDYSldMG1MfUE33JWVhQ6iYo42snSdACogwFGEVdirYRqVKLuSat2vQeufYPVyp6G7UhMu
	FVKPLrVjScs5FjYhbmVSYHB6kE1NiSM=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77251d7cca6so5959528b3a.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520577; x=1758125377; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TXr0Gr+eyBH1J2ZOC4B1nLxnwl36iHb/5ARHAVX+lWM=;
        b=Z+x02et9WmQczyzJxYgEYlOLsBAnPrZUxO8DRoeaSpr1Zzy46HcfTtdVcd+o0KC18c
         88nlHJAvyQ+LricbOnmQpHU8c9kDP2RItkMLuq8UCzernJ8/7p/WSK3TzzeO4tcDuH9+
         qGL+7CADxX+eaeG/38zQgDPL1SqcoX3Bl0GdhxFHHYzU4A5alvLB7lUFxDWkxefnFAPd
         pDUuW7pTNpaAx2fkxB4SVsh4kQJHuj5jFdGa6rJrP6oWvU1gFuhk/7lD/LgDPCn/rnxl
         zmG4lPbrcGLYHchWfcqIYBbuxY2W7tZlUXTtN60jRxtGkZGvHk/gUSXCN8gVTh+r3pOG
         7wSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520577; x=1758125377;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TXr0Gr+eyBH1J2ZOC4B1nLxnwl36iHb/5ARHAVX+lWM=;
        b=hXTe6Ym7ZEKqkZeBAMD+UFg/jWY38tjDs2kmm1hPvfCLEjzYaRgAIxaGu68YwG2MK0
         j5aYxLAuXSCP0ZqVdxEnDJ4psE/g6HTY+H5QtIYVY5ce63pMM3crRUdek290GC8Hu7kY
         0kDkam8hf3qA+dDmNx+vVIuCO1JnGPG9bhptZp8kL+4PLMwgY4V06YPQj+t0Td/MQ6uk
         0TgAvxgs8AzO/gMBUuLtHDbnCbyahpP4vXAJOVJ0bEE2veTrVXhKpxlN7syHxTEvuzGS
         T0XIQg6IvKLiqT8HVRRM8FJ/kbtr6/OFHHvP2tPSMvabVdNMkTFMRohsTLMPIkHe81Xa
         4InA==
X-Gm-Message-State: AOJu0YyVdNn3LYuLU7L4waEQstrLlJ/3dHzG7eWH9/FndhIh32UHgW+Y
	uonrZXlPOELQ5SRSGbxWNTejFpIEoKN7L0Cc+B1Ufgypf+0D6OJBKnPisDgU0qBkOSQ=
X-Gm-Gg: ASbGnctbReDyWoS8bEYAyDoxyFYZfWCJDATCyPv8J/8opU5bHqJSbH3HQvml0l2kB6T
	gk2ND7ltA4QtE9myeUepLQMw3ZVQct7c4nrC2eM1jcCgjnDmIt+HjGcuu4puFGaJiRxcknxi8ij
	8Op/7uzDS1l6enyui0DQEc9ZmGwtSUWdAmtcneMGZ1GEwblBlXBy34DPt8TH7wPvRaKXD1iyeup
	aGSRat7LDo+UCDdW8xN9J2rc1sCIziXs53nS3posZPt9mqo5rSdC0YUwaFxAvaLcJNc9jRMqCD3
	ipYiapHt3ZeCW1YY5R3BeeY5xmn3b2/MniL0wrlYpb4C7hVqUdZJvFdE3LuC4i4jlgqSONhHLI/
	OpuOTRTwvR7/VsTjLNjyzU5XNpPIYUvfLdi+4WCNLyzp9ewj4awjIroWTKw==
X-Google-Smtp-Source: AGHT+IGd1fs3d/xLWFIH8x0QD2Wv+0XsIfWldgkL360dAU+YTjAIy2jV9nMZXESeItmlntKEcr6Daw==
X-Received: by 2002:a05:6a20:3d19:b0:24d:301a:79b1 with SMTP id adf61e73a8af0-2533e94d169mr26623227637.15.1757520575417;
        Wed, 10 Sep 2025 09:09:35 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:34 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 10/15] mm, swap: wrap swap cache replacement with a helper
Date: Thu, 11 Sep 2025 00:08:28 +0800
Message-ID: <20250910160833.3464-11-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C15AF1C0009
X-Stat-Signature: 953anhst4ira3ejjd17bao7o34nohc4h
X-HE-Tag: 1757520578-724687
X-HE-Meta: U2FsdGVkX18f5QoMM4BnpWNDFwHnrxusxVriXeX0KnR5RkdJw5K71jGPAF1rLBuin15+4zKVY2Jba2L/c3PMKcXTYc35SbcjrTvxav8T6wd4DvWABdYuChZnhQzK1Gm99yHobx4ao7rSt/QOo3NYCxt1Mj4yUgbIVrhr2NbTfcdBccHhhHd2hhcaDWDsT+zp2ZCdg+DS/sKuTMABGIPK3QiuHYzrCiXPocfXzpNomJqKEi47TsnUfUiZAQoxvcNMwuab3UIW9LGBAFeZDkjuMOy7px35ri1IlJtSmLYl5GsyguAoGmEl/eMGOmBy/f1dpLWo+w8Y+cV8O4ojJNeJAq9IDNVoOV86je5AYNjNt4fWHxhjLkI/CU1LnHpZNZfeFQeVyUM67YyTQyFwmeOC2NkNTO02j5hmK9Nj1T5EeEMkAONqq4GtueWC3iBKGGiAK9KPigCDYpRDRr0oj5zkQqkMphpKObODOnofLGncw3s1TfiS8YXWT8bCQuVagpuNdPMI/go7K2QaxWcitlOTpfno8Bv39bm3RiVWQ6dlCgEI+puyhyNE84gWz9+11jYjeBmSPTPDvGNZfgo7zF6hrM2VOtPq+P3E5keY2kMg6Y43zfM5R5mRz6e+i8HXEs3JRlnMLy2wlOKcafE7HIL2ig3gup4DPO5llwvyyUKW07SwOpUfofitHDqSOSQd0QFC6K5HRPIOmoWB+eNwilGY9uOi/yvcDJlbam9dVXqan5ogC0ttVKbMWYoY9r4bzmL/bFetaz1I5VjsE6s5TU7RcDFRgp7VpYC6OJoQXp92bN5M5vVG6EjmQUMbi5ahigOGq3Bs7KcjEiepMFAts9KO4lzaFciWvSMBb/3klItYEBaW38pyGtF9579aHFgZukEYV+YAprx/lVu6NdXFp3bgA5N/yPGDBvRk/bPK2v/a1h+7yKqQKCbO5sDfEkC1//fenjsgqheJSY3KvudAuch
 cSV/n2tw
 sfCW1cmS7C543F5vUgpNuwWUWvn/33gIoulmn+ctzD5cHay0lBEY1pVqC1hue5jSDQBi+m5pGW5Qh2Fwtw9oP96+E1ZtLHDS1xk5xAbKhrc7doc2d4u9oJOEeiMVA+XzQXgdeYRsQT7G6e3dLkyRYm1oQsM5JgwJOKRuT1vJy3bfXFsukZWKHWx9/HDfjDlK1R6sB5QQpNcWHHk6rkaqkW6AAqnHGAKYOi6oKIUiD5TIKC7blSRi0Fy39wqd+R9wM5kOJ3HZlohAtRbNQQQ0amTTjG9fzvqK+aBEfELfiTgS4o3nIoNRNIqIvXBnW2Uan94ZkGUFYRk84eG5HKHf4KjfGMp3qDSDoLt9yL2H9kMCsLJVm+Dc1BSqo5bpjuGYcA4fpnIeaAyqPZBnJ1quMJDZ9v+HN2k94qUPfB3LVcAegz3SdvcG6AC+3aDYoHsgkS/vEQdlFVguqFt6bJciPjiYAWye6cacczsUuW+eELGMfAnoQkJSw+yQ7sXzCvj6CLIlxNS0nrjPjeZaQVnphFgak1qLLbxTfcn8NyB6z8XZr4URQeBt7dWmotd5Zw4M4BmQDVu0GmxG00VnSHqTh+p+1fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are currently three swap cache users that are trying to replace an
existing folio with a new one: huge memory splitting, migration, and
shmem replacement. What they are doing is quite similar.

Introduce a common helper for this. In later commits, this can be easily
switched to use the swap table by updating this helper.

The newly added helper also makes the swap cache API better defined, and
make debugging easier by adding a few more debug checks.

Migration and shmem replace are meant to clone the folio, including
content, swap entry value, and flags. And splitting will adjust each
sub folio's swap entry according to order, which could be non-uniform in
the future. So document it clearly that it's the caller's responsibility
to set up the new folio's swap entries and flags before calling the helper.
The helper will just follow the new folio's entry value.

This also prepares for replacing high-order folios in the swap cache.
Currently, only splitting to order 0 is allowed for swap cache folios.
Using the new helper, we can handle high-order folio splitting better.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/huge_memory.c |  4 +---
 mm/migrate.c     | 11 +++--------
 mm/shmem.c       | 10 ++--------
 mm/swap.h        |  5 +++++
 mm/swap_state.c  | 33 +++++++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 26cedfcd7418..4c66e358685b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3798,9 +3798,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			 * NOTE: shmem in swap cache is not supported yet.
 			 */
 			if (swap_cache) {
-				__xa_store(&swap_cache->i_pages,
-					   swap_cache_index(new_folio->swap),
-					   new_folio, 0);
+				__swap_cache_replace_folio(folio, new_folio);
 				continue;
 			}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 8e435a078fc3..c69cc13db692 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -566,7 +566,6 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	struct zone *oldzone, *newzone;
 	int dirty;
 	long nr = folio_nr_pages(folio);
-	long entries, i;
 
 	if (!mapping) {
 		/* Take off deferred split queue while frozen and memcg set */
@@ -615,9 +614,6 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	if (folio_test_swapcache(folio)) {
 		folio_set_swapcache(newfolio);
 		newfolio->private = folio_get_private(folio);
-		entries = nr;
-	} else {
-		entries = 1;
 	}
 
 	/* Move dirty while folio refs frozen and newfolio not yet exposed */
@@ -627,11 +623,10 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		folio_set_dirty(newfolio);
 	}
 
-	/* Swap cache still stores N entries instead of a high-order entry */
-	for (i = 0; i < entries; i++) {
+	if (folio_test_swapcache(folio))
+		__swap_cache_replace_folio(folio, newfolio);
+	else
 		xas_store(&xas, newfolio);
-		xas_next(&xas);
-	}
 
 	/*
 	 * Drop cache reference from old folio by unfreezing
diff --git a/mm/shmem.c b/mm/shmem.c
index 5f395fab489c..8930780325da 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2086,10 +2086,8 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	struct folio *new, *old = *foliop;
 	swp_entry_t entry = old->swap;
 	struct address_space *swap_mapping = swap_address_space(entry);
-	pgoff_t swap_index = swap_cache_index(entry);
-	XA_STATE(xas, &swap_mapping->i_pages, swap_index);
 	int nr_pages = folio_nr_pages(old);
-	int error = 0, i;
+	int error = 0;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
@@ -2118,12 +2116,8 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
-	for (i = 0; i < nr_pages; i++) {
-		WARN_ON_ONCE(xas_store(&xas, new));
-		xas_next(&xas);
-	}
+	__swap_cache_replace_folio(old, new);
 	xa_unlock_irq(&swap_mapping->i_pages);
 
 	mem_cgroup_replace_folio(old, new);
diff --git a/mm/swap.h b/mm/swap.h
index 6c4acb549bec..fe579c81c6c4 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -185,6 +185,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 void swap_cache_del_folio(struct folio *folio);
 void __swap_cache_del_folio(struct folio *folio,
 			    swp_entry_t entry, void *shadow);
+void __swap_cache_replace_folio(struct folio *old, struct folio *new);
 void swap_cache_clear_shadow(int type, unsigned long begin,
 			     unsigned long end);
 
@@ -336,6 +337,10 @@ static inline void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry
 {
 }
 
+static inline void __swap_cache_replace_folio(struct folio *old, struct folio *new)
+{
+}
+
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
 	return 0;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f3a32a06a950..d1f5b8fa52fc 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -234,6 +234,39 @@ void swap_cache_del_folio(struct folio *folio)
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
+/**
+ * __swap_cache_replace_folio - Replace a folio in the swap cache.
+ * @old: The old folio to be replaced.
+ * @new: The new folio.
+ *
+ * Replace an existing folio in the swap cache with a new folio. The
+ * caller is responsible for setting up the new folio's flag and swap
+ * entries. Replacement will take the new folio's swap entry value as
+ * the starting offset to override all slots covered by the new folio.
+ *
+ * Context: Caller must ensure both folios are locked, also lock the
+ * swap address_space that holds the old folio to avoid races.
+ */
+void __swap_cache_replace_folio(struct folio *old, struct folio *new)
+{
+	swp_entry_t entry = new->swap;
+	unsigned long nr_pages = folio_nr_pages(new);
+	unsigned long offset = swap_cache_index(entry);
+	unsigned long end = offset + nr_pages;
+
+	XA_STATE(xas, &swap_address_space(entry)->i_pages, offset);
+
+	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
+	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
+	VM_WARN_ON_ONCE(!entry.val);
+
+	/* Swap cache still stores N entries instead of a high-order entry */
+	do {
+		WARN_ON_ONCE(xas_store(&xas, new) != old);
+		xas_next(&xas);
+	} while (++offset < end);
+}
+
 /**
  * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
  * @type: Indicates the swap device.
-- 
2.51.0


