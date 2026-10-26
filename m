Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7A5606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l9TWTt+1
Received: by kanga.kvack.org (Postfix)
	id 55C9F6B05B9; Mon, 26 Oct 2026 19:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C276B05BA; Mon, 26 Oct 2026 19:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FBFC6B05BB; Mon, 26 Oct 2026 19:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 126616B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:18:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A555C088C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:18:52 +0000 (UTC)
X-FDA: 85366344504.05.B5EA8D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D419FC0005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:18:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l9TWTt+1;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kqvh3QHgES+LSiM08s7U/NmvKIkWtzCHiKPGrHCdA4=;
	b=P2SJ2eN+aG6Hgy87QLwbajMnjYvpp3lfWjVhNxrykonxahJk6SjahlUtl+7Pmj0ijdDezD
	ZK+cL9Pvcs7CVKti4VMekFtBvNcWaOsIDuuGUUidOVmN8gF3dKdTJSE6QDG1AnNb7JaNKO
	AquDRgJdOh6HOLGYNZsew0mKbcLEFho=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l9TWTt+1;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056730;
	b=VTdU5ORKQg71kqNyjCd6no1WXyxDv5F2siqx8jGdnt0p7Hf72w87/uk9vNDXfmua6yh/pA
	IZhGncbY1vXG1R1XVpyrnhsRR6mqOkDiGIosI86QGWBeOYVdDgCu998QrTb3j1EKcDL4rf
	xcPgs7cUOtdmBUAiRXD4zJHZ1duPLp4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AA7960232;
	Mon, 26 Oct 2026 23:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DE81F01828;
	Mon, 26 Oct 2026 23:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056730;
	bh=1kqvh3QHgES+LSiM08s7U/NmvKIkWtzCHiKPGrHCdA4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l9TWTt+1L+96E8I0lJ9iMCkUJIkaJ1DluUoi903qeANK9k6EbKcVlyv97+o5GezYH
	 DLbgE5f37O/Zzf4gABcw0E91GGpbNhYQ2bcjgsFGFMxtOH8rGEPiXqQ6IdoN/afDgv
	 d0U7ZYskU93ZiARZJDopac13HIKc/OTZeIBLlxhDg/d1nbW7Xgq3rnOjhJjTaZAtXc
	 OJ5JwrO3qLcWFvB2dMJicIRahK1xbEhf2+G+OHRE2yEWbp2B4NWxfcIDJ7cyQyn9lJ
	 RcH072HgQhLHMSDRpqqlOFWLLRiTzdYY4XiqIXCtLe0GTIn+Tr52qXvk6mvuBIkcck
	 fZbu26U8SUFXQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:23 +0100
