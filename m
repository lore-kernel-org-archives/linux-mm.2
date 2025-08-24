Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06200CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 07:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1CF6B0008; Sun, 24 Aug 2025 03:58:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B1E6B0092; Sun, 24 Aug 2025 03:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0896B0095; Sun, 24 Aug 2025 03:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A2EBF6B0008
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 03:58:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2817F5B757
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 07:58:27 +0000 (UTC)
X-FDA: 83810898654.30.5885F7D
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4E6694000F
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 07:58:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="xd3dZ/pU";
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756022305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=slUmkYOrTSY0veb5L5dRln/m9zNUvyNkP+tgerLHGc8=;
	b=4+ia2Bkqc3GIHUe4Mbt3+UVFsXWqRrdDr/CzY2CQpFeht3uJ43EcE40hydJr7URJItoeAG
	V/XAWD05UmztRF+WCa2WSyDHvQ8wZcTrhqh0Mg39XSNZN+dUDAg54GS5zEq5kNwNo8i4DO
	8y0K9xSS7I/2kyB5WHd1l5gqVgC/5jw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756022305; a=rsa-sha256;
	cv=none;
	b=lQxVA+sjpzVCqFh4xGsQK4i+qaH8jQxx7HEuoaHEqrH4i7TZtlYmGA0UcCSoXXxLkqsMwl
	F7RRgRMvn2HosR7JiFdA5EGunGK+SNZgorZpRli7dkHyNhiTBtQNj3CRDn+aVa1UA4lJm5
	Kj7ZpmE3jNSIEjTSIK8fB35vW2xXxNk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="xd3dZ/pU";
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id E67165C5115;
	Sun, 24 Aug 2025 07:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09679C4CEEB;
	Sun, 24 Aug 2025 07:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756022303;
	bh=Xl7fDAkPrzGhj4EuyO2C/XdBEFuxeBu/uK/M+/MF61k=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=xd3dZ/pUkeKsyPjF4qWL2Tbi5MH14nOt5XqYCxk8XfIE4B5BjB88pD4s/wYRCCB28
	 FwkQ6L6KBCSTAHyBhSNCdim/Jo+uvEoFuirXo2MXjaWxTXz1cPjbrpXeP1gtjN+nPj
	 Id4jF1NCtEPyZbJEBv3MUz6fwZT6nizw4QE6mCP0=
