Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 464D2CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1C86B0005; Mon, 18 May 2026 15:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253D76B0088; Mon, 18 May 2026 15:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1426F6B008C; Mon, 18 May 2026 15:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF5876B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:12:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 787A0C32AD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:04 +0000 (UTC)
X-FDA: 84781485768.30.34EC510
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 63D5C180013
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXdqNT6M;
	spf=pass (imf06.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779131522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HdgjcDSkJV3GKfKlbUQSZ57rr2po/MRqPRPN+0UqD+s=;
	b=5NNmaEE7GtWRWQOMPIObXxgDjEP3Cz2hllmyzG3nbYG8mUou97FxPBMmlLylXil1H91ENV
	JVxGDbnHu3XaJVrvQP4/sm+i4WtOqMRtCyZ2vPgdsip2ejDu0OOA6S6vzrzuKWpadkSmGh
	46Npcp8WpBrKDbZKe2ZOzBrAT3fl2t4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXdqNT6M;
	spf=pass (imf06.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779131522; a=rsa-sha256;
	cv=none;
	b=cMqlsRGi+jrsTOjps8KasDi+SVa5KRwd6RPxXQB1PHfEuYC1ZVi//owjyOJyWVn2ZG/UwI
	ZkO3wOr7t0PjJuEaNO6WOCKizqp6riSOyo8LGb/Uw3UgVBQungMW4xVlgVm0ZG1h19E+6m
	6WKaeOpm7cdq8XkqRIpdiqrMn8D8+Zg=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-44dd5cb0f81so2471271f8f.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 12:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779131521; x=1779736321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HdgjcDSkJV3GKfKlbUQSZ57rr2po/MRqPRPN+0UqD+s=;
        b=sXdqNT6MkNvsrgZ0+k+mokzMBcz91A/wHsuXMaRZMTBfM++j0eeW0IKQ4su3r7cfRM
         bYtIk/f2IMnCUoY3r1lru6l3ODoIBLlERnCu/S5O4jH4yrSQCXvGV43zU7T3I7RZrRNl
         CnKtO8rqF20XDGooz4KgasARzHWbYfqcyVpX8KhUcDV+AdVkwhZtC+uQxf2V7JjxoLR9
         KKqPRyE7WNLha6Iv0k2J/U52iO65MHmDL8Uj8aQo0h4io7jdaICBDkbWBxmDP0UYctHb
         FuPTB/AiyLUvsRuD42RhspLgW2pxO/kPPScH4FlHs4ZCVefEMH7fx0vGdBDQwPMy5RGO
         gtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779131521; x=1779736321;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HdgjcDSkJV3GKfKlbUQSZ57rr2po/MRqPRPN+0UqD+s=;
        b=AL3co1J40U/DRk4SWdKEvPZ+gOOd+7JRLxoKlGhvm0neS1nzXJbOWwBY1EgEclDzTf
         2CKqv6D78EyNzKOFb8O4w+YMsQiWFdIFFR+mJf7iSjKMBnMlSSwvfj+fxZyM94WoIrN1
         Qi8cGGuEetaNUcbbN0uB3s4tzXLcxLpgduyslqKIEs1rFnHu1eF6iUMZn2F5s6EfHw/R
         BIxCfJYLKEVqNd+TpOCefRRRDBXOL4uL/eYBBwxjWgDqrSYbvvPLffaP0my2euHpXLWJ
         vq4OfmZ3haeRoQBTufVgz80f9k+4u/vQ5FUdkBE5xAmQ2mYhHDL7qRAAZuIfIrWLXTE6
         l2Cg==
X-Forwarded-Encrypted: i=1; AFNElJ/G9hZYMjWLMxuoSG3IbEUGHeM9wPwRXqTiAWORlAvlRdUB8incZhhbY4ZsPC6BJNA4/1fPfJkLPw==@kvack.org
X-Gm-Message-State: AOJu0Yyp1gzlytRwTC6DnIDWks36ZMIcxY0g9tqXiY07jtimWXXQCLL0
	2wSlboLSrJfDx+zt2NvK+Vy5/a3RKdLzt+LTfN5DxLCE2jkPsFo0AUtK
X-Gm-Gg: Acq92OGF7qCNsZ2E56XJFJUdofS2ooPhlbQ43Wo9C+TIdQnIhl3fX3iyMKR3WKcZJxg
	qlpLJr3D9HZHC/iFwoyFq3WVfj8K/ufRyZaQ961QGomIgE3iCYOGUZdYFE6ghSVRSijE7DhXPcK
	ExvHLevOYL/zt9qx/Cb1ubTlfFm62MoJNDsG1kce9MC62yzgucbEVuL++PUEVrRXRPxwR/MAYvh
	lSyRXSOF4TtxrTvKNockhfmxotTTJfi6+ccWvRHPErTqsKQ9ycLuNbjINSh+P+e6G0PlJYQZyTy
	gRse3ZFzK+51JNWm1oNQefUHZ6/jdNK42j+glSwGsrogNmxw8cTybrWLNZt73RozoXv5mlkY3Hx
	x+uNlJuKD890+y8Zr5XeJB417ESyG9HLYp5TsG0jPoM9z+vB5b7iJzI2E49Jev4QbQGBSQ6P7Nj
	U9G546m2CCwLAHPaiuLzdHgoHsS7EpquAvc9rBZIAJDYJ2ueKQoog=
X-Received: by 2002:a05:600d:644f:10b0:48e:9134:6ae7 with SMTP id 5b1f17b1804b1-48fd62d9be0mr228420795e9.0.1779131520505;
        Mon, 18 May 2026 12:12:00 -0700 (PDT)
Received: from mshcherba-RedmiBook-16.. ([188.163.115.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm40043167f8f.34.2026.05.18.12.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 12:12:00 -0700 (PDT)
From: Maksym Shcherba <mshcherba2000@gmail.com>
X-Google-Original-From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: [PATCH 1/6] mm/damon: fix missing parens in macro arguments
Date: Mon, 18 May 2026 22:09:27 +0300
Message-Id: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63D5C180013
X-Stat-Signature: bt8wb1dujwunydchbxwzfo7qt8ukokcq
X-HE-Tag: 1779131522-518202
X-HE-Meta: U2FsdGVkX19tusB/LKEP3W9f0mf/WRxy2GAvu2JrrBG+fy9KrePZWQK5TmBtgJR/k17YOlkDw7vah93ITE0/gzvMdlsS8hssxSqR+JL8prM3GSE+2d5NCjapfdAu9NFBNYcZogVUoqRYWcw+swoZk2lSkcgO2zT0nUnCtKZqPlUHn7CExueWJ+5EWVUKb5zT7uYLoQ1zXdCjQVZAKzr+Vd3ckC6Xk+98XJW98WKl4ZeobCUU+hXvVBQHdlpZIeLo9czS5DAJIv7pq+6/KiyPzhy7DDCNZV9Rc1kunit5swxaN4zpBon/emF7XVUcRdTu+BHVIy9EY1GWNkRaNWWAwehIRQv5UiGTcIY6Qj0RF4fyxPhyV7PW9BY0dbo1ShJE+FBW5iQmN7LUIjgUDHHvBUWJb+fdnd4E/GWMOGQm30ijMMd6utxQlAPqkBTVm+Cove9a00Ik/F8OeUyiC8IE7qfEDNEhdc6EoflkrJGQDlegdicaCPf1+VYL2aWA9PHGgi+FXFKrDOGOguUAjELVEHtMBNAQ7mj32E6eDSVs/c/M22tONF7LZ9k32FjIn8rJw/B1j4hZ81SP5a++nCuc9VnV2hNfxMikAelHzOm3HY8TrVThg5cMOH4leSJWdjEN/NCibjmblpz0Cp31PzUcUzeyLR/q9Eqvyz3dKXWl1mO5wvl4I8AAUUiLwqxlazqMArkllrpP2+gY4mPotI9huFvFvgGD5RrkPzXsoeKAAvSJUEaIunzJHfjhoHecCOjjvXuMIUB6TRbFFAcQ1kQG6cya3xbHKsJgQRWivSMEpy9NGheu//Ry7K6lDZONjId8g8PfZlw2a2TQEjKQyfMCxOfQkeOgJ7e+iaaOSb0tPJp/gLGPrBmQeC+nILIXbmXNDtVexvoVaZKjOD17HZeZUTZroYsvRemsaKM6Idb7G+LqIuPImC3ckjkvO0gam4MZcWEI7EjriPofPyCOeju
 Vhl/dfwv
 ovj9OC2PbZCtdHof15JUZj3YL8CD30cNCsU2vy8GDMIR4CBNKglZUUfyRDIM0J2L74CzU1tXkYq/RObD51opTZS0E/4RqJTjoAQojGG+9xfXkvXHDcjEomCq4bs0tRdUlZ+nVNhvLxzg3CMJ7ZQdQYg49orOlMs5lC0J87LW6ODnGdQPwWq1YHQSZczAGHbAs2dGvUJLXbKkTATFBXT0aSlKKS7E7lx7oozqoK2n0Ztj0rzewvEMSRtR/s0qr/lVZcHvLE95VbZHIgVptbTGZLrN9wbMM9URoQB9k/vt57hmyL/SxHjo92lTQ0UJDkMpCnN1Nd9tFZrCib2He490c3jq61v2eM3uhW2hPkxjSMKfKjhWFRdk2NBJE8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAMON iterator macros do not wrap their pointer arguments with
parentheses. This can cause build failures when the argument is a
complex expression due to operator precedence issues.

Add missing parentheses around the arguments in the following macros
to prevent potential build failures:
- damon_for_each_region()
- damon_for_each_region_from()
- damon_for_each_region_safe()
- damos_for_each_quota_goal()

Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
---
 include/linux/damon.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4d4f031bcb45..32f2318ac77f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -902,13 +902,13 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 
 #define damon_for_each_region(r, t) \
-	list_for_each_entry(r, &t->regions_list, list)
+	list_for_each_entry(r, &(t)->regions_list, list)
 
 #define damon_for_each_region_from(r, t) \
-	list_for_each_entry_from(r, &t->regions_list, list)
+	list_for_each_entry_from(r, &(t)->regions_list, list)
 
 #define damon_for_each_region_safe(r, next, t) \
-	list_for_each_entry_safe(r, next, &t->regions_list, list)
+	list_for_each_entry_safe(r, next, &(t)->regions_list, list)
 
 #define damon_for_each_target(t, ctx) \
 	list_for_each_entry(t, &(ctx)->adaptive_targets, list)
@@ -923,7 +923,7 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	list_for_each_entry_safe(s, next, &(ctx)->schemes, list)
 
 #define damos_for_each_quota_goal(goal, quota) \
-	list_for_each_entry(goal, &quota->goals, list)
+	list_for_each_entry(goal, &(quota)->goals, list)
 
 #define damos_for_each_quota_goal_safe(goal, next, quota) \
 	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
-- 
2.43.0


