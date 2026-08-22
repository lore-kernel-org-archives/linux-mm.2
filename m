Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C32FC5DF9A
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06B176B00A6; Sat, 22 Aug 2026 09:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7706B00A7; Sat, 22 Aug 2026 09:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF026B00A9; Sat, 22 Aug 2026 09:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6FCA6B00A6
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 273F740156
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:17 +0000 (UTC)
X-FDA: 85129049754.29.FE44021
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5408040007
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YCA2Qflv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3BaqJaggKCNo6N97+CEPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ardb.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3BaqJaggKCNo6N97+CEPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fli+nS6RhVan3nt659uJs8jpsHJEZUSGw+6iw8TgCBk=;
	b=yO4kd9HPxPmg3+qofkTHq7tfO4w4Qdlf9wNYN9HH4RTvB76NzZJLBEf8dqJc4cgqrdoDob
	Tb0/XnFFFZMqjmBDUWMKIJnrU369Gcunr/y7eNMTMl/Zdbblbx1TQBnWyOsav5FsVqHWWp
	TC5vqaB0m5KlusZYyqy5LkMLI+EezIs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YCA2Qflv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3BaqJaggKCNo6N97+CEPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ardb.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3BaqJaggKCNo6N97+CEPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ardb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406855;
	b=gWdu+50eE6RA/H7dFG4BiMhpFSoXR/3+JG57qHXbpwW9LVBPWvIJaFmSE6HRoWtMEmqF1f
	S/wGKPNPUO4dkP4xuhDd1X2LdQWOHlJtg4IBO/6LSDQKslKMuy6Cyq/ZjxJ4xfaFDPkNYs
	2JVXvMxQK3EAs3pMyIGiGQTc9uz3DJ4=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490a767b782so11841865e9.2
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406854; x=1788011654; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fli+nS6RhVan3nt659uJs8jpsHJEZUSGw+6iw8TgCBk=;
        b=YCA2QflvNb9haTgY3nSpadbglHBFlI5+TactjE/qghOuVIWAhzHML3QH6/eUx/EpK1
         6LVS3iC6q8lreiQg2Lx3sfuUF2u9hornuZEnCdXGZlnBK5No4232EeUbYroDwU1ejhNv
         7EbLs0hS+Wis8LlQ8rkxGBgUy+lmDOh9KdY8ljZqr5ylQ3W8zaEMmLC476Y5B2kKZTxu
         /5o6aDwqbi6UI9kopVJ7Ynw8mHfpjzy3FkWI3y2O5CQ9gydkMu/jewJPKLae53OUdV8Z
         /08wZpbHByns0Uuf4KoR+DXgbYwgUzkB+MRJkF8cD892KPqB6KJfegEuj92+KAuZFw+4
         /hvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406854; x=1788011654;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fli+nS6RhVan3nt659uJs8jpsHJEZUSGw+6iw8TgCBk=;
        b=HzwyRtEIVO9RsjRrrg0fkYQyDAFUS/OT0MhFJvti7a80eR6yt5PhjdTJIVV1EduXTi
         CRHExuVwzWmeUVdkrnzjaZ9fkYxBAN7eteMzy1bMceRHzjQzTWRBZcDe/GQReQgz5+K0
         8Ihyqi7BjiUKabtZOV7X/bvsvLft7x+S7l4IS55JzpJSSSqRcCNDvtO8+PSw3+ih54bZ
         Wplm+cfCtKJ6Ewxezuj+g67bgxo32pMpPLURD/iheCdLCtK/dkEeahJvd8UNPjeBfMdD
         OwnrYeaDkUfKfXcvlxFaxeVCsyu4vr1C+bCobmPHm2G0CAdf3YizKb1GfuJcCsUKicsK
         9I4g==
X-Forwarded-Encrypted: i=1; AHgh+Rrti5bBNgPOq1alznqQXADinXkn1TxL2cY+izXakT+jbIcxYgYWGvFKhko9OOeqwaGfV/lok9qT6g==@kvack.org
X-Gm-Message-State: AFuF++lySKv8ku48UN235ianVrOWmUfeUMgLXHuHf7nkxfDjRIptup6u
	GlE97LnzRzWYj4/XWwmgtd74nKNzFKuudC8ZBCO5hcdZdB81rrmWtB5/jmnafTdn9ikjHiaqJg=
	=
X-Received: from wmfu6.prod.google.com ([2002:a05:600c:1386:b0:495:4396:e1fc])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f87:b0:499:5a50:b022
 with SMTP id 5b1f17b1804b1-499b830d220mr157719645e9.3.1787406853968; Sat, 22
 Aug 2026 06:54:13 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:31 +0200
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Mime-Version: 1.0
References: <20260822135323.795946-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3229; i=ardb@kernel.org;
 h=from:subject; bh=E47PSMirXFpI2/XCsflkCaR86s287Dpi3LlkrwYeMZU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIatz5YP+Sf2p1kr7Q6vXvzG479h57WWiGrOK0SxDm5Zur
 rn/05U6SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwETM0hj+xzDKsHPO3dNxlH9C
 0+uIc6a1D/ek6rI+m2n6kfsH+/Iz2xj+xz1lvlS6rabo2mvOz1OevZxXu7UtMFJsxfK5+yQPz9Z 5ygoA
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-20-ardb+git@google.com>
Subject: [RFC PATCH 9/9] arm64: ftrace: Simplify PLT handling
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
X-Stat-Signature: 9ix7iftbbmnkhu7bnka94w8s66r6cm6s
X-Rspamd-Queue-Id: 5408040007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787406855-183028
X-HE-Meta: U2FsdGVkX1+YS3y2OFZpG8ROXgOS53aSjUwerUR9+xEV0Y9q3STtWTIK0UzUc4e0k/OawpNBOMT7/jFpPezTOi+b8RH/22TJxo/G0X8/AF1LpxljnXRERKTj52z3gfsZVWSBUn70Tsl7BRhm/DoIjMcAzkXgY+rbIYKpeya8kIT/FQ6mibfRp326JohHSpdLtBy2s+pz48XYlVYvNxI0tffy79ZQHA9k1ig6Uzv3imOyEN4Fau8/1IrlYCiqD3/g+Sc5SH1Tdo1KUgbS01NZ+T5fsv39KibXan9ubNECcLS9JLYVSkPTW86Ared64ja2wuipZEE7/CTkV31qMx6qAplOaoBdOBEPpGPQXPSENA9I+P/fm+N38Nf4OWRxhKZPdrfrt3GDf36tMio7SmltjwMeUip6TE2mVm6OoWJ4TdJwfXZc5VhFNT9QUr7JCw6JOxfo21IHiegC+2shsxEWiTfXVHORTz7y4cgG4sr21No790p+1XC3gpPFvodrapX3A5J5Tm4Ph1y/ynRYEYxb65loWr1A14XOOGfo19TdKIV1xO/XUER5Yf5pyVrkQQYaxkYZglVan3lTIozd1udzJQSUzq6kDWuukxhnoZ/XDv+0cZuZKM5kDeYCY73firIaaNf67VWOgl+Bq5AvojpNhk2AUjyW1KRQlKS2Uhq2m3YdUKUXkr7bLC58VJ0Fx+edbaM/1H+A0slm13zsptlo+LsT1ia/l3qnx2/ux5u1qCTs8fJCO2E2tAJyCV/hUkCjRmFp6/0yyq3QC80JzALtlzxKG9zM8ZaEOCKyy+yYzKmpkmZ3p5tz2K9XMzYaHxsnL96nYL/zFHYT+Gy7P+Qavn4n+N646ciJv2KcaBrbwuzBMA4943F74JlqRuMPIMwEOzBBOeqNcTUERs/Jvs/GUJU2Xyxt4D3+jgbfvDB7Qv53h149Waf5NVHp5vFVLNsId7iY/Le9t1cPXGbWsXI
 w5VM+Zfs
 skx4GkuJW9jo+fZvjoIDxosKV4iV2vZfIuNFvu4ZWlCkNonyhyXRf4FUmCjhFF+OWHSWz2KlpkRSLzJ1bCkUM1sSLgKaPfaN2rMj7ftI98c6zjDKm7WkK3Ed72N3iueAGHBQowe4mnkDcsBrAw/XkvP4ndd+YoC4MPfs9NkWQvdbleYM6Q9ALfQssVQqK6hpJUwwz+r+gvzTkC2BwvNA2Z4dK8b1NA8xk3o3cQUiQt7XAE1SAeFMp+ZGbdMc+Ndy+g6Ul+iTtpSEoUi4CRYbBnI/ULpeB96is8CDtxMLs8Q0Sdy+7bcXvkzRj3o/ia8O7xD8FxbErNTRVMR6ikXevnOV7L22J4GPTK/nb/+jYrT1Xs/9lNqdNvYTDhyaHGauAK9yjJCrOQOggJ2cb9zBocTs6Yrbjigq3S/20pO9CNwId1fXzQi08wurNmka+sYLZfSF1rmd8390Jke19TDXDLFsZhjLQLqWW1p46alsUBGxyAR/j4f3kpZCRXLsnbOmwrAkWl30mhQUORiRC9tUHIy9pWxoqjRoYYe0upDVV9wplflO/n94HXK06/AdBxaKLhoC2ptAneEgwo0pgUZMnf/vgVjsWiLP0+w54
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Instead of emitting the ftrace trampoline PLT into a separate ELF
section, allocate them at the start of the ordinary PLT array, so
that no special sections are needed.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/module.lds.h |  1 -
 arch/arm64/kernel/module-plts.c     | 18 +++++-------------
 arch/arm64/kernel/module.c          |  9 +--------
 3 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/module.lds.h b/arch/arm64/include/asm/module.lds.h
