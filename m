Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B27CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036366B0006; Thu, 27 Nov 2025 09:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F285A6B00A3; Thu, 27 Nov 2025 09:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9746B00A5; Thu, 27 Nov 2025 09:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8F2A6B0006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:12:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 949CC13902C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:51 +0000 (UTC)
X-FDA: 84156578142.17.C79FCB8
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9FBC7160015
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FFRRUHiX;
	spf=pass (imf08.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6POrY+BMUj8HO1IGB0lZ0hYE1ONoquBp43+FVGHg3w=;
	b=NboFWujP9kONfWcsVJQ82D2ASW6N1RwWeoST0s/KZa4YY99ZaSB2HCxaapMwCR4r/7txZv
	4kTqT0ZG1U/kdFK75WLJIjSkTtK7pIf5G9TD+77pINH1PwwukP2d1l/aK5caUuAjSE2A9B
	agIebnCHgz7+5Owf2iFO28PH+og/IAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252769; a=rsa-sha256;
	cv=none;
	b=nZm2o72/YvST1UGiaq8FXaL6QvkW5U7x9tHjBq+VYp31wfrzExBS2O+vMkvRZceAiquyWJ
	dvubALP95A9nmzB3K+c1qnsROrfGN9wYZPE6fpmabGYDUjwHeRjZVfgrdTLfjFw00jtLiA
	OwLByhaVinXiplNcD8ojrxOnymmTgKY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FFRRUHiX;
	spf=pass (imf08.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-297d4a56f97so13007335ad.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252768; x=1764857568; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6POrY+BMUj8HO1IGB0lZ0hYE1ONoquBp43+FVGHg3w=;
        b=FFRRUHiXyF9ElbeuyR1HxNYIJPCN/Yzfg/SZukI6ptsf97EJTtbAvzLq2vI5G88Q2O
         V7G/+I4JjdnP0jbjxmEx2CrGSJrc0KZezoasUNBASjy1I7Y4JJwrSmasjGNjRV+CiLRJ
         +tbpqu/3iIUN1Ugawz6HmesxO7QP+/B64N/95Hh0WunGmrCjI5BOQtbuitmfoZsCQH2I
         MrAK8MTiiVLezpvMrsUueB+Oyig4JtlNMqBEh3X6zzDzpkvLtAV2kivo6Sc0EpHx3AuY
         mnHTwqxooGHkIUPM5ZqxrSik5n7uOHBfrf/WmsKyXA7jeDYYN4NH3TBVDELs8SoqMTmG
         1TqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252768; x=1764857568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y6POrY+BMUj8HO1IGB0lZ0hYE1ONoquBp43+FVGHg3w=;
        b=bhIsFwObG2CwYNmdB6+XfWFvo3KwWAD8MGbyngVkhwpCQVEizc/cB9lJbFTppu1mKR
         nhAqCRXV9bGV3yw2aUjpSjD+dRLSarw48Qhq4P91MiDN90xjCfdh9C5xPmSp0NgTx+hs
         7lKPjRoDunQiSvhK2CrOOPoqcFTysPsU7NUclYZzmTWR6NZaKJGTbnXl8RuwdeF1Kqol
         aHpxQC/HJfo7/99i29D4aOwn4IQS9vkmqIahTpaJMgAzhtwT9MRyLjUf0gqCrmMtBmrj
         6JJzLMWZe3ufVbXB2rddrvoMyghd9yTCiDw2rZyJaRM6RK1AUjDAzd/avJyujKEXRj77
         KnOg==
X-Forwarded-Encrypted: i=1; AJvYcCVLknTc4gaa3qt0TqKW7gFDFMQFG+hTZ4IXC3iXyve/FID61rEBeof9Cm8LT9U8x+t3Ad0Ef0gMlg==@kvack.org
X-Gm-Message-State: AOJu0YwjE5fsnuguuRnpVj5EYZUHIajxFG+NMCNlbHHCE692aFn5+fJl
	lNRI4GrbYqkO54WWWOdWhF+Jmog1ynuB3FmmAntd1yD8w3waDszhBm4CRL/xTn4MCc0=
X-Gm-Gg: ASbGncv7S/hd1eTdx0YY3BBQU2aEGn1f8h+8AfHptmFjrB+YJ3oYbgnxFUhjVn2CzIO
	z7n9cXPWOfm8dCFEtUpj8Ac6kbqq8YWeM7SP0L56q3n50Qe/eYnqAgODAxoMjv52pDPIuo1pdIF
	R49JI0klvRxOxHBclSkhs/djmlzYX1Q6yEkSJeAl7s0Sm8pA0YU7UA95sJPLnJ60Do9AKc5G7Tv
	TYu1CD3rc6F2WmGhtY/sTxNw4JNWrnd5H2gIuXYiImrs4gzvSYFnrg7g3SbT1wkLoew7FRCvYCi
	0sHEhzZwFeFqIkREd0MoL8oa7owloam4qow+mhZMvIG28EG9PXFcPD2lnlp9DZn1drptKQuSlhJ
	+OCQ11k/y6kNDsVxbqoJxrzQhXJoof3iHAbtjuWKxeUsbqFfP2f2s4COF2ahy1RKLfrvE5rHf1a
	mjEYlN/Vg2VpJWOZzIQVANkmiyoEJdV2DBxLjLp5Z65tCXP42OfBF74OjyAX3tVPxrn0YlT2g/j
	w==
X-Google-Smtp-Source: AGHT+IHvUpXCjjZYwqFKdgiDcxzIag75+OwjgHS8aOmS+l5BTWC/h8DmVKdTYaMfKXu5VxrbnkaKrQ==
X-Received: by 2002:a17:903:1af0:b0:299:d5a5:3f7b with SMTP id d9443c01a7336-29b6c6b87bcmr256617355ad.53.1764252768286;
        Thu, 27 Nov 2025 06:12:48 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.12.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:12:47 -0800 (PST)
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
Subject: [RFC PATCH v2 8/9] riscv: mm: Clear mm_cpumask during local_flush_tlb_all_asid()
Date: Thu, 27 Nov 2025 22:11:16 +0800
Message-ID: <20251127141117.87420-9-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127141117.87420-1-luxu.kernel@bytedance.com>
References: <20251127141117.87420-1-luxu.kernel@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9FBC7160015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: c1tkd7pfrshhaof734nbexi4gia6ntj5
X-HE-Tag: 1764252769-914032
X-HE-Meta: U2FsdGVkX18WYpI6LPnKTK1UpxXYqFyUiXIQj3Jxfnom+DQa+jWeLPaKDdOlJxKMbtgb/tYXHygZYoAlwQoETvHbl3SVU3Cxs9j4UW2nuNVPDHivlLGsDLpTiQWIOkVVOdNY8r4DaRtIbNl6oFMH8FR2v7UWOBoDpt3gp/43AbQuj3lJTCXYW4QvsY6v4us2wP1CaDl71kni4HHe8wCA3cdN8/DOGXsXF7vcUYG6CeRgR0N7DZ5IhfJHvY+wGkCQnWZcrzrnObfSnPc9jzcFaaoqnaqoJ1CjmfXT0PIjDBqaIU/cfyf3P0x5rLqZhotN9Wg1SSfJ2N5ADvysjonT5Xgxy3hipxcev+NGQKGuio80xf9mLfGG7LLeTx3du5PcImxQZwjaKKsKqMNTrhDnaU0zbBl9Jg4KQd/v1Mzb6geMGFvZDaqwuJDaruQ2cVecF9ydZMVSquWB2Dn3FvsLVSspGESFlDVhP4exfkjvf0yANOlXrLX8qvh1X+HQrVYm1MS8rkWZx1XVuD4N8Ymx1CS5saZcvQFYIJwuSGGn0kRy1082MKRp/WZO4Y+G+P4c34g3jfljf8+E2h531Ydc1yv4y2Zk6MOKAEyLE5EFvxyKlO6qn9S1+3ya36tbzA2VbQIS62VByGPP6JaZj1JkNPXSkKHXEPhhHB3C71/b6VyXHwCWcl1uZDPRrJqSTwDAVEMSGy7D/r5mXaUL+B9KUJiOVoa1NHybE4yVcyz1CboObGxBDrE1RYKfMvsBmyRmlRYX7dInSUWD4fxd+UjXvbHAQeVHGe0s0jto9rkqZVXK+kNmX9cN+ai6e5YOge9y2XGDHQEFVjBqPW9C+Hg3guYqjaD6tGXiqlNc/7jCXC/2AaHkAhPiP+13P+8ycpysh/yllps53Bk1N2g/HSqQ0howeSd8GJ1C3fIAiBVcPts+V4FzIEdyr6B1LuNq4zpBnG/9W30d3SjCNF8Uipu
 SuCcqF2e
 twoxAwLTL303mj3mLveqQCG4rb3HI1U5/wA68TCzxWbKznC09n/wrrlRQnr0SV7DgIF84KtQ6vBny8ogASd4jp2SXvt56euR/GYUT8gxrnRzsuqG0sM/vag1Sb6tcKvxD4meZWMfmwDSFokFCImz7T4M5dJ1uLUrCjL2i/lHZqJwqp1c+p+KuZFWpdEzjibz7gi5PsIi/Rw3QJDwPLGrQgGRY5J3FnzE0IRZZr+FMlsUueiNwki2PwPEH8heLLjWU3+DQB/gvcXpd95qJzzISLUCfkJITzrwO5vEJcxeeGpzJqGMyeLkWDdylWqdazCmk34/Gj3Xm9SibUQ/6JD7rB15yo/2K9qqwiqsWA1EIHedSkNNmUMqT3XwJstRA7zjgv7Wp4ZZPiqF0fzQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When local_flush_tlb_all_asid() is called, the target mm's TLB entries
are all flushed out, then we can clear current CPU in its mm_cpumask so
that next time the mm's memory mapping is modified, no IPI will be sent
to current CPU.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/mm/tlbflush.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 0083fac87c2bc..88a1e45bcf508 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -35,7 +35,8 @@ static inline void local_sinval_vma(unsigned long vma, unsigned long asid)
  */
 unsigned long tlb_flush_all_threshold __read_mostly = 64;
 
-static void local_flush_tlb_range_threshold_asid(unsigned long start,
+static void local_flush_tlb_range_threshold_asid(struct mm_struct *mm,
+						 unsigned long start,
 						 unsigned long size,
 						 unsigned long stride,
 						 unsigned long asid)
@@ -44,7 +45,7 @@ static void local_flush_tlb_range_threshold_asid(unsigned long start,
 	int i;
 
 	if (nr_ptes_in_range > tlb_flush_all_threshold) {
-		local_flush_tlb_all_asid(asid);
+		local_flush_tlb_mm(mm);
 		return;
 	}
 
@@ -64,21 +65,26 @@ static void local_flush_tlb_range_threshold_asid(unsigned long start,
 	}
 }
 
-static inline void local_flush_tlb_range_asid(unsigned long start,
-		unsigned long size, unsigned long stride, unsigned long asid)
+static inline void local_flush_tlb_range_asid(struct mm_struct *mm,
+					      unsigned long start,
+					      unsigned long size,
+					      unsigned long stride,
+					      unsigned long asid)
 {
-	if (size <= stride)
+	if (size <= stride) {
 		local_flush_tlb_page_asid(start, asid);
-	else if (size == FLUSH_TLB_MAX_SIZE)
-		local_flush_tlb_all_asid(asid);
-	else
-		local_flush_tlb_range_threshold_asid(start, size, stride, asid);
+	} else if (size == FLUSH_TLB_MAX_SIZE) {
+		local_flush_tlb_mm(mm);
+	} else {
+		local_flush_tlb_range_threshold_asid(mm, start, size, stride,
+						     asid);
+	}
 }
 
 /* Flush a range of kernel pages without broadcasting */
 void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
-	local_flush_tlb_range_asid(start, end - start, PAGE_SIZE, FLUSH_TLB_NO_ASID);
+	local_flush_tlb_range_asid(NULL, start, end - start, PAGE_SIZE, FLUSH_TLB_NO_ASID);
 }
 
 static void __ipi_flush_tlb_all(void *info)
@@ -204,7 +210,7 @@ static void __ipi_flush_tlb_range_asid(void *info)
 {
 	struct flush_tlb_range_data *d = info;
 
-	local_flush_tlb_range_asid(d->start, d->size, d->stride, d->asid);
+	local_flush_tlb_range_asid(d->mm, d->start, d->size, d->stride, d->asid);
 }
 
 static void __flush_tlb_range(struct mm_struct *mm,
@@ -222,7 +228,7 @@ static void __flush_tlb_range(struct mm_struct *mm,
 
 	/* Check if the TLB flush needs to be sent to other CPUs. */
 	if (cpumask_any_but(cmask, cpu) >= nr_cpu_ids) {
-		local_flush_tlb_range_asid(start, size, stride, asid);
+		local_flush_tlb_range_asid(mm, start, size, stride, asid);
 	} else if (riscv_use_sbi_for_rfence()) {
 		sbi_remote_sfence_vma_asid(cmask, start, size, asid);
 	} else {
@@ -410,7 +416,7 @@ void local_load_tlb_mm(struct mm_struct *mm)
 				start = queue->tasks[i].start;
 				size = queue->tasks[i].size;
 				stride = queue->tasks[i].stride;
-				local_flush_tlb_range_asid(start, size,
+				local_flush_tlb_range_asid(mm, start, size,
 							   stride, asid);
 			}
 		}
-- 
2.20.1


