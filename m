Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51482CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 22:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9694C8E0130; Thu, 18 Sep 2025 18:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A078E0068; Thu, 18 Sep 2025 18:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808D48E0130; Thu, 18 Sep 2025 18:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9868E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:26:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28F761A0383
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:25 +0000 (UTC)
X-FDA: 83903805930.09.D700BE7
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41471100008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IdQOg7OR;
	spf=pass (imf14.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758234383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1dFsvQMxvcjtQz197QK9xl+/t1w6WalvHTZ6lHd38A=;
	b=Dj4GChZCGfuW2fSAkA7teNzDXyBCa+l2/DrXSEQ0bXDIuDhnr6aaIkZR90hRYVMXQhR2FW
	lzM5jvUjcI1kn11GYDOnrwqj5uwJ6BSUKkKr95AQBQr7f5s4eljrt0YX2GoeIZxehd3yXU
	WoLmECyykE2dvyUxCbaf7WBkSbpX/bw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758234383; a=rsa-sha256;
	cv=none;
	b=guBL+i0Qg5feP8W/e9VI2yYxLRbUnjwZ/HHuRP6QJ/tCbpXgAnfb7Sf00o9t/Fj7OkDyAs
	Q079mt8UxLmzIEPQSyPAWrgeunc1Z1IqJpgeLqCbfSxYyxZJG43bebNSaH/sc7es7qIgbU
	dBMZqrkjbcckVxZh4+PhN7eDPcnJyfQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IdQOg7OR;
	spf=pass (imf14.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-77256e75eacso1418774b3a.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758234382; x=1758839182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1dFsvQMxvcjtQz197QK9xl+/t1w6WalvHTZ6lHd38A=;
        b=IdQOg7ORtnNnG/JBncOLJNxB0L7ex2kmyOphqx+PwF7aC1KOm3Qin3uZSaLqXMcCzQ
         bECOX6xcd2ocMZ/1hIqN84sAwWBrvuWGgwRV76IRrvVL3CcmyqtFDeOFgf3rz1LECVLH
         YuJqh8hw9X/kHXN5+nGLovRPlozsWqFUcDOlNs2u8bb4oPjcC19PBEfqq/EZoV4fW3zg
         +DP+2OCuumE2LuXI3MkEwnhNXJGIC6jC1Fuur1ZTmN/vNPJEelmzPvyKIlr0fKxY0wbN
         yTS84h58KUcmfLEhndB15sIt0nAJ8Zs20/zNJdYVM5pIGsIHJqjSaognnQ96jHW3D6aK
         dgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758234382; x=1758839182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1dFsvQMxvcjtQz197QK9xl+/t1w6WalvHTZ6lHd38A=;
        b=nOXpiUuA0+RkXDPImnUG+Tl6gIwXk7XVp3DVJ/3cWiOLCeRi/TYiyO5Px69MX4RN0c
         nHYDFBmi3cdHQe0MPfc8/mMbjngR7qmaapPmE8hOBSBGmp10llEfeO9Wkdqm7t/w4xq1
         VyWtSH49S5xJkW1Nv147nc6Tl6vO0UhCS9dzx/pN9Du9WJjC1eEEDlUU1UoOYuirJ8oi
         PVQ7GSePP0HqhI6kU29101rp4NkJR/yNsuYsWeRmD4zQoF5Ac87spkDq9nln/esDiC/v
         pkqeymD5KBHmH2qWn0GZIZE2rb7pFT3FSxgUtb6zfgfT20PA9o++4E+KO5Q+m9ZDlm/f
         5mSA==
X-Forwarded-Encrypted: i=1; AJvYcCX1PXcq60KObcSiReigTv/FDiXEQsmpxG9NimR7zbs+HkGSqo112CzPgXAScws2GK+9Sk/xywIwew==@kvack.org
X-Gm-Message-State: AOJu0YwVJ+vTJF6ZJS6/Wo8ERDB2ImWtVUXr8mF+ppTsrEHB9g9k457c
	ylOs7yVK1+52cOaiqFJ+FsGaVw/5/BSlDgTqhApE2XE9eo4otp5QhXKR
X-Gm-Gg: ASbGncuf3Ej9cJgzjeiJtmEjdk5Ys/3wpQhGHyC0xzn5BjRdV9XlrQbuwMJmoFYjrKB
	KfdoF9YnY2PDkYaymt6zZeG4+WiadxHC21lgZahKwywL1xFR3Db0r5pSs/E21mAHWbJAzk1wqh0
	EZlRAuOETc2mkOYfGLA9TIFVmEAcwq/PSPos4tLwjJx4EZb0o//oXRQ30oxgZgBn7KzVkR2L7fr
	LeIzPkAFwuWGAOKn+eDkEBfpYFYWr7KAL6rE4630gr64HDeMggCOjoLpAGdBJmvtp5cenq6dpFN
	atm+xnGP4n+Vt02CupLRBeBGOYv/fFp/KNEJPp9ioytcrK4uAmMEwkP3S1NApZ16pwYpDqmBbhP
	y8vaSTWGa0bTrbYwnj9ZJ9+S1nu3j6oXjpRd4wP4QyzwIpk8=
X-Google-Smtp-Source: AGHT+IHiSRMLDAqLw/Cik8QC7OKyXdyrkBpwegYIn++ScY0FjSln61N27eWeZhvArH7Hx9TmCQ0oyw==
X-Received: by 2002:a05:6a00:1bcd:b0:77e:87ea:ecac with SMTP id d2e1a72fcca58-77e87eaef9dmr281236b3a.24.1758234381924;
        Thu, 18 Sep 2025 15:26:21 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:c5c1:2e33:6cf2:beed])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77e5fe6de75sm407542b3a.19.2025.09.18.15.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:26:21 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch 1/7] kexec: Introduce multikernel support via kexec
