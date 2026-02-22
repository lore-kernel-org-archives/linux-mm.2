Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E2CFC624D7
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA116B00A8; Sun, 22 Feb 2026 03:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E706B00AA; Sun, 22 Feb 2026 03:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934F46B00AB; Sun, 22 Feb 2026 03:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 769A96B00A8
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39FD01A05DD
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:43 +0000 (UTC)
X-FDA: 84471469446.29.10845AE
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 63B6A140005
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hW+XpmDb;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWN/8SdZp4eQ7RQYloaf744UbOif/6lpP5ud9yJH5rA=;
	b=hTZHaJWVh7L3SxnXV6f5eXBBQchkJ+KHKAbdukzYDf30Q39mDVsKIyJxcsTCYkHrkxOKmz
	pd9zKd5Y5U/FAkKAMV2N5mxyX4xSHiVoOYzUkjsfEpH7sbGhORzQw+Il6YBNgMFIXKJrop
	IkBgXIlhnTURuOw/KYTzAtf72Z14kAU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hW+XpmDb;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750181; a=rsa-sha256;
	cv=none;
	b=fOxbwfIATMoGI3oT8NPkuddk4Q8ZxFgUBSvceSMcegW+NAqfB6g4poZK62YoJ0lH+4yIrc
	tsua/vkHt/j7e8XAeuMgNezuNsNUH1K9SVITWanvp4RQiKRNaqfbGeYWQDKlLXqaxhaKDm
	5JzzF5PSNwuusdgGhlT9DXLgPRXqR/A=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-506aa68065eso29814461cf.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750180; x=1772354980; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dWN/8SdZp4eQ7RQYloaf744UbOif/6lpP5ud9yJH5rA=;
        b=hW+XpmDbq97nDjQy/KDQAHTx5RT58HvFpTpBM1xVplYUkaTGRlzVKvv6YBuYtmlmxX
         8dAAe7HyAtNLmmPTyeLYGK5/TbdEcItEobK7AzuUJAxSw+AV1Ta7LKc0TKznzV02CA9J
         BpT/tDkx5Dc/Us3ad+Zt46gB3o+cB8N+qpX2RVYky270Xn+RDZREy+vXnaHEO0vQXB8m
         MV2avDSIi7Kc7bT39WgMoR41H4BcBQzkjTZBRDmKWZ3Lk7+MBtTvbK05n6bqTpdid2W7
         n66sEpAymIUrtZaJkII1srPvj59sWckIcY5eVs2eDFNzUpMsahBvnJOIsmaZhSXFKZoP
         vKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750180; x=1772354980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dWN/8SdZp4eQ7RQYloaf744UbOif/6lpP5ud9yJH5rA=;
        b=LtSw/fmeiFnmw2//L9m8jcAJcESEAFF2t8hvyL+iFVjfBovlQNj2PtqWTbzh4oj+EZ
         D/QHeYMBnZbTaDTXh+4DNvrssInT7ZM035i1svm5KPJmLkq402lWJi8586nGuUsRLkWq
         9YUx+2KIVjGfMIL9E5HaMy4dV+eCgm0PzKBOLYnFmuZkvBlbJgthBpiqQrsHqpQuj1oR
         uwMgP/ZRlOe3OE60r5IyliN5/6ijXVkAXaZMKt0a3rWAuRwR7hS2hfMltbAS57p4Piu0
         yhmvgfKwW9/N3XPxoK7sI1f+19g+pIxkx4Waj8lXzQevc/D3VdhxSSR/Ul3jWud0/UZe
         rBrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWA1vYwc7QJOE9zHM5utnfGBku08CDqLLx+ikWJO8LHorgHmqgFzrIYZuSrENJCVz1ac9kardJo8g==@kvack.org
X-Gm-Message-State: AOJu0YyT8OloivUb1P1sMMek5AXYn64RsVVmb34OMkUnPKsSIJZaLfpp
	edgtB9VGIU+SmcEQb1gdaYS/HGZLpdm1AxKs3qXtqUsNN6CUVnAifjTO5r3lHvJ0gVs=
