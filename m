Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C64F9F3ED7E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 06:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A586B0093; Mon, 13 Apr 2026 02:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07DB6B0089; Mon, 13 Apr 2026 02:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B3A6B0093; Mon, 13 Apr 2026 02:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAABD6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 02:21:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 692A38CAB0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:21:31 +0000 (UTC)
X-FDA: 84652535982.29.CF5BF20
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4ABB520003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:21:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf13.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776061289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EiVNNoQD7UdW6G12WNZFcm4HDSZKcYCzMd3dPjoYjT8=;
	b=BTC0SwLK7NcnEf90rxryzNP+Hm5Hs1N8G9Jp6TwczOebumVky3mU1vfmTaUvVIs3EfAo3g
	sMyorxVIi+E0UuJS7w51qd0GrEfYWGTIVtDxtyBUfLv45eQIlje6JndGJhh2JaHy2FZNYu
	yh4XhqDLleC8z7T0TyQzpnqA0gJvBsg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776061289; a=rsa-sha256;
	cv=none;
	b=xxL7qEFORT5eKRRQdaTCPwmFrICedqlyluzYKIlly544UHJcNjO4ZUVaKsP/Tk1mggHKq7
	7TfD2jo16M027Wo+cHa6w//2x0n3xHFXGQGvgb7i/I3EbldyozvmhDf9FUsijMAwoU6uVl
	kOCmCp1V9qhvnqRZASHBrNvcHbFmy4k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf13.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4fvHNZ430Fzb7P3;
	Mon, 13 Apr 2026 14:21:18 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4fvHNY0B89zb7P3;
	Mon, 13 Apr 2026 14:21:17 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 8F3C57892;
	Mon, 13 Apr 2026 14:21:14 +0800 (CST)
Received: from SH-HV00110.Hygon.cn (172.19.26.208) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 13 Apr
 2026 14:21:16 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>,
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH 1/3] mm: use mapping_mapped to simplify the code
Date: Mon, 13 Apr 2026 14:20:40 +0800
Message-ID: <20260413062042.804-2-huangsj@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413062042.804-1-huangsj@hygon.cn>
References: <20260413062042.804-1-huangsj@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.26.208]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Queue-Id: 4ABB520003
X-Stat-Signature: r1thwfsg935bg7jrrf15maczjho5a1si
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776061284-902707
X-HE-Meta: U2FsdGVkX1+bREHGZt+cgCtYC17er4twEHsQXIejWr3byNLU+ZUZheFPQ1kn8q9TGKUl6mq2lDWan+K6XVXnBiesV2n1pp2tQ/eiv+pUxR1G3ccRGgmrgmduJBe/80psoo6PFt4uluouS6jcq8GxVaxy1q2VjTA0+z32r9zyZwjT40Vgi6zojLuB99Sv7xQjLIBvGb1gbRCcC8rmeEltDyMctbh5igWMKIQpfUATrbfkOF5/5f/oo4D9sgsnHg5euzq1L/JbB3PD/7fyXwn4m5Gik9lBXFl8xJstAEVFDdEjd3xTsZo9u2EVXNsnP1y8xTKWi/4JSL4CacP9KOBIBKb7vDssqDfBoacKy9ePbEhSBFXtHehmIVgMskPAet+t8fEhWXDYxWqX6p7rAyjAiFcb0OJxsQ6u9tijB9KPLQgcwQeLrtxmKz32r/SKbmNkYwejf1Uov+QNDkIqWiLVSbRGEOK4xbnyfwUYAGW0DxTSo75OwsZJzrL7OMqfQIoI5OTIp+g1ZxYLR/ZGVW2o+NaRq4IpoekgTpqHMdAOxgxf1jAGu1OnRIkLLv3CNoST0r+Si7tLTqboLkoCE0HgQTuIKszyj33OYvPyh76AvusxE6SyNHh+Ws4iOJcUXFyYxslB+i5XWt1qQqa7mR/M+WLI/hnGdqR8u7fuHrSWULhIuHpAeiQA6rrVVNxNdXk23wdyisPOCyJkzq3NL24UAyRAUv189E2EwZqezYpIUvvS8zOlupjiyLzqBMBssky/eKVy18IlWHSZfLpYseMPEbO8v4O0P6cdhfdklsgT1OS7MTHEsJremz6xC1u9sZIMoj0AMphgiE5f9AWBAGDNfNUzNs8bwoTSiVl6zKyhdk2Rl0f6msnyNxX9X3rNedEDUrz1yyZKX/ub7IgCrWs2+zugiv5U7yHqWbAQYaxUfYS9T0fJYJRq73fRoVmtM3FDPfiewjcBIMT9a4qUPbx
 8aXjtdLs
 +NbKWLHO0RQWLzDsTySvWvUaQZSeoUWs/YwM8lDamWUeqZXmyt/RgzYAEARpe8Na9tY9m5ub14cisD5kUMQm6cmnwgGa4B5BhSRq7vOQ37U7qxQLbIr63N1bru4HMTQ3Pw9zEnUcuF8RkyXHkmQk8ffG0VDXbvoZ2DC9UIsDURH3Z2izTgWBwss+RDmBKEllq8jIaN4rMxmxNMmFmyciESBXmu/Vs0nSqsAUZT/aSrRC39MurZ+BNDn1o9knmlofyFXfAts6c1x6PXrBFgT63E0T/pw3Wqi++xuz6GAM/h67wv7+BE3bxC6GgF+MihJH1gNXdOmX+jW+i69pShQ5v88Zj63ttchfubv56M61yYJ0voJSa9sRYPUagAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use mapping_mapped() to simplify the code, make
the code tidy and clean.

Signed-off-by: Huang Shijie <huangsj@hygon.cn>
---
 fs/hugetlbfs/inode.c | 4 ++--
 mm/memory.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f70c47981de..ab5ac092d8a6 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -646,7 +646,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
-	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+	if (mapping_mapped(mapping))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
 				      ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
@@ -707,7 +707,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
-		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+		if (mapping_mapped(mapping))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
diff --git a/mm/memory.c b/mm/memory.c
index 2f815a34d924..366054435773 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4297,7 +4297,7 @@ void unmap_mapping_folio(struct folio *folio)
 	details.zap_flags = ZAP_FLAG_DROP_MARKER;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
@@ -4327,7 +4327,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 		last_index = ULONG_MAX;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
-- 
2.43.0



