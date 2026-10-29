Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471B8606A339
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XNLXlqRw
Received: by kanga.kvack.org (Postfix)
	id C18946B05CD; Thu, 29 Oct 2026 16:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF2D6B05CE; Thu, 29 Oct 2026 16:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B065C6B05D5; Thu, 29 Oct 2026 16:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8705D6B05CD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:44:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17ECC140512
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:44:53 +0000 (UTC)
X-FDA: 85376842866.19.190599A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 52FD4180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:44:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XNLXlqRw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0u9mqum51kiy34ukMYiOeDJqgQ6PcqJiGIEfUzDte84=;
	b=aUcnvOpsGMPOTXjUzrF/9MExgncgsflCwk2qap843Q0+sMROpAdbF3n4ZgHXGd4CwACjeq
	sPkTxOnqPaLrZ5wZm50hBUXVLpcW4eCxwQZriuUAcV8n+DnkcfApVT4Uolyjy41nh0uuGt
	tzCgJMY4DZVKuZIPooBdD9LCInFTdQo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XNLXlqRw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306691;
	b=SmIsm+qGu+miR0tgSqPEDCcWmdfKbSQntvbRjYPeoXS66tWv5Kvn2FQEaHPR9HFUvsHePF
	ghkueK70pYXHIhp1a+Gv6rvncWo/CQNkdc64BTDQwHbIlkjZPlP/jf5iidYyuPor0Q6ymB
	4qQeEyn4OVPe+rg1DA8kM8WLAyvAZH4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA33A601EE;
	Thu, 29 Oct 2026 20:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9CC1F01824;
	Thu, 29 Oct 2026 20:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306690;
	bh=0u9mqum51kiy34ukMYiOeDJqgQ6PcqJiGIEfUzDte84=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XNLXlqRwdRH7zOXlHSAyM5r9l+ZsOYydF9IM6c41SfzDtPH1QjYiKg2vebUPxLRhE
	 op9syInbMCIbPK5ag5w28kgrB20oq6dz6kz7zwHtoMeI3sn0MMvrWpam94RFGJgDxP
	 PwuSJ2sDX281xB+sF7JbamBjH+Lt1N+zLFvcykhavgdcPfZcysVtAD4MHmB4sYH6Ln
	 ybtI5TkPw6mEClQrIsXfrvgw+3L5rwnHWTSP6EOAsNIyTGyK5uyY2hbH03ERH5/SzU
	 /29GOoPKsf2oq6PwxEHLGhAGPKt6XxH3qiXXHt/UH7EJc+i1SCplW5JPkQ0WQvlUQC
	 DoaDQWsFpWhEA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:41 +0100
Subject: [PATCH v2 46/47] mm/memory-tiers: unregister empty tiers outside
 memory_tier_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-46-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3065; i=david@kernel.org;
 h=from:subject:message-id; bh=Be0cEORXL/+FFSLbAGaUCWXPcitw/28TU4MyQxK8Pu4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+2KdjtU9mUqD/ObE6nfr6W/WsvPu0X2p7PUp8V1b
 +oT/Z1XdZSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRk6cYGdakdG50VWY+a/9V
 8/mJgoV/fRerH9Bh/RdRvUB9CnvUSjuG/24s+zm964Q1rNsURSvOGhmcdnscZ7DUsWr7it/1S89
 +5wYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52FD4180003
X-Stat-Signature: m3ep17oatrmj3b4h6r4xj4uyy4ip6ee7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306691-350100
X-HE-Meta: U2FsdGVkX18kA5tMlRGOi3IxNDgiYDJxsXe/d3oziJ4bGU3DADRkMHBfinNFekroDaDEWkTDSZAKJsD3L/IzbLsEPXu13VA9u35bYFU1V1J7CN9h1UmAQxjCWehVrpw/H1I5tzrOmtKZuDquCr715Tq8TelYtRgy8FOmSLKpKVVCTtdLo1kFdbVrYOhfFgzz2nFatCCZxQE50ki7mMrLjcwM5hpQxZAfIO0JekhJszAREI7M9JcKOUNfKTQMX9iNwgjSdb7oeIRzR0nKCrs0w9vKEku0yvODobHsWHuWg+aGor67+MqDfyhsgccsRlhZ/exUnZqSMGyfpTQ+KxiO/ESk+zxcmR0g60YBHWRAL99X4zcJUuSM1jhRKiyTNRWQjJBfboJLNthPX4JOTdPKOtvRu6H+EADxbA8s14IKPdCVcA3lWZ0IXlGbnW5xrWEW+eYeU+348uncmjSf74HuqfFPnQxuaWfSwfjjbozAvd4jREpKKEfUPMF6q2miytfqYFTkQQE0OptTse9LNCsQ1rE3n9Lu4b3zKofY+lNpEvxB3hmOFN9sDKk7AuxB97a+cvRAYm5mmJs12dNa2JSOm1QdSjSYTLWE073khcJXC9tUKjkWzLXSS1Bbx/5S/81HdnzmrW4RsIhb7GwwtSrtGbjY8DIA3T5Sw0i18AtlpLtLqPn0XzY9QPaudChNHdxxCmFe+z3Ft6bLYKWX+ag6QymeCZFLgfQpAaPXvVP1XTwWlta5xfqDvXQ5TRrHl1UCDaEQvTBmIvO3tSeEDYl5K3r2uUNIH6AQYfGXwSlTPFIVP7kprlAvrFah6NWbjCpfAVfkID6cluEHPEJJxCLoBsZ2aImUxRF7FxvO3bxXO7bbhPsJKHiDMNwpKlUVr8lmigQT499jOKYPL1/J2YBc+IAhTklYwxaJegSBFNfZ2dfyIQ7CQXAjw2kjmoneGCBip6oxiwjRMH/JD45J63G
 5JAwwXUz
 Wp666AWPS3ueJGV+2141GJM8GjLk49wvqhAL+MhLEespjKuPxmhq7rGUoiE1S0IQ/sfm9Jve5O5Jclu0rO3zycPa9rRMcGHZxtkONPTZZwq3p3COLPIpkrLKdAEYsT3POKHWnQHup7N6+oPzzHhdv1WwEiKtGqEAyXBQuwNyfgSmejuxFI51MC+hI5ca+RzKWkarru+GQcgwwi8sEGbpV4dAb9/wXT/0eOAvBRZeQw3feK6AUc59vhFK7J6kX1078AiyD5N58sJOvioQfym7gzo32AZCI/xDhK0KpM3HsM10Dlfq3vnMDQCmUyrEjCSgthhsvdL0jF5LH0qpknEsa0C+QKxDx1Poe69Hei7MSo/xjvkmxEOtqMvIQTPUhTSCWFju1Hkhe6ZhMiBCDOywT4mx/T0u3Li/MTtEwneaHsVi/ZJD3h138uor2NpfQABjhn2pwHFker7OJFBl9FAwIt8pzuRJEpVyK5yRh
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory-tiers.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b58..8eda313cf619 100644
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


