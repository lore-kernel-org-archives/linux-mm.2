Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90B5C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0B96B0088; Tue, 29 Sep 2026 04:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B773A6B0092; Tue, 29 Sep 2026 04:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB49A6B00AF; Tue, 29 Sep 2026 04:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8831A6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:20:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 129AA120453
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:20:39 +0000 (UTC)
X-FDA: 85266103398.23.FD57028
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23D0618000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:20:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GBPNHHu/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670037;
	b=mC0LS8a43hfpXKI+zwLZnHQHl0WKOvj2Kh0BvwJkAt0SnnteQqZ6xGEDqIDUtTczkhSl92
	FSmPsi7hRyLvU/uGdHbJjw1u598zn+sQE/OyJoHV2TRiL3F6M9WiICbc+cr+0XcOCH1i0P
	5TFv8ilX8DFiJ6bMyyQ/cdoeyOcJ5/0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GBPNHHu/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmZkJ7wN0Xw+FUDemDih2hJ4oAQ+XgMEgsJwwgU4l7Y=;
	b=Lm4Y+yswfi+VhJHze+KlGNCvk7nVkVW0gWZql+ZB+GJnnA47AjHd62Wd99QKEjJTBwpkaI
	bZ3ng8NlZNBWQfiObOpvGFzQih9xr3wLgvkg2n6dcGta5fdTeImWZQJiLzlFn8kMHaIc9U
	25nsaXSEFSHJ2G/21Ru8rTwQ/blL4bE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NmOcbrfa7/oEgE3yYkATzy2rrRVs99nl3VT8zcqmJIA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790670035; v=1; x=1791274835;
 b=GBPNHHu/iUuEs+eUshh663mxy1dtwvLvFy66sPwwh0JrurV1x3uukgQh02+j/n/OB393IW65
 kHVUbQ1Ivv4OT6mPtHEd5ihksKuXjoa5kwbqfdD1+FRcpyCbl6s87A8xnJgmzPnJiDv0mWwk3/w
 NTBYnnN5xYjYrGmvzwQE5BuQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ce78a524c08d6a9f;
	Tue, 29 Sep 2026 08:20:26 +0000
X-Mizu-Trace-ID: ce78a524c08d6a9f
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
Subject: [PATCH v11 5/7] module: allocate codetag sections before the regular module layout
Date: Tue, 29 Sep 2026 16:20:12 +0800
Message-Id: <20260929082014.160587-6-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260929082014.160587-1-hao.ge@linux.dev>
References: <20260929082014.160587-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: jw8179ghqpegdfpzrktrditu4jwopin4
X-Rspam-User: 
X-Rspamd-Queue-Id: 23D0618000A
X-HE-Tag: 1790670036-566324
X-HE-Meta: U2FsdGVkX182cGd9uVRTIknlyZOc/owHf5dyRB/2NM7s7xsSe+cVbdZs9H+b+WYHukz5yWAS5oiNbZSUhMdQkuTy9RcHBhKaUUiW4vG1GmkHttWQZODnqMrNk/s3QOcCv3VLkeAho3szy9fVQ/Lzq4yzkzkonmCAAlMqYDhg/yzJxKARVxb3206pfuKCdjBQn30F711zaqbrnhArz/4NpyiGbROa3Pq4s5eukjnsq5qFycRFvsKsF3/cEfaHgUz+ReK1u6oFllI0TSa8/G0TRNVtaJn2xZeK5rMgaMudZ+H+YkgpejH/IYR7iKg+hfrOcvzveL2uLUBPQd99DsbXEx9ycLERz+vLb182KUGudSI9ZZtqorz8Z2BpcRq7S0tH4CmhNhCefI/2xBL4Vs4FGQ7yFnW4NFlecn6+GNmD1jzgCrwONByn8ZPf8kZ0Aq71i+/3C1yF8vTvRMFcsjQiLRFbGJu19vyBjgLaIfdd2wdeteRmiXZqJhwzU6tLs9LPrXcwfIXXyQqECGwoxXbSJzOEoOnvmGLO7uQN41NCiz5rVXfpc46141TaQ5ghZczdhF4+zx0SYFPF8Vnvuu7wTOfx+itL+HfIU38Nuj8sTtCj4N3Oxva2HzR6mVP6UBK5y8nZEMlwt0SAf7zuZvgFnAEmWHuHDTh1SNQhC+P6T74KQp8yVg41I7yUIVfeCekgsoacKThPdvTkY7UkTy9YVV5h+eozAJLZVZ00SA7kHmzhSkHJlh/DsfCmkaloanKv0/M8F/5YoQzXx4Cw0KFPSLsZiXH3zjVMCXOO+j8LYHYUYJwvVkV7Yf6+opo5CkCNSTcE4A/5LBODd7/VUpHq57TxjqdtTDKqE9pynrKLnt4nJZwRJE0PtiBwO1yblrRl3b5xOr4jJ6/+JGKjS22M6NKpTAa++ZoE4DX4lc5KSL81XUsfxIhlcB/93cuspkBr60LnHXX6ohwjs2gf5xE
 L0hswGT3
 5xJKWuSqXdHxAkEf6QwBpFrLbT6ZvQq1lBfzDimu3+HBATdlwmf84E3Cd+m3Ejvw7Rj2j0yg3nItZHtTdyNsWLX/6Kn4OHPVXOJrriWnEldBVQRBCAZiOSS/T6VXznjubSLknQtBvR/GWwDE6hl8DRgl08MUG79XNWTSU+vsJoIsw9NIfX8QjYD9rpjr7l6o7sjYQsPWNqfnAH/ZEU5NN2o1v8j4PAFs+4lGUhew7K5rWJ4yzOt6/wTqprFCddh3Oa3s7VjKBsy1xacnzvQfea1UZZgpVWXqoVgTsirAVMWRDtkl5boXV0FwIajNpNh3Nr+K8OVvIPeKH1NG/mwp0y6JHdQ==
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
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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
index 3e6306ee0764..605c0016f646 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -951,10 +951,13 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
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


