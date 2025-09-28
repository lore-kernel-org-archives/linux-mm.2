Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC8ACAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 11:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981998E0006; Sun, 28 Sep 2025 07:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959348E0001; Sun, 28 Sep 2025 07:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895D08E0006; Sun, 28 Sep 2025 07:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 784898E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 07:45:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C1F91A0968
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:45:25 +0000 (UTC)
X-FDA: 83938478610.28.27F0B41
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf14.hostedemail.com (Postfix) with ESMTP id 19508100002
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:45:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JIq1Lufp;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759059923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O81bmHO/De5uM7lSg4FU2b4XyEO6JopNzT32LkacqfA=;
	b=EBbFStZscsVmvPKzRYnMIqDxOgxg2kPKfIKhl42IXLvGqPWCHgMmfO6iDw+3N4jG6yD2h4
	WnWqjzZurtAAU685ansT85UaDvhiLGDo0ITm/ha7/h5k5cHSnhN+7Tm+qrnYv60ybH1oWH
	bEBFfOsxY8IY/QdiUe855XZIdwPPDZ8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JIq1Lufp;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759059923; a=rsa-sha256;
	cv=none;
	b=A8NuWt7H4Xp/OQzNNMdkCZZiRJgwrzhXtwMNCPhl9FhWgii4lfG77+py28wRAFn2YAg3o+
	eyyeAlgos2lA6fHiX3LdIY9Quw0TSdTTFQfh+LmMYmaYA4nznMQ0CAkWahyKU4c+OMCPWK
	WU6JCEYob4VTVdx7rWDXAyHfordfOA4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759059920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O81bmHO/De5uM7lSg4FU2b4XyEO6JopNzT32LkacqfA=;
	b=JIq1LufpQuE8ZgyxbB42qgdDzEoiLyWslWoFZWiXX1nBvJoYOI0iUJTYCWWWrcG9DM8Z1y
	SRk3pLH0BZTEabjcCsD8hKiuAdZbgQtS6dL7JSMtOHc4NHVtKe8iokFqA6bwqUDe7XQjB5
	S8G3ATFaBFe2Sj1eyaBxrpoVqKvG9ec=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 4/4] mm: thp: reparent the split queue during memcg offline
Date: Sun, 28 Sep 2025 19:45:08 +0800
Message-ID: <2ddd0c184829e65c5b3afa34e93599783e7af3d4.1759056506.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1759056506.git.zhengqi.arch@bytedance.com>
References: <cover.1759056506.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 19508100002
X-Stat-Signature: woiz75tch45x7ktzhiqj4n75bkapyfi3
X-HE-Tag: 1759059922-97862
X-HE-Meta: U2FsdGVkX19l4GiAQajRpf7m7YN3Hr8YRJkwWwweKiIpDTCFqbge7BjLOZPMYZ54459QR1CMSTLx8nc6+yRnUNRGa3db3hiOSgMGZfMDFLPR/S3XlpxBw+rYGZFP4zmAG6NZVgFxqOFNK8esMqHpNDVaaUKQruOddDI1CqtAYLC1qwEfWdj7vQ7QZxcuDXlJGmU5vypxpLqTCq2Ir1eu2uM656l+S1IRBtnxp3uOeBTkJkrjRx/uXBMUDtiTE8CilrXje/E/v2YdJiEmHwHK8irSndsVwr5d5hTBOzgHp9Mk87N+ITeyt7clHDexZsTDrkUThPMalxeRr3KHcprBKBAZgW1VF6pLw5D+HKk8Jc83+bOoL3Tyas3A5T7upblQQ/UgRCVUYX33sfFhXflyWHCaXs/a+3hf5XmRsh5mpCn1jWeBwsCzbeakTXv3R77sDOXZ4y/IV8Lq+XQzO2ni6uQ6SEuUqhdRgaKCrAF0brzPe1OH2E0ax8VI/KOm1EYGPz+cwsSNftpHqa9nyc+ZDG0i/4Vpkzp/U0aUSTYlW3WVW6Kt/BhkEqVug38fA556RVenIsxEJbdwpAO8LUtAFDV3xU+/d/1EmXAhakGx0IjX9Sdj+KBG01k+jBXT8D6yueFybDWYyc6nWmZl68r+9HFk6r5TR2OH8CQgzM9mQm2TSAx67kgdDImjvDO849znN04BY+r/rtFjLzs1vHF6ZWAK2saE7UAwEBM+UYfCvakhTgogrxjGTVcJzXg0U6mG+/Q+O63800P/MVs55GYSrcbZTfhe6wM1FS8s3+FrUdvRK62Ya7FCza7hBoTNR9LJDZuQRciRRaJKIpoCVOTFKpI/yPtpH/sRhbb2mpzG+YLsSQILVGie8AMt7whLgAvmv/a+8pfhZtbivjQAfaFEYaF4AaRleeLyR/NRabVmd156rXPFwNNjUP5WQJ2ZinW/sNiE3DBoKDFX3s7pkYd
 w8AtqM3b
 PjWwrxrI5f+oGWpqSCS459VipSwTZNiGsF7Q/VCNp0WrJlTIcHRwb/lPOC/CApPgT1iuMsLicHhEA4OO3hCBBudoy/Qcr2FGekAvbqP73c0blqOooVWSu/hFxaCbj7plRZL8dFze9xQEgSWxKogxRFHrNVawDEpt+NXsfmGZeGTHNrUWgYXh00Xhd9cJiQFrzmcJWoshSLgUSmWf3nMCt/FQnfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Similar to list_lru, the split queue is relatively independent and does
