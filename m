Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A94C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80A36B00A2; Mon,  3 Aug 2026 15:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59126B00A5; Mon,  3 Aug 2026 15:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB266B00A7; Mon,  3 Aug 2026 15:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 741926B00A2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D77251A079B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:29 +0000 (UTC)
X-FDA: 85060992618.07.F0B66B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC8E98000A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRCymV0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786448;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGL55Gn26jnww6De77kstLjKOYiik3R/tBrreu0lvco=;
	b=bB4aS0UEZ1+PawH9CiYhtJQroPVKvHMu+hWQJ5gsxlN9oGfXWsw1rFTev7+tbHe9TMpfbw
	nCnLJ6rgx1r3dM9b3kdfxv9K8msQOjk34lDb/quML5ixxJosCmyxhx08FyyxPPQ1xchq7H
	iOzORt0OfZXDTdokZYiW3e2xxyL/Vjc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRCymV0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786448;
	b=jgqhQr92IfNcb5vJhak/JleX1gy+M5pYAyej6hloENonswR0Ujaom2JIg5faqJWnl0OTnk
	Ht00FUTgmKWA2YZA1CKJqFKt/RBkfLoFjvJcL13SppNDmBFSduQofjGnrVuCZwMB7o8615
	Fxngq0rBPzoNMEqLEBFbZy8nAW+GZrM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9381143E83;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7248EC2BCF6;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786443;
	bh=1n+hcBYJ2VLCPzu8Xg2KTxM1AQOc1aeNpaYZxBPUvng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nRCymV0UwDUe8D10YefBzAs8HYuwJOYHOY/54Em4EiZScroS/J3oWbwC7w3BVWN9w
	 QmcSHQm009697qseGapcMPFvqMZLb1jWkBMLrJ6klAp/KUMSrSM+XYMmtMLRnRv+tN
	 D8g0NABxxd7WwkHevK8tpSJG7hiWcBVSvOAHOaUzUTQvkf/yKBHs9VH40ro0kXnNpK
	 w8oGXyVwoIlbrmMMg0DFz6kJeGqDBGbAlpUeUUnDtq2NI1IkIZZdCI1XaceUzOH5cX
	 q4ZtF1eMgPLoyAsMXMBiuvavWyYgsuGymFOU9PuNjLrYrslmV4hKpJU2PUXf03kpGk
	 RreVEaECiQ2Og==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2BFC55196;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:11 +0800
