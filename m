Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C94C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE126B00D2; Tue, 30 Jun 2026 10:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48CA6B00D3; Tue, 30 Jun 2026 10:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10816B00D4; Tue, 30 Jun 2026 10:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94B0B6B00D2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1215BC282E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:39 +0000 (UTC)
X-FDA: 84936782238.09.836E7BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 73EAF140007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MpvryAXc;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829057;
	b=igg0B/CIk9ffqiEJyXVfW3XVWA8CD1Nmb7XT2THF/gLoP7scG3zdCOJnYDMJTgf27DzJT9
	e8aHJQ2P3Gt+syM+7duZe41UcZY+NYB3PnOqrADD35rm6NWcme7vRnBKnbLqwUhr7K0ENi
	xgKvTvlD9fiayNbA5fK/YkJmDcqrFhQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8vfRiINSDbirl30Dmm17gH3r0ZINd4Brr0niqjDS/TE=;
	b=ZEdC+WnmpiZTT1b20H7LT4+Up/mu57ksw2dqPWjwiENPGgvwc1oz6NDH9NsOU4M4nLFQtQ
	ScnOAn8PKAKWVKv/OnKhhgBn2z20A4r06T3x0Dyl6JeyoqZtfjfYSQjLevu0L+eqax6J6N
	+0p9dcIzHGCe2t6HYcYW1QZuw9YOdT8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MpvryAXc;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EFF0434CE;
	Tue, 30 Jun 2026 14:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A4E1F000E9;
	Tue, 30 Jun 2026 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829056;
	bh=8vfRiINSDbirl30Dmm17gH3r0ZINd4Brr0niqjDS/TE=;
	h=From:To:Cc:Subject:Date;
	b=MpvryAXchpyZO7mGub1FHBvvvj9h2FyGUTCQqdpcpHzs6b4BwS62GwPEfLkxV9+Ic
	 xznRbtcnDWntPb8Y0MzcvWGbukxiERNdlZi10+dJLsJGpW36Y2V/TIOO85+M7hDA4z
	 6OUbwEta+oYPz9ehSP+A66TAbJJ+ftvyuYIgpMkcTbn1z6q+qHMuUwUL0Gg/+2fn7R
	 5Fm0gaZ4xlsVjXBHsWgU7WIco4Qn2nhDOaWy7B/Ch7lJKXSewS2mz7umL2CjkHzns2
	 sNSSc3AJUmpXpyijIKBL7OOaUyjKE49ZLQiZbrkPLPScBzT+SjxHYa0lSCjVz9mWIX
	 O2sh0WBEvnsHw==
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
Subject: [PATCH 00/11] mm/damon: update, optimize, and clean up doc, tests, and code
Date: Tue, 30 Jun 2026 07:17:14 -0700
Message-ID: <20260630141726.92246-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 73EAF140007
X-Rspam-User: 
X-Stat-Signature: wr3hg3dtr1iyxmc35t5pwtmhn6dfn1qr
X-HE-Tag: 1782829057-409486
X-HE-Meta: U2FsdGVkX18pDG5vNsLtzkx5h9x/LnzsrP3GEyF+90MzpHoHLO9C8SaVkfaoE/bTTyyB8AHLvMvwHY/C+B0XpYrRFiywDnKMJ2kvlh8TfSaaTmqtriUAPlQvY+DeHJyHtMeur9Fy6XmYA6WwBpozbLUQzd/iLhJo1A07CqfCyAdDHqTwwQ3HeNHRfqKarAofmk0kockmK/B108iy6t8Aq8g22g6GALAow1JM3l/KlAa+SyBvvfiPXxHAaOCX8KiZCbKLATLOnTp5FqGDmsffcDYZvKMSLuO6yHoxT/QD1NalLLo31PeKZq63xsYfrx4aEsIAMTOqLfdgQDehDkn6fqeqMygQAc0f+GdnYV67eSsS6DMMHuZOTLqsStdEO2GEIFAWrYRPia2uxXL0CX7jb2EFl0Mc4o11k77AZaro//EvWkhoqEyVXC4eiYB+U5sgTHdY29/S8mbnJtmdT+d3OMOp13eXbAOYnrb2T/7pYDO5CXGjRoSKBksLy5z0PhsCHU4u4aZqWHv5LkUZAP//5EVBbvchPSaRXIswY4er4CXUGYZv3BNMLBKcym7n0KKjyTQj0kxqwmMJvkdCCGRRFjeMvkSUzO+ToCrtiGDiiUjm+i1tIdfUzqvAJt/Un0V9EemA+tHQc/eiRvLIQicfKDY5/obf5EwSAEydUvSZY45nN5hkblFNm36Vtp/7ZgWwjoJWKYZ1MWZZFjHcXYgSJYshtkyqUyuDiEvnJ3ch9aYiX9mO6Iz6dBe7aoNxG+5qY19vChFXPEcO/2F+JtSbsgilJ+YsSOJ8gW81iGso+sFNXp9gpGeKLfTINFiCxBmDEgWCSaoAElulbNdFTwpWHBqGuqKODzhmkfJdEWirnEA8oH7SByt8lU9oN6UwOYy/2kiTg22jitbmFW2a9O+qIMeFPKfRBf+2cbW7TUoRh4n95gSXNQqfI82+qjyWTkLVPfzM/YmYF5EDYM4Of8X
 7ydFfceJ
 6YjD+NxahrpcjIk/khLZ7Gr0OgjyKOtLla/Y3vWSQmkgcF6AfcmMcixOc93EIDwzgKWDtTkDB/bdaJjSA19aduXZDRFvy95LZXLV+pT/rcK3ML4xrVn98DgGNq/9BILv5EQ1tX7yqQdQNGP3P9LmzL+nHW9L3/BxQf9Dfz8CNcQxtSCk5t9FKy4fOlqlUc7F6tHBAaTuq8bO/J7ZzrqqOnJ33Vx+XTM32tD/MesgCxvx24Wk=
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

Changes from RFC v1.3
- RFC v1.3: https://lore.kernel.org/20260626001644.85825-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260625142357.103500-1-sj@kernel.org
- Fix broken sphinx syntax in patch 1.
- Drop unused counts[] for damon_rand() test in patch 3.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260625050756.91115-1-sj@kernel.org
- Document nid requirement for node_eligible_mem_bp.
- Fix typos: s/memmcg/memcg/, s/geets/gets/.
- Drop damon_rnd() randomness test case; test boundness only.
- Fixup dests dir selftest to do real test with correct file permission
  checks.
Changes from RFC
- RFC: https://lore.kernel.org/20260624142008.87180-1-sj@kernel.org
- Rebase directly to latest mm-new.

SJ Park (11):
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
 Documentation/mm/damon/design.rst             |   6 +-
 mm/damon/core.c                               |  22 +++-
 mm/damon/sysfs.c                              | 102 ++++++++++--------
 mm/damon/tests/core-kunit.h                   |  15 +++
 tools/testing/selftests/damon/sysfs.sh        |  71 +++++++++++-
 6 files changed, 203 insertions(+), 53 deletions(-)


base-commit: bb5dde77be397d614ef968578e3bf6cf9674df3c
-- 
2.47.3

