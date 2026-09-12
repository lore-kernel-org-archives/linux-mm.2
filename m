Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFBFCC88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3CDB6B009D; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976046B009F; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B27C6B00A0; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA066B009D
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A003E1604CA
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:20 +0000 (UTC)
X-FDA: 85206071160.05.BE8ADAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1FB1E180002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gkYDo3z4;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789240699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as3OPkNFsYYWKFBQO9tZASdaFQXU9TrMOPenfE/ek3g=;
	b=38G/7TzoYPDCvdoOC0N0sMeZE2PHmI1BG96ZYr86CieME70MolpzJKiKtBsmavuidmSzDx
	AFRi+YDpK94m9sttHLZYuwsRAEALB8JZwNzU/Seqjyjte1MiqDNHmRySmFnowR0VLGhC1h
	90ip653lKCUoZVXFXqurVQlKDeT0q6s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gkYDo3z4;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789240699;
	b=rqzdeDbmMv2WivSZOejJPzV/TWy4hBtSmGjkBbhtckzxeSVKaKVB6+WM6v75iSyHGiUDkf
	uCZtURpfDMK0kCKJKZVT51IREi0t93oMPbmh/nMV9KVXXWuJcyqp2S4aDAJ8kXcFW0WIj3
	zbx5CaZFT5qzFTlH9SB2BnMh1yrawJU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 751144451C;
	Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194621F00893;
	Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789240698;
	bh=as3OPkNFsYYWKFBQO9tZASdaFQXU9TrMOPenfE/ek3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkYDo3z4bVAwkbLlvRSugF93EZpKUfMq3gUGH37PieSO6VIDLJYlCn6C0IiGcVIt3
	 hAAyoIGNJWpMGfCVAIjItVbz1vcOKq+TdYEsXUlD7aTEIcVkCM2iLrgIE7tv4MXNF9
	 gjkWjd6c40ame6/dA9N1nJ05DPvf5PyToguj2EfbcUxweZ73jtv5d24MVkRD8flkW+
	 F/krcEHjJtPhkE7/3wlsp/Ymk7ge/iULGRdIAaS7GF6BexM39ZpCxyhbd1e1indNE8
	 XdA5j6tn6UEtSGR0TpEkXUnl3XQAE+BTpsezXsJBmosazSneAA1IMsiQihEzzNhWPj
	 qcDcUk/EGVgEQ==
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
Subject: [RFC PATCH 8/8] mm/damon/core-kunit: test invalid damos filter commits
Date: Sat, 12 Sep 2026 12:18:06 -0700
Message-ID: <20260912191807.138502-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912191807.138502-1-sj@kernel.org>
References: <20260912191807.138502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rtsp33wu8stae7abo7s3916y38ifwu9k
X-Rspamd-Queue-Id: 1FB1E180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789240698-473520
X-HE-Meta: U2FsdGVkX18rJvIJbCI3lKyCInTrzVw3bKh0Aj0ik4lqKnXufO2Oa9zi7XbwZVVyM1lBhtiiPkSrPIBIo28xcf0IjeS9wuqm60hlqEwp1pBjR2oDHNZFGx+6L1K/czd/ZqkYnfs2u1ELcKj3Nz/DcpUfdaOsZdfdqAn9sV/fyrOODJtKcJMjcZbJNnUdZqTFLscUhbvJrznZYrjg4nOg8md65Cp3ssu7LCctOUZ/8cpG/EAMgEN8OL/H5XskZoWUAzMwR0Z/ZlB15J1RYeOk/ZwcQ0XROQ4z2JvahQdv9o6RphFzn1irUWDhZA2ANvwOue9UROwPNbiUfVm5e/udUzRpNZPkHMg1D2+7wOuD1Odx8iLZJ0ZSTd8JMuZO0GDuyCGqAXPWLUVbV1KlGpY4ebtM+sRshKJxjxI2e63mzIslWbZScc8imP7jKe140zRvD4fnh3/6OPgK+YPIA2I2uhuSK0z5V1jKWscYT/v18M/w4zQpFCzGv7g4uOnONZnL7htYMATkXPdOfuVCRE3L6je9zDlsolsqOLLKHOH5Rvs9wpnWOdFvaG86CgHNsdUETPiK5/1Svh177DzgsElvYUENS3nW1+ddQK70vDqBSjXRNsi6hA8OXHxSdUwjhnNqYtF74OscQVzeDbB5Q4cFMYEsDWgepav22LefuOmr+/kS53x6Vq6EqRogxfivmSRK4U+4MWWc4oTcX/rEFNAcTRKVPNQdkchTMissbNRa4FtyvRX1h6DXP1jDePxtzIKn7Qr3hSwEfHgRdkQvF+i95X4sz4pv1lwFs6u/SWXfG9GchrG5JVJyPMmai4kyobxAZYvov/IUo+Xzd8LGNq4w43BmJ50dP5BTyKBlWjSdctncig2zFz0Tu4avVXxzpNQn9CEnL3rvuO84OdJtzWAC7nVoq1yhzYVK8BJhVAXV7e9jKBv8USnCC0eEF5U0+ZACNHyh1dz73DOAsUK1cIl
 E0oeArr/
 h7u7zNx8TR2kIAuaHnHY2VQ3oPE7pfDPjR2c77hgZj53x1V5eGKKMP2ndePnffTCPfs3lxRgBIeg5ZBU71Q4awa9Y8wdVCUfXgPZzNJD9HOncBdj+pJY1ia/WaF368Qx/G+rnXF91iD36DdiQA13WtnFtgOUddjwtVLsryTjmAlYM6YIUd17gQUf51ov6XAQADp6fkvugstcHU/Y5UnXrZiMKzncIVdwp+LM9tUsSoMOis/I=
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

