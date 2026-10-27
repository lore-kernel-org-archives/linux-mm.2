Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF1C606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FRpCV5Ea
Received: by kanga.kvack.org (Postfix)
	id 073E36B05E4; Tue, 27 Oct 2026 09:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FFB6B0717; Tue, 27 Oct 2026 09:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DB26B0718; Tue, 27 Oct 2026 09:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7FC46B05E4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 652AA80985
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:34 +0000 (UTC)
X-FDA: 85368422748.09.16C05AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81FBF100009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRpCV5Ea;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7D2pDXqbZSONsr/MmRGENltL8knHH0R9po0DYvSbu4=;
	b=PBUSMn864Ju+q4jXqr91wAf8Wqt5e1ayG0/P+WAjt1JJYX0EbHIASbkIIZzpUDm7LEENdO
	bacphpW+CzjJSWdrn2TAsB18ugILz5400JCgRZfWgljHaHnHn4SitpHWiOeas/sH1G8DDM
	Up2ZDKDf+TrY8YvQJIL0El+O07PzROY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRpCV5Ea;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106212;
	b=zX2ysE3Cg5NbUZvURqVzb9AthbWXopAELUUqnwgozc66JGGNpeuGZXA9Awcc0syXaK+J1E
	l8DMpKYLbSzd1n3LXTwAzM4tsgrwOQ/fQp1aYEAl4DwfL3kciM5P31grkJUAm0aiI2gfAR
	cQwRQYoGYj4iE13Ck478oQ99wTIoWxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BBA0412A5;
	Tue, 27 Oct 2026 13:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1FB1F01829;
	Tue, 27 Oct 2026 13:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106211;
	bh=Q7D2pDXqbZSONsr/MmRGENltL8knHH0R9po0DYvSbu4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FRpCV5EaSLtVC8eEMDVo0u1FmULq5zDGV8G+kIfW8i6YVeXP/TraM30QNhy3KXjGF
	 TBnRw+JKmsEW853CgwTRSl8OoKlIpdTxwWbJMAFAK1gjL6W9P0tdldeDA4VYmSJsBY
	 fjHs9KsqiPI4s5TiR4sQD1nIN+sMvB6zVtyxz+YpiyNGseRZEbTNv0cVqSqDevw32+
	 jyhOI+3+bVZpLb5QwbsZvJVYVjx6dn6y8Qkmj279LOd+xdlGrO0ieT73YWk2/15IK8
	 EQds5zruV+Q+e/YrZFZQohlrg2s1XdBdfdN2c57USCYUbV9pDRzr1P/bb9RIqoiA/9
	 hAJ2HAAxOHgiw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:06 +0100
