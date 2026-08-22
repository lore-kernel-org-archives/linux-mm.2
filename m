Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1194C5DF9A
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489036B00A5; Sat, 22 Aug 2026 09:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412886B00A6; Sat, 22 Aug 2026 09:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300DE6B00A7; Sat, 22 Aug 2026 09:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 058826B00A5
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57F15140147
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:16 +0000 (UTC)
X-FDA: 85129049712.27.5CEDABE
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9252F80002
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BYsIlRhB;
	spf=pass (imf02.hostedemail.com: domain of 3BKqJaggKCNk5M86+BDOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ardb.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=3BKqJaggKCNk5M86+BDOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lE3r1MZLrWL74IP7BP3pqzwy+IxcMr+2cYN0bFzQAQ=;
	b=ymDpH6Pp2cAXZMYe2VZizWjTD6uXGhxLZ40uCyEOjWs+xY7fNkO84pbOLumLXV/g28qZFG
	T/ulWCRqoAgKtykjsZ5u4zO+YLbm1ss9rmq1nbBPbudn3JNiYYP7f97cfVcfNdOZluHbkZ
	x7IKFTHyWRc/7vAxhx0NroAlcGId2DQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406854;
	b=yVwNK7tQ/qGqGxZybkuN3pSt2tJU5bf+yCro+9r6MVPaw2w6gUYHGfvQbCKGPkwMGZ0SNs
	T6rqqafCSFyP+ZzakqfTIpy0fulsf1HJ9YRhha5VBRfvzB19270kAHTLB/wJRbBt8oR5ou
	8bkBbCmIjUxc7qowWPW4iHHByL03Z9c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BYsIlRhB;
	spf=pass (imf02.hostedemail.com: domain of 3BKqJaggKCNk5M86+BDOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ardb.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=3BKqJaggKCNk5M86+BDOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f84ac1990so1032981f8f.2
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406853; x=1788011653; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4lE3r1MZLrWL74IP7BP3pqzwy+IxcMr+2cYN0bFzQAQ=;
        b=BYsIlRhBNKPgJJw1VioL8lkrVxAGD1ns/hactY/3toR+KdpEWFmgmf756qPDk3HmiO
         G5rc04VKHOOEnOfI6vnHb0V0dM6xokgaRNEAsdqXFDNweUcsE2AWnxl04agoluifCuBX
         RRRcqVpgHeLlimMzeZvzkSKTpA4iQiuGQamHx94iW7hGCCZh/TBBVSGzABt77eYwbrnV
         zx9YCqkvouYSFRlUhEPBjqigso2UaMod2WWyWZdF3f5yxkFeonC+kj5v7hgyzdNo8qBF
         Y9MB4KTB2quJofnzqSmDusghqIV9/Wd4zjmdq/QIwK1HyRPSVYjYwQGm17IA3wKW8hKA
         Mbxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406853; x=1788011653;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4lE3r1MZLrWL74IP7BP3pqzwy+IxcMr+2cYN0bFzQAQ=;
        b=osX3ABxYaM69tT1TKdKhFyUfIUL8cDER7Od7pY0YRZuyVbcytcSwC5cPicAYHgG7ja
         RqHrg+Rq+hAYuXzMzWDrPVx6fUeuCgCIDkNY5PzaUppxBvkEIpNrehXk1pC3pDO2GRom
         G82YwrIpqfMH/eYY3MpnA5J3KMQM0bEXiHrshFK0tN+POZjnAbaZPrNEg6L88oSkdvqO
         +n4X+Q672ggwBDUQCeMSgeGRiQZv2CBfcs09Cy7imbVPtZQNE1jp7IdFh6fSwOgMKPrN
         fbczaIW4gUj4sY5jPM+qGCugcOay7cSxLVEew1mLkLExf/XWpl9iw19c1nE3z5DzlFQs
         JNXA==
X-Forwarded-Encrypted: i=1; AHgh+RqrIRnPRguVgFeiiKf6Qes1CdStfDUAZUS+YeVET44cGnUOCCoD4CmIIW5n1QwirKxfcp3NpDJtJw==@kvack.org
X-Gm-Message-State: AFuF++nSnHrCqepX/2Y9XSRH///hIOvEoVkD+u+hljjlDCbxR+JhfWK4
	/TaO6jxpO55Vzq5Qqh0RlgRQEJcClUvBb1yaTGs7w+MJTq3Z2t5c+BkU6npLg8i3+gkIPskXHQ=
	=
X-Received: from wrbgf1.prod.google.com ([2002:a05:6000:27c1:b0:462:567a:6591])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:6f13:0:b0:47f:e9fd:80d8
 with SMTP id ffacd0b85a97d-482c0bb40bemr18991596f8f.21.1787406852902; Sat, 22
 Aug 2026 06:54:12 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:30 +0200
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Mime-Version: 1.0
References: <20260822135323.795946-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5799; i=ardb@kernel.org;
 h=from:subject; bh=5Vh9JPqa1jt8juFWDYh0K543ecP29Z3LFYkXXDIJ0JE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIatz5f0rrx+s+jGrVkH3hJXknjsl122VL1WsEJX3nyc5J
 3SrBmd9RykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIp2BGhvu/oyTzD638eknh
 x5azWglPZFe66t+aGDBlhfIq+S9TPy9gZJj348O6+Lw9ldcEz9Z/ZujJu/c0/uE08dwNgV7bPq9 szmYAAA==
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-19-ardb+git@google.com>
Subject: [RFC PATCH 8/9] arm64: module: Combine init and core PLT entries again
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
X-Rspam-User: 
X-Stat-Signature: n1eyacpba5eg4m6jqhz949dbai9t3odq
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9252F80002
X-HE-Tag: 1787406854-113254
X-HE-Meta: U2FsdGVkX1+2ScpGU4C+JooTgNLfC04x1Y/qNCVUfE0rgcHYjMeydhL3KVvWNaekmQ5X8vTrxWUe6sCPzZOrlTdR9/pWgK4Ay+3zRJJTRQhPmfgSutPRPH+8LiB2uS7OJY0jwXpcZO072icl7ri3bjl+cejh2y8QlQ2Lwa1tQgeFdaB0O78YIkn9tB3p+sw+zPRr8hvCkQSEKg8/qemJ4nOqm5Nakq6ecEfaXV6hoy1DL5V+qC3ceFoifZmx4wBKSAg9VOVNl8Z7KWgYgltgbvpppwtbYR55tzQ5ef4Wj91574F1zFsJN4c8qp5YEm1Sp1wlWZz+yNRnlsUtKrfTkkrUBhQCN7xL3kXw1Bx1DcFQj4PUvkowhZ7DUOTMaSD7sUbzQ2jggkvvEhcMvwt51wn5CAgXAEQnqZUHQcqIk2+I9xUz6i+G6aUgcYceslSWR1oxrM4pUbIyVebVQxMu2bn04+wv0r1zM5AXqQAxL/15fN5v+8HIq4wtndxoGOFtDMl9HEDQfFX2K0LUBhP5fz0DNzxq5Wrchiw9nnR4qqfwr4U9rQpmYnBH2ELttx1AELHSSExH4Hm31Spoya5IrkVwvwvzSCpZSwmzOUfN6Hgb16Zi4RH+bsHhYqlS9P969PYJwLOnR3H/qn5X9pna5gda5+UhqbLHhgv5ZWFwAHWlWei6wBnG5zqLBNeByEkFzJ8PTE4MroGFfm4Dmstz35pOvunY1LRMGHuHpe0M+rgBlM3Ss0solYMj4Bic1RzaWgLJh81Kp+uJn4Lfb5QZHTp4DGQmiuc1NO2t3cHskO1Q9Nmzylv2bU+cDefG5iWqYzNcQtED/sfRvcpVOBpA3x6q+9rIRA8vsehYeT8thpq+AjycZ0EGjki+XwbSkdLf1IQGWGwQqgqx2F7HXJ+jkmH2Xw7ls1SNKHATvmY17FxIc9M9JkCaMmo2eatcmU2bkMxygvqcG4HoTas8+Vu
 SxxjiKpI
 gnhRCTwh2z9VzzG1/dioaW8O4lbIGk/atCgJ0d8FbArEGQCv9YhG37VxOvnThFruRyBEXu3XV0foD8uUjJzD0qXB9nbYJQjZbAClT/gch7gvIWlNFItFg6VN7NtnKO56828OXF19DwCfedZZP7z1A2gvWn1VzIxKRRj+wtNvaHjRnxMdtdwyla1oex1N6i5l5g/AtjMiZac7ZOSnYvFBk28ImSneIyIduv+LpXlX2Ukq2d+dO74gt8CA+HhhZdQjVOCGZXK+bkKTcdUIs44FNKC+65CuVfjwF0yUquxhcIlVLAWYbRCrGlWbsvty23KHejW5t6kOSOFD4d1HZuxzbgZ++0FX3Cf1ht5bXIeKfGbnBnd8kCd1MtIBHR7Zy89evvGXabij4jmKtKLu95w4XFewuj+K5rQT1YAOaIG70efBhGSnkBup4PaTU2PiTybkfl5Nkbew/0Skmy6eDSwu1SumLOwUBX1KizGAshbXACk+prxpQ4zvZZg4LwL2vi0kD1mJap9zCLRZCizidUUyBCj6dw/b2XHR+zm9Ns/1Y7xtKF+wEP5Vi1Zyqshh2S65wszvp/eJf8RIkQmEJah6oJ8O1CeSQ+l+W4wKG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

It is no longer possible for .init.text to end up being placed out of
direct branching range of the .text section of the same module, so the
PLT array of core and init code can be combined again.

It also means there is no longer a need to allocate PLT entries for
cross-section calls within the same module, and so the upper bound
for the number of needed entries can be lowered again as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/module.h     |  1 -
 arch/arm64/include/asm/module.lds.h |  1 -
 arch/arm64/kernel/module-plts.c     | 35 +++++---------------
 3 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index 79550b22ba19..9328fadb4a95 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -15,7 +15,6 @@ struct mod_plt_sec {
 
 struct mod_arch_specific {
 	struct mod_plt_sec	core;
-	struct mod_plt_sec	init;
 
 	/* for CONFIG_DYNAMIC_FTRACE */
 	struct plt_entry	*ftrace_trampolines;
diff --git a/arch/arm64/include/asm/module.lds.h b/arch/arm64/include/asm/module.lds.h
index 0c3aea98e116..24fc9401c514 100644
--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -1,6 +1,5 @@
 SECTIONS {
 	.plt 0 : { BYTE(0) }
-	.init.plt 0 : { BYTE(0) }
 	.text.ftrace_trampoline 0 : { BYTE(0) }
 
 #ifdef CONFIG_KASAN_SW_TAGS
diff --git a/arch/arm64/kernel/module-plts.c b/arch/arm64/kernel/module-plts.c
index bde32979c06a..e30876b90e30 100644
--- a/arch/arm64/kernel/module-plts.c
+++ b/arch/arm64/kernel/module-plts.c
@@ -70,8 +70,7 @@ u64 module_emit_plt_entry(struct module *mod, Elf64_Shdr *sechdrs,
 			  void *loc, const Elf64_Rela *rela,
 			  Elf64_Sym *sym)
 {
-	struct mod_plt_sec *pltsec = !within_module_init((unsigned long)loc, mod) ?
-						&mod->arch.core : &mod->arch.init;
+	struct mod_plt_sec *pltsec = &mod->arch.core;
 	struct plt_entry *plt = (struct plt_entry *)sechdrs[pltsec->plt_shndx].sh_addr;
 	int i = pltsec->plt_num_entries;
 	int j = i - 1;
@@ -101,8 +100,7 @@ u64 module_emit_plt_entry(struct module *mod, Elf64_Shdr *sechdrs,
 u64 module_emit_veneer_for_adrp(struct module *mod, Elf64_Shdr *sechdrs,
 				void *loc, u64 val)
 {
-	struct mod_plt_sec *pltsec = !within_module_init((unsigned long)loc, mod) ?
-						&mod->arch.core : &mod->arch.init;
+	struct mod_plt_sec *pltsec = &mod->arch.core;
 	struct plt_entry *plt = (struct plt_entry *)sechdrs[pltsec->plt_shndx].sh_addr;
 	int i = pltsec->plt_num_entries++;
 	u32 br;
@@ -169,17 +167,17 @@ static unsigned int count_plts(Elf64_Sym *syms, Elf64_Rela *rela, int num,
 		case R_AARCH64_CALL26:
 			/*
 			 * We only have to consider branch targets that resolve
-			 * to symbols that are defined in a different section.
+			 * to symbols that are not defined in the same module.
 			 * This is not simply a heuristic, it is a fundamental
 			 * limitation, since there is no guaranteed way to emit
 			 * PLT entries sufficiently close to the branch if the
 			 * section size exceeds the range of a branch
 			 * instruction. So ignore relocations against defined
-			 * symbols if they live in the same section as the
+			 * symbols if they live in the same module as the
 			 * relocation target.
 			 */
 			s = syms + ELF64_R_SYM(rela[i].r_info);
-			if (s->st_shndx == dstidx)
+			if (s->st_shndx != SHN_UNDEF)
 				break;
 
 			/*
@@ -281,7 +279,6 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 			      char *secstrings, struct module *mod)
 {
 	unsigned long core_plts = 0;
-	unsigned long init_plts = 0;
 	Elf64_Sym *syms = NULL;
 	Elf_Shdr *pltsec, *tramp = NULL;
 	int i;
@@ -293,8 +290,6 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	for (i = 0; i < ehdr->e_shnum; i++) {
 		if (!strcmp(secstrings + sechdrs[i].sh_name, ".plt"))
 			mod->arch.core.plt_shndx = i;
-		else if (!strcmp(secstrings + sechdrs[i].sh_name, ".init.plt"))
-			mod->arch.init.plt_shndx = i;
 		else if (!strcmp(secstrings + sechdrs[i].sh_name,
 				 ".text.ftrace_trampoline"))
 			tramp = sechdrs + i;
@@ -302,8 +297,8 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 			syms = (Elf64_Sym *)sechdrs[i].sh_addr;
 	}
 
-	if (!mod->arch.core.plt_shndx || !mod->arch.init.plt_shndx) {
-		pr_err("%s: module PLT section(s) missing\n", mod->name);
+	if (!mod->arch.core.plt_shndx) {
+		pr_err("%s: module PLT section missing\n", mod->name);
 		return -ENOEXEC;
 	}
 	if (!syms) {
@@ -332,12 +327,8 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 		if (nents)
 			sort(rels, nents, sizeof(Elf64_Rela), cmp_rela, NULL);
 
-		if (!module_init_layout_section(secstrings + dstsec->sh_name))
-			core_plts += count_plts(syms, rels, numrels,
-						sechdrs[i].sh_info, dstsec);
-		else
-			init_plts += count_plts(syms, rels, numrels,
-						sechdrs[i].sh_info, dstsec);
+		core_plts += count_plts(syms, rels, numrels, sechdrs[i].sh_info,
+					dstsec);
 	}
 
 	pltsec = sechdrs + mod->arch.core.plt_shndx;
@@ -348,14 +339,6 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	mod->arch.core.plt_num_entries = 0;
 	mod->arch.core.plt_max_entries = core_plts;
 
-	pltsec = sechdrs + mod->arch.init.plt_shndx;
-	pltsec->sh_type = SHT_NOBITS;
-	pltsec->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
-	pltsec->sh_addralign = L1_CACHE_BYTES;
-	pltsec->sh_size = (init_plts + 1) * sizeof(struct plt_entry);
-	mod->arch.init.plt_num_entries = 0;
-	mod->arch.init.plt_max_entries = init_plts;
-
 	if (tramp) {
 		tramp->sh_type = SHT_NOBITS;
 		tramp->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
-- 
2.55.0.860.g4b6b3295ed-goog


