Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4755606A89C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Zvh+kPDw
Received: by kanga.kvack.org (Postfix)
	id CF6376B05B6; Sun, 15 Nov 2026 11:01:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE566B05B7; Sun, 15 Nov 2026 11:01:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97616B05B8; Sun, 15 Nov 2026 11:01:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 810146B05B6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:01:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04B61A8514
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:01:13 +0000 (UTC)
X-FDA: 85437817668.09.918989B
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf08.hostedemail.com (Postfix) with ESMTP id 08329160011
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:01:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Zvh+kPDw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3Rtf5aggKCDsgfXnfvXkdlldib.Zljifkru-jjhsXZh.lod@flex--jiaqiyan.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3Rtf5aggKCDsgfXnfvXkdlldib.Zljifkru-jjhsXZh.lod@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794758472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQNBN5n20nbzOeQbJMzo0/EVUvvdWpBCnk4LAdFuQrs=;
	b=qRfydJrmm5vccOigXK3eobmZDk9MklVCmDjFymihjvs8k+kXVkW288aCfCTVQA9n+rENVt
	ZRniIGvo0c3aUKzDaTX8/R7iHSFs9oPEmByLlhDVcVh2lVcv+BTEpO0zfNWXeD8cKp1SwZ
	KmjzJpDUd2KM9BsGIYLGLtpj3d8Wbjc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Zvh+kPDw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3Rtf5aggKCDsgfXnfvXkdlldib.Zljifkru-jjhsXZh.lod@flex--jiaqiyan.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3Rtf5aggKCDsgfXnfvXkdlldib.Zljifkru-jjhsXZh.lod@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794758472;
	b=8feCFmYFt4qpg7G4Pzm9XbxvXBd3fAovTK0lfmCb2DwZztu2Ee22HgDC0hYi6UJlH1fKCa
	lRGmADkrlJKDDHwYxLbiaHp6Uax4FD+d/alpE2AFyPi6DqMcyKpO2iQXlUEB33ARWLvAXS
	zMtMksqStEyRWBkoNvh9B02z9A+xww0=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b18741aaf8so4252847a91.2
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794758471; x=1795363271; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RQNBN5n20nbzOeQbJMzo0/EVUvvdWpBCnk4LAdFuQrs=;
        b=Zvh+kPDwJVeaZlHEqBlo7LBoehumEnAG21dJOjs7BxenGV4n2qWVUxdXJ+s2beXybt
         x6xl6R+T/olWqQri8z/91UtAo3YIW2FR/bVNGrisBJxa0DCwT9Q48Fj0oCjIKe7dCpxv
         dou6nDq+Cmk788xeLnhXIt02ZkXcQZEySYUUszKGPKRj8ugD14c3N9hPeKKaxVtL/3Gy
         FBszPsBwl+hPoTe4TMT14NLdCFDmExTFI+L239U0QUin/ql8pY97ie/qPUntmck6xd1J
         xvGoCfxsdI7STVbwom1uLPdh5aC49SNx/XeKzhxePdAjppY94swaHDfV6vxGS0BT9g+4
         W+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794758471; x=1795363271;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RQNBN5n20nbzOeQbJMzo0/EVUvvdWpBCnk4LAdFuQrs=;
        b=osmJ+AgxD6aD8sOgADbx+zRZtc6XJjkpLeqeuN6OxuOfJkalM749X0gr2LnFTo64xB
         en2oSZZE594Vdbej6FHjVkMZiuBJ86JIcQgOuzD5sk1WIk6nV3M1Q6SqOYNBZSL2rhCU
         bPH0q6mxQjp3AsOByVAVaekGCwrzY1maeM7QBQaNVfuPchSpuftoC335eDIPHlGAhkik
         dv9Vi49wq/A76k99lSOurCpUluhxLxvBN9DPKTh2uIIYdbSh9ciYrPu1zyqZpsf7JsMM
         7TAbWs1VGGKsRNRhaadBIxBJBbQP9TWD6yqZBBGkeXvscps0G/PYiMN6CpYGvRfMcq4P
         tAww==
X-Forwarded-Encrypted: i=1; AL+hErHXbJ3V8ump8R5muVgTOZrtmLP52kO+CUXM1IkQBT7EDP7tVONez01A7+OH5HLnsP9pUBYEB8EdJA==@kvack.org
X-Gm-Message-State: APuU4Z9g0wToaTyZpxVqI4FuHi79Cw37KGriXt91mlhbiOAgl49YN1G2
	blIMhCa+PcMMzHX+Ykmk5XNdxMbMKA5wVIngj3GSMuF7XNr6bAXRLRig778+xOBX3ZTe+LvQFzo
	lMPdg+lxQX4cEig==
X-Received: from pjbmv22.prod.google.com ([2002:a17:90b:1996:b0:3b3:7744:80c5])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5607:b0:3a8:c0cd:57fb with SMTP id 98e67ed59e1d1-3b1b0cbee8emr7980273a91.42.1794758470324;
 Sun, 15 Nov 2026 08:01:10 -0800 (PST)
Date: Sun, 15 Nov 2026 16:01:03 +0000
In-Reply-To: <20261115160105.2507650-1-jiaqiyan@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261115160105.2507650-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261115160105.2507650-2-jiaqiyan@google.com>
Subject: [PATCH v4 1/3] mm: memfd/hugetlb: memfd-based userspace HugeTLB MFR policy
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, muchun.song@linux.dev
Cc: nao.horiguchi@gmail.com, william.roche@oracle.com, ljs@kernel.org, 
	vbabka@kernel.org, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, skhan@linuxfoundation.org, 
	corbet@lwn.net, david@kernel.org, dave.hansen@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 08329160011
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rs68d6qz5jim68cnoep3rumedbibu1dn
X-HE-Tag: 1794758471-258045
X-HE-Meta: U2FsdGVkX1+Wwtq7FBqJli5DxsZftkTSV/lIkRIGIds8POIX/B9sDbHelc/r3yci9qvlxj5eneFnl9t+NMSHHSElD6E3hqwoHSLhWFKLIouUqVp+faE0/a/wawfZZxefEbSwYsefL8emiGZF6zXXNHHY4yoezvNtTS6Qx+37xzHWGjUg2+YoVcBO5ruilZ94j5u44jlOraloqBB+eSZutQjdhZ0xEYmS46I6jIaHZCIUzyx+aXBHGKHruHj2Nvl+gju2dxRP14tOb4HEYBdEM5EnKfCh1udF7F5VmwuDFyiCOa9M0LJbpgA/QdYkd5/FXNpetItDoI42CceKia/uzQ4f35B/UyV4PD1sj/NTOzEqKUKL5WNzbduS0LzLLN2r2NbB09oHT9zFksLV3tO7+k2AXE+MH2McCZ5+Fwk4JZ1qu9ZDyHMpuETno3k2k311y25fpXeQ7gsv5/ZeF12fbbIU6tNSwHq6Qty9psRv2O8hVxADEcqxhaTaFUw/J5QVqkX3Vm8favPTBi6WSG2kU2hie9NEVoFgGb92OlatvMFgZc/wAL+/MV0N2SNApSYIe0NvREF3a2RSJ4TXsrSaWkrMmS9lsnMQT0WlHeKxozSMMuMgDvmWE2iVM6jbI5abpg9+cH7g9OfskP9QzrFKBFk9BTzgcdAWXwYIL0C1n+XT1Ie92VliRa4dArlV/nAnT+SeyNPHYzz8TACBeUbks60OueLrr5OanERigKHoj6ZXYb8f6zM7LjrPxAsT8M6ZA6oFV/H4+hQ0y5IRanwpR4UWAOOoc/Vmr2DVeDl/LxbUwoL/AmQE9gOkoEaRoFSFhbNg36v/hGEd5JFVhM4/8bfoGK5iLmPdS1ap16sXn/5O46l+7aOLyehTzYkZq94Ex/kleHT36H14hEXTCCgolCDa+HkB11wfwF+eETrud2wCybuDyswLPOQP1GbkIAM4k1mNpoGDyCr2pilLiNn
 6T3zwz78
 /l81k/UH+nTjQgv466jRARdqAOCEUqkvtFc5SohDx7iRtCpRDXO/57IxTNfQmCi7LiNw78IbqNhiLcZXCxeOaNM1P0dN+ctQAzbcNV9bbtEmpssBBFDK7NXUdYhXEyyh6d3K4LuOqAiWDQDUSdaVAyxsiz0Ry1deENTB/NFfPrZRhko/x9r/qsJqTMvRihYS42Yn0igeprAAelNH2HmkADPQ2MDY49cjtlstnE4uSCD9bbq5pVItflmNrGBoaxXMocko6n5ahsu6AJFT1o2fMF7tKc9erra0z2ANbVavwYquW9ySD+8r6z0qqkOpc6FbmHShVlAYqjqinB+JzqGFqS8wlAVbiqYkdbM478/Xhv/CxE1lLZCFrEiWgX8rytBr0WOnWpWiOm/tTbfWVxcYyM1kCEjj83nD9iQT/PQnyI18KqYvoM8rQyqskNCKOZQhMIYPirdhaf4b6oCBe3/A6qK5iNg/W/GLhBgWGrHDp55VF+DhkDtipseMnkbUVJkBLaKXjA843IsqnYcpB8tZWBETocXZfxszIXv7cAoRWZmsXDOV847gSh3VZBVCuIMm5F4xVd3V+yl85xcN9IZQjGd+sgn1FQlZaqegnXXNtSbvGX463h/8jGoEzf9fheednEPeVUoh6qKlgwZrYLpe6eUIRjNqIRUcIoMR4kj0LMVWhCtir1V1f5yt04vzhDekkYBmxvv8xgvFfM/JudbxAM12Ho7pZ7eX4mcrXcbWQ9AfESkg6QnA2H4Si0a+erFmeRaHAO0VQK+ZubzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sometimes immediately hard offlining a large chunk of contiguous memory
