Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B4CC44515
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C244E6B00FA; Fri, 17 Jul 2026 20:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFBBA6B00FD; Fri, 17 Jul 2026 20:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10DB6B00FE; Fri, 17 Jul 2026 20:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7942B6B00FA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:14:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFE7FA02E0
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:47 +0000 (UTC)
X-FDA: 84999976614.11.56F72D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48B62120002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvgYV8nZ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784333686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyQzh9cAgWHiv+f51XfecFAFsLqN9MeOR+zzeRidaFs=;
	b=jQaaJlgleCexmDeYZA3/DQPBCWviNfBjOnNDpHQmkAN/9COWFm3sDK+7JfgKxZx0pveZEp
	b/8fHC4CIT1b1m0odgQgbR/ORoYjqB9gv1iOGZDrcH9Kzp70mM96uhollVz0Ren9TCM7V5
	mzvcY1H5ix+FDWICE4w3dDY3Rp6uAWA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvgYV8nZ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784333686;
	b=DY3PnbI2XDJHQ1ggD/cfZn8iN+m4p8vnO5zR6HBelzEEEhcFK9l9kCNMsLbAZtEHWKbCmE
	GCYMA5/TaCNIUWU/8w74r5sV4ddpBcwDqGqOhjplcpH8mmJjddGrZQ3488/PC5Cgn9sRmP
	/C653B4WP8Lf+Wn7/Sk4J2pyR6LYw2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93B5440737;
	Sat, 18 Jul 2026 00:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237C31F00A3E;
	Sat, 18 Jul 2026 00:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784333685;
	bh=KyQzh9cAgWHiv+f51XfecFAFsLqN9MeOR+zzeRidaFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvgYV8nZPh0Vs1e2HWmXBKovRq0Q3KTToigGphwSzwA2cJWWfN7ore4sH905Gw0ov
	 FXzFVC/n/hY9EC1AhYH4jO0MfoA/h9nvdyRFi1NWFwJFPvVuLjDs4db3V4mzkfeAT/
	 HwsF9mGbmafyJDwVY/osoUqOWNLphNkQZ7I8drngm/DrT8ckGOzGltlIFAVVRbWmC4
	 r8yxuIByONYDUB1G1Zf/RbqlaIgXszwzFHzLC2uXK4cTxPmR7jmyuqU/UJUWqRE33s
	 ls7VImQlsPN6pvlnjyDWKnhBlktzvnuBgXBW1i8jo30Iaiyz+gfNfZYfV3RYjuas0o
	 7GyiRuCsclNcw==
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
Subject: [PATCH 2/7] mm/damon/core-kunit: check region count before testing in split_at()
Date: Fri, 17 Jul 2026 17:14:36 -0700
Message-ID: <20260718001442.87129-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718001442.87129-1-sj@kernel.org>
References: <20260718001442.87129-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8n1tsoywbjq9x7iz39y9zbcdt18izqwe
X-Rspamd-Queue-Id: 48B62120002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784333686-551004
X-HE-Meta: U2FsdGVkX1+MtDkAO4RwgO2u1NhPYDsjKS1Sa0P6PGZgmpJ1ZLvEgCMsOvpyU+H2rFXHtZDWGwvhgHJR6+Dzld7fwIQpLI1Lo9A4sgHDalD/eTfMc5xPRWrJbMgvUYvMS6UJWsj4frBxPu0UQu5BaksM8UOCtXAxrC44cE3dlds2kCUHAI2EkGbyJO+0AcgHaZq7xZyeH6Gu1qtI0V6VtfYk4zkgbyrbwDmNU2qFEBl92cWx7+5u4SbTH8f+Unco8e1Xfk9odog51oi6SWTLlSqYHnRvAu5NNm3TfV8zMgmMaTshgPmo5bjXyiR+xx8RTzaBIWPGD5O8qZ/TC9NVXtUjt+3cTQDarwGH68nylhjgxLQJAVTCG2ZfHZhqNQkRHo/w+fUTCKO/evxDrAx4ezm3OoVmT81srVfq+eO3UkIOtB2cjZRgEr+pDEi+XQIXPn/DEsYsZ9rV+ZGc9k+f96Ws3z1vxirO2UDZSgC4PdpCp6myD/WAq2DUZs/wWRMAukrIWkbNSzrfVfRkzz2aP1bvylIUU2LuaT9f/qsCgbItYEqr/LmEIhw8B6lU1278sMfRZbiaNWRmK2wrqMrPTfndtyRDG1RlAPaOWw6JlLdtGY97Wi9gmfvtaIyEi/OCNIxrZHlNnYsJSWclUnTHB8TfI+pMfeVyfrLWF/R/pOwDuBXQq9YUFlU3W5PAVvwa8Gg5U083WYH+beJcXCJfbojGs4rhL7ne6kOHqkdVw1CTAwh3bsdZw4tnBAWqGOEM/6hQ/q02lApkxQQkQyKijBOLcGGEnN4vQaJM90GebuOFQ81f+cKim8pcjN5Q/zhd2rZOegu8qzLVpme0mUkp114I105YEDLOCqusJk6sN78pdbpRkz3hgv7lEBpV2YX4oRDhH4T7TZdN+5F3NenJQNw5v7rtLSXNX0chKEHySxugXYgBY6Q0vVRZUxBP827n7QAfMX8TQpe3E/pGJof
 oCtjuZkX
 HMf4KEWk99qgKmf0EYAK9iM2xgr51LcB16DlRZ2mpEaghge18N/BhIagGbjc/VivZi2sC+l/+XE5FytOJNbG/liB566RadHlGTVLkoyNmIWMzk7taJQ9yMqSoNGhX0CSfMxI/kP5TrOlAQk2sN8SOK0oOYZop9+td8pUjyi32XvYBaxbmSISLr4LPYDI9pzb6f72EaGLZ839sW4qkQNEFT5RDTSIWttAtxGYxisxXtvhNgPIhFFuF7nP5qptkSq7WzDUh5qyHMb5E1UV9mioG1DhiFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_split_at() test next region that is assumed to be created by
damon_split_region_at() invocation.  But the split might fail.  In this
case, the succeeding test may dereference invalid pointers returned by
damon_next_region().

The invalid pointer may not cause a really bad user impact, because of
the implementation detail.  It would only read wrong contents in the
belonging damon_target struct.  Depending on the future change of the
offset from the link header to the accessing field, this could also be
really dangerous, though.  Still, the realistic user impact would be
limited.  It would affect only test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index eba643762132f..322a295ac2cec 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -155,6 +155,10 @@ static void damon_test_split_at(struct kunit *test)
 	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
+
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
@@ -166,6 +170,7 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
+out:
 	damon_free_target(t);
 }
 
-- 
2.47.3

