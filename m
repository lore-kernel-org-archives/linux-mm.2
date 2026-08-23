Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60FB3C5DF97
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 13:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331F16B0095; Sun, 23 Aug 2026 09:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB7A6B009B; Sun, 23 Aug 2026 09:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB016B009D; Sun, 23 Aug 2026 09:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA8B26B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 09:31:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 138351A0329
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:31:27 +0000 (UTC)
X-FDA: 85132621014.13.C8D42FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 91B5C140004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:31:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TV9Q5meh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787491885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zsSjjn7DLVrE+cmbB2WIsuyMJH7KSRD8XhZ3lqxHxTc=;
	b=ekmNu/ZtGzp0AA8tKjN9XF5U4Y6PHCOlbNfia2L71JGUI9/gheo5xjS+6cuLU5aBqj+eql
	6cZ8snB9knY71ibwalB41eETza8+IO4R9pJEzlryGteY+hIQEmjK940gtcUeSKffF23Y7s
	ffoScV0zwj2+PeURkXcHCrtrFRqIPBI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TV9Q5meh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787491885;
	b=ADiFLW0aBcKj7irRyck+ifKUS34UQqjEkvxcyxUuhnN6jhOP2fJNUexzUtYAqtzhJ5J2is
	jmuhBiN7/fKMwYDpeNPSdmGNLwo/XvHe5Jm2DDxQl8m/58JSlgDW7cnLRklCqbYvlXm+x1
	NIEwyuYpeHWPsa2TBNv42M9De9mP0aw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B38AD60008;
	Sun, 23 Aug 2026 13:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5E21F00A3E;
	Sun, 23 Aug 2026 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787491884;
	bh=zsSjjn7DLVrE+cmbB2WIsuyMJH7KSRD8XhZ3lqxHxTc=;
	h=From:To:Cc:Subject:Date;
	b=TV9Q5meh3pwHXqjStt1RaCQzxfSQ/sLyIC6aPeQbDgn8M+12n2iTRWIgCmgx4u/Cq
	 i6MfKXjSUVw3ny9D9Wt6xb2kveiUodxsZPgjrJf0bFj/hA3C+/CE9npDXJ9iPmJHYB
	 47gUnRlOotDIkz6qidAHuIIUGgooXOqUzMVV8xqKgGV7Grz7GhrQwFKyRdsttNV1oZ
	 DY05Oo7QYT+QlOjKCSl4VBvA1lRxrkUxc0mhWOcMgNGfEJK3z/HrU60Nn33qgSbgIv
	 nigBw1iTObQb89JTmWUVK2ziFz56GKSVqSCdnI8uzig2wuONiTvVc2+NJbGyjAr7xE
	 7XqOGKI2SqJ9g==
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
Subject: [PATCH 0/3] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Date: Sun, 23 Aug 2026 21:30:42 +0800
Message-ID: <20260823133045.970199-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: frffto6r41qjbg1orq9rq9mzesge1yjp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91B5C140004
X-HE-Tag: 1787491885-345846
X-HE-Meta: U2FsdGVkX1+iNNxrQX9nqhTXUU9cbtT1tpQbE4VtojVHenuJaY1yC0XBUvgP7VL1vGLKAsCDTZC6hdzasLFk5QILu2feYLcF8tmi72MkEIh0atK0TVsB3e0UKG0a0bo0zN3M0XgbV9eLaDWJ9W/v3ubv5SUN3JQYV13gtmpLewgjQxFUuXy0f1vsEHX7MzWjBQP5zE9KsnNAbkZgiNj1GLCETOMy+5xnGCFG6xxNYp/DuXQ2AfxOf+DT3s5ziqNJgO16alyTT4nIK7hD1Hv+0ak0quttz9xZf2uoClNwLHE+0t3VKNlAsTn8NjDWyonJDbHixeWR3wiY0vrolOF9GcnOW1aUpPjtVcdXfgXyIvr94CAiFWi070D3KD8IQ82TGqd8rHbFSlXkv2eiUIWRm7qq7+HUpDAkV2gCO6uCfHLwB+TLvDlZQVt9Mlv8o60+pQIktLTUEFYFvLZomeOm8u3sjUvaHTVNu10InXGLubYZdepktjY5G5juJ1C3P2f+VIhaVTqzaqMCfksTGDobvyWuv5/J2QMt2aPoFvbSleYIq0hTJZezV8E4Jq8enIdxmd4iBPD0bZBQW+oMGQSx+fMR6OOsjQixoQaCPJ9dmlZ5PGZfGPiUIga5trpRER0NYfJ8Lhri6WAvCYOiwvcdk7VpPWWFO+qw2whKNJ0+4dQziaAo7BRGvIvmDk0P1R89yKgOD/QJapdlXsW2g+ugqPNqAh4Fd+Ad5GVf2kSFKKpp0RfXoYvXxukb0h95ixq+p1/wizSyNz0sMCpwMoJp9P6wlZQ0HWflsRm0H6I3RYQ0gNKmhJiYocDrYxcs8CcTMR9AG6f84k/1mO9G3RgBld7OoRd6hJAVxnfvCsnNy+FOW1oCL66aGLV5RCJ2HZeuqeNdUnBXSsXLd6OooK8AauLOXdBr0Upu+1/fVayqjD2QFA1p/9CqeDJa3vet7yr1PzmOKd5oKDWfQfaOvVf
 JEm6Hl8Q
 Cy60pCbfwdWVolzrm66soaVIa7CGjAiL6m81kU2ddztUEFQNQs8u/+jrYMjs1CeKIowS3Z5a0NDo1/qOZfRBaOLM5wCfSEJ8xnP3l/w4E6wLxaCvR3W3QdI257C6HVw9oTGDiI7rmCIS6H097pVjjWYKCHW06Yh1PUDvC3lmrWqRTDZke9kjAqa25iob1r8FRWY2tyUsyRyX4WBpZSkWGVg8FYll3thnmBIdNXPZDSivm36yfxIgZLxjYPjB4wYEe4LV0b+S1mrObxHSJ4BMYd+4mvzKy1tiiWZiVVX/4cXCcBkrl2Dnw9I8cNgQx2Hog3GnZTa/Dbzi/jAIhPXrHaXuBBY9msCjykoDzNAc62SeSKBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

This is the first formal, non-RFC posting of the preparatory series for
the blkcg_mutex conversion proposed in the related blkcg_mutex RFC v2
series [1].  That conversion moves queue-local blkg topology
synchronization from q->queue_lock to q->blkcg_mutex, which is awkward
while bios directly store queue-local blkg references.

RFC v1 made the stored bio association queue-independent by replacing
bi_blkg with bi_blkcg, but a bio-owned blkg reference still had to be
recovered by looking up the bio's blkcg and current request_queue.  Tao Cui
reported that cgroup removal deletes a dying blkg from the per-blkcg radix
tree before a throttled bio drops its reference.  A later lookup for that
pinned blkg then fails, triggers the warning in bio_pinned_blkg(), and
leaks the reference.

RFC v2 makes request_queue the authoritative lookup owner before converting
the bio association.  A queue-owned rhashtable, keyed by the blkcg CSS ID,
keeps dying blkgs discoverable until their references drain while
q->blkg_list remains available for ordered walks.  The bio conversion then
stores and pins the blkcg CSS, lazily creates a blkg only for users which
need one, and uses lookup-only access for completion and accounting paths
which already own a blkg reference.  Async bio punt state is finally moved
from blkg to blkcg so punting alone does not instantiate a queue-local
blkg.

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
 block/bfq-cgroup.c                      |  16 +-
 block/bfq-iosched.c                     |  19 +-
 block/bio.c                             |  22 +-
 block/blk-cgroup-fc-appid.c             |  10 +-
 block/blk-cgroup.c                      | 339 ++++++++++++++----------
 block/blk-cgroup.h                      |  92 +++++--
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
 24 files changed, 366 insertions(+), 237 deletions(-)

-- 
2.51.0

