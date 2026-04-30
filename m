Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6846FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 22:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8450A6B0095; Thu, 30 Apr 2026 18:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5EF6B0096; Thu, 30 Apr 2026 18:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AAA6B0098; Thu, 30 Apr 2026 18:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58AFF6B0095
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:42:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD67F40204
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:42:01 +0000 (UTC)
X-FDA: 84716696442.24.41CB072
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2BC09C0009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:41:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KtQf8hxz;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777588920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AhXspHVJ0aPjrnDzi5apJ/Np+ujm+YlrRt2IOonH3TU=;
	b=Bk/Hb9Qy0qHsJBeEX7RNfGMasDoUW0BDRiNyIPlRVC2hUfePCcxUVoKHtLMn3yUHgZqxhd
	9ui60yJyrmUF2/GTufi1VSl1w8DoCsxKofAJxR20LKJxiNiHbxiXWNI6JuzuRnL6yVJODG
	tTmsQc7eABGDEjxxwBqBgPdOgZRq7W0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KtQf8hxz;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777588920; a=rsa-sha256;
	cv=none;
	b=QjRXQJPV8s20uNxuu1MfDyPm6yuAjZmeIepzEuNzCvpnaLjl6OXmTe8E/ggDAgaZf0URe9
	kRd/kt/nxeG4kzx1z20xOXTx9NQDUeSeRBYE5IjWRpdftsPCQ2JmgRxCjIEbA6x1c0Nw6I
	G5lcdW4W1P14TtQViVrsMzs5LdtVZNo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F040843676;
	Thu, 30 Apr 2026 22:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B469EC2BCB3;
	Thu, 30 Apr 2026 22:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777588918;
	bh=Zpkg7ICr3kV+8T36Pv6VLyLhBdhfgU6eFlshvNHL7Rk=;
	h=Date:From:To:Cc:Subject:From;
	b=KtQf8hxzxa1umru6qOYk1rwl6aZUk6ARl9uDyc6Uf7f+OBGRBprCukpvBRpZmzbDC
	 eBKFgZOxuadaPBjMhUmzQ4bLXRJs5WE39YL0UDuSvbb/ldBbqoxUXjmT6AUXgxCj0e
	 dVmVDJvJxLLbrh7ksjQxdSvYSTmtbThpxZ3caF4I=
Date: Thu, 30 Apr 2026 15:41:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc2
Message-Id: <20260430154158.4739147fd0129804c9e6766a@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oqry9qcx5yobzu5ntx5u7seemxegqco7
X-Rspamd-Queue-Id: 2BC09C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777588919-705200
X-HE-Meta: U2FsdGVkX193ULbixyP/uzojQk5iPRHJoKauuGFosRij8YtK9661KiW7+q1PYDB/jRuUGg2mKV1yMeJZ/8PE10olUHqlRDv/HtkkjFnw0kt+hCe2lZkGdW4Xdw961cFv8ZZRezyFcmSIQdJ8o/hJRabQtRMriS3ZDnSV0qnxzeKeTkWD95c2CExVKGIV9Gk+hNcbfhxMFTniTwGMss0KIRWyZSRJulCcY0QcbsnQ28dtLU+jl3bG3wj6tr6IN+quBIHgEeo4lG0U3N2K2Difq18lLpRZkHa5f1wcGaq5CEHGSKYyc7k2rLSWj+aYg4DwfGrHQBFWtLi57CxJgAENaV/cBUvZwVUyhp2Pzn9zMZuLVSHfATW8w8EZjKXNSi8yyejus5o4t/CGczOGHVxocqOc9V55VH57S4XIvQeiYbjEthQNtFtEf6d3iRLfMgHs9ixDFwljsaOA92z1pLLbuU3P5YmXo9sc55L90va3a7TDYiP8MzICJXk/wlGGDBVb//BmRRemMmw+gCDr58/WRqz4fiiUv/oUN+oGCZxJbgLR47P57XHwtpjunGlQMUBJ/WT0dPXwmgj/OTV1IRvO0MWXE/5yOP+R/ytZF5fhAPIZl1efe+Bv9HXco9kckIz8B2xmHJVMGXnZog5JvC8BVZBAus6X2Adp8B6NQX5gPyp+QZgLn2sUrdkZtV1f6MI1mhK+f1ET8kud7mHZkf6BQm7Z1fXC8Hfy+GIw1sqSMwSwY38pUoOUrs15qO+AF1GtNtNv64tEDkauLRuVXmBAvAHZz6vv6r+cOWOGoamKaCJb8Ebpw9wegUBw4SjW2wfujAQ83LdwFZnNkdPgeMpB5v2mtd78LwZbT4bp+gjxDSazhz7o7QM1GNjtcOEsfdGjTkM4qt16WNykay0Ak7o/zfwNQnAQI7RolH5SI064wQyueXNHxLqkngmYRC3DoRtOG60sKfY1Xijbp7JtYIN
 NG3I+Tg5
 RzdWQHd3yu0nnl8fi/woh/gTBx76TzYY3ZeT8eTeL6yOBpj22Lp1hUrdoY+7UOlGndljqchoNeqsjCPNWMCkF7lk2y8f91Np0vbu/leBtEKxl5NvM3KlThh0gu4yKP5VD4kt2SHG6eYHPa05OsEYldpbUVctEZVjN+Kw25CqYQijBKdntpPZHPzYXUfjgwrYgBWq8Or1xwFpr8J0GLPzvuMz73UZykW5iZNdtWjvsBlnpMCBvQHYTXsNfrH8G8ZXRhOpgUY1NUTryHEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-30-15-39

