Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A53C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A017A6B008A; Thu, 10 Sep 2026 05:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9626B0093; Thu, 10 Sep 2026 05:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8045C6B008A; Thu, 10 Sep 2026 05:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B51D6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:54:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89738120456
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:58 +0000 (UTC)
X-FDA: 85197393876.30.715D671
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1AEA11A0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zprR1cA+;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034096;
	b=5iFtrvT3H9c/LHmZUR10geDfqB2kGsQeK7Y1r28IDNu2WuKQ+DblbNQMjT4RHuSsKIZBgU
	aN/gnBV2ulCZc/1HTuKApejmi5fzz2N2IqLxMP2sH7G29+TXsyXMU5jdDdHAoCgwypHZKm
	v6N4zv8x8gSt4qPHRiQcmjr3qFdQpbI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zprR1cA+;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYH8YVqAhKFLmpEdImn2etJ5CxjXZ66KHXC3hb3Jua8=;
	b=AAsJIiw9lDtJ/ej7T73pSo2im0jwfvtMlYt/KMD00WZfcb090qeN/QJN+rRNf65yu9Y799
	+GAioImBfFuVSH/grJZqsHL5noC3KoR/C/nnLR4Nf+stnPtMMiwHsCROMsAEu4F57szHdn
	MbzBKJnMGj4kUdKAukJ3ni2qmkGhrqw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YYH8YVqAhKFLmpEdImn2etJ5CxjXZ66KHXC3hb3Jua8=;
	b=zprR1cA+H71rOCGihI9cnn13m8SrmuaTpDU5s4vj/J47DpSKPeOy+pu+xINwQdqWn66YzqW7B
	61GYohavpx8UaHbHJvUc70hiYFGWiKUOW1EBv75OG0gzZSnIIOLMug4y5zO8fxyzlzd3N7Vb1Jg
	d38E5HnfhBZDxwLgl589lzo=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hgXmQ6N7Sz1T4MG;
	Thu, 10 Sep 2026 17:43:18 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id D6E4840591;
	Thu, 10 Sep 2026 17:54:51 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 17:54:51 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Chengming Zhou <chengming.zhou@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 1/4] mm: zswap: pass type and offset to zswap_invalidate() directly
Date: Thu, 10 Sep 2026 17:54:46 +0800
Message-ID: <20260910095449.715183-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1AEA11A0002
X-Stat-Signature: dn4ibha6u7enght9fmn5gzyk7i7qgeuc
X-Rspam-User: 
X-HE-Tag: 1789034095-294290
X-HE-Meta: U2FsdGVkX18hNGSfsabT37H79NqAdkveYQKhNSHXtrRMr1I7WP2lYh4HevX4QvIR+OeHioNt0qjvT8FPq2hXbe2Tm0CupYaIELnAQGGd8QH3fss8eg4h2ft3vv0mRuIac+YqdjeIPpGVGUCRzIgRlywEn59i3A9Wi5K4GGMOMQA7j8uuxS+Tc9+2RsEaNsklB6zzCTKFWlkZXTdo3PP1b1edDIf/kEufzmKY6MAxxf2KHdihQlaWMGr4ge4iCliBVlVOQWOpDFaO5sM/E7BhIRsOPdPvyEeCCfMKEXWSSvEvFbXAzlITi7LvXw8c8SEoEiiwogLQCV2KO6BG7kgsoYLR2SSrovPtmqM74zpdEvGsp3z7ynzj41Qxef/LCb2zwUGvH5jmnwZcc2ZRmCW1rDTAP7HIY4aYRbTXDrMkeriPMPCoph9jkDJrgqnqoLpQ49wI8AOUxrbPqCSdXToiGemk39bQb6HTn6gnQTk57yGhZ6F8KLhmFdz9fXfkjzXVWY5+xgf6o3nyX5H0KHZqtQjTPC96vtR9ra0Q9psGHBf8unaM129ckcrDbW/3xRJSK7U4Yzlx9eSiRGcoKEQt1fQ5oXj1jZIipf/L5HxXuwFCNOai6/Zt6y4EXXco5arwZEf6m7Ji45YNe0+8BohbPOtKS0MXdAIurf2KzZBI5d/HIaAnUQZRDkSk/k1uJQi2MPXmv/LodP521C+nKyBaA9lsPRF9ldHyu0h4alRg28jY7TGhO94fCIamoD9pSkoNXl3rFkCm60XF+s6ZHZlFjOULS+VEf26vkd0uPrp1/+dG8mIa8Co666AWC/7ocgAVimCHv7BC7hnLy9Jy67Sdj34vOLdkt1LbsSqTnl/lunHME0SmrFaax/qHBZmXG8xGMfHXMNALLHicwh4C7LXzooSUZCd7G75QMGCEB19vC0O4WJf5QvfdAWs642hhkLj01V95/JK8PbYIbPjFj6J
 h1M0VUFZ
 62UR7cVXrwrNsB8n0GwZs9eobkthSIArynkV2yvJrS1qfRANUgFyH0GAEec0fWFJ5hGju4e7LHu70CLeC8dNIn2GiBnlta48tybjYb75n0djjnbt3AY82NoJxGqyvsXsIPRPh90gtxaIe0+TdxTGae+0I5UROJK80RgzP906dJ22ox/IajArG9Kg93vcjZzbtn/xzEt2JuMxHuLpWwxbnnM5tjaxE0ZPBJB5dxTNMyUifqh2M32RuBR9mzfuSj6RYi8zJ2Aboik6kPLNYzMBCdo/+PmhjrPz0JxH+M1sG7ektsohU/TVuoh31Y/igST3zL0zKRhoZG53O5cAwz0A8m4cMNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_invalidate() takes a swp_entry_t only to unpack it right back
