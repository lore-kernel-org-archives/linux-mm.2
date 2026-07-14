Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAFCFC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAEB46B00E4; Tue, 14 Jul 2026 14:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85C56B00E6; Tue, 14 Jul 2026 14:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9BF96B00E8; Tue, 14 Jul 2026 14:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63E186B00E4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:23:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF7B1140440
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:23:23 +0000 (UTC)
X-FDA: 84988204686.05.4AA8EE0
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 17C0F10000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:23:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VeKNJM+k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lu1r+dI7YhT/+Q6NrL3ZLzbfp3koK+yzDpN5AF+wuNI=;
	b=Finwkgjtwb3UrGfZm0BxlVuDOth69u7DvstsXbnlIM3QY3pLT1VCSlXhj35ztavPScIIP/
	609sclrIRxl9YQPlR9uRv6RkML7Qa6xvCKRfj6BR1LahMUgPDn74aYHq8u3muIC4QaRuD2
	TAGjZvX38EBtIcP4GiSFMKCY1IhLPUU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VeKNJM+k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053402;
	b=28aeDRYg7VI0YFRgJTLE2xp4rd3OMU0nwrP/vSvb+2+HiLlmnk9tXPBJAmdxAcjnIzp+Ad
	6rQh9PewLlPjzl+7slI/E9XlpQURcBR0TgRV9g2GAQr1TQRlk4cHhqjb/ax784LWqgZVvu
	vUjVxz/5/UGZF0/+AnRLJm1xjNpu7pc=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e512a9a6bso234482085a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053401; x=1784658201; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lu1r+dI7YhT/+Q6NrL3ZLzbfp3koK+yzDpN5AF+wuNI=;
        b=VeKNJM+kSEcKVJ2SGtNk1AzXUFaM6s97Ed3ytzLtwy1FcTquACbWtUtkFYql+uF+cK
         5Iq3pcbJ7qUg0Wtk8zc5aTEUYwUkYeEs56g3KNMemxS8Brxld6OdzPH1CQAmdbvS0xgv
         60XdUCH2a4/ZuRfehU+gDzG0N7r6OLo0D1Ii1bB7eT6BsJvOq9AUyNT87mOIVCMJqgJR
         erxQ2G1qW4ugPKWzfNZ/+dXr4pdHSXqnhnfoXcJ5+VQhAk4oyi8jucRUupGbScTScM0L
         R+JkpkBz+NdzH2gykeYXwaETu6P3QpOLcgpA2nJythtUA8003vFcd4UvgSG5YK8G6noy
         zoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053401; x=1784658201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lu1r+dI7YhT/+Q6NrL3ZLzbfp3koK+yzDpN5AF+wuNI=;
        b=Ym40/hduG636y67+Qp8CjkbZrXMaQYc2s2WPGlNWl2LaKdZb9fwkpd6LwTJ4w2Rg1V
         Fe7D7eMlFuClJZdPyp2IbHviSLP11+KX7orCmHW/+v8ZwRyIe4AkjSi7kk5VksTgZ0bE
         S0Rl95MYL704W3XeCTmK7AlZoKgHzybIIm8U0/kL16g98OfQ6ZlovBenpIAIrNdikMNF
         1+a9m08qFq9yh+4wtVVuH+FJSqsr/us1G8VTxPKF/L9kMBklWTJeU5Xh2lxDB9lw2kms
         +iOaKhVXGNzj4m78L65RvMsJmmq8Jg/PBrZlpTdYooLqu5B7GhVxEfolrtBE0CvIbZdg
         w88g==
X-Forwarded-Encrypted: i=1; AHgh+RqFNvkkYhmSgug5T5XFixHJgEItNF9F0sIg1iO2hvL/Xcr/efJVM3T9EEJEuVuNaOLjfyJYLRjWJw==@kvack.org
X-Gm-Message-State: AOJu0Yz6XT/WCmr8ffe87qPkz1mcYpmHgjlHTh9mIY3L9gfQaS10WI6+
	L2Bu9AbgKQ7dac+xY1dmED66V82PBWaZdVfJ9DJHOTLNfVyknEW2zc7v
