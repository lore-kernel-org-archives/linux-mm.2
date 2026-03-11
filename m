Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E6811125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8F96B0092; Wed, 11 Mar 2026 15:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD746B0093; Wed, 11 Mar 2026 15:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF29A6B0095; Wed, 11 Mar 2026 15:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C00DB6B0092
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65A6813AB3A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:02 +0000 (UTC)
X-FDA: 84534828084.19.35C90D2
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8678040013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZDtN601C;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnVFn/QWUod1peerD4NOctgVgrZtb1oHuY7D76awS8Y=;
	b=A5vOCvHyKS7nADm0Ho4Z3AU3u2a4pB2Da9H6xAiGKEh9wPeCxF+HotOcRBMtLyLahWtVoR
	NhL7ei8aq3Sotdon2N2zDXi14UDUQJhIii9bQk9hwSU3cOVtEH1fIOQz/GF8NItWzqmB/2
	8Eyx3mYc2kIXT9nKosBECuPN+9/w//E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZDtN601C;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258720; a=rsa-sha256;
	cv=none;
	b=EMN8/7lNIFk0HcUH3eFr7s4Ljbexy2H+BvapKcjCIDM5ubjNaiT0YsrjY6UVQw8G5p0/c6
	66EP8ZEv9IfUS5iYOVcntDN8ue+tOl3g61RzJoxAXDnjiDclgcX16uryp722b5ET7UNEw1
	FkpNusixG+gvzdeogJTmhc/Gqx/Wi9M=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-46704fbf62dso203746b6e.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258719; x=1773863519; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnVFn/QWUod1peerD4NOctgVgrZtb1oHuY7D76awS8Y=;
        b=ZDtN601CWGexamXyxYsVhJBxIAWOUalchVhoCU8KXQRfysUu432JG1Tx7KcT3Tv7AY
         tFRhKOoIqr9S1ZQnSzWNaidouKo7zK8P8DD4GWEET/0u/Xs4QEvKiKdL7EOjqFrtWOAR
         KAAAfEwmr4zr06Qs+YMPSKxzrZ7t54OgdzfpySv0dIFOJZfbRGpCbKqVA9sS75zoIUaD
         8yYM9ALPH6htdjCsjiO6yBZBAHKt4rOXL7eJB5IPliIzjzE73T978pdgWA5jY9e25iNC
         KQ8hd7wbFxR+5y+qp9D8I3ovO9Pl8gqV2YDEn2Rcbzf3txzTHXxRpPHnuczQvgjV/BLd
         5z5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258719; x=1773863519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mnVFn/QWUod1peerD4NOctgVgrZtb1oHuY7D76awS8Y=;
        b=lpXNJajOMn73MbJVKT7AA+7waxqEc3LTo2u/Zo/DeyYaZ/tolGARnKGjAhPY380HgR
         c/s+nNuHVIfMnJHmNSpmVvbOGgtokt+NwQ8kPXE9OH3g1IpRmlTeI8RJnYQSeEeTImh6
         AUb7Qn3pvsBSFa1zJvifGaFIhNZDk2sp7YnlrQ+iwXSKrIPH+yBs3hudZu7o+HeRWI2c
         fvw6mVcPAeLDqUjSMlavAJ5BBgCjuP06e2Fl7swXjeF0885cIO1zxoabi61OOU6M+ehv
         MXmNJdMft60/JrCOl9k49wiUHFndWo8hvXNBze3bxizko+iMePdebhFLM0xXBrOO9t/i
         TGgw==
X-Forwarded-Encrypted: i=1; AJvYcCWF8L9Ad6uGaIEAs2WIkPlLTakC2gT0DGn8Y0SPpYAP4pdBFQE9SkuZYVIOWRxClu9pi1pM3k4usQ==@kvack.org
X-Gm-Message-State: AOJu0YyBrOE5BqudvJAyb6jHe7NXzWhwLT/dxGLRNMtD17wbfC42nx30
	5/eE+aMKTZIgHrYLYu5rawrdbADXM/glvtVpFqydX6xijWk8nr7njpWt
