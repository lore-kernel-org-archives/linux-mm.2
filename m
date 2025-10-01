Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD35CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 17:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BB58E0008; Wed,  1 Oct 2025 13:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63638E0002; Wed,  1 Oct 2025 13:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA05A8E0008; Wed,  1 Oct 2025 13:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B79FA8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:56:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6890983BCF
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:35 +0000 (UTC)
X-FDA: 83950300350.20.C558608
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id C64534000C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="joDiFQJ/";
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf07.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759341393; a=rsa-sha256;
	cv=none;
	b=bB1ORVr3JTahEFHO+dFkmjle7kzg0RxtxJ8ybPzQMIa35s2/SXuLOvAJjO2fnE/AKg+KKQ
	TC5W1PUmdlbyxcvT5bZzfYYZo607CSmh/qwznA3nH88mksfOIAtB0Jfm6Yt/RovqIsmZvd
	EQiCLRLxLeq15kIFjDbdA0h5lOCkLC0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="joDiFQJ/";
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf07.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759341393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Yt1tx1hSW4BERbOPJZtMQAF71fcPnG6q+/M6LLWaWU=;
	b=7DBtenynP6uwP/KV8x5/2ngCkrFay2CsnVWnGvwQM4Po4dzxVBhPQGVbDNam85pGr0acy+
	ciW2HBpEpNwpqFolhL2rUqRlAj+c5V7zzzTUCg6hhzJYSpIIcmRsgrKkXZpN2BjA7EcYwg
	UhCKcaLUoz6b9EiTTkDUO2WTci4piMM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8Yt1tx1hSW4BERbOPJZtMQAF71fcPnG6q+/M6LLWaWU=; b=joDiFQJ/fpMabMXZVaNDK8vUS1
	kyoFyUPQkwqGmJ8AnV01uDW0mP9zJhCegyxoIqbcvlFQjbL3eK9ToZsGdrl/bUKzHB0sJidvkWQvR
	k07yWhlMGjQdCYrX3wDJMspzuxxERLLkmZhrIpUqXNnvSIaBMheFkV6jqPlt7QFByjszvqkPbRO6b
	4JnVfwuXwf2Ue0Rx4faKUXDH6kg3hFRK1PCEe/RNLDJE3ZMH3bAzX0JnWDuChz2AMjnsnKFuNSsHJ
	P79SOeZBnJshgVzCV40ejsUqFauAyBo775lddWTbVTz8Z15JxWclrl4fkIOfEE5KPbnJUD9siWGl6
	rJH11IGg==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v4140-002xd4-CN; Wed, 01 Oct 2025 19:56:28 +0200
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH v2 2/5] mm/page_owner: add struct stack_print_ctx.flags
Date: Wed,  1 Oct 2025 14:56:08 -0300
Message-ID: <20251001175611.575861-3-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251001175611.575861-1-mfo@igalia.com>
References: <20251001175611.575861-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C64534000C
X-Stat-Signature: umzktu5gj3447bjed4eqy4oxhcjkt96h
X-Rspam-User: 
X-HE-Tag: 1759341393-575776
X-HE-Meta: U2FsdGVkX1+fT8TNC8blDcrOQalguC3ZLzGO4p1n/4Sxml9bGT9CjxL56D0G7Sbmp8Yyo5RELcgzkmvwLT/aU4/5L3mCIJuXz9EdUFzS9v6APd/N7PyUApk3cmmic9VJtZrlf5KqfXEB62vH5LArkjUGEa5pWuXp3XWLfU+MYbESyqtsh0UUEwbSo4T+xuFfuXbjWeIxo9LjDfrwU91UOGNpM1C4PJpYhrkWmfhuknonaK3Skf6e2v+qH+J62DN+7Qr6Zk4xrC+3Xi9LWYxoJIMDydxmJQuvtly8lOR5X1wFK/MxKKCPUnqEPBdC258cP5/bq3KWJAND/EwGzXQIwzb0lkYiGUgrhzLpTXW8WnFOiyc5bfMqiuGT8VzqBHam8EYRUBBnjY2LrS96SnezEelOC+N6+93jtt5boDrXkSQF/J/1zdhcX+nhXebedR2G6VFM9of4ZpbU1pyD6IW9h+DLv9Cgr3geGFprAbfxl/6VgSY8Gix62NCQdtmBT/RjPPktpFvKGbpz/a1BMtexiKGrU9pEMeT9fAKXHn1fXVpYBTLS/j8zJoWvoDzIRth+HcH6m+NzWCfKjkHjbiuNbBj39riFs03tp86G+QNZsdbLV2CZ7liKOa6WEsG+ZyJCrCTZ+iiIe0LzR1hfN0Mi0sLEndAy/w1FHcz2/0ru5gIW0/uNqcbPr2BFh5O3/C3TEPd67txAov4+C9+4+8kZ0vO3FoDyuXYecNuJrZj1REZiolbjOFNfZkuHOskJi47Q7BlA2NLciqNhnHs0d01wOGpQ6Hxo9JjtRDlgIDzNtlidl3hq4DubCUa/YLpHwJSzSzx1vUcT2ffRBExJCFrzJulPsqitARtGvRovVr28Zlfx/OQOuoaS7RF7CVx7Mb0bCGrh25l9HQ9Ht41XZY+5Rb0dQrRHMU4MbAfWUSS8yfIgxOUr5040jPwwuWJi2iJHXLSLnCzpuOXTKuu5I4F
 VnPU6Xv5
 vmPH/n772Itj14Y6Ll0bt5pktBhx1JKaOVDDxPnabMkjbBSCeEynnl7hAZr39yUG+aAPB4uv0TnRzC27IO+bw3sQmZDk83Qnf/k0dYvmWFFn7jRHx+7p1LHFJf4JM6Z2Am1aOHJ390xqCrmerljCTlR/Pj7KhcSFc5AyeHWYVd9d/2v1Tk0VShx8aakfyB33fMGC5OdAqONwPA0CQw1YgjLhsN6hzyaRCfZY5AKP3Vgv5cB1u/ZbCuN/PvZxDEoev0iD+qap7JB10Tovvy9Ejw0n+OmF2s669RL0vQugCJGYYeJeKRiPfRWXsIusfMnWorQfF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the flags field to stack_print_ctx, and define two flags for current
