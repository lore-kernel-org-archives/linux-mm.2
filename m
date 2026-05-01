Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33AF0FF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FBD6B008A; Thu, 30 Apr 2026 21:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6CF6B008C; Thu, 30 Apr 2026 21:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8127F6B0092; Thu, 30 Apr 2026 21:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7170C6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:37:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 227BB120299
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:37:44 +0000 (UTC)
X-FDA: 84717139248.24.C19DD6F
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 45E9540005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:37:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BY1f1S2f;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777599462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXTXvru2GO3NZn+5sTz42Mp4kDJWE6wNo4KhGjLHTqU=;
	b=bcRqYBBvk+cWRwAEEvVuRq1O3N1GWcdLfvlkBpCjsRCOXRfVoGdZ8mi8fozEgu9t336ytD
	OBbFwLlSqoXL8JfC5coaGxQgmOUSa+qR0AL/9NRRDXj/3lZeqbogAMxXVgmZoCc30O7aZJ
	cCWvZevlTsDS1uxlWM1v5r+U0Hj/3rg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BY1f1S2f;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777599462; a=rsa-sha256;
	cv=none;
	b=5VM0dcPgiw45e7rUTHx5X99jb3jIZwTk1J78ts7zNziYkveafF7KCtnux/FtKQE5809bCs
	H0UiRcqL0TnfygHpYthfXio6xya1kZUo/7H0WXk7FSYYextJ1UmG2OC85TLK903BVtMtd0
	7p/gQT6nBo4OzSyshkt6H7NxqADi18k=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c76c60c7502so1066712a12.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777599461; x=1778204261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXTXvru2GO3NZn+5sTz42Mp4kDJWE6wNo4KhGjLHTqU=;
        b=BY1f1S2fZvaPCpTfNZkeMDKrQDnbPeGztOS3Fkrva2AhneS/71lXs7xRyThRNzwBfx
         dz1vUB8QA9QgsimnDkOVCJaFX7tZdjaCPEWWy0GDlNnGfYxaC8PVjLkQWn03Kq1bJV+j
         vyFOs9ThVyQeSantCEMgjzDw/ndkTTEQlJPN9pM7O5gImQM71JxCLQkX33vTDrq2Ybvc
         SC3KsgVUCMHqDwFtvPlqt7LxemQbw9A+Z1SjLrsr2vM2ONB5juNWP1X4peWU0a1Hu6Mh
         wzNsQple6ybYGlOdXHkiQarzUrCOXsaaqwaulra7lIIxU7CbthHvpKGAMgPiQL1bACko
         To7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777599461; x=1778204261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QXTXvru2GO3NZn+5sTz42Mp4kDJWE6wNo4KhGjLHTqU=;
        b=oM2+IBgq86rWv6V46th/yYUvcRzb4WVXM47UPB2+J3WeoxytIxiA3BG5ZQwASEV8Bh
         cWAiemDmo0DjRHoc3KdkfYUIuoyVfg5vIbluHO3Hs/ff3GGQLRzPQSsOuH1Zwh/mzma/
         vC8kbPS/lR4hwbyAdpbYyyZDEBJO5ussgrLI22a6evwABDMV52EunF/x9U8hduCZdoGG
         +RDnZtIwCG4caPOyRRJxCajtHJWqmCn5+lfIDDfNN9wuEyTuvnjIZfNN8r6wKi7ZMVdl
         2Hvl/wrcWC9emqF7eYM5laL0PAuIvIMZ/3Y+5gJlmULRO3+1jm0ZL7H4vIqnfX/9sL42
         Nc+w==
X-Forwarded-Encrypted: i=1; AFNElJ/VG+YGueZwynZxK0WeKk6b3VQ7vNTkZxmA4LERbJEaDhZDddH8rhIsON5sTJ16kTkvAdokmZL+WQ==@kvack.org
X-Gm-Message-State: AOJu0YxA0qYUG9Zh8ccThOSocqhXU1oiLQWqEs87n6kGfxhVsj3zKUT+
	C/DwCLFAHKBCEJFvOjF+7bSMe5a13tqbbuPes/CMmy7+bDBu0WCEoPht
X-Gm-Gg: AeBDievlx7uxzw4I+U3x3EMBFLF1wMSa4gDBJhdDapt5kkce7FCIdBXAfnQGg1FWB9L
	iSRC0DmPULyaQE9pOeuPbxmAPeCJyIqETyhJ2vxmGT5NHoQIP065XdinLpOgOq3gKN7mEQsbJZo
	wFFXnLbvOkvFB2VnxAvq3t8vxSzbpKSJMle+uNLWbJWXoFn0kqkOJPjXH3A6l6Pui4Yag/UFRgi
	hgXj8Vha2SUPJBnvSog3PwArFKQ4yqMdeKWShGa/aJ+lgWfbXtT4L61vkRmEwqnkrdCaT5ERwMu
	Bs2r1Eflm+AK5xNrSr8ITewcYRjHvY1+ELf2/V/tPwfe8vNEGBtZdhYKdSsJNO/VJP1RVVLrU9e
	AUwvxcVsbPuu2lhuZANXwLJFOBlWeP2oKwM4SYvNAAfhZvE40yPhBrC61BqolCqFddRrgtUs84T
	+5GAAOba0uhBU0huN8sbXCW4ZBetkPjPkSuwQXypwuWbwIP2zgTN9gFOpOqTN4YaBXYlns/Yw=
