Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C76DC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25696B0117; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5DE6B011D; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DA26B011D; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 611EF6B0115
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D870B160418
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:16 +0000 (UTC)
X-FDA: 85093505112.07.F745E8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CF1E440007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jx7AR9bR;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560554;
	b=SsMvtUEVb7oHYUVd+weZMElxu0pATQfHXubH4+Xf4fc5SXKy5lCp069ApmCMZPCOaDk62A
	Rr6Uv3G8gEgHotd46tS+Rmzm2W7owN9BS7tc6xU8NlVwUBvMiJVeQPDo+cY3WmRMdBELFC
	jJUrHq50lYPWeqKHBAkCgbrJ6lK5Eu8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jx7AR9bR;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560554;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wU5tdF+3qPH/nAIOmC+HgAgvsSOpukqWfonseAYmIEI=;
	b=k+/y5Qye04JucXuOKQMSU69iTSpWP1vrinjGYItHlsMtL/b++rZczTcJ3hyhxZLaxzfSG0
	my2jn6TPmr7d77c8Qrk+V7nbrgHp0lKw/EcnPnHmax7IaAPIGNCqEpZQc383rXjN4dqGaI
	NENhdfLK56gCHDhfKApJ3LEXNH8obaI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAD5243F2B;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91B38C2BCF4;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560553;
	bh=JRL5pM86B8RFgADsANhqeFbHfvQl3wS3hJzH3CirW5Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Jx7AR9bRcjmrZfLaQWtd8fe5PEmSdMdcboi+T4J8jkJiSwMgJ6RDofNSmXo2wf5jn
	 gbiVCgKRXHCijIIJjgYmgIy8/pi1Y2ccVlWRmFuhrCj0nxozHhmNPM5gjd5S2X9QCM
	 xJwlqPFUUHYMP6k+INE0kugXhfpC2q4zRsxFzDkoT5qy5dtwQBHVrO9Rl7UnKcmtz4
	 72LsYj2mELCumyWyc8T5mQVHE05VBPs9xM+6hVbSXS1poN/JP/J2M2Hok5IcWjl9yR
	 semk8viKUdlkFJtSKOuBLZCmLTqo1aD7BOid1HdGvaER4Dqi+A8/5uRioChfnW8H1x
	 aEAVRuO2EMMpw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E24C5B56A;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:42 +0800
