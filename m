Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89961CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCDF8E0005; Mon,  1 Sep 2025 02:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5798E0001; Mon,  1 Sep 2025 02:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155F18E0005; Mon,  1 Sep 2025 02:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F37048E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD7CD13AB4B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:38 +0000 (UTC)
X-FDA: 83839662396.03.4B36288
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id B9BFD140008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Cy9u0uys;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfDRUXm7GSZttX/qoKcpbZzZfAWEleydE7MZKpAlbdg=;
	b=cVinmJJjGghiMDmwvDCKSmyeej3EIbpSXsGuCrkdbBlZPg9vVXt5sRtzHIdg1qKl0WWdbo
	iAAZqgl7CdtD+A/oDAXxbOWDoAqWTOSi9nST9K24LrFjHQsRenOK+uKCnceIXQS1lkwP9F
	ox29ida8ljJxpCqitRJUcLoBbFyP5VY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Cy9u0uys;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707156; a=rsa-sha256;
	cv=none;
	b=NMMExRL/i/I+sbrqRxUJJ6+1AlJC39Xj1dZmM75b0AKf+WYbX37TtSKB4hwxgdzJTvQWCA
	cVFB0xnZL4C3h3TYIL27okPT08Lo6mEbugvY5gQO3fTIduor27XVLuZYOl+1m5zMyoNQp7
	Ro5TwzuOcjwtCSfUR9gnQDrmnkJGXPw=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61cb9e039d9so7775612a12.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707155; x=1757311955; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfDRUXm7GSZttX/qoKcpbZzZfAWEleydE7MZKpAlbdg=;
        b=Cy9u0uysd0AkDXLxzbUlOUK/pPB+858uN9/3IaiXqe2GD1R5UJNeN81PYr4kaCNmW3
         1n8K/HMXTT3n2MlHPiH+07MHI/dMI3mCQsD8TizyuS1f/d7twTx/+ad2NHpqkcQRRQAU
         ZLO9Th88pTWTcqYyVOx01sxPE9Jzm9QcYXXrEBieyKHLrLYhV8g1548tzacErm1i7TTj
         XxrQCxLJJe3jTT3lAtNDsC+NOnN8RusQ6/u2pEsYj0tn/21VvqvkEcZjm8CFYmGeHklX
         lrGcSg6NkFuME80wzUsksEF4+7dsLASWvSs0FsJQTopOzrB1qmZASWfG3tX5ZTfSfb50
         CdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707155; x=1757311955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OfDRUXm7GSZttX/qoKcpbZzZfAWEleydE7MZKpAlbdg=;
        b=VnlyEWgTBeAQyZwwEHkAIZtoCgYRc4e7k2hKL2fI6UQG7g/Zz3EqD9DWZhr6K4MkbP
         5hmz38lyMcJ1osehBSK6osS7qfSFaKDCKbTL8TLNQTJwTnreKrFZwewJpKCjgY5ncGym
         5QTX5DtyiYI5kzhRMWrh1Bh5/wD8xsc+J/9bl/+WR6hRc5dD/r2CnTtt/JGl7fLW35Qh
         7YSFgtykqd3VOBM8n2tSDaPx7vlEhTonRXBdSMKAGYXh9HV6C569BgFBxAtJo8/A3o0L
         L/kQRdzl6//VtfRTtWoHJwwJia+ws1jUh7S4lkgXQYDnF1wJGSqsxHTD6xExH36cGljj
         2WmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVA+voABexIVpORxto2JyAkYCAfIVlN5dMXJHe30l8ej9hEtAMBQLQOTu8gVmbqC0Gwnc0/cOhOtA==@kvack.org
X-Gm-Message-State: AOJu0YyKhRXOWPEzZW5ZG65yNwavZhsxECGbX42t0vHGWguEdo8pFWxP
	klak7BMIX/fWlWmWzrLyi2tQAGXYxK5OAkaBGN4J4ClN1W/oL182m2DIJquIXsQjuKc=
X-Gm-Gg: ASbGncvATL9G5jxhXhReWK00PfUUa13FIEHZ86ZTjTxbFPKEAAYwMxzRsHvz+1EZCKC
	K7Tak+Q5sKj6JdjxJQpZNdXl8OxC4cJB8ZcdCzV+L6yZpdJszmcjRC0s4kD128TCH3LzVu7hxjP
	MoLF8eMpbA0i2thzn2BiwiRg9d9uTOdFcU/mZjj4p+zN9l15C8lZfuNykbCZvrXmYa+6ylXF1Uk
	BrLMSHPQ04mA8mHbmW+o1ABUddn33c26T0Awi45XA6rnvfp631DaDn/FfEJo16HjUOJv9Wnct85
	VWtuOwyD+7UeYtjaXyWHS0zOMYMYsfZLpJyd4f0j5EtVHsE51SWmL5iBA2vKvXJZEAYjHyvnWwo
	MuAJj2rBgx7yBVxmwyc9lchMjj0aC3mk/yz1SZD9KeZ+TEDD97D4FD1M/qAK68xpPp9TOb76ekH
	Nhc69UmJv4XTmd3lL6ilAcug==
