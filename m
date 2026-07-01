Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B329CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7426B00A9; Tue, 30 Jun 2026 21:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467AB6B00AB; Tue, 30 Jun 2026 21:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309916B00AC; Tue, 30 Jun 2026 21:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB1BC6B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:23:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 477C2A01B9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:11 +0000 (UTC)
X-FDA: 84938459382.20.E1FF1C9
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 88C0018000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XopNAdgM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782868988;
	b=NdYTn71lGm/lA035H48i6fisz/zgjUX94xFXI6koUW269MgXTQbvc5SFRsPn14UClcqn7i
	hhD8Or3B58ri6UrcCwKA6x+op3sYKR3V41UxYdnzwOrIhlBVkymQkkdt+yhQ/61qI1F19F
	KfM3ONniOW9q/3bQub/BlMYDWl5ftT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782868988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Uz52W8u4KLE/aWGQJH75bXXpHks/NCvUx2zWmpBg4g=;
	b=sFnxCNXnGnPdEzkZQbwk15/HhPP0ilZXYpmKfFmEIYfAMbikrB30L/qLw4I/rBo21rsOlL
	aAk22wXbDcVPRtY47fLIdlOC0zOixCmwYW42IGhNx1dDgkZcZWhao5Y3ahLjbEDRwqJGvI
	COmbW7WQJs7dZ6SqR4J71JQoctMSZVQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XopNAdgM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782868987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Uz52W8u4KLE/aWGQJH75bXXpHks/NCvUx2zWmpBg4g=;
	b=XopNAdgM1RymsQi1j5g/juFlb8A8mkH9/ZoZ7LNp1P54XcV3LX5YOgShubAupbGeGfj+De
	74fskIOSFAxyda1qc/hhw0aS79zVqgOoV8fZm9NijKOywzt2W3qBwCYft5EBXyrXu7/fUr
	dwD7U0Gj1A238aOWHMlpcjZePfR7xyA=
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
Subject: [PATCH v4 2/7] mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
Date: Wed,  1 Jul 2026 09:22:28 +0800
Message-ID: <20260701012239.315262-3-ye.liu@linux.dev>
In-Reply-To: <20260701012239.315262-1-ye.liu@linux.dev>
References: <20260701012239.315262-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88C0018000B
X-Stat-Signature: 8tcncneg19n7iesdagewrioymp3ezdac
X-HE-Tag: 1782868988-293317
X-HE-Meta: U2FsdGVkX18Xy2fJEFxC8cAbMUqODOcD5clvWRJB+6NxrugJld1YtHrI3ANMFLrriJ1I1lggEpKTZRI5RZc6wnzcqKZKj/urqf9xLjus5GqZ+coiIziGNsiIDv1n86pPgwPDiDE2ZtIq/iH311W5xu5Qtd+yjSjXwKOs10sZsMZn7U21SZ7++SljWM2UhTdkRnuikTXmQ0X6DxGofbnrUGpQKNsPZsTBgqwXWtwqBUpE9rieydeQ+VG1Zzk5Y7ImCsFFqQXjkQvsmkm7nF6Mikkm0tcFFsvqbKQxNDAkv447YiPgt0jl4Ulkht5YZBW0JLvX9OzXefD/gIuJU5YE3LgyK2NXZbkzrN5UplPPLzTN9m0IFbizK6wAoSLsDO9VND4YEj/Yj9GOTVumcDpCAhIZ+nT4Rcoc1BXXF/QuTe9GjWEY1XMRxoW9J5jdjXq2Hf6dqpCvDBnUNooJbiCWAHojm8hH2zGW89MG6AhQSFfVHSQUPmoF+hmC3U6ce1Fy2+ZQK+Oz8gebM6GC4P6WvDaXm3Oa49hUmWyfrWNYwButLOvCxcR3kdHdcmS5Jj60Z106R3bu2nTsN8flY5LaURGOdSTGIq16l/bvawerqV57mddXydMhWjHXFnzjpsMCHilvW6jkU7EhJjKwVTwMw1gOdwA3gU6DeQuZG5KfIrsjJX0Q+93bfm7HwUk/tFz2ZE0LDSEYaT7HUgJLGHUhof1Ayh+MR6bifQXRMdBFUjbglRFq91TA0GR0rseEmkInInIll4txCDgxhiEHz/NO3re04Pk67UBPIfJbVQBY4U3IQ/MLk+iq21/oNWc610gtT9yEymX14pSJY4lhUfY8onCm3IbwzZWVRqHFBR6CGpHgddWO8fzkO8xz+XA+yfcYu9/j3tMRZZCkTBv14+qIUzRG7BthWxIqg/WEBE6mSMEg8pA5VfuevGrEjYcQAygKc72kv0UFxjrCg+qiL7i
 B13Szlfc
 OQRDo+fEoeVw9Rb6CTYuWovrLk/UHRztj3lU8ta0mh7aY3hWYFkMOPjuNs7kSwZPfaAHpziBhSKHuqDZwj1QKuZ7Z8AeEVVJr10gHQVCrlT1WIZAQQpfrcGz17tpSKfTzEFxmcXhW7V+gzlQTx8jqXCMBM/DApK0psulrB8xBp18Zf936rr1A4E3mneZoyepQAwdWMobe5Rw/cfDZx+B0c/WmRwBzvowWMaom1jZKF6iKPuzjn3Foexbr8z68RHlK+f7Mq2O/hxnkuiMmpHtd9Nmqup6P+qLq4feutNk7V565KHZH9bgr1nPiaBYJtSxI9l7/6BrboOJ5hjUkt5Xb9V77PXm1fm8GBwxPk+ZXw7VSPluYyhozjYneC0sCiZyZ63diuqG7oz5Qwx4=
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


