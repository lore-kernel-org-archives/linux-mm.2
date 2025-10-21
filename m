Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB55CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 21:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571828E0010; Tue, 21 Oct 2025 17:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549808E0002; Tue, 21 Oct 2025 17:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486768E0010; Tue, 21 Oct 2025 17:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 30D328E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:10:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3D1CBA49A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:10:51 +0000 (UTC)
X-FDA: 84023365902.22.B17C381
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E18ED2000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:10:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Sxuh6gdZ;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761081050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rWnAwrzm8A9V62GaFabWYZ0BgD3yXEcNaO0orf0JZk=;
	b=Haidzg6SdkR9n/QeUt0Yl3r8EzohyebonXlzXCQYOht4paSt7naYNlXE3phlvAtVWyVJ3o
	mUY/DJEj9NmPZN20/dRSva70Cuz8OJIcZu99SKR1OETnYGTHB4iXwesJCsaROU7Qyh4EvE
	2kGNy+mW/LUnZhUAiIgFi4sRXOZ6eac=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Sxuh6gdZ;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761081050; a=rsa-sha256;
	cv=none;
	b=zz4Ghjq2HhmxDhkG4A4YF8/11ikmprJ2RxgizCET1YRyc5x/FoA1TUjwWy2mkSMKdtFIm/
	Sek+ClHh196gJ/zyZrjBM1IQAn501Y1nNtA+azGOypdtNNjkDvOvbPjiqdfVwVvcePieWZ
	aQ9LBawyCgZFoi843bknnkHYbdE2LvI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6567401CE;
	Tue, 21 Oct 2025 21:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F431C4CEF1;
	Tue, 21 Oct 2025 21:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761081048;
	bh=CyjoCB+nOz0XloI/00jaAfTOPYcrftUYJkwBXkzSnRU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Sxuh6gdZ8tBwi/FrddVvT6zN/S0xQu3CcZiR4deQfvK2CEmOAWnhlV6otHUg2G+Me
	 4bVTKWRgfLsUgPo5eBXVGtvk+HYc4988REnbdEPfC5xVCmfjZqiqJnGkjOQsIxYzvi
	 rLggorjf66h1/4Z5DRmHyf0slgeeXXfNWVFLRAIU=
Date: Tue, 21 Oct 2025 14:10:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com,
 Aishwarya.TCV@arm.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v2] hugetlbfs: skip VMAs without shareable locks in
 hugetlb_vmdelete_list
Message-Id: <20251021141047.532542aecdb0dc5fdb95696a@linux-foundation.org>
In-Reply-To: <9d20e689-c06e-43f8-811f-3e66f3e86d2b@sirena.org.uk>
References: <20250926033255.10930-1-kartikey406@gmail.com>
	<7a1d0eb0-ab08-4fa8-bdab-b193b69a8c9d@sirena.org.uk>
	<9d20e689-c06e-43f8-811f-3e66f3e86d2b@sirena.org.uk>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E18ED2000E
X-Stat-Signature: 3xwr85gofwk3pcwu4de8ftfuez67s65i
X-Rspam-User: 
X-HE-Tag: 1761081049-895017
X-HE-Meta: U2FsdGVkX1/GqxF2M4kC038DZVDf0MOp0BWZNmO8rlwUb1+SDC2VUzdMtXsEzTxJZYXSsTSMrLKnjEef0usZKj7SZEbvVBH9F1qkcRyV6C9jYJESwNQBS9yEgCzeuPJ2KIUx8yQoYJJvJSj0WL5v2h1FfAfxdCv1I5sK38EY3mfJ3K6nYLiLYb9Z8HkFv6cTEnoD7lfTR8OgPRsIouFqbOgGOuOKdOpVhjbPK0BCSMp+wXO0ZPcK3ahPH0SafwvthIAJaZ2BhCojMx/MJzw4A2wKJXiMHv+ZveUhHPq3W/8tjtF4iCknEw5kjJPdJxet5PzbXU1On+4q/hfh3euppiyXO06yKAAkS67aXSYyjqgU4APk4ZBDKco31nMbupbYuRcGcsNBMUrJKOtgfQVZirpMmB+fzdjn871eH0RbqkjC8JQi9FJFF7Vo0oFtPnHvLD1SKpSGZ293tN4qdbXdZd5rFAvNmaVkmLGB2DzmYijCuJ1WbI9f8yRhG1yA0n++mnkcXUpBfZ0EPzKT6eMSLKV0qkRWgE0sLZ73ATod3WuGC2lyu10YvmmOPVemTivJMhNW5tMVfdg+hzepUwnD0/foI7yIjdkX1bXHG/CiA7KoqLJu3pRlr6e43c5Ka6Gjh0DWrJDx3jAWLgiORYjc1ezcUHkDcN8O8rJyJAQHxCrEH769Qe9YXjPFvrZHFAeU5rnk+Fk2Gtw7WH+UVDbXkslOCHPNT0hHZRnlC8VGXlXP6aS0NOctARLamMe5vLeuXwd/K/G5UBpzhoTCBMEzZNR4rlK89B0Hm3qu5ZHjknq0ku7M90BrPKlCQeUgXXT2OLqmAjNFBMNkSlGGHiM9Ykw3XI23EWcBd0uI/dxGKvV2WqseEN7alPoRSgvRsprLyp6f8EWjKQHRC8PLPhT9OvDz2W54REP8XYfg8/2PNn6Ptp/JZPx/4oPnxZng1S3AlpqhCFTL2H5HJwtOPhL
 ylnoLaO8
 97ZO6WKTu0Zsv9anEdj2/lmkV4kxN2+eNDHzb9GiigrA8pSUTJSyvnxko5PTYA63lBSegtTzJ6xXaUWt5mXxThH115VkrOB2N+S7CbYEAXmfl6tRBS0l7hnCA9yrPAioIXWlTmanvD6ttdU67q69pZVLTydWZWn2CU9rohy5BF2zm/zqIVNAaPHcKFzq+22rG4jpbMDD9h1AqVU6ed5iW4JaQE2943i3N19Fl3Ej//DR9moQQKAvyFRDHW0fYbcRzE47R4/CBpsNUagsNEv/f2fu6Zlg/LdoXQZQYmA/mNEzf9e3rDOBEEA8O1svxng6iJn1PZYrK89zAXBnP5O+WmZmjPYfXKO/ORHQx8urXO6vig1ec5Uq193aj+eyXaIpOAjPc4aTNrfoO+oHJtZBytvfm7HAQ//2Gzc4sfHfYnWxkODLkXo2Y3WhSFSdP0wqQ0Q6uwGuSVKyj+2iebKstM9CWUtZ1SNYwQEmgQbNjpLnk7VWPSJu6m0gRVlUYf7cUUevpJZT27D52WFf26kP8YUcbZy36DeCSrdVaZ30mBlq3wsESFt+ZQhXcoW0qCGXD869SBWLKChfQSl9cUiuq0Y1kYBJrRFr0xUQWCyLrEvDmyOETOvFu66+F3xnrpOaSgdieEW2TjdA6VSwqVddR/WVhVH6doMz0hkJwolafPlRDZRVzDeQRL+jjPvGqB6emWjR9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Oct 2025 18:52:11 +0100 Mark Brown <broonie@kernel.org> wrote:

> > For the past few days I've been seeing failures on Raspberry Pi 4 in
> > the hugetlbfs-madvise kselftest in -next which bisect to this patch.
> > The test reports:
> > 
> > # # -------------------------
> > # # running ./hugetlb-madvise
> > # # -------------------------
> > # # Unexpected number of free huge pages line 252
> > # # [FAIL]
> > # not ok 6 hugetlb-madvise # exit=1
> 
> This issue is now present in mainline:
> 
> Raspberry Pi 4: https://lava.sirena.org.uk/scheduler/job/1976561#L1798
> Orion O6:       https://lava.sirena.org.uk/scheduler/job/1977081#L1779
> 
> and still bisects to this patch.

Thanks.  Were you able to test the proposed fix?

From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
Date: Tue, 14 Oct 2025 17:03:44 +0530

When hugetlb_vmdelete_list() processes VMAs during truncate operations, it
may encounter VMAs where huge_pmd_unshare() is called without the required
shareable lock.  This triggers an assertion failure in
hugetlb_vma_assert_locked().

The previous fix in commit dd83609b8898 ("hugetlbfs: skip VMAs without
shareable locks in hugetlb_vmdelete_list") skipped entire VMAs without
shareable locks to avoid the assertion.  However, this prevented pages
from being unmapped and freed, causing a regression in
fallocate(PUNCH_HOLE) operations where pages were not freed immediately,
as reported by Mark Brown.

Instead of checking locks in the caller or skipping VMAs, move the lock
assertions in huge_pmd_unshare() to after the early return checks.  The
assertions are only needed when actual PMD unsharing work will be
performed.  If the function returns early because sz != PMD_SIZE or the
PMD is not shared, no locks are required and assertions should not fire.

This approach reverts the VMA skipping logic from commit dd83609b8898
("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
while moving the assertions to avoid the assertion failure, keeping all
the logic within huge_pmd_unshare() itself and allowing page unmapping and
freeing to proceed for all VMAs.

Link: https://lkml.kernel.org/r/20251014113344.21194-1-kartikey406@gmail.com
Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: <syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com>
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Tested-by: <syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    9 ---------
 mm/hugetlb.c         |    5 ++---
 2 files changed, 2 insertions(+), 12 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare
+++ a/fs/hugetlbfs/inode.c
@@ -478,14 +478,6 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
 
-		/*
-		 * Skip VMAs without shareable locks. Per the design in commit
-		 * 40549ba8f8e0, these will be handled by remove_inode_hugepages()
-		 * called after this function with proper locking.
-		 */
-		if (!__vma_shareable_lock(vma))
-			goto skip;
-
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
@@ -496,7 +488,6 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		 * vmas.  Therefore, lock is not held when calling
 		 * unmap_hugepage_range for private vmas.
 		 */
-skip:
 		hugetlb_vma_unlock_write(vma);
 	}
 }
--- a/mm/hugetlb.c~hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare
+++ a/mm/hugetlb.c
@@ -7614,13 +7614,12 @@ int huge_pmd_unshare(struct mm_struct *m
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	pud_t *pud = pud_offset(p4d, addr);
 
-	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
-	hugetlb_vma_assert_locked(vma);
 	if (sz != PMD_SIZE)
 		return 0;
 	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
 		return 0;
-
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	hugetlb_vma_assert_locked(vma);
 	pud_clear(pud);
 	/*
 	 * Once our caller drops the rmap lock, some other process might be
_


