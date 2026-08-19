Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42A6C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D2B6B009B; Wed, 19 Aug 2026 11:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E48D6B009D; Wed, 19 Aug 2026 11:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAD36B009E; Wed, 19 Aug 2026 11:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C4A6B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:47:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F11A7A3147
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:47:43 +0000 (UTC)
X-FDA: 85118449206.02.6DF74F8
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B6D820007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:47:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1X8Nqp9;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787154462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B2uLc65dgQUV8wo0HaABmpVZfWQ7ltj2gBRL/yjHnUo=;
	b=gKBWWXrtcWi75Z4OAXWigT75ai2yj13FTbESJugYym0tjUPIZs4JCu3ko/y5wwXltWY5Os
	y1w1zn2/HRjUswxIUu1zILSb5PeanfP5G6jBl+eo/zDQ15DGCt0DTl7bNYk5hVe0B66hry
	ET81hw6Wzo1Neli1q6TpRPAKFjwC69U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1X8Nqp9;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787154462;
	b=x3EUKRqFB18nq+Adfenv19zAQGRd067XbwRUm78nLLedWvRdnp1lgIhxh5vv06OgA97sCV
	OgfI3/E1O/j8RDdC3WaWncjByRQljxVmeOkmXzulE5OnSz72uwhRxX3DtMSPGsGhkhTXXY
	iRsfCV4UEpThL0TFnQuAroefMj/NZ+M=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d5655cc850so14246455ad.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787154461; x=1787759261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B2uLc65dgQUV8wo0HaABmpVZfWQ7ltj2gBRL/yjHnUo=;
        b=B1X8Nqp95Ug39bNRIZVRrEcEkcy+WMiaSTF94aKyyYlGKc+JKDxfaH8Upxpls8AjlF
         p6zKLe6wpX3HoswNkU9CiXi1PHfaBcdecTpbU+8XNkAAzxoCm74HJZbGYtRtI+R8NaLQ
         Rfgj5FZ6u9MVqLuO4Kln0TaK+f6zghcTIXuPa39NgNjvgFR/hKun4k5OR39oQoiYSkfg
         uf9ZCkYoFRNcIU2SU34RIwc4vXl2apBCF4R7X1cd2AEZzLDou6ZCJslFOyqGKEeEHSyN
         Oq04XxlERUDNi5RMnz5Ye4Zp2ILObIy0UZy3RdZzb5u5HkqYXtlJ0CpIvlmYX59FWeqo
         FkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787154461; x=1787759261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B2uLc65dgQUV8wo0HaABmpVZfWQ7ltj2gBRL/yjHnUo=;
        b=a7UnH8Iq1c8+VAIHenRfeKlWO4cGyZgtdFGuew7Ib8SExm7unyZrAEZVZ5g0AY4Ug4
         qQ/yzaJcjXwoV2R+c5dPVSg5aUtYrtYI5RHyjNwItk36SZbl3CGcbgHYRn5dxqI7A2vs
         JN+X6VFvHoqpNzXd21lWIELroReh1tdfEpPMYgiHBsOYVvYHa8fBo4nDa0BIOyOVgzOq
         RQGNoJEeOse9V30dL2M21zFiH/qyMEC2PnwOIDA2x3wjVoNnktXTkXv1/yppajY9634Q
         bIny/57fd6YhUb5pbailIOqHxX1Zcd80FQR2Osxn9JO1gDgL/ExOq5N4Kz9JeCiMgG/4
         YpqQ==
X-Gm-Message-State: AFuF++kr/j9eA95vlybd5xKmnsakvhQ8tuPzUyzDtMOCH8kLf4czVCDz
	vnmBFvgGqmlP7SMkdInJ20ltZX5UBywRJBNK823LlbjKndYCCt3hLKR4na9Q9Q==
X-Gm-Gg: AR+sD10eSq+jbGG7sRQ1oCHojAwUo8PeDny5YOJjb2NJr6IHN/z32p0X0lCksr3THET
	nuehSN+U2LzqXGTUKOQiIGg9F1T0oK9Av16d6KQR1SGfarQJfOmTGtAtu72RzVmc91zS9kemcd8
	PKB0pSZ6+03Mui72aOiylEH27d+TAS/QDW5FQE9eAFtnHFObyuobw4rvf1Q5/IJrqQbkKZmUk1e
	VqCfkgSKKA3Dm79E1/N0Mp+gB3kWI3XQxFiu/QlzVbXxDtCZIszsoAjLcAe1EcexQgTsgn815rG
	xcjuFpwQH5ZYTPsVUIvFAqzxgPivwllJt791IscaA2BkUoNcmTlKLOTKKui7knL6vgOMBwbBuH2
	8RGmi6qHQWyWa+6NoinAvjIwTERPHbhXyvOT6ufKfP7JwesfVcZIUPcp4XHzHAggts+9odm9E0S
	5X4mZzLEJkmSE3aOpr0dACcphill7OvdvUHl1EP4Hpg9TWcEnvEGOmqMI=
X-Received: by 2002:a17:903:1b0f:b0:2cf:4339:aaa with SMTP id d9443c01a7336-2d5fd73454emr110247255ad.12.1787154460937;
        Wed, 19 Aug 2026 08:47:40 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e93ca0sm26279475ad.63.2026.08.19.08.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 08:47:40 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH] memblock: simplify reset_all_zones_managed_pages()
