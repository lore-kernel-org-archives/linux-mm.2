Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36ABECFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C736B00A0; Thu, 27 Nov 2025 09:12:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCA16B00A1; Thu, 27 Nov 2025 09:12:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C48D6B00A2; Thu, 27 Nov 2025 09:12:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 588DB6B00A0
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:12:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 358D11A01A6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:40 +0000 (UTC)
X-FDA: 84156577680.18.9942511
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 51B8480022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Os/7bird";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252758; a=rsa-sha256;
	cv=none;
	b=ElrJQLXURGw0xzbby3cq1g5G+n6INYDlb+/3kzyv+rN+b/r52u2tKTcXuWtQIpH5mdHpNi
	NcqtKFF8Xln5LbvFuYIIVuzW8cQ9RmB0zhVPto6dy0ywWAcrZGMebtL3TDwoC76kHoTrbs
	dKUHzsIir53gQIRDm052e4rTRORA+K8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Os/7bird";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zl77PqgzhSQnbli+DMk7tCeC4XrJE4OWFtNvT9IO89M=;
	b=PPvadMbbS1LdgbfIYkxlp3trBbw/WhT8RDSlyi0QOHgJBB9X6xqh//Xdk1+K6kYBWYg4ya
	J/Qeq8qmcVAxGEoQxFbNJBsJkteb/uZfudep9RuBvdHnPC7FNxbhoTdH60dQVFk2PYqLO7
	laippo922liNUeZz5yV+vVPpk3nqstM=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7c66822dd6dso1260504b3a.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252757; x=1764857557; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zl77PqgzhSQnbli+DMk7tCeC4XrJE4OWFtNvT9IO89M=;
        b=Os/7bird2/VTQ+Q8+OFFsdVONSf2rYM8+3kalJoock4nQ8yNnmcUkLlze+bqLGgzyg
         6d14aO7uvO5X2x3U4XU4zkCvYF2Oo+kTHIugw15YI8BdYAo0iOEGzd/ywErXJb0l97Yd
         tua9sPJn7/KSlQh14F4YkLASPc356xFp2EBTBq9qSRdF0D3t/sJOzjjwZ2ZaVPq7/rCt
         hZ3k02EwvgNYP6lMeQXBk1XXljM8Rasgx5NSy2RRRwT2bZr+YYrdrxsi14/xHxj1urp+
         YD4kKf6KkEPByJJx9lFozC8O1tu2GU7tD8mL9u5F2TFkoKna4wN8aIabK/HIb9USJT8t
         Y5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252757; x=1764857557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zl77PqgzhSQnbli+DMk7tCeC4XrJE4OWFtNvT9IO89M=;
        b=qvbAQTFNPZpd1v1ihzq3mkANJCpIIaK9U2gioIsJII75qTwK9CdtWIQn1YTR5Iss1U
         9cZ3heoEDGT4dUa44GbT/rrpObe32Vg0h/vgZun8frcbAdx+CiGIF+hfJtK5OQU/JtxW
         ambzUOPm6GB7gnC7jx1De/PBC0qxPPSfPIplR1OcbfmIYcgRdS28B4eJ1HdIfL/xR8yL
         xmlxmldsnS9VDuBaPTDZQD01az7CZpMfafevcrRgFrOhXH/xo6ZWkKkwdT21r3iDIfX/
         3yDhVGJO+apZFyLJCBOR3XqJW7YtFB6aqxzHksQNoXZMASngT8BZRefmIMtx4V97uxgz
         TzIw==
X-Forwarded-Encrypted: i=1; AJvYcCWlLXnkngRUvZ7x6q/MVnqQKiEmg3sicvE/pBGhOT6H7XBZss92cfJTf1iSYSriyw71/QLGXxsFCQ==@kvack.org
X-Gm-Message-State: AOJu0YzKz9/m7KjRaf5WOCqFUL7q4jGqkNEFyglvINX1CYbkq3cov8DU
	9H1WngebnlBDX4a3blJ0uuN9tklzyvPAKw3KItomxoLn7rZ8EF6U9FUT7eosgSlQZ/0=
