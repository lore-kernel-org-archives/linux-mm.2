Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB74CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA838E000D; Fri, 29 Aug 2025 19:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBC08E0001; Fri, 29 Aug 2025 19:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9DC38E000D; Fri, 29 Aug 2025 19:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0F7A8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:40:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 908FD13AA28
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:00 +0000 (UTC)
X-FDA: 83831415360.26.346BF95
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id B539F140005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TpI/PABv";
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQukcjQRM/baglvoT2KPpefom5XTnGCNmGslo6r1GEQ=;
	b=p89q95Jy/t25EF1/YGKYPvcsD7gfHwA9T6b31SDgt4EISsIk7DIPAhApWNerWvfFIEXESB
	n5RhKy7xfEVjdZKo9q0jNA9DqEnqFsZA2wY+QlfNo92fO+fQBpmhiWgKNf9n8VpVg/J/2E
	AMSMgs1O9eQl782Q6A/y8q0WDxVITtI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TpI/PABv";
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510798; a=rsa-sha256;
	cv=none;
	b=SEFDXB/LIrIX2DO6AG3/lrJMagIseM4Bcp8V+uTmpNzzn5k4HRokxpUhJQCsNOo+08jsHX
	zw2yca0FL30fiMk3zXcdFJmXgkeznZn5WN+WNEN6aK6L11W/dovP3L9TLyyUfgtlcKEJOd
	8KrTXyf+YZ6bF0L/Fh6+0cCghdfvdcc=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2487a60d649so30060085ad.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510797; x=1757115597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQukcjQRM/baglvoT2KPpefom5XTnGCNmGslo6r1GEQ=;
        b=TpI/PABvcsVqvObEdgBT3cB2gPGin1ioL9NdBWYkMySeCl1H5c+ET6EkGyetL2FPI5
         I8wTw3GCr6hR2TCYh4yGAPXl/xRcSIuQng+zkLBi7/1l8cnVJgg2uaEAaSVzvzXG2KND
         KIop+6yZ9J3LF4FDNyF0qhSJXVaWZvi2+1badXtEwAB6EN7Jc0YBY4lKhF/daNshU+3X
         T0K3LLTUDKqaS/+/HHLOGnSzq0zwZJy5goZgom7xgZ6nS/ObYGsOKtNgI2GmgMm+MT4e
         UThYh3JSfc7VjWfy9ojWJUo8NtBRJUrx73QJpA0kcoPmKpnuEF5h5u5kx0+mv6WZ4LHI
         vFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510797; x=1757115597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQukcjQRM/baglvoT2KPpefom5XTnGCNmGslo6r1GEQ=;
        b=DYmQhlDBX9t78RHU9Fk5LYcvX8KJBEPXDq5lSuiqC7b6K2PsjUwE3fA4o1+PjnRYKY
         fEo15PEhGVrhQo/n78X0cdqIr6wY61fMh+UecM216tFe1Vqo8x6Ev+esTdbPbyR0Q1bN
         DTKQDSaqYsdCBVSBoHo9gZu7Xc8pL6JIeqDXGz25rrPuBEAZUvGj+5VQdVmWv2zLTEhH
         uggmTn4ezP4NlRqw99cP9GhIzt/HctwTR1+y7Kq4Rgv75o7g6zCNjrSplSzOhvbnhdQw
         IykR9F9DkkQLDzLJ7HI93xeG3iXKW8XynEKjDt2bQCNrtBJYTUS6G/LdUcIg25CPN3WW
         BxRw==
X-Gm-Message-State: AOJu0YzDRWZCybw0On02Q/PUN+qBSVOc5kRa+L4SwAq1h26dihApeT07
	YbFll8OgCtpBEtWMid2A0nkYfBazP7wl15/YyDQ0OqzD2r03lIwtGTffE8NWdw==
X-Gm-Gg: ASbGncvfpJvgvslDadQVBWOW0BJbMKZuGw6EsG3BIteDYZbZ69TwlLvLcGaFdJuQmZ+
	/axsI/diX0MNhnveaLyxJnYfaFq/mGjImlsIpXlkMyD1M9PHAwI3xMVtdrmx1XPz23+DuCdCUEt
	u4g8tfvH85eq6fFDbogL4uVxjDQE0yN9MHSStwojMLU4/fL6gretizPU77GpdTclJcJp3sqYn6f
	04trIioym2JeMGtCnZ27HrzM/Dyh5rgupwNRt7avmLaSwr3KEhVinYVGT+QWfhjhbIWHuu9d55W
	A3yhzOyl3GfpHbC5oRmUbHkLKg0YOZgfqu8XvtBQvAlVkdc5UZz0zf5dfuRrOKSu4Su3KbOhsPZ
	KeG/jdICBmlmIDr1RcgC4Kimp5no=
