Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39D7CA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 08:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8B28E0002; Sun, 24 Aug 2025 04:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57798E0001; Sun, 24 Aug 2025 04:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6CFB8E0002; Sun, 24 Aug 2025 04:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 937618E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 04:54:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E9105A17B
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 08:54:02 +0000 (UTC)
X-FDA: 83811038724.21.5CFB1D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7A72C180002
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 08:54:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=NVKDmzdt;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756025640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=MHY3f9r7VjkQ0I9EO9NCUP0qX4dkbI8QIlCkoqcT+QY=;
	b=sr2Ah8AwU1RD2vDSr0v3Dssgy/0QnqRs7zAz7I+sk3yYWA3IHmYCnMUJA31pqyZNxWvuqJ
	dKAyTXvxgNqx7ejJ4fQ56SqgfYmPBifQ+xWDy/uqlhr/ywCkel4uXRz1MkCjBqu7kW+POc
	MbA7LoJ4j1BAOMIoSRU/QTExiCHFbV0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=NVKDmzdt;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756025640; a=rsa-sha256;
	cv=none;
	b=zihly9QvxzlaAosCQLOegKZ30BfB3YppoSgdLFX01a/B3OinR9XgUqJ8xxpANPBhBlQfzC
	pvmfaRqH4Y2uVORW4l5JaA01DO9W2kiLdf9jw2fwIgVyq7ByfnaGq8H/3pV6CCfwrOdgKr
	Gv3+UFUZgppxHc+JuT4bxJ2+JUbi7XY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D22B8600AE;
	Sun, 24 Aug 2025 08:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013A5C4CEF4;
	Sun, 24 Aug 2025 08:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756025639;
	bh=GHH+mCRd01IAeLUsA381AWep94agbOw56lswlWrci20=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=NVKDmzdtsrd57scy0pYR7g4TnodBE/f/TIxd5bCYy+YyXdmmLqRVgiOJiyO04Rjj0
	 B4AQkwgLN7mfAL6AlrApyd6El0NIUbRzxC/M5I5UJE2CDf6Q7tKE2fJY8fqTU4U0NZ
	 bPmr7/XqwI11cFaH8wr1pBeXGXTWnZTk0u6w2TW4=
Subject: Patch "mm: perform the mapping_map_writable() check after call_mmap()" has been added to the 5.4-stable tree
To: Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,brauner@kernel.org,bsegall@google.com,david@redhat.com,dietmar.eggemann@arm.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,jannh@google.com,juri.lelli@redhat.com,kees@kernel.org,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mgorman@suse.de,mhocko@suse.com,mike.kravetz@oracle.com,mingo@redhat.com,muchun.song@linux.dev,osalvador@suse.de,peterz@infradead.org,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,vincent.guittot@linaro.org,viro@zeniv.linux.org.uk,vschneid@redhat.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 24 Aug 2025 10:53:40 +0200
In-Reply-To: <20250730005818.2793577-4-isaacmanjarres@google.com>
Message-ID: <2025082440-slightly-kerosene-e7d9@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Queue-Id: 7A72C180002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9p14wh7kdbkoosnj1eg48jye1dimhqo5
X-HE-Tag: 1756025640-525586
X-HE-Meta: U2FsdGVkX1+0tozHo1l0LCpyQU6BLf8R4DMdVY1TPwdA+3oCxhD0CP44HosoVryL+7SIY/PKFpppJhvexdwcECrFvHDLk9SHopJ4/gpiKf8ibR7n9fvYzoPjNdr/WKdTGCzIGXT7DK3Phn5goNVYCBUmzdD89h4uHKg+AbmB2W7Gje6NFtTZT9T4HnB5TAzxvZyDAILaZWxBJS5H1KUa3GntWd7neaD8Jyuzv7/wX+wkDvfCIzzbsSvys4gNd9OHd+ojOq7DfYOVesuQUrBYBOhHxFZ7I46tz40HkgP70jK3ZthkDnidvp7KggOjvg2l+2i8DCWMCXqDKr2YsTP4PNjMgYbvr1oFPG4F+1u/zDouaoHSmHdNbJjVcXk0MeNAqB45oOb+sBF4yJhyvUhMW29etgXO4MubmoDxLlAAzubyx7HdLO3WEbz3ef7VgufblLtOfetVVfQn1xAeeeEka5EMcRScHVbbfvZZWoau44hXzL9HM6CkC1XeqI3kH2VkoHE1GqMAVs439QW4cGchmj8hltTKS1L1vNsBkVPY0mrpBkkmiMAbqrZ8ROFwz6ioDfF27Nber9le7M8hIGrEypiE0yGix0IW7KxUftSMrR1I2+vqIqeE/wEwHGubLDWNwZ4O552sCldQwS7r8aJDANvrtuoNiWWkR5frZGo/Qd/bFLoJHseVatzXkhm2bhg+O0MEgoXu/88c5VLQ0yiE6vkfdwzgSfRQktMzgAAIifo4wntD1adby1nP8ylqst8N9OMiCqtIoO4eOr8qFjDGT9Y9nIykdvE5C8sGSyzbn/QfxpFAuGPGNv/QF97uPgMvdUZNBQgcGOBzphNEG/bB3KG5u31tmLciz5wHxbSJXmDVUtRta12cB1EeRq81MJzV2vkaMOel6ATCaMJ1qtE+pyMGvLish0eeM3nqNVNdpkJdHpwk3SehJy4wGlwAm3qBAUW/eSGaPS223llAdKz
 d3BMSswA
 vD2dMTgng7hlulARMB4w+ka3AB6oWEWpBh0QAlRL30ZIpszCCFoO6U4IqLcM8jBvyIcNx8v/k9XBo0cRDF0tIkcjNcenguzlk++2n6xqXggPHZFMwXJ1CzI/vPr7F8D+cOBTJ70aMft0WbZOf8YXdMU9b5sjMeOawA3Z+G6l3I3AuQYrm1STWhObmwnonByxquWpGaRTdwOyud5O+S6bH2bvQ7E4sBVmH27UdAnXGGzjo4rx/8XwhQIVXtG4z6ErOPJmlr32M5N2SlCL6BZspfpUB+H70SkkdAH1/N3PyCg8/ymvcrmik1nNaCvkpqPHY3/tJGTADu7vT58simazQ5wnLznJY9b8EWbIABaPxK6YDOlQkWYujWtcS0a/pHJyT+j0Xwu5g4aAzxSHwsON7vXqnpm/4PMMzghZ/oFtP+jIAwSK8WeNJ8l8y1VarIXjGcXQQCYElxOsF43yTg37igF9a7F4IBB+tA3o8N9x21+CdwvLa0Ap+MXPcbFgD6h+d8uOiv+fr9Gkg2C+vXaWMkSsV+Mt4KOcnsffyUtEl0ArstRuFpCkiIFO6wlM/yFgsQdr6+P/2IRaJlLk5mP8GGXjlp2UyRdpZceqjMepAqe50kdbIo4sZ7KpitstvGxPX+RdG53MVush5IleyLhikZtuQEJkXEkrzgZ4CfdpexBgG/N8VnTIVhc5N2j85Zwi4Kok8zsX0X8lqg9uLyXCdXEBb+AfiIlT3b+mNQkqiNPtLxG3ZQBUL7eXkCDM4237KRHKLZiIWxzj0e7Z971ZXiNCGm2+0q6j70EJyD6azWvnEYcs8QimblHledtwNqQaVKqJHCA7gjpy/NQHBemNHVKRiCp+sUMkBCxuCCQl1GjEH8YptwVCo4RQDVVLPebdKAiHTyTE0O5GLj18MIMdANWC2EZzdN190FUAxMt7rH4PvtvJ2YehDtN/NY/ud1biPAiri8twabGaj3XMi9YqHj0/tiZcD
 g9jYiBg2
 FUXLhCok4ZFLlqrLWu5C6prwpN1vbQ99YdDv92dsm+Lx4y6MXFXY7WlIPOtsAo6weF8Ei+ugHBuIUg+mcycLma0OSsIOKEBBsQE+eerYG4e2HptDIE9mit+CCooKZyGN8ujVt3AmQuC08LNUg2BPfpK7ZbIY2b8KnBupO8RSrRlXxWAhEb0fLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: perform the mapping_map_writable() check after call_mmap()

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-perform-the-mapping_map_writable-check-after-call_mmap.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165155-greg=kroah.com@vger.kernel.org Wed Jul 30 02:59:23 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 17:58:08 -0700
Subject: mm: perform the mapping_map_writable() check after call_mmap()
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,  David Hildenbrand <david@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,  Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,  Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,  Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,  Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>,  Pedro Falcato <pfalcato@s
 use.de>,
  Hugh Dickins <hughd@google.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, linux-mm@kvack.org,  linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,  Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>,  Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <20250730005818.2793577-4-isaacmanjarres@google.com>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 158978945f3173b8c1a88f8c5684a629736a57ac ]

