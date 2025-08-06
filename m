Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54050C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED39D6B0099; Wed,  6 Aug 2025 12:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84FC6B009A; Wed,  6 Aug 2025 12:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73676B009E; Wed,  6 Aug 2025 12:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C12A56B0099
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:19:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 647B381BB9
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:19:19 +0000 (UTC)
X-FDA: 83746842438.21.954F8D3
Received: from m.syntacore.com (m.syntacore.com [178.249.69.228])
	by imf02.hostedemail.com (Postfix) with ESMTP id EDFED8000D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:19:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b="Ef/RJIoN";
	spf=pass (imf02.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com;
	dmarc=pass (policy=none) header.from=syntacore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754497157; a=rsa-sha256;
	cv=none;
	b=QWKEBi9Q3v/no7slLwazlWPgOW3lsd9onEMHJZ2Ttb3PgmixLrOdn/IsmNeNj5WF7gW8rb
	+scE5hfz8gEYBxhqU53xI79wCIeqiDJRD14TMU6mHMX3rO52IgZM/kCpHl0k4HjJNPtAZr
	b8IA9AS6BF8JhRL4muUkzJY0WOOSOlQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b="Ef/RJIoN";
	spf=pass (imf02.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com;
	dmarc=pass (policy=none) header.from=syntacore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754497157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U6FTpKiOoyRjzi4zEir5vSNswrtfpJfF7RjfrB5z0zs=;
	b=OpXkPEL8K9mNI2apzF0PK3qAZ6zIUod9smVzwMZEALRY94kGofBdPytQRMuxQI5MvjyqVi
	fokMw0vnhYue90XQLSdJ9bcfHskPuNGkij8HxYL6mdlbf4kiyNiXy9z0q4s57wG3m6kgnG
	/MagxVk+PxUGfdnghLKPsKGfyZTxSEM=
Received: from MRN-SC-KSMG-01.corp.syntacore.com (localhost [127.0.0.1])
	by m.syntacore.com (Postfix) with ESMTP id 5664B1A0004;
	Wed,  6 Aug 2025 16:19:15 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 m.syntacore.com 5664B1A0004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com; s=m;
	t=1754497155; bh=U6FTpKiOoyRjzi4zEir5vSNswrtfpJfF7RjfrB5z0zs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=Ef/RJIoNJbs8EZgWhpfBfkBP9vpaJvH9f08yilVqXmt6XAnNeo3IlyE9Ifj3KZYO1
	 fk4AgYgfGCtS02Qdnhy2rktbsvSoZlY9ZH2UD1u6Q88xHcUiW6BgAUGLliWm4QaGwn
	 tvppdrKUJw+ztzH8SKrAiAdV7o/2FvFJDSXt7E8alQJxu2f+UmGoXSm6q7gDlPUVj0
	 AYs7O9nafqTs0mrGWxxBm3TedeYsCBzjZXKLk466X+OewqkeBBmnwU/C6NGjxn2u4+
	 GAxxMfsUOxfgjE5dTT0sWYwreGmlwQdyplt62HDfY6p9fkGshVnvd84SeVegfIHwrL
	 5QRRHp+koFaeA==
Received: from S-SC-EXCH-01.corp.syntacore.com (exchange.syntacore.com [10.76.202.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by m.syntacore.com (Postfix) with ESMTPS;
	Wed,  6 Aug 2025 16:19:13 +0000 (UTC)
Received: from localhost (10.178.118.36) by S-SC-EXCH-01.corp.syntacore.com
 (10.76.202.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 6 Aug
 2025 19:18:47 +0300
From: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
To: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<kees@kernel.org>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<svetlana.parfenova@syntacore.com>
Subject: [RFC RESEND] binfmt_elf: preserve original ELF e_flags in core dumps
Date: Wed, 6 Aug 2025 22:18:14 +0600
Message-ID: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.118.36]
X-ClientProxiedBy: S-SC-EXCH-01.corp.syntacore.com (10.76.202.20) To
 S-SC-EXCH-01.corp.syntacore.com (10.76.202.20)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/08/06 13:33:00 #27636797
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EDFED8000D
X-Stat-Signature: qohtap1ua9t3m5i4d3mgri8fxz6eqeck
X-HE-Tag: 1754497156-738848
X-HE-Meta: U2FsdGVkX1+mbOETAGXsqmGJq74RqtW70PpbZ/Jv8mfhBAWRqGjfIX4gcKl1RqHpU2Zkz+RgeKoe3sJJa5WhAEkyng7A3iK/ZwtPD2KnVy0Cp9zpxUzBBxcdGfxkhteEGXN1sICeFjOSp4EIdrdMB/LOLYMwnMuDBcU6NcQCwljjas17lgJBBc6Ua6gxwGxCrOzTq1AVSZWzSPh3TMpkXDfx2kVOZfgNKRTHNL4iSCo6pTM1xFBEQxbpGNbn1Za93iJSVUYLv6X0b4IKBnGzptlYL5jec2+xlHm/+xXjzUuFNo5oKuS1wlpZl6hPYVIpkfOEFNm2P7WjZXXZtYgoyYEJ9n7u5HnlAEDGCkBv9KIVF1DsrTQ5FtgU5ehjfrpAZXsrBrMiyOVyOm2oO13l4b/+F57tSgFWQIJ9lE00bQvHGC91OvNeEhM7r73ntmaiWR/Sy2neIlqiCNjbz9Rmg4GyHkTClHYUSPNFN/Zzb4tcSPAi6ZAvDIOfF5k0RnglajfFFD8VztaJO1Jbi1RI7QBx9PYHMrEIf7wUuZpdORhwjXfuiSzjZzqnskFooyxjBhvqhLaadwIhICL7DLeCoyRjHK7s0NrmnRFYVsD5Nu6bae/PMoNcb0dQ9H5XJbGWO1vT/151Er4Chu4i6xh+EVlYqkYUgHakdS70huo6R9F17ZYy73yBXWaBstmfrPaPMnVQnw5EjYpndVGpdhDphAm1oTA8zsxCiJNmB0qsQkuQCYqvoncdf0NJuhNzSwACQM2QDxWwH9GuHtCf80UnkFDB75mr4XzSrTvTs4r+DuY8TRrx1KT2koobBh9u469dciEYgxN7Sl1Sr/mnfUBkXQhppnD43yMyVxCxlrHsv96ZF6DrnMQFLsy9PgX/G1kJb8rm8R5Y4vEsAypd+P3l2EHE8t2pfHDhIjkgaDDFvTPVexjpH93Nb08/Pu9t/nyTK3jnZJYNsDIwXbL3plJ
 W2kuSagk
 cyZ4gwE0seJvqIzFQdsDyuwefMon09HlT/JVTJ/gn9ygQ0DzkfMzViwecm7fSthhH10Ce78L2FyOuhTzotMy+nBK1BdgFj7eaEq6DGckdZS9WaZhojtVSK1Yqqm3VU+zsHHxa7n3YCGQdBOuZZh73t2gKD7w9elT3FDcJATOWNGoqbVCYEDcv/Ckj/mXAkK2k07MEVwonHgstAm6z3N4bNSeFTwSeZX8wH4LiuCoaoT5NmEbtfNYlqkHPzpRFy5TktBRBP9DLdy6Pw4qLj1d18KvyPOKUlWTKhw7HqZpOfTh+ebAl+IB2Ls1Mi+BixzzzOHYaibRD9jt2H5JnrdiLAERANSKeMTvhj2oWhutU9lSrI9To2ahLbVQKRjfJhhvspp3fADFLij03E73QkJKKV8jynNsufY/Y/kynpr+0Xniml6+szMzeAOlXnjzNn/vWecmNhb3Sq6oxxRxb7Kfn4b70by+rUgfHK6YfSeugQoYbovYp/SFs57zGgcHl6GQ9ZJco4vBx9QWMYhk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preserve the original ELF e_flags from the executable in the core dump
header instead of relying on compile-time defaults (ELF_CORE_EFLAGS or
value from the regset view). This ensures that ABI-specific flags in
the dump file match the actual binary being executed.

Save the e_flags field during ELF binary loading (in load_elf_binary())
into the mm_struct, and later retrieve it during core dump generation
(in fill_note_info()). Use this saved value to populate the e_flags in
the core dump ELF header.

Add a new Kconfig option, CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS, to guard
this behavior. Although motivated by a RISC-V use case, the mechanism is
generic and can be applied to all architectures.

This change is needed to resolve a debugging issue encountered when
analyzing core dumps with GDB for RISC-V systems. GDB inspects the
e_flags field to determine whether optional register sets such as the
floating-point unit are supported. Without correct flags, GDB may warn
and ignore valid register data:

    warning: Unexpected size of section '.reg2/213' in core file.

As a result, floating-point registers are not accessible in the debugger,
even though they were dumped. Preserving the original e_flags enables
GDB and other tools to properly interpret the dump contents.

Signed-off-by: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
---
 fs/Kconfig.binfmt        |  9 +++++++++
 fs/binfmt_elf.c          | 26 ++++++++++++++++++++------
 include/linux/mm_types.h |  5 +++++
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index bd2f530e5740..45bed2041542 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -184,4 +184,13 @@ config EXEC_KUNIT_TEST
 	  This builds the exec KUnit tests, which tests boundary conditions
 	  of various aspects of the exec internals.
 
+config CORE_DUMP_USE_PROCESS_EFLAGS
+	bool "Preserve ELF e_flags from executable in core dumps"
+	depends on BINFMT_ELF && ELF_CORE && RISCV
+	default n
+	help
+	  Save the ELF e_flags from the process executable at load time
+	  and use it in the core dump header. This ensures the dump reflects
+	  the original binary ABI.
+
 endmenu
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index caeddccaa1fe..e5e06e11f9fc 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1290,6 +1290,11 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	mm->end_data = end_data;
 	mm->start_stack = bprm->p;
 
+#ifdef CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS
+	/* stash e_flags for use in core dumps */
+	mm->saved_e_flags = elf_ex->e_flags;
+#endif
+
 	/**
 	 * DOC: "brk" handling
 	 *
@@ -1804,6 +1809,8 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	struct elf_thread_core_info *t;
 	struct elf_prpsinfo *psinfo;
 	struct core_thread *ct;
+	u16 machine;
+	u32 flags;
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
 	if (!psinfo)
@@ -1831,17 +1838,24 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
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
 
+#ifdef CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS
+	flags = dump_task->mm->saved_e_flags;
+#endif
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
index d6b91e8a66d6..39921b32e4f5 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1098,6 +1098,11 @@ struct mm_struct {
 
 		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
+#ifdef CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS
+		/* the ABI-related flags from the ELF header. Used for core dump */
+		unsigned long saved_e_flags;
+#endif
+
 		struct percpu_counter rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
-- 
2.50.1


