Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03C39CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04586B0096; Wed, 24 Jun 2026 10:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA7D6B0098; Wed, 24 Jun 2026 10:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3BE6B0099; Wed, 24 Jun 2026 10:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BEFD6B0096
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EF8D1A0360
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:22 +0000 (UTC)
X-FDA: 84915016284.07.D546074
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7E32F1A000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PAgkz+O/";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310820;
	b=1FL+01/ywuoPJ1C6k/3aEWMZ2TynlRKiA0GwglZrUuwjLFCy+x8dQDO1y/N6iGklG6Rqsd
	G0nVYH39pIfJ/1MA7W66JeU/ekOFfdmtD4WwVMn9j8aI+hg6e30AQgWZTrxYKR2u/z/tel
	wUla0LhoxROzTjVNLwxFJ1QePLV+KXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DJajJ6C8GLY+N9uEH7jpwp8hPpWryUvttF8AzRaLQYw=;
	b=6Tkw0PVcUtAXVefbtp847xJMgOXkvtjUXDqBMJpme3fUmhP5Icujxr/3hgZVsEQfRLCzYv
	g4ctR+Y2SWNDw1bsbYWhaGwH8AbSCPr366jQ5pqBsElC+GbzWNp/MQyh0+y1QwhXIanBI8
	u2JMLXVnmLzod/4GVLHNa5pz8QKM7MY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PAgkz+O/";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C786560018;
	Wed, 24 Jun 2026 14:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951341F000E9;
	Wed, 24 Jun 2026 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310819;
	bh=DJajJ6C8GLY+N9uEH7jpwp8hPpWryUvttF8AzRaLQYw=;
	h=From:To:Cc:Subject:Date;
	b=PAgkz+O/7OxDk2fOT0fUDrXFwnePUhWrU3gVf2PYiU7jxZI3dX88PVVKb+XuGGhdS
	 4jIKiEulixFT3gs4wizds4JiGYKtYGw7IYmh6O8oO+oQRaCvL6oa/dcpK3l2m+sas4
	 ABL/ND6fZvexkg+/mX4bK9Ja29jYPc0/g0OjJsWfKouVEEbM9aiLnPt3FOnpIIdspK
	 WXW3MwJR5faCndTkPeU5PfGvW0P0vQkP+CVO9yaS/2mP87T0K8fy0P/7AX6OeNcnPE
	 IpTJq8R3nvL3BDEpsnOh3SPqDnhKUmNDoU4pG3mH0AlJqjGMcY8fRqmAtNRUp3gwmN
	 ReGKHg8zw+8JA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [RFC PATCH 00/11] mm/damon: update, optimize, and clean up doc, tests, and code
Date: Wed, 24 Jun 2026 07:19:56 -0700
Message-ID: <20260624142008.87180-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7E32F1A000B
X-Stat-Signature: o47ftdwmk636azj1y5k5khrhh3b4sj56
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782310820-469735
X-HE-Meta: U2FsdGVkX18pe8oNMKoxAov3kMIEOZgrzPnYCzzSv8kP7ZcMWTYpvR9iJgkFDB7kkXgTXoZ4gg+rc4ptFBAzpEtrv+yt9k+qOXWuPdDnjF9YNoH45Q95kmgWBrM7ajKRaH0sv0qzDg2nLux5IeEg+NVt/6+KW4+zHm1h9gv72SvsJaO/Ny+6Q8CJocN4+J8U0eC5Ow6dwgDct+a17qLXNj/jy8QiS5TVBexgL4LtP1rK2Uwax2pAe8/knjdqS9OCbE3s5UnmCRbtKzmb4yN3xIoBPUrLvdnAuVtCCZMU2SNrgmsOcsTfiglQKg8sgG3Wmfe4O2xTAXQCfALxTRLMW+L6rwv/RLy6/q0tlo2/uNPE7Ey8qNQ5TvxM8DnyvMtKyJCJLE1J3h3PggfMv1bPlUE4kN9uj/mY3rn7qWnLFUcN3R9s684kOwJXwGqC3l8MPlRjIImAjR1KIvEAt1xEbsPsvx1/OieAeoxiLCDNYbLyMkTsjhPMyDgktMQ+xpz+q25MWl0LzaQX1KzTnIqGHYRdqdg3NCdB6O6U0Dzvpdo1BhQQd6vjILKxWUoV+aQhhRGhs++UJZuWZkD6g/Ruaj7aKTZngpwGrsTOMkT7VWaysscIE8IknV3tcukyvbgRJWNxCG8g+J88fJn8qqWYKjiWFv5aiV6UKQNYGDGueO9G7YuhA3s8kISokeNgp96MnjeOD8oV6yC3uXfQQU+aspaX4Hu7vABlMgrQd5iJdmFg9psYkiZzEV5TzVhbuWpukB1Uu5dL7oq+wLJwrQJWRU8QTysyp6f/JGZeF6Kr+tjStwbWuVOwyI3CY7CEiDWVUHY2f8n4Z9h4jmCxQr7DFaF1G825jAbwQvkiu67ev/wojvwqUC2Nzh3Zj7dO2rYfA4t2FQUv8YY3zELcJEaBfvI2N/SJkgz2Zeb7agjw6qVoAN7PafekQ0K72F0mB8MW2UO6H0hBawTdq3H9oSc
 E30fALUs
 iovBjpfHyfZZT58XotLwoJCNktQx+qOF9S9WU3OymbbEecZTYOZVX5hj3y8EtdPlO3UIF3ehMYvqYos1F2zRePF9rm5YwC+y7bFI9w1SkRrX6tofvFR5Y0FJTR/mgjnDKGnSvd+qhTPZOAN7tB/p7NKe3GbOO+u5dBwX1oN/17QnnSJiSsKBdUcVN2k1SuaFzC5td/WrPgCU2w39UQPbEQq67dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patches 1 and 2 update the design and ABI documents for recently added
DAMON features.  Patches 3-7 add or update more unit and self tests for
DAMON to cover recently changed or added functions and sysfs files.
Patch 8 optimizes damon_commit_target_regions() to skip unnecessary
adjacent ranges setup.  Patches 9-11 clean and fix up recently added
DAMON sysfs interface code for readability.

SeongJae Park (11):
  Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
  Docs/ABI/damon: document probe files
  mm/damon/tests/core-kunit: test damon_rand()
  selftests/damon/sysfs.sh: test multiple probe dirs creation
  selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
  selftests/damon/sysfs.sh: test dests dir
  selftests/damon/sysfs.sh: test all files in quota goal dir
  mm/damon/core: reduce range setup in damon_commit_target_regions()
  mm/damon/sysfs: split probe setup function out
  mm/damon/sysfs: split out filters setup function
  mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/

 .../ABI/testing/sysfs-kernel-mm-damon         |  40 +++++++
 Documentation/mm/damon/design.rst             |   2 +
 mm/damon/core.c                               |  22 +++-
 mm/damon/sysfs.c                              | 102 ++++++++++--------
 mm/damon/tests/core-kunit.h                   |  21 ++++
 tools/testing/selftests/damon/sysfs.sh        |  70 +++++++++++-
 6 files changed, 206 insertions(+), 51 deletions(-)


base-commit: 197a7eb91f786e5deeb1dfea35076c01ebd37ce0
-- 
2.47.3

