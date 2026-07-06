Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B19C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510EE6B0108; Mon,  6 Jul 2026 04:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9C26B010B; Mon,  6 Jul 2026 04:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D54B6B0108; Mon,  6 Jul 2026 04:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00F7B6B0108
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5287D40176
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:25 +0000 (UTC)
X-FDA: 84957725370.17.D0C8266
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6FAFB20003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g MDVFP4";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=dsEDKwOt;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327703;
	b=30wQRK9OqBH5U0jifb9N2z3gosZXbCx9y1tkatjC3XuyijwYlhLoqIvVPGdB8/2+5Fc34B
	3f0F+zGci5U/qJIqqpuOx8xoKU95Q+bDF/H3iuoxjbPtuno4CcBx4axS4eDlwwjBthfmIm
	bAnfCw15fQjbfsvd/ZAeR8ax9/dKu0k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g MDVFP4";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=dsEDKwOt;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIGGseHJhXFtBRSP7SmdRAt9uVdtYiu5/BEQ1j7OuI4=;
	b=ZArZnZJZHF9vdFQJYZ4ofPczmX46h7XmOp5vABJrWvVR5mQTr5+eIDjG4zxesIG3ZIambU
	/xy7ZRvFK3HarJ3yy0w0HyNCHXQ3rSjBaCLObrL6k03Yk9IyLPM06rtpZfKu0qbZXSXh1R
	bs9kd5hnf5WtstBuuCLPfU6bN6LReFU=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4ABCB7A00BA;
	Mon,  6 Jul 2026 04:48:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 06 Jul 2026 04:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783327702; x=
	1783414102; bh=pIGGseHJhXFtBRSP7SmdRAt9uVdtYiu5/BEQ1j7OuI4=; b=g
	MDVFP4ahXttEHNWfRtSlYH+A5aVUn9C8AYg7aXVrdbBqWPoLwIiah9YvTswZoqj3
	i/PRfHPrYE0NOkgorJwFhIhpaSi3BGDfG5MvIf7TjwEIQglu4wP5fjjxXWV0fl7L
	92BwgDdgmIeKNPoNzJleBvOp8HUhmdrl9TMMbIgrggEInpiTRzkCsNp/nAF5DecS
	mPJXrvgPXr16kVZY9wcUbVeOHLY0fOHnhxO1xm8jLNy7V/1tqlAUu7VltQVn2bPG
	58ih1LBzqPJbC/b3pA+yofM66ZZc89cHJkSC2OKGb86vYpR4HBPByhNE46HtV6vY
	k4In1G6+yXG0kC7v2rF8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783327702; x=1783414102; bh=p
	IGGseHJhXFtBRSP7SmdRAt9uVdtYiu5/BEQ1j7OuI4=; b=dsEDKwOt8vBeOlz18
	Rbyx04dcBuH0ThvUGX9Sal135KPWd0R9HPzzncgTKetpNvjh/2i3fwRKrYsRDPdN
	KiUBM427gzUcNmM9CR9nIbQ9DgTvfW2RrMjNg16aUhU1Gv+NqxFBUFyXtHIe28fr
	CyCQO5MASWYgB9Bq/Mn44IXLP3Jo+NCZQzqkQT7XJ/oBO7oTtXvsoiL10X7h8Csg
	Nq/Mn2oomXwg1wXTaB4BVjWdse0NC4n22JaelIgkYqbXAVq6AK22tvvi5zi6l10u
	bgFtQ/gCypYiq5D5bN/6H6P00yVs3SJ+i6L137AET2vePbd+98jxCSmz/Ruq/He0
	VQwPg==
X-ME-Sender: <xms:1mtLao8nI5NDz0YpVZw_EudMMkqWKKtfQdC1DEAuBvh23LvDq0JMCg>
    <xme:1mtLakqZgINCXNr65BbhhZrTggoEu6lafloMKqR8qCjDa2y-u0eBux5X284GPnCy0
    8Om3FBt-B6tqQMb0z7V4Pjw6IvlIGfIPAN3_FANuYTtakQKmmf6oU8>
