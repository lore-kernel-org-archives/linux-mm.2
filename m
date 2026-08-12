Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B8AC5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 05:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2AB26B0096; Wed, 12 Aug 2026 01:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB446B0098; Wed, 12 Aug 2026 01:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2B86B0099; Wed, 12 Aug 2026 01:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 597AF6B0096
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:41:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCD081C0E8A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:41:09 +0000 (UTC)
X-FDA: 85091519058.29.7F2F307
Received: from out-186.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0519720004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:41:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Whpnxh9p;
	spf=pass (imf31.hostedemail.com: domain of hao.ge@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786513268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJw8Kb7KYo62APlX8MEZxvAZlhH4o0ziACenqfJhSwk=;
	b=BgZSurqADTWIVFtI5hrNyPdNXtwyN2W7A0QWkaEwuWVAATwhOZjb2ASb/LSsxe6JlAGk3t
	Dwwa/26P9FWJkKKDcUCUF+u8Q4/gfmMBI6Un60M8gTqAqMopoaz9vyH5mSi0WDZDsc9RR6
	PfBy9u05q/xXAoD7uodVTZyQPoYuPgU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Whpnxh9p;
	spf=pass (imf31.hostedemail.com: domain of hao.ge@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786513268;
	b=M0xtbBKo61Ma94x3dP8jwDNUb5yFkMUOkB/3U2wTCvQj40ec2bZD93X4/6VWYMaSNAkOAW
	lblwzihRMfieW923/hWcNOxrzRAfQLdvU5rldTre4tJvnzhUDtx0qRrwVCzW1tTGJAGSIY
	/g+5AxhM9zdwDjgYBpygImfYZQykD0w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786513266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TJw8Kb7KYo62APlX8MEZxvAZlhH4o0ziACenqfJhSwk=;
	b=Whpnxh9pXp2+bTxNYX9GyGV2YNWyFmEhiFLBxTHM1emfN+vJjElCcTotxQwVy3X1umLo6t
	yiTOJm0OqPnobb7aV185QEy//Yh3hnbhvUFaABU9uMRD6FwBkggx2YIhowltCfc/AyM1lq
	HTTnFTnQdY/3c7KPSiV2czkyKaweldU=
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
Subject: [PATCH v5 2/2] alloc_tag: fix undetected compressed tag overflow when profiling is disabled
Date: Wed, 12 Aug 2026 13:41:05 +0800
Message-Id: <20260812054105.102637-3-hao.ge@linux.dev>
In-Reply-To: <20260812054105.102637-1-hao.ge@linux.dev>
References: <20260812054105.102637-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0519720004
X-Stat-Signature: yaqfwo5ji6m9zhxuz9m1hyju5hwa6e9o
X-Rspam-User: 
X-HE-Tag: 1786513267-264500
X-HE-Meta: U2FsdGVkX1/iAh3I8bhIvXCExtzevy2WJRs4JD7KnaV2ARNcDsPZATzcX8pSbpkPjBpMqTja6A2XiFBoHhYMuLq3RnocP3p1E9gpR2Mvod4Wek3AytT3KC8N+UYh8betSsC5bCp5I2C13ykxK2pOvtJvo9qgCW58H4nGhE+CRMW76CcoBKM6qIA02IMNFZ0g3fV7sXEWmH817Q/UJyz0Ycn65G69DOo75340fJYSCS66CTCSVwKiSbBlLPTJfd3Xm2dUDOwDHgaeYWqlCt9AhaDVwhGnKzhoF/ZFfXMW86V8q5XAFERu3XvwGjpgT3SkiIOiE29BECHAf2L2v9+UbAxPUSvlQC4roNk3207NEEFbWj11vVgbMg6nLQrXuMXdhRNXjDLuRzlJOTC7L0D0K6v6g1kJObHW7/RUovdBt8M7b07dRZ1TEZyzFB/7AiQCuj/odTU9J+oHJ5q4uuUaeDfUmsVJA7kcljzFiFqazMzK/BX7DOUhNVfujR0CNxgrHTxk1nG1dRsfthRueRZchNa4KLiYgKpBtk847qrks+NR5hQGzCqKeCGwVVhbc5XAvJ96U8Cuzd7+0h5LMmwbPnkUyvPN3zT+SIQDnsfw9HG7T23++lmPV44di9euN6Up3ksxQgkvFXAStxkdgapjOcU2/NL6gn2jftxq0A3NwgF8JyVRGy7f5dH4yzrFkfgHOVPnuDRzkGhXq4GxIpwpyY6Avw5vkAyhJKNZWKTLRr1KNlDQoXi4ECy5L32X+4oyoiNFlnYRayh0B1TW2HcNxXCa2F6Ct5YIWH4chJNQpgLpMbmjZct0qJmhDCgRYPW64+u3o5RMkSB2DzPwu/bP+cqwzvP2RfRg7xLnev0BGKaqnQbyxs7D78ex0Hkp2Ua0y5LxxjRikKnZrvgUIlnHyhMkFU1+nD1mgfAKLnPIRJVXPEcaENKFpThSBlbaLZn9zLgSMYAO6+aV6rnvmLo
 oka9IJfT
 5BjWP+Vzf5CHTVhHWx3Vw9pn7rWoPiUz1fPOtE+xWUG/2zlxpo59zarjzRTIZDierdPYPoDKQsAGtB2dLceJIsxyvKneor5vVB91F+9yHIJcK+wAqcy8XolD5cv76aDTRdnUhRyBHAYRu6JHF0oK/rv0ZibVBGwNTxHehv4QiqAhqctHnqtXfqvdrVAv+pe6KK39J5LK3O8zHVngaksb/ue2tahHBnB6NdDE+X9kwZ0pkgCzuCoeS4IAYkdckLahfx9/F
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

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 kernel/module/main.c | 25 +++++++++++++++++++++++--
 mm/alloc_tag.c       |  8 +++++---
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 46dd8d25a605..ed26f167be84 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2944,6 +2944,7 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	struct module *mod;
 	int err;
+	unsigned long frob_size[MOD_MEM_NUM_TYPES];
 
 	/* Allow arches to frob section contents and sizes.  */
 	err = module_frob_arch_sections(info->hdr, info->sechdrs,
@@ -2966,18 +2967,38 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	 */
 	module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstrings);
 
+	/*
+	 * Save the sizes reserved by module_frob_arch_sections() so they can
+	 * be restored if we retry below.
+	 */
+	for_each_mod_mem_type(type)
+		frob_size[type] = info->mod->mem[type].size;
+
 	/*
 	 * Determine total sizes, and put offsets in sh_entsize.  For now
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
+			info->mod->mem[type].size = frob_size[type];
+		info->sechdrs[info->index.sym].sh_flags &= ~(unsigned long)SHF_ALLOC;
+		info->sechdrs[info->index.str].sh_flags &= ~(unsigned long)SHF_ALLOC;
+		goto retry;
+	}
 
 	/* Module has been copied to its final place now: return it. */
 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index af44f90379f2..0a7b657fe2de 100644
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
-- 
2.25.1