X-Gm-Gg: AfdE7cnl3kXnbbikxyLTYPDFTbPS/acqV5AD5WUnN/8MuMZtKdUjqsbRzlLVsfUMtK7
	NpGq1fY/+MvyG8ucNzCk3aW0i5q/0/sTU6R3Bt/Q3/8qPUFnnNtJymbs8RH3gbv83czlLrL52hd
	PzFaQ1ptqyR7f1MTw40eSLX8536rKXCZ/7ySsagb0pEUpb0fMfeMqr6UZ4c5w927LXdFQDYuLQN
	wOinp5yWTMvY1j3pT9ksrt0mOC5zg2bsvrnTXBDDKe12zpybVBmbSQSAJp3l7lwxEJSI3mPRKQT
	aJDzQAG/1suxevPSOQ70Ot4c3bk/a9XdU+Lny528BnSxGvl7R9X5JGcm1eeCkeBA98M22E7vx9J
	MXdnfFoRtRb5pVeQvMyKK6ajulelHuJkgguxXm9Zm69AN/pAuZPleCKJ6cUL9/Gm/lgrqeIrBCE
	HmRMWUPHktCmfLlVoexaMhD9Hub5YLf+mSB0Yjzh6g77wCJkj7yus=
X-Received: by 2002:a05:620a:408c:b0:92e:9cb3:3f71 with SMTP id af79cd13be357-93086a5a11emr367980985a.36.1784053400994;
        Tue, 14 Jul 2026 11:23:20 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d33689sm1501801285a.36.2026.07.14.11.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:23:20 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 02/13] x86/hw_breakpoint: Unify breakpoint install/uninstall
Date: Wed, 15 Jul 2026 02:22:32 +0800
Message-ID: <20260714182243.10687-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i77r4khhkpmeww4pdci6sjz8rfg5hopj
X-Rspamd-Queue-Id: 17C0F10000F
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784053401-80133
X-HE-Meta: U2FsdGVkX1+DgIMXHBEheZ+4NDiPnjIv9NYTG6E6DrWIe6yJDcMoCrlRtHQtwmQBzgaeaTF7BE0YTU+6Bc6JOZ8XHsaGVNZecG6mRKw6Hb/qizCsgN4+EvqhLSCbB+8vGWAxvfpUAc1XcHPYTIMNpD/+BZqbHtiW64lCu//K7rBWqsN3EqUS9gDqritP0ykOou9Vts7xGiq7U/7df/nnKsFPVxqmJ+/2CGB3g5lALc4NQdYqF9d5zqZXooWud6dfuAH+OlG0QRrd6ryrcV9jk6Fh6bKB9BIQ2H7pZ4T1vS7CNnSLJ5F1XQ5sdVIGmpL3x5ZoL1pO/4n6vS0Y2uOdmdpd4RDTU0Tc/EOD+LpLLsOgds1X9y5VTmdre1WB1CMExtFS40zNb0Qmo732MG3E2gznw672PyYpHx7dbXNohOCq+zBzFEy0aJa0d+nbOe5pXJxgf3du3EdnV11px8HWxrHvljphWELjEPdYj0e2Oi2oldyBBA02KEDDuMOVNNrCsfSIzSzeD+RExXT6u3tqKhR9nVLkX8e9/5QF+wfrRIWKzPJOr6JxFtLmrDl1gmpksbLQFfTbCC2XmJvJVidnbjFTFQUEl287LfyjVuuDI5vk1G9U24yKRk8scdCUbJ9Qh1nasqoa29CU/Jcpz+4H820NmK1q2wfHsLKbum7vfWhMYV9T1MCLEtKM9Lb6DDws8ya6Fj1GZQDvwXzAAJzxOB6dkuagQ0SnZRiGeEqyWL6AR57wfbopk7K/Lh7Bn4gDyBD+juJpKFy3sriSpq5RyzuBnGMkiT6nBqCcDdO9Euks8GRaGLHMjVaLy4Y1/VjLv1GZqxoG/hA7xOFDOg6iqExKWl8E/B8TIbOTVgX3zi5eoe3ZSswYgenovfFIWJ3GW2kItGtEqZLeY9HhDqglxqyfWN8WSuIBL5U9yvzWM9OXPMHJ+hvCar4zxYN5uGzVe/EarJFiMl5Db9f9ucB
 dYK9oGKP
 f//6Cjn4cZpHQYJ4Snqfns3KZf8GS1PnUJYqYsHopAKrFvwZbsLSQaVR0tS1zil40YzFHmoP4iU/Q78aY1W+wrL/CSp9+XYEJTEdC9AvTwSVy8w3fqdVNVGUSnODyz0axQ1AxLXyvkLKjyrIlOZVRPG0S9AwuII/oSx4KVKzEnj5dU/vn7ApsN7aA+EvDupejLKD6QL7RSR/RvXg/aHgbwnWqDJKZXZA63YxQyWFbVgXbiQT5Usr1C5HqtzXypAUFt4i678K7qQRLr/wncYkGa4ErUDH3WOhRnw/uBTO490EWNqw78ZqnJtcp147GP9aM8QTOzDDbd8Ts0hikQfqHE2fvxOKxIgVPI42F5EDqVLIO7/rKa40yl0c/BBXmncDdNIaG1hiGAJlzZSTP4a6uPxQDpje4U5SYQJBC7NbTf38sM2+SdF1Rddv77zTcZ7gs1RRGSoZIxtfij4hVDOtQw2naoYWLdwiPnz8MQJPQ6au2ylkIummh60w0tE4dzDhJ7W+XV+8dMiktdNJRpnyYDqdfS4JT/tKgDuoH9fqoYqEJcga7ZaOyC7B5Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Consolidate breakpoint management to reduce code duplication.
