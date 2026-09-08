Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89426C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D9E6B00B0; Tue,  8 Sep 2026 05:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE856B00B1; Tue,  8 Sep 2026 05:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4B56B00B2; Tue,  8 Sep 2026 05:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56EB06B00B0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:25:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D35C28048D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:33 +0000 (UTC)
X-FDA: 85190062146.25.17455D9
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	by imf05.hostedemail.com (Postfix) with ESMTP id CF977100006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rYkOBLKi;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859532;
	b=nKH1zq4k4Sz/41GR5iDY8ssQyNQN9GE0Xlkz5Xr6dtT+9S4APGOf/6Qi89MRtKgO/qhcVm
	7jA3QOHIxmq0jLcONS1LX/8MeZQ5Q5y4tqr+prYsmF3BhkGurLbWa34o1yoT5PUi6oeDiv
	MD4vaSyXUAL/dXBYmGOny5FhqSxznpU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rYkOBLKi;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNEfEweXZSXP4c+go10UMzIifVfn0YdhFJg9pBB+Pdo=;
	b=gXHK75GINESJHB/eFJ11U/KAuUFP7YR3t68tWQsXsIblrP3dQ3c1PXGyqmD4UK+BPXPIdy
	BdWYOjxrMjY+EUnGWL/H8R6Bh3B2pbPww0TR6wg445cSf6YTn/LaXI9hBOXBwFcn3OGiw+
	9iLXaaBwM4Y/ToNc6QVBg9yAj4zVJXU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=w/KB1SsQSsoWxYDHp1kzPPFPoeIu4Zqs63a0uQsIsZg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788859530; v=1; x=1789464330;
 b=rYkOBLKivt11g3GSTJpmD8ijpu5fzzP6KMxIoAORyd/Od/5CtVQPIPr5/IcgJHjZs/MWd/+Q
 5lpD07jtO3x8uqYQckc/y7wn7TxPbE7UUyB32MvVVbNgTc0XG4aPLQsGyOeB58DFp1hKPFtMTIr
 6Mi6lMFIe3hNAx+pFDULnaM4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id da906c699fed78dd;
	Tue, 08 Sep 2026 09:25:30 +0000
