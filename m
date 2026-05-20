Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D930CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DF86B0088; Wed, 20 May 2026 02:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7256E6B008A; Wed, 20 May 2026 02:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6526B008C; Wed, 20 May 2026 02:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8586B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E1EA16048A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:10 +0000 (UTC)
X-FDA: 84786820860.09.5E3C73C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 880C380003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhJVi031;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2QZBI9lHfw0z2vkHVTq3F8i3GFIsR6yWGGTq/bbu72I=;
	b=utGOwZGmZiuJMv91vTfqtdfEC4KOS/hCJhwRz/yXszBRB6fG8ZEAc+LkYeW6pUpEArzsqZ
	3TGU6K5Z04mWEg/bqSqGY8RO9y7H1fkY0d2+Ndles/0xDZH+8tqPQ5DHhE+at/knlCLNua
	Y3yd9HjWn9ZJXjyQW4Dz8EK9hpcF5gI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhJVi031;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258548; a=rsa-sha256;
	cv=none;
	b=A59Gs5vpAsmu83NjPydKcnFzfYsP/1phOWjpDaZ4R9w1KisP4m4MI719RZczRHHoJNpSye
	HDThhhOervDW9Hxabh4AsLdwev0hVX3ebZ8v+0prWZGHlR73t1O/GHtaENGJoypDeWlBI/
	rHEVt+d8nY2WTInDM5e49u0x9TIshm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF4A241B3D;
	Wed, 20 May 2026 06:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641AC1F00893;
	Wed, 20 May 2026 06:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258547;
	bh=2QZBI9lHfw0z2vkHVTq3F8i3GFIsR6yWGGTq/bbu72I=;
	h=From:To:Cc:Subject:Date;
	b=lhJVi0312kKyHMbcsBQ3eowTBceyHjvB+t5JIUXfALT+jp/1VLlXseB3qYIKKL7Gb
	 JxGzGZLDevosJUtPvyATXLqnHzJ8AZ7cq4S0/zNU9a0TWzf57BKxYmsFzkqmPHvPee
	 t16WKXvRhiWZb05CZp5tGASHnCLPZB4V8k/1wGqjz9FykOTYHdVucXb8wUVbvn1KLp
	 C4LPucgd9kqAvMDnKN76tEFB3gGH9oZwGRAaHtwfppExDQQIOyDcPDYRF8er68qEh0
	 y4teKxnCD8wiEBhRB2PN2EgX8kWz5wPFlfPrbh/LLG0eppK9gLWXmDcfGFQj6J9rQO
	 KSQaBkUtZHNdw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 00/14] mm/damon: minor improvements for code readability and tests
Date: Tue, 19 May 2026 23:28:32 -0700
Message-ID: <20260520062858.167011-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 880C380003
X-Stat-Signature: wkawe4mk6jjxg4x9f4i1w7wqynqr1eh1
X-HE-Tag: 1779258548-110215
X-HE-Meta: U2FsdGVkX18x5yaHpPielItMa0xttj1T/WN67Ypax5m80btWOYy7lfizTXg2xhVyPMLQJE4nR3iMEYQcfn0YGmGuRt1MwDA1udQJk1Xo5VHWaAmn9JM3c0xIIUQuU3SyZsV2kVeALlOPaUNdJs765TnKVyR+98XKVHhuH7W6YdPeAxOLj/JNbfTsNCLH2GWQfIda4Lp8PshuzKX1QBtHInR8PGAXGqFE8qxUru3KfB/RwzdqAqXkqfDTP/3APd1OT4fBpKKrMVx75SQrvX4vsknrMPF0dQt5lcB7U7JqOMLaSy6Y8gJ7V3nvP+CPUFA/iJHNRn1He4vXgC+rFsBH067PaN90M1buq4mPB06aZGyz6LHv7q6bm3WoLKYYTerFrFupHgeDB+ekxBOQo0s8w8esDpa4oq/CpUZOCanu67tStnstZGSW1FQ0Ec6ddW6vQtGpIz6fS75tIqcdD09WXGjWVayVIhVcciIz10KNUwKbmnrnZsm1rpfdE/2dUVfz9yov4Q6hzvBQiYWgEs3NFVAnNxddXgEQSrBm4T6pIRIgnNmcZmMfFULwfvD2SSDV4WcKwWsjbJoEshx+0RrNxaJ2a4EByh28NsCOcdrJ3vi2SzkynWAzqSs18BDPMi/+DrdURE+0kn9OkzkWo2z5UW0OZwt0MX9a0l63EKfMGuQddGD3r6aFrekl6hZ8I6HBeoxHbi5Ns5AKbMn7EJUjCFliiVQxSRBTA6o47hEOrTaMJF4myxodR2ydr0EceME6OjYrQDaBcAhuQVNFfeDBalbN607hvzoHvzzQj0a4uFD5L5WZAP/w5dBBO8Ii9/76l4MmBrt9pKEwXJwvk3yrXoMdYlSy2mIOPFogQfWIS2rnabOzPAxm2mRlDbXV9e92OFZlwGNh4bNaI6VmB/cO+vApBogLZpyjoJxFNLDKjRnd++lnQxBCAARFJKCvJboHSUpGzCBJYRs6llRPjmh
 4H8zzMXg
 tbihJI1ottqN5sPmEoTNFu0kDB4T0OztWh1F2TWRjSwpVpAz37g9pbVpSDxZe+IIyny9XN6Wfgo5XFlDiH2clyeiXm/sZsTG+z/oaQVRvK5aPDaadmKrcSQUvBgVQE1uUi/MQbwfLc7xUmI/6KWjyAyyirQ0BQUxtRJz+RfcJ4XdIYlZi6d0SHSPsJ2zq3RE/ikJ+2jD/mzfsO+9vzb9WqillMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement minor improvements on code readability and tests for DAMON.

First seven patches are for DAMON code readability and resulting
maintenance.  Patches 1 and 2 make damon_set_regions() safer and easier
to read.  Patches 3 and 4 remove fragmented DAMON API use cases. Patches
5-7 hides unused core functions that are unnecessarily exposed to API
callers.

The following seven patches are for DAMON tests improvement.  Patches 8
and 9 adds and removes DAMON_DEBUG_SANITY verifications to ensure
reasonable test coverage without too high overhead.  Patch 10 adds a new
kunit test for damon_set_regions().  Patch 11 makes sysfs.py selftest
more gracefully finishes under test failures.  Patches 12-13 adds simple
sysfs.sh test cases for the monitoring intervals goal directory, the
addr_unit file and the pause file.

SeongJae Park (14):
  mm/damon/core: safely handle no region case in damon_set_regions()
  mm/damon/core: do not use region out of a loop in damon_set_regions()
  samples/damon/mtier: replace damon_add_region() with
    damon_set_regions()
  mm/damon/tests/vaddr-kunit: replace damon_add_region() with
    damon_set_regions()
  mm/damon/core: hide damon_add_region()
  mm/damon/core: hide damon_insert_region()
  mm/damon/core: hide damon_destroy_region()
  mm/damon/core: add kdamond_call() debug_sanity check
  mm/damon/core: remove damon_verify_nr_regions()
  mm/damon/tests/core-kunit: add damon_set_regions() test cases
  selftests/damon/sysfs.py: stop kdamonds before failing
  selftests/damon/sysfs.sh: test monitoring intervals goal dir
  selftests/damon/sysfs.sh: test addr_unit file existence
  selftests/damon/sysfs.sh: test pause file existence

 include/linux/damon.h                  |  13 ---
 mm/damon/core.c                        |  92 ++++++++++++----
 mm/damon/tests/core-kunit.h            | 142 +++++++++++++++++++++----
 mm/damon/tests/vaddr-kunit.h           |  16 +--
 samples/damon/mtier.c                  |  10 +-
 tools/testing/selftests/damon/sysfs.py |   4 +
 tools/testing/selftests/damon/sysfs.sh |  14 +++
 7 files changed, 223 insertions(+), 68 deletions(-)


base-commit: 8b8727a18b7f247aed7e0476b92d07fc59c04cb8
-- 
2.47.3

