Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC37DC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942378E0005; Thu, 31 Jul 2025 08:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F31C8E0001; Thu, 31 Jul 2025 08:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D138E0005; Thu, 31 Jul 2025 08:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AEFD8E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:28:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D70C1DC053
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:36 +0000 (UTC)
X-FDA: 83724488232.26.AEA6B79
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4962818000A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bSrzTL7i;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVGPh02pmLJrHp5VeDMRa3cXERDmLuGimyItCvJL/y4=;
	b=2DJ/FNyRyI0qylIHcg6oaJq/NZwb/m3tCT5bFKUj5UBm7ub5xX2f2ySuUgvnpBl+XCyTSB
	J16o/hBCAojmdc3yq7kC/9UIy4IET3asFxuTqmH1Vh0yccWuOtjm+yAbBAUk0DtP5PU0rn
	xQvrsg3q6A81gzhbwf3Cs2N7Kn/RjTM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bSrzTL7i;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964914; a=rsa-sha256;
	cv=none;
	b=PnDuxkJ/Lka7LwE3gQ0dY8EHLO4NjUbPxiMLbPOGTpmYLhwGmLwSpi+L/P3738YC2KeRak
	XcPh1x1mt8Xgdiz2f87hN2sxoYMLoKJLiAdmupbZH6KDnn+1Yi9PycRqaZhhONFZeoy2+U
	wkJ87m4GaWvM4zGuuqFUMNIGX7JFfoQ=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ab8e2c85d7so4140191cf.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964913; x=1754569713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVGPh02pmLJrHp5VeDMRa3cXERDmLuGimyItCvJL/y4=;
        b=bSrzTL7iH4QnEGNZHnuNH3XruuU9wYlqUogqv3Gz9ArVpTWVcbSI7EAJlpJVWbwDih
         2w1vHkJnDBoWuOcI6fV0GWbOEBemRUqGrIkfF691fO5/cbtS1kNL5xAnw2K/O6lgz0JO
         aMDP97iB8J0q1B3ZBCwVqmGvuRCu/UDZfxgZ3AY0FyA47WMTpwfuUUT5V+hUSt+8SMU3
         n7nXY5NugMJ2UCvAQySJlht3Aw/VBaqrudvl11XM3nmDJkF9v2iejyqKWYAA1YI46ejw
         r8Zf6IAFYS0P8i/AjXvQ6o01VyBbmjtkPRGNvuaL93N5+LiwqIvxY/leByeSXY4irKt9
         +JUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964913; x=1754569713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVGPh02pmLJrHp5VeDMRa3cXERDmLuGimyItCvJL/y4=;
        b=DvU8qYuagW0Moxw1f4lJ0ymhQke0Ft+wy9YWr/PDv2iEE5KebOTT7IjNrUf1gVL0Yz
         AbPzLakI6q8FyAChBvx1kF275ZAH0nvhUgZCPltZxXhHInWLg/nOevZfN9dNMGI1Ryzc
         yIjAzg8AsnM+M9cv06weIJanxCZ81r1xYWlsAoOyVjxR6SdQu8P1g/R5ZIfO7y2ACTIT
         pQHWg/5+Z+Fpafks3nGuqSgH/a467ktNDFhmuTUUYuxSom6iKw8huZH8VSxKeNUem9P3
         wiXBnOGf7lmCziYOY7/Gnok/SAVBGofIreK7eBo1DFyd3R7rOHmKRvqgB7/uS5Y/f9FG
         /zxg==
X-Forwarded-Encrypted: i=1; AJvYcCWsr6t5PaKJ9kJl/uZRARN3mb5F2pgXv/PtdwiIh46VrcHmaf17VM64FZuMdce4fEAp6ybOywWEiQ==@kvack.org
X-Gm-Message-State: AOJu0YzWADnx1yEF8dEf80ECNeXp/JxuPjK+Mbcbub/n72GvyVgt4uws
	Dh47PTLZ7ES36FT4mkGaBRtITmaB31LR/Fg8nFmY+Nx3LlqQGJpLjSTF
X-Gm-Gg: ASbGncvHvhjO+hK6bjA2P8VCdlB9pDQcUuFmSuesbjATwjwW2Xm+36+ZzpmTFTA8za4
	xcAuF2qOHKrzMrkv/SYz386bhharCJu68Z3OON1x14OsZx+P38UOM9gN3Vqzd1wxZ72wcLpu1oz
	s1+Q1JsO3JHlUZ8XfGTyl2IRNWSsXV9ZX2M/kubtQnQwlP4YePTnpd7ySoHEa7DhK3w4dCPk29Z
	fSrYD0U2lSwdY2kjHYdRTlBvHhq2+23FVeF0wgTN54QeIrNa+d0gPOfdmezTykCk2g675LAdCO1
	FJIT9ZF45HI3Ml74SC3ZYK84vfBVUsmUqqr+RrRhGT3nonx2SqwHbccshMTo4zPzt1n0zXQLdyK
	5Jz+WPyN4gnGFOm2yC7Z/s/ibTZF3deZVVVjBIMUk