Subject: [PATCH v2 02/17] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-2-d2ee48c6aa49@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=3618;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=e13wjW133ljVhlDYICXRiHfXbLfq+7vviv5uJlt7V3Q=;
 b=xVp6uYRp7/HG2Xn+3DreYkz2asTtCCNkel+zPY2gP9WehszGGj+6N0a40H7BQSS7YYhkDx00f
 Oy19B4zWzafATgehWF49nPpx0JRspUnTs8Fgq8+dxxcLk+PlNwdbWAF
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF1E440007
X-Stat-Signature: 5695tyjwdaanf7n7kuhkeeorz3rphisa
X-HE-Tag: 1786560554-829380
X-HE-Meta: U2FsdGVkX1+LmX+Dd5YxCyLEp8o92MsmV6An/BHfhHiYyBcQgiOddJ76XlqC0ccOLaRd7XX6R3qhTQOtFDJEKW1N+BZmGY/levL9P0PEjomCMUX+PuKqzdJfwKsqa38YL+/u+VWr7hIdznDmmz4VIXFo1jgN4CQwfPJMBoAcbIyV3HT5mFuZNdqqfYLRG4pakuu6E/qnGdJAcvAosnDv9FRQ7yph+JHI3YGp66skjbXyhcNedgUZScSAO2fPOZS2A1ZVLgtkc407a3tP1fVgK4DpU9coY7fijUsQSJxCGB++jwcDRNTxK5G4ccLYqAKVNfgMrz5dN8ayMFJHWiea0OxdQUMGmUBAwZ5yiIW7O9Hrr3sVGjdmQTRiyZAdS+GfhgCRGVLC1A5kq0jWKzUqHteLYXWYdvLdKHr2Qv9CsyNdXAaoJpMhc7WI5RudvbudHk1gtPaKbYb9SGHkG9GjGwjpLOZVs55ojYJ5mcdH0LspJc5ABf6e9CgOjFVv/nDi7yVqhMGNi4XIqtpXaYNXjw1Fmv07aBdxgg+2p5zXXIQL988BvH+EK1XlbvFefKq8xGaZCRBuMPStQrJTTkPeFqJ1+Gp4pxmEPHGOFNQv8v9dO0Ia3QKf0ax0OLJU33e2qOHPm1lDuiDszGP8NBNUr0v8nStqWi4v/5icuB7+XBbXBGbY7OvSM0PcVMwEihfKxqjW0T2nGoHoWOHWK8R/CaRw+whUkj4+f1/O5KTSXx1dl8tU8ItIU9VE9NfZ8aug6PoQ4ZFwlscU3nO29SHWEF2JeWAM1KaVgRL1KwB8TIgFFjh048czCuiPPzcfyY3ESPBWeA3gdswjXOPfvbOx1t310WLHwsc2ID22UfAzd4OxOVH7tPck3VVUbm2LheMgTeNkqXY2zdTLxHE5wk6FHHvTC5da0MDtJXbWBRXm06IJY015hZolHTeaIqM0isA70C4sl0My10IFWS8djH5
 krIfuuah
 HIT7NqP9fSOhFKP3xiE5isq8tMNdxUKvkS0DIVYqDQooIoai+Tq7ZIKVorUClmsANFeL1WeApnmfGA9Zkjr3cTXSGiEuaeqPuSqmASBHM0tQ3xI3NiiWpKXUuyCOlayflyw245IEI6KP9ZX/EcWCUBslfcbHJKKWheLk/RGWD63ptB2qj3Mzq6U95fecGK6Z7hNjft9SCfNnx+WZyS9Bl84Pey8VvU8ZwXNQSaNxu9mMl/QrX57shENPbkAGmCSB6M16y68W6wZ6Eiq6a87TCupl7jaSy2ZiVe9eqfxAcIMsle/VxBbQ7s/h3F5QS7HGzn/bWbRLJroGpTdBpGEVDcFzZDBm3grt9Nu3AZlmWfwLI5mXnn/ULenXUjg25Fb2OTHfrbU+oG6+3e/xYqNrgms3V4jk3dWFXWA8c9K9WQ2iGKRj/yj/1WJ5nMoFFpPACebdibnIwbL6YgVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

A folio in the swap cache cannot be split if it has a mapping (shmem).
The split code does a defensive check for this in
__folio_freeze_and_split_unmapped, after the folio ref has been frozen
and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
rejects the split and returns -EINVAL without unfreezing the folio or
restoring the counters. That error path is buggy: if it is ever taken,
it leaves the folio frozen and stuck, skews the counters, and fires
the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.

Check for this case up front in folio_check_splittable and return
-EBUSY before any state is modified, so the split routine always backs
out cleanly.

Also fix a bracket style issue that checkpatch.pl keeps complaining
about.

Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..a6759a14e057 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3878,6 +3878,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type)
 {
+	bool is_anon = folio_test_anon(folio);
+	bool is_swapcache = folio_test_swapcache(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
@@ -3886,11 +3889,11 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * TODO: this will also currently refuse folios without a mapping in the
 	 * swapcache (shmem or to-be-anon folios).
 	 */
-	if (!folio->mapping && !folio_test_anon(folio))
+	if (!folio->mapping && !is_anon)
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
-	if (folio_test_anon(folio) && new_order == 1)
+	if (is_anon && new_order == 1)
 		return -EINVAL;
 
 	/*
@@ -3901,9 +3904,8 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache)
 		return -EINVAL;
-	}
 
 	if (is_huge_zero_folio(folio))
 		return -EINVAL;
@@ -3911,6 +3913,15 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * A non-anon swapcache folio that still has a mapping can only be a
+	 * shmem folio under SWAP IO, it's removed from either swap cache or
+	 * shmem mapping afterward. There is little benefit in splitting them
+	 * hence reject it here up front before touching anything.
+	 */
+	if (!is_anon && is_swapcache && folio->mapping)
+		return -EBUSY;
+
 	return 0;
 }
 
@@ -3983,14 +3994,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			}
 		}
 
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				return -EINVAL;
-			}
-
+		if (folio_test_swapcache(folio))
 			ci = swap_cluster_get_and_lock(folio);
-		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 		if (do_lru)

-- 
2.55.0



