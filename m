Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535D5606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bkJpBq0A
Received: by kanga.kvack.org (Postfix)
	id 51ED76B05B7; Thu, 29 Oct 2026 06:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F71D6B05B8; Thu, 29 Oct 2026 06:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C996B05B9; Thu, 29 Oct 2026 06:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16F9C6B05B7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:44:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9200612032B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:00 +0000 (UTC)
X-FDA: 85375328640.18.70CF21A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B5A91180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:43:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkJpBq0A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Nlw0Pnf5KuWb7HS/hkfHK24u0Jr83mMZGFwCShmQGg=;
	b=DCP6Qo/kxEzfFJgNSD7VXe6QtUOslLJQ78ZCrzKEzO+Zn6uMsZyH4RH6X0CZxJFZX3e3OJ
	NXjbHr4lJF0aWjclusuoTTgYfCJ/4HgfdKzQv7nEH8gvUkdzIvcu+9JMOT4laFzHOuk5qF
	8Gmn8LavmfXPrlD3vTkg8gW77akYn00=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkJpBq0A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270638;
	b=8FKUeGuM0xVkN+/qn0BPJdE2DqSqFLyLEBevElCoJHJ3A3YtZ6in/csrP6rng8UVs4MWAu
	8u5xfhHOBA9Bog+Q4yY6Vhb6L8Z+u0Dn0tDjGEcJgYyRu7sK10ULthXUhTMxRQg31kcg6+
	L+jRlVOodpxSIjCgSp+tY5u4q2N4Mt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEC5F40881;
	Thu, 29 Oct 2026 10:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B771F01829;
	Thu, 29 Oct 2026 10:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270637;
	bh=4Nlw0Pnf5KuWb7HS/hkfHK24u0Jr83mMZGFwCShmQGg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bkJpBq0A7tLgFWdOTeb28VWNLmlbxVWYyp8pS+qu2QrbBVm9OwZ/S9+36Ujn4s2Gx
	 ACnwcqZFOCZRHWLVSzlcr51tmv+fL3cxOVyAHrNO0VcNkwZnTQXp+9+4i9wIywZolS
	 juvTmqzAS9IxqhjP7/JPq9eKLcDjiToJkMzmDsfSimQ/4f+fvhoc09ZS0lkYCvlO6O
	 UuwseDQcQ4yUr0bNdr8P6+033fTHXYJ+EJAlafH3AuJ52tUJEIfdMAHcouX8XYRIQ7
	 XWHHrbBG1nQQVs3FBD5sM0y9m6K1Rw2rhtUrHeuRx80aLsKt+jJsw1oxp4kSPra1nR
	 tWYvqiNf7ez0A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:22 +0100
Subject: [PATCH v4 01/15] mm/mempolicy: charge shared policy nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-1-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
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
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Balbir Singh <balbirs@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2729; i=david@kernel.org;
 h=from:subject:message-id; bh=EMJxHgy6I/JyLvzzM0S9yIHJ5L/vHfGKZm51JgH5rxI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4f5M12OPnCuXMrPfaWEh+5c9pdbo4KrZyUl5x/o2
 jGl9MbLjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACYyy5ThN9ssdY2JtWedy/3Y
 Wi7q8qcnfZa8xvWx/0dD8q7cJTdyOBn+Ssv4dP2++1eqkv+1Y6Mzd7OhXtUjPjYDWYmWgIAeKXE
 +AA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B5A91180003
X-Stat-Signature: dy1eiepg8bnbc59fgt5uc7z68gwojnbz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793270638-922028
X-HE-Meta: U2FsdGVkX1/OKhtPGAwJq2ZJzLtpwfRLyGXSQHHAAhCNBIZqZfWzJjKXBdGit0t5KSFE8KPaO95eh6VUcsSSzGXNm/Cdn3h8XLUTfvJxk6V+czDlvRoNa3XVh5GAabovBZuZ4lCBDm4BihuGpqozE0zNfSFbQkUR3jlKP+Hs0Nt1wRmwlxSkcU0ZwEZ41slAf7V6+8wvzR7oB5vyRzYhjaJFyaus80tWEMZReHCgvLQMF26cyh5XdOExjBtikHN98NnE56QiAVkBzE3GcY9TXQP95HATxsiIwY9m1M5vAj5bKDL9Kjg7BhOTj748fCV1pQGFSXx96MAmSAGHxad9DLmX/A/pBvED6G+CRTjNeDA2B8nNa97p+ko12AiMdyhsVOHcEBiiAacAnYNo/btx7on2cAuevup8prCqB+2xVK2oRdOj4nt/VI8AGJVC5QMlOHE9/6gYxIWw8PUOVApur5LgVpbQA4QRP49nKyBqt02qC+1+ud9CYmvgOAKH8IGI+s+Ub9v6M+Py5k3rYkyTfusAYC52w8n+oncUaVtEBmc8NO7A4b0GgF4WygxXFHjJKpO6GKCrxaYDg7aDonu6XPgTlOhbWpVcHMxpadqRJS6Mp/eGt3ltfC5m0MS2arSDG0jj3M8OklBEhvbMBmWhqzEX4UmzGDVf7FD6hJClIenpjcJZ5bpuKLX5hVN7HCmjiBMTnIQSH9hE9t6NajW2SngFtNEe87FQhDTsezLfK1EjdWfyW6OeaR2amT8oJPM2DkOfZgqz8/yHVbIDL3Oh8uhZpGvJu0bMn9p1wQbEDJ8jFjYpVSgXcckXRlHLyFb7bNi09gi9kqQpv55ReMpQ0NdiRDyGw/sD0WkT7jfMJOfB4dGk17Zw/5G2YwgapeiwUtLqihUpibgL2F32na9o5U/yENe/JYe+sxwunT+j8av6yHvisxw9o0lqmw/35wdT+R/yfPdpsN/E3rQfjAk
 qacUbHAw
 XmWW0Cg2RlJEGHKdYrR0wkixMzevENJXYpJeD3XXJc4yceZMKxhBMAwkhSSr+yNB0/lEx+G5Dy6v6gmQZyCeB2fbjuQMIJOoc5E60PGOKREABBubDAv4yLHmrlP/+vBmKjtK1N2bR8PsjcIXZWskLnKDjBhG9tXet/vdygckPz5MTq6xp1GSK1oTR0Wnt2eTze2ngmui6CZEyws63n3c4qw+xQKD8glugEPS+X6yjixtGL/FCAGtRVkvYK+brqG13LYpH7BJpT7Q5UbDDA9X8TW1HydJflIQu5qAnPva5pLrn/BBtbOp2+2c8+RC7FbsMGktEvk6Q1InyjpwWY9C4r6HX28IAE7nWVbFZsRy1l7lqNobio8RPu7QTRyEcEKl9isBDDHc7vYNeGWk75ZHDzKi/L3zR2IV3fz7eDUGymX4M5uE=
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
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670d..4da1cb8777f6 100644
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


