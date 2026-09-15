Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9176BC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2746B009D; Tue, 15 Sep 2026 02:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB0F6B009E; Tue, 15 Sep 2026 02:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0757F6B009F; Tue, 15 Sep 2026 02:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9E3C6B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:59:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 553A2160313
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:28 +0000 (UTC)
X-FDA: 85215095616.25.689F051
Received: from mta0.migadu.com (out-127.mta0.migadu.com [91.218.175.127])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E385160003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eX8qA/FQ";
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.127 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wa+uG71bUlNto16Q9Z6YwT0Okx0y3zn6noS2Oo19nOE=;
	b=3m7Lw4e91AA2Cd9c/g4fVS2Dv5VbGYitV8P/zc18sGUcyVjSryeCSQAI8O6O7ltbowP5m1
	8KvH4LOl6oLfv68o8uM6hVwhGRQRrk6PWhnL8YFQGO0ZXCdS9siRFipBeP2Pkb0jGXuoFc
	5igLStmxiKaBZ316HNxKJHpkb5U24Rc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eX8qA/FQ";
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.127 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789455566;
	b=uPzIIdFzrbFuwFM4CA24lyIt8tGUmBJVo3OlbraMMTHN/erta8+UtVj0BhiqYZ8EFcjEKM
	2E9aAZAqZmqD8j93RApsKA/0WYluZ96p7syFS9WfUqRbGfVoKSp9j06thhljCLoV/OUtnZ
	lc5v/CGhzQ0/lCPRAdQikpxmluGG3Q4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JlOTHViXIUCNUHaVGMaJ96xltazLuZ70o/39P8cGYqY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455565; v=1; x=1790060365;
 b=eX8qA/FQMAqQ1y9V0POhTCcGwZthmYQxTlnAsZJG+OaRuI4+ogmno1eG/AV6dDSEY4RyeKes
 lHjiOaxfYJlV5sAYxPByFS4RKMlAWHXhGl+P1cpNjm626+qshAIXbAsfQEqlvki4Yh6+yCc2TCl
 iqEQF3zM0n/R5iCVaBawJcoY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5cc9afbad426c8d5;
	Tue, 15 Sep 2026 06:59:25 +0000
