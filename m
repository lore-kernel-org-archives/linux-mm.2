Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA94C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7186B00B9; Mon, 20 Jul 2026 05:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968126B00BB; Mon, 20 Jul 2026 05:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87DC96B00BC; Mon, 20 Jul 2026 05:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3F86B00B9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:33:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDD41C077E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:33:06 +0000 (UTC)
X-FDA: 85008641172.11.760F6BF
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2FC6EC0007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:33:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=I4UpIQSI;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539985;
	b=rEhwCzRshlyk+PAB4xplgvwZsyYmO5MNO6+qYvpuQmhHrlYKxTIZA4J+cEZN5dgy0aWEhG
	mqY9F36BZ1AcQsh/cxveKhJxmS/xg6m/NG/hCJsY2eQg8iUBIUJz7S8RK63MeDNMCFZuL2
	k21ql+a/gBwjdE6kxdDa2afX2RUvrnU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=I4UpIQSI;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tj81g8LuTQ8+sncASIkT/kKzX02ru341igJMpdvJrHk=;
	b=ZRW9U37qn0Czb7frLXEZUUP5T9ctvHvInu3aG9FP6IMKr524OzCSY8yxD+kOH923WmIWHi
	VAaK5RrJ49uxwYC+gnLHv2Lc3tODQozZSoFoFgfOudHtEyGenVb5z3BhLXFh0l1y6RQSwt
	duy0whoteWXaRpnrqDQnjesR9bP4W8U=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cace91f112so100152995ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539984; x=1785144784; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tj81g8LuTQ8+sncASIkT/kKzX02ru341igJMpdvJrHk=;
        b=I4UpIQSIKFiL3RPoD94aDOyaYtJblZG40ftV/sJNuWLzfvoYj1aeyptdXPJ0cLT85E
         EnjwPi1xgQhe9m8CJ14lGdO5Ila0MwIjpSjyWATSi4RNmU5f+ceLpE2YuK4LhED+Aolw
         nx9O5nGX3ajVHh4W5Er2KEQNM2v2ammxUV23na7GdgGeDQfrFA0Ldkk4QxhXUcV/JjcR
         GAhcenbEUAwW0iU4QFyl8EbLDKwB58dQHXzvQXi1jPRMYq5mChhAkezF9RHpuxn/1yTj
         lARvEoQVLbDCRvGgB02BafN2A9QmrFDt5T0OH3v2XrK0iSSKmTPGRXKzlczlQhIrP5Ly
         oVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539984; x=1785144784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tj81g8LuTQ8+sncASIkT/kKzX02ru341igJMpdvJrHk=;
        b=WR0Vzo16U0HGokUd8xleFI2EJFbrfzQik6tXxmy2Mc3S7MSgM8s6JsyLv1ST6LSgk2
         muiUWgJ2jApQ+O85EM9DKSSIqFbneiZC2nar0KFX0pVzGFoCKQxhzox5ghb+GHYAjxRi
         b8W+yhUMNgRi3OteKGXBTjzszR2r2Q2PkuEhCIqV2TnZ0WU/80G8hP1iu0OpXyAgYbWH
         DAvKt342EyWPSzFH4PL56oi7t9dGnuYEASif9bj2ArU+OfELtVKGdFbH8ZYVmB02CIwa
         1eRuCRd50SkEzzjTgfv6GbJRnrIq7EJOiW4CQqPKzoiAvwtT1TNK7gWeJO9pkJR6juOT
         iJ0Q==
X-Forwarded-Encrypted: i=1; AHgh+RrEymzjW3i4nLztseOtRFiLXfq/4C398Pzc2K957yx+uK3l0u74U4A6pX5rTJko/cxODlwlEF0ocA==@kvack.org
X-Gm-Message-State: AOJu0YxNgkImO0fe4/9AtMo6kTIhNwx2tjRae4AdsRxkzIzdvQEM3Xjo
	Weq6AhiLCtxV6DlHsMAJbOR9OlQmcdKO3YsNKnRRBcp5cbfxuxJ0ZI2kPSAahxbfhv4=
X-Gm-Gg: AfdE7cmgxVGZwTxo0bnunVf8+i6YtFV/PJLmceDdFfOjbZqSoQgQym33pzZibvJkwxt
	qS4nNQZgm5rd6XsvAhlTBexEt6PxCjKhv2Upn6Iqsrw9pPVZv8xtVA2f2oT+SDX4oJnB3bFS4SA
	OYfEuc95lWJTC44rZfv/t0b+tyw80j1t4ZI+hbyZc7eV3jsN+9dPJ69e81yeQEAGFh1iefEVj7H
	NtKgItLQhzm+w1hr92hGGP07bF6fnuLLcoYMOeqD2OkmZ46598MFFCxyAK9n6ASoYXj0FbpcLVA
	D+bjDsEfxcrLN2kHVKfPUojwxvCtTeEXEtolGm4Oq/d3s1uVOcH/WrjOZI4arK+TiQn7MmeVP9B
	7zChHHF1awSHZvR75+3JDRyqcp7Iauq4ju2Hd3j2u3hSolHA6GPmmh5gLAyToklMEGdl2tNM5JJ
	yR7hUHaKgjelBzGcf6d1mPUUo=
X-Received: by 2002:a17:903:2301:b0:2c9:aae1:a611 with SMTP id d9443c01a7336-2cf349bb7cbmr136649455ad.23.1784539983964;
        Mon, 20 Jul 2026 02:33:03 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:33:03 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 16/17] mm/hugetlb: localize struct huge_bootmem_page
