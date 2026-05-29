Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 173F0CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5776B00E3; Fri, 29 May 2026 13:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9CB36B00E6; Fri, 29 May 2026 13:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79546B00E3; Fri, 29 May 2026 13:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A59EF6B00DF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:27:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E21940274
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:27:59 +0000 (UTC)
X-FDA: 84821140278.16.7D665CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 17D6940013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:27:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LYykaHGE;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075677; a=rsa-sha256;
	cv=none;
	b=DCtX9rLTDYev0P5Mpwwh8akYQWPsSb5po7MIG+efpKhi08rE/YlFKl1T2FYW+tFf0nNFDt
	NVKNjFjLiWc2ZFoYRVP4IdRE7vP4EXl7lRPGsGbGYcfKyy4dcQoG+ixxKZLKbO7T/KrqpC
	Q/lfxFXNrFMpb60shukIG6i0zxTXPCw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LYykaHGE;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kPL22rrzi+QauahU6y1XS1epMwqoNAKDudDgPyn9b8=;
	b=3IPX2uCmD24yRxVODcvgUpMKfQ9DT3FtFy3Z52qysxoTBzkZtyL69k5KffoldAWz2tJLM9
	jY1o0647oqdDrRyQu3LuzDyQuyNW8eBEo+JwbXWeeOsMhCh1LBRO0DILw8/LmNXe54faDu
	ygABOzFzx9umziwgZvDco5xS8y86F24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAE47444E3;
	Fri, 29 May 2026 17:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E48B1F0089A;
	Fri, 29 May 2026 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075674;
	bh=1kPL22rrzi+QauahU6y1XS1epMwqoNAKDudDgPyn9b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYykaHGEvTd2TkD1e4znKhbj8aqcmqxNuCScLcIjCtPIoOBFAg4yIp33e+i6OEF59
	 xILf6BQj2cikc8EIVXA22dFndfyluB2JGCny92+8cAhC6esbQ9i4qaCdoVq9ubDIHh
	 8FnVQkQEMW9iG/imHkmiqSucpZVsqq9k0Ygrb0ss6hQBBHNRTsZENhcJn5vBSQ/jpO
	 7lede15Ko4K5BnQgfDF4jUMyNMsIi6J4InnGIQwU5qe26Ig1N7R53O0dBMXRHkMN5M
	 KkCw4iG195iBFEkXq/QQua46YdKjOtbdaJhmRTOKbeOVe/Vh/XUf/8st3yuwpWfB1o
	 EmVL5jo4WnnOA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id AD56DF4006F;
	Fri, 29 May 2026 13:27:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 29 May 2026 13:27:53 -0400
X-ME-Sender: <xms:mcwZapsP1rjBUxdRudPhbXu0el0Itgp12My4nnx2PNh71h3upoEHNQ>
    <xme:mcwZauUmyxrDshwSrQ4bXRXvWs0XLPtkXUR9J2-d0bPWWA8ZakSI9hfZIJXBnLqcz
    PJD_JPQdA_iBISwnxODrqDUq8KuXfAXdfoRXPeCu8DIloCXLPB1xJ8>
