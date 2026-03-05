Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF668F30938
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291986B0095; Thu,  5 Mar 2026 05:50:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233406B0096; Thu,  5 Mar 2026 05:50:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114786B0098; Thu,  5 Mar 2026 05:50:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 027B06B0095
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:50:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C021A16052E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:48 +0000 (UTC)
X-FDA: 84511691376.11.369909B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E936D4000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUxLFGSw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+wUnOvqYR9kFB0tViuLrFruOjaXqW8h4W2NTTOqXcs=;
	b=aHoRi+d4zK5rLJH7LzDsvVDHlnQ01YVXoP4hnarUnq14ukQqyq7wRIpVt0kxe26T2PHYvf
	fBx5G75JOSUbeRBHQharqLGuCsW1dj4XrgoS8zxd34OUET8ur46oGEzRd8lYBiRq2JXvUF
	L1JL9oaOA4eDb6RPNYpS6mORkx7V51Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707847; a=rsa-sha256;
	cv=none;
	b=O8kBxX1EAvr9qY97vQ3iDFO45SWiZp5BvZIilMih+vucKWiaQ58QR1Z+awJPE8Bmb8Tdkr
	3WNFIVLLupHkMUrsAmARVnLRDuoHaR+DZxnvwHBZCLPameLdzcVOVMtHtm/jVoU2Q1X5Xn
	QOY9T/KYz5jVcLaLXIUsi7ZVjiKezuA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUxLFGSw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 208F444522;
	Thu,  5 Mar 2026 10:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7A0C2BCB4;
	Thu,  5 Mar 2026 10:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707846;
	bh=EK6fYEvH1wg5Fjr6ELYShGj5Cu5n2mWY5XPhO/+Nlxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUxLFGSwjcUn+c30j5c81RAPfXsVUUBDRry9ESKIK6yeaCjMkOjGYX/r9jyrIhx3d
	 MSDcAfBnydcuRaU4exr00z3uuBkYoayRS8E/jQbVSxkIxp+a+xN8CTbRZ0r92e3j8R
	 9QhQHyuJGh69jHlZi/X2kFiqNMdTa9CnYQtwGXxbo91txfjll27yeUHT8nVqEgg8KM
	 xithGz3kD1LrKxFUgiCKt1H2NlbK6vKfKqbW1k9+R98MDIOBcx6nSg008cr/jJwSCh
	 pSH00jsYh7zjNllJLU6pctKk01tbqn870dBj6bd2rMuYcw7E1yb5mGQOJi1i0tQj2q
	 7lPLYYy3OfPVg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-mm@kvack.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/6] mm: reintroduce vma_desc_test() as a singular flag test
Date: Thu,  5 Mar 2026 10:50:18 +0000
Message-ID: <3a65ca23defb05060333f0586428fe279a484564.1772704455.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E936D4000B
X-Stat-Signature: keicdr48buqgk1q53q8zz4s8o9dh9q4e
X-Rspam-User: 
X-HE-Tag: 1772707846-351709
X-HE-Meta: U2FsdGVkX18BQ2SBy6NI26vsgWG+dFXXzsO1CCRyxonB+NBMuKiIJ550tvXvbz2ERQHYfJozGuxbu+D5TM4t0lh0ltFy1D4Kx5V1zzGMb8irnQRUU0IkS3u417lA6qi61rqUaa8n9hHkw4ZyIMtCTF/loqqfDyBuvj2FZuRQ4XQl253gZlw5Tz5qy6H6NcvJuV94VRyO/6jpCOYbB8el7DcEvgRYROkLgBpnN1fOSE2CAa4oTJpRJneP138ktR5HCXapGchSkyJBr9rVzdrvxY3o+8zZZxdbQgUII4ypVhNhOLZTx9e4jJm7lkhtC2jJnvhtDJzumcxZbOl1phQIfSBqYr/686R5f27iz1M5IM4v4ulhgVcTP+p32ijNc83TkTmQ9vpEpq8XU7+6vXsemfG2r3BdOKomsFhf+mn6h/OBS0oXa+XuJhe2T4dG8SLutk/AY1BGEYXXmcWwC8mIacKwXpfd0u6JqHh/NPP2ydduCDISKjEd7KsgRTlqAtwvH+OYh2Ye5qepoi+tl+YkxNw0wnRXSC3oErdtOU9f16GWwARqoB7h6tndO7IML0JpxOc9MfY1TQPGugUJh2TkHsI5hDnboJIIU4J7MyuWXlqFz3QA7eNWgNELVJvKcRr27otIBR4q7xhs8OZcWkHz9HehTNeUDPgqIe138LYwtd1bsNVmKl52YaLMvYxjVt/bTykmJMLne86U+Tdl1vfZJGwprIHSy8UcY7GAw+ACbBI5ZThlrHgsJM/8hnNY2dLDC7tjpwCz9OCyJJQzfBnIRyagc70JI4bnCn6HoCIzWQ2dDldNHyM+8cEttoenKygLIpk+4Xhf1I4TvAuXY5uf4dzvAkXqlcvyed7C6b8NA8KDw2KVOcwOLRwLJpCkauTgT8LVfH+69/ypcS7ViP5M6yqE55ZCqXbF6GrK5kRWWj3SzszF7QYuuoy2jp0u5ldYb6ZJiEAMcL6Wh6fJr/M
 vMqS6MrF
 wOY1X7ZTtbr59J3H50JrJDGshzvmQKa+h+s6KUDDqxnEX1THaYZqJCIi2wN2kzy41dk7na/VAUUjngD5BKpccKJ+zVmtuUvnj+0Wl0CWq/OR4J9E3s30SKjGLXh1ELJFMwCNs4KZIWcidEq8UxiDqYqknTxRt62ShSBxs2CXl4yy/w+5u3Fv21Fi883vz/FBmuwolacawwQnQhl5jQuX37orfTA3k7yPLn6NxWeWPDccqRvoTe9OZycCggfoUZb6SnZwqEFBkstMie34E5SpYYasnNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to vma_flags_test(), we have previously renamed vma_desc_test() to