X-Mizu-Trace-ID: da906c699fed78dd
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
Subject: [PATCH v9 3/4] module: introduce SH_ENTSIZE_STANDALONE for separately allocated sections
Date: Tue,  8 Sep 2026 17:24:11 +0800
Message-Id: <20260908092412.115953-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260908092412.115953-1-hao.ge@linux.dev>
References: <20260908092412.115953-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF977100006
X-Stat-Signature: pys9ctwksckcg4456ap41oaei4ij1gxg
X-HE-Tag: 1788859531-128624
X-HE-Meta: U2FsdGVkX19ZDmI3COPj1Lcr9o5yCUmC7Yb0djr+2rz1KlfRSpx9T4k4ONv2ACP2g2qsUgECG1wX+ULHeLg0gO6stUimVkrjSIVlREoeQinmw4XopqCL4ongeWUnE+0f7YtZvzGXVR6WTk6Cdfh9G8Kg+hBAN1GXtrun8BsAbpZE9WKMAIvEdIBMy6pqJWbXnMGv9t5gP7+MrHEYbhv/xGgULfv3usuNvhZyu/jBhLwu01Kp/uhKTu2OgeeohuD04IlmJJsMZZbtqcIqqQ3HcBtYc2NKasUJ7Rz274Afap3lJ7mVF2VNYIkJ5a6os2IuJDpTqQ47H9dM/MhXwRDiW209dvNJTEYfbst4q6Y5l+D5+HjPnArauORD8QGVTlZoy5jIrH7NyYjNysHdJNy6s9OeIL4rR+LQjCeSOCfVpGcHo1OOGkej328N7EpAM1vVGhObAIppZPUH1ffv0evYfyKTi8F6s76Q5deXql94hbqg+kXxuCFqIn5m6XhbL7xJOD8FL0j2RS32VuVHDvdRdoDd7FfUza+JZQhH2Pl24prpAb9USAYGoggXlCsYZFvbjYdvYAtd+/by5N1R24P0+2d4MwwI9xYliVzTokICcU7CE3PNRimzM98KwVcLvbDIYq8m1SE4LU3YAaIUGFhv4UTABWGKyfiaKJxCandL2FUJRuwpQHJKxamYTD9LKORDml8UtSVKr8cyASm+8fagq5mmGi1wB+01wEHUrK9l5XgcCeHJvlxyfSuRfS3e/ImS2+HYns5XNBcVl8PiLnwYkw3SzhNoqNHJc/yB9f9ZgBI5I/a/DewxkuxLwbL16hAWb/Wnu39sk4mXTyEe98kE8NRitfjPEHCXAEHP+ZPd4sP2np0DUmXv/0BXA4HcZ4F+9I+NuDPFICeVFOdQYH1JWZydqotAsdxRvnejSVRkxhQ6MsPJk4jTwFbDJecYb+n9y9m3yQxuUsIIaZRD3DB
 bWHMZJjW
 PMZ4HxAHrYFflhOZ60t0UpfqTq1c9muMcPJQj6PMkFawsxZxjzOvkIeT7ESo1suOc7H9Djr0E+T+lduxL27GJAQ2C/Nk+HqPlB3HV81EbSHOiq7doFUOq1vJSFVR1lefl1aUwVAMYVa6g37fKTRV31/wkPyOB/bxFRxJH/CsjwejGq6z7+sarNjVku07U3EcXH5yFkfG8Dos+A+YoyRq6hhgoykMNMVSPFhLrsyBUAgymUExCV8FXY+OaBeb91AG6YyL+vqNs5j4vax37BfCRKMov6m1XbaZoyCJi+qLE85tRUqjuK8euMsJHtI+sWGx1mJQ9DkxbZSMgy4DSqJL3eu5Ay9WU04Kzx0DjTWfnlm8UFNs=
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
back to testing only SHF_ALLOC. Based on a patch by Petr Pavlu [1].

.data..percpu keeps SHF_ALLOC, so it would now show up under
/sys/module/*/sections/. The section has one instance per CPU and no
single address to report, and the entry never existed before, so
skip it in add_sect_attrs(). add_notes_attrs() indexes its attrs[]
array and skips it too. No functional change otherwise.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 include/linux/module.h   |  2 ++
 kernel/module/internal.h |  8 ++++++++
 kernel/module/kallsyms.c | 13 +++----------
 kernel/module/main.c     | 32 +++++++++++++++++---------------
 kernel/module/sysfs.c    | 15 ++++++++++++---
 5 files changed, 42 insertions(+), 28 deletions(-)

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
 
diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index 0fc11e45df9b..49190deae61e 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -76,7 +76,7 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
 }
 
 static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
-			   unsigned int shnum, unsigned int pcpundx)
+			   unsigned int shnum)
 {
 	const Elf_Shdr *sec;
 	enum mod_mem_type type;
@@ -86,11 +86,6 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
 	    !src->st_name)
 		return false;
 
-#ifdef CONFIG_KALLSYMS_ALL
-	if (src->st_shndx == pcpundx)
-		return true;
-#endif
-
 	sec = sechdrs + src->st_shndx;
 	type = sec->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
 	if (!(sec->sh_flags & SHF_ALLOC)
@@ -131,8 +126,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
 	/* Compute total space required for the core symbols' strtab. */
 	for (ndst = i = 0; i < nsrc; i++) {
 		if (i == 0 || is_livepatch_module(mod) ||
-		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
-				   info->index.pcpu)) {
+		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
 			strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
 			ndst++;
 		}
@@ -199,8 +193,7 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
 	for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
 		kallsyms->typetab[i] = elf_type(src + i, info);
 		if (i == 0 || is_livepatch_module(mod) ||
-		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
-				   info->index.pcpu)) {
+		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum)) {
 			ssize_t ret;
 
 			mod->core_kallsyms.typetab[ndst] =
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c32f1d370b73..fc577c01dfd2 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1620,12 +1620,13 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 
 		/*
 		 * Don't bother with non-allocated sections.
-		 * An exception is the percpu section, which has separate allocations
-		 * for individual CPUs. We relocate the percpu section in the initial
-		 * ELF template and subsequently copy it to the per-CPU destinations.
+		 *
+		 * Note that .data..percpu has separate allocations for
+		 * individual CPUs. We relocate the section in the
+		 * initial ELF template and subsequently copy it to the
+		 * per-CPU destinations.
 		 */
-		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC) &&
-		    (!infosec || infosec != info->index.pcpu))
+		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
 			continue;
 
 		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
@@ -1716,7 +1717,7 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
-			    || s->sh_entsize != ~0UL
+			    || s->sh_entsize != ~0UL /* offset or standalone */
 			    || is_init != module_init_layout_section(sname))
 				continue;
 
@@ -1746,16 +1747,10 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
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
 
@@ -2811,7 +2806,8 @@ static int move_module(struct module *mod, struct load_info *info)
 		Elf_Shdr *shdr = &info->sechdrs[i];
 		const char *sname;
 
-		if (!(shdr->sh_flags & SHF_ALLOC))
+		if (!(shdr->sh_flags & SHF_ALLOC)
+		    || shdr->sh_entsize == SH_ENTSIZE_STANDALONE)
 			continue;
 
 		sname = info->secstrings + shdr->sh_name;
@@ -2943,6 +2939,7 @@ core_param(module_blacklist, module_blacklist, charp, 0400);
 static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	struct module *mod;
+	unsigned int i;
 	int err;
 
 	/* Allow arches to frob section contents and sizes.  */
@@ -2956,8 +2953,13 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
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
diff --git a/kernel/module/sysfs.c b/kernel/module/sysfs.c
index 01c65d608873..f64170344e69 100644
--- a/kernel/module/sysfs.c
+++ b/kernel/module/sysfs.c
@@ -62,6 +62,15 @@ static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
 	kfree(sect_attrs);
 }
 
+/*
+ * .data..percpu has a separate allocation per CPU and no single
+ * address to report.
+ */
+static bool sect_visible(const struct load_info *info, unsigned int i)
+{
+	return !sect_empty(&info->sechdrs[i]) && i != info->index.pcpu;
+}
+
 static int add_sect_attrs(struct module *mod, const struct load_info *info)
 {
 	struct module_sect_attrs *sect_attrs;
@@ -72,7 +81,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
 
 	/* Count loaded sections and allocate structures */
 	for (i = 0; i < info->hdr->e_shnum; i++)
-		if (!sect_empty(&info->sechdrs[i]))
+		if (sect_visible(info, i))
 			nloaded++;
 	sect_attrs = kzalloc_flex(*sect_attrs, attrs, nloaded);
 	if (!sect_attrs)
@@ -92,7 +101,7 @@ static int add_sect_attrs(struct module *mod, const struct load_info *info)
 	for (i = 0; i < info->hdr->e_shnum; i++) {
 		Elf_Shdr *sec = &info->sechdrs[i];
 
-		if (sect_empty(sec))
+		if (!sect_visible(info, i))
 			continue;
 		sysfs_bin_attr_init(sattr);
 		sattr->attr.name =
@@ -181,7 +190,7 @@ static int add_notes_attrs(struct module *mod, const struct load_info *info)
 
 	nattr = &notes_attrs->attrs[0];
 	for (loaded = i = 0; i < info->hdr->e_shnum; ++i) {
-		if (sect_empty(&info->sechdrs[i]))
+		if (!sect_visible(info, i))
 			continue;
 		if (info->sechdrs[i].sh_type == SHT_NOTE) {
 			sysfs_bin_attr_init(nattr);
-- 
2.25.1


