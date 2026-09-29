Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A96B5CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA5C6B00AC; Tue, 29 Sep 2026 04:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2086B00AD; Tue, 29 Sep 2026 04:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B82C6B00AE; Tue, 29 Sep 2026 04:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 663806B00AC
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:20:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD46F8042B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:20:17 +0000 (UTC)
X-FDA: 85266102474.09.2A3A92E
Received: from mta1.migadu.com (out-114.mta1.migadu.com [95.215.58.114])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA9704000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:20:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rDC+m5qf;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.114 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppmj5TTO4y6zokgfeLvbBh/33FIu/9bwzAQrOsACU74=;
	b=5P50dOgLiKcIXZDX84DhNZLeryY/c93+s5pSdvSymKZSFJPi+wowtiR6ryGq5zn7j1EBFu
	OCdZBkYCLttgGpiVyjZibhCMJh4LVKSVupIf+z+LiG2PtH2Iw3uecX3L9dEt37yFqzVnVc
	mQ37QE2n1Bnac2p789npXG+S75+DEBk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670016;
	b=V2e61urUbY2ZDw90a4CSNXgsb2wYyb95cjwXuvAOI8GpIfaDBC06Z1ksk52ABbXfIGncSG
	fdkmnfk10wrHToOQz/vuvVR/4RqGiQDYxOkdtmqFmWXHXk9QWPB+YT+Kyig7oZxXqUFfGI
	LgwYp1jvB5dwMBsF9165gt/o/VKFnHQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rDC+m5qf;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.114 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=McBvav1PmpTZW1Oc8IEUHTnfa7I+sXWLfxcSkA46+9k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790670014; v=1; x=1791274814;
 b=rDC+m5qfVw/rruL8Z3VESpJvPbPDN9auioAlo+o6KFIP9RScKzppywa5mApXppszL4JrjHnG
 CJb8j33z2gD60QRH5gMrsqzuhtAHgQyotTXCakPXADkGGfaHojJrLtQ5G1FbRdR45zN3P+si4H3
 UHCEuNt7K6f4rf2Iduz2ZdtY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fff4609c831d6a5a;
	Tue, 29 Sep 2026 08:20:11 +0000
X-Mizu-Trace-ID: fff4609c831d6a5a
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	=Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v11 4/7] module: introduce SH_ENTSIZE_STANDALONE for separately allocated sections
Date: Tue, 29 Sep 2026 16:20:11 +0800
Message-Id: <20260929082014.160587-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260929082014.160587-1-hao.ge@linux.dev>
References: <20260929082014.160587-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wtku6kfnhib9ubph46iwnwniyrfmbkh3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EA9704000A
X-HE-Tag: 1790670015-610663
X-HE-Meta: U2FsdGVkX1+puHnzPRdXU3TuxCIrnrCNyTQJpCr60SjHXn8Vp4mUEf4eSQ510Q2jsa9tO7+Vk3OvI0ywjpbh61oOjAkT3mcCajNmkb0prN6Gckx4J5OgILw/Lc3IPvBqma3fDmOufQbMOsMt1d5xQB74MZecyK+Ufjx1k9norIysWl937bBcMuOBut15ZdUiqXtWT2pYVKc+JSEioB0M7oSgzdM0ssS/FAj/WMnFrxCPmGsPlw2RtNvTYNf2MBb8Gd9BbdGmkPugCd8Dsy71MS/YWy71VPDa6e28aN+J2qsGhtw1jJHib9p0je3mpG/uQi5Ik6bEzWhZHe9HxM7+MLoDFgl/iVcTzzvjlM7oQrpS2EmMtWmgTxtQYKWj7N2CLCmGg6nw2WcvUVEyVmGVWQ4vyFA30sACbcxz6PXUwwLCwRjdRX6wP4FdkoQOBz+hbC2ZikvnSpeAp+k8zuc3paaxk0hPW/LQAyjtuqeLHzX+71dM1BM9iUZE506iBL7Lspl6y37gYo0fESL2ALr8QlsGtDnsxNEyE544YUZe5c7UtPRHWjnIZ2BNpzpwOwCwGvPdWfDwQAQdJC63soht/e5nFhTlde46ApbiJxYXHTuNxPII5OkhGp35HH5z4ApoJQHMdwg+7mU6tyFzCawstPQPLYpYsFJqWvAdqYvYQ0Joh2YOFo5/LF0H877A3YZslabvnFfRIyAjzoVy9J6mTHYxyGSnIfHYDrtXKC3QwCafvViYlK48RDQg1b2oTLqCiY8nhL9AkWft0cecLOnrS8qVeUKfHgL+Hflc+g0X6vUmbiHJUx3pIZidQrlMlSklu75utKPvuWw5DdAGqydwPCsffic8nYVx3DZ/QyqGvg/yPFh2Hl5k4PBOVttnMNy4Y0ROJSrI4t/hvvSk2752oMscMgWjmWHPIHknl8AuEi/xQTBycKTH4sHx7t2QDedy8YndMjk7JftEyNln8MI
 gRGUVLsX
 nRltgexFBHcx7Awbd5LMJ7amokcahZ9Z6Jg02OgYAMtuEynzfpZdWGMFe9ke/ZVdntRCnE591960JMSNZ552BcRVNy9i49lzngLEwdpEuEpfRDRvr7xbs2jCI14p4VaFVAEAP5R10l+u/gREdEZQB9HAD+T2iq4vlc/vEd3rtGR11/A8k1GeZDIOgBXrxMPNbq+zu9Iz1sgXZwO9g1AXGb51lkJz8nQDHD2Bfqb4wRIr/0ZKkoYDnPWpVl2IuwgzFb4NN8wFPXwftLynQ4rmiuMbK7VYfZZMsIQJYp5THwsn1k1g54Zg4rNXxZq5KdvlEOp/O2T2EqP7pXU62D4SueEc8bYR2l+bcUa2qiCutt8yTbLV4tq/Hl/9noR6//tl+/YnT
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
array and skips it too. No functional or userspace-visible changes
otherwise.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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


