Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5185EC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9856B009B; Thu,  6 Aug 2026 04:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559A76B009D; Thu,  6 Aug 2026 04:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4217F6B009E; Thu,  6 Aug 2026 04:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 075966B009B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:09:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E2E1C069B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:09:58 +0000 (UTC)
X-FDA: 85070121276.18.5B0FD62
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf04.hostedemail.com (Postfix) with ESMTP id 365C740004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:09:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=pass (policy=none) header.from=sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786003796;
	b=p+krfEfswlvprIZhKlh+hky+oJIS7oVZwawLnimJQ9Mr6HIhyhv7WIWeJ40tR5cikTi6Ts
	U9ASUE+ph29l67d/DGeOSlZzrrRLMCg1vQO/hyYwUkZqHcq8XBhnlU75Ry6/2UnOAzi029
	qRjqsEBNtjcBxkwZtuKeH8izIqgUym4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=pass (policy=none) header.from=sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786003796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nybiZBTFTlp1JX7q4puTjj7mtm9LGiY2eThuX1Vuwzc=;
	b=n9RnmvYofgXHVoeKX55NsQIQR058GCxJJ4x3LVNHqsA65rmgwJjvnVF6GGuRVRXaIgMlmH
	j67D/8JWVy+Z3Pyv4nwFQXN6BqVN2gH/k/mkN3gheW4VZs+4Zzj3M5CmQ5HKvcdu7DvEDb
	rFL+xZ/P9yZIVHHX3Pbgsj+/Rhvz6PM=
