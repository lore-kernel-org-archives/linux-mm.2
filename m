Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB3A606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CXkASDrJ
Received: by kanga.kvack.org (Postfix)
	id 80DDB6B00EF; Wed,  4 Nov 2026 08:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF016B05B1; Wed,  4 Nov 2026 08:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EF06B05B2; Wed,  4 Nov 2026 08:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1FD6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:01:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 820A51206C7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:01:34 +0000 (UTC)
X-FDA: 85397448108.21.9B7E635
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8922D20013
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:01:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXkASDrJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1naArokeT8hAvd4c/3wQ91hHpuDBfEkOptaMudK1XoM=;
	b=rTe9yUtM//FaStg/ZSqF80DXmXadjmvV3t4bjq8c/DLspmWTdEs9wAWVaWDBHMNY/bTOtW
	r9VfrnmTTFGYpojOKzBE6z3Y2BXReGNyKgziuomo3FPOriY2f7RrdOZh2Q7PKakRVakOkA
	QVXkxUM00JDPnqpxJQM7DBPP3ui7zVQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXkASDrJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797292;
	b=Tj6PaXVBEV6zFdx00trdpgyFTQbvCuc2gr3WW0Sn5JqWeku4PgOtJ6I/7D2ReyMYzTl7Qi
	XtVUfcZ/HLisckXOWhcXgNzM7BKKwpiifiXghPo+uDXz7mwtzke9q148a2DShf9lBgecEF
	YZaPvz46HeE66Mq338A69qV2yOASU7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B56160DEE;
	Wed,  4 Nov 2026 13:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28BF1F000C1;
	Wed,  4 Nov 2026 13:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797291;
	bh=1naArokeT8hAvd4c/3wQ91hHpuDBfEkOptaMudK1XoM=;
	h=From:To:Cc:Subject:Date;
	b=CXkASDrJkGF9vM8wGrqhmp7mof5LziByY2aC99HsnT71SzFFnqE07K2gvIOmMhFZd
	 Xh7UMARge4wa8derZbyetN8Rer8GvM4gFytJ/IHWGdjZ49TpDXJCagYj8TpDIZuzvt
	 ipA/kmS1/uGGGCyqUjwOc5b3fkeiPkHdD+rZ4u7REZmkIj7LlbrLR1+mKSgVzBmO6O
	 CJ6KLm81l2L8DlZ8SqquTAqYZ6nlu2afBrmkw+ufITKtpShFwjwgRQZp1Sq7zRqFtM
	 Uwfv8nQNJFnmrdih8FH9rmkq3fkvKfqI3gZdKGuy+7Tq6ucOvBPRnkCMfAl1FNo1cO
	 iziU54yQRS06Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 086591980052;
	Wed,  4 Nov 2026 08:01:21 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 04 Nov 2026 08:01:26 -0500
X-ME-Sender: <xms:oSzraqSe3qY40In5vCSZfsjoVI6LIk2xl6KlPlozXwHIiJ6OQQsVkw>
    <xme:oSzralD3XT1R8Wyh7ZRIlZAHXDDVGowimAlpf_NrPOZfemmaNXuq710xTKsWFJZ-1
    jJMLGUjg6Djt78b8aD6jCB6eIaYPhyZd_9kMC468JW9tKzcYzue8oQ>
X-ME-Received: <xmr:oSzraqd8QA9gpwR0g_DoQp9FMA4LGqRXXDgUg392M_rSzvCISnYfT292I7w>
X-ME-Proxy-Cause: dmFkZTFjS7WhmVkAbJV7U5Sl1vJol0pbiewT5vYEl/HxWgtVMy3+E/UcI/uTbjSY2RDK1k
    N7nFQ45UJoKvDAiJviFTKxeP70x9uG0RhGhPUykjQbACjs8xcs1ni8tPzvekASzTC2wz+J
    mhTdSPGETc0U6RPkz8OQUo5Hk9s6MrzL6ru6da94Ovr1SpyiId6m8cyQEyvaecQ/e4TQul
    MTHMGhDQIQhDaazmDaL9Jb0Lh00f7hm/9xV48NQxnGBYTtlHnrfEeR85K7RFVDGr6rkeQ9
    pD8f/z80nCaIoy7E1IpQblv51JUpy7TMr3utHDnplxCt/vhZyhtHrspnbCeFjy3rmbepWp
    7iXGioFX9cPGAt3BPtkRUc4EbC8VXE07i3OMBZieBCl0oRYIBILDRCVx1GylvSlYOxV+k3
    xxj/YLr7oZv7vI5RWYdKM1wrBl/ISVjXbjlhNHyxsMgyZyg6dbIvG9ri/aJwtdIcoPCEDr
    x1c/CSAky2kq/xzI9fOcH+z+CCxv1bfF8ju/WyYTWXQWBaSbW9SHlFIBJn5J7lyxiXxSBU
    qr/Z3HibtZuxNOkWmC7pBMCRMVxXuyeNF7PoQ/RxX2FVjNrTxzgPaUjAIgyxWMgda8YNhG
    mAy/Yos9FzZKIRgeZg18CQpKcHcfvWMD0c/SFK9CG5+d1byZeN8JGhJrGLeg
X-ME-Proxy: <xmx:oSzrals5LuzlhYWjylvyCvBxVFZc2iIhMNgLP9yhE9JT97LSmAQSmw>
    <xmx:oSzrakK8MpZ9dmTvKS-biPpeD2rQTyUPBLgZbfnl9zFlORIKLpjOgA>
    <xmx:oSzrap-G7pYuF2UgdBRFYB1QApBObfGESU93udGJSt0roOxE9V1wOw>
    <xmx:oSzraqBlltSUlbFFvPaBz49RHHMWmC1ixLJ3QagkFPbEyQFEB0pfBw>
    <xmx:oSzrartKstX7KQRwEEfgNBPcu3Z3XhuaJmRLx6zdIPJJ75ZGUo1uDCXD>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:01:20 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH v2 00/18] mm: read the page cache without folio references
