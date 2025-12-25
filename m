Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DC1E7AD41
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD10D6B0088; Thu, 25 Dec 2025 03:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F2C6B0098; Thu, 25 Dec 2025 03:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD20E6B0099; Thu, 25 Dec 2025 03:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE9656B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:23:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44E59160615
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:23:00 +0000 (UTC)
X-FDA: 84257302920.02.F90EF8F
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf04.hostedemail.com (Postfix) with ESMTP id D19BA40011
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XijCKMRX;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cEdrCycZoSGIaSMQtohlYU0qPrlLixmKafhXY+xcm0=;
	b=mPele73VBZbeXf6H97WzUolDbHTO7SjFsMhUyuLN/+Ht62OWjs1HDAbVcGRapT9NmLaQf6
	AxSVl8zoA7MFc0sZjVUvMmJB1khsqq9eVzt8LiFZnxt9lMOu6Fdr3hxR3VUynPOw2910sL
	y1vTuE7bysXYS1UsbthFklr//HywvBA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XijCKMRX;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650978; a=rsa-sha256;
	cv=none;
	b=fuvU0PQdRflit5SJRJ7g4f929OdiKCY9IrauzSEv/Op3W23NEv3h5yUKj/xuRT01S5Anw3
	OP+j/03AUTSP+ni4YidA80A/N00FekzIrugK8DD/Y3N7cb0bWEkmYhfgFUSGXeQkB98ewj
	/snrbn4LLMPjjVZ2avbjD/EDl6fwHTo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766650971; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=5cEdrCycZoSGIaSMQtohlYU0qPrlLixmKafhXY+xcm0=;
 b=XijCKMRXz0bUt2h22L9Vpe/2yPl0HCS7pucYTxXUo6SPNfg6diJIe5n61WwUS4awfvGlzC
 RQMyqJy3LYue9UM2Ru6f6YxJRNT/Dp1cKmghUiPx2btIGfUDmr5mfwRDgcBJKM0JwrkthL
 Hqz7/wkLo8+B/H3N9A2jvqInd/y4qht1b6Ml3f5Ellm0X5ct6LzhAlN5UNLz+YUuZPd2aS
 /LIJSWfDzi43wQc1h7BuY/NgvBYGa8kbStb0WglMtaTuzfaaslXy9F9omtPPh8Bd831OkP
 /nDj9LpsU7EQEk1bwbKOfSN2CQPswXjZeCURWYtCok+oOcO+safd35BCdojunw==
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH 7/8] mm/hugetlb: add epoll support for interface "zeroable_hugepages"
Date: Thu, 25 Dec 2025 16:20:58 +0800
Message-Id: <20251225082059.1632-8-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+2694cf459+0de43f+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
From: =?utf-8?q?=E6=9D=8E=E5=96=86?= <lizhe.67@bytedance.com>
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Original-From: lizhe.67@bytedance.com
X-Stat-Signature: dyoct8bkq17yuxgzupetsu61hnznizqa
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D19BA40011
X-HE-Tag: 1766650977-621145
X-HE-Meta: U2FsdGVkX19UtsWleBgffvrVmhk5jjCRrPDq5wdwiSJhG5T7wLOuiifT3vQmDzZIxqdeW/yvskQTnNas3rnhBGWDm/DsG5CMooFMY2nNoETAA8oqSpatbTQOUzL9v05AKRuxkkZteIM/nf36Fn9ltQWVT0kxoky2ZjCArwgsnpI0s4chn1wgu29QMZKtwWOZfBCJrMXuIiOzysLGj1aekEUacPGA1qGhrD5zOPCu3DHypjDMcCbmM0G3vDK3lLa7eRjg5NhqN47JyTZ1vUM5XbYXZifMr8yku8Vr34SnExwN8K/OUgHAJuw4XNILAm+NxYplMbykUsbsR6+bCfn/CKBnoEF+W+trU6q57qjsGsEZX2umCpxgRqJwI54OOXyG1vWc6yY3iUmRoeW00zt6sx8rj/8Qi66xnSATdCcewtVO2nPxbW/zff2qj0K/8RH7DPQ6WkPEWBZ7dyPmQE97G5Kr/JJz0F2DH8kQ3Mn2aJHxoKGbwQd/5VazvgD3WBr68Jic+mZ+RyIhKn7GX5XaFYf34rqsvP0L0SQmPVd6KoT2UdS6qoTKD79LSCIJxotke34XBXgfblkkbxzV1wBqo8KDOkvE6+o+KNsssi1XFBPMU1c9m+W14PO5kB/9nMTeTszSA52d1MYvT51T+3EtB++TsQLvoUgDx1FvqelorZRG2B4atNnWq/PLEme7kxiU6as/Xguu6kkNiiqAxYQ6O5H5F+rnXZIkNUqU8JDopAWF3VGozZo5VNB1ss6k1jh6q+ajtaBkadXpsQQLA3jMpSCQ0rLPt9ddYoacAudmIEXsZS2+txcIKfpTzyUHUoM4MOCVc8MxLRvxDUaC4p6jjuBhGsnIzJ82HV4UCUqeJA3JSamkA/YNYnKCk1/MxX25oxsIGwIxv9FZdDWeUh2j82+TAK9WqDLkBnN7IR0nf+lSl9WEAQgi6CSkOfmAScuUFjgKOc0GduOhcinYlte
 Y99n6kVH
 OazH/Dy/HFir3z8SZRNJXjlxMMRjTKevN+yTC7h4MAuKRXScUr7gh8JEZVtxl0Z+it/WU/tupNNtV4fCg/6AuMAwkCk2SCBZurqQE2NsLglYU5Wsh2unViE+pSb9e33Qe8PxQmrRhnF8R6C9HMgRu5C/XXhJRsXk93CIQR6j0a3sGHYpsr8sSDl9KCcUG1gOQ6XjzPyPyql/mucfnDWniWyv4JzqDPnVdP+GugVHZ2UdbkWvho7lEdfYezcYI0Oq90MxvhpiYYCBLj32SEicPhHpITJsx15DzOFrSzxFU5hcLt5AMmPVCuT+a3dXyklHmMrt4r66lIyZ4Qq6dRVkjxDtfswIjLHQFrEtjijjaZnXw7aI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

