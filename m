Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA15CA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 03:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118F88E0001; Wed, 10 Sep 2025 23:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA7E6B000E; Wed, 10 Sep 2025 23:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21668E0001; Wed, 10 Sep 2025 23:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD1F46B000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:02:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A73F58B04
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:02:54 +0000 (UTC)
X-FDA: 83875472268.18.B2E2770
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C109F20008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:02:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NBM/i83s";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757559773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q5WKJ6+LxdzQdEw2Gbqr0R8p6gzFZH63Cclt5ooL3Z4=;
	b=oMKFZcKGqW7X7oBnE0Ow1FiuftZnGQFlrhLA69JCshBhx9bVG716y9oAhhjsWwGw+1NFlk
	wyMO+lfaFMt/s13jSuQcO47r9J4cNNbb5WdCCjbXGUo/0/vPDxUNXUksN87+S+ktxLXLO7
	PmtFOZxlns43DhJPenuE2Rrrwpqmu44=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NBM/i83s";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757559773; a=rsa-sha256;
	cv=none;
	b=tHvyCUDzokIrVwWNW+QCA46FosjwOouu93/dZuYxvPnZF85IRUT1Op06qSL+b8/YaMg5oR
	42MMxjaXrabVV58h1ECBJ72MWrjNU9mEILTcUWGe87JnXxCVbRAgu2t1HqTA7B6RzbokLG
	0WvhFtgmnbJkn0DHb8y6lQNWxV7NkYk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9930941AA5;
	Thu, 11 Sep 2025 03:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43332C4CEEB;
	Thu, 11 Sep 2025 03:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757559771;
	bh=LaA/VWmGiLwdH1UFM3vge6MrAkXvw9+Tei3RlIykXfY=;
	h=Date:From:To:Cc:Subject:From;
	b=NBM/i83sCLCRdTKnOz7AOrvq1vtPk5ndjiixThdhabcRdtLf4QwKK+7OgeZLFF0oF
	 c3sJncrmw60CBlvngEowyiRC1G0LCAUOFGwoWk31rby6GKm82KhKRw1qjzw9DXFpb1
	 1uurkySbAvpOs5GDsV7D0gOUNaYAVATofdnsGCQ0=
Date: Wed, 10 Sep 2025 20:02:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.17-rc6
Message-Id: <20250910200250.b110da062c9561aa092c479f@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C109F20008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ndojuitupxcz39fsn3fi1u779t4bohae
X-HE-Tag: 1757559772-801661
X-HE-Meta: U2FsdGVkX1+ypQ9X4skCjY0gprfLCerBRqS2qy8bk/ntxxpcvpevbJLo44iC9JGPS4FfQKWFcJB2j0zPjg6Nk0nOL9pAPUhzWCGZBIpj0K5lwhaeMbiIuUBYIjdK/4+OaGDplTscb5RLwJ1Ieh6C72ZmeQCW6UFsw2GVCjWHokkpoJilPPk5/w5bICkdbJIn6fTWudTUbZpWT7XfT43YswT8qhmxetbv2iI5PVwSyqFMHj45hmkGRfED/8RX4ARqd2oYci+LCBGfGg2xXNPa6epsU68E/vKJJNjlEjH/HsF2jNXQn9iymsneU6FC7wBjzQT4lF1/pEqO007mgjcp9Sdk/eH93RKAuBTOGP3fffk4jB7aYp3gscZB0tGH6CFnJqeWd8mZmZy9CYVVdRn+znrmL4pgbUcl836Jza5na/JCVjLirERn4dzmOf53aQjTo0yAsfQOrTpJzSlKpr8Pc39ucQSUyEeo0III8avGcs769yXcrlhIC03jjCeGnzqlkHSaaxlL+Dh1ev6QW3yaLtUCTtFDG+fUk7Wj0DbSjWJuTiEhm57ofDrPLUW6kwRy8F4svmKt0Rqf6+ESJ8E5TD2b3coDjlWGWWc0QHz/sPv7jQ5TE6JeVh0Z7SmMKn4geP2XlkbdvD+ZOhdOOBMff7vF8i/8oYVH3Lo7dO+xxSO80/QNJE8Q5aqIOCa3SyZbANARjangC7cUnuJmUhZyI3JmdNqtsP+IXo5zVbqjB9VzGtrTTJHOEOPYyRIpMPkMVE5NH3R1wNQfP8IyHVQXzIoh6eQAjs5+2BVv5roKDVbgJY6GkNfDb5bKXmSjwBPEb/4GL63LDGKfbWQk5t0rK+lAE54p9Z0rWEmYEXIImQ5EcA0UU1wA1V4ScBkY+bI4JuC8LqAycibJwqihZgmJVHtqdRvyQBtrwVLa5s7AJog+juLM8d5K0y1dS6EyTkilGF6IXACbTfvvhiz5lYw
 1zU/+d+Z
 9rCBvTs6D9Dji+gx3G6EfHnHygRkivVcMzx1kpkW8g8Po4ouKKMqP68MIAO2MbZIEcR8TfM/CCMsRaDPAZofDXdoE3zBhoRw2XEwv2DDsRmIccVkN2OaV1As65fmsUyXn6PBXmQ98E6GnZkVJVsBaOOyZ/vuv+1af3I0HcOaM0sgjw9ORyv73dzUhZI8jkroB1lg2C5IS80rU0Ypxe1Jgmrn6FZN3aUmZW9o+3wpc9GcqBGh6f/VnwH2UkEm6z8/wiIheNnshUusurMM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit e6b9dce0aeeb91dfc0974ab87f02454e24566182:

  Merge tag 'sound-6.17-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2025-09-02 13:38:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-10-20-00

for you to fetch changes up to a68172d95c2845d2b5455b072b4ff51ba32650e9:

  MAINTAINERS: add tree entry to numa memblocks and emulation block (2025-09-08 23:45:12 -0700)

----------------------------------------------------------------
20 hotfixes.  15 are cc:stable and the remainder address post-6.16 issues
or aren't considered necessary for -stable kernels.  14 of these fixes are
for MM.

This includes

- a 3-patch kexec series from Breno that fixes a recently introduced
  use-uninitialized bug,

- e 2-patch DAMON series from Quanmin Yan that avoids div-by-zero
  crashes which can occur if the operator uses poorly-chosen insmod
  parameters.

----------------------------------------------------------------
Breno Leitao (3):
      arm64: kexec: initialize kexec_buf struct in load_other_segments()
      riscv: kexec: initialize kexec_buf struct
      s390: kexec: initialize kexec_buf struct

Carlos Llamas (1):
      mm/mremap: fix regression in vrm->new_addr check

Jeongjun Park (1):
      mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()

Jinjiang Tu (1):
      mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()

Kyle Meyer (1):
      mm/memory-failure: fix redundant updates for already poisoned pages

Mark Tinguely (1):
      ocfs2: fix recursive semaphore deadlock in fiemap call

Miaohe Lin (1):
      mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory

Mike Rapoport (Microsoft) (2):
      init/main.c: fix boot time tracing crash
      MAINTAINERS: add tree entry to numa memblocks and emulation block

Nathan Chancellor (1):
      compiler-clang.h: define __SANITIZE_*__ macros only when undefined

Quanmin Yan (2):
      mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
      mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()

Sang-Heon Jeon (1):
      mm/damon/core: set quota->charged_from to jiffies at first charge window

Stanislav Fort (1):
      mm/damon/sysfs: fix use-after-free in state_show()

Uladzislau Rezki (Sony) (1):
      mm/vmalloc, mm/kasan: respect gfp mask in kasan_populate_vmalloc()

Vlad Dumitrescu (1):
      percpu: fix race on alloc failed warning limit

Wei Yang (1):
      mm/khugepaged: fix the address passed to notifier on testing young

wangzijie (1):
      proc: fix type confusion in pde_set_flags()

 MAINTAINERS                            |  1 +
 arch/arm64/kernel/machine_kexec_file.c |  2 +-
 arch/riscv/kernel/kexec_elf.c          |  4 ++--
 arch/riscv/kernel/kexec_image.c        |  2 +-
 arch/riscv/kernel/machine_kexec_file.c |  2 +-
 arch/s390/kernel/kexec_elf.c           |  2 +-
 arch/s390/kernel/kexec_image.c         |  2 +-
 arch/s390/kernel/machine_kexec_file.c  |  6 +++---
 fs/ocfs2/extent_map.c                  | 10 +++++++++-
 fs/proc/generic.c                      |  3 ++-
 include/linux/compiler-clang.h         | 29 ++++++++++++++++++++++++-----
 include/linux/kasan.h                  |  6 +++---
 init/main.c                            |  2 +-
 mm/damon/core.c                        |  4 ++++
 mm/damon/lru_sort.c                    |  5 +++++
 mm/damon/reclaim.c                     |  5 +++++
 mm/damon/sysfs.c                       | 14 +++++++++-----
 mm/hugetlb.c                           |  9 ++++++---
 mm/kasan/shadow.c                      | 31 ++++++++++++++++++++++++-------
 mm/khugepaged.c                        |  4 ++--
 mm/memory-failure.c                    | 20 +++++++++-----------
 mm/memory_hotplug.c                    | 10 ++++++++--
 mm/mremap.c                            |  9 ++++++---
 mm/percpu.c                            | 20 ++++++++++++--------
 mm/vmalloc.c                           |  8 ++++----
 25 files changed, 144 insertions(+), 66 deletions(-)


