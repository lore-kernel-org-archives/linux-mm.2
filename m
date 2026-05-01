Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A81CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F159A6B00A1; Fri,  1 May 2026 05:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDF96B00A3; Fri,  1 May 2026 05:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03936B00A4; Fri,  1 May 2026 05:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDC406B00A1
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:50:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C35C1C021D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:50:27 +0000 (UTC)
X-FDA: 84718380894.18.832DA09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8EC5618000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:50:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+nS8Pjb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777629025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yo99vZfmC2Udmh/GuBpNEn1IT5p4HJ9vl/xRfCDpJ0Q=;
	b=P9xXCGv2otnZqvDoApJIrvRDh8JFRtpU4Zv0efQDg60XxM6Mf333il56sc3sswsZHqb9Vx
	Tx+YALANueDkrG2bu/+yR8Aic4SrIsrSB0siKZA7kVDmzr42D+wNOTYArdDsdbc1ht+VF3
	i0wbO3bVZm138tKt7At26C03A2RW85k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777629025; a=rsa-sha256;
	cv=none;
	b=pmR/5qlulUMvOeQLhK9yK/fFHQgcxWNWPFbk0uMOlIM/IYQAnY3S+35tlz21MEYrsatoyW
	Xe/pDecyHmx4qp9DaeVheMcFjCKWzuTbPZ7UJO/rX5n1s2Krms59GwiW2PadHv8GL9mNYI
	y2a/pgGnbiT1PKljg9nopHcgeo+vvXE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+nS8Pjb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BADB444504;
	Fri,  1 May 2026 09:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FFFC2BCB4;
	Fri,  1 May 2026 09:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777629024;
	bh=yQTt3liEqaBCXR2rlPWa8sEqJC3iU4De0vNfeKvDjTo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=G+nS8Pjbnmo9t/IZ57mzwBlpCRQmSurm/m1WdYyt4lnMR1H1j+7xVvyCTXLeeLbuZ
	 cLRKLgklu+q86CKFnx3bd4R5BFOWCXb0JIOI6MAKLU1CW+//W8nAUSZT9VJy8lb6zQ
	 ShcnX/VMJ0dzb1Cx5NHJ4LgRUIYeYT0r/amFEA17PzUtVhBaOTXKzIhBFeBUlvb9oY
	 RF9n+TJ687D/9O7xYFGvTtcccjbeljDpZbT8XA0MW8W0N5vQ5F44W8UugIXIZbM6iR
	 4HqcP2jqt06D+oJ22nJNuHbbkcPqASO7nZtZ6TJQOb6D/l2aBUtHdtxmonuqfD+kqe
	 EwnQOWE5UDTxw==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 01 May 2026 10:49:36 +0100
Subject: [PATCH v4 2/4] mm: kick writeback flusher for IOCB_DONTCACHE with
 targeted dirty tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260501-dontcache-v4-2-5d5e6dc71cb3@kernel.org>
References: <20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org>
In-Reply-To: <20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8810; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=yQTt3liEqaBCXR2rlPWa8sEqJC3iU4De0vNfeKvDjTo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp9HdQEPnjarLJF089nZsNrHY1wCEnRipW9HnmX
 Ak9A1pY4MyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCafR3UAAKCRAADmhBGVaC
 FX3TD/9FjtZLOba+69gJe2qy6mDT7cmra2LtxLO/aVBzPzXDnPDrSmcdfM9UEygP/7hJX8zOsKH
 LzpeSPO1qYPIrhzqKiCv5pEtFoiPjHQFiJkl5Q4nkV5W1VFQ+ixBabI0TilzTu7Rkh0YqlObh8Q
 NUybJwTdLdmGzoiaZjucNOT0G92X6i+08nnVAAndvKOSNzsEIimkSOO5TnZBhoQl0SN4SSxCXiG
 pLtGCL6+s69HOVeJs/RKgiB6oaGuIzJXgsWFCU6wlD1/l1vXI+X5RlC8KYnH/ZeW5FK3Bb/Tczi
 KtLMSdDcJtB+SeNaiOmNQIU+T8+wLOG7YO1XSKi2itGHz2aLH9bsU8qFZz6DKTg7bwRI9TAc197
 TNkU1dBpvTKgLw4RqjWlbAsI0awNASKAXoV8D5Ik7iDlWZR8Grn6o8ApebcrnkU867kqV/GUtlN
 B4IEZEqkcQXwkvUHQtMNaoRByWkl1nOFjfOrncCJhwxyKkIj1zCd+P7WI6tehiJocXZyJBchJ+L
 LQQlTPWUH4Dz6ASuI08fX9p3hupvNnwtaMhD4UEIwvOoMtQWIzyaA2zcTY2blc0j/xoWxFG04rM
 W8xJqJD59HoP3WZ9AwC+iHWNHKBASOEizv0rBSozfXzfWnjnuNZxhQrn69YJ4FX5/x5qYwmoYdk
 ACBMGMVwOGQLDuA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8EC5618000B
