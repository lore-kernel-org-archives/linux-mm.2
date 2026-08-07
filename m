Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B030FC5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D366B009F; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5872E6B00A3; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407AF6B00A5; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6AE6B009F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2A3B401ED
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
X-FDA: 85075735626.05.FEC67B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A572E100007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7Ha1ubr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137471;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNJhV4U658lBc/0r27WEeb4Vzan/a11dGpasVaJnP8Y=;
	b=DxE3PhuhqTS96O4tJjWKPfr0wcWIVubQ7YADOGxmGbcnufDyAVZGLv6ZMOYoccq8eCAHMa
	ZsOXTUwbNWfD8bF5duoIzUxGkb/ySbU/dxpV6XZEZhaCdUoWt1kczSCVtgfKKrDreuKQeN
	Ze5fxdg5UpD4YP/qhP/HniJTq4xOA/s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7Ha1ubr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137471;
	b=8MtQVJbxLH0g+XdeYtv9SMZUh/lJNZWiEWoBUJLVPCpzk3L8elts+fdgcT6ErM/fxoLGJ5
	rHtPWQ9VS0PRbio744ZmzWS/vUYelbQrupcUBPhM/29gJi54rDGbSpENq0Q0YTf+aryVu2
	Vx16PaLNj5Cbx5iTMFGCXtu/dV8FGws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2041E4403F;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7956C4AF0E;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137470;
	bh=qg2voHcSa5lIFMPir4HqweiwxwR7SabRJqMF5KNCN3E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=A7Ha1ubrL6o1rXqEntRyJnY2Ksy7+SmDCTKoqOiTs2GfJn8c8OGbhFUtsPGaGyXTT
	 QUyVp13MoH6DqCIqN7owlQMlAHjEIwWvjdhKCVWkvve/rXAgf621BlaY10vhiRYmcZ
	 DzwW0aLKDorNo13j6KIN1GO3Ce2zSRcEtctTHGiXBk9cNMxIKxMTAB71onUNMmmRNG
	 lYODRGQmOL/iV1O6dZuZb/YmVxXDMSN0QJ+ohkDYOlMxHq74YgfHiJ8FAXFRB4fDtQ
	 OpogQBFiOYPSIRsStU9dbZqZmn9sNJbJu5V+4UXCL6ibupavE6xXZs9vnT4NE91yoc
	 XNVha+PeNS7Iw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56FEC5ACD3;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:06 +0800
