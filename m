Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00754606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PFxz1lIy
Received: by kanga.kvack.org (Postfix)
	id 28A886B05CC; Thu, 29 Oct 2026 06:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B136B05CD; Thu, 29 Oct 2026 06:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152506B05CE; Thu, 29 Oct 2026 06:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE3736B05CC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DDB3A7D5E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:47 +0000 (UTC)
X-FDA: 85375333134.13.0D67346
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB00114000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PFxz1lIy;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qf8qG507wre4SONZUotxgYcBHB/n//LoEtT0ilQ0jRc=;
	b=B5NoD6x2UafaC6ldVNWrFL3ujrwdQplGCgi50XkePL2taHDpqkYhjwjYAYnIZTSsbpfLZO
	GdU2vjHZ+85MLI4HfptB+YrcUZMuO9xC6adBPFxeE6FT1W5GglKxz3hbMNkN0KBMcthBg0
	IAbLZfFZZTpeS5fk9NM1Etmf/d6LInw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270745;
	b=uiN3RHHE4Mr1rZkQ5BHE45P88jBvs4AHOOSy+s5JPMQwCYXX7hxuNmh1mjGCcqwm04jTIG
	6DEE0yV1RdHi2kWl0WjKqLhZyUazZj51ffciIctmAl7LOylSW5Lv1ymFgG6WgtDjZeHfLl
	mbOxuVsByLe6l5cr8AD2M+130UybASA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PFxz1lIy;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DC1B43EBA;
	Thu, 29 Oct 2026 10:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7498C1F031E2;
	Thu, 29 Oct 2026 10:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270744;
	bh=Qf8qG507wre4SONZUotxgYcBHB/n//LoEtT0ilQ0jRc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PFxz1lIyQ9tq7f0NdG088fn/h2vXLU77RNHMMgt9PFlS9psyh9gYNvZo7eo8PTS5x
	 pqR/abniRuuQqzrpHtJR5vGIY4Vc5fU9gLeMOGoFKNy90leSggqwhMbdhxcaFuJ8o4
	 Kc8PzSAXTGDA6JwXu37HTpMjB+Y28E2anP2vuwZoiL/D3YAcQzTm8PxXltuhBcbQtM
	 6CEEGQDtVn2E0jJPByvw2LL0shlyLZPEB+9LQH4DuYe4SSIX+/+5G6wXuIdo2U3YEW
	 tqsk+KwH4sRTgD2VpwTsNUNBN7H4QBS7UqXsmLMELC6CROD+oCMgEE9oZywZddBnKl
	 eEnboukpwQVpw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:34 +0100
Subject: [PATCH v4 13/15] mm/shmem: fix truncate loop after boundary swapin
 failure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-13-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1913; i=david@kernel.org;
 h=from:subject:message-id; bh=Iz/Ns6ilvBHJdxwO3TPj304o+BNdiHuhjsO9UbzV6vw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4d/WhZaPuvJcYe1etXn+2++mFf6Pr6zOftw8ENj+
 67JO5e+6ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi2asZ/lmcWZd06cS9vI/+
 B0JKL05T3rPA8q7xjiO6dku6J164/3YNI8M1q8PXc2zcHGLlc377pu+vml1cL8NZwBA9e+6y1n5
 9C2YA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB00114000E
