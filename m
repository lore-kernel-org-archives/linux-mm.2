Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E43FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 06:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0AA6B0088; Tue, 28 Apr 2026 02:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761DD6B008A; Tue, 28 Apr 2026 02:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677CD6B008C; Tue, 28 Apr 2026 02:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 53C4B6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:06:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9319A1B94E8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:06:01 +0000 (UTC)
X-FDA: 84706928922.08.ADF21D1
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf08.hostedemail.com (Postfix) with ESMTP id 208C816000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:05:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LTuKEVkg;
	spf=pass (imf08.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777356359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UENmXrqV0minNvWhiDn/Fu3Vfd0TFiYhyAFS9+hB2Pk=;
	b=znW2/r39ApUEoLdIbRCZfZ7HXjOVOuW5nVEbfn6D8krLroF1tZir7TiyNDBSc0g+TIYLBD
	9osaljlFnJQ4ZPLDPkYPSIAxpaWyMTxLBPv/soAjc4k3L9EQi2piN7nKNetDkdcOLm8jRQ
	VO7bvSH0bJHvoY/ZwnxmODOb2YBlBuI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LTuKEVkg;
	spf=pass (imf08.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777356359; a=rsa-sha256;
	cv=none;
	b=hxuxIug7jgKgGW/XDi9E/a3aFn/tkAn3mRKsN+YRYOMRNly0vDPMxSDnrVnVk/nIbpI1fk
	7P9lyji2T3gbb1nEojC0BRkxapxg1hSAgvmZfCe9SW6/wVakXcFTkfEWp8DsXKNNm21nWn
	FGSnVA6YSQqheWfXnUMypVaxhZSNpU8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777356355; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=UENmXrqV0minNvWhiDn/Fu3Vfd0TFiYhyAFS9+hB2Pk=;
	b=LTuKEVkgrlno0kttPhZ4WAm9D+V9V6tQ/RstMHhIQQ78/H76gBDqvENFYCaadlKIduDlQxunEcoATgLYZdfJGyG+WDpOciOXk1uTGgs7UGTir3hv6fzkPEgr4FeC48gHlrfmRh89y9mLZQ4bRnu3Wjzx8qpPag2ZYFhJNnuJUSU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=feng.tang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X1tYxNo_1777356350;
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0X1tYxNo_1777356350 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Apr 2026 14:05:51 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Liam.Howlett@oracle.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
Subject: [PATCH v3] dma-contiguous: setup default numa cma area if not configured explicitly
Date: Tue, 28 Apr 2026 14:05:50 +0800
Message-Id: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 208C816000C
X-Stat-Signature: 3nfh8xtupqg53ej357ksdwxrydokz4x7
X-HE-Tag: 1777356357-149171
X-HE-Meta: U2FsdGVkX1/nUpFU0h5VzYJ0patOmpwvFeIxAqvqWlW98tDHwGjSDGzeSD1QbPClrIKIkZQCgdvH9IFEOS7Agy2EQD5pXb+7bQMkfiSqM32dc2PFPfLopY0b6WxrIKL7UggyMSkRO4BRwM0C/rvyhEuKPcUGSUilg45m+Xu5Zt67m8G8vc98yLs1ASP86xOT6qg/OkeN3tNW+MXxT0/z6qmk5Z1dgrAs/Nahh2VPe9d4VAs67cPjrgcdUlm0axY+C+xmIOK8pir3YNHKmgHDQIjre4fSPfya2FnbIDdtqnZShPyzfkr+9gCd+23nY3bUy2Qa89fNWiyrRSUmQfsoWNixcCLSpjrfynm8AR51JR53MzO0H8eO+y0Y1y3dCWJP+bnuel+9csx6qWoWkPbJaHjG0wk1XzULSofZRObk7Wx3Wn9t7WQkr1+h05hNDqYBZMoes4Z0YjEttkxkFMfD0Z9OZyyJJVeNqMBm22LX1TujK++NFz8JpWZrAf+Fy4nWmFdyFoYvGO08ZwR8NC7OK990yaojWpMwNlbx5skhqEvru0ZvF8/WJFKs0Lq0355jhnxFAw/JnjhGUnG4BMkMBISYqZ6ZACxWnbJkOkYmsVSAW7g0SMi1kHyNOjjS+NEoSze+cpJdPfVCyUkVBUX1s7V2Uo4BaAUa3sdvIwazlV2x1nfUlVrSZIRg+a+3MJsMHGIpR/TRUUvwpCY5gfw7u0WeFo+a0aWL5+e9GRuAWGmK15X4rbe13X1F0xsr+ri863mR/6HvFoQ33cAEIhDYNIUgQjThk4QNVNsuJd5z59SBwPDXIqvXewuXLBtxBMwASu/kbGhkjZhqftLkv92jZ0tfQykF2OVOCSiU3ibIbWV4s0KBdcHhP0Uh2wtN8Ruej6GJ/DchaZ91mvAtTCSLcnNHgN0yu/PyoiGRNRBdiHbHzGBi8VtHFFcT9BzjDouGGCFh4EtHJmCqEmY4wd1
 aNpvlOI/
 7PUfwJAL+cCxKoufU/daGNLhR68FGA1e7NvdDklyUOAmQ4y0DsfW1KXzLwOKM0V0zXsARWvQZ7One2LHUw3mL4r1mSZzTE8rJZh/pxpGpnznh9olpQWe9x4JAYCP5gZwkBjcWI91ONIj7FcCgzlwHwi/fNPU93FthxEbyeWYDnUXuaSmcoS4hLTppH6dGUu8bMK7KWUQbQJi6mq/5Yuj/vbDSoREdZ6BFrKMbP0dZm1boSWRm1J5EIETBje9O7iyQ+0E21gkmE3wdGmYu6ndZkiRS3f2tCL57wz1h43RpIZQ70nUBk0oRRGzxAEPMB0Tyon37doyZ/E6umIYbs7LN9wDOt56gHAthEzkKKvuwScgY0sM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There was a report on a multi-numa-nodes ARM server that when IOMMU is
disabled, the dma_alloc_coherent() function always returns memory from
node 0 even for devices attaching to other nodes, while they can get
local dma memory when IOMMU is on with the same API.

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
or 'cma pernuma' method) is not explicitly configured, set it up
according to size of default 'dma_contiguous_default_area', while
skipping the numa node where the 'dma_contiguous_default_area' lies
in, this way the default behavior of platform with one NUMA node is
kept unchanged.

To get the node info of cma area, add some helpr funciton and setup
in cma code.

Reported-by: Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
Suggested-by: Ying Huang <ying.huang@linux.alibaba.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
---
Changelog:

  since v2:
    * setup the numa cma are following default cma, while
	  skipping the node holds the default cma (Robin Murphy)
	* add cma_get_node() help and related code
	* add reporter info 

  since v1:
	* don't use the original way of adding alloc_pages_node()
	  before trying default cma node (Robin Murphy)
	* setup default numa cma area if not configured (Ying Huang)

   v2: https://lore.kernel.org/lkml/20260423095243.14239-1-feng.tang@linux.alibaba.com/
   v1: https://lore.kernel.org/lkml/20260414090310.92055-1-feng.tang@linux.alibaba.com/

 include/linux/cma.h     |  1 +
 kernel/dma/contiguous.c | 14 ++++++++++++--
 mm/cma.c                | 11 ++++++++++-
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1..acc9ecdf28e1 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -26,6 +26,7 @@ extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(const struct cma *cma);
 extern unsigned long cma_get_size(const struct cma *cma);
 extern const char *cma_get_name(const struct cma *cma);
+extern int cma_get_nid(const struct cma *cma);
 
 extern int __init cma_declare_contiguous_nid(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 03f52bd17120..ae6d856c5559 100644
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
@@ -221,6 +224,13 @@ static void __init dma_numa_cma_reserve(void)
 					ret, nid);
 		}
 
