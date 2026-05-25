Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6027CCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 23:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4016E6B0005; Mon, 25 May 2026 19:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1646B008A; Mon, 25 May 2026 19:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7F56B008C; Mon, 25 May 2026 19:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17EAA6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:24:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFAA51201DD
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:24:58 +0000 (UTC)
X-FDA: 84807524676.29.019EAD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E42C3C000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:24:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XS8r4faf;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779751497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q9/IdT39X3dE7LxPKUv6KDEBgFCD8qHZ8fQBx+/DyiY=;
	b=KyFvcQfqDI83xKIfI5dAupWq+IOM83Sa3VdqXcTOJwZvHJ6QrLjJoMQ7TnMPFrFkHO+yr8
	vOnYJKhVyna9vup3ZL9/WjifaiJZXIEXr9+2yMpLGLao3MTpAX4mcw+mH/5iUTt4/4sqyb
	gvqi0KgaF+5aLwVPNoO3ukFqjlHBWKM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XS8r4faf;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779751497; a=rsa-sha256;
	cv=none;
	b=6cvVsedJCwa/I/zEPt+Rf/p3sa1p2NYxIRg3ApcxRzOwHkJB37v7wveop1yVf5uj1XyBvL
	6yz20uTcL3CHGbdai1NneZLsg2tMfBaroZ51Cqgam43VY2xyNCj9eqQTsGdbOah6FSf5S4
	dNwF8OCeSnBYjhJQwKh20m6+JKGD/7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5EDF419EE;
	Mon, 25 May 2026 23:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4781F00A3A;
	Mon, 25 May 2026 23:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779751495;
	bh=q9/IdT39X3dE7LxPKUv6KDEBgFCD8qHZ8fQBx+/DyiY=;
	h=Date:From:To:Cc:Subject;
	b=XS8r4fafSV79SwewefejSDAPnLagqfP/a7Itn3C1fKwzxQp05KBnkL1WaG44xEWWj
	 vguUTsbAFoBtdAHBNGmulzHL7YDZZEhMqhZhylsQQ2q1vgeWlN/nTzsRCt4X3Evq6J
	 3n2oFGiy2/2pSbnLcQD/D09l+f3wkKyXV2y3Kyb8=
Date: Mon, 25 May 2026 16:24:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc6
Message-Id: <20260525162455.b407390573351c2d352baa16@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: goexbz577tbq13z9rmf3sh1ghbsfebd1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E42C3C000A
X-Rspam-User: 
X-HE-Tag: 1779751496-121458
X-HE-Meta: U2FsdGVkX1/Onm5lddxdp27GQwyCJqNCttCCXr+TPnzntRuj1dvqaiB1xwgEVkd/sc7mlBcHoJDATZ2eAUwlX9sa9FPmhwfiMCFXnQSVlxEPwcMsgrX57SR87EVTith192Q24pOsAFT4sGMvG+zahXfEsS/4BsqPAu+Hk8Q3JBC48i468GQ4rXyPe37/nSCDzFC9VPCjROy3sJIXuCF8zWzpg+zGEMSmDIu0iuV4oaJ31Kk+Pkb7ZFvHPtfDISL4SLe60NgIMTgBsQhlH5EkJYTRNfpFDnwnueKN/473cZbWu9rrs/anHOnU8R440nmf7LAywiIqM8ifynIAXCAk5qgLfNWA7lvHECRN2pLRXBc+NPtWiQ8B/qG9Ewcst0Y0lWfxyUmR5vMjRGYpQpjBC/z2aSmmNjxm6kt2HCBlWZlun4wwWY6PHrw/vNOXMpSfiZjtZPcZz6HUviE7wwgPY7w/4+hw37Z7sAlNS7YcStyr0VzZ1DSgMinmBq30WZ7D/E2RDcq16uWrSXFvtVQwJjhziJ6yf62gxnelA7B+kJYMZ67nv2Iax//tRoz5yA1BYd9ZgAbzdi252U1DBliBkkUjpZ0JNKBjibBSDUUeCAbaOoE9yerAn3rGeWtghq5v/jpzHtK/QS8Na9TG0nq6nC0kT0HyFKfyPwMQXEnl8VOkUqDBvI6CKhR4hFAbvcu7P+nXq7VTuXO/uprPed9+VRy4tF0Jxbs74vk9Gkarldc9/AR4XU43zhuzANS7mFd1rSaj4aCDG8Pm2ybI6J80LYzR0eagWrikBEVyz5HCtiUQN36dA7RnmNRVznvPt8wBO8RB64AkuDJaIj/xw8w8duhUgxwUQtCmhAofW80Gr8PZXrqU1TXBMlC53J5YBuObujYkRYDdNyWINFBxGmB4qvxzqvVb5HIcG9s/fwspTaCgqsg0EaK4WoPzwymt1a7W9j4LmgVt1ybUqBPgsey
 Jio7AHHf
 T7YxKIXQ4+0R9gEG6lGNUct3bVSGDOfD7LR9vZBKl0o3AL5nslKNRfVTaQodx7P7iOEStdHFtbRUG7KpSiObwa5lNgtjTqa7iT+j1h8ezVaqnmJrgydYnceLlQ1iKA9yHiorLrCOgONyUV8fsr2X2+/gsXfsDY5zVwj8oeUsLr3J13+TZCvjACtezLVbFrm2ln6Yqo1Gjb9MUi9rKHD0+mFTSqteJhtfmD0dsoanQgPmRUorZ00h6pkVEcKPszMVeIK1EivoKWiosjbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of 13 hotfixes, thanks.


The following changes since commit 27fa82620cbaa89a7fc11ac3057701d598813e87:

  Merge tag 'ata-7.1-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/libata/linux (2026-05-19 14:00:48 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-25-16-22

for you to fetch changes up to 54cf41c969da6637cce790b7400da1451609db9b:

  Revert "mm: introduce a new page type for page pool in page type" (2026-05-21 19:06:13 -0700)

----------------------------------------------------------------
13 hotfixes.  9 are for MM.  9 are cc:stable and the remaining 4 address
post-7.1 issues or aren't considered suitable for backporting.

All patches are singletons - please see the individual changelogs for
details.

----------------------------------------------------------------
Alexandre Ghiti (1):
      mm: memcontrol: propagate NMI slab stats to memcg vmstats

Byungchul Park (1):
      Revert "mm: introduce a new page type for page pool in page type"

Deepanshu Kartikey (1):
      kernel/fork: validate exit_signal in kernel_clone()

Dev Jain (1):
      mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one

Eugen Hristev (1):
      MAINTAINERS, mailmap: change email for Eugen Hristev

Ian Ray (1):
      MAINTAINERS: .mailmap: update after GEHC spin-off

Linpu Yu (1):
      ipc: limit next_id allocation to the valid ID range

Lorenzo Stoakes (1):
      Revert "mm/hugetlbfs: update hugetlbfs to use mmap_prepare"

Pratyush Yadav (Google) (1):
      memfd: deny writeable mappings when implying SEAL_WRITE

Richard Chang (1):
      zram: fix use-after-free in zram_writeback_endio

SeongJae Park (1):
      mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()

Sunny Patel (1):
      mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page

Uladzislau Rezki (Sony) (1):
      mm/vmalloc: do not trigger BUG() on BH disabled context

 .mailmap                                         |  6 +-
 MAINTAINERS                                      | 14 ++---
 drivers/block/zram/zram_drv.c                    |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |  2 +-
 fs/hugetlbfs/inode.c                             | 46 +++++----------
 include/linux/hugetlb.h                          |  8 +--
 include/linux/hugetlb_inline.h                   | 14 +----
 include/linux/mm.h                               | 27 ++++++++-
 include/linux/page-flags.h                       |  6 --
 include/net/netmem.h                             | 19 +------
 ipc/util.c                                       |  2 +-
 kernel/fork.c                                    | 11 ++--
 mm/damon/sysfs-schemes.c                         |  8 +--
 mm/hugetlb.c                                     | 71 ++++++++++--------------
 mm/memcontrol.c                                  |  6 ++
 mm/memfd.c                                       | 12 ++--
 mm/migrate_device.c                              |  4 +-
 mm/page_alloc.c                                  | 13 ++---
 mm/rmap.c                                        |  2 +
 mm/vmalloc.c                                     |  2 +-
 net/core/netmem_priv.h                           | 23 ++++----
 net/core/page_pool.c                             | 24 +-------
 22 files changed, 135 insertions(+), 191 deletions(-)


