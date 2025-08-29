Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B51CA0FFE
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E39A8E0015; Fri, 29 Aug 2025 19:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9228E0001; Fri, 29 Aug 2025 19:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625AA8E0015; Fri, 29 Aug 2025 19:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCCC8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:40:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 108D513AB88
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:11 +0000 (UTC)
X-FDA: 83831415822.11.6B5FFA9
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 263F440009
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X7O2sGt8;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGpw0mdO7CMkEmFTqe/yJx/RGR5vQk5tTnmLJYozAKc=;
	b=vdo4/d5QsI5BogMGELtOG6qcW8mNzLE6TDLr2/JQmTBt9pswpzbA7wJtEP8ArybMU2EKe0
	joirb7fpn2NS1uYi/mjJed4YO5/TqMR0HrX/Siko0qJYMaJ85/3JE2kj99Mj2gs9/lHKnU
	e3Mc203T4GFP3ZWBE93+Pdr9kIAYqPY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X7O2sGt8;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510809; a=rsa-sha256;
	cv=none;
	b=fDhsnLrrYdQna4p0toLSNPDCDb7+zR5eWJWMxDRXFY3te/y5+mTF7R/e8oqEvLoWkX8cbl
	qtIKBcmsrVManYl+5BCkCIk0xVlms5y/1KsEE5PtFWbhuAvxBBDCIFuE2+q+Fk6jkGL3RE
	YEhG53abqJFIZLmZHOy4ufamb6Y+KHU=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2489c65330aso24915755ad.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510808; x=1757115608; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yGpw0mdO7CMkEmFTqe/yJx/RGR5vQk5tTnmLJYozAKc=;
        b=X7O2sGt8Y12L+I3BS7aRIXfWtUnI6nc/csJzcuK5K2xLiLHr2UngFOH3gPDOAG0/+k
         AgBevz9Yc4sCFK1CJ4QM16/7jmkBPOzOHbN+ZArzI6xBFmDCv7zfQmB2qmj/ys0O/Qb9
         2VcTKyzasN8nfztul2fhw1jSBbGo44+op+pW9GhDMMbTYtWKI+hII4Pzv1r6iKZY2VqS
         OgP/C8aZ0aq1E5GHS0p3aHbuknAV9qysdR3bsoC8UrNRENLiOcgO6y2HDjwR20NZ/jqJ
         nUcbF5BDkSkiKZY4k2YG+1c8y9bQsEic1X5XJzzjqFAclaHPJuHNLRZD1ZKrrJ7qiV5l
         Etdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510808; x=1757115608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yGpw0mdO7CMkEmFTqe/yJx/RGR5vQk5tTnmLJYozAKc=;
        b=fQptQnn56Hz0xOw039VGey84WMl+IO9ugoBgmkI9X5BLpyMeWRilJ6Sw1a3CllZkb7
         aPF4mpD7P1qkyNCYFxR8Jk5OYeoLWusnKHjXNACUEVu5eOMWhwdgF31RgjcOrTr9oiuY
         1CjfXQBCgmSFAu5QlAy8EnjjQAm/qFUa5PvtIpr+mDt5a7cG2V5LA0koj3l9Re1a0sp5
         jWC6m7eGspyDZJG3gzYSyFdn4ri4oz4g6+1n7tkgMnQTdzHmbr/IUbtubrrI5CVx4/Ye
         P3sJ7Hm7Lpw0I/ZP9rIW/J0MrfLNTWApA1sWrLuGG3LkpwyNi2Wx69X7gS2OYnVWNwdp
         o1rg==
X-Gm-Message-State: AOJu0YwzGcT3ol2CF3CyLZQRNi4POTV1WFeKOCbUlxNhqAvu6yrih1zg
	okzttl/cY9gMZl/9i1FOllLIAXruYaTflXurLvkrPUYtiZu/RsUBr4mj7qyr4w==
X-Gm-Gg: ASbGnctUqLT6Ly+tWWuvE4Fcv1t7HY/s1DU2QemIdaTXtRSOFkxQTqjyApPt/0BIoNx
	zPK1JEr6E2c95MI7alfFCX62HChAxIowy6S97B0wWf8RznCo7MN0f/cv8eLeejiwMnbDpuyfhVN
	qbbNNrcWEgmXFaSHE/22HaSz5R/dNGQ7zL+X5eutVj+RAbpdFhW3LQJ3kPZ2Zt1YMbaClAmQnYr
	kOKUT8HTkoT97UskHteVasatJ56Rc745M0ksMs6Wk34XNhBnKw4WBPllfMXjCyzp6C/6msJJ0Gl
	/BQxhjDCoYmw8FR31LFkWczEbXMlgtg3ZUuzCs8Vsnx2+whIk8roqQdjDrIZv+5xWu89V8v869x
	/gz8j93p7kehihvYP+rbh/+BPUeY=
