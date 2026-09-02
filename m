Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44CAC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EBC6B008C; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5856B008A; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9416B008A; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 036C56B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:47:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB66C40747
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:56 +0000 (UTC)
X-FDA: 85167740952.07.BD48C81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6486E20009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nmr8Tapk;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328075;
	b=Q76jWxfxkwUwiTHsKLa0HIzoBCr9eaTqV3LZOU1oQUSegmf0pqvjetVOo/G/k41Q1HyVE7
	RXs7nkfSjFd6ToJgfNJwycmRAhOHoDw3VuceqMxHvE3HEUSrTtE/axrT816+y2GTyXT4te
	B3mo7OtkBY4f/HHyLFqKZro/XOfRKQs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nmr8Tapk;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xyVBn1leruni8Keulp+lVKAKdJp5Y+Dj/l28v3PKPmU=;
	b=U/Ai4hsy3w6TaDj3M66+DlbKBixXT9wezpDIePjbcgvlvSFdSiOkJBl0me2OyOvwjUJJ4v
	qE4nHeeK+wdsx+EibaRnlFRuxaM1y7IXKC+0Gt/e2pbRV33fBn2lVBrWdzdmK7U4rSb1Vv
	+oEh90dbnMMxlYFw1H3Xs7OTvMGOKDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2C0260218;
	Wed,  2 Sep 2026 05:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B9D1F000E9;
	Wed,  2 Sep 2026 05:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328074;
	bh=xyVBn1leruni8Keulp+lVKAKdJp5Y+Dj/l28v3PKPmU=;
	h=From:To:Cc:Subject:Date;
	b=Nmr8TapkJLpq3LiZ50wQjliwtU5ueiy7PCUbVtFZup6daOCWOMBPEi2992dEg3DIN
	 b3hmVw5bw4+9tXpzdcuBFO76dTtOML0lTwjBOLp1SBNvIi0XGcaXG7RRgnWEqbtqQs
	 bBX1MOcKsiIZuEC1NPcI8QC3GNooaBLRiyFAwC3ehnIAF3dkj7qxRAY2agHzJLnjMn
	 Q1t3GqJ6Kl91TVUU+6J6DoHZv8IyjMXEa9Zv80QnjuDRbmeDjzsiJd8xmz+DKuhmI9
	 xkp86K0xkYf50MX4IjSCzNH/ZPYog8twgwaA1aoVfscEr/SH4j0qlr6ZLi+nH4BBic
	 k3h+OGLsfotlA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH 00/12] mm/damon: cleanup code, add test cases, and update guidances in docs
