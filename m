Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66ABACA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21328E01F8; Fri, 15 Aug 2025 09:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7998E0003; Fri, 15 Aug 2025 09:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7E38E01F8; Fri, 15 Aug 2025 09:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B12E8E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:56:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B2DD136BEA
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:02 +0000 (UTC)
X-FDA: 83779140564.11.B6BC191
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2039180005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gOOXzwZY;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755266160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjAM2kVPg7HSAJDIq3Fm+b8P0QFUYqeRJ1MrMImZHTY=;
	b=YI//7jAjX7yQN6/7McWlN/cI3p6CsiGCq6GYcWfSRGw5dldldl46Zs3xi/2wN1rWu7Q+gH
	aQZCFtn7MmcaUANdJ2FYDZHGrTdcGVzmlb9zi6WrhMXuOtEiqQqTH80ZLTRgzV5QOGjQf9
	ThXl9RT13NXIrqEuSf2e5AgCeaBLYWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755266160; a=rsa-sha256;
	cv=none;
	b=xBKl2utkzFH6cdj8+vNt2rLeDdTZ9MdGFq18LYS/9ZcFuOoXghdWQwtO2zLhxpMHNV6OE2
	ppZqrwoN1WvsirBfuVMXEX+2PJkkwiDJNkO6tpuiVxjkRWWWLSRsRexONrvNkc6n1jJTFa
	GMjd63yJ9vYqEg4X0xOMIuZCXWa9nZY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gOOXzwZY;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7e870621163so131891085a.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755266160; x=1755870960; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HjAM2kVPg7HSAJDIq3Fm+b8P0QFUYqeRJ1MrMImZHTY=;
        b=gOOXzwZYGkaHs+fcuNh/rA4+ZKDwEtkEnKIkH0hvYAQbacJk04Jp0XS3NGWIXJUiKv
         ZUEEdUIkILFT8dPApdx0vMs7dTGAwBNJiUawsjpkimkFyLQjRoBAWssoNZrHBuBv2ugM
         p/ss9S0+/CDckZAT/QuG5t0ZmmlRFm3pVa2GpEr42hxBYvVxbD6gIOkiy9Lk/tC6yCpu
         oxbtTDknsTg86ivd2+SCD6pdIW5bdfvRfakA9pCJD8NBI88SyJzLNF2ZfF+codLIH6Wi
         FWAKsgHzQAHED048dom+g6ago1OTdvnErFTDPq49LwRaFiNlrPkONq3k89WwKFr/ryVJ
         KKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755266160; x=1755870960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HjAM2kVPg7HSAJDIq3Fm+b8P0QFUYqeRJ1MrMImZHTY=;
        b=eTkdg/BAllV7X4sJz6wkh3G6DJytGFKifjjvRB28njxym2BfgQ3w4wiJ16TcQwmHyC
         rV9TD1yW3TwiwuAtUJf4LiYttNLBz0V1WWKoL4p8KNGoqYXiILzoQkCiGEF3lbUR5qZN
         nZpSFB28OhvfOqlNh4ugseqTl4tSBEgar/mcIxgo4l8+l7x/tm7OD+pdRUDN8R+IUS2s
         1IKst/vHzroUj/BR6R0jy42GBr9MELmRsT+YioUZ/SuXNrwOJUIcISFcMbjwUGLLqlA+
         NKLr9CO5R4tkDIN1SK02Z7bF1l005on/5TuNSJmnQZcfIVddA+J8/gP464+M3jDlCOzU
         HeYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLbZ8mY+kvVzARRx+5JZTFP8Lj3d9wlznGTWH9RVhlb+6uaL9o2oFIiBoBCUekYGbOOCegTDkJkQ==@kvack.org
X-Gm-Message-State: AOJu0Yxkkt/eF4mlbrLZnslV+TdBWINPHiviLj3AFmePyyrJKyaqL7vP
	GphDzAMyQ1nYLkL7EVYEZAUG8r8g0+CIALHN2gFzfbM0aXkwWOXJcup0mw1bxlS1
