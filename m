Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF982606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03166B05B6; Wed, 28 Oct 2026 03:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADA4E6B05B7; Wed, 28 Oct 2026 03:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFF86B05B8; Wed, 28 Oct 2026 03:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 729086B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:45:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEBB5120C1E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:45:58 +0000 (UTC)
X-FDA: 85371251196.19.E459672
Received: from mailsc.amlogic.com (unknown [64.106.246.77])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0FE97C0003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:45:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=amlogic.com;
	spf=pass (imf22.hostedemail.com: domain of yao.zhang1@amlogic.com designates 64.106.246.77 as permitted sender) smtp.mailfrom=yao.zhang1@amlogic.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793173557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jKu2cq7RaKZ/bfx14b0vxiisTRPYsAwPIdF2ERn4E/0=;
	b=q65UAhrQJfWFwUNUxrM4cQFe5VZEBsBWSse/7T8ZTou0mskvjc5jgWJfBgY9ydTTyATIxa
	iePBCStXAIcxkBjb9EVCooAWu5LwL9E0O6nTNF2PFdRUprk3z+pZhx4PnGm19lg+KFuh/U
	rfiXT6GRGZEmAhKfCKEv3EMv/BPLFOs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=amlogic.com;
	spf=pass (imf22.hostedemail.com: domain of yao.zhang1@amlogic.com designates 64.106.246.77 as permitted sender) smtp.mailfrom=yao.zhang1@amlogic.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793173557;
	b=XIi1X98+dS5iqnTkW4zbk4wn5xQjbkR7+yvduesV1f0Qyz2AjdPhAUgq+q/ZaK0e9BJXH9
	j5ayG54ym5Zmfb0/xSa8N0K+Xmz1raDZ2JhUcZvX+76SgZANyqSrogexNKRAVUufwgECyA
	R/WNSKewwj+xCrkYpStcq6xyHsf8b1I=
Received: from XA202100-0024.amlogic.com (10.88.19.246) by mailsc.amlogic.com
 (10.8.11.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.35; Wed, 28 Oct
 2026 00:45:51 -0700
From: yao zhang1 <yao.zhang1@amlogic.com>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-mm@kvack.org>,
	<roberto.sassu@huawei.com>, <kirill.shutemov@linux.intel.com>,
	<jannh@google.com>, <paul@paul-moore.com>, <yao.zhang1@amlogic.com>,
	<syzbot+1cd571a672400ef3a930@syzkaller.appspotmail.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Jarkko Sakkinen <jarkko@kernel.org>, Dmitry Kasatkin
	<dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, "James
 Morris" <jmorris@namei.org>, Mimi Zohar <zohar@linux.ibm.com>, "Serge E.
 Hallyn" <serge@hallyn.com>, Shu Han <ebpqwerty472123@gmail.com>, "Vlastimil
 Babka" <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15.y] mm: split critical region in remap_file_pages() and invoke LSMs in between
Date: Wed, 28 Oct 2026 15:45:27 +0800
Message-ID: <20261028074528.1720-1-yao.zhang1@amlogic.com>
X-Mailer: git-send-email 2.56.0.windows.2
In-Reply-To: <20261028074251.1695-1-yao.zhang1@amlogic.com>
References: <20261028074251.1695-1-yao.zhang1@amlogic.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mailsh.amlogic.com (10.18.11.5) To mailsc.amlogic.com
 (10.8.11.35)
X-Rspamd-Queue-Id: 0FE97C0003
X-Stat-Signature: kkoja6oj3oi8gfr5tosnajf5rt5wb4ij
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793173556-904908
X-HE-Meta: U2FsdGVkX1/kzQfb1TMaomICBBcVcrYV6/fVy2JLfbDQjgxKHk7oxIwiOmKzhXuAexjw7YH0yv8RbY6sW4VFcW6ISgQKFSUauRBvgd47KIV9SgQjtyIKipZh9hddbazN2vvKhVht6kqScUI9OVgUX7GCzyhlOWa4wsRbmECDArNCTPD17HF7PSHqVs940P0NyZHIC8SgA49JGT7PTnYOu5T9+XrO0sGoubiPouBaImFs59XN+ADjvuYLMSnSlgzMz44rnLQLUmUl+6pcHy6N0kRLF3CzOOJ1mj/pEDFIMUb3biqYwNg/bBNkM483hXz9kcpMYNfsQd35rq45yelcrle+/EUi9LxrQKanBr9vbgb2aVH4y4eWMUOgyYzPNhhOyr3L0WFpWJP4QhAyjzJY1k7yXRLMBKoBZBCyddBvopXfhZCIdkj/swtmvTLmU3AyL1az/J45W3p6Q6Y5r7MQWxNnLyQHFiUM06w+I9JwuMGWvnZGs/khqdZpRH9UBGA91xk73MYrVBPOI+Zjdr29HgI5kO6BDJuKQaueASSIHfXukJrq8JTEUcZfaRmfP4eGt8GQ5CXdDJh1FvzErXW2c52gFEfD4n7+hea+9gKtI4lgZIX8sMi4ti3qpk8BZGVj+zNWQFcLFJmW0vOqLcatv920nq0r/7CG2QsU0DcbrCypklm+U3ef6v19KuvLHJIF36mf9k/gztLO7fVW3Ko0Dm0RCPm3iS76rhTLdtKGiLTkG5H5IgdwGwBoc04Up5FY2Ag3YBBCBANenL7zkdg+FQI0vDw0/g3iU2dFMzBjk5RwV/gLSODvM4iTECXsKB7/ASYdzftUw/436rWMy5hPgfctLz13ihwfflUbdk4yN3Fw6ZdnX7BvpWOwYUW4lfkNgHa3PpBsFmaNmIoMXSS4YAoyHzU++1mu34u20J2g4EC2N0PgL4PQZ+yYKglwOG8EIB6pDnEajy8etnGxxdH
 AK68WhaE
 nGj48PHGGoqIFPPjjJESpANst4Y4rUZjkHe0BK1z5gOlJmJ9xT5i7qxg6O+1t3WYQuZARx1/D+h+EwYY+OQrXxdPUULUvSpFJqwCGuf8gy+/ZAJEwwyDyeWrKQyaGKfq9vT7XvAtn7aKb6RId+YicQY6L6GKbJhRfh4ixLbRD+wFSuehMcZbhGtcDyeR85JpKn44jG/Ez9sCRHdu5Of+mjBppQaBrhGeUBkNUNORZ2hkXPI2LVJRfZaXQrr7dMcjoY6KWJO30Qj6sUdO52dDxpK4seI34MaKcR+VxWeC6Q8bV9259M2KUL9hCR1fAKGPpqdhJTMOhh+Dgsh2cvDCTECj7SAmXX4UZ+l8hdGk0PexUUVyWsnvokcmZluLb/GTFp3AtBDmGCoGgjIfD/23HaVsHEq7p9xxYLZzmF85XdtHocWUtQO+Ugv5aP9xnLuT7mXBrGSrf/GJghQqO/Zpf1QDHmeElLkwK3MUOiK84xdiksC6l6lSh9Za5gHsyaHNGPBBVt5C1NF3otq5Efvacx+lV6cQpYHi6t8B75NRg9ykqbKHkeLI05RBeAKqj0b14CURoHfPQLmQ/i+EhkVmncPBLSW5Xeg142PaZKodfn9DQ5MzJPdXPJAInVfoLrYXuco3fLO3JUYd6BI7b/rPtgN4yv88JiOA6lZoUtjmKy4F+falLkP9DsI3PRIWIwvz4FUPjrsbGvWbz8vhtbj/Utosfh5tOvxpuizM+xnh8m4wSqPDyaWmJY5mDahPaGIjA5pPS+hA39QixbL8gOHcKEfRGnTM6a6vZRJ+QhoF+ada5SIFoS4cG6lVRUSCnOx0steibohwM10Ex3PEL4fUDsKMAdzKAJc6IgbXikZxM5IfEe/9u6tpcjSsfxLfluIprWnADOtf1OvM8JH9z118ITZ/KvA3jvtxq0OkfxER8fxxzJL2FcSWxZJGrQJlQtIWVusu7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Commit ea7e2d5e49c0 ("mm: call the security_mmap_file() LSM hook in
remap_file_pages()") fixed a security issue, it added an LSM check when
trying to remap file pages, so that LSMs have the opportunity to evaluate
such action like for other memory operations such as mmap() and
mprotect().

However, that commit called security_mmap_file() inside the mmap_lock
lock, while the other calls do it before taking the lock, after commit
8b3ec6814c83 ("take security_mmap_file() outside of ->mmap_sem").

This caused lock inversion issue with IMA which was taking the mmap_lock
and i_mutex lock in the opposite way when the remap_file_pages() system
call was called.

Solve the issue by splitting the critical region in remap_file_pages() in
two regions: the first takes a read lock of mmap_lock, retrieves the VMA
and the file descriptor associated, and calculates the 'prot' and 'flags'
variables; the second takes a write lock on mmap_lock, checks that the VMA
flags and the VMA file descriptor are the same as the ones obtained in the
first critical region (otherwise the system call fails), and calls
do_mmap().

In between, after releasing the read lock and before taking the write
lock, call security_mmap_file(), and solve the lock inversion issue.

Link: https://lkml.kernel.org/r/20241018161415.3845146-1-roberto.sassu@huaweicloud.com
Fixes: ea7e2d5e49c0 ("mm: call the security_mmap_file() LSM hook in remap_file_pages()")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: syzbot+1cd571a672400ef3a930@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-security-module/66f7b10e.050a0220.46d20.0036.GAE@google.com/
Tested-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Tested-by: syzbot+1cd571a672400ef3a930@syzkaller.appspotmail.com
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Eric Snowberg <eric.snowberg@oracle.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Shu Han <ebpqwerty472123@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 58a039e679fe72bd0efa8b2abe669a7914bb4429)
Signed-off-by: yao zhang1 <yao.zhang1@amlogic.com>
---
 mm/mmap.c | 69 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7f357de8f4d6..90a5358da10f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2991,6 +2991,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	unsigned long populate = 0;
 	unsigned long ret = -EINVAL;
 	struct file *file;
+	vm_flags_t vm_flags;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. See Documentation/vm/remap_file_pages.rst.\n",
 		     current->comm, current->pid);