Subject: [PATCH RFC 05/13] mm/huge_memory: consolidate irq and locking for
 folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-5-689939a7ccc3@tencent.com>
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=3951;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=yZ53/oBOT/Q/to9ofK8tbkn2yDjvslEEnFYWLgM/+Qk=;
 b=t+/Q4iPxdj5Y5U1lyou6qmjzoFRjzxv2yON8YWRa/nW5Se1WbrQN+JkcG3tuKXkJthj2quc5f
 SN7VLiot+jECC4BI2fikxBSaQEF9iDysr49czZcbLdLvX1sEWJGsXmU
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A572E100007
X-Stat-Signature: xpss45d6693hjimqxdtuhcpcqs473rrx
X-Rspam-User: 
X-HE-Tag: 1786137471-312588
X-HE-Meta: U2FsdGVkX1+OTlroS+P/HhFeV14IL8hDgAH2kZg6d82wV9swrd/U8Y3wIx0OF0m4oqS156VmwQwgrC9EKW140AQqlORPUKyXF7NDtkcgswfuyb3vFAyxve/SY2mP6ePTJY3yp3DmjoIMtmFo4+ssQ59FuysilI4/pahiIflI4vBcBrRL/2xOEu3Pn7asnLPRcd1BqtReglhOfdO1sV7KbaIfJUreX+n+5CyTP/nNbaI7F2zHPTXo246kTVllnkTgIVtgxpgCTCXfyTPsBZHJItWIxmGxPsbiZuAT90r5xshYPQPKBK9Lw3N7FW2IRNxjXd/Lm42U60Ay4CGKCilXL4c/en+5/ynKEhNLAfqA2hYxHYO0B7qisQdP4IXn4JM0ZDOP/sBu+UHIgNorirto6A3+A7by6dx7HYgenlSFTuIx6rOln5WSle9wDkj02NZS41v/WwZ27fAnSqWM7K6WQI/TMEMvHxNfo1g5qfoGVINd1Dy2xRWf4hz29qyTrEs+7jIMezTM2bkZMSEOkEHm8qn/sAVlI1lqawJh/SW2sEIJqBMyqlB+ZKb4TaMSz9Hop8mdwg8Ki6Pdb2jsGkl8b/PwNdtzIkuMaDn5n+J71AIYy8OjND8UNnFjO4UQlyufW4KfuGUOzSMiNhJzpytOJoAoif19xC1VgqefIzRoeg/5Wjt8uXl6K+Bo1sYk23Hr1rQYAVH+qnKL+K49vk34utVIyw/sIHJIHJf04eT126264T8E728mBCtostBiAgPw7jp3tvkTYFhyZlQ+FzpUwPejRkLhNxj6S9BQ4kW4Ge22pL6GyGj4SFnJ+A+C7n7I5attKv9RGPWWgYotwtlYno62ggCcVnBNo9T1jVyYNhy/3JBJnAIEne7BjyA32zbO5K89ZmyZiZNLokPZd7Ww5UowszvU2NbmvfuCfGZMfRL3OJ/gGzLQACfUVmZZhFI7jwvaQnEXm+z9Uvskpuw
 8IeZ4QAe
 K2O6AbGuhmuOQIyhB+oqgXz5D8qW0/7/ZJ6zjtV8NRoblyCOgVnDGSkNt8inkbZVK67qkPKHqEBcVt61VFPKQAqQ/C8+2hhB+yECAHIvuBZpq6pNx9LVb4qQPLMU2ZCczBNVFs47hgijFKiCl/PBoW47IwgJZxnCf14yp2CKmy+vJCUUTI2Yg4ANvmfGuhEKCdyoqhoauFw2Evf68gZ7IdYZIdEy0ZQna2AAxNZ0o0a/LyQpgS9wZlllx7j4z/dd0rG4KZvoKkmh7iBwL8klv1bNs48bARxp+45nCmbyPRLhedNneYWSpbq8NYWRSAfnM30TmPDGkOOn2+M/pYwFL9Qn4YvplbAKPsA4+/xiyOQ2mM40BbaXSjPWo9We2SkFyIpV/sYYqWOJ1pCE7CG/zfEuU4rw6FWGeVW/vN5AgEu0sfxVGDiO90HvgQjB3QrygtgMpu30f4S+nsrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Let each split helper handle its own locking instead of relying on
the caller, so both paths follow the same convention and __folio_split()
can drop its local irq handling and fail label, preparing for further
cleanup.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 52 ++++++++++++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 56a356c30f30..ca9430a6f8d1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3947,6 +3947,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 	bool dequeue_deferred;
 	int ret = 0;
 
+	local_irq_disable();
+
 	/*
 	 * If this folio can be on the deferred split queue, lock out
 	 * the shrinker before freezing the ref. If the shrinker sees
@@ -3969,6 +3971,7 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 			list_lru_unlock(lru);
 			rcu_read_unlock();
 		}
+		local_irq_enable();
 		return -EAGAIN;
 	}
 
@@ -4020,6 +4023,7 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+	local_irq_enable();
 
 	return ret;
 }
@@ -4035,8 +4039,21 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	struct lruvec *lruvec;
 	int ret;
 
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
@@ -4107,6 +4124,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
+fail:
+	xas_unlock_irq(xas);
 	return ret;
 }
 
@@ -4246,19 +4265,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	unmap_folio(folio);
 
-	/* block interrupt reentry in xa_lock and spinlock */
-	local_irq_disable();
-	if (mapping) {
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
+	if (!is_anon) {
 		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
 							 true, list, split_type, end,
 							 &nr_shmem_dropped);
@@ -4267,12 +4274,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 							 list, split_type);
 	}
 
-fail:
-	if (mapping)
-		xas_unlock(&xas);
-
-	local_irq_enable();
-
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
@@ -4355,8 +4356,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int ret = 0;
-
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -4365,11 +4364,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
-	local_irq_disable();
-	ret = __folio_freeze_split_unmapped_anon(folio, new_order, &folio->page,
-						 false, NULL, SPLIT_TYPE_UNIFORM);
-	local_irq_enable();
-	return ret;
+	return __folio_freeze_split_unmapped_anon(folio, new_order, &folio->page,
+						  false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0



