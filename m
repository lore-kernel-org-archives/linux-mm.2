Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2657FCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E4E900002; Fri, 22 Aug 2025 04:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6655B8E0056; Fri, 22 Aug 2025 04:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3B8900002; Fri, 22 Aug 2025 04:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46BFE8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:26:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C13E5A5D0
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:26:15 +0000 (UTC)
X-FDA: 83803711110.06.41B51D3
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id 501E5C0015
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:26:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=l2vSCV3t;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755851173; a=rsa-sha256;
	cv=none;
	b=UPQNsCRhSshjI5RU2Qm4DI/m08rgKBzK33Qpga0v0xud0M7XLp9S3SE0c+0y1FcaSzXJBb
	2281EPeqOUaaxeyxGR0R/KuRYvVKBYVQN09th0poc6qYK8bbwDFh8zUcPLKAe8IK2qkjKn
	IOcWGXrvns/utjoY19RnhFjwphVpFwg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=l2vSCV3t;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755851173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=/O8NdYxhFw+UOrcF6Yitd6XAODuLYqIrdNH+QAj5kVs=;
	b=YyrMpcvPZ0o4Pjmo/28s+36VIXL2cYrNvaU5h1Ri5BIzgqTAYeWiH+AZnbnGqUhzvva0Mo
	+Fl6d2j2W1r98b4M0kbCaF1ei1G11WafXdKhhmMot1Lyhkw0cdbhhfaJSA+BU9izbHWjpX
	gu8LldIaOeKoZadhljN9h17R0MPHd6g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 2538C5C6D73;
	Fri, 22 Aug 2025 08:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66006C4CEF1;
	Fri, 22 Aug 2025 08:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755851171;
	bh=/0H+1Wel1Z5uANE4wL/CRvqnMWubdxjhPWPKwQhsGn8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=l2vSCV3tNhroXD/5L/DfFViy+qnuAWnDgJm1hM5mlxbYHmaeJvbWMOz9FfzRmoMBg
	 Y7tyCOXvXWpwK4uUd2VZhsXfvVbiuVyLxKUH7SldryaI05Lwmhq6StWji8ADT58CvT
	 zohlrW/RKfYykur68JHqoLBr57ODr1g30YoPBdvc=
