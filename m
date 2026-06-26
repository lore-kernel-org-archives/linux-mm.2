Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0398CCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1046B0092; Thu, 25 Jun 2026 21:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8515A6B0093; Thu, 25 Jun 2026 21:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768626B0095; Thu, 25 Jun 2026 21:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3ACE96B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:54:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF3DC1A0317
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:54:53 +0000 (UTC)
X-FDA: 84920395266.30.BFF3CBE
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id D31FD1A000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:54:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KeGdiZMD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782438891;
	b=qooQIyWDP1QtPFxHy3F8+SS8e7muJLsqyAus3Py/ZdGS5Pn5H1dvHFXtIJ9b8SmPWFqI16
	dJDc2RKv4+bah9nPPcdAWo5g4CQxKioRuctC5F9HudMQpIvcrtIETlnDaXdWln051DXw4e
	5UDkrEvR38AHt7ht5XWWRjttIiJlApE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782438891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7CMxZGmSd9rDJg1W64dvSL1ed3tT8uDPMgraGKCi12o=;
	b=3jSyNu0f/VAXyUPvGzvKmoX9/AUstYoTAklMwLpnHqlF9BzAC/mf1RVchR10k0ybFl8RtO
	yS3BkLzrmvmGPQcJpbaW552hyCqQfgLk91M61GaG6jAwWZ8aFnVkRkj8EL+AS+PEHi4qkd
	/PMd4nqEIv4uGglVdg0QzpTF0khJAIM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KeGdiZMD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c7f5869cddso3168845ad.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782438891; x=1783043691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7CMxZGmSd9rDJg1W64dvSL1ed3tT8uDPMgraGKCi12o=;
        b=KeGdiZMDC/SCb7rnpKUNOqzKPK4/YmgetKQ4qSWaEmxIKMP4g7qTbVurxqGPCdRkdv
         Q4kwXHteBAeqjx5u/JdeonXoX7wD/lBSRJmyd3BiTPVgf0vHyr50E+Vof7ayhoPNVYbv
         JvDiw3p/OPUUaUDk9EdLTG0l8IGxkCAarEALoqlKC+NhrjryVC3HSSp29l0xcmNxeDGL
         65ix1mh1IFNihxuiR1S6pCWKatNCta3R85O6DcWt/hKQgSi638o2MNScmACFjC7quRYA
         V2tRI+UPVVxeWGTlI+AUBhHuoogYwkHGNDYZuK4dZhFMUji42ckcZvG7PpLIZrt7jXmx
         IEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782438891; x=1783043691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7CMxZGmSd9rDJg1W64dvSL1ed3tT8uDPMgraGKCi12o=;
        b=UnlvsAiJ/LQKVez7S2PiUlHsPeQ2QNvziSdTzIdxEI2fNq6FGTIUWlUM65l47RkL0E
         thEIhc0l5TxVrRt4vs9MD/KpZ7NU860UbQp6Mb5oBSWQgo9iz27Z1n8KnSe/ayc7vr+Z
         r2HGneVCJZz9qZE4rzGdrDpMyImGpOwz1pvjYf6FCRABgqHqwCXFDsMAzIKtttTHgJE4
         xxdJRlH/KThJda8l2yBHFjP6ojC7OYAP8ucsNIDNu3XkJdCDTYsPbOoW39UWBiFP9q/9
         2viBtm+idhsHkkmlAHJjc3kLkCYzfxvGTkYwEIbC16mR3J2qe8P64iQS6FziWbHhosxt
         aR1w==
X-Forwarded-Encrypted: i=1; AHgh+RrB8OZ7avc1xnz4+TyJa0g2ar5NdUevYXVl2TZV81l7htcnLdBhOBCuJ5CFY0txF1ncGXm3NoEGCg==@kvack.org
X-Gm-Message-State: AOJu0Yz9Oj468fyCc4bM2koVjr7aoB1NYjIVgvdjWjCjmmU1pElF1no5
	+h9SzpjzoqKzzyoqmKZaFLuNSteZzDeTCI5iRGxeZt4EqTopixQViVBN
