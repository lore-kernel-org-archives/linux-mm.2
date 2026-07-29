Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA010C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326D26B00C5; Wed, 29 Jul 2026 10:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1996B00C8; Wed, 29 Jul 2026 10:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088936B00C7; Wed, 29 Jul 2026 10:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4A466B00C5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60529A05E9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:10 +0000 (UTC)
X-FDA: 85041980940.19.E660A43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 93BF1100014
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+RiQEj1;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7L5cUB5gmn/G0XCH5EnzRVEYnRmQ6289QitHVcV3Es=;
	b=SUrAQkoYygtHn5Z+o5Edv9XoDxzuQDyFbpwsCanRRTRDf8inOLAjlRE83fGuEZn63arOx5
	jUU9Z6+O0CxePNnxIb0uMxprLj5uDORXx5DX67/kQh8caYda+7uwpNXOT9/0umJUdk4d6D
	i6aWiKBmrUycWY4Z8iL/CKjnfvPZcm8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333788;
	b=7QMFA95g93ezXzZrudD+tSzEqqIi7712nYbfTl2i4r3LoHI3z7KaB+ddGU+j0HEG558oXW
	ruXBKhfqq6+y8EAAeEahJ0JEXw/ewJconxkHe/XwM//vTbG+h0ERcCp/ac3z0XVS8RNllT
	0V7/BaeGKoronQL05oathdpA3Nnu0Cg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+RiQEj1;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC11544F9A;
	Wed, 29 Jul 2026 14:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D981F00AC4;
	Wed, 29 Jul 2026 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333787;
	bh=+7L5cUB5gmn/G0XCH5EnzRVEYnRmQ6289QitHVcV3Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+RiQEj1BII59zxArhj3mnt9JNjHlppSgQFrZumsStiGxqJod+wqnzEz969A1Fe5L
	 qH24I170RLkeEifJvonk0wRwGd0+Qhyu1+9ZpKDIks5ey5OBHid2KgZjaK38OJ5LlD
	 QhgCmSgzcNk7iM1zu/gpBxUbDHly7oTZsKE9QDWHCwXlRGoxCc1Ms0UwctAo5EQqv+
	 b6O1QVrYLHtbNZgMyGG2tXCb8ihNVltJ9n+pLWgE2j2Lun26JIpmVi+d2U2c/0nWGS
	 4yWuRV0JC+3WM9DsgTAuLvngx+Ja10zUCb+01ri7LvDXxmSD2rWXz9kiBIvhH06ye/
	 ZhMuEvLUzzJog==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 11/12] Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
