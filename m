Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 150EBCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 19:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3788D8E000C; Wed, 22 Oct 2025 15:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FB28E0005; Wed, 22 Oct 2025 15:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28CD78E000C; Wed, 22 Oct 2025 15:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12EB48E0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:45:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F23513BF27
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:45:52 +0000 (UTC)
X-FDA: 84026780544.01.E75A1B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BDCFB140011
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:45:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tmDh3B5Q;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761162350; a=rsa-sha256;
	cv=none;
	b=abPLlNNe/9YiwcOgyZAHkuX3POWlJ8tNsoWcT79kUNoGL9PtdKckSdDwZ5OdcFjUmiI0ay
	6egWhTrMyrROunPTEec7WA3hb6PjidYSz+IS2PDIHtcKswHIn/SbRXZSnxEw/LdRjh0bad
	kSEKaIiEdNa/i0xQKQ9ZYgBEmfFhG+I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tmDh3B5Q;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761162350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6+wdlb+rMjyEPEhuErTElI/Clk1IdfbS/ZYe3Bmqz1I=;
	b=XATqeSBMYh3fnK2ZrR/S3knVFxZuP9vNpCVjZXZ4YWyNXaDu9YsKbH2BrNcXU4UZxiVRrN
	p0xxyZGo3iBMAMtoggV833eUNL6ERUpy1KoBIdsFmUCgBbWz398G8aa8om2ulWD7iIhZUX
	vf+aWocwaKKSc13pOjJqHl4APaQDgrE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BEAF4A094;
	Wed, 22 Oct 2025 19:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F574C4CEE7;
	Wed, 22 Oct 2025 19:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761162349;
	bh=BhrdWlrWjrxxxCFVIJZR3Y5rtQjATk4Iozogb7pSrYU=;
	h=Date:From:To:Cc:Subject:From;
	b=tmDh3B5QWQdj9aWhhJA+vZ20tQwAVdcPPo6xtHJ6xsW7/J04SUP3vLa3DKNptpTki
	 Gvf9v0TkTvCQ9G8TkWH2ooOqhtCLRMOzqPZvGidP+Tdc6Wj7tw9EN9zN4bf7X9dno1
	 +sRvxc9OFqpko3NnQa4mATd6SMmXdwimegArOGok=
Date: Wed, 22 Oct 2025 12:45:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL]  hotfixes for 6.18-rc3
Message-Id: <20251022124548.a2bd1335de33d5d2b7b2fcb2@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: gwtbawqw9szs6yhujp7njczwa389ophs
X-Rspamd-Queue-Id: BDCFB140011
X-Rspamd-Server: rspam09
X-HE-Tag: 1761162350-555930
X-HE-Meta: U2FsdGVkX1+IZLY3IgTyXbTCuek3O32lMIi3OuC6B+QLLmfXQws0Bn6JnqRQAI0bqfQ7Ew6ODHQwl1Hz1oTfxhj8aBstNLcbdlSwGo276G0DnCSY8bTgGJnhebUx3s+D6BRKsToHYZaddNT8KskFxG5oMIOMiF+NJvHZAZ+UuYTU01UQ2Tx4yL4RbEmlZeKMLu1TJASVbdGne6LKUR/BC+B5pl9it7Pe1JVD1IOwz6a/0FBcodFUgJp2bA5w6V96bkyuo1BJyfHNQCXG1asg1B6BuEPb5dWz0iVwrD1V1H+4MdtOit30nFyxBdkjBofaPkOISMuKzn4XOGSCIXvzQc8nNk/0A0guIDTusETRdtvn3bt2b9e3YlXR7vVbb1bO9GovjAboefCC2it/PLum1LmY1ZuPMXiinqb7XOrdKdWJk9XkWrtJZNiqqW3eV9HUMBlhJGSxNeGhPcmdplRiSr110knb6D9OBwbaGQ5ABrmfTT3rTqekPOXSKArw/H7LTmCbTvpzVsGnrLxZOTwyqWHgzB+HxecsuEv+EQ/3afngn+H7AVxCYc8rVsThxpf+aGzsXjCl/eOlAiFRHDrMFYxSIK3lr7IjsmesLvhilzTnh1lV+VPNMs1NA6conDC3luPGLNX3QBLDepVvaB/TBtcsJgZ+1zY1SqBHYrXQnrhhWlvuofuucMJiE2sOQijkaV84E7FA56zfA8LeI/2SeomMDiNdy5JGj/KIlwAUS31GBD6cvWUhMRqUjiblXWKWmidYfMJ6/5LpX7EcDk9n9ri7k8ZawyYWu2ZzPwSvee1aV/hEk5N2oDYHgR9AwI/5tm+4zshdOAG2H0E7Zds89PX26VJfd9+wS9eLI1tvRGpLEJLBFItalK3c+RiO3x34nnk7BOUTE8C7moEda/wwKrKLRCB6Z4L7q//vPDwWvx4xs9cPnyPQ0kMiSivAGhndm9yb4+Vjz5FmvuhmNCs
 dcElu9jT
 kKOJtT63IjlLCIJmbxFjPt2+Bq/2z3aR58CDPaYVqAHgWAkMVVyV6IIRmsKd/znqDcIS68g3sWjCiCHd4Gq18F2WObMedBGBMwE5SrgvDZW0zXrnFJopItkXzfTRQ6W4glAFRZ+DDibAc6Sgn6h/8sFvBWjmqrvYoIVMEz4J2fzSVV4MOOav1009iHdtwM8ymANHB0/sYuTjx+sxIHTrsGYgBnB423nc9zxWE1e40x1wX6l+oHbW8cib78kQ2lE5BP/6JoURZ5/PwFxqwPt/TyZBOBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes for the current -rc cycle,