The diffstat was misleading, so the stripped code size is compared instead.
After refactoring, it is reduced from 11976 bytes to 11448 bytes on my
x86_64 system built with clang.

This also makes it easier to introduce arch_reinstall_hw_breakpoint().

In addition, including linux/types.h to fix a missing build dependency.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 arch/x86/include/asm/hw_breakpoint.h |   6 ++
 arch/x86/kernel/hw_breakpoint.c      | 141 +++++++++++++++------------
 2 files changed, 84 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0bc931cd0698..aa6adac6c3a2 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -5,6 +5,7 @@
 #include <uapi/asm/hw_breakpoint.h>
 
 #define	__ARCH_HW_BREAKPOINT_H
+#include <linux/types.h>
 
 /*
  * The name should probably be something dealt in
@@ -18,6 +19,11 @@ struct arch_hw_breakpoint {
 	u8		type;
 };
 
+enum bp_slot_action {
+	BP_SLOT_ACTION_INSTALL,
+	BP_SLOT_ACTION_UNINSTALL,
+};
+
 #include <linux/kdebug.h>
 #include <linux/percpu.h>
 #include <linux/list.h>
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index f846c15f21ca..877509539300 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -49,7 +49,6 @@ static DEFINE_PER_CPU(unsigned long, cpu_debugreg[HBP_NUM]);
  */
 static DEFINE_PER_CPU(struct perf_event *, bp_per_reg[HBP_NUM]);
 
-
 static inline unsigned long
 __encode_dr7(int drnum, unsigned int len, unsigned int type)
 {
@@ -86,96 +85,112 @@ int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
 }
 
 /*
- * Install a perf counter breakpoint.
- *
- * We seek a free debug address register and use it for this
- * breakpoint. Eventually we enable it in the debug control register.
- *
- * Atomic: we hold the counter->ctx->lock and we only handle variables
- * and registers local to this cpu.
+ * We seek a slot and change it or keep it based on the action.
+ * Returns slot number on success, negative error on failure.
+ * Must be called with IRQs disabled.
  */
