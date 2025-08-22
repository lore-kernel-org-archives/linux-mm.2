Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 622E9CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A8E6B010C; Fri, 22 Aug 2025 09:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BC56B010D; Fri, 22 Aug 2025 09:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5411A6B010E; Fri, 22 Aug 2025 09:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF6B6B010C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:11:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80EDC56593
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:11:26 +0000 (UTC)
X-FDA: 83804429772.29.3C396D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B30D9160017
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:11:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Wzt2aPBJ;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755868284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=95pmFDrJ/vz2JDQ4EHuXt1CLi8LBlKjQfv3kPrMK62o=;
	b=B3JpWfvlQLkeqqV3eCMEsVRDYYc+LlgF5JQk2BTp2qQHpwJFasnmzc2ayPP2YxBdvCKTfb
	cgRVYyXhDDtNAwN+DBKOwt7Zy8qnEP/HDLLhXF781j96QtUVamUbLAeEkXa/3P9/916J9V
	UTt2IZ/ILBszOVs3I3e1XqdE4XOdDmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755868284; a=rsa-sha256;
	cv=none;
	b=r8GCJ/2EJhHeMZpNlYbhulBgf6THIbpiCPJr9m8Hr1F5/wUAMmgIH5E1sL1FLaVdbw3lEp
	YZ+/9wDlyOYI4Dl4KQsUlD7jsEEFt29muz/Z2VvREw9pCPbw+kvjStgGK308Fpz+eTlhvH
	GsGxT/VdIv6Osu6ZT8wdyD3GFtl7YR4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Wzt2aPBJ;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D296A60268;
	Fri, 22 Aug 2025 13:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BD5C4CEED;
	Fri, 22 Aug 2025 13:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755868283;
	bh=La6GpC0xCnSCpJYf85O36xC28AMkgTRE9MSR+qi9W2c=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Wzt2aPBJ7oo9KV7j4jrhYTSgA69SyNyAKqkk9R8gjGmDmyz7HUSSoSCSSkVt/9Wy8
	 1NZPVptBAIOtmrJAuT4aQ93Htvc8ZijcGZVci+ezDMU/UW0fIz6yINmAg7XR5KOpXC
	 f8GVxJVTgIhut58bWC5xwDLUefaSHbHfc1VovCXA=
