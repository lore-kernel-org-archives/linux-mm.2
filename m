Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41EC9C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1356C6B0098; Tue, 15 Sep 2026 02:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10EE66B0099; Tue, 15 Sep 2026 02:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025136B009B; Tue, 15 Sep 2026 02:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF99C6B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:59:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53FF580335
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:17 +0000 (UTC)
X-FDA: 85215095154.16.C088C47
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D44240003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dz+c9LRn;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789455555;
	b=3GLL9XvGibQC9n6CwgOglDVIIbrHkWF1+Whmd3dz0cwtiYzIQxPSeHyQIv6gdca+iYaVr6
	JrM7Dqr+yNgVUv3NphdzYDkSyt//zv3cPRkm6PZIVpOo4RR79XcAjwQZyPj8VF1xcONe+3
	AHF4AO+c8DjbGsTTmUvaxW77drI3sek=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dz+c9LRn;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHuVn8hUbj7N8TDfyEoDPKlG2yZcH2DzDBWw+EBJ4/g=;
	b=fpm1W3EiRNFcSgCOcJpcCPBBoL3OzVsrJxII+IxH8Yc7LrxDejEzZ3l3bM3NNp1ghXSLxP
	k0zaT0qUxAbGBwUZUa12AV5pqBOnYZuqO2zu93bJ3mWc4+adD5l/cBtybUvX4ON6E8MmJi
	/1NmJIfZbws43mbEQFeHsJZUD1b8TZ8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1hrOUU2WscT9i12+q2dsMTJyNqNUXrCyPWNHR9ygX74=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455553; v=1; x=1790060353;
 b=Dz+c9LRn+U4BKwUguORIFZqNQQxieg5o6zVodNBkoC2JEXt8UFf3IAGlY2Ygdn+0XcweaVfN
 RyzXkNvwdBOTnbJydG4u2KGY58++n+UcMBnQKR4CbLBnkhksvsIBdLOWisrIpXrFWhTKTay03rA
 jLB+iD4fMXYWigsmUd+sRAvg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6a28f1219eb0585b;
	Tue, 15 Sep 2026 06:59:13 +0000
X-Mizu-Trace-ID: 6a28f1219eb0585b
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
Subject: [PATCH v10 1/6] alloc_tag: move release_module_tags() above reserve_module_tags()
Date: Tue, 15 Sep 2026 14:59:56 +0800
Message-Id: <20260915070001.113559-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260915070001.113559-1-hao.ge@linux.dev>
References: <20260915070001.113559-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D44240003
X-Rspam-User: 
X-Stat-Signature: esonhkfatw1qqc6oo9djwbaepmqoas33
X-HE-Tag: 1789455554-566221
X-HE-Meta: U2FsdGVkX1/f21ACpVLWup3N2QFugaww7s0FTf/kFHEiBC5h8CL1LdiuRfGxd52ctO7CiKf3AxhV3GK2CNyiA/Cv7o8JMjr1Fp1ww/3FLRoi3e7X22MRaC1ifO+FZcuep/LZo2DDo99gAuWnUPSxrDBqrvuBE43w2+JxvgPGzSKhNKGN7CmyJrKBjYhX9rhxv6ZRAajoy3eJIskiQ35w3FPqtzUmdj0Rtbu6MAkrt71vU2hdUEt3qGDDWixIeYoJTcY8JF2v5d3Nvnl74/QWu8lFxpjJD2T4LKNUS5NrdPm+fKhTLRK1dpfXWI1NF/oy9eAKTHTy5T88NoGqJ+2k2xiJwDTIaD2TFlvG8vySvEs5VyMuRc/La528rQOw85i1Nkv+mVfq8D4Al1jxM+v6xM0r6SjC+zq+RjrLE1Hn54spwT1DuhLKXYCCc/itmKHg1T0LHQOj0uVM/O1ve3WVOELH2dLS0aS7eTvwvpEZWOUnqL4+pcO/D7ik3ni/d9nUCVPBrzGzG2D8Hr+xhSXVc1mzXwCzS0jxJEiiR7ndB092+VA7Ovf3fPsCdZ2k1lqf6XszcnGnKBnOm66jFyL3Xad2rQK6Q2lOFuCXlVwZKFkqzOpaeW8ehzoaOcaPh9eKmEL7Hj5xgyaNOJL0U6uTxWKKYSdGjB1OYjQrKgdgBed5mC0ln2+gZhEVXSfYcK4Wiw7XNr+4WEidEWHfi1Iph3FA6Qn9rmL/QDezbvsyvdwqjkK6mynlWFozRu14YxBdhB2+jgJTT8VTi7t2JtJZlgdufy5xFGHKHV+GNNEvza0jkWLSN7oPqpKk+sYIZtxUar5ClZfcQNg8EXy+Y/2/6xh7mFlq97qHmeQL7CEqaicGMON49KWZgzWJ/3BJ6lpVeaHXXYhzIOpQyD0k6a1qJ0L03BZkzCULo/ybnwXWIXtlwZYJnlFWYSdUndIgLjm1m0ZTdqXIjbe3+jRuoF2
 l2Do2OAr
 kKV2uZH34dOi3SDUXN516rWkFsIOcbL4Ilp1rZQy9imFSoPc8x8hqKHzRY0je+uVSK0Pq2OPM0Kc0+4cLLgJdnmAcMD+nXWFYlB8LCA0SSshDIPn7u/5ACvxkpWYXd9/NoREsi/9KuV9ReMPEt1RPu2K28+fz8uTJIEVttjZGr4m7fIxRCikYuDlS9isZjNZGU2DAClN0jT2/bLKa2DjzovLMaTjNRz/uYa4QV1V36updaL4s3vg2qd0rXKqwaGHB2VXzDHqtzS0GApZ6/njOZ8Sz/nLN0P9YwDPs7HQMdDQIe14D/IwDXuIPSDp0PWR5sWUQ
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
Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 92 +++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index b33410310477..2070e682fe10 100644
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


