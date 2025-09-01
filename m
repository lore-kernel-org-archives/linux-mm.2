Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A29D3CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C1E8E0024; Mon,  1 Sep 2025 05:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC9C8E0002; Mon,  1 Sep 2025 05:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802B78E0024; Mon,  1 Sep 2025 05:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 678188E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22C521DEA99
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:33 +0000 (UTC)
X-FDA: 83840133426.02.26A7B29
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3125B140004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=bySiTZE9;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf09.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718371; a=rsa-sha256;
	cv=none;
	b=u6vprsdJqJKxuDi26zUvOD7ZwU/eco6XT95KmTAxZFYqeEpimKQ8BEsPSewAr8YmGFlrHK
	K5jbas/Er6FqB+MiAqRTrXWmNEipXAtvhZSeF6H2A12zdFd3Lj9GzBNJC5gZ9JyubNlAKd
	E+zTHQflLhX1oTnFSK9vmk5yiCcqZWk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=bySiTZE9;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf09.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqkRolEiPUj7RJL2rUljUH40PaguAeYrnxbluGnyi6U=;
	b=3L5bYeremg3A/7G/HnJ1xwj0j2CZMqSmU8WdyiyaHqwQh5q1dQq9Pd7LjzVHZireYJHMKr
	jyFaDoVINaGbiceHjcrqSORadQJmxYFIIJMEwV8ZAvup/eIZI6nijVO5ZYqbhdTHBoYKBi
	ex7/4wQTTzxtOlZZxcSnKLYgyC3imBc=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb7322da8so802414366b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718370; x=1757323170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BqkRolEiPUj7RJL2rUljUH40PaguAeYrnxbluGnyi6U=;
        b=bySiTZE9OWpEfQBlpkzLTwi+11ii/udzuRUNdvyaEDVbyH8POP+DoSAoLJ6YHqp9Xy
         YP82kZs+IXEuoIoU0NVdGiSIH0BQZzuOKbEUj08awW1aNEERDt+yUjEDwWuqDHPCeGAE
         fthxAgoxkG1FHpzPB0+CsOI4brq655Wk7MZy7CL0rlW03gVac4zPYOO7pJedyjUxijQw
         bV1uX8abNndvkStkH5MhG3IYo65lNxLB71/8/sO4g9/5Mb6CL0AKqakTTZ3DG8wLkC4h
         pkH1Q2ndv12079TG6p/ije1GnslwoIyYce+mxC1PgN4XW2pLx9Njj4r4GFnSJZxU1Q5V
         n26A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718370; x=1757323170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqkRolEiPUj7RJL2rUljUH40PaguAeYrnxbluGnyi6U=;
        b=XckCda6xfnH9bd7Xf4NkpUMz4f+oxlzI8vkEjKfgq/58HLVqEUqspIb8X1mbfcXEPC
         nXGcZUpCbpWKCZNii8ir74iK73wJZHbTOflgAValyhwmR6ntd+7/1RzO0Ff9GhdbSh+l
         zCBYQ0l2lz6AGAqdpWO8OLBBM/0Cn9p1nHx17P6rLze8bWjouCbYPtSNb5kI1OXmbNjD
         6MxCELwN14kjjaUlxwf3t6BuJoGMgtSt2Yz3dveJNxqjITGAH95qG3SL3EV2ECGtxMUB
         uYYn6dnZy1LFuZw9POhYp2wiOKYwTNXvYV7/nDWSI340iD2HoTkyQrcClawgMG2KA+4Q
         JkeA==
X-Forwarded-Encrypted: i=1; AJvYcCXLaG4W/3AxWyooZXImKGJ+E4njUEOMX7bzChCaC6cAs8Z+6B5Ez5HAG3zzOBSAlQ5vw5pF48K1dA==@kvack.org
X-Gm-Message-State: AOJu0YxfSLaKQkDYkaJn1fcW/N9TMry8MbKoxgObuyT4V84ykzJjJ7M7
	zuj+AxODyGWvjLLkO3QnfeZc2nobNHwtIPaaFwEbUV57QotFD2CQ18gn6gPFGZTx7A8=
X-Gm-Gg: ASbGnctEkS5SAJUFBbECGoNWkdWmaPiU8tWkgwT2+ldh2W/rsKazpeQ/Za9HqGjjJZJ
	cfumV7XDm9I2GZis5P3eh/d3qzu6vclbJYYvTveSgLGubdRPMOWe/kJXQBH2Hayt7Xr5g2BajDo
	oRm8tXYSxQEue6kIATZ2xgNuXu5R1RzTx1NF6Wm2AW2/yhoErPm+b2RrUZgW0qI74G5nr4tGy5Q
	mgB5XpK5LlE6v2WMGwqIEDVgilUkV1yvHw6BehDmLe8pUGaP2DPcIj8KLsqFkHvHNEUahT1s145
	j2wrOplwIXupOafIIn1PhtairZcmqFeXcqhQ1hPnZjPGLuL1kZIcPaFeDMtBjRsHp0u/YiWtofK
	7jQFoLHls4ztfKhLTnrVlwEiY5an9izOEEXDUoZlUg1O551CMZeZIXfvLxqnoOK7baqgKG0Lh99
	NeNK0i7/zcF03Q0FTrPp2k3/VIvC3NHkRZ
