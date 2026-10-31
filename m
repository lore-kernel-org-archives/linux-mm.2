Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CCE606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDaRfZV8
Received: by kanga.kvack.org (Postfix)
	id 8BF106B05F8; Sat, 31 Oct 2026 05:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86EA76B05F9; Sat, 31 Oct 2026 05:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D4C6B05FA; Sat, 31 Oct 2026 05:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2AE6B05F8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:52:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C57EAC095A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:52:14 +0000 (UTC)
X-FDA: 85382455788.23.9301A2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1AA5D40003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:52:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDaRfZV8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXWsGGAuGYMpNthZzj7j0qIEhHCnCLdw4tDv3Dde7tU=;
	b=4o6g8LIegmehUXZuzXT4rZqUC0C4wKdyljcGuGwvHD7yyG9ZBTReEnvcbuL9qol28Gz0ju
	WCXu1YYW3L6vQ+cm10nb2zT+e7thIagowdAgRsYcQNYIF/POhbYfKT6bqHvbI+uWGeQPIX
	KnMTFMPzFt2AeStA3hyk3xEY4rbNEkQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDaRfZV8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440333;
	b=FXzbsAmO1o2OMl3ENk0Ep4OrbDhXbPzJkhhhXQBaJMFdWWl066AQ0R+xxnjvrpDfi1h0NX
	WkKq0dbuiWJZNhx46t/pwZIXbqIAMdewhOfnCAfvHoLANApx/qJCAmIyrP++gIEx0go3Mz
	pOYWkB0hPLrWHGwbiP0AEtI36g/ZrXg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE00F600C8;
	Sat, 31 Oct 2026 09:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D3F1F00919;
	Sat, 31 Oct 2026 09:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440332;
	bh=LXWsGGAuGYMpNthZzj7j0qIEhHCnCLdw4tDv3Dde7tU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WDaRfZV8lrdSHWo2bJPjhRAvbOAWGSBSNWe8J3upHnl+8qcyY3Ce8G7dfUa1DjNu8
	 H8f+FSaHVuGPPNLccj7ytAj3BCbt3FdYbeSSKQF/QvfRjblvOsaNaGnbw9hLcvhcsJ
	 dDRBr8BfUwDlVj32RVLLIYvP7S3lEAMUk4hAgnS3bHgLHai9rCoFXH1JhD19+t2mMl
	 n7zx2EBIckhQ3seuwiWQtQn9Jl0jqIz4d6PcM9b+vRYVjFs35sap3cB26D91h0RaDe
	 MOMYNkE9tGqvEbueSr3By16YiV7Ok4fX4v3f6g5/bvzabRudn/+qA5QxL3Z0bM3mj6
	 nFye94PFipthw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:15 +0100
Subject: [PATCH v3 46/47] mm/memory-tiers: unregister empty tiers outside
 memory_tier_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-46-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3122; i=david@kernel.org;
 h=from:subject:message-id; bh=4kChVYvvx74BRlmNy9r2/KDpSY0XvvEjaE2NRYfL7Rw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs9+99iyuX3mtNxzRav077QJloZ+YyoR6Cgy2vp4d
 YX/5CM6HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzk4SaGf/ZLKmUk1xgsDAxl
 Pc3A+6Vf/4kPc5PbSzOWCXdu2uiXVTAyrOyZI/RJ5uh8YRfxXwU8K8t/sD5yzZZddPjK5FOzcxM
 mMQAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 1AA5D40003
