Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C21CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB85A6B00CC; Tue, 26 May 2026 09:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B698C6B00CE; Tue, 26 May 2026 09:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31306B00CF; Tue, 26 May 2026 09:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF6C6B00CC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4ECF78E1B3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:45 +0000 (UTC)
X-FDA: 84809593050.27.6415D21
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5A0EE180011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="x At0vXY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=b7qQnzes;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJ/P23+WvEJc8tAMZssUSHiIG11m5YK7nNg0e5jqPMc=;
	b=UZfhXy5P21OA1OqFeO2Blkj04pWXLDyt+3GgpeeN+yCNDg2AzrkVSAHEdf6BztEQirxLiP
	eHzgh4ab1AfKa9mZZtfopMZ7Xe6/teiBcXn28UbPTvF+OK+fYZ8T2pMUGq4B4WOSQgO8kO
	0YljuOaxLgVbc712S9wEtlv/1ixcSAA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="x At0vXY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=b7qQnzes;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800743; a=rsa-sha256;
	cv=none;
	b=U5bq6vP/Sq05Am8PU9FUr+6pgdOOz/LzRSnQA/Wd9eYMv9wfNXgCrxnsWqcNo+Ibo/b/lr
	U75Fo3vWY8rJpXgPiWRTgC3C9fOWchVe6wVgXZXtw+znxMdPFVUGn1XTVdkL6Y74FeycKB
	cNnRUyeNsQ3pJ48/FqEBPe6A5yhwDxQ=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 2B4DC1D00108;
	Tue, 26 May 2026 09:05:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 26 May 2026 09:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800742; x=
	1779887142; bh=HJ/P23+WvEJc8tAMZssUSHiIG11m5YK7nNg0e5jqPMc=; b=x
	At0vXYTB8VbB4xHIpZMpOoa+SK1tQFdbDowNTveLlc6Ho8YcYddRn+Dsfc+DYDt+
	X41YhqniFoeUNYh6PEaIrzDwGgrdUesa0Kwhsnj1sOKJhwueQY3m0fJ7vV44YXC4
	5JSuSs9x31RkhqjBMZ1fHbo8PRzwrW4JlGG5ymmToKpBmnyJ9Msrg+1vGyJoVZ3I
	EFXFnJgwBUvd5etbqyTX26NGGhNHQ5S4L5asFSwz7OSNSeLs6iIXEPYoS3V0P/yM
	tILG6cPXSX/eUjG39NkI5dL4B2/ynI4G/wFWovIltnQratofGNgtT0KpMy1JeTww
	qrVTX+q2ObN2LACDG0Asg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800742; x=1779887142; bh=H
	J/P23+WvEJc8tAMZssUSHiIG11m5YK7nNg0e5jqPMc=; b=b7qQnzes6kcqdTECe
	iHUcSEBJKXRkGFcyjuQOvLrxxap0Ct5AAhiyXqurhQZnVQtHEdx1QTiSeOEAwkBY
	sSj7k29xMbnOVD6UZPNB4WzPRMJuS37xh+JXObiJr8MxeJWhJ43lradEky88Vqqb
	HI2bJnfaMtUTLeLqF/+jO6hKkT83cY+joMZOAgV6Al4S4HssNWHxT1kw1FA0VHi/
	lsWbuNBHq8ZGdygYeW2/uAl2ERZmIbGqoI+Trwrgtq4qK90IWIxGjMX91n8Izh2l
	FVDjPl4oM6VDJpQJQ91h/VocNi4Wx7zBw/zoyA25NMf6hHYrFLs3Sh/RUN9uahip
	kGZBA==
X-ME-Sender: <xms:pZoVakMmky1Jfbelt3kP-6Qb2MM82EcioFcBRRMWE1O290UfYOadgQ>
    <xme:pZoVau7D9clsrIHgBwhlTj-WGv_00pLWTlFr4CtLLF7mFA3nhDpjIMjKaOfMeW_d6
    zci1uzwxaNv1KHe2KzQJU_LgtqmfP8n2SAImGWV2xPb5mLVnMMh2F4>
