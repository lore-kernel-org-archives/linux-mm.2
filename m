Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D651C606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dAohb4eg
Received: by kanga.kvack.org (Postfix)
	id 030346B05BE; Wed, 28 Oct 2026 05:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22F26B05BF; Wed, 28 Oct 2026 05:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E605D6B05C0; Wed, 28 Oct 2026 05:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C43166B05BE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:55:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 955D6C0BB0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:34 +0000 (UTC)
X-FDA: 85371577788.03.3313D02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E17B61C000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dAohb4eg;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F8pPM/bRUTziIOodg42WNv0yxbRY0HbfS2ntsfLX70E=;
	b=PAFxb5AQ10HiKcaAWQrNIvZASVCDcUo3Sk4B8ZA8OrnUXgBhvpxzRZO7UrA3MbfYFBxs2g
	wZyD6aWFjvMA+sWOWnzE62qUJk3hXCal34yVmOZ6riCEoTU8EeI6XYp4Loq75Q9KwGI3wb
	Fa8hnrkxK/YiKVp3G4YdEskADn0ZxF4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181332;
	b=u7qf7y4j7PqfXrLTBrwOPKcbM8+u3/8frYyx4CHDcb1ostHriqnqGbTRSWyf1zf/cmV3o2
	RsxvxKMbxPPGyl3eH+CESmErHFz+elPR5J2ezE1Ynb6i+z5BTGv/ORMGq7ktpaMCYSBtFA
	d5g+Fol6DCX+Nv0kjtQ2/nZi0A17rYE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dAohb4eg;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AEE16020A;
	Wed, 28 Oct 2026 09:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A703C1F01828;
	Wed, 28 Oct 2026 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181331;
	bh=F8pPM/bRUTziIOodg42WNv0yxbRY0HbfS2ntsfLX70E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dAohb4egrc9euupGLmqj2Zinirntj2xoQNsartLNbJPRvK8bxD5jn20KboSV6G4UD
	 kjBCDJicWJUe3+lR1pn9RbpG2X6cPOTDCM4lW7cOHGmkoGscInpmcQRWnaj7fGrZTM
	 eJqL8ZfQCl+QdJFER8Wl0opx6v5Jz0BFzkLgK1WJ6xi87CQ2X0wvSDBBXegC9qZGHY
	 GSLxWxFkMwspJL33RpJIyO4ReBvyVjdfVHuWOPJ+YCZwEPf/6CpH80BP3p2+VIBWvt
	 zrv7Ywxn8NFEBdFyyeAodSm2Tgzm72mssDrmczMckeNwV+MeSnM6UVfIiL9CK80I5M
	 3L1BMHU8CWOcg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:54:59 +0100
Subject: [PATCH v3 01/15] mm/mempolicy: charge shared policy nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-1-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2681; i=david@kernel.org;
 h=from:subject:message-id; bh=8g2Q09MddcGiWaBBqP4q1RNteEaljuHdjt5+KbfoFWM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHms8eqlr1cuWXaKtM6/v2H5yg/HvY7c3zrU9ss1NM
 z9r0eOUqI5SFgYxDgZZMUWWoOD7Bi9frqutduNjhpnDygQyhIGLUwAmsm8Cw1+hgMMvFITffrb0
 fXJv+947Vq6xpReuCSxLcatZvOsm780Ihv91h1yeBBvUVdo+trpZELJH3CdR8ePbN4Hm+ZyrmWS
 iOnkB
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E17B61C000B
X-Stat-Signature: 99zinfb5rrokmsqbw3qb964tw73ggich
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793181332-314642
X-HE-Meta: U2FsdGVkX1+RZhzlBb8RYzRoKP3EasWTSn6FSLIAkVRw2npjyxEZ2HSQURkJU31C6Z67gvnOScjSVs0EfQzP4+AMzQNWZ3u8C+5h5eMRJ9LHUMINl6zOIt5AEyG+4y1M7cU5/4Z76B9rNhOBgo3prhXrjZ/PWlYyWWDREXC0EtaC275oZLQoOQoNx7d4qHfsfr3PbPPVMyZuK45jBq3RGkyK2Z71IOXH9uBRWNNoza1xqgdI1eb4R345Q/QSLgz6MfQ1oRBsJh3S5fy2cazMGtjdSrAi46nfIjxsXllOVfnh7VZUoO/68D59pLv+ff2eglzc/2KvYDrk2rdd8ejrp57OdGTh5/EOZdoMgzDQBhO8CVRWXYpOg3vUmclbWS/OOLjXTs/FsGmYbeAaQ6ZPYk1YZBXvc1qZL1Gd7yisIhl/C2uj8/eTee8ineKS/ohxEZOvwzXNhVFH5TLVuQeV2ajHYhvo3ihGSXJvc+nDR+g5qnWG+0uD34jNRL8oHKFBziH1NSfnyi9o7VdA7aO1aONO3VNiI2VX1usNZK9/jG39A/7SkFURN0UueNNMkIYwx6cPSqKTHwccfktwoSCVndX0vp9W3qgUsPdoaXGAGOxzWoy7T3JaTCSIUq5rsLiK+Icw4bC1Lt3xJad2EtQY+so/tjq3f7MyJrYL2qsAmCVe71xBhTeG5RJvujSiHAUTGtae5hs8Dd6Z1nvaP4AFr6bACOjfXlnhIuhPh9yNI2Xmj//eQdVivw5LGfPaodxWy0Hg72yd7J3gOYnEf7L/CmgAp3yQKZUVe47lVQnNvkIPhgqP1LfF+Eg0yX/vLKHmoEZNvgeFcLOKI+AVDw26RkJPcSfYCPfxmNSiRSEt6Dxi25f3RbtzFdUV7O87LQrQp9S8wzkb/gsyB1Uo4Ihs32NCE2i+sydlpYGbvv2tiuGD76iE1XiaU6XKLjImBTG8qUDPDXUMOoFVKwihInt
 t87ZFuWo
 JjsZwa9dg6xptog6FAgz6o2qEir6AKrx7nApypEAYrT3GgRZNp1lVFH/7rwC+Sljn043098tweMcZ36VqF5vUstEFXPZcnvDDsRxyjXNIe/YOoRvJVfSV7+h8+DpRvyNvKVs/ykWZvwf5pWSkvI6rsctTFqpvZtLo+8yEMWYwkoLEMMG2DsKN13ockaRpCSatUSpLEX3vmh7N7ZGv4A7I0j4yNXMDxp6pgBrW3Fs98DUgYidLWhqdLS/3Y/jQxD8NV/nMryxns1733ayRgr0wyFEx/OamCUHoz+HAjfecmeLzsUmhnbh9fL2I6dbgeC+TuZkXPEFhK0WnsUsmGPDtJ/nOieATQ2l1E5w/61eGocLldLMzlpavx8CZGMQRPH0XlOGNbzYqjzFy017FarlfZlPY5isawa+FilsjI1SLlmwf7mc=
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


