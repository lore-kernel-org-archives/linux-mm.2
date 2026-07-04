Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26867C43602
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 09:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E7F6B00B6; Sat,  4 Jul 2026 05:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7916B00B7; Sat,  4 Jul 2026 05:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984D66B00B8; Sat,  4 Jul 2026 05:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8986B00B6
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 05:20:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D044E1C7B4F
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 09:20:28 +0000 (UTC)
X-FDA: 84950548536.15.DAD65CD
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1632580004
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 09:20:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aa2GcYfa;
	spf=pass (imf02.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783156827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOl+czY2f1ph2+qzbkwCXQTY9N5lq8+tBU4quwjJzyE=;
	b=PUQ6pvjUjDeXfp0zd4v3F/gUcuK1FNgfdbO3d3lX/JWNbnEf8tAAJyNl7w7RxfwzobL17L
	cnnRL4qa7aoNCCz39DBuh9x/p2bHfEQyixHKqZ7rpbYU13tBG1X9O85ecxp+nvG3h8f/sY
	sHCi9oo3/g4XLrqqPN8/8ukIAccVbFA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aa2GcYfa;
	spf=pass (imf02.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783156827;
	b=6q09KsoY/e/VJaBoNtzim18e74r273sxUxJWeO/VR29c52h/a7ojdtYHCSFgwIcew2EnjQ
	Ko8REi1aVc+W0JEuyWeuDwNde4ravSUezbs1GFzFB+fig5fUd7tUXo4jw6THxaUTuBEHeR
	u8Yzp0tJCUEyu7G82q+emE0BBoptpnE=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aeb5829fd5so1009325e87.1
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 02:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783156825; x=1783761625; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOl+czY2f1ph2+qzbkwCXQTY9N5lq8+tBU4quwjJzyE=;
        b=aa2GcYfaTFaHKvW1WIUhAOplWmLujGgFQz/bv8zVKpBuuPZJrEMLjAmddXw1kOBJNh
         6NYDr/MaI4sNh0sewhztSU2LG4ETA4SJpKxQz16MXv2nvQAP8JCAqZ0vgCbBCTRUFAkz
         Kk863vWACLfsBJ4AcIbk2wbL67/9tIOBE/hpcqjaYlkHsCxWPRQMtoFNDwzfWDXwf//6
         nN6o9jaTk2Ow3BkBABkH9R9uv0v472yxa+owjvyOX1GIZKZoafWrj6YTDTfB+0qGj+z8
         ZsZ/MXrvO5hgfBjnC/PCUdRyIsm5go0KYbJX0s7T2a472PP9Q1nyAUY3xtHRZ2+QEr0z
         QzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783156825; x=1783761625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vOl+czY2f1ph2+qzbkwCXQTY9N5lq8+tBU4quwjJzyE=;
        b=kqQtvbfo/HrBn82o4C+yc8yNSMYA3DcU5doyGCfEL/3xhhNinLBGxsGMuOE7RC/5oz
         nGODIL8pxspYFDxNJ6y5C97mRoPy5aCwpbRdCuE46uRqXSD+IH9w6Cd3cCxXWWpzo/h0
         iJlLhm6cPMUSNn9xWoiSrx93yR74hxa6HpXNZE3Clm8oLXmrVgugr/Pu+ra/yqdUGFKD
         upBYvKvvAVkyrlx5HGnfH6Ata36FUVTYrjt8vGYQ7j6QuENJtwK/yD15mpvlG+fzV90A
         T2tjb8EpR7FG6ZjGrnvmWsp7WT8HUTwSvdfEd4/9hUOg0rfz8x/3EsqGpt7dNglcFk92
         M6Pw==
X-Forwarded-Encrypted: i=1; AHgh+RonBGL7cNlwBkghnRSUPO36t69G5ZPHOaq82PKskBC1KxYH6Cpf6Q5te8xFqtqqSR2+dB/oBXlIag==@kvack.org
X-Gm-Message-State: AOJu0YyZCJimM5q+HxmV+xAtzJC+7tC5io7B2xWllbQp/g7MD9QmOR2X
	HC3ewUH+9IcNIuPV9miOZQj8+pDIN2qqBBj9m5NUpWiFNJhvfqkBr8G7
X-Gm-Gg: AfdE7clb1NnC1DcGNXZpmJSsQtbMxX8bIUrAa5Esy7aYcLJGyM9GTkZHgBHArSxormx
	K0uvCmzvX9rtdLm0KBtDTI3a2+tyQpHBfiDizs6KkurIDL1x0bKUWl41OZIut+5tmmAKVQDwAnG
	VFCOUiqLQI852xBHS/Qvs2uddmrQ5dIrgEpk1BPU/oaeycEJfbREES65y7B+vHWMaNbgK6WNo4X
	pPZp2+LFcHNcjGRn6IZ/K5p1dsThSZpJGHGkQk469FY+mI+uBUTqNEfpKCkadKbcQq+ByriaB8K
	xMH/MDKCFRkYeM4tYgTSoeh3QKnbD/XsN6xwA6olPriLl6cDLJM7JRjLUNbfGt2aQ+rJ1yI6unj
	hkcfy1Ng54zrnwQrBKO5OGiFKdrdt54U3tA9Z1Jb5MJsJsxh26fenZNQzjwUVHsg5yTLpbN0wGH
	ESkHFnBGhxhzM8xJ7cslqIEtmfPBjpMvTb3Amy564suztvARq2wWRA/TV+QWrh/Hw330y/HSak2
	dHHv4U=
X-Received: by 2002:a05:6512:1382:b0:5ae:bfd6:1bc1 with SMTP id 2adb3069b0e04-5aed5084c00mr553192e87.14.1783156825451;
        Sat, 04 Jul 2026 02:20:25 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aed13770fbsm1149063e87.30.2026.07.04.02.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 02:20:24 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 1/3] kasan: deduplicate quarantine reduction logic
Date: Sat,  4 Jul 2026 12:20:05 +0300
Message-ID: <20260704092007.3483-2-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704092007.3483-1-igorpetindev@gmail.com>
References: <20260704092007.3483-1-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gxbrasgqsxrm13gmg4u4jqthnw6aoyu5
X-Rspamd-Queue-Id: 1632580004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783156826-691297
X-HE-Meta: U2FsdGVkX18/DEsGM56D1YsbaDhtgp1NzIaslAveW7oY4XwjQKLokwhk6B0XQ9hi5m4rr6b2StBEMWfHTVO4cA3MBTFbwAPv3dQHcHH7f3eBgLqchPYaXPUELJ0yCdzLbBxSkV0df4NoNa8dDJ1fFDqR/yLSPLbGDGx7dHqRHXZfuvm1x+OYRnlkd/jntCmRVRoox1/E7IEWHWrq1hyeWn6zD4uT+JbHDUv3/0bkrXl3WGOY0uhFtTsOt+mrC0s65T6auElscOSQ02ftmZqZzG2p++sadv7cgR5EDdgL13A7CLcQgIW/XaWzDLh/o9hCzeGz1Sv4321rnAHRsALVPpCcLNo2+iaPowansJId4UUFLgzqaVU7ZyEsTITgdFZ6G0S8pOPe5ZP1LpK/494fsTdAqH9/Vy727HY/ZwOXabE1FE8lOzxSz/+p+QPbNS2HE4y7HZSAyzwgKb5Cu3SDN9rwjOb+OUG7tpFZ1pwD5r2AGd/A6DMtISuRM9TuanW5bfuXy14QvJz5c2MZNPKMKMz0IS+KJkAGFOrjitFvFTXNsi+mlJen9KTksWWfkWuAqvFG+aJmArLgPiWBwCBd4yRBNNJafjG2y1wta7Mvdvv2ZVEvws3/5JjigjI9McOftBs6oPww0pJJ2tgvfx6MjN4PS4E9myYSz8RTHMW5mBtMKO6aDZUf7SPaQyBN8I5g5AbnXoglNwzecX1nJSZdKwggmJRYvirCgsD28Vp6mhQ0aFfshIoXottrDh1DEQ7M8gONd1i7LQFMrvOL4gc4XOjaJR7WhhkhmSjOrY8IU9rkygEhGXo7fHjrzMDsfEIYRmJHI/RLed+x5TCrCovZDja2eDDH+XD4s/8G9JaDAFx0bRvxfiK8sAtQufsmHOdC2cPmSIRW24pg8ajCCvzT2iavW53bZT9rRPMuoPNnsP/rU8WTq5Bohp4ASByi/ZQVBIMg8OqDKD/BEboXaqz
 ZhfQuqFF
 EtXoBiXEbaFaSf4qCGSpkQWOgyxgeWNavkYDg4CQXJw/ipvaS89Y5j8dWqTqseoOOtltfrIqhMku1NrOrvYC7O2CXZel0WZPFOJTBaR447TMH9fAwSHLORPAXVLpPHWW5avdxITqclWiuQrHT6Q2shjg4LmSyvgPXsmPvyDMxiC1x9AXZEzeM+OMk7TZh02dJFvKFKTU17qY+dMmM/PM+ASnyEiG7RJZa0h1RyRyNMZ5NNlb7LsdnlNbp1Wn9Vnh62IZjisfCRLzP9v6vA+nAQ4l8l+urmcs4aQcm1lpF2dCawbf3cf+7RwWgL3azWTtOAmh9iF31B+kDmWgQKh+q/nMWI+6MJtkUQHhYkXV90IhgTaQasb9IHfKteWb9Pb+ZO4fODGBAwypjQoNNDKfw5qYqXAH+Jt+k3xKIakanBfo9HXQeehn0clnGyKI3gu8uj7q+Ke/diBQFk5pXDggkKDTnpfEht8Us1pLox5EfBwJo5lk9SOu0XLXcPAUwW5dx6Zg5wVjMSxcOmiIosaFvEeTcffn1lOmvdj32tAua10d7oBZRm6pekj5tasGsC6cVGPWer0qS5VuxCLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Multiple allocation functions share the exact same conditional logic for
reducing the KASAN quarantine size based on gfp flags.
Introduce the kasan_quarantine_reduce_cond() helper to eliminate this
boilerplate from the slab, kmalloc, kmalloc_large, and krealloc paths.

Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 mm/kasan/common.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index b7d05c2a6..34aa0fdce 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -340,14 +340,19 @@ static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
 		kasan_save_alloc_info(cache, object, flags);
 }
 
