Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE30CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72EA46B00A2; Mon, 25 May 2026 07:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706846B00A4; Mon, 25 May 2026 07:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C3A6B00A5; Mon, 25 May 2026 07:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FEC26B00A2
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:39:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9EA0C0F5F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:09 +0000 (UTC)
X-FDA: 84805746018.05.1C6DDD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EDAA6A000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lH5cJQmP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYFNxHBj+X9DzBRzdjiAmOuXk1cN5trQXnOJ5Ey2j8w=;
	b=BRzNyNmlmK4aL4wy+ZoDeOc08RR3UOpNMTB61vVE2Uecx9BQlznlGauNZUr1kGDCJ7t9e9
	Com87/ti8LHNMAU82xictbnTcYETgw7UUfquGCPxWkC22dka4Pf6DKnw3hcrx3JhzuS51S
	rluXMUogNKXFQxUYI5PDgG9eJ9HTLZ0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lH5cJQmP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709148; a=rsa-sha256;
	cv=none;
	b=nyYgloPe7vaM1kk2gJt0gOlXfC3tca7hqvH89Us52NckDh8eiAA62NJK8oo82VmZYUJDMH
	9+y+ulO1rfKfV+xRv1lCgonA39eLttlwkYcv0JfmpkVhmY2KewHLZQ3PObPm8h86HFXVj7
	O63bs5roNc1Jmdcdj3jIFNYS7gCKB1w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F82F438A2;
	Mon, 25 May 2026 11:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E2C1F00A3A;
	Mon, 25 May 2026 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709147;
	bh=UYFNxHBj+X9DzBRzdjiAmOuXk1cN5trQXnOJ5Ey2j8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lH5cJQmPcVaM965/SY5fYob8+8tNzRtNhvKv2aNo7S5IqoIC5NCzXq9t361OWY4NU
	 SMaOAKjIh0S08NwdKGs6XnF76wQaaRxnSYbOdNYAtyAGlzQrSsvw89MzFNCKcZ9OtF
	 Qag2P2Qk2XZCYYhvMgJcpGBOShbobSxah/x4RqhS5MwGPsKuQ79nviIuG6X32QbmiD
	 Q69HuzgrhmY9KpRfgPZas5VpKxDT3w+Cm0iH1CvAKDR4brRoyEHw7knvZ9Q14fXIYG
	 ogpbeAHz9/2zvTohgSAIHU5azqnXfjf/sDE2HYRsFuw/EdBd2iHCtzeZG8XxsxyeDr
	 AP8dGf4a6N57Q==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 046D2F40082;
	Mon, 25 May 2026 07:39:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 25 May 2026 07:39:06 -0400
X-ME-Sender: <xms:2TQUaokYGon2c3TJKcVxX8ExCgOUxlZoeEil9ShYNHgq8VE6sJwMnw>
    <xme:2TQUarzPnQwDBtF1HfgTaOvKpEN06Ccx5bqNjIQU5EHi5Ikh-RhLqlMFsWPnGMaiX
    NsYPAeuUtrXPp1poPluJl3bbkF6LtTqykBy6eP6uNtDrDgHVylCvcw>
X-ME-Received: <xmr:2TQUavKa4fnL64Dguym_txr-kFw-Xwz0t8QiK_0NeJrrTBl1cSQRuzav0J4l3A>
X-ME-Proxy-Cause: dmFkZTFnTuEJhvyD+myNg4p794atgQHzdZOXs2A3gxvR3FSD7M0iqWwHWhOfEG1IgnscR2
    dpWEnUQHTt04gBiZJ6FOYLwJWkueK3/2x7yPKsRIizx2ATY4cFZISTDZP9EiTwl/39cNmM
    OA0CsMrDRjxwva2a2lWcAgzMzYsZoGkumkodmX+5ok307LF0rRD0oLFOgPIpccglfJ7Cmv
    AURvPb/dWg6Eh/o3LACLo5CgxqvMM0m0aATVsjZcPfM5Eqk+WNKfRQ8GkDG8MvyLCL9P+n
    Ffx6yvOWdEN3fPIKUkuyF3PJ8RYaK5VmWWEYQaxtLNJTEh5sz7hSNo8ZFBfkwknbfQV6SR
    ZJG/EnGQXxPUd+ThT0wRe2z8HAL+SXTI7hO/F/eeJly9kq9yylfFG88SwAqzAwD9HHERme
    G8HfeJltgyPiJI1xtRmMnfUJBikdE64v2k24H+YipvRguofRyGj1JEcS5zsa3rIE9v+moT
    lrp54cePWta33SuKtNISKb73LMJJD9GOKep7qocolhnD5wwXEg5TwqXkChD+gFQhn9AHQl
    B2zgy61tB2MbbieFTu2lQtOfDMTWaiOmuvSA3YJ/QfUbtCX6K5lD5Lfis+Qkmf8nwaxdVA
    /jbvKAZkJQPhjydCFet30pKzX0mF3h8Ch9Ro/O/f8GXt6rcBL6DczNArHwYA
X-ME-Proxy: <xmx:2TQUauJ1ODt9oBuhmL72Ke7XEVQEZw5i1TnDgRt2RF_K4UthjmFKog>
    <xmx:2TQUauWPE2jlJqDRL3DN8kre2Ipal9bBlXxPzz5rXokLMQmh60CZHw>
    <xmx:2TQUamAUASCZAQChD0y6NkH7uG4wKzB9JFShM-mUlKyw8nvvghZmTw>
    <xmx:2TQUahETNfEDBNoAag3iDSr0V1tV_7Rp0DcR56CObtbBfmuUjXkMvA>
    <xmx:2jQUaieTCA1ZyzuuXqn8_oqE3inNLRKhY0Rmta9AbjHvU25_gX139lSS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:39:04 -0400 (EDT)
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
Subject: [PATCH v4 09/14] mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP
Date: Mon, 25 May 2026 12:37:23 +0100
Message-ID: <20260525113737.1942478-10-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EDAA6A000B
X-Stat-Signature: 5w85ahdbfkibsyhzy5gu3fxmyijux988
X-Rspam-User: 
X-HE-Tag: 1779709147-238441
X-HE-Meta: U2FsdGVkX1++38i5ZNe8AbFFkknlC5h/F+EURhECZpze7V0NvFnFXnim1V62voYDmB7+2jI1BDad5PRamYoe4STD2WegPVJPbr2bt4ZOw/Iu/X+/KQ8TPL8gAUpUK6AY2nwoYpEYBVDTonyGyfSR0CkTEsUUC01YatGahi9ZoUASl0QwhO/BiS6NqB3y7iervYKvfKJQA0845cVyQLnE7fR3h9h5ul4I23IMTXi/Y9JzrM18XTawg88OKAVMOK+X+jJ3rUcBB9ZVBvr+btb8U6VtrWgGH3To09yL1JF/cmao5dmmQuUVfWRqjcl8BanqVzp0Hk6FtTL3Q2LeswpBU46HZoPyNQgunc4UR3cPOgVSloQ6rMfaSl5bOu3T1UHAp2dphCV5e/rgYi6issVsqQC5ahrIJxh//BMyNCqC0GH3UZHh6lW+et0wsDilB3AnQgno7bSXkoJJe/Wb52JzhakDTh4As6dEeKq//k79VnRBkXYx5rviJUacngrk9z7t1EHz7ISGpR7AXU5gTVmKcR0ERIoIZNrd1TH3bMEjEwylH2wPkkkUkjBe9Vv2kLmGB9gy47loHMG0z25qE90LC9QHP4rAH9hsNTjF0FhfzBN8HqVz5ET81XrtYxBBjUXk/5jkO/ShI5PeEcycoo+zRzzNQduLn+SzKEXssv1bGKbqZ54WFMzYXlXuhdWoG1hF5hPXv9YVv3LefJolZe5ie33UxT/eOGtVl116nrWnC/PYr2daOTQf3vr89Nv7A71T2BclivhiflO+TCvpjx7tnn6oZPnxSbDP0srkHCZ4Z5FUoavDYE0UMWbLm9+8hwL9/NmXOPY+CHdCiCDhheAW5l2pF7covQfnxMWNNGROKeeE0mESG/P1avkMj0lS7vWRLqK3P/Tz5GZtRNFfcc04QKV/KweTEHwMhUgUziokBFsOobznSP8DxJKFW9LEE3jO9HAUbkh0Jxmu/SNca1I
 sCk1B1Gr
 iTBZpjz+7iV+MeDSdSg7GGphwhqwMcEJYKlPS9cYn2AWaj2OH70CuPloq6dJqe9agcm3MFz1daPj7xFVGWDAPYwgqy28JHWyQR04pCajPsJGZx/r0bJkaPYO6W1VgEz2YC9QqWDQJHIP14diwebPZBSuZK6WLTQt9CsQnQ+UyihsMGlhdJ8NBlrpF12JnlTOFtjDEAWv8mh2amrNBn5F1RjNF1rDwxJAeX7AIbXo5NJYFx+Y5LLXJHlxVJyKYuSv4rnB4WX0qFdCxYczHq0ZEb2MzxAwgJx/b/qf+xjNAohN+8kXpgU4IdSVwxtcyZbvwHM4/l7x1TMJRgLnR5vvqOJ53eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 mm/memory.c                      | 21 +++++++++++++++++++--
 mm/userfaultfd.c                 | 32 ++++++++++++++++++++++++++++++--
 7 files changed, 104 insertions(+), 8 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index edece3e26985..fe48d76957fb 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -529,6 +529,8 @@ static inline bool folio_test_pmd_mappable(struct folio *folio)
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
+vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf);
+
 vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
 extern struct folio *huge_zero_folio;
@@ -716,6 +718,11 @@ static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
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
index f78d5d370d0a..d8f5f400c8ef 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -233,6 +233,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
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
 	return vma->vm_flags & __VM_UFFD_FLAGS;
@@ -363,6 +375,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
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
index 8620ba92263f..cd32bd51e311 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2289,6 +2289,11 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
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
index 8555810cd42e..f63718296cc2 100644
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
index e4ae5350db41..3e393881031d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6135,6 +6135,12 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
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
@@ -6410,8 +6416,16 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -6525,8 +6539,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
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
index 78eb63702649..b966df47800c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2650,6 +2650,12 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -2710,8 +2716,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -2736,6 +2748,13 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -4477,6 +4496,15 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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


