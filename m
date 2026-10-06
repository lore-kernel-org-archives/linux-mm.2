Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3000CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0475F6B0088; Tue,  6 Oct 2026 02:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3AFB6B008C; Tue,  6 Oct 2026 02:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4FD96B0092; Tue,  6 Oct 2026 02:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5C706B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:52:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B9CC1A056E
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:52:18 +0000 (UTC)
X-FDA: 85291282356.23.E8EB9A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C2387C0002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:52:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEPBvpoO;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791269536;
	b=V9ryOyI+RW557oIyXdaW/kU6GU+9UGCVMr6/geYUjm12DlZbJVS+E7+xgt87tO89dAFtYK
	r7GZhynP6mPFgXmuCuI+JejpBnQKGClW85cs4GmULEnZ0UiyAQ1Gt/9ilVbMhYkDdyGdPh
	enJa/G80EE9BUkz0b2ByJorHub+0rv8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEPBvpoO;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791269536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PSfSoVBXGadNhagMAHG18RgSe3v5QSKmmn3n3+vo4hQ=;
	b=1WptzfRNtazq5rUzBOMjKQJka/s349vSIS/Y1SakbBQMuIQHIZWXqvCoHcprHfoXxtveI0
	+YrutHLsk/6F1Ghx2H40TZpHnkGOdYO7mtBuxYHwmHfyepLhP/8vGLKEV562bY5ViSAgel
	SWi4Jjp014KOfrVowXFM9G6Ca9KnNuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75106601F1;
	Tue,  6 Oct 2026 06:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEF41F000FF;
	Tue,  6 Oct 2026 06:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791269535;
	bh=PSfSoVBXGadNhagMAHG18RgSe3v5QSKmmn3n3+vo4hQ=;
	h=From:To:Cc:Subject:Date;
	b=QEPBvpoO5O23SJSlCo7NCFJ1p2qFiGwOekB6/LxdVAI+Te7qVga4p9nzOwdL1cCqS
	 hKzHJKtMfbFvob8z3zLFnazHpYpP6gps5GpuT/YU8OTqHPP9YvvM5kDJW5pdyFvXSV
	 6ppbILs25XjelKJt3I9ZXhQZ85wHn8Y2zDFxupX0WTrGbujX1m0AWIW9tZoqSQj7EG
	 BmD+jYBHW9yixEO1Po+8aSw0G0hI8jbKW+M3BosWkY3t8z1Yw7aVatNFBk6aey8X3/
	 BOkYzKqFedEnwp8/H3ldZ6NwYRFeWUDwqxLpm6FUhvWv9oH9yQV8qSIsdckP3sQ7RR
	 Et39CxfPESlQA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Gregory Price <gourry@gourry.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] mm/damon: fix a minor bug, clean code, and add a test
Date: Mon,  5 Oct 2026 23:52:04 -0700
Message-ID: <20261006065209.41507-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C2387C0002
X-Stat-Signature: 3wnbqibmono6nathacu88k7wsw17azgr
X-HE-Tag: 1791269536-516825
X-HE-Meta: U2FsdGVkX1/lfG5smRMwyqrHCku01FuMplSvHOISVcPE8jbgJdEFzp5jE29qKqmEC0vo13vayPnP3EN6tzmeliBbnzvwVoLq9qWX+xLS6ZWeO0tctFZ68OD2YOlfldcvpVASUkXXa5VJS38MqFTKQmKqnagEwR7vR8SyQGWZBHUEsliPtgD8gQj5GSvVCgLW/SlTejGUnXmEtYnMButsleXc8kw5BAwZFXeUbygb+7/GyeS+hfxJmkFwqN32AmZ0LikpyEhXmV72JN00s9u0KeECJb41ank+EK8GPodZEQTIQ+MpNpK4OGsPlA6QBXkToVf03yM+vR1d/8cTWv9UL0FQY9wGoCVFnce5wR1h/ecIrciW4w0WBRy3RRJbBSDf72MM1nSV69qlqZJQ4OaDqxOu3mAwZi9j2ziQGHQ1YG8bT++i2Nj/wubPobFFO4ZB7kpnU8z8VBkbEArodXwzPyDvGgYiaq6dDqEpJBNsrJRs6U78bIQ6eaXO1rpW+Eqs9YnJ+PMvjFIMQjS4p91eGJhdeg/CPgyBfwQa9yOHTAFkF7ALa9EPq8WULblRSKUz+wqXJodVjwVd7YLzMu5dDkbVfxZr4eAAsNhgzmrFy01yVXQrnacbv8INR0iP4AATFOh//5Hm9m/wNxBsb577eygdOf17fVQzyk0uRRTBZfQl+V5/+XWJqsn9IcH8pmEoYIQAGT7JOgp9HL/DuS1ttTyqeW/f6G6Kuyx4NiWiIgCGhJiqyltRv+hwl3OBM2wrk8oG4dFbX9z/GJjH0+I59nhiyCTgnBa2yamjoQe2k+t8ipUfw8cNz48txcjR+g13bVXZLiZQnFgtAphptkKmLYZppzKCt/mWMFNw0pIPlh1+1Hej2/mnDoLaTiTdcSIusWmlWzn7CTw0niZrOswS288R77g1GFFw9zVDSQ4+4fSBsU3EdXvfdBPGQMnZzS8kd8sSXGXV4I4JdfUwzVH
 RrDH/ZIH
 VyPUGE6V2UjO1NiW+PJBOXHpO+i19QVmo4fPDzv7ix6KdPa7Km24PD5RwPfImlghNhlhtrI3OlWjE5dIhQ2LECtC3QbkBfWSPd7nHBG5pVpvSzsw49/ay2qIdbmM3JdIKxaJqdk/7qFzJOk2iTiWyg/h+M8kQseFywSXpaLiSAOowRoXmES/v5cZEvCE/EPLeQCiVz2a/C2d35cCQfVG4FNzbOCi8krc8Ktp/qxajPCYxa5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 from Jaeyeon Lee fixes a minor overflow issue in DAMOS.  Patch 2
from Gregory Price (Meta) cleans up the code for handling of hugetlb
pages.  Patch 3 from Liew Rui Yan adds a kunit test for a recently fixed
bug.

Note to Andrew.  This is a batched reposting of DAMON patches that I
reviewed and asking for merge into mm.git.  Since there are only two
weeks before the expected opening of the next merge window, this will be
the last mm.git merge requesting unurgent DAMON reposting until the next
rc1.

Gregory Price (1):
  mm/damon: use damon_get_monitor_folio() for hugetlb entries

Jaeyeon Lee (1):
  mm/damon/ops-common: fix age_in_sec overflow on 32-bit

Liew Rui Yan (1):
  mm/damon/tests/core-kunit: add test for unconditionally skipping the
    last region

 mm/damon/ops-common.c       | 11 ++++++----
 mm/damon/tests/core-kunit.h | 42 +++++++++++++++++++++++++++++++++++++
 mm/damon/vaddr.c            | 10 +++++----
 3 files changed, 55 insertions(+), 8 deletions(-)


base-commit: 1b1d9187f46db1efb64533dab8b8d5f4f2af0eb5
-- 
2.47.3

