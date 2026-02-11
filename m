Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E8CECD6EE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 21:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A007A6B0088; Wed, 11 Feb 2026 16:54:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4606B0089; Wed, 11 Feb 2026 16:54:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8116B008A; Wed, 11 Feb 2026 16:54:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E61B6B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:54:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 159FF1603D4
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:54:58 +0000 (UTC)
X-FDA: 84433531476.25.A089213
Received: from mail-qv1-f68.google.com (mail-qv1-f68.google.com [209.85.219.68])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4D07E180010
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:54:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ol5iZyHW;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.68 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770846896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wY7FoCoT6W3h+FhLeVYQDgJWzgS3oWiQlGuojbJGq/I=;
	b=Nf6UG6uW3oyuYtAzVE9Hw4h1BD/V+3Jrir3pkrvOAXyK0WM5aGMuqIAoKWFpPfcQs4LUen
	DEeS6RiHfgTeaaPtX22SIr9U2nlov+ynXVXTorTm9/aQQKQka6HbCc+Ho8QFrRI5U1toFl
	8NYsfCsylcyLUQTOAHGFAvAHuLdsqFo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ol5iZyHW;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.68 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770846896; a=rsa-sha256;
	cv=none;
	b=VBHyOMAQi7iQfHi0HrjqxwoZEYzZcedlhc6krrLoi1yIf/5QldL0bcXOHl2mLS+if06U5I
	RYk7ASvFr8S151MA72kdMDksm9MhZ5bvNdCyG/PIp55DrMpWprder8iHusYG8+X+Tke1za
	GpOmiqv+fmSZaa6bZ90UpC+u2LNWVz0=
Received: by mail-qv1-f68.google.com with SMTP id 6a1803df08f44-8947404b367so79648816d6.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770846895; x=1771451695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wY7FoCoT6W3h+FhLeVYQDgJWzgS3oWiQlGuojbJGq/I=;
        b=ol5iZyHWbvtkKLDPoYBjVF3MOCfShJPahsvJQdlthk5YsMT9n4OkR/E8sA+fYc/PGU
         0g+WmwvVqbUgLcNfcrtnrklp9QltsB2aOsa5XG72FKzIU0fZ1ERJfiCsXueCyR0jlOj0
         OQZ1KETRC/cY/G5YdVy5fCvwoHyX/GKyYRMxidYYXbE2e02+DwtEvuLnq3T92Uz6DYoZ
         fr8KYv/ZREx3rQ+7tyH7wbglLF9L8RkoWBO60LysqOaZ/5ylYwA4/vLG493k0b9Z2eW4
         gp+4260IGaBmVIRhknT1M5wLUlGBwamI5AbarljZHH76lWpq/usSmBaOQbL8J/xZWG56
         jDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770846895; x=1771451695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wY7FoCoT6W3h+FhLeVYQDgJWzgS3oWiQlGuojbJGq/I=;
        b=aQd9ov2uHWRaJP8dMo5HMpQhQx45E/P8y+CDSfqaJCXoMVHjoBqoyoMH4zfMEBkALK
         V0ovt/0wzzIHY1/o+aKWuqrouJPVL8TZPfGnHBp5vODDl458gAFgwriJwrdpTkoSWyjx
         xhK7bnTHn1UhZ2wRaXE24fkAD6iAZTw5c4HaH4IttalB1rYDqvsR9ZRO4h0MFMAD5ECI
         5UG+eaQkQqwG7ni5hYbvLr/lImJQ3231UHW/xsJiEsKihfbaCgct9GR18E1ZRhyBbljS
         GTwVB3jkBpfuK9WJCMksZeT4NIxLJUPB+n4OwnmjEW8YYHbFj9RnncRXN71/fVNh9YY2
         LXdg==
X-Gm-Message-State: AOJu0Yxv3Ldk6u5L6liK8yt05hq/21in1KzJP6nGhJ9DGmrC9ZD1JTTO
	WYfFITMxQAoBnTR6PmBdxm+Y5EaeewMV585HjtYYry7kaxKL2mFr8PE79Ha/exx9CRu74Vu0Jbg
	sZoco
X-Gm-Gg: AZuq6aKyYF1XyI3w/sdzz3aZFTkBrye4rNrkloawpG3VzGN1TH49C4AyJeH70mXB8Rl
	btkAOKf0FnNthx9ZzVdg6ki01NpmMWmLqrZ5zhBV2JMLI22/HiOqU4Hjyj2iODOmBNfGMvtKuNT
	zc0mdAPB+sf0wExmdLCoSi0zJBcfE6w26KLmjR4nPpNIEotQQ8EnL/J6gUdetNDKx5UvGkkgQvN
	x8Fzjg52RwkFq3iu6K+LcvKc/9I/B1Bi5sSRYNh18ULCWOhdnhCjz98/mUDkMIwFYQm5jM8xJlO
	/uMrzqzGctRg2/YkSJVfIumDnEr3fPh8Ouzc9pj+NBB4ZR/30K2joDoi9iKgIk7B3KCvzA4RHyY
	8WLOyGhjjsjWhdAJMAxkcw721zECU9oYjraTwfBeRritzCCmP6m0uOAm/VMnMko1AD1rTAbakXv
	qJvhOXuUGqttCCdDWApLOfxUSNGWm5+i+6W1hGC93YNhvumyL3a1gMV7NcidVj3iXe2YPrQfmRg
	84w1jsib7t7VEE=
