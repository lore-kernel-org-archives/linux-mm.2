Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14C8F9D0FD
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B638E6B0092; Tue, 14 Apr 2026 21:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13FC6B0093; Tue, 14 Apr 2026 21:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02856B0095; Tue, 14 Apr 2026 21:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AA886B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:20:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EEFC1A0326
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:20:59 +0000 (UTC)
X-FDA: 84659036238.16.AE2E52B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9609160009
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:20:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oPy6geJV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776216057; a=rsa-sha256;
	cv=none;
	b=L4anrmdlhBXDctiCnOtB5S+Al/loBvjUpO3COWo17ah5lp86pK+iL23Voi5SaSqK9y/lXK
	UN4TkyUzuB/aMdfmW3S8eX2VqXkJjzEt8Q5YdFiGxstPblyQCoLRM/sl5weHMkZTgFROTm
	/jo439eg8ayLgqNVquzXk0p2dv8PMRk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oPy6geJV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776216057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WktzHuGs5lEztIo5R7RHaDIyeCMd1IRqWb1SdVIcgng=;
	b=3/pBTaehbNXYKny3at2Xrl/so6Tk0kieX9EGyV//dXk3g+AFAs26WmUsAAMefJwlQnGUwR
	s4S20rlJrJXp6hUc/RC7srsFCux0+9YGzkfe7EH/LtgLkkz+42Sgr5oaf+OwrK5uoQbNDp
	z3nq8DFx3kptiZpJQ7pzirAANZphgA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F2773600AE;
	Wed, 15 Apr 2026 01:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE52C19425;
	Wed, 15 Apr 2026 01:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776216056;
	bh=/73a6Fauu1hEXPiMbtwap5gMqcffhpJAS00bzrE8afg=;
	h=From:To:Cc:Subject:Date:From;
	b=oPy6geJV/ZHcgYgvAer8Ya5yKvPgZpm82wb4uqkM8lofq/CbDh6mcjnSalolMex7n
	 PHC0xCJQn9O/rXx/6JTyW8BG2m3wuB6pOBIUZTvfOJzYqLjyY4WvE5MyEKftMrNw8q
	 ady5yDxKOulIcFGxzXWt3kVbv+h7G6ejvUeIrwVdXiyyGu6bdtpK7DoshDOLlJtI/A
	 Yd25okJYBOeZiosBAyEEuSqoiMiUIAUSW+UWxkNneK+yD0wGaVvckUR7+z2Jzc22Qd
	 sxEsOwtPKL4kZyBon4M5lwIoU9d9mYyst9r382UrADOf/qHsM7cqDM/CObHK0VnnlT
	 DsN2Lt/LkN22g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/7] mm/damon/reclaim,lru_sort: monitor all system rams by default
Date: Tue, 14 Apr 2026 18:20:28 -0700
Message-ID: <20260415012048.76508-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B9609160009
X-Stat-Signature: qm36ugj59fyk7ydho4x65qy85k7bszum
X-HE-Tag: 1776216057-659735
X-HE-Meta: U2FsdGVkX1+gsa107bGQdOU7ljHpF2+a9H9YIVRSWIlkon85wV41fzO43VmqgpeNm27ImC1INQReLle1mQwq6Is5j/R4UKHCfH/sGpOl83I8oA6egcIwJCPh7XfogucKXiEYZRLnHr5d4N+xvww2Adz81FcKHK+EoW/q4APZN0Xr+22pr8oVBSr08A1Ozh26rvZnHMpzlee+Y10qgCvGZCq6mFMs2cjcRC5oYRPdlqhGugOzqggYjUG2kCaN1YZoioKhn1TrAHC/tO/mv13Rstur2nOVNrCIPvY+GA5AnTN4sIHDVIJatWWtSALyoNOqGcUyKkHbtzfEA5QN6BMvErmxRzSxECZs1JfZBGT4sX1gwwvSV/tF8ygOg8yFG14qUQxNwzu1VSzdWk7SleCf6fn2Ds7Yfiiw5LabhbtcIni/PqCFLd0NNZblIdn7rERxLnKCvYF1AFY/BQtclNXVIdiXreJRP0w55NuEkO8WR62SzC/0+jNGSYAsD/ZrGXr/04BWsFfkxYqjRG5an57Y4Ke+K1BqU+yIgXWji7gsarXsKUAzZzXat/K7TG5W2HrQEkPXXCUVL01S0u5sfPUZEqjtkh/MPshy4EZiMWXeX7TBjBRiYIk0+md7qBxFx/SJqUL0Ma5CG3NvZ6FeUkaKJUKzzKby6acLedBtPL75BIP5pCCZC8YGR2HEoolmEDGPyjwThTYAsWxrDI9mgTGbbjbd58QqBTbWNRwGKJ7QY6Mx8jxluFXfS/stGYy2/EPS4+s03Ijx6Vx/p3lff4+a6rBvVw/W0V3+SmGJ43iniVoM1phLxWs33WFt9sRWhOSbzPjNNw41Eh6Nn1JTLCNpAyL4ne+DrqliLuVyfR+s4L2abTjYTuhq5C1zeg1E6TvEJr+uEOYXnVhqhQQN4NA/4HHkoGp1ZiblvUa8iKVBSICldQ0NdLhDR2j+/whYE3zvFRZV7ceANXe1PMmByEq
 HOmd9o+C
 Nd3/eC4oAQ4pEmGgchRvEW9IABP+VBPzXUi4d78PjQIPjWMg2bnwiWMDpSrshotutWdtwe0JFWJTYiivmUbGjCbjsHR92idiOlSakrmvdgrCeH7XN0r9N40e6jY24KNJSEstHUfb5tIJ5yHqZasWIwCTDL0soOMQ3m3CxDg1025HCl5qYiwrhnoMTElnrKYXBBgviUw51xUwQgSUgtE4c7v6yHMi/FgEz1+4807M7xCRXn8F4+Zu+MQKJBPEDgM8RvvkO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM and DAMON_LRU_SORT set the biggest 'System RAM' resource
