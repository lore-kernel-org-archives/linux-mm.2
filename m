Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1217CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAA9E6B008C; Sun,  7 Jun 2026 23:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B806B0092; Sun,  7 Jun 2026 23:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B992B6B0093; Sun,  7 Jun 2026 23:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA0A56B008C
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:42:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4763AC2DE7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:42:59 +0000 (UTC)
X-FDA: 84855349278.11.8CB32DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BFDACA0003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:42:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l79LEIS4;
	spf=pass (imf15.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780890177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kTfnsBWKWstk18ZI7HL6+/xILjAyO2gIFYcndqvX6qQ=;
	b=WVKypJlV2LQ8FBDsd2HYWbqRchgL9dN3CWt0m7ktK7gbJrz5LYTGCyA9AIIYTCHEipiFne
	jJwWg43eRA0uy9sd3w1HTqhjl3DetHJh2BhiiOZrJTUbNbC8tBebhUWvLbddKHiewThFet
	/GJEJqktLH20UsrD4rR4EVE+8I00oEo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l79LEIS4;
	spf=pass (imf15.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780890177;
	b=fYt1ATWvGIJH2M4g86w548YsKFm2OO36qYb4ifuTGnlhmkj5EWLyMKo4xTyso5ZBz0d8RQ
	B4TocjDzvu8FEhFMLE5gHLGpSUgdjg/GBiz/fqRdBg4AQQEOpR9vArfgtcNFo4N8FBW4k5
	OLcwK1DsdvT8W9iIPSb+ujEr2CFFbtc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3D0D42AF8;
	Mon,  8 Jun 2026 03:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F58A1F00893;
	Mon,  8 Jun 2026 03:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890176;
	bh=kTfnsBWKWstk18ZI7HL6+/xILjAyO2gIFYcndqvX6qQ=;
	h=From:To:Cc:Subject:Date;
	b=l79LEIS4XhbNdoLkkK3F0lXimfDS8dnD5BMItZVYJottxcS1M8KxguF1uQxNctd+B
	 tADht0NE86tZ1vit4SMnac6zRD9AE9aamVouDK2C/0VrLC6WH+xVe0jfG5kDChoVTN
	 Iaoq9WDdCAuGAAHCtWIV0DO9ziDyz1SfVsRTH5Rn55KdhuiO3Bocijgg5KhCk/S/ap
	 ZUPLcEexYFBjSVFZvMEHtRetNnNbLAvK7ILzXYuc9czKHTVXgVYxI0Ab+kVf8n/8fe
	 Jk+oYHurZxt5mSXeh/bsihd34n3nIpuWd1x2FtDoeVw44z8nIlTMw+uyY2wV9dU6NF
	 lb0ZokElT9e9g==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/8] blk-cgroup: remove queue_lock nesting from blkcg paths
Date: Mon,  8 Jun 2026 11:42:41 +0800
Message-ID: <cover.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BFDACA0003
X-Stat-Signature: z57r79qsssifnyibq7ytcngjfnb4qjb9
X-Rspam-User: 
X-HE-Tag: 1780890177-309374
X-HE-Meta: U2FsdGVkX1/2SThfoboeJEri5N+A87Au7al7jGmaHqWYLG5MIWflrDbq8uF0qqXe8/LCN7UwhepkV8x76F8lEI8KcdHBMJxyASTCAcGV75YrbztihzT4uSMSBIM7WJHtTQU8UFdmMFL0D5Tc1Ca3DdZU8hNSbFKfysl9fJc934iFgZJwQ3m2li0wGLYEhvT68Vgy262zeefQuwj6106Q+DbYQ56v5YJvU6/gCwsZ/O32TcltTZweZ5Q4IXXAYfPLSuPGIhRYCt4TnQxibnowDnirxmGv8grwMfkKU8TiucUbyOI33f2eaeMyffbEu2aWJ+nrOLemhEVWWo1DfmB+GQjHgQ2wo0gpaXGPKYQMdqtfDtQIbK6bGFxcsn55emnt3mXLYG/Oe93uQgSedwbO+f3SCL8ByHDpBHR2nJs+YLNfPoW5DsLtBkoEo2h2z2AsjItOKD/O4DKLfAHA3Gw2lesAK3+d6HrzMtFm3fim+xupQHpnNiD8ImSuXGbHXbKZMeUlWoT7xeq9Z7vHRXiZqA90kPumroORAKT90WBJKV4g2m1C2Lu6AQm6aTrQEWWsE18+Vs9cBOAVf36+kvB7sPm3yPJYCWX1r1R2NubQeweuScbSngoeo4qdMQ+eePpkZBa9m64WdQ5pAMa0ySIy3Pd1SEmJqt9cQ5WOapKTaQyUOcAezBO0sgWTI0ElvUMR+vOhGOn8g+lttfgaHwqYavAxM2TvhmwS5T00Vqudi9NSVET5JceiG83frTlc9NT1raewglEOAUhWxPuuvL/GFA14OIyXpSGr6v2RgNys2NWY8z8Pl3xPGmpxiUhKPB8k0DzDTF25uPqeYAqDPjpWhiC+VDtnd6hxLB9uHEHxZJ6HIDrFsi758VOIkw5R8nrc+e8gNa/Rl20fZ2Pf5sfuWIHFE1ljSHfJ3RqIALcDTZeIUHqoZA2loTjDER+aYs2xMzR7n0c9MV8m/ejZ1+r
 KEh2TbAB
 svNam0BaE1+hlbePRnQhnr7ob5agTprGtI+Vv/Gxrss73iakOn0JqDp9s2VCaQ42HDCq8Z7e8heG3xUSv6sXuqi8s96fmVFZoIOgeDCM7tDfU29B8qug6IemLXoHeGaYC6R+RWPHr5iv9Og5SqsW4ahZ4jKCCjqSBuSZhPf4KoYILUkl+nvXe+bHdHssWnjs3D39/PYMoX/QBnW93n97C2sx2UqpS5V1MjsqMdoZft8SVtecD75itUOJ8Ooj0bnpL/hqrzaobp5fw66kOmeF1Fb53aUz6HwzpoWs6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

Hi,

This series is the follow-up blk-cgroup locking cleanup on top of the
earlier blkg-list protection fixes, and prepares blk-cgroup to stop using
q->queue_lock as the global blkg lifetime/iteration lock.

The current queue_lock based protection is hard to maintain because
queue_lock is used from hardirq and softirq completion paths, while some
blkcg cgroup file paths also need to iterate blkgs, print policy data, or
create blkgs from RCU-protected contexts.  This series first tightens the
blkcg-side lifetime rules:

- blkcg_print_stat() iterates blkgs under blkcg->lock with IRQs disabled.
- policy data freeing is delayed past an RCU grace period.
- blkcg_print_blkgs(), blkg lookup/create, bio association, page-IO
  association, blkg destruction, and BFQ initialization stop nesting
  queue_lock under RCU or blkcg->lock.

Using blkcg->lock and RCU for blkcg-owned lists/data keeps the lock order
local to blk-cgroup and avoids extending queue_lock into cgroup file
iteration paths.  It also makes the subsequent conversion to q->blkcg_mutex
possible without carrying forward queue_lock's interrupt-context
constraints.

Yu Kuai (8):
  blk-cgroup: protect iterating blkgs with blkcg->lock in
    blkcg_print_stat()
  blk-cgroup: delay freeing policy data after rcu grace period
  blk-cgroup: don't nest queue_lock under rcu in blkcg_print_blkgs()
  blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()
  blk-cgroup: don't nest queue_lock under rcu in bio_associate_blkg()
  blk-cgroup: don't nest queue_lock under blkcg->lock in
    blkcg_destroy_blkgs()
  mm/page_io: don't nest queue_lock under rcu in
    bio_associate_blkg_from_page()
  block, bfq: don't grab queue_lock to initialize bfq

 block/bfq-cgroup.c        |  17 ++++-
 block/bfq-iosched.c       |   5 --
 block/blk-cgroup-rwstat.c |  15 ++--
 block/blk-cgroup.c        | 151 ++++++++++++++++++++++----------------
 block/blk-cgroup.h        |   8 +-
 block/blk-iocost.c        |  22 ++++--
 block/blk-iolatency.c     |  10 ++-
 block/blk-throttle.c      |  13 +++-
 mm/page_io.c              |   7 +-
 9 files changed, 158 insertions(+), 90 deletions(-)


base-commit: b23df513de562739af61fa61ba80ef5e8059a636
-- 
2.51.0

