Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1445FF44873
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6407F6B00A2; Fri, 10 Apr 2026 10:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0AF6B00A3; Fri, 10 Apr 2026 10:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DFAA6B00A6; Fri, 10 Apr 2026 10:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37C616B00A2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF3028BFE7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:46 +0000 (UTC)
X-FDA: 84642857292.22.CE00E97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 639CD140009
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOfuPOTg;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YN9ALS18r0tYD4auxLRsR3017e8yGe4hneQuwOQlt2E=;
	b=TVtY9t+qbVtFp/Pn0ozM97TyIc9LzVC4HLlyg84okwj+qdivJzDA8ziTyXiJ/R1YjFNhoH
	2E5a9YExGXMQR+b8PAUeXPbx2JDeNIRoubaLm5q4Jy6RfEhPLcQySf/suweA7HW7jBjHlE
	h3b1UzhJqB/djUV4hbo1l7mMzMiBP8A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOfuPOTg;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830845; a=rsa-sha256;
	cv=none;
	b=KR3YUxAZjlLXoxGghJpuzcIzonGA7nZHM7+n8rHaxWN4e0w/OHCOoXyD/DDhRtYnDPuttU
	SUTMC4Yw7PgfCwkBqasXwBu+eZXZt4MpMcyzm0ZzIP8uvBwLT9hQKkZhqGNe1duIb/M/i3
	FFTYP0g8Y+nNy+m78GABtqkvYf82sCI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C4BE460126;
	Fri, 10 Apr 2026 14:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD9AC19421;
	Fri, 10 Apr 2026 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830844;
	bh=JJWpVrHZSIlukvM587fa/e1ss1M9d88mHEJo7BWA4Tk=;
	h=From:To:Cc:Subject:Date:From;
	b=gOfuPOTgsOhuPg1WH3NqUiGgPlN8sS9ByLozVoiJe6CilHiXEcQ4D0n3nyA8g6fxP
	 lEx6Gq1FbxdrpxOYA0zwNiYjyboYSj+rajC1tBA8Pp/3C/fe3jqEtOVLyx2kVoqgeX
	 IP6FxfW9Ps7ViweVsWDw2DIqxhUZAtoZDLq5WmgwEb2Wu72xRZTufIGlF7IKlD+Rnk
	 V178EBVdc3R+35sAolJexwWppQ6nl1xD7e/UrPCDYg/4zAOE9pQCUjTl1gxgsztvWb
	 f0jGNz/J8ygavVl5yzgJtUk+g0CDlNh4IgLPmN7QJwjqs9+czJ5HBHrVTSbNJIjsNp
	 y6Ilectl1u/lw==
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
Subject: [RFC PATCH v5 00/11] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Fri, 10 Apr 2026 07:20:21 -0700
Message-ID: <20260410142034.83798-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nkrx4tdbt44ioei6zt78ukoti6c1j88n
X-Rspamd-Queue-Id: 639CD140009
X-Rspamd-Server: rspam09
X-HE-Tag: 1775830845-611788
X-HE-Meta: U2FsdGVkX1+C/AB28rRwfOHRhgLb+BrN6epBA69+Ahf7QYQG5lTpoflMuFiuvJ+5Vk8yzsu5M1Rh2vys59F3xHVGJeMZVtujRE/Lns9DEaDrRM49XlMd8HN4ey6L1LmFtd9gAIfh3ohNGYLIH93KJL6vwQHEOtwRnMiD4Xf/UafIyj/nHuZmyC++eBHMih8PyT6cvxNEwYGVDtCeqDeWoQIwvNVB4eKA0KokjKeiafRRAZc2Vn54x75u5Qc91AKaSF7JrTIx+tYy4cGTJwaGtqVBN4s5iRKkJeR/MYNfW8rCeIFBUDnlRh3u4l5EaZc7Ozsi0S5SNq+N4TWw66T5y2qZdpjouSJlxMwQd4Qy/AefUQGJINLJzMHhJKaYGrOv3+TNOCfRA86Jv8ybvfgnDTuwRgcm6CUPbU7PXBRyvYdvCzMDc8WqMHNa4RTDKvJrWg6fkz3jGujckyl3n1KU4ufi8oPTf6W4IuCDZQeiSfE/L9GUkVR7dm4UzcHNjdo3I4vuDU/pQBnD6sSxxGPNCHYOzgjJAuGAihM7NV559OPWotOdUmttqzhRSA6ZdZKAKEZzN7b8+I8mnUdt+M9+P3m+wCh9EqZ/YZCVK2ZRHAjK7x1l24C1SzzhC6qzgpZE2fMV81VoiL0/nZuwSxYK+pDX9z6OH0rZm6iC5aEbTF5zcF+Vxk7QOvEhXFmXt/tsSfn2zr1LAmWch2lLXIzUxYkc0rxw5EP65VS1ADv6XuUgaAeTANNUjeS/MrANsfpSlFyJtp5Z46Q/CWUfbd1N6PMNAQu/oz9b/v+t6aJCQF6yelUoVHoV5V3WAeHsZXP7WjmLTsRO9KDfSXt8p0Rl7FaGk6BuDlNXaW9VxUsUkKp+Y+ekRi6A626XXvEJPfIhB7v1pA8IHwBUwaFG0QSZwYcBDt1aBobc98O6nW7q7TlbxIBBA+TxPQ==
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

First two patches make preparational changes.  Patch 1 updates fully
charged quota check to handle <min_region_sz remaining quota, which will
be able to exist after this series is applied.  Patch 2 merges regions
that split out for quota as soon as possible, since the split can happen
much more frequently under a corner case that this series will make
available.

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
  mm/damon/core: merge quota-sliced regions back
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
 Documentation/admin-guide/mm/damon/usage.rst  | 18 +++-
 Documentation/mm/damon/design.rst             | 22 +++++
 include/linux/damon.h                         |  9 ++
 mm/damon/core.c                               | 83 ++++++++++++++++---
 mm/damon/sysfs-schemes.c                      | 54 ++++++++++++
 mm/damon/tests/core-kunit.h                   |  6 ++
 tools/testing/selftests/damon/_damon_sysfs.py | 21 ++++-
 .../selftests/damon/drgn_dump_damon_status.py |  2 +
 tools/testing/selftests/damon/sysfs.py        |  6 ++
 10 files changed, 216 insertions(+), 17 deletions(-)


base-commit: fe17d40616ec462138186edb32f3105b0c064674
-- 
2.47.3

