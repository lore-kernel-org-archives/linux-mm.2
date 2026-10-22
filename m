Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388C7606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DpnLxfxC
Received: by kanga.kvack.org (Postfix)
	id 56BD46B09F1; Thu, 22 Oct 2026 18:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544A96B09F2; Thu, 22 Oct 2026 18:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5626B09F3; Thu, 22 Oct 2026 18:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17C256B09F1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:03:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 991E01A0256
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:28 +0000 (UTC)
X-FDA: 85351639296.18.96BB465
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3EE3A000D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DpnLxfxC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5g4D3hEwc7GK+nQos56fFKgAhNh3H0jKC5fCgXobkg=;
	b=aC5FAbBu/6sO0Na2zVsSzRo+LZb4E7iRJAuyc0HF5OKelP2JL4vn3DcSQb8Gfi/xWVXota
	BiJBDHAlfGFYY555Z/HsEGLHl8Tc4s6iYc6jj8yVuvt4i8hyaL+pPMMmFkLSij0eBH5O9x
	w3N6rSnJrSMBsyDHtQGjMSExzCeUi6Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DpnLxfxC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706607;
	b=u/8lxqSm8S12DVZIP9AcPH94FhtVw36tPDDNBwUM2mdg7Aj1pQs0wwb6Wj1m8DZNs46vbd
	1/PlZVqwa+DeLSG/7VTXfNzOKyFJuKelkEEhQhv6VeE5zdggyVYvIACmN5o/gE+/R8rjPY
	vRJM1Zd/NJ0LKqDSKUQfVB7VGbcTySg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9240960A8E;
	Thu, 22 Oct 2026 22:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C181F01829;
	Thu, 22 Oct 2026 22:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706606;
	bh=x5g4D3hEwc7GK+nQos56fFKgAhNh3H0jKC5fCgXobkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpnLxfxCgxMDb32Z2c8mEShELG4hi0o4Yo00Cxrxh1xB7RIknx6C7gC8fgtZGN6HI
	 KMkbyw2c9MEhy/qdoVTDrc9QY9hsMNeKvCT/iGbL0YvyZzVX/rPdb1ClNy614kxCFL
	 TDvTU0rnJk+8yotIbkKZH8kawmZT+PNUwzWU7rGfng7QGLnJYxGlx4XKA0CHT99bGm
	 uhPDuyT6deMTTrsAlAyyLkcqY4xZmd555jRLS9FxPQL3DXl4662uIkLTkOoomN5/rQ
	 Wo8wxH3JYEHotpZXhLcFx28w7f8IHGOE0pWalAmLDJSeeZK4sOx6U1hVjs3IPTh0ps
	 dUe00IyGnD+aA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 14/14] mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation
Date: Fri, 23 Oct 2026 06:02:03 +0800
Message-Id: <20261022220203.91911-15-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F3EE3A000D
X-Stat-Signature: j65gw8b9fugbjup6rz7m3jd69d8ok7tt
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792706606-211473
X-HE-Meta: U2FsdGVkX1/j8pXaG95SvUw8irRtBMbswxXGGhFX3L4axTMlb5bfohFJge/87FmYXdZQfLhyB4ApDAIVpJzc3ct0V1Ait/FuEAgDgE1fPPuJZCZBxYbL+sUAgXGmDsCFVcH0BIykDls+68Chkz/ytroJFEkj0wsNYqe3PZXP0RggB/ojL5dWzv+21kKgV9QNMWngSN8HKz0ll00qU9N1yqxJx9wYpU7dH2LWvgKFUislSvbRkNSv3fG5Hp7wtX7gEXSsd02Boks1WtbjDkj7yIv4t2tmNBfD4zmUvb1zH2hldEYi58PDqbB7zjKKAEzDYRVtx4/szrr2cQzSndZsdGkdnn4fDadXePbIXBHVBcTlzVZEV6Yx0Go3WfUr0zuzQQQV1NY012yfF4n7McVvQETKgD+cmH6RacQw6bTIJKahb9l0pei87dhMI0QwPmjR4QpWb38TWiMKRi559lju5RPNc5jFiXARvm9Zv4/TplODtEQvWMdCom0CWFzxNmcHFH1UD0mGIsDb+VO/hwRdx5qbHqeQDD/OJ1jXSC3qIx1CXAPe0/dbGJpGkafkoL1kC1rZwCZFrbFBeJsCHecfxOzIiWR2Kh3m/tZirnYMbhi8Ddif0/pMKF4bLlGl59EBR8JgayEsXEmFsVMGN60Cth+ThCA+RA+hXGAZkXYqVXKmfrP2jz/KpCEtoLwEZoYb7IKnvsveyTyXggb/h3l7r7eAfLIzHNreJ7Z+dPotvWBFNHTuzsHYYlZUQnZ41n0pzyQZIy7va/90/OfRTfQFLZTqt3nenOIyK8di1nS/cmmpadMUhy5kSfWLrKODqlPouzy8XQWbA246O32tJEPHcDTKqHCYAPwzIZ9VOGpxLWMaY/DBRZ0HDDKCbSUA6yVilYJUCgiNCYO3siPzB/FYLD20Lxh/x2qG5yu/wt72LVDw71b/9cYcjyljjH099zHuiXnPuaSCWRbr8a8/sNJ
 IcW42MYG
 QfjcSuq7U2U9IOeMaq5vBTNv3K008xL+w0QspeIdbDT2S94Pf0q0pWAEdZhYq5vDt1tNntOcM69SKVG5iRnSjHNNKiW4hfMDZU47+2pD/db6NQrVV1O95ZnYJ/xJj/IhJ5RxnTcqPVCHRObRpUG7KTpANHf40C6HXNi+lB220I+P4j6feHl+2ECdxlO+SioDmz5pyI+Oq+KlRr1+p9v3+TmDUvaRA1BVVItOaOG+/aoFoAtd6/dSXhhRdQJbE+kZmR7u0cR6iSQbDgYTV/2O3lyFU4vErNzG1aYvaty/hQf+xu5YAqfk/oVh24pEHApUi5096bdKflQB5PZfHMYiuh5JCYCiLmnKP9DU7PPyBRvLZvqMjgOZzg+LJCY/0aTcLlLKHZ5V/LMQ+YigF595nEKQm5A==
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
---
 mm/vmscan.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6d5a823667e0..d72a5aef3a0f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -379,13 +379,6 @@ static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
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
 
@@ -5061,26 +5054,23 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
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
 	if (swappiness <= MIN_SWAPPINESS) {
 		nr[LRU_GEN_ANON] = 0;
 		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
-		return;
 	}
 
 	if (swappiness == SWAPPINESS_ANON_ONLY) {
 		nr[LRU_GEN_FILE] = 0;
 		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
-		return;
 	}
 
+	if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE])
+		return;
+
 	for (int type = LRU_GEN_ANON; type <= LRU_GEN_FILE; type++) {
 		int hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
 		/* start at MIN_LRU_BATCH to smooth the rate on gen start */
@@ -5306,6 +5296,8 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 	unsigned long total;
 
 	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+	if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
+		nr_to_scan[LRU_GEN_ANON] = 0;
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
 
 	/* Just scrape all pages calculated above if this memcg was deleted */
-- 
2.34.1


