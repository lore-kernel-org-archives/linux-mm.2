Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16410607A0E3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVd73Ics
Received: by kanga.kvack.org (Postfix)
	id B35CC6B05D6; Fri, 20 Nov 2026 13:10:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE64A6B05D7; Fri, 20 Nov 2026 13:10:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F906B05D8; Fri, 20 Nov 2026 13:10:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65C3A6B05D6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D544F120122
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:31 +0000 (UTC)
X-FDA: 85456287462.20.D63FE41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9A8B2C000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVd73Ics;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf22.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198229;
	b=ctUril1FPHoQOJOdBZOkebOIcm5nT0hhXXh7ENXbMdbSLReZUmQ1F/6IMI/8nFkH5MX+wE
	hWF0YAORqzBKTVMjveFpgiTWmUclxnhXWe2+HbTLLdO4JqoWBCphyUSa/q6hSo/s54GoC9
	TKsikLA2H6xnBWm0erlpuooUG06hrUE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198229;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLAmj9OwANHiFsbGoQBG/l0HxQVZ0G6TA0SumkQC8Ek=;
	b=K6mWj8/4or9ZrRYDRumqQM1G2UCeymSQKHWktmLWDtt2SZol6Am/xC5AwjFOyLQMrpbRML
	IJqQoO7m6g0FhU6dkNsRLWK0pyGYPYkqY4U9elCTjbl8CBDcorrZ0MXonP3jyQo6R2OWdr
	x4V72YixyetodPXbxion38eBo60weS4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVd73Ics;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf22.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D354A40EF9;
	Fri, 20 Nov 2026 18:10:28 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198228;
	b=VLVX11e1841MmZlYnTKLAt/Bqii3gkqQ3xwcEezv4+p/uvrCC+IPMD4C0Z5lcWA/KwZh
	 10h3ZumZ025a0SERb5XOAFrp4+laWc8GDynEY9ZqLa4DEQaWIr+fFXJu8EkmxeusL+Gf0
	 kue0f4Wg7aaDdvf5+7+Opvj0A+HJ1XkvM1bXd7Q071linYsCsLA2GgVcos8Vk1nMchaAA
	 tP4mLCedo1VI+5zjW7tydWQPJZ2FFCW/QG6m+ZRFlMsHOFEsgIgjIJQ1S4aJZmlchifb2
	 86FfhMpSZ9Os2rkfh+KkSOh2LOsn3Pk+70TEYkMOmWmJK+zM0ruCBXXitYy3wgycDrQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198228;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GLAmj9OwANHiFsbGoQBG/l0HxQVZ0G6TA0SumkQC8Ek=;
	b=OKK1k97GtF6xD9yLiFkTOQm5Jsa0rplHg/D371vC4ERQb5U0pR+ZeSYSvxGKBNaWGXdF
	 pO/UXKqVgVUo1D/CN6Ec3RfKVBr9/85pzr6noPPykAXFN09QzYgWTD5PPq9007fnKbICa
	 jixdnCo2E0nXMOv/7Kx/BJc4Yg5+TLYguQpLo3I6S42eouRFnbMDAvzprI/ZWMhZVQBU3
	 hPFjEANG2sLuZVwGkNb5dilZCDJrTslRKoUuzLqEVUwPONLcxHlsQO4DymZkID6/30YLM
	 N1UR+Z12z+QmbCGofYpfe5mfm4rxzFu3XDtU+DdsCbIqy/N916WHu51pUFXD33MuIXw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4F7B31F01568;
	Fri, 20 Nov 2026 18:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198228;
	bh=GLAmj9OwANHiFsbGoQBG/l0HxQVZ0G6TA0SumkQC8Ek=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PVd73IcsHXgaXuTXA53q7iRvEMOTH15cvdyVHFMSl9QZgU0Lh/r+nI6W2p4EPDyH6
	 dIyQZAKl7ZoYAVT08DZE2pUuaQ7S+ov7od7oJhmc4DL7qLSNPeFI5kjhw4M6F+5sPL
	 7nC+1BM0MZJgV11QSCSmApqfzj6yvdWU0wH7zhoFJUQrB8rFg4x0uVXLWviuUNp3hp
	 WI0XJH7JMaHJQUwous2ZtiCpbL80YvvOX8x11t0BOuqvTgWt1tVTzp3Ladxko8K36z
	 Bd+k/dmSSAwm0fBrl8Znv1bB10CvoUZJ0T8J9uOgTYS4PkCuHgcsuOAGLv1OA5ZRpu
	 VQgFeJCzcbStA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7E4EF4B935;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:20 -0500
Subject: [PATCH 29/60] mm: keep private memory out of the system memory
 totals
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-29-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=7541;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=8jD4gdJ7f9IthJ+W65OhuvHMjSc7pf2CPG7wZM7sxhA=;
 b=WALF1SEszBgHGduONGSRsLszrM9vdU14F2BXkDNGsxMux4GtiPUn1jCBsOIJG94Sncocj518V
 +J8LFEBQrN1AkkVDHSuBdmtjq0kHaikaGd0FRxFUM7hg22oUR9ppnh1
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A8B2C000B
X-Rspam-User:
X-Stat-Signature: szmawsxaogubqo8adrpoiqw15xp7ykny
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795198229-638258
X-HE-Meta: U2FsdGVkX1+gfZJcutnWDzSFOnd9labQVNG5VV55WUbhvaOFIc1iKggYm6AOD5JUNECinvVNZFFehiszkB+dzxa+E8uGbqVJvSQf/Z4TIc1euYQKCOfmmM7adrHmGj6vH8OhJLKora5/iimPv8Q1bwL08vegV6f3fBVFyDW+rzG/7qMbSDVgJ+W1mhjL3estJ961n85Y3BM4lIrweUOIqrn/IEAu1p8RHY2BaBhfIa/Ik4Ni1tecZC9FRoSaX3amRHybitwSqTilm94pdnqxLxF6j5Cq+biXl5oVLzdc6XspbU/5wpHIFDSDeTqQSABW56djS/M/pmXirEiiU84X4th1/ZtWRXg433XWWFvUNgD4WLJx8NMmkKUh46Se6pkbfXsNqHRakt36EMRtAtP3WuaUIWrPacCum4Jc+MMkSsCpqaXtdHD21JhpnDBQT7xlqVQskx8l59sz3HUBIT5na+8OsQ12DFHtOwco3mr4ZObvxtACa3JjEM856a60sHxfoS5JebjwLr5galVEx7QU3M1nGpzNnzMc8WBUsHyVmDXxkcAwVfjh5ypYnQ8PcSb1t01E5JQH31CvFnVwXqzcOptG0yNyDv39QzNV8jEph/ct7b4bx+Evsr+3lUT6jmy6EGS7//TBHiwYBxy2gxLa/d4r+SPWgTz2cj3msaT5sSurolODhvktoG/sDdh/WiOGf0TOkjp5NuGl14+rDhZrfPjLM/kWKikIy4wWOi14r8o/a4XggpwbCVTdl+JLldoLfxJyr3adFi9riQxks/SsS/7dqrOQe+eCUSG4aTY+F+XIQvdH43V4KKj6IZUZ12X6iL9P7LoGQv8Zu/I8ntqYIz//ottlo/50PomUt0F0thguX4G1H8Z7wB/dCHc8liwNZ8zgGIcWi7oraU7vLDErpux6uXZ5GzmzV7IdV48RmR7mevQ70cwZSYG7t12jSkSFbGVa6Ze0XmrF2ESGsBc
 Ih8dwIi6
 50HeZoLBCg4Jg8ED1Gf8abAgAIqYvUlZv6FFIsu3sQGVTobhttMMyIzRrSlJX7+q0EMi/q8T/6HmjmoJtsTMhidA3NUHfQNbjpndKk31FuEyaN5ZB+Hcp/hJ58bmJcyTZa1wKjghh8f0rv+7VRQT4+LU56Qrzs1PF1luGsO7y0CQ8VaMcjxbJQEbU1G+Rrb3vzbnnzDooxdloYQxIM98FpQ0Ibrre/8TiynZqXWX9wTL0390sZlFsGWdk8woXhiYUo0gjt5bkNyvVxAVkGBJA7keh1KV43BwZbZAT2gI2WbR8VmirHaq+dfBeReWDQHOX/HOZRcSxQJ6mMwH8n0JaxLDhKH2lYLdy5vsTo1rVuP/R13nFq023LESTJ30uqFOUyCepLS0jSfD8P2cpo3kpC4eKFP4ONYx2RCOLMGYRt67zsiBP3T5EwR9rZniWZvADdoB7UyShmSFXJmauaguTHMgqZfT0xezoNRCXT9KvqNeOipouMRXUPc5U+tVulN2VG/TfPZrPVwQFWKTaFNwGWPOXpQd76O2k1kR3fxLdfgt0rjjvtn2IbfTd21iuV16njQspdpzT5XUKqj8JEul8q58n/tZkn0XaEPq/wOQ/7b9YYbJYIU/wyG1dAFGNoiDdnwZahcK0BepWNvOHjgjSKDNKCf93E2v/lQaGFza8Urha9PHFBEr1rjSsGmTfT9tcHDhpvamdw1bMosw2DbguB5+IRsQxrwbRZqo+UAGWlKytSKTHBjwzxf/KnF6XgDN943qE2xEVRpDrFgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

totalram_pages() (MemTotal) counts every managed page, and MemFree
counts every free page, including private memory.

Many limits and defaults are sized from totalram_pages():
  - the overcommit limit
  - OOM capacity
  - tmpfs
  - zswap defaults
  - others

Private memory is not usable by ordinary allocations, so it should
not inflate these counts.

Count only general purpose memory in totalram_pages() and
nr_free_pages(). For now general purpose memory is common memory.

The two must agree because some callers (files_maxfiles_init()) use
their difference as used memory. A node's features cannot change while
it has memory, so counting each node by its features keeps the total
exact.

Several readers use NR_FREE_PAGES directly with the intent of getting
the general purpose memory count:
 - overcommit reserve defaults
 - DAMON's free-memory metrics
 - dirty limits
 - MemAvailable

Switch them to nr_free_pages() as well.

The vmstat counters and per-node meminfo still count private memory.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/swap.h |  4 ++--
 mm/damon/core.c      |  5 +++--
 mm/internal.h        |  7 +++++++
 mm/mmap.c            |  6 +++---
 mm/nommu.c           |  4 ++--
 mm/page-writeback.c  |  2 +-
 mm/page_alloc.c      |  3 ++-
 mm/show_mem.c        | 20 ++++++++++++++++++--
 8 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4f686709d71f..fe7eb13385a0 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -308,8 +308,8 @@ static inline swp_entry_t folio_page_swap_entry(const struct folio *folio,
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
 
-/* Definition of global_zone_page_state not available yet */
-#define nr_free_pages() global_zone_page_state(NR_FREE_PAGES)
+/* linux/mm/show_mem.c */
+unsigned long nr_free_pages(void);
 
 /* linux/mm/folio.c */
 void folio_add_lru(struct folio *folio);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 986404b547eb..3eec5a17b5e4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -10,6 +10,7 @@
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
+#include <linux/swap.h>
 #include <linux/pid.h>
 #include <linux/psi.h>
 #include <linux/sched.h>
@@ -3229,7 +3230,7 @@ static unsigned int damos_hugepage_mem_bp(void)
 	unsigned long thp, total_pages, free_pages;
 
 	total_pages = totalram_pages();
-	free_pages = global_zone_page_state(NR_FREE_PAGES);
+	free_pages = nr_free_pages();
 
 	if (total_pages <= free_pages)
 		return 10000;
@@ -3867,7 +3868,7 @@ static int damos_get_wmark_metric_value(enum damos_wmark_metric metric,
 {
 	switch (metric) {
 	case DAMOS_WMARK_FREE_MEM_RATE:
-		*metric_value = global_zone_page_state(NR_FREE_PAGES) * 1000 /
+		*metric_value = nr_free_pages() * 1000 /
 		       totalram_pages();
 		return 0;
 	default:
diff --git a/mm/internal.h b/mm/internal.h
index e89dd1153662..9c162ded5305 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -779,6 +779,13 @@ void set_recommended_min_free_kbytes(void);
 
 extern char * const zone_names[MAX_NR_ZONES];
 
+/* true if the node is capable of servicing general system allocations */
+static inline bool node_memory_is_general_purpose(int nid)
+{
+	return READ_ONCE(NODE_DATA(nid)->memory_features) &
+	       NODE_MEMORY_FEAT_COMMON;
+}
+
 extern int min_free_kbytes;
 extern int defrag_mode;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 7618e72766a5..091d67f82221 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1567,7 +1567,7 @@ static int init_user_reserve(void)
 {
 	unsigned long free_kbytes;
 
-	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
+	free_kbytes = K(nr_free_pages());
 
 	sysctl_user_reserve_kbytes = min(free_kbytes / 32, SZ_128K);
 	return 0;
@@ -1588,7 +1588,7 @@ static int init_admin_reserve(void)
 {
 	unsigned long free_kbytes;
 
-	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
+	free_kbytes = K(nr_free_pages());
 
 	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, SZ_8K);
 	return 0;
@@ -1632,7 +1632,7 @@ static int reserve_mem_notifier(struct notifier_block *nb,
 
 		break;
 	case MEM_OFFLINE:
-		free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
+		free_kbytes = K(nr_free_pages());
 
 		if (sysctl_user_reserve_kbytes > free_kbytes) {
 			init_user_reserve();
diff --git a/mm/nommu.c b/mm/nommu.c
index df99495c8902..a6f70c5d9ec8 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1858,7 +1858,7 @@ static int __meminit init_user_reserve(void)
 {
 	unsigned long free_kbytes;
 
-	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
+	free_kbytes = K(nr_free_pages());
 
 	sysctl_user_reserve_kbytes = min(free_kbytes / 32, 1UL << 17);
 	return 0;
@@ -1879,7 +1879,7 @@ static int __meminit init_admin_reserve(void)
 {
 	unsigned long free_kbytes;
 
-	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
+	free_kbytes = K(nr_free_pages());
 
 	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, 1UL << 13);
 	return 0;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5939f781fc54..00293a64fcea 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -317,7 +317,7 @@ static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = global_zone_page_state(NR_FREE_PAGES);
+	x = nr_free_pages();
 	/*
 	 * Pages reserved for the kernel should not be considered
 	 * dirtyable, to prevent a situation where reclaim has to
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3a7c12fec906..0a5176a6e9db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6513,7 +6513,8 @@ static void setup_per_zone_lowmem_reserve(void);
 void adjust_managed_page_count(struct page *page, long count)
 {
 	atomic_long_add(count, &page_zone(page)->managed_pages);
-	totalram_pages_add(count);
+	if (node_memory_is_general_purpose(page_to_nid(page)))
+		totalram_pages_add(count);
 	setup_per_zone_lowmem_reserve();
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
diff --git a/mm/show_mem.c b/mm/show_mem.c
index b938cbcd774a..b90fb5a0016b 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -45,7 +45,7 @@ long si_mem_available(void)
 	 * Estimate the amount of memory available for userspace allocations,
 	 * without causing swapping or OOM.
 	 */
-	available = global_zone_page_state(NR_FREE_PAGES) - totalreserve_pages;
+	available = nr_free_pages() - totalreserve_pages;
 
 	/*
 	 * Not all the page cache can be freed, otherwise the system will
@@ -73,11 +73,27 @@ long si_mem_available(void)
 }
 EXPORT_SYMBOL_GPL(si_mem_available);
 
+/* Free pages of general-purpose memory, the memory totalram_pages() counts. */
+unsigned long nr_free_pages(void)
+{
+	unsigned long nr = global_zone_page_state(NR_FREE_PAGES);
+	int nid;
+
+	if (!IS_ENABLED(CONFIG_NUMA))
+		return nr;
+
+	for_each_node_state(nid, N_MEMORY_PRIVATE) {
+		if (!node_memory_is_general_purpose(nid))
+			nr -= min(nr, sum_zone_node_page_state(nid, NR_FREE_PAGES));
+	}
+	return nr;
+}
+
 void si_meminfo(struct sysinfo *val)
 {
 	val->totalram = totalram_pages();
 	val->sharedram = global_node_page_state(NR_SHMEM);
-	val->freeram = global_zone_page_state(NR_FREE_PAGES);
+	val->freeram = nr_free_pages();
 	val->bufferram = nr_blockdev_pages();
 	val->totalhigh = totalhigh_pages();
 	val->freehigh = nr_free_highpages();

-- 
2.56.1



