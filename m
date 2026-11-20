Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5CF606B9B9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jd4fURSy
Received: by kanga.kvack.org (Postfix)
	id C21736B05F8; Fri, 20 Nov 2026 13:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF4F6B05F9; Fri, 20 Nov 2026 13:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE0D6B05FA; Fri, 20 Nov 2026 13:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 604566B05F8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3BF2160151
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:26 +0000 (UTC)
X-FDA: 85456289772.13.0080E53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF2E6100009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jd4fURSy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198284;
	b=oEcjeHLKvdCGx3lShqScH5aIJyKE6bSOWM2wsftd4AXZtqLEIfsbYkZ4E39SbyI3w3uJuI
	+SRn73ISUGWrUlP4fklWr6nZETQkChtfYo3YT9eON+HVf/P54BqhoLnjeiiG3RIFW6gCJ8
	SAQaFXhnmuRpas83jG/1aNdVXtkzZVw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198284;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imMR3p2duQqhNdG0Ig5xxDisuLnpgFn7S+h/c9cqvAo=;
	b=wF0UvI+4FfYC4NU289Qid0PIsxvWGgjeVlZyQT4gTfUG0RJ36qjHJHKFtnZLFvV8zKDGu1
	AlsviA2p08B4aah7+rFDHy+0sFdbdo48q5Yyv+DKBpy/mVVpA5QUTM+CBhhC1AyB+vUZfC
	nkJMxzHQlhYyS9L8EkT9h+2QNyAGBrc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jd4fURSy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45BC163415;
	Fri, 20 Nov 2026 18:11:24 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198284;
	b=oN5hg8SVxJIEm+eOfQa5dnZxRrXMKw0jOIeESIP4+JvlBwxy4LtUt8IwXHSUcV0fWD1T
	 0KyHJasjeuH0eB0GpdZvbS4aahn22X2wxHSGAbh1pUWaClZUKNx5ilLI6eVGoNzbfzEiw
	 NA0JL15d3FaZxrpT8gjUUNpApMOOWI1GdTUDvDWMq83UiWh2M5gJdpyUQbX1cjOrSUjeT
	 OVgJTFyVwj/B+NLDihulI+4x3BPOXBpIVdU7u2NvPgte7FewZ7oWTQXGoYsgch1t31umY
	 6YCNhwNrDuV8ooHywUrv8qB6548ilIJnSJ9x/gzEW7mCAlKMG//AiV7qI1T6/1DjzWA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198284;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=imMR3p2duQqhNdG0Ig5xxDisuLnpgFn7S+h/c9cqvAo=;
	b=X49mlkC4FajkLoXa/znfgvIesfbtAM8BnO+wQst2HFfMB7XP4JVwNrDJzcoHybmjTtQy
	 ZrJYT4HrF1r2t0PPwnw41BttUtlluVxbXJVAfdmhDzAudHz41mnpMuDvqaIu/2jonohw2
	 ddpTUCgqpCOR9KrfyGw7vxm4PhvOai2cWzml1NoHBo3ZAEmYbU+zPSOZa7PTvvnETXALp
	 WpaYQ/xTSNvueBcp1XR008lliaR5bOswfHVVfAQSmlzL5W8N9VctNkmXZQxD0RJ/vB9b6
	 Dwlj9goVKV3QpqQq4OStgc1eE/S/5Hv/bXtWw3uUI3/t+6x201p8nnySHDKeraWatDw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CEB6E1F000F0;
	Fri, 20 Nov 2026 18:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198284;
	bh=imMR3p2duQqhNdG0Ig5xxDisuLnpgFn7S+h/c9cqvAo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=jd4fURSypMuc1PYJWSEuqcYhKpA1BXYzDrVoNtpW5V7+zZ5o0VtaYTy3KbcB2qGTX
	 4dIfUBTN8u5zvn69Z9HH3S/VtSJ+pxyhk+eGHpP7VYUIeSka8VMgvP4bqBNI/JWy0w
	 K4fTuDOSzH86QLv2UgbkkCa6Bb6i7onAFQowqPPfmfzp5SYOIG3tmZ+uoxlPnBGt2V
	 EYwHRSj4T7CmgHSWsCKBDCuaVSLTbByPSCdn2ZJ2W6Fp1abhF7J/SpEmUqfFUERCqv
	 +qTUo3zf/NcVlpaCczM1aRukH0lgVeuBnpLt5lnoSv+cY8smO0EZ4gHVA3lCL4WWT9
	 hhnb6WxDmFVCw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1AF6E4B988;
	Fri, 20 Nov 2026 18:09:23 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:41 -0500
