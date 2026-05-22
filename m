Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB819CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C0C6B00A4; Fri, 22 May 2026 11:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6EAF6B00A9; Fri, 22 May 2026 11:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC22A6B00A5; Fri, 22 May 2026 11:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA5B56B00A4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4EC44140266
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:37 +0000 (UTC)
X-FDA: 84795468114.21.FCDEBDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A6A9F100006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZqdJ6Ux;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6QxSA9c/yrZYSL5gcr9C6ZCwNghk39MyMElVsQof6yo=;
	b=KNeUEftmffDb2kIb1o/PQy1CJWiqjn3IRUjhl574VKdZi/8n1ZmvV9OxhWvNo01eVSUzQ2
	M9gUwCtTNZWVJ+iLjsxxHnmy+LgH6Eez2wrtzI1elYX4V8U9zJ9mW9q+sNeCv8LELvC0H7
	4BeHTsM7uA0rHplgOzltiLPxqWg+b40=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZqdJ6Ux;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464435; a=rsa-sha256;
	cv=none;
	b=S6BbEsJB60MJWptUUK75BnN9bJvFJ1Rs8ofUsodG1lQzC/UE3d+ymCv+Sddto4gWQcQxO6
	z0vc4E40FqTKJvOi91O/sJ0S2KbAa6GQ2hQJfHheCgJrisf37W5Tp8nTiUkJt3mRuQbgqH
	lQWbajgjoEQcb1SU31dW/i0zsmDJ0T0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C89B5416CF;
	Fri, 22 May 2026 15:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F381F000E9;
	Fri, 22 May 2026 15:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464434;
	bh=6QxSA9c/yrZYSL5gcr9C6ZCwNghk39MyMElVsQof6yo=;
	h=From:To:Cc:Subject:Date;
	b=oZqdJ6Ux7DMZtTKLSyYOFOWpVxWyMDem1e4BmHzwpHyTb1QPRDOpvyGaICKMor6WJ
	 j37lowD0I8eVvc3BkXsUheghqZAi/nnhfwJpBQMWVA1dgmeOAZ3ldf8qmWvp7IIG1Z
	 AsbDXo8++EVRePIocEDtphlsCkk6Uyn31wUiKZDVcwpfl6PLrWf0YaFmH08rXgVWZP
	 BeYpe5eP7eVdN47jMO/EmI0QSCnHmM4pUwX928kypmAAs4Sc/P+7lp1rJo6pnsKVb+
	 mX1MnQP+yRwB1ithYO7VdK+N5DgENB1pflGWwDBm/ahzK8fW0EfrzxgyMZvKLpXt5m
	 bbIWtRH3qGtNA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/14] mm/damon: minor improvements for code readability and tests
Date: Fri, 22 May 2026 08:40:11 -0700
Message-ID: <20260522154026.80546-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6A9F100006
X-Stat-Signature: 669oydrntyub1j3ezienzsfaeazmbdg9
X-Rspam-User: 
X-HE-Tag: 1779464435-51255
X-HE-Meta: U2FsdGVkX18t3NSty12Nze6/paKfPGZ9vtayTxckEe79KPE63/yIIDkwYm2fj5vc3x6W4jq90Cou6EDmTQ/WP/T3OALTdA2caeSMH1biiCVLMZ9824z7mlhgVNM6IwoKKyATlki1B3XirCv0+uDghkiaXv+V88KfTaU+kkXg4qeN7x2R9f0BpXEI0RbMMFyqfgt4ll9rpU3oKvRHVMfrf2S6i1OvjQ6Np8sif6ldRUs6XLJ5O/WErAQtAenmXtxWH+v7lPkjNn44wf0i8SLs3QzOfBE/gERKdWFT+c9gd+Nzs+YqxaUl+aTXOi/o2mAyGQQMcNWvJplQ76sPitwffokeJ7UyEYR7Zzu1ylzVWrx6YanfZXzCaCxnRFtLX0mspT10Q54hi80aLHedvvLJtDaT7Ni3dzPYXydRidXtuTVt6ETJ8sIMiDBPqZywuzvriOU7zuAK+JZY9gZptlNDybKG6EiQRzazG40rFGNKyJ6hfMG/p5L0z0tXLE9ZWQxW58Wo6E4c8ZLm79wIqYZ36D1qcezyH/H4QC9LbEqXiascrIj/5lHAhhCLG3TTM1ygs0HKKaXO1PK6h3mYq5mvI0IvVjfEiDD9fCev4OxLTNpi+YXUgCZLZu2mU+OyFXPdHPJxsEUQ3bWteJOaacc1luxb/fMe4gZLTxo1nIrN+TCd13JoWvDHdrz34WaVD0cpn36H1IbV5BjogAToSERPAUB959q3pzoXgj38c8J7ezfQHzkrXci7kbwbhNJyaZ2Q9dbZzU5Hw4J2kplCp2p9lOh8M93wBdxjh27jswXOIV4TOf4SYrevoDHhARdoMaJbtZ5bkWiG4crbYGZI6dTXw5S6iSG0w8Af6mtgdb58g4OMnSAz8bmKXOdRsT+NOGhR2f/BFev6Gj2e/MDLLUj2BrjSCxvQ1vUQ3uCf1H3Als3gkoLZ8qN/ROvdeDtJZrgG2ns5YkiU7RaTFMKwPvb
 5WzVvRNl
 K8tf6bYss4AsEnTYGfJ+w3Qb+NPVT0AbgTGczSfWdEtVCguJz62IlOpOkQaurcRLPG0UwI2ESbX7r1VjHr8ksghra8dxvS0HJUeRP0+9kuwrqysxlF4HutkL6XF63Z41eJshtfFkwadn1CL6niKE7W2Pk6yIdiIcX7HoVC4/sdxY+cuDMpiN3u9JoikWCk9HxwNXI3IP9f7A5u+bMmmVqq1iW9ZJiWZsDa6EB6prgvVhbpeo=
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

Chagens from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260521143428.83157-1-sj@kernel.org
- Drop RFC.
- Rebase to latest mm-new.
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


base-commit: 712074729b7852a468166a84b131ca9f12680629
-- 
2.47.3

