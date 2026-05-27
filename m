Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90BB3CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063AF6B0095; Wed, 27 May 2026 08:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B566B0098; Wed, 27 May 2026 08:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92B76B0099; Wed, 27 May 2026 08:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC0836B0095
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:01:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88D84120585
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:01:41 +0000 (UTC)
X-FDA: 84813060402.25.EF3EAEF
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6A495140013
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:01:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HDbVDKuj;
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779883299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHNxVkzgOEtrCskHNiISj95cLTtaoMXSb01E6jPrlAE=;
	b=6bZoDa6O3anMUrrX0r7nznTSc8aKQe3oHtZ1C9+/JvkNe5sksTUZZsRNRV+NFrwLfD/74U
	xeTcz0pS6ljpzu/S9Ee5ybb+RikY6k/azCN56XJiNyWCxrJ8OHgX3Bkj3iXe8BHOA6xKLN
	ULyynPcbidIZcjY/o2pMXcUv6YoOyAg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HDbVDKuj;
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779883299; a=rsa-sha256;
	cv=none;
	b=fKhvyIBSqAI7jdTlgUHAaZK2h344MWfuVtt9WkqD2hW13MBj160Fyp6qpxeB39vQgSfwyu
	pYUs81IhpprE6GOcJ91ubL+HgwXUoi+LCnMinx9JLgQhmWDCy4syQ+aCuusbdS2yk0XNdj
	KUm2S6Q3EXKthmNOOuBndF/FfjdJsKM=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ba4a1a0325so78566715ad.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 05:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779883298; x=1780488098; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHNxVkzgOEtrCskHNiISj95cLTtaoMXSb01E6jPrlAE=;
        b=HDbVDKujaN03QQfYISlTesjSKLDgQmd6nhZFKyYXtyBUwAC5DPerqazqEo7OELMtSl
         W/SoD/7/vlbAlvkjv0fR2x62tzAMJf4/UfMByIjBoYhk7yZpwpm9troYqaytU5AlhBXh
         Hsu6rz4LqvyIVYWAWK2vPzknWGpLQoLxQw6GduxriPdCTcKuRJD2LXxrKx0jlN85cOaA
         7qImlg++nq0Y1bhb5Mmgg3dx8LLufVcYj67deQo69P5i+QLrQlKaF1QOUAORnLuNvcBM
         am7c/qb1ALtxB4VUBiSli6QCCmK6hz+BsaLTOkLlqsCFB+O7GvmaM9APXiiS3835YmML
         Fl7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779883298; x=1780488098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uHNxVkzgOEtrCskHNiISj95cLTtaoMXSb01E6jPrlAE=;
        b=QwPNo7Fwi+8Rrc+uotTZaITtSfZBE7N0fuMKmWfcQzfXOPeSa/VF7skUVZ9325YkbW
         YqVoruU3pBuvd6wUsIze2AsHU7bZHtBgw1NJOdBZoHyVUldGCxdxqaDIsQJ691OtAvOV
         wy/9UIjafF8EVEEZW1BU3aGWRpPPckUcudRK+vcgEzv8gADMO6LyZaioQTxE9sn0CSdD
         yOQKFVp2aQoJ+KFVjYBwd0S8gmrZinTO+DoLI8aA7in5tFP7mCoGyX7chgylKPbQbjZu
         3y/CcK4ty4ctVMrLDEQrDwT/Oc0crO6Nj18dRw9yDdvUxZOGQv0C/HmPOkJQnBpUFtVh
         Pipw==
X-Forwarded-Encrypted: i=1; AFNElJ9rbxB1YrdCdnl7/1IqF8ML+0tUbrq5oJpmUO24oMwAUFB79iSFGYnn6hGf3SIm1lYXoE9tzkplTQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2KaFkRe9n7yeEcft3VQA1SjwMLeSm3wdYpIRm+wfnUR0AHJPw
	otJ3O66pTuukxErXcOLIvhjpbdgZHfp1HWO4pMg/U15nX2iqlSU1l8/+Y+UCXg==