Date: Wed, 29 Jul 2026 07:02:51 -0700
Message-ID: <20260729140253.87753-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 93BF1100014
X-Stat-Signature: c1efyiaxj4kt4bxhf7kk4ofeo4z13zyf
X-Rspam-User: 
X-HE-Tag: 1785333788-972610
X-HE-Meta: U2FsdGVkX1/29KjxMrc1QfqQIuRrW+LkpvJrJwam7cdAVcHdIAa0ppe/BXtaH0xv/oMPtwBuEA4Z3zq9OQb0Pbmmq3ech6lh134L7t3uPY4pPEKW/wTGRVJWLRehfYs5e5JCwvO2c7yT47bAij85op2Jvb8/KzND403u2A6lGHaLx37T4Kxju6iE6ggULdYdVvUklnOEz6kAXPfuYmwTfYoRnMdN7/NMVrFwtExTtsdCb6EslxRx+lEUw2H3jiv9NoaSxScTmCZ9aJFeRF5rwXL1+a5fSvu9Bd8ZZCt1P3NvldtA/tkiAKJDDNslMF2feKd7HYCH7qC2zYNsjKjc6UoXS0MO4sxy9qc/aUFddSyDwks5mosuVeShscpEVpbOATVV0RZCsL/TGeN89tlKdEIhwXVfoygIjuYm37RBDj/il+i+0EeJ8yy5b/bjIcZTK7q5c2RMkuNq9e5nbddEyK5WmxOL9YEP52fccvC4Y75mqH0TGEVQEImZ0c6prPnROskK23nfMUNaid9KS4HiBSSLmpUvE4ZKg8SShWKGS97V8bbA1V4rBjKGxbiJuR54CZFhm0EeUreApYtCe7DgtcVH2NBnIEzeO+ZJJq4juFyN/hctacfOhy6KWO04n3fnIs2tIDTp+R8eMo7ltZklRNLQj90T2TofKmb5Z6Cibphv4w52JYQmLirPUwYNokaxpeHEIg3UAUu5zcwdWxNsnv69cX9JKXc0RETGSP+gigjb2Coh0udzokiEOAKhEsdBSywYrJ6V1Azw2q/tf3/gm7yb6icMPP193Jbpz1bYIzgqkOMGrIxN/L37nMp8UAWuOsrGI47iyhbUghGEOC5sUtGFTn+58HotCI3tbUwJ1OIt791/oHwfiJ0jPUKauoCuqd1RKY6kglx8vxGU7Rp57u6UNaFUU3RntnqKHheA2Qu9CrXnXFwVitNbLEVz0EKkgLyRsLfjWcOxksZr6I4
 +Z86GaOC
 XXJ11hlMtGaVOB5TthbRkJx3muhYMfk24tbyy0KUNFjbpc/60FpOBlvWez39xdfENuwDd2KRK3Diwk5+aynQIpEqmiCOB+1KJuIoGhQ6l3VMqAIbu2NVVZ64uHc4QHM8e/4JpBV7s+x6/k4ugnI31kSy79VUzobSUIxCT3TKmgoQ9NC+rGdHeUUShAGJxczL/+Ow+ElAZLl1qKMbHWS707gfc/b1uFn7RZchVjWjPGVA2uKYSEWN77yaNup8cRkmxEDzN/G5sulyDG3ci75ukeolSvKn84JcwG/oyWm8+edQjU9BOH3Nvd0nxI50ZxqDtf5iW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, sharing Sashiko review results was tedious.  Also it was
suggested to minimize the recipients on the sharing mails.  Hence the AI
review section of DAMON maintainer profile document was updated to give
guidance about available tools for making the sharing easier, and how
the recipients list should be managed.

Now DAMON is onboarded [1] to Sashiko's automatic review replies
feature.  Sashiko directly sends its reviews as replies to the patch
mail thread. It also reduces the recipients list to deliver the
reporting to only the author and the mailing list.

Remove the old guidance that is no more necessary but only confusing.

[1] https://github.com/sashiko-dev/sashiko/commit/b554c7b6e733

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index fb2fa00cc9aa1..a7c1352339378 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -106,18 +106,9 @@ AI Review
 
 For patches that are publicly posted to DAMON mailing list
 (damon@lists.linux.dev), AI reviews of the patches will be available at
-sashiko.dev.  The reviews could also be sent as mails to the author of the
-patch.
-
-Patch authors are encouraged to check the AI reviews and share their opinions.
-The sharing could be done as a reply to the mail thread.  Consider reducing the
-recipients list for such sharing, since some people are not really interested
-in AI reviews.  As a rule of thumb, drop stable@vger.kernel.org and individuals
-except DAMON maintainer.
-
-`hkml` also provides a `feature
-<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
-for such sharing.  Please feel free to use the feature.
+sashiko.dev.  The reviews will also be sent as replies to the author of the
+patch and the mailing list.
 
-It is only an optional recommendation.  DAMON maintainer could also ask any
-question about the AI reviews, though.
+Patch authors are encouraged to check the AI reviews and share their opinions
+by replying on the mail thread.  It is only an optional recommendation.  DAMON
+maintainer could also ask any question about the AI reviews, though.
-- 
2.47.3

