Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A0DCD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5C06B0095; Mon, 25 May 2026 07:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975F96B0096; Mon, 25 May 2026 07:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88CA96B0098; Mon, 25 May 2026 07:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78C6C6B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:38:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 136891A0169
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:38:28 +0000 (UTC)
X-FDA: 84805744296.16.098A0F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 29E9FC000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:38:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fgDkRLew;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7juNkMV5TDpUnlxcmv88D06LjDSQgKGBYnBfLIQ2xYI=;
	b=TvIb8EsOS3CZT80xhNm6nYI7U3Q3G8om0CEfSzUJY/4dLGHHOvnKRbtnseWAT9xIuPRSex
	V836ZTRmqSwt+PkHjxhFYYXBv2bGhtXmMLhb7ldqJv4DEFC7wlni2N3mzmuBeIcwtSSi6J
	bGwGdQtUbXpR9Gib9ZNrXhJDZcV8YUs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fgDkRLew;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709106; a=rsa-sha256;
	cv=none;
	b=2JJBRvYlQY6XPjWy7mnB/dD2i8PkbcCTQqMHPEu76WLnxqxx2INaJCN1qtJ/PmvTJ9nYJn
	R7h88b7azXr5BeWnZM3s2SWriYn4+BxHRX/Sk4hVrTuV0R3PceRgfx5mqS1uxhImnCLGcr
	d6hFhhkILTOmcv0Pt+AnDAbpUZilgh0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAC6460209;
	Mon, 25 May 2026 11:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0081F00A3A;
	Mon, 25 May 2026 11:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709105;
	bh=7juNkMV5TDpUnlxcmv88D06LjDSQgKGBYnBfLIQ2xYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgDkRLewuZxGr4+3E4KlrnizN/2k+trryj8j/PG3G0hhmLbLUNveOm2kvUKB5rblT
	 gqNNXMr+jZBNvtrsD73iKtx+OlZFa7HtTwlJjfjmzGvHJmWsvvjIA5981kgqbt0SbC
	 Bw6x5+7JBVMrJ0cP/5IEt6PlRdlZvlhbCvymZ1QHVvpBn9r6towbKO9RZvBcSe7u1I
	 zrTqwJOxRpJJPIEpy/TcenIEait1V1VmFWe1CBFciYaKH1wsnMmQT8cVQ0ruPYnPsK
	 nTkOKlmrQ3Wns/2RSkDH32PFecFrO/vLpxTSpxI+mI9XSuCHU51KBXmXawtoo5Kf4G
	 ka6vvbQ7ei55w==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0413FF40082;
	Mon, 25 May 2026 07:38:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 25 May 2026 07:38:24 -0400
X-ME-Sender: <xms:rzQUalfN_rPqI1ldElcjCeOYaFU9CBtY_g8-8k_PME0ZUN_vdszEFg>
    <xme:rzQUavHX6pbsZ-eWeGa9BTPEczp88SOr1AjQkJNA5-p10NZhPLRNiFDIxzvn_ll-5
    60OMqEMfB8_4jXV-Wq6RlEPkH4zghLyZSvEo6EsmWw4eX48jXmeNw>
X-ME-Received: <xmr:rzQUanWICMKmXZIrlRwnwIL0xu-ovguAzK29rLSjaamZ0F1Me4cKem_s54UBsg>
X-ME-Proxy-Cause: dmFkZTEgijbjjUCUhtY2VaKKjXb4gcimluwf202HZFDKxEui2BlgHuLI1UEEi/eMokyXuA
    a2E+X4+kRvsxjI6H4HIsnupxRR/h8xNVRKTfREZ/dBM1+bNmP6eZod0MlLM6BS3n5MLTru
    DFAPtuu9eHiW4wZdezaatBA9PaDtMNRtePvzx4xHdz5odRImn6rzmKpWWCJY57tyVM68hg
    6hiyI47tklKjeEZPc+OVuEyQzgGjohrHzOhn9CL0GB1XC7ZHOPHNqzO9SjB/g+CKICA1Pc
    hnNW6YlnLZWKYV9MguMVFQmjoMkYeCI94OvICOd3v50m1nVI2u29Wd5SJb/ZmMVY5A1HOt
    8qOxwGK+UagydTTI/8CYcTWMqZ14n+0AJOQ+yxyZkIno6xEY1G+7tXV245QN5Zh2Ml+aCD
    aZuF8aYZzrd8JWcPsUXqzNL3JzPfa8/VvhydiYbemdB5s5bqpasABrKv1WjAeiXXGQRBS5
    /UTXrwwaI+ey+MVGlVaVInOqm0zCQceJ/B0a/lio2f7YUimFKszqRCxfPq1Cfg2jiod//w
    zgKF9Bt7USHLdM+hHTabaXUubcyjRcafchd1xLJ2TaEMM/fZqXkpVPhIZlFJvq07QKHhyR
    jWT5/hRkEYOwT/sTjwAtdwomSTNVTjakaeNitlp8mGftnYkhfMsIN0MRG9Lg
X-ME-Proxy: <xmx:rzQUanyK31hEnOsn0geIpqRyR36nV2875OAJhpcFLBdhbIa5d_8CXQ>
    <xmx:rzQUaqtwMt--ZkpLYmxNtRWQFslr8Nq4RoEcD0FRhK3EoIJNP_dj8A>
    <xmx:rzQUagDBSNGpJmuku_3TvrzM5ARUCBtZiJQU9QYi0f4VlNAgzSwt_Q>
    <xmx:rzQUaupbAr7aLhvMtNHkOSpJR_oS2GTFc5FIEHZKSFGHmSvyihvkeA>
    <xmx:sDQUavaql9WV6ZwrLM1oqiDdWM1ms9Ej5eOVaYq6ln4jaSRa0ZCXzDF8>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:38:21 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v4 04/14] mm: add VM_UFFD_RWP VMA flag
Date: Mon, 25 May 2026 12:37:18 +0100
Message-ID: <20260525113737.1942478-5-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q4zxy51bzasqakr9mnjb6pjqr51go8gu
X-Rspamd-Queue-Id: 29E9FC000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779709106-749508
X-HE-Meta: U2FsdGVkX1+WFCPD7vQ15UYWx2bYFgycHvyOrWhWOqrcQAiqeYSW/bFpUIF0nA9y/ntH0hgFeH5pnipbnmwdiNSrxSXHAx5nzWh446xUO3/QfCK19UaZ3NSAQEFRbk3y7LpAnWGTYwLTaAOz4RYSIywAm0PCaJnhRhi0073PYzC0u73Jz8Dc4YM0NN07RhoXSzkgvMuBWrAYeL9PGC+9UVfT2ULx5pVhQHiiydPuKCkuNr+9zUDR51XzC43exHkQ10t73PLZ9yo/DUpZEp1UiXLiEM3D2HMfCJPycCofnXFd+J4ErSUc55JZUR9jWz+aeqn+cnDVNPI8Rb9FfqI+2YU71mtn8UujLSfqlC2OOWF9XcwBntBtlUFJB+b1BfTHrq+Gn+QE8FA3nxBjv1YqNvCtA8FzCALd6GuEcvc/c8zUOZmr2OkZNDIUwOGHTzJsJZraXOSlmQkQj3II1ugiEBxwnDiWEkVqDE59Xbphx+bqF1qJMw31CfvMdneBIDojn+8w80m28h2otSNPSdHVmfWkAAYi26gR3mQ0VRVXGkJOKuSYZyUcV+hDyuo3OQh2n1vS6mzGhMa1kGXlBsw1opW3a4tFy8HiF3lzFr7v8mn7jIGv7APRVe6T0uK6HUhHs8f7V7zMrvO1cx4Cmq7zkSevxtfPj3H0Q3efHO+9BliGyC0egGvxTRBqXm7yG+fhT8qSH47qSQn3PUUU1stItEE0qS9U52Fz0Vl2KjL8phGW6FfcAeJnGm01E0CRRlU3W+NyqTdYuNGHtClNmjHOoLGJqI41bcgcT1M1uZcQJl+q4rRlZMA7OH8RA2Kl1yRm+1sUOMDSrEuRpKzW12Y+dkF9fldyKdyb2fmvXgu81jumnMASRoC0bBN6GnlIP8doZkRduHwBkWov6afBJQXIn1vS1Nul1In//spdWNLYb33aDo4BBsEbq2yNNK+9Vn0W4sgc4mkvjYz6tK3UaqB
 NHdeniCD
 4raDVopiQGXCPXotqu1oflON6lP/J4uZ14ntmzU7dnVWbJMGr9nW0wwtZng6Th4KOct4xh+iC3FjyGrC48oyMH6gBlOoKQ8cryThz7v4/muwRsq5kNljlU3U1MnMU8O0nHv1xvu48JxehISSO1VeCaAcsVKt+9PlrBNvMlMxRb4iXihGL+lWr9DwcpoKYkAelFYxeda6KN+v/HzqVaUHxwWXTvEglM/qlEkHn8AZLjPCxYSyMgis8Ly1+pJrzcPjpTFdbilHN25RIV7F2daSLmmFqerQhLMHGZaKcp43IhHLqAioIApNyzIHcJRTO4N0nBYxmjJgs+tRPXdtPvcYNWa6lCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preparatory patch for userfaultfd read-write protection (RWP). RWP
