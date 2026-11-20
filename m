Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B97160A3828
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VtLT1Vjl
Received: by kanga.kvack.org (Postfix)
	id ABEC66B05C0; Fri, 20 Nov 2026 13:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48846B05C1; Fri, 20 Nov 2026 13:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9956B05C2; Fri, 20 Nov 2026 13:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FFD96B05C0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE77E12013B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:03 +0000 (UTC)
X-FDA: 85456286286.27.575CE08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB886100003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VtLT1Vjl;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198201;
	b=ElU7lxMPFZSa+XjAoVWvLupnx+uQzBvUfVrJUzM77QqGlzoPlc5chIjadATN3fekgmi1GH
	PK71vJF2H+R1FLeqle58Tsw5/O0O40c62MZjLwEWss+yY59dFaABJ8pHKbn6nOKTJpdVDH
	nhxRXXCBSZrxS5q6+JsvO5c0xrvOzas=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198201;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=viHCEx84Kk76c0umGmj4eFC340kJyEsd5v6cdjPlHcY=;
	b=6/AU5j7sssjM7y5EUgEp/jZ+jdPgqaW5XUcl/FkmMZKkUQVGGJ2ffhJ4q17grXsF6DvMjE
	XEgs/5HPf4wz+ejjtnbTKG/cyiuf3az2JcNj3u8JaejHCYajB8ZIeDaRzeVYJ4yeXKUGtA
	3HeBhFkDFc2NCVZVaqcrt47fpLgHCRE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VtLT1Vjl;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 584D1633A1;
	Fri, 20 Nov 2026 18:10:01 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198201;
	b=pbBsCyTuXe3uGA4DfyytHejl1rPZg2LP7B3EjlFpUT7Tj37JXqUfZo8eUb7Cvwm4xPUl
	 8VgllOC2PGIOFJ3HJ9vkMeEwiixcxDwW0CoGRe9LAwYSBoH4s9Ayu3E/sbRLcArxIsieK
	 fFIH7AsiRCfY7TavYKrbzfZc0IO6QhQS4cnvPWMQ7D1mn9zRSetQki9XN4co0Nvv7IOa0
	 QdtOkHZ2cl6C5oaege3uvLAnNYKeopUmBubd/zHpQb13d6NUNxtAvFKcDLUiWVSj+Tk+l
	 ozMktJgL1MvZVoxSiiRrQpLF5S+rifKHVKu2wluTEadfe3LvjDS8gsKBzEHl71P9Ugg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198201;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=viHCEx84Kk76c0umGmj4eFC340kJyEsd5v6cdjPlHcY=;
	b=C7jUbMYKBF2IyihPO+sr96NRGAwCmBIT8umG97U92DC+Ok5dYuQpKfw76kLOQ8E5UPvo
	 slsGsTDpC57YpeK3Jccf1dymMyHYCFPZ1njxbfJGus20u6wUq+tT7Keq38c5tOdLE2KhH
	 0bZkMZ4enjVvy2+cZ5h8qXuTS7zWkQuGO0C0tZxQ5GRpazZNEsODN83liAcO03gPh0IF2
	 pe9R3PX6A7251U0QwaFmOfkDNrs3xYj6dGSblmUFHZnxRfSm3ve33tRrhYfefXVcSCbll
	 rbbhb1awKN4FFPQksIFdWFqBDJr7RYZHWlFIICRxoRj+U98ejHIeTm6HEKRZdg5p0Jw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 20F871F01565;
	Fri, 20 Nov 2026 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198201;
	bh=viHCEx84Kk76c0umGmj4eFC340kJyEsd5v6cdjPlHcY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VtLT1Vjl/ZJhW5bu0P7GA1WqpSuPQF4AOmYWCeaIu/gh0gPmu2F4hGBMAPGv+hhfR
	 yBY4LOPWwvA2gtK28DY0usxuMH8BxokZCU+GGsHLjY2fiBMTkJhR5+qAxMvr6Jar4o
	 klRm9iK5tdVMNIvpWRTMzN9DI5E4kcBYgipJfhDsjmFZ+LOTprdviW+6I6Pv1geKeJ
	 iXn3B/jfMB5DF0ePSA0T3N+/gNq7jFRF0WCWqSeqo6qXnKmT4S+iAbbx2eHUIsvsO+
	 3+tLjgr8rvt5hcQHrkPpqOUXL6BnS/j4R8gEaA7GQ9SVqiiBwVhJU+qAc6pRVMUApQ
	 RnPiy3dyAhkIw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 08EB64B905;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:08 -0500
