Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC29EC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B6A6B0093; Mon, 20 Jul 2026 05:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C731B6B0095; Mon, 20 Jul 2026 05:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1286B009D; Mon, 20 Jul 2026 05:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 873266B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFDE614073F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:01 +0000 (UTC)
X-FDA: 85008638442.07.E2A824A
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id A156040008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:31:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FhLanJGK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFSAOL0DZsiwYlqzPouS8XnC2DPIgfqzINxJ7kc1Vuo=;
	b=ienr10+9q13lSNuHIo5GcBnXkJzYpDXOf8ho7JWPSz8tHyVo3LNK74EFIuUGUKxfdH6Zzf
	ZfG5GPWzTECEvNG18IiD9RCWtsCrogmnFlxio7cVsJ6hbM4HY/92rupGKDZ7FoQWmm7JR7
	0o3hFr0HQJ7G9Y/x1/+eviqeaY2BIw4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FhLanJGK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539920;
	b=YAXHUyFO+nyNyjwi5Hy/mzvvOLmEIbWGVwC25adUDPkGKJsYaIdRq4CIn1ywNFf0Voikmd
	NAejnG2ds2DxMTIXR+N9xhpgT/D5qJsEGIBFjDL/sWeXg7yLjh99byBMd0KAeIPjZKAVX8
	Vg4xbV0Zz55NyVDNJa6XcRzqYUUnIH4=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cacf197759so107867325ad.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539918; x=1785144718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZFSAOL0DZsiwYlqzPouS8XnC2DPIgfqzINxJ7kc1Vuo=;
        b=FhLanJGKcr9x72c4joYzNllXj/AI8f1soChnYc+r5NuPfAkkuUVkhM3kFOXyncPHNW
         AAZfw6q4X1HFmumPMICxGbDJ3XS7vEwUclUhNzZEHNxmtxzFR5G3Lf0w0C1LeJnwl/gf
         8L8fEQFU1bRTORATQ02jh3O4ZhP4xoZ7UgSfy7MCt2IysMpwJG+M7U7q8pOO1XTrSlqm
         G5BBNhndtsoblWEWDP1xGyiSzdzeqJF8ycbLE49NFbMEibhdsXRjnY84tEz7214x/tyl
         n+ymJBJd+SVk3W1ZO0tmZ379i0gnwFXTIa5rWa2GGyQH98B5E6a90FBeTpeePHLf/ami
         SSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539918; x=1785144718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZFSAOL0DZsiwYlqzPouS8XnC2DPIgfqzINxJ7kc1Vuo=;
        b=MC1HACqZLvao9sOQFPz88cS8WPGBORCcgFcxHHHxnVBTc+FxfD47v2k81ORdsjO2Db
         HyyRj7eD/woyKtRCg2Ys28jL1UrNN0jx4Y4ngkFb6sjVmToFudbyqe6LhT5Ek6XJ+xX4
         x1UxcrqhXIWKGqXMLllLjx39BflomZXjNV3gB6gmeCfrPfq62ulRfoq47FFS0jfxYZRR
         fHZN9IZiI0Jzu+Oq51XasxIpZvOJ5Exty0aoTI/k4/ulvuY1WIbkx6vKL1Ov7ynt3UJk
         EncEPKYWOxpjELt0BJehXOwIRix9W98htEtvMUT/W39eNonN9Hws+27QpRZ1YrEy3rK9
         VXRw==
X-Forwarded-Encrypted: i=1; AHgh+RpjZoA+dGw0syOtpl9e0dByQt4WIn7zq0h/IB/gSJ+Fo6DjQSbb5XzwMgRPm41Kgyi3+HMegaFajQ==@kvack.org
X-Gm-Message-State: AOJu0YwOymoIodctTZ8RSLT/wtrayo3fKexJw2YEJagugPbDXa00MdO1
	zUu1F3bWcPdwFQvVSUY92mxBlnGQL7+V5IUmtb/tY5Brg2TtXxBZS5/iAJyro1xbipE=
X-Gm-Gg: AfdE7ckyoq0ECdrbshSizOIuw27v4AFbFqeDBDHn3LWuh+y4TtLOlrRIdhv+fwWPnIU
	HDUi2vL+H5TwQskOiHKLy+HmjuMmwTEKzlCyd5hlafrDbKQZO0BdIm0poOYhSSdFhOvVk2VjN4h
	9ww2lv/Fc10745OZA6d8lakDctbBQ7HuW86AnYFvejJc7BNirS/s2oPldkP0iwELW9+DJ3Ii0hv
	y9Y7Y4OvnLWwmdUwgS/tRHGj88zOV7ZJPcNLB10p41aLxWTWrNb59Yfm+hpA7DofFz3VkPdriGG
	GTklzCq+SYXinOtzF/LiSGlnbGvotEZrfHDBBRrK+tFIAtYoAmoFNEke14gnw6xLp+yVY1cyLMj
	+B6AB0VpLPJY279Kr6q5RoMahdSNMDxjqe2Vy2A3K279uNMB6cpcpq52sbetGK+N7pw00PZA2PZ
	IT+otPH3W1cxBFmT+sGtyflCh0MuN0kRQYPw==
X-Received: by 2002:a17:902:e748:b0:2c1:98b7:ecf3 with SMTP id d9443c01a7336-2cf3494aebdmr144468675ad.23.1784539918154;
        Mon, 20 Jul 2026 02:31:58 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:31:57 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 02/17] mm/sparse-vmemmap: rename HVO order macros