X-Google-Smtp-Source: AGHT+IGuKJdAvwjbdBZ1j3ZwGMuIpVw4ZVBxyR5tHg/Pre4/7L/XxQht4x0Inx8zUKLN64ENADXlyQ==
X-Received: by 2002:ac8:5a8f:0:b0:4ab:825d:60d6 with SMTP id d75a77b69052e-4aedb9ab5e6mr101508271cf.8.1753964913180;
        Thu, 31 Jul 2025 05:28:33 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:5::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeebde8c0sm7794781cf.2.2025.07.31.05.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:28:32 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v2 2/5] mm/huge_memory: convert "tva_flags" to "enum tva_type" for thp_vma_allowable_order*()
Date: Thu, 31 Jul 2025 13:27:19 +0100
Message-ID: <20250731122825.2102184-3-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250731122825.2102184-1-usamaarif642@gmail.com>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jqf39mhu3s4r3opafdent7ryuk9nhb67
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4962818000A
X-Rspam-User: 
X-HE-Tag: 1753964914-387705
X-HE-Meta: U2FsdGVkX189IxM7ztQWQgTUQ69/Dr8UWtqFPb1kLRNRF6/UX8lj0UI1pB0Qwozrqv4+iCCDUntgg5xJnc4QdSDCur8OVOTxt8r/ClWjYBPZDOu3dDUGTbNuLqBaED2coyp9TS7UFJsh+tA+HoookDzCiRSwC7p33aoAgt/K5h3/prhtupB1FTxqZZPzYgCfU5+RFvP8KEO3KtLYv9caRxU8j1kin8dXMDqbvCkzp42ur35ZkSe049Iga+t7iSMwT41/qAr4w2/NuOb2ZYInUuuMaKdYXiHGy7/iOcJKJGChjxXyVuVyUVYfwNbohHhug1Mb9N4xdCBGqLdn1f0jtg3ntVVb6nUFysbFxhI6+SpyJGG+AktjqTntk163rP3CwfRJzrWApXQiutIGNu+sQlMMWzILXPaGvlVOr9d/lyle86CB0mDCLy9OcYLyTtJMRsZKZRalbWDPBM2IpGYbt/e4I8hqAXGxaLuNR4biay3If7m37x8hk+yo4n1ccIDRHPneq2l/MDmIkK/lqYdmD8d0kfZ1Ar32q2X3hK/2KI7zxmYn8HtCQxglWT0GUblUWvWQ3RKW9tnn7YaaCsH5M5yyGrXSj37ITb2FPCHE0xsmcXpYLpv+DKwUzvZfDMFuKQEeVZoePD3m9IeLIE9HOi5wDjjCArs9gbctAyZjfkptihaIxWKFbyffZkrai1/pog75xh385JhpQWO0BqTU22vTTpvSCaMWBWbOV/K+2uBPo1Q0l2NjDn4HsHDbQ2BKpKMvP0Txi+JzzeggBeNGBWpwysRmGIAj+Ju6r1qxE/aP14/P+rxcZpaMZ2EPdZ9uyLoA4bmS6qP5g9WYnupVR+4Hs/bJOinoVk02/wiOpV8Fmh0psU+IlVft8fr9aR61e7F1rkfUJ6ZanoEI8W/jtjy216bwhvIYoGHxmgBQxQJ+DifJltjHeybXICO6Yx1FnQBnOLuaAxpRMMoYQzr
 Yt6JmfLt
 d45L/e/wusUI/LiAEUzi7Y1VHy6O/hQTDPaT/efu0ijKQB3XTRJHjr0ojEMnkHKQaHJltVdXvj2bg+twagsrNvaf46pUYWIpZrHZpB/mn2359aJ3mnOS6cZPNd5NfczcgEiWBVRzur5y9DKtLWsxyQKt/dh1W+y7anqhlckVoZY1qB1N+c18z3sSrZLHuNWsiSSCVn6aCiyxX8kPDedwSYWHZkw5If3XIV8CwtrG/J9gckK2u3poV1nA8lUZaAm9DUMoZwlWaY7e/ibGb2qijCOXoAP7JT83klnqRcSonOBrH1SELLivPFdthBNe1uYFH+sbUyBtg2O+/etRkQIcnmwx+RS1TPNvg1AguBtIsT0c21v7dcD+izgVzDCfBL4X/33EgKlTwv8Jq1+UBtsXzNQcNOLdEAy1L5vK+FqgDNPHgOMishjxo2D1tIzMJ9RJb9ELirFwDHZfpL3GQxSjJt8JkEJjCiictOW3i/bzNK0uSklZyLytINpGxl6WLdpjUpdJQer6Xg9pbpwZ+0E6JBjKzQx+ZnH0ae/gChguD3UMfFb0SLwlZmjucjCa+L6l5f/j5DFhclBMTWhnQ6yMcUsnD7LTyBSR7ezFl3iXQKFJv2S+xMVvQ8IuxEJzEncYmRS8tUk51j5zVLKJIJZ54GaaqLZd2apoQ4lhv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

