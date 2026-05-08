Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE50FCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A056B0106; Fri,  8 May 2026 02:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E20B6B0108; Fri,  8 May 2026 02:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0CB6B0109; Fri,  8 May 2026 02:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD816B0106
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:19:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91A9E1C1014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:19:33 +0000 (UTC)
X-FDA: 84743251026.20.91A8CB5
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7BF2040003
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:19:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G0mcXGM6;
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778221171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yd60DVAg2KX/emKeF35pZxyEzN8nWOKFEbn6cCyQzU=;
	b=NzX+ZHpyhVMktPcKoWI5TxZTgc7T0jwNGJHHFi/fEnN5woBgQ5hEbPxY2mQX8DFhfQrTwT
	iJR7hSPyj+OE6WN3DMCRNqYquL6mNi1PDiGfTKAyYvkmHXo4vesikzhzFy1SNvXoP7cUE/
	fYMrj6m+eA9fUN+tYrRCGh7dVIhMe70=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G0mcXGM6;
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778221171; a=rsa-sha256;
	cv=none;
	b=JcB2MVDOGiBNN/bi2AjHXMHVlinrI5OowaSxzswu3/1QoreVlTvcVOdSKQ6j2q+HhHmEVF
	zOTewBmIAFvNBp8ge67uP0zS5W8blADUSZwHPQCfGF6rKzt2D96OsbmQ3m2WOp0MqH6St3
	HcsoA7WnKjILEZXC8MBayiha3b1afo4=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-836ed29d1e5so693010b3a.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778221170; x=1778825970; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6yd60DVAg2KX/emKeF35pZxyEzN8nWOKFEbn6cCyQzU=;
        b=G0mcXGM6ggRP1fmRIsxlfmWAVSjJ2zUaIe0m1FC588C+ucwSyQ50iXmSIMcPw0bGeL
         DPz9CR5RJGTZ+ibZ41/Vfv9h4qsy5JMWVFFbU60rQ47OZSBl+vMb0GISNC205ic3qM/R
         OJ6xdaQW595GKxzQeWRH1eRENMdNjS//BtVOJ+wq2FlvmVqHomwksIlanxqpHPfTEXPf
         tydaedh+D2ldGL3WBlpoP/jz3IGOZvOhuEZQ2w0ybSOAhzje/2eZwkyAcru+9BwV3LRC
         M+AGD9rhTq2+TMdtmp3jbVoK++vdZbr6kIVUTG4XirEJNlCSxsSbSg05wciqpkQeko/V
         NOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778221170; x=1778825970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6yd60DVAg2KX/emKeF35pZxyEzN8nWOKFEbn6cCyQzU=;
        b=e2UzVhYXfxgngF8fQJMKBFrOCe6yohpMyYuSSSWNPc1pwezS3tmNNwkd5r0x0P7xDo
         pqoJoMnBxIxJWlR2jkGaGrPStmcZ5RqoUAwyKT5IgGnf6z0H8ddlro61vJ961VyGKFfQ
         OLzidZjdBHznkpb5hx228pQNXqO6Cvd3A2FqEWhggwg574PVql9uYa5gIGCqtAtsiEnK
         IUy+M7XdMEqhUdh06kYLH1ByN7kZ7TaXty0gbXWp4rW2NslmHDwRgXktJ399Jcz5J1Sd
         0VOEckd+VcY0X0Uh20Cv7G9AQrxRhmTW4YuRcNGOPwCOa0QsnXWXLkA+SydULOMwE+mQ
         vEQg==
X-Forwarded-Encrypted: i=1; AFNElJ9uwFxeYZ/9KbO9GV2iGIzU0mVha3exq/3AzeWOywQT96umsKu77GIeJyo1oiif15lulHpV4qYV6g==@kvack.org
X-Gm-Message-State: AOJu0YxfToIYQD88m3uI0kb93aPaurCN/kRDZoSlFMi1iyWWkSQKLGU8
	6hdbwqpZ8IybOWmaAVJ8eyEtIdoYCY5d2N8qhsnrY81Ol+kvPcq7lKv1
X-Gm-Gg: AeBDiev794WGGFCWF8lK6tYPrqiaCbX2D6ljIO/kVm87OMJ9BL/I1wLvPNhazX2Zb/I
	+aLUMR7gcLkh/+6P+eSBCmu/Mvm6UEIOij3UAtUyQQxsf9qSY3FOPLDPEcUD7kIA82g8565h5S8
	bqx0/ZSVVbP0WhYOtO0itAq7KZh+IoAHhZpUiyodM/VMmkDaHxZfB+c29byYFCHDhTqHXB1dEBg
	jCsMxINzCiA0cRNQ3ISyjeaA9TGG/0lauWBq/fD3Mfbjcuj3pjVU6LHi+NEJvVei4CRhzJSG8cn
	IT2aTXrMG2UKB+cResrsVdqizWsuIEfCU9vf1m85V3zUNKGwrtGy3pPPGphYREIHhpJ34IiXAPr
	akCvjHUi4t49HjK6GLdafdJe+XuvDgcaHTTtK0rsHtRD2HTR2srE+h6Y5P5gjgl5FnhBlpO1lSW
	ydw1FK/DcjU/+9ELxjv9c8mEWXT/5HPF3eEBHCqjZmPtUSx6iF
X-Received: by 2002:a05:6300:8b0f:b0:3a2:f14a:4287 with SMTP id adf61e73a8af0-3aa5a735addmr12419479637.6.1778221170292;
        Thu, 07 May 2026 23:19:30 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965a3e3ecsm11308452b3a.19.2026.05.07.23.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:19:29 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <21cnbao@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	Minchan Kim <minchan@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH 2/3] mm/zsmalloc: remove pool->lock from zs_free on 64-bit systems
Date: Fri,  8 May 2026 14:19:09 +0800
Message-Id: <20260508061910.3882831-3-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260508061910.3882831-1-haowenchao@xiaomi.com>
References: <20260508061910.3882831-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9tx34k51opmn14o9g3dn3hfcctett7di
X-Rspamd-Queue-Id: 7BF2040003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778221171-234700
X-HE-Meta: U2FsdGVkX1/QknGc1XRtj7rf9d0LP6Gig8als6B5oeOQ1Pc2qMaZKW/YCw/D0b307DV9ggCNPYAg60qK8LVw74UK57djzz7C6/7Lq7Cv3b2cZARpmoYa7yZLzJGDq/jzGVTNgJzVhYC0AtQjmtZ0nTpz6YrSNK7847zoEb2lXzuwDzCOWr14cF72gkXk0qhzpUYL9Utm3k6o2xbyrpPm/ufSZopnA2FV4YSHzlL3+pP/6E4yE5swrfb6/DPOBhp0jABIif8QB4wv3IReQjzZGoaANqPaGMjc8tgXvZ37GtLdsOHCyKAMR3XZA1MUmrvz2vkQGx9JAe6sgqhmBNx8uK2F5MnAR/v9W4k4L2llDylPtQQOa8y3MIeSTWdW247soF+PtUsLUD8iIbJQTIRBMcMRbImHa5yO/gTLBtaz8xy3KKFGZ9qLaehifNHLy4k6OXtbNI/a1qLe896NLjv7Mptge44AMaXEZvaPr75xxZHBGtCrP7cEyKPgWBvfNwoHGenl81dw87YlXL34rOp/VGj/nge2qQ5sVpTYLfctMDgdxNwR4A6FexwAMxg5r3LLqVhXd7ROgxgpoYgQvVptb34YTX27nFp0Bx1zNEU4FD+khj2YpUKT9Wkm7DyyF8sTHPCNa6OUdT5zETXTNb1XXtFHFeooVq+o7HDiKLYvL5b4of3e69boUEA9AJoj8J2mojizpBlxnIcaHDhJgTv51S7IIWOTJnrfpBM7Bzzzi0fQ3DAAKZqaZjAIptz5Y5E7F8FATB099o+KvTRhHEwrz+GHt1Nkcd9pJfCvkA3Lul3zPClsrbivT3wQ05KXjUJL4jf6nr77v8OASwMmoeDqx4iPCTuZiajZlxvQqMotjId5Y7oYBeCJyxoQcs6fUwpTHzld296EwXdTImP1jSMPvSV7CBVj1rxseF8MwPXUQi4A5ey34/nvpRT4BjV0OMjoIU7LSZyxcrqcKE6lu+x
 MGz6Or+4
 1GaD3upTBQGXM1kjMaEBv/c1ffHMIADU3r2QYDR3/smEAqRRur/+IdYivBw8kSLEKe7DPz3+PhAf8lfeytV41SD85O9Q3UnV4NJKyeAlvRD7QLQJOEbhPVA/Kdl1BX5cqX6fJK1CCMNawtV/0P4uySswXliaHXfyI9ow9D10i1LI8GXjVEeppdwp8fzdQHbjbwzl9S1vwo15QYSFhTytmk6HoWXBtZswA43ANJMw1WYxjTVOC0pa+AfISAro+s8Fq0AhVqeV542tEBOCbj5ySzT0+vMs8xc8dUU11b1sU3ZCj3JoN3rMsg0tf96XqAh8wUi/+LbPbs/mIJfhMy5az1YLJgEyCiClo3qtnEeB6+KS/MbKwG2Px0NU18rgyzD5Ss+hQXiq7c0ZKDVg5GIXHjSmGGadU+NYHDfabQ5cvhdgFH7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With class_idx now encoded in the obj value (ZS_OBJ_CLASS_IDX),
zs_free() no longer needs pool->lock to locate the size class on
64-bit systems.

The class_idx is invariant across page migration (only PFN changes),
and 64-bit aligned reads are atomic, so a lockless read of the handle
always yields a valid class_idx.  After acquiring class->lock (which
blocks concurrent migration), the handle is re-read to obtain a stable
PFN for the actual free operation.

This eliminates rwlock read-side contention between zs_free() and page
migration/compaction, improving zs_free() scalability on multi-core
systems.

On 32-bit systems (ZS_OBJ_CLASS_IDX not defined), the original
pool->lock path is preserved.

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index bccadf0a27f2..47ec0414ce9e 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -21,6 +21,10 @@
  *	pool->lock
  *	class->lock
  *	zspage->lock
+ *
+ * On 64-bit systems with ZS_OBJ_CLASS_IDX enabled, zs_free() does not
+ * take pool->lock; it extracts class_idx from the obj encoding with a
+ * lockless read, then re-reads obj under class->lock.
  */
 
 #include <linux/module.h>
@@ -1467,10 +1471,24 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
 
+#ifdef ZS_OBJ_CLASS_IDX
+	/*
+	 * The class_idx encoded in obj is invariant across migration
+	 * (only PFN changes), and the read of *(unsigned long *)handle
+	 * is atomic on 64-bit, so we can determine the correct class
+	 * without holding pool->lock.
+	 */
+	obj = handle_to_obj(handle);
+	class = pool->size_class[obj_to_class_idx(obj)];
+	spin_lock(&class->lock);
 	/*
-	 * The pool->lock protects the race with zpage's migration
-	 * so it's safe to get the page from handle.
+	 * Re-read under class->lock: migration also acquires class->lock,
+	 * so the obj value is now stable and the PFN is valid.
 	 */
+	obj = handle_to_obj(handle);
+	obj_to_zpdesc(obj, &f_zpdesc);
+	zspage = get_zspage(f_zpdesc);
+#else
 	read_lock(&pool->lock);
 	obj = handle_to_obj(handle);
 	obj_to_zpdesc(obj, &f_zpdesc);
@@ -1478,6 +1496,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	class = zspage_class(pool, zspage);
 	spin_lock(&class->lock);
 	read_unlock(&pool->lock);
+#endif
 
 	class_stat_sub(class, ZS_OBJS_INUSE, 1);
 	obj_free(class->size, obj);
-- 
2.34.1


