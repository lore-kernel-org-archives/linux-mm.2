Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5516FFD45EC
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E886B0088; Wed, 25 Feb 2026 15:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC796B0089; Wed, 25 Feb 2026 15:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79DC46B008A; Wed, 25 Feb 2026 15:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 632566B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:36:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17726140620
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:36:59 +0000 (UTC)
X-FDA: 84484138158.17.78945E1
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5985812000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:36:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VUB3I5Sx;
	spf=pass (imf29.hostedemail.com: domain of 3Z12faQUKCPIYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Z12faQUKCPIYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772051817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3O3Me7fgwyHmdf0v5rLq8O8sd5sCO/cE1nxT2vqkXJo=;
	b=S0N6ObM5gdzz9OmZL1U43HUx+r/1DHi0AhOZG1jqWr1YZppxqjhf0cF0ajaalre0PqTBA7
	fYLGSKJzAqWyzj1TVE+yPq2m+PcWe1hEJ90vkpA0dUzVswQl6x3ZtpoiMr9/XkaBhVctg3
	xdxP0ghaEw2FVAaw1TEkESMTqeA4y5Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VUB3I5Sx;
	spf=pass (imf29.hostedemail.com: domain of 3Z12faQUKCPIYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Z12faQUKCPIYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772051817; a=rsa-sha256;
	cv=none;
	b=kncrn/v1Uc3AGhH0MFEJ7Vxen0H5Z1J6ZJZOHC4a3zCN3xkvWyjezkHsLZdPF8Zg/+rabf
	qQW6aA4BrxFd90YN98q0iOZVUScOxbZVfi3oXnnwP1H05CpFHhlxCLBOyLOToqqEY+Q63S
	rrfn34tP3ogbc/Km3U9tMsFnGAWhNOU=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837f288194so1250225e9.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772051816; x=1772656616; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3O3Me7fgwyHmdf0v5rLq8O8sd5sCO/cE1nxT2vqkXJo=;
        b=VUB3I5Sx0RQXbpxgaS+9Q5nG4DHf/rZP406ICdhdA+hyR8nrf3m3k456k6T5V9GMZ5
         9piEePcDqmHwGAsfKitOYSBC4SspvpJPxGTgqk4zrv1ymvOqOxyoNsSlx0/BMmV44v2C
         3dJrT+NdE6HeNtZYH3kHexTrfq5aQwmEwUUkaTHHLgYhMgVZ7pOByE3spPJqvqYn0f3o
         ePWsLujNm1o/0RiPTc2du4Z1IwYjyRE3L479viXI4BSH14RMfv9McN2EmCZeO55vLVJ2
         aWgW2SrMfl+48MzQiy7H3BkkS6z83ldfiyhkOqDv56gLXnEgLl4LocAEAPhZxBgQKJgE
         7R4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772051816; x=1772656616;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3O3Me7fgwyHmdf0v5rLq8O8sd5sCO/cE1nxT2vqkXJo=;
        b=QmLzSbyJX7AIJKZTjYkMmyZ0Y/WbUveb37zdMXt3Awf30jnxu4Hn1HQdwk65CiyX0I
         NfnzA3skvIuGk5Oe7+dO040bX9/2Y8jb9Ht/w4YRA1NFH1N5TkRQdIXu/JFRTk5s2Kjo
         FIAaEs/hsNoKTsuFVF3Fd1kJYMeIx2NA6BaJjkeqF9cXcnZdLOluKFPxoOq5zFaQlHU2
         3WklQM5XNMzHabLfLeG5givy4rE1X3ZfAXn2OaAfwdp1cKoNjkrBwVb5PNtCZKsAW1st
         VvIraWgh8Bqd+YJjL3bSrtoRoHjCHIvnKR8rYaF/oiS4yZ9Xwn/4OlQdz/zdTIjZueRW
         dSFA==
X-Forwarded-Encrypted: i=1; AJvYcCUdbQLz+c0o+X9AfqrzjTjrilHEhiiLHlWBMrJLNXJ359zehIYnojbilOr4efgWgPHXDIBnmJXo4w==@kvack.org
X-Gm-Message-State: AOJu0Yz4Udi0+SWw60MmjoKNN52Cr+y44LBCrWLvDYT3LTLSVdZ3yRD5
	hGee8GkbGJItW986yYPK2NhSce9a6ltumj2EaMp9QJV71nIMH2CueJIiLuQxbNLb0R/RM7Fs8Wc
	YgQ==
X-Received: from wmbjp9.prod.google.com ([2002:a05:600c:5589:b0:47f:c96e:8381])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:6409:20b0:483:78c5:d743
 with SMTP id 5b1f17b1804b1-483a9637a19mr199333935e9.28.1772051815765; Wed, 25
 Feb 2026 12:36:55 -0800 (PST)
Date: Wed, 25 Feb 2026 21:36:05 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225203639.3159463-1-elver@google.com>
Subject: [PATCH] kfence: add kfence.fault parameter
From: Marco Elver <elver@google.com>
To: elver@google.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-mm@kvack.org, 
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5985812000D
X-Stat-Signature: 1fk9josxd1dgnabjporhu31xwnbdne7z
X-Rspam-User: 
X-HE-Tag: 1772051817-70436
X-HE-Meta: U2FsdGVkX1/MvBF9OIwGFXrBRg6TFAjQt2necj+EnSwEhUrC/ImI/JuC7XSQQMpx4XxTfv900/baAzZXkDYFrrlvpiixyRiDvZRlZDWXe0ET2+ZmB9RGzME/q3dJP3dsUryAWWOdtE0xbmEuqxhHivBc9Fk7i+07+fycabX+guBdVmGhmUfA4wVoIWlyeMWiV8QzQDm1X9OUzsjpUVn0q3M1dhF+0R8gYr4mjKC+wXU8oNbCJPCSYKjMa6rSs++ztuQlNcK8mxK2C8tKlsp9afLn14oqKDvjeMq4wv627b5E6iifQsczteb84gX+fypxRij8Gv5FqDhx5f3iOea5TKAo+tZMdSWCZtW9R5qntU8wlH091CsEqDuI80znMFdhgU3SIO8wyqXQHgvZhrnMyNGSFT6zpgCYrNsg5qRDlJZ59hNudWRAlS0zHX6OiYR/KVn7rcRGsQmB8ocVgX8APUICrPYlGFsbMoiV3n2HIiwtCi1RCTKOLSY0eXlyfdgs1CGAHYu3hp/Az2TOgf+u1X5Uyka9IT+MFzkHjNPP2vp2iyRxbfvysVIh4DW4ny5hF4yEqEUUAKDnWgiA4QimsIe+dZvwETgTL/6vB4U24SoJtwFGXFJgwX2g29LodwOrnhmDByoinwDhOmx/kyFoAaQQTJsZW5bzxuV/XKfnUHY8Jj0f6TYcSqvs+mxza8u19y65UpJHN22gIyR1HA5yfqOuJyH7IKW8KiknGC3CGiKd9ik8e6YChWSilJcCuADdMv1lEl6ou/tnhD8xyn8bKxYbRTdLh/3YBB+Cgb1z7xtFLaByDZiNOjtB7S05XsUT+3SWwHnrZstF/ImhxVIWEf6KDoHr13UpqROzyoyqDQ2EJ0AdfPrxfoyTNi83R6yl9XqY7wYs92BdZhgwv4bsm48dUQTfs6WU8tiOhFKHh8r/AyaFcadNDOWFyqOiOCG7MALC38v/wDsPqnXMzLT
 1fB9Htpj
 dbedYIGS/VyIqJNrMLdmWQLDq1/MOi1EN5nfAT55DllHYr0Zkky3YP1QaPrCzdTyUZpTPtNJLjPTX46oMuZEENSNnI9xrnrnSuC2OoOadYKZcNhRcKNXrzdcj6kxH7hMXDZAuxctMrMQhnGHQr+BItIJgTkHL89wgdTCghOlgAynR4zp28E25bmfs9l8444uBz2SEaxYyme2ZrjfZP0JbmbxhGePXjtd8RSuCLvZeVrERtpdC2cvWUTx3CNLe/ye4AXy2xlf/tGdVL7aSEQGxjW0A8bxM+cBumd4FNK4xCnZG4Kt9R03kpKuPEMrk2cqpUcCPaRFt6psBsB6tPsHHMCd90O90GGM/mela+PsFZqgV1R0uBx/cebMqCjs9VI06nyagRsRxuASnrAvUNHCI50+9g2npsr3lTl49U/8qi5X/YE3gcG20gas19RUxh2dl4Fk3nbi7pjk09bs+82oiM06Rt0EXq0ErlKkexvffZBJ5jmLX2nXNt8euiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kfence.fault parameter to control the behavior when a KFENCE error
is detected (similar in spirit to kasan.fault=<mode>).

The supported modes for kfence.fault=<mode> are:

  - report: print the error report and continue (default).
  - oops: print the error report and oops.
  - panic: print the error report and panic.

In particular, the 'oops' mode offers a trade-off between no mitigation
on report and panicking outright (if panic_on_oops is not set).

Signed-off-by: Marco Elver <elver@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 +++
 Documentation/dev-tools/kfence.rst            |  7 +++
 mm/kfence/core.c                              | 23 ++++++---
 mm/kfence/kfence.h                            | 16 +++++-
 mm/kfence/report.c                            | 49 +++++++++++++++++--
 5 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cb850e5290c2..05acdea306b2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2958,6 +2958,12 @@ Kernel parameters
 			Format: <bool>
 			Default: CONFIG_KFENCE_DEFERRABLE
 
+	kfence.fault=	[MM,KFENCE] Controls the behavior when a KFENCE
+			error is detected.
+			report - print the error report and continue (default).
+			oops   - print the error report and oops.
+			panic  - print the error report and panic.
+
 	kfence.sample_interval=
 			[MM,KFENCE] KFENCE's sample interval in milliseconds.
 			Format: <unsigned integer>
diff --git a/Documentation/dev-tools/kfence.rst b/Documentation/dev-tools/kfence.rst
index 541899353865..b03d1201ddae 100644
--- a/Documentation/dev-tools/kfence.rst
+++ b/Documentation/dev-tools/kfence.rst
@@ -81,6 +81,13 @@ tables being allocated.
 Error reports
 ~~~~~~~~~~~~~
 
+The boot parameter ``kfence.fault`` can be used to control the behavior when a
+KFENCE error is detected:
+
+- ``kfence.fault=report``: Print the error report and continue (default).
+- ``kfence.fault=oops``: Print the error report and oops.
+- ``kfence.fault=panic``: Print the error report and panic.
+
 A typical out-of-bounds access looks like this::
 
     ==================================================================
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index b4ea3262c925..a5f7dffa9f6f 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -50,7 +50,7 @@
 
 /* === Data ================================================================= */
 
-static bool kfence_enabled __read_mostly;
+bool kfence_enabled __read_mostly;
 static bool disabled_by_warn __read_mostly;
 
 unsigned long kfence_sample_interval __read_mostly = CONFIG_KFENCE_SAMPLE_INTERVAL;
@@ -335,6 +335,7 @@ metadata_update_state(struct kfence_metadata *meta, enum kfence_object_state nex
 static check_canary_attributes bool check_canary_byte(u8 *addr)
 {
 	struct kfence_metadata *meta;
+	enum kfence_fault fault;
 	unsigned long flags;
 
 	if (likely(*addr == KFENCE_CANARY_PATTERN_U8(addr)))
@@ -344,8 +345,9 @@ static check_canary_attributes bool check_canary_byte(u8 *addr)
 
 	meta = addr_to_metadata((unsigned long)addr);
 	raw_spin_lock_irqsave(&meta->lock, flags);
-	kfence_report_error((unsigned long)addr, false, NULL, meta, KFENCE_ERROR_CORRUPTION);
+	fault = kfence_report_error((unsigned long)addr, false, NULL, meta, KFENCE_ERROR_CORRUPTION);
 	raw_spin_unlock_irqrestore(&meta->lock, flags);
+	kfence_handle_fault(fault);
 
 	return false;
 }
@@ -524,11 +526,14 @@ static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool z
 	raw_spin_lock_irqsave(&meta->lock, flags);
 
 	if (!kfence_obj_allocated(meta) || meta->addr != (unsigned long)addr) {
+		enum kfence_fault fault;
+
 		/* Invalid or double-free, bail out. */
 		atomic_long_inc(&counters[KFENCE_COUNTER_BUGS]);
-		kfence_report_error((unsigned long)addr, false, NULL, meta,
-				    KFENCE_ERROR_INVALID_FREE);
+		fault = kfence_report_error((unsigned long)addr, false, NULL, meta,
+					    KFENCE_ERROR_INVALID_FREE);
 		raw_spin_unlock_irqrestore(&meta->lock, flags);
+		kfence_handle_fault(fault);
 		return;
 	}
 
@@ -830,7 +835,8 @@ static void kfence_check_all_canary(void)
 static int kfence_check_canary_callback(struct notifier_block *nb,
 					unsigned long reason, void *arg)
 {
-	kfence_check_all_canary();
+	if (READ_ONCE(kfence_enabled))
+		kfence_check_all_canary();
 	return NOTIFY_OK;
 }
 
@@ -1249,6 +1255,7 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 	struct kfence_metadata *to_report = NULL;
 	unsigned long unprotected_page = 0;
 	enum kfence_error_type error_type;
+	enum kfence_fault fault;
 	unsigned long flags;
 
 	if (!is_kfence_address((void *)addr))
@@ -1307,12 +1314,14 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 	if (to_report) {
 		raw_spin_lock_irqsave(&to_report->lock, flags);
 		to_report->unprotected_page = unprotected_page;
-		kfence_report_error(addr, is_write, regs, to_report, error_type);
+		fault = kfence_report_error(addr, is_write, regs, to_report, error_type);
 		raw_spin_unlock_irqrestore(&to_report->lock, flags);
 	} else {
 		/* This may be a UAF or OOB access, but we can't be sure. */
-		kfence_report_error(addr, is_write, regs, NULL, KFENCE_ERROR_INVALID);
+		fault = kfence_report_error(addr, is_write, regs, NULL, KFENCE_ERROR_INVALID);
 	}
 
+	kfence_handle_fault(fault);
+
 	return kfence_unprotect(addr); /* Unprotect and let access proceed. */
 }
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index f9caea007246..1f618f9b0d12 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -16,6 +16,8 @@
 
 #include "../slab.h" /* for struct kmem_cache */
 
+extern bool kfence_enabled;
+
 /*
  * Get the canary byte pattern for @addr. Use a pattern that varies based on the
  * lower 3 bits of the address, to detect memory corruptions with higher
@@ -140,8 +142,18 @@ enum kfence_error_type {
 	KFENCE_ERROR_INVALID_FREE,	/* Invalid free. */
 };
 
-void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
-			 const struct kfence_metadata *meta, enum kfence_error_type type);
+enum kfence_fault {
+	KFENCE_FAULT_NONE,
+	KFENCE_FAULT_REPORT,
+	KFENCE_FAULT_OOPS,
+	KFENCE_FAULT_PANIC,
+};
+
+enum kfence_fault
+kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
+		    const struct kfence_metadata *meta, enum kfence_error_type type);
+
+void kfence_handle_fault(enum kfence_fault fault);
 
 void kfence_print_object(struct seq_file *seq, const struct kfence_metadata *meta) __must_hold(&meta->lock);
 
diff --git a/mm/kfence/report.c b/mm/kfence/report.c
index 787e87c26926..d548536864b1 100644
--- a/mm/kfence/report.c
+++ b/mm/kfence/report.c
@@ -7,9 +7,12 @@
 
 #include <linux/stdarg.h>
 
+#include <linux/bug.h>
+#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/lockdep.h>
 #include <linux/math.h>
+#include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/sched/debug.h>
 #include <linux/seq_file.h>
@@ -29,6 +32,26 @@
 #define ARCH_FUNC_PREFIX ""
 #endif
 
+static enum kfence_fault kfence_fault __ro_after_init = KFENCE_FAULT_REPORT;
+
+static int __init early_kfence_fault(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "report"))
+		kfence_fault = KFENCE_FAULT_REPORT;
+	else if (!strcmp(arg, "oops"))
+		kfence_fault = KFENCE_FAULT_OOPS;
+	else if (!strcmp(arg, "panic"))
+		kfence_fault = KFENCE_FAULT_PANIC;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kfence.fault", early_kfence_fault);
+
 /* Helper function to either print to a seq_file or to console. */
 __printf(2, 3)
 static void seq_con_printf(struct seq_file *seq, const char *fmt, ...)
@@ -189,8 +212,9 @@ static const char *get_access_type(bool is_write)
 	return str_write_read(is_write);
 }
 
