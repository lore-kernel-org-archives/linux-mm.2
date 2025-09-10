Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6541CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400E76B0011; Tue,  9 Sep 2025 22:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8966B0022; Tue,  9 Sep 2025 22:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EEF86B0023; Tue,  9 Sep 2025 22:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D22C6B0011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:45:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFE9486E3A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:17 +0000 (UTC)
X-FDA: 83871799074.19.FE3DCB6
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED89B140006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qe35WUAI;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhCL43VUSjorkOuOskO9Is7n7PplBlIp0Kbwah6VXOE=;
	b=z5Ps4Sqgc+oJU/mfXjqPy5iUsnVKBV4j9mgIUenenfr8bziLUBbjVIedoSgExensvHey6S
	OzgXF+RMQnUoLU5C9tXWfcZ+rjlMVbuKJmUrFWT1gFmrepSj16FhlxbN8W1t3i8xley8Zs
	Ay1mPVG/Mpo963w8ZoG4mWBI0oTN5N8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472316; a=rsa-sha256;
	cv=none;
	b=2C1wK5kTyHVC1LouU8CpyZmIc67Vb00uSxn2e389aAZP+yyG5cT/9wJ7N9oa3c+WvOUkhg
	vIqzsXVbxZHfVKWSF4ohvkABNbI0q9IOPk2TDD0lP2bd6cFaq+B36G331K8PIlepldwvE2
	EKJuy8qJRrlQdTJZ9HHt36xXVT2CjPU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qe35WUAI;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-323266d6f57so7033883a91.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472315; x=1758077115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WhCL43VUSjorkOuOskO9Is7n7PplBlIp0Kbwah6VXOE=;
        b=Qe35WUAI6MAGTAFiuEaJau7UwgA2MLQVc5KuX1Jtt1+J7Ociww4+FebLyIpQusr9gp
         YD7szQ3voHVZVXw9hLkjjy7Eek1Q6xa0wzpcE7iA+fXgQ+hKO/NYxPEu0PhlvR5rnYAp
         AR1+Lc1dPk3iI0yz9oxP5Zlzd6fA177rqWM59btL0pzQgg82MSWWVEBns8o5LRU08F7O
         NdoBEfpL+6/5uJv55Ygmp+SwtQ90JyEiRlC1rYbppoQJGAL0yoFoJLXHEkEOz4zIiLr9
         pJ9XvTcGAOMWUrjFDY8CZXGCUMtxRD8RcWYPlsKOsqXy25+/MmaId1kt/wbeSVNv6+4Z
         nMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472315; x=1758077115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WhCL43VUSjorkOuOskO9Is7n7PplBlIp0Kbwah6VXOE=;
        b=PHeyd5ImCQ3VqEBgdhOW61SkiJynojxhUKcYFxrPFrtREV8tmyOdNqmWy5EcWphDDa
         fzyBvwOhfvg/zJ6KfLS+cG5Pp81F/iFe/37WQW98JVkdDytOiIiM2v2RxQWtunT2BVB1
         AORbF54z1UYuLcQ+Kgt4KL7S5N9BbsU1TW9ytLP5kFI91RwdYlJ9xIne3tKr+ic7LRTz
         OrLgYqyWWaH4cAtApavrZvULAH8X4qIMaDCtnEh+gvjyj/I+wn9m3Ki3UhGCA8HTncu5
         VkBd8aQYuGop8PF5vesbYXOqX8L1UGFxWLFbyQMYdVJGSw9o0kksiZc2Es5tkV0CN0mU
         BGNw==
X-Forwarded-Encrypted: i=1; AJvYcCVBG+Uah6d2Fs47CxSMSAdqHSWIEpAHwJ81ld014tSmwFBGfc6lTxqh3TTc3DoKWu21uNr82qH4Ww==@kvack.org
X-Gm-Message-State: AOJu0Ywli6ibeLzxvEtmtnXO3hyCFOy1vOsXtNCKhulHtMgXc/kfbRmf
	X839buAP9ScfOqqkHX3VScXvPrxB2PhgJdYDoKE3aGWso5aRumY2ggTQ
X-Gm-Gg: ASbGncvP1jiw0qrpVkDdlxrNobV7KqqG/ZkIQ7M8sUuji+lV5qjsrC5jJSaT6E8ngj4
	BS4qK2DbbYb7xXqCdm0IzreAc8u/2+175W5e3+YK1KBK2b39vljJ1VVrOzDjuF05wYBGY6F/K2i
	Nze0YD3rQ4xvjhAM2G/2iaPQFC1EUyp7e8SXgZQ72YfO9OHXp9p7y0TCvHXvWeZvtR+1ZzL2vN/
	ZQVtWivO8GLhzQGim5+XNMBLzmln1wO+fClMsRqkvnoxIm6lRlGqb+X/Ywyi9tTEVoAf3UazCu0
	zmDhXKofc1smwA6qVhVHqqV2lGsYeFCWQ2Fxl8S6Xajc81ZQtf3aG7jz7zV2UOsHMvi8Bt2QKDB
	7X89BCBZeBtIKqd6MWb0E0JqkLeMc34coZx+jWQG2Pswrdgk6bur59K/20bobEqawDmHQgINSaY
	u8jTg=
X-Google-Smtp-Source: AGHT+IHVMJs3gjlx25QtzwLeozXSFxDxX3vomXFV/6WkSK5g41a+qiePUUHhw5pn9woB4S9xqmZy2A==
X-Received: by 2002:a17:90b:350b:b0:32b:9d3c:13c4 with SMTP id 98e67ed59e1d1-32d43f8ea76mr19311149a91.24.1757472314798;
        Tue, 09 Sep 2025 19:45:14 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.45.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:45:14 -0700 (PDT)
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
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Lance Yang <ioworker0@gmail.com>
Subject: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from khugepaged_mm_slot
Date: Wed, 10 Sep 2025 10:44:38 +0800
Message-Id: <20250910024447.64788-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o78ctaao865trtmot7mcpf5ik38nqczd
X-Rspamd-Queue-Id: ED89B140006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757472315-245746
X-HE-Meta: U2FsdGVkX19m3SbXYq2Ap3e4qW/BIBDnvuyRkOC5kbufRDPKpuhdxvBK8GFb/OzgJtwqIdKhYFti5nRKoKww3vMgJaGcVZDjurX3r3B1UcNXguT7Merg9TMKjlqCBJ3/zuFRTArA/J559u9tJ3V9WIp2Eca4HwmvrfLPpUfxmx1ZKrbY3Q+LrGDh1NN7v80XI3QbSNG0Py3QIShEzLVRRzZCIaEfVcLBuRz1No3rOGbGHB7MF0Ed5f+Oi+PbaxO4QzrI83qiTx6HkRnNWadAqV12e2NKbORjSvR/jT+hWlBGdnAfplerb6vJAggbwSB09yXDrmsjFdhmcutfCdcI3ZquXXIxx9Im1abGhOrBKUH3ng+wr3GqK33ICjGoljx3KzjgKL8/iN8Ur5h116soG6RQfl26qNOr1aBWq+hQK9XLRcMgozsCDv2Ze2J2P9qXegAsm1C4dxUy7E17XskH+EBHnUWoFVsRrDmkLu29uLTsTYsbKMb/NbCnak62XAwbuKJXOOIx7Fyv9yAix+/UR/6Dgu5uf9CZdXdg+n5uqtzV9nPQGSomaGw76lqD6WcvJjdq7/h/yzGG1ZH/cZnPMy6vhmV+DA4X2t+BPBAxqzO0cvhdwHxTFmT5UiFm8R7PKKVAd4EFMcP4wNdkxsv5akcL95nHplIe1dJ1wR7B7Tn641gydys2MLypDZxCp7UGCjXuYcVbKKztKiCSd/nqoFr4kfTb/M/lOK9fOnXdroaaqM4XQYlQ7ASbS3EE7uPdU3Z1ZZXFUd2AypT+iQ9fgYCrqz/hAU0KyXTmjjmB7qtJE6bsq4p8eYJlhR+gq2sdr98rPSUQWLqAWdFNtbkSIx5RT+pJWmRDoFsqdYB4wZgcq7X/thK3RTyBBZyDS/HTGyH7flR6eVgzhvrkX8l3NmovspNdLrDu0RoBRFljfzxy4qCh8kPXrqvxzmDGmMYNliNgU98RiMoApbGEKm7
 rvxMqcvI
 BQYyUlbcH6hdvrL4upU9YbjY8HTAjS036ksZxKORtKLUDCuvQlnVj1melaVneXzc6JQQ8Spd2SYDpYabN0GJ+sVYGc+i+wnKwS1B1zdRloP4lxJUyxRu2tgmlYZFuYTBe7w1/pMrEmRsusaKRSjM3Ca5EdTyG1sNo83VIvRWcIVVYGzEImJmEHvnIWDWRZZ+XaLIEFZ8jyQDT+jpQnmvwCRjQwceFNzB26pLEnfQvsltQksqRAjTgq6Xly4vN7Y92NVgDFmptxEzVh0OrtHfyiIAte4Dj6tL8iD/jqaxcW5CH86LpbgBJe6VM4lw3c4Js8T/bpZnl0jw7Y73DEaEjE7mLQRJzunBLtKM5/3vvnIqxMr1sCp3BEYnmBk0MYCTWbS+OitVD/ICZXYilXG2xyoiX9GFvxo0syEX/kSyREV8A3KEdqokQJK9LVbDC70x5jQKHzunYVMI8NtBa4JAJ/R/BT5IvD6EHpzPOKbClbgOENmAvktv8AFPqF9ItVXSvq74kAnpEa0M56WVhwtgIt0Qvh3uuZsdjpRRWFvFi0I3kLPWKvPGS7MpxDTwMDb57tVBm/kKw4uhHz8PdaZRPMQpDJ0ivxVLgU2nn6c5lGO0/T9EpETGhfTSgwcEBqRUaLJQj
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
Cc: Lance Yang <ioworker0@gmail.com>
---
 include/linux/khugepaged.h |  1 +
 kernel/sys.c               |  6 ++++++
 mm/khugepaged.c            | 19 +++++++++----------
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index eb1946a70cff..6cb9107f1006 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -19,6 +19,7 @@ extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
 extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 				   bool install_pmd);
+bool hugepage_pmd_enabled(void);
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
diff --git a/kernel/sys.c b/kernel/sys.c
index a46d9b75880b..a1c1e8007f2d 100644
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
@@ -2493,6 +2494,11 @@ static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
 		mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
 		mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
 	}
+
+	if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
+	    !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
+	    hugepage_pmd_enabled())
+		__khugepaged_enter(mm);
 	mmap_write_unlock(current->mm);
 	return 0;
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4ec324a4c1fe..88ac482fb3a0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -413,7 +413,7 @@ static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
-static bool hugepage_pmd_enabled(void)
+bool hugepage_pmd_enabled(void)
 {
 	/*
 	 * We cover the anon, shmem and the file-backed case here; file-backed
@@ -445,6 +445,7 @@ void __khugepaged_enter(struct mm_struct *mm)
 
 	/* __khugepaged_exit() must not run from under us */
 	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	WARN_ON_ONCE(mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm));
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
@@ -472,7 +473,8 @@ void __khugepaged_enter(struct mm_struct *mm)
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
+	if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, vma->vm_mm) &&
+	    !mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
 		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
@@ -1451,16 +1453,13 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 
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
 		mm_slot_free(mm_slot_cache, mm_slot);
@@ -2507,9 +2506,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
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


