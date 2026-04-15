Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D6CF9D0FD
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8E56B0093; Tue, 14 Apr 2026 21:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783966B0095; Tue, 14 Apr 2026 21:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4886B0096; Tue, 14 Apr 2026 21:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6816B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:10:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18AE0E368B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:10:42 +0000 (UTC)
X-FDA: 84659010324.03.5E3A57E
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 53ED0A0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:10:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dj2lAaIi;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776215440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=8Cw/JZFECeDgg2piqdkTLJtT6fB7QlqNdpNQHpTOkjs=;
	b=gOa/F+3LJRsnb4GG3lyGXvQviQek78PzqjTtiMv6WLycvxKlzk2oi/QFWvoUhoBJflZInD
	67pdn0p2epMEUfKax5c7R0YaaJ1fCZfLSAkHNGnv5VKg6/aiMZQvTFtghuz+RH935nc8qH
	Io3yYBjavZBbgYVHY84KUQgf02rvtBY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dj2lAaIi;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776215440; a=rsa-sha256;
	cv=none;
	b=F/giNa793vNToMgY5yJIkdHmlpj1tJnLKpYd45ORlOrzj2mN1UPozflmxJKgpZGVE9UY/8
	YEiY1YFlR1i8my4/rp38D83yNxxGXYtDneLog4+hpEpdn7Mxw/Gy3W0YruKah2FvnjFUDy
	8m9ETpQUmj8rFxXFLDkAl8ydsPe+WZk=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8d7f22d405so972179466b.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 18:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776215439; x=1776820239; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8Cw/JZFECeDgg2piqdkTLJtT6fB7QlqNdpNQHpTOkjs=;
        b=dj2lAaIicAYP12ni3sFnyrMU4/+a2yn0GWPNMvSimhXemz5PUByQlf1DtonFjlgG4h
         Opkkl1rnCsgpt5NFz6W0ei49RIrQ6J+c5n2YlnZHb9xcVFsJofNpxSlAEaHW6hdWPhX4
         P1RiamqK1VOYbD0FXv3eP1C4Pr1uYskH6swnmnhhXrJUoazXwYq5A2RkPk79GBoQ0phy
         yzK66yhBIHdmOq2ne80S1EaWJXb3to9rdQeBAFXhV6xJAUahWR0IVXFw1HXLVBGkdcr8
         EstBh74V5RjyyQDziWWNKyoMw0wNfZJ1POQGR4ifCC6mnq+COqMOc1BtLFUyoIa1uEc7
         xL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776215439; x=1776820239;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Cw/JZFECeDgg2piqdkTLJtT6fB7QlqNdpNQHpTOkjs=;
        b=Vm5hT+yJaJ1lVqoL7OuLTXSVsbq/kljhhsz16w90sOfSTsooS2mJzcXxrfWXoADhWn
         9onIJ3R8cX9hdTu1C7TIYmMVlYRQ/0zAE+xTy+AYAnbKYW/q7f9A2S4HofcVmaM1HpcS
         8PSx2Zjy5BowgAuiTNkiqhPzYgqExU22BmdAl5Hq21RJ1ZcZmkNzanUkDdtd8vk48QAD
         xc8Yxb3i691wiRsthpVvKhtik8fyv6aMGSHGwSkIsy100U1TnXVf9HRyTyns4RBZ30MO
         PSNomfflfapYN/vuZYtMiMvt0ctKwUYCQajirshr3vtpQsMWRksgo0oZG/q2KFqgOeHa
         5eSQ==
X-Gm-Message-State: AOJu0YzcXZZ11JKJ2JjRi186J+lQdEmxtlxSC5k01iDBayFIw6PZWrRW
	buyqDoZsRDbNGM4dZWCoi0VeBIXSm7urfYNNPcq/N6xVajzdUlhRWgCJ
X-Gm-Gg: AeBDiet6OlUuFJOBT6G8aqd5uFyJxLjixwikQdKT3YsIjNwm7w3dQozcgXwjdDy+bLh
	9IG2V9XVIXKre4BpoUKD7NelGWx1ohJJM/SnvqQsXDMB0Di6jBIy1rvb36j2KyiadHKO8WK3pxx
	Y7LTjB4+0Td+zMknXqVj1VQ/XcxzQEmEzv1tNJfiTk9SpbQi2KN3TRfm0qjNZWO+BgTDlPNxfEg
	Lrmzv17WrMHOJhYB5M4d+ofeofS6mrZFQEyzNkFt0I4j8xkALQwoxGzXGyfHmM0aGvtLGTNf4BV
	HTnFvjHLRtI7+ooUbNYeJnxyjwQ3mLpbAZNQGlSL7xhVYtAYp3G8yw4HnMl+RiSirKiRSPcKYu3
	WuYQ6Rj5FX/tCUX3+qRkUCq4fR2n6eFq55jiNs4ln6U4/PpvH5mOViR7j2z4EcHJs+J9FK8Sxt2
	u88+iwA01BIqfKG+1N63xG7/UEtVBuq2V7Aw9YbNGJ9gg=
X-Received: by 2002:a17:907:d08d:b0:b9c:cdd7:486a with SMTP id a640c23a62f3a-b9d7298076dmr1098256366b.31.1776215438458;
        Tue, 14 Apr 2026 18:10:38 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba1773c5318sm3903366b.41.2026.04.14.18.10.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2026 18:10:38 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Gavin Guo <gavinguo@igalia.com>
Subject: [PATCH 1/2] mm/huge_memory: return true if split_huge_pmd_locked() split PMD to migration entry
Date: Wed, 15 Apr 2026 01:08:38 +0000
Message-Id: <20260415010839.20124-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20260415010839.20124-1-richard.weiyang@gmail.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 53ED0A0005
X-Stat-Signature: sysn6y7kzd4rwarkfmoji8k3d1b6tfr1
X-Rspamd-Server: rspam06
X-HE-Tag: 1776215440-630434
X-HE-Meta: U2FsdGVkX19/pmgue1IySzT5p5DQzT6+N4JaP9sEHSYiDXnGxI+yf3zHtcaDGOn5/g3JoFSwghDzlL0QsTQ50vprv6ksfnhNTOCbtw0QytpcIhWLxR5CUJqfJoNN8ItXc7RVZ5JYPMQ6apUawcDNP+I+1GzOHGb0Dl16WlpQgK2dDrrEyvhf1XWNjX4AcmSh8m9NUtTa/Yw2aonG5MJGSuPE1/3ijAbCIEMDeFxIQ1ucCag2h5QIdHU1qIX2z4T/sUClYrnOJohEGY83lsd/07XZFeJZCHKvrFW8EdKHydfZQTpvUNifJ1PKGUilkSRCqFEdD6aZ6Cb42VUTQn+FBOFFtSpr0UF/graeVMaCoxLccSLVA9To4FZIQaLHpI7SrIc0PrbqcLFu9vUA3oeXxqhw4n8BLPG+lcxCjFX1iRYL057ECPmb7axzPc3Kkzx+3l+SujI8YOcPsgSkUarOlNUiWNAfox57znLf512tgDad6EdTl9wbTvNXobVx4tMirqZm4syAAvN0FX4DwOk20Z2erMGftFuTlIX3t7TqsXCOSyZFZU24rCyfdGG2r5dchO66WchVPIFodZKAqWrNNQy2xQnOTl3BkrjiZOM4GR0vUvUnZaM1a8uQi6jlf9CDKthhvw5QZGNcoo3kRau6Y+uPrC97G2e9vyyJEvhTE2j6WHL+Yirat2qETKAGuR9PTpawImPHmXiKwY6f9zP+zyYurdZpL//z5RoNYRqsANzayxx00USnCuMcA3sprLGlug1JP2R0lhYtA5sUSAyacNn9GkTbj6vHt5KxCzMAAWgS/ph5XG9c7YaFKZA9iirrGCf8ipkB4T+8fEyw4AqK30N1BaxANOOBfysnKaypxibscXYxHNNzf3nKDbT5HM0gSi9wOpkBnguFMIC2mp5pRrLs/s1j6F4Q7QtKJRKSmQge0q8AtE8B6ujAGuYiJX21sNm7pJDHnwzUXqRKYWZ
 uDwwfwgD
 EIbQqoEbAxk4LTFqDsgOW1a2WxMJA9BbYCb30EwpZdSiap4JH7juiZcy/nCl7s8bs8eFshwEQpvMdAdlnyRfSLgVgDgu/QtMWSm9wnnkPioV9YPvYst+xwVeOWmtYZ5+sJrOE9VN6BBrULRizFCth0luf2lnqq6q1Q5STXl2rtj65M/O5JBuv6FWe3zF510TDvcIL3vOhfcnnJf7vADGDwQyQaYbSYgYtnJ6yuHLDLsLlSx/SESgnny4FRZ1a/e/StMKYEit+YEQHgM1q+wOzIOiwGihtwXYd9uuKs4AU4d4G6cQkj8lWQF9rxxAYQokWYZXs72NWED5CqTMA/5YKqjHWC6y/03E1JhyzZrypxVKBnbMua+s9zjKiRh0NF5XNf9NQoreTJMu7RYNkZ+egJGq+xN04c7efyQy6iH+Ma0liX7l3l3WRlDgw9+hfzbl9Dh9mqU4u+66bpqEULMGZIm6bFxJGLL3og9WGo1QOYXzXwtCyfW6ra+h1umcs5FPPdaOxvQRStM0AeBJ9m0egyKdriJYFzCVi5ftJ5FSigRDiYWxqx9qV5JR9/mBHp2Brq3U6T58vQSs1MUl/0ehsXeJmt2+TYVZYr6GZnh4t4M/YQx5L6CPnfSQQj2kuvW6RtApQuUg4LB/2Dn8DOzaxRol9b54cdgkk5SrhQ8e+Ahfr0VfBC0KDcpeAfJ45/ycJCJQLguGiKRqoP3MiaAMRKXOEOB0lSQ6FTr5JZf4THjcRGOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When @freeze is set to true, split_huge_pmd_locked() is intended to
