Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F12CCD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 07:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96CC56B02FC; Sat,  9 May 2026 03:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945336B02FD; Sat,  9 May 2026 03:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882526B02FE; Sat,  9 May 2026 03:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 773EB6B02FC
	for <linux-mm@kvack.org>; Sat,  9 May 2026 03:26:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DEE51C033A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:26:01 +0000 (UTC)
X-FDA: 84747047322.13.4025D62
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf26.hostedemail.com (Postfix) with ESMTP id 02870140005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:25:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ISb7nnde;
	spf=pass (imf26.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778311557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Zz9dljwMnRAVIrIM8dQvn0hpqZlwAvACimR9yDAo7Rs=;
	b=BlixU/mrEZjtu5iuNl9O+s35cxfFUvjLm8BkPXHjXxJjOzLRFk0T5tmEiD7CtVmrwYbND6
	TPCS6WjAZOcU/5YsssapLbx5U9UQyEA2mx1DBGtaR9CexO9CTpkrrFV2lH8NF9L0KtCg+z
	FCh3267pIq216H+Ht9r/MWH1GW5TNF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778311558; a=rsa-sha256;
	cv=none;
	b=u+qY8R987EBjrQ1RPHpypwmaghQywvPQgbLaKUdlzDydPEpLRIvQ/gdogwtahpQpC5RR87
	5+CjR0MurudRR64oozWHqU2vNLwDoO8msa3eJDWiz7HTgphn74LoO0OFzVIIPDBcg64v0N
	fRCcWuxxXcOcSYtHpWLJ3ZGX7yiKb9w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ISb7nnde;
	spf=pass (imf26.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778311548; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Zz9dljwMnRAVIrIM8dQvn0hpqZlwAvACimR9yDAo7Rs=;
	b=ISb7nndeoKBs75cwKciPnj1bDbgwQ2a+CEV3mZJG1z612xtHTDzzvIOSFvAksNWix7PR148FNmspwXzG/oibYYyHbqDGiCq1yMrEpeUEcFQW0GLR2/QQPwzuquPA5eiDktDHUcH1KlFoL/XlmJt0TV1/ZQAHZDCsUsLADLtFGAQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=feng.tang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X2ZrJg._1778311544;
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0X2ZrJg._1778311544 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 09 May 2026 15:25:45 +0800
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
Subject: [PATCH] dma-contiguous: add kconfig option to setup numa cma area if not configured explicitly
Date: Sat,  9 May 2026 15:25:43 +0800
Message-Id: <20260509072543.69650-1-feng.tang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02870140005
X-Stat-Signature: t6ohp9r46ubh84heswh89axokikotr18
X-Rspam-User: 
X-HE-Tag: 1778311555-996787
X-HE-Meta: U2FsdGVkX18z0BbxzhisAFxTa4/W0BorWTeLoUfWpF9MkahOejMZbRrxkkl9vTwpP+YJPgd7Wuk/kHIqUE2Sr9FcWLLz9H8+yOz02KzNqZ3OQc3xM9Rq8QF5JhoGopJkWWqhpY4ZaFzs8hTlmZX5X1F0SR9z2QW3QYlyPYbR2sS1EB+tKNeac3td0oAY9+eH5QfmhlqyKvg435U5gmPeEW0D8qIojZT2OXGwV0fDjoVc6f0gYwuaJxacQ+BPJqnSPpTIpD9FUaSxeQqZNyMbZuc4CQPUQFlGthHyzRvxQ8KPUcUSv2iuw/mQiUiPt75oek5c4kaOwdORfZPPsgNF44wCUtlRLBYNlG5rOXyOiFfDPf99ukJ82MxubK4aiSV8Eo4Hm8YvieGSOwLYgJlGDbkFrc8516xWjyCjxm77XpGHCkgKgN46E1o6Q5w3FLSUyoxhWcpVF8sla+YqSzV+gNEUvCYnPeFwk/rZvajAiY+6TUr6Zalj7pB2BZDMkwaSEN2qlQHHMStGn7McS9u6192fxL+oXjRV58kearFNcoiEeCBstnU1wYkGa+9qgX6hua1Gac5DZraCT5UfLl0S6JMjIKLSfRyrAZSS87oVmD4szYasA6eOrW8mFhOFTE/mJokkfYtoKUJPPH74jNfsbENqL47/+mqBqEafWqpPyuWrFoZ83LxpAfZxVX1Ub298DDREngxSfYyE2t5gF6YudVRWIg6QMUYst2b3siTL+keW055jvoRex8xsS3Zqiy5dwPrURtH4VIid5gu1y+vIdGOCiv5rxN7f70tmxtOoLCKVxcpXCth+khiSG2H9wK733YQFbTqvwrrjRMuHdRup8Jz1bWbSpWgYOxYffuQ9R7NQocjatwYjEFJ/WwLUrgq5TcjwwcoCYbWDSzExWeMwd6GG3YENEQZrxg7W1RwRYSlhjsPzSTqnQ4Pu8+SthMEFhuChlqYMsxvouZOoENc
 bgpIko6n
 P1IQ7OShCgQ1jBQ/L3WDb8MGxuTE5LY65wZoTwfF38BIubhao2vIufLEI3sJXy6Wze2YAZEwXdUiVVHgkRVb3Hxq8WDErVcOkhAUYuNvdOt08LUMTGAamUTnsm55cDmIVAGD0JWEcnAjIHDx6cnN57oZr2l0hYsssdSoOhgcjA+9aDq8rcTWHCQeWecF1tHQt0Cjv8JVHZKsSuI4QV3fjVbKq/N0GNBedZk4dUNQKywKbYp8iJrIvbgjKQnk6nmVWgH8GC/X5pwaiQBGAswofw3TwJJGHMGdUXPbOK51t2TkZQnwQpKAprJavwTeIkzfcK+vtXPXZH1JKTWCMPOdGXs0ztYM2+jABtkkBejLqoPIsaPk=
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
or 'cma pernuma' method) is not explicitly configured, set it up
according to size of default 'dma_contiguous_default_area', while
skipping the numa node where the 'dma_contiguous_default_area' lies
in, this way the default behavior of platform with one NUMA node is
kept unchanged (say embedded/small devices don't need to allocate
extra memory).

Add a new bool kernel config CONFIG_CMA_SIZE_PERNUMA to control whether
to enable it. Even when the config is enabled, user can still disable
it by kernel-cmdline setting like "numa_cma=0:0" or "cma_pernuma=0".

To get the node info of cma area, add some helper function and setup
in cma code.

Reported-by: Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
Suggested-by: Ying Huang <ying.huang@linux.alibaba.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
---

In v4, the cma_get_nid() code is still kept, and if people really
think it's not necessary, we can use the "nr_online_nodes() > 1" 
instead as mentioned by Robin.

Changelog:

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

   v3: https://lore.kernel.org/lkml/20260428060550.7167-1-feng.tang@linux.alibaba.com/ 
   v2: https://lore.kernel.org/lkml/20260423095243.14239-1-feng.tang@linux.alibaba.com/
   v1: https://lore.kernel.org/lkml/20260414090310.92055-1-feng.tang@linux.alibaba.com/


 include/linux/cma.h     |  1 +
 kernel/dma/Kconfig      | 10 ++++++++++
 kernel/dma/contiguous.c | 16 ++++++++++++++--
 mm/cma.c                | 11 ++++++++++-
 4 files changed, 35 insertions(+), 3 deletions(-)

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
index 03f52bd17120..6388ebbbfebd 100644
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
@@ -221,6 +224,15 @@ static void __init dma_numa_cma_reserve(void)
 					ret, nid);
 		}
 