X-Mizu-Trace-ID: 5cc9afbad426c8d5
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-modules@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v10 3/6] module: introduce SH_ENTSIZE_STANDALONE for separately allocated sections
Date: Tue, 15 Sep 2026 14:59:58 +0800
Message-Id: <20260915070001.113559-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260915070001.113559-1-hao.ge@linux.dev>
References: <20260915070001.113559-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E385160003
X-Stat-Signature: dr9eedk34tkbgpgxky9rjz4k3eby11qo
X-Rspam-User: 
X-HE-Tag: 1789455566-356736
X-HE-Meta: U2FsdGVkX1/8ra/DEJatAp8YAZg1SnErHEdkQzQBjQApUeZxzzRi7TDUw2OYdIPkoyKl7/ifYglxgiH+ksJ3XEdhvg0Ij9wREm5eqwZIU+j+T2llBgNy6hljSIjG5giIFd+E8eH8Cf/WF0y7ZImLUEwYHdUlSkFFli25mCWC8Ybp2PBj2Ioh5S2peuNNZBrZFkrcLpNyF+wCyMTk4Ojmzxi6D15JLwQf6pthwo/mp9L4oA+UYzpR2VGPXulXLHq8mfK/AJFAHIU1oyA/9UFwpFkL+w6zLiUu9jFEXcq/5ZAcVR6VeqC754nb4nJfzCgQxoVXHhZrFrH2zygX1Pxr3HUSaxHHJFyn/xoy5trnbqH5Ddi/rmDy8welxgdpvtrYZ/5qOhyIDvE4+PUsfoBjLYAcD5xupG6HwtfSJ/sZ6sP3fVtv4ymJZU4sT6kehUFnUR27ccXZ95ZsF5QH0cncPzTGA/kSANBcPBiHLL7JzuKNKoFzqzDMPJ/Cgp2WEig2NZO4HgQveZPw+fqSYRQWKVvoaO6OFtj5iBnVgiulXjvIRPR5koi0mFGk/zosfvCvOhTcA72EcspVWmav2ulfRMCnavybpNmMJf9YytN3HdBW7KzhqbtF5ZeeDME09m7C9iBLs/j4lzLRMtZNK1znR9w89V0iq9Ko9WtfgSZvA6JzVd94B05eHh5rws/3Mlf7BdDKG8Z/+u5mGtuQwdBVRocXgPDXTG2ciy5BH0FNhDh8AASFPZK7G0bURurF2GF8Ypc3Uv4XKvIXyx6cHvOhmZnqbb13ZXrR+FaCGYnApDhOAMQvLr8jWzs0V7DwpNNRyQNqHc76dJi84zyMQ6pniMFxgqTDWZf8b4sZjG8gU1jajykS0ThKYEfcpeujiQL3UlQIV2bPfjPjqXIIKhuJ0BKTA5k3Dx2xN2eGYDoAM0RL7zUkBEvLiL5hED3MDEOOpvPo4dqmyTEpX09gepc
 zOiqJUJ5
 vz9RNxbJl3cIMgXQ1COf5zevacTz9rdQh15ZXFumjJugR+tc3ueMLizrT2osDZZ/pw+CYTaH5R89e6yvURogQGRn4G/GW2uUbURpQFgn9b5v98M00s9LC8iASkAQdrf6PHI2J9oWt/KyZp/BaO/71dwrqNQelQmEQynt4HNvh8W9QeHBsGG4ftUfPQRl2g0c8V/DSjCOOEJkDC0Zzab9Csh5wJMnvKe35RarAV0nM5iFoBlZWhdvdkX3Y7WJ3D7PyzodIMxJz9wMWvBkC2OuMwGoCAYn12ij96K5Z66QVsU4sAw3EQCzi7CiYmUzA+qsa54aNAPOxb0EXbyIOzMwWZMMCcNQ2yhPVQ8thg58N8Uj04pY=
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
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 include/linux/module.h   |  2 ++
 kernel/module/internal.h |  8 ++++++++
 kernel/module/kallsyms.c | 13 +++----------
 kernel/module/main.c     | 32 +++++++++++++++++---------------
 kernel/module/sysfs.c    | 17 +++++++++++++----
 5 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 96cc98568eea..0c6f32ddcbf2 100644
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
index f23126d804b2..0dca6d40160e 100644
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
index c1b34dc1e89a..ae2678ac7840 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1619,12 +1619,13 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 
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
@@ -1715,7 +1716,7 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
-			    || s->sh_entsize != ~0UL
+			    || s->sh_entsize != ~0UL /* offset or standalone */
 			    || is_init != module_init_layout_section(sname))
 				continue;
 
@@ -1745,16 +1746,10 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
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
 
@@ -2822,7 +2817,8 @@ static int move_module(struct module *mod, struct load_info *info)
 		Elf_Shdr *shdr = &info->sechdrs[i];
 		const char *sname;
 
-		if (!(shdr->sh_flags & SHF_ALLOC))
+		if (!(shdr->sh_flags & SHF_ALLOC)
+		    || shdr->sh_entsize == SH_ENTSIZE_STANDALONE)
 			continue;
 
 		sname = info->secstrings + shdr->sh_name;
@@ -2954,6 +2950,7 @@ core_param(module_blacklist, module_blacklist, charp, 0400);
 static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	struct module *mod;
+	unsigned int i;
 	int err;
 
 	/* Allow arches to frob section contents and sizes.  */
@@ -2967,8 +2964,13 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
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
index 01c65d608873..15c6baeb39c4 100644
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
@@ -159,7 +168,7 @@ static int add_notes_attrs(struct module *mod, const struct load_info *info)
 	/* Count notes sections and allocate structures.  */
 	notes = 0;
 	for (i = 0; i < info->hdr->e_shnum; i++)
-		if (!sect_empty(&info->sechdrs[i]) &&
+		if (sect_visible(info, i) &&
 		    info->sechdrs[i].sh_type == SHT_NOTE)
 			++notes;
 
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


