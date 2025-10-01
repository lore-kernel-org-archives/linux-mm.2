Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371F0CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB018E0013; Wed,  1 Oct 2025 15:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ABCD8E0003; Wed,  1 Oct 2025 15:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725698E0013; Wed,  1 Oct 2025 15:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A65D8E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:27:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23C19139F3F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:27:01 +0000 (UTC)
X-FDA: 83950528242.25.D767235
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 41B3740008
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cw6xSQPs;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGcXmCAAujJZjKkzb6sJy5VjUrvDSK+t0JgV9AfB/HU=;
	b=A+ojdT1DIYohjT9zRI15M559vGWLD7yf/oTALQmUYIdT3yhXP/Y7jrD4VD9mRwIaX2OX+q
	nJeXO3IeUjMzfqO5wQINjKjmsYT8JCuqlWQmX8yK6/ZyyQjT2Qp7IGm6ziEY0p4ocJyu+L
	NajqHpBoGj2oHVEJr0a99eXM5e5k9TY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cw6xSQPs;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346819; a=rsa-sha256;
	cv=none;
	b=Naf+Kqp6/0Z+4v5XGjs/CEsriby9jZrNNaf6Edo4Z5hV0DFWWtzYvmEkeIVs+5Dy+AlEAl
	S3MqdhB4zWzyjcVQPj5li98lFUVXdTLVpekhTAvkChKma3gCvuWzUq1CLdO0h+VAsWHLcc
	jNyUJYFuNKURicEQn57X/tlggLWEggg=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-57e8e67aa3eso1969422e87.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346818; x=1759951618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGcXmCAAujJZjKkzb6sJy5VjUrvDSK+t0JgV9AfB/HU=;
        b=cw6xSQPsr36F1ZRc3Ho+155gI++qVkR5+qSv/J9VTmhsHXugzE3bVInvwZQf7VUzyR
         9jWbORZhI0IS+lffKqYqlqv6XK8VJjne0rvVc5A7vb/Kh2KfPuyiUDrYWTLYlCcHfJJx
         pKuP4j+IzIWtFyQXy901ubp585sNAwXgxAzbst/iPMfebF9FSX/s36lM9333dl6Y9nA+
         C3v18/ocxrVXsR1yUJI9t4gTIFBr47IJLlDk92VMymKawZUvdR18FNn5qBO1DjSZT1+j
         o6UMJBobQimyAcrQhZLRuOlH0YW1pHa06cWVKFi0hPMdwN36JmTGQaeJOUoaQTeuOl0X
         UkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346818; x=1759951618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGcXmCAAujJZjKkzb6sJy5VjUrvDSK+t0JgV9AfB/HU=;
        b=nr3u+9tNvG54KXM/ua0ktg7wZM/lny82YKRvKP67wbViKthhm/8s5l93h2ygTg++rD
         8d9u0PlSgaQiw4e3zKkXkJStUpKJk0LFzkC3pjHg+q2wo8luzvx6svW4DGNgDfxyG1YT
         7FZ29H4aaJEQjeF4gMsmE2rIGG0+g6i86BHaMhmeVn2Hj9HDk6UPGoOCRJ8efZZt6G20
         8HLYwAvxmYD1Eo71OIZaKzsMfX7PukWwQzp7hDX/c9eOIzXmwC6PuuIZ2icVR2hnUxF7
         K/Be3UykdH21rPhZLFovxUDaeGafPUfezHyYjqxDNyh/94wYXjJtwKMnk1MhGMjtssyc
         AGKw==
X-Gm-Message-State: AOJu0YyYrsXps3T4+XyXyCg2OdQ8MCfg5N8jNt3zogqiuh/PGZZjwone
	dOxWxbwNshpBAGHnzx6AbsWlVzmoA2cjUniBYejjkPisIVyEw4trP3NsYDWC2EjT4C8=
X-Gm-Gg: ASbGncvTr/CoOWIyotWZsuekSl0LMNqATyFxKcmtCpoq02Qx2WyvYfFy5IjP6L4I0x8
	6DIoPfLbd393qjVkUv6h2tDHpbcdhJG3hvEpiv7D3zHbARn+u8LSyJktOuOm6MP/shSeE8mDjZE
	SGXRuR6n66YFNUoANKUcrFkPhzD7ZdQ+vU3OENmIyyEyRq1tTjxsJHwmoPnttNyeesnp2i70SSj
	xlLWxe8FZ2xBF6KDzSy3j27ViwFFWHUA7RAkKbuHX1LyG80rEX7V7dumyn9gY4hlHAbD2noZhj+
	BoOJGPjq9VmBkum147AAvtYudpGRZ0bmtjbH/tGLSplJwDwrGhYftcvZNZlfjuS8VDnFsz0WRmf
	x9eHwr1qWVt6Z+3T07norjO6+TSDBLy8Y9NpV0pnj
X-Google-Smtp-Source: AGHT+IFj81R2vtq1WyCNBYlhGONs/CusB8poOp8hUY/5PYbf+QgHwaSgauT7SatCZSoEjPU1zHqd6A==
X-Received: by 2002:a05:6512:3da6:b0:585:1a9b:8b9a with SMTP id 2adb3069b0e04-58b00b5eb5cmr248354e87.9.1759346817420;
        Wed, 01 Oct 2025 12:26:57 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:56 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v3 10/10] mm: kvmalloc: Add non-blocking support for vmalloc
Date: Wed,  1 Oct 2025 21:26:46 +0200
Message-ID: <20251001192647.195204-11-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 41B3740008
X-Rspamd-Server: rspam05
X-Stat-Signature: 7ue8mufkyrisje5ub5b5iqaaa6xr5r1d
X-Rspam-User: 
X-HE-Tag: 1759346818-473706
X-HE-Meta: U2FsdGVkX1+a00F73C/fTTclERfEfP8FiX9cNnhPAmaU2YgvEa/FgHtjsfWooKd66w/WWoYRnqF6AKU2l337UwtiRTEnwiWZEfxzS6wfnQCuYQJBv84wTX+nn0YoelTYYld9FsIdLjTEeWIQYt+Ebal64MiJAQtURi8XDBN4MmjgSDBgv2R/FoYnm8fDSgBtOYXsSHb13p78DmvD1lt8n/GkCx4ZVb/h5Deo5HyD8uy0Sh91pjnwB4TcV29rbA0ODn71K2VDekz89F6ySiD+T8L9e+SKq+HLBpHi4d4SMwFT1QxVTNQ4v1KxPGVvD2lqxYVRxtOJVlUGUFCAjlHDG8QaVdQDcXYt8/HMFiKAnd9LOAuC5f6j7JXvjRB/Q+Wo36S6KJQVjaIffDBdCzsQiBShmBVugv1texqxXwC2YlbcL8Vvi4oiYSRNQYF6aPDxwWwpbdBB5MKmH3Weq6fDZNccjG+2o26IvpVloJXzzSgX0CchLrgd7XZDyeoRdDlYftBPzZJuLgbs+2/GOTIBkBumA0ltm3pMqgS09Kh9rXZhOoZxStqKRVw9AhpwX81aA0DmKjDORQKN6FWfyxyFe7N+y3J+De9PK2r1ZJGa6IBG47Yr4aaQy+b3uhNROqDKtVigXIhey/HanWbp7b7BP1Hn85aJvHBmDdBB/ggvHdSgg4CXKMNDDOHDpWluTr39lUrRAAdhEUQQkLytx1U9qrSY1u3aObPtsv7THMFSkfpHBQMg8DSB/Py2U5hSj3bvEZ7zvIZiXb+SBV2kFkqWuwncEfbBVEaPlAwh84SBin6MT8YMBL17bYoTvyfi4OGRyTfvrbBmTjbnRxaAknd8Vvqcv/jkyHj6k+o8xDf6oTj/YZRbE6UyWYs2hu+PkB+zENZmxobjlz48EeqQeXTnOg3N/lRi02Gc1QAKNQS7isGTh5P94fcYB0FsQzJIcMFxaCfDSzPXdfRtYL8gsJb
 A8KRm+Lc
 sxVcMkmgGmauKk/4mfK6bETj8iWWZLp5Y/7GJ20MwvYBs0tf5QZ7uAMR9OlXoBD3l2II3ZbuK3F62Nsk90IsNAYlXe/6bzPRMaxeg9Ou9+8icGef2pBgFgvn94YG1/6572s+FcOgPciFYqvbA6uCwnXnU432DSq43wTUlG7YkzQ3Wi/a1ni476UWqu402ixiea0r3dYeK2khltcdkW8Af4YvWMD6UNGYmnvc+SpL4VONvvOK4BedVtoeereIG5eyIq8crBiGoWlDK9nQgGE2Q4Sk2xsPYx/75dMBZGxY4WuYwgTfdXwn+ksghDxeCygNECSup22hrz40jX8DaEbLVhacAyVSLnzj7YWwxLB9p1AFTUXOPwwTPIfpB9ALhNKrafVX6JgvJzTiLFTZEuPtdFm9PvTsXtiiN7EAM0bxdMHGwqsqasaTutzCYqCnL/pxwe6s856RkNRvuMco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend __kvmalloc_node_noprof() to handle non-blocking GFP flags
(GFP_NOWAIT and GFP_ATOMIC). Previously such flags were rejected,
returning NULL. With this change:

- kvmalloc() can fall back to vmalloc() if non-blocking contexts;
- for non-blocking allocations the VM_ALLOW_HUGE_VMAP option is
  disabled, since the huge mapping path still contains might_sleep();
- documentation update to reflect that GFP_NOWAIT and GFP_ATOMIC
  are now supported.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/slub.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 584a5ff1828b..3de0719e24e9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7018,7 +7018,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
  * Uses kmalloc to get the memory but if the allocation fails then falls back
  * to the vmalloc allocator. Use kvfree for freeing the memory.
  *
- * GFP_NOWAIT and GFP_ATOMIC are not supported, neither is the __GFP_NORETRY modifier.
+ * GFP_NOWAIT and GFP_ATOMIC are supported, the __GFP_NORETRY modifier is not.
  * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
  * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
@@ -7027,6 +7027,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
 void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 			     gfp_t flags, int node)
 {
+	bool allow_block;
 	void *ret;
 
 	/*
@@ -7039,16 +7040,22 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
-	/* non-sleeping allocations are not supported by vmalloc */
-	if (!gfpflags_allow_blocking(flags))
-		return NULL;
-
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {
 		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
 		return NULL;
 	}
 
+	/*
+	 * For non-blocking the VM_ALLOW_HUGE_VMAP is not used
+	 * because the huge-mapping path in vmalloc contains at
+	 * least one might_sleep() call.
+	 *
+	 * TODO: Revise huge-mapping path to support non-blocking
+	 * flags.
+	 */
+	allow_block = gfpflags_allow_blocking(flags);
+
 	/*
 	 * kvmalloc() can always use VM_ALLOW_HUGE_VMAP,
 	 * since the callers already cannot assume anything
@@ -7056,7 +7063,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 	 * protection games.
 	 */
 	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
-			flags, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
+			flags, PAGE_KERNEL, allow_block ? VM_ALLOW_HUGE_VMAP:0,
 			node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(__kvmalloc_node_noprof);
-- 
2.47.3


