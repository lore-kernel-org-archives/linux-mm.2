Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953D3CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25538E000C; Fri, 26 Sep 2025 05:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5868E0001; Fri, 26 Sep 2025 05:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D769D8E000C; Fri, 26 Sep 2025 05:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFAFB8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:34:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B4431A05FE
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:14 +0000 (UTC)
X-FDA: 83930890428.17.A622C92
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id B3BCB8000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a5rc22bU;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZMgKn0wKQ/oqMfqx0uxt+uUc993BOebahb39/puGXY=;
	b=T3SQ20xS0AiYEYVnOySVD09PFX9FuNX7hLw7Lpe8jQB9a8OAC0cfI+oNYDbhDD9Pu/qXuT
	KMdnNg3qH+kPpbZcEnpgUv7Nl4L5mGyKbA8PgMKKusPNvOUd6IlGN22WYPLm1M5TeWjbxK
	8kMk685N3vGmG2EzcOTRx8vO46JqOY0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a5rc22bU;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879252; a=rsa-sha256;
	cv=none;
	b=kmgEmdAUwNSYZy8DW7tR100t7lvsVZpTNoOfNpcEBHqExJD/VjyhHqnsHJuEWqu0wsXRhf
	OvczftYAhbO0x4+gWjusO4sv4qSP2ptyxclZ83wxPLzpxs3Y4RLdzAsJznqzL4tZyJ5PZU
	KocpZRjxKngArJZ4gmeeoK57a/2mgjc=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b57d93ae3b0so598213a12.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879251; x=1759484051; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZMgKn0wKQ/oqMfqx0uxt+uUc993BOebahb39/puGXY=;
        b=a5rc22bUbo5bH205vSY6FtcNT4y1WPwqs03fBhIYmcyw4hCY4SMZyn90uXNqwRhhD5
         +/rOVN3Ikr23mw+Ij/w9HUC7LkBDACyqzhZoQGdHLRKlIUzk7BiKs0kwC+4c06wsfo1m
         QANGr8614l/oF2kfw7/NF8iaXIBss+qhqUCWYEkRTGcQ2di+yQUPWggGN+vatzO5CbeY
         WKMN8w1YDsvx5npuojFMH/cBf+Q4RRowqFU4U04YPjWoY7wsvkRNFMCmopQhj4aQIo17
         1kMVwOpF8fAtZVDdtt5eyDJ8YE+4oRuNEVkTSDl/EDGf8iHeU0LlZFoQ5EM+5/pXUTmV
         XZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879251; x=1759484051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yZMgKn0wKQ/oqMfqx0uxt+uUc993BOebahb39/puGXY=;
        b=Qtfp5SC2qzam+8hOmRNgL58sqXjAIKVJ0IFfUBucKq9SmIsDlnodsVZKjYqHEDoWnN
         d6p+z3EEJzQZYxY2lOl6nysH/glGcAbkABpGApQ+Zvcv+f+zQ9XGnOtXJY2B7UUQB0Fd
         HKqnzD9MY1+NG7NxXy9GDGvJc2yg67aZideqnuoH6R5k1Kr0Cez1TJ/pcEd+4rTF97Ii
         YbnHCISsYFYCooE9XOnHHh5hXY9R8LeB/SGXVvhlbtgtZH4lxEYfqqfSCvcQJoJIbHfe
         KVLuBCqvKuXmFmBHZmzKT3SC8l2bJWMxMj9D7OgpIpOR3aABa48bLIWxwR9UWwO1kyCy
         kWBA==
X-Forwarded-Encrypted: i=1; AJvYcCUtWqeWYhwyuUt49ntVtEaF7UAtS8LzFMK5+BgIwD0EmgvOKzAYxLHRqZzbcQyF8MTgkBTyI0SO4Q==@kvack.org
X-Gm-Message-State: AOJu0YwABC2QHKL6jF5Q3G9BaZGp48rC5ascghYN/HaSotswBjHARy5i
	anIi633mgdyA1ab8QT/JqL1rnMXjBv2RzkZail48s+3NYRK9Mk9zViWQ
X-Gm-Gg: ASbGncvuNouVdUSj6NXYz20p6WHcNV530CwTdq0FmeXtbpQsq12RUWVp0vgag6dPTz5
	4VR6032CBwJzUmHy8ZbpxsdAbBvuxwjiMyyHhWM0TUygCQWD/JXv4SNe++a9bum7vOguS2RrfzD
	EFeVic18SVuUbtCLG6up5yfM5utSy1NqS94DfSgyhj2xi+S/M6tbwnvSr0UTw4PwX2ivHG7I9M8
	ls3mToghrEfGpTo9AQvTcUDgUVmgTiZtnLASRrYr4XDpl9xyZK3yVxWaaFdUMtMO4RBXfIBusgE
	wQpC++yu4Aw0EZvrhTj9Rtrw4aj8es/myMlTaCYayIZD1jReYmo7tLpsE7KmIn/s/V9YKAwvNi5
	b3vTnL+CBVRq5zOTgvpUU9SPhNNVwkndx5fH0i2fpM6vvBNqDEgAkYc4QBsY95xNXR084CwQIma
	YSndLH0q7fkKKT
