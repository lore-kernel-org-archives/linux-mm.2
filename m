Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66567CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0688E0039; Wed, 15 Oct 2025 10:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22F88E000A; Wed, 15 Oct 2025 10:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99CCA8E0039; Wed, 15 Oct 2025 10:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 830308E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:17:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23713160113
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:17:51 +0000 (UTC)
X-FDA: 84000552342.12.A9F2E8A
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 63DF4140010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:17:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BFzTLiZc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vy5v9XGDeS4JIoi1WBeevI4rwn9UOnGGFWMHMux6eVM=;
	b=U6BuTWdlz0CTtREHV60UEnNClC7s/sP5ihU7spyUsKbC/7oL2jvDE5p53vRlcF1bdlgvL3
	rGITKFFVeb6VHPEUFQLAFimfmdVmhRbkpFo1KLnyJzDM0o8DeQQGstzWyiinmSgbVKbiT3
	47sLmgDeDXdNILWka5yElUGrkLLUUOo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BFzTLiZc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537869; a=rsa-sha256;
	cv=none;
	b=Kt3hMykoO2wKmc/7u6605hQdzhnVWdy5fIYKXgvk5caeXflCFqdzu6dKTjksyIM91E+Fg+
	jPRaf/KmG5CEwuww1H0adi4l7Je4vRbEW2sn/GLQSgUtfD6YecbBac7IwMxobDvOpqwnqU
	nUPcu4hV/ssN24t/6JBm6h3dKKKc17s=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-781db5068b8so5278024b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537868; x=1761142668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vy5v9XGDeS4JIoi1WBeevI4rwn9UOnGGFWMHMux6eVM=;
        b=BFzTLiZc3+yIsM8J/GqFbj+EAwQC2RFdjGYCyAMHTfOAduuLCqzGuKcJReCB/8LFS0
         GQX0TGPJVcMCsx2QROtVexBe0Bb9LbG3IDUnr8BQtrHmPhntDkwJIgRt3bsog7oDEfzU
         paxavq9wOn3i4izEdQANsZz/VCdNzHBuEK3zu+G1UNKjUnuyLcgnBIx2r9pmyllJf9U2
         ZxFbg0PYVib51H3TzSCUJuhGhRwABgEUnYV8PP8xjeYtd2DvXcTefnKzaflLv6R4UpPH
         ZK3V2/zECfvEL8kQ7jLTnYHMt4uqXaxgUfdXxfXdELJNbl6oIvDw+kbHxuz9zXzlJ195
         oVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537868; x=1761142668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vy5v9XGDeS4JIoi1WBeevI4rwn9UOnGGFWMHMux6eVM=;
        b=k7Ro52/INJwr7N/r07HcItjVWijOXTL+wcFU6Q5gKpg00VJQRn64ZJYtPRBVdjO/4E
         6GcicIA2mLzvLlqvn4nSPSEE/rbFA13N9UUstNWtZmSCmzwA5UUoDzllvu+7SBe40RwR
         UJTEvi2Mt4kw3Ge3wsGDXLU1Y+dRWvZ34U7treRMAV/X/YPK2F6we+3gT2MQNI4SkRtR
         oNBLRlnxQgvxAJiXXt/6S/d1+TxdJ6LV1RdYdMWLV6Rm65/6/Ief49kGGRKvkxsyeM18
         geJoKng8lYbIUtq/ZT6z5URZIzItkefTAgmU9ExTO0BojoLfqmEha+V/Ovq3bWxXljgR
         d7YA==
X-Forwarded-Encrypted: i=1; AJvYcCWUXrIRSdfkmX5L1Vg+TQLY7sd9VjuoIALUVm/t9t1V97min8MRBxCHv9tOnBU+/mNJP9mjIy3+ag==@kvack.org
X-Gm-Message-State: AOJu0YwVm531EypTRkNAtWE4HHwCghrBj3wIv7odmjBxnPmbiitZDmgt
	IXzgHaXUUfCDhKjT7Zr2dNxONe0yc+peVcOlOkYCsZPHJoa7wxPd3xuQp54i0Wz9
X-Gm-Gg: ASbGncsZwEU8I4t0ff+/VQ6MS20TfYepWNGyWBT+l7ZEP4mzVfd4YwgDbpZ9qqrhN8J
	b2cYrTNcUoR+KQbk8pTzNTIrtoMux+3YOx+3DfZeEDZ25XDt5pIAJNgMXnFEyXO61Fs9ZFhft07
	l07I6JkoeMRM5hVgLm8uRzvrTbcJj1cdT+l/1gRC+BFIzi6NvZiXf5LeofPBCjlnYpqAqxG6JD4
	U379opHE52E0fjs7Z0qhR8g959f4mIvi2TmqM+DsSeEN8JQ6mFKzfQLv/wU1Koq5NX7R7vEBmxK
	CZBuNsUvkfu7tXMu3anm36ehnp/t5eJPUZd2aTUOxfaGbKDPvumoMBmQz1XcbWrToywKaWyQ4Rh
	Aba0JyiygvSUZ+q02cl+o2UFlvix897CxTo2xhNSeCqsaGru4KE4/yw25JwV1T/Yy3Z9MHontI2
	QmWtrFwwSuPzeJq1EbK8M5DBekJDdYxk0RRg/EpkV4yKmZSVaqpWI=
