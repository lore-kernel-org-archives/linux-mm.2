Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6ECCA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 13:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9246B0096; Fri,  9 Oct 2026 09:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783286B0099; Fri,  9 Oct 2026 09:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623126B0098; Fri,  9 Oct 2026 09:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A62C6B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:50:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBBC8C0390
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:50:10 +0000 (UTC)
X-FDA: 85303221780.28.0DD5E2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1033F20009
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:50:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=POPZCRVT;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791553809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGYamTbhyF8fPIDsPezdQjUGd6YDkrBY2lo9+2JMLnM=;
	b=KxmaPHEE9hCGHCnRTq4PY87dDlJF6PPWW4sHWOtI+1zIbEZysyOpZuJMd9s/3tfHapHgCe
	Ct7cP5z8r9t6sZBLLNuicfk3Nei6jxPOVCtlhtSBU1vTJ0oQ77SoarNbQWrytyCRHqsVUG
	EXBRourB4OCoQtMFW7sWf2NACQSZ950=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791553809;
	b=bl45HyiPKjBXAh/xLfsklfqYvmJeCYgTF5rwFvlouejAYDBRadz3DG44FaCqNQYl2zmQ2K
	YljowlpiHwAgF9x6/qbXqChZ3V2j/FN2771CN8xUvX7VXaGhr4u3RVZCWGUWXelqthBnVY
	0D3OOnTMgWyYOwIpQ9i+CdpbGn7NiXk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=POPZCRVT;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D875844011;
	Fri,  9 Oct 2026 13:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4190F1F000FF;
	Fri,  9 Oct 2026 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791553806;
	bh=NGYamTbhyF8fPIDsPezdQjUGd6YDkrBY2lo9+2JMLnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POPZCRVTopIVD6QueeAp/dbl/2w0eQjppiua1Xgapd3r3bYqxeOThVbyppGzpk+Ua
	 FdxU9T/jq3b0gprHOqC08n2+VSwbkSBFDcXCv/mm8c9ZF9Zaq1use1gra0+sx/neEK
	 9mZuxnkBuRKpHgwau3IiHViu0chKTSycGzEVW5YYuTfNPfGXSkD5q+YON8/dPfypzD
	 YA7884+MinfTyzde+PG6yLPhO9XUZXFjPbF6uRZiXKo+1j+jGn3CemPeBGvzRjbkJ0
	 Fno1psmye9lcBTBlPAMduLnRV7SnTFfNAT3v7CMc+eWrQEHmxsHMSOZ8B33jWPfSCl
	 7ld4as1g2mg4A==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: damon@lists.linux.dev,
	Liew Rui Yan <aethernet65535@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y v3 2/2] mm/damon/core: fix unconditionally skip last region
Date: Fri,  9 Oct 2026 06:49:49 -0700
Message-ID: <20261009134949.11507-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261009134949.11507-1-sj@kernel.org>
References: <2026092948-moonrise-persecute-3597@gregkh>
 <20261009134949.11507-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1033F20009
