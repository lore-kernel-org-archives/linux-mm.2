Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E609FCC9A4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 23:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9636B0005; Mon,  9 Mar 2026 19:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4BCC6B0089; Mon,  9 Mar 2026 19:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957C06B008A; Mon,  9 Mar 2026 19:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2556B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 19:38:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 445001C400
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:38:50 +0000 (UTC)
X-FDA: 84528142020.28.1AAA3B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A428E140009
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:38:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ctBzW0Pn;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773099528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EhQxIUfqKerIUvblSoVqNufIU2pc/kZB6YibPsyxr8Y=;
	b=kObfF4DVM3HRKtuwJYRCSZEx7cx745dUsbHQk1C1F6RRlkperhJb9Feh4BhHy9QAbP0ihd
	YEdPGbf0/aaDVzo/zEpSJTW8E+MprbRTRaHXmRccUXAqMO3xSNb+3O0VL714J0810+9BAc
	BDgp6UDfQsKTOSqIAsLSHGhoiUFyubM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773099528; a=rsa-sha256;
	cv=none;
	b=kFWgQTmfG87wBEBq5x3BYJSpSYX+dfkrtwnVQoJK8+2RSF9L9StaVwSXeXRQb1MfORf7zz
	iQt978SB2uT4hOSnynr364KYcYWXShv7uL3xbDTW7Vbd+S8vWM2adaY5clI9rat7/dbFfJ
	sgXJQShMiwOgH4lVKTlGf4wuLdexDis=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ctBzW0Pn;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CA46439ED;
	Mon,  9 Mar 2026 23:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BAFC4CEF7;
	Mon,  9 Mar 2026 23:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773099527;
	bh=FykBWcFe23lE0fFQ+0Q1RwNiAvy8eDPcpckP4pBtT7Q=;
	h=Date:From:To:Cc:Subject:From;
	b=ctBzW0PnltS9HVS48yHYDmydDQQY2lN9rew4C6+WJnP8JqzF23lLjJPF/T59cadw8
	 R2wkZ7Z3CxU6Jp8kG7sdFgBvYwUHn/0aFA1SkJsuTgGMXBAPmEQ0eeDr3aBCE/3TEB
	 E9nQJEzqOHrNLKHvogIjOtMNgs6PxyM3lOpghi6s=
Date: Mon, 9 Mar 2026 16:38:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc4
Message-Id: <20260309163846.f59b3518cba71b9587576e7f@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A428E140009
X-Stat-Signature: 6zngifqrhxf7k7scghire9ayjg1f84ot
X-Rspam-User: 
X-HE-Tag: 1773099528-656999
X-HE-Meta: U2FsdGVkX18y8pfYEkFJOH0aFcFWAFNTaS+r8iOm0rY5kXgfoFwm6+JqaZlJytimrtLMzg26Z79ckurG728HpgqE5/+HTtHQzsuhRFqDUhuR93qBljj86qHwkXzceko1qVhcq84WDPKcf+/ES9yD65jBDfURgls1vTv6b7wj29lQ3rjiNQoOlPult1fw4zNxFGK0JXSx94uIcpX50DtfALf4prwB6AxEfNaLmI0H1/IwhD2qbxp6XHyUxbqVpMdkswdIcxii7MZjV/iCyYz/R0Shhxrk4Icrvo9P3nCojFVEiE20WGQsmbYyHFmpOF7fsXsHMLOmRglUkTr0xIO2obY20xfZIf2fs2U2Wnujoxr8icky3GKliXWW55Jzh9ztTv9xF/cGkjnaMzMoNRVQqTo3YCHPg8GzOBKyFlseZKT34l1nxcBWp5LP4Qf1v6G+4AKZlGDn7watU17WVRTDND7cmyVmXz7BhxOkN+duJuiJGbD/gFCkaxWhfkgsl+/ED9cV/+Ukgn+/d//mkq5NNrGwFtdjCyD3SMW6vx4XV1et/RkOkoU9e0+4vZBxypKRJGubFTDEE9sE6snL+3QzucBR94WxxRsNxFd8zDyx3gIiC073BH3Cs8H8a/nilVwiDbwm7JNeNqEQLtpgjSjNp1NwMpbX0Esr5DY+3QRdk4kUCaX2UoaqXNqh0x2wLoCr0ZIjlszVtExoTYiviLaAGm1T4VQai5+/y6ijnPinTnrD8ulkuIf8lT+gORDmsYTfgvhAf/bq8/6FrtMqaGHt/xRU8KHfNlsUFyRbc/96YhdHqyHf3R4/Bhh/G+YOcK9dD7HEy1dGef+VX+pnpGEOg0/WkhTjoi4i24PQ7AfX8kpUvqsiNu/XDrHcUBrfwbTbmp9rKXcDnE9y7ylt+cdYVLguthsQdHzspf+NYpUsETg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Linus, please merge this batch of hotfixes, thanks.



