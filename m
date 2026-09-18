Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110B1C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 04:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037076B008C; Fri, 18 Sep 2026 00:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A1A6B0093; Fri, 18 Sep 2026 00:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BC26B0096; Fri, 18 Sep 2026 00:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5A4C6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:17:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44B70A056E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:17:59 +0000 (UTC)
X-FDA: 85225575078.04.F0F771C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A0622180004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:17:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZdUIubP;
	spf=pass (imf16.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789705077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WWxabFUVlB3kxXBm4kFTC6I3NzI8FakdyNfET9iDosQ=;
	b=zbOJPGD7eCZLNIH1iX/yDqxIYv7doMxLpRZ2BM28ele3beTGTznPE4N4tDVH2cHhz+IyLc
	u3dvmcOXkLnXGpGBmFbay+o2POAP2lTrmUjdauP4XKOuCqAVBnkB6RwSeh4L3eHpFzBXDI
	lRltid3RTNQmpZrTHM5C/Ea2JAO0lAw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789705077;
	b=rZ43pC9kBZCOX6cDcc/1m1XHNVQFQ01ulbeguU+WZas5MYz017m1bNMSbghfytS9lXTr3E
	LAbMx5AKTp5OgMvwYhFJyN/u6BocVQ53YiRZ5CRAtrt6F9Z5TxiwSERs1pFC+jl38EMA2Y
	IJGRDS6s/aT1t8XstDVgCl48OMe1vPM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZdUIubP;
	spf=pass (imf16.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CFE360202;
	Fri, 18 Sep 2026 04:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E811F000FF;
	Fri, 18 Sep 2026 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789705076;
	bh=WWxabFUVlB3kxXBm4kFTC6I3NzI8FakdyNfET9iDosQ=;
	h=From:To:Cc:Subject:Date;
	b=dZdUIubP7WawPPBoUISGeGIF5ET69n9vHrkUVvspPnrH7fxHweJj2pqEOElVx2vIL
	 0gFC5UbRFw2yyrUHY8PuEWsj3Mk6WHImCplwTlI60/XUI76P7v6YKqCFuBRQ3z6vC8
	 D4IfiDdtb9OpF9KJwyaUUmE0WCWrChqkCcnscAtjBVSlbLeT1gn8kIAGDPn7QXBRDy
	 uyVZJ/cSvCjKvvkrk1SWqjkP71K7D2BHoKJ257aiaDDnQ+ozchaBZMGL59Cyc8YNCA
	 cgNPGGgrw2vZkS3Mn+lrb1xgQs6YmdMPOv5u8KaDeiJ+0j1eeksXZuaT4qd7J9F0+p
	 3erBVRFc7D2AQ==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cuitao@kylinos.cn>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [PATCH v3 0/3] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Date: Fri, 18 Sep 2026 12:17:41 +0800
Message-ID: <20260918041744.1526924-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0622180004
X-Stat-Signature: 3c1fqnzfxwfa7qjfmg645ewn8dj65n8q
X-Rspam-User: 
X-HE-Tag: 1789705077-756559
X-HE-Meta: U2FsdGVkX1+NGCTfzph8kUcNchMYc+WjD5Uq15jxnx3OVn0xmc6wZnhnY9efWKoYFYbINpLkR+eb5IjABfoPa9AX9AU2A0N7VeqBVCb+7nWyF2d9E/culf7EIlBPvCkWAvu+5/j838tuHFn4e4nbtSLMq01dwsE3MLduqDUPITXiwLTfFgVw9lZhIhhfL3++CarU30WOuU2fD1KZ6FjEd12c+y+qWo4e7Pig8w6lkofMkZRLAbn4UAGKG41G5fd+oz+F1ukNeGd/wbF1zE2lahkvfK98Ejgaz5PNRi1hiHdckfqtJdhfnOyeJOO6l9ZNf5teKDXi+AeJlHqVkIbI/zU4KqR4Q38UgfHj1S97x1OOFl0mQektueIFOGMaf4CZdvC46j7E0v6kdN1Ki/TI0Lvh1oYQ5gSNBE9/nKBBmRtJD9t0Y51qYtoSphuo+oi15pY7UoHrkvjW2XTjq+nC65vZG5VflQaBAzI8DXWjqalI2Bhej5pWLAWoSDNKysMz3P8cZIQAeAv81jebZt30R3kjOF9lnTliAxSz7yPGa4GkSI1ES7s7TU50OItnx6j4TfilPyBAi0S/AiGgLaWMabX32tufzJMqHIcTpNP6qvXXjHTTmCAwxktDOf43TrK9vJNtvJhtXxuA/8NXUmdGlgNUgC1XZoTDrwUOZaqyTccFwfmruCQ7twijX6QM+JPtV1uONoyHf9GSiK6kcidznVDLSAFw9x9hTxM9vGlQa66SWne8XjYMVaJN2IT3pNNTekvPND/TYcrHUDMZF4p90ZzPwKPgut8V8lucABCuVVbhq22lri7d8vutJ8gao90lrkSIWWHA5QEVWCMuzxR1WHNEr6zLdNE8pXdrQ/LOBePccCe3Hoaay4YosnSmhVJPsjb6VhCOEJMIcawB91VCwOKStYkhgKVGztZBk04wjpDp4+StZBmkftDba2Appe8eRU2aVtm8/M4l0R6bTV1
 5me7HnkH
 +1g4aI2njoaXWcdLaa8nDALzhQ6fWDVJYmL6N0dCNfFBI7FUQP+1dUylNxDcPS4yLjj/9kPXrB2dY68FKe/A165RNDUMCzFADvOjpN9M8DWMwGqkUqHJSokxpJ/k0lIwkQZvPxX22xEP46iRgPWTbhV3qYRMHK9a4DsRlDnB/axUjiSGDIAj8iBf6ThLSHDjlcWHVrJaLOePXiLcmfv2zZkgJCIMi54gjUCVEG+VXOFqtKXa4d55SRTWYHg1R3KON8u5a4r3c5VIafskCPwHiPHvOLd9x/0UB/8r9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

This is v3 of the preparatory series for the blkcg_mutex conversion
proposed in the related series [1]. That conversion moves queue-local
blkg topology synchronization from q->queue_lock to q->blkcg_mutex,
which is awkward while bios directly store queue-local blkg references.

Storing a blkg also ties a bio to one request_queue. A remapped bio must
drop that reference and recreate the association for the new queue even
when no blkcg policy needs it. Dying blkgs add another complication:
they disappear from the per-blkcg lookup tree before all pinned bio
references drain.

Patch 1 makes request_queue the authoritative lookup owner. A
queue-owned rhashtable keyed by the blkcg CSS ID keeps dying blkgs
discoverable until their references drain, while q->blkg_list remains
available for ordered walks.

Patch 2 stores and pins the queue-independent blkcg CSS in each bio.
Queue-local blkgs are created lazily by policy users, then pinned until
the bio changes devices or releases its cgroup state. Completion and
accounting paths which do not create a blkg remain lookup-only.

Patch 3 moves async bio punt state from blkg to blkcg, so punting alone
does not instantiate a queue-local blkg.

Changes since v2:

  - Rebase onto the latest for-7.4/block branch.
  - In patch 2, clarify why dm_bio_record() excludes BIO_BLKG_REF and
    add Nilay Shroff's Reviewed-by.
  - In patch 3, replace scoped spinlock guards with explicit
    spin_lock()/spin_unlock(), drop the redundant teardown check, and
    rely on zero-initialization for async_bios before publication, as
    suggested by Nilay Shroff and Christoph Hellwig.

Changes since v1:

  - Rebase onto the latest block-7.3 branch.
  - In patch 2, require every blkg rhashtable lookup to run inside an
    explicit RCU read-side critical section. Annotate blkg_lookup_any(),
    blkg_lookup(), and recursive wrappers with __must_hold_shared(RCU)
    so Clang thread-safety analysis verifies the contract.
  - In patch 2, exclude BIO_BLKG_REF from the flags saved by
    dm_bio_record(), since restoring an ownership bit cannot recreate
    the associated blkg reference.
  - In patch 3, use scoped spinlock guards for async_bios and annotate
    the list with __guarded_by().
  - Add Nilay Shroff's Reviewed-by to patch 1.

Changes since RFC v3:

  - Drop the RFC prefix.
  - Add Christoph Hellwig's Reviewed-by to patch 1.
  - Add Tao Cui's Reviewed-by to patch 2.
  - In patch 2, relax blkg_lookup_any()/blkg_lookup() to also allow
    q->queue_lock as an alternative to the RCU read lock.

Changes since RFC v2:

  - Drop the old patch 1 and send it separately as a bugfix for 7.3 and
    -stable, as suggested by Christoph Hellwig.
  - Rebase onto the latest for-7.3/block branch.
  - In the new patch 1, note that the remaining q->blkg_list walkers are
    cgroupfs/sysfs slow paths and can move to rhashtable iteration after
    the queue_lock-to-blkcg_mutex conversion.
  - In the new patch 1, explain the list_empty case in blkg_release(), and
    add an RCU lockdep assertion plus documentation that blkg_lookup_any()
    does not acquire a reference.

Changes since RFC v1:

  - Add patch 1 to wait for every old blkg to leave q->blkg_list before a
    shared request_queue is rebound, instead of treating root_blkg == NULL
    as completion of asynchronous blkg teardown.
  - Add patch 2 to replace the per-blkcg radix tree and lookup hint with a
    request_queue rhashtable keyed by blkcg->css.id, as suggested by
    Christoph Hellwig. Keep dying pinned blkgs in the hash until
    blkg_release() so bio-owned references remain discoverable.
  - Fold the v1 helper-only patch into patch 3, as suggested by Jan Kara
    and Christoph Hellwig, and make bio_blkcg() naturally return NULL for
    an unassociated bio.
  - Rework patch 3 so blkg_lookup_create() acquires the bio-owned
    reference, falls back to a live parent when creation or tryget fails,
    and updates bi_blkcg when the returned blkg belongs to an ancestor.
  - Make bio_blkg_lookup() lookup-only: it returns NULL unless BIO_BLKG_REF
    is already set. Use bio_blkg() in the BFQ and IOCOST merge paths which
    may need to create a blkg, while keeping blk_cgroup_bio_start() and
    completion paths lookup-only.
  - Move CSS online-reference handling into
    bio_associate_blkcg_from_css(), including fallback to the root blkcg,
    so bio_associate_blkcg() does not take a redundant reference.
  - Keep the v1 async bio punt conversion as patch 4 and document that
    async_bio_lock protects async_bios.

Previous versions:
  - v2: https://lore.kernel.org/r/cover.1789237876.git.yukuai@fygo.io
  - v1: https://lore.kernel.org/r/20260823133045.970199-1-yukuai@kernel.org
  - RFC v3:
    https://lore.kernel.org/r/20260818070641.756747-1-yukuai@kernel.org
  - RFC v2:
    https://lore.kernel.org/r/20260811064744.1139446-1-yukuai@kernel.org
  - RFC v1:
    https://lore.kernel.org/r/20260804065313.2092022-1-yukuai@kernel.org

Related series:
  [1] RFC v2 blk-cgroup: protect blkgs with blkcg_mutex
      https://lore.kernel.org/r/20260724123037.3004560-1-yukuai@kernel.org

Yu Kuai (3):
  blk-cgroup: use a request_queue rhashtable for blkg lookup
  blk-cgroup: store blkcg in bio instead of blkg
  blk-cgroup: move async bio punt state to blkcg

 Documentation/admin-guide/cgroup-v2.rst |   2 +-
 block/bfq-cgroup.c                      |  18 +-
 block/bfq-iosched.c                     |  19 +-
 block/bio.c                             |  22 +-
 block/blk-cgroup-fc-appid.c             |  10 +-
 block/blk-cgroup-rwstat.h               |   2 +-
 block/blk-cgroup.c                      | 346 ++++++++++++++----------
 block/blk-cgroup.h                      |  93 +++++--
 block/blk-core.c                        |   9 +-
 block/blk-crypto-fallback.c             |   2 +-
 block/blk-iocost.c                      |  12 +-
 block/blk-iolatency.c                   |  11 +-
 block/blk-ioprio.c                      |   2 +-
 block/blk-throttle.c                    |   3 +-
 block/blk-throttle.h                    |   2 +-
 drivers/md/bcache/request.c             |   2 +-
 drivers/md/dm-bio-record.h              |   5 +-
 drivers/md/dm.c                         |   2 +-
 drivers/md/md.c                         |   2 +-
 fs/gfs2/lops.c                          |   3 +-
 include/linux/bio.h                     |  26 +-
 include/linux/blk_types.h               |   9 +-
 include/linux/blkdev.h                  |   2 +
 include/linux/writeback.h               |   2 +-
 mm/page_io.c                            |  12 +-
 25 files changed, 381 insertions(+), 237 deletions(-)


base-commit: af78ca007be5f63dc34b8180c8063c1113697192
-- 
2.51.0