X-Google-Smtp-Source: AGHT+IErcgarYy/T/LbpOd01mEs/a9St9zKIi7FuGSacJVKNtjl6t5fcTCh4n3hQ+dLs6MtazbkK0w==
X-Received: by 2002:a17:903:2b0d:b0:248:cb07:6df0 with SMTP id d9443c01a7336-24944a11330mr6113675ad.5.1756510807822;
        Fri, 29 Aug 2025 16:40:07 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903758b89sm36026645ad.59.2025.08.29.16.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:40:07 -0700 (PDT)
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
Subject: [PATCH v2 12/12] iomap: add granular dirty and writeback accounting
Date: Fri, 29 Aug 2025 16:39:42 -0700
Message-ID: <20250829233942.3607248-13-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ngi5isrb3bxqxkmi1e9t9mpusk5t6k7o
X-Rspam-User: 
X-Rspamd-Queue-Id: 263F440009
X-Rspamd-Server: rspam05
X-HE-Tag: 1756510808-990668
X-HE-Meta: U2FsdGVkX18iP4OchOF0tnckSwmoQqK9ZM31pOSAGdpB+tyS6+ozVD3bN8D0PR1lJJ4H31dhcVJ1sqkrSQqGCFfbJ+s/mG1bE0PnO8rB4vPR9PO/pvIaMu+DPqmTJxwGNyNaTZ4Yx5ccvAL3PNM79Nwwgwlsj3hPdl173sz4rLFVeOraLatO+/8UVBwqGrk2NtILybseboKaCbma8px7pmxPKnYKRSt0tRMNaj69kCnrUaxK5rs0037xZPh2r50ORKKGgaMbnMj46hXP6Nfxrvg9zYYtQjNQDgY6yOjUsbjaWgN9kRuqns2hQt3JbcK/QwZ2+cR74YBE+g4n6lnVh1oZ0FP/Ht01U055RGymKPGGF96VfMMln5Gjh3A0K7+mjN4XW9JgMXaZCTqY/uB/wY7YYEDLPIbJwJRKoHHQsJe7QLXCcjPjvPXP1SWuz2w/gKTL+CmWqTLOU2PfDs9V84sj+v3TDpxuGFL4FGTGOKtyep6gLWgq0d0m+iDEm78oc+tOeB+iehchnyA7POiKrNfOumAOc+BV9niBXpK0nHs+6k2XsWpXcEhzvbzUq5DbfnIbIuYo2fAuE4jXiQdbmgS50+FzBdvEhD7LNQmpcMHpgqKhEj0UWCT1DYDAjDULh9T0wVqYpg4n3alPARTiFE5VM4vbbbh73l0NIPNBntGm5ZwctGWFsIYipVPXMbv/P9bAfJODLUEfXhE1oDG7GeDd9gFYGet7QaKHJR6mF47lw4AePIz6eqvBm7tNXjA8sFNe6aAvBryfY7rTBnxcXD3N+JLu+lMKhKa/X8LRUVx0cVydQc4FFGRtYbGSOGkn5j2DkuVory573hQ0HqVroPLnH4VhV/HvV0+pNB3vx10mzsCRcZJFP56P1ROkP7QoQ2LuqOhfsk07323bL6B6R5+8fV4yZ0pNuKu/AkA4xEOytMwJkb+35lB5pdaCPjSzW/rrf7y2Z6XyG3E2bGY
 /wrmAH4H
 hQSh0eJsr+H0//4M7WOPXed9rXO2pr+WWf5fLETmT5xbKsvn/4L+cD4cnqVNNV4pE5/yZp3iFoYuLqETV0g0W8mjqhqONiR2FnNQ8jgeN6zqAl3Zfv8eMdAne2MLdRVnxd4PJH/ncDLIgUoabybY/6vWRufHEBwIJdFqorjPiwODyJJehE+9aZi4NJUxwJapzOcqaxuMmkxTfILQstVFp5BftL7nCrM5RD+X/nS79+ZGHgHg42gFJ3F7v0rW8+6t/givuwjYfpr/IU/atCAEFVPyK2Xcx/6YODGMtbsXs9WjQffELEcAOtgAUPjZAphYWpf0EZvs1BM8Y2u+RhdUnWVZ94uJqBW1tdn6zKqeBLM3/7UXo/XBePjkwKfE2eijzwFXJ4q13PSCmtUoM5j4AogEGDtCxZUiN2YoBfTfmymTOz4sMcSq3G0oBW6P1SDcc+kHjuWtObF102EIyRoEUDcvaqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add granular dirty and writeback accounting for large folios. These
