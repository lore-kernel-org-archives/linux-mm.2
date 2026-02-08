Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1675EF06EE
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC976B00A0; Sun,  8 Feb 2026 16:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF326B00A1; Sun,  8 Feb 2026 16:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFBA6B00A2; Sun,  8 Feb 2026 16:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0851F6B00A0
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5926BA57B
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:06 +0000 (UTC)
X-FDA: 84422655492.25.CD499BD
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id E2742C0007
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=amYr6FfB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587944; a=rsa-sha256;
	cv=none;
	b=7W4DvETMqps1kZSC3+HQuH/aq91DzXj9PXcvi+B+FeyxBA4MsBk8H6zDuZMpNRQuy7mcM9
	1ihBdmydSfxHy1ETlmfU14fRuai/gVc0LN5BLSq+n1v1hOCrkwW7hvuQLvxeOxLWT786Ou
	PbfE/Myzu0MV1XI3pYomsdM3YhDlwNo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=amYr6FfB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwTpwkTCuWwHn2fL97emlDEhO4U5O+3cG0JKQCZZBaY=;
	b=XvynU1NnYOd7+KaVr3XYMcXWZPJRMgaWT8h22PK8Qsyf8ftgmkFQS13mouJ6SN+oP1mRla
	+FEyfMg6iMdazFzCxy3UusLMXLBcTQwfhZzTiw9/hlBXm0/GugPzjnWI0BwLnj6M3+XrQV
	31Ix/6iCTZUEqO9bw6H83IVifwfRg3w=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d45d37c7a0so1532789a34.3
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587944; x=1771192744; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwTpwkTCuWwHn2fL97emlDEhO4U5O+3cG0JKQCZZBaY=;
        b=amYr6FfBgvanKKXexhImdF91/FOzHakK19+3Q4Rld9Cmu6QJN0fThjdyINnRYhaYi1
         RCIMUJqa3p6At/69NPEhViiWIrVCKN+dduOgVh/8YlQhirxGTTT7XngojgnxXSKtGChh
         xBTPZJ7Tk6I3I7z7zrxpg80pfy8p80H6lwu+y3sBaTEC0s2EHQhOvzBMdIea2XpFb/b7
         6HH6L8ZuoFDVA+negMJu19fBheQllJ+w9EJdaYu0upQpOy1P6IfXvEu8qa62XQdilvyM
         BtPx2a/JBgpwLp2id7hFGGUCcpTR0ZNM1hPgJb61F6L3X9otheOo1s5wJmWwZQ0rugq/
         xW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587944; x=1771192744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vwTpwkTCuWwHn2fL97emlDEhO4U5O+3cG0JKQCZZBaY=;
        b=Fx1l8wfk4Eq+bxoF0GJhmAhX0d9gDcvKopjHQ34j+ePVSa3Loi+Kz+K9EDthadS/4X
         E+MxSJQreQgfTXNcPYZXN+x+hNHE+1AM+5naKM+EQ2ALP+KZ8diIzxkUdQqU4O+fooly
         hwqombqj27+oxqik8x2/9CVIxUyPJfKGF9yz2MzqiVuZqjJJH5lWwcZAdPtZ8eVXimrP
         iXBbbdReiX4bqLYbOUVlqm6oNI4PsWdM8kb/2T5OA2pN0wHfCexWlL2+kRTlr07CYZ6E
         MidPOJH0MWvUu7qQ/oxtUk2DoxHopiytTzUEsgVkUzxDJaoiTKusozKQ5s8zgZQj2H+V
         kzdQ==
X-Gm-Message-State: AOJu0YwvTnV9UizDV3Il1yQ2tr4KxaSCkJUI1Vqx2tduHmKb8ASZmPDq
	iAlI9hgJ3X1F63/0bDPdyqj9ptTP32eXWCZQbizkawqnLlGmXBex9Nm9iO8tcFN/mXvMqA==
X-Gm-Gg: AZuq6aKGNQZ0d8QRb5W+FTv0tB5JpiexHMO6d1OZewkr5o+smDC0xxgtl/OfYTeyAHi
	JNxVvj4J6k4iqkI83rbybRPFdmhevoE0Rh+O2P9skJCYEyyvNSFKddJ1bxwYZTVm30kfqWZlE9J
	eGGx2D1v56VjS9rAqByb8MapB/emyhY4Q4wP9nuO7bjg74hMyxqvDbQqyELIzHkqfKvc5KcnOfW
	ILw3cilcoVPwv5B2J2x4Zjq1gd3h8JknXOD5Daj3fgKTtQ8hF05wfmDrMTuGDtodrruGaAxxrLp
	DqTSQRhpuok0IjLri/1HxDU5YZ2+fu5f/5uxQoubmLyTjxKaW5q0VnsYG5MNUkYIImkkCz9e584
	0EpRM0fO7OmOJ4GobUeFRulKjSgvJxTVJAzTOXuV0vXl113mxmnf4FGCLiu9kViXrMiWbHjaApp
	GO8XifkYAsyXCXKrISwzvtLh1c0J+WJ6CL2Q==
