Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20EBC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00AE46B00A1; Mon,  7 Sep 2026 02:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDD66B00A2; Mon,  7 Sep 2026 02:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3BA26B00A3; Mon,  7 Sep 2026 02:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B11E76B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:23:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4263C40613
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:43 +0000 (UTC)
X-FDA: 85185975126.18.28AEAC6
Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	by imf20.hostedemail.com (Postfix) with ESMTP id 513F01C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tXNY0+GU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788762221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unNJiitE5CwfPfSsGoQgDvaw4w1LHKwVmi0M7TIlwao=;
	b=gj+xVD1Td0+yj9I/fxBtv9ObRgENs06sptVQ67Th4Zk/PYcLDtuHjWcPOpKmQQfqhrjgur
	Jm9bHJHGY2CvDS1vLkOlZV6dvSsExQ6y1q9vQ0vipsAUBqm3O3QcJrzEnhnBCSd3pCsGMF
	GT0qmtoVZssJJvUI9JMmUsvmAkWBxhU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788762221;
	b=Y2GthDUxR43d6L6Rs0hx/tdgJevaeLeUqPUo/+JlEyf3L8Aznos+mvCa/tFh00jmk64K6R
	7cZzkdD7YsW3TAuBfhJ+qu/uMOVyan9vpAv+0v+kpztCcSYLHC4m6IgU1Cq11pFtilPEre
	+Z/YN7AjlIrFAOE4a21LUCxOeWGhJ08=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tXNY0+GU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZC7KtKLUN5VQuY7xOf0M7JnuJe+C9bnmljuxLn9sX8g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788762220; v=1; x=1789367020;
 b=tXNY0+GU0SJM6JXoUvJ1LkPJTPmJS18ZlQNbB99ovOHTe7bez+cb5y8mrQhqHdI/RsLsNtPl
 QqM81FWBKNQFLFFtHK88jzpZZ40pE8csfkhL6WZIxP67pwiVbOPUdUXTAEHXP7dTLJYZBmY73Fw
 u7YP2IXSRR0FsVitVASARuvQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e3dafb86706da778;
	Mon, 07 Sep 2026 06:23:39 +0000
X-Mizu-Trace-ID: e3dafb86706da778
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
Subject: [PATCH v8 3/4] module: allocate codetag sections before the regular module layout
Date: Mon,  7 Sep 2026 14:24:12 +0800
Message-Id: <20260907062414.106873-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907062414.106873-1-hao.ge@linux.dev>
References: <20260907062414.106873-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 513F01C0003
X-Stat-Signature: z1o7n7kkkgkhazyykbugmhb9cqeur13h
X-Rspam-User: 
X-HE-Tag: 1788762221-491135
X-HE-Meta: U2FsdGVkX1/P7vlJzBUiQtRqXBo3O7B+Cx5yQHfCwy/aJ0mEAYt2EGCeURTuPrhLyU7HZKU08vnMGHHo+TPCMv3yKd1kK5oAMNm/AMeOyZbqSAGXAzX216nCkDqlHtW4CN0VF6FSS5bK+dnyuHVxvkCvuK0iySm8YWl4lKu/64Lu7itE4IKOL8hIIvQ6zV2nn13G4rmUU8b1UuR24Jx8c5pYHg54sBAayotSzsnnNYEv0n6wdliP4zL4pO+Q/N4HQuDx6s7Y/TWVpJudMrVhVRBrQYdDlgK0LUFfo/Pri2CsQ0zmjx1amFKWkqALcV0fPdbu0Pva5cDOPkhlBXpSXLReTF8W+IpTZYILpgjv+gH5Tco9PKqycYTEUbezAIw4UQMjXBCA/hTPPswODT1Dr3tOSwZ0ZcQDKnzrcDC/O1pNWT0VLCGDRcJjIEivwwlNc8YlA8A3RNkIFV30rau5V5XxFOF6k/z4cVMhcK7qpJv0N2/QcVTlbVjCXGZMt5Nj54epUk9N2OUG9ml56iBzeKZUAEQCPJ8sTKBf1xLZ/MJ348I/MTktQfl+Pi1cO+ltsbU7Pwbu40BUu0FK9wQvB3cNHrUpcJpOH/p7QxG1LmmyEu1AWIR7BpN/EqSDNPMB8Vo5eISTlma+nglbIzq5eOIpliSqj2HGrUMvZcreu0JTA7CQ3BoP1uh5ZJ/Z3tDkWzMBbTIHCo3i3eYYdq4Zo+VBbkWYnoa0HkJ8zkNbcIcvANMKy2teV8is8b2kkn2fhe2goZfBBQpBvoUKs5VsjU+t1zyXcXiSG1G8OPuF0A5e3XUZvc2oao6oJjKKehrgUe+fTULJlR2yVs7IqpAHIu6V7/YVW+kKlwBSnQ35osMUaxEXRlDmDHUJ0jgB12N4teYuhLeRCyK0wSZzxwwfc2oDH/z2ozWLMSrOyNZ4yYUqedHfWbB/SngTMInwzBDgweDXaYvc4oLS1Z33Sqs
 JgHAiDEJ
 zHFKM/NN6MSJ3GfYOT+TMWq8rG2tLi57QicZzoWvdl4HZZnhbflhaHF+Xx2s12IHyFScgwtUWp8acNTtQa8MNoSrPUxoIZuzy4O1WPkCq2LpKhKS2d0ukhI9kJbki/3Hu7QKEWDuowSqyqw8NWuxgkdh0YvRDk7SHjMPI52LKHgcOBfSq5z8AOG2I3jnXfn5Kqf/PFwB7aSiy9YszMVDCn0ZThBARFfgHfIDcC+5h3hF+Zc1+aYKC4PDEGoepWJEy5JzAXIdQ5KCaNKuonnmFCrCE79IjOO/ceP9pmXfwsV8T0c8GNKSv214C+A==
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

Based on a patch by Petr Pavlu [1].

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com/ [1]
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 kernel/module/main.c | 101 +++++++++++++++++++++++--------------------
 mm/alloc_tag.c       |   8 ++--
 2 files changed, 59 insertions(+), 50 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 20b85148ad72..612facc51214 100644
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