X-Gm-Gg: ASbGncsPkJ+pqBboPN+zP0z/qNInP0kDJv7P2kcoj/xR2Az/bsfTerKEJTo0hcYxAqB
	kV9wQ1aqnqW3I6QdWYhUPVbluOl2HbjfV7SlaAkszmA/cpqE3eWTilYzRztiHfcFMTYDXrjjXYC
	bhWXNnKzVPDsNa2+i5VOO7IjQy6NgfsulaJmM0dJWEcDjuGiDolujQkf93M2Zae+LQacuNOCPGa
	EK2oT3uqkvoUySOLBc+gwumHAbiDxv6GrhWQE/B7fFqnlHPGj2hFXGV9onJc4G1Zypw4PXIVlM+
	uX/2AoTjKu6WlmWE8HJFjeCKlLQxL/wRIrBfvIeVi74SPX2vEcSJjMwEDfdfqCa8GeZxHQCHfF1
	5H9ybagH8ZnHosnHC9usMVPdQ8ZyAoGSpCsO5rZuPzvJumuKOmL5MFWClgnGuGp73YMbO7ah6jD
	c8+rIUvJHPEkN/7jv2mk+TUio9IajRvp8O3cZ48TdAO9lE1BUO7Q8qHzquYU8LOmzTPKV0NYvDx
	A==
X-Google-Smtp-Source: AGHT+IFs53VTIZhomsFYAowx9J26TGi3f3ksQWsE5AJKE20aCMEW51a+o1FMLwfvpm4UU6skwP1mVg==
X-Received: by 2002:a17:90b:38ca:b0:32e:23c9:6f41 with SMTP id 98e67ed59e1d1-347331be358mr21956360a91.5.1764252756999;
        Thu, 27 Nov 2025 06:12:36 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.12.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:12:36 -0800 (PST)
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
Subject: [RFC PATCH v2 6/9] riscv: mm: Introduce percpu TLB Flush queue
Date: Thu, 27 Nov 2025 22:11:14 +0800
Message-ID: <20251127141117.87420-7-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127141117.87420-1-luxu.kernel@bytedance.com>
References: <20251127141117.87420-1-luxu.kernel@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51B8480022
X-Stat-Signature: jwwurxuprt631kog344ozufk1johxfxb
X-Rspam-User: 
X-HE-Tag: 1764252758-868878
X-HE-Meta: U2FsdGVkX19IfdwePf4meQ/Bfd8W+j/eCK6dHMZ9mWt2sHdZfIVAAX5mHLmaq48MOSFBDGqJXkZSQfulPFY7NBbp6jjNbNvvu4cs7rU7Q74vY8R24nko4srV+CG5ecRPPmrXKi3DNdMLQHjst/G4LrWgD36kdyzIz0tkOuNPo5qyfO2JmSkuDjWq1xSvmjFy1XPHXLTUslA6iI96WvF8uOo5+PTD1mx+7agahOJ2T5Fmevs1CeOUNptnnrJFjHgNUjiVvIoAQwAb+KMJcPmGJeqh6SbXdFeW4l5Prn42ZQ+hDGqLz5tHSdqaDn2e4PkgHB89wJTCIyCCncqhLv6/k82qOmQhk/DwIWd8qENQ+ieWzyOaR5rosReAK66Ka+NeBGRa47Xu8ot23KWiBad3WN1k+dyymZInhkjklEHxzyCFrBxmkh+MER0v8k14LAypiZu/Gaz9jpTEjGV0MCw0AWxE6cgsZ1zzy6V1KuteyTO2iCfHeF3no2gCA6Wx8bzLt66alPuwYCHsw5VV5Grl5+uHBX7+gvn7NqcPlzLHId+QzbL4GCW9E5MRctLrkpPD3W4ZAs+J7mkeBvLA9cI5c1ZSHoVulzBAcgkFN1R1JysBV1+FLLYeUGScIz455HfCA5ZBc+LWS9r8QZtPe06DerX/6kjqh6vmCZS6fZT0f7VImQxI8astPE23xoHj6mkoahTlF1enfTHOv6KoZSd6RJ6Eh3YhTiLZGcX3aEWvXXi+R6fAzk5LxTEzWbCAx3nEK3LI3l0duw1d36FVyevFSLSfbUX2RXh1BfaWU/jvBcAi+9ZlKGZ1/sfFOmhUrqmbkUWREKwYEj2fWWrwdZ4u+KAMIs0+WW5/aQ5Oo0US3CP9yYb1VxFAMbeJz3JTAodv7XDk15nwiEqgyBQG+z9rsFcmdQWLyWupqb0ailotLwmPfkES+B/H+CGtOtd2+dcUceFVAERYqCwNn5KxNrz
 PK1lmrOV
 Iy3EXFjlGFzmHLhqvieSF0WKbbvan/NokFu1gcTvYNx4ZGTonO+tDNN0iP1JwB8d6K7aE2XcEmXEmRcD0vagcHXvUWZAS2Yl0IJ4A4q8nkiBVq8MKBvHd9rEdF2ZMg/eT9n0LZ65KZ7fcZ1IBF0dF2+avLfPGEVtOkzwll9Qsvc/I8xTr1dJSESlSCM3iOcf7V8bO66blFIbYeSX7PF5ZZoIpJPzZDmrUMFOdLJAgroEgl9ElHkpC/5gzTelh9oCP3tUVSgqxZQ2UVyobtZGa9V8hlpWqT14kDwWNt6MA52zy2oxyNiTnynkZkxCNqjYwxRgMQfagwqSS6W36r+FUPIRP5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory mapping of a mm is modified, instead of sending IPI to all
CPUs recorded in its mm_cpumask, we check whether each target CPU is
using this mm right now. If not, we just store the TLB Flush information
in target CPU's percpu TLB Flush queue, avoiding the IPI.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/tlbflush.h | 19 +++++++++
 arch/riscv/mm/context.c           |  2 +
 arch/riscv/mm/tlbflush.c          | 71 ++++++++++++++++++++++++++++++-
 3 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index e7365a53265a6..c9630267c58cd 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -75,23 +75,40 @@ extern unsigned long tlb_flush_all_threshold;
 #ifdef CONFIG_RISCV_LAZY_TLB_FLUSH
 
 #define MAX_LOADED_MM					6
+#define MAX_TLB_FLUSH_TASK				32
+#define FLUSH_TLB_ALL_ASID				0x1
 
 struct tlb_context {
 	struct mm_struct *mm;
 	unsigned int gen;
+	bool need_flush;
 };
 
+struct tlb_flush_task {
+	unsigned long start;
+	unsigned long size;
+	unsigned long stride;
+};
+
+struct tlb_flush_queue {
+	atomic_t len;
+	unsigned int flag;
+	struct tlb_flush_task tasks[MAX_TLB_FLUSH_TASK];
+} ____cacheline_aligned_in_smp;
+
 struct tlb_info {
 	rwlock_t rwlock;
 	struct mm_struct *active_mm;
 	unsigned int next_gen;
 	struct tlb_context contexts[MAX_LOADED_MM];
+	struct tlb_flush_queue *flush_queues;
 };
 
 DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_info, tlbinfo);
 
 void local_load_tlb_mm(struct mm_struct *mm);
 void local_flush_tlb_mm(struct mm_struct *mm);
+void __init lazy_tlb_flush_init(void);
 
 #else /* CONFIG_RISCV_LAZY_TLB_FLUSH */
 
@@ -102,6 +119,8 @@ static inline void local_flush_tlb_mm(struct mm_struct *mm)
 	local_flush_tlb_all_asid(get_mm_asid(mm));
 }
 
+static inline void lazy_tlb_flush_init(void) {}
+
 #endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
 
 #else /* CONFIG_MMU */
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index 3335080e5f720..c381c4ed46bfb 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -263,6 +263,8 @@ static int __init asids_init(void)
 
 		__set_bit(0, context_asid_map);
 
+		lazy_tlb_flush_init();
+
 		static_branch_enable(&use_asid_allocator);
 
 		pr_info("ASID allocator using %lu bits (%lu entries)\n",
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index a47bacf5801ab..b5a2d9874d62b 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -97,6 +97,7 @@ void flush_tlb_all(void)
 }
 
 struct flush_tlb_range_data {
+	struct mm_struct *mm;
 	unsigned long asid;
 	unsigned long start;
 	unsigned long size;
@@ -109,7 +110,8 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_info, tlbinfo) = {
 	.rwlock = __RW_LOCK_UNLOCKED(tlbinfo.rwlock),
 	.active_mm = NULL,
 	.next_gen = 1,
-	.contexts = { { NULL, 0, }, },
+	.contexts = { { NULL, 0, false, }, },
+	.next_gen = 0,
 };
 
 static DEFINE_PER_CPU(mm_context_t *, mmdrop_victims);
@@ -155,6 +157,47 @@ static inline void mmdrop_lazy_mm(struct mm_struct *mm)
 	}
 }
 
+static bool should_ipi_flush(int cpu, void *data)
+{
+	struct tlb_info *info = per_cpu_ptr(&tlbinfo, cpu);
+	struct tlb_context *contexts = info->contexts;
+	struct tlb_flush_queue *queue = NULL;
+	struct flush_tlb_range_data *ftd = data;
+	unsigned int i, index;
+	unsigned long flags;
+
+	if (info->active_mm == ftd->mm)
+		return true;
+
+	read_lock_irqsave(&info->rwlock, flags);
+
+	if (info->active_mm == ftd->mm) {
+		read_unlock_irqrestore(&info->rwlock, flags);
+		return true;
+	}
+
+	for (i = 0; i < MAX_LOADED_MM; i++) {
+		if (contexts[i].mm != ftd->mm)
+			continue;
+
+		queue = &info->flush_queues[i];
+		index = atomic_fetch_add_unless(&queue->len, 1, MAX_TLB_FLUSH_TASK);
+		if (index < MAX_TLB_FLUSH_TASK) {
+			queue->tasks[index].start = ftd->start;
+			queue->tasks[index].stride = ftd->stride;
+			queue->tasks[index].size = ftd->size;
+		} else {
+			queue->flag |= FLUSH_TLB_ALL_ASID;
+		}
+		contexts[i].need_flush = true;
+		break;
+	}
+
+	read_unlock_irqrestore(&info->rwlock, flags);
+
+	return false;
+}
+
 #endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
 
 static void __ipi_flush_tlb_range_asid(void *info)
@@ -185,11 +228,20 @@ static void __flush_tlb_range(struct mm_struct *mm,
 	} else {
 		struct flush_tlb_range_data ftd;
 
+		ftd.mm = mm;
 		ftd.asid = asid;
 		ftd.start = start;
 		ftd.size = size;
 		ftd.stride = stride;
-		on_each_cpu_mask(cmask, __ipi_flush_tlb_range_asid, &ftd, 1);
+#ifdef CONFIG_RISCV_LAZY_TLB_FLUSH
+		if (static_branch_unlikely(&use_asid_allocator) && mm)
+			on_each_cpu_cond_mask(should_ipi_flush,
+					      __ipi_flush_tlb_range_asid,
+					      &ftd, 1, cmask);
+		else
+#endif
+			on_each_cpu_mask(cmask, __ipi_flush_tlb_range_asid,
+					 &ftd, 1);
 	}
 
 	put_cpu();
@@ -376,4 +428,19 @@ void local_flush_tlb_mm(struct mm_struct *mm)
 	local_flush_tlb_all_asid(asid);
 }
 
+void __init lazy_tlb_flush_init(void)
+{
+	struct tlb_flush_queue *queue;
+	unsigned int cpu, size;
+
+	size = MAX_LOADED_MM * sizeof(struct tlb_flush_queue);
+	for_each_possible_cpu(cpu) {
+		queue = kzalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+		if (!queue)
+			panic("Failed to alloc per cpu tlb flush queue\n");
+
+		per_cpu(tlbinfo, cpu).flush_queues = queue;
+	}
+}
+
 #endif /* CONFIG_RISCV_LAZY_TLB_FLUSH */
-- 
2.20.1


