Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4642C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67EC6B00C6; Sun, 20 Sep 2026 15:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F916B00C7; Sun, 20 Sep 2026 15:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E146B00C8; Sun, 20 Sep 2026 15:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78A5E6B00C6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:39:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA45F804C0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:39:31 +0000 (UTC)
X-FDA: 85235154942.11.E337D0E
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2522320003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:39:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cn8IPzgM;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5EaTmFX7UEEJKbougudGcIFK6qUIRFfVy3dwTjeVQg=;
	b=x2kb7ak7vd8jCb/fFBAiPNidL6Lt4ywNk+Aaupy1z0ZxbwGUKaB7f0r7rJteX+49H4NO7W
	P7KZ7IT+QjPZjOqus/6oJ9Zwu8M5SNaxX0wzYwVR2dDmxwBewfxjO9Q4FSAz4jcyNAkfsu
	0zGHm708hIPgm/zjkXeASVkEcQejW64=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cn8IPzgM;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933170;
	b=7FV4SWVRlZ3skeNdEHj526MFIxjQVLH0ZwiblhU5cSTRBK3/c8dE6qh/9+B8wE4uOWZJM0
	w6GrJZQTWzpup4E2yk4bO/7B81zzK1B5SzBC2QH1Wh6bDBh0pA8ebEP6RZanNbngbu2DOa
	xEB8ImSLWTCZss50qwAqt5TIqZ8I7Co=
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d440939e3so14292177b3.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933169; x=1790537969; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=k5EaTmFX7UEEJKbougudGcIFK6qUIRFfVy3dwTjeVQg=;
        b=cn8IPzgMYSmREDze3tYyFPzL0G8adn3z9J/90J5KE+7Ej9oEvI0LGjf7Xx4zmfdolV
         s4LXkwM5a126pAawdu4cT5Z1VN2h8wtIHCIqmEQUqeTBkE7xFO2AvnqwcCfUEE/U1pPQ
         0WtM1mHk/0KAux47U1LrtRTWfJOv18C38NKDHnnUdgx/A+C8gloO/WXoDC1hUE9Jv9Mv
         8FfZMasdTIRCKg2gGrqACsgHMvcCI/NZemBZdt52c0Kq2tCUePBRG0DUdEnIYULHwPm8
         +t05WxBFB+ymwOTcPrak6b+0wqQummYKebUcaUcf/0OQWcRxiqp8FUwrqwHmTWuuAM8R
         IikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933169; x=1790537969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=k5EaTmFX7UEEJKbougudGcIFK6qUIRFfVy3dwTjeVQg=;
        b=o2XOvEXkJKGyfMvwYX9ub4C0fhuHwW4vdUF0Wuk/z3GkgLj0oFFCdfFefZEKaORIvp
         6ZThSbpqNxDIB+NjY7KREl1/wPH6bp3zazb1gsMD+cE1ooUuCPVe4nkCCwfUXz+2p/u8
         cddn6xUB6tN+/7tfkY2ao09waOWcTrub/nDfuCaJ9tjOL+hNch7kZN9YFKs3qlUC8b9i
         1Ns6h4ZmJNNqysQGvcfYIT1vxqXj3+8aIZvnriSx7rQ7XyYemu3fZdT9+hLKDkvvDWJv
         J8yPy82GVCBNbY3NuC6QVCk1ZEPo3SBTWa9jtgw4sxdN0y6ngIkk77NcG+7qGHuepkBE
         Z8tA==
X-Forwarded-Encrypted: i=1; AKwUvByZXEWhdItyW68merQAHr/78chL+10AMPmrkDMEJdyfQr9yRe6OWgN0fjrhQptGU7Rzti48YR2Hcw==@kvack.org
X-Gm-Message-State: AFuF++nW5wJ3k0A0J9h1QkZQjvjWlp9JpgnZ79iLwnqoeFuBXLVhVMDg
	TCCJmHiz58qVsXxYE/5LJ5OScUusGPuSi6i7UDPAZBcJYvaHPRxWHplcpbTtZ4K/ILw=
