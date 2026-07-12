Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC8E4C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 17:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA36E6B008A; Sun, 12 Jul 2026 13:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B6E6B008C; Sun, 12 Jul 2026 13:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF916B0093; Sun, 12 Jul 2026 13:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC1946B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:03:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38D29C417F
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:41 +0000 (UTC)
X-FDA: 84980746242.26.8C53D03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B9886140005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPADvE44;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783875819;
	b=MfvFQjswUD5Bso8yYrfd432ZR5zILFhoCV/H7yyo/DcLyP4c7BglSVqm1HEjJ+Cgbtpb84
	tq8bx/NOKuu8+MODhXsn7Bf5QQ1l+gGYhnismU9iw/rlTp1m0icoPAESOiQbpJplwG1CS7
	8EzA5SchuU4zEf2On05rwZmaHe0cnns=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPADvE44;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783875819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b6Hje91CDtF95cA1GOS8FiqBgZ9D0LGrk6SOQDgcIRA=;
	b=UX3Pyn8KYw2edZGg3AsFEh8MrgrGiBbst14mXiZX7Xrl2V6JhXpdaAsOvJ5NP2LOHAd6u3
	sWxAp12z1B/gznwBfaTgqwshJ0aheXyIE0OlzEF0QsEoMTiG+95JFAL6I0tw73ji16qAaQ
	XNKA4qSflc3DFsatnnhp6G0JsdTZH1s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 288BC6004E;
	Sun, 12 Jul 2026 17:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505A81F000E9;
	Sun, 12 Jul 2026 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783875818;
	bh=b6Hje91CDtF95cA1GOS8FiqBgZ9D0LGrk6SOQDgcIRA=;
	h=From:To:Cc:Subject:Date;
	b=DPADvE44OdGjcfTQ/fQBi4gUAEwzjHBOqoGlpFqaw13QV/7IKHEMRAwEgDomyjuDN
	 Yj7OoSXF+QkhqjwJ23cWxn+yMSVUCgvdhO24kOgWUCVRaQLeEA6pE3XAbjYfQmQ5+l
	 RSRvqAwR0TSRQhXIn1AlmiG54MAOnjGhNmXBQgFNLgrfbEqeF8FHLFLiEL7rZorx8n
	 otDZkK2LjgPDstNoG0jQGvB5S0XW33BH57GkZicrXvT3HyR+UkTX8cbRDCKU/scJ3q
	 IQKT7RcEdLS6yMLqpdavfBZ/0U0RubpyKG3Ra88sk3kdVMqT7+K8MVYG5U/cprbNjV
	 AucIoElM6yn1g==
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
Subject: [RFC PATCH v1.1 0/5] mm/damon: unurgent fixes for infinite loop, NULL de-ref and races
Date: Sun, 12 Jul 2026 10:03:22 -0700
Message-ID: <20260712170328.91144-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9886140005
X-Stat-Signature: daueaqou8oxie6jbhn7pumnkubsutkrn
X-HE-Tag: 1783875819-244512
X-HE-Meta: U2FsdGVkX19eueisJmpjR4JvQ7+s9hhEdo1Vhwd5gjJNp72OOn5i7KmOc9hKKw+4nmh0RHQWHZxQLXQkN0O4VTT7mPGlmU6fR65AxpPmNOiKjc8t0088mu4cvk6G70FEw5ZQmDFhiDFsZuHtyUuGRTsnTodpDyS/xS1OfmvOJyNnm3OvDaS98UBTh60JDmgmdKoInXig3xunk4TyL8nxzHcRIupP2v17Md7ZtB+Lnj6q5m8XY18V/2wCa/Uqec8c5wSb3/SNmCADVvnt8NbrxL7q9fPpnahUy3bqbAbiI4da4WpCss03LIZzN7B9M/O3Nkh3komNDDMDv6gmVuZpwDRaZlsUjZZ9B1NzgQ8pGsKsAyev457ymNIYwqIjIG3KazuHDcvGZTcFwCev1TKRXZP5uX4D7ktJj4sgX8pR8nyljEFKT93++v8GLL6++SJDemSfu2PVzeFXJ6qd+0KZQkq3kIXPn+HbAZm4lbBnZj4f4yJxJ73pn4dUpd9mSogzrMiSAYI5b/K8hJ8d1CKTTdNCYZ8lJZtLdrt2ksLbSEeBFp7s4O0lytj7LmSLHbJ24ZcnjT5m0aNLC6R1bZReM/mTqfSeqtbf4UguZjnr0x+5dcM1F3enfAaoZ7gg03ls13OHPZzAtW3mBzCRj+irLT76KmV90eotP1heub/SP5tLy5EMuES5b4S8bv/hY+oBJ4yXy0WbHdFLSc6FOsy7VO3jMJv1Q7YyWHr/2qqYk9BCk2vBDURPvPkNUPvcrdkx9mIjyZq0fh6v+lEAdKpp3JpeaqRAwbHooLwgIwhysgS0s6Re4KGLxtZQZrfL1hQUr6DdKyYlkpmXBIIej4JoKXpvX99xTYElJADe003Vx+xFRjlHmxBlSMlT4/Xg/XhBKxVX6TmIGKRJ8z4rhpamd6ZvW7F+w1w7qmL5oCl2RwynrH5S4kJtFvZ6oHBG/cWrSsjsnJsDfRb0Vlq2Cri
 48lq/qf5
 JOSx83jAfx1pDeUrsR0JEnkkQCb0bCL/UqUla4/A32yUgANdPSmPHJ04tzTTF0aVv81yilM+0Z/n3e6s5hC3XyGHYQ4a/rZJzQS1+f8nky8/8d5eK9s8zOX5KhMdavD7/Tyh7gXdQ1mHkRRsd4e6TL06hZ/qeKta8UEHazf84ebVD+WOG25hw4/3y1/E/3xXPgdXpH6UyUrfGiCa31xwYIiieVo9XTxKFSPA4GRuZc+V/OHU=
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
 mm/damon/vaddr.c            | 26 ++++----------------------
 5 files changed, 24 insertions(+), 44 deletions(-)


base-commit: df701015aac3c13b1ecff311fda1a2ada2b9c1b2
-- 
2.47.3

