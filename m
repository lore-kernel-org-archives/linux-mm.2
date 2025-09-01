Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4D0CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088F18E0033; Mon,  1 Sep 2025 08:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0125A8E0013; Mon,  1 Sep 2025 08:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59818E0033; Mon,  1 Sep 2025 08:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B346D8E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F15557356
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:42 +0000 (UTC)
X-FDA: 83840615124.11.9758AFA
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id 804FC20005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=PYvVHRrC;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URv9x64q4vLQVSw6o/AGB0bIgfNWsPBlnMBV30KLfzY=;
	b=SfRla4ifapSFFp0CPmE8IdvqH9mhmtV0TZtjeUGfskrHdXog84cmavYlc1YWse0pyJbc7N
	YVA5o9Hm7meUwTXOcQUeWadWcdkHmJVd0XL94VHq2IEIH62AHFuZ6NLLQlYc7kBB0wYNJO
	b9tmkJyk79nKrcdjJ5msAGegm2dFlXY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=PYvVHRrC;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729840; a=rsa-sha256;
	cv=none;
	b=M2y4g2OVkuaNnSOR2reWqNwwHszdZlEUFAjBP729m4i5e7rPdfP5Py+KF/gNGDAMpFNPba
	Bs6fwf13fM2y8WyPsKHcWruvs71vK15kXf9AoFsOSE/Wm51yQbFeibau/L6cI541RsaNa8
	X7kE6eIx808OfQxE1/S5hYSCfqHjLW4=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61e3b74672cso2280026a12.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729839; x=1757334639; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=URv9x64q4vLQVSw6o/AGB0bIgfNWsPBlnMBV30KLfzY=;
        b=PYvVHRrC3YRLO2sOQ100t4FueXu7bnyZ+JPNpwREZeWxrM7JPBc5Bs0HWPrRTYHt+Z
         3RLYmUdyVw+40AuxPFaxONbJWTTpgHHSuGYOML28h6pQL6PRq+6fpgi7hwRMRmJgxcYB
         0mdiMFbxa3aAhoOO75IfY4VqYjcxzN8eETrb2UfMq4DTFRzDsoh+XAbHKGECHMin3xo0
         v3zOf/jgRDASq3CicAKXAzhQDvkzeIShNWB6nxVKzgwu7PQZIcX6cBhnO3+ByozstU62
         vUefTArg2YuvHVHqIHY8Poiw+ZRnEWT40BFhfCfnyLtrVgc3cDx5t/KUD6k7qq2zroht
         vyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729839; x=1757334639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=URv9x64q4vLQVSw6o/AGB0bIgfNWsPBlnMBV30KLfzY=;
        b=ar394E8ckjVIr6R2kSRjidCoc3Ums6dEor79zcrKmAbAzfYbysUN0QKCv2mYKgUmxk
         53vd55m5K+Si9mpA/X6ABEgP8kFhIgwkCSPXFUYF6kD6i8BtZHK1jE5AJZorP+VCP0qL
         f8+ycYusZ+lfcKHuc6gsw7uNuKVhHA+DgX4pbJPDjOIIJDhBYTI5+XRMFHTAlAAf1N80
         9orPZKA2VsJxKbrDbG46q7yCpbwQFbPnjUeI+r6BPySZVuYPj90Y1zeKiSy/CHk/wbsP
         umr3h6nUvLqFyt9WDBnDBAVkBYvk71DB8btD0csswSEwgkVBy1JfTe3P+/boQOPSagtA
         af0w==
X-Forwarded-Encrypted: i=1; AJvYcCV1Oi9DQGQU6hTCvTAWzp0VRENQ6Xa8EbxoEi+4sm830rCXh8iLNC+wSoWxeu+X8RyYINsPUxCLYw==@kvack.org
X-Gm-Message-State: AOJu0YwPeccMne0Apx0ErpUNmJLVLqREcS4km/1txFajcGMjHKOAfvOK
	DWHu3TPOfIEz2mL3Y5WUGVOJ02ZwCaA2ytX0FarI9DDhoLrX+esqKg4kJQiKkXlIlDY=
X-Gm-Gg: ASbGncvrkfszKt/wEG76bZnhg85yoGGoL0phlqc48Z50AIImxwNMJafMv3j00LW25Ay
	TvQbHJh0NXOSXHBQgtiVZKKj09KfLy1KX2jCB7xJGq7nk2p8FAwCVTV0EgHoMXL9KUP5WzaZJjg
	0DM/fr7CjcSPbEO7odBXgkwK90my1GbrW5E23Z6TSUS9VsUwmhvcRUxLlOgXRa5uocJ24EbFUmO
	YnZj8qnyFxRbh+eN/YQ9yIDGqkxP/8BZUToSna0ynKW4KTmLRU2KVQI5tn1MVys2mXfJgYpHbhb
	oqCOi2c7FIVlHZ8lctgI/jfmUihTD3CHPFvdkSNHe8GbL0kK1NstV+0HpugBX29qP925cFKewd5
	MF82IVR2dJ0E7GOKdFjEKCKCnh+zcrYQfIgdbjM6OvBrAJO+J6Xx6MMVjXUqPE0LjxVlwSBf9To
	oadh+f88wfpvYlLUYCzSfjQA==
