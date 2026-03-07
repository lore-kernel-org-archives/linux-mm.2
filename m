Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCEAF55102
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5D86B0092; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E646B0089; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5546B0092; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 268F76B0089
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF55D568CE
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:42:29 +0000 (UTC)
X-FDA: 84520288818.17.3475006
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22E14100007
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:42:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hHL0zZ0T;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772912548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyaHzr65VkD5inFq+kzdicf2QNBbeNOlfc/YYwP3k7M=;
	b=Bo28FKvxuH/4FeSNekFSP6TK5v2kqzr/gI6DMSZ9Q65nk72giuxQ6NzfRnE4CvicdBjKxp
	IB/TExJDgJE/WzitPTEBjeP7qvCeKy8Jf+LloD7m9V0g0OnBaBaFfwYxFCWwBhbYfDNOSS
	+ocJ81U7r59luFjAysYF5HMAyft6dOg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hHL0zZ0T;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772912548; a=rsa-sha256;
	cv=none;
	b=re9zhKbja3y3ZvDIrNmipVtYr1ztIPyEqqhUQYUSfSwY1xq/VkF1RPX4X9B4ow3GpaCH07
	r6l/1GFtM0ppQhBD/4oq/s/Dl4Ll6yN1+ilXamRZNvEdSArSpeWv+R/ptFL8ZpNk031hNw
	iTtrc2NuDr3dImzARCbmxjwWjyShuEQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 679F8600AD;
	Sat,  7 Mar 2026 19:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72E6C2BC87;
	Sat,  7 Mar 2026 19:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772912546;
	bh=AJWquAe6BG8YHnrQ8aXuxdUfziQhpzCbJ1zdbrFuHTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHL0zZ0TvAHNnHQ7Cx8FggEW9UvgVWE6BVsBXZwT60K2Z8O1FwYY3Pym8SbI1gYtu
	 xdvlKOSPZRT6iZZrqinbtJZlAhWko57Z1GwX/inx0BJxQqSupQ+3mP7OzkILA7tW5p
	 U472oBC98UgOEoKmsg5vxmtr/JI610fktLoLqtScM8MIof5ghrMqHdDlamRm8wJtuW
	 qWizXPYVxtmj2Pt7AXmB5SKdWV+qzCi/cjBkkk45HJLUBdAxI70UerT0oxZI2ec9Bp
	 6CidYja03cW/p+ZsEsl4jWhFfkXg1bUexTzIXphxBZhgi7eFqfiWKLOkIiEsSt1XU9
	 Sa6TLm0CSKJTg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/tests/core-kunit: add a test for damon_commit_ctx()
Date: Sat,  7 Mar 2026 11:42:20 -0800
Message-ID: <20260307194222.202075-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307194222.202075-1-sj@kernel.org>
References: <20260307194222.202075-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 22E14100007
X-Rspamd-Server: rspam08
X-Stat-Signature: pn784dunyg1udnzfphh7697cu9zwftcx
X-HE-Tag: 1772912547-479803
X-HE-Meta: U2FsdGVkX1/XZRQhu/FYazu0q9AnCfKDj3JteoZZoxW1juZ4ARUGuDqAuEM7fpbjUDD4DwjnEK/ffimgmAwEqMzOMEbiBxYFCjVbJloZfV/G3OebOqU++c3+or0OjYA+Mv27kj9qaYwX7fYHGUaCmfM5CzdfOohE4qyarGhSYmhfzh6pAkyMIrkVj1+aPmdtq2eaukvFXzW3QRkYgz3g/1m8gIk6j/8GVK5dcrx0NHydr3C8u55dVKsEdkI49p6BlPIy+uNYYFrxg+ad09CvRQDnvLYB3GOl4xMyC5bwLyPWmosXrPILtPF4mgBaa1i5T1WO6wQwvLYtqQMLMC8SrisNOzq8OApP5vNptsQbNEnjHkCGoUq8GtkWNckMm4tXJSdawv1F1KfuaWeienuBnwXRpKYVhUhVxSBJ23cLhB65f6nCr9CrO02IxyyEDnZboHx+XOvByQX7soG+vTvcGkQ2Y07rEcaLf0pJT1uBdpnyJ8COTaLQGjYyPQ3jcVEuODBhLnn3pf5oPNiAl8u/F5uNdylFYP1cbfR3y8xD73c08Kr504VurOdo8qM2FFLNKkUNdDGuTOP//iFPnb9f5PSV5EXx1K+US2apfMlHy+kEYev6VbX/PQNSuj/FIdexZDVAIcQG/KSn+TGrtM9kXTJ+Vx/hQwcy+O7Ftyn0h/8bO0q6ntxRHXbXZkR+bonsA+aPCUty4y3+Fq/m9eHEDafTtan4gF5+kVkfoIHhaLMKfvoeAhSCmVwylHz6NdCPb8qNzF9cM0GQpoavFWObmd0uRNHrNK5e0JUjQceyNLSUt98+U1rEWGwXUvFMjeFEtI9jE/AIDndMi/SKCe2xz+mcV3MHamn7D4qLm6VNOK78+0n3x/PeAqweQhm673qNs4TLg78DVC/ccG6nX3O/+hNzj/10fjfeNbUqctEFWziMHgLQTaQqRQfmrQHxjbZajxbex6dDpVKL+QTXuS0
 kW3M6vpQ
 PjKIGMjQhSzU2nHRqeUYMUk8FQnNh+5/jwr9HC4MK1vZQQzUhNlg8jzRIFwY7oD2bqAHZmnOgqVEvOPGiByc3k0ryp5D+inoq5l/nEBbnQ/BHhlSw8F6FsHeLPgglLB9O79KtBZxD0NrIiMYvQPZIlQMfmcywz5A9T+MP0jhyFRIYDYE9H3uQnFxEBLFyov7af9Anh2G2pwVfjTM6MSZHXAKwHsGndYJum/UCUibYpoyMCiEroZmSEmByu0JRhb+iBq0DVbiL3WEOkjQittgDaYmzEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kunit test for confirming the change that is made on commit
c80f46ac228b ("mm/damon/core: disallow non-power of two min_region_sz")
functions as expected.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 44a983fca9501..65181c6dac1b4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1060,6 +1060,27 @@ static void damon_test_commit_target_regions(struct kunit *test)
 			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
 }
 
+static void damon_test_commit_ctx(struct kunit *test)
+{
+	struct damon_ctx *src, *dst;
+
+	src = damon_new_ctx();
+	if (!src)
+		kunit_skip(test, "src alloc fail");
+	dst = damon_new_ctx();
+	if (!dst) {
+		damon_destroy_ctx(src);
+		kunit_skip(test, "dst alloc fail");
+	}
+	/* Only power of two min_region_sz is allowed. */
+	src->min_region_sz = 4096;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
+	src->min_region_sz = 4095;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), -EINVAL);
+	damon_destroy_ctx(src);
+	damon_destroy_ctx(dst);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1316,6 +1337,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_pageout),
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
+	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
-- 
2.47.3

