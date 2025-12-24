Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7045E7545C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 15:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB506B009B; Wed, 24 Dec 2025 10:31:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BCE86B009D; Wed, 24 Dec 2025 10:31:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF3E6B009E; Wed, 24 Dec 2025 10:31:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0276B009B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:31:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5B16138618
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:31:31 +0000 (UTC)
X-FDA: 84254753982.07.B1DCB4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 415EF1C0015
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:31:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ikH47xnw;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766590290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4gLD4gGTas+MhDBEiGOIZ1aY7i0vNAOCP87/Kabw68=;
	b=nJhE+Nxmw94Fx6DL9r7t1A6fHNJhJaPIeXJcL+EhDyoO5/Wxu+0pJEUZBxmxTMkVbPMx8r
	zUsRbD1qhSgTQknLrWdkvMRynoxLRy0bEAU5gxAbbLkcfzQa3V5Ry1yYBsGKGW6Oaa/Zje
	ktjIL91XJ5WkNozRJkyi1/Ph2QBmbXA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ikH47xnw;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766590290; a=rsa-sha256;
	cv=none;
	b=PXZaTFX9HIyAmVs6qiVjXt56G3Pp8pIdvLNd1hoqvCnn/tgDt8lEA0aa0aUYrw1HwKsW7y
	CKqj5HDSvQoMfJeDC3ts/OsWH5la4WtV7Sz22EIoULqs7E8851Qg62MxC6UAboVXIOKaWz
	NflU2HT2K941MPKGiV4Xl/t7BScwdII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 067064367B;
	Wed, 24 Dec 2025 15:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39F1C4CEF7;
	Wed, 24 Dec 2025 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766590288;
	bh=pYAUqa6oFZYO/VGx8zrWIvrkonzQsyd2twadgZmVNJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikH47xnwgcwk6YycFzvdnpoP/MCZ3++SorzRiscRX78pyuh8PaCvkA6a76/zuyARJ
	 MzQWd7Ozqdz5hEDC0Q7E04ZN8IML582sse5UatqofBWHqabCAFdqSG8Hru48qF27Xx
	 c0Yv1Xj704bqoYijArC5yH02+3QTj2GsbdB8BQwgIkK0POQYQB0KpsNM4fOvj3W5CU
	 wIaO9Mp3lqwm/FSrcNoHzmsUwa6s81AzklS7UAqaPgZyAeqBETu62pz/EljNd09l6V
	 JKFAcZx0ZWvapytQ3UjGNSTAp+CBoVk6yIzxO6QKyZMhPKTFHVypA+Uao4YNwTB5Q/
	 mTOb3CtYf2WKw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shu Anzai <shu17az@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] mm/damon/tests/core-kunit: add test cases for multiple regions in damon_test_split_regions_of()
Date: Wed, 24 Dec 2025 07:31:23 -0800
Message-ID: <20251224153125.69194-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224053407.81911-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 415EF1C0015
X-Stat-Signature: szep1idwn8q4q4w4b3a47x86konumzgm
X-HE-Tag: 1766590290-44205
X-HE-Meta: U2FsdGVkX18RJH7+kWQy9UQ1Hb+w6IfuoJJgMpF0pP+Q5Szp0PXoMIgEQbu2wx9LgQLKCgMbwK1zRHLOlO2BO/ar/UqOxytkPvGeoeeXkiynmYSyAuPG3aiM2Q3OgnFKbrBcm19a8Kf47enUh8xiB/paOOiTrNvq0Bt9AUeZvUVzaisYYrw1xY69KbVl5xGk8iiyVCC80YLfPds0GVlOe6waD/YNsIFtBwOqAZI+sePMD4zTGbZ3UiFvluhgb22R4kJjrUmkuxaIejXiHOOaCagy6yhNluosFVl1PoMqJTSbeuWuQDBeq5vvwDTTq6+zGjoUjciw2U6Gzc74+N586KHH/dVV22sNRfQBwP1dyE3bx6CTwJ3DOfd2HSEUTgB86GqrN2KiqeCirLxNK/t8fEYJ6HfMKQmEeNO+G3L8JIT3qScuMv1HQov91weT9ZmzGu+/3xHnfTmim5XQTYLp93np62YGm/ZrT5UJ0dT9ESf0J5NxIqihaE9OVuQEr64qCc+e2w9gQTP4RVJ6EtDkhdcZAPlf+hGGZZa6cAa2MzkjJJgCmi1g9mfzGsCC2JvYrqE4a96Ku7d/JozF8r9Z3HwSnyqKDxuZZ/LRQUGCZazuVfUiOPHkrG76cyqxvBNoxXrL0f3wm7vjSBtKjpx5uKecNu2yqSwRX4oXfdAwY/W8yifR2muuCj2o9FSCU194Ckt02AGQVXXb1CKvkHKLPg9j8RBMrkCWygZUvGi5P+AVp9inzbIhnwzyg01SFCDU9Wq4gSqt0WlOPYGZ3ifsGDuUXPR31cWlebe1xxiLgu7G2OEcCUGQXIR99HEC+xgHcpTDFTnbTxJxIP0iE0mL0985PzfA4LV0GLD1vUi08F1NGhlRrd89Dv25aBIwS+smpa8HRpP65vtXX1nLsYfE6DzNpR+KRXTBnNBtAhyvqW4rV/IMhHgd/X8ujN+rutVOSrtnzMmtADKUSOy5kfi
 Y1X4OJJ/
 /EIkp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 21:34:06 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 24 Dec 2025 04:21:59 +0000 Shu Anzai <shu17az@gmail.com> wrote:
> 
> > Extend damon_test_split_regions_of() to verify that it correctly handles 
> > multiple regions with various 'min_sz_region'.
> > 
> > Signed-off-by: Shu Anzai <shu17az@gmail.com>
> > ---
> >  mm/damon/tests/core-kunit.h | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> > index 2eb6f41635a8..36622a2c11f1 100644
> > --- a/mm/damon/tests/core-kunit.h
> > +++ b/mm/damon/tests/core-kunit.h
> > @@ -275,6 +275,9 @@ static void damon_test_split_regions_of(struct kunit *test)
> >  {
> >  	struct damon_target *t;
> >  	struct damon_region *r;
> > +	unsigned long sa[] = {0, 300, 500};
> > +	unsigned long ea[] = {220, 400, 700};
> > +	int i;
> >  
> >  	t = damon_new_target();
> >  	if (!t)
> > @@ -301,6 +304,24 @@ static void damon_test_split_regions_of(struct kunit *test)
> >  	damon_split_regions_of(t, 4, 1);
> >  	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
> >  	damon_free_target(t);
> > +
> > +	t = damon_new_target();
> > +	if (!t)
> > +		kunit_skip(test, "third target alloc fail");
> > +	for (i = 0; i < ARRAY_SIZE(sa); i++) {
> > +		r = damon_new_region(sa[i], ea[i]);
> > +		if (!r) {
> > +			damon_free_target(t);
> > +			kunit_skip(test, "region alloc fail");
> > +		}
> > +		damon_add_region(r, t);
> > +	}
> > +	damon_split_regions_of(t, 4, 5);
> > +	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
> > +	damon_for_each_region(r, t) {
> > +		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
> > +	}
> 
> Nit.  The above braces for single statement is unnecessary.

Andrew, could you please pick this series with below attaching fixup for this
one?

> 
> > +	damon_free_target(t);
> >  }
> >  
> >  static void damon_test_ops_registration(struct kunit *test)
> > -- 
> > 2.43.0
> 
> Other than the above trivial nit for the unnecessary braces,
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> 
> Thanks,
> SJ


Thanks,
SJ

==== >8 ====
From dde3e0e84056f85cd5cbface38c1f617bfbd0bd4 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 24 Dec 2025 07:27:04 -0800
Subject: [PATCH] mm/damon/tests/core-kunit: remove braces for a single
 statement

damon_test_split_regions_of() has braces for a single statement, which
is unnecessary.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 36622a2c11f1..252ce3e001c8 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -318,9 +318,8 @@ static void damon_test_split_regions_of(struct kunit *test)
 	}
 	damon_split_regions_of(t, 4, 5);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
-	damon_for_each_region(r, t) {
+	damon_for_each_region(r, t)
 		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
-	}
 	damon_free_target(t);
 }
 
-- 
2.47.3


