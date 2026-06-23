Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB0FCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F0E6B008A; Tue, 23 Jun 2026 02:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F73E6B0092; Tue, 23 Jun 2026 02:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDAB6B008A; Tue, 23 Jun 2026 02:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 068A06B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:52:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 711991403D5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:55 +0000 (UTC)
X-FDA: 84910259910.23.22B015D
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id C28744000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G+ifmTq0;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782197573;
	b=z3N9f2Gfa/8Ygb5fofwfgbMxji6kCDqFWgh+tcmXtqZN5i3dSePHdW555j1a1iCRqP/T9Z
	THskwXkd8XFu2L9ZE+XlkaH5OcvHCd9BFRGPUGo5QTl1RgtCIiyCmE4XjZu3Hspr0rV5R0
	EQFODI9FFpF2J4EX+lIjLFivWZIFma8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782197573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dUyOBnUAmeOV/VpmEyx25JanzSfW2aamrhE6D4NgAk=;
	b=fa9q/7KfpS51MEnAcHjQCUynZ3yRtP2u7behAJh8QiQMPaW/jYZxtHUFyd08cBTB8E/oxT
	aIxETo2TbKttLnfWtjyQafpoBYp3Zsu9/DoQ/DenjJflVr5E95haEKUo4U8SJ+cXjDo76g
	FCE/Kk65Vv8FQfLGU6FNzrZh2xlQqDA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G+ifmTq0;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782197572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0dUyOBnUAmeOV/VpmEyx25JanzSfW2aamrhE6D4NgAk=;
	b=G+ifmTq0PVVelMYucTQ6pV5/6muw3la89CPy5zYvWWEh8aTHUPxICkMSXNwvapfFj66ZK7
	Kz1U0h00Iu+ylmDVXYBnoSB71Wn68XpIJ3bz4Unbf8Gk/SzIiw6lINtipGTFCAHYKvkyEC
	xCsiIq5D1u3sjEbCQSRFb1CZ84bR61o=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] mm/page_owner: use MIGRATE_REASON_NONE instead of -1 for last_migrate_reason
Date: Tue, 23 Jun 2026 14:52:27 +0800
Message-ID: <20260623065234.31866-3-ye.liu@linux.dev>
In-Reply-To: <20260623065234.31866-1-ye.liu@linux.dev>
References: <20260623065234.31866-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C28744000B
X-Stat-Signature: 8hpix33kpap3yddbxtdprdamigxrz4pn
X-HE-Tag: 1782197573-135195
X-HE-Meta: U2FsdGVkX18h17VrpUrd/OHT9k33SL8tR4jg80H+VOvYk1UXofeMDPf2DqwKkK83dayreGz94xJKKFLyT12NAdk1juEIq7QnUT3Bi1ZiEYUAvylGcSXBJ9G8MlVqGbHNymYYVYoqy+ZcG+8oxXNG5QOTGhhnTvf5DnXHOH0V3NJiA7FXwswrRL1wzUmwb4S3emeJACBEd+NC+NsBEZ0EbJr+enOY3YMuBTE7HrCUsufgkp6DiYxJOz5ga9YG+NMtqnFuK3DQjiI+v/sQxhpmwh1OsB7ws4a6yl8ExwvJZdt7cWNJUAnjqwW+3dJ7ILXyOakLaBziQSJIisNoU8/trqo70sRDOT6ybgNEwBGmugJhTC+nzlAFkqiM+4lgEKwO5Ua7i67UNv5K5jQcGbR7ClJJ5lIxyIw8sXRFgx7QI1VCA3fx9QVFk3tpe/UJKYqKtPC7zsFrqOC2UjBnq8skbCoNYNMrN4DcXhBmcIHjUFEzV5jBS37A4tz9GggLSBectXTdb/pb95uTuow+5/W3wuuBDEhEqoaoSKKx5zGqKJp/p0a09nALyC5s2yjMf2x4oZCYakxAUJUQfSKs5rZifAhXrS+mqfZPLg+Jdyr5CLxDqErHMDftY9TIWCYPZByLhCVZMfW+GyqAiVgfsdKWecrSyQVRUwFXRE8OmtPIkRmXrknAsaDwazxd7pZvddGS/8PofpKfEmOPzpMDSZhetVtUBNemUC0XJsE4zqcd9RGEFmNZbabUgt0mpW4sU7TOeUtJSaSCNKb3BMWws0DyelGBr+Tbx5lLvBKdbe0ltRGgZxn1g0fO2/3lbGaFfy8qN+jzRJm0bjHhKsOW5Cqv6APOJqI+8OUOJoA8F7noOjrvaQ2DGDYSRGNAVW2UeeGF7Z7mzgtSdyBMsHJj7eCy3L5wW4MOgiIMJRPADchjMLH74bvuuWgcPGwVBOo5ptEDuSgcABIPXaVNVu1Ky0C
 ViNNCfei
 W2kXL/wzSHUjygnosP7hG/O00vf8oUtre3cTJVUGmkLOBGx0d9yPkByWfYKZRCkMfw9sZl9ySF/qh+3mxruIklUkLIpPrQFEThAIi/tJYgcl7tAYdw2xXHHUFPLKW/M3a5oNKy9tmsmJQ+8otJcOgFeEex8yrAYy2MejDjg2BrzbTexN5pMg4ybPAWmAzx58p56KI0G/c/w9Nlm9xJJOWBsNZht5R9YA95XMm7U/N6OZv+imKOnuvO6wcSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last_migrate_reason field uses -1 as a sentinel value to mean "no
migration has happened".  Replace the four bare -1 occurrences with a
local MIGRATE_REASON_NONE define so the intent is explicit and the
magic number is eliminated.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 342549891a8d..ebafa9d7ff07 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -21,6 +21,13 @@
  */
 #define PAGE_OWNER_STACK_DEPTH (16)
 
+/*
+ * Used to indicate that a page has never been migrated, as the valid
+ * migrate_reason values are non-negative enum members (MR_* in
+ * include/linux/migrate_mode.h).
+ */
+#define MIGRATE_REASON_NONE (-1)
+
 struct page_owner {
 	unsigned short order;
 	short last_migrate_reason;
@@ -339,7 +346,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
 	depot_stack_handle_t handle;
 
 	handle = save_stack(gfp_mask);
-	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
+	__update_page_owner_handle(page, handle, order, gfp_mask, MIGRATE_REASON_NONE,
 				   ts_nsec, current->pid, current->tgid,
 				   current->comm);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
@@ -596,7 +603,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 	if (ret >= count)
 		goto err;
 
-	if (page_owner->last_migrate_reason != -1) {
+	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE) {
 		ret += scnprintf(kbuf + ret, count - ret,
 			"Page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
@@ -667,7 +674,7 @@ void __dump_page_owner(const struct page *page)
 		stack_depot_print(handle);
 	}
 
-	if (page_owner->last_migrate_reason != -1)
+	if (page_owner->last_migrate_reason != MIGRATE_REASON_NONE)
 		pr_alert("page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	page_ext_put(page_ext);
@@ -826,7 +833,7 @@ static void init_pages_in_zone(struct zone *zone)
 
 			/* Found early allocated page */
 			__update_page_owner_handle(page, early_handle, 0, 0,
-						   -1, local_clock(), current->pid,
+						   MIGRATE_REASON_NONE, local_clock(), current->pid,
 						   current->tgid, current->comm);
 			count++;
 ext_put_continue:
-- 
2.43.0


