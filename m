Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92782CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE648E0038; Wed, 15 Oct 2025 10:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4D58E000A; Wed, 15 Oct 2025 10:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBAEB8E0038; Wed, 15 Oct 2025 10:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA0208E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:17:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95F20C0188
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:17:43 +0000 (UTC)
X-FDA: 84000552006.14.DAE1C7C
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2F2F120012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:17:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D08o2Q3i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537861; a=rsa-sha256;
	cv=none;
	b=XthMjyY1415GPfmbp1/GPRO++Dx736ye3ljlULUAk5tosg8GssBbQX7iJuwATyk0aju742
	31wRf4TQJg4DrQbjBkqhTskf/8fwNVwqB/esf1RWCoQD33OfgylXfYoxqBJy1mduls0B3a
	0sZ3S4oVVnSPpdNfsHvZupRBXA61sdE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D08o2Q3i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IX/EZDn+5jjqePiAgsr/tPwX5d1al1/qKcHV0+MDT+Q=;
	b=SJKFyl0URhjSjuwa00RxTCOcu3OxoNpdnNa1L/EpcJxqYA9Bi1Nk807hDgOCXuz+q/0F08
	3U2CKfkE2JzRXNA1T+48IY71t3vV+52G2+rieVM6Ge5KyraD/YffUpxo3+89akaSgZd8G4
	cIWgNgFsl5Z60aL2k2QNeGkaem+ZZ6M=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b633b54d05dso4314515a12.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537860; x=1761142660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IX/EZDn+5jjqePiAgsr/tPwX5d1al1/qKcHV0+MDT+Q=;
        b=D08o2Q3i4kGu0t0OQOb6HPAUjPUCt77X5y7j7fGaKyYWDH/6THaUERL/dXveRya1/G
         v/u/JImgwBj8Zal9tf9AXGoY8h41TQNw9rzvwwQIY2eX7qZeg7FyTNwz4cz63HJyWTSC
         oNzSdvfrkLxSzJDLhwqs14S8hnjpO+Z3iXRZzxmGNvPuAJZdXS4HeNayAm6QTT6U42YW
         Hbh4SSWxRrTTEZLZBXXiYZTHoxEgZyK+FsnY3Q/iBzbecfnBPWdVEdPby6vpUPFl6TzM
         amG0IPa0jWc5PFoYTKXZoADeMDMmcUQ4D3r2RTxBvxs50E0Bmx/jNBiofwSuBpPzWdTj
         es4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537860; x=1761142660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IX/EZDn+5jjqePiAgsr/tPwX5d1al1/qKcHV0+MDT+Q=;
        b=No71tXwNX/uYI4fCU1XdrYwZWiX7Zt9EQ3fojDMSzjPrieHY3t4KhkoIAs7guy/Mv5
         gd4mh22+2K6gZG/1LOzrWjfd547f8q0iCC0AQKpgH6xcjlYSG4sTO5UQk9cdECzP/6KX
         eSkLK10yI4cHyOV6/n4doR7MHk+9YtnmgL8wyBpVO0Nn0FKnpLxQW4opRX/Ul3uNKkwW
         L5CF86pmRKTOaC2Npmd5B0XkA1ZP9sTgRHmMuEURhqLJBA4SawlSNSwzF1UnoNR3rVMH
         8L5VaLwK0TkmovQTBUFDNYqYz6knEhHAr7DASZPc9ZgGZovCylm7rtsTBvwPAkigu+EK
         9lhg==
X-Forwarded-Encrypted: i=1; AJvYcCWzYSW8MXU8ZTsGxW8A3uEcRf751OOEWVSPNLndb1OTXp+WR/zNgGO/lwstrGeMegzuspFce2OE0w==@kvack.org
X-Gm-Message-State: AOJu0YzOT6an4HBEXfZVtMcFk7wJs3Cl4t/IENVp23S1hk8DCa4n3JgJ
	YkJymbp3l2qTA4qlOGZuNbZoi5YSV5L3jZfmpjXfFlM9TPNwG4xBjVI4