thanks.

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2025-10-22-12-43

for you to fetch changes up to 9aa12167ef1149d9980713b120ddcb31cf17222d:

  csky: abiv2: adapt to new folio flags field (2025-10-21 15:46:18 -0700)

----------------------------------------------------------------
17 hotfixes.  12 are cc:stable and 14 are for MM.

There's a two-patch DAMON series from SeongJae Park which addresses a
missed check and possible memory leak.  Apart from that it's all
singletons - please see the changelogs for details.

----------------------------------------------------------------
Alexei Starovoitov (1):
      mm: don't spin in add_stack_record when gfp flags don't allow

David Hildenbrand (1):
      vmw_balloon: indicate success when effectively deflating during migra=
tion

Deepanshu Kartikey (2):
      ocfs2: clear extent cache after moving/defragmenting extents
      hugetlbfs: move lock assertions after early returns in huge_pmd_unsha=
re()

Enze Li (1):
      mm/damon/core: fix potential memory leak by cleaning ops_filter in da=
mon_destroy_scheme

Lance Yang (1):
      hung_task: fix warnings caused by unaligned lock pointers

Lorenzo Stoakes (1):
      mm/mremap: correctly account old mapping after MREMAP_DONTUNMAP remap

Marek Szyprowski (1):
      dma-debug: don't report false positives with DMA_BOUNCE_UNALIGNED_KMA=
LLOC

Qiuxu Zhuo (1):
      mm: prevent poison consumption when splitting THP

SeongJae Park (4):
      mm/damon/sysfs: catch commit test ctx alloc failure
      mm/damon/sysfs: dealloc commit test ctx always
      mm/damon/core: fix list_add_tail() call on damon_call()
      mm/damon/core: use damos_commit_quota_goal() for new goal commit

Thomas Wei=DFschuh (1):
      csky: abiv2: adapt to new folio flags field

 arch/csky/abiv2/cacheflush.c         |  2 +-
 arch/csky/abiv2/inc/abi/cacheflush.h |  4 ++--
 drivers/misc/vmw_balloon.c           |  8 +++-----
 fs/hugetlbfs/inode.c                 |  9 ---------
 fs/ocfs2/move_extents.c              |  5 +++++
 include/linux/hung_task.h            |  8 +++++---
 kernel/dma/debug.c                   |  5 ++++-
 mm/damon/core.c                      |  7 +++++--
 mm/damon/sysfs.c                     |  7 ++++---
 mm/huge_memory.c                     |  3 +++
 mm/hugetlb.c                         |  5 ++---
 mm/migrate.c                         |  3 ++-
 mm/mremap.c                          | 15 ++++++---------
 mm/page_owner.c                      |  3 +++
 14 files changed, 45 insertions(+), 39 deletions(-)


