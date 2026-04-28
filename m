Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A7CFF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04BFF6B0088; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3EA96B008A; Mon, 27 Apr 2026 21:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54436B008C; Mon, 27 Apr 2026 21:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D44436B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6CC84120380
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:32 +0000 (UTC)
X-FDA: 84706244784.25.DB58BFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E981140009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQ2vRLD+;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NWty/hlF12CgvRaRF/nMhKmwXx0wH0E0YhaEBbd8EK4=;
	b=gC4se79gvj46jFa3Akfa3vf6Eqd2/b+wua0ZUL4Ze3m9j5mWKzwBYAH8+EfyVQBmJ9mC1a
	i/h19uJEj95K9mSI48fLXN24XcsKWMqi+cp3TeEAw7XeU2OkIgFDuvLnPy1XrOpYymtbHu
	LxZhQ3ml0FB0RRHvIpehMjZixQF7PMs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQ2vRLD+;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340071; a=rsa-sha256;
	cv=none;
	b=Y5UYQyAD9o7q5qDOQd6z401F4517XavlBjbImKxdy9/Aik1Es5O+Fo9yn6zA4iqXxGx8nO
	fp53elCHCBe+L955Efm9mnEeBzjyZ4E6q5F5s7PQpLnck+yn6dtlrmfttebCI85ntMAJbn
	PUcKaYbAnQzKogF9MGLEiyJVOInahxU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E29760121;
	Tue, 28 Apr 2026 01:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E1CC19425;
	Tue, 28 Apr 2026 01:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340069;
	bh=n+vzimhdYGORhqHrb8YTcp6DkxdcV+FsF457fGMq5j0=;
	h=From:To:Cc:Subject:Date:From;
	b=BQ2vRLD+d2F/DyTGmvnvlwCuS5YYE7QfHI/7NJf9yMcGyog2vsgddkY6hexfNssW8
	 W0nA9tyBV2UEi/pDf4kyVNrf5zlKoZwdKYcs6RzfRohZgSkqesEwwlgk5ZkFjqVmwN
	 a1gNT2eNXNr+RHbiwvViVODQixNIpo8ly6zGYfMsGhp0zsYt90p+h/CQSemHMB3/10
	 RAUOZ3Em6mZnu8zPbOpIOmj9mgTA7Jv32WDPIts7tIR6RxAKgWuWI+cZvtt95cF/Aa
	 2zLkZGK2xy/2VnKeq9MYM5A4C5Jw1F03SOviu+Ddr3Bv49aMSPXY3YDUT7NBWQcHAe
	 7GWFYZ/Dw7YDQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/11] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Mon, 27 Apr 2026 18:33:49 -0700
Message-ID: <20260428013402.115171-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E981140009
X-Stat-Signature: 31twkoy6xwzhf6geskxzxdnnfjobepcm
X-HE-Tag: 1777340070-332526
X-HE-Meta: U2FsdGVkX1/gp/EUfymn90Aw3l9jVqv0OfryJtGkXID9ad4igXlQfC5ompIYOHyIyMJJ4melcakzL3YV0gIeZIa1Uj9j5MzMbSTZCTjCxIt135B2qePhbZuSoak0OF+10FlHYMj8l+AQRBW+Yn1nFPbQhWXiIkrsFT951/5w+l5XDRvw7zQeHMHeXC+gR/ktoV9OBhFefPi6ZThFyPMQfEV+OEzMRRqflX9Qqj/9ZqkEh8994uriNhwXi9CyZQAWb/zN3uP69kAkcCEZiL5XLVYW1rJaohfBajNd9Ganq71jNOS9W/pxvqc5srGXENGbVC5AwBSmaPZCWmTyohh8j0JvyezuTzUS+9ov6oxZqDZ/pzeliL1tD5auPR3rdpCRz4kuv33MTNbOp9RCsQy8PmgW7nTR2zh1vJXKWbCIDCYtLq+OOFRvzjGERg81ybqo0yw2K2W2FidMnv9spdoqSvqRMnLzQodnxDWS6+VVaqJRAyDzH8WaVMQeghcVc3QIXD3nhRjOAYv/xmDZO2oIDiJ6/ZriRuu8g8dM29oJ6m7krE1Gz8VgHIsIkcUXyPgwe8TCqmzxmNB+zvwJ3SHVt2ma24bMqAcZqKOJb9uRsdQq/YEsnaEAFxyzkPpiZmoiN2phGFsd2BdgiyPNXkwGZJhtb32vXzzzgJ4AZlhMuF8wFLdnwgo27WsZjOaTmIR487PkGVbPJPzoh7hyhnyBEmnxLp6nqc6GKR07/kXpFMkIfEGpj6hb2qCpwabMLnBoOsrSsKT4AXIh5QAgvvSVA/+OhBIvGdrVsYTFNhVM/0vS0Ytn2pVFSzAR8776OuTtELUj6Qllea2xQgsN4C0xQY5Ed6h8/C4YqIOurzfNn3+6owIi0p3JBQUja4UQRU+Zh1CopVsXH3MuIuy1SmKVURRkIOfAcgpjztFKrEqFaKXx1Vi6IB/VOVa2AJALwubv+zTsQHuSPCx//l+F8gs
 2P9tddPM
 q5BeHWKK9VEThFkEEemByniP6E5Nqc/cpTDYtiZ14mKAs3vMUsQ+jgQkcvVB5AAx4sygVq3ehp3smqjLIxluli6ZEpZTvdONuv4AFyfAt0A9jXzFkVY6brAW2EnBQnneEKME25Y/m6wzDJoXM8CA8ILeiTMy4k0C4g8pYkR3AHOUiI+U8SdGY98vyQ/Aii0jaQ8Qpo9JT5nfuw5Rzs+AN6t9yxO9sr4QvH1MlKHe9L0fT7dA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: Let users set different DAMOS quota charge ratios for DAMOS
