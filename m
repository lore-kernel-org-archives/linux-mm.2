Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BFC7CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60C86B008A; Fri,  5 Jun 2026 04:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7CE6B008C; Fri,  5 Jun 2026 04:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED686B0092; Fri,  5 Jun 2026 04:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC286B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:43:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6194990248
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:15 +0000 (UTC)
X-FDA: 84845219550.07.28BFE00
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 58F194000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f4E8o6Py;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780648993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1nQOtmsuSqcQUPuYJZAkaLb8MkxxRia+eZsD/iG1mU=;
	b=CNClXLuV0FmqbzA950oFHHtXAFyHWVIXLnSGRpo5wkxGiRMTb3EBvTlAPHTXWYlpO7cYdJ
	ul1xXuPCCAtIkJkEKByWaNEhH1MjNIMhvvAYw6r5HjxhaYNHHq4cbtD48rgEH1MxXSwEiq
	1vyC79NZzOcXqLprBX88UTXGouvYCe4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f4E8o6Py;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780648993;
	b=rlMETGzek1RWVhv+PZp/7obe9fxXI9tl6BpnEE2ycjunDeCWFJDWVX9Xs3U/wARUox0ugz
	F62jnVD19YVvplJQTMkDVEXLQI/trUBGLB+JmboJOMRzOrF+mL/TLo7wbBcU3TNJLPNQHK
	5YmpwZYEGs2QMYMgOnSAhAQ1du8fYTI=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36bcf3d2565so1221400a91.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 01:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780648992; x=1781253792; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1nQOtmsuSqcQUPuYJZAkaLb8MkxxRia+eZsD/iG1mU=;
        b=f4E8o6PydqNTXl80o+IoynVdGo0inWa47h2XmRXyg7jMLUrcNcZxKiRcZGk+YAiiE6
         D4HURWmMNbF4knd+hBGKZ4zxBKvAUFnnc9yJngXVe8If3NQGWlfffQqPWqg8OQcCzz26
         a+67P2pG+3cVBuijSCqGLpMnqG0of7XAQEDcfZ1GhFUDmdo45xEkvKQv3N1ABEtgLDP8
         I5DOhUdLgNFN2SQPAWNaomg9Qtg+IrJJKRKf8rXFi7m6G773UmapmTIosgi2OJQmSuwD
         H2PEOHiazsePg0x2q11vtZEUQsnuNpXRg+te0i6IBIUzk27BIBRrU9G1yDWax+jYif55
         6V/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648992; x=1781253792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z1nQOtmsuSqcQUPuYJZAkaLb8MkxxRia+eZsD/iG1mU=;
        b=TkUQSVbhiFdQPZphOYGUIQaUqJDL8uDyLVdJbjTa+Q4oloqyLiHSw8NhMACxUF+Bop
         faYm4QkacerbmmyAdAmsJkdM5OCQxI7DDSYv+0Wnf7LYTuXIhCDgZ3teLBmzI8yc1u9V
         gKRiHNRlNt6dIq7gK5l5zmy/3DnX2lw0PePahXDd14FhdlOMWRyQYHGCc4FzccVaC+ki
         clAQBLPM4LFL/EUJM9xTPSuet+gCOa9qt4fXnhAm/Nita1A7uYSLyRdN5TmLGJPPDUTi
         mRyDgNjwIjroZDIRecr9dthVkYiwVGSRqmkkfeQn3iRdEAwNQHFlpazP1GcDBNjdyr+a
         D6Cw==
X-Forwarded-Encrypted: i=1; AFNElJ+UNaBFdTadluLDIfxMAjLU1n2Gw9K7Rlj45jaFyqi9NCp8gB6EG3Fa42cDHtNCwi2wFP41mHEawg==@kvack.org
X-Gm-Message-State: AOJu0Yzb8Z9vhi5qxgqtlInGUT/BYqwK621Afu1MoVTwa8yO3MqLKUIQ
	BtSd0h3sL/t14kFWfqAWHwhR5KqOVDFVVUS+ds4zGrUHQn1Xfunoe31i
