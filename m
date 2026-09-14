Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B08C0C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D381F6B009D; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6FF6B00A0; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86D26B00A2; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87EAF6B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 132371C0B37
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:05 +0000 (UTC)
X-FDA: 85212577170.02.0EA33C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 75A26100006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jn2zEmzg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jn2zEmzg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395603;
	b=WNZCFI1ifqUfsrIhLjNy3f0aCNMaVE6GCVfvchERSAAIAHDqNnKrkg2trfrTzpUUnHoMZA
	Y+A80Wdmd+8q6EWybGfoaI1u/nPv6Om+5CQEqmNxkDSGdl4/1yuJbMRKeCmQHMNpW3T1rP
	2Z99arDMh/O8Cm3bA67WKHtbxzlAyrw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oi23zu2/PrV0Foc+v/urHYp6bcscQLI0NRalUKOBVW0=;
	b=d67WBL1+1q+5DISNqlUqg6ZDJvcTlJy3EiY7HWQ9RmynJHzr89j6mb1urwG+pGrB51bzke
	PoEW6n+CYkaUX40EjyWm7+gOER6ixIXHLzzcvkJQtNeVrENSfz+Vh3nF2OASzsvQxuSAtK
	tHp1mVwj1bSNIM8jSi22nYuiOyskYqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 068C160209;
	Mon, 14 Sep 2026 14:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D6A1F00893;
	Mon, 14 Sep 2026 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395602;
	bh=Oi23zu2/PrV0Foc+v/urHYp6bcscQLI0NRalUKOBVW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jn2zEmzg+8eiuhpnhyv9+INeK0b0PsfogpmddAwICz0n1DBUnFcadfFFpVffnaSJS
	 vsKsEiNKXkO/Kl4FgEFeZJFiBlEyx1S6WFKEfjJvy8gnXibdwTLeQU2W9bkshneTkc
	 XnnGaHWVx9bygDzCyMl+LfVoaw3/8ladZfooOKsSo7poW0P9Pqth+9uzTOMQCgwkf6
	 Ad6Qmj+4U6jMwKKl1xiZZCvg9G1nHsUbTZRmjczJg1FQxVNn/gaBOSWUYyl2QA6pjj
	 XO0tChvfTnDPewBNPesDi411NMzSx1kV7ahtGTSRvvqq6uLtRzw90zbOj22GOOeV+0
	 7Hz7jeFMr+Y0A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH 4/6] mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
