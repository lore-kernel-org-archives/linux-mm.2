Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55B7CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E966B0099; Mon, 22 Jun 2026 10:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35CA6B00A0; Mon, 22 Jun 2026 10:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25166B00A1; Mon, 22 Jun 2026 10:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9976B0099
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:21:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A67001C3C24
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:48 +0000 (UTC)
X-FDA: 84907762296.21.C89FD33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 302C64000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f5upGlO7;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ulp3AjMI7B4owCFSWbljnqEOw+fQMJireuqm4uU5XDA=;
	b=sVYm4gHEpSPkV4xPc34+FOIMNe8C83x80FtcJg5As7NUGHaq7IjrnhIHDmUSgZA4zNqJ7s
	b7H5m6n6JOEobIOCtJg9UugvLVtGTDF46wjdViOLcJ5KuoGOxRz7maamrqGPJ57NlEnzGW
	40cuciO1PRb3y1NvRseLF7n9t/G/pcI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f5upGlO7;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138107;
	b=qQeL/UTw0NlpC2vmtFspz1N+3OBHtsCDGKFaY0i5UPZxLugrLI9f1auQilSaT8RiXnanN8
	uctpwXnIXRG5OTrktHVCWdk5Uu74U+Socll9ED3RUa0iYL9GKn45/GzCARJ2RfXiHY+4C0
	vTKUZvTzGiaCYs661Dk+mgCE/OKcWQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE594601F3;
	Mon, 22 Jun 2026 14:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55CA1F000E9;
	Mon, 22 Jun 2026 14:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138106;
	bh=ulp3AjMI7B4owCFSWbljnqEOw+fQMJireuqm4uU5XDA=;
	h=From:To:Cc:Subject:Date;
	b=f5upGlO7tDaw2xoj25Q0J6HRHLPKbqkTMUPQDH4FgG/FbyZTeze8a9YMz+D4OqDnB
	 8xf4fWEYEmNX4IiqH4yHZPl4G1Mzru9Eqmnf03K2ePUacbq4Wa7INIoebAI8vYoba+
	 DAeupamDMxxuR/rO3R2O064FMtTTcdy7tCJjfw+p6hRPHYWX+XSkHPmaBiD4OILXUY
	 NAgWjSG1aPqi/Z0NhR0urrhchDa64wjpL2SJbrjrrpTBEK/G44vgaavy9U4LZwu4WI
	 GWwKpPmS4/SPsqZikB4uB7VhnW3ZDP7HjvtPYIrzsEm8sDGDrs9MCiIT3DLdx7ui0I
	 BwdmvhSgoNg8Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <shuah@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [RFC PATCH v1.3 00/18] mm/damon: optimize out nr_accesses_bp
