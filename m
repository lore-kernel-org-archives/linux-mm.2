Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66DBFC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BDB26B00B5; Tue, 29 Sep 2026 04:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89DB96B00B7; Tue, 29 Sep 2026 04:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7835E6B00B6; Tue, 29 Sep 2026 04:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 537E36B00B4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA2E212044B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:30 +0000 (UTC)
X-FDA: 85266055140.15.C9FBAFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 39324100010
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YC5u6d3y;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5cEs7PRdoqMNSy5NOsa42xjR4QTiCW1/my5gdO7tFQ=;
	b=m41YCsHG+tE4yp62X6F7bjeIOCnsYPPxYXJZdCNQJNoftsAY3OsTJf6lSs3VvKI43F9aB0
	q0NjRn71k0USnZqv+cTkpRToYf+veMY3rXWTBRL+JGJbMnRsW+FC7c8QgLn9zqCLcfnVlQ
	/M83v8h1w0UXnPXfu5fyAjd5Wu3qMzw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668889;
	b=xJ8xTXZuSaov2g8JafIl0ptNvizmVblSU+yClkc/VMLPbof4qIvAR0L4H1LjF+TtJim4rR
	wtoZSaqtgY+QajhKGWXq/KMLaQxvRrurIHkZZ1gO1wf4gAAHDD/b1Nb/XXYjnF5aLuzTzM
	wsV77JBta6GhX9h+WgJSNx7GOBb43Cw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YC5u6d3y;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 902FA4015C;
	Tue, 29 Sep 2026 08:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670281F000FF;
	Tue, 29 Sep 2026 08:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668888;
	bh=L5cEs7PRdoqMNSy5NOsa42xjR4QTiCW1/my5gdO7tFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YC5u6d3yluoDzHwp4Cpxt5vHFKrGn3wti3vDOFMYsUMQCb4bomj0Pvx4JQeJMJQCL
	 N0lyjbiLVSkur+o1P0OdoCHp2etn9/aC35dhq+T48T41uMztjCohjvsavxJwqqWSTz
	 w98GAVe54rZh84P7gFqjc3dlTMcxL5g4X3it3QfWCMWmUjqVzRb4vWdkcIXExpXXsT
	 jl3gNNsfMxRMhtw0YOKmk+Bypmo6uhhGkLmKlIx89p3hN17JvHkgTsCFyRPTRargD5
	 Qe6ZfKzNbo5J+glpqmAfsRHZTuBMbVW+6dgdAzeJNueIzDYvmqc6uikYKuQnkj0FGL
	 wvtpWGwCljG/A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] mm/damon/tests/core-kunit: test quota_goal->complement commit
Date: Tue, 29 Sep 2026 01:01:07 -0700
Message-ID: <20260929080113.41708-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929080113.41708-1-sj@kernel.org>
References: <20260929080113.41708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 39324100010
X-Stat-Signature: iuf4gmif9pn7byimn75qwsaykd866ejq
X-HE-Tag: 1790668889-315180
X-HE-Meta: U2FsdGVkX19UDXz7vqks7ttV7ypNgXziuf+tipC5OXPqDHaPNUri4SE8gzXk/G3CVK6QLj2jxzU1DIX2GLrAGAZXzssvPmBZSiO8q9yZ4qQwHRRErNdv9+8C08QA+KElROskeZUl9oPkWCxWGu+7DsWD/P9YwEQqMeQqHNKa7ygi9Z2Dqv2rX/uytuhhlWCFMz0fC1AhzBKcQpofG8O+7Ljrlvt4TqTrGknHbyyTV4NyVoWlCff4/8Qmu+kxB6QZOv40Wl8ytVJk0TrW5nFXAIKfDPXlXiut24az7wHQp/k3rkqiXrKHkSAc1LPT5AEqtMb9ATF7taoITa2f6p7J310wmsPIgfUyDSZy1gEqAS3Ae18ERvYOEgOFcVyeP/dEL3PE6VfyeOfTBWqvo1WDIC9XH9aH6tlmenu/sAOGYnEF6Khd5mC/TFpB10hqLeOmlla0mxTIY09J6JxR/34TpYeywbUJEP62c9T18kASidsWEQhs6vg9brkNBRTrXWfOL7cN+M6xanx3+g/pOVS+j3DD3OY6P8RybD7ubzLXRF0rc6tj3CLYbdC7tyak7FpxEvR/0LwUyoRJw31bF+SSZqONkk6mtuBKdW8jvwk2lN9VlxPJL+dUzRKjdy30JFdYHByrHXX9bsgiTg5t3dcYUxqXdnpeFLCR50zrO4Wv06PMnWaABL6JMo2p+QEyWXfbq7F7vZpxrfSBK/oquXCgRVYUWrgqKXuSkguaryXo6gYJs6OWgkwE46UzTB5EgaDpRtNP70D80a7BOfkuPhNc/RIDWJgl9z4J+GTu6PwU+TNXeLbjTaFVoraRaY/RgTR1brCjnBnjA+fXDbTSbcAcXAiiqp61tBH0SfYdClV+STPexC22WcBxUxso4+rnHzt4G/XVPa/ho5gDEZUkhWCc6o5D1mTSWV3eio2upbdbks378xFDJ6PEEPkSV/Dt5CF/sKmw9jTkUEBII7kj0Nt
 FdZuW1gW
 KvPGbOU58R25KpWSbDl/cmVus2kagofXUiJaCbBaMXc1Hf8z/rtnUeP1fsExbB4eXDL52bHJ4Pfra7U5YZNQydmb4XtqKplK28s1jugxXbd8esFfQqFEw+jJRqnbPheQT2c9E98Jz6MwkuU6kTnhPD7/9jqW8Et1st8BiRR07lwKT9mtLyokhuOkk+7OOo7yf6nIsKGBLMx7Gm+0II+rdkBxmGkCfyKekgQg3WM3reWL7LUaeUwGV9Tj9lme+dis/RvigiT6j2NnvVtWPNSKxUACrKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend existing DAMOS quota goal commit unit test to test the complement
flag.  Set the source complement flag and confirm the destination is
updated to the given input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5a924edb171f..ef146ca2ae8a 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -861,6 +861,7 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
 	damos_commit_quota_goal(dst, src);
 
 	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
+	KUNIT_EXPECT_EQ(test, dst->complement, src->complement);
 	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
 	if (src->metric == DAMOS_QUOTA_USER_INPUT)
 		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
@@ -904,6 +905,7 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
+			.complement = true,
 			.target_value = 789,
 			.current_value = 12});
 	damos_test_commit_quota_goal_for(test, &dst,
-- 
2.47.3

