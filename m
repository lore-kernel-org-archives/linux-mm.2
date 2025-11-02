Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5985ECCFA07
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 09:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39AA18E0003; Sun,  2 Nov 2025 04:49:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3726E8E0002; Sun,  2 Nov 2025 04:49:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261448E0003; Sun,  2 Nov 2025 04:49:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11C468E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 04:49:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BA1714074D
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 09:49:54 +0000 (UTC)
X-FDA: 84065195508.16.DE75E07
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF4D840008
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 09:49:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P4Az4H91;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762076992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GAo7QPFRSMtQ+F+v51lXmGXWMCiRMzi5C8xvTtplUQ=;
	b=XQ4LzaNE4bTsElWym18HGLYMhNu56ex0gKifx5nk3IY1HHjg0rVf9JRH7Vz1I/uEYw8T5u
	a7Z6H6KrspfW0AcdID3mVqoPA0v4IOEstSSqzv7LBqjo+pjobRs5vBEo602a59/VLXpRS8
	VsUnVdYWgIu/UGI4WRrvvs3iaN/FPoE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P4Az4H91;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762076992; a=rsa-sha256;
	cv=none;
	b=2XzLKYD4FN8zN053GviKD6HCrI5Uh68I+mwaSM5pGvEyQuY8ucFuWQnmWX+wCUHdIc8a/E
	63xPmzDwRwKDwLvGYB4F3eNFjHrUxDcmSnqhuyQztr/Rc4n0IGEQ3yrw86ozre521VwWJE
	nTAC1YuZrRuLu3YMc9ZTV4YvoSrp4as=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso49311b3a.3
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 01:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762076992; x=1762681792; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7GAo7QPFRSMtQ+F+v51lXmGXWMCiRMzi5C8xvTtplUQ=;
        b=P4Az4H91wZAmkT6k6l0J+sMrsdeLtKNWbT14pKYVqutt2JVWj+aHTvIc6OpFB9sF/d
         6rz0MYk3IYUos/boMifg74BqtiAzOVp8McvbLdKt7CpRrZJnOtu5fRhmkb0J3jNuPuIs
         i5VDgUB9/ywCLy7JrA7am1vI6wgvna7TP2LIqd5B8byZok5QYVk8vZ6S3VhIdbu8thOn
         JjmhtHq/bzC4n0Sngja4JRRVr2FaWpD6m0GZvuKlMhZDDrbW5Kutz9VFMARwZGb1oRgB
         oVbIuHjWXMXeUM7K+k+b6zB5lknSNKrx4uUEQeSOwcpq+x7XCYB8f/0/h2amPvw6nNVE
         tcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762076992; x=1762681792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GAo7QPFRSMtQ+F+v51lXmGXWMCiRMzi5C8xvTtplUQ=;
        b=dmOn6dkxlbia3/rtVBmIjuANeQ7BhLyNXqXIQrulO2Tp9PuvlIhsf0rZyklU7u/aMU
         Eh51lH7xL0R+jdJel4q1vFPAYU0BUT50R58xO/HPsQNmVks42LsrwvABRtCN7SFQ+pVr
         zpKyBH/gu3wd53+sI+sJb087jydJU7a/NuBoAN8BbWQYVBctCfiE9LsGDc00S+XP+5FL
         nzv1XmXzRRA546ayLFkz/wIhFMD7Wjof+kW2SkV1Z62yDOaigBovlx2Bzkdt6i98+wmT
         7PhuEZbsicT6SOddo3W3fp0a5yVdBe8b/NFUcywirWvPlq1nvjoBpIRBkBGE2i1cQYqS
         eJsA==
X-Forwarded-Encrypted: i=1; AJvYcCWZYJA2uoopR6HFy2P8gj6XVa57jEWpA3yTJhVyr5o6KO8rxw9uVJ8DruXKOTPONlJ1OCWosyAnbg==@kvack.org
X-Gm-Message-State: AOJu0YwN/h7uqgNL3Ach8lIeI/TJh3kyq5XdRYxzulRMJFwkGT3qKSWS
	LAf+JTedZLzGzci+eIR3i7mAEbmQGFAUhepW0P2H6YkpVRmLtJKhLrUh
X-Gm-Gg: ASbGncv41yaCnmUVY3Q3PtsonMkX/UgX1sONwGI0h937R1nQwdSrgquskiHqcR3b6yw
	kM8Vm2UwTasD+xJX4oJZFyXZaIadbFVlCGHt5jVmrq1T0lgLH0RDcKvWC5gTSLvoFasCcqCr9je
	9WypjzRGf1vYVoX/dBWJjHA6jNcYe1EMD9IVOjGvyttbuYMsldwjklhe1akES52FHs0e5m93zNl
	8Utbqvwu+x73CMivGsv5wSCQ0zXbPHjAc6AcHBEFFML5nKIDWizrlcUvITWEHqMGpSn+Nas14FC
	9U1ijaPW9aY9lr9XsoOa5q3IikQiAqKrgidsMw5o5ABxDecNxqF1kYJ/r2xHvIYAdwO/Am5BZoB
	TNU5Txe5Tvd1XAtoq9Zgh0ZZxn8DUv3e+tqucY6DVjSibQqrT4qfurshrCsGnve00v/mnjpx6lh
	7eQMF5jz+pklmH32wvKIW+ZPUGcXLXiqB0mZhCspJHdm69pw==
X-Google-Smtp-Source: AGHT+IFjPZCZPoz2w60NDnASz0MjN7TYV8NIqgCnj6gVUAWRi7VL8ewmGqOYXuj4ykHVff4Lv7oBqw==
X-Received: by 2002:a05:6a00:1793:b0:7aa:d434:69d6 with SMTP id d2e1a72fcca58-7aad443af35mr506394b3a.10.1762076991691;
        Sun, 02 Nov 2025 01:49:51 -0800 (PST)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a9bad978c4sm2738154b3a.13.2025.11.02.01.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 01:49:50 -0800 (PST)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 0072711237FF; Sun,  2 Nov 2025 18:49:42 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-um@lists.infradead.org
Cc: thehajime@gmail.com,
	ricarkol@google.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v12 01/13] x86/um: nommu: elf loader for fdpic
Date: Sun,  2 Nov 2025 18:49:26 +0900
Message-ID: <d0537389ac18acb03ae3bdaf25473d56f7e74f4f.1762075876.git.thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762075876.git.thehajime@gmail.com>
References: <cover.1762075876.git.thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DF4D840008
X-Rspamd-Server: rspam03
X-Stat-Signature: c5rcfu8k3y4gxb5rgn6qathb8eggsbs4
X-HE-Tag: 1762076992-229288
X-HE-Meta: U2FsdGVkX189VphEgEIMv0bi0Ez6w3BvrT/ZoScPg/TQKl+5JIfPDwyhuQKP4nSrEp5nXsuxMFZte34vcTNrfD3uG6iDQvWBxb/sj1neOV26tvX9xipxRlf8D+VqHGu911CKj+KfA5adgAEsChfZHD5A5zilyVrGO/X0kyHvzMyBCDySGvi83eBPjfzwXjqRaqJQ2m2RSu3MCpbHLjj9lVp5AyQXVfKs+u5TyQd9JS2kGcm4/of9aNqlO5hKT9on3zG6di6fx5+KhC3GXIyL4wMDKNttlCUkmis8g2fgmGRtwNqgp9SC8J/1QRYtPHfuhL55Y1y8NzrVYcEhsi+t2LU+pFFFW4YInVknFdFekN0ZCEFZ/Vg2nLaOx74B4eTV1QIB2O6T3GCQ6cffNDDTELXLyXfHodYioAJut1jCbQUla777xIqQzJFfSEYzKuLwb6Fb89E/fWK9mJ9OcanEmXMjHxQg5Cyw3WnirIsOQsdUO97L4JH1YD5KWlyrSwKmPB+xhvcDnqxL4XjwxrIwZ9+sxmHmlTUhrHN+UMMfgCY+i5BSp1WKPX9V0kRfYSR4vuzfXeieeg1cnZHxd5Q88gWJIctju1vP/7Pv0O4nVBT0AaKx4U1hxGwM7M262lpedPaBw0AC/T4xjDH1OW5evYU0mky9tapgRGz/zIoSVIPkxhUYOOT2Me7BcOmdTKhYrlUg6ytBmNgGcbOg0WxEMjx0pe4skpzOsKfDfxEkEyM+U5v92+u4OI6rE2wiIunj4UGEkP2Px4xcoUkoK6LkznOOBpbpnPm505t7WFNJg9cT7EbEgtMtCvVPUcWby27znHqDq3WsF+22ZM/wwL2jua/JWgD6vlwBl4UvYcOCC+zpIf9VN4UHB5e+FPRkm8zBvftFztiPTpAOC+EutOgQSm8lffN2Ai+vpmP/z3+pLGkjhxvNQk7aHiZMXI/PB5kYr6mGrkwUZK6+GHU3Y0r
 GUG8Z5Jx
 W3/O8XxT55tM0kSF6DfCsrnF6rCivBAfdjkbh1OANHxjWRI0WQGlortnfLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As UML supports CONFIG_MMU=n case, it has to use an alternate ELF
