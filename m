Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 881B0CAC587
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D65E8E0009; Thu, 11 Sep 2025 22:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882908E0001; Thu, 11 Sep 2025 22:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC968E0009; Thu, 11 Sep 2025 22:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 555868E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:40:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B388C0679
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:40:03 +0000 (UTC)
X-FDA: 83879043486.02.526EC5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6C48920008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:40:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jknMytDh;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757644801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EiTaYr9jivRF46510pqhm5QTOzAr9Qowh3zQ6BHzRY=;
	b=37bQRKZdqy+2nyS6lYTWhbqE7IoZEysLsc/5Jgh38VRP2AkJho8WY5K7azWggDw43sYFik
	rW77/AUr4y+vXjBb3p2Yn85a3xeLZQCezhfqIjGppElR1mwZOHwP3CTvQDuGVjExtrNNFU
	yTMVFHXgpDyMhjI5zk2av1PgAbsWFBY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jknMytDh;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757644801; a=rsa-sha256;
	cv=none;
	b=iOofrYZg6qfcwkXjUc+7T9n8Mc9FLY3qFlzaxZnl2ad5LPrXPeSI+l+kO0hCS2uHgKFVED
	ENZXfRtD5TDFnA9I2Y43s3AE0CO0ZqLFrWOXAXMJVMqvm5H3GTRK4Z4BtpjclQ9VoP//1r
	nH6mtJl0w8lpkUwekX30iIncJX2Ghbo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76679450F8;
	Fri, 12 Sep 2025 02:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF9CC4CEF1;
	Fri, 12 Sep 2025 02:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757644800;
	bh=4uQscG4mYr4g+dERacoLlCCtLcp3o3ScovLzzqmdpAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jknMytDhn7nH98vCJ2dHC23SjVhQsA7hX+cBhn4LpIR29BoB46OaU5hnMA1/Qzgo9
	 nqj+qbImVWHWeUwPwbCQReUvKwxq89ndr53Z2gXBpCFQl2J4S0zkQo0OPuWvgnjuUL
	 7czcLLS3K1iZjTLeysSyJJGWTkmWo+HPNar+zD7snR/EhsfupSTmRtMpVjfQJnkkd5
	 AUvtI55YVd0NxkNULBTEWG8CDdyzULDgdmO78DOe2uPNFYWt+UV68i61p5MficOXMX
	 eKGaW5X4GzuKz+bZAqTAXUga9ErisdgD3M4JpamvPRA0i0gkJzDIO9XxAZ+fPUjoy2
	 N2iNk7JcRnxMg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 7/7] samples/damon/mtier: use damon_initialized()
Date: Thu, 11 Sep 2025 19:39:46 -0700
Message-Id: <20250912023946.62337-8-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250912023946.62337-1-sj@kernel.org>
References: <20250912023946.62337-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C48920008
X-Rspamd-Server: rspam05
X-Stat-Signature: 93dg9acocf5r77mpe7u4ews8zezagj46
X-Rspam-User: 
X-HE-Tag: 1757644801-344858
X-HE-Meta: U2FsdGVkX18Akh9YLFtqT+go5eiW98bwEWK0wsLj9CXEjsDmesOEvxSnEUxmZAjq+q4+t/7/51dm2kPer8FrgcBQ4RvO01zcwxxlJO5UKJ/+k4WKELWmwGVbqlwu62xxdFdv87Rky4qKJe/dcYCYNPSQzHnZ3XWD5ZVfxHlcE7kfuNRUXOrEceMn1apSTThWfiAZ/2wnanFwvkoltNLGWfkk35LNWGNPeZp4U8ghL0nG2dS0YB6j1QVn3VPuDOsAnU3aB7g7Ckz6V3YMKyCUr2gr+g3Am/+e846TeUcVIj2lMXOwsWNub8iQuyDA8rsBZtHgF6JqrNkZJhRMlcvyLBP0Y6jKLcWHPzqf9if2qZZfsGdljGCpQV4PFSbLAS3ttjbaQEOGNabM7GZjWDaexm1QXfkGAQLalW/d/1asYS7qq3fdas/RMZCPYgqqt1hu6fqWnosabDcDsKSjhj3grERbdxXiZWUsm3sOfsorL+XFX9/oZorUIvqZJQvdk7nRD+HqIBA9VAPlMMsJsqLVvWsBG3+caDUvEoRLDwNjBozhdxLbnefJwrac66niH0Qjo1TPFhK2XDjVdGB1PpwZYUuKZe4jJ/tjBwjRLq1R9derpopb21DN/fHyZ3Y5BbPph+dAP26b3QcXjYjhdhv47OZwjGZcbLJT6HhXDQqUtEeR+TpdDHxFQdCblibdvbkBTt+RyTXr51J8ZJ/2pVy7wr22nXfDyRXmDnvBPjHPONQ0tP4NU4bptxIri4ytXETCji5z5KjqidktMPYN/4wSYaBIUfIU6OGZHNQ8fqWKWkZhY3MYJuuXV+BDMi0gZrNMEbFnNMjDyaqfDEMcexwcbobLH5GkpYaBeJfDF589r1bmgtidyOQ+Q4okmvVTe4sRUpgj2cyjmeZUnNHGHVd03r71IIJagtUUILLEpzIyXSgyeTcgFGKJNJuysyuemMcfNOQ8RXKiBz/zc+tRF7c
 5mMuomr3
 ROKArCDHFV+2Fmt+3IaXrLjw5Cj2rFk12ofpw2C96h6hTz6/Z8nzYzsNTfKnqi05Sorra+mSNeXt7bxXYd+Qfy5spSm5mWtImrgkkyQx55iRENLx+wmZhMRuwUKBUZjoliaJZ0pcMVkljgm0T4GnTnw4Sj2Lv1IL8SBMbc477Hq/GH/61clz7EgBKGf4RVi/JLmEOiO5yFxkX/E7nHVI8hTCt+ZsXflVjbKblbif6M0K65xdhX6+4JgraA0PeFLrEd7vc/YrqGYPt1gfeWXZn9kOGiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_mtier is assuming DAMON is ready to use in module_init
time, and uses its own hack to see if it is the time.  Use
damon_initialized(), which is a way for seeing if DAMON is ready to be
used that is more reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index beaf36657dea..775838a23d93 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -193,8 +193,6 @@ static void damon_sample_mtier_stop(void)
 	damon_destroy_ctx(ctxs[1]);
 }
 
-static bool init_called;
-
 static int damon_sample_mtier_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -208,7 +206,7 @@ static int damon_sample_mtier_enable_store(
 	if (enabled == is_enabled)
 		return 0;
 
-	if (!init_called)
+	if (!damon_initialized())
 		return 0;
 
 	if (enabled) {
@@ -225,7 +223,12 @@ static int __init damon_sample_mtier_init(void)
 {
 	int err = 0;
 
-	init_called = true;
+	if (!damon_initialized()) {
+		if (enabled)
+			enabled = false;
+		return -ENOMEM;
+	}
+
 	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)
-- 
2.39.5

