Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D5DCCD19F
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 21:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B758E0023; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1BCF8E0002; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DE78E0023; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64FB28E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10D7C878AE
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:45 +0000 (UTC)
X-FDA: 84005314890.29.A90CCB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 73B9140005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gsh5UHOg;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760651263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmySYY4gEzu6PYtRkSbj0lIXOesTM0g9j3/U9iARDHk=;
	b=hcoDkvi11YfczBtfPXKJfweXbfA8uj0YnU5elRdDJz+pva+iU3/JFk01WzExPBIynE8r7Z
	Ukvp7ZkJ9CeBbxMPLtRhzwe5o8tnW0QKZf5qse6nNi2dKftLYMJ7qFHCHwBFziX/PtRv3f
	S9ZBcCTDbtyErff8mTUVu4dUqBS0Rgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760651263; a=rsa-sha256;
	cv=none;
	b=7HniKSBSgUj/9u+yzKNtuZsvPy3JETZrUu8iPHPtUG5Msoq1aF0YVnWoL0jiNEnwqp1+8j
	c8jFizbxoUCe0C2BHJUCMytqV/r0GIArUOsWhmNcgy3jBoqtK+Fc7e38IPBjoYzvLM4gzY
	MQpfQE/4nvUSh3MMMgTjpk/I/8rvC7s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gsh5UHOg;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EAA0864135;
	Thu, 16 Oct 2025 21:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B18C116C6;
	Thu, 16 Oct 2025 21:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760651262;
	bh=ViqZA824hPzHAr3rZEOCt3wrknWYvtKIZnCeGd320Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsh5UHOg/Bco/JPzss70ISncmMJwcSYWtb3xemxYvxxYWa5LeiC+wFrgNFnGGW28Y
	 KhBeaYy98TjBckzy0vJrgB32mLyg2y0Q0VD62w4Ipzq8VF0JHr4HpXiUgA8g6MrLzv
	 icPFHtiPDEmW45+Zybr3NyYgJlO5T4jycUbYxoBI3KyUY/XA5f8lsCw+LnIix3YOfe
	 cUvwMkPY2CM0LcHzYQN/GHRSrYK+Sya+wLlKvlEi60UVSo3IDVDhk0XJ/N1xQr84Wv
	 kQVzY7FCS1Mqva+PgvhvGtqzLU6pi1v6KieOXo9SKK660woehbnCSQU9ezkoObpQy+
	 dIY34Vzv/r04w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	bijan311@gmail.com,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/5] mm/damon/sysfs: test commit input against realistic destination
Date: Thu, 16 Oct 2025 14:47:29 -0700
Message-ID: <20251016214736.84286-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251016214736.84286-1-sj@kernel.org>
References: <20251016214736.84286-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: fog5ourme83dhypgqpyp1n16eckxmybc
X-Rspam-User: 
X-Rspamd-Queue-Id: 73B9140005
X-HE-Tag: 1760651263-47188
X-HE-Meta: U2FsdGVkX1+QFif3mDQE6bFlne3uktQOBIueTM79PKq8tPyULD/u/rXDc+ELrjd43R4DWh9vKipSFK5SqKNqxf2Rgksdrm0jOh8Xlrl8SF+su9DXTlYJisD/eq0wmvIi3iDPOH0se3UMkGdr0izXLXbaOjpVLcSMz0c1NPlbe5PwcUxFiaowIUkjtK1wq3mXWI4m8jl+vtoGswLj49cHT5lI1lG44fWe6P4GC+14BroyA9hkeWFMDVNoxjVcDDqddBMC9PR163Qml0nxyAYC6gw0WKb71n+bdVcCtreKy+5YNlpyGNGCjCKSgkFlqePl0hXHOSft/UW3AW+KnaEPK81jedBVtVbMPFBdZMNUapvuttfpgvFrEWVBA/UZuSBYfaLLLa0PPV1p4Maxmtlid7dpByc36/ubSJfh8j7V+P2ZWHcQbqHMPJYn5FXS5j0TggPEBstE4JyYlRdC+6xYZFBft+9qADCJAMOOsndPDQGoFbsjgKJhmJqNHTD6tF/0BlT3GZpz3oQYmpZrGTi57YXYqKLlNXG9qIqCYSz/ofDDvXuK9m6qnq2vDO8agQZMU+CHiQrG7WqTQykV/vrB2Zzh9N7KPY8G7rIFGo76O1bQRdUW2abYcI5A8+pQWOS3UINaMke7ATD54p+KtlkZsJMh0UWJI5lrn2CGBvTUrX5dD9JK4QFpczre6raThZaJFewqqW+37UmV2flZfGf7bLqViH77lueIGPbF0N0epPTSTY3x2IGry/mOzhJIw7RFLpIYXQhlo65WHNzsgo30DP8OTllcN9zUYODDI+lpLbI0gxPB14cbdL+Z997B3YeJirW+2IwdK38awRdg3J9SkCQyQoIJgnry93wh2MlI51CSoLDm7TrLdtfJK+QQGezwcLSRG04JWEZNtfDxVJ3FSlFDFcVNyX43d7DD/cRcs4ExuyPS0PObciMvCxM0Y55bkNOKS1ICp5OFtHzYSZV
 RK0IIOq7
 sAn9kAbguScLdQvmzQVRRw7heh+JnStFZSXbk5OXeVl539KuV3A5NFyg2Y6W+fEWmU3PyExJqZ4B5yz5rY/wivLOJENWh0EI/vo4rYtwz9R0KDH4hxPoF/m6CqBji9vpNhot+hlg+m10rpp8yTOy8FQGhrcCuTCury+skj8s9J/Esg6PqpRAhdOudT7EreTYbAkSgftUjKDdlY1JjY3jE1EdqCDiZVoznq72E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface tests if given online parameters update request is
valid, by committing those using the DAMON kernel API, to a test-purpose
destination context.  The test-purpose destination context is
constructed using damon_new_ctx(), so it has no target, no scheme.

If a source target has obsolete field set, the test-purpose commit will
fail because damon_commit_targets() fails when there is a source
obsolete target that cannot find its matching destination target.  DAMON
sysfs interface is not letting users set the field for now, so there is
no problem.  However, a following commit will support that.  Also there
could be similar future changes that making commit fails based on
current context structure.

Make the test purpose commit destination context similar to the current
running one, by committing the running one to the test purpose context,
before doing the real test-purpose commit.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index dfdf69bdbbd3..6848437b86af 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1680,6 +1680,26 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 static struct damon_ctx *damon_sysfs_build_ctx(
 		struct damon_sysfs_context *sys_ctx);
 
+/*
+ * Return a new damon_ctx for testing new parameters to commit.
+ */
+static struct damon_ctx *damon_sysfs_new_test_ctx(
+		struct damon_ctx *running_ctx)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return NULL;
+	err = damon_commit_ctx(test_ctx, running_ctx);
+	if (err) {
+		damon_destroy_ctx(test_ctx);
+		return NULL;
+	}
+	return test_ctx;
+}
+
 /*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
@@ -1701,7 +1721,7 @@ static int damon_sysfs_commit_input(void *data)
 	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
-	test_ctx = damon_new_ctx();
+	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
 	if (!test_ctx)
 		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
-- 
2.47.3