Date: Wed,  4 Nov 2026 13:00:56 +0000
Message-ID: <20261104130118.2507513-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8922D20013
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qzsbdjyzhx6soubzmrt19py8jzne95ci
X-HE-Tag: 1793797292-488237
X-HE-Meta: U2FsdGVkX1+O5vQPcpdYpTedpaoJaQNHNXIP4+7pmgn7rpOSG+uGNiTk062Hla/YI4okd5Ce1oVYqXEuj07/b79GmF24FWl4pDZ2M60xKAox2OZbMAFDucPQSYb+oeyUyjkymADUsPun0FuOizs9Rj0vNdGemUm9WA0GwRol9IJMc60i1mRdEeWJz0bJZgzXgIuOuR+P0sy/sTDEzopv2c8KQjpwo5SxC1U3Et5dvTT0JqaaHbzYnj0Mlx9qSD3wFmMl6hIdF4eyP/Gj7np+NvzEtphnAQCqfV5KObhOEFnTeIFqlOkp0LOj7z/ckuJ7AmYzx+AN4GaHaSPbTNiZj9/mudeIb223NkCMo+Qp2r7ipQOiAEbVlI26x/aR1W07ADNs+dTot5jGgxD3V20nicuXVAUC9nu7t/GG4CVRtq6IaSBCZuuoP3GCId/32MbrV5mYiP5aA6L8/vqaS/VdXIbs3fWtPW2l71hazcZd6EwQx+g8FXr21LFCvORKkI1Ob6tY347NAkA4eEK6W/0YI6fGegHcfXU7nEqF8D2BqZH9/hCb3I7AGH4+4yUIi8pU2iVgeaZajSr/mR9LqkBwU1V3aHleULF8dIyfP2Q3gZrTJR40Uc26JVb43ywmQ3rGAgTVEPSF541ig1B8TVtHkKr9zeHHmd1/GD0eMs+4WB5zOni9nx3FmdDX1SXtgRW6wZHQAHyOYmzAU+e8amTP82O7dNEEWTJmPge/OfM9stdMcTy7DfcUTUhfKmwmvfs+RzqNty2yVJNT7HLOZbZbNoG79nvQb5MWJ6diWH1n2zYW7ShcJ728koA0qX8jfXT90s/rZrhzL8+xBnqWMJ0r9Pebqqhh0Mgog/4QAG81cxeabMS2XuIfKAs3kEhk4W87EdVPcFMOTjN1welfIL06cC2Y+ocgCVmhw4z6QH0TYrqA1EoLkzDfUY+KNV65DXARaamv8S/kGmSBIHgCTWa
 pTSNI3Qz
 GoUNh1NsoFqY6Rpfb+ev7Ig1YlERwW5yYuyp5QjAtAfcPRqDrrAmwgXM+57U7e91SABqFkLzFZJPYT9EgQBk4M2kmWiWLDapJqwojLUQ1sFys20MXTk4/eMB/nwLGsktHfqnz9qWYsHjJYN+Hl4S8C6BuUyhUWgAzKtHf6dJmwBoKe4XDy6YxBqE5HXemkvbzp3F8FEGJCPupxvZGV0sDJ/ON9WqCCoHSQsDdyo1ehb5nRqjy01nCHPywQAeXPDFCWCfMtoHe8hOyftMnXS/EyUyj3iYILI7Yiiu3czj0HOZBtJPE6MwcUJxUh1UfeXX7JRL89ZeveU0y0lC3a5Su61BWhTgY6QvUaOBEYCqUi0g/WuGqXTvdFR2JyJotuu9bdHS3Xtkyz13nOgD7xavJRsmDDKaJfBniqOxy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Small reads of one file from many CPUs all take and drop a reference on
the same folio, and its refcount bounces between the CPUs.  This series
lets filemap_read() and shmem copy from the page cache without taking a
reference.  It is Linus' RFC [1], reworked: a folio that such a reader
may copy from is freed only after an RCU grace period.

Only the folios that reads keep coming back to get the flag,
PG_rcu_free: those that folio_mark_accessed() finds as accessed as the
LRU records.  Streaming reads and data that never gets hot are not
deferred, so the memory held back stays small and most frees are not
touched.

Who gains: programs that read the same few pages with read() from many
threads and keep no cache of their own.  Most programs that care about
read performance cache hot data themselves and never get here; of the
real workloads I tried, a kernel build, pgbench and SQLite do not
change.  A read still pays for the system call, so this does not replace
a userspace cache.  It does keep the page cache from collapsing under
many readers, which may let some programs keep a smaller cache of their
own, or none.

  1      PG_rcu_free and the deferred free (64-bit, not PREEMPT_RT)
  2-3    splice and fuse no longer reuse page cache folios that a
         lockless reader may still copy from
  4-8    NR_FREE_RCU_PAGES; an expedited grace period when a CPU's
         deferred frees pile up and memory runs short; the waiting
         pages are freed before the allocator, alloc_contig_range() or
         memory offline give up, and when compaction empties a block
  9      memory_failure() and soft offline deal with such pages
  10-12  filemap_read() marks a folio accessed in one place and sets
         PG_rcu_free on the folios that reads keep coming back to
  13     filemap_read() copies small folios without a reference
  14     ... and large folios, with one more lookup per folio
  15     no f_ra.prev_pos store for FMODE_RANDOM files after such a read
  16-17  shmem does the same
  18     a debugfs switch to turn the reads off

