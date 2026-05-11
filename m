Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E56D6CD4842
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6496B00BF; Mon, 11 May 2026 07:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77F26B00C3; Mon, 11 May 2026 07:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14606B00BF; Mon, 11 May 2026 07:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B8AE96B00BF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:58:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E7DC160711
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:58:49 +0000 (UTC)
X-FDA: 84754992378.10.B323E50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC3908000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:58:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t9IJXCdZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500727; a=rsa-sha256;
	cv=none;
	b=ifSCF3f+/Jv7yukFuX0r003cMpsTjphr1NvIm7oD8Oqh9HEY7B9gMcMYGLVHPjBA3czYXg
	6FM5hzowMwR8wxXRjuYIJG7RnBN9/CwByCoPcCKZUP2a4i9cr3KyqOUEvuvXxrxnEplMDi
	GggOx2L50LybUdMEbvq+12UjJv11mOY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t9IJXCdZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vArUX3udmtEbM/32R/2TnYfBD248lZGZte0iAEMvm0k=;
	b=UTt/ZBCPhkQ3x7A8steGYJVLAMQSsBI0D7nKGpyM86rV3nxwGNbRP4f7yNmpqEMBlO5A5e
	E1DykR0ugFgXMqE72mHU3GVmyU9vaNakreNvHWKN9k7ImNsHYMCbtq2RJYtQ/9x2qXUCXn
	aZ8TMph/oIOMl3Wn8Ds9U11sP9rpTSw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 576676012B;
	Mon, 11 May 2026 11:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4939FC2BCF7;
	Mon, 11 May 2026 11:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778500727;
	bh=CosZHTq2j2jb6ZSY38VLO1g0AZgB8KfqDu8O1xyEp7I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=t9IJXCdZEAvL+UiAUdALKiaOAv4Z3yfVg9GVqpPJv0Jnku/OZm7X2zY9V0bMQAvLz
	 lhdOKp3hViWV2UTH1D+qp2l/xJcYX7UWDvNVQBxCJOOEa5stxTmBjaTJ59lU7Q/HGp
	 JIMzbOc/64KlhylTCkH6zqGm2FimhnreyIUQWck/PULPM8NmaLSW7SB5yecfLxm8E0
	 4sxTDANTWg+OD50t7zuPlM+bGBC3czWEGq4vjSmOSO5iPk2q50aTn3YsXt+/ii33m0
	 voYmEqsasfc+GW1TsTJs2AzaWB3vSWDBHQNTOSyqouOhfYVP+VqSCrCZxWlfY0A/By
	 /7ZygqupTRr6A==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 11 May 2026 07:58:28 -0400
Subject: [PATCH v7 2/3] mm: track DONTCACHE dirty pages per bdi_writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-dontcache-v7-2-2848ddce8090@kernel.org>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
In-Reply-To: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4629; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=CosZHTq2j2jb6ZSY38VLO1g0AZgB8KfqDu8O1xyEp7I=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqAcRwRhMfp+nQZKNB7vdmS68Q5wZanT4Sp2CH/
 C6Wq24eWPuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCagHEcAAKCRAADmhBGVaC
 FVi5D/0RkGeyFY1pqY14JmBK5en2j4bGs+0zCOoaggIm1apekSZxTTt4ZSrcDbo7RrZqrwjzuwW
 6ALobK9dF/Jn7eyHIZ5LYs5ewwDGzJETSQjI3XlA4plxjuLXkIl2/eMKwJXMwknogGFjTl25lND
 cy8/cEVn6IgC8kIhk0oWiiUfZHd38XM57v4hhoWJ8wT5OBZlMBHGZZDk/K+i8lUGgDH5hwxsmNO
 l3s1ZUjkZXcM2v6z5/MBlw9cC9BKDdgEE/c2hDWliZ9MrIovMsn8avXGss3FS5RLiwWWQCQ7f2U
 aZ1SH766/YAHNL/jMjqDqKUZGLvY0chZqTeoyOLK5+NNlrbnYLxOSOTITIKN4d/q95SJWjeyLSs
 ZW/l4dLKng0TQ70kG4GgwSgi+8WJOIjeIwta4bTP0rRqrSV6fP3A2tETttLFwHw7PVxVD8EKdym
 XuZulPsek8YvrGLdBbmdAAqAu7hAsbgfhZUUeOCM7tGZ8LobKWv181GjJteC7xUqyTCJuN54twN
 Y8NJIlxfLtZFu8t4L+k8oVNtmvtUTYY32OFjNuXHB0rcc9b5snvDIDdBiN9SJ8OZedPdhk68l/c
 urDXf1QNcLWbDC8cWevuzJu9J/vxT/J6zMFkWwY+pArhbI+5mXeGZ+REhPmd8J/Eg/IDzys0hmO
 b/kd9P/lwpFMMAg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: cgow4exmm69mbjw1pwjj4dta1o9bm7hh
