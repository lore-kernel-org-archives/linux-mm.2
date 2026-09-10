Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B002C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC766B0092; Thu, 10 Sep 2026 08:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193B16B0096; Thu, 10 Sep 2026 08:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EABAE6B0092; Thu, 10 Sep 2026 08:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA7566B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:36:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 297E4A482E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:36:01 +0000 (UTC)
X-FDA: 85197799722.03.D1C1360
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2BAF840003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:35:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=erm8ORLe;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=erm8ORLe;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789043759;
	b=1H36DGs7xXTSltM43F4jS1fAUp0ykg35602gjt/9J0WyoTy8DDsDCCuGN34DmOCPuIjRZ3
	TcN86/DdSreW6oqeRs+zxr6kqmaAWbBLiNPeGMufJuJ5O/Gpk/Nmyw6S6nBrPp28/EA5L+
	pNsao2tHXpqJfzyUEOF0BHidGkwJcTQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789043759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZ4HHZVGh/OUFXs7UNrTv4c3tt7D59kEmSG9wt4b1X4=;
	b=2f5RWKJocZeOfDhIe3zuSTMYolupMijO2fWMFttQc0dZObgL9YNH7ok5ivLJz1MiZShPtx
	WijsaRib7cRjgxNsok1wnziHpOZSEi/nhdV/fbaTkV2EKZwTrrC8xH/Cj/BL3PFAcHlQCh
	dH5D2BJrgE09jpKVLGqxHsduihQDtXQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tZ4HHZVGh/OUFXs7UNrTv4c3tt7D59kEmSG9wt4b1X4=;
	b=erm8ORLeiWsSRaNSqOrWTha44gEXeOVIeXYImossiUw8wOR46JTzw7KTCx4lgEjrmHCx430cY
	wpjkh+GGNBSfe6fbt84opsMoHxPCmqjRyIAA7v7+wbtRvam8yEcpumOSI6m7pLHrVVa5q82E7G/
	dam6Gw9wq4Kjfp4hofRuuRw=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hgcLz2vVBz1cyV9;
	Thu, 10 Sep 2026 20:24:59 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id C371640572;
	Thu, 10 Sep 2026 20:35:53 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 20:35:53 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Chengming Zhou <chengming.zhou@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v3 1/3] mm: zswap: convert zswap_invalidate() to take a range
Date: Thu, 10 Sep 2026 20:35:42 +0800
Message-ID: <20260910123544.818146-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
References: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BAF840003
X-Stat-Signature: 9kq5pbz1hsckkxyjjwdpj7pebstd3akp
X-Rspamd-Server: rspam01
X-HE-Tag: 1789043758-740622
X-HE-Meta: U2FsdGVkX19M/xGm7CoGMRX+1HmwgyhVnyJS+ECycQ2v7V6A1rx7K3ZB64an2LDFsi7aHuyhUSCYcv2r1FYgp44NX4CjlmYQQ3ZmIip0dl3U9HQ00MUI5R1SqKMr3wZPNYus2Umlfi3yZQjObNThsfVL4yrg5AXRcwxqrrpL+p7b8dNgS+JOWtrbW+xXFkJhCtcV3tDa9sggQA5+v3yG+zf9pI459N1Jmgbf9lXUh8CoAAFSJz1N/JpI68Gus4aOgQ+69kMg5IKkoroc/c1njUMPpUgPHf7xA87evPqaNbW+JMqSsP7BztvVoAJzGAWznk8A6AwUWKMgGyH0y7bec9Zptvex9NCS7na4jQh/VI9G+Kp12+trbIz3dqN0U02ABY+BftAYCDxNHZPb2sHLkJkQfeALIO11ce+bNuSBy8jPTcWXiOh6FQKmUzx5gr/UuQV7yBYhUgvB5acCKRG1KHKWFaZUdYAcdrAq/fesizKCRkhoaQO1odm73DR/FRRE5G4NBGVHy6khoM9vslPmS++tSi4oBOlHhtZeHEDzQLaYIBIwgoXygYuSUOvr3+QxSkie4Jq6DTYvTH38jw6LTQw0M+NPg2r4rJtXDTAezfUKbXxVBoB7upV+/3j1cUHkJFWPJivW/8zqmdnvMETbQVfhR9SZ0QjrLIZUXH6qD1kr0syxtAyP9r6RVEJvr9j8uN8maMP3v/D16u7VZaRSt0QTLkuJeBjdpAADqwMTys6CTUj/3uu4IEklvoRzqsy8h7ffRZp8dZaWI9xalgBU5IJXUPPDOpPLHZBZ+xY57uvHfnEENj7XvnyElWrXeU4R9r1nr28bRP1qM666ysdAcrB02kntpLivPJQKK/u340BjGioSmVTKx3qP0jQgQra++QEcAvfApReaz+NrINLYem2OUg2rV7eZdcaKAEYxz48AKFrUpulgDr+hlo3XZcwt+voBUkUiQ8lTuPJVshg
 afP9spTw
 aK0+Hq1EDImKqPhzCAGHh4egZYQBBIpwfM4gD1GZoWtb/HFZHzRYCgS7D5AuthmIOVsI5MfOjG+NoB4+bc3ExF/PKB68rq5cWMx41JdwRZ9VD94lsxfO4BkwWKE+1PVA4f7XzQlWsp5nxxRwQ3VsSdv8bXUPEA3a+4HUB87b/Umf4Fn20eW05cJtSEm4CdmIoGVMAiYcJ4sDH4gKxB5OndDvkMc6Rsx/2qpiN4CBfKltzoe1DKbmJwRzNoIZFR9KRBT0BqZdwRwlqu6ZwtWK/yAyCCCa9rQzLD3ZHZ4dhCNgegydul9JcOK4nOAhut9N2zWfVm+4pI2L/G/QryWsvAQfxYJ5g+2DBfvkr2IvxJJ0MEOyLE2TgyexyCU2JEsRr/6e2K9GA4UPyNSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_invalidate() takes a swp_entry_t only to unpack it right back
