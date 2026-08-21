Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51162C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4BE6B00A7; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4281A6B00AA; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D0E46B00A5; Fri, 21 Aug 2026 14:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F212B6B00A5
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E3D4160225
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:07 +0000 (UTC)
X-FDA: 85126186614.16.00DF53C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id D38F0140005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Twhts8AZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=222y2tNP5AAzgrcKEwSA0V5PiUFlYG+znMLqhuMeRAg=;
	b=wFq3xA7iHNvGqDNlb5KELaLTu1AqBA94FkY7vdOQAJYcMkcOncDFoFUXts1j7n3XtPk0OO
	j75Z51AhzPLuxbtv8bBK40mUVWBuql0BjamioyxGwgeHOch3pYH72Qi2gREd0b73ikGJM/
	vH13YmGJnDG0J1tzNylISRaocNvMV1Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Twhts8AZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338685;
	b=Yf6ldjoqDXrmBV4Igt6sowcqu3c42DOvnQ/X2TstkjI9UaZ/GNYUjWo46aYl3+yE6fj0HL
	TeAQcLr4xdkp5gyAPhdEszU0ZlN7yFee0hwe6P8Sm6xNStmpQVt95tBTYKiO4kdxrv+cMg
	ty8qwK/BoduJqAe8WcngqJXIyPbvfy8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=222y2tNP5AAzgrcKEwSA0V5PiUFlYG+znMLqhuMeRAg=;
	b=Twhts8AZYDHkvyy2JvQcGIm1XXMo14Pp8lWmQVSl+GRI5yfszbP+/G+3JYyb5DU8ngPeV9
	KBeWKgN6Lw/9R4uDW4XRVbZHxFosQOF0GAjofD6qODOoiURkAxgEawXblGjqgqaj5fDDFL
	UMMpXj+nA40AKc+JfgNkH+YeAFjU8Tw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-vz2UDsZOPHysIqoT_r8iXg-1; Fri, 21 Aug 2026 14:58:01 -0400
X-MC-Unique: vz2UDsZOPHysIqoT_r8iXg-1
X-Mimecast-MFC-AGG-ID: vz2UDsZOPHysIqoT_r8iXg_1787338681
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c0e702df8so17017351cf.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338681; x=1787943481;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=222y2tNP5AAzgrcKEwSA0V5PiUFlYG+znMLqhuMeRAg=;
        b=OsUYqJCQRwGxAVS4vVMiJl3KaQ9FSbkCZQmjiIPKo5RYNwh/nteBN4blUYEn+D5RRg
         9RCWrB3DV7umLTcc5HCgYS4qGrpjzb2igCWc6UIvELp0nvbQZtP0tj7qpcvOPd4Z4Sve
         7sq6RJ+wrKElTYPpuSzXq97GuH+EN4F2tLX4jKe351BCyA0giTnEL9bJFN85BO7vJNQH
         E4aiG2WW7EdzVgD47/X9J07fxqT/D3SR4/5UHRgzgcTpdvzJWHpWdXkaLnCXu1lnVZKE
         NIVzA9nfK4n4xqRfxG6cgCORgL8cFAalqICYKOPXDU1aiaxUqLbVLQI34OqNYkYL/JFR
         2Sdg==
X-Gm-Message-State: AFuF++lKFLliB8sVJwAqorg5OtM+QaPH8L9tZfbueZl1LJpid1nZgdbD
	M0/9JOQPANY32r5dK8YBve4vKk3CGXg/2sBTbTYTbqfV0BdyriQY8n3TljGEh99vh2w7Cz4M6fH
	7d1C1zQhJLqC8WOokuWLB+FHGgmu/l2qcrDSNPiKyMwLzV3zDRGEL
