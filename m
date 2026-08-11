Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163D5C5B569
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22EFE6B008A; Tue, 11 Aug 2026 02:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFB96B008C; Tue, 11 Aug 2026 02:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE976B0092; Tue, 11 Aug 2026 02:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D09536B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:50:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 685524036E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:50:16 +0000 (UTC)
X-FDA: 85088064432.07.1A26543
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D4F901C0016
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:50:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aErKRRUF;
	spf=pass (imf20.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786431014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RtXw0gsHMIHOvQ4ed7zbppcLy8ZndSN6FNy5Y5u9i0E=;
	b=PDAyshmMBNfsvYjr7ckQw5SxYroKCRPV0F6nU8uL8TcGVzsSh9OASPEuTD/cjFzQzuc85f
	hbMvEceFSZJrn5tekBZ8Tl890hSVTsMDqRtbwkWYTW4C4e/PMaSosnW/2q2d0knbYscair
	dSJ2TSlvjjqI2Ccbp7hj1PI/YWLIrP4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aErKRRUF;
	spf=pass (imf20.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786431014;
	b=tsdlXrOLQz9xD0w6UCIWgcfYaEnC6XjQRKtEJeIey0et/WPAigRbtq9UNeAiMrnueUTR8F
	Vu5KjzJkLw3DU8HTTK/YNlGlVJbnx1oTbalLK0ccnFx1UDwuyshR7I7RS4spAA4hsoW5qw
	dn07O49jgZcPryL+3235EwaTEhk2edQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EFC16001D;
	Tue, 11 Aug 2026 06:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5944A1F000E9;
	Tue, 11 Aug 2026 06:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786431014;
	bh=RtXw0gsHMIHOvQ4ed7zbppcLy8ZndSN6FNy5Y5u9i0E=;
	h=From:To:Cc:Subject:Date;
	b=aErKRRUFLGCF/LqHhp9yqSimSU/tU8Sj9mgDK2L1aPG63Fg+sLft3yksx2gHSiwQT
	 jPn+Vq3SmxqDq6PNd4MNjrDlQcsKMv5zkNwhLQO3VRAfu950cmCfLnuxwKrz2Tbdp+
	 lRKIsBUisIPnYPY4PR68NWqNUAe66JGUai7RLdf9XZvT0KxSsXVjrTosYDu6Ah3ivj
	 Bt6ZJ/tX6J4Wbm3KYITy3n3X1nuFcyNs9qKIzv5Ew3eErUwPARkJfnOkmwGuQAOXGM
	 nrLniOLXIVS1fTQM9YcZUYZFM8di/RV9vIJFlAzwf3D455P2rC9JK0B7Z2K/WL2NiO
	 K+8phmSNuYSFw==
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
Subject: [RFC PATCH v2 0/4] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Date: Tue, 11 Aug 2026 14:47:40 +0800
Message-ID: <20260811064744.1139446-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nne5au9h3kom1sjng4rpe6je3gmf5s65
X-Rspamd-Queue-Id: D4F901C0016
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786431014-812396
X-HE-Meta: U2FsdGVkX185Q8btd7eT20K27GTGeOnAhrfybcrHvnUcAWi+wtvFkDvdXp8hmI3Tfedg4hClgVrLnbPwgAvpI69f8L5fnAVkIeTRR/tuVjl+caFJ7T0oi/Nw4tC8nGlqrPmWR+vw8ne+iKi6X83AZl4T104EdmaKWQDu2Z3lks1TQmC3wW6HbM4YLeO3nXF3AOHmLYPlj+vSGaJCIA2jLLii3qrrzHWPETfftGYyj7NBeGX2ZNShwXttlZC4Dr5VsnGYRPx3ztWyaBZcXvKF3OLGO/ku2t4MbSvGuyAS8KcRIB5LBePyRzwmnpYXJP87eMoeajTXZzRo9dkJ67saomNDB132psGlSEYLv9PLLo1hOQWCpbIQAW/y503eCJSCPhH8Y3iMEerUtXgIjQLPpfbYlN9jdQVPNLoJOtrsM6n9N9asAIzCG2iPrtTZgEscqD47V9gVZB7nR4KmFwsgpj+7RLBwO5LWjUKdoxivQO+dOg+XYaZs3JQtG4tKxj0SjwGgTkYBEweUPmr6xp/MhAw17ABF3LFvO21aZzwmWbtKlpLz1aCTQtMJfmwMLMCu+SPRRy6rVRkKN8Aklf2Nis64N6/zsd7a3WxeeZ9LayD8Z+qcfG+ahiE8LiwdLmzqTynq2eSST3hHfUJieJBcPDVnVvO9Vxp1Lk0jXFoyzBG/5PR3Q1HiGeVDIBF7X5ZXVI0ugUr/r6QLJbIfB64d+fJilVG2YzA57a1MG6Qo/fKy2tbW45LlEeabKLB9lk7JuxMEhievktXDjbyCofoadhzSekVVy2ktwVSkvKh66S3x4ikf0LNuRhPe+c3TA/0aRzDJLgPlxIo0qfPjOMyb/RnEuBHzfZQekEPbbUXbdlLkNVNWPlvn7QCc2gpQx8GxTrphOigRCLFMWHjilaiFI+VhsRffnK+RgDVdIPlDLj1KmmFmE4sv7TddMr7FcCnLFEq6UapmAywpg+gTD0u
 xt8HN8mK
 GFpEllswnzalME/lYf85KkJkb1hnznfsh0UoQPLq4Tl8/dZsS03ywQlcyiwaQvR/8561Xa1YvU3nN6uIrRn4sEQZzpZerUND5937Iw88hTuDn7+1vJIzCPBrTGXg6e/0gAElaaySAiU6xwzxKCvR3iwxkljOJUl2t20MVYBw4sZ9WnmyJ/DUe2vtHNvif963BijXSG1SgwULDJWoMak26BAXaZ4+EkJX5awnAiX02E/6Efz5GzQomyeyL8qc+xUMQLNgl88i0uUD8k4YrIH1oR4STg+VE2sUbGSfPLDE3L0MtVd5vWikTWDibIP++47tJJv/BmBczpihuOOeKy9SfrEOfM5EMpbOm8uF3e6/8o91umds=
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
  v1: https://lore.kernel.org/r/20260804065313.2092022-1-yukuai@kernel.org

Related series:
  [1] RFC v2 blk-cgroup: protect blkgs with blkcg_mutex
      https://lore.kernel.org/r/20260724123037.3004560-1-yukuai@kernel.org

Yu Kuai (4):
  blk-cgroup: wait for old blkgs to leave queue before disk rebind
  blk-cgroup: use a request_queue rhashtable for blkg lookup
  blk-cgroup: store blkcg in bio instead of blkg
  blk-cgroup: move async bio punt state to blkcg

 Documentation/admin-guide/cgroup-v2.rst |   2 +-
 block/bfq-cgroup.c                      |  16 +-
 block/bfq-iosched.c                     |  19 +-
 block/bio.c                             |  22 +-
 block/blk-cgroup-fc-appid.c             |  10 +-
 block/blk-cgroup.c                      | 348 ++++++++++++++----------
 block/blk-cgroup.h                      |  82 ++++--
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
 24 files changed, 357 insertions(+), 245 deletions(-)


base-commit: f2690679ecf3a3151688ebef766dd2512ff95854
-- 
2.51.0

