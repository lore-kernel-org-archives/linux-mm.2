Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D40BDC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B462B6B00A0; Wed,  5 Aug 2026 05:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7486B00AC; Wed,  5 Aug 2026 05:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5CF6B00AE; Wed,  5 Aug 2026 05:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7921B6B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:07:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06A951A040E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:07:20 +0000 (UTC)
X-FDA: 85066637040.04.CC77A22
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id B4A218000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:07:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nTH612fl;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785920838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+XTh5YfCdnKB/aSwCeyPpNR+1ZVZMYEDrrf6Diqu2cE=;
	b=tXYgKGbRT2p+JeCUu4kpqdYYl757PlclXvEzh1NYusQeGszTmhHibwS+upABmAs7QF/Sia
	Gzu9iRjZ8YryRfxhKWfZRF8LdTzQLLR1x9GheLIlqEXLBX5/g2SQ1EL6HjwGDlJ23iL4Xv
	jdmAQC2ioKboDD5vzXRkUnQqjA/eZ70=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785920838;
	b=cdhjKi86LplqecwhQ4Z9SeYL9oL5hlST74nd/5ykucKHecf2SFfSqRao2ejAurVAKIqWw1
	UaubqzL3/V+F2zyfK4yA/5/ldxgidcghQgYZrdvo7qyk+YyvdzrJOKDdmk/DVpXlOUuPLB
	e7mkL2TRRu4HF3G1mZka5HXvPSyA88U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nTH612fl;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785920835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+XTh5YfCdnKB/aSwCeyPpNR+1ZVZMYEDrrf6Diqu2cE=;
	b=nTH612fl5Vx0YT6YPtYYSnjipDresEX6tRnZQ8RbdJVw/AOH7TfOtn/i3TgClbt8mMF6Wv
	Oq1O87t34dsD5zqSdcYNp3CZzGlnJorCSfnhMGn99atn/ArjpuGd5UxIQEIllMyKQgUJFm
	SHUFUS/dHKzw6+ff4wLm9afuBDZUQTw=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Ge <hao.ge@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Abhishek Bapat <abhishekbapat@google.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] alloc_tag: fix undetected compressed tag overflow when profiling is disabled
Date: Wed,  5 Aug 2026 17:06:33 +0800
Message-Id: <20260805090633.141001-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4A218000A
X-Stat-Signature: k1n5g4j8t1g6ae5uernkx6mbidbmyhoh
X-Rspam-User: 
X-HE-Tag: 1785920837-608123
X-HE-Meta: U2FsdGVkX18NcNMar5FHqFWzxyqDwKiXUF6K/ggx/AZTaGodouYLsJpC8pKUDUZ8nOxWbPX1CEQtjbrpu7zq4AqVT/3BNdTlILEy0TIIMaFv5DFr40wBY1jLuqM97KhM2G+8EDuQtXkSmh4I7n4IHbbkeblch2JvM6Ci9Y87aEN4rBFV30Tp/RZjDPTKFg97JXbHqCso9jYKeN3NNdVtRj1FJmBFKnp3eLXhEk4N0AKm8qIodLMZvnJyYBUgxoYyIYkvW4akR4bVTDJMUFhNaggIO/+/OdoEPoydD3Wvo9QRVn+6BhoIhU/b/UEeJgQmeSxYyNk4ZZlUB4pEw2Ir5xSXazaQMDAiXeqQ6BgqR7j9r/W58+ITUvVmabxP2UlsOJ/5i0naiuTOna/h5/zXSENVuYUQGfzrzY4f1NUYxOlpcp8bDofh4c9efZeHzG7k2x2pZMrKDWhPgPLancCw1R0/FcMVBI0Pi9AVgUX+XtxtYc/qU/9PNaqGAXocDUY7UPkRI72moUhAEcz9JqG1tzE4X7P3FJBTymnNfevc4r6Jj89dAr56xQuJ0FPjkdpZ2e9DqkV0CmC5RYj0Z2wGEm48O/CbmIrXktt++02oPwU9Fie5bIVlkoRICWB9Kmu0iX9LGcoIp5EJAqaxM+qmIlGU9HmyGyaH1KPtCUW5HL+lTMJgRgHXLTO93R2Xr8sWZGREPUWADh7k8BmHhRXefpxof1P1o5rHvDWweQlWEVvgbRkZqbsZ8E7CPb1zSrSmY0MyHUrUHYpGA+6AXg2AM9FhKXXsGstVfKI4weN51lx7XAfbUmFX3V2o5XA74PwdwfoZFxhIvtRS7eWJqNqjemMxhoksro2sqqjrLjeic99rSE7H9T9TWfC2fb4WyKlGQSFtaS0wUbmfyH2dEtrosI92UShpGkFcYI3WtvoG0TCrFRYbpK6gU1m90mNpACZxyyMDlLfItRLfRHpLUFu
 p5Sf68Xm
 h6J9KSmlrVaVTJAG/8h9nnAdVlV2T7wlP540rMkRelYYRpkkpxOqwkHEgsBYtfjUJtOKNUpOrYAty0Ubo2zhCcYX5GOrZrgnhFkyfYazOsi2OiVNRJtQNdSsfMXoLbZLY8cNXBXTEXDVQACiKVcjRq2/cKjIOfmOmyP+XPeI8pash0s54YjlPyiye0eZDlW7GC3vyjRGa3XCjnepT/YLL3Teb55tuE35rUX+eJbPTAjmk4yTh/Ne8vu4F1msM9u4qAaxIK3oUDyKa54Q=
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

Remove the mem_alloc_profiling_enabled() guard. Also return an error
after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
the mapped pages would never be reused - shutdown_mem_profiling() sets
mem_profiling_support to false, so no future module load enters the
codetag path.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
Changes in v3:
- use pr_warn_once() instead of pr_warn()
- return -ENOMEM instead of -ENOSPC (Suren)
- expand the commit message to describe the /proc/allocinfo impact
  (Andrew)

Changes in v2:
- return an error after shutdown_mem_profiling() to skip
  vm_module_tags_populate()

v1: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@linux.dev/
v2: https://lore.kernel.org/all/20260804122038.190270-1-hao.ge@linux.dev/
---
 mm/alloc_tag.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..35ef2bbfa13a 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -904,10 +904,11 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 		int grow_res;
 
 		module_tags.size = offset + size;
-		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
+		if (!tags_addressable()) {
 			shutdown_mem_profiling(true);
-			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
-				mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			pr_warn_once("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
+				     mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			return ERR_PTR(-ENOMEM);
 		}
 
 		grow_res = vm_module_tags_populate();
-- 
2.25.1