Date: Thu, 18 Sep 2025 15:26:00 -0700
Message-Id: <20250918222607.186488-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 41471100008
X-Stat-Signature: 834e5ba3ckc9k5u5dgst7aeg18ntenc6
X-Rspam-User: 
X-HE-Tag: 1758234383-771225
X-HE-Meta: U2FsdGVkX19rLRUyDB2C8t7EU4teHeJ5omfi8FtGP4gQP2ASlwb9Le2Gc/jXmsdzxxv4PZsCHcJYsearkLTMaqg7OYyiVjVfum9/884ccExx01LyPBhTkW7Ku8+AgLcONa6pkUp4Jbshwh+Or8vAyLyJDhLhAJIcKBgmIfQPZcaQI6AypBqoQ2ofuE77UsN5wUOs06l2aBJcX4scchYu2S5qSqAiX2vW7GgGXogsDf2K+leyCby9BCTOXiF7tafXMLxj7Hcn3ztGDW9iR+eM5lZrjLr/GrceNhapzFjm2uR9+QJ0CcTdmu6LY7CA3tO0gbnuuh87MKXLqvRtHbW8+X00L0o5sT9WU6li/ayvECVyyMrqYRZ+VVUM7HlPSuiNto0Mte0y6TlwVkNx3ITDVzCz8Oq1EPKJhRaAGgt898kMwR/DH8arBZedZmEeQb8JnNuzIG8FxBjP1wW2/iQnfPKAuN4laPKIcppErl++awN6rADDFJWI/LT52U6xntJnGFmfq+WOjoFcjW+nFRnYj020M5WuF3dYkHXACC/M/c/yQAYj74ibnVn1SHEAbUPaKPjBtfNaD5c5Cy45YotFdkiLgWZI9Do/sWWnWL3KNfZ8CksAJQG16j4AuBfzyBWDr+jh+zeSOU/a43sLOV7lTzHo6Umwkr7lCu2TRX5wHqjrkg6YGXkSk8lALoZTtWRZTxyXIb/Nc7p71OYYIIEkuXrLePZ+k4inDTtHwHUspcF8S+kMDKtA4TvO5Z6o/a4atjvX1Oz85obGebZ6S5ZojwjFEqnd3xBT0a+lMmBohD+EvNrNKoGKz/3Vn3MnHHJTAiU4TBKG3OyqHW0oofoBnnw/h2ebyFTYlOBFF8lmUkAxDgsZAD+w2q5eclsQQLuoOfLL39XRJJDVx21Gcz8bqDu9Ooog4oL1ROHMjv7SVy8jl7WfcA8ouduKNSo9JQYInJDc3/zk8HXIUp1ZUHE
 OEOSf39d
 wIyxpo8ImYwSm4X3U1oxJFjU4qI915buwdTXfnv6wz718Xjq68ZpL6zWmInhwdpWsXv94xtjX/fzQNwAlPaX8voYL4/I4TKEU3173RSD/MmzysmM1ZvKPDqQSwjs6fewTELnoJXq4O4fSJgnP8axD4QuTXuMUCfyTEqm5fltCxaBFsGEkXFef2Z1K87wMpFeOXoEXPRl9Fw3wrAWxy6ufwPsX3V2UTx2ER4pwnmdaEBfkNEXQFu9vZMdAOXX1MFRVpOIzj4CO+G9DtrSPzUJm7kyFYOozjgy16Zii+fyAOJ7/xGnrEOHvCw/H+24ER1/Sq3xwdQQPIwuVJmPsay5WRAywEH40CXSOVZIOiIOgeYHplOVdV2/r6/+CqWoSj23TXQG6yNyyuAz+ioKGXd4XJ0UTn6vOVqOkRHTvw9ESAencw9G69DyfhyDNJkoDY/JcYKC0GKABsGLzXGqQadY7SCdGdA==
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
 arch/x86/kernel/smpboot.c   | 104 +++++++++++++++++++++++++++
 include/linux/kexec.h       |   6 +-
 include/uapi/linux/kexec.h  |   1 +
 include/uapi/linux/reboot.h |   2 +-
 kernel/kexec.c              |  41 ++++++++++-
 kernel/kexec_core.c         | 135 ++++++++++++++++++++++++++++++++++++
 kernel/reboot.c             |  10 +++
 8 files changed, 294 insertions(+), 6 deletions(-)

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
index 33e166f6ab12..c2844a493ebf 100644
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
index 39fe3e6cd282..a3ae3e561109 100644
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
@@ -434,6 +435,7 @@ extern void machine_kexec(struct kimage *image);
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
 extern int kernel_kexec(void);
+extern int multikernel_kexec(int cpu);
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
 
@@ -455,7 +457,7 @@ bool kexec_load_permitted(int kexec_image_type);
 #define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_UPDATE_ELFCOREHDR | KEXEC_CRASH_HOTPLUG_SUPPORT)
 #else
 #define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT | KEXEC_UPDATE_ELFCOREHDR | \
-			KEXEC_CRASH_HOTPLUG_SUPPORT)
+			KEXEC_CRASH_HOTPLUG_SUPPORT | KEXEC_MULTIKERNEL)
 #endif
 
 /* List of defined/legal kexec file flags */
diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
index 8958ebfcff94..4ed8660ef95e 100644
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
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 28008e3d462e..49e62f804674 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -16,6 +16,7 @@
 #include <linux/syscalls.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/memblock.h>
 
 #include "kexec_internal.h"
 
@@ -27,6 +28,7 @@ static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
 	int ret;
 	struct kimage *image;
 	bool kexec_on_panic = flags & KEXEC_ON_CRASH;
+	bool multikernel_load = flags & KEXEC_MULTIKERNEL;
 
 #ifdef CONFIG_CRASH_DUMP
 	if (kexec_on_panic) {
@@ -37,6 +39,30 @@ static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
 	}
 #endif
 
+#if 0
+	if (multikernel_load) {
+		// Check if entry is in a reserved memory region
+		bool in_reserved_region = false;
+		phys_addr_t start, end;
+		u64 i;
+
+		for_each_reserved_mem_range(i, &start, &end) {
+			if (entry >= start && entry < end) {
+				in_reserved_region = true;
+				break;
+			}
+		}
+
+		if (!in_reserved_region) {
+			pr_err("Entry point 0x%lx is not in a reserved memory region\n", entry);
+			return -EADDRNOTAVAIL; // Return an error if not in a reserved region
+		}
+
+		pr_info("multikernel load: got to multikernel_load syscall, entry 0x%lx, nr_segments %lu, flags 0x%lx\n",
+			entry, nr_segments, flags);
+	}
+#endif
+
 	/* Allocate and initialize a controlling structure */
 	image = do_kimage_alloc_init();
 	if (!image)
