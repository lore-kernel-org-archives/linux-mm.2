Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9BCCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 04:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87E68E00A2; Thu, 18 Sep 2025 00:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39228E0093; Thu, 18 Sep 2025 00:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EBE8E00A2; Thu, 18 Sep 2025 00:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2EE08E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:13:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58904BB467
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:13:14 +0000 (UTC)
X-FDA: 83901051108.21.26A36FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9ADBD20008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:13:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ErSRjBVv;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758168792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ugfRz+SYZVLO+pTmu2m9V1YFjwxyOqDwXGlvNMswJ84=;
	b=jRfklglx3YkJNbs+XFrSx3e78wj7LYp1WwS3BNL3LsWOUPgeHUfrs4/BrBdwlkA7/X+DXI
	f5oIJyJIr4qhpUTDtTtl6joOlCrGMlv3nI7OAFfjUty2mvq7o67cEeQov8ZSxzYvw0shLz
	mCUZO5mGVvDZNs37HFev4FM6Feq/drI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ErSRjBVv;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758168792; a=rsa-sha256;
	cv=none;
	b=HSMOtNKjwgATx2uexBvnOyP8B5vlWOoNkw7k4PYsBQLsD5myMIctj0PoIJkkcnV4ITwOc8
	VpmNrHe340Cdt6tJOdUFDoFyGPRniYJVQ/xhgL22cRm/LoCeGcInYwPoKj3+wGdhG7hyt7
	nYq4HzDvMiMYAEFG3zfl5agN4mtFCJw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45658417EE;
	Thu, 18 Sep 2025 04:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEB8C4CEE7;
	Thu, 18 Sep 2025 04:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758168791;
	bh=W7Yj5+1o6KKMQC/tA+UpcbbG71xRxkrXyq2jA6xZEe8=;
	h=Date:From:To:Cc:Subject:From;
	b=ErSRjBVvxfZAW9IXBd47FcARzxb0fJHZzBM57kJEbVjPS9Zgw690tuQI3p5tAiFkk
	 9dgXH8ElJQcIhJBoSCToVRqOjEbLIiv+d49mbKuWF52CyxDDhtRBV0+6lP+SLO6aWn
	 /4v67jTsYSQ33omWwyqA4pDCVQsv6SbNG9tKTXQk=
