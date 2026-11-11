Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621C7606A881
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iq2EVakL
Received: by kanga.kvack.org (Postfix)
	id 7DD666B05F3; Wed, 11 Nov 2026 18:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4836B05F4; Wed, 11 Nov 2026 18:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3B36B05F5; Wed, 11 Nov 2026 18:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6676B05F3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:27:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0739160380
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:36 +0000 (UTC)
X-FDA: 85424427312.28.7093EEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2EB91C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iq2EVakL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzO4KiqZw719W+0CmuqrZxCm8Y3trZUlrMTybnCiAns=;
	b=pTthkmEGN6DQrsYquELQuFhh2ikFVclvRWvwzOrHpZZL8oZnGPYvj38kklz4GHbc6mhszj
	i7bd6ZcvNILS61LNzq7LFQ7CFtJ0Jt3MCNzB4BuTq04/mDeh+thSDn9fGLH4bsrdSSFPy5
	pglZCI1Z4EI8nyqrkX/AdhcmeA8/eWE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iq2EVakL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439655;
	b=58YP5y92+R0eTVKIaB6YEQNesmmzH/USTf4OwTLRHF3epyUpE6Z1JPr8cHzyuzbe6pEwlh
	3UByL6T5Tk25xyZmZoj0eAMCaJuFGbCkl1oD4kd2npHzjbx2Jb02zowXzUpU4P9Rlc7Wyg
	B9jhcUL6LsYr+3fZ63MzYWmjBzVIvBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D96C44D61;
	Wed, 11 Nov 2026 23:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EBC1F00A08;
	Wed, 11 Nov 2026 23:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439654;
	bh=mzO4KiqZw719W+0CmuqrZxCm8Y3trZUlrMTybnCiAns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iq2EVakL0MhzMjJN/wPKDl5O+vbqbX16HeJU7+ZbRzhfWqhoFz5ZKXQZvz1w+T1Dh
	 KF7kUlO4GnmYu/rJ9WBO037T2whfizPK9qfARINQmf/WU+uE6o0mdUJgDhsrdsk2BD
	 +vHXCGDZnWUr0SHJUYqthnjYoc4qrGHzxTy7vAulu7g6xadWDlyp31AZdJmuGSmTE1
	 /VjiXN4BZwD5AbUWu/lxEOyAX8SquKAvnqDbEgXviM3t0XTihH2dIDWoxZh3hyUze/
	 NIQwLPCscGRMe4sfAGPYo/XEB9VF4W1tuxytr5WtLdmJ/FrEtnrRTwCRP37zrXP3VE
	 x7W+68/cOUQcg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH v7 16/16] mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation
Date: Thu, 12 Nov 2026 07:26:03 +0800
Message-Id: <20261111232603.9934-17-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2EB91C0005
X-Stat-Signature: 9sudat7gws364chg5d75widmn8deph3w
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439655-218298
X-HE-Meta: U2FsdGVkX1/vAv8U6C5qE19WirDMXHg1cZGsiSa26fKxlC+YByZxIOt9NaIcOkq7PKLDLd/iy636tCq24MJsVvyi+rVLypgWLXTyO2nHhpGflo7dT9KRkCbLvnEUVHpmV5vbdh1bubvRpGAmhrUc/b31ToXFxjlkbqxoc4APqPqRZNlsSCoasGtn9tZKHyZBaqntCqrR/IrStYjyRIBgF7jQmy3IpxNyQQlhGIh6iXdfXUS0q4tx5x6IXZhI4pLl1QKpwSyeM9CqGofkO/AD5fFzUck+tRTB1+0qCqd1vPHhQajyeJlbdgJ2SccUy3i2ajAtVIWeMTqnJT5Tdvdjlt/E0T7NPPOzSshbrJ5zfVPUPxQRq4EUHV0Wq2yGPRIBA6x/beqz7mIDxRFQvoTqZ0qREBXuBXN7GwsxTObrxBo9w/Z8P3wHLEkFXQh5xV9dvdMw0BMS7PeaoziYXR2/y28+b1Veer5tYIQO4ILnfVr0zfr8ipX2Nu4ckFkQc6uo2OS7Sdbtlb8i8i0pnO/S6amANvIrF31wn22IbjlLHfF91qkFWiK7MXLd5Pnkj6KLoB6S4/jtyQTbSfVqN+vsoTjlD2BVDpTVy395PyF/UADxTFD6EjySIzeASqsxzqs1hb9STnuxPudBlE+meKRxA5vsqpIbXsA4HT1ZVw6vtFal283X+jp17XdpGjIPBz3oTimuatxIJUGlfD4wnHnlVa/A11Dhb9GG/RLdG0NqAS8YGyokZ6U9XbhJvzS+pxHOG37ke+oBxtwWfKVaBG+hMelyWcdS2Br5AY1V7oO6+pVoync7VdNWUbYZJL2V9+82O11661EMSZasvrEtNusRq9/fOGzZcZCTSYGvgG9WK1FUv1mgIitIFklvL+zBNgmj3swA6PP8+++Ghk7dPmNM3CWUS2x6fMaheiVQ6pYTIlo8acm1fulinxKuEC/5RzTOh8JyYkoTLKfEJLrOHiI
 OutdUjWP
 P7jimVJJ2oGijfwrqCgy5OpstCE/yVKQAOkGyG0lqRMGjw5fn0UZGUN/Af+B+kGX9IBDO5l9jM1ylOnezXeTq5uklyeH49zhQwkdaTsUJm2fXs+CJjaOeqZrGloWPIklR/LWBkVuse20f7i6rlDmrPWal09bJR25Iq4OxTfVpEjQf8aJs+pacPgcs7ZiykJS03VyKS1FIcHxfv4jkMAzwZl9VT28J3LK213GbqUnL+fC4v0uD/AGkJvyzF3mwsn9vDqOAMVOLBL8DVBa4R+8ayPr92XfJE/Vf0xm0WU+ZEWuSvLV5KgnlLOJD2pRBX3Ib2wSLCNqmDTWupmGSbiA8Ix4z0GbxK4efm4RFNF1wZDl/a3Gj9WVr8HGpogTFwpR6KTde0nT6cbqvH990OGd6joRRYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Bo Zhang <zhangbo56@xiaomi.com>

With GFP_NOIO, we cannot reclaim anon folios unless they are in
the swap cache. CLRU skips anon reclaim when the swap cache is
very low by commit 74d9aa0d8e98 ("mm: vmscan: avoid anon scanning
for GFP_NOIO with low swapcache"). Apply the same logic to MGLRU.

The new scan-budget-based mechanism makes this straightforward to
implement. Thanks also to Xiang Liu, who previously attempted to fix
this before we had the scan-budget-based model [1].

[1] https://lore.kernel.org/linux-mm/179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com/

Cc: Xiang Liu <liuxiang.277@bytedance.com>
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
---
 mm/vmscan.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d51303a5cb67..9f759d213614 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -272,13 +272,6 @@ static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
 	if (!sc || (sc->gfp_mask & __GFP_IO))
 		return false;
 
-	/*
-	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
-	 * scanning type, so only apply this to the traditional LRU for now.
-	 */
-	if (lru_gen_enabled())
-		return false;
-
 	if (memcg) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
@@ -4212,6 +4205,8 @@ static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc
 	int type;
 	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	int nid = lruvec_pgdat(lruvec)->node_id;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -4219,6 +4214,8 @@ static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc
 	nr[LRU_GEN_FILE] = 0;
 
 	for_each_evictable_type(type, swappiness) {
+		if (type == LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc))
+			continue;
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
 			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
@@ -4893,23 +4890,19 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
-	u64 anon_scan, file_scan, total;
+	u64 anon_scan, file_scan;
 	u64 anon_weight, file_weight;
 	int size_bias;
 
-	total = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE];
-	if (!total)
-		return;
-
-	if (swappiness <= MIN_SWAPPINESS) {
+	if (swappiness <= MIN_SWAPPINESS)
 		nr[LRU_GEN_ANON] = 0;
-		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
-		return;
-	}
 
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
+	if (swappiness == SWAPPINESS_ANON_ONLY)
 		nr[LRU_GEN_FILE] = 0;
+
+	if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE]) {
 		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
+		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
 		return;
 	}
 
-- 
2.34.1


