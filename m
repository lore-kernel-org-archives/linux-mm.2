Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F1C8CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 07:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86DB56B00AC; Sun, 24 Aug 2025 03:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E8E6B00AD; Sun, 24 Aug 2025 03:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75BC96B00AE; Sun, 24 Aug 2025 03:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 619AD6B00AC
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 03:58:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2AD21A0833
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 07:58:37 +0000 (UTC)
X-FDA: 83810899074.02.7771C74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4AEF3140003
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 07:58:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="pmho4o/k";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756022316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Ow3HEqQa1f+nOQxlyFMGq1cs+ivycxJPeknBen0meOk=;
	b=s5LsqAmNESG4e1NfGmlTeHhzyxum6Wi3/r8GAE3OcyVz2DkPk6b1hyVsYi7O6vccKJr5Wa
	EdcqL39WPDwiew85HsEKY4noCfbDHqI5yV0hlecueMSp9PehPmIRAEs1Dl6xG55CouiqQG
	cjX//aoppVTaojVcSxxrc3XcP/3I/1Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="pmho4o/k";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756022316; a=rsa-sha256;
	cv=none;
	b=DLhFaq/txSpZjhgi2jTIsPMLpDeH0KIMlv1RSaMWfWrOKUmD/LFfplaADohHOoofKnMe+I
	tzSW+xJg1cXfCE6oqW2nZY/qHYLXj/YMsot5jaMKhyxx4ymM0UITHhOPfn/zeNaoe+itNZ
	UR7/N8DO4nxQkdVMxFBQMOv2nsFIhGI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 789066024C;
	Sun, 24 Aug 2025 07:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62F1C4CEEB;
	Sun, 24 Aug 2025 07:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756022315;
	bh=es617w/lf3zGR9tSX6L+KcamAvS/pdehMD8XZGttNK4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=pmho4o/k7p5kUJfglAeysHFGex5gnd7iiDfWiiza6OUnK34U/pHBrWNbnszM700Xz
	 ILmvpLyfeaIEbRok1HrkpIRg044XZIildrbDlsAd+7I+MQfe7SgHWnm0PJiWDWIYnW
	 +wmqfxO+JIFlFl85KOXOB1XeRGxGwk0SWeIss9B4=
