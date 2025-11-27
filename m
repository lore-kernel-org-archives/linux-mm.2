Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F55D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566746B00A3; Thu, 27 Nov 2025 09:12:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517126B00A6; Thu, 27 Nov 2025 09:12:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF5E6B00A7; Thu, 27 Nov 2025 09:12:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5086B00A3
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:12:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E94BF1A01A6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:56 +0000 (UTC)
X-FDA: 84156578352.12.FB5E7FB
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06D5CC000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZiFgGK50;
	spf=pass (imf22.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTb9aibo/K/jflPv0dS9O1eEwweSl7PPeR+/A9D7hw4=;
	b=EBCTHjT4j4nJtPlSgeJjzur/0oLJhsRFpkUmfTwzgu62/W9yq2ffIZ5wU3dglVXZZahR+G
	4RBjCx22fCkLDnFWlqsWX69RpDHC1ZYeTPfYR5C59MdRTuokugo/Y9VDSfkzvLSPfL6xlE
	yUx7X/jPLgUXt3er1cyWIOL3/uGOTTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252775; a=rsa-sha256;
	cv=none;
	b=K7Z8Y9xfJnZwpUqqYxHRVXbDTAJkeav+wmICQh+ZqPmzQ0+AMm/NMIARdKSt08C0Hwd7wc
	byyitLI8+7LSBSsNVJRbzQEZO+Juwobi+aaugjOfPzdgEUHQr+tYqz0i4GwB/4aXayDMP3
	8Ku6751Dy4yQPrLSTcyb5yw5rZYrXXA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZiFgGK50;
	spf=pass (imf22.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-298456bb53aso10601655ad.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252774; x=1764857574; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTb9aibo/K/jflPv0dS9O1eEwweSl7PPeR+/A9D7hw4=;
        b=ZiFgGK501gt9W79fRn7JtCHL53AE1PByFEX3uAOsCNmYXB+1K85pXdj/f+Tt9tVG8E
         x6MU9ntZ5pFubjLaWLBauxSRFPqjr6harSWr3slfZ29lsYNZrnORqAW53D3b1xI5KqVi
         X42vBV5m9lQRzHwJ5dF62gdgPP7WUUdoNcIW0Z88K7r131+LkJXH9gRsB/yfSYhg6lAb
         nv0PqY+kA7dl6o4XNx5ov0r5NLsk2FLrqdZ91ak2ZRaKtnPPjInCrq9oPTZ+MyZp8AAX
         Oi13C9XE9fbwnKatLUgBKiYfYu6mVTrXsQRdmHC/RoEZzGrbnYKNN2qiiMdO2H06ZAPc
         agMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252774; x=1764857574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hTb9aibo/K/jflPv0dS9O1eEwweSl7PPeR+/A9D7hw4=;
        b=B2GdYx4oaLKh8k4D/va+aAfzfd0zebgBNePWRAxccHm4vXcEZMV4i3NfhkjRRAVWuC
         A5bjSw9B4X8AaXd4QHEPw8mUmC14ECw+UOSCpx5O72mODUH30fw508M5H2XquYp8tEFf
         3HQGZlglVGL06oSYq1CDSr9E/9QnEuVrsXf4cxOxfHWyuZ7lVmXai8H7LHRYaAfnCoWJ
         DSrLVJIKA5Er/Wz0vPeDFNu+ZDu2c+7IHjBlN4ZQwYbZ5+qe6yYp8lqZrN/mi2W8KX+L
         O0uYxZttgMJ4M4zUlDy2vyAsKAfS46uSEepmiHDhKQTgbXsuR5lPrZOCKYi4nDhzqbVY
         md3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUdL5o2xeOpAE/OLUGrRZ2HfG/Tj2E7Dc40FJODZBN/SWiJPCG7BwArYHN5rT1jSApGt0Y3QWRiXg==@kvack.org
X-Gm-Message-State: AOJu0Yz2y4TPTyts8xeKTlFGzvXw9lV8uh/dTypNynnYtAwGbT9IEOM1
	Nt4ExGRonLkUHwAoWRBPgfsMVb6beXBWjlXzruZyk/jPxv90j+DHgJ9G6LbL8u1cO0k=
X-Gm-Gg: ASbGncthQIqNOGC0Yj8iA6NqAI1AVtuN+HCTKU6FkbLRHzwYmUjWqBsHyCkI4bmkp9W
	PwH2kYCWX/6bPvVOwWj24RXMVxy4v7dzTAFRuqebLyoVef3cxOO/l4mjJbSzm4REOHqc7i0JG/t
	LQuDIIe2/DCkBkb3dbxyArdTe/E97pl5MyDYGa380TKB4tlqC+rchY+V+xgtmYHHOGWe8mT7kN9
	KG2e6wfkcn2/NmNMUpt7G5WcZnIAv2bkwyyhHcy+5vinNErfYu78mDBPzDkEanYkpjk1dTxe5Uj
	0L1bFQRn1i9U/yLRUzZUvC13BSpqFSwILkJhkMfXrdPZ+SiVTGHICO+/9I31zsHX/MGWwb/aoUt
	yPBpNx2JTUyRTEt6OEskjIseqqdYW2c2ua9P3k8FsAUE7ghBeSHrSZkpHEaRd64eVTWHjkhk589
	wIC5CjIjRGJY6wlNZScVG0/RNqBzE12Vywt3yV+U4JKI8fVDFVqtdZoP36SF558lCYNty1QD5xA
	YRi8yjN3CAk
X-Google-Smtp-Source: AGHT+IGPqPAMlGbhX5jEp4J3UbDXeLl8BWDll8WVzM9luwXo+j3LxoGVrUXUo4r4lcoq2Ou8dpHZEA==
X-Received: by 2002:a17:903:2c07:b0:295:f1f:65f with SMTP id d9443c01a7336-29b6c6865a6mr282588785ad.31.1764252773816;
        Thu, 27 Nov 2025 06:12:53 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.12.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:12:53 -0800 (PST)
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
Subject: [RFC PATCH v2 9/9] riscv: mm: Clear mm_cpumask during local_flush_tlb_all()
Date: Thu, 27 Nov 2025 22:11:17 +0800
Message-ID: <20251127141117.87420-10-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127141117.87420-1-luxu.kernel@bytedance.com>
References: <20251127141117.87420-1-luxu.kernel@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 06D5CC000E
X-Stat-Signature: cd17qwjx8fto984t4cyo5f4ecsmjmkng
X-HE-Tag: 1764252774-209356
X-HE-Meta: U2FsdGVkX19+lFFE+FuTsihxvK8lxC296e50bJ4kyFp78DFldGWHWHYqMWGInqgACizYDecGlawxcLVMk/bW/5xqK0YSFdyRPfKWWGCnUa6zpAXnlaJOhq8wabe+RDAEp2TMvux4Guuiu3G71WR4cf7fDwJq/jTyo0i4dmJlI4+Ie592cHF+G2wihgQmlglKkJfI3DUrJy8I90DrD/hQndP4CU9AH6RViL1ofsztajhPtehJ4TbhFUHE32yLRJPtNUh/4XCPf4rKJUlWmieIezuSMUhPabFJ3CwRz9oPsr8E7ejFF8h7sKWznaAF+SaAmLnJBNaBbORWThfsCsNDgQvM+9zx3lnwlm7c7/vCCs0ObTiKgD+/6/WGh6CdRAYoDkYI8cuMHMSo7tXD3TsjphVz28ofixPAgNME7f5budHmKPcSlXkpeJfFYdS4aA8v4J0Yyp+al4dlRVpSf1rdcgT1G0VjKniPQ1xhCWYr5oQpDoUybVOUmCNLaC6j7MHrBUNsMCHx/Og88Sq7DtVMreeNF/hoWuju2QJYgqIVqxU09rDOrAw2GFxD73odUgbxvB/cwfW4IMK2Kow2eVurqzj7TzAAhVGW9s6QkoFvKpTmSbgaNY1reiPAI/MQw4u4WW+t/mF3eY0L1i+B1zRxPh4SfVPalp8qs8xChnvnrL07uqwWh9Ah8UKzabkJoDeDwu73S1S3JwscFR5RyKG71DplVRD514UwEiljMcEbLZkihdQVojthWc4KU+HtsY69EpL9DvCNp0wBjhdzYk2yEoOZL0svV0DvQo9o7cDrHyCoQwMdzgpm5RgeA00zMPWdslKYn0em+xUTFPLPzYUFAJ1PS7g5Yc2CNZs98217VE6UeMSmQHlQwElhzhEEvQ8Qnnbih6NsZ145giepYAbMhh5dlgDRugp6ZIMh2u0ObnkXBpC9f6paV3cJlxjfzX7vaisxEj2vsPBBb4GJifl
 EMY0oIr1
 MTpktFUht6j1VKa+XtvGOik+KI1p22uXPNcAhI4H0uN5jh9bKd25ZINjK3CwuGLsDTn6Nf+wbNXbjuYNVrsWBNiJNY2bnCoEjOIux4CQCzz9VA+nHdjvE8tsh3O5AMFw42Y9DTB0XdJzmLCjMHUYdbgMW+KOD2OhFLiBQ78UbUGXJcs08boJ/E+J3EO2nwLBkh4oGy/a/rzGUaNSgE1WpQ3LpvejdSzaI9WhEZTUr27CxSzBicjqpEH8aDzR8YfSX8CucYv81sOJJ+MX7vyjjr3VZbjNiEko32v5U7Jw4dyRB71HM2jdxjzW8Aw98RBUT+eOwyEDzfJ3HhZHIv8AnnC+l0u/uPTlnJnsMY1wQej9mSTJxlQqfQ1rLep6PCF5ohG4ace3Nwgu8RCk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we maintain an array of active mms on each CPU, when
local_flush_tlb_all() is called, we can clear current CPU in the
mm_cpumask of all active mms on current CPU.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/tlbflush.h |  6 ++++++
 arch/riscv/mm/context.c           |  2 +-
 arch/riscv/mm/tlbflush.c          | 31 +++++++++++++++++++++++++++++--
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index c9630267c58cd..fd62b27172d4a 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -108,6 +108,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_info, tlbinfo);
 
 void local_load_tlb_mm(struct mm_struct *mm);
 void local_flush_tlb_mm(struct mm_struct *mm);
+void local_flush_tlb_all_mm(void);
 void __init lazy_tlb_flush_init(void);
 
 #else /* CONFIG_RISCV_LAZY_TLB_FLUSH */
@@ -119,6 +120,11 @@ static inline void local_flush_tlb_mm(struct mm_struct *mm)
 	local_flush_tlb_all_asid(get_mm_asid(mm));
 }
 
