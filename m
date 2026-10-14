Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A70BCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51FEE6B00A3; Tue, 13 Oct 2026 23:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2086B00A4; Tue, 13 Oct 2026 23:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398846B00A5; Tue, 13 Oct 2026 23:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19B836B00A3
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:59:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89255C0408
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:59:36 +0000 (UTC)
X-FDA: 85319877552.04.3A1B13A
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7919F180006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:59:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Wwsy+n34;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791950374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaAy9NFbsaWAIqgLcyoOERlKyqqeQpYUYBxUTmvTMEc=;
	b=aJbZdzicJEI8fDKjM99RBx4zPcvv7o8yVuaIYV/6Lnv3agOcc0/9ikHcIcuXUlAPk/oMzl
	ASsQVVslc5OZJu7qHhC6pyiuT4xjOhTb2x/+X6LELiBJfU6JajpdRh9I/nO5MKwHwrqEVi
	ws/2tMFxL38MbsIS3P6dWgbyQkBJT48=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Wwsy+n34;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791950374;
	b=z+ktVJ/WsPIuzwr9LdYw9VLJuU6Zk5clgO7NWmeCrxGWqeri+MVQJ8hJdxeoB2AxsdDTdD
	9oJGRvVIMPMu+uRBExun2N3WmO84QegoYqB2sepjQqfKQCfYpkZRkT6KYh5PTSnhxtQsKf
	lrC9PGYAi1H5Rgz32t046Wb7bJrbD9w=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-ccc6b11a19aso1544020a12.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791950373; x=1792555173; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xaAy9NFbsaWAIqgLcyoOERlKyqqeQpYUYBxUTmvTMEc=;
        b=Wwsy+n34q7rQgoAJDbTe3PiE5hzDwboutE8YoifOohy4pbS2HTOiTxO9Yt8yJ0a06T
         +FBBuuHUh3Ks0p0ahJymunlfSe7l4Na/tquATqCucLCpML5bStOj0Wr4IZQWvtxuVjM9
         XZqhcRJAjphWh+lQnQcZ1CkQ9HTT+xsjMOn9JAzyVHLK3hoQBkfpphYtxLISfoR437C+
         Th/oWw705L3g+EbKrqe6JMvEA5meU6Qym9q5cDwUZBgvrw/qFtastddn5pUhD51Hp8YX
         No+4pn1etTy6sVL42NT80nTaYMLpiiKDbO/ZOBlQxDOjqIjAZAX+ZOGzfR0CpxVWsDeG
         ZVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791950373; x=1792555173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xaAy9NFbsaWAIqgLcyoOERlKyqqeQpYUYBxUTmvTMEc=;
        b=b/KT1vLMdsG1qudOwwPPJgQu9jarQZ/OLjDbwGs+DAVKlSVMMHlE70n3oFSvu0t1kb
         wgwZD5yIVoV+Uc1Gd7RjBJkd72wXOCDOi5NwCUaIowPInL4p+iw9F9g2wjn0LojkIol5
         Ojor30xKWOAA5GumRlCDNN1iprUzIfEiR6ostrqxhsuDpitq3Q/boIH9QdGWQ4C+8WfS
         UMtB/SPMIE9gEzlQo8I2v76VvfOvnCIbra56xI6aWV8Q9ikr9yiUAP4o/ArgO8Np3LxA
         ablUiZ3GeIJF12i/w/pLxZfthAaCw1Eir3DoQiK6CsLit1f2SBvcfO+RLMkzpMwFTmw2
         YbqA==
X-Forwarded-Encrypted: i=1; AKwUvByX4HqDKDwn4rWEZi17g2ToFRzTlQripEKIte1FPG3LR4VqFt/nnEYrIt6bUuzSQQgZJr+QBaaXDQ==@kvack.org
X-Gm-Message-State: AFq9FYK6VQe28VGb/k5xTi919LHsqqsUQJ20kecR/C1J46f+1//oudUI
	zjuDAr2NKomNMfFpbumDuHLno8GQBar8G9NF3j6MK9KoLtTS/vr21W6L1I1qwu8t468=
