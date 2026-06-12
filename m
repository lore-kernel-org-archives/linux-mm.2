Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C78DCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40556B0088; Fri, 12 Jun 2026 03:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18076B0093; Fri, 12 Jun 2026 03:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54B76B0095; Fri, 12 Jun 2026 03:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D80C66B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:31:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A36E414051E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:31:23 +0000 (UTC)
X-FDA: 84870440046.11.D3C7909
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6055640016
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:31:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781249481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=FBwBW53zu/oGPagXTSsymEf+z2vunFeJw0CIHka/rQw=;
	b=ZFg8KI38M9VhjgjWosF98N7cX0nhwfXfq7Kg/5U7StqpqSDT0D3GxNqSLiqAJoN0LlnfWB
	9LS4QewDkkF1NKmkUC3hOMDiYzMJx03oQJyHpGJa4m4jSizypsMu8LEZv3XgR/qldCaGif
	RRASKBhsweEQk+cpRY3z+AN+/3rv+Pg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781249481;
	b=cqVNsBkQ2CXiFQwaA/LJ2bURS4EsLPXEylltorm1nzY0NLOELqm1rVxI8swy3R+sWSLKlj
	IEyUGPn1Xk2wNyqwQmpUtieUUA2eAUxuVngIEme4WG++aCvZcOKg9NFm7NL5YtaAsmOvgV
	YX07BHc9vfrLLfleCXlHYaURrJywA/g=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gcB5S2VrDz1dd8V;
	Fri, 12 Jun 2026 15:31:08 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gcB5R6C8pz1dd8V;
	Fri, 12 Jun 2026 15:31:07 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id B7C9334C3EC5;
	Fri, 12 Jun 2026 15:29:41 +0800 (CST)
Received: from hsj-2U-Workstation.hygon.cn (172.19.20.61) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 12 Jun 2026 15:31:07 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<akpm@linux-foundation.org>
CC: <zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Huang Shijie
	<huangsj@hygon.cn>, Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH] mm: use mapping_mapped to simplify the code
Date: Fri, 12 Jun 2026 15:30:32 +0800
Message-ID: <20260612073032.33228-1-huangsj@hygon.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.61]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6055640016
X-Stat-Signature: 8yrxrbzy8nfsni8atmwpq5ik1dxetpr7
X-Rspam-User: 
X-HE-Tag: 1781249475-561283
X-HE-Meta: U2FsdGVkX197wERDMposN6NUi+FVxIju1qCLx3MpiaHHH/kLlWK4Jn/uevnlmc35U8B95Zy3HKH2zD7rUoYZ6rFsYQ8BXdCn9ZNdvRpA1taOLWZVdwieQV5LTMQYKK1fXR8vvQnMSp5YWJrKhKHDRRLcu3YiyI5587u5/3vmoHlyRDQ0IZLUP8uUHiK0xRXF8NmR4ZWaQJr0CTWXKdT+edbjBaVEuc6tKpWCWY0158aopbK7zat2k/IXGlIgujiQutMsTZfjjsVUaZPtt8mlN5KZEzpLVwydERBzWzcfBCJkpWYl3Gh9juS5GhIU33smuhS+l4iDxB2TsZfh6k8zZ7dQDpp8U4efEmjhZpv85Tkwn179UQZat16HURh9gDdZvTcxhnc42mapRfTaiz63JeoNsDR7h1WqQ8ugaIKYeRsjwjvkpYRFp5NCpgqu8FmR74k6TMI6fyiD/NG+rfFwdS/NZlNHXFo5ouPv6Q4XJsd15jOp7fE81X7xga9f01BHSzS/7dnZFjoR5kO5XraFIiTAYkQLzpUb10Oy4/A9P5T6uNTzp+QgAlCTVA+Mrpj+NpTOYGLqnpsd6a7bLNeOJrqkfeqykOkI6HX2ptiB+zIAgOXeKaYFNhJuoE6EI1okZ+mCKIPTQqOXtVjjsVKZsTGWXZCjl+EDti97LxHiMQAaqVvRr452Bj4B9AQuPRiF5iLehv4kd/teZHq9rk5upSFMcIMinNg3WC8LkPA/ROINOoZZThPckLZMZYcgrS90N0hC+KYs0IDpMtabQd4P7YrV5nE4aSXdVNCns6pU8g3PCIgq0/y8fX6ymZfvhTprS7Z+OqdiTWLTiCxtNh3Pv94lSHl+j6O4hTr34Vcc14bTlkvBfq5G87jju0+wvXNnhgoXDulKfb7yk7mJuKa30dCHQWo861sDIGSJ/GhFDjb2bYVhLNZLybfGlIY+0h7K+v26iLl0JsFxAE6rKF5
 UukJCTGs
 WqVl6D/Z4A6AOLhMZaIdt3uYQK7+n/imNg8Xg6jPruzzF0rOptnKcwSA+y4RQykC+9Lnjs2pE4pE0bBtiN9dE3clfDz+CGd/Y8Ek4MslwtmuPVBd5XDE0xnUJZWqt8btBhQrRubzc/0qOYclagptZdS/ku0Eimc/wGrxLtr7OGd0OhkywwnSFF4AYnko/eabTI5u5crvxkNTE2JEvr/bIf1E0FatrRbPCdmQYmp3vKpuklOd7PKiAv4limF2ll2sI5HwvAZE7JTBTuektml6hQOcwN35hCNtiQ5Fyjq8W6Y5ibFMrdflpt5WwQTm4hjMKyKdExHpn/XNp3s0fbHb52fsi7AbPoj1Ea3YP27FzktAJqBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use mapping_mapped() to simplify the code, make
the code tidy and clean.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Huang Shijie <huangsj@hygon.cn>
---
 fs/hugetlbfs/inode.c | 4 ++--
 mm/memory.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 78d61bf2bd9b..216e1a0dd0b2 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -614,7 +614,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
-	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+	if (mapping_mapped(mapping))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
 				      ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
@@ -675,7 +675,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
-		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+		if (mapping_mapped(mapping))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..5335077765e2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4386,7 +4386,7 @@ void unmap_mapping_folio(struct folio *folio)
 	details.zap_flags = ZAP_FLAG_DROP_MARKER;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
@@ -4416,7 +4416,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 		last_index = ULONG_MAX;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
-- 
2.53.0



