Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B85C5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 05:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2894E6B0095; Wed, 12 Aug 2026 01:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2618E6B0096; Wed, 12 Aug 2026 01:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DE26B0098; Wed, 12 Aug 2026 01:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E32D76B0095
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:41:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EA494033F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:41:06 +0000 (UTC)
X-FDA: 85091518932.07.CA7D07B
Received: from out-171.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4218FC0008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:41:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QrHRZra0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786513264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJefnKdyyVU6NP3rSxhHMvWH6C76JvPIyTZYHfrF4TA=;
	b=wnPmYm2vdreF+VJ1FvKoh590wbVaAJwZPxbbOeHg/jhEwGujq9jeOCyaZFjM4HAwyXHbIe
	11ZlKwnWEhK8QFSg8nB7c9wFqFNcGS/pOHX2CM4dgzGiXhfAGK3imyI7KEIP/97m8JIbP0
	pfuAltWveECVM6VAD+5ga1yIDUupFNE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QrHRZra0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786513264;
	b=rCWiUOqd7Z34r9UbnawLlvubMkSxfsIfTMBLODSj2gkJvrioojwEjYPVSDqlmKzyZUJWHX
	ZUGXakHuEN7l6/OKkSkoV8NE+Hqv+Kylm7wCnr5qADa/klcE9OvADxY6XPO5KwAsjWe4UW
	iq2TZ0b6voHSw9zCK55w6niOjxPjTyE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786513262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bJefnKdyyVU6NP3rSxhHMvWH6C76JvPIyTZYHfrF4TA=;
	b=QrHRZra0d0oMGEigxQe/Homsx9vdjks6wFLQ1hFnx/AzQPiam4RRF32oxnU9JqB9+pF861
	eKbAeAGGchjXgw2qQpcl50hhXLwiIZF4Pu78nuy7A3hzOvtQaE6wLy/XrxMNuLIb0Zfi5r
	vl+tD5IQW9MDinWepMWCNp8CYs+SYeo=
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
Subject: [PATCH v5 1/2] alloc_tag: move release_module_tags() above reserve_module_tags()
Date: Wed, 12 Aug 2026 13:41:04 +0800
Message-Id: <20260812054105.102637-2-hao.ge@linux.dev>
In-Reply-To: <20260812054105.102637-1-hao.ge@linux.dev>
References: <20260812054105.102637-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3jdf9i7o6qzxfpshjt81ipogj33197si
X-Rspamd-Queue-Id: 4218FC0008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786513263-748664
X-HE-Meta: U2FsdGVkX1+Iz+bQcXwQvlZO5VHKSEbQr0E5J7W0yQB1oqSYOCsX/6w9dxLuMzWOT4UaBGy5VjgnJdGg1Q2tV1zrykYTH66V1vZ0OvLIjlmNVu9FqfoDRKNyOPLUTpHwWwAnV8WqtanMMqen56Oe+9Tdm17PTvvOXqUiiT7g8ZNxb9tmha8TJuZQM3o+wqvq993ZvOtG+ks4MXSJ8bKLOMNie07DwxBEOaDXWJ0ILZ34LzixCSAQuTeidypl7AtH5B2coR1gOag+h7aSegboJDp8lNCEJjdAnQ9rXRkwcj527oZjH/cFoJPCUtPfvaf/qElVgOMXhQvy9c7uRiTDMADukQ+69EFLH1JP8dNWDvcld5rabjOAkPQouRs6+gg2iugpHDJHmPwZzvT4gbDmewkKu1AXil1OovNstOSoPEKSxayOJ9PLeIz2pCo/uFBF+2VnErqAozN+bLXibaJiP+lxf1vT5Jjn9FEkRb5Au8tJf8dxAcZjaUozwhVkshR+vSeW9LFqYPLAttEuXeS8RWk+HGIHUu4aIlqTSpf5s/1Hhm9Nk9Yh54ulAdJGUJ2+Nap637fr2JKJyp7cJU21pS6Ec5fRpYIJ2/rZD83fqtUdKs6/rllsdGlEsUSn2okbEr1RqwOaSpLmYmuPTO6RzEWAlXaN/ZruuB4z5SgwS/8VZfGd8OnTBpoH+2hDWs05Xg9gRQbtYu5glkYmCbE5SQL0p0HKwCZqAmmPgtEZU3j/jRd0SbB9P6LpC4/4STBsFxdeL7RPVdwaSa0FZKktIuw+AIZumStmPGQAWv8dMWrxJrCxiQlxzVsRChdH3yU/exhveHFOi8Wb3SL5n2c1WyV4SHYBCkpKlntH1JzKBEQMQ8SPc/D4btpJ2vrW1zHWW9yS+F435nEXzR0Pqv8Lu/BP7uOR/reTHGIHOcuHYlIXX2E/iAuwYPy3Z6unGIk3ghhptIj2Hu9My7nkhJ7
 Z/64LQ66
 RNv7n224+cnJaTP0nXyHIdmryQUQYAEU0Gpw7gQptVw9nKX/Z1HpG5t87lWXObR8qIBIjYnSAcH/s3/+Jthj39p3oiRI71/3ZRUzsqO8QDpxjkiJ5Ul4812AgmOuT4+bpxwlI1N6cZJVQe5KR8/0sKSecqm53g93n3r+qiwX++BELQb5QgCsv+RE9ljfihE99yRtzYgV3JEsnisQmj8tuHVjP+H2dyYO6xXG5na/C0px/qGevFHTRB0hs0PmnZ6AINe3YvBTEPHdvG/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

release_module_tags() is a cleanup helper. reserve_module_tags() can
also fail after storing the reservation in the maple tree, in which
case it should call release_module_tags() to undo it. Move the helper
above reserve_module_tags() so no forward declaration is needed.

No functional change.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 92 +++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..af44f90379f2 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -835,6 +835,52 @@ static int vm_module_tags_populate(void)
 	return 0;
 }
 
+static void release_module_tags(struct module *mod, bool used)
+{
+	MA_STATE(mas, &mod_area_mt, module_tags.size, module_tags.size);
+	struct alloc_tag *start_tag;
+	struct alloc_tag *end_tag;
+	struct module *val;
+
+	mas_lock(&mas);
+	mas_for_each_rev(&mas, val, 0)
+		if (val == mod)
+			break;
+
+	if (!val) /* module not found */
+		goto out;
+
+	if (!used)
+		goto release_area;
+
+	start_tag = (struct alloc_tag *)(module_tags.start_addr + mas.index);
+	end_tag = (struct alloc_tag *)(module_tags.start_addr + mas.last);
+	if (!clean_unused_counters(start_tag, end_tag)) {
+		struct alloc_tag *tag;
+
+		for (tag = start_tag; tag <= end_tag; tag++) {
+			struct alloc_tag_counters counter;
+
+			if (!tag->counters)
+				continue;
+
+			counter = alloc_tag_read(tag);
+			pr_info("%s:%u module %s func:%s has %llu allocated at module unload\n",
+				tag->ct.filename, tag->ct.lineno, tag->ct.modname,
+				tag->ct.function, counter.bytes);
+		}
+	} else {
+		used = false;
+	}
+release_area:
+	mas_store(&mas, used ? &unloaded_mod : NULL);
+	val = mas_prev_range(&mas, 0);
+	if (val == &prepend_mod)
+		mas_store(&mas, NULL);
+out:
+	mas_unlock(&mas);
+}
+
 static void *reserve_module_tags(struct module *mod, unsigned long size,
 				 unsigned int prepend, unsigned long align)
 {
@@ -922,52 +968,6 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 	return (struct alloc_tag *)(module_tags.start_addr + offset);
 }
 
-static void release_module_tags(struct module *mod, bool used)
-{
-	MA_STATE(mas, &mod_area_mt, module_tags.size, module_tags.size);
-	struct alloc_tag *start_tag;
-	struct alloc_tag *end_tag;
-	struct module *val;
-
-	mas_lock(&mas);
-	mas_for_each_rev(&mas, val, 0)
-		if (val == mod)
-			break;
-
-	if (!val) /* module not found */
-		goto out;
-
-	if (!used)
-		goto release_area;
-
-	start_tag = (struct alloc_tag *)(module_tags.start_addr + mas.index);
-	end_tag = (struct alloc_tag *)(module_tags.start_addr + mas.last);
-	if (!clean_unused_counters(start_tag, end_tag)) {
-		struct alloc_tag *tag;
-
-		for (tag = start_tag; tag <= end_tag; tag++) {
-			struct alloc_tag_counters counter;
-
-			if (!tag->counters)
-				continue;
-
-			counter = alloc_tag_read(tag);
-			pr_info("%s:%u module %s func:%s has %llu allocated at module unload\n",
-				tag->ct.filename, tag->ct.lineno, tag->ct.modname,
-				tag->ct.function, counter.bytes);
-		}
-	} else {
-		used = false;
-	}
-release_area:
-	mas_store(&mas, used ? &unloaded_mod : NULL);
-	val = mas_prev_range(&mas, 0);
-	if (val == &prepend_mod)
-		mas_store(&mas, NULL);
-out:
-	mas_unlock(&mas);
-}
-
 static int load_module(struct module *mod, struct codetag *start, struct codetag *stop)
 {
 	/* Allocate module alloc_tag percpu counters */
-- 
2.25.1


