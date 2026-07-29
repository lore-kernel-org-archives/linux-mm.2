Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71178C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55E66B0110; Wed, 29 Jul 2026 10:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5736B0112; Wed, 29 Jul 2026 10:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE06D6B0111; Wed, 29 Jul 2026 10:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF4D6B010F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 282D41606EF
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:46 +0000 (UTC)
X-FDA: 85042093332.17.DCFF04D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 97298C000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h73bFV9X;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVDCDmM/5oMd0S9q4mDsaOvqgsm4wlgdEROJ+WP1mCk=;
	b=2IUv+aGs1KMqxpNmiurZWU8/C/hfwdLmb385t2pY6nMKqXHTma2A6upsnUtD092hOfmUe8
	TEFZfDGyt/XqporEHzISrAN/pbr503BTW+1Nbbk8ksi7tZ+M/aVw5OwNefXHFDIXuWYKoX
	J+f7tkrwMx/036n/1kAPmX8DmDAFJKM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336464;
	b=vhfGvFzQjoZ+DIZ4wIIDaSivyrTiyapjyhbeikEPQxKnlGhhknLDs2srkPHE5075WyqVxM
	Uo29wwm2Jc1pP62txXkwRDxXzz9mXVTZuv7ty/YcQVaETHwH4+vThEU30dk8/FRYx/cAq4
	M48HNSvgG5UUYpby/pvVkM1oB+umGOc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h73bFV9X;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74EE342D66;
	Wed, 29 Jul 2026 14:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160181F00AC4;
	Wed, 29 Jul 2026 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336463;
	bh=cVDCDmM/5oMd0S9q4mDsaOvqgsm4wlgdEROJ+WP1mCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h73bFV9XXRa3rYOjLrc21PccfLGzZcUBzEX1CZuw+YuyQ0xWnKof5wRTUjM43vDp4
	 N/ZLjeop0UV/IKchgAkeWPTMsWWHEKTjq/in08DKOSohkjXgCny8wsB0j0tywnHuG9
	 Qb3eUWM6aF3H+J2gGN2QfX7jOWDSyx/ax6tLYNx2RcV+PpNKUsn2EbhQsHhPR0coD2
	 YkTQx80CES31BgAW1lfdn8s77xGQCn/gFo/VTByC29CvKJfeoHMuk0qNBjIFkqPpzq
	 6hnAQ3EuEyYvvfnfM/PI/HCxaWAWFTpHXDjbesfeDQHDBZ0Wf9itBmt5fNyQfjmoCA
	 TLlCdLA+Qs4Vg==
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
Subject: [RFC PATCH 1/6] mm/damon/tests/core-kunit: test damon_commit_filter()
Date: Wed, 29 Jul 2026 07:47:32 -0700
Message-ID: <20260729144738.90895-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729144738.90895-1-sj@kernel.org>
References: <20260729144738.90895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 97298C000B
X-Stat-Signature: ez7ijw3555rjzff9dxnb3wbun7hota5q
X-Rspam-User: 
X-HE-Tag: 1785336464-735416
X-HE-Meta: U2FsdGVkX19Yxy6fyiq7o4wxivf9EYnvDGhKqnpqPBmVFRxlf+nzVcMGBLxB3fmwG3fXCFQhlXsBRi8gQwkfKNoIlJnTh/ssFxyav5OllDP9jAl3mxxlS7bVR/FyW2ZZkLJRBPoY93MnsfzVa6AbJAxbkbVAKcxmA7Z6eM8kE2CMNOYuAnwX91VZDWj/Ip6xmlyIQ0F1I8qJ9zOitr1kt6giw+L6CqARPZDBDodFZ7SirqRt2uILduIK3/lCcq/fDeXIlIVJrHJtMaYgVk/AZjuaQklIlMZwItGJSCdPQ2P7AgtFw7cbToR68itcREQLNZb4FpqaTzlXR7iz08DwGek6tqYrqMDGrglIQQo7Zh4uWIiVTIh1WbYYBuwN1aeEYUFRqPfDjKNYuIsTfsLTnuJjaP29uPQO2H7KBth1cmNu18JoNJVrwqIlCE1k62yEMdZyP3/NFstIYiBdEBsX+OZhwEbltEIgXaBlLf3HcUZ9ti5rQH8cQZ4cd0FD1hih7zdvu1dIAulbHFz3r1TBbHIZzOkWhmU65jEuHGBZMsG0LSssyPDeYAV5m5YmSXcPM3JGi13cGhdh93sGLQV6CZ9ZbrxcfBoVwIejKOlNMQz5Nw3/8G66nCxGAmMyPkwvrQ0Nh2FCZvbQkEV/RANZz0WojfciPihZjF3JMGGQvz6MJrwaLcjDjY/hgMJMEW2j8cyhq3g+yFmtRohYM52rkPAMmMcI26Xoch5iVDhqYL5esfUaeGJq9bZZOA26Q2ZdCaNdmMgI3wR+JxfuKGEDw9aoj92T824FSMnhPuwjwgOcBgl1FMdKNuzDX6JTtWslBDV23JMd9Ma4nefeLe3hzXuHpF1+tM8hqhqfN+AygBsUvrwXrMk2u3cv7Tq4HFT7UW9GzPYFnP6gqu1lM3IbFa4YTieMs8qxh7Rlbx4xWE03kk8uEs9et9d5RtabafdJIh2wD+PBzHErzwH1fdX
 g77mqobt
 J4UkGJH+GM9ULUWMDOfjrCsjNcDFLEAZ1mhzvxUL5uYSI19vjw51xoEdqqgblFsgbKt7G5PLpBa4+/+usyje5pXaety774c4QwcWTpXeaRR6hSoHe3o85XnEYso6Ht7cocxVhoe1Qra/RSxqQsS2BGxq4LhFj1B0/TZMXaKa7WRJKB7rpH/OtCjqb2ySSMKQ9seUB1PdkZgtvwNVPOrcUcIBdB2vt/tegYv0bcckInWobPXJlYzNQvw/b4q1J54EsS5lgAmBokZfyGogHE7n3/rgHmw==
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
index c7bda8aadef3f..ff864402e9c75 100644
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
+	case DAMOS_FILTER_TYPE_MEMCG:
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