Numbers: 64-vCPU KVM guest on a Threadripper PRO 7975WX (Zen 4), no
debug options, base v7.3, both kernels in the same session, 3 rounds.
With the default mitigations every read here pays ~400 ns at the
user/kernel boundary (TSA, SRSO), which holds one thread to ~1.8M
reads/s; Linus' numbers with mitigations off are in [1].

  16-byte pread() at offset 0, each thread with its own fd, M reads/s:
                                 base           this series
    ext4, 64 threads             17.1-18.1      68.7-71.0
    tmpfs, 64 threads            1.5-1.9        68.3-70.5
    block dev, 64 threads        14.7-14.9      28.3-28.9
    1 thread, any of them        1.6-1.8        1.7-1.9

  Base tmpfs takes the folio lock on every read: 64 threads read as
  fast as one.  The block device takes i_rwsem shared on every read
  (inode_lock_shared() in blkdev_read_iter()), and its count bounces in
  place of the refcount.

  RocksDB readrandom on a hot range (db_bench, 100 keys, 4K blocks, no
  block cache; the threads share one fd per table file, opened with
  POSIX_FADV_RANDOM), 64 threads, M ops/s:
                                 base           this series
    ext4                         10.6-10.9      14.2-14.7
    XFS                          8.9            12.2-12.4

  At 16 threads ext4 is within 5% of base, XFS at 0.89 of it by median,
  with the series spread over 5.7-6.5 against 6.2-6.4.  16-byte reads
  through one shared fd at 64 threads: 1.20x base at one offset, 0.97x
  on random pages, where the struct file's cache line takes over from
  the folio refcount.

  With a block cache RocksDB reads the page cache no more: its
  HyperClockCache does 26.5M ops/s at 64 threads on either kernel, 1.8x
  the series without a cache.  Its LRUCache does 3.5M on this hot range,
  below base without a cache.

  Under memory pressure no load got an OOM kill.  pgbench in an 8G
  guest runs at 0.92-0.97 of base.  A stress load that keeps rereading
  and dropping 1G of hot data next to a memory hog runs at 0.88; it is
  there to push flagged folios through the deferred free.

Open:

- Patch 17 drops the folio lock from tmpfs reads.  shmem_get_folio()
  held it only for the lookup, so a read was never atomic against a
  write or a hole punch; now a read also does not wait for one that
  holds the lock, as filemap_read() does not.  Fallocated folios stay
  hidden: they are not uptodate, and only uptodate folios get the flag.
  A race test of reads against fallocate, its undo, hole punch, swap,
  collapse and migration found no bad data.  I would still like Hugh to
  double check.
- Patch 16 makes tmpfs reads store f_ra.prev_pos, as filemap_read()
  does.  tmpfs ignores POSIX_FADV_RANDOM, so threads that read through
  one tmpfs fd cannot skip that store.  Not measured.
- A deferred folio is uncharged from its memcg before it waits, as every
  page cache folio is.  For a grace period it counts towards no cgroup.
- defrag_mode: a stress test that leaves free pages in a fixed pattern
  makes compaction fail and the allocator stall in direct reclaim, on
  base too.  That is a compaction bug; [3] fixes it.  On that layout the
  series stalls badly more often, 5 runs in 10 against 1, and I do not
  know why yet; the series with [3] is not measured.  Patch 8 cuts
  compaction's scanning there, but not the stalls.
- The flag is a page flag, 64-bit only.  On large configs it costs MGLRU
  one refs bit.
- On writably mapped files, architectures that implement
  flush_dcache_page() take the slow path.
- filemap_mark_hot() still tests uptodate.  Willy pointed out that a
  filesystem clearing it under a reader is a filesystem bug; the test is
  cheap.

Changes since v1 [2]:

- Dropped v1 patch 12, which cleared the flag on the folios of an inode
  being evicted (suggested by Linus).  Sashiko found an ABA: a reader
  holding a stale pointer can see the folio move to another inode, get
  the flag there, lose it when that inode is evicted, and be reused in
  the slot it looked at.  Deleting or evicting a hot file defers its
  frees again.  The f2fs fix it depended on is no longer needed.
- Replaced v1 patch 13, which stored f_ra.prev_pos only when it
  changed: as Linus pointed out, it never stays the same in a real load,
  and the compare cost RocksDB 4-5%.  Patch 15 instead skips the store
  for FMODE_RANDOM files after a read done without folio references.
- New patch 8: compaction frees the migrated folios that wait for a
  grace period before it checks whether it is done; async compaction
  does not.
- PAGE_RCU_FREE is off on PREEMPT_RT, where expedited grace periods are
  normal ones (patch 1).
- Patch 6: the drain before OOM frees to the buddy lists, counts what
  reclaim can still free, checks the watermark at order 0, and waits
  for expedites in flight (Sashiko).
- Patch 9: memory_failure() frees the waiting pages on every retry in
  get_any_page(), and waits for readers on the already-poisoned path
  (Sashiko).
- Patches 13-14: races with a split (Sashiko).  An order-0 folio is
  copied only at its own index; a large folio's order is clamped and
  PG_has_hwpoisoned read without the PG_head assertion.
- Patch 13: the folio batch is declared in the slow-path loop, so stack
  auto-initialisation does not zero it on reads done without references.
- Patch 16: shmem stores f_ra.prev_pos as filemap_read() does.
- v1 carried Assisted-by trailers; they are gone, so every patch shows
  "!" in the range-diff below.

The series is also at:
  https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git rcu-free/rfc-v2

[1] https://lore.kernel.org/all/CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com/
[2] https://lore.kernel.org/all/20261019154913.1765974-1-kas@kernel.org/
[3] https://lore.kernel.org/all/20261104101747.2485913-1-kas@kernel.org/

Kiryl Shutsemau (Meta) (11):
  fuse: don't move a folio with PG_rcu_free into a fuse file
  mm: count the pages waiting for a grace period
  mm: free the pages waiting for a grace period before OOM
  mm: free the pages waiting for a grace period before isolation fails
  mm/compaction: free the migrated folios that wait for a grace period
  mm/memory-failure: handle folios with PG_rcu_free
  mm/filemap: read large folios without folio references
  mm/filemap: don't store f_ra.prev_pos for FMODE_RANDOM files
  mm/shmem: count accesses to a folio the way filemap_read() does
  mm/shmem: read without folio references
  mm/filemap: add a debugfs switch for lockless page cache reads

Linus Torvalds (7):
  mm: free PG_rcu_free folios only after an RCU grace period
  splice: don't steal page cache folios
  mm: expedite the grace period when a CPU has many deferred frees
  mm: have folio_mark_accessed() return whether the folio is hot
  mm/filemap: mark a folio accessed in one place in filemap_read()
  mm/filemap: set PG_rcu_free on the folios that reads keep coming back
    to
  mm/filemap: read from the page cache without folio references

 fs/fuse/dev.c                  |   4 +
 fs/splice.c                    |  51 -----
 include/linux/mmzone.h         |   1 +
 include/linux/page-flags.h     |  21 ++
 include/linux/pagemap.h        |  12 ++
 include/linux/swap.h           |   2 +-
 include/linux/vm_event_item.h  |   2 +
 include/trace/events/mmflags.h |   7 +
 mm/Kconfig                     |  18 ++
 mm/compaction.c                |   8 +
 mm/filemap.c                   | 346 +++++++++++++++++++++++++++++++--
 mm/folio.c                     |  46 +++--
 mm/huge_memory.c               |   1 +
 mm/internal.h                  |   3 +
 mm/memory-failure.c            |  33 ++++
 mm/memory_hotplug.c            |   6 +
 mm/page_alloc.c                | 297 +++++++++++++++++++++++++++-
 mm/page_alloc.h                |   9 +
 mm/shmem.c                     |  20 +-
 mm/show_mem.c                  |   9 +-
 mm/vmstat.c                    |   6 +
 21 files changed, 808 insertions(+), 94 deletions(-)

Range-diff against v1:
 1:  80d1ea6c758a !  1:  4ef64163f1a6 mm: free PG_rcu_free folios only after an RCU grace period
    @@ Commit message
     
         The flag is 64-bit only (CONFIG_PAGE_RCU_FREE): page flags are scarce
         on 32-bit, and the contention this avoids is a problem of large
    -    machines.
    +    machines.  It is off on PREEMPT_RT, where expedited grace periods are
    +    normal ones, so the waiting pages cannot be freed quickly when memory
    +    runs short.
     
         pgfree_rcu in /proc/vmstat counts the deferred pages.  Nothing sets the
         flag yet.
     
    -    Assisted-by: LLM
         Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    -    [kas: rework for flagging at read time, 64-bit only, shorter comments
    -     and changelog]
    +    [kas: rework for flagging at read time, 64-bit only and not PREEMPT_RT,
    +     shorter comments and changelog]
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## include/linux/page-flags.h ##
    @@ mm/Kconfig: config PCP_BATCH_SCALE_MAX
      	  the maximum latency.
      
     +config PAGE_RCU_FREE
    -+	def_bool 64BIT
    ++	def_bool y
    ++	depends on 64BIT
    ++	depends on !PREEMPT_RT
     +	help
     +	  Reads from the page cache can copy from folios that are read
     +	  again and again without taking a reference on them, so small
    @@ mm/Kconfig: config PCP_BATCH_SCALE_MAX
     +	  folios becomes reusable only after an RCU grace period.
     +
     +	  64-bit only: it takes a page flag, and those are scarce on
    -+	  32-bit.
    ++	  32-bit.  Not on PREEMPT_RT, where expedited grace periods are
    ++	  normal ones, so freeing the waiting pages on demand would stall.
     +
      config PHYS_ADDR_T_64BIT
      	def_bool 64BIT
 2:  54ae7580bf73 !  2:  1cfc33d7be6e splice: don't steal page cache folios
    @@ Commit message
         stealing fails.  SPLICE_F_MOVE from the page cache into a fuse file or
         a virtio console now copies.
     
    -    Assisted-by: LLM
         Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
         [kas: rewrote the changelog]
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
 3:  7a4a1df99f88 !  3:  6f1f2faa2ee2 fuse: don't move a folio with PG_rcu_free into a fuse file
    @@ Commit message
     
         Copy such a folio instead, as fuse does whenever it cannot take one.
     
    -    Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## fs/fuse/dev.c ##
 4:  226465c86d51 !  4:  b4b2afbb5dbf mm: count the pages waiting for a grace period
    @@ Commit message
         free_rcu in show_free_areas().  Preparation for freeing the waiting
         pages sooner when they hold back memory that is needed.
     
    -    Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## include/linux/mmzone.h ##
 5:  601a788a3c9d !  5:  1114d57c872f mm: expedite the grace period when a CPU has many deferred frees
    @@ Commit message
         zone still has memory.  When the readers that refill the range then run
         short, nothing is freed that would check again.
     
    -    With rcu_normal, as on PREEMPT_RT, the expedited grace period is a
    -    normal one.
    +    With rcu_normal, the expedited grace period is a normal one.
     
         pgfree_rcu_expedite in /proc/vmstat counts the expedite runs that freed
         something.
     
    -    Assisted-by: LLM
         Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
         [kas: take both lists, expedite only when the memory matters, rewrote
          the changelog]
 6:  d13fd5787f06 !  6:  f9063909ef1e mm: free the pages waiting for a grace period before OOM
    @@ Commit message
         grace period.
     
         Before should_reclaim_retry() gives up, free the waiting pages if they
    -    would bring an eligible zone above its min watermark, and retry.  That
    -    costs an expedited grace period, which is cheap next to the OOM killer.
    -    The retries are bounded per no-progress streak, so a drain that does not
    -    help still ends in an OOM kill.
    +    and what reclaim can still free would bring an eligible zone above its
    +    min watermark, and retry.  The drain frees them straight to the buddy
    +    lists, where the retry's watermark check sees them, and waits for the
    +    expedites already in flight.  That costs an expedited grace period,
    +    which is cheap next to the OOM killer.  The retries are bounded per
    +    no-progress streak, so a drain that does not help still ends in an OOM
    +    kill.
     
         pgfree_rcu_drain in /proc/vmstat counts the drains that freed something.
     
    -    Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## include/linux/vm_event_item.h ##
    @@ include/linux/vm_event_item.h: enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSW
      		PGREUSE,
     
      ## mm/page_alloc.c ##
    +@@ mm/page_alloc.c: static void rcu_free_take(struct rcu_free_pcpu *r, struct list_head *list)
    + 	r->nr_pending = 0;
    + }
    + 
    +-static unsigned long rcu_free_pages(struct list_head *list)
    ++static unsigned long rcu_free_pages(struct list_head *list, bool direct)
    + {
    + 	struct folio_batch fbatch;
    + 	struct folio *folio, *next;
    +@@ mm/page_alloc.c: static unsigned long rcu_free_pages(struct list_head *list)
    + 		nr += folio_nr_pages(folio);
    + 		mod_zone_page_state(folio_zone(folio), NR_FREE_RCU_PAGES,
    + 				    -folio_nr_pages(folio));
    +-		if (!folio_batch_add(&fbatch, folio)) {
    ++		if (direct) {
    ++			__free_pages_ok(&folio->page, folio_order(folio),
    ++					FPI_NONE);
    ++			cond_resched();
    ++		} else if (!folio_batch_add(&fbatch, folio)) {
    + 			free_unref_folios(&fbatch);
    + 			cond_resched_tasks_rcu_qs();
    + 		}
    +@@ mm/page_alloc.c: static unsigned long rcu_free_pages(struct list_head *list)
    + 	return nr;
    + }
    + 
    +-/* Free what rcu_free_take() took: the grace period starts after that */
    +-static unsigned long rcu_free_flush(struct list_head *list)
    ++/*
    ++ * Free what rcu_free_take() took: the grace period starts after that.
    ++ * @direct frees to the buddy lists instead of this CPU's pcp lists.
    ++ */
    ++static unsigned long rcu_free_flush(struct list_head *list, bool direct)
    + {
    + 	if (list_empty(list))
    + 		return 0;
    + 
    + 	synchronize_rcu_expedited();
    +-	return rcu_free_pages(list);
    ++	return rcu_free_pages(list, direct);
    + }
    + 
    + static void rcu_free_workfn(struct work_struct *work)
    +@@ mm/page_alloc.c: static void rcu_free_workfn(struct work_struct *work)
    + 	rcu_free_start(r);
    + 	spin_unlock_irq(&r->lock);
    + 
    +-	rcu_free_pages(&done);
    ++	rcu_free_pages(&done, false);
    + }
    + 
    + static void rcu_free_expedite_workfn(struct work_struct *work)
    +@@ mm/page_alloc.c: static void rcu_free_expedite_workfn(struct work_struct *work)
    + 	rcu_free_take(r, &list);
    + 	spin_unlock_irq(&r->lock);
    + 
    +-	if (rcu_free_flush(&list))
    ++	if (rcu_free_flush(&list, false))
    + 		count_vm_event(PGFREE_RCU_EXPEDITE);
    + }
    + 
     @@ mm/page_alloc.c: static void rcu_free_defer(struct folio *folio)
      		queue_work(rcu_free_wq, &r->expedite);
      }
      
     +/*
    -+ * Free what every CPU's lists hold.  A concurrent drain holds the lock
    -+ * until it has freed what it took.
    ++ * Free what every CPU's lists hold, straight to the buddy lists: the
    ++ * callers want to allocate the pages next.  A concurrent drain holds the
    ++ * lock until it has freed what it took.
     + */
     +static void rcu_free_drain(void)
     +{
    @@ mm/page_alloc.c: static void rcu_free_defer(struct folio *folio)
     +		rcu_free_take(r, &list);
     +		spin_unlock_irq(&r->lock);
     +	}
    -+	if (rcu_free_flush(&list))
    ++	if (rcu_free_flush(&list, true))
     +		count_vm_event(PGFREE_RCU_DRAIN);
    ++	/* An expedite in flight holds pages it took off the lists */
    ++	for_each_possible_cpu(cpu)
    ++		flush_work(&per_cpu_ptr(&rcu_free_pcpu, cpu)->expedite);
     +	mutex_unlock(&lock);
     +}
     +
    @@ mm/page_alloc.c: bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
      }
      
     +/*
    -+ * Reclaim is about to give up: if the pages waiting for a grace period
    -+ * would bring an eligible zone above its min watermark, free them and
    -+ * retry.  Not for a dying task, which frees memory by exiting.
    ++ * Reclaim is about to give up: if the pages waiting for a grace period,
    ++ * with what reclaim can still free, would bring an eligible zone above its
    ++ * min watermark, free them and retry.  Not for a dying task, which frees
    ++ * memory by exiting.
     + */
     +static bool rcu_free_wait(gfp_t gfp_mask, unsigned int order,
     +			  struct alloc_context *ac, int alloc_flags,
    @@ mm/page_alloc.c: bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
     +		if (!waiting)
     +			continue;
     +
    -+		available = waiting +
    ++		available = waiting + zone_reclaimable_pages(zone) +
     +			    zone_page_state_snapshot(zone, NR_FREE_PAGES);
    -+		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
    ++		/*
    ++		 * Count pages only: for order > 0 __zone_watermark_ok() also
    ++		 * wants a free block of that order, and the waiting pages are
    ++		 * not free yet.
    ++		 */
    ++		if (__zone_watermark_ok(zone, 0, min_wmark_pages(zone),
     +					ac->highest_zoneidx, alloc_flags,
     +					available)) {
     +			(*rcu_free_waits)++;
 7:  61b797a643a3 !  7:  1058885aa5a9 mm: free the pages waiting for a grace period before isolation fails
    @@ Commit message
         offline stuck on a busy page would otherwise start an expedited grace
         period on every retry.
     
    -    Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/memory_hotplug.c ##
    @@ mm/memory_hotplug.c: int offline_pages(unsigned long start_pfn, unsigned long nr
      		ret = test_pages_isolated(start_pfn, end_pfn,
      					  PB_ISOLATE_MODE_MEM_OFFLINE);
     +		/* What this pass migrated can wait for a grace period */
    -+		if (ret && migrated &&
    -+		    zone_page_state_snapshot(zone, NR_FREE_RCU_PAGES))
    ++		if (ret && migrated && zone_rcu_free_waiting(zone))
     +			rcu_free_sync();
      
      	} while (ret);
    @@ mm/page_alloc.c: static void rcu_free_drain(void)
     +		return;
     +
     +	rcu_free_drain();
    -+	for_each_possible_cpu(cpu) {
    -+		struct rcu_free_pcpu *r = per_cpu_ptr(&rcu_free_pcpu, cpu);
    -+
    -+		flush_work(&r->rwork.work);
    -+		flush_work(&r->expedite);
    -+	}
    ++	for_each_possible_cpu(cpu)
    ++		flush_work(&per_cpu_ptr(&rcu_free_pcpu, cpu)->rwork.work);
     +}
     +
      static void __init rcu_free_init(void)
    @@ mm/page_alloc.c: int alloc_contig_frozen_range_noprof(unsigned long start, unsig
      	/* Make sure the range is really isolated. */
     -	if (test_pages_isolated(outer_start, end, mode)) {
     +	ret = test_pages_isolated(outer_start, end, mode);
    -+	if (ret && zone_page_state_snapshot(cc.zone, NR_FREE_RCU_PAGES)) {
    ++	if (ret && zone_rcu_free_waiting(cc.zone)) {
     +		rcu_free_sync();
     +
     +		/* A freed folio can merge with a free buddy below start */
    @@ mm/page_alloc.h: struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned in
      void free_frozen_pages(struct page *page, unsigned int order);
      void free_unref_folios(struct folio_batch *fbatch);
     +void rcu_free_sync(void);
    ++
    ++/* Whether @zone has pages waiting for a grace period */
    ++static inline bool zone_rcu_free_waiting(struct zone *zone)
    ++{
    ++	return IS_ENABLED(CONFIG_PAGE_RCU_FREE) &&
    ++	       zone_page_state_snapshot(zone, NR_FREE_RCU_PAGES);
    ++}
      
      #ifdef CONFIG_NUMA
      struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
 -:  ------------ >  8:  c1fe5ee6d2a9 mm/compaction: free the migrated folios that wait for a grace period
 8:  cbcc28707563 !  9:  58f670555c22 mm/memory-failure: handle folios with PG_rcu_free
    @@ Commit message
         later freed with the poisoned page in it, and that page can be handed
         out again.
     
    -    Free the waiting pages first when the page looks like one of them.
    -    memory_failure() has to do it before it sets PG_hwpoison.  The free of a
    -    poisoned order-0 page drops the page instead of returning it to the
    -    buddy allocator, so a later drain would still leave the error ignored.
    +    Free the waiting pages first when the page looks like one of them, and
    +    again on each retry in get_any_page(): the page can be freed while it
    +    retries.  memory_failure() has to do it before it sets PG_hwpoison.  The
    +    free of a poisoned order-0 page drops the page instead of returning it
    +    to the buddy allocator, so a later drain would still leave the error
    +    ignored.
     
         A folio with PG_rcu_free that is still in use may be copied by a reader
         that holds no reference.  When memory_failure() succeeds, its caller can
    @@ Commit message
     
         Both callers hold mf_mutex and can wait for the grace period.
     
    -    Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/memory-failure.c ##
    -@@ mm/memory-failure.c: static int get_hwpoison_page(struct page *p, unsigned long flags)
    - 	return ret;
    +@@ mm/memory-failure.c: static int __get_hwpoison_page(struct page *page, unsigned long flags)
    + 	return 0;
      }
      
     +/* A page waiting for a grace period is not in the buddy yet: free it */
     +static void mf_free_rcu_pages(struct page *p)
     +{
    -+	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
    ++	if (!zone_rcu_free_waiting(page_zone(p)))
     +		return;
     +	if (page_count(p))
     +		return;
    -+	if (!zone_page_state_snapshot(page_zone(p), NR_FREE_RCU_PAGES))
    -+		return;
     +	if (is_free_buddy_page(p))
     +		return;
     +
     +	rcu_free_sync();
     +}
     +
    - /*
    -  * The caller must guarantee the folio isn't large folio, except hugetlb.
    -  * try_to_unmap() can't handle it.
    + #define GET_PAGE_MAX_RETRY_NUM 3
    + 
    + static int get_any_page(struct page *p, unsigned long flags)
    +@@ mm/memory-failure.c: static int get_any_page(struct page *p, unsigned long flags)
    + 	}
    + 
    + try_again:
    ++	mf_free_rcu_pages(p);
    + 	if (!count_increased) {
    + 		ret = __get_hwpoison_page(p, flags);
    + 		if (!ret) {
     @@ mm/memory-failure.c: int memory_failure(unsigned long pfn, int flags)
      	if (res != -ENOENT)
      		goto unlock_mutex;
    @@ mm/memory-failure.c: int memory_failure(unsigned long pfn, int flags)
      	if (TestSetPageHWPoison(p)) {
      		res = -EHWPOISON;
      		if (flags & MF_ACTION_REQUIRED)
    +@@ mm/memory-failure.c: int memory_failure(unsigned long pfn, int flags)
    + 		if (flags & MF_COUNT_INCREASED)
    + 			put_page(p);
    + 		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
    ++		/*
    ++		 * The memory_failure() that set PG_hwpoison may have failed
    ++		 * without waiting for lockless readers, and the caller may
    ++		 * unmap the page once this returns 0.
    ++		 */
    ++		if (!res && folio_test_rcu_free(page_folio(p)))
    ++			synchronize_rcu();
    + 		goto unlock_mutex;
    + 	}
    + 
     @@ mm/memory-failure.c: int memory_failure(unsigned long pfn, int flags)
      
      identify_page_state:
    @@ mm/memory-failure.c: int memory_failure(unsigned long pfn, int flags)
      	mutex_unlock(&mf_mutex);
      	return res;
      unlock_page:
    -@@ mm/memory-failure.c: int soft_offline_page(unsigned long pfn, int flags)
    - 
    - retry:
    - 	get_online_mems();
    -+	mf_free_rcu_pages(page);
    - 	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
    - 	put_online_mems();
    - 
 9:  e1e5b7cd3c3e ! 10:  46d88376b778 mm: have folio_mark_accessed() return whether the folio is hot
    @@ Commit message
         No caller uses the value yet.  Preparation for reading the folios that
         it calls hot without a folio reference.
     
    -    Assisted-by: LLM
         Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
         [kas: shorter changelog]
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
10:  fcd474ea7b1c ! 11:  3afb00ad5b68 mm/filemap: mark a folio accessed in one place in filemap_read()
    @@ Commit message
         No change in behaviour intended.  Preparation for deciding in the
         helper which folios are worth reading without a reference.
     
    -    Assisted-by: LLM
         Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
         [kas: shorter changelog]
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
11:  585dd033a029 ! 12:  abe088444b40 mm/filemap: set PG_rcu_free on the folios that reads keep coming back to
    @@ Commit message
     
         pgfree_rcu_mark in /proc/vmstat counts the pages that get the flag.
     
    -    Assisted-by: LLM
         Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
         [kas: count the marks, AS_RCU_READ, 64-bit only, shorter comment,
          rewrote the changelog]
12:  34d07f67849e <  -:  ------------ mm/filemap: don't defer the free of folios of an inode being evicted
13:  5bd0abaeaa08 <  -:  ------------ mm/filemap: store the end of a read in f_ra only when it changes
14:  e9ece1540b38 ! 13:  970b0c9bb8d4 mm/filemap: read from the page cache without folio references
    @@ Commit message
         Leave to the slow path a folio that is not uptodate, needs readahead or
         dropbehind, is not hot, or has a poisoned page.  Leave large folios
         there too: looking one up for every page is slower than one reference
    -    for all of its pages.  Copy at most 512 KiB per rcu_read_lock()
    -    section, and skip files that never had a folio flagged or that are
    -    writably mapped where flush_dcache_folio() is needed.
    +    for all of its pages.  A split clears PG_head before the new folios
    +    replace the old one in their slots, so copy an order-0 folio only at its
    +    own index.  Copy at most 512 KiB per rcu_read_lock() section, and skip
    +    files that never had a folio flagged or that are writably mapped where
    +    flush_dcache_folio() is needed.
    +
    +    Declare the folio batch in the loop: with stack auto-initialisation,
    +    the compiler zeroes it where it is declared, and the copy without
    +    references does not use it.
     
    -    Assisted-by: LLM
         Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
         [kas: i_size before the second look at the slot, poisoned folio check,
    -     large folios left to the slow path, 512 KiB sections, shorter comments
    -     and changelog]
    +     large folios left to the slow path, 512 KiB sections, folio batch in
    +     the loop, shorter comments and changelog]
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/filemap.c ##
    @@ mm/filemap.c: static void filemap_end_dropbehind_read(struct folio *folio)
     +		return false;
     +	if (folio_test_readahead(folio) || folio_test_dropbehind(folio))
     +		return false;
    -+	/* memory_failure() waits only for readers that got past this */
    -+	if (folio_contain_hwpoisoned_page(folio))
    -+		return false;
     +	/* One reference covers all of a large folio's pages */
     +	if (folio_test_large(folio))
     +		return false;
    ++	/* A split clears PG_head before it puts the new folios in their slots */
    ++	if (folio->index != index)
    ++		return false;
    ++	/* memory_failure() waits only for readers that got past this */
    ++	if (folio_test_hwpoison(folio))
    ++		return false;
     +
     +	/*
     +	 * The slow path does not call folio_mark_accessed() on the folio that
    @@ mm/filemap.c: static void filemap_end_dropbehind_read(struct folio *folio)
       * filemap_read - Read data from the page cache.
       * @iocb: The iocb to read.
     @@ mm/filemap.c: ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
    + 	struct file_ra_state *ra = &filp->f_ra;
    + 	struct address_space *mapping = filp->f_mapping;
    + 	struct inode *inode = mapping->host;
    +-	struct folio_batch fbatch;
    + 	int i, error = 0;
      	bool writably_mapped;
      	loff_t isize, end_offset;
      	loff_t last_pos = ra->prev_pos;
    @@ mm/filemap.c: ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
      	if (unlikely(iocb->ki_pos < 0))
      		return -EINVAL;
     @@ mm/filemap.c: ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
    - 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
    - 	folio_batch_init(&fbatch);
    + 		return 0;
      
    + 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
    +-	folio_batch_init(&fbatch);
    ++
     +	fast_read = filemap_read_rcu(iocb, iter, last_pos);
     +	if (fast_read) {
     +		already_read += fast_read;
    @@ mm/filemap.c: ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
     +		if (!iov_iter_count(iter))
     +			goto out;
     +	}
    -+
    + 
      	do {
    ++		struct folio_batch fbatch;
    ++
    ++		folio_batch_init(&fbatch);
      		cond_resched();
      
    + 		/*
     @@ mm/filemap.c: ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
    - 		folio_batch_init(&fbatch);
    + 			filemap_end_dropbehind_read(folio);
    + 			folio_put(folio);
    + 		}
    +-		folio_batch_init(&fbatch);
      	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
      
     +out:
      	file_accessed(filp);
    - 	/* Readers sharing the file would bounce the line for nothing */
    - 	if (ra->prev_pos != last_pos)
    + 	ra->prev_pos = last_pos;
    + 	return already_read ? already_read : error;
15:  c90a38e2e97a ! 14:  7eaf88828496 mm/filemap: read large folios without folio references
    @@ Commit message
         slot of the last page to copy holds it too, the pages in between are
         this folio's: copy them after one lookup.  The folio's size is read
         without a reference and only picks the page to check; a split after the
    -    check copies PG_rcu_free to the new folios.
    +    check copies PG_rcu_free to the new folios.  A split can also change the
    +    order and PG_head under the reader: clamp the order, and read
    +    PG_has_hwpoisoned without folio_test_has_hwpoisoned(), which asserts
    +    PG_head.
     
         Copy page by page with _copy_to_iter(): the hardened usercopy check of
         copy_to_iter() reads the folio's order, which a split can change.
     
    -    Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/filemap.c ##
     @@ mm/filemap.c: static bool filemap_read_rcu_can_copy(struct folio *folio, pgoff_t index,
    - 	/* memory_failure() waits only for readers that got past this */
    - 	if (folio_contain_hwpoisoned_page(folio))
    + 		return false;
    + 	if (folio_test_readahead(folio) || folio_test_dropbehind(folio))
      		return false;
     -	/* One reference covers all of a large folio's pages */
     -	if (folio_test_large(folio))
     -		return false;
    + 	/* A split clears PG_head before it puts the new folios in their slots */
    +-	if (folio->index != index)
    ++	if (!folio_test_large(folio) && folio->index != index)
    + 		return false;
    + 	/* memory_failure() waits only for readers that got past this */
    + 	if (folio_test_hwpoison(folio))
    + 		return false;
    ++	/* Not folio_test_has_hwpoisoned(): it asserts PG_head, a split clears it */
    ++	if (folio_test_large(folio) &&
    ++	    test_bit(PG_has_hwpoisoned, &folio->_flags_1))
    ++		return false;
      
      	/*
      	 * The slow path does not call folio_mark_accessed() on the folio that
    @@ mm/filemap.c: static struct folio *filemap_read_rcu_lookup(struct xa_state *xas,
     +		pgoff_t index, size_t offset, size_t bytes)
     +{
     +	pgoff_t end = index + DIV_ROUND_UP(offset + bytes, PAGE_SIZE);
    ++	unsigned int order;
     +	pgoff_t next;
     +
     +	if (end - index > 1 && folio_test_large(folio)) {
    -+		/* Read without a reference: it only picks the page to check */
    -+		next = folio_next_index(folio);
    ++		/* A split can change it under us: it only picks the page to check */
    ++		order = min(folio_large_order(folio), MAX_PAGECACHE_ORDER);
    ++		next = folio->index + (1UL << order);
     +		if (next > index && next < end)
     +			end = next;
     +		xas_set(xas, end - 1);
 -:  ------------ > 15:  1455ef101c5c mm/filemap: don't store f_ra.prev_pos for FMODE_RANDOM files
16:  c878dc794ca4 ! 16:  77e7c1ce6060 mm/shmem: count accesses to a folio the way filemap_read() does
    @@ Commit message
         marks a tmpfs folio accessed too, so a folio written in several pieces
         can get the flag on its first read.
     
    -    Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/filemap.c ##
    @@ mm/shmem.c: static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_i
      	}
      
      	file_accessed(file);
    -+	/* Readers sharing the file would bounce the line for nothing */
    -+	if (file->f_ra.prev_pos != last_pos)
    -+		file->f_ra.prev_pos = last_pos;
    ++	file->f_ra.prev_pos = last_pos;
      	return retval ? retval : error;
      }
      
17:  e472d4328d29 ! 17:  4fc2a5f445d0 mm/shmem: read without folio references
    @@ Commit message
         PG_reclaim, which drop_caches can leave set on dirty tmpfs folios.  Do
         not let it end the copy there.
     
    -    Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/filemap.c ##
    @@ mm/filemap.c: static void filemap_end_dropbehind_read(struct folio *folio)
     +	/* shmem does no readahead: there the bit is PG_reclaim */
     +	if (folio_test_readahead(folio) && !folio_test_swapbacked(folio))
      		return false;
    - 	/* memory_failure() waits only for readers that got past this */
    - 	if (folio_contain_hwpoisoned_page(folio))
    + 	/* A split clears PG_head before it puts the new folios in their slots */
    + 	if (!folio_test_large(folio) && folio->index != index)
     @@ mm/filemap.c: static bool filemap_read_rcu_batch(struct kiocb *iocb, struct iov_iter *iter,
       * Copy from the page cache without folio references, in batches, and
       * return how much was copied.  The slow path reads the rest.
    @@ mm/shmem.c: static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_i
     -
     +out:
      	file_accessed(file);
    - 	/* Readers sharing the file would bounce the line for nothing */
    - 	if (file->f_ra.prev_pos != last_pos)
    + 	file->f_ra.prev_pos = last_pos;
    + 	return retval ? retval : error;
18:  b05c7c67fdf7 ! 18:  9a845ea67175 mm/filemap: add a debugfs switch for lockless page cache reads
    @@ Commit message
         Folios that have the flag keep it, and their free stays deferred: a read
         that tested the key before the switch may still be copying from them.
     
    -    Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/Kconfig ##
     @@ mm/Kconfig: config PAGE_RCU_FREE
    - 	  64-bit only: it takes a page flag, and those are scarce on
    - 	  32-bit.
    + 	  32-bit.  Not on PREEMPT_RT, where expedited grace periods are
    + 	  normal ones, so freeing the waiting pages on demand would stall.
      
     +	  Writing 0 to lockless_page_cache_read in debugfs turns these
     +	  reads off.

base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.54.0


