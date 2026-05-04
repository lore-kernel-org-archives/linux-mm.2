Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80924CD3436
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4F56B008C; Mon,  4 May 2026 09:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C346B0092; Mon,  4 May 2026 09:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2216B0093; Mon,  4 May 2026 09:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC2756B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:21:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81163C0621
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:21:35 +0000 (UTC)
X-FDA: 84729799350.04.D785B4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id CAC0680009
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:21:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j54ynDpx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777900893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcmZjfE/LHTsqQsPZHww5DdcTEyFZ3aZUgScblzTB3Q=;
	b=qjk0tbAh7KEDt+Whv9wIf6IOcL5wQ5DNF5fxqZE269P8/eUJyaw0nulJyK1eLWGGxDYdrt
	3EQuxvcmS+BLI/EdNgwSIRoqft5UZ3dcJSEMyofjyntvCbKnv20dwm7xQea+2UpsWysion
	lPO/T543Fwx2b6Ix3FhgUzWq1+9m44Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777900893; a=rsa-sha256;
	cv=none;
	b=iMnqip6bNLBYfyiY2jGDPc9slpm5kyVt24SYJGKW+P3nrmw7odajtOFZ1HHIsoBDpY8+zH
	SDiqePAXJFYoyEvLgiFJS1+yMvNmx7uUkD0NBe032UEAIe1zevNExs/eomMo4Qwck9fJPu
	di1JBwEqQQikiGfRuD+/vwNForwp9uU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j54ynDpx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4116560581;
	Mon,  4 May 2026 13:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EEFC2BCB9;
	Mon,  4 May 2026 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777900893;
	bh=K5q1zRIUANtP5+ezPR77QL8VR3Y+17PrUYBZelKYwQA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=j54ynDpx41SgtpTVwV13AhhL34YKqxMGpZizKJZcLZ+2+lrgjuxzi3Zk5lCbe4zOj
	 6XTe/latR5gEu258dSfB0RATqtjUNpF9v+RQKNcgwGwNTzzkIg8p9JqGbjNJtPLYr/
	 oYoEV24VejBaNO75lVqN4Xn1pR3DIjsXA+F5+nHZs0zRRdXiVDJPJWTgkySqU2tdnN
	 nQEyBH4d6Kr1W3NiQ/+O8XvrSkKKS/fY6I/KqFbmMkZdzo4v0shUYt9lN4T7u1/xhj
	 lMpu+qOjNXn4CSMhwSMIJCkqEdLdAhhQ4ycUeyND4Lj5LsRbn20ljQfk8Z0JH86A+6
	 jTEtqphdH50Mw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 04 May 2026 15:20:50 +0200
Subject: [PATCH v5 2/2] mm: kick writeback flusher for IOCB_DONTCACHE with
 targeted dirty tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-dontcache-v5-2-4103e58bb377@kernel.org>
References: <20260504-dontcache-v5-0-4103e58bb377@kernel.org>
In-Reply-To: <20260504-dontcache-v5-0-4103e58bb377@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9241; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=K5q1zRIUANtP5+ezPR77QL8VR3Y+17PrUYBZelKYwQA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp+J1NiIvi0vMSfHfxkcBTX763n3T4fxh6pexT8
 YCbsfLYCRmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCafidTQAKCRAADmhBGVaC
 FVOaEACVZZ3bkMrZlVY1320n9egVK7t2tt9rIjgPzUaEXprs9pjMWgMRRQBIeC/Rwy3a94SfMUN
 koHfEaSesiOsNg72wBd2wlkTFYmsjM78M+aRz3jMrlAXQsSrGaOr1f3LJ4qXKmd+C711vkWKkRv
 5q85XNGvIWF2mXApReoSsgxQy4jcJSQu9Qwjsl2s7CKyCiX3HhA/Cuv7SPAAcUcmbqKc3EzugtS
 OgSgiHHhdxTGoXK/FOXFhz1M/E5a3sHr17qUwo6DsyjKyvSiFlsLiWYuEgKIwxW6J1itILeGi8a
 X0be5F2+6gEBRou/yF5fvH8jZC9+lCeFdNR+lXwC+n/OAVltkPu6IrAv4JA6Bk2mfFUlOSvsrEQ
 Ncxjpww+Q0YBtE1NAu8Qjx+a2lht0xI+/7NxkO85sAfU93F4egCAvh5If+Nw3e2in2GVfNmPbuj
 KSFEhBsa17IXZoIeQ5ZG4hseRVWRlneHq9x3d0G12HOyjseq6MSgUjzvBTP5ywDe921aWQu1hTI
 /+3Iog762IfDxLhzPA76ZAPhPQu4ZSDdjfbPaqzYu7toyaRBJDea8311y7NLM2Uer5E2ug2Vd2+
 ZJVieEQ3C74DSbEN8cGc/KbZZvI6XhA2tTaJV8y0iVfcRGspgZu1u680cvRQwl3m8EkLnkYe/gU
 6IX0WNnHJ9rfE5Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: CAC0680009
