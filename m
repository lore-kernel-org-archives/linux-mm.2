Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C93DCAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 07:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4038E00C9; Thu, 18 Sep 2025 03:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C0B8E0093; Thu, 18 Sep 2025 03:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2448E00C9; Thu, 18 Sep 2025 03:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8951B8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:39:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4340E1A07FB
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:39:22 +0000 (UTC)
X-FDA: 83901570564.06.30D2453
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89ED740009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:39:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OBlwnlPO;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758181160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiT0MrcHOyv1UJl38CIIzCgovK63Js+Y+q9YvsvWIlo=;
	b=7pTAzxEwbfXYoJIfCjMNiq+2zWk9PR5g+4FqbiBH/N/01UAmYG83I7tDfpf/3BRpPboHTS
	olWlktRD+7Z1PfLfyBuOGqf7EHV03MDk4UCgx5yKBdLydT6tTwKy28sVGD8awjF9BTJV3M
	ZvABLTXBXMTZhEY7GgufTR+HaMmVrvo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758181160; a=rsa-sha256;
	cv=none;
	b=TKHduA4iXCn+JRQejaND1NVtUoQ4Phkl0iChuZkNT9i1yncsPUnqTEy8dP16ndKFrOKOWD
	mkotmBSuYpMxVUd85BWLEaYUguKOlOyHiK/vZQi5Gg5AyWVMGIWThC4ha4x40N8k948Xv+
	hxVObIeKuMHlKFlZH9A8U4l3V7BTlIY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OBlwnlPO;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-25caef29325so5996855ad.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758181159; x=1758785959; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oiT0MrcHOyv1UJl38CIIzCgovK63Js+Y+q9YvsvWIlo=;
        b=OBlwnlPOj6I95GcvZO2JToMjgLHxZdwcQUC0xYrzU1Bc5THnx/htku+cyiT95NB+eW
         aMABLzueMoYDdpxRDoQ6FdDHAs/Ho6UaAsTV3z8zw2SQf36K7BA69XvnGhJbnCe1NiLJ
         IpYcUZgFlHgqe23vZD+oYeyltGvEENAPvEDx8nu4XGqQQBTVRO25JDt2TB+DPj8kpNCa
         k0UO9FP6PM4SDn4DBB0RS2lreeU0vMWWyR6A/4BCPC/Trwayz6aHhPfrpV/bgQQYpprz
         Ptklt6SG2VBRnDY04f2C//2YCO2uBH5Zju0uCV3JLvKUXuZeie+V4zqlrg2CSz+Ui/Rt
         5d+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758181159; x=1758785959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oiT0MrcHOyv1UJl38CIIzCgovK63Js+Y+q9YvsvWIlo=;
        b=appb+lLTy/rhzxQTY6pwqOZ+8DaCEkmKO7rPj1DfFAbg/tHIDMQ3TNnkZEXoWEpS+2
         y/JQTSXUjSLYyxqTxgsXc/qJ+KFJKqpPo8jL4e8aJ9J71s/V6hzdgMNxGz3yXGmcBAz8
         rvnf4qmMjW/1txybICo+WyzE8Jwvh5+6iaQY2OUFQDFK98FiHqgwTyz1zhoVztGIR70R
         x3SEzarxscyxDADgf95gL4ATEFnlmUd13F+B9T1MY4KAde3GqKQJGeN8jdicHihGjgWc
         ipKALoTU9HeOLuE6dts0Ek0l/lHj7a6OS5sR3eeE8OyqKRRttofxAirJy6OEgXPmb0h0
         Eb5A==
X-Forwarded-Encrypted: i=1; AJvYcCXvkxPnVQ0czsPTsCgEtADa+PD6mnDHd8Fwond7mQUEeW1dZp+PFgp31YU3XaE/Z1cACVwsE4d7nA==@kvack.org
X-Gm-Message-State: AOJu0Yz5z0hSz6ipXXCpRLl96m6MwMwui8/sAvEM7EHJrJOdDvNjlSqj
	m15yQQP4JeE22SUERM1G3pZt2LR3XG7C9sgQIkWeGK4nVm7gHPykZf1O
X-Gm-Gg: ASbGnculm8RRD9yM1pENSXr+fH5wdzjlVSma4/JDz33sGs7BwrsK6tAJm2dSGloXYhR
	ESFFi9uIz6eu88qP9a6MhEn/5XIzYGnbGmExKy+iM83EdvWQCLR00rfdloPdLHJgvFrlYq7CAqH
	PDOBmm/bCAnvsOwaG3se8FdvLk9brU17R1HgxE4WYKUOZYnAREt1qA18yKaYsTRZtrqOaAvGaYS
	VvzhUDoWxkoH3dCTxcNxDPYTu3ksWkSGKblVCMT5NXc3cau/iR8NlMpPVJTitvkoWp9sS+ls+l3
	Hhppd2QeSBOy7qYTaHLeIbfW8vsZ/Ra4kG36YMtE/D0wqBdZutpYMwMzc6U71YSDwoZR8OmN2GE
	nHKgV2YTjrQ4zTIjE/ao/hQPfCQdeMaWo5U8YSbEKcVBPObKTOQDXtu3H8ZgAiXuu76/NSL/pDw
	QkNTKXiXPJSLk=
