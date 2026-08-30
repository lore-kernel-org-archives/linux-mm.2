Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 347BFC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA176B009E; Sun, 30 Aug 2026 00:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C3B6B009F; Sun, 30 Aug 2026 00:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CB66B00A0; Sun, 30 Aug 2026 00:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B78A36B009E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3253580263
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:31 +0000 (UTC)
X-FDA: 85156631742.09.B49D7D3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id B694140005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L037xD86;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOsUEQiX5hPPz6sUPul1Vy0rSyJQxXGSiFeQvRVO8q0=;
	b=wvPBAdgAQE1RZaGH02DNdXjA4TtIynJSlVTojdZhGv8D8yxvUEylz8YWCfq4f1YQskXrvj
	aiAmBZNOtU4Aj5lGBC1UwdNsh/glYMJuLEHKkuPXDpbJGqQsu4Loc0rO66iUxCV90FWc7N
	1tbu2SyQ2sUOz60/V8qKMx1BLyA6/gs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L037xD86;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063569;
	b=GgxxxaKGKEJsL3iI8luENfz5jCyq8j1Sb3pIEkSt09ggg23dj2fCB52uIcS7TUZWhGeKG4
	32zKnLeASqM5tOJ4U+rBEUXBmfoaJdsmzjVXCLmddBhTWbuvmgPg1tcvMZjJJyO+DtipIy
	sZ9TwLBkZu1XjOQ5Qa+VYgUeFNWdTWQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=iOsUEQiX5hPPz6sUPul1Vy0rSyJQxXGSiFeQvRVO8q0=; b=L037xD86tbRevrRc914UOatghV
	p+tn3zXNS1KjRC7ubVd5/qGwTQYn67z7oD8fyhA7G9ULdUFo+SleMrRPBP2CXoDSeI/7al9q9nIBh
	bmvFtG3Y5i5bMroPMma4KLePX0fwM4bTu9I2VJ5gXVLsypFk64Gnc/qCG7u567/hwq8yGZliK/Zvc
	mp+qCjf6x5LPR33alJLx9+FDr9EgLfA9qOEQWikc5b8t/EBAvvRKPq/rfyqVNKKFKh6WXwWwv2OGf
	vwRlTrodbR9EbM/Z0xfKyBR0cszGGhcIfowJ6uc6nEYVcihEAwYLp019cM9AJ+pEp5IabkI6qHXVM
	QYpBsLrA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000i3-26Vc;
	Sun, 30 Aug 2026 04:19:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/9] squashfs: Remove use of FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:54 +0100
Message-ID: <20260830041901.2668-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B694140005
X-Stat-Signature: igtcurxjyddbht84isx5nekjc9r6nuss
X-Rspam-User: 
X-HE-Tag: 1788063569-969112
X-HE-Meta: U2FsdGVkX197zckdnQCXLu3HwpypUkLuY04sntERCd3AKcDE3qCGsbbUpXTIk4zZSy6t/gC3sQfcK0bVPqSmMYduCgYY5IBm3/tHaMlVeGsfVr/qZ93x0jTLPoRxFKeMliog5LxtrteweSD+89MX4rVpK8m3HSwu6LHGKObzjjIArK+ABclKx938qgx+yajbrdOu+WO7Tsrf4jVcUf2WtOQ7Isf4nAMxumN3JFp7Xrl7iascHqpuKoVxCBRJXHgolMkE3dbBLdHi55DN2GL3Ag+OUU3cz2ZYE1Tks9EeS00tIFiv50SROAaBXIpGHaZCqeCDouyTHi9O8SmkB4QgwBDkD8oVXnu6Qc9QBVIlYrbZjSZgZcEYFjeolVh2G3BxR6Br5BhsL+4q5v+42vH0rPcYEFkOsVUIHVKpMmKnKcTgUrfb6yEb4nP09Xj764ymqSRJBEkNSryucLAvDAJIV5a6tWNI9xQO4ntqEFXK1wirLnCBxQuCVLMom4AxYVHXCEfVkbXtwquTBlZneWjY+8wrq0pd2OGp7wxKB6AaX3DA68TLB7yjRRb9JSEUZqnQUF0aKYdS3WkMcXxv+yiURFJ+60V9ALCXJWijZLwZa7M1654GTGAggV6x2ZVxt182jI6qfdxLbywOXaci2QBGbPb55l1g3wkJfLi2DJ8q4FcJ19su+3Ziv6U/lIvTit4ZSgqr8kRonLpG4l0nGXUcLAlvHvyOnNyBUQJndgQHolcBnk8VfVdX3RTipyw3MwvtY2ouy+ZYZg7zh+zTPr9PtoorX4y3mmif11/67yUMPnLIZMG3SjxP7mlE5M6ndjovRkCHXsLJQ3Den3Ti5RZtgH8Fe6hdVtLNAXJu3zWN+tCXOapJAhVm21c2Pzpg629+1IIIoUmwUmYnCe0d3MScOT1HSnMIsotPLt+csUGSdkScuov7wOsGCuI8dhEV+GWmKmHJCOH6/aPL2T1gmn8
 Reaq2Dr7
 WRZWI+jE9lh1sV7uCL6uSGi4HO810Hzib/vcpvWFT98HCGJhDnheoHZ/jaQ+voFSZSUKklMzpeoFHyqn71f6Ki/v+bFYm6rDYyzMHeVY+d83lnMGEOsIWSX48tJxuo1fV7txtVi2S8mH0o1OyL2DTikhIgc9IPcBGZbKyjRfC8wxzM0c+7HQqebZDWDEYI1Tz7RFEDjCz4A702cImnCiiOAiL8H04Cnwp4lkYX1uwmEOuUz3nxqX0r6jOzI/u8YTQPaYeOKixZy6WC7zyz7JpsNlwsvn9pIlbdIFOIqB+GH9exKarTaqou2hLEKXP40swgKqdlCtqFzmlXDXd9jt31dj9+vZq6DcYWxMEXrN1B4TcUoVVDrOJ3qVZcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we can allocate memory while holding a folio locked, we cannot
allow page reclaim to call into the filesystem and attempt to compact
the folio we're currently holding locked.  Use memalloc_nofs_save()
instead of FGP_NOFS here.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/squashfs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index d83594ce91d2..34c550a266bc 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -398,6 +398,7 @@ void squashfs_copy_cache(struct folio *folio,
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	int i, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
 	int start_index = folio->index & ~mask, end_index = start_index | mask;
+	unsigned int nofs = memalloc_nofs_save();
 
 	/*
 	 * Loop copying datablock into pages.  As the datablock likely covers
@@ -415,7 +416,7 @@ void squashfs_copy_cache(struct folio *folio,
 
 		push_folio = (i == folio->index) ? folio :
 			__filemap_get_folio(mapping, i,
-					FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+					FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
 					mapping_gfp_mask(mapping));
 
 		if (IS_ERR(push_folio))
@@ -430,6 +431,8 @@ void squashfs_copy_cache(struct folio *folio,
 		if (i != folio->index)
 			folio_put(push_folio);
 	}
+
+	memalloc_nofs_restore(nofs);
 }
 
 /* Read datablock stored packed inside a fragment (tail-end packed block) */
-- 
2.47.3


