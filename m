Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC108CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA65A8E005D; Mon,  1 Sep 2025 09:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54588E0008; Mon,  1 Sep 2025 09:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959508E0008; Mon,  1 Sep 2025 09:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73C798E005D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:54:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 362F011A3E7
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:54:36 +0000 (UTC)
X-FDA: 83840826552.12.D637568
Received: from m.syntacore.com (m.syntacore.com [178.249.69.228])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA0D81C0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:54:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=peyNlvWF;
	spf=pass (imf18.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com;
	dmarc=pass (policy=none) header.from=syntacore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734874; a=rsa-sha256;
	cv=none;
	b=xa0M0yfdml6oUUTFz+j/rHb/6ecTPGKyfn2pAbEU+G/3aUzIcl+ZjUD+JsqRU3MAmjiojX
	pk6uHFfIZB90+J5h8g+BHunNaJBppQcQBNreoI6z+ZgjOYGR5N3dsuPEVPY5Lioq4r6yUX
	K8gEK3jFbtv9jyW41p/WdMdpMTppq8E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=peyNlvWF;
	spf=pass (imf18.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com;
	dmarc=pass (policy=none) header.from=syntacore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ozw0O54FHk+TR7i9YrzO3JawV9UWD7KG8XrbYOvortQ=;
	b=ntq57jrZd88hgnsqD0wdEeSBheKWs1pg38fD4+k1RasOrVQSOhnKSdMPBYLJiOdVTtfBR9
	0EZWjAPeg1TjA0uDrVhZIZMRSwzTj71gXnttXQszomfq803ekyEWCPA5expD9YpPySGsPM
	8GaF6SE/IHDPcBEmbQnhQpr6gHepRsk=
Received: from MRN-SC-KSMG-01.corp.syntacore.com (localhost [127.0.0.1])
	by m.syntacore.com (Postfix) with ESMTP id 0FFE71A0004;
	Mon,  1 Sep 2025 13:54:31 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 m.syntacore.com 0FFE71A0004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com; s=m;
	t=1756734871; bh=Ozw0O54FHk+TR7i9YrzO3JawV9UWD7KG8XrbYOvortQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=peyNlvWFhWIz1gS25XmRT+Gl87AHdP2bmsj7MxlSrvVwy0Hw2XYGoSh1GMIoRvZ5C
	 VCHoSk4RDu3pZzD6he2aBgueonopmlK7H8M4R66UiNdl60h9xk9b3JRFOhyyhCz/VL
	 UHG0iX8oYOSp5MK5/MgGQp+AVR5jRUrCu4y2eRyRFk1nFu+ph4ayO1Amp5LY2TMxfo
	 /OHlpSgFPnq8PsDKeDReiv4K8STUDGC7L17urcTh+doMyuqZQY+Sc7wWfwzw0WooOl
	 jPDi6uLMVuWwg1JwtD8CNEduS9boa+Y4pnatDgl3sdCm7Pzx2YHNtMjN5vqsrQbof8
	 QgwW/n2bUoqeA==
Received: from S-SC-EXCH-01.corp.syntacore.com (mail.syntacore.com [10.76.202.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by m.syntacore.com (Postfix) with ESMTPS;
	Mon,  1 Sep 2025 13:54:28 +0000 (UTC)
Received: from localhost (10.30.18.228) by S-SC-EXCH-01.corp.syntacore.com
 (10.76.202.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 1 Sep
 2025 16:54:21 +0300
From: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
To: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>
CC: <paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
	<alex@ghiti.f>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<jack@suse.cz>, <kees@kernel.org>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<svetlana.parfenova@syntacore.com>
Subject: [RFC RESEND v3] binfmt_elf: preserve original ELF e_flags for core dumps
Date: Mon, 1 Sep 2025 20:53:50 +0700
Message-ID: <20250901135350.619485-1-svetlana.parfenova@syntacore.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.30.18.228]
X-ClientProxiedBy: S-SC-EXCH-01.corp.syntacore.com (10.76.202.20) To
 S-SC-EXCH-01.corp.syntacore.com (10.76.202.20)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/01 12:41:00 #27718494
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA0D81C0006
X-Stat-Signature: 7qzuqpwxypo8dkumno9szk84exfpa1u1
X-Rspam-User: 
X-HE-Tag: 1756734873-958783
X-HE-Meta: U2FsdGVkX1+TlwLWWZPQtkc6P/QHsuGm8BiHNX0A2sb2sm5SkxNXye5KL6qDsGR7aWCtPUkTiSrDzONrdFjsDocLHyk1HnAw3O8/8PTRX/D6LCFxbNtF6crNtTKo/Mg0xZ3ZPhXypHlAmEgcwad0HDbvYhses1Q/4OZrcisLdQsqSCX1qouWp7e2unn370xnFPx4dccangJMwz7ao6skItTM6phT5bSjJKmHxps1p68swUE0VgyGmvPNjpXTYFH7eDHGIinWSqDNfqUksbAaGUvxveYUZWFgb4aAGokSPf/rWESBQBvNEg4zNwzKCYQXh6uvXswTxLtsK5aEfssqUKr83eydiSfVkf0B2WXM4Pb/MwJi7J1fq9C4DW/0YpM1MhFdcEPoOiSV/owp1A186WYXNEhkLBlJN6fPIeGLXs4Iy2K2AOGmTxV/0JVsiBrcLNnqPXoh/jfHoLdpIKCM7z0fBN53mj96xhKJmwd5ZYgUQX78ncsTCa5tdE5GnG8qECLiWCMko1r4a6wEaYCHPucvpYDzrZRKdw3OaOyHvbBIVQ1x5i6/0CGNiyZBbX/uBssKDVVjaLAfM0uvZuk+eS2KPt8o8VdavYlTXdFC5oDAsdyBasbPQfHfhPGl8vmugtuLsYTCK8IasO+nMwkUHBcUCUdMt08hHx4O++yUsEV29k8WUNNv6kTyPMDj6xgnhZ9WLJnE0wbLAZUwZQzYDjw/TY3RjDJ8uaQWJlqpfQh8OsMte1/y1Oh5DTqr/gDoFiP3RyfUHeRJGZKxzrWKGBoIcRGDqQ5rCXmsrIs809nKAvI+VvOTqTpJCAwExH9dpn+mWm3N5wE3gO3pHNoFRvK2LW+tGpRgzjw5YRbC015HVcReYS5eenaLfjFzmCc1rjb+BZa7TuhZqfB2JjmyXFXbFCdydboqvisUihi6q+eakxEr2VH9UU0fBR2M5Qx6xks7wRkM5gkbetKauwc
 faeQ9Ps5
 WPZPowee9xhV/7IXC3K/iseMl5WfeFoSogZvtWrDUPBRUO1l7pnbTyIovUrVxYbDyhc2iff1nVihE638t+0mMA3XTXK0SJzvUy0eZbGdRq+LsasgHwK5GsIde+QPx30BXFuxd310dEWnogmxG0ed8f0AjvqY2qNKeRa6U/xw40K6+B0YdOUNbERLLnEFxGhyYDOQ+a5kTuyO8R4isrDl22ES2XdbZ3qNsF6NhqOMhxCPLdSW4eGCAudb7XRT5NBlBQ/vrigRHyt+2F5JszAqouRn338hADLmjCJr7+2RHwysBxAiKxt3R157E993XXXwJBv+Bfn+LcGU/zzkoNrtMvzKXimNtCdXwY+f5V6eVRN8ekCJ2AECN3tnSeMKI0KXz/+PTjcLh1dEiLvlC2En12Yrk1ct6t4VIho6rVrOweSmjAnOWHdDIMrJL10cMPIpR1pnl7RUwpuJ0R8VPwApH+BT56a57lR0ViRdwe4vmfRdr49XgXJf2msTkEyLh7zcJZS9uGw8IN8izs+o=
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
(in fill_note_info()). Kconfig option CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
is introduced for architectures that require this behaviour.

Signed-off-by: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
---
Changes in v3:
 - Introduce CONFIG_ARCH_HAS_ELF_CORE_EFLAGS Kconfig option instead of
   arch-specific ELF_CORE_USE_PROCESS_EFLAGS define.
 - Add helper functions to set/get e_flags in mm_struct.
 - Wrap saved_e_flags field of mm_struct with
   #ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS.

Changes in v2:
 - Remove usage of Kconfig option.
 - Add an architecture-optional macro to set process e_flags. Enabled
   by defining ELF_CORE_USE_PROCESS_EFLAGS. Defaults to no-op if not
   used.

 arch/riscv/Kconfig       |  1 +
 fs/Kconfig.binfmt        |  9 +++++++++
 fs/binfmt_elf.c          | 40 ++++++++++++++++++++++++++++++++++------
 include/linux/mm_types.h |  5 +++++
 4 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index a4b233a0659e..1bef00208bdd 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -224,6 +224,7 @@ config RISCV
 	select VDSO_GETRANDOM if HAVE_GENERIC_VDSO
 	select USER_STACKTRACE_SUPPORT
 	select ZONE_DMA32 if 64BIT
+	select ARCH_HAS_ELF_CORE_EFLAGS
 
 config RUSTC_SUPPORTS_RISCV
 	def_bool y
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index bd2f530e5740..1949e25c7741 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -184,4 +184,13 @@ config EXEC_KUNIT_TEST
 	  This builds the exec KUnit tests, which tests boundary conditions
 	  of various aspects of the exec internals.
 
+config ARCH_HAS_ELF_CORE_EFLAGS
+	bool
+	depends on BINFMT_ELF && ELF_CORE
+	default n
+	help
+	  Select this option if the architecture makes use of the e_flags
+	  field in the ELF header to store ABI or other architecture-specific
+	  information that should be preserved in core dumps.
+
 endmenu
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4aacf9c9cc2d..e4653bb99946 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -103,6 +103,21 @@ static struct linux_binfmt elf_format = {
 
 #define BAD_ADDR(x) (unlikely((unsigned long)(x) >= TASK_SIZE))
 
+static inline void elf_coredump_set_mm_eflags(struct mm_struct *mm, u32 flags)
+{
+#ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
+	mm->saved_e_flags = flags;
+#endif
+}
+
+static inline u32 elf_coredump_get_mm_eflags(struct mm_struct *mm, u32 flags)
+{
+#ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
+	flags = mm->saved_e_flags;
+#endif
+	return flags;
+}
+
 /*
  * We need to explicitly zero any trailing portion of the page that follows
  * p_filesz when it ends before the page ends (e.g. bss), otherwise this
@@ -1290,6 +1305,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	mm->end_data = end_data;
 	mm->start_stack = bprm->p;
 
+	elf_coredump_set_mm_eflags(mm, elf_ex->e_flags);
+
 	/**
 	 * DOC: "brk" handling
 	 *
@@ -1804,6 +1821,8 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	struct elf_thread_core_info *t;
 	struct elf_prpsinfo *psinfo;
 	struct core_thread *ct;
+	u16 machine;
+	u32 flags;
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
 	if (!psinfo)
@@ -1831,17 +1850,26 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
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
+	 * if arch needs that.
+	 */
+	flags = elf_coredump_get_mm_eflags(dump_task->mm, flags);
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
index 08bc2442db93..04a2857f12f2 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1102,6 +1102,11 @@ struct mm_struct {
 
 		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
+#ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
+		/* the ABI-related flags from the ELF header. Used for core dump */
+		unsigned long saved_e_flags;
+#endif
+
 		struct percpu_counter rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
-- 
2.51.0


