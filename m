Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38422CCFA02
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85588E0010; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25E48E0012; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40078E0010; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B84D8E0011
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F12B59485
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:43 +0000 (UTC)
X-FDA: 84062853966.07.1C19EB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AE1ED1C0004
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pTnX92eA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021241; a=rsa-sha256;
	cv=none;
	b=UArf+AOKdOr9DJp9DZREMFj01h7x1ox3kRbs0p+WSDiQN4TvDHrbay0yXyZgqXBIxgTKhx
	kukf1xl458XAtURGClop382I3nv9y4RUdDLBEbqcQ7qJlpl3WN7i6a8+WI7u3OHT5l09V4
	tzprGLG+0eeuLMLD9EN7TZTJ2hhBA9Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pTnX92eA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waVgRIZby+fxBgeucQihg690OIa8ER4WAjeQ8OAK1yM=;
	b=yyNcu4mTyQLQWiHACXJCcMBDsDW+HKFkAOjvbY5W/wqhwfBL2HrZBjpTje5YkTMCqwbQ/H
	vA30owsMbtuPmPHX2aoKFCgB/tEQGix6iWn0idGJhlyfVgnEc2RBkloiH23Zr1Uy6uyLRr
	+ewpbnVXkdxW8q8oO4loB+2pqi4kkpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4471443D5;
	Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B98C19422;
	Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021240;
	bh=nowG8T+x+dG/UTataXUmNzsTvJgJYwTbgZ7j9/viwz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTnX92eAX8Tf+fp/lAUwcaxrEGjrHeadsPJpIZsbEqqDPrwZrqVp38LCtAZhEyl0l
	 fI/K64ycIzy/WXv1deyCvaZzD/ej/px2Ws/JvoMxo/BQz6DH4SCLO7OQt5PZ/emXh+
	 RErI/36eXxKdf1UAr4x9unOEWvp/1XboK1x+d4TaUpNX8JNnFk/v8KhbltiMHEA00c
	 HftovZWEBLEsB6ThgrTXJEWApG9I7yabjYikWW0a/nAnVqPtDN1QGKx8WlaXCcF7PU
	 bc9YLEoIj7Nr/hkeEaZIf74U2CtQEhFMohiQGqcoQG0X9pNkABBDigatEpVU1s/SmL
	 rVQwbBT//EPtA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 14/22] mm/damon/tests/core-kunit: handle alloc failure on damos_test_commit_filter()
Date: Sat,  1 Nov 2025 11:20:08 -0700
Message-ID: <20251101182021.74868-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3i41fkimpeatgeymecdyesy3am4xp5fz
X-Rspamd-Queue-Id: AE1ED1C0004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762021241-773211
X-HE-Meta: U2FsdGVkX1+UHtkIOTMxFNGJI6zKx8vgat/NC0UsTUQyzZk4RaiTCa/aC4m65MREVEDYZfsEtQiZHC4L4gf8NXZH0iKs9qXfvi0PSsu+bP3nlcRF85ZIaTuJTVMkx4BUtqhk7B8sHvDDGNCKDNbpDMCXyb59iHN8jQfS4SrfOe+OKfjHMFEp+cCObodMO61eqDtubzCSnt2Fl6N3h9PdURkaTGp9K91w6WSZBnUlT57t8+mwlr/vEEwi96TB446NhzZWPp5zlYBa03xgHaUbyYFzfzbuC9qid6EvcDh2Hpo+WzK8juEe/i16hpYVOBnh+gSm7b74Rb3QMAWz7s20AdIYZalQWjp78ioskSSG/SLh73A35hYfmpJF4BshMmeJgqDioXUAzCV6CbIZgA2MjEgkd0MKl+bN+au9PSIniKd0EjmZTnqBmOexVZL5DoPzItzpJ2V/kSChXGriO50QzEt81ZK19Ns/UzXI7wGezwZ6DmWY4j2WDuglrR6F1x5bzDL4wIkY3Zz/WDJWRDfrUenHivQPYo/yGmrzR8Nh7ygDCo784yy4na2O3rtNFORuUc/C+mWiZEs7pHFRUlBJsQaJoxZY4QfbPlEmf8Won6KG+T/4cf2gPEyW6nrWqW2GfA90NH1Z1+GV1zEs9jVDPnt5mtNfoI2SsG4NTjygilQxeuELMD5swy98EfrX8L4gXfhIQ9Bf7PNQ/43z3QHMQv6ttw7S7bZsbzyYuRj+uI+OdTIM3LDSpxJTy4IMoT2F4eiCu3AEUuSdaCIYscvH3Qpv54oFnR+aXm+n0i75y5uis0vozpHbapH+DB6HO9KiAuXxDKcow3kkNRTth6EviRiX16NdMWg/P+QqVjHc4Jx+1KeRiyYRq1UYaFW6ILZ0126rnCVIGDm9ecD7Nwsbg+5IH2cHSnl6lw3fMj5lMIm/6gcTtARIOkr+gByDxr3RgRW8HusqhORQFXY64Wq
 6zMxbOgc
 yGg114UStZPDqL1Y19WjSA4dd3HstW3vH8drKEXZ/qeygWO5wqOb8J6kOGTfsBoW0xJ7hoqBkkkh7vuqw3w0VKOMwsyVObpZY4Gy9Y18UqWUT0QUst9n9qZT9sYsfOKemBEzsZq+h1OjZFm7p8aWoAnVSpTdeKUevgV2oW5vEqDdS9SwMSh2E8Bre1KlusgeESF2FVy5K3AveDKWtu1a6DmAA/VUO56qnZ7AJyYNHZsAtQdYs4ureAvVrCSHOHpbYO+R1gAp77UPYMOnf7mBLzp8hIaZ6sJnpuDXm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_commit_filter() is assuming all dynamic memory allocation in
it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: f6a4a150f1ec ("mm/damon/tests/core-kunit: add damos_commit_filter test")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 03c7ac31db5c..5af8275ffd7d 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -516,11 +516,16 @@ static void damos_test_new_filter(struct kunit *test)
 
 static void damos_test_commit_filter(struct kunit *test)
 {
-	struct damos_filter *src_filter = damos_new_filter(
-		DAMOS_FILTER_TYPE_ANON, true, true);
-	struct damos_filter *dst_filter = damos_new_filter(
-		DAMOS_FILTER_TYPE_ACTIVE, false, false);
-
+	struct damos_filter *src_filter, *dst_filter;
+
+	src_filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, true);
+	if (!src_filter)
+		kunit_skip(test, "src filter alloc fail");
+	dst_filter = damos_new_filter(DAMOS_FILTER_TYPE_ACTIVE, false, false);
+	if (!dst_filter) {
+		damos_destroy_filter(src_filter);
+		kunit_skip(test, "dst filter alloc fail");
+	}
 	damos_commit_filter(dst_filter, src_filter);
 	KUNIT_EXPECT_EQ(test, dst_filter->type, src_filter->type);
 	KUNIT_EXPECT_EQ(test, dst_filter->matching, src_filter->matching);
-- 
2.47.3