X-Gm-Gg: AYBFou0/+o3ICJ503ruh/HrV64b76yLgk+sds5HnN36VHNWa4rLXNqob0udLLo3llHc
	QgZyYyNw+ZB17dh2tiPuxEEQYTH9tX9p+FbYoad3gRH2ZGXF+DgkxGvw3SMywDWCibruSfeI1hN
	uuPNLAkVbnT8Zi7aJRjHpgjBEZqt9XqcALrcRmLbM84hAvNPQZSs19FvhTtvF3m0evqtyRzdD1y
	4wsiszZHjTEuAIoW8JnSUr1UeN8pplxkwZIreAWC9+7RbeslEx1ogHDACQPSPFOTqYmyavjYj6Q
	WVxTw6BZgrB18FgSabShbAQabS/ttuFPlF1Q9S429pRfz2r14kSAPNKkTnGKhbbouK9To5KxGKw
	IAeOPMBTRrdXd9JZXRoFjA7gcvxymRg0hcIk0c0tDFjTVMwQ0ftW6VRE8AuCDzuY226C1Lhz2nW
	CgIAAbDb5x6qc2g74NvqG0B2TEtL7rGVWHDryOjunQL+fJdvnLBj9+n8tYcmbf8dryZSxGdnALD
	hMFjnCwu+VIOLiuP/8oJaimlP4ayhpEk6pDau5VoOC2HQctGLCjIQfEGAiqkvFUxmq3aRo+DYuY
	iuNUNNcoLlL0VOhCz28=
X-Received: by 2002:a05:690c:6:b0:88c:b8ef:4fb9 with SMTP id 00721157ae682-89736848436mr28151587b3.66.1789933169160;
        Sun, 20 Sep 2026 12:39:29 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a46e4dd4fsm18636037b3.25.2026.09.20.12.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:28 -0700 (PDT)
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
Subject: [RFC PATCH 26/46] oncore: Add on-core KHO ABI and public framework headers
Date: Sun, 20 Sep 2026 15:36:30 -0400
Message-ID: <20260920193650.3373435-27-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2522320003
X-Stat-Signature: 9pupcop9ehr9dnwkkpxytdzgkk8h1nd9
X-Rspam-User: 
X-HE-Tag: 1789933169-855279
X-HE-Meta: U2FsdGVkX19NV2V9a77Y5P65XL3Sd96h1hnlIhBbjOi29lff0vyYE7IRrtY0k9LxU+o1ATl9hEp2B8jIEFSIxzhJf4DqyEteVl/qROtWFu+UorzDoKfnl/Urlvf+tLwe1UbbKmry13z0ZhJKvgxBhSwxDfNbccBHPQ1ezApyYR2zOwdDbvwayQgBpbrlYxjebUdvDxZi6qF1x2cuQguH+vlIWZbI2mft2QXaMlQ9HWkRpNCcBgSubZ9ffHJeY56S3uGOVxIXHtktL2mizOapSaVMaIkymJkJd7RhAKR/tPqjqONE//sneKWaydIpAQP2SODgOj0jVXZg61RwQnOcHHRFIWGIDNBGIzGAostcZNb7zsVrjLc3OnAH32FMTpb4owzRvjCC75N6knm5AK3qHJ1cFudhx93+uT1uX0CrqcoMg3tpuh+szQPufNwaE+lXlyM8amSwFSNpTWM6IQCAWS7kJznCe1ZWDRxj4zdj4Ebo0z4hKAv8veMxvkNyFdEeO8QBvF0xymGBHHZ8Tp4C9hidoOiNKPXHk8dU63yLQfF9Vd9aM7QworotwhvLuGNyv/Gm7eaBO1o/JeMQ+0EAH9rpLV2qMLfaiS2pNTgjF8Qioxbv4uddQRA3QUPdpTp/jy+79SAxAM0qnTeUO4O7o6xs2yGiPQOnUFuZuu/0VdiFWrBxq535xH3zuvjFs2hRuRVUnOhFFZubU1xAo6nHPFAhBoDKocWRJzVMYHHcFqqdzvWvdHxSVxnqGeqLoSmsbbccuF3mPb2IVdmPRFimgGU8dajyS0HrTAYkJ2JnLiaG4a+vuzUbWJrKwS+2FqA+b4Yzt65CxBQEWu+JmGieEz/xTbjQ4pol4GpFx5K1TYSxBXbFMGLR9ghVw3qZkJefntpj2c9xhgHKsI/YNxC3CrmUcZts+BWmcpEOokETbrUgGyPpS8FjlRjyt85G952ra3dyTTlXUnlvAb7+s51
 xmq2nV3k
 mPNg77Wq5lQA61aSZ1JI39GwpASHS6DSMXL4NOHGaiWIYhP1M9IRUA7vCjAtDxeWoszb2rlHywQydxS1ofkV4X/KGiGuvzOXKkEW7LeI/WXtA3hhoITb4pNesv6qMP07Q9cdZn76ixhRbzH41Y7Ukp8fYBsnmHGcoKS5Vw/v8zkbQKqvyPM5VIivv5j2s6+UwvLn4bz+ne+5JUiXCbyrITJMJiGD99HEJrKA6955CyzjckL+wOR4Z1oohaBkaDhdQutSVs1eVIuwuQZA5vNaGW6cPd1hWqtx2biQrbBdW9HqR4pg2eivH/rdm+bAbyC6X76vALvsWv1/5vdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define the On-Core KHO serialization ABI (include/linux/kho/abi/cpu.h)
