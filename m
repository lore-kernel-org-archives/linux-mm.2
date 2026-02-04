Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E118CE8B38C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 02:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7BF6B0088; Tue,  3 Feb 2026 21:28:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2893B6B0089; Tue,  3 Feb 2026 21:28:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2346B008A; Tue,  3 Feb 2026 21:28:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 064236B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:28:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 967828C15F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:28:22 +0000 (UTC)
X-FDA: 84405190044.14.2E6E2AE
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id A8325A000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:28:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YTd1mxIj;
	spf=pass (imf25.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770172100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjmnnaJ+dU4QzslBxUrlmdhSXDXCpeTGjd28jp/dBEQ=;
	b=t2pF7FRznjFuwonUnZRwiQngyWUyDvk+zRpDaWDWo3fvARtkWVvnnJn7xKTcW8nUI43JEY
	Z2zRc2Pe3VXmB9oBL9UawoOXCJjtOpTp3dO/mGkPuVf3REcRMHB4t1xkxbJ1iRqs1Trn8x
	+2+H5yTvviNh1Bi5ssoNZUutBoOEkwY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YTd1mxIj;
	spf=pass (imf25.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770172100; a=rsa-sha256;
	cv=none;
	b=V26ULWUzvvhaP4Yi1fDFyPqZbKb4FaSmfFmoEIw31dgGD/JVU2tTcV25KvHy/VEBfXSitF
	NGvtABSuDliiwjDgjmpv1YvGDo3IvOBSv/FaSvnidGz36kzOpbYwZP62jTjEknVqr5FViV
	+KRyjVfO6k4bfKz9tnoUKgUdlpl2Tdc=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c5e051a47ddso3764139a12.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 18:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770172099; x=1770776899; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjmnnaJ+dU4QzslBxUrlmdhSXDXCpeTGjd28jp/dBEQ=;
        b=YTd1mxIjeHAF9hY2PcscEc0VWxf/OT1qEYdBLmX1w95kVRlaVQLY5dlvIiSCahzGwO
         xfmfbgO/n4ZAsIovSm/8hy7U6Ocwd5SsW1qWBkXcgc4JZ6WFXmeIi0rDMNfm7+UcRr2C
         OQwpqFV6tiGopMfi8DzFOU4CekqnDutnJniVjM9yLsN+2f9K41/Tv4+xOtkvdWqNha64
         27mc2nuOHfkQ074Y9+780J8Muq6NL/A5Mh9a6KaIUCaSy0pGyzawjvTSE3wMzEkPXByk
         rZzeIiKrOdHB7Gt+QjnNzgQ2e/GDGELSzd08XK49MHc51q/1kSQd0IAabuRBdEmKjBK3
         fAPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770172099; x=1770776899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hjmnnaJ+dU4QzslBxUrlmdhSXDXCpeTGjd28jp/dBEQ=;
        b=U3VsBQC8Rnn01xIcaoQFRQefgMmEio264mu7NyYL+saGmG6Zs+FCKQLJhzoxDbY9HH
         L7eCN0GIdIsItrcja/5CxlmBJ4hQxJG+xpUSruaNWoX1IX8zY+r9ObUUsLUzihLSFdmF
         fgqMfdWEsuIjUrOgvk7nyWztITvl3uknyPB6aOvkqzI75qAvcAqvrTQFZxK9dm8FVAoa
         RWCL3J269cAPks4O1BCSBIbL5AysAL9xStitdIEWIqzq7tKdkvKKvCwmmxkTiA/CKuK/
         qFKh1N+gFmTDyJQ/xEdIaI/Ze9owAm/+jtZsXw9FIld2xNrjFtQxVu+Vqg3YTIToFwZY
         Tp7g==
X-Forwarded-Encrypted: i=1; AJvYcCXRDzsbrmIoCUHKpRV55hzlfZih9REL8w+jYcaf1C1X0jZzMTRZcJ6IWnXP0sxcG2UgKsUfrd9U4A==@kvack.org
X-Gm-Message-State: AOJu0YyBxIEKw0uxfyw2OXZTyrvPiiNiSNC8/QY13XM8pLl9Z7c7P4Me
	MLy9jU30nG7w3kd6dEDQdwdeyaayWzM9AE9NdtOQbxPnc3fusgInpYOo
X-Gm-Gg: AZuq6aIvtgAJr2EysV4OPhO1tT7bw9NPdlbDYyHIu/COgUDwyS0ZKn3nGnmDKnoSfkv
	avGbWuU3EyGXz78zmwVn3MYbVMBQ9Hg6mozNeWv7Xo5iSwUXPZ86BkzqZN7ls8THPaD1smXCWSl
	XP7c3MYEy0GIUsj9mydPwHWzzC3T6oXg+/jf4uuyjubdsp58t9+CpR1Fbvlfl1hZ6bMbx/DJNto
	Rw41TcPugM2T/40HxaPs9JKEs1JOIOenKKDFRNHQJqdObkhBRD8L8UN8osX7iTq0onfDPA37Nds
	wnw81GOtQsXYONNe3SXjPBtOzZWy/QEKhlCNu6sxhnWsLbFccTu4/S+7HTJQnbFGUENjBwHRMjm
	4txAMAw5uAxEfeNXho9XdjfFKqdI1gmRcUD1RTkaq19aSOeVTQrt0XnDyolTjV/nOn+xVxWSnWm
	fLlUin0R3LmfjiYuQdwT2I0ysJHtoLNVd3Lcs8ETbCb1FloCo0uBh+Xi+2ot44hv+EXizQ0tdsA
	uLxJhsuz9/Xf4/P
X-Received: by 2002:a05:6a20:a122:b0:370:73c1:6a87 with SMTP id adf61e73a8af0-393724cde89mr1471194637.58.1770172099431;
        Tue, 03 Feb 2026 18:28:19 -0800 (PST)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a93397c472sm6721415ad.89.2026.02.03.18.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 18:28:18 -0800 (PST)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 421DD1200C31; Wed,  4 Feb 2026 11:28:17 +0900 (JST)
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
Subject: [PATCH v14 01/13] x86/um: nommu: elf loader for fdpic
Date: Wed,  4 Feb 2026 11:27:59 +0900
Message-ID: <fa22ec46b0d78df65a005d4a33d05edebbbd381d.1770170302.git.thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1770170302.git.thehajime@gmail.com>
References: <cover.1770170302.git.thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3skxb7z48qd4e6kxeen7uegb6iqbucwe
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8325A000B
X-HE-Tag: 1770172100-448215
X-HE-Meta: U2FsdGVkX1/X5H+0A1RkwoGZg6xqaXBZkkK4IcndP9GNtQWKGB5YudsZG6MQLoxDVGIcyBpAZ4h8QsfJxPfk80j74haSIVCJRttZnSkPA/IKedHt1jMpQU7ihuohOf2So1JZlooS2gmUSzBkqD5Gdd3fLkZE6M0YRKQFt3BEjB6XGeKvp8gJZ1mH8WJyZipxzVvudOv5ZBzAmFueg34SgbPH0Cvi/0e8xgWO9Vup5uw3IloqFL0f5nuUM8ztK5IZ/uAkOXtFw9WEV0PwQelgyRN2O2mquaVZKSmzLZzPw9W3wxrwgOe51ANgv6DSCyXlsE4F+WPEmQaSe4y3hR+w0CxdNlczNAXPR+Q3cdR0I1rhpGavOBPqhnxkNTmTJUKy6cDHqFnVX4nFlYUzIW0YwixpT/bVFjpZJ7AAg9VzIDvrqcavtCBCBmRs7hVr4WE7cS6mIiHdV//vWhElJyQlIHjW6Us4hV+8QIVZQ0qjwPXHJU6jDQBBkwsVizO/50DYkkRO9hegD+cM7X2f/bnJQBO37TLVali5CJY/Q3ViWYI9N/WH/vrjsV45x+zdE9GGoXy7lQ2YENRFfuls/a/NugE4mAHwqsS9wQCZkEOlZOi/vVUSewiRXIZMayNm8sEXLPbTeUMohcqUvwdpxRuRzzIzOCMC5qNNouE+GqC3a78rcjA5Wug56LL6wVag31OmzPjrlAK5q12CXz88mQpu32dVV5za0zRevQmQZzDdAtnoWGXeZ+DOl5wb5frazsfYmFDLwcxyaQX7obxVXMhFDpZCELemCaY1TcGzefBcs4kcVI25SmPNa4ANq0MWQ4E9LzDlrDRi6bZXBCoRZ4tbXOn1QY7ZGwRcIkv6DyCBLdmIeKbP4A3euiWfBOBlB2TbMRWWQtuzn5kjN1xMiMDHwTjYYTZ5UwD9AMrGnbWvsIv7+FWQWsrl4IV8FmmmdFQzDxeFINYIG3ess2/wOhN
 d+8jLza/
 4VzxPsxG6REIL8bvLDz7skY98FnsHU7xe9q4t1v8zVtzu0XGXKCiSs866Bbi3u9+SrpcOMPYxV1mcdFgn/26NRX6asWCr3IFK3I+99Xy+CrVa2lbnLO8bDAASgUgKFMYPDef4bl6zxsecqwVDxMAPNBiXFigt7tKWWHUpzTowQJlduXs2JmJGz4e7EYZbtliZW8hZMvHp98HnIdKm5IC6n6spLt5p1bTBtHE88+5B8md01MAedOJbahibYieyzzCXUCc3R/RQDwIpJ5kgng8LBDxSxEcKRg2nmbMq4zbBFN4Ayu6GjbDczsMUS8BLgKjqRXhbXnBdNsh/utxQ+wZXQjLuh+LfuRjmmBDfPd1qcbq0JLL8msMy0Jy8zcFU52DNxBU/y/8CAyM2pUTeDh5Tx7a5xrq4TjBuWJV5uNnswJ/xbziMlNOQmumRW31EHDZ4YT5yEhG5joCm/hJbqcHm5I1A3BRek3MbF/gvZIHe9EaPQRFc7DCoBWX6G+TuXup7VctCNwJWx3Ii9S9Hlum95hcfL9tb1m1JPrQA36PLNvPc/65vXGIQNdjZd5PttWqogWsv87EzSMOq0l14ewuNmiDTq268VdktfJJdgkL79hr1NT/P8eGesfVBBC7rQacI0rMqfCXwbehYXeI=
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
index 22d0111b543b..388fe669886c 100644
--- a/arch/x86/um/asm/elf.h
+++ b/arch/x86/um/asm/elf.h
@@ -9,6 +9,7 @@
 #include <skas.h>
 
 #define CORE_DUMP_USE_REGSET
+#define ELF_FDPIC_CORE_EFLAGS  0
 
 #ifdef CONFIG_X86_32
 
@@ -158,8 +159,11 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 
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