Subject: [PATCH 03/46] mm/memfd: check for real shmem inodes before
 accessing shmem state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3445; i=david@kernel.org;
 h=from:subject:message-id; bh=72FnFCPclMGQ2RVEjfTEZip7yxNcpfMMwjBpW8uk9h8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu3598IHG65lsVvXN7Xh/+NOGzlVBY7sGdTtrcVexbt
 0vN3xRZ3VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEbnIxMqw+svrQr1oPlhsX
 rM+erHVStVc64N6aKaOqvXX5p761hzUY/hdIXvknGLTOdA1flFehtk0aT5N8nNyinpZ3zf/vbl9
 0lREA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D419FC0005
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: hrode719un5qe64z8sj68beek64bidjg
X-HE-Tag: 1793056730-241665
X-HE-Meta: U2FsdGVkX18WdlOCgaLm6rbH9mrZb3Doo/pbg9dACr8EcvFDaOVUsw/pENeKIilXQaz56XGHhPVuPzacyA55jUrNhEYC6mlGZg/IEyzWXI2+inYtQC/DT2O1Sls3e6/PTPOujf/UXyXJObexvsbvU8+KgxPYaNYGk5rFcMEVjOhTUqaooTQwS71h04ja0yMh27J3hwgWUbk6s+xM/qPkcpFxnl/swUubw1evcxPrvbAZbCYB1zA9BBLWT0/wu37lHwDg7MkY236So1AtaodT3KD8qAjyidG7i4HGWlxy2jsjhTNyRF29lHAJYwDJaNFHlul1zfyhEfHDnwhRezEMiTf8FXPXbhI05suWPqjbDl+tStT6axtBQOkcIwxtYUtow2U7fnR4c5PXFShtVTki/e6j2j0fgrPdiFxtq/+BGQn33wWH+Xe2WA959sSEVE9+lJVM43bA/V/XsOIM249siKklTXlZCMlelHGw2Hiyz05osGNzukbVa6KmOq1ik1f6Ims8y+rIrddP6m8cEwyQBQzqj29FknpOCebPnBqzPf9yo6dp3upksMIoereY0Msc3O1rsC0FweujcJA2/TWoMy6LweypdfX/94cnjO3Ge+hw5i02wK2Uyj2mRel0jh7NKkpVQdWwzi1/Zy7mgYupn4AcfNDzjpqrUX0mPd8WCr9Vuwc0mILsjcbjRbCR5twD/rxjKDOT86VXfDOLBfgc7TsYU+xjvVdASSLtiosNNdSx3ws/mz6JRrdX5Z4pwjVIt5aL95JCIr7raw6YG2dtuT415NLIx8+Cvfma/G8qPXxWMuri40+gMayT6MP5rvUE5zsL8f6vImqxdS3S1CH5WKsma3i6OT0bNbBpkmcY4XPFOa91mdc/MqSnwjB+LiDKnD2GBZYQanK5pvyfMpFz+jVt9Fnpd7l1CtYzRXat82SR43cw7XZU2w+9Dc2YOHt/YooeowzVEcACh29jwk5
 gB74Uoqm
 1jKWWI9cs+1nQWNOX6MDAKIk/9XBMATIPLSNDMVUGpJ84Axljq4GY0lZ/0KR7hNPecWcCkKelxyGKOYB9T+ldStAAVjXWQYpo6WPDUaVQEfiK6IeZ8NsPMV0oHn4laAvjZri4Lxei3NF0fL2NjgZKQeJnTv5bTV7uxAxiMaiQ5BffyZNVeWWFoXOzE25F4xq/oupnTqAWAFOK2oNS/f4scSNgh3+gDBW88bsiluaS3MfC4wBIjhRqtZnlcSFqb0lRj27P49fNUeGWSa+3h5Ih9wP/66HQM84Hvh+FcwC1C/d83Wxdw2txn3t0aqTIccArWhAb
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/shmem_fs.h | 6 ++++++
 mm/memfd.c               | 8 +++++---
 mm/memfd_luo.c           | 2 +-
 mm/shmem.c               | 5 +++++
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index a7c7a96a7cbf9..2ceca7993e4f5 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -117,8 +117,14 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
+bool file_inode_is_shmem(const struct inode *inode);
 bool shmem_mapping(const struct address_space *mapping);
 #else
+static inline bool file_inode_is_shmem(const struct inode *inode)
+{
+	return false;
+}
+
 static inline bool shmem_mapping(const struct address_space *mapping)
 {
 	return false;
diff --git a/mm/memfd.c b/mm/memfd.c
index 0f6fff004f5e4..7d2da23157003 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -211,12 +211,14 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 
 static unsigned int *memfd_file_seals_ptr(struct file *file)
 {
-	if (shmem_file(file))
-		return &SHMEM_I(file_inode(file))->seals;
+	struct inode *inode = file_inode(file);
+
+	if (file_inode_is_shmem(inode))
+		return &SHMEM_I(inode)->seals;
 
 #ifdef CONFIG_HUGETLBFS
 	if (is_file_hugepages(file))
-		return &HUGETLBFS_I(file_inode(file))->seals;
+		return &HUGETLBFS_I(inode)->seals;
 #endif
 
 	return NULL;
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f9..c0811407ce397 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -582,7 +582,7 @@ static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
 {
 	struct inode *inode = file_inode(file);
 
-	return shmem_file(file) && !inode->i_nlink;
+	return file_inode_is_shmem(inode) && !inode->i_nlink;
 }
 
 static unsigned long memfd_luo_get_id(struct file *file)
diff --git a/mm/shmem.c b/mm/shmem.c
index fadf23f9e21ed..0d41aac125df9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -275,6 +275,11 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool file_inode_is_shmem(const struct inode *inode)
+{
+	return inode->i_fop == &shmem_file_operations;
+}
+
 bool shmem_mapping(const struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;

-- 
2.43.0


