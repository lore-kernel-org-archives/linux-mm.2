Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F671C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991106B00B0; Sun, 20 Sep 2026 15:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9683B6B00B2; Sun, 20 Sep 2026 15:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836246B00B0; Sun, 20 Sep 2026 15:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9B76B00B0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:38:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BABE71604F7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:27 +0000 (UTC)
X-FDA: 85235152254.27.01D2492
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf28.hostedemail.com (Postfix) with ESMTP id 098E9C0007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kMVsiTnQ;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5j5l9GIwIcGWU8WT7f8DcBXaOCqBMTT8VcXmZE9caw=;
	b=xUxTeyqJOBGPgCWTSRxFb2jf0PAhb4kHDkVuvFMIkrLLYHGxNySSHPy+dq5mlBlbM5224m
	lxXOfUpRCUtL2ZV0uuIdaLzzAnA7mXOTOX7Fn1q+bsDO4XRfMdygrPBtKdg665kAuFXqEY
	+Dl0NasvkgREls4iYvBxQTylQ94NHgk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933106;
	b=Z6+LcKU3qvvODo26VtgCCXUWjL4G3qcud9aGxoEQBjvhMXyiFcFboGf8ZwGI8I1BYyeo8E
	OtV2igHoBqNLRwjWdeDwciSUmw4jYvCvaCCaTmNWdivzgo5crz9RarQDDb5sXot/vA3THm
	tpa5dDykJdMI66N+yfvRj8T6gINBwK4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kMVsiTnQ;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43f9b119so18207357b3.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933105; x=1790537905; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K5j5l9GIwIcGWU8WT7f8DcBXaOCqBMTT8VcXmZE9caw=;
        b=kMVsiTnQEQiZCJLBMw50u69G2KvfuheM/9Uv3aUyRYrtgYGPicZiZdZqi0TYizDVNo
         lzAvC+KJAY6Z4eeufKPW89VAH4YgYV+TrL6PWOjoyBSRtYF6YaDbawBbs9REzl/o/a62
         IXWni3iu4ovyCOgNY8mdiA00VeyOvFwh1Z/u09E59IWoyt9qL65fZWspFDaMzZAUruGv
         uPwGIjHWs5j4Ey2dxY3EczMrmVOsxzsaCawTUdZ5MIzOmRpXG+/JNqsoGR25RZfJ4gQV
         WwL0qK12OJIbm+Aq7zUYspJlsdY6xEz4Hx9BdAzFuwCakJC3zMMEwP8bNV3hSyQxybPV
         nCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933105; x=1790537905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=K5j5l9GIwIcGWU8WT7f8DcBXaOCqBMTT8VcXmZE9caw=;
        b=jTgT1xGzFgAQjOyriVxv13HW3d8o5iSLEInmWXV4yAj+PZEekYnkdThfeYLXr83XMg
         HZo8SuzJdpSvZ6hKoWdtwqLuU7KDow90OP0ZG/tInR4HzXXoU0nfF+pIsV9tEGtYu3IV
         QmqgQIqXsw480qtLe0p3hl4znUJ95SXilbuP0Y11KCShLYXS60OzjurRWt9q26XB5Ov2
         5WANh660vWfBRRR29w0BdbA7F1kqw/Yyrc1dqClky6vScFJku4mAYMieuA4NJz7Ys7b7
         V6Fojzr3cKEfB4G61sm8GtcRuGy8ilyxXCQ/TIxXZFR3bmSwsiJhiy4h+lWru/3Hfimn
         T4/Q==
X-Forwarded-Encrypted: i=1; AKwUvBwAhbojTdwzwC5tODxFx6ZLSxhPChsfn0yKmil25YgOStO9lxC8oU6c6CuTq28ayvGUZzp1nXzyMw==@kvack.org
X-Gm-Message-State: AFuF++nMcmROsQ7bRoIThqZX0Umyng2K/VyQbRN+vscGNk4hgsIzK3vZ
	L85Vma/RrbpTw8GEhm2wJ2kVhvYc663cJkUaFHIM8ICEhwNM3ZFEF7mXVQ6AwwJupTo=
X-Gm-Gg: AYBFou0QXiJMJa1mmbloWmttHysML+JfNOsthBBI2kfngi/EwoP0iHRLWwqUB+HLVQ2
	XgZfyoRbBiuq0iyTqtXrWWyFdIk/anaipBX5RHzrIBnGEzhjJF07UIjIo0BR9hfc5nLOHAqr6Pg
	50A9WBXOXTGy/FM7HwXgpkKh/Ocbgw23FLtkde1sjyMHUqDvv35HpTv2xUhRksvSx02QRQONqBi
	DF5TymuAYWlS5T11T2rj8SnhDLxBF+TdOl5D0kg/XAUWlhHiq4DfLdL+ZRNGzRJ8pjB10TAATiD
	/XWureuz60ZrzmKIGuAq2AOX1By4pjufSis2QWmnhSl2wNYdHymv/7oJB4vLPFUiEh9CegCI7mq
	TFCSXAz8SmReFu7jXMB0a7VWlup+r5mmht8NXRpwDJ06rBRjo1JCc/Um06In0ZSP5Bb/W6G0d6f
	ug/k3e6mj4c9Hbj2Lhq4QBhXrPL5xx+Wcj+US4DdpzpN9HL/N2+9JGtRepdnffFakQhgam54scC
	EBiLFfrIThCTXxazNKrvhCAUElnV+CJTk36Ip1NYtYb/6ID4DrYAQa7cMGkYifugAQIl80Co5wL
	seb+unlX3ecJkC+IPmE=
X-Received: by 2002:a05:690c:a695:b0:873:5ddf:d85a with SMTP id 00721157ae682-897346e4bd2mr18960687b3.37.1789933105074;
        Sun, 20 Sep 2026 12:38:25 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a47af7bfbsm18835137b3.33.2026.09.20.12.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:24 -0700 (PDT)
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
Subject: [RFC PATCH 15/46] cpu_preserve: Add physical CPU preservation lifecycle and build rules
Date: Sun, 20 Sep 2026 15:36:19 -0400
Message-ID: <20260920193650.3373435-16-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 098E9C0007
X-Stat-Signature: 1xhudiusr7ysad9m6h8ccfjozrgcun61
X-Rspam-User: 
X-HE-Tag: 1789933105-486793
X-HE-Meta: U2FsdGVkX1+9uTQq4LU+4GBp3FIK5TyVFnGHc72PY8gQ3cQZA1Bvvidaul7U0idA0IRhWCz0jcaab5h38CsqHpdyXy5yQGDbqPPJ8a3uxRYr+yB1REfOnvVhwsI/+WljSF3AUGRsSL73soj/BDeudy/aHnC5/tgz4KRmYYXhyGfB18y3hJVm6V/aH7QpEed/CmnaGeXOm0LjHVGVpriSxofpBQYogbKffOtwzvEXYnCvNyU+OVK3QkqFLRJQtseUPT1Vn4kNPTQAILfzUOCYUk9NoCNPyaCsNROoH2FtF7/VPSQEvFCl5mLoC6xEj0kaKLSYDQnlIoi+lhO03FkPo3s5bT+unlHi2zOPBWTbT+2xE3PuVA7PJyFjbxGTzGgIO8HwUq6MekW+uHCEKg3thQmAbCiWLyLRCq1ef2IvygFVjM3ffOaXCEdHWj2nnUdfZ5D68ZeV1JeImT+3iMXmQqcvxpvm2KAZxpG7Z/cvbisZQoHrrhaGbbnqsCgvHuHvpy+odJAQ5PHJ7bRJZPsLomCkXUTPSFulovf2r2sPEwmuR3S9tV012Y2pu2O8WzzVW/Lgbkg7HWIC26uLOo044o9QnRYMiDgKqOhWUDoGfJWhigLxTB2sVcFyoIyqNuPtKZqiKTEZZ4yNXHje5wBgKVIx5N2Y5HmLAAtPhX6No4pYuXFZG7mCELsxur4cUFP5ZrodurpOGcCjPNNHk+RX66lR+R8g4qNmefrMC1dL+GcVSD6x07YFwPcDQmTDxqPw4l8CXvY4NZisVGbslNoQUtICCLqqB6iUssElOTYyseQms6F7Y1WzDcsTb87RhnsL7Ok6koLhemDsdJh62cwJTbkXmE+botyBWs4rXRSObFnHhZLh6YZfW48M0F6tOq4zWexru0esc70GFuewk8kxcFP8fDHx4CISj2Q6eHfDMQue2K5No7rB2IyCWpOovpGGrpt1YD3KAuf/zSP1A6W
 aC9/Ruy8
 m9y0JQuxXnZO2/QN8OeqGlU/+9wDmM5IfO/wLWcj8mJu01nwqum1nhQOE5O3oHVQ4+HUF5pVT5OPPdw9o9EdBj8BYWPOqs1Ev7WKbye2GsO3QPKJUpBWGq0l/xCNsnJB1hOR22U2qN8ROXS4eoZcR9Z0TGql5J6TcHyWGc3gKV+Z0yqNXRK4R6JjknLCx3IdUj+hz6EQDrS+gRi2c9CBipZ9Hpft/nvZwhxAUsMMoWFEdvk33JawvOTg1m8Bkk6kr/t/yIgIMUD4mgDNwOzJmTpxmYMVdxwfzU4hRZ0QJ1tFm7w/sqfCKVUZxMeggIM9h+jNvJmBvPC1QnVL+E1JJw06Gmztf+d9XFoPOPGEwylyuiB9qfz0r+Khlrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement physical CPU preservation lifecycle management, stack allocation,
