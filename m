Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BEF2CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D626B00EE; Fri, 29 May 2026 13:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F196B00F0; Fri, 29 May 2026 13:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C81F6B00F1; Fri, 29 May 2026 13:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2279B6B00EE
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:28:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2BA1A020B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:06 +0000 (UTC)
X-FDA: 84821140572.07.6F2BF3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3975C000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4WWIxCX;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gv2+pRc1U6osORJP228ODxtBMek/urQFSJbHm0PtvWw=;
	b=s0CULc8ZVci9vyXwc6WgW+gAhXq3B6cEK8ZJuWObkQQPbyNWuLW4t6YDjog2fFcdXITc+7
	waJMUlEcuH7isKqpgG3zqCQI94C0tCsCInagoo6lxLiTa6zD2UDFO1pI8U91E6hyVR0Q8J
	SxPlTpVdcgx/2GU6HY/bO748lobOsxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075684; a=rsa-sha256;
	cv=none;
	b=FADL2XyIwd9nvMRMSvB81MbVDjnDinPuYOT3YRwZ5GQDZILf2IHSxHtrfDiueVXgpKwdlm
	qGTU3KcsvjkXj6iajSUwTHSBGRSLvHfGfIFdL9fb7ayjV3J1jV6yIRqYnLGwNfdWAHObbi
	O9puL25Q84Ih7McXAYIQ5lsNI/c1Plk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4WWIxCX;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B96C43832;
	Fri, 29 May 2026 17:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E8D1F00899;
	Fri, 29 May 2026 17:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075684;
	bh=gv2+pRc1U6osORJP228ODxtBMek/urQFSJbHm0PtvWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4WWIxCXDnrZqTI1Qe+ZF2iXjRAi916ExUZ9vROr5qeOcQQFpFUrlbseSQ4pNCfgT
	 0yfOxP+eGUllXaX6F8Hrd+V2CIZ0xeeARqbNGouZMA+kGMZ5Xee4/gHstleug2lm+K
	 NnlLPYO58Ak7pkHvvtFd0jfJxi6lenSed0y63UW3QHx88rx8mnVgmWBaCFo3f3R7Ku
	 HxRf9Ont7gmTfgkwT6gnAHuTvLAEKiBFw3jeeG9OUNwfAVkqi2IeYxiBlWpcSymn+z
	 IPULPjwm1xkQC2f8WOrcImMMFAvgrcc59KX1rPXEBmVk4EjB/8E1SvGt2pHHZoIdvo
	 L75XMon651J4Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5DE70F4006F;
	Fri, 29 May 2026 13:28:03 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 13:28:03 -0400
X-ME-Sender: <xms:o8wZalKVGj3LRNkKL9KZNnChoz0l3aEVaVfSQo_n9uNAdG__lLLCyg>
    <xme:o8wZalGHO3htPvFBIn1xfIn1OPuesMLN0NLOdtYNs44KD7kibZtdSe0Rt6HPwRb_7
    ogU2YxUNzQw385txRIwHX-Yca7B4b14yfm95tjCfaNPthFI9V8RDS2V>
X-ME-Received: <xmr:o8wZamOjVPLxAh0aq18lwmO3XNGkvlJ1XkYcVIJZVDdMwFugTZrDRLgMtNRBlw>
X-ME-Proxy-Cause: dmFkZTGEJshrF8A2I+ABT1+PcGe92P4pFG6+cE0vklYqRrHb+mEFiJirgfeISxfctvyDGZ
    GD+y1IeZv35tmnbzf3LLnXzuWli8IsJO39uylVNJfpIhw1RwqSaiqgJqpRIr+kvRh0VYKQ
    hEgzmgZT3VRasc06vpC33AigH7tICC2Iwt4d1dJuL7T8m+/ijDYDWTAi4mKbspJqr+bVrb
    MSH1cVn2xbuEamsG3tXwf9pNNkU33/NFHfeivk6kEXasVk0NjqFjFU9J4z/SYAXJRjmQ8p
    iEkseBPErjuJTuMKszjhjApDifllPe/w00800msCp6mk2mwgOI/kxoE6f7Uw227lFWaunq
    UK+PxxVafsjvjp98sZ4Vff8Pytl5ElNRoPtVaTtpoNEzigSzPNDIUbs5MldlpGCqGrNKx3
    I1YS+TPjb0Zja8i605HxL19GV0P5r3ldivKTTByIOwBMw7eG/K4ljoUXm3VQkm/I0buwKX
    NUHj9lTPrY73szOibjqKsPpNwyzrRCHdlxn6PQZgscJDpQCRTPSQzjf7Cd3l8Jt4ymgobP
    rCBTt58EejelLFPzXMfrx1PGSeO2XZQc0jESDWn2J+ZvMS47P4bOyDvUuxei1rUjmKcANR
    adir3XVGGC7J60lYe4e6U6X00JCJqVIzUKWBXtBvkR02NT9DRDbtfqz3qmrw
X-ME-Proxy: <xmx:o8wZav-T9CNkH6WJeRA0Fx65jMraa-gZMddQRXE45lMaHgd8Z9PX8A>
    <xmx:o8wZaj5w9mvZWIjsydHIUDlmH617Q_eqZylTQDgZo3wImisCrRacdQ>
    <xmx:o8wZakWQNp1EohUumBDBVPDv3s29MPgTxLgMdH6z9q_rcVPieqYhAg>
    <xmx:o8wZapKRZht6BTztSBC4FK3aCRe1ETrbEok7-z1cqkBlDtGLABtldQ>
    <xmx:o8wZahRWr_gWVXtJdme-17S11zgmHnZUVwRy-rpAmcEuee7jN1ZtTQe2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:28:02 -0400 (EDT)
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
Subject: [PATCH v6 10/15] mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP
Date: Fri, 29 May 2026 18:26:39 +0100
Message-ID: <20260529172716.357179-11-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C3975C000E
X-Stat-Signature: 6m6ynmyetn6afzrzpaq7jupf51qxkcm6
X-Rspamd-Server: rspam06
X-HE-Tag: 1780075684-814827
X-HE-Meta: U2FsdGVkX18cfVZi4bqvLFYlnEAjHehTjEsb2cqOkdRxHiyJDaYBWKq1JLFvpVQckHTHyVMz09CT6A6W59OApvS1/e5m5dwoIx8Xdi2sKeWIoMTbRBSiyPnfA8sDJAS28YWNnTqXFpU4e0ll0cuDK6Rnfmaxw4Nu6Brh5Owt9gA9U7cOh9r+daQAExFlAn1wcbz9LNQhVeFMB38TuuppfMfyoUBBO+yeB+qUjK19MH/7auN7/qwimEeg3Fb2nybTBZxBwBA1dkR3KPS0AaiLtJQU4BS2fBxYi7acaCGnVz0Y82jHZwu3tSitSWGcN9iE9RkIVlJF7BtJUf9R229Nm+/+I6oWQ8bAxvUDCCXKSmFeyKxdOYSy4tGXXnfgZLF/iT+HCPX0TydZFAWZEbaKHjf6BP2YQtZk9nfJOXMkKD3RbTk23E8D/DYBfcGxutJcDVaESGjQqBZt+7dMAARii5aQqTLyHQPM9LJAJF9PnH6HMWKk8xIdWt6Q7ajt0PZO8MZYxJYyxJnQK0u76+Mih2Mz/erl45vvTqaNVYwLezafUUHT9mJlT9SDaamRnqvhEmZOiVehPuTCcRFeIejXraxdoG/vzaayZbDGKz0UnYsUPgz0/PT4kpAL2PCHKqmQ/cYv0HTZeBOpJm+m/VPNRF1ZQ0GPHFtR5+y357+ql0PkIaFSFGbV6V7uka87W1avrj4XvxJC6lUxuX1wKlSDR5UwxDDGhxni2ORDYndzsnEizN3YRz7BZSENnEt5gT75sSFglcYa55+VPlvXKU9oOEttSqmPMzuTz7W6YN6IzMWNuIOHpOEMpn1I7PMfp4tmTpS4TLFOFicsO756IMob4x80EAJouZaywtaL9UpacGP90s+CJWWKHKiOiaPtVr+iadNn9uknS+HkWTstHm8M2JVnUv4BJlKZChJEARc4l6YqqqWvP7mQU+qOquCMhjXlQOU9+/bN2fIgsLpqOOa
 WXq7QY1x
 UR5jVsHGkxazTwWkGHffB0wcbqBr8sQ2aX4n+ldHboophiYS2t3vVySvtcnR3A9llDZQFCBUQMVAg6kZusOwvJVZxVUnQsrCnDDlrIzuJQ1zlciIYgCle1y6c7OoXis+fblPzy/5nVHUmt6JrYnjfXlguG6LXyRHVMV5oJ2YuUIXjtc+E6i1zmWYtmQsIDLf1M/fiqqNdkr+DmuJLnoJ3kqqvWgdbAVQvF4B1ZtSN4Ge3M2V3mNZjNmFSDg8quM6Jn7Barhf9XVZBrfK86TTTq1Ri2O26n7K8bTaW78y6NrmMUj/f0Zq5nLeeKVRhRRFjM2gBTAPVhv1FYWooy8KjaeC7ng==
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
 mm/memory.c                      | 31 +++++++++++++++++++++++++++++--
 mm/userfaultfd.c                 | 32 ++++++++++++++++++++++++++++++--
 7 files changed, 114 insertions(+), 8 deletions(-)

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
index 8e0833e6613f..6b633ec694e1 100644
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
index 6417d883d2e4..72cb44332004 100644
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
index 06473285c0dc..4f8b8dff0b7f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6122,6 +6122,16 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
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
 
@@ -6137,6 +6147,12 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
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
@@ -6412,8 +6428,16 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -6527,8 +6551,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
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
index c07e3232a01a..db3707b9d977 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2668,6 +2668,12 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -2728,8 +2734,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -2765,6 +2777,13 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -4506,6 +4525,15 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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