X-Google-Smtp-Source: AGHT+IHhvNxODvJgpQ4vTWKKwEcUrkdCrnvezfsKZ38SEm/r0ZcLOPNUukweP3ilslLK3BqmFJDj8w==
X-Received: by 2002:a17:902:d2c5:b0:248:7540:7bdf with SMTP id d9443c01a7336-249448dcc22mr5541335ad.15.1756510797368;
        Fri, 29 Aug 2025 16:39:57 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903758b89sm36024195ad.59.2025.08.29.16.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:39:57 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 05/12] mm: add filemap_dirty_folio_pages() helper
Date: Fri, 29 Aug 2025 16:39:35 -0700
Message-ID: <20250829233942.3607248-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ntxyk8bq88j9y9kqn6a7sz6xz4zq8hth
X-Rspam-User: 
X-Rspamd-Queue-Id: B539F140005
X-Rspamd-Server: rspam05
X-HE-Tag: 1756510798-315702
X-HE-Meta: U2FsdGVkX19248yia0MFUCF9BWIqN5c/uRwS6lnNtH6gdBJE9VTi2lHjwf6BpCWV99ASD9/1Pha63Kba6SWSr+3WcpaIUL060GrkoF4r7wv1sOah/cwwBbaTHHQh34X58albjfKiE9USAH9ZUtA+fe9g9+sB+deEun8lJCl6Ls/vsOj83shfgmQQnCdUnFOLG5ja5YSU3SWVJeJvleZEJEAzjkwtaSN4Yj7UrDPyHEOeqJRtW/zEiyQasgNwOomQ102PNtrI0TH5QQHh+CB9A56/WI7fIrKspUXAcfkDUbFG2IFECHMg7y7tG5ea77wB+6+QKToJeGl3nWTVqJEWllkyxSj6KkRQXrd13Yets1ptVvnHSN6vyLdpfH13nC6g5/29TBO42iQ9MbVBwE0nlHT7cg2diz1bl84adpueeiTZ8Wp/a/+ofOtdfiMALolCArcVXCbUIitYAeR/SjjndL2N+vHHtBF1USx0+q4oFg7gNgS/ORsfL5Hvj+w1EzofzTco3lQGIaznHYd2sd0hGo4PLkg4RcLK8zXrFTrdXNcVY2zn5AVWXDsvsPq4rKb4s/uaGGt31BnhcyE1QMJkzbo9eQLvoQedCXIWkgArrX7i7uP+HlEAjMATyuf5d34Cb9XJcQ2rMkCRrPozh4cA60RSGWO/EOwa9Dnuilh615JYmz5oXgIWuPfiSKYDmTsToztZ5fjpEAlXIzlONZ5pr0ctPn6IOUCIziVrpNYvKjB2aZI8no/cO4SXH+cQLWSCiqu/zuM9TGoYbWsXMuzoOvKFK7i0PumpCk2xVZNeAxkrZ8rdCzlav7FkgswPWIAi6oaXvbEAe58ZiHk2Q80gMAKZX87RRJaWdvMqNGadx6vLJssyLD0WwGjkA1CeuDq8tWtXDAm2Df7nN4ArwBJcwN4V2lxZLEVPgU5Df3zhcLfuQ+iEZ++Ukogo90FelaMfVBjUwehs15IJenCqA3s
 xk3/nsQ3
 1IjnQ84aIKBnoIZ5tJ+1eDGf+h6jj3Acd8Z7UpT1CaHzHERaUcI6OfeCYoabgMsWAIPD50dhhnVhny7en9ZnO9UN6ZSBVKg6DTmPSr0oiRf1jjQceaier7ZNkfjI2sHfNYKxrTt5+xEaOs3mBxar/fqTPFFUr88s+aS1/h0q3a9zrMdoQIp1alAsY+7WRRHb9bchAXCvfje219tgH46c5j44iBUeUc4FTPUMxzf+WOCpLohm3EwWn0SQ/9CCCYvlJeT0XBmoFIUcYQgKczIZejVBNDcxcKl78vSpi2gaBAcokXIjWF9pfjN5jXLvZbCa3ke6XSRdKhiEyneLG/0VAuW0VoBgyzBGUgkNg5hx9Jq+6TsPMGGhtoGP9mOE+sWFH9fxmIEDuiB+1oDahGJ6/o+yucGO8aGiDSYCnFQnF+g9FtZC1rEQW5TadyQmtJryyUdBulryfi0UQF0T+jQ/Tu0zw5qvujnSpQtVBgfzbTb6STAWaydcr7TT9+YbRuUYd5sfDO1k6KFwWDzKPx+kXtmSN9KJcCLJJjQNxpSw44JHRnmg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add filemap_dirty_folio_pages() which is equivalent to