X-Google-Smtp-Source: AGHT+IEI+/052EQvn2HkQ3uPQ4HOT/tEpF37FK5n5389qJs3n9FMvOvIqD4njM7OvECWY8CWysAFtA==
X-Received: by 2002:a05:6402:51cb:b0:618:2733:1a52 with SMTP id 4fb4d7f45d1cf-61d26997500mr5190269a12.8.1756707155269;
        Sun, 31 Aug 2025 23:12:35 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:35 -0700 (PDT)
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
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 03/12] mm/mmzone: add `const` to lots of pointer parameters
Date: Mon,  1 Sep 2025 08:12:14 +0200
Message-ID: <20250901061223.2939097-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9BFD140008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7suxexk9b19g5ubcyyhf9oq3i69o6osw
X-HE-Tag: 1756707156-985963
X-HE-Meta: U2FsdGVkX1/i9DdO0NILp48fG8fq52BuO8qjzO9ILdHyV2SFPm7satE7dItvvAgS5LhA/ZOL8da/vxwzrRaHgO12M2A6CpcrXx7/EUIUNThOnCF0wAP2QgFSHKt5dZboQAtBI6ChZnhAudOVvp3wQDsMZgcqAYn7yK/S5DXtX2NapuKhyLHp/2PnltAv6TyBayj5AC7L6aE2qhTbOCEdQDcW567AFVqTjij9csc8QAJvJPxrSS0MnvW71gqgbcdbHoYpNKx7Ef+2tTXBB5h28y7SKDxUwUFiHvKLKO2qeVi9po2fkE1Fqu/kblHJhgrz7q7dXmaaQnpw/CDO4rPbf4UITk6Zr6IaHF1MBwszsOlylPUVZznKlO008jFn/i9xnOSoIiUxH51p3/espR7SoifKrODuD2tCpYrQeFPjvvfJoms4HuGhOMdv5K2m0I89bfrPi365c99hrugmDsCyHHYzvbL+L55qm2qn+coP9mKapDErdYAZAVg4XZ6+ue2ueDRcv9BAe/oNVvf8CKI6Gr501fd0E7VQka+DZW4xdIVvOiKkjk6Rqt9dDtqcL+X74zuRSV6PiVMlIsBje4OhzbeGSJdFuj9PdizkcDUO+I9xqp2WP9wSTpk4qM+PoAPNqqomWUdX7wgnwxaI0eKEJSp5mF/RvyvBLgCs+R1P/WHJgyLKcgVExxfvJhOg4D+Az17dcDLanqdca++jVCXS6GUl/qwStQ/56QvEH1T6Lt83no3040oSZ0qlJBf7BJxSnXpJPRLs7ASLqlm7EMN71TmsLQlGYAFANAqI16S0IusgL5ANDayzfUsHRa3MVa/ZqPKH1t7TzyYQJ2BdHladmE9i/DX3x9j6vabN9ROm/h8OHvHF0SVPwViwfXiYwPBIGOrxXpytwXnF1rQRpDn3rT7UoaOAm6SGFR0mZ8Wr64cimj4FNdzAUs043FZzQHOuGcH2PncRN8CtCBe40Qj
 d8Lw5t2K
 HEj1Mm/z8RsKYiK4irhDF3l36tkvmkdUN8DrNsyY9EkQbhf4r6pWPAnQXC1DQVJ74jVMPMrf2zbylX0ZdWLdPA8/XrDr2hWOEOk1YyojMD1sB2NsEEMXS3KobclAxhtBkhUPbUXMeGeHADPpGIMKs0k+a+Mo8eQdR3ddJaVuwqAGD5ysK5kb7jaBG2ocJH5BBbXVlbE6FUaFtjUec2JOjQX6I27MZLPxHHfNiZKRPnCgl1i51uFvdtM/BPg0/JyTumkf/sHSAoDDPbBADYt7qK2t9hMoxx03waKspKT6S88LdVr5M2UUsp0u4jBqAZTEGgEHmektyLF9Kaxcq8AiROTb3reaVzkOx2fLiXjqeegGzQT5N4poz62nyCG8t+zse275yZasNuqImScEHRf1J2a9ptC075sGae7FC0eL2NfKTsM0TYCCE63A0nij0T07Jw1tXXuvWszEF0JvD2hVYmy+6xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mmzone.h | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f3272ef5131b..9a25fb1ade82 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1104,7 +1104,7 @@ static inline unsigned long promo_wmark_pages(const struct zone *z)
 	return wmark_pages(z, WMARK_PROMO);
 }
 
-static inline unsigned long zone_managed_pages(struct zone *zone)
+static inline unsigned long zone_managed_pages(const struct zone *const zone)
 {
 	return (unsigned long)atomic_long_read(&zone->managed_pages);
 }
