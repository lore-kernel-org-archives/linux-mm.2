Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51941C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A87C6B00D8; Fri,  3 Jul 2026 09:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3396B00DA; Fri,  3 Jul 2026 09:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336546B00DB; Fri,  3 Jul 2026 09:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E50E46B00D8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E0B91C5B3D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:45 +0000 (UTC)
X-FDA: 84947565570.21.6620CEC
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F956100005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y SuOORp";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=piyqrpK8;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085803;
	b=6HELiqq5r3fSuuLY7+9rVOglkUueCw67YKRuB7bDrkNvxsgBkxyGQZewYPxptIYfZnxig4
	JCRhQoCRjMLX6YTx+egONLXZP/aWS92IX7UtNltyZqlanJfvQBXLLlZEXYLgKHkkl855V/
	vDn6iloIH32pJ982ojHIrsOLKzWP+Xo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnGPokI8NoPIw17S8aI7OUuveKncQuB0CodfcIUfH1I=;
	b=zEL3+2BjJYBhRuOYmNHDfHSCV0nSmPLfloxy3QPThM3CHF4FT5CHsHLz6jcvSXvzBC25/u
	2mHL6N6Gi3Cc6iT/e+TISWZjJkQsWwkJvUKLheycf24ByzV/VC5Qt7K9Lzk8zG3EovgKgn
	Gujw7mP736i+CxVGosENcRyYOPuWLwc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y SuOORp";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=piyqrpK8;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 5659C1D0005A;
	Fri,  3 Jul 2026 09:36:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 03 Jul 2026 09:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783085802; x=
	1783172202; bh=EnGPokI8NoPIw17S8aI7OUuveKncQuB0CodfcIUfH1I=; b=Y
	SuOORpn+wWmFsv2/puv4HVEarrGTPKHXxLfbyMyRmlH1ATbV3af6jI5q0/Sy8a2R
	87fBKd8MLz3queCeDf5zeAOrAoBuwalB/rE6r1MlvaCFUxVg9oQZRgiOOsMif6KW
	KEPEQBERPvCyxT0RsZO4dDHTk59/G4y3Kk9aQ5qcD8OmMbiAuorZCL2x+kHQF/qc
	nXobHoF8vLz9VavmAZPikZP0y+DtvW8QbL73Fm6QJUo6QOpDHYk/26vzthEpUC6f
	dFqB5FtoxJ8aA974/eNLF+pYan58on7RsZeYdEvrlA8WnSz2BijrODoC7WcmihK/
	6iaVOD2JkoKvnRE3mAIuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783085802; x=1783172202; bh=E
	nGPokI8NoPIw17S8aI7OUuveKncQuB0CodfcIUfH1I=; b=piyqrpK83sJydHy4U
	+nRv+IQMme5nc1lnwk91IYk86dU9RsC8Y2oWnlNvLiSpjs/WVF7vBAF3pauNRmn7
	NmiA7c7ziFH4sJEzr+2t/6fnxHceBMcJx4hp/cQLnIFFu06opX+jXWV5TcuJUAJB
	d8RVYyb9Pn4KTZd1zjK7XtfSIVAO/wXSz++AI9rFAhExarrXsfPJ77tr/Y1E2kAl
	wYKmZcElrbKTF9usJBK66fel1oGMUo6wcxSIX2an0VFcb/9A645Zu7SwwivDQPiL
	M8TFcXBayZGdUUObMh7sWH8rdV9gKpPxZ5Nkc5PSCKCIhad21HJnbGJD32inKu/b
	egb/w==
X-ME-Sender: <xms:6bpHanYgzK3XZuOq803nAdOcHWC62Y55QAKjNX_xLM0EKK3uSZTbhg>
    <xme:6bpHaiQWme6sr2nyVOn04_qWRwzFMDl-orezRPPtwG_bULY9Gzu1pqyzVbmP75lXu
    mgoXrKEsRlyePACT4rL3xNfSPaxGLj2hoaY4_bNrcX8s2ONaTDkiXo>
X-ME-Received: <xmr:6bpHaizWHjQb8fP0uh9ur4EZxQWhTklnda05xPlXk_KOXSqSFvEplN1GrLLV4g>
X-ME-Proxy-Cause: dmFkZTFugVRxFdH0dMt22KIYT6S26SSG98N0sz+ys09Hlr+AnmeajYF1RN40hpGypUpqlJ
    Zy5d5jLGARuczyZO1OdMXn8vTiUEU5e041N3yfZtKjqAJ2fvSnwYTcPKrlQ8VpRdJVBZzT
    zWez++VZ8twwgwYUntmWOLuiz+JddIPneaaJpHaGxbGUweQl93yRdt1mLP1v11JzYxL0TR
    PjwvC7VHBsh+pFBwV52NT5Wi2gI/nElrIms2Df5C0iyrzcKgELK3rpQpBE9FsReh7PU8JH
    HSiQWhouKdXxBitqX30HTHdkATiOG+IvrpxSrzooOF/Wd6aJR6SYeTFYyzuXA81DmL1FZu
    dbuHx3RPaS+fDUg5W5fHLoILK4x1qT65gUpbVNj4+LXvyGHu+dCdWS3sKod5EzXonDSyLr
    xZz1SmC0MDdAZPlDwg0mlaZMKz00DD3nB1XSRLdAaU0OsSI3Kyk0fPbjgDUl1+ed1cVkGz
    HAZ3tVWvIqJ1sECM8by58pBNHXQY8F8z0tFWRGshYzR0+86Y6cbRrk3rgCP4QL5nO1uO0o
    EkXRSi00vMG51ZfeQmjVTQjbRte0YXVaXD5kGuFXspTgEJ06RHJJlTF2Vi3bE6OPFsWzl6
    hjEw93+uGKKdCxGpDp4CZXkazXEZLLHffAK1uvVgqrv+Lwt3rBp4DLNEFdbA