and public session and job management APIs (include/linux/oncore.h).

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/include/asm/oncore.h |  24 ++++++
 arch/x86/include/asm/oncore.h   |  25 +++++++
 include/linux/kho/abi/cpu.h     |   1 +
 include/linux/oncore.h          | 129 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/Kconfig       |  10 +++
 5 files changed, 189 insertions(+)
 create mode 100644 arch/arm64/include/asm/oncore.h
 create mode 100644 arch/x86/include/asm/oncore.h
 create mode 100644 include/linux/oncore.h

diff --git a/arch/arm64/include/asm/oncore.h b/arch/arm64/include/asm/oncore.h
new file mode 100644
index 000000000000..fbd0f218d867
--- /dev/null
+++ b/arch/arm64/include/asm/oncore.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * ARM64 architecture hooks for On-Core execution.
+ */
+#ifndef _ASM_ARM64_ONCORE_H
+#define _ASM_ARM64_ONCORE_H
+
+#include <linux/types.h>
+#include <asm/arch_timer.h>
+
+static inline u64 __cpu_preserved_text arch_oncore_read_counter(void)
+{
+	return __arch_counter_get_cntpct();
+}
+
+static inline u64 arch_oncore_counter_freq_hz(void)
+{
+	return arch_timer_get_cntfrq();
+}
+
+#endif /* _ASM_ARM64_ONCORE_H */
diff --git a/arch/x86/include/asm/oncore.h b/arch/x86/include/asm/oncore.h
new file mode 100644
index 000000000000..f64697a95d6a
--- /dev/null
+++ b/arch/x86/include/asm/oncore.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * x86 architecture hooks for On-Core execution.
+ */
+#ifndef _ASM_X86_ONCORE_H
+#define _ASM_X86_ONCORE_H
+
+#include <linux/types.h>
+#include <asm/msr.h>
+#include <asm/tsc.h>
+
+static inline u64 __cpu_preserved_text arch_oncore_read_counter(void)
+{
+	return rdtsc();
+}
+
+static inline u64 arch_oncore_counter_freq_hz(void)
+{
+	return (u64)tsc_khz * 1000ULL;
+}
+
+#endif /* _ASM_X86_ONCORE_H */
diff --git a/include/linux/kho/abi/cpu.h b/include/linux/kho/abi/cpu.h
index f75bfb4c6161..4d63e623f162 100644
--- a/include/linux/kho/abi/cpu.h
+++ b/include/linux/kho/abi/cpu.h
@@ -145,6 +145,7 @@ struct cpu_preserved_file_ser {
 	u32 cpu;
 	u32 reserved;
 	u64 stack_pa;
+	DECLARE_KHOSER_PTR(oncore, struct oncore_session_ser *);
 } __packed;
 
 #endif /* _LINUX_KHO_ABI_CPU_H */
