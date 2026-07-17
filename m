Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A9DC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE516B00BF; Fri, 17 Jul 2026 13:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B941D6B00C0; Fri, 17 Jul 2026 13:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAAAA6B00C1; Fri, 17 Jul 2026 13:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 829386B00BF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:02:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE46E1C0077
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:56 +0000 (UTC)
X-FDA: 84998515392.24.03B0AF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4F580180013
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jAmFrdPY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYUt77gOaLnD9RIh57O9y6iLCV8DgyWvyhX78FkqqnI=;
	b=i+BTMS2MHJEpZNbB2VbjGQXg4hErnLykrIz1hEM+3awSmmB57gHNSCOYTXvwfc0aBqD01K
	pa3wfahQuDBUGfvHzxVbwgZIWiRcYXtQPyrGJxI0vTdtSIwYkCLGL8I25c3w2AtUqlaYDY
	ZqmDRwoNjJ4NE6taIAewvW8vO7X0OQE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jAmFrdPY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298895;
	b=lkXy8TFgfHgY4ccmIBVbC/vZsfCpGRNoJyWuGO4qgJjEJWxBCyLOr8UUC94afwxdPoq2iH
	5BpeYH2Zvn2UJ/lSdeApbmxsns4ZgRmF3MtB9lMah8oEjAIeAPvNbi5gwdXedi0yAwg0rP
	kRsynYXCq+cOIdE9O6yatiLNf/MXQG4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5792B60A69;
	Fri, 17 Jul 2026 14:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE41B1F00AC4;
	Fri, 17 Jul 2026 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784298894;
	bh=BYUt77gOaLnD9RIh57O9y6iLCV8DgyWvyhX78FkqqnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAmFrdPY24XYQ5acDhq7jYcbFZYkwynaIqmqMPtnVezWvFejovFVxwCFlwpRvPx14
	 06wZVFqeO37V8QGxAOu3+2PE/V95PPU/bId3A4HL5wH0Xt5ZjbDYX9eciKZd2vLRlm
	 DsY2T580QzVOcjGrA13jhqCWtzdY4rj8IMGgkq5rK/87t2XSI5nVElYCsNqFnJ8szQ
	 nCN9staruM05HlIJyLIwjwhBZx3aV+g2NBE8L7HthHO4oTaNX3fbwJ2VrVU5lvTlyE
	 TgpxUiV3n4va0xkg+KOIwu3KzUJ7Z5C2c3YrBK5o1d2SqyPB3ikoFuOzew0AxisEKl
	 ytjn4DAXvz8yw==
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
Subject: [RFC PATCH v1.1 3/7] mm/damon/vaddr-kunit: check region count in three_regions test
Date: Fri, 17 Jul 2026 07:34:40 -0700
Message-ID: <20260717143445.91207-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717143445.91207-1-sj@kernel.org>
References: <20260717143445.91207-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F580180013
X-Stat-Signature: csxoqppfjc136nhea6f7jb536pdh8497
X-HE-Tag: 1784298895-242607
X-HE-Meta: U2FsdGVkX19qEoFgulrd4wcJKSnNsPF+5GcD/pMHVtvNHFVMPD0c1q9gdZ7Ilbs46tUM4QgGGuCdYkr7WBnjIxyy1dvrC1norRurn23KcdthxkaqbdBempDQjC7bHPYI4ZWU1EBzfm18jPuSwkq6x05kVBOTRuKWYNjwOxhT2cAZ5ApDjtlGzTnNVaByPoAqPwxkbbfBLwxcM1bYKP+d2XJCxRxsYfZFQlb/2dA6BajwEnC4TcAoD9UIekpUowwNY6IkIbUMdmcH0M0RWDB8vNa0ED10W1onrHOCuNegb2JkJJr4ysFynxi139SZ2R7pt7ZV+hZGrLD8xe8hgxGDaOJKBhO/1EqZGxi9WSlGcAoznCIw+EJzzGqRu1yQPY8LvIkZ7MD8mfQJXZx0ptsWOBzI4bOLfni4QflZCRNcJcTeL8moZ5Fu87xqugm5+DsbyCdLZiCuUlKC3CJOxDbiVQmaJ/pOGrdBZxO7fDOiQeVTEwovWetQ0svCWlGfKNmXQiVDXzbc0a8VGdare/QX0oByUSl1WvzFo+/Zl9XjDbWJIjxllBx40LFBJ8kzYxz9+0bJ2mxYloKmAFiebvvrmNeciBjUa1vmKxJLgLnSqu1iUD5UXNh0GUHR/rQZ0TDwSdZSTnW/zY88UL/W+zZA4U9ejX4oka42wIROB9koNis/IEuitRfZZrEmz9RBBTbrf9Rnfk/HoX93tk5rK42Wt6f6qxnRIX7AqNHr7tIWilxWU7hC94faML0DmPcYt2a+a0wdluecizCBt+6SbaSSpkAjuRtgp/Crq58BN72mOXWbZ1zR7OZQbshor0fHzrje5Vd9BBzE+RXY2gmvi3ccrLFxyhSitccj+W4H0HuPy/LQHhA4SSnnSgQAVcWuvxm4g/JgIUgS0NtwHL8S5ZwEKq8dq+JGe3QyEXTMrklQK3i+K8bYaMgStIERGOkobdNUyjJnLVaTxU4+IzWKift
 4lXRfWG6
 0YLX+9Dm9fHQkapJQi/eS2Mf7zuLjVbZPcrDnHY9VdFB7ZB3WkTinrcGKGd0B4iujW3WSklo2hspXvlIpn0ZtUo3wWDdk/aLvKuBnkFX9pTCTrOpFp+LL36hBtHSaQW3uSyJ0wjeYOHg8r96jdxraR2RVmioI9wZ6tFXAYeY/JzkViv97HQSrVkn+bpPzX/cPJc0Vcy18GlO1wUH0dzUgqPTy8cEC0Cf5hCgjyY4nr3svhntR1wULLUBPJDhdZOvxec1vs9kw+OWl5ht2YKLdO23zPm0uefpBe3MXDjgRiFYuuLprEnVBK6uxi5I/muTmWiXK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_do_test_apply_three_regions() iterates regions after
damon_set_regions() call assuming the function would succeed at setting
the number of regions the same to the expected one.  It might have
failed.  In this case, __nth_region_of() in the iteration could return
NULL and NULL dereference can happen in the test.

The consequent user impact (NULL dereference) is quite bad.  The
realistic user impact would be limited, though.  It would affect only
test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/vaddr-kunit.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index 61f844336ffb5..6a95441d193ae 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -158,12 +158,17 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 		kunit_skip(test, "second damon_set_regions() fail");
 	}
 
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_expected / 2);
+	if (damon_nr_regions(t) != nr_expected / 2)
+		goto out;
+
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, expected[i * 2]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
 
+out:
 	damon_destroy_target(t, NULL);
 }
 
-- 
2.47.3