Date: Mon, 22 Jun 2026 07:21:20 -0700
Message-ID: <20260622142139.30269-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 302C64000B
X-Rspam-User: 
X-Stat-Signature: mrayk8395w5q4gqb45m88cxjxzup3pj6
X-HE-Tag: 1782138107-935986
X-HE-Meta: U2FsdGVkX1+lSvjJbyOPpaPjDQNCWAcz639+mNM84hV4ygb1F9hSZM3A62dVtrR4pLCawEuq215/tkIoaRtDtt+1t4ncyNwcC2dq7pWPrZepWK6lQrA+4ZaVW+AhTPf7jWzYY8bZNEREZlp3pcmn/2e8wvNVhTx6TadDd7TP3qkB3OgfAR7wUZTz1+mi2A7nithiFsSXB8a9j7/hAPFVLSoQ5ZP2F8/msC0Flkqw0PQyo6NlATP2INBz7FL4BiIM97+uVRjrJhakMrPt9P8lkODPuyHVcqkg6kN5cM0qLoLK7uih5AbA7FImETNpFoxyMYpq8sz3eLIdJT8+Am5Ypkm6JzOycybcvmsjmqyQDDEs4HIxM5CxUauQMcqoC+mBRNKCDpdqqHqbo4qTLX6zp2gOPTyCGfmwIt4YVbnzEpRsdweFoNYVsLE7JqczDZVaL5AQ3oL96cFBHJrWNwNLPmadxqZIBE7ygGBcVkI2HCCPJ6/jqpIwXDctVEpXZRb0hwD8yFReNWXlNFb9E3mQZergg4107FyXHMGNvlTr4JIlzL7cPro1iJuziB+gI5TQS3q5b+XXMDotS0MKhxpIHbvTnAWv3t+0vFtyGgIdCqrqY0yr46UV/gi64AKYai+B/kqngkwh9Xsyejg0+UXwhRlXCJBreGT1kSNLvvSdZlBGJFkhWcEyILQWH69i+zj4MM2ImUIr4T+xe0AzjUwEMYKQgzCkWqr90zxeDRxcWNCPNAiTeafCDGdxJiiRZ0wT0WNKpwbddN/2XR/VZaMGX01kezb97NmSCX00K6Ow4tnreubYzJVwBqXLuXmAtHnMsevlIeudyzlRpcBoWXkSS6D5t+yHcWvogxm/qp2yzvAUlFN2d7cO4KBYC8LaPKAVpi+17ERTV+rLcvN0bEn8c2GiFqHEtNGhgHptQxfA+aKKrxvh8lJDGDvXEmCMd0IPWmxcLMmPtIUUER0GqSS
 mGOB6biz
 TH9LOwwgjHHv4yKE0CRvMEo0C+4FJXf/cGhiSxDJHTRCjCyPab+nPPK+bZaViHwBuit3Q/R5QIxNMZENjuB0xHw5Cnpu67Lonr4tH7A0pcBAOxbDD9MJQNTikCoddtY8ATxGcIBNOYNssDbkj0QZ3ZQQdJW3xA7KoaCfaDESkjerpNDkqnf98UZqIaswfNPLuMOBzIk/WoSDcQcnaWrBEbU2qJqIG85SCx/jQCbeB6qsC2d2UptI73PXj488oiYlE4VEvXfZfviWJGFK1TT9mnvCekk3zx4OyoKpx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TLDR: Replace damon_region->nr_accesses_bp, which is easy to be wrong,
with a simpler on-demand moving sum function, damon_nr_accesses_mvsum().

Background
==========

DAMON's monitoring output (access pattern snapshot, or more technically
speaking, damon_region->nr_accesses) is completed once per aggregation
interval, which is 100 ms by default.  Users can arbitrarily increase
the interval for demand.  Under the suggested intervals auto-tuning
setup, it can span up to 200 seconds.  If the aggregation interval is
too long, the snapshot users cannot use it in reasonable time.  To
mitigate this, we introduced a new field of damon_region, namely
nr_accesses_bp.  It contains a pseudo moving sum of nr_accesses in bp
units and is updated for each sampling interval.

It turned out keeping it correctly updated every sampling interval is
not that easy.  From online parameter update feature development and
more experimental hacks, we found it is easy to be corrupted.  Once it
is corrupted, DAMON's monitoring outputs become quite insane.  Hence we
added a few validation checks.  It is easy  to be corrupted because it
requires every update per sampling interval to be correct.

Solution
========

There is no real reason to keep it updated every sampling interval.  Due
to the simple pseudo-moving sum mechanism and existing helper field
(last_nr_accesses), we can also calculate the pseudo moving sum on
demand in a much simpler way.

Implement a function for getting the pseudo moving sum on demand, and
replace nr_accessses_bp uses with the new function.  Also remove no more
needed tests for nr_accesses_bp and the per-sampling interval update
functions.  Finally, remove the nr_accesses_bp.  The new function is
quite simple.

Discussion
==========

Depending on the use case, multiple nr_accesses readers could be
executed in the same kdamond_fn() main loop iteration, which is executed
once per sampling interval.  Such readers include DAMON region exporting
tracepoints (damon_[region_]aggregated and damos_before_apply), DAMOS,
and DAMON sysfs interface logic for update_schemes_tried_regions
command.  In this case, the new function will be called multiple times
and this could be overhead compared to the old logic, which simply reads
the field without any additional work.  Nonetheless, the new function is
quite simple.  And the new approach does nothing while there is no need
to read.  The old approach had to execute its update function for each
region for every sampling interval.  Hence the new approach is believed
to be even more lightweight in common case, and the overhead is anyway
negligible.

