Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA4DD73E84
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 17:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194F46B0088; Thu, 29 Jan 2026 12:45:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143856B0089; Thu, 29 Jan 2026 12:45:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041866B008A; Thu, 29 Jan 2026 12:45:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E30C16B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:45:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8308CD371A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:45:16 +0000 (UTC)
X-FDA: 84385727832.29.F8D4485
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE79A180007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:45:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0akjmG9r;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769708714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jsu3vaga3zLR1rmUEj0Yv2rMXLjU74nkvztJ9bQNAsQ=;
	b=23ouVCjpxWndXzOTD+vOifjDS96ZLsEj8h75IEgrccjKfBtVHrR5LlIIvvsc4IDjpB9S2b
	s3GzxfIJ13RmTk9rr0cmK3j9cSxdvgwLPS9ivtwZG5adB0kVO2jhvSN3H/B2RiXZ0x6vNA
	KGMeTx98J4cLuRnhLHFnH0xLA5qozGE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0akjmG9r;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769708714; a=rsa-sha256;
	cv=none;
	b=hpAOem9qdV2YUDgp2i12YfW0XbqgMsNZw4+2GuRBxfiKzaH1wVXx+4opXWDW09Rq6+vojx
	tINAuCI5gVGj5w5RmYelBbeQSf/vH/Hmf59D4M3kamLXq+rpRopyc+hBwF8kNYGFr9Sk7/
	dliS1g4C6gXmsuzm1/FhEJ2es9AlDMQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2294660054;
	Thu, 29 Jan 2026 17:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A625AC4CEF7;
	Thu, 29 Jan 2026 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769708713;
	bh=/6Bij3SsXTuU2/orANe8p9+tCAYwwRciCDxFl8HVqdk=;
	h=Date:From:To:Cc:Subject:From;
	b=0akjmG9rb9fhX7DXzSBU9V/DaI4hjKXoHmSjI3SM1rSTiRMEyX5S4IKy9Fhffeds+
	 IVWBA8nGrlSXZeN1bv4HsvZzaPpGnfzRaod8fMPivarkUNE0RIoahDVpo37Gg9KL/f
	 6K0+FwY4CYKBLQj+w0UG/bWaqtSiasUp/ye751YM=
Date: Thu, 29 Jan 2026 09:45:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.19-rc8
Message-Id: <20260129094513.621310717801e65dce692162@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6xmzka4i1mywfoxos35qorhq85g1im3r
X-Rspamd-Queue-Id: CE79A180007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769708714-305128
X-HE-Meta: U2FsdGVkX1/4DYlDwPT4MU7vcK4aj0UuZ75Lpe0CL1EzZpA3jd/r5Yt2rSUJpTR1DyXo3T/cLFXRATI9ep3vmQ6PgOhjzu4IacpO2/ZF/A3VqT5+r4wAcLydETE/XfLWG/AUmSx7Jsl+1j4MMwOHjR6WbyLL1oSuF2d6cV7QkT4PN+Nmj4celAKH5drEhpLHdH19khwRSG1lU2G6kMpm89QLvcdxjhv4q6B8yOaRs80znfTqwgMSFuTK2IQPBiy942pu3ve3fscfabSjwDqFLnR5GB3JeCKtPBsfgD7sUb2Ehjeo5PbEU9SKf9pJhoPef4Ebzmlnsqoeh9LkptUVGYRi53M4tbZennLiBrn3L5qDMicIGKLDMSP/I832uryNsR1ZBtZsYH4DOsy+p4MKw6OoH8pkecsH6WvPY/PZEXbgLegxR6ZrfzWGksB9au6GjecywrRfNLSF3seDiDwTwvi+VZ91GOCV/DFyuO75D+15rWYPlBT8+Wj2XsMxBMB4kYgDGbXGSDGbaVyiWrIy9pioo1Z9JN+CxPScEiUSsPBix3iqJrr2tdZHP5WWb5JaGaeX84TKJSFPGezpFc5kqWk5/Gw+KEswdWF6Xu+kdQnwkOFow0Ujd2lsLnAJCYppfNKXhSvoaJHvt3lII1AD3pIA66iOASzsn65SQEwOcqTxMwrSSLLo1mYetT0WGGB3mCFWGoDJP5s4pHl5M6ePa6Gc+7GP20PPM8z8r8xnoKBAhodg3UVMRBbzzupr1PI9Y1BE5hUu6+/u16yaTHrnJSoabwUEGtRNj2M4pKAmGcPsLlpk+mE31fcMF8kTifXTsOi+bX2Xhv7/CUnvx+u0rR8N2cY29zp4nRGkLIViZkr1LrEFvcBRllnMW0XDnYz6/NWjxm2FLNByI2vkrFrSnPVp2K7n+jdZPOKCSNUON1w2FyYCialTadaX9Pv08YWQv7xi68Ea7Bq64K22u3M
 vzvTNCK4
 29aTK5n57faV707xgngsGAUM13Oo2Uiip0dv7imojrBpJ8ajXvN+ugJSjYdSZLuiumm2ediGuqTLhYehD/OQsj3kj21gX272RowBwGozGRVh8a6ed2Jq/wWSug+m49LtxhngKurhDo2J0/Zgkh7PhHtRqbZ+nkRYETph0ggUxRqiPOPoXYUPeJZGT6Z2eq3sa8dMBUH5b9HGfFmXNR0xLjS0Ory4vHW6G7yn0SapSJIrVsZyg5DuXdwnEG/IXA0C+lb0pgIgEsel9/C8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please pull this batch of MM and non-MM hotfixes, thanks.


