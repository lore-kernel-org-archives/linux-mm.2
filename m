Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72845C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855EF6B0098; Mon, 13 Jul 2026 21:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8576B0099; Mon, 13 Jul 2026 21:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE766B009B; Mon, 13 Jul 2026 21:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFB36B0098
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:51:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDBEB1C0122
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:51:47 +0000 (UTC)
X-FDA: 84985705854.22.DAFD566
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 15602A0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:51:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=evR+b9Hf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Uz52W8u4KLE/aWGQJH75bXXpHks/NCvUx2zWmpBg4g=;
	b=ekG5RVZ1emoATZENxLcuG/PdW+Kh4SWs9GJzNxwGoFZaUq76jKzja11S0x6Boy7bkcCTtB
	ygNhy7mNY3SSkDCoLyNvL2SX0uKMP6vTnoGyzGYnfljvDzmg816oj9Z1sazf6F5YLeFcgc
	biC4Iw+PWks4yxcTJwA3waRUENyDaic=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=evR+b9Hf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993906;
	b=lLwBmGL+N1r8UarG6eOdubPnYX8HQaPXJMVclZGxOemjAV5CEFEDqK0StjzPuKEUqT+Xce
	nV8ob215lVF7QGzGhwFrvreacFOjevIlwudvJYdfJKOr8DzgaZN9UpPE9I1oRRbIr2BcL+
	zptZastcm4iaKJrWNjfeXAoLdqmeaE0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783993904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Uz52W8u4KLE/aWGQJH75bXXpHks/NCvUx2zWmpBg4g=;
	b=evR+b9HfhPd9/q4bYfexK5ghaI2i9yq2n8g+yuiWZiuKIvA9uQNlLjKbH6uaSpfOTOsidQ
	reywB8MMasH+G9WTATxb9sIRILQArxH/RHNCAf0nQqYeazABPk/D9GsbUguMPjTSk5Q5TV
	dUO659U+gWnuDhwAsO1DbvHGThKaW3s=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v6 2/9] mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
Date: Tue, 14 Jul 2026 09:51:01 +0800
Message-ID: <20260714015117.78351-3-ye.liu@linux.dev>
In-Reply-To: <20260714015117.78351-1-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 15602A0007
X-Stat-Signature: gr6j986cuj3k76ef44djhxcrz5fczwrg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783993905-959301
X-HE-Meta: U2FsdGVkX1+P//m5zxqZHZioAOZQ0nUsCw+wyhY4BnSEqjSAiV72Ildywu08pyH/p64w+wHK+7IBN+x7HPAX3PaRp0s292rtnEgLv5LJ27tZWHcGKyhMH/uzyX1R0MWLV530LGLnq8uVIUE3oCoUr17vSjADncmbPoIudQowwNl+3b7/4D1a/XZ5Hk1vs5rTLh85iZSHti0mwTv3K5jTJsgwzohYgw0tMTI5FOFVXDrGydxjDUdfBD9I/CmtN10I2FViwvtG+4m55ukE1Pwu4Hz5ezLhzWicoKI1sU1JRIczMyCF6eZnj1/AzxzfxxDaR26m7DdWIGNCqtoVMx1HFXaVBQH6CpsFd/VddT9WoKzCFSHNiin4ynnb7Ev7kEJt7qq4eZIX8PktYEG6fS+ZHH01cxIMN0zezYdpzzdNT2XZsnczXTdIZtuL8hNr/fhPigCEx8sEJROqJgu4ZVDeSdZqIDvN9pvu24hcRjdSBsn7xiB7ZjRdbDTg6gGPflpeNMhpD/rqfWBuYjvbKke+XyFQXcYSoFpAWwJxtzOujlyP9jbFE5h7p25xu7+zf2aC+IbhwVTnSRjnnB/XgaNTQ005o8O2ephUDE7oJUYqeawUpZG3iYpys7pxxSiAgLiRBNUjuZpeALLY9Zpf+p3oTQW5DfxNyPPKqs8wVJdfJXB5e8v1R9KIvd8+T91ACoeuYW1eCflLk4YU26/ksI6pssaPKmHiiV5lK4MiozLFa3/kbwNqqVSMInnYsMkh313h9R/ZWthKPkqm8jpydRbDOilmwYaYlIVGuLtTMK4q8sLZtZzCvVT3hddmHwAnOrpMm3pTFCZeMx7uSuN9JExJRu6Ba4fQV1Z2SIKOjyiboM+EEKTjg3WsOW3+GufPEE7qc3fBjbY+gLp/Bv0IBOwpCvwKAhRidJH9X3/NIPAR1VRAwVLYin0QKBf8c5e2xfelagv7yxAC9vyd93KjB47
 vDv6ymTJ
 H6XjX7/MCww0DP0DAvEHTfrYhD4YuFQLekrWagX///iYjc8mNgvu58N6gKtJLidzd78ydzoZlXPsEQ9sWcZUuh8YXFNlN7MKgxSYD3wFwi7xwPxsB9cqK6y42GgKgW92ICPioYk4bcaCsk4pN/GKRsgIY9FltkOqsmIbCw0CHcOterqbIWBwZITEbYy58t2OUvwp/oiqXBWOufk0qRoUR1DDCxlrdJBibq82HLkkYwgp3LDSh/DdfywRjQkkfgNEquf+qZ7mF0SwEjwjrnKq7IGl7nsUBMzzJTwqGkFCVC6A7Uaz9sa+aPOre8ACoxeVF91WFFadxCBJvtLk5mb6iWRZH5pgPZ4GZVAzDc/aR8+jTW9YuB7OR7i6rRXVV1KPFkKTzdIHG1DfPql0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last_migrate_reason field uses -1 as a sentinel value to mean "no
migration has happened".  Replace the four bare -1 occurrences by
adding a proper MR_NEVER member to enum migrate_reason, defining a
corresponding "never_migrated" string in the MIGRATE_REASON trace
macro, and updating the GDB page_owner script to use MR_NEVER instead
of the hardcoded -1 so that lx-dump-page-owner does not incorrectly
report unmigrated pages as migrated.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/migrate_mode.h    | 1 +
 include/trace/events/migrate.h  | 3 ++-
 mm/page_owner.c                 | 8 ++++----
 scripts/gdb/linux/page_owner.py | 4 +++-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
index 265c4328b36a..05102d4d2490 100644
--- a/include/linux/migrate_mode.h
+++ b/include/linux/migrate_mode.h
@@ -25,6 +25,7 @@ enum migrate_reason {
 	MR_LONGTERM_PIN,
 	MR_DEMOTION,
 	MR_DAMON,
+	MR_NEVER,		/* page has never been migrated */
 	MR_TYPES
 };
 
diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index cd01dd7b3640..11bc0aa14c7e 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -23,7 +23,8 @@
 	EM( MR_CONTIG_RANGE,	"contig_range")			\
 	EM( MR_LONGTERM_PIN,	"longterm_pin")			\
 	EM( MR_DEMOTION,	"demotion")			\
-	EMe(MR_DAMON,		"damon")
+	EM( MR_DAMON,		"damon")			\
+	EMe(MR_NEVER,		"never_migrated")
 
 /*
  * First define the enums in the above macros to be exported to userspace
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 342549891a8d..c2f43ab860eb 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -339,7 +339,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
 	depot_stack_handle_t handle;
 
 	handle = save_stack(gfp_mask);
-	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
+	__update_page_owner_handle(page, handle, order, gfp_mask, MR_NEVER,
 				   ts_nsec, current->pid, current->tgid,
 				   current->comm);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
@@ -596,7 +596,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 	if (ret >= count)
 		goto err;
 
-	if (page_owner->last_migrate_reason != -1) {
+	if (page_owner->last_migrate_reason != MR_NEVER) {
 		ret += scnprintf(kbuf + ret, count - ret,
 			"Page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
@@ -667,7 +667,7 @@ void __dump_page_owner(const struct page *page)
 		stack_depot_print(handle);
 	}
 
-	if (page_owner->last_migrate_reason != -1)
+	if (page_owner->last_migrate_reason != MR_NEVER)
 		pr_alert("page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	page_ext_put(page_ext);
@@ -826,7 +826,7 @@ static void init_pages_in_zone(struct zone *zone)
 
 			/* Found early allocated page */
 			__update_page_owner_handle(page, early_handle, 0, 0,
-						   -1, local_clock(), current->pid,
+						   MR_NEVER, local_clock(), current->pid,
 						   current->tgid, current->comm);
 			count++;
 ext_put_continue:
diff --git a/scripts/gdb/linux/page_owner.py b/scripts/gdb/linux/page_owner.py
index 8e713a09cfe7..eeabaeed438b 100644
--- a/scripts/gdb/linux/page_owner.py
+++ b/scripts/gdb/linux/page_owner.py
@@ -34,6 +34,7 @@ class DumpPageOwner(gdb.Command):
     max_pfn = None
     p_ops = None
     migrate_reason_names = None
+    mr_never = None
 
     def __init__(self):
         super(DumpPageOwner, self).__init__("lx-dump-page-owner", gdb.COMMAND_SUPPORT)
@@ -65,6 +66,7 @@ class DumpPageOwner(gdb.Command):
         self.max_pfn = int(gdb.parse_and_eval("max_pfn"))
         self.page_ext_size = int(gdb.parse_and_eval("page_ext_size"))
         self.migrate_reason_names = gdb.parse_and_eval('migrate_reason_names')
+        self.mr_never = int(gdb.parse_and_eval('MR_NEVER'))
 
     def page_ext_invalid(self, page_ext):
         if page_ext == gdb.Value(0):
@@ -138,7 +140,7 @@ class DumpPageOwner(gdb.Command):
         else:
             gdb.write('page last free stack trace:\n')
             stackdepot.stack_depot_print(page_owner["free_handle"])
-        if page_owner['last_migrate_reason'] != -1:
+        if page_owner['last_migrate_reason'] != self.mr_never:
             gdb.write('page has been migrated, last migrate reason: %s\n' % self.migrate_reason_names[page_owner['last_migrate_reason']])
 
     def read_page_owner(self):
-- 
2.43.0


