Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D0BCCD184
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1197E8E0008; Sun, 19 Oct 2025 02:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9568E0002; Sun, 19 Oct 2025 02:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F708E0008; Sun, 19 Oct 2025 02:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D307E8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:16:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87B2213B341
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:16:53 +0000 (UTC)
X-FDA: 84013855506.04.6D33E69
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F4A240005
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:16:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YhklciWm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASOuu0vLLkYA4SCgQcRVW0CFmaVqIaRDuU0cccUVqmU=;
	b=dqTXMZ/qYJYVrpTbLNCJW0aTeB8HE5u5tfHDWjeqz+W3QXumjsGN88k1SvEwdVWT881oBI
	OJY90aVey1ZCn2XJHephhDDIGQtfYAccTD4wstoJKgygtYBmF6djcapDP6PHW45M2xaGfq
	Ig7ElsSl8RbORwFP2u4kKEbMWxTKTtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854611; a=rsa-sha256;
	cv=none;
	b=KM2ZO3h1MGeD7rhrcnhZbadvZ7rLuX7hiilhSUa0Dl8jWWJPccOlPCYvQHkBqJjDjkgdYO
	4fahqXgAtCjGzvevXMub81H+jEVzJHYhWYxwGlMi58KZb0/O9h5ZwyxZivMihraDeSgcfw
	xsr55Dq8uMpuUXqTfYxpebUfzTbWH8w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YhklciWm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7a23208a0c2so647157b3a.0
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854610; x=1761459410; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ASOuu0vLLkYA4SCgQcRVW0CFmaVqIaRDuU0cccUVqmU=;
        b=YhklciWmPCGzYAfpFpi+o5Xue/qbWNjCOuSX9JzeyuJEzuK5cfqQDFx7OErmUqMzCs
         MPB9pIn3bRMeLt45NLsmHO8jP4XamdRxI+a6o+ybIvT1l5ysIsWP17KupdQU2SOUFZbq
         3ElCbFsHClhCVR30/xMqy+uuPTZs+TxL5Sx3CkB5oxPSouRUca3cBpm6m1O3EZ0VFMsU
         d5ng/DiTNI+4DDxPYnLZs8fv+KOX8RWFqNW+u75bcKIeAG2k+eIMY7yiU2Alyhq1I31h
         alBbw7cTx5/XpD42pJlrnM3XUrnUaAI6poXpIJ46SOz/+SDucmc/kg8sFCYdeMPKttMC
         7DvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854610; x=1761459410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ASOuu0vLLkYA4SCgQcRVW0CFmaVqIaRDuU0cccUVqmU=;
        b=rFQlAI7x9C/CN98stSfcQF36jqebNLZteb4azqtgRNWAVNr3lnzVtq97MnL3z38OUl
         IzXvpvY8POJQy/0S220bZeddbreno1AZ1u7ef6FCCrLiasAFE0ak8qasR4G9IbXRt6Gn
         n4i/XtBCGJXQ0U8tcYWdA1wNd8RVYzPEB47jLho7+yI27Bj2VIeSJgYJ0lfwrTChNYEC
         aTNhEtuQ0NsRfeU30kIhXisS7CRqZU0g1zrbbmVCkT6qzA5akTE2lL2KbvHdjZqE4lrU
         Wf8SQTUDp9mgsLN1gFKql5gjPr2DabWoMz7hl1ODTAikDRvZCm9Ky9RXjjBEDluZYUcF
         VI6A==
X-Forwarded-Encrypted: i=1; AJvYcCVU/Pfufh58RjHSkmUtCR1fwgeZ+0q+k/Q+uN/+/hRy7DywfXlsCMS9f0mvR7bhHeOjDeQyIwIYlg==@kvack.org
X-Gm-Message-State: AOJu0YyPMakkVpLFwbVV7Fjr0Ql6ug79I8n51sEbwN0/FQR4Q992gTNT
	NoPvULo3jFtl+r9w412oQVR82Jeo9wDg6oYUx77Ot0sH6e6YL7AVL9S2