Subject: [PATCH 50/60] mm: add N_MEMORY_MEMPOLICY node state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-50-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=4477;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=POrrod7a8qe5/RJcpG1x1W6f1yuN7ZdnOW2+WhH0FXE=;
 b=aTDMy5aQgR/eu/TnyoctRRRg14g5CIETIw3u4dDaQdYVGncbixZ+T0SNCnrlFn6DFrsn4+Zg1
 q8XW52q1jYMDuHrNhBZsCfARwTf3Qz3aNp9IhHdIxv9ybHyAJ3U5en6
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF2E6100009
X-Rspam-User:
X-Stat-Signature: 9ni8mfjuewf6d9w63rrqixtm9fiabi5w
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795198284-777294
X-HE-Meta: U2FsdGVkX18Ux9a131QgEgmZBGwZeeVXPTh5MG5QphXhOQuk1KIUnkwUL0Ph8DL1kICs0lAIRzl/5mwVoPZtxRL85wbWLTFi2TIeWFCMSVe+la/a79nBMuMsAH73u2iC1Jm2bz/xFzh1bJKVSKIWiKj6tlyEHG4J+0HKO5ZO3KOdg0bgLDUyDgrju1+TJ5sKLU5jz1hqdvdYq2dYy2pq6SPHcPaPCiiZSHTVQkmH+rwVN/58KFX5Ri81QPSfGqbimj0IdeU7SO8fZBoX22UktSpBuqO9K6s4BDbdyJcPgFDO3myRQOorDKp47gAL808MsY+pm3GTSa1rA+kJuxYUYT9S2APZkuI/njweBX+N/X8nAIZYA+GC9vXc838d6TeUm/w3FIli86YTJvXPDnEKnAC0tX1TE2zzqsoNB8f3U/RmsnrYBy6veOpLfmNeWM2aWAGsRe5p2dD929CPTrekcPUyuJ+Y3BSluVAPuYScEtfq97R2MKHT/Vnj3we1iLaRyL0NjQeeaZaXw2lrLiFzU63sGES+uOt79Pv93GiDnwhDaatrA0DwL+LCAL+gXVe61oNpDNtJYA7CqO+RZoDXzuCf5pIT053yaiJGqBgpXfeJy12rhy6e+8lCMOFQDkbOfQDHbVmq/Hjzo09TaZS1Ln1S8AsXLhWXU5s5538gOp6HFrbO+zb6aP4WpePQWyrGhRVaTBoeginbWDtoWIaJyhUBvsPxT9x8R5l+hpcSWiRBO3CGt8WWwvnYnk1n0iBQGtHVSrtr/VpH3jpMsVt2YqtDFTbQgN6xrGuk8w4q02FpPUJRJIWVt6MGiZicT4jm0YFCu2r8YAchfUfKfw9n+D1JRh58OTpu8ygoo6BuMFilAUJzXnczhfwk51X1nruMLnrOT1hjDJH7rBMexmvXuqGkkwqRL0WHPmk7RtRfO63zuYwfGESLDMw5gzY7X3qblBTuJGwtQT8v5RscfI6
 rqlFTh+f
 Iz/crM26ZvoKr+/2/d7fPdK1FY33UyvURSca3r+I5f2KkO7ADm5ok9eC6Ab9oygIaayTSBRkmu4EUW2PCbs3+hHsX9gj144dDMiGl9ScTEJP2BuMK+ND6tF30+X0fdyOZVVGLyze1w9kHhKphoO1ptx1Dd2R6e4ice1K9DkWEaUqhv2naKKXsesh7lZEFLLohCMvX8JE1bIUglOoXIx/w/VkRCEW2PQyMaGzpSeR1s4/xfwzhTQdymHWgXbTlMHRt/8niKxn0QEOHtwKNuAxFzwivrX1RWxqCaURK+b439GJdBcSimEn5A56U64Wplg9DYld90GoTtWOTF6BOQlFdmagnTB/+MrfAysWVOEAuDszVNAFoELusaPOaglGHCkdATFGw/WGj/kfjvFCI4hmqI1FyxTSQmgh2lhsjKp5qZ9c2/FXgrYzQogCh3aWh85LUCvR4JLvKtrmYNcR2Xn+cvtwnCA5ZZAW0zcPFNqIIQQFww48b/8UTRvpOBOhtkYLAsZsBfrH67QFvk1Y+RyeYfP8rzuJ5UEjMKBUwgRvO5CFV3r/kOEyJlAe6tMbbVBOA/VqZtSkWqKjsfHmnEW4MEHUwaWnFJXjDGrh7c05Po/VSCum48ICmRFCiaSk+hayp2tbUGcm6OYxndyqX6zftMUfYx41Vgnmu274yLQD88bNdRLqkJwfB9jMSCke2OcpmbEuh8826q+TxX+9Rr+gXfC2aXF+gWNQGP9v53yN06UtVyuxDzHyq24QjdKVLjTziWT1ngyzvFBadGUrqaS+67TqaZFtNLDtj3eRVji7WrVYtC7eZGhqskYVydWg83yhL4nm8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Add N_MEMORY_MEMPOLICY as an internal state for the nodes that memory
