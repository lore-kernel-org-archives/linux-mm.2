Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B784ED232EF
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1206E6B0088; Fri,  9 Jan 2026 03:56:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C98D6B0089; Fri,  9 Jan 2026 03:56:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15A26B008A; Fri,  9 Jan 2026 03:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD3CE6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:56:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F26458CF0
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:56:38 +0000 (UTC)
X-FDA: 84311819676.04.33DDF03
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id 534AC140009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:56:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A5HnMYwz;
	spf=pass (imf23.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767948996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1C4SXc9txWHarrSa+EN97vKZ2VSa84XrNklAGg0RSHw=;
	b=AG371hooJuDUCNa54W+QnP9Uzvw8qsKnTayptajFSTYRsbFf8LRyTEC64RHYBi1Pp6gzSK
	sjvq9di/vX+cXDcV0AvsRxTgB4DLq+w9nrglKD+neyLpUJqKgZ0UJs9iODfJ5nP9Fhsc8g
	6kw3fs7/pFYVJ0h5h7uiE/H0IuMuzEo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A5HnMYwz;
	spf=pass (imf23.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767948996; a=rsa-sha256;
	cv=none;
	b=ResnWMv41scSeDTRs2F0gYQoq3QKXlXhFMFMXow/v2FulhIpeXDU/qlWa/WLZ2QHq6f5bN
	nqC0fbubeLwnAjBEtzMPeRcFOIfUKdW99gpLY6w8qs3MSfUUak6ddpQ/ma69DxTxDVBqgs
	0GPW14VmiX5f0ySp2ErMrbDWS0bVe0s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767948995; x=1799484995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ei3iOPS+myBqtT5xuA9JKyEL9TietkXXYAr7sL9XrQ0=;
  b=A5HnMYwzOHyqAg2aoMTvmQl7rjMBYRuhW9cUzDHTmFh/vnAafAWwetHo
   Ade8lHb++1IIsENJWmlydS77p5EmrzYMV57fS2ocDQ8R9Bs4l7vAqvTpU
   APShkCUDF2Rs66GC0Sg/L49D9eJFWhgY8TULePvC9HrnLvp+dtURulp0W
   CZVW4YEJT1SWFxQ3k1/cMVxtOaZRR9X1NJwL9Q5adC95ovAxmQ5nSXlgi
   23Se/wYwHxAGHUwceeqhOx1j5HwicCYo7b3XDGIsaidTVd6jNb7YXwg+q
   o/wDXPQbCmaRQlvCY8PM3dEdFzZpcVu/4WGgcOUNWV0BS3rtmYvjbvXfC
   w==;
X-CSE-ConnectionGUID: 5aLJGP2iTFiDCfHcB2AdGA==
X-CSE-MsgGUID: 1f7VRPHRSWCPjF7Z8I98Qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="79625970"
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="79625970"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 00:56:34 -0800
X-CSE-ConnectionGUID: LgJ4gWLiSTGmrZf/2pruUQ==
X-CSE-MsgGUID: CFcs2tEXQX2urP2N69BAeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="202538591"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.83])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 00:56:30 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alistair Popple <apopple@nvidia.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v3 1/7] mm: Add folio_split_unref helper
Date: Fri,  9 Jan 2026 09:54:21 +0100
Message-ID: <20260109085605.443316-2-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260109085605.443316-1-francois.dugast@intel.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 534AC140009
X-Stat-Signature: zcjbxgbpjo3cx9h3zrnb5gfy4fqeopm8
X-HE-Tag: 1767948995-207792
X-HE-Meta: U2FsdGVkX18k97tfMwXbqb8kMthAPnqiNgxRDhhhNICQH3cHo8V48SBb6jia4SKiv2gokAxJ/raEgrayEGPonzkJvS5jRU6M9GZHdhvq5htFO2E9I8uEyxlUqu4UKiE2ZC3W4N7S8YPMOoUIYsjR+fXYdMdKDBkyGnWby/21X08tK0K4BVtb+gI0RtDn8DIYv3XE+EETxLq0pTGqm0WQdSYbYu/UdIiNc7MkEt2nhzeU9htQLtA6Ib5QoFvyldSjaMPLPRR3uR2YW/wA6RnNoW/VmhJs9T+xKHxX4O4zg1Kvb9gC3ngYchToI41V3SlwA8rm+Ecc5RpHAWSHd9Vaex1zxB2UEiY1TFM0yhlMOwv3UXcSv4jG84HhNJ6/DqgrPMZ+1Dv9flkWvxFxJERUm3ipDgS1AnReA4RMACAACukM6kY7elJcHD3AGZTi0y0zx4Z1ed0diYR17TLts6l2anUkZaIfy2gNoKTJ0L6gxM+XeD3fle6uW79pgNEYYL2X1X1BzwjEmg6F5kjOelyKnNGSF7hn9mHct00DhRnyoc6yWuSEQtlo5/q0yhRIKfi+Th1Ilbp+73WVj3DGFP/eYlceAToBZSrtGQ+wyzAJAGgb6G+y+2fp6fP/xPYo30nbqvw1kTi6ZBR/QVaJNtJ84PiwXBEKihs/4z+ZR9CDLIGk4TzAv8hEYSOPW/8lCl/qExl9uUoe6v3EwxM5oX8UOUJzywTJJDRAmx9jjVrNzfoXos5IUfV0KpJ75fIhJzIzNClEqHhTePa2iBZLl6Z9I7ZJoagY48tSer+cNPBU+0EN+SiXapMvRDp7NgIDc0iFW+pEIV91oVAI+RXXIzPBJBLeeeOuYun9gwLoRMQ6B8ZgPFxs8Uh/iPI6oxClG/a1fGOPK7AxDlPZFSQpgSrLLco7+IL3D3YomUGt8w3L5aRfAx4RQRtKA/9/FugUKNeSiYQ6NAUG1S+kv61Lvw7
 4bto52BE
 MhTdB36JND1g1bMY/mQTbDYw0jVBBxtPoJAvGEe5VoF3tcf56YT/XPtEFgJsOepQJJEo964BFv14DEv0TbzwYLWvfbKOyA2ctg4aBz5wxQNzmL2OxYDdePtar3jqCG5N8BLwJnIULm/azsKVieDiheVuTH3hx7FctNJsEPUHX7jRwX0qY6w7dcyArWnePz14CDgj9C+T5ZjIqEi7zfIEewfR9Z3W+LgW29dp3etd1AB7ts3i8thRKJCo70jTC6TUWTII80Na9h8HJWk4XNIPEnah57b02FTLy0SQDmRDVv0Bq90b4eaZQBPByfBLrY03ZnFksPUovSo83whRwinvLC8EjMAM+pJgdDaE44bGtGdan///5Iy2+sY4MZvLiABR/AYRLY0uOukTl28tjUIiqmLH+EsqmhK09Lo6+3B11WW6VZnoiOcwvrMTdbZ3xtCtRcth8Nsky7dwtaDzplHafPmdsX9vYQZZHrKWlG/i8x8zAR1J7LKXDPMwBhGiUJveuSQiGkqDLeXZNbG0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Add folio_split_unref helper which splits an unreferenced folio
