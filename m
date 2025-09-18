Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B3ABCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6EDB8E00B3; Thu, 18 Sep 2025 01:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46938E0093; Thu, 18 Sep 2025 01:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C688E00B3; Thu, 18 Sep 2025 01:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A2C8E8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:16:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 455C511ADB2
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:16:27 +0000 (UTC)
X-FDA: 83901210414.22.55BDBB5
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5BF2CC0005
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:16:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j3HroT5w;
	spf=pass (imf10.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758172585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiT0MrcHOyv1UJl38CIIzCgovK63Js+Y+q9YvsvWIlo=;
	b=pYnk+tXYImtE9RJtZTwzDpaw7q8Y4XE29ueV5kQSsqw5EEynJ7jIdGKw/b8FttD//JuszP
	HuSyBHmHKBZygICQ74JnqB25WwYNrBHqDfW0YrDwRId/6sKizuc6LItS7bNH1RG8H3Jrq6
	FgZc2FEM/UfLAyxTBD4o22cvOgc0Vcs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j3HroT5w;
	spf=pass (imf10.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758172585; a=rsa-sha256;
	cv=none;
	b=06aHN3n1HHViMpQtSXoKkBQd6d2y3xfYmq9u22oDh7lRZT9HNex4LiUpDG/Q3j3BORjhXX
	nSCQLr0Y9oXairt8GeRAyvLd9KbTDMwBGVnzfyqo2gTl7p7KzO2WT/jVRSIWp1sXYCqy+X
	IMYJ5FBbTqPK9h38PTYeD7Oap/Zx5jg=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7742adc1f25so449745b3a.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758172584; x=1758777384; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oiT0MrcHOyv1UJl38CIIzCgovK63Js+Y+q9YvsvWIlo=;
        b=j3HroT5w1/Gjcpztg0jpNgs18pUjcfEEPDe5Y9Pjh05Ggxnt9Ackyq1wVARsP5dSUw
         Lmo6jxWId2POfNucHj7jxlwHdwvN80KZlCAJ1Ft+jEx8brldf7NUUdWxYLQdj4PP8+60
         vOWLY06rlKpEwS2KSgYTDET9Qc0V8eu+mydVRBYiXzGwRdiipJeuemeTHjrnez+adONF
         1/p4OR5FCICm2zAt/aq/in9U9ZocAQ7XPBY5e2vRKdKuJBSKyJKH9spBjCTjscK/lWU2
         EsSEEYUWmxpBrTzLMgzt6QhrxcBA2Uc5NlLryyrhiEMCcd7NWyeNh0Qvp9k+gwBRvrpF
         pElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758172584; x=1758777384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oiT0MrcHOyv1UJl38CIIzCgovK63Js+Y+q9YvsvWIlo=;
        b=nIBoLfrGuWH1ruHWy+fenEhbDiJOT6mU+sPXoYT+G+xuNFhyFaAR05FthwgZrxJre3
         XKcWVXSsCb2T6pkMOt9bPIfk9Vsn5cAHfbz3wwP2lAZP6oJ9RMyJQbc1KCF5KscYD9Re
         KvajRBtcMJRkxQS2+Q43Fv8Y+G4DWAxvbDVhOyf/4fAAEe7NPDmhftM4JGhT3B6qnn7y
         h6YTaIPj8VIjXmhnKD+t5QUN9fGBDttDaxKgMfYBNVkicb3n6R6wfyzs5XnIMfrRMsUK
         s7FZbJN2Jb5Si+Ai0/TfoDKvpzwOwmpmwMBD1WzkeDqP+8TCIpO3sMYxzYGawsMykCDO
         1BMA==
X-Forwarded-Encrypted: i=1; AJvYcCUXISO8eqJWczedKzqk7gmscWVkS48bgjCUJcftnALgSTsnzigBIZyti2jbecxo1c0+sTGRZCN2kg==@kvack.org
X-Gm-Message-State: AOJu0YwmYG42Q73hdzV9PyJzv93a1xBDRD5RvAqON9CMUCvmD6Ym8e+8
	JD/iY/k7/WVqw8fkRmg9fBtCsqIP4t4R40pKIXCrkn6ETWyLmhwSCbPN
X-Gm-Gg: ASbGncvgZv6o8XmCaCMevDodYrbpPVe//Un1rid8P9Ca84rZ4NZVjN5v/ga1oEsr9aF
	wC6IWUxnGs+7JCRElEPfL2asPqLne5p/CvhTd1g0zFn83Y2T196HQEEPw17sf8M90B9+yQqz0OH
	PZsAEL3TTvK+sHwp4K9l+FRVHT2LyYZlOj1Ofx72yxzW29+juRHpXUc5HhG7AfR/WLXk5Qo2gyY
	tvL4XHdM7NI71Cm4ne+zpQVXTxr7m0qs9fqVCHRfG1rRw4wilE7fV1Jr6CIJcr5SfrEQscX+W+V
	yHbjKD9SuHf2aL2aDw+cPGenajsWnOB5BOYCnv2Tjd0TgMAL7MQDS43AarvLVGYmiAYD8Rpjmef
	sueM1wKx1RqaOBfgCzRKhkkA2RxnAO5WuBy/rz7EPJu5fk68EprCaidu0qmqNLcq+gvl5YyuZ7z
	NH/Pr+Ffpo4WDemLpdfuIctg==
X-Google-Smtp-Source: AGHT+IEa23dRQySwPPnr5ub15MBlqUEyaqoSvqVGNsNzpQT7Ye8yNYnLRaw4EeZooTnvYHDwu7FgGw==
X-Received: by 2002:a05:6a00:887:b0:772:8694:1d71 with SMTP id d2e1a72fcca58-77bf45c2008mr5267793b3a.0.1758172583863;
        Wed, 17 Sep 2025 22:16:23 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77cfe7607c8sm1093015b3a.58.2025.09.17.22.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 22:16:23 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id B2BEE1061EE2; Thu, 18 Sep 2025 14:16:20 +0900 (JST)
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
Subject: [PATCH v11 01/14] x86/um: nommu: elf loader for fdpic
Date: Thu, 18 Sep 2025 14:15:54 +0900
Message-ID: <5a4932bbcdbf79facd544fec7e3d6a6969a40aa1.1758171893.git.thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758171893.git.thehajime@gmail.com>
References: <cover.1758171893.git.thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5BF2CC0005
X-Stat-Signature: qx31o6wyisrkbqqks7187f7kkpjs9psj
X-HE-Tag: 1758172585-959018
X-HE-Meta: U2FsdGVkX19o4yroKWBGl8f/I9hUZkf1CUO6b9hJ8tjcrPLBzRl9Ore4GiPbNR7kZwFTcXG88XTXChT/VamWfSLCKCcryxd/5xHaStcU14og342ebzahTAnqbzjM7lQvROZ3bfnFySGFIVncG95MyOtcz0xsMnHMkJzBU4mOTV1VtrezyC2U3PS50L2Qqbxw8+XT+JwjuRl5yAB2T5ci2k8PX+t8g4/ZxIQsRsbaD7zF/1iU8r/MOLI6QQdwEUmsL5pNMdMCDJ9TP3zTzwjlRWqr5OhZpkQERwZ5gkcFPtQS2xKTky7VhWVJqRRtvecToQVEiyfcj90qOPIHXEazbXb5np7F0IGICzqU38sB6beYz3A0IJ6iSeU/5rqlJlTqtINHW+p9AK3qzzkcVTViBzS7xYeCEtJ/9vRCxNC+ISLhi8i4q4zGbMENNAea6adWEt/77eXLjnfW3fTOD9PPfxITuI2I4glgh+BdD61EX/hCKGwZZ+PArrVzg+T5SEKucVwtTn5P+pZ6qhVGW++GXpYzhGKQqxr1WDk5VuivZ6+ANw5B5247qR1VHQ53LWJb6N57/WeD5aqsOpYeFp4QiuINyUEg4FIdl2ckC8zbs0dpUGvmT5EWuOLbPE6+u3Vz3tJAWyM2/ZpyhWt+q0ZIv/3gePIrytLv+kR7VPsIq+6mEMp7BVsqhAlNYEH+oLuvL++OJPf8C+cvuwtYwGIpOmj0OqA+cRcT4mf2uuYCz5sJDQb9sPjNiDJYQkSt3AOnTbS7OxP5zF/zzJwNG5jllFPzjBbFLEd/ZmrXA25GiO6PPWvGOhTtpAvshy4nrkdbwzhOOfAmTcfGaw8HT2i3z7Goj9xMJs1Y+/jRk8eEAb1hgDII+Jirdp++TCJXuq+EjcwgVk6DEuRR1CB0lH1D5jKj+tDdnhmr3XoyX5DBct60YhxGyg/TbiuiEDLbikKKxRraxMNfsl//rBwTJbO
 5v11203j
 YsSlvzc4QNJfSINvPejTHsLXbrJKBYWYfRs95DHQig6ERncorKGgoXR57k+5hDe8tGghiaHbBZh0pbJaC5oLa6jZiHiXTkpYB13YONzIpxc1dpR9sBfRT5cSlqmXxT6s1BOHoejWtYZc2JRj8B8/2xk2CNskILaGC+J0d9e0vZXCYXZVt35mvQC1bGM0C4V/Bqkush5u3F3zKmrdFPqUZ4rt3MOyittRHDyqLLhLYGl0eWJpWcowbVrm8VL2fH1cj/uniXtNoqYEiA/wcyo8Got+D7zMjlbAjBwjfy6DmHygvyonQ8rkoA3Vn4bA7T/LQkIqy6F6ZCXc25w+UGYVf1XZ9tPN6kE9GS6UBPbRTDOIIdiReySOpQ11nJl8GO8NOaaNqQHb7gj4VNUxMT/CRXMZfyefxIUotl4RsiJPpSXSq+6I0ZxgifoQx52FBtC2ws5uITbtOgazdZrnBGpT113yw/CTzdbLZEiy9UOdIfuTxAEPGbFW7bLZyh0T3+oYcZqq7M6FkQgmhP4fmHZqfe/FnbWdceMjv2CHeIxt2Fe5c7tAQjXFVJ65u2iY3+r/e1cPGVIGyiQbC2EOLTMF7A5siV+04LkyxK0my+WZgrK3gXwsHCGDXCe5gzStr0jJTmKcEB6yEFzLiyfs=
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