Subject: [PATCH v2 01/14] mm/mempolicy: charge shared policy nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-1-86a00952acb9@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
In-Reply-To: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2683; i=david@kernel.org;
 h=from:subject:message-id; bh=gtxaBrXycCbt80R146vYiuduiMmjXTomAHupfr8V11s=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBQIF+jI+L1r94RdB436LiUluq0JODvPmOXDkYDLc
 8RbRe/md5SyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARnXuMDJf8uF6o6vkvbVxd
 X2Xi6Dqf97lx3XWHy3xh2TMUmPOnJjIynJtZssWR/ceS7r5nvheP35HT81T10/j9Kl6zoGkuo30
 1LwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 81FBF100009
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7m8j76mxw936wok6pwddpy6tgxoza81b
X-HE-Tag: 1793106212-937757
X-HE-Meta: U2FsdGVkX1+K3/CgEJJkIvf0amTkrIY2rPkaaNIqSvXv5r9sQjBiABiCXZDguvd0ozYaj+QuQDZ9soM27ZefhmK2mUOis3rJbMCO+5/nbH5HAM7h5Pqtga+oZ5wODF+PNgLPxGjwWow1itkOdpBJDp1JyARygJcM52O/bpeZkK3O/d7CXo06aRsBWwN03L5PnP62ccGFKq5+O3uOe+3bK9+6x4WLkESWbWZlw3BGe9hG4uChPhC91KT+HEdHRC992ak0JR5+yzxkuZZ+ckmww7gCLyJtnJOsYYfcpt2zvpTZH4IbjcTPA3Eay2zZHDvXks2bTjp8PRmd3qtQHmt2QykZ7kxLMscTBZKSU6Iqznf/fTLu4uL0PMZ3tQxgA+GD174V/LVYhAKn3GCTj+VdY9FfnbV2+QNq8C76AxlUW4axEdLC6EerWhpN7EeDyOnqxvGUcY3ocaSimTt2Wd8evMWVd/SwM28e/53Km5f94Rg7Je3yRFl1zAPgX129O2rngWe7KQmf63TH6kn7+dqDKt7pALILBy9KQ4Pc0MtEjPxYAB96e8ZYhhLJ9VviQuL4lsCT97EHBsz5dN2vsszYVs52mebtVGt/pnBL4Q1f5UsTBlXn1vPEthZyoXgcjyovO5P07QBDbCHoTDaqza6SVbZNpeJRVF3zAAwfNjPzMZ0KvBGSDJHKh7U+r9TRbdsgASnjtMeo4R9T1J9uJCZdZX46/0YuXiC5qD0UpkIaJBdulwB9Ht7rpo2EQLFZbWXVdQJvdTV06kikEKnRMGrDtWtcr2gOt+JA9zjxYT3SjM9vhg8l7kGvNXsKD/0CFVC/KhMIfy3UX3CxP7Mt2znUNye/KIe0hsTqtEvRh/KHAkhSqVT+aBUMEIGgySiATyALYzbW57MQYIzoQJ23QJqgcFrmQlLPUmDERlJ+Vjfnr641RvDYj+203+zyAkcIgDF2iQRJLWC1SeEupXOuUqv
 ymFjN8YG
 IxPsszIaIxah6eOzr/SzhJCjPF88ESZfzAaru7UH1Dz12NCDFg9UNjT8twMFey1PfQUczL6QwrWxB6CPRM7KHQHQFi4UX491SnLvuL0J8V77P4j80OpaZvNSVLK6CjR0yfhSq20eYikrP3yGdRXaLMjyOA589GyhQHu03BBMGu9xzjspv6blyln0koOnzgTiv4drczyvSSCs7xjT5VYk8koB8E7o9Pak6229unyaxARvFXi37JI2I4O3renFJu2hEHW/sUvxO9w83RdKr0VbfBRMUByxv0+Y/wKzcICacIHxELIqw3RAlgoaFw6ctreklRikcnUWpss94wUCVj1Dp/ftHNjyeZalkpXDljDgpfoc8awlHhWhc2WhoK0y7YOC9JNEDzCKdzHBl+dzR6GD8fTXY2NGLGk2vHLDHwFU4pcDPeo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Any local user can bypass memory.max with mbind() on a tmpfs file, and
allocate unbounded kernel memory.

mbind() sets a NUMA memory policy for a range of a mapping. If the
mapping is of a shmem and friends, the kernel also stores the policy on
the inode, in a tree with one entry per range of the file.

Each mbind() on a single page of a mapping can add one shared policy node
(struct sp_node) and one struct mempolicy to that tree. They outlive the
mapping and stay around until the inode is destroyed. The tree is not
bounded by the file size, so the file can be empty.

Memory that user space can allocate must be charged to a memory cgroup. A
slab cache does that for all of its objects if it is created with
SLAB_ACCOUNT. numa_policy_init() creates the slab caches for both
structs without SLAB_ACCOUNT, so they are not charged to any cgroup.

Reproduced with mbind() on single pages of an empty tmpfs file, from a
cgroup with memory.max=8M: the global OOM killer killed tasks owned by
root, and the machine panicked.

Fix this by creating both caches with SLAB_ACCOUNT. This change implies
that mbind() can now fail when running into memcg limits. Further,
the policy_cache also serves task and VMA policies, so they are
similarly accounted now.

Note that per-file limits are not really helpful, as the user could
simply use many files; having limits per user is tricky as well.

Fix generated by an LLM and submitted by Chris Mason in private.

Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: smaller description tweaks ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670dd..4da1cb8777f68 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3372,11 +3372,11 @@ void __init numa_policy_init(void)
 
 	policy_cache = kmem_cache_create("numa_policy",
 					 sizeof(struct mempolicy),
-					 0, SLAB_PANIC, NULL);
+					 0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	sn_cache = kmem_cache_create("shared_policy_node",
 				     sizeof(struct sp_node),
-				     0, SLAB_PANIC, NULL);
+				     0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	for_each_node(nid) {
 		preferred_node_policy[nid] = (struct mempolicy) {

-- 
2.43.0


