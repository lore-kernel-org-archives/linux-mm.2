Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E25C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE0E6B0099; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC63A6B0098; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916976B009E; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC116B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D31111A0116
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:42 +0000 (UTC)
X-FDA: 85147572804.07.DC7573A
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 95FFE20008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=C5IJTV4J;
	spf=pass (imf13.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847881;
	b=IxI+gG6PR/R2XXJQDbfOHN2VngigygbB6rQzcWsowzqMrpbo8qpZVl5sOjPC2RZfFDuKS3
	QMKOHkQRB2oifBh3Q9yCWhffnovEG/VHP8rAiZPaandrwGtR0YgQXDfSqVdbHOYIyee5ZZ
	7cj3X7unX7tmD8IG33KRuLi1luRQ19k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=C5IJTV4J;
	spf=pass (imf13.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847881;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKuenaCAMTLlNwdMoPfzm2hy+Pt0nBKVk4JpQv+n4NM=;
	b=ciI7UUplbGR3E0DF06U+rsVl+1xZp7MUKxDHRv88LrmSfm/sRDEyS+yQmeJixVyDFkB90R
	6dzhZKKJHFgGT6s9tCGrPKY0avsU8NThZXy8jKCC08KZBzUe+ovNQBl/qKzfrmidk8KWlW
	9kSKs6J+ssNBNFhk6r2uIVmU18+JhMw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nKuenaCAMTLlNwdMoPfzm2hy+Pt0nBKVk4JpQv+n4NM=;
	b=C5IJTV4J1n9lw97V91/ERsJm3aHcbmynLEqmLveBrW9NAaQwfyJydojAtXyn2UNJqUnmRe9/R
	/2NlQfieQix/TjmZIknLChLnXdZdbA6mhO+V26YMdxKCAX2+4toDfUmszt5rt6Z8uN6/UWCOrqY
	YeCb5qZebuNEjUDCVmnBgbg=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KW1nY9zJ469r;
	Fri, 28 Aug 2026 00:24:15 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id C651A4058D;
	Fri, 28 Aug 2026 00:24:36 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:36 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 07/18] arm64: add support of memory protection for NUMA replicas
Date: Fri, 28 Aug 2026 00:11:47 +0800
Message-ID: <20260827161158.3618409-8-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 95FFE20008
X-Stat-Signature: azmwzfbkfe3ta9p8hfce4o1gfwpgw5df
X-HE-Tag: 1787847880-682030
X-HE-Meta: U2FsdGVkX19Q+LlcFBBBZd9fJ8Z1n8SWFUBY41smoWGStuKP6yvmabBdES2D33G77fzYtWiPTUFct7ouUMP9i8dp3p3Nn3mDEQWvgOP8d29p+ODnxYkEf0HvT1bn6ubQ7+838eOOGLyI9KYk0aUe3srnQczhd1Y0kppPIuPN5x2T2vZ5B/FSAULT4I6VLCoyJLizizjciC64b9dP4wP1y0VwB1Wclali1l7NPfRqegmksFQaF/CkCAwkxlkAmNel9H8rdGWB9fTxxGhdk8il7uki9BrilmtX6JKyuesHn9zRNSj6Du9XLFXt012Fw/7bY12vdZd65kf8nXJm3cqLbolEKYGcwagDRmeO6Ye8v1ljvo52ocf6mmRfkEKbhrCQnT0R5jRJq0mkqFbgQz3HWV5jLDT/yDuN4mC4jbyWW6ghAZEyXenXzNtmFin1cD9kLIwpto65JYnRbLoWxmSG+NcL65YZPajUA2fpG38slXAT55u0mMvFBBPa/UWO+KuIYgQqe4yyqKcLV2ockTYBu+Ch+aq1N8GXSFjFDrILDLlU2FQD6KVxQrpV0O8AZeJcQZXIWfE/+709dkeYWf6YY33oCyib1UrzYjBAvIL4DBJbMVx0kAj2jsEKyt18zJcHUyTtBX+8UutdX2pxT30cONRp8ut+jZ/L6xWvfFEG4VqV3w7poXMXTkZ3dMw9W2pQBzo9u+hn4ztfUuopGCAuBpSZ744K4k0ILycbaOZGvBCvJ9HHREXK3rGymSuXPtovigv2ccuePcJztbkkouQ33HScctRbv44XAOXQ9eBYPN7xM2z3o3bNFuMljnIqt8uowraavBQA2fS/pVS6JMzloD46EomDm/tHwt9QsVkxY2ucpxu0zRKi4zY0KsKR/uCal+qCsVaNZLi9ufLrddPSt0QWj7uwu5ttw5mzZAYNDflNTwLBx/f4opLHPevWZwYEIPXWiPzHQ/qkFK/JkSJ
 ZrqWGdlY
 tVMvrAGlFc6TxrrOJjZht4IV/9rh1w/xyCEWXbjt8z+MQQtfXgy6odN/8XlQn8wFRKtgwDbCN83VlvVgKeZHDx/VXj3lYRDRwHqSZSClIFGuU5siHbBD0sgsuJcE4xFtPqOIP7R8b/w/JyBi/PygQD4v4DBOvW4mD9Pl9qA+G+uODOr2Q47UEcHoOnx3sRRmVG+dbmmS0cIyxln7rEjRWAjOdILwl13MdR9ckzZpjz4RDBI0Pg6PNRbNT8XTdpNNlB6Us2pIuUEd7/tzLy8fHSatT7wlVfBkc1d8k6OBearxAAjvGuPpwOF3MZAU+IB7wpJrbu7HGcQXyKmAZUzsv29SvMXh/sHhBdRntwQ3k18u0KJ/XVZuOfc3PUp4Hohw5kcotyf3Upqoe6WGi1pBo6RQHEpUvisrsWfsKv8efphikd6PTxo2x5KZJF7dURGPN8hP5Hl1RM3iz98nnkH6xLCtN4RSlsslfWex7iQn4t12/HlfrSAEkCCIMJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 arch/arm64/mm/pageattr.c | 72 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..50a76385b184 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <linux/pagewalk.h>
+#include <linux/numa_kernel_replication.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable-prot.h>
@@ -102,7 +103,7 @@ bool can_set_direct_map(void)
 		arm64_kfence_can_set_direct_map() || is_realm_world();
 }
 
