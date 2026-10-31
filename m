Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476CE606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D55mz271
Received: by kanga.kvack.org (Postfix)
	id 586F56B05EB; Sat, 31 Oct 2026 05:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536566B05EC; Sat, 31 Oct 2026 05:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425EB6B05ED; Sat, 31 Oct 2026 05:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1367D6B05EB
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:50:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8ABED40955
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:50:26 +0000 (UTC)
X-FDA: 85382451252.10.F80AC72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB44BA0005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:50:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D55mz271;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440224;
	b=nmW0BugdRyjdOvzVBXbrnL00X9c60GB6xOvE5v7QndBvkNvz095rnDQHhDuVxF7DcseE3T
	TD2yrZeB1WpGvEmEgSKar8rp3vUPnyEirlhwhmQ7FyTSU1Qd4L8G3kDWBJLCIR36gqcVoj
	Z4b09Sfp0zVy99ZcoDjKaRDRBKulfDM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D55mz271;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7XJnsrw1a5gmHitwDTAR/cnJ4FEA4vxklFTb+Y9pAI=;
	b=sv/66eje3+YdX4VD+iYbSDGO1pJFyYxLhWQ9RKqocbsM2w1k+rKQbb6cairg2/yOfBj1Kr
	oGgFLVAwx3EgJPkEslSi4uuwENScZsZuTi91uIkUENfjOVMRGXvImjVfNUsE7BYksf0tyh
	sPeBwI4chEEgr5fBQSneW7IeiOwHUC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01EEB40E06;
	Sat, 31 Oct 2026 09:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB23E1F000C1;
	Sat, 31 Oct 2026 09:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440223;
	bh=a7XJnsrw1a5gmHitwDTAR/cnJ4FEA4vxklFTb+Y9pAI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=D55mz271223NPR/LC1mWZwbXNt7+1AppD98IF3Xlhmsw7cr59Bv8ph/Qx9T9wBTnt
	 IRwJ7seKAp3Xt9M0DCeWAyLI/MBriK9GHaWUguJRzUqEOo+TiWgX1qd5uRZCu44wc3
	 amVr5MQIuUPQd/aX+pFw1+Aqa6T0sOTHCCeSMgSu05Km1pYzwKn2nx9VLksIuSqedo
	 anriGwlarij1k2nk9IYxr5TA0xhzc7DIcNVboZ7ylnFEKgBq+ljyKATpFJ08imOsjt
	 luKTD8IrLdDRCGXQ76EvNimb8cuzICBrv/G7y1QJwDUhW0eiLn4XandQmIWO1ShaKU
	 YWQzaO32/jcow==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:08 +0100
Subject: [PATCH v3 39/47] mm/ksm: reset the unstable trees of all nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-39-d6437171ecc3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2273; i=david@kernel.org;
 h=from:subject:message-id; bh=nUvclxTiUv/Tum9+/Zt09Qv8koZgF+ihTZzvWN6IkJ0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs8SFbm2as8ZL5Oti3XlL6p6yF24d96eSeSMwCaJw
 rLk7vlRHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEykZB/D/7A7eX6mD/nX/Ltk
 832B+LYAgVaxGd9nsTU7uyRtnjjXYQvDP9WEP9ebK1m+eVvpxFrq87b9VOuZltIVvGG+efeHM0U
 fGAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: ijtj93e4s9s3goh3m51n185qfa9b3hmq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BB44BA0005
X-Rspam-User: 
X-HE-Tag: 1793440224-593088
X-HE-Meta: U2FsdGVkX1/JSFzDMiBIXoGK6+/EnADw1LDBsmYnt6WpzqO1js+5+GOSJ+ezo5unlPmuXX2bHplm8BXS3xG5GbJA7oAsHRNuETx7HArge6AjMaUWSyzx+I3iNQTUU1jp6PPyPzaFjl3AKvRnQ+wMjoNGi3kxOvP1BZ3iak3VBjnFPm1pXUWJfC7v6RtHt8bbwFbtABchJeKauXZniYcY1lycLxIusgf58+5vSo8vORGGuYmT7FtRVfBj2JPRW5dWaZfmfOTR/ihdGzAAZD/FFL52CJ4mF9BtocVviMoJxvLP7xnpGljloAUcfAWetHdxUK84yw3fCv64RzhSJ3D2Ynmu1WBaIRl6KonoHb+c68YXKvuzABJyxXcAOgjel/ZhEqd4TNZv096Cdj9qVy/7kmrKYf1LbsMDmzWiQSEqGDoiL85/TlOP1L0vy1dTo/XRqOCkQwWE+/fpJrIe3JaRKb/qxYkDLu3br6jtVdhztndjRoqtemuqkdWS5JsEWWkR2shnNWCizIPshHcdf+P1BLw8YiGZvtmVazswSJanilAGbgHEValuXDiUjRG5qAAgKmTdgj+jkrOiCMmm1MTaUQ5oOglZnal7fnA8GyLfSBJvQ8GaBe2yqVbJa4vDuF0spfHch/RAIxEkAnwnnJR0BdzvdTzzh/RLDqXtQjJ96VZyNJyK/M1KdTaxxS26XX9NXakKAr+FhGxjwitUNNS8IuYiT7VouKugafM+Lbc6VqkwkvMJpOK+yzfDrXQFTqtcO5qnvZpNLB7d8U8RclpaNOVg4Zq9EPoL1Fn8g/KWWdfZPi+p0HLLzY19fI3QaGi2QcN39uLV+PSVPWlwuy8dbR6esuRB6eayg5GsfljDj2ZvSCWQW2X3SEcK7U7lIHCA1+2k9z+t+Jryshe/doROaVKPJJgMS3+QjZPy6Ik7uc0B78u/GNSBgHNBdZSeP7NuLWdu6CIrQmCp5c6zgmy
 80Yc4wZs
 J9QY2iflfWj3fAPu5WVFKOPWSMGPMlRuXiRgJsyWn6LzRacrVRvqJbgQdjdJy29azjsORlbFG1hsJNIhSNjjbiXhG/NN+IADmx5F9kFvJsOiMFZj0BMtbYZQS2qeN3IuKGlt5v2zqsbXq/u/zKCoGp5jILlMnqbA76u9jE4PME9EwzPM7wL09U5twQGwA4BQQG92iPk935SeIN/goJ86zPeuO/ZxpI2Nx5QU7EcQGA4SxLuV7XJ6+WRI9kf/TrqDVUqx5xSeRzP2c26kaEG1dFEiMvVdjOzMBJvD2SfLpeptY1rqO9Lnh44XCyIygmO3vyha75Xlu8xSGE18pnpM3BZVdCWdAPhma9z4PimEAKtg/xidJOirRAvDAk73eBfn3CZPIrO6YA5EyGJca8GXtoOBWfdWJmDUe9WOdWtSON7YmNYL88jSU2aMYywLFkaO1V46jJBEqt3NGX0nUwXC82CxNjDIwmqKdeey6OV//Hrh9WFKhlktMWS2bfQ==
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
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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


