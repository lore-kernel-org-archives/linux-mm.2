Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC4CC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519646B00A7; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452796B00AA; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3412E6B00A9; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 050CF6B00A5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 870118014F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:48 +0000 (UTC)
X-FDA: 85246326816.25.257F09F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 86FC51C0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ev/OJyw7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199166;
	b=oWHKnKWVF/GmClh5bzv6sfzS+KF49MzTmjepnsqW2XgyQWatlPhlgurmqdV1c0V1I6nXCN
	VvXtd0qp+oo2YSYlcI9vbydK79vpY3zlYsSNedaPb1uYSfRRbgS+JD3gCJdc7CsAgKaK16
	0T5CCsWigYqgdGVc1uNP+U/DFm23j8k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ev/OJyw7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199166;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpqDZgax84Cb9Mu25mK1eDqaRMyXmDJqtLkJcLxXiJg=;
	b=A+C2UbQuzcBdxeSWN97zjK4YuFEIlR59MPGz0anOGi2pKcEEX+eCiBLJksq7kcJTsuP39O
	qrBPcco6mR4EMJelJslU/+vVOgqtvAGTZZ0OQTmRGHLNvyQP6dBobpZtTMVDzJOBbXjiRk
	hDGbHAGZyC2S+WsE7eaKiQSFbOVHoBk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 863D744037;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64A17C2BD00;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=iTLZGVjgoHpMRdSYonjQeKB/M7uNxAVPULkag3MrBFQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ev/OJyw7/DMacbSTtZWNQHhKTwrXYmZPZ0IjruuD9qh9cDkOX9Xm1BBvkP5NOqq5U
	 2cAoLJSsz7IzLQjxuqmKe3qA+libAhhTX3ANujwZzeVGZ+X5EHH5FIfwdaKLrgcCDU
	 gWdLhP2I1GI6l9tx7Ij+5X2s/ZJkpdkjjJ998n0Subs2PeXrkYKWosC/g/FISuOu91
	 RSkkl6VR5tTqLmWYWGO3bSyaMDjGAAgg88lbsoDI4PshSEocm21fESbbY6esxHJa6K
	 hAt682SZIbRSH9j9/jeh1d6QNAAD3ZRsmv8LcOmTkXQ76peNLo4aZslyF8ftk6F0qz
	 CJEID+Dbkp+kg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAF3C9830D;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:38 +0200
Subject: [PATCH v6 07/17] mm/huge_memory: move EOF trimming into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-7-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=4114;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Kmu1++mV7nc4Tr+6jZYhD8yAKOx3Sk1bhpFOnueBvVc=;
 b=zHrF5I+OHAffKORsRYYD2Fi/tvD9Tx8ghkvc9fkakSvwsaRzAUVK5dbIz/+pWxzosu1pKyhG6
 Vdc0slLOwPRB0W0JdWLkiLyBvXIbQPXa3NYQM9O96MZJ/A9cPrQlgQq
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Stat-Signature: ne5nuspyise7p1fcht4mazkgps5mt4hg
X-Rspam-User: 
X-Rspamd-Queue-Id: 86FC51C0006
X-HE-Tag: 1790199166-344893
X-HE-Meta: U2FsdGVkX19ymNZTa3TyuPAFWWvIAKa6wTUxJhBy+xSK8Cv59qDBajCbIXJ5wed2cFTcDH54+5Bmud4liLd7VcKKylP1RXXT+k58R7siFmbX1yWwVigH12L6REOL2dq/X4YWvs8tSKXPYmEguDKJfoF/m5mnra2og4LxXLwUufdqPqOGO2jlo6pShzd8qNzczGXSzshaC4iPq8qh1tqH/nVWpTzgo/Zzptw0hsaUzSNJwdBTlMpvywYZoY+VpWG2gSRNKX5kcw8Znn9Gat3QL42xgUaK+/Z5sBWy/S859vwAnVhEjBaVEC+3PBYKV34I7WpfZYxEEFTQAPZi7/YWPVczfUnorM3cihz3L7fhFbcEaHwheTEYv37352ZhmsmyWZ8xxtDaXgw8CH6GX0UrQBSFzj68sbrEHgPPAw0kgzdpXVn5C7PixbuSc8XGNkUcD4atVoDc4rwTPuUUOTqdNnLk9GQdZgBsAZsFAU2u4+dCx8hI65y7TNV8S9qm45SGbUKwDPYZ6BDGYX8jTMB859QOk4DQ96Y38sVVOgn15/Jrq97AdjMIKtRP2QHBDme7sTpNPZSOHxvVjEwZ2netAtFldAJ7nzB9QQIhErRD7sSMYIBLV1H+nj2L+C9HGyZIFSFTBiClYzGpS04xg9eVPSbRqRnNSV2NVmACeqcHlF3MuJelSsMM2vAuotNxsU5JcCaOqZNAjbRN5R91rdGXI+RwxeLx2lG6Gt56vYCkK3WPi/UKawWW98pfbLmU0KBLg/OMZmyjfV+dE7iCFw1J1bh7RElp8g+Daci5lIlAZ0GcTmrqvqP6E/JtSZMIBPPYy2DWGjgzfnVB3yBCRwsc6kS19c4/mgy/QavxQ1EiZPJQv13Ipiz675i6DGa/3aiE3ZUJWAGaaFahRM/VONLhjDIevRXUipZUW8Wmd1ZhAS2dI9Q+bcqolUs/eGvNsgXmedgasL4mCvsJuGgNdSW
 NLyt9AYn
 HpRyyys5mrm1WqHOcI5qIYJmo1vwZ6LtydPONQ70IPY+I4pfRHqZ2ZXaHNyiPZkK4kT/5vJNVBrBmpeauseVOai864IjyKs1T9Iqd75kAxFJALz7pGUESpuRg7uvIJDfOPPVov2BxIrAAshZuhWZaGBFNVjh9J6QIbT7/4Voy/zZj/LFbYs1tjzDptHaO1EgMxou8yh6t4NtPZQBbEfl9KBXKqwvvLeuX18AZo2ujKvjvt6oyX3rNHejVe7Ir5O5nFg97GTsz2zIS2PlAd30sfLLpWmcg07hojHK809YWVfz+TQFNahIoicvklDpF5ZdG6ueZyKwjBxGo+piQAfdlOdhPsE7c4UV1RS41J07JYcPbpQwXvTXRhoIxl+FmmpJ2LvTd/4dE0jdJa4w3occXurE4pLAiR1J5CmNTYlNXccFR5G0iNScEXhuwrxKW+ls9PYWKy4wy/yj8xfNpvMIYE5x4iRB+nfa1DpEi6EIFplkvYNM/U+/btn9wXrJiFE+630dwwCgMuyEwKosB08A/5f7y5L1b5bkE/VGzMdwMkwETji2IPFiVWvIkNA==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 46712d3700cf..625e7987ff40 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4082,16 +4082,29 @@ static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
 		struct xa_state *xas, struct address_space *mapping,
 		bool do_lru, struct list_head *list,
-		enum split_type split_type, pgoff_t end, int *nr_shmem_dropped)
+		enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
+	int nr_shmem_dropped = 0;
 	struct lruvec *lruvec;
+	pgoff_t end;
 	int ret;
 
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
+	/*
+	 * The loop below may need to trim off pages beyond
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
@@ -4156,10 +4169,9 @@ static int __folio_freeze_split_file(struct folio *folio,
 			continue;
 		}
 
-		VM_WARN_ON_ONCE(!nr_shmem_dropped);
 		/* Drop folio beyond EOF: ->index >= end */
-		if (shmem_mapping(mapping) && nr_shmem_dropped)
-			*nr_shmem_dropped += nr_pages;
+		if (shmem_mapping(mapping))
+			nr_shmem_dropped += nr_pages;
 		else if (folio_test_clear_dirty(new_folio))
 			folio_account_cleaned(
 				new_folio, inode_to_wb(mapping->host));
@@ -4180,6 +4192,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 fail:
 	xas_unlock_irq(xas);
+	if (nr_shmem_dropped)
+		shmem_uncharge(mapping->host, nr_shmem_dropped);
 	return ret;
 }
 
@@ -4216,9 +4230,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
-	pgoff_t end = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4295,17 +4307,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
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
@@ -4324,11 +4325,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end,
-						&nr_shmem_dropped);
-
-	if (nr_shmem_dropped)
-		shmem_uncharge(mapping->host, nr_shmem_dropped);
+						true, list, split_type);
 
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;

-- 
2.55.0



