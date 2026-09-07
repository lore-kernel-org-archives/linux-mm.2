Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF864C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7BEC6B009F; Mon,  7 Sep 2026 02:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2CB96B00A1; Mon,  7 Sep 2026 02:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C326B009F; Mon,  7 Sep 2026 02:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77A396B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:23:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CB701405F0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:38 +0000 (UTC)
X-FDA: 85185974916.03.B9CC3C3
Received: from mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
	by imf29.hostedemail.com (Postfix) with ESMTP id 169FF120004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q2z26p0J;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.62 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788762216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+hYpsg/V6pxMEmMjwieCD+2qOb39PV5PJYdtHm/7Wc=;
	b=CF0g959+E3Uuzzx95lFWoj5ldFiy3U8FHcFHuSehsFsQl4Mj9qIe+l84POlTY7mEE2zBiB
	rUh+zap3gGEIpBjje/1zJBM7HWiOeG2u6qj3cZbM9qKRw65FSS6A3Zp+SPlFmtN0e3mx47
	rpyU4yGwylKUBnzuO7pb46UslguetuE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788762216;
	b=tO9FRpn1utBeUKjswHDJSBOW3PFcx4/g5JlSutOsVzOAH31J3Uc59Wm2p1ZE+VumHMK1Zu
	4Kq3uKaVKmtn8qfBGehEuiQaVbubxnQxTFQbvt+yvV8MH3ar1oqtFtwvBHoZujQs8Elv33
	jTmXqk4qSIhT2KJT2F2maw2dp6UE6eg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q2z26p0J;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.62 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=W54UFCGSSmwPyS5+O/eCDyT8i2/f/U9GJTv7sexmrHE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788762214; v=1; x=1789367014;
 b=q2z26p0Jf3bjp3A6wUJs8UbU99dI8imvyofo+dNgfSw9/t6l7sabLv3F5vyBKe4FyuP602so
 zdZXDxLPOfbkAxp2SW/YiYWpF5FSTZOjN8BpCV4xkEOJsi+pNU2GRVhaf1n59dwYY3AHBsuZByA
 beiBQW1gGpB8OxYe8DhELbtg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 20bcc22c11472e28;
	Mon, 07 Sep 2026 06:23:34 +0000
X-Mizu-Trace-ID: 20bcc22c11472e28
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
Subject: [PATCH v8 2/4] module: introduce SH_ENTSIZE_STANDALONE for separately allocated sections
Date: Mon,  7 Sep 2026 14:24:11 +0800
Message-Id: <20260907062414.106873-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907062414.106873-1-hao.ge@linux.dev>
References: <20260907062414.106873-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 169FF120004
X-Stat-Signature: x1mbb1xpx6jc4bzfnah9xrr5frai4i4x
X-Rspam-User: 
X-HE-Tag: 1788762215-631371
X-HE-Meta: U2FsdGVkX1+Wvfbs3cVDdchXWfj+a2dEmK/clhN8diz/p2B/t04iAJ6Nl1TjD07JV4iQ/89IKpZZutzaHGIem8ubBkFf5FJmVaiv/oHXeNmZEWZcTltI879f3oCy7xouHvM+dU+agkHL8DYPPdI2fCvSc0J6Wyfs6NAgC9q8rXfet/btA6pOY1yVu266FVLhbN3KL03SjCjlNAAYdhVaYqdK+C2uNGtnLzs5F6FUhje0Y4gpAg6zHeP3Q8lSjVfcQGQ0/K7ZJIk2yqP+djklITNSTWArRnPFevVcT3OfwIB6jidSTiPiRyLHHviVftZ1FWDmIvMO96O5c/5TjbQPGC4yY+d/EqK0NA52bvK8qyJS8rX1+xdQZKBHNT0UaCGG4GwHOgQWMiFzhNFWwj9sPJMSb6LLocJc0JE5JQz2rFxcubWZxT+c+O0ZG5K/NXyYPEoRCiM75bN+CWAk2P8HdgGz2QEU7DXBOJBMRmyH3rCAs78RagtcWPdxsakbUOmsDDCge0M5xZTqCpJrCIuTFlwfLnENyhU5dYxdtN6Zm+1SH5vDbJnKz4WKJTzthiRFh1618c1iL2CbtFejPUpT5/9sCqr2ioqHyR75+QSKC7uLo1/h3wwlehteO6s3lSmgjx0z1UhSgw2pbRIW83G+K+fItxJg5kUwvNaSGfg33/v7Z5paTZFXybTDVje8VffjL98XAJXD2dhKI7pwmKmP9SlvK+zkkoCQ+20e2g9ztz0w1B5NQlNAnJf+7zR6lp0vCH1iijq0bYB123WO9bET2IDBlKHlM2Qx6YBNp/f9861d+E29F6Er83u8cvk6eAPN+v+C+vaJ8KJuqj05lHkw8xQsWA54Fjlsyrc9YEr5qWTyfH2YN5KgFOK6uQD8i0gGOw5eg8VEW0leeJWMFSGYM+l4mQQPDmEKXo0uziVSQhszdBJvCINIUYf2SdgRre6RwG0WDPZVMPbfjkTCts+
 mBSZCKLN
 8t3D3kpGgwAv6sn0g52PERqSlGxuseVvR/TaoWrpNWcUdEXAFjQiw6KoUM7Hm1EImmnquy311ANpkoxA5xXnIdglfNqGxw+jKu166n4Zo2P1gbilpRryRwkVPH5CdqPvMtddTAOv1NXofjD5FcCisjBsk3XcsLlF+xAVmcssImDkLgL6Gdw248L8VmLOTNhTk8TNSJc5t3RTVtEJxMaHf9ixwAmf0cBi8P1M62wmmlUpJgsz3KoqdOYEGj/UjxYPNGuTdUoReCrfxGgQ7xgbuQcDxUPzVjz40LSF0h194D489WuMn2gACZ29MsCMeey8XaERVnIO99narh/8p7fF3aNVS71q/F9B9TlFyjon5Y1EJunE=
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

.data..percpu keeps SHF_ALLOC, so it is now exported under
/sys/module/*/sections/. Report the boot CPU instance of the
module's per-CPU area there, as __is_module_percpu_address() does.
No functional change otherwise.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 Documentation/ABI/testing/sysfs-module |  8 ++++++
 include/linux/module.h                 |  2 ++
 kernel/module/internal.h               |  8 ++++++
 kernel/module/kallsyms.c               | 13 +++------
 kernel/module/main.c                   | 37 +++++++++++++++-----------
 5 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-module b/Documentation/ABI/testing/sysfs-module
index d5b7d19bd310..65e152c6fa58 100644
--- a/Documentation/ABI/testing/sysfs-module
+++ b/Documentation/ABI/testing/sysfs-module
@@ -57,6 +57,14 @@ Description:	List of symbol namespaces imported by this module via
 		This file only exists for modules that import at least one
 		namespace.
 
+What:		/sys/module/*/sections/<section>
+Date:		June 2005
+KernelVersion:	2.6.12
+Contact:	linux-modules@vger.kernel.org
+Description:	The memory address of the given loaded section of the
+		module. .data..percpu has one instance per CPU; the
+		address reported is the instance of the boot CPU.
+
 What:		/sys/module/*/taint
 Date:		Jan 2012
 KernelVersion:	3.3
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
index c32f1d370b73..20b85148ad72 100644
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
@@ -3520,6 +3522,11 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (err < 0)
 		goto free_modinfo;
 
+	/* The percpu ELF section is a template; report the boot CPU instance. */
+	if (info->index.pcpu)
+		info->sechdrs[info->index.pcpu].sh_addr =
+			(unsigned long)per_cpu_ptr(mod->percpu, get_boot_cpu_id());
+
 	flush_module_icache(mod);
 
 	/* Now copy in args */
-- 
2.25.1


