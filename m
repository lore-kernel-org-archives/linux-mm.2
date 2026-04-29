Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC7DFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1922D6B009E; Wed, 29 Apr 2026 00:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A046B009F; Wed, 29 Apr 2026 00:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F866B00A0; Wed, 29 Apr 2026 00:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB7E26B009E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:13:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32F2112064B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:40 +0000 (UTC)
X-FDA: 84710272080.01.8105C72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8C645180003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R4YNR7uD;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777435958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XKxt+pKxaif6bz5GvhvQC1hjS9tKII9vJCYWxiSDDkg=;
	b=GsMmq6QVAHCcWwNJ7l1UWBLGPsG6jvx22MhmJN80NUwG9ZorTPCizd2WP7SXqWAr8aHeDQ
	/azy+hiTNl4Sxv00aYvz1dBjSyfYbEvRveL1mRabmAIO8M2GZdHgw64PVs4H3U5N4QR2Bc
	kOfOoAqkIXHOayWingg2Fi8Q7dAY5AQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R4YNR7uD;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777435958; a=rsa-sha256;
	cv=none;
	b=qKJgWf1RxXHVtfxAVkdHh9RqrmTo7Hob/mW/zzxM9E8mrHWakJectSNQt2lpFw76CVfmmB
	eKttP1Jnzq9JAb49U6uX904LyBGYBfeg3IqyG2RnL0g8oi5G588+7MxubN+94BMH89+tqJ
	oT8PPX6TA/j9xxyj9LvT/Bu2bKb8ZIU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3576A41578;
	Wed, 29 Apr 2026 04:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CB0C19425;
	Wed, 29 Apr 2026 04:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777435957;
	bh=RCIYZP1Msb2RTI2SpfpPltIJeD6RApU3Y40MYAqfhiI=;
	h=From:To:Cc:Subject:Date:From;
	b=R4YNR7uDsz9ma88wFhsLog/autlmAYCp9r4i/R/c6j8wSh28uod14qZe7792jWfi8
	 4IP7GzXzZcORJ0kJhktIv98nrGV6asZpmyuJ6WPF68fyMzKTLjMmYC9SRS8MWB7qZf
	 9xJuWjKgmlCR49qXkFFIeC7CsUKsUN9HzoJG4x1EvJrnhRVS9qvd4ekDqBc6yAGi6B
	 0+KzQA3KwSW+dV9nLXG6Ux9Fti4WvBfLVNJHid7+/N5aWmqch92y5rm3gLYVatpN+/
	 gkVzjyITojlmDehfgwYIDLyXD+7XE5ILvmBWGKorDuyWIvJ8SK5AwJHgoHv2bokLzg
	 v8e+74YDPAT8A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 0/7] mm/damon/reclaim,lru_sort: monitor all system rams by default
Date: Tue, 28 Apr 2026 21:12:22 -0700
Message-ID: <20260429041232.90257-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C645180003
X-Rspamd-Server: rspam06
X-Stat-Signature: zmqgmm33xt1dq8ru1n6iogcjn7qzirps
X-HE-Tag: 1777435958-957154
X-HE-Meta: U2FsdGVkX1+iRpUKIUHZ+sDTxPrTveMRp7aoGfudiVxjQ/zPNRs1enOPcNBEJ+jojBpRyU4tVqx8IHvMZnrVLjyH+osGZTk5IT4SIr9DSrufARoznRRQ7Za/hPw3qdQ3zUrAfsDZjAuvTcixuREqLqQpmYWPbtR6Im4e5jH7I590y7EEt5wVR4JUabRgunhGc6NLrlCZ3+B8k7rV07GEyqDNhU3UpLVCTAjUy83X4ssVRdMv7o547x5u5dCzMvlkJ5SVDMMPzaZRjqdpdgIMcwgeoCUB4rg10UpaUFXcZcsj2tAN1tlXaUZcZILsFZPKuLpj7IDmL+u0k2VTVkPeJEDpLJF2h6E5B6iO3rX7YCH2Dde3kAgIvXWvspzB8mtaXorrJCgsKsBYVLYAzPUjtZR01/PVBL7uQ1cIS03iZF7Ob2ZgOd7JXAPHFgkNQvvYMxTbpyznzfl+Y/FkFLGs4fZuEwJhQq/ibFTcRRzh7DgIuTmew+ractUTy5z0UUCDwmG3jc/NH1lCwbAi5WqOqLoxorYwn/720xSwrlO7RYwYv+FndcUkTziLZzn0W+0UFmidekvYhWgXLuaQC1q3gyZS9SzopLGrNFSJJy61PnE6WpXF6fCr4AdnDHYA1S8onvvjR07Vb3/Zwj3JxD5wn9XVqM8MdPwujs6ovf0SOuIBSQOrSAk4Agt/EkwWPfhRMXBRp91fBnHOIbQAfTBcJEyP3ZQeRIrXvayGzV8tG+MvwWkzZt5nwXuhri9rpBBTj0LmsUSbG6gr559f9b98UppYWrd/ls0tMb7Ug4dG2CxduRAZ5DOETKPvjbOCHpF8Ea9Xo/iQ9iAVrE/Qzta1qWCz34C+fL2xi/M6C4iLKziCuMZJciTXpM8AHpm3jQtL3LLhcC+/Nt3mkZA2LE+SHjVIwP5CaN1OjIp0Vm2W37NBJ5Wx0zQAZQGY11mv0e1s6cAH/UnNYB6fmOkNZJK
 ED3XLxcq
 r40YDLONJXrr4FCb7ZrB2NQS8HOJ0fiMw+jylRjMCr/QVgP2Nv/UEaM+P+pld+CpulU9Xf3XRVgzpCSsc5ibtyXUX8hCq2+kLgfb8xERkkulrUxHwnBIdYqIySOqFR53ZDYcOM6btbtiaRLZn/ubE52acxWH3AtECginOMGEEQygN4X9AWpJzMZ9gS3WaaRyuSvxNEpfPZSNGq4RANZNkks6DBfBj+aVFewwa4jqIWaZKNM2JCl9U7olhGhXHkLXKHRsLN9oO2YbilbnLc3kXnP1FmQ==
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

Changes from RFC
- rfc: https://lore.kernel.org/20260415012048.76508-1-sj@kernel.org
- Fix typos: s/phiscal/physical/

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


base-commit: 01b1d4a72970ced030ffe246ba99c961c746527d
-- 
2.47.3

