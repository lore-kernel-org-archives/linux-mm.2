Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B55FCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7647A6B0024; Fri, 29 Aug 2025 14:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BCB6B0025; Fri, 29 Aug 2025 14:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE046B0026; Fri, 29 Aug 2025 14:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BFCF6B0024
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 061181A08A8
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:13 +0000 (UTC)
X-FDA: 83830639746.02.C8E42A4
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16897140009
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=J75jumsD;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf23.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oibqmI8v+HWCWZ9ViDRReAYoAk04POfRsF79xWQhEJY=;
	b=2IRrkYMJwsDGw/yGEnmBS2QGigPC00c2TlHu3lolEInd7m3CDtvJW/oWjl1TjN+PsCGNrG
	ayz0OGA8QRMxeR/t9m11+Spqna91CTxnoJyJQrYtspvM3GDQMneIu1sFNs8rU1vdSJtdNE
	Qto2BNlx/3nShxxujipNjDLtBEkL4+E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=J75jumsD;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf23.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492331; a=rsa-sha256;
	cv=none;
	b=kCHbq11KMH4s/cbk3yiBKG2zshGgQ0a8LBw/8DlXKqVm1X9sIc+5jrBUzSgaCBij54gn8c
	mAwWFGZspC00z4bSKUMQE2xC8BzbPCkEknuvxEIPhNkIoW+rBd8YCR2hzIuCCzPuQJLaBt
	JmZQ5SsS7wKDUWYRImBEwlrnDRLlg7o=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afedbb49c26so374444266b.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492330; x=1757097130; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oibqmI8v+HWCWZ9ViDRReAYoAk04POfRsF79xWQhEJY=;
        b=J75jumsDsfx5M5GIKTwmimjV2KW7OLGCQnwuYvzwYedFNnBzFqHYYS535WGzQhT8u0
         KI0X6j1UL1cb6kH8NX7R4yMJJk1uohtadJ+BwY/Ba6ljqUoPscFDj1mKSevg5f7Mz7t4
         Uj9GaaTRmpHfhq2nfTY1AvSNvL/97JBuctHzzeoiJf9POSEwd5jEU2Gg1a6QX0d1GDWJ
         Uhic3Or5xzYMnPDAuIJ5N1zR5Df0K6zGfLpbOdei44yzBLcNuLFLfq06XhkaiGX0uyXu
         c2c9UenB6DylNA307Lib2SztkVQfQzXVZTpsQPPXu4GU9b5Y6Z34jcNfjPBVPiGtJP4l
         96/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492330; x=1757097130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oibqmI8v+HWCWZ9ViDRReAYoAk04POfRsF79xWQhEJY=;
        b=PblrCV2iwJwk0gmhKGA+xxdHVGsyzaNmWPquNoHQfLCwAmVG8xMi5SPxF0BODlVp8B
         vluI6NQVtmJR0jkYXAe5iVLYkWeFA7vvII7ljVV0ESu39RoaQZec7Dw5wShUsU9nmQtX
         /7NYE2R5kKDyJ8t8xoF0Dn/DnUXNOpzaLl281t0my1/FOeRGbiR5Ls5LZKprDY1fOV4+
         RgeASe8ERapdJU2kY5qkXvuvQrx+1DaF53ofyQ3O4KvWK4/pfgZ8yZ+RnpoqIsLADHFy
         Kfj63zshBftdeKZ1amNRUNF29shS2M6Li5E9PCKD0rfMc2nIB2nrEeOZN4Do5Mq7f/T6
         0GqQ==
X-Forwarded-Encrypted: i=1; AJvYcCW33j78/ybtIHNezBZPAHBlX7NtZzA2S/5LrUxih8D/DjABHRtDA9pnmHVupxqKBbM5YjIvei8NGA==@kvack.org
X-Gm-Message-State: AOJu0YyJgTau5oZ3QbiheFW5wA9tEL1kjYBkQ0cMbUKG5iombET3QGST
	n57Ra+bHQet5is/QnmhEoRCVXBawcMnU+ihprF3r2fQsnIyTY0AS0yVVnt9PR/tmXgc=
