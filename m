Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C978FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D44A6B0098; Mon, 29 Jun 2026 08:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685E06B0099; Mon, 29 Jun 2026 08:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574BE6B009B; Mon, 29 Jun 2026 08:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1ADB06B0098
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A6199028F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:06 +0000 (UTC)
X-FDA: 84932826972.16.54DA65F
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6024340013
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="P 9mxKrR";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=GEhhmDJy;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734884;
	b=A0mL6nl/VpS+NW7ZYCO0eq1rSfNxZrDheNPhBfl60Pxv2M243kevSjI+mDKUVK1aovLc39
	YXRU1Ko/buDF7Pq1m+lL9YriIdX/41MWHTZYxUp/Ci6ZE3BTuNSrNV1lhntmzRRpl+y7H6
	q6W6aNwqS+wz03Vy9xslSUG3+0IBD/U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpysjLjnfl3D5VX3gnxELvpxI3a3Ll5kLhg4eR3DzNI=;
	b=nC3u7WPqR7m78blKNhtnf/iAoONddUnKzTPGTOtFPQUAfN3sc7xYFaaMRrDF6gB+wqI03h
	qO49ItsNGIrnluuwktJ2z2lOsfwmOpTDUmn+qmG/3H3n/84Hb2sOGfkhAMW5pnlw66tLGB
	B5AT1xUQSPTUj0XMomRaFtz0u0KAJzU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="P 9mxKrR";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=GEhhmDJy;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id D8482EC013B;
	Mon, 29 Jun 2026 08:08:03 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 29 Jun 2026 08:08:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1782734883; x=
	1782821283; bh=MpysjLjnfl3D5VX3gnxELvpxI3a3Ll5kLhg4eR3DzNI=; b=P
	9mxKrRgU1HqWipD2c4b1CIog64odQYvsjwdeEs9BIsLxnnRhT76sg8v7F2W7t3Ck
	DzKFHunufXYY2rmQNh6cEDhgV1dNHiXAcKTWSYj386ICj5MwPYr83EziisfawVa1
	iNJGx5l7PSOPrR6gP5vw1KBzFIjsQ8HHaLc2CgZ+RKNWSoAz5U5d8nYxQFG23hOg
	1Qa0n6CyZCEQeJe+GsPvHiB4+n4FKQvpxdxBkr//71N9Cag3JQmiix0hiyzENgbq
	BvKaqC3F+VZYFjKy+1v3hGls62rSBzdVZcfmELRsgl/6sShhglU78NVKeBih1NWU
	r6Apj2jbkU8FdI+Nqk3tg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782734883; x=1782821283; bh=M
	pysjLjnfl3D5VX3gnxELvpxI3a3Ll5kLhg4eR3DzNI=; b=GEhhmDJye0F28HXIA
	FiR6SNPKbU5mexEkfBoEYCcYzPPgOmUiGe0DrwhogjmV/86EMQI341BE4uNATRcw
	GVEnwtfc7krpsy77nqL7DbsKvyndV+yazev2MF+o34mPIn25UIhFSZDMgPa97Tdh
	V7f7/sDRl5fpTLwb60qbVXzSD6b18anmFQ8d+fpCL/dMgfHSpMUBb/ufSg/dZ7Gj
	DUR3FpLAEOfVhD81d2SSvqE3qRmJnufUPnzjfTN4thw6CbNU7OjYOcKPDjRQ7IYa
	OCNNyKwQDkRrtD8LR1r7m3DZ8lCfz2j0FnrFAAJtZNsdZi/RnZ6kLKL2J3l/738X
	8vmoQ==
X-ME-Sender: <xms:I2BCapSHuXvfTtTlrlHNRHJlm-8ObO-Ht7oErBjiNvwR1Db9_ZJ1Xw>
    <xme:I2BCamv5Z4CZdfKmrvyiI-jUx8vcE27JzWpmgD2y3l8gJyqW-zZQOtWIS5vJqPVMs
    MtSIcxsEDbhLHm8be_9HW49p012O68zK6AzC3YZF8MEBE9zzk0HscE>
X-ME-Received: <xmr:I2BCanWUvBe4WjpedFHEQohUI8WPyMNOBt6k7ylpSshpXKPlI3GCUf5EfkimlQ>
X-ME-Proxy-Cause: dmFkZTE03hnIKuO1K3iT0B6SdPEorAHwRyVyrYJgNBnFLayITdp1OwideeCNALTrAxKDHW
    lrHeDCNBinndRjjCEoSHsHBRxcSTgJvXZ2u4BFWm5JlNswQVNTXy6KR1//l81guE5vc+x7
    rxhjsVK4UNZpdhcp+8xYc7rdajKXoryMuVW3VgXd7l0WwK1A9ecgDjmZcxmKdIfUSwNbBT
    w9Flw0Xn0LQ0Zpo+xOXKNmcLUjFquLUanSQSZS6mLAYkR7seLokCcHJgPhgn8KFvx/reXu
    qVyoKkBhF1UpFGOYPRgI54Wjqf+VsAL2kA+YdAd7IgaMd6cfk6+CEx7lGegqaSfW/6E/qc
    aprTeh7/C6rXoV7OW8qmt4wqhLjaZski6IjYg36T+tPZNrBKmkqfN96HBT3rPOEsVU+0vx
    XYudXrgiWtJuFt6G8/diQUH+Xop0LyUDgV5dIgs2FNPLAnOnzdlKrX8b5fKG6uLu9Hp2pY
    y19FmjQsl5LeWLMmuRrAkz8r8gY2C/vBT2Ckw7ZFzzckKPL6i3fv1udCFagrgq1S8AT9/1
    SiWEbQGmQ6DrCLL9HzqGuDQBjR6UOsUfP7u+//ebviiMhSffOGJ87qfcazwLQN5HsnrUDM
    mVDZzXlGQ7dty2MAFfAyva9q+J8Q0yRfYk9KlSdWYkfZNkv/GVvPi50bsJJw
