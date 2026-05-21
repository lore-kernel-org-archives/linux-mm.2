Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FF8CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6840A6B00BD; Thu, 21 May 2026 10:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D8F6B00BE; Thu, 21 May 2026 10:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4D66B00BF; Thu, 21 May 2026 10:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37A416B00BD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD58C1A060E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:39 +0000 (UTC)
X-FDA: 84791673078.11.547326B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5F2EC140010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWEiFSk5;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oDpHqdp2/FfG8W6otjqNlnOFXaYu8wH7zUOP/guV6po=;
	b=W3e0iTyJJ5sDbpdR6/6htxO+JRIMisUk/hE2E6q2xbS1RsaXxmNj5ppwdk5sLbxMFIEX5g
	UTy/E93LonmMqYbgEfUKe2XWksCIdvFlMPexGSSYxYv8q1AJ0TReQ3qv9qQh29Tul3D3ML
	6Rutu/peX5zab2Nvx8dt4Ox8P14zIwk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWEiFSk5;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374078; a=rsa-sha256;
	cv=none;
	b=oHFhhTOCsmxM7myEGUzselU0YCX8JYTW7O9hYBQFyfVC54vEVxu6LRFWs2w3VrePK+HbO/
	8wP9uV/rXOfiv59eLzK6BfDRTCcYXRg3nL7YmFS3llPUUuMw/UOQgCuAa52DINg3E4jvmi
	uvgmHzX3V21X4Brfls5+RrG5Ak8Yy20=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC943600C3;
	Thu, 21 May 2026 14:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349ED1F000E9;
	Thu, 21 May 2026 14:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374077;
	bh=oDpHqdp2/FfG8W6otjqNlnOFXaYu8wH7zUOP/guV6po=;
	h=From:To:Cc:Subject:Date;
	b=jWEiFSk53GduYLLCUcNwNsnavil23yX3zXvfJ2cxVG+reQXF35lvztNJ6uNseFk16
	 MvWA7k/XHMtEkdJloi/jQyycdC0GfEdaZPOd86TcUFcsxpZVc6gjUIjZI1FQVZALdS
	 ezDdvqO151RFHncBqVl+pljPYy0D5oc6WhLhwSIUSLRVwIe1+n5OgonZ4z42zkOgpe
	 heUNBdL9AKfTE8OG8a4dAPIQCHLDHLtkk2iADsiLAzVF3beAt2l/EIaYOuZbPyu6LV
	 58x1F6+2i7xYNeetZtVI7XcNyZWpekxX5YHCIE/xxtYkv2+DgJ3Cvk+3BHQh3NQmLr
	 oVII3c3q1GNwg==
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
Subject: [RFC PATCH v1.2 00/14] mm/damon: minor improvements for code readability and tests
Date: Thu, 21 May 2026 07:34:10 -0700
Message-ID: <20260521143428.83157-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ebuk51y7ufno3oe3e36ucwknfj7z37kw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5F2EC140010
X-HE-Tag: 1779374078-198467
X-HE-Meta: U2FsdGVkX19QgMpzdCnaE3IO8GS34FfxO6QZaO3+71JuOul2qAQ/+MSQ0zr1pokDWYRZE/MObdA1PTrSIYkvKVp4eEJ00kuD48VORc6qGRyjb3/T7EGxjgnpLvZRsgx/LFhWAEEIQEZVoht6oavBdWOpcfGi4sLidm4hZvsV6lsZRFo5uisOsRRy4fE1bww9XakFn/xFAhBwfe6LHLJD/QS29/pMiwaDGCzz8ON26/cyFLOF+V+7NI2BMEI6WU/XDOB2KB0p2ikR5zUZUbRI8/s2TEnUJCS67juGRyYEPMjjfT/4T5rB9xMwBrCUAhrzOCJEuREH+9O2nJXdS8HWLrG6+7ziDisES7Jy7nLRG/ZumDux0B00VvtzeJkC0NyFd8sYBqfTOhI68XtiqefFER0kp/VJpMwU5w1Jsfg6YGWsqlVH1Yrv+bw6U9WZUBIKXCOmxytFnCwGdmS7WAouVY0CAXwxSi6Kwll1vWNXQ/STO1D2IlTSIm6lL37JbDn6nCM7BIX86CJXwuHMdlqF8IZ+tbpe1fxgWkvauva1msm1HhxQSHtHS3Fln//Q1kFFtYb6cWQLYY8Mwlx3SVZKc/XfuHel7r254vfxaTnZBYHCwQxZs1d0bgJVye6TbeVY63qOups8krofiF3CwABCwMbsn1oG+iSM9k1fBkhBoBlfiDA1pqZqO2R1DYjShCCBYwSxH7cdbMbuKraTbYblQgLA+miOveDbEE/KUHTtlIAul2BWdywXiieRrPfbz6TJIVqxdLB6vItV4zn3xTWzM/DTFRsWHU23DJoOq/195pHPofa4ajQOqYXxHkHxUaPSG6JcBu1RrhD0oMs2wm+WpylvUWZ5gTKdnOjc/klELn6Uqzs0sI46sabuiUQ50pE6mcZ1VUKCQ6V6R6TctO7xZbE25bHZgZ2HMUeBvAHZ5V2vm2+7cA49oGiUOeOeKdjLJnE+UQLmTwitEAwKNIe
 6JY9REJq
 zE/whmkgCY6BV8eH/7zS1Br47SOelKB8UFboxXCnn6zlbW1I9MItdA5A79nKEZmdjVSk4KuIIZ7y1fCGh+gWTzlRTAhuaQxTi97zQAi44cAH0mAFufzetRjsjtCEnnEwg7PoI2v/d3vbWiDoTGngwJr9vK5wmW+c//mqnsTIzlz2N/+4KhbUr11ymt+SvDlxd6RLPKfwGvnB7LKdL1S8xmgvJOMcuRQRzTrh3Mpk7IWNJRfM=
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

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260521035349.87565-1-sj@kernel.org
- Free DAMON target in vaddr unit test fail-out path.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260520062858.167011-1-sj@kernel.org
- Handle damon_set_regions() failure in vaddr unit test.
- Free ranges array in vaddr unit test.
- Fix wrong region address verification.
- Fix typos in selftest: s/exit/exist/

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
 mm/damon/tests/vaddr-kunit.h           |  27 +++--
 samples/damon/mtier.c                  |  10 +-
 tools/testing/selftests/damon/sysfs.py |   4 +
 tools/testing/selftests/damon/sysfs.sh |  14 +++
 7 files changed, 233 insertions(+), 69 deletions(-)


base-commit: ac6b83c7bf3671e8ff0d541cf03e6eaeed00a79e
-- 
2.47.3

