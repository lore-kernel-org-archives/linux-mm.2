Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED77C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2F76B0093; Thu, 31 Jul 2025 08:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194F66B0095; Thu, 31 Jul 2025 08:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00E1C6B0096; Thu, 31 Jul 2025 08:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DEA7B6B0093
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:21:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F3E5160720
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:21:59 +0000 (UTC)
X-FDA: 83724471558.15.1A93EC0
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id BE810180003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:21:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EvWeTnHY;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVGPh02pmLJrHp5VeDMRa3cXERDmLuGimyItCvJL/y4=;
	b=pt8pqkK/CDdfy0vbrbFOQrGqBdsiIDYSARB48jn36fDsHRv8K17IeAveBmwRD8G4+yMw8L
	A+l1oYpMjE+o8kUS/DabA6LCWQ+gqmOJfA6z/kxwc5cVPxRcZoTTCWyNIpf9C3sOFqimV7
	gyrw5g6UnNbnpX/XkpsMS+qtnH/JCQs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EvWeTnHY;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964517; a=rsa-sha256;
	cv=none;
	b=ycjqujrXqrryhXbzV4oDMCk5ANDI57YMn3PuZ/O39R9jIo3+UyK1NtaS6EUwh7s9Y/fh+D
	E8lr3JCDvQGtXH7g1l2+ktr4bwJ8wSkZE3hSRZam5KRJA9Std0YTJzT2YS+VoUI3HKZ2wA
	WJXikr0uxHXDnYkCNMJHStdi1mAr49g=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4aeea691687so8689101cf.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964517; x=1754569317; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVGPh02pmLJrHp5VeDMRa3cXERDmLuGimyItCvJL/y4=;
        b=EvWeTnHYa+YVXiPhwLWrGe9fqtzsruQscDCFDSiL/8VJ+a9uEyDXQV8c45ai8yHOOk
         C+eb3bGNbBGKduiLbVs8g6r8vjDNZuDhDP5uTIjjSQZURuCc1yw3QzfTbqCzO4wqtoOS
         rjshx2n0q2U45iFU07AdfmS11JRY1lIHUDrdXRtLMMIId3f+3O6IOiLKgvTU3hxi8xYu
         l5DEySY7/VBnRajjnVLXSy/PWA/VsZp0l7y0MH2N/xBRCR9bTsbFIeL1Tfh48Eypgp+P
         BkiNvKYPPuuH+3Eo4pJyRuM6XF/vJkGBfowGwF28GLzSOmFsXt2hD+XTNp5Pv0csW8ru
         W1YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964517; x=1754569317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVGPh02pmLJrHp5VeDMRa3cXERDmLuGimyItCvJL/y4=;
        b=mj9+xDPuNNan7Fiw4yUSAFitnvgf+iXBs0RefnN0iiI/L2NNTIqXAhBLU9ajhpzAvu
         zOMC5JOCiduQgnoFk6CwdK5XtuFqBy2v3qLIjJiwNQT99pcU/VGAoLIX1RVFBcJYEEE8
         OmKL4joRfRrvwcPkW0DP9OyWj/LJuz7OyRFfUQJOzUeVUViRFJwT5eTUwSr0p4S+uCMY
         JtNAasfGf0X491/3IOP10ZxNPNxVyxbeOR5IgIzBB2y/YCASMmdrJ3dF6pTD4utw+/mE
         LQKznHGGk93gHlMd+sGzaig9mfDuPUD7cmmSpu+XwhRH+sx5htjWzMjPsefb2Si3QwoX
         3RNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTP5yXVTfUsJKRek3mGNTJUZgeRcTgZ5Jsve70slLsbm7xUnDspSFSgBDg2gOsc2G3tSpHi5MYzQ==@kvack.org
X-Gm-Message-State: AOJu0YyL/JjLMAsU16eYYnObEYy+/6g73pIxBBlIsGDUwoCGqTjBtEFI
	Fq/2P00q5rcyGMGvnym9TZjzPGALlHwOotisclM2LKlozAi4Dq7U71+K
X-Gm-Gg: ASbGnctFrckOzYmdi1u9euwPh11yRzjbVYawkG3xC5ic6r6AtS3Ac+V9EpmbwXZVPkV
	bEsXKeDF0L4uNouaEGBrN6aT9phpHCw1Ptd9S7q43jEJnzhBIgpwdZF1nJsGpVXXYUJM2PTxcQt
	g6eiIS73vmWmYJU6ps/DpNZwcpQLTwrq8ffULVNd5yJzEODbIfHQwin0oK0EtTW4YfAZlXgPlp7
	BPelKG/QM5d5TxF5Qr8FB1O4sSB8qnr8ix5FIiU6xbY9ndUj6kBp/J3E0bXCa8kfQ7cfCkKzlPU
	5yoKP86mxq458IEWNylrcEnvypx4SB7+ySxGqbpsdJqM/8oMbf+7Tz1ldPU9o+Z3LEIViEzyQyj
	P/qlF2CWvt/vA9KZf
