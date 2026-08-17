Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4E8C5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 06:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E136B0923; Mon, 17 Aug 2026 02:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D160D6B0925; Mon, 17 Aug 2026 02:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C538A6B0926; Mon, 17 Aug 2026 02:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A21026B0923
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:27:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 128D0A06EB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:27:11 +0000 (UTC)
X-FDA: 85109779062.15.859E16B
Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0848740002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:27:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kFbNfxaJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786948029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=catBUQq+7xfUG9g3nFVpzefAxED8aVYAcVxMYhej2GQ=;
	b=70HecLTSYx7qBSDFBb40ZKBVTm/RTL1xJu6Pr9CI1IYzNoYUS+HGfKuzR10UqekcVv8tfw
	qqWQfN0ywLsbTXvhoFtU/gGJS9nrhhbpG54IcGCvMBtrnWkhKkt8PC6AYgYugkQJ1KbmJK
	u3PrOus5HqOvgDY/dP/p257wbsvBWOc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kFbNfxaJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786948029;
	b=y9t5bPqMYMagCFLzzgrx8fctfgn6PXQVa9annh9YZyLDmpN2+CPpzBuh2G94rrDOQXRFrs
	WSOPQdqv6CWzR/btuEwlRcCgQoSCjiQd+I/6xUnQzRpxr49Nfv91BZvvCtS/WQUIN2VPeD
	JFP+eSsA5bHOTkwaMgWX02Y1Papojws=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GCy+WguWNDQlk/N3Wy1cyqoO2byfKnIj9nX7d8+026w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786948027; v=1; x=1787552827;
 b=kFbNfxaJSQd+teceRATDLlPSixZxjsV8yAQQTFTaMNe/YvC9puCwBjg/ettFEm6/+fUoaNbb
 7MJJxnolOK4L7K4Dggjgc45fFCIIlCWx7ogYTjXWmjiLaaleurv36c2Zf/w0ohsYoqzFQ9Y07Pl
 tkd57W5y/eedfZCdfiZwQUbg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by smtp.migadu.com with ESMTPS id b5ed0a00273cb5ad;
	Mon, 17 Aug 2026 06:27:07 +0000
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] alloc_tag: remove /proc/allocinfo outside of mod_lock
Date: Mon, 17 Aug 2026 14:27:26 +0800
Message-Id: <20260817062726.106511-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817062726.106511-1-hao.ge@linux.dev>
References: <20260817062726.106511-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y81fbrm7t99xjcfwpnqkxs8zqjghb7ht
X-Rspamd-Queue-Id: 0848740002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786948028-532064
X-HE-Meta: U2FsdGVkX1/LEA/FZ4aJG0eoDBtbjXSM2szmzkQ2EeeMQLKRDRnrhTe9i7ByXpdRTiULGGWumCTitmQGO9JBvezUnuZGBcIHfpNkUGHfFWb380QQxb/IWehOkvreH0o6vYPk1v0ShwrtAgYwFUB/BFPAI0HDxHZWhhfpuid50bLKqoG4IrCaFvT/J2FCf++lxkNdFKGoWT3PflLptzKbS1SW+Jac4YZtEMeWxhcRIrO3aXWHg0EtD/PvKGP2RW17lCuYabw+nYF5IFt9rwRfuun3IOZFrBP52lPeaKe2EGGp+EZvFeOA69Pb5fQkJWXU65fFX5swgad/uzevuwbcdzDk5bIr6AHSAEBqEDqAzdw39L5wsGiW2O738pWT9l4QITokv6CqEVFdWW8eEnGJMNKbJ87D5LwC46OQS4HhofUCBmM0F5NQe873hrhpagJAYWNP8U6E2e/5UnVnd/qJe5c90npodUFDG2Mo0pHaa+RngYRAeijXVEr/DA5olPXSapKvqWafSEgJQW75oh8kfSbXPYTjaVJShMM1Q7XpQtcB6/NdYXUCinmE5TRfpB6DzpTzjYhx71KjD1FW/nh10zhoI9H6xIzNTYAnG5hJUD+Z1mgSKR9Fbbb8radK2fIFhmvqfZiZ+Ri/pz1y9Be8EXJ2+zOYqBsB1Z+1t0ZfB3qxkyTHSCsz7hJ6lc93ggIpxKBvmlTYEk7BfDvsJn0O6ypPiew+OhipjjXF1gRI6+ANsIHIBqqEFU9fjoMJ62lb9f3zOnqMTK0Is1MSrHrH0eLT+t+AmcWAlnPfqTqtgviZKVxfBYJzVMgD6I/1VJKa9tWLK8aB+wE3zSGig4JPvMQyfaTbppFGybkcI7Pec6RlV/5vbGRlZvWVNA0IoeOf9o1RNQfaxUgQwco2kIQQlLkvE0Pf8l75S1UO5BHxFoCvLFztsau27j8VYl+/h+beENqdi1VuQErU8JF/ON/
 k2Uu7od6
 NR1M+D5mv1/BHeFmJtOD6UQAdic642ty7xc5GrAWpDz4lTetn7sc/m2EBVKqGR9MwC+xgcrVBYSgJcuevQiv3osv2sXs8VIap6QUrIC3OV2C/h/5uLzqo1Sr6M9VVVvcoakeI6nSvQIBrfC+FqdbFMV2Bgs1DWe39BUpydrSXGuDMIBUB8Ir437JYfVcurMY55XkgOj05+1fobrI8+Ow+YNu59av1240ZItML5t/lARBFb1sD7UnomchacfsaefmEtCKRET3jUSoeIX9o4iRa9rB+IZfE35sYJbjwkp5aRmLmJxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shutdown_mem_profiling() calls remove_proc_entry() from
reserve_module_tags(), which runs under mod_lock held for write.
remove_proc_entry() waits for readers, and a reader takes mod_lock for
read in allocinfo_start():

  CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
  ----------------                   ----------------------------
  reserve_module_tags()
    down_write(&mod_lock)  [held]
                                     use_pde()            [in_use++]
                                     allocinfo_start()
                                       down_read(&mod_lock)  <- blocks
    shutdown_mem_profiling()
      remove_proc_entry()
        wait for in_use == 0         <- blocks

Move remove_proc_entry() to a workqueue.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 80eccaca665a..b1d48532a25a 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/string_choices.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <linux/kmemleak.h>
 #include <uapi/linux/alloc_tag.h>
 
@@ -591,6 +592,13 @@ void pgalloc_tag_swap(struct folio *new, struct folio *old)
 	put_page_tag_ref(handle_new);
 }
 
+static void remove_allocinfo_file(struct work_struct *work)
+{
+	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+}
+
+static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
+
 static void shutdown_mem_profiling(bool remove_file)
 {
 	if (mem_alloc_profiling_enabled())
@@ -600,7 +608,7 @@ static void shutdown_mem_profiling(bool remove_file)
 		return;
 
 	if (remove_file)
-		remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+		schedule_work(&remove_allocinfo_work);
 	mem_profiling_support = false;
 }
 
-- 
2.25.1


