Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48583CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814F08E0081; Fri, 22 Aug 2025 04:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F078E0056; Fri, 22 Aug 2025 04:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D228E0081; Fri, 22 Aug 2025 04:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5454E8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:26:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 220DA1406BC
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:26:18 +0000 (UTC)
X-FDA: 83803711236.13.99C30F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5352F80006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:26:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=g8iODTFB;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755851176; a=rsa-sha256;
	cv=none;
	b=OK+b1nCFOrHjo1VrM/3fXGGetSs28xUbxe2O6ZDRHmiEDipMfXwQKO3tV34ommAigIgQCq
	Plbi5wI29Qc98ZSCUmd8gfOBp5n5FRYgLaqcJNQncfiehhlt5RSD1jHUsQYFTi7O1WIDjj
	XJl4EhtreT1IfqIcAMbbNSckqWDcrXE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=g8iODTFB;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755851176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=dLVaAUvgbp0lAyleb/edU3Ng39dz3X+9ydCBtvN8TGo=;
	b=uqepvgbuSH0fL3Z7Jj8cxFup7DNmLZlTxEt3qhdSLb6EWUGtPq+0tWmuYUXAkCNG20RgcS
	mkGvWvuITjKFe1NW52HLtcUP9Bxe+66XVk0UtuFx77VVyn+hZ2wUbOMGopcjVrSypdq0N/
	iHlaJCQwMfqc6rTwOhBDmrWNId+RKbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFB7A44C63;
	Fri, 22 Aug 2025 08:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5FFC4CEF1;
	Fri, 22 Aug 2025 08:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755851174;
	bh=XlioSjdWZfVw3qSe0B9YKADl0bSx2EpBj8ze080WeqA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=g8iODTFBcsB3PDeQ1v/uDN8CcdczXM2zAO7fcFxy++Qu+cW9spHj0W6Cw1RkdGpWD
	 El+kV+Z8rj64UpUgR5oTggDxaO191pC9MHIzI3P75K3FT1SZa+GoafamDbOWNx6uUf
	 29581bjp1axzrfJtUJJ86Z7DC1BJjHeWLB/JXUfM=
