Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7749606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wi70OnYd
Received: by kanga.kvack.org (Postfix)
	id 6DAE86B05BE; Mon,  9 Nov 2026 07:05:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B23E6B05BF; Mon,  9 Nov 2026 07:05:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0DD6B05C0; Mon,  9 Nov 2026 07:05:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 384C06B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:05:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C61C4C0642
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:29 +0000 (UTC)
X-FDA: 85415450778.28.9EF5C60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F46E40007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wi70OnYd;
	spf=pass (imf01.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225928;
	b=jNprWZO7t5CKzQjt1i8Ld6DXiqL5+xlG9zc+vW3JwztDaTzx9EF0oINnbONHIOOilzyHjM
	GieWuR+k1a7AXO2RGgQX/ZDkKifc6gTjLhwjch8lxZwTAeh77+4E+JDMbPCaRpFQdO/ic1
	z5smknXy+FrOVT8cFirQPAwJ4QTH7Ds=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wi70OnYd;
	spf=pass (imf01.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bP0SvI1SyNFWGaznG9wghum5HnnqOxchfJ6Ki1mewRQ=;
	b=Cllb+vcjuWkdt2Ep6dz0srry6IbDtCriqFCvKIMPSD3/9SEGRx9RSnPHHZJ9kwcq94XpED
	lfLeDfjZI+4WCFIJWjDrxPnwfKLabEqQ33zqu70rGmjj4nFNEp+hp9D7F1NX8fJpnuhHSU
	/HWHMqzikFoHta09km833+nCSUk2t5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB0F463175;
	Mon,  9 Nov 2026 12:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39FC1F008A2;
	Mon,  9 Nov 2026 12:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225927;
	bh=bP0SvI1SyNFWGaznG9wghum5HnnqOxchfJ6Ki1mewRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wi70OnYdXmU/O5nlE/GYtPpXZc8dZ424yjRjXLwEb6eTHY1K8E+36UyZSllQUnGCB
	 WQkz5zKyd6wqkCbfXFNIXaR1/R90WpjbgNB1/01+YQkDQ2ANmTwfMH+5ifbsMrEb7q
	 GkfDMhHXHhrpxrMVXW/sfzie1Hnru04kpBlgkiSA/Hs4JrAzE+/VqHiCLS+/RKB68+
	 ZEfKMa+J6A2lPZa4UFALIHcd8Q5uR+b9B5Ojdt5CbuDb+VYE0CNOYysFUzkPlusF1Q
	 hJ1tcHpm+kPyQtPHtcNolz6olZ7kUUl4DkKPFuTDs01ql81IZCQfXaj/i0bXkxpndd
	 3/uFwMb3OWb3g==
From: Jisheng Zhang <jszhang@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH v2 4/6] arm64: stacktrace: Always inline internal stack boundary helpers
Date: Mon,  9 Nov 2026 19:44:57 +0800
Message-ID: <20261109114500.20298-5-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261109114500.20298-1-jszhang@kernel.org>
References: <20261109114500.20298-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3tjrikzy4fdozke4ew537fz1q7yegdms
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2F46E40007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794225928-766373
X-HE-Meta: U2FsdGVkX1+FfZBj+t0Tr7na35cAssMGn/oIqWdam/x2pjJSKR5pzQhoD+WBLwHbNnH/iILwqLIpEAtXyuMSmFnZx+ur3BWh7GWLjXmKUzXtXtqLGy8wiXEwiDEl1entBLkXeYxyoIpQKnGag4jWkgfx6rlnn/PRQSjwqLTt1W6JSu8Yw1D9mEjWk1I3hniGnf7ZVyNs8SU4yaDHpgJVjbax8jwQ8vhBLDWdL9FkYcyzvUXOimPd/XCP58QA1InFQbxiiDprtPIuL2UsuzSEkaAIUe0JZmR6QhINWV8A641JRucoIbHfIV3ZqWt6uDOA9I/WXhynBgjbRnPsGYBHf7+M5svQ+y4N9jd/o/2AwI2NJhqBDQgSrMcqWUqg1wOHmhCwLeg0dv0eK2uv1dCtpOyHqDVtqJa9YIAiMqL0T93yMzQWIKxA5HFoUhOZAa+tIYBVuvxsbm9Rp6VPVHzxq3TfvQT/57GSyoOixX/5TzV2OMapQPtd5GbPMRIZq+IUKFmelWeXDjVDGLqGvDL3jILNmSWUm/c2FT0tPGx3qK0E7qpYNvOxJBOYyw9hQwF/hcHMgu5NVRW5n+bCiwsfR1fAyDF9iVfBVSwcpmlJRMz/iQB3B4H1srRmjqky453hERmE8qGgZqjhdJMhl81cP+pm38ezFduHDNF7m4FGY5y8LjB8xQsfmeHayEw1SWo5eKyQt5uXVZkslUYDK0YbaqASmdMQj3pjrl4qYZk5tAhEW5FXIsBNJhTrh0dXb9/F0Gff39R748hkkFnQSt2bS6xNk+3kt+uCXY1wSvgpdW70xwwhAhRZuXkeebyTX+VGAYk0Aym3Rw9+ljoSkU03p5C5wt7Tw6LsY60bnnTZOJGz/KfjSkCMceSqbv07a7Z7gg+kjvHwhp1t6A2RFeSdaZ7kSfUHZt42OvaRtw+Dm5VXOydKAv7t54aZbkyYf1u3oKOSMUwduyAueW8Yplv
 4+LiVCBR
 AZpHdeCQYr4nDiU06hANjqg8tGGjHsg4QF8LdEta+LgT4ncicSeUmi7JuclX+FNbvKE6bSaWrKVBfC91VAxswFLRo46Dquu0Re5Wh/F+xtQc7a5YMGHI1iduRrBhwxaYuHuywpT8k3zwSBPHcYpaNG7bo0ECiHBpnbsDTsOlW+qWaFEYVxRkQ8TeGF2UhzOT8Jcn5U2mt9ZMhwXYMI87hd+fQBFoyX5qx3hJWqFUnnDUR5AVZ5KzsFvrg9SufjgAPlfy6+h+kqLnmLA9nqyAxi7o9uGjFu3DDrxEsE++gmnodstSuIAKUMOfSXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The noinstr stack walkers reach the stack boundary and frame-record
helpers through an __always_inline call chain. However, these shared
helpers do not themselves guarantee inlining.

With CONFIG_CC_OPTIMIZE_FOR_SIZE=y, GCC emitted several stack
information helpers and unwind_find_stack() out of line in .text.

Mark the shared stack boundary and frame-record helpers
__always_inline to keep their instructions in the non-instrumentable
walkers

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Assisted-by: LLM
---
 arch/arm64/include/asm/stacktrace.h        | 16 ++++++++--------
 arch/arm64/include/asm/stacktrace/common.h | 12 ++++++------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 6d3280932bf5..b370c0e1e337 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -22,7 +22,7 @@ extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 
 DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
 
-static inline struct stack_info stackinfo_get_irq(void)
+static __always_inline struct stack_info stackinfo_get_irq(void)
 {
 	unsigned long low = (unsigned long)raw_cpu_read(irq_stack_ptr);
 	unsigned long high = low + IRQ_STACK_SIZE;
@@ -33,13 +33,13 @@ static inline struct stack_info stackinfo_get_irq(void)
 	};
 }
 
