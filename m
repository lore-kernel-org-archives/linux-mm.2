Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55898C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01EBC6B00A4; Wed,  8 Jul 2026 07:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11B16B00A5; Wed,  8 Jul 2026 07:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01946B00A6; Wed,  8 Jul 2026 07:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB12C6B00A4
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D7AEC4219
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:48 +0000 (UTC)
X-FDA: 84965351856.22.67E4966
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40542C0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q 0pQJe+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=YhpQuhXw;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLdU2gqob5bwo+kOBqQrY/zB5cHUK2h0s++S9ZpZZrE=;
	b=25S665fr8YtE2ng7YVlfmN1fYwvkd8/i3h23cbJZ1PzAUsxw2JxPI4tQU+Bno+VzZUsY/a
	EY2wQudJkB80dh/VxvBOHYJ7sEk/yzNcIaUMmG4NJDdtSu5jrv5MbXnnntSjH8DFnsjzpi
	5ZXF1TXSYGgNelryow77YP+pLGtOZ5c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q 0pQJe+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=YhpQuhXw;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509286;
	b=J20xlfT90kQlIN9j8dfJY5UAgoR2X2+4CrOlNNkiQVqX5Dwxc010/9PhpiZ1Wt6VQ1CeSd
	tb7KOzbdAplPAkWxJj1xL4NAl6mMyhZcaH0Tvrw4uQMi9pI97QXiOS+kCOJLBNhbp+QyMA
	51W3LZwbRQv6NsgZSo9RqLq1PKV7Few=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 148DE1D00128;
	Wed,  8 Jul 2026 07:14:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 08 Jul 2026 07:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783509284; x=
	1783595684; bh=dLdU2gqob5bwo+kOBqQrY/zB5cHUK2h0s++S9ZpZZrE=; b=Q
	0pQJe+IPbmCkZBJnjci9dZTU4H3Qhd1at6U3bbx3JIUywV67MooBxmdv2do52gCp
	LK2xiFi1SHyPzIs0VvW1giiiwM7qlY5kXTYZpiPEY8GeGZ9SLtUzdIRHePTGy4Eg
	oGb6AP+Gk36IsVhR1aR0odI7aZ9HNKIL9r5SqvNeQyMdYx0GkRzrlD8uZYyqTQH+
	v3byfr/5FtjxXbsnnd807a2M7M/5vUhpBRPS32xAYnK8C/sh/lJa+4jMf2LbhUlv
	hzS39Joo5J+duQiAm3/br2iO2TLDMcCZN9mL/trpFLtGFMFrLNSCRvXgSDu4Y34u
	hvpZo/REq/bnMH0+0qcEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783509284; x=1783595684; bh=d
	LdU2gqob5bwo+kOBqQrY/zB5cHUK2h0s++S9ZpZZrE=; b=YhpQuhXw90I7KkjCx
	tITCZKapU2wGlETYzHzOGYMO6xSv6HmAdCqotIyBYqrt6xzYmHSW2QOHgkE2Vsk0
	r5GLZ1VZqb8zdh0m3zuJD7reos5MZGZ1oetz/P9JIfMlKuqUAOYT7bljLTjEeXn/
	RJ9FzA7c2h7PT7r8eV0roehj3ylwJK9MQi35NUYv0AQzOxSrpuJ+PFTrphfdL3EK
	yqGeblmDeN6haQfMUjPKnX8LVUDD1EIKA7CFijeO8TWS4UTU4GPWYCiSqofqgDuP
	fWFHuM73q4kldgcx02AVLgBNs/ogPUPL5IXpq8OaqOOVykOw1WA3P3MdgE3bVUxD
	VFDUA==
X-ME-Sender: <xms:JDFOagBrbIK5NAd6ovwtN6l-EBJ4ceVU7SDvOaFNVX77hCI5pnkWbA>
    <xme:JDFOaubOCN02IbdH0vFtHSOtoKOnrwMK1QTX22w2PgO9HUZ9ninQXKiLEjhoApg4X
    S9FS76SKVAi5I1ftUVAS0VkPQ_2PSqinTnF7MxM3h1f1J8WpZ17og>
X-ME-Received: <xmr:JDFOasbMhqiV9XxDX92bnxVbIxQ4avdmwbU87-q5Sg8EM3cfMC08C59XAe1G2w>
X-ME-Proxy-Cause: dmFkZTFrgK+JlrVaprEdMCCT9jL+WeqlR41PWLlswNzN7Q+R9eHi8slIfq82AsY5fCzbDR
    FF2c6/38vqfy5yn0mfN1Q1IuR0w/6jjhcBlbbYbwVeHRfHyttYIq8Oj6v9pP51nLVeKVF5
    08J2hQde+dVWeXYQH682oaYmn32K1d4rnz4RgIn1j8hjtXUL5IxvtXbrp9YKRUv370bN2m
    UN+Zd+JxmqGqLZtvxlNtOAXgPcUE/BQPZ7oqAykND9BbS/e5r3R+8nAwQL3YfeXzdQzT7u
    8EidJ7yOHxiJJbRHrAGeZIH1+iybwcJ1viiDHX7PYKqYv0VVB7VVolJezAJqTlXxgJaxao
    DyRFUO5fJ71MTvsMWl1xPdOtcqjNemnyR/k/9pvf6KfEoU/HqPvYrJe/xUFQynrWrj5jRt
    yIJACT+5w6120dsmRNR0TcomfSjOt0mK+N9OK0RIfILwq59y/WFkw3wgtgLAWqq+BHqw2R
    PIQ2P6iY7WU+fxywAT7SP9DnGo9yLHxagBPaJZIuqhE0PHYsj2WbYk8ZqZfJRVANRqO7ih
    TWOus3BByU/dbHKdqHe1tgM0git1R23oXSjugH2TfKTYkigYru0ObHevLptOZ87L1tBEpA
    kDratagrI/oMGRyubOsfuOx9hCKFMh6Yf0/W/5WVON0benwpEifDkCLfA/SA
X-ME-Proxy: <xmx:JDFOavlmryb_kZcWsImbJvf53eeJFcMuBSMD5epki_wK_3kRAvP5_Q>
    <xmx:JDFOauSfB-pmegXF38dE7WzNxNQeH_gohRzB7ykqmP0r5el40EVGpw>
    <xmx:JDFOakUSB-1PMkSZQenUshRWZBXQpa3dCzGXVD-wX3UoGyqVx9F5KA>
    <xmx:JDFOakv0qkwM9N5Wx8FDaMaFRjQaBOuQ4z2WX1ReXD2af1bPwBf1VA>
    <xmx:JDFOalRAEumihBMN60INyQN1GCPdms30Z7j1HDs4-7PEigbjME15k1yS>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:44 -0400 (EDT)
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
Subject: [PATCH v10 10/15] mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP
Date: Wed,  8 Jul 2026 12:14:11 +0100
Message-ID: <20260708111417.173443-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1cnojjat78q9m91cmnbhrt14x49f3q6t
X-Rspamd-Queue-Id: 40542C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783509286-218300
X-HE-Meta: U2FsdGVkX19QfXcKovGtgJjMZO4IFtHMwX+wGWibH/aNLgGTLWOIAr098e9KpcyNp3b7RBcASVUoDfaXwTkP/kPS7wK/bMIhPLDUDx4BqTOzu9osqSYlYZscYHNO0laDwdvUMD6XQcKofIE7D8rNTOkPs5RDQDwz4fkvM9IZ3WRrs+OX2kH5gJl4RKFUimnOBCWZne9GwOEQmJrRmEec5gEnORc5fXLJVHQY5ToggY5vILbOZAij0eBcpW5BguQHJ6zldvHRL/JL3pWxY6E0tjcokF+vBfREf14SDqoIU01oMhft8KOTUqs6T+beE3O3kVezvL5oVVcwdxuQUXEIPvOX/nhYPi1pVbUcn/XnLQT/l+E/s4qIXgXSNJUlrRfcbOTw9DCyANL7hUE0kgCmswUtBRDrtfiaYIt43RT+HbGmNXmvlig7BwVgil4PG2V2l0IrmBtkXwLNWpmt+rCcy0EeXSDwT+XriRUSwX9K8j9/1LjJ0krxoWFqgaypoLMUE2pnXyptkADxcxJRTEKwaYdzZMSr2QHaUOtxe5/+hXuBXrrZutyNqGgsnLxWsmDj0VIZAvrIbFba10n8uhxBK+IYjgz+3+mYaIC3iLKid9JDQzh7y8Z2F7RarXRAizL9h6TDxoDV5ep+7B1eFerGF5UsOrTEIiUd+avHCbU7QtRhHlYqlGkjTJQfdcuYr2q+8hMI7zzKKPH0SeCbelUl7G6i4YP8VFZ1Lq0nu6oGrFm/HPzKJogqWi8ELVdSASx6fee2o4Yn0TFCOqOmSgyjs3ZFmaTF3bCH4LI5z6Hm3yQfx/zsRuBUbOrXmTcnryT4qdiCIbNPR9OdyGg687GAEr0hYu9I21i7+qjbWYE4Ru8PmpmJwqGbTNZROO/3DSqingrxxRWDTVhYhPF5RKA/d6+2zK0GAlpJLpBIBurnHK9dFyJs27YPEEEGIGpozW/+FAfsAh8sKnHQ4DFrSqJ
 VsRdNOBL
 g2VXc+YjNNQMfumY7XsAm1Lcx0qp12l/mf9eTK5x6GQnqbFWPKBIeZv5yzKTbahJS5xe4DCLJP8eM9RyfXpX5IWedXu4xL2lZpupHOhUnwIoyJypnZ0kTy5YhgcvKBchdDMZ3T/dX1uu30BefZXXr9ejzTzuaqHJC2yNCUjafIn7fGpgQTZOO40Q0VnXWqx4RlAUmXx806JOkMJlG573OLNaNBCDiD9KoN3b8Fmuf8G7/Ez8FzDwkCnSQSy1nWOkFkAqZRqvsPy1PbJSwHbCv9Sp7a8v65UsWblc5ExaoA5k6UnyBJ1MRM1iVlx8MNwe/YWVHRdXPuZqx2z39MBEZZ/Wje5xpM1YsXhqieGkXgGCPfCO5hsHCXN+B7z2Bira09HEG+8uXkw3Yu2eYkmjQuJFEbCrTvR0MmguOUV0qup8l5aekQ/CiMuTWlrfvQqDIGjnZP8jIDWTbj+4Z4+67bO8fPPSFNgAjVoOCnZNrETy0vlIL7brtd1N1M5UKPu1wX7BryJLy6WTMToGChmsC8pjUJviWJ0/mIWhtGI7/xboYRoDWiXu3Sj7ImcwjEskThIeE
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
index b34e8e5e5f9a..19a7bfce279e 100644
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
index d31648ba898d..6f7245609bd4 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -241,6 +241,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
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
@@ -371,6 +383,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
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
index ce00ef882c26..5dc9654ed030 100644
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
index 6f753bad8e78..546e23d7a8af 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6105,6 +6105,17 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
index c18aa08c0630..f668e47f8575 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6119,6 +6119,16 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
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
 
@@ -6134,6 +6144,12 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
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
@@ -6409,8 +6425,16 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -6524,8 +6548,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
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
index 92174d65a73f..994de4c09d2b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2677,6 +2677,12 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -2737,8 +2743,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -2774,6 +2786,13 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
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
@@ -4526,6 +4545,15 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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


