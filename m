Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B362C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A256B00A0; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849896B00A1; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC716B00A5; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 320EC6B00A1
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAA0314013C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
X-FDA: 85246326732.11.AC22C88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CBE88C0009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U9Y8ZvQ3;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199164;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTcd7Z4JwHMYpEkLXpGH7PIeUJoC3ihNKGSmhgx40TI=;
	b=4F9OWowZ9JaU5wh16pXyBp7uhq+4itn366VxFYGCYl8afywWeKtdxhcI98KEjb16XLCJO/
	MYvEcTDCS/8d+LgKkF7LZy8sTUR21E8femI55XaORIvl1AU2zo0/QXY4aTpeHZHTFx3VRE
	VVVlUmB97BD49P3OzecHEEAw6w3WcJs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199164;
	b=o6cK0iaxUQRv4P9HRG/ggFLdQ7rfX+hPMOwh5k/YaaI57lmIT31UeK+ItNpQ0iIDAfeBil
	nQixDk5YlJUkZxYMAwgGWUTp8nTxMLD/ULk/Z+ggAeP4+BAL6bvKYu2cjnDJi7DniTJ1UW
	7uHLqBBtyFdRR+HbXnSGOOFUXqRBNDI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U9Y8ZvQ3;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59CB6601FF;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09362C2BCB8;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199164;
	bh=sOp8u6+5I5kr8seW5fU3M5ogXFq82vrw4VOqm9lx8z0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U9Y8ZvQ3t8OG3KjhwXTUtRrGU1BzTZNinBYYaxRN14jp88gBZArAUQUavuUKo9WMx
	 oJOFNChjLUsyzXhp9X+J1lwsMq5RyKBzcEkxF1NUMYFtzPNNBavbB9fZf98sKTGtDx
	 quTZW7p+WIVhDkxZ6Pmr+kX9kSc6ufChnRCEhkQbr9jhnPFnhSgMU/HH5s/zrltIRh
	 KleDfi5yd11JLF5Z+Laphc3f54S0viePX9PTApED2TZpWgJZgex3gZLxIZ9qZdEbtw
	 OHGznJZE61MncNjUTP/c0xwdqbTSvmk/wsQHnb3Eu85QC+6R4TGAeg+tSbWgHaEAEU
	 XAHkc0qyYwgvQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E31C98313;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:45 +0200
