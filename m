Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C183CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67D88E0014; Tue, 30 Sep 2025 01:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18798E0002; Tue, 30 Sep 2025 01:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0528E0014; Tue, 30 Sep 2025 01:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7EF08E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:58:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C7A41405A1
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:58:58 +0000 (UTC)
X-FDA: 83944863156.27.DBBF22C
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 57E5D1C0004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:58:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yloy02sy;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759211936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IX/EZDn+5jjqePiAgsr/tPwX5d1al1/qKcHV0+MDT+Q=;
	b=VfR0qknslJb0kPRA5/jIm7y6OuzNOgR4TlGs5udQa74iAtEgWW79Z7nEczVqIHbMyJVYLg
	wLEu0cWl8ipLkpRDY297NxW5SS84UHrB5Tat+pvHXBSb4cFluSs1sedOGoe/yyAsl7awHW
	RwserQrzowxy3YPWQXvkhTBBgsWcFoQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yloy02sy;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759211936; a=rsa-sha256;
	cv=none;
	b=wgTsHn/lN9/9XuJjDZyOe2O3wS466nmlq42QKrSnzSGndYHGhjjb4ojQcogd8ZOKtYCyrh
	uZyEiJAi66s0U4rJWWxX5oSyJsK/3BggRDy7jz+7FezKXELfliy+aQ98W5rcCBU39wKN73
	zVDsxzzFsOXavPI9S++IrfakyAaPQkI=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b57bffc0248so4305947a12.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759211935; x=1759816735; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IX/EZDn+5jjqePiAgsr/tPwX5d1al1/qKcHV0+MDT+Q=;
        b=Yloy02sy40z7dqEJVnt3rp9PQpOzCOXtz/geku1sFJd7z4JAaoWM0cNyDG7xmG7OMT
         IzMK6pesflB6BBPxjyR/S4R7qy2WxYnKyhgx94xgWqzzH5ZgjKlepyt+Km+RN3KMcPt7
         n2diNBz8Kzq8U3mvLE5HAaEBhr8VDdHNXFn5FQW6056hQwn6x5QvOwPlGo/o12Z/jq/Q
         bCz2aWGqVpfv/qi4EfSe0741uOwVXMNMHOimX4YEjcvEeFRfOmEJg4LeL5+WdHiUM0L6
         9kvKy5ZHluxc3JblRftlQUGLmp5J0zOrdmFWZw5hlkq7tl2eZxSy8pGTaN5jODJCGOla
         yqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759211935; x=1759816735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IX/EZDn+5jjqePiAgsr/tPwX5d1al1/qKcHV0+MDT+Q=;
        b=moxG0WyVdkwfPJm8m8r9wsY9ZgOLtE9HsSQZ2Pf4FabHAUBhozXHVdEp1cZ+SNisSO
         YA6HkWbqqJCJU0RqGB2YPY30EjjDJVAxAiu5ALhRNQ1pD9du9DdsBJ2PA6WfzbFJJwIA
         ykOXRz9+kt1DfoGTuJ803QsYWUgssenQVYpX4pnGVvmRh7zJ/G2WeWRW3xQubhyhMWNZ
         HqnazvhK1nGsKw0Lpd0NB/ZSDbcZendNyhr11dJEppVQXTJsGr1bbu9D/wA+jH/IR1/l
         YC7xk8/LSnNL4X/VpLdwJGv8G0iYNXRZn8aE7k8hJTW60SU9L0WrCoQhNvjn+SDUmA8L
         eShw==
X-Forwarded-Encrypted: i=1; AJvYcCWYifUrwfqlDx7obcEIfnwGxDb7Jk7fB5NnlkUCg+3SCYhTHfFcJSBji84kckQDrnSmrR4zaElf0w==@kvack.org
X-Gm-Message-State: AOJu0YwDOWQSvFihBddBCaIYRMCnkKr5eitAlow5OYlXIQxj+QUotDlK
	oJzPYu34Tt50qZ2qUPEQdRc+jhw0/MWu/0o2y9KXQVOhqFMkNBK2kNwC
X-Gm-Gg: ASbGncupyFnOCUnE3RB8a8S/fxf1FiIjzjRjEN2wqtyMRsgN0PiaTzBeMWcy4fwN1mS
	5LUiedyqcx4w5nW7TXvtnb8royRAat19EW7ytxvOTqJJoxIsP8i/iQDCBxGdCZYDloGOzIEPjnn
	C1xFHIW7Fu4dmzAjTZ17FYuK1PsRsbER4UdqD7927FagVx13e5aMHIsKosscQ7ArVvNAOCOipJ+
	7FHdI7mry3fROtywEpjFTJLkx+8gPcVTDzU+51/vNfR618GSXPP8bjDmXCCRIVC1klR8B5d0K1v
	6McJ7rEYh+LK0LszbIDTH/zFkxY40F+ppML3z06AGy8uUjMie+Ohn3GvMX9y8KhqbW0j4ZcMlSZ
	N0CVnX8dENqjltsa139ScPImYtVfNejN9lDMHB8d5xMkUltGtzZConZ0wrxDeU5nYFrv6n2zGAg
	wpRU2HnmlMBnWdQFsUcNpnyZ/1wMMDNx9B3nXing==
X-Google-Smtp-Source: AGHT+IEe87sBeRrqaS6fI58+8CLk5OyPR4wtDVThXkEE6FbVm+QMGWoKZoG0IbKrCxt+Qu4CXqUQVQ==
X-Received: by 2002:a17:903:1904:b0:282:2c52:508e with SMTP id d9443c01a7336-28d171199c0mr34377675ad.8.1759211935110;
        Mon, 29 Sep 2025 22:58:55 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.22.58.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 22:58:54 -0700 (PDT)
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
Subject: [PATCH v9 mm-new 01/11] mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
Date: Tue, 30 Sep 2025 13:58:16 +0800
Message-Id: <20250930055826.9810-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57E5D1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4znuore6wtc3oc4acja4sqcarbqz81ph
X-HE-Tag: 1759211936-374825
X-HE-Meta: U2FsdGVkX182t4EcpnWhc3f5zggptir40fJThJfOf9AAjMiy5o/LGqlQCGakgAfbmjbbALHRv/7DMLOogFnG62b1lOMmIjRWErr53z7GgijqNs7ahzeC+g4XfLx/7eUUe3QaxSAjPb83+NZZylxw+cYm1EnddZvcVP9QjGNaRs7kYCv37CKQ+ySJ7fLnloNHNPHy0OUfpxcIEPh4nVP7HOegvtAk/DiBRxRvNili8uUqP+XDh4phFySMoajeB4TK1zdxHKfIzZlLwVsL/eeGmvVYCLnC6mfeqpuSJMuhqfAqXVQ+R/xVubtzHcl6LAHW1SINCSXaYNj/BRh8w2MwY8Ef7y2J8Qb96JlM0YMQpFMfnSbr0xe7UOOHkA8IYHyFnKvp1RlZWdvztWtceRCwGnrACxh7tYAds5zDIolTW8brCj/c0pCdo77plFaTT8HZ6yoNquApwkrLgzHTARFM/H74HY6vMQkz4VpbAhev1zVZ1N+6wj8xrWiDYMjGYse9zXhegEhTQEDlkv3QCZ1Rruy/wlr7E1yEx5axx9G52DI0BykXJQtDpvly1jb9VkTZRHLhEuX2gUQ7ZnKjWd0BxBC77dsm9AUM5D4GFNcl2wudz00r+YRaOKl3QlTL/4gTi1g1g3/ny9YZ/6qi3eTnGHcqzQYqZRoPDJUVRNs+dmTtegG1AfGAF19TlRuMZD7n09qtiADmnouVqL10oJWWVchYkRqHSU3g+VxL0BjPHga9JgYxl8eNp65xSIvRpXcP1rloK0gpy5MGYsydR+dGtz/CgPXARclboOIRZ1CKGW6zu6Q4s66b2L0YHqdHR4bSnVPMWWl/OLJGyaSSATzfJ46nU/g77lbPAJ5TshFEWkFw0iOQ894WScAyOwAIv/98RYCTsuzLBiKEbgKQ5HLNeFC5r3pV1Rxo9GYi89M4Jxnf6q0byfo9aYlarR3aZJFv3R1ObnU7cRomA0VK4jJ
 YyF4J7dA
 XGmEOnwUz2+5OLwWDJY70Dx3cR4d25iBDjznpb5Xd/TanCdkUiSM1nK4rVQ4z4ndvisHJxlXhhr71OF1+A0+UFAVEYFgi3ANJup7fHRib8GgRwZcT/10x1gYcgu33pH4HoslPQNNYQavTKpjr5UyAggxQegO3hNX9w8FIUr2U1zJajZDh7a/YGdwSana8kZO1lc/yRsF/C1Xs5SgzP4yDvyhR/53jes+00zc2n5CrCyJXYWjIhcmit//CZOuWTBDKZwoIpLFGSDEj4HK58vjUeDHOuab6QSPKnVj1RWJpjFGW4oP7O1+GFATuuL32H6LPTPSVyQzbdjVrrswlIFSgBgD4OnyfADGRKn4v7T4L85Qs9g/5PeVzB8u7bY9Mf2URDaJezPiOkJQ7LNHkxc57EnZAWw5KklESVskui/pKn+LARVG/PdIQRdnRPD8mmmBq/04pII3ZLy+4u8f7hlA8+rHfcEb1u7NQpKYzHdzopswHEuGa3F1q+Rn6rHzmX7AOEIf/rhP2VauGPAvX3BwubGYpS5V+eaRLniXSRoOn7tveoPJyzes8O0qajGZAR+3bCo5b+G1jD8dOP6/wLgMwZ0CDm7eKww5xTvwN
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


