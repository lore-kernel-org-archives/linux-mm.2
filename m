Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5075EC53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7395E6B009D; Sun, 26 Jul 2026 18:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711156B009E; Sun, 26 Jul 2026 18:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6278E6B009F; Sun, 26 Jul 2026 18:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29ACC6B009D
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E1B01405CA
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:36 +0000 (UTC)
X-FDA: 85032355632.17.9ED2FA1
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2D99C0009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ugBxdcXx;
	spf=pass (imf10.hostedemail.com: domain of 35YhmaggKCOoVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=35YhmaggKCOoVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104615;
	b=ddqE5uH6o5zgwtW74vIsGVqCc9LP7GuE1G/M8AkMlhStv4pg+K1ZN+0rrHHiFsw29wEsbj
	4fkCmM6wrsZcY8clqj2fnWaFH1sBRjRkZAz52lKkkPxEDNHvvOfi4pWktn13rYXnvO7Dbg
	TdUSuilSJ4JtatV5gTH41YRk/5jIjnk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ugBxdcXx;
	spf=pass (imf10.hostedemail.com: domain of 35YhmaggKCOoVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=35YhmaggKCOoVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyOh9aeu8h8uSSc2SnxD7XE/Zp9/FI1sdExUOKQtsH0=;
	b=i+cpOxHNO9D0FeJ+vkbBDZOap7juRidcflJ4BIoFOEJ9ymnsD6l5pFZpBdlXeLURXpuB1E
	bEO7CooJJi3COyd+nQVP4DXCNosIwVKcM6pwOHwh2wXq1Ahshr3XmKpkj9S0RIGGpznESh
	WLoyoxcQjOmNwViguAxFLONBycYgIL8=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-496b4cc049fso11288745e9.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104614; x=1785709414; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pyOh9aeu8h8uSSc2SnxD7XE/Zp9/FI1sdExUOKQtsH0=;
        b=ugBxdcXxcJtVOcixNucJdJYscoW+YmaMPZpXsRegoifIo1EpBrJdcFmSJD/5X83WVX
         7YRQqr+v3I8aEBh5IdxSALweOSVZYGHZEha0hGRqE9cwERVR4hT+Py4QvAh1pHIYRJbq
         UkQESTr0BGMuzE/M6m56xRb2Hi3s6/XaJPO7i4q7UW7QApcpoF09mBysw+Y4C/z5Y3dg
         foXyzAWA/1W9roazmx/CH8zL5cCVP0TS8/GCbI4Y0SMyy0MgT/dOp1iFXHhOrpL/kGkq
         bmJeScyu3gML4FFYMGNjJWZ4yjDC1nJTMV47OiHgQc/PZ8RqZw1ob1jv2KjX1XzKzCyF
         c31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104614; x=1785709414;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pyOh9aeu8h8uSSc2SnxD7XE/Zp9/FI1sdExUOKQtsH0=;
        b=RVhsKjNUjCFtF2g3IPFP9dz6Uzz53081/logLsrh65tialU8wVb+ccwCcrGyVD/Zox
         OFACQgqsFBEwm6xRZ+kScl9HZUs1llk0T7RAxLiCrSJwiiKeioM/obdpbPJBthaodyPI
         /4sytzoTX4wrzpfKKoPLV+adgQOlP0RlWwlczRtQHyzYudufbpOnmBMzNgg0Fuh+HDUo
         IgXLOagMpYnag4MsruCzNy1QJY1/HGyTvemEIe6pvtFKCtB7/BFDydzM15ZOJCrlk9bX
         BNSCs+MDvvee1QxApzsCBRCV7AGLdlDDBZmxLkLu4hR8TsE4wTigKhOXBDvTWP1tiT4/
         W/PQ==
X-Gm-Message-State: AOJu0Yz5TjhsIRVZt27wI7wonYAEq9xKsrm6PEwCG0bx/gyVKeeHGwl/
	Wba8de3SgSkQyJRECciSlkKFOtrbybWfadWresk/P1svmIzgomw+KTeTkFM1rtVmDLmugyO5jNH
	GOhqA0D/7b75VFA==
X-Received: from wmsk6-n2.prod.google.com ([2002:a05:600d:8486:20b0:495:5bab:557])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3150:b0:495:4f84:7280 with SMTP id 5b1f17b1804b1-496b5b3b1d4mr83782625e9.4.1785104613513;
 Sun, 26 Jul 2026 15:23:33 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:42 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-9-6f5729aa9832@google.com>
Subject: [PATCH v3 09/26] mm: Create flags arg for __apply_to_page_range()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: hqsmpjn634cxsjqxgif5jbyo1hrgddm1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F2D99C0009
X-Rspam-User: 
X-HE-Tag: 1785104614-980653
X-HE-Meta: U2FsdGVkX18AEFQjLjawwwUkpcal8pyb0VhCUKVSz/aRqUXn2s3ZkhJdZCxJV9ssE0B7+WMP5VeVzDOcEqKy27LA7zo07NxcWN48FWq3h/EKr+5ScxCgaDTaHGJByJr+O9gEqQi6cDxE94giiLf/YXsul/nQcG1wuY1gftvP9qDeYOUrenmRMFcVRJOsCXZhxAMGBxx/bbEl/0HnW3pI3BTdaS9TlU/AZSctWIXbkyh8bhT+qU0pXRmQSEN2lfB7o8Zx8oVAjZsUdJx8MFubCyu+Kc1i5gwUAs2tgCYXsrjA4vKYsWAl4iFhJmwbmPmnLV/nkXJAEbnZA6Sg3MLl1gRrfdHJhPGXxSszgd1XNQ6xX5k9teMp6XaHgz+7gVt3tqS7+bvRUnDWVmAGqnE50BV5zw2jpqJiYz5T59vA9wFHYKbS39K3zUiVAoA6v4ZQEB6RndtLkS+qZyJtwUblZ+jV6KLBA+JBEoQEXzT3ysfcOnqO5Msho6giRtensudb3YYdnAEk5zF5zK5NrvD0f4rvOt4jBz82VHhjxdzp2wuefSywWlRRvjX2HpB8Lo+sd49sZ/XVc2Ugo/5TlVS5PK7T3EXXZbpM3x99oT3VezCHDJdKTaLd/+P7bEhtIbLM8V79EHBMxiWJ0WE5ufk/xKXQRWB5YelKva/VVxeRFYn5HkMydeQ0TlbpNHx8hkxfavAMsLkkBFthpEGwHb2B2/74rsYEOh3q9oKtGAEP5Q9if0HYYr0J/HyPmf889bDU8X7V0y99CMWJmHfhvgTapKBeh73F++n+MO2jIo2G+mNRVhMelrzGppSl7xT12OKqYBGLuc9wCBj4Rmb5xQy7Cf7KYlqS1qJXNG0iRoaejIlLoTnOKFZK+puH9YuK9KRTDKHvqv7Js1f+7T5rSByT3CScad0nallVYm7zjUd6S/dVi0O5R1zxYtZK6n8FjNFRA4UChJc2PEh0W1oup7K
 OvEaunaV
 Upw3hhJUnP6Hv6OPOS8RmnkMMYGCwRxvV+NieX4Br829wnZ4hpwdmvNSvua15mDJWrSwtqT/mlyzbfAMaqZFLD5K0ja+hoXlLZheHvgs9kw72udmJ0KQvMsohR/qfmqnP/0mLmRpEOscSfchdnZjLzxk4iKgHlL2YT4DXVuOgBgvdmI9YBR8+t/nK9s73s1xtrL3NOutt9QxkqYcJKy1iwooqhsEPDDK27O3xwBeTpBjxVfyObv0E5PTac9Q3cWCDeBK2SlifMbPuHmexNFf9aqOnk2PT8uhLeKLgPcQ0YwlI0z2aneHJlZMH+9pgoslbew8yS1tLl6Uu1QrnHyszNDmOLa7cOINukRjRUMQTdkpRnEswS8C7k6sCpP1blAjHHWsfN8zqp4vwz3vlDZu7Og/HB4Er0HibdpzasdoAghLiXklqPjqcXtFJjB6i0CZsj3mcn92Tz4Ht3HlRP9u0AVQIajwAr9QbSi2Aw30qnejfW1VxLjLsb0SU849hX9DLlJjlz+EkjlvTzhX4Uf1HmphMNZqLYGpbIjAGzIjuztWdCEukBJ83G9VgY3H/6FFwIhf8k1jfxZgvcaILWrDg5YAvejfvU69tcTWppPwgBB58qlzGSKXlsc7j5v01slh/XuMeaBLVduHZsWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preparatory patch, no functional change intended.

To prepare for making this function more generic, convert the boolean
"create" arg into a flags arg with a single flag that has the same
meaning.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h | 10 ++++++++++
 mm/memory.c   | 29 +++++++++++++++++------------
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index f47f06c555481..395331a12d62d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1660,4 +1660,14 @@ static inline bool can_spin_trylock(void)
 	return true;
 }
 
+/*
+ * Create a mapping if it doesn't exist. (Otherwise, skip regions with no
+ * existing mapping, and return an error for regions with no leaf pagetable).
+ */
+#define PGRANGE_CREATE		(1 << 0)
+
+int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
+			  unsigned long size, pte_fn_t fn,
+			  void *data, unsigned int flags);
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/memory.c b/mm/memory.c
index 789c65a6d6a0e..c4defefea1574 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3438,9 +3438,10 @@ EXPORT_SYMBOL(vm_iomap_memory);
 
 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create,