action failed regions, for deterministic and consistent DAMOS action
progress.

Common Reports: Unexpectedly Slow DAMOS
=======================================

One common issue report that we get from DAMON users is that DAMOS
action applying progress speed is sometimes much slower than expected.
And one common root cause is that the DAMOS quota is exceeded by the
action applying failed memory regions.

For example, a group of users tried to run DAMOS-based proactive memory
reclamation (DAMON_RECLAIM) with 100 MiB per second DAMOS quota.  They
ran it on a system having no active workload which means all memory of
the system is cold.  The expectation was that the system will show 100
MiB per second reclamation until (nearly) all memory is reclaimed. But
what they found is that the speed is quite inconsistent and sometimes it
becomes very slower than the expectation, sometimes even no reclamation
at all for about tens of seconds.  The upper limit of the speed (100 MiB
per second) was being kept as expected, though.

By monitoring the qt_exceeds (number of DAMOS quota exceed events) DAMOS
stat, we found DAMOS quota is always exceeded when the speed is slow. By
monitoring sz_tried and sz_applied (the total amount of DAMOS action
tried memory and succeeded memory) DAMOS stats together, we found the
reclamation attempts nearly always failed when the speed is slow.

DAMOS quota charges DAMOS action tried regions regardless of the
successfulness of the try.  Hence in the example reported case, there
was unreclaimable memory spread around the system memory.  Sometimes
nearly 100 MiB of memory that DAMOS tried to reclaim in the given quota
interval was reclaimable, and therefore showed nearly 100 MiB per second
speed.  Sometimes nearly 99 MiB of memory that DAMOS was trying to
reclaim in the given quota interval was unreclaimable, and therefore
showing only about 1 MiB per second reclaim speed.

We explained it is an expected behavior of the feature rather than a
bug, as DAMOS quota is there for only the upper-limit of the speed.  The
users agreed and later reported a huge win from the adoption of
DAMON_RECLAIM on their products.

It is Not a Bug but a Feature; But...
=====================================

So nothing is broken.  DAMOS quota is working as intended, as the upper
limit of the speed.  It also provides its behavior observability via
DAMOS stat.  In the real world production environment that runs long
term active workloads and matters stability, the speed sometimes being
slow is not a real problem.

But, the non-deterministic behavior is sometimes annoying, especially in
lab environments.  Even in a realistic production environment, when
there is a huge amount of DAMOS action unapplicable memory, the speed
could be problematically slow.  Let's suppose a virtual machines
provider that setup 99% of the host memory as hugetlb pages that cannot
be reclaimed, to give it to virtual machines.  Also, when aim-oriented
DAMOS auto-tuning is applied, this could also make the internal feedback
loop confused.

The intention of the current behavior was that trying DAMOS action to
regions would anyway impose some overhead, and therefore somehow be
charged.  But in the real world, the overhead for failed action is much
lighter than successful action.  Charging those at the same ratio may be
unfair, or at least suboptimum in some environments.

DAMOS Action Failed Region Quota Charge Ratio
=============================================

Let users set the charge ratio for the action-failed memory, for more
optimal and deterministic use of DAMOS.  It allows users to specify the
numerator and the denominator of the ratio for flexible setup.  For
example, let's suppose the numerator and the denominator are set to 1
and 4,096, respectively.  The ratio is 1 / 4,096.  A DAMOS scheme action
is applied to 5 GiB memory.  For 1 GiB of the memory, the action is
succeeded.  For the rest (4 GiB), the action is failed.  Then, only 1
GiB and 1 MiB quota is charged.

The optimal charge ratio will depend on the use case and
system/workload.  I'd recommend starting from setting the nominator as 1
and the denominator as PAGE_SIZE and tune based on the results, because
many DAMOS actions are applied at page level.

Tests
=====

I tested this feature in the steps below.

1. Allocate 50% of system memory and mlock() it using a test program.
2. Fill up the page cache to exhaust nearly all free memory.
3. Start DAMON-based proactive reclamation with 100 MiB/second DAMOS
   hard-quota.  Auto-tune the DAMOS soft-quota under the hard-quota for
   achieving 40% free memory of the system with 'temporal' tuner.

For step 1, I run a simple C program that is written by Gemini.  It is
quite straightforward, so I'm not sharing the code here.

For step 2, I use dd command like below:

   dd if=/dev/zero of=foo bs=1M count=$50_percent_of_system_memory

