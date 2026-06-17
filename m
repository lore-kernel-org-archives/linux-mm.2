Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5648CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598946B0099; Wed, 17 Jun 2026 13:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A5C6B009B; Wed, 17 Jun 2026 13:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F7B6B009D; Wed, 17 Jun 2026 13:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC986B0099
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:26:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8824D1C48D5
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:22 +0000 (UTC)
X-FDA: 84890083404.04.58D13E7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6919E140005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e8mP7W5g;
	spf=pass (imf26.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717180;
	b=eS8yHYPYgOsRPl8gUZ1cVHYqbu1+QNnZlyzg3ItKIPdIBrckbkaz+DC6uwbG/tFcu7Luv7
	E01INgyzgPZQbmh/+rRHV9n5YQubBY+6oP57+Mbg+VitUJrJ8QM2nFvYIqS2g8rmcqPZQs
	hzhzdSnaYxBfT9FPXEDV8EUqLxtt/mo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e8mP7W5g;
	spf=pass (imf26.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAUn+oaPJv9DS6gb1kxocCUDK3tO/sBjrG28cGJsMmQ=;
	b=Uxd9ePkME5yvRmKUkRcc1qKs53vVq/4YzfbakgsFPolGyFWw6EVH12+KGAFpUfjMTq1qqF
	g2SkqDwflzfT6ofPg5iSBKVHKZijrlSLE0R+z4HK/8Tr4E+Buf90VKsF3ZS6WiAliyI7p4
	xHayQfPvsXKnIpLiPRrykFOi84z18tE=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HErZ9S2382295;
	Wed, 17 Jun 2026 17:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=tAUn+
	oaPJv9DS6gb1kxocCUDK3tO/sBjrG28cGJsMmQ=; b=e8mP7W5gOUeWfRuOuhS8s
	OIheX7Y/ykvE0vcj/UTihur/BaDkLb3CVA2Z89J9RUfKTXMAtJbUp4hz03HH+6Ee
	9YJSFj8pqXwKhU54AVdyRB5E07CWEjxwOwvttJFGv0eQm6JojT1Uu/Hi2wxuKjCZ
	rhmhxe3trsb96srf+DXLcJLVyzTApukrLK61rofUeLI5OmDdAAkfB4h/Sb6bOfdw
	oVRYkFAq0RExf5rolOvW54ec0AiDdXRBaOw0Vh4WnTP9Dhk2hMw8Sa1gamP1qj8T
	P05mBxG59gRhk6OPf40MRB808kReUPqbfZy+fgalNJwitS7I0ole4cRvjlBn7ZbQ
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euege1c2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 17:26:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HHNVOv003778;
	Wed, 17 Jun 2026 17:26:07 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4eudvc0wgy-7;
	Wed, 17 Jun 2026 17:26:07 +0000 (GMT)
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
        david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
        rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 06/11] hugetlb: make hugetlb_fault_mutex_hash() to take PAGE_SIZE index
Date: Wed, 17 Jun 2026 11:25:27 -0600
Message-ID: <20260617172534.1740152-7-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260617172534.1740152-1-jane.chu@oracle.com>
References: <20260617172534.1740152-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606150000 definitions=main-2606170167
X-Proofpoint-ORIG-GUID: oDHmsfSY4upw41nmGtuFReoP_0Fp2nWm
X-Authority-Analysis: v=2.4 cv=d7jFDxjE c=1 sm=1 tr=0 ts=6a32d8b0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=SK8YR3qc6bc5OXhI6RsA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: oDHmsfSY4upw41nmGtuFReoP_0Fp2nWm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfX6kjP6VsYV4IZ
 UmfUNEm6BSpS09cFyWzIDrortU/ddGJ5JipiIvZCCNwOsgHRd12X439rB+JT7LhNtCUM8gvO1WE
 T8BtppSoBeE0jw91BxGLHwFBoQI7D1udhBU1MIKZWNCL8jApyS/NpHrSI1oXCq7DyCJXQ/kDpFD
 ShlkJgqrrPQTHMR8x8vO697Ng5JWvG11eKr0EU2iNz44ZgtAyos1rDhXvDz+4lXmZkJxo2RZyaC
 s5PClI5JniKwx8CPBkq8861VM1uSLCzFjMUWJ31+74kn8xGKjIzSEqcbjwOJm0C7nMEk3kD+CEC
 XGi+7Yw8qMGcBRFoycXER2J9xalzzQRZmPxCV1tg3xjmbIA/3gWPzMuY9pahDqGGxHrtrn5q5gw
 R6gDRF9T5ZOBMZN4W2PVP5ZeWRJb8nBdG/Mv2zo63Z5SC5U39XIvC3hUA6+W7lu733sz+sJZCbj
 bDsvESKkDl1G0tYsgjsLSf4F432abH2SK+IxbkNY=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfXyHhvJ98vL3KF
 FmArO7ehBCz4uOOxZrSpd5MbwMWU5B+zkPIKNTqdI1nAnLnbcYdmKc5pxo1BUHhZz88d4627jjO
 NgIqZAqLng0FrQMm7hhOez869BycIQYkAFBCG5H5kjJTlSjomOEg
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6919E140005
X-Rspam-User: 
X-Stat-Signature: 3p9zxrtodpx133qxjdni1ug79c3rysoa
X-HE-Tag: 1781717180-439532
X-HE-Meta: U2FsdGVkX19R4dp75xQoddZCJTsuW1MMEzWQmY85ZJFwg1ryF5bhSE8fAlp3nw/FYxVJDZT6QJilHLH7knuBNPZTidCg0gLW3kFnKXgKaAEX5+LUIgvEJMfD9Y27JdL5UEgP1xoSNnDbFhF7pfHl9yhh+lJLjOo5ahRto8khrC6wtV4mcbQNHVywid881eKrPALk68S1Cl9RXf7xbocuOHKc7r972Ihry447c73PG9LRh8MrCtYVhlfjJa++wCr3Uth5lYaT4VEKdwq5CynS1X4pIdEqRE/WbyT3o7erhOD7CF7crwe8c60UISCY0GdWHl/YoBt2g7Y1gW4Rcxpzr6ggI039JD7rkKBg/oKlFP3WX8swTHF+QHi5Os0lb2M7EdQhNS7GWR9SAMuS1maqf6L1VghT0wRKrg2Ny6sN8ZwNDxhOsbbeCa9PE2/VyWHzCdwNbXEHZkbJjA+wAJ3OdwYqE8+HcyXhzrDkxGCOGH5EyIVLz4XhC+KV7GWFCE3pZEgBavDH/J7U0ryBPGFXavnuzTwBUb7ZGBBX6zVd45R9Tib07tk7HzQ5gA3eETgdFfciyWB33bMc0OrKR+3pl2pYl6WX/4PNZ9TMPrbizls7me30aBIlDt64hwu5dxXplOujN4NopFN2Ulyociy9K0TAfdzJTFuOcimk/L2Bh7o48iV8PsN/E0eT3rV2w3On4gtt2wO4DOWEpIwmjU2fUdLi18vw2oJbo6DKUiXMJOFF8Kj12MJhCHku5biz+w6DwlUR9D2BR+tb8Nxp2gHVBenXyIXGLmaVOI+n1ECce/IBifV75qMudM9lQZneFQ5y3rT3uIleFEnoTLoAUl1ODzQql8SXe5Nj1es+2ICZZu5c71Vnwy8VO70G+xBKFBoV+JnOhFfnHAzEL3HYrtkYWi5VV/EGiJIspAnzuXj0euU4YvYh1i2Refr8XSycZmn2shtIDQDt339NEBd39LY
 tnSXPIbd
 wpykmL/QWe4I0W1yuUKe8cUan7ZIV4dJthQklYi2A5ntc4tpskVg/CBX2ROGDKBHcFPxMSZcmQaGnc5DCMTRQSoddB01Uu/00TREFzVVNHHFvpK8CPNeipNE/nUkKdJ3dXX3XY08VWuBHQcIkfp6dGnSGhOt2IGJv4V46CCCbjq8uAkh0CKmDBAwgblnFG5EMN/xd+iOCwM9kFykasbzPzNpuqETy/ta1ToHyaYRoAfKVTSLSOGHzlLjWie1awDhxPBENkdKq9mfTR+qDXsEoNVz+PV/lmkePFHJ+WoV1O0g8w5DOpxkhrlfDPxXankYU2hx89Hm2bWdPcEGAEfWkps34dSY3trAa8/rUywBmZMOHSwwABR00cBp53n9UPDuusk6LEffwL3ZtHSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make hugetlb_fault_mutex_hash() to take a PAGE_SIZE-based index.
This makes the helper interface consistent with filemap_get_folio(),
and linear_page_index(), while preserving the same lock selection for
a given hugetlb file offset.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 fs/hugetlbfs/inode.c    |  9 ++++-----
 include/linux/hugetlb.h |  2 +-
 mm/hugetlb.c            | 23 ++++++++++++-----------
 mm/memfd.c              |  9 +++++----
 mm/userfaultfd.c        |  6 +++---
 5 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1c25485c91b9..02cb265a580e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -448,7 +448,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 	struct address_space *mapping = &inode->i_data;
 	const pgoff_t end = lend >> PAGE_SHIFT;
 	struct folio_batch fbatch;
-	pgoff_t next, index;
+	pgoff_t next;
 	int i, freed = 0;
 	bool truncate_op = (lend == LLONG_MAX);
 
@@ -459,15 +459,14 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			struct folio *folio = fbatch.folios[i];
 			u32 hash = 0;
 
-			index = folio->index >> huge_page_order(h);
-			hash = hugetlb_fault_mutex_hash(mapping, index);
+			hash = hugetlb_fault_mutex_hash(mapping, folio->index);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
 			 * Remove folio that was part of folio_batch.
 			 */
 			remove_inode_single_folio(h, inode, mapping, folio,
-						  index, truncate_op);
+						  folio->index, truncate_op);
 			freed++;
 
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
@@ -664,7 +663,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		addr = index * hpage_size;
 
 		/* mutex taken here, fault path and hole punch */
-		hash = hugetlb_fault_mutex_hash(mapping, index);
+		hash = hugetlb_fault_mutex_hash(mapping, index << huge_page_order(h));
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 218284e80451..cae5cdd3ea00 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -159,7 +159,7 @@ void folio_putback_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
-u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
+u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t index);
 
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3255f6b762c9..ecd1d1322fda 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5505,7 +5505,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 		 */
 		if (cow_from_owner) {
 			struct address_space *mapping = vma->vm_file->f_mapping;
-			pgoff_t idx;
+			pgoff_t index;
 			u32 hash;
 
 			folio_put(old_folio);
@@ -5518,8 +5518,8 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 			 *
 			 * Reacquire both after unmap operation.
 			 */
-			idx = vma_hugecache_offset(h, vma, vmf->address);
-			hash = hugetlb_fault_mutex_hash(mapping, idx);
+			index = linear_page_index(vma, vmf->address);
+			hash = hugetlb_fault_mutex_hash(mapping, index);
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
@@ -5654,8 +5654,6 @@ static inline vm_fault_t hugetlb_handle_userfault(struct vm_fault *vmf,
 						  unsigned long reason)
 {
 	u32 hash;
-	struct hstate *h = hstate_vma(vmf->vma);
-	pgoff_t idx = vmf->pgoff >> huge_page_order(h);
 
 	/*
 	 * vma_lock and hugetlb_fault_mutex must be dropped before handling
@@ -5663,7 +5661,7 @@ static inline vm_fault_t hugetlb_handle_userfault(struct vm_fault *vmf,
 	 * userfault, any vma operation should be careful from here.
 	 */
 	hugetlb_vma_unlock_read(vmf->vma);
-	hash = hugetlb_fault_mutex_hash(mapping, idx);
+	hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	return handle_userfault(vmf, reason);
 }
@@ -5896,7 +5894,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	if (unlikely(ret & VM_FAULT_RETRY))
 		vma_end_read(vma);
 
-	hash = hugetlb_fault_mutex_hash(mapping, idx);
+	hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	return ret;
 
@@ -5913,13 +5911,16 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 }
 
 #ifdef CONFIG_SMP
