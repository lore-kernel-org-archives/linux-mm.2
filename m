Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB00C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74F36B00A3; Tue, 30 Jun 2026 00:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF5A6B00A4; Tue, 30 Jun 2026 00:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F04A6B00A6; Tue, 30 Jun 2026 00:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 715FC6B00A3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E976D1A0254
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:25 +0000 (UTC)
X-FDA: 84935246970.06.8FB12A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D93040003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQXXX8vo;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792504;
	b=5ozHmvTV1b6gM5zfI4oPPqc1DvEMhsGMR3e0aBfXh71gIwS/u8ghNS4Mf2d1WhVIvsPaTP
	IVZ5NJEs7mdxcyTips3/WDUn0SPF+oSHXVYNTB/jXsOTI2OM05DNLXKYfpjmy6sITuSuYA
	7LOIAM50jI5LCWhLbB5HZB57lFnE/m0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xbDQiekMgO/KFya5RKRP9Live6IJ6QFxvQeuI2/y3bM=;
	b=19bX0ZN9F2qnwsCtFEepkA+lQOZ4PoPpPujuZm3/nI2FtFo0pN1xOrmYkixo8TrccP89AU
	MG2fHUJHTAm/32DaJRNAMeS/yPZ8xGxVbaLztD3ys13hi0I5KPR8VzH7iIgJdlE6yh2NYq
	fKEUutoV35tdU62u0gty9vIcjp56Deg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQXXX8vo;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D388860008;
	Tue, 30 Jun 2026 04:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119801F000E9;
	Tue, 30 Jun 2026 04:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792503;
	bh=xbDQiekMgO/KFya5RKRP9Live6IJ6QFxvQeuI2/y3bM=;
	h=From:To:Cc:Subject:Date;
	b=WQXXX8voRMwhZsrn4r0dr2n/sgzaxhek7sKjB+Fz8GP1KKjI+oMS0gt5wvz9fMWH1
	 d0eirhGW0NqVn6ThgyCXuoxtW2xpfsaOZkwM6W77a8nvfr5WOJaM8vvPu4ITECnbgp
	 id1FK7KTwEE5hMEBDXcb9xShQQws2IJOZAXcJ1g42fiVLe+SHJl3DHNlmNOspguKpS
	 RGEgnTfNtEfL2Uag26TZv4b/nwuv+93MGHDkDsCvWsNrlVK5fsQlJqtTpUeMo2oaZD
	 CCKssA3H46Jib9CQdPnIcc+AJhhJDsqWaqbNSZt4DpZY8ogU0SVt43se8wfBFywhVr
	 QOha/uAvsBmjQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
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
Subject: [PATCH 00/18] mm/damon: optimize out nr_accesses_bp
Date: Mon, 29 Jun 2026 21:07:53 -0700
Message-ID: <20260630040812.149729-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9g7zenz4map4x4kfbk6a5hq7gxe6ipym
X-Rspamd-Queue-Id: 7D93040003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782792504-782397
X-HE-Meta: U2FsdGVkX18w8fm+IesFK9CGRKOIbmB6AKyDMYzFdZZV7EGMOOLjduyX/985jKjLzeu+VlqRnBwoTTP5gFyjue4VOUkdoHkuaQ1S27+BtMY0lZ7tOREw7seXIq9nY5eArh5nzlDf+9dtfcnsTXbNGw8QZSumN+qw2jzI9o34uIhjXZUPa7wa4QKeh+0kDvhRiYyDafdHyKL0HDXgKZK+ACVTm5YfUCEdye6zomBWjEkSHZ3Tju4c0AbYZsCyhmB8p198iafFugmvqzGhjdGbAK9JO9uXoPDryvk6Bv//ZbVkMLUOYzpTGGDpTKdl4VRa41KBGi+oTGZGjcwf/R7cjVKYL/JisTwMEGcrQCUvfjmfAyPwUPgep9eAv98+SfjvU+H3Kp2sidXeXfAsrs+CdugjEgNGBlC3E4lYhsGhor+IVFeGB7LvMEn9FeHhnOcWHKdrI+z9FlT25FTRlk1eyze8Aco0BtMs9uqVhBKlJbAuFzop6ZJjSN8D2d+vbOyWVb5PCoJqXiLELt+lPKD4cQZsMhCU5Bqa6sfgxtE99HjZESaHOf8LqOXsV2DAriQN0cRq6mGHdO0UyIU9Jw9bj7NPINW06mfc25KRjWSTraqSPl2XAeTluWnKkSUa4YvprorxTe2qssFUc1tth/IlKdXdLs6M3y/6DgBZ78JgsGU/GU41rTYll6De+cw/G0Uru7186YyLUxxzPhKf8vpADuUTKKWPBpRPvEUNeOXiMXg95QFExtOxwZOzFFpOECZOqgDETtR7DU4FGYerW4jAIMsMSNI+SVtVtaz1FZNUB5IEFcGKpAdxG5lDtoXzPowYPIXGSSxZzHA0ZtXhYdtdF1T3VQoQE/vGRasCzJ+cNiZD++2UxOBw1f+0DdQ0RwuJQOIuXmQIt8WxNEKXi5hWkfuOlbOHsrzhfLDuBRGX9mX0IvUniJDOm5nW6khZDgRjaW/qVRdD+WbBPHFKjTR
 +eG+gTBs
 Lkiuo407q8+sKqvtYMzrSIbtlIQ33ZGnnmqoCD3rYQfSaFPCXAI9duJQ5rjhDt9WlPh2i3+MPY/YEFD6SKcnIMqewuDYDE9latiVACKmTuCExtb7tuUOlS6kwGZwvoBZJBaABcJFDtp7rva05NhJoZzyBOBBnd9uDxlmdJgU+1cRgwx8K/gziY3CMW9nmTYsFg3D7SxP5BaxdAEmLlJRBpGrvxsTqps0aBhF8RzJDf3pDi2NUIwabeHYaglhoMYczF6CNjCT/4i0VWkMdbZ6msbCNm79iUQfyinDD
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

Changes from RFC v1.3
- RFC v1.3: https://lore.kernel.org/20260622142139.30269-1-sj@kernel.org
- Wordsmith and fixup commit subjects.
- Drop RFC tag.
- Rebase to latest mm-new.
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

SJ Park (18):
  mm/damon/core: introduce damon_nr_accesses_mvsum()
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
  mm/damon/paddr: remove attrs param from __damon_pa_check_access()
  mm/damon/vaddr: remove attrs param from __damon_va_check_access()
  mm/damon/core: remove damon_moving_sum() and its unit test
  mm/damon/core: remove damon_region->nr_accesses_bp

 include/linux/damon.h                         |  15 +-
 include/trace/events/damon.h                  |   8 +-
 mm/damon/core.c                               | 201 +++++++-----------
 mm/damon/paddr.c                              |   9 +-
 mm/damon/sysfs-schemes.c                      |   6 +-
 mm/damon/tests/core-kunit.h                   |  37 ++--
 mm/damon/vaddr.c                              |  12 +-
 .../selftests/damon/drgn_dump_damon_status.py |   1 -
 8 files changed, 119 insertions(+), 170 deletions(-)


base-commit: d74f4c01f930b32580e172a786efbcb352c312f1
-- 
2.47.3

