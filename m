Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF3FC87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 01:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAE68E00D1; Thu, 24 Jul 2025 21:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2A28E007C; Thu, 24 Jul 2025 21:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF858E00D1; Thu, 24 Jul 2025 21:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E10B8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:05:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B3431DB61E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:05:07 +0000 (UTC)
X-FDA: 83700993054.27.E6F3E34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E83DA8000B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:05:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HXP5UqLi;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753405506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9DY9zSrjxnI4tno1NsONmm4QHg6nR8eJiRfauUt2LzE=;
	b=H5ix9i3/7TGMH/a0secChp/Zr4S+OFroV+6HcgKEG0HqbwjCtFh6eR+86ATkc535H9WtEk
	lkKAqzil01ZtgoFB+Ls4cB80xmZTVKqZMHTposifN782o5JAPfKMM+8g3J+vrjGZ01aHtc
	Xz96K8q7yeHFEYPxpiLZS5Sf5dzFXng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753405506; a=rsa-sha256;
	cv=none;
	b=no1vpkEo7zo0Lx5kvyuMhNbD4Pa1zGMYQYMN2Q1rhk0FdSQzyCGOSkIcE7T5Fnoa8eV5Qt
	9m3cuoDhwQwVk9J8CE3oafOoGybWiA1s6Yz4xPE9PuwWKDmAPikpwkb2vooP7Y63kuxAvH
	WXoKMbcE/ccX0XJAnq/hMf50cHaysNw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HXP5UqLi;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3D2343740;
	Fri, 25 Jul 2025 01:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA5EC4CEED;
	Fri, 25 Jul 2025 01:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753405504;
	bh=tAi5yNbVWJZar85JYgxMKocAfRchNPvqbGllAqQ8wQY=;
	h=Date:From:To:Cc:Subject:From;
	b=HXP5UqLif1X61lXGPABx2KAbUTpnbRg6hpTtBn2nMNaygxT8Ase/sMQtr+pAG10nO
	 b3LAKC0oGKgS28/tNtifcdkHB7Kat3YQBizSFC9avU4m7SBa85DKyk3DqtQV+Sxb2C
	 N0HOhwDaozGo8fO7kqrt6Y122N85kyQm6kJK8UJg=