+static inline void kasan_quarantine_reduce_cond(gfp_t flags)
+{
+	if (gfpflags_allow_blocking(flags))
+		kasan_quarantine_reduce();
+}
+
 void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
 					void *object, gfp_t flags, bool init)
 {
 	u8 tag;
 	void *tagged_object;
 
-	if (gfpflags_allow_blocking(flags))
-		kasan_quarantine_reduce();
+	kasan_quarantine_reduce_cond(flags);
 
 	if (unlikely(object == NULL))
 		return NULL;
@@ -402,8 +407,7 @@ static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
 void * __must_check __kasan_kmalloc(struct kmem_cache *cache, const void *object,
 					size_t size, gfp_t flags)
 {
-	if (gfpflags_allow_blocking(flags))
-		kasan_quarantine_reduce();
+	kasan_quarantine_reduce_cond(flags);
 
 	if (unlikely(object == NULL))
 		return NULL;
@@ -443,8 +447,7 @@ static inline void poison_kmalloc_large_redzone(const void *ptr, size_t size,
 void * __must_check __kasan_kmalloc_large(const void *ptr, size_t size,
 						gfp_t flags)
 {
-	if (gfpflags_allow_blocking(flags))
-		kasan_quarantine_reduce();
+	kasan_quarantine_reduce_cond(flags);
 
 	if (unlikely(ptr == NULL))
 		return NULL;
@@ -460,8 +463,7 @@ void * __must_check __kasan_krealloc(const void *object, size_t size, gfp_t flag
 {
 	struct slab *slab;
 
-	if (gfpflags_allow_blocking(flags))
-		kasan_quarantine_reduce();
+	kasan_quarantine_reduce_cond(flags);
 
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return (void *)object;
-- 
2.47.3


