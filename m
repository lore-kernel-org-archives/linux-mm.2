Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3608BCD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 03:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE636B0005; Mon,  8 Jun 2026 23:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4883E6B0088; Mon,  8 Jun 2026 23:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E8A6B008A; Mon,  8 Jun 2026 23:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A85D6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 23:54:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B99F18DC6B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:54:29 +0000 (UTC)
X-FDA: 84859007058.15.B3143A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D4D558000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:54:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V1eRCX0V;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780977268;
	b=Fyg4Dfd1Mbp3wpFMA9/8uobX7kYDLrICLxFDrQauzGxvh3h6Fmaji9d1nsd8ybwJ6RCBqP
	EGKGDf852agqSJfNAeuEwn5oWbSBfJh0v6dWHqlz11sx5alW1QO1EobXDWakakcqUOnFtl
	+psiLQzQVH/YvXlNi4G3X6a/tuYebQ8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V1eRCX0V;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780977268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TqrgAu/JqewJItrwuRMduRmwxB/x1xVSsT3lOJ0PyWs=;
	b=zqr99cOcArvcQZoepABW7y5U/nc7+iRJftK3/d5ExvYU2hR/0Jl5x7fXUBe8oudM49UU3B
	TB1ajdAW1kylWY6vCQqYJnh17KJZZK7EpJ4gLm1VRKsoBcexx0uciN4CMvNHqxx2mkhQON
	g7iHUCXgvkR3AhTdJXP64rVW7IOPquU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCF8D44255;
	Tue,  9 Jun 2026 03:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7876B1F00893;
	Tue,  9 Jun 2026 03:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780977266;
	bh=TqrgAu/JqewJItrwuRMduRmwxB/x1xVSsT3lOJ0PyWs=;
	h=Date:From:To:Cc:Subject;
	b=V1eRCX0VUSKmAYCbu72vNTgDCPEHeZ3q2KWPdEgH+NS2RH4N2EkvVGbQlXmgQylsb
	 7SmRcAr3hOfDPHGfQ1bt/JO1NlE8EBuu1W158kgptwux+Ui1Au7CMot+vRx2IXfRdh
	 Rb9UvKHr+Y/mYPhMdvlomi0FRcZSG+S8J++EEqEk=
