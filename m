Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358D6CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5233690008A; Wed, 13 Aug 2025 09:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D553900088; Wed, 13 Aug 2025 09:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D87290008A; Wed, 13 Aug 2025 09:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04745900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:57:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBFA61A03CB
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:34 +0000 (UTC)
X-FDA: 83771886828.03.E625826
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id EB5FF4000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cpjGOpVc;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5zqYBDHJl9ahDn9th72JcB6czovc9uCtW5RO9v9njY=;
	b=rUg0ebBQtuKR5A0BMykksyDgT4nV0aqx6ap/WsXmNbEkljeD99lm6kf/FkdvfgxaZTvnYg
	LIQqkTeG+oFelcmDpvFSI6AfFCncntpr93kzrrcKoVl+vCCQyeLSzJ5qm3dPbWcmqre+vj
	9aAJhhAT/i4vm10V9jOa7EQst9gWCYo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cpjGOpVc;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093453; a=rsa-sha256;
	cv=none;
	b=Cszlv3GldyFt7wKmQVYqGmat3DIUWjeJMP6/T93bPNVibnor44sowHs766tj2Tr2IlPIZ5
	5BjcwM/RUZbvWFcnuMBj7S+y5xQVGvnKXt9df6veM9CUx5kRMK8HDMgSaaZeQYe6VeCbIR
	0PHXu4ElVhqFNSWzhr67AMKVw0jCArY=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-7075ccb168bso53404426d6.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755093452; x=1755698252; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G5zqYBDHJl9ahDn9th72JcB6czovc9uCtW5RO9v9njY=;
        b=cpjGOpVcw0Ehszqj07nhHINzG2BWmkKdRFUCFkCgAzzTnELCWX7wDqSzXzshq840kd
         YG6R0IOoZ4J9b50EhixkMhgEPi4LFbluT9dJoZ0QEsHCPpFgSN8YgL7DkarQnSInwO9F
         MFyqX5RPPqKuj4L1pn26SgaDJmb9zbvUqPRLaFmcpV0fmGguoZR4fiKjh8DEZ9VP87Nk
         D3RA0hPsQ+mS0d1sNcVV9XicSgZVe8Mlhi1wZjxZxrAqMuduKSVJWcNz2hNQ8ZEVqY5f
         B6ZOHV6lq602G67K7vSx2B3IDE8rSx9TZF6+3pXc9DLpHYobvYz9JxJZqUw95AxdzVbg
         YuHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755093452; x=1755698252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G5zqYBDHJl9ahDn9th72JcB6czovc9uCtW5RO9v9njY=;
        b=pmCo6vyTsfTFyME8ydkO3efkNnmLbaGUOM+QXf8A9WgccXEukORn0hM07pxVtdfdwS
         VEjxcxFu2iI4NLet694zrko5+9srS0R712JqgEK5B3A/EXFiFqGGwtV906wRzp349PqK
         IFAAAAqKa7bM9Yif9p+CSHaC4QV6lwRvRMMPIih5jtDV4ARBpbfHqfRF+wkq93gtr1cQ
         pvZu8RtiARQdiXUV3BTtlZXsfS0rau62muhWAx5l53Knl9VpCegsGCKUHLHzvoXZXDcT
         31C2DaLjtUzbf/9KaO/hMtcMR6l5JlYBenk6zlKVrChqCj1E2iK7Rh1LCYbK0Zqo5Abq
         X0iA==
X-Forwarded-Encrypted: i=1; AJvYcCVX3YWiwOdsuJjE9Dy/ZPPSa+cIMrGxIDHXksi6E21cvRu7HWvSTTanSd7oDiMuj503OkMfGc725g==@kvack.org
X-Gm-Message-State: AOJu0Yz5O1ilS2VMNfA59xI2j/VQcJ183MQoXePk7DGKDI3fWOoXvC50
	LV9Uu7YN0reXPa+NlbLqNto48wk14egpdgQrPV86K8ErgB1bAFFSgf8p
X-Gm-Gg: ASbGncvGheIMbho+Xde15DnUt/0mYib9AjU7EB0JSvXTVGS0dOY8ZDQLFu/NMm9T3kq
	WcpQvJWOp+S2qx2XoX0juSjjCcXjeFbUR6OjzUjTZ3YhLDjZIrbEum4vGfm8jI1dgWdvPXGW9yr
	BU5Fku7I6wH/3yAoSCMwFNcYaTNo2kYn+/rpHBOXzYJEs2rV5qMWjY+wF6AeuJ1TtnHKQu7UjdV
	bxR4RMxUZ3z6PP++5DeiO9+lWQQF5zAiDAu8U0JCo4P3Mnxjh5pTfdkq+5jy7A/KBpFIA4hCaB1
	lVJFBtLDFvysqGbvewirWTsg/uCKWLCPER6/vadB9jR1T9hH3smN1jX77L9fiTcpjCLSAGGrLi/
	0rqRsIwseP0ghGJkNigc=
