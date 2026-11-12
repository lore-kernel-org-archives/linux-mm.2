Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D1B60A261E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRB/Zcj5
Received: by kanga.kvack.org (Postfix)
	id 193396B05C0; Thu, 12 Nov 2026 14:09:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BD86B05C3; Thu, 12 Nov 2026 14:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8BA6B05C4; Thu, 12 Nov 2026 14:09:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D71DE6B05C0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48E9DC0BBB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:21 +0000 (UTC)
X-FDA: 85427405322.13.EEC5280
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 939A84000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bRB/Zcj5";
	spf=pass (imf11.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510559;
	b=bEeJhfhpQvjMJXS/WpIzWsLK7qa8pb/OfQYoHbLCjGRQgKLYJr1LMWOXN7D/k/d3IyM4Ct
	JW+05pwMHGoB9W8Bo7b8IbpvYj5tS0eaMXIblYusj1nTKsdk7WE1Wkkw0LCB5zUSe1R8xP
	pzwpmn96pYUicAPLXtfhnzqNVCe+XZo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bRB/Zcj5";
	spf=pass (imf11.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnDCs+7uPBjV4AWzwRSdGW/2w1/1J5xqMVOU9/AJamg=;
	b=u3WmhLP4v7OFFy7Lr5Hns6QfsYACZekCer3zaPGle4RMwrigWh0ixDwARoIg52bHDzoNI+
	ZhWE09o1eeoAeh6bX+dINFC+Mt4LhFI6B7zVWMhSrk1usQBv8TAG16PKFxMEeTHW0iXeCn
	wgJIwQb2EXeCPTPWbF2+2qlpcSkvauI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0C3846007;
	Thu, 12 Nov 2026 19:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704B21F000D0;
	Thu, 12 Nov 2026 19:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510558;
	bh=tnDCs+7uPBjV4AWzwRSdGW/2w1/1J5xqMVOU9/AJamg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRB/Zcj5tBHqofQ1FhMUoIae7WIVhuFumByqTXTwNMROaKdkdEhhKzAuo3L+PSEWA
	 jsmvOP0LuwA7NC8AL+y1lWWToofAEXl93LpuN75PVTgKPV0WvznroS38D72xnXOnbX
	 +fbeYmyTbMfQsXaKotTl/AuXa9s/f7GKkoexAcW3GSEotWqMizZhL0w1w8wQq7KDO6
	 qgN4rCP16V3UPJuz06vZOKsPFl/ik1T/wHkd6XdoRqJ0V0ujf6qYEmO2ukYrYkP17k
	 5/2grxcRwprHDzvjJ2sykwsEZZz9voqXZp7xNxwQiHimSRA/Tgla+WWWzB2/4pHdeS
	 MHztBApi+OluQ==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v12 2/7] mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
Date: Thu, 12 Nov 2026 14:09:05 -0500
Message-ID: <20261112190911.84702-3-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261112190911.84702-1-snitzer@kernel.org>
References: <20261112190911.84702-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 939A84000B
X-Stat-Signature: sxjysfbif3gzjfjbsiefkfyijoz4bwi7
X-Rspam-User: 
X-HE-Tag: 1794510559-56926
X-HE-Meta: U2FsdGVkX18BrfQ0l4UN66jkCcjE6jhIYiBVSuaAQty9ccRXLhdt29IET+kInMnQtfj+/u9kzSJS+khN84IJdX4bg7tzIHOloLR1thQdZc5bDOBFStSR9Y2+7Zx7alqXetZM7Sd4knt6k3wLaOwn5yKZafdnVhfKsx/TXAR2t3ROwjghWo2CT7oYJUjKZ+A8a29yRvZecXZ0ZQA3wgmNOtvGQ+a6qJi1WrFvhgF5mnVahBgTB2SvJ2U8ErE6hQZJakcU95MpXLnt0H8sVm3rEHKcMv6e60It4GnGUdf9/pIx8SimQknO56dQiZsBIrPyB7V4hyLI4lh3LvLI/wQ7ZM7uTqt7L43i14qx2FI1jpakI68kOAopWKSMPJL7i8ufOn8ptp+sVFaJYrKhH38Pw1uq8o2gDHVK6U+ys4MLavlNRt7SmauNpVeI8qIjchSdPcU5XgM4+5Ry6g43E8AAUS6EuzW2HD81fRSkzhtRb1ap7eWXOIG7WWizpU6djmyztrkays6MNHKWQjQEyYBiC16u23Nk+1PrkfztaoW2broTzcFUl5x9UyZ8nGHO3Y6I10uMfoLSwMIc8DaBYZ40MuCQaBgOXFB0seLsyMk4J+oDkhl1YkbZdEJof6mSZ0wwGXlNhjc2zR1bFnqASW5CmOhL8H2THWRvupC12jNHP4r6qkrbDiMi6PS03eoA3sCccTK+IqfVqm/jyLwtXtSO94swlDQltt9U3Ut3rWafn2L6we9mP8FPrANsE0TUgDchfmql9KAhhUEfgDQ7sqcd85QHuqLM9Ach0+Hy74T2CZstRTw5t50dhSnnvroRpwhSTXrweNIgO42HYuDoucmjw8oR2dAuwMI1b0DdFQ/uqyhNSAKLO8tyb3uhVqPbDXlMha8Y3oo4zeU9Lw9XB01n4lxpZYvjzJkSLeoFfl7I48HClhM+Q8Q7gV1VZcW88eYUZMZG2mviWvYFgxeU1CN
 rxvp7GAg
 yodX7Qgdj4P2esd5tkXvrKIS5j7RPMSF8p24imz9wCmhcgGHII+j9fL1aUo3V8HPtC+tMaDAgf26ZvrhnO/yJM67qexUy9UnghVskvp0emSm39WuuXzUsMvFFLlTGdOjgXvlhijp++NIkcxqx3pcGzA8TyeQEKvhlIhDiKPJGjGICSGCrX9cokowBoOAWnE9HVXl1/zyk3Iz+Yh3HyFlDbH6eMhsB2nkSDEZIoyo8+cmxcUHEC+SmAAbfrwZTO4cr0+fl7kiC/ONIWdrotbr+jW/JvuFPw50kJQO52bKJ96R2c0v5G6sZTeseZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A cached lookup that finds a dropbehind folio clears the flag and
subtracts the folio from WB_DONTCACHE_DIRTY if PG_dirty is set.  That
test races with the dirtying of the folio.  filemap_dirty_folio() sets
PG_dirty before folio_account_dirtied() counts the folio, so a lookup in
between subtracts a folio that was never added.  The lookup also does
not hold the folio lock.  Every other path that subtracts a dirty folio
from the counter holds it, so the lookup can subtract the folio a second
time.  Either way the counter drifts, and once it is negative the
DONTCACHE writeback kick writes nothing.

Fix this by having filemap_clear_dropbehind() clear the dropbehind flag
of a folio that a cached lookup found, and take the folio off
WB_DONTCACHE_DIRTY if it is counted there.  With the folio locked and
the i_pages lock held, the folio is counted if both PG_dirty and the
dirty tag are set.  A folio that another task has locked keeps the
flag.

Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 mm/filemap.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 437113addbddf..98ce955404127 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1956,22 +1956,36 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 	return folio;
 }
 
