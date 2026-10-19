Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4256075536
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XO3Nb3pb
Received: by kanga.kvack.org (Postfix)
	id A3A546B02B8; Mon, 19 Oct 2026 11:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11C06B02BA; Mon, 19 Oct 2026 11:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2996B02BB; Mon, 19 Oct 2026 11:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFA16B02B8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:49:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F252D80739
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:27 +0000 (UTC)
X-FDA: 85339810374.26.FE1AFCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1278980005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XO3Nb3pb;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792424966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wQ990R/5ZEFygzTrA1YWpJldH6G4pj9OJvJoQ4d/FzA=;
	b=1NoHoyxFzWsHmniektUtuq+EhFqPr/8uBq4d6SMSJbj65RTcBXkenpWUebxXeCJx6gdV2R
	Y9YKYsVRO9lEA3mNrpbAycTNuNd4Xt4SWQq2czR9fF+3ZR34VL7l0pe3DyB7coGuPr/W0T
	FOSupeSGfEcb9C+y4UTSqr2agL1nZtU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792424966;
	b=1+1DG41k4tk7S8lxjjQ1/Z+ZxpLCs5VIv9mNiYGnPJZdHk7iCUlb5+qMgV2GE2DcZrkaWM
	iTqIENoXUcsIQ9qUkczxzUewOqJf8l9vVawcs0FuMmfuIxk/4HBo7FaPUrRi0b/+O+8685
	s3nv0eHdE/UNGET01pN43kHdZp3cKKM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XO3Nb3pb;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DBF960D8B;
	Mon, 19 Oct 2026 15:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01DF1F000C6;
	Mon, 19 Oct 2026 15:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792424965;
	bh=wQ990R/5ZEFygzTrA1YWpJldH6G4pj9OJvJoQ4d/FzA=;
	h=From:To:Cc:Subject:Date;
	b=XO3Nb3pbWKkDGqCqWt8s1g/51Qyc4mj4/fgl6/opq9MTwuO4eZBy+p3UjSvTVPCnB
	 HFVv8NBrwMV+tzuD4W8FMgZLaYK66C/MnjxScnnxzcixTYjJHwEkRkaY8xYYKvGQ/O
	 Tzcf6e3uDImMRgemALgvUquPxIcGzeXf3sAxvXZ3TokEVWYQfBy8jsilFN1dbVfCqE
	 TTycvf2swMcdSUaeMvMIy1W0Tuza05QYaN4ykt2iyM5FGkCcTcyhGUZcKYOvhKoGhy
	 6Q/jCd/LkeiM4lIWtlmSsyz5BHVYHnMG+07nA5x8v7EAZvlojWYt3RR8hfq/TkLZgg
	 TX73pem4Gln5A==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id D5766198003A;
	Mon, 19 Oct 2026 11:49:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 19 Oct 2026 11:49:20 -0400
X-ME-Sender: <xms:_DvWarseNCNj-1K3ydVi1xpumSkQnRRl0n5vfaaii2blHYR3U61zXg>
    <xme:_DvWahsrDgai0popxK3pq4Q1XluvLOGchJiOqe9xfkK9rqCfc4GcNjM3mY_DVY3Ge
    zCamNpZGDe-iIKodklILTXSCMfjd1-cKkA7Q9HUjUnS7ku1nNezhEo>
X-ME-Received: <xmr:_DvWahbs8pkdUrzHftHpVz-buvBTdJPgSIwm4Dc_26XSgKAyYT3HmhraTj0>
X-ME-Proxy-Cause: dmFkZTFnkWJlnRk13lJhbRMMhE24dqHowqcTpm9YnVFCemJ9z1tAQpZ9UIKuKv51JTF9iU
    2hhiCZ/IkT2KxjYD1ShgD9a8RgpKwa1ZheIFR1syQqOIS3t0DJ6bqLkU+G81/Jio6o2rdC
    s/B/caTmFCInO3FojJZuX51tsa4/gHWZt0MUXYC9sddXDHQs46fNpBKHuKE6MOHDPyefYn
    l6VnrgdUlXLxuiEoE2SiiLcfnf2ThqoippUJSZDkevty9fwgaade8PBXXf+tzNHIYFu07R
    ynO280RbJB/GY1Qm4ViCxbIy3aeA969J+Dk/0GeiMVe/ykRsNG+2DaTjjzJSlq9y9IYoon
    f53H32j06ZqUchtJR5QJZ7KWf4Ez+qIPEIT60hpoC9Th/vETMECu7oyXr1b7y6Cz5T9pgw
    iDRLbIhl1oCHf7zZcI6zLLIQfq/4WmmOvW9O8Z7NG+pNWg/TYiAiWEj/yH2nTWiyCg0mlI
    0bePk9NM6FmywzSzngeyGAfHaq8Ki8WT10Qy2PcyZxNnhBLVFV0TZLh29rlCfvXmU5/yFk
    mXEQrbRzTxA4hJhJgUnPXqvy5Nl1LcCbvaaJn2KoCaJ2tHOjrKUOAcQRaxxQAPhKe3VL1L
    NrtsEPA37iaCPnNH6VTmYZ2lB26fbsgdjj6pjobnvYH9rZyBMFQHP9vZylnw
X-ME-Proxy: <xmx:_DvWap5lmUainyAt7bSZ6lkHgk4huaKIzOazymiC7u17IuILHkbjcw>
    <xmx:_DvWasnGXEdbl4e6Hjht9bitXSO7XtEuY9_rhlDqZGTdOaU0FR-P2g>
    <xmx:_DvWahpMvpEOY0yX0IfKKOvx2Fhm3-NSh4s2p-8uiVX3JfHKzEVAsA>
    <xmx:_DvWav_83QHLq2h3tPtvvo-hEzPA7u3TKkvmmGzgs7R0-uGDUmNanA>
    <xmx:_DvWai4YwVyeGoTNjWIJZm_bF08gZwsYe8RxVLfeEgRW1l9eqxILwns1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:49:15 -0400 (EDT)
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
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
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
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH 00/18] mm: read the page cache without folio references
Date: Mon, 19 Oct 2026 16:48:53 +0100
Message-ID: <20261019154913.1765974-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1278980005
X-Stat-Signature: 64geckaz5p95nfeisf3nyrdn5dm8ngme
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792424965-266384
X-HE-Meta: U2FsdGVkX1969ahmjEEk4+qKCOYDl/ECcF1m+m2pWQQdHLa09f9KbUoQ0OJJw5V/GvxbJD9Evr6+eTt1naARopzVZrzpjIn7rV3xoDljl71Tr+nv3Iuo4zhVch8yCBPIZ4G1S3j34uBjYQFid3RmEAf0nzY//1J3tnGE6+2v2YvHwAbbJIAa5crmVIVAaigpL3NQR86AKG8zqHD6YyOoO/WkqtogMdvis+/mRx6ePAh9ubGTDko0/N/UZDZ9XrT0qwK8zd6WVOQyAgKhs8uuHUF3nwYA8dh42ZlXILqiMhd+hZit2Z0PzG6+wizFDRe22vyGaOgGo3UT+qoaNoB7wx1oOnRPN9DufLkq0li3cT/zf6AdXJMyclrNk/FTcfyfRqDvtsK0rUtVEYuyW8RwGYYXsQrHAKTP7n8Nlw9s2rwkrSz69ThOfnyjf9pVQJEBO5YOgU3I4maxUiaPExqSPQBmATaHgxom/oTinU6zOBMU62GTUTMSUVgUOCmaCLikF5+taqzzSlY8Vi0fm2neuHqqLHUdPcBTUi+PsIWdjA6X/j3rmWlHI0EyEKkqd2Tv+7L6YA7Y9naVqPvbgF4wwdqjde+ehah07cTt3/DPz3fNtSdAnVRFkw8L9raSxtNoE2txnqL3B1TGjsrC9diutXUdT/rsq88OqlzgMdtj7npdUUGvc2Q2TpjLLmVzy+Ozc9hJSezewyhs7mlgRl6AUasyy88ahL9FJlJe9KR9lvuXevmZb5zsnxVWqJrJ1WNi97GM4cWoK0o9XwtsXExmRSWZwV5WrNmYni71jDq2HMOrku3BoOoh36giJ6Nl9rv3DSyD+scm/9Wt/mPlmxs7t5k/oQvqbn+Ts5kYvaWLqyZyd63Ru/E6lrDcS2DBmnBzSB3veLEoyhpBPuxKHW7aPpES4XBjJrUdPrh87bL8jKYzXNDmeGeuZ4yVCDGUh5m1zswoGg6kVhcGp8d+eYO
 iBdJUI81
 R6LD1yI6BgsPMDMQQMuwyQkpHbUel+Cp6wx851UeqTPjJv4imgwjmu+WXK05XBMBAfCQb9IcVdu/91gAz3lbLYBZX1rK7Z6F/E+aXqauouh11jO8bM9Ti+SRkA6fISKbyLa/1hTVTapQ/zlaZVQbUkhKKOm+9HNa9D/TPAa3E9QYdlbsCcdk0P7Hy9xxnpqH5KKuDInGi3QbqScAfOP7O7cy7cVQrphLzay42Sj+M9HS72ikzmScCxiTUuJN8cqHRppWXzD/4pTq6RdtWf9mMRTml8bfMc61qoLd/lDbXKQsQ8+uG/d4f89tlMaQp8V88K8C8YgE+CfZg0NULyppno7OtzbV5GPdFdi58mqDGKCTkV8aZe80NL8ONAHhYxv7Dqc38HOR2guooQgk=
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

  1      PG_rcu_free and the deferred free (64-bit only)
  2-3    splice and fuse no longer reuse page cache folios that a
         lockless reader may still copy from
  4-7    NR_FREE_RCU_PAGES; an expedited grace period when a CPU's
         deferred frees pile up and memory runs short; the waiting
         pages are freed before the allocator, alloc_contig_range() or
         memory offline give up
  8      memory_failure() and soft offline deal with such pages
  9-11   filemap_read() marks a folio accessed in one place and sets
         PG_rcu_free on the folios that reads keep coming back to
  12     the folios of an inode being evicted are freed at once
  13     f_ra.prev_pos is written only when it changes
  14     filemap_read() copies small folios without a reference
  15     ... and large folios, with one more lookup per folio
  16-17  shmem does the same
  18     a debugfs switch to turn the reads off

Numbers: 64-vCPU KVM guest on a Threadripper 7975WX (Zen 4), 2G, no
debug options; base is v7.3-rc7.

With the default mitigations, every read on this machine pays ~400 ns
at the user/kernel boundary (TSA ~170 ns, SRSO ~230 ns): a single thread
does ~1.8M reads/s.  With mitigations=off it does 7.1-8.8M, and the
64-thread gain on ext4 grows from 4.5x to 13x.  Linus measured 7.4-7.8M
for one thread and 13.3M -> 304M for 64 threads on a Threadripper 3970X
[1].  Rows without "mit=off" use the default mitigations.

  16-byte pread() at offset 0, each thread with its own fd, M reads/s:
                                 base           this series
    ext4, 64 threads             15.0-15.7      68.9-70.1
    ext4, 64 threads, mit=off    17.2           217-220
    tmpfs, 64 threads            1.6-1.7        71-72
    tmpfs, 64 threads, mit=off   1.8-1.9        230-239
    XFS, 64 threads              11.3-11.4      20.4-20.5
    block dev, 64 threads        14.7           28.8-28.9
    1 thread, any of them        1.6-1.9        1.7-2.0

  The mit=off rows are from an earlier version with the same small-read
  path.  Base tmpfs takes the folio lock on every read: 64 threads read
  as fast as one.  XFS and the block device take i_rwsem shared on every
  read (XFS_IOLOCK_SHARED, inode_lock_shared() in blkdev_read_iter()),
  and its count bounces in place of the refcount.

  64 threads reading 64K at offset 0 of one file, one large folio,
  k MiB/s:
                           base           this series
    huge tmpfs             96-100         1370-1390
    ext4                   756-775        1355-1373

  Large sequential reads of a 256M file: single-thread within ~1% of
  base, 16 threads at base.

  Next to a process that touches 1400M in a loop: no OOM kill.  A load
  that drops 1G of hot data with FADV_DONTNEED every round runs between
  9% below and 1% above base, which itself spans 63-75k MiB/s there.  A
  load that keeps refaulting loses 4-6%, as Linus' RFC does.

Open:

- Patch 12 relies on mapping_exiting() meaning that no file holds the
  inode open.  f2fs called truncate_inode_pages_final() on open inodes
  for atomic writes; a fix is on its way [2].
- Patch 17 drops the folio lock from tmpfs reads.  shmem_get_folio()
  held it only for the lookup, so a read was never atomic against a
  write or a hole punch; now a read also does not wait for one that
  holds the lock, as filemap_read() does not.  I believe this is safe,
  but would like Hugh to double check.
- A deferred folio is uncharged from its memcg before it waits, as every
  page cache folio is.  For a grace period it counts towards no cgroup.
- A migrated flagged folio is freed after a grace period, so a pageblock
  that compaction just emptied is free only then.  defrag_mode leans on
  free pageblocks; not measured yet.
- The flag is a page flag, 64-bit only.  On large configs it costs MGLRU
  one refs bit.
- On writably mapped files, architectures that implement
  flush_dcache_page() take the slow path.
- filemap_mark_hot() still tests uptodate.  Willy pointed out that a
  filesystem clearing it under a reader is a filesystem bug; the test is
  cheap.

The series is also at:
  https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git rcu-free/rfc-v1

[1] https://lore.kernel.org/all/CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com/
[2] https://lore.kernel.org/all/20261015161714.1586334-1-daeho43@gmail.com/

Kiryl Shutsemau (Meta) (11):
  fuse: don't move a folio with PG_rcu_free into a fuse file
  mm: count the pages waiting for a grace period
  mm: free the pages waiting for a grace period before OOM
  mm: free the pages waiting for a grace period before isolation fails
  mm/memory-failure: handle folios with PG_rcu_free
  mm/filemap: don't defer the free of folios of an inode being evicted
  mm/filemap: store the end of a read in f_ra only when it changes
  mm/filemap: read large folios without folio references
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
 include/linux/page-flags.h     |  24 +++
 include/linux/pagemap.h        |  12 ++
 include/linux/swap.h           |   2 +-
 include/linux/vm_event_item.h  |   2 +
 include/trace/events/mmflags.h |   7 +
 mm/Kconfig                     |  15 ++
 mm/filemap.c                   | 337 +++++++++++++++++++++++++++++++--
 mm/folio.c                     |  46 +++--
 mm/huge_memory.c               |   1 +
 mm/internal.h                  |   3 +
 mm/memory-failure.c            |  28 +++
 mm/memory_hotplug.c            |   7 +
 mm/page_alloc.c                | 284 ++++++++++++++++++++++++++-
 mm/page_alloc.h                |   1 +
 mm/shmem.c                     |  22 ++-
 mm/show_mem.c                  |   9 +-
 mm/vmstat.c                    |   6 +
 20 files changed, 770 insertions(+), 92 deletions(-)


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.54.0


