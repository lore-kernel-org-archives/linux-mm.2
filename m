Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F9E606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xjuuvzf9
Received: by kanga.kvack.org (Postfix)
	id 4FF0C6B05B7; Sat, 31 Oct 2026 05:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6876B05B8; Sat, 31 Oct 2026 05:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4FA6B05B9; Sat, 31 Oct 2026 05:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 174C96B05B7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:41:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95F78C094D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:41:03 +0000 (UTC)
X-FDA: 85382427606.19.87C3911
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B87FCC0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:41:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xjuuvzf9;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/UbZ2DKEnQojQSELBFGnS0lcpZB7Ro6yxedX89z52s=;
	b=aSbRRzKl7lPn4ka2O7+zdmkN8oOYdt0PjN4tAKCnBD1jkR9razza7V1oGkTIIy/q/w2ztD
	M2HeT8y/Ir1gHDuIikeG3hdD1pIVjP3ejS0KRupDwBa6pRJHECmiDA1Jqiw5MAnri/xlP/
	b/c6kSasjYNtiFEZpHOIimTM6K129z4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439661;
	b=s6Lx/l/UJJe1l1Act9An9Ltyz0fxD3hmMqEQLp+QaTPWJYzDDFOCwDnfj2QQeZqasXRcur
	eTwo1QUaAUgqPH5IHsk3C+nq5CjmIbSISs6RtOvFj0OwkrUCBueZNmtkmhkZNRRyTnkuTd
	gEwPaICeRUc9tTEXVuSYlgMBep5nf70=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xjuuvzf9;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F23DC435B7;
	Sat, 31 Oct 2026 09:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDB61F000C1;
	Sat, 31 Oct 2026 09:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439660;
	bh=N/UbZ2DKEnQojQSELBFGnS0lcpZB7Ro6yxedX89z52s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Xjuuvzf9wuLMCySY6IdeNSdaTJ2k4cmFetgxtxYQ56YkxXU/QKPSft7eTxxxhEvPx
	 h3bLiQgIiAgEDU6jd7zQkjZZR59AktCDf9D3EsyMCAU2pPH7YBmiH8F90lBDCLylGw
	 4qOV9TbiNgXVH4TQ/L5eN0UL5u42Rnr/3BeMbJxAnndyh1Mvaiszu5ZZvtfQ/UsITg
	 8fMpWAb0srINu2AcXKp7C9J5bxYK32NhnbiumWhDoqenMmVWz3qtrUKG11MrymKh+r
	 cCY1IRWjCta06tdjbBBvjHeXTuhxRU1FKB5a0eg3KogPsKSrj0wxtO5XG0pTSkK+AN
	 2dPToiEUSGgTA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:32 +0100
Subject: [PATCH v3 03/47] mm/shmem: make shmem_file() check the file's
 inode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-3-d6437171ecc3@kernel.org>
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
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3990; i=david@kernel.org;
 h=from:subject:message-id; bh=i8RbN8wIEh2nBD7/h47LWSYFQA3zQXy0uIRiZqeF/JI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk9dfvr237cbdI8eOSy4jP9gU/dDjZ0JD3/NcpZu8
 6qMC5hv31HKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBE4ssYGV4dP91s57bvP/Me
 RQXP4vMz+03T4kuPGXx4/H3+xMQouw8MfzgMu+PduC+dyy8+21m6acc5s/6YU8d3nbGZFv/Pp9J
 EngMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B87FCC0002