X-Gm-Gg: ASbGnctrGnLoXCYvDRAlL4Phkxivb2ko8Wu6BYNmC5u3Vbb/s88Nr96l2xLuTpNWsX4
	JejDChDcMz4n/x+vLhCnVLYRjVDQFjSG0bV40nncQowaBjiydJUMhJAytLbFbZHfAYT4iX8FvTO
	HW3krS/LVKgfO9isX4rd0bidm0sKBmAYqNscy3OTv6PLJjH0n5kD2FV+mUC/11Z3dKakoM1nPPZ
	92dra7Q1P8I7gWEjqE6VI5QgkFg4DNU6KKvmhCoMQI6lo/fB2pI7gzGOJgo1n1B4toyylMC88P3
	8H4yVn7TXl8WjfTSMoBN4vh5og9rPALj4ZGNBd6m6/mhGFFwIHOIgirzDorWfdaVTlT8mDiJSG3
	ivNMgAdydtgdilxgjEcZVNJ9/ztzLBsHWJJ2fFZEomqaBgapmauGC7YRx1wga+nFZ3d5ybh+NW1
	kP/h3QBjmMOyl0gmYU
X-Google-Smtp-Source: AGHT+IFp2HkeSJPTm8Jz89gAC0GGdTodgo+Rdq6QKzLu2VX0OPkPInkpCJBEYxlCq7SYTb+D8YpIug==
X-Received: by 2002:a17:902:ecc6:b0:25c:e2c:6653 with SMTP id d9443c01a7336-290272e1b44mr365455255ad.48.1760537860292;
        Wed, 15 Oct 2025 07:17:40 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.17.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:17:39 -0700 (PDT)
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
	Yafang Shao <laoar.shao@gmail.com>,
	Yang Shi <shy828301@gmail.com>
Subject: [RFC PATCH v10 mm-new 1/9] mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
Date: Wed, 15 Oct 2025 22:17:08 +0800
Message-Id: <20251015141716.887-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251015141716.887-1-laoar.shao@gmail.com>
References: <20251015141716.887-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nm44yssya1xrt3fpoc9g91gqx5xzrz7b
X-Rspamd-Queue-Id: B2F2F120012
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760537861-976706
X-HE-Meta: U2FsdGVkX19Vqnw3s2ywxpHrA3ZB+nLeOgQyCyVLxXmN3q7uFJIxXU5U4q2tQwWwYJwhjmPhY46oBp0FoJcF6RR4QHhuYL0HZee5m1Gmz8yH62tzuI403Eo71rbhgAdBIr8tKBaK3eeegjgneMLzTCZdjuFLWdRq2Tdc/4vKtcG6QQaIszRLsEtxtXtlM7WpjAOUl7D5ya855GneIx8otYcelYkdcyNPMUFokhf3sLKhcSpNB5MDu4d+bHzoDHj6KNwb4SNBE1wZr/jKU5GjcFgij7gG6JwMCfmDj1AU2KGgf1iX1/sIw05YoGgFXMFAdsF1EHReQqfMaWVeP7C5sTlqDgGbNc35xf3E+RJryC0y2ejLxyFJfAnWW3OhZFNDT/tXVTYyLkcbrDoZqITaAmRmF88laaoHt1JHJvjY0yWRClUJgJ6V9+Ln/AHeapUIvqa2FpEv5NDPVbsIzRH+lcTpo0gbBUss2g21SMZF5YZrKH9OdCg9V/qHM/o5A7MeMAukG6U66JUDoeLohw/jDhQ+CXlSY8fL4AHBYraWTfW0qeoeKRVWT9IrEaBHAiIP+D1q70e6sKid1hL1hdc470jLgwgICl80RBnE4Czt4Dlskx0K97RfLfxRfpEnDS2ML/YiZQFwSZiqwdkqXNa38BagYpnadRaGf2bUVRuob0v+GiPw76upTkXn09ulVJQlDxWF46HYfzkkZwC4aORRoy2zEAUROKk43sWgTngQJ8y4IdIyc6OnX7+IxhFLQKMlTfmM3HtLVbHIfFWu4QfyAMfqAEjlXOEWrKYiX5/vjt1S3QCY5c5IUK5f8FhvGp2Ufa+6kckdHacHKmxhxf+w9SNB3umLw1NDH2Z0DauEJY305K85iF1AeMf32Nt+yAxcuOcV/D+erHzf6CJxFDPx8RDZpueDh9jy65k3APSC/NrncrWxNLVpd4SwF39hxp8yeS9odsWogmT1gFkwZh7
 MRHF+e+z
 Qfv0wi2t4RwCT+B+VgdcWXTTiUbId2/uHNdvEhS7m7Es+J0gL73Y8D4ORDLSev0gYtOUA3yQldmqMQNYXctcxQ/QbSYjLZ2bgV0LWiDXfzF2EXQUywGNj32a0ImgcEk9PRxIXNLGlJIR4RP/bD3uLqN6PvXZfrmlh1+EM8rvtkX3Suht9xFWLRtKaFIERp4T8+u2owjp00SSq5lr1/HfULW9uBBFTrsPD0joY87HtYcDZyIYOIIVAMWj8Msa18Xg+x4vZ1ncgOnrqHQ5XXSL1S57USzC/neGV6RqTZsgC3Od+RLGk0fr37BargFaqXF25gYdZQFKI7s4xBzT92eT1czE26tygOnyCHZBz8MlQQ1pv9px3eSEUWUhAzdqV4WV7KI3ZmIK9Zcn0HUigOwmfcPmGNagcchjNWuxHXIkDu+T+Ob9zT8O6WRsEBRXGn2U5rLNlrrnlk9NfrSizQI2ZlIBBujAd1JXHDK4jSjxQpi/ownaFvybopLHrHmvqww/BEfwSHWBFC43zJgWLdiLRh7MXtSvpfyuq9YNPl4M5Boe1wbIPH2P8nFt3D5dSeIaHkYJ/Y7xk3H82rwFa2mwk1CFeWuJxuUGHkg91
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
  When a new VMA is created (for anon vma, it is deferred to pagefault), if
  vma->vm_mm is not present in khugepaged_mm_slot, it must be added. In
  this case, khugepaged_enter_vma() is called after vma->vm_flags have been
  set, allowing direct use of the VMA's flags.