X-Stat-Signature: i4r4mwhgogto568qoxf55ska785gm8w8
X-Rspam-User: 
X-HE-Tag: 1777629025-6212
X-HE-Meta: U2FsdGVkX19/luXOOmzEg90S/3yJ/Zi/OMhxWX73xFk21YFIYQGHrBfPVXc0YjJIYFsxO0wU7KO2DCDec/yEvFn0ETse1qSq6br8iGSRLEa+Sq9kn9tAEulb68G4MNQFCEqVjkP93XkUf7VgILR/TGdLGpLplc1AQCcqyOa6YPLDjjWsiIzX7LPepep4MoAgxqMYMSb6cnQ8uePzWkNTVkTf1IYRNd9HZz6V1qgWsShaXVKepr85bwv+6e+IKDXEbqOz2JneKOcEE9Ujynm1SPKc/kh+2+6mlH+TDzKZ4k3cVZmFLiMtwogiJMcg8iPBkiGAGDhgZct+egrBAIjnfUZzpiN8X5M/mp1pfPCY1ViZWRBXZ2VF9AvjWRF9Xs/VIgszIVdLOCmIKnGnj2lIxBooTfOPSzxiE1XYUYgssTo5jlS5OtDdouuJQ1QhMMuUadfKWQdk8/9r9hQBJw0SK9DKoxKJ9JNu/tyAXHg/dwPfaZjQ3uKbaMwinA8wgLZw0XFOzN2R8g+QQdKeKlHPAs1vMJ38NfK7sbtydM8USpESd6qFn/CEkMo0HXdOJBom83YwfjGXU4AndjaAy9Ra/3IGA5SfkiUZByrKFxxZBj3yNP1+0Oho5Yxu0ZqyS3Z+xA2OSBCz9TaOC3nS/QZvo8rc5vtgd8+axdFGHH23ZhH8gN2rjx6Q/5dh3dBksYTjsT3f9UsdJHP5Qnyh5r5GLAHzpTUgN9lsyYwcjmkh8yaghfgjy1rRbrfAItpF7VQKNB8tFtTLXVSB7FeLTG3r0nmD6NHIL/s7SjWEEyQ9JC9KnugI5HituyUd/8VUB0rcBKq8/eyzoWSTWCLtSeUP9p0nXfCRu3xQJGXcLvrVZGEFkyRVvlbztlpul6Ne9xfuFAB+bxDWAoZoRNCtS7MIuapTl40+eslEwnDbc1XtTT9vDlspSsEg6olw2VvYZR4oDkY46Gxn13S6SGbfU7N
 coHDANFb
 Yz0PICWEXkeIjrJQAEgsUgq/eroK4hyE8OU2urw4I8Gi3YyfxnVP3nTZYjvlVOwd/PJt/PLksJBFSAm6tMX0d1BzOnbP+ybzaAMT1vX5Lr0o5/GUCIVChlSgrGmXD/e3OSv61qsykhHFWIV4IVC4vTSyj1o224syiFGv0xXmkjL3DLwYiPCgv5GsZJDQZUUVFuo77LtW1Hr4H7l91En0TxtEnDb01nX+TUltWq4JH9wCURirpiMqlTWsBc/VkUjPVmO8SoXqmI2Ay6ZtxW7fISsUTTz6XelrwVU1p5liUPPjjQUI0xB+APsn+R3dSTE160fhnXT2iCiw8eQBX4Xy9gitbmYwnSW/3tQlWbZY5Bc9q9Jl1i3Fwbwp5mz/ydjVK9prE
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
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fs-writeback.c                | 60 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  2 ++
 include/linux/fs.h               |  6 ++--
 include/trace/events/writeback.h |  3 +-
 4 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a65694cbfe68..b06a51fb5d6c 100644
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
@@ -2468,6 +2507,27 @@ void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
 	rcu_read_unlock();
 }
 
+/**
+ * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE writes
+ * @mapping:	address_space that was just written to
+ *
+ * Kick the writeback flusher thread to expedite writeback of dontcache
+ * dirty pages.  Uses a dedicated WB_start_dontcache bit so that only
+ * pages tracked by WB_DONTCACHE_DIRTY are written back, rather than
+ * flushing the entire BDI's dirty pages.
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