X-Rspam-User: 
X-Rspamd-Queue-Id: CC3908000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778500727-431651
X-HE-Meta: U2FsdGVkX199Py5q5+xtDA8LjH7Bw+BKxKnzq1M8ZjE28itvpkFEaXTmGWeUtSNcr4d8O5JHwdzQzrvqX2AatSqoRS4PUrZ+zNsyudPPRELmxGKHCN7BhOHRzIXpbvrjCXTiIU76hV5gAaG7CCl866QtjfmGsQ+lN4nueEu1WkY6AbOd+I683E5mw1ozuL9XftnqlxHKMxB/W82+6EfTbboYEJRBkw/a0vRHqh/4Ady55TOU+V8eRXHSzcj0X0c8QcWiBmIOpb0gyqbx2tqG+hJOIVpcyteEE8Y77bkTPzEmP6GDnlQVne0GtlZRHVb9JBLbzzHW/vBturNDDnxPOOojSCYnYdHLczvYUNcNvoU2UQ0izCJoPGWK4xyGJ0X3nz0VkHh8+IOYIFjT6IG2PPLnbMbhj3feN+zvEk/1sJughtmgj8AYJPw5waa6WGXtCCn2JlxJN1KwMlw47XghCMl/2RHyCfeQwKZefQWhLWj4W+v7ofbhqSIEmaZJij0BzFWe1DeQ6cWBzaUmcU7lTFyxj4sxt0+pA7quyo14w1x0Z/7U8eGegU2dWWRp25Xx7nYfCq80oFdpmiNq8XQHoUF1W5ND7uSJ9OrTIEc+KP5GhW77qjkqLGmlSYZUd7CVF98wqeBvwY8ROMwkOPjGJYun3rgnUUQzl9gc2OtzhIE6umNcJRtu1Lrkfa00GdEO6EaXhSL1mb0LKXtYNHfKjzlq7odxY4v3G5dYDA+ggCKYV8CCYI/mNJRC58PNZn5iCgG7sQQEMEhaHdwBRfe+TWPy1NnhJKI5zAqL25FGODOf6HtOP7CL//1UplUByje2eRn8t/HomLiN0SWuQqWN/HVrv2MvRy7F1vu5wgS1qLknHeeF+VG0Spg7z0NlS7zSneJ8J+Xl29wIw+xPA0Ywga/CBvCVDJUsQ5f1CRocjw3f/iZCHTRKQAZqY3wGwV290DvRlll98lYgiXUTDyA
 do/PzJ6O
 DXa1nuNJtwJhvo9vZ6zKogee8G2z3/cr4KeTPx5R+BqiT/DnIlv+s62b+OMqfyH+IofUzWlaaIyfBKDjujhH86kBrG0Dm1BzfP7mCwcTZ9n871dGVLqSsp2anDXX6c8aYvfwwgMp8NkBuxwwIiCK/mpg3SqAE/8iph3paFxUKk+oSGzBztb3HG/77Z9Q5W9mFLMdJON/hgg5YU9+tEbvh9myfI36ZIUI29u+/u29evsq50UIGTk9Zd2WPfbxsc9fKX54rYg68RAQNlWv0SOpn2/sLCnp/rxC+qnWwp4SnSdfA75liW0/zjJDFjFI8mz7rkc/X0K+LX7bSsj+yDGlnj6mtESkV+iJc8J6z8EFYDAQFBNGscYB6dKcqVkiKN5i318uH15KgvrewzwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
