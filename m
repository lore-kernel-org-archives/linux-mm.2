Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF5360A261B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YdhnBWYe
Received: by kanga.kvack.org (Postfix)
	id 3E96E6B06E2; Wed, 21 Oct 2026 07:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1956B06E3; Wed, 21 Oct 2026 07:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8166B06E4; Wed, 21 Oct 2026 07:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF9016B06E2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:48:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77625C0537
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:01 +0000 (UTC)
X-FDA: 85346459562.13.003E153
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C87B440002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YdhnBWYe;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UY0BY5YZcT9xFUcwEXXKGABgtDytV9atXMOzM0KH+wY=;
	b=ZDwBz+Ed8X2H2Gy59iR6STIAmvTc6B+TOgNRoH1Izg9ik5vSaO1+9Nvq15c6sW8a9rqAjJ
	olLmJypo62B4YPUum7YXREmV8PxCR+l5IlUcfMiMaOvM9Olmi8/i8wF+OdghtuwmOnT8wN
	fZHfcYX5Hzji0X7uUt6HxgKuOgCuXn8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583279;
	b=WZXHpSBlgDxW17dyidMTEdG1RsrMRAq8al2PBtMzYr5+JHE3P8ccfY+DbqWMzbpMOqelf6
	OKHXmTm0GKek6urgmeGN4TC+ISszysvNCCWSCOLHltHxwPF2Ur1P51qoZZp4VYibNyw/Ez
	fPrKhf51rgkEVxi3lfJLeefblkg3Ncc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YdhnBWYe;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A664414D6;
	Wed, 21 Oct 2026 11:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992091F000C4;
	Wed, 21 Oct 2026 11:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583279;
	bh=UY0BY5YZcT9xFUcwEXXKGABgtDytV9atXMOzM0KH+wY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YdhnBWYe3LLCjDlSmUmc7fbfmRbuuqfaySN5me/ny51WQDoQFdlIh2+8UL9tQ3WUI
	 QLOQEHpo/RasEj1yUxSmp5WVnLLlhN48g3Gdgpk8Da3uyBRRa/yvGrSoekpmLLSlo3
	 Ts4DDL/G29GuMseX9g/VaL9o4FJSAxHJ6wNXwITPioc8BGogc9r1dMo6sF1/O+WW1/
	 VrMkruz4tjRP7Siphpg2GtlCcBNpsGrYoZv7ztN3r8kNPqI9BXcYNIDVCR05R9IvcU
	 jSpGR3PcurvE7W+458ZtaW8m9gmkJWIuysihjESrJLVgPldaTk6EQv6K6Wkr+5B2IS
	 Xf8YIIoHyE0tw==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:50 +0100
Subject: [PATCH slab/for-next 09/14] iommu: specify SLAB_MAY_ACCOUNT for
 slab-backed page table caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-9-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Niklas Schnelle <schnelle@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Chen-Yu Tsai <wens@kernel.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
 Samuel Holland <samuel@sholland.org>, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-sunxi@lists.linux.dev
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C87B440002
X-Stat-Signature: u4ssy7wswm3urx9or4ztc3bsd8p58pit
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792583279-895706
X-HE-Meta: U2FsdGVkX19koyWmE8yi0Zlxc2tq3jDTW9/xeO270+c+AU2Cl/bfMfl3l+JkDNQczwHCKoU5NkWbA6usnsp3gixBjyZwt6ZNsiWp00cxqX1GEBhDsQRIOlus/9pcuaQOSrDxHhZkuEBXxlKFODsX4oHNRM2XRrokRL0Hm2oMdL27gaXyKpgMvcPvcCa4mwYLq148h1Y8e3rEsMKflJl+F1OooTuEoKpaRV14E34e5otYAF6mCXA+b7izJfX3b+Ea6zaa+RDSOtriRlh62QRCt0KYaVNdtnUPl+JUredKJrkQL+qTGG4YTBBHnwCFOYZLqgcDHjg+wyCtoDX6mpx53bDn0JuVVC4NGSdtPHad5FQtEFuF6y3Yu9EGHswsoIrNtoD3nqsuSZR9WGwHTWLheTldKgpxhfJGwyH2Uq7BU8OFM+p4P1MD5spntMnCTZjc2RbS+uQfhTurjU1OTUvnqwQieChGYCRDlKbBb/oy58V44jJwMUdbXCpwj5RSXLFH3C45fQWKGAZDlGoQwlZ3annAKQiphpv4tvO6kAjsXSGKOhEJjczLEGjJUevAhtDSgWPL2niczQqUDxAIqCSo+wH0ErNH+bCRw+dpce2/8W1pz2ZvONa/rZoi24cNWX9dO17JC1UI53R0mmsETCO18Gx6tn+dRAq4SL4oX39VdVs6fKYCaeL3JY/EZoqod/Nq9YWItburS4YzClgn4j0J3RCd58yEYa7J+Pjpqj6Ak/1DXmkoWwDfckzwHLJEhU0aPjsfpMjTqrQU6AyQEJaLUtvlBACKOvso2u4lOkCO/VvgH0V/DGZ4bM+C6noL5KU5xA6DIFq7pvArz9DquEmsnB9igjRBoAYKTyi/+x2uwzkLOdUBcEq3I6brsRdB6rDFi5qWyCZ3IO4ADyzMY55RnZmQQNkHvdO7GBg1LP1ejAmz9AMJegr/zxjvT/wfz1k+6ZO9gNAJOpuKkHOET4n
 mQaaFxsQ
 8RXloY3raYGv1gua+ML3tAvonp6/ny9zO7uXTcz+rTRjwaVM3n9bG5eFzWRuuV52a+bVHLU7+hBmnlgTxZ0mqBVZXYecf5r5eODeTo5d1QVH6eriUNM+H9N1VLFGzgXtI3Fu+171dAXUkP36C/ooXqbEq98ApPc78k5FRlJwxVviHB1mi3OY2ymYdGukYSN0021WsIzSbcuDRLdYVZJD9ftsxJpzDb9ZrThQbiLmw+3fk3muzUm6mCvOeRnp35qkSYQPlIcI1nnQDAGIp09dzbnTQ16TS/JifVteCJOL4rTYwqC7uYtv8q8SIMM+MwdRkG8Y9soUUYERwKuY4IQurrqZsZqq6PlFX5VjdBOCSEi23vyFH8c9sZAM30QlaJaG4ac/kpnLCQ7zrCLN6YGnZ89qexiMzjDD+AfXkb+w3X+gTwr8vN1u3Lwc4jDG23sisO5m3WKRWGrWQN3XjhmuqXI6VB06QXqwde8gkEWANRDG25HqVvSXU3Frb7pn4ttXprRrIkX6E6E/DM2IYO+gWircQfFRhO/+cUNNxHZPjCXmULZKJ6xh4uI7pm/enezIZZbsdKbWfIJyGGBtHC9OWRxhH81w/G2dMeRNGEMM0IiyYxA5R0wYghWwox0ndvZ92OBKcjgdSkuilFBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vfio, iommufd and vhost-vdpa call iommu_map() with GFP_KERNEL_ACCOUNT
