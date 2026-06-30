Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4FDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C36A6B00B4; Tue, 30 Jun 2026 00:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24CF06B00B5; Tue, 30 Jun 2026 00:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED5E6B00B6; Tue, 30 Jun 2026 00:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B871B6B00B4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CA5412034C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:31 +0000 (UTC)
X-FDA: 84935247222.16.3E95353
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A0A201C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AoTqBpXf;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792509;
	b=e/oPtZj4ayr2I7mF1u+tCj9yQ80DnERP9rcU+yXLRW5HjT5kApYjN6pzbWGc2pwUInenlR
	9MG6yjQYQ1q2UkLTltxoRYagojt7Pr3IL+nOBRyeJeNAlXJJzjt0p8Xx+j2HgYIlJBNpz3
	KI67PCINXewwez5Ece/oJr0MQMeG7NQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vShhMCQAtuGYJfXsoeN6dNb/QNuypPu+KUsP36UNyI=;
	b=GKSM9OeCssjWejLLa2AQOm/S6PphP6nfIpk08BEMMOoW27b9V7RfdgXFzBa+EId0KqA+uf
	hRwCx2dv2CR6JlSaf43t4rbYc3JghV1ySNq+AA2fj8tSsK+OVuEt7KDBtjqlrHv2qqfx/W
	r3wK7Wnv7Yu4sHvMXeQK0aIR9LwVYt0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AoTqBpXf;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69BB9600FC;
	Tue, 30 Jun 2026 04:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC731F00A3A;
	Tue, 30 Jun 2026 04:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792509;
	bh=0vShhMCQAtuGYJfXsoeN6dNb/QNuypPu+KUsP36UNyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoTqBpXfA1SnIuJuInvXJHen7E7pLq9KgPHik1JonfM8R0pt+g1M3TL1EQBG03gx8
	 H/GPs5LERuZhbb0hbmBO2xmw1GZ9M6SDcdFwJ2c3Rud+1HorUlOLChb1/a788z+OWV
	 yi+ydbXJnWVaL08NrgF7lBDdEpYwFat4bvUC8AmlyDjMqGfpAst4skyfRzfB+62ltJ
	 6vRDlauvnMA+nHDXuI3LpVlTep0ag+EFe4kNh88cc+BZtIeRJnPWSyeTu0qf3sEm0F
	 Z1m1FEaInWNLVIVuyy8qHzqvYm/6TgzR7MzUC4zK9B8tIwVsiOHjzNOuP45ej3dJSz
	 sy1NHW/a5T78Q==
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
Subject: [PATCH 11/18] mm/damon/tests/core-kunit: remove nr_accesses_bp setup and tests
Date: Mon, 29 Jun 2026 21:08:04 -0700
Message-ID: <20260630040812.149729-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o87s5ch7i1trhzbdghyow4qwb7xbbf1n
X-Rspam-User: 
X-Rspamd-Queue-Id: A0A201C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782792509-219000
X-HE-Meta: U2FsdGVkX18wQpHbIV/+mSYww/RR5d8rf9LBsObQKsUPsfsDJUsckDsuOI+m3axlEl3vfvo6UhSxRh9Ljh3cHJ4l0BLACfvwzjTh9jxeSoq0Tdyk86N+6uHjB63eQsG1dpkvJLYX3ujoWX6MEnKU7teB9BMZmGsuOD+W/8Gx+LdSEOuGU55/FKHGuSr309O3MBRU6weTZFW9CzKXJU/p0Kc6zEG9rtdL9iECOZLsklTw0wBbWA7929ZstEmvxeTgeRncgZvsrl9OYatbDdyEaQct2FKbt2bSEOZUNBYoy1hxoYI73fq4tg8sXrn+CbyXWydE1o8UQelbFCA/4gDY09DBVDi4iBzulCR6EOrKuv/KNhsWG9L4zBbX+ctwJShFnaPcC24OOZ2CX9pcOFpaD8xG4nmGK4OW0P3FWN/6MmJ46KJnevV4NYEfue6jfjPSOiwSxdemvMOH2tf3fBtXR78G9nTsxs4a8cYNk7YNdXzoS/cdSUg5XJFNrT7RaHlvzmqsQsUlFhgbOW0piJ2JG5h0w+wIQo6Cjja6oeXZu+7vRJGcbGHVMZSMPxNY+8fR2hhLh8Y2tWzmp4H07WILms7eIVnFQIJPiuh+8jMdSq/FD+7I/HJvWf6UR/BGOvbmjXKXNW2706S1+hrFQYCuWKWZ47JQ8ilBdAOiXh+Vp2VUcjthOgkNV5pGoeINUldfkVFdFBqhwSJwUWx9B0aty1326X0Z9/GH0icUGlcEfiGpsq8It8vIz31+FVpZYnT3jOHwi+/FUxpNWSYHtitjVy3vQ4McSve6VFrS1bcLzK8dUXeQkCJ/+TFPrPOBocw1Cjck0h8oCM7hb7fRGs41EPBGZC5VRbWlQx1F1tVJ5qk47JsC6dPLA98Z0fsZbk0KPwTnUPqkk0tzHKN/jck5FkG+8RKMKn3UhfO0/B6L8rwkkK12FbQaaiZsRD2SbzCv1wr3sbdrf13EWln+GU/
 JMpA8sPN
 F8qH79tKUP3sEZY++BVQ5NrRbqMmzuNq4ZdQYZqGvt8P8VCuHVrHg1rb90JL13XTSCCJdE2fC8bgrEfM92xERapXA9fxdb5RmyCQa/Ucb7ZbzpMCs5gaD68kGuV5eBc22VMRhOJnBGU3LlOkR6p5C543JsHBiq0ANDPYrWZqOY7dX19GI57e15aT6ViEZpYH4pCYCaNbkj00SqGuz6fZmDrTxIaqGiEoyV8xxN1BObuMLark0qNbnBikXbks4CYanQ0Fq0tgjlY+WG7jrLZtGj5ef+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core unit tests set up nr_accesses_bp for representing realistic
damon_region, and also test the field.  nr_acceses_bp is no longer being
used for a real use case.  Remove the setup and tests.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ff13d1b1cbc94..e1d22abfbbc22 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -114,7 +114,6 @@ static void damon_test_aggregate(struct kunit *test)
 				kunit_skip(test, "region alloc fail");
 			}
 			r->nr_accesses = accesses[it][ir];
-			r->nr_accesses_bp = accesses[it][ir] * 10000;
 			damon_add_region(r, t);
 		}
 		it++;
@@ -151,7 +150,6 @@ static void damon_test_split_at(struct kunit *test)
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
-	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
 	r->age = 10;
@@ -164,7 +162,6 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r_new->ar.start, 25ul);
 	KUNIT_EXPECT_EQ(test, r_new->ar.end, 100ul);
 
-	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
@@ -187,7 +184,6 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "region alloc fail");
 	}
 	r->nr_accesses = 10;
-	r->nr_accesses_bp = 100000;
 	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
@@ -196,7 +192,6 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "second region alloc fail");
 	}
 	r2->nr_accesses = 20;
-	r2->nr_accesses_bp = 200000;
 	r2->age = 21;
 	damon_add_region(r2, t);
 
@@ -204,7 +199,6 @@ static void damon_test_merge_two(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
-	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, 160000u);
 	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
@@ -252,7 +246,6 @@ static void damon_test_merge_regions_of(struct kunit *test)
 			kunit_skip(test, "region alloc fail");
 		}
 		r->nr_accesses = nrs[i];
-		r->nr_accesses_bp = nrs[i] * 10000;
 		damon_add_region(r, t);
 	}
 
@@ -615,7 +608,6 @@ static void damon_test_update_monitoring_result(struct kunit *test)
 		kunit_skip(test, "region alloc fail");
 
 	r->nr_accesses = 15;
-	r->nr_accesses_bp = 150000;
 	r->age = 20;
 
 	new_attrs = (struct damon_attrs){
-- 
2.47.3