extends userfaultfd protection from plain write-protection (WP) to
full read-write protection: accesses to an RWP-protected range --
reads as well as writes -- trap through userfaultfd.

Reserve VM_UFFD_RWP, add the userfaultfd_rwp() and
userfaultfd_protected() helpers, and wire up the smaps "ur" entry and
the trace-flag table the rest of the series will use. The flag is
gated on CONFIG_USERFAULTFD_RWP, which is introduced together with the
UAPI in a later patch; until then VM_UFFD_RWP aliases VM_NONE and
every downstream check folds to dead code.

Nothing sets or queries the flag yet.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 Documentation/filesystems/proc.rst |  1 +
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/mm.h                 | 28 ++++++++++++++++---------
 include/linux/userfaultfd_k.h      | 33 ++++++++++++++++++++++++------
 include/trace/events/mmflags.h     |  7 +++++++
 5 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index db6167befb7b..db28207c5290 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -607,6 +607,7 @@ encoded manner. The codes are the following:
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
     ui    userfaultfd minor fault
+    ur    userfaultfd read-write-protect tracking
     ss    shadow/guarded control stack page
     sl    sealed
     lf    lock on fault pages
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index cbd164f4928f..5e74dadfb1cb 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1237,6 +1237,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 		[ilog2(VM_UFFD_MINOR)]	= "ui",
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
+#ifdef CONFIG_USERFAULTFD_RWP
+		[ilog2(VM_UFFD_RWP)]	= "ur",
+#endif
 #ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
 		[ilog2(VM_SHADOW_STACK)] = "ss",
 #endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0f2612a70fb1..3d0a5ac3c717 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -353,6 +353,7 @@ enum {
 #endif
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
+	DECLARE_VMA_BIT(UFFD_RWP, 43),
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -496,6 +497,11 @@ enum {
 #else
 #define VM_UFFD_MINOR	VM_NONE
 #endif
+#ifdef CONFIG_USERFAULTFD_RWP
+#define VM_UFFD_RWP		INIT_VM_FLAG(UFFD_RWP)
+#else
+#define VM_UFFD_RWP		VM_NONE
+#endif
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
 #define VM_SEALED		INIT_VM_FLAG(SEALED)
@@ -633,22 +639,24 @@ enum {
  * reconsistuted upon page fault, so necessitate page table copying upon fork.
  *
  * Note that these flags should be compared with the DESTINATION VMA not the
- * source, as VM_UFFD_WP may not be propagated to destination, while all other
- * flags will be.
+ * source: VM_UFFD_WP and VM_UFFD_RWP may be cleared on the destination
+ * (dup_userfaultfd() -> userfaultfd_reset_ctx() when the parent context did
+ * not negotiate UFFD_FEATURE_EVENT_FORK), while all other flags propagate.
  *
  * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
  *                           reasonably reconstructed on page fault.
  *
  *              VM_UFFD_WP - Encodes metadata about an installed uffd
- *                           write protect handler, which cannot be
- *                           reconstructed on page fault.
+ *              VM_UFFD_RWP  write- or read-write-protect handler, which
+ *                           cannot be reconstructed on page fault.
  *
- *                           We always copy pgtables when dst_vma has uffd-wp
- *                           enabled even if it's file-backed
- *                           (e.g. shmem). Because when uffd-wp is enabled,
- *                           pgtable contains uffd-wp protection information,
- *                           that's something we can't retrieve from page cache,
- *                           and skip copying will lose those info.
+ *                           We always copy pgtables when dst_vma has the
+ *                           uffd PTE bit in use even if it's file-backed
+ *                           (e.g. shmem). Because when the uffd bit is
+ *                           in use, the pgtable contains the protection
+ *                           information, that's something we can't
+ *                           retrieve from page cache, and skip copying
+ *                           will lose those info.
  *
  *          VM_MAYBE_GUARD - Could contain page guard region markers which
  *                           by design are a property of the page tables
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index f4cf5763f92c..87a8cebd5938 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -21,10 +21,11 @@
 #include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
-#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
+#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
+			 VM_UFFD_WP | VM_UFFD_RWP)
 
-#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
-				      VMA_UFFD_MINOR_BIT)
+#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_MINOR_BIT, \
+				      VMA_UFFD_WP_BIT, VMA_UFFD_RWP_BIT)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -178,7 +179,7 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
+	return vma->vm_flags & (VM_UFFD_MINOR | VM_UFFD_WP | VM_UFFD_RWP);
 }
 
 /*
@@ -208,6 +209,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_UFFD_MINOR;
 }
 
+static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_UFFD_RWP;
+}
+
+static inline bool userfaultfd_protected(struct vm_area_struct *vma)
+{
+	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
+}
+
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
 {
@@ -328,6 +339,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+{
+	return false;
+}
+
+static inline bool userfaultfd_protected(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
 {
@@ -421,8 +442,8 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 }
 
 /*
- * Returns true if this is a swap pte and was uffd-wp wr-protected in either
- * forms (pte marker or a normal swap pte), false otherwise.
+ * Returns true if this swap pte carries uffd-tracked state in either
+ * form (pte marker or a normal swap pte), false otherwise.
  */
 static inline bool pte_swp_uffd_any(pte_t pte)
 {
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index a6e5a44c9b42..bfface3d0203 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -194,6 +194,12 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_UFFD_MINOR(flag, name)
 #endif
 
+#ifdef CONFIG_USERFAULTFD_RWP
+# define IF_HAVE_UFFD_RWP(flag, name) {flag, name},
+#else
+# define IF_HAVE_UFFD_RWP(flag, name)
+#endif
+
 #if defined(CONFIG_64BIT) || defined(CONFIG_PPC32)
 # define IF_HAVE_VM_DROPPABLE(flag, name) {flag, name},
 #else
@@ -215,6 +221,7 @@ IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
 	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
 	{VM_UFFD_WP,			"uffd_wp"	},		\
+IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
 	{VM_SEQ_READ,			"seqread"	},		\
-- 
2.54.0


