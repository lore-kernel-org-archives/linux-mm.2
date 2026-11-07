Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A16606A332
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WQ12olfY
Received: by kanga.kvack.org (Postfix)
	id 8519E6B05B1; Sat,  7 Nov 2026 08:50:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829806B05B2; Sat,  7 Nov 2026 08:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717F86B05B3; Sat,  7 Nov 2026 08:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 494B76B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:50:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9BE040399
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:11 +0000 (UTC)
X-FDA: 85408457022.21.B48F538
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 153E01A0007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WQ12olfY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yTgtDF6jEtnEd1/HsYlbR7LkWEKWDRmQNU783tsnwk=;
	b=QDvuFgvNXWHT+g5t04s1m97pzglNdrjYL/Zq60SNPD224ANcjJ+qCMuyXm7P7W7j9p/58v
	TC6fMlV0H1w/f9E7hVefTmdVO9vjJf55ZxqANTFfL3XAY88eXU1vCL6CSXQqlqw4LagBj5
	1yWi/YPF3un52nN1paGMWD24hy6zwVY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WQ12olfY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059410;
	b=eBvE3sJWpOJB2IhDSOg3wiEoJBM8cSiZEncC1Altg2PvsRiBbfQj2enPFIoamFrlsSeQec
	UPSOnukQL7XxWxv+gZyQR0vOT5D9QfWXzNC6QUFy6nUXwuKRJBbB9n+H7cFRRiCuOqS0tz
	yW9GBRsPstKDuS03rVYYBKB8SCT+PLw=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-37071c0f42aso2118517eec.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059409; x=1794664209; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1yTgtDF6jEtnEd1/HsYlbR7LkWEKWDRmQNU783tsnwk=;
        b=WQ12olfYIoRa6NhNp4smc+NQ1VqSD6uBch/5unhBj2OCwFMJnz1xa9/IQI0sJcRnQa
         WWQ6u1aioZsgsipuHrhSCz+nh1abmpIh+4NVT/k/FTJBTJ8Twy9EJ07knwxe5ss9oQPq
         b6Syu+iVNUsCcxRDWnuXFtghbwYAF/116q7cAe0+GXNt+SSNpc4ERAFtVSZWL4BQ3Q9o
         rU6EQjKZ7H5drLek+hH52GnJBS5I56aC6E9Fnj5w9UUslVr92gvu0AQMi4UzQAJFCLwO
         13/ZaapfOZnSpY1Gab2xrj8jGJio2QnGAvNQVd5VPiryhogJHxHVBtQkPTXk0xTJW72s
         c2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059409; x=1794664209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1yTgtDF6jEtnEd1/HsYlbR7LkWEKWDRmQNU783tsnwk=;
        b=nwtbS32l0Ql0+aSkprtS9aaH4NC7Kj43JbWLoaaTCavsAlnHWzI42uJWxGmBXDaCLG
         6x/EKSygKBvCpll1sSC2xFCPD7X2SCQxRpYhlI87k9vOFWvRgOkk9wU+MbSelgNxBDn1
         HnFx2vrfm/SCZF2jpPRyGTGhTKbTURd40NHvZKEgdK/kPkypvaoI0nMtOZOe7xX7AdIw
         RkNysr9tUM8Zuq4mjhDn7z1MYC1BhJfals0CV1l/JSir8JTv83myhlNZrYXaH6rAwnUy
         VUu4xkJ4tPfzUVhFtZ2nxtLD0LCp/E8q8I1d5IOB/MJYoG6VSXg+dO80Z7ig65neMegv
         2xBg==
X-Forwarded-Encrypted: i=1; AL+hErEwzzitqyQfHYY/JPdpSzSaR9vaMoJvuxK6xxNPL9FNX8nZIYDSoUV5Ql2tT4tHEFSaMzH6DCF/5A==@kvack.org
X-Gm-Message-State: APuU4Z+DpRjUsb4EF1xmkuWxPhKvqIGov9WFhI3P58abLae3F9BXRIVN
	wbBWQmlqhNcUz2qp4Mdlwo7+yc4tvuHlaXvjwwYwX4JYdWh/uRHWYjxi
X-Gm-Gg: AYBFou1cPrWXodGVtuKXhfBAbn55FOlIMPBrm7o4yo+XeAYfzBRs9Tj216Et+6iodEx
	ctcne/cekzq88zhUL3gWqKChZy2+YqHVZVakNy5yx7KNBHFqhi6dorxWDyrYse/WtXeEASXfF60
	AyZKzSb2TbaqeJ6OuS5iWhm9HglUcztqP6KPrr5ReMXhKNxGfC1iGl7QxB0MM9aufyCTlpX26CY
	3aCsliXxcC/SpGdSQs+BPrqXK380ElH1OIuQzN0fASjroubaOwfY1WpdhHLqRZyBrWST22i3nv4
	IqFsWXX/+4aIweY/02PdUexp9YIgJCGMHCsN2eJT4+dLC05mkkRa6JfyZrCNu7Rn1FG2N4a3Jmc
	ZOCI1MEUfEWvNPCnL0PHHgItllTt+Wz+jDT7YFDA/xUgpXNJzaKaYILHIzPVP643IiaK7OMUKK7
	NFOEtdCcXKarKwNZEmMWzYhIC1rl0y2rkCchI8+imHBIM34TsyyfuGmB1PMJvU4bb6s5rZy+adZ
	vzzXc3Sso9ApEceXnirMszodLFH8WDpAi0mLZFUCPR0GnxSaM8xPBDIaeGIhB/FR5qJjeHDNJ2d
	2umFHhLDbpNrqI9EUHx6aRczZ1WZnNpiiS2vrCoxzYChn9/N6NkyeUnGnA==
X-Received: by 2002:a05:7301:70b:b0:36d:4560:dd38 with SMTP id 5a478bee46e88-36f765216bbmr6889124eec.37.1794059408773;
        Sat, 07 Nov 2026 05:50:08 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:08 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 01/10] arm64/mm: add vmap_pte_set_huge() and vmap_pte_clear_huge()