Subject: [PATCH RFC 15/15] mm/madvise: convert to new lru refs API and
 better support for MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-15-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=2598;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=IZ9piP3HZQ3l6Pb7dyuhGVIV9UajVhIyv5fRhBDYZ6o=;
 b=Ilfa9kf1jZoKpnpzjRcdb54/uo49AYoBym1Mxkn0Z4Zm9OWDSdCMbgnMvIATbnuQPI2/EEr0d
 PVsDj5Gc3FuCRO92Q5+ThtGtYa277T/0VLQwzHhJJM+3TojEEjijN16
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC8E98000A
X-Rspam-User: 
X-Stat-Signature: s8qiyx387iiegxxnh866cwscgsewyrzm
X-HE-Tag: 1785786447-708736
X-HE-Meta: U2FsdGVkX19vzUqvDPD4FJK6AVQPew7oXrKUEo+uxGHxF2HPjk2DfL9g0zYvYahoEdKYhrh1JyjzeDgL9uN5TAsZHWNprAUZp6fv0lAoQgYehzyP3j6sz5TtFv25yQ/K0XQ4dZBneqS2BfGyjxmdmZbkmg7taNnsG04y8Co9ltMcKTOn4Ku6lpbFKy/4nImCEf+fTAcfqeTUcXbKLu6kRN2cf9ySBN1wz6B27J53vgWNYYlNrGTLHnNKmaMetm2H40iv2WsVCnS3KeOXhDO+v9chHObsRtwsQW15PbaL1eHNMUnx4CSwAT7IE5/jARhWPM4rAt3V40VooZm4Io9sCHhBtRcbb2iM+Ub36qL8nlv9A8EVRPMEgJh5lX7102QV6UnC8Ep1vv2Wra1FYesNXyvExl7e7VT7vSfpC64xW0bFTi80aTBllStpYvMA4AlRyBu08Z45jmGM9aRE4wKCNTw1WT1+R7J8Ea4DFLI84phBugud8Yn9EH2tdY4/r0kvvbzmYk2F8yh6cdf3T+hfRAKdE2pT7a9gKKMHTnWCoWefiu+GAZBRwTXkBNIlMhAHfxurj4K+PrQrpaYO1vAYdpLmgczOoi/Tlqy/BioURmtlW7yuNp0vpaGZ0JmrSFlc0GTWjv1fE63pUPLAb6T49WVzy4HE9MFAsI9ZyZVWB5XE9HE+x+PxoPDHIjZXbuLwy1wTe6Gvbp9XVaUBtBBmp0Q3Twi0chScz06ERCbNyHFy5QK0+LTZDdsDGT5ec20JkP3RsqoElVLKTR7eDPQ4CtV4f8P3cddhI/609JSDexLYH6Jp/KcOEzEaOlhOgvFXANt1fddAvRl9ppdTKI4mCMlpU5oexH+8801oFepLYG8suitJFepzfbkJ+n04+LB+ZkjNLfDoFywmBNuuF3evIe8xOu2cWKPKCJRuGvsxvsGQpGyN9O1ODDaA7yR3GzukCPxY+Dpdep7WY77ZbYC
 t7z7hmcm
 ksIIVpo325HN5gZ038Yfr+Od3PD1Ni1NoiozXeJttFfikpcdWVvNevTTCt72cWZ9dV2CnhRhNfjBJkYmd1Op9i2H2jxrH9JrzfZSyvWp6YzITSzjW8nRg8CIzJ0MHO4Y2Nv4J59bjhZZprhHVh15NZrOmDQu3td4vLwxfXnxT2YDmUL3EVsUhSh7N/XKbfI4gBFVYoPiCCKmybzWcbrymumMCYM95mRnrKZFSGTnvXqlI8ERIvJT9ke8nrEYe7usSTLmVD12IKoEoh6W+ln+X6dUQqCW0Ex6u/RGs/9MMZ8Q6FCHLat3hAOv8jVZQbIU9cPflPKOkRuXqhcWo/sXw7iEC4d+G3PMbmIL3PKbRpkmjG1fZ4hUjGZ90gX44028z8uFGtwuIq1XaroiHZZV/ScKoH2TSpAHpRsg0dDYZE0WxaMPJhYBXHbUUAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For active/inactive LRU, madvise wants evicted folios from active LRU to
be considered for PSI too, so some special handling are added. But MGLRU
doesn't really need this, as it has a different activation logic.

Switch to new helpers and improve the support for MGLRU here.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/madvise.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index abb17760b8b5..f132dd7418f5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -350,6 +350,27 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+/*
+ * We are deactivating a folio for accelerating reclaiming.
+ * VM couldn't reclaim the folio unless we clear PG_young.
+ * As a side effect, it makes confuse idle-page tracking
+ * because they will miss recent referenced history.
+ */
+static void madvise_cold_or_pageout_prep_folio(struct folio *folio)
+{
+	folio_test_clear_young(folio);
+
+	/*
+	 * MGLRU clears all reference flags in folio_deactivate,
+	 * no need to touch it here.
+	 */
+	if (!lru_gen_enabled()) {
+		folio_clear_referenced_by_bit(folio);
+		if (folio_test_active(folio))
+			folio_mark_workingset_by_bit(folio);
+	}
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -424,10 +445,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_mark_workingset_by_bit(folio);
+		madvise_cold_or_pageout_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
@@ -533,16 +551,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
 
-		/*
-		 * We are deactivating a folio for accelerating reclaiming.
-		 * VM couldn't reclaim the folio unless we clear PG_young.
-		 * As a side effect, it makes confuse idle-page tracking
-		 * because they will miss recent referenced history.
-		 */
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_mark_workingset_by_bit(folio);
+		madvise_cold_or_pageout_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))

-- 
2.55.0