X-Stat-Signature: g6jm9zezmee73sckciq4k8u5ygdic7ab
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793270745-629071
X-HE-Meta: U2FsdGVkX1+yzHdbaAks9f0sJhI/sT2ax2wP6u88oCG6KlL2e5ZrWtC2vM5efoCnMYw+hhIFkt68ZlqhhQVnNz8pTAx4C8qbUCqumaMZdBOJpFo1WgMR4K5U29QBF/FcRg/PTkjBOQfwt4dmO8t2Qm3rBGgxjcl4JVDNTMv+Mv45PQ9ZrIjalz3v3KGN7fjPlH7A2DVcAj0/crpPN8ZpQ7tmTFL/NgEtFrZD1l7w/k31+d3sQGDJprlFx12ENg9zz+woTalqFVvBHdkECdZs2tV9j22QV+4YGO8VHKhy0bofyq0w1luWc1NvrGxcOmGjTtuyWRp2ReDIx8+JBzUEtcfAfBdNdAKbWnw4WRMyP0QI+E/mQaqoHB1nNxu5DTJoy8jrEEIV+pcD5hZVg5Ba1/4wnTBFI/flH7kYUtbhp/wkWdbuiDRlmSM5jWDsfmkUNnnm32svjWUad2wAqCXHr0hujdteLAE+SLxDvNA8melB1ayQY8tNAZHns8mePi4dSZ8cxqGk0LDHiqxqhshNiHsoLGCs4j/cy4qoi+pLtlgN+G/tekasKr+jqv6VdTQ3d1l4DT7AFyEhjRPd5epHcrXsFuLmJG41pt38LO620/+J0GJefjuMC/7SXGipz6qC1Q/uyol44oUizoGVH/zLQQx67yID+CjAlVbHoAGQfMF7wJceTk1hoR0vzJLBhAff9ryfAjy2HL08c0mbjoWxClv2pSXLvhbY+3ILmrVhnmTUqx1PfoubKJ44vpEXGP2FcZPnTOYQJacP2Yxc+I/VApDrdbgR+SnDQbW3nN51dH3i482bQLiIRQxUb2gIsrGC7xi79WTnq5iMT/Json9MTNwPcjf/ujawxKlEzqoFlevzq5wvBE5Eu43yZsrS8LW20TUyZbvch7ILuRBQYgnPuzdC0XOR7aXejxLM+uFe3TsMtpyVqc7mPPbKutXQ+FaKmrcObucAJg1YoLsGJ1+
 SdAyYSPl
 3DMSsNeKa7IhZeMI7gvZmMjpVTZnb+00cHzXogeFWOyRRGBMS4bSyoTV2Q1En6zKqKVHNGQMeYzaqcOT2ulUdcVc+fgwaK19YibGzmCONWS2qyjMTF/ugTDgutmvwtwGCW+KXL+wjTFtQupPMs+/TzHDSNsjOtKj9RnKIIbsGXXjyGPAeV07sQSjPCaC3Ps5ya88oRfku93b44NvndGt7/wu59TR2Nj0CwHZano1xFQIU+BWp4oTaGE4MRykbnXnt0mmAI8O0kumR7u2i2GL9dK2u8zKAG7Wk0VDDIp4YKvwi0RTq+mvOXuI3qeHN7oZqKBy0Lx76QnQTxZbzNSySf4QRqW34xcvXMa7XJX4yhkrIyEpvvM6LsEvHHz9OUumsFfDER6Vfkc6nZAz7RcctbaqDSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If swapping in a large entry at the new EOF fails, shmem_undo_range()
leaves the entry in place. Its final scan skips the entry, then restarts
from the same start index and finds it again. Truncation can loop forever
while holding i_rwsem.

Advance start past the skipped entry so that a restarted scan can finish,
as we already do for folios that cannot be split.

Note that this does not fix the missing zeroing when boundary swapin fails,
it merely prevents the endless loop.

Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Cc: stable@vger.kernel.org
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 02de6326ef3b..eb2e6e50630c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1434,14 +1434,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 					order = shmem_confirm_swap(mapping, indices[i],
 								   radix_to_swp_entry(folio));
 					/*
-					 * If found a large swap entry cross the end or start
-					 * border, skip it as the truncate_inode_partial_folio
-					 * above should have at least zerod its content once.
+					 * Skip boundary entries when restarting
+					 * the scan to avoid endless loops after
+					 * swapin failure.
 					 */
 					if (order > 0) {
 						base = round_down(base, 1 << order);
-						if (base < start || base + (1 << order) > end)
+						if (base < start || base + (1 << order) > end) {
+							start = max(start, base + (1 << order));
 							continue;
+						}
 					}
 					/* Swap was replaced by page or extended, retry */
 					index = base;

-- 
2.43.0