For step 3, I use the latest version of DAMON user-space tool (damo)
like below.

    sudo damo start --damos_action pageout \
            ` # Do the pageout only up to 100 MiB per second ` \
            --damos_quota_space 100M --damos_quota_interval 1s \
            ` # Auto-tune the quota below the hard quota aiming` \
            ` # 40% free memory of the node 0 ` \
            ` # (entire node of the test system)` \
            --damos_quota_goal node_mem_free_bp 40% 0 \
            ` # use temporal tuner, which is easy to understnd ` \
            --damos_quota_goal_tuner temporal

As expected, the progress of the reclamation is not consistent, because
the quota is exceeded for the failed reclamation of the unreclaimable
memory.

I do this again, but with the failed region charge ratio feature.  For
this, the above 'damo' command is used, after appending command line
option for setup of the charge ratio like below.  Note that the option
was added to 'damo' after v3.1.9.

    sudo ./damo start --damos_action pageout \
            [...]
            ` # quota-charge only 1/4096 for pageout-failed regions ` \
            --damos_quota_fail_charge_ratio 1 4096

The progress of the reclamation was nearly 100 MiB per second until the
goal was achieved, meeting the expectation.

Patches Sequence
================

The first two patches make preparational changes.  Patch 1 updates fully
charged quota check to handle <min_region_sz remaining quota, which will
be able to exist after this series is applied.  Patch 2 merges regions
after applying schemes is done as long as it is ok to do, since regions
split operations for quota could happen much more frequently under a
corner case that this series will make available.

Patch 3 implements the feature and exposes it via DAMON core API.  Patch
4 implements DAMON sysfs ABI for the feature.  Three following patches
(5-7) document the feature and ABI on design, usage, and ABI documents,
respectively.  Four patches for testing of the new feature follow.
Patch 8 implements a kunit test for the feature.  Patches 9 and 10
extend DAMON selftest helpers for DAMON sysfs control and internal state
dumping for adding a new selftest for the feature.  Patch 11 extends
existing DAMON sysfs interface selftest to test the new feature using
the extended helper scripts.

Changelog
=========

Changes from RFC v5.2
(https://lore.kernel.org/20260412161957.82835-1-sj@kernel.org)
- Rebase to latest mm-new.
Changes from RFC v5.1
(https://lore.kernel.org/20260411164908.77189-1-sj@kernel.org)
- Add missed mergeback fixup.
Changes from RFC v5
(https://lore.kernel.org/20260410142034.83798-1-sj@kernel.org)
- Merge back: merge whatever if it doesn't lose monitoring infomration
  and not violating min_nr_regions.
Changes from RFC v4
(https://lore.kernel.org/20260409142148.60652-1-sj@kernel.org)
- Fix quota-sliced region merge-back issues.
  - Use damon_for_each_region() instead of damon_for_each_region_safe().
  - Avoid merging back of sliced but scheme unapplied regions, to keep
    the monitoring information.
Changes from RFC v3
(https://lore.kernel.org/20260407010536.83603-1-sj@kernel.org)
- Make damos_quota_is_full() safe from overflow and easier to read.
- Avoid quota-based region split making too many new regions.
Changes from RFC v2
(https://lore.kernel.org/20260405151232.102690-1-sj@kernel.org)
- Handle <min_region_sz remaining quota.
- Document zero denum behavior.
- Fix typos: s/selftets/selftests/
Changes from RFC v1
(https://lore.kernel.org/20260404163943.89278-1-sj@kernel.org)
- Avoid overflows in charge amount calculation.
- Fix/wordsmith documentation for grammar, typo, and wrong examples.
- Improve unit test for more consistent comparison source use.

SeongJae Park (11):
  mm/damon/core: handle <min_region_sz remaining quota as empty
  mm/damon/core: merge regions after applying DAMOS schemes
  mm/damon/core: introduce failed region quota charge ratio
  mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
  Docs/mm/damon/design: document fail_charge_{num,denom}
  Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom}
    files
  Docs/ABI/damon: document fail_charge_{num,denom}
  mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
  selftests/damon/_damon_sysfs: support failed region quota charge ratio
  selftests/damon/drgn_dump_damon_status: support failed region quota
    charge ratio
  selftests/damon/sysfs.py: test failed region quota charge ratio

 .../ABI/testing/sysfs-kernel-mm-damon         |  12 ++
 Documentation/admin-guide/mm/damon/usage.rst  |  18 ++-
 Documentation/mm/damon/design.rst             |  22 ++++
 include/linux/damon.h                         |   9 ++
 mm/damon/core.c                               | 103 ++++++++++++++++--
 mm/damon/sysfs-schemes.c                      |  54 +++++++++
 mm/damon/tests/core-kunit.h                   |   6 +
 tools/testing/selftests/damon/_damon_sysfs.py |  21 +++-
 .../selftests/damon/drgn_dump_damon_status.py |   2 +
 tools/testing/selftests/damon/sysfs.py        |   6 +
 10 files changed, 236 insertions(+), 17 deletions(-)


base-commit: 5f9ac1ae1aa2393af99ee45c09c991b20087a9be
-- 
2.47.3

