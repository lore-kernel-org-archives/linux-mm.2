Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8975E606C95C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c/FOeaVe
Received: by kanga.kvack.org (Postfix)
	id B0F136B05E7; Fri, 20 Nov 2026 13:11:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABEE06B05E8; Fri, 20 Nov 2026 13:11:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939A86B05E9; Fri, 20 Nov 2026 13:11:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60EDD6B05E7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8C73A0157
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:00 +0000 (UTC)
X-FDA: 85456288680.18.3274F43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B505140003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/FOeaVe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198258;
	b=wwgxXjMBGdDFZV7QLuEZ9KwGMft1yCiSZuxgChlC3AHdq7ob4GVidXO/V4cTMYzx3etm4E
	lsPErs4DmA2rn0bRsaqFtWC8bAWxepH2O+sdKW2EpNznMiupnYoLbpD/wmpdD9GL+tMgyC
	Po2TOBAyQKYett/M6Q+NJ0dzgUnc2xA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198258;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7OURSsmBiNAAKz0czFdC+E/6wbPVxqwq73TmOo8fvs=;
	b=miu4JL9ZIBARGKG1gnWbHhLk/hkCorvI0gmcOz6/t4gl0nvZU+DJRqBzi36OtYioDiRK4U
	mTSFlOj53bSGYi7ZLb7dAyFdpGoSgekt68ztTh2nVWh4eB8bTBaBF8rA2dU03+WSlp+EN8
	CbIcAvv2V3qsS6PJterBSVqvwd/V9AE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/FOeaVe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DE88404DC;
	Fri, 20 Nov 2026 18:10:58 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198257;
	b=Fk41YanxFD9ltdT6Si0/y78LUoZ11jWS98CcYQANmmkl95tlMSBJHdmu8qcJlTgiiy58
	 avDihpNwByq5C6XhhXdsGiRBCTnuiAEsTq1nXwoIhhI3NRDfnTTVt4wGvKt5mAzlHix87
	 PVlW0rFbTgdsNKJ2QwzhIs4FFHmTW42wcDdNpABgdn4ndLpXD8BAJabvbLkyqIVd2filD
	 /89HgzUal7x0AGO0a1ivwpkqOW9vNkPmwY4KT+G54b0HFpotnR0zz2iS/G5hpwJvjuaWI
	 dK/fPjv1LI9Twt68o3Z5kexZus3FC8MzZRQqX6csEyuNhiHmtWrpygwC4lV9WL1Cxuw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198257;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X7OURSsmBiNAAKz0czFdC+E/6wbPVxqwq73TmOo8fvs=;
	b=iiWQHyPD3RuzXibebHdJeLNz8Q6HhN5aKekt77bFc4hBUZPa/iUEDDkmWoI0vea80pKg
	 +yyAfdna6GsESGpvnKflVr3pXTvFdl4utJiGOqtkWjle7FD97ISZIvpzC69g5LjzgFF8g
	 1hjxEvIK5KXeH8/2MNKIG+frwK/In60rCFBdwsWpUP6T0c8NaPf2pxOpgRX08EK/vWqJ6
	 2ShtCibyxIRQ40i/mjWj/YmKs9d6P88GF6x3B5kNBXZPPO+W0AJ/Tu1qwz8PtN55HJe1q
	 WEtMxfKUA3+U0QfqGwEVe0jA7tbZ1EjTTweJwoKIj5bZvcKVUoqU8BtpftPvF94U+eQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2B1581F01809;
	Fri, 20 Nov 2026 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198257;
	bh=X7OURSsmBiNAAKz0czFdC+E/6wbPVxqwq73TmOo8fvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=c/FOeaVeLJZWtA+5a6dBdMMaXisyLI8AF9+8kZZ6tjHUZGumDTs1o1Woz8PGJOBtd
	 JEAAR7MJUM5B2L5h7X8kzlgW6F4yMjqynFM3LZ1ykoNRlcvc+rR8qj9iaDbbVYlOZi
	 4A/C+5LjZ0a8/2jHyVPrTvnGlED9rqtbDz4GSehdrQyj8a5v64ETsgnFHtbGXcrK1Q
	 cXU6zqm6yiHxEND9rxfttDSUV99fJhgStD0VZZB5Nj5riRIHNRKVxUWdAQBRJ4jCam
	 pJRNlCv40utWZYqR2L2j1VSF1eKIMuVP2Ribn4KE+uJ1L8zJ4d4D+MHhLLY7QQXIKM
	 gL+Bv030ncwKQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5D47E4B971;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:35 -0500
Subject: [PATCH 44/60] mm: add N_MEMORY_COMPACTION node state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-44-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=5165;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=g7ydIdopU0v+cqoPiLJmqWYEIQ70E6DWexCPxxD4cU0=;
 b=Ddw1phUFx8GRbqgTFY+sDiYn8K+6nhCoWRNObiJW/+7XlTHPwI01iZM9GC51adS8pYYGCvW+Y
 J4qL4HCpvf6CbWfMf+rMSh6u7SUxavjyPEy7loBIXocrA9zjhLa1w2G
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B505140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: p3jefyp97cpsoatkj3mch9mpihmr5gbj
X-HE-Tag: 1795198258-64781
X-HE-Meta: U2FsdGVkX19w39FkGDvtFfbBxRnpsU2quUu+TD66pBn8P0Xwiv0/lSYmW+zg3ugV5MKZmWgBnm3Rapu+kQfnh/WCOtzNx6hjAVEBD3Uy1XWmojZnwVb4NB6n2Zvi76Z4/c7dcbf1G8Ok6ac0naHJJDmvCRWD7Q8JN1UiM10KoNraHrUCITga15NmpCvriHOXPEbqusAoQbJA9pdlv9lIqb+jnp9wOeOyi9nGF8XVNwCRamYkhi3rfA4Dy6xud3XVh8yjxjUh4D/BI/kTAEwEm+HiqbMZwoQlxFE32F0c9DpITN5ZaRkY4bI63aeilXVjGPl44Ls12ZpaUBjkE9M6M9dImtHltmqdIATOjtBWlIBHShAag7g0r/OaV3e6i5BTjdfhJK/UNfAQE5R/s6cL2X836c6QBmyf1GDMyOdDlrmmBRCfMmRITgagSPTHhZzY7vsY1BumOS7jUvLBMkrJK6DPyPrtMXEf9oXdvVfZ3hIwRFpXgQr6VASierrGQvc2CQJO2jZR4ludtlnS8ZmgxoZWrwVeJkAViefIh5S7wOSiVytRDB03F2vdbMf/TFN9ElnfxSdPIbskQG9QTpHx7P529lvnx0EJH3LfxlAFYC0RnlCBUpKR4jehp//nvRCE1LMP/P3Sbsj80TmXi3WgYUzkaLVRmp/9pkmj5utJZPbA8Jib1OhBmCRh5uKr7du3veu3gwWKQrz5/G+sZ6+CB5e8UcWHKvQcdR657DFbAPlAkefosD5T95kh0YeDft5vRFFIQuEnFPPFw3DjcJ/LeG+o3Dl0qTCY7So3/cAULTwD5te7CagjPncvUUTd/02F/8bneWakoztIYO/vpETynLfXQ7Zl6TiQXpy03DvlT7WJbTutKI+3sJ7tHeEBhTrpYnvPwbcrTwjMU5nvNCiTJIE6wXs1G8EdCojZxEggqikZQK/IzJh2aXC6TXJtd6IfDeU0xW5/6AtFHsOZI92
 NlYDE+bx
 SjBSNefxzmA4tZMOFCPbLmFj6vKO10IwZ421xe2Ek36G47e9IQqEg0l2s8AeKr5z4LMzyZ5U80ZJXJsajIIFMJpyfDq2YsHfrlrZowL2XEj8PXYtYj2kIwA8gTu7S30HyUZX1R3TRyRqkNkO4Dk4rtOHzMmK7pDjSSwudwMcedBPRHwNbOkkO5zga2fRowthcEmmxbgFOXbYJJ9nje9zvarNvy/iUFTKz2dciDs0Gj73gQvLwEo9iGAdZ9+q1O7ajvdrNT3rj85CFvtP+dj/YEwR3jqfb2L2fqvVOkuKbcLUXqQllKS1DjEH67ldJk7BG+AeBtK8XdBVfndqVS7WTOjFhZzrFKxbgaukYRSBfCnKaPYRdHn5j80F8xsX8XfUSUwGoPaKNbUpnEFX+Ir7QYpzeRstkRoo1AwIbo6vetmpiN6jNG7DRQdIZk46OguNqxay2vBgOQhKyDhoDhucxmY5fFIye0lDNeZICiP+4hIKQpDKgdiFeb+VQlt6TJOILJKyNnxrFMxHNTeh267f4jFbpmd5LSs/8nZFNehp0X9cok0PuYWTESLwH/Tmiv0e7yLXhppok3zYh1CejxSGQsHoL8vy0YiWHx90O63Fk8s2uP1lK6adfCX67U8vz6SYaTeiS8QK61059CgDYF5DBG56f7pnKFnoP4jAO8KQ5kYKKTBthcnTkE5OHmxThn78sTXL3wrjMEN1y6+/O5HhEDOh3vQ0f073wgo84yxozY30VmQbttEzOA6oxIVka43amr1KnNXHtfnooA3U9h6/3pEbia8/ledpt3kOaXuyZFukqXIHjLElaHkZU0E4lX1D1R18C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Add N_MEMORY_COMPACTION for the nodes compaction may operate on, and
NODE_MEMORY_FEAT_COMPACTION for memory providers to select it.

Common memory carries every feature, so a mask with
NODE_MEMORY_FEAT_COMMON must now include compaction.

The state is internal and has no sysfs file. Internal states follow
N_GENERIC_INITIATOR, so check sysfs coverage only for the states up to
it.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 Documentation/mm/physical_memory.rst |  7 +++++++
 drivers/base/node.c                  |  5 +++--
 include/linux/nodemask.h             | 20 ++++++++++++++++----
 mm/page_alloc.c                      |  4 ++++
 4 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index ddba7c890418..5d0a69f6c23c 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -182,6 +182,12 @@ nodes with particular properties as defined by ``enum node_states``:
 ``N_GENERIC_INITIATOR``
   The node has one or more Generic Initiators
 
+The following states are internal and not exported through sysfs:
+
+``N_MEMORY_COMPACTION``
+  The kernel compacts the node on its own initiative (kcompactd, proactive
+  and explicit compaction).
+
 For each node that has a property described above, the bit corresponding to the
 node ID in the ``node_states[<property>]`` bitmask is set.
 
@@ -194,6 +200,7 @@ For example, for node 2 with normal memory and CPUs, bit 2 will be set in ::
   node_states[N_MEMORY]
   node_states[N_MEMORY_COMMON]
   node_states[N_CPU]
+  node_states[N_MEMORY_COMPACTION]
 
 For various operations possible with nodemasks please refer to
 ``include/linux/nodemask.h``.
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 56a1741a6a45..19f93cda90be 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -1000,8 +1000,9 @@ void __init node_dev_init(void)
 {
 	int ret, i;
 
- 	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != NR_NODE_STATES);
- 	BUILD_BUG_ON(ARRAY_SIZE(node_state_attrs)-1 != NR_NODE_STATES);
+	/* Node states after N_GENERIC_INITIATOR have no sysfs file. */
+	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != N_GENERIC_INITIATOR + 1);
+	BUILD_BUG_ON(ARRAY_SIZE(node_state_attrs)-1 != N_GENERIC_INITIATOR + 1);
 
 	ret = subsys_system_register(&node_subsys, cpu_root_attr_groups);
 	if (ret)
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 02908ef23a62..2757acffff2b 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -411,6 +411,8 @@ enum node_states {
 	N_MEMORY_PRIVATE,	/* memory outside the common pool */
 	N_CPU,		/* The node has one or more cpus */
 	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
+	/* Internal states, not exported through sysfs */
+	N_MEMORY_COMPACTION,	/* mm compaction may operate on the node */
 	NR_NODE_STATES
 };
 
@@ -542,16 +544,26 @@ static __always_inline int node_random(const nodemask_t *maskp)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 #define for_each_node_with_cpus(node)	for_each_node_state(node, N_CPU)
 
-/* Private nodes omit NODE_MEMORY_FEAT_COMMON. */
+/*
+ * Private nodes omit NODE_MEMORY_FEAT_COMMON. Their providers opt into
+ * individual MM services with the remaining bits.
+ */
 #define NODE_MEMORY_FEAT_COMMON		BIT(0) /* add to fallback zonelist */
-#define NODE_MEMORY_FEAT_ALL		NODE_MEMORY_FEAT_COMMON
+#define NODE_MEMORY_FEAT_COMPACTION	BIT(1) /* mm compaction */
+#define NODE_MEMORY_FEAT_ALL		(NODE_MEMORY_FEAT_COMMON | \
+					 NODE_MEMORY_FEAT_COMPACTION)
 
-/* Private memory needs NUMA: node 0 holds all memory without it. */
+/*
+ * Common memory carries every feature. Private memory needs NUMA: node 0
+ * holds all memory without it.
+ */
 static inline bool node_memory_features_valid(unsigned long features)
 {
 	if (features & ~NODE_MEMORY_FEAT_ALL)
 		return false;
-	return IS_ENABLED(CONFIG_NUMA) || (features & NODE_MEMORY_FEAT_COMMON);
+	if (features & NODE_MEMORY_FEAT_COMMON)
+		return features == NODE_MEMORY_FEAT_ALL;
+	return IS_ENABLED(CONFIG_NUMA);
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b7339bc634d5..335ce73e645e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -204,6 +204,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 #endif
 	[N_MEMORY] = { { [0] = 1UL } },
 	[N_MEMORY_COMMON] = { { [0] = 1UL } },
+	[N_MEMORY_COMPACTION] = { { [0] = 1UL } },
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
@@ -218,10 +219,13 @@ void __meminit node_set_memory_state(int nid, unsigned long features)
 		node_set_state(nid, N_MEMORY_COMMON);
 	else
 		node_set_state(nid, N_MEMORY_PRIVATE);
+	if (features & NODE_MEMORY_FEAT_COMPACTION)
+		node_set_state(nid, N_MEMORY_COMPACTION);
 }
 
 void __meminit node_clear_memory_state(int nid)
 {
+	node_clear_state(nid, N_MEMORY_COMPACTION);
 	node_clear_state(nid, N_MEMORY_PRIVATE);
 	node_clear_state(nid, N_MEMORY_COMMON);
 	node_clear_state(nid, N_MEMORY);

-- 
2.56.1



