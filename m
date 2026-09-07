Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46ECCC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41576B00A1; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B2C6B00A6; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869E06B009F; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59E496B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE8F080272
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:21 +0000 (UTC)
X-FDA: 85187760882.19.CA7B307
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E975FA000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHiPUYIR;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804740;
	b=b2jdW7/6LPeqpyBGNkJKu1Za9zALNabpRoRk0fxgZR0dXr7E+5TyNWJRKFcDyWEAi4oXlu
	i9Qvo5dgGjS5f/RWM4zy3RYWii7jXoqsJW34kz8fwJEuPs4/pfruVNn4yc1BjBlKdRUujD
	Iln6A22VywRALw5+5HhRUcYf4NLEQG0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHiPUYIR;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804740;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tgr6F0UVGm0ecDJ4GZKPLI/HL/6CkzXFIUzmP/5UA6o=;
	b=k0me9YU1kpgAT/MY5XXk11LY/O5EU74pgtAxYrQ415vENARL+qYSNbVrC7iBowJvQlneNe
	DdV5sLXLgIWZIBFhg1mWcrp0l0qRm5fpDxgSYMTnfbe/44mXoVnTVhuFA7TWKzD4M1Uof/
	bpg11+CNnRL9Jg0YbOTlLfG7IJR5fQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F14F4429B;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 219A3C2BD00;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804737;
	bh=R9EpXQ7qONV9lpiPA+ohrrtEztCFHdKrqYYyIfuXzkM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MHiPUYIRtdY7HIlAIkR5pthbc0iYl3GgcEwafx81eSdxVd5LmTaaKzh/o3a6k2Q8K
	 ND94eX6aI/avv+Ymw+yTd1jutgAu4wmohmp+VhPncy5NlwE8xCfEJPGjtvz/aDRghd
	 UTinD472/q6i5eAAN57e9RurkQh4gURsaORfCMh6W7ASzGKHVQgpt9E2ixm9LbsAdg
	 MH5vQ9JbihRLSGDUXu+dd6GHvTQMPG7YRntPL6Rectr2+0gw4A++NqK3nmnn1JUIJZ
	 JmjLaBlPxo5x873mRYaYvVPtPdqFOrUja7P1vCbBi6Wq7b/orWarztU95c1P1gvc+X
	 RJEdNkf6PyBvg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C922C79F99;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:19 +0800
Subject: [PATCH v4 15/17] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-15-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=2589;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=LPw0g31E5D9zX1H4eUm1VXyklDl8xmiD0cmIubk3YCw=;
 b=H3zOLrM7H20Uz/hjtabEwQXX2WvQZwP9+1s7jTWTHc7SOHnZFzVYPLkFCTTIVNhSmZkWHxt0P
 XxpW4+ZB8q8DZJJF09UiRQTz/rxIMXQuGMgPrgv7XnqMkclK9SKlIsx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E975FA000E
X-Stat-Signature: h7163eniuyz1nwpn4bwwn6xtrignbbbs
X-Rspam-User: 
X-HE-Tag: 1788804739-156359
X-HE-Meta: U2FsdGVkX1/PQvdRSlUQkGODy+mQPPr4xJT9UOopKSZQIdov7bHErAuaGQDuu8iqn9ZPSoGGbbI8gd360f1rehVPK7b722DPy/OtoZmc6sYb36b00VTG4GkbuQ+1sCvPhaERT09pv+2a8uAgrJ0cCePn0uyNwiszWA4iNZUtoMCpNlHHpWSbnEAvhowPRrSc2U6S6OiT/DT+iAoYfSzWm9D4Zo/Y8P9z91DWlUaQ4ev3BSNHPHelavs3P/YBrfEcC3TWVmACBpSpYJs4w9p0sMapljjyjcsfjkNDYYVEOv4hfObtNyf7oZy+8Frfb6DmBySBDWVXFoNdzPzzoR7Q1qmBRMEG3NAItuNsydWB1fzcjwb180PgorRaiiB9yd7nonB0n9A1ROfEGNHdtxYCcVaMdJGPzJYTiX+KTVeNCjnCpnfg2Ue3aD1AL+TkAnYPC5P2Dl6CDvWa0+0oCVMztUCcMQd98Df7OrkSv0Hw2e9fkY6Ef0wK9p5EpiXrfLzQBAKUj8ZPhiEWAMoQFzzi86klwMRLY9mc0bBdJKKrdZNLnmO2/IAb10cqouI2bekOgPPvz5kRztMwWR14Qmmghh9ShLKJPnkGpdAmtQEmOm74GtRKObbJ6iuN4vpR8rOpWOfDAw5z9hXY6zZTREcZgx06XEitjYZ3ik0Rl4/aizc8RhLtnc8Fe0i+jUkc89tbtSGujACjx130L9ocWIa/Yyj6znjR72qbTVYjKJEvx+2QlXtLp+/ROX2Fm9mANwuqP8eAqi5eo2jaLl+2EdyDueQjaf5sdkKftRUL+mCZqL7/VpwNz/qHbhXFfPxMbSbUz1Uy5yhccjpLNVGCPAbH3l7FoB216hQK16hXjOpN64L/c0rmly8k0dP07V8y7cPbyXn3K7Rca+eoNfUextuN9Hdr3ehEl8WdUSVKMtFu5Do30JFxa/cQzE599bHz0Se1+Kz9ahoPiG7/AHEP4go
 pvuxnKRM
 Ma+oKnYWfXnmJ0m1m9g7r3Ekk6cBoRrqv1MEpUgI7mFmSGFrdQBBMBRLH9hyuIF/1oVuUqsyLIM3bM/J3Vf56gG4Uhu7OA60PfJ2mvgfNnBBtH596BiGluK2aTMRViRlAgr97rTlCOapgqod8efTe2pRj6j5c6eTTrEhFR7SOgcYMQgV2Qwe95Xo3VPWc7L/JcFjgAQxzrRjfbUXvNk932VMx6nHu9aZyX3k8XCVy0ntyRallrPReZ+jsY5WbaPVuHVMmLznEy8GNVWknU9dW8b4zAkWRoepHLIRZE9ZcpZdSsuVVjbS7OP30cgmVZpY2AkSxu8cFAcE0vq8FfqAw571in3fgWCk3VFanOcBiGRbv0TXAj1JCU0IC68vSnW5GZXDUZfwS+9QmNxNktIWUABBc9EvpnHS3gXWFHJCuCfbUWOYvvm2DT4aoGw1WuLmh0bFlmMzOHjZ86f+fBR3xWQiVJlnqTb//0F3Ddw/Invf0oKGvt5yXltx+bGEdUgP7W6r2GIBPp49jeGb5qwdjZnH7tJYkouUk52z6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
and folio_put() in the after-split loop.  free_folio_and_swap_cache()
unlocks the folio, then free_swap_cache() must trylock it again and
re-check folio_mapped() before freeing the swap cache entries; if the
trylock loses a race, the entries are left behind even though the folio
reference is dropped.  The sub folios are still locked and unmapped
here, so just directly call folio_free_swap() under the lock,
unlock and drop the reference.  This makes the swap cache freeing
deterministic and the reference drop explicit.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6ce58a5d93d8..f2862556d715 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4300,7 +4300,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
-	bool is_anon = folio_test_anon(folio);
+	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4340,14 +4341,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
@@ -4374,7 +4377,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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



