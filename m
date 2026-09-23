Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F44C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62EE46B00A9; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517266B00A6; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B65B6B00A7; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CDF26B00A6
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86A0114013C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:48 +0000 (UTC)
X-FDA: 85246326816.23.4CA2D51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 86D9AC0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b2joWg8Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199166;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zWfdp82h0c1xIWUaJdmtqS394Kjz499++zhqoqzrUA=;
	b=tRMLsJVTG3Fd7uTViEA539xviwMhRytHMWnkqAo6EgHiDwOKvdHMvMHdKlnLFif8VdRZcf
	qXWCBkU1726D32SsGJ1OIe6kejL1BJC4w9agAiNnFcae/NnomTal0aIfP6HsguyORJ65RI
	tC60hKKUK801be43ArEd5ezEmjNd6C8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b2joWg8Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199166;
	b=z6/pwPMS6gYE2IftUMrMtevkcUL8uC2Tk8KNII7Aiey16KF8AceX26yzlYZQpxecDBFpBe
	sjJno4b32m/jBTZtkdVMXNeAgx4mL0OPKMcr/fpzmEE9T+OHNXfCjqPP9P4OLrHfq2094x
	N6oWDpMwOGSICZcRB2/l3/qVgpxNS1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76B0B414CA;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D18AC2BCFB;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=kpGjokCilLiDdPLTyYRNKpK0lLQYtt0pXI1RqARDLw8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=b2joWg8ZXjX02ni3/gODQx15ScarpcWMqA4h0MRuFakU6R9+fcmT1VUFyeRsJitxB
	 t1NFpP8tE6ukgf2Lw1tnm6ps55/Az6s5jaO3Upn4arkUtpEy5l1bbUUkpw+fFBjT3q
	 VSXeFipnE/BbhqMG8KbaVdqstZhDXLfusrn40JKFWv6CLLRogNswv7rg2WzLRO7Nl+
	 ocOaBGRTL5IpcMYLAR6VDpUlHgyIvzZe22tCqBRr/vjSxoeA8Sc1ukyuDVw57ESb4o
	 G1y+hu2u/HSHfCIi3OO6YspJQBmbhjOX800i7jTN45uYSTzfDPYqNbeQf9tj85JwQh
	 p6aUrXrq6Hfug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320F8C98302;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:37 +0200
Subject: [PATCH v6 06/17] mm/huge_memory: consolidate irq and locking for
 folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-6-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=4898;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=9801dxSFmr5iYbSNFCm6NGwAwyCbNb/aE79GzNHnX1k=;
 b=oYvZJrEg40ByRDiz932WhVRb/QVu57xS3KHFRX0EZQm0Q8hhaT4jdmyyS68GO78DUmvQofMt8
 3G05ProET/VDBtsgYaqPJ4gWp9RnxTol4/AHwHcIV8HqvaOtvG1j3Mx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 86D9AC0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: g1zze9n9iq88anik4z83sog593tqo8s6
X-HE-Tag: 1790199166-234952
X-HE-Meta: U2FsdGVkX1+3EyH+S4bvsOfzjMdmmF/rEfbahCXKADhxThgmWLfhqYA/UjIsp24TRs+rnbOXF1JSxIcedJjCJUwFEDh2XHHgGRbTau3C56KONxT0uWEGrqeIqWbaO6O25ynsxM9pmTU8+uiGcumkU5m/M/z6nZ1FoyHBEeF+oBe+izM0wuSmbrYjAHICJDJm9f2+J/S7Ji+4znhYhujyJ0kaWrLo820MyZMPLDxkrXeIDXuXyjNOJRyjtWUvbN1r1R9eAfxjVrVW3DVgOzUMALMlciybhgK1z+x0unbreI1iNKuEHmXbyh5y3EDTR1wk6AimBxk6VCRDtFwSIGxRO/kkGQ4iQ4fa2gRYh2nXFbfTGpTOXZYPpYmmb5GxUb3CojhKCptwo6jlDjAxwR69+xKZVrbxMRlyoli4yjbLf+SSl9AMp0yPQhx8V/UVGIaftQXR+Rcf1s0glkFl0V4jt8ryeb+vdTyoi6ZjxZo8h/0yS4hswQhQPLUj+6nKkKhV8X89w83+svLj5ilSLJBCZLA6prCyF/UvmXMd9VWhheI64bD6vvB+h5mhmhxgcjmD+XQXev59VzAYOsqU7azEbnBJ/P9YsJ4yed6cAOddNfXqzqmuErmTj2GE35hgDozW2VLv/PLscYJ27tidaYzk5WncVS2OGvrXyVInrSwzGp5OI4Xyb2ymktH66bCPtIKiULi+hEwBWx/cE98MwueK0HzuciTnr3sY4oeWiN1L+7LPjEKe4Z6Qw/Al9fAZN1KL4ZFQywHQ/FambQYDtTllZdHR7HWLaHJR64VjnU60LvB+VzHyLv9NJYQ9Jl6/+beNLKqVnvTeRWQKu2Ki7fI2fUc+fJbOtUnlVxLoAc1YKz7Tf64U8BoPbso6wcwrvs3HYH1p5qhsMwOiWXI5AwDYkVNtmR1W7k4wHBtOvaLR755Uck+mlvVJvifsT4e4wmpuzToWU/gJILEPOMgKpl6
 Dk7qkeDy
 38DZuaEUL/3zC/LLSwhlcxz16lmVINBA4NUMAD6XAnNDyVHlvSGAqUzcXUHeKfs0NrdeVGwSwOgLBuvtcyZ1mxCtw68Ynvh5xhhoMRM71EeFRdWNOXOv3zTLf1POStRqXSrYl+w7uXy1gsQ5Fr3sv4mWcN+StL5aIYIymGdndKhZ4+rtFDf5+z/OE6RFyArBYyJI9O+a0p+cJu58Tm9pN4h2D6X2jr2f17P2Hj/MjzQWfaLojH0FPkwEHLS2JOAA9SSAVnWgUIm0kiGGg4ueTtEWVYt09/AflURtK0wTmoZ3uvAPWUOtNzP9pwaECv2xT5IX4eBUjX8QtSII6tdzsebxrCVo7gXCOQsP2KuoMw040FS3o7lU5xvEVONkmfARg0E3oosoSvY/1+vdfptEWewhjH6n0UOscU2kFBfC654Z2KPQ4IyCTrEnUWCJAYAoVcaosvBPrr5PkJWVEZ4oWl8mTjaVGGtcsAs/cd67eOkkj2DfHsy2tWi3qXarCGHM5Eeb6uCeoHptx1EQy3uN+mn/fkqIF9PXt3BrgogjF0X2CLwiOApsuV8J2tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Let each split helper handle its own locking instead of relying on
