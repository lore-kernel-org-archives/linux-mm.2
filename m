Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4568A606A894
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 08:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o5/eFKoU
Received: by kanga.kvack.org (Postfix)
	id 692E06B05B1; Sun, 15 Nov 2026 03:00:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643B56B05B2; Sun, 15 Nov 2026 03:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5328C6B05B3; Sun, 15 Nov 2026 03:00:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 314096B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:00:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B53981205F6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:00:43 +0000 (UTC)
X-FDA: 85436606766.26.F4F19A0
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	by imf12.hostedemail.com (Postfix) with ESMTP id 51E874000C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:00:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o5/eFKoU";
	spf=pass (imf12.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794729641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pt8xvDwKeZFNbSLqDy3OvpUkDSrTrAmd4jUA7dH+Zmk=;
	b=OtuLRSJssWXtQDELekT5C1SvoYRz2+s/wBgTYzmHiEavz39Ro95eeWmpXJcL6LGjklwB7B
	1SF02ICMdEgJvWjx6exr0L4Fyh6qbjtDnGjsP5ViR2xlBeVoACo+ZJhv7WUD4xjqmE8/OJ
	RTBxidck1RhUcW1jrcNpqt5a5tYXBrs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794729641;
	b=17ex00p+8aQuyJahvGFVfrO3T7SPXFQ/f+0Afojfj9QEH8xPjj9SySz1fTgkU62QzPTgQs
	jnoVAxb256y/Sb6HnNH4kHou6vN+h4nmzA2LwOuTfyaw0Z7SdDRb3WB6RliWlHaldexI38
	DL35MQy9WQaegh/dTuznRX8yv6zDbpI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o5/eFKoU";
	spf=pass (imf12.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KsT5VlOouw8+wlbQGGPvciVPDA8AmFbkB9L6Bo0igYA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794729639; v=1; x=1795334439;
 b=o5/eFKoUpKx8HigQzKWUi4AYgpp0HzJrxq3jRocTYu/5tfZUv0eMO3lj7PYBkPmYqRf9zbOS
 bzA8rXYvZU0HTcGOIEG+F1fF8Ra1F6/vW9rwQPVXJ+/uKn0SVGE9zI32MvhGtQddvSpwHz+VJAI
 MUf0lSMKVeqD57ZdXrfOb9JQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 8fe9c4ef923e859d;
	Sun, 15 Nov 2026 08:00:39 +0000
X-Mizu-Trace-ID: 8fe9c4ef923e859d
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Subject: [PATCH v2 1/2] mm/ksm: extract helper functions for scan cycle cleanup
Date: Sun, 15 Nov 2026 16:00:32 +0800
Message-Id: <20261115080032.132397-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261115075832.132109-1-xu.xin@linux.dev>
References: <20261115075832.132109-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51E874000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: k3zx3m5ibwia97ia6e5mbrauxxycrz3q
X-Rspam-User: 
X-HE-Tag: 1794729641-73451
X-HE-Meta: U2FsdGVkX1/POyiA7WILbDA54q5d79uVP2DoZq6c6DgS1kq4p7vacNSKwjfwvUrz7T0ncmlMUo5nQnvTRK6SIDwdHWWykyaYb1NI2HGbGrt9BmghC+s4vYlKeJhrMkcnF4ZW0Zew5Q6sRID3UcRaLX+FW0ri+1umt7vGsdvtsIAYTGyMhCPJezXVSSpckSvhGWSCxbtisXJZr/fcMPZcR+wIE/Ff2FI363mqlLfHLN8jkRy4o6RxkMVMBIRi248D1KTWu4xXp43YVxXzVhMYLbe1c+TatIiazbbAbX/oN4+phz27xKeRYJ5BGfyvXzATBSWi4+arrtI3bRcM0nkqROLJs1S7CXOoeRJKCuK5VphspS0+zbuAITsuFqfPwdjIhV7Ed/XEcfw0dZ4IdlFKda9jlZFg17ZUeoh01VdAudJUXpwYqE06K2h0VubzpFRLjUAvcuZOiOhlBC1an/S1vuvfN6XZMYRu5fhce7sqH1IYQ13m0W/NhRiNmt5K9IkAe7cwvWEEp3LPgUGVRokPMBQ59XMDaANdeN8uYAamRVc2pmiheVbV0T57xVscU5wD5W5s+ogrme432wEzYn/znGWxq5U3bLsHONjXP4W3zhzBaUkFTvSaNY8q3u2bYpTzZSgFxQ6plZQYtLiT0HFyEbDBklSiZ/36k/1gzs5fETQZvm6aAjre8LlAzZ1u+92NU7Zoz1uppc9FCyFKGCmHsLxaTe//RNS0UgvjlkOuCnxL51lz+xqLNyFNZy+IqOudRcGV7NZUK5Zqns4TdcIuRTTYDzusp5CjtUboh3KNTn64FIR5BMLdemyNkNqIaa7I/yAH1Pc3ueYkcYicf6kE/2EoPScDdgtc1VbVKKzGJTEfnMplYkwpvR8AchOY4blvJkyfJ8uwuknUint+9tSFzh3mqqLFtbYXn/O+Jz3jiQU3ser7nv5hbj6mI1Vn8yxoV+9JLRaWtHy5nD3iMR1
 5SlHcd77
 zK3Knj/L+/GxFgCWDEtQhwjMlViRkiF2pfZnFQqLhU1BBosi+tSo6srMM9fYaUgNL5dTh9K50pkGoY9GSkiBPEXf2xBcVZ8hAjovW7fna6H5n9JMzcvkHAweDMHokJqqZnDWHH38FhxMmrJg44F5Jr3mmBbndN9lqNRfkiOOIV+P4jtAJ7f7ojEh7ZbMng+9vF8HKqWLR/+fx9AeP89AhZbUnt1ndB5l/tnFvlNALphQapw+/yUucRMRGVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since scan_get_next_rmap_item() is getting too large, extract two new
helper functions, ksm_prune_migrate_nodes() and ksm_reset_unstable_trees(),
to reduce indentation levels, isolate local variables, and improve the
readability of the main scan loop.

No functional change intended.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/ksm.c | 54 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 5e24b5ca8dc8..8db6743ece6d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2609,6 +2609,35 @@ static struct mm_walk_ops ksm_next_page_ops = {
 	.walk_lock = PGWALK_RDLOCK,
 };
 
+static void ksm_prune_migrate_nodes(void)
+{
+	struct ksm_stable_node *stable_node, *next;
+	struct folio *folio;
+
+	if (ksm_merge_across_nodes)
+		return;
+
+	/*
+	 * Whereas stale stable_nodes on the stable_tree itself
+	 * get pruned in the regular course of stable_tree_search(),
+	 * those moved out to the migrate_nodes list can accumulate:
+	 * so prune them once before each full scan.
+	 */
+	list_for_each_entry_safe(stable_node, next, &migrate_nodes, list) {
+		folio = ksm_get_folio(stable_node, KSM_GET_FOLIO_NOLOCK);
+
+		if (folio)
+			folio_put(folio);
+		cond_resched();
+	}
+}
+
+static void ksm_reset_unstable_trees(void)
+{
+	for (int nid = 0; nid < ksm_nr_node_ids; nid++)
+		root_unstable_tree[nid] = RB_ROOT;
+}
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
@@ -2617,7 +2646,6 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 	struct vm_area_struct *vma;
 	struct ksm_rmap_item *rmap_item;
 	struct vma_iterator vmi;
-	int nid;
 
 	if (list_empty(&ksm_mm_head.slot.mm_node))
 		return NULL;
@@ -2639,28 +2667,8 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		 */
 		lru_add_drain_all();
 
-		/*
-		 * Whereas stale stable_nodes on the stable_tree itself
-		 * get pruned in the regular course of stable_tree_search(),
-		 * those moved out to the migrate_nodes list can accumulate:
-		 * so prune them once before each full scan.
-		 */
-		if (!ksm_merge_across_nodes) {
-			struct ksm_stable_node *stable_node, *next;
-			struct folio *folio;
-
-			list_for_each_entry_safe(stable_node, next,
-						 &migrate_nodes, list) {
-				folio = ksm_get_folio(stable_node,
-						      KSM_GET_FOLIO_NOLOCK);
-				if (folio)
-					folio_put(folio);
-				cond_resched();
-			}
-		}
-
-		for (nid = 0; nid < ksm_nr_node_ids; nid++)
-			root_unstable_tree[nid] = RB_ROOT;
+		ksm_prune_migrate_nodes();
+		ksm_reset_unstable_trees();
 
 		spin_lock(&ksm_mmlist_lock);
 		slot = list_entry(mm_slot->slot.mm_node.next,
-- 
2.34.1