having uncorrected memory errors (UE) may not be the best option.
Cloud providers usually serve capacity- and performance-critical guest
memory with 1G HugeTLB hugepages, as this significantly reduces the
overhead associated with managing page tables and TLB misses. However,
for today's HugeTLB system, once a byte of memory in a hugepage is
hardware corrupted, the kernel discards the whole hugepage, including
the healthy portion. Customer workload running in the VM can hardly
recover from such a great loss of memory.

Therefore keeping or discarding a large chunk of contiguous memory
owned by userspace (particularly to serve guest memory) due to
recoverable UE may better be controlled by userspace process
that owns the memory, e.g. VMM in the Cloud environment.

Introduce a memfd-based userspace memory failure recovery (MFR) policy,
MFD_MF_KEEP_UE_MAPPED. The policy could be supported by other kinds of
memfd in the future, but the current implementation only covers HugeTLB.

For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memfd,
whenever it runs into a new UE:

* MFR defers hard offline operations, i.e., unmapping and
  dissolving. MFR still sets the HWPoison flag, records the raw
  HWPoison page in the folio's raw_hwp_list, and sends SIGBUS to
  the consuming thread, but si_addr_lsb is reduced to PAGE_SHIFT.
  If userspace is able to handle the SIGBUS, the hugepage remains
  accessible via the mapping created with that memfd. The result
  is reported as MF_DELAYED, since the hugepage will be dealt with
  later.

* MFR doesn't hold any refcount on the hugepage after it returns;
  the page cache keeps the hugepage alive. Every memory_failure()
  on such a hugepage takes exactly one refcount and drops it in
  me_huge_page(), so it never drops a refcount held by others,
  e.g. hugetlb isolation. Since the 1st error clears the
  hugepage's migratable flag, get_huge_page_for_hwpoison() treats
  an already HWPoison hugepage of an MFD_MF_KEEP_UE_MAPPED memfd as
  in use, so that the 2nd and later errors are handled the same as
  the 1st. Without extra refcounts, the memfd can still be sealed
  with F_SEAL_WRITE after its hugepages have UEs.

* If the memory was not faulted in yet, the fault handler also
  allows faulting in the HWPoison folio.

For an MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
when the userspace process truncates or punches holes in its
hugepages:

* When the HugeTLB in-memory file system removes the filemap's
  folios one by one, it asks MFR to deal with HWPoison folios
  on the fly, implemented by filemap_offline_hwpoison_folio().

* MFR drops only the refcount taken by filemap_get_folios(), so that
  the HWPoison folio becomes free, and then dissolves it into a set
  of raw pages. dissolve_free_hugetlb_folio() moves the HWPoison flag
  to the raw pages after restoring vmemmap, so the healthy pages are
  freed to the buddy allocator, while the HWPoison ones are kept out
  of it. If the dissolve fails for any reason (e.g. an extra refcount
  on the folio), the folio remains HWPoison and is never allocated
  from the HugeTLB pool again.

By default MFD_MF_KEEP_UE_MAPPED is not set, so MFR immediately hard
offlines hugepages having UEs.

Tested with the new selftest hugetlb-mfr in the follow-up commit, with

1. HVO on and off.

2. MADV_HWPOISON and corrupt-pfn. corrupt-pfn
   covers the code paths in get_huge_page_for_hwpoison() that
   MADV_HWPOISON skips with MF_COUNT_INCREASED.

3. 2M and 1G hugepages.

4. Hugepages released by truncation, and by closing a sealed memfd.

This commit message was reworded with an AI assistant, which was also
used to review the code; I wrote all the code and have reviewed
results from AI.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Co-developed-by: William Roche <william.roche@oracle.com>
Signed-off-by: William Roche <william.roche@oracle.com>
Assisted-by: Antigravity:claude-opus-5-5
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 fs/hugetlbfs/inode.c       |  42 ++++++++++---
 include/linux/pagemap.h    |  24 ++++++++
 include/uapi/linux/memfd.h |   6 ++
 mm/hugetlb.c               |   8 ++-
 mm/memfd.c                 |   9 ++-
 mm/memory-failure.c        | 119 ++++++++++++++++++++++++++++++++++---
 6 files changed, 189 insertions(+), 19 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index f0be8edb3517..282bb19dfd3f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -493,10 +493,14 @@ hugetlb_vmdelete_list(struct address_space *mapping, pgoff_t start,
 
 /*
  * Called with hugetlb fault mutex held.
+ * Return true if the folio's folio_batch's refcount is consumed by
+ * filemap_offline_hwpoison_folio() because it attempted to deal with
+ * the folio for HWPoison reason.
  */
-static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
-		struct address_space *mapping, struct folio *folio,
-		pgoff_t index, bool truncate_op)
+static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
+				      struct address_space *mapping,
+				      struct folio *folio, pgoff_t index,
+				      bool truncate_op)
 {
 	/*
 	 * If folio is mapped, it was faulted in after being
@@ -526,6 +530,17 @@ static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	}
 
 	folio_unlock(folio);
+
+	/*
+	 * There may be pending HWPoison-ed folios when a memfd is being
+	 * removed or part of it is being truncated.
+	 *
+	 * HugeTLBFS' error_remove_folio keeps the HWPoison-ed folios in
+	 * page cache until mm wants to drop the folio at the end of the
+	 * filemap. At this point, if memory failure was previously delayed
+	 * by MFD_MF_KEEP_UE_MAPPED, we can now deal with it.
+	 */
+	return filemap_offline_hwpoison_folio(mapping, folio);
 }
 
 /*
@@ -556,13 +571,14 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 	const pgoff_t end = lend >> PAGE_SHIFT;
 	struct folio_batch fbatch;
 	pgoff_t next, index;
-	int i, freed = 0;
+	int i, j, freed = 0;
 	bool truncate_op = (lend == LLONG_MAX);
+	bool ret;
 
 	folio_batch_init(&fbatch);
 	next = lstart >> PAGE_SHIFT;
 	while (filemap_get_folios(mapping, &next, end - 1, &fbatch)) {
-		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+		for (i = 0, j = 0; i < folio_batch_count(&fbatch); ++i) {
 			struct folio *folio = fbatch.folios[i];
 			u32 hash = 0;
 
@@ -573,12 +589,21 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			/*
 			 * Remove folio that was part of folio_batch.
 			 */