X-AuditID: a67dfc5b-c45ff70000001609-a9-6a74414d29b5
From: Rakie Kim <rakie.kim@sk.com>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rakie.kim@sk.com
Subject: [PATCH 3/4] mm/memory-tiers: register CXL nodes to memory packages via initiator
Date: Thu,  6 Aug 2026 17:09:34 +0900
Message-ID: <20260806080936.421-4-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>
References: <20260806080936.421-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsXC9ZZnoa6vY0mWQf8lEYs569ewWdx9fIHN
	YteNEIsTNxvZLFbfXMNo8XzrL0aLn3ePs1tcv7WS0WL/0+csFg+aVjFZHN86j91i3alDbBbn
	Z51isbi8aw6bxb01/1kt3jx2s/jWJ21xv8/BYuWPP6wWR9ZvZ7KYfGkBm0XHy/ssFrcmHGOy
	WL0mw2L20XvsDpIeO2fdZfdYsKnUo7vtMrvH5hVaHov3vGTy2LSqk81j06dJ7B4nZvxm8dj5
	0NLjxeaZjB69ze/YPKbOrvdYv+Uqi8fnTXIBfFFcNimpOZllqUX6dglcGXPen2YrOKFcceDN
	e9YGxm2yXYycHBICJhLLP25ggbF73s1h72Lk4GATUJI4tjcGJCwiICsx9e95oBIuDmaBRawS
	Jz6fZQVJCAtESmy6cIkdxGYRUJX4+24q2BxeAWOJFYu72CBmakqs23gLLM4JNP/7nUVgthBQ
	zZ9f29gh6gUlTs58AhZnFpCXaN46mxlkmYTAV3aJv/t2MEIMkpQ4uOIGywRG/llIemYh6VnA
	yLSKUSgzryw3MTPHRC+jMi+zQi85P3cTIzBWl9X+id7B+OlC8CFGAQ5GJR7eC8bFWUKsiWXF
	lbmHGCU4mJVEeFkPFmUJ8aYkVlalFuXHF5XmpBYfYpTmYFES5zX6Vp4iJJCeWJKanZpakFoE
	k2Xi4JRqYOyIt22vX3r6u1qfRktVcUqxSOvZlU91bYofvsp79uPqwavM145c3J250ITvjWtK
	S+yKSRbyD9uetvTVteSrHHgQ88cm5skmxtnPvzbvWKK8/rn3P+Vrs60PegYbHbvQnNdacdfz
	9ras82HNrvs9tU7uXPBpzzwJxm8aL9RiLVepHahhEykoLldiKc5INNRiLipOBACQgDsF0QIA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG+c7ObcPRaQmdNBVWUQ1Sw4ovkNQ/9aERClmZUq48temcujl1
	galJUivFLEPdClGwqUtxpqkk1UznhdK0Mi0v4T1FrYWZF8opgf9enufl/fPSPFEj7kTLlfGc
	SilViEkBLsjbG3bgpF98pOeHZm9oqDSRcGCki4QNn0/Ddw/0JGztSyNheZ8JwImaJQD/DFgp
	2NtfCqBtfJoHX45N4HD4RhkGrTWPKdj0qI2AFe0WEnYWtOOwp8FAwkHTXwLOjByHC1nOcCjL
	F5YurhDQ8mmCgG8qn2PwfnchCW9NDeGwP7sFg+UmGVyuNZJQ3zxI+bqi+oIBChWaNehORg+F
	qo0SVPxiCkPmstskMv/MoVBr3jKO6r8dRZPV+QBlps+SaOELQsWT8xjK1aegymcfcWQzuwYy
	5wXeEZxCnsCpPI6FC2SGuQ4ytnVX0quZOSIV1LroAJ9mmUPs3VkDpQM0TTJitqUxzI4dGRc2
	d7UT1wEBzWOKCLbV9pawi21MCGvu6qbsGWf2sKuzubg9Cxkv1lisIzc297MVVf3rnL+2//tr
	0XoWrXVWlmqpjf5Wti1/dJ3zGDc2vUbPywYOBZtUwSZVCLAy4ChXJkRL5YrD7uoomVYpT3K/
	HBNtBmunliSv3KsDv3pOWABDA7GDsMtLHSkipAlqbbQFsDRP7CgkXqsiRcIIqfYap4q5qNIo
	OLUFONO4eLvQ/ywXLmKuSuO5KI6L5VT/LUbznVJBTsCYNaQ/qDh4HF+Ojm9Ql+j2zQelhdY1
	BV+56XN9y/vEuN07+gZ2Wj1Hp4Iv8VOeQsqKP1wIGD7SJEDfM2Knp23ZHVGSxT4PIHE9U4WU
	yacexbkTg7L6GUnooLbXHxtyV5zT5LOBiakuAU9+yP1yL6g1LjU+TQlDRreIzDkxrpZJD0p4
	KrX0H1WBXsDQAgAA
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 365C740004
X-Stat-Signature: jywix4b11bf131oa3qitsx3ccf3f95uz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786003795-558267
X-HE-Meta: U2FsdGVkX19h6wVSz7XsdHg+XEWZ7wBGKJE6ZHTCIcExURaIqN/b1/MeO+SZaTrNQJtA67tmr39WFjgpl5N4RstMDfkLHCywyydI0LONRgqyGhj+f/7QGajpwnIjJIZ8IrD7nvSrn10nbOD/+G3nMtAqK9f2hT0Bkvira43pSi4M2/dgqDh3SogFTcyHl+VHW9PDpZNyQHeEoTPdf8L/LXZocP73KTPsKgj0RIwY+zQ94fe5NsUi9I3/9xFcvT9tgTlUy0lC8YiBt+ipYco4DRHCmp5UBpFyozf+EuKAMqoNqkdkxiYdGxMDjqcq18oNFNcJ19RB7abg/sSDoFdQZIA6oagqu5vk0y7LQpqIHGTOH8G5Plwju+Uww/cyYyEtWM672catSzJ2eJI2/l/caWRqJ82owt0r9xNJ3XGH9ZMVqpkG8bDfXpDb/1OU1sqaATDSEcph31m3rEEG8qrh3NlOYNmYTEkKYYU1l3ELjFQavAnZhZ3TEmbLh+IhyG23Wsmc5ix7f8fBIfYIXvtBc/65RGWWadsqP+tti3+FIhOajXKypLl59APA3L40srPcjm+OTX2/8Ne1lbA3m6hcT3J+2spO5VkOXCjGk1scfHUhSPMqsy5lQyjc4CWY9dWx2k4HJZ5JzvfZzAZTFC0wbMcRKlm29DGjbDHGIx/epHTfVQR7W83/+2fmLObsGKXCjpXHp3EDgyZ+gc2sdSPHAeErzVuq16V8bvyvNtBPKVX2GjdpFhuScD6swa8BD+nlQ+isM2rW8sGSHXseNQiIOU+ff9cepz/FXo0ARzs2S8MRKo0DkLqLxcWbfIqpU7dHOsrkJG4PI3dLWmmxCzSKB8MQAeMo0y2RNT8L5lePp7kwq8suVdxSTUdhopF70vSSmW1lmGWYyzZw8alkrdjFtTObsUx9+5AhI+XBXMUo8zCFGcoTjmot7mtCCrd3LoXHc2QbXRopAHevotbxrAZ
 4sN9gOOQ
 QDD4lwuTXsXMUQYyhMA6Ran0pXuHujJ1uMFIs5MU4x8lWgtshdKD0pFL42X+LGzxEbQC/Q0aNvme9Hi3VlBStD8rfQwu43vjMiIhHZJqlb/vY1AcoYIbMU8DizpRfoyR8O8xW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A CXL memory node comes online without an explicit package association, and
