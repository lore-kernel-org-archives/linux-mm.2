Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60CA6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556666B0092; Tue, 14 Jul 2026 09:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E9C6B009D; Tue, 14 Jul 2026 09:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444246B009E; Tue, 14 Jul 2026 09:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC196B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:52:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F8EDA0424
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:42 +0000 (UTC)
X-FDA: 84987522564.25.20C459B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1C6D41C0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AP6xYBIt;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jjskXBnVaUyXXYcnlZnqyVF8f035p6ceF7P+7PjCvJw=;
	b=YlJRirIm/VdRDK43SWEwiPlNbnZTGaH94u1Fy07spNHHdt7dh+WDzm6Z8BzMFI4e7PLZue
	1M+o1KR+YWoyvGJ3YdVTMzzoXyKCJ4eC76Lbrlm8HnTN8DD4wU5aZZhyNJpfevrW+1k/IY
	2KsRJXqNn2ATnT39tnLpRjAEuwON2WM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AP6xYBIt;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037161;
	b=wKBxjnIMzPm+CsuBcoYAWJugI+glz4lbnekXHj1vHEBxZ+mRYlXLaczCgQRepF1DeEjBRa
	fH+H3xQs1oE/2LUu5yFtsX0GCtXYdwfCEZ/YxYr3nue2U/kQTvuOY+nrWOxcBD2MxqHVfa
	tMBPIhI2rfFiDjdRp6Nq1Bf5mDlWjMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA7BD601ED;
	Tue, 14 Jul 2026 13:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78341F000E9;
	Tue, 14 Jul 2026 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037160;
	bh=jjskXBnVaUyXXYcnlZnqyVF8f035p6ceF7P+7PjCvJw=;
	h=From:To:Cc:Subject:Date;
	b=AP6xYBIt+ngQ5f2uJQXzbHbTwF1QdRUmts7VqVey0zvhy7l7Bqzfs7Mv5f1Ar8prc
	 lY8fe7ehEjlSQvWVnDTcHw9d2pRNM0DcnrErXSIfB1yrCi0WCYn7AtHVemQOrFxqZi
	 +DCiRfp9a2V4fgRxJawmpNheBzQfO/jy85c7mLYTkKof2ytKqp5ikvHXrhdQFTyC2S
	 crwadMUvqebK5GrLXDWrc8pUFU7Ldo4r+D6qMjWNkdqqFEy7FhBWzqwykV0AqEt5tY
	 8avdoWxJtKOKY2vb12l3doaZiYWiNNImeZTlnGoNwfhM2GBEsKHkju6FNytz0yePCE
	 u12yXtdVwwziQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
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
Subject: [PATCH 0/5] mm/damon: unurgent fixes for infinite loop, NULL de-ref and races
Date: Tue, 14 Jul 2026 06:52:28 -0700
Message-ID: <20260714135236.92699-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C6D41C0005
X-Stat-Signature: oujmn89aktf5yzf49z48tdi9jp4zkhtu
X-HE-Tag: 1784037160-596281
X-HE-Meta: U2FsdGVkX190gV4L3cf8XSxNMy9nrjyDP3FHiiECqiFojW152PhNZE5hYvTPMVTgs6G5SCIsfbAYVWe4caxiRIceAkt1B69DGHzj+5zLb1xjZyw/2eGS2DRYNMK7XwKS+1kpe7nIXGNhYD1gllc3CIm/uRPaLhLC8ddxxNTrcOauNRwg6Xm5IZakSj+LsHh/B7VR+aEAU7SNO3TWuLrJ+lIy+yrK0Yay5mgvhpII1CNf0yQN19NTX4sEzPWVAxXygYlx4qot2xd2XZSWh6lRRmjc4dmV2UwyriLL4dJ/ODK2MUZ8cBIr8rSdz5d5iXYVBCu8ZeUk14un3fcQ75g0z7b24nrrpn9rWvAvC6wtFyG/nM9UxTkipRHhBCaRJogZDv2cpqaRnoO7lKO7l3utyTBmu8J3xkfFha4mcVd58/P9rSTbsZfEMvakDjPez0TuLknj3xZin36WAE7SMwMLwyVxz7P9zVm8ZzFD/AIbdYPldNsDKS7tppygYdhUUwCdFH+xj2pKqd2OWBNGSB9iriRggaqvPg4d/WJaOBy9Sk/5qGnRh3jeMV+ZCDcl5v5dpz0Yjk3WYgYd/BvIPHKSAqqYJsvk2slhMVvi6IcGUHNaT92IctHeTSaDiAWCXjsYi3QkAnN3hiWtKFxAeGxh906TJIdFll3FYvCmRjXCBXbR0TYOZYYSt8vuQvLiEuD+JqU8d6/s3eo+qHkMyGAwygB3TJA16Qv/O6thgsNQ7kZwlG2Lf+biITk1pGNNx6Qg7NUb9NsbVt7EKS9Oqhv0THx2JZt9chhsqvNro+2MbVi1BJ4kWytroPKx6Hm8LTXsVBp0u52rWB00YSoXmWCNC2taJt1n7AncOLEX+CBMKIgTOV8UYk5OoJmwkv3B0PwX88lhoPsRTwzu7daWLsjaAw5gj0fxYxtSnW/wJtFWgQRzTdd1sKXGgBVe2l1ZB5frSxcqY2GHC0E/Eq0HWBU
 JUI1V9M6
 VVCCZtQQ3lLQGSX3eSaT9nF7naFSVpeq9OHc9fVHxHv0oMDtKi2cw5o6X6C5RVSFPHUzZrCILHOLTNz7mwKWIQjjioMUtAZj5ribBp4PfTBF6UcHeDyV1mChOTbA649w1eemTzg+SJZ4FcevLzWNTWs3dDTPs1rzvNlBJ5mkwfh2yrQPKWgXDwQtfIZsPjiDX4qFvWJFcGITUmJeH9MhSYmkJ4VLTxfJLD8OMMeDRxaHcfL0=
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

Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260713135838.32730-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
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


base-commit: 93cecef8d85fe01bc004e07591501e85c132b343
-- 
2.47.3

