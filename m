Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7469EC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E906B00A7; Sun, 20 Sep 2026 15:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F9C6B00A9; Sun, 20 Sep 2026 15:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E266B00AA; Sun, 20 Sep 2026 15:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 485106B00A7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:38:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E21211C24FA
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:03 +0000 (UTC)
X-FDA: 85235151246.01.540F856
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3287B1C0008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="P1aRB/Qz";
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933082;
	b=qZKnBGAShlrGdwZTp+/uL3nssIQ9Q030I/q5eOjhMa8qHf8fVcC558+Gloimf2Bq69yBIe
	iAunW1yWs4+wexNbg9iEd/RVPuH74ReUfuhyHIhtGKun6RZHHvqS/OwiehKHQIyRyktW61
	TK7SfG/2HgNN9aOox/0FYTUtJk6oLaA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="P1aRB/Qz";
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+SlWroSdaGxZWUb4GAQgkH+PVdX8bfzP0oz7opOlFk=;
	b=5E0iEz8LxiDQ7Dgy6MDgoI65ZIn2os5t/Nx4hcvT3PRNiqhj2mR1uQ2bcqKQIEc8ch7z7f
	l3OMYBfhyldqNiAIU8dHZMZnyVnBx15PkJrX5i04xVQrfIl15eTwnA+r2dWVePz3cQ5U5y
	6r0/ZDeGMk1ZWx44YRiEEFr26Fb1AFk=
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d43ac8d1eso16261837b3.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933081; x=1790537881; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=H+SlWroSdaGxZWUb4GAQgkH+PVdX8bfzP0oz7opOlFk=;
        b=P1aRB/Qz8qJvuuVFWsvrBL2SVIl1cQGHYKbNgMepLNSgMznNrx74L2cnzOw3jSyg5p
         0mK0EYOJETL2KP8eSz+Y3XN7SPMwu5GqMhppK5lfyGucj4rDjPTjq+HsJx8YPF0foY7t
         Un+xIh23L5oh49UBT0wh+L2MMM4+kxoh0paM/VHk4yrVd/IIE6pWDq0OHOL/vKez4yhI
         WLB6U3HFY7GQULcQpVtceia9e2zf+0SR24cgTpneVj+OCoSTb8d0BIOU42bZcH8TlPwz
         WlwOKAwkju5yHpgEK6PzauB02RxcDyBdJ1gVaqdNLir/B6fCK8yW+oZGIbrwEE7jJQQG
         cNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933081; x=1790537881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=H+SlWroSdaGxZWUb4GAQgkH+PVdX8bfzP0oz7opOlFk=;
        b=WrxFAQELIUaWnKx4Vb8G2G2Jjacb1bIU9M99D/LOZU8d6D48HpVhFn1q/02AO5VbVd
         K2l62WnPd9OH/ecJ5tfyAWhnZ4JBJYETR5ADTLMlIxZam0LSo5KUtLGrbjMZ9+2vS0BU
         ejrURGeubE3UPR4Sfe6tvptq7+FoXDk5s9JLnsNVrP8Mc2SnqNgy6BUE9N/PLqlFeELl
         XqHAONo1fvhtjLooj418tXctlGTLFrIKQAe/6eZU+WADgI69kYn+4icMfqEmCnz9BMXb
         U0gSd+nBH5BdnCjzgq0cVRL8+l6432GnzerexFyNsZQ2s2hmjKzlTr8RhCZaDXZKAjG3
         ZgtQ==
X-Forwarded-Encrypted: i=1; AKwUvBxec7zkuX3VJwukOpDvx0FSq24yBhG6iRRXwLqol7JEov1Wt7hmFqATdIBfSQluBYd9sXQVQhHVhg==@kvack.org
X-Gm-Message-State: AFuF++mubLXxL1ZfTHtsxeWGTTQxhnj0b5y2PK/twRxQ+IzoEDcxXQVc
	0HqdWrot22bAQRFQQ+u78MAGU39A1/CG7qvBFe1DQqTWj5loK5IJtxZePz7nAPCfKTY=