X-Gm-Gg: AYBFou0ljD2oKxkHT56RKPxZPfGwaXau4/UocfcFMAm2ngHaA1wdT2jobljiYnvGq35
	Q7VzZZOrSAgSLBmAy5Zyf0xNIz7L9j+fY8GTrE+zpopqTKMIiopYjLGgyIaljL5qkRA/KJjcl7P
	l0F/msYxeVsw0AdlctvXOXjell5pndm5i62P1wyVNUkB/EBaAems5FrRWd5k8ztrzudLAsNIdLY
	RCfzy0pWjW0l2+Kdl2JxPnu4hoNE0C++vuPXEpfFotVVjZ9wUZ1CRNTHUOt0TffeERo41zsQoZB
	pMoBFfGXGa2Al1afHPo5jTWZfcTFHeJfzxZL/JPtEcYovUByaYZSrKLnkRA3LPM4+pXe/b4jCjy
	HOWiW1Q/vYF/u0K4lm3iEfpS38tRYinM6srs3lZVEqvur4mOVOvEcv2A838EAAzoWzcwlU580zQ
	6jZcQJmKX40H8CCDmyECsztOptlPled1v+uWPegoM0vwvdrVo/L81jVnlZGjqJQ97TSIHInEC4k
	HmQLjYDNhEjGSA6AhDK
X-Received: by 2002:a17:90b:384c:b0:3ab:f38:2b43 with SMTP id 98e67ed59e1d1-3ab3ac86fbamr12973731a91.34.1791950373230;
        Tue, 13 Oct 2026 20:59:33 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f24a538sm2492305a91.9.2026.10.13.20.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:59:32 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mm: generalize PUD page table allocation
Date: Wed, 14 Oct 2026 11:59:10 +0800
Message-ID: <20261014035910.687847-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014035910.687847-1-songmuchun@bytedance.com>
References: <20261014035910.687847-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7919F180006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: pyosixjoh6j4qk1cdr4azrqsr5azfirx
X-HE-Tag: 1791950374-483307
X-HE-Meta: U2FsdGVkX1/ZhQdhCQHoN516X6htuH8mnOnw1mcnY2KQpS8z7Dxa9KEODAhuI2UFdeWHmplLSupb9IibFEfYMXuV4OVgXWBdxHru2ULbxIN84ZY7yV3nX3+AvrsgpAe5cWri4LNq/1+h7cb9SfVF9e0wxlOC5TdyJBFnWUD4vmklMPLYu3KQwWfo+1+r2Ziuy7yP4c91sSw2Ua5N8cG0FhRI07gOe0b9cSMKIqp851lM0mIBHkE8xcXGl2JtQMX3wHrUJkXeqBuZsgXB6GijwSflre5BmJyksRRmhB+48IRtMVQKI+dfJZQ8ROA9S4VUw1RaTvcTUSkD9qB3Bsx0CvRDgNScjiadgr31b7ToL31FC/ovat5//F83A/65kBLaj9epEUF+inv2UsFOYmKzXPykLkfaojX4LVBixy29c3kuw0R0WWUCZvRAQrCV4ivv5uj11uhmQL4TO5BeEJ2GV5cfBkP7sFD6yp+T9RAXkvX0eZGvLlwvlv+dn9hKXNGoW0YUpnFu9848mgWx+de0Qf4rwMutHTuST2BT9kNf04+E/XfH0Nk2DlJpd8hQIdip03ZCUhXA5xDkEHKyvS5kOOtKpfPhxlN3j+nM6Ox6p2oZeNHYnWfM2iCkNUCsxzmUA03IOZYgKM+4+WmYoQy+uYQ+NLrFk8HfKoRT7lUDTvRh3bte6wKnkCR7x4YoGAy3P3UnnLmUUzKDoMiEY9POc7VRcL6JBL6DpNnrx3cH03/PeSCoHNhOVdfjYgi8guzoiXMP6SiBPI+501MowrUfeALUAqmoxspb1KSzso/8Wpl1YFbSB25U3ZpSoKxSPIG+iya0+3ORrU0rLeO/EjFYC+CjPRnkcuCt/RKlPUPzvC+no0ExcdQOSODpATbWbeieoO0hsZXX07ydV7twJOB8o/z06JUSIMWKRqehZFUc0ytspG48pXF+uuKCru2Sd8v4s1z3s9qB8Vo6+TahlTX
 cTRK93ll
 IfeWW2oamxyxFRDj/WDx07j2vkTHp7AMOet9HB/iZSYrEvMxoXdh6SMcY91k9P6bICbegZIqnwITPTDMz1N0P8NG29mL09Bmt6B06PjwWF16DbhPdfdVQ0fj/yHPVmbC6/C2U7makPW7UOOcd2NhaXOoXYIbqpW9laC8073ABD6hpd+vAJ9Q0Qo2q7DN1ZJW7nNRuDe4DJ/y/eQroMvg5giQ+U7X1GFT77JuiqJ2eSMDE283VajOJkHukeHU04YJ3uwi53kCF2otTOnpa7GeMcCNyvjRHDRPthvHSKxuyoJela8R2JDLBWxUfYdDtdsK2jO1TtXK2LTSi/nzk9aM1Wc/sYETS3FoXuv5WnD24gEbPYx2YV3PcfS7XHkTtFQDCxQGuasXUkqV0i9OYUMLXH3gTiwXOQpm1h9h8Gwlsje7tIeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic PUD allocator assumes order-0 page tables and zero-valued empty