X-ME-Received: <xmr:1mtLamgAb0ws00OdwyQ-0z5kttYBI6e79WM3cwAmQW8mwn27aVWgma0SGkpT0A>
X-ME-Proxy-Cause: dmFkZTEaPZdviD2XbalDAKS8tszO4Hte+xIg0jgPrUan8C55y4EV/KJ/Eom7XifH61NPsj
    FpHJNCv922yiJ1/uYMxxnyO7ohj4FdG9jlt3xAQ9ulNn8sNn16Di9FfOZz57KTymaDzX0X
    Oa0xwtmkNizaUUH2ahz49zlPrt4p4TivjhaMFb9MByS5fcrdsopAtNxM42z/KLfZEzontY
    dL7oYKud5vnDF47FBpMkQLkbBVAcKZwKKE3gao9aGmCcABxV7K5XPoDt0NUeM7mdB6UBaE
    xlUOaRlAzH3c/cAXi9JZvKpCWHAqobGBBf/9tSV3q5HJYXgQVn2KMNtd8oDpj8yLDeA9cw
    EiP+W3gbDTMAji58CDcSjQj8hrGHjvPfFDIfswkW2Zd0nzLMIqPoHSdnS526nq+y6Fdzwx
    iCAAplLEFCa7gx4a6zlhXAKI7Tnk5a4fGRqD/Db8iP163X0RV+bShQ0dei0xhIiHurzjZi
    TuMozwsGY/uD7wvjbKxD2bcab/pMq3T8lg8tHrIToYnDDtsKbiiUDQQTh2GRO7W91bfeu5
    0pB/icLMJP5V/BCL6aBfgO63muhrIEG5ilkKqzDFASz/MpUGJTv+W4iKlYtEhxEDKbnbVh
    4/yJkbZBm/NklkmCpFITr5xYPpoxi/9yi0zlKg/LJvDdLnxadQtwcjVkUyaw
X-ME-Proxy: <xmx:1mtLaiCtXEfx_DjTgPY_ph6Yfq0opb0iQS6Hn-zEyJVGIE9aITrm6Q>
    <xmx:1mtLakvJSM5WjPGUkxcgzhnP6Alf_-G1Yo-why6gyaE7Y0SDvteVHA>
    <xmx:1mtLas4oRNRK95AJ5CVSS7GR8f1JKFhZ6fV9C1e7dkxeWnWd1_9OFg>
    <xmx:1mtLaueZhy-wzL-PU1KKqpM_rbnbHVoYARnmESGV68mkIHzIFTgKvQ>
    <xmx:1mtLajfaL3XtANBm49J29XLq-n6i8gtMAfIPY-L9PAgO8WVBFkMPdcOQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:21 -0400 (EDT)
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
Subject: [PATCH v9 06/15] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Mon,  6 Jul 2026 09:47:55 +0100
Message-ID: <20260706084805.8400-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6FAFB20003
X-Stat-Signature: iogwqumswgi457jni4mf9b9znqon1gyp
X-HE-Tag: 1783327703-910203
X-HE-Meta: U2FsdGVkX1+4YHtraq7QfxJzHqvnvX41tgAegC+1Px2JrM5rp1Cd6u9eKt9QF9pAPD2+/b7z5keqnThGzUg4oYLdBGlDJpQrAo3dKd1xslvQFyCfsSuKdrwBM4V2kv0QMT64pkT7nQwkCnDCKR09HqMHt2ZFHYUz3B94b1RysyL5c4KNKJ9vDJIgUwS1dYPRYmCZcaqwnwJJU/gW7yDWge7O+PfrIjsCEdmyfI6R83JvsBU/t75dpbvOlSuo1EJX4aBd8JN9dSY5Y2G7u5ShdPfiiiHULmItU9yz1mAigkBzVAVVoc7OUamzpNX21EWPoWP+hN8gN90dbnF0vWoEYhm5mugoCYzOoSRMCX2oWsew4OA98KvqBDjOllyBEahdCrqZwzj2NBIBB3oTcH5O7VY/gf+SytzvEN3rLvHT+ljvnN98t36vtygGJ51+2pLUhYkY5JdLq6HpETLP9xpkeHXo+naFE4oP2t7tfm5gEWU8uuAq/sOFbADsyaovDIqIUpbpqqlumgxSeTbZRykWRXjbf7MkYcOxzN2IJDq2vgOfHeiIH7enf0vzNlc+Xo0/UeCLzNy9bxuHlwhnXOAcnoJ5BfEhdIclmxuh2whZ2gRliMY71tADaoqXIJ+JozdjUf6wL5pFr1h2FfWf+87XUVWCviQGT+4SgjrAZMpWxulb8/VtiEjpfgnYeEVFJdFGqlbyRpwRljPA3DLodSYOQzUtCo/j2KoB0QDTugj3DcNylANjJxkc9Me4rB3UqpVt+SsDOq14yF/N0SA9ZQSbxccgJWzHRtbVC+9YAGDPW8oqAwsGY1SmT4mV509BuBXnOSgcqFC1gRMJ1sJhTnpi6SjkJ+xdjBpc1PNlnDfGZ+ylKB99sCqd+/UG4FShpuO0JsboNZBDTqzPskdcu0yvqw50kUAmPDRqg5pFft9CTwbG+1XxDyIP26d8IARMAd/ftkXyX0TDqWTjaLb+UhB
 2plaFQjQ
 5hgj2f3iTL5QsCpBjbnLh7ljJWHifRUlSs0OWmasUPNs7UtDxEeDVn2NNtJVbb5VRT4gnVuDzj64cN+7aFuc6VCm3LPtSerYg+/QH/mAnPalVNPukoIiA6EYDkwqkgUuOgXNFM5WNCAXgZ1+cXtQ3UOgAoD1ulNwPn2yGrD8VYqH5aZztx1w1BNxhtjE4AT5eNTZilNknur7ZJQHbCe3wsqzcTCWruz+s25+0CiKnYDg8w15H16XcLx0IZnZfuMuux7UtRH6aZLVyP7VZtcWjUTsAzrcTJlB25CvOU3hqVBGRwpbb0saP3wZsGSmuhHgMpHNTvgL0zyLA1EjCqNa/5BvJi+jH2OonoOwsBhOM9WMGkTclprd6RM8fE32pDEgU+nwG8zAXGQfEwWtvwwLDVRINf5KqWCn9Xs4x7sWFXenvnqvkgefTUGI3MRXtJ7WhoaYRYaEBYdT17pFrO4MSLlssqGlT4RwOlgAjH7D5dPopm1+hInggDOKV0H5VFVZslQBR+6qYouZs1xb+k1JeDqexMP75rJ4fyRyFHAbFZLBXzfxH6FmVnF6wHX3MKPwC+7aF
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

