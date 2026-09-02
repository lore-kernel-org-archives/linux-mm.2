Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B89C624D7
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814C06B00B0; Wed,  2 Sep 2026 04:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5EA6B00B1; Wed,  2 Sep 2026 04:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB6C6B00B2; Wed,  2 Sep 2026 04:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C97F6B00B0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:17:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D38F980108
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:17:57 +0000 (UTC)
X-FDA: 85168118994.05.211D4EE
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	by imf16.hostedemail.com (Postfix) with ESMTP id D1C94180006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:17:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HFLeu+hU;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNwMnZFyiCarqXj3ppzqtzQ9sVms+GKxCJO8BzJsEyY=;
	b=8fegUlAMWdPLeJ3X3+TeygtGvY5vKog/uSS643WZNyAgG8PMU3peZscHpHZfgP+dr9pqTV
	BSv3gv03IkplL/UoZSe5rycPZx+Q5Wi5lzPiyjxjxqsoCVuAvLulmc/48WMAtqFcmAxVvt
	Eio/F+wxAF/k2HV6sllLc29795h5XG4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337076;
	b=kPpQIS1zq8uewdCJqoZJ49W+egMk2ogoJNdlt5nQx6FwntkERVGuKddD4zmz5d6WOjP88G
	xUV9UYUEYqLWip3ffWJwz9pij0Y7C8J3oz/PrOp23cV1m4QylplWJssrT+0nc5kRks5Gtc
	t0NdxmqGpJfDSx+KR03Y4r+Nr/L5/F4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HFLeu+hU;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4nP8oY3FXaK6DMyt7vwB8mKX+49J/UMAOZEl2daUDMY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788337074; v=1; x=1788941874;
 b=HFLeu+hUwGbQPfLt6fKYDW0nrqYdd3+B5K+6NDeOmppIIn1RYDK3xhDzcw8zSaiFpe9d4T1H
 Ela2dV+PenVnlUEpM1RgsFOdQ+FHo1kgfF0voJ2fBJkdHex9hBR93V3GNBOmsIKHbB+d7CmkR4t
 B/MaZms9nvA5gtMYNYRHvF5o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d040b23edc8a3246;
	Wed, 02 Sep 2026 08:17:54 +0000
X-Mizu-Trace-ID: d040b23edc8a3246
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
Subject: [PATCH v7 3/4] module: allocate codetag sections before the regular module layout
Date: Wed,  2 Sep 2026 16:18:01 +0800
Message-Id: <20260902081802.146145-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902081802.146145-1-hao.ge@linux.dev>
References: <20260902081802.146145-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1C94180006
X-Stat-Signature: z4dndbm6u66am1wyq64u81smw5obnkcr
X-HE-Tag: 1788337075-231653
X-HE-Meta: U2FsdGVkX1++EtEq6INL9j5wK3n0BBWqDVrjVo+48u8AuctEa43cExPio/+voU4Q5d5KU6ORsRbGPR+lHkOtth8iUvxVpodNp8DlW3bG61uN1fr4ugAoILbxpFSdSUQBulPayehQqywREKY4TFq2rDvZrSs1afzvT71ntM3z07GRR6kO1rhdUNM6I2ZmIiwxxuHFHzsdgRloSJOJK87vdekpirg1uoeEsl4hduCS8OR7PG569Q1fP1ee+rvQuJbwgI6CnaegZTMa1XB5p1IffgR/Yivjw97gyyuIogENeNYWcTc+eUrs7FPQWNvaWnZdgPJvTWgZdU6Yu/G4Cwir5SSdlhQ7icUCnUd+hz9NZN2//aAuXzkpe9iPQ8QPuTOrB2yPhfqengGKMooocs8OdOpynAPLY62zRzR/fAQEmPr0bvPofQBbrMgsdWNTZAlJODqwLlRXcmCQ9ZdlgjakAHk574M+Ple8NormIVil0TNv38qUwbRX4VhNmMeVUiivyCwihSPYjE42I9YgmHqio7VpRxP8++Z3/nDA8K+TB5/YMYOCbNWwCU0+zJ9ClckVupaQU6pm/RpOCFq1siR3gTpB0BiXTpF67RWo7xZnTHfdoUvWijyBLK9CBaDs0bWA18Qv9T1ZNCJSSABUiZzsgZaw5zqgPXVVsuRI8fUpPNcN2UsKk4c16bnO59gHk2+gBDID9Qdsrsy3rUqPl0F/J/KA+JEvwTSl0PVJRrq/k5ZpTdW+YVt7ItJl+h/9VA5PDeIXeKy2DoBfJi4lR2w+8N/YGUoRacXonPKhGvqNXdbgKu+u5DLUoP4eTifEVyNXMo2x/Dw1qKOgUpKgDUAw0RT+zDl2Ioh5p6h9t5VChXptHjpj+sqCrmxoE5sS7h/hKKxromN3Q2Mx5GC5NekhDViQ/MNJyUlZmqOR8G8nkFr3GwaJcCok50VG7p1NriuWroJU/FoU5bAccQGdiW1
 6NwWCOjE
 hQVH1q+XP7mhj1jwCY+kFTlRFdPulfdgIKWhOxDhK6URj0pjXfidMKnh863dkKTPsSmhyja9K5TfER/GZOkIvzUI5HLwdayPGc7SSH7fhXxbGbdOov0xCZFtL7zxNTambKxPSX13IrUFFSq2PPNnjoN9gXkdzJTzw15jZwI+dEdlkKMYl0aXAFpgbv17DDX/xWRdM1//OWDedF80C/H/kdLyAGNyTF9Id9rKpD5JbP0WAof1sgZJqZ6bQtuu5KycSjDGVFhvUu1eFM/BxHLncmTLit7a3Q+I1MR7gRsXTsjmZBsynNtGOjABvww==
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
data and the module still loads.

When profiling was toggled off the overflow check did not run, a
module could load with more tags than the page flags can address,
and re-enabling profiling then silently corrupted /proc/allocinfo.
The check no longer depends on mem_alloc_profiling_enabled().

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Based-on-a-patch-by: Petr Pavlu <petr.pavlu@suse.com>
Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 kernel/module/main.c | 99 +++++++++++++++++++++++---------------------
 mm/alloc_tag.c       |  8 ++--
 2 files changed, 57 insertions(+), 50 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 078dae188aba..d0a8ac9b3ee5 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1717,20 +1717,6 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
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
@@ -2777,7 +2763,6 @@ static int move_module(struct module *mod, struct load_info *info)
 {
 	int i, ret;
 	enum mod_mem_type t = MOD_MEM_NUM_TYPES;
-	bool codetag_section_found = false;
 
 	for_each_mod_mem_type(type) {
 		if (!mod->mem[type].size) {
@@ -2797,35 +2782,13 @@ static int move_module(struct module *mod, struct load_info *info)
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
@@ -2857,8 +2820,6 @@ static int move_module(struct module *mod, struct load_info *info)
 	module_memory_restore_rox(mod);
 	while (t--)
 		module_memory_free(mod, t);
-	if (codetag_section_found)
-		codetag_free_module_sections(mod);
 
 	return ret;
 }
@@ -2929,6 +2890,47 @@ static bool blacklisted(const char *module_name)
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
@@ -2961,18 +2963,21 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
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
index e7a79116ad81..248496470904 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -958,10 +958,12 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
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
+			return ERR_PTR(-EAGAIN);
 		}
 
 		grow_res = vm_module_tags_populate();
-- 
2.25.1