vma_desc_test_any(). Now that is in place, we can reintroduce
vma_desc_test() to explicitly check for a single VMA flag.

As with vma_flags_test(), this is useful as often flag tests are against a
single flag, and vma_desc_test_any(flags, VMA_READ_BIT) reads oddly and
potentially causes confusion.

As with vma_flags_test() a combination of sparse and vma_flags_t being a
struct means that users cannot misuse this function without it getting
flagged.

Also update the VMA tests to reflect this change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/char/mem.c              |  2 +-
 fs/hugetlbfs/inode.c            |  2 +-
 fs/ntfs3/file.c                 |  2 +-
 fs/resctrl/pseudo_lock.c        |  2 +-
 include/linux/dax.h             |  4 ++--
 include/linux/mm.h              | 11 +++++++++++
 mm/hugetlb.c                    | 12 ++++++------
 tools/testing/vma/include/dup.h |  6 ++++++
 8 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 5118787d0954..5fd421e48c04 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -520,7 +520,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
 #ifndef CONFIG_MMU
 	return -ENOSYS;
 #endif
-	if (vma_desc_test_any(desc, VMA_SHARED_BIT))
+	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
 	desc->action.success_hook = mmap_zero_private_success;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 079ffaaf1f6c..cd6b22f6e2b1 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -164,7 +164,7 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
 		goto out;
 
 	ret = 0;
-	if (vma_desc_test_any(desc, VMA_WRITE_BIT) && inode->i_size < len)
+	if (vma_desc_test(desc, VMA_WRITE_BIT) && inode->i_size < len)
 		i_size_write(inode, len);
 out:
 	inode_unlock(inode);
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index c5e2181f9f02..fbdfaf989a31 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -276,7 +276,7 @@ static int ntfs_file_mmap_prepare(struct vm_area_desc *desc)
 	struct file *file = desc->file;
 	struct inode *inode = file_inode(file);
 	struct ntfs_inode *ni = ntfs_i(inode);
-	const bool rw = vma_desc_test_any(desc, VMA_WRITE_BIT);
+	const bool rw = vma_desc_test(desc, VMA_WRITE_BIT);
 	int err;
 
 	/* Avoid any operation if inode is bad. */
diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
index 79a006c6f26c..d1cb0986006e 100644
--- a/fs/resctrl/pseudo_lock.c
+++ b/fs/resctrl/pseudo_lock.c
@@ -1044,7 +1044,7 @@ static int pseudo_lock_dev_mmap_prepare(struct vm_area_desc *desc)
 	 * Ensure changes are carried directly to the memory being mapped,
 	 * do not allow copy-on-write mapping.
 	 */