X-Gm-Gg: AR+sD10XvwPVQHqEILQBJBT5ZkeaD9RVMr/Zy5MeqQfkCVlkkYBHl2l9/btcm3arUhl
	XNQmHNGe0sV6gLDJRrv+kchaBlZByZEngx5TZV2xnc/R8nWF4yFGvl0kapvBmkKztLodHuBPKjV
	ytD8wyjsfH9o/ZwYca/2ccrDfKYmMMK4233ywnNTSRAFrVGDX8GvGBpxB2cZwIsxRSQyP3gHdd8
	Q2yr9h5I0pW9EgQFwFQf/lBwifbAPKuQDagv6iY0SPzYe4zHgZP4ZsGohyZaPOlojEga2LzTibI
	eHglcdcIVwsvYuYxLVohkGwQ/ktBn/c2QZsQxSeXCVLVjGG5kS4/iJn6VH3RKi72sitRKUZIXRp
	aCwVwBGah7EVTH94kttBPhk7h+l4DVzRURJDIUL4XQRZn
X-Received: by 2002:a05:622a:4d8d:b0:527:7813:a439 with SMTP id d75a77b69052e-52df5a09808mr94675951cf.27.1787338681251;
        Fri, 21 Aug 2026 11:58:01 -0700 (PDT)
X-Received: by 2002:a05:622a:4d8d:b0:527:7813:a439 with SMTP id d75a77b69052e-52df5a09808mr94675291cf.27.1787338680742;
        Fri, 21 Aug 2026 11:58:00 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2b5ccesm69150516d6.46.2026.08.21.11.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:57:57 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:56 -0400
Subject: [PATCH 04/11] memcg: add cma charge/uncharge functions for area
 counters
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-4-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QDXtThfIJsDUeqDW_UlmXhElr8-aI4bd6nAjDJJ56_8_1787338681
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tciykpc1hiyr6j4iun6z54sh4qecupyr
X-Rspamd-Queue-Id: D38F0140005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787338684-405080
X-HE-Meta: U2FsdGVkX1+h1gMr+nvRHiSf85Grha8Dh1z4bvxGSIh0zIarXuCBlEN8ITAAA/Ddi4S5BRya39N2qtBCY/x2yd1+gPPn+VAEcMVpMEpe7Qf6axoR/UN5anpzUzjRs7FfDlmWFGlKgLuQanzamKkqY02vwOUIj7JldImBWviMsZiS+TDEQT9FJ3WMdV5TfTUX+9jvVLmtIH0Gfza4EDHC40Ylyu1hvR9i8XwZXV5s5KdZ++VScrMeIaBbTTZqJJiFY7VOYTsJjpgg/hB81w2z4KAkmob06d/FttcFCTpCCr5BlXy+AKqY6ZeccgfzROIj6pzZg/6sTspnpWNeomn4mXrozWz9dzvRrbVg+TwL097xYqyb1T7DNpZRGRsLgXulKNY6zd0vjby0ljHWTeut1kGeh2Le/xY8UuyE0/mKONDXnYIZySdH0BBVl0OywBkQKONr0gk1jjyd7J718nhjRWID+HtEPJkQHQEgaH+9lRONMwXHoYIiOyy3UnIO9O9GUQVpXZAnMZ4gFlL1TS05ZdylBU7MusUHZgDgToHZWWwLdxDGQ+JXF/R9ftB9k3MFqQGy//gsgQWIxS+K9G3GSg/hrTWvOkNLu8SBWtVL7JBHG5tKsoWoDa004UlrJRnLFMV//T+9gat4UIpevRaFr7VZZH/9TULuPLKr1yEDy0Y8DU2mvdHYQlLy/ks8IqsNRca5zfX3OW/9j0/wdA89Ef6wyGs+BUH6LX85LzmmDKb1NKaKXho+cN7N/bM2pDISIMs186rjuyZrPHVK2YQ4fmz0ECUEbHr2akcFmImo2Uz8mJjLduabXroZvR7zB+kTtH0hX46DJ0mZpni8mqPi0qCblmhLFpaTRFzYAp7Kf4FTZzTIMDVJp7ouV6EaZulqmvS2gD/TE05xKBWnYC/72+K4FDk/wG7uU9dLxxv4Muuyoe6Caws1Jxc4CNms8WIqXJIlfCpLss8668srLzX
 GWiOfasb
 TtU8rR9FlBcr5oH2jAvGCLs06Lp95sc1j+GNdIDfUuNw8rXja2dGT/5JcjIGAX5Ajs0M8vVCQ2wjjIOV4w6F0PRq/YXPre/QpU2uJyMQErp7a9qxhW3R13LLdAl7Rt+RbwFKjofQsBYCxCDqombbRd+AutjYI00v3/dSt55zP/eYCuaA+afBdGy2WTPQEpzma1cDLOJf5k1NMJJKieRS16pJ/abRJpJoXibfvqIsdGLcJjhvlZpH/1aAzSawAW+mk6ixZpGqHARunl4ZTM5A6jBax4m3snClb76Bh/iiauQ4S5xGxegZE4/OZPJMaxPDrQ+TRwl5ecDDgwEa0fl63k4rdQZYRoWm6RyyhyvhTG7F14RrKcDozrmDl9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce mem_cgroup_charge_cma() and mem_cgroup_uncharge_cma() to
account CMA allocations under memcg when memory_cma_accounting is
enabled in cgroupfs.

memcg counters to account for allocation in each CMA area are kcalloc'd
in mem_cgroup_alloc() and added to the page-counter hierarchy in
mem_cgroup_css_alloc(). cma_area_count is used to size the array. It is
calculated during setup_arch(), before mem_cgroup_alloc() is called
(for the first time in cgroup_init()).

On cma_alloc(), pages are charged both to the cgroup's memory controller
(with try_charge_memcg()) and to the per area page counter for the CMA
region used.

CMA ranges can be either pages with a 0-order folio (cma_alloc_frozen,
!__GFP_COMP) or pages under a large folio (cma_alloc_frozen_compound,
__GFP_COMP). In the first case, mark each page's folio with the cgroup's
obj_cgroup. In the second case, only mark the large folio from the first
page.

On cma_release(), get the first page's folio and uncharge both counters
accordingly if it is a large folio or not.

A small cma_area_index() helper is introduced to succinctly get the
counter of a given CMA region in the memcg CMA area counters array.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 include/linux/memcontrol.h |  19 ++++++++
 mm/cma.h                   |   5 ++
 mm/memcontrol.c            | 116 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8170bb8066a2..801fbde94137 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -320,6 +320,10 @@ struct mem_cgroup {
 	spinlock_t event_list_lock;
 #endif /* CONFIG_MEMCG_V1 */
 
+#ifdef CONFIG_CMA
+	struct page_counter *cma_counters;
+#endif /* CONFIG_CMA */
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
@@ -662,6 +666,11 @@ int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
 
+int mem_cgroup_charge_cma(struct page *page, unsigned long count,
+			  struct cma *cma);
+void mem_cgroup_uncharge_cma(struct page *page, unsigned long count,
+			     struct cma *cma);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -1160,6 +1169,16 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+static inline int mem_cgroup_charge_cma(struct page *page, unsigned long count,
+					struct cma *cma)
+{
+	return 0;
+}
+static inline void mem_cgroup_uncharge_cma(struct page *page,
+					   unsigned long count, struct cma *cma)
+{
+}
+
 static inline void mem_cgroup_uncharge(struct folio *folio)
 {
 }
diff --git a/mm/cma.h b/mm/cma.h
index 0c9de38d6bff..52b7d4be5170 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -81,6 +81,11 @@ static inline unsigned long cma_bitmap_maxno(struct cma *cma,
 	return cmr->count >> cma->order_per_bit;
 }
 
+static inline int cma_area_index(const struct cma *cma)
+{
+	return cma - cma_areas;
+}
+
 #ifdef CONFIG_CMA_SYSFS
 void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages);
 void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..8eca00d30fc5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -68,6 +68,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include "cma.h"
 
 #include <linux/uaccess.h>
 
@@ -4062,6 +4063,9 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
 
+#ifdef CONFIG_CMA
+	kfree(memcg->cma_counters);
+#endif
 	for_each_node(node) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
 		if (!pn)
@@ -4144,6 +4148,15 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
 		memcg->cgwb_frn[i].done =
 			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+#endif
