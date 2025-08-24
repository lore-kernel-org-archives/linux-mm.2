Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C89E3CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 08:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172688E0005; Sun, 24 Aug 2025 04:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149E58E0001; Sun, 24 Aug 2025 04:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087148E0005; Sun, 24 Aug 2025 04:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4D0B8E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 04:54:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2347A160889
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 08:54:11 +0000 (UTC)
X-FDA: 83811039102.03.B8A7347
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8A32E4000B
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 08:54:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=kVlPHkiw;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756025649; a=rsa-sha256;
	cv=none;
	b=dNxC1mamGW5/ujpar1PZd+IPfixUn9vbx901aIYbRO5TZhHiFPOAKMDeWAcWVFS4Ke+Ro6
	0AQzJbKmh3M+idmPp/UTnYymn+Hxo9aoatQ/JAiaPfiIU2T3+tr1dvzWPBZZbQmdb0/yeY
	f9xs91+c73iRCNt+oHH1ChA9HgWs6jQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=kVlPHkiw;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756025649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=3cZjmAyCnxkZb1cSy/R7xQcpcyDJSUxjgPNm/VRG5wc=;
	b=V5NTK/poWIpDeMoJ9e9w+1+B1AgBZ9GJrKuqc6Kqqw5h8r8osLWRZr4Q4m42Ff+t84H0XR
	nFqTBEGdCIDe5lyA5wIOEWMkiysbGXpr0oilkzyzFevuvXhtS/HlFinZ+K5W6IfCDW9nP5
	v2wglXIZER3OcKyx7YfX8ZTeEPnHNBg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14F4540729;
	Sun, 24 Aug 2025 08:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EEDC4CEEB;
	Sun, 24 Aug 2025 08:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756025636;
	bh=FzBVT2RrWheuR0vGDx8V6lpJnmuPApB8VEmDDAku9rk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=kVlPHkiwpoXmRAZmvSPfjx5AS6kNi/Vy77qrM92IxMkIAZqxfKClNGxhz0r9UeW6p
	 dXERa93+CP8fJ2Gt/zAXgIL2RQaft7TYMWYv5RZmzztIu92Q51iSHuguUmisNLX9Tw
	 DTZxzzx941eT2aR0HAeVHMoEl2S5AxuSYoGa7Pq8=