X-Gm-Gg: ASbGnctYwLgDFNEf3L9yhi3MEQXv/AVCMN2OXYgzrIbTyoPTqOkewZ2HtE7dvxpT8+1
	Tb5MAwlZRFM73l4sgoexSfdsV8chYNdgDbmWgg36xUGUQ/73ZkfKsjI+azZgsgDauSmubSXPROD
	01/iQhIJErQijVRt5r20Aixmzm5T/rpSaSjQBajlonuyi9F40dsBHZ+9kahSVSaGc5hObsPrLbQ
	Yu8VEO07/PBSjGrqYs3+mKPF9NLUWDd8yuD/L6qKGQPqyWKPLbAE00sLzqbKJMuPkEOZZ157Qhf
	ZmikUH2ReC8E2Pga6gsU0xHBtgIqtx088kHVDL4Zu4QKgh/Yvae8VOkOpvIiL0ElkMDP3sr5LjR
	MUME73+8o7uVE1hZqPnWaVuexTS58iYuxEZw7NtMXl28d1dz8E9zA+4xlRu+xFeEd58LmRzjgVh
	1s/NPb
X-Google-Smtp-Source: AGHT+IHcUYO9o6/V8YsIgbXToAumR6ZpDXIuRlYfIC0ZEiQ0uD3wnq9KGJNzH0DhGnF60uXtoY0gew==
X-Received: by 2002:a05:6a20:6a07:b0:334:9f87:17e8 with SMTP id adf61e73a8af0-334a8610a1emr11564376637.38.1760854610412;
        Sat, 18 Oct 2025 23:16:50 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:16:49 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 01/16] kexec: Introduce multikernel support via kexec
Date: Sat, 18 Oct 2025 23:16:15 -0700
Message-Id: <20251019061631.2235405-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: ejhdo1w5ys8xiqnpagp5iaicf6j9qrc5
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F4A240005
X-HE-Tag: 1760854611-357744
X-HE-Meta: U2FsdGVkX1/ihn6w1eFEnQ1yV2xFJgjy245y9oj+kj3XY2ce/V5oiJMBv8bRDQZekBvCK67F50eaAYAV3AJPSwGd7tbhxdRYFvYRPtizyUjAbVh4JILyaXKIjoNWPG4SdVYFDERPLL5katDb98XWCWYBo9eWr/z2G5YnrF8qcbLTABkOlKj1iVEuwIIojL1f6GSqDoDJZjlXhuFPP90r47+dNVUwK5vHrGDJ/SpOPxwz9K1TYjSwP0Z4mx93HWivu6BCUh7scHlXabLEjTEThsIlEq5z6sVBJWLv/HS74Z/AHTuXvfnjoR/M61uAAi24iALbiFPTvkGr1Twt8GifqKMvP10iFYff/4hjyL8nshWBQnL+J6mHO5krpouASRqnJQ7OgwSBsjDbHZVvhclbekpj4MyG5YKqDZiv+pSAEuL5BuI327XiKT12x6Qudty+xzQo6GIDC2v/JSVqPlzY9G4k1oiALIIXPn6SwbmBFIC29ZlfZkaE+UJotJB8NrhyU7MqCJNUDDkw9hJo7NdKPwCqVL1irHGKozkFX7rPQZZApc++3Pp+s6H2eLgdV1Tr+KUC3Gb08t2w9YApsYHN7F6n1nSNtlAj0SGdQSAzO1a7XYA+ScegLgbF5DipaLFklET/VWkmcOBrXos/wM4cGOvnDzT8u74BoL8MaO50Z7Z+kDhYDsT1U9XYrQ6X3tcCRf6+BKd7boZX+Ku+S9hZzKzJekQARR5IvBwRNFZkfgwqP4YtXIJgUpP6Br6xWlaZ4eWmxG1SLrMDwcEw47bT6OdGtno0XvmAaDfNFcytORtwmAlfmOljLBX/RQptdtZJANmUHdUTxnAkliBMMEvVIiiLTch4CTbpHDeMo1rX4kxUiTfuhy9p5RL/L8mMLZWHmUHMacBTjEZZoWmxWkC+gLboePQDDu8BZocWtkemZjtHRiw0OpLD+pKGQgW+vqQL0+8AeotmXje08o7PKyM
 yeelvQ3y
 K69IrsfZoNO8u6U6gcKFDzrx1IMZgz9RkqR7iHv1GOSQ/hz5eAdrcgWT9B6kac6uyuKqRuMeqSeAosyNuQ2D4iD97oC57fpqkApthZGq3LmRcuL77xN6PNIP9kTYwli2Hqeb7//BOChTbiy33JSbZvFsdkF4RqoOVwZwXjt4qp614vJHWrf0lW6gOt1kAru6S5eYEx9ueO8b6qH/uQFXalWGKlk+xI413LB7oRDITIVlIOtzSIi1sW4x1UcndDD3YFww9xvhOtRlyuWgqOOdzQ2WRHPdsiMTlkWocBpejpjmpPeR/IjAw4S+5DTXekbmSHEW2ytLC3kynycE+FAWVg/Cvda30m5O04kOU27Pazto/ZikhZnl1MG29iJqk2yRhpz2dQx/zQfdf2ljnYHgx5u3DFJXOq2dojXJmrdXLvJhvbCEKsy8fb9B56jqgv5yErFh4EKFpKfvRMqEtjKsiSE0eZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

This patch extends the kexec subsystem to support multikernel
functionality, allowing different kernel instances to be loaded and
executed on specific CPUs. The implementation introduces:

- New KEXEC_TYPE_MULTIKERNEL type and KEXEC_MULTIKERNEL flag

- multikernel_kick_ap() function for CPU-specific kernel booting

- LINUX_REBOOT_CMD_MULTIKERNEL reboot command with CPU parameter

- Specialized segment loading for multikernel images using memremap

- Integration with existing kexec infrastructure while bypassing
  standard machine_kexec_prepare() for avoiding resets

The multikernel_kexec() function validates CPU availability and uses
the existing kexec image start address to boot the target CPU with
a different kernel instance. This enables heterogeneous computing
scenarios where different CPUs can run specialized kernel variants.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 arch/x86/include/asm/smp.h  |   1 +
 arch/x86/kernel/smpboot.c   | 104 ++++++++++++++++++++++++++++++++++
 include/linux/kexec.h       |   6 +-
 include/uapi/linux/kexec.h  |   1 +
 include/uapi/linux/reboot.h |   2 +-
 kernel/kexec_core.c         | 109 ++++++++++++++++++++++++++++++++++++
 kernel/reboot.c             |  10 ++++
 7 files changed, 230 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 22bfebe6776d..1a59fd0de759 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -107,6 +107,7 @@ void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int common_cpu_up(unsigned int cpunum, struct task_struct *tidle);
 int native_kick_ap(unsigned int cpu, struct task_struct *tidle);
+int multikernel_kick_ap(unsigned int cpu, unsigned long kernel_start_address);
 int native_cpu_disable(void);
 void __noreturn hlt_play_dead(void);
 void native_play_dead(void);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index eb289abece23..7b27fdc1d169 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -833,6 +833,72 @@ int common_cpu_up(unsigned int cpu, struct task_struct *idle)
 	return 0;
 }
 