split the PMD to migration entry. But if it doesn't manage to clear
PageAnonExclusive(), it just split PMD and leave the folio mapped
through PTE.

This patch let split_huge_pmd_locked() return true to indicate it does
split PMD to migration entry. With this knowledge, we can return
directly in try_to_migrate_one() if it does.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>
---
 include/linux/huge_mm.h |  9 ++++++---
 mm/huge_memory.c        | 21 +++++++++++++--------
 mm/rmap.c               | 11 ++++++++---
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..6ae423b8dbc0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -561,7 +561,7 @@ static inline bool thp_migration_supported(void)
 	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
 }
 
-void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
+bool split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
@@ -658,9 +658,12 @@ static inline void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze) {}
 static inline void split_huge_pmd_address(struct vm_area_struct *vma,
 		unsigned long address, bool freeze) {}
-static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
+static inline bool split_huge_pmd_locked(struct vm_area_struct *vma,
 					 unsigned long address, pmd_t *pmd,
-					 bool freeze) {}
+					 bool freeze)
+{
+	return false;
+}
 
 static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 					 unsigned long addr, pmd_t *pmdp,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..ec84bb4a0cc3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3087,7 +3087,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	pmd_populate(mm, pmd, pgtable);
 }
 
-static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
+static bool __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -3096,7 +3096,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
 	bool soft_dirty, uffd_wp = false, young = false, write = false;
-	bool anon_exclusive = false, dirty = false;
+	bool anon_exclusive = false, dirty = false, ret = false;
 	unsigned long addr;
 	pte_t *pte;
 	int i;
@@ -3118,13 +3118,13 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
 		if (vma_is_special_huge(vma))
-			return;
+			return ret;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
 
 			folio = softleaf_to_folio(old_entry);
 		} else if (is_huge_zero_pmd(old_pmd)) {
-			return;
+			return ret;
 		} else {
 			page = pmd_page(old_pmd);
 			folio = page_folio(page);
@@ -3136,7 +3136,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio_put(folio);
 		}
 		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
-		return;
+		return ret;
 	}
 
 	if (is_huge_zero_pmd(*pmd)) {
@@ -3149,7 +3149,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * small page also write protected so it does not seems useful
 		 * to invalidate secondary mmu at this time.
 		 */
-		return __split_huge_zero_page_pmd(vma, haddr, pmd);
+		__split_huge_zero_page_pmd(vma, haddr, pmd);
+		return ret;
 	}
 
 	if (pmd_is_migration_entry(*pmd)) {
@@ -3309,6 +3310,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
+		ret = true;
 	} else if (pmd_is_device_private_entry(old_pmd)) {
 		pte_t entry;
 		swp_entry_t swp_entry;
@@ -3366,14 +3368,17 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
+	return ret;
 }
 
-void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
+bool split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
 	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
-		__split_huge_pmd_locked(vma, pmd, address, freeze);
+		return __split_huge_pmd_locked(vma, pmd, address, freeze);
+	else
+		return false;
 }
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
diff --git a/mm/rmap.c b/mm/rmap.c
index 78b7fb5f367c..91fb495bebbe 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2464,13 +2464,18 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
-				 * split_huge_pmd_locked() might leave the
+				 * If split_huge_pmd_locked() does split PMD
+				 * to migration entry, we are done.
+				 * If split_huge_pmd_locked() leave the
 				 * folio mapped through PTEs. Retry the walk
 				 * so we can detect this scenario and properly
 				 * abort the walk.
 				 */
-				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, true);
+				if (split_huge_pmd_locked(vma, pvmw.address,
+						      pvmw.pmd, true)) {
+					page_vma_mapped_walk_done(&pvmw);
+					break;
+				}
 				flags &= ~TTU_SPLIT_HUGE_PMD;
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
-- 
2.34.1