for you to fetch changes up to 99ebc509eef52675ae5bae86aa2a53e15594e4a3:

  mm: memcontrol: fix rcu unbalance in get_non_dying_memcg_end() (2026-04-30 06:13:20 -0700)

----------------------------------------------------------------
20 hotfixes.  All are for MM (and for MMish maintainers).  9 are cc:stable
and the remainder are for post-7.0 issues or aren't deemed suitable for
backporting.

There's a 2 patch DAMON series from SeongJae Park which address races
which could lead to use-after-free errors.  And a 3 patch DAMON series
which avoids the possibility of presenting stale parameter values to
users.

----------------------------------------------------------------
Breno Leitao (1):
      kho: fix error handling in kho_add_subtree()

Dan Carpenter (1):
      mailmap: update entry for Dan Carpenter

David Carlier (1):
      mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()

Joanne Koong (1):
      mm: start background writeback based on per-wb threshold for strictlimit BDIs

Li Wang (1):
      MAINTAINERS: update Li Wang's email address

Liam R. Howlett (1):
      MAINTAINERS: update Liam's email address

Lorenzo Stoakes (1):
      mm/vma: do not try to unmap a VMA if mmap_prepare() invoked from mmap()

Marco Elver (1):
      vmalloc: fix buffer overflow in vrealloc_node_align()

Mark Brown (1):
      selftests/mm: specify requirement for PROC_MEM_ALWAYS_FORCE=y

Pasha Tatashin (1):
      liveupdate: fix return value on session allocation failure

Pedro Falcato (1):
      MAINTAINERS: fix regex pattern in CORE MM category

Qi Zheng (2):
      MAINTAINERS, mailmap: update email address for Qi Zheng
      mm: memcontrol: fix rcu unbalance in get_non_dying_memcg_end()

Sang-Heon Jeon (1):
      mm/hugetlb_cma: round up per_node before logging it

SeongJae Park (5):
      mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock
      mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock
      mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
      mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values
      mm/damon/stat: detect and use fresh enabled value

Sourabh Jain (1):
      MAINTAINERS: remove stale kdump project URL

 .mailmap                           |  5 +++
 MAINTAINERS                        | 30 +++++++-------
 include/linux/maple_tree.h         |  2 +-
 include/linux/mm.h                 |  2 +-
 kernel/liveupdate/kexec_handover.c | 21 ++++++----
 kernel/liveupdate/luo_session.c    | 15 ++++---
 lib/maple_tree.c                   |  2 +-
 lib/test_maple_tree.c              |  4 +-
 mm/damon/lru_sort.c                | 85 ++++++++++++++++++++++++--------------
 mm/damon/reclaim.c                 | 85 ++++++++++++++++++++++++--------------
 mm/damon/stat.c                    | 30 +++++++++-----
 mm/damon/sysfs-schemes.c           | 24 ++++++++++-
 mm/hugetlb_cma.c                   |  1 +
 mm/memcontrol.c                    | 29 ++++++++-----
 mm/page-writeback.c                | 16 +++----
 mm/userfaultfd.c                   | 12 +++++-
 mm/util.c                          | 26 ++++++++----
 mm/vma.c                           |  3 +-
 mm/vmalloc.c                       |  2 +-
 tools/testing/radix-tree/maple.c   |  2 +-
 tools/testing/selftests/mm/config  |  1 +
 tools/testing/vma/include/dup.h    |  2 +-
 tools/testing/vma/include/stubs.h  |  3 +-
 23 files changed, 262 insertions(+), 140 deletions(-)


