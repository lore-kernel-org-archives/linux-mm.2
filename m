Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA05BCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA888E0080; Fri, 22 Aug 2025 04:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A058E0056; Fri, 22 Aug 2025 04:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FD98E0080; Fri, 22 Aug 2025 04:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ADA638E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:26:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8310A118378
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:26:05 +0000 (UTC)
X-FDA: 83803710690.17.3820316
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D56A6C0005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:26:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=s7NtRxjj;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755851163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=aO/iRLUH81HjzyfDNApA7Rk1Bs52D9z4B27CcXrwZzk=;
	b=E8VrqUBUDqDuyd3c0B4Wdd7XYGCak21RMymmiWeFAfqdmF35O4kHvCqkrq6XLri0n+QjKi
	x4CJyZOPOGpA0HSIiSrft93i4XMYA7sE1T+Xglj5SLLRZylnX9JZiNcOcqUmnnGkpj9wNk
	kYJpBRlZj74E6l3G6tqC76dTauLx/AQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=s7NtRxjj;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755851163; a=rsa-sha256;
	cv=none;
	b=KmUxr8Qh0WnmN1DzRTW/MhhJ1oocJ4o/9C6Q/a3DUL4uW0jJJzafVfO8dkWlZxRVkOzWNw
	DxXaFLMuUiQCe/6+q3nu4m4PyG0PvuzLfgW55/GWoVjjquwbuQgPmGxiwO0ej/I4ZiVj8L
	2/hOw7U6kIMchWPTSxCSzD1DFMQA4Ao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E80A60262;
	Fri, 22 Aug 2025 08:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E58C4CEF1;
	Fri, 22 Aug 2025 08:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755851162;
	bh=twC0LbHG+3VECDtCDcnFH5NGOeKdHsedP3lvokG0jVQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=s7NtRxjjC00cs40b83P3WSexThh+I+mrsozUPdKFkl1Y6THo3YkzxMDfBYu1Hknwl
	 D8QZDJ7ce+qKv8OKvurpVheV0rauBaPpbaUnQW8Vz06boSbqEy/7PF89YgT2mD4eI3
	 dOS28wru1m+Z6do3IFvG2ktlitDqjN+vfeUFmLro=
