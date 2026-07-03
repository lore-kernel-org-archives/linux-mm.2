Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B9A9C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299126B00DC; Fri,  3 Jul 2026 09:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE296B00DE; Fri,  3 Jul 2026 09:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051966B00DF; Fri,  3 Jul 2026 09:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6A926B00DC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 545DB14015B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:50 +0000 (UTC)
X-FDA: 84947565780.15.C52CE25
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf25.hostedemail.com (Postfix) with ESMTP id 590FFA0008
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=OBDQBb6N;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="g BkftAt";
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085808;
	b=Rh/1Rf1TuK9bD9biL4Vc+dvmlQTuGhNByS4kaBk6I610ghcinf+gOeQdVoEKiKwe3XVCX/
	RtsPtq7IkfCbovjLSiGoofyH+FkVOdd6Ti4DnirrlFe+b1JZTx/HhHhgKIU6SSXya+UqBD
	BQzAwvFEW754JnWyIDAyGFij+1SYeDg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84a9PK3Ct8p5TIcdRD9lg7P1nu9S8wKfUYQxDhyvEQ8=;
	b=xkyVwJQh2l3HNxE0LwzSqup58rUOtI2ZdvJr6Ly8CpMddgBdEWqpL43pPuB0l8b0RQxowv
	f1sZx2SLTO03Z4H8so1IsAqJJzIcu6UtwOMhA7HYZzybA9X2EoMfXWs/fADD3jQjh6cmrw
	kWLP3t742i5OMaN6mbm1/Pvnra1nvRQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=OBDQBb6N;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="g BkftAt";
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 2F9041D0005A;
	Fri,  3 Jul 2026 09:36:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 03 Jul 2026 09:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783085807; x=1783172207; bh=84a9PK3Ct8p5TIcdRD9lg7P1nu9S8wKf
	UYQxDhyvEQ8=; b=OBDQBb6NCZ2Tyhl+2JFCHxWHrhMgnrMaMh4PFb1cTThlSezQ
	2/SUegJK9BQ0+4WKVGgSJT1afVBzJwpYM8ZezUVJvmBvL99Z2e2aGdvBVtkEQp7q
	JIKuNNIGrLtOIy2hoMRlszr2MIzrCJKhe7gWQ9lhBQz3ztt7o4m+wnt5Io1cMoAv
	vbDuCp15whhb4RnTDpLy1uvNN/FioJUilQWck5PA7NtTJZudYIQppf4uW+3y90la
	VLdqPxRSVwo/nddgg5tj+YtgW4U4BCQPRrY78DydkeTRoM68dkAQtcDuULhNX8ND
	T3JNHSAiYrrfWOMLTA8eQzCL09vYVw8+uJpQ7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783085807; x=
	1783172207; bh=84a9PK3Ct8p5TIcdRD9lg7P1nu9S8wKfUYQxDhyvEQ8=; b=g
	BkftAtGMrF1pTKuj3Oeyem6g4akCz9Va39rWH5wsEztrJbFj7HDnkDl37fzwVGhe
	mFL+Qk1du6XF1xzf832LgmsBhM2gLtUTreUVQ2pz3NCqS6WvCxiR8/DfbWBOAGie
	uPCGJHrKK4EsBzn7awoFh43KHMkSzUpAwiFqwxktCON9Tp++M5ExpxxgZlBDgk3w
	643IP3cAYBydHXw1zuflaQjSxCU/cr/THPlD2AavykPo6mykG6IEXZAWvjpMtmhc
	b0dpLYybGqkGXiaqNJ5aAsqBHXplxVdi/N2GDdjPGtnD9gZiaKjVpu1Nc3GYs8oD
	zF3TpMpx+Vv0KeGWL5Otg==
X-ME-Sender: <xms:7rpHaiIW--fRMlFfRrvT8xKrbWJyrtVM9vVabUxzEDiaksaCIeB5lA>
    <xme:7rpHamA44IcYxmeU850VLHjW-bVGu36yMVdbT-MR6g49LhibAswA88w8h4PlYvJIV
    1FHEiSVnwBT4DP0D3bF8vCbMh9d2H6-1p9Fn5Wf8U7zJNJ7cp4v4l4>