Subject: [PATCH 17/60] PM: hibernate: size the image from common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-17-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2366;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=A3l/6pPMz9YPRB99YIwhmspv/HD0g4ri54lK4DwOHLU=;
 b=mI+JjYrIOIQon3oEqa2KKxHS1h91tm2h8L4t/n3aWLMMUysU1+sJoKRNNeogaWqhf2eGMWvyF
 WkAqiNUeQllD2ej1Rpnh67Y1ngxyx7Mj3iNBos7ryRyQn7xec/6u1L2
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB886100003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: q11yn4pn3csdyk811i3qy6h3uf6daza5
X-Rspam-User:
X-HE-Tag: 1795198201-447531
X-HE-Meta: U2FsdGVkX18KsBsdfO+syyylsC+kupb+p8fXHnFt/+CSpFP7cuQUTX4e0d/zM0nmwqrWVAd/da6NEX0pGAoLv4TFGhbv/xe9EOB6yOb/Wn3bY9LIEVYn++TrU4dKbOZGuf5oxqh4zfeDe8sbf8kgCog0v9Ejz3hI4XRoRkch2GEW4few/Wda967v/26mu+R1yRpuMOUu2t1g4hCDGzsKngBvZysWeAxFPLpu5ZQcaE/TVcEpWHVeMZfXP3fsVxAGi0XyVX7t7Sdt45iqSkc97V4bepw9RXB/OXaydY76CMt+/CGWD8VdkxydkzstCv/npygKj8VbLC11X6SvxmthnfSx5JhlNvJX7p+0TNk3SlMc/5bMUysCtpOAubgQyQNEMTu3Jv0fG0+KAXYhMdMQ1nolUZdi/sfJsCMaZCLLHzeZwubkUBS8Ay+MxwieYjflBoi8Xm0ctlwCt7+y6i5zsRyzov2f1VfjAPMoqL9OWRtJYW3LPYKdV0Fz+KBK6uL4lNDCpnwapAIQB3hr/gmXfcNgUhCifl1zwlaHkxCOb6dyYtjKeI4noZQFOqHBYIhhdi76cHR+fVJN7Ogd2aVOvbfQspiZRvqLhM3Gfxtl0exymcLU7039uaLq4H3qbUzT+WdHP3Qhp9b8k0H5J6XjYZ3sxpKolzAmarH6+/m8EXIcHk/1tXiyfNw4jAi72klZBjAR9+VcfsAMP0aQQ7wusHK9ImCFeVp0W1g2Ng0jhiLQDBn6vPCQuWQWjTB65iRoyLJwjZRt5GvT8caHkT5CbJJ2pe561CfWOp1kuQBw5vaYmca+rrJhK0SqsCVPzGNrtRKPlty/DejHVGo67c9LBVQLjakv0K64Z3VpJynvQfh0Rpyz/5f3FEIXYdoyR0NWS5ttVFG0q7y6Vd7UYbYA9yjPvNrXrePlfFg6YEKAxdzyB1fuYiPN8xm4wJ7+xhgZlvMYFnG3DKZ06D4Pmed
 pZIXd8NI
 i/At5fuDAQJ0dlbb9EnUzBXtUNesdXlYm4vusehbS6WPjUa4FbZzDOqyxKGZknZ/jYQpaBBnSBuKMqti9U7x+Tus/vBX8EBWVIKnZY1TmyVkf8cZZNKonaTdEOY58y+1lE2Tqy5841dcjGfXvBURQurCJ3r3bH6JZfJFlls9ezww2Gq0bR+AF1V/hTKWOm7/OPyyRVM4NFTud8iwPPYExAd8M7BFoaXrIYLFdj3ni9dlWsy3MiumkYZgIuNseqJtXJYEkhLnpXRIrWHIEOO/t+Cgd03DFe7koSkdSF+ZEPFP+JnzOKO997eJuz2wZpSiHhH9Y3jO7FOwqpAy3+3bLVk4ZJ/TKXDFjjadVnPMHyL8skSCUSGQbOnK5gxbXQtbJ9Ro5I4hE1S2HHueW9EW/38IEW7Qo6EseVToIhEa/W3lmu3a+aYB9vUwfP1ibf3DXBfc34L0r3uPzaK28kqdJZCV6crGcWDW8MGu2kDbYyKkycth8ZjmddLSJw0GsNInO7YrQCQedKXo2dfRYS0eBGdIc7XdoSF+l+2aluNStJKexDZW+gcY7mKfKtQe1ByUoeGdQEcCu7Du8A4weVwCfDd4+DiWE2sFukYbMpexJoXuDtsCe24bugcGHRQrfM9KeuUUPa0Gupax8+QtVVKjWh89Wzl3xXHTso3Kb+LrOwUd2EE+QyW9vNdPht5PQtXjjjbZM/x15dLZ14gasGW9+dfG7cCGfFMC1Ra2S2LdwPejlzFnTLyiCIdfmGldltXPqFNfV/c4oDp/LHMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

hibernate_preallocate_memory(), enough_free_mem() and
count_free_highmem_pages() count the free pages of every populated zone
as room for the hibernation image, but the pages used to store the image
can only come from common memory.

Count free pages only in zones on N_MEMORY_COMMON nodes.

The image metadata estimate is a separate sum.  The bitmaps track the
page frames, and every zone's frames are tracked (regardless of node),
so that sum still needs to be calculated for all populated zones.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/power/snapshot.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d5dba0e50b2e..912804bee361 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1291,16 +1291,19 @@ static void mark_free_pages(struct zone *zone)
 /**
  * count_free_highmem_pages - Compute the total number of free highmem pages.
  *
- * The returned number is system-wide.
+ * Only common memory counts, since image pages come from common memory.
  */
 static unsigned int count_free_highmem_pages(void)
 {
 	struct zone *zone;
 	unsigned int cnt = 0;
 
-	for_each_populated_zone(zone)
+	for_each_populated_zone(zone) {
+		if (!node_state(zone_to_nid(zone), N_MEMORY_COMMON))
+			continue;
 		if (is_highmem(zone))
 			cnt += zone_page_state(zone, NR_FREE_PAGES);
+	}
 
 	return cnt;
 }
@@ -1868,6 +1871,9 @@ int hibernate_preallocate_memory(void)
 	size = 0;
 	for_each_populated_zone(zone) {
 		size += snapshot_additional_pages(zone);
+		/* Image pages come from ordinary allocations. */
+		if (!node_state(zone_to_nid(zone), N_MEMORY_COMMON))
+			continue;
 		if (is_highmem(zone))
 			highmem += zone_page_state(zone, NR_FREE_PAGES);
 		else
@@ -2011,9 +2017,12 @@ static int enough_free_mem(unsigned int nr_pages, unsigned int nr_highmem)
 	struct zone *zone;
 	unsigned int free = alloc_normal;
 
-	for_each_populated_zone(zone)
+	for_each_populated_zone(zone) {
+		if (!node_state(zone_to_nid(zone), N_MEMORY_COMMON))
+			continue;
 		if (!is_highmem(zone))
 			free += zone_page_state(zone, NR_FREE_PAGES);
+	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
 	pr_debug("Normal pages needed: %u + %u, available pages: %u\n",

-- 
2.56.1



