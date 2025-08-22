Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5348BCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FDAF8E00AB; Fri, 22 Aug 2025 09:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF188E009D; Fri, 22 Aug 2025 09:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875D48E00AB; Fri, 22 Aug 2025 09:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 776EF8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:28:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02F9B116AE3
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:28:27 +0000 (UTC)
X-FDA: 83804472696.23.6E6AADC
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3D48140003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:28:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=VYSuwc5z;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755869306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=fqC/Spz2Hq2FVjUT65d+ktoThn3kySBVEzXaDURClfI=;
	b=fj/4chkARqEtSkPjrSJ4W6HPkbPg5VUKFwfPLR6g7h9f2EvWR9WWuhKnvIR13xznbdgRyM
	8LlYzZ+zEz5I/5o3QlzRxXgS1RVDWCyNZD/e3UrZK2DYcdFGGYLMivlvKeURVUfkt0AZSp
	oQN2mwF3l8621eZ+8apMEX8kuHhIrYM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=VYSuwc5z;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755869306; a=rsa-sha256;
	cv=none;
	b=boqWaMxS0Zo6TyWhp67M6my+OcZF7XhKcjb15tFM9NOf+3fk4+j7pjyTVX5ijImdNYb/Aj
	ueclZCOgvrnv0BKrPEK3GAVaGlf1Wk2dZDVTHUMwFUNP+e62bS3VAaWBRICsBcbKAH1P46
	Ohug2Y9kiMdKwGF15ikV48pNq2J9exM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id A3904A58A0E;
	Fri, 22 Aug 2025 13:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D468C4CEED;
	Fri, 22 Aug 2025 13:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755869305;
	bh=0qXYlDRajCqE1UuEPQ9xvBU0VYwa8pcHwIGL0Wg2jbU=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=VYSuwc5zkT68u0lT2K9gbmc+5JrVROybe25+DpiNr9hZC8PD+m1MZQsPh7Bv8L0Xh
	 aHQrq2LOGdAxOkJNRjr4s+amDmsBF36CXwTUc/blsD09Kc2t2gYBOeN/1P/zBeIODU
	 Tr2hajjWN6XZlvdwAxRfqxsv6qxcOfrnES4c+VDs=
Subject: Patch "mm: update memfd seal write check to include F_SEAL_WRITE" has been added to the 5.15-stable tree
To: Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,brauner@kernel.org,david@redhat.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mhocko@suse.com,mike.kravetz@oracle.com,muchun.song@linux.dev,osalvador@suse.de,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,viro@zeniv.linux.org.uk,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 22 Aug 2025 15:28:10 +0200
In-Reply-To: <20250730015337.31730-3-isaacmanjarres@google.com>
Message-ID: <2025082210-preface-grimy-5a21@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: 9t1efcr31iexqsbgy5s5y8oyb55j1cd7
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D48140003
X-Rspamd-Server: rspam05
X-HE-Tag: 1755869306-513111
X-HE-Meta: U2FsdGVkX1/2rgpeQBAQFyPmJEPSpSHEskAgtp+Dc968Dzyu5oGSkmLU06b7Cml8Ok20rt+pwFTZ9c2QCh79y/UUKwY1swRxUE/dGY2ZzuUQnl3m3tuUjmGy+s3lv8FguGacn4M/zDDKBHcYz6kGvpWNsJsIRkpV7K1SA0K3S27MehO6rszi7jXUf7RbmA8OPKc/kctoSSwLCykhCPFG/wfKPh4ZDFiSmpaBaLuEV96MxWdZ0KKS+AkoVBKW9kJuMjc6H5GBw3Xse+eSBtZEVoxBLUBeB/QDVF1BG59vYS1c4s3G3kxRc8WRp3Ddn521dungKvRr6a96ucqlW9Nw9cpzu3ddWmy+m/pRg7sj5iM0viYDcIrPSRadOIx9BlfmAXVc/gYjAv3BL/qUwyZrsrSCpC9c774jT88E+JQpW893ocGkedlCH69NYr2ZYl2H1nq4RfsFVzzwLlnbDRmYMQpKx3gutceOtVhzwSPNvu2MimGeA4kEeiGG61chc62NyBqDWdgK3fjYZ9xzZIRbeR4An/nsJKhZHi3pEzMmwjvpNi05MPkE04uUjBTRCKJTYlRTqZ5vZF/ZPga3WS91RZi2tbSJTMaB1Ga1xtrS3GTK1Ffpdc3t1f3Osg3Fo7Isv80lEuOJsgkl5Ngc8TpTNhVEqNK35hE+YQe0rP9evX75kW68UGrG8sT9grT4eRWTURp+hojF54pocW1dM5/ry+XrEAz1O3AdqWGkuwqqKROn+3bRGbBb/ZzASaVYAvP0XNhKwF3vq79L4Qu0aSuLIcqeursYvhGx3VmPlVEKw2BX++xofY3leSnCFOdZLqiNnXtD9iVxXA0d+pRLxyqMZt5SWUWcnvRuxz0wHTXuA3Q0ilGojA+HpvEi5Ef52c882W11D7XtP7AOKeTD3oL6Gdm1niM1UpyOI0VPiXC1PB9u71ZL1BY3oS3At9seN3H5WkN9MxXp65cpFNmo7gP
 l8wfCpGd
 bkOjM8DAnIrZVSPqRRb0kcCtHwSWqODvXnUlBybVpG94+RLK3G1rrrgxeKAYBgMdGnLafLkUEsdyBDMEw6JL96eHaFtmWqzYi+BR1AF3Elocc4tpEJCdLuWLn0euuaZAM7hi96hMIC9efjoMHDnWiOXOXhTGcieWJ4liDfftqXEF4gtvk8FxN8+t4WpsL1b6giXu9OrHwOU+HfrcNG0ImxNeg8TefK8gRF37tD8dehX6/88x/2L6dCrXCY8WBVkOaNN7SFCAUpZCxJ6ffZJepan8oeUOUwGpco5+hbMuXeU4ZAwXBUCtpkhjt8rnanM0EqL/mlBxsDtz/3U2tzlzDeX1mxF5vayH0i7DactxHWSiejwqmNJAD/APM0dM5bpDzFl9XyLkJ7p6vMMk4BpM4ArzUQptMI1EcH4AltSRsKze4hCWETPfUVt+ryvls6V5gzO6OgMl+Rqrq5apoRUr9xPsdKxPZcPZYJHBB4zZWkjZDmo8pbFjRdnfVE3yCm6t6UVXn0a74TaZixxZJLInBoneYPmjBeGFfFVKa1LAn2n0FG+N+yH9B7gYKRfk3igcvpGOyrAtq1SgwmBfK37KQJJQRSvyEWWy8Mpb3pHFUTCGi/BoIX1+NpWrILt1/E4nbt6gPNxzMAr+bIDMm44xXlcuSv+rI4fiOFs+oGupjV14vlJQi0oti+RwiG0Pe1ZkOzoRuxpEVwQ8O6629CF9op7ptavNFR16npK3XZlqi4a/S6YObUB/u88vgi90kgaa1wnvL4gmTcXOA5b/cDJqk37VIBk2J0pmiByjXviBXHXN1BgMePDzYZ5JpKXMGhbSGgeSPASZrgC8i6jxNUrhlwK5z9LEXEn7cQpXO4VJPlVAWc3Lc5eiwtrAGdce1U8ELbTK2d3vu7VwhZcLOD03nJi6a80hplVThbEYp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: update memfd seal write check to include F_SEAL_WRITE

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165170-greg=kroah.com@vger.kernel.org Wed Jul 30 03:55:00 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:53:31 -0700
Subject: mm: update memfd seal write check to include F_SEAL_WRITE
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,  David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Lorenzo Stoakes <lstoakes@gmail.com>, Jan Kara <jack@suse.cz>,  Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,  Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,  Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <20250730015337.31730-3-isaacmanjarres@google.com>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 28464bbb2ddc199433383994bcb9600c8034afa1 ]