X-Rspamd-Server: rspam04
X-Stat-Signature: 7a4iaoenuy37cyuj1hxzmn5q4mhscreg
X-HE-Tag: 1777900893-47181
X-HE-Meta: U2FsdGVkX18faczv7I/dQmoBhIpE8n49vRYG6T48zjeG8K/8jowl0tbH9ftx3f0WxOBaHtulecgppEbRg4nD2/2hrUdaY4a8GyV0RA9fqUqPWJMGr73abwB2ZugPsDRYOHBVQPnk8wSq/whDq1shnBG6tsDoY/G2xesgkRDZKQR1HAVIXxrQUaMyexBvUz1ystz70Gdb0q/v2KH/Q60t5OIe7Xcu1Nm4gDQlJ8vtBDiFiNTvhNXGvbAEc9iQOnV9/iENvthhqOSfmhseNo28Xxvrqs8d1ydnw7JiwLFmj0E/iThC2HFHLCJwrfz9wxk/FAi6w7nC6/cAoK9OsSN5Fzdu/Zl3R2gZpclLxUzhme/gLSeZx1l+uRDEIZaeRyFJ5u7x3LfehtkfP87QzviM8Jgi+j7MnPDaIxCxx0vPf49EpCYdKS3lEE1l+QVId8scxNM19f3gA+Y79tuRyxCjUuAg1TVx//25ParpAg5GT2wZGSiQGnqh+iUNk5ZczEMBT+tpkaNtJxsxVxrlvs2ys9eT4/E+CZr5TLEgI8int2AjBz2/9UeBvJ77RZ/l/HShQrRVkE/P/obEyCzYjKKWPxFQ5rYfNbSpb5OAWdXNyO9D5XviVhMDq5vvtge9LAN1Ir0+6kJpNjmo3+wod0PmagIjK7r6eOm9m91fwF/c+L9QSiuM03VhsboPzqOyX0CBg4m2FBKnm/Lg3L91Gl/702l9tvKb9nRgTEi1vAIdMdY5TbUUet6wL72moRwefkWFJss5MP7wwQhnWrxAMdnGTiVLhyrFlzaPyah5HkypSJiD66LT9Sf/fbrDcyb5GhcQ20xCGEadX4ver42L9jwW9StG1R15C0Ft3EIoZTbhHdqhc3U96Xft1SbzpHBOeu6RYPxBpVT9r78RJNPORPZBD3XNLcoWJtve2E9IvHIPUI6Rcl9GEZntSOEsVoqarZ2RX3EHqz9TB5/sqU3lFv/
 gGW10e8z
 hk4qF0fCAcAbukEVu4bkWaQIJtdsY8ZI6DPpf+f7RcK+lmKJ4BmXo2v4T83zsExSg83O0uEwgNVSOJltyseDiWp/HCM+eFNzG+EF3CQi3JUKKRU0x9RAs4Rv7Re7F5x5R83xZZ0NCuKve4U/J3WNGsn2s6imi8wjTVpkfasa/73VhItzaueLjZLjCoRSug9t3KiXbOXHcIN1Lmy2KJzz7IGdJ9r7d3p713Oy81pGa8pUym4gEcLm5e5YTI1772tWM135+NrhcrSeQwK10rdHeQMD8s5D7gABjlV+nsOFw1H7RbD0mMGER5zQp/ZocYNzCUL0K1oQHTbP142zV/nmpWRZsy9pb/D2Z9NZZifT1e3YxoVNRAhVfgmA6rGniitdr7sUE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The IOCB_DONTCACHE writeback path in generic_write_sync() calls
filemap_flush_range() on every write, submitting writeback inline in
the writer's context.  Perf lock contention profiling shows the
performance problem is not lock contention but the writeback submission
work itself — walking the page tree and submitting I/O blocks the writer
for milliseconds, inflating p99.9 latency from 23ms (buffered) to 93ms
(dontcache).