X-Gm-Gg: AZuq6aJ8dpv16VWTQjzQo4kCWI9uzcEmB3n4oZohaxQu0kay30jk2ferPJqTxHBaGNR
	AuHRpo/FfFgmhO7vmyLE2bDit8A7v/T+GhafqjWFwI2kj6cuiTSULWyflcIN3K2L40BqsJ/ZC9M
	JnBX1IBzyHWd/UU+RPh4M8Q1aIs3jrQhodRXb4vbksmpkDD4zYtWoJTRLSQzUmdMwbI6sYNdqSW
	EGUUXD5lAs3mjtpHKbkFp/gn3exfGedlrG8OK6FbA0SXJTnd4ZPnwHlUNgwGtuOgrFLlmdqStvk
	HZFRRjK6H6mI395hnfHmAImNnCQQ5icKmGWdLotQel6S8VkYMzmXBZRttTO/kANOKvvCLjc6bjV
	pqHHTuxozeSMwQiDataZ9tglt2yf/sXRSZ/ZHh9oICRHwRPw0bl+Mfg3J25cNHA6avyhdG6UQrS
	ECFk5lPR2HzqpPJHCmFvGoQWMzlfy3lPJ6rlmTxTa4y42iEhZFjZdsiGh7ZLlaKp7ZakmXjDVdc
	3eUZjoevAs8apM=
X-Received: by 2002:a05:622a:241:b0:506:9944:8cfa with SMTP id d75a77b69052e-5070bbe0e70mr69483451cf.17.1771750180365;
        Sun, 22 Feb 2026 00:49:40 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:39 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 12/27] mm/migrate: NP_OPS_MIGRATION - support private node user migration
Date: Sun, 22 Feb 2026 03:48:27 -0500
Message-ID: <20260222084842.1824063-13-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 63B6A140005
X-Stat-Signature: dh8yrnksyzmnpsb1zx5mb5sa9r4croxt
X-HE-Tag: 1771750181-951857
X-HE-Meta: U2FsdGVkX1/PX/bWh4hDJ31EnFzDGVcVjzOWpPIxe6D1Ex2SLVZvrmUmS4OHhO5MSs18n9wrx0j1qEnu554R/aKoEBzbeEzEj+OqYzOCMpaRFbRqSSOWr9sqk4mdx6CpW/R4K7SiEGqeeMqMaVl6cH1+g9DLU1o41D8FQKPGEvhBfUSXarmTY1st0ULoME4ekVcjOgt5Bl6bPELBPcHa1QXb4Ne/ouIpGl24yxGIQ/D9hVG6lAGauddthwlbPt1Cr3QPkgM9IjV0bR9T3GqnI9JvYSTELQBftoRPBB0ohbUce2CFieYY5DiHKJv9upnSk7/ovg+VKUeZHKvmjLgct6mZEuHqDtPp9pUPC2XC0uhVJUmLxNOVZdZ+7UzdMsEZzLcc3d+wtvYwH0WdbBI0iF+m7KJfZuuJx0aKTFCUoBuStO6Wj6KqjU+2aE+yLDEUFtF5wVYWcbZfSKgL4cYOkgRyamDMI8FnLPXJfTfALij99NF0fG6oT63T+Z23tf3kF0oLjOcLPOXdBKGjquPikYtIAgzpshJP2YnzokQdllIdzj7Mw5eupT9ciYOGDf7QI+DYEpSihYin1OBJOKyvpBH69cz9vPUVmPDRPk4gYITBSEIaIczgjOMMIO9O+9srU+y7PmRnxIuC8jO/KvKyVlW3mp7tuFrG9js/zjqLLdZxW9DQrWhsXn3vMkqVkkFHWXvzSiXHRHRuOr5Pg2abB64Ysp8X43I4i6OCcbdArSokfMHAI7OSUeSRR6gTTsAWNgZaxNfSnYy3mZKFxRxPHBH06EaO3ylqluCaqNkV6YGx//00JWnAss3gs7fyf9P7sZT0XFqQ2w5ejx60IwrfC6A3Cdj1ZwIA/+CkU0u9geUIU6xnXfxOESG8cK2rboGgVe6HjRAS/gC22aSrzS55Ou8j0xdt4OIYogfeahSRV0CvSMx8V6GAWvbkpbwIO9GdzaCke+/VttQX5SPVNzS
 XN0wkn0q
 bftpFoBKGEruKzLBSVE7mNOEe1O0lV75+BNcTWxzcfRF/6oqiVwheC+RKKCV/hJ5Bk3bF2nW+K4ZVuoVuPOQ30iG0HPxYEN7WnDjMofpRgzXj4QBv1SeoVYDCncWs3bUXCeUe71O5ZRI2YkcwF4r4wj2RlCQ73n8eogL2Lf95KjAmVri0u8wnPUbJGqgh1srEXw/nQHvs2att82aJp9u/TUNweJV7SWkSDl/LNtsnt1RGdwRdUcnmZynA7+y24/iF+D8A4iPQq13Ix6nxolWchFaonAS418boXWdqgQWOs7DN3bdj2KuYtw7YFQIgKRgylyWIZTCaUg8ykUKiAC19caJ553AsC+a44muokEM3SGvcq949qUDxEKE3QygM3cnLfhF8cTGEk4WNRVwBoa0+7U8PSBOmLua7E8zH71Y9eNBrS5NAr0xxHHTGhbb/wvv+xBLijAPla3+1WTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private node services may want to support user-driven migration
(migrate_pages syscall, mbind) to allow data movement between regular
and private nodes.

ZONE_DEVICE always rejects user migration, but private nodes should
be able to opt in.

Add NP_OPS_MIGRATION flag and folio_managed_user_migrate() wrapper that
dispatches migration requests.  Private nodes can either set the flag
and provide a custom migrate_to callback for driver-managed migration.

In migrate_to_node(), allows GFP_PRIVATE when the destination node
supports NP_OPS_MIGRATION, enabling migrate_pages syscall to target
private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/node.c          |   4 ++
 include/linux/migrate.h      |  10 +++
 include/linux/node_private.h | 122 +++++++++++++++++++++++++++++++++++
 mm/damon/paddr.c             |   3 +
 mm/internal.h                |  24 +++++++
 mm/mempolicy.c               |  10 +--
 mm/migrate.c                 |  49 ++++++++++----
 mm/rmap.c                    |   4 +-
 8 files changed, 206 insertions(+), 20 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 646dc48a23b5..e587f5781135 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -949,6 +949,10 @@ int node_private_set_ops(int nid, const struct node_private_ops *ops)
 	if (!node_possible(nid))
 		return -EINVAL;
 
+	if ((ops->flags & NP_OPS_MIGRATION) &&
+	    (!ops->migrate_to || !ops->folio_migrate))
+		return -EINVAL;
+
 	mutex_lock(&node_private_lock);
 	np = rcu_dereference_protected(NODE_DATA(nid)->node_private,
 				       lockdep_is_held(&node_private_lock));
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 26ca00c325d9..7b2da3875ff2 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -71,6 +71,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int extra_count);
 int set_movable_ops(const struct movable_operations *ops, enum pagetype type);
+int migrate_folios_to_node(struct list_head *folios, int nid,
+				    enum migrate_mode mode,
+				    enum migrate_reason reason);
 
 #else
 
@@ -96,6 +99,13 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
 {
 	return -ENOSYS;
 }
+static inline int migrate_folios_to_node(struct list_head *folios,
+						  int nid,
+						  enum migrate_mode mode,
+						  enum migrate_reason reason)
+{
+	return -ENOSYS;
+}
 
 #endif /* CONFIG_MIGRATION */
 
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index f9dd2d25c8a5..0c5be1ee6e60 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -4,6 +4,7 @@
 
 #include <linux/completion.h>
 #include <linux/memremap.h>
+#include <linux/migrate_mode.h>
 #include <linux/mm.h>
 #include <linux/nodemask.h>
 #include <linux/rcupdate.h>
@@ -52,15 +53,40 @@ struct vm_fault;
  *     or NULL when called for the final (original) folio after all sub-folios
  *     have been split off.
  *
+ * @migrate_to: Migrate folios TO this node.
+ *	[refcounted callback]
+ *	Returns: 0 on full success, >0 = number of folios that failed to
+ *		 migrate, <0 = error.  Matches migrate_pages() semantics.
+ *		 @nr_succeeded is set to the number of successfully migrated
+ *		 folios (may be NULL if caller doesn't need it).
+ *
+ * @folio_migrate: Post-migration notification that a folio on this private node
+ *    changed physical location (on the same node or a different node).
+ *    [folio-referenced callback]
+ *     Called from migrate_folio_move() after data has been copied but before
+ *     migration entries are replaced with real PTEs.  Both @src and @dst are
+ *     locked.  Faults block in migration_entry_wait() until
+ *     remove_migration_ptes() runs, so the service can safely update
+ *     PFN-based metadata (compression tables, device page tables, DMA
+ *     mappings, etc.) before any access through the page tables.
+ *
  * @flags: Operation exclusion flags (NP_OPS_* constants).
  *
  */
 struct node_private_ops {
 	bool (*free_folio)(struct folio *folio);
 	void (*folio_split)(struct folio *folio, struct folio *new_folio);
+	int (*migrate_to)(struct list_head *folios, int nid,
+				  enum migrate_mode mode,
+				  enum migrate_reason reason,
+				  unsigned int *nr_succeeded);
+	void (*folio_migrate)(struct folio *src, struct folio *dst);
 	unsigned long flags;
 };
 
+/* Allow user/kernel migration; requires migrate_to and folio_migrate */
+#define NP_OPS_MIGRATION		BIT(0)
+
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
  *
@@ -177,6 +203,81 @@ static inline void folio_managed_split_cb(struct folio *original_folio,
 		node_private_split_cb(original_folio, new_folio);
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+static inline int folio_managed_allows_user_migrate(struct folio *folio)
+{
+	if (folio_is_zone_device(folio))
+		return -ENOENT;
+	return node_private_has_flag(folio_nid(folio), NP_OPS_MIGRATION) ?
+	       folio_nid(folio) : -ENOENT;
+}
+
+/**
+ * folio_managed_allows_migrate - Check if a managed folio supports migration
+ * @folio: The folio to check
+ *
+ * Returns true if the folio can be migrated.  For zone_device folios, only
+ * device_private and device_coherent support migration.  For private node
+ * folios, migration requires NP_OPS_MIGRATION.  Normal folios always
+ * return true.
+ */
+static inline bool folio_managed_allows_migrate(struct folio *folio)
+{
+	if (folio_is_zone_device(folio))
+		return folio_is_device_private(folio) ||
+		       folio_is_device_coherent(folio);
+	if (folio_is_private_node(folio))
+		return folio_private_flags(folio, NP_OPS_MIGRATION);
+	return true;
+}
+
+/**
+ * node_private_migrate_to - Attempt service-specific migration to a private node
+ * @folios: list of folios to migrate (may sleep)
+ * @nid: target node
+ * @mode: migration mode (MIGRATE_ASYNC, MIGRATE_SYNC, etc.)
+ * @reason: migration reason (MR_DEMOTION, MR_SYSCALL, etc.)
+ * @nr_succeeded: optional output for number of successfully migrated folios
+ *
+ * If @nid is an N_MEMORY_PRIVATE node with a migrate_to callback,
+ * invokes the callback and returns the result with migrate_pages()
+ * semantics (0 = full success, >0 = failure count, <0 = error).
+ * Returns -ENODEV if the node is not private or the service is being
+ * torn down.
+ *
+ * The source folios are on other nodes, so they do not pin the target
+ * node's node_private.  A temporary refcount is taken under rcu_read_lock
+ * to keep node_private (and the service module) alive across the callback.
+ */
+static inline int node_private_migrate_to(struct list_head *folios, int nid,
+					  enum migrate_mode mode,
+					  enum migrate_reason reason,
+					  unsigned int *nr_succeeded)
+{
+	int (*fn)(struct list_head *, int, enum migrate_mode,
+		  enum migrate_reason, unsigned int *);
+	struct node_private *np;
+	int ret;
+
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	if (!np || !np->ops || !np->ops->migrate_to ||
+	    !refcount_inc_not_zero(&np->refcount)) {
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+	fn = np->ops->migrate_to;
+	rcu_read_unlock();
+
+	ret = fn(folios, nid, mode, reason, nr_succeeded);
+
+	if (refcount_dec_and_test(&np->refcount))
+		complete(&np->released);
+
+	return ret;
+}
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -242,6 +343,27 @@ int node_private_clear_ops(int nid, const struct node_private_ops *ops);
 
 #else /* !CONFIG_NUMA || !CONFIG_MEMORY_HOTPLUG */
 
+static inline int folio_managed_allows_user_migrate(struct folio *folio)
+{
+	return -ENOENT;
+}
+
+static inline bool folio_managed_allows_migrate(struct folio *folio)
+{
+	if (folio_is_zone_device(folio))
+		return folio_is_device_private(folio) ||
+		       folio_is_device_coherent(folio);
+	return true;
+}
+
+static inline int node_private_migrate_to(struct list_head *folios, int nid,
+					  enum migrate_mode mode,
+					  enum migrate_reason reason,
+					  unsigned int *nr_succeeded)
+{
+	return -ENODEV;
+}
+
 static inline int node_private_register(int nid, struct node_private *np)
 {
 	return -ENODEV;
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 07a8aead439e..532b8e2c62b0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -277,6 +277,9 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
+		if (!folio_managed_allows_migrate(folio))
+			goto put_folio;
+
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
 		list_add(&folio->lru, &folio_list);
diff --git a/mm/internal.h b/mm/internal.h
index 658da41cdb8e..6ab4679fe943 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1442,6 +1442,30 @@ static inline bool folio_managed_on_free(struct folio *folio)
 	return false;
 }
 
+/**
+ * folio_managed_migrate_notify - Notify service that a folio changed location
+ * @src: the old folio (about to be freed)
+ * @dst: the new folio (data already copied, migration entries still in place)
+ *
+ * Called from migrate_folio_move() after data has been copied but before
+ * remove_migration_ptes() installs real PTEs pointing to @dst.  While
+ * migration entries are in place, faults block in migration_entry_wait(),
+ * so the service can safely update PFN-based metadata before any access
+ * through the page tables.  Both @src and @dst are locked.
+ */
+static inline void folio_managed_migrate_notify(struct folio *src,
+						struct folio *dst)
+{
+	const struct node_private_ops *ops;
+
+	if (!folio_is_private_node(src))
+		return;
+
+	ops = folio_node_private_ops(src);
+	if (ops && ops->folio_migrate)
+		ops->folio_migrate(src, dst);
+}
+
 struct vm_struct *__get_vm_area_node(unsigned long size,
 				     unsigned long align, unsigned long shift,
 				     unsigned long vm_flags, unsigned long start,
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..2b0f9762d171 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -111,6 +111,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/printk.h>
 #include <linux/leafops.h>
+#include <linux/node_private.h>
 #include <linux/gcd.h>
 
 #include <asm/tlbflush.h>
@@ -1282,11 +1283,6 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
 	LIST_HEAD(pagelist);
 	long nr_failed;
 	long err = 0;
-	struct migration_target_control mtc = {
-		.nid = dest,
-		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
-		.reason = MR_SYSCALL,
-	};
 
 	nodes_clear(nmask);
 	node_set(source, nmask);
@@ -1311,8 +1307,8 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
 	mmap_read_unlock(mm);
 
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, alloc_migration_target, NULL,
-			(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
+		err = migrate_folios_to_node(&pagelist, dest, MIGRATE_SYNC,
+					     MR_SYSCALL);
 		if (err)
 			putback_movable_pages(&pagelist);
 	}
diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..a54d4af04df3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -43,6 +43,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
+#include <linux/node_private.h>
 
 #include <asm/tlbflush.h>
 
@@ -1387,6 +1388,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	if (old_page_state & PAGE_WAS_MLOCKED)
 		lru_add_drain();
 
+	folio_managed_migrate_notify(src, dst);
+
 	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
@@ -2165,6 +2168,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 
 	return rc_gather;
 }
+EXPORT_SYMBOL_GPL(migrate_pages);
 
 struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 {
@@ -2204,6 +2208,31 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 
 	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
 }
+EXPORT_SYMBOL_GPL(alloc_migration_target);
+
+static int __migrate_folios_to_node(struct list_head *folios, int nid,
+				    enum migrate_mode mode,
+				    enum migrate_reason reason)
+{
+	struct migration_target_control mtc = {
+		.nid = nid,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
+		.reason = reason,
+	};
+
+	return migrate_pages(folios, alloc_migration_target, NULL,
+			     (unsigned long)&mtc, mode, reason, NULL);
+}
+
+int migrate_folios_to_node(struct list_head *folios, int nid,
+			   enum migrate_mode mode,
+			   enum migrate_reason reason)
+{
+	if (node_state(nid, N_MEMORY_PRIVATE))
+		return node_private_migrate_to(folios, nid, mode,
+					       reason, NULL);
+	return __migrate_folios_to_node(folios, nid, mode, reason);
+}
 
 #ifdef CONFIG_NUMA
 
@@ -2221,14 +2250,8 @@ static int store_status(int __user *status, int start, int value, int nr)
 static int do_move_pages_to_node(struct list_head *pagelist, int node)
 {
 	int err;
-	struct migration_target_control mtc = {
-		.nid = node,
-		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
-		.reason = MR_SYSCALL,
-	};
 
-	err = migrate_pages(pagelist, alloc_migration_target, NULL,
-		(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
+	err = migrate_folios_to_node(pagelist, node, MIGRATE_SYNC, MR_SYSCALL);
 	if (err)
 		putback_movable_pages(pagelist);
 	return err;
@@ -2240,7 +2263,7 @@ static int __add_folio_for_migration(struct folio *folio, int node,
 	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 		return -EFAULT;
 
-	if (folio_is_zone_device(folio))
+	if (!folio_managed_allows_migrate(folio))
 		return -ENOENT;
 
 	if (folio_nid(folio) == node)
@@ -2364,7 +2387,8 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 		err = -ENODEV;
 		if (node < 0 || node >= MAX_NUMNODES)
 			goto out_flush;
-		if (!node_state(node, N_MEMORY))
+		if (!node_state(node, N_MEMORY) &&
+		    !node_state(node, N_MEMORY_PRIVATE))
 			goto out_flush;
 
 		err = -EACCES;
@@ -2449,8 +2473,8 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 		if (folio) {
 			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 				err = -EFAULT;
-			else if (folio_is_zone_device(folio))
-				err = -ENOENT;
+			else if (unlikely(folio_is_private_managed(folio)))
+				err = folio_managed_allows_user_migrate(folio);
 			else
 				err = folio_nid(folio);
 			folio_walk_end(&fw, vma);
@@ -2660,6 +2684,9 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	int nr_pages = folio_nr_pages(folio);
 	pg_data_t *pgdat = NODE_DATA(node);
 
+	if (!folio_managed_allows_migrate(folio))
+		return -ENOENT;
+
 	if (folio_is_file_lru(folio)) {
 		/*
 		 * Do not migrate file folios that are mapped in multiple
diff --git a/mm/rmap.c b/mm/rmap.c
index f955f02d570e..805f9ceb82f3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -72,6 +72,7 @@
 #include <linux/backing-dev.h>
 #include <linux/page_idle.h>
 #include <linux/memremap.h>
+#include <linux/node_private.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mm_inline.h>
 #include <linux/oom.h>
@@ -2616,8 +2617,7 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 					TTU_SYNC | TTU_BATCH_FLUSH)))
 		return;
 
-	if (folio_is_zone_device(folio) &&
-	    (!folio_is_device_private(folio) && !folio_is_device_coherent(folio)))
+	if (!folio_managed_allows_migrate(folio))
 		return;
 
 	/*
-- 
2.53.0


