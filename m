Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD9E9CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474558E0003; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B9A8E0002; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388678E0003; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24D2B8E0002
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C54BC4A778
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
X-FDA: 84062853756.22.53A0AB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 43E7EA0011
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MoOC/Q9T";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021237; a=rsa-sha256;
	cv=none;
	b=vu2pO5Rwl3PJuEYcBGmltJh4SRRqAuFYsq7nYVfe3g/5V1obrauOxcQB2LhQBbcf1F/8jv
	qHOjZ8kpD11dAWk5TL/ZGA1xNVvQoF4vubczZOyVsXTBXU79J9iBZbqVGCuz8QijW9t+zR
	rMD4F1+Fz2IUplHi8DrZc5iqsnBqAXk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MoOC/Q9T";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SZAHEhWX2zyv4sQOI8R+YcmNPhCPWXh0fXIXGTP+4Lk=;
	b=Tby8RC98FUSpNctNfL4U4isnjVUA7+dC+U76UMSO7jYhoGZaPdkFP1f6UCnJYLar6PpDUA
	FT3SRgZQZp9HEnxl3ZEv9+9JTsdsctv4anw6BjzQnNoHUzqfs+z8xH3vBuOYgbB5VcrD8g
	Cx8/iIrdpoDvgVSgtwEepp15DRpEUiE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6ACFD601D8;
	Sat,  1 Nov 2025 18:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8240C4CEF1;
	Sat,  1 Nov 2025 18:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021236;
	bh=YTd/vHBelVnR6mgK17h8ySbO2cFbzynFbPAWylHXqLk=;
	h=From:To:Cc:Subject:Date:From;
	b=MoOC/Q9TCmUnC9Zl9aJKK4Yg4xuuXinVSTajYDp9j64NVw/rlgaaJbt4ukM9OiZ6Y
	 uadJI7iBu2uFO+7SxgMkGpiBcJ+TjBkSp1poVWyvl2NBGZ/h9l1gA8Yje4Om5EobN5
	 o2lBy8yVeq2buFtnN3egBTJo734aeGWc5JlBREdi6x3B7lYYqwXh8qkpsMZKMLbYQx
	 lsaRHNXbje01iUxvNzpcfGUnvGtU9a9mosNIIUhlXjZsepnxJBawU5OZdSX/4Zl6cR
	 E8Z+2mEU4PKW+loBu6Plk/HfQv8kmh6q82v7VPii4zOFy1D1fl0eSd+XuJPw8rtACa
	 P0/2lWn2IE96Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/22] mm/damon/tests: fix memory bugs in kunit tests
Date: Sat,  1 Nov 2025 11:19:54 -0700
Message-ID: <20251101182021.74868-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hktam83mgajqq4mco6akp19tftkzimnb
X-Rspamd-Queue-Id: 43E7EA0011
X-Rspamd-Server: rspam09
X-HE-Tag: 1762021237-20158
X-HE-Meta: U2FsdGVkX1/VPYDfR5YZ6PcZZMlvfLMSfIHt3FytMenV+fqgHxaCRCX4J1rcz3Uf1HuZNXQd0z5cbLVlLEegsIGFgRYwxeOyaXLl82Y9QGONBlgx7UW9iaCjL9N9VZ5z5S1NPqgWQeKgqzb2KIdwpueeTaZTgTD4jApiqcHAdRq4YSXh4ZfsZ3gkhgt83jIzaVZPWvMq1j2MPwxwCsDZIPGYjWHpIQGBeZCW19vfvCnfXipuLnJcRzE65/3BJaJo8QZ2KQBBRojy4ebMSvKqwoFj2IoMRaq6Xp0QHfsTAEvBThL0FPN2hNE/YWZd9p1hmcT420I3P+XcvqtrmZRjANWeHxc2KfD6TEbR0vA3G912IWtT/zvvp9gTi60D7MtpJ4shh9orNWIRbB5QoBsdMgnarRK6LX8pKZ+D8xRUTTTc7Iz8ncQA04hKYbYhTeOg6xCJ+8KC0LAmpFXsUCdTyn879JRASsfIZOtDRsLupAy6CFHcY7wKG7iRIVbNmqHLEvv+VraoqC7pB/2idxK1aKLRjlZdwpSB/3F77lbyI1yUQ3IGPRYSUrRPAq4Nwez+fwz1CkWDMRnxxX2+w8ScLxI+zGJA/541Y/nGyVzZqIvVZmVKki0p1WkS9aEbVQjOuwDdGmjPYO3OZQ7EnSIpddNjx3+x/rRFsqlooRhENjH4h6CoNQn5lAqNYKN8sSXu1c6uttk4htv8AOn8wHSlyDRitfLQh13jPMngxPnojJLyY9/VRPI2gp9JHow8Gwhe5VM0tyDhQH1syDAlvm7SwV1ahDN5VNdX3i3aRl/u8m/TgQWATNyGPvPf0ABTahvP/kdqTVIo5/FOw7t2WfLmk4iht6gGkbB1bPp2REk6BR/YxExZXqLuxRHkN54R8/79YBX07QmVXqjoI1bjI/HYgb1RRGl6Jk3eap1nliXIWuGb0Gv00wcK4dAxYyhz4NB1w5Ia/rsInmpH7p3EJwz
 GTfMQTK+
 qvy1+qMk5qSWkhk2M3uLXKbXm528YdF53ZKqeDq/sR/FC8acE6z6goG+y1EkDDDDauGANB+sxpKqqUH196vw//9vhCWF8IGhZua4BNH3gtiVxsKe1ek16kUZj1Tmtm2mxT3RFYYi4AcraIdvt7TsXnHryV5ZWRtGIs+bwpcLI+YrepXp5kN/bfDNWPp3KkBi7TtSSKl2Gkyh9O0s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON kunit tests were initially written assuming those will be run on