Replace the inline filemap_flush_range() call with a flusher kick that
drains dirty pages in the background.  This moves writeback submission
completely off the writer's hot path.

To avoid flushing unrelated buffered dirty data, add a dedicated
WB_start_dontcache bit and wb_check_start_dontcache() handler that uses
the per-wb WB_DONTCACHE_DIRTY counter to determine how many pages to
write back.  The flusher writes back that many pages from the oldest dirty
inodes (not restricted to dontcache-specific inodes). This helps
preserve I/O batching while limiting the scope of expedited writeback.

Like WB_start_all, the WB_start_dontcache bit coalesces multiple
DONTCACHE writes into a single flusher wakeup without per-write
allocations.

Also add WB_REASON_DONTCACHE as a new writeback reason for tracing
visibility, and target the correct cgroup writeback domain via
unlocked_inode_to_wb_begin().

dontcache-bench results (same host, T6F_SKL_1920GBF, 251 GiB RAM,
xfs on NVMe, fio io_uring):

Buffered and direct I/O paths are unaffected by this patchset. All
improvements are confined to the dontcache path:

Single-stream throughput (MB/s):
                        Before    After    Change
  seq-write/dontcache      298      897    +201%
  rand-write/dontcache     131      236     +80%

Tail latency improvements (seq-write/dontcache):
  p99:    135,266 us  ->  23,986 us   (-82%)
  p99.9: 8,925,479 us ->  28,443 us   (-99.7%)

Multi-writer (4 jobs, sequential write):
                                Before    After    Change
  dontcache aggregate (MB/s)     2,529    4,532     +79%
  dontcache p99 (us)             8,553    1,002     -88%
  dontcache p99.9 (us)         109,314    1,057     -99%

  Dontcache multi-writer throughput now matches buffered (4,532 vs
  4,616 MB/s).

32-file write (Axboe test):
                                Before    After    Change
  dontcache aggregate (MB/s)     1,548    3,499    +126%
  dontcache p99 (us)            10,170      602     -94%
  Peak dirty pages (MB)          1,837      213     -88%

  Dontcache now reaches 81% of buffered throughput (was 35%).

Competing writers (dontcache vs buffered, separate files):
                                Before    After
  buffered writer                  868      433 MB/s
  dontcache writer                 415      433 MB/s
  Aggregate                      1,284      866 MB/s

  Previously the buffered writer starved the dontcache writer 2:1.
  With per-bdi_writeback tracking, both writers now receive equal
  bandwidth. The aggregate matches the buffered-vs-buffered baseline
  (863 MB/s), indicating fair sharing regardless of I/O mode.

  The dontcache writer's p99.9 latency collapsed from 119 ms to
  33 ms (-73%), eliminating the severe periodic stalls seen in the
  baseline. Both writers now share identical latency profiles,
  matching the buffered-vs-buffered pattern.

The per-bdi_writeback dirty tracking dramatically reduces peak dirty
pages in dontcache workloads, with the 32-file test dropping from
1.8 GB to 213 MB. Dontcache sequential write throughput triples and
multi-writer throughput reaches parity with buffered I/O, with tail
latencies collapsing by 1-2 orders of magnitude.

Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fs-writeback.c                | 65 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  2 ++
 include/linux/fs.h               |  6 ++--
 include/trace/events/writeback.h |  3 +-
 4 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a65694cbfe68..ebef485b2f8b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1334,6 +1334,18 @@ static void wb_start_writeback(struct bdi_writeback *wb, enum wb_reason reason)
 	wb_wakeup(wb);
 }
 
+static void wb_start_dontcache_writeback(struct bdi_writeback *wb)
+{
+	if (!wb_has_dirty_io(wb))
+		return;
+
+	if (test_bit(WB_start_dontcache, &wb->state) ||
+	    test_and_set_bit(WB_start_dontcache, &wb->state))
+		return;
+
+	wb_wakeup(wb);
+}
+
 /**
  * wb_start_background_writeback - start background writeback
  * @wb: bdi_writback to write from
@@ -2373,6 +2385,28 @@ static long wb_check_start_all(struct bdi_writeback *wb)
 	return nr_pages;
 }
 
+static long wb_check_start_dontcache(struct bdi_writeback *wb)
+{
+	long nr_pages;
+
+	if (!test_bit(WB_start_dontcache, &wb->state))
+		return 0;
+
+	nr_pages = wb_stat(wb, WB_DONTCACHE_DIRTY);
+	if (nr_pages) {
+		struct wb_writeback_work work = {
+			.nr_pages	= nr_pages,
+			.sync_mode	= WB_SYNC_NONE,
+			.range_cyclic	= 1,
+			.reason		= WB_REASON_DONTCACHE,
+		};
+
+		nr_pages = wb_writeback(wb, &work);
+	}
+
+	clear_bit(WB_start_dontcache, &wb->state);
+	return nr_pages;
+}
 
 /*
  * Retrieve work items and do the writeback they describe
@@ -2394,6 +2428,11 @@ static long wb_do_writeback(struct bdi_writeback *wb)
 	 */
 	wrote += wb_check_start_all(wb);
 