filemap_dirty_folio() except it takes in the number of pages in the
folio to account for as dirty when it updates internal dirty stats
instead of accounting all pages in the folio as dirty. If the folio is
already dirty, calling this function will still update the stats. As
such, the caller is responsible for ensuring no overaccounting happens.

The same caller responsibilities apply here as for filemap_dirty_folio()
(eg, should ensure this doesn't race with truncation/writeback).

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/buffer.c               |  4 ++--
 include/linux/pagemap.h   |  2 +-
 include/linux/writeback.h |  2 ++
 mm/page-writeback.c       | 41 +++++++++++++++++++++++++++++++++++----
 4 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 65c96c432800..558591254fdb 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -752,7 +752,7 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 
 	if (newly_dirty)
 		__folio_mark_dirty(folio, mapping, 1,
-				   folio_nr_pages(folio));
+				   folio_nr_pages(folio), true);
 
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -1205,7 +1205,7 @@ void mark_buffer_dirty(struct buffer_head *bh)
 			mapping = folio->mapping;
 			if (mapping)
 				__folio_mark_dirty(folio, mapping, 0,
-						   folio_nr_pages(folio));
+						   folio_nr_pages(folio), true);
 		}
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 48745f8f6dfe..510bc6e0f70b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1224,7 +1224,7 @@ void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_pages(struct folio *folio, long nr_pages);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn,
-		long nr_pages);
+		long nr_pages, bool newly_dirty);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
 static inline void folio_cancel_dirty(struct folio *folio)
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a2848d731a46..0df11d00cce2 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -372,6 +372,8 @@ void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 
 bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio);
+bool filemap_dirty_folio_pages(struct address_space *mapping,
+			       struct folio *folio, long nr_pages);
 bool folio_redirty_for_writepage(struct writeback_control *, struct folio *);
 bool redirty_page_for_writepage(struct writeback_control *, struct page *);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e66eef2d1584..1f862ab3c68d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2730,7 +2730,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
  * try_to_free_buffers() to fail.
  */
 void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
-			     int warn, long nr_pages)
+			     int warn, long nr_pages, bool newly_dirty)
 {
 	unsigned long flags;
 
@@ -2738,8 +2738,9 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
 	if (folio->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
 		folio_account_dirtied(folio, mapping, nr_pages);
-		__xa_set_mark(&mapping->i_pages, folio_index(folio),
-				PAGECACHE_TAG_DIRTY);
+		if (newly_dirty)
+			__xa_set_mark(&mapping->i_pages, folio_index(folio),
+					PAGECACHE_TAG_DIRTY);
 	}
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
@@ -2769,7 +2770,7 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 		return false;
 
 	__folio_mark_dirty(folio, mapping, !folio_test_private(folio),
-			folio_nr_pages(folio));
+			folio_nr_pages(folio), true);
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
@@ -2779,6 +2780,38 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 }
 EXPORT_SYMBOL(filemap_dirty_folio);
 
+/**
+ * filemap_dirty_folio_pages - Mark a folio dirty and update stats to account
+ * for dirtying @nr_pages within the folio.
+ * @mapping: Address space this folio belongs to.
+ * @folio: Folio to be marked as dirty.
+ * @nr_pages: Number of pages to dirty.
+ *
+ * This is equivalent to filemap_dirty_folio() except it takes in the number of
+ * pages in the folio to account for as dirty when it updates internal dirty
+ * stats instead of accounting all pages in the folio as dirty. If the folio is
+ * already dirty, calling this function will still update the stats. As such,
+ * the caller is responsible for ensuring no overaccounting happens.
+ *
+ * The same caller responsibilities apply here as for filemap_dirty_folio()
+ * (eg, should ensure this doesn't race with truncation/writeback).
+ */
+bool filemap_dirty_folio_pages(struct address_space *mapping,
+			struct folio *folio, long nr_pages)
+{
+	bool newly_dirty = !folio_test_set_dirty(folio);
+
+	__folio_mark_dirty(folio, mapping, !folio_test_private(folio),
+			nr_pages, newly_dirty);
+
+	if (newly_dirty && mapping->host) {
+		/* !PageAnon && !swapper_space */
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	}
+
+	return newly_dirty;
+}
+
 /**
  * folio_redirty_for_writepage - Decline to write a dirty folio.
  * @wbc: The writeback control.
-- 
2.47.3


