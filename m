Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C3EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28656B00A1; Mon, 29 Jun 2026 08:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6C46B00A2; Mon, 29 Jun 2026 08:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52AE6B00A3; Mon, 29 Jun 2026 08:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96A516B00A1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2238A9037C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:17 +0000 (UTC)
X-FDA: 84932827434.04.8D3FC72
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf30.hostedemail.com (Postfix) with ESMTP id 24B848000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=cOPeAtkU;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="J epfbjE";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734895;
	b=rzUD1ajuPqmX12S1xdGZKDObwkrPidK4KSPj8IvDh3Mi82s/5+c6wOkbEx8+7X8dcgTVfN
	V2k4Lba5wZDngbmZ/U9He7vlmEsIZwnpLd80AVFCu/QNBJHUfybcpJNwfI8cp5NY9js3kH
	awZi0me9bIZHZPshs2k2lgUgF+1zH8U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9dfdH5SKHpm67jNJrdE1cA+mXv6/1X1jgZwwXpfCaY=;
	b=8Luo1b0OBTfXRbu1Px22v2TRWtoIH64w9L7Kdg6K3MxBxuT8TIQFP+OecwJNdGb5vMHEy+
	2UKpfD0y/1A7hjf7zhuoVdScF77CJRts4MabFlkqKBj06FzBn5dNNPpRGWcHjditWmH6T4
	J2zWE7y2rS1WXQ52omWEpKhLfvQwjzs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=cOPeAtkU;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="J epfbjE";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id AB320140011C;
	Mon, 29 Jun 2026 08:08:14 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 29 Jun 2026 08:08:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1782734894; x=1782821294; bh=Z9dfdH5SKHpm67jNJrdE1cA+mXv6/1X1
	jgZwwXpfCaY=; b=cOPeAtkUA5+qnExfmgZOVkD/FB5fpJ9Ju8CWCfdqWRAWVTk4
	LywMsg7+X8USrh9IGE2YQ+0T0Vs3Meilqgxg9LvcvSEnx3W84kZBMHWuqdDkuo5t
	s9aE7FYQlLTFOmXffz0a4joD3kYkdFc3FnbBNA8rBZL7HyDRgcJ9bM0DBEj+FfeB
	+DJg7NvkiNdRqV2kWRSz/LbrPky2lePB70foDH+QJWY4PsD035VB2Fs4h6zazjm0
	oT2QdzQxHqwFZJpQCpiGU2xhxxbAJ8CoGrdxzNOKCBM95VVIbAuIdDeKzboxzff4
	GdgZQzBmw6C3WnnqXYEVBZlEQiu9wxWLypKedA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782734894; x=
	1782821294; bh=Z9dfdH5SKHpm67jNJrdE1cA+mXv6/1X1jgZwwXpfCaY=; b=J
	epfbjEYGlmkb5DbzmRZm/8VC3JzUS50zt5/5lJolq2w3VtHlcsR+Ug91twqmotd2
	hlQk42GuefM5xRxlLkOMDNbUD4EcJ/e3djdlHGRRIN7BDaTTY2YjabDdBOdwy5Qa
	56BHa4ejB1YZlBHnsjbNhvqKIATmoqoVL4+a+8XrF3VPcDuEOaNfdQIJXXW1eFYw
	bK+ys9uAAqcSA3wDa/eNVQdwp7MFtynpx3I9z56CAadAD+0tH3Ha7YLbXFpfO9AZ
	5txn4rKOt6VjsETigOgiDxpmVWmhmFG/DJIkEBWqCdh8jk3U5dIJGl0Pl9CUuNcv
	lDSR7i8dqQwXKyM/isD7w==
X-ME-Sender: <xms:LmBCahBQGXOazwRogKKG6KszetimKgtPz7stmZEg11dTNziHocVkRA>
    <xme:LmBCaje-nzw-IY6Uk1IfTlvBKeTIR6pJTj9B06qR8s3LsmGCQ4O5sskRrhvq-1fF7
    FxzNIFK7adsKHaKe-ojMS1OJr1MQlyWffZSChkPjdLvapkCII_kFCA>
X-ME-Received: <xmr:LmBCalGnWqpGP7tnFqQiR5qV88QunfsNT_Xn53yVnK2pSGligXcGMqMmBwS85A>
X-ME-Proxy-Cause: dmFkZTEbeJVw6LHQweWhVxV6YsjHAMw/x6M6i2UioCpAmsrJGMnjm7JCfk5Nb4aoCqvKnN
    91tRPzQkxIdfhn03N0ZpwuVqidXzNPJfeGWLvbpIh0Vb/OxkWky2JSYOHrAYJQLLSAB7AL
    toy2cpnq5TVKX0zNbh0LHZsT2sTwF0477WE69g5lswYPot14j81Ea+hOFPxysMYC/MWVnR
    3Dzoy9inuC75prIkon2ncihK+vG72WjpEkuux2GDIB97l3OQISzMRmmuo/8ZARgSjSwpQ+
    UM6vUvaQCbvfx0vplMOYjWf6ufp0BqVYgaIkGB0rpNNA+DKzK1TUU+7BMGyDUwBoGP6vRB
    6rfVl83GslF3VWIVQHCQBF6qYZPLzBEb8ifaAuhmjqSGzqS8cQYz0w63TyBk96SjVGOwXo
    UWssUJM9Jk3Qms7f4GXe1OWytDs034m69PjyCMEi4g1WUrMT7tWf2J4oKAH5pyaH75Kv5n
    IbmHaB8NpOWZj6cc3D3d69w5fCdOnTL8WS9mJMVyNf7JyGzKLggDMygvf+P7jKY6MqdPv4
    J1BBGAjGQLfZcQgxaeA3kcCvY1Syj+ExhG5HpIBPE1DVKrahWTrDUc6eQThZOnNnxeH6HG
    Mr1eErq/neeFh2dexz8C7UUTWVxI6uxkyNx7E7tsfiEnScAKPL3qsir74SUg