Subject: Patch "mm: reinstate ability to map write-sealed memfd mappings read-only" has been added to the 5.10-stable tree
To: Liam.Howlett@Oracle.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,david@redhat.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jannh@google.com,ju.orth@gmail.com,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,mhocko@suse.com,pfalcato@suse.de,rppt@kernel.org,shuah@kernel.org,surenb@google.com,torvalds@linux-foundation.org,vbabka@suse.cz
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 24 Aug 2025 09:57:53 +0200
In-Reply-To: <20250730015406.32569-4-isaacmanjarres@google.com>
Message-ID: <2025082453-whooping-unplowed-c59c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4AEF3140003
X-Stat-Signature: kq7u77o41ret9wphch3et78zbdjqoamy
X-Rspam-User: 
X-HE-Tag: 1756022316-977331
X-HE-Meta: U2FsdGVkX19XlwSl3nSexpQI7YRSR/L9ecqrLmPGFFKCw1vRkw5lAdYrYphebLjHKiYrdlmheRo9THWjd0k0tflQJbITqoLaU3sSbSfeqI0HAX8QZTugku8Q5tHMvil+cd/H9Li6ioax/woJ34NyhvjgWvLVMwcSFh9QG7Cm2H+r15AwVqh4yb1ofud+lei712HBtVbLcYOOwHUp0ZEnBhjpjBibQP6YBn2KERiBZUzz+DSbadw75NcozNJoWBLnM3yBDzpDwdHcxhOm8qPAOlClbrYaaQSq8SXfcqcgP7a/nLMGtz7RC0S9AE7gncBm+1RQG2DvB82CF3ekFOTi7DV5y0XdfoPjhnmX4KB3YXkacLmWhSY33hvG0oeIKpEsKnqoDrydWcnVH838dCs+pG+j/f24oJOd5QiJXQmXaYsz8R+GM7D5onFezYTo7mP6/ut+DfM1r08gnZKcJP2Ark9cCG1rSm409p2nlPCicnTd0oQ8Ct/cHBOLrLTUoJlKgYM9wPoPJXrVkuB4dgjerCxmMFNg/tBIX5Uwgx6GZ6rySERoQIcYiMGLD3qud6UcKelHXUIyYy8gdc1j6lL6+2szXQYTO/0kzJyLcHFkQUUEueMcSWWNDgUqqiUqoLSW//fz6dsMjb4/hNVE2+yGgF0NGMdIhNPMZPxp9yl1rIaLJ2Ul30zlA2yB+5a5SRjHxkF5bKZ+OvKiObiar2IYS5DMAQiRm3M+/Q+A1TtQ7REKxMfPzuJ/cRJ38arrxnZrPzbrPg1r9KmieB/MAoFXnEvaNJEEnvUQoyzB5FmrnRrmoURNYgPajaoUMgdIsEAHo4lsRg4kQ8MyRwG/CwdxY6MKFCHgFpKlGGVNEUhRxjNsBeqwUTmc1g9OCQ8f3L2k8yFnWN2VC2eRNCj8qwsNQj0Kf8HuyJKLuvzyyzCZ6HK9PShO3HrHlFs7Uqxrb5KkgmyFbwQCvcUagsWcr29
 2QtveoZl
 iJlnptcQ9ATj3DX/dkcIT20eHhnxBqiyrfuFoUD3UlU7U77QIJVTGH/IZpErEu4HVVehsInqyz7DgWxOl9mwNi7Q0C7DsKI046T5uTGcC+k3ygZ+JMA9Rlt4yJ9mpFUPTzjSR4YiSmhCNq7gGiSZnsVt27bl6C1++f8S3uyypO4QW8Z7Ca57yBYVfK0dR6/THnR/8GxDZIxh8ONNeFBDeOManrUQwvLl7rzSGuHi98g23G1tZuWwkk34CA4lCszB1P1T3qEVhoFhpmxFsTynC0Iy7gpCR7TJ6OpDTzbQrjHD5R27y/iM6k0ZOU0DjoViIi2DHwH0/k3xuyQ6CzIcgf7bGvejBmusUcYrqUR12yxtYCF+gldeKb39F1nOFW9v8dvNpsSsBCGkXymeUmlPN3fNRqBK4bTOpKRwSeeAcKXlR6b1M1pZ4gm6zZpN8j9W00oumTpoYD60nJ58aH9fn2RKRzWcvgBdk6vXtC1QxB+cVcmP8s/KWwwuFDo8Ep/nDrhwf/TEWjcT55Sf8A1PHihl9t45a35HuWNyyh0b1KkcqBmwWHthPAdHEZ6Xytna3jCoFnnO+OLQ7OoTdxJHnW7LuWzTqraLX8Pczk/oHMqtSEKSGB0w1gngUHFJrCcuq0nF12Yo4BIK2u3qpPKuTpFSzcC+Ln23035KlDob+i4+IBivTqA/TsJ5oTKX+MuP2NdN3s+iMoRQCC2aGZhkxnrpwUdqNawzgidveTNQB9cCdezgemcyHHSPT1FrR4tBEco4HqaSz5U+n4Wt6y/cJMco+Pq5NQqIihqfiVv7PjzT5NYQgzp0hARoAMFNtApEjAZ8E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: reinstate ability to map write-sealed memfd mappings read-only

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 3TXuJaA4KBrQcmUUWgUhdUllYmaiiafY.WigalYaebfchorZiohXUncih.ila@flex--isaacmanjarres.bounces.google.com Wed Jul 30 03:54:21 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:54:01 -0700
Subject: mm: reinstate ability to map write-sealed memfd mappings read-only
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,  Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Julian Orth <ju.orth@gmail.com>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,  Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Message-ID: <20250730015406.32569-4-isaacmanjarres@google.com>

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
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
+unsigned int *memfd_file_seals_ptr(struct file *file);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned long a)
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
@@ -3200,6 +3200,37 @@ unsigned long wp_shared_mapping_range(st
 
 extern int sysctl_nr_trim_pages;
 
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
@@ -3211,24 +3242,15 @@ extern int sysctl_nr_trim_pages;
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
-			vma->vm_flags &= ~(VM_MAYWRITE);
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
@@ -133,7 +133,7 @@ static int memfd_wait_for_pins(struct ad
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
 #include <linux/pkeys.h>
 #include <linux/oom.h>
 #include <linux/sched/mm.h>
+#include <linux/memfd.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1488,6 +1489,7 @@ unsigned long do_mmap(struct file *file,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		unsigned int seals = memfd_file_seals(file);
 		unsigned long flags_mask;
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
@@ -1532,6 +1534,8 @@ unsigned long do_mmap(struct file *file,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
+			else if (is_readonly_sealed(seals, vm_flags))
+				vm_flags &= ~VM_MAYWRITE;
 			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-5.10/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
queue-5.10/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-5.10/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-5.10/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch

