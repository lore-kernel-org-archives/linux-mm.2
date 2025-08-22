Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691EACA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5A58E00A9; Fri, 22 Aug 2025 09:28:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD6D8E009D; Fri, 22 Aug 2025 09:28:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAD08E00A9; Fri, 22 Aug 2025 09:28:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF148E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:28:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25D36140196
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:28:17 +0000 (UTC)
X-FDA: 83804472234.03.15ED4F9
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6BD3EC0005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:28:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=kUqXeLIe;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755869295; a=rsa-sha256;
	cv=none;
	b=ncrumS7yLVxcBnANfZAJxIUL1yX3CbEvbqfWWGVB8qK/oWE17qSr7OebJsDTwSyijCyQMp
	B7rQ6lmGSSEhbAYOAMQUIAxJaZrHOsGWyZHnBqvgd2QjL8vI1r4fFLzyqPxNUHSHXII5Ka
	XVuExWsp73vQnYtjggS9zfY+0S+ffyU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=kUqXeLIe;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755869295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=enPTleglpChGZ2dTDFDpdZLXBT0VZ+AbWI20bCM+e1o=;
	b=yqUs4q1frfuF37gl+xSgaUP7chZbl1YGhuJS33YVSv3CU2r/2giNjYVixbZO/3xZ4TIrki
	nmiS5FcE6RuFnOWI+fi7+RFr3hMJciVSUct8MQaqD8ZfcT6VerJD2nOIHWXzAA4HfLb/4F
	2A0eE5YuirO3c8kbp4fxT+Q7ktf7Yqo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 966DCA587D8;
	Fri, 22 Aug 2025 13:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C93C4CEED;
	Fri, 22 Aug 2025 13:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755869294;
	bh=21KyaomW/fZv1pEUDNaWCdz4K4naduREXkGo9CYUPPo=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=kUqXeLIewdtONLD5zDQbMe4CwxEkMtAeIfvEOChs3mui40olIX3ZmI42pSLrBUmch
	 adKvdI6WJ2vCnoUUjj1g+n2+WvZFBSs36D2pZJs5jG2iYxp9GMignqRG+9rYQfKNby
	 55iqtbFMFt6bUaySqx2ZyGpoR/8olbOz3vQmsJXM=
