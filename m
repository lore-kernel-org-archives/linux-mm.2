Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78618C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721116B00AB; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA466B00AD; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2476B00AC; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 273006B00AD
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC3DB80140
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:49 +0000 (UTC)
X-FDA: 85246326858.29.808EF5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A7E5814000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iq3SdsXE;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3xfoaw2Ik9eksYSXTYv3biYhOxKuOQIl+7U4tKFMWI=;
	b=RFEJfg9Ak3onuGPQsLjvYHVkYffrBEwXgRnUkFa2fS+P+AnW8U2D/sKZGiwVEzZP4uqZhi
	5TkCHG2Sj26s6oKYSrkuam11cUjW18S7qhNpDnCbJXYyEOpFCOmwSt7KpLFybvhOyyNkBj
	FedBtPQK/Fm+M446Rd0XE+7St1vPHPs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iq3SdsXE;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199167;
	b=k9QXtw7fAp5O7LYwn+HdWkwzG4yG/R4ZAPXRhDqInzx56o1fat2IAQIip4aS3cT9aSYDbE
	HwSJvIAfEa3D/FW6HlZZ02OFcIAlrfMXBux4bIcXeD0pH1o9iFL6LQcr+WQA6lm3cCTa+7
	ktAf8hspFty/knP14/nEOcWT24ERwSU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EBF8447ED;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E058C2BCF5;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199164;
	bh=1HjEP9h01m2os52VFtLg0w0k8h9JkhcfR+8oAefYrS0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Iq3SdsXEQ00dkvVhZPrugL6rHpldJisSBZePiddEKfdn7c9bKS4FYwE5U3XYzbnzo
	 ZIK/wNtGf+G5DAXqVwC2Gj9FJh4IuwApuB7uSan3rFc08k4Ah/kmmFmUCzrP5Uxp4I
	 Spij0Bc3DpnTMn30vwVOU/odrNz/Wabnta+rmDbLcDJfOVmO50J8rePXyWG33V/TsW
	 U9F9TnLxUM7gfJioGql2jSF3R6fIZ/5gmLZXe3SesmMw3FrwmJ1BQHkatyvRXTT5gB
	 dAqu4OXdYxDmLsBqCsrC1HutgWfncPcXJmBmcl565cA8Nrr4972SZ1XIYg+MYtBqgH
	 mS69YZjuBklkQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C2BC98311;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:46 +0200
