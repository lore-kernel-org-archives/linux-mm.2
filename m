Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F9A6CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7CD16B0104; Fri,  8 May 2026 02:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52E96B0106; Fri,  8 May 2026 02:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69266B0107; Fri,  8 May 2026 02:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C372F6B0104
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:19:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 630824072E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:19:29 +0000 (UTC)
X-FDA: 84743250858.30.3AB1A11
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 847A780003
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:19:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JLwBhSuU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778221167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+4px8BwYZFhTuuCugdzO8I6K2HioZzSZpj/NFEZaAQ=;
	b=W+p282eJBK7OnmbRA1ez96u8VezypOT5kGNysvCsGrgTXateBl/g49M18Vc87qftg4crjj
	LBI+OCHNWMIdEZ+Ln5zYZj8MFgVpzyancaec6BRwZxZHo2lvzXalJQktpm+AHvW7cQFbE8
	wPV2ffAeAFGgU+g6YwUA6ecBOBUCK74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778221167; a=rsa-sha256;
	cv=none;
	b=FnLUFB7TzEe5eiqLAIZsJ24slEc/9vyG+a+OodBRbw5yDNfZhhDDtistRNsIYhSOmxeXxu
	duVydNURv9nzXN2hSC0sbfYrgp+X0iMpu4GiaBYADP+Jv34du2bTufu/aNMHYS3AiPoa7h
	S6kx8Bor4zC4P0XJyRJjuCsUtJ4QPYs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JLwBhSuU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8353c9f24d2so895244b3a.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778221166; x=1778825966; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+4px8BwYZFhTuuCugdzO8I6K2HioZzSZpj/NFEZaAQ=;
        b=JLwBhSuUt7loE1ngX7nU5rxPxDBzUIredzkGw+PbBBYhUwCHjcYO0bxxf7+dJmkDul
         YVKa8ALblgxSNiUfgugR+qsMqRlTtQZIyf6mYvbKVnMx6Y5xaBcsdNyTxyJjHZM0bjeJ
         jw1GeprYZLANnKMGs7KGn3gdDErpa6zWDWrrRHv6TfGh06ePskn3cVvr/zSCT1SSPVlZ
         cFIR1pDxAo18b+nVGyJxG4NEkkHvvYwLCivLTcA3L+mHUkHvJLOwfTV72LzzfU64SOF7
         jXi56xVleZkpJYpu+lnNLt1D8wBjg53cb1UpavVPe8M3TOebfUS4DQ5xdYKCQ8If16gB
         zfog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778221166; x=1778825966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z+4px8BwYZFhTuuCugdzO8I6K2HioZzSZpj/NFEZaAQ=;
        b=VSCGgLX79Gid0Y8yfoj4Yro0TYXGZikYKsAiX5UzTrMKgu/UeA0jlBwLz/kABdRz6e
         j1sAV19ul3SV+RcyxLE1ORgvFu9uHAEhh/XB2m4HKSKKE2OrhCeGW+e38suxrZqM3vps
         apuYW5uuE7R/dwSGEmJ9mBHEp8rK08EWDOaoajTLw287ki1n7YQmSU83QEFK6ApAr9FA
         Mo8dFi2O+BHQL0IqCtKWt5sPoMHuvef3VVJi9UIJpNBcHQ3Z4oO7oytD8lwnUn6wT+Vn
         T7A5X7hs9tZBQnK5kfwO6xRDx58EbGFSU0ZZqi4YhTYC6EzgtPzuW/527CRPl5UqmStP
         5R1w==
X-Forwarded-Encrypted: i=1; AFNElJ9CIyC3r0HaOU0cSg21NQcBUluPFa7YTOmhph0I1gkL3LWy1MmrVzGkONWAwJDleByDfRgDV3jjAQ==@kvack.org
X-Gm-Message-State: AOJu0YzkgR0Fr5KAYnZKNuoufscyq2xeEdN0SoWLQCPT17gXC7j0eVmx
	YgH8pwbJmLJuEs+0NG+GsI2crU2VdJs7CTbPZskW99Dplgs6sZDU2+EL
X-Gm-Gg: AeBDievHMvpvjx0wdvJZDUra57VQ1+Dr9J9adi2k+fRexM2cXhlLwXBLwUlGqZiWJeb
	1OI3yAyr7xC3d+E3dqfs5Y2GjUoB8UCjucFXODppN2MYvH3zbA6f/5Si2TkElsv7QQxf0ZdcGza
	izUNfbwfpWoP45g4NPH+IQHDQjZRcTWJSC6tsr510IoCnigX4I+3eKNjieKqmUDpriWE6X7t6lx
	cKVJSIId52h1ls+z+un3QMz6Tlqf4OWeLd0YzOwuzEdILExFJvU3qlCRJDknKrkPXIpmtDxK7b2
	oUMzQmQbm4BQoPK4Ttk11nxZEVvVKd40k/xcIwaZgJbXq+rwn25L/s0GJQ5hnfjU/7y94D+FMNo
	gliUhIaiX8CSpv8iYmYC7HbYacC0xq2b9DTf3DwRL3yArbVm9WAv8Dpf9VwfVubk0aGxFZM9SuU
	gWBaa1XNidI97545RIfY/hUtahpcPUWWSCOGl9OQ==
X-Received: by 2002:a05:6a00:6c9a:b0:82f:98c:1465 with SMTP id d2e1a72fcca58-83a5d681339mr11042157b3a.27.1778221166221;
        Thu, 07 May 2026 23:19:26 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965a3e3ecsm11308452b3a.19.2026.05.07.23.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:19:25 -0700 (PDT)
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
Subject: [RFC PATCH 1/3] mm/zsmalloc: encode class index in obj value for lockless class lookup
Date: Fri,  8 May 2026 14:19:08 +0800
Message-Id: <20260508061910.3882831-2-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260508061910.3882831-1-haowenchao@xiaomi.com>
References: <20260508061910.3882831-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 847A780003
X-Stat-Signature: ptgty9rwsosp3dhnp6rtmbghxtwrpdz7
X-Rspam-User: 
X-HE-Tag: 1778221167-121147
X-HE-Meta: U2FsdGVkX18enK01Sb7c0agbxNFnalexG67Ql/IdWnF98E2L1ORgLI7sEJQZSkuwz09f9ebRdb5ZTopeCmlSUApIqMuq5SrMpcC5BToebhsgMfsqUke5iPd2CrUD5S2a0IlW7e+nhFLCvLrqnrCBjq8+KlPrl0Eh9qAGxaupEVGdALvbZkhhpOyOeSxc5afkMRA7nuj3VECZZsVe4K5X0tpQk9u49FAqeHWNwitvG0Dq+rW/43mxVBzPKP5r2vgolCXZc8euOxYtXyqzSflXeTXCuU5U/un/aUtC4iRFW0JUWB/odW9LZ9Zv68XBRgCMSB75CpeEodO+7T/Kd5um1mgjpAi7braUAEvKbheM38vuJQBllcWlGyxdA7L4M0Thxu02z9sHuUgyyc5EJgMn5fjhhSVkPtHmGc/hEU1CMP/F+3ly09lv3gJvmwaovap6zthtys8cwSCQPTBYiUPaIfak9n9nXmkXwBJhsrrj6PvryslyqkTjVDpqz8oXmn/C20yHEOhzTSD4iwIFvGxqIzHWXg7c2Yem3aGe7eOefozYDT4kcW1xbmu37I1NLgEPL+BrCwepQvwACdwn5eRHWHN8ZhrMCFKO/n3opVWzpWBmSvjsB/SGhEDWz0ao8YXv5f8ksXSkUCfXGWzr7cO4nCjyvbCEm/HiMNkZEp/WH/NUO0wSCTAqnXpZGLNtFqaipfUMN+r406o6XeKsvLUJf81FHovELLu8PonoP4HP1OvLDq2xy8pCcG3nEsSdItqb2bmyLXNZTc2gaD4cydYSzINZ1Qcozemsowcf1hGsNJdTQhjvt/Ih2OEFg3Oe2IuqSq48J8YvazbIuwD7v6P7mSRuT3J4RgHuGU6ESTnDE4bnsZ3u/+TdltJQJwSImBieKoL5X7kRN6IL48LiAi8rmu05PBEZsm2DHFj11S50Y+huAhrwwJXoUXzVBD0W+ABfwv03eROY4ZApY2pbfKa
 KHMIou+P
 zdEiMylnj5awOfxRssnU9SfShwAzX9D16kEJpLTgdQm0WLYS16YwpTLN9WN7U+pKfEykPO2DRm5GIoHH+n3APi7Q6NeZwh1WfOygm25mdUhuuWyAyZ9U7H8oTXK9po7JHncsqRuZBPL/WE/W6ry0ldXsAMZQ+J5XmF0jpe3hB7HalnHyJ1GblYLIJnmMHx8EpAXzu/8AgTZBuTymZDBP/qj7sCwTvCgRUJLQx2ua0JchODp8BeOIcuqRMLKR8AmiNczyF7LpyM6PWdxOp5R11xIhpLmM/3AaHqwnju+r2cA5DM9a1KXznw7Mnv2TCOTOvqILBzbxC97n/hhlSG3QyfG06DPjVFfjYk2+MoSxqxOuoxi+nH4j3D+ksUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Encode the size class index (class_idx) into the obj value so that