X-Gm-Gg: AYBFou08DW2iqdpRNV7enEmAYdZu6LmxRo1al/U/23rGU7dBChTOtQ7vXSZJQFmlbVL
	qpq/85cALmdzU2Gm4Ee7puOPdfRrOglUO9msMoQrf8fOethlrVcT1UCL9v5ScyTol2wNMShfMCx
	xf639CyGdGJFkxFhk9sQ9jY/aI4LXdb0abtvu1vcyBrzuJZCiwP99oyN1+r4sEYD0MyjhObNko6
	0q8+MCCz5/63FxDpEb/hFGrHXqwNXStWBXuoleOxtXuntBNfbwJeGpiUDKmoFPTq/WZ1g+ubo4b
	406hQc3O0NACzoscyTdNv4KE3RPD99pnBID3tKlbf+kikw0VCdV9Zn+IHQWCMJTi+hqnEgoYi4Z
	E9c/a9yM1/mKJgc0fExG6fmB99OI0HytxCkK9m8431NDteh2kdhRVrqVqeOk80UUqTG1qGPSI//
	GEOtFriy/4b7gYPDeWtHuR+Hg4CBvuHN3QeNW2XffHSGim7cjdlrORPOZdlSbC4V0W2d7yuOQ1v
	6mam9BQjuOXkjeTw2Uy8OexaFw8+ROh5nwvZ/PqRFTNMBrtK4Zs/ZBcOyvXmfofgmlxoEgia3SO
	WLuwDkxzq1OnYTpOsgE2
X-Received: by 2002:a05:690c:60c7:b0:873:5c0f:280 with SMTP id 00721157ae682-89735f6df22mr25869157b3.42.1789933081162;
        Sun, 20 Sep 2026 12:38:01 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a46a44699sm18596057b3.19.2026.09.20.12.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:59 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 11/46] liveupdate: Define CPU preservation linker sections
Date: Sun, 20 Sep 2026 15:36:15 -0400
Message-ID: <20260920193650.3373435-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3287B1C0008
X-Stat-Signature: heck8zubc8fo551u7gdw4srefkyqupbf
X-HE-Tag: 1789933082-492292
X-HE-Meta: U2FsdGVkX1/N22E9HDz0bXGHyTSVuIuUh3pds5kLzpSwlK7OePVxfs9gdeU/rfnB5SLGKgD7LSoLLZFTnFu8iFeGf/58pQBN76M5PUPsC9dn32FkPVtMCydwzue7JSOzC00TmdwNcwOZG8weUrG2OWCVJEJlLioXYqeQmJcU49JZ9dlnF57T1UKeUSQEvRKdz+QZqo8tUq9TeY0dyvvDavfnGmSeCoo2IaZFiv1GJKYX+1KSdqF33lkAuaQJjqAq6mP0J0+IWY67Y55aVESSy5rfdPAVM4Ww2os6o3xjy8KcGiDIT3JLbNpPjwd4OKdaddUiv2RaRT8dUqlvWJEqVUKhvRpnVb+s+h/GETJNNkSFvwQiVvi8tWa2VlV2GhPV9Fmo4Wm9NZnKj3lQF73Na4bKGK9a7HCW5cSFKZ6KFNWHGGbo3uZzHGhz3Iak8hMcpNHdww4+wlAVOyqR1+nWvpKp+rq3Ky/7GEjrnt6jSgPDZG7Kmhr69bqsygrK6m0h4A0RTWjLWo37DUL2RKKzRNODg4OJPI6UVCJhPy5Lkp59EdumWQLKipYnz7ZZgQ0ERGHqgQpYUWS8+XADDbjH5Jm+6HXaAP0qyw4dwEjtHFkZaN8FbA3/5YE3dvkecBV719UOrhO32FayU7rUYcNAPD7My9mrPoLwYrSzyqDutXCvs93/AcZMPFsTNLrEreWHsMe0amWsW7j0WGXX2JO3fEyenfN6KcTGlogDBLkm1703KbzQEm+bh/nLcEmQg6qU7GjIa6dIR9cTbb8JIqjkSjC963EaSVLYnS+5RlZgHjYAIhQQxKVD+Hb5IGxhNlzUhsk3tbY4UoKj0SZ62Nt6wUXWfRLy3Spmlo8hlk8Ae0BDGNpckbOmW2ivhMKpTQOR6puGp1k+U9mLOnY2UFnFjZmwR0+eEYLwu7lVeSg7+SGpm27mn/nMiWgQZ5JiRrvNGyJQ+cmSLwPb1yXEafn
 4mW53h1b
 eGNURo7aeC5ZnHiI1/g2ya2qKWGjpJrl+IQvp2aV8znEKlelXCGDCJybImPK48wO7AkisRoYdqrJH92inx/Isiv6ekE0QMj5IL6NoMvOt3Y+Ts8W3RY4f1dhR9MA0V6R6yIVjRwT/Y5RURdjjsWXh/baPuUSJgDfY+mZZs75T2KJS9wO8v7l18WaO4tU2Z3dduFg1I6IXSpoyelGg+gL82A7fN343S1qsp09gIh9dLV7sMufg9zcfduej3B86TOI4BxfrxHzz9p1yvnq6SvVuDwGnJk5u/OR2N8thjPyls6q8onMzNIs1ecNFug0MjcBkDF562YQnaovlDFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define CPU_PRESERVED_TEXT and CPU_PRESERVED_DATA linker macros to place