Add epoll support for interface "zeroable_hugepages". When no huge folios
are available for pre-zeroing, user space can block on the
zeroable_hugepages file with epoll, and it will be woken as soon as one
or more huge folios become eligible for pre-zeroing.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c          | 13 +++++++++++++
 mm/hugetlb_internal.h |  6 ++++++
 mm/hugetlb_sysfs.c    | 22 +++++++++++++++++++++-
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8d36487659f8..c2df0317fe15 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1868,6 +1868,7 @@ void free_huge_folio(struct folio *folio)
 		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
+		do_zero_free_notify(h, folio_nid(folio));
 	}
 }
 
@@ -1999,8 +2000,10 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 void prep_and_add_allocated_folios(struct hstate *h,
 				   struct list_head *folio_list)
 {
+	nodemask_t allocated_mask = NODE_MASK_NONE;
 	unsigned long flags;
 	struct folio *folio, *tmp_f;
+	int nid;
 
 	/* Send list for bulk vmemmap optimization processing */
 	hugetlb_vmemmap_optimize_folios(h, folio_list);
@@ -2010,8 +2013,12 @@ void prep_and_add_allocated_folios(struct hstate *h,
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
 		prep_account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
+		node_set(folio_nid(folio), allocated_mask);
 	}
 	spin_unlock_irqrestore(&hugetlb_lock, flags);
+
+	for_each_node_mask(nid, allocated_mask)
+		do_zero_free_notify(h, nid);
 }
 
 /*
@@ -2383,6 +2390,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	long needed, allocated;
 	bool alloc_ok = true;
 	nodemask_t *mbind_nodemask, alloc_nodemask;
+	nodemask_t allocated_mask = NODE_MASK_NONE;
+	int nid;
 
 	mbind_nodemask = policy_mbind_nodemask(htlb_alloc_mask(h));
 	if (mbind_nodemask)
@@ -2455,9 +2464,12 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 			break;
 		/* Add the page to the hugetlb allocator */
 		enqueue_hugetlb_folio(h, folio);
+		node_set(folio_nid(folio), allocated_mask);
 	}
 free:
 	spin_unlock_irq(&hugetlb_lock);
+	for_each_node_mask(nid, allocated_mask)
+		do_zero_free_notify(h, nid);
 
 	/*
 	 * Free unnecessary surplus pages to the buddy allocator.
@@ -2841,6 +2853,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		 * Folio has been replaced, we can safely free the old one.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
+		do_zero_free_notify(h, folio_nid(new_folio));
 		update_and_free_hugetlb_folio(h, old_folio, false);
 	}
 
diff --git a/mm/hugetlb_internal.h b/mm/hugetlb_internal.h
index 1d2f870deccf..9c60661283c7 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -106,6 +106,12 @@ extern ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 					   struct hstate *h, int nid,
 					   unsigned long count, size_t len);
 
+#ifdef CONFIG_NUMA
+extern void do_zero_free_notify(struct hstate *h, int nid);
+#else
+static inline void do_zero_free_notify(struct hstate *h, int nid) {}
+#endif
+
 extern void hugetlb_sysfs_init(void) __init;
 
 #ifdef CONFIG_SYSCTL
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 08ad39d3e022..c063237249f6 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -340,6 +340,7 @@ static bool hugetlb_sysfs_initialized __ro_after_init;
 
 struct node_hstate_item {
 	struct kobject *hstate_kobj;
+	struct work_struct notify_work;
 };
 
 /*
@@ -355,6 +356,21 @@ struct node_hstate {
 };
 static struct node_hstate node_hstates[MAX_NUMNODES];
 
+static void pre_zero_notify_fun(struct work_struct *work)
+{
+	struct node_hstate_item *item =
+		container_of(work, struct node_hstate_item, notify_work);
+
+	sysfs_notify(item->hstate_kobj, NULL, "zeroable_hugepages");
+}
+
+void do_zero_free_notify(struct hstate *h, int nid)
+{
+	struct node_hstate *nhs = &node_hstates[nid];
+
+	schedule_work(&nhs->items[hstate_index(h)].notify_work);
+}
+
 static ssize_t zeroable_hugepages_show(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
@@ -564,8 +580,11 @@ void hugetlb_register_node(struct node *node)
 		return;
 
 	for_each_hstate(h) {
+		int index = hstate_index(h);
+		struct node_hstate_item *item = &nhs->items[index];
+
 		err = hugetlb_sysfs_add_hstate(h, nhs->hugepages_kobj,
-				&nhs->items[hstate_index(h)].hstate_kobj,
+				&item->hstate_kobj,
 				&per_node_hstate_attr_group);
 		if (err) {
 			pr_err("HugeTLB: Unable to add hstate %s for node %d\n",
@@ -573,6 +592,7 @@ void hugetlb_register_node(struct node *node)
 			hugetlb_unregister_node(node);
 			break;
 		}
+		INIT_WORK(&item->notify_work, pre_zero_notify_fun);
 	}
 }
 
-- 
2.20.1