not need to be reparented along with objcg and LRU folios (holding
objcg lock and lru lock). So let's apply the same mechanism as list_lru
to reparent the split queue separately when memcg is offine.

This is also a preparation for reparenting LRU folios.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/huge_mm.h |  4 ++++
 mm/huge_memory.c        | 46 +++++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c         |  1 +
 3 files changed, 51 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f327d62fc9852..0c211dcbb0ec1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -417,6 +417,9 @@ static inline int split_huge_page(struct page *page)
 	return split_huge_page_to_list_to_order(page, NULL, ret);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg);
+#endif
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
@@ -611,6 +614,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bb32091e3133e..5fc0caca71de0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1094,9 +1094,22 @@ static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 	struct deferred_split *queue;
 
 	memcg = folio_memcg(folio);
+retry:
 	queue = memcg ? &memcg->deferred_split_queue :
 			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
 	spin_lock(&queue->split_queue_lock);
+	/*
+	 * Notice:
+	 * 1. The memcg could be NULL if cgroup_disable=memory is set.
+	 * 2. There is a period between setting CSS_DYING and reparenting
+	 *    deferred split queue, and during this period the THPs in the
+	 *    deferred split queue will be hidden from the shrinker side.
+	 */
+	if (unlikely(memcg && css_is_dying(&memcg->css))) {
+		spin_unlock(&queue->split_queue_lock);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -1108,9 +1121,15 @@ folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
 	struct deferred_split *queue;
 
 	memcg = folio_memcg(folio);
+retry:
 	queue = memcg ? &memcg->deferred_split_queue :
 			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+	if (unlikely(memcg && css_is_dying(&memcg->css))) {
+		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -4275,6 +4294,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	return split;
 }
 
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
+	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
+	int nid;
+
+	spin_lock_irq(&ds_queue->split_queue_lock);
+	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
+
+	if (!ds_queue->split_queue_len)
+		goto unlock;
+
+	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
+	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
+	ds_queue->split_queue_len = 0;
+
+	for_each_node(nid)
+		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
+
+unlock:
+	spin_unlock(&parent_ds_queue->split_queue_lock);
+	spin_unlock_irq(&ds_queue->split_queue_lock);
+}
+#endif
+
 #ifdef CONFIG_DEBUG_FS
 static void split_huge_pages_all(void)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e090f29eb03bd..d03da72e7585d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3887,6 +3887,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	zswap_memcg_offline_cleanup(memcg);
 
 	memcg_offline_kmem(memcg);
+	reparent_deferred_split_queue(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
-- 
2.20.1


