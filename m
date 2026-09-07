Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E17DC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE716B008A; Mon,  7 Sep 2026 13:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F7A6B0096; Mon,  7 Sep 2026 13:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D456B0098; Mon,  7 Sep 2026 13:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52C876B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:12:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E433A14026D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:27 +0000 (UTC)
X-FDA: 85187609934.09.068750B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5EC3B4000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="np/evmUe";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788801146;
	b=XvtbS6PCUq15pIDxvAjJoxRTnh50YLDX8h08pv7XGTksSe6IRJun0LtqnMUNiRd1PeahMl
	rdTtyffMGiSNkydqpYAkM4ER0exhGeidqtjLKPGO7HpZisOUYjVfINBuyLTibcKQ1tMj4N
	BYKF+MFCsH5RtooxYw5NaNed0at4vm8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="np/evmUe";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788801146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y4p31XPgokx2qGPPsP878fh0V85lBvlTq2ciEbDGO3U=;
	b=7+QGZGEVAwE0wPKJpa53UlD3fR/f8DO3pdm2vZY1811wwy36EkWPPtWERjXfaQ3GLQNoBD
	pm9MSQrV6DXSKlfqZmdUNt+3blmg0Z8AaPlHnGevOeyetx66WeWzh1gQZj7ApGiR92+8qx
	yK4IjeG14MH55veqbNmwFbNWz1H6lZ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3D59601DB;
	Mon,  7 Sep 2026 17:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099081F00A3A;
	Mon,  7 Sep 2026 17:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788801145;
	bh=Y4p31XPgokx2qGPPsP878fh0V85lBvlTq2ciEbDGO3U=;
	h=From:To:Cc:Subject:Date;
	b=np/evmUeNjelzFmw9xTdA+JsbGs2ltTV2QDwKxwAcVeIdX6kt3gku2vENsL3wRZRk
	 eVZB4+X8aRVXmz7mM/V0LTwoH+hqtzMzpW3ElsYo57KVgxbasBMregeE6v7eSCG3jx
	 aYyN014d7bUA9dBcRPw39EfEIBlPJtomNq+he3HqOAKLRmptzRzj0VgteoTyFq0dnh
	 Uw2DNz3W4uYLrkOmjbRJtdkkc8/zmzG/O3pCVMU952hdHp3i9sKLnllmyF3ss8fcPb
	 4700rT65guzgVUEa6HlwV6MxJKGDAcBHWcm/Y87JulXMeB6vY0AgnvfG7GuaUSSmqE
	 AM5vIJc9hyCiQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/7] mm/damon: introduce probe_hits_wsum DAMOS core filter
Date: Mon,  7 Sep 2026 10:12:09 -0700
Message-ID: <20260907171218.101430-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5EC3B4000C
X-Stat-Signature: q9quk747a86x97ga4hz8t1tq4gah3bth
X-HE-Tag: 1788801146-697586
X-HE-Meta: U2FsdGVkX18g/seKEOr6ovJCw0AHh9acqcZSvwAax956vORn8vD+qEc997mnoI1oTix01GVdFTlEguwFAdhjPTIsu6TeDuFiOGSWeIJbiGDPAL7c3DhYyZxVzEoFrU/Q28yVj6sVgrtmX6C0H3HWvVVVgIuU3XFonxxT0fNn6ivnJ2xSKCE0Uc4OFellLWvGT3fuOMFOAVpSKQHgMEwrVnWKjjLey6LGG5No0Pz+V68Qdd3aO8A9no3I2zE4kU1AoiURx632hXnV19vulyboIZUSfCZufC6WB+2195TS/ib6g8jqoayKit+OLrqZCsVsHOh15wfUqa0wi2/04bGw+s6sqWnQm17VPunUmd+bLVNYqplvGkDjL3OjY2t+QuROzWrVqRXTRP8Kayrh8WNWRK8OiH3W06WZ6jUN39ZIBkn0LOLJNX2x9WFm/YtEpJRcE3Foci9Mtzo+uR1QfwFJ3L+Wfg3OZg0mSyl2gS40P/Q9h6aYoC/RuEdO6p9At6BFrpVMxKIA7i7/8ZVmip+HWdQ6Jaa4L05pL9wd3CteCsjJLtfXTE3VAOGGbBLOATI51hC1Q43VQK7ZIsKSv7GBGjMQvHJ6Cq5Be8Ozrc0nkEhmMT/Emy2w5G9omKGNQ6jFGHPftgzCHaWqxdNVmhwOgtXgnACTi1SvrYxRzuo/+ZN++5jG1jZEGAvx0pkY3fQMnzaXR8Bup2mFgoo4Xt3SNpNknkiMHoS+zbri4/NNgcEc9++1RRh/+rhIp/Uy9snl1fCpeP6tzZFY8d1wNZk1OqyHBC7tkCqwViE7qyWyaSL8WHrUv5aRHncePXdVdX2I44whnb3Q3QZiSdO6yavgwfWhQmP990MNstUUCHoYFo1qSTeiryR5G1UK1uaS3Cc/voJ/EELQV4Xk5kipCd/kPj1Tc1/5L6SjRxJBfSXrplyLsEiKQCeASYbX74cG+Z28VMGSICCAko2GoHl3h5t
 mff8jlOp
 Axl5wHLvVqqUYOc4kCfR8Lu0WWVXtgXmzdsrYU3rRlPTATMGdDdCrTV15A2TXJMsz7RKAowS2/lRFYKdmwVlZoAEqA16JqFaqkJ9w8rU6B9b12IkRVtIJPHo8V3vA2Uw7PdWi3TxuJNBnPpRVIvCf3K8rxcakjni5kW+WgCzYDAQ+fAY/AM/yf8dj80OxKkofFdnDYSIrx/eUrrH+W1LGL5ChQTP0Hws9ptN5ksVjAOjnzEr61//PAwDhAuhvetlOTTePFhGJlv+nYOAuk8PD6D8KasduMzxRA/xW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON can do flexible data attributes monitoring.  The classical data