zs_free() can determine the correct size_class without dereferencing
the handle->obj->PFN->zpdesc->zspage->class chain under pool->lock.

OBJ_INDEX_BITS is over-provisioned on 64-bit systems.  For example on
arm64 with default chain_size=8: OBJ_INDEX_BITS=24 but only 10 bits
are actually needed for obj_idx.  We dynamically compute OBJ_CLASS_BITS
as ilog2(ZS_SIZE_CLASSES - 1) + 1 (8 bits for 4K pages, 9 for 64K)
and verify at compile time via static_assert that the three fields
(PFN + class_idx + obj_idx) fit within BITS_PER_LONG.

This encoding is gated by ZS_OBJ_CLASS_IDX, defined only when
BITS_PER_LONG >= 64.  On 32-bit systems the bits do not fit, so
the feature is disabled and the original OBJ_INDEX layout is preserved.

Split OBJ_INDEX into class_idx and obj_idx:

  obj: [PFN | class_idx | obj_idx]
       [_PFN_BITS | OBJ_CLASS_BITS | OBJ_IDX_BITS]

class_idx is invariant across page migration (only PFN changes), so a
lockless read always yields a valid class_idx.

Update obj_to_location(), location_to_obj() and callers accordingly.
Add obj_to_class_idx() helper.  Adjust ZS_MIN_ALLOC_SIZE to use
OBJ_IDX_BITS.

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 88 insertions(+), 7 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63128ddb7959..bccadf0a27f2 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -96,11 +96,74 @@
 #define CLASS_BITS	8
 #define MAGIC_VAL_BITS	8
 