X-ME-Received: <xmr:pZoVajyA0RdUOW7qAv2aoDzt-RaA5KgRnZYQIVvaxqRfVeZyMkPgK4QPvPq7dA>
X-ME-Proxy-Cause: dmFkZTFqbc6fXhopwy+hAOgtjHy4pTGuHjfXZXlZdTx/k4tQMvhyI2vZzCnM5UZQOJLsQ6
    MBNN4KMbmYZdvz5T8cIgQbo11hylcsT72WGhRELqB/NWcVS6dsw2DuAcdzpihvUx/kC7Rx
    TXAh0tKkGSNzPC9MzCVari3WizUMLAhLPeZR8i+UtrjD8sUs4gbS3nJjyE6j7x9rQvwYKa
    Vo1Cdu33hYc8iqP/ATtq14j2/nP5x/Vq5r72hY07O9WQkAcMkY7hJXfuznzppNnRfPI/E0
    vXoMBAS+e5kQ5+gg0Sxc802FUu+VDDuhW3vvNg1v2vn17b0MDhDS2LwVSA9QGKzjnWPAAt
    Kt/oqiMSLUwhAYjMvuUleXr5hhkZGcTKNFx9r2pVI4AMYV96PdweEcSAVtUG4fpY6gEZjs
    zf/DPrsSp2bPs4qJWW8vk2q54QDwAGzBOcHzKMwKjCKIrfkf3kJh0XrTie6n6Evwg/GULE
    CD+un1qH1uwlGwvrCM24Rb54P4mImv6KcgNo3iV33SVab8IHQwrOZOqcUrNdkU9nEGmxpC
    Kx8RZ3GrqrNUcUm8kRFEoXmCuFdKxxFGKJLgCKKNxshikWZf9j0X1vaaqOw65D+InmFNIj
    HJfgDWt931Uy0iyL8Ajjfp+h1S/6OQ6TnRXEM1KHxXrppVxuowSkwUQ6EWRQ
X-ME-Proxy: <xmx:pZoVamSSlQ6dyZyWn05HZZYmQLnYY6zLqUne59ubtuQKdfuCIinRKw>
    <xmx:pZoVaj9_LRKoNxt4JnWZGF92uMl-pyelqVLMbq5uyT41MoZrEv8Xug>
    <xmx:pZoVarLZDo3iBlWllOjur0-2jsGIFTbs2M807y3h_EuqfxBREuSy8A>
    <xmx:pZoVavvC8cK4yyJoEiCQB-K01nUaTuGtdBoqhiFFgw_DXdNDvZXsDg>
    <xmx:ppoVakufqWe9-HWLEFtzmx6SaPI5i8rGVNopxzddFlzD2Lkz0BXfDvwq>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:41 -0400 (EDT)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 09/18] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Tue, 26 May 2026 14:04:57 +0100