X-Gm-Gg: ASbGncsJb1QIl+BDb/s5v1l0ZN92+qb1+yipLCdCvVbGy3+H+f3Ps4VZLDbIGHt0LUC
	p9mvmyGEvaTGJnjrYFjHuC03FY85rpbTt+EfhQca0pds5hSp4iuhTOHDL6DVKH9tzKChXLh2maC
	NItO8HExYnhN1QCr9kydMRRutWmUtQY12s4esKZV+UlSDmUYjeKkokxeWM69fAm8EA+jc0WMfvC
	bRj2Y7vhf+EH4OkprCqBht6oge/sRh2T+EjQyePXhG6QGUtYSLUxPkLiXFyoDVUZ8m21v66TqfV
	ztlG3OLcp0WTT3f7aPjK9JM5rhG5rbLvxg6/sxJdf1K8Nf+2DOPJPJFwNzIecE2ahKH1opM0cAi
	xNU8QSaLNINbZHF0vINNXjzDMLQaolpAZeG0qq4k/nKirfYP4+MVZL3Ipg02f8rwsr1b9TEOiSN
	fmRgJYsFFBbYP/6z4UMetw2eRR9x35pTMU
X-Google-Smtp-Source: AGHT+IGUw1aZ9x71ac6zJGO7aTmEWDSQk81WmXJEAyxTzFCvKu5HR8+0UP39oGUMJnx4qlOTNYHCGg==
X-Received: by 2002:a17:907:3f12:b0:afe:c564:32e5 with SMTP id a640c23a62f3a-afec56519d3mr1113660366b.15.1756492329546;
        Fri, 29 Aug 2025 11:32:09 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:09 -0700 (PDT)
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
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 03/12] include/mmzone.h: add `const` to lots of pointer parameters
Date: Fri, 29 Aug 2025 20:31:50 +0200
Message-ID: <20250829183159.2223948-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 16897140009
X-Stat-Signature: tyn9ndf7fo76fmfqmtyrjg1qmhn3jxyr
X-Rspam-User: 
X-HE-Tag: 1756492330-650334
X-HE-Meta: U2FsdGVkX18BEePj/JKeG9NWGSebGxCaV4/42GSE2qrSZGVNpCy9a54B/wyBlXLnbIa2VFjPCLAt52Wntt9DOMTFFN0v2QWuvmyObzRdLPi+uErucmcW7Cfc0Ra9axEfarRrIyVccSDse8/I0Tc8eIAg0gBoEqLzB47R7wqaIC1NdYkBveX9Pzcg6dSJsvVN8lNGxQNKEQiAAbE+k13eSedNH5Iw/SPRG0d+7R7ATW1ci/9xzxvyBgEIZbXUXHe0ZbdSF5zuWA6/uJTUQQu/9kQC91XzZuFvf+V/DOBA1iRm4WroINpXh8pcc+AasPHhyDq47JgS9Uc3+rgj/Q15CoahIyLGovykcq3ZiXK/vDYuSAb89ACHxfoxgW+eCNRVugnwZORe6fEVn2QPNgq3NB5hqiG88oVaqb8E4XXiiVr4c+aXLIIciu7dkW9mWIoXyZduBPwJRPZdeDnRbJNc4r9E9DlNZyICQk8K+7DxkVWRaqfWwH4ewOd2LKRUhU/TF2JT9k3QBz5MxNXZ/k4rP75zlDNT9ffMxXDmkSaXOn+beiCd9avMaXjqr6oAQ1sSRhV8+lFZVpkL2ZPbE7tfRS6XJjB81MEDsfATf8IL2bu0/r8F6ESq7tu7itJrnEV1EAJAvpl1nMVHir1kxryobFSohnoPMcetVVZu8YlpHmjr/bN4f+j9T0DKJlrp+sirf1DR5ncxetMfvcbWhrvvw96YeOC/+BAT5Vu3YmuSVmwznL51Ya6luWopVAQErZVQpHcvIV4y1rJyXqp2PoVLfdl3Gzp0PDFm0bYYE7U6oiXkf8w7EtPsTgMGqNbLAxOBWeRswaN4LuoUy8H/2ZE/CMzWRqoHZFM3FB8Pw7MvqsSFJHHTYexT350Uc/Dvy1Al4B56zmiiLKCALW69fzd3x/rYoAFo1X2XiUEdObOBpRw0XbVlyyDVP/f1BGioxdn+02F3vDDk90SegRNEKcz
 zQ0oL+iC
 7MSL5PQzdaXUB75BTo6hC5EI9aawSvtdTQQ7O7sRYgT9D6lZ5Ue6X4I8mjGNWtcZbD8HT/D8EL9yzVMr8nECEH7v/sww/PC1VI+lNELyLoeTo26AwBWAukd4kPED+h+b8Z2m1nOZDAKGPog/R493Hny+l/l5tScEMNeobi2440eqYHPkZC873i6Hip+bC7TPUig9iJ7ljBEhwGgx9d2tz8kLKHlD25uBwHoi81tDlW3+SrVshretoiC1I3HaTO0RP709TeMeIqiSAMSzmlSDvg8rv43Hfwb5nfExlUGGpjHOS9ewIJqUKE9ff47XtM/XjAKPRDMbt354SWrE00iRbvQ4csBWzxW2ViBHFMsxNqhnnqUw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mmzone.h | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fe13ad175fed..3e16578767b0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1103,7 +1103,7 @@ static inline unsigned long promo_wmark_pages(const struct zone *z)
 	return wmark_pages(z, WMARK_PROMO);
 }
 