+/*
+ * Optionally encode the size class index in the obj value so that
+ * zs_free() can look up the correct class without holding pool->lock.
+ *
+ * Rather than fixing a hard CLASS_BITS constant for the class_idx field,
+ * we compute the minimum bits needed from the actual number of size classes
+ * and the actual maximum obj_idx, then check whether they all fit:
+ *
+ *   _PFN_BITS + OBJ_CLASS_BITS_NEEDED + OBJ_IDX_BITS_NEEDED <= BITS_PER_LONG
+ *
+ * This naturally handles all architectures and PAGE_SIZE configurations:
+ *
+ *  - 32-bit: BITS_PER_LONG=32, sum easily exceeds 32 --> disabled.
+ *  - powerpc64 64K pages: ZS_SIZE_CLASSES=257 --> OBJ_CLASS_BITS_NEEDED=9,
+ *    but the sum still fits in 64 bits --> enabled.
+ *  - riscv64 Sv57: _PFN_BITS=44, tight but still fits --> enabled.
+ *
+ * When enabled, obj layout is:
+ *
+ *  63                                              0
+ *  +-----------+--------------+-------------+
+ *  |    PFN    |  class_idx   |   obj_idx   |
+ *  | _PFN_BITS |OBJ_CLASS_BITS| OBJ_IDX_BITS|
+ *  +-----------+--------------+-------------+
+ *
+ * Migration only rewrites PFN; class_idx and obj_idx are invariant,
+ * so a lockless read of obj always yields a valid class_idx.
+ */
+
+#if BITS_PER_LONG >= 64
+#define ZS_OBJ_CLASS_IDX
+#endif
+
+#ifdef ZS_OBJ_CLASS_IDX
+
+/* ZS_SIZE_CLASSES computed conservatively with original OBJ_INDEX_BITS */
+#define ZS_MIN_ALLOC_SIZE_FULL \
+	MAX(32, (CONFIG_ZSMALLOC_CHAIN_SIZE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+#define ZS_SIZE_CLASSES_FULL \
+	(DIV_ROUND_UP(PAGE_SIZE - ZS_MIN_ALLOC_SIZE_FULL, \
+		      PAGE_SIZE >> CLASS_BITS) + 1)
+
+#define ZS_MAX_OBJ_COUNT_FULL \
+	(CONFIG_ZSMALLOC_CHAIN_SIZE * PAGE_SIZE / 32)
+#define OBJ_CLASS_BITS_NEEDED	(ilog2(ZS_SIZE_CLASSES_FULL - 1) + 1)
+#define OBJ_IDX_BITS_NEEDED	(ilog2(ZS_MAX_OBJ_COUNT_FULL - 1) + 1)
+
+static_assert(_PFN_BITS + OBJ_CLASS_BITS_NEEDED + OBJ_IDX_BITS_NEEDED
+	      <= BITS_PER_LONG,
+	"zsmalloc: class_idx + obj_idx + PFN do not fit in obj on this config");
+
+#define OBJ_CLASS_BITS		OBJ_CLASS_BITS_NEEDED
+#define OBJ_IDX_BITS		(OBJ_INDEX_BITS - OBJ_CLASS_BITS)
+#define OBJ_IDX_MASK		((_AC(1, UL) << OBJ_IDX_BITS) - 1)
+#define OBJ_CLASS_MASK		((_AC(1, UL) << OBJ_CLASS_BITS) - 1)
+
+#else /* !ZS_OBJ_CLASS_IDX */
+
+#define OBJ_IDX_BITS		OBJ_INDEX_BITS
+#define OBJ_IDX_MASK		OBJ_INDEX_MASK
+
+#endif /* ZS_OBJ_CLASS_IDX */
+
 #define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, UL))
 
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_IDX_BITS))
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
@@ -722,7 +785,7 @@ static void obj_to_location(unsigned long obj, struct zpdesc **zpdesc,
 				unsigned int *obj_idx)
 {
 	*zpdesc = pfn_zpdesc(obj >> OBJ_INDEX_BITS);
-	*obj_idx = (obj & OBJ_INDEX_MASK);
+	*obj_idx = (obj & OBJ_IDX_MASK);
 }
 
 static void obj_to_zpdesc(unsigned long obj, struct zpdesc **zpdesc)
@@ -730,17 +793,29 @@ static void obj_to_zpdesc(unsigned long obj, struct zpdesc **zpdesc)
 	*zpdesc = pfn_zpdesc(obj >> OBJ_INDEX_BITS);
 }
 
+#ifdef ZS_OBJ_CLASS_IDX
+static unsigned int obj_to_class_idx(unsigned long obj)
+{
+	return (obj >> OBJ_IDX_BITS) & OBJ_CLASS_MASK;
+}
+#endif
+
 /**
- * location_to_obj - get obj value encoded from (<zpdesc>, <obj_idx>)
+ * location_to_obj - encode (<zpdesc>, <obj_idx>, <class_idx>) into obj value
  * @zpdesc: zpdesc object resides in zspage
  * @obj_idx: object index
+ * @class_idx: size class index (used only when ZS_OBJ_CLASS_IDX is defined)
  */
-static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx)
+static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx,
+				     unsigned int class_idx)
 {
 	unsigned long obj;
 
 	obj = zpdesc_pfn(zpdesc) << OBJ_INDEX_BITS;
-	obj |= obj_idx & OBJ_INDEX_MASK;
+#ifdef ZS_OBJ_CLASS_IDX
+	obj |= (unsigned long)(class_idx & OBJ_CLASS_MASK) << OBJ_IDX_BITS;
+#endif
+	obj |= obj_idx & OBJ_IDX_MASK;
 
 	return obj;
 }
@@ -1276,7 +1351,7 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
-	obj = location_to_obj(m_zpdesc, obj);
+	obj = location_to_obj(m_zpdesc, obj, zspage->class);
 	record_obj(handle, obj);
 
 	return obj;
@@ -1762,7 +1837,13 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
-			new_obj = (unsigned long)location_to_obj(newzpdesc, obj_idx);
+#ifdef ZS_OBJ_CLASS_IDX
+			new_obj = (unsigned long)location_to_obj(newzpdesc,
+					obj_idx, obj_to_class_idx(old_obj));
+#else
+			new_obj = (unsigned long)location_to_obj(newzpdesc,
+					obj_idx, 0);
+#endif
 			record_obj(handle, new_obj);
 		}
 	}
-- 
2.34.1


