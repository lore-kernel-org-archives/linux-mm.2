Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA42C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EFFA6B0096; Sun, 28 Jun 2026 18:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2606B0098; Sun, 28 Jun 2026 18:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291196B009B; Sun, 28 Jun 2026 18:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC1846B0096
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:33:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5027B1C34C5
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:33:04 +0000 (UTC)
X-FDA: 84930773088.01.C78CF45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CFC59A0008
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:33:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782685982;
	b=li2bDG8OAwvgLRfUXKEMO0vEtygWZxYGRebJUuqL379g0+LD8APmsZe6xQaKZsnz4vflIh
	rFLe9utkkfzh3PrjaPn4PZCIeiIBpySA+glvPW6gfUjUFv5v8tBH9NB4gosnjKnLvyxJmE
	37TA4lBM3Kj9E0MWa0a6AcxERMDrZbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782685982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=OQpIqyExXWh8e5hgBdVo9I6agA2SaSybO9+XQLVFz/M=;
	b=mla1BuNYmvJGkoNUhUoP+/yzs1MUfULNY2QLJVrY/2u6byhhsTvSpTp4UycjA5u7cIgAHg
	u09/aywoRFLC+2+fXYVHvqPH5p1WXJbo7Kv3zFt70N3D3sDqhLkKJGBZvZk5PeB6bUjoJA
	hI1xB1Ab9R0km2uHZcJ2YRKDkRzkq9M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 105C2405B5;
	Sun, 28 Jun 2026 22:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA37E1F000E9;
	Sun, 28 Jun 2026 22:33:01 +0000 (UTC)
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: DAMON patches reposting plan
Date: Sun, 28 Jun 2026 15:32:50 -0700
Message-ID: <20260628223251.99886-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tp8ty683qbumockz5oih3astwz9x13od
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CFC59A0008
X-HE-Tag: 1782685982-120339
X-HE-Meta: U2FsdGVkX1+/G7Sr7NDsL5TaQGJ1rW4HdtpjDZN3JJdffbquK+ZiMRFZobIPaY8J/qdoxGAuLH6AigMgvNP1TdEaY73jZP2ofFb8QFG5h7+fAj4PcgjGZlpRgbSaBfawg2s6aAcxKEI3Mv4Ggb9heBOb9zCGwM1owSi6CTdEXhWPhypJ/0Ghwb+BYoR46zX0lwtWROXw575AeJXmAk7DEQiKVYYv4LM6lOZDHFLivZde0Cjeax96Vp+rvwleZpFsqw5VYeBur7TQMy1oBcw3rrE0eotyOVepk8Er4xO9lS5UgOyhmClu8Q1x5mohQ3LwXd1FUDI7r3LDEI2p5B6f1sYb1yRlU4vp6N69LoGDoL8kNXIL+3B3/TWEllKg2shI9B84pIxrGe3tqkkBBWCwchCCXm80KCkUVDpxZ07q+eMJTmPKmF/bTlQPejI5ExFIEAvg8vO5lMRH5GIuMrFWANBMySWssyQ6WLBJyhSziswcm0QIPP91LrND9urm7B//U9yEluHQ6nV91SFtsWHLx4PIlLyzW0HG7fHRzJmw4Cdiu2M55Np/QnVHHEYf4KYfhT6PQAALwjh1gxBhLipv96RAINKlbr6eQldxhAjdHNc5f5+jXKJb7e6JNvhClsEdvB50hJ/Jq9EfvlKzb5g4UPovVM+bUqkiGC6r/PNzCAupA7ABcE0aczAXlpfgZLlso+62jpgfz+v8hmjw/C9RpK/8qJD8MoR1kzxSJTLJjgORDWEkq7N0GrJDc3DQSqczxofCkd7TPZZL5Yu/RW6xIYE0FdrHpEdFSAy6sHDvyf9SfBnSLl+US7I7TBwlRFqjYXAGymkw4nxn2QCH1sL9GEag3xWXUSG+2oFsjFIrQ1N26kewPST01xNUuflkXLwIPO4KQcN4r59IyRSYjMMlXCz466jtHYi61LaoGfUOiXJpCZH0Pp2uyTXMU3mJqIzGV3QE0y1b6cvZSaHr86L
 Y0pncsjo
 JWsKp48voKkVQfIlXQ8HgiYXy7pX4o5Su72Rt+UeiUp6laxY7IZ+UCug9bDoqmvbxSpm8Fvj1wKAYtWVOtaVzPa/LiJB/Mcs3Zy5SY4fgcECZutcpY/aKsKNvjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


For the lst couple of weeks, I was queueing a few patches in my tree
(damon/next) that reviewed by me.  Those were intentionally not merged into
mm-new, for gathering our efforts on stabilizing changes in mm-new for 7.2-rc1.
Because 7.2-rc1 is released, I am planning to repost the queued patches.  Let
me share the rough plan.

Hotfix
======

There are 3 such (blocked for 7.2-rc1) hotfix series (19 patches in total) in
the queue.  I just posted those all.  The list of the series and links to the
mails are below:

- samples/damon: handle damon_{start,stop}() failures (6 patches)
  - https://lore.kernel.org/20260628215447.96166-1-sj@kernel.org
- mm/damon/sysfs: kobject_del() directories that users can create/remove
  (11 patches)
  - https://lore.kernel.org/20260628220121.97360-1-sj@kernel.org
- mm/damon: add kernel-doc comments for probes and rnd_state of damon_ctx
  (2 patches)
  - https://lore.kernel.org/20260628220808.98931-1-sj@kernel.org

Non-Hotfix
==========

There are 4 such (blocked for 7.2-rc1) series (9 patces in total) and 7 such
individual patches in the queue.  The list of patches is below.

- selftests/damon: misc fixes for test bugs (3 patches)
- selftests/damon: fix memcg_path staging handling (2 patches)
- selftests/damon: test kdamond refresh_ms (2 patches)
- non-series
  - mm/damon/core: use kvmalloc for target regions array
  - samples/damon/mtier: fail early if address range parameters are invalid
  - Docs/{admin-guide,mm}/damon: fix DAMON documentation details
  - mm/damon/core: reduce kernel stack usage
  - mm/damon/tests/core-kunit: add KUnit test for walk_control_obsolete behavior
  - mm/damon/stat: use secs_to_jiffies() instead of msecs_to_jiffies()
  - samples/damon: Fix typos in Kconfig help text
- mm/damon/core: detect internal variation above max_nr_regions/2 (2 patches)

I will post those starting from tomorrow.  The 7 individual patches will be
posted as one series.  Whether to post all at once or one by one would depend
on how quickly the hotfixes are merged, and how many new findings on the
reposted patches the reviewers and Sashiko will make.

If the plan needs some changes, please feel free to let me know.


Thanks,
SJ

