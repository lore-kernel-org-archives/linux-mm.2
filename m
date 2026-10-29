Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83441606A33F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8FbsmnN
Received: by kanga.kvack.org (Postfix)
	id 9F1D06B05EE; Thu, 29 Oct 2026 16:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9626B05EF; Thu, 29 Oct 2026 16:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA2A6B05F0; Thu, 29 Oct 2026 16:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9046B05EE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:43:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D2014036D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:43:07 +0000 (UTC)
X-FDA: 85376838414.19.C31D3C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 557E940007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:43:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S8FbsmnN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukvSnc9VVc3+aKTeb9PBaNc8Py82EOnJibhIoUxMHZg=;
	b=etfc9/ppjlZvHklOfzCXV89sq+5gwsQRiRYSGteRu2XDt3fXJpAtLUMMfWVREgm2hCF/Ii
	mpDcO+Q8OPfqIwGM187Vme8bp0OIUhzw5gSLSMLHouC8DLGDnzjup0j2+MGAq7oKsM+YCX
	JJ9X2U5RxzZZvxg5WaMik1HTPI8bMk4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S8FbsmnN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306585;
	b=gh/A9bmEEdSo7LI5EAqCTSc/Ripl6vzXaMjEEZHjN3VHOvXvcO/wIZl9qvwRDk6LUwT21g
	Qob0Ges3uHZGVYwwnbwpg+A5ouf861gV5cF8AQc/x7zpbI4wwm7tM/8qMDFBeuIg+UU+/R
	Wb5mbBZkZu53cG5HFPv87mnsOjw2A4Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D654160619;
	Thu, 29 Oct 2026 20:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C581F01825;
	Thu, 29 Oct 2026 20:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306584;
	bh=ukvSnc9VVc3+aKTeb9PBaNc8Py82EOnJibhIoUxMHZg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S8FbsmnNOor9iMt8aGi/JafQAxsLqG3RGF67M4+YkY+bfjLhZP05oOL+wLOh/VMVi
	 xpxXBig5h+Ps5h0PkUYh0RJcUSrNmkCMzKTKvGA3HWL0cmQq8nJpI2zsIlgFK+Ewkn
	 ArmeXbYFayYttDT2/E+E2ZIMWAkeIin1CRybodeUgv53L+r3L4Y/JF2GeyH9TEP3qm
	 2YDBuuePBEA0zf0C6CWmmEfuCvium6jPSQp8dKwzaq1tJGPopigJJ5ztzX9j26W8h5
	 hyObhrs03z9OqcOuYcHKu40pDkONYhgOFYxRA/kRczyV9HVZ9cND6kv329GCBt7FBf
	 fLADHXyCo7eNA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:34 +0100
Subject: [PATCH v2 39/47] mm/ksm: reset the unstable trees of all nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-39-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2216; i=david@kernel.org;
 h=from:subject:message-id; bh=qFI0e6Gq7RNpgOyDOhV5hfkjLlYbA5wha1P7Baiobyg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+1c7zu38PLkvM6G9nsHQlYwtF++tW0rU+Kcoqaub
 UunCa5Y0VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEJixjZPjl535bMbTc2Fzh
 a/PcuJbe6S/9w2XXTLcp5inr/KGxIorhD+entrzndb6N/27ZGRVYrhZjq/X22eYhbnw5LbLLKmo
 XPwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 557E940007
X-Stat-Signature: 6xnkj1sag45ebn9aarmet4zgyii6xkqw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306585-94083
X-HE-Meta: U2FsdGVkX1/fvu4eQY/wHWc1Np3le2x+NU0wWddEagazFuzimuzMbNTprAHIPd4nyL5E2LbNKJBrZeY20Fd9el0MirKvXpd4jPIpwvqPeSbdOJCCIqUC0wAcL3p39EFcMR0R4vssba8M3xxnWfnKBoF2u7ohkLzBSaWBPuTmat8B0KnIH2fNP3YNUajI2TcF0uHROxok942+fiNxVIeZE4CPpQsiJuash1Ix5BiAuJL9Xt409yM78IpivSLXRwRM2QccVAnPYSqGUd2VVazRl3KoOPLryfrXWQvFcMJp9exXclvUQQXEbhnSxqkmKJR9o0vre9Z2E/sWE+5VfHhzkSRyRtEUK8v+zQaMVvxuV5qve0LqJ17WEpBBlWeqyvB/u4txifZMJWUdFYanvymBl7wMfU6FqrOj2Nyk3lBtYyAUg/3wxpR2B+JSz/Oe44SIfuLpLUOeGOGiBKmbF12dEn9dFoe5NteNb0SkLkrccguleM/GUjSPPdOi9vEubO9NuVj/8AYh+nr8otKBvG9tBEGcUGhmX1JOOEpSQD0hKb8XQ60pEJ0z+RkUUcsmTw9pJKqrc6JYAUMjSYxAPBJVIYfGsynlHYmkQu1HtjxZ/qWeJjfdjMLf1e62x+Busu2Yz3oITRacx38n3FvJ0UCHEGjNQSGvy0zd7UPzoRAt7wF7f55LuV54oFsXhkjMmSvIkb4MOJS3m94caQEHSv1THRROaCrI1flAMcCWheYFlbs+ws5FWcSiS4xxCbpeTXy+rIhy24FTWV1c9Y70UEPQTE5On69iEXMZH/jdWyxRR8kifqhwHN4qt8erEJEq8JwdEdA5mOjBk1PJXarPIf9MSah/SjJm5+fpisSwnZJAuVNgKKUXGZjhK5jbakiFvSZU6KvHXz9JrCgxQijjsFKKpasFWolshPIH5/K8wZx4u9dQj2oOHcSVm2xq8qnd5tQppCmzzc4tf1Lhe8X8eRB
 VvEHY7Pp
 j9B20jsabXUncWXzsMDTULQTTW/8G5tlFxNw+v3kiurP1+X/H+OY8LvTnuUROouqAmgiowN3AQ3+Q3II60lR+PTZZvVQUivazG+MIScIyN0G2ctp8RixRgza5sHupYWyZ018ESeMp2NXKuEEZ/z2IU/zKyqsFGIVdqogiXW4hJNSKF2H6YDlA6VZAxBT2koB7tVfejveJHxZsuKuBR4mwigQl+iFR95FLiA7VD2a5QbCC2UoZP4gqiNzQCxasve+YlMO0mG2DD7dx234etzTBbSub7oOfoWo9pNXgJCDfCG0324UXgxPJOR9isAsNvqNigXK9+pDOyGFmKWcdqANOj44TAo39dEcxeRa/Pk4HsN+EKBQypWyiCjGv7aN3bDp0QPLxeEQNUQ2Zp7SIutGUGHSE3b10Wc/l9E2+FyAMWpvy6Awf550Enh1wkw==
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/ksm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index dbfb8f98b189..9c51925825cb 100644
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


