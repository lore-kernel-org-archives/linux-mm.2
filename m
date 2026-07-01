Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CC3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281FD6B00A9; Wed,  1 Jul 2026 06:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233526B00AB; Wed,  1 Jul 2026 06:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122456B00AC; Wed,  1 Jul 2026 06:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E50656B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:56:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5AA2D1402F1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:56:47 +0000 (UTC)
X-FDA: 84939904854.19.2D19C69
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id A159940002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:56:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BEB28umq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782903405;
	b=bkNjaNUvq6Y1677Ndq3km2wvkLFrLPCC9RhlogSPl597d6IB+Up7+k2UUbjpHeftk2oJFv
	9EFJUcLZu4KzEE6POfjqPbVOaGEsQpmnvARlGCqmbkDkG60Btldc7ExCNMRQg2RNf3dysf
	69bggbrAjQF80lQxP8Ns/Br1xyY/Bs0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782903405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nL6GH6ik36u+3oisiWgN6v5JDtof35vJCqA02nCfVYE=;
	b=Th96jsc2viBkye+OLJbr5kjY2yNNW7hXY9EfSQLIbbIGVokqBtmI7h9rlfL0wecIA62P5K
	zOdSXRNOUzCHRLq1E8e49eUdknOUt4koFIxdVeg9S1Rw/Kg+J19StW/R5/rVxIgr1+Ne+h
	zUZaChhiOQEIQXqmpKM+Z9QSIWYdqgk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BEB28umq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782903403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nL6GH6ik36u+3oisiWgN6v5JDtof35vJCqA02nCfVYE=;
	b=BEB28umqoFY1ipQDj8kEy/vtLPrXMX1C7Kkgaj8zaafTEosNcpsLG7NOlJYsD9PyFOtiTu
	HWHx5nd3jNMt9CguvZgfRuTVKpb9ZSmeutmg6b6893N8dAzMOO8yXFzItuyK0V2GFeMkEY
	uovwpvnkIaETiOvNvkCYzuyw9T8GnIw=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Andi Kleen <ak@linux.intel.com>,
	Muchun Song <muchun.song@linux.dev>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] migrate: Skip hwpoisoned hugetlb folios during migration
Date: Wed,  1 Jul 2026 18:55:44 +0800
Message-ID: <20260701105544.97059-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A159940002
X-Rspam-User: 
X-Stat-Signature: uawtz4j4ikzq1mmwgf75ip8p6ahbkcbn
X-HE-Tag: 1782903405-966359
X-HE-Meta: U2FsdGVkX19+/PNX9vYzyK62dYUusbdFmC6kuAznrRkUOTCSMVIsJIKpLWn9r060JZuHyoM2h+kgvVLt8j1lCxnIzR098qFggbLWJNWjz5Z8c2op1ILSayOpv9H9KVSqJNmoiGp0dEDFCI1og6EM85MRQFUJukKrcJbb4/kOB5cNe2i1oqRa+Rfym1hDWpNOGXuWjjL6cs1dEWs2B9/S15SyJfCKUV9FoaU7Uz5cZ9Y8DsSLI+44eBhDgs2IIVIievoYFR4J24yW8MfEbQWh6ULIfrd6Wm9NgClZgBiLabiOIYClO3RK5KwPEddmU+ot3HHxqjfwlfoOW1QQ1xuOA8Ego8Vc7QoUd4WN7UrjOR0GUwul/i7gosDJd5mv3bRklw8xSRxSWjc0GAaiycNOHR8yIsTRORooUFIrESgO7c2jkFq48E5MQ13NIpJWB6Lb6WZbSz6B8k2FihNOhIah/U4tR31H7qGVqFA5qVkiwe6RXcA/npTYxPRnJXCqBmW3NY301wYYTgO+TgUZBNsCknxo3TWe3/LRE44n0B0Xaos6KI8pZrnapCPMNRPJwsPyh6by6ab0Mda+feBoQnUX4Ul5aQjYVFRkTf8zW4T/sgotNx6LAxyAXRa5GWs3dostT9rshw298rDTISGLzHbACTwdgpnNpO6cjJwNRjUAvtAAf7RK48CHwAMa2wIWolYdG0BAeVAbCvXeyDVOdbjNgmNLr3ahzrHTBVagTrm+8mWWxLn1c/dluMtkx3zf4QNBrcUufnr/gyN3Bc94GeJd/sOmjpXCxkyCpTq+E7kJEfCTixBoy682V74tURLUmNFs3DEmPGMO5MsDAucjzy+z6MVPjK5RCtXkzKbsOCcpdpi1ZpVS697nONvGw1lUJeEPcBta8C43zl4UkQqJ/HrBk34ORD+OpICk4p7CyROTycIRifeZyKnPPUG0FAH9OpE4nTWAOs87Q8M2+KBh1iD
 vDVBA5hF
 +lBriXLQJ8jnxCfd5fo6x06cOlCsuiOdFmxdvDVe6aS0XTGQxWjbTN/BUSuzuezQU61tV/uNMHpkL4ncKV5cayZteRV8DhioWxvH2LOsSmhPnW1YP/rT5v3u/kCdWJ/o2de8LMi4sQWahMsVRNxkD6ZJw1m+HGX9s5i7cw/2YGjOO6pZOs1nUoHSGWMDJzF12esOW3kfyvgK1EymQOBl0FZgnVv4LER6IiXVeT/wBV+xIYzn8PutvDYmVViaIDPU7p/89Dlu8wH3O1ZAQ5NY/o+2OZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Hugetlb migration does not check whether the source folio contains
hwpoisoned memory before trying to move it.  After the folio is unmapped,
the move path can reach hugetlbfs_migrate_folio() and then
migrate_huge_page_move_mapping(), which copies the source folio into the
new folio.

That copy uses folio_mc_copy(), so architectures with recoverable
machine-check copy support can fail the copy with -EHWPOISON.  However,
there is no reason to attempt the move once the source folio is already
known to contain poisoned memory.  Architectures without such copy_mc
support also fall back to a normal copy, which can consume the poison.

Check folio_contain_hwpoisoned_page() after locking the source hugetlb
folio and fail the migration with -EHWPOISON before unmapping or copying
it.  This covers both a hwpoisoned hugetlb head folio and large folios
that only have the has_hwpoisoned summary flag set.

Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/migrate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 49e10feeb094..ac12e9aeb05f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1510,6 +1510,11 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		goto out_unlock;
 	}
 
+	if (unlikely(folio_contain_hwpoisoned_page(src))) {
+		rc = -EHWPOISON;
+		goto out_unlock;
+	}
+
 	if (folio_test_anon(src))
 		anon_vma = folio_get_anon_vma(src);
 
-- 
2.43.0