the caller, so both helpers manage their own irq and locking state.
This lets __folio_split() drop its local irq handling and fail label,
preparing for further cleanup.

The file path now uses xas_lock_irq() instead of local_irq_disable()
with xas_lock(). The two are equivalent on non-RT, and
TRANSPARENT_HUGEPAGE cannot be enabled on RT anyway. This conversion
also buys consistency: every other place in mm/ that freezes a folio
while it is still reachable through the page cache already takes the
lock this way. This was actually the last plain xas_lock() on
mapping->i_pages left in mm. If we are going to support RT, spinning
on frozen folio refs could be a problem, but it already exists in
many places and should be fixed generically.

The anon helper keeps a single local_irq_disable() as before, because
it has to cover several plain spinlocks at once.

The dropped xas_reset() was a no-op as the xa_state is not walked
before the xas_load() under the lock.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 58 ++++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5f54a3559e4e..46712d3700cf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4020,8 +4020,12 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	struct lruvec *lruvec;
 	int ret = 0;
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+	local_irq_disable();
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+		local_irq_enable();
 		return -EAGAIN;
+	}
 
 	/* Take off the deferred split queue while frozen and memcg set */
 	folio_unqueue_deferred_split(folio);
@@ -4069,6 +4073,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+	local_irq_enable();
 
 	return ret;
 }
@@ -4087,8 +4092,21 @@ static int __folio_freeze_split_file(struct folio *folio,
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
-		return -EAGAIN;
+	xas_lock_irq(xas);
+
+	/*
+	 * Check if the folio is present in page cache.
+	 * We assume all tail are present too, if folio is there.
+	 */
+	if (xas_load(xas) != folio) {
+		ret = -EAGAIN;
+		goto fail;
+	}
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+		ret = -EAGAIN;
+		goto fail;
+	}
 
 	if (folio_test_pmd_mappable(folio) &&
 	    new_order < HPAGE_PMD_ORDER) {
@@ -4160,6 +4178,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
+fail:
+	xas_unlock_irq(xas);
 	return ret;
 }
 
@@ -4299,32 +4319,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	unmap_folio(folio);
 
-	/* block interrupt reentry in xa_lock and spinlock */
-	local_irq_disable();
-	if (is_anon) {
+	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
-	} else {
-		/*
-		 * Check if the folio is present in page cache.
-		 * We assume all tail are present too, if folio is there.
-		 */
-		xas_lock(&xas);
-		xas_reset(&xas);
-		if (xas_load(&xas) != folio) {
-			ret = -EAGAIN;
-			goto fail;
-		}
+	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
 						true, list, split_type, end,
 						&nr_shmem_dropped);
-	}
-
-fail:
-	if (mapping)
-		xas_unlock(&xas);
-
-	local_irq_enable();
 
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
@@ -4408,8 +4409,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int ret = 0;
-
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -4418,11 +4417,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
-	local_irq_disable();
-	ret = __folio_freeze_split_anon(folio, new_order, &folio->page,
-					false, NULL, SPLIT_TYPE_UNIFORM);
-	local_irq_enable();
-	return ret;
+	return __folio_freeze_split_anon(folio, new_order, &folio->page,
+					 false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0



