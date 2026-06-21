Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F7ACD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38576B0005; Sun, 21 Jun 2026 11:57:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC21B6B008A; Sun, 21 Jun 2026 11:57:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64326B008C; Sun, 21 Jun 2026 11:57:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 672596B0005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA09F1C53C9
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:28 +0000 (UTC)
X-FDA: 84904374576.21.8C05B61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 60EF6100008
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BoACW9Ni;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=g1pqP+v5eFw/D0i46DGcod2dVlXszJ2Fl04pLNpvs9U=;
	b=b+PdrDgYPUHPIG0D950LdlBRfwoJckDE7KnH0wHjbXZJryADs38IyDw2sQLQsoBAcBnFWZ
	gXzVjLW5SovkoMhtk55GfNfyK4cC/5z2q6JB78XfhBS18WeGyHYuyDpwd+NjXmzwr/f8zr
	oQD2MHwk1HBjd+4PIqHohown3qVJGfY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BoACW9Ni;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057447;
	b=h5LCH/ho/LOO721s2AARvV2uiukHJpxUzIGXm7vhhrBK8+c/QiafrnAXU1wZInp3ZI2j/c
	5dx3KMdZpQscIEyATWnFxNH8GgRk7+hUf+5/bMO1h788czzJ47QVKM+O55aOAMllJH/DRP
	Tu3RKKC88859uXLlUW9lHrPwkbiJOjE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCD9060051;
	Sun, 21 Jun 2026 15:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C271F000E9;
	Sun, 21 Jun 2026 15:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057446;
	bh=g1pqP+v5eFw/D0i46DGcod2dVlXszJ2Fl04pLNpvs9U=;
	h=From:To:Cc:Subject:Date;
	b=BoACW9NizvQsg0kI35M8hFvmeYUpzx/OBlgZmcSWQ8fnhjhmvci/L+Vf32yaYcVLo
	 KCJ5tMUDHmnGEUgeZOMtblgXQoFMiXeMJcs8MrFG56cqTwS5ZBTLGDcgl3VJmcLDgV
	 p+1pEcmGS6wxGozQsOgMeStHEPu/MCcDdk0ZwdK6hZKnc72Km/1pGKkX+gUWpfpTHD
	 vflzaWzmj7cUKmJ1LmVznyEbaWTsKBz0Dl2yvW3Q4w4baPr/SgjRPWGAyuUH0g9VnY
	 qTVmfZFBozH+6Cmi2R2dlZqK5LTfDHTcUoxSm5Rewx3KjOYlI0oSdYuowqdWFq3+xH
	 AArfOhhO444Ug==
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
Subject: [RFC PATCH v1.2 00/17] mm/damon: optimize out nr_accesses_bp
Date: Sun, 21 Jun 2026 08:56:56 -0700
Message-ID: <20260621155715.87932-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mr6atdpc6zy96fooqjgk531msq83ptw1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 60EF6100008
X-Rspam-User: 
X-HE-Tag: 1782057447-861065
X-HE-Meta: U2FsdGVkX19yruIKtSu3BFWwypQXjfPwnEjO/C7wjs7hYvr1jN3jwK9ZYE2vOXOkt+6GkhmtT4dCfhFRQks/epd/LQ1rg5JsXcxX+AbUnBrJA6L0WJNTMJH6FfB0UTtMI1n2k5VNfWzcJsR54fFeBFkNU5suSvo3QgssOg3DQhnAeB480x+B9/AqM9+NGlBqTZC6jduas3s+pISm5bzKDL30CO0l/MsJznK+k7VKFK29UpBDxl07XIKSsaSO3K+kaR5UjwHeUXuVoTdSfZDvFQMMr2/Yyk6j/mYV/o8CUB6a9gQEiiZMoZ/FpPegW6MRHmPQKo6ZIWo2TGqzVzNl6cmr30I0rwBF37fAk8QthisLIdLSKbQZiVv/Y/ab31TnTlIzXwzJVZHTiOcDWMqbrEd7djuDuGUm/3bqMmWuhQQRsLen1x5P+gLaLcguhxFo1mf548vOUKJfEsuEPjf26tUTILPt7PG9s+nRQEK1Cz4Vtsdd4no0dfH/au6KuEhEaoEhqCyKD7XVateflDivn7jfeet0/9wM1BcJniPLR7E0o5Nl8+RBxYegdukz6Tf6OHfp8Gu2TN/eWDjuvuFx6a5CREwKeVjB/CoX96rfOSL6RXImOeBcTqezFOcPfA8RL+BMpNoDC5Jl8QzYqSJyBt26f8Y/foxvWSHbSZ4Xf0LylBy1ICRp4lYWvhab035eRGa6B4mc72Aj+A/woTY01f6cjv2D7105xEl1C7klPlvJWIPF57bSfgjs42WwxCwDA5gQNZGsInvxRGg10Rf9vzZ+wQr3OhLo63KFjQd8GOplXuTwrBmV/jDudWEWQwGnoURDB04o7uIvop5wm7yxiQYLArlII6XZ0PAV8L85LPz5lj8NxLn/gmlJxkvul6hFeGlIzUzpX0cck9YDrMK3n5md1AgY/cOy2D/Gg+hjHnr58XZPwN048xRnivnqeTHc5qMgTYkugs3DYUsnY5Z
 YpN6iZcV
 pRPMVTarfRxtyaWmF0sk9BQHjNWFUVIew7TI8O1Zkn3hNkcEVCojdRYXbZmVcIQJWjVVa8Kguy4qGiRY9nJiJ/miRuwF6lqRCbus5T8AbnjP1f/cU+IDtrfkufuBwZzLsI1y4MTCXiQcgx49qXOmle74+hF1soLhGKTlhHrZnPzFHsCevKHp1RJkzPWcZpKb0rLTEy2/ufBNmkqcE54lN31iPFKzK09xUrP0I7L2iImRzuHh53Eh9eI5+5ub3EQvjnmrrk+xi1sgiVzz94oiWrauRKXE1+Klms7FY
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
function's internal logic.  Patch 3 updates monitoring logic to ready
for safe use of the new function.  Patches 4-6 replace uses of
nr_accesses_bp in DAMOS, tracepoints and DAMON sysfs interface with the
new function, respectively.  Patches 7-9 removes nr_accesses_bp
validation functions in DAMON core, one by one.  Patches 10 and 11
further remove tests and test helper for nr_accesses_bp, respectively.
Patches 12 removes the setups and updates or nr_accesses_bp field.
Patches 13-15 cleans up function parameters that are no more being used
due to the previous patch.  Patch 16 removes the function that was used
for updating nr_accesses_bp field with its unit test, which is the
single remaining caller of the function.  Finally, patch 17 removes
damon_region->nr_accesses_bp field.

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260620172244.90953-1-sj@kernel.org
- Handle next_aggregation_sis < passed_sample_intervals in
  nr_accesses_mvsum().
- Always rescale ->last_nr_accesss for intervals change.
- Remove unused attrs params from damon_update_region_access_rate() and
  its callers.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260619193415.73833-1-sj@kernel.org
- Avoid divide-by-zero from zero aggregation interval.
- Call damon_nr_accesses_mvsum() for damos tracing only when it is enabled.
- Remove obsolete mentions of nr_accesses_bp in comments.

SeongJae Park (17):
  mm/damon: introduce damon_nr_accesses_mvsum()
  mm/damon/tests/core-kunit: test damon_mvsum()
  mm/damon/core: always update ->last_nr_accesses for intervals change
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
 mm/damon/core.c                               | 198 +++++++-----------
 mm/damon/paddr.c                              |   9 +-
 mm/damon/sysfs-schemes.c                      |   6 +-
 mm/damon/tests/core-kunit.h                   |  37 ++--
 mm/damon/vaddr.c                              |  12 +-
 .../selftests/damon/drgn_dump_damon_status.py |   1 -
 8 files changed, 116 insertions(+), 170 deletions(-)


base-commit: 6b4f924f70f92679c81959ad6b9234242aab74a7
-- 
2.47.3