-static int update_range_prot(unsigned long start, unsigned long size,
+static int update_range_prot_pgd(pgd_t *pgtable, unsigned long start, unsigned long size,
 			     pgprot_t set_mask, pgprot_t clear_mask)
 {
 	struct page_change_data data;
@@ -123,12 +124,19 @@ static int update_range_prot(unsigned long start, unsigned long size,
 	 * must be eliminated by splitting the mapping.
 	 */
 	ret = walk_kernel_page_table_range_lockless(start, start + size,
-						    &pageattr_ops, NULL, &data);
+						    &pageattr_ops, pgtable, &data);
 	lazy_mmu_mode_disable();
 
 	return ret;
 }
 
+static int update_range_prot(unsigned long start, unsigned long size,
+			     pgprot_t set_mask, pgprot_t clear_mask)
+{
+	return update_range_prot_pgd(NULL, start, size, set_mask, clear_mask);
+}
+
+
 static int __change_memory_common(unsigned long start, unsigned long size,
 				  pgprot_t set_mask, pgprot_t clear_mask)
 {
@@ -147,6 +155,22 @@ static int __change_memory_common(unsigned long start, unsigned long size,
 	return ret;
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static int __change_memory_common_replicas(unsigned long start, unsigned long size,
+					pgprot_t set_mask, pgprot_t clear_mask)
+{
+	int nid;
+	int ret;
+
+	for_each_memory_node(nid) {
+		ret |= update_range_prot_pgd(per_node_pgd(&init_mm, nid), start, size, set_mask, clear_mask);
+	}
+
+	flush_tlb_kernel_range(start, start + size);
+	return ret;
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 static int change_memory_common(unsigned long addr, int numpages,
 				pgprot_t set_mask, pgprot_t clear_mask)
 {
@@ -211,6 +235,20 @@ static int change_memory_common(unsigned long addr, int numpages,
 	return __change_memory_common(start, size, set_mask, clear_mask);
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static int numa_change_memory_common(unsigned long addr, int numpages,
+				pgprot_t set_mask, pgprot_t clear_mask)
+{
+	int ret;
+
+	ret = change_memory_common(addr, numpages, set_mask, clear_mask);
+	if (ret)
+		return ret;
+
+	return __change_memory_common_replicas(addr, numpages * PAGE_SIZE, set_mask, clear_mask);
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 int set_memory_ro(unsigned long addr, int numpages)
 {
 	return change_memory_common(addr, numpages,
@@ -239,6 +277,36 @@ int set_memory_x(unsigned long addr, int numpages)
 					__pgprot(PTE_PXN));
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+int numa_set_memory_x(unsigned long addr, int numpages)
+{
+	return numa_change_memory_common(addr, numpages,
+					__pgprot(PTE_MAYBE_GP),
+					__pgprot(PTE_PXN));
+}
+
+int numa_set_memory_nx(unsigned long addr, int numpages)
+{
+	return numa_change_memory_common(addr, numpages,
+					__pgprot(PTE_PXN),
+					__pgprot(PTE_MAYBE_GP));
+}
+
+int numa_set_memory_ro(unsigned long addr, int numpages)
+{
+	return numa_change_memory_common(addr, numpages,
+					__pgprot(PTE_RDONLY),
+					__pgprot(PTE_WRITE));
+}
+
+int numa_set_memory_rw(unsigned long addr, int numpages)
+{
+	return numa_change_memory_common(addr, numpages,
+					__pgprot(PTE_WRITE),
+					__pgprot(PTE_RDONLY));
+}
+#endif /*CONFIG_KERNEL_REPLICATION*/
+
 int set_memory_valid(unsigned long addr, int numpages, int enable)
 {
 	if (enable)
-- 
2.34.1


