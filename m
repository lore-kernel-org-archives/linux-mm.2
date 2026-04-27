Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E71CFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1946B00AD; Mon, 27 Apr 2026 07:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A066B00AE; Mon, 27 Apr 2026 07:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FAC6B00AF; Mon, 27 Apr 2026 07:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76F786B00AD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:47:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45B6212015F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:47:31 +0000 (UTC)
X-FDA: 84704160702.11.869A5F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3DBF3160011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:47:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=klPw+8QE;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lm46fnrboymLQUfB59zr/w7Yi4doUkb84inuZ/vTrKY=;
	b=pWvNpdH8sqbisb4ZBFvNOsPEoa4+Fj5jyNCJDFPQDlA2m4IIYjYmV/XAmO+HWBJf2vXQRe
	lRRZIkhWDymGtG1HbNpriJi76fFnfjGe7y/cYB8EMuRjeYDMzxlGKRgiAnE9DZ3sEj0qHU
	W98VQSwcmAwVpiWBs2n0W7+6xdx1q4I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=klPw+8QE;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290449; a=rsa-sha256;
	cv=none;
	b=wTCZyuejONZasCqE79SR58jMLYcU2GPeE7AUa4FQbttVVLmnYOMkNU/km6/ODTNStk4cGw
	TjegX9GgsevwKkDkOVKdzmH/Dl++tCDUa7/ldOB37vAiV5xlDjw0maTJdHVcR3aOwuA7KH
	mUYicNsLsrI0R6z3nufluL5clltWUmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A761260180;
	Mon, 27 Apr 2026 11:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F23C2BCB4;
	Mon, 27 Apr 2026 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290448;
	bh=kJbcMJlpsyLEDywKd3yLGpkL6ZqjGtsC4/OESxF6sXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klPw+8QE8GxfypIby3hiwkokseXSDvxTAerl9soWMjspvfH7N+yzHRR/OM2RylSV1
	 LGUshSRQZ4t6x2uwu7yvaesFW9jEA8MjFMNNVdT2NLdQum4WyRvnzyBZjVMWvrhO/U
	 GsIguCm0K/cD0ZmwQDHOy57iZeXBKaHNmLoDKonKp9nxEVfrFYSGaeXwUVfJxQUd4X
	 TwYMFKsfbGxvbbK29P2P9xpoLWt/fnvyLt2Ov+uO2DKgN6et3RXFEmHRMmL2xP7uxM
	 yjar9AG/he+tOT5HhO8bdwrjBxDbd2JpX0enKgqBkKPVT6uUfUb30TgxjBvb2Q8XDC
	 tBwBGQtOC/NeA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id E3BD9F4006E;
	Mon, 27 Apr 2026 07:47:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 27 Apr 2026 07:47:26 -0400
X-ME-Sender: <xms:zkzvaR1SBWnvGMykW82tF2DKKxNg4CTqU5eZC57vZseB0wj8ELHBUw>
    <xme:zkzvacBL8CUHSYRBQL2RoFjUl4LSbzYJ5A672OmDI_YWfgTPEr43Hb7ajKd6b7O0v
    vsiDriW_m_Z9AdM0Hr0jKq-cLdktKtNinCsWFg4wEVmmLGLj1yqk64>
X-ME-Received: <xmr:zkzvaaYAHKlCCEJYgn6ma7XUs1fGGsIIuFSHhKqH67YC73PV2P4YKeilANLtqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceo
    khgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhudejfedvgeekff
    efvdekheekkeeuveeftdelheegteelgfefveevueekhfdtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprg
    huthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhk
    rghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtph
    htthhopedvgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhn
    uhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghp
    thhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhh
    hofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgr
    rdgtohhm
X-ME-Proxy: <xmx:zkzvaYZ7ZSjRETcHZcIHLSZCUGhfXvZdkwevZatxtry2XRyfZf1e6A>
    <xmx:zkzvablOgEIGfYS9C8s01yl_TaeAkx3otQBZK4MR2XuoO8yR13ThUw>
    <xmx:zkzvaaTMMJciHqpOIp0xIpJA8U6mqt4fUDJY5NP09w3xfyorAJ1W_Q>
    <xmx:zkzvaQWgw2ZGlLBAvd1fUCr9qgp4Dx4Ae0mXdO0rdzoYxq1ii76WIg>
    <xmx:zkzvaQvPTbaz4_m2_azwKttpSaJaIJDUS2izkrqdQLbJJn7ngYuIsXuQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 07:47:25 -0400 (EDT)
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
Subject: [PATCH 09/14] mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP
Date: Mon, 27 Apr 2026 12:45:57 +0100
Message-ID: <20260427114607.4068647-10-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260427114607.4068647-1-kas@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hnnzm6693jmpqgpoypc8ixji5dbqi9dz
X-Rspamd-Queue-Id: 3DBF3160011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777290449-378914
X-HE-Meta: U2FsdGVkX18b7vb5GaThs9rsqkSH2Ra5iLj/ENhEycGp8FwsNbwvPF+vAt41LyS3j/iIbARUB/k11cmIXe2Yu5OB4sdPcGrbrD/WhGHAdsltAi56RdskADgp9+jWx5rRblIWbY/h/Bzv65gTrozEGup6y4YsYZU5kN6z6YH6tuQY7N898XQdgtqrM6+DyKBFPbMGoFHAn2sIRQ/1C2RSYI7MwddZ8Jn4poPUD6oPuN5aMBzegS0UTi7sMgY8HWuojfRhgjj0jvEC1PyMxxr0/b/Ja3dV7mz1x3FTIR0HYuyjFkSrB1TIxojQ7ES+FbfVf57hOqA+GAPzir7qeuAElknET6uhmsoSgyTuUfMIsS70bLkkJ+V+yJRP76TomqptVwpX76Y5f/nl/G9JXGQ5LWxQRt7VNlmwrXS47urK5xGqEirIljCL2sfr3fEENAHdqEYFuGQmy+Km+uU2tmr4m5Cvyyoov0pdGAvfCU9CKfXzbkuiJm6znyKt3Lv1t6jQhw/frROAGgaQNPWK7LCgwCHZ1yKU3nrRdYOrlFoIx6tz8AxW1ItQZ7UQtMLt8kn6LguoGdCjEAPegvXD2n0p7IWFqUJmSIQHW4SxkvvYr7u2V9wuK5fb1fww+cl6I1/CD6Q4ckG/YyydhzUvqdwpM/SsimZryDqaT/4aVPLbvd/11AeDzaNYLq1fA/Lftnn2ddSrKKC/HxpP3nZG4Vr7vRLaFq9gLnLZKTXuT4fTM+Q3OtLcRqjo64r0gUBcV2ge1ksEPaB45QsTH0KMUXDGvAoGSvP36PSDR1rrzgqWu1pylgCjClddqT0SZbH5EGDFkNx8qg2ZNaSY3zpfDL00HGCJggWyMXfYPzmIZXtgzkmMst7slR8s5ydKkgBvbRmg1d7cuHOl+C4KwuC3rr2EeyU9TWGJNmJY9cucS6J3JNBgX+6hNLBAudphCTM9XpB5PkYfaJxuXkZTCbstQgK
 gGZWkhXm
 HzwBJi7dFPh65ktkF+RXVQpE504VKXi8NELZ17Y+jHBGDthg2RDMWosDOgYiYIzhUchffTiJfkB3PtcjwfTibbtM+d5hU8fQMctBkfrs+EMah0ppIhrjNOo50+xpOsIRHCUS0j/k6l6bwymkzuOg/o2IV2XX9SB7YRvWfUdosI3kThZr9jYPJVNOXgrUoo2OlGLFNE+RcImTeyKSZ6La8AIYreRC4h/u+SQz20PWBlupRxbsLXEbKsiPr3V2e3XMdswM/Iq/eaP9CDfOUnFvyeiOy+VvjqPevDLD+wQDrhtDoiRcCNNDE2QFtnA==
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
---
 fs/userfaultfd.c                 | 33 ++++++++++++++++++++++++++++++--
 include/linux/huge_mm.h          |  7 +++++++
 include/linux/userfaultfd_k.h    | 24 +++++++++++++++++++++++
 include/uapi/linux/userfaultfd.h | 12 ++++++++----
 mm/huge_memory.c                 |  5 +++++
 mm/hugetlb.c                     | 11 +++++++++++
 mm/memory.c                      | 21 ++++++++++++++++++--
 7 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index f2097c558165..6e577c4ac4dd 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -261,6 +261,12 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -321,8 +327,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -347,6 +359,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	 */
 	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
 		goto out;
+	/*
+	 * PTE is still RW-protected (protnone with uffd bit), wait for
+	 * userspace to resolve. Plain PROT_NONE without the marker is not
+	 * an RWP fault.
+	 */
+	if (pte_protnone(ptent) && pte_uffd(ptent) &&
+	    (reason & VM_UFFD_RWP))
+		goto out;
 
 	ret = false;
 out:
@@ -2086,6 +2106,15 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..e980909ee49e 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -520,6 +520,8 @@ static inline bool folio_test_pmd_mappable(struct folio *folio)
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
+vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf);
+
 vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
 extern struct folio *huge_zero_folio;
@@ -702,6 +704,11 @@ static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
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
index 3dfcdc3a9b98..37e8d0d29353 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -247,6 +247,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
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
@@ -399,6 +411,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
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
index 2aecb6d01c44..631e0355919f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2264,6 +2264,11 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
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
index f2f1eb6cf66e..bac9aa852f6b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6067,6 +6067,17 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
index ea9616e3dbaf..e0dcf2c28d9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6172,6 +6172,12 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
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
@@ -6446,8 +6452,16 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -6561,8 +6575,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
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
-- 
2.51.2


