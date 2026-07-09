Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3C2C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0C36B0098; Thu,  9 Jul 2026 10:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A0E6B009B; Thu,  9 Jul 2026 10:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2853D6B0099; Thu,  9 Jul 2026 10:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 076836B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 961D21A019C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
X-FDA: 84969412416.11.C3EDC6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id DC70BA0012
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wr/8IaT1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605966;
	b=ZUQJb8UVMljFaaJ+2n4K87sJkAc1G3uC0rfKvPBx8DsiyjQ0SLbdwwuFigyGsT6JFuqZVm
	tBqIc9byKE4JI0rQkeLFMz8NyCD3M9f4mQJBqS4mNn1LO6OG0/YHshUVI48Qgb1+i7P2He
	mWUyILpqMo/EadUDD107jjIdcT5pdoI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wr/8IaT1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Afvkxg7JDGHDzuDLSPibRSpczK7Yb0J9zCK+iiS9Hlc=;
	b=IPz8lQMU9PByxe/kvIMuc7N37SWG8UV+467QVLJTPQMJrh0j7mU2EqD+V5ALQTEui54pX7
	+8lVhNZPlZ7wqAhPL2AqQ0TQXbrGUI+oCIxLedtDAJklX08iayjJZHJDZWHyvHYAdzi0T1
	cxZY4G/MAsph0qR7us8+aZxyacZ7fEs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80CA361386;
	Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152B91F00A3A;
	Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605966;
	bh=Afvkxg7JDGHDzuDLSPibRSpczK7Yb0J9zCK+iiS9Hlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wr/8IaT1YIogiEeE+7VXNxpm5ekZswKIm/Y6AkWJ4zeAYVC0AUKr2TxCMlSwHKT1+
	 HbzWenPOjTFMNfIGdIx3Da0MH54BjfNfRxqfrnSwEfJDtd4Qnot5+gAOLSyKd4xpv4
	 H3O2uuJnPGtUt9teMEmtMliN5k0hGm6iLsvh49SwTLrUb/uqRS2+9GZxdf3acq3pO4
	 jMfrfzi7zsh/YNedPD3XJUpEm8imhKoebaMrnRXoYlBRWoMUxO9FrAdCzPPbfbh6qo
	 lQRyZ8z/yePxPhyenAHgmBZ7nQKbSoQpjtQbXy5LjitT3xedRDkGkLMdX6Lnbuy+Gp
	 +knKLaXO+3PjA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 07/19] mm/damon/core: use abs_diff() instead of abs()
Date: Thu,  9 Jul 2026 07:05:45 -0700
Message-ID: <20260709140600.90950-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC70BA0012
X-Rspam-User: 
X-Stat-Signature: 9rjdmprygx11hubws1cxrmnf4t4xpswj
X-Rspamd-Server: rspam03
X-HE-Tag: 1783605966-899282
X-HE-Meta: U2FsdGVkX18s7RcUg5/dDXV7yPwkrmFHjQUrWfQ4v37KimENt1uy5T1EwTD+rPvric97ewvckUhogeh2UfbIoOJbb6DEkoQkB8V7g8Jn2i1iHwwkAeYZpkMfA8wd/3ydYtm/x/Blka6cpOqkJMc0lqzk46SOshnO6NKd06FVjK9WWMN8ssUmetTmVROPuLWZVeruXYDwxrvBZ25b1t0gBRxilj9LDiGNN4242Mtynz9ZejVyGh+IvCGxK1Oc92gNfkMv9cn3eN6tvosMYV0JIdRhSMyCKMmmqddPdz/DpAm6g9T3XS+t16seVsoCirmD9ymI1+ao8s2zhVctNTBQlW8KYMzHV2JE4YciczOMHYnjfwH+t3+sT7BUAsgEJ0QLAZHcSHwLsL+QDFYCYMrcX2LFA2FYiUKxXaD1Aed1XF5zxdkh5NfEmyGlUOn3U741hkGqvXsKy2uz7sQ/T0gT8BjVyeB9eAIRPTcyTz2e9QHGzxxhmZY8L3g9MFcWldVqbZWKTeEeSwp0qxhRztk8gVyHma9yoWmxVDRBDy7RoZw775GS4N48s8HcCiiK2lbncMu+XR4N7S4TYXIi9OcxH8DNOCxVXrBBzxtWEsjqj6uJ+NdgCCLASu/ren0B8UxiukJ+TuhlZBnqzLXAnRXOWcBHB1PIvyKG0i7pRUq58jRc+Ei7IA/jVWN0E+FmIowYSZ+hWhc/5UPtyLKPnJn1YXmbG+n3k6Cr3pJYFbmn5bgiGs2v8VBjgEvmbjop3znqeQ/QYWpsp/q0/O7belrBQhTAw1OMgYuxzJEp3OFTqxdLaqKbqfZxsAKM4ccVlAzIyA4ceeCtJj+QdmSO3Ut2DAiwvltWxYLCfBo0tpgvCKq6e6BJdkyyPZ8kuBfLOV67mSUIO+2j4ivApmO6757S9Edn3PK23DdYovWQTTPco1/JCl5crAONkoZaZ27vf7koVx3Q9iGJn8KGXCmUrFu
 iJUdQLR9
 hht83Y9QXQv6o56p70p68cjlV1YImNBBRQiame/Dw/ZOKs6D2ILiAEVKzF1eV1DDpY3xKynt1AESM2fzhNwvmL9vBJVov4IExnJUd+q8VWp5ds82VZRaf5qmE2uhTxknTLJoR7TlorrP5ncoutM2vx4TYzqcYwySYrnTvuVU4f/kkUhbR8K9sVFPh7gfMTbeL9MfhBPYvQ/6Qra/PRxH0mArDL9fiaLZ5XCwzdiTSkWwfYPI3wWMF0iSDkM6wG4o8h7US1bB3gSDJ+3hiMg1u4TbzEw==
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

