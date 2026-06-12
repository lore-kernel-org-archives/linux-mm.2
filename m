Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F851CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 06:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3C16B0005; Fri, 12 Jun 2026 02:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984506B0088; Fri, 12 Jun 2026 02:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A3A6B008C; Fri, 12 Jun 2026 02:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBB16B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:24:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8711C2280
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:24:14 +0000 (UTC)
X-FDA: 84870270828.20.88E32E6
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A65714000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:24:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i8pVk5Eg;
	spf=pass (imf09.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781245453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45sVfS/nx2nzBsCxkzCB9QiCoVHDr0etpbiBAxE4XQM=;
	b=wy/W2ZZWBNoncLBc/4nHipHAQ/+QWKg6JQvwbnnt04VK4yUJLF3En941jinSGDrJEgl+kY
	JQ2ApSkmJxndwcx1vkMyo8Jimmek0ivhotKH3GQYJ7Q7qSPjuvMAp4VPtsQ6uZEHbUNJUg
	FcPzujdK/yhtJpIBJrMdVRDaaTO4gUo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i8pVk5Eg;
	spf=pass (imf09.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781245453;
	b=IDQvJyCVfkWmGOll9Ef3uk2V6d9+3ELby43qzmMDI5uwdK2ktzvVIF0egvmhpzrBHgfY+X
	xgi412y+YZHShseWOvhsrVckZ64BLl8xCcFHUJN5DXgrRqqiq8G2t/3VeGfqMHAK7647e6
	UrxSgaIcpIDTEkZKx9WV4R68V5FFbsk=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2bf201b93c5so1067445ad.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781245452; x=1781850252; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45sVfS/nx2nzBsCxkzCB9QiCoVHDr0etpbiBAxE4XQM=;
        b=i8pVk5Eg2YLEM23BClGR3LASJRMql9v1c1i3M6ux7MMr/SM/52oM5rPVYKleucRZfO
         pOunpA5YFu5rZ0ApozobKJp2Ip05feHl0gRgLuMXHSJ9q1FkWbxYZLrvWcZAQF3WaTe+
         iZqZpgawEVeawNHyzeTl+Milvmv6BtmcKXJ/T6F7nohO26KvARfeXefSVsAw+MtS/4zC
         N3AID4dCCmy6noVR4xzez+7k35h3cG3YCvh19p/2lhPnUFCswYM6sv4HHm95D+4lvnYr
         NJsIqEr1gZK3FPUddVlf5jSxz3w9sED4EW2QTca9JVxt9bWXWb4WGwTCy8qey1toSyyy
         aEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781245452; x=1781850252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=45sVfS/nx2nzBsCxkzCB9QiCoVHDr0etpbiBAxE4XQM=;
        b=mo6UFfHsWMutgNRgBHjm5+qeozAh0VGQaalYbzNyhwFkQemglInVIBLu2HyA51mCda
         SsGa/eFpjTI8FMRQ4Wpzjnt/kYr04kBY6PkHo2tZT9lcQVS0TtibaQJtQJ6qYLaaGGbA
         MDwGSkTbLrrsANQgsm25coTMtb5pTVEHFpm1kodTycPwFpaCM+E2BHhLxC7+9WrG1eL3
         cyejM+/dT6F+iWMfaah+MOlZrmqZ1wXYxBV6d704OclwKc/ugBRq9KrdoXZ95ZaP2SQ5
         /viHn8SrFzsyFJc4JshVOfaOvkPyQb2uvivHz7T20fjoAIPFN2oULjACf13Tu60rEpoD
         pS0g==
X-Forwarded-Encrypted: i=1; AFNElJ8BQWJe5h94ZAypiyVLqi2uP5SQROlcwYbFF8xG0jjcCEckivMM5I2aW0mKAKX3SYzEA//egL1sMQ==@kvack.org
X-Gm-Message-State: AOJu0Yzi1VMF2YeEDqPOUTePvG8i4mlhv5pAeXf4cFz2nWT+EPlyoSL7
	ej7z42v530xwnAN4BDg33mSpEjWfCw/PMbVpcGXy6+arJs+3i0aHkF8c
X-Gm-Gg: Acq92OFX969/RowGBgspI4SRwzQmcdN+DoqKAgb86uw6+VHXBbShgQu0kuJT4Rd8cZY
	QeKkFvMmkNdERuTP1FaprlJ8g+/u/acyrTwHO0UxF9qEhv868UOCAs7Dm0i769ujLRBfBv4JY7R
	7StiSVwRfVzTZ+64uUh3crVbk2AP5q2HkMoJMXpDlL7gjIWQ7esQf+WwX7g39yn2cS37Q1wLRk1
	LZUQ/mZi4/dmMpdlOZkKRCmQK98/HyOpB/F/NXXiW5ddBa0KOreyBcQ/zGCIh4wh5R4F/1qwAeF
	Bq+7rRsQ69BDCtdyVE3fOBEtDmTeYynF00rxQlcGMc1l1CvvdQthEBZ2Z4y0UVzlwwpXzSAWGWR
	j5wlFTIn0P+UmhyTD500ZJ4nl8V75uZSt/xcFGwpiOg8jYIq8Y3ADwS9nE8W1CPI10K6afde43T
	unW1iBsOfaiQPB8Q4wHrczr238jneiE2BJ7A0nebCAYn2gVZI=
X-Received: by 2002:a17:90b:2c84:b0:36b:9798:4f6c with SMTP id 98e67ed59e1d1-37a0468a571mr789060a91.7.1781245451640;
        Thu, 11 Jun 2026 23:24:11 -0700 (PDT)
Received: from localhost.localdomain ([106.195.67.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ac9cd8dsm1064680b3a.1.2026.06.11.23.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 23:24:11 -0700 (PDT)
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Subject: [PATCH v3] mm/damon: add KUnit test for walk_control_obsolete behavior
Date: Fri, 12 Jun 2026 11:53:37 +0530
Message-Id: <20260612062337.2459-1-saileshnandanavanam@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260524100258.36819-1-saileshnandanavanam@gmail.com>
References: <20260524100258.36819-1-saileshnandanavanam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A65714000A
X-Stat-Signature: 55x7fohuqxq6tn6y3djpe3aw5dyhdr5s
X-Rspam-User: 
X-HE-Tag: 1781245452-810330
X-HE-Meta: U2FsdGVkX1/PvQBjV7QJkXKu5nKwZkXvs+HuJzgBcS/636h/uMm3jZrkcvJ6MWdCANo8RhMU6ZQ22AOMRds6k1/uSGle4wG8ll2thZqlA3RglBxFP/mqu7JgU1qPcm87EJXt0imNtnIqO9pgKFx3mxg0c8cYSOKylZ6m/HjQHlp3/uaHghMQZV3idQfqcJc5aAe6RVsub+5QoupMRDF7DaJaZ48yBQPdS9YoyBuwmM49L7vdbe024e102SBycfdJHhUrEKLJr3Vm/9XGBKEhzncY4XdUhtio5hhrDWAm0n/csysp3Sj9iNNweyP7OaGJI2Ny4FheraXEuz3uo35xZT9adSj8b53xSeZ9NdYMnD8ewllSdogZcDg5/dvxC3NeJM0CAvNgzzJB7VGlmX7XkbeqaOL9y5w9dcolYIm0VmJQWwWTYL/6XM9E7aso5ZTmN0LrVK9uFffwQeddGAGxkcjmkOmdjN8P/W5uKOFoFp3lGWP8C+hTEHkyjJ1EENEE1uZVx/86soDfkLl5zq/dIQJPpBdtrE1Ez80FdUG/qxhx1VK2+sMUu243SX9TBZCVnUG/RvniaY5ptJEQO1OLMlZm3VkTKMoXiSmbWQr/8ZWUh3d3Rthvg4EBEJHQk5/EZOas6Dv5pn2xh6c2IacKj9eNi926ot9GoCf1AqRcezJI5bkUOFds1skz2LKDkvDN3FuO67Z9o9qBvzEBa0tuQI4ONVh3rv4+pibK1GX9wgdzOk8rQ8zQGwkMvTcoh0UEizopcUpUILyUdcpICbDlW0HPlIYp/YrpcQsuF3zmaK6G0h+ChN4EaN3MNmn3UVT2D0mKWhJlwTquwGCheHzeElLE1LLr7epUjotaQ4A2JQH3gqFPnTq6sHU/I2jItVIErv5pyEeCOIUsBG1DL1LnZ6tcyTXOLvPLe0SLKzpIpyPV013ElMGTrReTVbk9lLC7L1lFxOlmRMgBBAHsLYD
 fitmtubG
 9w0I3F7i0idrRPs5vSs832g1pTNcoFLdb2Cg8nFfQIFCEWyOlBbbLDZawOLV1SWp6i4m0SqH8xBuDauA8UVBMO9lq6NHMPQQdsQW1CjFXsN4RHNx997PKqajxPKAl2/OViw2vwgKId9q0QvD1YJG44T4l+Hjz3yzhNGvEALeuNyNtxsskxJU9Wr9TwqZfsHSaGeHDq+NhFvttPg8DUdQckpQ484SYJ+Vm2++g1ES5gXmgiuRt3DT4iXkmWqT7/ZIyiPtfwuT0CC2Ph4sM22VDI/8oEj22NGQ7X505EtTZeHbyGHEgePTrcNbVBRgcmqnHDOWI0jGg+XW87ILB48fOumlVV4UXFx+ZBaIOOIRXkwfZo8M6zXwwyNJx7Za4k/808JuYR1lDkAso1Q7fU47kShkPFWYdPoTgLSCbD8ZG+OkY39dNoL4qpyn6VUAMWsBqEnO9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a KUnit test to verify that damos_walk() rejects
new requests when walk_control_obsolete is set.

Commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs
kdamond_fn() exit race") introduced walk_control_obsolete
to prevent a race condition where new requests could be
registered during kdamond shutdown and never handled.

This test simulates the shutdown condition by setting
walk_control_obsolete and verifies that damos_walk()
returns -ECANCELED immediately.

This validates the invariant introduced by the fix and
helps prevent regressions.

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
---

Changes since v2 (https://lore.kernel.org/20260524100258.36819-1-saileshnandanavanam@gmail.com):
- Dropped the userspace selftest approach entirely. SeongJae tested
  v2 100 times on a kernel with the fix reverted and it always
  passed, confirming the microsecond-wide race window cannot be
  reliably hit from userspace due to syscall overhead.
- Added a KUnit test for damos_walk() + walk_control_obsolete
  instead, as suggested by SeongJae. This directly sets the
  obsolete flag and verifies damos_walk() returns -ECANCELED
  immediately, without timing dependency.

Changes since v1 (https://lore.kernel.org/20260524091812.35283-1-saileshnandanavanam@gmail.com):
- Addressed sashiko bot review comments (execute bit, threading,
  dynamic sysfs path, OSError handling) - superseded by the v3
  approach above.

 mm/damon/tests/core-kunit.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 9e5904c2beeb..599aac056b73 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1336,6 +1336,33 @@ static void damon_test_is_last_region(struct kunit *test)
 	damon_free_target(t);
 }
 
+/*
+ * Verify that damos_walk() rejects new requests when
+ * walk_control_obsolete is set.
+ *
+ * This tests the invariant introduced by:
+ * commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn() exit race")
+ */
+static void damon_test_walk_control_obsolete(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damos_walk_control control = {};
+	int ret;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
+	/* Simulate shutdown phase */
+	ctx->walk_control_obsolete = true;
+
+	ret = damos_walk(ctx, &control);
+
+	KUNIT_EXPECT_EQ(test, ret, -ECANCELED);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1365,6 +1392,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	KUNIT_CASE(damon_test_is_last_region),
+	KUNIT_CASE(damon_test_walk_control_obsolete),
 	{},
 };
 
-- 
2.34.1