and the gfp is passed down to the drivers' page table allocations.
Specify SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Paths:
  VFIO_IOMMU_MAP_DMA -> iommu_map(GFP_KERNEL_ACCOUNT)
    -> s390_iommu_map_pages() -> dma_walk_cpu_trans()
    -> kmem_cache_alloc(dma_{region,page}_table_cache)
  iommu_map(GFP_KERNEL_ACCOUNT) -> arm_v7s_map_pages()
    -> __arm_v7s_alloc_table() -> kmem_cache_zalloc(data->l2_tables)
  iommu_map(GFP_KERNEL_ACCOUNT) -> sun50i_iommu_map()
    -> sun50i_dte_get_page_table() -> kmem_cache_zalloc(iommu->pt_pool)

Assisted-by: LLM
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: "Joerg Roedel (AMD)" <joro@8bytes.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Chen-Yu Tsai <wens@kernel.org>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: Samuel Holland <samuel@sholland.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: iommu@lists.linux.dev
Cc: linux-s390@vger.kernel.org
Cc: linux-sunxi@lists.linux.dev
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 drivers/iommu/io-pgtable-arm-v7s.c | 2 +-
 drivers/iommu/s390-iommu.c         | 4 ++--
 drivers/iommu/sun50i-iommu.c       | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index 1dbef8c55007..b544e5da237a 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -706,7 +706,7 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 	data->l2_tables = kmem_cache_create("io-pgtable_armv7s_l2",
 					    ARM_V7S_TABLE_SIZE(2, cfg),
 					    ARM_V7S_TABLE_SIZE(2, cfg),
-					    slab_flag, NULL);
+					    slab_flag | SLAB_MAY_ACCOUNT, NULL);
 	if (!data->l2_tables)
 		goto out_free_data;
 
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index f148f559ac56..f308efadc87b 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -198,14 +198,14 @@ static int __init dma_alloc_cpu_table_caches(void)
 	dma_region_table_cache = kmem_cache_create("PCI_DMA_region_tables",
 						   ZPCI_TABLE_SIZE,
 						   ZPCI_TABLE_ALIGN,
-						   0, NULL);
+						   SLAB_MAY_ACCOUNT, NULL);
 	if (!dma_region_table_cache)
 		return -ENOMEM;
 
 	dma_page_table_cache = kmem_cache_create("PCI_DMA_page_tables",
 						 ZPCI_PT_SIZE,
 						 ZPCI_PT_ALIGN,
-						 0, NULL);
+						 SLAB_MAY_ACCOUNT, NULL);
 	if (!dma_page_table_cache) {
 		kmem_cache_destroy(dma_region_table_cache);
 		return -ENOMEM;
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index be3f1ce696ba..51a30969dde4 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -1011,7 +1011,8 @@ static int sun50i_iommu_probe(struct platform_device *pdev)
 
 	iommu->pt_pool = kmem_cache_create(dev_name(&pdev->dev),
 					   PT_SIZE, PT_SIZE,
-					   SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA32,
+					   SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA32 |
+					   SLAB_MAY_ACCOUNT,
 					   NULL);
 	if (!iommu->pt_pool)
 		return -ENOMEM;

-- 
2.54.0