stats are used by the mm layer for dirty balancing and throttling.
Having granular dirty and writeback accounting helps prevent
over-aggressive balancing and throttling.

There are 4 places in iomap this commit affects:
a) filemap dirtying, which now calls filemap_dirty_folio_pages()
b) writeback_iter with setting the wbc->no_stats_accounting bit and
calling clear_dirty_for_io_stats()
c) starting writeback, which now calls __folio_start_writeback()
d) ending writeback, which now calls folio_end_writeback_pages()

This relies on using the ifs->state dirty bitmap to track dirty pages in
the folio. As such, this can only be utilized on filesystems where the
block size >= PAGE_SIZE.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/buffered-io.c | 140 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 132 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 4f021dcaaffe..bf33a5361a39 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -20,6 +20,8 @@ struct iomap_folio_state {
 	spinlock_t		state_lock;
 	unsigned int		read_bytes_pending;
 	atomic_t		write_bytes_pending;
+	/* number of pages being currently written back */
+	unsigned		nr_pages_writeback;
 
 	/*
 	 * Each block has two bits in this bitmap:
@@ -139,6 +141,29 @@ static unsigned ifs_next_clean_block(struct folio *folio,
 		blks + start_blk) - blks;
 }
 
+static unsigned ifs_count_dirty_pages(struct folio *folio)
+{
+	struct inode *inode = folio->mapping->host;
+	unsigned block_size = i_blocksize(inode);
+	unsigned start_blk, end_blk;
+	unsigned blks, nblks = 0;
+
+	start_blk = 0;
+	blks = i_blocks_per_folio(inode, folio);
+	end_blk = (i_size_read(inode) - 1) >> inode->i_blkbits;
+	end_blk = min(end_blk, i_blocks_per_folio(inode, folio) - 1);
+
+	while (start_blk <= end_blk) {
+		start_blk = ifs_next_dirty_block(folio, start_blk, end_blk);
+		if (start_blk > end_blk)
+			break;
+		nblks++;
+		start_blk++;
+	}
+
+	return nblks * (block_size >> PAGE_SHIFT);
+}
+
 static unsigned ifs_find_dirty_range(struct folio *folio,
 		struct iomap_folio_state *ifs, u64 *range_start, u64 range_end)
 {
@@ -220,6 +245,58 @@ static void iomap_set_range_dirty(struct folio *folio, size_t off, size_t len)
 		ifs_set_range_dirty(folio, ifs, off, len);
 }
 
+static long iomap_get_range_newly_dirtied(struct folio *folio, loff_t pos,
+		unsigned len)
+{
+	struct inode *inode = folio->mapping->host;
+	unsigned block_size = i_blocksize(inode);
+	unsigned start_blk, end_blk;
+	unsigned nblks = 0;
+
+	start_blk = pos >> inode->i_blkbits;
+	end_blk = (pos + len - 1) >> inode->i_blkbits;
+	end_blk = min(end_blk, i_blocks_per_folio(inode, folio) - 1);
+
+	while (start_blk <= end_blk) {
+		/* count how many clean blocks there are */
+		start_blk = ifs_next_clean_block(folio, start_blk, end_blk);
+		if (start_blk > end_blk)
+			break;
+		nblks++;
+		start_blk++;
+	}
+
+	return nblks * (block_size >> PAGE_SHIFT);
+}
+
+static bool iomap_granular_dirty_pages(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+
+	if (!ifs)
+		return false;
+
+	return i_blocksize(folio->mapping->host) >= PAGE_SIZE;
+}
+
+static bool iomap_dirty_folio_range(struct address_space *mapping,
+			struct folio *folio, loff_t pos, unsigned len)
+{
+	long nr_new_dirty_pages;
+
+	if (!iomap_granular_dirty_pages(folio)) {
+		iomap_set_range_dirty(folio, pos, len);
+		return filemap_dirty_folio(mapping, folio);
+	}
+
+	nr_new_dirty_pages = iomap_get_range_newly_dirtied(folio, pos, len);
+	if (!nr_new_dirty_pages)
+		return false;
+
+	iomap_set_range_dirty(folio, pos, len);
+	return filemap_dirty_folio_pages(mapping, folio, nr_new_dirty_pages);
+}
+
 static struct iomap_folio_state *ifs_alloc(struct inode *inode,
 		struct folio *folio, unsigned int flags)
 {
@@ -712,8 +789,7 @@ bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio)
 	size_t len = folio_size(folio);
 
 	ifs_alloc(inode, folio, 0);