X-Gm-Gg: ATEYQzz4ox+pxed6XxTi0UX3qkyL3xBNqwLQQZ2y1JnArfnJHw5xU9hBLyBzuOsR3sR
	VzGBIWZC0lTxqXoptGtO7dM7S9LlhLo5fTRjd7DkFKPvpZdV0cn0PpGHSp2BA0SoU3yUiAqc9WR
	SGwSmrn7YudtaWllUZdldfYmnMCULwY1GzIBTtIRlHCTqCcXYoJbVPPfpXRjPLHlxXkGl2yHQvi
	tx66+ptYZs3y6SKTlotAW3uzcZIm0vB9SxI32L0hnEAHpxXkvOWT1QHPONHdTxiH3CoV2cXnmtt
	Hppi2at1F4627S664e7TvgCMUOUBqnnmTj4XstmGfRXOUov6Psj2NhePVYpPoDd5HVgSymVZjxZ
	AlDEjQSWpwwS2akMSZkQJwa3MIKUEJW0Z4h8RCJkkdcCHcbVLblgLLNCd+fgKIT8jvIR93uEVDm
	sSP8Uyq8qjyJLLMqkZkASe/A==
X-Received: by 2002:a05:6808:6a83:b0:462:d09a:cdca with SMTP id 5614622812f47-46733545ca6mr2042383b6e.32.1773258719499;
        Wed, 11 Mar 2026 12:51:59 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e5e94b4sm2862488fac.11.2026.03.11.12.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:51:59 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 04/11] mm/zsmalloc: Introduce objcgs pointer in struct zspage
Date: Wed, 11 Mar 2026 12:51:41 -0700
Message-ID: <20260311195153.4013476-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8678040013
X-Stat-Signature: ps6shnx4gcb9ceargf8kk9jegdnfkauc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773258720-375509
X-HE-Meta: U2FsdGVkX18ubGTW1p3LpYXutoqxqSj7FsHb/RXuBigqUAkzFylxyBRF2//W8y+CkMqSDO/Eq2VkDX0ERXEesVtoGk5H6kaLok/NzgM5l8oYPJbwfXacZKJywMhzZ4X+0zWHZUVvLVqlhxlKIlK7kHtV2aol+al/H8NIiH+OT7tmzkrXdpTQR4jYQBGWtinKqCVZVhifPbk1oRHAxUaTU1BD47pmc59P9ItQa5WVLeBEfiHtb2rpiGFadP7/MfthVaeP9sPxVZWXb1+Pev3FJqstku7OoaxXs9zJ8Mnhuu2o+7YX7BlQwESO/8QKZJspPbnHadau9dNFqJmXE3F3t3p6efg/kHvIGH3YhRR86q4OTAD0C/GZVTjg04PhDKne1/VLU1u/nu+3Z4g83e1I1cNrwr1YD1j6Nndm+Z74Ss0JD5u3fv42gPwRL4Jst0X8AGNk/eUOLv0e1dY5a2iCz+B1FCY0a1AspS592RULOlNGLvEqfz06H41w0f8DjqL+Jp/n2AYiwd0L0NcVOTjk+nA5W7QY3k8J1O1kGFscYpPQa/EEDjP/Ju+BkqlHTz6L2833apIuVJ8WDAvgM1GUHlaZPDUkRj17j18eKpzQ0vm5+cK3/2sdTuWNzF58+6G9QDkfpGRx68QbPUMIAshDpI1wfuwuAFet2LVhA36duf95OFUQz0i/Xj7eL99kRCtQ2TpyJBtTX2B2+gbEdQv3zD7qmx1/0jqGzpYyCIKRJfJA2E7yDwW9vzE+X4SAKU6dT31mcSCtDWH4TYEqTuVmlNIXHOmeqWTM0/RNjlYHK6paSdtp0cuBnn544yNx0NAmFNsNd36N7m7pgZnNaEQVLxNTEXUO0tqjE/C62t8lApyTCH2tKEvso2lvLUwzq3GeuQ7Cwu5OOzbNZQti9K/PcP/WmHdZ2qZuUnOCK5VDhhRPn+D5iP0NeSVGYEvXLvRXXdpl6bsotmT7dbJ5fAG
 7ksh/paw
 At0Iq77sy5Vj3Rjfnbc47Aivweb6dNzL3LDTqXJZEX3jSSzwl4PBgqD1RL5uC/bpC6zASGe5MF1Zhzv2q0r452lJbsxYbTFTtuYtplx9pCE7lwKHEOijm9dxzSNhvE1mad+Mo2Ze/p8UiuvmMC/G7EfGI9ggGk7rWfBBnVliBBGDcNuADWCqVuoOhw+3a2WN5OUUVI1ZTExCrbAHa+1t8eq/GC2yyhjY1u5xNf5ovuhM2uuAXvxXloMr02rwVbfialGnBapphuWqnX5eQOBUzZZyVZPCza+m//Tu/43s7lCkFEIdS5x4Nz+zk2VeW00SrxFpCJ01K0tWqck/RkKa4r53Tv6khV4cLPWxm04n2Nk7UxgtK7lfsB2lwtE+piovp12C85qpndVNjfHKvJ6Yv3euHT1/qYnyMp6H/QsYwdC/xCCl1bJQZwwSiFfo5X0Vip9Mms9YLmCo419/Swt3dItXYvhE4hcsuZC7o9sPOHstWgWMWiuoQt+uMHPtDT7QctOG1MCdSWc/+f81sMnVrbG44zcIDUs3JbEQ3TB8bfcGDZ1R8zvyJxWFe64rMLQPNuOZ4+GtCwpNs8e4VEZ3tw/MtSDAu2f9rLd/1UbrIot1dM4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce an array of struct obj_cgroup pointers to zspage to keep track