X-ME-Proxy: <xmx:6bpHamcL5UwqJ3PC0FzLboXEiOdjMY4BWN1SdFxbMKSzfLwZKu4llg>
    <xmx:6bpHarp2AVos9szuQJ12JVJs5tszxOtWhoiq6o2MXftRliF-IP7bdA>
    <xmx:6bpHamPPs7Lu6cRnWZQ75yz6X3tbEkydRtA7qHqivaE_oj4ACDuDtQ>
    <xmx:6bpHahFuyAT13DSc7NTt0CCAUdyrUdt_89lH27LDm9g25C1Gk-5RFw>
    <xmx:6rpHahpc1KKIvu1_WRMVo1Hm3ak6PUEb4UH8OjNNTsXOFCYBzcS35ukY>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:41 -0400 (EDT)
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
Subject: [PATCH v8 10/15] mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP
Date: Fri,  3 Jul 2026 14:36:09 +0100
Message-ID: <20260703133615.1039465-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F956100005
X-Stat-Signature: oroszsh644gtqmkoxihx7fxs3qtuhh3x
X-Rspam-User: 
X-HE-Tag: 1783085803-666119
X-HE-Meta: U2FsdGVkX1+jVGMwHqHbSxeCEU77W0fpITJYeBvrafXYuMPAO4yypz1780jOo/rjehORAHtYT4Dn4MolgfV3x9s+MfOrru8AubtBEQ+booWV1jou+hQ/gDlXNHqYmv1qOjI3YYMdkWtqpX/U6A1okbarVpKG6mLwVi4hpEzmQgYxbxIOFXBza7uMx/Rxf59nCcyDUm9fFAFq+Zv6r+6V31WxF8Wz8XroWdn2GWDHk6x4J0grl34PY9RXFrRZBQtUrO4RQSabJOsPwGByeF2/MR6vJA3tzOjjvbcfjjgOUZG8XObHze7cWndxEfoOdjQZMJis24+2qAryPH+LPZimUyiHANIVQLgtAkfsSaK+29EkyYrf9VgTv40EMXUlzD6+XOlT5aXlxKxHRhuBgSIvVqobX4EFRWK6zkQvZH0QKSzwK+WPAmdXzPNMOXh1zYjbm0lJW3A7u5Nm4Ll68G4kdVMzQcvoTq0SWuCKz3B1/uz8bY0honCAvoL4i7Hn82DyeCgAXrsz1fMD/5L4Pc6uzqQWPeboemIhe8eN+G4TPe6HAhV/L6/58TKrOGSyqBSJxHerhYo4BJIVb3kcHVjPQNZTQV2iaWlpMRLtrlpqz4zOrTcnuLKEQL0qCuIUi6KS2B620vzshYjigB2ntf+euPJ7OAmu85dN0kbStzxBN3APupjU5fFtXH9y1r2vcShnyCNbCCLFRoqjQ7whUBgKScQ2mMoB0veiAr+10NDfGFOfzYWJ+c0nIRCAf4j2lpkwvdyr+bdf1N5G1UfJVw/LBM/PCyVjmU44IhReAtSmQS31P+FAAz6Viux4vbYXeZr9eFMZV+rRgr+T7wlJBCojA2z9mtfN0zpMZkMd8FiLn9s/4VE0+0mHyPIZCckCQ4/WjO3s7RZHC0vrZlh67qfSOYIJ/mMEw2FN985Z59KNzI6I5wUJr4V3cPGxN5AtcGSenbwWERSLqGvwRtjJQaq
 SV+UxtEr
 kjVHpRdaDuH7Hczr/tUTcUJYebPio+dWheqCjWUl1r84aytSXESr7bREOpXfOqHx7uZ+TMzK4+8T+RHcHwuZwjJ5gJ66ZJg4i5UimkIKcqzJhXmXWzIc1k2AtjdW16LFt8aD5ofeLBNQ1yf/yJQ5HTaWgXW7resVx6SJWfD4AOVBIzrcblLZgxQ8FoWqYpfRa/Ft4YQ/jRpzxVUA4t9z+SFC6g6DmxIPKCt3WOAKBqdecto91tYW2P5UEzuCy8oRQ8R0/7siYulam0og6r2gTYeFvsYWGgrYD+pGofvU40ry/IUhdlpZ8femKm8tkLQYG2r06BW44TFQTijgrTYqdAvondWZ6eZCAzGovKr3ZuC2iTMazi07yVVVDoprzt9wivxVoObzeujvx8UgfoXUCH/WjgZe/Fy3s6lfq3U4lbBuX/hawiFOSX4tc1BN7vgDttcDbI1IKfVaSi9LjzLHVcOxnd7AIk1nEHSNJoiE+KLh9ApYySLe82fvPjw==
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
index ddf8d2e49c12..8b8a5979ae12 100644
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
index 4d0b6d7d9842..f0ce2e9d4ba2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6063,6 +6063,17 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
index c1f79a3dfd6a..fe1d605a4d66 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6139,6 +6139,16 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
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
 
@@ -6154,6 +6164,12 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
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
@@ -6429,8 +6445,16 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -6544,8 +6568,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
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


