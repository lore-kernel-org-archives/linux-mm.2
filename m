Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DF3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FCFF6B009B; Wed,  8 Jul 2026 07:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D48D6B009F; Wed,  8 Jul 2026 07:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598EB6B009B; Wed,  8 Jul 2026 07:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13D806B009B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D31212078C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:38 +0000 (UTC)
X-FDA: 84965351436.05.E5A1987
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf29.hostedemail.com (Postfix) with ESMTP id 01B34120002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="s Hx3SD0";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=po0Sgzoy;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHYRZBpXAiDEadl40kRDh0JED4LJUyQnY94gn3r1gWI=;
	b=BAjUVs7Ccj6P1H6Nkf1RqBZBBtoyXraGjGeU6l0OuTU1F9RL3tMy4MLPTrZfm2VJ/wAyN8
	c0fmmtuJDh7p5EMuvvpMC/yx5d1rb2tqDqx+UtrsNWvj3bKNGXOIzvHtMBHAE8dkUe8Ga4
	nCirOzu9YhGVswX/cHgY1M3KQC8M7JU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="s Hx3SD0";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=po0Sgzoy;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509276;
	b=3wYj2/MBopvD7Qev11xEvPDIHxhUHb3BWP/9p4huNkvIYXPLUbY5nvqcbIDUoWKZe3S8hr
	6r3kVhj+d/b/WBJVopzsOcz9gmy2aZSjaG2uxW1RJ7DsxsYKgrZRdaf7Nz8AynzgH42l34
	ZxQBu7FZ3CrsCTU2Hs+WiJDdRBGITzU=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C0A4D7A012C;
	Wed,  8 Jul 2026 07:14:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 08 Jul 2026 07:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783509274; x=
	1783595674; bh=lHYRZBpXAiDEadl40kRDh0JED4LJUyQnY94gn3r1gWI=; b=s
	Hx3SD01sTtuz+B+QBA178E9uPSkURB7L3t8AQc2KtDUxZ0nfMO6vRDwSB/oDfrYt
	grmnuNrgWU9BoJlfWabO6/c5UnOAp7U3bucJkZqGgmmBtMOPBHkNYkWfTDAS70iu
	x0ojGxEWa3IfEtgNG+pFuWZIlij5JsmP3kcyQPxaCT/BKT8OM5c2XAW4bRHNw4WF
	EGYRWoi4oqQq6Isk4JOUbIYTORNu15q1waob3fOmkIb+W17WjWwF/kpmWb81fZjS
	8CVATPOxiRf3O06UN1PZUkjXIVyXfMst2uV+xtnUVKlZfZ67eoPLixUd0fAO7hT9
	sZGZ0busJYTpbGf94i4zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783509274; x=1783595674; bh=l
	HYRZBpXAiDEadl40kRDh0JED4LJUyQnY94gn3r1gWI=; b=po0SgzoyQYR+NqQjd
	F/zugeB9B0pyHp7zb9W+ckGV8bU51uPlGQ9relp8MX37YCLiSWNuk5vLtWaqkt2n
	O7Ba9eHNBlCCXOy5c2VkL6DljdpFXk8jYPx6vcSm/TvxMB0eB61a8ea8I8xNp0Hs
	CQCjuxwAe01n1yIZbRbOOE4zbcZYBTOx9xwxW/VcsxrQf7YYRXUsutORuM6yhr2E
	9nmTl//EpcOD0i1l08Y6gELgTwJsYeA6mA65Co/BeBVwoq676JdCakKRHSZCwbf2
	3aj6r7rk15FmEF0jwyemK5wrsk3PHYMiSOGqPcCbqkkLm0FCdtuH452uaImaJohg
	wD9cw==
X-ME-Sender: <xms:GjFOapOKCWBNtBa7n2Ej--Oxkm_9rI6VMUU8gaF3vBEydGXDzMdMXA>
    <xme:GjFOav5ZPn4W1oE7TMpz0kk7d98JSwOksERgBDKpBBbOGjuSSf2JKVbWXV3JLuF-t
    nmGQA1jpBQA4NLoGI18cQeS3v2BRrdtN3jrCZUAutuvgJl2ry4YTQo>
X-ME-Received: <xmr:GjFOagzFS0iQsx4Cn5KcVNs78oFkT_1Sz03nuzjP7vz8yYZfsSXnp_SXYkiXVQ>
X-ME-Proxy-Cause: dmFkZTFrgK+JlrVaprEdMCCT9jL+WeqlR41PWLlswNzN7Q+R9eHi8slIfq82AsY5fCzbDR
    FF2c6/38vqfy5yn0mfN1Q1IuR0w/6jjhcBlbbYbwVeHRfHyttYIq8Oj6v9pP51nLVeKVF5
    08J2hQde+dVWeXYQH682oaYmn32K1d4rnz4RgIn1j8hjtXUL5IxvtXbrp9YKRUv370bN2m
    UN+Zd+JxmqGqLZtvxlNtOAXgPcUE/BQPZ7oqAykND9BbS/e5r3R+8nAwQL3YfeXzdQzT7u
    8EidJ7yOHxiJJbRHrAGeZIH1+iybwcJ1viiDHX7PYKqYv0VVB7VVolJezAJqTlXxgJaxgB
    QFwm68fAonFIfHpZ8G0tP3NWJMz8fS7tjZC8iJ3R/Mtb8Hh9A/yDHLUXWumG85iLfJP5yl
    W7BeN6RnPlwRLRnc2ySOjyZ/uo30DDHO+i5pHKALkb7QcYBiZia4VJqMf2OEmZ0UohiR9o
    b+lKpkUFGCZkOhnmR2xImJ/wMb4CBKt7JkgTs1It2bX/qmxhgOM8BS9htIqSNgANnYqLz0
    ICkRqAkkeZb8KEMUhgvRV+UVo0cA4hwY3E6DSgtU/nh81l4aNFWgpADcTFqZ1hLSDhLSl+
    m3rvCUKm8xMebsiMD3AuGhrhHRjErYD67KVJp5VJ0gp9lnJ7nPReBqbqxBBg
X-ME-Proxy: <xmx:GjFOavS-N1wYJtMxlCrkr82-IBTobnr1N3D0AmtWy8VgUihKJJ9qLA>
    <xmx:GjFOao_YA8lQw_EWxr16txe5xlxN-lS_CTgpWdYDDH1oDhbwYnVZ7w>
    <xmx:GjFOasLAULBir0fUUDefO3a10qyHSO8_EZuiOfxnFnK7z0d1WBYb6Q>
    <xmx:GjFOasuEWd7MrIUt7xpScd6As0kKqQGOm4pixX_q6RFEtT6H337mtg>
    <xmx:GjFOahtRHJiF0HydzKdPCehILS3zj35XkvxIYnXOfHLb71A-SWFDdUFH>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:33 -0400 (EDT)
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
Subject: [PATCH v10 06/15] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Wed,  8 Jul 2026 12:14:07 +0100
Message-ID: <20260708111417.173443-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y6u1sxbgjmag6p8c55rii7hsxtx3fftg
X-Rspamd-Queue-Id: 01B34120002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783509275-827374
X-HE-Meta: U2FsdGVkX187eB/EiTZpKAuCSQ4fjsBDNsrisb0EQomFWazODSheicwqizdYzvpvXPSAqVMKhMPWJNqfKXx+OmUCDrexoWUTHngo7mM1Od/7Kw/hk7UEZW/kbkLL6P5ywvDXdd5syW0DCgKTHJZPIh1fTulET05bCHnIBrUSpZzqiIWxkCis5IlKIbsfOGLyFUTE+anxdY9vhqYWhacrUOBkmxZ8pfG5V/AJJ+s7zfADRKPs8g3l6pjtKM7RX/VbIBNm3zkj67eQiMFGREQWujgww5/CeeabSwTtyS48FJGrEXXYDrSvuppSW9Ih/UeMDIROxEjRuAJsE6PuqwZAf0TbmeSCnmyYLrRlK9A81JWhcyqqAp5sKO6mxC42WeLw0298+XpBfX8QwFjaY7NBbOiSspuIZimBU10/pgUrLXqumCK/PVsgH9foAz9R8Dd2gPQYM6Wjh8Xt7HtTxKXVFRRn2kiYmOsLD4KLYPo+EKtMrsj5GZtWeHnLGl9eCZaVUER4wHnH5rXIBgzcUCU89iM64CzID1VaZoGrTXLiC5WwlmeaTKN2QsGvVBkXIcoeMmMGIaVXSzqz/OaeM2HzC5PQo+jr/atpzwc2FlvJBymcijrnL4xvXyKPTAcPreBs8ROi39FasabJJU2useRXaPENIzvddYS6yjb9b7ISC8LHh64C4g1KdOY9UTnYZ/2ObZn6z8Lo2d2Fpi8djhOmLvoVFnLSK0PwS8nvp1vixs8V719Nli+sZSKvT3ZGXBWZylXSuqtF8QsTmqh8o8ctKLLTfFD7Ymd3P7JTBTk0Zt98iwuOk5G0dCfWVvyegNL9XY18Ztfn20sSdicxLfdaK3+WV5GfZgdpSXHejKwvcOJas5uo3g/IbKaOfA/zErD25e7d5CdK4LRGTQ2efAYWXTxRlC8FESbYJNBn3I2u+ihHwjFElePQukLTJ0SHYzvUWgodR8V/N8nyGgu6nd8
 vPtorK3/
 RPllxzoJD+CQxDgdqB3BOu0A9xPufwfLXe7qSLwpk7FK/n/lqlt+wB+RgrauyrAPJM3L3NjTZ5Glli5zqSC9D4Eu82aNTmZDnQo9XVhhtQNc50Jy8mD9oiAWNANXg6RYtNdQKLDlfP/MyUbkFomfyHC7VLmoojoKsmGn8VlLM/0hSYm64jeS1WXxLRbKtL80AoAUAMWA9oESjIPYD6JiKwrV+pIUm4UnYt8Umt3xCBLMBUbhlW85fUBKxOra5ioEDb/itsou9KEMce8Vt+K+8WZ7UmVTZMbJ+AOInf/Bi7RnFGooUyLNLsxc/E0FWbfQ1jEKvYmt2pc1KO6DuRC1dbEEGBxKbgBWpM9/MyTsY/Oc5KCpKodZ0WV/EL7b2wagRYyb8E4AlnAC6PZtoHjaA0IU2m5kNg88jFtyyXbNHrdp/1VFe0n1S0FXe+nVjbJkAUxRn/Ojf5+vByjshpyA0LrkKySFMJkuzVJw8k+aYk91BtZFNgElltLlko6p4PCoaohhnwoyEZQsZxsc25+k2lgpqp56pj8hNInL9f/DcOpCVy8n31/W2nxn3NIBJJ+MiOrPe
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
index fdb8d1a500cf..a567abb90862 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3356,6 +3356,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
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
index b9aee7248c17..0e503ab2493f 100644
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
 	pmd_t newpmd;
@@ -2583,9 +2583,9 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
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
@@ -2606,8 +2606,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2620,11 +2621,17 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2635,9 +2642,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (pmd_protnone(*pmd))
-			goto unlock;
-
 		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
 					     vma_is_single_threaded_private(vma)))
 			goto unlock;
@@ -2666,9 +2670,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2714,10 +2718,10 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
index 53a70ee63957..d9e93d1d80d9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6437,6 +6437,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	unsigned long last_addr_mask;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	struct mmu_gather tlb;
 
 	/*
@@ -6462,6 +6464,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 
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
@@ -6483,7 +6490,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			 * shouldn't happen at all.  Warn about it if it
 			 * happened due to some reason.
 			 */
-			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve);
+			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve ||
+				     uffd_rwp || uffd_rwp_resolve);
 			pages++;
 			spin_unlock(ptl);
 			address |= last_addr_mask;
@@ -6517,9 +6525,9 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
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
@@ -6530,19 +6538,24 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
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
index a971d86c06ca..ea290f04d90f 100644
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