X-Stat-Signature: bsis9odyzwj1f8ep1ehk7iwgaj7ce53j
X-HE-Tag: 1791553808-346672
X-HE-Meta: U2FsdGVkX1+HyAkAD99piYau4SO1JRcmCwghd8VSpSgnCZa5rYa0ae9REsL15F7g9LIFJdw4jZrgLgfl3LS7aobS5DNraI7hQ/G6cjIGs4Y9eZR1HMpqiCF72QwCk8R8GlRQgufARXt/yTbvaq71hzciXolsQVuD2VHhADVakfnwG/h0QuMQ8RlX2xepBO2AXUQS6R/I1vrK7+jKcad87P/xCptkjFKgdaqhLpJX9o1JS/ePTJinAgRli6bx+3dY6W4csUK7+fTwHGkk/LhbRhbVULjSodBOW0XPafaRsI5S57VkItl4V2ZMhz+OQ/hS+5RYuo5izizVvUEX1wr4JwTIZGTzUQ7SE1J2vSF46onPAvqOgESFtx4Do+L9uf1UdHklHbUp76MJyOV3ZIblh0gVeevtA8w1eUz132b6QW2QosjO3l8zRAdkbOvURTh4ej2iSqZq7uXT3E85vRBCyv4I2aN/WuwjekLjYswk9kf/c9Pqzi52tj6E4D12p/VDPChAV7AYeXaRXxVzwbfML6Ln+eqQauFEjgTySr2FKf/KtcUbLP+a457EqqsPZQDoe+AT7tnGSZN3dGQI6DXsgGISPnRcmDGNk3L+vdo8QxEUbaT46nMFif2mI/hh9kRJPh7jx8bbq4Dgezns1/jW3HFahroWPsG1IY3to6pMH/puvipgxxJIS73HLq61uOGf6kS92NwAwHA+sIlvt3S5PsnDgCWM4o8HVIIrpgKGurIlf8EtvmZCilsUiPvpasuGKDf2p1G2rnkuJqDnCdFI6erttHxNCNiB6IJCP3wVeznIVHCFpBJPbaeGPd+t2JjH35s8KtiG99fvQLRAQe4/+aqqql4o1jx3aSWPF6UIzOL5TfjhSa5C1/+vT+anNxLJZ4IAGcc7sIQDX+ZhuyGZpT0koTB7TLg/7ipgrnHYcxRJ6SNH6NPK3YXT1I1liAR/t1463garEXqvmhpZ39T
 dKCgigzs
 9UZmZLVo5lnF00U9lmWxS9gYWFrtwsv0g63BDE1fgVn9DrX7TNbhnmGoPftc5dHJ4pa/4OFFYBB7wFFcsbRN57fXXn1DVNofWtGSoEROU7oc9VXpLD8VqpsN8XgrjosVaX8r6bxIQlsIVBdjZtoELcQnSa0IgGWpmuxlk+pPIZM7rJnWwdvI9/MYIdLgbSdvQXPQkzAo8jPiCMhmKcbhYhzu1vyw8ffJ8VYynDzBEus7axQ03wbhCMRHBP2C7HBqJidBH1tI0wrr3u5jDjSuw5FCxZfb0NCk8Msj1tTF+lRDPH08kUGBVDF8jRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Once quota set, the charge_{target,addr}_from unconditionally skips and
resets at the last region of the tracked target, so the last region can be
skipped even when it has not been processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
       addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.

However, it is important to note that this is a very minor issue.  This is
because it is triggered only when the previous window saved/kept
charge_{target,addr}_from, and in the next window, all regions except the
last region were skipped by damos_skip_charged_region().

Fix this by only resetting the charge_{target,addr}_from when last region
is reached, only skipping when it is applied or cannot split.

Link: https://lore.kernel.org/20260908134739.96919-1-sj@kernel.org
Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # v5.16.x
(cherry picked from commit b3723b596b548c837a766aae3553c14a7b15af2b)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c86cac855b9b..c459eae4bbae 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -884,36 +884,39 @@ static bool damos_skip_charged_region(struct damon_target *t,
 {
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
+	bool skip = false;
 
 	/* Skip previously charged regions */
 	if (quota->charge_target_from) {
 		if (t != quota->charge_target_from)
 			return true;
-		if (r == damon_last_region(t)) {
-			quota->charge_target_from = NULL;
-			quota->charge_addr_from = 0;
-			return true;
-		}
 		if (quota->charge_addr_from &&
-				r->ar.end <= quota->charge_addr_from)
-			return true;
+				r->ar.end <= quota->charge_addr_from) {
+			skip = true;
+			goto out;
+		}
 
 		if (quota->charge_addr_from && r->ar.start <
 				quota->charge_addr_from) {
 			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
 					r->ar.start, DAMON_MIN_REGION);
 			if (!sz_to_skip) {
-				if (damon_sz_region(r) <= DAMON_MIN_REGION)
-					return true;
+				if (damon_sz_region(r) <= DAMON_MIN_REGION) {
+					skip = true;
+					goto out;
+				}
 				sz_to_skip = DAMON_MIN_REGION;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			return true;
+			skip = true;
 		}
+	}
+out:
+	if (r == damon_last_region(t)) {
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
 	}
-	return false;
+	return skip;
 }
 
 static void damos_update_stat(struct damos *s,
-- 
2.47.3

