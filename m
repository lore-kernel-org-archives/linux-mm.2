Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C03C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 01:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B829A6B008A; Thu, 10 Sep 2026 21:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D596B008C; Thu, 10 Sep 2026 21:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8386B0092; Thu, 10 Sep 2026 21:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA406B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:13:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCF1EA4F22
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:40 +0000 (UTC)
X-FDA: 85199709000.09.C73838D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 456D240003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i81ukWa9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i81ukWa9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789089219;
	b=S98XKVfAlccsM+KCmY6T9YIZzhab6vLN5y7Q69UN1whv59dyRlOAoOGPrtBYVB8+3o9sKB
	dE1JFI9EWbhcTulwuSOIUPu9qVLYcvTAICFR9HZIH6vYkWI7yV/TmLJtTZUxOowpDzTH0z
	T2naMHiOuTvFYoMfKeD8kxzk7tXWE0I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789089219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GpC4gk3m7cdW8BgHK5/ON6FM2LXn4NcAQ6pZC9bl+OA=;
	b=PurmligaBbRX+KVruR4P9c5bRIQPfv1EYjlLBC4TnkYmlPpSQxgDONIPHzfY7/+MoZSQkl
	GH3yVX2AAZ6vddXc/R3k4llrpHrm46IRM56XsM8USrlxTCIUzYNxS96Mftj5oSRSXg4byz
	BNk9g8Vj18yGyM0aiZQiY1s7BOel0Ek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 859BB601F0;
	Fri, 11 Sep 2026 01:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5AE1F000FF;
	Fri, 11 Sep 2026 01:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789089218;
	bh=GpC4gk3m7cdW8BgHK5/ON6FM2LXn4NcAQ6pZC9bl+OA=;
	h=From:To:Cc:Subject:Date;
	b=i81ukWa9Q8JIQisy8BbIlRUyfGpX8D/Ju1bddEZSQ5Q69K5NkvMY8hw/Rpfe888Ut
	 LXV/H+SvyWR5vCLtUjEW0BgT889s0GxDMZ/Rd0H0tK3T4JaDs0HeTnC0oUXRnOXMy+
	 xoq9eYpPf8TFaUQ0TDhT9HUS+TgI5YyCFSCZ9vBm3PIzRNKBUksZ8RNELqGR257FRm
	 GNbrUFj8ZnOrHnpgK+3E1rDDsCWnEGolNsynUi1G/2/WnHcPyfn4whYL0DnMidsY07
	 hKLax3gjw39Qcfv5Ttopa50mPawvYixzfSmQLTMwg6OFc675qTPyFkEEEUJzlRtcng
	 +8h29SO/AW4pA==
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
Subject: [RFC PATCH v2.2 0/7] mm/damon: introduce probe_hits_wsum DAMOS core filter
Date: Thu, 10 Sep 2026 18:13:21 -0700
Message-ID: <20260911011330.93678-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 456D240003
X-Stat-Signature: 15ff4z6qm6wofe4cecozxqt7ndd8hwme
X-Rspamd-Server: rspam01
X-HE-Tag: 1789089219-276273
X-HE-Meta: U2FsdGVkX1947M2RCUA7mmxuAfo62r8BQO4ESWzMqBkn8M8ghZ/SPebtISzBoULE4X3EyJ4Ivsslum0dCSHvdo37OuMoRgzO2rGD4X+ydFlffdRqXh4SM18CDTB/djVZCpXBsxvJEzM+CrMYT47DZaHCY7STBAnDxeK5YhzM25zC6ILe7tFJnu3lfbpQfRdL3Mrvjm085DFZyS9tOGOTTj6Bu62hQMu//gdEtiVOKicpguqKlZp0f8SadtnXf6b8+xQCxBdU1Ysh3vH5noS+w9UqUfzAvaLMzdW1IvtOsLLQTILt1TT6P83DtqaHQFZ2epHCrjJUZMqy/PJMWxXEsVj6Z0W8ArLznnWPV1n7KihNKP4bNIS9XbS1JlsV7MfZ78OnTSWdqaIEuP4Tstg7BmjJT7KDehFp9R5Nxt5uEr6vRDZeYHQaMJcZyV570rAzky2M+F70JlXYLKmTl+LGONIQYeosMTH+0ULUp7HP2FWD8jYr8ZT4JXrmVSZdKZSTIQSGVrzczYGFaYZwOsBL+9XHGCa/PQ2JX5avBuQa0Fs+3pNslBQKnJBbOW3k2GV2m363g4LAnG2Rrcm7TAy5cCMBbsppUoXxThGBZeRHDpmWET0o1GMo7ZIVPKsDTCZvVQPoPrPlrNy4Tugx8aw0p3GDF3/KC1EsTG4XZU4KkiAcNgHpUmrCI16swS2JHGUnw+l1kRotUzdYZfCaL1ihkJ+uN5N3nH0fVSWy9zvM6kjyO9/7FZGhS/GIX75rnk6NICbZAWEppTsYS6ErfRIyIeNn7aix3VPpqJlgqxP7PhnTreNZk6KteyXt7lthaQ+rVsN8Ro9hUPH38VqqXcKDsSGzv7saPkGwNOALV2MyV8v8bkc/kmQLNCQQQQyL4W+ZB6V4UQOSDEkzAC/HQouCAmM/NdWOy+qtVLunIJOnZk+GtwkiSBu1ps6entFeb4wmfL5WMLeyOdlyioOG7dw
 DIK59k/S
 M3XTy2QZwkpnrFadEkAJ9c3qdWkhNt4maOQPOhY3Kie8M1LzlZ57pVoZhnoDGObRa3fBWegRjOa/AQfaizgdHif1+sH3J1SEAkiD/wW/jDy865K/YaAeTcNwXuHrLfQCRQsJC3aYY5ajoI60sawrOe10Xp2MYPqREeuaFZEaYYgL3JtXB0N/mCWgyeiLtEVMal2BgX33FwsqOehu9Bf/qoethdcnluuAM9Mcp6ERuc3BilFeouNzszMOrBd0DNDaHGFjBGH0BOLCc/RGWblGexDib2J1I1uP64fgV
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

Changes from v1
- v1: https://lore.kernel.org/20260910141849.170896-1-sj@kernel.org
- Validate {min,max}_range sysfs input on local variables.
- Add RFC tag again.
Changes from RFC v2.1
- RFC v2.1: https://lore.kernel.org/20260910040319.147037-1-sj@kernel.org
- Update kernel-doc to clarify probe_hits_wsum is a damos core filter.
- Drop RFC tag.
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260907171218.101430-1-sj@kernel.org
- Rebase to latest mm-new.
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
 include/linux/damon.h                        | 22 ++++++++++-----
 mm/damon/core.c                              | 20 ++++++++++++--
 mm/damon/paddr.c                             |  2 +-
 mm/damon/sysfs-schemes.c                     | 29 ++++++++++++++------
 mm/damon/vaddr.c                             |  2 +-
 7 files changed, 62 insertions(+), 20 deletions(-)


base-commit: d07c4abd83baebbe6dcc351c519292cddce024f4
-- 
2.47.3

