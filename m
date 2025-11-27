Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5A07CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B466B009D; Thu, 27 Nov 2025 09:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452CA6B009E; Thu, 27 Nov 2025 09:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3691B6B009F; Thu, 27 Nov 2025 09:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 229816B009D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:12:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE1B286DC6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:28 +0000 (UTC)
X-FDA: 84156577176.19.D10A356
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1DE6EC0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TaS601QE;
	spf=pass (imf28.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCE7BFaxTmXT5gX1mJT6mv3jSbzO4IVr04XlUFHKTqA=;
	b=6ZDwCSsO0Kw9P0QaN9j0hQBHgroNKviRcqK9Y2jlR81+g10KPLk/fB3D8L9YHB25rzt50A
	n5IuEp+NIIGiwrsAqbo29lcoXkblMsXqleZhojJi7knC8aP5/ISyQIcJlQDGwm+1pi7MfM
	6li0bxel9tC197e0mvyVcn4cnmFACoY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TaS601QE;
	spf=pass (imf28.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252747; a=rsa-sha256;
	cv=none;
	b=TClae3/yrxoOFjqz7DEL2Bj8Pk33rYsQQ1GelSM7hWBLPJZQ15blYRwAH91hhU7MBJYMx/
	qLtAWdTAPGq7jogYgJAmZb7W/u45a6SXAMPTbupIiiJQY464xM+VX3VJ9SGTp0+dQSpl1Z
	K47VVKlqucbeYZW+6DqqUtXhclKAl7Y=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3438231df5fso1142463a91.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252746; x=1764857546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kCE7BFaxTmXT5gX1mJT6mv3jSbzO4IVr04XlUFHKTqA=;
        b=TaS601QEteDiBoln87xz+MW6RA4EJ17C+MNyZCPGSkD26E7xg79C2gwchztAORK2jo
         oyQ+o7jMJ4tY6yUhW966vlzwSfU0wjzkrZT0p7kGWJ4a94NAK6RUR71Xwjy3VlrAxpwj
         ZGoGO4oPlZKktGzX4rT5pgdUc8fUFJ2EXXg6lxHu3XYXF48lmOYxF4nFXO5x4113N98d
         7w9+3kcTvr+uEgorsMSif5bYNlwXsK23aybPak2wusGmd215cTV6eBbkCO9p77pQikSG
         6q+YCPe51UApz76WD2UFpvShRGXOPUXLWuS3DU2bpk709o/QNsvexNM+bO1tfjsQKYgv
         WZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252746; x=1764857546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kCE7BFaxTmXT5gX1mJT6mv3jSbzO4IVr04XlUFHKTqA=;
        b=qP9TvAm0CYVtOWZP86mnhMGpB97pLEFTV3wlZGlrHejSB9p/t4dkGNO7RzDD/3QI1w
         IYuskJPjQ4fAsI1toXhZwjdQth7l4XaFDQWnc6N9pntqwxw0pVPraCS3Q9bMAkdU7yOb
         cHu2x6rfiUrcQ9pZ8D49y7MQARPuqkrr1QKv6+jSWWp6fIGa2Lx5CkIP8a3YLYUWqDqo
         KDlZ5S4lvat2v1NMzWM6KL06bEvC2QHQYvxH2GW/R55F+vKhn/84uATxAZkFReqjtLX3
         frU0TXkotuhUQ+F0VRtDFf4CTlvHHpTPXyA22AUkNuNFNTTkTtZYkMvxV1U/ipqKkw91
         nWVw==
X-Forwarded-Encrypted: i=1; AJvYcCWKv+5r9PcNUOI0OTotSmvqP6W/14QstBKCkXVmKM6arHjpbJqdnQisfmwGVfWwYqnFvb6krTfCGQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0UbMY9yQbAl7yLbLR6p3B2FPNSkERVYZwtsJO1FBRA14kfDzX
	JmZBnCzlUrePaY5AvlfqmsZ+AoBwGNw91kWcc2TNjTaYEPCYluE4hQoBuxeToOAEQaw=
X-Gm-Gg: ASbGncvwcmc2+IhwaUvgJVrS85D1B0FOykv/I05FLAG1dc2daSX0F83UBLbVXPv7bLz
	MV8K52hSt/EAhaynwavXnL8AH+oRs5BZKfRCX42TmuGPqUTcjh/jMCpeDZ41XwciuP2yjnBgzgg
	5y3tMINNkasf9zO4cuQzoYnEmmnD421KvhKbJcCPSANSvTJDK9vqBwUAEs4UCBD2FRURhfYo2MN
	g0Zele05SVcPL3aLR8iv4E9pBrLHE8f6CKkE4V0+YZDb0Ou8aOC2hrGied1o0ImT7YwBe3K1SVC
	eJ9W3B4V+oc6AaLMwh1RhZZyRhKD1FlzN+kG4g8qEBzuuu/JH4YrthJLBJa9Ur1UoK5vO2ImlAf
	FFm1dUNOaE42/KbWR7eZ9pmEnaMn7jH7AuRd7PrNvURSiIE270zosAu71bKBP7DPpamn++YxMSm
	MJQDUNgq1GUtEs14cHYgIMxOF25Zd0V42p4eNe0f2GTOhB6iG0LcBezCV1Pc37vXJW7LBdz4Ab7
	fjpMMYgZDQJ
X-Google-Smtp-Source: AGHT+IHaJbhR6uoA8AsgyvN1rZkRokZKcV5EN92G/Fd+krItmdJONN0XD0mHkXfOugo46//aXXPl7A==
X-Received: by 2002:a17:90b:1a84:b0:32b:65e6:ec48 with SMTP id 98e67ed59e1d1-3475ebd2f41mr10628835a91.8.1764252745954;
        Thu, 27 Nov 2025 06:12:25 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.12.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:12:25 -0800 (PST)
From: Xu Lu <luxu.kernel@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	apatel@ventanamicro.com,
	guoren@kernel.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [RFC PATCH v2 5/9] riscv: mm: Introduce arch_do_shoot_lazy_tlb
Date: Thu, 27 Nov 2025 22:11:13 +0800
Message-ID: <20251127141117.87420-6-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127141117.87420-1-luxu.kernel@bytedance.com>
References: <20251127141117.87420-1-luxu.kernel@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DE6EC0010
X-Rspamd-Server: rspam02
X-Stat-Signature: a38bi9oy1rkns5ykjqb4egeciqrwz78u
X-Rspam-User: 
X-HE-Tag: 1764252746-76524
X-HE-Meta: U2FsdGVkX1+Gnk9kZmGIZs3BebubyPeYyTMHkXW/MIsHRrT+/nMgRZizzzNlsqgZfHf94tamFCPsPg4wfXAZULbXriWD1Fr66wFaRk0ZHScHXygkuNNo2iqwtVi1dOoOtLXpu3r3p3x9REK9G7Qcn+KO6UoyplF7HcM835IsytrAWFhVVaF7+HmetPhVAyWcS9ojcErprw8RA9zpbh6ZY+d6O1BQhrrFQfjQyVE51R0V+I/BzYzz37i8WC4vByTUn9QXg9vvBK3RN6f33uXDKZX52DYDVrDNuDdUHt2a2plVMLC6FBAebU7tvmNS0Fw5BcFtQVtVcO4QRYuu9QRm7YMOIBEdorZoX/fxBVc1uldrco4q7x8+qGbw1zJNDPWJV/wmZg+yirBIhkcU+criw3xhPdkl5hF3vwlC+MeAJlCiU3aYlaJbu8f3nt/q2p/0xReRQLeUStAPFB7IP08ZF2kgk1cxeqoUtUqLHdI9vQ8rjiLLX7RkFkNmygqJa0WTVzkAWuZ8nv8w5Obx/XdVHGhCzr76mWTj0hDpJGVSfIWsL5Ov97MQGu8oWWtxBWnyMtazNHTZDengUFf5/F7p7G+LChJZSIojCSFEs15vs4enSlOl65NLXykIWx5T8c0g61xqD6dsgQ0VW3W8X2wKpKX+lIqYTuMmjqogrQLlzztFVZji9preTLDLmtmGXOPkGir0OEJ3Y/6LVVynjt1RatCLXFAOpmR+umsdsVaxn+VkLWDAmSb517rLG0fBSXxQXBc6QbIrAjtmi2nywV7ytaSENsZoI5zSNsNPH4ElrsACyIkOYmgrMCou441hVFtpcKlOUaYw+wIE/RfVZzWpPruvWab1BWb81vRY6F96GhPsZwUrJp/Ah1N6sf7kiu0DeeAwOonae8C6jVFwaBM6WCsBvwzVs0ET0Oh1+RunZZZDw4NgFE8W+eIF2YOQacjuVVn3/+4fw5Gz4ucyJSM
 k9QUujsq
 ZywMyCVRD+WN2wjZGR85E0szwM7fo8PcMVM9v+rt0kDyIs+fLR9jMRyQGUaAYBAeGVwPy+YD/ny4VfQulMv7ZZSgsno0sd7iobKDjhCCWze82myKaBdl+xzp4oLq1KjrAcNbwnWFizdwyyK8IIXOULS+4FVAKy8+f0tVtg8CvW7Ag6JipXfpyaOegrVBvAofSmJ8Ph21kfKChywHaLeHuEX396OoPdoOnMF3V+h922vs0+TSGmrpnEiSiuNStTL/KE1clpqrHn+AjxdPHtotd6TA6HuLFYXPCZy2A2knW8Gkx44eZz47WYAzOt3dN3Xq5824febgPCvR++Q0/HnSN0yxlCZSLxfioAmeXQHXBS7sP/xr90Nvgt3DwpD3GfB3QPiPobFjp8uQ311w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an active_mm is shot down, we switch it to the init_mm, evict it
out of percpu active mm array.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/mmu_context.h |  5 ++++
 arch/riscv/include/asm/tlbflush.h    | 11 +++++++++
 arch/riscv/mm/context.c              | 19 ++++++++++++++++
 arch/riscv/mm/tlbflush.c             | 34 ++++++++++++++++++++++++----
 4 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/mmu_context.h b/arch/riscv/include/asm/mmu_context.h
index 8c4bc49a3a0f5..bc73cc3262ae6 100644
--- a/arch/riscv/include/asm/mmu_context.h
+++ b/arch/riscv/include/asm/mmu_context.h
@@ -16,6 +16,11 @@
 void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	struct task_struct *task);
 
+#ifdef CONFIG_RISCV_LAZY_TLB_FLUSH
+#define arch_do_shoot_lazy_tlb	arch_do_shoot_lazy_tlb
+void arch_do_shoot_lazy_tlb(void *arg);
+#endif
+
 #define activate_mm activate_mm
 static inline void activate_mm(struct mm_struct *prev,
 			       struct mm_struct *next)
diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index 3f83fd5ef36db..e7365a53265a6 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -15,6 +15,11 @@
 #define FLUSH_TLB_NO_ASID       ((unsigned long)-1)
 
 #ifdef CONFIG_MMU
+static inline unsigned long get_mm_asid(struct mm_struct *mm)
+{
+	return mm ? cntx2asid(atomic_long_read(&mm->context.id)) : FLUSH_TLB_NO_ASID;
+}
+
 static inline void local_flush_tlb_all(void)
 {
 	__asm__ __volatile__ ("sfence.vma" : : : "memory");
@@ -86,11 +91,17 @@ struct tlb_info {
 DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_info, tlbinfo);
 
 void local_load_tlb_mm(struct mm_struct *mm);
+void local_flush_tlb_mm(struct mm_struct *mm);
 
 #else /* CONFIG_RISCV_LAZY_TLB_FLUSH */
 
 static inline void local_load_tlb_mm(struct mm_struct *mm) {}
 
+static inline void local_flush_tlb_mm(struct mm_struct *mm)
+{
+	local_flush_tlb_all_asid(get_mm_asid(mm));
+}
+
 #endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
 
 #else /* CONFIG_MMU */
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index a7cf36ad34678..3335080e5f720 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -274,6 +274,25 @@ static int __init asids_init(void)
 	return 0;
 }
 early_initcall(asids_init);
+
+#ifdef CONFIG_RISCV_LAZY_TLB_FLUSH
+void arch_do_shoot_lazy_tlb(void *arg)
+{
+	struct mm_struct *mm = arg;
+
+	if (current->active_mm == mm) {
+		WARN_ON_ONCE(current->mm);
+		current->active_mm = &init_mm;
+		switch_mm(mm, &init_mm, current);
+	}
+
+	if (!static_branch_unlikely(&use_asid_allocator) || !mm)
+		return;
+
+	local_flush_tlb_mm(mm);
+}
+#endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
+
 #else
 static inline void set_mm(struct mm_struct *prev,
 			  struct mm_struct *next, unsigned int cpu)
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 4b2ce06cbe6bd..a47bacf5801ab 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -164,11 +164,6 @@ static void __ipi_flush_tlb_range_asid(void *info)
 	local_flush_tlb_range_asid(d->start, d->size, d->stride, d->asid);
 }
 
-static inline unsigned long get_mm_asid(struct mm_struct *mm)
-{
-	return mm ? cntx2asid(atomic_long_read(&mm->context.id)) : FLUSH_TLB_NO_ASID;
-}
-
 static void __flush_tlb_range(struct mm_struct *mm,
 			      const struct cpumask *cmask,
 			      unsigned long start, unsigned long size,
@@ -352,4 +347,33 @@ void local_load_tlb_mm(struct mm_struct *mm)
 	}
 }
 
+void local_flush_tlb_mm(struct mm_struct *mm)
+{
+	struct tlb_info *info = this_cpu_ptr(&tlbinfo);
+	struct tlb_context *contexts = info->contexts;
+	unsigned long asid = get_mm_asid(mm);
+	unsigned int i;
+
+	if (!mm || mm == info->active_mm) {
+		local_flush_tlb_all_asid(asid);
+		return;
+	}
+
+	for (i = 0; i < MAX_LOADED_MM; i++) {
+		if (contexts[i].mm != mm)
+			continue;
+
+		write_lock(&info->rwlock);
+		contexts[i].mm = NULL;
+		contexts[i].gen = 0;
+		write_unlock(&info->rwlock);
+
+		cpumask_clear_cpu(raw_smp_processor_id(), mm_cpumask(mm));
+		mmdrop_lazy_mm(mm);
+		break;
+	}
+
+	local_flush_tlb_all_asid(asid);
+}
+
 #endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
-- 
2.20.1