The following changes since commit 6c790212c588fddeb0d852f2790840753bb604b1:

  Merge tag 'devicetree-fixes-for-6.19-3' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux (2026-01-20 15:01:15 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-29-09-41

for you to fetch changes up to bd58782995a2e6a07fd07255f3cc319f40b131c9:

  vmcoreinfo: make hwerr_data visible for debugging (2026-01-26 19:03:49 -0800)

----------------------------------------------------------------
16 hotfixes.  9 are cc:stable, 12 are for MM.

- There's a 3 patch series from Pratyush Yadav which fixes a few things
  in the new-in-6.19 LUO memfd code.

- Plus the usual shower of singletons - please see the changelogs for
  details.

----------------------------------------------------------------
Andrew Morton (1):
      kho: kho_preserve_vmalloc(): don't return 0 when ENOMEM

Andrey Ryabinin (1):
      mm/kasan: fix KASAN poisoning in vrealloc()

Breno Leitao (1):
      vmcoreinfo: make hwerr_data visible for debugging

Jan Kara (1):
      flex_proportions: make fprop_new_period() hardirq safe

Jane Chu (2):
      mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
      mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn

Kairui Song (1):
      mm/shmem, swap: fix race of truncate and swap entry split

Matthew Brost (1):
      mm/zone_device: reinitialize large zone device private folios

Pimyn Girgis (1):
      mm/kfence: randomize the freelist on initialization

Pratyush Yadav (Google) (3):
      memfd: export alloc_file()
      mm: memfd_luo: use memfd_alloc_file() instead of shmem_file_setup()
      mm: memfd_luo: restore and free memfd_luo_ser on failure

Ran Xiaokai (1):
      kho: init alloc tags when restoring pages from reserved memory

Viacheslav Bocharov (1):
      mailmap: add entry for Viacheslav Bocharov

Waiman Long (1):
      mm/mm_init: don't cond_resched() in deferred_init_memmap_chunk() if called from deferred_grow_zone()

robin.kuo (1):
      mm, swap: restore swap_space attr aviod kernel panic

 .mailmap                                 |  1 +
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
 drivers/gpu/drm/drm_pagemap.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  2 +-
 include/linux/kasan.h                    | 14 +++++
 include/linux/memfd.h                    |  6 ++
 include/linux/memremap.h                 |  9 ++-
 kernel/liveupdate/kexec_handover.c       | 12 +++-
 kernel/vmcore_info.c                     |  6 +-
 lib/flex_proportions.c                   |  5 +-
 lib/test_hmm.c                           |  4 +-
 mm/kasan/common.c                        | 21 +++++++
 mm/kfence/core.c                         | 23 ++++++--
 mm/memfd.c                               |  4 +-
 mm/memfd_luo.c                           | 10 ++--
 mm/memory-failure.c                      | 99 +++++++++++++++++++-------------
 mm/memremap.c                            | 35 ++++++++++-
 mm/mm_init.c                             | 12 ++--
 mm/shmem.c                               | 45 +++++++++++----
 mm/swap.h                                |  2 +-
 mm/swap_state.c                          |  3 +-
 mm/vmalloc.c                             |  7 +--
 23 files changed, 239 insertions(+), 87 deletions(-)


