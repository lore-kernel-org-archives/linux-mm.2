Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7848CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47B78E0161; Sun, 26 Oct 2025 06:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF80C8E0150; Sun, 26 Oct 2025 06:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0528E0161; Sun, 26 Oct 2025 06:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B33448E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:02:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54CDD1A03A4
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:29 +0000 (UTC)
X-FDA: 84039825618.23.7FFE20B
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E272100003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XABYv3Ad;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761472947; a=rsa-sha256;
	cv=none;
	b=qHfzYzZzJNC0tBuaHiaM3ph+6D8Z0BePAu0guwnbgw1v1yPJI/C5BdpDfXwOTRhL+I3P17
	GKV+LexiTjkFPXDBT7r1srDvwe21pR+GYhJbEnT8sRrtHHX36twBrPZXF33JKAITvfaUjT
	KzIKv1cRfXW1bFsLcBufaLtuQku5gGY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XABYv3Ad;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761472947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwGSchT18d8qNcK6ftYzJtYNcHfYL/3EORdpk4nxKdU=;
	b=T/RXAtybdCdAxymk7uHCgtRx3dxn7niLGIDzinCYgw9zzpecXhecnhnhX8cRAhSqq6lwu+
	XiRTPro5K1Si0ZIZ7IUpVTn7HugjR9oIGzi364oo2tyupj11Dkr3aLngmyYiv72ZfN1feI
	umiEh8f+7444pqyMeTcMkMGef1KY8+s=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b593def09e3so2183307a12.2
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761472946; x=1762077746; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwGSchT18d8qNcK6ftYzJtYNcHfYL/3EORdpk4nxKdU=;
        b=XABYv3AdCJ+Jq/CiXaQkIL8mHbCRf1MQ2gptVqf9pyO2UMWjE4n1rAR9DbUu1uFdB6
         DEBXHUsjGa5JsIgaCTNc1UEtdwltwoI48jU2c/fpSZ+oci59bOShqPqhPmL5hsm5lRsX
         xH/0D/mnHgwqykQbjBcEPV44EaDYKbowD1t6B6oskJ4mccyAjlmeloqvORmroicI4LZS
         H8DaiUdxSsyxNURchr1ntwwArLO6tQjT9rtiLaQpHPf6vmuW/bkOCteK1UrKt8Sdtmfh
         fc7u1pPq2EsEXd8qq1n5SeXwkzv1yKAdrlWclwlS98FUMRXKf59D5A5tT5N6orGuHMQV
         2GPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761472946; x=1762077746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwGSchT18d8qNcK6ftYzJtYNcHfYL/3EORdpk4nxKdU=;
        b=La8iHRy63CGsGVjmhyJ0nmpA8y5uDPc2nihK5F0PkOg5nk3/XDJ535UdaFow0K3gd3
         Q6CE3SYyxjDPju2kBldtfINbDIumPRlyBaGAjq8wYXTDlFD10Kow2MQ4V2bMgqzLU/ge
         B6/4rlZ+IiTNWu66bFmUXrvqHJ79gS302nGaAQmGw7B2KayRssHoMomm/npZy34VFpwx
         NEAy2NIXrYzAZw8l5jZA8A4qbMMMQVACcwVqmQWZQMyvqwRyDsLLlns1U6T9EcAjLscY
         VrsBLG/DoMPDUmaTanmWPLr2LrMJnlNWfjZe8rFPArYeFd+tGzfN8pU/+xlZIR4funYf
         Tutg==
X-Forwarded-Encrypted: i=1; AJvYcCV+cIfMGl3hEkU0GanL/H3FB1pgd/x3wIDMXn3zrRsUh8Md9piVnqMAE418WW1SdCpGlG4qKUtZjQ==@kvack.org
X-Gm-Message-State: AOJu0YzwtCVosSR61LyJf1cr1lNu/h/hAwDww77QuZmfYUUgOsR8lAFe
	ZLcpSduQ+ql3b1M3pZSDlU+sjyW3jS0BUrcL5GeY1pOyS+xMyNF+HMBO
