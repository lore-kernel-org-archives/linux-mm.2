Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E48CBC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971AA6B0088; Thu, 27 Aug 2026 03:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922376B008A; Thu, 27 Aug 2026 03:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837D16B008C; Thu, 27 Aug 2026 03:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 550766B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:06:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCF3E14034E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:06:02 +0000 (UTC)
X-FDA: 85146164964.03.7E4981E
Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	by imf01.hostedemail.com (Postfix) with ESMTP id BEB9040006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:06:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DdVOXXs3;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787814361;
	b=mYojRKKQ1azHu3+XP8Kc9Qab88nePPJTcInC5fJY1GQolItKkosOMiwgDafr5k99ttM2b1
	JFGZzDnQxmYZnOFlpx4kVSfT9BiUp+8b4uPaGGMbLlZSg/B+UgZJ9avNrJSg0zSAYO/46R
	8D2PyJLYba1ux/hGbAZfhzWgIO+D/cM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DdVOXXs3;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787814361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7VPMrGbG1IwU1BtTdRMy8gG0saUFQ8/668SaTrEPJ9E=;
	b=kVqNj9dVESRM+leWssWf1w/i8YD/abOTxkD9jk/Ti6N3GTXs0/UIm2e1bcb+E4ptsp8huM
	If27G1dEkiqt6T2bbHFEwVdGfHm9G52QeV4YgUwS4c0m4LrvMgO8I2rs/WN1wM21FrzjrL
	MoYl/92maqFk5w/L4GBswY5ZgSIdwUI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mq6bgW9Y3BpplM0SeTP3IpFOd1r2MD18zWg1xWm28+A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787814358; v=1; x=1788419158;
 b=DdVOXXs3RiMVQWXUcguJ5bITYl4aArdK8EBs+usbcaymas5JVjRrOp8ESm818qOBbf5cGymA
 2QQuZAB9hqMu89w/1DXU3wnqb42w9+prxeuABNmw6hrKWbf9srdoOryOrRmWhhQy+DMwrdIg2Hg
 bdiFco3rF8Y9aChz3NrayHlw=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id d0f96db2f5e32cbb;
	Thu, 27 Aug 2026 07:05:58 +0000
X-Mizu-Trace-ID: d0f96db2f5e32cbb
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/vmstat: annotate data race for per-cpu pageset fields
Date: Thu, 27 Aug 2026 15:05:46 +0800
Message-ID: <20260827070546.1336383-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xs83zsre1rc4ckfembaamdxt7y9tpdrc
X-Rspamd-Queue-Id: BEB9040006
X-Rspamd-Server: rspam06
X-HE-Tag: 1787814360-328946
X-HE-Meta: U2FsdGVkX19YrSu1V9y4HVj73/4dmHW/FneYTigCDADKVBNHTzCaqKQoGuhUWu1D0ZORbJ6V8UkI/uqzXlhwdeA3NEdvaYK/eNF81pL4X4fh/6Sb+YT7OZ7uk6FixsVqH3g6XszZS27pkZbpeGSBRdRg5crm30uNYu/jMT7AdRz/zRuiUC0aMt1c4U0iMsN3vGG4sACDwKbLDjntfkD4Ft8BjsFZLZqmDRFiRjTma/zweg9FaDfECBQNwonoyPAkfTg+YDn9Wud6SY3uzvG9CxSywbFqUFj9lylbtc2XrcKoEXB6lPrHzt5bMupYnRGpAfib/C4ZNlQXK1teydz2CbHqckOUYWBDv7JM4uxnSWxPl4UBThW7mh7TI2V/Tkf53RmPXJdyOBWbGIq6L6fXlcRfGrtlOMXKIb44LrBJFgW6SNFzU7t6cCF6c+r7Fwp/8Jd87rDGUBRkDJr5BHofDxnpW5olJGDbaeiCo+QLG4JzlsGl6exQTl+YOw+HBC5E4cLuMlu+e1tUGOPlce2JYdFKr8BLkK0RWiEVBrGHhN3apVzqmxQXcH7exPg7Nq3grHkxWECdU7qxCvUhfkvGbweBg0VOuSxPWZUZQWhWaZNHovKe1wigvC2gMEr6lgSbhquA11yBFe55AuQjFxDie7V6eLLM1No3EfjwnbHtvro7OWSiOCtz5G2s+ojDXr+gfNhC2zToLlXQSTyXw+LbsPRdhbJbaDYhftXNTf2xd+vy1SO59WzmmfyXp40KbmDha9JyemY0Qf7UypSuHXD2xQI7BOvqhIkFQJyfjstQJgx66U9yc9KMIefZbBxge1mFFuTP0v8wRHcyCMuclfP3RgL/daNb2EtzGf4tAwuE7iU0CQTYEC2qBnGlNk/EECdAQQWdmJ/mnDfan0G0iqoAFvbMU5KS+28GDIlcooa4un07tjKowo1Q44yU+nyaAgH75+b2KuEuCZ6FfZnZcZQ
 RT24gQd4
 gx2B8mwSZ+qQQ0cOcfVY5qW147wCy2+kP64JfAmqC4UD3JRaNXDOmECh1ApG/PpXtrthmJuIvp2XpToGq9lL0jTg6IEW7Y62atJkzuSs2h2fLyijaO+fLt7ECLxjV/j24Dv4im/OOKmxWZxGYqb4BLEzrIlrm/grcZneutKmElf/GCwFy5RQ351okWVZ/CBCvvbpBglP0/lIf40Ud+CKl9j9TXn9CQLDXoNtIhERuN6H4+woPCNO9LtOJHSZypWwpt4fKQVk5g+7tjDUtJS91yTvxMdaOP4dI/Y5u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

zoneinfo_show_print() reads pcp->count, pcp->high, pcp->batch,
pcp->high_min, pcp->high_max and the per-cpu stat_threshold while
holding only zone->lock, which does not synchronize these fields.
The writers are the page allocation and free fast paths under
pcp->lock, decay_pcp_high() which updates pcp->high without any
lock, pageset_update() which writes batch/high_min/high_max with
WRITE_ONCE(), and refresh_zone_stat_thresholds() which writes
stat_threshold locklessly.

The race is benign: the values are only printed to /proc/zoneinfo,
they are naturally aligned integers, and pageset_update() already
documents that users of batch/high_min/high_max must cope with the
fields changing asynchronously.  Annotate the reads with data_race(),
following commit af1c31acc853 ("mm/vmstat: annotate data race for
zone->free_area[order].nr_free").

Found by KCSAN testing on an older kernel; the same race still
exists on mainline.  No functional change intended.

BUG: KCSAN: data-race in zoneinfo_show_print+0x355/0x520 root/klinux/mm/vmstat.c:1774
race at unknown origin, with read to 0xffff8e1835410808 of 4 bytes by task 22653 on cpu 12:
zoneinfo_show_print+0x355/0x520 root/klinux/mm/vmstat.c:1774
walk_zones_in_node root/klinux/mm/vmstat.c:1496 [inline]
zoneinfo_show+0x41/0x70 root/klinux/mm/vmstat.c:1806
seq_read_iter+0x30c/0x970 root/klinux/fs/seq_file.c:230
proc_reg_read_iter+0x10c/0x170 root/klinux/fs/proc/inode.c:305
copy_splice_read+0x2a1/0x4e0 root/klinux/fs/splice.c:365
do_splice_read root/klinux/fs/splice.c:985 [inline]
do_splice_read+0x139/0x1a0 root/klinux/fs/splice.c:959
splice_direct_to_actor+0x16b/0x540 root/klinux/fs/splice.c:1089
do_splice_direct_actor root/klinux/fs/splice.c:1207 [inline]
do_splice_direct+0x10a/0x180 root/klinux/fs/splice.c:1233
do_sendfile+0x6ea/0x7e0 root/klinux/fs/read_write.c:1363
__do_sys_sendfile64 root/klinux/fs/read_write.c:1424 [inline]
__se_sys_sendfile64 root/klinux/fs/read_write.c:1410 [inline]
__x64_sys_sendfile64+0x117/0x130 root/klinux/fs/read_write.c:1410
x64_sys_call+0x1cc7/0x1ee0 root/klinux/./arch/x86/include/generated/asm/syscalls_64.h:41
do_syscall_x64 root/klinux/arch/x86/entry/common.c:46 [inline]
do_syscall_64+0x75/0x2c0 root/klinux/arch/x86/entry/common.c:76
entry_SYSCALL_64_after_hwframe+0x76/0xe0
value changed: 0x000001b2 -> 0x000001b1
Reported by Kernel Concurrency Sanitizer on:
CPU: 12 PID: 22653 Comm: syz-executor.12 Not tainted 6.6.140+ #672
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/vmstat.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index cb57714539fb..a3e809c57f29 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1837,6 +1837,11 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		struct per_cpu_zonestat __maybe_unused *pzstats;
 
 		pcp = per_cpu_ptr(zone->per_cpu_pageset, i);
+		/*
+		 * Access to the per-cpu pageset fields is lockless as they
+		 * are used only for printing purposes. Use data_race to
+		 * avoid KCSAN warning.
+		 */
 		seq_printf(m,
 			   "\n    cpu: %i"
 			   "\n              count:    %i"
@@ -1845,15 +1850,15 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 			   "\n              high_min: %i"
 			   "\n              high_max: %i",
 			   i,
-			   pcp->count,
-			   pcp->high,
-			   pcp->batch,
-			   pcp->high_min,
-			   pcp->high_max);
+			   data_race(pcp->count),
+			   data_race(pcp->high),
+			   data_race(pcp->batch),
+			   data_race(pcp->high_min),
+			   data_race(pcp->high_max));
 #ifdef CONFIG_SMP
 		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, i);
 		seq_printf(m, "\n  vm stats threshold: %d",
-				pzstats->stat_threshold);
+				data_race(pzstats->stat_threshold));
 #endif
 	}
 	seq_printf(m,
-- 
2.53.0