-static inline unsigned long zone_managed_pages(struct zone *zone)
+static inline unsigned long zone_managed_pages(const struct zone *zone)
 {
 	return (unsigned long)atomic_long_read(&zone->managed_pages);
 }
@@ -1127,12 +1127,12 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
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
@@ -1272,7 +1272,7 @@ static inline bool folio_is_zone_movable(const struct folio *folio)
  * Return true if [start_pfn, start_pfn + nr_pages) range has a non-empty
  * intersection with the given zone
  */
-static inline bool zone_intersects(struct zone *zone,
+static inline bool zone_intersects(const struct zone *zone,
 		unsigned long start_pfn, unsigned long nr_pages)
 {
 	if (zone_is_empty(zone))
@@ -1580,12 +1580,12 @@ static inline int local_memory_node(int node_id) { return node_id; };
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
@@ -1597,19 +1597,19 @@ static inline bool zone_is_zone_device(struct zone *zone)
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
@@ -1619,7 +1619,7 @@ static inline void zone_set_nid(struct zone *zone, int nid)
 	zone->node = nid;
 }
 #else
-static inline int zone_to_nid(struct zone *zone)
+static inline int zone_to_nid(const struct zone *zone)
 {
 	return 0;
 }
@@ -1646,7 +1646,7 @@ static inline int is_highmem_idx(enum zone_type idx)
  * @zone: pointer to struct zone variable
  * Return: 1 for a highmem zone, 0 otherwise
  */
-static inline int is_highmem(struct zone *zone)
+static inline int is_highmem(const struct zone *zone)
 {
 	return is_highmem_idx(zone_idx(zone));
 }
@@ -1712,12 +1712,12 @@ static inline struct zone *zonelist_zone(struct zoneref *zoneref)
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
@@ -2020,7 +2020,7 @@ static inline struct page *__section_mem_map_addr(struct mem_section *section)
 	return (struct page *)map;
 }
 
-static inline int present_section(struct mem_section *section)
+static inline int present_section(const struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
 }
@@ -2030,12 +2030,12 @@ static inline int present_section_nr(unsigned long nr)
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
@@ -2045,27 +2045,27 @@ static inline int valid_section_nr(unsigned long nr)
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
@@ -2075,7 +2075,7 @@ void sparse_vmemmap_init_nid_early(int nid);
 void sparse_vmemmap_init_nid_late(int nid);
 
 #else
-static inline int preinited_vmemmap_section(struct mem_section *section)
+static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
 	return 0;
 }
-- 
2.47.2


