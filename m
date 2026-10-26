Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFDB606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GiO4u4AK
Received: by kanga.kvack.org (Postfix)
	id F0D066B05F5; Mon, 26 Oct 2026 19:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5766B05F6; Mon, 26 Oct 2026 19:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC396B05F7; Mon, 26 Oct 2026 19:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6E7B6B05F5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:29:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56C57140181
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:29:49 +0000 (UTC)
X-FDA: 85366372098.16.B722A23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8CD54140005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:29:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiO4u4AK;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coOQRGDsT+wJUVW51ZA0Qbw+6l1l2M6ICO7oefEeEsg=;
	b=jEX0LPzsIpEGkI33kWP6WI1uAnhvkjZB5Hz4m9C3OS2xbPNXRxJvmC+htgnYi6JdRBJIbp
	YNfXvK9IfYnSAs2yB+VTl2dv2T0S9W/LC3uMT7FmOQ4giSuZJ30j/7jpRB6h1JEUYzt++l
	ABOunLW3i0W1XBRuksY+BP6chZl1DC4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057387;
	b=CikJDSro84kr6NUMGUHoMEtop1zGWxgL5SBD1e2cKLl95LxxgX7iwv93j148WkyZ9D9g3w
	KbsNih2PaVD/91IA1gmRVrGGR3d8rDltkSqvhPudNQSHLmG54SRrtoXyJebMq3Y2nzkFtj
	FPM6cYkWR1syFiYa8V12z0Mz3JnnMKE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiO4u4AK;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C57DB40B83;
	Mon, 26 Oct 2026 23:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776751F01825;
	Mon, 26 Oct 2026 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057386;
	bh=coOQRGDsT+wJUVW51ZA0Qbw+6l1l2M6ICO7oefEeEsg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GiO4u4AKmDnNc8YPvYmnDQq3BaIr+RptwEAcqRK360IcwrF2iBXGw1J4DWyV4sHLw
	 MSmQi5baxNEw+IWu5HmCurp2H0sINX0XT1PqKiMpshw1F2bnM249lb1mP7hvV3dxpi
	 N+m8PyNfp4nCcfiSAuW26vuJptP/q9S+unB4blp/je/Ms+iGljDFKSrQg9w5cS7geq
	 1CVPNZZRNDlD5jgns/lYTAziDHZsp0MK3FeSKb4cJb9NqDwRkM1P3hdksaafMGCq6r
	 tMOZBP+r6O5Og0wsloC7zDVaRJvM5uwjDSdXuTuIZRJxrM835hsFQah5qSZ7+y6oUc
	 T4SZkCG4ibHWQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:58 +0100
Subject: [PATCH 38/46] mm/ksm: reset the unstable trees of all nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-38-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2111; i=david@kernel.org;
 h=from:subject:message-id; bh=FsjPKsNWJYzmMrPhyxtJFP2mccjtdE2o5Mf6O6Ctwdk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/BVZrBpbfEKWi9gCZPyGl1UYv5LxucgjodX84/d
 nXj1IAzHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkcSMjw92qMGGWqxeDpB/t
 55ue9/pO5JsfnUq5j/YnlKxvV5Iv38fwv0hX1t79y//MtLXGB8QSL6zP3r7r9IbVn0+8efTB5KH
 fXW4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CD54140005