Date: Mon, 8 Jun 2026 20:54:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes against 7.1-rc7
Message-Id: <20260608205426.3319be94a327307e23b34f3b@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4D558000B
X-Rspam-User: 
X-Stat-Signature: qhbfgi7ecbnp4ksk6htiw8or5go36mb3
X-HE-Tag: 1780977267-766961
X-HE-Meta: U2FsdGVkX19ePGVDcIOR9TsNXzWxciogrbuKfoPvF2NHcor2EM/eysoN1/+HZHYwgfcTvbW+36HstgHmzXRLsU4BXdVZ+C/TZ3hD0R6ocA6x2zE52fzPqys/1cTdpI/BHnRYHhQslF4UslWkee7166qjBYGWL0lZgRHvQNTQxc8h+aAYjLg3mjRHXGbwYS4bUA1EHD/GAIAw+G64BfsUSUtNQ8fXlR3e39io+UAF4F7GYd42OqtvU3udbrMlCOLHFPqk/LxNJ/eqyzrmgU9EiNuDtM29bYdWRwPuD0XBmW6Yz+/bJ+kSZYTKDTDFibjiZ8rgm3USCb5IiFcspigXEt5EyyTVz6hWg8oowo+9ABWh2cwmvfuyoJtAHpRCEg3FWpnjGrogtYqBJLwEfQbCW/WMW/TZAfID1G9TDoyUaRXXulEyr4E4GqbP6jMGVhWNTrkX8QecI96PFm2ZK/lNa3wX3vXuY/e7lzHJteX6Dpy7lfo8MIAOoAzpyqR+Vuyuq84F0Nf2YK7KNjMb9tw5d3H/A6OU5MVeYnoI7A3SGx4uC3YyTUS4UZFJ6DZ9JkFh6SkTMGkJYpRTP3gOdx8ynFGIA2qjE28iod2UfkfGBUFiKjLw9d9xlOFouEHOGhsWWN99jphkCQBr3jks+KnYWvUfXdwzU/Wj4VXTwMB0Q4XPqhDJ69vhgiAyHukZ1xEQVZqlHrwX/IuOfu/yTNaJI1iCwoKep7Ep2rRckKVnts798zNsSQh0aXYDwg9f4n0fXX4k3Agqq0y5UBddC7XawIHwJMaIHvtqFbVAvYIIAk0Dk/B5g6TcPxzofzcuCoFj4Ir1LITjIAojNSTixS2JdxC9WPbI4cSsrY/MrRI6KDm8VE2Eu0Wq/HvTcp+lVH/3DFf1zc+Bqg2/kyOnp2AxUbJYScFjmNzJDVxq8XA31mWN2U/TTvI2DzmL8i3F7tpMgnoX+kNaMb5dtTdYHnA
 DCFWz39l
 jdpqM2/PRULM7qt66Xs/V9rRW3K75eTxxuXAQgZqua+E3AFz1pfxlzOtXlRkTZTqK1uGDvVRRoeKDQahhrrTtft0VlRMG+nExOg9VuFQ40o7tzEfyd+GVcwfW3Qnn2dRhbt/DCHjAsplhJJ5F6Up6ra2h226v/e/IPRfcgH1SwY9Zsk3TkC2Ld1w0Kena+6R1TiteuP5w/AzTVHVrq17LJtNdN5coNicS/vssa14/zO3DN69amtCnRinzQQkQCyrJxm7qMO+XjI3+1G9p3+/HumsVvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 9d7bea186ba5a002456471edf36cc9b69f809397:

  userfaultfd: remove redundant check in vm_uffd_ops() (2026-05-31 21:50:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-08-20-51

for you to fetch changes up to 0c25b8734367574e21aeb8468c2e522713134da7:

  mm/mincore: handle non-swap entries before !CONFIG_SWAP guard (2026-06-03 16:25:52 -0700)

----------------------------------------------------------------
11 hotfixes.  9 are for MM.  8 are cc:stable and the remaining 3
address post-7.1 issues or aren't considered suitable for backporting.

Thre's a 2 patch series "mm/damon/{reclaim,lru_sort}: handle ctx
allocation failures" from SeongJae Park which fixes a couple of DAMON
-ENOMEM bloopers.  The rest are singletons - please see the individual
changelogs for details.

----------------------------------------------------------------
Alistair Popple (1):
      arm64: mm: call pagetable dtor when freeing hot-removed page tables

Baoquan He (1):
      MAINTAINERS: update Baoquan He's email address

Cunlong Li (1):
      zram: fix use-after-free in zram_bvec_write_partial()

Kaitao Cheng (1):
      mm/cma_sysfs: skip inactive CMA areas in sysfs

Lorenzo Stoakes (1):
      mm/huge_memory: use correct flags for device private PMD entry

SeongJae Park (2):
      mm/damon/reclaim: handle ctx allocation failure
      mm/damon/lru_sort: handle ctx allocation failure

Shakeel Butt (1):
      mm/list_lru: drain before clearing xarray entry on reparent

Usama Arif (1):
      mm/mincore: handle non-swap entries before !CONFIG_SWAP guard

Wang Yaxin (1):
      tools headers UAPI: sync linux/taskstats.h for procacct.c

Yilin Zhu (1):
      ipc/shm: serialize orphan cleanup with shm_nattch updates

 .mailmap                        |   1 +
 MAINTAINERS                     |   6 +-
 arch/arm64/mm/mmu.c             |   1 +
 drivers/block/zram/zram_drv.c   |   2 +-
 ipc/shm.c                       |  10 ++--
 mm/cma_sysfs.c                  |   8 ++-
 mm/damon/lru_sort.c             |   4 ++
 mm/damon/reclaim.c              |   4 ++
 mm/huge_memory.c                |  45 ++++++++++----
 mm/list_lru.c                   |  21 ++++---
 mm/mincore.c                    |  10 ++--
 tools/include/uapi/linux/acct.h | 128 ++++++++++++++++++++++++++++++++++++++++
 12 files changed, 204 insertions(+), 36 deletions(-)
 create mode 100644 tools/include/uapi/linux/acct.h



