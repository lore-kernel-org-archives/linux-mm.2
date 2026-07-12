Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C721DC44501
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 17:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB046B008C; Sun, 12 Jul 2026 13:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1821F6B0092; Sun, 12 Jul 2026 13:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C07B6B0093; Sun, 12 Jul 2026 13:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D78496B0092
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:03:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F1F91C92DD
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:41 +0000 (UTC)
X-FDA: 84980746242.10.80D9894
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DB94980004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GX/i+5+c";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783875819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFIQucAr4vFmOrW82XY64T561EcF6nkSnWV7DSiSLJg=;
	b=zLegMdUAdcs45aokipEaS0UBETMslESxYK/fl7cu+dEM72IJoyJZrPlhmX0CwLWfhaCNbZ
	3iiifb6IPTsfCXc4CI7EMSbIBL6UNEnqu5vKA4d1BXLFukbR8bCqCh3bzRobHV44oJilX9
	8cfy2iou31noQ2XDiiB21v9uHdg8Jws=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GX/i+5+c";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783875819;
	b=QKgTPx++8L4dEsF1uq3zNYv+UQnuykrcnWriKCTPkhpATxxXwyTdkcNSduYRpADatT2am2
	857aeFxaIJmvxCrzEJGexmOZlpLxxSBWJL9MsDlZ53E1HrmsJOJ8scRGC9dGLahkkjcClY
	f2pYQMnPicFUCQskhR2IfipB/jIp4VI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 731A4600AA;
	Sun, 12 Jul 2026 17:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E4E1F00A3D;
	Sun, 12 Jul 2026 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783875819;
	bh=yFIQucAr4vFmOrW82XY64T561EcF6nkSnWV7DSiSLJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GX/i+5+coUrveNcvaY0xrsZhuVmtLA73CcoyMgGHIOeUe/2ZqEWjBRanPSO0/jWo3
	 hZXs98sRQ5y6Z/l7LJLzomKm6ll1TUyBUHzWgkM7q14s2RJ6TOP8Q4EBEL8cb44sya
	 5oDv87oF7WZfwYblAmUApiym4/OeEpy2nrZwVTmJz97NhAF2m7f3AoEvMRKJf87btW
	 APaptSK4lju2hZNVR2ZfI55SEZ+I7PAGQa4GUS0kiEAifPyUG0gfYefAUsPXNuG5S+
	 bwIjD6aaNbxBciAczMQ3Uz2wEIn01AmfPXvPT21LRmBoXnc/2Tkv530H41GKV3lo2n
	 FdNYfWLdVvtbg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/5] mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
