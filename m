Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1BF7C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BAED6B0095; Sun, 20 Sep 2026 08:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F64C6B0096; Sun, 20 Sep 2026 08:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C586B0098; Sun, 20 Sep 2026 08:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1F886B0095
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:24:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C9891A045F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:25 +0000 (UTC)
X-FDA: 85234058490.03.3E43D8A
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id AAC4640004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A0bBImQK;
	spf=pass (imf11.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtyjzrgYhOa3bpnnzl8J/NBn02c098QytsBeznFYa9A=;
	b=puYaGBXfbDrunHD0bEtYADsv6yQEPWIdIzEvpDgxg2x7ykrNG38HlG9Qmb4DrLJ08E1eWL
	XGsguxT9gyUJVulXR/RBkYVfq6Epps/8es8MxjFOVq00YvAHnucHENYP9zbJp5/lweGRbV
	ATmW9tYS2/jrukrtFNgn+2/QyVr28mg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A0bBImQK;
	spf=pass (imf11.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907063;
	b=nXKbWoM/V60gZkciOo4C65AUA1V5K2CHNzgZbU3uoNZaaE327Kygo2IeNNgA/5ALZ1JUsU
	xGEsI8JVl2CsAhRnOrP3w7M/r5HXIXb8yQuy7YkKH9vAjwPM0OH2KpyMHWIOCRFanXHi+b
	jZPJ8/LxPJweqaJ0g8fpfdEFytsu+i4=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d93ff61046so21442725ad.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789907062; x=1790511862; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NtyjzrgYhOa3bpnnzl8J/NBn02c098QytsBeznFYa9A=;
        b=A0bBImQKMvGYqdZFEAkk8QgA0tRXcTpDNTdSURrTQ9sG/dgUmCYQjkmjcGqCSewArz
         yF3XWk+G9V9pRpcA+Ue4844iuQAy0Kje5gatVdVJJqJtWbOOFGpowuGKqzrfIjwa1HW9
         fky2am0NDafW7SK83sn8RzIgaEXFxIqeqSuUqJ0DzBYSIEbDAVTS/7VQsetChKmDYJep
         M2O1086kZe1QdwZzH167obisZywZtcuReBjFq1fYLlFTCcLzruCplyywbP68JhwThoMf
         hvZXKbnrB2OUHLtHZK9jWCh2UTqGKaRUXtkbRY8OtDTQ7S4fmg0DL2DtqdUzd+TP76aJ
         /npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789907062; x=1790511862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NtyjzrgYhOa3bpnnzl8J/NBn02c098QytsBeznFYa9A=;
        b=Yq0ZxyfGSkmy2kSsJKJUFfVU4yw0mQfrrpEdskrYzwvZVqhusxG+mD4nxG7gZjZ5+K
         LWyxBON8UlQWU66DTra3ps8TtngSjGqDsstN3xSHXyK9HMqfDwe3+1vNRghFVqR+01xs
         QirbTPypXBCKnEtmwvr2X6ZFk33jsKYz8j+m02+4TRM54Iv8fuWfK7A7mv7hKyU52Vx1
         ex/WC67SPI4TCVAmFpoS8U2i4AMkGJ7LT0wNbJEdxJvs3O9VcSxZMTfRtbbNcffEmdFp
         QdrTFc3hAmtWqd7GqdET7MCFNFmNBHMVSHmDiagDbFrFOUyWVXWPhnQa8GEGbuRFlCuG
         ef5w==
X-Forwarded-Encrypted: i=1; AKwUvBz/GOFdn2oz5R/ygpc1oigIhYtbT827K8K4F3z4kW7nvOQgJa2L9kWir9LxkKAxzGiy5eO+cz5hrA==@kvack.org
X-Gm-Message-State: AFuF++l2l4PhQaSw9UezKwjQ2V1VsMnFn6WfuG0xAevAoA4sG7XXfzN+
	U6ZHxv4hObilxAVgl6BwXUg4BaT0Thek+h12DGhA6nNM/yC7o6P7xODBbwAaW50=
X-Gm-Gg: AYBFou3NVY4kNKCnl6bm/7Cdgpb4FYevuYBpb63a+pTYCuXmxPt0QMgdGaFYoRBqvsv
	YdIyRS1E8dmEHqiowugZt7b7g6uHDAPJp8+KcG0deowoIsugpp5hIX6Pdc3OKYa3gX/MSDNcpwf
	1xADtogVu78dRK7ogCpfq+3hPFIWMAh3PpOoFnkbNTEO+nvlzeHZorj7hlYzQ1RBF6hlP/dpKcF
	pfIvh0ImZcrVOBrToahQELWJmxbI2y6qgPGZ4oEkg9uX9N7PnFIVXXF9RzZjNAF2AeVnrLyV2I7
	lqa5MoJWLp4iNREsQ5kHbynctb1HrlwxYK+r3Q2XYWZwac1pz3CLZzpGa+ejk2INP1QdVxigV+n
	v4CUp3Gx4VtKB0MNSKq5UX1fB73wWimGspsIRbdRMzY3sLj7ZTDZ2L1G+hLHuo+jvFB1Hx68EA0
	czGUeN/IQY17uHGmrUyGq4VxfaEe7bnbg6WXLwNHLPWt1LoxsRcDPlxYW6Qd6i8cn5/IB04NGv/
	Qu3MLdHVyiHQ4oXdIpkNewl/+w=
X-Received: by 2002:a17:90b:3a81:b0:39e:6a82:afd9 with SMTP id 98e67ed59e1d1-39e6a82bbe2mr6880094a91.43.1789907062475;
        Sun, 20 Sep 2026 05:24:22 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:e0d6:4b87:c472:c9ae])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cae997csm8753943a91.11.2026.09.20.05.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 05:24:22 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v3 2/2] mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Sun, 20 Sep 2026 21:24:11 +0900
