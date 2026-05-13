Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3792CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C2B6B0107; Wed, 13 May 2026 09:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177906B0109; Wed, 13 May 2026 09:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A436B010A; Wed, 13 May 2026 09:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E87466B0107
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:22:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B61A1A0117
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:10 +0000 (UTC)
X-FDA: 84762460020.07.869259B
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id E122112000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hTs1ieNC;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyY9SCyAZIGNdueTrW/y87O7+cp/ViobtWpZedyU1UI=;
	b=1kC3zjida/a0/2zbbDjbwmgaKFlsTjqRryyaz0iNz5jqNQbtm1g1DVQQge2D/Q7ijnchV2
	AW0ENztluAla2UqZNf0nOoHg22aN14/Cio/jLpuL38wB0WJu3ieSRXmMm6Jo5xJCorH2yf
	D42KBvQtFNEkkSW+cb/F1VYUl3aJ28M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hTs1ieNC;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678529; a=rsa-sha256;
	cv=none;
	b=B30LX4vA+zhnVSh2pq+6UomlkXo+CTXvFbR1D0I9IRMFKkaJvr6gB3LkMIKeuEX2qUVO6H
	b+sBkzgnPiETDR6owKDWZARx1z2PThccoEhb6XzeVpMuc60DC/fXzPJqH3sG5B/tqpjEQ6
	LQh7PGw9VSC01RXl4iyjYtFOPzD0kes=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-366087480d8so6059899a91.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678528; x=1779283328; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gyY9SCyAZIGNdueTrW/y87O7+cp/ViobtWpZedyU1UI=;
        b=hTs1ieNCmGDCCG6R866K9OtQnSllFBRdijTQGy6+ijyrlIyIJ5IGEXEqDvHZQnWqUr
         DNiIgpXUwcmATOVsbNgddDEUp9Ku28nPae51UWA0XWsqfWpMCsIDPeCKduYLuKDIQ2+s
         PGyOhjOqJGx8lAOsskZTsRo8fuo4EHRev6+q265iHFrdWhOCowmP23X8CIMhRI8WyVs6
         UMMHvndFCPiOigV8dAilnGOS5bTby0lzWfGAaANOxhCpFmbH5jtQKYsQcvXFNu7XI3Oq
         tVYhgS6VlPy+b5FMXc2om/Fx8tOHMXdBQWMAsoR913m8ubHXN6ZXqZBSu9sAVEbNKPUI
         v90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678528; x=1779283328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gyY9SCyAZIGNdueTrW/y87O7+cp/ViobtWpZedyU1UI=;
        b=c6T+4uweQF8TDTL9iS7OxRhwpXGI9QikbO0wbqc/QrmCbF6/vKQKdcaJpnLNbYP4uC
         bZt2zX5fHXUJpM+xFP1NSKHI2Ux3T9mWGolxegj1b4CMgz8ceBIoPwlhCy6qBi5BFnjP
         sTks1n5R4Zqf3F3W0ph6Z+n3xupZQPBnqXSR3UfLWISjmtd/GMFeqHHRJFPiDMlkZg4e
         j9RVrltE8gf7gxH4VZAOR0GwF2utoqPB2aO6fDAFicCsdDWeWHLA1mkN7gK1tUHM2iLE
         8JDBD0CXkAChWM43zyegANiKL2BExyCpNc3Nih9vb/9hcljxZfUVeVnniPRu/IiQFtHz
         t6Vg==
X-Forwarded-Encrypted: i=1; AFNElJ9tWCCrrNTpP6agkmHYcQcNl4N52dvVpjdsAFpKeMX+eaPFXkKgU3LmlDTrtDBWbMeprV3hawmTRQ==@kvack.org
X-Gm-Message-State: AOJu0YyPkB2FBM2GDDv71EkUnWlRI1Qmao3qHq0NCD+uS/SblHetxoEi
	CYctgeUjQi6NRgJwBflBsymqgtB+l/7ujiFWQoqRFxepRmpWF6l+qywrBHqwzS+6f58=
