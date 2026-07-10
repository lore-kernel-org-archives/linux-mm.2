Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C2DFC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8926B009B; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204486B0096; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F0B6B009B; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE48E6B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B2E21A02DE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
X-FDA: 84970969566.12.FDCD46A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B40FF160011
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hD6ITAf2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Afvkxg7JDGHDzuDLSPibRSpczK7Yb0J9zCK+iiS9Hlc=;
	b=rigRTtzgwxARyf1g6egP0YmVl84aM5dse7taQ99jAgHDo9cz4GMLdvW6SZeg3MnWlQqZhI
	1cn8gfHK2Nlp3BK9pIf1NpObWEFyDsOZ73HLXpssa7VQPh/0jg9Szn2h5lMZ89foIuarEH
	qpKQHP6b3ERJK6fsxhjXJJ/4JnQ+MUY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hD6ITAf2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643041;
	b=dCVcvL5xlNzrfwmIpCN1Bp5cidU3dNAfUBl7ruKfCt/FkF1pKbTOrTM/lydK7odypjDbOb
	s9/hAEeNbTRTsjl5LaB2Hr1nPHclD8G6+jfebJqYV6Xu6gmv/4z7ZpKPQ6k95uE1vG5Kgb
	O772GPBUnw6QM/nttYdm292vOg5BYLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DD416138A;
	Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57DC1F00A3A;
	Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643041;
	bh=Afvkxg7JDGHDzuDLSPibRSpczK7Yb0J9zCK+iiS9Hlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hD6ITAf2Zsiq8wZRypCUXKFrsfJY4IQ6OnuTGPbEYiz14+mnkxjghaK5xr9tRT7lC
	 ChZ8K96sA+5MyIkWz/g1+K5i5m+3W+z3tImfbalH4vLvwKILa2afVqPw4XCjrzYYdO
	 nAuPUR+H8/whyTesGqLo3EJkHQzqxFGAN0+yObygU8CWpKM5Kj7yhjm904b2USZmFw
	 /A7we/IgtIzXX+fCy+vEmdNPuil2LDRqyOVrvgvhf2At5JVaBq/nkzBASFRtZ69w7r
	 BujozuOoXMLiAZM4xWduozWYsRqoxQp/vdBbuLdF5FCdCDk3bgeUIZIX0IriNk/B5c
	 53VJuvUbqNlHQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 07/19] mm/damon/core: use abs_diff() instead of abs()
Date: Thu,  9 Jul 2026 17:23:33 -0700
Message-ID: <20260710002349.111414-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B40FF160011
X-Stat-Signature: 6d1thsfksb37g1gsrm9ing7tidg9714n
X-Rspam-User: 
X-HE-Tag: 1783643041-319114
X-HE-Meta: U2FsdGVkX1/WsyYErjrR48g3ZeePphBG2ZZkldVsR3zDBepCLdsxOFQsggVKRI3ZZDz59jJoiGzmPemAZJfIlQby9D627uu1QdY6KxbjUIrubQkA+9ebdpJkApr2G3ZhIATvO88NbFLMb3cV1XGBkwTiIvNO+4AX6iZTCMAlwcE72yPpRy/aTu7td8XRxe4dpcRfpVJHyhRQkVXHq8fNhg9OBXKBvT9v5BLilOQIWGAXyURF0jG22Il0RndaPsP66gq6j7bnk/x8S6ZHgGeQgB8WrRCr/ov1r86IUbg8ih/+Z7Ta+x5JibyHoUKJEnjEi/gahvpJbyOiJK9SAhH6PkC+sqLG1I3axCQwDJKkXhiJh6g7dSGivKCWE9xk/0YgQy0yt7BFonJYlb9VqBYwa2sAUxM55q/WtIJu7KNj8CxFBsow39DyQ49vuzzd9sDQ3vIJIUX2GAw2TRTKKXXhye9Ji3k7cIfzyLq6G0WsKoC/hUzqcCQp4J0nl4wO7Y6dbLZHI76HcFPfwhUwJUpEVRq6NtCniUpRdW55aKHDUGm2aQ9uNL+wyTeXuSp6zVZW+Cwbm5BpWf8VRTxfHZEpHVoB6yXRultmjNcerCutJyXs7ezBRxA51gEyKrrpHcHPa7zww7B8LUk6eRA50tpkZQ2NDzGXLon2Lj/J3gUqBPtiZgDPgEBxCjfTBmK5+qDrvOOLRMnJ4IBE1cSPEgtHlhATnpgMgeA0vo93fLAu5aBBNnmMH6dU4KJX1vb479z8dQT8OuhgfXU9/6H34Plvd0OwfGqTOm3XWOh2WAvTkCWzymxXJq3/18tT9Na0pFqU5O+Z7S6Lx0QSsqXtjzmH38qBtCCrq+C1v2nZKuL6Jznr8oDPbk4PM/Gx59G7tfAMSf1lViucN18uOALzi5K7mmLin4UWm7Tc0DKR7SFCvt8ufMLlD3IZ365G05rxj5EIYlnY9k588EYwO5gpOEM
 ++R5e7Vs
 EsnmnMzr+TdSmzfPq89pnbVvgddn0IbUvzTyFKH+Oo3S0p1JKR3HlcpmDKuFerRMlDoyFMnFy/APeRemfxj9ucNXFwqlrhJQ7lRZwr3nuxJTsWY4HGU4/Xi+j7brBwuwO4H10P/EhvVAgMLAgf826j+qFgyeDDzN35VCFFrBVQtuyCjciVHnH2aYcWgwaev5svOxzqTulhSCXuSSDuGkkegjpIC9/e2KzPPj8YHtrkviu3iM0EqvVYw7lTYV/vBlFwnaxAy2eavfvEQU9rQBa6sJfgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use of abs() in damon_merge_regions_of() could cause a silent integer
overflow since the macro casts unsigned int to signed int.  It is
unlikely to have such a large value for nr_accesses.  Even though it
happens, the user impact is just degraded monitoring results.  Users
showing bad monitoring results for weird setup is quite trivial.  But
the code is obviously wrong.  Use abs_diff() instead.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260705213817.100841-1-sj@kernel.org/

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index fea97399b5754..4c7e8a12a9b67 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3261,7 +3261,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
+		if (abs_diff(r->nr_accesses, r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
 			r->age = 0;
@@ -3269,7 +3269,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 			r->age++;
 
 		if (prev && prev->ar.end == r->ar.start &&
-		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
+		    abs_diff(prev->nr_accesses, r->nr_accesses) <= thres &&
 		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
 			damon_merge_two_regions(t, prev, r);
 		else
-- 
2.47.3