plain NUMA distance does not convey which physical package it belongs to.
Without that association a CXL node cannot be grouped with the CPUs that
front it.

Register a package notifier per CXL region. When the region's memory node
comes online, the notifier resolves an initiator CPU node - the NUMA node
of the first memdev backing the region - and binds the memory node to that
initiator's package. This gives the topology layer the CPU-side association
that plain NUMA distance does not carry.

The initiator nid comes from the firmware and driver description of the
region's endpoint, so the association is only as accurate as that
description; it gives a more direct host-side grouping than flat distance
values.

Signed-off-by: Rakie Kim <rakie.kim@sk.com>
---
 drivers/cxl/core/region.c | 54 +++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  1 +
 drivers/dax/kmem.c        |  3 +++
 3 files changed, 58 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e50dc716d4e8..af66e2e06c62 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2673,6 +2673,55 @@ static int cxl_region_calculate_adistance(struct notifier_block *nb,
 	return NOTIFY_STOP;
 }
 
+/*
+ * Find a NUMA node to act as the initiator for this region: scan the
+ * region's endpoint targets and return the first one that resolves to a
+ * valid NUMA node.
+ */
+static int cxl_region_find_nearest_node(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_endpoint_decoder *cxled = NULL;
+	struct cxl_memdev *cxlmd = NULL;
+	int i, numa_node;
+
+	for (i = 0; i < p->nr_targets; i++) {
+		cxled = p->targets[i];
+		cxlmd = cxled_to_memdev(cxled);
+		numa_node = dev_to_node(&cxlmd->dev);
+		if (numa_node != NUMA_NO_NODE)
+			return numa_node;
+	}
+	return NUMA_NO_NODE;
+}
+
+/*
+ * Package notifier callback: when a new memory node is onlined via dax
+ * kmem, bind the node this CXL region backs to its memory package, using
+ * the nearest region target as the initiator. Notifications for other
+ * nodes are ignored.
+ */
+static int cxl_region_add_package_node(struct notifier_block *nb,
+				       unsigned long dax_nid, void *data)
+{
+	int region_nid, nearest_nid, ret;
+	struct cxl_region *cxlr = container_of(nb, struct cxl_region, package_notifier);
+
+	region_nid = phys_to_target_node(cxlr->params.res->start);
+	if (region_nid != dax_nid)
+		return NOTIFY_DONE;
+
+	nearest_nid = cxl_region_find_nearest_node(cxlr);
+	if (nearest_nid == NUMA_NO_NODE)
+		return NOTIFY_DONE;
+
+	ret = mp_add_package_node_by_initiator(dax_nid, nearest_nid);
+	if (ret)
+		return NOTIFY_DONE;
+
+	return NOTIFY_OK;
+}
+
 /**
  * devm_cxl_add_region - Adds a region to a decoder
  * @cxlrd: root decoder
@@ -3852,6 +3901,7 @@ static void shutdown_notifiers(void *_cxlr)
 
 	unregister_node_notifier(&cxlr->node_notifier);
 	unregister_mt_adistance_algorithm(&cxlr->adist_notifier);
+	unregister_mp_package_notifier(&cxlr->package_notifier);
 }
 
 static void remove_debugfs(void *dentry)
@@ -4066,6 +4116,10 @@ static int cxl_region_probe(struct device *dev)
 	cxlr->adist_notifier.priority = 100;
 	register_mt_adistance_algorithm(&cxlr->adist_notifier);
 
+	cxlr->package_notifier.notifier_call = cxl_region_add_package_node;
+	cxlr->package_notifier.priority = 100;
+	register_mp_package_notifier(&cxlr->package_notifier);
+
 	rc = devm_add_action_or_reset(&cxlr->dev, shutdown_notifiers, cxlr);
 	if (rc)
 		return rc;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 1297594beaec..9281ca3a5f0f 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -477,6 +477,7 @@ struct cxl_region {
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct notifier_block node_notifier;
 	struct notifier_block adist_notifier;
+	struct notifier_block package_notifier;
 };
 
 struct cxl_nvdimm_bridge {
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 2cc8749bc871..1de23f196354 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -94,6 +94,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (IS_ERR(mtype))
 		return PTR_ERR(mtype);
 
+	/* Resolve the memory package for this newly onlined kmem node. */
+	mp_probe_package_id(numa_node);
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
-- 
2.25.1