Subject: Patch "mm: reinstate ability to map write-sealed memfd mappings read-only" has been added to the 6.6-stable tree
To: Liam.Howlett@Oracle.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,david@redhat.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jannh@google.com,ju.orth@gmail.com,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,mhocko@suse.com,pfalcato@suse.de,rppt@kernel.org,shuah@kernel.org,surenb@google.com,torvalds@linux-foundation.org,vbabka@suse.cz
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 22 Aug 2025 10:26:00 +0200
In-Reply-To: <20250730015152.29758-4-isaacmanjarres@google.com>
Message-ID: <2025082259-uncorrupt-museum-2982@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 501E5C0015
X-Stat-Signature: 1ikhyeesj7jn4ctwbzeh4kpemgbxqe4p
X-Rspam-User: 
X-HE-Tag: 1755851173-219599
X-HE-Meta: U2FsdGVkX19PoTZS4iXnPxHpD2Z2awsbxfQ+nZnGAKgb5ulN5pEEZJhwRN7OmmMZPggl1kNtISiwEU/Wyfi5KZCsESpMMqVLsRrvSzJHPc+xs4xnMVVFbiNC6QaS1AvahPuQmsPUYhoYIcp/IqqC74RzR7Ygf/H2+2hM3MN9nKD0iwQj2olmZ73rYqFtHg9wc6bek7KrYEObLIt6Ex5tBL8F3lTZ2i20NK66gHoo5nawYYfEc46VLUjlXwSi/DlBfgC1V0ivvHtyN0lS0ne26dvpIQty2YNQfHfKL1tIgqGyPtvzrn/8dEe8KUuNzoH2JbvAVGOF+fsFX8BHS10E2GGGYExcuR9xebHUuWqKHsy+DJUhkL59SPnySGY0NuqOBpTS1q0OuBf8lN8qcIPoD9QGiXQQ+pmBcU56UWGUSlAdWy8ct3ENqY0K5BVIEig2wDcYYTnFXAtWBcIkyFMO6kbW5+PeB6+GGWFpIyC7iW66HjvkE9pQleAkOV1WS3Sop2yhjQkRZZ5iWkjqzO2zOIJu3JwYw0YebjXUYq0qL6AZ4UhwBHgvd+mVoF9LshHB9bkEbUDxmTXbG6BEpgBEGewr9f8br9youynL5bk68TX6HG6nu+UiAF+3VoEM+bubM2olhYAXlzqo1NFBcVIoGW4E6wy2dgRt8K8xv9PioYP8IUfWlH7KYDZlKbk1pTiwPpy6syjNwroU1DyfvETJrnRRUMMbuK/TWyxoXWMQU6yl280Dn3fkdtDzFcDtgGQv+oDxk538SEn8uM25TFUdQa5Nm0jhFZZCU6hd7k7Zg7er6GRBKptfQ4/otMZzw/j1SfD/eWeS55jcL391m4mNMDhAQGoS76qD4S4px23Frzomj9hPjYmjnL650OegAzdh8Y5nHzJ3XCicT7m6JFnPn5tYj+kxJy58JQkxsECRCI69HsIQyIOcADHQDJJ43aErQLR6WZrfJJ89ev5L4E8
 1rJtlFfW
 7dhe6n9ZDHqyPOzSjeFWo4nY2Bx/gfW6OOHSEGQ70ym6P45is5A8eHSkbDcZDbyyR6ErrIbf1Ls8VJv9gv3/z7thqT0dE9bIyy4eIBsS+ND1TmTRdbwassU7CSFe/Hh7xnP66OfD+DgF1ZM0uYEulSlJTzrVlrS4aFkBVWFmwj6Mt74Zn6hfgd3V0ahHGSpnp9KUZupR3qZ8fUpl/GYOGMGw8+vjU+NLnuSaCh8bQkWIqcr/46DMJXAKhTYE5v1H6JDZ4n5wIXn7vUepPgDlQy8Pjc5nT3JZKZINtbTyti7Wjjf88qq4ylXIIVz2v8mt+ZuIzLNg9/afK49tJ1yciwU06bcbwicjKBYF10UCTt0SwJN5VPhRdX8LNnRnSNRLJD4mEEKTEzfengVjS1Z3cqaO/T+oJLrZAWrMauqsJvGF7c/odVqXpY7uh5sqQYp4eywc3VQ7EvGZRJWwE6AIP25LB8mu391rctgmZ/+hFU51zv8QdntC5YTEZ5hPBdRd5ShnjHSBRTXF8AtfDq6vcK4P7oorPsjyECm6L8IHLSy326Nn6YgHyZkywEiHRF9LFTRtZZhF2U3wGcboNXVmS5fafkwOWN/9n3/BmmOLQU387mms8RY2n+wvMID11b/dXXgbRlNOSybs7hwTMZzoRWKHEs+qISFOOmSo+7PBd9jGXU4p1xYsY9cqS3wC1OsAl/hs11SxU1Mc9xvS27g9s/nJbR3U5iSTYDU0VWe6ek21riTQfelzsBvM0X7RPvmf23MUcihtZi89nCS1y/K2L3J3tO19l70iRHBjPXFImBQalDTL4HHnZcTSVS5vuBO4MnyKf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: reinstate ability to map write-sealed memfd mappings read-only

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165161-greg=kroah.com@vger.kernel.org Wed Jul 30 03:52:59 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:51:47 -0700
Subject: mm: reinstate ability to map write-sealed memfd mappings read-only
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,  Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Julian Orth <ju.orth@gmail.com>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,  Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Message-ID: <20250730015152.29758-4-isaacmanjarres@google.com>

From: "Isaac J. Manjarres" <isaacmanjarres@google.com>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 8ec396d05d1b737c87311fb7311f753b02c2a6b1 ]

Patch series "mm: reinstate ability to map write-sealed memfd mappings
read-only".

In commit 158978945f31 ("mm: perform the mapping_map_writable() check
after call_mmap()") (and preceding changes in the same series) it became
possible to mmap() F_SEAL_WRITE sealed memfd mappings read-only.

Commit 5de195060b2e ("mm: resolve faulty mmap_region() error path
behaviour") unintentionally undid this logic by moving the
mapping_map_writable() check before the shmem_mmap() hook is invoked,
thereby regressing this change.

This series reworks how we both permit write-sealed mappings being mapped
read-only and disallow mprotect() from undoing the write-seal, fixing this
regression.

We also add a regression test to ensure that we do not accidentally
regress this in future.

Thanks to Julian Orth for reporting this regression.

This patch (of 2):

In commit 158978945f31 ("mm: perform the mapping_map_writable() check
after call_mmap()") (and preceding changes in the same series) it became
possible to mmap() F_SEAL_WRITE sealed memfd mappings read-only.

This was previously unnecessarily disallowed, despite the man page
documentation indicating that it would be, thereby limiting the usefulness
of F_SEAL_WRITE logic.

We fixed this by adapting logic that existed for the F_SEAL_FUTURE_WRITE
seal (one which disallows future writes to the memfd) to also be used for
F_SEAL_WRITE.

For background - the F_SEAL_FUTURE_WRITE seal clears VM_MAYWRITE for a
read-only mapping to disallow mprotect() from overriding the seal - an
operation performed by seal_check_write(), invoked from shmem_mmap(), the
f_op->mmap() hook used by shmem mappings.

By extending this to F_SEAL_WRITE and critically - checking
mapping_map_writable() to determine if we may map the memfd AFTER we
invoke shmem_mmap() - the desired logic becomes possible.  This is because
mapping_map_writable() explicitly checks for VM_MAYWRITE, which we will
have cleared.

Commit 5de195060b2e ("mm: resolve faulty mmap_region() error path
behaviour") unintentionally undid this logic by moving the
mapping_map_writable() check before the shmem_mmap() hook is invoked,
thereby regressing this change.

We reinstate this functionality by moving the check out of shmem_mmap()
and instead performing it in do_mmap() at the point at which VMA flags are
being determined, which seems in any case to be a more appropriate place
in which to make this determination.

In order to achieve this we rework memfd seal logic to allow us access to
this information using existing logic and eliminate the clearing of
VM_MAYWRITE from seal_check_write() which we are performing in do_mmap()
instead.

Link: https://lkml.kernel.org/r/99fc35d2c62bd2e05571cf60d9f8b843c56069e0.1732804776.git.lorenzo.stoakes@oracle.com
Fixes: 5de195060b2e ("mm: resolve faulty mmap_region() error path behaviour")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Julian Orth <ju.orth@gmail.com>
Closes: https://lore.kernel.org/all/CAHijbEUMhvJTN9Xw1GmbM266FXXv=U7s4L_Jem5x3AaPZxrYpQ@mail.gmail.com/
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memfd.h |   14 ++++++++++++
 include/linux/mm.h    |   58 ++++++++++++++++++++++++++++++++++----------------
 mm/memfd.c            |    2 -
 mm/mmap.c             |    4 +++
 4 files changed, 59 insertions(+), 19 deletions(-)

--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -6,11 +6,25 @@
 
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg);
+unsigned int *memfd_file_seals_ptr(struct file *file);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
 	return -EINVAL;
 }
+
+static inline unsigned int *memfd_file_seals_ptr(struct file *file)
+{
+	return NULL;
+}
 #endif
 
+/* Retrieve memfd seals associated with the file, if any. */
+static inline unsigned int memfd_file_seals(struct file *file)
+{
+	unsigned int *sealsp = memfd_file_seals_ptr(file);
+
+	return sealsp ? *sealsp : 0;
+}
+
 #endif /* __LINUX_MEMFD_H */
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4022,6 +4022,37 @@ void mem_dump_obj(void *object);
 static inline void mem_dump_obj(void *object) {}
 #endif
 
+static inline bool is_write_sealed(int seals)
+{
+	return seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE);
+}
+
+/**
+ * is_readonly_sealed - Checks whether write-sealed but mapped read-only,
+ *                      in which case writes should be disallowing moving
+ *                      forwards.
+ * @seals: the seals to check
+ * @vm_flags: the VMA flags to check
+ *
+ * Returns whether readonly sealed, in which case writess should be disallowed
+ * going forward.
+ */
+static inline bool is_readonly_sealed(int seals, vm_flags_t vm_flags)
+{
+	/*
+	 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
+	 * MAP_SHARED and read-only, take care to not allow mprotect to
+	 * revert protections on such mappings. Do this only for shared
+	 * mappings. For private mappings, don't need to mask
+	 * VM_MAYWRITE as we still want them to be COW-writable.
+	 */
+	if (is_write_sealed(seals) &&
+	    ((vm_flags & (VM_SHARED | VM_WRITE)) == VM_SHARED))
+		return true;
+
+	return false;
+}
+
 /**
  * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
  *                    handle them.
@@ -4033,24 +4064,15 @@ static inline void mem_dump_obj(void *ob
  */
 static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
-		/*
-		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * write seals are active.
-		 */
-		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
-			return -EPERM;
-
-		/*
-		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
-		 * MAP_SHARED and read-only, take care to not allow mprotect to
-		 * revert protections on such mappings. Do this only for shared
-		 * mappings. For private mappings, don't need to mask
-		 * VM_MAYWRITE as we still want them to be COW-writable.
-		 */
-		if (vma->vm_flags & VM_SHARED)
-			vm_flags_clear(vma, VM_MAYWRITE);
-	}
+	if (!is_write_sealed(seals))
+		return 0;
+
+	/*
+	 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
+	 * write seals are active.
+	 */
+	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
+		return -EPERM;
 
 	return 0;
 }
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -134,7 +134,7 @@ static int memfd_wait_for_pins(struct ad
 	return error;
 }
 
-static unsigned int *memfd_file_seals_ptr(struct file *file)
+unsigned int *memfd_file_seals_ptr(struct file *file)
 {
 	if (shmem_file(file))
 		return &SHMEM_I(file_inode(file))->seals;
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -47,6 +47,7 @@
 #include <linux/oom.h>
 #include <linux/sched/mm.h>
 #include <linux/ksm.h>
+#include <linux/memfd.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1285,6 +1286,7 @@ unsigned long do_mmap(struct file *file,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		unsigned int seals = memfd_file_seals(file);
 		unsigned long flags_mask;
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
@@ -1323,6 +1325,8 @@ unsigned long do_mmap(struct file *file,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
+			else if (is_readonly_sealed(seals, vm_flags))
+				vm_flags &= ~VM_MAYWRITE;
 			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-6.6/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
queue-6.6/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-6.6/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-6.6/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

