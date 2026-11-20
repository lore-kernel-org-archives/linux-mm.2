Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B459D606C952
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FiNtXZFe
Received: by kanga.kvack.org (Postfix)
	id 3E17E6B05ED; Fri, 20 Nov 2026 13:11:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345976B05EE; Fri, 20 Nov 2026 13:11:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197956B05EF; Fri, 20 Nov 2026 13:11:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D44056B05ED
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57A93C0143
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:04 +0000 (UTC)
X-FDA: 85456288848.13.351D127
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2DBF420006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FiNtXZFe;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198262;
	b=gCCjNnR/j9Xa5GiKeDS7Xl5bPfLPTsnvdwz0aSM48tNIi5x+svlRmryfEFFJ6nCrj1b4j2
	HU6NArVMuStM+BGP8zZzIKfdMVCCL+MQqTIKtffwT5q3IRmul6Vgf5efOEjqkuz1NPRo+A
	diAlsX64nXoVxHdNVL/HoVeoLwYqFWU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198262;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9int1jy49B7hwGXzuzABb7Yf3ibBtagCxCa/Nz1EVw=;
	b=A8ouHtlPwHCyFaTpaHb7YJdCegEKbf+8ssguE5qYz+C9Q6+QAI1FFaAnkeJa2ZSB8+x9Rr
	Z6pWwqrXcSPAZxENJ3rymE+BXYO0zkGbzLwi5yc7fP2g+0A7Fw8/p6+Pb5PQ49SrhPjesS
	QaD0KaojunEuRaUFBoaRM2Q2qkInYMM=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FiNtXZFe;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 418E746C80;
	Fri, 20 Nov 2026 18:11:01 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198261;
	b=2e8VgvWw20oGJbhaFAXSW9AE3LuCDd9mWgBDby6E4rQR6pwNWb3s+fZNEvWs6aTSFzL+
	 SDpCwQRy43FTSD2lNGg5NSW0EtfOz01/wwfLh7K3ZvWefgtNbE10uncMfJzCO2Wfqj7k5
	 XNP0qzaX8t+sSh7YSW0O9/rEHqLDArer8xLdpimjmV3P8aWxJQVJZ6RcHp6UWsNRAHaa9
	 AeQE988IMJ7PrAJnt0eSSESMDqHqVUO2DYIXlOag+/AfVHNyLz16EoeP1hk8lDZwsfz+V
	 neGU50/BfiT1YCyqPvShVGr992umvT62yhG5AOMrqCsMR7yoHFjl4CW3TX5xIkM/6TA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198261;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=t9int1jy49B7hwGXzuzABb7Yf3ibBtagCxCa/Nz1EVw=;
	b=Yn7j1+An7+Au8r0j4D+VqtzCBAGz6XWf7a4vI+M0Ax+ZLoEHgBMnohWhCbPelApUQEEs
	 H6s/uYvyrgU342ggsdSnvqzlKCFyPLLXJg5VhCDXQccwWMph8X/+QwsiyD44rmpX+vJtx
	 X1TXY54LC+qzzDWyZfQ64gUtaO3RHESru7PrkPnlzZpOku4E2a3BjDmP5cKcLpw/j3UdT
	 8scYPY3Zm3w2FsMfSrCouh5k1U+KtAk4eNz0JTCirG9OZRMjomXikzptG5MFQYRcO/BaP
	 O3y0MvYObM5liyzhGiTTl5DpKldsuXPHjb8YDVlBQQP9fXuUH4N8QkKFmEvtG6M2sGQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0B13E1F00AD4;
	Fri, 20 Nov 2026 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198261;
	bh=t9int1jy49B7hwGXzuzABb7Yf3ibBtagCxCa/Nz1EVw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FiNtXZFeLl1TrtsAtUHZi0b4+W2iJ/cCZI1gI7GcYTjZqmyCC+UHmP0xpDfP84IMT
	 gSGHmFNRGUnHi7+9ZDg7LnuvgLNj+oW60gvkqNJGFdrWUMj7UR5paFT1n0Jl/LvJm4
	 UQ+3GefGWuyKeeFPod/FkxKNjkkiWl0bAvK0IJYxg46SM+AwLnWoCVxT4QwhBDtLsH
	 hy11uA4+ke8KwfJnAHfmERpG8aGhC9LymhE7GA9/JP+xVlwXGxPyv6HRQ62QTNwFPp
	 1YRvg6eiYhj2WYeYIN0BFyq/5FdJzpeSTXpOylQ7ipmacE/Af95PD+QNk6r/7PfwKB
	 fQ9QIkAWdgxVQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 78A5D4B975;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:36 -0500