Subject: Patch "mm: update memfd seal write check to include F_SEAL_WRITE" has been added to the 6.6-stable tree
To: Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,brauner@kernel.org,david@redhat.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mhocko@suse.com,mike.kravetz@oracle.com,muchun.song@linux.dev,osalvador@suse.de,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,viro@zeniv.linux.org.uk,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 22 Aug 2025 10:26:01 +0200
In-Reply-To: <20250730015152.29758-3-isaacmanjarres@google.com>
Message-ID: <2025082200-elude-until-b70e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5352F80006
X-Stat-Signature: uhink5xydebkwzzg5jhetzwcdodjeko7
X-HE-Tag: 1755851176-236406
X-HE-Meta: U2FsdGVkX18HaN1QZw2M1BgiO42aXJ8gJe+R0weRgA900NevZbx3q85I7ctflLY0eF8P9Csb+lkDJecD4atEZwd9z0WRxoYWDl3XFfTHPfc01oJvkVvzKcXUA0xcfZRG4mFKFG2rdXAAW7NeXUvM1ssHxSNlltYnLmLtZsbQgTRxW/XNtSKRNMG5PzcYNyc1vBgI2dn57BUA/83+PY6Wnq6jk8VI0aVUEcXQ5xgBxSrYImkIAkw9efBuwhD2JymWXoBhscBLdvxEYWeP5Enj1+B/yECJlwr5GIGlkTBBzWyK3GWEtLs9qGuzNVsWaOOsM4H54lE9mxC2nH4IbV2kNNyl4noSjPuV8MBVLACDfg9E3TDfowikD3Vw/olhdPxl8MlGnM7+zWI8gipxDVX4Nm2dYDHy1ew/PDQcCGn6SquSACuW9BMrIfJNTnaOY0SBGDzDhQvp87jkkOwjiTipl4PYVS/KHnybH3x1D5lfSSmFA5CCxNvU/5gyqwgMEhBhZJLHI4OwIXGlDbLzF2hMgWfViI5c2eTQ33uu7NmTycF1cpZqSXGE5wba+28vkCd/FYZjig50AXZ1GCPA4R/WthijPYQPwmZXi3GnTYiQzJR84z7OzsqhfxFFIqLUAuaIGxjHQ8RndlgXRnbi9+3gYQlFrIjvSAhBqTcng24p9GI0ddPMBAZNhKzjezMYGVcKrVBkiaAptG5oqcFltEUcCgukDimsrh3I9Cbk+iStw1DNX+LtfYdLnyq3nwmCiEmilH2oRqExj0amZQa2AGdxS/3VqMG6pqFLWqkV7BQFZAKy5jI1YOsZ2NMHBZqaLcC+n4e5x7NQ33qgFHJ708+95Dbpx8jLkVBmjNWAX0sV2pLcvMDHBo+0gZTQT98IfzpXlI78I/uqZLVKu/dObkXBDYqbCl2bJQSXptvnGa3AugiXXdKlrakqkeooI/Xm7CfjPvfPebyWXZN5JKCjp3F
 oiJFTkUR
 AbjFixl1dpZpnqDGfrpumScvo3CmG04buJqTS3ilnjAqRjmpODZhc9Ys1ztqFz0ahJA7dSrzK9lnYNDcxUUrioucA0ZBniTuptANS97CJOkC8J/GImnRNPgs+iTuLfFv+SjmAgcei2yRj2WPZCpZ0DKjx6RHwyiMCZUzDtGd2oM4kY3nfRfjqd9R1/YJBYve/kF4sWwDSyYB+6gJTr2FfUV+HU77D6elYNaL4b+ysYhVFW3BLpapd50y2u7MyjDrgdMfB/K5iJzqCo97VoofxrGb8x8UjGYHKZSPc98Uy9bqO2PXxXFhZyVjRNGXlec4CrwD4Zg5WfhFjGnsmOfJVLHjDw58utXszskIwLVK3HG7Mnmdm5BO/GBDbkMVqSVPTLvjGxZEoS/g+3ieHjVtnI4Mrw5dZUiooQmEEtKd9nmt+mvvL7w2i5Yq7VCdyKC3QNR9ktnuw0J5dGIty9ndQsDwVq/Qc/jkBkW0CAHeJoAZc5HEUGJGYua6cChkF7xnxqBpIOBFUdWo02GoekMzt3fwuH4L05FaSTx+qafjwr9Q2Ie7Us1EeBkJljJvgS7Lz2nP05E+5OBqZAZ05A+gF8hPJifjfJwzMnjLCK406buOka+OVL5ZBcMSrJFLwA0niajJH3N8s7N1O86FrYitfa4bXpm9XLFCewWPGAObRwTpxxcXvOoLqhvarnafyy6JrN+obNOGxz82dleoTbuFg3YoqFxvHIQSOItyJNcUJ9Wh8J5DBsObT9vvHg/BgTfYduFakKyHcoAEaRXGk7gIgQQg0JD/Fmz21U4ib4gzgtOhbC51D2znTfLpeXqAO7b8s4mjaF6BgKJqGFZZiQiyYA7oAV8ct1+m50QVLc/6bRF+FUPOp2L8gD1Jnmcd7DLjyAMKXhDIAk/WTNYQRJpRFrPMbOkm/PBB3IEiEEB84gPmyO6iktt7TFJHHs3hT0ft0CKCF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: update memfd seal write check to include F_SEAL_WRITE

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165160-greg=kroah.com@vger.kernel.org Wed Jul 30 03:52:41 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:51:46 -0700
Subject: mm: update memfd seal write check to include F_SEAL_WRITE
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,  David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Lorenzo Stoakes <lstoakes@gmail.com>, Jan Kara <jack@suse.cz>,  Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,  Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,  Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <20250730015152.29758-3-isaacmanjarres@google.com>

From: "Isaac J. Manjarres" <isaacmanjarres@google.com>

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
@@ -136,7 +136,7 @@ static int hugetlbfs_file_mmap(struct fi
 	vm_flags_set(vma, VM_HUGETLB | VM_DONTEXPAND);
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4023,25 +4023,26 @@ static inline void mem_dump_obj(void *ob
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
@@ -2396,7 +2396,7 @@ static int shmem_mmap(struct file *file,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-6.6/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
queue-6.6/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-6.6/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-6.6/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

