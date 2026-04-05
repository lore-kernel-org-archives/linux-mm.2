Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2511E9D805
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790D46B009D; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1076B00A0; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A5E6B009E; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA7F6B009D
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6501C160B44
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:39 +0000 (UTC)
X-FDA: 84624844038.23.E590D3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 07F8240007
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3MHsGpG;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401958; a=rsa-sha256;
	cv=none;
	b=LlnrbmExcPGbjoBwZomS2sL4difxD2FRwRRSX96LWbsNKL8NWpnctck/d9j1qrqwjGqKHe
	HzDkoNJI+EHU+93js0aE4hlZZI3Scm7o5Dr7TG4sWD8G6uO/FEItOSA4872ej6aIw2owaf
	YnyLWEmzb2CNpYcIjxClro7dVGBZOvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6Vrepbo0fxRr1UfbXruiB/H0TZx4i78vjouj54JrXZ4=;
	b=a+Er3F9GYLFlm2lAZS2T+hwxCWSMy81HhEaMJqRZ4i9+ZFrh3aZuyNeT4kk1LvpDBOxC39
	mxdHBHgZcMQBQVE7mrRRBOwV9Mi88Ou0TLGs3ps7y2/U9msfQjRRerYjhPwozZNnXOkY2X
	gRWFhHmA4duGQwxJjEtGFRmI8ENFXPE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3MHsGpG;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43A30600CB;
	Sun,  5 Apr 2026 15:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450F6C116C6;
	Sun,  5 Apr 2026 15:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401957;
	bh=1iPV7qLbF53jDL90OwyGcHkmehfvKrFrN+lbGpsZkRU=;
	h=From:To:Cc:Subject:Date:From;
	b=R3MHsGpGX+xAPv5VgdeT8gcCjWU+BHimAOJfmMJMMqR/Or8TKdpZ64atSVe8UIA2C
	 sCAr2S+PVt75/VlPQmKtxQ7BlLRcqQwrqhzCzgpAcpjyOV4kGJ5mDheijDV4ks2ENh
	 1Fc3feG/MshgOa3817s0DpO7s0BcHAtA/GZMNnQOYAwMyoSpYs8LpRxMz4utci5FMM
	 O2BSx1uk14RqNvUsoDFvwFkjl2QXDwVdv55VEMskVxBS7yWnydSNfF6HTzU3AF9rjp
	 JhkIjSK44rd8kUT0xGas4A80mmML0Wf53wkhizu2Tp0vpJ3Vz9tS1qlWrv5fWstf7X
	 DvtxhX1qvfp8Q==
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
Subject: [RFC PATCH v2 0/9] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Sun,  5 Apr 2026 08:12:18 -0700
Message-ID: <20260405151232.102690-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07F8240007
X-Stat-Signature: yxb78tryk6nnyj3nbixerxzxajryp6fq
X-HE-Tag: 1775401957-310226
X-HE-Meta: U2FsdGVkX1/52Z2k9WJPtDEkRZ5K2Hm4spL8k22N4qPVtvc3fDbdiuzJiEUWjyW+htABIK29e7OdcYXV+kBcwLYIcinpSEcL056BjcGwXcyfqnOOUc4b8PnBI/lxHTFL8ZkXvyLyve0CarD++C5BmFbe1zNykpExcpFrE9r7jQW1U09YEOuKe313UtUvQXgp/cV1wdbwuESlkfFs97a48ySOC3TC0F6fIQeowNXn6w1K9QMVgDao3FNaFP6nEWnQZX/58e8J/nxcog5QQqEYbO/rmUZu6EMDghBopK7k/zqO1fjGq0kVPd0+K/vDlzz1qlEUMllbLb/Kxapx4E4KwOl4p8KYen8CQZ8WuZvdLSUxZ9B9kiUr6rURkHtMCJ/4CBn0ViqAykGisRMmIBycRIpLuxauueGTFRiTu+6BHzbCPWQuMllioUPb0iBLb9mBfpgQjfNbTqDk78LpYc0BynIdBnr/qGqTZ4FMCaMiff9N0fDXtxJ8FXGnfwutlomyWVkFXrf1c88aV2D1L7h57SpbNCLCi1fUiFb2tVMj6G+4vc4h0v1G05TVLc1kUpkG+Y0HjbpeQC8VrTQ9Vt2eb9BsA/4GKaLovpNlVz+Xd36rBHg1URsk2gAS55Hsin1JISxI1EYGoCKIxjwn2koZCIQL2mFYqxHwy+kfjjMZjz15JDMmT+zyRToZkhfqZxbqF3iT9e35agW550KfudFYqgoT5nBnFwMTHKkag8M/OfhSAC1T+tHb1RDktlWQFh9bcl4vP9ljzvDIGO6kjjlNgX6DSpqkgdv/o3aeYVlvLgkn6l2CITrCXdwcXI7DZWfSNvblMjVAIhxwIGS7FzCJBfxSZRnNiU52IL7O5Z5bT7hM5akpP9pVxZExzFJDDjN2KyvCAUHJMdTWu3/gnibSIBA5SwuwaMB5VbaUhp4Kghl2w62mcs9bVw==
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

Patch 1 implements the feature and exposes it via DAMON core API.
Patch 2 implements DAMON sysfs ABI for the feature.  Three following
patches (3-5) document the feature and ABI on design, usage, and ABI
documents, respectively.  Four patches for testing of the new feature
follow.  Patch 6 implements a kunit test for the feature.  Patches 7
and 8 extend DAMON selftest helpers for DAMON sysfs control and internal
state dumping for adding a new selftest for the feature.  Patch 9
extends existing DAMON sysfs interface selftest to test the new feature
using the extended helper scripts.

Changelog
=========

Changes from RFC v1
(https://lore.kernel.org/20260404163943.89278-1-sj@kernel.org)
- Avoid overflows in charge amount calculation.
- Fix/wordsmith documentation for grammar, typo, and wrong examples.
- Improve unit test for more consistent comparison source use.

SeongJae Park (9):
  mm/damon/core: introduce failed region quota charge ratio
  mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
  Docs/mm/damon/design: document fail_charge_{num,denom}
  Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom}
    files
  Docs/ABI/damon: document fail_charge_{num,denom}
  mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
  selftets/damon/_damon_sysfs: support failed region quota charge ratio
  selftests/damon/drgn_dump_damon_status: support failed region quota
    charge ratio
  selftets/damon/sysfs.py: test failed region quota charge ratio

 .../ABI/testing/sysfs-kernel-mm-damon         | 12 +++++
 Documentation/admin-guide/mm/damon/usage.rst  | 18 +++++--
 Documentation/mm/damon/design.rst             | 21 ++++++++
 include/linux/damon.h                         |  9 ++++
 mm/damon/core.c                               | 21 +++++++-
 mm/damon/sysfs-schemes.c                      | 54 +++++++++++++++++++
 mm/damon/tests/core-kunit.h                   |  6 +++
 tools/testing/selftests/damon/_damon_sysfs.py | 21 +++++++-
 .../selftests/damon/drgn_dump_damon_status.py |  2 +
 tools/testing/selftests/damon/sysfs.py        |  6 +++
 10 files changed, 163 insertions(+), 7 deletions(-)


base-commit: 36eed23041e834175ca57dc38ac0e128808b1abb
-- 
2.47.3

