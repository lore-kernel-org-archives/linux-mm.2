Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3640CA0FE7
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 07:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9DBF6B0092; Sun, 24 Aug 2025 03:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E456B0095; Sun, 24 Aug 2025 03:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DFF6B00AB; Sun, 24 Aug 2025 03:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B250A6B0092
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 03:58:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C9B25B74C
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 07:58:29 +0000 (UTC)
X-FDA: 83810898738.08.114D912
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf25.hostedemail.com (Postfix) with ESMTP id A938FA0008
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 07:58:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ZT864UrJ;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756022307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Ftg8Cl2HXuaP/w3mCrHDB4WY1tdJWndRHnslI1S8ca8=;
	b=xbD2oIzMldIY7wSdmIBqbXNcfVyEpma8pMw7Fwe8TReq42la6X7K20eGNJGE/QhBFZs4kW
	lCznPa/ygYpF3al5AuFpd1O/M/NIiu+/MoNixm5ejx7fqGPEfGXwgJi+vdNIz+rp5AvSNW
	zYsWlOnNrYx8W8+6N72PbpgbEzmXEqU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ZT864UrJ;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756022307; a=rsa-sha256;
	cv=none;
	b=T2AJDy5w1HohDtmWqkXYCxoRBnLvgjNT3MsFVVCul3zcjDo/7U49vc39hUCs7jFAa+/xQs
	W6f04meq6SZB3OovNeoKWr93uV/52T5qU04pvXrlnZvv2DPWDzbVooJcASpxJowtYXUcDG
	ewOQCaSHr1mg0PSsUnDifdkfgBn93BY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id C1B7F5C54C5;
	Sun, 24 Aug 2025 07:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15240C4CEEB;
	Sun, 24 Aug 2025 07:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756022306;
	bh=1cLI+9uAbXJ4I+vdv4vv0frefuNKK78akI/v1Ekh2vU=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=ZT864UrJtZOZTQiryYMNQ7xA8wOqXAVEqohjkhHrcmR/6qeKEe14xRVz+Rx393OCH
	 cOJzWmwqrhy36Ql3SQVfQKdx8A8UFEG1CHJHVTLfrpcRdop35KufXlP2RTi6IRCzZ9
	 W9Vgs1MzjpRfWWJBMAIQuzjUm7uDEBDPU1NsX1Lc=