X-ME-Received: <xmr:7rpHarhRevdJ9FuCste_vjateCd2MgqcPOxFaNrWPK-2fF6izaQw_Dm7Zt67rw>
X-ME-Proxy-Cause: dmFkZTF1+AtcFzjfXPBOkKcnuVuvEKWA51HaRP9bg4Pg6TSRWkw2MHE3+MEbJVMBeow/LM
    G0fikRttzVJzDKk6rANFKg424rq616qgOS/9yD5DKoV5dEBpH0UVw5qR7S6Dsd+tFle1cl
    xuwqoa20hLAx5TSmZkBbu5BqRWSSq2LwsJSfGKpcgimQ41klX/YFt9zMWoTEKqjLDdGEqk
    YAS7Sh3djm07z65afqgw6mRkP2PVAIusFaZ85XVnI6KRRQBmwxYFKmOravoaCbxfbr6lyg
    Tv6Zpys5DDsGMaV00Nb63KU6hP/F/fNB41j09tv/R6IOaTkqZwYciV6fTolkoahpFKveZg
    LyKOClxcNMUL8MhL9/xing/xGD1sUKKwmshW7mBXV5VpYUZZa31uF1RCoOREyHlSXQMUcu
    i9Je2lMImvAJKGg7Cc20zIOfpYCBf3SL57yrgZ6QDSVu62xBmCBP9E80iyggJbEtiC3xDj
    NX9t9W2Z6BD2I5KcKTfk3z19E1PpyETqsqfwG3Fy8IaKg395M4umZZAGy1aCkN7ORSMazL
    q8tgpK+zrBTsIEzOkGuOb0LrYJyFdOdCB9kS5sFmuvvq6ksU+r2av4hWXHs2yBT9eMYnJX
    lSwUEbBWBVAUmEPcHVre4MfPcozpQ+zzQkpG24ycF9ZSH2oJoSc/cMqsv7/g
X-ME-Proxy: <xmx:7rpHagNu6PioIqGwEv-U4N-bhgndrqDdCri4621S8lDqS78tSmrnIw>
    <xmx:7rpHaiab2tF9KxOGhu_p-QUtT7rnEWVBR24OuQVd01QfUgRgnB16EQ>
    <xmx:7rpHal9ZcQyg_q0OqbiWXfmzoQah-RtYJ6-OZug9DCxKpoAF-3wIpQ>
    <xmx:7rpHal2WxEDIoZbHldvgwIMHmHG2DBGvYWvveFhvLlokgMhfRKgrsw>
    <xmx:77pHamYIwoNUxxY67OeDHPWQA2L04erxYB2BWAcsBmfoHy75xRsZd0dJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:46 -0400 (EDT)
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
Subject: [PATCH v8 12/15] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
Date: Fri,  3 Jul 2026 14:36:11 +0100
Message-ID: <20260703133615.1039465-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kxygz8bam64yriycoighe7zx9wtqi6ou
X-Rspam-User: 
X-Rspamd-Queue-Id: 590FFA0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1783085808-202040
X-HE-Meta: U2FsdGVkX1/wBhyf0LsHB+0RY5vjXqLu200TYGhCrRWEerd6yefCLVcyZmzA01VJOGeO3lNj4wDTFYM09zMRiv6TQTcBBMQd8JZjXpjiE95jsipWHo209UCnQwH1J9c70f36DnHznhTKdNNE5diIeHaT7YMwCVclkYSFCyVDiJTkS542uQto3wGQyPuxfSdJ1uvgDhVzDhceumvx/yYCm2PuJQ4BvOkX/wxxVaMjr758BvfOcFjXOPSZtWd+nE27tl6JTohXkDUj0ccYSTfr4LzjIShoy8LLPEKi5+RFdV8TuDJsIlC7ZbG74/QXZCwj4sQRiGqmGHKtV3Tdpc+hQOcMS6rylyf/DDjCsDSAIZN7H2al/o7iWViIA1PMz9hyAjaZYzz60Kt75ZFPXN73MYIO2ix/1w/NxQsPAXHF7+GBqMqsKHKvSQ1FoGwqYfXfxHIa/Trr4kaRxvxy3O8/rxPRvqzQrCO+H8jb1yomBavGhNgnhlWm5p7ok7YdGDMrUKbsnzOrpNtVLIul1Vk44Lpc6jSxxKbRHwdg5/VU4rAqvWWc0Sw53PGo3RdR/G/iLj2OwFqMEU1SYlO8anGPSZfxYez1zdURxNHQO6Uihhhur/85YWSGQOP1G6QrFsKbOUQ3a9LGwtvToz0K0AEb5fT8irI8Se86kBMWVH97Vtk0u095uD7wJjxj3r88T/H8i3aty8/5vXbJ4ekfP/X337Qcw15dG+z1/efvOyo2cfsVyIXD5D4FahbmDMOmgQr5WATWNfdbjdHoYoatDZkBbZl8rdIRrxwuhBGJhyFGpOW5oMtL+R2dRe7KxdaagPrL8hJKr1pdoAprZtzO54V1A5Us2HoQ6Kb0s+fu17DTd3aChhpwW7dMlJzw3LYMOSU49cKl9lTnRleVAKdpCZ/tXtDSSRxDBYNF2TbM7ucGbHZQJz37KznpsJh7XQJgEdC2QNjuvduc6A1qdMVHFvi
 Edvrf7Oy
 STGBSVguNlOKE1r2j3yab0uuJJ7Yyz+cMWwW3xWTrm5PQolPVRvcV3H2oa5R+oeHAYVwI4muOcTVhGWSTs7vQL/v7eJoTLcoQ+ymvjJOCWeZ3ipNh4EyZvc0jB/HV/9gpxIlO4F8XSlMsH85CP/MWtpL4CtyFBA4ifX1vMUgDPOAcUiet3srWfEI5ElXzDNyBs5XI3Wq0z8VmoId5RHTStdt8UNiSI7kvygrb3GvMv8VVqoj37jfHSFbLKbGbOwB0pHm93CKLnCNLybZqgYSF/HbIqYt07P6cspG576cU40yNJpu7f349HewZxDa5Ot5+FkXTmgs8bEARrm6V+ID7NfXfgoOP42Wdp7W2I/K8ybK34FAuguLwjJsvKx5NbLSJjJNnvIygas9M2uOKBoB+9ujbmbdU34JttaJAKZvJdghecrdNVKiPR0fQ06kytpIXjY5LjLSzwrROxhDX3YT0fUrnpefarl90RoVrjh34jgFon+/mi/J6tCH1jLlNOi3FDnd4hcwPFTC9Syhk/zgSZOldOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Sync RWP delivers a message and blocks the faulting thread until the
handler resolves the fault. For working-set tracking the VMM does not
need the message: it just needs to know, at scan time, which pages
were touched. Async RWP serves that use case — the kernel restores
access in-place and the faulting thread continues without blocking.

The VMM reconstructs the access pattern after the fact via
PAGEMAP_SCAN: pages whose uffd bit is still set (inverted
PAGE_IS_ACCESSED) were not re-accessed since the last RWP cycle.

Worth calling out: async resolution upgrades writable private anon
PTEs via pte_mkwrite() when can_change_pte_writable() allows, mirroring
do_numa_page(). Without it, every re-access of an RWP'd writable page
would COW-fault a second time.

UFFD_FEATURE_RWP_ASYNC requires UFFD_FEATURE_RWP.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h    |  6 ++++++
 include/uapi/linux/userfaultfd.h | 11 ++++++++++-
 mm/huge_memory.c                 | 25 ++++++++++++++++++++++++-
 mm/hugetlb.c                     | 32 +++++++++++++++++++++++++++++++-
 mm/memory.c                      | 27 +++++++++++++++++++++++++--
 mm/userfaultfd.c                 | 19 ++++++++++++++++++-
 6 files changed, 114 insertions(+), 6 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 8d5d6ca60b67..ca718e8590c5 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -281,6 +281,7 @@ extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
+extern bool userfaultfd_rwp_async(struct vm_area_struct *vma);
 
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
@@ -459,6 +460,11 @@ static inline bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index d803e76d47ad..c10f08f8a618 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -44,7 +44,8 @@
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
 			   UFFD_FEATURE_MOVE |			\
-			   UFFD_FEATURE_RWP)
+			   UFFD_FEATURE_RWP |			\
+			   UFFD_FEATURE_RWP_ASYNC)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -243,6 +244,13 @@ struct uffdio_api {
 	 * UFFDIO_REGISTER_MODE_RWP for read-write protection tracking.
 	 * Pages are made inaccessible via UFFDIO_RWPROTECT and faults
 	 * are delivered when the pages are re-accessed.
+	 *
+	 * UFFD_FEATURE_RWP_ASYNC indicates asynchronous mode for
+	 * UFFDIO_REGISTER_MODE_RWP.  When set, faults on read-write
+	 * protected pages are auto-resolved by the kernel (PTE
+	 * permissions restored immediately) without delivering a message
+	 * to the userfaultfd handler.  Use PAGEMAP_SCAN with inverted
+	 * PAGE_IS_ACCESSED to find pages that were not re-accessed.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -262,6 +270,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)
 #define UFFD_FEATURE_MOVE			(1<<16)
 #define UFFD_FEATURE_RWP			(1<<17)