X-Gm-Gg: Acq92OGkilYofSTkvv/qOs+Ejp4vEISAbQQzGKzSd5YQv28qILVXghb41TkErgUbhd1
	OrKOYNDmmszl24mjK16LrvOtrjmBoy0ihpAhTwxLrxlEjiyBinuf5QhhVmO18AT+ncuGvoLx1w7
	XxiIeJrRJkD8jBA/YavoSYdBBJA7+Zdna7TlK8D5a++WJR6DYs0opHzQV8BVF+SyR/lSk4+wwum
	8d9zuYIRqIDBnVKkF6AcE1AQT6ZW4YLZXpEOoTGoOylY5eoGLhaODZVjWdVWg4cPVgCDuG8SD5+
	2Q0ytne4SsAqHcM2VI3QAl9mdwaUwVMSBm7t32PzTWs1cTurjC1MOHL8MOnHhWd0SvvGZSSflQo
	zsTD1l1/Ia9vzkJtVSderjr/+gjK28tcbbfYhHNaXSY48STELENYyzx2zL1XpzzgBpBz7I0xiul
	lGisdhTKankRwRaXvFb2bLuik2k8WHViDMrEM7LLgDwn0v3cTHOX18P4ZR6Y7Z
X-Received: by 2002:a17:90b:3bce:b0:35e:3b08:8fc4 with SMTP id 98e67ed59e1d1-368f398c9d1mr3681030a91.5.1778678527413;
        Wed, 13 May 2026 06:22:07 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 58/69] mm/hugetlb: Make HVO optimizable checks depend on generic logic
Date: Wed, 13 May 2026 21:20:23 +0800
Message-ID: <20260513132044.41690-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4m13h4ty97n63casedbkwzxd95d8fswf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E122112000B
X-Rspam-User: 
X-HE-Tag: 1778678528-710517
X-HE-Meta: U2FsdGVkX1+zIf++Hs1bOLw6X5JNlGPu/a6RzzvRzbozCRZCcqr0C06xUecWYn0zO0qFXNGDIQRIcYmKvZzfKJcNI5a1w9M2TYcoz68XfNaTPct3YVZaDwKkoQ2DqbwbKvbqC2UUSAN8IpdqABGrRZyd944KgJw8YQRej1+H91sRPGugyaQU767S44adz+nEnWO2PTFg9QC6nZCuwumHtsJj3ciCx0sqLdzAg0xcHOoBawCgO16Wy7UoWdKkDUzJU+SoGtSyi7ZFhqt9GcbFbs4wjHf6VuKYgFPipfkw7Y0rP7xMMYxK7Gv5utRHRoyjOFGee+92VpbJsGFjuddc5VSeQnjOBH5Mlhpkvz3DK2L5El0Wl/hzO8yuUxGNALYTThzoIySlU4Nu1Cj++ycnfmF1Skp/K8R2sLrJ/Nn4ktvNZNQEyP24/MrMT2q0+H7ax/Cs5mm8yxCmIJubyyG8tDG0KkHrD0RjCzpEN8k4b+2v9eZHFKS5fMtsqtctZc7O+3xO9O3OViaHtZHjkXrQSY3pm/WIYhf4VnXJCRSKMe6tFTQsnWIo9zxZubj8kXwDInPsScdGYyR32O4d8t3i/HZO6tt1ST5ZUws6xRmDTOWwLnwLF06ceRg+MbYR2X9ii7W8mQ6LrGKBJWauL7ivYAU9LNqpPxR8KmsyM5ounaEJ/PE6S++2W0hCLZhliluPzDSgSlEZRLZCjeIyJlJtyXyFl82yEUzbobWA2vV1pMG4MHbiKu69Ub9lL55EW0LiTIO7NOWv4+GX49Fs3iBqUf73OEHGdaEN9QHsZn2tO3wz2oMtrMXw1GkU7odr7LFAqbWKnFGNEmXtwuNAxHE7n4piij+mIrXTNTdf6IhZVUaq0RIkDQ3IPJo0eJ6EwEfQTLbGwg8Gz6K7sdrx4xocg8MrANmu6kcHpjNvW6oOY9OFVPL01Gj3nDCc6cWY3blTqD68tq8vtB0P5icc1jB
 UjmQPJ5G
 8oUQeAbpmabAj4HGiyt8Mml64gRWI5NyuAhmopyMOintTmvo/9hRkfmi7jxSyGfQmINq1Iid8wodS9xbXCK/D/R/j8unF91+BlIfrFJ/7ReRPoP2IDUpiTfh4A1JP2EQmlfIS19MEB0s6pBGybYsSv0vcu+pfXSqbngomfK10kBwvUns+TsArFpOfz3TxQhmrJdEscHhobHij7kg9vrLG4mL//JaOOYhaqsdBMu4tTRVqMOunKniZ1AigKsA75rgq7WyMFHFDxqSULrlOZge366N671QX//iioyAvlZ/vwUgTf6HyjLV4+g84/I86ypngzd7hp3ozR/RjTqsljCfkvAB0bmp/Q7k92LJ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make hugetlb_vmemmap_optimizable() reuse the generic
