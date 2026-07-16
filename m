Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48023C44517
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84A76B0150; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6ED6B014F; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC716B0150; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61D156B014B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 237831A0142
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:52 +0000 (UTC)
X-FDA: 84994609224.24.1CA1009
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6F4E380008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fQwlPuBD;
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205890;
	b=XgIslmfUMBMUMGLxw7/Hb2vm2VwxeEgfUbtCnWZSjjYNuieEhCcpopwABg+mGg9SEMjplq
	7BBp1ACgaTYn9qqE36EwxbiJG6OaF/BEkHLPw/IA+gprLDHt7+LgPqdWZsOnHiVOYq3yCL
	Wk2XnfCOIKt7MBFYTs0cPkd+J5ycok4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fQwlPuBD;
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P62EVeZeD6Lr+EK73ByExkJlzskm2POoZpW1kwtVtAQ=;
	b=YUJRhj3xFkbraWgs29Fjh0pmHS13D9BK8VDqQtTr3tw6gYIUbJktDVqt3YrAd+8RxXcdGo
	Y8XlrPOC2oryvUlEG3JV8ZZGRkUNNwFObYnE6w3OeATCmtzpND/dyDtyIzQZX62yde0XwF
	YnYLekcBsfVJnPaQ+ubWWv6G069eaCg=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so2825958a12.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205889; x=1784810689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P62EVeZeD6Lr+EK73ByExkJlzskm2POoZpW1kwtVtAQ=;
        b=fQwlPuBDa3V26o9wWoN7yPiO1yT/gml6gHECFWnVgloGeNxjU83UnHqWDItuUtaNrI
         zLKP8c14aN1LKF6H0TD1Bs86ReegLVEwIC31EQYF2pMrdRxE65p4ipWxYoeYmpTf8TYS
         8O79BHpGpKS6YQRYvmuqq1hMCWJEW3XkiLQHBeQ/WPOEa4A1Qs0ZyK2mGSxSophGgE9+
         l1Iy06ktvvHwkYytfGD0ZCeOiUO2RRHdzL7gRYcp3AYZqW7NiKktCGeiwBDRIxR5P6J2
         GqPiLggM0og0ATnc3KNGUGgqbsrfgFNUUgHO0FMKk33yW05lqxt0FwQUIOnniC2pZge7
         54Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205889; x=1784810689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P62EVeZeD6Lr+EK73ByExkJlzskm2POoZpW1kwtVtAQ=;
        b=XsJaLHkuFTPcU+Igqd0AEl2W5f0pwxlpe+mAc2gKPLSuFPReKoQqDcfv8E77UqSxuT
         smQMe4poC3FSqUfLuFQ7vA7XBppPX1U1Mkm4EQCPDUW6mjwUXzyTdQfPdyM6c1kJDoRy
         34Qu72V9RQO4cCzQ3ig1oKCtAUYg+W3v5pUcawDbMPIzVC9HGAr7GPDHNgRQAWWR8BW0
         Ofp5aZcdVOk0SU9oVaRnHqgrf7ZliJk4kksTL2mhdqRrpJww0pC6EOHLwAJ8j7ahFseD
         kcJx+KiQ+QWBratOe7iLpBJ6lMYAvbRUiP8+gm8iJBSidGJRfxgVDhxsPrI9BFlLRc+p
         aFPA==
X-Forwarded-Encrypted: i=1; AHgh+RoXy6w+iuIBV3JZGF9YylumTrT64PZ5i4DnzOTziCrQdHkZmDZMOrPTDWshakZF1Qiza1LwEoM1Rg==@kvack.org
X-Gm-Message-State: AOJu0YzOYoPlab9oVuE7ZnXO6AUwFcjEL8dvEXs3M3m8ENUwjzENEtak
	xFp9R2iVa+tTUsZVmn5neI+OXjXdkw6Mhm8JVnl+V4nHzcK+E8mQwHFHj+nJ8WPEhUE=
X-Gm-Gg: AfdE7ck60H5t9TTrKApIqUSImvv+tSgooXgLUSxwfEFzyzUNpUYXaING+hErG4jdf2i
	bWygOIO4P2icKaiLJB9epAWsh2M7QnOLyPawzgKJhq3hpfjnn9Pica29q4snx+SOK/w2TWQHhTp
	sE+jc3qk8XgxAalfGPBPLgjohH7zAAlAYTg2rAJiC0RhHkanQaAGthtxWFTsYpGhM6cRfaYAS6j
	AijO0wr3YNCCxGfvwlkWdodxW5JjHgUvLciRAeGMCH7NYEHC1UJRb4sdSArDeiN8rvWQ0NVhNej
	dFaLWgZOUdVhkCDwLe7e57UTKmbAg5i15oxaRpvKAZE64fcQZ3t7usYOzpXhQb+/UfBwMfgSxNL
	vcj6ddyrdQCGu+xyxEyQ4nvFrOnHRd9g8H2F18BEP++qT0VV4A++DynKYXF4sz4UOHjS4p4b7cD
	fsFrxT3Kj4Veqg+6VP6EE/Yy4=