-	if (!vma_desc_test_any(desc, VMA_SHARED_BIT)) {
+	if (!vma_desc_test(desc, VMA_SHARED_BIT)) {
 		mutex_unlock(&rdtgroup_mutex);
 		return -EINVAL;
 	}
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 535019001577..10a7cc79aea5 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -69,7 +69,7 @@ static inline bool daxdev_mapping_supported(const struct vm_area_desc *desc,
 					    const struct inode *inode,
 					    struct dax_device *dax_dev)
 {
-	if (!vma_desc_test_any(desc, VMA_SYNC_BIT))
+	if (!vma_desc_test(desc, VMA_SYNC_BIT))
 		return true;
 	if (!IS_DAX(inode))
 		return false;
@@ -115,7 +115,7 @@ static inline bool daxdev_mapping_supported(const struct vm_area_desc *desc,
 					    const struct inode *inode,
 					    struct dax_device *dax_dev)
 {
-	return !vma_desc_test_any(desc, VMA_SYNC_BIT);
+	return !vma_desc_test(desc, VMA_SYNC_BIT);
 }
 static inline size_t dax_recovery_write(struct dax_device *dax_dev,
 		pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5622d04c9ba9..9bdfa1a91552 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1193,6 +1193,17 @@ static inline void vma_set_flags_mask(struct vm_area_struct *vma,
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+/*
+ * Test whether a specific VMA flag is set in a VMA descriptor, e.g.:
+ *
+ * if (vma_desc_test(desc, VMA_READ_BIT)) { ... }
+ */
+static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
+		vma_flag_t bit)
+{
+	return vma_flags_test(&desc->vma_flags, bit);
+}
+
 /* Helper to test any VMA flags in a VMA descriptor. */
 static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 		vma_flags_t flags)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bd9f3b2d2cb0..8cde83fb8a5a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1194,7 +1194,7 @@ static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long flags)
 static void set_vma_desc_resv_map(struct vm_area_desc *desc, struct resv_map *map)
 {
 	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
-	VM_WARN_ON_ONCE(vma_desc_test_any(desc, VMA_MAYSHARE_BIT));
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_MAYSHARE_BIT));
 
 	desc->private_data = map;
 }
@@ -1202,7 +1202,7 @@ static void set_vma_desc_resv_map(struct vm_area_desc *desc, struct resv_map *ma
 static void set_vma_desc_resv_flags(struct vm_area_desc *desc, unsigned long flags)
 {
 	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
-	VM_WARN_ON_ONCE(vma_desc_test_any(desc, VMA_MAYSHARE_BIT));
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_MAYSHARE_BIT));
 
 	desc->private_data = (void *)((unsigned long)desc->private_data | flags);
 }
@@ -6600,7 +6600,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * to reserve the full area even if read-only as mprotect() may be
 	 * called to make the mapping read-write. Assume !desc is a shm mapping
 	 */
-	if (!desc || vma_desc_test_any(desc, VMA_MAYSHARE_BIT)) {
+	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
 		/*
 		 * resv_map can not be NULL as hugetlb_reserve_pages is only
 		 * called for inodes for which resv_maps were created (see
@@ -6634,7 +6634,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	if (err < 0)
 		goto out_err;
 
-	if (desc && !vma_desc_test_any(desc, VMA_MAYSHARE_BIT) && h_cg) {
+	if (desc && !vma_desc_test(desc, VMA_MAYSHARE_BIT) && h_cg) {
 		/* For private mappings, the hugetlb_cgroup uncharge info hangs
 		 * of the resv_map.
 		 */
@@ -6671,7 +6671,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * consumed reservations are stored in the map. Hence, nothing
 	 * else has to be done for private mappings here
 	 */
-	if (!desc || vma_desc_test_any(desc, VMA_MAYSHARE_BIT)) {
+	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
@@ -6735,7 +6735,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
 out_err:
-	if (!desc || vma_desc_test_any(desc, VMA_MAYSHARE_BIT))
+	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT))
 		/* Only call region_abort if the region_chg succeeded but the
 		 * region_add failed or didn't run.
 		 */
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 630478f0d583..5eb313beb43d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -922,6 +922,12 @@ static inline void vma_set_flags_mask(struct vm_area_struct *vma,
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
+		vma_flag_t bit)
+{
+	return vma_flags_test(&desc->vma_flags, bit);
+}
+
 static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 					    vma_flags_t flags)
 {
-- 
2.53.0


