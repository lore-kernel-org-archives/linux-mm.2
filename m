Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5AFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C616B008A; Wed,  8 Jul 2026 09:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5976B008C; Wed,  8 Jul 2026 09:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B43A6B0092; Wed,  8 Jul 2026 09:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 681BA6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:54:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2742A0138
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:06 +0000 (UTC)
X-FDA: 84965753292.11.4D7B551
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 59B1918000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C48wGeCL;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N6Tlg2IQM8d13Ck3KqSkeF7axKX2g7LhiH2fFY9f8WU=;
	b=soNtFUaQytcKxhl8bs8rLe4TW0ndSK2RusslEq8SkZrAX9thhec681cnwfUVhhRPO2x3EJ
	EVElNgERfzFWWulo+0cD6lJ8+uxEECVQjK9pyP28Yni3jM4DbVgL0/zK8lrjJpn1H0ymjC
	LodfY5THYLTH69jqG3FlWeFCeFYhPv8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C48wGeCL;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518845;
	b=5pMVm5D3DIiM7SjYjKz5pQsgE51ahq98ee7jsn7X7kE2hB9Eefd2E9yfMYPX5JOXhDaGXg
	CJ2MCdJc66cgozssdocR+HFh5VziPTA2i98+j/P5da1i7lCY45V0be/do68z/CvJTkpefD
	HhAdPwLIdDzAJL/a8sLI4j4iG+M22ZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA5F960008;
	Wed,  8 Jul 2026 13:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9511F000E9;
	Wed,  8 Jul 2026 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783518844;
	bh=N6Tlg2IQM8d13Ck3KqSkeF7axKX2g7LhiH2fFY9f8WU=;
	h=From:To:Cc:Subject:Date;
	b=C48wGeCLLHcpuS6xlOQG8PQmgxpDZHTopJ7fnpskUpFsK56TXm8zxZZuCfjlGRX5o
	 KukCWuEpO/aQUFgoLtD3YEaicj9ljr+bmHrg87ZaC0J5gqiIW+xGM6CQQBwwNCtXa1
	 QKIYlJC0EbIFFl840TJJOa0MY2jEh+uXxRIc1A9/bqcQYv2ZWPIWbDml1kQX4gtu9l
	 7ozEzelFj93HbJyJV0Ja28fod+VfPTE5gb46vA7HUpnbrNzv9u6mFqmdv0ZzuoNDlf
	 2WRKoJBDBRB8HrZiTNN4oQ8cbryrmL6Ci53nS1jsB5051d2oFUZRXZROTrfbDedb81
	 6bI9Nw/OArrFw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/7] mm/damon: update probe hits for runtime parameter commits
