Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86C2606A335
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 08:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=VwqbbILO
Received: by kanga.kvack.org (Postfix)
	id 833616B05B5; Fri, 30 Oct 2026 04:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80AD36B05B6; Fri, 30 Oct 2026 04:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721D86B05B7; Fri, 30 Oct 2026 04:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49F1E6B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:38:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFD96A04E3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:38:31 +0000 (UTC)
X-FDA: 85378641222.27.B998688
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 727FEA0003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:38:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VwqbbILO;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793349509;
	b=fjmuZRivlwF6lJK15m8HNzEtSvAP3kOvrgKL0suV1BsUtuPdw22+ctCnw0vF4fTNmAiRrw
	PqYYo80IqqLSkbG3VN+Np/Ru7bC1FXJU7tP/TZdrJOJ28HNlWfHsAogOaHrtb255bgqMgL
	W8CY8QFgOZnGDnJkIYUc3GZeuHz+hnA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VwqbbILO;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793349509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNSWkSKbXy4yqbi1F/NqpsveYsUGyKJhJ7RGmrJoCBE=;
	b=O7rL8zRwSCQo273Z/UzgZCQfOWlDrcEYB+7hxgPWOjeef4FCo07KKRUhscXO6RblNqhgfP
	GRcYD7hLhHPmypQpiT/sOCp/sqGJAnD6DBbK9iEuiS+obTfu5RqNS8bQTF6zbJ/eT2GY7P
	A97AjLt+CwqktlBOmR6o7ssxLf+LSRk=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ad787b79ffso268774a91.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793349507; x=1793954307; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kNSWkSKbXy4yqbi1F/NqpsveYsUGyKJhJ7RGmrJoCBE=;
        b=VwqbbILObSmwjgbu6pJWSbXT7ouddP2AQ2vLWdB9CcYu4FVXIGl1ctcxZhFCVDMZbD
         Cx2x87u7FHiUJcfVGAvixeujUHeoEHxcPJ/jCPltqtwretw9958bNOolPyKgH9/wfIZi
         VMolNf6DFiNmoW0G79mST+ll39tgRNa7wkbgD+6DCGjtfeCgHpyMb1ZmUfPYMX3ZaAWz
         FLU8u2MrwZvXw5jj0jyId3HtOfx7sFFWse4MDwDmYXo16De3d2lVgaG87JgWeeLzFmw/
         ZHwF2UoQOertqgFMhhILGsCygVi+3iNqd+xQljFONjmlYg1LGssFgXGkGD7hlGapqz2Y
         fZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793349507; x=1793954307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kNSWkSKbXy4yqbi1F/NqpsveYsUGyKJhJ7RGmrJoCBE=;
        b=GYZyNhFl6DeVg1sld80JLryo38y0g06qQqPIzIwGO0QUnh8G4e4VwWlZWZmRnL6eQ5
         Krve+UHqTxcxyXu65d/crRK6GG1duZJElAATNzwvdia+NRgShreAGc5pbpBL1/eaiQpJ
         GW2aZA7EFVbON+VVZfuKrlL3FaViyJ2m8cLzsjY9V1zD9qj3VoIqXebOTpYCvW4ra9DJ
         6In1Jl+HkvV148FXaZJ0NtFwMKi2iJhwv6NEl+qWKR+eCetzE0O6kLCe8qsjkKX0pBKz
         muoYi4Nv4eA8OicJ3rInPuqLpXAjA1Nh2wP1ya+pCy9bDcmgZpONWUzR72jRgE6BcPF9
         0i+A==
X-Forwarded-Encrypted: i=1; AKwUvBzYF0yAq+kaDfLnNjn3Dh/9sRJ6YTVgvbllE2hVNuptY9eTtbRmZaC5776ar7MBMpM9Y5Bn3aed7g==@kvack.org
X-Gm-Message-State: AFq9FYLjlTeykMtLFG/lV8cKBJhTzt65LUImrYKsnMDKuL4ymzAcy96R
	dUqlWlHAZdCupWlbOsxT9aw1Bl3PVsn+vPZsFB3ySIRpM59jbgw1UV1ShK6joLF52DU=
X-Gm-Gg: AYBFou3EXNfQLW0J+vua6G2RWwbkGYlecdP7R2kHAHcH3M+fsBCyVSVMmpclAgMOYtK
	5+ab2p5RWbkKeJ6OCIiScvy3vbGLUrW4F9DCta0/lIurvDQBexsAeV1zwN0XV7S9YnO8mknB4oz
	oK12Ntjuj/JMJeNEGFvj/XjHHK6tH2dvlV2MYWISHUpPbCT7ukI3kQUFO/prTNqqncJ58zfDG5d
	3KOk+5d2EoHSXXsBX5cPsOT0lsO3SPmLUmvfJFd9Vut89YHJB8+afueySoX9maKtTKpYfZlUHZx
	AzK3knpIGoeSF7Zp8sFvbK42nzmDR3X2LgCKQG6VIQ7w37jqBz2BD8lTnO8iXoSlud60x/ogZq2
	P8N2Dsni7FFMWF1Si94QPDT0MZeesuOf/9a9m1arXL5yHXZ7d3mof707OEmHEqbvEfKbTalEmWy
	xR/Ji+xUX0VqPsZQKllxpMzwlUJlsNP+w0YyJLZnMDKnBur14s74eu+jqYrLAcXD1L58NRzi/AB
	UojNawDmlvVUncqWABzwgcnzCDWdQeq9rVAjiELkzbsUm33r+RXQj8eHhGGicuqug5G4pQCVEoG
	BKwxdDGradYIsbALBw2Xdi99PK9Y6P8i1jzMfeUTl6t7DR7/vv4=
X-Received: by 2002:a17:90a:e70c:b0:3ad:a232:4044 with SMTP id 98e67ed59e1d1-3ae8979969fmr1091626a91.38.1793349506870;
        Fri, 30 Oct 2026 01:38:26 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9b1506sm7542122a91.15.2026.10.30.01.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:38:26 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Alistair Popple <apopple@nvidia.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 2/2] mm: remove redundant pagetable_dtor() calls
Date: Fri, 30 Oct 2026 16:38:00 +0800
Message-ID: <20261030083800.599152-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261030083800.599152-1-songmuchun@bytedance.com>
References: <20261030083800.599152-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yiwt9f65r9r4itnmezkd4n5ky1oghk5b
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 727FEA0003
X-Rspam-User: 
X-HE-Tag: 1793349508-733768
X-HE-Meta: U2FsdGVkX1/OKngGABueIB+n/UcrWTEz/zqYZCBNo+3ea+DBufm6uRAjQzS6OZUH8il4k7Julf3cFHGPx+I9lBkcHVEaOEM29QxAU3+9u5ThGDfAgIn4Vp3RKunKlHRzBv1q9hYyfNMq9wbcab7++k1fXc4d4PIg9T04Zh3U/lAefUMzLu2rSNb3Y1zcvk8SbSTdQUhtj1hfZ3BPOkg6NPLzUZVrkMiIs+LQsNo+vW97Wzi69JUw+WNinHNF2yu8qbyzqoTpl7FgYMfqc5aLtCB5KZa3I2tlkvA5U9gGEAwlYFElWQOtQ9IOlPBgqpRtBt3mOR1gL2i2Y8QTOua/dI24tLNbnuuvQUF7T16EyTjx3LnZK8mhEaM6tgdvOUwI9ZaMIPFm3uQJ9qlvrHDzhgoLH+HMdbJyv7QARlYjab5R16pwHQOLklDxpXdiMbNNs1LpemxANv9UqJqMahT1i7plL58Pgkmf1KV9NNxvUwcjZVxS1oZ0sgNXxrp4LpAYDz0qEQOZcVKpnXKnUaPIvuw3dfur5Ix0WgIfjjdhPEOJ0bzzNWfj1lcHiCU9li2ePP9iEn/bypsYBDt8hsQf4k+2JT5XTlJGoh4DBRwQzT3DiH8lNC8NJ3fHfokinYI0uHUT4tb1lgpxE2MpaGijLonqLR2YD3CQ9Ga0U/rC5ccX0bFoou/830s6frA4pyLaLIbjkxCXrl9YENyyEOJ+bQyQq16ktm2DY1foWwp3e9Bqg8wpOmavZwWN28lpKCSnjaFt9onuBSZGqWHVbCGIXHoA4luhLq13xJ0n4Lk+dMZA4M6QfQ3J32vCbNMO/xWlX1pKnWj/KWPTQiGc3i5Th1fa7EmIvsX3yydP6nxgFQklIRbHwdthfs2eZpKwDvboxJfHUK6R+gJ5sm+s1cCSdA66RUEVXC2OS47u2Danv0RfLA4HY7td1UfWOovPm0Ex82aX/NEakct5idSzpIk
 bXtfuuPl
 46tc+isT1hJJiBB618ciqwQKGoeuTnvKPvACXalGnDqyftF8Ff9W0Tf0rLSyHD3/dOqi/Li1jrrlNL+R7IdJCIeP3YuUhwNcdNWNY0uJMCvl5gJHc8dW/9F9xCDwz+o8cThFFPsai6HaV+du4MF6CyfJHI3DDN/IvYUukZpLqMC308g6YWI/FhAkRkRWHBgmEp8TP02YUUqHVZ/k01I4RGmVNMSjzTRsqSfkLCwv6MMBc1eHjO4NTiFphcKd5EwphXbyHoSyZcShftpNT9LcQs4QjeZIh6dfDcBEknHzYcI2+4fU5ytWR/4c7t8g7eob5SPd2E2R6Rgxe9Q3KCiMk9wZr0BrpAez03TP9ms1sBsxgpRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

pagetable_free() now runs pagetable_dtor() for constructed page
tables. Calling the destructor immediately before freeing the page table
therefore duplicates the lifecycle handling at each caller.

Remove the redundant calls and let pagetable_free() handle the
destructor. No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/m68k/include/asm/mcf_pgalloc.h    | 1 -
 arch/powerpc/mm/book3s64/mmu_context.c | 1 -
 arch/powerpc/mm/book3s64/pgtable.c     | 1 -
 arch/powerpc/mm/pgtable-frag.c         | 2 --
 arch/s390/include/asm/pgalloc.h        | 4 ----
 arch/sparc/mm/init_64.c                | 1 -
 arch/x86/mm/pgtable.c                  | 1 -
 7 files changed, 11 deletions(-)

diff --git a/arch/m68k/include/asm/mcf_pgalloc.h b/arch/m68k/include/asm/mcf_pgalloc.h
index 27c3b91ac0b8..f607d239ce16 100644
--- a/arch/m68k/include/asm/mcf_pgalloc.h
+++ b/arch/m68k/include/asm/mcf_pgalloc.h
@@ -62,7 +62,6 @@ static inline void pte_free(struct mm_struct *mm, pgtable_t pgtable)
 {
 	struct ptdesc *ptdesc = virt_to_ptdesc(pgtable);
 
-	pagetable_dtor(ptdesc);
 	pagetable_free(ptdesc);
 }
 
diff --git a/arch/powerpc/mm/book3s64/mmu_context.c b/arch/powerpc/mm/book3s64/mmu_context.c
index 2fe787e6c2dc..36ce18e625cc 100644
--- a/arch/powerpc/mm/book3s64/mmu_context.c
+++ b/arch/powerpc/mm/book3s64/mmu_context.c
@@ -249,7 +249,6 @@ static void pmd_frag_destroy(void *pmd_frag)
 	count = ((unsigned long)pmd_frag & ~PAGE_MASK) >> PMD_FRAG_SIZE_SHIFT;
 	/* We allow PTE_FRAG_NR fragments from a PTE page */
 	if (atomic_sub_and_test(PMD_FRAG_NR - count, &ptdesc->pt_frag_refcount)) {
-		pagetable_dtor(ptdesc);
 		pagetable_free(ptdesc);
 	}
 }
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 85ab6723c8f2..4ff471775f2d 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -450,7 +450,6 @@ void pmd_fragment_free(unsigned long *pmd)
 
 	BUG_ON(atomic_read(&ptdesc->pt_frag_refcount) <= 0);
 	if (atomic_dec_and_test(&ptdesc->pt_frag_refcount)) {
-		pagetable_dtor(ptdesc);
 		pagetable_free(ptdesc);
 	}
 }
diff --git a/arch/powerpc/mm/pgtable-frag.c b/arch/powerpc/mm/pgtable-frag.c
index ae742564a3d5..2568bb514181 100644
--- a/arch/powerpc/mm/pgtable-frag.c
+++ b/arch/powerpc/mm/pgtable-frag.c
@@ -26,7 +26,6 @@ void pte_frag_destroy(void *pte_frag)
 	/* We allow PTE_FRAG_NR fragments from a PTE page */
 	if (atomic_sub_and_test(PTE_FRAG_NR - count, &ptdesc->pt_frag_refcount)) {
 		folio_clear_active(ptdesc_folio(ptdesc));
-		pagetable_dtor(ptdesc);
 		pagetable_free(ptdesc);
 	}
 }
@@ -110,7 +109,6 @@ static void pte_free_now(struct rcu_head *head)
 	struct ptdesc *ptdesc;
 
 	ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
-	pagetable_dtor(ptdesc);
 	pagetable_free(ptdesc);
 }
 
diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
index a5de9e61ea9e..d554c475c61f 100644
--- a/arch/s390/include/asm/pgalloc.h
+++ b/arch/s390/include/asm/pgalloc.h
@@ -66,7 +66,6 @@ static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
 	if (mm_p4d_folded(mm))
 		return;
 
-	pagetable_dtor(virt_to_ptdesc(p4d));
 	crst_table_free(mm, (unsigned long *) p4d);
 }
 
@@ -88,7 +87,6 @@ static inline void pud_free(struct mm_struct *mm, pud_t *pud)
 	if (mm_pud_folded(mm))
 		return;
 
-	pagetable_dtor(virt_to_ptdesc(pud));
 	crst_table_free(mm, (unsigned long *) pud);
 }
 
@@ -111,7 +109,6 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	if (mm_pmd_folded(mm))
 		return;
-	pagetable_dtor(virt_to_ptdesc(pmd));
 	crst_table_free(mm, (unsigned long *) pmd);
 }
 
@@ -144,7 +141,6 @@ static inline pgd_t *pgd_alloc_noprof(struct mm_struct *mm)
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	pagetable_dtor(virt_to_ptdesc(pgd));
 	crst_table_free(mm, (unsigned long *) pgd);
 }
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 9bbccb5d23a8..9f3cb7883f3f 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2840,7 +2840,6 @@ static void __pte_free(pgtable_t pte)
 {
 	struct ptdesc *ptdesc = virt_to_ptdesc(pte);
 
-	pagetable_dtor(ptdesc);
 	pagetable_free(ptdesc);
 }
 
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 81b3bb9a197a..9929d7d55d72 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -156,7 +156,6 @@ static void free_pmds(struct mm_struct *mm, pmd_t *pmds[], int count)
 		if (pmds[i]) {
 			ptdesc = virt_to_ptdesc(pmds[i]);
 
-			pagetable_dtor(ptdesc);
 			pagetable_free(ptdesc);
 			mm_dec_nr_pmds(mm);
 		}
-- 
2.54.0