X-Received: by 2002:a05:6214:258a:b0:893:42f1:ebb with SMTP id 6a1803df08f44-897279b27a6mr15748206d6.24.1770846894943;
        Wed, 11 Feb 2026 13:54:54 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cdb5f26sm23742686d6.42.2026.02.11.13.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 13:54:54 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: [PATCH] mm: name the anonymous MMOP enum as enum mmop
Date: Wed, 11 Feb 2026 16:54:47 -0500
Message-ID: <20260211215447.2194189-1-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D07E180010
X-Stat-Signature: ocjekdymyezgdbfggtdderadh739t5gw
X-Rspam-User: 
X-HE-Tag: 1770846896-359998
X-HE-Meta: U2FsdGVkX182V6K62qtbmtENJaXBajI7Y0Ag1ksJ8PdLOe//JBTHO4mMkrgLLbb8km3p2QS6XTfdQXYfsRuo6oBHWY3YrunJ0j3WZdI9P5nbVv0+jPxA6aSVx2aK/tgM50+c7OgB6ARsLNvtwiXYBn42qsfxgFLrHrRARzfz4T8lZ+ZiirnSZ9uhdIwi0IzmLZK4d6FpNkyEnWxjzIbAijRxGSZgXmhe1tiYU2EOHFLsQsEFeXUWoLRQh5/TruaYOGK8fjW39eON3zSwWSup7ZvBFP9vyHjfLTsH6N82c9r97qI46ROXPm2JrgYrs1FFvZMrnywjX69tjfC0B7J/dXjl2j8cEXXEpLH2iWzRSXYAiSKyWugrFOOfMW/aafiV1wF7NmV4GvzxW/rnZArKxRJSoxvd29kwopNkrAgLrFfvvKeKJO/58XjvG3NeUUgZtf2d7GS80KjE2YXPSljgDYczp+WyM11OJ9y0YejRc2fntkAlqSu23VeP4/87Rugo9D2gp+V+6v0d1TUWRYfW+T6zy/Hs5+sK3z3G1WIuvfep2i9iZv4lJliUmHFQj/8X+nkTwoN5y1/FA8/t+VZaWJdz0rkSMzC7TAnsO3iJ+tz2vSVodNZ7Y90wunY60DBD5uSx0EdrxfFeoJ8E8ABv5pgB/o0V9/TkGMpvut4TiriEF5EzCbIGJvEHjxiWQfQNIyiJHZ4qYbupg0IYdAkUW6BVImAdvtFh2sSzwYOUGHxsRiVtxKLkjWTXSPpKuEnFsMcs5WqM0yQ6m0AYMNZnKzWyIESqrC/K2y5Dbx+uL8RowQa+asL/kaYDm+sB+Y9U5iz2BFs2DpHzAsDRUjZ+jEI0Joms3ANRQ0Xu8Rte+ExbuYXOgLkuIMUAZ27DxBhrYUkw648RIRE/oup7TmhDkcaxkugHgpMLQUD+s7KyfUlTtWGYnlfdVv1sVbzchdbQ9aC7BF8tdLyDwA7bIyu
 gOmNLYT6
 3RlBMDQSLSWPf205SMLB66sk8D8f1nm2Ock+TWIajb3PKkqV2rqAG59MXW6uGMbhTCzEN6RnBWaEQrNBVgXxNByrg2MB+5oP0QVfPJkqca2QJ7OHHulR6TMy3G2AQjCk1lheERZ8yIO1azZao5ajXenbvbFuKqgCNFRhtgiSyeds31h1uwehM1jOVZNir6x5K4gVbtt8Y6tgFOvM92ZV6rDhYo2A9JC+yWAV5pP/SZ2C5Q2ffG6Ab6JjDaMUnhpMozjy/2WLm44cFUVnNMCtp1hv2bs5LqWaLV7hxOgfHOo7U9LbYylS4P/xcA47oqlgQmksRuWbdRrP4Lx0FFDkbbtUG8+vPh3C6wwHh99am1r4URvggd3BpvI7SJr5rVC2CK6T9LwMBI0T5oFVYCDcDWgG+3UFUReBoopY4p8p/YzQVhGfpGlR9k+xS/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Give the MMOP enum (MMOP_OFFLINE, MMOP_ONLINE, etc) a proper type
name so the compiler can help catch invalid values being assigned to
variables of this type.

Leave the existing functions returning int alone to allow for
value-or-error pattern to remain unchanged without churn.