-/* Clear the dropbehind flag of a folio that a cached lookup found. */
+/*
+ * Clear the dropbehind flag of a folio that a cached lookup found, and take
+ * the folio off WB_DONTCACHE_DIRTY if it is counted there.  With the folio
+ * locked and the i_pages lock held, the folio is counted if both PG_dirty and
+ * the dirty tag are set.  A folio that another task has locked keeps the flag.
+ */
 static void filemap_clear_dropbehind(struct address_space *mapping,
-				     struct folio *folio)
+				     struct folio *folio, bool locked)
 {
-	if (!folio_test_clear_dropbehind(folio))
-		return;
-	if (folio_test_dirty(folio) && mapping_can_writeback(mapping)) {
-		struct inode *inode = mapping->host;
-		struct bdi_writeback *wb;
-		struct wb_lock_cookie cookie = {};
-		long nr = folio_nr_pages(folio);
+	unsigned long flags;
 
-		wb = unlocked_inode_to_wb_begin(inode, &cookie);
-		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
-		unlocked_inode_to_wb_end(inode, &cookie);
+	if (!locked) {
+		if (!folio_trylock(folio))
+			return;
+		if (unlikely(folio->mapping != mapping))
+			goto out;
 	}
+	if (!mapping_can_writeback(mapping)) {
+		folio_clear_dropbehind(folio);
+		goto out;
+	}
+	xa_lock_irqsave(&mapping->i_pages, flags);
+	if (folio_test_clear_dropbehind(folio) && folio_test_dirty(folio) &&
+	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
+		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
+			    -folio_nr_pages(folio));
+	xa_unlock_irqrestore(&mapping->i_pages, flags);
+out:
+	if (!locked)
+		folio_unlock(folio);
 }
 
 /**
@@ -2105,8 +2119,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (!(fgp_flags & FGP_DONTCACHE))
-		filemap_clear_dropbehind(mapping, folio);
+	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_dropbehind(folio))
+		filemap_clear_dropbehind(mapping, folio, fgp_flags & FGP_LOCK);
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
-- 
2.52.0


