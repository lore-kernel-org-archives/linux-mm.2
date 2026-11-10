Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953F960A2612
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=pUJkOKlE
Received: by kanga.kvack.org (Postfix)
	id B567D6B05BA; Mon,  9 Nov 2026 22:52:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7EB6B05BB; Mon,  9 Nov 2026 22:52:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF376B05BC; Mon,  9 Nov 2026 22:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 797F16B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:52:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE37B80889
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:52:19 +0000 (UTC)
X-FDA: 85417836798.05.98A21B4
Received: from out28-50.mail.aliyun.com (out28-50.mail.aliyun.com [115.124.28.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 293AB40005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:52:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=xiaopeng.com header.s=default header.b=pUJkOKlE;
	spf=pass (imf12.hostedemail.com: domain of fangxy@xiaopeng.com designates 115.124.28.50 as permitted sender) smtp.mailfrom=fangxy@xiaopeng.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794282738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LnJWD/eQmPATzcQ3ya5TLYOaFRBgryPz/dxqLK+YACk=;
	b=SbKgL6ZNDv5RBsXOxd879tDSoxF4gkB7RPpnS/xFDVq2JiVwFMl6ICHXlk3Dz3QsJztCpT
	EGpSuJIpZfCwNgVTYw01e6FxxSyilKjRtMwrL6hz2XPupNX4D75s2yWr4xncK87t5gEPrp
	LiJ7g5/UaP0ci6BdUrCbUL19TCGx9TU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794282738;
	b=tXFsQjnSWk0MLmIzl8yo0R6/nnQbFfb+6I2oXiwuyFKGbWdWhm5Tebns4NC3gPJEmD43Wy
	GT9peBDbze1G9Qzo0LhZuuHj++eScr1HTlE9BLhwIyUo+DuGy7hHdwOBYxWHfxD+FH/elf
	MqYVTXW/P+UGPlr2auiA8dcZViiQXds=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=xiaopeng.com header.s=default header.b=pUJkOKlE;
	spf=pass (imf12.hostedemail.com: domain of fangxy@xiaopeng.com designates 115.124.28.50 as permitted sender) smtp.mailfrom=fangxy@xiaopeng.com;
	dmarc=none
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1794282734; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=LnJWD/eQmPATzcQ3ya5TLYOaFRBgryPz/dxqLK+YACk=;
	b=pUJkOKlEEHicb4xkMIAwAHedg9LxgIbJbdpRfTrGqDMYXqQICNkr1uu5hA/+PL8buWir3etYTM50PIkM23rvDKBshNSUDpXS27izQVmCBlHV/MGw6PUIaI0RzWAKrU2f3MxlKTWq8MTxxj7SEwLarmCRzIH5reVy1+75imNko0A=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04436259|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0321415-0.00146777-0.966391;FP=14329174377433204728|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033040092104;MF=fangxy@xiaopeng.com;NM=1;PH=DS;RN=28;RT=28;SR=0;TI=SMTPD_---.k-eCFpa_1794282731;
Received: from localhost.localdomain(mailfrom:fangxy@xiaopeng.com fp:SMTPD_---.k-eCFpa_1794282731 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 11:52:13 +0800
From: Fang Xieyan <fangxy@xiaopeng.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Carlos Maiolino <cem@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Liu Chao <liuc63@xiaopeng.com>
Subject: [RFC PATCH 3/3] mm: enable filesystem page-cache large folios without THP
Date: Tue, 10 Nov 2026 11:52:05 +0800
Message-ID: <20261110035205.3036-4-fangxy@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110035205.3036-1-fangxy@xiaopeng.com>
References: <20261110035205.3036-1-fangxy@xiaopeng.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 293AB40005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: pqqr31aybaypzkaseghxzgkfztbjrkdb
X-Rspam-User: 
X-HE-Tag: 1794282736-658593
X-HE-Meta: U2FsdGVkX1/oLYWw/3+sgrmrX4LblYQX2PhC+ZHVooOBL0AIROeuxUWEGjX66iSGvKs1dNpnx+IbnD/66d4FEbW7ZimAi/UsCR1jBYM5cMUs3JoFbYqzELq6tXxbJ0aFnZlWex9pOcTt7L3ZARGn6J2Pq4RNvfOeRrmYTLrk5dSXhudru7d74Y1nCJxM2HtgGYNF/tRN4K2GtgFlidVuTOWByExH82YU5hu9zRh8InAF4cDLjh76p0WlUse/9Ir9bEnnF1qIxU3ZLbSnhH6YwVf2dRfmrc8I/hECDp6fA/jGDCH3JPo1VR5V4DU+ZgtvWW7Po6uYhQwmi7wBO1bb70GSD8OjmrDTU3o+EHI32qxx27HELRdM3mhKLgMBN9Vlx4vzS9FNHTcgE73alkzNSw89uhhzeAKWqp37Z2+K3by/yT9jkzYuj5N+O2edWyzLz9FjO/K/kUYC7ejCQUQs9K+rblH64aprGl7eH4H826V+gXCoxvKicFFQlC+8GQa0k0AYhBZk+bkaLLTP9iYxipNUVprr5AUBqEtXaKGZAR4cdkxJfC/g54Xce/qyIJsEdKBA7QvOkJS4lR0nsLQ6VP9r9AmBSeRVf4INXlI2w7LFiv17vUq9hKpqKXs0aQuGdfhFSobVtJHpxmWUAQGyo6e+8LO7Zv53zJyHiSHQrUsRXXFKV76WwLDzHa38W+njSE9k8e7MOAfi1/t6zG72yc+qAoofqP/WXjTrhoQ2oKN/Qrk8b46IL4WByUsEAl6J573yHU8w19w9jIJ2E4wOpKGMLsREQXVkYlpqBgWTCd0popV9vFVfMG9Vj0TfsI1+YFbClQxBazUZ+adsko66A4M2NaxOG4rzA22ESO2AvoAgQ46OeG2XGSZWMlzLaWh9bHKt/FhD3bnF3cwhTsrGsfaXlo/mcvNaGBlfQsaWs2+gvTvRadyiEPiFIXJDAukRA7npUPd2fg/KZZMTYD2
 Ji3CHkZq
 xgQAjMgn1llVPz6a/tgHHnWwklQ62p1DYjA6nc+VzGZb9CojZRQtcNIdqzcep5zMLE+z60+1kUe2K5W+hj8GX6dqlBEAHpNlzQeDf8DFgifcDRDMAN5MaNMpzEZncX0GUM6zSbjcS8ZsHoKiIr5lQ65BSlpAEdY9/fToSP63xOP9SLJhIh65jkaPuWsZoXLYXmBAEyrlE88F+K9RhuM5vTjI+biQYzL9LFp5A4OZjk8ZAuY43XOERkdDYtyJ55yF1yTz8bCG/GRk9elRTJc6xgerlRJt+UYRG7w0U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ten filesystems already opt in to file-backed large folios by calling
mapping_set_large_folios() or mapping_set_folio_order_range() from their
inode setup, unconditionally.  Every accessor that reports those orders
is nevertheless compiled out when CONFIG_TRANSPARENT_HUGEPAGE is
disabled, so the opt-in silently has no effect today.

Gate the page cache order accessors on CONFIG_LARGE_FOLIO in addition to
CONFIG_TRANSPARENT_HUGEPAGE.  Both conditions are still spelled out even
though CONFIG_LARGE_FOLIO defaults to y when TRANSPARENT_HUGEPAGE is
enabled, so that file-backed large folios do not silently disappear if
that default is ever relaxed.

PREFERRED_MAX_PAGECACHE_ORDER is left as it is.  Deriving it from
CONFIG_PGTABLE_HAS_HUGE_LEAVES would let HUGETLB_PAGE raise the ceiling
on its own, to HPAGE_PMD_ORDER capped by MAX_XAS_ORDER.  On arm64 with
64K base pages that works out to order 11, a 128M folio, eight times
what an LF-only build advertises today; the figure is arithmetic, not a
measurement.  Without THP such folios cannot be PMD-mapped, so keeping
the existing order-8 limit avoids substantially increasing the maximum
page-cache allocation size without an established use case.

CONFIG_LARGE_FOLIO no longer only builds the split machinery, so its
Kconfig help text is updated to match.  The default also carries a
comment recording why THP must keep pulling this option in:
mm/folio_split.o is built from CONFIG_LARGE_FOLIO, while huge_memory.o,
built for THP, calls into it.  XFS also gates mounting
block sizes larger than the page size on
mapping_max_folio_size_supported(), which means large-block-size XFS
cannot be mounted at all when CONFIG_LARGE_FOLIO is disabled; the
rejection now points at the missing option instead of only reporting the
block size as unsupported.

shmem keeps its THP dependency.  shmem_alloc_and_add_folio() forces
orders to zero without THP, so the mapping is only opened large-folio
capable when CONFIG_TRANSPARENT_HUGEPAGE is enabled.  Advertising the
larger order while allocating order 0 would not be cosmetic:
generic_perform_write() sizes its write chunk from
mapping_max_folio_size() and passes that length to ->write_begin()
before clamping it to folio_size(), while shmem_write_begin() rejects
pos + len > i_size outright for F_SEAL_GROW.  A cross-EOF write would
then fail as a whole instead of being partially satisfied up to i_size.
THP=y kernels already behave that way; the point is not to spread that
behaviour to a configuration which gains no large folios from it.
Enabling shmem's large folios -- allocation, swap and split alike -- is
left to a separate series.

The stale comment on mapping_large_folio_support() is updated to match:
large folios are now gated on CONFIG_LARGE_FOLIO rather than on THP, and
CONFIG_LARGE_FOLIO is a default rather than a select from THP.

With CONFIG_TRANSPARENT_HUGEPAGE enabled the generated code is unchanged.
Without it, file-backed large folios become reachable for the first time.

Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
---
 fs/xfs/xfs_super.c      |  2 ++
 include/linux/pagemap.h | 17 +++++++++++------
 mm/Kconfig              | 15 +++++++++++----
 mm/shmem.c              | 11 ++++++++++-
 4 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa..29548faec 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1864,6 +1864,8 @@ xfs_fs_fill_super(
 			xfs_warn(mp,
 "block size (%u bytes) not supported; Only block size (%zu) or less is supported",
 				mp->m_sb.sb_blocksize, max_folio_size);
+			if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
+				xfs_warn(mp, "CONFIG_LARGE_FOLIO is not set");
 			error = -ENOSYS;
 			goto out_free_sb;
 		}
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a37..2102733c1 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -393,7 +393,8 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  */
 static inline size_t mapping_max_folio_size_supported(void)
 {
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
+	    IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 1U << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
 	return PAGE_SIZE;
 }
@@ -418,7 +419,8 @@ static inline void mapping_set_folio_order_range(struct address_space *mapping,
 						 unsigned int min,
 						 unsigned int max)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return;
 
 	if (min > MAX_PAGECACHE_ORDER)
@@ -459,7 +461,8 @@ static inline void mapping_set_large_folios(struct address_space *mapping)
 static inline unsigned int
 mapping_max_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MAX_MASK) >> AS_FOLIO_ORDER_MAX;
 }
@@ -467,7 +470,8 @@ mapping_max_folio_order(const struct address_space *mapping)
 static inline unsigned int
 mapping_min_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
 }
