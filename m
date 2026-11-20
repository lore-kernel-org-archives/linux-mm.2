Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23B760A6F4F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OCztcLOg
Received: by kanga.kvack.org (Postfix)
	id 6A0716B05B5; Fri, 20 Nov 2026 13:09:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650016B05B6; Fri, 20 Nov 2026 13:09:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2806B05B7; Fri, 20 Nov 2026 13:09:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFC96B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:09:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F34680132
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:42 +0000 (UTC)
X-FDA: 85456285404.12.BD7E850
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5E57D140003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCztcLOg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198180;
	b=SRmWLosmNpdnDeCjx2545bNek8ogR/qCeZTLDi3K8HhJfIfT3O61XHnBLJ24P//ajBw1q4
	A7n8YFExYswOpUv8s4Hm7S3lSOEhPKfnSt4UfzXn077xAPBv2U9Tf46/mEenlUttB4ahMf
	TjYHhsJxNb3V22haSP9Pbpfggn7MBj8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198180;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fr3kKexKN6/LyygAXFTIEKl3iK6RW/c/i9QMIazwjQ=;
	b=Ouqj0ksqxp2g30P8CpwHQ2y7ZGcj9/asMS5EbJ2zsha5TVZmzXR6N/hU0ucRu0UwBRlm3F
	uU9gxaC5pFLOoH9gJDEocWlB+dpve9f+4BfBF34KC16DJ4xpyn2yyxSvvt39kzv1noj7k9
	TomB82jSo0dogbZ2X9WdYDAggDAMo+4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCztcLOg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1F1F62CB1;
	Fri, 20 Nov 2026 18:09:39 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198179;
	b=RyFewlpd5l4K271Q6uMjt9F/m+2FtKKnBOcz/QUifTQaoFuPUiRnB+M6lRMkUsQybn41
	 enzq7mR4OzPEasIKZ0P8Zk6vLRFeqooO6njIJCsHf6A6j2M3n81suRn2qFQ01CyR59oKM
	 Z26yOEujB6CfseCM9gyF9+xo9DC//HTiE899FRcMbPD40HzHb/UnBaVA+HXv/KaIRurM5
	 w/sj5uY3uz7JXzbnKaYupdlWtTUCxjiVL7ntnHKOpGBu2smVYRv7MLff7WhZYVM51awJM
	 kxJ7uQ6cT3GwOvqdmDOKuMwEVsrYD15AirFv+jRYFj6Nb9stmHvdaI2Cs6hroFgTxWw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198179;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1fr3kKexKN6/LyygAXFTIEKl3iK6RW/c/i9QMIazwjQ=;
	b=OMaDJplmaz3lXt1I9MnVtRaa+YzWOh50yVAqqGLQOUxbNXFQ0sdOv5dTxx72aMidsWYy
	 nUeZlmxelyeFareaRm0vq2xSClijKVk1WJaerO8zySTB+WAK2EdA1ETetxi2hYftcg1Po
	 ZVfnMsphYqGndgYNypmmJ4tqJjTJrAVTq3WOtU9mU9pq/z0wwBNwhPN33fl3eZbrgJY2h
	 Wz2gkKT6X4/bt0VhkTjFKJQV1iWPx8J2baK4TrrvbihNHJoNn5MO4dM4OEtyQvdWjdYEz
	 MRGGQ1fIgKkHviGQ8cAdhnuve3bIdOqXo8ATUEMxHWnH7g2v59xly6A/FkcfR9s6AEw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 83EA21F000D4;
	Fri, 20 Nov 2026 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198179;
	bh=1fr3kKexKN6/LyygAXFTIEKl3iK6RW/c/i9QMIazwjQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OCztcLOgEUkLZxegPnkwnwjsD2ELjo/DLiWVH0v6oX5+rPC23jmNC+JvqM5dqi6mp
	 am9iyWmCtw9jvwNBptonqTkzUVZEOIP3vmhCPhL3rRU1TjrSmJaVKYrc78B+/L5cln
	 lLTvYZ0y2jfCWeZGDFYkQj2cj5OCmuoHvORLEOcoNZGsuuqif2kZVAgdf3xDeoZbfl
	 A/sTbKdivOERXHzGEkFseFteanXxDZO/Ro+7OceW9YKmFpeMT2SMwkeg/xVJtHfBef
	 6sJwRyeLxAUD5OmGpdCpHlYNL2EE9bcBZ6RkqdQwD2atl9BlpjpauUI8C35lvkNuw0
	 iagFqb4M2fHJw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7ECCF4B8D1;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:55 -0500
Subject: [PATCH 04/60] mm/page_alloc: build zonelists from common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-4-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2108;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=hYnZoxMJ3yP49nfY0PYkTWJ6krAi0Bs8xOcweeGlZSI=;
 b=0+ENTTd09K3orEMzSi6wiR5qOFJD5dDrUYY3xdoPrBK5gY7zLwZQW1DS5dBPmSiXPxJfW0mkv
 12JJVCclp0MC6jQLSgCNEVIyNSUniufk9x/6ovTQjJziND5MyE5ogoK
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5E57D140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tgqr43y5i9y448agsqj98ysexfuz1jdx
X-HE-Tag: 1795198180-56558
X-HE-Meta: U2FsdGVkX18/BfsTqZiukHBZszm6ecnfy2eY8qwTz0r6HY5KSIaHGBUB4RA1hg784Ya12FG9A4lY+v5IfKkeBoTs6MulnQr2ziCClE2pPbEX2UH32iMzO0mijC53mFRJKRVfZxGujOx8bgkxb1lJxS53iEYCkypp9BYEiHKIV0BYjOrxw3iC5OM8WVLvsE4O4Ddo3mc8PoCVXhy0B75BTJGUtplaTi1dhNwZ/oVtgUYvvFkqCRb5nEzQ0vwbe1zRVThsbOzjKb+syqSvOhLX9Ztd3yaSUWBelhKlmohFvHQOfb1lCenI/RHG6z7pljP3ZGxmhZ/95rtGlT2CcnFEHqN5V/tMQ4NBZKc9VtEbih9XmoXca4ggyFTeo6Z6ZWUrrrDmOLwmFBw3Omo5mUOInpQB95VBg0P5qnhhrjNe0be5RNd2OcrNBvvWH/6pJB5g2/ZrjSsVMF26+e5l0+Fa7ilO7FoT2Sg2PDemtJtl+LTlvV0WHB6rQZtEWhGAjkSk7b1+ULTMXCLqOeV1vJnnIy3tDyFtVMevjC2/M0YSz9wR4B44doK50jruMXxOSU/EBBiBUW9J6/TDCdMCQ5v0ro0xgEMeK+LxIO50DxIotJIifGlYBlD9pMOWDKj8iltFMvQh/lcuEG+JbOReEIq4JVg0/sJhbBs515cJEx+3YjJcRLXRpLHijOET7KV2AS/yFD/CYJXTzW1JuL7vlGj08EjXIkuRkkW5pxOPizjBq9Fs/kcmF5vKTzuYdGxHZ3BOVBzm2HKgZEpbaNdVyvdmDiXDLT2AbxR7fPq7fQNG/lVfHpulVO+BcPzGxex23KTuKRQrd9Pp1pXArCq6jI3kue63ATosqZtN1wQQcEEtNALyUXuJUiWpBZ6iHcNIlsYuXzFgpFkr965m0L/a9iGjFKf/CyAoVZfamibGZD+Cx5Z5s4mb4xwwimm9GHxkRXcl9dTBhXZJTUFQyNvH02/
 66NvwPtq
 4EmK3dtJ/kg//SbtbD2XdXe+4v6gfCzuruSbcaV14BQOlaQ2f/GXePj5yUv/ctC8MjaEdCsjL3TKGhdyTbsy0HS6epyg34zjOcaqaR1vI434aYoywlyJhbwf4gi4nqoyGN56leMkO+6tmPJNxzoBQKQpm5/4ZNZskdIfljPuY/fTmgXSJTmBu6DUrgyp21gMI564T1gydvS+5e5aFOwnAkj1t+oRpisZGOmkjBwRDmocmhUaDptTkIHQpwOGcWTiHTucQo4djnIU5OPOmmLr5UscK+HTad+DurH9e1qzMjtzcPQuTiyAjDfJbHeExBVC7ukASGnMvun5og2eXe2wYVqQ/I0KU64QQpfT087/NEtf4cVSG+Aptw3NwJdpi+IrS7HDddwoYw//TU6TNbyptTljV48V8fkoojGanYIE2q+kqL+3IpXP1qYkkUKVnKAAHgp57frEum109260mvxTrg4gcH6YGwg2excIMZw2p1kTzeGBKQ3nzd4vfM5VfDN+46CpkphJzszaP0LaHPPg0qPR4BzsaTova//Z+Q9kuAsiLgqcOcdKp1pz8XmDe2qvUJRX5s5GECd7dJKp21Mnz8gOIrFPJ+jMDWBTBAXg7Grr4iKmYlOByryaiCOJw3WAOCJ6CWtx0BKEiFcgoSa85Rgqo0VB181qjZl9jDMDltBnQ2Vs2vs01LmqGiMt+VYn3P7MdmXYoqQ65DvwusfDtBwa2ABCbNK9t9YHjOdHFbj9p+R/JZxK+P2NEam63IuZDabAIqMiLB58HEIU/NzETEHOfBwXcjgshE88AbbP1aGZduG2pFJrZBawlgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Zonelists decide which nodes an allocation can reach.

The fallback lists hold every node in N_MEMORY, and a node's
__GFP_THISNODE list holds its own zones whatever the node's state.

Ordinary allocations should reach only common (general purpose) memory.

Build the fallback zonelists from N_MEMORY_COMMON, and __GFP_THISNODE
zonelists only for a common node.

The build_local_zonelist() refactor lets us reuse the code to build
a local-only zonelist for nodes outside the N_MEMORY_COMMON set later.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ddb04b72a160..0448d04e048a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5947,17 +5947,14 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
 }
 
 
-/*
- * Build __GFP_THISNODE zonelists
- */
-static void build_thisnode_zonelists(pg_data_t *pgdat)
+/* Build a local-only zonelist when this node is eligible. */
+static void build_local_zonelist(pg_data_t *pgdat, int zlidx, bool eligible)
 {
-	struct zoneref *zonerefs;
-	int nr_zones;
+	struct zoneref *zonerefs =
+		pgdat->node_zonelists[zlidx]._zonerefs;
 
-	zonerefs = pgdat->node_zonelists[ZONELIST_NOFALLBACK]._zonerefs;
-	nr_zones = build_zonerefs_node(pgdat, zonerefs);
-	zonerefs += nr_zones;
+	if (eligible)
+		zonerefs += build_zonerefs_node(pgdat, zonerefs);
 	zonerefs->zone = NULL;
 	zonerefs->zone_idx = 0;
 }
@@ -6001,8 +5998,12 @@ static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK);
-	build_thisnode_zonelists(pgdat);
+	int nid = pgdat->node_id;
+
+	build_node_zonelist(pgdat, &node_states[N_MEMORY_COMMON],
+			    ZONELIST_FALLBACK);
+	build_local_zonelist(pgdat, ZONELIST_NOFALLBACK,
+			     node_state(nid, N_MEMORY_COMMON));
 }
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES

-- 
2.56.1



