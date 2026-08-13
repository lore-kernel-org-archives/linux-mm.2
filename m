Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3422EC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94E096B01A0; Wed, 12 Aug 2026 23:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812CE6B01A1; Wed, 12 Aug 2026 23:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F4D6B01A2; Wed, 12 Aug 2026 23:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CAE46B01A0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:50:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CBE25A2B92
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:11 +0000 (UTC)
X-FDA: 85094868222.28.8612ABF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4EF0B140004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IuqgpbQf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a47tDKl1k73QAF90ft2RevU02WxBCqQ2EJTbPYNlFRk=;
	b=rT7TJxhrmgmrvtWqoCQe+DsuEYUm94NpZwffRtTFpKGDmwt/6tZNO1fXNRSq6jw8eJCZv7
	W2qsZq2SKq87QHvyhUEoevcTpnwFE5dd3egBKEC6s/NCWx59WO0evyjlOkCopd5thhjL8p
	nt3vtS4S9MtkFNLJl3X54aagmJsvkBw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IuqgpbQf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593010;
	b=1Kk3mbLBxuQSeVIycb713yJzlCgwPvIwIRhv8OjQ93G7lt11bwtq/EidGqr8ymIyjhbw6g
	O7FD0NPBDp6ml9XE5gz/P6xzYMKAkd0vd1Qfb0GF98t1SgjD2e07H4YSmdOGz+ouvGbxZ4
	P4TAp/1rQyYosl9iDt+2gzO+BecCrgA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B544A404C2;
	Thu, 13 Aug 2026 03:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730751F000E9;
	Thu, 13 Aug 2026 03:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786593008;
	bh=a47tDKl1k73QAF90ft2RevU02WxBCqQ2EJTbPYNlFRk=;
	h=From:To:Cc:Subject:Date;
	b=IuqgpbQfP+QGjzGZM9WLMbxkwiv9v/WtdS5IyXQnUnqL5JM8z87cgFAzMvLQy4/UQ
	 68IEoed1pmNQxuycnsLr+EiXhkSg+AvDO4ueBQv4kfBCexcU/dGw8ErrGP/ENtIhfn
	 GJwFJakkTOtwEyGgLqw2QU4/dfavcN6ghpBFaJ2P/2t2TAnXexMfU7SDJal2QS2VWV
	 fKuVU1wD2cpukfIdB7+bFlYQavhvlvOB880cr/iG6mpq6sYLioCaO9Djkl2uPZRaYB
	 7F4bQtBTY6FeqmGR0wH2DI3JrdRmPdE3yu0podBkCjn4iJYNnJuYkc6GDpx1J97nth
	 V36XdH8sx04Uw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/4] mm/damon: allow NULL or unstarted damon_ctx parameter for damon_call()
Date: Wed, 12 Aug 2026 20:49:55 -0700
Message-ID: <20260813035001.97364-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6jqakazjhemum8ab4u95ipnxnmr9ztkq
X-Rspamd-Queue-Id: 4EF0B140004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786593010-844910
X-HE-Meta: U2FsdGVkX18t84XQb2yTmxcSxQbHATW5ByOIgDHZ7wRPDnT+PJdhk1QTF9kPW9oKIydrbsFwQl8B4uzn5QdXJNmWhJG+QQcCL3UjpRNnqdJvTxsuxkYlWKMT8R7eq8OptrubJpNW/sxzaAuie637m57j6kyeFeSRnw/9DDfLr6U4zjivtDrlMYrpLYr4KXhQm/7gkqCuzn1jeQDk4G+Ju6DymTlAoEc7Lt8i9Oz9nCkBP3V3QQwqUJCqut6mV1PrZyqxoN6XlVN46Qj1cAn38Pn7knmUeNq/mhNiHyLVbYnHe0dYZCOCxC/8Sm8IF+ItUgEt4bqROPkvoF0aUvaJ3qbnm4hFQS7zUYY9mndZ8xScEQY+4F4vg60Ay+hZdkHnefYJTZLhLR81sOULHUU5gq8kKkkpz2ZT8sTXImDQCmTT0nqqDTOwHcse0Key0+7x3Vb+NjtWESnvVcKXqbSq96TjIF2YVIdVsdcamOEQm6KJ0ScOIiifv0cWwGK7qODJ6tXwHSUT3mJIkUqKGvykiAxIhgFPMvRz2wVa6bmDJoiWTQFP1NH38bf6eLL/NUjxM9VoFgWumiUcIz3N4ZpxeGHLJvujJaUug5wFLCH/lHjT/Uj8k5CO5hKGqmpyK2Ahpl0OntlFftuYRyECj8LkWD8hyZOW6jAC5fMmQK8DRHPoDz9dz7JSOlKAp4NpzPQgwVpmkwx+jYC9QpxQJIgKwKoQkhVhd9h2t8Y7lGoIwMo2uIeE7vN/pSd4PP75Se5p9nzwkUyAdTNw5AsL5LifSbd7gcnKDRg1YO7qaYvvitOyrCEhK6kZLUbvg2ym/R3TMgBe0mSBU6iAFfLmoE7bXTMeBMPwY/cz1GjtAU3QFiMniwZwNy0VUw15iiuoKRflxiTzGNL6mUQRrIXH+T45R+JFpvU4ok65LGOx4eAC1bsr5fzB/HVPqX4tCla+b/JCtuTSWy7LX3yvhOtlT6m
 ucWonVK3
 4LNJnd5cP2Zef37bkUEnPVfRHQICQiQoe+qzxArao1yOp1hVBkwXy/6uKSuWNMB3n2n1s0uOeksao72N8vN3Q08CDQPMV4bAT5cBoDhBbr1+dMGn+Ts5M+g4XEjcVXB8gS40VHo56V2gjx2HLseRlx3I4snxhtj/nV2hyIyBMxif70S0/rC7zfgFDrb4UBpo+5ZPDTm9ABx0nTmLGfxVr9ursSZ4C4XXJOf1d80onJ5gGilE65p4+Pgoq7rIg6/+KQ7gH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers of damon_call() should validate the damon_ctx object parameter.
If it is NULL or never damon_start()-ed object, damon_call() could
dereference the NULL pointer or indefinitely hang.  Ensuring all callers
doing the validation correctly has turned out to be difficult.  Handle
the corner cases inside the core layer and remove callers' validations.

Patches 1 and 2 respectively allow passing NULL and not yet
damon_start()-ed ctx parameter to damon_call().  Patches 3 and 4 remove
the callers side validations in DMON_RECLAIM and DASMON_LRU_SORT,
respectively.

SJ Park (4):
  mm/damon/core: handle NULL ctx parameter in damon_call()
  mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()
  mm/damon/reclaim: remove unnecessary damon_call() param validation
  mm/damon/lru_sort: remove unnecessary damon_call() param validation

 mm/damon/core.c     | 7 +++----
 mm/damon/lru_sort.c | 8 --------
 mm/damon/reclaim.c  | 8 --------
 3 files changed, 3 insertions(+), 20 deletions(-)


base-commit: c8520e181a2aaf85290d0447656de0df112dbbea
-- 
2.47.3

