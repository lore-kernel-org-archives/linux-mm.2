Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC34FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130216B009F; Mon, 29 Jun 2026 08:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108396B00A0; Mon, 29 Jun 2026 08:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11D56B00A1; Mon, 29 Jun 2026 08:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8EA76B009F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2DA0312064E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:13 +0000 (UTC)
X-FDA: 84932827266.14.5A4C83E
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf24.hostedemail.com (Postfix) with ESMTP id 31D0C18000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="p XHwF5g";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gGdVmN64;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734891;
	b=miQYLwwRRUjV2OQE5/xcUNp94CuNiczsoPmWyxgq1o0njSJhK9+9excUNMP29KPcTfge1A
	kYk6ADvIUvvVlMqpGeCo4lQ4SCKkHG/Uq8pF1mJr9xbkaLvxmgCrCB//eAzasWgMHQC5/5
	Qa4z9PuPwZTjOZ9RIvdU4z9K3Pb5T+U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2O6YTync8OEENxadp/W8f2q0ghwHsrH2EczR8/nGUUI=;
	b=fZtCD9kSiehkVGbRa+8mhvUm2Y1xcDhs/IAN6OWgsjdyvFrLIGbto+IKmP9QpN8n+I/4ur
	vEQQ1k6UKmFxr+r/lEKAf4nnTsa5vSDt6aOnyDg33RD8RiH7TgVZvoseMyOzZpshu01vqI
	96O6acrGYWwNS54Lq7FjoJUO+vUXPDE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="p XHwF5g";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gGdVmN64;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id BB97DEC0119;
	Mon, 29 Jun 2026 08:08:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 29 Jun 2026 08:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1782734890; x=
	1782821290; bh=2O6YTync8OEENxadp/W8f2q0ghwHsrH2EczR8/nGUUI=; b=p
	XHwF5gbFOXF3/4dEaBJ2ulgp9Pok/ZEFTUb8m33rFqlZj/mUkwRr584VwaUE8nk6
	fepO7U1Jmknq7fMkoCxxj9NGzfxp8IRi1fBHNWTethXAsToplZkxIuK/TDqNNDyw
	CyVfjfgngxk9lKkNSGMFEJieAVK8LGJgdHkLCWgxSknEbq8nN6Nh7lwN1Zb5nZ48
	EB/gWf3AfJdbzM8gd36S9hC98rQ5UZdkuW1GKfxHI9cZpLKv3pQGVMi4gcJrSnyT
	Q2GbXBltoXxJxJVQOGeOiis7t3XUNPT0m/V+pGun7rXs24PEbFASADiYkYioH7hw
	iYUMwlP0JDZVLO6a37b8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782734890; x=1782821290; bh=2
	O6YTync8OEENxadp/W8f2q0ghwHsrH2EczR8/nGUUI=; b=gGdVmN64DchJqVU52
	STpK+6Ghj13y9vPGqS8za5seZduO+LKtFdhJvU/IPLkdJBWcihUbheUEw0X4YxAI
	LzVkGbt7kjOdBPoAAminK1rPFdYj1mFQCgShJsz68nA0ckbwsJ7YUenFK4N0axWW
	TdkEiy5Uv2/7mE+JLjw+jeyJMBK8sBXqS9p14GVgbmZ/EBP+ejlIbHFm7oPoHpti
	UpWxYnlghYzUsiNDSx9EZeu6mnftDyDCQKTl3IPA/bUt7KoVn8m4DNpTFcCSvMKG
	X2eV7DGQV32EeY2IGGzTUnEUpdr4IJ6o7OMeFDLALwq3hJJqY9ykrfL7T+Y5khVw
	NAN0w==
X-ME-Sender: <xms:KmBCapsqZrsSZRQi6CT9_OjWzFHz5aR7mZI-UuZLMvjvrCoCmd5-tA>
    <xme:KmBCamat1RP-ohhhtcSoePWpDJDUvp8O5_Jn9oMzhMDRwbmmoD91-nsBCpeY4y1F7
    jiGLwqj1eK1A5UwxqocQwSACzxsQvcnqnibHk9bCYslExxsOTUSyGQ>
