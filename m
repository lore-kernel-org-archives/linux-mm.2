Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791E9C5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 06:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835266B0921; Mon, 17 Aug 2026 02:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C856B0923; Mon, 17 Aug 2026 02:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722606B0924; Mon, 17 Aug 2026 02:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53BF16B0921
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:27:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6A001406F1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:27:00 +0000 (UTC)
X-FDA: 85109778600.17.2E79B40
Received: from mta1.migadu.com (out-84.mta1.migadu.com [95.215.58.84])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00994C0007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:26:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6LbZYdJ;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.84 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786948019;
	b=ct4vVHQnvY7daBdH234iVH9oPEoDNgfZcC0/+77klBQgHSmuCdJQn6TeVefrz2oxsgrdjK
	kBswCG4VwWcfI8LXOWUtKrQoFPMOGzuz7fdU3TEkK0O3itQf2GWo5zZG1sKOYVm2aUe6at
	/ZQVnylHR1TRZZ7x5IU79H17wS5iVo8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6LbZYdJ;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.84 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786948019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0PMvdNu7veelu0uVn4CMMLM6OdXFaU9gxzcLpwuQCU=;
	b=P8J0+PbJmidJPmKgiu0OLoDmXN0hK5tskAHcKtczzX1Uc1ueuL1iPnAUYNLGy1vHzuR6SQ
	THhBWdH4tqeCG30wsDxx0gvdMKFOHj32ISIpuHwHjsIJ/EXNycrzbrnpgC/lIgeYAfd3/N
	d12OWwBa1UGLn45yaqTNtL7dQDpJOmI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Nrl5tHbT9eQhQhzooTC92+qQ11qduWmutBe6i3Oleeo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786948017; v=1; x=1787552817;
 b=f6LbZYdJbh+RYFONAlNMXgMCY6QH0m73I0gQkFwtcV5vUoPEq1W0rJI/BDaJSUr6yKX2kkcP
 57tl03izkRjx3CJv6Cr3Qab9i8hMy4S612po1osOSA0X/X60Qn+N0O8O50qNuWvFRbuRC2R7WrE
 e+HDGPSYtiVd7lQZ0fgYrbaE=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by smtp.migadu.com with ESMTPS id 411436bb243080ca;
	Mon, 17 Aug 2026 06:26:57 +0000
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
Subject: [PATCH 1/2] alloc_tag: skip percpu counter allocation when profiling is disabled
Date: Mon, 17 Aug 2026 14:27:25 +0800
Message-Id: <20260817062726.106511-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817062726.106511-1-hao.ge@linux.dev>
References: <20260817062726.106511-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 00994C0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wr5e6ct4d7hca6ecgj8qoiu8imkafizs
X-HE-Tag: 1786948018-178142
X-HE-Meta: U2FsdGVkX1/U7n7C5uB79NpAnfRcxr/T88bQb07z3gXvzb+aONIVpCXOdXctU2u10wS5n2TrFgkY0nxnF7llpVwygqmpOP6Xoar0gY90+uzKnv2isILnsUs5wABmTEb3TnC/yb94Syx3ehWAsdnkdoSNnM6qfT+lrT7njEByl43HRUMoM8nz5iMSh5yGZ/eI2Uc6JL+mTXursDYfbb+Z3NVJoGrAmq5fAv3FT0Z+JUxn8BM+hMZWnPavjt/tWVymsNMD4kGewD48wIvuVB/ft+6KwLq0mXcz3304DDjPEy/Rw3ZCgQCtsadgfUGdjc/z9BToGe4kMSXrP89tHmKSMtNaLsiFoKUzjKZRii8tnotYdnTxB4mreyM2R7DYHONkDiiOgkGcA3m/H/JBozvD3v78lsFXGYl2wvU5i39M5pupssqJg5WnnKyy1hx7QcR8Aa4M11BsBvwJpTxkFajyEfj6zwE7z+Ly23D4Ty6cVx9pGUO22xDWVMZDEfsZP8zECR3OkkZDF9+HqpH5wcmIBEZYRMfVw/AyVO/b+iHuq+XzG+ySG8ectr5VShwPq8Ch6mPpaQtMG69gQ0VHHCUFj5JbFv3DooxgK8F2I28AuGnop7zzIKq1MWCtHRJfdNnriVq0KdYdL7JHTNTUcni5Wvgf7yfethdlLCjBPVKFr3MAvzc7LY0gfFi5NXsiDEptLqpwHsAwGhY/GqlAkM4vljVuaySdLC4jxhy8ZjbL1QDmyuW3JXZxFbjg0rxDINPMJ1IY3KLUvK6HN5KuX2vUAFPsnitEMt/MBVacxP6jsjd2/+5aHoXu5e82LJwlOzqsmJ9qryhNDkKvX2i3mVTPiomsjCz8m367keI40fCqI1mF08BTD5qtrjYalYBJfcVljJAzUYPiCM+tn+eCEMTJQQDut4Q6jYuvBxvbHA+fnFYJY4hp7kK+FRQI2TMLZmIJ7x379KwFOBc0XSFPnEt
 CpI9OuWy
 kJzGgZlPfGnNhJwB/JHAuwd9ogggY7g8w4iHi2sf6jWXDFXK7GDrTBAr1ADrZMQSoQhpOlnFeeFoumtPN9N6daWpETGJdRetZ45oEGzsYqJ2HVljulOGpe0Z2BjTHZTtMHpkH+QhMocTzr8aEIsQ5N8tLVai32TqvaoPo68JJ0E+Fx1rxrFFT0I1UVoBLWF0emSgAi+z82bcYSfoZ2H+GZ2CH9ZtEvWHBML8KpEovTosjV1TCmSJfvbzhuW/PuwpLHkbKafvfGii5qjMkqLRPvE7SVQzl9BGSe+38dSZYgZTMtmW3ma+pd1HstVT9lN1SbI0K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After shutdown_mem_profiling() clears mem_profiling_support,
needs_section_mem() returns false, so later modules have their codetag
section placed as regular data and never enter the alloc_tag maple tree.
codetag_load_module() still called load_module(), which allocated a percpu
counter for every tag; release_module_tags() could not find these modules
on unload, so the counters leaked.

Return -EOPNOTSUPP from load_module() when profiling is off:
codetag_module_init() drops the module's cmod, no counters are allocated
and the module loads without its tags. codetag_unload_module() now always
calls free_section_mem(), since a module whose module_load() returned
-EOPNOTSUPP is not in the idr but may still hold a reserved section.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 lib/codetag.c  | 10 ++++++++--
 mm/alloc_tag.c |  4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/lib/codetag.c b/lib/codetag.c
index a9cda4c962a3..a0b600720afc 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -240,7 +240,9 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
 
 	if (err < 0) {
 		kfree(cmod);
-		return err;
+		/* -EOPNOTSUPP means we can load the module without its tag. */
+		if (err != -EOPNOTSUPP)
+			return err;
 	}
 
 	return 0;
@@ -388,7 +390,11 @@ void codetag_unload_module(struct module *mod)
 			++cttype->content_id;
 		}
 		up_write(&cttype->mod_lock);
-		if (found && cttype->desc.free_section_mem)
+		/*
+		 * A module whose module_load() returned -EOPNOTSUPP is not
+		 * in the idr but may still hold reserved section memory.
+		 */
+		if (cttype->desc.free_section_mem)
 			cttype->desc.free_section_mem(mod, true);
 	}
 	mutex_unlock(&codetag_lock);
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..80eccaca665a 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -975,6 +975,10 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
 	struct alloc_tag *stop_tag;
 	struct alloc_tag *tag;
 
+	/* Profiling disabled: load the module without its tags. */
+	if (!mem_profiling_support)
+		return -EOPNOTSUPP;
+
 	/* percpu counters for core allocations are already statically allocated */
 	if (!mod)
 		return 0;
-- 
2.25.1