The following changes since commit 410aed670cddac1de4f0c2865f30ec623fd20f78:

  MAINTAINERS: update Yosry Ahmed's email address (2026-02-24 11:13:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-09-16-36

for you to fetch changes up to b12bbe35c7c1e431f2fa01fe9291daa52fb7ab43:

  MAINTAINERS, mailmap: update email address for Lorenzo Stoakes (2026-03-04 10:06:40 -0800)

----------------------------------------------------------------
15 hotfixes.  6 are cc:stable.  14 are for MM.

Singletons, with one doubleton - please see the changelogs for details.

----------------------------------------------------------------
Axel Rasmussen (1):
      Revert "ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()"

Hao Li (1):
      memcg: fix slab accounting in refill_obj_stock() trylock path

Jason Xing (1):
      MAINTAINERS: add RELAY entry

Lorenzo Stoakes (Oracle) (1):
      MAINTAINERS, mailmap: update email address for Lorenzo Stoakes

Mike Rapoport (Microsoft) (1):
      tools/testing: fix testing/vma and testing/radix-tree build

Pratyush Yadav (Google) (2):
      mm: memfd_luo: always make all folios uptodate
      mm: memfd_luo: always dirty all folios

Randy Dunlap (2):
      uaccess: correct kernel-doc parameter format
      mm/mmu_notifier: clean up mmu_notifier.h kernel-doc

Raul Pazemecxas De Andrade (1):
      mm/damon/core: clear walk_control on inactive context in damos_walk()

Ritesh Harjani (IBM) (1):
      mm/hugetlb.c: use __pa() instead of virt_to_phys() in early bootmem alloc code

Sergey Senozhatsky (1):
      zram: rename writeback_compressed device attr

Vlastimil Babka (SUSE) (1):
      MAINTAINERS: add co-maintainer and reviewer for SLAB ALLOCATOR

Zi Yan (2):
      mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
      mm/huge_memory: fix a folio_split() race condition with folio_try_get()

 .mailmap                                    |  3 +-
 Documentation/ABI/testing/sysfs-block-zram  |  4 +--
 Documentation/admin-guide/blockdev/zram.rst |  6 ++--
 MAINTAINERS                                 | 33 ++++++++++++-------
 drivers/block/zram/zram_drv.c               | 24 +++++++-------
 drivers/block/zram/zram_drv.h               |  2 +-
 include/linux/mm.h                          | 17 ++++------
 include/linux/mmu_notifier.h                | 31 +++++++++---------
 include/linux/uaccess.h                     |  4 +--
 mm/cma.c                                    |  5 ++-
 mm/damon/core.c                             |  7 ++++-
 mm/huge_memory.c                            | 13 +++++---
 mm/hugetlb.c                                |  4 +--
 mm/memcontrol.c                             |  2 +-
 mm/memfd_luo.c                              | 49 +++++++++++++++++++++++++----
 tools/include/linux/gfp.h                   |  4 +++
 tools/include/linux/overflow.h              | 19 +++++++++++
 tools/include/linux/slab.h                  |  9 ++++++
 18 files changed, 163 insertions(+), 73 deletions(-)