Date: Sun, 12 Jul 2026 10:03:23 -0700
Message-ID: <20260712170328.91144-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260712170328.91144-1-sj@kernel.org>
References: <20260712170328.91144-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uhpnnotshxe56r57zob8sskhbo4y9xa5
X-Rspamd-Queue-Id: DB94980004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783875819-841942
X-HE-Meta: U2FsdGVkX1/bNzmDiEa59306Dr3+jZqHeeeZ+ikHve82bW0YiECMq7Fs6VgjTQ78OeaHA02vgwCk+oLdnbzSywJc/CI3B4ORliLqyl1i4Dv6yEVQvdJJDuEagi3Jnt2d2jsPVQx8MxegVyH4eA65WsvDNyMe7qT9ZJpUd+4GYNHPYaOSCalX+asQnKFBeqJUorezfwRqIg7uJqw46taUUppb+MWagh8eVG1HA5EENfuDtipxEMH28AvcO+l02wnURiZd4Ak8uCkfuylnV7X+3ZFQALiWC+/9HpOdCzSsMnvSUtKU6CvEAHxva+clmBZGxDCTMhNAHd7ZS+UltVfXBHbKDO/Dmpy0Zua7GkWfL6G2BcIrNduoy7AXG/xIjQ7cdoM+JPsRt+nh8yJ0D0sJdsLL5z4Smz0ppp8l0hFu6RZ7vbn6NB0W0qAOtb+CGLvoIY8EQhhmlNPXR5PI2FE3sgLrK722mCFZGJRmA6poDqPo5+lN/YlRQoidNcU1gcIJ2kxpbSidU4gzvAIxn75Hcu5IewsYKjY7jwZsdh8ff3GgZWn4eQtGsthAqeduULCUEtr4OWaLKjUwO3QqpV/2Qlwl3LwdAnPU7LYZWoRUQjHQRUJVY4VtPSFIwX5YaMhAstZi1CdiOSka4Ht1I3rEyn91P+aKzcUScWFM9uoeMpyzqhfeNiZWThl3fanfep5Zb58ysp/5QZUM9rxbOO3y6y6oe+OGmdEMFupgzxSx4xQsbAztbFzdiHYyeD1xP3Mnb/wYIv0CvN8jeJC5CBUM8bsZamV6zLEz/NFj7uRILnzoEIJOEfRBJbNMoQ0ZyABB0zgNhlYAb6e+MiDsk07Pqf7G5IRV1v3SEb3GGU+JOJwGLSQtMQs3bskiZKyrFaC14FghgHVan3Qsr2MufXf2xuo1JhvztsxTt+vpTt3RriCuqDaweD5kLWcUwrMjCScJzDfiGYA1nOZ+2n3ozFY
 xPNC6liA
 U9UO/z6PKsfY/lqcwXpylIW+G6CisEdkdB2vW2HXXPj1MKOPi7F610JxVTCKe2TD++lIZehJCc8U6wlC3J7LsLRUuC71oDvDfTj2vUAgHPTOBzBxK8q/kUPwQ78zc3e8Mkc70mCFCv1cjHcnwPw1rdXvNnseKGA0ekgnK9z1f532YUi7xxICfYAjW76YLzG6p6yqQDFTidqmM8cS2sG5NbVRl8p1uoy4+zpyWllCMwJTtVWxCiT2LeR0gqD4bUkv7SQFoKwsOx9x/gRI/ZeS3qVaiIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Due to online parameter update like events, the number of DAMON regions
could be higher than the user-set upper limit.  kdamond_merge_regions()
repeats merge regions until the number meets the limit, while doubling
the merge threshold up to the theoretical maximum threshold.  It is
tried only up to the theoretical maximum threshold because even the
aggressive merging can fail from reducing the number of regions under
the user-defined upper limit.  For example, there could be many
user-defined non-contiguous regions that cannot be merged.

The threshold based loop break condition is evaluated by comparing the
threshold for the next merging try against the theoretical maximum
threshold.  If max_thres is larger than UINT_MAX / 2, doubling the
threshold could make it overflow, and bypass the loop break condition.
In the case, if the number of regions cannot be reduced under the upper
limit like explained above, the loop will run infinitely.

Prevent the case by doing the break condition check before doubling the
threshold.  Also, prevent the threshold exceeding the maximum threshold,
as it could overflow and apply the wrong merge threshold.

This issue is unlikely to occur in real world, since having the
max_thres higher than UINT_MAX / 2 require unrealistically large
aggregation intervals compared to the sampling interval.  Also, it
requires an unrealistically large number of uncontiguous regions setup.
Nonetheless, the consequence is bad and the fix is simple.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org

Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Cc: <stable@vger.kernel.org> # 6.10.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 806a67d02a6e9..f3b6a46fdaabd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3369,15 +3369,20 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
-	do {
+	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
 			damon_merge_regions_of(t, threshold, sz_limit, c);
 			nr_regions += damon_nr_regions(t);
 		}
-		threshold = max(1, threshold * 2);
-	} while (nr_regions > c->attrs.max_nr_regions &&
-			threshold / 2 < max_thres);
+		if (nr_regions <= c->attrs.max_nr_regions ||
+				max_thres <= threshold)
+			break;
+		if (threshold < max_thres / 2)
+			threshold = max(1, threshold * 2);
+		else
+			threshold = max_thres;
+	}
 }
 
 #ifdef CONFIG_DAMON_DEBUG_SANITY
-- 
2.47.3

