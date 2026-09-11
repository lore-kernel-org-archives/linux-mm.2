Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DE2C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9246B0092; Fri, 11 Sep 2026 11:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469CD6B0093; Fri, 11 Sep 2026 11:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381366B0095; Fri, 11 Sep 2026 11:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 178366B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:52:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E22F1C1CF1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:52:52 +0000 (UTC)
X-FDA: 85201924584.17.C50D644
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 66D46160010
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:52:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gTvS2L/j";
	spf=pass (imf08.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789141970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LNQ5H8myUqx1tWJQeg5MIIwa9og+am+x86iyfUFxIuw=;
	b=VQcMs1A7bsemF0hII0CribpRu+/lK6+GuYcXvW7om9gJkI+thhFfYwtPp3DZWoejlJ2nUe
	YnP0qZ1IrjZguixm4u1Geq2B+M4VhJt91mDzLaWG1IOqo1hgahG4u5st2YIKXOp90peS9I
	dSAwrj4XNbb2qM0wo2npw1aFjB0oh9Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789141970;
	b=29T70P9Bub0/oOG6AorQ4p6oXMYvb+mHxR7LWC4y28P6mopGjHRyw9K2TIXR3yxDRJMsBA
	/1s2hvHchQ33DW6ZTpclFj85kUpUvvV2dVqcdmMQxjie0XCJ82NixURpsuVg1TOm5KDLIS
	xjOY1F5S15YWdxrzwFdGPG8Kq6CrIig=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gTvS2L/j";
	spf=pass (imf08.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2dcff8f44f2so14650635ad.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789141969; x=1789746769; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LNQ5H8myUqx1tWJQeg5MIIwa9og+am+x86iyfUFxIuw=;
        b=gTvS2L/j/F1WL+KqB2ZUuhfCO+49cgS+TaAKim0C7z+JYp5ZYAMjCt3/PALe3EeHNN
         w/qKSJvG+uYfmeMplEHYl2d7ImheDLISoU/uGWJkmukTCJFlqy88RcV8BZVqOJqlNPRR
         eWirtLveKoqtYiiMGzYnkeRsNRzdmnW7YIlNhOOQE9nxQy/8+KwFnY+7sW53gCcZmf3c
         +O/1maaqrMt9RdajmQoedrbtJNl9MiaW7qKkfKmk6tIK26JwURO8VuUR6DKGtd09Jyle
         WDd7YUvUevGW/YfLo8iK4xXGPKAaXTVcnFKY4MUhiiBvYHdxYyG05Vk8GXaqlxKslgqR
         hwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789141969; x=1789746769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LNQ5H8myUqx1tWJQeg5MIIwa9og+am+x86iyfUFxIuw=;
        b=Dri2+LwAJqfh2FbfNorsiyZlgRW4Hepo9kYfhDzoTwuj2TPpwMo3CV/QvD+pQh1RR1
         wSa0j/0o2RgU+x7xNSwplB/Uf4dEiDstqq+Ehybrm6GVlWbH6LIW4Yno6ATQbVmP3hwI
         j1nmN4vfxCLx2ZUkPXVJsbGO7cvRMZBo6NqZQsZEEdTWFtLpudPob0SVfFzE0+GnB4/5
         RlkyLKHECgC51qNC3eQ4xfIo+Bsvb9TNUoxdzVs8yGmzBJBYskDFPT61LKnJ9asS9OkB
         vBjlKRwvk6+11CYVb6J1U4YkciJVt3StNuFaQaFaQy2VCVFg02sfVPMEuDGE47fdAbHj
         PheQ==
X-Forwarded-Encrypted: i=1; AKwUvBxUym849due/YZWQDOyHDhPBMcqL/ed/40nC2oH3216RBHwMMKnwCmue7sfUkFxpRyV9d+NMQ52gg==@kvack.org
X-Gm-Message-State: AFuF++k1ngK7BUKHx8Bl95UFaA7QNOjVl7ijaRIsjV5To9KH0wpq/edK
	q618QKCkSaVp0jIsr7G8lRelj1/gpu1wdRk7rQTZPWVxI04B6HwIXtn/
X-Gm-Gg: AYBFou2B6UUfPZLKzKplyz9EfkC+z3vag13LYDgmxl0v1FshUNgrYEgj63YVS9Lw6e2
	FSFY2KC7tiuajscs8bU2hJ3USgseRSM6daCt+ITL8R+fK33BW/L/Von+hgQUUSc1tT8K1oZljGR
	lPCTWNUbxZ2i92egelvFEFuYyuMOJANhWz7n4BvsC8oR2HKyLYD/ZqNgFTcZM8BbBysNhn9YOuJ
	vPpx9UkhQK8Dw2cZ259rYmKzXgtEcLTzvDTI+02PLGB1hl+H0L0E9oj+x7GZEZP3aEPdiJ34tnS
	SuztuA3x/pt4it4i33kGZ7oy14XRAWMCnDGGMxCqElxdlYDiYJpDcuouuX2719zKMgz1pbm4PaU
	6XsIZJyFk6ioyRLGplxGLZrK6H3/f2j0OXbjdE962K2IKnVFrvWkS4qImOJ8APfm7qdQ7iR2WH/
	jKUbhjTSxqpdPZ5fm+gL28qzyIzshOU+s7wUSVvTm3tW76WA9tKntjv0J69B9Rj+F6BwU=
X-Received: by 2002:a17:90b:4b0e:b0:398:9be5:b41d with SMTP id 98e67ed59e1d1-39d9c368348mr7982154a91.24.1789141969010;
        Fri, 11 Sep 2026 08:52:49 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b97994sm13853172c88.12.2026.09.11.08.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 08:52:48 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
X-Google-Original-From: Yury Norov <ynorov@nvidia.com>
To: "Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Eliot Courtney <ecourtney@nvidia.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>
Subject: [PATCH] lib: fix lock initialization in region allocation benchmark
Date: Fri, 11 Sep 2026 11:52:43 -0400
Message-ID: <20260911155244.1406122-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u79cxyr33taas7srczwjjphz844mio7f
X-Rspam-User: 
X-Rspamd-Queue-Id: 66D46160010
X-Rspamd-Server: rspam03
X-HE-Tag: 1789141970-704655
X-HE-Meta: U2FsdGVkX1+sU2UCenlXx4k00WLlkBRoj99X7c8mj3KELpv928yUHeC7UWBCtrMLEJIu3k4oduHNLzQNlqvR87XzcdTKgznzXfrfJU3SuYf5eVhPYIiLUar98oIRvGMkiCC8J0EUMoF5oRkBlj7tapymtGU08gLysH1ieY6fIjvDruQy2vkFx2nw8EwpPjHbdYQ3WRd0acff8D+9+IOAhJ1V3wqgqhXM3BACTHLiIEiqBK0DkPOKkQ2BUtdL1As75r59wk79WmOmBaLHZ0Pd8TtywqyXn67L+y74d4363BdTqidC/iOgoMcZQ5gOUAgW1abOchoe33MxFRs8dGnDhkeePZPPhc5cjGPVc7PVYLZbjLS9wvdVzB/XTilRDmxntHf5OC3lr6KRTocCPR2OWw48O5W2pyyaDrjqATJBN/axarjeDK0CxtHb5d3ILcwvXZLyOeUjaK4ikx4rSu0AlmJKsc/r16NPSgSvH6zMo4dD4gcrk9zKyEKl6ixI3UW66AHbgt+3CI4JBGD05pzAYvYOlYPAEDp/UXdmtOY5fqt3E7Nfp76X58yks6u4avvF0eZ2ENRwUU9JV/nY9/tuTUSAhZBfX09WgaxAyliBOa+tcv0VS8zPXA1EBNbsFzUSDUOboMJPijEZkQzIpWLK4FM9wtvE8eZTOGP/Zqnlxt1Oy/FT3HRpVDvHTgtQzxfix72QpTuJFGcYa9HUcYTa4sQX+IAs0G2D8NswqNjh5ZZ0iXZSKcZIhN2y4j3XH29Ky+zRO5vA3luSenYFe39Orf3HVB4El3JRxdlgs4BAOXPVMjgwXIZzrstKeNOi6XWwtb5hwbNICYEbp3z3mcQtWGDMYhrROw72PutGusaXsw3ztvKV5MDbxCfisNAA19eD1egvnMOgQigwjhvFrr2NbZ8/f/oU5/W0UCMCfbR/zWzXjjR58DDVQwQ7Jgrm4Ih6OyIFq4aTJTgrfF+T/iS
 rfYG6t+E
 lSO74if5u6FKOwy8iiqjcGhR8KP1pjT4Zh26ykKxkCC4ATmW4GU6PVpuD0xgsZiiP+KB4RNgEA2gVJ78jg42Q+iUPMuu1LPtUNbtuPVBYYp+rKcOznU7E7B6aAP7KTRW4NTcee24qONtqKGglEACsbmEC7IFIV95MY/VB3LtrFtI3h9hO4lnsvjJzYnY+M3ZKDCfH/actejKRdCFReXIhhD/6wxiuk3Kq+MGs4EffR7Cs1Frndqxizsl/6BQlK1qiQ65TpitJSrnQ88If3WDl1UgODnXxC8UJ3bRbBkJGKdwtUotjvBnCG/3enW4ml86ZoEfi8MHFNxNM/xGhl9MbnrOKw7TkgqJrA5JSs1li51p3KetydEg4egr4NF2LzbFF8xDVDd2G7/vWVjTpQ1axJBUfAxgm0RTF99ckGb69IyS3DhAKOAE4rYh6yT1qRCy+NQhqvXBrGOy49ECbZgiNbcVBJnHhPblV+4x/TKYngNnGVnDpeIIaXkAODuypwBsbw67hqMt97j/4OIUraGqvGla07ebHhOy9bXYc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Maple Tree benchmark uses MTREE_INIT() for a stack-allocated tree.
Its static spinlock initializer leaves lockdep to use the lock address
as the class key. Since the address is on the stack, the first allocation
triggers "INFO: trying to register non-static key" and disables lockdep.

The IDA benchmark has the same problem through IDA_INIT(), but runs after
Maple Tree and therefore encounters an already disabled lockdep.

Use mt_init_flags() and ida_init() to initialize the locks with persistent
lock-class keys. Keep initialization outside the timed allocation paths.

Fixes: f4806cc63cc6 ("lib: test bitmap vs IDA vs Maple Tree performance for region allocations")
Closes: https://lore.kernel.org/oe-lkp/202609101106.771b567e-lkp@intel.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 lib/region_alloc_benchmark.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/region_alloc_benchmark.c b/lib/region_alloc_benchmark.c
index e88b4cf55c62..a644f3d5431a 100644
--- a/lib/region_alloc_benchmark.c
+++ b/lib/region_alloc_benchmark.c
@@ -78,11 +78,13 @@ static size_t __init ida_size(unsigned long nr_ids)
 
 static unsigned long __init benchmark_ida(unsigned long cap)
 {
-	struct ida ida = IDA_INIT(ida);
+	struct ida ida;
 	unsigned long cnt, idx, off, nr_ids = 0;
 	ktime_t alloc_time, free_time;
 	int id = -ENOSPC;
 
+	ida_init(&ida);
+
 	alloc_time = ktime_get();
 	for (cnt = 0; cnt <= cap; cnt++) {
 		for (off = 0; off < reg_sz[cnt]; off++) {
@@ -125,12 +127,14 @@ static unsigned long __init benchmark_ida(unsigned long cap)
 
 static unsigned long __init benchmark_maple_tree(unsigned long cap)
 {
-	struct maple_tree mt = MTREE_INIT(mt, MT_FLAGS_ALLOC_RANGE);
+	struct maple_tree mt;
 	unsigned long cnt, idx;
 	ktime_t alloc_time, free_time;
 	size_t sz;
 	int ret;
 
+	mt_init_flags(&mt, MT_FLAGS_ALLOC_RANGE);
+
 	alloc_time = ktime_get();
 	for (cnt = 0; cnt <= cap; cnt++) {
 		ret = mtree_alloc_range(&mt, &idx, xa_mk_value(cnt + 1),
-- 
2.53.0


