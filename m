Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E06FEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14BCB6B0088; Fri, 27 Feb 2026 12:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CF86B008A; Fri, 27 Feb 2026 12:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F167E6B008C; Fri, 27 Feb 2026 12:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E01FC6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:06:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68B575AF12
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:06:29 +0000 (UTC)
X-FDA: 84490865298.12.AB8E36A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C2DCA000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:06:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uz7lf4Yz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772211987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJfvS7AYP05C8cOTAGtWu/sUPnK18kvxjopsYLqykqU=;
	b=HXdcBKvaV+R8LxCwjj0LCs6FFlW0tbxXqZBFVA0Q4CocZz7/LB/iTuy4CHy1BJ2BmDaQI7
	5810j6fHnsUw1hZZacUc5xQODxh5q9XVRBSp/cYegGEe3fGVJeN51yGF++0lpuG/w7YuVp
	q/uOBxCnd7S1xFLHnrvMi+q2SyKbkOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772211987; a=rsa-sha256;
	cv=none;
	b=C79eBbs2YrJY5pydvynMQdsZ4SQmYpt7dXJp1JMeMU81WHpGGOAoX4eHpPBHqLY8+iNrzt
	QRbz1dkyaZKdEHimwF8S1muBFhWkwIFjv/99/7wZDSvlCx1mmM1LARHTpPDWGcwkcl6xrB
	yDPtTmDu0KRSqyOfiwwLaSRdE3B00qU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uz7lf4Yz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 711B540675;
	Fri, 27 Feb 2026 17:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFA3C19421;
	Fri, 27 Feb 2026 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772211986;
	bh=O0Ekvw6cgbKrFzaRP2KpqyCdbtP3NYtFFUZbEaTlXOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uz7lf4YzTdbIrazqOQVddnhbSgx5bVHjmhM+4TzucPLaYBvJFspWv7CDEfAl0ow5T
	 1vl+Dg0r6GfUXsasYtP+UmoxSIvJUN+vTao3lGuc3fO6W8hskjuXsvpwwD3u3ec46T
	 5VJAZW4IkjlnPmOO6SfOqvsw/jmeVQQ/j357v1GRqmY0EtRE7XrmpU2mewYeiQVTNB
	 5vSmhewn/W+E9l/4CQIIE67hRpIjpBRecqyeD57x1P9xCQh7HbKY8M1i5eWqTTWMsD
	 VR4YWLvvyIxdxrYG4U6bfEuXltHVEjhxZF38Nblq0VhJAdvJM5kkS/B1nSE7FMKkmo
	 2HiwRKMWmI+5w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/core: set quota-score histogram with core filters
Date: Fri, 27 Feb 2026 09:06:20 -0800
Message-ID: <20260227170623.95384-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260227170623.95384-1-sj@kernel.org>
References: <20260227170623.95384-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C2DCA000B
X-Stat-Signature: ke6ezty3ec6t8s8zie9onwsz1aohbjyn
X-Rspam-User: 
X-HE-Tag: 1772211987-334558
X-HE-Meta: U2FsdGVkX18AtxK1JArtawirOcdhxyEh8JNjQJi7aYz7CTjLboLBYT+tBTW1qiwHUgGss9M+HXK0vQ81J6UWhniK2961tbuvE6IVIPAHdiV2Sfqn9Sd+b0IjWjfANI+dor/cipDTTmfCt274TlYJuUcbgONfqGNZXGiKvoPYowcANV9siPPO7AboE5v/LK8rjiOc+w+FmfAbZOL11vEsrMu3gMPe6yObauSdaNTuqWnJ5QETSkG0uG2X2iOdbcWLlUm/CWkUMrbSe0DkZzZ9DM9JcEP6pvRv0Nk0qJ8P6IAfEnR5bpiGpThlcBScLC72MF1zFpH2qmTiJlhvvN5PFhRWSSRQnEFUaZ59mMHQXay6XEGqsIdTBsqf9J+QTuF4JbW07CdMfFf9xTSrCXHMIRlnbZ+HXBBHpnPiyh8skqbTDJy2G5FwM/XobEJNRPB5yasLHqIBKR6u3ek+uT4cZ/H0Eg7S/+q22U8++h8r8QYVIxmj+E72xfnUZeGubCBWeIfiAmtWEcQAqk3P8Fvp0n8JTsYMHh/7/PPMRcLrqeVpsxna1v+sFTd88UmEFXz8S8/i6e8hN7ltohNHOy1zpwss/qoGgLU8IR7bja//9L835IR7SsDGlfyTduG2jESuSDbSQ9Bhc+MHhzxGvCcbZ3nQpozrhIq7RR3oEoBlwul6ua5G4N3x2JAEOlkYPPkejfDZ5hPf8lVIcp7l4Eq72paIkusM52WO9Uz4APISMCiMzRKn/dy2buLijNI7ya+LJ/9Eu+YATxwVRt6xrXVSgD4ArXbRqocL6VDEbRlK8Mff4+lsPtXwy5LKeOaKkcZ7ySuPH58sI8uCRwKlf6N4NQVLahLEKJkteoWrMFNgWtDnCYu3P1DOTwLHC1SWXy9NCA9V9HSGFwBU7Ut1snqr2Uxm1x4Gtf7zSzjj9ywip94wlHQfkb2WnnHEfs5qJFZr5DpHs+sB7I32X3m6kzY
 hnipQOPt
 v6WWkw6nmG+CIpbP10nmeOEPeCAgYIdKhvxEm14yl3iwsHokZ+euQMEo0C8VE2+DBPPaTYblIrLmNqUUIxq0dOm0Dwnj1YX9YGvGnBDK8aeJd8sR/XskW033b/Y9UeGg7JmeBeA9Nx5TdrF8Ejec01QOnLIfdsC5iMDoX56N61HpDwj5wj1WuhSVa/PXsxFG3NLVwjbLxER7Ad0OlqvEcR/1zncpHZlPdYDJw0M/sdqF8tU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The histogram for under-quota region prioritization [1] is made for all