Subject: [PATCH v6 15/17] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-15-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=2665;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=AQb8VGHmCtACgG3BJvB2LYY1R1HEBncd5BHWOwnHe8M=;
 b=F06ZdTYwgfJVEsPAfkgvPL/eTORiKnaXRd6FY2R/9M89Xtg7PMRDlyTl2fjhQ/0e97jYMuLBm
 bmbM7a7dTJTAjsXllyw2lbB1vjd82/tlqbPT3RSz4CIb88a6/Wu0Bzu
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A7E5814000B
X-Rspam-User: 
X-Stat-Signature: bj6gchb5dxhjobxjeozziqj5z6stf578
X-HE-Tag: 1790199167-341433
X-HE-Meta: U2FsdGVkX198tl/oZ/4J58APcLMp82MzkM7Cnl1UJxR0gLJ5Si+5l+EQ5HkKt++WTiMvSvWUy3l6r9dZZ5IY6oyOXIZz4HWlCUl/a2YrpLO/86rfa6N3uv08oIF9gx7mU4AFlt0j/MJqQqipzpyTDriKDdXLoGWo690Fzjksp4mpu1IJDcBSwnhPpOiHYVh297t8qLx+LEqO/Qo6uNWGWXdj12qQmnAWDYWwSm7qwCGwuvazwHnJg0x5094TeT94ldWBcNuqukAJMAGx+XiRQ2gfObtw8XMgvB1yn0FNsNeqxZuPe5jza9HafUuJzD8iWMlSzlA5sc84gBdpfjne1iVQc7ZTwcbmkDXQzi2ZlUEawftskx2Ps4gs6y0Lgbf9oR2gcnorOYFVSubnH2PRzyzmRXgwvzIRFzGwG8thLrmFumZzwYpK8TB0X9pDzNuqcFsknG/vxFbfYC9s8ABNhBlP+48TLOOceYTu4jBDIMNutxo5XsPIijXdfuomAAQGveOqSrOjBEf4uMrmQsbA/E8KT5dmHt+MRTiW2vSvvNDfeHbzx6XVH2+cs2ipCCYpll7O0DoM3zACMoMqexQ4Bccfj/HaaYkwldE/ufAXXvrpAkS4dnygEc9VB7nUJHiw8h8vcEllCv+i/KVL29CDFa8aJF3Z6qQpvYaWLykOr7j4f2x6lyNMb/Y941iDC0g09c1lz3XYp2zcagoCscsRFwgaqxKNdiDMo7KpshKF6R2AtVo8hKCzGZgJi6BYdRo00nqi8RB7DnYE7z1dMcUcDLTEc+IhR8OrIf/lP0UGQK5y2G4w9SXtKqbrtoOV/CXyC/1m68gVnRt6PsMCRfGKSVSElb2+w+lk7CUJjVfiXAOag+P1965iCYgXitFsLFJQzzU3eXpfaY709O/JhjYhRacznyA0GYoOLi2J0hzx/n0r1cuavfhTbfrSmhltZkhcHuLdQuMjNy0/zZokWXM
 8dSJnp0F
 Y8dgJV5n5vOOMm9F6lYsEkbx/vLgOk/pzmvLBjWDFSdqpJ67Qg5Zda8NQ1U9vwgOmVqFLjgBCB88LAWhG1GpuKzpoiGkdxs7qjk/X9g92DiYDD1a3lyotA5jQPPZoLKNbDLVWXH8PnbJpv7BJXCnnbZ+MOYqS8RWEnsWAfQK4m2QM5yUaHJrWOEYTE7X4ENxBOmkF+tZlqxUd73c9wqid2WifTXj3uQdhm1hbY5pMrurJ/PkNxUx2y08Mv6hjhZHysgfZBDMyEXahZLZZQrtzIFbJDrfdpzl7TqT3bHwx+gvn9Hm6zYh1ZFTQBwUX43bmUQ2MBgkO5JeWPg2YzuCcQxCOnV3OFxXHaMvU3FFdujy8rQ7zXCq4ra6e+eqPxXNPfxE3ktbPMkl9q48nyHaDvMlYqmbo8imdvr+o/c6VrOlT2GWMJOvgz4sfAav6i3c8HYmegWFXmy2qUgm0AQe+HAObmkmn5XtieVhai5DYoVlAlOYIO/OAEmeWXQO7VBdFGmzFeRK/8ntg5wgYdzgsGk7vBG4kSpkJW+oFcrMwmgd+gDtMaPbmBk9ZCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
and folio_put() in the after-split loop.  free_folio_and_swap_cache()
must trylock it again and re-check folio_mapped() before freeing the
swap cache entries. If the trylock loses a race, the entries are left
behind even though the folio reference is dropped.

The sub folios are still locked here, so just directly call
folio_free_swap() under the lock if it's unmapped, then unlock and
drop the reference.  This makes the swap cache freeing deterministic
and the reference drop explicit.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 86583bf1b148..a98f447ae78a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4325,7 +4325,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
-	bool is_anon = folio_test_anon(folio);
+	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4365,14 +4366,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		if (new_folio == page_folio(lock_at))
 			continue;
 
-		folio_unlock(new_folio);
 		/*
 		 * Subpages whose mapping has been zapped may be freed
 		 * earlier, but freeing them requires taking the
-		 * lru_lock, so we defer put_page() on tail pages until
+		 * lru_lock, so we defer folio_put() on tail pages until
 		 * after the split completes.
 		 */
-		free_folio_and_swap_cache(new_folio);
+		if (is_swapcache && !folio_mapped(new_folio))
+			folio_free_swap(new_folio);
+		folio_unlock(new_folio);
+		folio_put(new_folio);
 	}
 
 out:
@@ -4399,7 +4402,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * isolated from LRU (if applicable)
  *
  * Upon return, the folio is not remapped, split folios are not added to LRU,
- * free_folio_and_swap_cache() is not called, and new folios remain locked.
+ * folio_free_swap() is not called, and new folios remain locked.
  *
  * Return: 0 on success, -EAGAIN if the folio cannot be split (e.g., due to
  *         insufficient reference count or extra pins).

-- 
2.55.0



