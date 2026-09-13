Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E26C88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23CFF6B00A5; Sun, 13 Sep 2026 13:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215B96B00A6; Sun, 13 Sep 2026 13:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152EA6B00A7; Sun, 13 Sep 2026 13:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCB6E6B00A5
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:17:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4B3A1208C0
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:20 +0000 (UTC)
X-FDA: 85209395040.01.10B81A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A69A140002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gEU23QJZ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as3OPkNFsYYWKFBQO9tZASdaFQXU9TrMOPenfE/ek3g=;
	b=lD19splMGlW5w8HYCA5IfNAgQN25MLq+42tTFYFWnJARXarff91U7Dn95Nd1BFxVG9OS/H
	M+FmydBA5rhsfj8eJM1fk83hqWxCb1vYWyHBJLUZrYg031w0HKTF0IjlXK/2Ur5Yml3vBC
	HLe33M6sMhccgNdNCLcWiuKDJHbwQRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319838;
	b=tWzVryStMjqeLxFWUxmrNMlzXHwTTF5rj/V9lmS01ACTmV1aPxsJO5i8Z4gJUNGpOewwqC
	fek8G76keu2dUluWZqPDAXUNzYe4p73QQhCMCCZMsh3cRs+ppPSFwR5YGHbtcQmOChRCsb
	EMkIW3rOXw/Ct5ab6bErQPYGZx7YqaA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gEU23QJZ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C809944963;
	Sun, 13 Sep 2026 17:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0E51F0089A;
	Sun, 13 Sep 2026 17:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319837;
	bh=as3OPkNFsYYWKFBQO9tZASdaFQXU9TrMOPenfE/ek3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEU23QJZRHcX0hf20lXi65rqTmqiivKMAkC8NWufRT7WW+XbOERTEzf6LOBNj+o8T
	 KdT2r6OtpYD27Ng7Q+Mtlp1jDlRl5lYYltAWyx8puWG25O5SQTLk79wNHEEw33znUr
	 uRwJGhZbp2nM9BidpT2oc98FQAtiyvIjxACfE0xEnYZuV+KiEmk77q2lMdO+mKC8n+
	 UTRrz7j85k3xK4VbbWGOH/rphd0YXZa7iWF0dEiiGGODzKFevfGLMmWzz776B+acKc
	 MTB+wmuAUkZggR2syAibirXfUBPQLBfUVferBLJ6EWSxUU8MtnRqSnxVRL7eAvqq34
	 ftqdznGyrAZAA==
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
Subject: [RFC PATCH v2 8/8] mm/damon/core-kunit: test invalid damos filter commits
Date: Sun, 13 Sep 2026 10:17:05 -0700
Message-ID: <20260913171706.103052-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171706.103052-1-sj@kernel.org>
References: <20260913171706.103052-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: q91dzr5wi1so7qedxhqttnfcatsimuye
X-Rspamd-Queue-Id: 7A69A140002
X-HE-Tag: 1789319838-288154
X-HE-Meta: U2FsdGVkX19UOXVp0OgTTdh64ndv/BMOY3+fkSGW4K8L13z8I6465g2jlT0B168HaPqMy3MZMmUrbL7unAbUwiqKBvEGq8m2mu9z6pcthKokYiGz1GWsJYujnW5q+Q4OF/b4wQ75+XI8+p6U1Zu682J2mOWKKw5B2PXgNdK3qEA+4D2/+HV0f8VQ0Q+SMvlCyxBMZZCzur7bOSNVrKIy3xSKW29/yqXqeFwEXgGquXn+GugAsoChThmK/Lo18QA/Ug8/CAD1HBqku9yEGQFcmw2ABODGg1lyaG5VTT3tJBJKyjKAOU3u9CaZ85xxj5cQxiWFUpjf1rRycLoHfVfZDNF5eJFcqxpC46abtznaMUUJpVKkA76TnvBu4GVOwuHEkjZc7t+L/cUVu+ohztoOCWOkYKGMtw+aW9/nOeg3HRkk/edDgTR3UEN0HD9Eauj2dADn+OcSgrfn1o8CiPdY7QBKqbhfIysYRcFXT7AUK1TaKe3lZSTPpGnHUVrPuCGUgxwIkrDaluH/8wEhC+uLJBrlPAjRbwRX7ZhnOK4tCdXocXHyJZ7/QpGJWgY5hfGanNloMnhrHM+Hid4TYECyY7RgWtTQ+OyGS/ZMjHDUZHCHYBVGMPJM1hy3UOrDqxYtDc5BykRp3Ys0ehzegmtorwY2uZh30UQw6GguyqG0K/S7+IVs/Dt/YtukNdaEFnp6Xs1ACOuV+5NZS438TloryFPbE4LaD++yK5ZUv03RkRK3TuSDy9zGbX+hxGujFkNhvSZZPFv+RMD+OKmWFgWRVKYckuUMF4lJ063yM18DBGh2rEtRu6tLj+GkHivnKJsduJNrhZB8JQ+p2VmrEc5uMKp9rwy5OCmlDZ40oOa3xhT/kDO1iORyJh9GPEmvMWSpCCZKLOfNHGcDH64D+kp9Nf5Sh7MRO3M8CJyJ7Q+cZ3Pvc+NSBcnN/jJoGIlKnNgSigoAntfLJu6vAYczs5o
 WITCVuEL
 KOaIDuv1+b95jrhSgdQ4rZQK6VOxJMcWA6/8i/bVKwEgrAopQ+gL1A3hUMWbNnyinUNJoe43om+sJRkhDGyDJo6BAVbtUq9dJUadljAYUK+XPDYLjLXqb5m6/W6Q2JpJob6rGAlR7SrJEPng3HvRnjQpIjgGA0iISqZwe40Eut46RtXOYZQ4rvwofqV8DvNvkIA+WiMdWfaYfaMT9bUlIX9t7qykykpdzWxy2pIcUIMEJNe0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test cases for testing the validation of damos filter arguments in
commit time.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c9941f3bfb42b..5da84caf4124d 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1195,6 +1195,13 @@ static void damos_test_commit_filter(struct kunit *test)
 			.allow = false,
 			.sz_range = {.min = 234, .max = 345},
 			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+			.matching = false,
+			.allow = false,
+			.sz_range = {.min = 456, .max = 123},
+			}, true);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_UNMAPPED,
@@ -1208,6 +1215,13 @@ static void damos_test_commit_filter(struct kunit *test)
 			.allow = false,
 			.addr_range = {.start = 456, .end = 567},
 			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_ADDR,
+			.matching = false,
+			.allow = false,
+			.addr_range = {.start = 567, .end = 456},
+			}, true);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_TARGET,
-- 
2.47.3