Subject: Patch "mm: drop the assumption that VM_SHARED always implies writable" has been added to the 6.1-stable tree
To: 20230324133646.16101dfa666f253c4715d965@linux-foundation.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,brauner@kernel.org,bsegall@google.com,david@redhat.com,dietmar.eggemann@arm.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,jannh@google.com,juri.lelli@redhat.com,kees@kernel.org,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mgorman@suse.de,mhocko@suse.com,mike.kravetz@oracle.com,mingo@redhat.com,muchun.song@linux.dev,peterz@infradead.org,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,vincent.guittot@linaro.org,viro@zeniv.linux.org.uk,vschneid@redhat.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 22 Aug 2025 15:11:04 +0200
In-Reply-To: <20250730015247.30827-2-isaacmanjarres@google.com>
Message-ID: <2025082203-smokiness-tapering-4a10@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B30D9160017
X-Stat-Signature: gf5oorgehdwimwcjort4r73m7ftnkdud
X-Rspam-User: 
X-HE-Tag: 1755868284-817506
X-HE-Meta: U2FsdGVkX18SD4CtBZ2+/gRdwf6Qa4XI77KJXPWjvMADfijrlTvhvNuHprDg68nI54kSr5C8J9UP0DPMrXGlh3TOsAaPZnOAvqyEzXV8EkSGh7SIEPw5hIp/gqinIzyun3KxK8LhjdHcHdPRsjoGHwum/wX7MTRw6Ld0tgRk5v/LfEp2VehMM5gOLOooz9G4R7bZlqmz+yy80iYi2JWZrPPf76FUopG6BH7E8CEn8Y6HB3/EKguYFu8YEL08lTS7YAUOyEJhpZp45UrjSufTX+uD9NNTuYI2hzUIhJT/zwNO+F6bwV6Gq1qYhuPu5KvhSu5SpY7FvmxLftLC5gD7oExWzFrMez43yk3cN5NamkIuJuChzg+LCfkjiYZ3dvOVh+vYG7ymGIhZ4o6AFCNpBN90muEzTQI3MwIoH0Dpx6nNQBZiV1icWR1+9xe8RN4oEchvZTyZEdTizkd0P8NlUkPTx0aecUhzzcumdCtIuNVU3ygW6276uyQjmNdqGPaY49KCT3fwBqPs5AgBu8NZcev6DKRS6tT5Y5ZzcDo2NzOE+MZAKKxksY6Rvmd95q6HwOysJKguTOHAsqFdJ79bUDVse4tcDkhZEPrZclMuIWh3HNKLxHZuLGgrMTMZxl9vH1xQ18gi09WTRZnQDex/x7mNWKq9GyLBHsqhW/wW4tCCBvEr6O7B9c0J+WjfPPo4ZntgXmPKXU9Qo6u6zITTWFeUz+8lvbVWAg/8fsdTO/qtkO0JJZX9lQdlS1eZAQZNaTQ+3LmURDE0erenMDYei/PJGRLUDfGauYHKkmOXTXBMPhQGkBhx6JZxP8yQPNTno1R8yfXwdySRH1IvSEJ3YvynFgBbjmWcNxx+JrxUuRO3qZRnQkplZQDxOe3lkAVkzax1N6Uiqon6MiR0kqaTJjNHRp4gfOo810KqeqAagfbgz/XjOTY602y/sHwa3wdU5U8QtTGi4+n5vAbQDYt
 xBQd3PDq
 /W0WuRe05kGSDbJMyzVfybYIlZtOXDBRouRiqrRoaq3pdGySyj9E8Thchqzg5EubC7NVvjpGeTXw5Bs8MKfMwU61prjWRlis1nhhDqTfeR9FtQyn5nfEqsbWo8K0FyXWSICfRQrQZZe8q6eYdAO4mpoK8hf0e/zRhKR3ccxVZM8HDISgq08gXaKefxgRtho8eGqn+/zgTLMErEJpWv98n3YIkHpxPsi08kzhNB/h4ughxEYpng1ugrnsYfrEI7P4n87Ha0kjIkkL5hVuF6bDPottV0NiFMsI5eAeVjqyfxtuPm710z2m0gsIZaHwkecKsYUqmIHqLLCt+5ZOBs4g5DgLo0EYav2+aWkdTOLAb2S0q6GmcUFLqYhTcGe9eGZyBUneSq7g9Al2eTtEezeemmVnXjkwgTk87S9+emGYN99fh6qV/pcR4ACRlz0nnvrp+OdKwZ9pAZITBQi8Lz6HOukmSX6RJ6xrAoVMJr/HXAbyseDhkOjw7P172GKS0Gxbyldszp8RLew9RxY1LcfiR9HuMl936sjaeWzoIt5FwKiKNFMhhV8X7TXDMKqadABWrl2qwQvvuD+wdev6r/3omb+v11fb0oQJPzf6dOhIs0F6qlykOm3Ny4RmJoaqhGTbkrsuxrwZaOMgNnEiS1EomjFyZFJdg9IrHZtD2fhqEg/8qD7cPDgmxu7B1ut8PDxIDGhbt640xGZU2UOtUr2OcgllHvfBtPhfoREk2i2ZNDgmHSumzOgtKGwLuYJ4nu/oCGTuruyEarU1me+H88pAhnUF6h4ap6bpZX1khhObhCMLJmkHQTm22p2A9GL/3XFxJip0fXv4guGjnb9X5Bq/nx0g0LHZcu4kN8wqiScvKl0AGWiK2+laac7yG+8OwUbhh9FvNTHR3pkjdwRsQ4GrFMJohliR1pcUKmCJ4NG/eVxVc5jSz7LWj7JxolFYNMM8/3y4Iy3zMEPI9kTlUqa5EBidGNemV
 DNvsxq4S
 SiWvdgWjNvqHKV7FIEaNufxOYuiI2ipIibO57Kzgk6LPfDqRjaueYRf85M6es7ln/tJfW/p+0dxw0+gDd3cY/BbcgsqY3vQk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: drop the assumption that VM_SHARED always implies writable

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165164-greg=kroah.com@vger.kernel.org Wed Jul 30 03:53:29 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:52:40 -0700
Subject: mm: drop the assumption that VM_SHARED always implies writable
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,  Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,  Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,  Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>,  Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>, Hugh Dickins <hughd@google.com>,  Mike Kravetz <mike.kravetz@oracle.com>, Muchun Song <muchun.song@linux.dev>,  linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Message-ID: <20250730015247.30827-2-isaacmanjarres@google.com>

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
 mm/mmap.c          |    8 ++++----
 6 files changed, 20 insertions(+), 9 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -410,7 +410,7 @@ extern const struct address_space_operat
  *   It is also used to block modification of page cache contents through
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -513,7 +513,7 @@ static inline int mapping_mapped(struct
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -673,6 +673,17 @@ static inline bool vma_is_accessible(str
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
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -669,7 +669,7 @@ static __latent_entropy int dup_mmap(str
 
 			get_file(file);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3554,7 +3554,7 @@ int generic_file_mmap(struct file *file,
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
@@ -980,7 +980,7 @@ static long madvise_remove(struct vm_are
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -106,7 +106,7 @@ void vma_set_page_prot(struct vm_area_st
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -408,7 +408,7 @@ static unsigned long count_vma_pages_ran
 static void __vma_link_file(struct vm_area_struct *vma,
 			    struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -2827,7 +2827,7 @@ cannot_expand:
 	vma_mas_store(vma, &mas);
 	mm->map_count++;
 	if (vma->vm_file) {
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(vma->vm_file->f_mapping);
 
 		flush_dcache_mmap_lock(vma->vm_file->f_mapping);
@@ -2901,7 +2901,7 @@ unsigned long mmap_region(struct file *f
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && (vm_flags & VM_SHARED)) {
+	if (file && is_shared_maywrite(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-6.1/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
queue-6.1/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-6.1/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-6.1/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