X-Gm-Gg: Acq92OHmZbXYyt6l12j6nQBPFgDoq2WUKNt0yE8wVdV5DVKs8HDB//gnFSoAXlS2brP
	YMjBlS9FHh18FTfgGta6AJaMeVdHXRZn7TBx+D8Pp4pjZw4wuDFyjPzewRiKMA03yFM25SYz04C
	eeKcfXrZ3sSTnsMBNzCCDhKwkmvhya9ED/c3iJC0kSdfUWeswMT0zNl6O5JKqSlOCnbSzA9PEP/
	YwU1tMIG5LcyKszLlI1cVvWSZ+UT6U1A2qbc3Rd7U69LnM2J30iyKD0moEfj3dcZ+qzmpNj1WTz
	707M1dWcHNvq6s0m0eEYSfLazfEK1jEsymeReCym2xLT9kIMPOYNVQL1V20cd9vmlFvPT/pQMPj
	h+WJu5m2aCK4V0GUbOQsr84tyNXvKauZg+tH9RV1StgyAoPBpMmVGC+EmdgfQcG6bDKI2Pynhzy
	lE3kWuTySY01NbjWq6za6jqoiThfAWVFVydYRC6ULJeyYQlXJy
X-Received: by 2002:a17:903:4405:b0:2b9:6458:1a2c with SMTP id d9443c01a7336-2beb06733bemr252958595ad.13.1779883298133;
        Wed, 27 May 2026 05:01:38 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56b5886sm136250465ad.20.2026.05.27.05.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 05:01:37 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v2 1/3] mm/zsmalloc: encode class index in obj value for lockless class lookup
Date: Wed, 27 May 2026 19:59:28 +0800
Message-Id: <20260527115930.3138213-2-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527115930.3138213-1-haowenchao@xiaomi.com>
References: <20260527115930.3138213-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eyrgm41bqjsm6jr9s3gmhn69kzjta1kg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6A495140013
X-HE-Tag: 1779883299-902711
X-HE-Meta: U2FsdGVkX1+Hx2QMvm4RdRR6+z1tp4mwkjvKlp8BzSc1yDnutF37QNLxcukg6DTyLgYU8PZSzxmcCo+6uWLGHX5BmvkzHxylU3vbtd8Sgc2lhzHcM3PCuS1Rw3OrWU5H+csRUOoLzvydzyNHl0DNEIviV3QMNkvjqU4bVLDEz5aaPTcPvj7L04IU7VBwa4P/4CHJPRLyJtrDVTLRs5z2RaIzwTLKRW04zd+Tah5LwOiy0FMaMtsu2eqkip86S7sJAu3PKd2E9uK31dfKCkuKYz1TqPTc25XUjrNziA9fEMus5i48yfO5gWVKLqKBCiW1WDDtMJLQsBhOAdI60eSQe1gTcZ0kw2uehvplIIbExqCNbd/MAL3reqkuo/qWSPM81Aqk5oRdG+rTU93Z1hEjCJ0xs0om/4ujXkaoVH1XEY93NliAQsfsE7e3HByCVKBarcoTOVQv5BB/W7Cehy98b5Ek94s7BgmgwzzME4MFGYWWJnxQfbBxjPm6LZrZ2F+SVOxYx+Sbg7fDokdwr34kQ4+ZuFRAv0RMjL/Ea7eJaBNQhv7pR+JXtMADyuaCT+9ZpSxbsmzTiasOtobVx7syn7uqHkFGq4gPCss8NQfliKG64x7up259LkYVDhrpqYXBNaFnT/hBbh6iwn5T5gxaX8fXC52biBTEofnLOrmP9M2sWkUu31VHWnU/1tva2tPHeFU9IWBgnE+HlOvcGm5GfGm9ictJ+g1lNeHL/iqu3xYAKn+y16wA0mRvzfA4kX/5NT54LcLsrn7c4A7vNdbxk+M+xDR1hMSFn3tK+QhAsEyreja4vDesXr0PgplzwLgPSlmkRDwkHpo5sasTEvXvxEx92s72XUX7kzALXa6+CPiyidrHtRCCH0M8hMevQZKvsCtIKK7IiqnFjQBQLj8zQaQ+Q9v2M3WwqU5Fr1jBYREmf5BApCcBND1DfEscf83T3WHA8vsqVbZhZPG0tDa
 T2/Q/efK
 yMxP5tSW3q4lj8bWB/wVX9nASXzABzYWx+fvVUS9lAWuAbJQeTmdy/uD/UEe0uPBn2/fhziZ0lWICM7r5RxLMv0LVZJfQZyvhtJeZOXan0diPyZy11mc5OYESwJ/fIRTWQChwbR6lI6EvcUzEYFwbMWt7L/q78Ne6L5geILK+SOcmRqCqm1xK/CmTNs3JBcPAAgoS3ddkx7w+cjqS5yNsSL7XL4MYxO/vydMnKwIZZn60ClOXlXmJSrBln+W/VJfSAeRodA9WcPs79Uajv2LDYpt8W4MTFW9ep9XvWpjB448PirrJ0xKv+azA5n4oqPtL+h4tQ1mDKm1UO6LssunEa5y8st1Ovjta1ooRPvXBNfhZun1nxJ05sFvHD06wrZSj0GWu46nj0UBuUx+Xl7HsIZhbLjUcpAypFLYtZHq2X51Ub/OuGyIABtNfoghqKoi5VNACO/ne561KkcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Encode the size_class index (class_idx) into the obj value so that