Subject: [PATCH v6 14/17] mm/huge_memory: drop the unused do_lru argument
 of the file split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-14-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=2467;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=xmffsm1SQoen6wnNoHnLCjDOebcsOHMJxuynkP1cNFQ=;
 b=BWZ2N3ClOOOgEbeQScIyuu2ZTz7UVZMZ8G6SWaNqCCOoFcNJmQX5pBttoyawp/k/M9HGCp/vi
 jNP0aNEeJsqB6/OPrJVBTzDozEblsDSMu5XdCvGraqT2eWMQjfnj20a
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBE88C0009
X-Stat-Signature: 5jueghexo987abzeztofha7hgu7syx93
X-HE-Tag: 1790199164-952801
X-HE-Meta: U2FsdGVkX1/ukO5i68MCxd2idWUahe14aGPg1YfjVd/V3P8Yf2o9dwCpAQC0MSA/6GiubqoYzuXexePut/LMuTEG+e9VoJRoTwK6AMq8Y7IKAfoqgiJ+Sd5GmWZU4WGuV54HHi+hoVjR6XuOG9qPh9q6F4fpSiOmsVKMMqDfUKdRVCuJ9J0rFZM6u3zEDGhQF2QRRNgDFAsr3O2l1sRjYssXAxux9JUyVaqkhcHnLBJSrZC0NOdkmdX6mzil3K0S8B+dbilklbX7moo9LfddT+a3Sx2dwmqWZRloaRCn06ByBU2sIrKQyqPW6D8fqIXM1oZTKW6bYTRtuDjuqFLWUzWXM2aIvlyEIuyuDWUD3/Dp8kY3wqoGylCgdhv2oAUhsuaYADEXDja/aD8TpJDN0pc9b4qSAp6nPNJKA4tGeVRsXLthNKSs785NYxm8q6ydNVx0H6sNxAx0EIkKdvBfKNXjzcSslDcljl/BhzhWTbd6DFZY/pZ4TfR81+z2aWBilgUcBuRuydeElwDw3bviewixHv0ZpjHV2stwT5O/XuSlyiBEaTE11xTGIzyX4Z1JQb8kimRfuGWzZ5S5UK+uY3kuJeQe3clgu10IRU23qnfZPH/IGzjNVYgOAXY3f9+sgWy9TcXADXzF/fwedWuNQXNJ0HZAOCcZc+7T76/Kb38UBZIX+FS34ekr9KTfrTlOoslho6fpSouxuet+TuM02dXNd+XHd1gtaUTtwB7j4+tviCSvEA8aQM0Blv8CQSVfGugFT2HtpUgwnzqqJdyxDFljGgf2Mn3cEpptsSHtprzRjdGo4ABEm9sDoI0fnLyAxdTiyivG/bP+4RProqnNHn7tZMIONEYMXFvMcIFA10xqAmXGg28lJVcUGNCO5T10xJm7XbjPeXi8k1XKvi7cDDKga52/6rcsiD/N1yzbc6BFMyHixNM8/eZLsoaQIsAEF9YIofFEYmWd+ayWg1G
 dZqEFJOE
 ZnyPO0OjfL645kTdE/g18o5HzLUpoXmEATidFotD4h3SH9Nhz1EaQ4xPMIBQ3G0aNAPg0jphrMHy5fBREoaVpEQdDqWK3ouQTG1cCWCQTg88zowvxtJ0rMGt6+q2WJl1gqy9G/P7Ox2RWmN98N+LbFO+41Q/6vROxBHziT0v8JGnwJEL1r9MbTpyeBro1XLna/ELGeg0MymKCYxWOftZsxuRe1zKQ9QOZEfqLjs+1Jw5FdyhhEcst0SwYnHGcG5cGtuGVPKHmbOB/+ahs56XE1Ha0zc7sBfisMzi8KB2uCTOhAl2LiQhaVAmBoHT3lrpJJSInMpkrZxTw3KWY4V3U3e+yAyTiVNOphFlJl0Sz9wNkB3HBAPuIyq43vB8vlYezn274tVlNB1IqMH2o0GbDwpFx7HZwoSP7p+UtK2OUtYol+27Ys//VQCfqOshHHbQw+S2+rNstKGCSNRNtCHh4I3+wK6rlML2pBKFrn3uBEC+rd9DDE/5slRXJHeIphGTfXBIVnGgPq7i0EVaPd8+EUxUz8wWyiFllBFxxY1Y/t5SQBq8MKNgKjmhC2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The only caller of __folio_freeze_split_file() always passes do_lru as
true, so the argument and the branches gated on it are dead code.
Drop it.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8d43ee243b27..86583bf1b148 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4136,8 +4136,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
-		bool do_lru, struct list_head *list,
-		enum split_type split_type)
+		struct list_head *list, enum split_type split_type)
 {
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
@@ -4231,9 +4230,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	if (do_lru)
-		lruvec = folio_lruvec_lock(folio);
-
+	lruvec = folio_lruvec_lock(folio);
 	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
@@ -4255,8 +4252,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
-		if (do_lru)
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+		lru_add_split_folio(folio, new_folio, lruvec, list);
 
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
@@ -4282,9 +4278,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	 * and its caller can see stale page cache entries.
 	 */
 	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
-
-	if (do_lru)
-		lruvec_unlock(lruvec);
+	lruvec_unlock(lruvec);
 fail:
 	xas_unlock_irq(&xas);
 fail_mmap_unlock:
@@ -4360,7 +4354,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at,
-						true, list, split_type);
+						list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing

-- 
2.55.0



