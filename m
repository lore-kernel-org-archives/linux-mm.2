Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87AEEC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 862FE6B00AF; Wed,  2 Sep 2026 04:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813926B00B0; Wed,  2 Sep 2026 04:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7516D6B00B1; Wed,  2 Sep 2026 04:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD9F6B00AF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:17:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C524E160111
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:17:47 +0000 (UTC)
X-FDA: 85168118574.21.F5A298B
Received: from mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
	by imf14.hostedemail.com (Postfix) with ESMTP id D3614100003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:17:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IPKrSK4Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrNfC4urpm4/Bp/KbbDEoAnpHqIbNXckguvwrIEtkp4=;
	b=l2Js+uzU1X+pcTC0GMDWzU3lJN0IhMGSHtUxES363F/v/armAFiHWQbVlPXXAO4ZQEEl+Y
	dktpfcbETO/lXyLI/1xXMl2wPvEV8n4noOrIvx2RbNzmC0xwQoRsrpSFlFaQ9yJvXfL4Yx
	l1Jr2xOOXURmqv2+iI5i06VeKxbLcV4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IPKrSK4Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337066;
	b=PUrgw54G6nk3E0aYw8EA1H/mnO1GkObv0qBk4udfxlVHXSdlzfnDg5IlAh7a7SP69Fc3ED
	6KZpXZPyWHS3a5YB6naPy0fweQBHWIHPhVxJ2gREd5pV/SVutRimmhzgW2GI03zDajtLDc
	mLfW5ALLKUMPslvMfcpqhQoXUQfDZoE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IWPG5U0baJXua7XoV+ocXpmKQBCi8RyT3W3FBxO4w10=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788337064; v=1; x=1788941864;
 b=IPKrSK4YEMwYEBse5k1ygRo4w+Wfgc8kHUvH+P3AMu3LD7WzK/bd8TI7CASKsqmMqIJkt/bl
 1MW2op3NprbONpukzKOVeYBqwZlTE29dhrwHNKbQ9kC1gTM5FqLlVcVx3NvXsvL7GQ+F6jyzdda
 wnNraxHtQBQVijt/3GwWksps=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 949a1ac0fa66a2aa;
	Wed, 02 Sep 2026 08:17:44 +0000
X-Mizu-Trace-ID: 949a1ac0fa66a2aa
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v7 2/4] module: introduce SH_ENTSIZE_STANDALONE for separately allocated sections
Date: Wed,  2 Sep 2026 16:18:00 +0800
Message-Id: <20260902081802.146145-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902081802.146145-1-hao.ge@linux.dev>
References: <20260902081802.146145-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D3614100003
X-Stat-Signature: wthtgwo1a6jha4dq6edsrjsx7gopppic
X-Rspam-User: 
X-HE-Tag: 1788337065-335119
X-HE-Meta: U2FsdGVkX1+fzWy2/lw9mqUJ4jCTX02d6V6lmrHKC+zzvkHoKHUwd2LfpPahWkD5miuC9WSC2CKQ5PF7JmK4JqI1jgWsbQl++Yx7Gqhm81CnRE3/rJ/wxTk9bOZtFdrlHlsBA6S+V10/Fqyr8FZwA1FTGFI4Lph4GvfXJ/0vubhZT4+24/17Biid1euM0exZStGy9pkj0FAiqImbaRb7mDtn4d/pJZUL4PMYaCLNiKL49fj6lbGvpNs131KTZ7Tfhfcebqzd5yC2gguNvty07G1iShcG0Irm2g0le03LLsNz/GFifb/SpebVVEC+hJQzkd9iS1lWvgwnXKYZvwqDDtP3dZ9x3L6XpeazwLcMa+beSbZxBSeL5/mzQxfLFx9bfH009t4N98tIulXqSNECpri56FKrHKpN8Q/MJs4kY+9IuaiQK93kz6XTPHwkXppwbou51m3+Zs2EXP+CHREBdVxAdj0I2lO4Wc9WeHcqQQxO9O7Bn+a8qWAXENIsS16Pm+EuDgxi/wLo/gPrGJ1XllYDYbbligmX9WsXudzJAXCHHTQ2JOuCmopoBRHrNPvz6jn6SVA1RFGni7CaVHgBNNEF191eiN28VUHiwpiNGDAEjfXqgJODyZy3s0GsU67nEhFKKYhi0azcAlg9GtOxuw+cZ/I1GEfMOCBASn1vjT7lw5VAZygGmVW9SJO1G3c9T9dzsVY+mzTtGqn5eO2BtfAoLyboewKzoy4JRW0Fqv0iuckjrhMnBjGVa0GQS/QyvBn/1QFqHqSwgF6NzOkGPiSGYKDuZz/lJMdMm90JlnWbCd9RN7qa2CGaQyjwwmpFajkcpF8+4S80irPGVFB/3BuFcwcGGBj0vig7RsLEVI5YypogQnhog0lQqswD/uyRkgshx3Ec4xh6Hf44MXuzqO7CwXDjlZxGw8OcnsXVZ8Cghajl8h/pwmFoDai5NwFaVUREVqbyBXQrGQ2lDwR
 QUgZPFLI
 nR2xvH+Mh+V2x8VfGSjIHNcPh9tJIQKevzrx3s0PmZpsXxbjyQy0BtBTSsdk3mwAZ5W91gMfKPjvihlTb+hI5kq6RILWrMBRJwqFYQ9AoupxLSLHrjvQ/ELyTHSwJ/MXYErahmPxedkKaClXWRPGba2lKvo9guVHbzuG7DAZ9xRnvH1IBxgJeYVN/jQuPgXFmOOYpBoed1M/vOO06RqCNwfR44ECCrfHfT43PCzHtTZdxP1gwPGqjX2zfY4lksu5EFzcJmeqX6Y4/BylZbeLEpOJTVas0OGDFKaO5Mb+okVD6EsP/CSrwj39vioEqFc0yQQnD4IoVGCS5BOZoXHgzqG4fWYSWtaa7Bu6c40YsaAMh7Xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SHF_ALLOC means, per the ELF spec, that a section occupies memory