Date: Wed, 17 Sep 2025 21:13:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [GIT PULL] hotfixes for 6.17-rc7
Message-Id: <20250917211310.da8771af4cb50be2e657fe6a@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9ADBD20008
X-Rspamd-Server: rspam05
X-Stat-Signature: hqccxrdzy36cozdqzm3mrn5rerw5d38h
X-Rspam-User: 
X-HE-Tag: 1758168792-704848
X-HE-Meta: U2FsdGVkX19uhOuvxdHVENeg5GFoozzJya7VUKV6CpDH6R17cYbBpasec2W+Gb6sXI+CfQauxq6HmK8CY30UBt/MN3d7Se/7KAXRXgODCd3uxe6mQw3etG9/Zx3rXOyUyoZmuRaeIf+BT8gvGuBlQtUpxbDqiseXwpAeU8JSw4a/CFpokATMQPHooNNV4eJPl3nDAyNbTPFGrXDX/itCwwKvnHX4IORYQqwwDGmpJicrB+JYyd+80o2vzHKXF6InnddaPA4klbvUOw/C7VNQd4KWrJEtMpMYTlvRT2nvRWPamLS+mjTyOrDtZDaPyFBHqAx/UI/DmStI7Ha/2nMLX0fqoBg4YUYsP34X8JlY0CK91jarjShZDW4kMlzY71DAJIaxgc/z8oEzw6mU5p1IvYPScurGb+IVBQfqGHrZ4ftECDZagU5UXG/YburWZWXZQIpw01yxtU/+6rNxE0G9WCGmnX8w53kQZmrobWjSLxIX7s0nVQdBB3JvzHDCgzgmj8GvhvcPHUgJtLX44rQAEAp+c7Lrz7UvjZMHTfJ+nqrDUssue3Y0JnrJLfp9GNWLokhNWlkaSUVBK1zv6vvaAr4XD98hfKF76gwLreGJlnpBUNHpsr19fGesbwYYea4lp4GccOmZyNsputY+ccCzKNdh4KCOTuuv7OXg4DnXIg6rUAz6K8EzwNri0TzQ1Ul839MZKomXw9uOdtzEVEqXCx3AXMJvJuRYLmFp00QwNWl95tIJw0siLEWEtwQUqTntsRAVK2P/0n8kU0kjOnaHwSpB5WysFBVPrR2ikLx3AaABnkfGul/ZQkJs59os0OOiEWdacTIejqsgp5nlQpSoVyWcUbWGVzir/9ZuJmfhi2NnBlG4IPLfybVutew6gxHdNXGV7D3HcqR1CfMnIDSDm2uoCxj4Ymfl6jJ2lru4aD3QZH3jbQ59RvWB0L4Qr2pisbd7B0BJC+AVmTs/kiq
 W0FidSDm
 bQi/mmChB4fuK/q5euLBa11VmlfVf2dQwaoyrkQ9arZdYytZuLYUzBvcjXwHxd4shygf3hSBJ4H2kJh2+LV1XE/RpFe3drajguqQd2gZOFllrasJ2mLMOChE6IYS5ySoCq7xVOAc451BwxUB90fiQzCqPWyvflMwfmvWGbl+uslf6K+moN24mr01BmqjtLjZvznz5jNUlnXullKL0aiampvFoTCPuV33/LDHKSLnVqS4LJ0LqZ5v8cot/dJHoj+MivJ0mSTAsDZ2qWmL9iVew3j8p1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit a68172d95c2845d2b5455b072b4ff51ba32650e9:

  MAINTAINERS: add tree entry to numa memblocks and emulation block (2025-09-08 23:45:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-17-21-10

for you to fetch changes up to ce4be9e4307c5a60701ff6e0cafa74caffdc54ce:

  zram: fix slot write race condition (2025-09-15 20:01:45 -0700)

----------------------------------------------------------------
15 hotfixes.  11 are cc:stable and the remainder address post-6.16 issues
or aren't considered necessary for -stable kernels.  13 of these fixes are
for MM.

The usual shower of singletons, plus

- A 5 patch series from Hugh which addresses various misbehaviors in
  get_user_pages()

- A 2 patch series from SeongJae which addresses a quite severe issue in
  DAMON

- A 3 patch series also from SeongJae which completes some fixes for a
  DAMON startup issue

----------------------------------------------------------------
Hugh Dickins (5):
      mm/gup: check ref_count instead of lru before migration
      mm/gup: local lru_add_drain() to avoid lru_add_drain_all()
      mm: revert "mm/gup: clear the LRU flag of a page before adding to LRU batch"
      mm: revert "mm: vmscan.c: fix OOM on swap stress test"
      mm: folio_may_be_lru_cached() unless folio_test_large()

Lance Yang (1):
      MAINTAINERS: add Lance Yang as a THP reviewer

Lorenzo Stoakes (1):
      MAINTAINERS: add Jann Horn as rmap reviewer

Nathan Chancellor (1):
      nilfs2: fix CFI failure when accessing /sys/fs/nilfs2/features/*

SeongJae Park (5):
      mm/damon/core: introduce damon_call_control->dealloc_on_cancel
      mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control
      samples/damon/wsse: avoid starting DAMON before initialization
      samples/damon/prcl: avoid starting DAMON before initialization
      samples/damon/mtier: avoid starting DAMON before initialization

Sergey Senozhatsky (1):
      zram: fix slot write race condition

 MAINTAINERS                   |  2 ++
 drivers/block/zram/zram_drv.c |  8 +++----
 fs/nilfs2/sysfs.c             |  4 ++--
 fs/nilfs2/sysfs.h             |  8 +++----
 include/linux/damon.h         |  2 ++
 include/linux/swap.h          | 10 +++++++++
 mm/damon/core.c               |  8 +++++--
 mm/damon/sysfs.c              | 23 +++++++++++++-------
 mm/gup.c                      | 14 +++++++++---
 mm/mlock.c                    |  6 +++---
 mm/swap.c                     | 50 ++++++++++++++++++++++---------------------
 mm/vmscan.c                   |  2 +-
 samples/damon/mtier.c         |  3 +++
 samples/damon/prcl.c          |  3 +++
 samples/damon/wsse.c          |  3 +++
 15 files changed, 94 insertions(+), 52 deletions(-)