+// must be locked by cpus_read_lock()
+static int do_multikernel_boot_cpu(u32 apicid, int cpu, unsigned long kernel_start_address)
+{
+	unsigned long start_ip = real_mode_header->trampoline_start;
+	int ret;
+
+	pr_info("do_multikernel_boot_cpu(apicid=%u, cpu=%u, kernel_start_address=%lx)\n", apicid, cpu, kernel_start_address);
+#ifdef CONFIG_X86_64
+	/* If 64-bit wakeup method exists, use the 64-bit mode trampoline IP */
+	if (apic->wakeup_secondary_cpu_64)
+		start_ip = real_mode_header->trampoline_start64;
+#endif
+	//initial_code = (unsigned long)start_secondary;
+	initial_code = (unsigned long)kernel_start_address;
+
+	if (IS_ENABLED(CONFIG_X86_32)) {
+		early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
+		//initial_stack  = idle->thread.sp;
+	} else if (!(smpboot_control & STARTUP_PARALLEL_MASK)) {
+		smpboot_control = cpu;
+	}
+
+	/* Skip init_espfix_ap(cpu); */
+
+	/* Skip announce_cpu(cpu, apicid); */
+
+	/*
+	 * This grunge runs the startup process for
+	 * the targeted processor.
+	 */
+	if (x86_platform.legacy.warm_reset) {
+
+		pr_debug("Setting warm reset code and vector.\n");
+
+		smpboot_setup_warm_reset_vector(start_ip);
+		/*
+		 * Be paranoid about clearing APIC errors.
+		*/
+		if (APIC_INTEGRATED(boot_cpu_apic_version)) {
+			apic_write(APIC_ESR, 0);
+			apic_read(APIC_ESR);
+		}
+	}
+
+	smp_mb();
+
+	/*
+	 * Wake up a CPU in difference cases:
+	 * - Use a method from the APIC driver if one defined, with wakeup
+	 *   straight to 64-bit mode preferred over wakeup to RM.
+	 * Otherwise,
+	 * - Use an INIT boot APIC message
+	 */
+	if (apic->wakeup_secondary_cpu_64)
+		ret = apic->wakeup_secondary_cpu_64(apicid, start_ip, cpu);
+	else if (apic->wakeup_secondary_cpu)
+		ret = apic->wakeup_secondary_cpu(apicid, start_ip, cpu);
+	else
+		ret = wakeup_secondary_cpu_via_init(apicid, start_ip, cpu);
+
+	pr_info("do_multikernel_boot_cpu end\n");
+	/* If the wakeup mechanism failed, cleanup the warm reset vector */
+	if (ret)
+		arch_cpuhp_cleanup_kick_cpu(cpu);
+	return ret;
+}
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
@@ -905,6 +971,44 @@ static int do_boot_cpu(u32 apicid, unsigned int cpu, struct task_struct *idle)
 	return ret;
 }
 
+// must be locked by cpus_read_lock()
+int multikernel_kick_ap(unsigned int cpu, unsigned long kernel_start_address)
+{
+	u32 apicid = apic->cpu_present_to_apicid(cpu);
+	int err;
+
+	lockdep_assert_irqs_enabled();
+
+	pr_info("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
+
+	if (apicid == BAD_APICID || !apic_id_valid(apicid)) {
+		pr_err("CPU %u has invalid APIC ID %x. Aborting bringup\n", cpu, apicid);
+		return -EINVAL;
+	}
+
+	if (!test_bit(apicid, phys_cpu_present_map)) {
+		pr_err("CPU %u APIC ID %x is not present. Aborting bringup\n", cpu, apicid);
+		return -EINVAL;
+	}
+
+	/*
+	 * Save current MTRR state in case it was changed since early boot
+	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
+	 */
+	mtrr_save_state();
+
+	/* the FPU context is blank, nobody can own it */
+	per_cpu(fpu_fpregs_owner_ctx, cpu) = NULL;
+	/* skip common_cpu_up(cpu, tidle); */
+
+	err = do_multikernel_boot_cpu(apicid, cpu, kernel_start_address);
+	if (err)
+		pr_err("do_multikernel_boot_cpu failed(%d) to wakeup CPU#%u\n", err, cpu);
+
+	return err;
+}
+
+
 int native_kick_ap(unsigned int cpu, struct task_struct *tidle)
 {
 	u32 apicid = apic->cpu_present_to_apicid(cpu);
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index ff7e231b0485..edf64bc98ed5 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -358,9 +358,10 @@ struct kimage {
 	unsigned long control_page;
 
 	/* Flags to indicate special processing */
-	unsigned int type : 1;
+	unsigned int type : 2;
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
+#define KEXEC_TYPE_MULTIKERNEL 2
 	unsigned int preserve_context : 1;
 	/* If set, we are using file mode kexec syscall */
 	unsigned int file_mode:1;
@@ -437,6 +438,7 @@ extern void machine_kexec(struct kimage *image);
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
 extern int kernel_kexec(void);
+extern int multikernel_kexec(int cpu);
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
 
@@ -458,7 +460,7 @@ bool kexec_load_permitted(int kexec_image_type);
 #define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_UPDATE_ELFCOREHDR | KEXEC_CRASH_HOTPLUG_SUPPORT)
 #else
 #define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT | KEXEC_UPDATE_ELFCOREHDR | \
-			KEXEC_CRASH_HOTPLUG_SUPPORT)
+			KEXEC_CRASH_HOTPLUG_SUPPORT | KEXEC_MULTIKERNEL)
 #endif
 
 /* List of defined/legal kexec file flags */
diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
index 55749cb0b81d..346e0ff4e663 100644
--- a/include/uapi/linux/kexec.h
+++ b/include/uapi/linux/kexec.h
@@ -14,6 +14,7 @@
 #define KEXEC_PRESERVE_CONTEXT	0x00000002
 #define KEXEC_UPDATE_ELFCOREHDR	0x00000004
 #define KEXEC_CRASH_HOTPLUG_SUPPORT 0x00000008
+#define KEXEC_MULTIKERNEL	0x00000010
 #define KEXEC_ARCH_MASK		0xffff0000
 
 /*
diff --git a/include/uapi/linux/reboot.h b/include/uapi/linux/reboot.h
index 58e64398efc5..aac2f2f94a98 100644
--- a/include/uapi/linux/reboot.h
+++ b/include/uapi/linux/reboot.h
@@ -34,7 +34,7 @@
 #define	LINUX_REBOOT_CMD_RESTART2	0xA1B2C3D4
 #define	LINUX_REBOOT_CMD_SW_SUSPEND	0xD000FCE2
 #define	LINUX_REBOOT_CMD_KEXEC		0x45584543
-
+#define	LINUX_REBOOT_CMD_MULTIKERNEL	0x4D4B4C49
 
 
 #endif /* _UAPI_LINUX_REBOOT_H */
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index fa00b239c5d9..7d89d00e2cde 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -41,6 +41,7 @@
 #include <linux/objtool.h>
 #include <linux/kmsg_dump.h>
 #include <linux/dma-map-ops.h>
+#include <linux/memblock.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -942,6 +943,84 @@ static int kimage_load_crash_segment(struct kimage *image, int idx)
 }
 #endif
 
