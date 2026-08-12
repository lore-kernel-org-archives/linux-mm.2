Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2316C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F696B0135; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C68E6B0132; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13AEA6B0132; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B18506B012C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFE0CA28F0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:18 +0000 (UTC)
X-FDA: 85093505196.03.E199D59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0A45620006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfXw7+Kr;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560557;
	b=cCO6oG54sxulZ3wf7ImOf4Hih3VuNPm9CA/SZHhCxtsknBeyP9kFunzVN7whGkJOjsuSHF
	ofaGdAxT1HPL9PkmqiMpX0jcwscoIl6npW339WQE5QiCXC/cT1jFLZgIFvl48MSmCVR1lW
	rBKqgJWpqQIhhge4vUDVmP0QPw2dLc4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfXw7+Kr;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560557;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZURAupjA7/Nu+57EONIocfD17lQaxtkob/Am4NSvjt0=;
	b=E6DqP2/LkWBq47I++EPZGIn9ads80tNOqTSejosP9kNW6/oYztBF3Y1C/39MYj3OyhCToz
	TZYBw8Z6uzqdnhErLoY19eJ+WtVT65/rBzV5ZcC74uYlJ5ykDvje2shv7wyl65fcKPJFgy
	Ed+IUSa2GMs82nDAU+grKG5hVhE2Tlw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2337E44043;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05549C2BCB3;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=tz1pq0t1A51RvfmwONATJHgMHYxmESpNAK86660fq0I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tfXw7+Kr9w2j+mHb33UODxwbxLvec/talBZXxND112xG1Nn7auZ0ioEjATtOHoj3s
	 nxXBk1rqlIRpbgWkew0JkccFGGFz3vyBn62S3dIyh68qy4kkyAVTEaGBUFHDTIgAfJ
	 Y/wATlUJ7PpjmqJEP00o20dTtO88UBqH+cWSyn6CnULMjsRrmZUhE6pzpyt/0p10zS
	 074fK8A0GhcWPG2WLMTwhN5FJEZAWHjPkxt5yeHi+eYzTc+FvmYx9Q7vTyNXMf1dq9
	 12Dku5xUjX6a2/DaQo+CQJnY91+8Nc0xToyDSJLiKKwq9HJqYeMTY8SnmqjI1+48J5
	 /FJJA2/TBFo/g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A04C5AD5A;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:47 +0800
Subject: [PATCH v2 07/17] mm/huge_memory: move EOF trimming into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-7-d2ee48c6aa49@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=4165;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zbz5fZUbRD1Px3Iw/cdSC2QmjwPbOSiKdK5oTzkxXmg=;
 b=Y9xtbZnrbsxp2ImoeO86xo/a+HOaqWOqCfBhkc9UG5YII1EUfFlTPgbGfRYjXvBDxwHNL5zR/
 zkj1MRyflQoBzwx/NR0G8d58RSTAmCPXgnT6WN+WapyDx4F5vTM+4u3
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A45620006
X-Stat-Signature: wccr7pftn96k74chscfajph4yader791
X-HE-Tag: 1786560556-756652
X-HE-Meta: U2FsdGVkX198PcloeYFTe/I5m9ffmEHxRNOU2liJ77QhG6cv1G88dBEYpX+Ie5dE10l226C9YTVH8XWCb2B5X+2pBAr5dd8dAnaRCvnip5J/zOpABoeBaS93px6Z5Rcfig9J7h9klxo2QcJkRVsKYUXdGa+w3+D96vN6kfCKopm4/0HQXgKawqlZswS1nM4OrThbbIrHVS2TMYHtqj5rHNSO/ZeKDOatfMEin2UtR+gblOd87fma8G3E+LR2wKZUana8tZrcNa9KhkZKUkq6fk5vy4QD75ZvFJ4oYXOPjIANEBXrGorCVGYT2Y/MDJYppSNCDLjRafbAbAmfgdZ4dGjAs/WPSzqtEJJp1hViqDA+wym8emPQ0r7mzdlOODV7jOjTQJtciN8k2iBQszDUmPP7MPWJhMkq/nz8FbDZnj91uwq+PjUaiaZWpbm6LWytMSKxos+B3EC9LlPZkV5o8ebVVwvNigg0p0joeTq1GM52DCuhPCQ4mxpKXa+uL3r9ewLuJnxK5BDuKgGWIqkLbb5AfOVPO5uYdHZJK3/5AqkLOPYYZZ+GVa73GyfL9t1g//wHG926lN6Xfh5A+Ez72/APVnTawmVk3fD/UIuL8ChHe5QkT4cRpDZn8oefAkkYY7KpRGxezhdBEtJsbvKSybPlgumPNNVB+FQMX1xg6Db0yFQ259N1uH0RGuz40F0AiuYqGup6NzflpsbgILfVa7WdyOBofns40NqJdZpjyy2tlRuxJNEvndterWUzGSdXtY+Cat+rA2EM9/8nD8Gf/H7TGIoR3DZhP/e3oJmlj/+x0JTtKSLigHMxHgFV4EO19glgzUTM9sym43qr8oUqbftEygTgNtbId/EeKOAbs+53yQR2+eR8c+9ZQbZjrtK7uG0VsM18fwXYKyBgYlQsMlzwBneleyOCY+w05Qo//0kv8HjqZ1LoTkCratCeTmz7QiN2LfnWj73PVyJQMpI
 zyTAENQ7
 mTb2dLKiwY1HVHT2PwxkU01Ivf4CkE4vloKA1x7faUxwP1X7vAOZpSIWXGG6Lb1UNGG1lXVgEBYArWx19PL/ih4qxsB0ZxCL8MMWYro8GfAL6t+FXo94asU2twB+UmefgSZNbs4Jr373A9jPQGFgLwHtlGUsa/Sw2AKPH4gKmGtNaeQ2ZVZ0y+D8XRRBUMh7I4UBhuniiOIqpCUeffsbtPAjuj1/eWnFSrONIa7nMPTMMHjMBt8myktn3PPw2Uf7JynncJ+82MdhU7cFxfr90rXitfn9lEZRQEI0TT8G7aMnYr0blSdAmKOqhfkYcZTR0VSciBNg9T/uA5KP3BgYV2lLE5wPIjWOSMTi+lGU6E/3pdHg7URB/HsCVBS8A2eBypOVDiCoWhLg5I7cGPfccrI6xpm+fs0VMNCKGlUAfiMZtSc0ekRpcDlpOuZ/HlkQO1S5p7ahyTYOes/sCwu7ywX9q3V2/CIz1fc5G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of receiving @end and @nr_shmem_dropped from the caller, the