X-Gm-Gg: ASbGncs0cq1a8fFeavI2mue8drcn/MtzfNg/S1emAXLkg1BwpnR/EUa9/pQksm7n8w4
	70Yf66yauJHCmF1Pb8NX0mKnUaZCrZKFWtSlxWnhhC3X9MVFXvOVBEQHb3o2AypowTlxCD7Zal1
	SliZZF0bIUYTy525xoV/7/GLF8QWmH0cdwUJKyltpTbIlRpq96Muk2kd2JfMKRITk5T6uKo5e6i
	/Qe+qTQ1kJQxCSWvXm7YNSmNWcv5PHZUs7oct2JHTLgj5H4inzwAncQ7beFD1XvecWRSm+4bvTq
	8kAgSpRQ0FYISLOoiEOSsm9WVZ5RXHQGWiagAW20KVGMw3drevLNjCQmB7zM8dc9f7EvhK7oIzd
	Pad+RLYmQ18j3eG7MBG+SoAT8UA11xoWrNYTU1lnHQFocQS6Jng072TdSjfs6UK5S+B1SDygjX4
	5ZCQidDSD2BX3djv2V7hlwvKRW6oGrw3yU8As=
X-Google-Smtp-Source: AGHT+IGuJ84bU5ooLGoiNi0u5x/Ollkx2KP02O/Hek3R52H05y4BEGNapVukKfR1o3GdEw6baOphkA==
X-Received: by 2002:a17:903:4407:b0:27e:ef27:1e52 with SMTP id d9443c01a7336-290ca1218dfmr405991515ad.35.1761472946089;
        Sun, 26 Oct 2025 03:02:26 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.02.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:02:25 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org,
	clm@meta.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Yang Shi <shy828301@gmail.com>