Message-ID: <20260920122411.610213-3-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920122411.610213-1-donggeunyoo.kernel@gmail.com>
References: <20260920122411.610213-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AAC4640004
X-Stat-Signature: dgtwxwbhf3pccw34gtyq8iwecrufwowp
X-Rspam-User: 
X-HE-Tag: 1789907063-468354
X-HE-Meta: U2FsdGVkX188az3CiZtKJ4Flw+/CQS4ntqep6erNOOhdF6YGzcP3lSHIzqMpl4/+WmMSrNYjBe8t8jb/n9I/f4AsVpgQUZnMpNEjy1EUjbEtMGJRvlJsSMXEx++bEp5NFXeiuPxN7IZiXYNNyMd1RfYLQZT4BY2YK7etjaInqiEA+9f8G655AE9T6hG7iVe7renyZEUCN4HeaEyL4O6wHuDGu3MmcPVKUoZUHnvXYqJoWP0pSv+RNykkvLywm+vzXH2bgT//quX1B+Z75mVLvBKTCMT1oXhHFA6Xi2YcoFOc0UWY4GFSaYEItZCdxD+AwMnmR5hnbpIybulaFujaIS5feiSQ6rSt2ZI5w3PW2dvaCebOsSXT1+dh9PiC7sfOqH+KD2fiKRnwfr1riyBi0ifrgNOeeGuV0Iq3vRRk5cXAXyhMSwUz3NVeOo9npOHrCFwZv5FcHYg8+uU7b8Wnyc5iUdXhuKcyBvd0jjVzepXam5R+zw0ww26P4QZrR95F3Mn345qQgefUEdoSrgK/Xu1Df4OEMWiJK2s6767aaaYfSgmsyrd8a+GhwvdO+GxZmrtU2WcRoObnui2nl/xGJkh4US2/Vsm1Rt/dtRFKXuZ8obzVvs8vdbmsCoJLLvH8xYutBjrSBMii8ORtnu+FA1kNEH9wO7HJmHJGGNxm5EVsJhqT52WQPf9oe3DyFWrKsO37xaVAP95DkJ2v9WRJ7Bi2LTzpTLUEeSje9Tz3ZgnsH5fwJbYAIuGxzvfHJGSYzbOWSN8oQXRg7vSLOF/NScXsKh3OnVdmxUxdu1iH+FM2jrgPLC9NPsA3v2HljB5Wt1bv4jItoM58up5/PyGdPm81UE7SbwxyE6Gzv3c6sq7+xMjqO9NS9zjhpLI5jXKwUmPuPqxbKwXZPLvr73zXhrXm25DBSvROZXvQiSfw/7sgYk3961+R/VlbKxhFs9edULnmFMTCjPyZY9el7oC
 mIfiBOBN
 Q/2wXNjZlSawROMCzJdybupWZF/3znyrvxOUFRmv8sT6MhKbt5Ydxad4rdijeBheOUuWQuEuRop6P3bwyVbLIqAm4xAduVKtOrGg/VZ44yLZgjXy3ZwvfKuEaMRyv4hJhOsRcYF2MBSecforpVlsAO6ChAhAGGiXaqf2Kd7Wv9btXA8mf5imZCPJAhKv7ESYc/UXzZVR07643m0R7Ov+Qb105Wb82+BODEX8T1kBdLj0Vac4Y5mXEAcSfKiVud2QTRQhlJUh91QAQVsprolNAM+aWhpEH18MgZslWoQFn7rzh6I4NtvnHabCxe593fdRmD9svvHsE1MdEIFd6y4Kr+pcaz5MeJQZBHni4Wso33KBy6Nuc6x3QMCOL0scjftfOZKPvNdrSd86b4Wpb7J3+ZTeOE6xDPrFkE4LkqoGfAocHWRWTttiTWhw0x1blAMcnBC5rb/T8v+rjosSZbllUfJ6dTaaickF0mLE71QN++mJS9kA3Z6VoBV42Oa/d77YlCaO0dFOdULkh12Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() encodes the size quota in basis
points, so the conversion is exact only up to ULONG_MAX / 10000.  Pin
the three sizes around that boundary: the largest one that fits, the
first one that does not, and ULONG_MAX.

Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5ff0436c58441..a0604788bc638 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1929,6 +1929,53 @@ static void damon_test_rand(struct kunit *test)
 	}
 }
 
+static void damos_test_esz_goal_temporal(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {};
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+	};
+	struct damos_quota_goal *goal;
+	struct damon_ctx *ctx;
+	struct damos *s;
+
+	ctx = damon_new_ctx();
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(ctx, s);
+
+	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+	if (!goal) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "quota goal alloc fail");
+	}
+	goal->current_value = 0;
+	damos_add_quota_goal(&s->quota, goal);
+
+	/* The largest size quota the basis-point conversion can hold. */
+	s->quota.sz = ULONG_MAX / 10000;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	/* Any larger one saturates instead of wrapping. */
+	s->quota.sz = ULONG_MAX / 10000 + 1;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	s->quota.sz = ULONG_MAX;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1965,6 +2012,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damos_test_esz_goal_temporal),
 	{},
 };
 
-- 
2.53.0


