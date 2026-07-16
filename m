Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76680C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566BF6B0139; Thu, 16 Jul 2026 11:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F506B013B; Thu, 16 Jul 2026 11:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431026B013C; Thu, 16 Jul 2026 11:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CAF16B0139
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:09:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B53DC014B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:41 +0000 (UTC)
X-FDA: 84994606242.28.AD7D3C5
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0D1914000A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HZwuvgRs;
	spf=pass (imf07.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z21FwdUtYh7DDT6q0cWRgWwFAJ8AfleqYSoyR88c720=;
	b=airj7Q7sSIH6VMPZvwCfS0H42kOUtE9pcMO++SDae3wy+pRZtJiBoEJSrJwmyMO5nQzQGX
	yjSkfbtUoCxg3AEL0iEBtIyeMCNnf4DadCDcgcCnvlSg0GRzywmx96Gi8C04xbD6uvTWf5
	FPUGHdPnx4OQqLmVx7wCUaRMffNiUNo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HZwuvgRs;
	spf=pass (imf07.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205819;
	b=avTcPIEX6P2wRC30kwtRaqAi/LGiTWoVSF+xBVAZKDyVy3KF96FwizmZkRZFd/AI7NITcH
	/o5C5vHiYDB8vUg65Lcs2lA1Hk5VAq0vsp3Uqx4uL32yuOGUesbmyQ7bRaqT6MsVlkMad+
	FvC0Owqt5Gvw7jA5MlFCTgfDKYm37Qk=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ca2fad0ae38so5145477a12.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205818; x=1784810618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z21FwdUtYh7DDT6q0cWRgWwFAJ8AfleqYSoyR88c720=;
        b=HZwuvgRsX+RPwhgi6wP7iDCBcneE+4E7lL6WgtY9qgeXsJEpARtpL5cabPW7Dl6A4C
         pwBzdODkEGBxpo5UU9nz9gr8DWe/D5/UcI3Wwnj1uvCkp8JOKoCc8nlcuHwlw8yMxNB1
         g/bEC/ru2Sbi/odY6BQ/mgrA//z+BLbUmwa28EIHtFL9EIQjf9JBziS5SxiAR30ePDTt
         K2JH9CNFzdF6uYViM5kxb1bVrUxDhkNAus4WiV4xaePhCt0TXolXsms02D/JQyTrG20X
         KiEePS2bomV6MOz0gcYTxUvqn0FdpyoxOv4aLdTg8EQYOysLu3e515HjLHl9i4+bXKGJ
         w8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205818; x=1784810618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z21FwdUtYh7DDT6q0cWRgWwFAJ8AfleqYSoyR88c720=;
        b=MvZLfyHqccALwuBMi9mPUwbZT1+Hm+jIwP+hq2RQfbtsG35cPByQa0AkGtSTTiyG72
         8Hscfr++tDgG9qCUpp3df7bDibmegwNamzIUmqIfak3/MFPwes4EjtPQEWwpApY/Xswy
         +iTfSzS/Dl/RNlO+CIJCtKSV0tnblibKJtt3mbEvtr6cJUekwnQKYU5Gqx+5MS1+zxUY
         N0lvputAtdmHKmKOuhIH9Dbtgy2aPu9r+gU+o/nDrRZurQ8NIAAIIWnBZln5KaEjbfmO
         99ODFhQsYQQbWPWWpBxEI0Y5NRN+Dtpg9XMbHE5aanq6G6HmbfwUnaSrz9cgfhFLVUB+
         VJeg==
X-Forwarded-Encrypted: i=1; AHgh+RohuR9goangiJPp9eEaHRWrkqKaMVrQGGK0gS5eTkxCdfsARZOenhHu/9dWLvN8lyOV2hL/YAwXAg==@kvack.org
X-Gm-Message-State: AOJu0YxlzXOrHhExKsvk0Dz/cA//MC9URDkzWKkyNOOxGee7gXjjSy34
	19XB9o3P2Ai9Af9EukOHU8z7rQIbNod7d17knyjwaKfLrj4ycNoeA6VIgvs0IZmi48M=
X-Gm-Gg: AfdE7clGQlbcX1EG3gEjdncOqBpNSjpMWcYFtmo+8LenP7PK2Xk/CfTprHlEVFDk85e
	Z3X6GwKdSAf4dLhkwUW+b6M1F9UfmQu+8e9kxNLdO2/nJBj+9qe+nNKlaANsyoly5umbbORqCvi
	sVaLhKO1BG0XBhqKkv8/uXH8H/1nYHHgB68XV/amugF1AuxruHQu7yDxaCV5Dls9i0E1ecHkyQh
	DeA4e/FWcA3TXlL2QMnJaS/OSV1ZfSrocFYbpG83d/J51Nmosvr1UCzSt8bTtuKLeFH0EfEmfIj
	Hc+8o0+/KdzxjDLhAxF5kNfC46VhDTRmLk7psrpG+F2a6fYRLe2rU83iOCztgYzdg4W6byXVS/9
	KaNlmBoXTYTOk3Wf62aMAJnkpA+J2DRH5lETTQ2Blk/CTbvAg+H0IzQovRwTztCsaftUXmuOeM+
	InsROCWJGtuuv7BR7cqczYsMM=
X-Received: by 2002:a05:6a21:a98:b0:3bf:6c08:fb88 with SMTP id adf61e73a8af0-3c36c3e7638mr7532060637.56.1784205817786;
        Thu, 16 Jul 2026 05:43:37 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.43.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:43:37 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 06/15] riscv: make pte_batch_hint() honor folio batch flags
Date: Thu, 16 Jul 2026 20:41:41 +0800
Message-Id: <40bc1db57d1fdad482a32ca6aa95031f7d5676e1.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D1914000A
X-Stat-Signature: pgp4pirzjiuwanyqwfbdki9uym15w58g
X-HE-Tag: 1784205818-988303
X-HE-Meta: U2FsdGVkX18wDBhSi4yO+Y60RsCKGaDAFH4hPOBdUNPCU3JkyCGHz3woqES5zOLpnntIjjmQfZK6uQk9yaKxcEyYBRihRhKQJDFp5MOOu/NH+jhhlzUWPaPE46MzuM2UPbkDdxGVOzObj6/sKP6RGyPAJWrhyGINKCsaFTZB0isSQ++aZPT2HIgic6vVuj/nUAwddO7+22He6ar6jZuryDQslhFWBvJ2vtcEyLPdAIPs4dYlMn0DRJW60v1JmcKUssh/gb3sAgLDRRqQmbTHermlXaMnqes1CxbDBvQjeNNNOljKVn2RwRPwD+cAKWiIbqjmZ0gMOp4cWn9XwrdSA9yFqi9vdUg57Ata2WlwKqkZvQyH/Ehm6pmejRq/zcElSQQ/6ZlFtqjCiH/m+NlkRyrFgigD0jrTibsZcbm7XxXuuM+QuLsbzw5nUaCbmGPQlwMhORkEYowbNKZv0J5Xs6B34xlPnit80zhosgMrFO2gSUrRxoGPYbQYmzfbxk3xsU3dqyZU6D4hxg7stSiNvdcqhR1D5tdW6Yskv05kRPqPP+6CrQE+pa6474clvRekUBSIk5mPyi12q+4sm//YZjguMjlMRDLNm9C3RXCxlMBPHed1oVDRUvs++TIlGcRVazpdHTKQkkL1+cbvLAkXEZmEjNc8GlycjjmE5YOLQ001nO4qJfD+7XbvxMTQdPYKgipRAyYf/x7uyFHQrBg1K1HBV4Lod8RxNOxsQ9canXMjaxjRiwaWteB8NI6vwN6bfq+otWsyY2HcqMyTMTBWnqN/S6fCQFQxj/FUtEe0969nCYvkWvQCUQooh52A5bKYMxYmvr56fu1IPpK9pC5zZCT9bJA4l6qq9Wl2zQdr425X5De8HVhO8YHBT4xglkDVmGRPWprIadA5CEP3CUWf4JCrcq1Vr/zejyFfPglvMQuxGqJVSqmFIgfzk09QSzsjf2TgxpKD/qQwVJMeV+q
 wNV8lbtt
 mW3DPcjPCqxkU9/aoZbSZA+RBfqbhjFyYGzxk2F+aXIKlICatggY7atMkrXRmvwMohZiPjwsGJ4d/kTNvQphN3pO6R9kSNskEBN5YssJIv64OWVxbIf2KZpx563/BiLH0sYlKyO3rt31Hrvxzg7gRTdvULoqmWwj0uuUhlmSBPnC8VGrqH9Meh+sNVlF5VQ7vLpuHPE07ZZDdRvzFYaesNf7Mcgr67LWl2YDQ/pLgS9LyN1IjWq6hcunhz4Q0IxXw3j2+L3ZZvSpMt7x3v/L3nnns+Z3eAScoPHq4VGL9OmnHDCEB4N29fLZuV1IdZdpUtH7nsBSQNpKtnFuutF+c5jhjGI++qtuWWAI7R2GceixN7YAzs++an1wwkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Svnapot folded mappings may be exposed through a logical per-page PTE
view instead of the raw encoded block entry. Generic folio batching code
already defines which PTE bits are ignored when comparing entries, and
folded mappings need to use the same comparison rules. Otherwise RISC-V
can reject a batch that generic MM would consider equivalent simply
because the hint path compared a different view of the same mapping.

Install a Svnapot-aware pte_batch_hint() implementation. If the caller
passes a logical sub-PTE instead of a raw NAPOT entry, rebuild the
corresponding block PTE first, apply the same folio batch flags as the
generic batching code, and only return a multi-entry hint if the
remaining raw PTEs in the folded block still match.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h | 26 +++++++++++++
 arch/riscv/mm/contpte.c          | 66 ++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 771faabb2b00b..da7ffea0dcd98 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -6,6 +6,13 @@
 #ifndef _ASM_RISCV_PGTABLE_H
 #define _ASM_RISCV_PGTABLE_H
 
+#ifndef __ASSEMBLY__
+#ifndef __LINUX_FPB_T
+#define __LINUX_FPB_T
+typedef int __bitwise fpb_t;
+#endif
+#endif
+
 #include <linux/mmzone.h>
 #include <linux/sizes.h>
 
@@ -591,6 +598,8 @@ void napotpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
 				     unsigned int nr, cydp_t flags);
 void napotpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 			     pte_t *ptep, unsigned int nr);