of compressed objects' memcg ownership, if the zs_pool has been made to
be memcg-aware at creation time.

Move the error path for alloc_zspage to a jump label to simplify the
growing error handling path for a failed zpdesc allocation.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/zsmalloc.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 3f0f42b78314..dcf99516227c 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -39,6 +39,7 @@
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/memcontrol.h>
 #include "zpdesc.h"
 
 #define ZSPAGE_MAGIC	0x58
@@ -273,6 +274,7 @@ struct zspage {
 	struct zpdesc *first_zpdesc;
 	struct list_head list; /* fullness list */
 	struct zs_pool *pool;
+	struct obj_cgroup **objcgs;
 	struct zspage_lock zsl;
 };
 
@@ -825,6 +827,8 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 		zpdesc = next;
 	} while (zpdesc != NULL);
 
+	if (pool->memcg_aware)
+		kfree(zspage->objcgs);
 	cache_free_zspage(zspage);
 
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
@@ -946,6 +950,16 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 	if (!IS_ENABLED(CONFIG_COMPACTION))
 		gfp &= ~__GFP_MOVABLE;
 
+	if (pool->memcg_aware) {
+		zspage->objcgs = kcalloc(class->objs_per_zspage,
+					 sizeof(struct obj_cgroup *),
+					 gfp & ~__GFP_HIGHMEM);
+		if (!zspage->objcgs) {
+			cache_free_zspage(zspage);
+			return NULL;
+		}
+	}
+
 	zspage->magic = ZSPAGE_MAGIC;
 	zspage->pool = pool;
 	zspage->class = class->index;
@@ -955,14 +969,8 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 		struct zpdesc *zpdesc;
 
 		zpdesc = alloc_zpdesc(gfp, nid);
-		if (!zpdesc) {
-			while (--i >= 0) {
-				zpdesc_dec_zone_page_state(zpdescs[i]);
-				free_zpdesc(zpdescs[i]);
-			}
-			cache_free_zspage(zspage);
-			return NULL;
-		}
+		if (!zpdesc)
+			goto err;
 		__zpdesc_set_zsmalloc(zpdesc);
 
 		zpdesc_inc_zone_page_state(zpdesc);
@@ -973,6 +981,16 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 	init_zspage(class, zspage);
 
 	return zspage;
+
+err:
+	while (--i >= 0) {
+		zpdesc_dec_zone_page_state(zpdescs[i]);
+		free_zpdesc(zpdescs[i]);
+	}
+	if (pool->memcg_aware)
+		kfree(zspage->objcgs);
+	cache_free_zspage(zspage);
+	return NULL;
 }
 
 static struct zspage *find_get_zspage(struct size_class *class)
-- 
2.52.0


