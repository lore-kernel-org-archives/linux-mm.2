Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D70A6C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82756B048C; Thu, 13 Aug 2026 06:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B016B048D; Thu, 13 Aug 2026 06:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22636B048E; Thu, 13 Aug 2026 06:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A00CA6B048C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:49:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2045414010E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:30 +0000 (UTC)
X-FDA: 85095924900.29.F324A4A
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2C2B0140002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618168;
	b=UcixBwbsOrt6+jo5tl8LJCbOcMR8GJCbX4W9YPb0PWS0MAkenJHipnzsE3lv49/ywCMjR8
	7dSg1wdz9w1yL8Rh7ugOE4ofZ58J7nyYNQuQhBNY37rvVPRq6xl5F6MEew106tGaJd/yL5
	9moVK0e2x7wAMnw5cBwc6A7XAV3AarY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wuhMHdChHPqxqxMY3U29p427PsLqT1xy5hZ2eGRBpM4=;
	b=HsFTf4KC7exTFIdMuPht3sv54lGbbJc7rM3UoGn7FWBBacJOzQq5bDhM3E7xLT+55Bhq+N
	H0WmGvSLssRRZXm4A2/Wu8ReoaVsUslK0zr3SoiVr9euM3Gchb8UZwmkULb5ov+EnXKpvF
	NYpksSHQpLxYoDbQRiy+h5SnA46NIRg=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id adb531c360a563a0;
	Thu, 13 Aug 2026 10:49:26 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 03/15] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
Date: Thu, 13 Aug 2026 18:48:42 +0800
Message-ID: <20260813104857.3450386-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C2B0140002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7kphmk7qzh9yfm7qc1i5razt48dhexw1
X-HE-Tag: 1786618167-956403
X-HE-Meta: U2FsdGVkX18gzWXEawuanQrRIkxUTuUOV/BNDnE80fau6/+GK9fuOb7GlUN7gu4RDi3UL9qCHT3z9rnlb+eS4869VG2CrZQk7naBgz1lk22+55FM8pTuhVjEiOAFA7E3wIcXhpvMpP91h1k79r+kKsrXeZvclLppuO70yDgeqqFO+iGDt1l7RlsK2KWPX4YBgqHLQjei1ZK8n/ZIr0jB8Jaso+6sbL5VhGxnIb37YRx+pMkaO18C4q9eN5lVk6wvbR1c2bPs0IYPSOcIYpC0LKKWRZy13Jwol4SE935ork0Gt7ACKingS+LjC8QOM8oIUfDOLPG4p3IERIKuoGwWAIxncJ0RUvZO/U5e/Fi5Uh/SzObiXT0ih6iePfdD6rrVyy+ORyxylXVac8xPbvKjBKou5xJqaiFjYNnpQ79OFsEN5e3AWtk2uQGkJD72Tz+mvboy4ikE5kPlZVjTrr8EQBhRB0QdAdITMxELs/kdBWR03VeRvodUUP6RKeK8bw7x7N1Vr/FjTrkhmU3B5hAlXY2fGWg0OMMknv1cb4SM8kSXwxHmaI6MRB3C0JebYNKqjVK6YNBf90afnUH8O//DmKVNIt/gRHMi3oLVJtf+m1woC+QX+wXRgo9HVE1uyvtIWWL9iCDV/bjGt/5w6c+OJ82xlNk6HAz130Bbyya2ZHUMJMkCttByKg91BFaYbT5Em3gfu6wFcKh5MupZuBwiTvEa85LYK2wgJev00uyrMP5ZW9M9M01S3LcTIrKzlLwks0mJXvblxFYfFg9KMap8BD0E9GnuW1I9L0t4Z6mT1UigIBEPXFCtzd+MtSg4lOa//xiZrb05BQrue69HEOkRwOC0QzK47uxesKg+dA3fio0dFvzYh4sfgD7+afaCl8ZADAeHeZdJt/TS01nqUlbLLYg/O5sG0BEI48sjf/Uwv0kaI92mfgkLKogEnpXLf5koqBq7IGx+C8QekFkYBZP
 3NEupyMR
 brU4U3ZI/lcAC1eTBjugsegAMbwWTBQUxIyaO4Rd60f13DxAGlEqf+1emXIRMKUAhIcOo+ac2MGrAZ1zehjuCL+IOrdtjxLxNOJpN925+IoF2ZNykH5vPC9GvKapXQ5XVw4OiJuUoy8vkxGqo00DHU21SYjN6Fx0Pyr9pRT0ec7S0IB9oqPvHIFtYr1IHZfvL8inBndO9w9zs6pYkh6Quubo4XBkD5pDZcVXL1iFkX4Ann7x13sqpzjdW1s89J+PisvjPd4vO6tuVm7Pr0b4xlUs0PXFbbHYmmUdIDRS0zJ1oXsu7xlpcKdcMn+CiDwuhwqiZVD8tNH3q4UXc/CZs6tHNBL5seDxFxdjiuzfsCgwOZzVj/zIBF8/PJ+W6iDehbRxYU3MSyzn9WGi5WEq5jDYv5IUCLr32p72f
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
index 12f1c63c15c1..7ffc62a3b2d7 100644
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
index 8a24c130d008..2b4007985c46 100644
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


