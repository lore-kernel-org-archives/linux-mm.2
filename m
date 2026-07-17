Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EAEC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1C86B00B1; Thu, 16 Jul 2026 20:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62866B00B2; Thu, 16 Jul 2026 20:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29C36B00B3; Thu, 16 Jul 2026 20:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77A626B00B1
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:30:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A5081C03D7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:37 +0000 (UTC)
X-FDA: 84996387714.09.6DBBD0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7123A10000A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fb0lKWnj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bm88riwVWukBM9Hpj1tl+kCGJPZuHznDRrppgwqi3X8=;
	b=f9yB6KxiuHg0gKRnVF6XQPziUt5KmsdkWhUEvFBOYr6//E8rINIjZSmOHEMHjZMoC30gwh
	7fi8bqtPP0HJgTY+r/d1W+Qle9VKU5UxqzOiBKzyMVydW3XYuZTJphcrVWwS6scIujPAtD
	Ub4Pe89bORKoAwFNGLIRwEsXrazwe8U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fb0lKWnj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248235;
	b=uIWRgyMww6PbfKVP/EuDg9JTrALs8NZOxjPqNc+W5hHsv+9WCzEbcnTjdYfQRd9SNAIruY
	wvE7Y0r6y2tU1TvWcJoeh/x9zb8SIO67uQGIPInynhicvkWRJXhmhuc1kpk9CVS8sw03TF
	owkLUPtTLZokfS1RM43GwAa25L3KZpE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B949B436CA;
	Fri, 17 Jul 2026 00:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486031F00A3D;
	Fri, 17 Jul 2026 00:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248234;
	bh=bm88riwVWukBM9Hpj1tl+kCGJPZuHznDRrppgwqi3X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fb0lKWnjC7Lhue4mwWOJ3RaPskTLAAMn9qqA+kBPqmElzRq20exd/6JHMh/NhsoS/
	 CGp0Mi9k6iFwW0p+TjGqvMaGUMl4Nkv33jeh8pZnlvQFAvPGZC8mlU3iMR3CluiwFv
	 fr6Sz/AMrTcxsGfQa4mXnC3/kkwIfoj2m1j+B1yq4+Y9Xw3/1uO1txgfxwHQZRzXXq
	 BbzzzmILhLFqz60w9/7H0IMjC800EajT13tq0ny+KqU5uOsJuIObjf3pZ8DtM9bbg5
	 ihYJl8mIYnssBcN+NL9A8ITLcAnsCReeYAfrR5YXQi1Axq6pdvA6JBe2rPoFFd4j6p
	 vJYWkATu5BJ6w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/7] mm/damon/core-kunit: skip wrong quota goal walk in commit_quota_goals()
Date: Thu, 16 Jul 2026 17:30:20 -0700
Message-ID: <20260717003022.119437-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717003022.119437-1-sj@kernel.org>
References: <20260717003022.119437-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7123A10000A
X-Stat-Signature: r7c59oswgp8836epxciocw78gchwy1rj
X-HE-Tag: 1784248235-443108
X-HE-Meta: U2FsdGVkX1+m51as3v5hzO52x1CQqG/pn+FPJ4rDltNSHBTuY6L2w2ng6UXtHHm7EV/Ww6IqeIUUJ/UuK1V6WaEjZTrYMokCDKMwre++lNq9wnjo0CJgTOaB2pacpL33KIlegUDShi+Qsedj2pjA3AK9Nw64ESwmVbE/1hNm8t0Bu4x5JaL6CSQWVCQG6QEVBPFJprImQeWGFLxu8k9z6wqZyhMVAE/CYZwEQK0FduLzNBv9gLNiXCXqdkd2dsfwpB/Pdt9FM9ySR7hy/96O0JFY06sSIlHrBRA7dBn9aRBG+kSKKqwD17DmbUOn95zn6j/ZRgdd5vEdTyLOIF8dzaITRAGaxzSHGQdKtZpzKcikSZA+AoUMweCJD3EgJHmmIKSwTGAOD33yGmHZjnNEDAtv4oBsnP915OI2Bp8x5O+5twVYRO/21zxeDAPG/o9wTpdUIVMMGLtq2Zy1bpZ5iGTjexYRwR4st6QPkis2//TOzrOCznCxoQkZcqWH59ZotQjOdydAKlvx12fGptZUNhBoORsMM1f/oKmh7HkBpTsMy2iCBMR5KMA11VrHiaJnIgTCFKS2O41hWsg06FiOEPWjsYU50fsSyfBGd8ChignwedDcPQnTw6ARs5EpwTjMIhwRjVC4btlMw4cZMOfhS0hv3rZJhfgaHqyzKTmiZvaKqOWjeXerfFsQ34VHg2U6H+TcnSDygwoVmm0nvRMc2M3VtkjNpPTIEXFk4EE6vVfcoppCP67F+yJXQXRIerCQsQTPWGKbKcN0XLFU23cIOvPyp936U178qV03rr2YmGPyF0iWjctKSyz7mW+WNakk0HzfYLuoMLAo7OnbcgZM6uLHQzOc5gJi5/SXGd3ob5z5CtVKHQXdha4CRR1zthXDHhmOk3m1x2e4GvO7NcN0KOdTZh5s4BeotZG0NhOmyFLNisdRjbIXAoOI+NVFAoBkKTSCw+1remtG9TeLsZh
 g9AjATWs
 SckmtdLV50PRaeaIh+jbqwfKgb5Kv64hEvvtFkUZdBrR9pUrlR48SgHq8Ea1CqsEsO9NXEkKy+WcW/SxvM/EKnMIRxSw8Na7XxqxKps8mpuc7MgL0Lw4/UnnIRaGeYrXaxb02651eE6MnZVJxV7eEACF1RblQ16QU8BC27XFEic7iS4nNF/onTrxJVfgvtuPJagmbVYambjj3eHzCtIXXqe3ykHu8rZxoLHe/bkceXU4Ku3TZ0YQUMOG8QUa6dBQreG2V2ME4i/Jb0Nq5Unb6OYl/DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_test_commit_quota_goals_for() traverses damos quota goals after
damos_commit_quota_goals() call.  It assumes damos_commit_quota_goals()
made expected numbers of goals.  It might not.  Because the traversal is
made based on destination struct length, it could do out of bounds
access for source expectation value array.

The consequent user impact (out-of-bound access ) is quite bad.  The
realistic user impact would be limited though.  It would affect only
test run setups.

Fix it by testing if the number of goals was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org

Fixes: d9adfb8a28e7 ("mm/damon/tests/core-kunit: add damos_commit_quota_goals() test")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ca6ac12a15b24..c0fc903a6a259 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -839,6 +839,7 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
 	struct damos_quota_goal *goal, *next;
 	bool skip = true;
 	int i;
+	int nr_dst = 0, nr_src = 0;
 
 	INIT_LIST_HEAD(&dst.goals);
 	INIT_LIST_HEAD(&src.goals);
@@ -861,6 +862,14 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
 
 	damos_commit_quota_goals(&dst, &src);
 
+	damos_for_each_quota_goal(goal, &dst)
+		nr_dst++;
+	damos_for_each_quota_goal(goal, &src)
+		nr_src++;
+	KUNIT_EXPECT_EQ(test, nr_dst, nr_src);
+	if (nr_dst != nr_src)
+		goto out;
+
 	i = 0;
 	damos_for_each_quota_goal(goal, (&dst)) {
 		KUNIT_EXPECT_EQ(test, goal->metric, src_goals[i].metric);
-- 
2.47.3