code and data required for CPU preservation into dedicated sections
(.text.cpu_preserved and .data.cpu_preserved).

These sections are preserved across live update transitions and mapped
executable/read-write as needed.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/asm-generic/vmlinux.lds.h     | 29 +++++++++++++++++
 include/linux/cpu_preserve.h          | 47 +++++++++++++++++++++++++++
 scripts/mod/modpost.c                 | 32 +++++++++++++++---
 tools/objtool/check.c                 | 35 +++++++++++++++++++-
 tools/objtool/include/objtool/check.h |  1 +
 tools/objtool/include/objtool/elf.h   |  2 +-
 6 files changed, 140 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/cpu_preserve.h

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2988aa12f66..0dbaac582bcc 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -655,6 +655,34 @@
 		*(.static_call.text)					\
 		__static_call_text_end = .;
 
+/*
+ * Page-aligned text and data sections for preserved CPUs.
+ * This code and data are KHO preserved when CPUs are preserved across
+ * live update.
+ */
+#ifdef CONFIG_LIVEUPDATE_CPU
+#define CPU_PRESERVED_TEXT						\
+		. = ALIGN(PAGE_SIZE);					\
+		__cpu_preserved_text_start = .;				\
+		*(.text.cpu_preserved .text.cpu_preserved.*)		\
+		*(.cpu_preserved.text .cpu_preserved.text.*)		\
+		. = ALIGN(PAGE_SIZE);					\
+		__cpu_preserved_text_end = .;
+
+#define CPU_PRESERVED_DATA						\
+		. = ALIGN(PAGE_SIZE);					\
+		__cpu_preserved_data_start = .;				\
+		*(.data.cpu_preserved .data.cpu_preserved.*)		\
+		*(.cpu_preserved.data .cpu_preserved.data.*)		\
+		*(.rodata.cpu_preserved .rodata.cpu_preserved.*)	\
+		*(.bss..data.cpu_preserved .bss..data.cpu_preserved.*)	\
+		. = ALIGN(PAGE_SIZE);					\
+		__cpu_preserved_data_end = .;
+#else
+#define CPU_PRESERVED_TEXT
+#define CPU_PRESERVED_DATA
+#endif
+
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  KEEP(*(.head.text))
 
@@ -1155,6 +1183,7 @@
 		INIT_TASK_DATA(inittask)				\
 		NOSAVE_DATA						\
 		PAGE_ALIGNED_DATA(pagealigned)				\
+		CPU_PRESERVED_DATA					\
 		CACHE_HOT_DATA(cacheline)				\
 		CACHELINE_ALIGNED_DATA(cacheline)			\
 		READ_MOSTLY_DATA(cacheline)				\
