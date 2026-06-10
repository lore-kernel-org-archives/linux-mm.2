Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44EFCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9D16B0095; Wed, 10 Jun 2026 09:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB166B0098; Wed, 10 Jun 2026 09:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0686B0095; Wed, 10 Jun 2026 09:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B73DD6B0095
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:56:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61CB040010
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:56:00 +0000 (UTC)
X-FDA: 84864151680.07.37F63D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B639CC0009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rji3sPlq;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvTmgzWVeo+cgK/5Fasuy9LNL6Vq1lM40f7iFKommVk=;
	b=He8oxwysW2OloaGrW0JuYh/4kBrrKgv4d0Cx/GAL+eaUF1iJ2NznZEi4v3z+YAuc8/isfP
	gi4dozM+YHT9/HoFunYJ0P79Nt3etyrfQAJSC9v9iRFZU4+AxWjIo1dkXsa88VTLbpyeCB
	i+O4j2+6xU/r8/6u1F0BFAlw408W/uw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rji3sPlq;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099758;
	b=pCmq+7u/8ctyrJZvQkqeh3fha00j1t4pNPJ0nEJhZscRaSrkfqRBA5I97RkU2CYV/1n2Zu
	UFSMSMj6VAi1PAeYoT5VDaR7QrCIPLefn9LPRP6byk8hjxP2euQ39Js4Fp0y1FTVsFixBE
	gwFYEBneATTUHQIctfbA1zLT0JP4Ui8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E87344435;
	Wed, 10 Jun 2026 13:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4991F00893;
	Wed, 10 Jun 2026 13:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781099757;
	bh=wvTmgzWVeo+cgK/5Fasuy9LNL6Vq1lM40f7iFKommVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rji3sPlqTY8ctgiYIT9CS7Y49q7tR0k6yOM2EHlHJxaxhefyvT56Z4d8udfEUajwB
	 KvkJHgfh5cbOSx6wEKZATBQfuvsAxdepjtiqaS8Pyk7OOsGfM1rxlIhF5gho1hEhpv
	 1+DAxz5IqAUFViWqsp4HF4jFvKcHi3mjr0zRpGY+EZ3MmExzagpwV47KeSbjHTP1u3
	 I1z8PGc2/8prMVoAza0dBmaA32J10LmYm33c1lRvbOtXvJK9WJwg3bg8nGy9ROCoq+
	 O2x69ckdQhHNAtLTxPFtRNByinbhkTVSrezp8gN9HU8g71V4clAzrBS8cZa8w6zxeG
	 WyR3+cd1IFNww==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 4/6] samples/damon/mtier: handle damon_stop() failure
Date: Wed, 10 Jun 2026 06:55:42 -0700
Message-ID: <20260610135546.64943-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610135546.64943-1-sj@kernel.org>
References: <20260610135546.64943-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B639CC0009
X-Stat-Signature: q3aj1fnwjszgekujdpg3d97rjnmectxy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781099758-878068
X-HE-Meta: U2FsdGVkX1/3N3iVPlRWgX10fnj46kSkxWLVFxf8TJGsICl0ykh06N/W3lhlG70BHu31c3QqlSVThfTIgiufmjcVO34RTom2Y/adsLuWgLCEYMZBom1LxHCuvlT+IwfniFx7BKJqyyi0d7KfWKLEp1Au0G1mj2a3VUzL4xqsd2IZaiYRPDokX0aLoxqQKIwVurbJEquazrcvpCTNPj9POLg+oiWTQcB1+bmAryzk9w9euTu7AG+70j60v0MKLG9VwUkQgGkxgYJrjZXzOYMHCRfxUy/pOscIKR7JwzgsPF9DZoUa4gKYnHKQEn111qm+LBglZiA4G60k7atnunZB1MySYA8BeTVROzpq228kDYSQS6aH2RYBirabMRhN1KncDiupaSpm1qeLhhLp9pXQlT7sXSEdYKxkQGWmDWMvIPidIW9SWkgQzZHyjKzCr0xQpDBO1v5on5wfU/XK19mfuAfewJRK9NGnnJXIzHvmj9nUvSiKPpSGJiQOjKvnf9XElSGA31qzlAjbVLVlmRkJ7heq4ch4rvSQcPaeujDfjMRsABW224LlLN+caW1Ipsec9PSWF7YhPDKr9uLMlTGuzKAgShJ3TI9A/NzI/p+oSzd0VR1GPndGUmak9XeYjFLrFRuyz/B6LKHAJhaHaGTMVWN2nEnhUF3yiv81i28FhKl4WRUyHn+ClJ5LfOh3I8Z8U+aInWgKaJcgj0g3nVwUsL35jBaNfYnXvpVkrcTIpmCwXRqXEZ3SY8RK+nd16NlnYTLb+MjDSODBIbab+rs0T5ZBuKdsf9YPDr2M0RXgCm0AALX85Ds6HDjD8Os74wwSEjFInWydH4kBvGXMGcSsb8GzVCuE7S66xnKqzNC6SAIIrBWBBFOFuDzrDJ89HCA9+Dh06UifnSExUk6LHM4WAKOOnmygEB58eeIxBLz7xXsfSqozAGMZCR2jILyJK18YcfOdiqmFHhDsbTihwDj
 2aa2dBpD
 PQJQ7S6iAc9l/casUFbPLXhUPFrcmae0AWp3kyOC4aY9AOE4mYMyxRdqxeGQZrqpzOYNi4XsIJGdsKITSdEDDVT2eVWC1V+OfF2eGDscGFssOCJUFy+KXU2NYfZIvhp5nHTfYslVoMSQMbG8N/E8afeLdknyreALtrtrr+HEXC6+mM8/4a+DQ5aMxLUIE/oaT6vFqDqrTm3OUSly+x6voiwAyemaWOaBbRbmlfohVc+xWGpr5ZXAaz9bXlpi+BWgB3FfJaObdibko0LLmJF5/gpn/7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_mtier_stop() assumes its damon_stop() call will always
successfully stops the two DAMON contexts.  Hence it deallocates the two
DAMON contexts after the damon_stop() call.  However, if a given context
is already stopped, damon_stop() fails and returns an error while
letting the DAMON contexts that have not yet stopped keep running.  This
kind of unexpected early DAMON context stops could happen due to memory
allocation failures in kdamond_fn().  Because damon_sample_mtier_stop()
just deallocates all DAMON contexts with damon_target and damon_region
objects that are linked to the contexts, the execution of the unstopped
DAMON context (kdamond) ends up using the memory that freed
(use-after-free).  Fix the issue by separating the damon_stop() to be
invoked per context.

Note that DAMON_SYSFS also allows multiple DAMON contexts execution.
But, it calls damon_stop() for each context one by one.  Hence this
issue is only in mtier.

For the long term, it would be better to refactor damon_stop() to always
ensure stopping all contexts regardless of the failures in the middle.
Make this fix in the current way, though, to keep it simple and easy to
backport.  I will do the refactoring later.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260609014219.3013-1-sj@kernel.org

Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 66b591f2180fa..faaaaa12e6206 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -199,7 +199,8 @@ static int damon_sample_mtier_start(void)
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 2);
+	damon_stop(ctxs, 1);
+	damon_stop(&ctxs[1], 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }
-- 
2.47.3

