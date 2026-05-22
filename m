Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FFA8CD5BB7
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8D96B00A9; Fri, 22 May 2026 11:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A746B00B0; Fri, 22 May 2026 11:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BA56B00AA; Fri, 22 May 2026 11:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23B3F6B00A5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D82941C0C4D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:37 +0000 (UTC)
X-FDA: 84795468114.20.885304C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5282AC000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMPU0gcc;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMM8ZRfSsARmGo6eD+hRIbIxGHEMj2jHM5nMAylgAOE=;
	b=WEG6UPRj2RFh6M+zYLqCO8meiOCzZledtkhtgtCUNAg+Oa63eBLaQRhhK3YZ6fwMv06pQZ
	XDpBefVCqa73eTkaBiHz2nrCTyWujg4Ho0rQhCrjPskj6bfZPF2iiybv1csktCtpXWXnWz
	4QXchJA/q2y+f0hGjK2cKzXk2XdiULA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464436; a=rsa-sha256;
	cv=none;
	b=yntrOfmmY36O5Mh+YeArzMe/+WvDm6ca4Bq4fB+HBN4JZTzLGtThpRjpUFtohEt3oA8py3
	MnYyj8nGbVfQToEP4Kbh+QfAMtNKISxBfMfu5/JV4rKelFDWvPfUUOIA0rOwT2ouSy8kp3
	BIsZtyhhgSMVIhmu3gmqZB616lCRc4o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMPU0gcc;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 746C541918;
	Fri, 22 May 2026 15:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3103C1F00A3D;
	Fri, 22 May 2026 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464435;
	bh=iMM8ZRfSsARmGo6eD+hRIbIxGHEMj2jHM5nMAylgAOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMPU0gcc510b8hEOWl8XNJ7KTOiGytz9l+pUedihaHWFRn6uhRrB/gBOKhTWft8Nb
	 KNUV0QEEPs9xlYvEMDvorRwl7OXRGWmjadBvyhj2HyjAYg+m34AYb/u91F9y6diVBO
	 Fzjrqt4+xp+Byx+X+4H+8H2BBPcQaoV93V4PycUJHwCLiS11ZdUDF9L+zFPqhIYFEE
	 n+CsIDT4AAafAisaotM9bYGCa636a5HiGodSMGZUBFfXxfjPoTWrbndQ4rOwuIK3Uh
	 QZE3ET4nfj7taaOxuJr5/xUXacJmh0Tmsp4ODD97FuQsWcv8IzcwsVuvsS1WLDaTKu
	 xbM1VAq6dRolQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/14] mm/damon/core: do not use region out of a loop in damon_set_regions()
Date: Fri, 22 May 2026 08:40:13 -0700
Message-ID: <20260522154026.80546-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 3d8jqsqnyun1tzwksystqdcr15grq39r
X-Rspamd-Queue-Id: 5282AC000D
X-Rspam-User: 
X-HE-Tag: 1779464436-5875
X-HE-Meta: U2FsdGVkX18mNhAr8JetyJGx6O4d0dbapubvBdNbCMxsbo93ZKNqeDSTEcVrUjeOdlP/K/1PR1zzTceiaoKXc6rcdt4buKqYI/Gsgocd1xR2gN7grOsVYXF6SukCf9w4uJJONuzqprd1glW2EfQmlKrPGM/5+CB/A1nML5tbCjK83PEdqV3cXDZSYJ9ViUChxqzbuHkWJeoPnBS8bSZCjCn9VBt0okJpX+DNaww8tb07nqHFN0ZhyK2sbSU5U7GgABMve/FmAWFoQtN6be3oswe0B2aVbz2GaSKhcghDeXxAiJOqmmGjKDVsgeFVxuBxUbhaX3gbkuG12APViYoDhfPz2uGxBhbzw9582OCr3jPsHsyz0F4f86CTEzc2bPEibOu6BwanmC3O+FgOKyiPtIdPTExxJDjVMFdSOtjtkYMCHrA1zEK+XgiZPBvLMjSpxZfbQfSfIacUH6aCC9keftW8tnFuXAiN8fKIlsd3c2sTgOqPj0kZm6JtR4lvrqs5knTQhhSLg4VryW4UjcH+rED53r2IgY3Ung91jIWaYZsU0BOPIGT1/CTNU31dbjvmoXUq7JiD3rm6RTOaUVuHak8VhDQdUKT5s2DasItSW4Y7zMF0hUxoM33QwXDWverKcf0PGQxuqNPHUUnhT9lvFO7YR+yqRa8b4p/qK/595FRQHqMu5ehlFTwJRP4UA/ZA7FXlGpYm3jsM1KqP+Kpz+3quRWbaKnPBlTT1hwUCaMICkO7zkQqb1YFCh2RKY4H+40OMD8z+DZIxX2YdparDwBUCS36i+pXjA7LXHhF21UEElCDc5ViHnwNyInn/slJFkvjZEkEIOw9iRBpRsZhMjtQ2KOkZPEQy5n/r68vcSmyltmlnV1+6VbtuWNp4GswAp/aUr6VTydu9tot7jSSX3koDnWxSATZ8H+4KTskisltMcLXxSgPjiftSVEOlh2NEvqfYzQX8etwb+KQP8VI
 ADP6XdAp
 NXYNua4ELoiJ/D9a12eEIv3Se6S2bya6HG3ldNxjgWWYdM3o2fnNSAC2D1SAm4W1phY6FYD/ZhPOjyFiu0ijpf4pAVXRfk1mDyiCAlHeW/b/eQ2H3F2jl5r6MX+j6YzdfRGqeLH+q4xvOlJKu62rDnxbLPvBC1qxtjzTMtzt85AvoruDAz5pixyetmLOY3whkN4TIaFqKUGJ8opOKQNZHrUzjpx59Cg4yIbHnnRP9ksVN5g+pcV59ePMOrNj5HxFyQooOmPPrArPBSqB/NgXyi31c8w==
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

