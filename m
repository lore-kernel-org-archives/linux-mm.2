Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B852FF30938
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4026B0093; Thu,  5 Mar 2026 05:50:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BD86B0095; Thu,  5 Mar 2026 05:50:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA1B6B0096; Thu,  5 Mar 2026 05:50:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 063256B0093
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:50:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91BED1408AE
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:45 +0000 (UTC)
X-FDA: 84511691250.15.60F71CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CD43D14000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnwnEQWp;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRQsrGjKXJR+5Wxo/0yAY1jeVCtiya9R7M4weUno1fQ=;
	b=sRiFQ8ufuTswbIUE9cgkAOQ62iXGW+9L4WjjarslrQoydHBI3/2nZw8Z+WkgTo95EWQ2aC
	u0yAabKxVwj6xYuNTpTxwTyMGCogV1EMAycrfZYS/3MYfgtW4KomqhQa3G4+wouX1k5Cy7
	w2EUZRKa1+3nhuIUd7y6IPXIInBANZE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnwnEQWp;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707844; a=rsa-sha256;
	cv=none;
	b=YW0q0nccblcggLzCe8EhyadOn3Xw37MO/+egzGcm0LSE//jS1Xvf2HAaFIsLfC7GmFoTzs
	bz3ecM2goO/AnyOiR3/1hxZJ+lgcq/wixPQMe5hfoxU5y0ldBbUcfCWWF+AE+LmFwgbt7m
	ET6dzXLIU1Hug5QbHv0sturuy9JmxUo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8632445ED;
	Thu,  5 Mar 2026 10:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EE8C19422;
	Thu,  5 Mar 2026 10:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707842;
	bh=K6atPXEwAz6pCpNgSjUNbutgg0Ze42UtzX9vGX/lf1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnwnEQWppRWj2X12TGMNPtDnaTYkVoE6SscxZf2XjuEV7EAMd5hPqHKmJjNb0couT
	 4Yr/gp9nN20VjAigjL3TT+oUbgvsXjg7/Ngchr1ZaD54JKZbRZ73qB38gEujixGeGv
	 GINuPfK8VIIcOs7b9HhLhT6ob1XPKTe868CSOX9LzAaUFCygQtAA6pK9T2qM+SKukc
	 lwmvOrm2Me7Xdn4E6B0XZtJszykq6mOYjj2lfsdMujilXsAJrPXpnpfI0518yH9B9C
	 7R1lexJePjT6Xn446TcwX5w5HCUlDQBBguymYuFcXM2YbOz5DUroMVLiDxaAhKV0Ch
	 kEWuHUjWY/9mw==
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
Subject: [PATCH 4/6] mm: reintroduce vma_flags_test() as a singular flag test
Date: Thu,  5 Mar 2026 10:50:17 +0000
Message-ID: <f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: brx1i8kamsuiuzzcdmxbw3ur7noueoa5
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: CD43D14000E
X-HE-Tag: 1772707843-591860
X-HE-Meta: U2FsdGVkX1+5rp3pvNLkQVOiEE87wZbb7cycjU5kVCAp47Ql0h4zg6Xefd71FHFgsl59xJiK5qIWlsOkm6GhNaRQAFOjQtJN0hr38kdSKf1lx3VKmxduip8LTuL1LLyPJ49FENd0s5v9Lss8LY9NDMPRV+UYzb6LQM+8ImQSXw6H7GH+2E3cCeOLFctRKmfPAU3zYs3rAWMpITRYNpvkpX6x8sNs3oKvgmnaLnzfguTd2/JBAycNRDaYONW7+Jo+B/oZiD5g6Dpf/9yCVJT/V3UmE4dY17BRV6VXJrG6aRfs/39j1qsAbIjyZL+S2dQ2Z+Nlg4Ttwsg+6oDm0MBeY0M5KTcuCoTBW7SUzM7xZpll5+p6vqvrp/1r+kdeSq0MkwzU5m4E+OVGIfbLQOtTo9+9kpyO2iZ3ofs0vGuhtItaEkyjtv3KhQDz06k/QRm4rNsr+fShJU7/nHtSSH7+yLmWqPq4BcJ2jsgnYdubuJ3AMjWEgJQoi1dO0SzY1bthbdARJ4Yurd1kO7XLLtX89qEOn9k4CxUmfFEMtS5R4bIIHse0GMG0w7y9Af0umRrkEjBJmACwVtAJjVEbJ+DtL9j5BBjgAIXiRxNRbpSs7m5zRL6MNOxH02yj5DIcPxo2DK4qr/Qz4F7Wkv6aCL2g7N7pvbd7uvybD3TvG5F3Pyx1lDzeC01PRKkO4yP3T6lp71HU7jhgzLJBPnL6T/yuDKXhRm+zuJY5X+iPbhKwJkdxq3JVDhKadt1P91a5dGaqfU81z63s7yLNEfOO0QcmeBjdSbfPHJHv26I9HPYUIYR09w2FiblcQgJYLkk9DkizH6zetDEu8z49xIf9gRZgNTuIWYj2hVQl9Yur2NfXxLrPVSQ85GdWtHNLkkx+/47xZlvN7BWQLJe6Nx99Q+eLW01qqgY9pR5yWkQmt0kS6Nt/LlT41hubo7YhI+QJheQPweKttpB5NdvqMMtCmHt
 kcaOpnDY
 QPAp/NUCdlITG0zud3QXS4cYyOq4o8L24/20/dnxQ/6yqbDP5bNoC0KgrpKuPCanROy5pYy3DNbPAEwS6NhGISprVcf4bcKvtJ2L9o4ZZ/V4HwPDnIFPEVrOWm2CvjyPUwfl+zzhizEGp49WcnjbljaSF0Lhz2mK8qetwKpBKG5OhqzrczHT9Z8yUu2ACD81e26HBAITdb5HgpmPVexsyYEucBDXafooRm/CNmIipgXUUfT4vSLiGx5eDAgLGRBKpLdBZR1Rqm5vnFdd7zeBrpvKerPvF66E/reTB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we've now renamed vma_flags_test() to vma_flags_test_any() to be very
