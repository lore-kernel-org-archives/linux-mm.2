Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A579F606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LaSW6y+e
Received: by kanga.kvack.org (Postfix)
	id BA0AE6B0B01; Wed, 25 Nov 2026 17:35:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79F46B0B03; Wed, 25 Nov 2026 17:35:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A688A6B0B04; Wed, 25 Nov 2026 17:35:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1F26B0B01
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:35:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10F5D1C4A35
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:35:37 +0000 (UTC)
X-FDA: 85475099514.30.A0380CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 396FE40008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:35:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LaSW6y+e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646135;
	b=cDQuDi1uzsm8ybcsiYcYdA84g9/GdLQmrT479XYA3tGhQ1Uod1lc78E6D/X1Dd7OHF4EaJ
	Z+na90nG/ByK7sI2qlzsNIG2MWhmSq28Z9TztUlfUNBdH3bUmj/sh2S7adYs2TldlFqJWn
	4Uk00rmu2t9TKNE0yscP+NSiMxs7kOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/X9EnMBb1EpL9DRptGLIFWJ8P5QIzwUUyryHlQqYQoE=;
	b=jYhdK9rOiUZaDY0ogM5VPqoySfag47E+T08Y7rcDFhs3FC/JZ/NJRn8VjuO8n5w/niFZBb
	O7sq7b5+fAU51zLG6x/PzYbaTMtFVPlrdWdhh6ABrLJbSYuYoAyfjmXcnl0KpZK4NUZB6l
	lhwgdI5s08WZkaoQzOM7It5sG8Ck7sc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LaSW6y+e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C572862620;
	Wed, 25 Nov 2026 22:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F9E1F000EB;
	Wed, 25 Nov 2026 22:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646134;
	bh=/X9EnMBb1EpL9DRptGLIFWJ8P5QIzwUUyryHlQqYQoE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LaSW6y+e/DzXfPl86UGKdoQPv9ftcRE1mSP6BQi2mTPKSfOzGzG5UKB0kjB1xLF3K
	 X5Z9gc+1vRMEyWO3ipTaFE/9r7jRJTQT+zdYCM7yGMmMHs/0/tGpDc8WHY144pLAeW
	 cf+e9mPaJdVobJqlLRXe/xexriXSyw9YprFEWKznN9vGLwDqqLvT2BWje5FMauRun0
	 CsymNizBrf9nYxFare6A9yymIDcTa+Cw1DrGLon+DPGQioOKDFmH7YhgLm/8ZlhPpD
	 Z9RkXImdGSDRgcRIq4qT0RB3IU1cDMGK1mPyLcI8NMCQnfxZR7Co9kI1hkS0qG7mlo
	 wjqJJ5BVwvEvw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:06 +0100
Subject: [PATCH 08/21] hugetlbfs: recheck the vma range after the lock wait
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-8-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3507; i=david@kernel.org;
 h=from:subject:message-id; bh=rw8ESenx8D20BApyF+9LorlGrtKZwWBIIKOWjIuUihM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1TW1krnXZg7+9hUgZ8sKi19nDUTWMu21RzfPoN3W
 9L64hiPjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZi8I2R4XmsbGub1+WExQVB
 S4Jyt8a+fGclrCG9z8E68covtWNCfxkZpnye+OjPuw1cixY87LavL+6TKRVl/u93avbRTRxnppx
 UYgEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 396FE40008