loader, FDPIC ELF loader.  In this commit, we added necessary
definitions in the arch, as UML has not been used so far.  It also
updates Kconfig file to use BINFMT_ELF_FDPIC under !MMU environment.

Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Acked-by: Kees Cook <kees@kernel.org>
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/um/include/asm/mmu.h            | 5 +++++
 arch/um/include/asm/ptrace-generic.h | 6 ++++++
 arch/x86/um/asm/elf.h                | 8 ++++++--
 fs/Kconfig.binfmt                    | 2 +-
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/um/include/asm/mmu.h b/arch/um/include/asm/mmu.h
index 07d48738b402..82a919132aff 100644
--- a/arch/um/include/asm/mmu.h
+++ b/arch/um/include/asm/mmu.h
@@ -21,6 +21,11 @@ typedef struct mm_context {
 	spinlock_t sync_tlb_lock;
 	unsigned long sync_tlb_range_from;
 	unsigned long sync_tlb_range_to;
+
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	unsigned long   exec_fdpic_loadmap;
+	unsigned long   interp_fdpic_loadmap;
+#endif
 } mm_context_t;
 
 #define INIT_MM_CONTEXT(mm)						\
diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/ptrace-generic.h
index 86d74f9d33cf..62e9916078ec 100644
--- a/arch/um/include/asm/ptrace-generic.h
+++ b/arch/um/include/asm/ptrace-generic.h
@@ -29,6 +29,12 @@ struct pt_regs {
 
 #define PTRACE_OLDSETOPTIONS 21
 
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+#define PTRACE_GETFDPIC		31
+#define PTRACE_GETFDPIC_EXEC	0
+#define PTRACE_GETFDPIC_INTERP	1
+#endif
+
 struct task_struct;
 
 extern long subarch_ptrace(struct task_struct *child, long request,
diff --git a/arch/x86/um/asm/elf.h b/arch/x86/um/asm/elf.h
index 62ed5d68a978..33f69f1eac10 100644
--- a/arch/x86/um/asm/elf.h
+++ b/arch/x86/um/asm/elf.h
@@ -9,6 +9,7 @@
 #include <skas.h>
 
 #define CORE_DUMP_USE_REGSET
+#define ELF_FDPIC_CORE_EFLAGS  0
 
 #ifdef CONFIG_X86_32
 
@@ -190,8 +191,11 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 extern unsigned long um_vdso_addr;
 #define AT_SYSINFO_EHDR 33
-#define ARCH_DLINFO	NEW_AUX_ENT(AT_SYSINFO_EHDR, um_vdso_addr)
-
+#define ARCH_DLINFO						\
+do {								\
+	NEW_AUX_ENT(AT_SYSINFO_EHDR, um_vdso_addr);		\
+	NEW_AUX_ENT(AT_MINSIGSTKSZ, 0);			\
+} while (0)
 #endif
 
 typedef unsigned long elf_greg_t;
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 1949e25c7741..0a92bebd5f75 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -58,7 +58,7 @@ config ARCH_USE_GNU_PROPERTY
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y if !BINFMT_ELF
-	depends on ARM || ((M68K || RISCV || SUPERH || XTENSA) && !MMU)
+	depends on ARM || ((M68K || RISCV || SUPERH || UML || XTENSA) && !MMU)
 	select ELFCORE
 	help
 	  ELF FDPIC binaries are based on ELF, but allow the individual load
-- 
2.43.0


