Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9761CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496286B00CE; Fri,  3 Jul 2026 09:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421236B00D0; Fri,  3 Jul 2026 09:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299736B00D1; Fri,  3 Jul 2026 09:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E849A6B00CE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8041E1A011B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:35 +0000 (UTC)
X-FDA: 84947565150.07.21B4917
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8CEE1140007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="v Bx+sJT";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Vy0lv/XN";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085793;
	b=d1Baim3ZelUN8g1hova8zfW46oJjKCI25OOog5KpWv7JhUXkbCc8BZxQ18RqzXq/PryGgo
	PZ6yMv8bH4E4JuoRxPnw+PHqM6SgjD0mMmnYCEbMRbyiKDyFS+c2t8bXIUqO67bnBD+p31
	yKUh9aW8TI+CRkU0MnbX6mbFxDigYDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpysjLjnfl3D5VX3gnxELvpxI3a3Ll5kLhg4eR3DzNI=;
	b=eIhIZJv4AN5grcN/w3Nk2M8F08JfCFkcVl53zNBkvhvf+CSvC175QBlBgRe0WMWA1GZzoP
	CtwrB+YJiAu/UZTkuf4N98baPh+X1DiH+xEe2Ai3bCI+Y5v1tHAR6ElPFCWL9p0nts59GG
	mpUoPSaarpQfaDHtt33iNmupuOCaVgI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="v Bx+sJT";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Vy0lv/XN";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 5755B1D00075;
	Fri,  3 Jul 2026 09:36:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 03 Jul 2026 09:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783085792; x=
	1783172192; bh=MpysjLjnfl3D5VX3gnxELvpxI3a3Ll5kLhg4eR3DzNI=; b=v
	Bx+sJTWkde53W0cE9sbErTVZZEEKWEktWaKidnvqj/7HG2O9pLVGGQ3Vw/fcKZuU
	yktd202aUtTJA8/QpmhbZpq6q48XQVggGPkjnQsTo7rkn0cDUdN0p89Z0+A9UBJq
	lLjv2Q3Wkt8mLD3Sy+Ved/orhmbIrS8z5FTP/z+ksgzb4qe1eBtW0zwjBftjmKTd
	/W2bbawUGOATvIRq5q711CNZ54Nvy/IqGCIZDpjnCcmnK+3cU7fgyDAI6M9Rk0H5
	17CfpjbQt3/tjh9NIYNV7K9KpkfCnTlsjHc9ovd0yPBlDMst0Ld9uNNagmR772vq
	dAj/0s6LIAX5Wv82UEImA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783085792; x=1783172192; bh=M
	pysjLjnfl3D5VX3gnxELvpxI3a3Ll5kLhg4eR3DzNI=; b=Vy0lv/XNKik4TZm+5
	Rp6+62L4zP4C1BnICD/Uj4rXxvm+laUCpHxe8baZx8oXn9mJuRKV6eOZDMhvxW5T
	+a0ENW2FEoUnD6s6vKQdMNQcnEdqC8AOK8hRVGzLhz5YHiUOtziqDHbWmjlJkPiT
	LFVEazgYqLYxITtnX2C4HDu07a3t2vb6QKGIO7d7H7/2n1xab58XAg7rAfyRGsNk
	/x5EnPeVbPz/Np4fC/ni55M8acmfm6axnOoLMoH1902e3JsDeySpY5wwqZe++vf/
	VJRSYQZKR+6Wz7pKpxyhbMgLUhziCtJSTNyi5fwiiiKJgIt3VozPnet0iRnbXx9O
	phF6A==
X-ME-Sender: <xms:4LpHagUeXnCRDRLVC8jrEBYxujXj0U9XEtphaf5z8GceOwpMKn4F3w>
    <xme:4LpHaoiN0TfXf9ARSOq6E5ja4NrW84mdo8YZAolrJXnmkOl0_NInC4_ewwZ4WYfBY
    PoLBmA4ugsFYsLziUYbENvRWJ8sceIx3U8CyZm9MjW7tinVNUWA5A>
X-ME-Received: <xmr:4LpHas6yfrvm0xaHqFrIPQyYK05Q1lwSwC6nrQ0hU45uXcvDlod1501pkIdL3w>
X-ME-Proxy-Cause: dmFkZTFQDL0sPRW30T/r8/WmDkXdFgjoaIX9vLNwohRjptYUed9306bo5V6gIx9MoEqVUL
    DOWAtjg8MmvSrTWg8GgGs2eP/FFDGLHYqX57o290l8bdH3IY0k+xW1ZYR304ONNSUwYaQK
    Bo4+Emve+flZyIIVzN32HB6G/Lort/YA8L1H1gsxabb9oSnL9XvWud+W3vggQeX1PoJ/lr
    b3eqT2nN+Fc3cRZtM5ggLz7p6oZndcDaRsjYfSAitKmZJei9EqcM8LdM+VCLGFHLAlSKAA
    8tPrvpHjoO9CczAcEbCuu4vVAaqfuT+lM6L0awrERU/Twntj2KE6oGoO3CSAB1ADqLwyHI
    +c8J8fhjLpiy+NdOc/oIkOAcxZkc69bRexMeSS33am0iRwpMUJ60P/UAjvpBBWdKdBBJ+e
    p3v5gmvUXke3Z19Nyk3Mh+pBWboJ9/5bo9p+cLIPbWd8aUSRIacgEDTkjUa3m44NWuPVn9
    uOMqpKItXMizu2NN5eLofaDGaRX6HgSG8pvseuojOW3fLl/3VAYApgZTZdjLTqzNeStBIP
    Xmhzy84nme3wkX6fqEpxt86mIMAqu8FPsKRpGyL9Unxk6Y5C7FaEt9tpJyw6DoyHefRQo+
    bRg6GfxCd9v4uW559MEAjXPL/HXP6qxbGc7ZVkbpeEr8Q2zr0pZp0sI9xI3w
X-ME-Proxy: <xmx:4LpHao5GW5UP6mje1kBAUAf8JU4zB4y3dnnJIflRK5-PSO8OmL4c4g>
    <xmx:4LpHaiHx8JbKWcac7s5N6cAt7lyHuL2BBLyQNiE2VRtOTbjJwR0UrQ>
    <xmx:4LpHauxi76SEaD7O1-5N9VBudf6Bu02Cr8evLQiva3CFlCOSDVdBjw>
    <xmx:4LpHaq1MTnanHOhkV74dJicD7WTuWAOH2P1pAVaD3N65Krt0po5wLA>
    <xmx:4LpHav0uvntyxLUsIziNgyVQFTvG_IY-y7xJQEiN0r-bFW1YiwFJX17n>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:31 -0400 (EDT)
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
Subject: [PATCH v8 06/15] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Fri,  3 Jul 2026 14:36:05 +0100
Message-ID: <20260703133615.1039465-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6uced6umsf8y1x6engkxhc6ni8to3mk7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8CEE1140007
X-HE-Tag: 1783085793-465651
X-HE-Meta: U2FsdGVkX1/sXkFJMMeHyRLmBs7+8EfWfzuo4KLHjyct+GttJGmxVOGj+oENoDdwdcTWAwOcwCDcyRXHqDpbtAcV92En3dhDyGqdVwtuQ6mgcalKZkeLt0oc7IdnfPxPB1eroRC5hXdlSl4vPsBm3tzWquyu1CS3vTRc83Y59DCmnD+k+hIQTUetR3afrcIGhtd9t2uIWP52cnWAv48L3n+9WieXpejIXIyT9h3oE+Q+EDNkhUBDUNx5BEdsk2ufjoS+XZhAwTObVO52pee892xWhuWafcvJnBceL9NsvUNXKnalxsmqhg4tTeDkOVJyfPyI4uCW0NEcdljjnpMh9bOP3n0TFwTYJVRTCEraB9TSXyhR1b+apwjZtMB8rWlszbbOtCUaCoLhwpxhDEnLBf5alBY1Fo8yIXT9rz9iz2g0gKDnNx9AWAOawLbDAXF5zDe7XRgzjpgMVCjeU9IQWukpesknyOUPM0TpvJW6ZpL6DcqiDdox86nytoKYp+jenLiir1p67+F/B5qHOmpYZ1KaaId15ePnoQX5gumNPASMX6ztOEZJGv4a3XSY1rMT6Y5xo6hNAaFl81dC4BO6tj8IDCVUTPYpUdtTiXEjFijVokyzdvT6BRv4jzFENsIr5fq3gCmXsVSu1nrGQEBiZrjuwdGj+YkFlS5eB+v9p6oL0TKJxc4aF9Vk2QxqML9CmUSZyh6xF7+hGzV4Z/uUN9dwkUnHXrDBYm62+yIO9+qrXW89HstSEgrJuPuXXYwT/PHJr7dyhFOTadwt9AGBpaGkhj5hu36xh8ZchThg3qkWiv5ON3ieBVVHRLEyh9tTV1kj8n0axAUbxfPy7QJ5Dsth4c3wsjaNJuLa9Lr+H6vsAt/RXTNRj+qsjqXsn+MR7szDe7ErWavCymRbJy8ES9+XLV/7BlwBcU+RbY1XdLa7DUFzClkLHm4pp3Gwxc+3qbCgXuHjUu77deku9oz
 t8r7IAeV
 zLWwS31LNNQXVgdpdPEvkE/CaVnK91m6OSJP14sCWkocpzM9l6aJzL8L0TMIEE1+23NWJxiXh0ICI2dQKVDpI3VPldJwPwkgF1FtQXMpq+MZV0DCLfJ5ehHNIU7azQK0IZ2FsEZflwjKaEAlDIYmwT6NHOSm0NQWHQScuzNrGWG/+0cEdX7envJ1ipcgPotWZbsXbZtsEW+JW1Fp7S5olJLsU4UH0UbuFYS2OHw9vKUD2XWBAkT7KXBoVeN5qlOdN4nkg0wtU6Vpm2FyTWyp2sgIMiWuJ+hsjlDh/S3W7n00ytsidSNPgnQVw4Wtlt85BbF0mnov7VOruIAXfzKujLnddP8kzu1uX1tyTB2iPIbpagdl1IK8K6bfyFbeQPRqz4+UmFnjTs4chmOG7uduHMy8u467/tu5DQOXyDn0Pv1+2Erd458X9ytR9exarjvkmQ0eq1T+qCiej9rQ5WMUwN1geQV4BZNOvt3UoQEjV+M8AkGduU0DYrL0I2Q==
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
 mm/huge_memory.c              | 30 ++++++++++++----------
 mm/hugetlb.c                  | 25 +++++++++++++-----
 mm/mprotect.c                 | 48 +++++++++++++++++++++++++++--------
 5 files changed, 78 insertions(+), 31 deletions(-)

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
index 61ea83dbd026..92d27c54fe79 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -364,7 +364,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
-
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5b60862684aa..b352b0dfe1ba 100644
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