Message-ID: <20260526130509.2748441-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A0EE180011
X-Stat-Signature: sswxb5qiu4kd99zggcx4wwz3uz67mbmq
X-HE-Tag: 1779800743-439965
X-HE-Meta: U2FsdGVkX18Veq08R2qVt3wyfwfaOCbD9xDgURLb8tKR6T3rS2COqdbCe8ld4F8swQ4fu+QalXs3lNDijBYoDCrxj5YWW9Cypw9DAOk5xKlL3o6gV/Tshr5Sd0QW7h8V/+ZH5x59i03x1mtcTQ2uacYhac8W8XKmqTrSecp5Nu4VUBoHswxDyLFOnVXxakUcrx5GpCX2HF09KdXSoE/e9kUZD1GZXA9PHC/glFLxfN+sDfOy0iurRjMCnWO5xBMAhkkg3DFyIIRuDQtJa2NsnvKFaE3KDGgNW7ltuZDCdxai85Rh5q1VnhCryDbMldu0/qQqSWG9dDiFomKDmCXnK1p/KRuV6x6aRjJf8jPoclfG/s+K2Rh/U6nwP7tP05QNUESUi1NP5DQmnDrMl/niiqIUyMxLGj1rgXkLipTwknj7AkNHpHYEN6VofIhozrwF+tNvw0psEGAs8hpwndjviORWFz0miz8VgK7MZJlBTOHwTaqNp/yg5CmGqGo8sEIWaqO9VYx12lG83cRxkNW92VOREJao3J1I+Ub4evhH+TMEmXRcQtUbwKqYX1dgF6+Se0nTpg7iG0HkfG3AcVe8cah7DJw7uG26Yn1Vcna93TwCUxKRhCrLa/oL42msC6zkIopXlxv+jKo6s3TM5GVX3qOeIbdgwBTIcL8YYeK86fcbBVXrkR+96GvpDZxsqE2movG7OrlFXmHVITYZkx4MTPl8v7GCtxpKJTC5P8BZVI8HPY+gTae+dotgUhhJUdmEfpjWhIicCnkf6Pz9M8GKchdOV+qBXfz98Xceu+IlsKQ11mFKs+gh7HPq8F7yiwwdVhtmfGD0tFgzuU5W6jHcOgh4pcBy2MTfVdngMnJ6GIZQzPOaTFeIPEB8iUlVnN86wDg9sGHl2JoGSp+7OFLZEwW5iDAOHOfWfRnQHrtWZYJySnPKO6Wu7a3Thz0V7+H+XxGfyGxDHgyxKBNWD1g
 kI5nG7z2
 cVfifvfnQLTUANJNY/VGX8+ZA8liZ4vV+V1IpyXd3IZx/aIpd5s+CY+iFJG+XQaUBY3UUz91QU+bPK/F++wNBxhx+x8m1EkeljA0RQ//k4rbFxzAtvN2E/71hzDXqJpRcquVsm1TurYxEOoRFdRQiUV/AhTK/C3Sh6Os2lWXMcPI9rAsJcjI3MR7QptReDeNl0HMeQDxD8IZ8KWSE5nnvbyQnZr5gb7t/6h9YUG4KMNs93VeQinIZUAl+dWStUY1q/HRLS/f9ponyVNr7nuBiOslFCAnxB2+9yqRgNrpI8IXJh8KFmYztcdiDXTw0OokCGhP+yM6tI69nbMqpy4pb6h0UwVU1QDcVCtZE+rsPX4ra+aBxcj80wNFCxhdhKPGGSv3NcEqWMNItrExDjTkcf9XbkkpsRMFeRvu9EWXzQxq4ibMLro8Nxkm27nbqSPGxVgKPPyStDq4KSnAosl2Gt41oxWGUJlYgWvlHXLufmlEyX3xM86mmeEp7p5OMrvNMhnU5jc/LjQu7rqT1uFRncr+3gkeJniDbVcaP1dkHMgzY10eqO4pakzbxbspbQBqVll+DFQRDGLstKyOVJUt/gr7murj9T7smUgTguD6CwA5a1VFJnzWkGFj1zJIdCemDBtOeTHCC2Nwj8ae+uOMjP0QhJzpaiA9UQ8bNBwFbAoJiMJeaEFTagMMnH8ApPVlBWgsmnAbgq9EI7hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Preparatory patch. Add the change_protection() primitive that
userfaultfd RWP will use.

An RWP-protected PTE is PAGE_NONE with the uffd PTE bit set. The
PROT_NONE half makes the CPU fault on any access; the uffd bit
distinguishes an RWP fault from a plain mprotect(PROT_NONE) or NUMA
hinting fault. MM_CP_UFFD_WP and MM_CP_UFFD_RWP share the same PTE
bit, so the two cannot be used together on the same range.

Two new change_protection() flags:

  MM_CP_UFFD_RWP            install PAGE_NONE and set the uffd bit
  MM_CP_UFFD_RWP_RESOLVE    restore vma->vm_page_prot, clear the uffd bit

Both are wired through change_pte_range(), change_huge_pmd(), and
hugetlb_change_protection() so anon, shmem, THP, and hugetlb all
share the same semantics.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h            |  5 ++++
 include/linux/userfaultfd_k.h |  1 -
 mm/huge_memory.c              | 30 +++++++++++++----------
 mm/hugetlb.c                  | 25 ++++++++++++++-----
 mm/mprotect.c                 | 46 +++++++++++++++++++++++++++--------
 5 files changed, 77 insertions(+), 30 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6499cfb61dc4..f79801816f32 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3297,6 +3297,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
+/* Whether this change is for uffd RWP */
+#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
+#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
+#define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
+					    MM_CP_UFFD_RWP_RESOLVE)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 0aef628514df..564eb2aac321 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -361,7 +361,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
-
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d43c2255f47d..40c65bf2d6dc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2640,8 +2640,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 }
 
 static void change_non_present_huge_pmd(struct mm_struct *mm,
-		unsigned long addr, pmd_t *pmd, bool uffd_wp,
-		bool uffd_wp_resolve)
+		unsigned long addr, pmd_t *pmd, bool uffd_prot,
+		bool uffd_prot_resolve)
 {
 	softleaf_t entry = softleaf_from_pmd(*pmd);
 	const struct folio *folio = softleaf_to_folio(entry);
@@ -2669,9 +2669,9 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 		newpmd = *pmd;
 	}
 
-	if (uffd_wp)
+	if (uffd_prot)
 		newpmd = pmd_swp_mkuffd(newpmd);