X-Google-Smtp-Source: AGHT+IE8m06qLCI0fDHhVvccWM4X7VzASHCAmPvCMmQy9qW9LwLNoLvpBo8EtHPcpGLM28ZdNvKrWw==
X-Received: by 2002:a17:903:b06:b0:276:d3e:6844 with SMTP id d9443c01a7336-27ed4a7e7d9mr64071655ad.33.1758879251420;
        Fri, 26 Sep 2025 02:34:11 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.34.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:34:10 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Yang Shi <shy828301@gmail.com>
Subject: [PATCH v8 mm-new 02/12] mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
Date: Fri, 26 Sep 2025 17:33:33 +0800
Message-Id: <20250926093343.1000-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B3BCB8000B
X-Stat-Signature: d3zb95gcui4hjhd4b1gxdfymukhtc4o5
X-HE-Tag: 1758879252-361298
X-HE-Meta: U2FsdGVkX1+sg62CHC3fGGlZW4TR+DgKk/Bv8zW16LR41Ehr5/GsGhB2+UnOusZIbqjan34YBajIQnp2Rz54yf5Jgkv6sIS5Sdp1PmCeiEhGemiHqyYeU9AaYGDHNr1kxnJYh3+cXNwJJj6I8sptAsSl26bvmL3o/TDbtfuerefwO1kKOQCivKtwVfU9yJZMOBM13ojasKKQ7yFSLcqlHQNT13TyaNvfE/PxxQuSY9aF7EM4OPXUc4KUupANKGmxmTEoP/jvT2GOLiZ3Kik5mU9/ldU28DWZiENzR0TrYV+U4S9X+7OxLUQzQarcw3/nnBtEtIIzHdEQhUg31+C1HRzQ1A3ADrORnpQnl7kJx83YiONON/Z/8V8Lo6hDcJRRkaZ6fdp7tF41ojahrZKm/O3ke5W2YItPm7t3zKNksu6+Y6hgS3nQKUx+GsyoCPHzslI4ScncuiSflEH3bbz0MGP2Kt08faLtv0DxpsZp5O1cXMNkNCnsXJ1YQ2j9Ndlvrzz27KxsZ+vWSL6LMskbxcHF3+8IzRItFi/VM/H1r/uM/T1KZUuGAJ4DbVMt7ywCH/YBvb4S2emLNiD9uA0xchSXy7RudBaygMN8LOyyiW448i4MByYkLUFXoI1ojMNVJj4FGvXJ0DYbA8vcs/tlNQnPYygvEeskO+MAPzsaWfQ9nt2Ge5KEwfoNjTfkdWQBwS0iVIX30FBuqpUwPd/l+0eYiXrNab5A/8WUrCh3dv5otAhTSDAg0GjZwiHUzPASJb+JjTJpSgV1V/YfljTlliIGGxVNuk5zxXaN04dcbsrBjNDW3QY6H0FhCp6uQF3SQ3xJhJ5zRglobYPvhDgpp2etmJd60a6gGWhf89QR4RzTz5rSRSsN9aENoIFryTur4W4Xo4cKmZDeCvchf4ZtJdMuNb6afUdJLzqn/SWqS0OY99UNfnduPyuYzlTQjCEevS+0mvIZRPPmZKbfAzU
 RTqzJcUM
 ixZam/VqSS5ipki8/kuS2yB8+GbqZWOXcW8fo+Emg9B0OxpKlnkcf/eH4f/vgIDjuydw0+vWq1uS18YieVfNoIPw06m9eLrGDuAOc0eF3xOJLtM7mmoz1JKNtLWd5gTJnFyQW/YealwBe+GDP9oOPnh6DDda3pgkWHIc325Lc/39UuDquD4aN8hyvl5kpNwFl9AZLraspOij6SPIdlSwVF638UnAYcmvjZrExkqJ7gUjIWkGcxhvBhbSmVrOIb9YBvg9FF2qzVCtB8SBpw/3RIc5ZmPUuZCDgGcBoC73SJy3JOdqrF9eWypHPlLv2wuPYnAO10mK4jUTlPmEBa1H9i3x7vImuy2bJXL96Zl1nkiGylcsllkWW9i9Vaxe2L1LGLJxFGSSjU/b/H3a2EmPoR/F7IX3fMczD8ttjBad3i1O0gApLuDSdfXgtRG+vDZaPMOFl7S4EyB6YBIQM1F31TshB5In4m8V1jtzv0rfvvV96nSa5oO5OmLdjfISCIW8GB4OC4/mLggTzKYERyCvlmsBIQTYfbhNtG1S6YgbbFX/SPPwCXA/SHLU5QTZ8xYJ/X3M3YCgstunEoBCah3lXVIZQLXBiPEVQfQOt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The khugepaged_enter_vma() function requires handling in two specific