Date: Tue,  1 Sep 2026 22:47:33 -0700
Message-ID: <20260902054747.99370-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6486E20009
X-Stat-Signature: 3owrahpjxnat9rbf1dqn5hkqcknuyhyd
X-Rspam-User: 
X-HE-Tag: 1788328075-602073
X-HE-Meta: U2FsdGVkX19gHdf564aLzQWhzH6RcRljOr8/NsmI3r+ZCiwiSoQ0T5LmBs+9HXMD7BxvrqL+3KmIh4HHfIKo/s76nFDa/ETq1Qc1+B2P6enlkrW77Co58u7h7Ax/oOgoZI8nR+F/+1iiAQpVbe18/bcv70ShyD4AalDvqPd3FHpkJgNBMio6MVbTg4Kc96dRtQsoUvAc8PrJ+ssH6z7n8w7PzWG17zCE620UJJhwdLlU6WM4H0KKJtOgbiKakEyjmn6umIzgnWwOyj5FJjYrz+ACsK3KRG7fbQ2W1qUEuFn99v7yA3xi5LJUpC8xwu4RnLU3B6dZ3jOtgEtc0HH9m+5hP0KwzzivYXyXDlrBobINwmuyGaCHq9dPRW+CEqFBmZZEXr2YyOI6pdxitxM6jite1DQTk67OeWT7xk4NvORek+WIWXPV7ICPLtC8j40Z51YeqUSp6t4THCO+sEojdUk2lW7zVKshzEFeAtDdLorGQx8P8TSc2ghpAlOLsgcv3d4Z++dh22Hy++Q2lfNvaBYMK9WhTCwgoASwnCwFgyLZFpl+6w5m6Ns0VC58j4/N7ZfaDS4khOaptarkBsC3ycuQWw9yYJkT75I8HnEPxrxfUyXWzOxXjODuo6I0huFEN3SnEw5mEjD+EF7Z4QggL+CXmWN93kGwVwbHHXhFHLQOPGEhqipid0zQOGe9kof7pRPqsB69IE+MCsXDyKLTIwvrewLIKza6tk8ajZQ5qsJbyzhfvXCsa+T6FUkCYISgkohDyT91jfN1mw2jQZsjDaxPTCyfNLi2WiqR3WjDwKvUQXZnOhqdtD9nUFDkyFNSRJpkjX2oDUsht3DsApafuFSuR0WURMc8BIDpKBK5P4fzRIey0F5IWQZ9aRbMEw+yUwUNIlmehOhKJr302pk5ajkYLJ6Qq0nedAXgCCB5tdpaYLJkWqK4q3oTxpE7/WWeYfKVINRTqiI/fHHHIhv
 Rd8jyfZe
 0kAZfQikIMbl2Qk9wFMEiQUtuCy64CvF6WKyAewZxrX+Fo6gncskT7btHgjtk65ksN6tS5grGk9jHc8u5op4I3nl1UtMyDsIL+BElZ4ZAaIynMp5zNBlv2B2Bj1jh0pt3H6zFlDJhJ7SgPJQPku+JIuRXYJHnmEw0UsxEPMOpKW5JubAOVMJqb1XvxixOUOPV4f2BdizHqxLIJIh8fOnt/BZIQln12VEVQKTwYHlmhq8ud1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Misc cleanup, improvements and updates of code, test, and documents.

Patches 1-5 cleanup DAMON code.  Patches 6-10 adds kunit and selftest
test cases for recently fixed bugs and a new feature.  Patches 11 and 12
update guidelines for AI review and what document to read, on DAMON
documents.

Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260729140253.87753-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260729033751.131213-1-sj@kernel.org
- Fix a typo: s/alingment/alignment/.
- Add damon probes parameter validation cleanup (patches 4 and 5).
Changes from RFC
- RFC: https://lore.kernel.org/20260728052811.192712-1-sj@kernel.org
- Remove ctx parameter of __damon_va_init_regions().
- Fix damon_nr_samples_per_aggr() overflow kunit test.
- Rebase to the latest mm-new.

SJ Park (12):
  mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
  mm/damon/core: remove debug messages
  mm/damon/vaddr: remove a debug message
  mm/damon/core: validate number of probes in valid_probe_params()
  mm/damon/sysfs: remove probes number validation
  mm/damon/tests/core-kunit: extend set_regions() test for error case
  mm/damon/tests/core-kunit: test <=0 size damon_set_regions() inputs
  mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
  mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
  selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
  Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
  Docs/ABI/damon: recommend subsystem doc instead of admin-guide

 .../ABI/testing/sysfs-kernel-mm-damon         |  2 +-
 Documentation/mm/damon/maintainer-profile.rst | 19 ++----
 mm/damon/core.c                               | 19 +++---
 mm/damon/sysfs.c                              |  2 +-
 mm/damon/tests/core-kunit.h                   | 65 ++++++++++++++++---
 mm/damon/vaddr.c                              | 16 +----
 tools/testing/selftests/damon/sysfs.sh        |  1 +
 7 files changed, 76 insertions(+), 48 deletions(-)


base-commit: 52315e1a031f7370a286d6f6c805e2c8eab5abbc
-- 
2.47.3