Subject: Patch "mm: drop the assumption that VM_SHARED always implies writable" has been added to the 6.6-stable tree
To: 20230324133646.16101dfa666f253c4715d965@linux-foundation.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,brauner@kernel.org,bsegall@google.com,david@redhat.com,dietmar.eggemann@arm.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,jannh@google.com,juri.lelli@redhat.com,kees@kernel.org,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mgorman@suse.de,mhocko@suse.com,mike.kravetz@oracle.com,mingo@redhat.com,muchun.song@linux.dev,peterz@infradead.org,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,vincent.guittot@linaro.org,viro@zeniv.linux.org.uk,vschneid@redhat.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 22 Aug 2025 10:25:59 +0200
In-Reply-To: <20250730015152.29758-2-isaacmanjarres@google.com>
Message-ID: <2025082259-revered-irritant-66c8@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: D56A6C0005
X-Rspam-User: 
X-Stat-Signature: ncasuyhtb6w7hip5pa4armwawnrns98d
X-Rspamd-Server: rspam09
X-HE-Tag: 1755851163-829566
X-HE-Meta: U2FsdGVkX1+AoBA10+gCsbMVkDcbtS2Dns8DBx+Z47OzBmOPs0Cbdpgg5k4J6bDjhSC/0y2uh9ndCFCoy0IFfchiT/5fQoDBU2DMewZXJ0BCF+Em+y8Eqeg05HeuWGdqi4kYNOEL200HNLbx1ZQzcmgidc/TECEGTcNfcm0KYy3+GVafe8xwgVz70try2RNLOwfWuO0P2ZhmVw6og8CyUpYvp74kc2F+j/TqfTeDnkc6MtzHBQcIFOEaTHC+dvNYy9+OJ8+PoXnYkq4hSXKItRW4ybRsYoNQWNqVbJYA19SdAn4zjGChVwZl+q7Z5lw3dDfMr+ceFlyasgmI8VU/8pxQhRTC+X7xiSkys/bo/OOP1dnVPyfXmMn/tS2NNQnp7vlRBuks45T94L99wEohL5hmz572PQgXXrdt5ROyKwq/LFL7KilS2MFsZ1K2OZjDWQx1Vnkv/mnLAU0wBiJOWCw+VwXg4fFHu5azSVd2k2NU9DqjHgw5oMb6xRC3kmsUW70NUx6t+4SNUvOVw5sCF0ZEyDhCC1Oqu9MWzdu1288J5PTqTTS7+EriVYlCs400lRXVLSyfMwIDwLSNbLY65p/BSFetmF3BtNAB+pdGZr5Yhme+X5KQp1W9g66qw1D1nKYRD4QW3QuX94ThoYpXqPftP5jYOwCVHspfa2qhLFgg1sG3Qymjcrr3niD+YTCZpoesff8KGvU6IQZqGT2YL3isWQxmfEwWcmzLWGhYnXNwSjhiK0ypTHB69prjqsDCL/NhwnZZ1vjGUhCx0PrF3wiu/kfjSjigHnqExon1WTvQsX7wwhXPOqXsT8K0tRO1mMoAR4t6aRB6ksChESJPwTETt2jZ9xEIlr3ipKorKk51C8GZLEbBEBCKrJY+27dAeehuZycXtR2W5cGXCGcLOETRL7JJ+puhTerypWzDFpKMLNGf08iPnBp+xR/g0cPJymTE44VHDeoxDATY8bA
 TVCA7FND
 fL8JNzzlTuHHpno3XMSK4i+Fs/CLpx2dNYdoV+y61veeDm3yw66NfeSHI0BHuWSmV0tW30N7w3GeCFaoP3ANYwPq5oAgQaDZhj3MamTecL3HslfepfSiS7+YKoEBc4720NVuf5yotIob4pAGigF/Gc8VREr4wIJS78Gl239lniUMUkSnx3wi2jGAU7Ft88M4bwy/jUdEbVxchwDc21JYcQ2emxFYdSCWO3OA81NbI7hApBbPMuxcnXXyqkNB/SifH81Zopg7YMCBcbASrFQqm12ZVCO3piAyQwdMYmxUYnxjvAsceK4K370i2ekE/2SPJl2ifDklBJFRE/r3HVwxpzzP352XrsWz+kQwgvRk2SWVAKLWdhzm3yWtqrllQWLaK57jdiQJJJia4sMjA/29Ppe9JPG38GD+9RUXKR692IxTAUXRXlCHI//lBreXlnxsOWKho5k/Yml7rkYL7l9zy3WPhckcEwZR8DojjgQLAavYEuo/Q7RbFlwUCZac3BM2wUpWnh847mqDm0c7HrnUN0BqJkg+V/f2MieTExIbb0vJfMyf+As1nJKmqG1MMSi2ht114ny6KtL3hkTB+FO2k0hpbCW5KThQTuVoQbWWaw0Fes256O80U6D6KSNrZEDWwHR6b9aSTetovG7Ebe4JYOjeNzasSz2ZpVTmf/ULvCBJkMYQAMJtlelQ6AQE0bBrnCs5+9X7mjwAqABXlaU+R3kyddSoe8IaZvkn1s7EKETuIH865mo2G5SW+X3cRkhTkdG2zRYUyA/cLt/IBe+PKOrgJ+dsE6mx6eo9GdqXEnWbSopUQ4oOSJaKEYTuVR+H2zRueMnkpjk2POcxhDJjJsCPL6o9p9j5igBBITAzGQW78pB8atzzfIMUyIlsWs9FK73QeWbBbSQQ20MozYj4eP7735HxnaWM2zKqFSjC/uZYWwsNkoYZWtwnaw7i6zAyT9K5HFtt8ay3RpPczlzfUMOcfXcKF
 ItFbKyZ7
 Km2YJf5CoVtYV3+TEP+79/KCJIwQVRuOyHg2+uE7GfKJK8qExc9YOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: drop the assumption that VM_SHARED always implies writable

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165159-greg=kroah.com@vger.kernel.org Wed Jul 30 03:52:26 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:51:45 -0700
Subject: mm: drop the assumption that VM_SHARED always implies writable
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,  Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,  Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,  Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>,  Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>, Hugh Dickins <hughd@google.com>,  Mike Kravetz <mike.kravetz@oracle.com>, Muchun Song <muchun.song@linux.dev>,  linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Message-ID: <20250730015152.29758-2-isaacmanjarres@google.com>

From: "Isaac J. Manjarres" <isaacmanjarres@google.com>

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
@@ -456,7 +456,7 @@ extern const struct address_space_operat
  *   It is also used to block modification of page cache contents through
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -559,7 +559,7 @@ static inline int mapping_mapped(struct
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -941,6 +941,17 @@ static inline bool vma_is_accessible(str
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
@@ -739,7 +739,7 @@ static __latent_entropy int dup_mmap(str
 
 			get_file(file);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3716,7 +3716,7 @@ int generic_file_mmap(struct file *file,
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
@@ -987,7 +987,7 @@ static long madvise_remove(struct vm_are
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -107,7 +107,7 @@ void vma_set_page_prot(struct vm_area_st
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -383,7 +383,7 @@ static unsigned long count_vma_pages_ran
 static void __vma_link_file(struct vm_area_struct *vma,
 			    struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -2845,7 +2845,7 @@ cannot_expand:
 	mm->map_count++;
 	if (vma->vm_file) {
 		i_mmap_lock_write(vma->vm_file->f_mapping);
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(vma->vm_file->f_mapping);
 
 		flush_dcache_mmap_lock(vma->vm_file->f_mapping);
@@ -2926,7 +2926,7 @@ unsigned long mmap_region(struct file *f
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && (vm_flags & VM_SHARED)) {
+	if (file && is_shared_maywrite(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-6.6/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
queue-6.6/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-6.6/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-6.6/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

