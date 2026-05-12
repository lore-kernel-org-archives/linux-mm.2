Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B3ACD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583746B0088; Tue, 12 May 2026 04:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534266B008A; Tue, 12 May 2026 04:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FBCB6B008C; Tue, 12 May 2026 04:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4686B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:55:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7D2A40417
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:55:21 +0000 (UTC)
X-FDA: 84758158842.12.020E03D
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf05.hostedemail.com (Postfix) with ESMTP id EFA7710000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:55:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="SgM/LpFO";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zk3RFEUB36HedEJNqnsLDwa9WLsP3/7x2x9nYChWeww=;
	b=dTirf97mnoZf4MuoVPv9XLjbv/rdCJW3deWzjElVv4xDiWNyw2Lu83SO5sLqLk1JMJ5uOY
	iKybAj142Skr907dcAfXHxWW0/S9+INH685BYqgKS/yqi7e5+5vfPDd3u1zTluO3kiQ9rH
	OZ5+x9Tr4oKzX4uJyJ6FCvisXjEV6qw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576120; a=rsa-sha256;
	cv=none;
	b=tss8FW0xP8kaBMCJtnlomkWx8UKO5g0mKGmh/XmRvm2uFpUfhodseywdL/rxwW3Y7n2J/8
	lypiMoiz/ArZQxgMXeLBnQtEbDEK1TfEuVArAeA9Ljen/892vAd9pwqurxUi044LpEAOHO
	4gGd7525orKlkcHBpboytEwSDHWNU3U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="SgM/LpFO";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778576113; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=zk3RFEUB36HedEJNqnsLDwa9WLsP3/7x2x9nYChWeww=;
	b=SgM/LpFOZZmL8aIjJD0lu5qwyYTk73aGGmGelqAljYa1v8Zy+0T35VIAcV3JsWWtvgxWZ3mPCPv7Rlp7o0bwZC/p1LaGFWg1GKEem/CHZ9eB/VzjJsl1Su6M0LYlMcj/G2NhQSgSiN1aaq+wfGSABsFdlGTi4AOAbpBif+34Ync=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=feng.tang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X2q2TIQ_1778576111;
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0X2q2TIQ_1778576111 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 May 2026 16:55:12 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
Subject: [PATCH v5] dma-contiguous: add kconfig option to setup numa cma area if not configured explicitly
Date: Tue, 12 May 2026 16:55:09 +0800
Message-Id: <20260512085509.83002-1-feng.tang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EFA7710000A
X-Stat-Signature: km5pgg11siq163ogeyahwi6gfuunndza
X-Rspam-User: 
X-HE-Tag: 1778576118-843147
X-HE-Meta: U2FsdGVkX19H7p54UlFkWvpvoGjmmkeSHAWpB/6Kb63GUWmFNJ6++/BUS28N6CA40TM908DFF8URKuM0uGYlhsgzfoh7vRhFZVrCrDqITcoSwA+WKlonwQHptRY7muPbanbuJysaBXNs0aMPyql/xMDYHMfWiMoAjAePaFD53GeN8cH86OOpp437ci9mV3mGPli3GjBpRf/xq5uCiXch1+YhJDqbv486BTvAnPc4eLqembYDgm1dnze7ccJZhw/6DoylY3jTdkPUo/9ZPZu6vSbyyCedhLq1LO0qC1JoNkOr5L1LvoZq7AE6CQj1LN0eyuzuQbtEOiG2m1gMnkVrTi9tuXAWIVmuM/r387jBWXUjFbPmULtifvU2WtlwrT8BLu7l3UYrg+r5kFQie0KPB1pZxAmHVfOhXju6hRZdbNUIVBh0R9ABG6qWqg5r0PPin9qgQoWHgBEEKnmMK5pNSTMctBUSSOIF+v5IYuH5yS80t7L/9PgwzUDxGD125g7x31gBTWNOgll+U19vo7MGFepq7didICebWWX8i8g/InaALujcZ73UNPuyB1FxW6Ko+j9SKb8lIGnH5IEs1TtT70sxIE0bAYOaZDzZuYUzHjb0yRXgqLx4+8xR3RhYyqjYvzMR0OShJckq9ltrteJC52XOaYOdty+Ajnv0GZsX+HpoYekge2hx3WTIODvKPa1jSkSTgxqg+3845+cm2ZxnSSEbEVDDgxGOFnn8sIZUd7QFfiSoIC1/VA77SHtsaE2rKOOuzaUeMCmWMtc67NsEfbs+jvR+osu5/cBERdHjKCb8NB0MISyXTjRrpfMOJ65xWtTcfeIcm57V/aYQqTMCFYBeS5NBObESa7oaEDBdQe9UU99sUJwgE0A2Q2UH8BpoOmQVSKSRR0zzbXvFTo3a/0CrLAAKb3cR1ib/xttQU59KNwkGph+lsJncD5hpUdcdgwKl+HppogxKIyX5ugQ
 ZBOslgIS
 pgAS5M/cYnyjZ3mvQKaWnlDTfrkRvrCnMMBF6kbScH5nEqfoJrQeUBqq/RYONMYPAb86AAg77UEVmkjLmzoTJ2Og0whqfZxCY+F3qCUpZA71Ee+2qjanjEhGkbXEcGtYmO0VChR4hGEPmX4hsJ+hXgCwuq6epmqEAilSP1PmcZy4Qe6+pMv+KcVv3N9UPxRzBuvFiAwh6izPpRi3xY161s3Pt9DTssKHPFMtTCdroFFjgq3o0RZ50lBUa9q5SfHWulcHLByledEe/+heFxKL7/ZDvGzDG0EuXhey0+XeKeZ2ADIcDwmmSuFF/NlN7xdyYJxT6BZF8ycU6N7V7mRc5gQbBneUa2WaYcnvdAcZMXLHV4G0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There was a report on a multi-numa-nodes arm64 server that when IOMMU
is disabled, the dma_alloc_coherent() function always returns memory
from node 0 even for devices attaching to other nodes, while they can
get local dma memory when IOMMU is on with the same API.

The reason is, when IOMMU is disabled, the dma_alloc_coherent() will
go the direct way and call dma_alloc_contiguous(). The system doesn't
have any explicit cma setting (like per-numa cma), and only has a
default 64MB cma reserved area (on node 0), where kernel will try
first to allocate memory from.

Robin Murphy suggested to setup pernuma cma or disable cma, which did
solve the issue. While there is still concern that for customers
which don't have much kernel knowledge, they could still suffer from
this silently as some architectures enable cma area by default (not
an issue for X86 though, which set CONFIG_CMA_SIZE_MBYTES to 0 by
default) for most Linux distributions.

One thought is to follow the current cma reserving policy for platform
with 'CONFIG_DMA_NUMA_CMA=y', that if the numa cma (either the 'numa cma'
or 'cma pernuma' method) is not explicitly configured, and the platform
really has multiple NUMA nodes, set it up according to size of default
'dma_contiguous_default_area'. This way, the default behavior of
platform with one NUMA node is kept unchanged (say embedded/small
devices don't need to allocate extra memory), while the general dma
locality is improved.

Add a new bool kernel config CONFIG_CMA_SIZE_PERNUMA to control whether
to enable it. Even when the config is enabled, user can still disable
it by kernel-cmdline setting like "numa_cma=0:0" or "cma_pernuma=0".

Reported-by: Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
Suggested-by: Ying Huang <ying.huang@linux.alibaba.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
---
Changelog:

  since v4:
	* remove the cma_get_nid() helper and use 'nr_online_nodes > 1'
      check instead (David, Robin)

  since v3:
	* Add kernel config to control this pernuma cma setup (David, Robin)
	* Fix a compile waring (LKP 0day robot)

  since v2:
	* setup the numa cma are following default cma, while
	  skipping the node holds the default cma (Robin Murphy)
	* add cma_get_node() help and related code
	* add reporter info 

  since v1:
	* don't use the original way of adding alloc_pages_node()
	  before trying default cma node (Robin Murphy)
	* setup default numa cma area if not configured (Ying Huang)

   v4: https://lore.kernel.org/lkml/20260509072543.69650-1-feng.tang@linux.alibaba.com/ 
   v3: https://lore.kernel.org/lkml/20260428060550.7167-1-feng.tang@linux.alibaba.com/ 
   v2: https://lore.kernel.org/lkml/20260423095243.14239-1-feng.tang@linux.alibaba.com/
   v1: https://lore.kernel.org/lkml/20260414090310.92055-1-feng.tang@linux.alibaba.com/


 kernel/dma/Kconfig      | 10 ++++++++++
 kernel/dma/contiguous.c | 13 +++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index bfef21b4a9ae..c9fa0a922cba 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -181,6 +181,16 @@ config DMA_NUMA_CMA
 	  or set the node id and its size of CMA by specifying "numa_cma=
 	  <node>:size[,<node>:size]" on the kernel's command line.
 
+config CMA_SIZE_PERNUMA
+	bool "Default CMA area per NUMA node"
+	depends on DMA_NUMA_CMA
+	default y
+	help
+	  On systems with more than one NUMA node, the selected CMA
+	  area size will be also allocated on each additional node,
+	  so that most devices may have benefit from better DMA
+	  locality without an explicit command-line opt-in.
+
 comment "Default contiguous memory area size:"
 
 config CMA_SIZE_MBYTES
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 03f52bd17120..42227c823893 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -136,6 +136,7 @@ static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
 static phys_addr_t numa_cma_size[MAX_NUMNODES] __initdata;
 static struct cma *dma_contiguous_pernuma_area[MAX_NUMNODES];
 static phys_addr_t pernuma_size_bytes __initdata;
+static bool numa_cma_configured;
 
 static int __init early_numa_cma(char *p)
 {
@@ -164,6 +165,7 @@ static int __init early_numa_cma(char *p)
 			break;
 	}
 
+	numa_cma_configured = true;
 	return 0;
 }
 early_param("numa_cma", early_numa_cma);
@@ -171,6 +173,7 @@ early_param("numa_cma", early_numa_cma);
 static int __init early_cma_pernuma(char *p)
 {
 	pernuma_size_bytes = memparse(p, &p);
+	numa_cma_configured = true;
 	return 0;
 }
 early_param("cma_pernuma", early_cma_pernuma);
@@ -199,6 +202,12 @@ static void __init dma_numa_cma_reserve(void)
 {
 	int nid;
 
+#ifdef CONFIG_CMA_SIZE_PERNUMA
+	if (!numa_cma_configured && dma_contiguous_default_area
+	    && nr_online_nodes > 1)
+		pernuma_size_bytes = cma_get_size(dma_contiguous_default_area);
+#endif
+
 	for_each_node(nid) {
 		int ret;
 		char name[CMA_MAX_NAME];
@@ -255,8 +264,6 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
 	phys_addr_t selected_limit = limit;
 	bool fixed = false;
 
-	dma_numa_cma_reserve();
-
 	pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);
 
 	if (size_cmdline != -1) {
@@ -312,6 +319,8 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
 		if (ret)
 			pr_warn("Couldn't queue default CMA region for heap creation.");
 	}
+
+	dma_numa_cma_reserve();
 }
 
 void __weak
-- 
2.39.5 (Apple Git-154)


