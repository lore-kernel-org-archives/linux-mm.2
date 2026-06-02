Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DC4CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D2C6B0496; Tue,  2 Jun 2026 00:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1142E6B0497; Tue,  2 Jun 2026 00:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051056B0499; Tue,  2 Jun 2026 00:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5DEF6B0496
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:05:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B5F01C01DE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:05:30 +0000 (UTC)
X-FDA: 84833633220.17.4355C02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D8AC2120008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:05:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sI5CfDVm;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780373129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LORZAgAR/uBAOert55Zjf1s2Z74JOa5LkLhOA3aVAQ4=;
	b=MtAeeEOFpz0J9Of0EmdEZNaEn+vYlGXFb+qDTlCS3sbu9qBmC2ENh5mDlwHN2HxWNCdIB6
	gLcVNEW8vPzOsioKxm6xCbr0cFPv0dwhZ8xiKZfJGMUEr6z0gQgJ5McnpU5mGO6o3drYdw
	m0AeqfWngIBeXG/IS44aEUjXY6wjnPk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sI5CfDVm;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780373129;
	b=DxCnhi+zP3uDN9zFmmG/o6MJjuBnJWq2pMnb2hkHuas3gmohUb39JYqw+zoI5H8k+aXWC9
	Vg6/iEqFN+f+BpDx8zSgxCc/Cotw98T4ZxGTi8TT4sTKBlOlDawnaj8BRXefH6VPOlnclh
	QpAWyNSE8VeKgyz4jQn2oFNGGkdDaYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FBF46001A;
	Tue,  2 Jun 2026 04:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56551F00893;
	Tue,  2 Jun 2026 04:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780373128;
	bh=LORZAgAR/uBAOert55Zjf1s2Z74JOa5LkLhOA3aVAQ4=;
	h=Date:From:To:Cc:Subject;
	b=sI5CfDVmV5CplfMAZAMZNdCrISuAnlpP8tkRa+TzlMDymEo5vIGfjTXSmzrHAwRyG
	 CxYGf6MgL750yONZoAUfDO+ElIkvjV7i3hDUCH4iBMf6iK/i8/ztkzJqsrDv9+FyII
	 hAyDW1R3aK2h1fIgbQFi5bO0IGZjd4ONRziprSmM=
Date: Mon, 1 Jun 2026 21:05:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc7
Message-Id: <20260601210527.ad1549849df4d9d58b12cffe@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: b9s9seb7y8wiwdxch956ua318bnaua9r
X-Rspamd-Queue-Id: D8AC2120008
X-HE-Tag: 1780373128-846991
X-HE-Meta: U2FsdGVkX1+SA6nwuSjjejeEt9R0ptvWGNRJFqQhIXDYash5M5uV/4uJ2MoC9a9+3rQIc44mOKIWMrQeYQdBTE5y1SknGWtMvSv5xjyQM7k0sbUiEjlnfUqWIE+fk/ndfk5qTXMdFoLL+k7UIbEipj3wzdWpfmTNgl20/P0pGgEcZSpjzjuvR51I+aKXpVDo4AhooddIZVHsD/GnrKOZ/r0UElL4tpOX7xSk0g47oKkEbABp+C0Yx1Wgc+jfAZamcB4YsU3AqpT9ZOJVIrxdaDV5LKTy8UKcIP4VHf2JwU570W+wOMmmN+43Qeb4D1nmKy7O+q4HnurNPVdJajKTVRkD4m38Q2N+8VOWpeBkdyELOjIVwkH0QquEXhT/GMZtedGn8Kl91RFPcTehncJOSKMp3Kq48gm3eWZvw4nL0Gt9WweTGEmdu7n+uxfiorzLxfSKfnQjYoN/z9rLLB51TsjJTBsjBB/velylYMhgB9rlXehLV0LE5a9NjNMHmp9L02I7lzENLGAcMNJEZ0JPw+NtsomWsisljs9UwX+WzukdRwIjYKwurt8YqQsnD3BtEM1to4kSRbJCMltMHQXzHUTUXmqe3exZsqFVfJGY2f/WlH5SNGIRT2dzeSTLCCX4AhDDYQVtGUg9072RYxSBq5Cw9cah+gIhg/vNxO4Od/o7sembtSc3x6AlxZcqE8C+7PxczH5s9y7yrRD/mM2iwg4yev7E923hlzVABJ2wGjdKzZjRuKNwHxndtNAq0oZpQfKp11kCXRXz59yjfeU4Hi33zriwlD7OU65ERr1vjevnJa3hwt/8q4tsnCPhg8qAIoVv8TVmjmL/jbLiyMqsczuAGpRImcipzE0IXK5t4YTtGLvIKcgUm03y6bB/u8QKdQdJVWMRUUhL0vHjIRxYgv1jNsWijLHirEGDoolZjI5p9Xd/4L40FpSuUP9y7dY4kCVMuxdf5wIl3NO6Q4L
 jcE6xY32
 jnp2plEIXF3hCGYlB2j0oFnTM+/0XPC1NAK1RvG6VyQhLHT15aGzTnGEJxb36EP1ZqGmhu2Kh7qFY4anXITYp/e0DNWjeeT7Ygn3alBQIc7r+dsTpHIeta5/NxgA/ZsdH6CF/biE0EEF2TpAibdQtHTaG76MPpWF3L8GcEhCOVq/KSf9r+o+bv8i2BA6IIAhGVaDXFojK+9YBcPAoLp3Z3Z9NoMVF1cjHHOrxTLTIkpWVbrnUU+Ub1obyABGJXjcDht5TetPi/xIOybM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.

