Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E210BCCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99868E0016; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0C08E0015; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE488E0016; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7A18E0018
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4110014024C
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:45 +0000 (UTC)
X-FDA: 84062854050.21.D0276BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AEBA51C0004
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9Qs0SVq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021243; a=rsa-sha256;
	cv=none;
	b=NQ+uafGepOb+3TwG4ivhS46KzxslbyPehfaHnK6/Za4GVdMp+A8AmD+F5EPnZqeCxn2uIr
	6y/biIEgeu9TDj59hdQxsqV4/o1wy5JqjRyquJXWqx2WyiA9CXT9ySh96Y8Y9kidrjuo4r
	Q+L/ibrkr9IHQnohdXjtgJPLU5v6vGo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9Qs0SVq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxSsPmumQtyDYdsPL9QaIpjIsGTS2mm1NL8gQSvk/m4=;
	b=79tPTVgGcbRFCXZiW4y9dtKV4zaSppK645mlU6ZP2797KqFiMnV1xKXQqvXhpB3Yf5rAPd
	wsWYJ+TZrlxjJtRXReplWegcb0u0L9LFk2P/kO+rLwyIlK5JFJh1Em7ahXn286Zu6Zd8yA
	A7y0+nr3WlRx8jBdt4FHwxtf8HXFYo0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 367C5601FF;
	Sat,  1 Nov 2025 18:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD677C116C6;
	Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021242;
	bh=7DGmc3I+5nR3iT/IUWCpGRBq8NOcMAe9aK8+QNZZPkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9Qs0SVqVhQ+cgTpUUlxG5QlAQukPmjmxt6eZXHcyaU3l9KUJtW09FWDRDcfT0Rr6
	 9+CFFebpcb2rwBWvOGieJzSUGdHSJOwYvDvyFcqoZOzLTX2qNFaBgTXoR+jkAD15MN
	 r1SNi9xKeePBufxbAMqfuFxfzKTWCtScyMfK6ee6Jo++FdHxttENFVYZa/3JXtdYSf
	 iZzlr3E+xOnNca6wscC0ot5/Mk2SinVlANgjDOIGUwnUlBcNwebF17q9mVUXnBv02b
	 S0j9Gwh+W48r/aC9lIi1VLYMz9MYluQoYZYCfs2q81gx7Vu+rIBFGrruYT8/Tn6mS/
	 09N3b7/ZLMuyg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 21/22] mm/damon/tests/core-kunit: remove unnecessary damon_ctx variable on damon_test_split_at()
Date: Sat,  1 Nov 2025 11:20:15 -0700
Message-ID: <20251101182021.74868-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AEBA51C0004
X-Stat-Signature: aqsod1zcdmskii1psm49sa5zrjw4apk9
X-HE-Tag: 1762021243-575121
X-HE-Meta: U2FsdGVkX1/UVAQ1lSYayZQyHDLtRflw3O5TAdssIZDqxm5GTy71XfwOZ2KQocJQehB2pj+6M1g4FXFUa1n0nyDQeGinEahqN16JxJu9e6n/4mdPu9DlDR34Z44hUMYQqlpTufXNVcbet8AmE/6fHROTGTpxbF8Bia1bxc08UmER4LmgbVSQD/7yDDrTeh6H90OOTir25z87EU4IRGVluqEQAEQAQk7fSH5VlB8K6meCuYrZAdGl8apmGSKN70n0MiLYHvUQQNJg10mWKu+labTSKI2vQu5YSIFCdX2+VcOfMZXvAmAtslR4W3isRk529Xm/QGsl6h6vY/dyM8p/S5U9oIA7XArb1ewKrtas6LWkXwefoTZo/EQ1Qk1UMOlswKOExR6W+UNomZWEIeF3Bk1qsU7hnryiRu0gmVvuqrKQcMsSHbtHSdrbZV3gBLGJG35Q1csFBKTwKoFh+XKn5t8/apHS6eBLI9MV5kDcCVAeWjQWL4DCwJjDkb1vKuMLrySfnI9rXeOHjhLK41njybs/1Ujq9vP1HAV06B2e8SMS1vuBJnlc9mf+MBFPwwiAsXkeuWfe8XUdXUkJKZapBHGFqC7k7Niu0+rQ0GTBE8UPin1dEPK+fKXFFycXABup6bY3t4jqPBamx2cvR0E2n0oplWxzH9lBH4XkrVTeQlQShk+hwc5/KFMeJ5gY26oQGq390G3BMpXgCg7zy7PBLGqbHa71ZYuuCDcJnw+QtzNs7ezsyfs/xEspMBjBdj2aMWHujNMfLURsOyPbE8ITdTLVQFdI6jii2Ay8dryM6bMWD9aB4w1QVP/WWgmDFuIdjC1IdxjpJGwc1ledfv0bDA9muq4mc2yngoUUOXRdpdHFqJTy7onRyigX94ch4y58Ean8aE/JEToxYeuX9HrzifSlvaLgh8LiwrZsVS5ZIJbvGqAc/FUFtSfH5VPbzN53GqOLAmsU/Z8ZTxDYqs0
 gLMBq7V3
 2ZDe20vNR8XZkptSzoeNuZnq5kYHdq2tKega9XrzS4KzUOOh65BzpzqIOqCAaeD8iN51gUqX90VfK582eT/peJB3w1sQB6LRT/MCJRy1+RVbgigkKOYRXpZLg36/0cqau0u4c3XRVL9A+FSfYVAjw/26VGS1Iu+VNCMb6xICanRWoPQ0eds/8+bJvL4CJywl3O1jOJLYMBjI+JRm30ytXZNvR2YcjfM+bXWIbAlDnVhmZZ8td9teHrCpQyESaJH6IIUOmQjzbP67yDbxPFGC12WnfZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_split_at() dynamically allocates a 'struct damon_ctx' object,
but it is not really being used in the code other than handling the
allocation failure and deallocating it at the end of the function.
Remove the unnecessary allocation and deallocation of the object.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a91d798caa70..726f593930e7 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -144,20 +144,14 @@ static void damon_test_aggregate(struct kunit *test)
 
 static void damon_test_split_at(struct kunit *test)
 {
-	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 	struct damon_region *r, *r_new;
 
-	if (!c)
-		kunit_skip(test, "ctx alloc fail");
 	t = damon_new_target();
-	if (!t) {
-		damon_destroy_ctx(c);
+	if (!t)
 		kunit_skip(test, "target alloc fail");
-	}
 	r = damon_new_region(0, 100);
 	if (!r) {
-		damon_destroy_ctx(c);
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
@@ -178,7 +172,6 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 
 	damon_free_target(t);
-	damon_destroy_ctx(c);
 }
 
 static void damon_test_merge_two(struct kunit *test)
-- 
2.47.3