X-Gm-Gg: ASbGncv7iJIKAWbmoKNXKyW6C0Q8iRPB/ndD/ih6K/tJnNbvKFMvM7phfakXLA9FO3a
	Wa9py113KCA0P39ItAtoI+hBvqDCHgOE+unqOjg6t1JAmeBm8YzYDsoX1t/0o+RVqGnMYw3LZWx
	ctAeiuZKynSllcbzMNHsF7dG+1g4kH00Z2yGv5ZD+C9+52y8kd/NGo9+cKhWirCygSy5Fbsgzvw
	jqBYSsI9krhwQWcXSicObYK0y8kFd1tI6CtfwRNfCXhQjMBoqybMfYz1fbNz41OiKAFLwM+CeX4
	S+/Ro2JMnuyIVUrtk4OoprtAEtN8L/WyliprV6+mx+HFK8XHrjmJNppxZKUNCxFFvYJmTQD0afx
	3nz2mzS0lqFKeEqZjIuva
X-Google-Smtp-Source: AGHT+IFF9RW9CTYz5caN0M6+lm/SBlFq7E34PjjRXGEeqVn4nYoCKB9rubR5z1M4MA3PdwlDkbJAVw==
X-Received: by 2002:a05:620a:370d:b0:7e6:28d3:c4df with SMTP id af79cd13be357-7e87df87270mr299191685a.14.1755266159571;
        Fri, 15 Aug 2025 06:55:59 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:74::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e87e1ddd9fsm108971485a.71.2025.08.15.06.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 06:55:58 -0700 (PDT)
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
Subject: [PATCH v5 3/7] mm/huge_memory: respect MADV_COLLAPSE with PR_THP_DISABLE_EXCEPT_ADVISED
Date: Fri, 15 Aug 2025 14:54:55 +0100
Message-ID: <20250815135549.130506-4-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250815135549.130506-1-usamaarif642@gmail.com>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2039180005
X-Stat-Signature: zwb5mo14pah1753zegnpaa9fy5c1b6r3
X-Rspam-User: 
X-HE-Tag: 1755266160-20046
X-HE-Meta: U2FsdGVkX19jLd8oGqpzsLE2IJXx3mEt6uzzjJ7yeBbwY1U/L/SFt+Hbs1UpT1EdCMqIkDfEmoDtUEVCegoxqQo/QbFXIaIHjJV15gWa9t1efiHfhLSGvLABNOE0c4zBLVBxYhhv9BFCajvNeQtXIwZ3WhjheaRltVAEn6PrAPHGmn87NczeGDw2QlRzA+T1rHsFg0DyURJxxGEjZPH/ImzUgjN7C0/mUZP++rR9nDx2AvU0pjO29czVMSESY1poUUB6ssxiCgMD1VMw6/QwBWS5JRFQipnVyp11rRZvF5ZSZgKnVn/CdnVc+It6BI1Mn4zxNRi/arAZlgDU1wYyBg27sUI27WCcrrf4TK43MOyR+frAxdHKBBw6PbYwhV2vqvQJRC79cI4NJT0F8td6a4wcHct/VMTODSPoEsQqna2dm09J0g64by2VE/wojhm7WMzOOwo2KWIS1ub/cU2WGfe15r4SANTYltVpE6+9aq28fhqqHZi1RRqVmpEdp7r+VayHqc98PYJuC6AMt8jZ/7NJYc0G7m6N7N9N61QBjiEJzboYOuf5oFiM2tm6b+d7Za58hY8TsyvsGD0KtQKx0NNUYU46Xfn/fSh7uM2HbXJ2PeLKXqKGwgZnZe6lopMXYOsdq3+piopr45EyiMjVkorME4g5L4WEgED3ehTxCnhtuV3HYhzxVMHKft4UB7nz4zmqGdkIZkUYl9ntWHRGuGKV0Wx4PRh5ifhl9J8dYFclEX7brD065EFfT+hUmjNfKZXRql5u/ZckwE2wNtr7I0EACxgpIMZVfmSQQ1rSqoRDulpuNHacaUHwGaLc9ZfVYuTTdtSwYZWFd3Er63+ny2Eu83782GXEMnih6IQ+lVskxCWruNe2HSM/llGTnxcTDvUFNCr/ylcPkvDAr599QBE9ElPaKQxYVHt778P+2GfMnwVPlNPcBIRTD8V1E1Fyfu50wwWundbm6Expcto
 92lzLnOg
 THg5YYi91HfMtt6ipjiBW5Ky049gAwyFrkPCopaey/3dfV2Svoj4YRUs2USu63OgojhLTKTi/Jw3LbA1toF5aB6O3oz8l8S4xLPcKucWdsO29NtR5OG7dC274ze03s1JrsUQmifNp1VJ8JyisehDA50sieoHuSRjzSPVlKb3/AgVYpiSxJvw2p/FPvVbiBms3KZonBwar6p1q8eg7x5yCClthhwrEB5hecpfeNpcktOXTKcFK1W/PYSra6YF1MabpXNEH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

