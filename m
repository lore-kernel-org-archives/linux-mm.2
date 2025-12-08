Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD4BED3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A656B0029; Mon,  8 Dec 2025 01:30:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904E86B002A; Mon,  8 Dec 2025 01:30:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A8B6B002B; Mon,  8 Dec 2025 01:30:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6176B0029
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F3BC1609B4
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:17 +0000 (UTC)
X-FDA: 84195329274.24.415D681
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 79B0F140007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1fWbwwd;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175415; a=rsa-sha256;
	cv=none;
	b=yHXnNQBe36sTcMXG2yR2k/CkS1jjxEh9w0AHPglC7t0+lEGx89MwjJJQsdv/N89XXju6UZ
	oXJJxQ2yZybOa4PCp2NkjvUzJUyy0PPHlairHkZnKtZPsdlS0G8V/bxgP2u/qxHiIQBvj/
	+OJoXect+TFh/Q5KouFV4ziS8xuNl0I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQSs9LTEhorD4UhSgBfgmXxhWTHY7JK2fb8PZiXm07E=;
	b=SdjaAFEX+DZGQtQ0i7UnwqDX6QwhLJkAnXUB4uCysyxWRBJgwYjWWFIeHw4hcDI+ZNHP2Q
	zq34+wLCFyhNKA7DvwLs2BAFA+iBGLH/phwf24NBINZPAtvHpnG03NWBpj26FgWcSUIjBc
	HrYwWTSgwFfNNxePtkJ4yTe8ECJhSwI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1fWbwwd;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C385444AB;
	Mon,  8 Dec 2025 06:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297D2C19421;
	Mon,  8 Dec 2025 06:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175415;
	bh=CBKpePU8YzS24DYStTop8saXN/aFoeKY8A1ZQfy6x5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1fWbwwdL26H7CSpT1GiJ3AXdvHU2IoXrM7xZolVsqDyKPyOqF/8dNFIB3QywHqBy
	 4YIGrJZ1XhOsJiXFJ5xEvJ2qURr2ItUpG13MwlQ4tvtts08nLfjyFn4LlDzJRnrJS4
	 ApOrQasTN5tCXMWznZl364rhzFlGYVy8MdJqxyUjqQyyBK2OorUA6VEC07qdSIITgh
	 46i5xwRlJK+r9e/oj6UeoEjJQxu6Anm/BS+ZX7IXz/23Xcz2xocIbTZl6JqYCfzyxY
	 j6+Kms2homn/pE2wPiIPeOcGFX0tZKx34/pbbECHjMI6wpFuRfDUSzXLSppPb98TGd
	 zp1YsLwz1jrmA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 17/37] mm/damon/core: commit damon_sample_filters
Date: Sun,  7 Dec 2025 22:29:21 -0800
Message-ID: <20251208062943.68824-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 79B0F140007
X-Stat-Signature: tyhm4by4pet1fj9akehba41rjc7y87fk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765175415-336204
X-HE-Meta: U2FsdGVkX1/77PFe3pTSPGom30Qn3/dcW7tZ6Q3YSre4Ct0+TZ7MqTDTz/or2vtNQAGWI42EiUXpPsR9MkO1/Wxz7CnxTtBgsUsdCbhjtihlFAxuTYX6YUSzcmyGIG3PbkqcgFDCwjUfXCWKdofy7zseHbLP7hwB+eWGkhBbOY41FUE3CY/wts7YCqOJvyNEi45PaSubtlDEw4mRcQoiqCMc9fTIRnSof1b69g4Yb7XwTPkofZgrOWa2rebHEzBOVyiW06coAeij5Inzs1QOJJIJLJYZduYI2diHVAiebJZKo3oRFYz5mtGYZ2EmzEnPWEaV5CWyvwCqOXPY9YFJc0XjC0yvrBYMS5w3kl2J2264N9gpH2SL+l9tp3GFn5PVa1Z1x3di85NFXgVcfT/Zu/ioIaOYhJFhrU9J2g/u6M7m8+32s5xkwPmsD24rPHhKoLDe9OBIOn2y51c1DMUHL81CteFx3rSonJfTBKKsWJTAa6TIEl32PsYH3QLh0jQApYKiuaJKMiPjp9CJDrgabHlXyyEt3qHD8YxmScr7Q2mYMIz4m83jdd8mNAHJOb0xJz3ehlZ0uVWsR0zfJ0ljW8eo6yiHUfFw7ausIHNVoc2RzBANdSBtt9e0Z1p3KZjoz2CJC6pUjhOkcplBF+gyBrwQ7pCAKCHRpElLdx8CuX1kA2m1FTOoDezrKohoQYwRID+ctSZ/5f9xDFRFhOJ0Pw3pMHozy+hrP/hzftbaZRB1LMrVH78SqZZyeQExEQFhO1KVzmNokhjNSVWD1ccoSkA6WltCFtRmXV7ZIaI6+j1yagrHeB1AZkOCWTq1gzKVFFkVdFzaLVn+h/3N0vKgWNVMGtF91xtBVhC5WCRpEzNifYZeCM0gBQ2g/4tgnGvbaADBPrLJqSaF8PWMt+HSgHFxlQ2x5rDC8Acgqaom3LU3t4ZlXoaAUo9WTeEYcvudd/8Al9w9ynscXZmSwTa
 ZthoDk1a
 olTQiUh03aWizMjL+Mn0sZKk4MhuKCDCiUYwTmNQ3dwE44+yrXCWhWikeJc6nbci5XeIb+apmP067Gnw5/1pBUGlAXzNqW24ghbua64UlvbrB6RnjvBC9UhFohpjSfVpL69TR0kyybG3yhguMTwcXzWYxHV9zdy6DrkhCiHG0Glv42bLoMIxeETjR/OFIQkFqWNzKLxiHJoX69+W3wTdIl3oPIeexDKwyqYhpvx1Tb189Ig0up3wztuuWHyKQuagXFtf+ru3prgR4wDIhl89SfEFLTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The data structure for access sample results filtering is not supported