@@ -54,10 +80,16 @@ static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
 	}
 #endif
 
+	if (multikernel_load) {
+		image->type = KEXEC_TYPE_MULTIKERNEL;
+	}
+
 	ret = sanity_check_segment_list(image);
 	if (ret)
 		goto out_free_image;
 
+	if (multikernel_load)
+		goto done;
 	/*
 	 * Find a location for the control code buffer, and add it
 	 * the vector of segments so that it's pages will also be
@@ -79,6 +111,7 @@ static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
 		}
 	}
 
+done:
 	*rimage = image;
 	return 0;
 out_free_control_pages:
@@ -139,9 +172,11 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 		image->hotplug_support = 1;
 #endif
 
-	ret = machine_kexec_prepare(image);
-	if (ret)
-		goto out;
+	if (!(flags & KEXEC_MULTIKERNEL)) {
+		ret = machine_kexec_prepare(image);
+		if (ret)
+			goto out;
+	}
 
 	/*
 	 * Some architecture(like S390) may touch the crash memory before
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 31203f0bacaf..35a66c8dd78b 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -41,6 +41,7 @@
 #include <linux/objtool.h>
 #include <linux/kmsg_dump.h>
 #include <linux/dma-map-ops.h>
+#include <linux/memblock.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -211,6 +212,32 @@ int sanity_check_segment_list(struct kimage *image)
 	}
 #endif
 
+#if 0
+	if (image->type == KEXEC_TYPE_MULTIKERNEL) {
+		for (i = 0; i < nr_segments; i++) {
+			unsigned long mstart, mend;
+			phys_addr_t start, end;
+			bool in_reserved_region = false;
+			u64 i;
+
+			mstart = image->segment[i].mem;
+			mend = mstart + image->segment[i].memsz - 1;
+			for_each_reserved_mem_range(i, &start, &end) {
+				if (mstart >= start && mend <= end) {
+					in_reserved_region = true;
+					break;
+				}
+			}
+
+			if (!in_reserved_region) {
+				pr_err("Segment 0x%lx-0x%lx is not in a reserved memory region\n",
+					mstart, mend);
+				return -EADDRNOTAVAIL;
+			}
+		}
+	}
+#endif
+
 	/*
 	 * The destination addresses are searched from system RAM rather than
 	 * being allocated from the buddy allocator, so they are not guaranteed
@@ -943,6 +970,84 @@ static int kimage_load_crash_segment(struct kimage *image, int idx)
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
@@ -956,6 +1061,9 @@ int kimage_load_segment(struct kimage *image, int idx)
 		result = kimage_load_crash_segment(image, idx);
 		break;
 #endif
+	case KEXEC_TYPE_MULTIKERNEL:
+		result = kimage_load_multikernel_segment(image, idx);
+		break;
 	}
 
 	return result;
@@ -1230,3 +1338,30 @@ int kernel_kexec(void)
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