-			remove_inode_single_folio(h, inode, mapping, folio,
-						  index, truncate_op);
+			ret = remove_inode_single_folio(h, inode, mapping,
+							folio, index, truncate_op);
 			freed++;
 
+			/*
+			 * Skip HWPoison folio whose reference was already
+			 * dropped by filemap_offline_hwpoison_folio().
+			 */
+			if (!ret)
+				fbatch.folios[j++] = folio;
+
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
+		fbatch.nr = j;
+
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
@@ -1048,6 +1073,9 @@ static int hugetlbfs_migrate_folio(struct address_space *mapping,
 static int hugetlbfs_error_remove_folio(struct address_space *mapping,
 				struct folio *folio)
 {
+	if (mapping_mf_keep_ue_mapped(mapping))
+		return MF_DELAYED;
+
 	return 0;
 }
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a37367..120821141234 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -209,6 +209,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_MF_KEEP_UE_MAPPED = 11, /* For MFD_MF_KEEP_UE_MAPPED. */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -344,6 +345,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline bool mapping_mf_keep_ue_mapped(const struct address_space *mapping)
+{
+	return test_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
+}
+
+static inline void mapping_set_mf_keep_ue_mapped(struct address_space *mapping)
+{
+	set_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
@@ -1349,6 +1360,19 @@ void replace_page_cache_folio(struct folio *old, struct folio *new);
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct folio_batch *fbatch);
 bool filemap_release_folio(struct folio *folio, gfp_t gfp);
+#ifdef CONFIG_MEMORY_FAILURE
+/*
+ * Provided by memory failure to offline HWPoison-ed folio managed by memfd.
+ */
+bool filemap_offline_hwpoison_folio(struct address_space *mapping,
+				    struct folio *folio);
+#else
+static inline bool filemap_offline_hwpoison_folio(struct address_space *mapping,
+						  struct folio *folio)
+{
+	return false;
+}
+#endif
 loff_t mapping_seek_hole_data(struct address_space *, loff_t start, loff_t end,
 		int whence);
 
diff --git a/include/uapi/linux/memfd.h b/include/uapi/linux/memfd.h
index 273a4e15dfcf..d9875da551b7 100644
--- a/include/uapi/linux/memfd.h
+++ b/include/uapi/linux/memfd.h
@@ -12,6 +12,12 @@
 #define MFD_NOEXEC_SEAL		0x0008U
 /* executable */
 #define MFD_EXEC		0x0010U
+/*
+ * Keep owned folios mapped when uncorrectable memory errors (UE) causes
+ * memory failure (MF) within the folio. Only at the end of the mapping
+ * will its HWPoison-ed folios be dealt with.
+ */
+#define MFD_MF_KEEP_UE_MAPPED	0x0020U
 
 /*
  * Huge page size encoding when MFD_HUGETLB is specified, and a huge page
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ff9dbfbc7a96..d28710d3ede6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5978,9 +5978,11 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 		 * So we need to block hugepage fault by PG_hwpoison bit check.
 		 */
 		if (unlikely(folio_test_hwpoison(folio))) {
-			ret = VM_FAULT_HWPOISON_LARGE |
-				VM_FAULT_SET_HINDEX(hstate_index(h));
-			goto backout_unlocked;
+			if (!mapping_mf_keep_ue_mapped(mapping)) {
+				ret = VM_FAULT_HWPOISON_LARGE |
+				      VM_FAULT_SET_HINDEX(hstate_index(h));
+				goto backout_unlocked;
+			}
 		}
 
 		/* Check for page in userfault range. */
diff --git a/mm/memfd.c b/mm/memfd.c
index 0f6fff004f5e..fcc00b4ba10e 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -341,7 +341,8 @@ long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg)
 #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
 #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
 
-#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
+#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | \
+		       MFD_NOEXEC_SEAL | MFD_EXEC | MFD_MF_KEEP_UE_MAPPED)
 
 static int check_sysctl_memfd_noexec(unsigned int *flags)
 {
@@ -412,6 +413,9 @@ static int sanitize_flags(unsigned int *flags_ptr)
 	if (!(flags & MFD_HUGETLB)) {
 		if (flags & ~MFD_ALL_FLAGS)
 			return -EINVAL;
+		/* Only HugeTLBFS supports MFD_MF_KEEP_UE_MAPPED. */
+		if (flags & MFD_MF_KEEP_UE_MAPPED)
+			return -EINVAL;
 	} else {
 		/* Allow huge page size encoding in flags. */
 		if (flags & ~(MFD_ALL_FLAGS |
@@ -484,6 +488,9 @@ struct file *memfd_alloc_file(const char *name, unsigned int flags)
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	file->f_flags |= O_LARGEFILE;
 
+	if (flags & MFD_MF_KEEP_UE_MAPPED)
+		mapping_set_mf_keep_ue_mapped(file->f_mapping);
+
 	if (flags & MFD_NOEXEC_SEAL) {
 		inode->i_mode &= ~0111;
 		file_seals = memfd_file_seals_ptr(file);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b456e0996ecd..30fa252d1522 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -459,6 +459,8 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
 			  unsigned long addr)
 {
 	struct to_kill *tk;
+	const struct folio *folio;
+	struct address_space *mapping;
 
 	tk = kmalloc_obj(struct to_kill, GFP_ATOMIC);
 	if (!tk) {
@@ -467,10 +469,21 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
 	}
 
 	tk->addr = addr;
-	if (is_zone_device_page(p))
+	if (is_zone_device_page(p)) {
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
-	else
-		tk->size_shift = folio_shift(page_folio(p));
+	} else {
+		folio = page_folio(p);
+		mapping = folio_mapping(folio);
+		if (mapping && mapping_mf_keep_ue_mapped(mapping))
+			/*
+			 * Let userspace know the radius of HWPoison is
+			 * the size of raw page; accessing other pages
+			 * inside the folio is still ok.
+			 */
+			tk->size_shift = PAGE_SHIFT;
+		else
+			tk->size_shift = folio_shift(folio);
+	}
 
 	/*
 	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
@@ -895,6 +908,8 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 				  int flags)
 {
 	int ret;
+	struct folio *folio;
+	struct address_space *mapping;
 	struct hwpoison_walk priv = {
 		.pfn = pfn,
 	};
@@ -912,8 +927,14 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 	 * ret = 0 when poison page is a clean page and it's dropped, no
 	 * SIGBUS is needed.
 	 */
-	if (ret == 1 && priv.tk.addr)
+	if (ret == 1 && priv.tk.addr) {
+		folio = pfn_folio(pfn);
+		mapping = folio_mapping(folio);
+		if (mapping && mapping_mf_keep_ue_mapped(mapping))
+			priv.tk.size_shift = PAGE_SHIFT;
+
 		kill_proc(&priv.tk, pfn, flags);
+	}
 	mmap_read_unlock(p->mm);
 
 	return ret > 0 ? -EHWPOISON : 0;
@@ -1210,6 +1231,15 @@ static int me_swapcache_clean(struct page_state *ps, struct page *p)
 	return ret;
 }
 
+static bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
+						struct address_space *mapping)
+{
+	if (!folio_test_hugetlb(folio) || !mapping)
+		return false;
+
+	return mapping_mf_keep_ue_mapped(mapping);
+}
+
 /*
  * Huge pages. Needs work.
  * Issues:
@@ -1229,6 +1259,15 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		/* The page is kept in page cache. */
 		extra_pins = true;
 		folio_unlock(folio);
+
+		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping)) {
+			/*
+			 * Page cache keeps the folio until
+			 * filemap_offline_hwpoison_folio() dissolves it.
+			 */
+			folio_put(folio);
+			return res;
+		}
 	} else {
 		folio_unlock(folio);
 		/*
@@ -1689,7 +1728,9 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 	LIST_HEAD(tokill);
 	bool unmap_success;
 	bool forcekill;
+	bool keep_mapped;
 	bool mlocked = folio_test_mlocked(folio);
+	struct address_space *mapping = folio_mapping(folio);
 
 	/*
 	 * Here we are interested only in user-mapped pages, so skip any
@@ -1715,8 +1756,12 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 	 */
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
-	unmap_success = !unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
-	if (!unmap_success)
+	keep_mapped = hugetlb_should_keep_hwpoison_mapped(folio, mapping);
+	if (!keep_mapped)
+		unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
+
+	unmap_success = !folio_mapped(folio);
+	if (!keep_mapped && !unmap_success)
 		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
 		       pfn, folio_mapcount(folio));
 
@@ -1741,7 +1786,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 		    !unmap_success;
 	kill_procs(&tokill, forcekill, pfn, flags);
 
-	return unmap_success;
+	return unmap_success || keep_mapped;
 }
 
 static int identify_page_state(unsigned long pfn, struct page *p,
@@ -1989,6 +2034,7 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 	struct raw_hwp_page *raw_hwp;
 	struct raw_hwp_page *p;
 	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
+	struct address_space *mapping = folio_mapping(folio);
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
@@ -2007,6 +2053,10 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 	if (raw_hwp) {
 		raw_hwp->page = page;
 		llist_add(&raw_hwp->node, head);
+
+		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
+			/* A new raw HWPoison page in a still mapped hugepage. */
+			ret = MF_HUGETLB_IN_USED;
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
@@ -2057,11 +2107,13 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 {
 	struct page *page = pfn_to_page(pfn);
 	struct folio *folio;
+	struct address_space *mapping;
 	bool count_increased = false;
 	int ret, rc;
 
 	spin_lock_irq(&hugetlb_lock);
 	folio = page_folio(page);
+	mapping = folio_mapping(folio);
 	if (!folio_test_hugetlb(folio)) {
 		ret = MF_HUGETLB_NON_HUGEPAGE;
 		goto out_unlock;
@@ -2070,7 +2122,15 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 		count_increased = true;
 	} else if (folio_test_hugetlb_freed(folio)) {
 		ret = MF_HUGETLB_FREED;
-	} else if (folio_test_hugetlb_migratable(folio)) {
+	} else if (folio_test_hugetlb_migratable(folio) ||
+		   (folio_test_hwpoison(folio) &&
+		    hugetlb_should_keep_hwpoison_mapped(folio, mapping))) {
+		/*
+		 * A kept-mapped HWPoison hugepage is
+		 * no longer migratable (cleared by
+		 * the 1st error), but it is still in use
+		 * and should/can go through same handling.
+		 */
 		if (folio_try_get(folio)) {
 			ret = MF_HUGETLB_IN_USED;
 			count_increased = true;
@@ -2107,6 +2167,49 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	return ret;
 }
 
+static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
+{
+	int ret;
+
+	/*
+	 * Since folio is still in the folio_batch, drop the refcount
+	 * elevated by filemap_get_folios.
+	 *
+	 * If folio has multiple HWPoison pages:
+	 * - When handling the 1st HWPoison page, me_huge_page() drops
+	 *   the refcount raised by get_huge_page_for_hwpoison() or the
+	 *   caller's refcount passed in with MF_COUNT_INCREASED.
+	 * - When handling the 2nd and later HWPoison page, although
+	 *   the folio's migratable flag is already cleared, it is still
+	 *   in use, the refcount raised by get_huge_page_for_hwpoison()
+	 *   will still be dropped by me_huge_page().
+	 * Therefore no extra refcount to drop.
+	 */
+	folio_put(folio);
+
+	/* Refcount now should be zero and ready to dissolve folio. */
+	ret = dissolve_free_hugetlb_folio(folio);
+	if (ret)
+		pr_err("failed to dissolve hugetlb folio: %d\n", ret);
+}
+
+bool filemap_offline_hwpoison_folio(struct address_space *mapping,
+				    struct folio *folio)
+{
+	WARN_ON_ONCE(!mapping);
+
+	if (!folio_test_hwpoison(folio))
+		return false;
+
+	/* Pending MFR currently only exist for hugetlb. */
+	if (hugetlb_should_keep_hwpoison_mapped(folio, mapping)) {
+		filemap_offline_hwpoison_folio_hugetlb(folio);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Taking refcount of hugetlb pages needs extra care about race conditions
  * with basic operations like hugepage allocation/free/demotion.
-- 
2.56.0.611.g1030f0b940-goog


