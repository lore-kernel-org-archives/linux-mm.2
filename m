Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41FCC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 06:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B989A6B0088; Sun, 13 Sep 2026 02:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49FF6B008C; Sun, 13 Sep 2026 02:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39A96B0092; Sun, 13 Sep 2026 02:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71F1E6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 02:55:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 468FB1605E1
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:54:59 +0000 (UTC)
X-FDA: 85207826718.16.240601C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AE3B6140007
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:54:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+v92v1A;
	spf=pass (imf26.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789282497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W2MbFsUx54LJK7U3V6vP7eUNrI9U/R36OrB0aVm9oyE=;
	b=NYQcAJTpFmT8BXsytLSODeh3/7VyqR2jfhEr+dcqMUdmqLL4vegENuIgVdiToGWvtEEUjd
	QKrnaHM1SO20Et/T15UP2Bix/3+IcWfhifuA1y89xytD23zyVXAAMyMASmeoEsuOXiSLCz
	C3nVisUhIJ4Sbh9qYuFEurXgiyRWRq8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789282497;
	b=BQMKWela88fs8qWROwHaneEbwiHIr1EL/Z/NndvlzZ0eGh/UxdP8WwAIS3uRJgm4eK3fY5
	Z3Lsc5K/l7D6it/PKBU5YhyjC+qwWW2STBRSm5SST8RZiVajXcKXkLQsxo1OToUMxwsH2Y
	F0iHUoqL4b0vQX6kNq7mCiEUCFWmxRs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+v92v1A;
	spf=pass (imf26.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A99B360AB1;
	Sun, 13 Sep 2026 06:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EFF1F000FF;
	Sun, 13 Sep 2026 06:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789282496;
	bh=W2MbFsUx54LJK7U3V6vP7eUNrI9U/R36OrB0aVm9oyE=;
	h=From:To:Cc:Subject:Date;
	b=L+v92v1A2R6bqo+k2ns+Apd0XuZhfJJRlDhcZRxfgYZBR6lBTySlcGwphZl9esPqc
	 6OapuqhkUgrZB5XbpeiKFE4FWmpX3fDYqnAWZ+Z5cik38+LKv17eC95gI/dBBW2maI
	 QBtXzwx4Css+3kO8rrA5dxC6eWTTYjMJfj2lSIDJyX9WPH8eOB6Ln0exJvX33oYTJO
	 CHj1Orsj3SZQz9ZomQddwDmGJoNO6y1P+zQ5V26DW3JHaWShU5qKy+zKNWu1trppZH
	 XR4Bt0VV/FOH6OlQ1i8WQIXtA16nKQJtDvrM9pq+m+RFhwSgcAcBzQIdBMkDJt9hP/
	 ktPD12L2uaUcA==
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
Subject: [PATCH v2 0/3] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Date: Sun, 13 Sep 2026 14:54:37 +0800
Message-ID: <cover.1789237876.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8cdxw6mjdfh9fentop91e9t8hsjgdcfe
X-Rspamd-Queue-Id: AE3B6140007
X-HE-Tag: 1789282497-187125
X-HE-Meta: U2FsdGVkX1/0dmt/CVE5Wg18vmp8/oMAi9jZcXVh/x526i1Y0kVIrz3zXlrvb/JGqEAjcF53kwlTdF+eGmsY++07ctUzZxCcnQ2yxxNwzHp7uAsD/ZR2Urk6/KleaQ96DXtLgzIk/G/Ex/zSROWoIx/iUmMayZEaa3R/B1t1BVd+P+LLoyv7mGDPuuZY6JrEmXhIsnTyKHO+6wH5CculalY8qkXSnxMagfmx9Q090z9S/XdrVPRkxja/RBcix3ujyulEztAMSTmXcsZePTDhwC+u/3VWWRZgHger/o9rmOzkd/KQyqy8ZbGpShozwfzJ3nVvStXKKUjPhS79h8KKskhh1NibVf0Paya+FE91gj7o8hGB5JcNTOkE7g2ArcYbx1NDO2Yp8hh631QUHnRabBd4qbICZigAhZh0rc5o/2koTugyKgXKkdS1xAdTp3EMqMSTPScvkN2rDjlDP0si6qsdO56PQ5lDJYAtDhXE3Eo3w0WPo1y/hijSMzvxuRoWZ6taskZThZXjRkaLxG1O2NyN6t70q6Zh1hAOCCBykWKSjregs7e7tAGCcJ1ZJWRRu3aEfG2UpSRyF123Cnkgt5aRA9ZAtGwyvGb4UbCczhC0RV2JxVp0nTiEhR2KqLMYLD5sveN2vOkXbue+sCbqw3j+UKG97OE90gEcR7ivnGqp2Fq5wzHRoRQW04DpYw+/za2iEGt4n4YBMBzG40LFn3a5uD7KMII/RY19bk5FYFygtBW074Tl/P3omKD9mjhxVEenEGKUK26cbQMINd5tz708CT4O42r3bjzmOG0Ay64+TWe2D/t1ol9Q4bAXPVEBOk8m+xsHgtwbFRa25P+UfJeppU5C59bdsiWc6rCpXifCO1Om1rpDi0LKJ3hVDg2aBcJoAG1XF/vy8t0Vt14Aa5aS2X3LEBTEbbNOwdStnmtk/go5norikOXRDzsz1dFSBW15V71SnFN38yHLIY+
 z/a+RuUd
 a6ho8Im7xq9VV2A9qQit55zNDCivHhGkk0Sc9WFr9gG2VgVNlgdGww7dwLElFzt0BeRnRqs5Qh8ADRcq4g7l4/bILjiHjfRm5k2Ozs9j6aNtTX7peqDluE39DNV7H/KN4wddsV7jg+PnNGogsgNAYFh6K6FT3Hzf+sWUGQvZXEv+LjlCTDF/EAvmnYipJUEUHNXyUdMIHigoK1PSbDCOnY18snds7SuJOZIEnx1Y3oc8cfwV5NM+KYAtMQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

This is v2 of the preparatory series for the blkcg_mutex conversion
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
  - Fold the v1 helper-only patch into patch 3, as suggested by Jan Kara and
    Christoph Hellwig, and make bio_blkcg() naturally return NULL for an
    unassociated bio.
  - Rework patch 3 so blkg_lookup_create() acquires the bio-owned reference,
    falls back to a live parent when creation or tryget fails, and updates
    bi_blkcg when the returned blkg belongs to an ancestor.
  - Make bio_blkg_lookup() lookup-only: it returns NULL unless BIO_BLKG_REF
    is already set. Use bio_blkg() in the BFQ and IOCOST merge paths which
    may need to create a blkg, while keeping blk_cgroup_bio_start() and
    completion paths lookup-only.
  - Move CSS online-reference handling into
    bio_associate_blkcg_from_css(), including fallback to the root blkcg, so
    bio_associate_blkcg() does not take a redundant reference.
  - Keep the v1 async bio punt conversion as patch 4 and document that
    async_bio_lock protects async_bios.

Previous versions:
  v1: https://lore.kernel.org/r/20260823133045.970199-1-yukuai@kernel.org
  RFC v3: https://lore.kernel.org/r/20260818070641.756747-1-yukuai@kernel.org
  RFC v2: https://lore.kernel.org/r/20260811064744.1139446-1-yukuai@kernel.org
  RFC v1: https://lore.kernel.org/r/20260804065313.2092022-1-yukuai@kernel.org

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
 block/blk-cgroup.c                      | 358 ++++++++++++++----------
 block/blk-cgroup.h                      |  93 ++++--
 block/blk-core.c                        |   9 +-
 block/blk-crypto-fallback.c             |   2 +-
 block/blk-iocost.c                      |  12 +-
 block/blk-iolatency.c                   |  11 +-
 block/blk-ioprio.c                      |   2 +-
 block/blk-throttle.c                    |   3 +-
 block/blk-throttle.h                    |   2 +-
 drivers/md/bcache/request.c             |   2 +-
 drivers/md/dm-bio-record.h              |   3 +-
 drivers/md/dm.c                         |   2 +-
 drivers/md/md.c                         |   2 +-
 fs/gfs2/lops.c                          |   3 +-
 include/linux/bio.h                     |  26 +-
 include/linux/blk_types.h               |   9 +-
 include/linux/blkdev.h                  |   2 +
 include/linux/writeback.h               |   2 +-
 mm/page_io.c                            |  12 +-
 25 files changed, 391 insertions(+), 237 deletions(-)


base-commit: fc34aff88b3bd22146745c75cff0abb3c067cf42
-- 
2.51.0