scenarios:
1. New VMA creation
  When a new VMA is created, if vma->vm_mm is not present in
  khugepaged_mm_slot, it must be added. In this case,
  khugepaged_enter_vma() is called after vma->vm_flags have been set,
  allowing direct use of the VMA's flags.
2. VMA flag modification
  When vma->vm_flags are modified (particularly when VM_HUGEPAGE is set),
  the system must recheck whether to add vma->vm_mm to khugepaged_mm_slot.
  Currently, khugepaged_enter_vma() is called before the flag update, so
  the call must be relocated to occur after vma->vm_flags have been set.

Additionally, khugepaged_enter_vma() is invoked in other contexts, such as
during VMA merging. However, these calls are unnecessary because the
existing VMA already ensures that vma->vm_mm is registered in
khugepaged_mm_slot. While removing these redundant calls represents a
potential optimization, that change should be addressed separately.
Because VMA merging only occurs when the vm_flags of both VMAs are
identical (excluding special flags like VM_SOFTDIRTY), we can safely use
target->vm_flags instead.

After this change, we can further remove vm_flags parameter from
thp_vma_allowable_order(). That will be handled in a followup patch.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
---
 include/linux/khugepaged.h |  6 ++----
 mm/huge_memory.c           |  2 +-
 mm/khugepaged.c            | 11 ++---------
 mm/madvise.c               |  7 +++++++
 mm/vma.c                   |  6 +++---
 5 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index f14680cd9854..b30814d3d665 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -13,8 +13,7 @@ extern void khugepaged_destroy(void);
 extern int start_stop_khugepaged(void);
 extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern void khugepaged_enter_vma(struct vm_area_struct *vma,
-				 vm_flags_t vm_flags);
+extern void khugepaged_enter_vma(struct vm_area_struct *vma);
 extern void khugepaged_enter_mm(struct mm_struct *mm);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
@@ -39,8 +38,7 @@ static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
-					vm_flags_t vm_flags)
+static inline void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
 }
 static inline void khugepaged_enter_mm(struct mm_struct *mm)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225..ac6601f30e65 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1346,7 +1346,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f47ac8c19447..04121ae7d18d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -353,12 +353,6 @@ int hugepage_madvise(struct vm_area_struct *vma,
 #endif
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
-		/*
-		 * If the vma become good for khugepaged to scan,
-		 * register it here without waiting a page fault that
-		 * may not happen any time soon.
-		 */
-		khugepaged_enter_vma(vma, *vm_flags);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
@@ -467,10 +461,9 @@ void khugepaged_enter_mm(struct mm_struct *mm)
 	__khugepaged_enter(mm);
 }
 
-void khugepaged_enter_vma(struct vm_area_struct *vma,
-			  vm_flags_t vm_flags)
+void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
-	if (!thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
 		return;
 
 	khugepaged_enter_mm(vma->vm_mm);
diff --git a/mm/madvise.c b/mm/madvise.c
index 35ed4ab0d7c5..ab8b5d47badb 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1425,6 +1425,13 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	VM_WARN_ON_ONCE(madv_behavior->lock_mode != MADVISE_MMAP_WRITE_LOCK);
 
 	error = madvise_update_vma(new_flags, madv_behavior);
+	/*
+	 * If the vma become good for khugepaged to scan,
+	 * register it here without waiting a page fault that
+	 * may not happen any time soon.
+	 */
+	if (!error && new_flags & VM_HUGEPAGE)
+		khugepaged_enter_mm(vma->vm_mm);
 out:
 	/*
 	 * madvise() returns EAGAIN if kernel resources, such as
diff --git a/mm/vma.c b/mm/vma.c
index a1ec405bda25..6a548b0d64cd 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -973,7 +973,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (err || commit_merge(vmg))
 		goto abort;
 
-	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+	khugepaged_enter_vma(vmg->target);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
 
@@ -1093,7 +1093,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	 * following VMA if we have VMAs on both sides.
 	 */
 	if (vmg->target && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+		khugepaged_enter_vma(vmg->target);
 		vmg->state = VMA_MERGE_SUCCESS;
 		return vmg->target;
 	}
@@ -2520,7 +2520,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 	 * call covers the non-merge case.
 	 */
 	if (!vma_is_anonymous(vma))
-		khugepaged_enter_vma(vma, map->vm_flags);
+		khugepaged_enter_vma(vma);
 	*vmap = vma;
 	return 0;
 
-- 
2.47.3