Subject: Patch "mm: update memfd seal write check to include F_SEAL_WRITE" has been added to the 5.10-stable tree
To: Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,brauner@kernel.org,david@redhat.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mhocko@suse.com,mike.kravetz@oracle.com,muchun.song@linux.dev,osalvador@suse.de,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,viro@zeniv.linux.org.uk,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 24 Aug 2025 09:57:53 +0200
In-Reply-To: <20250730015406.32569-3-isaacmanjarres@google.com>
Message-ID: <2025082453-landing-krypton-14cb@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Stat-Signature: qxzhxmaqds56ug65e3icefbc8un33fow
X-Rspam-User: 
X-Rspamd-Queue-Id: A938FA0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1756022307-573131
X-HE-Meta: U2FsdGVkX184ldJWd3RQByud7Qho/YFlonN79HAcyNNkhBA0Bz8baTX+cdwf1KDEinUNYuWFFEMRa0qJB8InJo/Y8xbRBhxY87KnQQFzcSm9YLIYB1EEJgS46n6nl3hMI8EdLQEJbD0iQZ8mfUP4Vl9RaG4gSB0rsFMuS5PCxstwZWBXQpOwdO0L9Wjup7z8hnxoI1hqW+UBSHk37c363VyDAE9g1+C9A8mEZVFTupJa0BF4gtqYlzztaspUm3ct1sNvaDk6fWhI2/xuK8AZ4yb17kKmKNzyA4VmJbHuLDj5ufcLUZ566SBU1sDssoOooY+4reTmudeOFHQcWNsGr1xKvK/rmjur3Y8QKDTgYAiRfZWKcI/mO31eRkXQSfvGulXu1B1pzsOZjILkALwQRFsQUXp5OzyhBuDO0Fyc0MRFSpATboYIpFOJq/5d48fG6yfYivErEBeyW9UiyBjolOcXAEFArtX58EAk567fHj78CCGFv8UMTRDPhHmbul+HvfUKDXjTL4HSeFQBcM29/eW92pv3VkiY+8HbJVv5vOlnIN1Ju+QCSliwspvqnL+8OqovwXePIr2orNjHbkgSM5GJv6GpKjuYCzo9FLNaEpgRM9AIv2aAiRt8ERkDaURubb02GMcr1w+DGgSvjKA2FlQfQh6c3SlYZ52J/26tAC5frXbum+G7EvDUWjMt9cmZ3Q2iX8p5W8ASGnmTwETkcbXi2t/VAMhFiBQ/YnadyzRL7Nob/Rnw6Bmt6EHxf7QfXLY0m4YPxRsY+elwCxOhikXIZZFHY2RCfNkYYnRmC++m3LUQCNBomHfNqev0aiJBUZaPRWn9YsFIpJDDYMB9wyPnTfG3pDeiXcOVpfV4biAoLYpVyrZ4KFRPqWqOfb8X+AZBCflYIWQExi4GsqdeC3tmXyr4G/8nj/UJpxGx39TgMP4ux5hOafrShSpwikn+D2ABIWbIek6Y6z+RCMT
 hud3owx1
 rUPDilOKoeI6jSZSgS7YRzOdhCpOsGNqehL+40a3ktOGzBBbGNzXnhYY7308mZHnHw8vR/YPbt327Mw6K6e/hJzdwyjX0kQ8flacwcF38B3VxYkiBQuw9c9XyD8BJWo9tU1AgdfG41XtYde9V2VZaDz3yRGdQbQV3kVUfS5UXu7giFU42KxkvopD3dVxfKYUGFLbxHv7e5BlGJJpwvjx5k4lvukgHdXn93HBE1StjAdFfx/MNxCcsmoB/keLpL+3XAuy3EUPue6YoqgT3VMYsFFbtX2IXSI5gzsKuKBJsqDOjiiBcrLi1kg36PofNrb86NQUZgnzb3lOKVxAfvkN2aicRHj2tVKoO0RHGro/QV34+16tdZnOhP31Sf8FYp0mgmLKy9w0dHMbyuQpRaj76xo5aZ5yOZFWPC/NZB8Wwm6W5/gv7WDTR5UgQcce1UB/NUo9XNiPCkGVBK0XIDSReVIfXA6B9FSWNy5+Tnhsm9V6/OJ+u30/RYl2+zlAGnOY10GcOWM+NJHoVLRe7KBWcephzRE/9cuEV0lJtok96B8TsDE6XpqOXQK2hKq/YGwkImi5P7o0gK8EDl5tjt04qaViI7StaS/+wuglnmwaVMcwiNjExUjM3n0Rb4SuaneTrDjnRywc/FPzlhkAMOdGS5fcCYNLd1yBTEVVC4cmO/6eMwzhzD48K5axsK6xP8tVDivVAwzaYEIToXcw9mf8tmncQGWpSVFMxvLDvS3bq2HljB/fSxbrEJx9GRpOzkmkK4+Z13FYSx3dyYc4DfcfojCslRZRBjY8lAuhvtDxNLM+72ROfOrILjK6P526za/rAKxkvW+AQJJ0t1pZr3BCzIg9LeO3MpC1YFXJn3PlFmP6DBYcMGj+ov3ruvh1JLwZsnMpuQQKOJJxQ2HFFEIrWg2s7JY6y+rDqWf+YhRaheQ+4Cz/MZGlruNZ+smIouXQhyeLT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: update memfd seal write check to include F_SEAL_WRITE

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 3SXuJaA4KBrAYiQQScQdZQhhUiWeeWbU.SecWhUWaXbYdknVekdTQjYed.ehW@flex--isaacmanjarres.bounces.google.com Wed Jul 30 03:54:18 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:54:00 -0700
Subject: mm: update memfd seal write check to include F_SEAL_WRITE
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,  David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Lorenzo Stoakes <lstoakes@gmail.com>, Jan Kara <jack@suse.cz>,  Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,  Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,  Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <20250730015406.32569-3-isaacmanjarres@google.com>

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
@@ -3201,25 +3201,26 @@ unsigned long wp_shared_mapping_range(st
 extern int sysctl_nr_trim_pages;
 
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
@@ -2263,7 +2263,7 @@ static int shmem_mmap(struct file *file,
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-5.10/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
queue-5.10/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-5.10/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-5.10/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch

