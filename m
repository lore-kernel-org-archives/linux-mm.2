Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE45C44516
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B758E6B0093; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26A06B009E; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950576B009D; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54A676B0092
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD1A0120197
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:30:21 +0000 (UTC)
X-FDA: 84994875042.27.E330F15
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0C85BC0013
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:30:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EHxBUtMQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3-upYaggKCI00rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3-upYaggKCI00rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYdU4t2+gE6AXuv8NtGQXs6INIroF6XnwJU0+W2hmSY=;
	b=klzE4CS5t8X+E1RowixDdcPEFNMx/2XEdY+y6rXHn+WisnSIvR6Se3RoRCoNmyMv1prVnC
	nlCOCB8CrHInfrBKF9XkbB1IXvuLYCmDjT+AZCyjIWO2Dtw+eNABLRfiv+xoua0rS2w7yv
	byGH8D09Jy1H9wC91WfsMGx4RzvJFNQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EHxBUtMQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3-upYaggKCI00rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3-upYaggKCI00rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784212220;
	b=ij3qKRU8UTiiY0dIV6faDmkMzigVJv6Fc9rlvxlF+PmOuADz7iBrYzF/90JIcaxVfAPT49
	cSRr+pesnFlRhVm2djl8fgFM+D8+QpgxPz2qUXDy+e/JCA5/8z+5uOFuEcb4knS5vFLiy8
	qTq7ycsewI4pSysnISBZfxnmiDNc7Ko=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c15d4bd2afeso669942166b.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 07:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784212219; x=1784817019; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pYdU4t2+gE6AXuv8NtGQXs6INIroF6XnwJU0+W2hmSY=;
        b=EHxBUtMQUa9Anqjf5nyJBCboOoxX1QcYDXZtolQhwOBEQ0M5QMgXDC4jo6NV9S+6fk
         Wm6c/foSBjqrIB1lxmqMj0CxzLxdm6i9MedTpy1DBXjMMRvlzLN5JRiAF29DeyemBQ8O
         ZvHevVVRJGKLFH4DN6M70Po2ljzDUvqLm2xn+AU+GF3GeSFnInOJshR1iywQslHPMtIC
         zOzVW2M9mG4Dp/4vxb3SIIPNwgOq8a7bdpfjbemKbdOPG69qdOjU7WIrPqXhUn442Jcj
         L5gVvJfzj6wskCd2TqeVGnR4wb6TSLPoRCBUi0kznI7SbP4CFhUfyx0hC5mNhD8YXnz4
         5Z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784212219; x=1784817019;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pYdU4t2+gE6AXuv8NtGQXs6INIroF6XnwJU0+W2hmSY=;
        b=OhiLaoDt4U0hxCDCSmL17rlFQZa1e2HWuYFrA1U6UDspyUq3kU5htdyh0FdLBJil5u
         piHrA0xXtndT+z88WGPIW1+SA6284UuUvmSRshyZDcYaI7Qx78UPd5hGgN95yKSHcjAh
         9Z6Nc8fgZGdDwHyJpbZ/9xQmOF/AwpKPQq3c7XzLDM+HJr+m611ingayp7cw0gmGjqle
         93XEghL37YCk737cB7QuMvIjeT8bOURj5faI4sGwoQgBhD8/J6mqBS/5aTjGZSxw/FzV
         3ENLCg5jjzVbwrPZXeJWISPxK/s7GdSyLPozknpYVtepZgqXMdf85EOoyghqG6RaEBCN
         kGSA==
X-Forwarded-Encrypted: i=1; AHgh+Rr1Mit8aGoLrqBgRGRzFpmCT9GDHnxCt6Z5PlqB/KVyeSE0Qizat1KUy9PNeEbA0CW0DxupzSfWGg==@kvack.org
X-Gm-Message-State: AOJu0Ywv/RVqT0tLBfPzuYU9ERbU4idMkkDOuKhLwWBeU/Ue5aAC+ls+
	CMjvodNhYdeyh7Ckl6XeLQgY48EQ/0JEN3OCAuJ7GR3+2bGqf3H/PQazyzo8QQcdTECH8uzVAB0
	RVYETucVZ5Qw8og==
X-Received: from ejfz17.prod.google.com ([2002:a17:906:ad1:b0:c12:6e77:2fb7])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:a710:b0:c12:6584:c1 with SMTP id a640c23a62f3a-c1667a6921dmr585573666b.40.1784212218007;
 Thu, 16 Jul 2026 07:30:18 -0700 (PDT)
Date: Thu, 16 Jul 2026 14:30:11 +0000
In-Reply-To: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
Mime-Version: 1.0
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260716-folio-alloc-cleanups-v1-2-5363b8e92d33@google.com>
Subject: [PATCH 2/3] mm, treewide: replace __folio_alloc_node() with folio_alloc_node()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: n6o97xfgmytr3bxqcdc3fpxo449irziz
X-Rspamd-Queue-Id: 0C85BC0013
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784212219-405547
X-HE-Meta: U2FsdGVkX1/60te9x/yeKdzu3OxMNzyP0x/ZzLvPh1nMZbgFkf+7uV3OQ/MLJMMer0jqVL8AjhhJ03A3SmfgL3kXgns5ivyHIqztTR9PzYttzWLrPdNNMxmsjyndTYveAZ03geRvgL1D3eIZZuxzUIkGojEv/s2A0R3AvBZMy4LazPn31XdBQdslJ9vAtsluBSO7NC1sdrs//F4jolNCF9moj18uwnD1AGIHd78gNpdnR/MHgeiSaeNqkcmvS8uVsnrvNqTMVM6pDM2lPT0MBae5z1Le4bVcoc9Is4GJdmKHNt1VtSLj92GewH7R5j0OdUwB0TbU4c5odk4Q6yHKYr6amnBfWnfSCawmomwoZamj3Io5Iwt2dSXXqv1KNDnMIyRa7tr1dpuJICinA45ZWnELbzDI5akI7VwLOX9sEAhvo5Myl7g4Kr/awkjtt4OExLLl/FlZQwqGnmQNDjnNTsV8sfOFfm9sdPhi39P8ULgEUH5yicdzBwdG/LGKLxjKxZzpUQGMA0dnaL05jvVKF8ax11rWz7kF3qEWXnuUyyhEAYJ4i4OO6IHxlxx4Kt9KClGWM21pZpMboEPWSrPAKBUfEVJgQZ49j2R+ZVP+RgvlAM88zCn9JfzIufMyb4XVSDk6rOnyhQRYQBclaq/6BgMqxAxaje34EC89EyUDuzrGuML1IJem5ewtbH4e+YJni4jn4NpvJWkjQhuIL7hkMl0PyQ5S+JfrwXI3fGrjxa3QrthP+LKoELYy41ZULdI6K29BVf6xpTpO1CRiweZMZWIfjSAiz8Zw0+jI9qtK0AzqYGnyPNILzBDok+8q8Ybh/+yQt2Jxs4pNYqZCe9GlGD4cRvhNfle7UEODsbllSnvFmhiFUJNBV6O07St+1RbdNgr3iRYiZ2rWPUvhlto3ur+2udBZrqVujrlFADIByB24kLvKSeQrsC7jyzsHt4obW16hXqalDWHwTI6AFZJ
 jZhpyqVM
 xRnBwfOfR9v54crkSMS0XJ+C6p87NfXYQOnqNUel4u13bHlx3KSRGC3gfLfdqiQdlmNeIlUAycxJwHnxqnEBS4tlWg0O00TDDIp3Mcv12aD9qDL62c0m7dBBXCzXaYBZdaaLCkA2YvDgjAOSs4MAaPvINppVqpxY8Z85pB+A7MUNKU5UOgSvabuU4gDVOE0bwCtPoTGW3Nj1FzOXEjbNFJq13CzRNRXOauSMBZwsQbtRRrIAAGjH2iD/sm4Tljvf2XvlSuH1U3plAFiJKNE1dWyqCljL3MR/RmexpY0ZJcsNK/ZKY0GquNfyCfIe1lFqeWJfbVLZ5WiEPIt24vcZ65ONiszOmRteN6rBgj4/DVTgRuiMH1pPf5+S5NiSvYhmWkyemMZjR8h5U3MIp5fk8bdROTjL4psvDZzKABQmuDHAamQZBA2WPtV1SP/bWFNqnOI99X+uEUQ08aRwr07aax5ERiuN5Ef4Ov5xhTk0embXimiE4Cg9Zxq1gvKVy9F1s3fribYd6rehvqS/L1iwx1Tsew62RkiQqoTdRyJm6tshAi2+6hEeFIMepALy3IVkeDRmXiDs+AHvobqq/CepkEcOzD8G4rizLfiPoxc5emEdk/I87lA/BYLvAhTW9zgNSKeOZ2Jn4YCpf/jH9pVL+hfrkYfOyajMVfgRkhjpcUt4Mm+UO+55/M6kJLAD2arjzjK/mz4AO9M5EloY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 5b584d2d22dca ("mm: remove __alloc_pages_node()") removed the __
variant of alloc_pages_node(), after users had been migrated off it,
since it just complicates the API (requiring users to handle
NUMA_NO_NODE, or risking hotplug bugs) for no real benefit.

This patch brings __folio_alloc_node() into line too for exactly the
same reasons (including the ulterior motive of freeing up the __ variant
for use as an internal API).

This time, it's done as a single patch because A) the users are fewer
and B) folio_alloc_node() does not already exist like
alloc_pages_node() did.

No functional change intended.

Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Link: https://lore.kernel.org/all/ed4572f4-0074-45c5-993d-7b6533eddc31@kernel.org/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/iommu/iommu-pages.c        |  9 +--------
 drivers/irqchip/irq-loongarch-ir.c |  4 ++--
 include/linux/gfp.h                | 12 +++---------
 mm/filemap.c                       |  2 +-
 mm/migrate.c                       |  2 +-
 mm/page_alloc.c                    | 17 +++++++++++++++--
 net/sunrpc/svc.c                   |  2 +-
 7 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 3bab175d85571..47e0759f0e0ae 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -56,14 +56,7 @@ void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
 	 */
 	order = get_order(size);
 
-	/*
-	 * __folio_alloc_node() does not handle NUMA_NO_NODE like
-	 * alloc_pages_node() did.
-	 */
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
-
-	folio = __folio_alloc_node(gfp | __GFP_ZERO, order, nid);
+	folio = folio_alloc_node(gfp | __GFP_ZERO, order, nid);
 	if (unlikely(!folio))
 		return NULL;
 
diff --git a/drivers/irqchip/irq-loongarch-ir.c b/drivers/irqchip/irq-loongarch-ir.c
index 21c649a89a706..427f7fd3cad42 100644
--- a/drivers/irqchip/irq-loongarch-ir.c
+++ b/drivers/irqchip/irq-loongarch-ir.c
@@ -384,7 +384,7 @@ static int redirect_table_init(struct redirect_desc *irde)
 	unsigned long *bitmap;
 	struct folio *folio;
 
-	folio = __folio_alloc_node(GFP_KERNEL | __GFP_ZERO, IRD_TABLE_PAGE_ORDER, irde->node);
+	folio = folio_alloc_node(GFP_KERNEL | __GFP_ZERO, IRD_TABLE_PAGE_ORDER, irde->node);
 	if (!folio) {
 		pr_err("Node [%d] redirect table alloc pages failed!\n", irde->node);
 		return -ENOMEM;
@@ -410,7 +410,7 @@ static int redirect_queue_init(struct redirect_desc *irde)
 	struct redirect_queue *inv_queue = &irde->inv_queue;
 	struct folio *folio;
 
-	folio = __folio_alloc_node(GFP_KERNEL | __GFP_ZERO, INV_QUEUE_PAGE_ORDER, irde->node);
+	folio = folio_alloc_node(GFP_KERNEL | __GFP_ZERO, INV_QUEUE_PAGE_ORDER, irde->node);
 	if (!folio) {
 		pr_err("Node [%d] invalid queue alloc pages failed!\n", irde->node);
 		return -ENOMEM;
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index e4e974a6e5f90..572605d84e30e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -251,15 +251,9 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 	dump_stack();
 }
 
-static inline
-struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
-{
-	warn_if_node_offline(nid, gfp);
+struct folio *folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid);
 
-	return __folio_alloc_noprof(gfp, order, nid, NULL);
-}
-
-#define  __folio_alloc_node(...)		alloc_hooks(__folio_alloc_node_noprof(__VA_ARGS__))
+#define  folio_alloc_node(...)		alloc_hooks(folio_alloc_node_noprof(__VA_ARGS__))
 
 /*
  * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
@@ -282,7 +276,7 @@ static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order
 }
 static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
 {
-	return __folio_alloc_node_noprof(gfp, order, numa_node_id());
+	return folio_alloc_node_noprof(gfp, order, numa_node_id());
 }
 static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 		struct vm_area_struct *vma, unsigned long addr)
diff --git a/mm/filemap.c b/mm/filemap.c
index 0dd8e2a15d746..1cf91970a6850 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1007,7 +1007,7 @@ struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
 		do {
 			cpuset_mems_cookie = read_mems_allowed_begin();
 			n = cpuset_mem_spread_node();
-			folio = __folio_alloc_node_noprof(gfp, order, n);
+			folio = folio_alloc_node_noprof(gfp, order, n);
 		} while (!folio && read_mems_allowed_retry(cpuset_mems_cookie));
 
 		return folio;
diff --git a/mm/migrate.c b/mm/migrate.c
index 222c8c15f782f..b7836b02f32db 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2682,7 +2682,7 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 			__GFP_NOWARN;
 		gfp &= ~__GFP_RECLAIM;
 	}
-	return __folio_alloc_node(gfp, order, nid);
+	return folio_alloc_node(gfp, order, nid);
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 37a3c1c00e169..86922270df157 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5435,12 +5435,25 @@ EXPORT_SYMBOL(alloc_pages_node_noprof);
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask)
 {
-	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-					preferred_nid, nodemask, ALLOC_DEFAULT);
+	struct page *page;
+
+	if (preferred_nid == NUMA_NO_NODE)
+		preferred_nid = numa_mem_id();
+
+	warn_if_node_offline(preferred_nid, gfp);
+
+	page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
+				    preferred_nid, nodemask, ALLOC_DEFAULT);
 	return page_rmappable_folio(page);
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
 
+struct folio *folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
+{
+	return __folio_alloc_noprof(gfp, order, nid, NULL);
+}
+EXPORT_SYMBOL(folio_alloc_node_noprof);
+
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
  * address cannot represent highmem pages. Use alloc_pages and then kmap if
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index ae9ec4bf34f72..74350a2e07036 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -711,7 +711,7 @@ svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool, int node)
 	rqstp->rq_server = serv;
 	rqstp->rq_pool = pool;
 
-	rqstp->rq_scratch_folio = __folio_alloc_node(GFP_KERNEL, 0, node);
+	rqstp->rq_scratch_folio = folio_alloc_node(GFP_KERNEL, 0, node);
 	if (!rqstp->rq_scratch_folio)
 		goto out_enomem;
 

-- 
2.54.0