zs_free() can determine the correct size_class without dereferencing
the handle->obj->PFN->zpdesc->zspage->class chain under pool->lock.
class_idx is invariant across page migration (only PFN is rewritten),
so a lockless read of obj always yields a valid class_idx.

The space below the PFN field in obj is over-provisioned on 64-bit
systems, with more bits than obj_idx needs. Split that space into
class_idx and obj_idx subfields:

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

On 32-bit systems there is no spare room for class_idx, so the
encoding is disabled (ZS_OBJ_CLASS_BITS = 0) and the obj layout
remains [PFN | obj_idx].

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 80 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 14 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63128ddb7959..6b0014b43408 100644
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
@@ -88,8 +88,27 @@
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
+ *
+ * On 32-bit systems there is no spare room for class_idx, so
+ * ZS_OBJ_CLASS_BITS is 0 and the layout collapses to the original
+ * [PFN | obj_idx] without any ifdef in callers.
+ */
+#define ZS_OBJ_PFN_SHIFT	(BITS_PER_LONG - _PFN_BITS)
 
 #define HUGE_BITS	1
 #define FULLNESS_BITS	4
@@ -98,9 +117,29 @@
 
 #define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, UL))
 
+/*
+ * Reuse the width that struct zspage already reserves for its
+ * class field (zspage->class:CLASS_BITS + 1) for the class_idx
+ * field encoded in obj.  On 32-bit there is no spare room, so set
+ * it to 0; the encoded class_idx then folds to a constant 0 and
+ * the layout collapses back to [PFN | obj_idx].
+ */
+#if BITS_PER_LONG >= 64
+#define ZS_OBJ_CLASS_BITS	(CLASS_BITS + 1)
+#else
+#define ZS_OBJ_CLASS_BITS	0
+#endif
+#define ZS_OBJ_CLASS_MASK	((_AC(1, UL) << ZS_OBJ_CLASS_BITS) - 1)
+
+#define ZS_OBJ_IDX_BITS		(ZS_OBJ_PFN_SHIFT - ZS_OBJ_CLASS_BITS)
+#define ZS_OBJ_IDX_MASK		((_AC(1, UL) << ZS_OBJ_IDX_BITS) - 1)
+
+static_assert(ZS_OBJ_IDX_BITS > 0,
+	      "zsmalloc: PFN + class_idx leave no room for obj_idx");
+
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> ZS_OBJ_IDX_BITS))
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
@@ -721,26 +760,38 @@ static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
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
+/*
+ * On 32-bit systems ZS_OBJ_CLASS_BITS is 0 and ZS_OBJ_CLASS_MASK is 0,
+ * so this collapses to a constant 0.  No ifdef needed at the call site.
+ */
+static unsigned int obj_to_class_idx(unsigned long obj)
+{
+	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
 }
 
 /**
- * location_to_obj - get obj value encoded from (<zpdesc>, <obj_idx>)
+ * location_to_obj - encode (<zpdesc>, <obj_idx>, <class_idx>) into obj value
  * @zpdesc: zpdesc object resides in zspage
  * @obj_idx: object index
+ * @class_idx: size class index; ignored on 32-bit (ZS_OBJ_CLASS_BITS == 0)
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
@@ -1276,7 +1327,7 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
-	obj = location_to_obj(m_zpdesc, obj);
+	obj = location_to_obj(m_zpdesc, obj, zspage->class);
 	record_obj(handle, obj);
 
 	return obj;
@@ -1762,7 +1813,8 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 
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


