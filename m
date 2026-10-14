Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8798ECC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AEC36B0096; Wed, 14 Oct 2026 09:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386406B0098; Wed, 14 Oct 2026 09:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2D86B0099; Wed, 14 Oct 2026 09:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6526B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:14:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B5F7160560
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:14:10 +0000 (UTC)
X-FDA: 85321275060.14.09BD07B
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf03.hostedemail.com (Postfix) with ESMTP id 08E5C20005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:14:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf03.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791983649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=1fmg/Ha63YqKdBivo+fLzBc06bPG5kqvRlHk0mnz5j0=;
	b=NFeIS9086NL9U2RcmzKjhhk97hJENGph7KnB9iNf4PV2gWcgEDTzC4gRoZNiajWQh68joB
	nYdh5+OPKAF4l2VX0mBKSyNWgu4k3m+tQa1822UWiSfE64Wgt0DgaqO10MzqEA4LRNhx7K
	vGoQEid4nvb89eCQJPPhAv68Z7mZm08=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf03.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791983649;
	b=JzbvhOJcJVcHOV/TL78/nYe/d58kqwO9EDi41589M70DDDX0OtA9G9b+RV7/XmJZDyBTih
	AGvRNaMFMk/vLZnc6DyaMjNSDSWXr/Pw4o6mdB57Rqzo3F4atNJw0ODxn/1hSIAPG0Rxcv
	FP6gJJ5lBjTruWK7MGO42bCIcn4fAP8=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGynv-005sVG-1B;
	Wed, 14 Oct 2026 09:13:59 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] mm/mlock: use a long for the page count in mlock_fixup()
Date: Wed, 14 Oct 2026 09:13:58 -0400
Message-ID: <20261014131358.780240-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08E5C20005
X-Rspam-User: 
X-Stat-Signature: jhku8s5of8c7wek5xpot8tp19rra98tc
X-HE-Tag: 1791983648-888827
X-HE-Meta: U2FsdGVkX19d93Z+/eG01SxbEFcDXJSg+YIjHj+ZNloj9tj3dvfNjyl77RgQzvKnRwgsIAm/yCn6RLAQda9iwGvwYSHE/JBrIEtffwca7XupMjlj5AMMPQ0Rcd1sjQqkAXLdQZbiBorIURPhMj0sYZ/tz2J7fNuACKM83pJ2RrdV00jQJ5N2vL6II6cCCz0Qc+bQELkJdEbX1TaA1h70TtuWSgRCGIWFCVpodAs+ELHr82ukcw1nM3XWMrUhcWrh6GJBsqb4owPsm2n2DLsULinAVtt17oPyq6PzFvA0bkbFQn84WFJd+io4e49Mqui+12yfX7NDmIs5EFNX5eVl29r9Y4Ft6FVu4YC9IbCkLp242TT0v5EOQB/jvBSrNGCS2pqfjDligFaILZ72rzrPuZpV6GQ/ViDOt6q+s+p515vfPlLgG9SCnnKGi2JPnyOEbEXtTcgJrBZBo5tfeYC/lKpzvAIky6SHFFHuV4RfeNC8lpWlPiVvM6JkVdgP5PgkZddDlU5BH3rMxHsQWZp9WpE/RVqLH1Qpz6Dh4GuF9vA39EE5eVaPRFIkIfqYDZEKRoyRIlshryvIrKNuDu1peHHaG33A+rUoTqTA+Zw/JNv2jTZ5JEzLh2L4zvNoGkYru8S4+UkcHAlTX5bXDTaedAnGz8wQ2US2PNv5c+eQHFj2nC6lhLNsnd8pU3Mqi2Ao8peuruaHiXbtKG86ATbg+sIzzvNQ+K3q/Qes0f3kbydC9u6q1YI2D4D1B06qqwFYLbAnHWdTVc0jfKU1zWXGGJIQeki7nkoI9QFR9HqE7Pnfnv5kJr3Op5extKNSVBdiItroWr+cHke8GmP4eFa8r/qCi85FsgpPdq8ZBWt9bvHnlVVLXKG4QsXl2o5iJRXFGL2cz+yZebXAAnhwN5eHoCTOpvaYjc+ZujONbv2opex4Y8y6yo6pA/afHONZkZS0cAQeEAxtUuQe9ZHIwMh
 Y7Z+WaHR
 yEybMHd488EVjLO2VYmsdteHKMYhxw7atjux5aNYFcZRIRim6hzvCrfSkukNIj+43Sxyb3OdBnvnek2Ir+YLYp5qvS/BTeGUmhlmEkSmBW/iql0nP8KnS5tUf7cLGMN324Drx6crBPUxfdG6MxekdWO4klfwK9iuVn6/u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mlock_fixup() adjusts mm->locked_vm, an unsigned long, by the number of
