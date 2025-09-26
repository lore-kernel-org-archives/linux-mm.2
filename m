Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68297CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFE88E000B; Fri, 26 Sep 2025 05:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F648E0001; Fri, 26 Sep 2025 05:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957D38E000B; Fri, 26 Sep 2025 05:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8160A8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:34:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFB2BC061E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:06 +0000 (UTC)
X-FDA: 83930890092.27.9E29118
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 01BC710000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=isHLB007;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879245; a=rsa-sha256;
	cv=none;
	b=ouEmBByYiKOwZzJ9TSLGyAqelnJLd7/3uICwjWAmG5HeRhNJcT/Q4OtvFWegJsRfY3fNup
	CecOoR5FsTW/lS0LHGhezTKg3pFh9QSWpGtMaRKiEmoNpxHesWhe40nOPZva6zCwwM/BxO
	za5k+GMEvSAihRQp2yvX5DOuD4i1EvA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=isHLB007;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1iT+4a+LxjpmMHe8jWDV6d5sbyjeFATI6sWgnnJ+Ko=;
	b=DSTGB1tuqOSUocpqKemu3zkjde9mYYzozDpBArk7nS4b8mUpDmQm8DQauyQgyiAfLAH8QX
	JOESIHiF3cztXBOKUdJ0IvJm5XF3tsDZ3XP8nsgO0t2wgHNCU3H2NjSOf9+zSXIY2lTfQN
	W16XXDrIv/WxVLU8FMRKUm/Fknchk9k=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so29849745ad.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879244; x=1759484044; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K1iT+4a+LxjpmMHe8jWDV6d5sbyjeFATI6sWgnnJ+Ko=;
        b=isHLB007le51/aJiVge1x6dIfBcogyVvpNbPc4tM1GW42C5O2YbKRO4SGB2ydcf+NY
         C9YuF2Uq5KfOS20dzcbI8h0GHwl94RsxGeNtkLb5zl47ecYFygmgbS1hLQIqyjRSRQx3
         sVJFnYteQ2fFRSLTJYsGYKfuMHBODFBNXocODwiiWco3WFdTgrrjhQQhkduxS/5/niDy
         nsg4zAv1qAz6DDyzP/7YhtJAPk892PHk5jOwnd/p1dieOXjI3Al7se6noV7G/2RiySS8
         zOwGSE3uvyelqp6H6nF9kDKsvj5L2Z95XeVFjaMYPnn4Ob7FsCIspxxF2UDNUlLeJLO3
         Q0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879244; x=1759484044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K1iT+4a+LxjpmMHe8jWDV6d5sbyjeFATI6sWgnnJ+Ko=;
        b=f19pxJX6xWENElwqAiq/rQv2VRsHB22Q9Kf2VPQkoqyTjjhXJnY+zTgoI6qGatazUK
         85v+uFCV6CCHcoRx9A9OzRXQu7JjU4syMMQ02GfELPvR5ubW5MruBWsqXbSs++IXyxED
         Rl3wokkZH+uIPjEzs71Vz0jF32DfFMa9zSw2kW/ak7GhF1116pFZL0YRR0buCMDOuTs0
         dmuiraxsA7pr+9SkD8P5vQpGt+L/7jxNE5kMdwIzj5c2ZIDPgoJxeYo/lWBxifSsJ+Jw
         NytSkRMkD+If8MBdOvhR6TvxCbh26P6NXTiRwIfSELljc66YdUOXOMGmgapc96tiLJh+
         nLoQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7ihv0HLY5hMMeTZyig/hD8t2BXDf5sEwrpqh9jLybW3VgnDRsnrE7TJyZbZI3z6y5a6KfTpoQ3g==@kvack.org
X-Gm-Message-State: AOJu0Yw6hnftj43wC3DEwHHo0FgU+HWsuaMU1u2L7JR44ZOJyQygz3ej
	GuF7C25SRnRlhS9OH5KMf2eOQ/EO/3sUgJWkbTe97X+jO7V2i3caj/Wb
X-Gm-Gg: ASbGncuquDbXyTxyqev/O9mtXm8h3BEQnAXG6/cHrU2v0E9sZtODE0605neEGBQnmQB
	yMd5H5F6XJecgCG3hSrB9Fv7ST7RHl60YAsXgdpbdSDzxueV4f8I7q+/xS57jxFEtcVAsV75iND
	7pwGpxSe4wMWzLeb8YIjsv48PBKSx1uHiTdCrDTiKxe58kB/3ywdjgrf9gBJLYeaFfhytUfMS4p
	EHNENWbDQpaIXMWWtMon4h7N2Vh24ALlSTg5bv4DukQzDo1Kh/XO3SkKdaknCBCOTYGAtdegQB2
	aUGbqVzqj0Y/2u8fZvMvTkqLZnREtauANAytk595I5o9BrRA6lVCmsakgduZ8g8ozpjB9DFXnEi
	L2AFXIVgVQMT3XyQdAKeYbFlrT8zvAheKfFGQbjfqiAtL8KcpHoKqWZmZB18PigdzVnTEHm1pay
	Sv7V32b0rA3uYl02KhSXXW+7k=
