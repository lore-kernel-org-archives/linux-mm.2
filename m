Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86392CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 19:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D778C6B0095; Tue,  5 May 2026 15:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E556B0096; Tue,  5 May 2026 15:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C649A6B0098; Tue,  5 May 2026 15:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7A1D6B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:00:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A3A81606B5
	for <linux-mm@kvack.org>; Tue,  5 May 2026 19:00:23 +0000 (UTC)
X-FDA: 84734281926.10.FE6097F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6CFD5C000E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 19:00:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Pw/HlPtL";
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778007621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXSFt34BXVtQv08D4r1/emCpF2CBjJSMvw9LbX0rS2U=;
	b=upuMIdKEf78pjkZEnFZ9iSIjUebSz0UnSuzpg5vu/KbPnpsRb9uWy8ddDm+4dUH+NN0NjK
	N5emc6lq3K4DGMRhjDcJnXlWapxOsFZX/cA1ET6+QaHsy5VueP4gXCnGeamtnQLEX50hYq
	oB5fcgf3G2t9fxLg/1cKyfbNfHVRU7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778007621; a=rsa-sha256;
	cv=none;
	b=NMNSaL6eYyaQtno3R8BHVYnFQMJnAVfoL1ikqoRm1ttPfKz2B9+dcRluHvL9jARVupdt2v
	VmdMLOGaRz1zd9VDGYWnWVsA0Tfg/ljx8Fg2iuRC3CAVZgX4TzL6sVCOqC9GFZQbuhYbVK
	YHY5kijVkxcamRRk+WqtInmcLyQaLSo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Pw/HlPtL";
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86ECF60181;
	Tue,  5 May 2026 19:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E64C2BCB4;
	Tue,  5 May 2026 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778007620;
	bh=/OcYNCE/fDC5kwoNxmn93OOTbnEEIB7Un/u2ZoKZZmM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Pw/HlPtLi9QZuSy0R/GnGVx/M088vN+is++AsVyK+HkM65BpmXKrjG1+FtVEufNbF
	 1JTwPCDtTtFASeItu0D/qS/p7Hrmo5kPk8V12o7x+VtPlFlstl0AoU1oma0wToRPKE
	 qvaLSBSW7sZQltZopaacSX5nIxkIsQBYz1vltvTlMljHo4qJzJZK5ps13ccTFCnyWu
	 voQfWk/C0S4JQJRq0Vn56aWoQxcFPCikGxFRGRzIJojN3iKBreYa0PeZRgr3y9nngK
	 3YZcffK8BS+CHZ/ln1P9+7SFkSpmhTQdnT7HP6WwLXTuPzVlsPl8sbwh8BqXTmk2Mo
	 wYkZ3nLfCV/lw==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 05 May 2026 20:59:49 +0200
Subject: [PATCH v6 2/2] mm: kick writeback flusher for IOCB_DONTCACHE with
 targeted dirty tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260505-dontcache-v6-2-66463805dd6a@kernel.org>
References: <20260505-dontcache-v6-0-66463805dd6a@kernel.org>
In-Reply-To: <20260505-dontcache-v6-0-66463805dd6a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9615; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=/OcYNCE/fDC5kwoNxmn93OOTbnEEIB7Un/u2ZoKZZmM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp+j4zmzZ7nDbB+fjQU1X+H+KbEaew/Rb2QF6q/
 oHNf3dZOuWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCafo+MwAKCRAADmhBGVaC
 FaZgEACq12/XKwbO+w71Vhf3mCc0WqNQSjceQThHmpkBQv9ZlF8uO/C7lf/v7idibv62hAJPRCC
 H3Uj4IauQdId4XWPj9SxBYQQASNuK+0qILP0XkR0YChV4RZvLPDPuT0ty4BKyyd3G76icATGdZB
 nKc0pdzr/YNo8RK5OI1iOpnlxM+l2jiiI182RtkmnatMQZZ5gfPqNwMSwayO16kMambplXFRMEp
 We13egbqmz7ayZO+RAnbdcpGbqU4doJq9GLZQCK8QNulUwxdmGsjgnB/TRwRA19/XBN1g3L4mSu
 ektu96BSyIIIJ1eWDHCfvNjO83FIlQ3Pal9oPTzrCm8aAUe3cLxiwlVX+YtIJE0smP5JO8x+auv
 iPd8j59q1eton3j/vUG/kuICFmTVHdYguxpBJ7BkbPwOMWPS9RQvj42+TzxwiJCQXqNPloimRKl
 JHWttx/Y0OjA4pypoGH5K8+n7MaFckzIv+S7T8rJXs85UMHci/TnuI6soZn4B7q7ypnxV164bXv
 ZEwwmjaXSgFoR3L/KZ9d/dQXbjr8weRraFl55IX+qcmQ4Anw1DuJqRSaYS8I57lor9WkA+u8yth
 TkogGYAY87faDji9bazKU3HLXprV5pSq9Agpn5Rtw5N+u/oQCY2cN9eM3X26fsP116+XoTxAF0x
 79lm31kEMtSuNcQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6CFD5C000E