and build rules with -mbranch-protection=none and -fno-stack-protector.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/cpu.c                     |   2 +
 kernel/liveupdate/Kconfig        |  35 +++
 kernel/liveupdate/Makefile       |   3 +
 kernel/liveupdate/cpu_preserve.c | 359 +++++++++++++++++++++++++++++++
 4 files changed, 399 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index b3c8553d7bd6..8637b5e7f2de 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -14,6 +14,7 @@
 #include <linux/sched/smt.h>
 #include <linux/unistd.h>
 #include <linux/cpu.h>
+#include <linux/cpu_preserve.h>
 #include <linux/oom.h>
 #include <linux/rcupdate.h>
 #include <linux/delay.h>
@@ -349,6 +350,7 @@ static inline void cpuhp_ap_update_sync_state(enum cpuhp_sync_state state) { }
 void cpuhp_ap_report_dead(void)
 {
 	cpuhp_ap_update_sync_state(SYNC_STATE_DEAD);
+	cpu_preserved_report_dead();
 }
 
 void __weak arch_cpuhp_cleanup_dead_cpu(unsigned int cpu) { }
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 2490f9a9b838..52c5fd7a620b 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -101,4 +101,39 @@ config LIVEUPDATE_GUEST_MEMFD
 
 	  If unsure, say N.
 
+config ARCH_SUPPORTS_LIVEUPDATE_CPU
+	bool
+
+config LIVEUPDATE_CPU
+	bool "Live update support for preserved CPUs"
+	depends on LIVEUPDATE
+	depends on ARCH_SUPPORTS_LIVEUPDATE_CPU
+	depends on HOTPLUG_CPU
+	default LIVEUPDATE
+	help
+	  Enable live update support for physical CPU preservation.
+
+	  This feature allows physical CPU cores to be preserved across
+	  kexec-based live updates without undergoing a hardware reset or
+	  full kernel offline/online cycle.
+
+	  When a core is preserved, it is isolated from host scheduling and
+	  parked in a dedicated execution loop within preserved memory pages.
+	  Its execution context, state, and necessary page tables are handed
+	  over across the kexec transition using the KHO
+	  framework. The incoming kernel detects preserved cores during early
+	  boot and avoids bringing them up during smp_init(), keeping them
+	  isolated and running their assigned workloads.
+
+	  This capability is a core building block for live-updating virtual
+	  machine hosts (e.g. Caretaker/OrphanVM) without pausing or
+	  disrupting running guest workloads, and can also speed up kernel
+	  live updates by skipping CPU re-initialization.
+
+	  Preservation lifecycle is managed from userspace via LUO sessions
+	  associated with /sys/devices/system/cpu/cpu<N>/preserve file
+	  descriptors, and monitored via sysfs.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index d9f469462556..486f7854bb75 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CFLAGS_cpu_preserve.o += $(call cc-option,-mbranch-protection=none) -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) $(call cc-option,-fno-jump-tables)
+
 luo-y :=								\
 		kho_block.o						\
 		luo_core.o						\
@@ -11,3 +13,4 @@ obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
+obj-$(CONFIG_LIVEUPDATE_CPU)		+= cpu_preserve.o
diff --git a/kernel/liveupdate/cpu_preserve.c b/kernel/liveupdate/cpu_preserve.c
index e19208670c3e..c5fd3a07ccb5 100644
--- a/kernel/liveupdate/cpu_preserve.c
+++ b/kernel/liveupdate/cpu_preserve.c
@@ -247,3 +247,362 @@ static phys_addr_t cpu_preserved_get_data_pa(void)
 	return cpu_preserved_data_pages ? page_to_phys(cpu_preserved_data_pages) : 0;
 }
 
