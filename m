Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF6D60A2609
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I8MAyeWx
Received: by kanga.kvack.org (Postfix)
	id 0D3F46B05B7; Fri, 20 Nov 2026 13:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036416B05B8; Fri, 20 Nov 2026 13:09:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17B16B05B9; Fri, 20 Nov 2026 13:09:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABBEE6B05B7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:09:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2848AA013D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:44 +0000 (UTC)
X-FDA: 85456285488.14.4BAE0BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 20403140002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8MAyeWx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198182;
	b=Y+eXSLke8C55KXewBU4ikZRHGo65lL7uG2a3QK1x7nITGah6bGcpX87jVWdrO4jSY8MqhY
	mxOMwWIfoqGmmwdYUitRkMSQUbYaP7cLQxsoQQtIFFCmDcdBFbUtG03klHqMxXW4wT/zBa
	flOIYXoQflibcmu6MkkBoUM/HkcgJ+s=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198182;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjE3RPeHs8dyfLzrDcCaKSay9Q5D+YG1hmYrydQv15g=;
	b=jDQl16DAcaWcNWQJi8cxRmXCf0h2LW25zbHEgfBCxeIi3BynjNhnifypV5vUbGMfBXXhyk
	J96se/PJmqv6/xgCgYp+jHS7zNHPAPL32PXYAL/b+bMDm68tJcX4LyPxO7OWNEILjVs1tj
	EyHx63I+n8goDwpQ/UGc8C0IZGJyJhE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8MAyeWx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEAD0633B2;
	Fri, 20 Nov 2026 18:09:41 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198181;
	b=gv7Ri9SnV2HMsGFzMvOMnGUAn3TUDIIq92T98LspHGWJ9lsCLThZ/86YbUt+4rdozypq
	 1m8cMY/m7zUmpMoa2g+f9UKDXkcBwUsUT7FXK2uy+nIRx4yfVMrR73UgC6KmPr9g0yI+a
	 7d8Y/Q5EzP4WFV7QMRhBociEjn4OovqWjjX5DhBuAbpQrojXvwGW07dqcvkzTGHMFjDhl
	 QgJ/KYC98psyArGkP3Bo2RrXKyyYt6sfZ6YIoK4rLSbheToRNtwn1MdOArwuUCxEFYuKS
	 Nq2b5VYUka6OlpomPZ2LKxg0ArQ3uulW/R6QZOrJPnZTyZZRXMPUZZdbwGmu2mewfUA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198181;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zjE3RPeHs8dyfLzrDcCaKSay9Q5D+YG1hmYrydQv15g=;
	b=i6AdM7CWRZzlF5lOaQAHSnokgiTHdG8H7B+CDsdEN6lW0lWn4j5cQlrOhsQ7u9gs70aa
	 klyBXbP5B/s9hfrCZQ8ljyfcUW1bRJS3V9ukNSsxMawxmurCsQeo0/ZomsJKLg2KwjwYe
	 fmxKDzbn9+NZ86JRjR6I5sy7IzMNjBupCplhya4/MpxksQif9EDXSVEwPnP/5WabBb0K8
	 rjfJH79pIUhVNOd55xYXySIpYT45evRuHfwnR6wf++yH4+kpF4caISfj7CjgXR4bXaA7Z
	 YLHQo8Ucu+1x4TxIUqVB7mDNYAcodwyIdONujJXBciIKd3ZCHBND2LELFM7xcE8md1g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7CABA1F00ADE;
	Fri, 20 Nov 2026 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198181;
	bh=zjE3RPeHs8dyfLzrDcCaKSay9Q5D+YG1hmYrydQv15g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=I8MAyeWxs/N8cm5gfF8PMfnDTe3N/eFpDUd+PfrlKJb0XkORimYesz8LWVtPvcoru
	 cz9fD7JaNOS9nqWot5huFbd+UXXIQqcw/vWtUBLjbS3S9pLtyz6g6pE13Z3PLmNaky
	 i7G+ev8KBZ5uYjl4aE+fIj0kj/hEK0TtMPaF+odDSoiiHPDI49CeUNi/ipFB3vfdjI
	 qkY+YkD+hIXUwjgbSh5bh6EHEelJi2Qt9wK9HtCtlVxed0gZ96K42B5+md97Fdzp58
	 ShoNrw3yx8IMSzuOLswDHDEnjFoyncqr5XCuaMcG+Wovoo/VZVUi+1AqoKwXzHuDJv
	 KdwNi206Ibw6g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B46A04B8D9;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:57 -0500
Subject: [PATCH 06/60] mm/memory_hotplug: migrate offlined pages to common
 memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-6-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2066;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=y+LG+FO6STODgbMk2P9Neg6dWT2V0RZ4aCGZDdcA1iI=;
 b=rF4QRfdnyeirN8cavwU1rBXmaiGs7/MuKraaTxIZF6cFZOTMnmNLGqUa7ewdFKbgEAKZSsWhS
 Nj0dPmjAPUKA3opSJvkIGXOZYeu3uu/WCfCgJJA/K1WyJMnnUOPr45Y
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20403140002
X-Stat-Signature: juw1tygxzxxhw5j394uu5iyyz1hkzajz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795198181-188535
X-HE-Meta: U2FsdGVkX1+h8273wrGD8otQ0wpYMOm+oSYcCEm5KROD97xK2GvkhJbfumEUy/Y+fzMc5ZdwCZ4lePkwj8cXHEPinSm0+8u3WXgunS3O+YYdkNiS5bpt2Ms5lnQykkuuCRiSgyBTb8ZHv2V187n1EKAtRTBq/8db+LEaq1/9/POjKDERpoMV+f71qYf78jpUaxZBf6CeqGJVVVz6/rL90FQ5SDs6fqHjaERxoAgZvKjDkrS/23zc986ydusEfidQhlom0JofRwZuX1Hg5k/lgb34JMu+K9l1vGF0kQNR3Mmh98yYw+x7ziPHk/eNrCv4y2BAH9sVeMvk/Wrm2kNYbKeYowMzcTwsw+K9uTesGkVJ6eLGYyrVBZT+/aS54Dak8vgRxjA1HsLpi839k/Cnz1rCOXhPS7yTtaCIw7LrwGf4SJeLXCYp302p2dwuksGihvfDF1tfeZBQOmze+ocJMkUB8VObni+jZvDjwKeEaWiE1KYTV8z6GFcPm05rEDPMETHD8kH5winbcxT+W8FiVsSgYCtxiZMeMnACSeyEMqfd7IAlpkeg+KHQ97bxviq+TkfU6ujcFib0TGtsGSCb733IM/eOfpnpl2593v143Qxnsmeqj1BGXcCWM0dXsB4HKJTMCHRCeizncYa4ZAlqgpWqeOhvFKB/6N6ppuHV8VD60reXASgnuu2NIVgV+Wkv0xgyThM1WGVd5xFtfLst67RNbNbW8QmW8cuqfUqyVQovW08o4gUip95S4ieD/1gaLhiube77LXSB/MKU4N9mUxX8Ou0Oa7EGW+4NDz5bHZiQMz+xZrZKMJS8l2Iqe/eNrgV98iBjVrTDf2rMkbBzLIL5DvN0n7n2FUCILqoBhack1q7PVAgFXyQpA2UrDossYVyd3B/0SpH43lhK7GYf4SOXWeY/yQ5jGn244L/HIJDjh5iWcyWJ4ppBU3eEbBqHl+CARUMFvKQPZqAzp8E
 oKWw5QPp
 SICguXihsrKLny/e9NUZ0BrEIZHFZNHykuoJcfThUD9yaFhVclzl8n/CfkE/5h9xL0ZzVBCBZs13QnbVHjCfVkOy6SkNa3rNcjouldnfmSTLSRwlrHfAuu9pfnz1sklC1bp7H8CSzTJzaPsWgeelzDp2WKaPsI+ZoxM5vAQV4yxbx3fwkoc7IbtmQNSeodynTxz57LFL1xNprEUIO1xKJVyWiq+SyFTtt8CB/07H4FHAHeGyviaEwL/2sOvGn5Q47IvFOsXMfhUjfqx9WDjje/axeW+0ythJ7rbeSgmwEw0uAzdfkuQ8dJ1FA2brhuo3KqB07NZNET5bHnMyHv6UTldV6ZO7Opivi3Tj/30KjqQ8rzB0Ym1q7lBWgnMHy9RNbClMiSaZTPIDG9SRQCu9tvStmxGvPUk27nc4+5ADILwm49uEMorOcNtMAS1t+yw9HAr5DTxLw7CI8xgwrM/7b/+Sso7fViyh+nxCcAYwhNA+GrNde1lI5qb2ZxFd5v/qWPQ/3Wk5/fiUzM4JNly4fJy3zSdtglsv0V4Gc0IY+XoM7eQA+6IWTJnQqljLNE451ONj/I3hLFy/o/M0KDgCmpGWiZ++pVpFdwDcFHg3aBl2symWhwZ4Qninc4dld+V2sPEGX7n26rKiFkad/vKpxFOfyyyDaH3OkDQG2qSpJmNeH3NxdM7J6XbOqu3aTYkAFCG+2n8iKbDIvI69+yQUJLmzSe006yyshIZ5BG0NKnIuF7aQRH8SkEnG6yAS28klErMGZubkewepeR0iUL72igho7ovSL0StqPrv0nq4Gw0ggJf3TqEvH/fgYxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

do_migrate_range() / alloc_migration_target() is only capable of
allocating memory on N_MEMORY_COMMON nodes. The destination nodemask
presently starts with N_MEMORY and removes the source-node.

In the current code, if the destination mask becomes empty, the source
node is restored to allow migration during partial offlining.

Consider this configuration:
  Node0 = N_MEMORY_COMMON
  Node1 = N_MEMORY, not N_MEMORY_COMMON

Node 1 keeps the destination mask non-empty, despite being unreachable.
This leaves migration with no usable destination because the source
node is not an eligible allocation target.

Restrict the hot-unplug migration target-list to N_MEMORY_COMMON so it
reflects the nodes the allocator can reach.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e5cb770e4b09..1d3d1792074c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1926,7 +1926,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		folio_put(folio);
 	}
 	if (!list_empty(&source)) {
-		nodemask_t nmask = node_states[N_MEMORY];
+		nodemask_t nmask = node_states[N_MEMORY_COMMON];
 		struct migration_target_control mtc = {
 			.nmask = &nmask,
 			.gfp_mask = GFP_KERNEL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
@@ -1941,9 +1941,9 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		mtc.nid = folio_nid(list_first_entry(&source, struct folio, lru));
 
 		/*
-		 * try to allocate from a different node but reuse this node
-		 * if there are no other online nodes to be used (e.g. we are
-		 * offlining a part of the only existing node)
+		 * try to allocate from a different common node but reuse this
+		 * node if there are no other common nodes to be used (e.g. we
+		 * are offlining a part of the only common node)
 		 */
 		node_clear(mtc.nid, nmask);
 		if (nodes_empty(nmask))

-- 
2.56.1



