Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA86CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23EA8E0005; Sun, 19 Oct 2025 23:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC238E0002; Sun, 19 Oct 2025 23:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA9D8E0005; Sun, 19 Oct 2025 23:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF4A08E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:11:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 857DDC01BE
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:11:35 +0000 (UTC)
X-FDA: 84017017350.30.CCE1B96
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9DEC240002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:11:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W3LU+zEb;
	spf=pass (imf01.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760929893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DcLsfJON0lJjNOupQsAXtJtd7DDEJTZNiP6jZEns7kk=;
	b=k5d0ILqMUAIoKp+n4j8bRU0e1NaAmJiRZxyVaHuk5tOzBJeoFVWdQsOc4o30BJl82jD1W7
	UB6V2A5M6sWBb+1/6AsNwuJc66hx5RBlB85RSR1MONhTN/jNd7ADKeyBjFwrBMBMaJfQNO
	hQenCI2O2RZGcKNnaULvRYnJYjmn9mY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760929893; a=rsa-sha256;
	cv=none;
	b=F6fMZuVfsX4/KkbROTtcocjqa3arbtFfDBU/9+k+qRpyq81to1X8I9Kpe67DXG2vAmxcI+
	f5ZipJVJlzBGw3bUvVeUAD/+l7UJZIjxm6n+jQy63fMWsG3Bwn7VdQNwS37jlLAiwfpUUa
	6bromK+tizaWUHhfsxxsBYPwGWKI9Ro=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W3LU+zEb;
	spf=pass (imf01.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-796f9a8a088so3601956b3a.1
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760929892; x=1761534692; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DcLsfJON0lJjNOupQsAXtJtd7DDEJTZNiP6jZEns7kk=;
        b=W3LU+zEb2y02Z7QV44CPcTNr9pyH80Qfx3/64zYfSznB5/ZaOHM6/5BCHQ38lFZWDl
         BBASTSyxvuohSulmRSZHFXNp1Bu4F1OZ1iQFdk2ITvG5UTynitjtiPeTvFpAY+5bS7m9
         b59PBagt9dXQTBotFOS2dy6KY2ccmeM6GgYVmTL1wSKDt+ja2w2+IEXrn3s3N52jnOSq
         xzA2GPvXatErjJdu3oVwdkFHeAKxtvYieGMINMQtSJpLjjo1Aupei8jaNmBJA/oMY5si
         Y5MS71EOleAR+AKxaVG5yIDHOxI9Apb/0SLXjcBXS+VOCiIqywaqDFN0D/oUTcp34Pu1
         zi0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760929892; x=1761534692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DcLsfJON0lJjNOupQsAXtJtd7DDEJTZNiP6jZEns7kk=;
        b=rajqa8FpJONoLTGHO+Vrox0rGptJSiPTSZBEcNLA2XMufOoUhtFSM/+8/ym5arH9lM
         SIuBVByLghB1sVMzyUUr6ElOXWIg6yHRC5Dy8QAqtcKlrE2aUlXVxcMF3NF8DgJ4ewt2
         ydzn2usVWspg2WuPIntFDzmZdlM0V0xzbiEc4/mF41rBE6hMTXhqAGbpq55s4JXLvJP9
         VXxFDZRWtD0Mn6OO4IXHCYhjOiepfaruJ+2OmMqyLruuBzwm4tB0c4LD3AmiaZ6Ozdmq
         LGfFUEBpw/xBWCk/4zrpNycScMlQTsMcePXwR1GlWxzI+2KVVtrs7jTABrEGD4NcNH96
         m4iQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyB4Fp3sFdJJ6C6LKLA1aqDJYJSVItbUZizOZlHQo4bfZ2EFw4If/JpjQOIJtL7KzWkx/GURgS9Q==@kvack.org
X-Gm-Message-State: AOJu0YzZTVyzJGADHTNo5K1RCB1mfyT9d3imIWgIjgmMGXfLz/XVDR/i
	MFIN4ulsj9CvncTMLdQyovrH3agWbcH7Lskvj6DueP/hJBxp46kwxDZj
X-Gm-Gg: ASbGncuuNg5RZNY1Kg1WgnAnT7I3+KSrv0sW5lGWm25BIgLwoCO31LtBZczc1NFhsKY
	4uQ4DV1OKdaAGtCTQDmOKaEGd8a43x6BeSTS16lpcon+Gf4LEjaMeW+ecUTxlvlQBCAwGEfN5O5
	BYqlrDjhVEdDzuMAaWc0yuFuUlEaLST+RTG5fgtDHtwKGfRjYsnzRfYOnWWO1MF29GlSr+qyDGx
	YnSEw3qkzfOOcVuTFaaSoRJ8euSHLX0jupEp/FrxpBwaBPP/6i5E194vC+XpSmozmkeEScE8Q4D
	EgGe2qJtb2tBn2l+oHOrgFc6jEv1ubLKogjFlefFY562eEwv+Ng2zFbbIoH2rkyrCnAP+0uqXag
	GkYpci/PiWboMaGf/2Xu1t4ZTLBfY8DAekRRpFOJATKNpKi5o/i+h+VJwJBnapJbEy9PNeZu46t
	GMdQ3KHMjYJG98IL+/PUEZv8SakXLycgYRDDCNG9wg
X-Google-Smtp-Source: AGHT+IFMHeuB2yTajHJ8tS5j2zdt34EIEn0u6ljuSzQNjGyzEgX3fDhahWmDGqGBC5JB3iyfLxZ55g==
X-Received: by 2002:a17:903:4405:b0:27e:ec72:f50 with SMTP id d9443c01a7336-290cba419bemr101429775ad.51.1760929892428;
        Sun, 19 Oct 2025 20:11:32 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:2120:6ebb:ce22:6a12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5794sm66007245ad.53.2025.10.19.20.11.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:11:32 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
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
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Yang Shi <shy828301@gmail.com>
Subject: [PATCH v11 mm-new 01/10] mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
Date: Mon, 20 Oct 2025 11:10:51 +0800
Message-Id: <20251020031100.49917-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251020031100.49917-1-laoar.shao@gmail.com>
References: <20251020031100.49917-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: k75umsnnmwi4dhnq3otzpomjbb6hyrka
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DEC240002
X-HE-Tag: 1760929893-346430
X-HE-Meta: U2FsdGVkX1+TxupAGc3AgtImgl0q6/TjtCtCBT1TJ4O7t70ktG/tX47xsF/jLXen9qBcg7mElWJRffbvJl8z+s3gR8hrpDCtuSgm8qKfTgodeVwniaoVYIc5hHjy3kYY7ojq8a4FqjuH6nzmiAro2+8LkbyxfATtDFKlgnN4W/kiMlJMWHJbS1SkopPMh06zV+8O/I8B9x7QKfYkXEqzkDco0Ulw4KNKIYCJk3tpKqQZsfoGzYjxFekgANWkRX+bPsGtEft8BcEINz452N0C29o56q8Ee2xKW8PwXC26HkqZig/YrNOFG/vf7v5FEHJ0UiHKnL8l0qlcXSuMu+QQybo1sv7CnEvQLT0tr5nAV5IpOOnL0/VLFv9qhpu9WQlKe7md+NJ7tQHRcAOhrITBW1Rh/kvNNGBEkh9WDJnYOshCpeX8we3DvcgiserJAVQRAmirZDFyQVN38HLGL/B9V7mHcjZ5wwRW0wuXyuPLf91qL0Ghs13ey466VdjuiWffuKpTK2jRD0c5guNMW2p+78w4v364kI4RE2u3JNKIYmFaDq0lX6dnivS+D8i+BpbLbXp6SyUjzt9oZbTQZi5SVvTyy9hfQLPDnofeuypm+YswWHqTDf1ilgYlYFM4KyW9a/zQRG3UWrEsgITbcjJEe2yyHkAdRT6l4hATyOpmH8Se3zcTni5qUSkNND9Mw2RTAchAVpr7buVkZm5oNcLv8x3Pj7QbcVl82UjIVi5mnDyK96anbWuq0BNPdoNOkymGCRFIaJBnDyjmLlLCIxTvomjZYJ1aJ1KK0CpTQ5Fxe2Skl74bNngHLQOWd4Jugi+KUflcI7wtN/om7KbSIhvb5QnzpX8IE/mbnCP/k2ZPxaoP8svg1kzMMwkGZYtsyCBWqRjtXWXISFtqibOWbOM/XbwsQXnIUlGbBm/m3JSjW6L7WqdmJwS+1oDSc/eWNtmd/oc4yf5vJBDfYsB1dn9
 qdyGIrnW
 4IkZiXnxrIjoInbet80usECzJaAaSyA/jP5RMi+3q5wUceE414uXFmR+6X3mW1+etCR1iGl2zUkG+fXCd0I/V3ZWVC9gpfWsPi5CL/ptlK4cGx0scYzgoldXKae+1kbUWWtFtjjwRgSZ9Tv+w8YP8tgl3RSBENkBVM6lHYjcVYYMTl7e/ZkcQAa3Sb9LX7nschzp14P3kJKgU3ondHQQ3+0jlXWlgPxiFW2k3qxbN0ZG3dbzeSiH6uMK6wuiwdkxJgl4cocdoLd0C+MwWsIOsO8V37XjCrNGOXpwTlnA4bUd2hoj0Xq79gxKyrD35eISf8awSV+jBTCPtUOo4SvTugFKGQBSOmvEbEBnPCwElFz81oDAXxEbCaEcWa1tKnIKzXy91Mgh5v1bwni53n90suZbWoZ08Kfdd088YlzDjG4/fLfUrM+Ry0Gj2bnp2cmWKTsOAISDyt+Shs4H1yfuhZOSVnoA6vg8WOHCJj0DkMOctxX7ciYbn0Pe/7nGfcRVHVzDCd1mmIYoucokXVcao2dtbgV1fXPoR06fO7/pehLxqUUBmXZhxcazMxl5fJgvapkCdbYKlbmTkOL+KhdDd2JA7kuXXf3NwvR6a
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
index bfb52c564fb3..ea3199ea98fc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1390,7 +1390,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e947b96e1443..c2c683f11251 100644
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
@@ -457,14 +451,21 @@ void __khugepaged_enter(struct mm_struct *mm)
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
index a2e1ae954662..64bf384fc325 100644
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