+unsigned int napotpte_pte_batch_hint_from_pte(pte_t *ptep, pte_t orig_pte,
+					      fpb_t flags);
 int napotpte_ptep_set_access_flags(struct vm_area_struct *vma,
 				   unsigned long address, pte_t *ptep,
 				   pte_t entry, int dirty);
@@ -1033,6 +1042,16 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 	return napotpte_ptep_clear_flush_young(vma, address, ptep);
 }
 
+#define pte_batch_hint pte_batch_hint
+static inline unsigned int
+pte_batch_hint(pte_t *ptep, pte_t pte, fpb_t flags)
+{
+	if (!pte_present(pte))
+		return 1;
+
+	return napotpte_pte_batch_hint_from_pte(ptep, pte, flags);
+}
+
 #else /* CONFIG_RISCV_ISA_SVNAPOT */
 
 #define napotpte_ptep_set_access_flags(vma, address, ptep, entry, dirty) \
@@ -1095,6 +1114,13 @@ static inline pte_t __get_and_clear_full_ptes(struct mm_struct *mm,
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define ptep_clear_flush_young __ptep_clear_flush_young
 
+#define pte_batch_hint pte_batch_hint
+static inline unsigned int
+pte_batch_hint(pte_t *ptep, pte_t pte, fpb_t flags)
+{
+	return 1;
+}
+
 #endif /* CONFIG_RISCV_ISA_SVNAPOT */
 
 #define set_pte __set_pte
diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
index 3f8a0a2970afb..9ffdffdc2b0c0 100644
--- a/arch/riscv/mm/contpte.c
+++ b/arch/riscv/mm/contpte.c
@@ -176,6 +176,32 @@ static inline bool napotpte_is_consistent(pte_t pte, pte_t orig_pte)
 	       pte_val(pte_mask_ad(pte)) == pte_val(pte_mask_ad(orig_pte));
 }
 
+static inline bool
+napotpte_is_batch_consistent(pte_t pte, pte_t batch_pte, fpb_t flags)
+{
+	return pte_present_napot(pte) &&
+	       pte_val(__pte_batch_clear_ignored(pte, flags)) ==
+	       pte_val(batch_pte);
+}
+
+static inline pte_t
+napotpte_normalize_batch_pte(pte_t *ptep, pte_t orig_pte, fpb_t flags)
+{
+	unsigned long pfn;
+	pgprot_t prot;
+	unsigned int off;
+
+	if (pte_present_napot(orig_pte))
+		return __pte_batch_clear_ignored(orig_pte, flags);
+
+	off = ptep - napot_align_ptep(ptep);
+	pfn = pte_pfn(orig_pte) - off;
+	prot = __pgprot(pte_protval_no_pfn_no_napot(orig_pte));
+
+	return __pte_batch_clear_ignored(pte_mknapot(pfn_pte(pfn, prot),
+					     napotpte_order()), flags);
+}
+
 static bool napotpte_all_subptes_same(pte_t *ptep, pte_t expected_pte)
 {
 	pte_t *start;
@@ -328,6 +354,46 @@ pte_t napotpte_ptep_get_lockless(pte_t *orig_ptep)
 }
 EXPORT_SYMBOL(napotpte_ptep_get_lockless);
 
+unsigned int napotpte_pte_batch_hint_from_pte(pte_t *ptep, pte_t orig_pte,
+					      fpb_t flags)
+{
+	pte_t batch_pte, pte;
+	pte_t *start;
+	unsigned int i, nr, off;
+
+	if (!napot_hw_supported())
+		return 1;
+
+	if (!pte_present_napot(orig_pte) && !pte_present_napot(READ_ONCE(*ptep)))
+		return 1;
+
+	/*
+	 * @orig_pte may be either the raw NAPOT entry read from the page
+	 * table or the logical sub-PTE returned by ptep_get(). In the latter
+	 * case, the public view has the NAPOT bit stripped and the PFN adjusted
+	 * by the slot offset within the folded block.
+	 *
+	 * If the caller passes a logical sub-PTE, rebuild the corresponding
+	 * block PTE first. Then apply the same folio batch flags as the generic
+	 * batching code, and only return a multi-entry hint if every remaining
+	 * raw PTE in the folded block still matches.
+	 */
+	batch_pte = napotpte_normalize_batch_pte(ptep, orig_pte, flags);
+
+	start = napot_align_ptep(ptep);
+	nr = napotpte_pte_num();
+	off = ptep - start;
+
+	for (i = off; i < nr; i++) {
+		pte = READ_ONCE(start[i]);
+		if (!napotpte_is_batch_consistent(pte, batch_pte, flags))
+			return 1;
+	}
+
+	return nr - off;
+}
+EXPORT_SYMBOL(napotpte_pte_batch_hint_from_pte);
+
 static void napotpte_try_unfold_range(struct mm_struct *mm,
 				      unsigned long addr, pte_t *ptep,
 				      unsigned int nr)
-- 
2.39.5