X-Google-Smtp-Source: AGHT+IFMcSGbIwf6P8Uo4nGwswfBIEGRuV2pBMbvxCc6qLaUcucPNfwqmzfPb0tJNWSduz7DlEJanQ==
X-Received: by 2002:a17:902:8208:b0:274:aab9:4ed4 with SMTP id d9443c01a7336-27ed4a670f1mr55436305ad.57.1758879243564;
        Fri, 26 Sep 2025 02:34:03 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.33.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:34:03 -0700 (PDT)
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
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 01/12] mm: thp: remove disabled task from khugepaged_mm_slot
Date: Fri, 26 Sep 2025 17:33:32 +0800
Message-Id: <20250926093343.1000-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 01BC710000B
X-Stat-Signature: gwj4n5hp13yq7jnmwzhwqiijb3bbuao5
X-Rspam-User: 
X-HE-Tag: 1758879244-345269
X-HE-Meta: U2FsdGVkX19GZKR7/eQYl1x1bLspQnrgLoSlx4Ri+7H+oDi+1cvayFnzqBpZ7qJfcnbRP4dRUuyBGETBqO515T6jA7v7gv8G6w7pKHASANiD29EvWslYeF7aa5eMBCGiFtz/lTxM1DVZqBtGf+Q1IGRRKXiv6v3iW+9gTnXBI9CTHAHXKE0ueLmtg9e8TMmzrcw99q+0TkvPYT9s5Sr0huZrZ6MvVz6/7BI+ehF+VNuho9ivU/5BtXYAqgmkFOH46L5rhlLdph6ZrXJzo1I/oEcIZ5qqkad68myhjrH4Yu0AFRcKHU3e4QoqF0CfpR+uFKNVDqwOqIexI8QCr6T8cgyyG6AnT28VXDD6SxjhxhqsYt47D1NcZrxbDIYxblzZ+I5bMCHGQ82b9VfX1qNMHeJmjzAn35uuDL1FSrW9LujliZqh0e1jxIipZkgqnl+gmpa0aSfEo8nwDdOtf0Vg1KzyQLY6UjREUCbu/tiCGwYTYPkHM4ITQ+5yKZfEcbC+1FD8p+R/5MBamUR2VMyBCr8ezpe8ytvMMo1Lbz0ABz02J6lb7i7ZX6S0uN/7u8hLSiP6Po0tW/lAJzQkPKjzVEHaGAFITyhmZeCthVqEa9CHvuLcljygKGrCBuUbk4GAs25mxQDNkCXEfXQgC1B8FioCysWgoQVHuGglCefx6zx+pUd90TNPbeNcOBvlUm7h+27jREJ7EZo5xTg/llcfsANr+KXfoVYrt/friFLgnmmI4YQcqorwrL+OdZ3bsrT08LLoA0SwMLGoXIKfK6leNtjkszTcA1eqi6ec0OhR+QYU4x4ELqhDY+CsMe/GZOJkHwOvGpvPAeaqecu+VVQTDI2MDQt+0irSA4PbOrro787R/PaUzgn3AHI1dPTEN8J0Sl/dek0ds3AbHt4PBOWMtLVhh4tLO9ftMatYQUSr5YSApoHNVm6aZjL0fJy4kPhEmEgcwwxGx0x1SxYo0iW
 6ws9oDi0
 0ZonoqeLuE7J29/hDunpo0hPIHZ281uVpZSWQggxzfHunmbP1nl5QKLOf8E8UpJT1E38vbhwmyp+/cK/9apl3TvWfLAPssGwK9YiVuBpqkq3j1shpE/XpxpJNVxO+0bbb9y6a3ZU729qySVB0ZaoLEWFRb5/Tb8OV9FPbdOkm1BF23hUfTXHvMqcj11DStlnEqtMCUn2wblEDy0qw+oZchCym8szKPFyiCjnD9Ff7NKG/HcQBYn4q/0IbhCoJeafam27Y/YlYXd4MgPwMa+uSyAq6/j40VUfJ/EtgwPxxiZXz2s/p9nNio5y3wZNji+jci6T6JrZIWWN+giRNbUl+UjgfAMg6YkcyblDRVKzf00ocEavTcZfkygSBa/Z8zUOUgx8tA6bjAMcjlJQfGEImMszmMOjeEm4FZN1JbNjBDJhfy/P/LDdV8nxnQfN1b0C0lB6FcQvGBdX7C/rzU/18ZGRal7joh/1asp6bVeu1aZ6o6tfglixPNo9DHcDt2J6UH9fcuNTf7M82uGvecDHvo5LLoCum26PTm3JaQL5mcgzTp6pighI5WglD7jAvHhdAl35NpArXqx3gB8A0HXfU1EO2btYYh55GYSgG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since a task with MMF_DISABLE_THP_COMPLETELY cannot use THP, remove it from
the khugepaged_mm_slot to stop khugepaged from processing it.

After this change, the following semantic relationship always holds:

  MMF_VM_HUGEPAGE is set     == task is in khugepaged mm_slot
  MMF_VM_HUGEPAGE is not set == task is not in khugepaged mm_slot

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/khugepaged.h |  4 ++++
 kernel/sys.c               |  7 ++++--
 mm/khugepaged.c            | 49 ++++++++++++++++++++------------------
 3 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index eb1946a70cff..f14680cd9854 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -15,6 +15,7 @@ extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
 extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 vm_flags_t vm_flags);
+extern void khugepaged_enter_mm(struct mm_struct *mm);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
 extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
@@ -42,6 +43,9 @@ static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
 					vm_flags_t vm_flags)
 {
 }
+static inline void khugepaged_enter_mm(struct mm_struct *mm)
+{
+}
 static inline int collapse_pte_mapped_thp(struct mm_struct *mm,
 					  unsigned long addr, bool install_pmd)
 {
diff --git a/kernel/sys.c b/kernel/sys.c
index a46d9b75880b..2c445bf44ce3 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -8,6 +8,7 @@
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
+#include <linux/khugepaged.h>
 #include <linux/utsname.h>
 #include <linux/mman.h>
 #include <linux/reboot.h>
@@ -2479,7 +2480,7 @@ static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
 	/* Flags are only allowed when disabling. */
 	if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
 		return -EINVAL;
-	if (mmap_write_lock_killable(current->mm))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 	if (thp_disable) {
 		if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
@@ -2493,7 +2494,9 @@ static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
 		mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
 		mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
 	}
-	mmap_write_unlock(current->mm);
+
+	khugepaged_enter_mm(mm);
+	mmap_write_unlock(mm);
 	return 0;
 }
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7ab2d1a42df3..f47ac8c19447 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -396,15 +396,10 @@ void __init khugepaged_destroy(void)
 	kmem_cache_destroy(mm_slot_cache);
 }
 
-static inline int hpage_collapse_test_exit(struct mm_struct *mm)
-{
-	return atomic_read(&mm->mm_users) == 0;
-}
-
 static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
 {
-	return hpage_collapse_test_exit(mm) ||
-		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
+	return !atomic_read(&mm->mm_users) ||			/* exit */
+		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);  /* disable */
 }
 
 static bool hugepage_pmd_enabled(void)
@@ -437,7 +432,7 @@ void __khugepaged_enter(struct mm_struct *mm)
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	VM_WARN_ON_ONCE(hpage_collapse_test_exit_or_disable(mm));
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
@@ -460,14 +455,25 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
+void khugepaged_enter_mm(struct mm_struct *mm)
+{
+	if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
+		return;
+	if (mm_flags_test(MMF_VM_HUGEPAGE, mm))
+		return;
+	if (!hugepage_pmd_enabled())
+		return;
+
+	__khugepaged_enter(mm);
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
-			__khugepaged_enter(vma->vm_mm);
-	}
+	if (!thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		return;
+
+	khugepaged_enter_mm(vma->vm_mm);
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
@@ -491,7 +497,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	} else if (slot) {
 		/*
 		 * This is required to serialize against
-		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * hpage_collapse_test_exit_or_disable() (which is guaranteed to run
 		 * under mmap sem read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
@@ -1429,16 +1435,13 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (hpage_collapse_test_exit_or_disable(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
 
-		/*
-		 * Not strictly needed because the mm exited already.
-		 *
-		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
-		 */
+		/* If the mm is disabled, this flag must be cleared. */
+		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
 
 		/* khugepaged_mm_lock actually not necessary for the below */
 		mm_slot_free(mm_slot_cache, slot);
@@ -1749,7 +1752,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (hpage_collapse_test_exit_or_disable(mm))
 			continue;
 		/*
 		 * When a vma is registered with uffd-wp, we cannot recycle
@@ -2500,9 +2503,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
-	 * if we scanned all vmas of this mm.
+	 * if we scanned all vmas of this mm, or if this mm is disabled.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
-- 
2.47.3


