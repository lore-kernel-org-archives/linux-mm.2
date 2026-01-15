Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC65CD44C70
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19286B0088; Thu, 15 Jan 2026 11:06:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC68C6B0089; Thu, 15 Jan 2026 11:06:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0296B008A; Thu, 15 Jan 2026 11:06:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC5876B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:06:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55BE1160400
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:06:49 +0000 (UTC)
X-FDA: 84334676538.11.66981DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D2848100017
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:06:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o+X7fBAa;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768493207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=H4ncJO3GIGeKUBJEHTaLG0oJIpq7xXB0x8qmnFWgh5E=;
	b=2SNeNj1vxvkoXzRyh6JiXyjRM5amJrwAdvvzg2zX+6AB1XxL106hQcwYp+QPfPzV8n3vbS
	BfkaoSlEX94Or5YcUKYly64hQN/W+iL865Ht8u6JKj3XiqUk7IaxgISo/BUG+HxQz+m9Fj
	lnEBbfzD8JDo85okqcC7gcIGKNnEC/4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o+X7fBAa;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768493208; a=rsa-sha256;
	cv=none;
	b=J4L1JkDlIRSzHDSWaMWOCTGQaUVLyb/cTKXoTuFJ3bWyGQ5KuMwZ67nW/qzJ+52f/VR9fs
	Ciyazlykhx9R1jJzslsj54rBlGLZYJ/3beP17tKJLsOFvJ2upm9ojSolrCpr7TnsbN1ylk
	cfOrHxbh0j4sbDxkGZAm+ZVVxGTI66w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB907600BB;
	Thu, 15 Jan 2026 16:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BA7C116D0;
	Thu, 15 Jan 2026 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768493206;
	bh=NVJo7J8yhwfa5AT6TXzZR3usJmOp8dPjAOt3Iy8w++8=;
	h=Date:From:To:Cc:Subject:From;
	b=o+X7fBAaEfqJPPICRdhNboEMHxZAgXFnck/0Zipxfls7scCDBDNtMvXh21cUdQzmT
	 XdIGcHvv9YRXuA4CAJLu/uFR3j8iNq6K/bKznP/wX+eQ/I5jWiL9/nHv4H1b8i6hqT
	 OgP7KRaNEH/IN+5s+TofyFY5UZzqi/unDV1sbu38=
Date: Thu, 15 Jan 2026 08:06:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.19-rc6
Message-Id: <20260115080645.3744d9e4178884f988d6366d@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D2848100017
X-Stat-Signature: fjnz997qdkh5i99optwspam973o1cn66
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768493207-517775
X-HE-Meta: U2FsdGVkX1/KEo5bQh1ozLk8ENO1y8LhF5nFewi0rOBEbElc1pZodfXkifhy5pqWv33A+g4p0o+wcKkn0pRiB3tqVosjmmLMj1yDSPT2XC2lYurdQD3mpPInpJZPvk0mYoe4tzjCeVGkdVMrttAm/h1nSkZlqsa2WJUDfrTJcPYs/A5pdpLUeAsBJ5UhFWxkrfGOLmash/USrU+6PYljEO883ToHNQBJhcFzVtc7Fqp0qOJgxJOt/alCA0mEG/2psmSj0kT4WX+2iNmAOogLLfum8B9B1SezBF0SQiayleJYAkBnK4+OPZdG7WuySlVKk51wVftOaw6YhKR6VgVFUVp7/y+7ioT9lBklSrfGXus4um+2EJTZnnMxMdQHw/x+h22L5HnQG3Wdj1mL8ZfeA3RRWRhIh+I8OShAeHnSeLxlr5uws5B/25fIBykVsBRPS2JBe4zSGz9WdrBltR04rCjCKrpQGPRBKlzwX+ILmAlmwsgfv/jxetr6vzWVPdQe0QuBSNvrfU8QTxFKkS3PQD5junI0Yd/wi7nL7AfR3g/CxQcilA73msBSONbjNr7KN6qemMJoF5lszKJBYyiHVvzsfW5LyQnIDY6cbZTZNgfJRJvceFhwpsyL38WW0SFPAElXXM5PXe/np3DzLMTbWWiuY0nnR3Gzsz9BUZvAItsHUl6q2W0s313/EKV9uOFtuHngw0X3GjYP2S42r/XiIIZHx31yuFnKfnVCX5xOCKatc/RM1KRNbgzrvA0WWAGBGI8lavwlbqzppgavCR3v6OV0hf8cuZpuoCp1yQ4dq2JAL3sMwgzvRFdAAtbGaOp+91QnhFwjqQDN0BLQA/8DnZK3r/UvWUdWryGgvbErMzTUt+Zapb/CtCq/ceqDjQ1bPMy54N66hcSaSk9sXnu2tGd5y4dprlYt8521mAz4yYo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please pull this batch of hotfixes, thanks.


