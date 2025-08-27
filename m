Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76F6CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25736B0025; Wed, 27 Aug 2025 16:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECEF56B0026; Wed, 27 Aug 2025 16:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9DA96B0027; Wed, 27 Aug 2025 16:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9F666B0025
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:24:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 815F31DE4F1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:24:25 +0000 (UTC)
X-FDA: 83823664890.25.342C5BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BBFBB4000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:24:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ap9/YJjp";
	spf=pass (imf12.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756326263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=mj2qlFU23Jx2jeUNS22RJ968bZg+/OWFR4Bpa6VUh4o=;
	b=6q0RoR/pY9muFz3jUqRywp17j1Jsr9jugGW6s6hcHj6N3KNJOV6nlAkF3JvBZCbQc7Y59q
	j3KqGXdwPypJljBKEAfV2fo6LUNmyPyJ47GelqBb11fC5paEHCMLTrSaPyMJ+GY5v1VmbE
	1ntN/WLkvpMnZpTMPSq4W4Q/68ZynnY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ap9/YJjp";
	spf=pass (imf12.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756326264; a=rsa-sha256;
	cv=none;
	b=BmsMM74ZbHQIPZNPqV9fSSU0eKS3xahLUGBs15LMVS53eEhM5S5Dv9QSG04o3K5JR/rnGY
	XNivn7sU+N44BFmJctROF7dyz9WCSPcirSM6vEEo/2B5SbtrZ2lrxmEZzUVQ36zj/hX4pw
	igplBjTGgoypig0KN8BJp4G6fDx5Pq8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A5F344CBD;
	Wed, 27 Aug 2025 20:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C2FC4CEF7;
	Wed, 27 Aug 2025 20:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756326262;
	bh=ZSB0DnLzbKO8PCtsd2VxzkydgfL0SwzNGhpgsWTugOw=;
	h=Date:From:To:Cc:Subject:References:From;
	b=Ap9/YJjpWNRXq+ka9fcI3c2Tyv5uvcrw3lK6BOUtwmTW4GhtV1HMh/zj4UyUfX6V1
	 aopmKgmt+vQcwsLpafeUMP9X1GAwO3NzCzM0RT28nqqOqhog5Lb/VA87RmdcfCcEQ9
	 pvlh0R4efmUNi/B1JJNlRho0LYgVWmP28SdshU6Mw10cSISc4BOG1J/+jgjCp2i1ZU
	 Z9HBh05sbCmPx+Mqy2vPDREXxcqWtzme6G8ygBjeZhwEwautl/nz/0LWgeHA4sbqgA
	 kCTbCu9CjYHCf3n2M5Y3wYOWNmFm61+L5WAe78Mbf+FsqpMu5JY+8RUjyNPanqYh2y
	 gWSoBrvCChLOQ==
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@kernel.org>)
	id 1urMhF-00000003kyL-0OqI;
	Wed, 27 Aug 2025 16:24:41 -0400
Message-ID: <20250827202440.946751792@kernel.org>
User-Agent: quilt/0.68
Date: Wed, 27 Aug 2025 16:15:53 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org,
 x86@kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Andrii Nakryiko <andrii@kernel.org>,
 Indu Bhagat <indu.bhagat@oracle.com>,
 "Jose E. Marchesi" <jemarch@gnu.org>,
 Beau Belgrave <beaub@linux.microsoft.com>,
 Jens Remus <jremus@linux.ibm.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Florian Weimer <fweimer@redhat.com>,
 Sam James <sam@gentoo.org>,
 Kees Cook <kees@kernel.org>,
 "Carlos O'Donell" <codonell@redhat.com>,
 linux-mm@kvack.org
Subject: [PATCH v10 05/11] unwind_user/sframe: Detect .sframe sections in executables
References: <20250827201548.448472904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: meadjzjdf8n4i8mms7o9u3tqhw5w3xro
X-Rspam-User: 
X-Rspamd-Queue-Id: BBFBB4000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756326263-373540
X-HE-Meta: U2FsdGVkX1+lmSfqziKJX+3rxR5M1FkjnawQzU5c4kVEewgkU9mrYMqkKloTDm0zi+4CDa8HIN27oG3UJ9PWSPVyrlFbj1eQPH//IpF2bTrP+IsIAJGa/0y0lNNIA50J+Y3aQHCW8G9gXfbcDZ6MlnT+KFAGsbQjyvAWheAV3pfntjdZqHb1Kzy9qLYAQ81U0DgS6V4zAekP94RFguI0bnmXAJi63R98Q+0nsdScIag36je0XWX01dDR1wMUhnRh3FZC85sB11SlNZXDzxFWWNzVY4NB4gnCYDVPLkBAD8E3HEMcPTzy41KvBAZN0OPHCA+Thxwlrvt7AtgzfmPJPjMoslAMX5s1UT/88/saLPXM7/iXphSqI7FsVs9vw5tqk1CN0oFqNfYMlbboTTajaCKglPEa0ubjXetvu/X3yPys1V0M+Hsbcd67Vq8OfsTdHdWJFyVQqemgWtruriOpz5zkRNVjdI8QCRHTqqYoZBESdpWiwElNs6qAhmUD13/OF7UWk2DTenqrHgmuKzrjVMJce0j7AQXmnmgGPR+VIo2r++SGd1s/DaJVH6XIkYzWzE0SJqW5Dgb5AfW0YNC3eoQyNG54utjDFxnDcu+8xpCCNSGgG9unZapl6c9u8gWUSmR7aCBrUXdcZGjroimnwKwuWsLMK9Lcg62VDrvaPPLmHiH2BxEAMx5cfHk+czoPvlYwfOUYhrQL+AaauTYhKQWvy76BLs+3CowX6twoURxLjJAH/OQ5Ea2gxT93SxSeBcMEcorq5iNT2A/Zjq85WKZ5Y4tBaRbkNoePI+VlYLSP+q0S4w72NvuUYjKCVFMi0zm8cNCLZ7X5Sm5rrpDom7m3jIzIAQs5IDRwN+LuOe7CkAgvR5d+bqw9RKkyJCBo9fYE9ZuswRwa22k8v5uxe/ptY1ex28JMbB2mfmKMiU+9a5TGgeEJcGdUcpODaXBNYF2iMDaSnn7TsdipYNU
 eW5xxd9J
 33xHr0TwfoJXztM4Z5SkOrmnLYidUiRpStPXa7QxXNzLzWPIYm3P0IuD8V2A8nznungMh2esEv7JmkF86cuHNG2QXjOM+1jZN8UvPylYTB5fGfDoetvRhadPebSfKClwTZiIVle2ypjWZMb+zuLWbeGyT4ba93XayP3wI29BMx6t3K61mvVG+5wm1v01EI6oXw6Z16hMeAMxPSIo0IDEZBD3H5qkpRueq3f/cMo299/pMEaDtIfAXXwk0S5M2hLRbaNTr71cX0wP8KE+/e32vQ8YjqQTXfFuLDjTa/BREpHq4m+BTUPf1jTFX4TTK8LJTI5dH3P77EQDOiatXO5TY1k8bSBM8DOV9ryQ4z4G+c7sTcVL72PsjMYUKJtI+ENHXLCmeA1TqBzhyt8MWDBrYo20QIbfgigF0rl+dKnzFR+Y4mSgwxNDJzoi+K4ltx5sjRiFW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

When loading an ELF executable, automatically detect an .sframe section
and associate it with the mm_struct.

Cc: linux-mm@kvack.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/binfmt_elf.c          | 49 +++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/elf.h |  1 +
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 264fba0d44bd..1fd7623cf9a5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -47,6 +47,7 @@
 #include <linux/dax.h>
 #include <linux/uaccess.h>
 #include <linux/rseq.h>
+#include <linux/sframe.h>
 #include <asm/param.h>
 #include <asm/page.h>
 
@@ -622,6 +623,21 @@ static inline int make_prot(u32 p_flags, struct arch_elf_state *arch_state,
 	return arch_elf_adjust_prot(prot, arch_state, has_interp, is_interp);
 }
 
+static void elf_add_sframe(struct elf_phdr *text, struct elf_phdr *sframe,
+			   unsigned long base_addr)
+{
+	unsigned long sframe_start, sframe_end, text_start, text_end;
+
+	sframe_start = base_addr + sframe->p_vaddr;
+	sframe_end   = sframe_start + sframe->p_memsz;
+
+	text_start   = base_addr + text->p_vaddr;
+	text_end     = text_start + text->p_memsz;
+
+	/* Ignore return value, sframe section isn't critical */
+	sframe_add_section(sframe_start, sframe_end, text_start, text_end);
+}
+
 /* This is much more generalized than the library routine read function,
    so we keep this separate.  Technically the library read function
    is only provided so that we can read a.out libraries that have
@@ -632,7 +648,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		unsigned long no_base, struct elf_phdr *interp_elf_phdata,
 		struct arch_elf_state *arch_state)
 {
-	struct elf_phdr *eppnt;
+	struct elf_phdr *eppnt, *sframe_phdr = NULL;
 	unsigned long load_addr = 0;
 	int load_addr_set = 0;
 	unsigned long error = ~0UL;
@@ -658,7 +674,8 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 
 	eppnt = interp_elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
-		if (eppnt->p_type == PT_LOAD) {
+		switch (eppnt->p_type) {
+		case PT_LOAD: {
 			int elf_type = MAP_PRIVATE;
 			int elf_prot = make_prot(eppnt->p_flags, arch_state,
 						 true, true);
@@ -697,6 +714,20 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 				error = -ENOMEM;
 				goto out;
 			}
+			break;
+		}
+		case PT_GNU_SFRAME:
+			sframe_phdr = eppnt;
+			break;
+		}
+	}
+
+	if (sframe_phdr) {
+		eppnt = interp_elf_phdata;
+		for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
+			if (eppnt->p_flags & PF_X) {
+				elf_add_sframe(eppnt, sframe_phdr, load_addr);
+			}
 		}
 	}
 
@@ -821,7 +852,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	int first_pt_load = 1;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
-	struct elf_phdr *elf_property_phdata = NULL;
+	struct elf_phdr *elf_property_phdata = NULL, *sframe_phdr = NULL;
 	unsigned long elf_brk;
 	bool brk_moved = false;
 	int retval, i;
@@ -930,6 +961,10 @@ static int load_elf_binary(struct linux_binprm *bprm)
 				executable_stack = EXSTACK_DISABLE_X;
 			break;
 
+		case PT_GNU_SFRAME:
+			sframe_phdr = elf_ppnt;
+			break;
+
 		case PT_LOPROC ... PT_HIPROC:
 			retval = arch_elf_pt_proc(elf_ex, elf_ppnt,
 						  bprm->file, false,
@@ -1227,6 +1262,14 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			elf_brk = k;
 	}
 
+	if (sframe_phdr) {
+		for (i = 0, elf_ppnt = elf_phdata;
+		     i < elf_ex->e_phnum; i++, elf_ppnt++) {
+			if ((elf_ppnt->p_flags & PF_X))
+				elf_add_sframe(elf_ppnt, sframe_phdr, load_bias);
+		}
+	}
+
 	e_entry = elf_ex->e_entry + load_bias;
 	phdr_addr += load_bias;
 	elf_brk += load_bias;
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 819ded2d39de..92c16c94fca8 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -41,6 +41,7 @@ typedef __u16	Elf64_Versym;
 #define PT_GNU_STACK	(PT_LOOS + 0x474e551)
 #define PT_GNU_RELRO	(PT_LOOS + 0x474e552)
 #define PT_GNU_PROPERTY	(PT_LOOS + 0x474e553)
+#define PT_GNU_SFRAME	(PT_LOOS + 0x474e554)
 
 
 /* ARM MTE memory tag segment type */
-- 
2.50.1