X-Received: by 2002:a05:6830:3784:b0:7c7:266:392d with SMTP id 46e09a7af769-7d46440c217mr4795266a34.13.1770587943960;
        Sun, 08 Feb 2026 13:59:03 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4647aa6cbsm6238339a34.26.2026.02.08.13.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:59:03 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 11/20] zswap: move zswap entry management to the virtual swap descriptor
Date: Sun,  8 Feb 2026 13:58:24 -0800
Message-ID: <20260208215839.87595-12-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E2742C0007
X-Stat-Signature: 8xz1o7617km6ygdhs7nzmt6yisncp8o4
X-HE-Tag: 1770587944-300416
X-HE-Meta: U2FsdGVkX1/79Pky6Y14hDYBOM3aYPglciFJIPDoeA55bmrLL5TsUBJTQg/RAbVmWwDm/vAgXQsvMEv7oslCKzEekTb01UETuc0al7nBkkI0l2ze5qBjGEWXetOHYB/LL6GmlQNFjlDrUlY+9LbNkCdyaW/AJjMdnUfBwWuMGUWh/lkozEJeAbHjmTPcrx2sZkmLvfU0r4klPghFTruJYXDSeO+mEqpSSFx3NmmjPJ/h55Wb4qsBjKfOw0e7POQtqR66yiQucAmvFaOXZAduw9xUDs0UaFujtHSj5kMjxwNHrnl7cvoQZsCkfHgxibdPY0oYe80vYadub+jFnCtXRBrh6rQh8k2ym7oZXmK5ZGojZ28AlDP6yEpLo5gQYfS+b8TIPIXi+O0YMGztOIM/QGBsf6/vXfMCbOuQ/itz/5E+NhLPmpw9J7sFwyhCndD+DrQYt4dC5HEeTKq9nPnfCDeiusuHOSC5lDfPxs9bk03RGe/s+YqLQP3+y72EqtmQw1THHpExszS9U7ZYt7rdRL7BYLGuYpgm+KKSkxeqRklLIA9gr7MWvMcc31+2nxlIkb5CO28NYzVHAsD2qqYLOeVMHavXvAuWPv7IlxTRWtycKun1ZT9lRrmGaAvZ1YANK31Qda4F5hesKzPaLXJ4UPHQZcjeYOHmAl48daJiro9JHUExWdvl0Dc6vFfC+cYAzcn/oOh1eL0j5Bsz5S2rJxxJIrIZckRWxRKyQQs2TH/ACifuU24RWc7aRI2D/g5hwI7CYAX655Hd2JYv4qivZiYLsYngLcTyM7AaEcFBR8+XGf68YuAf5so3HGljW/cbU17PJ8CmV+M9tUEpUzWVPV70JEAHTvTo6Fbw1OgwJ+3bQkCnPn5oxve5wubsEqNaQhgdwUnFU/97EXRctbnhkrYJY1QZB000T+tL0g+SDjTdeKIOO5rgiim9rWaDHHnVdE8do2IXhh/FBFvykh/
 FEhWuXwt
 lN/8SZegayZEOmoCwcXF+kc1CoVp0wm4xupSzO7o4ys8DIYRdVgzXV31La5CKKPl2HKOIux4sAd4umHW/icxCxiX18wtEXcDpeAI1S9Q0Ddxco22Ip810lEmYMb47Z51TkaTtG5iqQxQC2x72ysJ2dx2yCd0oRS/p0AFNl+UHRxmli3BMYs1hirVwUuQqsm6wP7twnbOGQEz2amvGSGh24//qX2bSn5O363XpauF60RyjZ+8CnpCHC4xG4bzYFmxGpS2EiUvVq7kU71rK0Fd0heMN/7J/nshdjHue7/aARlWcso/ycoo/uzfwauTndbast//bi0MIKHo/fpvNwcPmVnAXoKLyjz/s70ZcJ5AJfoc5uJgxri8d3z8Y9ar/pifyfU51SiCwjQXpiuL+CGx9qYtlhyasl9lpmeGt/a+Ug08ipYOkhpmJlY/0RuJeEkhDGPb5fJylEnrLIo63eWKVqYcnVjLiR9TXUURCnEz9M6G6bf/aNyQKXnjQFdWYVjZrF31RNrfk6aAfAmgelMBlFcXyPNwZ5FadAGVS/wv5KXcDMDrD0t5Y15dgLzuH0Q1faby+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the zswap tree and manage zswap entries directly
through the virtual swap descriptor. This re-partitions the zswap pool
(by virtual swap cluster), which eliminates zswap tree lock contention.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/zswap.h |   6 +++
 mm/vswap.c            | 100 ++++++++++++++++++++++++++++++++++++++++++
 mm/zswap.c            |  40 -----------------
 3 files changed, 106 insertions(+), 40 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 1a04caf283dc8..7eb3ce7e124fc 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -6,6 +6,7 @@
 #include <linux/mm_types.h>
 
 struct lruvec;
+struct zswap_entry;
 
 extern atomic_long_t zswap_stored_pages;
 
@@ -33,6 +34,11 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+void *zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry);
+void *zswap_entry_load(swp_entry_t swpentry);
+void *zswap_entry_erase(swp_entry_t swpentry);
+bool zswap_empty(swp_entry_t swpentry);
+
 #else
 
 struct zswap_lruvec_state {};
diff --git a/mm/vswap.c b/mm/vswap.c
index d44199dc059a3..9bb733f00fd21 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -10,6 +10,7 @@
 #include <linux/swapops.h>
 #include <linux/swap_cgroup.h>
 #include <linux/cpuhotplug.h>
+#include <linux/zswap.h>
 #include "swap.h"
 #include "swap_table.h"
 
@@ -37,11 +38,13 @@
  * Swap descriptor - metadata of a swapped out page.
  *
  * @slot: The handle to the physical swap slot backing this page.
+ * @zswap_entry: The zswap entry associated with this swap slot.
  * @swap_cache: The folio in swap cache.
  * @shadow: The shadow entry.
  */
 struct swp_desc {
 	swp_slot_t slot;
+	struct zswap_entry *zswap_entry;
 	union {
 		struct folio *swap_cache;
 		void *shadow;
@@ -238,6 +241,7 @@ static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start)
 	for (i = 0; i < nr; i++) {
 		desc = &cluster->descriptors[start + i];
 		desc->slot.val = 0;
+		desc->zswap_entry = NULL;
 	}
 	cluster->count += nr;
 }
@@ -1009,6 +1013,102 @@ void __swap_cache_replace_folio(struct folio *old, struct folio *new)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_ZSWAP
+/**
+ * zswap_entry_store - store a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ * @entry: the zswap entry to store
+ *
+ * Stores a zswap entry in the swap descriptor for the given swap entry.
+ * The cluster is locked during the store operation.
+ *
+ * Return: the old zswap entry if one existed, NULL otherwise
+ */
+void *zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *old;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	old = desc->zswap_entry;
+	desc->zswap_entry = entry;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return old;
+}
+
+/**
+ * zswap_entry_load - load a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ *
+ * Loads the zswap entry from the swap descriptor for the given swap entry.
+ *
+ * Return: the zswap entry if one exists, NULL otherwise
+ */
+void *zswap_entry_load(swp_entry_t swpentry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *zswap_entry;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	zswap_entry = desc->zswap_entry;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return zswap_entry;
+}
+
+/**
+ * zswap_entry_erase - erase a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ *
+ * Erases the zswap entry from the swap descriptor for the given swap entry.
+ * The cluster is locked during the erase operation.
+ *
+ * Return: the zswap entry that was erased, NULL if none existed
+ */
+void *zswap_entry_erase(swp_entry_t swpentry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *old;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	old = desc->zswap_entry;
+	desc->zswap_entry = NULL;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return old;
+}
+
+bool zswap_empty(swp_entry_t swpentry)
+{
+	return xa_empty(&vswap_cluster_map);
+}
+#endif /* CONFIG_ZSWAP */
+
 int vswap_init(void)
 {
 	int i;
diff --git a/mm/zswap.c b/mm/zswap.c
index f7313261673ff..72441131f094e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -223,37 +223,6 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-static DEFINE_XARRAY(zswap_tree);
-
-#define zswap_tree_index(entry)	(entry.val)
-
-static inline void *zswap_entry_store(swp_entry_t swpentry,
-		struct zswap_entry *entry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_store(&zswap_tree, offset, entry, GFP_KERNEL);
-}
-
-static inline void *zswap_entry_load(swp_entry_t swpentry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_load(&zswap_tree, offset);
-}
-
-static inline void *zswap_entry_erase(swp_entry_t swpentry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_erase(&zswap_tree, offset);
-}
-
-static inline bool zswap_empty(swp_entry_t swpentry)
-{
-	return xa_empty(&zswap_tree);
-}
-
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
@@ -1445,13 +1414,6 @@ static bool zswap_store_page(struct page *page,
 		goto compress_failed;
 
 	old = zswap_entry_store(page_swpentry, entry);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
-
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
-	}
 
 	/*
 	 * We may have had an existing entry that became stale when
@@ -1498,8 +1460,6 @@ static bool zswap_store_page(struct page *page,
 
 	return true;
 
-store_failed:
-	zs_free(pool->zs_pool, entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
 	return false;
-- 
2.47.3