Date: Thu, 24 Jul 2025 18:05:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.16
Message-Id: <20250724180503.a8a80b0b0c904c1c7f967448@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 65kjh46oe7d4gz6woze5y1sh8wowoohk
X-Rspamd-Queue-Id: E83DA8000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753405505-76396
X-HE-Meta: U2FsdGVkX1/kZCkSOPL9oy5lO2Jqvc3FRobQZvf2i3JN9wku5NGFGTaRomFs2v45ECx4Gs8STzbLG+H7qYvKn3Si9tuGN0rlyT0EwqsnruXuAN/wTM/uOewh2OrxXPOISkR66m9o4sGF1tM1UmSCj04oXCZVm/IydsoshpOCt6fH7NuOnHcNRlx7zu2J4XsZCCfIr6hBYqCb4cLCJqLg+upr+tEcLOdJGL74xaki1rhiuyJ84uy0O5lJBXaLwBxO1KlFs6rxcxO/8EpQ6Alpjnz1MkOl/8J+1dG6evv97iJswX4HeQZGtNWYgRA2q58jv6yHwmjAyIDLbLfz6hpb6jTZq/8D3ZAJ29ucn2Ps2ldbI9jLnbTjVYu6T05vEfe26le5K0RWo6kKXL3/4jqRnUxfDJmy518D10LbKVIfHc/l0cwemrBBZ+nSTBiRqvkChPjl1FdyKQIFN5d2hSuBEZ7qvpKU3n5HFb4RLFQQL7kkXRflN3gOX/wkELpW843woOJE61mVn8iyg1yBn0M4SkfCrW+kK45RANbUPa66pOLGR+4TyDgZX3+E+uu5R0DSqM6vnkn7hbjEDJ2RAp0g4JnnmEgpnY06cwcHafLoyCeIPQzaU9ZC7NV6KvK88VHdLRRb/ib08v+oPM38/UJoaax+VIQUcWW3L5x6WOgcPvt7sU93mXHghnm0Bk1veWqjlp0K4yLi4RkFQUVJk76CPUluZ/MYRSzqCn0iPn4PUbLXt8k0o8NCXavJo2GS1wueXrWln5KTg7UcAPANM9C8aY9z4gcwAjwMGgIuPoGu6/SzGdxtKX0LI1Elo2B+V1aVpRIQ2PkCn3lMOYGC1ABfUw4PkIsOf1gnHBt4qSxcF3Xj7+4J5BzH1+zgK5ojgyqnjV6k7XhZ4O/8jiJwI4/HUmlwaZF/jPTA41m66k3NYdrsq/GyLy/lEPTsAJ9ErDCL1wUxekEMDydn+UVhXER
 nmzUx05A
 0skJC6jjhbKZu40SAbGejgvR6rvRMdvr3i4Hiv7afpxFSL1RbSE8kzwrpCei6xctkUwuu1Xupvg84MqoX/tUvxPSRMshy9a0RQSC7WsYQnj3dpbpZuV3MUC3jHGO30ZbNF9d+ZT3I6aeM0apJfERMwsb0I0c1h4Y1U0BIoQJtC0MGUvO9RepLPx3pvcMuXNuIwJx1PQPIwAHfRGCOUdRpBVwOpzUNmPu2mZEsclMl3SChvSAcC51mpNTEVMwc4IK5lDz+cpjHkzGc5Xs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please pull this batch of hotfixes, thanks.


The following changes since commit db6cc3f4ac2e6cdc898fc9cbc8b32ae1bf56bdad:

  Revert "sched/numa: add statistics of numa balance task" (2025-07-09 21:07:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-07-24-18-03

for you to fetch changes up to 0dec7201788b9152f06321d0dab46eed93834cda:

  sprintf.h requires stdarg.h (2025-07-24 17:58:00 -0700)

----------------------------------------------------------------
11 hotfixes.  9 are cc:stable and the remainder address post-6.15 issues
or aren't considered necessary for -stable kernels.

7 are for MM.

----------------------------------------------------------------
Akinobu Mita (1):
      resource: fix false warning in __request_region()

Harry Yoo (1):
      mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n

Jason Gunthorpe (1):
      mm: update MAINTAINERS entry for HMM

Jinjiang Tu (1):
      mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list

Marco Elver (1):
      kasan: use vmalloc_dump_obj() for vmalloc error reports

Nathan Chancellor (1):
      mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()

Ryusuke Konishi (1):
      nilfs2: reject invalid file types when reading inodes

SeongJae Park (1):
      mm/damon/core: commit damos_quota_goal->nid

Sergey Senozhatsky (1):
      mailmap: add entry for Senozhatsky

Stephen Rothwell (1):
      sprintf.h requires stdarg.h

Zi Yan (1):
      selftests/mm: fix split_huge_page_test for folio_split() tests

 .mailmap                                          |  4 ++++
 CREDITS                                           |  4 ++++
 MAINTAINERS                                       |  3 ++-
 fs/nilfs2/inode.c                                 |  9 ++++++++-
 include/linux/sprintf.h                           |  1 +
 kernel/resource.c                                 |  5 +++--
 mm/damon/core.c                                   | 15 +++++++++++++++
 mm/kasan/report.c                                 |  4 +++-
 mm/ksm.c                                          |  6 +++---
 mm/memory-failure.c                               |  4 ++++
 mm/vmscan.c                                       |  8 ++++++++
 mm/zsmalloc.c                                     |  3 +++
 tools/testing/selftests/mm/split_huge_page_test.c |  3 ++-
 13 files changed, 60 insertions(+), 9 deletions(-)


