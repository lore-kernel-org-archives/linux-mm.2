Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A780F3ED58
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4CB6B0089; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386226B008A; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275D06B0093; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14EC56B008A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68144E323B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:29 +0000 (UTC)
X-FDA: 84646860858.25.1D2088C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C56531A0004
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bUeTEcqQ;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mEN1dwWTUWB5SpsalQ12B//ej4EQVouwCQgWOmClkL8=;
	b=vaihRsDaNgeDJrB24P+s3DoVLo4h51D1DkqFucZjfdYXtne8WQTt930p6N33bhkKWeWsTS
	jk/+gsYmGSVgdvHSopZBgG09Y8vKaWdrhQQiYHTj3Qz8H9ywQgP+3agTLKLCVoz7M0Lq5N
	uoJg+m5epeiEusL/TL1h50rAq5e/CSk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926168; a=rsa-sha256;
	cv=none;
	b=ejdxbQj7rhgRpXWW99sXipRMTqAzlbgC4yIIQQ+6jix7FMcdi8/7WF2tcCPCfkK4+i1PtW
	Brkgf/Ofyj/JXQLr///96MDzzZMRbtgg6VmCy1sAA9C0x1+1TRSHU6p8Gv+XMMkx0Y/mwQ
	zpDIeoS9zzaC9PFsFLKv/hODGC5gtHM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bUeTEcqQ;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CCABE40160;
	Sat, 11 Apr 2026 16:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF304C4CEF7;
	Sat, 11 Apr 2026 16:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926166;
	bh=5MMsoFqD5g80oWL3EPeVaK1D9tYLBe4mG41HfqJTM+U=;
	h=From:To:Cc:Subject:Date:From;
	b=bUeTEcqQYhjB/nccQee8TVX4gcAyZD+4AgpjxOItInkkJ63mVsYIT8RwzL8YDJ4Zb
	 KPGSm/QNyqdCcsFcY3Q5420WhNMfamzeLmxKJMgCtcEFLnAQb7knPIyAGb4u7vrw0x
	 Ce0wRgjl45RHasQq7YBsRvvto2y8A1dkrkpB3A/Np8t22iNs6M5cu0cJmQ6uOvxpIY
	 lzvpCmaMC6bbkx5JKFTMOtsMcyOK3mEIzt0GJoHq6ua+U7Z0rMujTpqnypOuO7NfVm
	 MCJIcGeUkBbEUA68QMqH2p+E+5GtIuZECXj3mS6DYo26GciAvkX82ZaXNlHFDIq1fF
	 OGcNxR/+qAtKA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH v5.1 00/11] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Sat, 11 Apr 2026 09:48:53 -0700
Message-ID: <20260411164908.77189-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ppoaapy6m8rd8ofdwade5b9nifwkcjm1
X-Rspamd-Queue-Id: C56531A0004
X-Rspam-User: 
X-HE-Tag: 1775926167-63039
X-HE-Meta: U2FsdGVkX189b3aXwVKMl1H0+9JgJB8uVInzGaFVY+v3qOnnM1NWYCEVX8zL9Ir3Evi1C3+rK9uRRF7cAB4luqYBQPACEo3hVnI8ppjP+PcKJYYvdBwx0ZzPR424SvIBYxxHnSdppfkEZCSrsbjJ4Qe81wJZOr2B/sd7+juvzXTt+iGvVMPpQXNLR4bxLEF305vz1TW1fG5dBcjFGTzRoVcZZdjwOjznWFX8fDaUk/W+1EFZTNqOjNaQiMYTzeG5KyQHItH3or2MeaSia9DF2Gy0PZlxpif+x63tClOWCutG8cNiC0HP8FViGAWmunOirXu2x/AgvwB8KpgNrf6gYZJygq8KMUwF6hVzpPTvO9zVHVzWfKVkAfyK8wCMZB/T+PvePutsocSXmDOvPuGbGcEri3fCvTR1NNCXBZFa9zH5Fd0SkSaRbhnOtKz/7DsMWF8CXnebVxP1+0sHROlnMvbuuGTiazgmelRE60pbXiUk1KS1Q4qqw0ZU0IdGrNtXKZw7kiaAFW9T7q1Nfmu8esaUsxsY6m+ovDZlMN5KyQKTcmEnNuYe7QhE/WfNzRFPE1Mj5n1hDbavkIZOtEbCi8d+uDqZvtZgmKWpmBDqzhXXmXLIvNeaZlY369/uvdLo7s/xYWP8tW0ImoFs9Nz+hrbX2NPkp/IliKXW6O20+gfiUFBPIJThDcPBTsUElSe9oLwWkxuVt6oR5fODO0QUMTr7tT0mvU0lTGyhKIvp6tKFNI8/KS3Q6Tn0g64ieoOllZYu6U6ZqLJ/3iLswLxCl45Ij/LVt9lnEG2W5BwNPFLtvyu8HgjESgHrU3YntFVloS98Ljb4lL5qKu1J6HEC/rBHDyR7JI6Gb76skX4zivRVmdQSdJe2W240zS18BWl+fpI+EhJIs/tdHEpNsnWxKpqnsWrcm90ihIl/65O9Ji1FGE2nNSANFlR3T6+X2h1ckxF35xHv8HAPDx5NZIh
 m2kIVTj/
 n1282XyhhrESbKZfwfs/XWzhJsgq63JmScnm4aILEWTQ1iekTAbl8Jb2/I5DwbTX0JquLlRraOwkf8VWXrH7tW6oNa+H/0kqZ1Bo+u9WbwjAxbFW1RN9W81bEDwS5EhN3ULEa9EzZEVJSIWjxbq7JpNJR73XwA+zYppjpidHy6R78qP/WAG5PieG/4NiYLXtAWoAmqvM5OkCvgUtFeGFguiEo+QH9OPt5T99rJqbTfAqDvrI=
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

 .../ABI/testing/sysfs-kernel-mm-damon         | 12 +++
 Documentation/admin-guide/mm/damon/usage.rst  | 18 ++++-
 Documentation/mm/damon/design.rst             | 22 +++++
 include/linux/damon.h                         |  9 +++
 mm/damon/core.c                               | 80 ++++++++++++++++---
 mm/damon/sysfs-schemes.c                      | 54 +++++++++++++
 mm/damon/tests/core-kunit.h                   |  6 ++
 tools/testing/selftests/damon/_damon_sysfs.py | 21 ++++-
 .../selftests/damon/drgn_dump_damon_status.py |  2 +
 tools/testing/selftests/damon/sysfs.py        |  6 ++
 10 files changed, 213 insertions(+), 17 deletions(-)


base-commit: 45df8a80cb5d9b548f8586bf6dee79b6c77c3703
-- 
2.47.3

