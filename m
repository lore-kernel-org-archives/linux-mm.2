Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23331C44515
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7686B00FD; Fri, 17 Jul 2026 20:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3979C6B00FF; Fri, 17 Jul 2026 20:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD6A6B0100; Fri, 17 Jul 2026 20:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E913D6B00FD
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:14:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45FF71202A9
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:48 +0000 (UTC)
X-FDA: 84999976656.14.A0E950A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B6ABC20004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dk5Y5mnL;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784333686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYUt77gOaLnD9RIh57O9y6iLCV8DgyWvyhX78FkqqnI=;
	b=6KEAAElzuLezDwDXY9G7KbvCxhG4lX5aOjPtUk9fM6gRP1n4gIslTB2w2ad6cGw8THpjH4
	2ddfqh+ZainLL7UAYbtPbU6FFFUGoLBab9dEDPZ+/7mu+kbwn6+E9FwXIYZQ8tB+PHjp+N
	AjQ/34baimWDx96IE0kqPLXcSRSzDMM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dk5Y5mnL;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784333686;
	b=JBeKsapcnk3cv/UuMlAxnOU3k8IlUYIEiPtoqCO8NlosVLTBjIYMgaHZNpTIESv9msW+ER
	aIxOqrhv6EbR/7+1VZYwW6q6AnsWhQxAoA1i53pgdRsU5Hmvu+FEReCdgEJsI7UPxlrYns
	6g9Wxg9iigoiqt709MHy4hxhGwihkeU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47BB560AB9;
	Sat, 18 Jul 2026 00:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10E51F00A3A;
	Sat, 18 Jul 2026 00:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784333686;
	bh=BYUt77gOaLnD9RIh57O9y6iLCV8DgyWvyhX78FkqqnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dk5Y5mnL4n9nX/qD+riWA/ocT3wlzIvV64mCeq4BIDPZnxhLoxScdDhMwdgNFf7zF
	 2iA2J60FRi0QCcK9b/Ev3kZn6isdq6kJon5KOwDi1aXFlthjXVHBdMcaO4pe/GSl2S
	 WdXeCd/lBbclbCT+ttbP9Vv7ictIL/0tNSMQcdiWd0zj0RD4ayuhATuniAyn4W0pWo
	 CY5xNFiqvWohcGTK/G6HGuUkRaSea9ew6LC4ldMnjwmdvKLpN/6SUd3aOyC//s3a9l
	 OS0a2uoubtWa0f+1KwryUzcHcrv0xMKGY9cDmLyCKWKB2tDcK5qriW2xupwwAM8y9A
	 N+JY9ISM6Qb7w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/7] mm/damon/vaddr-kunit: check region count in three_regions test
Date: Fri, 17 Jul 2026 17:14:37 -0700
Message-ID: <20260718001442.87129-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718001442.87129-1-sj@kernel.org>
References: <20260718001442.87129-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6ABC20004
X-Stat-Signature: nf73pger9gaeqfecetcjm8hadwf4f3b9
X-HE-Tag: 1784333686-827113
X-HE-Meta: U2FsdGVkX1854ZecAYPVwiQ7GA4hurk3Acft0VWkEWXBlV/HSv+iIqE1VKY9VEv905eJ+OtMncZxABHBvYXbpuIZctbD4ScyRetYxzJ+LYCwQ3zLFOHxKHyVIa631RFewID0W3b3T5Si3jfrqZVVXH30CmefvY4+HIZTBxXl1QTJRCW+kaLE29GhV0wpt28XLEY3M3/S4PD014fyxXhR9CDM2vUk1FB9QorJ/kqLaGkOo+5AjUR5hjWz5kOb7Ogz/B46miaVEo7+hN8orjlYC0GMgsxEMuSc7XIsdjFE/tTJd9aLENOx7EqHlx0oPzyOVoArkZs7AMUGV9BIeYoN0UaJZxwPmJVNcwNnr4FuXp1XH1IQ9erD+YED/8vYcMD9vN6Z3mfC9ppLc7l6k/NGTUN20uZSQGngUpa+mxR/DWiyKB3nWxWbQHiaqoBoxwmdWl35VXjK42n31Saa2cL6hRZI+fMMsY2qp1/dzVCIDsHIZ7vCrbKtAyjIYCoH216wyw7Qi4jtcjKLbEmpDT3By/g3y//9B2Q30n7Cb6JUaHbUihAeEjm0y73yDeX8bJ8KwLqLZlozDBmu78uT3ApXYzDaZoh/R2d59azGgv1GfnOmehm2c8Q7oupTBTZp7hnk6KwOAPr4UAwT4jYykCfudRbkOGbp+jV2LcFfIOt57hq7tL51ZHDDD6mvB7yP+hGJMKBva/hH05GyRe3CrAEEkxjj68KmHr2uQsdgF9SstrZwy6PZ48aRKy0iurexSc9///bNM0eOkhUkQp8R39vFPOA+CiLSjlOxclnD4MPQEAn7/QgfSsgNfjX+/M4SkcC4WUK70dZ+BrUcLXsLWF8YhsNJ8mQ7MfacF0xTVKILnIMt11P8ArVdxAUT6X0/nZP2usIifvbpqM5m5mI1dToLYwEcpJsNoHYRFF9SAi05fFrZmOQ5+tz7db96bcjbhdBh3Dend/ukXkM3mA8GbRY
 soUK3u3a
 4pNu/jH3mzyeWLP9D48w5viC4oJZLF4nMuzilCYsesR76oGT4E5eqBQw3yVBLrwCM5yr8C+ekAGKPDy6a6d/CWLmpmS0zyOM7dHImI207EePRTzOxbmKcacJuxVM3eG9P9I8+y04ExnVYmAKGwbKlQwoQ2WR6oaRjepKHIOJ+rMIwFm9TJfOIVWaVTFm00u3+UNSWroSRdtc2B5V3bJ00NgkvYtSX8ibJKuP/PcYQNMmPr3tMQJELP/ZMAtBGDSkRwebvSS9Caog6uV3u7BWbKGy7rpplHeaqrL7hkjNawSYrqhZyqCrcFi4iAjcKnBH/wZcg
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