X-Gm-Gg: AfdE7cl8zOkuw6RsSNEnSgwIP5XtBrBOkshRpsXRWlRPpNhZ5xHq4i6U0VN3N7UEAMc
	I6zS4WUrtmQfb5g7tiNYuEcRZGyEez+sp3pnYf5d+b8TQJUPVCb9z1Z1Zpw14XBgO4D03TZm+jV
	n+rLLqY8oOXUz1YsQ7LQ8HGQgszIoAqzS0Xs2GTANq9snrGLhFDEc8wEP2eq/wKDe+eyQrJbn1s
	cv1dYfJeDJE0Y6QpADtOrtHmdzQEGS1AAHAyhw728slt9QteVxegCOU360/5oI/j2S84zbe0JZl
	aCkxQsdDxoCgHy7N1hw0ve3JkK/xLOMje44UxShRr+DDXoVE3P6r35Do8Wk4ky2PW/tpZ4jbC+q
	v9zcO3H7X5aOno0VynbNmssq6Gi74LxHjzJRs2O5DBHdvWmlPhTNg5LDkd43n6QGuJ+KC43UE8h
	0Lhc6a3PzybuR11EjuXnhntbiwxzI4Ti7u31wqdZo=
X-Received: by 2002:a17:902:e84e:b0:2c6:a99a:52b5 with SMTP id d9443c01a7336-2c7fc890641mr46029165ad.12.1782438890700;
        Thu, 25 Jun 2026 18:54:50 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63b2bd7sm29047005ad.48.2026.06.25.18.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 18:54:50 -0700 (PDT)
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
Subject: [PATCH v6 1/4] mm/zsmalloc: encode class index in obj value for lockless class lookup
Date: Fri, 26 Jun 2026 09:50:00 +0800
Message-Id: <20260626015003.2965881-2-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260626015003.2965881-1-haowenchao22@gmail.com>
References: <20260626015003.2965881-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D31FD1A000A
X-Rspam-User: 
X-Stat-Signature: zcq11zic1fbjqqdis4ypbgi7grna8zbf
X-HE-Tag: 1782438891-920475
X-HE-Meta: U2FsdGVkX1+iGZqJt4xecq5z69TL4gEoMl0LW3AWvIInWXuQEWrIOqQKL9Dq+68Va1g2+F49IP/Pc8Gdbahh3ZTxpj+WaWu21R2C5sJN00gvIN7QIV0yEnzKpXYlPR/xh1kysZ1HV8qDezwTh2T+2Y1KRS8MPgDxNa94bJ0hEJCR4BAX9Kio9Lr/YC0KCMi+fxBoV2lbwgO4CUydo9GWcqjwUb/8vY2GbIC5niYqdmR3r+FzgesERu4sra48ERvBsphctqGMjar2DyhZcMLfZZG/b2GtAebf0lqdNBaexrQr7OVDiOsbu5oU5+9Gr+hvGhLHPZesuB6oskXAuLzBSAZDEE5fGDcQQa91PtTC3jxZWUQI8qj4ZSULjAeAPVZghPkmkZN63+2rt/iJJD7vhkaXdAVoKb4sJ5TinmRGGFo4xJ3O2NAAi9XOGz7vjtaWJ+TQQmfXKAgha07NQvk4KsIkMPEJd0wTzJDO3c83ApVh+RRkr7CMh97NRZ0CdBBFOZ5Z3ux2YIxNkD6YFSEwupQeFsrZ+VSiPHcf0lqcsQvOTOT0NxeMMEIN7L4ru3MZZ8KXRywf/YDwyrDPnvZIhZj2ExiXQdzdicOskbq6Fh3/EXIU6Tx9zZWlfOFJdEfF0qFuW5C5OA7h+XOEPILzTUHeYcbVlQ1BOR4ug8KH9As9JGWELkXoyxQUTUbpsKTF2kUd1l8WnKbS5bVMpD4T4PKmlHGvvcYTzd1cghDs+K3lXwyt+2Qk9kzOUi2ORh7h+ht3KeNwZisGPfp2cExEtM/g0tCp5KrVLsdecA0tjYk5LkM+wfVIHDtmDvBhzmMDQLweLGo69sVpcfJal4chgo+SdXUMohHIsZYdK26oAFQ528PWMFAuaBgoE3LFAK76x/UYijZT0fXSX3twOde+RxQzX/+GizixR9P/MrGkjntSKI/lFaFg0kCdPpgYXp9BXpiIJUBhpxzFhVFimPW
 XEI5ntuc
 QUVIweF9/bDvlvdHagkdZQwCIAGIkjduobvfKTkElbXPfhcKXinjAXJrU7hzwVWB4jFMDTIdN46Vw3d6EgHVzke3vre2ZFizTp51kWJ4OtLa2yLzoxepsFuUJLO5XnyI6FtiXGWdDG/DyxzBvLa2C3caiWXrDaar3tEu0jbPkiqlnr/2tWOP67ZrlFXiH6h5iVLCsd+5EpoLcSxi816fQyppR69Tskl7inZNoFRc+ZiYwPDBSvFjXdYCJqbzWIymZ88/nFJ7tRSLYyweWPniizZIvtVafGEzOgWvZr7S++X7yPFGcKchDOkaHC60gxbkJEr03sGb0N6xAezDIKvVITzXUnlor7mZ+ryIddcSQePb3gfOQVSOsmY0Y0ZxdtPLhBsNEFNTcbrbnlU2BGjYC5N4HCzXyuhVRkEU9Fddsd3OLTW8ERioUPehq3r7K+UkwGU9Ib8FkWXPVtiEjANGSY0Himdcy90VWLWRkq+/L2lYPQLXUosxzGlLm6OIHHFsQh1EP
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

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 105 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 14 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63128ddb7959..c4fc06b259af 100644
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
@@ -98,9 +113,61 @@
 
 #define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, UL))
 
