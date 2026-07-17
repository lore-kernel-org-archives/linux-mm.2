Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6790BC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E516B00C7; Fri, 17 Jul 2026 13:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776C26B00CA; Fri, 17 Jul 2026 13:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B29C6B00CD; Fri, 17 Jul 2026 13:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 348566B00C7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:02:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41F9240189
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:55 +0000 (UTC)
X-FDA: 84998515350.21.CBBE5EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AAAC180004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTRec0dP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A/mmTeERdzSAVoQzcIz3XDmSQeXAl6NdcuOV37Pow6A=;
	b=RZsvsAa8yHmOqBjIKCmYXC4+idHtAQ71nyx58J5Yw2/3Rb3TiJScyEwV0tavA1BSQfQmEJ
	mywUnMvHh8md63fvr33ZEZn5qeCFKzk8yxgkmT99ecPs6axEgOAF5jKjvVXFMsuCPHzZ3Q
	KVnBJJcUH3w8ktALsXbewMwyWQulRFo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTRec0dP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298893;
	b=vcazsqCNShG0QYy/GG8atcSbQky0pMvAo7s51lZ8LTVMUC+ap5/8JNiyd7cN4HcDswEMuO
	9km6AcPa9KBCR5V0t3+HD6DKpDsvicK0Nfwdp0iHvfNYzdks1AmHahtnBlYZB0MrbeSRbZ
	JDkABhXh/T4bf3iAE7yvx4aBmh6E72E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB2F140472;
	Fri, 17 Jul 2026 14:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B26E1F000E9;
	Fri, 17 Jul 2026 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784298892;
	bh=A/mmTeERdzSAVoQzcIz3XDmSQeXAl6NdcuOV37Pow6A=;
	h=From:To:Cc:Subject:Date;
	b=VTRec0dPg80nAAyIMFhmHkd5UkN6eOfRhFAMEakqLgiQ2cXKlsP82+lq1yYOUblJN
	 4Mhpo/I8BzTBnby2y7JTcHjSyA1biNes2vjvAT+7M0AbkiWGQ96YczjNB3JQ5Y55ke
	 /rsW9SheDsdKcCVb3tQUzs1IA2BiBGg4Jj6x+KTL/SvHNlmmlOt5iVe5bZ3lgJyJLZ
	 VYngAbFVxR2B6n2TzgwTmZoF4bi5nUnHkyFxI6UZxZSYhzprteTlAEhshnLNC+3sjh
	 m8bIGyOw6bGq6s/egfMSAbkzoa/7dwj24XMatAKdmhK5io0HwuupNUG0blI49vBN4h
	 2X45gKJ2I/I8g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 0/7] mm/damon: fix uninitialized DAMOS field and kunit exec expectation bugs
Date: Fri, 17 Jul 2026 07:34:37 -0700
Message-ID: <20260717143445.91207-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 93j1k56ffd4sk5uy5pga7jfjmdpufy6p
X-Rspamd-Queue-Id: AAAC180004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784298893-896620
X-HE-Meta: U2FsdGVkX18V2f6H9KmwoyoxZMyj4TmiYXmU6rZVgppUJMX/tCemW4+LC0gEXzTdcFubPtzKIJpWJl7yNvXpTrV2V2lwIaEfJQHa3cO20+321/fwMrbveSCXu0AiAGqfiQ6F3sAr34kg046nL2GkOXq0fUhAbfmRjMzKQoyYutMBAYA7TkR6z+FKRk5aILaqFj9Xebwaj4dNifrLZB3pGfLc0r1b/kXrygGFMjP4LYB1d9s8fW+N0DVwGBRlpq1iUgVgJqAdsaQvGjPi1PLTiX4zMAdiatZIHWOkMfTK+EzoO3xB8s99Gg288k9/chMGX0Bua497kYi6PSqFDFD9nNkduFVkaHPGWQCC8L3XvN0nbn7z/h8M2WeTrER+5VCcSHtV8klqZGNVNOl4bPny2Ph1IeOhxOncbM8j+Xd2ze+6Rj2q/ULjdRCW42Ue7nwt6zN+L5QWienzPIpVwUBPVUWNthN0hPNQvCa2OpwwNGY4v0pA6k0x31YTOC3kqtQmCJeqlvxBhtHmUHk4F+dJ5zEXp41iqlWfYrjWhuT/8zm/nn9bxkz8FOU1x/ZVp6ZZI41OMJilxmDPGrbndIylsz+NpBCPftDI5BJ6uzNjbnq7X/HbncxJWM0O3H2NkFywtkftZE8ALtlCHgdpQK95M2qom6lhWIKuq/YvcSf9r5ni1sYZTYJdXfs7DB5u6w37Uqa6WHjYIXozh30u9sRSDjoZ2RINSYDXtY0xuWSfLyibXYAw2+wELjH/DLc0UL92V890M5Uq2bzvDaHr54IKj9vXuu92gPZwFn1Q6QTRe3J3D+V29MftljEJSjQhL4FMbhlAde+iH24EzJTWdRfQxc+P6whRq+/3CMe6JoOZrhOlIgxI8NkVLsmA4+lgUodL2Bo+5xYtTShUzLkMrgx1BolW9YOGMP+RePlge+QjZG1KYqvJmEkF6YWFZpbj9Ovb4S8cGdCt0u4SPuplRvT
 C7Q/EkuY
 gBFxRE00kb2CGsx0RGwKXa0vyYso6ewoAtEVZQeGlsZaHfzqd/qdggC6y/MVsQC9UhV592e4oar2vh7whfWJWFPM/7O7igUxDDooQRDnv8NWf4UU3x5L0Io3K1R9MTe3mNo7cKebBAmwR4gYLA7ZGdxw8lSbBGsD7qNH/F6/kl9tVnTI5gbHztSkrMW8M5dXgzA6ee1qADrOBz6QT5/2pwXuaMW3m0yZFCV9Z1UM+isfuu6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a few Sashiko-found unurgent bugs.  Patch 1 fixes use of
uninitialized damos->last_applied field.  Patches 2-7 fix DAMON kunit
tests that do invalid memory access under test failures.

The bugs are better to be fixed and eventually merged into stable@
kernel.  That said, the fixes are arguably not urgent.  Patch 1 only
introduces negligible DAMOS efficiency degradation in occasional
cases.  Kunit fixes could introduce quite bad consequences but those
are test code that affect only test run setups.

Changes from RFC
- RFC: https://lore.kernel.org/20260717003022.119437-1-sj@kernel.org
- Add missed region split failure check in filter_out() test.
- Rebase to latest mm-new.

SJ Park (7):
  mm/damon/core: initialize damos->last_applied
  mm/damon/core-kunit: check region count before testing in split_at()
  mm/damon/vaddr-kunit: check region count in three_regions test
  mm/damon/core-kunit: handle region split failure in filter_out()
  mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
  mm/damon/core-kunit: skip wrong quota goal walk in
    commit_quota_goals()
  mm/damon/core-kunit: skip wrong region walk in commit_target_regions()

 mm/damon/core.c              |  1 +
 mm/damon/tests/core-kunit.h  | 30 ++++++++++++++++++++++++++++--
 mm/damon/tests/vaddr-kunit.h |  5 +++++
 3 files changed, 34 insertions(+), 2 deletions(-)


base-commit: 0ad94b65c75dc6c6c3fa742f0a6213ed578c771a
-- 
2.47.3