on the online parameters update function.  Hence the feature cannot be
used with the online parameters update.  Add the support.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4b98473eef84..d952a833a05e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -573,6 +573,19 @@ void damon_destroy_sample_filter(struct damon_sample_filter *f,
 	damon_free_sample_filter(f);
 }
 
+static struct damon_sample_filter *damon_nth_sample_filter(int n,
+		struct damon_sample_control *ctrl)
+{
+	struct damon_sample_filter *f;
+	int i = 0;
+
+	damon_for_each_sample_filter(f, ctrl) {
+		if (i++ == n)
+			return f;
+	}
+	return NULL;
+}
+
 struct damon_ctx *damon_new_ctx(void)
 {
 	struct damon_ctx *ctx;
@@ -1290,6 +1303,67 @@ static int damon_commit_targets(
 	return 0;
 }
 
+static int damon_commit_sample_filter_arg(struct damon_sample_filter *dst,
+		struct damon_sample_filter *src)
+{
+	switch (src->type) {
+	case DAMON_FILTER_TYPE_CPUMASK:
+		dst->cpumask = src->cpumask;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static int damon_commit_sample_filter(struct damon_sample_filter *dst,
+		struct damon_sample_filter *src)
+{
+	int err;
+
+	err = damon_commit_sample_filter_arg(dst, src);
+	if (err)
+		return err;
+	dst->matching = src->matching;
+	dst->allow = src->allow;
+	return 0;
+}
+
+static int damon_commit_sample_filters(struct damon_sample_control *dst,
+		struct damon_sample_control *src)
+{
+	struct damon_sample_filter *dst_filter, *next, *src_filter, *new_filter;
+	int i = 0, j = 0, err;
+
+	damon_for_each_sample_filter_safe(dst_filter, next, dst) {
+		src_filter = damon_nth_sample_filter(i++, src);
+		if (src_filter) {
+			err = damon_commit_sample_filter(dst_filter,
+					src_filter);
+			if (err)
+				return err;
+		} else {
+			damon_destroy_sample_filter(dst_filter, dst);
+		}
+	}
+
+	damon_for_each_sample_filter_safe(src_filter, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_filter = damon_new_sample_filter(
+				src_filter->type, src_filter->matching,
+				src_filter->allow);
+		if (!new_filter)
+			return -ENOMEM;
+		err = damon_commit_sample_filter_arg(new_filter, src_filter);
+		if (err)
+			return err;
+		damon_add_sample_filter(dst, new_filter);
+	}
+	return 0;
+}
+
 static bool damon_primitives_enabled_invalid(
 		struct damon_primitives_enabled *config)
 {
@@ -1304,7 +1378,7 @@ static int damon_commit_sample_control(
 		return -EINVAL;
 
 	dst->primitives_enabled = src->primitives_enabled;
-	return 0;
+	return damon_commit_sample_filters(dst, src);
 }
 
 /**
-- 
2.47.3

