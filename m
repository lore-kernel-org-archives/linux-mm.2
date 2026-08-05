Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6248DC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C77A6B00A4; Wed,  5 Aug 2026 03:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778696B00A6; Wed,  5 Aug 2026 03:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E0B6B00A7; Wed,  5 Aug 2026 03:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 461646B00A4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:54:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD7DFA0E72
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:17 +0000 (UTC)
X-FDA: 85066452954.29.ED16EB5
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id E2E7C40004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MSUvCXlN;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916456;
	b=77uOT/96N1L2IEwJTPd4PDlLo9Q75W8HilRAnCRhXWG5R2O9+XK+IMj2Tw3bIH6RchfM7Q
	S+KfOkHjIGpNs944Tc3OzXb14Tm6yGjVPc3SupbMEcucbzN1YodtAKaxJSt40JDCJQEbz2
	9bnF4PepEbgES9D1TXUMkCYi0Ew+S34=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MSUvCXlN;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vyg1JuKKGQsuDU1bKZ0uj2oDV98R+6DJe0buLRSbuTU=;
	b=0YW306sBncqCGzsiUqw+Kk/rnUcUzAEKymmy+cyondipwXbXSgsue6T98jneR/8WrBjEW+
	XIbyw15FtXgtjhhJeqK94XLhej0WAxZ4R+KkdSn4/xIqAGFlNBp1ETnao7Y3JqwSKvypX2
	I1gHmubitRFVYF29YSsdMGQ5bGXTcQs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vyg1JuKKGQsuDU1bKZ0uj2oDV98R+6DJe0buLRSbuTU=;
	b=MSUvCXlNL2jJBQKWRW6MwT/fPVE0vP3PeCSPlPH7WhqywWqLqS1Xh114SiWC01cikNT09/
	vfXD2m/xesXSYNU3Uzfu6TaN8oGfy6pMdMom1JUDyeE9I7rEKk2LCr72CVqA+BGcdQoSY6
	xBeD/z12DtBqmFC/8ZqDvGdWQfznWFU=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH v2 02/10] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
Date: Wed,  5 Aug 2026 15:53:25 +0800
Message-ID: <20260805075336.3579395-3-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E2E7C40004
X-Stat-Signature: zodo7bywfny1szqz3ceh4e1xitrbojrx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785916455-9086
X-HE-Meta: U2FsdGVkX1/I7G8jy1igAJDRA6g8h2+R5g/ZXRisqjZhbMievk/YXFZ1ZqZwgq/O/9+x+POA2xpxgCxq9oSfJe4FfbEisBOtIwC6Jumg+ioLONrCzmUSRGJ065HXvU757COrPyVXwtt3gwuKcJAQ9QV4k8PRKIf52zWj9BAgi4aOKlVkOP1V31VajZJKlDHo6eVCqduA3GyS7Net30pKNuKZiizJzyneWUcfIx5fMpu6zWOzzIhUortLacFOwM9fPu8clzhnnSHmQaX4aBNzkUnVyOGy8GqT6HJla6KcV4XnP18WGkLlAFrC5eRECPlSw6smhHqtvLCv9Kzbuy8ZbUTEHUzO+QujzP87OKHjiPRh0+Tws2+98zOB8XCVN6qrlRpPLSlCCOKQZ8EGaqBvr+EryoWJInR1zA2Qj2TNVpr9N17cIz3Q9da9B9KM8RrFuDgqF283V8+hnMjKyFet0KsgZ0fIVJl8d/6UXMyNdDr33vo+Tu7nvOF+rSqvkwa6TJ7wz8Rz2QQ/lB+/Yk897Ixe7CwS2vXijF/ATcWMr2FtXsQs1hT68Mlq1w+Gx7hwrnmhM/oXUBN1+Cc9ozeWvhKaL8PpYIR2yAXcs7LDjwuClFmIz9S1f9b3ku1AjA7o+BwrZsBUOfmhAoVh2a++DecE9a3/bjB39g9AeVEKsFuM4yvVeD+Ym1WJMzrW9X4kdd5A2ikkaxdOmIFuiKlnVxZadjYec/wOTnOx/prySfvVEYLZXTLnLXG+KecvfsrB8b76xypXa5aKpUzIew1bCZSBtN5dm+WIv47DIDT6JM+vilBMCkPddKCUhXNSkEXzYrYBvbmJll0NVwDF+m8dH5SElUvLJkU55cWODqEEHib/A8rlBQXn8NzN2nHzHPM660DKYzW3qX9DawIiL0Hha2prEGW97qme9pTAdVo9ymCQVEoClSWy6F4LULLmnPWnF3TaHCdwhGMeZE7YOQ+
 uBm9yaXA
 BYZSfWchbVJa45JaoVaFOFhO5sGWPx4t0umySSQ8hiXCITKac/RSZVp5AqmM8DUQ9XOBsloFQa/T0/ABhIYRoUlT5n/Nc24jmx1NKet/HR9j1aEEyxKO+vfyE+4a2b/V3VdFgg2q9efmFvA+Oj46b/farDU+NKKqEbYNPVSYQNpEiPg7oY/ZCaAYvy2ZMO4QGYr9fzMIfQs1VwbPqR1ck7uTnsgBBPllRpMUa/DUrmDM3LYQr7dh13o4kFA==
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

These fields enable lazy vmalloc-based dynamic cluster management
where the cluster_info array is backed by a sparse vmalloc area that
grows on demand and shrinks when clusters are freed.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h | 5 +++++
 mm/Kconfig           | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 78f4302b92e1..970232f6359d 100644
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
index 060190e12bce..82f62f4c5b23 100644
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


