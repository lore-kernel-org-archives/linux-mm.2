Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF97CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC7128001D; Fri, 22 Aug 2025 09:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95298E009D; Fri, 22 Aug 2025 09:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA80828001D; Fri, 22 Aug 2025 09:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A20CC8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:11:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C96B82777
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:11:33 +0000 (UTC)
X-FDA: 83804430066.19.93A5DDD
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf17.hostedemail.com (Postfix) with ESMTP id A2EC440015
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:11:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=x5vkFjmc;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755868291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=3LJbwGN55GIKPUkSA5FGr8r9aM1cdvwU2bcks4o1KZQ=;
	b=cfYVMvgp8/4gf6GCpXC30xzEhLBiiEywdvoWab9W0RU77zMX43yVHkM7vtCbmw7SBywsZx
	cQzQGKJ13W+LF7fxKuecE4DzXy50uAEk7LVt7yYiF4P5xhK0zolj1o0dTZhQ7zyWVxK9Nf
	mOoEfc5RBBvADFfoE68vR+2v1bz8fmk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=x5vkFjmc;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755868291; a=rsa-sha256;
	cv=none;
	b=kTeH23q0hxSIyofzdvtvP0WzYhXoASXfRPe0KfOZgDRht8FjjxmquqLiaQxFl9IlufQfWY
	tqA1+bXkR1nZOXbuByCA18ftDYuzO2JwIWEUmYYHSqh86PlmoqG4uCKXVMEY46Pfp19UYa
	8bqqzfvgtxuciGD8pxDf0hGErotZRHk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id D605BA589C7;
	Fri, 22 Aug 2025 13:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1040AC116B1;
	Fri, 22 Aug 2025 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755868290;
	bh=EWYV2CuaFsMwWLbADSDELnV6QQ3umbfWzwwk/yVzLc0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=x5vkFjmcQshUcOj+bMAKvk2IXKg0WcVKT4/QWCWaVzNMxzfHX+WGH6kyAowCOTGZv
	 a/9h4B6i7Vi23/0+AW8Ak0HfgJoaaYXEwYUUG1GVhfqck4ZljrLT7gETOeriyU0/gG
	 brvgLeMaQciMePoPM0NZ9XlxgQVBEm+2WlFwcyFk=
Subject: Patch "mm: reinstate ability to map write-sealed memfd mappings read-only" has been added to the 6.1-stable tree
To: Liam.Howlett@Oracle.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,david@redhat.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jannh@google.com,ju.orth@gmail.com,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,mhocko@suse.com,pfalcato@suse.de,rppt@kernel.org,shuah@kernel.org,surenb@google.com,torvalds@linux-foundation.org,vbabka@suse.cz
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 22 Aug 2025 15:11:05 +0200
In-Reply-To: <20250730015247.30827-4-isaacmanjarres@google.com>
Message-ID: <2025082204-gliding-second-5fea@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A2EC440015
X-Stat-Signature: e86g6ys88es1a8nsdh3p7ha7sq47yrnc
X-Rspam-User: 
X-HE-Tag: 1755868291-866115
X-HE-Meta: U2FsdGVkX191q6+iRRIDFVjO44JTMJ3JFs49+0Aj7JglqVLONSZj5HulwL7uzPSwRKubXFMJmlxrkgkFRPGB5FqAlbYLxgkHu2NtdV28nuC295qgscIfwTdR5WHbJFpk9o7oiAHsDnr1Zei6LNMPoNChCLrYArfTy5IqhNHl0dePqWX+F6J7bgKFZ8iK046yxNkfHcqjJAY1FATzdXRkOgVtnjDlLC4odvtADwzM0d4O2AluYcVrJ/i7N/AJGaQgVkZi8QwJHpl23kfX9PMxAg0+j4nmGSnHDdx09MjZog4kEGpRxDQXcpyLlKgmcdrKq7aC7EUnh3GDuNsK6qhtcEyEod88ZgYeJHhEoqitm4Ir2VOrwxtvK0d5+VVA8+Qpq/vNf7Bh1zZ7aTTPnhAA6NHv4eUCaKAhpDdu9/tUm3kz240sYlkYIBY+Iz6umFLEK6Y/im1SS6cFuPJmZcJ2FFGwOAgxl1zIcNh9AlVOqbBpeNsOBvT/19UBURE591LmrHaBz5ut6qqwVOWEytcD15EM6jfImypd2kTaj8ESEdSsT3D2E17Hyg9/615Ezn3Bf3M0ZqDMfTlMN450hS4cnguKEgvb3e2wHxUgQQ0qFR8jc2Qv5KYMQUYrWpw67yWqoeh66yC0Br48+T1s9lDTWjPKciMmvwm1XU7KPtlLnqDrhsgREFKhr/JP2AduLz6qnUyi4QKp2P1nvkH1YbgUFMwIDba4fT11mkCp/yuv/+vhVBJYGwnwGu7dtWWoz2+vFIJgYgxxwyTFAsTl2z+j+bO2I8G+TgcYArYwtbbraJd8bbva3Nn3sxB9V4SawvzrPRpN8QTKqvPaBjsJ4mSXV7xsFxuPlCHDSvlgSgdROzw8/wnrb6cAK7OcgOAqJjGDtpW7GKwH30txqomYLznLndnsHUdodTE+G6k3SJ1agSZhQ+1V8C7u1EcBqQCbVb4ChQJqftolG4F45JBCeBw
 UAZo2utv
 6LQYVu3niHWkxU7vKbYAlA4LFXymOQVGLhyviOx+e8bcWvT/DQ52OCxKyxorb4jZJw/LKl+Yvy6hS3IoEE6GEBpjzXhRPll+1U9WP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: reinstate ability to map write-sealed memfd mappings read-only

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165166-greg=kroah.com@vger.kernel.org Wed Jul 30 03:53:57 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:52:42 -0700
Subject: mm: reinstate ability to map write-sealed memfd mappings read-only
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,  Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Julian Orth <ju.orth@gmail.com>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,  Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Message-ID: <20250730015247.30827-4-isaacmanjarres@google.com>

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
@@ -3525,6 +3525,37 @@ void mem_dump_obj(void *object);
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
@@ -3536,24 +3567,15 @@ static inline void mem_dump_obj(void *ob
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
@@ -46,6 +46,7 @@
 #include <linux/pkeys.h>
 #include <linux/oom.h>
 #include <linux/sched/mm.h>
+#include <linux/memfd.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1336,6 +1337,7 @@ unsigned long do_mmap(struct file *file,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		unsigned int seals = memfd_file_seals(file);
 		unsigned long flags_mask;
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
@@ -1374,6 +1376,8 @@ unsigned long do_mmap(struct file *file,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
+			else if (is_readonly_sealed(seals, vm_flags))
+				vm_flags &= ~VM_MAYWRITE;
 			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-6.1/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
queue-6.1/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-6.1/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-6.1/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