X-Stat-Signature: c43a18neymmb7jyo3dq364ncjzh8ecwu
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057387-344937
X-HE-Meta: U2FsdGVkX18csBcQyNV02Tmv+A3ERGF/ARR8N5snzRMp1/0CQvizaG7p/IKRDk/B6x8kYMGFV4Tvakukiuee1TXfaP5EcAqYbjPinq6Fu3Fim0eIkK99BX5UzgJfQU6Dv3KUNuhr8G+8d28kNUXD8/ImaDDxVP3NYlvIvwDoz6ccAKqRtlSBdf7ras/OQFubUj/MnFQ1qjuDJV+P0sYFkvcDZhA28xb1Cpz8hzMlx2zv1+TMgPEeha1oDrftlN4vfmZqGXI6HSCIkzFz/K/aniZXVv8G/JGxThgrezUY+B+ySws4d8NLJ6k3RIsj018t89Ps/zKNJTW5Peyxua4rht+gCjI8sy15Brw1cdBU7V7Cdhs6oZM3AwGk2ly0IaHsIKDAhLLj5znf3ejNyNVAFrG2yamwyILaa/8kgZxyAyFwRwRYDebmJ1GY6Sm2KTlEb7GfYgK2J09s2w9gOwGNWeEC7GKYoXHM9YsUuIs5EfnQqxEVfSk2x/ZazUfLfr5zdpfEKtOa8SuNY7rfjQSYzaEWiNbDPuBIBnlkVSyianG4j5/D/PLtJxOScK8LWP7h6woURH7YaBQqrM31bOFuOZ35migTIpcFThKHubQNGnvb0Pz2S0xmeJdU6/anumGZDu8OwRMDUZuNMSeQ2YLajx4NYLlxYbDS/seotb7k0bFz5uE0EAlVnSuiPe7v6Mgo9U/iYsOgT4wEhs4vk4m+bW/12RThfOv+gso6XLiRql0jo9av6u/KT5lOZl/JX5bA9zanlsAbH/w1EPBV33pBaSGXyGP4h5DXmWxSxTNu78sq+BAdfrqNGpnF4U9atuau9ug5IHwiLCU+EiawokQp3pAOg9QYXCwnoewhzsk97vG/rAoKArdZzEgWLrXWiD68Y/Ox004G2YMFuzIHJ04dBLg5Nv87MA4hBugqozPmybq6dkDPv8oDZxpl9pzK21IaLuvruaPq9YGQSNx4M9P
 MWl+Z67w
 EKXYtQoA6nFhDZyAWzBpuNLI9WYajDU/SSlDeAN0ND+GSTJ3TyvMCsVxq7JLQIGCPbyYgNpxWzx5zve3fijDLwB5Ue8wQIgsoPZQk36MIBHlnJSjQ0IRBVOWU1rjlZE/Kcm7EmloL7sYiTR7N1Z7jklqVn5MHdcM/JVUhCu5aWpa8AdUzpQyORhNYpT9IJh31iApa9/h6P1H41KPEfEGY1BbqUCZWSm5JAdqJAhWwD5nrWs2hn3L4QxgcBnGXTviAkYzIZG0t77e3/W0a5Cr7ljwqLeP6uWbQLKytEQ9IeYV34LA5xt9gaqy0c7odoYE4IdBvBaXQvttqZwphAxn9bjZQthKaLusSllqRj2QKVv0TDzS8joKo6SqYJrMrDsecGrJq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Each full scan resets ksm_nr_node_ids unstable tree roots. Enabling
merge_across_nodes resets this count to 1, even if per-node roots were
previously allocated.

So when toggling "merge_across_nodes" 0 -> 1 -> 0, a scan that starts
while the setting is 1 and continues after switching back to 0 can
encounter stale unstable tree roots, resulting in UAF.

Only root is allowed to change "merge_across_nodes", and the documented
sequence is: "merge_across_nodes setting can be changed only when there
are no ksm shared pages in the system: set run 2 to unmerge pages first,
then to 1 after changing merge_across_nodes, to remerge according to the
new setting."

Let's fix it by tracking in ksm_nr_node_ids the actual number of
allocated tree roots.

remove_all_stable_nodes() and ksm_check_stable_tree() will now scan
more tree roots (skipping the empty ones), which is harmless.

Fixes: ef53d16cded7 ("ksm: allocate roots when needed")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/ksm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index dbfb8f98b1892..9c51925825cbf 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -475,6 +475,7 @@ static void advisor_stop_scan(void)
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
+/* Number of allocated stable and unstable tree roots. */
 static int ksm_nr_node_ids = 1;
 #else
 #define ksm_merge_across_nodes	1U
@@ -3636,14 +3637,13 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
 			else {
 				root_stable_tree = buf;
 				root_unstable_tree = buf + nr_node_ids;
+				ksm_nr_node_ids = nr_node_ids;
 				/* Stable tree is empty but not the unstable */
 				root_unstable_tree[0] = one_unstable_tree[0];
 			}
 		}
-		if (!err) {
+		if (!err)
 			ksm_merge_across_nodes = knob;
-			ksm_nr_node_ids = knob ? 1 : nr_node_ids;
-		}
 	}
 	mutex_unlock(&ksm_thread_mutex);
 

-- 
2.43.0