into type and offset.  Both callers already have those values, so
pass them directly and drop the swp_entry()/swp_type()/swp_offset()
round-trip.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/zswap.h |  4 ++--
 mm/swapfile.c         |  2 +-
 mm/zswap.c            | 14 +++++++++-----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..463bdee5c1e1 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -27,7 +27,7 @@ struct zswap_lruvec_state {
 unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 int zswap_load(struct folio *folio);
-void zswap_invalidate(swp_entry_t swp);
+void zswap_invalidate(int type, pgoff_t offset);
 int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
@@ -49,7 +49,7 @@ static inline int zswap_load(struct folio *folio)
 	return -ENOENT;
 }
 
-static inline void zswap_invalidate(swp_entry_t swp) {}
+static inline void zswap_invalidate(int type, pgoff_t offset) {}
 static inline int zswap_swapon(int type, unsigned long nr_pages)
 {
 	return 0;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 05d3408396f9..ba71905e4d46 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1319,7 +1319,7 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	unsigned int i;
 
 	for (i = 0; i < nr_entries; i++)
-		zswap_invalidate(swp_entry(si->type, offset + i));
+		zswap_invalidate(si->type, offset + i);
 
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
diff --git a/mm/zswap.c b/mm/zswap.c
index a12b6452a225..420c405d0402 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -228,10 +228,15 @@ static bool zswap_has_pool;
 /* One swap address space for each 64M swap space */
 #define ZSWAP_ADDRESS_SPACE_SHIFT 14
 #define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
+
+static inline struct xarray *zswap_tree(int type, pgoff_t offset)
+{
+	return &zswap_trees[type][offset >> ZSWAP_ADDRESS_SPACE_SHIFT];
+}
+
 static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 {
-	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> ZSWAP_ADDRESS_SPACE_SHIFT];
+	return zswap_tree(swp_type(swp), swp_offset(swp));
 }
 
 #define zswap_pool_debug(msg, p)			\
@@ -1659,10 +1664,9 @@ int zswap_load(struct folio *folio)
 	return 0;
 }
 
-void zswap_invalidate(swp_entry_t swp)
+void zswap_invalidate(int type, pgoff_t offset)
 {
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
+	struct xarray *tree = zswap_tree(type, offset);
 	struct zswap_entry *entry;
 
 	if (xa_empty(tree))
-- 
2.55.0


