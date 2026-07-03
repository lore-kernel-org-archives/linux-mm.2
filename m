Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D2CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0C926B00CA; Fri,  3 Jul 2026 09:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4A96B00CE; Fri,  3 Jul 2026 09:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA8B6B00CF; Fri,  3 Jul 2026 09:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF996B00CA
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 261DE1C485E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:33 +0000 (UTC)
X-FDA: 84947565066.04.8B5B7F7
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3BAD640004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="u lI9KIR";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=o+2kmV6C;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085791;
	b=a8UvJ4QQbWgrOXQluyJpQR6T47+AuSW65uufMJeSWWCI2ukjqL4MDbrqV0oDnwXZs20wL/
	x2JpZDGmOA8+xxes+6lzSg3tP0eNFD+aCgvEdNOSbkiLBwA4XRRyc8dHCgc7QALTwdV4Fp
	B49ibnuIsjNxQ1QvZdkQd5zYWUsHcds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHyluruvg80LL7D5iPr6EokbEesUw4mOCnn0P49HM6w=;
	b=YGM3BUH4jRKA+rhBYLrqvQO+vV+0zdpWZSNaxeKEHWCB9dIxzBGUtloHYmFg6DNPyOOyBw
	ZwhP231nnK4jLAktyEx1VFtOs4/12MmwLO44WoH7Hh9e0k28sGTr042pWJHt5Vk+/x2CdX
	uzHgu0EenIZtz0ZFD99OkgANqWzCs3M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="u lI9KIR";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=o+2kmV6C;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id F33251D0005A;
	Fri,  3 Jul 2026 09:36:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 03 Jul 2026 09:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783085789; x=
	1783172189; bh=EHyluruvg80LL7D5iPr6EokbEesUw4mOCnn0P49HM6w=; b=u
	lI9KIRSFQQpZFr1O7v53zxzOIz5SjcZdUWoPErc/Img+jVDRgYXKqALuwZlI76mO
	G2mBMnH9RDneVIgsqVeb6V+ouWymMOv1cy9f2Lx3c3+xK4k1qGUsZMUP0T/qC0oZ
	jK6huficfyVNEe1zczxT0YEvFvECjRQ8gwtnhY8MLUi7mRbYbdcMBp6luaPwfUtd
	CaoJLTblTgq2QRUt5VZl86N+jmr5VIUt2JYui3b3JI0A/TU1bGy9GwwSjaxP6rwt
	MgMXO7WBJ5Uy9ZZ51nDfwb1+Tp1zegVVg8hD9vApZ4YrAwyqYy81N4ubG6f67pan
	Q0WlOCRDkxP253EIZ+sWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783085789; x=1783172189; bh=E
	Hyluruvg80LL7D5iPr6EokbEesUw4mOCnn0P49HM6w=; b=o+2kmV6CJwB2+nECU
	ccXzrS4Da3vd//N+wcMUTb8JpdzWfMIjiXTMg/hBOfKlOVNZsoXG/y2xVh2/vjoL
	fug9iFKKJrEbu0YIp+4jhh9iEeqEx1aI+FZIVAGJCEK24o9X9Y6fMDH3wLTCvHs6
	3sqvEXyNT+KNmfjdK6i8wLQP4EAWuO9PNyAFIOH43Gy7NYlTLYVVPIBvyoqlmGYc
	5nDo6+hHFwgzYDhAcDNm6TWY7AgPB5BZ1EKsiQDfnj6ToMZJh2JZAAk9QdrsxmAU
	6aV83reQqzVv487HzSXZodGIB6Ixge1fsc/zrTY5gKZGS6jDoFppx29yUWC4yOiC
	pHUiA==
X-ME-Sender: <xms:3bpHak3-CBnpeZUmbIYwzPCCl0hhLp0KE2oQsq2n0QqtCoQnms_4Yw>
    <xme:3bpHajC8c8D8mBa-khM3xw5p3TEohXHEPW-mSQMglX3_QUwEgQRUDGqBXu64mIy9d
    ifpwIrozjdIpdTR-Af9aZyPBlGX5SywrH3KFCI6vid-HX7sYauzoyvA>
X-ME-Received: <xmr:3bpHalaAV1GeJ3OtCXNrrXeaBO6eQ98KAHGZvoznhKKXPrA8G0-p5d7UlYaukA>
X-ME-Proxy-Cause: dmFkZTFQDL0sPRW30T/r8/WmDkXdFgjoaIX9vLNwohRjptYUed9306bo5V6gIx9MoEqVUL
    DOWAtjg8MmvSrTWg8GgGs2eP/FFDGLHYqX57o290l8bdH3IY0k+xW1ZYR304ONNSUwYaQK
    Bo4+Emve+flZyIIVzN32HB6G/Lort/YA8L1H1gsxabb9oSnL9XvWud+W3vggQeX1PoJ/lr
    b3eqT2nN+Fc3cRZtM5ggLz7p6oZndcDaRsjYfSAitKmZJei9EqcM8LdM+VCLGFHLAlSKAA
    8tPrvpHjoO9CczAcEbCuu4vVAaqfuT+lM6L0awrERU/Twntj2KE6oGoO3CSAB1ADqLwymP
    DCo9nXgtrinx/XCu8cRXXekZucUqJ8ur+tzRwVfdsNhceqfjPVzf43s9cBHnwTGRusU01g
    cssd6BWYVvBfZ3T8xNyVGVtfojRRW9Onv9Y/ketrjob867Lv99K+T0CeX/nX4r+PySCqBc
    x0VmN0qWNsnb64Htt+0wMCZRNVGzlfHeRVlChFuhE/Mur2RtnyX61/OIF6Jcs4okMY2GIG
    uxWDLste8uC7lbwjic7bcTDiCnAssFQcXxuJ2EHHk7++M573dnrjxjQnCKov+7JenXovR2
    anR2gJITK3gJSgJO2Wvj1z3GUbDZ41yc1HZwYlmlxUUCILuVPjr2napSwDRA
