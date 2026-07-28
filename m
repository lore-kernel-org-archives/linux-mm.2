Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91696C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A066B008C; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B38D6B0093; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1564F6B0095; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAE486B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50938802BC
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:18 +0000 (UTC)
X-FDA: 85037054676.27.51F8FE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DAEFC14000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NrkU89uR;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N3HvH4/tSu736bqeiUxT4Fvoqu4R4sLivhdZFnOzSNM=;
	b=bMnxVD8ruMGXwqCveoCzqjoKdar61fZXgg05kqWGk2V5Hhx/fOpuyjt77SwwODjZ65qxSH
	iClnGKZ8/bu9zYCQT5JaeraTfcaxSPYtNgDWHmnh7tgjQzbqLzJJqV/yavlCG4aXAaVE0l
	0qiLnZ+HHInFoEkcB4WMW802ECL+7I0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216496;
	b=rbqeyeLyv19nliqyBiK1jc/+QqGKza/g+k34JTpcRCsqQat9yOBof+vl0kd+Nwmb8Qog1f
	E/K0VvlKsH4SqGjgM4GC9bCUQANbjlB1InoyeYjyxHm0V7DruEfknVcssLgEXM6CbxAMOr
	rMdc4l9Lw3j5Gmy8Urpoo2hKWdKveaY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NrkU89uR;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CECA60A6A;
	Tue, 28 Jul 2026 05:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4457C1F00A3D;
	Tue, 28 Jul 2026 05:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216495;
	bh=N3HvH4/tSu736bqeiUxT4Fvoqu4R4sLivhdZFnOzSNM=;
	h=From:To:Cc:Subject:Date;
	b=NrkU89uRiJg3I+y+kH60PO7jvuidI/3gCjUZDFGE3+Uv2Ki1KNbXs5YM9EMXofmFN
	 Yhizx54cvr8L8eUls+wzrxdY+tq3AI3ATMNu9lOofr7VRPYHnf3uEyuTmRzWJJbnJM
	 tDLxe+hk7iR7S2J2ws+Xg6iw10UHoYM5JFmMlkzQAp+cn95dr9S+GQtFqObxSj05O9
	 sG1dO0aSZIBDmtpxNK1xffq9c7wWDrxcVdnKaoHumviUwNvedIfq2gezf0u/2hJwUC
	 KJ19TmoyYkaqf89udGc1pd72zWxv5P7wxx0zH8/T0Gpke+L997ub4LbrVwBC0nc7Mc
	 tXODw8A4FskBg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
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
Subject: [RFC PATCH 00/10] mm/damon: cleanup code, add test cases, and update guidances in docs
Date: Mon, 27 Jul 2026 22:27:59 -0700
Message-ID: <20260728052811.192712-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DAEFC14000B
X-Stat-Signature: qm446bh8nonzr61k5j9ie684y5sbra55
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785216496-830583
X-HE-Meta: U2FsdGVkX1+5GVLmc8EA8r/o7kcboj+CaqdQiq6by5wFX+fEK4qvw08+2SfxP/KbIkHjIRwM0Zm/3HRxJ/OT3T8WobPTRuq+kalhCKVnutF8wKp0YxIowRQbPwUQAnaxnXzjXGQ3CZ+rTiBuVfwuw9OgBoYVU7ctVtYFiABUeeO0rMkK3Oh6mLxj+w+QYjhBxbPogBdInn/vMcJit8cYORaQx012ZuMewIRGxJzUbhRNYKnXzJ393pHOgYus0J8Im7tEGLSefdIlgIG9emdfSjPhkJo7j6KAMC952g8Ymc6ZCKclzBSDdlr7csoRFBUQ6j/2OAm0jYR75PaPBzgtyJgXC2FZMpKVAkuHaj+Ai7FB1a74KDWZMQ35N7Qvm9fpNCh2wUVNfrxRXXMn/KN2wZCxN680T9HL8zBEHAs98FyGp8P2ARnI9fC7VaNKDFhRkwVFEAooSnx+p/gslKKu7tIifFTOaAbzWs4WHuoitBdBQAvHo6uqakZRiv4m5sujT4Nz4Fejly6JMF9r2ykavo3dxhajNbk0SsUgPYNRvilSbFyOICjrlcAmICaO7ki+HczoNehIX6V83OOylXS5d5OEG16jyYG61S+GGF+D4m26DN4Cf+NpmCB7RJMKsJ5aK7EcNkZw2v55XKQdjlJjRt3WNWhDeNYW5L/nyByVaE/ikCXET0ZjPPBHZJH+iAzC1X4JuFkezAS+pQcRgAkGS8dJqiE0HjcOPTaKxKaPQTv2dauP7y0A1qtIKLZgDuAjx9aGe7Qr64Ea4BKuNBl/Nx6DJCVLqih1c3Qe4pQrIfbhqaOh+m0i0F6/tGVu5iXYTGiFl9bCN/5/gwU/+cNd4AP3nWzEru/blUWN6NbEEJUQcRZk9tXDo2hjROSIFull9OIKTmGASJj8yGQ1uMAD9+H2+Yuq4+qgLMeLVUqVM6N+dphOp3GnVqKJ4JAqiGMB+jc4Jr8yJrw2nZ3/2Ie
 yM8YqG0n
 BNaD7IAkcSjzbPi/jj8p8qN2zd2poc2uytzNps2+xxFLqxJ/uIFn2vrSXUvofpLytK+62jnjR4knfSOkEKzKQd1PrXFpTHwinS2eQSD64RSr0wZv9pwhRjz2JAJqibz5PP+drzIau7Qi+lw3mr94kzFpaGoDEAgBX/EDitV1Rxh3vg2369DzESI4YvbOTtAAjVsfHCFR4eGqruSJXS9jPNWLY8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Misc cleanup, improvements and updates of code, test, and documents.

Patches 1-3 cleanup DAMON code.  Patches 4-8 adds kunit and selftest
test cases for recently fixed bugs and a new feature.  Patches 9 and 10
update guidelines for AI review and what document to read, on DAMON
documents.

SJ Park (10):
  mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
  mm/damon/core: remove debug messages
  mm/damon/vaddr: remove a debug message
  mm/damon/tests/core-kunit: extend set_regions() test for error case
  mm/damon/tests/core-kunit: test <=0 size damon_set_regions() inputs
  mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
  mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
  selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
  Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
  Docs/ABI/damon: recommend subsystem doc instead of admin-guide

 .../ABI/testing/sysfs-kernel-mm-damon         |  2 +-
 Documentation/mm/damon/maintainer-profile.rst | 19 ++----
 mm/damon/core.c                               | 12 +---
 mm/damon/tests/core-kunit.h                   | 60 ++++++++++++++++---
 mm/damon/vaddr.c                              | 11 +---
 tools/testing/selftests/damon/sysfs.sh        |  1 +
 6 files changed, 61 insertions(+), 44 deletions(-)


base-commit: f5d0a1c210a9bec33ee6cc888f4cc6dd1f56eda7
-- 
2.47.3