Date: Mon, 20 Jul 2026 17:31:26 +0800
Message-ID: <20260720093127.540540-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2FC6EC0007
X-Stat-Signature: e8x1hjgcr9cyj61eupac7aq6gxqktz7a
X-HE-Tag: 1784539985-334789
X-HE-Meta: U2FsdGVkX18ucs5Umr3lQ92/RKnNOfTh/B/JH/ksBxrr5zy3pVc8qjNPB8oR+X7yH5FBjsGfa0NRP+YGwEQWaEJO9k3P1Jli8S+2yrC0JEZyp+42Cow6+wU2S1ksytMRl6Xfu16G+05tDYRijSLDBBN7s7fRlsJSlcmsAMRnFG+eooDK1cMC8wLwarFHHewTqs9tnMn+eC7nanmhjho/GPjo/J2JhecM8eT5S1UA80bY7i4Cziy32UgG8dD3+Ik9SymvUhEeL2iZvGTK+4mEm1gVJWW4oTTK7J0wu34aVgW9od4LnAglCBMY6VI69XQGWM+XmaqfTZFoSnrg5KrVUQfBLUfGc1q8QXHGZThmkFTqZM0yiIXr3WfK0gxCK+he6VYcuE32VyUDPuVb0PmaVJzCztn7dDB1wxxLftZOcIMCDPgHIWbfwD3uL5vY+KBfVev2sZage9bnRhIzPuBd5BK8SZIqXJltktbXap697iEPBHT0ht6IbtR6Dsz9Jurd6q+TXSoobeOb5alaS8T3Gl3Q451L9uJA2RQ5OttnlPegCJMMvfGk7CIexJaQAxjpBxkJ5yzQUVCr20zcJe8B1Zn86Rt5QmrgeWRAuVx05aEww5PfsQG/TLr2zwPe/4WZqb99tkWJocRuNAsp9d25EcfEA8IcEmKdajgcNteNlJem9evkBRe8sqteRkDLMtwhKWN0MShR0Hpq9vWxs5ganCGXr4wjdibEM+DqNTTACESCKkpZswX9xCMuqFZbzemYnul0TluiF+4d0JTolJL2R5yZ43yh4NiTd/UVvb4FGBL99vd8HKB3G5xITEklUOD4DWka0O1Rmi6IzvjjQNxUn68qerrUBXne1v3fVALATiTeHCri4JDQ8gJPRK4aheL2AfWNzlxJaRBUBuSGE2O9AJM/c9OWggkY7b6cCv+cAcwStFPsqpaj+BjlxvvPRnXqmkWDqEaP9tYl8uZhWdw
 jeNtl/SP
 E/wGNbbKLreVP5EZ2XdS49Y1zGqyaO+rlnz7c26cj3sy4Oe7zG9Y/fNRwYPC0gEfmMACTjhiD7GljhHd2CGNkmmvQBBcPPeqSeMDTTL17SY8T/E+FD0zWn7zbJAMHlOPEcpdm4Io8zNsGPT3/CU851BzYS0L8/UGVDxer8v6InHOkTTLrESMQVITuEYNxhdhqy6iOIHTKA/ojlkVR34yrhJ+/Km2a19bSjaPW3WjeO7Mb8yu4XCAQRDAgO7wILvb2olPpPWstcY97XeMe9SJHbgnOSd90NSjcg61ZgkGOdyh6mf0SH2lm9aDad0uJaHX+rRN+dLZJqNBx7HlzhkoiTwRk6NY7ap9psZz+hTmSv7LdGV/WRMoAxtMWwOUftDx570jrvCKfA29YMUJgsCz9zf9FNr8PYxF9qEQf+IyHT9DqmHsVbgmUvHXY8z2ZNpofo5MFRcOtVgEAXyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct huge_bootmem_page is only used by hugetlb boot-time allocation
code, but its definition currently lives in mm/internal.h because
hugetlb_vmemmap_optimize_bootmem_page() takes it as an argument. This
exposes a hugetlb-specific internal type more broadly than needed.

Change hugetlb_vmemmap_optimize_bootmem_page() to take the information it
actually needs. With that interface, mm/hugetlb_vmemmap.h no longer needs
to include mm/internal.h, and struct huge_bootmem_page can move into
mm/hugetlb.c.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Pass PFN and order to hugetlb_vmemmap_optimize_bootmem_page() instead
  of struct hstate and bootmem metadata to simplify the code further
- Collect Acked-by from Mike Rapoport
---
 mm/hugetlb.c         | 8 +++++++-
 mm/hugetlb_vmemmap.c | 8 +++-----
 mm/hugetlb_vmemmap.h | 5 ++---
 mm/internal.h        | 7 -------
 4 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d0c726845fb9..364fdf254e78 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,12 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+struct huge_bootmem_page {
+	struct list_head list;
+	struct hstate *hstate;
+	unsigned long flags;
+};
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -3152,7 +3158,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-		hugetlb_vmemmap_optimize_bootmem_page(m);
+		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a25adc474351..eb339c4a71f4 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "sparse.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -705,15 +706,12 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
-void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+void __init hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
-	struct hstate *h = m->hstate;
-	unsigned long pfn = PHYS_PFN(__pa(m));
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
+	section_set_order_range(pfn, 1UL << order, order);
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 20eb03df542a..464192e32dec 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-#include "internal.h"
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
@@ -26,7 +25,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
-void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
+void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -77,7 +76,7 @@ static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate
 	return 0;
 }
 
-static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+static inline void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
diff --git a/mm/internal.h b/mm/internal.h
index f26423de4ca2..9d3196f9d19e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -23,13 +23,6 @@
 #include "vma.h"
 
 struct folio_batch;
-struct hstate;
-
-struct huge_bootmem_page {
-	struct list_head list;
-	struct hstate *hstate;
-	unsigned long flags;
-};
 
 /* mm/workingset.c */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
-- 
2.54.0


