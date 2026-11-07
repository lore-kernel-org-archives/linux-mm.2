Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A52606A330
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H9HhWnec
Received: by kanga.kvack.org (Postfix)
	id C7CAE6B05B6; Sat,  7 Nov 2026 02:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32BE6B05B7; Sat,  7 Nov 2026 02:40:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68056B05B8; Sat,  7 Nov 2026 02:40:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8220E6B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 027F640306
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:40:52 +0000 (UTC)
X-FDA: 85407526386.04.C58F754
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 65DA1180003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:40:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H9HhWnec;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794037251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bP0SvI1SyNFWGaznG9wghum5HnnqOxchfJ6Ki1mewRQ=;
	b=4SuNGXnxYC5qr6RriMT0YBbmZuRjRFaH+itOgp24grtFtnMXX5qV0BAhocVSqzOop44imV
	I4zsMFHSSS9PsFbvgA8lTvxNAxHsJ/daY51PVVR3ttqiOf3c2MbvaumwtLqwaX+DzPKuU+
	SQXGGs8F5FVoaf799RoAO8EobvfBaQs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H9HhWnec;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794037251;
	b=sfPgNA9ORgTVhsxfhIBYJ1uTBH/P9tGG+JQ1lPsqrfwsF872iSaI5aFb/olDfv2l79h3i9
	gFTE+b5D+P3jYhRCr0EQdME/Do2dU2pcXTfACUgaLZrfmKu0jiAd3XXkQkmbdP7rxGuSa4
	7Bl8XDjPcEgoGgXjJhW3q6Tx8/9xNQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E592460D96;
	Sat,  7 Nov 2026 07:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4806C1F0089F;
	Sat,  7 Nov 2026 07:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036842;
	bh=bP0SvI1SyNFWGaznG9wghum5HnnqOxchfJ6Ki1mewRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9HhWnecdxRy9vEC4nHuQJSaDvquhMBI/PT801hH48JTsRd3zA+RCmU/HDJCkHKUz
	 9hBx9hkFGuKGERrF2UnNiTcLwsiPNUfWAxAI0rfswINB7IfINNe83yyNK+Ej2D+BCS
	 OXkL33cMm88csVmrZIt58Pz2+7egV/OvVOGoKu09CBbZGnbXWOzHJqhYy+ZdFrfrBu
	 MRItFyzQ637jbhvKdvyl+N32L+rfyvgF5fvoCSkonAy/HLJm1lpO6w3gkcU+/RYKwS
	 90HlrZFYjMZt8hjUpU5+ACKyyckNqKjK2xddxpsbAhtly/u4OqUwOEiIqAPv/gzhqs
	 ccw0wttMDE0sg==
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
Subject: [PATCH 3/4] arm64: stacktrace: Always inline internal stack boundary helpers
Date: Sat,  7 Nov 2026 15:13:38 +0800
Message-ID: <20261107071339.17467-4-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261107071339.17467-1-jszhang@kernel.org>
References: <20261107071339.17467-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 65DA1180003
X-Stat-Signature: kqsr14b8h5u49ogjmzkz5trkqq8j68gc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794037251-147625
X-HE-Meta: U2FsdGVkX18AfZ1Sjrx4lwr2DN8ze5uCmeTOLML7IBVlSMtEIgxE7Rc3PqN1xZ7wNPBhZPslKFKLuZEoXRqyE4Nph9Q5rtUh/LjldF1631wNFphf9G3l+5S0DrAGG74KFeYpe0/b2K9Ks+IrnEx5QnkPif9XFTJW3Rmr3zyaFMG74wBQCQPl14RCtD27IRNp58jzAeC/0KEmTjtSbq9BtaWx2ckw776m/Kc5BGI+Ky9HvZmcYRlOZPSFLAPk44zu1/VZ/0Kzu7GLo49o+nUN0zXeiz4qF+Xpv5hoKEi73+A8YcjzzHUNxNgEhncjG2xxxZNLP7FW6S5vpB8/UX3VxhjzevZ78MXVsUGdDlROCOrH7eWXucSOYm0U3RZydWUa1Jix/ElIzruCqzJ7J16pwQJ88qCW6RqZZckmfiCJBGbpqinh6KTlX91AZ1JMxjM4GusbtMSgkrS43piJ/hr+4ccGSMM49omFPlzIoauIFrxxU+cMOzP1PUaeKzC2ZbuMq4SzkAJ0hIKQwv7nmi/paMnaJTTrnTd8kl9dUwBVyqxpALJllpO11E/BrdmJRUiIdgDDT+jxhy0bwEm08SZnDdEv1apxV6RVTmeENhJ+nLp0/OqVeN5mrFdbPuhAanOIAj7T1CIpiaPybTtAOpyw9BN2X5YL6VT6mlNaBRrnCQJ2b+PTM384moCKAT3NdGsggYhGyh6nuULpgQNdW2Kg/+3bxF8gLnJIgOz1PTK7qSf4tGJEbVuGI9bokw1OMxoNG2Ey3CfWiwBKF8fdEIrblP1Afx8w3xqM34IoNsCIC3qf9rwV0bXRvTJP39LfqK3Txk5hCez1+nH8t+ytBHgLvJW6I0U18zsaf0bhmZBwGtMZu1x7yBteMvg0hK2lUdEkFIUwCMjyj4Y3xJfitgFmzr6vYbbMnVxUqWwOycK+8MZ9/1onm8ag1HmWkOLvd5mKxjnnfrd+Fe33AXBaOB7
 vC1NXYfd
 F17m4l9sqT97IvvdrI4iYIRcjUHll0IK9DX1TxJG674UxF5MsiD4wmZfuMYeEXPjrkxL4JRRnICjJIj1j8SSmVGeO87aYYAB6xqAryV8nWHqBoxg+tegm23Xfz7KauOS89GblULjYYwR/5USOl+vE5L6ek6S9BkA65mJRBTCcBdVpRQKErJo6kVPRupmZmjy6d1xAcU+5YWdYENUVaP/W1zWz3WcybQTiS9Poh0Z9lR8fvjHxlbeeX0G83k8Tqgm7f/HjcY/P1U9Crmf+eWW8kUVibDTxwZiCUYmJSNRuZ9Pum8Ea08s7byeMdw==
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


