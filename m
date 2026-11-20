Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B21606F171
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YKIfjbgH
Received: by kanga.kvack.org (Postfix)
	id 393506B05C2; Fri, 20 Nov 2026 13:10:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31CA96B05C4; Fri, 20 Nov 2026 13:10:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A266B05C2; Fri, 20 Nov 2026 13:10:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA93D6B05C2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72EE6A015A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:07 +0000 (UTC)
X-FDA: 85456286454.17.CB6B240
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5389340005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKIfjbgH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198205;
	b=lN6ypFzB3uLD11/TIpVNJhmIR1c0xMcARyXE1MuPwKu/S81hXT2POpC9f/OknnX40Yjk6b
	deRf1sIA+MOwivzqXNUEXGKwftqiYZZrJj3VjA9rRVUGIPfftB0ysOP6be3h08s5+agPEm
	fIuj8fzvo8yIGvqfyq+5JBE14DY7HdY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198205;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cabvuNy33zQdENtGlK+47ghfpMiZg8BMWdRKAMzcY20=;
	b=AjKuxvmvvFiFknz20wMzp68YE7qy8ctwU2Wy7RCm/O2U3cVJF+O9B14sr+OJ2lF3EQw5z/
	p/b2UdkwGRhZCfXzzK5CaH2jYYLeI17/EnsqRtdPZyZl1UFOACpszp9tAZ6Hb9z4P4a0PD
	8Dof2yaggx+l7X3VBRvUwQG9MTh33TE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKIfjbgH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A6E246BBF;
	Fri, 20 Nov 2026 18:10:04 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198204;
	b=1Glh7xG7DQyQgs58vS+RFn2bEuM/v5veajKq/eNgHQNRVcx41ilyer8YLvNp5DB9952J
	 j2uABzE9qQxhfrf/lxzTQ6jDr+5os0uxMKO0AkIUpvcyOMLbQdfRionsJCVkAIEUIxMga
	 syl6/1cfjJ7sHcY7cLRHbkmNb9wCLg3Nl7WejDTnN5S5QjZQew9EEduKg2h6ezr50nZ3K
	 J7sWHr9+/671pEDgUkjg90V3mqYy8s4vopMrhe6XvcbBLurBdyszKXGryT2OaBFSnDqMY
	 aVhxPhfTdRzEK73eg4Z0dnX8dUR2ixOvtYYAWsciVbjaj6Rwyw35MT9g43dO3tiDdhw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198204;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=cabvuNy33zQdENtGlK+47ghfpMiZg8BMWdRKAMzcY20=;
	b=RoHAFvx6CFYBgjDUjov8c6/LKC/hzsQgPI8lJurlNWLGa9NKRfEN7mjBtuUVOHkfatjd
	 XUwBrr18tOpzRWBmp6juTz4O/FG1tYP27tB81pOeZHwazFXZXme9FcL3wZ9RTUOdBmEmX
	 xkKCsA6z4qKCQormSLRdlqxWDZHufN+QeBKwwCUzsZkuwPZgPAMPQFrBrmuGowpQmZmtb
	 UP6nEuuAoOoVhXtLu1IGRU6JgB7v+kvvkuEiKnWYYe0WQgxXch5WUIj4eJr1Z/bRKNLFI
	 ZojA0PA9GKL5X2m0Fs3Vt6b/hBhFRQacJl7bup17aNjqHAOlB9NXp8Soo+A72mf/LXw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 88BA11F00ADE;
	Fri, 20 Nov 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198204;
	bh=cabvuNy33zQdENtGlK+47ghfpMiZg8BMWdRKAMzcY20=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YKIfjbgHpi3PF4ZltXAmdFkEgFMJu7tiBnP0Qv0WYdlKvliiGi5LnEKpnSwO8I6Eg
	 nm6dTfrA+by2pdK67QWdAhwdqzPARnDFAVvknFGFEZx0Te/olBti3xV3a00J59d1qo
	 7FgYoY6DKHmiGGhZRVEQNqKOreCgHN9zvfLn9gO0GSeJQQ2Jn46ohMF0ad2n5ADKYD
	 WdeLpB2If1i1py7nAifkP+IRp33MGGZJC6UIG7agde4ve241A0tQg0hfvJ4hTnmfU5
	 KSU854TMQSRW3OU2DaWSPmDmKc8lmdLHDR0nfeGdSUmMt1Mys9ZIJ85LuKvsCwysAK
	 ++rSQLDWIO6CQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 86BA04B8F5;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:04 -0500
Subject: [PATCH 13/60] mm/compaction: restrict compaction to common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-13-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2217;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=BmbnHul2BY8/db5+GiTddW3CKoXNqAVos1d4H4BuQY8=;
 b=UBJbyCgvQkAHnb0K2qbW7oGYgoTN2r8jD/DTCgat/O2ohtOkVQif8zR9qpcfBTBGByrEoQt25
 bXDi/nE8V3+AUav43Xm1EHfXoH0es9WCRtJpbKRVj72i9Kflq8+RAVP
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ytpzenu8atjkbebn7garygmg4f8mzstg
X-Rspamd-Queue-Id: 5389340005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795198205-874761
X-HE-Meta: U2FsdGVkX18qLBicihJumJy+0gmFmuZ0JcEjIaSTcae2tUnEglLaSoKxJQddQALln3ivVNU7RTTw8HVTBpUbj4mvG45b9H0vdXUGOUrqiEYv55hSc/pKbhT79DHU6zWQ67VfGhnLbsn0GrmMOsDm3F1k3FY5uzLfcZ0VtoJIDphdota0bMSnGr8ZwrpaIJ5D+gkszums8eE7kjPQiQbvKj1pspqaBpgHf1jxPycxNyUrKZQbmztHHLWrX1438ycKOx584abflHTO5ybDIsW0cWk0u8Z1MdoRJkPeItBHFZ62HLqB2AZmR/OiyYZDlE5M7mThi6fJJQaTCOH+J+UgEFFCDEh2IjTtUftgdI/6rfhtlaQGxddQzpJOpcWIv3xcYHDDIgcfuuBtUGr8V3EobR/Tg/TBSfG/bIb08ghXXfqrK30EZGoEV5fvR9xVMIXZ3OAOQ3rIH4EI+9CFAYBBI1K6pLqQPo0OvJ6M4gvhUYmTPEXRc8kqyfNL0RJwTOrVBb6VQLGuqEwMA848QeXJVps1OhG1TfdfbsAH2SojHH51UbKp+ssvpw+NlhVJ32hOweVHljsGDsxaMx1VwD7d/W8A4OIxO8ELflkFdxhDaTsjBJL/tsJ9qRG7sCMqeFb5fZi+jD6R6mtH9msmSrMQOM+OpRQ+N/xyyvdZkQMlB7T1OPRbPxVaNBHzmXvyrwB5yPM+TDiBuwrIFSfgXYLmRaMoxw86dAWAyrIlj3zqHE6/0Hmi+TOvu+Q0VPI36riv9PqR7eP+iyEB992ji2PNH+jSckyAzxfEPnR7U5STyUtni/D27kndsZ/hzTM6cSg+oCKASNy/ORE5gFhJYpUvYdP+ZzYQ5F/V7XAgq79O41/c+igz3qJJdKSqdh0Kqs/Y/Tg2txNrIcqd7HXFyafNtL9p4vld7O1ODr7FkXzFx2110CYRkmf3na/1EPwA9P4YCBGZhqJhRfMQyb2EldW
 YsXFsi6X
 3mC7Qrfzpo1/MQyR8078mEP7LeaeCkcEAuwoS3oa/1SIth96HO8lXwErSIM413aoQsgssXeZnd0go6ST7plW3sU8S0KHLCpayIQdWx4ubPhTbRmX71O/Y+/LkSk1/DuFhYslihm/qkYfdpt7LfP1oU/PKtxJjbFAMbQEpw3K+8qy8ozSSt/xWBdxLECIE4ZXoo1KqwNwEjm/JYc3oqcXZXdTXYawU/8HYsn3rWJtcY3uv3EfPym2WGN7qnFDJEEP6PSHZo4QK5NrUB8SZ7Lddz7bL6aXfsZxZXCsp8Z4qgROCCTcPu5FgWzr8MLU4lXkE3aLF1AITCFvVmcI7Hajyi7QDpOZNdCfROEZtWaMx7ml4JrcFcy102lWpfCPCqolTT+HeOrjRuXt73zHallxTSSfgLXboUqNGQ9ha11T+SSpwEUUCNVrxCTOVpx79vQ+g2Hx53oMPLBxWmEeefESGHNVEdPMI06S6OiDQHLHZScvnc30OOtGQvtaZycQCOruxNsiDnhg5qXpIthTIl12W12+EbLs2S8L80HhG+N+xLZ6VdhtOCXbt7Z9uqSuP2gv2GbagN6U/b5/eOfuIP6hwxAqIxFCL3ItI7dLoRlezbiSjiKV+FSt49AqT1Kev/+YkDqWZ/11vxassq9nkF1A2P40x88MVgD/3jsZCKqS7rtDkvLI2a26/Fj7pUyB/5d/V/kZI42azSlgHoLBpBhZ3lmxx4ZFjKO8EwG9Os5mnvTzLlC5RvmjStgCw7l3U2Zfm5uVo97Lax51HN4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Compaction serves the ordinary allocation domain.

Restrict it to N_MEMORY_COMMON:
  - start kcompactd only on common nodes, at boot and hotplug.
  - compact only common nodes for /proc/sys/vm/compact_memory,
    and trigger proactive compaction only on common nodes.

compact_memory and the proactiveness trigger walked every online node
before. Memoryless nodes have nothing to compact and no kcompactd, so
leaving them out changes nothing.

Direct compaction serves an allocation from its own zonelist, so it is
left alone.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/compaction.c     | 6 +++---
 mm/memory_hotplug.c | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 426563acf7ac..879f372a891e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2973,7 +2973,7 @@ static int compact_nodes(void)
 	/* Flush pending updates to the LRU lists */
 	lru_add_drain_all();
 
-	for_each_online_node(nid) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		ret = compact_node(NODE_DATA(nid), false);
 		if (ret)
 			return ret;
@@ -2992,7 +2992,7 @@ static int compaction_proactiveness_sysctl_handler(const struct ctl_table *table
 		return rc;
 
 	if (write && sysctl_compaction_proactiveness) {
-		for_each_online_node(nid) {
+		for_each_node_state(nid, N_MEMORY_COMMON) {
 			pg_data_t *pgdat = NODE_DATA(nid);
 
 			if (pgdat->proactive_compact_trigger)
@@ -3366,7 +3366,7 @@ static int __init kcompactd_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY)
+	for_each_node_state(nid, N_MEMORY_COMMON)
 		kcompactd_run(nid);
 	register_sysctl_init("vm", vm_compaction);
 	return 0;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a599fcad65d3..6b6873cfbc5a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1224,7 +1224,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 
 	if (node_state(nid, N_MEMORY_COMMON))
 		kswapd_run(nid);
-	kcompactd_run(nid);
+	if (node_state(nid, N_MEMORY_COMMON))
+		kcompactd_run(nid);
 
 	if (node_arg.nid >= 0)
 		/* First memory added successfully. Notify consumers. */

-- 
2.56.1



