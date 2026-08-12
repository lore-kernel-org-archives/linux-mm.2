Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A334FC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6B66B0130; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4086B0137; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A806B0136; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 243346B012F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 634AFA0446
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:19 +0000 (UTC)
X-FDA: 85093505238.28.9F7770D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 550CC4000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cwDHP1bz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560557;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Yo7JBF8xyJG/3ZdvHkW5ChARdHgrsT47tnv9ry46xk=;
	b=Pa3yU9OwUNKHZvaFZFML5yPhRpPDoieG5l65YAa5dyVgLo4IwSGt7z68U210+tPmlIPBLh
	hwt+R519lwIpdpezi3kXEDgNXd+XPZ7gHNOejoQHzK5KmJfxf9Zp+ji2nPiHJLeRyA3b2F
	rc+rXXevtr9rfFv7mkzzSh6lfKdqF6M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cwDHP1bz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560557;
	b=FPe/sV7/vt7mEt6cmyJnSwP3oplSmW95XAhGfSzeZwzB+a1yMoCwCvGeoOgMJJ20K8kwo5
	g0A7kDWvn4+yDW+iUqao2J8D68m/i5+s3yx65hE+PhZ3k8b+8mWzUM8IzFy2e4VscNJ61q
	y0Jf8Pcs+D4nS0xSQUI7oRMA4RlYySc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11EAB4401A;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8864C2BCFF;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=OnHSKfnQxoycgFQgDUmNgpdMiqrLFZGFqsr5+cGdiJ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cwDHP1bzrl8a8i+K48g3YNVaP+8J/xaB0kG8/+ZgF5QW57aLyF9qpXoDQAdgGh4j4
	 8dyd4JK6kaCAK677OaaDrzqPhX1jaIEP426Of+fv4tHs8b6xE/LYFckP7Cwh5wZv30
	 b+tCMZyI6MNkbPAyWdH4bBbN/0i0qcv6kG8nBZ/6FJSTh2S+gLc0xk76tIPDti+4lo
	 TRbVTVoILau7Glj9HIXHd7LT/iyeh2DG9u7Ws9bKfaqxylMtCLxdBJnA6o7SAFb6Cy
	 9wfaU55p0Tb6YHliLZnwM9d4C5wIc6ECe/morO6yhi4aA0Ngb0KzheVFl+iYUCXC1q
	 dBlWG+T8pGjOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32D0C5B56A;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:46 +0800
Subject: [PATCH v2 06/17] mm/huge_memory: consolidate irq and locking for
 folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-6-d2ee48c6aa49@tencent.com>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=4783;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=i75VWCkQ8jK7NZAq0hH8d0si3JwG/+ahq4sLsBZtBsY=;
 b=YuXMwQdPjrVH7JhAsFv1+GMWhTDNt4GrjxOpz/CbWpY988UPpf/8oMJOsueu/u2QCWRxC7cMz
 rt1jsToN6BEB5bcR3qmcv1GzRJD+8v4jTXXnCXoUwhlStZkGHo/vOgq
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 550CC4000B
X-Stat-Signature: njr79599ueiqxjphdj9ce46ttgi1ifsm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786560557-1548
X-HE-Meta: U2FsdGVkX1/+WlpMB00WZzVgbJFZ0IWPB0IVEuEB43wXUqZt0frxsLZUlAFK7Atyz76UpVjUosyndTJGhhnS9JCFNKvShmi9pSIdRgOJgAPPx9wTSYiUuap1kRT5FYWWAJjXgoBKq4nlGI05271sFXGdx86mV3Zu15N1k+8nW2ig5A+dY4OvfoG5kNtwbrkSl88ZBoQTA4y2qzEjO+iVzcQyClV554cLpRvOsC6rWFhzJ7uT2r9/pcVqtCOJKtxN1vAuXDmw/WOQ5LshGwNOEC7r8Zyqb9PNGpdwXTz3b9JoJOk3Ri0sA0AfoKu9EUk3E0XLztH4SvCcyXxp+ZdjR5YiAD+VPQgEreZUbDnt++CKN7bk+1cKYzkfvNqHJRm/AF2X0Sxrvn/EwZowSP2P3VjobkmSctEkc1LnYPbFZ56PqxSFL46gquWeZN0G/SOhpRV6opnngK6tWCE1TZh3fAPW3gFOSGu+g/NbNRC70tqMTBni2VOdGEjxdrdQbr8yPJD0I63QmR6MJ7Vr9r3MEMm2zysTKNZM5nikkENHrCbJqwDPxjUvzCfd3j0kPB1KkSQI6r+qJMvH14t3cBITCNm5+lV4rSLGQYh3nWE6PFcFENrUBLvZe3kjZ24A4yVlb1c2d8QdUJtYxWcQ/TBREfLgCawe80wcWve7guKAm173pBrdzpqIgXrU4uHK59e5EunxcRTUpaO7I4hoj+QBZR2Vcn6PclK9QP2cO8skvj94FO+6bgpmhDxLz1benBADMz975ewDA98dfaqZdyzAyJnGurnp2DpdHJ9jh+OmII/1JfKUHaiAALPg47d3qW5BxjwFur5pmVi3RT+X+lmVI6+sx8xbosjEgdwG8Uzx7HzZ4QWknLUageqRoY0YKgcwFrkW913ByBVjViRvbWtfGhdubXCfJngw/9bvAE3Dl0xGqGWI7jhDzm7n0V8E+rufvX++Y/c/sgk0tmn+RSp
 jY8ryCpD
 gU2eRZtPZw89R+EUUcmTFI+6LZWaKXD656+W//iZcEIPRkWD2tR+O8sYTlgOPfwNu1MkAIG5iGDhTmbMDn+/7v+lhQcvct358kGoCxiiYN9tEQfh0mPebD55QV+fBHSpRYcS27OG/VT2l8rKs0O1WiVs9KwEaRivvEOBVWbktUstX4hYQ6MAtcWNYN+I0sF9R4yJJTEvvjmF4JgHrGwCoWh5UWCrYWt31SiNtuTxb85JogWFeh+2+F0qAb0C/7uDG6sgfio5hGthsN5ePrdoqNcR9RD5ZONpgdwYI2J+AyjyS9qp4ZIOpv0E8Ta36qQ/75UO5vHhKl1oFyiPvCIxfvRDfEzscf2Rs9P2Z+t8urjqbyus5YiT5gC3WFGxYmJT+0P6/jLmnD4CJ5URQaq+W6SM3POCCvOKwb6T8g0Yt6Zaiuiw8GtD/oHp1hgUnR84UiWRNklXDjlPPb/I=
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 52 ++++++++++++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dfecb93dd64f..2cd53afac63e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3958,6 +3958,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 	bool dequeue_deferred;
 	int ret = 0;
 
+	local_irq_disable();
+
 	/*
 	 * If this folio can be on the deferred split queue, lock out
 	 * the shrinker before freezing the ref. If the shrinker sees
@@ -3980,6 +3982,7 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 			list_lru_unlock(lru);
 			rcu_read_unlock();
 		}
+		local_irq_enable();
 		return -EAGAIN;
 	}
 
@@ -4028,6 +4031,7 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+	local_irq_enable();
 
 	return ret;
 }
@@ -4043,8 +4047,21 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
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
@@ -4112,6 +4129,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
+fail:
+	xas_unlock_irq(xas);
 	return ret;
 }
 
@@ -4251,19 +4270,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
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
@@ -4272,12 +4279,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
 
@@ -4360,8 +4361,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int ret = 0;
-
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -4370,11 +4369,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
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