during process execution. Some module sections occupy memory
outside the regular module layout, for example the percpu section
with its per-CPU allocations. The loader currently excludes such
a section from the layout by clearing its SHF_ALLOC, which
overloads the flag with a loader-internal meaning.
apply_relocations() needs a special case for the section, and
find_sec(".data..percpu") returns different results before and
after layout_and_allocate().

Introduce SH_ENTSIZE_STANDALONE to mark sections with a separate
allocation. The percpu section is its first user. layout_sections()
and move_module() skip marked sections, and apply_relocations() goes
back to testing only SHF_ALLOC.

No functional change intended.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Based-on-a-patch-by: Petr Pavlu <petr.pavlu@suse.com>
Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 include/linux/module.h   |  2 ++
 kernel/module/internal.h |  8 ++++++++
 kernel/module/main.c     | 31 +++++++++++++------------------
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 7566815fabbe..33548daa31a3 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -325,6 +325,8 @@ enum mod_mem_type {
 	MOD_INIT_RODATA,
 
 	MOD_MEM_NUM_TYPES,
+
+	MOD_STANDALONE = -2,
 	MOD_INVALID = -1,
 };
 
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 061161cc79d9..4c738074a27b 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -29,6 +29,14 @@
 #define SH_ENTSIZE_TYPE_MASK	((1UL << SH_ENTSIZE_TYPE_BITS) - 1)
 #define SH_ENTSIZE_OFFSET_MASK	((1UL << (BITS_PER_LONG - SH_ENTSIZE_TYPE_BITS)) - 1)
 
+/*
+ * Marker for sections with a separate allocation, which are not placed
+ * into mod->mem[].
+ */
+#define SH_ENTSIZE_STANDALONE					\
+	(((unsigned long)MOD_STANDALONE & SH_ENTSIZE_TYPE_MASK)	\
+	 << SH_ENTSIZE_TYPE_SHIFT)
+
 /* Maximum number of characters written by module_flags() */
 #define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
 
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c32f1d370b73..078dae188aba 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1618,14 +1618,8 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 		if (infosec >= info->hdr->e_shnum)
 			continue;
 
-		/*
-		 * Don't bother with non-allocated sections.
-		 * An exception is the percpu section, which has separate allocations
-		 * for individual CPUs. We relocate the percpu section in the initial
-		 * ELF template and subsequently copy it to the per-CPU destinations.
-		 */
-		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC) &&
-		    (!infosec || infosec != info->index.pcpu))
+		/* Don't bother with non-allocated sections. */
+		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
 			continue;
 
 		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
@@ -1716,7 +1710,7 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
-			    || s->sh_entsize != ~0UL
+			    || s->sh_entsize != ~0UL /* offset or standalone */
 			    || is_init != module_init_layout_section(sname))
 				continue;
 
@@ -1746,16 +1740,10 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 /*
  * Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
  * might -- code, read-only data, read-write data, small data.  Tally
- * sizes, and place the offsets into sh_entsize fields: high bit means it
- * belongs in init.
+ * sizes, and place the offsets into sh_entsize fields.
  */
 static void layout_sections(struct module *mod, struct load_info *info)
 {
-	unsigned int i;
-
-	for (i = 0; i < info->hdr->e_shnum; i++)
-		info->sechdrs[i].sh_entsize = ~0UL;
-
 	pr_debug("Core section allocation order for %s:\n", mod->name);
 	__layout_sections(mod, info, false);
 
@@ -2811,7 +2799,8 @@ static int move_module(struct module *mod, struct load_info *info)
 		Elf_Shdr *shdr = &info->sechdrs[i];
 		const char *sname;
 
-		if (!(shdr->sh_flags & SHF_ALLOC))
+		if (!(shdr->sh_flags & SHF_ALLOC)
+		    || shdr->sh_entsize == SH_ENTSIZE_STANDALONE)
 			continue;
 
 		sname = info->secstrings + shdr->sh_name;
@@ -2943,6 +2932,7 @@ core_param(module_blacklist, module_blacklist, charp, 0400);
 static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	struct module *mod;
+	unsigned int i;
 	int err;
 
 	/* Allow arches to frob section contents and sizes.  */
@@ -2956,8 +2946,13 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	if (err < 0)
 		return ERR_PTR(err);
 
+	/* Repurpose sh_entsize to track where each section is allocated. */
+	for (i = 0; i < info->hdr->e_shnum; i++)
+		info->sechdrs[i].sh_entsize = ~0UL;
+
 	/* We will do a special allocation for per-cpu sections later. */
-	info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if (info->index.pcpu)
+		info->sechdrs[info->index.pcpu].sh_entsize = SH_ENTSIZE_STANDALONE;
 
 	/*
 	 * Mark relevant sections as SHF_RO_AFTER_INIT so layout_sections() can
-- 
2.25.1


