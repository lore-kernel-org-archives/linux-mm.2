Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37990C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED8C6B00AD; Tue,  7 Jul 2026 09:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076AD6B00AE; Tue,  7 Jul 2026 09:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB906B00AF; Tue,  7 Jul 2026 09:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1F8A6B00AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:50:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D3EE168BD2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:44 +0000 (UTC)
X-FDA: 84962116008.10.68070A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C99871C0007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2jxb3uA;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nr7LiDJycW7rOXIUJ0Nv9/D3v/lvB0yYNIb1OxPaUcw=;
	b=INLdnddddbrgfVYB68CVWTH+Rr5qItQlU0wq7HRveLphiQG+3ceq+HCVGqMF43dCevfxsk
	T4qvma4/y3CdDclLeX+4q5cYprsFq9MUe7C/EmVh3mDHFzhCsmbmmtXqqGhJahM8EDLMeI
	fLiyAdUaTeptjAVHaFSkLbdZFfFzvOQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2jxb3uA;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432242;
	b=Ghjy1IhDGGZ5lemL7anzF0Gk0hzO4XJ01WHrv6CC47EQy9AQJPHPldsfzCSiGNIp3aKrQE
	wwoiHbfiBbHEGrzZJiAUeg1Kd6bGJB7hmPNYdW5o1PEBpVXTcNQvbdscMDreSeMeilbPNz
	KWwLpamqES5ru4N0rfelDUyzgrSbtmU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26736601DE;
	Tue,  7 Jul 2026 13:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1FB1F00A3A;
	Tue,  7 Jul 2026 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432241;
	bh=nr7LiDJycW7rOXIUJ0Nv9/D3v/lvB0yYNIb1OxPaUcw=;
	h=From:To:Cc:Subject:Date;
	b=L2jxb3uAGdDvzvWsmN5zCrK1xnY0X6efwdUSRFvER7tfHfXesBy7pwDqu/Xi4xSRs
	 WdQ0R3V8e532UpspMPX0zLEnU3xXmppIB+tTn/G3/NDkQ5OV97E8GBc4SLaLA+Rk17
	 3l8EVZDPrhfwPl02R0dhSMuFcrnCjTTJIQPKyZud57BO9SLrP+m+KFE8MwREwuj5sw
	 qWIG265hwlFPaNkLVXHvWyN44Og+5bqjL/bo/WynFvJa3ciFzLa+HVOymtojG9sWDT
	 hMCumww3KCzwdSqeYbgVZxIZiCcJmmEbZ1ttQJ7G/lDRCYKWDjZtKZp5KhO5uzt5Qj
	 tkgGlIs9W9IRA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 0/7] mm/damon: update probe hits for runtime parameter commits
Date: Tue,  7 Jul 2026 06:50:29 -0700
Message-ID: <20260707135038.90068-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C99871C0007
X-Stat-Signature: p8pmazppbk6x4wxgoftykwiyjifq1bjz
X-HE-Tag: 1783432242-559500
X-HE-Meta: U2FsdGVkX1+RxD3jcY/0LxQDqdihZqVJkHezsw+pQlxtIpy9r9djxfedRZH4ZqX2kMyMIRhMufO2a0tvklLW6yrt6DtehAZ5fbtiW26WLN7Fgj3qGQW7OA9tIgfHsRJdq+siHlWd+eUVpDImxWrksjCSnkwj+UQGmu7TSu5KNNYMi/RBOeetgcr4TLXf/RPPpChs522s2w/VIpKtAR20pBMu8tiIbyMjBSrxopLfRRseRGX8BR789JPEt3P78GI+GA+zZOL+d9ryv/I2547rcSdyeCBfaIutYhDUWtcBO6ziB6Ika6vX0TpMmEaaNuYENbtuvGgMpT48z0nsY/sgnDDcWVCqmtLhwdmjoZyUBtzIHZCBBXco95Qp05rLKPqE7D46pN6zl6F6rUkctC4KYIB2F9jFJEwbPR3lNhtxqW9zXCn3+MpKBOvNoJi1sM5W5sgcrokuviJym4noVT2v103w0q3Qqt6WxdQqVEGZvbqSsYCt+WhL1gI7r2Q6wzOsyCHTxU977pVatXGqgLt25jNBf0EU94a+7Li41VTOSs9cZQ13jLjyEA6Y/hFahx+F2nE7VSEU5KC2k9PLpvbQ6EdePR1ZxsyBWmTPPvOTYBWW9ErmxIPGa+1nYpeOnje4rc+jwoO5NfZXtn5aJCB0pTvchSKiv2daukIO3dvo+4k+SERUcSPAMAHVkhh96JgmEuyvzYGS0Da9EoBkX0C2wIvItyOfDYnJcL2GTIQeBERQdaWrk+TsUe032cBNCT6mw4E9hCeSG18vvEEFWnGkAn8JKPTIXh1oMK6TDzzrczYWNylAvjcG9tL8YgjMHmf76hx1xtBpWhBax2TatYLclEReJjWuvpOPzxpORKFmjL3R+xq5e0rN4GJhphHzp+sjifjilXYQTbXCx//5Lho1rJ7LptwSf9tErW/8VOTWkHuEobnCVddMg5PeN5q3vBaNJdzi4VfMqOHxCETpFNj
 c6J42R/w
 tD9nLlPr/JIDRkEQE32g0ZCkZSyDmN9iP/ZOoCYP28I80AF5KTBp4WsqiCMoIVwmn2IvcWDuxIH3evp+rs2Nl91kHUz8L29Xo8DUWTXtlYox0LLlJH5kP3DHkihJOC96xKNBRmU08+ibZYrRr7K09gwN93x9Vm3c2YDIlZvc8dmMQWEgBMSLsTEX2JU7HY5J/Mnq2TOyhhXJsj11NQouvevFwt7CyCxUBuJJpOmZ49SA4FGk=
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

Patch 1 removes obsolete comments and test code on a function that this
series will touch.  Patches 2-5 rename functions that are being used for
nr_accesses update, to be able to be used for probe_hits without
confusion.  Patch 6 does the probe_hits update.  Patch 7 update
damon_probe_hits_mvsum() to cover a corner case from the update for
better accuracy.

Changelog
=========

Changes from RFC
- RFC: https://lore.kernel.org/20260707043828.97900-1-sj@kernel.org
- Remove obsolete comment and code on the test.

SJ Park (7):
  mm/damon/core: remove obsolete comment for nr_to_bp() divide-by-zero
  mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
  mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
  mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
  mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
  mm/damon/core: update probe hits for new parameter commit
  mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()

 include/linux/damon.h       | 10 +++---
 mm/damon/core.c             | 64 ++++++++++++++++++++++++-------------
 mm/damon/lru_sort.c         |  2 +-
 mm/damon/ops-common.c       |  2 +-
 mm/damon/tests/core-kunit.h | 31 ++++++++----------
 5 files changed, 62 insertions(+), 47 deletions(-)


base-commit: 86f45ad9d6667f344421729eec5a9367e37bfc5b
-- 
2.47.3

