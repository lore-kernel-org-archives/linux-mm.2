Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D81CC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5C36B0088; Mon, 31 Aug 2026 12:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6859B6B008A; Mon, 31 Aug 2026 12:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574C16B008C; Mon, 31 Aug 2026 12:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7246B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:37:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A604E1C0261
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:37:57 +0000 (UTC)
X-FDA: 85162121394.18.60D4337
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id E450380006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:37:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZfHGGUG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788194275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9afrDjj3OiNFQNFlcWPaAJKUnSQO06bnnIAXSq7zMg=;
	b=T9MKabpbLCmkVLqBpCvjyvzWeh8ZaSaheXLq4zQ20W5BcJFnyqahXZPPZkp1cC46WYkLKc
	SzrorpJWPUha6UhM/JMage7EsCmAfg7GJhF2mVcfghVv/7rXYqkaZNi/11jKhPtSoyC525
	0e0DTlhiqfPRb/XdQUWUVYdIk3sxivU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788194275;
	b=aZWWaMb5MChFR9rzYmNcboQMXUQ2ol2e09cd4qSqNihw//UAu+UdaqITKF7EuTVLseYOai
	qZhg2sptZNZ0bug7iGx2iJOpmNAClfAYRB1+MWgmp8WQG/YJ/LuE/ojWwOqu2+NFsR7HT9
	7ElLDJ3l0ILlei4Ooo1QAYQDTo7WrKQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZfHGGUG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-46a4870536fso1139376fac.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194275; x=1788799075; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q9afrDjj3OiNFQNFlcWPaAJKUnSQO06bnnIAXSq7zMg=;
        b=PZfHGGUGCg61V4fLXJWv2dTQvtVzOnRzJnjJOJQLKmjKOhh9zMpD5z3MnCoTzLWv+O
         1quJx+e1OgcZrKZ6GPmTm1GxtHxwzOIzks5rvMYTTkbz92DVg0tGZJwYmahpfp89s6En
         BkBwD9syTpkHqE4Rm4va7U5Or4945ytqn1WlO8jVrl0Er18VSP8SX2CC+ICpOtVqBNKR
         r1pFvrMU7xvJ6VOOcz850Szs59+oTjGNWSk4cHv4wHwmrAzytlGZGUsq8dEcLRB3uN3d
         gKNldp5l5lUyV4coq9vyRimywZlwH3BUUQjTDLks4g3cnssFIVPW/TjuV/UZgFZfFciv
         xIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194275; x=1788799075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q9afrDjj3OiNFQNFlcWPaAJKUnSQO06bnnIAXSq7zMg=;
        b=f0db7cUPooF70W7dlJwAl5RNmpDtJR5r46Xim3mOZrpL5CMXe12ZCiubSJozyfeDbv
         q44YPUayo3kWp90iXKOjM2jDuh8d+KbY6ax9ZddLPtncIRFaeqUBgMwq4bvESXJu8u/a
         S76fgU+8V/puenvKO1gWrcZZJi0fMLUguAa1v20tG6FfkYspoM8GNsvwycgddHSTaYcl
         JarakjVwA3hx2duQymumJODhkchUHdmLR2yb4cMYZweOAgmR3e6D5BnTCBuv5o5stmKs
         8g72ITtwAZP/eWXsBQBDMT0lEdxCrS/2V0HZUDLDWZ8vzgq9VMJBMtVVEKqzLBxMms+1
         DeSA==
X-Forwarded-Encrypted: i=1; AHgh+RqcgiHqm+WrzE2r3fv6nSCDBamUUPSDIy+erkBXFmxyqWBM9BoS/sCThAbpij/kHR+l8zVze28YIA==@kvack.org
X-Gm-Message-State: AFuF++ndf0d8sShfUrRDkkL0NRBJDELDwXvfZn/31caQpQ1+vHuONmWD
	tBwOq4H14N02UYZr7tLJQQJQItgz7oSuOQ92tm9ngsxQhBlRu5J3gJrg
X-Gm-Gg: AR+sD109IOZkr0kL3gTxr6qFJTugNJ7kIPHm6rKLd711KQFmys7xiTA3Zx6QFdsV+NM
	nMTkyXn5CuJOCn9mKeI3+54eJVwkGiAM4U9yJvLJGYNAbnjmGxM92Gw8jjFeOwuhuKih+3mXvAP
	T6xk993E/waOH686uMk7Hg0ElWsSMV6MTUARLseAV1494OWgQzyvEmCBKPv6SYXssfVYdgSAIR3
	1hy9J0bxqLVGp6X/l3EQrKoUX6mDOyKdVqRC9DMt1noY+QGdpz8mskcLjG5nN0hRWPXYVT5eOs/
	mTwcT1xLeVCst8YdwrysS5UnOHlOjtUQrzU9t8qthcxeJT8mL6hMTu9q+16/b9b1fkh2tP6u8fV
	axoiE67F4gqNs+sGdmJR8DzBNGp4HUnVxP8E+ObX8eQJEti4QRONOAy4i32ynswBw30l8FULbly
	lpVlavKPFcrqvTaSeDlbkMMc/E4YdthX9OfkZlV7CQbPW4drOBkzCC3SKB9D6YJz1Vc5csFCh9i
	R/LvdUAKmD2xjRpoQ==
X-Received: by 2002:a05:6808:1921:b0:4b1:b83a:5878 with SMTP id 5614622812f47-4b5b81e2f8emr2412176b6e.14.1788194274813;
        Mon, 31 Aug 2026 09:37:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b3a1995f2fsm8537880b6e.11.2026.08.31.09.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:54 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 1/7] mm/memcontrol: flatten try_charge_memcg control flow
Date: Mon, 31 Aug 2026 09:37:45 -0700
Message-ID: <20260831163752.2193337-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E450380006
X-Stat-Signature: ygajuq5upqiy7oqnqz66i1x61fc71ohh
X-Rspam-User: 
X-HE-Tag: 1788194275-396732
X-HE-Meta: U2FsdGVkX1982vXpEYCKt9Ef+qdyIfzv6VLMDhARAkSN17TW3vdU0XcdHm7xwfGwGQPDqNie33kVjdvRg15/wLWHTAxiRcOD0uqTVbFFZb6JQaXaqdQk5WBkqj1tj5fW0yx+X4tTD6P+TeUeDaCJ1fBssK/84SrwQF4c59iWmnGYtfzGPFFE3GtkWvTWWEo1fgYLPnQKxbB3hcKoYixkmdbG5Zv9R9bGYB4TQSqt4su3AURtNLuP+Sl+rRJT0CCGm/qSgxP4rsdS9PN0X1v4BMwULNJ+Ct5rg3yqmIq7HwWNPBOegjqcvfoKsq7PDOlMYK7KRLjFxfms63pgK6A4Bvh2X9FVYAUYWqRh7tIbj2ba0UZTKBaKfbtV+M+BaFxPkSM83Oc7HQayRKdh2PjiwjMy6PbXOGbzuKdnahAQUgRZYghELJU4mXknMnNWMX1JTvMVzNIwEzj7oUAkcc9tBhaWwVCMXZy9wM5RcWf1nCu0K8ndBOoW12LfadeFc7dG3ikg4kqay8PFQgyVhnA0z6nF59TmBiZS8IXV2I6RatHP0KMzTfK9aFxU8DBnXZW/ndc8rDYw8pCFrHyblPezp6rpF1efEWONjK7Od07VhbFHCWkde1gd69NiZGAyo+EpDDFmcahYWHt6Z9RXiQQTPRIOhhOUeZniotZ3hqU0fiCMA/STPnoNnlYN65oyP7z+664KwhmNWYjvGzs5drFXcCDtW0mcE2C6ETBOsA4sui/6XrH7Bp53zDjkAQo9mxb/OUdFzprTXw7SMm2/wJvZl+6Kig8W7HYrWXVm+S7FPZbbkCno+nEPQWBqK6ouCzPeinq0ytvTHlX3Pp6MJ/G1lv91BuweiY5AQSdKP3QRXt7ujw1wnDmr6na4aoXVdyWZWK6QaReJri2/wEwzXYxdvxUep7sj3IlCL2YbAL0am+L67lTR65cDBjJjQKvwmUQhuOfOHFAuCENydbZiGvs
 mkZq+V9U
 NGTlWFq/9ov6n5zPGj282tGBPn2CbqwIBhySv/dpXj7sgvJ7iiEmdYvYcCDA+P+wDWO4pZHJVCehCcxC4F1erD8/6hgiHpJmFkRIRAwUmJmE6risfQNoQNFd3JOQVeMLueJw+xXEjwLkn2Gvr3vDg40eGWW2A2P+B0zGnS7ucrNt6t5/iqjcD6MBPonQjEECWg1Y9zCsEqp1BZqgGwIg5ObcsJIJDDVL8QpRbRH3TxipmnuyFb3YHGa2agE8ojf+dlSsrTIEzeBVjc7dvVv8XNHRI9MUvMKDC0I564Xohs6CbT23Y0Zc1Roqxm2Q6FyX+wZIRxZpdLfqvQzpbE9Y3Zgq4UUWTqJKsb/gLVQN/v+BXnd74mRgDsC2hCQgtd3Z3v1F9v0ODht0hEx7HC6744FNgTR7B3Q0HDkmiQH5XmSmmCdYhJQKQRMjh6YXfinOjxPELLJkqv0V6rc8G0fLYK0yAIMWX7MohXTPq/a7uPJTc9V1uN9civG77sHBh9pteLjeCOpkjXN1MkBdu/8zYylufZQxdcInIwEO66xQ+DRb6GDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bf829638524b5..93c2fa04da4fd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2679,18 +2679,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.0-Meta


