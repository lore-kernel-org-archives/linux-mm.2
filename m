Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCBC5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9916B00F9; Mon, 13 Jul 2026 12:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A18B6B00FE; Mon, 13 Jul 2026 12:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DBC96B00F9; Mon, 13 Jul 2026 12:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE1066B00F9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 292D48B991
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:48 +0000 (UTC)
X-FDA: 84983909136.07.DC84E4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A56D3180003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y5R975aO;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kw48eNAzxFRXO6yZLVXQ5NvQIurCQHZvh9V8CBG541c=;
	b=36jT8my94l2maWGNoy1x0WHQXY3h0DcExbAIWKO0JpWRLTOJRWMj7FuUvcxhyhIkaN5bCx
	XmOwRrr0XE8aGOkI0N4NaHDoQFyHyuziwXPFDnSzYc/L7Z5teepYkMWr/S5qqViGkQmumP
	+nOfNHGHzyFiBIPuvhB7kRmmi+wuabQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951126;
	b=b3n3tYGNM6sktKkMfaLEKZgXNyna7/vcyueev0d8rZ6StfZx6y+6P9FoRcaV1JsCh+8YAF
	QYSjwHMG1a1av57xFZyN8vl0WgzbRoYVkE3TTNj2LDyh6VberRUFCHkvyWTr9mTg2QJhOF
	6ZJvGrjKQpKB3Z3HmTmaGhaXSC6V+NE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y5R975aO;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22C0D6004E;
	Mon, 13 Jul 2026 13:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A171F00A3A;
	Mon, 13 Jul 2026 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783951125;
	bh=kw48eNAzxFRXO6yZLVXQ5NvQIurCQHZvh9V8CBG541c=;
	h=From:To:Cc:Subject:Date;
	b=Y5R975aOCRLNoN4CCClsQVWkZ2zFMRMZznKjqildidyehZoUelNcs6ATVc3mjonKW
	 A18YnBR5cIur/f3whvlhNNuah1hRPblBSy1hd3uqGawgTIQFjpK+WXqn/lFZmdHfA2
	 hZEcSj/xhioRp4fTT47PJGTQHhCt1xIcGj91Jo1AhY21n675b+mlSokY3/0KnQNC1i
	 PlifB5A1j0TlHIPDT47wu/8VYo+584fQQ68909KnlC4UIHGc5BQ06b41eVdHz1xi7b
	 E7s5eufe1vv68EP5xHYuv3576UvvEuz4n1x4kIaCmpuFtoH7tt5JQutxxgYLpKfgCO
	 BRMhdprJ47juw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 0/5] mm/damon: unurgent fixes for infinite loop, NULL de-ref and races
Date: Mon, 13 Jul 2026 06:58:31 -0700
Message-ID: <20260713135838.32730-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A56D3180003
X-Stat-Signature: w5nbqcg48xdtjuf5cnr4gxuoisqqakbu
X-HE-Tag: 1783951126-509521
X-HE-Meta: U2FsdGVkX1/UBkWynTgRuOFPCVa/dV9PDTq2fCyZPPnhjaI8NpG6oo9OS5TJJCKOf4Kxw0PhBshcVM82UofEEhfHGnfeB78N456lNp3JA7g3b3FapiHMVWdcBRu1lKdRFqozJ9y8Nb9Iac0bhgdl7YpJrBAty2nq9dyqQU7+L+VM0uh/yKozf2ByVAxfak2I+v4CGFIdRN51D7S+c3hlsZ/HFviQYx2Cuq3n0vZSBUtT/J3WSUL+7fEZrzllgshOfvSNcFjWAqPgELcOGD0DT25znrlVKGqMNOutN3r0NfD+Ilh/VccQcU4mV54geWfDd5ExReSSTMoCRDIK2vJGLWI/yKAh1sXIO69pj8ce4Nk7OAg09v1kthIpqlPmbwnb6rE5PnI/PwEmwkBzz+y1chxX0dFT0zbfr1vmfFoELgmy0tKghCg63LtawnAGPFqbw9/6cJlNNHNj7c3L6mTvQg10jjzM8M8qNqHVQKnjN8lu6B+2duRcMnkQ7HMn08dAlPQdnOyrK6Pf/EyQPHB+mleUPAkkoOSZr30NAYE96T4Ig1mNm/rXAu4cZvtxhNRC2946+y95cxnIRUvzbwSzVzRhMrg2rGPIy+2Ouw6c6cGFZ409bbp+BCoP3P3u2oWk7AlawZ158WnOfcwYwanMRuO+m0U+PcpwgmIqea2oopoDGAyNeWmhptUE3URHoF13MU/1aV8lgljdqS6llR1QzCN3Yr6pHy1+GPPrWlaLpwuVSnrMSvaso70TPIrsMWsAbs0k8ji09E0IvHA5PLX8d7hhtX3i5vglFdBhqgOMt9GrTvc+d1mtFDIfcRnVEMBbrRtkiLRI7Or1sfmrLddSU1rVg+SR2vmdE4BnyE1RGrkw/GwAcvdq4QDXnUO0d5UqFefNuUAjXPiJ0UUTnPWYNRRwOXyIAc3eWM+2KIjTx0s6tkju4U6qRgPEpAwI+ZEQWBHE6wStCeG7asYJ/UQ
 i0Y7QN2b
 VTM5KXYhcfIR8A162KLZliuvyJQcqni3YyjkLGV3WQXNivMZ2UGL6cfRTWgZHfZtyTiXG60PAvxlN/k4XgxeiFQ1eGQ4LkpI22MRYLfhnqnVs/IDmVWGUxIWZI9v5vtK6plQ65768znXA8oi4kdVYiTxgBeG1Kbz1PsfmZYZzGx8OxF4jyF0ySQ8w0uATDgKNnp9OSK17VW+MoHv+PyaSU57Mc35FRVhhEgiUG+e2p9Y2VDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko found a few issues in DAMON that could cause infinite loop, NULL
dereference and monitoring results degradation.  The first two sounds
scary but the infinite loop happens only under unreasonable user setup.
The NULL dereference is only in a unit test.  Monitoring results
degradation is trivial since it is only best-effort, and those happens
from only unlikely races.  Still those are bugs that better to fix if
possible. Fix those.

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260712170328.91144-1-sj@kernel.org
- Remove same_target param from __damon_va_check_access().
Changes from RFC
- RFC: https://lore.kernel.org/20260711180409.82093-1-sj@kernel.org
- Rebase to mm-new.

SJ Park (5):
  mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
  mm/damon/tests/core-kunit: catch test failure in
    test_merge_regions_of()
  mm/damon/vaddr: drop last same folio access check optimization
  mm/damon/paddr: drop last same folio access check reuse optimization
  mm/damon/sysfs: read ops_id only once

 mm/damon/core.c             | 13 +++++++++----
 mm/damon/paddr.c            | 20 ++++----------------
 mm/damon/sysfs.c            |  6 ++++--
 mm/damon/tests/core-kunit.h |  3 +++
 mm/damon/vaddr.c            | 33 ++++++---------------------------
 5 files changed, 26 insertions(+), 49 deletions(-)


base-commit: 9d192aa422c3f9c503a40e5eb98093df671accf8
-- 
2.47.3