The seal_check_future_write() function is called by shmem_mmap() or
hugetlbfs_file_mmap() to disallow any future writable mappings of an memfd
sealed this way.

The F_SEAL_WRITE flag is not checked here, as that is handled via the
mapping->i_mmap_writable mechanism and so any attempt at a mapping would
fail before this could be run.

However we intend to change this, meaning this check can be performed for
F_SEAL_WRITE mappings also.

The logic here is equally applicable to both flags, so update this
function to accommodate both and rename it accordingly.

Link: https://lkml.kernel.org/r/913628168ce6cce77df7d13a63970bae06a526e0.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |    2 +-
 include/linux/mm.h   |   15 ++++++++-------
 mm/shmem.c           |    2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -148,7 +148,7 @@ static int hugetlbfs_file_mmap(struct fi
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3287,25 +3287,26 @@ static inline void mem_dump_obj(void *ob
 #endif
 
 /**
- * seal_check_future_write - Check for F_SEAL_FUTURE_WRITE flag and handle it
+ * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
+ *                    handle them.
  * @seals: the seals to check
  * @vma: the vma to operate on
  *
- * Check whether F_SEAL_FUTURE_WRITE is set; if so, do proper check/handling on
- * the vma flags.  Return 0 if check pass, or <0 for errors.
+ * Check whether F_SEAL_WRITE or F_SEAL_FUTURE_WRITE are set; if so, do proper
+ * check/handling on the vma flags.  Return 0 if check pass, or <0 for errors.
  */
-static inline int seal_check_future_write(int seals, struct vm_area_struct *vma)
+static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & F_SEAL_FUTURE_WRITE) {
+	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
 		/*
 		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * "future write" seal active.
+		 * write seals are active.
 		 */
 		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
 			return -EPERM;
 
 		/*
-		 * Since an F_SEAL_FUTURE_WRITE sealed memfd can be mapped as
+		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
 		 * MAP_SHARED and read-only, take care to not allow mprotect to
 		 * revert protections on such mappings. Do this only for shared
 		 * mappings. For private mappings, don't need to mask
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2262,7 +2262,7 @@ static int shmem_mmap(struct file *file,
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-5.15/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
queue-5.15/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-5.15/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-5.15/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

