Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327CEC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5D06B00A0; Tue, 15 Sep 2026 02:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCFB6B00A1; Tue, 15 Sep 2026 02:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD0E6B00A2; Tue, 15 Sep 2026 02:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2DB56B00A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:59:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B4381C2216
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:35 +0000 (UTC)
X-FDA: 85215095910.24.177976B
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	by imf19.hostedemail.com (Postfix) with ESMTP id 931891A0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gZHJBhAW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789455573;
	b=2VK3/A7mVM1NOaSAFpOgi7/4hTS742KF8f1Kzzot/tYab3qOjIcTMlrEw1Y5E9fnH/YH3j
	dM8Et6NvKkipmXGwKODd8cuwns3pDt8F5Qd7L6CVcBi54WojV2Ah/FWHncdRmWZlxLuojs
	TBmc8CGpNirUGC4LfPE3tTENgEjFlv4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gZHJBhAW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3WkXv3mFJ8bkd87pdUqIhEnb8dIbLfoygQf6RLxpNSo=;
	b=748Wy/5nQ6DmCMdUNXNMcY7LKlgQqqvytohPSQKAkfkxP5VD4lGXDyp+w4zy3QdkG2mm7C
	XNb8JPaMjALPlcuUVB2i5ZB4KziBioiqALE+dXbwRhCQ5EeOC+/pFpcltj+aYSS8YWB97W
	vGi5RKFQjbLYZ3nnYVTkC3SvAAMjxqs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=c4O0poOXDZAJ+dp5afuegzOnP6NuguXqyzv1RKQWySk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455572; v=1; x=1790060372;
 b=gZHJBhAW4Anv3v5A+AAu5ENXSA6gb6fCjUx7EWLCN4ZpK5wgXJWzjVFsYTZlRInWfG0Idl+D
 vg+oh8D+lhxUXylNf3UZzg3EkFiTBDwvTvEPYVR6pdCcBpB3eNe2yIVanbiF9qrt0LMoDbWR3xU
 qz6PTIXCMqoC5NWPwl8L3OjQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5b16f9d39e75a696;
	Tue, 15 Sep 2026 06:59:32 +0000
X-Mizu-Trace-ID: 5b16f9d39e75a696
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
Subject: [PATCH v10 4/6] module: allocate codetag sections before the regular module layout
Date: Tue, 15 Sep 2026 14:59:59 +0800
Message-Id: <20260915070001.113559-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260915070001.113559-1-hao.ge@linux.dev>
References: <20260915070001.113559-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 931891A0002
X-Stat-Signature: h7xs1akp8qzrrfqiozakkgbmj4yt7e3h
X-HE-Tag: 1789455573-757386
X-HE-Meta: U2FsdGVkX185lnBGAfkxv4BR3hPB/8ceYBODCPAOmumGp+CTNjBUGcpMswTu+QsGOziabkA8RnVPt1oyLhZbbvgxA4hrUzuhkNpoJq+y240wR/OiZ8XFBC/r3mXsEa0TWVWdHB4xFk/aJJwj2EFw/asDP0fdNnBuNlS6sJSbi/fV77XDDmaPHVLsQ2R9PcMUGiUd+/+C0ometX1Qn0sLf3WkPHI0exv086K+EC3Y5ojOZpwMS77EafFrQno397IGRuQZE8Q9uNj2UrwcrinBL5b+JT6CvBhix6kevKoh9j6/Js8HyDQctlbWObCfBZClcvTVF0Ag06Fv/fJDmmkOB+9DHzOVxdfZIKL+riocg2hAMf7/ueA7vqzwKyGXvN5ddv/iA1f3G1a6Q4Zjja9/arIGphjifz1yhgCXIhTbCahIgwxTY390giCs+CJnWu1iJtXH3yMqrY2btEZK8kiGGZktTDrybOFlOcgFiAGqqOTlhmcjyDFLZZBlly5iv5biuaPXWb8MYorBHQvT+5f9+Ext2/jpmDrwCmbA9r4sxsXao4NCKf5xuqVvKzubXo5Xylm1v/fEkg30x4FU6jcieM7hyahkGSp6SuQ4h3bq4VoLLjLxQdeb+MuL0Qbg2fgqinSL/x1IoFzk/a6iS2nFZa6EZjg37ZAdKyiTtwBLL7H8ZlfjBCpM7UQgm0OAzcGAhmZ+Vi9iVGnR1taa1bHQQsPUNBZ/3dTKLePwKOajo3RAsWWxSDFdtC/ipuzdkCHQvEArqlcdFDB2xSeq6bkaalaKRS65lZFg+vE10v57o0HaIiCJmzb34Is39IVdSTSX4MmqB/dX1N9Eyu1h01AqcWW+L7V2gTuNcpiQs+D08pTmhEsfchvirSShZToYHhr7zV4j10kPVMmlxcZKVo7sw8gSONvO9plcInn9TguzdMlYa2bh3p95RYERHhwWS3VpfNxN4C1pI71sx2bhoia
 tf+RxI2A
 6sPGR19RB9gauRZArwfTW16F/WCe+g8nxdZdIKLbwJaHF/AO8CO6gZ+6wLz+28Ojyz3xHwTxHV6NZG6TbKIP5vEXl2h1/ngLSzgfi/oRBlWxYWzKUUp6kunsPU3XbxU0pph9zumvyIUfaZzej8hSW5+LSu7dlyymfJ23htg6DmDljqrUuSua2pRIIRnv0+JLs5eD4sBfxj+zcXeBVbrzly2P2ftX0nVp8Lj/6K9njcuO1VDZ+dCoqMf5x0v7uLCivBoztdojL64FhY162q39TAq0kfytbvxkL1SH+JjCyzcIra9F530ezKBaj/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Whether a codetag section goes to the codetag region is decided by
