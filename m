Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE09C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54AB06B00C1; Wed, 29 Jul 2026 10:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F7B6B00C3; Wed, 29 Jul 2026 10:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2446B00C4; Wed, 29 Jul 2026 10:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA1876B00C1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8101C1C0F59
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:08 +0000 (UTC)
X-FDA: 85041980856.09.B9D9C0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DE5788001B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3SJ02dr;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOFGYop7G5CT0IvbShe/iVSTs0keWEcjAd/ooP0VIE4=;
	b=Y2IxfcheNKAxLoSVfRMhEqO0TKdamPBHLroLtCL2326P0bbxsjh/zjNBxJU63HkVyXOg73
	a+l5Z4f5uIW4FM9wJe028owaUlUl1KBVjDeyz0LCMiA1c5TKQLrxtMXcDeyjYHzacpw2tH
	+ngsDXbeqGeL1FVtHJojX20sCu8s7qs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333786;
	b=7eWI96YBJpefcBr7w6Y1+0agOnIRekJiVETdXvo+ex7CsQhk0Mluo2vSXWkVRqK8ORwBrf
	lStbjOSv0KgTRih7FHf7WHgiPR6ZrWEkPX8MRsAifdheB3Lnhpu466eedzJ7FphVJSnIcX
	aQJ73q8SG3zj8kxwwt5B7rsEadn/MNA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3SJ02dr;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3A1E4195A;
	Wed, 29 Jul 2026 14:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8214D1F00A3A;
	Wed, 29 Jul 2026 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333785;
	bh=SOFGYop7G5CT0IvbShe/iVSTs0keWEcjAd/ooP0VIE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3SJ02droipthfU1VEMG1xJ84auTvUbx2K3kVN1erJ3EjWV42hpmN6ojM0ZLjJ708
	 Y40xwMtAkHekYBB9J/MBmW8Jfw3nAuSmatvTs5eVTraWv5PkN/vaFyXu3+RhRanz81
	 Gmfv8gMIZbSSEA1AoLENDMJqj+Hf5fFxHn0AcDuHVjOw02QRXJ5UCT4dMnFI9cKSzr
	 vB9vVYMxfVTwi7K/rEyo2UuGwac4ps6SNXGsoZlvKEdEJC2Qyohapy1Ut6jfET+saN
	 untQQD9KtqlRZBw9Ah4bDmKhdNZ21LcM4ZiADWA4twN30jGzMkWvnpvLguQEJhKRRJ
	 XUZ9Ub1m9OdEg==
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
Subject: [RFC PATCH v1.2 07/12] mm/damon/tests/core-kunit: test <=0 size damon_set_regions() inputs
Date: Wed, 29 Jul 2026 07:02:47 -0700
Message-ID: <20260729140253.87753-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DE5788001B
X-Stat-Signature: ds3f63c1zghaxzts99ktn8tbwgz8obtz
X-HE-Tag: 1785333786-691872
X-HE-Meta: U2FsdGVkX19VrICDifFO5sYKDA8IVkTjRn+hnWWV5Fe/PE1eVGABZqPp6yN3xej4FEhoflhXREeYTFKobNafvNnPG71ahMMvOzdcRpPMVqZ+oJ6yHmPHL8ngklth7rZ6Hp7aXLI+zFDrrFENreH6qy2M6hOpDUpr09Eym8TC+LfwY/Tze0oDQ78kqWyJJqRd8tnorKZkPX9xVA0dNTAY6bfySHA4kaloIdRFI0XXl4qW3AehjITZtcHQeEcZhgdrx2Hrd78pvF/xgrVbtELAugnmm8Sk6xtiNUn6BeeUL3JlxSUuICXeMyfcZ8u3QyQyr8uZ2MbEJ/RM6DXQCjpWKohkt6yqN6c3JJjpBZDrbinDiRoxHMrkDz2WA4ut/qQbfmZrKKla1PJ8wj87cX92tyzrc7tRVveiKWPdT3oKF10Jzs/bkPfGeY4HZGSmwIaD1Ml9TvgBLP4ZQGo+37EZnKlj6rgkbaVLpkfHDaAIIZCjMSFseD6p+FpSa9NPY/U9Wez1BHDlTE9h64wVWOXg44wboM0L7Je7nfB1zweO8ovHt7amOBWGJFtTnNJneU868bRmtaLyJGcdJ43tCM0EXm62iwYE//PR0pv91i+F9mdy0W6XYi2i8NPhODtAS0XK+X8PvTk1/NOvEhTWtgkADEbBZ3xV4t6E4sVNxZXFDs5mJ+u4rUNpNsLMtGj+KWH4OKT73802peITm/z+Sgme7K3DIHe4M9A/kPVEoKENGA/2bgUh8S+yFeZXyMeOY0FnLCT+aiA1Grus0/hqXwNb2zEs0vXhX+HAFFqF8hODACOo/yDFf7X9/xb39MRubNRTjg4FNCdlI550UsY+XFPdIOMZEghirAqKuB8HCb8Axt4r/EvCNgsU1p/CJr+UCrBV4MkQJGUOjUuosJGhp1liHoQzBsG58+RPaylYjAmU29qOCysxx6fS8W2AGUhZYiz2L4ZNWfrvWu192Obw0zT
 W0zQUzL+
 j4YMevTAOB+teGxu9PoDM7+rDjYeXNpdqxfOXoTXBOt8iPkuOKOkM+qvXR8zcu6zEIMiLdQh0AlV7zm502La2+e8SmV2CLXtos6ixEsRIcMdH+X18HMPbHKeCaibIZ4MjmbIxnM2+jaH3jR/t57PhcXcvpRXjF0OQdmIUelNb5JXzuHpf36FkU2yzZnGJM65zl5UqYi4UpihbO3+gLJ1RIxsL6ef9wxkQ6h2a9yuzYnCF/qn7GeZt3aYB23ieab99gTfOky2E8r6mHF8/jc7tU309kxig6k67dmdy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1292c0ecb1ca ("mm/damon/core: validate ranges in
damon_set_regions()") disallowed passing zero or negative size input
ranges to damon_set_regions().  Add kunit test cases for those inputs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index befc1196d6d60..ac15393a7935b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -592,6 +592,20 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 25, .end = 40},
 			{.start = 44, .end = 50},
 			}, 3, 0);
+	/* Zero size regions should return -EINVAL. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 42, .end = 42},
+			}, 1, 1,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
+	/* Negative size regions should return -EINVAL. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 42, .end = 21},
+			}, 1, 1,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