(refcount == 0) into individual pages. Intended to be called on special
pages (e.g., device-private, DAX, etc.) when returning the folio to the
free page pool.

Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 include/linux/huge_mm.h |  1 +
 mm/huge_memory.c        | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..18cb9728d8f1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -369,6 +369,7 @@ enum split_type {
 	SPLIT_TYPE_NON_UNIFORM,
 };
 
+void folio_split_unref(struct folio *folio);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..0eb9e6ad8639 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3580,6 +3580,45 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		ClearPageCompound(&folio->page);
 }
 
+/**
+ * folio_split_unref() - split an unreferenced folio (refcount == 0)
+ * @folio: the to-be-split folio
+ *
+ * Split an unreferenced folio (refcount == 0) into individual pages.
+ * Intended to be called on special pages (e.g., device-private, DAX, etc.)
+ * when returning the folio to the free page pool.
+ */
+void folio_split_unref(struct folio *folio)
+{
+	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
+	int order, i;
+
+	folio->mapping = NULL;
+	order = folio_order(folio);
+	if (!order)
+		return;
+
+	folio_reset_order(folio);
+
+	for (i = 0; i < (1UL << order); i++) {
+		struct page *page = folio_page(folio, i);
+		struct folio *new_folio = (struct folio *)page;
+
+		ClearPageHead(page);
+		clear_compound_head(page);
+
+		new_folio->mapping = NULL;
+		/*
+		 * Reset pgmap which was over-written by
+		 * prep_compound_page().
+		 */
+		new_folio->pgmap = pgmap;
+		new_folio->share = 0;	/* fsdax only, unused for device private */
+		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
+	}
+}
+EXPORT_SYMBOL_GPL(folio_split_unref);
+
 /**
  * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
  * two ways: uniform split or non-uniform split.
-- 
2.43.0