X-ME-Proxy: <xmx:LmBCalUUdOkdVri5MW4ymf17fmD53aytvxbgCKFwQt2SBpXGyHyz5g>
    <xmx:LmBCatxY1fP2lEccDJpnlMpOI-P0HvkKkAawmJwh89eXjWsY9Ti9zg>
    <xmx:LmBCaouPxTHH6BOAnhTj3i0cIdoZTOVd7gCuahmJFzLr6n_T6G9-_A>
    <xmx:LmBCamAmKt6Fu2R5bHiwOwPMj2Hv9MKa3qcLtrNuU9xHJgGZByrcqw>
    <xmx:LmBCatNWkD4doC32KEw4uFcnTtm-mILaR6-Rp5YNqS2VUDLa7LRLnue6>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:08:13 -0400 (EDT)
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
Subject: [PATCH v7 12/15] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
Date: Mon, 29 Jun 2026 13:07:43 +0100
Message-ID: <20260629120749.566063-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24B848000E
X-Rspam-User: 
X-Stat-Signature: mmjfouszngu3msekk6aojj9cx11e8xdd
X-HE-Tag: 1782734894-553633
X-HE-Meta: U2FsdGVkX1868QFBZBEQB/uSeSW4jbgMFCio5xzyQdVKi9RvdR3c6E0XDP7ByDZkbMpTxKEGSNggkG0jUUiQ6AxwyNT1jj/hC60tNii2wgDV4v0rGX+y+0PMOuz2AkdaGo9uGRR1yN0BlVpXC1xD4u5/iLQPhMNGvDlORNG3ag8p6KUjS8455Fjm7r5X4lDm6flDeJlGHbAdo4PrteI/hKdu8q9p9kv5kk9yIahT72tB9YDjwrn22xUJsy1QUd2YcGijxTbX930wnlc1RGOshtpS5wF3nBZmL0T1Z0+O9f2XzdfRQdkgUX6mkKiA3TAYoC0MRHWbQF/jSHslBCb8Y1m7YTaizRfFpBKfKG1b5mdnhD0Z9+Hf4RjmSzQDZZW7d3uh+SwV6qLazcPe1R6UpSx+JElmMutmffBXpfZF/3onvSSCoxsSkHUkPSAA0JxU/IZknCZkqcxl8+LuA6q4sq4a61CGo64D1MNPUE2KNY+ZlFCYeefSPOdGM1YVi1Aaqf3kWEQPn0kGDz8ZhjCnIJylJTxYaH+KSEZgIhJ6Z/ccMmmch2kk9EUnX1DnGQbbuMlyTpcaPCUrq++aTUWnSkLKtvRoddNGLmC0IddHnyJO5KtpyC1WkJKrnf56I6prmyY+bYg//E5mNBbDScohiEjcBRHgBnX98IqNBV3SQykrNNKWXNhOf38xHHcPyRGJ5j+c4KChKfb04ZdaBnhD+OVx1WuTK/xWgMh6xmarualbEHjqGri6I7HulOj1L7Wy4ELqo25CUl+1u5riVNd15m+WOEo6NDqYUIhGFcMDQmI8A5YGsaG/XT/KtXSqzCdER2DkoIcVHMe1Petd6YpSM9yqt5ka33+2NAke1qcNjtLnn2+D0W707N5ya8eZkN/56svgWSPl4yUdCrywbnrPOu4h2rSKA5erOukX9kEDiIY52jWlIxiJx9tXAkDu3PE7pdXCnPdNLnZu8pyF0g/
 CjKwkYvb
 W3p7+2sMdBdnpdBWprcDFIQE9w+BiajdAOPYwq9tBIgdpxOGGnw+dUjBdeXHBFdqujaGSkoN/PVtFX/c7s4pBx565OcOYtHCpfCI73NQwybl4JAoMRktOzTF3NmIKvwE1nqjA7xU7VGGD5+N98FM7WH8wFVfdHUuv0A9IobCzckZlNk+4YOHlAIVTKl1qcso3Q5Vix4niudwX9Q9Jbctou1I7WJFT/z9l3EfyNc+0kXdlG08U90ECRl9DQVXnJBPsiAOSxFEKI52YoF2WnA6tjw87sVRIPe9tVA3CYrdgl0Oge/VmAdHJ2ghFxzE11N8+vqTbdtUMWwL6SlRZAYRqTYfblvpp/05Meyp5IYgSh6TaTiDmWP1QtmPmaxL07+Z8DQ30LiLIOraw71SUWuMuERbI+asrMEAMWb0mwuLFJ5dlm6TvGrmGtk1KyK1IquaQmgFmnouPZOWFh+7ZYN3UOLbrs+k0sdzS7h+6hds1yjMc5DkINJ9ZRgQRaIwlnIP+cN0enfbTs3ULyN76vN1gR550rQ==
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
index 39f705fbcbc4..400a35ee536f 100644
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
index d4da39d698b8..9da52d95b3fb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6070,7 +6070,37 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
index 16b7596625ab..20abe12da481 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6153,8 +6153,31 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 
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