X-Rspam-User: 
X-Stat-Signature: btjuy9cktt4necobry5xqeih16n1rig8
X-HE-Tag: 1778007621-941410
X-HE-Meta: U2FsdGVkX18yNe81OcOJJlYvcaTio4Q3kkmSk1g8840Y4MF39lAxQig3KWWx6BsOFHsahU5vF12ng+VhadB5eFJIdwkCLqeS90XWxVb7BnKqPYZIDMstc5PZFtj9+34EElb6KTYLfJOUW4biIFWqmtOLO2L6qdAr4w9NiZzWsCDJerQLnsir3KfMqRomm3viA+goigLhzl5wDbFF4kr9qvsDyxb3MM9qYBTrBIXyXdm7I5/dybuecPwR8P6cZehnQUwP3CYDHhsLPlqP4pAfuQvuHrPjnoAbjVmLocWbD2xUKCYxbBHVFqxAleCRRH67/0xRNyYgJDCNTfHW47IwclmdVCNpJQUfNZ2HPdY01Qekdh+KdwrIG4Qy9ScaqHyGTNSzt4Kqzk4txNQv5KznGNWXI+o0jp66H5C0Y90bDAb4Ugac2mzLsbFXV3j6/lRcIfKDc8yPWnC0nMPzBPdHM6s950NsZoIQF6HljtWZDSL0y1Fu3NGLJS7ukD4ZkMe2GB6GnLFc3E4qaTrVxmefO6VBquj4dwWs0quO+Ka+XG8hiDPkqtb21gGE8ewuAaMEDsdI2GV+hJoa+YVfwosSLbjK8eNu/LSsvSf4wr38KLupqq4vwymzYLYouT1ntlTFSo0FQRHt+QXQvRi52R5E11UDnPYiyxL/ahzBWdbkCD9Esv6RxVW6l7XZx4eycs+M8yOiqGRX2g5uVfG9irmrkskJ3wffgwqTxqRutiGiyqkkDDIgHk9i2QNSqIkokW0PGAdskNaGEF/YJTq2td8Qw/Ji0Nt9x5+p4lLWoBSrZFuZq/V/0ziTaaBOxjsjQOx11pr6dFy4vlTaOlxxEMJYTkAKQZFy33Vy3qpxPMTOSaWfxa8BM/MBf2us4SLpYlBhkrzYzqUpyFInRHKN+cqSCGAMMCwqQReJ4kIKLxWV4MRCUU1lKh2zK5YXMAvtZw2fUBJEheNE1TFppeuFRtY
 kReAi93R
 vbXOctNXXxPyfK0LJSCWzKUaZOEdJBe4+KSajVc+L85OZq6TxuLHzA8HKwbnT+16Vd5SbPDr6kC8kP2vMvpxkU05DhCKro9lTYiwZhycYXKQZu1XuglvSsJbltqQMcPIlKHx+uq/gUiez0WsBMCmHYpryTIkmsfgHEwy9UGAzsvmNOQazUM/mADKt2At0+5iI672iid/M2m+D3F1oR54XaQ5toLI+2/Qzk2SV0fRay5Gs1ATTH8UqtVw2Mq4FXT6TBKK+m60b1R3tQvAr0RZ40NZEUfZaG9Mi30Nd6KqRX58j8KDc+uPf306sfgEweZOyv+Rgd8opI+46XsWuSyJhzgqpk5VWSyWR4coq5wyQHNkm3rHKEV1QDeeDk8kIgYStNTEB
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
allocations.  Use test_and_clear_bit to atomically consume the kick
request before reading the dirty counter and starting writeback, so that
concurrent DONTCACHE writes during writeback can re-set the bit and
schedule a follow-up flusher run.

Read the dirty counter with wb_stat_sum() (aggregating per-CPU batches)
rather than wb_stat() (which reads only the global counter) to ensure
small writes below the percpu batch threshold are visible to the flusher.

In filemap_dontcache_kick_writeback(), set the WB_start_dontcache bit
inside the unlocked_inode_to_wb_begin/end section for correct cgroup
writeback domain targeting, but defer the wb_wakeup() call until after
the section ends, since wb_wakeup() uses spin_unlock_irq() which would
unconditionally re-enable interrupts while the i_pages xa_lock may still
be held under irqsave during a cgroup writeback switch.

Also add WB_REASON_DONTCACHE as a new writeback reason for tracing
visibility.

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
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fs-writeback.c                | 59 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  2 ++
 include/linux/fs.h               |  6 ++--
 include/trace/events/writeback.h |  3 +-
 4 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a65694cbfe68..faf15cf84c68 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2373,6 +2373,27 @@ static long wb_check_start_all(struct bdi_writeback *wb)
 	return nr_pages;
 }
 
+static long wb_check_start_dontcache(struct bdi_writeback *wb)
+{
+	long nr_pages;
+
+	if (!test_and_clear_bit(WB_start_dontcache, &wb->state))
+		return 0;
+
+	nr_pages = wb_stat_sum(wb, WB_DONTCACHE_DIRTY);
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
+	return nr_pages;
+}
 
 /*
  * Retrieve work items and do the writeback they describe
@@ -2394,6 +2415,11 @@ static long wb_do_writeback(struct bdi_writeback *wb)
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
@@ -2468,6 +2494,39 @@ void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
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
+	bool need_wakeup = false;
+
+	wb = unlocked_inode_to_wb_begin(inode, &cookie);
+	if (wb_has_dirty_io(wb) &&
+	    !test_bit(WB_start_dontcache, &wb->state) &&
+	    !test_and_set_bit(WB_start_dontcache, &wb->state))
+		need_wakeup = true;
+	unlocked_inode_to_wb_end(inode, &cookie);
+
+	if (need_wakeup)
+		wb_wakeup(wb);
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