Date: Mon, 14 Sep 2026 07:19:49 -0700
Message-ID: <20260914141952.91465-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914141952.91465-1-sj@kernel.org>
References: <20260914141952.91465-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 75A26100006
X-Stat-Signature: 6akye4ferjfs54wswnqb7xieoe5mc14u
X-Rspamd-Server: rspam01
X-HE-Tag: 1789395603-483461
X-HE-Meta: U2FsdGVkX19mV9Bk0I3G+nHwA+S0GTwY+ayvAPG//dDqVwBtwCmlgt1yJymjAz37t4fGjIgbg+K75nz1DOWnU2ntejnNKDXGANd7arK8U4z+vZAasHtcZDBfWgYVb+JycxGF+IC/bJEX0iPWIdyfjojM7WrvZqrrM3DBBNRzXf7QvduqTCegCAXKwHzwGgjHEzm/cd6/nZIRND2fgQUhcya76KRixqF/RdnPLkIZoqy1znSF2sNKot+YzdhIlTG6mf36tBPPcKLk7CTw5oMXQ7fbBUC/7PIrBmmb3aaEKPdTp0uTPEjeq5somNO4FYHfkS9obkMExFRcu8/eA2Pnlc4SldXODr4JfBEfvgdkYTN95I0080aX+5ETkiLTXBN+cLVv4DE9Bn2VhUs8oTg7wjWkPH/65H71FGYbxXQriMd5IfdJxFU2yYGGq684UzYQXJehQy6rz3dSpYdUnHAfgrkOE4MzgTO6AQlYF5pKKxdIPNnSiI2eaxcndCbvAl4fVODEqzyzPkovuQTbjqIF5DoVJlz3hXxSxw2oyL6hY+oQi7HP0vTzXp83dx90mgyQkt+/5NLUw00UqxBgSDb8nSysrf9f+FagodCwP+L/VE9PmEszm0VJfLJ/p4Dn1PTkfCJF1Mw9PbhlJsQ7ySAgvboTXnPbU250p72wFpw4jyp3IbXm5E3Oo68YFQr3cSZIiD0T7XpbSosgwxtqsS1w+yWJjVlzUuTHcijJn6N+THJymeo1XzSZ5Gx6i9S7XQ4ChDoH/rzsVSKodRRoRr2TQ1V7H//5xV2canRXtnLJZyN+V0t0j4qCrpyPQCHh/xesH8BHLrXxQ07U4kAQEAqMp26tb3+/Axlekly5OeEL8+vMZ4Zsv9fiNuIjU8qA6H8hIW8iYTvqySmS3EgyIhhrZBJnAMiHpbGf7TQ3+axYXXv8lIJ7/U26TfL+da3HSzx+FqQJZiPkkCSRGguV1pF
 Y4Vw087Q
 c2WMsqK4iMvo07HdyZkTFiEt3noB+urjAeh8vVsyMEScbMAWnk/468bpgEZvN4p3VSVUkF3kW2hQczo56kOs9EdfrCn9gtBgZPnPJQE3aHy0u72PeWrGwv1nbHpsaX0RsYczVmX4COKrk+yfrYclecG66TFi9F2PatykNwsivLIgzfBBrXJk3OZxj28nqt2iSTb72UmLUVTsdoRqmpBFZT4TnWQbHJ97gBlyy/5fJxSodeZO0AWG+8XgliUp0HCB6go4QYjm+xgU1IUCc0gMsTUse2S6A0Q4NvyRrSLDlzzKob+7csb95my2iQWq5qggwRGULMa3X3USVA6qakOjZMc0NWzuTOCm8gyb5t6BYAZmY1KfjOqJLux934Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

Test the zero sample interval case with a non-zero aggregation
interval, and keep the zero/zero case to cover the zero-result
fallback.

Also make the overflow case use an explicit sample interval so that
it does not depend on the zero sample interval fallback.

Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20260909070711.2448346-1-kunwu.chan@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.
Changes from v1
- v1: https://lore.kernel.org/damon/20260908063635.2208922-1-kunwu.chan@gmail.com/
- Use 0/0 for the zero-result case, consistent with damon_set_attrs().
- Update commit msg and add Reviewed-by tag.

 mm/damon/tests/core-kunit.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c01e6a75cadc1..a47a5cdf285c8 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -627,12 +627,20 @@ static void damon_test_set_regions(struct kunit *test)
 
 static void damon_test_nr_samples_per_aggr(struct kunit *test)
 {
-	struct damon_attrs attrs = {
+	struct damon_attrs attrs;
+
+	/* Zero sample interval is treated as one. */
+	attrs = (struct damon_attrs){
 		.sample_interval = 0,
-		.aggr_interval = 0,
+		.aggr_interval = 5000,
 	};
+	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 5000);
 
-	/* Zero aggregation interval doesn't cause division by zero */
+	/* Zero sample and aggregation intervals cover the zero-result fallback. */
+	attrs = (struct damon_attrs){
+		.sample_interval = 0,
+		.aggr_interval = 0,
+	};
 	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);
 
 	/*
@@ -640,7 +648,10 @@ static void damon_test_nr_samples_per_aggr(struct kunit *test)
 	 * overflow
 	 */
 	if (ULONG_MAX > UINT_MAX) {
-		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
+		attrs = (struct damon_attrs){
+			.sample_interval = 1,
+			.aggr_interval = (unsigned long)UINT_MAX + 1,
+		};
 		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
 				UINT_MAX);
 	}
-- 
2.47.3

