Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F488C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8736A6B008C; Sun, 20 Sep 2026 05:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8247B6B0092; Sun, 20 Sep 2026 05:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713656B0093; Sun, 20 Sep 2026 05:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5346B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:24:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74464140394
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:24:06 +0000 (UTC)
X-FDA: 85233604092.10.4E01581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8DF3140004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:24:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RjGRP7gw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789896245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5Zw9rJKZMZuSI+1jUTLBTxzKxPkXx7fMF487IMc+57k=;
	b=zU6FmXMPw2qa2efVJbs9F0bKwFcSWrFNuW7WaYPxhf9DgbDA7+FGWa2kVg1Uxj3N0dEeHn
	PJyRpKq3Mcax1w9IgLvfDBXSsgmqJJ/5CBigyIsNlSF8bXbH6Wh0s0lcj5+B7MMocdekTW
	0/FikNy41uisYtIEbv8pe6/Mcp2ouxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789896245;
	b=4Cd1W6aNAuHtSALZ/R+jXdplC8M6KR6VwJZdNwUxTyQHJHpdyXc2ALeNrt3QLD7YgFGts3
	dG9ALi5mikuul4t+O7Ifre+JDmF/GJVIPqkOKqDJ1J5B1Vwj9yaaA3gcoXLrWcRNdZ7CII
	J5AUvKTLKVompN9cJv1ummGw0qc2xDE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RjGRP7gw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB4534180C;
	Sun, 20 Sep 2026 09:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA1B1F000FF;
	Sun, 20 Sep 2026 09:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789896243;
	bh=5Zw9rJKZMZuSI+1jUTLBTxzKxPkXx7fMF487IMc+57k=;
	h=From:To:Cc:Subject:Date;
	b=RjGRP7gw9J6P3KEqUaIB6cDxXJQhT8hzei8Jwh2Nn3InDNpo9Mho80D9CpQxhAVRK
	 aBhXNLlHPQyd5p8OwuBQl5Iqrm0/6w5/yYfvlQIGUEQtf7jxe/WRjimLserbyQntBH
	 TpxqEqB6k9BLGNGVl/gqE2RN+JqoOryIYV34aohaGRE/08b5kWBFErEa/nb8/oFK7u
	 Yxti2M6U7/nf8NyXNH1gxEb0rmt2pFWMxr+9p3Kfc/FFEDxjmiKtBYrOtK4pn2F7Sh
	 SzXiC4mt2ivvlO4ppZ0xGS/h8g7W7WplY1cCuGW6ztDxmtgwK1t+BJrwUfmJEY/fCA
	 0h34u9P82y+2A==
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
Subject: [PATCH v4 0/3] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Date: Sun, 20 Sep 2026 17:23:48 +0800
Message-ID: <20260920092351.2434283-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D8DF3140004
X-Stat-Signature: dqxhqjra6r718ac67k6g787ia4p7fwfb
X-HE-Tag: 1789896244-668893
X-HE-Meta: U2FsdGVkX1/TXZPB0M9+OHGu68gdnD55iUVXP0x/gF7SwkvBFDxD3C13l/2aHzVVo4pM183ZPnYuzvZjnRrmxbk4vIUfjvspaQDtlqjxnu15zkoxWBLNFyo3gdVTkcVkvJ9D78qnLtNXmGSqbg4oqjH79rmP2WMgZ/QuYHk67HPvVV/J6YN9VUTJoCGSD5kBi6Y0905kByG1ZBSQJKRwoi/cCdJ6SCahkHk0hGY6lbAmfbFZaeqzQ7UhzZbA6Oe6oE8m25ABxAv+Bgq9u9ttAhbBs8yGxSKX/cU63sb6DfhwReVz4z1WMuXeB8Y6QNCtQHPudGD5BXch4a7OcHwYA2U+VgKBZOLb6f6af1cKqkhB7kmsUVidYAuKs9xC7R5xs5DD6pCiay15szxC6FqIDpcep2vDNNFZEdK3Z3w2M9Ql3WTYN/3zPeoek0zhabGeR7v04YTb9TXyd6oPj505h2cwxNr1F+SOYtUTuou0FJjs76sHEtWPsWzceBvLuol8p4S+6Dnj+39zIG8+n8SgdrcH92CMYCU2bRQSOka7O/Fw3JshEQS/teo4g4iN1DB/wIKi9xplcfRcAqKQA1/YYl7TBd0WKpheXkPL9czVhtJYySJrGUtf0k8aU8BfzD24193CbTrOOfmw6eXN153g/QcLOtItYJrP1u1t46lDUkHhhn0xK/ZjR5dfjNjbTEzX+p4HXVBuqc+YI0y1wOcBDs28yEH0pN4/uPk4vi0Vr/e3/aqenyu27MNRxe12ZBv/QpvXXB6x4CAMb1ayVkFfvYuTW8BhEaG6iHcYLQcB+smfxOCj+JAYASiaIY7FO7x6pTNpxtu8JTwXDrrizJJUMQMbhkXpX0ZTRX9g5XsA/qX5uEXW73jShqFhWxgcg+AYhRV754yAG7BQSfUVGwMFzxgPbbJSty3XqAJvXOpD7UcT56yZKTKtaJ4zmIhI7g8ns938nyyOMPjXvCdctS0
 VAR44Slz
 jiU39CMrxN08IWIFSb2aWMfPiMu8eaIEjkmCUQVXxT+x+r8bzHsfGdj1wW4mOFZJ5cJA2+ROUKFrWVnjfqQfqhPKxUdGpbMdafPXCftiinE5tPt85tK91ZjlODhJegtDmT0aknnu1Prnv4Zvk2YgLMgWHbX+ZB1/q0XFPd8sbfOteB/vkTr2H0osqxmxRTvLG7FjCsJYMXp9iweLrQMt7TQ90IrDsKB11gbe9eOLiE5csPjtpskyvAjyrGjCWATuV8XH8dp0owmHRBKmkJBDg2GqS0f+XerlqZphG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

This is v4 of the preparatory series for the blkcg_mutex conversion
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

Changes since v3:

  - In patch 2, have blk_cgroup_bio_start() look up an online blkg under
    RCU and hold a temporary reference for accounting. 
  - In patch 2, dm may restore bi_flags without restoring that reference,
    instead of fix this problem in dm, drop the blkg pin after
    blk-throttle for bio-based drivers. This is safe because
    blk-throttle is the only policy and blkg is not longer needed.
  - Add Nilay Shroff's and Christoph Hellwig's Reviewed-by to patch 3.

Changes since v2:

  - Rebase onto the latest for-7.4/block branch.
  - In patch 2, release BIO_BLKG_REF after bio accounting and before
    entering a bio-based driver's ->submit_bio(), instead of filtering
    the flag in dm_bio_record(). Add Nilay Shroff's Reviewed-by.
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
  - v3: https://lore.kernel.org/r/20260918041744.1526924-1-yukuai@kernel.org
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
 block/blk-cgroup.c                      | 355 ++++++++++++++----------
 block/blk-cgroup.h                      |  93 +++++--
 block/blk-core.c                        |  17 +-
 block/blk-crypto-fallback.c             |   2 +-
 block/blk-iocost.c                      |  12 +-
 block/blk-iolatency.c                   |  11 +-
 block/blk-ioprio.c                      |   2 +-
 block/blk-throttle.c                    |   3 +-
 block/blk-throttle.h                    |   2 +-
 drivers/md/bcache/request.c             |   2 +-
 drivers/md/dm.c                         |   2 +-
 drivers/md/md.c                         |   2 +-
 fs/gfs2/lops.c                          |   3 +-
 include/linux/bio.h                     |  26 +-
 include/linux/blk_types.h               |   9 +-
 include/linux/blkdev.h                  |   2 +
 include/linux/writeback.h               |   2 +-
 mm/page_io.c                            |  12 +-
 24 files changed, 396 insertions(+), 234 deletions(-)


base-commit: 6aff7d30932eda1aa3e96364e73ec6fbcfbefe1a
-- 
2.51.0

