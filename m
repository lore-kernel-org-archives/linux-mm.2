Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C768FCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3756B007B; Thu, 27 Nov 2025 09:12:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A40E6B0092; Thu, 27 Nov 2025 09:12:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C0A6B0093; Thu, 27 Nov 2025 09:12:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02AFC6B007B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:12:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E07956500
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:59 +0000 (UTC)
X-FDA: 84156575958.25.824A4A0
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id A2E2714000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cFuWS9yg;
	spf=pass (imf09.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bT1DoFK44/mxXPszG1k06ulWEZ0r0zvum0ccrRfuy/8=;
	b=1dSAhK7lzXu7Y/EsxbmcM/4ZiSiXs4JU3W55AKPzZAwn7tOvy4F85Ovum9z4ms42UNHn1n
	mPgzodgF9qN6Jh1QZXWXYPhHXo/k+pBHxeCw65apo0+9ScGVLPlCsWiCNmVU2yqMugoBRJ
	GWV6WtHGEkAIYRkHCHat62WDsgCM9ZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252717; a=rsa-sha256;
	cv=none;
	b=mlxRGD6aNNpX9n1DG++q0mOarFLBaD82VC+OfRx4HLv4DqTproF8dWgKY3NWjxUcFNH6PZ
	CsmHvUwpN/p6eESJx9c7Uy4J4/UCG8dM7gHcReFLrw3wO0J0d6ue4bwbbklsvvA5IuUuzs
	+1avvtmdWDpZAdmIpdPR1wBWvLyTz5Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cFuWS9yg;
	spf=pass (imf09.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3438d4ae152so1013770a91.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252716; x=1764857516; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bT1DoFK44/mxXPszG1k06ulWEZ0r0zvum0ccrRfuy/8=;
        b=cFuWS9ygQ2XR7mk8nJCF1DMmrwd1wnQRTSsa8zvfmbmEGh/QSOaz5Dr5hy3hTx8/WG
         aShlOo2ZYqyyLsNMu5EV5nvXwgCth3XW7a3IvAoP2P3Y0YqL+b0s00vaFtw0VHF0/XgH
         sdHuBEwkDheXltHeQdfXlyJbztCr/cYMWbAemYgiRaEYuybfxAZAx0pQagEpEEDXR3kP
         uijDPWU2XRHgz0cDITF+iUS4aK48wvvINlocrYdbwzjeazCROjWXwh/3ymb4rGXBeEBO
         Qo/p0Qz6cjVplUALb88r6v7iQOyYqA1dJdD/cT8BCxUoFInU0Y4IQd1ZBy4DK9g1uEVM
         HkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252716; x=1764857516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bT1DoFK44/mxXPszG1k06ulWEZ0r0zvum0ccrRfuy/8=;
        b=blHya0z5hhkVzRj/cuiw3X9t5/qF/foA6MrwM0skP1s6j6jMApU4C0IETV9HCMtue6
         ADauxIYk59r6iv9711NSw8VsTZex2pOgEwbm904fdfiKq+OLnIIIsu6VV/ItOI0vN4uk
         p8KibH6yQ5VQNKYxIXuixt0X3Omrcaz2NjcyUPAkIaDkOGDzcMiIHxaLlmHi2pCNUGrq
         q9v/Bdd38NProC9lt4xhbDR+Ci4BX1PW4Z9ypHpxsaZJnqYaYAbBgPYtrqt9OPsdJ8RK
         m3y2J+YnsFr6P+okcXwHEqJt7SwfIKhCCNv+/Jch799EB2pwwXwJ3t/J/j32AqoZU5rq
         jt0g==
X-Forwarded-Encrypted: i=1; AJvYcCXK8T5Z1U9JbW352WD+Y8FPVgCtSGizD+Yq6URLJAOA1abGbGM8dZwpqYnBEIiZZfuquicLB09uQA==@kvack.org
X-Gm-Message-State: AOJu0Yx6Spo7EbWeDxACRZeFWVeJ8lorNmZRwhDUoMH3V5ZzquH/MA7F
	dmza1h03MuXi6zx+RJCcQUesjc0GsEo3LP+vI3jb40j71/sjnT/kPpjo9rAwVGxKK+s=
X-Gm-Gg: ASbGncvrd68lkzDdN5jxeVAqtVV+ZReBnnLYrZocfPIRMWmhdVu4tB60HJjXIO0trbk
	WvhRo1tVrVWWscVnX33mBaJgXyoT/HDGr+pTE+02uMFcp0W6k6SNyaKqjjswD53oqIIK6suadeT
	Qxw5gAkar978R+50NG/MAXgbxCU8VsVs3f9L2uUZordWFwiLcFoxAOnOO+8pyIoOn+yAV62/2/M
	ulpkbe0L6E4bQmUbbnauYHwf3/l9bIIcPcwBfbLE62ODyIh1JWWAnS9SBS4mZe1d5B7PHsTOHiM
	dHWg+9QFd3bTvol+RBg6yOtsgRaKxUBTlllGp3yORMXW4OeAtDSy6RwojQC8He3DJDB/40WUTW1
	dr0TsQNetcwS7dki6v5TYIDlp5dVGhvla8wg+b/U8UzzD2FZApDtz9YLSk55+PiV0H/LLVmazjN
	kfDyJez3HtEqfjUf7l9P91pvlHzR1XAwg2em55J8+aOozVE6t2xiYQbI60SEz0vWq002C6bkZmp
	0m7WDG5CcCE
X-Google-Smtp-Source: AGHT+IGHWS9mtIo18ykGEbjce9y2+tGQtCuaDp2x5Akdhl4bvcW7U6KnSKpb0r7Pzb23BFyTlkH5Aw==
X-Received: by 2002:a17:90b:2f4b:b0:341:8bda:d0ae with SMTP id 98e67ed59e1d1-34733f2de45mr22829266a91.20.1764252716195;
        Thu, 27 Nov 2025 06:11:56 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.11.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:11:55 -0800 (PST)
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
Subject: [RFC PATCH v2 3/9] riscv: mm: Grab mm_count to avoid mm getting released
Date: Thu, 27 Nov 2025 22:11:11 +0800
Message-ID: <20251127141117.87420-4-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127141117.87420-1-luxu.kernel@bytedance.com>
References: <20251127141117.87420-1-luxu.kernel@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2E2714000E
X-Stat-Signature: wcupzase5wc3qd3w9jchzrok81d3te9t
X-Rspam-User: 
X-HE-Tag: 1764252717-231933
X-HE-Meta: U2FsdGVkX19Kt0yMLTEbrlji/580Zr0BiKNk7splNkWPWUcPkqrhwp/r2cMfoBxC+cWsdwdSbFdvbkGqxm9YBk5HW+P96uoRKAASuc5G6pkBp7EUkUlRDNFVLlwXj09upnC80rw5P0XITIbL1PyTE0fVoniUO6Qf7nnwbcZdNZvyMwcP5v5oi/c0MLG4S1af3lOyaI2XtwnW6q93L7y/qSShi4HtjRxaD/FUauvwiL9P52GuTg063xJYTMOxmmhH5swX+pyBTZhelTCEogNKqprPDD8X5T8pbtmgnk1AbgWhkgVbxXq+FXPFtBMv3cUxfA/+I7v144sJWZKjDXhYYcBvOSvMCqSqD91b5WwP4RuAscMts8jakQOJgazEwaM9wBNr7vJ1dbJ7HTccOCVbCVKxPXj41kyAQcIGnsL11OLfiuZh9wLRi/62yrI+3C3ZuuoDHlC6W7nmUdNVZmqu6gbrZ3K14DhcWoR7zOgauN5yBR5dMWy3TStJLb+eiYziXweOfS4vmUYbogdqzWxaNQNfmEamCapaT0gBXIPKNV2j3Bbo2YcKO2+v5vHNV5m2wSSRBbwhuX9H4Cr3Ppq7wDewGVumlTQziyykbXJR6Hn3Btv5voWduul9vUgmx5fYWEoXHy8EclBWXHeHLFqjcfak3TelOBgMUwMPOvehhOxzZER/2lhegUwg3GMa1PAEfI2/kYut+8JXlfzfsNFGgOqm/5GH14Q0xVD4DyebdRbQXr4ZJkEU2aGVikcSnw7dp2158xvcolU77hGamBFaiHp5awqWEd2a82KLIuEtE8TLk/845bO1lDS7SNAmVGvKxnSY515pfhbieyB3mFJLRKIfW+ETS3Eo48V8XNnEiZniyr0kXp2nsnUVvyaD4vOLzmrsfFn+a8QGYOYDN2LB+OS62puNx3lkT9B370WNUor9jCz92snlr3bjXufIdKg0lmZZujaZn7vDCVGsNF0
 7fXYCFPL
 ix5O+84tnfcGIMMHeR7Fbl4ofcytYDw6yDZjOCSRH5B7LmrlKbHG8N/urrQMBwEsfevPZYaS0wFlLaxKEWcSBCtwMgIYjxve6sm22qWGoADt0WXEX8dThs2zJXBa+AdD90L2iYNTMuWE3ScJWgIhjyicJPiNhXKzP8wZ3aptUQg+EZU2zRR1rRAF0/IkBluaFpKqF+ej7aXKOonWXaPL+dNrjKSBZv/Hlq9TbZSikMurDUWaNum3S3Rg6zXKGqmDUr5F1xT6R5cAKvi4hb785uF87ipW1peuDw7UqKrjJSHyVv5F1B6Vsb8zJuT1y2Rr5ulLQ17GJg7WiASX1Ur0zBnwffSgT4NtV2MEE4zrPUZcQwFt2Nprdnp4lG9kTSJ+PT5HxnroBwE/phjk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We maintain an array of mm_structs whose ASIDs are active on the current
CPU. To avoid these mm_structs getting released, we grab their mm_count
before loaded them into the array. And drop their mm_count via tasklet
when they are evicted out of the array.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/mmu.h |  4 +++
 arch/riscv/mm/tlbflush.c     | 47 ++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/riscv/include/asm/mmu.h b/arch/riscv/include/asm/mmu.h
index cf8e6eac77d52..913fa535b3d19 100644
--- a/arch/riscv/include/asm/mmu.h
+++ b/arch/riscv/include/asm/mmu.h
@@ -30,6 +30,10 @@ typedef struct {
 #ifdef CONFIG_RISCV_ISA_SUPM
 	u8 pmlen;
 #endif
+#ifdef CONFIG_RISCV_LAZY_TLB_FLUSH
+	atomic_t lazy_tlb_cnt;
+	void *next;
+#endif
 } mm_context_t;
 
 /* Lock the pointer masking mode because this mm is multithreaded */
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 0b1c21c7aafb8..4b2ce06cbe6bd 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -104,12 +104,57 @@ struct flush_tlb_range_data {
 };
 
 #ifdef CONFIG_RISCV_LAZY_TLB_FLUSH
+
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_info, tlbinfo) = {
 	.rwlock = __RW_LOCK_UNLOCKED(tlbinfo.rwlock),
 	.active_mm = NULL,
 	.next_gen = 1,
 	.contexts = { { NULL, 0, }, },
 };
+
+static DEFINE_PER_CPU(mm_context_t *, mmdrop_victims);
+
+static void mmdrop_lazy_mms(struct tasklet_struct *tasklet)
+{
+	mm_context_t *victim = xchg_relaxed(this_cpu_ptr(&mmdrop_victims), NULL);
+	struct mm_struct *mm = NULL;
+
+	while (victim) {
+		mm = container_of(victim, struct mm_struct, context);
+		while (atomic_dec_return_relaxed(&victim->lazy_tlb_cnt) != 0)
+			mmdrop_lazy_tlb(mm);
+		victim = victim->next;
+	}
+}
+
+static DEFINE_PER_CPU(struct tasklet_struct, mmdrop_tasklets) = {
+	.count = ATOMIC_INIT(0),
+	.callback = mmdrop_lazy_mms,
+	.use_callback = true,
+};
+
+static inline void mmgrab_lazy_mm(struct mm_struct *mm)
+{
+	mmgrab_lazy_tlb(mm);
+	atomic_inc(&mm->context.lazy_tlb_cnt);
+}
+
+static inline void mmdrop_lazy_mm(struct mm_struct *mm)
+{
+	mm_context_t **head, *list, *context = &mm->context;
+
+	if (atomic_inc_return_relaxed(&context->lazy_tlb_cnt) == 1) {
+		head = this_cpu_ptr(&mmdrop_victims);
+
+		do {
+			list = *head;
+			context->next = list;
+		} while (cmpxchg_relaxed(head, list, context) != list);
+
+		tasklet_schedule(this_cpu_ptr(&mmdrop_tasklets));
+	}
+}
+
 #endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
 
 static void __ipi_flush_tlb_range_asid(void *info)
@@ -292,6 +337,7 @@ void local_load_tlb_mm(struct mm_struct *mm)
 	info->active_mm = mm;
 
 	if (contexts[pos].mm != mm) {
+		mmgrab_lazy_mm(mm);
 		victim = contexts[pos].mm;
 		contexts[pos].mm = mm;
 	}
@@ -302,6 +348,7 @@ void local_load_tlb_mm(struct mm_struct *mm)
 	if (victim) {
 		cpumask_clear_cpu(raw_smp_processor_id(), mm_cpumask(victim));
 		local_flush_tlb_all_asid(get_mm_asid(victim));
+		mmdrop_lazy_mm(victim);
 	}
 }
 
-- 
2.20.1