Date: Sat,  7 Nov 2026 21:49:44 +0800
Message-Id: <20261107134953.748622-2-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 153E01A0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: u9r73wcm73ay39c371wu8rsgoqjffwkq
X-HE-Tag: 1794059409-415988
X-HE-Meta: U2FsdGVkX1+lKS3F+kzPrz+gJlgYEY390hvZI5fNmcWmENRqPRFLl6T97kO7K1Zp6ASzUHsmGAYJZwdKgOjpap553w03fbmuVnMPHRTmIQVszQDWEY+5oJXwimHy/Vq5LDitx3rAwVymlgjvwewEhoP+edzqHuBlhE3Gsc76Fr8gFJLTfGTe7lGpVnaWSxJdCDfHdOt/+oXECPHoqKI+mOXLADoyJOR1gdgP+u/IdXMab+dvzLgf7pXROJXcs42dCqsurzQ5RMLSzeuAojr8AC18RAxg1f9qCIOVDXgEEssiHdUBDO1wnpWhod2Aj+3WL3T9LjAtD+oVVHyKglrBgHaC2H53HFoKaq47Yx9EHy2vSEKe/Xu7mB6tjp1jvtCJ09pD0A5doVNy2P7LhpuCxVwKzIfj3LHTfkARveuGIjbhPb7A30TQ3aJzZPr8UXTEsbeynMQKZahe26+jqe7PTc8iPMDVVAVYKwOGr72omlEhi7mMmKi43Vg7GVFV6koIBiL4BGlCjOUA4fv/SszftoCowW3Wttm6IIFe39j5nYV0buIsQjoHLr6grgb6rQpbhpS/gpdyEhnwBA93F3S1hPF+qld2xJf1bAQmkdjYc91Me0I6FjK37zTayc/GZYB973MIeAv8S/TttxUrsRz3e4Asos+bj+AZK9AtSGMbERTFelh8ArfJBWavDRqZ8aiuOmwnsnvEX+s3peXrD+Au4B/x74r8MVgNFfZTnhkUkMyawfCltmjSa+ko+KF+f02bbS/I/D5PgkwN8de1VOulhPM/WXbRcQzg0GIscTe8fpgKDozlf8KpinMwCoYuUCRjrc21j8sB23L+zR3FPvMB8M5fWj0ofIEYv5EIHDw1tb1dM+3qvu5Vap9iJl2D1jIVyGS7xC9rl8RSqk7ZIQIc0zY4Jv6D4ujnJL7Vf+x5bcCmSovGqyN2FniWDt2sl9ZTq+0u/KycMZsl+NTM7b+
 Tm9UWi8/
 wny1aTbGIQJUQzS5bn+78eXKG3Zvwppj4Mmf/2sTbeehsIpSEl/Ho15dEVrwdksGeout4IYHI+FZrXocafOg22Hj5GignGIuscH0jIZUI0RamzWwZb7itnWM7Pf13IjSYxtlMRZkMbliyAZpIa0gdD65GozAS9nhjg8vKowLD+GIPblL/AjlAhaH96+MmZ+MgHd/E6yQ+ixhl0gGrjOqMCASvngMnKZXoP9CBBwD4vlJX1jGwy5rz3E+c9gdumi2cBmEXuUR8fjCsfqo+v1B21fQ4EdpkPAGTEWf0he16XElfix9VsbdUB9azqNL48VxzKdLc+ghLiwV9XVbnOsJ6kF6NkP5qliIz/lRYoCdfBet40ldY6XoSaGUeukNIuaZxGkELESPALZBuewy0R6rpWzM1TuPOGVw2e3kytP/ffb0L6vKS4O2oR9Ue9fjD4la0MuQHBuqpuVnk30nt0LEPlQRSLzcGfMFwfQ3Qc3WyUiDukpR8va/nit/A76unKr380W2Pb+whvHAiQIOgRckizJhdC1TzizkhKeBepcwgdHeHXFkn7jQIISdufQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
unavailable on CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to
HugeTLB internals it does not otherwise need.

Add vmap_pte_set_huge()/vmap_pte_clear_huge() to arm64, joining the
existing pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
__set_ptes() and __get_and_clear_full_ptes() directly, so they do not
depend on CONFIG_HUGETLB_PAGE.

There is no caller yet: mm/vmalloc.c is converted later in this series,
once the generic fallbacks are in place.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |  6 ++++++
 arch/arm64/mm/mmu.c              | 27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a474c9fb485ad..ce51c1b9be222 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1927,6 +1927,12 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
+#define __HAVE_ARCH_VMAP_PTE_SET_HUGE
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		       pgprot_t prot, unsigned long size);
+#define __HAVE_ARCH_VMAP_PTE_CLEAR_HUGE
+pte_t vmap_pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size);
+
 #endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_PGTABLE_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 140520b351e28..66b23c78f0951 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1912,6 +1912,33 @@ int pmd_clear_huge(pmd_t *pmdp)
 	return 1;
 }
 
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		       pgprot_t prot, unsigned long size)
+{
+	unsigned long pfn = __phys_to_pfn(phys);
+	pte_t pte = pte_mkcont(pfn_pte(pfn, prot));
+	unsigned int nr = size >> PAGE_SHIFT;
+
+	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
+
+	/* For vmap, there is no valid -> valid transition */
+	VM_WARN_ON(pte_valid(__ptep_get(ptep)));
+
+	__set_ptes(&init_mm, addr, ptep, pte, nr);
+}
+
+pte_t vmap_pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
+{
+	/* Kernel mappings only */
+	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
+
+	return __get_and_clear_full_ptes(&init_mm, addr, ptep,
+					 size >> PAGE_SHIFT, 0);
+}
+
 int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
 	pte_t *table;
-- 
2.34.1