2. VMA flag modification
  When vma->vm_flags are modified (particularly when VM_HUGEPAGE is set),
  the system must recheck whether to add vma->vm_mm to khugepaged_mm_slot.
  Currently, khugepaged_enter_vma() is called before the flag update, so
  the call must be relocated to occur after vma->vm_flags have been set.

In the VMA merging path, khugepaged_enter_vma() is also called. For this
case, since VMA merging only occurs when the vm_flags of both VMAs are
identical (excluding special flags like VM_SOFTDIRTY), we can safely use
target->vm_flags instead. (It is worth noting that khugepaged_enter_vma()
can be removed from the VMA merging path because the VMA has already been
added in the two aforementioned cases. We will address this cleanup in a
separate patch.)

After this change, we can further remove vm_flags parameter from
thp_vma_allowable_order(). That will be handled in a followup patch.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Usama Arif <usamaarif642@gmail.com>
---
 include/linux/khugepaged.h | 10 ++++++----
 mm/huge_memory.c           |  2 +-
 mm/khugepaged.c            | 27 ++++++++++++++-------------
 mm/madvise.c               |  7 +++++++
 mm/vma.c                   |  6 +++---
 5 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index eb1946a70cff..b30814d3d665 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -13,8 +13,8 @@ extern void khugepaged_destroy(void);
 extern int start_stop_khugepaged(void);
 extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern void khugepaged_enter_vma(struct vm_area_struct *vma,
-				 vm_flags_t vm_flags);
+extern void khugepaged_enter_vma(struct vm_area_struct *vma);
+extern void khugepaged_enter_mm(struct mm_struct *mm);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
 extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
@@ -38,8 +38,10 @@ static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
-					vm_flags_t vm_flags)
+static inline void khugepaged_enter_vma(struct vm_area_struct *vma)
+{
+}
+static inline void khugepaged_enter_mm(struct mm_struct *mm)
 {
 }
 static inline int collapse_pte_mapped_thp(struct mm_struct *mm,
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
index 7ab2d1a42df3..5088eedafc35 100644
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
@@ -460,14 +454,21 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-void khugepaged_enter_vma(struct vm_area_struct *vma,
-			  vm_flags_t vm_flags)
+void khugepaged_enter_mm(struct mm_struct *mm)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
-			__khugepaged_enter(vma->vm_mm);
-	}
+	if (mm_flags_test(MMF_VM_HUGEPAGE, mm))
+		return;
+	if (!hugepage_pmd_enabled())
+		return;
+
+	__khugepaged_enter(mm);
+}
+
+void khugepaged_enter_vma(struct vm_area_struct *vma)
+{
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		return;
+	khugepaged_enter_mm(vma->vm_mm);
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
diff --git a/mm/madvise.c b/mm/madvise.c
index fb1c86e630b6..8de7c39305dd 100644
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


