Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F98CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8118E01B5; Tue, 12 Aug 2025 23:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62528E01B3; Tue, 12 Aug 2025 23:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50F38E01B5; Tue, 12 Aug 2025 23:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ACACB8E01B3
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:53:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7EDA216022F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:53:00 +0000 (UTC)
X-FDA: 83770363320.20.3FFE9EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C1D57140006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mdaKKiRb;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vx+YTl6uqOZXXxItxdxhTB3y5PoQZAUMaMJTTaCutMc=;
	b=cCqKP60C6Fq7WqwmlYvuoMjkxY0ec6RFFCGW3wSgYZZGw85q/tiO1Z1+Xkaz2eABHN2LW8
	IKb4Lm2SE4YoOTG6GESzo7MD6dXFD3IklmMB8mlOAmZEWIUFDqQBDuKYkmZjKoQ5aInTzo
	FVWq1D9SjMbAXM1JlieE5yEr6VRcyGE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mdaKKiRb;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057179; a=rsa-sha256;
	cv=none;
	b=vfGR/mWsBn3fTs/RokFcooIrxQoebhmnWZiW7HoppKptEGs+4dGER11I7A+bViyBea2dMT
	6rkur4VMnxJlXFUwOwMsb6TAIpeOnUDwmHRKc6ogs8vnY+7itimS0cxSqHvawWUfa/4lB3
	MUEkq6d4OnNFOagrV52ST3KiWZ8buTc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BADD43BDA;
	Wed, 13 Aug 2025 03:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6F3C4CEED;
	Wed, 13 Aug 2025 03:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755057177;
	bh=ENmDFe3lJzYsbCz4gjRO/Qie8EynIqu821IwkBvbcf8=;
	h=Date:From:To:Cc:Subject:From;
	b=mdaKKiRbDaXmZTDoJgJCKxkY0oofdNzLmnyBdCsRbqCJnCKRTc2JT0y5JzeUQxuKB
	 WfpqWLZmHjucdfa5hXXzB8KnpHUVfbYOaNwC1KEoWwO5NkcyrxUMG924uDLbAjbA8D
	 pfv42gmxYv0Ej2d6Fjdv8i4lBNky/3OML/mdHbcE=
Date: Tue, 12 Aug 2025 20:52:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.17-rc2
Message-Id: <20250812205256.7782e2e483a8b12774e65dcd@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C1D57140006
X-Rspamd-Server: rspam06
X-Stat-Signature: mqamqsdaho3abmjkzmyb7roc45m9e1tt
X-HE-Tag: 1755057178-353665
X-HE-Meta: U2FsdGVkX19G6X8KpQRR3OGD/WrhVALM+fZNuxKN4gN3Te/EvB/5MCbNYvlqofw0RDOcHfnol2nUtz0T9Pc60gNiBsmJMODAbTkW59OgOFfPvoRdHca7kw3poIiVFTXhcFbD9GcvYN9UwKK4dsQ+BG+JfG24Pd6BIphqOJbXH3L+kKdK95Ha+ouwwOg36H3M4drzxolNS1ScjDBwIBLNz390gw2ltbB4Rv6rqjjcDCGVuX3dk9sfN0XrWJtaJrcdwpOCrua7ikNETs8TM2IYoO9/RiQTWWhR/LuJQR3O+vhpsu3G9ZaKDkmbTxXEn4BTi1CMctUWjucrTptOD2RE3NMrEqrZMYhpu4NfP4NSVgPxNSdJZ0QbQ8tQ5T73cDHJDiPa4q9+RTx9SfBoaduXBwM6CTgX/5x5uXsz/nbLlFH70wbxLXP3x3av6fyg8KWKLGyiZZXe2vItH7SDzykOSUYKIBy2+cskggW3LVksWt6C/E2DnlRKU+o5n4TouHw5vXfI8bARA0NzsetPFf4XvQZMuw8L3ctJd5uC4IX+M/0aENzF/pSpkLXiAfx5tN7jypjRqtONvbegvwx6K8VDpu5esNZtl6agNTuUdcuBFRu1LEvUaBnOzV2OhZNT2f2T5raqMBYMkjZwuHSNWalrCm7P4tm9mLE1HtIpRpYb9cWaVEs0hyZMtOaznx7OXanf5Ol4c+KWwk5Dr6/RiCajR4AHH9MUnW1ThaCfMen2wTeAdl1hvyeJePIHQURVW+ACWpoeHnazkkP7skXoWQ8gG3T+xW6dMRiwBwFHaJYMSQ8bCnEue59JbjsTW2eCMsJLccFwUT+uWmOTYR2YevxjNnt5Pv7cw0/zxuu32uhlzAvooDcVU2kWxaa1xBPr+BJ/aIsbNKgLYVH4DjVLM/NwGKr6YwoxIS33Pe3SWPkgR+RlyrPT7i0fCf0BZVqiJ9lAvzXLbAg9bc+ObvfEDHz
 Qwk1yweR
 szKpeqcJqLfxHamk+NAwK4ElEHhTlMkA48Glgc0vQm0SF3IIxFwk3ZMc0OxAcfDsewv19F9vFHsa17LsZQxB2z9gj3viDR12ibY76mGuoopBq5ss863BMsAzhMBbQmn9G/e099GrYSNRiUdtDHIjd2PzQrxul6W0UkA4cYCuI+HK4cQbz5JrYkkv5AVtZnJag2pgo+MGnr5/8ty1jrE6hWN7Q6qazRQXJrG1YNM38DXdts09b9FTBL9dEnLDtRxKferdg6UELTQPlErY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please pull this batch of hotfixes, thanks.