X-ME-Received: <xmr:KmBCalS4iQJZJVbZWU2cutHM1toX0fP3GE7yhAhbCLq3gaEV3OQvfIsmCKV7QQ>
X-ME-Proxy-Cause: dmFkZTFBuleX+G3m7sP9Zsu4VW3liFh4/9ES9+x1zhm1LO4o69juul9VJVwpsp2yKNiGAY
    HMqkCLCEnSIu8jLYQ3WjovuYpKPl33AHMh9x9zT3DK1CZBAEOJ9UcECvBViqtkEpGhv4bS
    HAJWwV7WvYRUgyT+w1ADydaYNYn6oSPqjU2R9RlHHDv4k29616CPiyAbL9Mb0C/dt6oYTy
    zU86eufTe1GQD3bzgADfXEXxdw4wXD5+1WXEyPjWMy12JtzWsyQqmauwTKE/Aj9TVxgFuz
    keGUSQYyghr7T2+sg7syXMqjUCe5fLBdxHRIDhqPnODHthe+Z872Yw3xnkzTrMbuaMK3ee
    wUozMQ+BCABF6zIY5rkZTtnq+K/PLrYV+a8h0xar5SgaJwSwuLv+7RPGhRhYwhJzjXe5Q2
    F94KoIhq3+6qYpQGtaCSOAu5qdacS2ZP1WxR2El9QdiStpYoAErwgmXyUj3X/3iO5ylsH8
    57c4KEKI7Xra0QSwzHXJ2/ggLJYbfDL2OE4//s8E1Xfsy9L7D00ad2SmdQnvlKup6UaRLO
    UDOo0c2rDihISuS6U0+LuSRT1g9C8UnCswwvP9KBdn7gd5hwc6F1k13HBwUzvEv/uapPvO
    UuX7aALujyeasP6fVxuqZjni2cWxmDpzw74AUn5N4vdhoaZBkR1YUY6I5QHg