+#ifdef CONFIG_CMA_SIZE_PERNUMA
+		if (!numa_cma_configured && dma_contiguous_default_area) {
+			if (nid != cma_get_nid(dma_contiguous_default_area))
+				numa_cma_size[nid] = cma_get_size(dma_contiguous_default_area);
+			else
+				dma_contiguous_numa_area[nid] = dma_contiguous_default_area;
+		}
+#endif
+
 		if (numa_cma_size[nid]) {
 
 			cma = &dma_contiguous_numa_area[nid];
@@ -255,8 +267,6 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
 	phys_addr_t selected_limit = limit;
 	bool fixed = false;
 
-	dma_numa_cma_reserve();
-
 	pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);
 
 	if (size_cmdline != -1) {
@@ -312,6 +322,8 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
 		if (ret)
 			pr_warn("Couldn't queue default CMA region for heap creation.");
 	}
+
+	dma_numa_cma_reserve();
 }
 
 void __weak
diff --git a/mm/cma.c b/mm/cma.c
index c7ca567f4c5c..fba5fc9c004f 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -54,6 +54,11 @@ const char *cma_get_name(const struct cma *cma)
 }
 EXPORT_SYMBOL_GPL(cma_get_name);
 
+int cma_get_nid(const struct cma *cma)
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

base-commit: 70390501d1944d4e5b8f7352be180fceb3a44132
-- 
2.39.5 (Apple Git-154)