access monitoring can also be done using the attributes monitoring.  The
access event is just one of the data attributes that DAMON supports.
Users do monitoring to make some actions based on it.  DAMOS is a
feature for automating that.  However, DAMOS cannot utilize the data
attributes monitoring results.  It is still Data "Access"
Monitoring-based Operation Schemes.  It requires users to set the target
"access" pattern.

DAMOS core filter is effectively the same as the target access pattern.
It is just a more generalized and flexible way of describing the
operation action target region.  Introduce a new DAMOS core filter type,
probe_hits_wsum.  It specifies the filter target based on a range of the
probe hits weighted sum.  Using this, users can apply DAMOS actions to
regions of specific data attributes pattern.

Note that the classic target access pattern still works.  Hence the
target nr_accesses range should still be properly configured.  The new
filter would be used in only data attributes-only mode.  In the mode,
classic access monitoring is just turned off, and therefore nr_accesses
of regions are always zero.  Users could simply set the target
nr_accesses range to include the zero nr_Accesses regions.

Patches Sequence
================

Patch 1 updates the DAMON kernel API for the new filter type.  Patch 2
extends damon_probe_hits_wsum() to do the calculation based on moving
sum.  Patch 3 implements the filter type in the core layer.  Patch 4
refactors DAMON sysfs interface internal data structure for efficient
reuse of data structure for the probe hits weighted sum range user
inputs.  Patch 5 updates DAMON sysfs interface to support the new filter
type.  Patches 6 and 7 update design and usage documents for the new
filter type, respectively.

Changelog
=========

Changes from RFC
- RFC: https://lore.kernel.org/20260906210513.106895-1-sj@kernel.org
- Fix kernel-doc typo.
- Use moving sum based weighted sum.
- Fix wrong range saving field names in sysfs.

SJ Park (7):
  mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
  mm/damon/core: extend probe_hits_wsum() for moving sum based
    calculation
  mm/damon/core: support probe_hits_wsum damos core filter
  mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to
    range_{min,max}
  mm/damon/sysfs-schemes: support probe_hits_wsum damos core filter
  Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
  Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS
    filter

 Documentation/admin-guide/mm/damon/usage.rst |  4 +++
 Documentation/mm/damon/design.rst            |  3 ++
 include/linux/damon.h                        | 10 ++++++-
 mm/damon/core.c                              | 20 +++++++++++--
 mm/damon/paddr.c                             |  2 +-
 mm/damon/sysfs-schemes.c                     | 30 ++++++++++++++------
 mm/damon/vaddr.c                             |  2 +-
 7 files changed, 57 insertions(+), 14 deletions(-)


base-commit: 48856ec5bf2f614ff3ef647bbf7cc605faf8c977
-- 
2.47.3