X-Google-Smtp-Source: AGHT+IGvocu+GUM7r7JllEB1alYpzYWhNpDwmZUi+589Y2v0utgEYLLGAevBr2manMrYMhc61uAlCQ==
X-Received: by 2002:a05:6402:504b:b0:618:3521:6842 with SMTP id 4fb4d7f45d1cf-61d26d9c52dmr7127139a12.16.1756729838873;
        Mon, 01 Sep 2025 05:30:38 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:38 -0700 (PDT)
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
Subject: [PATCH v5 03/12] mm: constify zone related test functions for improved const-correctness
Date: Mon,  1 Sep 2025 14:30:19 +0200
Message-ID: <20250901123028.3383461-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 804FC20005
X-Stat-Signature: 3t8sthznq6bque5e93ye9b33igtffucf
X-Rspam-User: 
X-HE-Tag: 1756729840-798281
X-HE-Meta: U2FsdGVkX18KBj1DcJVaM1wjIj2YsHigxWZ258oi8jzeD7kY/uqRvy4uazVjehuHj+A7w5AElQTTrK3UBV5+8Fc1GwPZuvUkmcmcUCOVR2T+EzSwgeX0Q2lJwWKbJ8YmT9d+rRxnykXsTRGgcBUwgfzEk//HI93j5KcfWaOaXjdU2MxCJD6DYiYsSo+3rnH/WA/RJI6ceOG6LfBDw7H2KPAsNK+HWFYsTHPO2FI1y94ioZ3Y3sadYZSTdfs0/u+mdq8FsA+MPe63M2hmaReornZ15TC9+ux0GYsRSlSSQdZsvZ4L2YNHRqTRLA4txlHlsvDwLmPx9T3jUdHWnLeLp3MDn5S2B60ALSRvKwVJEPuxczb+HoKrs9HxJyj+qJiVvB0R/NlNNjE6+FHvfwpefOAg+mueB8R9mX+U85X21dnt2Xg6Dz6UKPyZmcLlKfc1TiDpH80EbFxsiRUiGiaopgzw1p7dP4l/5DxefRvAnz+2Xo9oVAjIhF8XWNn7c68jKMScGXBRnkaonEuI42hZilhyvXS4VsssUy+7og2OxN0V7RaA5kjPRkuiVDEd0cYc3MnlVFNbTDlsRhS+Q6R31zc9RgsANXrFjm0OX8SCKest5vlZgDpeCg+TLVO9jo25UV4LR8v8Kl2kPGU4Lt1QAKf1JYAhYURjnu2uj9aXa0BMyy3NrgBv4pu7180be9JAB2lXm8/ytIiV+k1v/KB8+Ssfx4Qfn7evolbJRhT6eSCDOijxrMpjzHg4i7imJy64xrQZ9fdGAf0sG+UbOv61IZJAi0/fWwQ1kyJGkG17joQXRL3+46vT1o46ovGxrdOp04g23QJ16hsLZqnlnguXEWWN5g1IKsWg6/o3smFlwc+WroNBR7P8x/dnmJSxGcmzKYF4ozevMD2lVQxul7tCIP3+RRzUf6CRWGYNY+mXDwz9mrnhPBNe4Lfj3ndTeJ7qGkVcC5U/8z4aSt2kOH6
 QTsstQ+I
 MGhBHIc4/yuSUabQo7K9HmglGMvh1LVqK/dbMLrd+ChUm8nfQatyUR4d/lGmwTHiWPWjLji7SF9OJYJ4JZVO+dzzxA/EA/wTYqx8T6nlhkX0Ld+D2K4g1vM+2edniops1GLBvkrAVgacm88mmmKLa6ehEcrtCGT1Sf/HWNTvfu09/hr8P2NfbVubD/Y2wkCfmFZkEcxQDInoKrHWDwAKL+DZZHCCmkBeuN/rBgARaWZW1D30KNEuRlU37yaYpSk/cHZAgm3blCkUv2qfDpoKqP7JuQ6Xz+mnF48gfxWkyludNgI01GaCRDKn+qH8P/bPRbAOeV457NBrIKB78YKUcNxN4pyEy2y9lsFWiwAmqIUxGrpa3ucuBsyhPvayE8gNUWrC2A4qLmrth5K5NRQLwPNrlXlng1VsAGf9HXlx3krZQbH8XuX8eEf4Jdp2cV8crsW+xc2GaBFd7tyupFlqaX1NWCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We select certain test functions which either invoke each other,
functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

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