diff --git a/include/linux/cpu_preserve.h b/include/linux/cpu_preserve.h
new file mode 100644
index 000000000000..f653838c383d
--- /dev/null
+++ b/include/linux/cpu_preserve.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Preserved CPU across Live Update
+ */
+#ifndef _LINUX_CPU_PRESERVE_H
+#define _LINUX_CPU_PRESERVE_H
+
+#include <linux/compiler.h>
+
+#ifdef CONFIG_LIVEUPDATE_CPU
+
+/*
+ * __cpu_preserved_text: Code executed by preserved physical CPUs during live
+ * update kexec handover in orphan mode.
+ *
+ * All code in this section must run without stack protector checks because
+ * per-CPU canary state may be invalid during handover and __stack_chk_fail()
+ * resides in regular .text, which gets overwritten during kexec before the
+ * incoming kernel boots.
+ *
+ * Architecture-specific requirements (such as disabling external retpolines
+ * and return thunks on x86) are supplied via ARCH_CPU_PRESERVED_TEXT.
+ */
+#ifndef ARCH_CPU_PRESERVED_TEXT
+#define ARCH_CPU_PRESERVED_TEXT
+#endif
+
+#define __cpu_preserved_text					\
+	__section(".text.cpu_preserved")			\
+	__no_stack_protector					\
+	ARCH_CPU_PRESERVED_TEXT
+#define __cpu_preserved_data	__section(".data.cpu_preserved")
+
+extern char __cpu_preserved_text_start[], __cpu_preserved_text_end[];
+extern char __cpu_preserved_data_start[], __cpu_preserved_data_end[];
+
+#else /* !CONFIG_LIVEUPDATE_CPU */
+
+#define __cpu_preserved_text
+#define __cpu_preserved_data
+
+#endif /* CONFIG_LIVEUPDATE_CPU */
+
+#endif /* _LINUX_CPU_PRESERVE_H */
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 75374c64b8cc..51631cd2f6c4 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -810,13 +810,27 @@ static void check_section(struct module *mod, struct elf_info *elf,
 #define ALL_INIT_SECTIONS ".init.*"
 #define ALL_EXIT_SECTIONS ".exit.*"
 
+#define ALL_CPU_PRESERVED_TEXT_SECTIONS \
+	".text.cpu_preserved", ".text.cpu_preserved.*", \
+	".cpu_preserved.text", ".cpu_preserved.text.*"
+
+#define ALL_CPU_PRESERVED_DATA_SECTIONS \
+	".data.cpu_preserved", ".data.cpu_preserved.*", \
+	".cpu_preserved.data", ".cpu_preserved.data.*", \
+	".rodata.cpu_preserved", ".rodata.cpu_preserved.*", \
+	".bss..data.cpu_preserved", ".bss..data.cpu_preserved.*"
+
+#define ALL_CPU_PRESERVED_SECTIONS \
+	ALL_CPU_PRESERVED_TEXT_SECTIONS, ALL_CPU_PRESERVED_DATA_SECTIONS
+
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.*", ".sched.text", \
 		".kprobes.text", ".cpuidle.text", ".noinstr.text", \
 		".ltext", ".ltext.*"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", \
-		".coldtext", ".softirqentry.text", ".irqentry.text"
+		".coldtext", ".softirqentry.text", ".irqentry.text", \
+		ALL_CPU_PRESERVED_TEXT_SECTIONS
 
 #define ALL_TEXT_SECTIONS  ".init.text", ".exit.text", \
 		TEXT_SECTIONS, OTHER_TEXT_SECTIONS
@@ -827,6 +841,7 @@ enum mismatch {
 	ANY_INIT_TO_ANY_EXIT,
 	ANY_EXIT_TO_ANY_INIT,
 	EXTABLE_TO_NON_TEXT,
+	CPU_PRESERVED_TO_NON_PRESERVED,
 };
 
 /**
@@ -843,13 +858,19 @@ enum mismatch {
  * @mismatch: Type of mismatch.
  */
 struct sectioncheck {
-	const char *fromsec[20];
-	const char *bad_tosec[20];
-	const char *good_tosec[20];
+	const char *fromsec[32];
+	const char *bad_tosec[32];
+	const char *good_tosec[32];
 	enum mismatch mismatch;
 };
 
 static const struct sectioncheck sectioncheck[] = {
+/* Do not reference non-preserved code/data from cpu_preserved sections */
+{
+	.fromsec = { ALL_CPU_PRESERVED_SECTIONS, NULL },
+	.good_tosec = { ALL_CPU_PRESERVED_SECTIONS, NULL },
+	.mismatch = CPU_PRESERVED_TO_NON_PRESERVED,
+},
 /* Do not reference init/exit code/data from
  * normal code and data
  */
@@ -960,6 +981,9 @@ static const struct sectioncheck *section_mismatch(
 static int secref_whitelist(const char *fromsec, const char *fromsym,
 			    const char *tosec, const char *tosym)
 {
+	if (match(fromsec, PATTERNS(ALL_CPU_PRESERVED_SECTIONS)))
+		return 1;
+
 	/* Check for pattern 1 */
 	if (match(tosec, PATTERNS(ALL_INIT_DATA_SECTIONS)) &&
 	    match(fromsec, PATTERNS(DATA_SECTIONS)) &&
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 464f6c9d9ff0..77389fbfd9ea 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -329,6 +329,8 @@ static void init_insn_state(struct objtool_file *file, struct insn_state *state,
 
 	if (opts.noinstr && sec)
 		state->noinstr = sec->noinstr;
+	if (sec)
+		state->cpu_preserved = sec->cpu_preserved;
 }
 
 static struct cfi_state *cfi_alloc(void)
@@ -419,6 +421,14 @@ static int decode_instructions(struct objtool_file *file)
 		u8 prev_len = 0;
 		u8 idx = 0;
 
+		if (!strncmp(sec->name, ".text.cpu_preserved", 19) ||
+		    !strncmp(sec->name, ".cpu_preserved.text", 19) ||
+		    !strncmp(sec->name, ".data.cpu_preserved", 19) ||
+		    !strncmp(sec->name, ".cpu_preserved.data", 19) ||
+		    !strncmp(sec->name, ".rodata.cpu_preserved", 21) ||
+		    !strncmp(sec->name, ".bss..data.cpu_preserved", 24))
+			sec->cpu_preserved = true;
+
 		if (!is_text_sec(sec))
 			continue;
 
@@ -3511,6 +3521,17 @@ static int validate_call(struct objtool_file *file,
 			 struct instruction *insn,
 			 struct insn_state *state)
 {
+	if (state->cpu_preserved) {
+		struct symbol *dest = insn_call_dest(insn);
+
+		if (dest && (dest->sec->idx != SHN_UNDEF || opts.link) &&
+		    !dest->sec->cpu_preserved) {
+			WARN_INSN(insn, "call to %s() leaves .text.cpu_preserved section",
+				  call_dest_name(insn));
+			return 1;
+		}
+	}
+
 	if (state->noinstr && state->instr <= 0 &&
 	    !noinstr_call_dest(file, insn, insn_call_dest(insn))) {
 		WARN_INSN(insn, "call to %s() leaves .noinstr.text section", call_dest_name(insn));
@@ -4164,7 +4185,13 @@ static int validate_retpoline(struct objtool_file *file)
 		if (insn->retpoline_safe)
 			continue;
 
-		if (insn->sec->init)
+		/*
+		 * Preserved CPU text (.text.cpu_preserved) executes across
+		 * kexec when the outgoing kernel's retpoline/rethunk targets
+		 * are no longer mapped.
+		 */
+		if (insn->sec->init ||
+		    !strcmp(insn->sec->name, ".text.cpu_preserved"))
 			continue;
 
 		if (insn->type == INSN_RETURN) {
@@ -4440,6 +4467,12 @@ static int validate_noinstr_sections(struct objtool_file *file)
 		warnings += validate_unwind_hints(file, sec);
 	}
 
+	sec = find_section_by_name(file->elf, ".text.cpu_preserved");
+	if (sec) {
+		warnings += validate_section(file, sec);
+		warnings += validate_unwind_hints(file, sec);
+	}
+
 	return warnings;
 }
 
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 063f5985fecd..18318f2faf11 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -16,6 +16,7 @@ struct insn_state {
 	bool uaccess;
 	bool df;
 	bool noinstr;
+	bool cpu_preserved;
 	s8 instr;
 };
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index a82517a76a0f..bac9e5f4921f 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -58,7 +58,7 @@ struct section {
 	Elf_Data *data;
 	const char *name;
 	int idx;
-	bool _changed, text, rodata, noinstr, init, truncate;
+	bool _changed, text, rodata, noinstr, init, cpu_preserved, truncate;
 	struct reloc *relocs;
 	unsigned long nr_alloc_relocs;
 	struct section *twin;
-- 
2.55.0.1082.g2b9226bbc0-goog


