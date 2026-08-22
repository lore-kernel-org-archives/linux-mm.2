Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA6FC5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18A86B00A4; Sat, 22 Aug 2026 09:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1B46B00A5; Sat, 22 Aug 2026 09:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942606B00A6; Sat, 22 Aug 2026 09:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5196B00A4
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC280120147
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:14 +0000 (UTC)
X-FDA: 85129049628.30.0B034EF
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1EBDE4000A
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g04y7qrb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3A6qJaggKCNg4L75+ACNAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ardb.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=3A6qJaggKCNg4L75+ACNAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCGSy80EkADOYqRdnClxXtF6MDWdUJROODWOao0NQ9A=;
	b=PDyWpOlIFCW8dQz08RAQAsYOUwXZhZOLHfwuYCPNGAYJSusYNLmuROyon5GXtCNsQOTz0I
	JtPj6c7iuYPN1khsIt0FgbtgT5antzplHd2rY3PtBCoXpj4fmuhZC3WLotR5LFSSNddKv5
	xNWnUjBn7/o00hGbvTiDqNDMnz0xzcM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g04y7qrb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3A6qJaggKCNg4L75+ACNAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ardb.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=3A6qJaggKCNg4L75+ACNAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ardb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406853;
	b=vh1JhrBf/it3RuHtXYIBlg5LMaZIrfLDDmZYGs5gcRFVHydISU/2kFzZisNXr0szYEE580
	nc3NPZblvuz4yVUdiBllTp99ieKXkZh61Cg3+zk5zbYn1KeF91jhcwCU6M8pGATMZ0c4jM
	N7fJOC+42sgepJnKPBc5Bzxxls3Q/dA=
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f83450a8eso1568528f8f.0
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406852; x=1788011652; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uCGSy80EkADOYqRdnClxXtF6MDWdUJROODWOao0NQ9A=;
        b=g04y7qrbS1gm4hhdViVbK1NCqxmf/PQFtX/wEWwZeQaNddk0ZzyaZZSwKyhvC2VGBK
         KcCBwvKdl/91W42WEOWo7HjeU1tcKUxqspRuXLUH9UXI4EbFr5ePJCU6pSyQRuFH3Lwp
         1wg1nKBVI5HLXowwaLRBAcGHpkRtmtTwo5Ylw1TGHRHx7CIPtoY/DOQa9TFyJGaFmznY
         +p/BnoR9xTKOAVNV++r3OXemflDr6qfiTcgrKxvhMQEQdtT9XhG0QTjrrcy0N43W13T3
         uBrb4sWPqG46TCdNnZeL4lIvxb6VYpuFjK2HSHJNqJAkNmw7UavmP+TwyR2lOWBFF0Gx
         km6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406852; x=1788011652;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uCGSy80EkADOYqRdnClxXtF6MDWdUJROODWOao0NQ9A=;
        b=cSlrsOypyL9x3by1iFYhtBwuTkQWuZ7WUw/P/93A4MdvAdJMGefm//JdZCwwui043p
         +eFdDOQ/pLvIKl9CK70IjFe9I2xdR4ksiu9dMeCvbIQNUKv7o9hrWps+IllYwB5jsAWO
         EM9xgSj5m/rLvBhYMEU3ZDQlk9ZV+DAGhk3AR26B9IUiWzjOUPS0wqj+KapkyZ5APU63
         YRNu7+xhU9nykI6fuplpETDpne3xFeWiHpCKNHTSSgyvvDD/ncTxfkkjR6KyYUhZ1GsJ
         iR0NuXa5JzOKIc4gh4b3ziWJ5Jes6zqcgQx15eRXTMABsiny1eOGxIOjlexIJtUEXXbF
         1tQw==
X-Forwarded-Encrypted: i=1; AHgh+Rq8FMPVyU7mcQMjznsQKdyOlfS+ZyiwvaP/FE3bfP4GsQ3QTIwYOuAnN/QeouaI2T45MzHC4Az8vA==@kvack.org
X-Gm-Message-State: AFuF++mad0v/jtzbYkmN7CzwjZkZIiEucKEiE8UMy6x72/mHCpbL79Gy
	Ky8KtMz3/RS3epdfd6IlrND7Yn1UI24hsCMi/Au5AgSc/yzWWO9PVhF6rLmG4BcDpeqWSV/qyQ=
	=
