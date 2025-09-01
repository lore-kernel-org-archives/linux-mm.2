Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B3ECA1005
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389C88E000A; Mon,  1 Sep 2025 16:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6AD8E0009; Mon,  1 Sep 2025 16:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D2B8E000A; Mon,  1 Sep 2025 16:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 030F58E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE9731DF1CF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:36 +0000 (UTC)
X-FDA: 83841874872.22.EAF5E42
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id E11178000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=LQf0rJWw;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HuFWfM/wBc81hJ9dDpPKVdEJMtdQ1aHoBTwvYzmlVA=;
	b=rlCL39d6WzMRHuWCfny3ugbnDJcb8vrTOq3VspbYa3rHETnmaX/3cFIrtgg6mXvUKnaxgZ
	Ma9aSZW1UYQPe0CBNNCS52+kLpPmieSFu71rWqmhaDCS6jkGF6+x/dgxayGE3mcjRlac4k
	4II5VKmN6GQu6CF7iaLue8/rIBE3Ox4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759835; a=rsa-sha256;
	cv=none;
	b=cE6/n5M3VXRufuKYseVc1xXjsuwCrGqHekTp6bkpK2F+DRu0JGcq487+5WMCJNtymFDpMc
	a44j/T2a5wuN3svF9yeYtyDdX9CqrcxkS07t0X5AuR84ApC6yMo5GlIXCE+ogg236ZpqTY
	aQe3i5GH2ZG0r868m3YkmYk0B7r61RY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=LQf0rJWw;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b0449b1b56eso41255166b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759833; x=1757364633; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+HuFWfM/wBc81hJ9dDpPKVdEJMtdQ1aHoBTwvYzmlVA=;
        b=LQf0rJWwF09uPIp5udaSg7n4dzaZBIAtNO5bhUek/zGU+NOruKXn2m3J/SHWlQsUVX
         6P/c9TRsrtcrV8aijHMzCokmmvAs144lcctc6VgduePwre/zOwLd1jXcnG57gg7YCPvW
         V9nEQzEY0uPI4g7vnw9TVLWhomwDnnPHhZzNDoUCbK47xLQPzk2dWQ7RhG43Q+vWXqTn
         yBUSB3zffv8W1LtDcPAfAeui4G2n9RfjAoY6ajh8w+DgWLLZClLwpEEeaBsm1xcarKc8
         sGOdEUw5IaevpDpUeIioqagCwlnQyAFSIvR1raaee9B2KeZ23rPrINauJD7zsTwfaFhi
         PvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759833; x=1757364633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HuFWfM/wBc81hJ9dDpPKVdEJMtdQ1aHoBTwvYzmlVA=;
        b=N1aDTxS6O5WRuG040o5HqP3ruxsLjodv3TM3tO/ObV8/TarAr306HCL0A4ogMXQaVi
         w8KlL+8WSmhnuIV7Lpgh6VC37Pi57M9z4tpa9bm2TNgwa/EqBmrqLz/BIvdOPh/iyABw
         aJnw92ds9uUe5yvC8FOdwz95O9HmpE3aug944tCnSfXlBQ5noo91fm2DbEhESFHpTn3p
         PjUcQYRoiDdlv1IpQP+GFLfX2E45RjLfzS1+gZlkEDBbcXHPahkTz8FINd4akN0EV5Jv
         t5NKJ4J3oAI7C3EzUPLAdhPzHcplgux7QDGYbl7yADelmyAxGrBNiEPqdMsSQtbZ0kNb
         W1tg==
X-Forwarded-Encrypted: i=1; AJvYcCV/LVgr5fJ/aT7o9u5Q0PNMGebsju7gc09Pv3p75K58q66DIuERHKRuKTOQ4c8WQhlGxXUSdSEIBQ==@kvack.org
X-Gm-Message-State: AOJu0YxYqJ6eudCkf05LCPyaSh1U5CggSPx8E4NssREe3+568djxB0d/
	Q6IoGGYH9HT8uVUz0VIfAml2m5gL6ZhCZ02kBCuX4IAjZ7uVW8gJ2ZpFKibNRbX/9J0=
X-Gm-Gg: ASbGncs9p9dk47JhURemVpF9PN+1KtLSe0yofjvzXquhyeGi1EmB+91xEjPlA7mnlhO
	Z9z6wNrDaTLSvAp761E8H3RuQpmhZqj5HfFa76B5KM0WQwkGA/7Tum4YsERcMs7yTaqUnupWa5j
	jF2m4zUOQEcJru7uKVKFoapYYjWHbQmYCo7PTV4z1eiuh/wpaEtDCa+cbt4m7L+wTmHRSx59GqD
	/hhhLh+NoiKzfKJdOtxRBD6ku2bvUXr/aikXG6515ji2gKwipvZpsV1u1DdsvTOJsM+b86Pzm9X
	wTJK4hZFMkROquZLUwyZLid336Kvhrxe1QU+MWzSOeRzevuymJcdGjNCDrXg4jmROaf78NzeZF+
	cnKHxpCbjchMkTW1EDzQZwywsZhj5zLYXFoFBarcmQVymowNWi+qLbGUgfiZSddvMZy4TCLPerf
	3p1UqluQJk4WHCrBlsfakdeu/mF9YeNAX4
X-Google-Smtp-Source: AGHT+IE84zezaOZTWoQkapLH2C1BbO6vX7Y1+6hTyfb4WtgBOH2M2hBOPUkaiYSUFhoR0XJ1xkAFHg==
X-Received: by 2002:a17:906:4794:b0:aff:7429:d40f with SMTP id a640c23a62f3a-b01d8a322b9mr880289766b.4.1756759833266;
        Mon, 01 Sep 2025 13:50:33 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:33 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 03/12] mm: constify zone related test/getter functions
Date: Mon,  1 Sep 2025 22:50:12 +0200
Message-ID: <20250901205021.3573313-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E11178000E
X-Stat-Signature: sdqycfzmrfom47ytaogbqec45bopptob
X-Rspam-User: 
X-HE-Tag: 1756759834-186302
X-HE-Meta: U2FsdGVkX19UBOTUX8DKM1uAzqEaNpc+sC4JaLgtqxTfdn5ukSwDDhTEreiy+WiH63JS2FdK6m5ByzI1Sown+zrZeYxy6s51oo9Vu56pBeNVDcSsE/2KG8la3dK2x208yzOBYGKnnF7H6HN0nzXWsD6J/HXMGUDiOucD5qWEf6bNBpM9vxdl0RmESln07zcvp291oN0fmwoUeLCOQ0Tif8234xZzQkrai2srYm2jWsPmkKdfhQBOGyHAQrkC+nfHrbzP/Fvs01xDr0Pw0RaAq6rjdkhaG63JDoRMT+beAYugNuY+fjbv7BBuvlSG2e8JHYiRjiQiWDOtrSEPdFCaV+k5z37o4WdJJBNpkDSRdTcirGGZDzT5F6HcpQm1LUYUdfdlacZTWM3vsbUoUHFrrwWXJY9Q+QEtWyGb4F/IZ38v7J+y24Q8Gvt+0sWxb8f5PnMPsd0r4hhmeRR0XNt/MbqB5W645BKlNbpWQwGgAHaxtMAiKs4gaqUwOt2CFV2iMqBMPJ8R/QR+2RgVi6AB374xmcncQAoApLA6oKEkSUbqnENkQtIrPIjXYvAznaprTSfRyy77UszEbDk+X0LPXQjOzGW0lTLWBtEYUKM+VBTuqy70MNMycZ7qnLLDftrOX4lNxjsGRUWopGgz5bxQCRkAE9hgjaEdddVlxRh6wIjUMilow7qoWkfxyQjMYEYI3WTetb+vNd/3yIoa5ZTppEfJm4hwyjErrQDpltp8pFPjlbESIaGXrLTJRnKksxnd5zs7s1Im013/d8yLEVKa/WytrD4ZG2At/zDwS3t00K+MSXJCRwYw10+WluuV3mggfAxyTTEShIh2t1TaxJnItzS89EKugXdqwbxieowLthZBhR/CbtlOJ8ivXWhE3beo4hXkOubg0rPpmzLZu7gaM6XKGDlFgiDGHoy6mprtmGjEL0mLMzY1nrY0oLp59B1K+l2oI2M5+2qdnN7jIcP
 DW7xZlB2
 yCt6JchD67PK2o3LTfbuo2SAEWSp1qljrRWTdOchbt76pS4ngPT4/O+mbjyB0Xzk/ld8ulEPOmaZYuJXSicwyiNSuMaU90QWygmoq/DM0SD47UAiuFYDlpYLTX9LpZsjbhGJc7R4JnoESEmDlZuPVIZIiFNJG+ZqOkzulLniNfV5xe9JeVntmNXNsabZ65cxduavrc0aULAiTF5e6rDdRGfiU7vQhj5FFEdGIcXnbPMsNFN+RWPDnPTx18z3v/aa5HnGSepPxWpJj7Y3k8YqWiEMass9vdLzYpPE5ZV3GGivI+JhGWKQM5C4zk7ugEbH6rumbHRBxXg1jFCPGj8Dz1Zt/wLnD+RrSbtUL66OBC2Z20myB6WFclYx8UGS26cb1WZWPZ0STXgQV8eF3fafdrS5aRHhI7DcAdKx9PMDnSBXdEIZMYFxXMTD911m1n9EqDT4r3AzmuCblzryipvcQfRagjqVRdm5iHw5e/T1fXPLH4U3NoguHjgPuQ2jIx5UGHlqL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

We select certain test functions which either invoke each other,
functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mmzone.h | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f3272ef5131b..6c4eae96160d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1104,7 +1104,7 @@ static inline unsigned long promo_wmark_pages(const struct zone *z)
 	return wmark_pages(z, WMARK_PROMO);
 }
 
-static inline unsigned long zone_managed_pages(struct zone *zone)
+static inline unsigned long zone_managed_pages(const struct zone *zone)
 {
 	return (unsigned long)atomic_long_read(&zone->managed_pages);
 }
@@ -1128,12 +1128,12 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
-static inline bool zone_is_initialized(struct zone *zone)
+static inline bool zone_is_initialized(const struct zone *zone)
 {
 	return zone->initialized;
 }
 
-static inline bool zone_is_empty(struct zone *zone)
+static inline bool zone_is_empty(const struct zone *zone)
 {
 	return zone->spanned_pages == 0;
 }
@@ -1273,7 +1273,7 @@ static inline bool folio_is_zone_movable(const struct folio *folio)
  * Return true if [start_pfn, start_pfn + nr_pages) range has a non-empty
  * intersection with the given zone
  */
-static inline bool zone_intersects(struct zone *zone,
+static inline bool zone_intersects(const struct zone *zone,
 		unsigned long start_pfn, unsigned long nr_pages)
 {
 	if (zone_is_empty(zone))
@@ -1581,12 +1581,12 @@ static inline int local_memory_node(int node_id) { return node_id; };
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline bool zone_is_zone_device(struct zone *zone)
+static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return zone_idx(zone) == ZONE_DEVICE;
 }
 #else
-static inline bool zone_is_zone_device(struct zone *zone)
+static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return false;
 }
@@ -1598,19 +1598,19 @@ static inline bool zone_is_zone_device(struct zone *zone)
  * populated_zone(). If the whole zone is reserved then we can easily
  * end up with populated_zone() && !managed_zone().
  */
-static inline bool managed_zone(struct zone *zone)
+static inline bool managed_zone(const struct zone *zone)
 {
 	return zone_managed_pages(zone);
 }
 
 /* Returns true if a zone has memory */
-static inline bool populated_zone(struct zone *zone)
+static inline bool populated_zone(const struct zone *zone)
 {
 	return zone->present_pages;
 }
 
 #ifdef CONFIG_NUMA
-static inline int zone_to_nid(struct zone *zone)
+static inline int zone_to_nid(const struct zone *zone)
 {
 	return zone->node;
 }
@@ -1620,7 +1620,7 @@ static inline void zone_set_nid(struct zone *zone, int nid)
 	zone->node = nid;
 }
 #else
-static inline int zone_to_nid(struct zone *zone)
+static inline int zone_to_nid(const struct zone *zone)
 {
 	return 0;
 }
@@ -1647,7 +1647,7 @@ static inline int is_highmem_idx(enum zone_type idx)
  * @zone: pointer to struct zone variable
  * Return: 1 for a highmem zone, 0 otherwise
  */
-static inline int is_highmem(struct zone *zone)
+static inline int is_highmem(const struct zone *zone)
 {
 	return is_highmem_idx(zone_idx(zone));
 }
@@ -1713,12 +1713,12 @@ static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 	return zoneref->zone;
 }
 
-static inline int zonelist_zone_idx(struct zoneref *zoneref)
+static inline int zonelist_zone_idx(const struct zoneref *zoneref)
 {
 	return zoneref->zone_idx;
 }
 
-static inline int zonelist_node_idx(struct zoneref *zoneref)
+static inline int zonelist_node_idx(const struct zoneref *zoneref)
 {
 	return zone_to_nid(zoneref->zone);
 }
@@ -2021,7 +2021,7 @@ static inline struct page *__section_mem_map_addr(struct mem_section *section)
 	return (struct page *)map;
 }
 
-static inline int present_section(struct mem_section *section)
+static inline int present_section(const struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
 }
@@ -2031,12 +2031,12 @@ static inline int present_section_nr(unsigned long nr)
 	return present_section(__nr_to_section(nr));
 }
 
-static inline int valid_section(struct mem_section *section)
+static inline int valid_section(const struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
 }
 
-static inline int early_section(struct mem_section *section)
+static inline int early_section(const struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_IS_EARLY));
 }
@@ -2046,27 +2046,27 @@ static inline int valid_section_nr(unsigned long nr)
 	return valid_section(__nr_to_section(nr));
 }
 
-static inline int online_section(struct mem_section *section)
+static inline int online_section(const struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline int online_device_section(struct mem_section *section)
+static inline int online_device_section(const struct mem_section *section)
 {
 	unsigned long flags = SECTION_IS_ONLINE | SECTION_TAINT_ZONE_DEVICE;
 
 	return section && ((section->section_mem_map & flags) == flags);
 }
 #else
-static inline int online_device_section(struct mem_section *section)
+static inline int online_device_section(const struct mem_section *section)
 {
 	return 0;
 }
 #endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-static inline int preinited_vmemmap_section(struct mem_section *section)
+static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
 	return (section &&
 		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
@@ -2076,7 +2076,7 @@ void sparse_vmemmap_init_nid_early(int nid);
 void sparse_vmemmap_init_nid_late(int nid);
 
 #else
-static inline int preinited_vmemmap_section(struct mem_section *section)
+static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
 	return 0;
 }
-- 
2.47.2


