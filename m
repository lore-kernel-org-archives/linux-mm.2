Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED155606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ev/j7rb2
Received: by kanga.kvack.org (Postfix)
	id E73526B071C; Tue, 27 Oct 2026 09:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD116B071E; Tue, 27 Oct 2026 09:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E346B0720; Tue, 27 Oct 2026 09:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CAE46B071C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:59:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 062521A0233
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:42 +0000 (UTC)
X-FDA: 85368564204.13.39CC754
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3EB6620005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ev/j7rb2";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of charsyam@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28t27eQ8gsM3u/fL1shL3y8iqdAx6jSJDsl/RU1Nwjs=;
	b=UHPCXZuC9c00+Q4DXk1EOBW7ILxUjADmxIFfc7sgHMlpobIMBRUwgyYn9+XcAMdv6l5ATQ
	va3tU/XoLsvUVXA898UMv6zHFntgF+RoRiGEwkD9CYPGS/7vYJUZNHORGWZlO/LVEi+kp3
	CnLck4JECRobPqlsld1xIw0zm5P34HE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ev/j7rb2";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of charsyam@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109580;
	b=lZF6R8s1Kt+jS1+pfXeiehJ56080Fk8H4e5KyxMr2s0ZMzFaJTnhF3vUn7Ee1VwOq6o6ex
	llgHLmpVY3I3IfQrixZyS4SkDgBdf9i5s5Qp8D/eC9Flh3UqMm0ZrOtaNtzHJ3uBoGnLsE
	NfduLz2MjA1YXZ58Rp9j/LDyLw6XDEg=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a056ced618so196779b3a.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109579; x=1793714379; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=28t27eQ8gsM3u/fL1shL3y8iqdAx6jSJDsl/RU1Nwjs=;
        b=ev/j7rb2qBF995x1zOS7RSdyh12IFvTeQvKGSoZedf14VCXvsY8YGy23mb3G3AqDmL
         WYl+ty1Er+fGBgl+9dAa4qsVk7XQI02VDXqp0hoWGLwAJDi1DSH5YWkPZvbzCorrTSEz
         YXr3/vKA9nZGENVUqeQENSlQLC/pqwR/4i47cusRSy+/VpRz0AzzxAjZmMtYkUVBmxK2
         S+14jGw5nFZv7pb1/10r8KcB8m3upKS2fs2PGeV2PXhSAOMC3OLAmZhRxqWyGMPHQCTk
         nm/kNrqSU+txIg4oMWLnkUSilTtkI7G7vdNx3geutOP4UT8Nuk7MHRYxFT0V6zABW+gG
         zpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109579; x=1793714379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=28t27eQ8gsM3u/fL1shL3y8iqdAx6jSJDsl/RU1Nwjs=;
        b=mpmM6NKteya/slNJ1uhbx2Pz+ORAWaIIE+UVz6VFa6JSsJ+HZT7W8O06Wd9CMd7UWP
         XOb7doNLrSfPNmNXWhxx/wlqqK5xh/Q4l8VrD3sAiQZXz5qlCwb8Y+Z3Ru/xqHbvmwex
         JNAbCHvwtO5cbb9UYhYLOLnmdHMm1uE2LVPPH918FcQ9seQU2xAAp42x4i7BML7NC3LE
         QNj7ek2MtOYMpjlIfetA4KI2A7Be3WlnwEDVDzvLXN6z+0u+ohbp8/13Zj6qbwz+PrH7
         UzcTQU7LnfY2V0gi4FKyCN4A0Dc5vvIgTPCROjBGdAYRHPP5bhZYRjGTZ50mCJZZWvop
         tB/A==
X-Forwarded-Encrypted: i=1; AKwUvBxX5JcD90wwiDbtI1geBpnS3R5C3vy+S2ZaN6+AZmPePefkozt1qXSDX7/L+ueR6iTmvMZ/L9tM3w==@kvack.org
X-Gm-Message-State: AFq9FYKfTHxxGqMojt54A1ILqSWu/dAMf/sRFQIq+gR05RYZ7sqDYgVL
	7itD1YNWhep1AiXUJ4jkq5THUZ+QdaRCIlSDLimLCo1Wt7mRDJxj/iNy