Subject: Patch "mm: drop the assumption that VM_SHARED always implies writable" has been added to the 5.15-stable tree
To: 20230324133646.16101dfa666f253c4715d965@linux-foundation.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,brauner@kernel.org,bsegall@google.com,david@redhat.com,dietmar.eggemann@arm.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,jannh@google.com,juri.lelli@redhat.com,kees@kernel.org,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mgorman@suse.de,mhocko@suse.com,mike.kravetz@oracle.com,mingo@redhat.com,muchun.song@linux.dev,peterz@infradead.org,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,vincent.guittot@linaro.org,viro@zeniv.linux.org.uk,vschneid@redhat.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 22 Aug 2025 15:28:10 +0200
In-Reply-To: <20250730015337.31730-2-isaacmanjarres@google.com>
Message-ID: <2025082210-junkman-cider-e6cd@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BD3EC0005
X-Stat-Signature: ktjdfnheaxge9c14nf599btugkuhumig
X-HE-Tag: 1755869295-950184
X-HE-Meta: U2FsdGVkX1+jl2SbJAmHnhr+MD0qEJdNnHD6DiuOzpWC5E9Tu814bKX5O5A6MSbjMfdDsgkwUw9MfJm7umdKt4Q38zFb+8zCdmRS3o4pjMwsQLxOIEtkuJmQ2nuSAxpnMMVS74l2GmP1U4f3j2HLA/aerNMRqpbP4OA1kpKe7qnEqgrZ66StZqkfltF6Igw2WWgZaDSAy1ABQvpA0JofepU0tJxcu/SCm5WLoNaGztNaY1nYQiTa+DufaNxzFvyDQVhWrt2dCwQg+Clle9xzulr41ihQBbrk/B+DM5sgj1745jsAljpu3GEjgyzRkkryj1iE5MTUirK/D2NMtcsLbTk/KunYefCA5NJ69aMPD1zgKXmp4DfHt2KjjLU1vQr56GE68gRoY43l8yiEnLkeEGqoeT9QY1YflfQdLzNLQIELoXiY04QlJFFPbuMX+MpqhUU9NCyQAguO4D/CBmRmTmCGgZLXUfBvB6hJA9elFva7Vpt+3bQs6tg9tgusEr1U2nFSUtMq+49xT7cjKXnZdv6mMVCOMu/MzHSQtgvW+KdOuNutuJk8czjGXBIP1k/xczhIwWYCijnCQ8W1u5vIYFiTX+IrK/UQ5ny8jH7Px7A5tRyD+yqgTmTGYVnnQK3niRF1AOk3Lg/4zadxDzspYQjonr/xo9evtyY8IuY+QbV2YCydKNwNagdv3LKF0+aumAVKct+5LT5xbZIJom4aKMAVkaM6hRXMt0hfTRO8Tqc99gGz02u/xV+G6dJiRbsSWrcd5Rp8cv9zI3QTwRJKfrYHFNjlMhXEmjsnNKvT3czirkTAHp7y2phJsHUYtdRvjrbXyC9MBkPwSJpnYL9/ASxzr/D0kf6hKrn+CKcav3JDE/UodX2mfE+WkKH0rOAeqAT093hzb9O/cbYXsY2TpSNREWgkKTXHqE2bxo5mhqo7ycn1yVms+dbnS4aOg4Yi9HxgCZJyqIORl6E4g/+
 QTxP2xGE
 JgEGyWKLvHW7uEp0lx0TQMp2wP3//JTRz8ImvAc13W2T4hLONLqLAVsx2k/nqUph8tJ2XNjHJLUeWZ3kE7eNXUe5tEd8epvs/B4+lbQNQflGF6GqiaHbVBoRaItjgo5J3k7P3K1WRcxuKwmXdINDnhFOMa4QV3VJaS8crsSRVlXQC+z+Zo7aQEx6PKfoIey9Ns5hnyAZGGSyZ1ojUWpO4eUJ0T9Y9ohbZsINOwQm2YzG8ojoHljFutQvHc9m/jlupTX7hZkrYabL/L9a7KV4rajByEbRHjkmuHssDCssPQQQITlEuzX7e0NNAhXFNlL7Mv8YnJh260X4n85nChOLzVCK3j79bBdwzWVrhxyZsNP+AEcxy9dvoUyDQ2e7THHSuamiKfTV8nlMV5MhI9B1KIu5kyc1Qfx+gMtBG3VmB6QSXNd8EpKxrS0dff1qUbaCCrGNcjhdFFLp6EodWwyw6ikbHpQyv3/nOMQL6HUqLIW4wSIJ2k4SsJSz2Tp7wn3YtXyLLt2dinUTXuNdf2GkNNhQnC/7lGlsFKGrpYfIuLc9O19ymz01NMEa/mMKL7BG1fyqhIF3q07kDZgZOxMMNujZKpAxuXtMNyhEY+YiXyARLsJZW8KVTOsYQsOIXpQE5uBvZWKez5BkVwMYSRLbCR85whuy7K+ktw1iDuQFqpxuGw3NL6zrjhpvbuxdYN7mzQEJv/YwLGaqWRqh5+apkkA8zeRGGqfvOu5mlaHx2UAzioqmiBTEkyXqLLGuPQh4iRUm0erud0/zxrfR/siKOOFHZxogFqX1YQ8oERzX5Wp4z5XHaH0niw7RqPXPg4Kc4jOuDAfG1uhbKK+7Z45zFxknlxqymBHy7jDp8j73OgXQS8x8nmgwSXWqqGkW8yxiJpkaNCFRQ39WTwwTZDJt4djoicEcuIgjeZ8GgedJwQExNGotdhDtVk4Nu9GsQHHx7y98Q/e0PABlNNZllf1ux2FVXkwba
 EBnJcurQ
 SOYwaHNs5/g9qJjS3Qu2lCHlq375Q5YWd4IBbLH4btDK4lDc/N0abr8JYS6NAHa2Uxm8KQquVCbMtyH6nowNiW/qfLk2+oQM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: drop the assumption that VM_SHARED always implies writable

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165169-greg=kroah.com@vger.kernel.org Wed Jul 30 03:54:58 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:53:30 -0700
Subject: mm: drop the assumption that VM_SHARED always implies writable
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,  Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,  Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,  Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>,  Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>, Hugh Dickins <hughd@google.com>,  Mike Kravetz <mike.kravetz@oracle.com>, Muchun Song <muchun.song@linux.dev>,  linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Message-ID: <20250730015337.31730-2-isaacmanjarres@google.com>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit e8e17ee90eaf650c855adb0a3e5e965fd6692ff1 ]

Patch series "permit write-sealed memfd read-only shared mappings", v4.

The man page for fcntl() describing memfd file seals states the following
about F_SEAL_WRITE:-

    Furthermore, trying to create new shared, writable memory-mappings via
    mmap(2) will also fail with EPERM.

With emphasis on 'writable'.  In turns out in fact that currently the
kernel simply disallows all new shared memory mappings for a memfd with
F_SEAL_WRITE applied, rendering this documentation inaccurate.

This matters because users are therefore unable to obtain a shared mapping
to a memfd after write sealing altogether, which limits their usefulness.
This was reported in the discussion thread [1] originating from a bug
report [2].

This is a product of both using the struct address_space->i_mmap_writable
atomic counter to determine whether writing may be permitted, and the
kernel adjusting this counter when any VM_SHARED mapping is performed and
more generally implicitly assuming VM_SHARED implies writable.

It seems sensible that we should only update this mapping if VM_MAYWRITE
is specified, i.e.  whether it is possible that this mapping could at any
point be written to.

If we do so then all we need to do to permit write seals to function as
documented is to clear VM_MAYWRITE when mapping read-only.  It turns out
this functionality already exists for F_SEAL_FUTURE_WRITE - we can
therefore simply adapt this logic to do the same for F_SEAL_WRITE.

We then hit a chicken and egg situation in mmap_region() where the check
for VM_MAYWRITE occurs before we are able to clear this flag.  To work
around this, perform this check after we invoke call_mmap(), with careful
consideration of error paths.

Thanks to Andy Lutomirski for the suggestion!

[1]:https://lore.kernel.org/all/20230324133646.16101dfa666f253c4715d965@linux-foundation.org/
[2]:https://bugzilla.kernel.org/show_bug.cgi?id=217238

This patch (of 3):

There is a general assumption that VMAs with the VM_SHARED flag set are
writable.  If the VM_MAYWRITE flag is not set, then this is simply not the
case.

Update those checks which affect the struct address_space->i_mmap_writable
field to explicitly test for this by introducing
[vma_]is_shared_maywrite() helper functions.

This remains entirely conservative, as the lack of VM_MAYWRITE guarantees
that the VMA cannot be written to.

Link: https://lkml.kernel.org/r/cover.1697116581.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/d978aefefa83ec42d18dfa964ad180dbcde34795.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
[isaacmanjarres: resolved merge conflicts due to
due to refactoring that happened in upstream commit
5de195060b2e ("mm: resolve faulty mmap_region() error path behaviour")]
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |    4 ++--
 include/linux/mm.h |   11 +++++++++++
 kernel/fork.c      |    2 +-
 mm/filemap.c       |    2 +-
 mm/madvise.c       |    2 +-
 mm/mmap.c          |    6 +++---
 6 files changed, 19 insertions(+), 8 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -444,7 +444,7 @@ int pagecache_write_end(struct file *, s
  *   It is also used to block modification of page cache contents through
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -542,7 +542,7 @@ static inline int mapping_mapped(struct
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -706,6 +706,17 @@ static inline bool vma_is_accessible(str
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
+static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+{
+	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
+		(VM_SHARED | VM_MAYWRITE);
+}
+
+static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
+{
+	return is_shared_maywrite(vma->vm_flags);
+}
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -580,7 +580,7 @@ static __latent_entropy int dup_mmap(str
 
 			get_file(file);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3408,7 +3408,7 @@ int generic_file_mmap(struct file *file,
  */
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+	if (vma_is_shared_maywrite(vma))
 		return -EINVAL;
 	return generic_file_mmap(file, vma);
 }
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -908,7 +908,7 @@ static long madvise_remove(struct vm_are
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -148,7 +148,7 @@ void vma_set_page_prot(struct vm_area_st
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -664,7 +664,7 @@ static void __vma_link_file(struct vm_ar
 	if (file) {
 		struct address_space *mapping = file->f_mapping;
 
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(mapping);
 
 		flush_dcache_mmap_lock(mapping);
@@ -2918,7 +2918,7 @@ unsigned long mmap_region(struct file *f
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && (vm_flags & VM_SHARED)) {
+	if (file && is_shared_maywrite(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-5.15/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
queue-5.15/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-5.15/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-5.15/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