Subject: Patch "mm: drop the assumption that VM_SHARED always implies writable" has been added to the 5.10-stable tree
To: 20230324133646.16101dfa666f253c4715d965@linux-foundation.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,brauner@kernel.org,bsegall@google.com,david@redhat.com,dietmar.eggemann@arm.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,jannh@google.com,juri.lelli@redhat.com,kees@kernel.org,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mgorman@suse.de,mhocko@suse.com,mike.kravetz@oracle.com,mingo@redhat.com,muchun.song@linux.dev,peterz@infradead.org,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,vincent.guittot@linaro.org,viro@zeniv.linux.org.uk,vschneid@redhat.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 24 Aug 2025 09:57:52 +0200
In-Reply-To: <20250730015406.32569-2-isaacmanjarres@google.com>
Message-ID: <2025082452-legislate-scalding-1d23@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E6694000F
X-Stat-Signature: hhpnknwmyydfd7wuw3oy7esgzzp4wxy7
X-HE-Tag: 1756022305-97432
X-HE-Meta: U2FsdGVkX18PqOlOBeer5oMneQseVoBVM0flBSmgjizs76MYskhTE2nsnfRCDXUbv7cgIbJViXWVP7eyWFtmJlM2r1yrsQm+VWiq9xU3KzCefmxDK1AIWnsLqmAWkt2GaC/RRShZRnA80YYc/9365Vt/Lhj9nTLXR6X6VcCthfRAhi9KchPC7tjtORDZbuGhUdPUvT6v13IW9g+p2EDr4pezqPiyh9axrSC+zq4tQ0SC32yBCo5aaBGapQUIB9Nk1t4sLip91qp36sLDUcjUeV2WcbR2bwj42DS18jdcMIJvU+2Yxd0HOoBxG/VcCiYadp94AYHnTaCcjc33LFQdknUKwjhTE2VjFtTGqot9sw5Bgg/Trz6WgHjqVpmONY04YcqbZeSOyv9eO7BxDqHfa2zBxJOxcSpqRh2yUrKxv7ItxxT+vQG5yKmFhzsj7FwvrLQL2QTg4J3WOb6dRGKymnHI5nXxbMfZWvAH/ynTNj2jFzSqUrdp4t9+HJi/OxWSnES4WLNLBjKsYiSklg43+FvCFYDvwhx8UAMMLu0A2r8caQFUhFRvU1cMKDg5kk58wqXjsW99yqMETgu04oiFqWABTjzEFiowYIY7iWu43tFvyqjEP4zOqMZu+RkCWblDvIS8uYIxO9sGVhfDaTzSks9jS9u0xcK3GYgvH4Yw8D/a7/UfTm2ojDOGiliDup+p0NxtyU/LJyhS+WajAWTuFmO54UI9FCQKMWaQ9u+ntH0KzIxs18zL5HbIp6pxNNPJcutRD3HKB3G8f6Xu3MO0ITbbkC5KZlleW7k8rRszXhIrIqGntiJ2H9Q4hksas4ELklD7D7epvUDnw7bWWKIKtYwNGOLqRSDC3svgyaXFim42EjLSTmBhF+HGW233nlCnkEg9iQ5jkf6hYZzFdQq+U3Az7wWIZoeIK/zrZj2+va1nFJnB2Ob7Dix4yqxQJZXBf7jxh/GdLscOXsEYE5V
 jRXT+UBB
 A35Z1/yWmKCc2H2WBiVLeMt10AiZ1GsJi/oeuD91iy1bywgdDTfsM8GQUsuS6m6nnU0Pt30sQQyyEjFj5YgdIoo2GbfkzmacpRkLIGPMyJq3iKRlUfFYSPfADVW5QPF/Hcb5k9VDXacHLZy2xc/wQcqgx3P6T0SWBMKxWpWWSTojAANtEdd+6QdqRztFI8XaMvIulyJhH59ZLeHRZaScYJu8tPJU+Sn23s6Q8beYCfBeYb5cAqkLaDhhbDElQbzB1RXvSH8kFJwQO931ss40GOtVtLIJrzqz+4qYwmVDGsznFQRQlNgbM8fqC7HrVOeN9DSIcek7EY1kQr5l4d0LrPbM+fPCBWWwEkbsk+gcsKGjfvJYE9piCVDQo6h6jkNX92MJKeEDQhMvv5tbSTrg/gJeSYTSIvBlzXjs92xw6JA7UFaK3gkoYuinwm5qoungCmYt94aowZPlPXlR9dia7ovuLLYNH+nIHSszRuakwSo6d2rB5upOOc+WXqymp2Ct/jxao30mvrfucydyhxp2KRgnmU6UMC+/CJJ1ALBKQ2KlCyOWBkb4j+5lQSPFtHWSifyIlQn6gs5KWZ10lr1mNHoVTDJvDV9PBlGzOO5oUdAyujl0jE3kDsOmXX+c9wxCNkqtTgItuP3WcEuYoMz1GrUUU0M/nbY0JNav/Q8vhCxTSuIi7ksmObbXfGqz7GmVzJ0yhE4fJuCB4OCAcEeH/XZg9QDng7FoPvG5B1Tq7DC2gkXiIHlRYNLbRuKCCrS0w7auG2/RVVk7JQE82133Xx77tp3L2bTIhOdzF0Ab77iO7u7bpyKgXig6Z9L+P9tkYHCp2wiW6ATmBbU7tMG4BTPSHm4CABJ0kHh8LlnFZcf9c72qbF0acsFdrECBAXP2w1ACGmMIu6UTvH49jMa3KIOaitd8CO9bfXp2PDnr1Zlp8cUMFgjkkyemiPk2+QCpKOSHkzRL1e6nzlXTNqbrlpmUfILHw
 FXgKd9XY
 dhPywU1rptvYXS8QLFMA1QuxkKhznxkqOG8CIRSuzDdH49Ri9DeKDhJacXzbTsCIJkKBEcBGKVuAHREYB1k4UNgaA3AhtGbB4zeQYQP4fSwsnvcpAT8S/Y1SzF4GuZuk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: drop the assumption that VM_SHARED always implies writable

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 3RnuJaA4KBq0VfNNPZNaWNeeRfTbbTYR.PbZTeRTXUYVahkSbhaQNgVba.beT@flex--isaacmanjarres.bounces.google.com Wed Jul 30 03:54:15 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:53:59 -0700
Subject: mm: drop the assumption that VM_SHARED always implies writable
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,  Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,  Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,  Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>,  Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>, Hugh Dickins <hughd@google.com>,  Mike Kravetz <mike.kravetz@oracle.com>, Muchun Song <muchun.song@linux.dev>,  linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Message-ID: <20250730015406.32569-2-isaacmanjarres@google.com>

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
@@ -436,7 +436,7 @@ int pagecache_write_end(struct file *, s
  * @host: Owner, either the inode or the block_device.
  * @i_pages: Cached pages.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -535,7 +535,7 @@ static inline int mapping_mapped(struct
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -666,6 +666,17 @@ static inline bool vma_is_accessible(str
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
@@ -561,7 +561,7 @@ static __latent_entropy int dup_mmap(str
 			if (tmp->vm_flags & VM_DENYWRITE)
 				put_write_access(inode);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2959,7 +2959,7 @@ int generic_file_mmap(struct file * file
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
@@ -848,7 +848,7 @@ static long madvise_remove(struct vm_are
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -144,7 +144,7 @@ static void __remove_shared_vm_struct(st
 {
 	if (vma->vm_flags & VM_DENYWRITE)
 		allow_write_access(file);
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -663,7 +663,7 @@ static void __vma_link_file(struct vm_ar
 
 		if (vma->vm_flags & VM_DENYWRITE)
 			put_write_access(file_inode(file));
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(mapping);
 
 		flush_dcache_mmap_lock(mapping);
@@ -2942,7 +2942,7 @@ unsigned long mmap_region(struct file *f
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && (vm_flags & VM_SHARED)) {
+	if (file && is_shared_maywrite(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-5.10/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
queue-5.10/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-5.10/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-5.10/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch

