Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1846DCA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 03:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643DE8E00FB; Thu, 18 Sep 2025 23:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE418E0008; Thu, 18 Sep 2025 23:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494B28E00FB; Thu, 18 Sep 2025 23:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3143A8E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:49:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBA361A0517
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:49:55 +0000 (UTC)
X-FDA: 83904621150.28.FC44284
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 145E8A0004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:49:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PVx1OChJ;
	spf=pass (imf25.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758253794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pH+wF1kXarYaSv3rskQg/2hJ0DlvmAW+2Zdq+CMJuUY=;
	b=gtU+LKecyg931AaLqAiTYbDQgZWaxstz8ftRGpndw072h3HA2vYUtsRhmJrM/5BR0vHbmy
	kpYeCWH7YhJk794AB/jKk5vlEg1QUVfgJTCX2KHXIlqx1Amr7MF2PSDpv25XgbFQQVDF6D
	jt0sFejKasRZSf6EAqIRR45O6JmAaB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758253794; a=rsa-sha256;
	cv=none;
	b=Qvdyv8PR/Khs2KQinWsTDlS497SCfK75rLy2Sqb1wx3GR04sxDXnCYRLE8INn14X9cJToo
	73UZ5rOnWEPR9IDMIgTs+qYGCz9NznIGvyX5NvQOTn0oZrRGJXV0pdlltQBFbr1c9zCVEb
	GOW8qwLinV/vd3GAWGxg6A+FlwnURz0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PVx1OChJ;
	spf=pass (imf25.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b5524c0ed94so14505a12.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758253793; x=1758858593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pH+wF1kXarYaSv3rskQg/2hJ0DlvmAW+2Zdq+CMJuUY=;
        b=PVx1OChJqQrfaIMgg3BTUtcgCeQ8HRonGHC+ahOeiizM99dw1qdwC8PDT7f6Kj4ij8
         9yM8SmF7L0yHq5WalW8DOfq1u5n6rm6VVwTUmPDKUZJlYgv5N9Cjxj0p8JDX5QPL8kTb
         GYgnfkPHUwPFQa3+bIJm1mY5v5JnNwHBEOZnckshsuzI1tVJhGb8fDpCuwMabSg8OxQL
         9+Tc0z2Zj/VPVRJF5bhsxYCsKPV1gwU4uzVERuz8aEQSI+Oeorp00+l65LLjEZtJfya+
         F/AFFcZKZEBkpFtPjNe2/sWXjoGIOo0/hGxg7gH++b22e4PcsfFxSXlU0+aHTFcKIgoF
         v0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758253793; x=1758858593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pH+wF1kXarYaSv3rskQg/2hJ0DlvmAW+2Zdq+CMJuUY=;
        b=leRZR/+LdkvllGxSfZt55iBc7+zF0oWKYPW1BQZBpwhmT/wkZ1w4cIdw53UCzN41lh
         9zZhF/B5eBBX1JOol+82VrXiQm2mzGRxgTV7Q+cCjk+uJGrx/TN7hzWqL23UpNFmhq4f
         PIAcnde3NzQQDA9eqjNSH23kH8VHTXrysrMAFNZjIWlarFCo+7hM/Jy4Stu0ESD8dosl
         SUPeett+OIwc3zGA2pdSPPw5DalC7poBFQ+LGxEesLQAbEkbUeoL+3T+JHUXgAA+PlK3
         R+6sGDDduMDGOPRyge4Qhi49uQwHxZuvyTLV9vIufFiQ61xi/dGVJo3VCWpZiF0agLO1
         X5Tw==
X-Gm-Message-State: AOJu0YwEPGklyzYaUW3rbja86UuInyKcxt9Hekrh11zb48UIFzmag659
	Nhb0qNKvBM9GNm5OoT30RLZzV7kgS6Weml8uu33QUq+iUtk2Ktz33wfszNX+noIsE0k=
X-Gm-Gg: ASbGnctwJ4ZkAGwBNWFvDgZ/o3/gWJxsyD0JxNm3UMaR6I1OsdMmIe/jWpZbXO98wkF
	0gqxPtt96NK75k4bwDKx6OFnNofINdIOWbf4+aSMwOC3E3o62gu0p+ZrdBiKnz86zHPpnX6T/lZ
	qifxD17SKfda7dReb5KwckFOAJc3tfKscxfFNHnihc9Kc92wKXg7r5X8ukPnndwOVeVZ3m/ovgf
	CHbzJJEMMYbspDWns6yTChjawBkcFV6JQceE0CB1Qh+VUFwzdyytXe4RMQm49mxMleNmIkxSbS9
	qgnaARq+XTKqaa4vPAn/3cmwA4ZOFYDn/ZwrUb1Oco1YL0f2NcBXFw0vesJ1Fdudpv1pRpDkiGs
	IZ0UHDDQ89qYuWAhkEJ+Cj9wWr1meRkgQq6ODCKFH3s8INsg+cOiWbC1iGg4vD0h6gZWwC3g=
X-Google-Smtp-Source: AGHT+IE5FHZ53nVuEAm0EyvYyGaqEltHg/7s5hCn2sKWBeSzIX/++Bb6G05UYvRwpJYwFHv887Zr4Q==
X-Received: by 2002:a17:902:ccd2:b0:252:50ad:4e6f with SMTP id d9443c01a7336-269ba566603mr31897395ad.54.1758253792612;
        Thu, 18 Sep 2025 20:49:52 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802de5e9sm39629235ad.72.2025.09.18.20.49.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Sep 2025 20:49:52 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 2/4] mm: thp: introduce folio_split_queue_lock and its variants
Date: Fri, 19 Sep 2025 11:46:33 +0800
Message-ID: <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1758253018.git.zhengqi.arch@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 145E8A0004
X-Stat-Signature: m3ohcdie53cynwztu775fuakgfe4e8rs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758253793-474447
X-HE-Meta: U2FsdGVkX19SWfMUIrMmIznieoJyjLV5ljXMRzAA93EVt/BSb647DEpMbwOjOZtWZC9TySwgnkZYnbhWHDbWfcprBebxqJF84eYo4MrVoF5tuWs4tSDWvISpToufhkQrk5hiaA1W55VJ0o/7kMScIMuABgPUwqFxWTQwQy9gaDbIaBpiNj+LdpP5GkbJpTZBNearM2Sg9WkfANxcPqwI2L1kV5wx9Qsmf5yRugmV+acDko+R1oyC6Q3bS4deCEID778okPYcJxZloyTxze+Q4u85Pxyu4GiayQVeCEUaXDxW7M+Lb8eYH43Q02r1UwxcrD35a/F4L9R44r4HZvJO85G0WpGcbpdeMR+48iRq69QFshs7ZW1FEtTB9fQgKniNsJWy7Fy2GuL11hIzd0N6vIHHDykX6/WgS+gP5FqqYhFrfszClzEcbTM8b0qqkq5dk/ImnGij3b0apdgJg/hOeV3j8DM5aRAmVL5/6KmEpbz0tuPUtoZJVuqAWwHAN2TgLxf2q5MJQTozwWyU5NU2L3tuDiROetFIlKHoJHyHTlnpbogqTTOGUcRuMOGWPLMuJNudmCA2pQCMVOhtb5QdLMTvvYOUnozWh4tvSRvKlAjst7sFkbRXawQ81sy2+MiDf7XR2hbfByfvu8rMDICMlCL5uD7LR9yhGRYCm7f6EPOq9L5o2imDTpBHCRuqHFBVXlDHWEkSb1l6Dlu3CQSOfKsecuOHBCiV6hInme5WLdxXWL+wW1v3P1BolAtJsjJmnvi8+BOOmvYFFFGUEr1ak4R41mUkW/OHUFRFjBJiTAZT4/ylPeN45jJnGLQRNrZMhv5qXC1tIWqM1657FaKju8VW0LgRYYv5QE58ItJ7hEorEGiqnPP+/I9yKm5fE6gOpy2TmAN91hI/Nrx9fmWoJfqidNpvkhQ++8WzC55oO7IPcZAqkDZgQ2yIEb4CjOU10a4O5e1BrFFTMumS2a9
 pe7eNAGI
 cP67pasHG/FbEq91Kia81nF9CrV1qQCSFM6z95DTnrC9GQKq5bouWDNJEVooTz5ULT1/FsofUtjdMzH3q7qYraGMIuLXajqPeOCKqVaJv7hJHEf4WgfSr7nhN+O3C3SOPXrSOiLDUWzy8lB5VlZX8V+8h2GtynAFHSEAf8tcX0eq5rdHY2dWCout2XBS0KKcyDou3PJI5xPEpjQJzzrzoJn5CjvDbPESczCZyfhNoZNvtqbuid+6M9tdI/SuIfotiRr9PE2uKxP6/crrMe9KVBfmEIWh2yfHk812Sp8x/KoGEO9KV6LG4d8o4hrkpqOh7Bh71ndljCPCMHeHkQ4vZ86xcxCTJdSV+Ht9xj0S/Wd6giWQSuiBBmLEwkYVdNVVHAs6ogVyoSeZTvAw79uXDQRzqPLrGPDEYBIGglSlqGj6AjZ7N3nZDKccKG4GluXwPyOMg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In future memcg removal, the binding between a folio and a memcg may
change, making the split lock within the memcg unstable when held.

A new approach is required to reparent the split queue to its parent. This
patch starts introducing a unified way to acquire the split lock for
future work.

It's a code-only refactoring with no functional changes.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h | 10 +++++
 mm/huge_memory.c           | 89 ++++++++++++++++++++++++++------------
 2 files changed, 71 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 16fe0306e50ea..99876af13c315 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1662,6 +1662,11 @@ int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return shrinker->id;
+}
 #else
 #define mem_cgroup_sockets_enabled 0
 
