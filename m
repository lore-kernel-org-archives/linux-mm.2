Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED24660A380F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=br7c+EMC
Received: by kanga.kvack.org (Postfix)
	id EA8336B072F; Tue, 27 Oct 2026 09:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7F406B0731; Tue, 27 Oct 2026 09:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E746B0732; Tue, 27 Oct 2026 09:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A846C6B072F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:05:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29598C09BE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:05:01 +0000 (UTC)
X-FDA: 85368426402.10.937C65C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 64AFB8000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=br7c+EMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gxJz3iIJoPNXgIYD8eZpN5Cc5fZ+i/i2TMToAi82b0=;
	b=7ZSVJGmKQjkQEl93tQKFZgZ+jjJibzcgTvpY8oIC02Zaf70VO6IQR2RoaeACyFoWzw3ypW
	VG5nMIUnp7zs3yVCzQ9FbEJJOjaITf9Lhl+8fiE5feICQujqtSsMjFBTXyprREHMwnrfWk
	Tf23sAj/HbEht8LnyHZkR91nl3i15TY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=br7c+EMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106299;
	b=S4umsIa7aCTKAEDAu0sJbd3Yi7EwCxByEB3OQQ3vqU5OLhRUOEe3Vi3GbEMmXsEVl148vC
	g4ghvbwDHe7Pr6ViIgHIuYQH/YCYwU5nDIhAtAp99f/kvTD0nAdoYqWER2bPwtydbXBqXG
	K7wjpjKiGydC/agP054zKTEI86O/W2Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0995960A58;
	Tue, 27 Oct 2026 13:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5BF1F031E4;
	Tue, 27 Oct 2026 13:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106298;
	bh=7gxJz3iIJoPNXgIYD8eZpN5Cc5fZ+i/i2TMToAi82b0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=br7c+EMCQ/TUHTkzU1JNsz8yIvolUd0KfJ8Ylc1U6SapKJzc+kU6Cjcw+cwez9MIw
	 /fNWjPRORj3Xmz17hbpAxnrWX8WQUcy8tZqJoIaqbqqNRWdnbuXuLxj2YgpM4EpW4S
	 MrEKDu17GZd76+ilTKby1yR7hl9ehTRbx6NBcGqFX1pKCnz1ZwGtJS0tF5f2/yTgWA
	 yEWgQr9e5Uvae5C2ERsVG/iHRM/2BAmag2S07Jx/cIEmLJ1ZfkaWNrv/qBOkO4ndLk
	 4OSyA9iO8zYYk2fsjOJE1dRfJ9InjOveaA38Pfy2D6xX2gXegn2N24aQfuAKiheqrB
	 iHH2l93FfP0Ug==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:17 +0100
Subject: [PATCH v2 12/14] mm/shmem: fix truncate loop after boundary swapin
 failure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-12-86a00952acb9@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
In-Reply-To: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1857; i=david@kernel.org;
 h=from:subject:message-id; bh=ayo2+LBrXVmIoxC7jGBY+l1RAqeIKBFNE+ufUyO6RGo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBTaPenspq3NwRUi3Q+9vtUUNcad1tHZEW9w0Wc24
 z4x3Q+FHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzk6BOGf3YrrpYznN1uaBwc
 IOO57IHw/O39zBlXbVVONhd0tU2ULWVkuPfslOfxLdHuS/2DZnzoW+7Y7iT2VC1lYVTFTpnFx9n
 UOAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 64AFB8000B
X-Stat-Signature: sumnnq8yyci6zi3qyzzegmbpn54jkg75
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793106299-458261
X-HE-Meta: U2FsdGVkX1+NHJg1Sd4yp5G13FaKEpcBU4s6hWOuLkxMuy3Pmd02mMnPFmtwRjOhYAntJ4hsg+s47knx5zXPM/SJy7DD9DtEj913g3tjiheTMBcI8qkRR3NjtflDzwwocNqIy1iw/8cUqo7AttZfDV8zxSZKT3IMEjzS78aKLAHGys2W1hTYuxR0pf/rpLUrfV6qMvJFEf5xbq/w67DrhPSqcPB5TAMhYPfMnaoUJoV4EmOTrLEF3KHIhjlvf/pJkv651fWxbj3B9MDkkvVPcO3beo7GqzeEFWK9EH8GWbwdx8i3kVtMfQvRmJy1z7I1NClgDXDh+EzX3weE+heANhkEZnh2b/YgfzW9EqU6a9Nx4O7REGVxt5AxrhBrI7tEeQu0f7S2q23aGtRHAptsEoJqsWAsCT53HwBuCxosdCfyDrnzTelnv0EbLYwQmi/FV6Er/KvGPgbHQNWMY+snnAb/4/R7XSG4i1C9aqgtAn+JzXbDNEZ/Kngbh/zMB1qKd05bqPxZga/6eZnu4AEPkeAcmUaR55yXsx/59MoaNrNsq1n6s5Y9lOYAIYLFT9LlYcnryWxIMKdkv4PAQ2dE8GjRVnUHXu02Raovj7ffl/lED8MrCma+av9BkhPpjYLf1T7EntTD5pgxI3a9xAJ4aBMPVwK54+8L188o9dsTK+bJw5DjfyyIVB2ak+cH2hOJAE9/gdhTCOygVzBZFbXNRLclAKLqDZYtuy/ZV0MGfOqG6IAXQLpFFAbfqNWYRrfTtRRjIWgsyymy3ph9TXygU8KLwUcTMFiZAwvUbZeO0KIOCaD+U8cb30ppxY51JHDcSBIk4BIu051AzLQcRS/sTFZ1R2REVM2KDtjwTSs4Q8b92H2wz9lmLfC0jrzjCuHRATCkML86s4OC2Bz6bviyMLur9XaZEB1EPUgnJ+xbQyyDLjauhN6D15LTP/SukHEYHD6Z0+YAHrEBKGxWrgK
 IEWSs85+
 BZoGgwEFMwQVZk2gyEolKVo9puE48MeQOcJqjrXvj4vBsq7oRC026bwYps7DxmTYOPZBDyV32XcNxLDfrKm3ehybg6rw7pm8hzpgxgF6kyP7K+tX71wojIzHf0reLIWg3FNntoRGhuStY2B4lQcO0QcYlhqa5yNtgeVn66Tvk+KTmJTQitIlz2YJbrVSmhbcMwLaMStfVpUe9937r5zFkE9Q8cWhn/wjUEaMQG8myC1y+iMBUPPsBaIDFwKiPi3oGiJzuUtN5dMjFes8JzetMS9ji57JH6eSzG0tMSuyNSqvgB8QaXLusVILl7KOqz0O4eHGEn3jabhLjc9IgAuI+bjNTIKzkmMc4w///4fAt27dmgZZ37MhBj7NWLYN115oByqRY
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9a11de010ed7b..4ece296a1ccf1 100644
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


