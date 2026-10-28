Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCACA606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E5D6B05B7; Wed, 28 Oct 2026 04:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005056B05B8; Wed, 28 Oct 2026 04:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85C66B05B9; Wed, 28 Oct 2026 04:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA69A6B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:08:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24193C0BDA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:08:53 +0000 (UTC)
X-FDA: 85371308946.12.1B3FA45
Received: from mailsc.amlogic.com (unknown [64.106.246.77])
	by imf24.hostedemail.com (Postfix) with ESMTP id 600EB180009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:08:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of yao.zhang1@amlogic.com designates 64.106.246.77 as permitted sender) smtp.mailfrom=yao.zhang1@amlogic.com;
	dmarc=pass (policy=quarantine) header.from=amlogic.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793174931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KOge3QbpemeNjgjVFlRXW6zSTDOId9PsJBtVEBvQu0c=;
	b=oHFNQ0ktXBUt/50yrrVsIQ5Crzgqi76JmNiA45nxM6GXqkfzfte3GwOFURDZc+HbumEXO8
	oWBFcIBHpS+3TKkEiEZI+PWcMkoEgx7vTRous8EGABxPwMPTdhtH0OZQShk6zZnZk+2lO3
	2EexpvsfeeHKAxvGIt5K/vJs95V0PkE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793174931;
	b=w1xZoT17kRX3HmjjnUL4cSs/z9TI8Sh9+wH3t0fDEDBulMPxXGVCF4AnjvrPLAc+X5BfqT
	qid9BgXKrB5xz6pPWHxwnfMexxAYf86ws/slQj42+MMbsdQheUOYUIS5gXbFtCHqxA98Gc
	eyc/XWESYK2W1OWu+7Iyq6XmDIR3ogo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of yao.zhang1@amlogic.com designates 64.106.246.77 as permitted sender) smtp.mailfrom=yao.zhang1@amlogic.com;
	dmarc=pass (policy=quarantine) header.from=amlogic.com