policy interfaces and explicit migration may target, and
NODE_MEMORY_FEAT_MEMPOLICY for memory providers to select it.

Userspace placement lets ordinary processes use the node like any other
memory. That assumes the node is reclaimed and compacted, so the feature
requires both.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 Documentation/mm/physical_memory.rst |  3 +++
 include/linux/nodemask.h             | 11 +++++++++--
 mm/page_alloc.c                      |  4 ++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 1bafe8c085a3..75752c3a5694 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -190,6 +190,8 @@ The following states are internal and not exported through sysfs:
 ``N_MEMORY_RECLAIM``
   The kernel reclaims the node on its own initiative (kswapd, memcg and
   explicit reclaim).
+``N_MEMORY_MEMPOLICY``
+  Memory-policy interfaces and explicit migration may target the node.
 
 For each node that has a property described above, the bit corresponding to the
 node ID in the ``node_states[<property>]`` bitmask is set.
@@ -205,6 +207,7 @@ For example, for node 2 with normal memory and CPUs, bit 2 will be set in ::
   node_states[N_CPU]
   node_states[N_MEMORY_COMPACTION]
   node_states[N_MEMORY_RECLAIM]
+  node_states[N_MEMORY_MEMPOLICY]
 
 For various operations possible with nodemasks please refer to
 ``include/linux/nodemask.h``.
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index be5edbee2b22..c7a1800d9171 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -414,6 +414,7 @@ enum node_states {
 	/* Internal states, not exported through sysfs */
 	N_MEMORY_COMPACTION,	/* mm compaction may operate on the node */
 	N_MEMORY_RECLAIM,	/* mm reclaim may operate on the node */
+	N_MEMORY_MEMPOLICY,	/* memory policy may target the node */
 	NR_NODE_STATES
 };
 
@@ -552,14 +553,17 @@ static __always_inline int node_random(const nodemask_t *maskp)
 #define NODE_MEMORY_FEAT_COMMON		BIT(0) /* add to fallback zonelist */
 #define NODE_MEMORY_FEAT_COMPACTION	BIT(1) /* mm compaction */
 #define NODE_MEMORY_FEAT_RECLAIM	BIT(2) /* mm reclaim */
+#define NODE_MEMORY_FEAT_MEMPOLICY	BIT(3) /* userspace NUMA controls */
 #define NODE_MEMORY_FEAT_ALL		(NODE_MEMORY_FEAT_COMMON | \
 					 NODE_MEMORY_FEAT_COMPACTION | \
-					 NODE_MEMORY_FEAT_RECLAIM)
+					 NODE_MEMORY_FEAT_RECLAIM | \
+					 NODE_MEMORY_FEAT_MEMPOLICY)
 
 /*
  * Common memory carries every feature. Private memory needs NUMA: node 0
  * holds all memory without it. Reclaim leaves high-order requests to
- * compaction, so it requires compaction.
+ * compaction, so it requires compaction. Userspace placement assumes the
+ * node is reclaimed and compacted like any other memory.
  */
 static inline bool node_memory_features_valid(unsigned long features)
 {
@@ -570,6 +574,9 @@ static inline bool node_memory_features_valid(unsigned long features)
 	if ((features & NODE_MEMORY_FEAT_RECLAIM) &&
 	    !(features & NODE_MEMORY_FEAT_COMPACTION))
 		return false;
+	if ((features & NODE_MEMORY_FEAT_MEMPOLICY) &&
+	    !(features & NODE_MEMORY_FEAT_RECLAIM))
+		return false;
 	return IS_ENABLED(CONFIG_NUMA);
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cc70e1b45322..eff9c3d8251f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -206,6 +206,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_MEMORY_COMMON] = { { [0] = 1UL } },
 	[N_MEMORY_COMPACTION] = { { [0] = 1UL } },
 	[N_MEMORY_RECLAIM] = { { [0] = 1UL } },
+	[N_MEMORY_MEMPOLICY] = { { [0] = 1UL } },
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
@@ -224,10 +225,13 @@ void __meminit node_set_memory_state(int nid, unsigned long features)
 		node_set_state(nid, N_MEMORY_COMPACTION);
 	if (features & NODE_MEMORY_FEAT_RECLAIM)
 		node_set_state(nid, N_MEMORY_RECLAIM);
+	if (features & NODE_MEMORY_FEAT_MEMPOLICY)
+		node_set_state(nid, N_MEMORY_MEMPOLICY);
 }
 
 void __meminit node_clear_memory_state(int nid)
 {
+	node_clear_state(nid, N_MEMORY_MEMPOLICY);
 	node_clear_state(nid, N_MEMORY_RECLAIM);
 	node_clear_state(nid, N_MEMORY_COMPACTION);
 	node_clear_state(nid, N_MEMORY_PRIVATE);

-- 
2.56.1