One more advantage of this change is that one field from the
damon_region struct is removed.  On setups that uses a high number of
DAMON regions, this could be a potential memory space benefit.

Patches Sequence
================

Patch 1 introduces the new function for getting the pseudo moving sum of
nr_accesses on demands.  Patch 2 implements a unit test for the new
function's internal logic.  Patch 3 and 4 update monitoring logic and
the new function to ready for safe use on the existing logic.  Patches
5-7 replace uses of nr_accesses_bp in DAMOS, tracepoints and DAMON sysfs
interface with the new function, respectively.  Patches 8-10 removes
nr_accesses_bp validation functions in DAMON core, one by one.  Patches
11 and 12 further remove tests and test helper for nr_accesses_bp,
respectively.  Patches 13 removes the setups and updates or
nr_accesses_bp field.  Patches 14-16 cleans up function parameters that
are no more being used due to the previous patch.  Patch 17 removes the
function that was used for updating nr_accesses_bp field with its unit
test, which is the single remaining caller of the function.  Finally,
patch 18 removes damon_region->nr_accesses_bp field.

Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260621155715.87932-1-sj@kernel.org
- Explicitly ignore nr_accesses from mvsum at the beginning of
  aggregation.
- Fix a typo in a commit message.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260620172244.90953-1-sj@kernel.org
- Handle next_aggregation_sis < passed_sample_intervals in
  nr_accesses_mvsum().
- Always rescale ->last_nr_accesss for parameter changes.
- Remove unused attrs params from damon_update_region_access_rate() and
  its callers.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260619193415.73833-1-sj@kernel.org
- Avoid divide-by-zero from zero aggregation interval.
- Call damon_nr_accesses_mvsum() for damos tracing only when it is enabled.
- Remove obsolete mentions of nr_accesses_bp in comments.

SeongJae Park (18):
  mm/damon: introduce damon_nr_accesses_mvsum()
  mm/damon/tests/core-kunit: test damon_mvsum()
  mm/damon/core: always update ->last_nr_accesses for intervals change
  mm/damon/core: handle unreset nr_accesses in damon_nr_accesses_mvsum()
  mm/damon/core: use damon_nr_accesses_mvsum() in __damos_valid_target()
  mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
  mm/damon/sysfs-schemes: use damon_nr_accesses_mvsum() for damo regions
  mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
  mm/damon/core: remove damon_verify_reset_aggregated()
  mm/damon/core: remove damon_verify_merge_regions_of()
  mm/damon/tests/core-kunit: remove nr_accesses_bp setup and tests
  selftests/damon/drgn_dump_damon_status: do not dump nr_accesses_bp
  mm/damon/core: remove nr_accesses_bp setups and updates
  mm/damon/core: remove attrs param from
    damon_update_region_access_rate()
  mm/damonn/paddr: remove attrs param from __damon_pa_check_access()
  mm/damon/vaddr: remove attrs param from __damon_va_check_access()
  mm/damon/core: remove damon_moving_sum() and its unit test
  mm/damon: remove damon_region->nr_accesses_bp

 include/linux/damon.h                         |  15 +-
 include/trace/events/damon.h                  |   8 +-
 mm/damon/core.c                               | 201 +++++++-----------
 mm/damon/paddr.c                              |   9 +-
 mm/damon/sysfs-schemes.c                      |   6 +-
 mm/damon/tests/core-kunit.h                   |  37 ++--
 mm/damon/vaddr.c                              |  12 +-
 .../selftests/damon/drgn_dump_damon_status.py |   1 -
 8 files changed, 119 insertions(+), 170 deletions(-)


base-commit: e08d3bec1dc38cc991fc819afd698bf7bd07bd6d
-- 
2.47.3

