Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC44CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230126B002B; Thu, 27 Nov 2025 09:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFAD6B0092; Thu, 27 Nov 2025 09:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4B86B002B; Thu, 27 Nov 2025 09:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBFB76B002B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:11:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80994140190
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:53 +0000 (UTC)
X-FDA: 84156575706.11.65B9926
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81AD710000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DKcNVXt8;
	spf=pass (imf05.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGHgnOknc2HR28gygrywMGZEYzdqi18gD0LqvxY1V9E=;
	b=pSb9hU57Ut/HI8CMk+O8u8NSVkeXVNu7iDq6AcLgYu+BAQdZzLkimE7W0+HT1/5Dc2yrkS
	LEzAGsSI5pTDRLjKnjCpJcRNiElkda4jUdW04GIN6mGYhMm2kyqE4EOuohW2uW7eB/Nxx3
	c9Ti8fWNtYP7J8RKXwdxSIqCLFFNd2o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DKcNVXt8;
	spf=pass (imf05.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252711; a=rsa-sha256;
	cv=none;
	b=VbJgUjYBaoTCHv4AzwJlnXuXPSDXqnBU/SbwMgxkOmnwZts2ErNs6IJX4ZsqCKmHLx942M
	4Kd9XBKl6B1p4VHwaYrQCCpn67EF9tY00YpWP8RuJztEFGmjgKbojwnX8buJLpLdFyVR8e
	MD6lED2GWe6cCMQ5xkTeouZ/b/aAcrU=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3436a97f092so1087359a91.3
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252710; x=1764857510; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGHgnOknc2HR28gygrywMGZEYzdqi18gD0LqvxY1V9E=;
        b=DKcNVXt8xK1c2azuxd/M8G/zIvagnV54ZYppEMoH8nOGXl0GAMAHU7b9wS4RBxH1wm
         V0rnNKjlQbysqdQuyQGMN065X2nBXsOqWASQxP2/oL5AjVbM4Sl33ryguL19MIXh2vqn
         YIMVYrTSdYVyPhMBqoKWqRR00JBuDvLAktHi35oE85yDLKnEoI4OXBEHe7JlZhI08BS1
         DSK/v0iS1pFE8XB4kh8MYlrNGu4jresmEY1EQX8BRdDEPlldQLW7JSQ9VNicp+QFpFTT
         RLuLdgQ7KOc8ix2BcXDJMqdIt3fdklwnK/hxyVVZttIrY+7uFW67XQK3E44xjQ6f81HQ
         n2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252710; x=1764857510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OGHgnOknc2HR28gygrywMGZEYzdqi18gD0LqvxY1V9E=;
        b=A36zE0Cg29ArLFR4GS0iigKQg7MSMrRx+z1Poir9+VFsC2Wqh6c/M9O2BqbqR23Anz
         QJdGQ9YhsRBpvpOOu5uzUDWPL5Zem9xslHlEXuxgnVg0JoKKMUsCv/XwjtyUp1Qfsp+u
         J8f/PAiXnDqQFrT6XxdH0DubtJvHnEulJBiJR80mGx3eIhEqugZpA1u2OfAdyF3FQO6u
         wqy0E9+IygaOKtm42oWqFlXRSHn981CN9vuDGcyGeoLYtKz6h/SAtK6fNVuUiejH5tJz
         Jt4eRh9aCRVFjJqNZ0cEVBpQBvODwodmMYmefA7H2AWathLt+ByX8DjI+yPoDR0w9H2R
         zhGA==
X-Forwarded-Encrypted: i=1; AJvYcCW7Sctv92bv0KNmWrfBORsbVhbgVBBe9NgrNDySkDwVrYA0FPWU2nzLjpHto8J5LCZq7VmXdsRTaA==@kvack.org
X-Gm-Message-State: AOJu0YycH2RyhvwQdps6/7bsDrSQ1zEKwMc4gi8QZTGUtW8CGDXDJku4
	FpZMkhkE40B55xvzV1dVdpbABvPLOcmSjAu91X/vfdlpecQfovOo30N/AtdSLu/PFY4=
X-Gm-Gg: ASbGncvXmWNgG34bGQ9WLc+EI8R9cRHtRrnaWxocDX/PSndcL+NuxBhsgs1Nb7ksmyN
	XxGY+NPU6dqpr3VTU3INfCxkgGqLKfnWFanFzh2fSDhxXYTBrB1opuutp2OCib7ZTbC+RqI/6Nd
	rgYlUqt2MwQBM/aA/VoJZSM6osBnBrCMQlDE+H0yyDzziTY4gc1gHMRogoKl3dnkmiEHDIex3vg
	ZBU3CKhVxUQYHUwulEsWxM0BbR6AhWxgC2sgJC3G98O0oz8ezruuWJRCGnlw8AEhl9ih4VmcnpZ
	D5WeFQhYUJtceLpa88qjHYhyQ2+oDQWv+EIAIrh6t68+z36DPjNs4yx22JHJQj2f1eG0Aqz5pmr
	Ch4LNh4M3GYtj6/Aaa1HhXuOoxRs0w+Gdtj82sDd5pkUL84UdiiaTgV4qckZzef/EPl/F5U0xiW
	2tv63wn263GvAgN1LFBv9BgUxm1NqxXCRzdrR4V0necaTEeHHnMNh9eD9Aho91wSVO7f9DvxYO5
	g==
X-Google-Smtp-Source: AGHT+IH9shCFmiY257H7nfVJqHK2TfMQ1cqSxBQ+VJIOMrKykl/Xamof7TK0iwdrGZLERz9FgKIyJw==
X-Received: by 2002:a17:90b:4c8f:b0:341:133:e13d with SMTP id 98e67ed59e1d1-3475ebd2d92mr11210465a91.5.1764252710205;
        Thu, 27 Nov 2025 06:11:50 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.11.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:11:49 -0800 (PST)
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
Subject: [RFC PATCH v2 2/9] riscv: mm: Apply a threshold to the number of active ASIDs on each CPU
Date: Thu, 27 Nov 2025 22:11:10 +0800
Message-ID: <20251127141117.87420-3-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127141117.87420-1-luxu.kernel@bytedance.com>
References: <20251127141117.87420-1-luxu.kernel@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 81AD710000A
X-Stat-Signature: bhm4q89ue1w8xdukmnxzws5hinxny1ru
X-Rspam-User: 
X-HE-Tag: 1764252711-647477
X-HE-Meta: U2FsdGVkX19mGSkReGqEoCmyczY/vcA4hHmyT3/Y/NjdDh0P3dYW8ysx3aMP+gB6ZTwxVKoKE0i1x8j3PAgzTs+8QOgTCcSoiYLXUjBXap/6bNzM+FYGSm2Mna1pcG5N5CqqvW3qiG5YU/+9jbjEYe4/c3lK0+VVIqsxG5x1IF3wGvVbKpyBMxGh/niNo8wSiP1CuKOPKmtCoqXPU1qDWQqV1shutLH687OFqFcYDTc/r+TKz3dEkuq1WWHrEzeSiueLHEM1XcXGfYrE1K00f1coob/Apdmo4tqGqh3NOse7xMa7asa7Y6Aj9L8CuxK2tBKuiuTaMAb9kVFKhTbOip5FOU1YFIJGrzhwyd271HpBQGjIyvZmeFR31aNq8U7Dp+kZRfyMgFjgJ4v0/Is48Y3dRwVURipIPpXQLUK4JoFEerA4PnkqnnL6d7cSuCJ/wf8wB7n1KRJBlTR2ZfpMSPxZJ8YHZ6C3DQz9AP5V1Om+pcR/y+VGqdr9QJ0B/rY0vxHfMHH9S4l48FVFn4ppRf7KSAi9T/PZQGLXHVL+so0YO0pN19uJEjKdxmjKgJSRU28qOXln8rD5Yy64R1uqnQvV/fJH/0Izjnkz6WM+5fpFRtTrex3h7I+I1EKmLJ9bYQrXyofApv6hSeQLMAOC/IYhOguXxKCmi7teCgks7aP7D4b64jZAhE2J7IsSiSr256UhweVXWojnDemX23FAtT8K3Jxmfd4PB6EnVIKmjy/1Pr1Q+s/Kv7uswIcNUFOYmWwG7YQU7HPZu779IxC//Zk0RzPheyCSR2H24vn9jQevn2Q/7rvB0642/qlr0+y0bW+GXfvKI29f+jdFRC+HTtwGZxzWXUz5qUHDKCVWtk14c/FDv1Mnte7wwTN1vbNoCbse+i7u5haXjlACAtgfzKi7S2N81unoRP1Ssz60rA0oca7rtBa+Zi9X6b4cum13jg3rRaj4KkOX6k5e7ll
 1/fFmeRZ
 W87TaS1L9ayzm0hZlZYHgPNm5Y7LEu21lmGOl2/efNMInD8K3ImrAIkDIc81V/7Z5MWXmAlMoZ8x3Ey43QTEZWoiy+aAzc7zM32d9S53Tc1T+uornimJGizqoXB05Q1ldxLlGUz2lv2djfXGEgBfJO23/0rkwdLR/3TfUoTWhwBXxRyiyQW1suJPhG0qxBuGMX6moW/4vEG7GJXEzFRQUU/SP92bUdr/4HHhSslQrXXPxW8bqkwunZywFQ0rJmifszbDqmpP3QthwuWZAmRiXCl+D8Lkoz8ZZFHUOXA4hHr4yfbu8J12lzXettkxOPXiH+26qU/umJxm6LcESBF5Ftkw7fdTYgtn9TLlSUdvw2Lgdsur+FkxNkqni4Hs46ceUd08+0dCdnhwcZwtJRLPdwVKg/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since each CPU has limited TLB entries, there exist limited active ASIDs
in each CPU's TLB at the same time. Thus we apply a threshold here. When
a mm_struct is loaded, we mark its ASID as active. If the number of
active ASIDs exceeds the threshold, we evict the mm_struct that has not
been used for the longest time, flush its TLB entries, mark its ASID
inactive, and clear current CPU in its mm_cpumask.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/tlbflush.h | 27 +++++++++++++
 arch/riscv/mm/context.c           |  1 +
 arch/riscv/mm/tlbflush.c          | 66 +++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+)

diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index eed0abc405143..3f83fd5ef36db 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -66,6 +66,33 @@ void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
 extern unsigned long tlb_flush_all_threshold;
+
+#ifdef CONFIG_RISCV_LAZY_TLB_FLUSH
+
+#define MAX_LOADED_MM					6
+
+struct tlb_context {
+	struct mm_struct *mm;
+	unsigned int gen;
+};
+
+struct tlb_info {
+	rwlock_t rwlock;
+	struct mm_struct *active_mm;
+	unsigned int next_gen;
+	struct tlb_context contexts[MAX_LOADED_MM];
+};
+
+DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_info, tlbinfo);
+
+void local_load_tlb_mm(struct mm_struct *mm);
+
+#else /* CONFIG_RISCV_LAZY_TLB_FLUSH */
+
+static inline void local_load_tlb_mm(struct mm_struct *mm) {}
+
+#endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
+
 #else /* CONFIG_MMU */
 #define local_flush_tlb_all()			do { } while (0)
 #endif /* CONFIG_MMU */
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index 55c20ad1f7444..a7cf36ad34678 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -217,6 +217,7 @@ static inline void set_mm(struct mm_struct *prev,
 	 */
 	cpumask_set_cpu(cpu, mm_cpumask(next));
 	if (static_branch_unlikely(&use_asid_allocator)) {
+		local_load_tlb_mm(next);
 		set_mm_asid(next, cpu);
 	} else {
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 8404530ec00f9..0b1c21c7aafb8 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -103,6 +103,15 @@ struct flush_tlb_range_data {
 	unsigned long stride;
 };
 
+#ifdef CONFIG_RISCV_LAZY_TLB_FLUSH
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_info, tlbinfo) = {
+	.rwlock = __RW_LOCK_UNLOCKED(tlbinfo.rwlock),
+	.active_mm = NULL,
+	.next_gen = 1,
+	.contexts = { { NULL, 0, }, },
+};
+#endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
+
 static void __ipi_flush_tlb_range_asid(void *info)
 {
 	struct flush_tlb_range_data *d = info;
@@ -240,3 +249,60 @@ void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 			  0, FLUSH_TLB_MAX_SIZE, PAGE_SIZE);
 	cpumask_clear(&batch->cpumask);
 }
+
+#ifdef CONFIG_RISCV_LAZY_TLB_FLUSH
+
+static inline unsigned int new_tlb_gen(struct tlb_info *info)
+{
+	unsigned int gen = info->next_gen++;
+	unsigned int i;
+
+	if (unlikely(!info->next_gen)) {
+		for (i = 0; i < MAX_LOADED_MM; i++) {
+			if (info->contexts[i].gen)
+				info->contexts[i].gen = 1;
+		}
+		info->next_gen = 1;
+		gen = info->next_gen++;
+	}
+
+	return gen;
+}
+
+void local_load_tlb_mm(struct mm_struct *mm)
+{
+	struct tlb_info *info = this_cpu_ptr(&tlbinfo);
+	struct tlb_context *contexts = info->contexts;
+	struct mm_struct *victim = NULL;
+	unsigned int i, pos = 0, min = UINT_MAX;
+
+	for (i = 0; i < MAX_LOADED_MM; i++) {
+		if (contexts[i].mm == mm) {
+			pos = i;
+			break;
+		}
+		if (min > contexts[i].gen) {
+			min = contexts[i].gen;
+			pos = i;
+		}
+	}
+
+	write_lock(&info->rwlock);
+
+	info->active_mm = mm;
+
+	if (contexts[pos].mm != mm) {
+		victim = contexts[pos].mm;
+		contexts[pos].mm = mm;
+	}
+	contexts[pos].gen = new_tlb_gen(info);
+
+	write_unlock(&info->rwlock);
+
+	if (victim) {
+		cpumask_clear_cpu(raw_smp_processor_id(), mm_cpumask(victim));
+		local_flush_tlb_all_asid(get_mm_asid(victim));
+	}
+}
+
+#endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
-- 
2.20.1