X-Received: by 2002:a05:6a21:7117:b0:3c3:89ce:b5bc with SMTP id adf61e73a8af0-3c389ced5b6mr3647677637.15.1784205889298;
        Thu, 16 Jul 2026 05:44:49 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.44.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:44:48 -0700 (PDT)
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
Subject: [PATCH v2 14/15] riscv/mm: optimize mprotect for Svnapot mappings
Date: Thu, 16 Jul 2026 20:41:49 +0800
Message-Id: <8b79ddc3311e1dc32b150b7efbaed5a187ee5ccd.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F4E380008
X-Stat-Signature: w17h4xafmc1fge1d5rwtggajhgp1ct6w
X-HE-Tag: 1784205890-129598
X-HE-Meta: U2FsdGVkX1/e8J//JcAtpjdKH25JrIDkJxy/UYy4/zyF/+taIfpBMegw6aSheA086oMa+i0SuU3RUbuwsxrpvzuh4WEAQ8TiSaOqKQ70qz9p++zY9zMIgii+iz06be3cJGy+ddWZykECUxsDiYrnBPblkpJcknsP4Rf/uHbMTTGQHBL/Nk/U7QoFJqHWLH8emDgNpaQ5eJ7bCQvYT8ftH6QlSFJLHSpVTjXQyiTpP9l9rl74DunSjsSUROnVAOSp6PFsCfUa27a8NtMC8rNS9aOQG24cO6rHgoE2qSOhkTE3QKbXzhr/69KZkxeESaGeM9lWo0gXgFBmNNXMIrPIGkD1y3zTsQa9II43GTNyiOLmIhS7RRGSGGMEa2E/5NLiThSJV4wlrdQjEtxzFKoprG9ML0+mqd+XRbGiDYNYkWlp/uuMmeGl1pYZd0kr+GU+7s6J011SbPKi9D+/M83BTVpDcZiQMl2dizo1GsbRI4CsFEeauQt0PpIIUETuQ+JzXu4x0fl5P59LECvL//F0+ZBsvEb5K6bQwqKcVyftxbJCL5KqurHYijjxY/k7hajfbV+KXunXE1oQlz8ezOuOmRTuVJcJnVSVk8wohYZKlOalqZcYZReO3XOv4I57gtEu63C1OvY1Taquu815WAETj0JDAsUmlyy0DxsMekfBJDj11jgYkK0hGRckBUPiu054a58aPwt98tO+gjM97BGH0H3Rt/pmPLmQPKJNEFm9W0aVPxkP8qxocPNyr0AsjyKasNxSHiEycKSFV++U8Vri/PtfXdJBhC6oGpDNDbTmtlSEsivjq4n45dloynDA3TfxARA+h1Ba1sx7ny9flmQ3gTpfWYhAhTmIe0kTSkiLVb4RK4cadbRIW0BWSYTJGpn/qWkW+c0UMhQnaMIaJc6Q7Gv1dnU3ntzsvZMpXRndDChYsyB7YGd5V8jNNrNzdn3V3BHJd9dDybqU5f+JQVW
 mU4pCwM6
 Hzw6gzewJt7jwkdE5O24pUhA0AG7sMen9ZNmSmE+bVMHXgJxETNfmqH/l0k6NmlXEQRbK9vN2af0/k7krHKTsxTix0ky3xaYNGLOkWD4Y9jQgaJrP5Aad5YbRqCo0Z41GHu36dXuc+iWp1rbnRcBquk0aKTzBp13NCm31FdCPwprgDto5IJUulQQ8hrC0l1a5QbKbRypVTBcCXqPKae0ECJ2AnQ8rsg0emsJhHsLNnC9Gtx5hxTlyENWBqpgRv88vNb/OGmxOH2Z4hWEDS6Knryx3IZViRDKR7C5Pn6E2BdUM5/7xtpp3eRq0rcK3o9mKC1+C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Svnapot represents a naturally aligned range as a block of base PTEs, but