index 24fc9401c514..95540e956b41 100644
--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -1,6 +1,5 @@
 SECTIONS {
 	.plt 0 : { BYTE(0) }
-	.text.ftrace_trampoline 0 : { BYTE(0) }
 
 #ifdef CONFIG_KASAN_SW_TAGS
 	/*
diff --git a/arch/arm64/kernel/module-plts.c b/arch/arm64/kernel/module-plts.c
index e30876b90e30..6900d2242f1b 100644
--- a/arch/arm64/kernel/module-plts.c
+++ b/arch/arm64/kernel/module-plts.c
@@ -275,12 +275,14 @@ static int partition_branch_plt_relas(Elf64_Sym *syms, Elf64_Rela *rela,
 	return i;
 }
 
+static const int ftrace_plts = IS_ENABLED(CONFIG_DYNAMIC_FTRACE) ? NR_FTRACE_PLTS : 0;
+
 int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 			      char *secstrings, struct module *mod)
 {
-	unsigned long core_plts = 0;
+	unsigned long core_plts = ftrace_plts;
 	Elf64_Sym *syms = NULL;
-	Elf_Shdr *pltsec, *tramp = NULL;
+	Elf_Shdr *pltsec;
 	int i;
 
 	/*
@@ -290,9 +292,6 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	for (i = 0; i < ehdr->e_shnum; i++) {
 		if (!strcmp(secstrings + sechdrs[i].sh_name, ".plt"))
 			mod->arch.core.plt_shndx = i;
-		else if (!strcmp(secstrings + sechdrs[i].sh_name,
-				 ".text.ftrace_trampoline"))
-			tramp = sechdrs + i;
 		else if (sechdrs[i].sh_type == SHT_SYMTAB)
 			syms = (Elf64_Sym *)sechdrs[i].sh_addr;
 	}
@@ -336,15 +335,8 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	pltsec->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
 	pltsec->sh_addralign = L1_CACHE_BYTES;
 	pltsec->sh_size = (core_plts  + 1) * sizeof(struct plt_entry);
-	mod->arch.core.plt_num_entries = 0;
+	mod->arch.core.plt_num_entries = ftrace_plts;
 	mod->arch.core.plt_max_entries = core_plts;
 
-	if (tramp) {
-		tramp->sh_type = SHT_NOBITS;
-		tramp->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
-		tramp->sh_addralign = __alignof__(struct plt_entry);
-		tramp->sh_size = NR_FTRACE_PLTS * sizeof(struct plt_entry);
-	}
-
 	return 0;
 }
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 6e5b488a219e..620c2b70115e 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -454,14 +454,7 @@ static int module_init_ftrace_plt(const Elf_Ehdr *hdr,
 				  struct module *mod)
 {
 #if defined(CONFIG_DYNAMIC_FTRACE)
-	const Elf_Shdr *s;
-	struct plt_entry *plts;
-
-	s = find_section(hdr, sechdrs, ".text.ftrace_trampoline");
-	if (!s)
-		return -ENOEXEC;
-
-	plts = (void *)s->sh_addr;
+	struct plt_entry *plts = (void *)sechdrs[mod->arch.core.plt_shndx].sh_addr;
 
 	__init_plt(&plts[FTRACE_PLT_IDX], FTRACE_ADDR);
 
-- 
2.55.0.860.g4b6b3295ed-goog