X-Google-Smtp-Source: AGHT+IEhAan4I4Yy608aj+94bqPtnH0sZCzGPXalqh2iDtPG1/N54CnlninxatIc4ohWkAdwd6ge3w==
X-Received: by 2002:a17:902:d504:b0:24c:af64:ae11 with SMTP id d9443c01a7336-26813903478mr67341765ad.44.1758181158787;
        Thu, 18 Sep 2025 00:39:18 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed275fb3csm4555900a91.20.2025.09.18.00.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 00:39:18 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 4BB8A10620FC; Thu, 18 Sep 2025 16:39:16 +0900 (JST)
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
Subject: [PATCH RESEND v11 01/13] x86/um: nommu: elf loader for fdpic
Date: Thu, 18 Sep 2025 16:38:56 +0900
Message-ID: <5a4932bbcdbf79facd544fec7e3d6a6969a40aa1.1758181109.git.thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758181109.git.thehajime@gmail.com>
References: <cover.1758181109.git.thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 89ED740009
X-Stat-Signature: rdwwnxy4xnuqmof9bqkynb5udwy1i17h
X-Rspam-User: 
X-HE-Tag: 1758181160-62233
X-HE-Meta: U2FsdGVkX1//Dt//4GJqQU/YkXHVTM2pd059uRbxEwODEFLyz+U5NeRJ2g3p5GwAupvtxCdcRo8Ye+GXG2znDZlKF3PY9f/Ch8oYNeqRodX5Q1BtxzoO5oJuGAMvJ8k2PgkboqarKB44/DJ+swppAZtPPDOb7HQXexr6XhzMOcnn+ZncAWtLjHhvubf0cVZbA3vOfkIRws7zykJYTNj1LMPnh9Z5tcccUo4DxumAriLSmnaWTy1V+Nady72sbbS2i0fS9QPEFJkuyLMftscg55xXjTGZtT+3lFYktpGQxgf82rKUhzjawGsUwQOegafQqNN5s4qexjSOT7p9Dg1BAurIyb+knoTq1prQsXNfiZUXs18YGgv+D0BshHgyX5k8IvOdxUr3e2rBEVZhZaktNtzhXbNo97+s9ygJZwcWalQhkx7kKIfuvckewG28MQxFNxzew6Ssn9DTQNwLM7B+3VufTjQuMeBu/4zJhsTewRBF8VqOBIVjFgrNoPznN/sDsRyVNvBZMDB5N72sYAVSydGSISwo254yr89GauoRjz6j5YicZ5c8PWOGm4tRizYi26JLi268/tVwOgEjxb4B3PNKQqd5GQXvrSJo95ZqFM3zWocx+BgxvCXqIs1qH3kzXyOAO3wrr01vpMlFXlEuqr7ywpjhz2hv1m2cIJM4a4UVBMRgMgHcbQo5OYm7OiPqS+usS9pFqroBJ7eQe4liYHvc64Dkd7CB9n3excpOlMFOmmme/k5KBqc/h0iQ6cLxMJM7zINXFN+MooVepHPJ7BjPK64D3Q+eDeNnjQBOgHDnlZAmdMoUSsZVaNp2u3/TcQds5HeFufoq2u9iTQAnpHUSGyQft2OxV4URct/wuFdFxK5QOaHQi0Gdn1n6nGuebnvEcyKfm7mG9BXZsPU3lW0XwOUj62AdfnGua7otm+HQ/nkYPcnLBBC19b53aWyyPcdmwQCwRQQcscFxeJh
 K17iWdeO
 pjCObE4+qvl/FB2alinPjYSpweDTTozAsrx5SOLx8xiMmfnhHCnJ7axTzrQ==
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
index 4d0e4239f3cc..e9661846b4a3 100644
--- a/arch/um/include/asm/mmu.h
+++ b/arch/um/include/asm/mmu.h
@@ -17,6 +17,11 @@ typedef struct mm_context {
 	/* Address range in need of a TLB sync */
 	unsigned long sync_tlb_range_from;
 	unsigned long sync_tlb_range_to;
+
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	unsigned long   exec_fdpic_loadmap;
+	unsigned long   interp_fdpic_loadmap;
+#endif
 } mm_context_t;
 
 #endif
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
index bd2f530e5740..419ba0282806 100644
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