regions that are eligible for the DAMOS target access pattern.  When
there are DAMOS filters, the prioritization-threshold access temperature
that generated from the histogram could be inaccurate.

For example, suppose there are three regions.  Each region is 1 GiB.
The access temperature of the regions are 100, 50, and 0.  And a DAMOS
scheme that targets _any_ access temperature with quota 2 GiB is being
used.  The histogram will look like below:

    temperature	size of regions having >=temperature temperature
    0		3 GiB
    50		2 GiB
    100		1 GiB

Based on the histogram and the quota (2 GiB), DAMOS applies the action
to only the regions having >=50 temperature.  This is all good.

Let's suppose the region of temperature 50 is excluded by a DAMOS
filter.  Regardless of the filter, DAMOS will try to apply the action on
only regions having >=50 temperature.  Because the region of temperature
50 is filtered out, the action is applied to only the region of
temperature 100.  Worse yet, suppose the filter is excluding regions of
temperature 50 and 100.  Then no action is really applied to any region,
while the region of temperature 0 is there.

People used to work around this by utilizing multiple contexts, instead
of the core layer DAMOS filters.  For example, DAMON-based memory
tiering approaches including the quota auto-tuning based one [2] are
using a DAMON context per NUMA node.  If the above explained issue is
effectively alleviated, those can be configured again to run with single
context and DAMOS filters for applying the promotion and demotion to
only specific NUMA nodes.

Alleviate the problem by checking core DAMOS filters when generating the
histogram.  The reason to check only core filters is the overhead.
While core filters are usually for coarse-grained filtering (e.g.,
target/address filters for process, NUMA, zone level filtering),
operation layer filters are usually for fine-grained filtering (e.g.,
for anon page).  Doing this for operation layer filters would cause
significant overhead.  There is no known use case that is affected by
the operation layer filters-distorted histogram problem, though.  Do
this for only core filters for now.  We will revisit this for operation
layer filters in future.  We might be able to apply a sort of sampling
based operation layer filtering.

After this fix is applied, for the first case that there is a DAMOS
filter excluding the region of temperature 50, the histogram will be
like below:

    temperature	size of regions having >=temperature temperature
    0		2 GiB
    100		1 GiB

And DAMOS will set the temperature threshold as 0, allowing both regions
of temperatures 0 and 100 be applied.

For the second case that there is a DAMOS filter excluding the regions
of temperature 50 and 100, the histogram will be like below:

    temperature	size of regions having >=temperature temperature
    0		1 GiB

And DAMOS will set the temperature threshold as 0, allowing the region
of temperature 0 be applied.

[1] 'Prioritization' section of Documentation/mm/damon/design.rst
[2] commit 0e1c773b501f ("mm/damon/core: introduce damos quota goal
    metrics for memory node utilization")

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index eae387d4e0786..419d6953783e5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2317,6 +2317,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
+			if (damos_core_filter_out(c, t, r, s))
+				continue;
 			score = c->ops.get_scheme_score(c, r, s);
 			c->regions_score_histogram[score] +=
 				damon_sz_region(r);
-- 
2.47.3