Subject: [PATCH v12 mm-new 01/10] mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
Date: Sun, 26 Oct 2025 18:01:50 +0800
Message-Id: <20251026100159.6103-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E272100003
X-Stat-Signature: gzxizdr6y5oys8cdurci6cboq5uezde3
X-HE-Tag: 1761472947-286685
X-HE-Meta: U2FsdGVkX19yomD1VLFZqkXEeJf//cdLvEh0VXeoyKw4AlJVLn25kv3eIYczW2+gK7vcnavPnq5NctImR8MPvn1DFHQ4+v64W/CesKWvD4/n1xnbuYPAX16HBr0c4j+Tvk0t3rVWMk6rlLlC84qLzwpJLJZH/Wu7ePX8tLJPeSc95gPoWpTBX5lFMcfUl4u/ar/rSDk880xCHU8IqC0P6HOO/WWs+uizfmW4EjcmpjJmvk03X+SmRWELeG67zdEBoYdo4paoAbfQPeC9XLhNIvp8Hkt+vFld7Ey8hwN4BGm6l3Y65L4SO+U61WP6UJZGb+ruhew88V3/S4uH5FpcU2WmKjQkvyu80G0WzpMqoHkIxTD5bZquGOp/gjD8oJ7iYJU2zA2v2+dgsmbgZL6yiaT66TAveriQH+NHegQFZB6p7SUpz/Qs0Sr+l4+5KUbH2AG5aDuGLe69wD8zf2qeI1v5+2wGMBEctdnM1PL2ulLiOzWS52ItWw5eYro44sKOSjr2RqIEgbcJsiO8RUTQ1Ii9dQzRq47h75oOyV231+Be57j8iedsZ/50BDSN4wsCL5XXq2zS0igi1gBNbKqgNio6dp7LDm/Qw8ESiRKsZpYdSAsbuTGlwkzeVnVWei+ldZHUKHlkh+De0qFCwKosqW42e3lHXQt32z37cy9rQMTp3Sh2eNcRUF0SeRLj4gea/BwSwk3MKdviei/0uqcESZ+pnf+L2MUQMr0AegAFiCjAhflORhcEA01OXDh9PuP0qmy672lIBqEo2KtyJlx7Bq2Wtq41jqo5iSfY9RXJlIEDQMm7w2ThsOF5ABm1+fK+W61b/Cb075qEhBpH8Db2iTM7FXl6SBCcDA40W8tQl7V0LwZRYj6KpVmdheDqB6vEg6QJmP4Rf26JKyIYYWYUWVZAfhSkG98RavcDP/wfQ5FDIQNljKkM49iofpmomi76dbkfg02q6ke6GM7SNyB
 SzoPBPfr
 dC3MV1jbTMxcfkMXjNfAS5pWH4rRE91iYk7bbMdSj52zX8lQxHNjM/o5WtO7vihL/ynRDvXs4c0nXPMBm5aBQGFs0mLIjsDzlHzvBbwSsK2lseBScwbQkqImb825VXTYiwXgWhtleORX4+ytVdrV+e74feJ86k7AToxo0Ahlw/PaRA6BFEN9vuQASBz7srRoY704c1xlysUVjW40IxnQ499+rQmM8TLfRGLgo5VumMFOWtzXIuGrjZLXbCDZhG/dyAsUNBulHcedIejYLjIEUV6fSnu51nB5LnCWsn32JJ4eBBSnkjZgpPE7clH1c3yhOzQYiS9saH3lHUGbLvIn0KllKfIb0OOJR/7m2uQESFqqCDV2dFIu8aoaCqWLB4uv4M+P4+xOyCjEvc0RowNzIio9hgDvtmF9Q/iDCFkr5sP2u6O2B7QfmC40YsyxyaLemSvpFy9rLc/MUhv37lTSu/bls/PrSmJrFAgsPypQpntOw/Aa6TGYJikixr0m/JGmEiY+yCaSLTEODa7gXydkYZT5dyLZLBzoz/hdbt8nxCW/ODH4K5x1WCpniqUSo9sAbFQXoWFcViV5PlRfolsgmyqAHzxnpxh4cGudq
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
index 179ce716e769..b8291a9740b4 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -15,8 +15,8 @@ extern void khugepaged_destroy(void);
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
@@ -40,8 +40,10 @@ static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm
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
index 7a0eedf5e3c8..bcbc1674f3d3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1476,7 +1476,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8ed9f8e2d376..d517659d905f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -367,12 +367,6 @@ int hugepage_madvise(struct vm_area_struct *vma,
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
@@ -514,14 +508,21 @@ static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
-void khugepaged_enter_vma(struct vm_area_struct *vma,
-			  vm_flags_t vm_flags)
+void khugepaged_enter_mm(struct mm_struct *mm)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_enabled()) {
-		if (collapse_allowable_orders(vma, vm_flags, true))
-			__khugepaged_enter(vma->vm_mm);
-	}
+	if (mm_flags_test(MMF_VM_HUGEPAGE, mm))
+		return;
+	if (!hugepage_enabled())
+		return;
+
+	__khugepaged_enter(mm);
+}
+
+void khugepaged_enter_vma(struct vm_area_struct *vma)
+{
+	if (!collapse_allowable_orders(vma, vma->vm_flags, true))
+		return;
+	khugepaged_enter_mm(vma->vm_mm);
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
diff --git a/mm/madvise.c b/mm/madvise.c
index fb1c86e630b6..067d4c6d5c46 100644
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
+		khugepaged_enter_mm(madv_behavior->vma->vm_mm);
 out:
 	/*
 	 * madvise() returns EAGAIN if kernel resources, such as
diff --git a/mm/vma.c b/mm/vma.c
index 919d1fc63a52..519963e6f174 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -975,7 +975,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (err || commit_merge(vmg))
 		goto abort;
 
-	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+	khugepaged_enter_vma(vmg->target);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
 
@@ -1095,7 +1095,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	 * following VMA if we have VMAs on both sides.
 	 */
 	if (vmg->target && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+		khugepaged_enter_vma(vmg->target);
 		vmg->state = VMA_MERGE_SUCCESS;
 		return vmg->target;
 	}
@@ -2506,7 +2506,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 	 * call covers the non-merge case.
 	 */
 	if (!vma_is_anonymous(vma))
-		khugepaged_enter_vma(vma, map->vm_flags);
+		khugepaged_enter_vma(vma);
 	*vmap = vma;
 	return 0;
 
-- 
2.47.3