The following changes since commit 6bcdbd62bd56e6d7383f9e06d9d148935b3c9b73:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rmk/linux (2025-08-05 16:55:03 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-12-20-50

for you to fetch changes up to c0e1b774f68bdbea1618e356e30672c7f1e32509:

  proc: proc_maps_open allow proc_mem_open to return NULL (2025-08-11 23:01:00 -0700)

----------------------------------------------------------------
12 hotfixes.  5 are cc:stable and the remainder address post-6.16 issues
or aren't considered necessary for -stable kernels.  10 of these fixes are
for MM.

----------------------------------------------------------------
Barry Song (1):
      mm: fix the race between collapse and PT_RECLAIM under per-vma lock

Breno Leitao (1):
      mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock

Dev Jain (1):
      mm: pass page directly instead of using folio_page

Jann Horn (1):
      kasan/test: fix protection against compiler elision

Jialin Wang (1):
      proc: proc_maps_open allow proc_mem_open to return NULL

Jinjiang Tu (2):
      mm/smaps: fix race between smaps_hugetlb_range and migration
      fs/proc/task_mmu: hold PTL in pagemap_hugetlb_range and gather_hugetlb_stats

Lorenzo Stoakes (1):
      mm/mremap: avoid expensive folio lookup on mremap folio pte batch

Masami Hiramatsu (Google) (1):
      MAINTAINERS: add Masami as a reviewer of hung task detector

Sukrut Heroorkar (1):
      selftests/proc: fix string literal warning in proc-maps-race.c

Suren Baghdasaryan (1):
      userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a migration entry

Waiman Long (1):
      mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()

 MAINTAINERS                                   |  1 +
 fs/proc/task_mmu.c                            | 24 ++++++++++++++++++------
 mm/kasan/kasan_test_c.c                       |  2 +-
 mm/khugepaged.c                               |  2 +-
 mm/kmemleak.c                                 | 10 +++++++++-
 mm/mprotect.c                                 | 23 ++++++++++-------------
 mm/mremap.c                                   |  4 ++++
 mm/userfaultfd.c                              | 17 ++++++++++-------
 tools/testing/selftests/proc/proc-maps-race.c |  6 +++---
 9 files changed, 57 insertions(+), 32 deletions(-)