X-Gm-Gg: Acq92OEoLyf3ejOEcr7jcYl5iNUvdIsV3NgiDIkyJTyfDASyAkf1HMcEg+oPFd1poti
	qchW4p6E8iUYjoI/OQS/us3PdcjQi++s4fc+5KfiwJSN7XUY1yFCUylH0opbNppjIr3SGU/eMFF
	EQSkkNFCkEoshNYu/ZoNhRRFrCWTpm2mdL3OfHmZnxzz8EauVS8E4KaUa8Fb/oC8VMRYG1x8yGw
	c9v7lFMSAhBgF+ijAnoIgK3oHWPCzj+u6dLETdAG/d2GOypBVWkwkxbEwLnAEZXbnaxsEvt/eXD
	af6mU+dpjQEG7EHeIg1h6DUibTA/sc2iMhfI5cUzxknpMB+7y6nCZBqjKUU63SzWAjq8rylbw++
	ios+/Hf0/wMiDpwcOxtKqaJ+r1oONN9KYf9pMDTWJzJF/sEl7/NgKthvwVmQB21yU0r4LuSf1u8
	h+WekRSSPDsKXFlGcUw2HZMmWpUpYLuhfHohXk+cn8DmzDX2e2561Yqp0pJof0
X-Received: by 2002:a17:90b:38cc:b0:368:f179:ba07 with SMTP id 98e67ed59e1d1-370eec125f1mr2950361a91.9.1780648992235;
        Fri, 05 Jun 2026 01:43:12 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3712fcb2607sm926632a91.0.2026.06.05.01.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:43:11 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v3 2/4] mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
Date: Fri,  5 Jun 2026 16:42:40 +0800
Message-Id: <20260605084242.1549811-3-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260605084242.1549811-1-haowenchao22@gmail.com>
References: <20260605084242.1549811-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4spg54jd8r9bp7ry7iu66qs7spjb3gkq
X-Rspamd-Queue-Id: 58F194000A
X-HE-Tag: 1780648993-953807
X-HE-Meta: U2FsdGVkX197DqH3h1I/aazzLgJ6YFvwMk9N0hNwlLl3MMuADp7/amfi0wVbSSmCF3TLmcgmq/nYebB+/zDud4JlyWlk22nAt3jMCmt4rEfr+WS7qC0IisXxax6c48EkMKnvLqiO6qt7KiGK7mKnpvcdilkm+2a0h6EZEEQf00vvqwWjD4sfqsbAOtmYt+I9ab8+uVYiNF9vE9IA3cVnoePxIa0DmG2igF/tbOniTdVmNod0uOaDUGHz9HJEPuXg3SsStbWsMPDgC7E+w9I7Wkai82qYwrIKGM+5dz16MuEZXvirTfCifMOcPpYKqTy5y5A4wKyWHaDy41OIAl1gEjtMLAOantxDnrveYpigcfRJ74wdh0T8U/LpfN3JX0vPHpIlh+xzgEEvwgNUQwpbEVxZ3FRU9ppJbvfvz+sJxAHIxZ/sFEpTs/OQMXLPn3wIxlJssVmlXKWhYmeEC/woPxrvdCJ59CKpa51B2jPtG2Kw7f6j+YPRp24FvG+gu4SeWVDf2IQk+76zFAhQ5SOhdKVDWTsyEjdOv8nbfw6hHIOIatV9LUJjwJrckCQ/Gk6FnKY93IXJH3NzwR4jhSrn+YpldY0f9G6z9vHAv7KQxDQO1p5iNFWd/1vCq6y7Hw+pKDugckgFenK/E0HrXrpqYzTYFFULUrFoj9nQUI0E4mqHQW0h3vDY9mGQisxgzAJmFgrazA2xAmkQQHzW6R8OijFjQ7D9QncQoJ3dCHhsIy3aCM/rCFG1Iv4NRReBlDUhyGVaFCSF1TxbwZyU+UMPY3QeaQxLcHdfCHCY0d26RY9S75E23dB0wERepK5JXDibvsXORKyT9NR59TSZ8KG9F/JGWKyAZ4HAeFaUtguOWfZxThvlAWuX1xmvr8GPH9M1ES70SYgpIv5dcCzKrrUQMkNq8s6+SK6McbPG0xD4ji90WPSui5mAe6NrJAcry9dc4EmVR0hOwjVi7z89r53
 XwQGajFl
 T6MjbGmAKujN4kH3kPCTc7+G9tGBd1rIf0yMzq/CARMunKdmjmh+tLrYDoois4Qjx9KFukEjVnSCK9c4Vyz9hyti48gMww7Nzz8tIFTTQHfEDsMSjBSofT/Z9bH+dEHq5s6h8UDTB9WI3tpUkWM2T8CK+ct4EZlXP76DXkqQdX6F5vQbG/sfsYxPcwpROPlg4gv728m0ZnFgiYDK71MADgYgRaXEAU/ePgHdCOHYxs5zQ21PaKxzrABGY4ua3Wsx+8zsG0hT/KWlBfx3wR/Rj3rb7g2dN4N0ACk1eQ/t2COPeeKpyeh2nPA7q3zRDiSgvejaPijfoXJj6sGv3L24em1udnKhwBJQkVniVQ3ZU/jguKm09/Za6IR9fq5Rq/+YBosyFlX3mapIY5Tljf37q/ud+gEfh2RhTvjYn0U7FC7JEJ92IZi297aq1T29ibplAn8COVfvCk2Wr8CdeYbMiIoLRkmo4BfW3a7vRWf/Pb6LQqoTx8uCzCtuaUNfFMvhDHKWHZxpWVOBa4sjs/lnR0IdSrnWK2OVuTDgTpNtL6/rMM8WML2VS8kX/3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenchao Hao <haowenchao@xiaomi.com>

With class_idx encoded in obj, zs_free() can locate the size_class
without holding pool->lock on 64-bit systems.  Page migration also
takes class->lock and only rewrites the PFN field of obj, so:

  1. read obj locklessly,
  2. lock the size_class derived from obj's class_idx,
  3. re-read obj under class->lock to get a stable PFN.

This eliminates the rwlock read-side cacheline bouncing between
zs_free() and migration/compaction on multi-core systems.

On 32-bit systems pool->lock is preserved.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 67 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 12 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 6b0014b43408..88d10f814da9 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -21,6 +21,10 @@
  *	pool->lock
  *	class->lock
  *	zspage->lock
+ *
+ * On 64-bit systems zs_free() does not take pool->lock; it locates
+ * the size_class using class_idx encoded in obj and serializes against
+ * page migration via class->lock.
  */
 
 #include <linux/module.h>
@@ -1432,10 +1436,59 @@ static void obj_free(int class_size, unsigned long obj)
 	mod_zspage_inuse(zspage, -1);
 }
 
+/*
+ * Resolve @handle to its zspage / size_class and acquire class->lock.
+ *
+ * 64-bit: class_idx is encoded in obj and is invariant under page
+ * migration, so the handle can be read locklessly to pick the
+ * size_class.  Once class->lock is held migration is blocked and the
+ * handle is re-read to obtain a stable PFN.
+ *
+ * 32-bit: the unlocked load of *(unsigned long *)handle is not
+ * single-copy atomic and class_idx is not encoded (ZS_OBJ_CLASS_BITS
+ * == 0), so fall back to pool->lock for the lookup.
+ */
+#if BITS_PER_LONG >= 64
+static inline void obj_handle_class_lock(struct zs_pool *pool, unsigned long handle,
+					 unsigned long *objp, struct zspage **zspagep,
+					 struct size_class **classp)
+	__acquires(&(*classp)->lock)
+{
+	struct zpdesc *f_zpdesc;
+	unsigned long obj;
+
+	obj = handle_to_obj(handle);
+	*classp = pool->size_class[obj_to_class_idx(obj)];
+	spin_lock(&(*classp)->lock);
+	/* Re-read under class->lock: PFN is now stable vs migration. */
+	obj = handle_to_obj(handle);
+	obj_to_zpdesc(obj, &f_zpdesc);
+	*zspagep = get_zspage(f_zpdesc);
+	*objp = obj;
+}
+#else
+static inline void obj_handle_class_lock(struct zs_pool *pool, unsigned long handle,
+					 unsigned long *objp, struct zspage **zspagep,
+					 struct size_class **classp)
+	__acquires(&(*classp)->lock)
+{
+	struct zpdesc *f_zpdesc;
+	unsigned long obj;
+
+	read_lock(&pool->lock);
+	obj = handle_to_obj(handle);
+	obj_to_zpdesc(obj, &f_zpdesc);
+	*zspagep = get_zspage(f_zpdesc);
+	*classp = zspage_class(pool, *zspagep);
+	spin_lock(&(*classp)->lock);
+	read_unlock(&pool->lock);
+	*objp = obj;
+}
+#endif
+
 void zs_free(struct zs_pool *pool, unsigned long handle)
 {
 	struct zspage *zspage;
-	struct zpdesc *f_zpdesc;
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
@@ -1443,17 +1496,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
 
-	/*
-	 * The pool->lock protects the race with zpage's migration
-	 * so it's safe to get the page from handle.
-	 */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
-	obj_to_zpdesc(obj, &f_zpdesc);
-	zspage = get_zspage(f_zpdesc);
-	class = zspage_class(pool, zspage);
-	spin_lock(&class->lock);
-	read_unlock(&pool->lock);
+	obj_handle_class_lock(pool, handle, &obj, &zspage, &class);
 
 	class_stat_sub(class, ZS_OBJS_INUSE, 1);
 	obj_free(class->size, obj);
-- 
2.34.1


