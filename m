Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3FB60A262D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=QG4hV9o3
Received: by kanga.kvack.org (Postfix)
	id D58806B05B9; Wed, 11 Nov 2026 17:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F456B05BA; Wed, 11 Nov 2026 17:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6BED6B05BB; Wed, 11 Nov 2026 17:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A74F6B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:43:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12E8E80433
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:11 +0000 (UTC)
X-FDA: 85424315382.18.E70AA21
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4A7D160002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:43:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=QG4hV9o3;
	spf=pass (imf08.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794436989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBoTs6r5wYqfFVcu6Z9h9kAjCr3YDmQNMbyd7fcbAzM=;
	b=GfcralXhfVTVtJiE4L0rN/R1hY3kyq1nBfLciK+f81SqUnOgw53mcazqeBraX8d7Xt4VNM
	lGWEb+VvDDwLauIKLla54a9F3HtKRlz/qF3hS8rm20f9mj1EF3cI6gtK1ybKD5NpFOUlW+
	tZ3Yd7j2EbkSNvdSZ/b7rbCe1BlN6nY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=QG4hV9o3;
	spf=pass (imf08.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794436989;
	b=xc7/BpsG76/JGjbp4xv92lSrPbvDZGZJUw+scyjZ8aV4nfLsT443aMJdr7hbn3oQ+1vPwC
	BKKZl8n2m/WsokR9h4/M3gWcuENF+xL76geR1/tN1XvLlYLK8MAfCez++ho3iksD3Nt1RL
	NRgaKERvivNmpl9H7naOknGA3edQXqw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794436988; x=1825972988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RBoTs6r5wYqfFVcu6Z9h9kAjCr3YDmQNMbyd7fcbAzM=;
  b=QG4hV9o37NwEjKw812sbjqUFCfH+50RlB5mj0Cfz0d/eSRsdan3NEZyy
   YWV9rjULefcFf+Dt6RgYdA66VWUKgO3f0lHryfygCsgQWz6GNjff3MgiQ
   xW7kULEyjEehX/e4Xspmqp3+LLvsLDxpFLqMiUOApuzgDOtgl2zgW97By
   nMlYMRo3i2jeT3CGymAPSvwySl8L9tP5F03mxFQKygK4NbnkjokUyXEvN
   /Igk9FGRsT1caBz6PVBgUI940oAdN9Se9WPTOOwIxzMkHxJc8MGgDhoRi
   8Di0W9V5l1wCb7ZSJ4rnX70EcZ9kOymZm48zfezkD9Oqzlobgi3oPoZtz
   g==;
X-CSE-ConnectionGUID: Rso91KE1TdiVCucbxbm6og==
X-CSE-MsgGUID: B0cPfbwwSJiu+2CdqbxQQg==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33769022"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:43:04 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:29544]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.250:2525] with esmtp (Farcaster)
 id ae4ac7d1-cb28-48b7-a577-32d39a81e1a6; Wed, 11 Nov 2026 22:43:04 +0000 (UTC)
X-Farcaster-Flow-ID: ae4ac7d1-cb28-48b7-a577-32d39a81e1a6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:04 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:01 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 05/40] dma-contiguous: add dma_get_numa_cma_area() accessor
Date: Wed, 11 Nov 2026 22:41:50 +0000
Message-ID: <a1294df95fbe0a2ef5cc3585824d396854c7242c.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: pdgcypyizfco67bm85sy4sapwdkd9fm7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A4A7D160002
X-HE-Tag: 1794436988-319293
X-HE-Meta: U2FsdGVkX19Mkd16rI2N8tSp32hjNHb8J94UC6PGV2q67uJ3eeeb32n1XybEMIFTPl9p+OeHEOkQtb5OjLVrWaOvBCotAie1PngWgR6B9jfOT1u55euRih+VdExYAycfB+NmnY6SuSKasnGacAEY08gT/gHFFIrM4Jr3zkoSgbmPy/49dv8ld+Cz+W0rxrS5x0rv0hHZezEY/L/e38TYjs6FXTzbEhgyKEMQv5KzfNpSMMgrurtxkpW+SlrzaD5toL5Mg1jd++WGAFzkQqn03BNRQm4c97kBLorLMR/N6lFYejSwrA+aVu0Wd0AFSiFxrpXgRhTjDmwcs9VWLz/NzuzbKsk+zkI1PC+ORvoscKrTb73lMECXkubgpF6mh0M735MtTPGpnDd3Rrw2mRSJxd0rcSdQ1xEk4uduGXv6WQGIKEAvS6Tn0++T2YA9NGBnD9hQ5Vd6xOsPBfzZBNsVuhQphO551UZOLVvD8t6la5a75dG00zSIoWBx5avrscWHMPFPR+eu58bp2tYVllZU9J2Nf2zF7/gRB4ZOBy48you1BOGp0o9kFs+S/6SUN6lD3/n0HmPL4P3qK9QJ7yevxzxifznLRp6yTFaNWGHpvaN4fIlAGnAT7hKrANP3Kouzw34nldMoE78vquOaOBzGcuC8MeDlFgd63pS0TyVOdYNaAYgk1H8eYL0XennGNJBE65oId8wKvpA49nYcrMIJpIFiuujMwt6WuLxkxWTVPo6yZ58740KWt69WmcT4PWP4n/F/+ad1sXpGPoOuaYP8UIDC/xc3wyUAmgg977/af2tjVzXbDoywHeUxLRfWK3ENU9KMhAilzbUl7hR4Zs+JagoUwb06v1flCrueCeuyhlABykVWPR6LoiFr7MRERqZ8Jdun9OLOPi0hsG9hjHDzm9s51fbZn6d4fqDEP8Xmy1Vk2KMtJVUpNe+zq1X7UBTJkOiNPscVeOrQNjW2nrh
 cHngdpn1
 bIwPQ+zFEZ0mgLHXjdJMhcikAi4unFMFgKPyMFnzMm3VZiuekjytgcFBPJteR8khDi+7Fcd+UO/zEIGic0I6Odokb6VAq8HU8vpofTJ4faAnOZC1yywYgPWwtKHLm/B9koUby5BHn2kEIsx9nS0NVxlqp0F2JUExmtZ4EfJs9DtO0kaL2IlQaXvhJH7ufHQbSu6Z/r1lDrNT7ui3uya971gHuU6l5HhVxbNOtow9q0Vc+ZaQbQEp3aiRZJfqH81Czwwnffk6hPWXvxfVWL1f5cVUbepyIUB1iFSWRA6rAJBCGZqlNtjzeQIg2nFgDE1u+wIYKZubG2+l/XQyL3kcY56SfLq/VXkF6fojrOp+J1hjsyH5bxoqff16vfnobT4z/xa4QxHWvskB03YXUcyLe9RhCEljMO2x/QwPevqTUM4rsWCoqK1xnWadbeypcSEfpRkT2rfOkixBI9JQ5plJhkrZvoirjk3bZ2yVo/Y1I02iLkr+KMQvRvfJDqFZCA1kFtP5qiy8DMTWKhMsl/nHHg9sJ4xtfGPDkHg92c+ZC7L4EHBnqItBut3cRBxiCsvWngQH4vdYGgYvs5qAXreoIjyhN6SLTm+O60zddrH1u9egKC43rYaYifANw2FxE4G9JHodgTVIuzapHizJHL5iM/at+0Dc+dOGnUILPw0MU7e8QQdcd3NYztTm0uGQnLc8S2EedrgTOFdKJNaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With Nitro Sandboxes, we want to allocate per-NUMA memory from the DMA
contiguous allocator, but have no per-NUMA struct device to pass in.
dma_alloc_contiguous() takes the node from dev_to_node(dev), and the
per-node areas sit in dma_contiguous_numa_area[], which is static.

So instead, introduce dma_get_numa_cma_area(), which returns the generic
per-NUMA DMA CMA area that cma_alloc() would use. This way, the
nitro_enclaves driver can build its own generic CMA pool per-node
allocation logic on top of those pools.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 include/linux/dma-map-ops.h |  7 +++++++
 kernel/dma/contiguous.c     | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index afaf2c12189b8..5f7138ea6899a 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -93,6 +93,7 @@ static inline void set_dma_ops(struct device *dev,
 #ifdef CONFIG_DMA_CMA
 struct cma *dev_get_cma_area(struct device *dev);
 struct cma *dma_contiguous_get_area_by_idx(unsigned int idx);
+struct cma *dma_get_numa_cma_area(int nid);
 
 void dma_contiguous_reserve(phys_addr_t addr_limit);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
@@ -115,6 +116,12 @@ static inline struct cma *dma_contiguous_get_area_by_idx(unsigned int idx)
 {
 	return NULL;
 }
+
+static inline struct cma *dma_get_numa_cma_area(int nid)
+{
+	return NULL;
+}
+
 static inline void dma_contiguous_reserve(phys_addr_t limit)
 {
 }
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 90937dc7c627d..363b84284d087 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -443,6 +443,42 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 	return cma_alloc_aligned(dma_contiguous_default_area, size, gfp);
 }
 
+/**
+ * dma_get_numa_cma_area() - get the CMA area a NUMA node can allocate from
+ * @nid: NUMA node id
+ *
+ * dma_alloc_contiguous() picks a per-node CMA area from dev_to_node(dev),
+ * which a caller cannot override on a per-request basis. This accessor
+ * returns the area a specific node can allocate from, so a caller can
+ * cma_alloc() from the node it wants.
+ *
+ * A per-node area comes from numa_cma= or cma_pernuma=, or from
+ * CONFIG_CMA_SIZE_PERNUMA, which reserves the default area's size on every
+ * online node on top of the default area itself, all three of which are
+ * CONFIG_DMA_NUMA_CMA. Where there is one online node this returns the default
+ * area, so a host that reserved only cma= reaches its reservation through this
+ * accessor as well, and that holds however CONFIG_DMA_NUMA_CMA is set.
+ *
+ * Return: the area @nid can allocate from, or NULL if @nid has none or is not
+ * a valid node (including NUMA_NO_NODE).
+ */
+struct cma *dma_get_numa_cma_area(int nid)
+{
+	if ((unsigned int)nid >= MAX_NUMNODES)
+		return NULL;
+
+#ifdef CONFIG_DMA_NUMA_CMA
+	if (dma_contiguous_numa_area[nid])
+		return dma_contiguous_numa_area[nid];
+#endif
+
+	if (nr_online_nodes == 1 && node_online(nid))
+		return dma_contiguous_default_area;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dma_get_numa_cma_area);
+
 /**
  * dma_free_contiguous() - release allocated pages
  * @dev:   Pointer to device for which the pages were allocated.
-- 
2.47.1