X-Received: by 2002:a05:6a20:6a1b:b0:3a2:c7e1:ff93 with SMTP id adf61e73a8af0-3a3d1d0b668mr4732006637.8.1777599460987;
        Thu, 30 Apr 2026 18:37:40 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8f3:e8d0:1478:fdf:dfb3:daec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b02935sm956318b3a.41.2026.04.30.18.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 18:37:40 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v5 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri,  1 May 2026 09:37:49 +0800
Message-ID: <20260501013750.71704-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260501013750.71704-1-aethernet65535@gmail.com>
References: <20260501013750.71704-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 45E9540005
X-Stat-Signature: cs8ojb1ndrh1q9aabyu97utdfdcoys38
X-HE-Tag: 1777599462-464696
X-HE-Meta: U2FsdGVkX1/cT1sKCCI7YSgMZpeD+6ssLvHo04gjdE9ZB3L3rmuI+IgnUnnvKyck9z9i4oTLZ0RMP4a3faxRjpH2UYZ92hCIq+BstkzAW9eDhRnV+oG3bfyh7KEUKsGeevslsgPeL4awghdGJRo40FP19cIih513w6xnyAUYVOAezNB0UtY9zVWDHoRQyRZOUO4Wcmzr3HWqrJk9b01K2HDwWJcN48HHGqfqgLYuVyeBPIj4ftmqHgx+/kaFUfQApLPs4waoJYPg6hotJ45gvdTtGw5Q+Bdq+K910DXZpby07pa3wXsRtsmTIDuOkKLEWen/zC1qP6xa3VA6KsruZ2delY2XxKQnktt1H7QO7buVAemrwfcDjEEOWAbeJFmkgNbTvNknG092ZxGc5HNmTMPHBuT3dCROH+xgX/8KAo6X9l2Fu/QSLe/tuJGaO2djqnW+PF0F3C1SDIIXyaFp0/Mhszm50jDiXPp2bM1UKapxVto8lNtrxz/tf0jI+Ly5LWv4pvWjaByjD6edcc0cFg1LmkYl+vD0wT2nxGH1bwsQ69JFOGeT/3OCHJtwItXs7UAhLkIJMa7Ye/JuE8ECfu9fGSNlyfJrI6yN0GWw29Jk5WWxGhcsCAv1RoYdoIqO5HbCfwloS7U/sgni6lZLy+XwU4wTBn5eI1sf+9q37eh22OMo4hNRYO+0nwIIWfGh/d9r1ygCemnenMTLc8sDAlMcbnH99no1WkUfvKL3Vr+Rwt1cBFTe5PvAjOfvO1bnAAi2tEk1bbv9f8KrxgTVEswiMkCSEhTc2sn2xX5XiY8OmPmU6iOQIe3KHsbgm82YP4r1M+tsPFF6RDO0Zy9LQkxVSCb/UpRJ+G954Jpjq+ZJbPgRVzK21e0elVxPi+PB6QXmHq8tF1HOAC8RW0vq5ur7w5vTpa3R4MknFdxcceA5yaCYia9aK5kjFWUGQz++aw6yYa97ablMLAXxojI
 BvjqEsmZ
 4TBnK37Y4J0dq9VE+LShrxrbqIF+qvhnAoEb/98iAcmKioCLxRgomyhGKm7sDnmTXCvH15fsdgtzrtQQcxLeNd9BCPZlTz32FH6YIicFyZfOWawTfDzbErAAraxj2QCTdcksnzXmaHUlUAkHIn2bVSRVCqcL8ZI8/GnZIIYuDOaU4pLAIlJhWoOdl+amM6h5edONot6uwmRIwMxzK1l7+3gAUvSGL2Kj8W16BXfWd3Qpuu40QiK5PDtRSPltrw4IMtIZNqaw0H0Rsg+SI2yoJTQqxabBobaWmZVp1y7aWRzi0/HB1rtQsKRc1a0Ne9thzHf2cg2Ofq8sdEGLxsCs2VzFQyRKRM1N1gc78ZdYBRzOp8PYWaKsxFO3uefWytg0qbqhpcETvb9+tDZHuomCJMOXj7bZoBMw/xEd80C/PS71P9AVhp3MnZx70FtoRFNj/A0t7KGZTDtzJa/vJKXnziV7jxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_LRU_SORT,
'min_region_sz' becomes a non-power-of-2 value. While damon_commit_ctx()
correctly detects this and returns -EINVAL, it sets the
'maybe_corrupted' flag during this process.

This flag causes the running kdamond to terminate. While the termination
is a safety measure, it is suboptimal in this case because the error is
just a simple invalid input from the user, which shouldn't neccessitate
stopping the kdamond.

Reproduction
============
1. Enable DAMON_LRU_SORT
2. Set addr_unit=3
3. Commit inputs via 'commit_inputs'
4. Observe kdamond termination

Solution
========
Add an early validation in damon_lru_sort_apply_parameters() to check
'min_region_sz' before any state change occurs. If it is non-power-of-2,
return -EINVAL immediately, preventing 'maybe_corrupted' from being set.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/lru_sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..3fd176ef9d9c 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0


