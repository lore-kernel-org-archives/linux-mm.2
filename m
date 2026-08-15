Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4046FC5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 10:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9F16B0365; Sat, 15 Aug 2026 06:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B216B0366; Sat, 15 Aug 2026 06:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC38F6B0367; Sat, 15 Aug 2026 06:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD49C6B0365
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:33:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0A66C0329
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:33:12 +0000 (UTC)
X-FDA: 85103141424.30.FC545CD
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0C5711C0002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:33:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ekx8MoTD;
	spf=pass (imf21.hostedemail.com: domain of eamon112009@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=eamon112009@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786789991;
	b=BCF8l7c9smr8ZPUSjJye6UttWgp+XaHk7oEwshsE3y2pczy/2K70Zg/LZEzybRGgBWsEhR
	3bdSrLDxUW1FbKOuEpN35Sc0Cmrm3CmKpKRCthI+L7Tq0sUkFX9BLAdGyLubGSAC+/u+3O
	tRJPzo/NSzhk1cJ5DOgR5SNjUqvXgCg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ekx8MoTD;
	spf=pass (imf21.hostedemail.com: domain of eamon112009@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=eamon112009@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786789991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvsygzwWhr39S6cCyUe3E5mHMzXLSAHL3vic+/R/AUE=;
	b=h3ie56DDP4qRxzXgYY/ZBSRiCndYYCinjpYba80dIlVNT4SnXddQVydVxcUBcXmJmfRw+L
	cbwefXd8AJRhbhUz3T8L/PrndGXApbtxKMXvDzYJtpNVT0YpHTc/IsvOte/U83h+M0QT/B
	iJimsbJefRvabciRLfM9vy5S0Ywvh9c=
Received: by mail-pj2-f0.google.com with SMTP id 98e67ed59e1d1-380f4166f80so1673462a91.1
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786789990; x=1787394790; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HvsygzwWhr39S6cCyUe3E5mHMzXLSAHL3vic+/R/AUE=;
        b=ekx8MoTDOr8mDgXbkn2KEcAOopyCdSlY4wdROvUIMuq9mkHedkzx3BbFIiC5cJa5+M
         iCHTSfBfXDu0yXMccKC46OziGtBO0Ln0zSVVXx/iiBsKOY+3HbopL+ispnSOL5IH4saK
         f35iBU7y98d8Ep3vbLDjoDv2wTqPnCtzmZwPh9aOiVyYd9CO+av0IXYIS+hKnAFQCpDi
         OqIM3Vzv9Bp1mXZx9y7nnx1f5Lq7a0sgFHjea/Fj7JBKJUX3KnRJ21fJPZC81KgIIpf1
         MQYXbfUI/ta7/Iu5smzc9jAS2mxYsYmNjeXN5sn5hCWZ0G0LZXsvRITkYiL0RzVf/1SG
         2aZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786789990; x=1787394790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HvsygzwWhr39S6cCyUe3E5mHMzXLSAHL3vic+/R/AUE=;
        b=Oe3C83GFeBK1Od1QYcmOWaUfxCkm6bgZbm2qoKJCmRvxg7FflV2HiApwOYMwJ4KAtO
         5MwZtoCcxqOXl0EJ7aQgcNgqN6TRiuWmPJoRWi1XDAiO/BMSv+ObbBGnttDnS5Pl+2ca
         YuXoF0Aun+9dtXmpgSX+UeFokDZERfHniQMZNEAn5HuUSKxQ1AbYCNvejn33e3pLhVrZ
         31aZUSG2AKFxvEx9YVRY4eAplGd1kn079qhkOAwpPHliX0HKXjPUFZ+OLH0QOmrus1IU
         sVYurxkg9tOrWVs9dmNmvl9LvdN59XqzQAY7Hqaz0dw9hB8W/IFvGAIhewiVahT9GtcK
         hg+w==
X-Gm-Message-State: AOJu0Yyke16BFb9otIqGKBWRMy6yKGyNX33SFh5Zr4sdvfAd0xMPindv
	ZQ163s+GpxZBy4ciWnJJd9BQVn8fYs1Qlci9btZV73iQNggB3BK7cBK9
X-Gm-Gg: AR+sD13GcI6srxJqE3eSIc627Pj0lOgOR3GUnS9ZDr1BcE0djCsJ7cF6i8NFq9TX+rc
	7mgrpRmaCRkudvsTbPf0Lr6mhcvlgJfX0tZqfsFWf3L9MxUhuhC1lrRU8EBo2s88H/InUVqcRQl
	6yADidVCSbHQU3k7i1NJYYldTieD11l6G22mPdaEYklMRe5GcPHyZf7X923lb0fL3Ug1PQVT6UN
	7aJipREFAOBa4tCgaVRSEQe9LG+o+7qpT4iP3cKPQM48FwDHxc/1342C42TDRh/n8m8xzxHejqb
	lVmts5YI8qNxWrdLq+8pxagDusb+2Y9B2BN60BVftu1uE/GhkpPvUkCR9jCHvKoM0DtZDaPiRrh
	jzf/ZemM8DC6JD3X/AKyIcL71ydqFtuUQWKdmbzRJVfGWTDe/bHNiC4spX27XcZXX2aJmylkX1J
	yVKPDmHTOZcWrHCik1r1LGWjQEzWGtsnjiyYn+se+/e57SuGGVfGesKUHoa1/2IJCt8ztA2tWQY
	Hj2BBvKEOlGCao=
X-Received: by 2002:a17:90b:5745:b0:38e:49c0:75a7 with SMTP id 98e67ed59e1d1-3933b7a6986mr15068609a91.8.1786789989739;
        Sat, 15 Aug 2026 03:33:09 -0700 (PDT)
Received: from Ubuntu-172-24-64-1.localdomain ([157.37.161.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1413889bca5sm25815861c88.12.2026.08.15.03.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 03:33:09 -0700 (PDT)
From: Eamon Sippy <eamon112009@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Eamon Sippy <eamon112009@gmail.com>
Subject: [PATCH v2] mm: cma: make mm/cma.h self-contained and conditionalize includes
Date: Sat, 15 Aug 2026 10:32:45 +0000
Message-ID: <20260815103246.5315-1-eamon112009@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260815084026.44078-1-eamon112009@gmail.com>
References: <20260815084026.44078-1-eamon112009@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0C5711C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wjm38a613jceo6nd4af1w84ddtax5crh
X-HE-Tag: 1786789990-945050
X-HE-Meta: U2FsdGVkX19H+KIXoYvTYmjdD8QiPlG7yEUEwpXBdUoFsYNn3mZ5s7JulIei+bl8PUhchwOZ8l3beR2Hi6QxRB/CqlRLoQ6bKDeXEF/rE8K7Cd2fsens38NLzICPdCb1RIKgmtATy6SZo/oRw5s2OveIBdU1OClt2xVYl3XJA5HjFQycFIT+UwhReTkU41DUCPgFHbjQ3PL0y34xHp2cA87gdBaVyLBbJCi571LVYCm1mPKv4J7v4g6fBGSNZAJVmF/bJqlhLii8gLE5A6uzWgKzp8XOWsp18T12ll7O+EaghUtzoGAhWpwvqXSvCV8x17Wi+zvY1tuAvrPvu17DOpH51w7S7hKXqBe4+BPVGIUV0LdKrrweaYC6aFH0/oGjGezrweweT09pq8LYX/UfzwpddapWc4U8V6YsnpYC6/CKhwdSvadKTzefSTxyrSflimfHfO2vmYbFQDOiwEMcdjbwXvE9sF/jnI2rP/SCqR4fu95kxUIrXXqAtQjiZbLJr/oPWAr98WhxMKCbRqwAWEPaRGGSuv22JjYz+ktLItJTGiSCD8Kuf+K6KehBcUrmq71Z0HF5Z7HSh4ZB6FjxxOEU2duQlnOxYydSVA9qvP0rmdCotWo2weSpzMtHH2mR9uGGtFE8+pbrAdYvlYhHUhoei6jChNShxrd/3rl9CnR5N4NcKNCRsqLJfnLFTmGhtfr1adtq2e6FtUl5Fq5OpchoUxTLaU91Wh5I2YMkFewN924OZnkbeGUlcXIwCqokpYoLjnkybIIsxnNjnKfXk8dxxCUnCkSN/SR0ykB7opkIiqSdjF54aCUttGeyjOW2Gf0JyXGuN3DSqkMWkOTlN7eHFnwW4QETrM66gewVg+fQX11YvNzpOzESl999B8x+AamEqJ/ZLSYs9mWAwbXP5sInrPKc7z2vWoepjAwnuVfo/eF0mKNQ+FrjOq8LFeYMyQ5SJElDPBHly82wxY4
 COQTxEKH
 zOXQAYCMTRuvmukyy+znbz7zeXy4yHEJ8pn/Vv952q/cJPdqr5Sz0WzmkG49hmqmBCujsFJnu4IUwuU9KWFZEJCbYesT/QJhWvDuTyjYxotAFdgGMhq12L1g68qzAgYq1V6xvKmFGNUTFzXQYovZ5Y5vnwAuCd65fSvXeRJjIf2uKzgG5m+DAESPklsIhmyQ8SCWXoOkGgbmP4cqWhdTnOpRYRCtvX+mSHpRaaHp5S+WryXMQZwQ/qmfTQ3swQNpdGSgLKhpS3iKCS1hhfIf/34C5/Yj5pKbzHEqy4hm2rfvS2zpUGTTLxOaSYawXTif20faikUhBcA2WxWijwzY9Yk7G++UPXJ9a3ulfylsOopYuyOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/cma.h uses types from <linux/spinlock.h>, <linux/mutex.h>,
<linux/atomic.h> and <linux/list.h> without explicitly including them,
violating the kernel header self-containment guidelines.

<linux/debugfs.h> and <linux/kobject.h> are also included unconditionally
even though they are only needed under CONFIG_CMA_DEBUGFS and
CONFIG_CMA_SYSFS respectively. Move the struct cma_kobject definition and
<linux/kobject.h> inside the CONFIG_CMA_SYSFS block, and move
<linux/debugfs.h> inside CONFIG_CMA_DEBUGFS.

Remove spurious trailing semicolons after the empty inline function bodies
in the CONFIG_CMA_SYSFS #else branch.

Add <linux/cma.h> so that MAX_CMA_AREAS and CMA_MAX_NAME are always
available when this header is included.

Changes in v2:
- Drop inaccurate spinlock comment; the lock also protects
  available_count and allocation checks (Barry)

Signed-off-by: Eamon Sippy <eamon112009@gmail.com>
---
 mm/cma.h | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/cma.h b/mm/cma.h
index c70180c36559..68e574b0f951 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -2,13 +2,24 @@
 #ifndef __MM_CMA_H__
 #define __MM_CMA_H__
 
+#include <linux/atomic.h>
+#include <linux/cma.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
+#ifdef CONFIG_CMA_DEBUGFS
 #include <linux/debugfs.h>
+#endif
+
+#ifdef CONFIG_CMA_SYSFS
 #include <linux/kobject.h>
 
 struct cma_kobject {
 	struct kobject kobj;
 	struct cma *cma;
 };
+#endif
 
 /*
  * Multi-range support. This can be useful if the size of the allocation
@@ -37,10 +48,10 @@ struct cma_memrange {
 #define CMA_MAX_RANGES 8
 
 struct cma {
-	unsigned long   count;
-	unsigned long	available_count;
+	unsigned long count;
+	unsigned long available_count;
 	unsigned int order_per_bit; /* Order of pages represented by one bit */
-	spinlock_t	lock;
+	spinlock_t lock;
 	struct mutex alloc_mutex;
 #ifdef CONFIG_CMA_DEBUGFS
 	struct hlist_head mem_head;
@@ -86,10 +97,11 @@ void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
 void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);
 #else
 static inline void cma_sysfs_account_success_pages(struct cma *cma,
-						   unsigned long nr_pages) {};
+						   unsigned long nr_pages) {}
 static inline void cma_sysfs_account_fail_pages(struct cma *cma,
-						unsigned long nr_pages) {};
+						unsigned long nr_pages) {}
 static inline void cma_sysfs_account_release_pages(struct cma *cma,
-						   unsigned long nr_pages) {};
+						   unsigned long nr_pages) {}
 #endif
+
 #endif
-- 
2.43.0


