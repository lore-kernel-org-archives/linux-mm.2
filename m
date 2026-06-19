Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC60CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE276B008C; Fri, 19 Jun 2026 15:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D608B6B0092; Fri, 19 Jun 2026 15:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E826B0093; Fri, 19 Jun 2026 15:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1656B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2AA440530
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:30 +0000 (UTC)
X-FDA: 84897663900.07.EDA816D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5CD8A40006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ru/rrkCf";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nhBjiNpTVYOHJKwKBkORiEIV5livVqDkEf2uu8Hai5o=;
	b=dJfIJcFhAToIhf73gtvHu+RgQ/nx1D0wAvmUcopf1ScX+VzikNTsSNLPCCZPfU89CLbLc2
	iW7JRIC48SNOi1yQSdw752uz+uHMs5K99UIcmemtzGtfVxAEtKaY92RHQAkZQo65PJ+Gs0
	INzcgR+QC2PcynUYCKYKc3Fep8s/FUo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ru/rrkCf";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897669;
	b=jjMruN/6WF+OyVecCCLK1VN/RIN3I5t9UT0p3KIopDC5tQbPF237MLOr6R+yeJCdSzMCcS
	R9hkeUZ56CTRA8Gns4+HZ/lm/KY9LpMmgrpiGVKwIvl4qtrnjmHGP5MNK3M7PHE17iuM5D
	L4fp3SZqe6OU99qe5XTJ2AkrOwCYFEA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63EB3406D9;
	Fri, 19 Jun 2026 19:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449A01F000E9;
	Fri, 19 Jun 2026 19:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897668;
	bh=nhBjiNpTVYOHJKwKBkORiEIV5livVqDkEf2uu8Hai5o=;
	h=From:To:Cc:Subject:Date;
	b=Ru/rrkCfT5gq968L1/RCUMS9wO2LVANCEZixdfQ7yXhZaZU1n1nywg7CKO6y66bgj
	 /pBTDjUjf31Cbn8d4q2dE1X1+disbJnizIxpX3ogV0eFCUvI6pY8YDvoHTk6PPJsS3
	 h7xk8iKNUJA+50C7sB3eIpP/Zp8wFMTl7Mipxyo1OOFuoY8SJRiUg3ykeJwjWjCH2Q
	 s121vLA3FXZtHSn2/S7/rdjyfmbQDkU7eeBOUdpY4AqcOhBuWTqwBUxO2dIaCI3O2B
	 fpFQ6rsWhu8z00e22Z6UssSUs/1aIMITG4V14xU3QXqXw00BA3y2xEqrdiuDIcVZ2l
	 Ir9hHJC4swZsg==
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
Subject: [RFC PATCH 00/13] mm/damon: optimize out nr_accesses_bp
Date: Fri, 19 Jun 2026 12:33:45 -0700
Message-ID: <20260619193415.73833-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5CD8A40006
X-Stat-Signature: s5sqgousi1tyzz3htrio9ojjoazurj8m
X-HE-Tag: 1781897669-969553
X-HE-Meta: U2FsdGVkX18aC9snPIJ2PBuQz5Uo3+8dPqNlo2IzRDBaDAE9EQocGsOmy0j9BibPtVvbak7Mzl6u9ebZPoWfhoqGK+eL7IVdoNUu0QMjw/grn1SNKOnlXZkR/t+MOG+scaKTXfg8CaUchaxpjBNQC7sBBLTTYBHYB2pQFoIbUN5bsdy+CXNcC05Y4r58bvnEUCH8CU+afKkjC5vf5JEkm3gqKRYXiH7psvzkQMGyWrBCe1igfRtsbhJz6aVOJJDhPY13iyqJWnMavd0MV2YJgBBRemhFSnSi/ynPm6bPGUX7ppGTa7/dutUGJ2ALX2XIQTqQK9sRS+M0DGsz5xm9ZaOh2dP4V+fOLnfbdaqe/B9liVvn+ttmLTO4qsxYjLdxnMRs3s5m1IeCOe3QAFleWhLe8jGq/6GGHh8OPPE+B1niEVRZv+vKhO2eKXzFLgTiqVo+S6vxHNtRXCN+lMFo/zWMVR405u1BvnE938n2vNoBkGhm44NeukmHrJmQGV8yNwzirrOfD1Pm7HwSj+aeZcIVoagm+lFV7CnffApcMqD8bM7zM0aKL2FCn+vJ93OEzb5YqS9sYjS3rMfVMQVwdH/dhStsAY9Tw5KTM7O98H//3Vy0BiBmgnDEQ+S/j3JknO2GWSjwZ14RI+OEBCmiQNaRrzPOSDDRsHhCDuOyBIcdrqn4uOKVoUrVPZqCX4IZAp1ltNvg/9QKk1l4JFy0C5pagcnJ1xUOgfk55js3gPRrV8wJq2jubpxMLb+8gPP6IGPOoj0WENWYWKbM4BA7kuk7zerR2ffmFsZic27c84507rQhZWsBVer6mEYtDyMH3jqlOnRBWAMdUTYZmwoMOptuh4aAbotcZoGH6tL1JgXPLTfw2ww77jpZpDDpg6wczAL8VYp49lSsQFUeLm4ybSQvJ2pd/rRq1Rve61MqwYsGVsOe9NXp0MzK0TaU7Rx268h4zCsm8xX2yEPsaKY
 XtypJNDB
 FJ4bUEmPkqRDfdpj9WQleL4WOGukHLcHxIEemJCRTM+4JX3yIUb8Gs0586CM+GJUtUyZ+X3I1i/mYnVu+XS5AXiqT7OskMjifoXnSKtCNWCtw5EgLDsLTCGZa0vR+x06y3HZxDcz/r7XFSlMtvzfMqVa2EixVwzGDTFOfCCLqxLVMIIliNmHNRSz6UwFWrt/ssaw6niv+rLFc1t7QLHLcKvIjC1wFAZNiiRbis5Flh3HZ8yGK5aPeCRN9G+8Vv1zh4bcH
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
 mm/damon/core.c                               | 171 +++++++-----------
 mm/damon/sysfs-schemes.c                      |   6 +-
 mm/damon/tests/core-kunit.h                   |  37 ++--
 .../selftests/damon/drgn_dump_damon_status.py |   1 -
 6 files changed, 91 insertions(+), 144 deletions(-)


base-commit: 6c6dd09066e98c4afcf61f404d5b2b87f35e3321
-- 
2.47.3