Reviewed-by: SeongJae Park <sj@kernel.org>
---
 include/linux/mm.h            |  5 ++++
 include/linux/userfaultfd_k.h |  1 -
 mm/huge_memory.c              | 36 ++++++++++++++------------
 mm/hugetlb.c                  | 25 +++++++++++++-----
 mm/mprotect.c                 | 48 +++++++++++++++++++++++++++--------
 5 files changed, 81 insertions(+), 34 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5ac31fbadeef..87b2fb1e3f23 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3330,6 +3330,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
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
index 6dad14b9abb9..0a0763c6e9f4 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -369,7 +369,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
-
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5b60862684aa..aca2f10fc1f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2553,8 +2553,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 }
 
 static void change_non_present_huge_pmd(struct mm_struct *mm,
-		unsigned long addr, pmd_t *pmd, bool uffd_wp,
-		bool uffd_wp_resolve)
+		unsigned long addr, pmd_t *pmd, bool uffd_prot,
+		bool uffd_prot_resolve)
 {
 	softleaf_t entry = softleaf_from_pmd(*pmd);
 	const struct folio *folio = softleaf_to_folio(entry);
@@ -2582,9 +2582,9 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
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
@@ -2605,8 +2605,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2619,11 +2620,17 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2634,9 +2641,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (pmd_protnone(*pmd))
-			goto unlock;
-
 		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
 					     vma_is_single_threaded_private(vma)))
 			goto unlock;
@@ -2665,9 +2669,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2713,10 +2717,10 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		return 1;
 
 	/*
-	 * Huge entries on userfault-wp only works with anonymous, while we
-	 * don't have anonymous PUDs yet.
+	 * Huge entries on userfault-wp or userfault-rwp only work with
+	 * anonymous, while we don't have anonymous PUDs yet.
 	 */
-	if (WARN_ON_ONCE(cp_flags & MM_CP_UFFD_WP_ALL))
+	if (WARN_ON_ONCE(cp_flags & (MM_CP_UFFD_WP_ALL | MM_CP_UFFD_RWP_ALL)))
 		return 1;
 
 	ptl = __pud_trans_huge_lock(pudp, vma);
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
index 8340c8b228c6..7dcc94e7bfd6 100644
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
@@ -428,7 +441,7 @@ pgtable_split_needed(struct vm_area_struct *vma, unsigned long cp_flags)
 	 * (e.g. 2M shmem) because file thp is handled differently when
 	 * split by erasing the pmd so far.
 	 */
-	return (cp_flags & MM_CP_UFFD_WP) && !vma_is_anonymous(vma);
+	return (cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP)) && !vma_is_anonymous(vma);
 }
 
 /*
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