Subject: [PATCH 45/60] mm/compaction: restrict compaction to
 N_MEMORY_COMPACTION
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-45-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=2489;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=M6oyV+uEjYSavi/eHygS70B16tEpJIW4P5C3UsQGkVw=;
 b=i/PUXbQkpoN7NVE8RFc+oEQ2kDN3DCJbLPIIOQ1aa2JDj2LavBaQ5jxI9kU+y+KQpdfh6F4lB
 iarRB2RDZBvD/7ptCHks4k7qA+bRL3m/1zijoNFVJyaSj9mQYSEfV+o
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2DBF420006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jb3zi67h7rxff8thz9gpq6nd7b93f9u3
X-Rspam-User:
X-HE-Tag: 1795198262-373227
X-HE-Meta: U2FsdGVkX1/9o0Gm0GQ7I9b2y/mIJN984w5NI/aAUT0oo7qc5bBkhPtByvpUE7UrrpuuJHOoOu78sh9en9VCxApLdOgQlBdiJrimHPogsLqcR/zxw1jnwfA5uFXkXsvYT/sF57ORFNa8n478raOqVebzqbjjzMMjbr7FTZFTWL6bVLYrrRMunxCLkmsUt1qo0OdtEbQW1gwZJqwwc0TmSYLn5w26a3xj24CvHqhhfwayay2mFs2ZwBPPne/L7D8I8O7iaWxEUcm8OjC4fND1zFzLsGQmNVhoQSCzD1l6BKVs1U466sfgAy7s74nDkkG3EHCan7Ly3goccJ5oucZQGlIhEVot2b45ZSFK0ic8EF/0z8qnNiM54Z9SdAZZ2AdhaVcbkXwmrsQ+R5U0mdLXV67lGOHU50EkyLyGc6kDUvNSHbq1ehaOwj+OGVUpXbVTMWa86ckX6i8500NKOW8lnBypUXnVN3NKJyTjoeuNPfc1bY1/OV23wxyDlbT/h35QAhuEo0QsRwQQUmhLBHu3S6xQKey/iMRqy4vchv2Y1pHT5Km4+Hp+d9C5a0v5qVZC1jjuPk1iXu95VX1QKltCS1mfOZCHqwUHjMHC7PTSHC2/wOk9azlA3fUydV9CGMp8+gEwHQlDMToXo9RDymEhek1KFn3Ah1wsrZvuR+E3gKVNwYlPszdaShbqUHnT+YE8B1cQHBl0aw/UpC5UHEfWR9kZ9d9SFX0b2FEuCPwuRxsm7BRtcruBhHzgydDjypRNZr/wpfy+st50Dco2gkBVBpo8zvHQaYbGIiKNasQgSmjVqcFbE1zk7In8ubBt6NXMVxByUBhd1dgsEzESKnw98BAm6grHfiiBgxIruuKHQEtMCJNTbF++YlDgburvXV+ZhFaRb48jmTfl4oNWqWEMKsV9oGlYYNO/mNKmiV4b69mjyWXTSBgBiS6uO0f5XdbLhjwzMozDd+rB7vdNmsX
 IMqH1QFI
 RHV5Zgm98VsCyaloo6hnbupAvcl/mzxQuy482ionRd61g3WcEHW1SK0SqYPt0Wr5pWKNlSFlNRtKUYh0u5qDz/IhF+snM/GiF5P7zwEVc+YHWSMFZSwcWOwb85vGdzrNKktmHwDqJdvZswkWpM97yDlFp8Wk6zpGxTKoYWp8Dy7Zmm3lFNUib9D2po4rg8clgHAm3t9zIvszEP0Ko9eJp19tMsDIPR/DV53N0vkwkMdhCX+u7pq+i5tEwhxlJBnvnjv50c1gX+Yy8uFK4UF53S2JXCVKUEO+TTXGkYFMm0w4m9EX07TZ5jVtKhKpDFnson2DujKMwKL9ubP3xjLXNOZ8b3hMeFtYqHEcvgpZgmlkblebyudAizpfXG87QkOhqmmvQ3NohIexmWF4M8VfTkK5HvxHHKX4f9Af7BiaaTRHAvLRJP/sga9nh3M0txQNYhRqVsTVGAirMKTwhgwNA6AeuJ10voANzLLubUhfHxOGbc7E8B6jR4IGEk1p+FjNxiyygi5qoB4acnCGkUs4x3+l0Bk1Q9eAXdw/YC3I/tMXHSXZvUyQTZW411vYAC1xH5asGo/oltrbNmH2Ijzt053s1WUvmquHpmJ7cWzpAbLfVhbIPUr9jOTv0xuSo3O44G/6WJdBuU1pKa+O6ajWzZG8IFk9Y7O4zcFyCyYHWETEv+AVsBXlOLweYJUG2VtwOUq/FFon0Z3MTuLoOgnbQ6QIxHUZct0jbA6G+3AtA6wKOfl5dMpKoM82GcMTGKe7wzg0aFsw5Lu83h3r7xyk14z04OY7xjeLKaMrRAyzbp5B1wDZ+Yp/OLh+O8ulUQu0suMYE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Restrict compaction to N_MEMORY_COMPACTION instead of common memory:
  - compact N_MEMORY_COMPACTION nodes for /proc/sys/vm/compact_memory.
  - start kcompactd and trigger proactive compaction on those nodes.