pages whose VM_LOCKED state it changes, but computes that number in an
int:

	int nr_pages;
	...
	nr_pages = (end - start) >> PAGE_SHIFT;
	...
	mm->locked_vm += nr_pages;

When a single VMA range of 2^31 pages (8 TiB with 4 KiB pages) or more
is locked or unlocked, the count is truncated to 32 bits and then
sign-extended, so locked_vm is changed by the wrong amount, while
munmap(), mremap() and the other paths that maintain locked_vm use the
full unsigned long page count.

Such a range is reachable on 64-bit architectures with a 47-bit or
larger user address space (x86_64, arm64 with 48-bit VA, riscv64 Sv48)
by a task with CAP_IPC_LOCK or a raised RLIMIT_MEMLOCK, which do_mlock()
checks against the full untruncated length.  It costs nothing with
MAP_NORESERVE and MLOCK_ONFAULT/MCL_ONFAULT, since then no page is
populated.  On x86_64, after

	p = mmap(NULL, 8UL << 40, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
	mlock2(p, 8UL << 40, MLOCK_ONFAULT);

VmLck in /proc/self/status reads 18446744065119617024 kB instead of
8589934592 kB; munmap() of the region then subtracts the true size and
leaves VmLck at 18446744056529682432 kB instead of 0.  With 16 TiB,
locked_vm is not changed at all, VmLck stays 0 kB, and after the task
drops CAP_IPC_LOCK or lowers RLIMIT_MEMLOCK, mlock(), mmap(MAP_LOCKED)
and the other mlock_future_ok() and account_locked_vm() users enforce
RLIMIT_MEMLOCK against that count, so they let the task lock memory
beyond its limit (or, in the 8 TiB case, refuse every further lock).
The error persists for the life of the mm; unlocking the range in pieces
skews it further.  The wrong count is per-mm accounting only: it does
not change which pages are locked.

The int has been there since before git history (the variable was named
"pages" until it was renamed in 2.6.28); every other updater of
locked_vm uses an unsigned long or long count.  Make nr_pages a long,
which holds the page count of any user range and its negation, so the
existing sign handling is unchanged.

Found by formal verification of mm/mlock.c against the kernel binary.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Reproducer: the program below, run as root from an initramfs on
    v7.3-rc7-28-g4056b3c9d3c9 defconfig (LLVM=1) under QEMU, x86_64 (TCG,
    -cpu max) and riscv64 (virt, -cpu max); a longer version also checks
    munmap(), a 16 TiB lock and RLIMIT_MEMLOCK enforcement.
    
                                           before                   after
      VmLck after locking 8 TiB            18446744065119617024 kB  8589934592 kB
      VmLck after munmap() of it           18446744056529682432 kB  0 kB
      VmLck after locking 16 TiB           0 kB                     17179869184 kB
      mlock() of 16 pages over a 16-page   succeeds                 ENOMEM
      RLIMIT_MEMLOCK, CAP_IPC_LOCK dropped
    
    // Needs root (or CAP_IPC_LOCK), >= 16 TiB user VA, vm.overcommit_memory != 2.
    #define _GNU_SOURCE
    #include <stdio.h>
    #include <string.h>
    #include <sys/mman.h>
    #include <sys/syscall.h>
    #include <unistd.h>
    
    int main(void)
    {
    	size_t len = 8UL << 40;		/* 2^31 pages of 4 KiB */
    	char line[128];
    	FILE *f;
    	void *p;
    
    	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
    		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
    	if (p == MAP_FAILED || syscall(SYS_mlock2, p, len, 1 /* MLOCK_ONFAULT */)) {
    		perror("mmap/mlock2");
    		return 2;
    	}
    	f = fopen("/proc/self/status", "r");
    	while (fgets(line, sizeof(line), f))
    		if (!strncmp(line, "VmLck:", 6))
    			printf("%s", line);	/* expected 8589934592 kB */
    	return 0;
    }

 mm/mlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..4fb43cddafa8 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -470,7 +470,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 {
 	const vma_flags_t old_vma_flags = vma->flags;
 	struct mm_struct *mm = vma->vm_mm;
-	int nr_pages;
+	long nr_pages;
 	int ret = 0;
 
 	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||

base-commit: 4056b3c9d3c92ea45955641dbafeb9b960e146ef
-- 
2.53.0