file split helper now computes the EOF boundary and trims pages beyond
it itself, as this is only needed for file split.  This drops the
redundant parameter passing and sanity check.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2cd53afac63e..43093b9a5bca 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4039,14 +4039,26 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int new_order,
 					      struct page *split_at, struct xa_state *xas,
 					      struct address_space *mapping, bool do_lru,
-					      struct list_head *list, enum split_type split_type,
-					      pgoff_t end, int *nr_shmem_dropped)
+					      struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
+	int nr_shmem_dropped = 0;
 	struct lruvec *lruvec;
+	pgoff_t end = 0;
 	int ret;
 
+	/*
+	 * __split_frozen_folio() may need to trim off pages beyond
+	 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
+	 * seqlock, which cannot be nested inside the page tree lock.
+	 * So note end now: i_size itself may be changed at any moment,
+	 * but folio lock is good enough to serialize the trimming.
+	 */
+	end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+	if (shmem_mapping(mapping))
+		end = shmem_fallocend(mapping->host, end);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4107,10 +4119,9 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 			continue;
 		}
 
-		VM_WARN_ON_ONCE(!nr_shmem_dropped);
 		/* Drop folio beyond EOF: ->index >= end */
-		if (shmem_mapping(mapping) && nr_shmem_dropped)
-			*nr_shmem_dropped += nr_pages;
+		if (shmem_mapping(mapping))
+			nr_shmem_dropped += nr_pages;
 		else if (folio_test_clear_dirty(new_folio))
 			folio_account_cleaned(new_folio,
 					      inode_to_wb(mapping->host));
@@ -4131,6 +4142,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 
 fail:
 	xas_unlock_irq(xas);
+	if (nr_shmem_dropped)
+		shmem_uncharge(mapping->host, nr_shmem_dropped);
 	return ret;
 }
 
@@ -4167,9 +4180,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
-	pgoff_t end = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4246,17 +4257,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		anon_vma = NULL;
 		i_mmap_lock_read(mapping);
-
-		/*
-		 * __split_frozen_folio() may need to trim off pages beyond
-		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
-		 * seqlock, which cannot be nested inside the page tree lock.
-		 * So note end now: i_size itself may be changed at any moment,
-		 * but folio lock is good enough to serialize the trimming.
-		 */
-		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
-		if (shmem_mapping(mapping))
-			end = shmem_fallocend(mapping->host, end);
 	}
 
 	/*
@@ -4272,16 +4272,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	if (!is_anon) {
 		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
-							 true, list, split_type, end,
-							 &nr_shmem_dropped);
+							 true, list, split_type);
 	} else {
 		ret = __folio_freeze_split_unmapped_anon(folio, new_order, split_at, true,
 							 list, split_type);
 	}
 
-	if (nr_shmem_dropped)
-		shmem_uncharge(mapping->host, nr_shmem_dropped);
-
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 

-- 
2.55.0



