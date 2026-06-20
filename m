Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9372ECD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D406B0005; Sat, 20 Jun 2026 13:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464196B0092; Sat, 20 Jun 2026 13:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3966B0093; Sat, 20 Jun 2026 13:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6056B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:22:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51C001201D0
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:22:58 +0000 (UTC)
X-FDA: 84900961236.20.4C51650
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8AB5140006
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:22:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iuyi5ggm;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h+feMnzBSlgDokl+hk6/kvzQur6aofhh+JGbxs86k9Y=;
	b=YNCG1hWjd5HKFZpLa+T/07AUVI7v02xlcAXMjriGSO6vzjr/Z9UmnJY+zErrTyeS1ztAxw
	R9NcFOyR1uzl5+LNCbd7FvXBYpivWxW7XF9xHAxcJ1++Bw/4uCrOlBzPvO8/4zMOqdZF8a
	dK3AVrP0vqgS8G7EDtV0rSzJ6ivUQKI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iuyi5ggm;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976176;
	b=WDpZyKbq5zhU65z4hsq5lch8xoORaw7WCGIpztIhGx0hAgFeI5Ig2UZCNLxj8w+aS5kPIv
	A87cQzJYVZJmH83A/UShYebQJm84Tk+Lk0LyIBEzKbDCIcCV+BHYSFh3wxvCE1OL+0Forn
	SJp+b7cKzqeK85hqjPoRZ0EHNj8fwGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E62F40823;
	Sat, 20 Jun 2026 17:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2101F000E9;
	Sat, 20 Jun 2026 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976175;
	bh=h+feMnzBSlgDokl+hk6/kvzQur6aofhh+JGbxs86k9Y=;
	h=From:To:Cc:Subject:Date;
	b=Iuyi5ggmnFZk67+k61TzLwwpXd6dzbhiq7CxDCPQ/2O/N5G+wA3Wg4UZBzSOxSZBN
	 PzPBG8YhoTSjWxscMc9YONVhbn7gxxe8I7WMfsBeEZ4rsjRt4nesvgr5dzRtvzDp92
	 W+OdkOPjiKC5LJclbKZyFFGD3q4vBuKrsyLuZhi5JVpdePvujfSAb2jSS5xm4X+Q5f
	 tJ+RdTQVDkdHqhlXKwlakoqfJGDqdhxKHzX3HfFjWAZ8ZhOV5DrgBCQ8wYBx8A43hK
	 1KOfwv56Z2AGdk/t448u07ExluqcE3zq91CYXPsHvYxgjiOYnjcP/oZkHdwjT8KKZE
	 vzW4fl5IDUCyQ==
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
Subject: [RFC PATCH v1.1 00/13] mm/damon: optimize out nr_accesses_bp
Date: Sat, 20 Jun 2026 10:22:30 -0700
Message-ID: <20260620172244.90953-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8AB5140006
X-Stat-Signature: tg3njcegzap93ktf4ib5zk9y7xzae6xr
X-Rspam-User: 
X-HE-Tag: 1781976176-41211
X-HE-Meta: U2FsdGVkX190ZtiCgoBtM0hvFxzdt5nBxOcx3xAjdbLC62r+CHK7SX4rnpkS3KTbz+TmIWJ6TW+TmggG+k0YQOxKXwdlvwgB+xk0M3vUJldJ2SYZsZwMLGLIYyfvdSeC4jXfp7LEzZjtonJYbyougP5M5jbnuuF2qepkJhJniBxHTSw6iGIEU2Xs+LpealTu0jNeNrnVPlS/DJiczkQz1Tdw5fMFHuqBYRqeEffVp2b5qX5iYepeidRPzR6e91Gs70mPKPGgxFGJugo1sLoielN/mNkPg0m1+v8mDEgdXmCgvFOjg27KdvKnO62S/SbXoCXKVsA6ltxRl7PiKfWl//aLuIFhlrglt9znzRn+PwJLpGlnVUVUtmhLeJ+o7oBalLlL/lLfTxjP8zYSwME3y39wb91tkit8p9R8DD+XDu2Ap+KaWIzKiYQRHK6+HSDGWdFJVYCsGQzfTlB6X1W8VRiJPdi3aY1EyiK0T2aYcy5eG/AGyCnF+EULmBmA+rm6jDG3hTHJ7WBG1KXvjlUbmeHClXwnPDyYEe4MJ4P0g+6wOCORmRNanW3aMhBA6XDLheeEXC/Z63vhf56CCF5nA7sYxSOerzyJCf3hXCGYoqRgOgQgNR4jsW3tLlbtlw3yj+ahBPG3BRE7KggFFW5KJvUDAIFOUphzgCL/JUBC3J06I7gnZJaQpEOk16NWFu1hS1qpt4HnqQHm/7Usp+D3N4VuPoBTA3okjxWGOz3N7pJStdGWTAtCU6KzCabII3JBU1m8jbB9X2n5Ofjv/LOTzZgI6MWoGIa2g4tPfXd8+Xkz4VWqOHOiJzjbirmAL1cj4V8ybtLrH3/6NXE9SYxxL0lUG2DISCbEQ80A5ia4E5zXGehquCGj1sOyTWpbVX/53HSVtW26zYrTuANpyncUkojajyREbP7qc/MMu1BgJVir2o4hYdoAzKDR0fl0z071AILlF2NmYQXpXXWhveE
 Yw1ZifLt
 PTRVJx7i+LMFhA2IXTe5xqqlKkdHdjTXfZ9dP/RGgIgy6l8TqwMicvlqnknZFGM/CckYkDgpEY44ftZOMwM+SdqY/AUAjLzeSWH0kCugQuYsqIbNzcbixBLcKDut2T+CciiaNpOFt3GuM9DPx31fiJ1JuQo53cDdL1ZctiY5/OuRNWghSskDvYaWjQRj1ibSrWMf0QSUGeMCXQ3A3PzBq5pfkccWx7zkWZGjcYMTB02Hlvs3BHxRygEHVb84kfUCz8aC/Qyznfe7ZcA6j9/KedZOpOdNXe0sAO47/
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
function's internal logic.  Patches 3-5 replace uses of nr_accesses_bp
in DAMOS, tracepoints and DAMON sysfs interface with the new function,
respectively.  Patches 6-8 removes nr_accesses_bp validation functions
in DAMON core, one by one.  Patches 9 and 10 further remove tests and
test helper for nr_accesses_bp, respectively. Patches 11 removes the
setups and updates or nr_accesses_bp field.  Patch 12 removes the
function that was used for updating nr_accesses_bp field with its unit
test, which is the single remaining caller of the function.  Finally,
patch 13 removes damon_region->nr_accesses_bp field.

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260619193415.73833-1-sj@kernel.org
- Avoid divide-by-zero from zero aggregation interval.
- Call damon_nr_accesses_mvsum() for damos tracing only when it is enabled.
- Remove obsolete mentioning of nr_accesses_bp in comments.

SeongJae Park (13):
  mm/damon: introduce damon_nr_accesses_mvsum()
  mm/damon/tests/core-kunit: test damon_mvsum()
  mm/damon/core: use damon_nr_accesses_mvsum() in __damos_valid_target()
  mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
  mm/damon/sysfs-schemes: use damon_nr_accesses_mvsum() for damo regions
  mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
  mm/damon/core: remove damon_verify_reset_aggregated()
  mm/damon/core: remove damon_verify_merge_regions_of()
  mm/damon/tests/core-kunit: remove nr_accesses_bp setup and tests
  selftests/damon/drgn_dump_damon_status: do not dump nr_accesses_bp
  mm/damon/core: remove nr_accesses_bp setups and updates
  mm/damon/core: remove damon_moving_sum() and its unit test
  mm/damon: remove damon_region->nr_accesses_bp

 include/linux/damon.h                         |  12 +-
 include/trace/events/damon.h                  |   8 +-
 mm/damon/core.c                               | 180 +++++++-----------
 mm/damon/sysfs-schemes.c                      |   6 +-
 mm/damon/tests/core-kunit.h                   |  37 ++--
 .../selftests/damon/drgn_dump_damon_status.py |   1 -
 6 files changed, 96 insertions(+), 148 deletions(-)


base-commit: a74bff7aaa4b3a64070425b4b367a459388a8233
-- 
2.47.3