into type and offset, and both callers already have those values in
hand. Pass type, offset, and nr_entries directly so swap_range_free()
can invalidate an entire range in one call instead of looping in the
caller.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/zswap.h |  8 ++++++--
 mm/swapfile.c         |  4 +---
 mm/zswap.c            | 29 +++++++++++++++++++----------
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..df6cafbe95dc 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -27,7 +27,7 @@ struct zswap_lruvec_state {
 unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 int zswap_load(struct folio *folio);
-void zswap_invalidate(swp_entry_t swp);
+void zswap_invalidate(int type, pgoff_t offset, unsigned long nr_entries);
 int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
@@ -49,7 +49,11 @@ static inline int zswap_load(struct folio *folio)
 	return -ENOENT;
 }
 
-static inline void zswap_invalidate(swp_entry_t swp) {}
+static inline void zswap_invalidate(int type, pgoff_t offset,
+		unsigned long nr_entries)
+{
+}
+
 static inline int zswap_swapon(int type, unsigned long nr_pages)
 {
 	return 0;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 05d3408396f9..891379c95a01 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1316,10 +1316,8 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 {
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
-	unsigned int i;
 
-	for (i = 0; i < nr_entries; i++)
-		zswap_invalidate(swp_entry(si->type, offset + i));
+	zswap_invalidate(si->type, offset, nr_entries);
 
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
diff --git a/mm/zswap.c b/mm/zswap.c
index a12b6452a225..79a66093d7ec 100644
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
@@ -1659,18 +1664,22 @@ int zswap_load(struct folio *folio)
 	return 0;
 }
 
-void zswap_invalidate(swp_entry_t swp)
+void zswap_invalidate(int type, pgoff_t offset, unsigned long nr_entries)
 {
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
+	struct xarray *tree;
+	unsigned long i;
 
-	if (xa_empty(tree))
-		return;
+	for (i = 0; i < nr_entries; i++) {
+		tree = zswap_tree(type, offset + i);
 
-	entry = xa_erase(tree, offset);
-	if (entry)
-		zswap_entry_free(entry);
+		if (xa_empty(tree))
+			continue;
+
+		entry = xa_erase(tree, offset + i);
+		if (entry)
+			zswap_entry_free(entry);
+	}
 }
 
 int zswap_swapon(int type, unsigned long nr_pages)
-- 
2.55.0