order_vmemmap_optimizable() logic, and switch hugetlb boolean call sites
to use the dedicated helper directly.

This keeps HugeTLB-specific optimizable checks aligned with the generic
vmemmap optimization rules and avoids open-coding the size-based test.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h |  2 +-
 mm/hugetlb.c            |  4 ++--
 mm/hugetlb_vmemmap.h    | 43 ++++++++++++++++++++---------------------
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 82dbb9ebead8..2383adb22ce1 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -778,7 +778,7 @@ static inline unsigned long huge_page_mask(struct hstate *h)
 	return h->mask;
 }
 
-static inline unsigned int huge_page_order(struct hstate *h)
+static inline unsigned int huge_page_order(const struct hstate *h)
 {
 	return h->order;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 54ef7d12c585..bd136fc6aec0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3351,7 +3351,7 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
 					&node_states[N_MEMORY], NULL);
 			if (!folio && !list_empty(&folio_list) &&
-			    hugetlb_vmemmap_optimizable_size(h)) {
+			    hugetlb_vmemmap_optimizable(h)) {
 				prep_and_add_allocated_folios(h, &folio_list);
 				INIT_LIST_HEAD(&folio_list);
 				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
@@ -3420,7 +3420,7 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
 	for (i = 0; i < num; ++i) {
 		struct folio *folio;
 
-		if (hugetlb_vmemmap_optimizable_size(h) &&
+		if (hugetlb_vmemmap_optimizable(h) &&
 		    (si_mem_available() == 0) && !list_empty(&folio_list)) {
 			prep_and_add_allocated_folios(h, &folio_list);
 			INIT_LIST_HEAD(&folio_list);
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index dfd48be6b231..1765f8274220 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -18,22 +18,6 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
-
-static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
-{
-	return pages_per_huge_page(h) * sizeof(struct page);
-}
-
-/*
- * Return how many vmemmap size associated with a HugeTLB page that can be
- * optimized and can be freed to the buddy allocator.
- */
-static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
-{
-	int size = hugetlb_vmemmap_size(h) - OPTIMIZED_FOLIO_VMEMMAP_SIZE;
-
-	return size > 0 ? size : 0;
-}
 #else
 static inline int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
@@ -56,11 +40,6 @@ static inline void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list
 {
 }
 
-static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
-{
-	return 0;
-}
-
 static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
 }
@@ -68,6 +47,26 @@ static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_pag
 
 static inline bool hugetlb_vmemmap_optimizable(const struct hstate *h)
 {
-	return hugetlb_vmemmap_optimizable_size(h) != 0;
+	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+		return false;
+
+	return order_vmemmap_optimizable(huge_page_order(h));
+}
+
+static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
+{
+	return pages_per_huge_page(h) * sizeof(struct page);
+}
+
+/*
+ * Return the size of the vmemmap area associated with a HugeTLB page
+ * that can be optimized.
+ */
+static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
+{
+	if (!hugetlb_vmemmap_optimizable(h))
+		return 0;
+
+	return hugetlb_vmemmap_size(h) - OPTIMIZED_FOLIO_VMEMMAP_SIZE;
 }
 #endif /* _LINUX_HUGETLB_VMEMMAP_H */
-- 
2.54.0