+				     pte_fn_t fn, void *data, unsigned int flags,
 				     pgtbl_mod_mask *mask)
 {
+	bool create = flags & PGRANGE_CREATE;
 	pte_t *pte, *mapped_pte;
 	int err = 0;
 	spinlock_t *ptl;
@@ -3481,10 +3482,11 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create,
+				     pte_fn_t fn, void *data, unsigned int flags,
 				     pgtbl_mod_mask *mask)
 {
 	pmd_t *pmd;
+	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
@@ -3509,7 +3511,7 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 			pmd_clear_bad(pmd);
 		}
 		err = apply_to_pte_range(mm, pmd, addr, next,
-					 fn, data, create, mask);
+					 fn, data, flags, mask);
 		if (err)
 			break;
 	} while (pmd++, addr = next, addr != end);
@@ -3519,10 +3521,11 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 
 static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create,
+				     pte_fn_t fn, void *data, unsigned int flags,
 				     pgtbl_mod_mask *mask)
 {
 	pud_t *pud;
+	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
@@ -3555,10 +3558,11 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 
 static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create,
+				     pte_fn_t fn, void *data, unsigned int flags,
 				     pgtbl_mod_mask *mask)
 {
 	p4d_t *p4d;
+	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
@@ -3581,7 +3585,7 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 			p4d_clear_bad(p4d);
 		}
 		err = apply_to_pud_range(mm, p4d, addr, next,
-					 fn, data, create, mask);
+					 fn, data, flags, mask);
 		if (err)
 			break;
 	} while (p4d++, addr = next, addr != end);