X-ME-Proxy: <xmx:KmBCapwEiweWLrh51aTeojV0dE3AkiUvYF38WXim0_KjgxNkqF9vtg>
    <xmx:KmBCahdx7XLC_N3HY8MjpwrJTPAUEGXq6vhdWuJkMlrfDjQsZnG_cg>
    <xmx:KmBCaqriMHUlsVWNq28_Y_vbeWPKklKawC09xtEbsw9nf2EpbQtAbg>
    <xmx:KmBCapNkHoKZe3p-dMgDuzUn6yeVdD12U2CWhf0wvHjeznqlZl_XnQ>
    <xmx:KmBCauNIZI1nLrv7ndzDR8D-B8UlhKLAzVlwncXU0Wdw_OTmp4J1o-UP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:08:10 -0400 (EDT)
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
Subject: [PATCH v7 10/15] mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP
Date: Mon, 29 Jun 2026 13:07:41 +0100
Message-ID: <20260629120749.566063-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31D0C18000D
X-Stat-Signature: xhhygcytqj9z4xn7d5qdxj1k3g1356fk
X-HE-Tag: 1782734891-259488
X-HE-Meta: U2FsdGVkX19i1iU+hMvUJOS0s1urmBqu1/4i5576uqOLcYDxpU8f5qOzjN4f/MR1/eNKetaEMZIPJGhrw2qVACGGpsg76hB7JBwtzcqWJtZegISezrbpCIKWHysSqFrX4qlZJw550r1DU/km05iu1BjRPwWnaGDnX0vnDpOpCnxuDXtkRyrh9MMSmH29vANiVerfEeNu63Z2KTp81U4AQPdZW6OMXoV69QSC+uNIuGLegNJhRb67vsZ7drBjPlFown5MkioxdBqCkS6S1RCN5LavuS4i980ggXPfmcs25sjADcRPQLx5SuFBWWofPc9/RzCYY+nT48mKG7MtAPQl5udKNNCghw3EkohDbFWCY1WXhWEn7sPas9i4KYDpPyYuZj4tJ7LKc4dEROen/EOXZ9EHplXBKnkMUTq4yXBwQWso1DEVPMCSl90jWi6xrpi1b/8pEkWRkK6eBd9kGjdXaxU2rO0w7FydivjzxxOZeRG5S3wjRibJ9xO7hogSL8GZ50+KbZecQUl8EVpvOLY1xvPPNafBRfutXdmeGYz5UnNccMr6kthRZ5u+yrmLKNbvuBs4URy1n6vgTomd8OumfoU6Vfgk7QjVCLKFhXgzHKo1DEvCNX0vs1uHwZazD3OZC+i1bqskP1LpLw8I2/KWBx4MMSciL5q/CpoKBxrZxU7/KRVi7rYmuZJ2gGjElbPMY2uaSeUkqMr2OF+gs5W3k3SXxRbQRp8poTegcTu2Lxsxvh+ZiwjQu4flFC8+vqAY/jiScA41RFc0KHOZdxkJ01wPLLRbKuzDbXtVt3rO3Py4JB0tABTFXIK1vYfaBBxqaZ82oeAqqnPpvlPsw+A6Xh7eK9ThesCgwR8l6Y7zVuSFMhXzrKb6jhMoJbXG4LA8wG/mqG6tHVRL7QPDgtLIm2ughkk8SVcU2l4/4TdsrAOeeGF0nP6ypf6RUpv53XKjPGdgaeYEec6PdUJPfb8
 7UYBfPpj
 ctq/BxMDICJ+V6SrACrgzyS0V967KJ+ATcOPQEqCoTZpJhs6YAAXHHkk+oobUqsFgA7J9xybT0zv1B45wLv5gew5ArQTboqLJkQcAp2yCFAzixYhdXOAUuIk4bqj876hc+65ecB0ikfoVxd0nALkJpAaLob97edOWR0z/ndT9XvUgjEbbNmMbUt7iYblDHbiiCEDPDg00lG/lmeE4rDIgwrjfoVFlCok6GQ6M2ZwDygyJ/jlVLf4S079FDGwa8XlcyRfMx4x5JqN/LbgQfarXQyiIi40fjI8Ly0+d3dL5Kf3NB5J/5WisIwAbEZ4NaEsapVvFlp5Oz455X6Np6F1bhah1EtcHz8+64VGdcGJHabcHh70fGr9+TYWjlOM1YBJba3e2wFuTAulrFWNwLMLna8MY1tNyWeFfjrt128F5gjNQeT7DnwwZErC1DPmHP4hEgu1kEnn7HOM9ADK+T5Lm1BfwV+er+H+xEl3TTQzfaQOo1fNb5kAK05v2rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Wire the fault side of read-write protection tracking and turn the
userspace interface on.

An RWP-protected PTE is PAGE_NONE with the uffd bit set. The
PROT_NONE triggers a fault on any access; the uffd bit distinguishes
it from plain mprotect(PROT_NONE) or NUMA hinting.

Fault dispatch, per level:

  PTE     handle_pte_fault()    -> do_uffd_rwp()
  PMD     __handle_mm_fault()   -> do_huge_pmd_uffd_rwp()
  hugetlb hugetlb_fault()       -> hugetlb_handle_userfault()

The RWP branches gate on userfaultfd_pte_rwp() / userfaultfd_huge_pmd_rwp()
(VM_UFFD_RWP plus the uffd bit) and fall through to do_numa_page() /
do_huge_pmd_numa_page() otherwise. Each delivers a
UFFD_PAGEFAULT_FLAG_RWP message through handle_userfault(); the handler
resolves it with UFFDIO_RWPROTECT clearing MODE_RWP.

userfaultfd_must_wait() and userfaultfd_huge_must_wait() add matching
protnone+uffd waiters so sync-mode fault handlers block correctly.

Expose the UAPI:

  UFFDIO_REGISTER_MODE_RWP   -> UFFD_API_REGISTER_MODES
  UFFD_FEATURE_RWP           -> UFFD_API_FEATURES
  _UFFDIO_RWPROTECT          -> UFFD_API_RANGE_IOCTLS
                                UFFD_API_RANGE_IOCTLS_BASIC

UFFD_FEATURE_RWP is masked out at UFFDIO_API time when PROT_NONE is
not available or VM_UFFD_RWP aliases VM_NONE (32-bit), so userspace
never sees an advertised-but-broken feature.