diff --git a/include/linux/oncore.h b/include/linux/oncore.h
new file mode 100644
index 000000000000..2817b0282a32
--- /dev/null
+++ b/include/linux/oncore.h
@@ -0,0 +1,129 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * On-Core Session and Scheduling Framework for Live Update
+ */
+#ifndef __LINUX_ONCORE_H
+#define __LINUX_ONCORE_H
+
+#include <linux/cpu_preserve.h>
+#include <linux/types.h>
+
+/*
+ * Only ever used as an opaque handle here, so do not include
+ * <linux/liveupdate.h>: this header is reached from <linux/kvm_host.h> via
+ * <linux/kvm_caretaker.h>, and including it would drag the entire LUO header
+ * stack into every KVM translation unit on every architecture.
+ */
+struct liveupdate_session;
+struct oncore_session;
+struct oncore_session_ser;
+struct oncore_job;
+
+#include <asm/oncore.h>
+
+/**
+ * enum oncore_exit_reason - Why an on-core job returned to the scheduler
+ * @ONCORE_EXIT_QUANTUM_EXPIRED: Time slice elapsed; the job is still runnable.
+ * @ONCORE_EXIT_ATTACH_SIGNALED: The incoming kernel asked for the CPU back.
+ * @ONCORE_EXIT_YIELD_IDLE: The job has no work right now (guest HLT/WFI).
+ * @ONCORE_EXIT_ERROR: The job hit an unrecoverable error and must be dropped.
+ * @ONCORE_EXIT_STALL: The job hit something it cannot handle on-core and
+ *                     cannot make forward progress until the incoming kernel
+ *                     reclaims it.  Unlike %ONCORE_EXIT_QUANTUM_EXPIRED, an
+ *                     immediate re-run is guaranteed to hit the same wall, so
+ *                     the scheduler backs off instead of spinning.
+ */
+enum oncore_exit_reason {
+	ONCORE_EXIT_QUANTUM_EXPIRED = 0,
+	ONCORE_EXIT_ATTACH_SIGNALED,
+	ONCORE_EXIT_YIELD_IDLE,
+	ONCORE_EXIT_ERROR,
+	ONCORE_EXIT_STALL,
+};
+
+typedef enum oncore_exit_reason (*oncore_job_fn)(void *data,
+						 u64 deadline_ticks);
+
+#ifdef CONFIG_LIVEUPDATE_ONCORE
+int oncore_session_add_cpu(struct liveupdate_session *s, int cpu);
+void oncore_session_remove_cpu(struct liveupdate_session *s, int cpu);
+struct oncore_session_ser *oncore_session_get_ser(struct liveupdate_session *s);
+void oncore_session_restore(struct liveupdate_session *s,
+			    struct oncore_session_ser *ser);
+phys_addr_t oncore_session_get_pgd_pa(struct oncore_session *sess);
+struct oncore_job *oncore_session_submit_job(struct liveupdate_session *s,
+					     oncore_job_fn run_fn,
+					     void *data);
+int oncore_session_activate_job(struct liveupdate_session *s,
+				struct oncore_job *job);
+void oncore_job_set_data(struct oncore_job *job, void *data);
+int oncore_job_cpu(const struct oncore_job *job);
+struct oncore_session *oncore_job_session(const struct oncore_job *job);
+int oncore_session_cancel_job(struct liveupdate_session *s,
+			      struct oncore_job *job);
+int oncore_session_map_range(struct oncore_session *sess, phys_addr_t pa,
+			     unsigned long va, size_t size, pgprot_t prot);
+int oncore_session_map_buffer(struct oncore_session *sess, void *va,
+			      size_t size);
+#else
+static inline int oncore_session_add_cpu(struct liveupdate_session *s, int cpu) { return 0; }
+
+static inline void oncore_session_remove_cpu(struct liveupdate_session *s, int cpu) {}
+
+static inline struct oncore_session_ser *
+oncore_session_get_ser(struct liveupdate_session *s)
+{
+	return NULL;
+}
+
+static inline void oncore_session_restore(struct liveupdate_session *s,
+					  struct oncore_session_ser *ser) {}
+
+static inline phys_addr_t oncore_session_get_pgd_pa(struct oncore_session *sess) { return 0; }
+
+static inline struct oncore_job *oncore_session_submit_job(struct liveupdate_session *s,
+							   oncore_job_fn run_fn,
+							   void *data)
+{
+	return NULL;
+}
+
+static inline int oncore_session_activate_job(struct liveupdate_session *s,
+					      struct oncore_job *job)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void oncore_job_set_data(struct oncore_job *job, void *data) {}
+
+static inline int oncore_job_cpu(const struct oncore_job *job) { return -1; }
+
+static inline struct oncore_session *
+oncore_job_session(const struct oncore_job *job)
+{
+	return NULL;
+}
+
+static inline int oncore_session_cancel_job(struct liveupdate_session *s,
+					    struct oncore_job *job)
+{
+	return 0;
+}
+
+static inline int oncore_session_map_range(struct oncore_session *sess, phys_addr_t pa,
+					   unsigned long va, size_t size, pgprot_t prot)
+{
+	return 0;
+}
+
+static inline int oncore_session_map_buffer(struct oncore_session *sess, void *va,
+					    size_t size)
+{
+	return 0;
+}
+#endif /* CONFIG_LIVEUPDATE_ONCORE */
+
+#endif /* __LINUX_ONCORE_H */
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 52c5fd7a620b..0e1f72de2a48 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -136,4 +136,14 @@ config LIVEUPDATE_CPU
 
 	  If unsure, say N.
 
+config LIVEUPDATE_ONCORE
+	bool "On-core execution framework"
+	depends on LIVEUPDATE_CPU
+	default LIVEUPDATE_CPU
+	help
+	  Provide the on-core execution session and job scheduling framework
+	  for workloads running on preserved physical CPUs across a host
+	  live update (kexec handover). This allows subsystems such as KVM
+	  Caretaker to bind jobs to isolated physical cores during kexec.
+
 endmenu
-- 
2.55.0.1082.g2b9226bbc0-goog