writes).

Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
when the folio has the dropbehind flag set, and decrement it in
folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
when a non-DONTCACHE lookup atomically clears the dropbehind flag on a
dirty folio in __filemap_get_folio_mpol(), using folio_test_clear_dropbehind()
to prevent concurrent lookups from double-decrementing the counter, and
guarding the decrement with mapping_can_writeback() to match the increment
path.

Transfer the counter alongside WB_RECLAIMABLE in inode_do_switch_wbs() so
that the stat is properly migrated when an inode switches cgroup writeback
domains.

The counter will be used by the writeback flusher to determine how many
pages to write back when expediting writeback for IOCB_DONTCACHE writes,
without flushing the entire BDI's dirty pages.

Suggested-by: Jan Kara <jack@suse.cz>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fs-writeback.c                |  4 ++++
 include/linux/backing-dev-defs.h |  1 +
 mm/filemap.c                     | 15 +++++++++++++--
 mm/page-writeback.c              |  6 ++++++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a65694cbfe68..32ecc745f5f7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -432,6 +432,10 @@ static bool inode_do_switch_wbs(struct inode *inode,
 			long nr = folio_nr_pages(folio);
 			wb_stat_mod(old_wb, WB_RECLAIMABLE, -nr);
 			wb_stat_mod(new_wb, WB_RECLAIMABLE, nr);
+			if (folio_test_dropbehind(folio)) {
+				wb_stat_mod(old_wb, WB_DONTCACHE_DIRTY, -nr);
+				wb_stat_mod(new_wb, WB_DONTCACHE_DIRTY, nr);
+			}
 		}
 	}
 
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index a06b93446d10..cb660dd37286 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -33,6 +33,7 @@ enum wb_stat_item {
 	WB_WRITEBACK,
 	WB_DIRTIED,
 	WB_WRITTEN,
+	WB_DONTCACHE_DIRTY,
 	NR_WB_STAT_ITEMS
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..179f2886f8c0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2052,8 +2052,19 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
-		folio_clear_dropbehind(folio);
+	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
+		if (folio_test_dirty(folio) &&
+		    mapping_can_writeback(mapping)) {
+			struct inode *inode = mapping->host;
+			struct bdi_writeback *wb;
+			struct wb_lock_cookie cookie = {};
+			long nr = folio_nr_pages(folio);
+
+			wb = unlocked_inode_to_wb_begin(inode, &cookie);
+			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
+			unlocked_inode_to_wb_end(inode, &cookie);
+		}
+	}
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 88cd53d4ba09..8e520717d1f6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2630,6 +2630,8 @@ static void folio_account_dirtied(struct folio *folio,
 		wb = inode_to_wb(inode);
 
 		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+		if (folio_test_dropbehind(folio))
+			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
 		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
 		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
@@ -2651,6 +2653,8 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 	long nr = folio_nr_pages(folio);
 
 	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+	if (folio_test_dropbehind(folio))
+		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 	task_io_account_cancelled_write(nr * PAGE_SIZE);
@@ -2920,6 +2924,8 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		if (folio_test_clear_dirty(folio)) {
 			long nr = folio_nr_pages(folio);
 			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+			if (folio_test_dropbehind(folio))
+				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
 			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 			ret = true;

-- 
2.54.0


