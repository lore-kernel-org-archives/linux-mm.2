Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78858CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139F38E000E; Tue,  2 Sep 2025 08:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E933B8E0011; Tue,  2 Sep 2025 08:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BDD8E000F; Tue,  2 Sep 2025 08:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1B838E000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FC601A0136
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:20 +0000 (UTC)
X-FDA: 83844290880.08.52D552A
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf13.hostedemail.com (Postfix) with ESMTP id E90E22000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=24Q26XOTfnEdhJqgab8OsoPihlmt1Gmm9p55zusICxM=;
	b=6vaDqm2MSjghESGSloLDaY96xqbXTDFgu+W/ihGAjdkju0XDIEGScdzk45oOEYUmHuhMp/
	qGHg5SOflDaqWTt+UsNxxqn0GRVVOcNyQFetmFoQvSrhxsJgwIHPfkxtcYIvBWlYi0Zi2n
	6q51k/K8rRhsu+0I3tS09QBEgzMkgbI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817358; a=rsa-sha256;
	cv=none;
	b=RmlWCeUwygsscnoW8uu0ningtAME/D4gmT173QzhyoYARB3Es0/VtPjmJ6Ycj8SOo3MlDJ
	LepOGi7AMl5EjcldEw/w6nMvvezNeERJEJ5GvAvijEzYN8qT/gLHsbKK2HpRWI57vcONwa
	Hu0nL6SaFRSjf8GpW7ljl25S5XfhQuA=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cGQTX0xXFz24hrB;
	Tue,  2 Sep 2025 20:46:08 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 88BBF14013B;
	Tue,  2 Sep 2025 20:49:13 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:12 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 3/9] mm: hugetlb: directly pass order when allocate a hugetlb folio
Date: Tue, 2 Sep 2025 20:48:14 +0800
Message-ID: <20250902124820.3081488-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: E90E22000B
X-Rspam-User: 
X-Stat-Signature: bwros9r6erdggyzkupp5yzanzgoqgdk8
X-Rspamd-Server: rspam09
X-HE-Tag: 1756817357-619874
X-HE-Meta: U2FsdGVkX1/KdRVRYFJS4nJEg1BOKSPThp9hbScLpBl3zrYWF1lbtjZfU/W/FWP8o2GYDl317s3YfmAiK216+u79YZOaCErcHW8QVOBacijbWkVAp3hV52t/qhhJn03gbFNMHV+KqgPUxcmXSAMwc1CQj4Cgkrv1fm+d8b0VSvITnI1KHc3SGTBuVe+PiRC3RJ/khYjR+HGJjXsEnSlMlaMScIxdVc03d8EU775epFlClMppe9cwMbz4C3wOic2lmdN9g99ww5Lm5STQRdOemf4cNwnn+Vi7LfdlsUuPSxemVehP/vb//Jeofrd5aUa2jWxqUutx/vqCTnteyWyKHLmjjGnTHZByia+cLnUaOSuHTpW/8iWXKFVU0Rf/v2wYmms3VAA+/+nGJv9P+AYO+s4rQrm6bWefC0uxcu+ThFc67grh16nfAdX4rdnniw32hVsoxjsYN25kYxefI33TYQ4fIA/BXmSM3K7uhPQtWifrSWa+TVDgmO/gpLKNC2EbXTrE+fA0xB06w52N4tiVncuRl0udS7THPMQ9czmAcDgnG99hsOU5jEVyjyUt8nx/fKlUCWq+0/tZYnAzLzTvoKEMjQdGFin6dLMiUksVePTZgKBE9QkqklLfJWr1WQrIVq8MkRPYNwC15/2TdJWhnglxtmZPiYlH9R5PITe5ZgYOi5i3rdReE4tMIpfGbWH4BpUtsiHoLfblUkitwg2kL0BRi5TDqxHi89FnnNstVWWc8b4ucvS9/HJaMPEjps8n0Wn0w0NqPNOZMfIzrum3HF1uTQN3f9nDEWZoze31e097dxncP/hncUvaGZpyhuAo3w/nLDhpg7ME8iIdk/2NeGXG+oX5w1+ga8CMVcmmKtQZ0iaPqdSoGCENt2I8BoWMvGaGVSVoeYPoEooz53tOyJzUIICAkSd6XulRrJw/lEib+jB+WVBpI7+MGKZ3MDO/+zb+62OcLbVOIJqh9Uc
 qCffKKRB
 RlYIuCxSbG3Eov57dXQPtWJBmel90JwjXxj5vr/6enDxE1ola96ysGQxsb+/vrxiT/ZdX0bv3g4Ro6E4sT15+TB/FcJ5micqFg8p9xTNa1GU5G8I5w64mTjRjFXNJGOQvBAMCbxRCy8zZYY7cL2uhjL4xHw5f5j65TouBDJUITQiJq+f+n6LvJWgTBOgp03A6bLlpafh6Jir3nCMc2LGPAsT+Fiz8MarZlGQc17+zIIcASH+ysIQLjHvAzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use order instead of struct hstate to remove huge_page_order() call
from all hugetlb folio allocation.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c     | 27 +++++++++++++--------------
 mm/hugetlb_cma.c |  3 +--
 mm/hugetlb_cma.h |  6 +++---
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4131467fc1cd..5c93faf82674 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1473,17 +1473,16 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 #ifdef CONFIG_CONTIG_ALLOC
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	int order = huge_page_order(h);
 	bool retried = false;
 
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 retry:
-	folio = hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
+	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
 		if (hugetlb_cma_exclusive_alloc())
 			return NULL;
@@ -1506,16 +1505,16 @@ static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
 }
 
 #else /* !CONFIG_CONTIG_ALLOC */
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
-					int nid, nodemask_t *nodemask)
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+					  nodemask_t *nodemask)
 {
 	return NULL;
 }
 #endif /* CONFIG_CONTIG_ALLOC */
 
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
-					int nid, nodemask_t *nodemask)
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+					  nodemask_t *nodemask)
 {
 	return NULL;
 }
@@ -1926,11 +1925,9 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 	return NULL;
 }
 
-static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
 {
-	int order = huge_page_order(h);
 	struct folio *folio;
 	bool alloc_try_hard = true;
 
@@ -1980,11 +1977,13 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		nodemask_t *node_alloc_noretry)
 {
 	struct folio *folio;
+	int order = huge_page_order(h);
 
-	if (hstate_is_gigantic(h))
-		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
+	if (order > MAX_PAGE_ORDER)
+		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
-		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, node_alloc_noretry);
+		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
+						  node_alloc_noretry);
 	if (folio)
 		init_new_hugetlb_folio(h, folio);
 	return folio;
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index f58ef4969e7a..e8e4dc7182d5 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -26,11 +26,10 @@ void hugetlb_cma_free_folio(struct folio *folio)
 }
 
 
-struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask)
 {
 	int node;
-	int order = huge_page_order(h);
 	struct folio *folio = NULL;
 
 	if (hugetlb_cma[nid])
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index f7d7fb9880a2..2c2ec8a7e134 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_CMA
 void hugetlb_cma_free_folio(struct folio *folio);
-struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
 struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
 						    bool node_exact);
@@ -18,8 +18,8 @@ static inline void hugetlb_cma_free_folio(struct folio *folio)
 {
 }
 
-static inline struct folio *hugetlb_cma_alloc_folio(struct hstate *h,
-	    gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	return NULL;
 }
-- 
2.27.0