The following changes since commit 0f61b1860cc3f52aef9036d7235ed1f017632193:

  Linux 6.19-rc5 (2026-01-11 17:03:14 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-15-08-03

for you to fetch changes up to 3e8e590fd65d0572584ab7bba89a35e6d19931f1:

  drivers/dax: add some missing kerneldoc comment fields for struct dev_dax (2026-01-14 22:16:26 -0800)

----------------------------------------------------------------
32 hotfixes.  16 are cc:stable, 24 are for MM.

- four kerneldoc fixes from Bagas Sanjaya

- four DAMON fixes from SeongJae

- four mremap VMA-related fixes from Lorenzo

- various singletons - please see the changelogs for details

----------------------------------------------------------------
Aboorva Devarajan (1):
      mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free

Bagas Sanjaya (4):
      mm: describe @flags parameter in memalloc_flags_save()
      textsearch: describe @list member in ts_ops search
      mm: vmalloc: fix up vrealloc_node_align() kernel-doc macro name
      mm, kfence: describe @slab parameter in __kfence_obj_info()

Ben Dooks (1):
      mm: numa,memblock: include <asm/numa.h> for 'numa_nodes_parsed'

Carlos Llamas (1):
      iommu/sva: include mmu_notifier.h header

Daniel Thompson (1):
      mailmap: add entry for Daniel Thompson

Feng Tang (1):
      powerpc/watchdog: add support for hardlockup_sys_info sysctl

John Groves (1):
      drivers/dax: add some missing kerneldoc comment fields for struct dev_dax

Lorenzo Stoakes (5):
      mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
      tools/testing/selftests: add tests for !tgt, src mremap() merges
      mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
      tools/testing/selftests: add forked (un)/faulted VMA merge tests
      tools/testing/selftests: fix gup_longterm for unknown fs

Marco Elver (1):
      docs: kernel-parameters: add kfence parameters

Mike Rapoport (Microsoft) (1):
      mips: fix HIGHMEM initialization

Pasha Tatashin (1):
      kho: validate preserved memory map during population

Pavel Butsykin (1):
      mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()

Ryan Roberts (1):
      mm: kmsan: fix poisoning of high-order non-compound pages

SeongJae Park (5):
      mm/damon/core: remove call_control in inactive contexts
      mm/damon/sysfs: cleanup intervals subdirs on attrs dir setup failure
      mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
      mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure
      mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure

Shakeel Butt (2):
      lib/buildid: use __kernel_read() for sleepable context
      mm/damon/core: get memcg reference before access

Sourabh Jain (1):
      mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported

Szymon Wilczek (1):
      mailmap: update email address for Szymon Wilczek

Vlastimil Babka (1):
      mm/page_alloc: prevent pcp corruption with SMP=n

 .mailmap                                        |   2 +
 Documentation/admin-guide/kernel-parameters.txt |  35 +++
 arch/mips/mm/init.c                             |  23 ++
 arch/powerpc/kernel/watchdog.c                  |  15 +-
 drivers/dax/dax-private.h                       |  10 +-
 drivers/iommu/iommu-sva.c                       |   1 +
 include/linux/kfence.h                          |   1 +
 include/linux/nmi.h                             |   1 +
 include/linux/sched/mm.h                        |   1 +
 include/linux/textsearch.h                      |   1 +
 kernel/liveupdate/kexec_handover.c              |  37 +--
 kernel/watchdog.c                               |   2 +-
 lib/buildid.c                                   |  32 +-
 mm/damon/core.c                                 |  41 ++-
 mm/damon/sysfs-schemes.c                        |  10 +-
 mm/damon/sysfs.c                                |   9 +-
 mm/hugetlb.c                                    |  16 +
 mm/kmsan/shadow.c                               |   2 +-
 mm/numa_memblks.c                               |   2 +
 mm/page_alloc.c                                 |  57 +++-
 mm/vma.c                                        | 111 ++++---
 mm/vma.h                                        |   3 +
 mm/vmalloc.c                                    |   2 +-
 mm/zswap.c                                      |   2 +-
 tools/testing/selftests/mm/gup_longterm.c       |   2 +-
 tools/testing/selftests/mm/merge.c              | 384 ++++++++++++++++++++++--
 26 files changed, 674 insertions(+), 128 deletions(-)


