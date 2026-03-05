Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34679EEF304
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 05:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132D86B0088; Thu,  5 Mar 2026 00:39:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACDC6B0095; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9BC16B0092; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB546B0095
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45BDF1B8A3B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:30 +0000 (UTC)
X-FDA: 84510906900.08.2377ECE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9D137180007
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFxfg2G0;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772689168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSfTrkN3uUIMvnOe30QcgaSX+Z6RsQeomlXqNC5BLj8=;
	b=f/fUGmNBQZpF5yYWQi3DVpOIFQRsU4QYTgytqgvii7Inw1EmIm+t8GrCLy4WMa1e9tvWim
	EsF8KLv+fTE5+hkickElvLPuIsFNAplhoxUtUCtnYywcP7z2/j1mXlFWtt9Z7jqiNYobxB
	HxXKXSkfzXz9MowK2rSaW5hlC7JiNK0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFxfg2G0;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772689168; a=rsa-sha256;
	cv=none;
	b=XvCl9fzS79zhlvwnPuAb6qFc+qohtHxJ+VySyzfTcCmmYt8oBIQHkV5t4aQO0+cTjB4mZ/
	M4mR0R/bwx/q2rDnrSYzyomTEz/M4GyJJsZlWgWiunplFcaKY/PGj45sGl/P7KfRMd+Yo7
	EEF0ZnUv+ghPE4p69Wugd0qHSmcDPwk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9512F4455D;
	Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658DBC116C6;
	Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772689167;
	bh=kZ7koKz8qVMB9D4eDY9APGuQt2En5THDUr0Tf4sclNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFxfg2G0MgGzE6YO6yM0TECJsgz7CkfK1YkIMVCHdR2GmW+C9Ip9QJk6GN6HOVUDp
	 FQ1+rIWi4WnjADGn5r1raE8kZscNrzDg1SRHnLh4b6/YbAwj9/kMKnFu2IRJDYVZac
	 w7tBvrdg33heRurOcaFdAz40Pf0Dd4wJL7q6OVtiQ8GaVFu4mwm8UwhuvyHOvjMmPi
	 Ba+DhAOG1FKH8YkqbKX1LoHmTO4zbpUhzRoSbMIVhuV9chljNyY2b/jOsSb6PHqlte
	 QXrL9p5SSA5wA7QtlsLl36i8NJqHDeKbgkbcGs4oMtFUOqJ6T8DzGKUe4qovPMuImp
	 VsLErYTguWahQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/5] mm/damon/reclaim: respect addr_unit on default monitoring region setup
Date: Wed,  4 Mar 2026 21:39:16 -0800
Message-ID: <20260305053918.83786-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305053918.83786-1-sj@kernel.org>
References: <20260305053918.83786-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9D137180007
X-Stat-Signature: e6oks9zgmk5qz7xegf3fzwfwbakxqoa4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772689168-644223
X-HE-Meta: U2FsdGVkX1/vJB2ZhAFDRkhZ3H8TvG50yjsV/tCJbCNDuj+LldaAuFwkhp1vJKqWz0rjSzfu0fkqmn+NdSukYDibuS5EyNKF1Xu9yZQDbfdjxZClo6Qzr3FK+sAmXsJEPWHqalS4VgbLO+kohzp8zbi4l1lQH1BIKBxPM1I16qRyH431aGwMw98zhbCtLb8kIQt5a8qBOb6/sxovbQZAWi54i00wrM2A+/66YWShCRh2BHE6CelQSa2QeRvigz/ybnup+ICXjSJOs8gT4gkQ7LS7r+zpuPiushgavixm1lUpZNKnRzQzGWaTLNmiB/XtsnIsPSDevbudd53fB4uueu5kcQfmRVqNfw/LMYKg05utVy4iQICFl5auMtbU1v/NYLuMM4KiFNWs10ib+TPBKgTpTGMsIOsmAtbooguIgWQ+YQag42mluYgruAwaNwGjE89a3E3sqGRJ90ERs5cTgtEzBSH8ZLJ9FdMsJ9d0mD7ovXwTFdh50hAVBR7N7sy6jPSucAFAULvdGznG7BDQjy/0jRrM1/diHTuzWz7BihZQkfuiU6CaBqKwp5uQL3j+s4/0Q94FYzcYxF4CI9TiQYhpuM9EcjIuBNm3A3vASrcz7V//kIR/IuYlPqvTRTATG9INvzQaaSjhVKQ0omigKIjOFRUDbVX1JCZdLuhYvGO7RkwGiWcISlH3s/0lz3aT0GdFnhsb7luw+aie1B4z/UICiQsh6mWDjBjiAqSngas97CTb5Oqu0ut8DwQZUEcu0J+5rw1Bt739CyUVxPRj9IBFq2g0vLR1l7brdJgn7aXrK8Hhz8z/KFQ8cqkdV9VfJpjvfQ7WWk3KKcAG6eHb9PUCE5UK6wxdQan0Ug5GT1wUYmTE1ApXJpK/ccYUm3u0B9LpSPfOhDKkdhKAowjhfTIx8yW5UzrXApi55Z5NhXU2XVEhlaqQlSV39ZcDGPT3K9BQEdGh2aPWQQ0Mmxi
 f4ZHKVA4
 PYV1TLg8Jo2stcYtc1MIULQ1sxC1p4pl2QW+xad8YRBtNdRr48zS9ghNkBXSfWFj4Cpa6T/ZxRJYVwdawMN3HTD/bfEmGpLjl/DrMfna4v6VKAZ5hxgOucvqTx1pifqL6CQdjoHYy8e2BPyi3ROI6HrJGGP7KQOjxvBmxSNc7Yt2Za0u0ckrq2tDH429PRq9dZ8P1cYXjGsXuaabaM0MFko2KUN11fCZFtie0XvaHn0A2maIRgUTBb9uXX4zT7GyLTPMweHZdm44JWtNQl7ReBbM5jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, damon_set_region_biggest_system_ram_default(), which is the
core function for setting the default monitoring target region of
DAMON_RECLAIM, didn't support addr_unit.  Hence DAMON_RECLAIM was
silently ignoring users input for addr_unit when the users don't
explicitly set the monitoring target regions, and therefore the default
target region is being used.  No real problem from the ignorance was
reported so far.  But, the implicit rule is only making things
confusing.  Also, the default target region setup function is updated to
supports addr_unit.  Hence there is no reason to keep ignoring it.
Respect the user input addr_unit for the default target monitoring
region use case.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 01f2f6cdbcdfe..86da147786583 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -201,12 +201,6 @@ static int damon_reclaim_apply_parameters(void)
 	if (err)
 		return err;
 
-	/*
-	 * If monitor_region_start/end are unset, always silently
-	 * reset addr_unit to 1.
-	 */
-	if (!monitor_region_start && !monitor_region_end)
-		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-- 
2.47.3