of the system as the default monitoring target address range.  The main
intention behind the design is to minimize the overhead coming from
monitoring of non-System RAM areas.

This could result in an odd setup when there are multiple discrete
System RAMs of considerable sizes.  For example, there are System RAMs
each having 500 GiB size.  In this case, only the first 500 GiB will be
set as the monitoring region by default.  This is particularly common on
NUMA systems.  Hence the modules allow users to set the monitoring
target address range using the module parameters if the default setup
doesn't work for them.  In other words, the current design trades ease
of setup for lower overhead.

However, because DAMON utilizes the sampling based access check and the
adaptive regions adjustment mechanisms, the overhead from the monitoring
of non-System RAM areas should be negligible in most setups.  Meanwhile,
the setup complexity is causing real headaches for users who need to run
those modules on various types of systems.  That is, the current
tradeoff is not a good deal.

Set the physical address range that can cover all System RAM areas of
the system as the default monitoring regions for DAMON_RECLAIM and
DAMON_LRU_SORT.

Technically speaking, this is changing documented behavior.  However, it
makes no sense to believe there is a real use case that really depends
on the old weird default behavior.  If the old default behavior was
working for them in the reasonable way, this change will only add a
negligible amount of monitoring overhead.  If it didn't work, the users
may already be using manual monitoring regions setup, and they will not
be affected by this change.

Patches Sequence
================

Patch 1 introduces a new core function that will be used for the new
default monitoring target region setup.  Patch 2 and 3 update
DAMON_RECLAIM and DAMON_LRU_SORT to use the new function instead of the
old one, respectively.  Patch 4 removes the old core function that was
replaced by the new one, as there is no more user of it.  Patch 5
updates DAMON_STAT to use the new one instead of its in-house
nearly-duplicate self implementation of the functionality.  Finally
patches 6 and 7 update the DAMON_RECLAIM and DAMON_LRU_SORT user
documentation for the new behaviors, respectively.

SeongJae Park (7):
  mm/damon: introduce damon_set_region_system_rams_default()
  mm/damon/reclaim: cover all system rams
  mm/damon/lru_sort: cover all system rams
  mm/damon/core: remove damon_set_region_biggest_system_ram_default()
  mm/damon/stat: use damon_set_region_system_rams_default()
  Docs/admin-guide/mm/damon/reclaim: update for entire memory monitoring
  Docs/admin-guide/mm/damon/lru_sort: update for entire memory
    monitoring

 .../admin-guide/mm/damon/lru_sort.rst         |  6 ++-
 .../admin-guide/mm/damon/reclaim.rst          |  6 ++-
 include/linux/damon.h                         |  2 +-
 mm/damon/core.c                               | 49 +++++++++--------
 mm/damon/lru_sort.c                           |  8 +--
 mm/damon/reclaim.c                            | 14 ++---
 mm/damon/stat.c                               | 53 ++-----------------
 7 files changed, 50 insertions(+), 88 deletions(-)


base-commit: 11bcd10460e9446785fc04deb5d175806a00400b
-- 
2.47.3

