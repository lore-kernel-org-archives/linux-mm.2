Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18891606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQKsyj+q
Received: by kanga.kvack.org (Postfix)
	id 4FE046B05B7; Thu, 29 Oct 2026 16:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEB56B05B8; Thu, 29 Oct 2026 16:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DB96B05B9; Thu, 29 Oct 2026 16:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE6CB6B05B7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:34:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59A32140506
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:34:16 +0000 (UTC)
X-FDA: 85376816112.08.64534B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F46F180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:34:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQKsyj+q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUH+yaBKom46Q63QM7iBm+f59t3sGZ4mQyL9p/SX3S4=;
	b=ppTceLFwJlFEcuZyHxvg5Bx8he/K991cu8GkMgmpWZCBylzdVPDWrv8UmI3/Dk3HyMdUqo
	piqcOGufQEpsmIcYpgiLyNCro5349HQqo0m0KhNR/22iDDkSLJPy37JH5hkI8YNzZ/DCOw
	WkkWP1/+Y/sN2oDvuIbaNyAB/W1Ywxk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQKsyj+q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306054;
	b=dFK0FvK7cfQ7tk2c+ASJ8p2P5FDcGKzWGWtN1lD7X669MNAfO0ezcLspdXoLyYlddq2zor
	HliTD/3nX3vfIV6RWP+3vCFRh9CF1TV4fgsaG9EXKMUmZVYyR0Sbk4iFBM5KDAMKs0eeN/
	OgCFFxRcU1WfeBfxxjluq7WNjS6c/7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7E12416D8;
	Thu, 29 Oct 2026 20:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26F31F01828;
	Thu, 29 Oct 2026 20:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306053;
	bh=IUH+yaBKom46Q63QM7iBm+f59t3sGZ4mQyL9p/SX3S4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AQKsyj+qR4bxZGp8hAtyoQ1xOy4UZyL47FxstML+FqQX7G/y7pZ8l9SOf+5ou7WnS
	 AZ/MIxoJhVWJNFDauvFzu5zXAw5inOOKbVVHKcdXEUzqJPeX7wQfcuJQKHYfLV7cgT
	 DBS0xvxyeqIDcCB94oXE/FoCz/yzahtQW9be2ViknnFuUwiLNKNChtzZica7dWmXmI
	 rxJu6FqHy+hS0KRyeLYDs7SF6JTjHzt3/Fnx/dmoxM+iCSbUu0aeKsMfsauzJgHrdB
	 M2PNJNfSKISDgyTRDXYcWYfP+czRJ+zkR1pNBo2whDOaHlVJSA2riVVk0BtrRZThlu
	 TWT19hXESofoQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:32:58 +0100
Subject: [PATCH v2 03/47] mm/memfd: check for real shmem inodes before
 accessing shmem state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-3-a64ce7f83abb@kernel.org>
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
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3516; i=david@kernel.org;
 h=from:subject:message-id; bh=llGJ6NdJiWik0yJaZwx3srvBERv6b9fGHgw5NUViur8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer21Ju85syDihqpSx8kZevq/BZ7vdCS+E9j8/nxLpZ
 /XE2Ia3o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgImo6DP8j8p2PfZIeerUF4kK
 Hjnn3G2C5wiVWez72jNt+fOvrBv2ejH84b6byOPtzq2/yLfz8kkfNWWZyr3pRUYsIhJrNjtK6AX
 xAQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 7F46F180003
