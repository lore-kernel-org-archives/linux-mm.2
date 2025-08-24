Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DF2CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 08:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9638E0003; Sun, 24 Aug 2025 04:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFD38E0001; Sun, 24 Aug 2025 04:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E60C8E0003; Sun, 24 Aug 2025 04:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0919E8E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 04:54:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB722BBAE2
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 08:54:04 +0000 (UTC)
X-FDA: 83811038808.06.426537F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3CE0B40003
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 08:54:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=dlW5DbKI;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756025643; a=rsa-sha256;
	cv=none;
	b=NGdsM/7GAxSU2RNQSJbTtRLwphUXwBz73g/M09/xqO9Zd4Br7FA4yKTQo4leFiiBkj6FJp
	Bnl9ASwoo9CIqoYZB6XYUnVP3aieIlInHp5S3ZY1pFxF7bcA9ggnkGLPYEvl0nzdh35y41
	KavkXFBj7zwND1UDLOaWjHYnKYeMhds=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=dlW5DbKI;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756025643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=NHdasPMcsiHV9DPlLnE658Jk7W55PHwrVThTIxgLCLU=;
	b=eoxhPCIlXNKIXHuSeJpNTHQcnbW3oKVFt7ghfQ4/D6mQdoDNz2zVkQXvbijTLiRCmDAR3f
	w+KFtp/jnxZzL/daTm7XvBJ//yoFyS5k0A+4y7PR2nZSgDaoXhK88jYn/atgGVMQp7niuo
	LkZpZlrGVzfHrYkNvGhKpBj8e6ohIkA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BDFC16023E;
	Sun, 24 Aug 2025 08:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6F2C4CEF4;
	Sun, 24 Aug 2025 08:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756025642;
	bh=hYvqRWQ+LgN4G9daXrINhaZbJhN8xXgrpRcIH4SYAy8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=dlW5DbKICsyb0afdPS6ytgTeMj9AVi/QyQktZpkx8hz5a7k6nVqxYbEkr8X6lMZxd
	 +TyE+AQY37uFLz3kw67uPJ9PzM3I/jyoWbxF2oGZ+w5YartIV4Ad5KUEpp2sg/ge9H
	 O1rEqvK8TWUgpLIdChkV3ngrXtW+9PAFmxg2Cpy8=