-	iomap_set_range_dirty(folio, 0, len);
-	return filemap_dirty_folio(mapping, folio);
+	return iomap_dirty_folio_range(mapping, folio, 0, len);
 }
 EXPORT_SYMBOL_GPL(iomap_dirty_folio);
 
@@ -937,8 +1013,8 @@ static bool __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 	if (unlikely(copied < len && !folio_test_uptodate(folio)))
 		return false;
 	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
-	iomap_set_range_dirty(folio, offset_in_folio(folio, pos), copied);
-	filemap_dirty_folio(inode->i_mapping, folio);
+	iomap_dirty_folio_range(inode->i_mapping, folio,
+			offset_in_folio(folio, pos), copied);
 	return true;
 }
 
@@ -1613,6 +1689,29 @@ void iomap_start_folio_write(struct inode *inode, struct folio *folio,
 }
 EXPORT_SYMBOL_GPL(iomap_start_folio_write);
 
+static void iomap_folio_start_writeback(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+
+	if (!iomap_granular_dirty_pages(folio))
+		return folio_start_writeback(folio);
+
+	__folio_start_writeback(folio, false, ifs->nr_pages_writeback);
+}
+
+static void iomap_folio_end_writeback(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	long nr_pages_writeback;
+
+	if (!iomap_granular_dirty_pages(folio))
+		return folio_end_writeback(folio);
+
+	nr_pages_writeback = ifs->nr_pages_writeback;
+	ifs->nr_pages_writeback = 0;
+	folio_end_writeback_pages(folio, nr_pages_writeback);
+}
+
 void iomap_finish_folio_write(struct inode *inode, struct folio *folio,
 		size_t len)
 {
@@ -1622,7 +1721,7 @@ void iomap_finish_folio_write(struct inode *inode, struct folio *folio,
 	WARN_ON_ONCE(ifs && atomic_read(&ifs->write_bytes_pending) <= 0);
 
 	if (!ifs || atomic_sub_and_test(len, &ifs->write_bytes_pending))
-		folio_end_writeback(folio);
+		iomap_folio_end_writeback(folio);
 }
 EXPORT_SYMBOL_GPL(iomap_finish_folio_write);
 
@@ -1710,6 +1809,21 @@ static bool iomap_writeback_handle_eof(struct folio *folio, struct inode *inode,
 	return true;
 }
 
+static void iomap_update_dirty_stats(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	long nr_dirty_pages;
+
+	if (iomap_granular_dirty_pages(folio)) {
+		nr_dirty_pages = ifs_count_dirty_pages(folio);
+		ifs->nr_pages_writeback = nr_dirty_pages;
+	} else {
+		nr_dirty_pages = folio_nr_pages(folio);
+	}
+
+	clear_dirty_for_io_stats(folio, nr_dirty_pages);
+}
+
 int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 {
 	struct iomap_folio_state *ifs = folio->private;
@@ -1727,6 +1841,8 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 
 	trace_iomap_writeback_folio(inode, pos, folio_size(folio));
 
+	iomap_update_dirty_stats(folio);
+
 	if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
 		return 0;
 	WARN_ON_ONCE(end_pos <= pos);
@@ -1734,6 +1850,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 	if (i_blocks_per_folio(inode, folio) > 1) {
 		if (!ifs) {
 			ifs = ifs_alloc(inode, folio, 0);
+			ifs->nr_pages_writeback = folio_nr_pages(folio);
 			iomap_set_range_dirty(folio, 0, end_pos - pos);
 		}
 
@@ -1751,7 +1868,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 	 * Set the writeback bit ASAP, as the I/O completion for the single
 	 * block per folio case happen hit as soon as we're submitting the bio.
 	 */
-	folio_start_writeback(folio);
+	iomap_folio_start_writeback(folio);
 
 	/*
 	 * Walk through the folio to find dirty areas to write back.
@@ -1784,10 +1901,10 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 	 */
 	if (ifs) {
 		if (atomic_dec_and_test(&ifs->write_bytes_pending))
-			folio_end_writeback(folio);
+			iomap_folio_end_writeback(folio);
 	} else {
 		if (!wb_pending)
-			folio_end_writeback(folio);
+			iomap_folio_end_writeback(folio);
 	}
 	mapping_set_error(inode->i_mapping, error);
 	return error;
@@ -1809,6 +1926,13 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
 			PF_MEMALLOC))
 		return -EIO;
 
+	/*
+	 * iomap opts out of the default wbc stats accounting because it does
+	 * its own granular dirty/writeback accounting (see
+	 * iomap_update_dirty_stats()).
+	 */
+	wpc->wbc->no_stats_accounting = true;
+
 	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {
 		error = iomap_writeback_folio(wpc, folio);
 		folio_unlock(folio);
-- 
2.47.3