Direct compaction is unchanged: an allocation compacts the zones on its
zonelist, and a private node's zones are only on its private zonelist.

nodeN/compact fails with -EOPNOTSUPP for private nodes without the
state.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/compaction.c     | 9 +++++----
 mm/memory_hotplug.c | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 283d4d4e78c3..6835ddb91f29 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2973,7 +2973,7 @@ static int compact_nodes(void)
 	/* Flush pending updates to the LRU lists */
 	lru_add_drain_all();
 
-	for_each_node_state(nid, N_MEMORY_COMMON) {
+	for_each_node_state(nid, N_MEMORY_COMPACTION) {
 		ret = compact_node(NODE_DATA(nid), false);
 		if (ret)
 			return ret;
@@ -2992,7 +2992,7 @@ static int compaction_proactiveness_sysctl_handler(const struct ctl_table *table
 		return rc;
 
 	if (write && sysctl_compaction_proactiveness) {
-		for_each_node_state(nid, N_MEMORY_COMMON) {
+		for_each_node_state(nid, N_MEMORY_COMPACTION) {
 			pg_data_t *pgdat = NODE_DATA(nid);
 
 			if (pgdat->proactive_compact_trigger)
@@ -3038,7 +3038,8 @@ static ssize_t compact_store(struct device *dev,
 	int nid = dev->id;
 
 	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
-		if (node_state(nid, N_MEMORY_PRIVATE))
+		if (node_state(nid, N_MEMORY) &&
+		    !node_state(nid, N_MEMORY_COMPACTION))
 			return -EOPNOTSUPP;
 
 		/* Flush pending updates to the LRU lists */
@@ -3369,7 +3370,7 @@ static int __init kcompactd_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY_COMMON)
+	for_each_node_state(nid, N_MEMORY_COMPACTION)
 		kcompactd_run(nid);
 	register_sysctl_init("vm", vm_compaction);
 	return 0;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d7ce60c6815f..1cb10c88954e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1232,7 +1232,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 
 	if (node_state(nid, N_MEMORY_COMMON))
 		kswapd_run(nid);
-	if (node_state(nid, N_MEMORY_COMMON))
+	if (node_state(nid, N_MEMORY_COMPACTION))
 		kcompactd_run(nid);
 
 	if (node_arg.nid >= 0)

-- 
2.56.1