-void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
-			 const struct kfence_metadata *meta, enum kfence_error_type type)
+enum kfence_fault
+kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
+		    const struct kfence_metadata *meta, enum kfence_error_type type)
 {
 	unsigned long stack_entries[KFENCE_STACK_DEPTH] = { 0 };
 	const ptrdiff_t object_index = meta ? meta - kfence_metadata : -1;
@@ -206,7 +230,7 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 
 	/* Require non-NULL meta, except if KFENCE_ERROR_INVALID. */
 	if (WARN_ON(type != KFENCE_ERROR_INVALID && !meta))
-		return;
+		return KFENCE_FAULT_NONE;
 
 	/*
 	 * Because we may generate reports in printk-unfriendly parts of the
@@ -282,6 +306,25 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 
 	/* We encountered a memory safety error, taint the kernel! */
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_STILL_OK);
+
+	return kfence_fault;
+}
+
+void kfence_handle_fault(enum kfence_fault fault)
+{
+	switch (fault) {
+	case KFENCE_FAULT_NONE:
+	case KFENCE_FAULT_REPORT:
+		break;
+	case KFENCE_FAULT_OOPS:
+		BUG();
+		break;
+	case KFENCE_FAULT_PANIC:
+		/* Disable KFENCE to avoid recursion if check_on_panic is set. */
+		WRITE_ONCE(kfence_enabled, false);
+		panic("kfence.fault=panic set ...\n");
+		break;
+	}
 }
 
 #ifdef CONFIG_PRINTK
-- 
2.53.0.414.gf7e9f6c205-goog