X-Google-Smtp-Source: AGHT+IFPbmTUq+rQQKcQuYZXe1ohl0cR1iKPY/f2446SgL2VSTGAqlu9z68Mvf6HROUg/UKLgqkEtg==
X-Received: by 2002:a05:622a:198b:b0:4a7:2f49:7626 with SMTP id d75a77b69052e-4aedb958b94mr102830881cf.7.1753964516365;
        Thu, 31 Jul 2025 05:21:56 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeed669c0sm7593891cf.33.2025.07.31.05.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:21:55 -0700 (PDT)
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
Subject: [PATCH 2/5] mm/huge_memory: convert "tva_flags" to "enum tva_type" for thp_vma_allowable_order*()
Date: Thu, 31 Jul 2025 13:18:13 +0100
Message-ID: <20250731122150.2039342-3-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250731122150.2039342-1-usamaarif642@gmail.com>
References: <20250731122150.2039342-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ejz5a4fet6exxjsxsx4q67bqkfh1w3fb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BE810180003
X-Rspam-User: 
X-HE-Tag: 1753964517-685410
X-HE-Meta: U2FsdGVkX1+bmzws7yOpeYPh/9hXnOTuwPoce+ANciWS4iBqkBsReBoc78gIaDDXbfk645wnGqtENFitolSB3cC52+zRGeSpARCshLuKmKQBX2RGl3glCsN7KcI0l+/dROZlXUeoiSRL6Y5jHFKrU9St3lHFmxEnQ6ckYarE2P7U0T7/TV+rbFj9zeyqzxcbAzWA9X1/kK38FHEbdboRSrR+epxp99nVl6fg5gD/Q7BKt/pAQxAeX+BhDMHZUsQjYs118BD2E31qNhakgOZ0Ycjp7oYr2MNFcZFQw/Z/OqqtNmMT7VpcFQ7WLlldwa45aN0xxcKhkxUwt4RFT8OYUsr+cM2zUg+qGWi0BGTV5l1Cxo7L/RUqVPUynEMDoZurnDQhJk0UR4lxAEVQIRESC/5n4BrfRKizQwJM1S6zRml4g7XV+ubdF1yNWMhu1dQ99H/Urvx/aFouq4GLCjJelbcmmvm73K5B+JgPw9oSGvkuRcmaVQH5qyLAOAojxrj1VGdJzsYfv0jDjXz5R4eYCFtgHjwBfC1y4lhVDNDnXv9wUK3dJqIQ2wQy4/YtDfFhYfAQKCkzFy3g87GLHywIEFWQ++9m+Ha7ULJ47tezoIQaDhyIOcyk3JbC9TReEIw6PIOXx8Yn7rFeh4Di5mB6EljAgPcWM0fMBHBobNzD7smZbFOFg4/KF2gh+NmTlfTlAl6pdtqsN3mkF7Zz5E/RA5OV/5yt2U3B68ChllJruyoOIze+EEsE6Y6cTRW7PuDpGGVYCCNlDP5tkZLcmwb9JM60FD4pDLmWXe7jYaDjpcUdmdhaGoIRns1lLLWOXQK4rKDI4mDuguk5j/Jgz/k0Dd+Z0RCjS0a4DueUTIeJhE4XY5988v1Q34iW3CtyQV/NmoX+72QhVNdb1T8WQ4ts9PkiPd8gvIEAVNpKZKWmfFDrSawVQk5At2XAKLBykVbBgbVcmMSfqsYeHuZiQ8d
 blZfsdpf
 Xgao3L0wclJpG8A3cmrD6fQ74UVH44ZfyF7p03iz8/yYvL7dYi996XyJmVaPlwNXZK3iKiK+5qtrOY3u/OF/AH4SdmZkzEJ/n80+gkUSwIHkccO6HEp4AujkHsIgUczRZuMAbc3es3qPf0QpzHa6eiqBfMOyfEbnno7SlXIBAgApbfGX+mG8btrm0XZgbY7CpQyD+0neCF4ZEWSlAZ5iGrPpCNMIV1Szmjf9ORpmMxuudWpg0PSw4hUiC79uZKp5d8/yGeUTKQSjmeTdRBt+j7K7Q6N0QCmPoIPe/D1DV6RRbq4UX7j/AxIxw5MCHCcxLFmtCjyaUg6SSiUw0sDlYgm6O/5qBq34/n804XFdedwrpv6hVFHD1ys6gsOS1l4mYbzEbsESbylMi17xOMyL6DQGdC4JAoUUeC3+H1khVnCUZJsMQo7xkvNQ1CbA5xeoJcb+UA88ahyz0qZkQy23sAiK3/EWUnI+CN1gQ0R2cfij46O3Wbb5pRMlx6kWZysCx4dUdzJ7yACer/dbatZKWrvNllEupCTAb0jSU8Sdo4eTl+2QjGuePh0XDfKh6vV8TH6eQqPGWmld75GAFGlCXu6zyDjsk3gRRB+rlWCMQUMRjqJXJBZqmeX+BmdLKONhbxkiPlNV+26R+NhboxY0yeVHeta9cZZhHLXRg
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


