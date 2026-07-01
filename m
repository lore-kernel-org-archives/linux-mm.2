Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16F38C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8696B00A9; Wed,  1 Jul 2026 02:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77B36B00AB; Wed,  1 Jul 2026 02:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D691A6B00AC; Wed,  1 Jul 2026 02:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC7026B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:11:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42ECC1679C9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:31 +0000 (UTC)
X-FDA: 84939185982.02.B41F895
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8C9EEC0003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="iko/I6mh";
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886289;
	b=tthPvwuC9SUDgWOOrSJHVgTNSnv4LAHE6GAlclO8pwRtgg0goSuP+FUzJXPAOYRIYG3Iz8
	b3d9GCaVEuXetnD7AznXvgGvc0HahzirgDTDK6kqJvJpuFKJHP5+QTytiAcS9cYBFy3FE/
	kdRB5NuLSQbo4h3FNZWFr9gbv00RisU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Uz52W8u4KLE/aWGQJH75bXXpHks/NCvUx2zWmpBg4g=;
	b=LQGAMK7xhBbQ8+4cJZO0TpVaJkV+ZMrySvTg0j1YUxCqy9+3RMDHab+/uZ/XuRQ73/YJg/
	UB/szmBQaiJHEdz37r4N2lXIgq1fY3Ylo+JH+pkFhHPb77X+69HtOxwKuhvF40yDx4IPqF
	Muwh/4UtHj8Sj1bce2BUYo3I6fXCUhw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="iko/I6mh";
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Uz52W8u4KLE/aWGQJH75bXXpHks/NCvUx2zWmpBg4g=;
	b=iko/I6mhDklMHU9Av9nnniz5aa2jVuM3/ZmVAzK3hNkRwZUaeehoM8GoKgJufwtelvlREa
	Oufuu1DvfhdeV9rOrj4R/rc1uDI8kOiM9IL6dvm+YoAFjDHZvQwlhuR9JgN/QNnY4zcr1+
	qfGmikPXBZc94e5AkMUoW8zm9E4betw=
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
Subject: [PATCH v5 2/9] mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
Date: Wed,  1 Jul 2026 14:10:45 +0800
Message-ID: <20260701061101.344679-3-ye.liu@linux.dev>
In-Reply-To: <20260701061101.344679-1-ye.liu@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: x4yqy7eg3r9ogeoeguscmd614gmrkbxj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8C9EEC0003
X-HE-Tag: 1782886289-609836
X-HE-Meta: U2FsdGVkX1/GXtyOtUhS/NmTocS8MIdEssAkljk4aWdi2RpBay4guIGqSO+8Z9v9RoFhi58mmWVwQToTehHWuq6RfvQCmRwKLiJzsPlw3YO//F+gHqIXvX9bFj12+vrFxztBn2xv8klzcP8Q3I66y8GcndEhp9HdHcf9xMEJiUY2UN/v8lrVGVaLJcARYjMvI7YVfFcMRV7ayHfEPvU5d2ibA8Emmxo12MFxnnekLpnAvawp+3ZDvgD27E/4MhxxmBxQ79v2D8Dj6rG/9IaTPmCE6nDuMLdg9DgASNeZfeOeiOZP2tqTNletv6mri3cLRqZOYlhUz6pDzi36zzGMCdOgd/55sK4Za5xMPz9ydKRnKiIyz/S7JpB1bbcsYhWbRxXfoKi7wVuv+TdqsUMpScAKg2UkzAZM6RQEViOhkRuIY6aHY4d/NYijlb7mLdh4i7I/qJkroTLgS8gO/VXljy3Aalnm6z4SxeOW+dhd1zJ3sD9uZ541HFn3gmjES+WzWAI2mr50jG05cc3rxDYQmfjjpEpscYZBEDIBETvLbzUelgfXL2cxS0WE5pnofCtPR+3ayw8K7nGuFFqEUzwewT87tZ6e0vBELC7XxnLnCFAFh0v3xKfYDhHtFRYOokdqdRCCOKUL6bxl6zBZlOjU9QePcnQKV01oXbCvSqQdfPN1f/OfuPkuSThbA8OypcQTPzfHpUjv98tDLj2aUBdP8KLRHFy4NrqoCtYI+Dr65f866lCpCQX0iflDpP8LswmygZHNymFdnLLeQN5i7QOVOQHWoaksDXMSQVQCNCFXuFYpuldwY7SorrsX4BLcgmIgQ19LR48U0YsSCMz/aU1BPWGPVQ7xD5uvd5cdQ/MYY6W2Er3LsLQJp1cj8HaZl9rWLpC/rCTsX5+SZJvlQYOyDRIpwB6Ms8xyQxMYG0pucPwrKHkjaLPFcNOz7KUpleKWl60jVjsdAkfqPyDRaqS
 1BgdeLjJ
 Rmwv3XZodHfXkZWKXwuDPlLsJoQmimmi7u7XJ60Uq7BkB0vexRHO85dHzJ623lgvPbxWyiTE3axQJoVO518ic80oWdu1Zc0Y9tVXLthYLe2M/SUgTsHPH3RXqiZ+0XAo2DIDIq770vupR7b97jGQ0/2k+UfwK0eW7JUImOYquwJS2VJzULlAEzvQWYfIdau1Sm2Ic6sBDTyjogyUdo8Z6ikiUn4UdmR9CIE5sR461AeRC8xHaR/07rLTB9u7sWuxB1jPs2PV4K93lo0f1VJUsc0mUoBKC/uQ11UQg12dIpJxrTT1cccFEOoA7A2LOCDReGy3XX1yp2hgSdGJZkxVfaHT21aSh/71jOwdoYxvspOkIOS7PhJzVJ7TSiPTyxlfYKyeoYsreoHts/mg=
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


