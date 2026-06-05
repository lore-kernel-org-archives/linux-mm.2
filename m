Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35246CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA136B0088; Fri,  5 Jun 2026 04:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791C76B008A; Fri,  5 Jun 2026 04:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8746B008C; Fri,  5 Jun 2026 04:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC246B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:43:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF74F1406CF
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:11 +0000 (UTC)
X-FDA: 84845219382.19.80A2A3D
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 13F1E4000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dLY58WmB;
	spf=pass (imf12.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780648990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=quOGtfpkvwp2+8B7oBqQS3hulhtIRkQ3/ceADPVIKv0=;
	b=mPBBzbEE8y1QNaAFoCEyBsh2UjQYoCg8oD0vLkOjPNpJqGdsRev1dIpXdipW58ANDe8bbf
	lLZqnapqTzCO8YZp++k/PgpWh1PpPsQTdzD1GDCDJkmS/2qvgABf8Qy4FuHkncYDCfwH/f
	tOaXJHBFs/RmTKTiCnCzgjysItiGgN4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dLY58WmB;
	spf=pass (imf12.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780648990;
	b=1Ytcv0UP+Xz8PIpZeZcXxLZkpfBrqZaEwEn9ujWygcVjDWTvvJBDVc+60JIvCiCSPp3LjR
	R4s0gA+J+45CGM3WWCEuPmzbKyKpIMb1N82uqD0BQuN4Zz1BGIbeqtLsPRkgk5vtWolJa4
	bWiGcVqfXGUWTIZbHHakGWzrC1ARi2o=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36b8e1760ccso1023463a91.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 01:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780648989; x=1781253789; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=quOGtfpkvwp2+8B7oBqQS3hulhtIRkQ3/ceADPVIKv0=;
        b=dLY58WmB98U4b0f8Fu4oCurfBGHU9FEgSl0WCOsF5EwewZhNwqlpWt9tHhiKErQ6SQ
         nE5uRgVM9ISxfympX/7z7aO5dm17k/ocBm2YL/q73PA9wEO3Gn425EKID6oRZN/jchkF
         3k8eCAbsfqPzqI4AdtFBG43yufVbd5hJmXWxV+wvCFL0dFViksFFXM6wuH+ZFVH2/cgO
         b0QsYvNnPqh+dMKul6Qv5f0EZuhy0z14QxuKwsRMhwuskMY500lNj2ze7BAexieCAS4Y
         rWGVtXtUnRDSfRNFDVfj0iAfNGORI2Dr87VgaWb0qYCVZNZRaLq3hzd/H/8OlEmBvNC1
         yPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648989; x=1781253789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=quOGtfpkvwp2+8B7oBqQS3hulhtIRkQ3/ceADPVIKv0=;
        b=VAfnpCaPL1EvFiZ3vt3dllviWuCwsOrqWONy9VaK8MWrZRyEpuVZMf3rjgqFZ0ZFCr
         AZCZ3FToRhQ5y8AbwRLsVQrIplHrbg7dunt+DKb9INWCpN0p2Mvcwm+KwBbyljjKC8wi
         17iahyLiwGsaiV4acA/9Q7mE9PRYev648H44E6jOLsy4hHTXRaNctehsIteDAv6TrOC9
         YN0loTuJq4wtOHHoBzmwD7CDaJ8AaZnNgZrdboLRhFXXJ71JHDF6e4X+MCqyufukbpyZ
         TNGsmi8RVKOwCy4gyE7J+88geBFKYXKt68u7vXEAs4BJq7oT9pfDW8lL1DtnJUTZmvb/
         yScQ==
X-Forwarded-Encrypted: i=1; AFNElJ88EZ1uR350mY7fTS6m/I7JP3mSqJ9tD7yKIkEr8s4tEtP7OY56qyRVPgiPY5Soy2uQRO2OE6Shvg==@kvack.org
X-Gm-Message-State: AOJu0YxKTUBK69kF9nu/qATUIQxy1usYTpG1I8YP52GHO8OhJuzqWv/O
	tYc0Lfcs7/OLQsz0D8XgaYjNc8PwDY+dKsXy7ll7gl5+3ARO2LMbMkDa
X-Gm-Gg: Acq92OF1BtmrJO5UwIz9uDMn5fCl7vJicgSjZb/iDo3gv4VCGBOHGgQbBM6kDuT8QHI
	vRgF/GermxMBI8EpKflRpjeAt6mytWUNbxvOA6vEqVGVboON5LIyc8Wj/XhGm1m3eHcxtesxnJJ
	M8v5NW/azja43AJ12/lBrsGz2UpZMNjJgYTQkErRnYWh0Jg4DR+d/82K2uiWNuo5lxDxuX7uEXV
	aEuGE2mOKla7QoZRcqjva60hdLIV94psR50zw0wA76p1ibz/kqPVQ+phTdelh2JULaHT32yA8I7
	HnRmirRhyhW2Kt0iwtFhJUiYJpHlonOjpWHTkjyVZKFaE1+bdb8tlGvEDnwn93z5+Bz3izROb82
	ZgcEX5OqNAQE9tVKYyqlJ4DYFtAqKkJJ6s8QCBwu1hp4052j8/Bf6J6wcv88PolA1VNn9Mogqpf
	sF4GyUufeHaZN1bGcnvzhh+tHOhB/0uV7L9TBtDAHxatWmOfqLneFgTkenpmVy
X-Received: by 2002:a17:90b:38cc:b0:36d:f28b:72e0 with SMTP id 98e67ed59e1d1-370ee92adfdmr2924474a91.12.1780648988874;
        Fri, 05 Jun 2026 01:43:08 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3712fcb2607sm926632a91.0.2026.06.05.01.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:43:08 -0700 (PDT)
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
Subject: [PATCH v3 1/4] mm/zsmalloc: encode class index in obj value for lockless class lookup
Date: Fri,  5 Jun 2026 16:42:39 +0800
Message-Id: <20260605084242.1549811-2-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260605084242.1549811-1-haowenchao22@gmail.com>
References: <20260605084242.1549811-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13F1E4000A
X-Stat-Signature: 6r7nxm7zt8gfnew8if5ex1tqq4j1bjsx
X-Rspam-User: 
X-HE-Tag: 1780648989-208632
X-HE-Meta: U2FsdGVkX1808j5Kk//8zR1W0hWJFd4K7ZjyUJGUrc3YO3iKJhVbvFbEbfjsAEEB5ND56BdoTXXmIKyU6HWAlo9t3b8SlNdD19su3/QDYPJIUj0v349Wh44fduQdCdpLpKPsL6zGVjR2vH6k6JeQmbGarRUbLTOFiitsGuEaelRZpp1pUNfyM8Qzc/CaWaRDuSsB4HhzJg70gTA6cGOs2vWMjQ+xe6f9Gk1p+fOqnJm3JPw7x/xKEyei/M0VjHFrjvUr9zLOnosDpMC1APmSADX/wLC6W0fUIYNEJ87W8TWt6U3POiTFbbmt1Fr8rglPTMpIlDzQ8YElOLXD2pRAyHHBNfy1GkHCk0tralh9mzv9B69j6ZH8/9cQ5nEXuhCEHI47BEtkXDI1Lfe5/YjxTPAX7a8kqKij2jcHlIQ+x2nlfRF1mfIB4ty8p875YKcILpFrlW6EaS4nrAsZbp5bwaTwxVRAq10Xi9R9EGuMmqmvZCxi2b85I5rFxzW2vpZK42bD1tcfWvpRGqNwMk1KD1zkOuN2cnrAajZy8ts5MIux7kzkBxP/lJOMt3WXOf+rWCbaiCI2Qdz/ecrYy+woNBjSItaQcu/o9qJl69qpZ18XuSJVF/dTtMUpZ09YS9nHUbHwMM7xH1xyV81h/Rj78ewTCROxwwfpNrrT217svnN0z5zboallp8+Y7RRVVN9DUKnBwBnj1VKbiO7lpOPGVnTqVxu7t4ffXuq7GswmlbOZUX+ldQshYa9Ad14e4Xqo/5qmLuo/Un6U0riY9pGnu81nI2okzd6cVXtlcE2TPVnYnn2VTE7fRM3nwM6982e1VGUmq3D9Xzov05OCitlX8YX2JRTGwhf+QEaBOmmS1bXM5T5+0Ik01o4p8DS4SWr9/YYSdmFmtvCEvcSw09CAxGPDuMLMzBX3bOFouV9LoW1VqUw8tqg4SzqMwLWsH0Z45DDolhcAuAPXqgRoi9R
 NB4gT7K+
 wloHPslY7I6jy7qmS87rdqUof65Z9Kvqh2ReDQVLst1sYh+qUC2zyQEwzztHFDMzvRqR2Bx7T62usXyVvUpRkPq5gGFtaVXnZ2iWYWXaFiFovU4pOohIXc1JAOBEKNmRCz+Ebp4IxxghTNdioS6yHq/IcvIMqOGDd1bpvBerv7B2NTQJRP6r5frXaBWbanpBE8MnRFq6bBby7yGZjxCYvUPIe3WvviwmyXedmsqDPX62qRWa5Wlj0F8t5+9RxyXd0VMEv0DVc93Ijd9Dr787DSxiYl28FJMNCZEjLhUJJEXOd6FFCQZ6FmiXaJBmVykWlWXX0tGfWScqUn4s21iKy7vkV7B0NMr08yiUQVPM8RfGfe24x3lJlI/mSY5WtniATxYXgh6PXewr4WaxKcb18IAGwaK3Fewm+Ibf6kwRla4qR0PZenNEgzF86hvgp787g7NRCsa+gG7lqezCpXbURsebeNkXwTnEy1efx76KjMyRUjfwJFF0kZ7g8L2cgVmXoYpJz
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

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
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


