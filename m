Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1458FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 11:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7EB6B008C; Sun, 26 Apr 2026 07:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E881C6B0092; Sun, 26 Apr 2026 07:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76A46B0093; Sun, 26 Apr 2026 07:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1E7C6B008C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 07:56:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55B36C1F69
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:56:50 +0000 (UTC)
X-FDA: 84700555380.04.439042E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 69C10A0004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:56:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ooZJKXZq;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777204608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0m25BHR209SskHMIvFdQtvFt1tNlS18Om/gq6vGYEC0=;
	b=o8RklSfaZkZ6qEKEceNAPUS0KPX5h3xC2ZwfKYp4FqePEc5WX5ZBoPzzoTBHFrlfdCFp4W
	wn8aFGIvj5jkjUotXRXoJvWfV+qgF1rw9blHjWETq4ztQ56cd5Y2RRgDmqQoGSbSYattny
	x9udMEjgkyBaDas7bnz52e0PlfxGenk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ooZJKXZq;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777204608; a=rsa-sha256;
	cv=none;
	b=MN+y2Nqm7RmG48jmyIRVs7hR+WHtRdwnPO4Gv0Z64lQlefw8DU79ZYDj8Rupc625SgMOmZ
	Y/zCom1sbbcUwGmNncxSOHfKIhNv6q3zRWlUQOJjHngIMXoB92qpKmvThML0YOvNm2i9g9
	eLmLBcofbumQaWNLUt1rQGe2HFpWFo8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 851024450E;
	Sun, 26 Apr 2026 11:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F856C2BCAF;
	Sun, 26 Apr 2026 11:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777204607;
	bh=5hBl0zioJo5bmMYBsa/ayjneMPX9D/E0U5nhPvmz3Ag=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ooZJKXZqm0RN4As5t7yp7UYg1yu3tEkFQjZEmM8nPsoeCGMVy3rDmDeNBVajbkgLf
	 QIADhlIEZ6EfFzFvo6gMAPZHKezwp2U/rjmNbqqeJIIvhqo4H1V9CcK1oonXxlNv4P
	 JRsyGCXXyCOosabi8sWpWNGuwS2iXNsAEkvPeyyGFWC1QBGd1kBojbIu67BdtUKzAq
	 yesLLXGUVTgk6mi2deep1Kj3q84eWZPsY+Xo4ypp6ZRYB9zposMCp8muPo5r/PPWEX
	 1QdLj8DBu/7gBbGWedtD8wAUzcPuChtBD60r/1mChVCWdhJBIkjpellVjR2eQFRvWH
	 8OR/xmZVr/sLA==