Subject: Patch "mm: update memfd seal write check to include F_SEAL_WRITE" has been added to the 5.4-stable tree
To: Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,brauner@kernel.org,bsegall@google.com,david@redhat.com,dietmar.eggemann@arm.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,jannh@google.com,juri.lelli@redhat.com,kees@kernel.org,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mgorman@suse.de,mhocko@suse.com,mike.kravetz@oracle.com,mingo@redhat.com,muchun.song@linux.dev,osalvador@suse.de,peterz@infradead.org,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,vincent.guittot@linaro.org,viro@zeniv.linux.org.uk,vschneid@redhat.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 24 Aug 2025 10:53:40 +0200
In-Reply-To: <20250730005818.2793577-3-isaacmanjarres@google.com>
Message-ID: <2025082440-astute-grudging-d9d7@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Queue-Id: 3CE0B40003
X-Stat-Signature: 5xm7j3ep1xfhumx9a67gj74yxp5tbqfy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756025643-673318
X-HE-Meta: U2FsdGVkX1/u5/X0ilfd0WYjUxLzTVQoP7wGEiSe4lqFCSQ9Z2lIWkcCPT+O3dKC9xArkLGfeTz0E6shTQye87chjKxikqR1RiYorGKQccf3jFtuszvbGtClIyj6l7oek1bRa8xDKy9ZARpxgeEbuvRCZCVX9888Ykrd1OlXLtaV+uJcjXCZhKiMkghOKzrehSLL9uJpVqAsSnpcnQXoDKb9jsktVXaD0V7w0cq0KnE0/hQd26v/B3TgOTApbrGvwmQwqsUCNkfJ/1aFj+LTArro0jX0oFV+agYQUyLfWD/dlPrLbMEEKxzkzyhg3oiNXPV/34CSIA6VQ3/x56mGvpTLxr56j8KawFms1s1rb+0InSVG0W+nrVJ8KoKafHE0Tbw6pxQ11mSbkxbBybp3GxLfQVPpQjrJGk3+JYpB8lhf8lWcqL6leNeYfTTUKgsHul3PM4VDzrZmfQEkqdvSnvL0lK4F1960HfIcSI91kwYPbvJ8EppqaQpcyrRVWDQ7RWLQE5ug+0N17Jsuci/MwF3Zlgz6o9UDH11jityJiMv4Pu4RIihUL2L3aU0BuTVTsnnPQTdxcX2rwMD1FsNFg6v/UK0jbyccZ/BHsoHlTvfyYNs4BSoHtef05w5SmrqX2U/b2XMgXrP0OdM3+pAkRUWM+vQEFbQ9G1vTdmtbo/Ayw293ARJSzUj2wmrWXyYEMtCcHZD4F6aR/IEjcxJJJS2pmIpNogsCZM5L5lIz6/XCTkYvIzYyJXiK2a9Hm7Ik+4921TtI9DAgvI1DBzz/WYkLAYLy2xuxi0HPRhLTfbEdduLHTm0dxyo+C7rpLpFFhSi6P+x/wDOWxxbUaCQxZjvhf8VE3hhBtGVsBWoAfEC/lnKya2iDa836OEUCSXDoSWPBPLpyEhCDtWC4S3A9kYJHK0qIZDwJ4JhJLGwWfH62XAYI43q26dMrSBebdS1MTqjTJtFCGtX0CK+ToH6
 8hXwz72R
 fHOFUNZaN6fhp7rLIECSJfx3cjcIx7ArW1/3L1bXLGH6N4ME3ZsLq2Os9Ghc35pupE1pEzgY5SHSggWHK4c52O4mduaXlawq9w+uzGB23blY5LV8U7Ck9b2JogNvKmaOVHvMjkHf94ABbWDUXY/nmdhci/TPf25J1RxCwzoS2aijOK6ES4hponM3E0q/QuVuZHbkc9GCLHTEc+jv/jsyEBManGMplqQKxdfr8O9Itie8xMIJV+WDIqCpSH0t2sw410F5EOef7O58oEJyoFlNMX8OMxaERe7SewmB+dMnj9WNTy79uIr8IeB/H76K1SipJ+GmstlZcomVDOPsLYVwArEe3JGTgV8Gg4z/69vCY6PsGLtV52oDiBiiZPj61YRK96bAZq0uEu+PTEZ/ruT7D2gSBQ/SKd5DWgTERPdTpbexKgNk7NdOaEX19n1BaGHUChP4MtmuHkprscLktvRJY20yk6BzesxHdXEhvTR3SudMG7esY7VNjPl0IDlQDo0YimsntjlgAJUI5BUXc4hloARTPvj9Xq47OOmYtRZKwkaer/+ZCq2YmdEmM000C165e+d9yQk4SEIePFJIyc79Bvm6FkgpsY9k4wXo5uIAZnA74zkqarXeKq0VKfa0JYGnQQZmKry+UUkNgBJvg5grbGcyTR1Vb+6keqCjolIqkp9sVtTnChkwUkA0BgehyKt2mOgZHL20ZACch0T0J7cALFVrhukxDVJSoNS2sKzEZt4i8ULtdREgZ7I7JB/C+WN2k7IjldjiDTPvZM7jyr/VEtug7k29BtKpqocE/j5Yy+WUNsZXBvnhZAAl+WaENu6fnmbazV5eO/74ZQfNZwNJoSYo1UBejeU10iHhiZ7UhjBSgBvThGHw94GiBpbrKmZ2MTQn5/Zzx1ubo9TxMH07gccuvjH5gdJNIBmgGmcUc3R+tlbuOKkBJy8iSwQoH+8AOeZVUL6O0cQY+yJDIpQJQvzhx64cJ
 qreqiezc
 KKQYPkgFa4WuAJ7jGBcamYKTJc6JnZgm/dvty5ImnEXMho8ji6UQ4gploc+8dTzIc9o8wswPJbUI7CVy/Jx5B3cFDtx999itEXzlP+7tjtkQQg8uCCksE55HZ1/slTinxXPQ7hT9kz7zJD1nGQJ27BDQUZdirokL0Kk/DrMzmqe26y7SdB9gTvfWcTuHPJGlkwMR0kBsfawWCbsfb5Pfgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: update memfd seal write check to include F_SEAL_WRITE

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165154-greg=kroah.com@vger.kernel.org Wed Jul 30 02:59:10 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 17:58:07 -0700
Subject: mm: update memfd seal write check to include F_SEAL_WRITE
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,  David Hildenbrand <david@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,  Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,  Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,  Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,  Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>,  Pedro Falcato <pfalcato@s
 use.de>,
  Hugh Dickins <hughd@google.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, linux-mm@kvack.org,  linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,  Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>,  Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <20250730005818.2793577-3-isaacmanjarres@google.com>

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
@@ -152,7 +152,7 @@ static int hugetlbfs_file_mmap(struct fi
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2946,25 +2946,26 @@ static inline int pages_identical(struct
 }
 
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
@@ -2215,7 +2215,7 @@ static int shmem_mmap(struct file *file,
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-5.4/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
queue-5.4/mm-perform-the-mapping_map_writable-check-after-call_mmap.patch
queue-5.4/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch

