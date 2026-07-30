Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16363C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7606B0092; Thu, 30 Jul 2026 00:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78286B0093; Thu, 30 Jul 2026 00:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB4266B0095; Thu, 30 Jul 2026 00:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B62446B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:39:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4DC14A0824
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:56 +0000 (UTC)
X-FDA: 85044190392.26.0B03CD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B9F1EC0002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=chXFHu8h;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785386394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgF7GK3Jltsm6GWffUatiq/f36fmtD3Cz4bexms/my0=;
	b=ZTQDKYqBV+Otb6aIH42Bq5UZR9CYgknDsLvh5FTwAkLbBoY5GCDoZKnwlEaSNielmK/ksV
	ZF0ZBuyV63RVhaiFIDJA49d9sjhQ+SwmN10TWxkZxYzTKoJ2AccB0M9l734BxuYza4zfq/
	rnTWkIK4dxILWt6a2WGaytr5my5rgPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785386394;
	b=HgKmDMessCzYQWG9M9wpkPfeZLk0r8tUxaTCe+6AaTLggQ0FyQGtgPCjsbYfrghb4sGHXw
	G6IlAYZHcUO71B85x7C8RTS14RNC2E4G5ezqgaeAjGeWsqNF2opMHqsnppP30ltmbqIAi2
	YT1P8lVMEzf5SBx1wFPqs1bSSEGrbn0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=chXFHu8h;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4410E600B0;
	Thu, 30 Jul 2026 04:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1B11F00A3A;
	Thu, 30 Jul 2026 04:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785386394;
	bh=VgF7GK3Jltsm6GWffUatiq/f36fmtD3Cz4bexms/my0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chXFHu8hPjQ9jdA7ezdPxqzspnU1pN3OwNYtg+0WYD0rYw7UCk73cSKTiX0l6D+R7
	 d3XGcy5sjyyHGGFNPoVeNCH+M6RWzAbcd05q7xQqdHB9kMzEyVyJoXqtB+C8Wf3/Bt
	 4fM2/c10JXUPG4AdVyxUYZXzmxyDOXT6ptegxPK0MevAN38V43ZP0/rIJGLV7XmQ0x
	 aC846XVbL+YlZJ2xOBd0ouha/FcYmWXFnVwRFxHIwjE07Xo2MGON3HZsIRJM2x6zon
	 uCtdpUtazBMf5ZsnqA4J2BB0cgwRYv0gPdJw6wKJVYj369mRxuBAyEK5E/z996lNXD
	 zLrplCJ9R7RUw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/6] mm/damon/tests/core-kunit: test damon_commit_filter()
Date: Wed, 29 Jul 2026 21:39:38 -0700
Message-ID: <20260730043944.146030-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730043944.146030-1-sj@kernel.org>
References: <20260730043944.146030-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B9F1EC0002
X-Stat-Signature: s736wp4tfia8q588gjoaqk9hyrdfdsbq
X-HE-Tag: 1785386394-323950
X-HE-Meta: U2FsdGVkX193AqGqoH1iu1hw1UoYYlvmj0sU9Apt0Paxo2xCqoR+iz8NHngCOxdG3Ic+032Gorgi4E2aL2k3S8P44QmpHAymOSpvlUvLOXSFFr1gbJyyhouY+NdAoUu5EqJgINAqCp//bMlQsaWscXdF1WEUhCj12eXLLry5j8zrYZwBpZnWpwojHThLD1C6wBJua8eFW9poJ+w0sGGw0orriZL9JQmwHLGMkebOIjHCeOqChKgGDTspe1jYn/e1ZpMn1oqr/KDCYz8xJVuC3b9Rv1/KwOKtn0OwH3qmN1O4145o6vLRyzZ37GPCeYyU8hWyb3PIKTRcktYGgpMjQF0GUL+JemYAbwM3CZLl+DP9MdOiTC5rY+AXk4vltmlETIiZi57OlJZc9plT7F5njwfNYhkaRBo6NpVENDRFrazXEAq0acPAL4EaEKQXQ7cCDz+NYPJUTwmZiqkupFrMwnCPpAKX/nL3kmVbpEyQOaWy7Cf4/EqYTHKMRMTahmPElxwaIYLxo1TZGGhlMm+P5J9WdJO9qEd6FdhdIi2WieLDgdnxBReljrYInnZzC7QelgCMZZoL9xNDd4zYidgjJduJAP0JedfWePOmiuSq6mfWymmQcJxtQ+MuzuWZ9EcGDMKq6EvdwS88BJ8k9om1xAEJbVtUtr9w+nM9d4WrFSN58+wz4tLmXcvy30MoUEAlUXJGwqhJSUWcTWlHVX93n+WwrEGXFty1QEH18WAYwMVM402ckLr3ubwkCauOurFklCYSv1fW2JOLeXkr3GPB2qonIQ0J1rp7VBpRIeArjsGF16Gq0qkF5TUDgOPgxxk7VBC/FinV1Cw8OaAdIkKfopVsNCIzTuGMDEbrFl+vrqJJZyZJ0xUXaDC9CY1ZrJ4jWfPRXAJTjgk8KvdekH5JwiFSK1+rIfsRihgkbpaMWT8kJvZo1+iQ1+IZ86xnrv1wAodzd41JlHeNwlKNlkm
 VWc7LakH
 tJDC++JeZMVUSRTrtS+Yj15ZPsHU8VykGP3upu4u/wnk3ipobIqAnWZ2TV0LM1EHr3ftJO0/oVC3q73HxX5pZvW/ou1AvvDskhHTLVsLd3BxZg0fEURl3r32XAFEE0+oni+eIfuR9FTg/A9k3YNbcGD1ZsL4vqWTgTIHa16gdtyb6QYzitkqKV4fOZW4E7P81rMPMljY17JcQOv6lKyJzoRiAl7s+KPhpQUv+R4qTFz3qdBk/xKaHKjgJXampGgrfmin55ygBcCQIlFyXjkhXTc5tNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kunit test to ensure damon_commit_filter() updates destination
filter as expected for valid inputs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 40 +++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c7bda8aadef3f..9cd2be03aeb9b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1354,6 +1354,45 @@ static void damon_test_commit_target_regions(struct kunit *test)
 			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
 }
 
+static void damon_test_commit_filter_for(struct kunit *test,
+		struct damon_filter *dst, struct damon_filter *src)
+{
+	damon_commit_filter(dst, src);
+	KUNIT_EXPECT_EQ(test, dst->type, src->type);
+	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
+	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
+	switch (src->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
+		break;
+	default:
+		break;
+	}
+}
+
+static void damon_test_commit_filter(struct kunit *test)
+{
+	struct damon_filter dst = {
+		.type = DAMON_FILTER_TYPE_ANON,
+		.matching = false,
+		.allow = false,
+	};
+
+	damon_test_commit_filter_for(test, &dst,
+			&(struct damon_filter){
+			.type = DAMON_FILTER_TYPE_ANON,
+			.matching = true,
+			.allow = true,
+			});
+	damon_test_commit_filter_for(test, &dst,
+			&(struct damon_filter){
+			.type = DAMON_FILTER_TYPE_MEMCG,
+			.matching = false,
+			.allow = false,
+			.memcg_id = 123,
+			});
+}
+
 static void damon_test_commit_ctx(struct kunit *test)
 {
 	struct damon_ctx *src, *dst;
@@ -1705,6 +1744,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_pageout),
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
+	KUNIT_CASE(damon_test_commit_filter),
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
-- 
2.47.3