mmop_default_online_type is left as int because it uses the -1
sentinal value to signal it hasn't been initialized yet.

Keep the uint8_t buffer in offline_and_remove_memory() as-is for
space efficiency, with an explicit cast when we consume the value.

Move the enum definition before the CONFIG_MEMORY_HOTPLUG guard so
it is unconditionally available for struct memory_block in memory.h.

No functional change.

Link: https://lore.kernel.org/linux-mm/3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org/
Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Suggested-by: "David Hildenbrand (arm)" <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/memory.c          |  2 +-
 include/linux/memory.h         |  3 ++-
 include/linux/memory_hotplug.h | 16 ++++++++--------
 mm/memory_hotplug.c            | 10 +++++-----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 751f248ca4a8..3753ca80069d 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -452,7 +452,7 @@ static ssize_t phys_device_show(struct device *dev,
 static int print_allowed_zone(char *buf, int len, int nid,
 			      struct memory_group *group,
 			      unsigned long start_pfn, unsigned long nr_pages,
-			      int online_type, struct zone *default_zone)
+			      enum mmop online_type, struct zone *default_zone)
 {
 	struct zone *zone;
 
diff --git a/include/linux/memory.h b/include/linux/memory.h
index faeaa921e55b..5bb5599c6b2b 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -19,6 +19,7 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
+#include <linux/memory_hotplug.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -77,7 +78,7 @@ enum memory_block_state {
 struct memory_block {
 	unsigned long start_section_nr;
 	enum memory_block_state state;	/* serialized by the dev->lock */
-	int online_type;		/* for passing data to online routine */
+	enum mmop online_type;	/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
 	 * The single zone of this memory block if all PFNs of this memory block
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f2f16cdd73ee..e77ef3d7ff73 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -16,11 +16,8 @@ struct resource;
 struct vmem_altmap;
 struct dev_pagemap;
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-struct page *pfn_to_online_page(unsigned long pfn);
-
 /* Types for control the zone type of onlined and offlined memory */
-enum {
+enum mmop {
 	/* Offline the memory. */
 	MMOP_OFFLINE = 0,
 	/* Online the memory. Zone depends, see default_zone_for_pfn(). */
@@ -31,6 +28,9 @@ enum {
 	MMOP_ONLINE_MOVABLE,
 };
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+struct page *pfn_to_online_page(unsigned long pfn);
+
 /* Flags for add_memory() and friends to specify memory hotplug details. */
 typedef int __bitwise mhp_t;
 
@@ -286,8 +286,8 @@ static inline void __remove_memory(u64 start, u64 size) {}
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /* Default online_type (MMOP_*) when new memory blocks are added. */
-extern int mhp_get_default_online_type(void);
-extern void mhp_set_default_online_type(int online_type);
+extern enum mmop mhp_get_default_online_type(void);
+extern void mhp_set_default_online_type(enum mmop online_type);
 extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
@@ -310,8 +310,8 @@ extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
 				  struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
-extern struct zone *zone_for_pfn_range(int online_type, int nid,
-		struct memory_group *group, unsigned long start_pfn,
+extern struct zone *zone_for_pfn_range(enum mmop online_type,
+		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..41f48f493b8e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -221,7 +221,7 @@ void put_online_mems(void)
 bool movable_node_enabled = false;
 
 static int mhp_default_online_type = -1;
-int mhp_get_default_online_type(void)
+enum mmop mhp_get_default_online_type(void)
 {
 	if (mhp_default_online_type >= 0)
 		return mhp_default_online_type;
@@ -240,7 +240,7 @@ int mhp_get_default_online_type(void)
 	return mhp_default_online_type;
 }
 
-void mhp_set_default_online_type(int online_type)
+void mhp_set_default_online_type(enum mmop online_type)
 {
 	mhp_default_online_type = online_type;
 }
@@ -1046,7 +1046,7 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
 	return movable_node_enabled ? movable_zone : kernel_zone;
 }
 
-struct zone *zone_for_pfn_range(int online_type, int nid,
+struct zone *zone_for_pfn_range(enum mmop online_type, int nid,
 		struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
@@ -2305,7 +2305,7 @@ EXPORT_SYMBOL_GPL(remove_memory);
 
 static int try_offline_memory_block(struct memory_block *mem, void *arg)
 {
-	uint8_t online_type = MMOP_ONLINE_KERNEL;
+	enum mmop online_type = MMOP_ONLINE_KERNEL;
 	uint8_t **online_types = arg;
 	struct page *page;
 	int rc;
@@ -2338,7 +2338,7 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
 	int rc;
 
 	if (**online_types != MMOP_OFFLINE) {
-		mem->online_type = **online_types;
+		mem->online_type = (enum mmop)**online_types;
 		rc = device_online(&mem->dev);
 		if (rc < 0)
 			pr_warn("%s: Failed to re-online memory: %d",
-- 
2.47.3