@@ -500,8 +504,9 @@ static inline pgoff_t mapping_align_index(const struct address_space *mapping,
 }
 
 /*
- * Large folio support currently depends on THP.  These dependencies are
- * being worked on but are not yet fixed.
+ * Large folio support is opt-in per mapping and requires CONFIG_LARGE_FOLIO.
+ * It does not depend on THP; CONFIG_LARGE_FOLIO defaults to y when
+ * CONFIG_TRANSPARENT_HUGEPAGE is enabled.
  */
 static inline bool mapping_large_folio_support(const struct address_space *mapping)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index 9f97ad698..7bbed71af 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -831,13 +831,20 @@ config LARGE_FOLIO
 	bool "Large folio support for the page cache (without THP)" if !TRANSPARENT_HUGEPAGE
 	depends on MMU
 	select XARRAY_MULTI
+	# Keep LARGE_FOLIO enabled whenever THP is enabled:
+	# huge_memory.o is built for TRANSPARENT_HUGEPAGE and calls into
+	# folio_split.o, which is built for LARGE_FOLIO.
 	default y if TRANSPARENT_HUGEPAGE
 	default n
 	help
-	  Build the folio split implementation for page-cache large folios
-	  even when transparent hugepages are disabled.  Transparent
-	  hugepages imply this option; this option alone does not enable
-	  large folio allocation, it only makes splitting them possible.
+	  Enable page-cache large folios even when transparent hugepages
+	  are disabled.  This option defaults to y when transparent
+	  hugepages are enabled.
+
+	  With this option enabled, filesystems that opt in per mapping get
+	  large folios in the page cache, and those folios can be split.
+	  Without it, page-cache folios stay order-0 even when a filesystem
+	  asks for a larger order.
 
 menuconfig TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
diff --git a/mm/shmem.c b/mm/shmem.c
index 4686875a3..399c8c9f1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3327,7 +3327,16 @@ static struct inode *__shmem_get_inode(const struct mnt_idmap *idmap,
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
-	mapping_set_large_folios(inode->i_mapping);
+	/*
+	 * shmem large folios currently depend on THP:
+	 * shmem_alloc_and_add_folio() forces order 0 without it, and
+	 * advertising a larger mapping size makes
+	 * generic_perform_write() pass a length that shmem_write_begin()
+	 * rejects wholesale for F_SEAL_GROW before the folio size is
+	 * known.
+	 */
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
 	default:
-- 
2.50.1