X-Rspam-User: 
X-Stat-Signature: biupy8g41us7d41s3jf8sttewa9rsbor
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793306054-780677
X-HE-Meta: U2FsdGVkX19ZvNd+KSstA9B/NWlhB1WnnWErGpT4G2rmGj6WrFsu/PqpM7n8PFiNl5pNBQ5H2UDkuxuPYrQDEfB9q79z1q5v6vqrEST/NJVgqztlSXrsdyNybt1Js36KlEzVZNXFll3KxxFjae+PWkSr6+F0PKPkxY4Bqa6c02OvKPk6DzzHB6DxkIsLMQiLX8qvN/gfCbz9EuIFae1Q2S3wAsM4sE1GNd6YfX28AGnO4GNFOr7WNE78rQcCnl+4vt4K9PkR/9ot35Nl2V5/7I8IFT3c2dMdekoQ8DU2H9qro8CwxkzrLH+f1M4+eNE3ILGR61flMr6wV9wPaBGqaoWqgBRE4Rp9BfY/QncKXZCpzEmn2MTwSpmII5zOlYAGJY/OEGiH2yRZUBd5k661AjQkxNx6p4SmwrzHQJ9lpHjfozgVpGnnWwP5XYTLTb/Bhzk/MB8vJENFox4qXroYmJbAqChwoK4WxBxVa+cylJVvOFeKxPJxS+RbdcO0pBce9UlvD0LXO50ApKQT02tjzlkPDehKJXwih7bBFxLYeQ81f1d+H46Nyv6ZfDMR83uYVkPQVvo6zXHDi27CGgArkBHxqi6MRGL2UVJ+uagCQD7kYR3xkUQhKISZUMdBpuvEoBRnZJ4TAJtoBuKnRWcl1o5ZIGiKHNGc2fyQumJ0thoXNgov7B73kmwZ4s/QoweLYIaIJpNHynYHQmPMZLYOfuod/u+9NF0YaY99TcdrdG8F4LpslHSGzjsSz+c3YX8zoJpSj/uY9csSWyqUHyRrULUMD19hgizQC77N9OcgXFjEvQyMPcxKozqRyXu06Zu6ETQk8Lmr0BCmvfNUcnOTK+E7+p5j3fnCtnK3AzhyLIvH6AC3dEKyd4+S2iNJFhkw36g73FJWJGqXSncPcToqTccJO7Xe3P88Lu2B35OknP8awkrI2aWpfb6TCNMc46lB676bZ4QHPYxLH5Q+i9I
 ZclQi2XK
 c15qWU4dv0vGD0W6hD5rdrEyMKpMrZ/UrxotbH74HNw6yFFHaJxwq4DwVKTNTuKGgqUMYeXxW4nyqZF0isoduyYAYiW+3Q5k/M3R001tEiWeTuxYNpwrqBltArP4+gxhcejoEFIVusHI5tpKI0KovM7PgBhveISwW7gzYYbLENw/QEIy0DiqXHjO53Dz3WwPzV1xtmfGcDefjd6Bq/4q6sVTg54xY3NpTxvKQJcpNBAQd6KmUy4Wpf+aKBJocT+BD+HFMNFZHIp71pt/fJK1bDaavEtNsehAr30oCn5amrHNMpGdhAUIH94zsZR7caPDi16lksI2CXj2rh3pZ4OenZ9SM0rP7ay/nIS38i19tpqLSRwiKTiu/XUMlbD7WVWde047m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_file() only checks a file's backing mapping. That mapping can belong
to another file, as with a Coda file backed by a tmpfs container after
mmap(). It does not establish that file_inode(file) is a shmem inode.

Seal handling and memfd preservation use this check before accessing
shmem inode state, so they can access an inode of the wrong type.

Add file_inode_is_shmem() to check the inode's file operations in both
paths. This identifies regular shmem inodes, including those used by
memfds and ordinary tmpfs files, independently of wrapper file operations.

Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/shmem_fs.h | 6 ++++++
 mm/memfd.c               | 8 +++++---
 mm/memfd_luo.c           | 2 +-
 mm/shmem.c               | 5 +++++
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index a7c7a96a7cbf..4996420cfe60 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -117,8 +117,14 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
+bool inode_is_shmem(const struct inode *inode);
 bool shmem_mapping(const struct address_space *mapping);
 #else
+static inline bool inode_is_shmem(const struct inode *inode)
+{
+	return false;
+}
+
 static inline bool shmem_mapping(const struct address_space *mapping)
 {
 	return false;
diff --git a/mm/memfd.c b/mm/memfd.c
index 0f6fff004f5e..507c00ce0fda 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -211,12 +211,14 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 
 static unsigned int *memfd_file_seals_ptr(struct file *file)
 {
-	if (shmem_file(file))
-		return &SHMEM_I(file_inode(file))->seals;
+	struct inode *inode = file_inode(file);
+
+	if (inode_is_shmem(inode))
+		return &SHMEM_I(inode)->seals;
 
 #ifdef CONFIG_HUGETLBFS
 	if (is_file_hugepages(file))
-		return &HUGETLBFS_I(file_inode(file))->seals;
+		return &HUGETLBFS_I(inode)->seals;
 #endif
 
 	return NULL;
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 6b68220275eb..adaab98c8b63 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -581,7 +581,7 @@ static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
 {
 	struct inode *inode = file_inode(file);
 
-	return shmem_file(file) && !inode->i_nlink;
+	return inode_is_shmem(inode) && !inode->i_nlink;
 }
 
 static unsigned long memfd_luo_get_id(struct file *file)
diff --git a/mm/shmem.c b/mm/shmem.c
index af21a89abb0f..0ca5b7f7a517 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -275,6 +275,11 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool inode_is_shmem(const struct inode *inode)
+{
+	return inode->i_fop == &shmem_file_operations;
+}
+
 bool shmem_mapping(const struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;

-- 
2.43.0