entries. MIPS and LoongArch need pud_init() to install their invalid
entries. MIPS also uses PUD_TABLE_ORDER to describe the allocation size.

Default PUD_TABLE_ORDER to zero, honor architecture overrides, and invoke
pud_init() from the generic allocator. MIPS and LoongArch can then drop
their duplicate helpers and use the generic constructor handling and kernel
ptdesc marking.

This also switches their user PUD allocations from GFP_KERNEL to
GFP_PGTABLE_USER, so they are accounted to the active memory cgroup
context. Allocations for init_mm continue to use GFP_PGTABLE_KERNEL.

Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/loongarch/include/asm/pgalloc.h | 16 ----------------
 arch/mips/include/asm/pgalloc.h      | 15 ---------------
 include/asm-generic/pgalloc.h        | 11 +++++++++--
 3 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/include/asm/pgalloc.h
index 1fc9a0751f19..06a36da302d3 100644
--- a/arch/loongarch/include/asm/pgalloc.h
+++ b/arch/loongarch/include/asm/pgalloc.h
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define __HAVE_ARCH_PUD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
@@ -51,21 +50,6 @@ extern pgd_t *pgd_alloc(struct mm_struct *mm);
 #endif
 
 #ifndef __PAGETABLE_PUD_FOLDED
-
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pud_t *pud;
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-
-	if (!ptdesc)
-		return NULL;
-	pagetable_pud_ctor(ptdesc);
-	pud = ptdesc_address(ptdesc);
-
-	pud_init(pud);
-	return pud;
-}
-
 #define __pud_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif /* __PAGETABLE_PUD_FOLDED */
diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 2f123455e363..4346802e283f 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define __HAVE_ARCH_PUD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
@@ -52,20 +51,6 @@ extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
 #ifndef __PAGETABLE_PUD_FOLDED
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pud_t *pud;
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, PUD_TABLE_ORDER);
-
-	if (!ptdesc)
-		return NULL;
-	pagetable_pud_ctor(ptdesc);
-	pud = ptdesc_address(ptdesc);
-
-	pud_init(pud);
-	return pud;
-}
-
 static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4d, pud_t *pud)
 {
 	set_p4d(p4d, __p4d((unsigned long)pud));
diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 68e473908758..cc8445e6078d 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -182,24 +182,31 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 
 #if CONFIG_PGTABLE_LEVELS > 3
 
+#ifndef PUD_TABLE_ORDER
+#define PUD_TABLE_ORDER	0
+#endif
+
 static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long addr)
 {
 	gfp_t gfp = GFP_PGTABLE_USER;
 	struct ptdesc *ptdesc;
+	pud_t *pud;
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
 
-	ptdesc = pagetable_alloc_noprof(gfp, 0);
+	ptdesc = pagetable_alloc_noprof(gfp, PUD_TABLE_ORDER);
 	if (!ptdesc)
 		return NULL;
 
 	pagetable_pud_ctor(ptdesc);
+	pud = ptdesc_address(ptdesc);
+	pud_init(pud);
 
 	if (mm == &init_mm)
 		ptdesc_set_kernel(ptdesc);
 
-	return ptdesc_address(ptdesc);
+	return pud;
 }
 #define __pud_alloc_one(...)	alloc_hooks(__pud_alloc_one_noprof(__VA_ARGS__))
 
-- 
2.54.0