X-Stat-Signature: 7shicef3g4cn19qbjp1gjatfoeoxdff8
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795646135-589970
X-HE-Meta: U2FsdGVkX19fitgLv5s3quGb9RXQHzUntmfCZfgvrRf8TjapnPVRkhUzj51xLuAaSp8N0yF0UhOaAZoyF6W2SkSPBPFkHOuzVIis9rAOcB2c2k21U8vU+kWwlkz9Ud2zsXZkFBSCllpKgYVsT8u1kOqFQyMn1GRHo6TqeWo15Ugs77TYDafGtUIgTYnObdXO/XFvoNjDtzg7tc8umFIenZ2xS0D7lcWFkXvKBjvDa2UhuomBeKKaUl53vq3rqYkpn2DJuTGNMpObaCppXQmt/wdC4aToQg/X2E1yoyNPE5uIF/Tj2bkTyWJdVvNBao0b+9Etk+glKVNNTpvbiwSJXjR3JmQO6T0qxzTNtIIiN7XdbEGbymXuSnGmehg+SlhHr9mikDcc2MmI1BR2zqPs8smz3+xFMkaUv068UgRclTWvjy2/Tb9i2YICprg9DGTdStTwZH6UNvpcuhLGC8P7cpSUykZGyg93b7D9V4C+Nxl5HMd2BFO4UBF0NsRj84TWo/Ji/KuGzEv9Bc/1FiDX9TqwgfaAmjiffl4aHDjovVEbO4X4yvQUNEZ8ZJ5I1O52D7mbjhi8UGpXfR2+cdu+zxneHgLCcvzO9QLS6wHSEeoDyHKzYfa2WrNrqybjKF1464cLx5zYU/e+vjB69ZzqoXTvlMLpLveqQnFuopuEVnx8a3L4Zn1F2nD1ekVbwzUzUP9fgft2NKHkEYOsJC5GE2mK3gT3YqmDGeSkRXeh1GlFUes4nvFDO6wJBv1y7dLH9WIhgvx5YR4PZ+nXYBWDCa/tItn4wqh4YqjX/togzVSra+MB4un5ssinCfiqVp/wDV2SoRda7ilXeO4vaj2Ldu+jDnMD84XSKXflCz3BCwF/qdFCHiM0uG9nY2If4WAQ5IbSBFQJRovX1OiFlcoKhUC/nF3+W7wD9G8HDFVOwy85hFIsFwmN7gZxZdqHIoZm5mUak8CVk0OG4fWZ7ip
 ABrmiWyc
 vSB/mHgi/q2vtaxJDPbMAj4L3dqRgEHd0vWVdULYbLsigR9LRdwSaUqcACFteCL8k31p1+r+0MIvdYdB3jJSuSHTJso9nHpvqSAx5eInQth/j5ZRaJVCjRpVvrC/BFVvLJ6JOH1r0athJzKjGTCnF5CPlSerJZWPjXsySqYoptvystTQfmP93xwpvL/AZ4OYNiaUBlliW3WDTvk0O27O2RXrkehxdyn5s7Isr2yv13cHXbkDd2Oweyi/fxBhBj9AMMNGJ2SiLbInhUddZgTMtQbQQG9uCJUdn+4pytlnbHJxl+y4LMTPqYQ668EBnDjlYMHUogBS1+Gq+o8eQNP+Fa8dCyM5LaPClrCJtI+5Az5ME9c8hfkNv8HAzZsnW1mf9FG0v0jX/vDgkq8GjOeB1nWsNmfmNsA40U7Dq9iePP+kVJQ42F1z16k8+CTx+ydc+IhWxjVOnHSZHmKco8VSTl79M6M5J4ILmAEDK9YM3+XEkiZKapu2RJtCDykf4iO7WbFTCUxfcAk0UUKVHhYx4lgiam4QRNA5DiLWH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A hole punch or a truncation of a hugetlb file that races with a split
of a shared vma can lead to a use-after-free read of a page table, and
to an MMU notifier range with end <= start, which trips a WARN_ON_ONCE()
in KVM.

hugetlb_unmap_file_folio() computes the address of the folio in a vma
and walks the page tables to unmap the folio. As free_pgtables() unlinks
a vma from the rmap tree before it frees its page tables, i_mmap_rwsem
does not protect page tables outside of the vma, so walking them can
result in a use-after-free read.

The rmap tree walk guarantees that a found vma spans our folio. However,
when we have to fall back to locking the vma lock first and drop the
i_mmap_rwsem, we don't check whether that is still the case after we
acquired the vma lock and the i_mmap_rwsem. The following is then
possible:

    hugetlb_unmap_file_folio()          __split_vma(), new_below == 0
    ==========================          =============================
    hugetlb_vma_trylock_write() fails
    i_mmap_unlock_write()
    down_write(&vma_lock->rw_sema)
                                        vma_prepare()
                                          i_mmap_lock_write()
                                        vma->vm_end = addr
                                        vma_complete()
                                          i_mmap_unlock_write()
    i_mmap_lock_write()
    vma_lock->vma is not NULL
    vma_offset_start() >= vma->vm_end
    vma_offset_end() == vma->vm_end
    hugetlb_vma_maps_pfn(vma, v_start)
    unmap_hugepage_range(vma, v_start, v_end)

Similarly, a split with new_below == 1, where the vma keeps the upper
part and vm_start and vm_pgoff move up, or shrinking the vma with
mremap() can leave the vma not covering our folio.

Let's fix it by checking whether the possibly split vma still spans our
folio. Add a VM_WARN_ON_ONCE() to highlight the problem that was
previously missed.

This has medium urgency, as this is triggerable by unprivileged users.

Fixes: 40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: adjust comment and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 5437a55d14f1c..0b96fdc3ad9d8 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -442,10 +442,11 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 		i_mmap_lock_write(mapping);
 
 		vma = vma_lock->vma;
-		if (!vma) {
+		if (!vma || vma_start_pgoff(vma) >= end || vma_end_pgoff(vma) <= start) {
 			/*
-			 * If lock is no longer attached to vma, then just
-			 * unlock, drop our reference and retry looking for
+			 * If the lock is no longer attached to this vma, or if
+			 * the vma changed and no longer covers the folio, then
+			 * just unlock, drop our reference and retry looking for
 			 * other vmas.
 			 */
 			up_write(&vma_lock->rw_sema);
@@ -459,6 +460,7 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 		 */
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
+		VM_WARN_ON_ONCE(v_start >= v_end);
 		if (hugetlb_vma_maps_pfn(vma, v_start, pfn))
 			unmap_hugepage_range(vma, v_start, v_end, NULL,
 					     ZAP_FLAG_DROP_MARKER);

-- 
2.56.1