clear as to what we are in fact testing, we now have the opportunity to
bring vma_flags_test() back, but for explicitly testing a single VMA flag.

This is useful, as often flag tests are against a single flag, and
vma_flags_test_any(flags, VMA_READ_BIT) reads oddly and potentially causes
confusion.

We use sparse to enforce that users won't accidentally pass vm_flags_t to
this function without it being flagged so this should make it harder to get
this wrong.

Of course, passing vma_flags_t to the function is impossible, as it is a
struct.

Also update the VMA tests to reflect this change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 17 +++++++++++++++--
 mm/hugetlb.c                    |  2 +-
 mm/shmem.c                      |  4 ++--
 tools/testing/vma/include/dup.h |  8 ++++++++
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 66b90de30bf6..5622d04c9ba9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1051,6 +1051,19 @@ static __always_inline vma_flags_t __mk_vma_flags(size_t count,
 	return flags;
 }
 
+/*
+ * Test whether a specific VMA flag is set, e.g.:
+ *
+ * if (vma_flags_test(flags, VMA_READ_BIT)) { ... }
+ */
+static __always_inline bool vma_flags_test(const vma_flags_t *flags,
+		vma_flag_t bit)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return test_bit((__force int)bit, bitmap);
+}
+
 /*
  * Helper macro which bitwise-or combines the specified input flags into a
  * vma_flags_t bitmap value. E.g.:
@@ -1957,8 +1970,8 @@ static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
 {
 	const vma_flags_t *flags = &desc->vma_flags;
 
-	return vma_flags_test_any(flags, VMA_MAYWRITE_BIT) &&
-		!vma_flags_test_any(flags, VMA_SHARED_BIT);
+	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
+		!vma_flags_test(flags, VMA_SHARED_BIT);
 }
 
 #ifndef CONFIG_MMU
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8286c5db2c12..bd9f3b2d2cb0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6591,7 +6591,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * attempt will be made for VM_NORESERVE to allocate a page
 	 * without using reserves
 	 */
-	if (vma_flags_test_any(&vma_flags, VMA_NORESERVE_BIT))
+	if (vma_flags_test(&vma_flags, VMA_NORESERVE_BIT))
 		return 0;
 
 	/*
diff --git a/mm/shmem.c b/mm/shmem.c
index 965a8908200b..5e7dcf5bc5d3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3086,7 +3086,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	spin_lock_init(&info->lock);
 	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
-	info->flags = vma_flags_test_any(&flags, VMA_NORESERVE_BIT)
+	info->flags = vma_flags_test(&flags, VMA_NORESERVE_BIT)
 		? SHMEM_F_NORESERVE : 0;
 	info->i_crtime = inode_get_mtime(inode);
 	info->fsflags = (dir == NULL) ? 0 :
@@ -5827,7 +5827,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
 				       unsigned int i_flags)
 {
 	const unsigned long shmem_flags =
-		vma_flags_test_any(&flags, VMA_NORESERVE_BIT) ? SHMEM_F_NORESERVE : 0;
+		vma_flags_test(&flags, VMA_NORESERVE_BIT) ? SHMEM_F_NORESERVE : 0;
 	struct inode *inode;
 	struct file *res;
 
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index ef6b9d963acc..630478f0d583 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -844,6 +844,14 @@ static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits);
 #define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
 					 (const vma_flag_t []){__VA_ARGS__})
 
+static __always_inline bool vma_flags_test(const vma_flags_t *flags,
+		vma_flag_t bit)
+{
+	const unsigned long *bitmap = flags->__vma_flags;
+
+	return test_bit((__force int)bit, bitmap);
+}
+
 static __always_inline bool vma_flags_test_any_mask(const vma_flags_t *flags,
 		vma_flags_t to_test)
 {
-- 
2.53.0


