Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B74F6075270
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FjmFO0Ne
Received: by kanga.kvack.org (Postfix)
	id D0A456B05CC; Fri, 20 Nov 2026 13:10:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB3D6B05CD; Fri, 20 Nov 2026 13:10:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B373F6B05CE; Fri, 20 Nov 2026 13:10:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 898C46B05CC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1622F80152
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:23 +0000 (UTC)
X-FDA: 85456287126.23.4E798A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EEA9D2000F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FjmFO0Ne;
	spf=pass (imf03.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198221;
	b=5osC8V0+nnVnyo7zsgNWjZsUgpM6sBjf1+wggkISjc8hH+JlpnXr+ur1rjbopqzMzI3PjU
	qAQR63ztMcDwDMo+nyQ4cHMwAlQ1yEO1jd7c0+yV9q3mlgcSrjtpUEZxBltwbeDToaxKn+
	Kde1M/er27BhBZgkXcEgZfGe2AFYXB8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198221;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnBcAFfhuVREQ06HLGZKn0FAq5MbkYivQ/m5eQpyggM=;
	b=cCZEZ/VUbM2RcDuIsKdMN56kCGO/nHhatF5xBmL4OIHCeRFnP9VtBkth52Enp1hWnlF0qX
	eymmxsiV52I30YVzCqWJeLSt7Y13ufwceGHHuLEGmyC9VkSp25FSCApGjeA28JXYjmyK7G
	pD0mBlbzkjvIzHX/qoY43tWBTJVIixs=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FjmFO0Ne;
	spf=pass (imf03.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E94744D17;
	Fri, 20 Nov 2026 18:10:20 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198220;
	b=LIHCSJRAesZdqvwjJVoUdNGxtKrtT8Avgdx2YLH9BEl3J4NSpViidycRNewBpiwQTaao
	 t+uzLjus5mKKF/2y4PSetp0lkWCKpiAOklHLBkrI1tZfWQgu80xGnrsZUjTqfm3ykNoSy
	 C5tEndVRHlW1aVgHgq33J4TurJszPhI5i616iguFvvu2aDDEmSOA7gJdWjM2g4jYtN+2G
	 ixiW7eOGcNDGecAm0XFFhZuTSWvLP0qRbmeoaMNV7Zjkn4JQ5K9eI4H7NL78aspOyYcPX
	 Ybcv9DMYIRNSfYjymd5fL6lzQDKyy4nPoI7yzi9V42uU5ftk9JRaVFJCd9gEyirRztA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198220;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=TnBcAFfhuVREQ06HLGZKn0FAq5MbkYivQ/m5eQpyggM=;
	b=hvnjYscACV5jeOL+hV8GilIPRrP30Y3jGfyN85bR9NkFkNiekC69RsSGcxOr2dboZDGC
	 K8vbGNTBL/l4riMwHcTYDPhutSXUqGiyEksEgG3PTAHf19Zt7vfYilqBDFIxtcLRymAvZ
	 qWjhoCcJf/cABFV3d4/oOr0O933g9u+Ec44VRqgtq+/PKWhmQxlgzkRt0grV89qAbEFgC
	 bBNeCNIUnWd4BGy/tl4EM7SveYHD46ja4E1f696ZUw5lljJ83BHsdawkYTmUWqORVnMKG
	 bY42sJZcR8pQ+P3SDxVfc+XV3bPgpjVabLD7Qq0mmCLOSDNi7igz3OV9D91k186hUig==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A58A01F0089F;
	Fri, 20 Nov 2026 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198220;
	bh=TnBcAFfhuVREQ06HLGZKn0FAq5MbkYivQ/m5eQpyggM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FjmFO0NeV5oLSGrzQkQofp23UWjC1TkcYJP6SS1Y2ZDARhpv7z9f06I7OVhLfYNVi
	 Hvmjofl3DzO5UOCE3BdMe9YU2Nq2ZnIZtFOemNAvkrPt6U/bysgFz96XN6Bv4Z26jg
	 4Xus2QbtDzrcseOR1K/QKT6fA/dkb59pQVsqhpaihpULGlF2dFbxH666RqGbKAt4P5
	 i4YX6sUUAXxfO48yiWY8eCkaJ2Tt9rkvQvQTJi1rV5y10yi+Z2trznacCm9EglVJl2
	 oVA4o2/q1RrEDmHYQvQoQw4eJo/fJvM8zyvi6ctaxiOshP/XPa/9MH6mrGtSGaORQ7
	 J8N3lUYF2785w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 487184B90D;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:10 -0500
Subject: [PATCH 19/60] mm: add folio_is_common_memory() and
 page_is_common_memory()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-19-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1507;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=m/xIO2hju0O2MUxmJsoUbcjHDLOxcmw4vOXYB3RhCDc=;
 b=r9U28O85QC7KiTn0NtGXb3PVRmPqixIvxW3FarWvGYMIe+TtX/FQCmUuDfZ/0dXaLjaL/g/Lw
 F7K7kgvtuD+BLMHEs+q0AR9fgZqrNmHByKFqFVDK5bc8MLFaIcotn7f
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EEA9D2000F
X-Stat-Signature: zoaxzp7wtxw9yi6qxt1qa389ptybxm5w
X-Rspam-User:
X-HE-Tag: 1795198220-59392
X-HE-Meta: U2FsdGVkX1+gStvafR4v4EOs2F03l4FY3JGPaqSAjxdMW+nEUNlP207mZeny/ss5hT8wbatcjo4MUIGC7m+TnjsYFDLQ/X96VHbXSLJBD36jiU/mnp6s+M2ZtC0HESc7nuj1814rqYNleew4GBijtBsrfnuMxFxKVmMTshVi+P912BqdlQ2MrnmF+yTEVaeKolNVwgd2TNRt0HL6T93u5CnB3NlNUz8zniAJQNyr8Lft882KAuPPfhq0J+K91G0Funicx6I7RvndfZaNgskldlNKcdEuH08VlMPiF7/dIP81xo9UdjgZK3yT9VQ46olkS8OO5TUir1KMddLkp/i9pVGQNbbvrRYkvg8fuJgc2m6ZWfPgI8gvOxOQGOnps1MDKikm3+EeROTSXjRIHxZk/4goZELLQdNsWFHmH5dXgukEkjg2kAuIOIpooEf2B6H2aE7LcszWleYnTYAQBAg0TJcMHg2QpcjfAAXEVBc1MZoeq0TM9liKPgWwD7X8eesKSyjRn44L/fLWVbLp/A9TkSJUOBLLoTQ8JREj1retZgvBaxMJ8xbyhF1H8od0DT8wvdUAbczPzsyYLFXTAsrLYrsY6P/9MG8XZNbY7/D+BMvSpHCTdYk3NpDG35hI0ig3juhtosueVnZG+fJW3tTLZSAVBVr9GIfCBkyjfoI9shxkC9Wh6zKO2YgRItO6nilQXIvhawNpveLgeiZR5LIWI9D4VF0jSaNCcUETjCHIgeMbVPyy0l0s50upmiUib9DR3jYcKnA9a6yd8MdhERoSGKP8j80oeC02ZVfNnN2GR0tbdeFebMoOli9rLJMvXB4nfsjoH50VqFJyroddTJ8EKsJDtn3l4gpBV6ngi1zM22X6P9qB6QmpUv8tuHsSnMIR3qg+QbX8KIfWkdYabJe3f1Y3c1e1vNnuJZM/gZpYIjGDY2WOnLJsfo7P+0mIh8MbQlmzEnoVTym2s2RvrE4
 RLSc3+8/
 CGBuc/+3AphnNiOCeS89sm+YpbIK/59ekGNPLwQqm6vLnGCWve9rnp6zYg8ebYCwRiHLNUwZeBK7/2PIizWTxi0PBLxW3WngVvcRWfd5UJU6eu1enWqBZEYrXvhTNnLUUUUPVACgmLZ5z3GuBSM/MA4RnzS6rz0yIqomyA9ERdu17QBkTwNyaVM1s3IJyamXWRXOudqCNSCLLSWfosXSJIzP2y6KkjYpiwFGVJAWfy8zbMHuMJSipFjbYk3+Gub/6XnqdD7+9iX+cRqgE9qbw9WaC0TDFtulHIcgSATCZFv2rloH/HjIey8jQe+9R20xte81gxEWi1GBVnwL+obBPG8tp/9voLNfht8ZjLuU52j8rQ8AQTDP+UZ0ZYhWi7PbW5KvsE8xcnfI1oZZY2aIZxR5A2NeLZgDtUL1gmYWvDKPSj1S5Tiv08WM1P/7k/Z7oSK9/837gyAbdHkIgBcePpgNgTI4QuDpqfeCahkFLO9NYLtaFjtPopT+oY+6iCejJe2eNljyXhSfgYpDbBZGQRq1ymE+sBP7gg13ODsrItxs0SP/zSTKq48G2+fKZKUWF+3eilAZnGrYr0wMr6H25A5hIHWhBtAoMH9GsbsRCfpkQZyVZilPNfv2jgEDHekLnAxeb6n64dLfvqqzRw0xLg+zLfxvmQO8Oe3u555uyNqj42gJge0v41ci1+8Isnh0+KQngRzWmq9eq8zQfJ5ZFAhzdQDQN/efgXJ3rhBD62jBdMy4qmBX7yOdr7/URCvpG6P4Yh/zgK88VakSUeCsWJZ9qwX49HDDQ7NXIoyiHewYFiKzP3sG4o12gbnPoZQx6m3MH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

N_MEMORY_COMMON decides where ordinary allocations and node-scoped
services go, but MM services that walk folios reach them through page
tables, physical addresses or LRU lists, whatever node they are on.

Add folio_is_common_memory() and page_is_common_memory() for those
services. ZONE_DEVICE folios are never common memory, so the helpers
can replace the folio_is_zone_device() and page_is_zone_device() checks
those services already make. Following commits convert them.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/internal.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index c102e0f498bf..cd0562f0b68f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -65,6 +65,21 @@ void folio_mark_lazyfree(struct folio *folio);
 void node_set_memory_state(int nid);
 void node_clear_memory_state(int nid);
 
+/*
+ * Common memory is available to generic MM services. ZONE_DEVICE folios do
+ * not qualify even when their NUMA node is common.
+ */
+static inline bool folio_is_common_memory(struct folio *folio)
+{
+	return !folio_is_zone_device(folio) &&
+	       node_state(folio_nid(folio), N_MEMORY_COMMON);
+}
+
+static inline bool page_is_common_memory(struct page *page)
+{
+	return folio_is_common_memory(page_folio(page));
+}
+
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,

-- 
2.56.1