Date: Thu, 20 Aug 2026 00:44:34 +0900
Message-ID: <20260819154436.3225746-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uzo3sj14kydybueq3erxmij4acz9ws6w
X-Rspamd-Queue-Id: 4B6D820007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787154462-998157
X-HE-Meta: U2FsdGVkX1/XM4UohujfDf9CSZtU6zoiNdJSaS9H6dvqYPYRF8XaQFXN8XLg1cCN8Tw5IKX+uZdj8Emj4o+0uQ6b7rmBQNggIFKzvWt2rchMkqmrgRLi7ffvZDelBnsykYNzepRg/43pBLYz+I+8Ol7f2+Xc2jYx5dxmUcr2BStE4mzDtlIWQeZUBdotGy1+BTvKbT6s/EkcY3ZIl1pnevGQA/nVlw+fjZDvLLI7cYMYhK2HTcGbmBrteqlxKGRUuyCtuxEXwvJmIdAABFZi8vkK0HT42W667svPFGtTxHJeLKrR7AMtEDnrojVOUf8JYBoE0B79nRv+hSqrvKeim2JMpc4pKOyOjEsRo9cuh5WvP1RMDOSu9HlF/ntoCgK9Nh5+T1upGZTduS7s4tVUSwtelFJTwIO1bgpmvC87FHz5k4PzTyDyTG0CS9rTfXN3bxex56TOPvKCgUUozZJtWnXSwsyZC4WJbARTErlLbxAA6sXMFVc/wjh3GmafjfLOoowex999pvgD1vkfNazj0zfw8Q2ZHxM2RK8sBTKFutKLMLxGoxI/8vJayhD1kkprZnPM1vL3kejYXn1oPquc+xf6jkcCdkm8MJj42L3dDFldYxy+wzgL9JfGnk3d8eLKKUX1txCY8fIIygm7Ypuy3Actdj//4oN7LKgmBMW/SW7zGOQc+vVJSd1tdqxaca9mHOS01R+2l+J/gMiJfvZc1DX/f6ZjeolCtHMsjSVMGIMeubcaFP9MSzSCSYPBlunUhmfJl0s9DOz6DSei5zt4iw4QYf24/yQQQb5rfNVzQJOP9GRwN+EkcH79YBIwUfPQPBk0Dlf9DdnlkgpEuw+urgZWGGhJ295ScOp2uotQq6h19sfmScPhzxpSbUM/4tmvAB//4sjeRYAd7KL+oFt6xbYbRSKIU/49fdMYb9KFyq03vUNGXe5PipQUh9xugy+Rw3v7/Cxo6LF47daBO7q
 vJ2zG633
 wW47aYYaYB4eQDaVNVzIrg6K7PU+BjaUlqgDd8bkndu+nkH/yrN3Wj/W071NAJvcT62N3IwpHaQH/RF8K8TscUmnwzBM5mI9wi1Sl2QBtD6Wd+w3QsFseb9fiKPkLid+1LBwHnQTsgLeDMWH29bwsMvF+td6mCMKDVMEDDTgTPb9O1pmVPfY4i5AwLPZCu1/lWf2uG4NwLS+y8udJLmUmhKERqbjEtMxehfvOds4AtwVS9C6BjQEsYUGEfxWqMfYxGQ8T5nlB7J4FdX3q96CR+NFT7AWyMsKcpdr1p3U5tPiXQF8JlxT+qeMk5FPwP38O0Ae4WluWe3QO6YimYsaQPGuwUkdUe1qwCauX1xNGvS4iIzcfP5Yka0K8Q20JcCyOkAHnwJKMa5DRSSOh+dJUsBSCtgCj6l8P7fUfILZ8VaVHoVcYTPgj4GB8NAEi1Yi3ayK884ZOp+22usw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

reset_all_zones_managed_pages() is only called from memblock_free_all(),
which runs once during boot.

So remove the reset_managed_pages_done guard, make the function static
and drop its declaration.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/memblock.h | 1 -
 mm/memblock.c            | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5afcd99aa8c1..83dc821b23ad 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -160,7 +160,6 @@ int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
-void reset_all_zones_managed_pages(void);
 
 /* Low level functions */
 void __next_mem_range(u64 *idx, int nid, enum memblock_flags flags,
diff --git a/mm/memblock.c b/mm/memblock.c
index 43e036f3e11a..5954d005dbb1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2368,8 +2368,6 @@ static unsigned long __init free_low_memory_core_early(void)
 	return count;
 }
 
-static int reset_managed_pages_done __initdata;
-
 static void __init reset_node_managed_pages(pg_data_t *pgdat)
 {
 	struct zone *z;
@@ -2378,17 +2376,12 @@ static void __init reset_node_managed_pages(pg_data_t *pgdat)
 		atomic_long_set(&z->managed_pages, 0);
 }
 
-void __init reset_all_zones_managed_pages(void)
+static void __init reset_all_zones_managed_pages(void)
 {
 	struct pglist_data *pgdat;
 
-	if (reset_managed_pages_done)
-		return;
-
 	for_each_online_pgdat(pgdat)
 		reset_node_managed_pages(pgdat);
-
-	reset_managed_pages_done = 1;
 }
 
 /**
-- 
2.43.0


