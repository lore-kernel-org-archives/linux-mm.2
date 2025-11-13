Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 071D1CD4F37
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91288E0029; Wed, 12 Nov 2025 20:47:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41168E0014; Wed, 12 Nov 2025 20:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45778E0029; Wed, 12 Nov 2025 20:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A8A058E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4AFD913BA81
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:17 +0000 (UTC)
X-FDA: 84103896114.08.F2EB5E7
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6838080004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=ftWlqXvM;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf30.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998435; a=rsa-sha256;
	cv=none;
	b=KxmD4IsmyxOqORcNZPcr9L2UvFbhIGP+JmyVnnw758dCl5+EkpIfHgU/F0MxaCLl5cwW9s
	S6YIhgEn5+9BcqCCUzGDqJIgBqfe+ySlRUcjtNZytUhw3BvNzomfj3I6G7jCMrQDrVuDet
	Kl8wLThxvWfsBxgBOWYckc/chJsEnW0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=ftWlqXvM;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf30.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onXS1ZyyTIk7E4Phjch+Gs0PpMpoB1JPFOZexalawi0=;
	b=Iq8/YnCT1A4tmq2yYvMIxZQma3vwOSV0a1ZXEUn1f7656tpx0L2pKAOV1P4AG0His/To2b
	xNFGNPbC+z+v76dyj9NeX6bTI1QD3ubsHsy4pQ3kKTZGfv+SfCe0iR1KltZxv/BU4+LXhC
	JTLnA0wr5zleBpqpzHpIFw6+eZimFS4=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7a9fb6fccabso209486b3a.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998434; x=1763603234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onXS1ZyyTIk7E4Phjch+Gs0PpMpoB1JPFOZexalawi0=;
        b=ftWlqXvMXubaboIB5PLTqqj7otV+T5JrLkVi356lj5nslFs97bI9hR+AmY5P7TbaRe
         bTCArKZ4i4u8uhIqSKs1O0xc0zU21ZlXdDbVXjxhgpHd2PmnJWMX2T7qaSSIO2Jmb8Kn
         4mRdcybDNvF7yVKJCgqVC46WAnLOLnEHzzIfN+hVPpd7eBxl33Q9AiCpaVAH72TiV5hz
         rlQKuA0TRXg2SGhKHJaBTw9HgSR+Z1gzthNxR5QBtVcJSPkNku++7eNvOF7Ci3L16s++
         2HfvZB4euj5YaGVvoGvQAAK6c4dYPKvFNQDop+BK1JKkUCbkly+6OXXZVhkue+umohVC
         II3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998434; x=1763603234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=onXS1ZyyTIk7E4Phjch+Gs0PpMpoB1JPFOZexalawi0=;
        b=r32ChwQ2DdfwIgepOoDWNnz6UdGpzNaV6+kygijHoCOmiPuj/n/8S4x3dIW93eUL5C
         /OkDv1xxAd+bCIiUrqvJ35hFZg2GVcTHoAkMBwId/7oZH6xNEPbE9Y8WEpXiVkyzEza6
         iB6WlrCPzRseatNT0AiNpQ6KhS/TeBUb+GtD/JuRFjzDt0o5+nblZqxOBXufooPgVYf2
         taG7+6YDHCQe0MtV3vtBtwwD6OPwzAW/p6MCKsMcFs+0Tm4Q5CAAaLdB9lbpPE4oY1p0
         KP4/fu5hFV1i6H+r5mFbDU1QHNsOiEChtcjnU7FEA8bpGwfUdjyArkq7S+SEXTL4/mud
         GjLg==
X-Forwarded-Encrypted: i=1; AJvYcCUy3w8wDZsQk7sy37I5iejfa7EK0LDSVbqmjEbE5RtiUv0q2qMhs+ikbBDwC61ZQinjZrFJ7K6NWQ==@kvack.org
X-Gm-Message-State: AOJu0YxmRlIx+Nj+TnSmxxGsAy9JWp8CCh9m4rNR0YcgpoDpNwHJo0xB
	uhlx3jA27HGsMafRW1rwgZbT3CzNLsjVqg6O9VIEDPj6rtXkJwBJxQV1TKyr8V6W0cU=