X-Google-Smtp-Source: AGHT+IFpHk5pQBDYwwsiLWpQpbOPKy4lZ7v78aysy0xnjiL8OlSxn4Rht5C6ZYA1xIGMHAe6XCbhlQ==
X-Received: by 2002:a05:6214:519e:b0:709:8fad:cd2d with SMTP id 6a1803df08f44-709e89f7a9cmr35795856d6.43.1755093451573;
        Wed, 13 Aug 2025 06:57:31 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:1::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ca363fesm192739836d6.31.2025.08.13.06.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:57:30 -0700 (PDT)
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
Subject: [PATCH v4 3/7] mm/huge_memory: respect MADV_COLLAPSE with PR_THP_DISABLE_EXCEPT_ADVISED
Date: Wed, 13 Aug 2025 14:55:38 +0100
Message-ID: <20250813135642.1986480-4-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250813135642.1986480-1-usamaarif642@gmail.com>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB5FF4000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: emuwdjq5r97ir6asyubgapu1q85rbgg1
X-HE-Tag: 1755093452-557683
X-HE-Meta: U2FsdGVkX1+bg42ou2Ok8c4IB5he4HysAOzbeaPAWAqndm9ca5cNr3PKD6MD43sgyWSf+Y7JIjBvt9RM8Xw0B8CwpAJovesooL72iIQUkiy1m3i7cVZqYkoNyV3IrNtVHjqq/4JGwbZDjbMnFijiHzxa6bzNSISMaN7+E3fwtnCzBDzT2Tdz+SRNqwE83ojJ1gAfEPYsQ+3ghI9EVdVNYOCt7xJ19Gz4Cl+BZakxtNUoGk09cP07l7n6clmL9CIqZOmraMMFyEOUZhmwCYFKo35SbPT3Q7gj1K55mPLJrbyFKFWu1Vzdz4tiUe+duLrFHTQU0JxanFqI0L7B7C4MYsqiNdo8+ZxWwZiLJyGVS/bbpqxOnT73hOItnnAsb8E1yHnsHhf8g3Y256ErkMvU6U1VDlOk0Pa4VeNOl8/3uW0frUgHSHpCOzR4y/Q2OoISCaKg2LUdUHd+U4DKHwhQOHU9DzYwcwZiz+x8ARyakwdUicd1r2hnKRi8WK6vShag94useFUZnbzXMmI5r5P9o9mgO7wSccGpDRp8ZeoHb9Ddt3YQvoX4qxaMZnog5yMfxFc2g+qyFLZWW3enuxUz6SFUUyj7NDSJQ5RtomSU/DmzQfSWVLTdWzATDqlUA1rjUdQhI3fyTgxUiuDgBaTfqTo8XWrps+guRYkppe7jp9VTRT0JhJPMd+HWfn5V8VXoZ8AtH9xT/uiL95rZ4XHgdS/pRPmfAMBukWtUqhmU753055VAQQ17RTsdAdXk0T3Wh7pCkR1PJ3CwJ1e9Tf5hG04RGm2BqOM/0a0A3dIs33brNRe99ZqtdluwLIS2X1HR/KoW9BuZ0PwHX95uVNajBqCQ+UCIhmq7tJQpQ1jXzjjC58Iq43hbJOF2tjDVmHyLKuMx+woAlB208FI4K4GBpqbOlDPtwWtBClox0f7ut8iDDZyA3MaaSEPNQGfnCtb4C+kqIBMOL71EEpiTSZk
 Em99oiWD
 fhTrSee56X0jCZWruUlSghtXJJiAtwzh2zTKxU8CBfzsdOHkJ3KUL8AAg+yJgScAuC/825q2qjnhAjScM8T7oNpLbDGa8Dn9jrZttaerPt0XCtMdEJ9l04lSW6VUsfHfMieZpJXe5v9X88q1FDIdXCY08yMFb3e0ZF2qG52J+lXPeL7E/z0A0QRc/165atZmymg7U+s407ujOLATSsjuQMtrcG39YAeq1meWuzHn1vWVS2un1nG0sd8yvlImEqjIdujbVIJ/lSNKn0mEUrxE4bBaExKQFvXI3EAUppy1r34+PF7OWI2iUIRLq6YiBWGF3Vz0aFiRsvcIRdSYnfZDXGs5R66Leaoh6VVKcNty9wO8EGyTGUhLstFnYkrqNTJJuZkDyEDUYaJfoubJFm7meoQauIMQ0f0xCqQjnz86+9/EeAkIhiILTPwm1swE0ZLotR0mlzkf4TsGSakTXjEpFYE/KkVw/X0fnTz4a93LCKE0CcqKfBEwUHBrLpTd0EEhz3FS5Qoe1HEy+39pnpdtKCvvWOGgJ9Z94ZRO7kj/D1OgfYSu96VuoG52MAnSx2xfL4vpRZpRTQK6qiV9uDOnyfW/OmhKBDGmZwO3RfJ7F4vDVuwQK4X1j8i0P+ENF9PFoleVEUDZ5rIyMtbaPaDp0kVMJUS2Wa0kgly25GnZEQoEkppeng5v/WFQaeHqzC/YUQ3qTpMPtL2WXyJMx3qnH3NdVVA==
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
index 7b1e8f137fa3f..e4f533655305a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5332,9 +5332,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * It is too late to allocate a small folio, we already have a large
 	 * folio in the pagecache: especially s390 KVM cannot tolerate any
 	 * PMD mappings, but PTE-mapped THP are fine. So let's simply refuse any
-	 * PMD mappings if THPs are disabled.
+	 * PMD mappings if THPs are disabled. As we already have a THP ...
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