+static void cpu_preserved_sync_global_ser(void)
+{
+	struct cpu_preserved_global_ser *ser = cpu_preserved_global_ser;
+
+	if (!ser)
+		return;
+
+	bitmap_to_arr64(ser->cpu_preserved_bitmap,
+			cpumask_bits(&cpu_preserved_mask), nr_cpu_ids);
+	if (cpu_preserved_text_pages) {
+		ser->text_runtime_pa = page_to_phys(cpu_preserved_text_pages);
+		ser->text_runtime_size =
+			(1UL << cpu_preserved_text_order) * PAGE_SIZE;
+	}
+	if (cpu_preserved_data_pages) {
+		ser->data_runtime_pa = page_to_phys(cpu_preserved_data_pages);
+		ser->data_runtime_size =
+			(1UL << cpu_preserved_data_order) * PAGE_SIZE;
+	}
+	KHOSER_STORE_PTR(ser->pcpus_runtime, cpu_preserved_outgoing.pcpus_ser);
+	cpu_preserved_clean_sz(ser,
+			       struct_size(ser, cpu_preserved_bitmap, ser->nr_cpu_words));
+}
+
+static void cpu_preserved_free_kho(void *va, bool is_incoming)
+{
+	if (!va)
+		return;
+
+	if (is_incoming)
+		kho_restore_free(va);
+	else
+		kho_unpreserve_free(va);
+}
+
+static void cpu_preserved_free_stack(phys_addr_t stack_pa, bool is_incoming)
+{
+	if (stack_pa)
+		cpu_preserved_free_kho(phys_to_virt(stack_pa), is_incoming);
+}
+
+static void cpu_preserved_state_cleanup(struct cpu_preserved_state *st,
+					bool is_incoming)
+{
+	if (!cpumask_empty(&st->mask))
+		return;
+
+	cpu_preserved_free_kho(st->pcpus_ser, is_incoming);
+	st->pcpus_ser = NULL;
+	kfree(st->pcpus);
+	st->pcpus = NULL;
+}
+
+/*
+ * Drop @cpu out of the preserved state, free its preserved stack, and
+ * republish the globals a parked core may still be reading.  The caller holds
+ * cpu_preserved_lock and has already made the core leave the park loop.
+ */
+static void __cpu_unpreserve_locked(unsigned int cpu)
+{
+	struct cpu_preserved_state *incoming = &cpu_preserved_incoming;
+	struct cpu_preserved_state *outgoing = &cpu_preserved_outgoing;
+	struct cpu_preserved_pcpu_ser *ser = cpu_preserved_get_pcpu_ser(cpu);
+	struct cpu_preserved_pcpu *pcpu = cpu_preserved_get_pcpu(cpu);
+	bool is_incoming = cpu_preserved_is_incoming(cpu);
+	phys_addr_t stack_pa = 0;
+
+	lockdep_assert_held(&cpu_preserved_lock);
+
+	cpumask_clear_cpu(cpu, &outgoing->mask);
+	cpumask_clear_cpu(cpu, &incoming->mask);
+	cpumask_clear_cpu(cpu, &cpu_preserved_mask);
+	cpu_preserved_clean(&cpu_preserved_mask);
+	set_cpu_present(cpu, true);
+
+	if (ser)
+		WRITE_ONCE(ser->workload, 0);
+
+	if (pcpu) {
+		stack_pa = pcpu->stack_pa;
+		memset(pcpu, 0, sizeof(*pcpu));
+	}
+
+	cpu_preserved_free_stack(stack_pa, is_incoming);
+
+	/* @pcpu and @ser point into these arrays: do not touch past this point. */
+	cpu_preserved_state_cleanup(outgoing, false);
+	cpu_preserved_state_cleanup(incoming, true);
+
+	if (cpumask_empty(&cpu_preserved_mask)) {
+		WRITE_ONCE(cpu_preserved_pcpus_va, NULL);
+		WRITE_ONCE(cpu_preserved_host_pcpus_va, NULL);
+		cpu_preserved_clean(&cpu_preserved_pcpus_va);
+		cpu_preserved_clean(&cpu_preserved_host_pcpus_va);
+	}
+
+	cpu_preserved_sync_global_ser();
+}
+
+/**
+ * cpu_unpreserve - Unpreserve a physical CPU and restore it to online state
+ * @cpu: Logical CPU identifier.
+ *
+ * Signals the CPU to exit the parking loop, cleans up preserved stack memory,
+ * and restores the core to host scheduling via standard add_cpu().
+ */
+static void cpu_unpreserve(unsigned int cpu)
+{
+	int ret;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		if (!cpu_is_preserved(cpu))
+			return;
+
+		cpu_signal_exit(cpu);
+		arch_cpu_preserved_kick(cpu);
+	}
+
+	/*
+	 * cpu_wait_dead() busy-polls for up to 20 seconds.  Do not hold
+	 * cpu_preserved_lock across it: the poll only reads pcpu->state, which
+	 * stays valid for as long as the CPU is preserved, and holding the lock
+	 * here would stall every other preservation operation and every sysfs
+	 * reader for the entire window.
+	 */
+	if (cpu_wait_dead(cpu))
+		return;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		if (!cpu_is_preserved(cpu))
+			return;
+
+		__cpu_unpreserve_locked(cpu);
+	}
+
+	ret = add_cpu(cpu);
+	if (ret < 0)
+		pr_err("Failed to bring unpreserved cpu %u back online: %d\n",
+		       cpu, ret);
+}
+
+/*
+ * FLB Ops for Preserved CPUs
+ */
+static int cpu_preserved_flb_preserve(struct liveupdate_flb_op_args *argp)
+{
+	unsigned int nr_words = BITS_TO_U64(nr_cpu_ids);
+	struct cpu_preserved_global_ser *ser;
+	size_t ser_sz;
+	int ret;
+
+	ret = cpu_preserved_init_runtime_buffer();
+	if (ret)
+		return ret;
+
+	ser_sz = struct_size(ser, cpu_preserved_bitmap, nr_words);
+
+	mutex_lock(&cpu_preserved_lock);
+	ser = kho_alloc_preserve(ser_sz);
+	if (IS_ERR(ser)) {
+		mutex_unlock(&cpu_preserved_lock);
+		return PTR_ERR(ser);
+	}
+
+	memset(ser, 0, ser_sz);
+	ser->nr_cpu_words = nr_words;
+	cpu_preserved_global_ser = ser;
+	cpu_preserved_sync_global_ser();
+	mutex_unlock(&cpu_preserved_lock);
+
+	argp->data = virt_to_phys(ser);
+	argp->obj = ser;
+	return 0;
+}
+
+static void cpu_preserved_flb_unpreserve(struct liveupdate_flb_op_args *argp)
+{
+	struct cpu_preserved_global_ser *ser;
+
+	if (!argp->data)
+		return;
+
+	ser = phys_to_virt(argp->data);
+	mutex_lock(&cpu_preserved_lock);
+	cpu_preserved_global_ser = NULL;
+	mutex_unlock(&cpu_preserved_lock);
+
+	cpu_preserved_unpreserve_runtime_buffer();
+	kho_unpreserve_free(ser);
+}
+
+static int cpu_preserved_flb_retrieve(struct liveupdate_flb_op_args *argp)
+{
+	struct cpu_preserved_global_ser *ser;
+	struct cpu_preserved_pcpu_ser *pcpus;
+	u64 nr_bits;
+	int cpu;
+
+	if (!argp->data)
+		return -EINVAL;
+
+	ser = phys_to_virt(argp->data);
+	arch_cpu_preserved_early_init();
+
+	/*
+	 * The outgoing kernel may have been built with a larger NR_CPUS.  Any
+	 * preserved CPU we cannot represent would be silently forgotten and
+	 * left spinning in its park loop forever, so refuse the handover
+	 * instead.
+	 */
+	nr_bits = (u64)ser->nr_cpu_words * BITS_PER_TYPE(u64);
+	if (nr_bits > nr_cpu_ids &&
+	    find_next_bit((const unsigned long *)ser->cpu_preserved_bitmap,
+			  nr_bits, nr_cpu_ids) < nr_bits) {
+		pr_err("preserved CPU above nr_cpu_ids=%u in handover data\n",
+		       nr_cpu_ids);
+		return -ERANGE;
+	}
+
+	mutex_lock(&cpu_preserved_lock);
+	bitmap_from_arr64(cpumask_bits(&cpu_preserved_mask),
+			  ser->cpu_preserved_bitmap, min_t(u64, nr_bits, nr_cpu_ids));
+	cpumask_copy(&cpu_preserved_incoming.mask, &cpu_preserved_mask);
+	pcpus = KHOSER_LOAD_PTR(ser->pcpus_runtime);
+
+	if (pcpus) {
+		cpu_preserved_incoming.pcpus_ser = pcpus;
+		WRITE_ONCE(cpu_preserved_pcpus_va, pcpus);
+		cpu_preserved_clean(&cpu_preserved_pcpus_va);
+	}
+	cpu_preserved_clean(&cpu_preserved_mask);
+	for_each_cpu(cpu, &cpu_preserved_mask)
+		set_cpu_present(cpu, false);
+	mutex_unlock(&cpu_preserved_lock);
+
+	argp->obj = ser;
+	return 0;
+}
+
+static void cpu_preserved_flb_finish(struct liveupdate_flb_op_args *argp)
+{
+	struct cpu_preserved_global_ser *ser;
+
+	if (!argp->obj)
+		return;
+
+	ser = argp->obj;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		if (cpu_preserved_incoming.pcpus_ser) {
+			kho_restore_free(cpu_preserved_incoming.pcpus_ser);
+			cpu_preserved_incoming.pcpus_ser = NULL;
+		}
+		kfree(cpu_preserved_incoming.pcpus);
+		cpu_preserved_incoming.pcpus = NULL;
+	}
+
+	if (ser->text_runtime_pa && ser->text_runtime_size) {
+		unsigned long nr_pages = ser->text_runtime_size >> PAGE_SHIFT;
+		struct page *page = kho_restore_pages(ser->text_runtime_pa, nr_pages);
+
+		if (page) {
+			for (unsigned long i = 0; i < nr_pages; i++)
+				__free_page(page + i);
+		}
+	}
+
+	if (ser->data_runtime_pa && ser->data_runtime_size) {
+		unsigned long nr_pages = ser->data_runtime_size >> PAGE_SHIFT;
+		struct page *page = kho_restore_pages(ser->data_runtime_pa, nr_pages);
+
+		if (page) {
+			for (unsigned long i = 0; i < nr_pages; i++)
+				__free_page(page + i);
+		}
+	}
+
+	kho_restore_free(ser);
+}
+
+static const struct liveupdate_flb_ops cpu_preserved_flb_ops = {
+	.preserve   = cpu_preserved_flb_preserve,
+	.unpreserve = cpu_preserved_flb_unpreserve,
+	.retrieve   = cpu_preserved_flb_retrieve,
+	.finish     = cpu_preserved_flb_finish,
+	.owner      = THIS_MODULE,
+};
+
+static struct liveupdate_flb cpu_preserved_flb = {
+	.ops        = &cpu_preserved_flb_ops,
+	.compatible = CPU_PRESERVED_LUO_FLB_COMPATIBLE,
+};
+
+static int cpu_preserve_reboot_notify(struct notifier_block *nb,
+				      unsigned long action, void *data)
+{
+	int cpu;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		for_each_cpu(cpu, &cpu_preserved_mask) {
+			/*
+			 * If this CPU is not being preserved across an outgoing
+			 * live update, signal it to exit the park loop and
+			 * offline it.
+			 */
+			if (kexec_in_progress && liveupdate_enabled() &&
+			    !cpu_preserved_is_incoming(cpu))
+				continue;
+
+			cpu_signal_exit(cpu);
+			arch_cpu_preserved_kick(cpu);
+			if (cpu_wait_dead(cpu))
+				continue;
+
+			__cpu_unpreserve_locked(cpu);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpu_preserve_reboot_nb = {
+	.notifier_call = cpu_preserve_reboot_notify,
+	.priority = 0,
+};
+
+/**
+ * cpu_preserve_early_init - Early boot registration & retrieval of CPUs
+ *
+ * Registers the preserved CPU file handler and FLB with LUO, retrieves incoming
+ * preserved CPU state prior to secondary SMP bringup, and registers the reboot
+ * notifier.
+ *
+ * Return: 0 on success, or negative error code on failure.
+ */
+static int __init cpu_preserve_early_init(void)
+{
+	void *obj;
+	int err;
+
+	if (!liveupdate_enabled())
+		cpumask_clear(&cpu_preserved_mask);
+	cpumask_clear(&cpu_preserved_outgoing.mask);
+	cpumask_clear(&cpu_preserved_incoming.mask);
+	cpu_preserved_outgoing.pcpus = NULL;
+	cpu_preserved_outgoing.pcpus_ser = NULL;
+	cpu_preserved_incoming.pcpus = NULL;
+	cpu_preserved_incoming.pcpus_ser = NULL;
+	cpu_preserved_global_ser = NULL;
+
+	/* Retrieve incoming preserved CPUs before secondary CPU bringup */
+	if (liveupdate_enabled())
+		liveupdate_flb_get_incoming(&cpu_preserved_flb, &obj);
+
+	register_reboot_notifier(&cpu_preserve_reboot_nb);
+
+	return 0;
+}
+early_initcall(cpu_preserve_early_init);
-- 
2.55.0.1082.g2b9226bbc0-goog