X-Gm-Gg: ASbGncu3M1XS5Jy1lOKe8pmjfH2Vg2ttJqXDqn+HWD/m8nWMCs5Nw5/UMhNjBAnLY2v
	9sbDsKQ4rYsv7i2Qjg5EArKlv1j6B0+zxV6Mrv9/TnvoR/VzhgdG/w7mUozfLCBIm172DMWgRVV
	eH/k0tFSRth3OptQ3KWWbDLR66EDVb7w3bG8IV5AUfVQXRmZpvlWsTOMSjNWOO7V56hHgye0V5q
	dBRg3YEVaRmQNFpcGkJRRMdaYGOLOCuMecohc5/NJXBYkjuVapw3+NxchSWHvakvNiP5SMb7ay8
	FWGIrmyDu8n6dhy5/Mjgbrieayswd+rr1OBojDqWUrkSy05efSG4MdNC72ZWJqcqc6UrRG2IV4q
	24Vux6sfFYLboWm0D8KhEK6rLpqAknD+0YMqqvOW8e3CtQHHo0sKlrFWBhopZGoEHcNNNp8Rvu4
	HqSjk8t+B7KOSszveIf8dnEA==
X-Google-Smtp-Source: AGHT+IEPUQpGJSnlpoH1wKnMxfvk73znW6zYh27mDLEJKnxaxWn+hw/P1W+C7Nu+pbcglz2Jny/U/g==
X-Received: by 2002:a17:902:cccf:b0:297:f8d9:aad7 with SMTP id d9443c01a7336-2984ede5755mr62262705ad.50.1762998434336;
        Wed, 12 Nov 2025 17:47:14 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:14 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 10/22] riscv: mm: Always use page table accessor functions
Date: Wed, 12 Nov 2025 17:45:23 -0800
Message-ID: <20251113014656.2605447-11-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6838080004
X-Stat-Signature: uuzf971z9yzsdgg5zb3ks9t7uf67a35k
X-HE-Tag: 1762998435-399092
X-HE-Meta: U2FsdGVkX18cyahQZac/q1yViP4nfrz5LkSzw77DjsylsJnbKd+7TmHZ6EpIIcCS7GZFSiOHyjwgIerqHn4srMYQgFrmm6Y5GdWTrFZ0xI5+/zxszzwaxxxouekr+flKYPO4MH4OlRZ8qaJYsjvq5/vKqM7Lp/FSEIP9jkZYXC+n8blDASz9WoCgJXy10QDp49TH2APZff4rhMwTCnBzneZ4h2oaPBn5cSG1Bv+OfkKf0IxIj8MYy1qBmviwLu16yKvphpG8ExILHgfw6YqBi/udOQZ1xInvWFJFz7/CQ4LnKXxLDLM6HbNisoInfu7xlWgfXxT692uHjUQYdbs/G9XJ26iBfjEzWdaPcJkrgXOAp8spHN7JF7d7j2cAQZ0mBMGzoj2fjJkoTrNASlEJAvvRBhtA9THW0PqPIVSpowjMxu9RnaAqrnDZzKrlo3+Ju0fp66YdKlOvCO8yIt1ZStQ7VJD/1USULADlXRgSg1izXC6yowzm3ZZ+gGS9pLkBPTOfnAmPNTXCf5pywpndjyc6ZGMxFUI3FVn2t/Aj2QNeF0crXGQr+D6BWg2d53aA5EkVQuVGsJzeBQsOrDjqB0LqSXCaIp2W8FyK31MLYVo3FgtMnbdumyKrCY1bk9HcotmxGCStKLUCALBfXKBc72fdN25zMF0aKNDdu/0wROQ5rqcJhGVsj6uQJuFhSHQGygCa9mEaByUAlu6DO+3G87LbYwO8UH2UKp7R98MTBKfeY6QGclfCNTJsXju964fdbNbfsNrlPOYKVk1B3qLMFI76TQFEPqh607xGPlchwzn55ZUqPvUtBqrWUnRItbr14JQGNclicrYhvTmF1nhDLlLRDR/PbhioivZNfLoqWytu0oPXxP9mbXVyy+kvL8rKnWEe6I02VbPkTkzaaTe2CBGNevMtRhLcWGhyA23Zxt9P5TKthT9NKZyqCk62IbVG2pcb/NZ0cImhCtrsfqc
 TrQ5HbU1
 UKg3KkxMi2fN909IQNtd9wbcOlPRSh+Nzumd+KfWQXarjaFT1qEWEjFgRvp3SuE6ZzDRhLBC/a/Ucb/hDJlNnFtKntl0U5WgwGznVdXAiV9W8H5qIIjhbJiXHGPrzCr9FFLXVGVVf/uLnxtVFq5NxbGWzMiDmOFJrG3F7W06eayxAJf3mRcWoQIDYq2pj/6yaH1ki+hCKboDxMaVfXPvAzW1SY/3rrMkiIHAb0EBvjyPN20+HNLTFp4WomG7tpBvncWpnt3jOGW6p74A5SLN2E6TD51H1MlUeFHUiTbK1TPfIWbYw7vRfbRmdl8SVTvqK/f37Ay0hwG47/aGWxBhor/CctQ+mTxQK01YQcaLcjxuT1/wltyIIvjgNLNQJCYErHvKUoXb9FfVmfDGbFPmCpPGrgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the semantically appropriate accessor function instead of a raw