Works on anonymous, shmem, and hugetlb memory.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/huge_mm.h          |  7 +++++++
 include/linux/userfaultfd_k.h    | 24 ++++++++++++++++++++++++
 include/uapi/linux/userfaultfd.h | 12 ++++++++----
 mm/huge_memory.c                 |  5 +++++
 mm/hugetlb.c                     | 11 +++++++++++
 mm/memory.c                      | 31 +++++++++++++++++++++++++++++--
 mm/userfaultfd.c                 | 32 ++++++++++++++++++++++++++++++--
 7 files changed, 114 insertions(+), 8 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad20f7f8c179..9c4ebf0fc227 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -529,6 +529,8 @@ static inline bool folio_test_pmd_mappable(struct folio *folio)
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
+vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf);
+
 vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
 extern struct folio *huge_zero_folio;
@@ -723,6 +725,11 @@ static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
 	return NULL;
 }
 
+static inline vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
+{
+	return 0;
+}
+
 static inline vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
 	return 0;
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index d65e1833f08d..8d5d6ca60b67 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -236,6 +236,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return userfaultfd_wp(vma) && pmd_uffd(pmd);
 }
 
+static inline bool userfaultfd_pte_rwp(struct vm_area_struct *vma,
+				       pte_t pte)
+{
+	return userfaultfd_rwp(vma) && pte_uffd(pte);
+}
+
+static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
+					    pmd_t pmd)
+{
+	return userfaultfd_rwp(vma) && pmd_uffd(pmd);
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
@@ -366,6 +378,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline bool userfaultfd_pte_rwp(struct vm_area_struct *vma,
+				       pte_t pte)
+{
+	return false;
+}
+
+static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
+					    pmd_t pmd)
+{
+	return false;
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 7b78aa3b5318..d803e76d47ad 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -25,7 +25,8 @@
 #define UFFD_API ((__u64)0xAA)
 #define UFFD_API_REGISTER_MODES (UFFDIO_REGISTER_MODE_MISSING |	\
 				 UFFDIO_REGISTER_MODE_WP |	\
-				 UFFDIO_REGISTER_MODE_MINOR)
+				 UFFDIO_REGISTER_MODE_MINOR |	\
+				 UFFDIO_REGISTER_MODE_RWP)
 #define UFFD_API_FEATURES (UFFD_FEATURE_PAGEFAULT_FLAG_WP |	\
 			   UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
@@ -42,7 +43,8 @@
 			   UFFD_FEATURE_WP_UNPOPULATED |	\
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
-			   UFFD_FEATURE_MOVE)
+			   UFFD_FEATURE_MOVE |			\
+			   UFFD_FEATURE_RWP)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -54,13 +56,15 @@
 	 (__u64)1 << _UFFDIO_MOVE |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_POISON)
+	 (__u64)1 << _UFFDIO_POISON |		\
+	 (__u64)1 << _UFFDIO_RWPROTECT)
 #define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_POISON)
+	 (__u64)1 << _UFFDIO_POISON |		\
+	 (__u64)1 << _UFFDIO_RWPROTECT)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index addf3bc34618..39f705fbcbc4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2202,6 +2202,11 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 	return pmd_dirty(pmd);
 }
 
+vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
+{
+	return handle_userfault(vmf, VM_UFFD_RWP);
+}
+
 /* NUMA hinting page fault entry point for trans huge pmds */
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0d8d39cd8888..d4da39d698b8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6062,6 +6062,17 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_mutex;
 	}
 