Let's allow for making MADV_COLLAPSE succeed on areas that neither have
VM_HUGEPAGE nor VM_NOHUGEPAGE when we have THP disabled
unless explicitly advised (PR_THP_DISABLE_EXCEPT_ADVISED).

MADV_COLLAPSE is a clear advice that we want to collapse.

Note that we still respect the VM_NOHUGEPAGE flag, just like
MADV_COLLAPSE always does. So consequently, MADV_COLLAPSE is now only
refused on VM_NOHUGEPAGE with PR_THP_DISABLE_EXCEPT_ADVISED,
including for shmem.

Co-developed-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h    | 8 +++++++-
 include/uapi/linux/prctl.h | 2 +-
 mm/huge_memory.c           | 5 +++--
 mm/memory.c                | 6 ++++--
 mm/shmem.c                 | 2 +-
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 92ea0b9771fae..1ac0d06fb3c1d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -329,7 +329,7 @@ struct thpsize {
  * through madvise or prctl.
  */
 static inline bool vma_thp_disabled(struct vm_area_struct *vma,
-		vm_flags_t vm_flags)
+		vm_flags_t vm_flags, bool forced_collapse)
 {
 	/* Are THPs disabled for this VMA? */
 	if (vm_flags & VM_NOHUGEPAGE)
@@ -343,6 +343,12 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 	 */
 	if (vm_flags & VM_HUGEPAGE)
 		return false;
+	/*
+	 * Forcing a collapse (e.g., madv_collapse), is a clear advice to
+	 * use THPs.
+	 */
+	if (forced_collapse)
+		return false;
 	return mm_flags_test(MMF_DISABLE_THP_EXCEPT_ADVISED, vma->vm_mm);
 }
 
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 150b6deebfb1e..51c4e8c82b1e9 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -185,7 +185,7 @@ struct prctl_mm_map {
 #define PR_SET_THP_DISABLE	41
 /*
  * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
- * VM_HUGEPAGE).
+ * VM_HUGEPAGE, MADV_COLLAPSE).
  */
 # define PR_THP_DISABLE_EXCEPT_ADVISED	(1 << 1)
 #define PR_GET_THP_DISABLE	42
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c716be949cbf..1eca2d543449c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -104,7 +104,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 {
 	const bool smaps = type == TVA_SMAPS;
 	const bool in_pf = type == TVA_PAGEFAULT;
-	const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
+	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
+	const bool enforce_sysfs = !forced_collapse;
 	unsigned long supported_orders;
 
 	/* Check the intersection of requested and supported orders. */
@@ -122,7 +123,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
diff --git a/mm/memory.c b/mm/memory.c
index 7b1e8f137fa3f..d9de6c0561794 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5332,9 +5332,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * It is too late to allocate a small folio, we already have a large
 	 * folio in the pagecache: especially s390 KVM cannot tolerate any
 	 * PMD mappings, but PTE-mapped THP are fine. So let's simply refuse any
-	 * PMD mappings if THPs are disabled.
+	 * PMD mappings if THPs are disabled. As we already have a THP,
+	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+						     /* forced_collapse=*/ true))
 		return ret;
 
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
diff --git a/mm/shmem.c b/mm/shmem.c
index e2c76a30802b6..d945de3a7f0e7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1817,7 +1817,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
+	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.47.3