+/*
+ * Bits to index a page within a zspage = ceil(log2(ZS_MAX_PAGES_PER_ZSPAGE)).
+ * Computed at preprocessor time, for use in #if below.  Kconfig
+ * restricts ZSMALLOC_CHAIN_SIZE to [4, 16].
+ */
+#if ZS_MAX_PAGES_PER_ZSPAGE <= 4
+#define ZS_PAGES_PER_ZSPAGE_BITS	2
+#elif ZS_MAX_PAGES_PER_ZSPAGE <= 8
+#define ZS_PAGES_PER_ZSPAGE_BITS	3
+#elif ZS_MAX_PAGES_PER_ZSPAGE <= 16
+#define ZS_PAGES_PER_ZSPAGE_BITS	4
+#else
+#error "ZSMALLOC_CHAIN_SIZE out of expected range [4,16]"
+#endif
+
+/*
+ * Bits to index an object within a single PAGE_SIZE at the smallest
+ * possible object size: log2(PAGE_SIZE / 32) = PAGE_SHIFT - 5.
+ * 32 is the hard floor of ZS_MIN_ALLOC_SIZE.
+ */
+#define ZS_OBJS_PER_PAGE_BITS	(PAGE_SHIFT - 5)
+
+/*
+ * Bits to index any object in the densest possible zspage.  Below this,
+ * ZS_MIN_ALLOC_SIZE is auto-raised by the MAX(32, ...) formula -- still
+ * correct, but objects are coarser.
+ */
+#define ZS_OBJS_PER_ZSPAGE_BITS \
+	(ZS_PAGES_PER_ZSPAGE_BITS + ZS_OBJS_PER_PAGE_BITS)
+
+/*
+ * Encode class_idx only when obj has spare bits; otherwise
+ * ZS_OBJ_CLASS_BITS folds to 0 (32-bit, or 64-bit UML/fallback).
+ */
+#if BITS_PER_LONG >= 64 && \
+	ZS_OBJ_PFN_SHIFT >= (CLASS_BITS + 1) + ZS_OBJS_PER_ZSPAGE_BITS
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
+static_assert(ZS_OBJ_IDX_BITS >= ZS_PAGES_PER_ZSPAGE_BITS,
+	      "zsmalloc: ZS_MIN_ALLOC_SIZE would exceed ZS_MAX_ALLOC_SIZE");
+
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> ZS_OBJ_IDX_BITS))
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
@@ -721,26 +788,35 @@ static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
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
@@ -1276,7 +1352,7 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
-	obj = location_to_obj(m_zpdesc, obj);
+	obj = location_to_obj(m_zpdesc, obj, zspage->class);
 	record_obj(handle, obj);
 
 	return obj;
@@ -1762,7 +1838,8 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 
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