@@ -3589,11 +3593,12 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 	return err;
 }
 
-static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
-				 unsigned long size, pte_fn_t fn,
-				 void *data, bool create)
+int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
+			  unsigned long size, pte_fn_t fn,
+			  void *data, unsigned int flags)
 {
 	pgd_t *pgd;
+	bool create = flags & PGRANGE_CREATE;
 	unsigned long start = addr, next;
 	unsigned long end = addr + size;
 	pgtbl_mod_mask mask = 0;
@@ -3617,7 +3622,7 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			pgd_clear_bad(pgd);
 		}
 		err = apply_to_p4d_range(mm, pgd, addr, next,
-					 fn, data, create, &mask);
+					 fn, data, flags, &mask);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -3635,7 +3640,7 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			unsigned long size, pte_fn_t fn, void *data)
 {
-	return __apply_to_page_range(mm, addr, size, fn, data, true);
+	return __apply_to_page_range(mm, addr, size, fn, data, PGRANGE_CREATE);
 }
 EXPORT_SYMBOL_GPL(apply_to_page_range);
 
@@ -3649,7 +3654,7 @@ EXPORT_SYMBOL_GPL(apply_to_page_range);
 int apply_to_existing_page_range(struct mm_struct *mm, unsigned long addr,
 				 unsigned long size, pte_fn_t fn, void *data)
 {
-	return __apply_to_page_range(mm, addr, size, fn, data, false);
+	return __apply_to_page_range(mm, addr, size, fn, data, 0);
 }
 
 /*

-- 
2.54.0