X-Gm-Gg: AYBFou3rkPA1O1OZMCxVrHD5KfeYquZyzzB9naMB6Fac/kTESetSQPRAVH4f8tljI8j
	vbt0q5WTgVn1YOmEt75vf9dcO1tLQ3io/6Zpl6waOeRQw1OacUhj7kNf4Y2MIjqs35YhCq+JJyN
	GjMrn5NyeuZmQUNbCrtQz5eKytqZR7vkceDxhnTGUamoAxE4Chzf3Jnmje5J+jxIPu+FsfIpx97
	2oF6GklgWjP9dTt2LTggiMxDyC5Og7wiFe/JHQLXMSq+h4Tqqo3HJOqVAGQSru2ejkI7mpZfasb
	JPgtXBMVjEOZHcO1qB6jPGEGulZXXqPpNEcDBT+h97djbA9F4gDNJFp/CcXUVJz/iHTAXHnoegb
	K6MpiBz2KMBrMYqE6ZME8/3aiOTM1mzWCyJ309I5BtzxE7ZX/wFx8ZvYPGkz7qnd6kNZEwx1+Fc
	ya5PIUV+HNHhBiGAfWdX5s1p0PVW8P+qKR5gjktKd/4v9L8sBWOXZJVrMxx7opIAXIKmovBm6Uj
	O0yUEU7OXlEWPgHgj0aBoHA4i2BjoPC2pCHRtRule6+NPbs
X-Received: by 2002:a17:90b:39a6:b0:3a7:a463:54bb with SMTP id 98e67ed59e1d1-3adeb10f4c4mr14989953a91.5.1793109578629;
        Tue, 27 Oct 2026 06:59:38 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae404432a5sm4243466a91.9.2026.10.27.06.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:59:38 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [RFC PATCH 1/3] mm/damon/ops-common: avoid overflow in weighted hotness score
Date: Tue, 27 Oct 2026 22:59:30 +0900
Message-ID: <20261027135932.2301646-2-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027135932.2301646-1-charsyam@gmail.com>
References: <20261027135932.2301646-1-charsyam@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3EB6620005
X-Stat-Signature: hxgcwzkixac65376k7xum5s7sh8ubuj4
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793109580-55202
X-HE-Meta: U2FsdGVkX1+prQuJBw9jtqnhMBe5rX4JldN6mWEeArA4mQ5jJQyl7XDLQ/1fbjZsAxbNxgLiv+kt0aycrjxDfXvJ2xTTM10kerIznECC0fkrc/ASvLcCSHoCGflAUw+7OPFQNvJB6yZgUNM9SkrnVdSX27nN2GEMB5zxD8Tp51qmLRCW0FLMyQjyOYrClJrtHhr9fx4b20s+reaIWZDAyaPlDXEskC2abCGkXXOGTsZXhM5V/IvD6u3QBtMS1jqiuq+owZc27FzGE2L8DJF9EY5FGbZ+4KoSWFfYCdcOIbSUWSiyfEpOqkQuG3hEqfIpSwtlvUeXxJvGId2sS575qLbzOVT+4y0jumREN3NVhnjf3QM06NeOfMEbbi7BxmZDMhFXbCJhUI17zY5+WrucrYyu0pG+Gveg4uPy0g/BLfr6UEFoILMex8IdDZItTU7N1qoR0rsUyFs3ayQmUBrpMgO7sz10QpEwp29XozK+OPXUkpgBU5QIKX3xxwxa2Vcy02diPR5003MrVlFYGoWWlSyFqtQno8EeCMXekr8yc4wHKWy8GI+kjfewolWh9QZkP6gemjrlaE64Sf7+4RiP0U261LDbmsSA/VX+c6u4jcngjc3YPzW1/meDkDOax3b9QviePVlH4zmssUS4NHeYiuYO6ESmbQVR5wZx8qZwnyrbnMhROGsTqayCVnIhY6nABGWvE0VlQmOoHqWLvUJHZDr/GCW8BntXPffNf5O8E8sje+97emWIb9RoLnI7tktWIQRUYPC/YcifuQmdHW7Ccb7ROIAAl8efiMMs4p8S+stIT74GstykG/5ZkS5bQEicuIocw0vfEJgQPG9W9lKJ04taUNgheyIn6o/hz1rJID7wi8AAMhcDAFTF6RUp89DdIOOGfd7obKBodpase6pLR5VtFs1a9Xsf4E1vCBMoEgKkqdxco3gijoyNjh/mwp1K5J6Z6uCoTPPs9s2lCuB
 vpG5EZLN
 PKfXDKA5xonUUmjfbRMzfyWXOPh4e2im6BzB5mBtToV/5c2+k9G5LDManOf2V4oKhtDCtbcFzV4WhQ7T9PANOmTn5slCyLH980YHWwYIQ/JGZyqyNMrEZ04vVFBTpEV1IaaTQmUrm3jU2L6Raj0WNReKpPY9OPH8ts+8GJnO357yh96XuUiYyrufr7MiSIa2eCqUXj9d6Ru+VIB8nkgQ+h/6oLEa9YneRYOvpEghldsO2pxazrDaStwhwxetsPSyeHivweOvtl7xEGVhGl6WSSW3V5mkaIzYVXg9pcFcnFzrDsiliE8ManMUYtaG8/oYyX8QSzDTnlKtV/MtpDXcsrGrF80zIsScHgynvl/svgiN6e4IMoDJv0ByrDlpgp8mU4br6Cp6/gEPx6Pt+kLKrw3u1/0sHW4CyW1JSGunznJiEWawkN0Erl8bV4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_hot_score() combines the frequency and age subscores using the
