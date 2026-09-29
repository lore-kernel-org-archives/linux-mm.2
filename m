Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 647F4C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 04:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831286B009B; Tue, 29 Sep 2026 00:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808B56B009D; Tue, 29 Sep 2026 00:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F81E6B009E; Tue, 29 Sep 2026 00:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC036B009B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:03:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DFEAA1203CE
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:32 +0000 (UTC)
X-FDA: 85265455464.22.47E1244
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	by imf24.hostedemail.com (Postfix) with ESMTP id AAC79180006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=Juml6KXe;
	spf=pass (imf24.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.216.98 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790654610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLpMQWp4oIwCSrdCkDjUFbSbG4amFgJT1I1bhegO2zs=;
	b=LCAIzEsALsN9Ys5MuQQSUOtZjc4yXE0vdPiQNNhE3nuNoJrE2YvNkBJheAuTR0mGEUnxOq
	O18dJFY59wlQqFUDa5gPHAgvZvNrKI7f0TQgba7Za2AvLyunFJu4yxUzw5U595p3z8BvoA
	pbSrM6wOsMYocg33WWdr0luyM/ufkxw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=Juml6KXe;
	spf=pass (imf24.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.216.98 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790654610;
	b=QPDQ6u2zfSPY97CfW4rGCkWO4Zg8IerOv3h2EabFIOT6kiqL+CZaGIFi+AXd6jkdOPobp0
	Oeh315YrUDZNs39RCqXCHn4ZXwEBh0bjCD8Kc4gQrYnTJKmTS+MSfaFjgE7Av9HwaOQMVe
	Ud/RTIud9xheJxpfAhiUZTeJwYIrqZA=
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3a02b38210cso2008586a91.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790654609; x=1791259409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VLpMQWp4oIwCSrdCkDjUFbSbG4amFgJT1I1bhegO2zs=;
        b=hkqQhe4+Wqvu3E1E842icNvhRi+mvhPx43EqFipqwPEhQ2Hovs08oSXB6XFy+sZbnp
         AKLk1YvVbeaepN8d8T6lZX2jsJjdPxBNiUEQtA3wy7UGKmHi8rkXt+npssScqBz3RZuN
         WC68aobarv2HHOrZCJfX7+NPgCC4xbEfoOnh6PzfdjhTkC4xz41FOkwoR4xNi/7/P0Ey
         DRbv72fwXARnC+P76LdpQBom1wpPGF1iG+ze6PcTdRgduEyHh1qQAXH2NA3Hf8BizN1m
         9nFafnUQ1LvYEUxILFMmpPKlIzGClYDknsAjykd7pmOhqXPu2C2ZTL/zyYuot/AGY8Bb
         la5Q==
X-Forwarded-Encrypted: i=1; AKwUvBx5MNoYju5aDRaykTdvC8nxd5ISQJC4pXXblYoCJKRQ8o5wM16Vpm0He27C+0hOTVQIZ3J0WesWdQ==@kvack.org
X-Gm-Message-State: AFq9FYLN81BM2xk++5vuMLAG5y0wgXUCfkF9glUKI266wTx2AUYWxtxV
	/TJp7WjPkQFN9CxISB86OKh+ZR+OPTsCwsrORtWia3ctVOxkTssHitTw+UKblcENF0zQQU7260Z
	ySY7QCAlZHEvxwyGCPqImjn7IeMA7QDan3Qo6Eyy2/NKuGZUT/vcXB/UnfaXHvj81LgW+7aLoz0
	RUFCW6KInOHl/IX81vlzKJgRm1KAxZs/CdFMHLFqt0Ak5R4XuW6GQ07htCAJbiG3X4eIBm+4uyP
	Mw=
X-Gm-Gg: AYBFou1+wDck3MZGoRPSopLFI6pfK/lhXBQ7Z4w5/7Fkg9hbFcgmChE48KLEiOczuzm
	4TTehogZul1BnujCCo+hpLzvzsKQWoJqAndwArSAnJh5fxF+kI0HUbM/AL1h/Wv5bmDuzLh9xqN
	MVK0PkxZVmxOUhOJyflnF7UBMl7iecJ1SL0lRbdAeFtU5hN7uvAECWq+9Ri6LC4DZkjB1zFdBMM
	/uOGHrYEJD3AyZITN+xRfF0v2ysxq46Q+cuoXlGWclqt6pklvk1+wY54JjcZGrWKXbEO/GIi/kX
	xU3wjzHU+iazR/RnLFi1nokK7jzRy2jnU2El3ve5BzgJXsCDRhc74w9A3Jq1vDG0Dhhqq00zWOY
	SwyCmzxZwaV6z+Or4NuM5LcpBkvJiUFkYwAOpOex0b+Jn3tniO+s6Z7ismS25qh7D5wxWTGAZy5
	USeWWolIxkKmtNhbJlUMeWCLW8HhFdRlflzj0=
X-Received: by 2002:a17:90b:2743:b0:3a4:77b8:1770 with SMTP id 98e67ed59e1d1-3a477b84d5amr3343202a91.15.1790654609372;
        Mon, 28 Sep 2026 21:03:29 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a4986acfbesm348212a91.0.2026.09.28.21.03.28
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 21:03:29 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-342a0e1d8c4so1487913eec.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790654607; x=1791259407; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VLpMQWp4oIwCSrdCkDjUFbSbG4amFgJT1I1bhegO2zs=;
        b=Juml6KXeqEcGX8JgVKOEFfTzc/iT5uWqvCx80d0HZXN2yVcPMvPI0DbjfE41RDvZ/2
         qdC2fYdUXDhVA43MJGQ5zed2HUvL416ox5D9I/Sx7GA+iGCQGMH891PiETqG0YCK2aDj
         40JIIEBUMFEmrtclhp9Wkz/1R5RzqgzC0cz7w=
X-Forwarded-Encrypted: i=1; AKwUvBxVgQtPiYt3UoT/LJ4yHPpTS2kE3Avcv/XWPTznxVeZrbS6ImLMGFGzdCJnez9i2uCEyXCN7REL7w==@kvack.org
X-Received: by 2002:a05:7301:152a:b0:339:7c91:21f4 with SMTP id 5a478bee46e88-34273252770mr13517026eec.34.1790654607114;
        Mon, 28 Sep 2026 21:03:27 -0700 (PDT)
X-Received: by 2002:a05:7301:152a:b0:339:7c91:21f4 with SMTP id 5a478bee46e88-34273252770mr13516961eec.34.1790654606151;
        Mon, 28 Sep 2026 21:03:26 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-347323f5a7esm10952571eec.15.2026.09.28.21.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 21:03:24 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: Kiryl Shutsemau <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bo Gan <bo.gan@broadcom.com>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: [PATCH v2 4/6] x86/mm: Provide common early memory decryption
Date: Tue, 29 Sep 2026 00:02:53 -0400
Message-ID: <20260929040256.543767-5-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260929040256.543767-1-zack.rusin@broadcom.com>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AAC79180006
X-Rspam-User: 
X-Stat-Signature: zaqowjbx6gut9s3g7pbw3gsbtw4ngm5p
X-HE-Tag: 1790654610-740579
X-HE-Meta: U2FsdGVkX1+9Ixi58qRdOVmLEwGhnaNHniy/a0g1/1MJU3pIJ2BJh5Sp45w2vlcd28C0z+q81/zFKBqoN5qeapvIyzVB8OLqeJB3oIechMC7o64RroL18b3Iujb8FAiIF1SaMZW1vPHBSEx4AaEDV3oGitnuopofENo7vi/e2+v1NroDysni0dE9euucrOq3xTabThWKQGjiirCv075tkAKcMQuuO+QjGehRqWex9ULkhS782LLua5dlfyo+080zKuRMxxaoncSk5y/KBRIX2joeBTHhgfbTHD4DZIzRfqUTtkEmY3X1/jIL+ECm8PWfEpRBWSk8zHU7djD9FTgTp+q3tFoItBnoOt+V+s2+kF59CQvfm+BWOpvsGpZVxUmcrF04SuF5KEY5wjAxl5Yn8llEtGOoK6tk3oMj2NNBH7fNkkA0PamcYI1NY8Syr5HNvCKOINb9OcVv05pp/9IhQKqLiNC0VoW43soXS2V5d4hF8/UtSp+5s3UlapVXluVpjZV8LKGIKLiYFo+0tmDaWXUWhh4L9rtfGtdPSoNwnt/yap0KksVAuj2mhe1E7PMKWUSZl0vOuivLijecVejw+Ag2fo8Gquu4LMFNIqpSNYq94DPhFskgVSl5zG1oS0/wHuTvfiHvcOOaRyIMAHAM1EIV61UUmx8hFj7CQqBakMwR3u4LXSiXXhiY22iRJCaOnqY+nLvcETQ8PHiQmCIaJiqzVzRLDkVdmmX2SIPi4BqLXHc9McwWrhEJ3gPFqc60rTTIPAeW3mnCEawGKPHy5uDz3zn2MfGExsxkCWSys4Ga7k6pUflTIc0v4LzvEbm53+Tw0cK/tgOru4clRvEuf+KvOyTDfkpJU3bEsqV2F7I6riTFY5MWMx01UWLoa5urEajr3q4ZhDFviJJCCOqmAk06PiNNIUgY2ql+7kwV3cBufGNIx+A8TD/Y668zBHomODWe6rYt1sFqvVWR0EY
 QhgVoOoz
 E18xa1wLVHsyF6Qv7Wh2DObUNbV/xCBH2CboHrHC+y6k30tEmhXZ9iRQILsXLjOjqJoYMGfKsptS7yBZEvYiLoygcdd33F0JTmN+lPw7AKWaCdYoeTm0KPPj2Ceq7j2gmn4mbfOIU7HHvppo0jnf9UjFJdOpiRnvrlTY9/7X9FPWo7TYW/CfZLcmqI2/BhlDCAzIuf8A2pJPBPsg53modEHRMW0820WEQaMN80GYxQTRG/605UNIyEqjUEkf49cAqX2TuaDKzhIUxVSueOEI7ZFGZi8mJOi8OhDARO1a5NDPaooceDFVLAKwqn7KrOeTqzDXiyqyc6OIjC0gbng7u7p+tQWxfBMgTm0ztOnhqGQpdOS1jt4CCT0cpC1X2vnFIW5WE0+99rXOMsEC2h5POptGg5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Static per-CPU buffers must be shared before the page allocator is ready.
Provide a page conversion callback with common early page-table splitting,
including the kernel-image alias used by UP data. Flush large translations
before changing attributes and retain the AMD content and SNP transitions.
Drop UP image aliases before SNP kexec makes the backing pages private.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Link: https://lore.kernel.org/r/aqqGUAX65s4LdJkr@thinkstation
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
---
 arch/x86/coco/sev/core.c           |  16 +++++
 arch/x86/include/asm/mem_encrypt.h |   7 ++-
 arch/x86/include/asm/x86_init.h    |   2 +
 arch/x86/mm/mem_encrypt.c          | 117 +++++++++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt_amd.c      |  12 +++-
 5 files changed, 149 insertions(+), 5 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index cc292d7c6fd1..bc1afa366c33 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -541,6 +541,10 @@ static void set_pte_enc(pte_t *kpte, int level, void *va)
 	set_pte_enc_mask(kpte, d.pfn, d.new_pgprot);
 }
 
+#ifndef CONFIG_SMP
+extern char __start_percpu_decrypted[], __end_percpu_decrypted[];
+#endif
+
 static void unshare_all_memory(void)
 {
 	unsigned long addr, end, size, ghcb;
@@ -550,6 +554,18 @@ static void unshare_all_memory(void)
 	pte_t *pte;
 	int cpu;
 
+#ifndef CONFIG_SMP
+	/* Drop image aliases before the direct-map walk makes pages private. */
+	addr = (unsigned long)__start_percpu_decrypted;
+	end = (unsigned long)__end_percpu_decrypted;
+	for (; addr < end; addr += PAGE_SIZE) {
+		pte = lookup_address(addr, &level);
+		if (pte && pte_decrypted(*pte))
+			set_pte(pte, __pte(0));
+	}
+	__flush_tlb_all();
+#endif
+
 	/* Unshare the direct mapping. */
 	addr = PAGE_OFFSET;
 	end  = PAGE_OFFSET + get_max_mapped();
diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index ea6494628cb0..4d81f693b1d3 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -21,9 +21,13 @@ struct boot_params;
 #ifdef CONFIG_X86_MEM_ENCRYPT
 void __init mem_encrypt_init(void);
 void __init mem_encrypt_setup_arch(void);
+int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
+void __init early_set_page_decrypted(unsigned long addr, unsigned long alias);
 #else
 static inline void mem_encrypt_init(void) { }
 static inline void __init mem_encrypt_setup_arch(void) { }
+static inline int __init
+early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 #endif
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
@@ -50,7 +54,6 @@ void __init sme_early_init(void);
 void sme_encrypt_kernel(struct boot_params *bp);
 void sme_enable(struct boot_params *bp);
 
-int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
 void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr,
 					    unsigned long size, bool enc);
@@ -86,8 +89,6 @@ static inline void sme_enable(struct boot_params *bp) { }
 
 static inline void sev_es_init_vc_handling(void) { }
 
-static inline int __init
-early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline void __init
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 953d3199408a..e4131402c783 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -75,9 +75,11 @@ struct x86_init_oem {
  *			the kernel pagetables and prepare accessors functions.
  *			Callback must call paging_init(). Called once after the
  *			direct mapping for phys memory is available.
+ * @early_decrypt_page:	Share a direct-mapped page and its optional image alias
  */
 struct x86_init_paging {
 	void (*pagetable_init)(void);
+	int (*early_decrypt_page)(unsigned long addr, unsigned long alias);
 };
 
 /**
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 3aefdef5bcb0..c3e239a47b66 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -12,10 +12,127 @@
 #include <linux/swiotlb.h>
 #include <linux/cc_platform.h>
 #include <linux/mem_encrypt.h>
+#include <linux/pgalloc.h>
 #include <linux/virtio_anchor.h>
 #include <linux/iommu-dma.h>
 
+#include <asm/sections.h>
+#include <asm/set_memory.h>
 #include <asm/sev.h>
+#include <asm/tlbflush.h>
+#include <asm/x86_init.h>
+
+#include "mm_internal.h"
+
+static pte_t * __init early_lookup_pte(unsigned long addr)
+{
+	unsigned long pfn, step;
+	unsigned int level, i;
+	pgprot_t prot;
+	pte_t *pte, *table;
+
+	for (;;) {
+		pte = lookup_address(addr, &level);
+		if (!pte || !pte_present(*pte))
+			return NULL;
+		if (level == PG_LEVEL_4K)
+			return pte;
+
+		if (level == PG_LEVEL_2M) {
+			pfn = pmd_pfn(*(pmd_t *)pte);
+			prot = pgprot_large_2_4k(pmd_pgprot(*(pmd_t *)pte));
+			step = 1;
+		} else if (level == PG_LEVEL_1G) {
+			pfn = pud_pfn(*(pud_t *)pte);
+			prot = pud_pgprot(*(pud_t *)pte);
+			step = PMD_SIZE >> PAGE_SHIFT;
+		} else {
+			return NULL;
+		}
+
+		table = alloc_low_page();
+		if (!table)
+			return NULL;
+		for (i = 0; i < PTRS_PER_PTE; i++, pfn += step)
+			set_pte(&table[i], pfn_pte(pfn, prot));
+
+		if (level == PG_LEVEL_2M)
+			pmd_populate_kernel(&init_mm, (pmd_t *)pte, table);
+		else
+			pud_populate(&init_mm, (pud_t *)pte, (pmd_t *)table);
+
+		if (addr - PAGE_OFFSET < get_max_mapped()) {
+			update_page_count(level, -1);
+			update_page_count(level - 1, PTRS_PER_PTE);
+		}
+
+		/* Flush the large translation before changing any attributes. */
+		__flush_tlb_all();
+	}
+}
+
+/* The caller has split both mappings before starting the page transition. */
+void __init early_set_page_decrypted(unsigned long addr, unsigned long alias)
+{
+	unsigned int level;
+	pte_t *pte;
+
+	pte = lookup_address(addr, &level);
+	set_pte(pte, __pte(cc_mkdec(pte_val(*pte))));
+	if (alias) {
+		pte = lookup_address(alias, &level);
+		set_pte(pte, __pte(cc_mkdec(pte_val(*pte))));
+	}
+	__flush_tlb_all();
+}
+
+/* Boot CPU only; size is in bytes and the contents are preserved. */
+int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size)
+{
+	unsigned long end, addr, alias, pa;
+	pte_t *pte;
+	int ret;
+
+	if (!size || !cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		return 0;
+	if (!x86_init.paging.early_decrypt_page)
+		return -EOPNOTSUPP;
+	if (size > ULONG_MAX - vaddr)
+		return -EINVAL;
+	end = PAGE_ALIGN(vaddr + size);
+	if (end < vaddr)
+		return -EINVAL;
+
+	for (vaddr &= PAGE_MASK; vaddr < end; vaddr += PAGE_SIZE) {
+		if (vaddr - PAGE_OFFSET >= get_max_mapped() &&
+		    (vaddr < (unsigned long)_text || vaddr >= _brk_end))
+			return -EINVAL;
+
+		pa = __pa(vaddr);
+		addr = (unsigned long)__va(pa);
+		pte = early_lookup_pte(addr);
+		if (!pte || pte_pfn(*pte) != PHYS_PFN(pa))
+			return -EFAULT;
+
+		alias = 0;
+		if (pa >= __pa_symbol(_text) &&
+		    pa <= __pa_symbol(roundup(_brk_end, PMD_SIZE) - 1)) {
+			alias = (unsigned long)_text + pa - __pa_symbol(_text);
+			if (!early_lookup_pte(alias))
+				return -EFAULT;
+		}
+
+		if (pte_decrypted(*pte)) {
+			early_set_page_decrypted(addr, alias);
+			continue;
+		}
+		ret = x86_init.paging.early_decrypt_page(addr, alias);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
 
 /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
 bool force_dma_unencrypted(struct device *dev)
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 2f8c32173972..e854f3a039f7 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -459,9 +459,15 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 	return ret;
 }
 
-int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size)
+static int __init amd_early_decrypt_page(unsigned long addr, unsigned long alias)
 {
-	return early_set_memory_enc_dec(vaddr, size, false);
+	unsigned int level;
+	pte_t *pte = lookup_address(addr, &level);
+
+	__set_clr_pte_enc(pte, PG_LEVEL_4K, false);
+	early_set_page_decrypted(addr, alias);
+	early_set_mem_enc_dec_hypercall(addr, PAGE_SIZE, false);
+	return 0;
 }
 
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
@@ -479,6 +485,8 @@ void __init sme_early_init(void)
 	if (!sme_me_mask)
 		return;
 
+	x86_init.paging.early_decrypt_page = amd_early_decrypt_page;
+
 	early_pmd_flags = __sme_set(early_pmd_flags);
 
 	__supported_pte_mask = __sme_set(__supported_pte_mask);

-- 
2.53.0


