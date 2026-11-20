Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046DF606C95B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E2QcXPpG
Received: by kanga.kvack.org (Postfix)
	id 5B8CE6B05FA; Fri, 20 Nov 2026 13:11:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543AE6B05FB; Fri, 20 Nov 2026 13:11:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394D46B05FC; Fri, 20 Nov 2026 13:11:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7CF06B05FA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 818C41A0111
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:29 +0000 (UTC)
X-FDA: 85456289898.30.EC8416C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B76140004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2QcXPpG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198287;
	b=N8Oh1CeQ8lYaS/kEaf0B8fDLB50e2HKh1CwWRwMdGpWa7FTLy2NShYhrMD5GZN7p1IG7vv
	3MwHCH+6WIfw4aSvMygsZDKUPukQVjMKmuTcs9uw+wD/ykakaUDzpJfhmhyWNaIPmpv7w2
	TJhL3X+iWTbYWvi4DMgMtOB8RXFqJUQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198287;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RpcXK0l33o1Rh3w5xtzko7j4qpbLiqFRKXf73CE8MdQ=;
	b=O1mkYBlMt7tnPxvz60oaDn3xAp+mUq1xNOUrOnYpn6AsxsYNC6a5HdLTSTaSrhJgjmcf9G
	/UZm4tdlzbjMZApRFbCCIfzww3DmMAj1sT7nqnvuu0ZLp042nzAB/DU6ehGL+HAHtQcQwk
	dSx8Z16RFxYziZZPFtYG8ZD6eICcU9E=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2QcXPpG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEBAB63460;
	Fri, 20 Nov 2026 18:11:26 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198286;
	b=P9XnSplFvSKFO92DKdhQYJZe5s7Bjbil+Ij2Wi9ZIP+GXi8bk53LKk3K+Aim0kMETcJK
	 JDL32et2iR9cY0SerlJeuU41+0Xz06iPy6Ghbq4u83HTnBQhxYINHEOgtGT3RFwKlBL/X
	 XkAFFANSOmoGpRBvp8WRHRllyGTGADxbmo1nQKtXl5I4JuOa9RkR9PKmr82wqzzEfjRo5
	 I0C5tET4Q5xqeVr2tOIceadeXTIWX37KVEHLKTtrO12eX37YiZZGnFG4AGfrH5hizvSTK
	 ThFPMnOGNcDygcdfA/u/dzqSeQZNAWpXAZgKjLv/IB66wrxSRatYt7S3eIrcbrRiMFw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198286;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RpcXK0l33o1Rh3w5xtzko7j4qpbLiqFRKXf73CE8MdQ=;
	b=j9w7CswICorP29Bm5Qt7Wq0dgxeFRSN0ilbLqb7vD6a+3Bm67650+iyP7I3+2XZIDAyd
	 Ju6It9kyLPa9gcMPpniyjbMfQqKqsGeaI5wQbKDtkWAJItJjYjPa9iEZwJve4mCUOQ/h9
	 bmCoptb17STYBO9pX08QvfPfTqNpjv67BFrVb2A04jWWOE6+QTeFur0tRZdEkX4TfZald
	 wbVBVKqM6w6PWCmJwP2hIqwD8X3+o8mrGyjZkT9IVkfjjDEiwM1vJ6HqpHKInb8ZCAqJ7
	 wM/I0c/FNyi0Kxpn0O/aBmv38o6sPZFXA1PmV6dnrLi2uPpjUZ4hEut7rBafnzRYZuw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9D9AF1F000D0;
	Fri, 20 Nov 2026 18:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198286;
	bh=RpcXK0l33o1Rh3w5xtzko7j4qpbLiqFRKXf73CE8MdQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=E2QcXPpGIGqPqolFYSV0aN9QgsD8HuUeXzzlDUHNpJ6t0yY2npz1V+Qc5AjDr7u4d
	 yIc8gXiRb+P9mM6OR7jB5ima6BDX5SdtSBJFGYLA5NEaOeIUek9O4Hv4YfGOfH3gd4
	 vVABxIWNP+fxwF040fo7F/atbU3iwCfu/bDAB5qbccPyU5O9ImTgrwuvpr6A9sWrLA
	 4vTveI8QhA5UOHYVikYhzbvIVb6OmvHc5xIfGL9O1e0cIx/luHb3RoCnOxkCr3gosZ
	 FCL3UrLfd06//8wJsUmBOwE8ee/YeoDlO2ecy7mcvaQsZhgHaqwMNvv2yBfxljqBle
	 s2bQu/9T8k7YA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B479C4B97D;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:38 -0500
Subject: [PATCH 47/60] mm/vmscan: restrict reclaim to N_MEMORY_RECLAIM
 instead of N_MEMORY_COMMON
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-47-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=6325;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=c7DgarKbPTh+6IzFAHFl6eKVTW2BJrYv3RKLDMceLJE=;
 b=pJ9yiRLLHXGH+ah/OM4I5sNBVlA9ZiE7FmUiyed58jvCYoAInkb3gL9qE4qbzozo6/HQ/UBhm
 +p2J5pp71F8BQDYiKB23kBhQW4ibDlwjd0+2F6Ea2rd3w38dcgQckEc
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B76140004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: gqsa1g8gxfbmqz3yd5ekhmzqo4t978wt
X-HE-Tag: 1795198287-847009
X-HE-Meta: U2FsdGVkX193V/ArX7HFhZrUI6iiZFiM4lsTx1jcaNqjVj2UNWPln2mCZpUaysA6uoPsRXGzKMKp7H5hH7U3KxqN0w74UU6dzTwVw0HT1gDBQcV4v2+Ast2ptTioIlIUzbLW8Uca4UQ0R0RFwP32xsD6FwLu4DKMjbItqM3uiZEP1Htsb0LNGazlXUo4zKZG7o/+jCY51nFx5M6PsnDvxryQhvds74Gmgmrci2tLJb/9dSmrRlJVdJCi5DM7ahgNGDiEAJNlyc92JyvgT/J2PhsVEQFw5pDogiPe6szbkgqhwxEXCe7ot1R4uRnrovYJfDsliAImTfSrHwnGCjriMMGTbGzbRzgrtRU+nGy31V80Gdec2JehDJJkw3kKULZ7Ad0lGZ9XVcCtZ9aynwFFi/znJ03kEnwqhbAjNhmRBb+TbhTvlZXC5j7fU+MHXGCDI0bMmiHZmMPpmXTrzPPCzJFy6mmIVT2rfD7MCGv6CmsFsmfAA/LXdcLDx2vISoJ9KPHr9vqI/e+nYpTKe5ttEnglgYmeKmwGylw2i5cdqJ5g2gJnwHkGO0F9R15SHIW523dEVxiFHctjeb2gtQlMliTokMowmN5SIJT9C8YsoFXIFDj5VBbJsu7f7aZI8VHwjYLJmVmiNwtmEgfYpRwt1hPRcp7OgKrc9Kb8xhury3a/WBMCSN8oW2vBluGgVKdewi2EFn7FOk2P3Fkh5VLB9L4J5lh7WhctstjlVezZYllT8twKOBmbmiboBYrQVkY4xvZTv/KgscpZwcqlqEq/GMdHKJes1SsagYv7xpbSY2ApSjvFXd9bC09xpI0YNGyiGst2QFXyzffTK3dfgvjLHLH+IOLSxqvV86q/KrirsRmzXZjcHsnS1ZzcrA6RqPs0GNVfj1tTpm+riKXimU1LZ3a99mlNUiGvgvuVX63K9+PekCqZ9lZOdzRQaJPJf6WE7vDkVlrHfgTJLDubnnT
 /sn4cl87
 8v3PGkJtbMvylFQ0VZHdviPO+fz2j3vsa+GQllxucCm+aZl0ZFy4s0hlkGAcxxujHYG+IluFhrjFtsuTe21pCmH3rDCejDX8KeFkJgLHuEf7scfwIHHnUzPssnNuR7cspDaUrwSOQHuiWlztRmqtZDsU2g2Nb9oc0F7L39inQITaglf/zp+LeNtF4LWaiJLMw7WnJHmXbiPLo6IFtkBL1mU611chiqAYnrzVs/fqdwppZ/pOWmJQVZOpWLDLkMZIjXSH9hs28E/1iMZeLd11tfSOAPf7XgVG9N61J5CyCus7pkhCt8fhQt8q9One8mXiX82oXJ0PZKTTK+TYlZJeZi72SE2hguO83xpUnZBgP46HWFI370Gorc3iHoHbFLazw1783FhB02lHmdLk7OInxdFBYxqfkTDfQ9nidxYmlTiEGZyIW+nLXimHUM1s53pBWkbAbLpQ5nc2VKtzma6zmbHrPJ9ymV4b+rvQn6HH72I6f81cZyXVG6bujuJR9siIgqC5A9ZBNCtrg+vm367S7wf9dFkg79IcaDJkUuUa6T69uwwwwF7NpkEu6rPMktO1HzXzMqoPZsBGbMk/d6ZKLxh+Bf1oamaMDdD58WmI2YX3lqWFOvVI0tdJolPwACgHVRgMJKj8g4bL3YDUmeybCi+TdIZJw/jR93X6M3E1zZsnxUxl7IhoPQwlJHUfLf/xoTA5tQJbdfGemEFcY1yggM22dIDJ6tMXjC/BOsHAkg2w6h8ln0wVSuC7/GxxxpcUmWnTCP5/2wgiq+P3LhFWVj7AQquPZMuZUoufP+trRfAaonWN/TrHEpKqYCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

kswapd and the reclaim interfaces currently serve only common memory. A
private node that opts into reclaim should get them too.

Restrict reclaim to N_MEMORY_RECLAIM:
  - start kswapd only on N_MEMORY_RECLAIM nodes.
  - walk N_MEMORY_RECLAIM nodes in MGLRU's debugfs interface.
  - reject nodeN/reclaim for nodes without N_MEMORY_RECLAIM.

Direct reclaim is unchanged: an allocation reclaims the zones on its
zonelist, and a private node's zones are only on its private zonelist.

Private nodes that permit reclaim get watermarks again (the capped
minimum that highmem and movable zones get) and are boosted, since
their kswapd restores both.

Private nodes without the state keep zero watermarks.

The hopeless-kswapd recovery on page free exists because allocations
that fall back to another node skip the direct reclaim that would clear
the state. Only common memory offers that fallback, so apply the
recovery only to common nodes now that private nodes run kswapd.

Leave private zones out of si_mem_available()'s low watermark sum,
which bounds the common page cache and slab that must stay.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory_hotplug.c |  2 +-
 mm/page_alloc.c     | 11 +++++++----
 mm/show_mem.c       |  7 +++++--
 mm/vmscan.c         | 14 +++++++-------
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1cb10c88954e..8146f77919d5 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1230,7 +1230,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
-	if (node_state(nid, N_MEMORY_COMMON))
+	if (node_state(nid, N_MEMORY_RECLAIM))
 		kswapd_run(nid);
 	if (node_state(nid, N_MEMORY_COMPACTION))
 		kcompactd_run(nid);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 864da908a59b..cc70e1b45322 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2972,6 +2972,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * kswapd work again by resetting kswapd_failures.
 		 */
 		if (kswapd_test_hopeless(pgdat) &&
+		    node_state(pgdat->node_id, N_MEMORY_COMMON) &&
 		    num_node_state(N_MEMORY_COMMON) > 1)
 			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
@@ -6814,8 +6815,8 @@ static void __setup_per_zone_wmarks(void)
 		u64 tmp;
 
 		spin_lock_irqsave(&zone->lock, flags);
-		/* No kswapd runs for a private node to restore watermarks. */
-		if (node_state(zone_to_nid(zone), N_MEMORY_PRIVATE)) {
+		/* Nodes that reclaim does not serve carry no watermarks. */
+		if (!node_state(zone_to_nid(zone), N_MEMORY_RECLAIM)) {
 			zone->_watermark[WMARK_MIN] = 0;
 			zone->_watermark[WMARK_LOW] = 0;
 			zone->_watermark[WMARK_HIGH] = 0;
@@ -6826,11 +6827,13 @@ static void __setup_per_zone_wmarks(void)
 		}
 		tmp = (u64)pages_min * zone_managed_pages(zone);
 		tmp = div64_ul(tmp, lowmem_pages);
-		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE) {
+		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE ||
+		    node_state(zone_to_nid(zone), N_MEMORY_PRIVATE)) {
 			/*
 			 * __GFP_HIGH and PF_MEMALLOC allocations usually don't
 			 * need highmem and movable zones pages, so cap pages_min
-			 * to a small  value here.
+			 * to a small  value here. Private memory holds no system
+			 * reserve, only this small minimum.
 			 *
 			 * The WMARK_HIGH-WMARK_LOW and (WMARK_LOW-WMARK_MIN)
 			 * deltas control async page reclaim, and so should
diff --git a/mm/show_mem.c b/mm/show_mem.c
index b90fb5a0016b..24dd33ba783b 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -38,8 +38,11 @@ long si_mem_available(void)
 	unsigned long reclaimable;
 	struct zone *zone;
 
-	for_each_zone(zone)
-		wmark_low += low_wmark_pages(zone);
+	/* Only common zones bound the page cache and slab that must stay. */
+	for_each_zone(zone) {
+		if (!node_state(zone_to_nid(zone), N_MEMORY_PRIVATE))
+			wmark_low += low_wmark_pages(zone);
+	}
 
 	/*
 	 * Estimate the amount of memory available for userspace allocations,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3e934135e805..03d0919d11be 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5729,7 +5729,7 @@ static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
 	do {
 		int nid;
 
-		for_each_node_state(nid, N_MEMORY_COMMON) {
+		for_each_node_state(nid, N_MEMORY_RECLAIM) {
 			if (!nr_to_skip--)
 				return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		}
@@ -5754,13 +5754,13 @@ static void *lru_gen_seq_next(struct seq_file *m, void *v, loff_t *pos)
 
 	++*pos;
 
-	nid = next_node_state(nid, N_MEMORY_COMMON);
+	nid = next_node_state(nid, N_MEMORY_RECLAIM);
 	if (nid == MAX_NUMNODES) {
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
 		if (!memcg)
 			return NULL;
 
-		nid = first_node_state(N_MEMORY_COMMON);
+		nid = first_node_state(N_MEMORY_RECLAIM);
 	}
 
 	return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
@@ -5832,7 +5832,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	if (nid == first_node_state(N_MEMORY_COMMON)) {
+	if (nid == first_node_state(N_MEMORY_RECLAIM)) {
 		const char *path = memcg ? m->private : "";
 
 #ifdef CONFIG_MEMCG
@@ -5935,7 +5935,7 @@ static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 	int err = -EINVAL;
 	struct mem_cgroup *memcg = NULL;
 
-	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY_COMMON))
+	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY_RECLAIM))
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
@@ -7907,7 +7907,7 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY_COMMON)
+	for_each_node_state(nid, N_MEMORY_RECLAIM)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);
 	return 0;
@@ -8268,7 +8268,7 @@ static ssize_t reclaim_store(struct device *dev,
 {
 	int ret, nid = dev->id;
 
-	if (node_state(nid, N_MEMORY_PRIVATE))
+	if (node_state(nid, N_MEMORY) && !node_state(nid, N_MEMORY_RECLAIM))
 		return -EOPNOTSUPP;
 
 	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));

-- 
2.56.1