@@ -3007,12 +3008,60 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	if (pgoff + (size >> PAGE_SHIFT) < pgoff)
 		return ret;
 
-	if (mmap_write_lock_killable(mm))
+	if (mmap_read_lock_killable(mm))
+		return -EINTR;
+
+	/*
+	 * Look up VMA under read lock first so we can perform the security
+	 * without holding locks (which can be problematic). We reacquire a
+	 * write lock later and check nothing changed underneath us.
+	 */
+	vma = vma_lookup(mm, start);
+
+	if (!vma || !(vma->vm_flags & VM_SHARED)) {
+		mmap_read_unlock(mm);
+		return -EINVAL;
+	}
+
+	prot |= vma->vm_flags & VM_READ ? PROT_READ : 0;
+	prot |= vma->vm_flags & VM_WRITE ? PROT_WRITE : 0;
+	prot |= vma->vm_flags & VM_EXEC ? PROT_EXEC : 0;
+
+	flags &= MAP_NONBLOCK;
+	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
+	if (vma->vm_flags & VM_LOCKED)
+		flags |= MAP_LOCKED;
+
+	/* Save vm_flags used to calculate prot and flags, and recheck later. */
+	vm_flags = vma->vm_flags;
+	file = get_file(vma->vm_file);
+
+	mmap_read_unlock(mm);
+
+	/* Call outside mmap_lock to be consistent with other callers. */
+	ret = security_mmap_file(file, prot, flags);
+	if (ret) {
+		fput(file);
+		return ret;
+	}
+
+	ret = -EINVAL;
+
+	/* OK security check passed, take write lock + let it rip. */
+	if (mmap_write_lock_killable(mm)) {
+		fput(file);
 		return -EINTR;
+	}
 
 	vma = vma_lookup(mm, start);
 
-	if (!vma || !(vma->vm_flags & VM_SHARED))
+	if (!vma)
+		goto out;
+
+	/* Make sure things didn't change under us. */
+	if (vma->vm_flags != vm_flags)
+		goto out;
+	if (vma->vm_file != file)
 		goto out;
 
 	if (start + size > vma->vm_end) {
@@ -3037,25 +3086,11 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 			goto out;
 	}
 
-	prot |= vma->vm_flags & VM_READ ? PROT_READ : 0;
-	prot |= vma->vm_flags & VM_WRITE ? PROT_WRITE : 0;
-	prot |= vma->vm_flags & VM_EXEC ? PROT_EXEC : 0;
-
-	flags &= MAP_NONBLOCK;
-	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
-	if (vma->vm_flags & VM_LOCKED)
-		flags |= MAP_LOCKED;
-
-	file = get_file(vma->vm_file);
-	ret = security_mmap_file(vma->vm_file, prot, flags);
-	if (ret)
-		goto out_fput;
 	ret = do_mmap(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate, NULL);
-out_fput:
-	fput(file);
 out:
 	mmap_write_unlock(mm);
+	fput(file);
 	if (populate)
 		mm_populate(ret, populate);
 	if (!IS_ERR_VALUE(ret))
-- 
2.46.0


