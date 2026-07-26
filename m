Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F897C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31626B0096; Sun, 26 Jul 2026 18:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B087D6B0099; Sun, 26 Jul 2026 18:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DE36B009B; Sun, 26 Jul 2026 18:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6936B0096
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA837C057A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:32 +0000 (UTC)
X-FDA: 85032355464.28.FB19ED9
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf07.hostedemail.com (Postfix) with ESMTP id 10A9740008
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ARlZJU0a;
	spf=pass (imf07.hostedemail.com: domain of 34YhmaggKCOYRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=34YhmaggKCOYRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIdD2acc/jIdSlYsMupzJ9xAswr0y0V2LMVp6mKkzVY=;
	b=RVOtja8yU5Xslk/8GriryLEhLGYU+DRu/4pWlrGkaMuFPAlGF1pZg97AkqRBSmgxlrHov+
	/jdUR9mQiMYCtANTHOeKs5TudO0A8AsE/AEOLTTxfI/Boyw/6mCOa2eWodgwJeRHJ/39h5
	dEsqCBHlnN3oPh3Xr58DqUHWRbbNyIU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ARlZJU0a;
	spf=pass (imf07.hostedemail.com: domain of 34YhmaggKCOYRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=34YhmaggKCOYRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104611;
	b=A5W32qFZC7KpVEG9DwmFIVPmrf+q8KXNokRx1LfzjzyTIUw3wEIQRNNenlV/xoHueFNwCQ
	d+V/vMM2WKbAy9uDaDfcoaE1nvrHPPebr78uTFIX4biixCQ0d5oCXzVUwy1kpTSmu8hxPq
	Cgeg1TTUdTN5+0qQ/jCv02YprP2gZPs=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-496b61bd846so11863175e9.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104610; x=1785709410; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cIdD2acc/jIdSlYsMupzJ9xAswr0y0V2LMVp6mKkzVY=;
        b=ARlZJU0awGkq6kPldMgH72ldc8NzvTOmU7fiohkJSQrm0h79F9k6efYUmdigOO1kXB
         EyyBcXPM9W5wsHdCYMpO4CCBuoh+nZ+CmzFsM+d5ZZQLjqGQ4iwRTDQp7xxjljdB4q3n
         4p+VDU6CJIKhC6RL6J8bpc0fHnd2GMQROZxCdxZewealPXb4W1L8Ejfi4dQIQFcl1Vzn
         AOL2ZPvsDV+y8BplVGBNLsi5qM1Go2IwGwYthrzZ7q0hQUYDw1BASXOHSCbG3mgbDyTB
         ZnQB799xwABfBgAI9VZHCDaYqJyRHFf6ZWReocZ1MieWbyHDlvxDI4YN2PfJm53PoVLz
         FhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104610; x=1785709410;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cIdD2acc/jIdSlYsMupzJ9xAswr0y0V2LMVp6mKkzVY=;
        b=aB+c7ojnz0710mjs8yuo2RWhvuBx5m3arW8yE1AzRra7Tz6UgDZH/H1JfqvoTtRTE7
         lgyTOJ7aJgkezgsny6bBWOMkdwGKmTSHCFiiqTBJKYIYspAikz81oPyWJKeCie3mOPT/
         d2v9lIjALeiVQCRCLPCQxEwQNWfSHltmP0XMZMA5prO1r27juKM8FVbYzmB9uh4zZAHW
         oKzSrwmt0Lx0k3NaKE/cYivJpRVMO1VN7wUMXBo4ZIv4T2pWAecYLJKCA1eJXUEaWOc/
         Ehx3DLOTzZVAUUSdSi/vEY2cd8Inj2fehYusPrWxBgaOp7kRqgHL4ayn/Aa1CIkyxJN/
         skcw==
X-Gm-Message-State: AOJu0Yy/QGKUjMpyFLutqoWg3sfSg7l6TvSZIs5wwU0+zQfCrtt33Jvm
	mIfvDu8zTRBD/0fk97dNSs9OA8k551Uy1WdgB4XDHPEpvsDeyL4VlRNB1E4eCGfCViI+sHeK4/V
	T/elJv9xWN6AGUg==
X-Received: from wmbe10.prod.google.com ([2002:a05:600c:590a:b0:493:ad14:710b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:820e:b0:493:e365:ace9 with SMTP id 5b1f17b1804b1-496b56e6603mr73573705e9.11.1785104609676;
 Sun, 26 Jul 2026 15:23:29 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:39 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-6-6f5729aa9832@google.com>
Subject: [PATCH v3 06/26] x86/tlb: Expose some flush function declarations to modules
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10A9740008
X-Stat-Signature: 8sqgss3ezhu1rwam4j6x33zoebf695gp
X-HE-Tag: 1785104610-497308
X-HE-Meta: U2FsdGVkX19/qfFiGOcjnDjoOUvmPX2wPZ0uE77FiZA3J0o00LpFOh2Nqq9VKGru/5CwCR6HhDLz0T6R8eRtdzvsfuXenXmTWNnXOei+2PiBXlAbMRJAbpi2rrjwKSHBPaOnBbaSCuA8PXACRnRQyisAdTpnMfI47lHnjvru1i0h2p6hA8lTUNUbiq6ldaIGZGLI3cvTlHGvbz1v3nzd51vgd0ygo6Q4JtiKBI5D0C6dZhLBN8j081s2t9fNkZpOZtvBzisUIN1x3MDAlUeePf1Vmbt1EY0OQrFyg5BZ7pbeMLmgim7Gqo9SRoGrzpVycxyaRurBVcaa8t+vRGd3tZa3AA2k84gCX8ygk7ETVc2fI5wmuo4hQBUBy4djC//yzkfvCtDBkaV6XSh+6c0j/SHcpyzkeVeJDzsYsr3ifiBbC6HJilCylZeVC2IDH/g15IbE4XVb+WlFBmnZeyg2AGtNLYtZ3+0DCqkJhwln5+jCSz9iXGd5AjlaIzo+uFaxbVfKS2uMoAHXMMfpftp4HEJJCZbrWhUtYTD8KWbiyM4hTBAE1XYU/0AQR2BKqjhGdFIKVApgn3JExYLdObVTH2TZrJNiZML1mOlREI2G/J3F1s3HbMFMd9uDBXtBdJ3elhwo8E9D6huvbYjyqhuflSGFc1VTpLr4EBNkR+LOpr5Kz0VzXTmXU+vQsgNHFK85LoKDoz+41Ve/24Yj9ixPHenKTCLyk4i6zMo/pc1yd4IOyqpqLPeTwiReqEfyWCax0W3AzeZE1/GJPbnDuy+puib3IxVUIFmKjMOZOa1P4ZtmCsSfqXJu0Nq8JW5o7d5qQ/DTzGn2ZquWzqYLRr5CVQqsCmhMVJ7y7gwfnnL8Amoskw+HR646vq4WyP51QVMm2ITwZP9Y7lm1IzmUQ+eeCbKDzzILcOwlQnqNcmkjtlGzc51YAz629WLchPl/aNXMVolmiyHyNOl+PEJn2AJ
 CEhAXGIP
 4Pwmw5NenelFrdE8JtdLyB/Euf56KVYX21hdw1bI1K9od9aHDTBothl00EYA9hlvSP5ej5GWSCsYdF1mSsz+er/04m868geprTxareGR/ZaglTQq3pjaY7CTzZYkKRDqsrAamOZcmh1PVIj4gfqpOgH33nIz8jgKaI8Eo4sTL/g7KHsy5+kYZmTIZWEvsN9DJPMt3F43FqtNJN44NkCOqk32ejz1P31v+B1y7IworTZvveICJRblhYSWNMxPuG3D0TBTExqyT1BeOso52BAWR7M5eahFe9p67k+egGeZzWc8lmFF5xH9lYajRwfSMPleoRQ8ir8SiLhI8KIS/pVKe67ter0zC2pY88PYEPX0EzbvDKK389o/2mcYCxD9HIkNmGZY2VuPuevu3+ggOmwQDFnPJbtYrKgyPEIG3LT0XImT0Zxrkg2HQ/6ldTrQRPhGWc9kMbsAuWfALx84M1Oveizc9ygXHK4N1vCEBfXqp/RGIe5q/y4MXHPOO2Mo5PN1lSi688kh7s8h0alnCeTBt43lUSOVLLLc7eNae5/z+348kD+xLqpjcAluq1ciiIKWmlzUA9yUYsuxuSTRkkMCRKFQ8JUy3sQkMICWG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In commit bfe3d8f6313d ("x86/tlb: Restrict access to tlbstate") some
low-level logic (the important detail here is flush_tlb_info) was hidden
from modules, along with functions associated with that data.

Later, the set of functions defined here changed and there are now a
bunch of flush_tlb_*() functions that do not depend on x86 internals
like flush_tlb_info.

This leads to some build fragility: KVM (which can be a module) cares
about TLB flushing and includes {linux->asm}/mmu_context.h which
includes asm/tlb.h and asm/tlbflush.h. This x86 TLB code expects these
helpers to be defined (e.g. tlb_flush() calls flush_tlb_mm_range()).

Modules probably shouldn't call these helpers - luckily this is already
enforced by the lack of EXPORT_SYMBOL(). Therefore keep things simple
and just expose the declarations anyway to prevent build failures.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/tlbflush.h | 43 +++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0545fe75c3fa1..56cff03b65aa2 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -251,7 +251,6 @@ struct flush_tlb_info {
 	u8			trim_cpumask;
 };
 
-void flush_tlb_local(void);
 void flush_tlb_one_user(unsigned long addr);
 void flush_tlb_one_kernel(unsigned long addr);
 void flush_tlb_multi(const struct cpumask *cpumask,
@@ -325,26 +324,6 @@ static inline void mm_clear_asid_transition(struct mm_struct *mm) { }
 static inline bool mm_in_asid_transition(struct mm_struct *mm) { return false; }
 #endif /* CONFIG_BROADCAST_TLB_FLUSH */
 
-#define flush_tlb_mm(mm)						\
-		flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true)
-
-#define flush_tlb_range(vma, start, end)				\
-	flush_tlb_mm_range((vma)->vm_mm, start, end,			\
-			   ((vma)->vm_flags & VM_HUGETLB)		\
-				? huge_page_shift(hstate_vma(vma))	\
-				: PAGE_SHIFT, true)
-
-extern void flush_tlb_all(void);
-extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
-				unsigned long end, unsigned int stride_shift,
-				bool freed_tables);
-extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
-
-static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
-{
-	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
-}
-
 static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
 {
 	bool should_defer = false;
@@ -513,4 +492,26 @@ static inline void __native_tlb_flush_global(unsigned long cr4)
 	native_write_cr4(cr4 ^ X86_CR4_PGE);
 	native_write_cr4(cr4);
 }
+
+#define flush_tlb_mm(mm)						\
+		flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true)
+
+#define flush_tlb_range(vma, start, end)				\
+	flush_tlb_mm_range((vma)->vm_mm, start, end,			\
+			   ((vma)->vm_flags & VM_HUGETLB)		\
+				? huge_page_shift(hstate_vma(vma))	\
+				: PAGE_SHIFT, true)
+
+void flush_tlb_local(void);
+extern void flush_tlb_all(void);
+extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+				unsigned long end, unsigned int stride_shift,
+				bool freed_tables);
+extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+
+static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
+{
+	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
+}
+
 #endif /* _ASM_X86_TLBFLUSH_H */

-- 
2.54.0


