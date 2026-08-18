Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE4D3C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E88D6B08E3; Tue, 18 Aug 2026 03:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798F66B08EB; Tue, 18 Aug 2026 03:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 687106B08ED; Tue, 18 Aug 2026 03:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 416206B08E3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:07:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD9BDA37EA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:07:20 +0000 (UTC)
X-FDA: 85113509040.27.B7B6C62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 525ECC0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:07:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f7Q/JaIa";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RNvoeC0JEXeBglk9uCkZKrFP7tQLecq/zIhUBpbbNJU=;
	b=1imBNLqM4lJV/19OKJpnq+ho3hrnCJCn0twKJmURHboyiZFWsUYN1F6R1sxmxA7WcWxAbF
	98q3i/S5UJDECtCDyuzJTLkIk5ZgdO65XJWR1bDvCvrawY6OEaamv4WwDvYvUVnrYu/o+T
	RkX09ZhdkLMJIJQqTRWRLdOgAuGsWCM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f7Q/JaIa";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036839;
	b=Id7hx9VrUVnWW6GihlFwbsP+MmT2YN9WGb/ofwdFIGtk16YrSOwYTgDRl9IcE4+V9GYl/t
	T6VdHxtk4S+vptJgTGDSE7y8nH9ymF4uCjuOfje+e/KInt2W4qFAHQzQfQuVRQQYd44s0R
	HTNX16A/QyRjnRxQ7HqF4oQZQ2U1Qx0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F5BA60254;
	Tue, 18 Aug 2026 07:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4721F000E9;
	Tue, 18 Aug 2026 07:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787036837;
	bh=RNvoeC0JEXeBglk9uCkZKrFP7tQLecq/zIhUBpbbNJU=;
	h=From:To:Cc:Subject:Date;
	b=f7Q/JaIaMl86dmjnFfyr2kSJU4hsCbDnFS4xWvkYwDU8g4aSuVyXa9+GHJKcdIiw7
	 DxU6in0bDgKlHhbpAbPaOtDielfMvAZ4xxMS2FdRb1DAldqufqTV0/aMcUJ2xiNDmU
	 efY6eMjABNG2upUM/p3MESs1xKCrnD8fwBsM/96GXwwYLaDm7c6mZKIHT8hGJBfpgK
	 mVopXLxlbEd+mhg/iIGeE/V2uFgr86/trU10wAjQ27mBaSPta4axKQuXN5bS0I+NoZ
	 nvl75La8qKMGLJx/ShWuXY1Jl2sDPQg5ridFKsAbvfCX2O+lCwwSca7/fcB71KqU7b
	 9yIq5JhwNIEtg==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 0/3] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Date: Tue, 18 Aug 2026 15:06:38 +0800
Message-ID: <20260818070641.756747-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 77b8hdkw4uuotar91my79c8365bewibf
X-Rspamd-Queue-Id: 525ECC0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787036839-132744
X-HE-Meta: U2FsdGVkX1+RTN9dsLfg4423GP6+BdZpBCmoh0BKOJjFZ42iHqNt31Kj8rsE/mjP4yaaFfjiwR+k0Q9KGF3Uyw1SBLmqWfw9w9Ev1OaGqVMn0X9Q2PJYuu1yV2zN80DMTEZtZav4IO27zINuaoUF1VNat1wFL5FwzF2+4ftGXipBucCGDvAEZwsC67BT0QJyjkzlx07D2rIou7a/aH9tazR6VGa8gmZMMjx3a1ZV5WgnlMsTfn9ztiPx191R3OddIc29RCXcF13GoCw+GjnuOt1eYuZdoTGwNisBC7b3FqQ7DrbHKmq9aF1n0M4DfKOcgiMK5y4LZSqfacKY+ZAod7836nJotYCtBkGmu7KaNe8umVOHREjpxEv+WFFUv+5kINROMoRVtDmbF2nwLOer5RGpX+eeVzp3r/xeI6Ziyh6IoxYhnNvsQCvbwZZqbLPizrfl9CNbHo/wxwUs4mfFkggi1SIqektmmzRHlJUO6w50IvKy11Ov0SqwV9WimFrAy3gUFSZ5G/mf/4yYSYN0cAXgMT98CsKElOljaM2gOPwMvoNiGNl41RsDucZoKvnGHKQERu3ZicTMNfhulErOmjAOLV03uDQfYYUvzFzeTvaWTiayExeiPTOUeGa6/vCKV6/4XFxWlQ/wZtBwFinYN05I/QwZ6InutchxcMV3Y9ZmO267V+OXv3L8I2velxxzhcKIwWcTb1fzgqWZJjqDEuk8KmKappn61cIz3Cfi7eEfcPW1syaUZiG6Ju8nU5f+5x7dM9Du8ouqkx4e8yqMBxWUiCO0vLDook3RwZdRVMDIiISaJIo4EEWVgm1X7HnMwQNN2wFqXFKqTLXVmTdU/JwOtXYRY3GjVPerduesNdP14xRugOYaiXfmAGzJIkOE8u90ctHGujlk0/O+2ZUo9O4lU3F9ByE6qrZPMm7B2kPsbQp99FqGq75UfQ0gPx9bx/VZmcn+r2ei5/qHzd4
 dwada+Ag
 bOwdhYZpWKoO7mRq4qNd4/EKri32QAwS2GNAEtmIrYMyKLBHtQatnjaXtfEinvxqzAiZA5LHUh9iI6Z66ZVY/KIpq1ePPeWEFjhxnCUj5S5gs2j63U+YaGRXDu1sxMYyFvcRbv62ruHdooS0Oh0oshlzF8KzOVnz+0JEMXQgGSyKnueNP5il7wpetZhEIYMg02X7DVrVbDaG2ff0Dg7XNdIJpAeLrQNRkVyUHpi3rxad7UjFAGyWLox3wuiOXWq3Fzb75xjtl7GTkq2zvMxbnBCpJFssdHHyf8/jQC1KrOxi+LaYY1fZKJktXGdpaofW9+zIrBYRQxdU63+N2uOJD/EdcZGRZ7AUyYhjRyPTJPpoJT6o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

This RFC remains a preparatory series for the blkcg_mutex conversion
proposed in the related blkcg_mutex RFC v2 series [1].  That conversion
moves queue-local blkg topology synchronization from q->queue_lock to
q->blkcg_mutex, which is awkward while bios directly store queue-local
blkg references.

v1 made the stored bio association queue-independent by replacing bi_blkg
with bi_blkcg, but a bio-owned blkg reference still had to be recovered by
looking up the bio's blkcg and current request_queue.  Tao Cui reported that
cgroup removal deletes a dying blkg from the per-blkcg radix tree before a
throttled bio drops its reference.  A later lookup for that pinned blkg then
fails, triggers the warning in bio_pinned_blkg(), and leaks the reference.

v2 makes request_queue the authoritative lookup owner before converting the
bio association.  A queue-owned rhashtable, keyed by the blkcg CSS ID, keeps
dying blkgs discoverable until their references drain while q->blkg_list
remains available for ordered walks.  The bio conversion then stores and
pins the blkcg CSS, lazily creates a blkg only for users which need one, and
uses lookup-only access for completion and accounting paths which already
own a blkg reference.  Async bio punt state is finally moved from blkg to
blkcg so punting alone does not instantiate a queue-local blkg.

A git branch is available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/yukuai/linux.git/log/?h=block-7.3-blkg_list-rhashtable-v3

Changes since v2:

  - Drop the old patch 1 and send it separately as a bugfix for 7.3 and
    -stable, as suggested by Christoph Hellwig.
  - Rebase onto the latest for-7.3/block branch.
  - In the new patch 1, note that the remaining q->blkg_list walkers are
    cgroupfs/sysfs slow paths and can move to rhashtable iteration after
    the queue_lock-to-blkcg_mutex conversion.
  - In the new patch 1, explain the list_empty case in blkg_release(), and
    add an RCU lockdep assertion plus documentation that blkg_lookup_any()
    does not acquire a reference.

Changes since v1:

  - Add patch 1 to wait for every old blkg to leave q->blkg_list before a
    shared request_queue is rebound, instead of treating root_blkg == NULL
    as completion of asynchronous blkg teardown.
  - Add patch 2 to replace the per-blkcg radix tree and lookup hint with a
    request_queue rhashtable keyed by blkcg->css.id, as suggested by
    Christoph Hellwig.  Keep dying pinned blkgs in the hash until
    blkg_release() so bio-owned references remain discoverable.
  - Fold the v1 helper-only patch into patch 3, as suggested by Jan Kara and
    Christoph Hellwig, and make bio_blkcg() naturally return NULL for an
    unassociated bio.
  - Rework patch 3 so blkg_lookup_create() acquires the bio-owned reference,
    falls back to a live parent when creation or tryget fails, and updates
    bi_blkcg when the returned blkg belongs to an ancestor.
  - Make bio_blkg_lookup() lookup-only: it returns NULL unless BIO_BLKG_REF
    is already set.  Use bio_blkg() in the BFQ and IOCOST merge paths which
    may need to create a blkg, while keeping blk_cgroup_bio_start() and
    completion paths lookup-only.
  - Move CSS online-reference handling into
    bio_associate_blkcg_from_css(), including fallback to the root blkcg, so
    bio_associate_blkcg() does not take a redundant reference.
  - Keep the v1 async bio punt conversion as patch 4 and document that
    async_bio_lock protects async_bios.

Previous versions:
  v2: https://lore.kernel.org/r/20260811064744.1139446-1-yukuai@kernel.org
  v1: https://lore.kernel.org/r/20260804065313.2092022-1-yukuai@kernel.org

Related series:
  [1] RFC v2 blk-cgroup: protect blkgs with blkcg_mutex
      https://lore.kernel.org/r/20260724123037.3004560-1-yukuai@kernel.org

Yu Kuai (3):
  blk-cgroup: use a request_queue rhashtable for blkg lookup
  blk-cgroup: store blkcg in bio instead of blkg
  blk-cgroup: move async bio punt state to blkcg

 Documentation/admin-guide/cgroup-v2.rst |   2 +-
 block/bfq-cgroup.c                      |  16 +-
 block/bfq-iosched.c                     |  19 +-
 block/bio.c                             |  22 +-
 block/blk-cgroup-fc-appid.c             |  10 +-
 block/blk-cgroup.c                      | 339 ++++++++++++++----------
 block/blk-cgroup.h                      |  89 +++++--
 block/blk-core.c                        |   9 +-
 block/blk-crypto-fallback.c             |   2 +-
 block/blk-iocost.c                      |  12 +-
 block/blk-iolatency.c                   |  11 +-
 block/blk-ioprio.c                      |   2 +-
 block/blk-throttle.c                    |   2 +-
 block/blk-throttle.h                    |   2 +-
 drivers/md/bcache/request.c             |   2 +-
 drivers/md/dm.c                         |   2 +-
 drivers/md/md.c                         |   2 +-
 drivers/nvdimm/nd_virtio.c              |   2 +-
 fs/gfs2/lops.c                          |   3 +-
 include/linux/bio.h                     |  26 +-
 include/linux/blk_types.h               |   9 +-
 include/linux/blkdev.h                  |   2 +
 include/linux/writeback.h               |   2 +-
 mm/page_io.c                            |  13 +-
 24 files changed, 364 insertions(+), 236 deletions(-)

-- 
2.51.0