+static int kimage_load_multikernel_segment(struct kimage *image, int idx)
+{
+	/* For multikernel we simply copy the data from
+	 * user space to it's destination.
+	 * We do things a page at a time for the sake of kmap.
+	 */
+	struct kexec_segment *segment = &image->segment[idx];
+	unsigned long maddr;
+	size_t ubytes, mbytes;
+	int result;
+	unsigned char __user *buf = NULL;
+	unsigned char *kbuf = NULL;
+
+	result = 0;
+	if (image->file_mode)
+		kbuf = segment->kbuf;
+	else
+		buf = segment->buf;
+	ubytes = segment->bufsz;
+	mbytes = segment->memsz;
+	maddr = segment->mem;
+	pr_info("Loading multikernel segment: mem=0x%lx, memsz=0x%zu, buf=0x%px, bufsz=0x%zu\n",
+		maddr, mbytes, buf, ubytes);
+	while (mbytes) {
+		char *ptr;
+		size_t uchunk, mchunk;
+		unsigned long page_addr = maddr & PAGE_MASK;
+		unsigned long page_offset = maddr & ~PAGE_MASK;
+
+		/* Use memremap to map the physical address */
+		ptr = memremap(page_addr, PAGE_SIZE, MEMREMAP_WB);
+		if (!ptr) {
+			pr_err("Failed to memremap memory at 0x%lx\n", page_addr);
+			result = -ENOMEM;
+			goto out;
+		}
+
+		/* Adjust pointer to the offset within the page */
+		ptr += page_offset;
+
+		/* Calculate chunk sizes */
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE - page_offset);
+		uchunk = min(ubytes, mchunk);
+
+		/* Zero the trailing part of the page if needed */
+		if (mchunk > uchunk) {
+			/* Zero the trailing part of the page */
+			memset(ptr + uchunk, 0, mchunk - uchunk);
+		}
+
+		if (uchunk) {
+			/* For file based kexec, source pages are in kernel memory */
+			if (image->file_mode)
+				memcpy(ptr, kbuf, uchunk);
+			else
+				result = copy_from_user(ptr, buf, uchunk);
+			ubytes -= uchunk;
+			if (image->file_mode)
+				kbuf += uchunk;
+			else
+				buf += uchunk;
+		}
+
+		/* Clean up */
+		memunmap(ptr - page_offset);
+		if (result) {
+			result = -EFAULT;
+			goto out;
+		}
+		maddr  += mchunk;
+		mbytes -= mchunk;
+
+		cond_resched();
+	}
+out:
+	return result;
+}
+
 int kimage_load_segment(struct kimage *image, int idx)
 {
 	int result = -ENOMEM;
@@ -955,6 +1034,9 @@ int kimage_load_segment(struct kimage *image, int idx)
 		result = kimage_load_crash_segment(image, idx);
 		break;
 #endif
+	case KEXEC_TYPE_MULTIKERNEL:
+		result = kimage_load_multikernel_segment(image, idx);
+		break;
 	}
 
 	return result;
@@ -1229,3 +1311,30 @@ int kernel_kexec(void)
 	kexec_unlock();
 	return error;
 }
+
+int multikernel_kexec(int cpu)
+{
+	int rc;
+
+	pr_info("multikernel kexec: cpu %d\n", cpu);
+
+	if (cpu_online(cpu)) {
+		pr_err("The CPU is currently running with this kernel instance.");
+		return -EBUSY;
+	}
+
+	if (!kexec_trylock())
+		return -EBUSY;
+	if (!kexec_image) {
+		rc = -EINVAL;
+		goto unlock;
+	}
+
+	cpus_read_lock();
+	rc = multikernel_kick_ap(cpu, kexec_image->start);
+	cpus_read_unlock();
+
+unlock:
+	kexec_unlock();
+	return rc;
+}
diff --git a/kernel/reboot.c b/kernel/reboot.c
index ec087827c85c..f3ac703c4695 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -717,6 +717,10 @@ EXPORT_SYMBOL_GPL(kernel_power_off);
 
 DEFINE_MUTEX(system_transition_mutex);
 
+struct multikernel_boot_args {
+	int cpu;
+};
+
 /*
  * Reboot system call: for obvious reasons only root may call it,
  * and even root needs to set up some magic numbers in the registers
@@ -729,6 +733,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		void __user *, arg)
 {
 	struct pid_namespace *pid_ns = task_active_pid_ns(current);
+	struct multikernel_boot_args boot_args;
 	char buffer[256];
 	int ret = 0;
 
@@ -799,6 +804,11 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	case LINUX_REBOOT_CMD_KEXEC:
 		ret = kernel_kexec();
 		break;
+	case LINUX_REBOOT_CMD_MULTIKERNEL:
+		if (copy_from_user(&boot_args, arg, sizeof(boot_args)))
+			return -EFAULT;
+		ret = multikernel_kexec(boot_args.cpu);
+		break;
 #endif
 
 #ifdef CONFIG_HIBERNATION
-- 
2.34.1