-static inline bool on_irq_stack(unsigned long sp, unsigned long size)
+static __always_inline bool on_irq_stack(unsigned long sp, unsigned long size)
 {
 	struct stack_info info = stackinfo_get_irq();
 	return stackinfo_on_stack(&info, sp, size);
 }
 
-static inline struct stack_info stackinfo_get_task(const struct task_struct *tsk)
+static __always_inline struct stack_info stackinfo_get_task(const struct task_struct *tsk)
 {
 	unsigned long low = (unsigned long)task_stack_page(tsk);
 	unsigned long high = low + THREAD_SIZE;
@@ -50,7 +50,7 @@ static inline struct stack_info stackinfo_get_task(const struct task_struct *tsk
 	};
 }
 
-static inline bool on_task_stack(const struct task_struct *tsk,
+static __always_inline bool on_task_stack(const struct task_struct *tsk,
 				 unsigned long sp, unsigned long size)
 {
 	struct stack_info info = stackinfo_get_task(tsk);
@@ -61,7 +61,7 @@ static inline bool on_task_stack(const struct task_struct *tsk,
 
 DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
 
-static inline struct stack_info stackinfo_get_overflow(void)
+static __always_inline struct stack_info stackinfo_get_overflow(void)
 {
 	unsigned long low = (unsigned long)raw_cpu_ptr(overflow_stack);
 	unsigned long high = low + OVERFLOW_STACK_SIZE;
@@ -76,7 +76,7 @@ static inline struct stack_info stackinfo_get_overflow(void)
 DECLARE_PER_CPU(unsigned long *, sdei_stack_normal_ptr);
 DECLARE_PER_CPU(unsigned long *, sdei_stack_critical_ptr);
 
-static inline struct stack_info stackinfo_get_sdei_normal(void)
+static __always_inline struct stack_info stackinfo_get_sdei_normal(void)
 {
 	unsigned long low = (unsigned long)raw_cpu_read(sdei_stack_normal_ptr);
 	unsigned long high = low + SDEI_STACK_SIZE;
@@ -87,7 +87,7 @@ static inline struct stack_info stackinfo_get_sdei_normal(void)
 	};
 }
 
-static inline struct stack_info stackinfo_get_sdei_critical(void)
+static __always_inline struct stack_info stackinfo_get_sdei_critical(void)
 {
 	unsigned long low = (unsigned long)raw_cpu_read(sdei_stack_critical_ptr);
 	unsigned long high = low + SDEI_STACK_SIZE;
@@ -105,7 +105,7 @@ static inline struct stack_info stackinfo_get_sdei_critical(void)
 #ifdef CONFIG_EFI
 extern u64 *efi_rt_stack_top;
 
-static inline struct stack_info stackinfo_get_efi(void)
+static __always_inline struct stack_info stackinfo_get_efi(void)
 {
 	unsigned long high = (u64)efi_rt_stack_top;
 	unsigned long low = high - THREAD_SIZE;
diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 821a8fdd31af..7c502ae276b9 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -35,7 +35,7 @@ struct unwind_state {
 	int nr_stacks;
 };
 
-static inline struct stack_info stackinfo_get_unknown(void)
+static __always_inline struct stack_info stackinfo_get_unknown(void)
 {
 	return (struct stack_info) {
 		.low = 0,
@@ -43,7 +43,7 @@ static inline struct stack_info stackinfo_get_unknown(void)
 	};
 }
 
-static inline bool stackinfo_on_stack(const struct stack_info *info,
+static __always_inline bool stackinfo_on_stack(const struct stack_info *info,
 				      unsigned long sp, unsigned long size)
 {
 	if (!info->low)
@@ -55,7 +55,7 @@ static inline bool stackinfo_on_stack(const struct stack_info *info,
 	return true;
 }
 
-static inline void unwind_init_common(struct unwind_state *state)
+static __always_inline void unwind_init_common(struct unwind_state *state)
 {
 	state->stack = stackinfo_get_unknown();
 }
@@ -70,7 +70,7 @@ static inline void unwind_init_common(struct unwind_state *state)
  *
  * Return: a pointer to the relevant stack_info if found; NULL otherwise.
  */
-static struct stack_info *unwind_find_stack(struct unwind_state *state,
+static __always_inline struct stack_info *unwind_find_stack(struct unwind_state *state,
 					    unsigned long sp,
 					    unsigned long size)
 {
@@ -99,7 +99,7 @@ static struct stack_info *unwind_find_stack(struct unwind_state *state,
  *
  * Return: 0 upon success, an error code otherwise.
  */
-static inline void unwind_consume_stack(struct unwind_state *state,
+static __always_inline void unwind_consume_stack(struct unwind_state *state,
 					struct stack_info *info,
 					unsigned long sp,
 					unsigned long size)
@@ -142,7 +142,7 @@ static inline void unwind_consume_stack(struct unwind_state *state,
  *
  * Return: 0 upon success, an error code otherwise.
  */
-static inline int
+static __always_inline int
 unwind_next_frame_record(struct unwind_state *state)
 {
 	struct stack_info *info;
-- 
2.55.0


