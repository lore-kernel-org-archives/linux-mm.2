Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 598DFE937EA
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F716B008A; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623786B0092; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F076B0093; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B97A6B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0634BBC756
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
X-FDA: 84650415570.14.7BF4F93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1B7EB160013
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSw0VDgW;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iDzbMb+5BAzd5G+Q+O9H0SeBYRyLJ5vvBy76zNVLIP0=;
	b=Ic0+CIRiCxyHJjBWRhP48mDenk9aV99F1oTjjXO2u8Y+ndcAgEwuD/6qWiK7Czp8BVqgMb
	/dy7KJL2P84Dye41dCSAhBfXQQcKZ/YmG3aS8pC1aM9bGfSbsL8/kEM6C3+bOxTlIZXbT9
	w7hyfQ4zlmJcXhA9Q2+h+dGSYXh9gJ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010803; a=rsa-sha256;
	cv=none;
	b=sUl8l1rirn1LtyTwZKA11Z8AV1ymjTeFyPKadRqhuB7nGPm89TPdAcyRHzFaL3M5IjB7IM
	3Ji0OIdGFomwx9lq6149zYWIe2NAVyGjo4Ny2KQuH/JV4SzKn7g1u4GScJYARlER1naiGE
	hyIHLxGL3p0NV0eIlpJIQnK16l3Qs7A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSw0VDgW;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2246D60142;
	Sun, 12 Apr 2026 16:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053ADC19424;
	Sun, 12 Apr 2026 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010801;
	bh=TKSNA76V2Q7FnR2TtsRjiWi8cm1w5FFExih5nDC2pRI=;
	h=From:To:Cc:Subject:Date:From;
	b=fSw0VDgWITMAvD/hRNLrG/1isNPI04+GCdEgM6V5sy/xiAtFaYWj9ef3FPoeHMSMk
	 1khdNuHw9AGhkjwicx4GO9A7cIuXTQNm3UVq/baZHQQZpIofLc5jWggt6+cNBPnbC+
	 EjdUQegFkqg42hyg4+HnV6Ac1y2w93c6maOqZfnNh0yllpVPOkackpAGs54ANxVcb4
	 HXVwjAPSVAiATDekSiOtxUyf+NaaxcB+SQ9AIDyJCt6EDKifgI8yUfecum84GLt1Aa
	 E6RELkIhtDg0exLNeikoI8pVA7HkZfoZUKdaFF1W0PDNsCnWFZuKEj6h9M8BCVelj6
	 GKb5+Co2PBfKg==
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
Subject: [RFC PATCH v5.2 00/11] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Sun, 12 Apr 2026 09:19:43 -0700
Message-ID: <20260412161957.82835-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1B7EB160013
X-Stat-Signature: 9utzh6yhq8jerajkcd44jrn6kxyqzgih
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776010802-48458
X-HE-Meta: U2FsdGVkX1/fmpI0QUUzqD6d9p/DHKApy70KSsdsHwBi/zV5bOcwT4s6yOdMNfrEP6phaCFl53gyp1DaNkZ7MhAEv4IWwm/q8uAnWouqp6TXviYRfqvQdLnJwjJJYMOR1afXxrR60o53l5L3T9iHQ+D66rfR/a7s2dSHASQTJ93MMFl7xwqMo/FcwDNMWBowrIfgqxbK3/VlA2PMqKOloSIdaMhNSYUQLhE3oW/6Bgh+S7ZZmQV4+cnsNq8UpgZqVKE02V9ikC0+fJOpLzp3uQGwjIaTfva0Ch6LE1XgW5kJO+nLGxuN9UBhK7aNu/NfzhARf/RrgPkWXoD2Fw7BMSWCsmy4jfA/gBadk/5tPPgWm/y58iEvonFwmfTCrvV5fGztcECX4yLsEPVk6YGhlG5EgsAwkWpupTC+m5+PoNOHl491En117oIvADSBf18QdmVn7QC2gcrfMTRAjf3xXxEhuFFQMGDxYZwe9UjaOHuMLdsSJczf7jfTM/CMk8V5sMCQhLGI61MIhorHDmN08Si8HuJh3pKD8jss2W/vKYQKEYmhf2Vh0501QYk1Ys1Kr3JZSRNYD493jVWXdGrJ7I6SZi0rYuVLLDuCkA+BzFNorjb88uumKY7bK+WQ5UMxCdM4SNePVZJlcwz4BBqjvPE7yPFWazLUEBIhyXJDJ4QE/2IqTo+CS5u4whQGkH/XSFmEEyKQStsAz9eestnHaAVutF0gEHPxmKn7/7VVHvWsK8ucQIIPGeSEsm0q4lW8QLvJoFHUfJz4/m6FRxdqlOXU6ZD4KIGl9WMZnS5TYn4E9bEtSeviU1A9nZe/E68nmHSn3v0zNRtaV1azYM3zhvHlBXFBQe3jmQKRWOe/LEDIyK/NaxyY/1X8Pjz/f48HUkA7F5lEcj7m9+59TsFshcno7Neet8LY7JV4o5wJC58A7HcxLKhmvxJpXkEq2Zq1Gb/58Er0PpixRDA5PLx
 FBtdRggQ
 Pp4ooA4mjR4EWPKAOG3rLKtZde251ByDj8FveBWavt3ZtszlOuFlZK1/6YD5CyR6dmLzPkGrJTXj0mVnKofw0w/ICDmmT4Yqtb3r24cVVhsAjy8k+E4lu+KwV3GzEy0yAHvpjP1GXNYlAZHulCU+HT4RQQghYq1iwpW8olMPamMsGwyB8oMOgdiej0kIaXP7wMB817YyNB9zpyQQogE01g0Eo0hP3XOMf3ceosM9mryUAkRg=
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


base-commit: 8419cb46e7cc36ea746f259cfcbda7166a9a1fd5
-- 
2.47.3