X-Google-Smtp-Source: AGHT+IE4aDUQVPtLHGnbHLnFA18ywMHTFWJFVJOIoyE0GV+0uMGDRn+Q8e6beTOkXj50I7QjYtAYug==
X-Received: by 2002:a17:903:17cf:b0:24c:b39f:baaa with SMTP id d9443c01a7336-290272e1fe5mr391867325ad.49.1760537867798;
        Wed, 15 Oct 2025 07:17:47 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.17.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:17:47 -0700 (PDT)
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
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v10 mm-new 2/9] mm: thp: remove vm_flags parameter from thp_vma_allowable_order()
Date: Wed, 15 Oct 2025 22:17:09 +0800
Message-Id: <20251015141716.887-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251015141716.887-1-laoar.shao@gmail.com>
References: <20251015141716.887-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 63DF4140010
X-Rspamd-Server: rspam03
X-Stat-Signature: n7ji87nnhunj78u53e3sy3nhxf3hq4pc
X-HE-Tag: 1760537869-317479
X-HE-Meta: U2FsdGVkX1++9rilLHlb9qJ3GqY/Gf+9CRaA/Z52kPGXqG6oDlytjQZDDmc+OjSBLbWslzWvwCpYARLlt53ID+z6jb97HOiq/DoLcvmyTvhl3njLFI0+f+Rxg4KfOniJiQAD38u2P7KIgWwkAGv/9V5hfuJ5SLNsRqrrn1jZs2lJRxBoeLZ0WDl6jJnppVb3khGU7GJHhKzJZwuV8lvA8hfDxLFRz/9hQlha7/3T7oRaYGH4mzLepm2iQmN0iSTWoTexryeVctkUXsC1sc0fomeOy/jxhOyzgoSZLWoqNNu4DW+5LeEXy/YRFwAWcmKbSuK6MOIaCJraV/W1FJtesiKNAng4KANSs8c0uZ8ayPb3AzEE5or29/tm903au2NHx8Chknt+9A49fzqkkxQoM0sM1VQE2CVz/OyxkBfS1cODvBP1n7+l9RdsOQMb+2G/1Ayli0ST2O1drHxuKAJXekA4+EcTxdqET19aw7Dfx+QZzFhpmTQ8WtMitW7uImmbkSxVnRkJHmW5zZY8YRnnP7kAUkzsjinV4pz5cryZIWbnL2ExsE4BhwG5z0a+mdW3LosOFWbdo1LkyMyEmdPh0hoEEZOIK8IAUC0lsDWhMQSSn6AIXXwMswsYNgJd712tmep8O7iIMMRojQRZwEQxmtWKujPSTYVr+hAJpMPL3pIQieZl/W7O3uv1l8vt+qXdV7w7P/RyMwGFBSCQvGEHAwMNQ4N4QfqIYu8wXzmGaGeGsuUsL8K0SQGseCygdCfcNdkkuzys9qzv/lO1NpjHXviHKAy8v/l3ieuobV2qYcGGLFa7C8kTqdpxn4qF6k299HuhPhKrDfPP1QAQWZgYVNFuKpKq0/3zk+L6UrUW3JTGhhggqVMoFArBz43G7qLc0t73usTPkasqzsDPrjT99Iw6nikf6y1K95nbj2djjIzTKjESvtOBOS8/9D3mcaRJMEIh2XZjkLH6Wfs1u51
 fy5mbAJc
 zWbw9aiaKrdlj+Mc+LONMDH/MP9h94wVU8xVIuJRBVIFlht5KyPE5mp9EezsD1e58jj+NGSU/RT3DJ1cFEgDW/itOoQjvv5uAcCRPNZLBM2otNbQMyVDtmwJ5Hk8IjRWCmp5F0emWdxHzZSyZZpxMpMLYg4SGFNwxujmNkUXouqKQfZrnesRDtj0SdAAzfJ0ucuQVNJt7d7JCzFZ5Vl6RB0TzIU/5kVGLnzysDgP2fW1Qucs0OWlvKsrq5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because all calls to thp_vma_allowable_order() pass vma->vm_flags as the
vma_flags argument, we can remove the parameter and have the function
access vma->vm_flags directly.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
---
 fs/proc/task_mmu.c      |  3 +--
 include/linux/huge_mm.h | 16 ++++++++--------
 mm/huge_memory.c        |  4 ++--
 mm/khugepaged.c         | 10 +++++-----
 mm/memory.c             | 11 +++++------
 mm/shmem.c              |  2 +-
 6 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index fc35a0543f01..e713d1905750 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1369,8 +1369,7 @@ static int show_smap(struct seq_file *m, void *v)
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %8u\n",
-		   !!thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SMAPS,
-					      THP_ORDERS_ALL));
+		   !!thp_vma_allowable_orders(vma, TVA_SMAPS, THP_ORDERS_ALL));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f327d62fc985..a635dcbb2b99 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -101,8 +101,8 @@ enum tva_type {
 	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
 };
 
-#define thp_vma_allowable_order(vma, vm_flags, type, order) \
-	(!!thp_vma_allowable_orders(vma, vm_flags, type, BIT(order)))
+#define thp_vma_allowable_order(vma, type, order) \
+	(!!thp_vma_allowable_orders(vma, type, BIT(order)))
 
 #define split_folio(f) split_folio_to_list(f, NULL)
 
@@ -266,14 +266,12 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 }
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
-					 vm_flags_t vm_flags,
 					 enum tva_type type,
 					 unsigned long orders);
 
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
- * @vm_flags: use these vm_flags instead of vma->vm_flags
  * @type: TVA type
  * @orders: bitfield of all orders to consider
  *
@@ -287,10 +285,11 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
  */
 static inline
 unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
-				       vm_flags_t vm_flags,
 				       enum tva_type type,
 				       unsigned long orders)
 {
+	vm_flags_t vm_flags = vma->vm_flags;
+
 	/*
 	 * Optimization to check if required orders are enabled early. Only
 	 * forced collapse ignores sysfs configs.
@@ -309,7 +308,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
+	return __thp_vma_allowable_orders(vma, type, orders);
 }
 
 struct thpsize {
@@ -329,8 +328,10 @@ struct thpsize {
  * through madvise or prctl.
  */
 static inline bool vma_thp_disabled(struct vm_area_struct *vma,
-		vm_flags_t vm_flags, bool forced_collapse)
+				    bool forced_collapse)
 {
+	vm_flags_t vm_flags = vma->vm_flags;
+
 	/* Are THPs disabled for this VMA? */
 	if (vm_flags & VM_NOHUGEPAGE)
 		return true;
@@ -560,7 +561,6 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 }
 
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
-					vm_flags_t vm_flags,
 					enum tva_type type,
 					unsigned long orders)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ac6601f30e65..1ac476fe6dc5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -98,7 +98,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 }
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
-					 vm_flags_t vm_flags,
 					 enum tva_type type,
 					 unsigned long orders)
 {
@@ -106,6 +105,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	const bool in_pf = type == TVA_PAGEFAULT;
 	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
+	vm_flags_t vm_flags = vma->vm_flags;
 
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
@@ -122,7 +122,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5088eedafc35..b60f1856714a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -466,7 +466,7 @@ void khugepaged_enter_mm(struct mm_struct *mm)
 
 void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_KHUGEPAGED, PMD_ORDER))
 		return;
 	khugepaged_enter_mm(vma->vm_mm);
 }
@@ -917,7 +917,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1531,7 +1531,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
 	 * analogously elide sysfs THP settings here and force collapse.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2426,7 +2426,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2757,7 +2757,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
diff --git a/mm/memory.c b/mm/memory.c
index 7e32eb79ba99..cd04e4894725 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4558,7 +4558,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+	orders = thp_vma_allowable_orders(vma, TVA_PAGEFAULT,
 					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
@@ -5107,7 +5107,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	 * for this vma. Then filter out the orders that can't be allocated over
 	 * the faulting address and still be fully contained in the vma.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+	orders = thp_vma_allowable_orders(vma, TVA_PAGEFAULT,
 					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
@@ -5379,7 +5379,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma,
 						     /* forced_collapse=*/ true))
 		return ret;
 
@@ -6280,7 +6280,6 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		.gfp_mask = __get_fault_gfp_mask(vma),
 	};
 	struct mm_struct *mm = vma->vm_mm;
-	vm_flags_t vm_flags = vma->vm_flags;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	vm_fault_t ret;
@@ -6295,7 +6294,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 retry_pud:
 	if (pud_none(*vmf.pud) &&
-	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
+	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -6329,7 +6328,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		goto retry_pud;
 
 	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
+	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
diff --git a/mm/shmem.c b/mm/shmem.c
index 4855eee22731..cc2c90656b66 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1780,7 +1780,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.47.3