pointer dereference. This will become important once these functions
start transforming the PTE value on some platforms.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v2)

Changes in v2:
 - New patch for v2

 arch/riscv/include/asm/pgtable.h |  8 ++--
 arch/riscv/kvm/gstage.c          |  6 +--
 arch/riscv/mm/init.c             | 68 +++++++++++++++++---------------
 arch/riscv/mm/pgtable.c          |  9 +++--
 4 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 5a08eb5fe99f..acfd48f92010 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -952,7 +952,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 #ifdef CONFIG_SMP
 	pud_t pud = __pud(xchg(&pudp->pud, 0));
 #else
-	pud_t pud = *pudp;
+	pud_t pud = pudp_get(pudp);
 
 	pud_clear(pudp);
 #endif
@@ -1129,13 +1129,15 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
  */
 #define set_p4d_safe(p4dp, p4d) \
 ({ \
-	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
+	p4d_t old = p4dp_get(p4dp); \
+	WARN_ON_ONCE(p4d_present(old) && !p4d_same(old, p4d)); \
 	set_p4d(p4dp, p4d); \
 })
 
 #define set_pgd_safe(pgdp, pgd) \
 ({ \
-	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
+	pgd_t old = pgdp_get(pgdp); \
+	WARN_ON_ONCE(pgd_present(old) && !pgd_same(old, pgd)); \
 	set_pgd(pgdp, pgd); \
 })
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index b67d60d722c2..297744e2ab5d 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -154,7 +154,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
 		ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
 	}
 