+static inline void local_flush_tlb_all_mm(void)
+{
+	local_flush_tlb_all();
+}
+
 static inline void lazy_tlb_flush_init(void) {}
 
 #endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index c381c4ed46bfb..b6657681948f9 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -194,7 +194,7 @@ static void set_mm_asid(struct mm_struct *mm, unsigned int cpu)
 		  satp_mode);
 
 	if (need_flush_tlb)
-		local_flush_tlb_all();
+		local_flush_tlb_all_mm();
 }
 
 static void set_mm_noasid(struct mm_struct *mm)
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 88a1e45bcf508..73c0a7ef61cb1 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -89,13 +89,13 @@ void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
 
 static void __ipi_flush_tlb_all(void *info)
 {
-	local_flush_tlb_all();
+	local_flush_tlb_all_mm();
 }
 
 void flush_tlb_all(void)
 {
 	if (num_online_cpus() < 2)
-		local_flush_tlb_all();
+		local_flush_tlb_all_mm();
 	else if (riscv_use_sbi_for_rfence())
 		sbi_remote_sfence_vma_asid(NULL, 0, FLUSH_TLB_MAX_SIZE, FLUSH_TLB_NO_ASID);
 	else
@@ -461,6 +461,33 @@ void local_flush_tlb_mm(struct mm_struct *mm)
 	local_flush_tlb_all_asid(asid);
 }
 
+void local_flush_tlb_all_mm(void)
+{
+	struct tlb_info *info = this_cpu_ptr(&tlbinfo);
+	struct tlb_context *contexts = info->contexts;
+	struct mm_struct *mms[MAX_LOADED_MM];
+	unsigned int cpu = raw_smp_processor_id();
+	unsigned int i, num = 0;
+
+	write_lock(&info->rwlock);
+	for (i = 0; i < MAX_LOADED_MM; i++) {
+		if (!contexts[i].mm || contexts[i].mm == info->active_mm)
+			continue;
+
+		mms[num++] = contexts[i].mm;
+		contexts[i].mm = NULL;
+		contexts[i].gen = 0;
+	}
+	write_unlock(&info->rwlock);
+
+	for (i = 0; i < num; i++) {
+		cpumask_clear_cpu(cpu, mm_cpumask(mms[i]));
+		mmdrop_lazy_mm(mms[i]);
+	}
+
+	local_flush_tlb_all();
+}
+
 void __init lazy_tlb_flush_init(void)
 {
 	struct tlb_flush_queue *queue;
-- 
2.20.1