behavior (printing stack traces and their number of base pages).

The plumbing of flags is debugfs_create_file(data) -> inode.i_private ->
page_owner_stack_open() -> stack_print_ctx.flags -> stack_print().

No behavior change intended.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index c1a7d7afe945..e983ac21a4db 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -45,8 +45,12 @@ static struct stack failure_stack;
 static struct stack *stack_list;
 static DEFINE_SPINLOCK(stack_list_lock);
 
+#define STACK_PRINT_FLAG_STACK		0x1
+#define STACK_PRINT_FLAG_PAGES		0x2
+
 struct stack_print_ctx {
 	struct stack *stack;
+	u8 flags;
 };
 
 static bool page_owner_enabled __initdata;
@@ -901,20 +905,24 @@ static int stack_print(struct seq_file *m, void *v)
 	unsigned long *entries;
 	unsigned long nr_entries;
 	struct stack_record *stack_record = stack->stack_record;
+	struct stack_print_ctx *ctx = m->private;
 
 	if (!stack->stack_record)
 		return 0;
 
-	nr_entries = stack_record->size;
-	entries = stack_record->entries;
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
 	if (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold)
 		return 0;
 
-	for (i = 0; i < nr_entries; i++)
-		seq_printf(m, " %pS\n", (void *)entries[i]);
-	seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
+	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
+		nr_entries = stack_record->size;
+		entries = stack_record->entries;
+		for (i = 0; i < nr_entries; i++)
+			seq_printf(m, " %pS\n", (void *)entries[i]);
+	}
+	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
+		seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
 
 	return 0;
 }
@@ -935,6 +943,13 @@ static int page_owner_stack_open(struct inode *inode, struct file *file)
 	int ret = seq_open_private(file, &page_owner_stack_op,
 				   sizeof(struct stack_print_ctx));
 
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		struct stack_print_ctx *ctx = m->private;
+
+		ctx->flags = (uintptr_t) inode->i_private;
+	}
+
 	return ret;
 }
 
@@ -973,7 +988,9 @@ static int __init pageowner_init(void)
 	debugfs_create_file("page_owner", 0400, NULL, NULL,
 			    &proc_page_owner_operations);
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
-	debugfs_create_file("show_stacks", 0400, dir, NULL,
+	debugfs_create_file("show_stacks", 0400, dir,
+			    (void *)(STACK_PRINT_FLAG_STACK |
+				     STACK_PRINT_FLAG_PAGES),
 			    &page_owner_stack_operations);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
 			    &proc_page_owner_threshold);
-- 
2.48.1


