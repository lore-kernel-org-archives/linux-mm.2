Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08DFECD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 11:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00956B0092; Thu, 18 Jun 2026 07:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7B56B00D8; Thu, 18 Jun 2026 07:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8886B00D9; Thu, 18 Jun 2026 07:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61F316B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:35:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2047A06EF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:35:58 +0000 (UTC)
X-FDA: 84892829196.01.53CAE02
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf31.hostedemail.com (Postfix) with ESMTP id D3B2320009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:35:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GVbWMym9;
	spf=pass (imf31.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781782557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+p6JSYNOLQBLkW6pkWe1IZK62WyPL9jSV81uAwStG2Q=;
	b=MZ9tTOVPROfocH8kILN7TS6YIHqWGbqCwsYV79/RYYk/WgB/oq4PF5cT0DBXK+6qPbYyx0
	8wH88PC1vDxyFeaSwtBaXriIN+1e2vnaQBJYh3hX4fvefU2lzVn0RKA7mYutRPOhObj8Y7
	CFtgdRF1ihRK2P2qkqP8LcA0gfvG3Lg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781782557;
	b=YM2ITbdNaZ/K3nfHx1H3YSEMwAECmoQh15ZmUE8wvlcRSyy2luuCfgHPXqC2cpgXBWo6Fo
	lMqhtb+KZj3FNxjeKVh2VcBUhk8lV+nGG8xg0jRy8ukMp6Vgp1MNUzZfuyqsEIt32mSqQy
	Qp0Y92S5vl/aHxmBJEfpU65vo4DIst8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GVbWMym9;
	spf=pass (imf31.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+p6JSYNOLQBLkW6pkWe1IZK62WyPL9jSV81uAwStG2Q=;
	b=GVbWMym9QBI3NFX1xRwQNjkcLT1JitZqvNBp5a8ergLK4ng3s2QkAFRNE39avAONhU0Wfx0Fc
	FLY8uGdiDJqhuIm8sYwWGNUdOT1fWXq42qLMRhDtTkh4Dsonm9u1ozoHtB0PJgLpGGteNHettYN
	/SmAan+Fj/QgXBOfA6DwjUc=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4ggz3p1XV0zLlsj;
	Thu, 18 Jun 2026 19:27:50 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0CE2540565;
	Thu, 18 Jun 2026 19:35:49 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 19:35:48 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, Xu Xin
	<xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2] mm: remove PageTransCompound()
Date: Thu, 18 Jun 2026 19:35:23 +0800
Message-ID: <20260618113523.3913307-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3B2320009
X-Stat-Signature: 5m9wwzkippfi81bpyonnci5id5bewswe
X-HE-Tag: 1781782555-894402
X-HE-Meta: U2FsdGVkX1+pasneKVHJSXrS2x6vL+0fuN2pF/hLrmYJoyY6WIOteWFTv2115jvZcfAh3FhC76/v3ibRWTz3x2BbGN3eF80L5ywalIZEAoXHgyYF1Gam4BomXkDtXCL2XORDYwWXnhbgRus6UgNMgz/W3vrjpHGFRoReRTSpoGcT3f1dQr5l1mIuEMn7lknvXbrwrvhMvf+sU1dT6Gxl6DSOy7nlFzhU+1tODW91SrOAO7TvZVGUCDb+J2Lo7OHm7dxKlqOMeyzBgpDAVdNVx83YHLRjLqSB5jbsuXDSrnSk3QMkRYc96U34DcRLPIIUp1jT57+9F6bjCNfbtp+SeocqFzzMEhGaxWli8/wGXHi1NjK7g61ppbVi0tWH2rUrXhxHGSmtcl4H+CAlmZYYahtF+NSQTZbdUwOcjtmbKK0URcv8HKb4AjIXAYjUveY95wOdNQhscv/zX9niZ3AQXruC2hcYxdoA3jDqDgaIDktMSuFHfG1Vu27FZSCoSr2EtmBvXS2/81KndpARuaF/afIeIjaRP8wvJx0JY9ru7YxV6aQFAMEoZoLhlGMWk/kfa++kIrjMPQvX3zsnoOroObwWWg+VMU9KXa5VlvhAybs0uoxf+LxcILvdeCOgbNLcIVE0zvYJ+vo5scK+nIJONXmqzss35J45NT/ihjjz8pm2x9UHebiJ0Vs6S2J9dBBvL7QLwPbtgrV5XJfqLNN9d8ZdsPb8aKvAcM7pm/e+4IihDEmYLtnNRayZRrnfGTIVNn5CRHW2xWn2BRUN2NMdFyWKpVtyZYBkCOKBVx+MrqZjhPmlOu1ep8cB8WovXbGTHAedB3uBGFiCNH/SoQ261uNX4uUKDvZiT0ZVMoLyZyMv82NByA1da3NENtji9L1EtYaiIDqZcI/EQhKQyLan1Nb7N8Ji3Ea3e+1Y8M19sl5tVjA9rRCdLJ34N/+jKyBa0HEELaUyfmx2AdSATHM
 ZvFU6AGn
 SHjXqr1irjzhJeFGaZ/MQcNustyqaqAuXUkXACCx1XGP5zjaiKX/KNQTuYjnmbFTRXDSfwdXaa+ZU2qWzA3pnjpbXxbJ+0tvwVh3dIm7ectiGvvz2gY8cs98ZEzllKbO3rBUKlM8LM4gAVslWwjOTx63lXKM/MgW3hy1TOB3VPMHjlu8LAQe1ILnEBnWv6C+o3tlEp8o20HSifpY8s4oWLA5N4X4aqrGcIsjNY24dZFaG4IsBMwXx4uABpP547ubjTK+rqDLbwji0Hf2YDXsFhH9Al4ZA3BcaVlTz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the last user of PageTransCompound() in ksm and
get rid of PageTransCompound().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
v2:
- use more folio in cmp_and_merge_page(), suggested by David

 include/linux/page-flags.h | 14 --------------
 mm/ksm.c                   | 17 +++++++++--------
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..7a863572adce 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -879,20 +879,6 @@ FOLIO_FLAG_FALSE(partially_mapped)
 
 #define PG_head_mask ((1UL << PG_head))
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/*
- * PageTransCompound returns true for both transparent huge pages
- * and hugetlbfs pages, so it should only be called when it's known
- * that hugetlbfs pages aren't involved.
- */
-static inline int PageTransCompound(const struct page *page)
-{
-	return PageCompound(page);
-}
-#else
-TESTPAGEFLAG_FALSE(TransCompound, transcompound)
-#endif
-
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
 /*
  * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..41ab25aa2a82 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2327,23 +2327,24 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 	tree_rmap_item =
 		unstable_tree_search_insert(rmap_item, page, &tree_page);
 	if (tree_rmap_item) {
+		struct folio *tree_folio;
 		bool split;
 
 		kfolio = try_to_merge_two_pages(rmap_item, page,
 						tree_rmap_item, tree_page);
+		tree_folio = page_folio(tree_page);
 		/*
-		 * If both pages we tried to merge belong to the same compound
-		 * page, then we actually ended up increasing the reference
-		 * count of the same compound page twice, and split_huge_page
-		 * failed.
+		 * If both pages we tried to merge belong to the same (large)
+		 * folio, then we actually ended up increasing the reference
+		 * count of the same folio twice, and split_huge_page failed.
+		 *
 		 * Here we set a flag if that happened, and we use it later to
-		 * try split_huge_page again. Since we call put_page right
+		 * try split_huge_page again. Since we call folio_put() right
 		 * afterwards, the reference count will be correct and
 		 * split_huge_page should succeed.
 		 */
-		split = PageTransCompound(page)
-			&& compound_head(page) == compound_head(tree_page);
-		put_page(tree_page);
+		split = folio == tree_folio;
+		folio_put(tree_folio);
 		if (kfolio) {
 			/*
 			 * The pages were successfully merged: insert new
-- 
2.27.0