-int arch_install_hw_breakpoint(struct perf_event *bp)
+static int manage_bp_slot(struct perf_event *bp, enum bp_slot_action action)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long *dr7;
-	int i;
-
-	lockdep_assert_irqs_disabled();
+	struct perf_event *old_bp;
+	struct perf_event *new_bp;
+	int slot;
+
+	switch (action) {
+	case BP_SLOT_ACTION_INSTALL:
+		old_bp = NULL;
+		new_bp = bp;
+		break;
+	case BP_SLOT_ACTION_UNINSTALL:
+		old_bp = bp;
+		new_bp = NULL;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
+	for (slot = 0; slot < HBP_NUM; slot++) {
+		struct perf_event **curr = this_cpu_ptr(&bp_per_reg[slot]);
 
-		if (!*slot) {
-			*slot = bp;
-			break;
+		if (*curr == old_bp) {
+			*curr = new_bp;
+			return slot;
 		}
 	}
 
-	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
-		return -EBUSY;
+	if (old_bp) {
+		WARN_ONCE(1, "Can't find matching breakpoint slot");
+		return -EINVAL;
+	}
+
+	WARN_ONCE(1, "No free breakpoint slots");
+	return -EBUSY;
+}
+
+static void setup_hwbp(struct arch_hw_breakpoint *info, int slot, bool enable)
+{
+	unsigned long dr7;
 
-	set_debugreg(info->address, i);
-	__this_cpu_write(cpu_debugreg[i], info->address);
+	set_debugreg(info->address, slot);
+	__this_cpu_write(cpu_debugreg[slot], info->address);
 
-	dr7 = this_cpu_ptr(&cpu_dr7);
-	*dr7 |= encode_dr7(i, info->len, info->type);
+	dr7 = this_cpu_read(cpu_dr7);
+	if (enable)
+		dr7 |= encode_dr7(slot, info->len, info->type);
+	else
+		dr7 &= ~__encode_dr7(slot, info->len, info->type);
 
 	/*
-	 * Ensure we first write cpu_dr7 before we set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 * Enabling:
+	 *   Ensure we first write cpu_dr7 before we set the DR7 register.
+	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
 	 */
+	if (enable)
+		this_cpu_write(cpu_dr7, dr7);
+
 	barrier();
 
-	set_debugreg(*dr7, 7);
+	set_debugreg(dr7, 7);
+
 	if (info->mask)
-		amd_set_dr_addr_mask(info->mask, i);
+		amd_set_dr_addr_mask(enable ? info->mask : 0, slot);
 
-	return 0;
+	/*
+	 * Disabling:
+	 *   Ensure the write to cpu_dr7 is after we've set the DR7 register.
+	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 */
+	if (!enable)
+		this_cpu_write(cpu_dr7, dr7);
 }
 
 /*
- * Uninstall the breakpoint contained in the given counter.
- *
- * First we search the debug address register it uses and then we disable
- * it.
- *
- * Atomic: we hold the counter->ctx->lock and we only handle variables
- * and registers local to this cpu.
+ * find suitable breakpoint slot and set it up based on the action
  */
-void arch_uninstall_hw_breakpoint(struct perf_event *bp)
+static int arch_manage_bp(struct perf_event *bp, enum bp_slot_action action)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long dr7;
-	int i;
+	struct arch_hw_breakpoint *info;
+	int slot;
 
 	lockdep_assert_irqs_disabled();
 
-	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
-
-		if (*slot == bp) {
-			*slot = NULL;
-			break;
-		}
-	}
-
-	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
-		return;
+	slot = manage_bp_slot(bp, action);
+	if (slot < 0)
+		return slot;
 
-	dr7 = this_cpu_read(cpu_dr7);
-	dr7 &= ~__encode_dr7(i, info->len, info->type);
+	info = counter_arch_bp(bp);
+	setup_hwbp(info, slot, action != BP_SLOT_ACTION_UNINSTALL);
 
-	set_debugreg(dr7, 7);
-	if (info->mask)
-		amd_set_dr_addr_mask(0, i);
+	return 0;
+}
 
-	/*
-	 * Ensure the write to cpu_dr7 is after we've set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
-	 */
-	barrier();
+int arch_install_hw_breakpoint(struct perf_event *bp)
+{
+	return arch_manage_bp(bp, BP_SLOT_ACTION_INSTALL);
+}
 
-	this_cpu_write(cpu_dr7, dr7);
+void arch_uninstall_hw_breakpoint(struct perf_event *bp)
+{
+	arch_manage_bp(bp, BP_SLOT_ACTION_UNINSTALL);
 }
 
 static int arch_bp_generic_len(int x86_len)
-- 
2.53.0