+#define UFFD_FEATURE_RWP_ASYNC			(1<<18)
 	__u64 features;
 
 	__u64 ioctls;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8b8a5979ae12..c67261f04731 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2204,7 +2204,30 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 
 vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
 {
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	struct vm_area_struct *vma = vmf->vma;
+	pmd_t pmd;
+
+	if (!userfaultfd_rwp_async(vma))
+		return handle_userfault(vmf, VM_UFFD_RWP);
+
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd))) {
+		spin_unlock(vmf->ptl);
+		return 0;
+	}
+	pmd = pmd_modify(vmf->orig_pmd, vma->vm_page_prot);
+	/* pmd_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pmd = pmd_clear_uffd(pmd);
+	pmd = pmd_mkyoung(pmd);
+	if (!pmd_write(pmd) &&
+	    vma_wants_manual_pte_write_upgrade(vma) &&
+	    can_change_pmd_writable(vma, vmf->address, pmd))
+		pmd = pmd_mkwrite(pmd, vma);
+	set_pmd_at(vma->vm_mm, vmf->address & HPAGE_PMD_MASK,
+		   vmf->pmd, pmd);
+	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
+	spin_unlock(vmf->ptl);
+	return 0;
 }
 
 /* NUMA hinting page fault entry point for trans huge pmds */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f0ce2e9d4ba2..a82f77b61e29 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6071,7 +6071,37 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 */
 	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
 	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
-		return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+		spinlock_t *ptl;
+		pte_t pte;
+
+		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
+		if (!userfaultfd_rwp_async(vma))
+			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+
+		ptl = huge_pte_lock(h, mm, vmf.pte);
+		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
+		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
+			unsigned int shift = huge_page_shift(h);
+
+			pte = huge_pte_modify(pte, vma->vm_page_prot);
+			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+			/* huge_pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+			pte = huge_pte_clear_uffd(pte);
+			pte = pte_mkyoung(pte);
+			/*
+			 * Unlike do_uffd_rwp(), do not upgrade to writable
+			 * here. Hugetlb lacks a can_change_huge_pte_writable()
+			 * equivalent, so a write access will take a separate
+			 * COW fault — acceptable for the rare private hugetlb
+			 * case.
+			 */
+			set_huge_pte_at(mm, vmf.address, vmf.pte, pte,
+					huge_page_size(h));
+			update_mmu_cache(vma, vmf.address, vmf.pte);
+		}
+		spin_unlock(ptl);
+		ret = 0;
+		goto out_mutex;
 	}
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index fe1d605a4d66..5b7e2ec8ae02 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6166,8 +6166,31 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 
 static vm_fault_t do_uffd_rwp(struct vm_fault *vmf)
 {
-	pte_unmap(vmf->pte);
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	pte_t pte;
+
+	if (!userfaultfd_rwp_async(vmf->vma)) {
+		/* Sync mode: unmap PTE and deliver to userfaultfd handler */
+		pte_unmap(vmf->pte);
+		return handle_userfault(vmf, VM_UFFD_RWP);
+	}
+
+	spin_lock(vmf->ptl);
+	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return 0;
+	}
+	pte = pte_modify(vmf->orig_pte, vmf->vma->vm_page_prot);
+	/* pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pte = pte_clear_uffd(pte);
+	pte = pte_mkyoung(pte);
+	if (!pte_write(pte) &&
+	    vma_wants_manual_pte_write_upgrade(vmf->vma) &&
+	    can_change_pte_writable(vmf->vma, vmf->address, pte))
+		pte = pte_mkwrite(pte, vmf->vma);
+	set_pte_at(vmf->vma->vm_mm, vmf->address, vmf->pte, pte);
+	update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return 0;
 }
 
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 388a91435d35..1a3504c63597 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2494,6 +2494,11 @@ static bool userfaultfd_wp_async_ctx(struct userfaultfd_ctx *ctx)
 	return ctx && (ctx->features & UFFD_FEATURE_WP_ASYNC);
 }
 
+static bool userfaultfd_rwp_async_ctx(struct userfaultfd_ctx *ctx)
+{
+	return ctx && (ctx->features & UFFD_FEATURE_RWP_ASYNC);
+}
+
 /*
  * Whether WP_UNPOPULATED is enabled on the uffd context.  It is only
  * meaningful when userfaultfd_wp()==true on the vma and when it's
@@ -4415,6 +4420,11 @@ bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return userfaultfd_wp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
 }
 
+bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return userfaultfd_rwp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
+}
+
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
@@ -4518,6 +4528,12 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	if (features & UFFD_FEATURE_WP_ASYNC)
 		features |= UFFD_FEATURE_WP_UNPOPULATED;
 
+	ret = -EINVAL;
+	/* RWP_ASYNC requires RWP */
+	if ((features & UFFD_FEATURE_RWP_ASYNC) &&
+	    !(features & UFFD_FEATURE_RWP))
+		goto err_out;
+
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
@@ -4540,7 +4556,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	 * but not actually usable.
 	 */
 	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
-		uffdio_api.features &= ~UFFD_FEATURE_RWP;
+		uffdio_api.features &=
+			~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
-- 
2.54.0


