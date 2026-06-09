Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE22CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198146B0096; Tue,  9 Jun 2026 07:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FEC6B0098; Tue,  9 Jun 2026 07:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05DED6B0099; Tue,  9 Jun 2026 07:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E77A76B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:36:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 849B1164951
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:36:07 +0000 (UTC)
X-FDA: 84860170374.01.F423F43
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9364320003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:36:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JTN1Ljss;
	spf=pass (imf03.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781004965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/nTjntuZjnrvE8ZyTpIYFayYnVSKdUVLKXvluFBzrU=;
	b=SUAFTV6QxV/5VAv7dxqLIPWgn8OH6r0q+0/rXiseutyr8eDipZJjTjz0B3FqW6YshOlNyv
	11M4Qzw8u+3dtjHAO+NtqLFjyhqWizwkZpJd4RrnFt1LvB2YUmnXizdR4cCoRUFHM/SFI1
	fYn7Y1Zt9m7le99R05p24b5v/D0EpDY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JTN1Ljss;
	spf=pass (imf03.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781004965;
	b=Iyxa/mfv3Yuf9ox11teoYF6fS17AQiXlofq6enQkmjOKE+TXN9LJeGBZ6Yn8E/mPHmvide
	dEBs2It4nY+zSIFmyJP2Ux9NyhczPT5bxLgHnAASzn1Lz/NJIokTLFuU+YUPjd6k6bWX4R
	MmrGtQS5w4a8UdSONYo49RG/eRAuWB8=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-36bd175fdbaso3338646a91.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781004964; x=1781609764; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/nTjntuZjnrvE8ZyTpIYFayYnVSKdUVLKXvluFBzrU=;
        b=JTN1LjsszpuJpVW3lUTGOSVFUijMEsBzxn3Wvig0Ww2uATknDbj+/L+UJln7cUqodD
         XHtr92A/FG7hGgE+S8PisN3kJHcYuRl/AlG85sYmBZXyIC9zV9FHIQnKmVpDfV5oZUca
         8hCOltAuM9jI377zMRbR9MyWoMix+mgkR663kNMaIRK/dX0RLV4ReUYKu32YdMrQiBip
         fp3MK1Ai/wfVvCWN2PQKJkKU8ybQNtIQRhtRt6vY8O5yZhOR9YABMKEAQbQtS3DuHAhe
         hY7tbS0bohtS00rwpxJCgwqcnasfDtwV2XkxxPjBTpsbZLmHyRfJnaqQuhCB6j/JZO9G
         rgng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781004964; x=1781609764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6/nTjntuZjnrvE8ZyTpIYFayYnVSKdUVLKXvluFBzrU=;
        b=m0NrKxUIB3EhdrnHCZc3hfkEaI1nmV3hwDKFQMSMbyoUUdWUsmf1ACDrODYVtb9QZ7
         gDTadmOzqPa3Y6pmxaRp/jrv5MY0f7sXyjp2UHs4r08OUl4c8OaH2B48PSsovLBW1f3I
         pQZkgIlRwl1JXv3hS5kdqRReNnj7EMH5nab/DhsQOR0khZXSZzhD3OT73tD9uQFRjEBZ
         671FDNRm7CyZSHs1WpyRz+2PE4Z+CTa97OK0yvKtkqWgviiA3nNfalWG2FCw+ehJlvW4
         d48Kd3ksQ0p6BL2HruW6KFzF/aBMAlHcTQc7NhoYp9a8DIZQyBzMEp42+Tys8/2g+n2j
         eBSg==
X-Forwarded-Encrypted: i=1; AFNElJ/QwVttt22l6FEkIP3jeaVoOpjHnaUfkv3MDNP2thlHrPL2GT8wG/ZfmPyg4kSfHrVn6loYYZBR3Q==@kvack.org
X-Gm-Message-State: AOJu0YwDzUXSN0FGDp7elgByuVwFAKtK7sSwa1M+rWnY5cCx/gIJGvUs
	wP5bNx2u5mZVvA7n0b+mhzVKpaWoT18DwYiCYEQ5oZRr9Q+sxZ8cVEvU
X-Gm-Gg: Acq92OEgNjaxknAqI4exk+mT5DX8V039XNWzfkKpvNoucMtErJXIvIR0QrKkEdveFWa
	bjgBRP0VISQnbLdumEA5Qi05XFJ/3LbpwH83gD9sixiOlnYQGtOUXsHqeMJhggnb+beuzBrx6FE
	BmLHF9W5OIRsQsvHNsGjmRqK8J8a63zhjZZ9SshIg+Q+LKeW3PKXfuRIgr9pENUmFEf/ZwEtwtE
	o86mK9rzoGNifPM5LYb3b/9zjh6ae5p+nvTm4jSfy9IYeps9snxW6z46KnkBQ8PEjBqB8kHIgW2
	jqS989rLMMSzq9SvbpOG8UkPC0xmDldsadtkTZPJgvW4Hd2ieY0TcZF0eB1g8YCTzZkoIztdDhv
	uF6PkHuxOUlCIPpUuSIBDznFXl7SrI4l03gKBpwaAtwdlH6X+Xb48tx7883JsJizMtwXnBQdtuy
	8jp3rrLxDKnESAW7PqO/qua8vDHgjjAh/7+oFFJcQL4TpZ06bX1w==
X-Received: by 2002:a17:90b:2742:b0:36a:c4b:76cf with SMTP id 98e67ed59e1d1-370f0b55e45mr21925890a91.23.1781004964510;
        Tue, 09 Jun 2026 04:36:04 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6c668e98sm19655292a91.5.2026.06.09.04.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:36:03 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v4 3/4] mm/zsmalloc: drop class lock before freeing zspage
Date: Tue,  9 Jun 2026 19:35:19 +0800
Message-Id: <20260609113520.3507783-4-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260609113520.3507783-1-haowenchao22@gmail.com>
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9364320003
X-Stat-Signature: tqfbowxoftab1gq3a6hqsrb58bh1ddou
X-Rspam-User: 
X-HE-Tag: 1781004965-941149
X-HE-Meta: U2FsdGVkX18FkmO/GIJ5b/luIxAB1C2rOE9GxUgqA7PLqZqE7w/AJ1FLlq+AhNEXFeth2O5Yp1i0xMySrhcIe96qYUVLBICffgP++J45wcxP0zrlSq90BuNyQ4Iass/xsxhoO848Q//0EllNc0PAY2sDr+h9lCsTW+E+DDFTIcuLOq5IKeagVXTFoAgUoTA91r3ckVbQDqsWPTEB0bFU67AbLFS41ZLSwSjfN/Tc/nuSTZSOVQoH5DKnVE+IE8njIOa4jsdwqqrrOJTj8DVaYYzC9gy4oDId/gCl2vLmtx9JzpXxRAdJUeto7LaxzMX248z1rBuAJVY34ECsG8iz8wZbxqaThr9+hfOI/hP8z3NhkandWxYJJauhKbroChTaaUC7eJkuMaIwdP73mzRC/G1Blflr1TFYcwsbY7I1Sz+jlqBiHqjzrTlPDl8H7+3KDmT4O4ukhvH1TBXKIeHwxbNVMOpxADTfdMCExnoA1rQnd5agO0WBEKG0dyyjK3ypt60rYy09d6Yp1oHp1fe1Z4zL8iLGa6mCJzfaIBS9ZZMS+GUeBV4UHQgpd7UHEI8a6e2m6sLq7W88WPgUR6tl+BDDzSV8Am7xVAPe1SgTx5BY6MaMfvYy3ibiIupt3RXOTaz5Uw48z9L2b0mdT74UgjIRvBMIuvesvJTXFeEScbLR/TdI+Ke/ojthME0Sxpl5k9HdUI1ugAEOvOOrPLBRYw0yUQM+qD/V0EdZMGtd/vgz/p2C3Ts3qQLMznuQLHLDF0S4znr8Pl7I1y4aoEwzt/sukFx6N+loN0QResg8NqxfYqVLDrtByUZr/fchN3z7t0ko5yocUG74JEmefo2QTe9SotAPy7NLT7g3FLhsabtr5mF+7WCZs3wfULixdF2OJ01Cloq2aDR5O5SJ8Ncw9Fs5Gk1lzC97RFK8LH1cKcS3s1xBFNijI/anWZiQQ5fkZt/v+LS6hriArEw3YiG
 dqkuODll
 mcSYB/3zVPOMcyapWkG4uMhX2FpKYqD80ZFYeQAYvyiBuduPte64GctI3b1bi19CLtTdfUB025xtwTvza+nR5Zh0lq0Vmi/acQesJV98HyUQwV63GdZLERrvU5E7U3130Ne7DzZPhcTc9aJ/HBwJufstzRSD3rr5gnbJC9MdEzcJaGUPI4VdWwGmpvoNNy4jd1U9cdTUSym9jZm74sU1h2tSZwQNi2/3O1fpQtpgH47Z/ijO2OcJgl4xaDXsnAY/H9lp+42N5x67Xpz0TsxciCWOk3Cliebk5z3iyjZKHfOIkk0fI9Ni+D9C0+UR3kVQtTA5+XJd0zHzEnu/Et4b0YIdiJx4asM1WDn0EYFuRq4Q+mwMGqs2Wdl7ZgtC4HDKXl+0Qgo6HkjgSZzH8rulZD5wodIaAOFmgDDoDyE1cV/sRoQQYPxh4LOSanox5TABzTkAEnJ6323FyIOQn2z0aa1zLZDWcRU2Kb1zmvH2W6BQvw8sLixTfYwj26Wg+Qa0XTeQS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Currently in zs_free(), the class->lock is held until the zspage is
completely freed and the counters are updated. However, freeing pages
back to the buddy allocator requires acquiring the zone lock.

Under heavy memory pressure, zone lock contention can be severe. When
this happens, the CPU holding the class->lock will stall waiting for
the zone lock, thereby blocking all other CPUs attempting to acquire
the same class->lock.

This patch shrinks the critical section of the class->lock to reduce
lock contention. By moving the actual page freeing process outside the
class->lock, we can improve the concurrency performance of zs_free().

Testing on the RADXA O6 platform shows that with 12 CPUs concurrently
performing zs_free() operations, the execution time is reduced by 20%.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index fe20ab297542..1602ccb6d814 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -878,13 +878,10 @@ static int trylock_zspage(struct zspage *zspage)
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
 
@@ -900,7 +897,13 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 	} while (zpdesc != NULL);
 
 	cache_free_zspage(zspage);
+}
 
+static void __free_zspage(struct zs_pool *pool, struct size_class *class,
+			  struct zspage *zspage)
+{
+	assert_spin_locked(&class->lock);
+	__free_zspage_lockless(pool, zspage);
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 }
@@ -1513,6 +1516,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
+	struct zspage *zspage_to_free = NULL;
 
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
@@ -1523,10 +1527,23 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	obj_free(class->size, obj);
 
 	fullness = fix_fullness_group(class, zspage);
-	if (fullness == ZS_INUSE_RATIO_0)
-		free_zspage(pool, class, zspage);
+	if (fullness == ZS_INUSE_RATIO_0) {
+		if (trylock_zspage(zspage)) {
+			remove_zspage(class, zspage);
+			class_stat_sub(class, ZS_OBJS_ALLOCATED,
+				       class->objs_per_zspage);
+			zspage_to_free = zspage;
+		} else {
+			kick_deferred_free(pool);
+		}
+	}
 
 	spin_unlock(&class->lock);
+
+	if (zspage_to_free) {
+		__free_zspage_lockless(pool, zspage_to_free);
+		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
+	}
 	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
-- 
2.34.1