+	/*
+	 * Protnone hugetlb PTEs with the uffd bit are used by
+	 * userfaultfd RWP for access tracking. Plain PROT_NONE (without the
+	 * marker) is not an RWP fault and is not expected on hugetlb (no
+	 * NUMA hinting), so let normal hugetlb fault handling proceed.
+	 */
+	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
+	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
+		return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+	}
+
 	/*
 	 * If we are going to COW/unshare the mapping later, we examine the
 	 * pending reservations for this page now. This will ensure that any
diff --git a/mm/memory.c b/mm/memory.c
index 978ead28c6d1..16b7596625ab 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6126,6 +6126,16 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 		if (!pte_present(ptent) || !pte_protnone(ptent))
 			continue;
 
+		/*
+		 * RWP-armed PTEs are also protnone but carry _PAGE_UFFD as a
+		 * marker. Leave them alone -- rewriting to vm_page_prot would
+		 * stop the RWP trap. Gate on userfaultfd_rwp(vma) too:
+		 * NUMA balancing preserves _PAGE_UFFD on UFFD_WP-marked PTEs
+		 * when applying PROT_NONE, and those still need rebuilding.
+		 */
+		if (userfaultfd_rwp(vma) && pte_uffd(ptent))
+			continue;
+
 		if (pfn_folio(pte_pfn(ptent)) != folio)
 			continue;
 
@@ -6141,6 +6151,12 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 	}
 }
 
+static vm_fault_t do_uffd_rwp(struct vm_fault *vmf)
+{
+	pte_unmap(vmf->pte);
+	return handle_userfault(vmf, VM_UFFD_RWP);
+}
+
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -6416,8 +6432,16 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	if (!pte_present(vmf->orig_pte))
 		return do_swap_page(vmf);
 
-	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
+	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma)) {
+		/*
+		 * RWP-protected PTEs are protnone plus the uffd bit. On a
+		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
+		 * NUMA hinting and must still fall through to do_numa_page().
+		 */
+		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
+			return do_uffd_rwp(vmf);
 		return do_numa_page(vmf);
+	}
 
 	spin_lock(vmf->ptl);
 	entry = vmf->orig_pte;
@@ -6531,8 +6555,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return 0;
 	}
 	if (pmd_trans_huge(vmf.orig_pmd)) {
-		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
+		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma)) {
+			if (userfaultfd_huge_pmd_rwp(vma, vmf.orig_pmd))
+				return do_huge_pmd_uffd_rwp(&vmf);
 			return do_huge_pmd_numa_page(&vmf);
+		}
 
 		if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
 		    !pmd_write(vmf.orig_pmd)) {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index a58ebf68d7da..388a91435d35 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2675,6 +2675,12 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 	 */
 	if (!huge_pte_write(pte) && (reason & VM_UFFD_WP))
 		return true;
+	/*
+	 * PTE is still RW-protected (protnone with uffd bit), wait for
+	 * resolution. Plain PROT_NONE without the marker is not an RWP fault.
+	 */
+	if (pte_protnone(pte) && huge_pte_uffd(pte) && (reason & VM_UFFD_RWP))
+		return true;
 
 	return false;
 }
@@ -2735,8 +2741,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	if (!pmd_present(_pmd))
 		return false;
 
-	if (pmd_trans_huge(_pmd))
-		return !pmd_write(_pmd) && (reason & VM_UFFD_WP);
+	if (pmd_trans_huge(_pmd)) {
+		if (!pmd_write(_pmd) && (reason & VM_UFFD_WP))
+			return true;
+		if (pmd_protnone(_pmd) && pmd_uffd(_pmd) &&
+		    (reason & VM_UFFD_RWP))
+			return true;
+		return false;
+	}
 
 	pte = pte_offset_map(pmd, address);
 	if (!pte)
@@ -2772,6 +2784,13 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	 */
 	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
 		goto out;
+	/*
+	 * PTE is still RW-protected (protnone with uffd bit), wait for
+	 * userspace to resolve. Plain PROT_NONE without the marker is not
+	 * an RWP fault.
+	 */
+	if (pte_protnone(ptent) && pte_uffd(ptent) && (reason & VM_UFFD_RWP))
+		goto out;
 
 	ret = false;
 out:
@@ -4513,6 +4532,15 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 		uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
 		uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
 	}
+	/*
+	 * RWP needs both PROT_NONE support and the uffd-wp PTE bit. The
+	 * VM_UFFD_RWP check covers compile-time unavailability; the
+	 * pgtable_supports_uffd() check covers runtime (e.g. riscv
+	 * without the SVRSW60T59B extension) where the PTE bit is declared
+	 * but not actually usable.
+	 */
+	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
+		uffdio_api.features &= ~UFFD_FEATURE_RWP;
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
-- 
2.54.0