X-Rspam-User: 
X-Stat-Signature: zjtmexmp1cy6uqct7sjc3q7jm8anghhj
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793440332-777879
X-HE-Meta: U2FsdGVkX18nNE8DgzJe2WsLXcenRu4UiGWhWIrzsShe4Qck0jMA3Yz11Gw3fsokrY5+Ap+GN7l4UxKZ/0N+7PVlPcQgftcF7vvemUhFXVA3ZdDxh+G8qKVv78R2oaNxHlMnpf4pXMxchCAMkrtICAzf2BpgduriI9uJbC7WIyNCBKJft2jMH7340BcMy3TjA+D+wODNkZpR3w6NpzEMOhdReJzaUbvYBucfiY7/+k+Xmmwb1vNsL8o32FTg/6zJingMWv7fQi3T19jz2IHYZdpgRN+qLoNLQo4z74n3zO3grFETK9AiNYwwFOSaluVHKHPtkNphlnW/UUTEfzkrp7LYc/orfu4rMRxcpMfpCl3WGQ+L4BLC/Q2812sjoEiV/R6ZCH9+TQjIW49sZyx6k096vuk4Y6R78qRsPN2O6Ym+rO44NEuEgJGhdj0mN5roLP3VGVchkcvgNXhsC6X9O/tT39lJvyK1rl1erJtd+xUkn6PrgIdz3fe/NonLmUefTIXfudBogv6HQkkVJsrcC4u9XUNwvOVLh3QCaSQsw8Q4sNvX8M/r7wWWR9LEo2T1eX8+6xzwHtc7wOkj7lp0028wCCFB8oi5wbT8KPsWqYratSvctIX+G51nE1I+6He1BzHJX9XPHo7gJxtl/h3qCFNtT/4Ok5v6hiw2fW0YOAMbFlVSAw+XhxGGVJfsRVFmdjGTSbdLVht/E1FvO5OwIOGxw6BMoFh3/lHJxnm2RsU2wmGEZipfxpuUmPdloFzze4ojI/9R7c+w7zOw9oUNjSMZYzvseCI2ESlyMXgSsv0LeJZoHATSxPCh7Pll9gBTu/FK3n2fMc+QCXmPCE0gHLvnLXylmnkG54q4bNCr9W+KNqkTCKZstruh8WCam0qI8Yu+JnWejIAmSaiehXRzfZ0jg3aV+ZtU+MciqVNiQxtg9dsvJikDGDuWXkT7+QfTSaMVr9/be4+QGGMMGcu
 er+L4Nn9
 SlE7VdvJEAhHDHgpzNLoniel0HOPtFGM5Y70zEeFdbgK+3l0b/WfpRHz8kpP9V2wQ24h7w76BX1Y69pYxxmvUkHQk64HyQnS9o8D5UL20rnd0VRIKZPo/kp3H2JsOUCb+9teSy9mMk+r0p+Nd+FjhvKQtI7bhSUU8BwokV1Abqv99j8o6/kIEF2T9W0F/NeU+XabYdMDKeJ+y2k4mr45CikqWSEGDeeoFSEfuyf4nca5so2NPgidb4HtY7WFW5NTn8oGBzepmlNTbIXBjy3SnoCcuxQtGINVSyhfQ50mJnH6XD5VBjf9AhmHtGbq30bqYRHexDAmLAvDcXS9BfnAO1JBnzNUuqdcAXluHtO4eI2PvbYJVARBPU27CaLJtOK92ugvxjYc2B4kB+lHWjIgQfnMQ1TTACTDqiyoDgarrKdHVRPFFsjfbhZNHo8zL2mWd+8xFVV6W7IOTF/LPfPYtajBBLiyMYwVue4kh5vPsDzOFesd8276l/YtPGBE7T5KXcT9Btr9Cqwled32f2Cgn87Co6yPW0ad+RkbS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When offlining a node's last memory empties its tier,
clear_node_memory_tier() calls device_unregister() while holding
memory_tier_lock. A concurrent sysfs read can hold a kernfs active
reference and block in nodelist_show() on that mutex. device_unregister()
then waits in kernfs_drain() for the read to finish and release its active
reference, while the reader waits for the offlining task to release the
mutex.

Return the node's former tier from clear_node_memory_tier(), making the
helper more similar to set_node_memory_tier(), which also returns a
memory_tier pointer. Let the caller unlink an empty tier under
memory_tier_lock before rebuilding demotion targets, then unregister its
device after dropping the lock.

Fixes: 9832fb87834e ("mm/demotion: expose memory tier details via sysfs")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory-tiers.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b586..8eda313cf6192 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -572,21 +572,14 @@ static struct memory_tier *set_node_memory_tier(int node)
 	return memtier;
 }
 
-static void destroy_memory_tier(struct memory_tier *memtier)
+static struct memory_tier *clear_node_memory_tier(int node)
 {
-	list_del(&memtier->list);
-	device_unregister(&memtier->dev);
-}
-
-static bool clear_node_memory_tier(int node)
-{
-	bool cleared = false;
 	pg_data_t *pgdat;
 	struct memory_tier *memtier;
 
 	pgdat = NODE_DATA(node);
 	if (!pgdat)
-		return false;
+		return NULL;
 
 	/*
 	 * Make sure that anybody looking at NODE_DATA who finds
@@ -604,14 +597,10 @@ static bool clear_node_memory_tier(int node)
 		synchronize_rcu();
 		memtype = node_memory_types[node].memtype;
 		node_clear(node, memtype->nodes);
-		if (nodes_empty(memtype->nodes)) {
+		if (nodes_empty(memtype->nodes))
 			list_del_init(&memtype->tier_sibling);
-			if (list_empty(&memtier->memory_types))
-				destroy_memory_tier(memtier);
-		}
-		cleared = true;
 	}
-	return cleared;
+	return memtier;
 }
 
 static void release_memtype(struct kref *kref)
@@ -884,13 +873,21 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 {
 	struct memory_tier *memtier;
 	struct node_notify *nn = _arg;
+	bool empty = false;
 
 	switch (action) {
 	case NODE_REMOVED_LAST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-		if (clear_node_memory_tier(nn->nid))
+		memtier = clear_node_memory_tier(nn->nid);
+		if (memtier) {
+			empty = list_empty(&memtier->memory_types);
+			if (empty)
+				list_del(&memtier->list);
 			establish_demotion_targets();
+		}
 		mutex_unlock(&memory_tier_lock);
+		if (empty)
+			device_unregister(&memtier->dev);
 		break;
 	case NODE_ADDED_FIRST_MEMORY:
 		mutex_lock(&memory_tier_lock);

-- 
2.43.0


