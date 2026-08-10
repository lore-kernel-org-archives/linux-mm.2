Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83901C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11896B009F; Mon, 10 Aug 2026 05:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7846B00A0; Mon, 10 Aug 2026 05:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925036B00A1; Mon, 10 Aug 2026 05:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72FFE6B009F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:40:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1345780685
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:40:09 +0000 (UTC)
X-FDA: 85084863738.28.31BB72F
Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	by imf12.hostedemail.com (Postfix) with ESMTP id B60904000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:40:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X6JETdJL;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S15GzqqeJfm+V4QQMSDG2XpUw61+RqiF3E72EGNCgjg=;
	b=2pJzbiyXigIGSIJWerrD6H9VB/jGISQTWnuIvHV+F9GCjV7HE4SMk0LOlwWXhIZOqLau7A
	Lzq/OZGbz9N9BXSiXeRHl2uXLiBAy9zXkh7PD9rztRgy200Px0x2ysOBvDAWQf4ihBOmDf
	NrFXTcph9+ABRwhlQC1cbI48Trl5BHk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354807;
	b=RZKI6swsZ7i+pnLfVaE08RD6tEtzI6Zd/NQ6JCOqyecDiWQBbzpgc9NKsWNI2A0cddHcOC
	A0jHeSuafd1kAH29o/MEr0WgOntEUqYMvmiKYMTS5d8+HiAi+0KyyhhSTA6M96EQ4nc9W3
	neUCRaNkakR4LxUcw6zkBohgPnoHTSY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X6JETdJL;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+7z3AP/ISNgtjS8Lqlp+ZNKMBFC0XbB0Gkd40yGE6eg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786354805; v=1; x=1786959605;
 b=X6JETdJLrNicIKajmnhxVTliKWjVG6cxTJow4sXQbILvCLiOXKsj1tEzo26qKwfiQ6S8BA+p
 XBBnPYe9+SwRw28+z938Zw4v/cTGcAmm7fp0KqIWYer0e0+XqfAbf4a71KvR+ElfK9ehdVX+6xJ
 F49syguUdUm0vLDLSDXRS+OY=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by mta10.migadu.com with ESMTPS id 52b4c21b50599e27;
	Mon, 10 Aug 2026 09:40:05 +0000
X-Migadu-Scanner: mta10.migadu.com
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 2/2] alloc_tag: fix undetected compressed tag overflow when profiling is disabled
Date: Mon, 10 Aug 2026 17:39:55 +0800
Message-Id: <20260810093955.153015-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260810093955.153015-1-hao.ge@linux.dev>
References: <20260810093955.153015-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B60904000E
X-Stat-Signature: kb3gdfhdq1q9x3wtgc88kjrhg4jumb7s
X-Rspam-User: 
X-HE-Tag: 1786354806-189697
X-HE-Meta: U2FsdGVkX1/akePPbfVmxvlrlAyE4Gi2c+jeY+Dq3toYtzcOv83Y4MbxVDruvETRnDcEoNSjz4CdehExgeiMTyBw3dR/q0vsbFDrd2A6oH9seV8otXkMOfgmy83JK1fv/zJaY1U1d/Mv5W6vjbsqMtxcqgyjzU9e6Tc3Wl/rUza8f6G82olad3+eCRBMFBlL0klrgDcDFtuqhBdCS0z2RxD5gefVpBVl1wofyeLxadCVDh8MoTEBCIgQlZm9Cu7aPnTxmY8L7wQ3hkGXhfkjLb7hUgQ/68dLME3HrXYwpSrt/cF5bCnSi4/ABAyl9WAUbQ8ogVaKkGo/obQaCgE7G7jIBu615jISoCtGDShj7ZnlzjfUJ6/1O5V2yz/DaEnRiZ56MRJvQKifm4Vy0I6Vu2mA4gwIna/48Ur6nG6zmf7PsyWnJQzWTxKBjRzAs9IS2I3Makcv7znWgy4fwf6sMb9LtDJ5fw5eCgA/HZ7IsAZ9hBxpuALEGegMMXuQtD4NUgd162SKQ1ylpjUu2L/KepTXMEKRb+yce/ZxFk5renJPFjZwljjGpY3p6OZV3e2tTq7pNqdVHzKAWiQx77xFtrB4nh3gaODZPaK5CTCMSmSbCIjoAXUY+eEf/UDReT+jSz2ffwE8/WV3iogJSLtMxQyocIp2O+jBIAjjdWfH82LucGPEZPxBjN34cTZN9loJXjqEK/gp/aw765aTEyzjc3mUcncWBCxslKO7CpEnsiZiBl1/8HfwaMB7F/CmMqkQOQjNwXYlEma/zfMI0iyrbuUnMtcf3lYTIa/VJLIscJs2WDOVm3LbOb6o2LlB06Qbeu8ZeSGWMT3Dbzs29ge+j61BxyUJiBrLWDEMNxwC1687KmFtsF73QsWtzVl+MCLRqigAHQlGDgnCDrbEwSeZUlz2Zg8A1JBwyvb/YPBff2XyFE+SJTluQrOjh8Ey7iap2IITn5sMd/CBLTELpYq
 ouEtr+gm
 9QsnAVFE5vaBF2gsw3CKzefy0HdpQeAWLUMZLEc22MXczRiZBJpsTAG0AjbBRNKFUkVSjN+PQJgZiDgl9J2kop8TcqWraelR2PIhhBzzlBu3u0Ejmg+/6MN4XSNrx0S34T+bbsFaCB3ysx6XkXpB740MBIgaTboLHcodyPwKqkPdLJonwy7I7jeOTZWd5mxtuY9DQweFlFSTiVf9oIZczdfxkSf6MgfRPcTrusS+6QEdOMIrW0uRZ+b5AT0kZcvedNQTYRhLrmZTtbcJWFOqW5c/Uqki6JhZQk1KmQNRbdCNgqBzvJ4Km6XO7bRagR6b5oOPI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In reserve_module_tags(), the tag overflow check is gated on
mem_alloc_profiling_enabled():

    if (mem_alloc_profiling_enabled() && !tags_addressable())

If profiling is toggled off at runtime and a module is loaded whose
tags exceed the compressed-mode limit, shutdown_mem_profiling() is
skipped. vm_module_tags_populate() still maps memory for the tags and
the module loads successfully, but the total tag count now exceeds what
NR_UNUSED_PAGEFLAG_BITS can address.

Once profiling is re-enabled, ref_to_idx() computes each tag's index
as its position in the alloc_tag array. update_page_tag_ref() masks
it to alloc_tag_ref_mask before storing in page->flags. Indices
beyond the mask are truncated and idx_to_ref() resolves them to wrong
tags.

This silently corrupts /proc/allocinfo: allocated pages get attributed
to the wrong call sites, so the statistics it reports are wrong.

mem_alloc_profiling_enabled() and mem_profiling_compressed are
independent. Once compressed mode is established at boot, it stays
active regardless of runtime toggles of mem_profiling.

Remove the mem_alloc_profiling_enabled() guard. On overflow, shut down
profiling, release the reservation, and return -EAGAIN so that
layout_and_allocate() retries with profiling disabled: codetag sections
are then placed as regular module data and the module loads without
profiling rather than being rejected entirely.

Skip percpu counter allocation in load_module() when profiling is
disabled, as those counters would never be freed on unload.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 kernel/module/main.c | 17 +++++++++++++++--
 mm/alloc_tag.c       | 11 ++++++++---
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 46dd8d25a605..c32bb47a573a 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2971,13 +2971,26 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	 * this is done generically; there doesn't appear to be any
 	 * special cases for the architectures.
 	 */
+retry:
 	layout_sections(info->mod, info);
 	layout_symtab(info->mod, info);
 
 	/* Allocate and move to the final place */
 	err = move_module(info->mod, info);
-	if (err)
-		return ERR_PTR(err);
+	if (err) {
+		if (err != -EAGAIN)
+			return ERR_PTR(err);
+		/*
+		 * -EAGAIN means profiling was disabled but the module
+		 * can still load without it. Reset state and retry.
+		 */
+		rewrite_section_headers(info, flags);
+		for_each_mod_mem_type(type)
+			info->mod->mem[type].size = 0;
+		info->sechdrs[info->index.sym].sh_flags &= ~(unsigned long)SHF_ALLOC;
+		info->sechdrs[info->index.str].sh_flags &= ~(unsigned long)SHF_ALLOC;
+		goto retry;
+	}
 
 	/* Module has been copied to its final place now: return it. */
 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index af44f90379f2..3eba6331174d 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -950,10 +950,12 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
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
@@ -975,6 +977,9 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
 	struct alloc_tag *stop_tag;
 	struct alloc_tag *tag;
 
+	if (!mem_profiling_support)
+		return 0;
+
 	/* percpu counters for core allocations are already statically allocated */
 	if (!mod)
 		return 0;
-- 
2.25.1