Describing the context through a type is much clearer, and good enough
for our case.

We have:
* smaps handling for showing "THPeligible"
* Pagefault handling
* khugepaged handling
* Forced collapse handling: primarily MADV_COLLAPSE, but one other odd case

Really, we want to ignore sysfs only when we are forcing a collapse
through MADV_COLLAPSE, otherwise we want to enforce.

With this change, we immediately know if we are in the forced collapse
case, which will be valuable next.

Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 fs/proc/task_mmu.c      |  4 ++--
 include/linux/huge_mm.h | 30 ++++++++++++++++++------------
 mm/huge_memory.c        |  8 ++++----
 mm/khugepaged.c         | 18 +++++++++---------
 mm/memory.c             | 14 ++++++--------
 5 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3d6d8a9f13fc..d440df7b3d59 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1293,8 +1293,8 @@ static int show_smap(struct seq_file *m, void *v)
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %8u\n",
-		   !!thp_vma_allowable_orders(vma, vma->vm_flags,
-			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL));
+		   !!thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SMAPS,
+					      THP_ORDERS_ALL));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 71db243a002e..b0ff54eee81c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -94,12 +94,15 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 #define THP_ORDERS_ALL	\
 	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
 
-#define TVA_SMAPS		(1 << 0)	/* Will be used for procfs */
-#define TVA_IN_PF		(1 << 1)	/* Page fault handler */
-#define TVA_ENFORCE_SYSFS	(1 << 2)	/* Obey sysfs configuration */
+enum tva_type {
+	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
+	TVA_PAGEFAULT,		/* Serving a page fault. */
+	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
+	TVA_FORCED_COLLAPSE,	/* Forced collapse (i.e., MADV_COLLAPSE). */
+};
 
-#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
-	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
+#define thp_vma_allowable_order(vma, vm_flags, type, order) \
+	(!!thp_vma_allowable_orders(vma, vm_flags, type, BIT(order)))
 
 #define split_folio(f) split_folio_to_list(f, NULL)
 
@@ -264,14 +267,14 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
-					 unsigned long tva_flags,
+					 enum tva_type type,
 					 unsigned long orders);
 
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
  * @vm_flags: use these vm_flags instead of vma->vm_flags
- * @tva_flags: Which TVA flags to honour
+ * @type: TVA type
  * @orders: bitfield of all orders to consider
  *
  * Calculates the intersection of the requested hugepage orders and the allowed
@@ -285,11 +288,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 static inline
 unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 				       vm_flags_t vm_flags,
-				       unsigned long tva_flags,
+				       enum tva_type type,
 				       unsigned long orders)
 {
-	/* Optimization to check if required orders are enabled early. */
-	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
+	/*
+	 * Optimization to check if required orders are enabled early. Only
+	 * forced collapse ignores sysfs configs.
+	 */
+	if (type != TVA_FORCED_COLLAPSE && vma_is_anonymous(vma)) {
 		unsigned long mask = READ_ONCE(huge_anon_orders_always);
 
 		if (vm_flags & VM_HUGEPAGE)
@@ -303,7 +309,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+	return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
 }
 
 struct thpsize {
@@ -536,7 +542,7 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 					vm_flags_t vm_flags,
-					unsigned long tva_flags,
+					enum tva_type type,
 					unsigned long orders)
 {
 	return 0;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..85252b468f80 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -99,12 +99,12 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
-					 unsigned long tva_flags,
+					 enum tva_type type,
 					 unsigned long orders)
 {
-	bool smaps = tva_flags & TVA_SMAPS;
-	bool in_pf = tva_flags & TVA_IN_PF;
-	bool enforce_sysfs = tva_flags & TVA_ENFORCE_SYSFS;
+	const bool smaps = type == TVA_SMAPS;
+	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
 
 	/* Check the intersection of requested and supported orders. */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2c9008246785..7a54b6f2a346 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -474,8 +474,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
-					    PMD_ORDER))
+		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -921,7 +920,8 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 				   struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
-	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
+	enum tva_type tva_type = cc->is_khugepaged ? TVA_KHUGEPAGED :
+				 TVA_FORCED_COLLAPSE;
 
 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1532,9 +1532,10 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * in the page cache with a single hugepage. If a mm were to fault-in
 	 * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
-	 * analogously elide sysfs THP settings here.
+	 * analogously elide sysfs THP settings here and pretend we are
+	 * collapsing.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2431,8 +2432,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2766,7 +2766,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
diff --git a/mm/memory.c b/mm/memory.c
index 92fd18a5d8d1..be761753f240 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4369,8 +4369,8 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
 					  vmf->address, orders);
@@ -4917,8 +4917,8 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	 * for this vma. Then filter out the orders that can't be allocated over
 	 * the faulting address and still be fully contained in the vma.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
 	if (!orders)
@@ -6108,8 +6108,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 retry_pud:
 	if (pud_none(*vmf.pud) &&
-	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PUD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -6143,8 +6142,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		goto retry_pud;
 
 	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
-- 
2.47.3