Received: from XA202100-0024.amlogic.com (10.88.19.246) by mailsc.amlogic.com
 (10.8.11.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.35; Wed, 28 Oct
 2026 01:08:46 -0700
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
Date: Wed, 28 Oct 2026 16:08:35 +0800
Message-ID: <20261028080835.1852-1-yao.zhang1@amlogic.com>
X-Mailer: git-send-email 2.56.0.windows.2
In-Reply-To: <20261028080719.1821-1-yao.zhang1@amlogic.com>
References: <20261028080719.1821-1-yao.zhang1@amlogic.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mailsh.amlogic.com (10.18.11.5) To mailsc.amlogic.com
 (10.8.11.35)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 600EB180009
X-Stat-Signature: 19bjsx8rqc3ffr8oz83fbyspywirnfim
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793174931-305196
X-HE-Meta: U2FsdGVkX1/Ajov8Wbzts6rj1s8W+j74Sx21YbQNwD0f1R4IQJ/ad/rzK/XUywWMNSjhgyLclu0S3dQB19+SP9PLAAXM7iapUx3dsF9d7oY+KGVgdOu4uJ2qRHJSSCITwOpjTPTFr3QbBtnJmJlBGBGMXLgXmbmgh/nksLeaBYWVh8d8LoKPoEtdG3nZpV1ADIcGu2XoQBAnhazUU05VrnqN+1cibgt/CFdJA/8CJz9lp9rsuCYzoZamQC1cfnCer/P2POUFf83SuFHucRRwKJ5By3Q06bqgFLUmy9D7eA/EtYhIKbItn7d9zTev7VN/oqZl2zvHIQ0MECa34+u/IPt11qfVTLN7zM6jdwG362Ptmp3jw5ckizs94gL6CduHVVLX265aFflIT10hY9Weiw2Q491+fRIEMkk+dHvw1+dfkVQFgO+L/ixaxgyEavz1EI/pdpMN/5VR2VFa6dWNkbQf+t9TezXI15TjDHpsUQ9712/fPR3jD5A+MfRr5ib1u2SrKopNUFGDYj/FTju7gMKCQ81JJFbr4GY/XcfNdPvtNxEvQ+7y2+5qxukYSatn0o2FNRdpqZY7radhCsCNLETSvHMNCoBaemzQmb3SXrvC5wTNegRlzqPsk6k/lnw6iBtlCMeAjPsK8j6ktxQm7UKm3LD2xWxDAFEOJ409cTtmCYhZtJ03jxXKmXUo0P5c9DBmS8nllbrzV1X/QhVIYtfqTWohZHjv/jK8qi2qqReWCMX5CyiaAIezY9Ij2qMF1uGL/2dQ6zFEe9EPkLRJdIfzudJcg36nv/Zd+vivmmsrZznLoxMF0dctEirrNbF5iQSOCsb5xAVGRdobPEW4LeWfncYghFv1B9OzwxgKZeNXqLoL7iI1V6q6/7iANbW/S0cr0/l3CZBc1INb7k43XeCpufczsaWAUeIF4aM5paMINPJ1bpXJWTe5qI+oDmO1zTvbW4Ki+nn6laW9nYk
 cS2QcDcr
 GcBZBwdSM00eMofa1kYHwqqB5lCKmMRwDCXU28lBTQQVQykhO/yZtWNUCb8vc73b/lJxt3W5vl5rz+S3uxYiBOvPAiGnS1uLpOd23bZ7PlLXEjSbjC1Ni1c4BbJwD+rcy7Q0m5ixaO/q4IWDcwJ9v7OKd3EwH2H0naBbBk75qfi3KdpEgp22vh8o6dCYbHv9h9Ty1s+MvINcpyaxbEYy1K/81MkKKCJcb+u6Df9P9v//24+/+iwCEkbL87Fvt1wg7g4vLItBrUq7WYpGMBAoa+sd1Mf6bYE7NvE27UGOUkLiiBHy0jqMgQ8wqbC2JR3maEoQ19a81RvWYg0MUohKGA4OiMhptN4e6yIwvaO+9BmI9C2MRivGDc3M3wNHc7nowM8PoUDH3m10rwJ/Ohwa+ccPwxtEm0EeelvxqdtbrG6N3NCUkFhBY31C83JG/PAM5d2e+MkDsQHcEpVUZ1OTrvJL3Sp0Zm74/RxJWSUKGjognbmfqPPHlj6Hh51BzzOBG1g7v/96wmtbPYmAXM9zJA0m5grlJMYJq21tNj2PoCEEtCV2wDiMukh+prfE5oG9w3E07VfWJUR2iHJWmNlYUyiXJgRcNviDjkv4tF7KtDyoVyecfxiHM2MYWevJ3P0+FomstYOvWEfHjyt8Or0U1HCTEHQUImufJacaAzEWUP502jKovEjhkhvjWmltNl1AbUf5Ykhn5+mjkdTL83+l4OxDMFKF1wqVNgTjbaCmG5LIAM/4KGRYeYrFrbqm7r1huvbP6SUWCzqzUPCSv+I4c4wdsWdNAm50s5tpzLpmxlaAdonj+CoY+fHX9b3pDSEdEWb7rISSTPwkKRrHmNxEGx0iXIXXl+60t+DOLEH8raNFtKf+cjjaJjHgeTJbUmhJN/HIr8l/gm5eXp7GoAYd8FauX3w5yo4682jUYsuVrUN+VGl554R/rF7yYgM0fWyTlL82kTlRRqpuPH7+hckRc15ESXHZL
 YN0nEK0n
 ubLyAANpmGcK/qryYaAkm/PwHRlg3+AOqUAXXpGSboW4gDVjJyLsSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

commit 58a039e679fe72bd0efa8b2abe669a7914bb4429 upstream.

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