+		if (!numa_cma_configured && dma_contiguous_default_area) {
+			if (nid != cma_get_nid(dma_contiguous_default_area))
+				numa_cma_size[nid] = cma_get_size(dma_contiguous_default_area);
+			else
+				dma_contiguous_numa_area[nid] = dma_contiguous_default_area;
+		}
+
 		if (numa_cma_size[nid]) {
 
 			cma = &dma_contiguous_numa_area[nid];
@@ -255,8 +265,6 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
 	phys_addr_t selected_limit = limit;
 	bool fixed = false;
 
-	dma_numa_cma_reserve();
-
 	pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);
 
 	if (size_cmdline != -1) {
@@ -312,6 +320,8 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
 		if (ret)
 			pr_warn("Couldn't queue default CMA region for heap creation.");
 	}
+
+	dma_numa_cma_reserve();
 }
 
 void __weak
diff --git a/mm/cma.c b/mm/cma.c
index c7ca567f4c5c..3bbfafeaf6c1 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -54,6 +54,11 @@ const char *cma_get_name(const struct cma *cma)
 }
 EXPORT_SYMBOL_GPL(cma_get_name);
 
+extern int cma_get_nid(const struct cma *cma)
+{
+	return cma->nid;
+}
+
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {
@@ -511,7 +516,11 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 		return ret;
 	}
 
-	(*res_cma)->nid = nid;
+	if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
+		(*res_cma)->nid = early_pfn_to_nid((*res_cma)->ranges[0].base_pfn);
+	else
+		(*res_cma)->nid = nid;
+
 	*basep = base;
 
 	return 0;
-- 
2.39.5 (Apple Git-154)


