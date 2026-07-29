Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA1FC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A126B00AA; Wed, 29 Jul 2026 10:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43AF66B00D7; Wed, 29 Jul 2026 10:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379386B00D8; Wed, 29 Jul 2026 10:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 132916B00AA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:08:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95B6912059A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:08:19 +0000 (UTC)
X-FDA: 85041993918.12.A5AE7D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E7414140009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:08:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8ehlRJk;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785334098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Gg9s4OxjyZsWduv6+bFXiwNwPGMDtkx9gG9oVB8jE8=;
	b=tRyah2rovEmpeNll9oSqyDXEP1Zh9avqLmaAXCdoVfQyp27NgWysGfAb2Ig9mPt9jDSh0I
	WgRxtIF9BpMeZeYGLruljIPBv5kNqVpc/mvnsCAnNmEE8T6qtRaoUVNAQRkOfFY7LZ5CM3
	/oQzGjgncS+nxIXJ4nOcGEfWBGPOPqs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8ehlRJk;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785334098;
	b=t0Yf3mEAyE+YbLJQ9UBj29H6Y9HMyDUR1Dhz4yOcO4UUuH9tQ4sN0rT5LIEqAk+fBSXC54
	otsjSM3CjkfBVgO7dELo9P3DFR2RQFyfge5/3VSSmLbkE8X9sT9xEtFhUhsEcBx9Vp2EFd
	3UR9fEgjG8IsH2CHl71uVJrM0vBccJQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A4FF41993;
	Wed, 29 Jul 2026 14:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED701F000E9;
	Wed, 29 Jul 2026 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333786;
	bh=0Gg9s4OxjyZsWduv6+bFXiwNwPGMDtkx9gG9oVB8jE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8ehlRJkGaGCxduO/cD+MG3q9sMp7cELQn7vOUCBQLA+E+Q5kYiip86CnkBduoqgm
	 v3LRexWczG5gaCd4aWRUGgqgQAyTTOaYsd8ZDA7O/5hLyDZ4oxf7Hf/zMoPQB7b+xI
	 UXoHLjd0PWma9IKdF7RE95HzYhT3KmElp1hnLGRNhq8P0afYf5LS8KuIplbfmQsZ15
	 m2J3gyqjWgf4pdnL1MUKYcN2WA0huzxLoBC64WnINF8spXBygSvS3WE+IKHCiFJltC
	 EzIalHwHlww3aLGH6ijs/BmiVDdwaohjEbadZGjZRW1BdJ098PTFF1lucBG4eJcflb
	 OfCuHNYOHmFww==
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
Subject: [RFC PATCH v1.2 08/12] mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
Date: Wed, 29 Jul 2026 07:02:48 -0700
Message-ID: <20260729140253.87753-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7414140009
X-Rspam-User: 
X-Stat-Signature: ommi6fg1tj1k6tf6mbqgobr5ei5bhhjh
X-Rspamd-Server: rspam04
X-HE-Tag: 1785334097-809530
X-HE-Meta: U2FsdGVkX18oaol6z1nf988UKsXD9Vwq/kbsSF0gJZvcd1ghfPJZTeGZdtM/jXC0ufPVbuFy6rHyZLX0G+RKM9pDQSPfw/usupX5Nu4hj56HUdZidHrNKAVgsDh3ZupIyM9sD872qF9iUpUl1Yv+oi2PcIAPwCB039fN3zGltWa6T0aNtKRIEZmPyDWDlt2pIWjSnUduits+/SzqMj9KUNnNNiiGPFm/McH5BzlbKXJT34m2cguM8NitH97RN0eR8ji0jm/O5t+5vPC18mzGwmBIbjmzBHGgSZbgHHXagfGG6w3BNdTe9Wl5nhfSWg7lfKCWIhDJ5XVWeqq7i080ecxLfVRfBKt/Fvn1+KeS4ONn4eXhRrxjJWiHjtyBxP8EsVR3W1sv2hD/xGA7VKeW9aUGagU8lXYSFvV22workTD5FdDn59RaV5oxo/AS5WN4TsBC7H1fItLfj4/80Z6Js91NzrY3yBKCkYlj3iQ+xLiTjPV8qQPHILDP/NO0z14n4vPpkNp5AuORLb5SZo1aahRiqSQewuvZF+j2dY0gr0/zDuJlTouis4nqwehyogm5KWft/zN4Xq2hL1cCPmGdQvbQXH90+TKqZwcdajQHcVZPvyeOmHwlAOKUuTJ2T4l1bBA6N8gAXfKWUBIaL1ZGGUMIYbBe0P8FjPH+R7UKMeVn/UqAx5ck2x7eguXK8VUxR3l/uCANsjS3Nt6GoPkPv5ycJWgKHwZFd1x8tqI7sUOt38RnkKG+6g78Al4MSykSZ0nQ1gID3xmoq77V7xE1jApu9OoX53IYTO0WIiemsrg3iHnO2s3zNBIx6He8jxn9u+f4TK5GGoJgWF4ixiWMZRqMNYg5CpERqgLwfgoWatXn1eRH9R1EGOnxba6DcLjZ0Ni7Gw0+34gIt/gYrg6ByPv/4imS7ZaygSvmNMXU35cuZCfnqm0A0L6b9FcS7Fyohmw+qzzKBBVKnR+U/vt
 40N0CLKT
 U2Fpjzi71iVXv91a1zkJbJcT4rsAnbfdrrgz/kYBEyR7eBFPHQRYsRbBgrCHFUIWjCFwuSjB4wN/MCO+67VryQAEl+2vgbZxUKraPTpJDKDlEsLfCq159GJJh8NkYcSs6AFJhC4v+WsUCIOsKIuG92Hh8qWTCR2MBNnk5H+SryQp6ht9vWVmTJqAvS7X/3+lrzT9PqX62yI1HOVcS86eSnokMjZgp7GdBvxjMj3y9j0Baj5CxsgAThQ71f9iDmQYFfU1OtIaoDBHn7wmxtQoq/7ZKGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 954157679ec3 ("mm/damon/core: disallow overlapping input ranges
for damon_set_regions()") disallowed passing overlapping input ranges to
damon_set_regions().  Add a kunit test case for the overlapping input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ac15393a7935b..252d81c30d6f1 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -606,6 +606,17 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 42, .end = 21},
 			}, 1, 1,
 			(struct damon_addr_range[]){}, 0, -EINVAL);
+	/*
+	 * Regions resulting in same region after alignment should return
+	 * -EINVAL.
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 10, .end = 20},
+			{.start = 20, .end = 30},
+			}, 2, 4096,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