-	else if (uffd_wp_resolve)
+	else if (uffd_prot_resolve)
 		newpmd = pmd_swp_clear_uffd(newpmd);
 	if (!pmd_same(*pmd, newpmd))
 		set_pmd_at(mm, addr, pmd, newpmd);
@@ -2692,8 +2692,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pmd_t oldpmd, entry;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
-	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
-	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	bool uffd_prot = cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP);
+	bool uffd_prot_resolve = cp_flags &
+		(MM_CP_UFFD_WP_RESOLVE | MM_CP_UFFD_RWP_RESOLVE);
 	int ret = 1;
 
 	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
@@ -2706,11 +2707,17 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		return 0;
 
 	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
-		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
-					    uffd_wp_resolve);
+		change_non_present_huge_pmd(mm, addr, pmd, uffd_prot,
+					    uffd_prot_resolve);
 		goto unlock;
 	}
 
+	/* Already in the desired state */
+	if (prot_numa && pmd_protnone(*pmd))
+		goto unlock;
+	if ((cp_flags & MM_CP_UFFD_RWP) && pmd_protnone(*pmd) && pmd_uffd(*pmd))
+		goto unlock;
+
 	if (prot_numa) {
 
 		/*
@@ -2721,9 +2728,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (pmd_protnone(*pmd))
-			goto unlock;
-
 		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
 					     vma_is_single_threaded_private(vma)))
 			goto unlock;
@@ -2752,9 +2756,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	oldpmd = pmdp_invalidate_ad(vma, addr, pmd);
 
 	entry = pmd_modify(oldpmd, newprot);
-	if (uffd_wp)
+	if (uffd_prot)
 		entry = pmd_mkuffd(entry);
-	else if (uffd_wp_resolve)
+	else if (uffd_prot_resolve)
 		/*
 		 * Leave the write bit to be handled by PF interrupt
 		 * handler, then things like COW could be properly
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d0c81a056ae2..4d75b69d4272 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6395,6 +6395,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	unsigned long last_addr_mask;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	struct mmu_gather tlb;
 
 	/*
@@ -6420,6 +6422,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 
 		ptep = hugetlb_walk(vma, address, psize);
 		if (!ptep) {
+			/*
+			 * uffd_wp installs a pte marker on the unpopulated
+			 * entry; uffd_rwp does not install markers so the
+			 * allocation is unnecessary for it.
+			 */
 			if (!uffd_wp) {
 				address |= last_addr_mask;
 				continue;
@@ -6441,7 +6448,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			 * shouldn't happen at all.  Warn about it if it
 			 * happened due to some reason.
 			 */
-			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve);
+			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve ||
+				     uffd_rwp || uffd_rwp_resolve);
 			pages++;
 			spin_unlock(ptl);
 			address |= last_addr_mask;
@@ -6475,9 +6483,9 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 				pages++;
 			}
 
-			if (uffd_wp)
+			if (uffd_wp || uffd_rwp)
 				newpte = pte_swp_mkuffd(newpte);
-			else if (uffd_wp_resolve)
+			else if (uffd_wp_resolve || uffd_rwp_resolve)
 				newpte = pte_swp_clear_uffd(newpte);
 			if (!pte_same(pte, newpte))
 				set_huge_pte_at(mm, address, ptep, newpte, psize);
@@ -6488,19 +6496,24 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			 * pte_marker_uffd_wp()==true implies !poison
 			 * because they're mutual exclusive.
 			 */
-			if (pte_is_uffd_wp_marker(pte) && uffd_wp_resolve)
+			if (pte_is_uffd_wp_marker(pte) &&
+			    (uffd_wp_resolve || uffd_rwp_resolve))
 				/* Safe to modify directly (non-present->none). */
 				huge_pte_clear(mm, address, ptep, psize);
 		} else {
 			pte_t old_pte;
 			unsigned int shift = huge_page_shift(hstate_vma(vma));
 
+			/* Already protnone with uffd bit set? Nothing to do. */
+			if (uffd_rwp && pte_protnone(pte) && huge_pte_uffd(pte))
+				goto next;
+
 			old_pte = huge_ptep_modify_prot_start(vma, address, ptep);
 			pte = huge_pte_modify(old_pte, newprot);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
-			if (uffd_wp)
+			if (uffd_wp || uffd_rwp)
 				pte = huge_pte_mkuffd(pte);
-			else if (uffd_wp_resolve)
+			else if (uffd_wp_resolve || uffd_rwp_resolve)
 				pte = huge_pte_clear_uffd(pte);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 8340c8b228c6..4a6b35482aee 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -214,8 +214,9 @@ static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_stru
 static long change_softleaf_pte(struct vm_area_struct *vma,
 	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)
 {
-	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
-	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	const bool uffd_prot = cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP);
+	const bool uffd_prot_resolve = cp_flags &
+		(MM_CP_UFFD_WP_RESOLVE | MM_CP_UFFD_RWP_RESOLVE);
 	softleaf_t entry = softleaf_from_pte(oldpte);
 	pte_t newpte;
 
@@ -256,7 +257,7 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		 * to unprotect it, drop it; the next page
 		 * fault will trigger without uffd trapping.
 		 */
-		if (uffd_wp_resolve) {
+		if (uffd_prot_resolve) {
 			pte_clear(vma->vm_mm, addr, pte);
 			return 1;
 		}
@@ -265,9 +266,9 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		newpte = oldpte;
 	}
 
-	if (uffd_wp)
+	if (uffd_prot)
 		newpte = pte_swp_mkuffd(newpte);
-	else if (uffd_wp_resolve)
+	else if (uffd_prot_resolve)
 		newpte = pte_swp_clear_uffd(newpte);
 
 	if (!pte_same(oldpte, newpte)) {
@@ -282,16 +283,17 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 		int nr_ptes, unsigned long end, pgprot_t newprot,
 		struct folio *folio, struct page *page, unsigned long cp_flags)
 {
-	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
-	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	const bool uffd_prot = cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP);
+	const bool uffd_prot_resolve = cp_flags &
+		(MM_CP_UFFD_WP_RESOLVE | MM_CP_UFFD_RWP_RESOLVE);
 	pte_t ptent, oldpte;
 
 	oldpte = modify_prot_start_ptes(vma, addr, ptep, nr_ptes);
 	ptent = pte_modify(oldpte, newprot);
 
-	if (uffd_wp)
+	if (uffd_prot)
 		ptent = pte_mkuffd(ptent);
-	else if (uffd_wp_resolve)
+	else if (uffd_prot_resolve)
 		ptent = pte_clear_uffd(ptent);
 
 	/*
@@ -325,6 +327,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 	long pages = 0;
 	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	int nr_ptes;
 
@@ -350,6 +353,14 @@ static long change_pte_range(struct mmu_gather *tlb,
 			/* Already in the desired state. */
 			if (prot_numa && pte_protnone(oldpte))
 				continue;
+			/*
+			 * RWP-protected PTEs carry _PAGE_UFFD as a marker on
+			 * top of PROT_NONE. Skip only entries already in that
+			 * exact state; plain PROT_NONE from mprotect() still needs
+			 * to be promoted so future faults can be distinguished.
+			 */
+			if (uffd_rwp && pte_protnone(oldpte) && pte_uffd(oldpte))
+				continue;
 
 			page = vm_normal_page(vma, addr, oldpte);
 			if (page)
@@ -358,6 +369,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 			/*
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
+			 * Skip this filter for uffd RWP which
+			 * must set protnone regardless of NUMA placement.
 			 */
 			if (prot_numa &&
 			    !folio_can_map_prot_numa(folio, vma,
@@ -667,7 +680,16 @@ long change_protection(struct mmu_gather *tlb,
 	pgprot_t newprot = vma->vm_page_prot;
 	long pages;
 
-	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
+	/*
+	 * MM_CP_UFFD_{WP,RWP} and _RESOLVE are mutually exclusive within one
+	 * change, and WP and RWP cannot mix. Miswired callers get a warn and
+	 * a no-op; userspace cannot reach this state.
+	 */
+	if (WARN_ON_ONCE((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL ||
+			 (cp_flags & MM_CP_UFFD_RWP_ALL) == MM_CP_UFFD_RWP_ALL ||
+			 ((cp_flags & MM_CP_UFFD_WP_ALL) &&
+			  (cp_flags & MM_CP_UFFD_RWP_ALL))))
+		return 0;
 
 #ifdef CONFIG_NUMA_BALANCING
 	/*
@@ -681,6 +703,10 @@ long change_protection(struct mmu_gather *tlb,
 	WARN_ON_ONCE(cp_flags & MM_CP_PROT_NUMA);
 #endif
 
+	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE) &&
+	    (cp_flags & MM_CP_UFFD_RWP))
+		newprot = PAGE_NONE;
+
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot,
 						  cp_flags);
-- 
2.54.0


