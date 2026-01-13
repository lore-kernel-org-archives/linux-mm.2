Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD1CD2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713E06B0089; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4D86B008C; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539826B0093; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28A736B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBE7C1A01A9
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:33 +0000 (UTC)
X-FDA: 84327319986.05.076B421
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CB6C1C0002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CNkBCAAu;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=exopNKgwfEFAmWeKrFQXfPiB9vdU+UhvQm9FyWM1RsM=;
	b=Ti4cMBtk0a21qxirtlYGm843EW9cwwt4LVeN7JwT3JXcQr2O67uchi37bGwRpIUgobmPrd
	nlfBWPnM6DZkNPgAA+TUX1ZXTjcwh78lNpx6d6WXArUtQevZ/MKMP526WyUHv+wII0kpSX
	ZOnvPDNrXsL7mLq3l0ArO2Ty6BuQTVg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CNkBCAAu;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318051; a=rsa-sha256;
	cv=none;
	b=dIJ+4K3h/RFzEIh7OshFhskCiE7R7+NK+RaVC05x2UcTc+21aUkQ+bdGVbQcK14tJG1AZL
	pontP9v2LrD7lszsF002unFR4hDhwQIAyB5Djsd2yIRy/KtcgfR9CxTU2OqhBz4SnFZKLV
	4+e2EmYMNcgtcD9zoTBrkbZ7lWthqZE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93B8560018;
	Tue, 13 Jan 2026 15:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A412C116C6;
	Tue, 13 Jan 2026 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318050;
	bh=9B4uMGFwloAk5ZAEn3IBwWCzYGd064BJjvrO/dS6ItQ=;
	h=From:To:Cc:Subject:Date:From;
	b=CNkBCAAudUv4/3USgBu/lTnxxryOMiV6WwUq/uGyfscdpNEgyE3cCYRMIpRisUv+x
	 nqC/IishGpRJ2VNhWc1T2ba1KSoHxv2RjWc7JTaVNYMRg3bi+fyENeylR3WlKTeKwH
	 PV/g11CNxfMyh3qLtbroljLGm7xMlru9UGMoFJkefj4Cekr21WgPUUUzd9dd1PRK72
	 Lw/ChIay2KTD/fciRkKC+jjSqrTYwR4mDuxYUQvM5tuZNgugf/SA2KBf/Ml7u8PYta
	 bdTnCk5MrBWh6LwHNfWzRq8+JhCqNog3Tbown+vhGy8Su5/3/q2Al+KVijWVQ5LcKg
	 uNcMvRe07LzbQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/11] mm/damon: advance DAMOS-based LRU sorting
Date: Tue, 13 Jan 2026 07:27:05 -0800
Message-ID: <20260113152717.70459-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8xyjfiy6cewhdmfszyoxfnpgqjswo7bm
X-Rspamd-Queue-Id: 4CB6C1C0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768318051-481775
X-HE-Meta: U2FsdGVkX1+2CcOe8bfpnr5lasVcLgKEE8Amu5YDz6//kyjBakXceWFSr4P0TIwM00XZQ24GsxP4F/6a2+rmX/RlKcz1LF9+AbM0jaxO3XE0im0CoTWPnJJqIzAUQb6SbBwMDn+UhSp9qgr7akOONrH/66rnk4VB7c7D1sBGkrilJeUDNtFG5ITyYHBjvGK4uJZt6I0SLEs4Ez2seyHduiDGW17ryLpyDgav7q25AQdo8488UZipOu35Ks8YRXPDzvQY0n3XES1M+O0p0/iUTIO5PckqiETCTTlR83QxBvgZS4zR6TsFcgkfWr0XI9sJ/9u4soyGHLDwoHZ85Xgu8uIyDAAfvxIF/uAteDA1IvPx12CrLTHNCMPF1e0sENWkrfbQPPD3ke85vf075pQF+xMZuqZqnI82M/7ovEvAol9c/seoxApzz4pmkMtFt76mDSAcpzs0z5Bk5tG78K73SjDHTfwcJITcxswEVdI1gMwfsquzBAzQwE2hquWdYBKMR2BWzTOWgn3udgHWSAlFihv0nFi7nqB/cKzMSslc4OpNDi+FXW/p50vj0XE0qPuquYALhaIh7vgEcYzBm6tO6LWf7/jzEkJBPYPMyja1Rff3CFkL5Ct28mBlFPiSrQ4ttObYQq4lT1CHI6M6Vb31Y/To9WwtdVJp7VYyxbFxUEqlr42mEVrIXclPYLcVNVN1O5DoOud/JGr3v6Z7FOou+XSl5jgShH5pVEB85HMI2vxPSoNhCXCyREVnBpVl4O/+bcN7dUwVqpSbGXGt9h3kLtXGZz5++NPvzsLr2hxWSoXvG+7LrT9VaQ+bCeAv9IS2ApmgdSXAC3ZPR8OZFaPqG38ZBG2uaa9CtX0ooo5WwwDzyYhVw0jl/AKO8Av2blA+B0LsDCqn7wufXkf+zJyy2ix5+WlRNwaa7mqQJkd3cDja+nzehWjeRC0gWImMBbTqgR784nVyxx0MFTBnT5o
 4vUYGGlJ
 OQpKQ/f5fklHRdCxC/PHvokxhQt2akTgFT8ztBipiR3PK+JklWi5txr8kVOcSeq24Fd0t+pwOp9+J7ZvzJpXqPM85LNAVizKKYvlH5bcTMxdje5u/8IYU0Ex5Rp/gQjqsBq+guW9cSjJ07sX1Zv2Jzb/J0uMhSPTeRhZQqjpQdkgZGcloa7oSs7o1QSqyXjZwEaW1FW0XKJ3avDv+oycKAazuQ7KEyDUONwcc4kUBVDYWQ+8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS_LRU_[DE]PRIO actions were added to DAMOS for more access-aware LRU
lists sorting.  For simple usage, a specialized kernel module, namely
DAMON_LRU_SORT, has also been introduced.  After the introduction of the
module, DAMON got a few important new features, including the aim-based
quota auto-tuning, age tracking, young page filter, and monitoring
intervals auto-tuning.  Meanwhile, DAMOS-based LRU sorting had no direct
updates.  Now we show some rooms to advance for DAMOS-based LRU sorting.

Firstly, the aim-oriented quota auto-tuning can simplify the LRU
sorting parameters tuning.  But there is no good auto-tuning target
metric for LRU sorting use case.  Secondly, the behavior of
DAMOS_LRU_[DE]PRIO are not very symmetric.  DAMOS_LRU_DEPRIO directly
moves the pages to inactive LRU list, while DAMOS_LRU_PRIO only marks
the page as accessed, so that the page can not directly but only
eventually moved to the active LRU list.  Finally, DAMON_LRU_SORT users
cannot utilize the modern features that can be useful for them, too.

Improve the situation with the following changes.  First, introduce a
new DAMOS quota auto-tuning target metric for active:inactive memory
size ratio.  Since LRU sorting is a kind of balancing of active and
inactive pages, the active:inactive memory size ratio can be intuitively
set.  Second, update DAMOS_LRU_[DE]PRIO behaviors to be more intuitive
and symmetric, by letting them directly move the pages to [in]active LRU
list.  Third, update the DAMON_LRU_SORT module user interface to be able
to fully utilize the modern features including the [in]active memory
size ratio-based quota auto-tuning, young page filter, and monitoring
intervals auto-tuning.

With these changes, for example, users can now ask DAMON to "find
hot/cold memory regions with auto-tuned monitoring intervals, do one
more page level access check for found hot/cold memory, and move pages
of those to active or inactive LRU lists accordingly, aiming X:Y active
to inactive memory ratio."  For example, if they know 30% of the memory
is better to be protected from reclamation, 30:70 can be set as the
target ratio.

Test Results
------------

I ran DAMON_LRU_SORT with the features introduced by this series, on a
real world server workload.  For the active:inactive ratio goal, I set
50:50.  I confirmed it achieves the target active:inactive ratio,
without manual tuning of the monitoring intervals and the hot/coldness
thresholds.  The baseline system that was not running the DAMON_LRU_SORT
was keeping active:inactive ratio of about 1:10.

Note that the test didn't show a clear performance difference, though.  I
believe that was mainly because the workload was not very memory
intensive.  Also, whether the 50:50 target ratio was optimum is unclear.
Nonetheless, the positive performance impact of the basic LRU sorting
idea is already confirmed with the initial DAMON_LRU_SORT introduction
patch series.  The goal of this patch series is simplifying the
parameters tuning of DAMOS-based LRU sorting, and the test confirmed the
aimed goals are achieved.

Patches Sequence
----------------

First three patches extend DAMOS quota auto-tuning to support [in]active
memory ratio target metric type.  Those (patches 1-3) introduce new
metrics, implement DAMON sysfs support, and update the documentation,
respectively.

Following patch (patch 4) makes DAMOS_LRU_PRIO action to directly move
target pages to active LRU list, instead of only marking them accessed.

Following seven patches (patches 5-11) updates DAMON_LRU_SORT to support
modern DAMON features.  Patch 5 makes it uses not only access
frequency but also age at under-quota regions prioritization.  Patches
6-11 add the support for young page filtering, active:inactive memory
ratio based quota auto-tuning, and monitoring intervals auto-tuning,
with appropriate document updates.

Changes from RFC
(https://lore.kernel.org/20250628165144.55528-1-sj@kernel.org)
- rebase to latest mm-new
- add test results on the cover letter
- minor wordsmithing and typo fixes

SeongJae Park (11):
  mm/damon/core: introduce [in]active memory ratio damos quota goal
    metric
  mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
  Docs/mm/damon/design: document DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
  mm/damon/paddr: activate DAMOS_LRU_PRIO targets instead of marking
    accessed
  mm/damon/lru_sort: consider age for quota prioritization
  mm/damon/lru_sort: support young page filters
  Docs/admin-guide/mm/damon/lru_sort: document filter_young_pages
  mm/damon/lru_sort: support active:inactive memory ratio based
    auto-tuning
  Docs/admin-guide/mm/damon/lru_sort: document active_mem_bp parameter
  mm/damon/lru_sort: add monitoring intervals auto-tuning parameter
  Docs/admin-guide/mm/damon/lru_sort: document intervals autotuning

 .../admin-guide/mm/damon/lru_sort.rst         |  37 ++++++
 Documentation/mm/damon/design.rst             |   4 +
 include/linux/damon.h                         |   4 +
 mm/damon/core.c                               |  22 ++++
 mm/damon/lru_sort.c                           | 110 +++++++++++++++++-
 mm/damon/paddr.c                              |  18 ++-
 mm/damon/sysfs-schemes.c                      |   8 ++
 7 files changed, 189 insertions(+), 14 deletions(-)


base-commit: 7a1491b1b0a461872951e8fdf885fc243f67f5e4
-- 
2.47.3