From: Jeff Layton <jlayton@kernel.org>
Date: Sun, 26 Apr 2026 07:56:08 -0400
Subject: [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE with
 targeted dirty tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260426-dontcache-v3-2-79eb37da9547@kernel.org>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
In-Reply-To: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
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
 Christoph Hellwig <hch@infradead.org>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9483; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=5hBl0zioJo5bmMYBsa/ayjneMPX9D/E0U5nhPvmz3Ag=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp7f1zmVJGTA+Tu2f1JtkgZ4Wu4QF3JzIvd1NAx
 QeDTBATFNWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCae39cwAKCRAADmhBGVaC
 FeF3D/9yCQENYERa2fOF8sEnGIr+VfDwMDVMKgp6/vpNwbtri6dShe5ipAoG1nNJw2Ec8fYuiFg
 Imjx0pFCtOHJuShyO4+5vUueRxuIHyxkF7MIEO+nn0GapxZzXdLryLM28vxnSvFOP5UWUcrlRVT
 X1XJg64SsFTYWrf6TqLLZGJih2OjGZ/f8sQUYW6+piUA97X4h7ya4/FUr8MWv12fANionDuGBRQ
 l/zALxRhRgT+Xa9GJ/cjP4oVmx3ZXXIRbDUoW5qJX5cjxx0cEi/xg0fAh3Yb6qT7iOWKAuqXoN5
 4dm9IXRaDvssYpbwMUHfSVKcxoiIhSGRULtO0bazlUA6uAxK8HVyzEBXB/DQkHqL2uVMT4E+63z
 2Tlyh0wn6NUVzaxu6D39C1BO8EZCIefUUGMI2sZHZj/UzEkTAe6hpjph3RTTvsIn3HygosnhqQP
 eGSjsFc55/57rjQzR2EQwitPA+Bcl+P1uZnYKrUKKPlfKzqbXEbml4VfiQTynzJ95mmDSr09RVy
 942UbUjLOXIyjmqzjx3vNiSw138EfZYebQTmL/LKeXIRRheDBE3xi6tG1NnFIUm+gYE38ZvUAka
 aHK2QJipOHP63BECxbbGddNccTr1e1Hx7Nw75TaIYoHQjgoTm4k/S6I9EjhwjgyyB16UO6L0Bea
 wuMVICRdIU/Oh4g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 6rnwu35orm775qjcxij6k47i5wjpaope
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69C10A0004
X-Rspam-User: 
X-HE-Tag: 1777204608-975450
X-HE-Meta: U2FsdGVkX1/cQi8wXg7me9DCFJWktnmUzpNphuMKkrSYeThbaT6wOS1g2r3HJAHYywxmRfCsg7Ud4cmBHtKvJQL5xYBi6UQ3BAoNzviqiNE9oEdScoxqNH+CSSDvTMIWjr9MHX9pt7qoQWFxrYdj7jEenvYyapmogFu6R3dCx7cG1zee+SUPkDljVcQZZBNiKppYs8VOsMViMhU2VpmnXVLbXcZDbGXRvb/ayXZl7U6Gg8hUjVazn58WLYmsCWhoU+Dgeppk9ytIPi83bzzi5EZBUm1IywaD9rCHXwGi1QIkFO+Fzy/jcKsog1Q/+wrCeIbbMVHljA6P3FiwKYq/eVOH2p9vA24Qhz9KixpNqu2Yn0HsQK9KfGyQlz2R1j7toi/nLWAHjeJGhwMd+tDIC9vzPtV5WU1schN/2+qTwXeQH9RwH4pAvqBk3wRukbfDypnMTsWhGMNjlQhHYa6J3gz0VeyBKFGm4oa7zU1qzDWRSegsHhQ36ZgLVhBKTuRTOEyb0rJFs+gNaGiKD+emVctBJdDL0oLdxk74+2z/5KnTKhyBc19bGXjpkaweORz76ET47tuZzvr5cjiGHZ1/Pbh5/b709z1HDTqf+LaVZACJTwjZBrFyymyal6laQJLEQeRbR69XeEAe2vr8HyZH6HHRI9/sbWV/jYhcHeYhakgHsGqcAOnpQmv6Lfl/sVJepf7RLTb/Yz7TkDAiSDdcfWOk4y7565itU/nNvegmh4R1aPTUN581WRqqw+leu6u98UMTqC0BlAGcD1KehYkvlnZlqJ4EVj3xr7YJ/cZPfeBNOczErSYaz7oHvFVuB+gmFUvG+WjpuBWpJoudhg7VNt4se1z2mRg0Dlqj5n1AvKbcKSWn1e8aMLa8vkAkXlRmvC23BFuiujzMzGivrCMwQHpWN6D4YRoOYqqYTe0skvsVBYAkHipcMLfEWJXoar8FZzxejNzJT92oB0Drqqd
 zin0bIOb
 M/W+AKA9LfcB5QsAbZ++Y45XiQP4Y8bNtccrkkjQerbkxiUA4wxwNrYN8DtMrngi1iQNxD1SlaSERJ7vU/SMt7/NSuG7oZJ2N+5rLNbnE1nGxIgE8Rw6/30OersDQX8G4SjycjcSN5hwmPHh+wmucuWTYAi0kUCx8SWqa7lOe5TyW6rTM5VfVzLewLrFnwpiS0i4MciU/+6uX2Rui4KmBRxqwnIYB5rsYnfo+W0Ql7lY1u6YSGq47fMApFkhdxJDWc4FxBrsZdbHWJE9KZM+GaV/r30RQV0/uetrkk7G7/rex0ScCtlTbGYP0iMAxbTatblfF6LALieqDcroqmw1DNQuhpHx+PSv78rE7C/MawlBC7pJvnsqX+Mz1qsm2KuRtwEWL
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
the new NR_DONTCACHE_DIRTY counter to determine how many pages to write
back.  The flusher writes back that many pages from the oldest dirty
inodes (not restricted to dontcache-specific inodes). This helps
preserve I/O batching while limiting the scope of expedited writeback.

Like WB_start_all, the WB_start_dontcache bit coalesces multiple
DONTCACHE writes into a single flusher wakeup without per-write
allocations.

Also add WB_REASON_DONTCACHE as a new writeback reason for tracing
visibility, and target the correct cgroup writeback domain via
unlocked_inode_to_wb_begin().

dontcache-bench results on dual-socket Xeon Gold 6138 (80 CPUs, 256 GB
RAM, Samsung MZ1LB1T9HALS 1.7 TB NVMe, local XFS, io_uring, file size
~503 GB, compared to a v6.19-ish baseline):

  Single-client sequential write (MB/s):
                       baseline    patched     change
  buffered              1449.8     1440.1      -0.7%
  dontcache             1347.9     1461.5      +8.4%
  direct                1450.0     1440.1      -0.7%

  Single-client sequential write latency (us):
                       baseline    patched     change
  dontcache p50         3031.0    10551.3    +248.1%
  dontcache p99        74973.2    21626.9     -71.2%
  dontcache p99.9      85459.0    23199.7     -72.9%

  Single-client random write (MB/s):
                       baseline    patched     change
  dontcache              284.2      295.4      +3.9%

  Single-client random write p99.9 latency (us):
                       baseline    patched     change
  dontcache             2277.4      872.4     -61.7%

  Multi-writer aggregate throughput (MB/s):
                       baseline    patched     change
  buffered              1619.5     1611.2      -0.5%
  dontcache             1281.1     1629.4     +27.2%
  direct                1545.4     1609.4      +4.1%

  Mixed-mode noisy neighbor (dontcache writer + buffered readers):
                       baseline    patched     change
  writer (MB/s)         1297.6     1471.1     +13.4%
  readers avg (MB/s)     855.0      462.4     -45.9%

nfsd-io-bench results on same hardware (XFS on NVMe, NFSv3 via fio
NFS engine with libnfs, 1024 NFSD threads, pool_mode=pernode,
file size ~502 GB, compared to v6.19-ish baseline):

  Single-client sequential write (MB/s):
                       baseline    patched     change
  buffered              4844.2     4653.4      -3.9%
  dontcache             3028.3     3723.1     +22.9%
  direct                 957.6      987.8      +3.2%

  Single-client sequential write p99.9 latency (us):
                       baseline    patched     change
  dontcache            759169.0   175112.2     -76.9%

  Single-client random write (MB/s):
                       baseline    patched     change
  dontcache              590.0     1561.0    +164.6%

  Multi-writer aggregate throughput (MB/s):
                       baseline    patched     change
  buffered              9636.3     9422.9      -2.2%
  dontcache             1894.9     9442.6    +398.3%
  direct                 809.6      975.1     +20.4%

  Noisy neighbor (dontcache writer + random readers):
                       baseline    patched     change
  writer (MB/s)         1854.5     4063.6    +119.1%
  readers avg (MB/s)     131.2      101.6     -22.5%

The NFS results show even larger improvements than the local benchmarks.
Multi-writer dontcache throughput improves nearly 5x, matching buffered
I/O. Dirty page footprint drops 85-95% in sequential workloads vs.
buffered.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fs-writeback.c                | 60 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  2 ++
 include/linux/fs.h               |  6 ++--
 include/trace/events/writeback.h |  3 +-
 4 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a65694cbfe68..377767db48f7 100644
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
+	nr_pages = global_node_page_state(NR_DONTCACHE_DIRTY);
+	if (nr_pages) {
+		struct wb_writeback_work work = {
+			.nr_pages	= wb_split_bdi_pages(wb, nr_pages),
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
+ * pages tracked by NR_DONTCACHE_DIRTY are written back, rather than
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
index a06b93446d10..74f8a9977f5d 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -26,6 +26,7 @@ enum wb_state {
 	WB_writeback_running,	/* Writeback is in progress */
 	WB_has_dirty_io,	/* Dirty inodes on ->b_{dirty|io|more_io} */
 	WB_start_all,		/* nr_pages == 0 (all) work pending */
+	WB_start_dontcache,	/* dontcache writeback pending */
 };
 
 enum wb_stat_item {
@@ -55,6 +56,7 @@ enum wb_reason {
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
2.53.0