Date: Mon, 20 Jul 2026 17:31:12 +0800
Message-ID: <20260720093127.540540-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A156040008
X-Stat-Signature: 5q4c5x3ew89k3yxtoqpyhoewyeoi9kj3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784539919-806203
X-HE-Meta: U2FsdGVkX1+YPK495JZK2RfBtPp/U2AZm0M3ERJtM0cWnsZrWCXRdV6IQJ4WxBT6LhRXKN/Fcy3rgf5e/BC1gJ818jcP/VSdvD87B1WAImmIu0/NmAD4lslIY9LDQo3JWFxnUo5UcppBdmkp3gYucEyG5lXRiUbRh1rb4W9kUh/DUurhnTv9n7+ZyBJ2C3G3yNOz7iknrHlMjsq52WZDVEDUi2XRvb+SF1f3c967i0Vc6vaVDW1c1uvT1SO3V/YqSFypTIUzi5aPeZUskH47kbWH34j0t/efGlTeX2u6s6oZFlRDvf3mmrsDZsF6pTwAr3+vFMp8SokIgKyv3uXVJPp72hakeq6iQlTfPjCj3yKdyD0fLydz+ls2SxiEM++FuGSBcdtYYoGt0CoY3Sh+MKcE7baI/TGcmMjPRkdE0S+P//42ZmHQ0Df+z21eOxHiYMQ7wXoTU/yvBrvpq2BdXnQwI8TZlm1FOPWfuPIMOvWeP+neWb42e7jic0YJCHswciUhuZkxU6VNrKEcCf71mWlXzJZ34ZtvnZOAfcBTWXUrSqdnOSV1FWc/ZwE4fKDrdWytZBQMK/SDnZay6+Q+gVPUf1O5jSWEM9dC1Dk3K5nSIVPcm783zMS+ccRDezvAJdd1QDb7Wi7cEXz+oJGpI0M5D649V387lWWexKqaNSbJdxkyRAjXUjC+niZtrLtACLG5bqNaHmhrSdjNyBJQjPuq0OPf+49X+vPwC9SczkSaZteKizd8Bj8bi4Z4ArJW0f+R51OCgjRsFlwhrvf69ZOM0AswUGg4ox3VNelsTNYDy4+ramntSaMjXLUeDzZvS5THD1dH2oZVcMxGLK9N87VrkZCcMBwlbdhv/uSAnuzK9F4+PoIvKeiDS/HMRAIH3u+sIafdZOfNCjC5YQ0gSP27tHOLIiVaS7VfQu1vYh75OO+udXpdq9dWCpBmuWBRvLGMl2pOzdZXhiwkDu0
 vFTSvail
 JtPkw6EpQ63FNaTrpNOHXrgzwYYVTz2J7HpM8VR8YfgJzjBNMRgXCogvcLd1GeQex2FNB4f2SMeLU6UfKW/63rZfdYcvQak18c/nJrs2st2Yu4Mdnqw1bSOR+NoQdSlT+LRTxmn2YlNAWO9FD31b5SLVHo+rlptBlMDgJyTLCu1SGY8XPeRt3otjdZ8A/mi6qT0ytau7XYnrNwx9ZswaYI3x9EXo69iLbNcsDyy7ItzPFGUbkgFZsB2luoxqzEwFloxwqT0dtnDMtvbZb5Rm5zsOf6Ab0Ma5PKGOmyL5HDPkle7Spyir/ZsqBVr1cilEC5xQglW3E7HOq7ZPsJ38kxzPdLZeKSJYhtG9Qkfl1vgE1qMivL0BoAFQaymzWqCId+/Gtyw9SueIkrek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The macros VMEMMAP_TAIL_MIN_ORDER and NR_VMEMMAP_TAILS describe the
order range where HVO can be applied, but their names tie that range to
the tail-page cache implementation.

Rename them with a VMEMMAP_OPTIMIZATION prefix and use the new names in
the HVO paths. This makes the code describe the optimization requirements
rather than the tail-page cache implementation detail.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Rename the macros with a VMEMMAP_OPTIMIZATION prefix (suggested by
  Mike Rapoport)
- Drop intermediate optimized-folio size macros (suggested by Mike
  Rapoport)
---
 include/linux/mmzone.h | 17 +++++++++--------
 mm/hugetlb.c           |  4 ++--
 mm/hugetlb_vmemmap.c   |  2 +-
 mm/sparse-vmemmap.c    |  4 ++--
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 04f3409edacb..82b0155d886f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -107,13 +107,14 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/*
- * vmemmap optimization (like HVO) is only possible for page orders that fill
- * two or more pages with struct pages.
- */
-#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
-#define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
-#define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
+/* The number of struct pages covered by the retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
+
+#define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
+	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
+#define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
+	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -1147,7 +1148,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[NR_VMEMMAP_TAILS];
+	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index db09f0ab6d97..b8e1569bda15 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3358,7 +3358,7 @@ void __init hugetlb_bootmem_struct_page_init(void)
 	struct zone *zone;
 
 	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
 			struct page *tail, *p;
 			unsigned int order;
 
@@ -3366,7 +3366,7 @@ void __init hugetlb_bootmem_struct_page_init(void)
 			if (!tail)
 				continue;
 
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			order = i + VMEMMAP_OPTIMIZATION_MIN_ORDER;
 			p = page_to_virt(tail);
 			/*
 			 * prep_and_add_bootmem_folios() can access pageblock
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 917db0984143..ae8fdaa42118 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -494,7 +494,7 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 
 static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
-	const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 	struct page *tail, *p;
 	int node = zone_to_nid(zone);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5a2469fb1838..aa6a4a2fae98 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -329,12 +329,12 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	unsigned int idx;
 	int node = zone_to_nid(zone);
 
-	if (WARN_ON_ONCE(order < VMEMMAP_TAIL_MIN_ORDER))
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
 		return NULL;
 	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
 		return NULL;
 
-	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-- 
2.54.0


