Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511C6C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB5F6B00D4; Wed,  2 Sep 2026 21:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F106B00D6; Wed,  2 Sep 2026 21:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624B56B00D5; Wed,  2 Sep 2026 21:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36E336B00CC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:03:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFA3B160379
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:45 +0000 (UTC)
X-FDA: 85170653610.01.8E9F6DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37816C000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W21hnb7e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFqUVYf2n04Uixau/NkzvcP/6puf0JnXDQxViDXP7BQ=;
	b=vSvJ2JFyTOXMxJO6+aWf6bPu6uNq9tLNGQGq8S1n2nt82N7QSTaUCCTE+e2buVCpvG7iy1
	DFPW9FGdXbT8QvJj46xMugnTi4HsaNcovbuysXCUGVcX7cVsa0GFJH2swx69fKsi+XAdLr
	C9XgMjaukxiYi0etkLpXiD+RLf0fQgI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W21hnb7e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397424;
	b=BEZrTfhIvdakZYuwrAtbya/6KR/3Ql+6ANPE/IZufVihnpF6TmxBf4PjYPNMzx4WGpKHEN
	5JJhJ1K2OJdjsgPKJKgPaeCCbgnbVBv1YoLACCWlzUmZ3Y8J6hRdeUE+Knw6lxBs1yg8QG
	AolYJR9CY5JeYQ0RxbUS/LjM1MznLAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59EFA41661;
	Thu,  3 Sep 2026 01:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CB21F00A3F;
	Thu,  3 Sep 2026 01:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788397423;
	bh=bFqUVYf2n04Uixau/NkzvcP/6puf0JnXDQxViDXP7BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W21hnb7eXdHFi5C1WDTJxhG7jrXJ3GRTxTkW9kXHLAflDXVKTfvdNeQzKfzYZJDIM
	 OkyuKIY20zYacrL6Y26G9sSwNzVPZ4nvRHrnky32h5IIPr/oVwCa2C/PZzglsSq35q
	 i2VcWvgmSs40pPuPwUtSTJMM1UPrOr00aRXUPck0Uz10xwYvokDhPHA22vBhQuwKYl
	 Seudwxv3FLimUuSQindVD9+RBkBQpqcL2X/K11Y8AgJo9aX4/KSeFiVA/HMxNUFXnE
	 2dXpn67RadvEj2yUpBivnV2xL+IaInOeiH0beKyN1yX8XsbBl8W2eOWka1L608IIm/
	 64zleUSZnJ+6g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] mm/damon/reclaim: remove unnecessary damon_call() param validation
Date: Wed,  2 Sep 2026 18:03:32 -0700
Message-ID: <20260903010334.93622-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903010334.93622-1-sj@kernel.org>
References: <20260903010334.93622-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ejt7gz93jcdbhedqpyj8nerm8w51zbna
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37816C000B
X-Rspam-User: 
X-HE-Tag: 1788397424-113057
X-HE-Meta: U2FsdGVkX1/jzR2XuB8PiEvbnU2KhL7dQb9rY8ok1BNtUwvxeiFfNCrJess6nNs9i1m2+V/EXJYmmTCKTfKN6q7G9e/nzwaj9nooWLsd8JRdhwFEHqMhzKse74tHLHuakj9Fg6d6nUKab8wFo1H3Sifo+J4PPf2I4rSdkf5GW+QzwTYBQGN18FMygH62E2RMqbMKGZXt1E8aN3ZF98Gg5mtjuKEBwKMRklXW+Ld1tNxRhS9OlBw0h3e7CcFXukP73nQ+CEI0RLbrmxhRhsDeEwpHtJo/F5DJkbkTHxr2zU5o0xY0rDXm2GA8Xg2PQZXNHzHw2tdFKZA6Otw3hDKLXZTV9HHiCeniowXhiIGtwy2m+c3lpBW4holJQ2FT6Fx6slBfLwkXkaXl8q4p9rY+YOLYDG6Y902k/Rrfj2X/ygu/LZj5+HRymdY0LrIpVMT7SwQNsPpBUD7ziGIDy7Y4zdg62mv2YpjJOgeVE913U+e4kpeQk/DLYBQ3t1ysIlWpnUeh89C78279rlVvwF4JAwABaJT9MVHEmT3eTf4QumKPO4wPhb6AcA4EZAGlky4P3COe7sVW7nLdywQcuOkFQUbSejHdj55wbb7K4SMFw2vwfYxqi17Igyu8ZaXhN0o8jpeMPBPUxyTNLGT9TTfuoZt3dAQUSvCGfVDPi8tPX3y9gDb/aFUa7inxNowqsYAkPsVzaunCWo8ql+71es58qMxnV01cO3+iHO0uit0SWVz3eNs1PQsD7VE7GGrShb8xJnJhrIlHPA4l3IXrv9hY63F1Iy7pKe+TEj6/gvS7NkxxV+tykgJdObyXJ0C5TtQPBzv2ULLDTaDtZGUIWi/Y2X5NiJzdvGbNXWFdpxKIIbCYzR3xjvergAqFOgsmQmjm6ecPSZWN/liJIC+R/nzn0t2U8xryLyC2Sd//dbz/hpRCWYYMtpejbg9Z5OKebCe8RPJhiIGc6wRapbLSCqb
 dbUfVmPh
 AZqjgeYV2YAKeL/NmUIdiZJ7E3g/DyxQi10xP6VAAF+bSi1VIcfGMnhhHo+oQq9wbKktHtJn8afdtLslg/rqh5VG3sI06tOyoBEzNwOijKljTprkB0GPNedWWJqGlXuDwrUEYu3Rd80MKzoBlJvQPZUd/OXBclQb4C5kas4kHEdkEYtfFrBX1+eCd9XbVqoH9Zs+c4mUPe+erreKvs65Dy40wNXfs8ffQqGmjDeoZvRC2LrnXrBskZx5PZCzR96E4sRtfU1igLhTCARE2q4sjujg99g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM avoids passing NULL or unstarted damon_ctx to damon_call()
with its own validation.  The validation is no longer needed, because
the DAMON core layer now handles the corner cases itself.  Remove the
unnecessary check.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 45d5557cc575a..42a2c9cb13431 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -271,8 +271,6 @@ static int damon_reclaim_commit_inputs_fn(void *arg)
 	return damon_reclaim_apply_parameters();
 }
 
-static bool damon_reclaim_damon_has_started;
-
 static int damon_reclaim_commit_inputs_store(const char *val,
 					     const struct kernel_param *kp)
 {
@@ -293,10 +291,6 @@ static int damon_reclaim_commit_inputs_store(const char *val,
 	if (!commit_inputs_request)
 		return 0;
 
-	/* Skip damon_call() if ctx has not successfully started. */
-	if (!damon_reclaim_damon_has_started)
-		return -EINVAL;
-
 	err = damon_call(ctx, &control);
 
 	return err ? err : control.return_code;
@@ -343,8 +337,6 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	if (!damon_reclaim_damon_has_started)
-		damon_reclaim_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

