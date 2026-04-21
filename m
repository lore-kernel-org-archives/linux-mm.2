Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33475F8FA66
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789F96B0089; Tue, 21 Apr 2026 08:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761806B008A; Tue, 21 Apr 2026 08:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650606B008C; Tue, 21 Apr 2026 08:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 581346B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:16:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F03701A0BD0
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:39 +0000 (UTC)
X-FDA: 84682461318.30.A824728
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1A3C24000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NnMd5t0n;
	spf=pass (imf17.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776773798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jm1uZfhnuhLjYk2Ukt+cLbqh8Cqoh4c1TPve8K7i0ls=;
	b=pFVI56tbHbi1d5IozqY19iH8Tq8Qr3qsw6MIVkGaxDL7xKIHtfHO2WoQaGO4VeNupasrb7
	PCgPUZBRRJ9cn6MTHE203W3DxYAsYFLsKQ0NYBiHJYDGZsYyroHjsR+U9qvIKIolzCJ2T8
	dpcPrCfZutduDlCmzvnaubHLWlgGTdA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NnMd5t0n;
	spf=pass (imf17.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776773798; a=rsa-sha256;
	cv=none;
	b=Ed8IlViNfhXb82wlGXs5mp7G+eK3syg7RhrV5YtP4KaczB1vB10NA/YA7zmNp0HBfM7BSZ
	LdwccUlHOyuAX/GZHFhMgP9FlzlCM9RMRXk+8ualaqLr7VTpj080eb5H/p6htpBOz3G/oe
	+4U4lWPXQPMb1AB54FYqWq+4VYcDpRE=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82ce2e2880cso2788398b3a.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776773797; x=1777378597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jm1uZfhnuhLjYk2Ukt+cLbqh8Cqoh4c1TPve8K7i0ls=;
        b=NnMd5t0ny44eifSWM4qYR2ak24tNduBo5F+m8XzLfBnhW9vBYI0Q5P27BIHWCMkB4w
         M4wgIxXcnnmIRFEdhQ6KSB7C2yE6MVnBDL/RyH9G+i0wdktHnb7vh9Rd+nUgjokrSCGo
         zbOTUncNdwzeOfqzmPOAbBgFz8ElQjhEeRDI46Z/v+rrUTcwYo8Fh2g3S5s2A++uns1I
         UYrgy97Az6YOKe+r/ADLT80ZgNan6OZHWrdWKMK8VICvDvpOFFHPh9ncndywlZTckVb/
         P2c43l6dgjqMCUn3I9CWZwpG4YwEWYruGPiO2LHkXEXKGDQ7hrhpM7eKMyZmaisR2pxh
         stVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776773797; x=1777378597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jm1uZfhnuhLjYk2Ukt+cLbqh8Cqoh4c1TPve8K7i0ls=;
        b=syPavYJHziiR05L8NsYa4u7Om28Yci1pctqV/DmWYkzbyYJ9fyE77EyK+7aEMJTYMC
         jx+0CSL03KivngFOXM+3l6X0SyjqVUj99v2X4lUIFEP73kA3STqOiz7DXzGzm+lVXjtC
         +2rEO6lBD8sLL+xojE2ms2kKO2lwVTrX9hJ6Tr6aoX3W/LWA5U+qWlX5P4pIzmUtvsun
         /Vk6/YYTarMyDsIDuTDXbwOZVJhPszahy8eKRv4sfyLvlvZk+4fvSQqj40Ta6M4sOmXN
         VglAoK0++j1ijKuVApXF8b86+W0s5P8QDbcNFcGoxo2QSkrY4/31UgHFAukubUGhXh9W
         aByA==
X-Forwarded-Encrypted: i=1; AFNElJ8bPeVYJReI9C59S7MhGpUSx5/6tQ8Nm64XyuvJXA/4D8OYv7Jec9pMHG9sVxuVPGEMq/zLWGaTmA==@kvack.org
X-Gm-Message-State: AOJu0YzR9VXThTIDW6Mq4kvSLxBqWDnX9AK8i9RH5Oht03P+wM+t6Jn4
	i5pijajrewGCso+pag+znmDeV6Js5gwWym7f3Ax2L+NEpZxfKIPF8b39
X-Gm-Gg: AeBDiesJgtjtqAIld9+hZsSaweWqFQPKMhCmEczqCBjFEHVtckWx+2B7Oa0G1H16Orl
	Gu/oYwFKfE3DJkNAIDznUBAzpKh3Ii4X+G9FQJP6kbD1Z2BCIQ2m2B3GIb861EMX4LbCoq1q7eW
	5oTThMVebXHzybqj/DDv0flsvkEOS7Y3xILc7uwjQttddjhO6wyW2rkQQQ99V5M7yw7XwswIE5F
	XkMPqWCk49wrqBvHEczBm+/PxXUa7ycILWBIbuPcezv5o8Nj/uJyrf3TTed+MK7w5HP6eAmZiNj
	Ng6prEjXJXzox5wrN2SAMFb/NCDkvyPj8Xqw6bGDCWwh7+XpEaXp9glhkKreoXnrdZAkwSOn+br
	8gdo247HMBnfWARdJSwnM06QTwguvPxPrCLhMqcTm2VgDfsPjgkbs5ITlo4YQvHvNtAL5AmnAnL
	s3lXLjnZKDqFTghSeFoF1wNspmA7TAosqeEYIaAGoLRZ21Q0E=
X-Received: by 2002:a05:6a00:2e91:b0:829:9a7b:db84 with SMTP id d2e1a72fcca58-82f8c97e604mr19692584b3a.49.1776773796869;
        Tue, 21 Apr 2026 05:16:36 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec037e1sm16371071b3a.54.2026.04.21.05.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 05:16:36 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v2 1/4] mm:zsmalloc: drop class lock before freeing zspage
Date: Tue, 21 Apr 2026 20:16:13 +0800
Message-Id: <20260421121616.3298845-2-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260421121616.3298845-1-haowenchao@xiaomi.com>
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A3C24000C
X-Stat-Signature: c7ekkomtu5k33e84i7wby1u1k7ra8e1z
X-Rspam-User: 
X-HE-Tag: 1776773797-932994
X-HE-Meta: U2FsdGVkX19F10LFZpsSEhdR1IUdZ9Jbeo3TaJwriD7kGg8dljEvzpW3agfWJpoqYKRkfDDux5+Slnh0MTqZFYN+FATNm9ILAE2zmNT70grp7UjTHuNo2SRIc77UbUSYxSysr9evT7sq/vmf4AKZHFF6nu9UzSvm8MGdKicZL2x8iw+Ir70E4ie6UxF2F9QWlpgWohyEqVFahVkUGVaFFcA5d1nSiLCNsT0YPxWhBOvjCLlr7R0Uuh5yk8Yl1tRlAIRsPoHJFQmI8JFMKlxFWAUsdYoqxd/NHS0QmKifVsMEEyzB0DpMY0qa6JvkWHGdTmm709zJtFn6fogJem/IPexDm0/7wQIFXSD/gQwBP3RCWGv5QdT2dG73JDNoEIqSu7I9x9ujSq1mfTZr7RbPiBsKDw2h+2PdAzgno+KwdJHuOorPnesVLOSOlz2NRymt/dEZd1GfaSLzozb4OyqFYDMsRngWT6UzQhnkkkMWimR4ITEuQAf2hYaWI5J5UXMM4SzOellXxuP67fwmSINMjegC5omu7AGhEKUnfH4OL+XFFikVV49AV2/ov6TEFHr6sKkAY18JmV8rp5ujTakeliADgH3ul/Dy/rKMH1CQLrn7X9hd9Q6BPeeYsbdxczYvcjWKw3R7RizV5LGs5oAFswF7Xz6ZslEsAUTL6GbTkj5bAOVjcmcxN3k8q8PztVNvWGSpVMDk9oV90H0TQveSAxUf5Sg7iJQrl0kHQ9E1mNgMHwNX8asd2wDweIsbjegHjThkmo5sFczgqzzkkSJzvyYddATdDJ6gdz+fN9n53lNE9a4n156wz8uZQQ/ycmMFpF3DAsGP+E+InVP+V8NYBCO1jXL+mFC0feyg491ENLYh/Vqb+oYAvCaYhZloPQwveWKMkN03fkG4oarNwiELQDjwvMQTmewWAPW9rTxaBrCo6O5SJEiYePXXs9CHcQP2lwJj0EjbOmdg/mKBDli
 JUPlsyaQ
 cIsXblYL5BocT2TNSWm3Pfphs5vM9Dyo88KwkQYm2Hj8EKMh6Ej+ft6/SmDl+cSK496Y35UiYMZjdBZ4ZIKMYDo9BUS8MJGxCjGNEJ31GUgcVzoJCiRQVqZYbTgWYhDbtqrSC05nsnG7mt74PwRh6TUcjRKQlv/38tYPPVY5s17bGcN2l8cUnbPOUdy8ItmdSBNTKJgFYcgdwPHQMPW7uV5arx7wOnJN+UwMloybP4AabIISKaoVwbZoZzN+OMIJiF9UCM+lBOh4ksV/Ck80WJ+UnZ6nALzAPDHqOl4uwEA84fdhBN9GZpK/XAQPuxoQ1DyZDAjyur6vWhAPr6j/nnPZjIGcrB4ehtnGYNOi8fN8FSvzF5ZeJlYhq/z439G8ketV82tFJ5Jdf7eUJ8/abTuCyJ9Il0s9oJMgP80J4gMavKgYLXYRL6FekdOsfHSuezeA0yld390FAewBaCElBAHJ1zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Currently in zs_free(), the class->lock is held until the zspage is
completely freed and the counters are updated. However, freeing pages back
to the buddy allocator requires acquiring the zone lock.

Under heavy memory pressure, zone lock contention can be severe. When this
happens, the CPU holding the class->lock will stall waiting for the zone
lock, thereby blocking all other CPUs attempting to acquire the same
class->lock.

This patch shrinks the critical section of the class->lock to reduce lock
contention. By moving the actual page freeing process outside the
class->lock, we can improve the concurrency performance of zs_free().

Testing on the RADXA O6 platform shows that with 12 CPUs concurrently
performing zs_free() operations, the execution time is reduced by 20%.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63128ddb7959..40687c8a7469 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -801,13 +801,10 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
-static void __free_zspage(struct zs_pool *pool, struct size_class *class,
-				struct zspage *zspage)
+static inline void __free_zspage_lockless(struct zs_pool *pool, struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
 
-	assert_spin_locked(&class->lock);
-
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
@@ -823,7 +820,13 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 	} while (zpdesc != NULL);
 
 	cache_free_zspage(zspage);
+}
 
+static void __free_zspage(struct zs_pool *pool, struct size_class *class,
+				struct zspage *zspage)
+{
+	assert_spin_locked(&class->lock);
+	__free_zspage_lockless(pool, zspage);
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 }
@@ -1388,6 +1391,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
+	struct zspage *zspage_to_free = NULL;
 
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
@@ -1408,10 +1412,22 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	obj_free(class->size, obj);
 
 	fullness = fix_fullness_group(class, zspage);
-	if (fullness == ZS_INUSE_RATIO_0)
-		free_zspage(pool, class, zspage);
+	if (fullness == ZS_INUSE_RATIO_0) {
+		if (trylock_zspage(zspage)) {
+			remove_zspage(class, zspage);
+			class_stat_sub(class, ZS_OBJS_ALLOCATED,
+				class->objs_per_zspage);
+			zspage_to_free = zspage;
+		} else
+			kick_deferred_free(pool);
+	}
 
 	spin_unlock(&class->lock);
+
+	if (likely(zspage_to_free)) {
+		__free_zspage_lockless(pool, zspage_to_free);
+		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
+	}
 	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
-- 
2.34.1