In order for a F_SEAL_WRITE sealed memfd mapping to have an opportunity to
clear VM_MAYWRITE, we must be able to invoke the appropriate
vm_ops->mmap() handler to do so.  We would otherwise fail the
mapping_map_writable() check before we had the opportunity to avoid it.

This patch moves this check after the call_mmap() invocation.  Only memfd
actively denies write access causing a potential failure here (in
memfd_add_seals()), so there should be no impact on non-memfd cases.

This patch makes the userland-visible change that MAP_SHARED, PROT_READ
mappings of an F_SEAL_WRITE sealed memfd mapping will now succeed.

There is a delicate situation with cleanup paths assuming that a writable
mapping must have occurred in circumstances where it may now not have.  In
order to ensure we do not accidentally mark a writable file unwritable by
mistake, we explicitly track whether we have a writable mapping and unmap
only if we do.

[lstoakes@gmail.com: do not set writable_file_mapping in inappropriate case]
  Link: https://lkml.kernel.org/r/c9eb4cc6-7db4-4c2b-838d-43a0b319a4f0@lucifer.local
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217238
Link: https://lkml.kernel.org/r/55e413d20678a1bb4c7cce889062bbb07b0df892.1697116581.git.lstoakes@gmail.com
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
[isaacmanjarres: added error handling to cleanup the work done by the
mmap() callback and removed unused label.]
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1718,6 +1718,7 @@ unsigned long mmap_region(struct file *f
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
+	bool writable_file_mapping = false;
 	int error;
 	struct rb_node **rb_link, *rb_parent;
 	unsigned long charged = 0;
@@ -1785,11 +1786,6 @@ unsigned long mmap_region(struct file *f
 			if (error)
 				goto free_vma;
 		}
-		if (is_shared_maywrite(vm_flags)) {
-			error = mapping_map_writable(file->f_mapping);
-			if (error)
-				goto allow_write_and_free_vma;
-		}
 
 		/* ->mmap() can change vma->vm_file, but must guarantee that
 		 * vma_link() below can deny write-access if VM_DENYWRITE is set
@@ -1801,6 +1797,14 @@ unsigned long mmap_region(struct file *f
 		if (error)
 			goto unmap_and_free_vma;
 
+		if (vma_is_shared_maywrite(vma)) {
+			error = mapping_map_writable(file->f_mapping);
+			if (error)
+				goto close_and_free_vma;
+
+			writable_file_mapping = true;
+		}
+
 		/* Can addr have changed??
 		 *
 		 * Answer: Yes, several device drivers can do it in their
@@ -1823,7 +1827,7 @@ unsigned long mmap_region(struct file *f
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
 	if (file) {
-		if (is_shared_maywrite(vm_flags))
+		if (writable_file_mapping)
 			mapping_unmap_writable(file->f_mapping);
 		if (vm_flags & VM_DENYWRITE)
 			allow_write_access(file);
@@ -1858,15 +1862,17 @@ out:
 
 	return addr;
 
+close_and_free_vma:
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
 unmap_and_free_vma:
 	vma->vm_file = NULL;
 	fput(file);
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
-	if (is_shared_maywrite(vm_flags))
+	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
-allow_write_and_free_vma:
 	if (vm_flags & VM_DENYWRITE)
 		allow_write_access(file);
 free_vma:


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-5.4/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
queue-5.4/mm-perform-the-mapping_map_writable-check-after-call_mmap.patch
queue-5.4/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch

