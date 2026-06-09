Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9EC0CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E81F6B008C; Tue,  9 Jun 2026 07:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391EB6B0092; Tue,  9 Jun 2026 07:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280966B0093; Tue,  9 Jun 2026 07:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 141796B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:36:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E9478F0E4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:36:00 +0000 (UTC)
X-FDA: 84860170080.15.9D9524E
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id B88881A0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:35:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H7MaUXCt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781004958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2a1iC93mF2361F98xckcBOo8JlNpMzrV7XxWUy9iDrk=;
	b=fuZsp5Ocmh4Eef1QdzFMuieV4H/qKgRohQsQwq6UJoSffk0ZtBDZvpDQwPcZRadm+E7+yE
	0dg/O31agHSAeapUHz+/ZAqXiYjAYj1W4pGnvKUZiZd3Z8VcC/c5gXTdvn6uP58qrOWBuN
	swAUb9ZKwUVDYp/MJaKIRonS+OyaO9o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H7MaUXCt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781004958;
	b=HsXnQHB6OQaNUbpS/VU73UnOSeoGfzJP7/r4eODgb+Fo13XlWUMqirkqQcwt0d/bKLzpqs
	MxPZTETxBkajSLYVj94u9MJrmIj5SPE+g7/iKgUkrhodvNh8iUDEKILSkymA3IsfcFWaBl
	nDrxudYRBh6Ob99kT8aTfW+qryLP0Xs=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36baec934b6so3554332a91.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781004957; x=1781609757; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2a1iC93mF2361F98xckcBOo8JlNpMzrV7XxWUy9iDrk=;
        b=H7MaUXCtWS5cLsJ8+hfBQ+qGcARmApd/J4iZX5BDLBBCISeV947IGgWH8PE9S/hCLQ
         z6OY2BC4jMcyJlUadNZG1iEaq9trUHlLEyfvNTcwGma3E3w+TfJAvQ/swP0+EMYRZoP6
         e90ahZfY0Cq4NLPbbrbfquClCWLwwK9djPYHW7ZYrMmTX3Ev6Xwf5bnv86nAUgB5UiEO
         UGWD/tvpr2ckKL27XPGIjTRwmBvAC7DsPd+7W7WOEZaKRhBEnRel4A0I4lGDbX6i4AqB
         skcq2h+23IG4AXPpJ+uWEra6LCUsFxbQduAPOmQxkubXMuAAXOV2b2dukobMn26S72tV
         G6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781004958; x=1781609758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2a1iC93mF2361F98xckcBOo8JlNpMzrV7XxWUy9iDrk=;
        b=Lo8EU0JfQGpPZmfvTs1SlABUF7sJ/u6Arsg7KsDRVL4AKrC8PJ4uvcDuptYJsPdaGX
         Lg8PjPp9CfGVGr6kpMa572sPoL9BFFtVe9isZczfYyildqeKfcLVhFHyzS4ti7T7OayE
         D4I26eCzc2c9dguFpmbtQrbQIL4GG1XEdJvzcjeIovGwCdH4BcwYWnPk63B6bNwdFyNF
         kgV/Gdj3yzE3Okcm+1RNKR6k7ZeT12s/UKPtJXsuZeZez0r5Gs8RdBTpRp3NllSO2nua
         8zKGda3eOFC+X2Ar1tAVu2koraD5FSN1oSqYI5mk7fP54r1JrBt4zi6d8HpEiUND9Mif
         LM9A==
X-Forwarded-Encrypted: i=1; AFNElJ97QgMIsbwVZJNF+6spVLN98tnZeI9GJj2NY3tYRAyEE9nAMnV4jOGk/R8e0gDNermJCCalxv3sMA==@kvack.org
X-Gm-Message-State: AOJu0YyLUgH1Uhug7N59+b7Og3TQdRx/coYkECmW5RPf9dCk1xGGjABd
	os16pXc75kvJ4zJh5wt5acgQAcktSuxLvyowskyU3ZSbYLzJZb2Jdj5X
X-Gm-Gg: Acq92OH/uWCZvVjwB+iEy/2/sn3bQH4aOOAr8KJATJiO/eOgxSuPgToh0u6tTM2Sgxg
	XrRxs98oTMn/9UAUVJYcYlR2Pv3A0MuzyS8mwRRHyy3GzJG5cPZbm2E1E9UGF4yyQo8nGyuK68F
	ABM4BTaYYZI0nU/0xa3Y6gtDmIjlk4p5G9/mni6Ln5b0ixaPgpBaKQ02KsNZgqpDu2rvbgjMBST
	0ZSRr3ol2EtmTPtuuXsLtAfUZEApd2d8jcOlXYHXhOXt0iNMWsdrsDCCaukaHEy8UIXWTvnrkKp
	UWJ/khNENN8oCXNe5iHsDUg9pqUQQX25qN/QZDMaPa57kuKsLk1ASyd/bOvGN51hKRlOdbEbwxo
	ShrrfGRbzKVgopUq9yeVwEezfelB8PyEQvNAhbs7izYzcXEtBYTPo/AvNNeI/5GSYdY2IBRFxXO
	qaW3z+wowgcK+sHMS13JXLZBgpoNNYzWavWCc1TkVyWmT3sQGnow==
X-Received: by 2002:a17:90b:3f46:b0:35f:b9f1:fded with SMTP id 98e67ed59e1d1-3713336f91fmr14812189a91.12.1781004957417;
        Tue, 09 Jun 2026 04:35:57 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6c668e98sm19655292a91.5.2026.06.09.04.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:35:56 -0700 (PDT)
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
Subject: [PATCH v4 1/4] mm/zsmalloc: encode class index in obj value for lockless class lookup
Date: Tue,  9 Jun 2026 19:35:17 +0800
Message-Id: <20260609113520.3507783-2-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260609113520.3507783-1-haowenchao22@gmail.com>
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: k19n898uutw1c7aqdf776obd7wg8uyj5
X-Rspamd-Queue-Id: B88881A0005
X-HE-Tag: 1781004958-534787
X-HE-Meta: U2FsdGVkX19dwXAgL6Yu1mZPbV+x/7vukBCGnQl21EZUt9Qw/bN12PHGpjZd0XL26Cbs6K2W2k/4SEzWUL9lUISWzqoD7FzCxoy6e4SpmZT+m9UuALRYgmZA4PPW4Sr0rlj0TOV23FeDlzM/tU2p6FPDR78PDuLF82uf0tyP5eNdp7NGL4OypaErTP0DDxBScWiUaOQI7bq2OYSUESZejORsqG1JSyzySzR7JozfI9x/qOBx2bIDPYHp8IJMaEbCdyvAZ9sAUQ5qJYLSdXldIj9IiYsM0Nl59uLqbh7keZSFuEnr5VSuZaMoq93s+UdWYNWgtNQI7LcmzTfswnUTxVJr8TUNc0UCtlJK9Dh2uuOxpzrs3cRPeVWb3O/WgbAfufld9nQlSkquqrw7zyNRQvNGd8TwDsdxy2howazwKX9GiCwur+Tt+YQnNxJPtI1iEvsNtNexgz0Pj1D6wRontAY6xw3AYVHWYQ/D2p4frE1APfZMuZNNwee7+Ijmvs1tn6DM+1ZyjQQpyJQABWyPUc72nng1e4QaDki+8RQK/UNS0ACPXYTenxkjmsleiUD0Aupv4mP1MAI0kj9mW5YaDi/o9bpIsN6Ex2E0R6GA9TJzO0z7mJgJLMS+vcV7I5RXU6j+hUjE6fhsIlhb3h9kx36I0PzeiKZ2lPP1Pyu2BTNHzekED+EF2WHdrkbCxObVubEr7TWOyZTBh8uAj37DAPgS3Q7ljvHdDrDsot9ZYt7g83PASmBkA5qrLS4L0YqdBZNtn9894dh2BRKix8hCJREVr0Va1S948xPe9nMqMBV6YCYYYA0W2S1q9xsaIiLNxWd/ap7uLxLg5OFa+/qsnjRarGkJNmQWVNCq4aAclbJUQwWzM+jPlGuIPCj2KdCf/NYhAREA1mjge6mEj90eJZyjMOdsYs5g8AapJ7TOG72ryIMCCijwOYipGriRXZi2NNgUmZMrI6ZG/JH6bTB
 uEI0U4TF
 HFPEsh4yMi1D4+rg+GkbkYOE02/PubAWY7DtQKDGu8EI8gTcMphhAtA22r43kO0+BU+fDj08ow/ErWCvA6iHurSwh927gef+sNfqnj1JN1ngUh/DoGNh2HN4JlMInPY6wUglMxySawI2nDDGj58wWJjxICk5Li7/SEdcYL276WoW94GEbie9pKT8KE/InSmdYkybCeeADE1pYGS186nfx3CrYOCoYd28oAgc1qMXJPCr8fx0kBULanYICAWVDgKkn50tHxM90rDw6E3KiGq61kvHtAZ6E/BLNyM/xzq094jjTG7ruGvh2FWUj4415RKw8QamprzWltc8tGH4BCyCa8MstXJE5eb41h3Ktc6m36zBxPSrMuOKrHOrfvJioBdTipd1SCL4qQkWq07LmgiWP55XnGm8yjvAixFuOPTsvdIVza0i77WnsuZPMLogjHhIkPkC6ib1I8mOEUXzH76plAPvZwuyCgS+SK91jjLXYiLCUqEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenchao Hao <haowenchao@xiaomi.com>

Encode the size_class index (class_idx) into the obj value so that
zs_free() can determine the correct size_class without dereferencing
the handle->obj->PFN->zpdesc->zspage->class chain under pool->lock.
class_idx is invariant across page migration (only PFN is rewritten),
so a lockless read of obj always yields a valid class_idx.

Where obj has more bits below the PFN field than obj_idx alone
needs, split that space into class_idx and obj_idx subfields:

 |<-- _PFN_BITS -->|<-- ZS_OBJ_CLASS_BITS -->|<-- ZS_OBJ_IDX_BITS -->|
 +-----------------+-------------------------+-----------------------+
 |       PFN       |        class_idx        |        obj_idx        |
 +-----------------+-------------------------+-----------------------+
MSB                ^                                                LSB
                   |
                   +-- ZS_OBJ_PFN_SHIFT

The macro layout changes as follows:

    Before            After               Meaning
    ----------------  ------------------  ----------------------------
    OBJ_INDEX_BITS    ZS_OBJ_IDX_BITS     width of obj_idx subfield
    OBJ_INDEX_MASK    ZS_OBJ_IDX_MASK     mask  of obj_idx subfield
    (n/a)             ZS_OBJ_CLASS_BITS   width of class_idx subfield
    (n/a)             ZS_OBJ_CLASS_MASK   mask  of class_idx subfield
    (n/a)             ZS_OBJ_PFN_SHIFT    bit offset of PFN in obj

ZS_OBJ_CLASS_BITS folds to 0 (and the layout collapses to
[PFN | obj_idx]) when obj has no spare bits, i.e. on 32-bit
or on 64-bit fallback paths where MAX_POSSIBLE_PHYSMEM_BITS ==
BITS_PER_LONG (e.g. UML); zs_free() then falls back to
pool->lock.

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 99 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 85 insertions(+), 14 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63128ddb7959..f84258d63917 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -67,8 +67,8 @@
 #define MAX_POSSIBLE_PHYSMEM_BITS MAX_PHYSMEM_BITS
 #else
 /*
- * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
- * be PAGE_SHIFT
+ * If this definition of MAX_PHYSMEM_BITS is used, ZS_OBJ_PFN_SHIFT will
+ * just be PAGE_SHIFT
  */
 #define MAX_POSSIBLE_PHYSMEM_BITS BITS_PER_LONG
 #endif
@@ -88,8 +88,23 @@
 #define OBJ_TAG_BITS	1
 #define OBJ_TAG_MASK	OBJ_ALLOCATED_TAG
 
-#define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS)
-#define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
+/*
+ * obj is encoded as [PFN | class_idx | obj_idx] within an unsigned long:
+ *
+ *   |<-- _PFN_BITS -->|<-- ZS_OBJ_CLASS_BITS -->|<-- ZS_OBJ_IDX_BITS -->|
+ *   +-----------------+-------------------------+-----------------------+
+ *   |       PFN       |        class_idx        |        obj_idx        |
+ *   +-----------------+-------------------------+-----------------------+
+ *  MSB                ^                                                LSB
+ *                     |
+ *                     +-- ZS_OBJ_PFN_SHIFT
+ *
+ * Encoding class_idx into obj lets zs_free() locate the size_class
+ * without holding pool->lock; class_idx is invariant across page
+ * migration (only PFN changes), so a lockless read of the obj value
+ * always yields a valid class_idx.
+ */
+#define ZS_OBJ_PFN_SHIFT	(BITS_PER_LONG - _PFN_BITS)
 
 #define HUGE_BITS	1
 #define FULLNESS_BITS	4
@@ -98,9 +113,55 @@
 
 #define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, UL))
 
+/*
+ * ceil(log2(ZS_MAX_PAGES_PER_ZSPAGE)) at preprocessor time, for use
+ * in #if below.  Kconfig restricts ZSMALLOC_CHAIN_SIZE to [4, 16].
+ */
+#if ZS_MAX_PAGES_PER_ZSPAGE <= 4
+#define ZS_CHAIN_LOG2		2
+#elif ZS_MAX_PAGES_PER_ZSPAGE <= 8
+#define ZS_CHAIN_LOG2		3
+#elif ZS_MAX_PAGES_PER_ZSPAGE <= 16
+#define ZS_CHAIN_LOG2		4
+#else
+#error "ZSMALLOC_CHAIN_SIZE out of expected range [4,16]"
+#endif
+
+/* PAGE_SHIFT - 5 = log2(PAGE_SIZE / 32); 32 = ZS_MIN_ALLOC_SIZE floor. */
+#define ZS_MAX_OBJ_PER_PAGE_LOG2	(PAGE_SHIFT - 5)
+
+/*
+ * obj_idx width that keeps ZS_MIN_ALLOC_SIZE at its 32-byte floor.
+ * Below this, ZS_MIN_ALLOC_SIZE is auto-raised by the MAX(32, ...)
+ * formula -- still correct, but objects are coarser.
+ */
+#define ZS_OBJ_IDX_DENSE_BITS	(ZS_CHAIN_LOG2 + ZS_MAX_OBJ_PER_PAGE_LOG2)
+
+/*
+ * Encode class_idx only when obj has spare bits; otherwise
+ * ZS_OBJ_CLASS_BITS folds to 0 (32-bit, or 64-bit UML/fallback).
+ */
+#if BITS_PER_LONG >= 64 && \
+	ZS_OBJ_PFN_SHIFT >= (CLASS_BITS + 1) + ZS_OBJ_IDX_DENSE_BITS
+#define ZS_OBJ_CLASS_BITS	(CLASS_BITS + 1)
+#else
+#define ZS_OBJ_CLASS_BITS	0
+#endif
+#define ZS_OBJ_CLASS_MASK	((_AC(1, UL) << ZS_OBJ_CLASS_BITS) - 1)
+
+#define ZS_OBJ_IDX_BITS		(ZS_OBJ_PFN_SHIFT - ZS_OBJ_CLASS_BITS)
+#define ZS_OBJ_IDX_MASK		((_AC(1, UL) << ZS_OBJ_IDX_BITS) - 1)
+
+/*
+ * Belt-and-suspenders: the #if above already guarantees this when
+ * class_idx is enabled.  Catches future tweaks that bypass it.
+ */
+static_assert(ZS_OBJ_IDX_BITS >= ZS_CHAIN_LOG2,
+	      "zsmalloc: ZS_MIN_ALLOC_SIZE would exceed ZS_MAX_ALLOC_SIZE");
+
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> ZS_OBJ_IDX_BITS))
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
@@ -721,26 +782,35 @@ static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
 static void obj_to_location(unsigned long obj, struct zpdesc **zpdesc,
 				unsigned int *obj_idx)
 {
-	*zpdesc = pfn_zpdesc(obj >> OBJ_INDEX_BITS);
-	*obj_idx = (obj & OBJ_INDEX_MASK);
+	*zpdesc = pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
+	*obj_idx = (obj & ZS_OBJ_IDX_MASK);
 }
 
 static void obj_to_zpdesc(unsigned long obj, struct zpdesc **zpdesc)
 {
-	*zpdesc = pfn_zpdesc(obj >> OBJ_INDEX_BITS);
+	*zpdesc = pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
+}
+
+/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
+static unsigned int obj_to_class_idx(unsigned long obj)
+{
+	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
 }
 
 /**
- * location_to_obj - get obj value encoded from (<zpdesc>, <obj_idx>)
+ * location_to_obj - encode (<zpdesc>, <obj_idx>, <class_idx>) into obj value
  * @zpdesc: zpdesc object resides in zspage
  * @obj_idx: object index
+ * @class_idx: size class index; ignored when ZS_OBJ_CLASS_BITS == 0
  */
-static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx)
+static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx,
+				     unsigned int class_idx)
 {
 	unsigned long obj;
 
-	obj = zpdesc_pfn(zpdesc) << OBJ_INDEX_BITS;
-	obj |= obj_idx & OBJ_INDEX_MASK;
+	obj  = zpdesc_pfn(zpdesc) << ZS_OBJ_PFN_SHIFT;
+	obj |= (unsigned long)(class_idx & ZS_OBJ_CLASS_MASK) << ZS_OBJ_IDX_BITS;
+	obj |= obj_idx & ZS_OBJ_IDX_MASK;
 
 	return obj;
 }
@@ -1276,7 +1346,7 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
-	obj = location_to_obj(m_zpdesc, obj);
+	obj = location_to_obj(m_zpdesc, obj, zspage->class);
 	record_obj(handle, obj);
 
 	return obj;
@@ -1762,7 +1832,8 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
-			new_obj = (unsigned long)location_to_obj(newzpdesc, obj_idx);
+			new_obj = location_to_obj(newzpdesc, obj_idx,
+						  obj_to_class_idx(old_obj));
 			record_obj(handle, new_obj);
 		}
 	}
-- 
2.34.1


