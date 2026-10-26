Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6E3606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M7Bbv5tH
Received: by kanga.kvack.org (Postfix)
	id 95B476B05B2; Mon, 26 Oct 2026 05:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C146B05B3; Mon, 26 Oct 2026 05:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822A16B05B4; Mon, 26 Oct 2026 05:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC466B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E36D0406AD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:40:59 +0000 (UTC)
X-FDA: 85364283438.29.9A973F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2FBBC180002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:40:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M7Bbv5tH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8sRDgQW1w3D4pWC1B8XyfoJvD5sWAzdleJVC62/pts=;
	b=LdgKqHNiG0uCW9eXrdbH96uuRBqLA6S1nc17soAiNk4UxvC0H+WmCFC+j9ct3D4qePQSdW
	51HTyqE/ZEim5m/Hw4oVWA8DFCUuqD9mlQbC6zXee8k9eWBRBJ03/rr62N9lzxZl7cDEGL
	2BcXedvClgoB3p9BxufLdsBWB4VkDME=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M7Bbv5tH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007658;
	b=iAAam5nwUxCWy7u9CsLPACXTU6iXvalfUer8g729KZwm65/gc2AT7HFiPB9ofI0cqrDnB2
	Pfv/ZtZoiT+bAGD/r4+E4ui7o9/pooy0plEecPGLVPW09bKeifceS4uXbm7nY5Kv8iAqkL
	8l7iGkw72AL/WiRomdz7MxkExSpmS/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 834E2602A8;
	Mon, 26 Oct 2026 09:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2A21F01829;
	Mon, 26 Oct 2026 09:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007657;
	bh=P8sRDgQW1w3D4pWC1B8XyfoJvD5sWAzdleJVC62/pts=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M7Bbv5tHudJU27SzaTTiM57hAYPlMRoINrrJZbFPMn2lw3yOmpkdpT/uKJEKi2Zam
	 sBxTY6XSDaJESuHbZ+MuIOhOYEoo/wuWGYZl1c4zpTJRX13i9J1zZmtNJz1E2h/JbE
	 GpcrXhvetmnVnbe1KHwKauk+2G/b4hlM7yEnvN81Kmwo8VWcku8xlBJ+m+rqv9nDdy
	 yD8gBW7SYzxQEAYfk+oa98UiNarMStxkokouevqUGo16SrxNCTqfwx1+z3lYYckupV
	 oMS6GdTI+6LAQOW9s9MlVCx6RWFVUPdURQoIpzGUlOty5l2YirUkSEk567VIKDeqOK
	 4nkxf+Wv2+xhw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:34 +0100
Subject: [PATCH 01/16] mm/mempolicy: charge shared policy nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-1-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2442; i=david@kernel.org;
 h=from:subject:message-id; bh=owxyvXACeldrYZYA+sOC4Awt4JHmThu8F6n4QgaspJk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4jp79RZ5tcrUla5uSki/OCNtluGRZceX/jvuc/iO
 9v1bwf9OkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiI3W1Ghhalibzvju9h2pho
 cZ7rkd3FRdvkV9xm8XcymFA5oXvK2maG/xHv3HWWqG8NeM7bO/3Y7jXFYZ+i/lttEpix7SeXdlN
 UBD8A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2FBBC180002
X-Stat-Signature: 81zsth6zgmdgnbtsm91kefxaajbtn1tb
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793007658-585050
X-HE-Meta: U2FsdGVkX1+JlgGXcteNQFxppc3apJLP2phh0GDZwslatthMft/u8RREyydLQK3CNq3MwXxSlRFzdkGbVKwGLUGZJuYjBCPG7EZaCuZhnkKZnZyd37Ezn7y+fPns1kT3g6dpCSTgxmRDt0SZLRRntNvBonJF7dlDEJ/Ifa3J9rxm6jXDmu/5elHG2KrWaAxNrMVbjEXKJ5N/8nx3cVj8Gh6haaR+Hcb7U/pJWdz3LVueGx1s/WWDAdu6oWBf1dPw8Ig5WAHhSHVP7/AYdC9TP5rI3juKPd436N3C+AxO+BtH7kXlm9c5kdcgO7mgsd70GuzU8w1kaUP5cOx2zvXvJMCWp9eX2kjVKHyzbzBXwrl5jr7Gj/q/a8IUfRGG+AJU0L97T12VVD5Sb6nUBAIuDOZHTN7OQyoaDe4/LXnR7/PiylwhgONt6OW1ctazXWu2GQNHMvEgmERMy9mvlikCSzHyeCbLTasC/4WVgBMi0DS8jVjk4qUOXrPf5IFLNR7z5huzxO4WEUSjAcEpR0tW3W/G12vITFpH8Wih2CiuwJk/IQfH03EjuoHVcPCz8T793mbdJCsCTkNM+w29lsZVB6K8IZqVNtSJoeJ5Tci96cZBjWSiDz5qdMc+QEZOZ8xydj5fvoR6tc2Qpia19d6LNVU7fhpry40uY5WpI1tebXI0Fa1j8seWdYXkzg1Z/1BAMGclMr06G7liV9vbWqi5RxwwG7Vp8P7drI6Nk87VhqIiIaYbnMWNOJVJdq9ubFqMSND5lnn57/lyxjlQcYi+xJ44/+wWIelFRJWayXfuEbzE2oINBSJXLLPAb3iXa2UnWeGIPd0+A3P6uSN7s7l1sNuO1VGoUB5132mTwtby+bKbjtU7BdNKPQq1VB2tWD7FBYElph6UsimINgyd3cn7D8JBOrUEY2UIsszev0wwTql2t+hPPrB7A/dC3XakmvfabG2988zCTcQzFu3kQUx
 d224cwhG
 lpJy6mhOWCwnzluEs1lRyk8PRnnF6vLEuhq3WR8YgKDfViUB9a6Gfj2MDr9GZT2rgli8A35ya1kc2d4sMmeGgOYuumi2vzoZrop4BNP+QvmUoKWFQdstCJtuR/K6UyC1AP4rEySKrGgGjpcsUQ5pQtZaky8FI3MsULoQotw/J81eoWVyB6PHvcDgKKJOmjruzJ7mnF/Z2HOfb/4uBMAglQhfsvLRLzxhlSl8wBJhk9GGtLhZh38ZxN8pSiRjPvgk1S9ZrIm3+oaowSpE2gaol+awxgGarJzBeceramFwIrsSvcN2YhRTIutYCuiG+fuH/J3HK
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
[ david: smaller description tweaks ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e9860fb9f73f8..ad49b7524064a 100644
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