user supplied DAMOS quota weights.  The weights are unsigned int, and
both the weighted sum and the total weight are calculated in unsigned
int.  This is independent of the architecture word size.

A frequency weight of 50,000,000 makes the weighted sum wrap, so a
region that is accessed in every sample gets a score of 13 instead of
99.  If the two weights add up to exactly 2^32, the total wraps to zero
and the averaging division is skipped.

Accumulate both values in u64 and divide the weighted sum by the full
total weight.  Add a KUnit case covering a large weight, weights summing
above UINT_MAX, and zero weights.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260623141527.044D11F000E9@smtp.kernel.org

Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 mm/damon/ops-common.c             | 10 +++++--
 mm/damon/tests/ops-common-kunit.h | 47 +++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 3 deletions(-)
 create mode 100644 mm/damon/tests/ops-common-kunit.h

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 2f3bf86a221b..af170b112e08 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -170,6 +170,7 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	int age_in_log, age_subscore;
 	unsigned int freq_weight = s->quota.weight_nr_accesses;
 	unsigned int age_weight = s->quota.weight_age;
+	u64 total_weight, weighted_sum;
 	int hotness;
 
 	freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
@@ -197,9 +198,10 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	age_subscore = age_in_log * DAMON_MAX_SUBSCORE /
 		DAMON_MAX_AGE_IN_LOG / 2;
 
-	hotness = (freq_weight * freq_subscore + age_weight * age_subscore);
-	if (freq_weight + age_weight)
-		hotness /= freq_weight + age_weight;
+	total_weight = (u64)freq_weight + age_weight;
+	weighted_sum = (u64)freq_weight * freq_subscore +
+			(u64)age_weight * age_subscore;
+	hotness = total_weight ? div64_u64(weighted_sum, total_weight) : 0;
 	/*
 	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
 	 */
@@ -576,3 +578,5 @@ bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
 	}
 	return matched == filter->matching;
 }
+
+#include "tests/ops-common-kunit.h"
diff --git a/mm/damon/tests/ops-common-kunit.h b/mm/damon/tests/ops-common-kunit.h
new file mode 100644
index 000000000000..813bad69cdcd
--- /dev/null
+++ b/mm/damon/tests/ops-common-kunit.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifdef CONFIG_DAMON_KUNIT_TEST
+
+#include <kunit/test.h>
+
+static void damon_test_hot_score_large_weight(struct kunit *test)
+{
+	struct damon_ctx ctx = {
+		.attrs = {
+			.sample_interval = 1000,
+			.aggr_interval = 100000,
+		},
+	};
+	struct damon_region region = {
+		.nr_accesses = 100,
+	};
+	struct damos scheme = {
+		.quota = {
+			.weight_nr_accesses = 50000000,
+		},
+	};
+
+	KUNIT_EXPECT_EQ(test, damon_hot_score(&ctx, &region, &scheme), 99);
+
+	scheme.quota.weight_nr_accesses = UINT_MAX;
+	scheme.quota.weight_age = UINT_MAX;
+	KUNIT_EXPECT_EQ(test, damon_hot_score(&ctx, &region, &scheme), 74);
+
+	scheme.quota.weight_nr_accesses = 0;
+	scheme.quota.weight_age = 0;
+	KUNIT_EXPECT_EQ(test, damon_hot_score(&ctx, &region, &scheme), 0);
+}
+
+static struct kunit_case damon_ops_common_test_cases[] = {
+	KUNIT_CASE(damon_test_hot_score_large_weight),
+	{}
+};
+
+static struct kunit_suite damon_ops_common_test_suite = {
+	.name = "damon-ops-common",
+	.test_cases = damon_ops_common_test_cases,
+};
+
+kunit_test_suite(damon_ops_common_test_suite);
+
+#endif /* CONFIG_DAMON_KUNIT_TEST */
-- 
2.43.0


