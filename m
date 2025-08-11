Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93694C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B368E002E; Mon, 11 Aug 2025 05:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC558E000A; Mon, 11 Aug 2025 05:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0CE28E002E; Mon, 11 Aug 2025 05:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D936D8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:54:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70AA582C62
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:54:16 +0000 (UTC)
X-FDA: 83764016112.23.60365F9
Received: from m.syntacore.com (m.syntacore.com [178.249.69.228])
	by imf26.hostedemail.com (Postfix) with ESMTP id E6630140009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:54:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=II4M1Au5;
	spf=pass (imf26.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com;
	dmarc=pass (policy=none) header.from=syntacore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754906054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yni3jeui56qGM7gspd6IrxvigH7pPMoqhQ6Dvk9afrY=;
	b=QqEIxrGk3H/H7dPXbbRHrFsTj4JNXiGR+UeIS21d1wFJNUXDLJYwooeMkQjaXi4nJyaAGM
	+Ow64R2hNT1cZswFSNYeZW3/9al0Lxgsnqut7YskCvsz9j0fZ16Lxevcv5CiXTqrv28WwH
	RXomMCZs8H+qC4Id2GXvUVoA3C5Pgp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754906054; a=rsa-sha256;
	cv=none;
	b=f79R4kZmQpkmWVjteqxVZ7tCsDzPXVNem7xbi0v106zuz+6BBZvQa4SD50x3d/mL5DTej+
	OWxb6QPrdejEQnXsQnBV6diGCmj5AAgdFE4MIXVL4yS7UwVVljTj+cXlyQJ46RMONMY9Qn
	HWKHGASg7PYwvW6W/hI42S6zvztOuiU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=II4M1Au5;
	spf=pass (imf26.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com;
	dmarc=pass (policy=none) header.from=syntacore.com
Received: from MRN-SC-KSMG-01.corp.syntacore.com (localhost [127.0.0.1])
	by m.syntacore.com (Postfix) with ESMTP id 55E9B1A0002;
	Mon, 11 Aug 2025 09:54:12 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 m.syntacore.com 55E9B1A0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com; s=m;
	t=1754906052; bh=yni3jeui56qGM7gspd6IrxvigH7pPMoqhQ6Dvk9afrY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=II4M1Au5GdLYynSnkzM0etPYEfbzel+cAmL5VNpBSPhKia3TEM4hdjcbl50Icmb1u
	 c1B6I1/sG69NHrP4EcJD9VOQUCTSFLrXy2c1fIwfRLkBHwTK0wt80VCe3L+2wbVLNU
	 FhAJDzP0DJlSytaVeDs3sRgeMm6NAPNEOiHXCAfbI+AzX/Mf0nEXSrHjIcUJXbIIz5
	 K14W+d+wJPFWkkaTZyw7ywofojaWv/E58Qz8KMSCEdMlIjQD/c0a68dpTskxJIlO7u
	 8+J1hh4uH1AxkRTK0x8Gmsv0qcnGwSNGd2oyP4hE0mMafYr7a05tTCExLpP+DvrvDe
	 Ud3oI+bWPrfdg==
Received: from S-SC-EXCH-01.corp.syntacore.com (exchange.syntacore.com [10.76.202.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by m.syntacore.com (Postfix) with ESMTPS;
	Mon, 11 Aug 2025 09:54:10 +0000 (UTC)
Received: from localhost (10.199.23.86) by S-SC-EXCH-01.corp.syntacore.com
 (10.76.202.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 11 Aug
 2025 12:53:14 +0300
From: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
To: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<kees@kernel.org>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<svetlana.parfenova@syntacore.com>
Subject: [RFC RESEND v2] binfmt_elf: preserve original ELF e_flags for core dumps
Date: Mon, 11 Aug 2025 15:53:28 +0600
Message-ID: <20250811095328.256869-1-svetlana.parfenova@syntacore.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.23.86]
X-ClientProxiedBy: S-SC-EXCH-01.corp.syntacore.com (10.76.202.20) To
 S-SC-EXCH-01.corp.syntacore.com (10.76.202.20)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/08/11 08:26:00 #27653044
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5
X-Rspamd-Queue-Id: E6630140009
X-Stat-Signature: rxk9edjbwnbu81up3t6c9aa795ahhci6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754906053-114868
X-HE-Meta: U2FsdGVkX18nJ6/dRCMIAafSBd4ROpYeuoPFurJMjeOWe/M8Ow/97SgXFw8vTJWFNBJ+6gmFCNNHxVjew0Xj92Dxp7yoEgmZldQhecZq26aqurFCR98x9DPfmtV6uyBLRSrBmiYUAnt3rmB5lAl0J6BSna2q86df6xDT5IO5VTIXRksKt4xgtBacrqSDtBJ7ZWmo+1W/mLllMNE9zEG+7aP03c1ZDANsK5SPijpVOtHG1L4DcS0iGWxD8G/xLqPCjTj7UlQUovl5xjT34OjfRx7nzbp87PxosI6W6ozh9pR5o0lGkte6lPouyOhXVcpl+Egr4RiBBaWpw4AKdeYH9X+5hqzjkasJ37ewkX9KBV7P6kzcDJED2/X6bTGcH0HW8qHb4wsfAuV3g2NH0a8C88bdcLtnniHNUcSv20Xyp6iqy1UFnU/N/0Gsnk9VPy3rBM4LvggvoMdKaDquJNO/rp/bi6MRm3b1eRzSsYVQQ4z6Kgvj/bWN8kW/pZnwgY9YGdJwLHfhg4NpHEwONZveX+otgM6K/8hKG+qyB4ks+EABrLmV2aZDWYOvDCSQ4PBTZdLaLiIl0f4NTk1UikRZJYmCvxEcSyW0p9bBbNjzHpGpxROt6YAFG5UPIuqc7+B4ANEC3yIqYw6cRg/Wn9pzgLLL9EGyCZvKulwImfooNB8jPc9fECpugA3mjpt3/VS9i4MHsno0pglWptTf/Z0v93chRhqjYd5DseVnj95Ybwkr3OWpWOabxk4sUvkJiT3UyXXBnPrZATOwwcUA/k4c9qgyhMPZdGhZ6TjaZmdfHawqFmmCQsHuTcazPb7k/4PeqCYATemknfHKnlvMRGidQ9p9ZaLhBXarIV+E8lx2tUYcq/8uHCp0Vm7YHTh0vtyFKH8rDBAk1YYbSXIEvgi+K1BAI2R9gplA5ITxsE0t+VoGwT19/wmKQQAmXoPCTKt7WW8AkgPgxk5G01/tnza
 L2solj5H
 hmPXTMFSa/2WkqP+7IymzCtK8xUlTOCgcXF5HuwxBubLTLpOmkJRIfDjb/qiXUWFXIH3jkfcdHi/CIVRwHOBD+r3zAVdi7UuPJZwPU0S2Ty3J+u2Vw71ucutKm76WlUIfTe4ysrINbHnyXZ7oo5fCxCpcZEfUBfK01DKRVimypXuj0Gj2PzBDs86gSrO9UPTsQ7l6oPWXT5aWxLNcWVuhKETE1t9M5QW59X3FFLKEwADGb+5fDAS0MEQRMtoY16n1xORZnsYHFY3KF0gVrsVJSjkCcaNxqd/bhUzUMOjmRP/yPHtDfHmVih8W4Rz6VNym7VLdRovOPMI49eNGy9O5lQJV69Lr3uOHvz2RLEwazDvuE8KmMNFi4/bAZ3HslDejs9pODkoVU+dJwGEUKsN2bzY1202ybU1MnczQhxn40juX7oHvwtQmvAzRBIFvMMV514A2jqC8FPlznmNs/FCkU1++mc2aTVCvxd4kTuoj5qKHVoyEGDMM722wTpl2kchctMGt/t7vktzjzro=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some architectures, such as RISC-V, use the ELF e_flags field to encode
ABI-specific information (e.g., ISA extensions, fpu support). Debuggers
like GDB rely on these flags in core dumps to correctly interpret
optional register sets. If the flags are missing or incorrect, GDB may
warn and ignore valid data, for example:

    warning: Unexpected size of section '.reg2/213' in core file.

This can prevent access to fpu or other architecture-specific registers
even when they were dumped.

Save the e_flags field during ELF binary loading (in load_elf_binary())
into the mm_struct, and later retrieve it during core dump generation
(in fill_note_info()). A new macro ELF_CORE_USE_PROCESS_EFLAGS allows
architectures to enable this behavior - currently just RISC-V.

Signed-off-by: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
---
Changes in v2:
 - Remove usage of Kconfig option.
 - Add an architecture-optional macro to set process e_flags. Enabled
   by defining ELF_CORE_USE_PROCESS_EFLAGS. Defaults to no-op if not
   used.

 arch/riscv/include/asm/elf.h |  1 +
 fs/binfmt_elf.c              | 34 ++++++++++++++++++++++++++++------
 include/linux/mm_types.h     |  3 +++
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
index c7aea7886d22..5d9f0ac851ee 100644
--- a/arch/riscv/include/asm/elf.h
+++ b/arch/riscv/include/asm/elf.h
@@ -20,6 +20,7 @@
  * These are used to set parameters in the core dumps.
  */
 #define ELF_ARCH	EM_RISCV
+#define ELF_CORE_USE_PROCESS_EFLAGS
 
 #ifndef ELF_CLASS
 #ifdef CONFIG_64BIT
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index caeddccaa1fe..e52b1e077218 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -66,6 +66,14 @@
 #define elf_check_fdpic(ex) false
 #endif
 
+#ifdef ELF_CORE_USE_PROCESS_EFLAGS
+#define elf_coredump_get_process_eflags(dump_task, e_flags) \
+	(*(e_flags) = (dump_task)->mm->saved_e_flags)
+#else
+#define elf_coredump_get_process_eflags(dump_task, e_flags) \
+	do { (void)(dump_task); (void)(e_flags); } while (0)
+#endif
+
 static int load_elf_binary(struct linux_binprm *bprm);
 
 /*
@@ -1290,6 +1298,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	mm->end_data = end_data;
 	mm->start_stack = bprm->p;
 
+	/* stash e_flags for use in core dumps */
+	mm->saved_e_flags = elf_ex->e_flags;
+
 	/**
 	 * DOC: "brk" handling
 	 *
@@ -1804,6 +1815,8 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	struct elf_thread_core_info *t;
 	struct elf_prpsinfo *psinfo;
 	struct core_thread *ct;
+	u16 machine;
+	u32 flags;
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
 	if (!psinfo)
@@ -1831,17 +1844,26 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 		return 0;
 	}
 
-	/*
-	 * Initialize the ELF file header.
-	 */
-	fill_elf_header(elf, phdrs,
-			view->e_machine, view->e_flags);
+	machine = view->e_machine;
+	flags = view->e_flags;
 #else
 	view = NULL;
 	info->thread_notes = 2;
-	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS);
+	machine = ELF_ARCH;
+	flags = ELF_CORE_EFLAGS;
 #endif
 
+	/*
+	 * Override ELF e_flags with value taken from process,
+	 * if arch wants to.
+	 */
+	elf_coredump_get_process_eflags(dump_task, &flags);
+
+	/*
+	 * Initialize the ELF file header.
+	 */
+	fill_elf_header(elf, phdrs, machine, flags);
+
 	/*
 	 * Allocate a structure for each thread.
 	 */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d6b91e8a66d6..e46f554f8d91 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1098,6 +1098,9 @@ struct mm_struct {
 
 		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
+		/* the ABI-related flags from the ELF header. Used for core dump */
+		unsigned long saved_e_flags;
+
 		struct percpu_counter rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
-- 
2.50.1