layout_sections() and asked again in move_module(). A concurrent
load can shut profiling down in between, and move_module() then
copies the section to offset 0 of its regular destination,
overwriting whatever is there.

Decide and allocate in one pass, before the layout. Allocation
errors fail the load. On a tag area overflow profiling is already
disabled, so -EAGAIN makes the section fall back to regular module
data and the module still loads. The reservation is released and
module_tags.size rolled back, so a concurrent load which already
passed needs_section_mem() does not skip vm_module_tags_populate().

An SHT_NOBITS codetag section is zeroed explicitly, the tag area
pages are not zeroed on allocation.

When profiling was toggled off the overflow check did not run, a
module could load with more tags than the page flags can address,
and re-enabling profiling then silently corrupted /proc/allocinfo.
The check no longer depends on mem_alloc_profiling_enabled().

Based on a patch by Petr Pavlu [1].

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 kernel/module/main.c | 101 +++++++++++++++++++++++--------------------
 mm/alloc_tag.c       |   9 ++--
 2 files changed, 60 insertions(+), 50 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index ae2678ac7840..b7ebcc40bdda 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1723,20 +1723,6 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 			if (WARN_ON_ONCE(type == MOD_INVALID))
 				continue;
 
-			/*
-			 * Do not allocate codetag memory as we load it into
-			 * preallocated contiguous memory.
-			 */
-			if (codetag_needs_module_section(mod, sname, s->sh_size)) {
-				/*
-				 * s->sh_entsize won't be used but populate the
-				 * type field to avoid confusion.
-				 */
-				s->sh_entsize = ((unsigned long)(type) & SH_ENTSIZE_TYPE_MASK)
-						<< SH_ENTSIZE_TYPE_SHIFT;
-				continue;
-			}
-
 			s->sh_entsize = module_get_offset_and_type(mod, type, s, i);
 			pr_debug("\t%s\n", sname);
 		}
@@ -2795,7 +2781,6 @@ static int move_module(struct module *mod, struct load_info *info)
 {
 	int i, ret;
 	enum mod_mem_type t = MOD_MEM_NUM_TYPES;
-	bool codetag_section_found = false;
 
 	for_each_mod_mem_type(type) {
 		if (!mod->mem[type].size) {
@@ -2815,35 +2800,13 @@ static int move_module(struct module *mod, struct load_info *info)
 	for (i = 0; i < info->hdr->e_shnum; i++) {
 		void *dest;
 		Elf_Shdr *shdr = &info->sechdrs[i];
-		const char *sname;
 
 		if (!(shdr->sh_flags & SHF_ALLOC)
 		    || shdr->sh_entsize == SH_ENTSIZE_STANDALONE)
 			continue;
 
-		sname = info->secstrings + shdr->sh_name;
-		/*
-		 * Load codetag sections separately as they might still be used
-		 * after module unload.
-		 */
-		if (codetag_needs_module_section(mod, sname, shdr->sh_size)) {
-			dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
-					arch_mod_section_prepend(mod, i), shdr->sh_addralign);
-			if (WARN_ON(!dest)) {
-				ret = -EINVAL;
-				goto out_err;
-			}
-			if (IS_ERR(dest)) {
-				ret = PTR_ERR(dest);
-				goto out_err;
-			}
-			codetag_section_found = true;
-		} else {
-			enum mod_mem_type type = shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
-			unsigned long offset = shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK;
-
-			dest = mod->mem[type].base + offset;
-		}
+		dest = mod->mem[shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT].base +
+		       (shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK);
 
 		if (shdr->sh_type != SHT_NOBITS) {
 			/*
@@ -2875,8 +2838,6 @@ static int move_module(struct module *mod, struct load_info *info)
 	module_memory_restore_rox(mod);
 	while (t--)
 		module_memory_free(mod, t);
-	if (codetag_section_found)
-		codetag_free_module_sections(mod);
 
 	return ret;
 }
@@ -2947,6 +2908,49 @@ static bool blacklisted(const char *module_name)
 }
 core_param(module_blacklist, module_blacklist, charp, 0400);
 
+/*
+ * Allocate codetag sections separately. They are loaded into preallocated
+ * contiguous memory because they may still be used after the module is
+ * unloaded.
+ *
+ * If the separate allocation overflows, allocate the section normally
+ * so that the module can still be loaded.
+ */
+static int allocate_codetag_sections(struct load_info *info)
+{
+	for (unsigned int i = 1; i < info->hdr->e_shnum; i++) {
+		Elf_Shdr *shdr = &info->sechdrs[i];
+		const char *sname = info->secstrings + shdr->sh_name;
+		void *dest;
+
+		if (!codetag_needs_module_section(info->mod, sname, shdr->sh_size))
+			continue;
+
+		dest = codetag_alloc_module_section(info->mod, sname, shdr->sh_size,
+				arch_mod_section_prepend(info->mod, i), shdr->sh_addralign);
+		if (WARN_ON(!dest)) {
+			codetag_free_module_sections(info->mod);
+			return -EINVAL;
+		}
+		if (dest == ERR_PTR(-EAGAIN))
+			/* Allocate the section as a regular section. */
+			continue;
+		if (IS_ERR(dest)) {
+			codetag_free_module_sections(info->mod);
+			return PTR_ERR(dest);
+		}
+
+		if (shdr->sh_type != SHT_NOBITS)
+			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
+		else
+			memset(dest, 0, shdr->sh_size);
+		shdr->sh_addr = (unsigned long)dest;
+		shdr->sh_entsize = SH_ENTSIZE_STANDALONE;
+	}
+
+	return 0;
+}
+
 static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	struct module *mod;
@@ -2979,18 +2983,21 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	 */
 	module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstrings);
 
-	/*
-	 * Determine total sizes, and put offsets in sh_entsize.  For now
-	 * this is done generically; there doesn't appear to be any
-	 * special cases for the architectures.
-	 */
+	/* Allow codetag sections to be allocated separately first. */
+	err = allocate_codetag_sections(info);
+	if (err)
+		return ERR_PTR(err);
+
+	/* Determine total sizes and put offsets in sh_entsize. */
 	layout_sections(info->mod, info);
 	layout_symtab(info->mod, info);
 
 	/* Allocate and move to the final place */
 	err = move_module(info->mod, info);
-	if (err)
+	if (err) {
+		codetag_free_module_sections(info->mod);
 		return ERR_PTR(err);
+	}
 
 	/* Module has been copied to its final place now: return it. */
 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 95ddf5b743d0..5836803898ad 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -958,10 +958,13 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 		int grow_res;
 
 		module_tags.size = offset + size;
-		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
+		if (!tags_addressable()) {
 			shutdown_mem_profiling(true);
-			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
-				mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			pr_warn_once("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
+				     mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			release_module_tags(mod, false);
+			module_tags.size = prev_size;
+			return ERR_PTR(-EAGAIN);
 		}
 
 		grow_res = vm_module_tags_populate();
-- 
2.25.1


