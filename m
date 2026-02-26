Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B5FFD9E14
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE55A6B00A5; Thu, 26 Feb 2026 17:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBDAE6B00CD; Thu, 26 Feb 2026 17:16:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABCCA6B025C; Thu, 26 Feb 2026 17:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8FB6B00A5
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:16:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F2AC8B2D8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:16:38 +0000 (UTC)
X-FDA: 84488018076.25.BB880AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 76BB616001A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:16:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X1Wf65kj;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772144195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2twt4f2FJmYcN6Pw5QmZNRqw7SJ/w14xOtAZ1HzA/5U=;
	b=3BFqvmMmRDvZv8y4DrRoDEv16MkOaIvCoZWMu93x4MdQhtLWPlIwm1BKb7IQc1mS4A0qq/
	OUdABWfTaEzTNROwxtR04DZkET7WCjn32NEB+fRwGkfDukzwW7jRwViXrq2jZkkR3TyKYt
	uBcMq6fVwvtDIMfk9tPCb2T2LxdA3TU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X1Wf65kj;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772144195; a=rsa-sha256;
	cv=none;
	b=QFDoQ7iqh7HH/PDdDrzqtjrkcDjX6FnzMtEXiCp/Cig7aFfPK86HXNyPilIw+38g0hzUNO
	cb8/7hSvoGVoFaXOZ7+CpKsG8nKrhDpIeOqmk7KS1prgwLnIyi4Yon/ioldI3bDBVmKdul
	OhWLexQLaroYBUl6+WjlNJiUXMzRaPU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65D5B40503;
	Thu, 26 Feb 2026 22:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B976C116C6;
	Thu, 26 Feb 2026 22:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772144194;
	bh=BE0fpb4BhRoem7NlGuVlvqeNimwZSbowvwDgnccDyFg=;
	h=Date:From:To:Cc:Subject:From;
	b=X1Wf65kj8xm3BDnBvQQlzXyKgJ2d7LCGkq4Nf8xLr52BY+yXsI61lTG0PF2taALKN
	 nkUmWNT1ktI5VTO9rYzFQNPcM3bkvIuqFJIH9FJue1jsO0GShq13bms6vH9Jxza9+i
	 m2mjxNvKb4a+V+dqgKBXp0mdxngHsrjmVbzYZVEU=
Date: Thu, 26 Feb 2026 14:16:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc2
Message-Id: <20260226141633.fd525fd4a4fe2c0cc07596f5@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 76BB616001A
X-Stat-Signature: 1zydz43fjzsdxwu7zswom54sd74jsmoo
X-Rspam-User: 
X-HE-Tag: 1772144195-473523
X-HE-Meta: U2FsdGVkX1+/XH7eBsYfugUPQqytOaxcUtWzILAZHlSRmAPm36WULpSQ6dOUO2ulksESxVpMDgZSFmhGtZJl0pv4cQpBkC23FOMsF1Z4xK5U8QZ9Nt7Ss9lGevP3+p+acx6xwf16oD0cRF59JEDpYsheKkzP7VYfoLCw9neyct+mkUB578bsz3Fiku69mqjttKCqOz+RFGwE3x9HDtVByX2evh2KxqUGdN4vibG+nyBOdf9mq9s0tB/V2A7zSt34o6xnNZkdeQGmmMnVfUjVxm+maS5MmjNtLGm6bvU+dchKTscedb+XARkTAfBNbC6p3MKGC3fjlh4yzSPcjj13A57UXPI1LW01WJhd8+U3ONfBsotTlbILZqoFar/GKo/BI139alW+mgqO9a1dJdKOLFrQB1QBoeXswgUQITnyJiICi79szUuiOcB+p9uBuqDAELT8nHJg79gcpGQ/sBnmSw3XZXOoYOKsFfUiz8usAPqQNduZ68ZzpALEqAlNMd7io5/gvuso/pUKeksZyOOpPxpTYoZs74XfdAiwRqmdKvGLFAgycaTSRUGsD0pjU8FxUNZ0C4VQ8hHtYgl/uGhfdqle55hQes7dXMexmyBOS1T3eFNu8CTS1HezWTiK+qSmaMNDJnpClc6YmcZXHHCWDVIIZpLpkK6J6WOPAz+aOMB/V4Vay7LTrKzvySSCsovB54pXj1eTM5LZcrKnsjNq0fzviFNAWSabR49bc6k8WSdxaMqwCjyeLT919Dpm1NSPYJru0yc/NA0cv3dA2CsF/F1GfM+gYImrcy9JTWvWMCrCqH+sYWlgdlQ/JqCw0k7AqGYafNVBnyH/93qzJNv07upExxqPbfKPcmZCw/1DkvQxGCuKZ/jH18QS35RE9fhox6ZAkowju6msIfB2r35R5BvT/Db//A3Sm7Oc85q4CiBgOY6C36sPck6W/2rR9dNLL0rRWOTpVFCsGTS8ve3
 fBeFgk6z
 4C0BCMGjXrjCtaPr3UohYxuq7VMvB/O9z+dywp/Smp/UwfMbMNlQwFGNLhD+pi+7n23Ee1pCUpEkL49qZDAD5bvpBapszJIjWO316KbwffwtpWGyDNZ47OYZnj71fbsQTciT/D8JXgg731bWio5sb+7eeMV8DpLg8cMuduMC0bsdBCSIQAxIgX0LHrsxWA+b2VTTocajr3V9Cxxfub2oVzYY4oF5Ofkbz+LcFyCGnuLstLLYNlWHdWjiTbbwRfrHVAD+F+/89yuT4Gr1/lN6nYqt/lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.



The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-26-14-14

for you to fetch changes up to 410aed670cddac1de4f0c2865f30ec623fd20f78:

  MAINTAINERS: update Yosry Ahmed's email address (2026-02-24 11:13:28 -0800)

----------------------------------------------------------------
12 hotfixes.  7 are cc:stable.  8 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Alexander Potapenko (2):
      mm/kfence: disable KFENCE upon KASAN HW tags enablement
      mm/kfence: fix KASAN hardware tag faults during late enablement

Arnd Bergmann (1):
      mm: change vma_alloc_folio_noprof() macro to inline function

Daniele Alessandrelli (1):
      mailmap: add entry for Daniele Alessandrelli

Deepanshu Kartikey (1):
      mm: thp: deny THP for files on anonymous inodes

Kalesh Singh (1):
      mm/tracing: rss_stat: ensure curr is false from kthread context

Ming Lei (1):
      mm: fix NULL NODE_DATA dereference for memoryless nodes on boot

Phillip Lougher (1):
      Squashfs: check metadata block offset is within range

Pratyush Yadav (Google) (1):
      liveupdate: luo_file: remember retrieve() status

SeongJae Park (1):
      mm/damon/core: disallow non-power of two min_region_sz

Vlastimil Babka (SUSE) (1):
      MAINTAINERS, mailmap: update e-mail address for Vlastimil Babka

Yosry Ahmed (1):
      MAINTAINERS: update Yosry Ahmed's email address

 .mailmap                     |  5 ++++-
 MAINTAINERS                  | 20 ++++++++++----------
 fs/squashfs/cache.c          |  3 +++
 include/linux/gfp.h          |  7 +++++--
 include/linux/liveupdate.h   |  9 ++++++---
 include/trace/events/kmem.h  |  8 +++++++-
 kernel/liveupdate/luo_file.c | 41 +++++++++++++++++++++++++----------------
 mm/damon/core.c              |  3 +++
 mm/huge_memory.c             |  3 +++
 mm/kfence/core.c             | 29 +++++++++++++++++++++++------
 mm/memfd_luo.c               |  7 ++++++-
 mm/mm_init.c                 |  6 +++++-
 mm/page_alloc.c              |  3 ++-
 13 files changed, 102 insertions(+), 42 deletions(-)