-	if (pte_val(*ptep) != pte_val(map->pte)) {
+	if (pte_val(ptep_get(ptep)) != pte_val(map->pte)) {
 		set_pte(ptep, map->pte);
 		if (gstage_pte_leaf(ptep))
 			gstage_tlb_flush(gstage, current_level, map->addr);
@@ -241,12 +241,12 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 		if (op == GSTAGE_OP_CLEAR)
 			put_page(virt_to_page(next_ptep));
 	} else {
-		old_pte = *ptep;
+		old_pte = ptep_get(ptep);
 		if (op == GSTAGE_OP_CLEAR)
 			set_pte(ptep, __pte(0));
 		else if (op == GSTAGE_OP_WP)
 			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
-		if (pte_val(*ptep) != pte_val(old_pte))
+		if (pte_val(ptep_get(ptep)) != pte_val(old_pte))
 			gstage_tlb_flush(gstage, ptep_level, addr);
 	}
 }
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index d85efe74a4b6..ac686c1b2f85 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -459,8 +459,8 @@ static void __meminit create_pte_mapping(pte_t *ptep, uintptr_t va, phys_addr_t
 
 	BUG_ON(sz != PAGE_SIZE);
 
-	if (pte_none(ptep[pte_idx]))
-		ptep[pte_idx] = pfn_pte(PFN_DOWN(pa), prot);
+	if (pte_none(ptep_get(ptep + pte_idx)))
+		set_pte(ptep + pte_idx, pfn_pte(PFN_DOWN(pa), prot));
 }
 
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -542,18 +542,19 @@ static void __meminit create_pmd_mapping(pmd_t *pmdp,
 	uintptr_t pmd_idx = pmd_index(va);
 
 	if (sz == PMD_SIZE) {
-		if (pmd_none(pmdp[pmd_idx]))
-			pmdp[pmd_idx] = pfn_pmd(PFN_DOWN(pa), prot);
+		if (pmd_none(pmdp_get(pmdp + pmd_idx)))
+			set_pmd(pmdp + pmd_idx, pfn_pmd(PFN_DOWN(pa), prot));
 		return;
 	}
 
-	if (pmd_none(pmdp[pmd_idx])) {
+	if (pmd_none(pmdp_get(pmdp + pmd_idx))) {
 		pte_phys = pt_ops.alloc_pte(va);
-		pmdp[pmd_idx] = pfn_pmd(PFN_DOWN(pte_phys), PAGE_TABLE);
+		set_pmd(pmdp + pmd_idx,
+			pfn_pmd(PFN_DOWN(pte_phys), PAGE_TABLE));
 		ptep = pt_ops.get_pte_virt(pte_phys);
 		memset(ptep, 0, PAGE_SIZE);
 	} else {
-		pte_phys = PFN_PHYS(_pmd_pfn(pmdp[pmd_idx]));
+		pte_phys = PFN_PHYS(_pmd_pfn(pmdp_get(pmdp + pmd_idx)));
 		ptep = pt_ops.get_pte_virt(pte_phys);
 	}
 
@@ -644,18 +645,19 @@ static void __meminit create_pud_mapping(pud_t *pudp, uintptr_t va, phys_addr_t
 	uintptr_t pud_index = pud_index(va);
 
 	if (sz == PUD_SIZE) {
-		if (pud_val(pudp[pud_index]) == 0)
-			pudp[pud_index] = pfn_pud(PFN_DOWN(pa), prot);
+		if (pud_val(pudp_get(pudp + pud_index)) == 0)
+			set_pud(pudp + pud_index, pfn_pud(PFN_DOWN(pa), prot));
 		return;
 	}
 
-	if (pud_val(pudp[pud_index]) == 0) {
+	if (pud_val(pudp_get(pudp + pud_index)) == 0) {
 		next_phys = pt_ops.alloc_pmd(va);
-		pudp[pud_index] = pfn_pud(PFN_DOWN(next_phys), PAGE_TABLE);
+		set_pud(pudp + pud_index,
+			pfn_pud(PFN_DOWN(next_phys), PAGE_TABLE));
 		nextp = pt_ops.get_pmd_virt(next_phys);
 		memset(nextp, 0, PAGE_SIZE);
 	} else {
-		next_phys = PFN_PHYS(_pud_pfn(pudp[pud_index]));
+		next_phys = PFN_PHYS(_pud_pfn(pudp_get(pudp + pud_index)));
 		nextp = pt_ops.get_pmd_virt(next_phys);
 	}
 
@@ -670,18 +672,19 @@ static void __meminit create_p4d_mapping(p4d_t *p4dp, uintptr_t va, phys_addr_t
 	uintptr_t p4d_index = p4d_index(va);
 
 	if (sz == P4D_SIZE) {
-		if (p4d_val(p4dp[p4d_index]) == 0)
-			p4dp[p4d_index] = pfn_p4d(PFN_DOWN(pa), prot);
+		if (p4d_val(p4dp_get(p4dp + p4d_index)) == 0)
+			set_p4d(p4dp + p4d_index, pfn_p4d(PFN_DOWN(pa), prot));
 		return;
 	}
 
-	if (p4d_val(p4dp[p4d_index]) == 0) {
+	if (p4d_val(p4dp_get(p4dp + p4d_index)) == 0) {
 		next_phys = pt_ops.alloc_pud(va);
-		p4dp[p4d_index] = pfn_p4d(PFN_DOWN(next_phys), PAGE_TABLE);
+		set_p4d(p4dp + p4d_index,
+			pfn_p4d(PFN_DOWN(next_phys), PAGE_TABLE));
 		nextp = pt_ops.get_pud_virt(next_phys);
 		memset(nextp, 0, PAGE_SIZE);
 	} else {
-		next_phys = PFN_PHYS(_p4d_pfn(p4dp[p4d_index]));
+		next_phys = PFN_PHYS(_p4d_pfn(p4dp_get(p4dp + p4d_index)));
 		nextp = pt_ops.get_pud_virt(next_phys);
 	}
 
@@ -727,18 +730,19 @@ void __meminit create_pgd_mapping(pgd_t *pgdp, uintptr_t va, phys_addr_t pa, phy
 	uintptr_t pgd_idx = pgd_index(va);
 
 	if (sz == PGDIR_SIZE) {
-		if (pgd_val(pgdp[pgd_idx]) == 0)
-			pgdp[pgd_idx] = pfn_pgd(PFN_DOWN(pa), prot);
+		if (pgd_val(pgdp_get(pgdp + pgd_idx)) == 0)
+			set_pgd(pgdp + pgd_idx, pfn_pgd(PFN_DOWN(pa), prot));
 		return;
 	}
 
-	if (pgd_val(pgdp[pgd_idx]) == 0) {
+	if (pgd_val(pgdp_get(pgdp + pgd_idx)) == 0) {
 		next_phys = alloc_pgd_next(va);
-		pgdp[pgd_idx] = pfn_pgd(PFN_DOWN(next_phys), PAGE_TABLE);
+		set_pgd(pgdp + pgd_idx,
+			pfn_pgd(PFN_DOWN(next_phys), PAGE_TABLE));
 		nextp = get_pgd_next_virt(next_phys);
 		memset(nextp, 0, PAGE_SIZE);
 	} else {
-		next_phys = PFN_PHYS(_pgd_pfn(pgdp[pgd_idx]));
+		next_phys = PFN_PHYS(_pgd_pfn(pgdp_get(pgdp + pgd_idx)));
 		nextp = get_pgd_next_virt(next_phys);
 	}
 
@@ -1574,14 +1578,14 @@ struct execmem_info __init *execmem_arch_setup(void)
 #ifdef CONFIG_MEMORY_HOTPLUG
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 {
-	struct page *page = pmd_page(*pmd);
+	struct page *page = pmd_page(pmdp_get(pmd));
 	struct ptdesc *ptdesc = page_ptdesc(page);
 	pte_t *pte;
 	int i;
 
 	for (i = 0; i < PTRS_PER_PTE; i++) {
 		pte = pte_start + i;
-		if (!pte_none(*pte))
+		if (!pte_none(ptep_get(pte)))
 			return;
 	}
 
@@ -1595,14 +1599,14 @@ static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 
 static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemmap)
 {
-	struct page *page = pud_page(*pud);
+	struct page *page = pud_page(pudp_get(pud));
 	struct ptdesc *ptdesc = page_ptdesc(page);
 	pmd_t *pmd;
 	int i;
 
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		pmd = pmd_start + i;
-		if (!pmd_none(*pmd))
+		if (!pmd_none(pmdp_get(pmd)))
 			return;
 	}
 
@@ -1617,13 +1621,13 @@ static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemm
 
 static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 {
-	struct page *page = p4d_page(*p4d);
+	struct page *page = p4d_page(p4dp_get(p4d));
 	pud_t *pud;
 	int i;
 
 	for (i = 0; i < PTRS_PER_PUD; i++) {
 		pud = pud_start + i;
-		if (!pud_none(*pud))
+		if (!pud_none(pudp_get(pud)))
 			return;
 	}
 
@@ -1668,7 +1672,7 @@ static void __meminit remove_pte_mapping(pte_t *pte_base, unsigned long addr, un
 
 		ptep = pte_base + pte_index(addr);
 		pte = ptep_get(ptep);
-		if (!pte_present(*ptep))
+		if (!pte_present(ptep_get(ptep)))
 			continue;
 
 		pte_clear(&init_mm, addr, ptep);
@@ -1698,7 +1702,7 @@ static void __meminit remove_pmd_mapping(pmd_t *pmd_base, unsigned long addr, un
 			continue;
 		}
 
-		pte_base = (pte_t *)pmd_page_vaddr(*pmdp);
+		pte_base = (pte_t *)pmd_page_vaddr(pmdp_get(pmdp));
 		remove_pte_mapping(pte_base, addr, next, is_vmemmap, altmap);
 		free_pte_table(pte_base, pmdp);
 	}
@@ -1777,10 +1781,10 @@ static void __meminit remove_pgd_mapping(unsigned long va, unsigned long end, bo
 		next = pgd_addr_end(addr, end);
 		pgd = pgd_offset_k(addr);
 
-		if (!pgd_present(*pgd))
+		if (!pgd_present(pgdp_get(pgd)))
 			continue;
 
-		if (pgd_leaf(*pgd))
+		if (pgd_leaf(pgdp_get(pgd)))
 			continue;
 
 		p4d_base = p4d_offset(pgd, 0);
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index 8b6c0a112a8d..c4b85a828797 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -95,8 +95,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 	flush_tlb_kernel_range(addr, addr + PUD_SIZE);
 
 	for (i = 0; i < PTRS_PER_PMD; i++) {
-		if (!pmd_none(pmd[i])) {
-			pte_t *pte = (pte_t *)pmd_page_vaddr(pmd[i]);
+		if (!pmd_none(pmdp_get(pmd + i))) {
+			pte_t *pte = (pte_t *)pmd_page_vaddr(pmdp_get(pmd + i));
 
 			pte_free_kernel(NULL, pte);
 		}
@@ -158,8 +158,9 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		      pud_t *pudp)
 {
-	VM_WARN_ON_ONCE(!pud_present(*pudp));
-	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
+	VM_WARN_ON_ONCE(!pud_present(pudp_get(pudp)));
+	pud_t old = pudp_establish(vma, address, pudp,
+				   pud_mkinvalid(pudp_get(pudp)));
 
 	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
 	return old;
-- 
2.47.2