X-ME-Received: <xmr:mcwZalleadARnOe6kg1i_fzdEMvlClALkHrRPKcBjdrWoTOnTSQowzRL2p_xsA>
X-ME-Proxy-Cause: dmFkZTGahW8s3xjZ3arjCZYsPeROx1tHGGIOxZ4ZTborx5JIY1xfx8o+3Ks6DBHpwKdcBc
    M0LV7UYzyw5BBW/MLyCvRpPXH4b3j/O36w1UIutGmjGoZPWXllz5NGLuWKcGXqDNqja7AN
    LjyibA8JUH8LlxNww+LolPBmmXeffckfCMyZ3ofUE4q+w091KUDN+vWzLN57aJjrFHnLmA
    DJhoBTsevLB+L7lFnUlwKPgFqlT5AUPgwhCfp483ir0podeZjRFOwVO5acGk8d/hTIZjyE
    iTtkTrHlenKgPfeJb7TkHTrSkVle7vVdqqUtJoKJ+Cofq6CG9ZD2U9nUSpGxcnBPWB+GWq
    gPC1wTp7fcejRHI3Q1FCzTHBKt9o4RKI/fN91edtIJi4rsYCqiSgf9/MN9PyG3oVtWwq2S
    OAwDPArj+xnGVYvnZdoZqf1pexBbR5njpxL6C3GTR+3jo1NY5djFNqneHNCwf2Hpsm15in
    1XS1KK767JDo+yUy4ycjs5w9OSpF8yQaWZzTrerso3eInllVcoT5QdI3MWYQVZqkXjPL8b
    mUzD5UgIUZGuGJCF4hd21JivANc+J6m3AGnfZkPWlppdwuBGA0vWQZoNjowrfQO8m/0BEo
    x4qJqm4lDkVPvQiPUZnEnO5I6L9exiwUbCXRwfxeGYYJEZi7J5Q+cK1EffWA
X-ME-Proxy: <xmx:mcwZapB0dV7ynLPC4kuCuq-LeMRJyazZ-0Vlyqg5N_hxtfWgZwYFDg>
    <xmx:mcwZai8TxRKhhXzB8qMSDXime-HdkiIyWM2_La-llYlVlUGP0G7Jaw>
    <xmx:mcwZajSLas5OsbCvJc7s-jx1X723a79QKbCr37I7QmcnpGL9Sm8tuQ>
    <xmx:mcwZag4sAGE3SUNn3sAzimtbaBg5oj_1rSyzfR72Z-0t-JsmoSs75A>
    <xmx:mcwZakqi2V0EMqjbRF5snmqiQFNaskBrgRWxSnk8hFNlc2prGBI9gRA3>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:27:53 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v6 05/15] mm: add VM_UFFD_RWP VMA flag