generic mprotect() still processes a full block one base PTE at a time.
For a full-block permission change, that repeatedly clears and reinstalls
the same logical mapping and then has to reconstruct the folded Svnapot
block afterwards, making the operation unnecessarily expensive.

Use the batched protection transaction hooks to handle a full Svnapot
block as one operation. The fast path is restricted to user mappings
where hardware Svnapot is supported, the range is exactly one aligned
Svnapot block, and every sub-PTE is consistent with the block PTE. The
generic per-PTE fallback remains in place for partial, unaligned, special,
non-user, or otherwise inconsistent mappings.

libMicro mprotect median latency improves on the full-block cases:

  mprot_tw4m   (-l 4m   -w -t -f /dev/zero): 40.4 us -> 4.3 us
  mprot_tw128k (-l 128k -w -t -f /dev/zero): about 15-16% faster

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h |  8 ++++
 arch/riscv/mm/contpte.c          | 76 ++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 3727c148fa0fc..b546e6614c558 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -619,6 +619,14 @@ int napotpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
 				       unsigned long address, pte_t *ptep);
 int napotpte_ptep_clear_flush_young(struct vm_area_struct *vma,
 				    unsigned long address, pte_t *ptep);
+#define modify_prot_start_ptes modify_prot_start_ptes
+pte_t modify_prot_start_ptes(struct vm_area_struct *vma,
+			     unsigned long addr, pte_t *ptep,
+			     unsigned int nr);
+#define modify_prot_commit_ptes modify_prot_commit_ptes
+void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t *ptep, pte_t old_pte, pte_t pte,
+			     unsigned int nr);
 #endif
 
 #ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
index 8289f39d6e188..6a1156629d115 100644
--- a/arch/riscv/mm/contpte.c
+++ b/arch/riscv/mm/contpte.c
@@ -190,6 +190,82 @@ napotpte_is_batch_consistent(pte_t pte, pte_t batch_pte, fpb_t flags)
 	       pte_val(batch_pte);
 }
 
+static bool napotpte_can_modify_prot_block(struct mm_struct *mm,
+					   unsigned long addr, pte_t *ptep,
+					   unsigned int nr, pte_t *raw_pte)
+{
+	pte_t raw, pte;
+	unsigned int i;
+
+	if (!napot_hw_supported() || !mm_is_user(mm))
+		return false;
+
+	if (nr != napotpte_pte_num())
+		return false;
+
+	if (addr != napot_align_addr(addr) || ptep != napot_align_ptep(ptep))
+		return false;
+
+	raw = READ_ONCE(*ptep);
+	if (!pte_present_napot(raw) || pte_special(raw))
+		return false;
+
+	for (i = 0; i < nr; i++) {
+		pte = READ_ONCE(ptep[i]);
+		if (!napotpte_is_consistent(pte, raw))
+			return false;
+	}
+
+	*raw_pte = raw;
+	return true;
+}
+
+pte_t modify_prot_start_ptes(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t *ptep, unsigned int nr)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long ptent_addr;
+	pte_t raw, pte, ptent;
+	unsigned int i;
+
+	if (napotpte_can_modify_prot_block(mm, addr, ptep, nr, &raw)) {
+		pte = pte_mknonnapot(raw, addr);
+
+		for (i = 0; i < nr; i++) {
+			ptent_addr = addr + i * PAGE_SIZE;
+			ptent = __ptep_get_and_clear_noptc(ptep + i);
+			page_table_check_pte_clear(mm, ptent_addr,
+						   pte_mknonnapot(ptent, ptent_addr));
+			if (pte_dirty(ptent))
+				pte = riscv_pte_mkhwdirty(pte);
+			if (pte_young(ptent))
+				pte = pte_mkyoung(pte);
+		}
+
+		return pte;
+	}
+
+	pte = __ptep_modify_prot_start(vma, addr, ptep);
+	while (--nr) {
+		ptep++;
+		addr += PAGE_SIZE;
+		ptent = __ptep_modify_prot_start(vma, addr, ptep);
+		if (pte_dirty(ptent))
+			pte = pte_mkdirty(pte);
+		if (pte_young(ptent))
+			pte = pte_mkyoung(pte);
+	}
+
+	return pte;
+}
+
+void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t *ptep, pte_t old_pte, pte_t pte,
+			     unsigned int nr)
+{
+	set_ptes(vma->vm_mm, addr, ptep, pte, nr);
+}
+
 static inline pte_t
 napotpte_normalize_batch_pte(pte_t *ptep, pte_t orig_pte, fpb_t flags)
 {
-- 
2.39.5