X-Google-Smtp-Source: AGHT+IEsmw8mc9FR+7YcDO3uHr7qQk2IFaFGO9lGAZi9GzeSVQNoy7S8eVMSnXBGPw6W32MtA4kZ+g==
X-Received: by 2002:a17:907:2684:b0:aff:13f5:1f0 with SMTP id a640c23a62f3a-b01d8a26e65mr628763966b.7.1756718369507;
        Mon, 01 Sep 2025 02:19:29 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:29 -0700 (PDT)
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
Subject: [PATCH v4 03/12] mm/mmzone: add const to pointer parameters for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:06 +0200
Message-ID: <20250901091916.3002082-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3125B140004
X-Stat-Signature: m8tq8j489ohcxqpkmgxcgoax8uhg5i9q
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756718370-175459
X-HE-Meta: U2FsdGVkX19a4QQBNb49SLH7AxCI1V/Px5jH4t0bEp6vZPPxc+35JUHibfkRZmk748ngZX51Xi3/XxuCJzymbP/qZwX1EoL5YH6i6MDICyrY44XwRQXHVAey/wA3GxeahMeb7mnJpIihEYZ8t4Oq56O53SVchresIdOJeoKADhpL9dtHWNAVqZjA9Vs+m4BIQi/SkxpzUjPNCbHJht93O1p07JDvJxZCrjauMmY+oSQp38DtDj6+e0QXoI9TMwQHeVe+5SlM3wYVa/nLSzJSzx2VMHmBtE4VOk/TYbpsKsCfxevYHfQsB4bWnqmYJyWH0H90qtxGUgY6IfrUygawGoRSWd4domjZicnGQYCmMhGQTzYsk+N3kG3XDyufaDhArEjogny9Ydo5LA/7HrAMxJ1YvK+a3xXfMh1WLTTXCYfRF6d2wRwofMdNQAhibhbODsrse0E/9RLAwr8IPK/zlaW/dgHnNXRC/v8oFx23mXDKlBISzJJjCH3iFiqL8O25Sj6MBMOcDgmCuya/iK1QwIITWWLwgexwVLnXREBRjXDWz+TuqL0pez71Y0pS2MaDgmZR7YaicjV5SfIcxU6Ro6uv72lbxWuEy3JFOAa2cssc2pE6RaoYtrmsQNRyJT1q2dX10haZjlcGP9buAGp8FGCNu6BsaRaWuthkNbFC5GFrHjUrfYIUlNIzdCxUy89GUz/NUTiODEZvus1HZC4BBlTnRCtXHTgrN8m0+VNVXJZMJzu8fjuS+kLYl3u4gRK+DbeewkmeJReVyXGDBw9az+GQdWCCU8gEqq6uu1p6Vl9+Fd3NlAWoAxEZX5LP272cDRT7Dwd6m7l6Lnj6tKpZ41kZcS3kQAbOYvk9JvLXxGGSduxyKqttm4G6nCOMMsH3LcqrsTqTI65i08DSFoGWBr7y9ZxEueReAgw3vcKKYghtLe9EDbYoqGNLYakxIWivTgnZOGNFhBai4AkGKR9
 ZrAt3Nzh
 ndYLH3cyUcBk+CNa5/bAAwunWgc0QYzTriXx1pl5IjpHufFpozpJbYv4CgchxiM5fge+imndj3MKMgnUqEle72oLOBS8ab9sUlEZiOd44Es4IjvUQOdo1hVA5iInUlvYPACvzRv7dyBB8Hr5dxCEWRyUCI6Mib56J4eqZegJh393wlwwgU+dpzsgTlbmxl9MX6m4stiHOFWdtDydkZsm/IF7cf9L6LvJUMTsW5plznOtTtUp+l7gS0YRxgJiulvV6RaFge2UgVQ42FDFKO+BbW5lHLO5XZEn9DtWhrJLDMCN3ex9zYXp8KZEUUzSHYp3OtZuHCVzzd9tsW75J8tT0DyeCZSvB4NEMpD6t+5WaEJcgmZo49/o9TyZ1haWmAThiPEsuSuxrIK6AoNJrYAbBXzMa6XvSBUVaWoMmUv+jfzoMjArxaI6TfW7tE8VKf3Qf1a/Lmw4TxgLAspU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory management (mm) subsystem is a fundamental low-level component
of the Linux kernel. Establishing const-correctness at this foundational
level enables higher-level subsystems, such as filesystems and drivers,
to also adopt const-correctness in their interfaces. This patch lays
the groundwork for broader const-correctness throughout the kernel
by starting with the core mm subsystem.

This patch adds const qualifiers to zone, zoneref, and mem_section pointer
parameters in mmzone.h functions that do not modify the referenced memory,
improving type safety and enabling compiler optimizations.

Functions improved:
- zone_managed_pages()
- zone_is_initialized()
- zone_is_empty()
- zone_intersects()
- zone_is_zone_device()
- managed_zone()
- populated_zone()
- zone_to_nid()
- is_highmem()
- zonelist_zone_idx()
- zonelist_node_idx()
- present_section()
- valid_section()
- early_section()
- online_section()
- online_device_section()
- preinited_vmemmap_section()

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