X-ME-Proxy: <xmx:3bpHanb5spRR3FKlgqZdV25Ac5w2MyVGgPLkckK48dVwfR3uIpx2vw>
    <xmx:3bpHaumN5DeFAQLgAnrqEI2fA_sW2lgXNQYfamp4njyDejbuy0cugQ>
    <xmx:3bpHahTU5AM0AcSV6DTx-cDwY96VjQFjay6mMr_faadYNMY0SieQkg>
    <xmx:3bpHarVqWWkrB4wuLC6FpuEnpl_xJ-UmDmqwss1c9oz7v9lgWFnpDA>
    <xmx:3bpHagUlJQD1wTINUIaj71rO5VW7sED8I0-k300kkRo5BE4ZmN0tovfk>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:29 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
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
Subject: [PATCH v8 05/15] mm: add VM_UFFD_RWP VMA flag
Date: Fri,  3 Jul 2026 14:36:04 +0100
Message-ID: <20260703133615.1039465-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4fu34j7jahwei8t1gs569eq9dd39ocry
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3BAD640004
X-HE-Tag: 1783085791-372255
X-HE-Meta: U2FsdGVkX1+Lp5NkvXZ1ez3e/fU11wBdH04OGd0mCGqvXnlbRbek41tw+b+I7nxglWmfukivVZdAblaynsZmAt0VTm0/DCSiv9icpBvGpsEXZjj1GPLKe+gSg9I+/sY8XzWp00yQVqHgeyR3ENpqIgn+gPwY++W0RfCTzH+favigFKN163czx7eWqJJYakmbkhVCcosrs2LeZ/dtpoVfhA0YsK9AIJ5cUBMrXcYuCsp3U2MtdyR++0+rdS9s6LT1xQ8QLslvgqYDQZasqsvBOL9au8cO/lBBFMhRn99UFjErW/hl+Lxa+Z2rVk2lq7inGZlhi5i+e0AEWaVbj073VVxHGiDes1G0Mngqt7dpogiXSY6Q7XLdCYBVsKdQVfSjfnP1uWA7GpQr4U2DgSFyuUwbSRdC0oTB7tdYuaV/kX4PABRMlpKoNm/eQNT7UMuzNzDaYLqh2u+PMgZ/jsQvsR61bj1UWchkc/BiRvLWIoxWjBinCH/U5rHfCJsuqL6L+qAg76rummNn8wqpt9EiHFU2Ws++YSSdaEzcAfSWe3Nye/HAfCoQOc6w8Pi30jE78P3aV3Ig0yXViDBtbPhIoLkiemN1g4IvO2KVgLPFHw+0v8hj57LksZDsN+M5LkrmD30nqAjn8q4X9ljNZow8c56GGJ+FTInUcZnBhjSFjJbKL7ucb14OJ+aCDP5VPtmOKPnl1KWPVrtjQHHM932QcQ1nx2gPy/lj07wOXfbYP6Wz0szvbhCZy5zOjiqI2P3g+M0H+UQsQE2iy61bgI/3IA9mlGblQkdu9+g7P2zsDBHN34x06XPTmfyKyyp2FIXgXl+NDHUEKVcFYZ9KRvd6WChJ6XSMlehnMPUVAuApok2OTb+cmdQYcbj0Y40+5atE1BMVww1dKXfh0PdzRKniF5ZttwwP3XRzgbRd0AIZQu+mYQp9kLMa8pr9yZKnInGwO8DRgYd8EdHsCzN1QGq
 Nb/5/YXH
 +Z84TdRK5kV6MnQcF/Koevv64x5iRuf6aCzjbxt7I52JOujNMUoO9YRNcDN+aXNIPJwEjrQwaesquttVdLxUg1HO7RdKbiAqWN4gTsMKf8i+dnZFSSa1MphYs6YiAkWl+mJnWdILXIuGqKS4J336tNWan15pDk7t0qLaN7FMmQlKM6n4zvlhKTkjadW5KSORwgwhy2QLu8YBdXT0EhMZpdemlwYm/uFwf2nVo2xjRuodpdJe2C7NB49kHJQSY/U7awJiot7+b1MsUABadH+Gmt6Xh7L5tGPGjAGrGkPX7puLP95FK9EGOtNN+e7Kxitba7B9EQoimsopyC/IWDMXctzSA5Z3zhlWV0U5o4XWiqQoAuNuyxMxqLw/TTCukmi4oikF/2KPaCe2YVWeThaRFbPXfwF9Sm3NJ3/ixyUSQfOxy4wTRA+OIOmf8nh4dhkhsZKydPmQVMhfeO73NJkbHK4rdSJtUe32UXgMyiiGCIHB+dXTMVclYAR0bbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

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
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
---
 Documentation/filesystems/proc.rst |  1 +
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/mm.h                 | 41 ++++++++++++++++++++----------
 include/linux/userfaultfd_k.h      | 32 +++++++++++++++++++----
 include/trace/events/mmflags.h     |  7 +++++
 5 files changed, 65 insertions(+), 19 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 2ccd5b2dfdd3..27189f6e004e 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -608,6 +608,7 @@ encoded manner. The codes are the following:
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
     ui    userfaultfd minor fault
+    ur    userfaultfd read-write-protect tracking
     ss    shadow/guarded control stack page
     sl    sealed
     lf    lock on fault pages
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 56deb516b193..5b55c59573a3 100644
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
index c4f2cc6dfcf0..61ea83dbd026 100644
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
+	return vma_test_single_mask(vma, VMA_UFFD_RWP);
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