X-ME-Proxy: <xmx:I2BCaqlkZExk6nPY1lm06HCaxrP0z9LBnUxraE5-pHYrzLKuNx75Cg>
    <xmx:I2BCaqAEw-EXz56l_wFU5gJAWXcBuB47EZXAXWzrOzDglQZ5p2lFkg>
    <xmx:I2BCav_J-VhIwi8lILSot32z-BGZHBcWTP7FYbblZtHuHGlxfLjVDw>
    <xmx:I2BCasRB2_Zup1JcXM-zyC5bzn7RhfMjsGzLkJ7VnJt1lOwP3rp51g>
    <xmx:I2BCahRxaaNbPuyCkl5AMbNxCdz6Ptb2jWbE-CfMIXck7KcDHRwG7O42>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:08:02 -0400 (EDT)
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
Subject: [PATCH v7 06/15] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Mon, 29 Jun 2026 13:07:37 +0100
Message-ID: <20260629120749.566063-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6024340013
X-Stat-Signature: f9e834soiz9w6oqztr4nwmwghubyqimd
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782734884-455516
X-HE-Meta: U2FsdGVkX1+8C7m1Ruo1/9Dgomyvap5Bs17cOpDFHgETsHR/NB4+DlbOoNv1UUaW3+PN4KiNf6WAXOP2PifWSEZcolOMgktEi4hZlPTcLPllV6zgpr66q6X5ftCgF7CJuHgGWE91AkOqOsT3qBAuy1pey3HsIFWaFEIytCqXvRAoRP5iFMfX1tXsvq7IjvanwMZO59QIKt07Q9nVDBgj87ENs17nsIyT2M669MgTbYuuU+k+o+qzS+kDtD3l1srfs6BJU5VOMVHDAVzXYOAtBZe5AzenB8yRQvf/CUw2IooKRpZ3CcEF0jQJNlhkFeNZyVwocvphjsAnS/+dMNCBhPjQ0CQmc1eNc0WhgJZYpf4W4k9b1+fZSbT34U4MrvHt098KWAUyirrN8f24EdYrH0K5WGJMpwmWArKfuiCSy5pgr1kfuCbLJ8kfTg8FbJG6L/IkEYI43O4+tvvmqEtNN+SQSgW7oGjpRH13yLE2qVwz9rnvo1xeS2aH83n8kv3Cs7l84LhW4IemfNgBcrltluNU2zhlSO/pFy10mTJXK7rvrLbArrENrLhhQssAC4FyZF9fddE61K6vdQcrycTZ0iHXxqx3oPzwaFA3QaXsfyEqOdfTJs0INVr0SuxRTh8ZL2fR/PbJA/KZKcOrwl9lp38MOuGLE8OayOC0qObcil+0LsMw5DsgnNGg4yuM4C7o99SO2Du8RS9FnzUGv65M1lwkFoLiYkmiw3eVzClL2H3MDZKYXpQZ7jX1XRNcQ5dKN4hkT3mcpcmEguhfOAnWNCNRNaoXsnzPF4eoaQIPv8TjRPSp6OtsctLqIPkzJyOtxyQ5UYmV5UE49h8RJ7D7vDjbxYIHSbqBzJJY0jARR6vBAb3iooBPEjovahxynd2ie3387h0tgQqlaIZCEgQY1OlQxKzkyW2QU+/lH7l5nXoDKp3vMGz7GqpYbLkD/LMPGBZxj2HBziSbVM2smtB
 lxEU1gGS
 xbve3TtqF2gXN5zIHOXE1/qMHDG+QgKX0GzgbAgKB7EhiajeJnE+6a695hitzUB0fbuYrI/NnyCr/YDrDk3K/br3LIm1cnFZyPxYBwevGtP9o9OuzY3ERmPvHa6dkGU1pG9AvaH6FkoPMvI676OBI66dyBlhOU6fLmAEiXp6aEmgrawAV1PXgU7C9hhIYSoF5AOg1uhlk5MjiqtebVie6jnO0UrEhnIcEx27ECaTgQCBuMcwSSq3SvVaCGVQ95axdPnvB+87FMa1lQVb2puvncWYyaLCllZUeJgp4E6MvPHm845PMDBeNHntPmOYCk8+SuiKC9xCWM4NHiT2TkCg9MQKtm2GDtlzkF39K47ZRriSBPd89UpcjOQh6W8F1Lnu9yZhgZlHv3F4s4+bDwQtttXxO+e4OFlXKiWZ6VlVUgB45DtL9R9HJOSjocIO3UANl9rMF6CzKqSgGv1XeHm53FOAhVVfcrZz7fi1hPeilK61G1hu7jS1dSK3cnA==
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