@@ -1693,6 +1698,11 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 				    int nid, int shrinker_id)
 {
 }
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return -1;
+}
 #endif
 
 #ifdef CONFIG_MEMCG
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 582628ddf3f33..d34516a22f5bb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1078,26 +1078,62 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 
 #ifdef CONFIG_MEMCG
 static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
+struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+					   struct deferred_split *queue)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
-	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
-
-	if (memcg)
-		return &memcg->deferred_split_queue;
-	else
-		return &pgdat->deferred_split_queue;
+	if (mem_cgroup_disabled())
+		return NULL;
+	if (&NODE_DATA(folio_nid(folio))->deferred_split_queue == queue)
+		return NULL;
+	return container_of(queue, struct mem_cgroup, deferred_split_queue);
 }
 #else
 static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
+struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+					   struct deferred_split *queue)
 {
-	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
-
-	return &pgdat->deferred_split_queue;
+	return NULL;
 }
 #endif
 
+static struct deferred_split *folio_split_queue_lock(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	struct deferred_split *queue;
+
+	memcg = folio_memcg(folio);
+	queue = memcg ? &memcg->deferred_split_queue :
+			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
+	spin_lock(&queue->split_queue_lock);
+
+	return queue;
+}
+
+static struct deferred_split *
+folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
+{
+	struct mem_cgroup *memcg;
+	struct deferred_split *queue;
+
+	memcg = folio_memcg(folio);
+	queue = memcg ? &memcg->deferred_split_queue :
+			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
+	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+
+	return queue;
+}
+
+static inline void split_queue_unlock(struct deferred_split *queue)
+{
+	spin_unlock(&queue->split_queue_lock);
+}
+
+static inline void split_queue_unlock_irqrestore(struct deferred_split *queue,
+						 unsigned long flags)
+{
+	spin_unlock_irqrestore(&queue->split_queue_lock, flags);
+}
+
 static inline bool is_transparent_hugepage(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
@@ -3579,7 +3615,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, bool uniform_split)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
+	struct deferred_split *ds_queue;
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
@@ -3718,7 +3754,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	spin_lock(&ds_queue->split_queue_lock);
+	ds_queue = folio_split_queue_lock(folio);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
@@ -3740,7 +3776,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			 */
 			list_del_init(&folio->_deferred_list);
 		}
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
@@ -3835,7 +3871,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		ret = -EAGAIN;
 	}
 fail:
@@ -4016,8 +4052,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	WARN_ON_ONCE(folio_ref_count(folio));
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
-	ds_queue = get_deferred_split_queue(folio);
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
 		if (folio_test_partially_mapped(folio)) {
@@ -4028,7 +4063,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 		list_del_init(&folio->_deferred_list);
 		unqueued = true;
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 
 	return unqueued;	/* useful for debug warnings */
 }
@@ -4036,10 +4071,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
-#ifdef CONFIG_MEMCG
-	struct mem_cgroup *memcg = folio_memcg(folio);
-#endif
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 
 	/*
@@ -4062,7 +4094,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_test_swapcache(folio))
 		return;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
 			folio_set_partially_mapped(folio);
@@ -4077,15 +4109,16 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
 	if (list_empty(&folio->_deferred_list)) {
+		struct mem_cgroup *memcg;
+
+		memcg = folio_split_queue_memcg(folio, ds_queue);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
-#ifdef CONFIG_MEMCG
 		if (memcg)
 			set_shrinker_bit(memcg, folio_nid(folio),
-					 deferred_split_shrinker->id);
-#endif
+					 shrinker_id(deferred_split_shrinker));
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
-- 
2.20.1