+#ifdef CONFIG_CMA
+	if (cma_area_count) {
+		memcg->cma_counters = kcalloc(cma_area_count,
+					      sizeof(struct page_counter),
+					      GFP_KERNEL);
+		if (!memcg->cma_counters)
+			goto fail;
+	}
 #endif
 	lru_gen_init_memcg(memcg);
 	return memcg;
@@ -4159,6 +4172,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	struct mem_cgroup *parent = mem_cgroup_from_css(parent_css);
 	struct mem_cgroup *memcg, *old_memcg;
 	bool memcg_on_dfl = cgroup_subsys_on_dfl(memory_cgrp_subsys);
+	unsigned int __maybe_unused i;
 
 	old_memcg = set_active_memcg(parent);
 	memcg = mem_cgroup_alloc(parent);
@@ -4171,6 +4185,12 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #ifdef CONFIG_ZSWAP
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 	WRITE_ONCE(memcg->zswap_writeback, true);
+#endif
+#ifdef CONFIG_CMA
+	for (i = 0; i < cma_area_count; ++i)
+		page_counter_init(&memcg->cma_counters[i],
+				  parent ? &parent->cma_counters[i] : NULL,
+				  false);
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
@@ -5213,6 +5233,102 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 	return ret;
 }
 
+#ifdef CONFIG_CMA
+static bool memcg_accounts_cma(void)
+{
+	return cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_CMA_ACCOUNTING;
+}
+
+int mem_cgroup_charge_cma(struct page *page, unsigned long count,
+			  struct cma *cma)
+{
+	struct page_counter *counter, *fail;
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *memcg;
+	unsigned int i;
+	int rc = 0;
+
+	if (mem_cgroup_disabled() || !memcg_accounts_cma())
+		return 0;
+
+	memcg = get_mem_cgroup_from_current();
+	if (!memcg)
+		return 0;
+
+	if (mem_cgroup_is_root(memcg))
+		goto cgroup_put;
+
+	rc = try_charge_memcg(memcg, GFP_KERNEL, count);
+	if (rc)
+		goto cgroup_put;
+
+	counter = &memcg->cma_counters[cma_area_index(cma)];
+	if (!page_counter_try_charge(counter, count, &fail)) {
+		refill_stock(memcg, count);
+		rc = -ENOMEM;
+		goto cgroup_put;
+	}
+
+	objcg = get_obj_cgroup_from_memcg(memcg);
+	if (folio_test_large(page_folio(page))) {
+		commit_charge(page_folio(page), objcg);
+	} else {
+		obj_cgroup_get_many(objcg, count - 1);
+		for (i = 0; i < count; i++)
+			commit_charge(page_folio(page + i), objcg);
+	}
+
+cgroup_put:
+	mem_cgroup_put(memcg);
+	return rc;
+}
+
+void mem_cgroup_uncharge_cma(struct page *page, unsigned long count,
+			     struct cma *cma)
+{
+	struct page_counter *counter;
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *memcg;
+	struct folio *folio;
+	unsigned int i;
+
+	if (mem_cgroup_disabled() || !memcg_accounts_cma())
+		return;
+
+	/*
+	 * Get the objcg from the first page.
+	 * page_objcg() expects MEMCG_DATA_KMEM, but for CMA we used
+	 * commit_charge() which sets folio->memcg_data = objcg
+	 * without flags, so we cannot use it.
+	 */
+	objcg = folio_objcg(page_folio(page));
+	if (!objcg)
+		return;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+
+	counter = &memcg->cma_counters[cma_area_index(cma)];
+	page_counter_uncharge(counter, count);
+
+	memcg_uncharge(memcg, count);
+
+	rcu_read_unlock();
+
+	folio = page_folio(page);
+	if (folio_test_large(folio)) {
+		folio->memcg_data = 0;
+		obj_cgroup_put(objcg);
+	} else {
+		for (i = 0; i < count; ++i) {
+			folio = page_folio(page + i);
+			folio->memcg_data = 0;
+			obj_cgroup_put(objcg);
+		}
+	}
+}
+#endif /* CONFIG_CMA */
+
 struct uncharge_gather {
 	struct obj_cgroup *objcg;
 	unsigned long nr_memory;

-- 
2.53.0