environments that are well controlled and therefore tolerant to
transient test failures and bugs in the test code itself.  The user-mode
linux based manual run of the tests is one example of such an
environment.  And the test code was written for adding more test
coverage as fast as possible, over making those safe and reliable.

As a result, the tests resulted in having a number of bugs including
real memory leaks, theoretical unhandled memory allocation failures, and
unused memory allocations.  The allocation failures that are not handled
well are unlikely in the real world, since those allocations are too
small to fail.  But in theory, it can happen and cause inappropriate
memory access.

It is arguable if bugs in test code can really harm users.  But, anyway
bugs are bugs that need to be fixed.  Fix the bugs one by one.  Also Cc
stable@ for the fixes of memory leak and unhandled memory allocation
failures.  The unused memory allocations are only a matter of memory
efficiency, so not Cc-ing stable@.

The first patch fixes memory leaks in the test code for the DAMON core
layer.

Following fifteen, three, and one patches respectively fix unhandled
memory allocation failures in the test code for DAMON core layer,
virtual address space DAMON operation set, and DAMON sysfs interface,
one by one per test function.

Final two patches remove memory allocations that are correctly
deallocated at the end, but not really being used by any code.

SeongJae Park (22):
  mm/damon/tests/core-kunit: fix memory leak in
    damon_test_set_filters_default_reject()
  mm/damon/tests/core-kunit: handle allocation failures in
    damon_test_regions()
  mm/damon/tests/core-kunit: handle memory failure from
    damon_test_target()
  mm/damon/tests/core-kunit: handle memory alloc failure from
    damon_test_aggregate()
  mm/damon/tests/core-kunit: handle alloc failures on
    damon_test_split_at()
  mm/damon/tests/core-kunit: handle alloc failures on
    damon_test_merge_two()
  mm/damon/tests/core-kunit: handle alloc failures on
    dasmon_test_merge_regions_of()
  mm/damon/tests/core-kunit: handle alloc failures on
    damon_test_split_regions_of()
  mm/damon/tests/core-kunit: handle alloc failures in
    damon_test_ops_registration()
  mm/damon/tests/core-kunit: handle alloc failures in
    damon_test_set_regions()
  mm/damon/tests/core-kunit: handle alloc failures in
    damon_test_update_monitoring_result()
  mm/damon/tests/core-kunit: handle alloc failure on
    damon_test_set_attrs()
  mm/damon/tests/core-kunit: handle alloc failres in
    damon_test_new_filter()
  mm/damon/tests/core-kunit: handle alloc failure on
    damos_test_commit_filter()
  mm/damon/tests/core-kunit: handle alloc failures on
    damos_test_filter_out()
  mm/damon/tests/core-kunit: handle alloc failures on
    damon_test_set_filters_default_reject()
  mm/damon/tests/vaddr-kunit: handle alloc failures on
    damon_do_test_apply_three_regions()
  mm/damon/tests/vaddr-kunit: handle alloc failures in
    damon_test_split_evenly_fail()
  mm/damon/tests/vaddr-kunit: handle alloc failures on
    damon_test_split_evenly_succ()
  mm/damon/tests/sysfs-kunit: handle alloc failures on
    damon_sysfs_test_add_targets()
  mm/damon/tests/core-kunit: remove unnecessary damon_ctx variable on
    damon_test_split_at()
  mm/damon/tests/core-kunit: remove unused ctx in
    damon_test_split_regions_of()

 mm/damon/tests/core-kunit.h  | 125 ++++++++++++++++++++++++++++++++---
 mm/damon/tests/sysfs-kunit.h |  25 +++++++
 mm/damon/tests/vaddr-kunit.h |  26 +++++++-
 3 files changed, 163 insertions(+), 13 deletions(-)


base-commit: 75f0c76bb8c01fdea838a601dc3326b11177c0d8
-- 
2.47.3

