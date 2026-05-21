Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE3DCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49696B00BE; Thu, 21 May 2026 10:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA616B00BF; Thu, 21 May 2026 10:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF036B00C0; Thu, 21 May 2026 10:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2476B00BE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6905E40631
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:40 +0000 (UTC)
X-FDA: 84791673120.18.6300C4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8CBFC000E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bWEuYdaN;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374078; a=rsa-sha256;
	cv=none;
	b=G7HL3NRpdcZegcvZT4lEFT+TLjr64IBhiyYoGhIWDOnyUuRTkLjjWACG6L0fPc0jucsXWb
	JXzzMjRfvM8BTGtFjmoxIO+TJxmtD0CMjmSwa1uiwlHUr1pRTWSLPdoQqwCLTEGqq38izY
	1JmtZ4kZuHuV3/HAhRDoBSvxH7uV1iE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bWEuYdaN;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMM8ZRfSsARmGo6eD+hRIbIxGHEMj2jHM5nMAylgAOE=;
	b=fuXHoy0ofZs0A4aYJTwvFhCGHvVXyiKDz4woUQRIMC71q/Ff/Hy2tnYHkqQNovGi7F0rt/
	bMC7z2OTCtLKmq39RB5wJniU/SSw1ADppm/0YpJb2QJWjJp399KIvU4Xlo4JoAfnLIPgCa
	5VgHtkkndpMMpdop23XT3GAalJCSCjQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76EFA601F3;
	Thu, 21 May 2026 14:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E491F00A3D;
	Thu, 21 May 2026 14:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374078;
	bh=iMM8ZRfSsARmGo6eD+hRIbIxGHEMj2jHM5nMAylgAOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWEuYdaNmVFDjKsvRuqq0YJHRvCUaAx2GvJr9y3wf/72QFXCBCP5rUH7TqGW7iQJE
	 bBZZpk650IhubHqIwaD3RR3WZ/xBWzD+e5BtzDBK8V5caF6krimBN09VdUGqiphQ9i
	 G+Wwgm6Ghl3smylvGOwZDVG1E49zp9cH+irT9akiBGo/ubPnqxpn44F4JENymzjUf+
	 y06/U4llsZhlI3lzFZ9wFOUyu29lPX6yKhem0HuViWrgSrqFYaNMoM+KhkE+S0nsAT
	 tqQhxF3Zefm12Ssc4iXZRH9BxQKKNmIREsYxTkATQT3YIHarbKSNBWh0z71oQlf7T7
	 JOTLdLi+PrT4A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 02/14] mm/damon/core: do not use region out of a loop in damon_set_regions()
Date: Thu, 21 May 2026 07:34:12 -0700
Message-ID: <20260521143428.83157-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D8CBFC000E
X-Rspamd-Server: rspam03
X-Stat-Signature: ppbmqchoaj3whkpk4bq4hqynrhcxdtwd
X-HE-Tag: 1779374078-938022
X-HE-Meta: U2FsdGVkX1+zs0V0ObIXP8R3pGLjhc/Aq1+2r3iLK9ZAel1FeKvSII02vUaZy6JlhrHFYoQAWDA7kgWOZoe3XPH11M/+/nx4uaxEhkQDHyv9WG2TF3gw/rzYr3gYUMIu/sjQcqqNlr4D1B5APBn3tiPAztDliQAIXe7Vvxf+ZgibpCTzFMNTgQwxTmWumpmVmA7VY5MWwGOO2bM6L7FENeSrciVm0JOkcAgDEXKlwIgLu7ImAEY72hBs7YwJsD2JJV0LTqn9uAUvKcgKmZSdxfrRW/+bhur2ivF4+FTavedxCwo9V6uzCTvSUGaHwVTH9hUL31EiS5O6ggFRhYHBcrxE8YMTFBuMbJVlWl/J5UJA3idfkpkVG1LuQiAQPXAy7T3N1N9tWdL0uAKcoiTA7GQ8dxsqrpD2/tRZkbdsHjMTTkA3IOhCLDZZZ6DPwpPyTZCKiizGxrPLC5lIo1upvzTx/0Ju5hwhqyrTZjiKIc30jDhTEZMADqjZh2peJsvAkzodXhHHwydIn7HJyo4TbU6aIZsUC4WsOZM5/Q2hWhs81utQZgufRb6DAWAUwh0P2vp2mThFToWjhPWCxDoxw0sykGU5Cza/vFKXnO4ENweAbeXL0ul2n4oc9C04JXtfkC05bvFwTD91g0NsgkIsPS+lLWCyGeEH7BTLgdqLufKwlEJGtT5ll6Fh5v/4ytKgrqqgs9iEjXX3vR7PxYgTcp4IQUQAmC0U3BSZ4zeCn8IkzgIyii+0BFxsH+TSmKnqRE2nUY8uBbLUSZV3F7ByH/uPdqj1bPvd94lV3D+KAVIWbehYUXQ41Dptx6Z5gMzS+KJzeXu+NC9+wDKwd5WOHMtbWZUSMy/9Gmssp0cDEoBOUuIBjsdUoAEI63Fuy1TQzRTqC35e1QndE9oCYHphOnUHkrG3Q9iLdcTgQy4fEi4Y6D+z65Cker/uqkknLAA0s73XIIvpgetm4XULOSm
 0DS+MQV2
 qEiObutyW6OP2TTICTGAE4a8DO9CllgzA8clxtN6G28ErOok+adPdSdj2fzu8HYTstdBmZSPU4zZUoDrXM7e9v/z+YWLbgcyz0zzPlaCicepK9HzaTWmxdY5Sx3gP1XCEGutYhtM/svOZHEGT8t7chli9QC+6WyNHjd0tsJY0IW7B4jnQTnKSIapq2Mrxl/8RtyinEvb50oFlPKmt/9AktVpIf+L3YEQACho8l5pcndoQV5nQJiAd6fR/m6OHZxL8Fl0uFAZXkf6gAxhWxRVPgHGoiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() assumes the DAMON region iterator is referencing the
last region after the region iteration loop is completed.  The code is
indeed implemented in the way, but that is not a documented safe
behavior.  Hence it is unreliable and difficult to read.  Cleanup the
code to avoid the case.

No behavioral change is intended.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 40946a7f6f549..e8cf3632115e5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -374,6 +374,7 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 	for (i = 0; i < nr_ranges; i++) {
 		struct damon_region *first = NULL, *last, *newr;
 		struct damon_addr_range *range;
+		bool insert_before_r = false;
 
 		range = &ranges[i];
 		/* Get the first/last regions intersecting with the range */
@@ -383,8 +384,10 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 					first = r;
 				last = r;
 			}
-			if (r->ar.start >= range->end)
+			if (r->ar.start >= range->end) {
+				insert_before_r = true;
 				break;
+			}
 		}
 		if (!first) {
 			/* no region intersects with this range */
@@ -394,7 +397,11 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 					ALIGN(range->end, min_region_sz));
 			if (!newr)
 				return -ENOMEM;
-			damon_insert_region(newr, damon_prev_region(r), r, t);
+			if (insert_before_r)
+				damon_insert_region(newr, damon_prev_region(r),
+						r, t);
+			else
+				damon_add_region(newr, t);
 		} else {
 			/* resize intersecting regions to fit in this range */
 			first->ar.start = ALIGN_DOWN(range->start,
-- 
2.47.3