Date: Fri, 29 May 2026 18:26:34 +0100
Message-ID: <20260529172716.357179-6-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 17D6940013
X-Rspamd-Server: rspam03
X-Stat-Signature: us7kayp6ru9zohb5q8dmm96c4zxcn4e1
X-HE-Tag: 1780075676-567093
X-HE-Meta: U2FsdGVkX1/zPiEgqJn415EKNyVxn+O98toaA2lcxwvnfX2aVkbxYEPmmK+0Cy0UOLnKaFOeqS2UpiPBdBFH29PH1ImsykFnOlXI3IcyKA2n9fd5cd26eQT4A7phVUUHsyf4lMs3AJ6pgG2CGElo40lynf3giGbmeU/beW93O9r2vvLQoCyUyg87cABIPSFTo8YX/eSIR89qmprPWpBr+8OHVP0J3bott76i7o7WO0gByvxLFs58ZyLfinnWVzy8JVCpfq984kXXKStjQGwIF16RRcZdBTlyE4xA5/sGVBHKEhhvUYNEeibBteseEiaFl1+GRhWIH69URDBT1XWQaGCEWeVjz5suKcgUdIfOiGugcV/dYRCfrPeYGTq3V+LNk2qGM7EuqxOQpiNNfxXyRwHSEeNCFNxnKRzZ9/+8+TB6BUri/NfohCrnq60lHK/uAl/nS6Dnp1xlwxvjCqcXl8x9Jz1OBGwZib15M7n5ti4bJdgCChkF+yD/p0OVkNIv4nF85P/msswit52DhyMnFGDLuY0USrKVMUDpFz2K5el6kKGCWSaKDouqog/w9PSuLIJ348DmXCd0sFRf4aQoRlq3e9K3Gas25Y8OiH4s1ERJWCMHmqfRC0GDjLRRGe0N331TEAALTjZtkMbXCxv82am+UfUoRmGFSCWmdbXMKIRzO5lz5ikF7KUSzlwokM/Jo5RijEcEqpeVpDcQVdpywDJC0I5iy+IpdiX7h4sGX5Ck9GENUszxKxDsQd/2Jum6yH4cobmjXPKXVqA6k6Wgjbb+sKL9OT6qqGq3IFa1XEIpmYrWgzUMUdvaRVIaPsflgenwOhv5hDUlcLl1WVxOBlhzeeNWlvRouGnRc+r08qLTbUnNEhUKSr4kB/+2+NyDTZ7Y5e9wRZhFPIp60ctyyk+Rg/nnKROJBfPs2Sf9WfQ3UqZf+l5IgDYOYTNRLE/133LNC6NojU0PgvpUQBU
 hWapfACX
 WNgHKGL86nYr1OfNGjxFMiN5ZRKuFEkizwFahZ2VsYQWNqpmfIamcDXke7oG+K0MDJ110FwCuHpWN/Y5aMeCvgIKPNmX4Ghgjz5XEpfNjp0QOwva3ztvCSgO6IS72KVEVLHRpilcIJnSsWxPCaMjX70FtPwUQ8a5ZcrL6QUZ90TIQbxgbpOnkc8xptQoh+MxD86q3OIdh74EWeS6z8H+W16Lva0z/sTkcir7z20R42x8kQKBodVobQIs1f/F0+ZjyLWpFbHQeXmBCMy+f1+4Tv7BZTcKfVxHImugepvr0TonJZouzos4GIhJQHA==
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
 include/linux/mm.h                 | 41 ++++++++++++++++++++----------
 include/linux/userfaultfd_k.h      | 32 +++++++++++++++++++----
 include/trace/events/mmflags.h     |  7 +++++
 5 files changed, 65 insertions(+), 19 deletions(-)

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
index 939657aa334a..ca0f69b347e8 100644
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
index 485df9c2dbdd..5ac31fbadeef 100644
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
@@ -496,12 +497,17 @@ enum {
 #else
 #define VM_UFFD_MINOR	VM_NONE
 #endif
+#ifdef CONFIG_USERFAULTFD_RWP
+#define VM_UFFD_RWP		INIT_VM_FLAG(UFFD_RWP)
+#else
+#define VM_UFFD_RWP		VM_NONE
+#endif
 
 /*
- * vma_flags_t masks for the userfaultfd VMA flags. VMA_UFFD_MINOR is gated on
- * the same config as VM_UFFD_MINOR -- which implies 64BIT, where the bit fits
- * -- so an out-of-range bit is never fed to mk_vma_flags() on a build whose
- * bitmap cannot hold it.
+ * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
+ * gated on the same configs as their VM_* flags above -- both of which imply
+ * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
+ * whose bitmap cannot hold it.
  */
 #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
 #define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
@@ -510,6 +516,11 @@ enum {
 #else
 #define VMA_UFFD_MINOR		EMPTY_VMA_FLAGS
 #endif
+#ifdef CONFIG_USERFAULTFD_RWP
+#define VMA_UFFD_RWP		mk_vma_flags(VMA_UFFD_RWP_BIT)
+#else
+#define VMA_UFFD_RWP		EMPTY_VMA_FLAGS
+#endif
 
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
@@ -648,22 +659,24 @@ enum {
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
index c4f2cc6dfcf0..f3b2db27989b 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -21,10 +21,11 @@
 #include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
-#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
+#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
+			 VM_UFFD_WP | VM_UFFD_RWP)
 
 #define __VMA_UFFD_FLAGS mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP, \
-						 VMA_UFFD_MINOR)
+						 VMA_UFFD_MINOR, VMA_UFFD_RWP)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -179,7 +180,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR,
+					VMA_UFFD_RWP));
 }
 
 /*
@@ -210,6 +212,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
 }
 
+static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+{
+	return vma_test_any_mask(vma, VMA_UFFD_RWP);
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
@@ -330,6 +342,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
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
@@ -423,8 +445,8 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
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