Subject: Patch "mm: drop the assumption that VM_SHARED always implies writable" has been added to the 5.4-stable tree
To: 20230324133646.16101dfa666f253c4715d965@linux-foundation.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,brauner@kernel.org,bsegall@google.com,david@redhat.com,dietmar.eggemann@arm.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,jannh@google.com,juri.lelli@redhat.com,kees@kernel.org,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mgorman@suse.de,mhocko@suse.com,mike.kravetz@oracle.com,mingo@redhat.com,muchun.song@linux.dev,osalvador@suse.de,peterz@infradead.org,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,vincent.guittot@linaro.org,viro@zeniv.linux.org.uk,vschneid@redhat.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 24 Aug 2025 10:53:40 +0200
In-Reply-To: <20250730005818.2793577-2-isaacmanjarres@google.com>
Message-ID: <2025082440-unbroken-nerd-4d87@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Queue-Id: 8A32E4000B
X-Stat-Signature: m7sysq877nrifejhmek7gn1rx7ufqod7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756025649-319853
X-HE-Meta: U2FsdGVkX1/qClun7rxsiG9V8xcrVBLQnMw1d0qsOJcRuqfIwanvZOOvMldhE8Ve9xlMtOW7w7QmINtKutjL96bBimef7FXkMvrB2QhUi2c4mdxdC8gDz8zwj1qfXYqvkdXoWPnixsOpLBgA0Sz/4kQ1ewaoelxq64bhX5Kx4heElH8MSCmUdBYqGi5tSIqvBENenSbqOb90P54l+BBHaFryVNaOuxa8Gv91MhlECgpFLEhESWMUnfRMXzUUUJUT+mDtzddLS7vmr7sk0FNR8JFZXvRE2KL7Z4K27MNxP4Tv/b4Wl3HM87cPSJVOk1J4x9Zn7GNuoNvDSkFiyD4a+2i4RIW6KUYHQtMfZjw8ljRGoU042Oap9HGQdJIQcdmvermZz0wJzGtwHU4oqtsi5UOwp5vFNSspERgI9uY4j0aPAvUjNZoLr3dj6k3sbow8iHXBeTZ/FfMr4kO1RR8Am1Igq/BT9vV7yGFLawnc9A7EH2ExwFIWpmA/a627vCMe2+0wSuKdK+52CPmfpMvcZdRYBVYKJJpcF1VJIrtIJruPsd7IiEv+3H/7ZUv7n3lOjYQoZv5muvTzejhIA0EjrLBeLmWaNkyDz2rV/Yd/CoiTQYru4NMRLQvX1aEL0HG6IEEcbPOZ4N18epF4gHskw9CznXari8fgIoticEviqjnC+uyCxjGh3S7+eNTMwM0atHodgtzfcOSvaUNLGkPTn4Ko9/uKueIaY/wNUuEiVlueVoz545Zt9fmmaXRdvsY9pWLcN+uSBDzrcyE8YwtECbeIpMyHJwzxtmyR37h5XNOar2G2fD6wD/ijFW11RifkwGO1//Ajcs9ca5/yUoQ93jCg+uOkgoVcjylHBMer6JGcAvi0xSlUHX2rOQAt/SWhnrzPWhTz2VZ9TF3IkUX95/ycHoTQYv4GTp03uGl93Nh/VhSVidd9BzWgW/aecrxAWrILbcrrdZEVhDfsYfx
 BaGdKAfT
 b11OcTq4P4P54XjgDsdgPcS1PtuYmZ/0EWih9pqNEYRK9tB4Sq4piLMGC1Xbkz5m5rqg+BEFyxMEI2cXgLQvkyAS5UG18mucqn7dm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: drop the assumption that VM_SHARED always implies writable

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165153-greg=kroah.com@vger.kernel.org Wed Jul 30 02:58:50 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 17:58:06 -0700
Subject: mm: drop the assumption that VM_SHARED always implies writable
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,  David Hildenbrand <david@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,  Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,  Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,  Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,  Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>,  Pedro Falcato <pfalcato@s
 use.de>,
  Hugh Dickins <hughd@google.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, linux-mm@kvack.org,  linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,  Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>,  Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <20250730005818.2793577-2-isaacmanjarres@google.com>

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
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |    4 ++--
 include/linux/mm.h |   11 +++++++++++
 kernel/fork.c      |    2 +-
 mm/filemap.c       |    2 +-
 mm/madvise.c       |    2 +-
 mm/mmap.c          |   10 +++++-----
 6 files changed, 21 insertions(+), 10 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -430,7 +430,7 @@ int pagecache_write_end(struct file *, s
  * @host: Owner, either the inode or the block_device.
  * @i_pages: Cached pages.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -553,7 +553,7 @@ static inline int mapping_mapped(struct
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap_pgoff
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap_pgoff
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -549,6 +549,17 @@ static inline bool vma_is_anonymous(stru
 	return !vma->vm_ops;
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
@@ -566,7 +566,7 @@ static __latent_entropy int dup_mmap(str
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				atomic_inc(&mapping->i_mmap_writable);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2876,7 +2876,7 @@ int generic_file_mmap(struct file * file
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
@@ -839,7 +839,7 @@ static long madvise_remove(struct vm_are
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -141,7 +141,7 @@ static void __remove_shared_vm_struct(st
 {
 	if (vma->vm_flags & VM_DENYWRITE)
 		atomic_inc(&file_inode(file)->i_writecount);
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -619,7 +619,7 @@ static void __vma_link_file(struct vm_ar
 
 		if (vma->vm_flags & VM_DENYWRITE)
 			atomic_dec(&file_inode(file)->i_writecount);
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			atomic_inc(&mapping->i_mmap_writable);
 
 		flush_dcache_mmap_lock(mapping);
@@ -1785,7 +1785,7 @@ unsigned long mmap_region(struct file *f
 			if (error)
 				goto free_vma;
 		}
-		if (vm_flags & VM_SHARED) {
+		if (is_shared_maywrite(vm_flags)) {
 			error = mapping_map_writable(file->f_mapping);
 			if (error)
 				goto allow_write_and_free_vma;
@@ -1823,7 +1823,7 @@ unsigned long mmap_region(struct file *f
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
 	if (file) {
-		if (vm_flags & VM_SHARED)
+		if (is_shared_maywrite(vm_flags))
 			mapping_unmap_writable(file->f_mapping);
 		if (vm_flags & VM_DENYWRITE)
 			allow_write_access(file);
@@ -1864,7 +1864,7 @@ unmap_and_free_vma:
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
-	if (vm_flags & VM_SHARED)
+	if (is_shared_maywrite(vm_flags))
 		mapping_unmap_writable(file->f_mapping);
 allow_write_and_free_vma:
 	if (vm_flags & VM_DENYWRITE)


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-5.4/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
queue-5.4/mm-perform-the-mapping_map_writable-check-after-call_mmap.patch
queue-5.4/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch

