Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F161C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB766B0096; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA2A6B0099; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100986B0098; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3F686B0093
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:49:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EAB01C3B0F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:06 +0000 (UTC)
X-FDA: 84964077492.01.268FDCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E7489120005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VlhsMs58;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=di2Omsb6NMSBZD8DrcCMzDSvay2hwhtM+GShb46YMM4=;
	b=zKQZrsUZvxpjV6+xizT7PjSk89AAmSFr6mtJnAOTVbFpXSzUzyTTx+mkgoU48UOHrATQal
	utdJ34i5o9kQzHmOtOGDf+P1/T5H22a6NzkTfs46GRKoSWOKY443uFvZBxLPRMAtstftDA
	H9h2WJ07CgiKw6d69zZScCQb+ytoUKc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VlhsMs58;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783478945;
	b=1HuNKF4/60u8wgWHKY2D3/tqTn3lgJ7xtd4vZ3syDPRF0Czcc0KUgXPSc5vEdPWlxSheWl
	QSUPX4Am0JfflVfPtKZOTx7QZd5YiPlqalHb0+YAydaA9spC2BTG9k8nr++Yw/m0iM0eQ+
	aPF+HBPpSmcRUsATcossLlS2NJVsA8s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC9A3416AA;
	Wed,  8 Jul 2026 02:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89161F000E9;
	Wed,  8 Jul 2026 02:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783478943;
	bh=di2Omsb6NMSBZD8DrcCMzDSvay2hwhtM+GShb46YMM4=;
	h=From:To:Cc:Subject:Date;
	b=VlhsMs586PSqacvNLg428TgMSP6y4/CI4k8TvlFlIt64T7yh+w27xIsoGGsHPKbiO
	 GIjIj5bC9YBipEtZJvymGljqPNj9iHgcqdYSg8HI4c2IURQrHhtZS2f/8TcwaqfTGb
	 uh2zt7h+Q5KtbkyPypyRyZ2aT4IX+WUBwaf2l+XfFNBK0mBcB00UIg7mcV1ba4uAfH
	 sTUr2cMNrffJPwW6Ho+My2EaXoU3xmNx8JEN7ecWTee/TQ30eXjcDCaL++ZGhDJ0IZ
	 V4KJd46nV6kaMKoj19tnk9AsiQhXskgxy9rpL8B0UhG3FYzApwfhaEnkoi4Ushrivc
	 Cm5/HMWG36vfg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 0/7] mm/damon: update probe hits for runtime parameter commits
Date: Tue,  7 Jul 2026 19:48:46 -0700
Message-ID: <20260708024855.116614-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fdku3o3bzuwuzqt6drisbfqejxtohqcq
X-Rspamd-Queue-Id: E7489120005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783478944-612106
X-HE-Meta: U2FsdGVkX18VnTdcEChF0EvvT6e5l481xkWOkF4OdLuu5AA/vDq88uZ7rDzAcUZXaiTzOpOL75WZ17yVPv53+mTQhUZpbVyPUKD70LbpbyRDFOJsbC9KAjaa/6ix38zooQsOjnpMOa5hRT96aOMmks5NMRA+Yuz2HsgI+SBo2G2TcMitbVOu/mZZqpPeFa9SzY87+vOEhcEgtJ6XOgNxp5R7RIByVnbQpMIqSNACS2m+NC8ssLw8D9PYUTqDcikeEP23uMa8rLc7hP0VxpdBQPObkThN6Pa1zzX82q55nEK0Lqevu0+zheUkBTvTgaWcGT+0IXXMj9BaIbkDU1kv6/RpqXopebky7bHDtNHg9vCLZqaPiSRHv6XRvru58JNLl3qZ4LX3D8e29ossn2kf6bYddmRRkOH6s94bkNsa3HL4HbKnqrokmT0VOSX8Ms7A0DQNzAKWaRJRswIpOJCU+P8yrt6sC8ZwyiKdkmsTEHVBTTvwOz/zb60jhqXm71PPHYoVNhvo74OM/V/L0zWruHnsOwJqGWoux1nMakdnQwDqZeQsaClvyIiFHgqttLS6FxTN2VJSrcSQG/DUxL8RdSEu1tIBKYxeYfR6V7tgKbbXsLuKKwt9yeT2r8pJQfbFFXyeY5YwBmtBDJthj4YwLwsqvHSFWlTH7JRoySMsw9v5V4tkxx6rRmBj+3Ost5TBQkLf3MU+tQ6yYuczVfi9Nk/3tsm1qBUtXIqRMv2lMW2QlRM7l6LSSZx7qyMPzo/5uCbG8BzqgByD6XR2sM2NiDK6yfbC/hVuicvMwqQ6c9WDmE5u9Ww99CAPC2GF9lMscZZ2mizsNd6x9b7VMYV6FhqGOot6iuO26snk4anHEGSuyzTeg6dU5UtDShhNjdvCzis3PaW2MwpwTEHI0CYwuX5iRom3QGMZx+2p5vIY14Q9Y+tId+i7lqn8F8fGKMh/r6aeeueEj18en4IcqUy
 TzyBeiRu
 gu/b4/QNJ+FJDaEbYUn42faS/OSYY3PfYVASJe3xM+t2voZiD8dAGfnf/e4pLXVreH60bl3Mz9Z1C0PnfEth9N2rhlaEHxuinz4q94fABU6pAFn9Mlq4TycCSGGr+UCnmFMVRjDBsodhGAkeqmPChJ501u7V3SnvLuZ0AHnPiDfbq+xdwvoKHSzOH+U6pfw18D0DQx652ibR1XEjE5cTb1ZpmifFFQjRDlwkZh8CysDVlaRs=
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


base-commit: 82154b14568e9b7abebe2fc9240eafd031e01b30
-- 
2.47.3