+	/*
+	 * Check for dontcache writeback request
+	 */
+	wrote += wb_check_start_dontcache(wb);
+
 	/*
 	 * Check for periodic writeback, kupdated() style
 	 */
@@ -2468,6 +2507,32 @@ void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
 	rcu_read_unlock();
 }
 
+/**
+ * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE writes
+ * @mapping:	address_space that was just written to
+ *
+ * Kick the writeback flusher thread to expedite writeback of dontcache dirty
+ * pages. Queue writeback for the inode's wb for as many pages as there are
+ * dontcache pages, but don't restrict writeback to dontcache pages only.
+ *
+ * This significantly improves performance over either writing all wb's pages
+ * or writing only dontcache pages.  Although it doesn't guarantee quick
+ * writeback and reclaim of dontcache pages, it keeps the amount of dirty pages
+ * in check. Over longer term dontcache pages get written and reclaimed by
+ * background writeback even with this rough heuristic.
+ */
+void filemap_dontcache_kick_writeback(struct address_space *mapping)
+{
+	struct inode *inode = mapping->host;
+	struct bdi_writeback *wb;
+	struct wb_lock_cookie cookie = {};
+
+	wb = unlocked_inode_to_wb_begin(inode, &cookie);
+	wb_start_dontcache_writeback(wb);
+	unlocked_inode_to_wb_end(inode, &cookie);
+}
+EXPORT_SYMBOL_GPL(filemap_dontcache_kick_writeback);
+
 /*
  * Wakeup the flusher threads to start writeback of all currently dirty pages
  */
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index cb660dd37286..4f1084937315 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -26,6 +26,7 @@ enum wb_state {
 	WB_writeback_running,	/* Writeback is in progress */
 	WB_has_dirty_io,	/* Dirty inodes on ->b_{dirty|io|more_io} */
 	WB_start_all,		/* nr_pages == 0 (all) work pending */
+	WB_start_dontcache,	/* dontcache writeback pending */
 };
 
 enum wb_stat_item {
@@ -56,6 +57,7 @@ enum wb_reason {
 	 */
 	WB_REASON_FORKER_THREAD,
 	WB_REASON_FOREIGN_FLUSH,
+	WB_REASON_DONTCACHE,
 
 	WB_REASON_MAX,
 };
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11559c513dfb..df72b42a9e9b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2624,6 +2624,7 @@ extern int __must_check file_write_and_wait_range(struct file *file,
 						loff_t start, loff_t end);
 int filemap_flush_range(struct address_space *mapping, loff_t start,
 		loff_t end);
+void filemap_dontcache_kick_writeback(struct address_space *mapping);
 
 static inline int file_write_and_wait(struct file *file)
 {
@@ -2657,10 +2658,7 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
 		if (ret)
 			return ret;
 	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
-		struct address_space *mapping = iocb->ki_filp->f_mapping;
-
-		filemap_flush_range(mapping, iocb->ki_pos - count,
-				iocb->ki_pos - 1);
+		filemap_dontcache_kick_writeback(iocb->ki_filp->f_mapping);
 	}
 
 	return count;
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index bdac0d685a98..13ee076ccd16 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -44,7 +44,8 @@
 	EM( WB_REASON_PERIODIC,			"periodic")		\
 	EM( WB_REASON_FS_FREE_SPACE,		"fs_free_space")	\
 	EM( WB_REASON_FORKER_THREAD,		"forker_thread")	\
-	EMe(WB_REASON_FOREIGN_FLUSH,		"foreign_flush")
+	EM( WB_REASON_FOREIGN_FLUSH,		"foreign_flush")	\
+	EMe(WB_REASON_DONTCACHE,		"dontcache")
 
 WB_WORK_REASON
 

-- 
2.54.0