The following changes since commit d60ec36cab338dfe2ae40d73e9c8d6c4af70d2b8:

  Merge tag 'mm-hotfixes-stable-2026-05-25-16-22' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-05-26 08:23:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-01-20-58

for you to fetch changes up to 9d7bea186ba5a002456471edf36cc9b69f809397:

  userfaultfd: remove redundant check in vm_uffd_ops() (2026-05-31 21:50:26 -0700)

----------------------------------------------------------------
13 hotfixes.  All are for MM.  10 are cc:stable and the remaining 3
address post-7.1 issues or aren't considered suitable for backporting.

There's a 3 patch series "userfaultfd: verify VMA state across UFFDIO_COPY
retry" from Mike Rapoport which fixes a few uffd things.  The rest are
singletons - please see the individual changelogs for details.

----------------------------------------------------------------
David Carlier (1):
      mm/hugetlb: restore reservation on error in hugetlb folio copy paths

Lorenzo Stoakes (1):
      mm/hugetlb: avoid false positive lockdep assertion

Mike Rapoport (Microsoft) (3):
      userfaultfd: verify VMA state across UFFDIO_COPY retry
      userfaultfd: refuse to __mfill_atomic_pte() for unsupported VMAs
      userfaultfd: remove redundant check in vm_uffd_ops()

Muchun Song (3):
      mm/cma_debug: fix invalid accesses for inactive CMA areas
      mm/cma: fix reserved page leak on activation failure
      mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback

SeongJae Park (1):
      mm/damon/ops-common: call folio_test_lru() after folio_get()

Shakeel Butt (1):
      memcg: use round-robin victim selection in refill_stock

Wupeng Ma (1):
      mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison

Yin Tirui (2):
      mm/huge_memory: update file PUD counter before folio_put()
      mm/huge_memory: update file PMD counter before folio_put()

 include/linux/hugetlb.h |  8 -----
 include/linux/mm.h      |  8 -----
 mm/cma.c                |  7 ++--
 mm/cma_debug.c          |  3 +-
 mm/damon/ops-common.c   |  4 +--
 mm/huge_memory.c        |  4 ++-
 mm/hugetlb.c            | 69 +++++++++++++++++++++----------------
 mm/hugetlb_vmemmap.c    | 36 +++++++++----------
 mm/memcontrol.c         |  5 ++-
 mm/memory-failure.c     | 19 +++++-----
 mm/userfaultfd.c        | 92 ++++++++++++++++++++++++++++++++++++++++++-------
 11 files changed, 162 insertions(+), 93 deletions(-)