X-Received: from wrtv12.prod.google.com ([2002:a5d:610c:0:b0:47f:76fc:f05a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2589:b0:482:bf17:e685
 with SMTP id ffacd0b85a97d-482c0b88f19mr19709898f8f.11.1787406851530; Sat, 22
 Aug 2026 06:54:11 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:29 +0200
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Mime-Version: 1.0
References: <20260822135323.795946-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4579; i=ardb@kernel.org;
 h=from:subject; bh=BEHgSt5XbzXt4tBoZXsq5UPFvM43IOdkHorxrjqha9w=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIatz5b2w6FXrAkIL3p777u+w3ijm62ajN4vezjfYEpZQl
 u7w99y6jlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRA0mMDO0W8Xtjiy5zcH03
 q/x9b5GHzca9Bgf6WzaZLIo6+FaheSUjw3TVOf/Ejuza9aHbfV1D3U6jyXpCKevnz9LVlc13Lr4 txwYA
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-18-ardb+git@google.com>
Subject: [RFC PATCH 7/9] arm64: ftrace: Revert "fix unreachable PLT for
 ftrace_caller ..."
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ofqhufs1fui4rjst6udfpai1i1ax3518
X-Rspamd-Queue-Id: 1EBDE4000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787406852-66912
X-HE-Meta: U2FsdGVkX19KxGoEhZoot7rGVHm8dC6FADgmYIjqWxf/9vPiYj0YZ8N8g7F6w4Z9ImADa6sRVkTprDG0SD+t//ccqiD3F2Xp1yzrlRIkeqj7GyRRa6amXTs9gF5l3ohOL5uNwltwNjn9GtNt9vCW8nhxvjifQrhyONZywKNi7w5s07MJ7PNUggKWqX3MFQz64Cmv+fx4y/UH+aRtcMNPPIvJBrwjG4BlJ/6jHP8XSZ5Q1IDfGStjW49ykPhD8SkudYoBS0fy3t4u/R+TJ6sqNCMkqIZZgUHidAdhd08HThC6eUOVmC8LS1B+mP+bClqfrRHhKwhhlsYKOzpFiCRKvBnDyaXCUvTaVXEnsoVl6Oac1rEWQA5oLU96pSi769j/TtHXvnkrkiepfjajGJ0ENfX2b2bNWseiXRG5RcCqhbyAXth9KiKpy1aB+jr6YZ6bPDUCK4dUwue+9uZCcdyC+8LPsqdddaAbSQuV4H79hikF8p1ymOCw69P7RLszBKJDzwknmAJ6lFk8ocz0+eteAzrZluPSGkwZcaMl8AXIqb/MQLD+phLyWky6ZQLI4SsKaIvFp8dx80yKRzgehCNXbwHDXH6N4DQXCXGMIhFsu3DSQLhD3m9SRLUBZRa/MTPuV5TFhOttPgiJfoSJ6/Ya6AiKeVwdZO66O+gQNmR6gHCND8t/Ra3+ZiLvNgs5PoY2OFEv5YjZoZKlAfvQvcZY8bf+M5Mlr+zK4bWQ/BttQziG5oqWiZ7vdjyGhfl7lPcEt6wr/2v0YPUKuFB7U4d5aF8FCCdUJwYrxjtVbV1M9HLy0v+z7Fbge2CWfAE1oopJsZHz1pwnuGy1wOo65OjjP713LpF2pLcofKZtXkpqga/7xyYyQuq8AWDE4RsRAHjGf5Y4+twhTl3OwSjlvbikVROfEuM9hGoUTS0a72nbe/gLUIlrHClLIS09i0YZ/984lxJ6vVyBq8E3liocY9d
 fmwgtCr5
 JvjBIQeCKA4K8ZBSFmEpTHaQAhnLNqjN49BUvY+RTNZ+49SfE1MaPc6S8S0kivoRaU1jWT1HxGlNOrTZsMwlWS4Y3x+13YUn1AhCYMjidoxZfrNtiedfTVOw6H0AeVKkxa/8kDMuDA3g+z55Dl/QVIf3X/EgoGo2LU+buFDR4ruuu6Ra9r0ZjeugEVQcetU5MnDyqmspotBaRiMuQA1xK7uCVi9uqechMMqh2Z6qL5iA9bshWeylIVbleIp6z54HlcAWHwRoCrrnZ4lghBfL/DvoQCjdasvtSAGRP0gh9SPGlAv+8CnJB1eOifu8eCT1+DuuqFc5+QCgQUTg8IdS8A2S8vLTHPVjvtqtJc8MVolavqQtSA8nyeZJYUNyiRg2/HizxcaDC6jFViOZ23FPRyOIAyXaXCzHQRq7MQJlmHK4ajk9e5xXPR1hdkgFnCd0Jijm5rtKEzZeZalOwUeAbm3UJYXzsZ/+q94LNx1plN1xO54n/Pqt9vtNqugJfqzeHhSQmjUWbxxFsVNsxNuh65SUFaFIn3sla75sW1Rtc8FqB2IonHYfDVrrKga90ZzSM+gqGbZ4WJxGRZ13yinoKi+be3rPxGS2vfUjciIdsx7CfmC1rl7G2aNrjm+96snQoe785ew1VI8LbyPtI+MKICG/NLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

This reverts commit a7ed7b9d0ebb038db9963d574da0311cab0b666a, which is
no longer needed now that the corner case where .init.text is placed out
of direct branching range from .text of the same module can no longer
occur.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/module.h     |  1 -
 arch/arm64/include/asm/module.lds.h |  1 -
 arch/arm64/kernel/ftrace.c          | 13 +++----------
 arch/arm64/kernel/module-plts.c     | 12 +-----------
 arch/arm64/kernel/module.c          | 11 -----------
 5 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index fb9b88eebeb1..79550b22ba19 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -19,7 +19,6 @@ struct mod_arch_specific {
 
 	/* for CONFIG_DYNAMIC_FTRACE */
 	struct plt_entry	*ftrace_trampolines;
-	struct plt_entry	*init_ftrace_trampolines;
 };
 
 u64 module_emit_plt_entry(struct module *mod, Elf64_Shdr *sechdrs,
diff --git a/arch/arm64/include/asm/module.lds.h b/arch/arm64/include/asm/module.lds.h
index 0b3aacd22c59..0c3aea98e116 100644
--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -2,7 +2,6 @@ SECTIONS {
 	.plt 0 : { BYTE(0) }
 	.init.plt 0 : { BYTE(0) }
 	.text.ftrace_trampoline 0 : { BYTE(0) }
-	.init.text.ftrace_trampoline 0 : { BYTE(0) }
 
 #ifdef CONFIG_KASAN_SW_TAGS
 	/*
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 5a1554a44162..b56da24c1be4 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -258,17 +258,10 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ftrace_modify_code(pc, 0, new, false);
 }
 
-static struct plt_entry *get_ftrace_plt(struct module *mod, unsigned long addr)
+static struct plt_entry *get_ftrace_plt(struct module *mod)
 {
 #ifdef CONFIG_MODULES
-	struct plt_entry *plt = NULL;
-
-	if (within_module_mem_type(addr, mod, MOD_INIT_TEXT))
-		plt = mod->arch.init_ftrace_trampolines;
-	else if (within_module_mem_type(addr, mod, MOD_TEXT))
-		plt = mod->arch.ftrace_trampolines;
-	else
-		return NULL;
+	struct plt_entry *plt = mod->arch.ftrace_trampolines;
 
 	return &plt[FTRACE_PLT_IDX];
 #else
@@ -339,7 +332,7 @@ static bool ftrace_find_callable_addr(struct dyn_ftrace *rec,
 	if (WARN_ON(!mod))
 		return false;
 
-	plt = get_ftrace_plt(mod, pc);
+	plt = get_ftrace_plt(mod);
 	if (!plt) {
 		pr_err("ftrace: no module PLT for %ps\n", (void *)*addr);
 		return false;
diff --git a/arch/arm64/kernel/module-plts.c b/arch/arm64/kernel/module-plts.c
index 7afd370da9f4..bde32979c06a 100644
--- a/arch/arm64/kernel/module-plts.c
+++ b/arch/arm64/kernel/module-plts.c
@@ -283,7 +283,7 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	unsigned long core_plts = 0;
 	unsigned long init_plts = 0;
 	Elf64_Sym *syms = NULL;
-	Elf_Shdr *pltsec, *tramp = NULL, *init_tramp = NULL;
+	Elf_Shdr *pltsec, *tramp = NULL;
 	int i;
 
 	/*
@@ -298,9 +298,6 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 		else if (!strcmp(secstrings + sechdrs[i].sh_name,
 				 ".text.ftrace_trampoline"))
 			tramp = sechdrs + i;
-		else if (!strcmp(secstrings + sechdrs[i].sh_name,
-				 ".init.text.ftrace_trampoline"))
-			init_tramp = sechdrs + i;
 		else if (sechdrs[i].sh_type == SHT_SYMTAB)
 			syms = (Elf64_Sym *)sechdrs[i].sh_addr;
 	}
@@ -366,12 +363,5 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 		tramp->sh_size = NR_FTRACE_PLTS * sizeof(struct plt_entry);
 	}
 
-	if (init_tramp) {
-		init_tramp->sh_type = SHT_NOBITS;
-		init_tramp->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
-		init_tramp->sh_addralign = __alignof__(struct plt_entry);
-		init_tramp->sh_size = NR_FTRACE_PLTS * sizeof(struct plt_entry);
-	}
-
 	return 0;
 }
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 24adb581af0e..6e5b488a219e 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -466,17 +466,6 @@ static int module_init_ftrace_plt(const Elf_Ehdr *hdr,
 	__init_plt(&plts[FTRACE_PLT_IDX], FTRACE_ADDR);
 
 	mod->arch.ftrace_trampolines = plts;
-
-	s = find_section(hdr, sechdrs, ".init.text.ftrace_trampoline");
-	if (!s)
-		return -ENOEXEC;
-
-	plts = (void *)s->sh_addr;
-
-	__init_plt(&plts[FTRACE_PLT_IDX], FTRACE_ADDR);
-
-	mod->arch.init_ftrace_trampolines = plts;
-
 #endif
 	return 0;
 }
-- 
2.55.0.860.g4b6b3295ed-goog