X-Stat-Signature: upcee4njgy4yrciw7xj49ygks9bogojm
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439661-393283
X-HE-Meta: U2FsdGVkX1/gXsqTu4bjDmLt+ymg0AvKSyoIIact4uZwHw7V/tQDukSDjQj0TPWcH9FsYSBH5GC2+1o9xc5KmW7sMJBW6MaPgsRzpEPF54QWxuYqEDR5GXLXVVdJZ5st60I+4Bk28FiG1EjgRAigqzk6Yo6DqHpd8QJpxFiPVIZEpdS3FLmvKzEpQrgySgmt0h74RmGhaf0u5Nx3uUXc8/ZoVG/PtFi7hAAHn4UEq35YDY9p0HgGTZt0RcC0ObQhwL4xJgS9KB+RCyr2rHCP7jLUFZY+sdvmXpUrjil/xANRxhv3hZd0mVFs03GRJj+gKXZl4CBy9+r6cESG2TslahW1oXbDowMsP0Iwn4ljVC00+7ZL5evwlFneOPiMejfV0XzdSSvHOe+dwgZxO2uSMz8Ss53wgJVhZX2DMKZ0ThRzrsKxzw8frnSBgiD//IyS652sEO+RglHBc129UfIVJqsYazFGWDSGdzFptATn7v1gi+HGfuABo1C4bYdsxC3DLexEda02VAhbJfV0HloSVq4OEYZcc4t4bscElIwlrykuOzyhbJuQCfLFs+whQeJ8tUntdW3sNETpPK8kjFZWDEnLovCKdOGTqg95rzxtf3EF23X1zwWLbly1x3/Rw3h1Vo8JWyIyoX/KWHyECZazNrz5hekvVkvduyCTPVOVUtEl6pFOl+qaGjeR/7HMWzCmBJO+VguaChHoOkp1OPEL4dJFYRurxF9rLSOtPLhuMqjHNgG56Z7qWZDuK0lX0dn2J2j3x9mINCBXJGqnPeio3fWjvAc0mKW2YEkUbcopAIGTEBmB0LRQifkrzhL4DH1jLP55xIonWAehB0tFbJCaJvi+6t2TUgdaILJo027/Aplj9ae8gR48cJ8NL1i7M6oRQUdgkrgbet3FD16YVZwfzlzmv+4j6R6ClpbIGC3tIymsSTgsarUex2Zu0HkF8lCJNpnSLGG8kIthFZ90FUx
 6CwA+b5E
 gBX3/k7qT78rinP2wCWuLbgnkJ1lXqX0pk/NFthGoJWagwaAGTqIXa4ZsRsF3vIpmpJ8GQuztqSdFgD0wqGg1+/fG+fvt0ZndhgBAdrOtE8+qSzdRrBiw6Vj5rGLNweeT+oz+RN028m5wT5wBVSWYSVPELKqIhO3c2lsNNClj+v/nqY3j6dXJgS8wTT8yYjipcbpQiCv6vPBGeOTzARyUa0oPlEM6F6Bntqvu14lzu9A2MrZuu66KgHhVGuiiK98Ujs4TVIemM2mr9pXCi942PPKFgCFHLTIlCC9q3YtMPl7RHJc8/kQg5UffFXLx0cyu9IwRx3sYLWIOfgjPUGdA96OmgOapK7iFbc5m2e2rD5Ye/NLcdqxko794GP7HI56ol4Bt/7ry6PcKgxdPVuORhhZ6XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_file() only checks if file->f_mapping is a shmem mapping. This
mapping can belong to another file, however, as with a Coda file backed
by a tmpfs container after mmap().

So it does not guarantee that the file inode is an actual shmem inode.

Seal handling and memfd preservation use this check before accessing
shmem inode state, so they can access an inode of the wrong type.

Let's make shmem_file() check the inode's file operations instead, to
identify shmem inodes reliably. This will identify regular shmem inodes,
including memfds and ordinary tmpfs files, independently of wrapper file
operations.

Use shmem_mapping() in collapse_file() instead to not change the behavior
of collapse_file(): it operates on the page cache and uses mapping->host
for shmem inode operations. Focusing on the file does not seem relevant.

Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/shmem_fs.h | 15 ++++++---------
 mm/khugepaged.c          |  2 +-
 mm/shmem.c               |  5 +++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index a7c7a96a7cbf9..f89b4b1511332 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -117,8 +117,14 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
+bool shmem_file(struct file *file);
 bool shmem_mapping(const struct address_space *mapping);
 #else
+static inline bool shmem_file(struct file *file)
+{
+	return false;
+}
+
 static inline bool shmem_mapping(const struct address_space *mapping)
 {
 	return false;
@@ -193,15 +199,6 @@ static inline struct page *shmem_read_mapping_page(
 					mapping_gfp_mask(mapping));
 }
 
-static inline bool shmem_file(struct file *file)
-{
-	if (!IS_ENABLED(CONFIG_SHMEM))
-		return false;
-	if (!file || !file->f_mapping)
-		return false;
-	return shmem_mapping(file->f_mapping);
-}
-
 /* Must be called with inode lock taken exclusive. */
 static inline void shmem_freeze(struct inode *inode, bool freeze)
 {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4b71d010b2aff..3a6f4b7b28453 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2230,6 +2230,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
+	const bool is_shmem = shmem_mapping(mapping);
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
 	unsigned long new_pfn = -1;
@@ -2238,7 +2239,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
-	bool is_shmem = shmem_file(file);
 
 	/*
 	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
diff --git a/mm/shmem.c b/mm/shmem.c
index af21a89abb0f6..421ba066995c5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -275,6 +275,11 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool shmem_file(struct file *file)
+{
+	return file && file_inode(file)->i_fop == &shmem_file_operations;
+}
+
 bool shmem_mapping(const struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;

-- 
2.43.0


