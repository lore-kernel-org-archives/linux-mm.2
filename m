Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5C5C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6646B009B; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66EAC6B009F; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5352D6B009B; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 310826B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 782D5A03BA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:22 +0000 (UTC)
X-FDA: 85223469324.26.6ED8DEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E36F4100002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eomREd/j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eomREd/j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654940;
	b=SgllpEJ2OnxXxlQvhU2uClNcOza33v3HBR7t4Hl2qPqSqft6zFAoJBUiAmaMll5WxsSzvF
	d5eQX9qo5eIS53M5QGYogARGP5hzI/SMqPaaZ5OLUEu0LMCrs+iRqReyW/eTui1sVGDRDR
	NuEVHrfrnH/k3F9oVn650Dnz1py8Q3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6dSI4kuA6F6vgFBpIvecMt6EtgI2oZu6oc7TQA5lks=;
	b=hEWcUjRIhtcDAtg9tj5N0hfKYb8a0rwUYGqpgMLLVNun7nQdKkf48thP8ZjSaQM1ob1q0y
	hjUhUsMzODVmtH0mtgPIuWyoGkuKwbXjUNVpA3XzQ2fPfDN8A67s1639B7qJ72lbxUKjE6
	ohGj44VYHyT9YFRq/TspFw9wjxznz2g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80B7E60211;
	Thu, 17 Sep 2026 14:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1026B1F0089C;
	Thu, 17 Sep 2026 14:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654940;
	bh=w6dSI4kuA6F6vgFBpIvecMt6EtgI2oZu6oc7TQA5lks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eomREd/jqdFfEgIBTkw87GKHW8I0aNQbEYgqPC+XhMuQfF2kvqLQHuoDRkVWKW8Um
	 h/kWbDGPyuzYBZ9C0uO7GVGW9GkEayqY6gWg8tx/KLP0ob8veYHtN+HgVlApO0Nt/8
	 pashGIOoSOk27LBlcMGTWhdXFRBKtPQoIGzHA19aJ3BcK86worHf/tRgXwAfjZoy+9
	 H+Lkytu5tfiU2+lMFJRsJ+SEDBGG8vVOUKTzOxEegmp4KRpGy03h5ob5Di7vvErmuO
	 rlRcia4W1GnwI5pHxpDwSEpNjcLXIY6tmJhMcCLGum7zrR+2OitqMapuYcDiQXwIyN
	 Qj4Qyt1OaS6Cw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/10] mm/damon/core: document damon_call()/damon_start() race hang issue
Date: Thu, 17 Sep 2026 07:22:03 -0700
Message-ID: <20260917142210.90829-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E36F4100002
X-Stat-Signature: og3xj8g88khsyzjmjw74d7ctxphmqahe
X-Rspamd-Server: rspam01
X-HE-Tag: 1789654940-857506
X-HE-Meta: U2FsdGVkX18ue50FBU7FEAfMgKlT0x8wd3QrKn6lsDE5tvO7TUYukEXo12Ww2jHlY7aFbZCIAvlRX0qY1Yjb5Fad0dfVw2NeZ4oEqWDiS9WtUIhHGDeMUgQlwkA7UmrIUMLA5sMq2S8l/p6XMq+SVD++2UJMoNCl1rFx4Imsu6uUIVuLF+XW+WL7T07n2KvqlfLFR8yt8YWVwRuY5NtqNDk4TQX/he2yl6JfleAIE9DCdRRfVKH++fyBa+U/p0eyHizO7DqyUj0H784kjFQv5BDpVeJLTCYHiWcImiLKWVzc2w+zLMz1B3HOYbRVNkiL9bIlYesn2hss9TNYSRbtW2xGRevVqh0E/4pINw/drJHEeytvB7SS7S+m2abqRmcL5Es3wK6YgBGpf5cIsmvdAWYSP7mlxwDLvv+H4UfGYxeaZMhueTc92OREgUAkzWBAN7MhS1NLFaGa3uzbccd6wIseefGJsATFlDVS4hHFHGeF4S3OLzJhhG4lwYxIV2f8Mh69vsvZ7UsQ1ubqtJr+64rmbBmcCZOp1ucRksBcd0/eXh89+nPmvU0iWWlfKb2mqHiWqF2vffX0qqEVfcAbY8TLSf2slarfs8L/wG6grmvpj7rMK6DMHUxZcmmqMl0Cnmq9LklJUoBYen/wD7+Lz5PKYGJoCv37NfBYrATnKFKZF4aGjo4C1dpaHQ2pKSeyv2eZGmXEGFfR9m5jzZaNrQUD3iEWyvx0YNyVQquzFI8/Ho8s0kH6q8AOPv2t3kQdm67DL/lTJASSPXxpK7tdD9wJw7hGrWKwGN0DXYpN8gLzuUBTACDNiw1nfio0JuuC9vaJpHSE5E9R5MP23pbm9+FFrfOLjx6fHY6WJ7kglXT6i1PO4Ndr9+HJvPRQ5sunOTHR1EtnhmAVvV9BAztXgn8FhRj4vdxXgJ6UFU7SM01f+TdfAaGYb3pC4lkS2AGqA0/RV85GGjeLLE0wi7X
 58d7agkn
 QtQPthd6w6TmadNs0s5h9PPFE3OWnlBJ/9KTvRvoK5I+0L3n3KyknjxEOEpXYK2rDXBncVBFzGSm6lw/Mtvro7lOoLt+5KmrGVSmRjBczjZ+lwyB/X72nrhusGZBjocyVhXzd+/mLJdJ7T6GDk39Di5Y2V3VYnppMPwUpZrQXeyP0CRZ9IlQARMjM+m1bqb4f0Bt6lDsCH9V0C0Z6fwLMGDuiF2/PW1suyNTfxoNW8L1T1zVgeFQ5uucb7d7bsEKlvrOuaRUiY3or0SXr92e/DKyJYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's suppose damon_start() and damon_call() are executed in parallel
for the same DAMON context.  Then, damon_call() could show
ctx->damon_calls_obsolete set while ctx->kdamond is unset.  If
damon_start() sets ctx->kdamond before damon_call() starts the
cancelling, damon_call() can indefinitely hang.  No DAMON API caller
does such parallel execution of damon_start() and damon_call(), so the
issue doesn't exist.  But who knows what will happen in future.  Add a
clarification comment for caution.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c63b09d4a2d0d..2258b72da7a78 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2258,6 +2258,9 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
  *
  * When this function is failed, the @ctx is guaranteed to be stopped.
  *
+ * This function should not be called in parallel to damon_start() for the
+ * @ctx.  In the case, this function could indefinitely hang.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
-- 
2.47.3