-u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
+u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t index)
 {
 	unsigned long key[2];
+	struct hstate *h;
 	u32 hash;
 
 	key[0] = (unsigned long) mapping;
-	key[1] = idx;
+
+	h = hstate_inode(mapping->host);
+	key[1] = index >> huge_page_order(h);
 
 	hash = jhash2((u32 *)&key, sizeof(key)/(sizeof(u32)), 0);
 
@@ -5930,7 +5931,7 @@ u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
  * For uniprocessor systems we always use a single mutex, so just
  * return 0 and avoid the hashing overhead.
  */
-u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
+u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t index)
 {
 	return 0;
 }
@@ -5965,7 +5966,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * the same page in the page cache.
 	 */
 	mapping = vma->vm_file->f_mapping;
-	hash = hugetlb_fault_mutex_hash(mapping, vmf.pgoff >> huge_page_order(h));
+	hash = hugetlb_fault_mutex_hash(mapping, vmf.pgoff);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	/*
diff --git a/mm/memfd.c b/mm/memfd.c
index abe13b291ddc..b0ec0b12b98d 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -64,7 +64,7 @@ static void memfd_tag_pins(struct xa_state *xas)
  * (memfd_pin_folios()) cannot find a folio in the page cache at a given
  * index in the mapping.
  */
-struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
+struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t index)
 {
 #ifdef CONFIG_HUGETLB_PAGE
 	struct folio *folio;
@@ -79,12 +79,13 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		 */
 		struct inode *inode = file_inode(memfd);
 		struct hstate *h = hstate_file(memfd);
+		pgoff_t idx;
 		int err = -ENOMEM;
 		long nr_resv;
 
 		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
-		idx >>= huge_page_order(h);
+		idx = index >> huge_page_order(h);
 
 		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
 		if (nr_resv < 0)
@@ -116,7 +117,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 			 * races with concurrent allocations, as required by all other
 			 * callers of hugetlb_add_to_page_cache().
 			 */
-			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
+			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, index);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			err = hugetlb_add_to_page_cache(folio,
@@ -140,7 +141,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		return ERR_PTR(err);
 	}
 #endif
-	return shmem_read_folio(memfd->f_mapping, idx);
+	return shmem_read_folio(memfd->f_mapping, index);
 }
 
 /*
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 180bad42fc79..95fb94b697a4 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -707,7 +707,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 	long copied;
 	struct folio *folio;
 	unsigned long vma_hpagesize;
-	pgoff_t idx;
+	pgoff_t index;
 	u32 hash;
 	struct address_space *mapping;
 
@@ -776,9 +776,9 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 		 * in the case of shared pmds.  fault mutex prevents
 		 * races with other faulting threads.
 		 */
-		idx = hugetlb_linear_page_index(dst_vma, dst_addr);
+		index = linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
-		hash = hugetlb_fault_mutex_hash(mapping, idx);
+		hash = hugetlb_fault_mutex_hash(mapping, index);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 		hugetlb_vma_lock_read(dst_vma);
 
-- 
2.43.5


