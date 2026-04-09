Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 973EEF31E25
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E906B0092; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9086B0095; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A00E6B0096; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 226936B0093
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CBAC8C043
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:00 +0000 (UTC)
X-FDA: 84639231600.19.53F7D37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C91344000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:21:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mD+ter6I;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y7WnEZa+JKRjumn5ByiY2uAw1OplFJRhCFiuNMuH6Ls=;
	b=cWcx//UgPx7wd7FqV7mb5YGedbIbxwl75kraCcl8nmlh5lUbT+evr0LZGCtid7w73mov6j
	G+BiOvD75Eguz8VP/GIfF667XTXBh6dQdi0mpKgDW41ZFC6yfwyH2XRdlfEG8FLp3hZi/C
	08394X+0jy3gLy3j8NN6d1RSy8C7Z68=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mD+ter6I;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744518; a=rsa-sha256;
	cv=none;
	b=sBjy1bvI1ZgixN4S7feZA1rWG82SO1daRDew6SGoUabpFx3Y+rgQz5K114OExpBgUgxkan
	KjkPMO+vPWMwLMisCIJNesmIDdC/CwbKNWJlfMh8Nv6whEcwut76xgQhJ7qiDLFHbUOtYc
	ZsmrXPPHkh5xBiFxVGUM7Whz+c+hSok=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B857460121;
	Thu,  9 Apr 2026 14:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78915C116C6;
	Thu,  9 Apr 2026 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744517;
	bh=9Zrk7X+kZV2OjsZMpp2b2i3iH4tpkagbjKQNfsTVoTk=;
	h=From:To:Cc:Subject:Date:From;
	b=mD+ter6IBEVK+orPc590wfrnHIDSNePi3D/N1Yku/oK7w3zyb+t7JRj2KxokY5b3a
	 oFU+Ck5mhqAxbkW4ii3bnK0Q6rr8dda2f8iwlIs7K4J8xXidDcLQoLf3MJhxnymeF3
	 zP5giDyjTGSVCLsKBaZFagcOdOW9STzcwJ222Ite04eFY6HFycCTPbIivT3ycZ1DKg
	 et6cAcYLjSDeXss1YINsIRd4bsaRW2V/2CGpQwWxXprCIv7bMxXEd9S73Tusul8rI1
	 8gZ++fUSC7aSclYt0pQErmkpbp86OWYsVp6MMzelsIpHU598cmeVGs/mxXJlAUQ3Fh
	 qDVfApz28523Q==
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
Subject: [RFC PATCH v4 00/11] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Thu,  9 Apr 2026 07:21:35 -0700
Message-ID: <20260409142148.60652-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C91344000D
X-Stat-Signature: jmwjw818tpffkgxywd8msaujiqgkxxa9
X-Rspamd-Server: rspam06
X-HE-Tag: 1775744518-184690
X-HE-Meta: U2FsdGVkX1+0EoB9MU6pAt7csFHWmYo17MJcfFgvPAGvjkFvpJsum9XP0gZOmoUzVJ+Hr+ZFelSCdVbcduOoHU+h0wmfhTv4/LrG31JoNgwM0kcy+9xb226530TJApWuqInGe8qmpC8Y0iLy9YDAgGfRPv+dy89v5peCTrI5/bdA+7q9nJZMLRvu2DxW+oogTJ2WrFHX4SyEbbM9dLB5L/9lcTLDHJYzY8hZfJRbyIHTKPeIdoj1kL4DTXpvk7h3ltPxrTuWEcSbirh9LnchP7S2z4emnI+A9BdsBp4fGP2p6XwWGT+jJ63Ogdr0JbLph9AYe2Cri3WCq40aHgcgV2xdu/oaxRpm8RiK+J95AbZ+7cMKpUJCAtRPH1hVCvGRFshm1EL0P8r5OeeJnG/Er1Ne75xZfu1WZUfMFHCWzLFsirOcsLcCVntgHh+Yagan49wzmSlNIbySgOtpNG2UK/MdWUEJ0+Zsp+7U0YCG+mOwxXpM+8xDC8b0L2CfytgvMkQMBYN15HJ1cqG4KEWDx1dl9MtmDQLTwe3cZTxr1MTjuC3nAMmVn8ifKpyqY3M0rVUB5608mYlnPLIRTQy5MY1TqY9fTIGUGU9a570YrKaX3wonvAydIiXBS4C15enmj/Lnxiei4QIzgqX/1cMVin3HEaVovZdU0o8fjMJMu4qRUNbU9hw08xrfcGR5gIFil/fMo+WbidsyjIMLsv28iY6DypwZeiK1X2c3NC+w1SDrtYAlgjQzkPomRIVeAXPl8MD40S3OuvFnLp7uuhz3lB9nAD0mgm9pOJeN4cYuDZDKrYZ/arFthUb80dqdQWlCrzIiF1fORN3JXv7q0ETYBH+W4xHYIsBhlqSxoxrQj4Y81S01c2Kiwi05PvZeJdfOLPMykxPckCECaGwHk3bDjv23ouw3kQ+zJuiUAF2rHTtAtxB8h+wAH1tNyngpgHPkBXsAZJ1hcFW7/oXlMDo
 34fLJuY7
 DRX91RO4QDPHhKPWfcxQtHdsf+B/9RwATKVo7W778XTTGFwkuhawUe9w8xIAMIENmep8sQD2ObQzq3Lv9P53rOVRMPTQPvcM8XzdQwS6gQjMlynLtxwno+220RE3B7M1zElxq2VlXhnFowFWJjjj29nKXFcnCDB4QNAcMC6a6busWFseCGRQuTWHTlMl6wYSRGOy36YQxa9iTUDSOSqIHCSk8BkTqELrCLAKv1k7hKntZ/II=
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
 Documentation/admin-guide/mm/damon/usage.rst  | 18 ++++-
 Documentation/mm/damon/design.rst             | 22 ++++++
 include/linux/damon.h                         |  9 +++
 mm/damon/core.c                               | 76 ++++++++++++++++---
 mm/damon/sysfs-schemes.c                      | 54 +++++++++++++
 mm/damon/tests/core-kunit.h                   |  6 ++
 tools/testing/selftests/damon/_damon_sysfs.py | 21 ++++-
 .../selftests/damon/drgn_dump_damon_status.py |  2 +
 tools/testing/selftests/damon/sysfs.py        |  6 ++
 10 files changed, 209 insertions(+), 17 deletions(-)


base-commit: dcd9caafdc7ec3f936d87d9698a6c126f77e9750
-- 
2.47.3