@@ -1128,12 +1128,12 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
-static inline bool zone_is_initialized(struct zone *zone)
+static inline bool zone_is_initialized(const struct zone *const zone)
 {
 	return zone->initialized;
 }
 
-static inline bool zone_is_empty(struct zone *zone)
+static inline bool zone_is_empty(const struct zone *const zone)
 {
 	return zone->spanned_pages == 0;
 }
@@ -1273,7 +1273,7 @@ static inline bool folio_is_zone_movable(const struct folio *folio)
  * Return true if [start_pfn, start_pfn + nr_pages) range has a non-empty
  * intersection with the given zone
  */
-static inline bool zone_intersects(struct zone *zone,
+static inline bool zone_intersects(const struct zone *const zone,
 		unsigned long start_pfn, unsigned long nr_pages)
 {
 	if (zone_is_empty(zone))
@@ -1581,12 +1581,12 @@ static inline int local_memory_node(int node_id) { return node_id; };
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline bool zone_is_zone_device(struct zone *zone)
+static inline bool zone_is_zone_device(const struct zone *const zone)
 {
 	return zone_idx(zone) == ZONE_DEVICE;
 }
 #else
-static inline bool zone_is_zone_device(struct zone *zone)
+static inline bool zone_is_zone_device(const struct zone *const zone)
 {
 	return false;
 }
@@ -1598,19 +1598,19 @@ static inline bool zone_is_zone_device(struct zone *zone)
  * populated_zone(). If the whole zone is reserved then we can easily
  * end up with populated_zone() && !managed_zone().
  */
-static inline bool managed_zone(struct zone *zone)
+static inline bool managed_zone(const struct zone *const zone)
 {
 	return zone_managed_pages(zone);
 }
 
 /* Returns true if a zone has memory */
-static inline bool populated_zone(struct zone *zone)
+static inline bool populated_zone(const struct zone *const zone)
 {
 	return zone->present_pages;
 }
 
 #ifdef CONFIG_NUMA
-static inline int zone_to_nid(struct zone *zone)
+static inline int zone_to_nid(const struct zone *const zone)
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
+static inline int is_highmem(const struct zone *const zone)
 {
 	return is_highmem_idx(zone_idx(zone));
 }
@@ -1713,12 +1713,12 @@ static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 	return zoneref->zone;
 }
 
-static inline int zonelist_zone_idx(struct zoneref *zoneref)
+static inline int zonelist_zone_idx(const struct zoneref *const zoneref)
 {
 	return zoneref->zone_idx;
 }
 
-static inline int zonelist_node_idx(struct zoneref *zoneref)
+static inline int zonelist_node_idx(const struct zoneref *const zoneref)
 {
 	return zone_to_nid(zoneref->zone);
 }
@@ -2021,7 +2021,7 @@ static inline struct page *__section_mem_map_addr(struct mem_section *section)
 	return (struct page *)map;
 }
 
-static inline int present_section(struct mem_section *section)
+static inline int present_section(const struct mem_section *const section)
 {
 	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
 }
@@ -2031,12 +2031,12 @@ static inline int present_section_nr(unsigned long nr)
 	return present_section(__nr_to_section(nr));
 }
 
-static inline int valid_section(struct mem_section *section)
+static inline int valid_section(const struct mem_section *const section)
 {
 	return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
 }
 
-static inline int early_section(struct mem_section *section)
+static inline int early_section(const struct mem_section *const section)
 {
 	return (section && (section->section_mem_map & SECTION_IS_EARLY));
 }
@@ -2046,27 +2046,27 @@ static inline int valid_section_nr(unsigned long nr)
 	return valid_section(__nr_to_section(nr));
 }
 
-static inline int online_section(struct mem_section *section)
+static inline int online_section(const struct mem_section *const section)
 {
 	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline int online_device_section(struct mem_section *section)
+static inline int online_device_section(const struct mem_section *const section)
 {
 	unsigned long flags = SECTION_IS_ONLINE | SECTION_TAINT_ZONE_DEVICE;
 
 	return section && ((section->section_mem_map & flags) == flags);
 }
 #else
-static inline int online_device_section(struct mem_section *section)
+static inline int online_device_section(const struct mem_section *const section)
 {
 	return 0;
 }
 #endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-static inline int preinited_vmemmap_section(struct mem_section *section)
+static inline int preinited_vmemmap_section(const struct mem_section *const section)
 {
 	return (section &&
 		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
@@ -2076,7 +2076,7 @@ void sparse_vmemmap_init_nid_early(int nid);
 void sparse_vmemmap_init_nid_late(int nid);
 
 #else
-static inline int preinited_vmemmap_section(struct mem_section *section)
+static inline int preinited_vmemmap_section(const struct mem_section *const section)
 {
 	return 0;
 }
-- 
2.47.2