Date: Wed,  8 Jul 2026 06:53:50 -0700
Message-ID: <20260708135359.122587-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 59B1918000D
X-Stat-Signature: r84xntpmamcu41qzkuekmc4chehgrecy
X-HE-Tag: 1783518845-633426
X-HE-Meta: U2FsdGVkX181kn5e+bgW/9vu2fKYaugrVV4Hpd3lUZPYNz3mezj023z2pmCWZOFWf/hw6HtVSo3TULJMPvV6Bu4ZfNd9mlLacOll1Lti6Fz7R9VDiB0pTK5mCU52jcbhU+2zBhI4e6tyr3/kHhKT5UM0+PbvZpJBY9KNJCcoU8AJoe55MwM4ADU70wZ7XXMCdGd3sPm6IKgne5tVB3mt6kR7pa++VdyLhtgZcpJmifDm6BUrBRNUHouB8yadMZ+yETKjAOZ59OgxmGDZ0YuGNoCrRIvwOg6kafyX2dxnoZeeI8L9R7TqSlZRMkpK0YKpN+/4NLFCjbLRuzAuVQxtYNZN0Q7M9Rm5tEmOCn1xQirO0U4naeGyyNfT16clTMZsQZQM/Gziu+47qk9bVWLcCQwsHUO4d8zU89DwUFwb2uM1xqCBjdFOS0iKqoQ+EXyoSzXXYa6eKCtZ1bdP9XubgTuVueJWD9ub8Rtv+75Ly0Bl0N1AMzdmmdWfA9i8K4KgQjN+oiSzVD8GibVIXQMrUXNlkx/k6LWRMe5xdpwsAokshQ6+ZffdVAxSNBWShUvXEBS6dM57QTl7R1l95ECdAlp2/yyZQ+DYOh2Ee+Rd3GkUmEL97ARO193kODai53rYhSX5Z9hxUDc+l/4ocy90xp5rZc/CCDWcq5wZRYU3ruPDFCQFKO7SlaRexXgdFSrR5SWuHp7cCcl2Yjo9FFAhnF6QrO4InhryqqLpqBA30DPZhYFWV6wec9VqgNsGpghlt0g5upYjP5Z2oo4JJqGGH5TjdG9RcnWEY6BH7oBiWHJmIptoJwfdKXIUOd9/r3k1sVFn7UYtHxLRBrCcfTawEKbDEqdwQkmnsXt2jpyaV8gkw3dKjImwf5rLb40U7QzffdTCM1TCs5RWADAUFofyynnczOCJ+srdxAwf20qlLrnX4Xt7FajM/c1Er2lpmjEsybWF/PK7b7oHh1rm3Ii
 7yq/LQwQ
 BOP/g6ZhPQ3I/kqUZAi+/6OgvtDXFIyiy0S+FaOQ7hxgo4eW1LBRhs4BtZlHW3Js/bXWbyGarizhdXsG5G9IW2oV3ySBf0jIMcSDg2aMRifKLWva0GtwpdJy0zX9AwoISfu9Cke69HM3pkXMfGYYe3NMw6ml88uYaTdpvw0e9Ouin97fJKuon8ti9gefTOHk0J0nAn/v5nDOL7x/JHJ+ySc/Es71BVbV+JR9OYMlkUaz+F8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON users can update DAMON parameters such as sampling and aggregation
intervals at runtime.  For such changes, monitoring results that depend
on the intervals should be properly updated for better accuracy.  For
example, the access frequency counter (nr_accesses) is updated.  The
data attribute monitoring counter (probe_hits) is not being updated,
though.  Do the updates for new parameters.

Patches Sequence
================

Patch 1 removes obsolete comments and test code for a function that this
series will touch.  Patches 2-5 rename functions that are being used for
nr_accesses update, to be able to be used for probe_hits without
confusion.  Patch 6 does the probe_hits update.  Patch 7 update
damon_probe_hits_mvsum() to cover a corner case from the update for
better accuracy.

Changelog
=========

Changes from RFC v1.3
- RFC v1.3: https://lore.kernel.org/20260708024855.116614-1-sj@kernel.org
- Drop RFC tag.
Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260708013252.95888-1-sj@kernel.org
- Fix rebase failure-caused kunit break in patch 1.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260707135038.90068-1-sj@kernel.org
- Remove obsolete divide-by-zero test with comments as a separate patch.
- Remove obsolete comment removal part in a rename commit message.
- Rename name-changed function parameters.
Changes from RFC
- RFC: https://lore.kernel.org/20260707043828.97900-1-sj@kernel.org
- Remove obsolete comment and code on the test.

SJ Park (7):
  mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero
  mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
  mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
  mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
  mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
  mm/damon/core: update probe hits for new parameter commit
  mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()

 include/linux/damon.h       | 10 +++---
 mm/damon/core.c             | 65 +++++++++++++++++++++++--------------
 mm/damon/lru_sort.c         |  2 +-
 mm/damon/ops-common.c       |  2 +-
 mm/damon/tests/core-kunit.h | 36 ++++++--------------
 5 files changed, 59 insertions(+), 56 deletions(-)


base-commit: aa8ba979c42a7bf2d344a0f3b192c4dc61000096
-- 
2.47.3

