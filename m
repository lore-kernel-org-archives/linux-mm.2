Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE82EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96CC6B00A3; Mon, 29 Jun 2026 21:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E3B6B00A6; Mon, 29 Jun 2026 21:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A36346B00A8; Mon, 29 Jun 2026 21:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70E646B00A3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:53:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C98CC40154
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:53:53 +0000 (UTC)
X-FDA: 84934907946.07.D3114DB
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf07.hostedemail.com (Postfix) with ESMTP id 340F240003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:53:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TMgXlUlz;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784432;
	b=MWA/LXJI+/fFO2WeSwlwAAg3J6U3xdB5KayYxGMitNd+Z9ChvUhgFqlmEIgOnQWiflHQRU
	hp/5Hmafo3mFIcjxhcO+spNBlJWZzWt6m3nQuhy/KHe7/LxFNcLEvPuqAew9d9im8Teq04
	VOnz0dr1SamAwhN5qH+OencBzkWHJzA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+9YrpEU34OPDz2iHabTDbvzWefArLaf4fpVcXgkiMk=;
	b=BUZLzr3PFv6sQbT7tM9APrmIZBms3waUAetWjn/1pBctC0pPM1HSAW2fpUS3rvRr97EjWr
	RSlJRM8/5mbHgU0UCVthv24P3PTVFKMnUUQnabvQvzxZaDMTrGoRxGWHNT6BQPhAgh18zq
	IQjz9tdC/M7CJ/IiW6WwXkV7yTnfiLI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TMgXlUlz;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782784430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o+9YrpEU34OPDz2iHabTDbvzWefArLaf4fpVcXgkiMk=;
	b=TMgXlUlzodF1IoLeynZ74eaIyV4U7rjvQXiu7RJXnASDsdrob6kxCYb1iZ3Oj2sGEoImCo
	PpbCJQ3Y7D4H1RmilH3Ccx34B3/dsJZlglzP80/GxM6U5g9lqjT0ZKC4rAuGD3D7z53R4e
	iFzxQ+Akjbb+4xLM01Ojlc64dPgqoAM=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>
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
Subject: [PATCH v3 2/7] mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
Date: Tue, 30 Jun 2026 09:53:19 +0800
Message-ID: <20260630015331.147174-3-ye.liu@linux.dev>
In-Reply-To: <20260630015331.147174-1-ye.liu@linux.dev>
References: <20260630015331.147174-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 8w43fndmurfcwx7odg8spud1peyig8s5
X-Rspamd-Queue-Id: 340F240003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782784432-588473
X-HE-Meta: U2FsdGVkX18L7NahzGJTxutlt2b6CF9tDPiVztU6n2n7rjtbEQVGqzH8x7bausUA/mskhF3fUnUPquewidWHWldE+cUxSWAZ/Gr6a0Np+tt37/DsIBTePjpoUwHv7Af/i1zAWrJBzN9v4AkZnGQZMa6fMlCxVorVDoO0+yL85usEqyFaE98WaSEMnlGOPNC7jlx7u3bCnelDNNP4fEuGtKcS/zGI+sMfzUgYwuEg4tZYV3+5r8bLSAESN5sXqqw0+3qMx4MYIgWIwDoFWPvJp1bl0hh8XcEemkui4bKc2FrVKCyzrTnBYsm7Q+eef3DNLE33SL/DZHBFQMHOleK3ueS1rVtL7zi51NlrVeVIefCNZ1Ap6QB8DE1kDmIfXYW9YOI2T332b3aEoPXJ6wCIqO2oJXOCRwZQCkzgmIpqdtYwu+H34YlXRgpFsgB6t6j+JW+aVcVi1C1Q6LvbqC9HrOLPtip46pbkm6WXgRmOY4qISrvR8DjyNdfeTLi8rRiI/DsfLVkwUEbL7Vgm+akEEIkh7AnNczzyjbibKI+43A08E/gKCzRGzDnEh0cBhXpyVTxz1BydbNYbxyBHxMJbvIeiecUpFGz3QeUdm21EMXM0bZUVxfNZrf9b7NpLbrunYCZ+Vy+T0QhX0IvUCqOLcVjjqblE57hOJjoSapUVWBq2tIcIHAqdK5VAdpBZttij3Ia0zuwRIGms6oGxhIXaq57gT6XNWybXJSz/msk7NHT5pgaS9xIEytUv/z4/fcitVQrOwjsL2NGwApyTr0iCIxVfPqwvta8l07QRuvkZvUQPMFTR5C4bm+7Aq5kHQt6cZ8I2aWhRpJSl8Bl3j9hKbvwW0vJ34GQ3oP4cK9skFwFe3asFfiu/hK+VTTJLbHk91aJmQGXv7ydL0354nHwWYrh/+FahieoqMff3wG4m4Gs0tZEoBJyLLgtDn89JkEYoEu7rSbnUJhwJmE7MGcl
 JBBBN1Gl
 10fJr6Kpt//GjFgOvJ2Mv3m7pKVoy1Eu0c+Ckxm6k+xWgMmw1BhMadNUDaiknjJ8rg0N7zsgXlf/Qt1LQea22AL+awLJ3mmmXG+MdVUoJejnZ1eF0yTvEv3NE+NTslutbsVVMpN2Owhf5ed0x4zPHJh66jg1065gTRRYeXughCeaEq86mBC/sqWvJeLFqogUUfSIO9Px9HV20sPtyIlTyXOhyIbDjcUBAHKedvIH27nyvEuJZ+4a/MsEM4nHDExiKaIbXXwHYtA0w7qWnyj7/WScQdRRjGYc1f64jLnD8Y9x6brs/zD5QU1zh9M1xBqoDE60L
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
macro, and removing the local MIGRATE_REASON_NONE define.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 include/linux/migrate_mode.h   | 1 +
 include/trace/events/migrate.h | 3 ++-
 mm/page_owner.c                | 8 ++++----
 3 files changed, 7 insertions(+), 5 deletions(-)

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
-- 
2.43.0


