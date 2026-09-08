Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA0FEC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13FD6B00B1; Tue,  8 Sep 2026 05:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2766B00B3; Tue,  8 Sep 2026 05:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D156B00B4; Tue,  8 Sep 2026 05:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B08D6B00B1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:25:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0439C1C23C3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:36 +0000 (UTC)
X-FDA: 85190062314.26.1DB1C4E
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id 181A5C0005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PEZ8PJjb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uObQw523iPG2qY1T6ObnyPv0fZe5VfPihBKb7Gn56wU=;
	b=sEj18XR6YbaFCq0sMa5fB1eSeK8ZkcK2TjEbs1quIuBRckbyOkvV1gamfDqblBBOday2ZI
	UKv4ZYwy/PqoYq/ZhjAZKfdQGaXZigmGpqnBbwLsgMwSMb/ROe9AuMWOj8t2UgHWXaUONK
	EMweDx0HE/W9R/wnNKUqC7WdpMgUFD0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PEZ8PJjb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859535;
	b=WgStrkmBO8LzfOqLIPQdOMHyKcK2y/aL7yCv19m4djbzdxrafEjA5sZogiaZDmUTVvzwGv
	nNm1x8h36MQAyWivVWJbFeUjqZjdrL2YHqvptcMapNXZxaoQTqqo6vrIluLVQBjDbhWNRw
	5bAQ4BMo4rM1YyvhXJf68dESMuh6Z9s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KRpwdv0Ik6eghF0NQ+wLMkFshij8x/0D3GA8MdrghsA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788859533; v=1; x=1789464333;
 b=PEZ8PJjbmnbstFzOJjdVnR4na8OjjuWVCzLOYTpiG8KyUKqTIToi/nQrIEKZWmYnd0OPse2c
 DZSZUePIYHxRP6cUaE2hBtl2LMxNnGvQaOO1uxcn/4LQBj1bqhqXlA3pOPbrXGLibNc7CQIcNKn
 NstLvxXfITPX4tipEVwz/qJk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id de3ac1b114ad648f;
	Tue, 08 Sep 2026 09:25:33 +0000
X-Mizu-Trace-ID: de3ac1b114ad648f
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
Subject: [PATCH v9 4/4] module: allocate codetag sections before the regular module layout
Date: Tue,  8 Sep 2026 17:24:12 +0800
Message-Id: <20260908092412.115953-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260908092412.115953-1-hao.ge@linux.dev>
References: <20260908092412.115953-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 181A5C0005
X-Stat-Signature: p8cafascihczxjeewjka6bkat8grcm57
X-Rspam-User: 
X-HE-Tag: 1788859534-494024
X-HE-Meta: U2FsdGVkX197agr5N+q0a8TNZoDgXofgIak13A1u61+WNPQHmXK97u8ZMH+fACyHk5Nbby6Yj5KmAReeL4BPkPmNBcOPwR8eAB3WZqieTuFtRDVLwkMa0cQ6/WcdI/s12ZJrTyuEvfm0RhpPhVJDhM23ZpDqpLUXlCAU5/Iv0fHu+osgtX8z4lwzLsIcsg2laFa8dLWex8yaA2VPuMBr9OLipi5CNNWPoh95aFtMjiQI1QpAJzrmknbOp2lGQ0ElQio7y0wQh8yrDe0EO7aKX0e1KaUQWD/WzCtS8mgxVuS/lDOn+s8UudleqOstD3liUa4nJv7LCQqvZzwgTawtRsk+AYDDXwPYYleMuG7XcyalZLvUszo3zw4xdgdkbu9IhPqh70FQ4XYhyviUNGfMcHCMDiH8kPuCb4pBosLAcFLDm/4eAx26F085Tf1eRrowB6hmMoVZLLP9fK6rsGZ+NdbfHpqdvd2Vohs0CASaF3Io/0uHRUxEtMTSHrsMHPPl1nTidemyT+8GuKCFQd99EyySo4p1gnNhW1+M1zg6RKQWkVCtEuPFFYkjemx3dYKwhskbJrfrMBJpkneP55K+WIpci0XlJfRS7xZDLSiNnxzicdRUfXHkBhLkdrOEAZdvlZ22AjE0ThsK/otnAgEgBQrP0mYgOzqRUzZ77c7TorjJpXq1AkvfSwv/IcaLVYDTGPb4mVZVW7HZ1I6N+oOV9jxsqozkgxE9nShe5VrwnG4Vm/umTApAhOhIufmoC/Qyh4KdW/oeb/xvHV6Hn/b1H3OfvK1efNeXTTkfcSCMyirtTd9o7+MSA/e+BuBoAzYaVH+DaIyDqQFo6QrHqyfxTTVdv7EnvhFQSstkJx7S6/N7Z/MvkcSCaGxs5lLPOLClpQ1kD6VDzRhkIIrlZGo7eSnhnTOLFPEeZSgtKBUYWmaSk3685l8ZDWCyGBU5mLc5KPsTdsKZpDFNwKz78a8
 FgnRcFHS
 m3w9BT3UKfo9MxWHUKy1neYZNutClR6jVefI9+12lezXsoUtmIb3osztp1ch37UyfVd5/gamGONjfMbFbEAo5Rlk/iI/8uxSCBsF3sLbYayVRWGuT9VdXQhTFFgb+S37jw1W/95bX/Y4FYBevR9rodi+ehGyOkcfDz3p6BqLThhITAN/d+PjTnraDNbjX8c3714jrP+77iaoqjw/TJlIZvoQ7C65KJI9aibieF2rIzNU9C4PJdDpNX+md9m5W1pl+obKHIQ5ySfnlKJElQEdaQhjgkcmX9XdkVbA3Yh/9Y+rX/LLXsjkJb6Tt1g==
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
passed needs_section_mem() does not skip vm_module_tags_populate()

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
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 kernel/module/main.c | 101 +++++++++++++++++++++++--------------------
 mm/alloc_tag.c       |   9 ++--
 2 files changed, 60 insertions(+), 50 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index fc577c01dfd2..af8880d430fb 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1724,20 +1724,6 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
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
@@ -2784,7 +2770,6 @@ static int move_module(struct module *mod, struct load_info *info)
 {
 	int i, ret;
 	enum mod_mem_type t = MOD_MEM_NUM_TYPES;
-	bool codetag_section_found = false;
 
 	for_each_mod_mem_type(type) {
 		if (!mod->mem[type].size) {
@@ -2804,35 +2789,13 @@ static int move_module(struct module *mod, struct load_info *info)
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
@@ -2864,8 +2827,6 @@ static int move_module(struct module *mod, struct load_info *info)
 	module_memory_restore_rox(mod);
 	while (t--)
 		module_memory_free(mod, t);
-	if (codetag_section_found)
-		codetag_free_module_sections(mod);
 
 	return ret;
 }
@@ -2936,6 +2897,49 @@ static bool blacklisted(const char *module_name)
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
@@ -2968,18 +2972,21 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
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
index e7a40a276ed9..76942f2e3905 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -966,10 +966,13 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
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


