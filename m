Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36F0C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD9F6B009B; Thu, 27 Aug 2026 05:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95A46B009D; Thu, 27 Aug 2026 05:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD26B6B009E; Thu, 27 Aug 2026 05:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8B486B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:45:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 027F71C1AFA
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:34 +0000 (UTC)
X-FDA: 85146566988.03.1696440
Received: from mta1.migadu.com (out-108.mta1.migadu.com [95.215.58.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1CEE3C000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.108 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+ukIsy+fgBjJ9pyw3m6Wrt/p9UJVb6331RMPiSMDab8=;
	b=Am3ujvKPHT+pWP3lLiqQlAxn2G0bjWhakIGTfKHWzdvT8JBXf/FtmWYcijLVkNgBi3lT88
	4rAOLneOKQDO/m4ZHR5u1+pT+9K8dSQoUduOMNWgRsFBtQkUBs2ka4f9LzUbENvP9hCzfi
	a1CMo8EM/+Kd8yQQN7nZJFfe9EOtQEk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823932;
	b=M+CmrrkQXReOAJK7NnkabMwIKUUXMMTBmH+Koe2RnCDgtD6V6f6dFuDRA76XOq2ROj4LYZ
	h3jfdvOujmTKs0w3Ftvip9heuZBgwmuqOCHqDtAP3ilO/y7lzJ9uBNvYMIOFjf4f4IZI84
	WBLRGLoNur4gBvhHJddzGTy15oQbfHQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.108 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 54ef9dade49ec2a8;
	Thu, 27 Aug 2026 09:45:30 +0000
X-Mizu-Trace-ID: 54ef9dade49ec2a8
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 03/16] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
Date: Thu, 27 Aug 2026 17:44:53 +0800
Message-ID: <20260827094509.1016740-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1CEE3C000A
X-Stat-Signature: o7myrf7b74cws3zqk9xpykq6iffow87i
X-HE-Tag: 1787823931-485980
X-HE-Meta: U2FsdGVkX19eyaoeOPygJ3HgvBsxTQjxplhS8WpfTnhioMpIenMG5FP0Jyz+ox+RC1pMoQ6LSkdfyosfA065ATILaGSO8AssM5/NA9LitGhVO1yc68dC1cJGdI93wnY7P1DzqbUCuTaz5mM6/UtFZ5eOxXNnnwz222Yqq1Pl2f+yeFH2Sv9Os+IB0u5vDh84ghhtZOxl31LQKUbFcIFqHIw6KdwWy9PsQp+ndElm6CBCM+CH0ToXD4Cif4XmesZOesjo7W4pg3Mx/i8ueP/+yGOaC2WZvS320l8v5dc+OpNNjIjqBZJkbqigZSVq1kU+c4rCq0l80POzqkEcaUjo6lXx++0P6F61x2vTs35O14tVLc2q7StO/FhrTCc/ZoU1v9yYTRALLgIZNm3Rj+YpxXkwvwK4pgeB1uU/18T2Xo/jjQZtHWgkxVlIM1qZogKHJt+p3o68NSm/u2CMF7wI/AXZd8cHd5ctmGFWcAvpO85cc4ml8Ex5XehK8DPwgMztOIy6Is4ed0cVQI4YKYiipLMHW6H7RCXclR9LxaZ54gJxz3cbsPHMrrDJESLAtd5ffkcKrV0YTl3xlhIgee8dfYG2eMTnbZTn5lqDxFUkJFi/eJnAOMpDvUyLxb8ETzWGmkM24nVBIH7xsmg/gCPqTUOjrvpAGP4UVWktP7NoQjY8oyzJmBv7TA5Bt0xAZ3a8OCqnPgQGezROb6YqejXksLKAW+peMc4o98zAinWnau4dItayts+0oXW9bDJ+ECmpKEv2loCfQchJhbwmlki5bCXTfyhKc3vlzRzlX3SD3fZWTLEGdd1yFu1gL7dRrFwuBJtffCTx5FJE6fKJuPujBWjhdok53twGP8JhTO8PZmsh5qa1GgP8VaPlEdZAJ4ut5lfFRn/8FqBADvTCBnDgg3QjiipxNJFP8cI5vFJc7rxm86yNob97kD2LAYF6FrQqRdDEPC+ytVG01NNeQ7s
 m5XTmXEO
 3NOibM6Oa+9TMS/kbobUq11aPhgE65jXO6ayPXTWArqichM2lYsGyoG7Es0/3YcerJDkhlDYFL6FwXDmvYRBxUFyk1HPlXp/wJ9TWBclD9UESuUDv8vYfB5rCV/BEYozUaf+reoam7Cyo1o1EjxNpZwTPQkqJ081WWgCL5+5aDcYJU//DSsdI35/t5ctp6q8YkEo6LIRtBvH+Qy7RNw+7x0fKC2N3eyQm8aMio6czXAKAHrTEwRTglZMnjHPuZiUDq6SIOCLt4yPUBEc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add CONFIG_XSWAP Kconfig option (depends on SWAP && 64BIT) for
extendable (virtual) swap device support.

Add three fields to struct swap_info_struct under CONFIG_XSWAP:
- cluster_vm: the VM_SPARSE vm_struct backing the cluster_info array
- nr_clusters: total number of clusters in the xswap address space
- nr_clusters_mapped: number of clusters currently mapped (lazy grow)

These fields enable lazy vmalloc-based dynamic cluster management.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h | 5 +++++
 mm/Kconfig           | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 787fe463dcbb..35d357a393c6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -248,6 +248,11 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+#ifdef CONFIG_XSWAP
+	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for xswap dynamic cluster_info */
+	unsigned long		nr_clusters;	/* total cluster count for xswap */
+	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+#endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..26cf26a2c59f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -122,6 +122,15 @@ config ZSWAP_COMPRESSOR_DEFAULT
        default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
        default ""
 
+config XSWAP
+	bool "Extendable (virtual) swap device"
+	depends on SWAP && 64BIT
+	help
+	  Adds support for extendable swap devices (xswap) that decouple
+	  PTE swap entries from physical backing storage. The cluster_info
+	  array is backed by a sparse vmalloc area that grows and shrinks
+	  on demand, avoiding static pre-allocation overhead.
+
 config ZSMALLOC
 	tristate
 
-- 
2.54.0


