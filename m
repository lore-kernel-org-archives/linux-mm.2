Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B2CECC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53E0D6B0098; Thu, 15 Oct 2026 12:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EE6D6B0099; Thu, 15 Oct 2026 12:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F566B009B; Thu, 15 Oct 2026 12:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E36FE6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:07:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6DCC7C0373
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:56 +0000 (UTC)
X-FDA: 85325341752.22.F39A087
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A91C9140011
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cm+O5AmU;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsz2YjjiO+P2ROIu2oZfmqjDi2l2nCSLg69aGUFa1mM=;
	b=Xqivri5fUxrggJU/osOcG0I1haTHugIedA3yO0KAmnQh9mqwSnSLaW0yfBH6TU9k7sSpC5
	7dxmEgzysSIrKpxskNElCGDXRmIRlYKpjbn5ncqj6gmepI6KjRjPRsZ5nDypoljU/JuTHD
	4ECZcnfeIbyLZJ1qGIQj3yjkdiC0Eyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080474;
	b=StbeNnI429iu3NKkO6I9H73HScPezeOWBh/HTotixHw7w5OiDl2qBWdnFSWxBqX8MKxcSr
	JKK/ZLmx3hjoXhrCJWLQrQii7L4DDpqazge3sk0wghpUWrp1HUeMvBUPdqhGJ5QtWw1dKM
	FlSBcbnSsiejDJ7bOxwETUlhYRDG9vs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cm+O5AmU;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 412E26020C;
	Thu, 15 Oct 2026 16:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8501F000C5;
	Thu, 15 Oct 2026 16:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080474;
	bh=hsz2YjjiO+P2ROIu2oZfmqjDi2l2nCSLg69aGUFa1mM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cm+O5AmU3+2HUnIWPW+K5lqQV6/iRQx3usBeKCR48KaC+rtCYPWmPlrMDaLMS9tAl
	 7ZJX3LoxWpIjCYuBMNCIXsEz5Ss0/GdLn/HOWp7F85A6rKb6536sfeNed6QQhz2xgQ
	 PEy2Ox9WpLGbw2yum4YwlFV9aFOEBU9p4PsqYDKTLhFwUpRDKDTJuqc1o47vLvNAKJ
	 5cePllUTfjFEKrU2gsBLghsjDHYaTxxp9swMtAH4wbrKx7PCGULylcAfdqfCrPOQtU
	 SsrYrT3TB+LkKzbFGcEbbSMDbc/W8of7dHR6vx8Q/bFvvm8wL26H3dH7DlaXiikSla
	 /3ZZT7SduGiPA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 15 Oct 2026 18:07:11 +0200
Subject: [PATCH 05/10] mm/hugetlb: don't clear the resv_map of a VMA whose
 lock is held
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-urgent_fixes-v1-5-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3065; i=david@kernel.org;
 h=from:subject:message-id; bh=QfDlqL7/jpqfjCmtJhEUh7eM+GYniW1rEDmE4ZrUJCw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DI++Fr1cdRHjsSZOXdrwiccSar79aBi253CmXpd7
 h9v25uydZSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRummMDOt61ujPPKOgM/Vn
 d+kX3T+K/clxImwrkvgmWvj1Z2fwlTH8z8o/dbmX5ZFvRfHLrbbxp28/tL5ztjV0/sacyjcv1A2
 KeQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: A91C9140011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rmazij8y5zjp6xzg9zbibj8k1eggsy18
X-HE-Tag: 1792080474-609634
X-HE-Meta: U2FsdGVkX1/9t2ssnZbQAKYJOVIBMTrt2v23aIpSeuM4jwnpflCQS8SLEUZMQ8nqEGikyBSolz1YKykCPPpJY9KRMe83DjCbi04kK+6UcrSkQiYH8UUzbAdozu2lq7i5x4Xb3Mv8km3DEuTGQHpf/l+vu3va3WaH/pceSVJRghZnzqpmgvt6AryrjyvKmfikOajmKv3wVuQhgFGYuhxKaeDLCV7BgI/g2p0Qv+q9jUZsb5xub0Mg3xEenBdDs/Xjn3G37r8US7xY2e5+fOzHHeeRTrISPqSgZ3gh0GMmU7Vte3fj9a9hqrSMB4ymzra2aMblYmbRNYgdjCeSmptOiLe5KmsC4DBvkJIviJgwDwFr12KYDIAm3x9RBNi0rvwiO+ZD3RTzohm1+gDl1JW8+aNHbUrp9ja7VRPx/mbZXmFzcglC/jZPvLm7SO/pU9q1e/93M+ZI+gIPt2aam2hB/LFfDLji3BaTTamnugdsP0Y0ljpqthX6UjXACZ0iWIYuzs3+e8VHeqkpQ/+v2LkagREN+Ag8hJNa9OIPOGO05f0nuBlzd0e+Gsfpe3EZAQ2p1n8vuiiU8VuY57H2DQfTF05UnDs7SfLUf6KlU8GnkW6XxK2B9cwN7/eyZUE2jwoPpO7N4HHRLo4iZS01FAb+LahLDsNNghyarlm9c3erXm7oFIZmPdziu2JRm8nYs8toAVudPw72XrdY+CgWbVgFNT0u+MQgee6/z4sjTgchB9vytcWTrSIfoKU2e1dtOwKBKlSRS/ZZWPpB2vUfRNkFLtTMXXM7JpkRQUUcesUny1fssasGiId9I/FXWvCn8pt15U/YYhX7c7plXmNVgIOe8Uw7KJzbm1wlJch9oQWYQS0lSgu0Oc/PTHoH83dhihpiklcUNVeOkc7XRvMUWZYRFucyrsRAIiA+ji4K/XjXNMN7aVe0GUy9sRgXrpfWFxkzksGJ3pVCD1EZViTjXNc
 ozankree
 +JZa3U+CC9lUxQ2ujXYYvOXW5UA/YsqEYeCFXpjpa60pZwleA/EzU1HXpkX0HD/QJ/FchzT9vTSD8KMBQuRQymhnmgVeA/7usi8EwJJV0mGhOSqO39H7cCu1xRJJ+dlfZVFr6rLV1msXgCVqlpbljkyXrVm+eZ21//Ay5/fnHbarpaMps+i/ksqLZeb9xyn5SAlpRyJXW4WHmxMBgpx2NkufMOujeL4ZNU6usY1LPo5bYUILle/O/4TflHh2soI55E1JBzxGHNWVgS5BHTHEVoBAZ5UiLmqnePiI68VvduxyokGbrz+o5MJngfsIjXfz8DlzqTfZEzSx1QCkWBv7eiVQQK6RzFM0tHPV4MfEkJmqMT0pn8S9VFSvcJIM0F4Zlcbf7N1tLjw6Rv5y4NzCyGExaxqzBk8RUp5njrMyYKnUfljxcvdtLMXENb4MT1vZNQdjSnSAphr4henM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josef Bacik <josef@toxicpanda.com>

Since commit bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private
VMAs") the lock of a private hugetlb VMA that owns a reservation is the
rw_sema of its resv_map.  The hugetlb_vma_*lock*() helpers find it through
vma->vm_private_data, anew for every lock and every unlock.

At the end of mremap() the old VMA has to let go of the resv_map, which
now belongs to the new VMA: clear_vma_resv_huge_pages() stores NULL into
vm_private_data.  mremap() holds mmap_lock for writing and has write
locked the VMA, which keeps away everybody who comes through the mm.  It
does not keep away those who find the VMA through the file.  For hole
punch and truncation hugetlb_vmdelete_list() does

	hugetlb_vma_trylock_write(vma);		locks resv_map->rw_sema
	unmap_hugepage_range(vma, ...);
						vm_private_data = NULL
	hugetlb_vma_unlock_write(vma);		no resv_map: does nothing

and the rw_sema stays write locked for ever:

  WARNING: lock held when returning to user space!
  mremap_punch/116 is leaving the kernel with locks still held!
  locks held by mremap_punch/116: 1, last CPU#1:
   #0: (&resv_map->rw_sema){+.+.}-{4:4}, at:
                                       hugetlb_vmdelete_list+0x46/0x160

The next fault in the new VMA sleeps in hugetlb_vma_lock_read(),
uninterruptibly, and it holds its entry of hugetlb_fault_mutex_table[].
That table is global, so a fault of any other process on a page that
hashes to the same entry sleeps uninterruptibly as well.

All those who take the lock of a private VMA without taking the mmap/vma
lock are affected: rmap walks. So hold i_mmap_rwsem around the clearing
of the resv_map.

No change of behaviour, other than that mremap() of a hugetlb VMA takes
i_mmap_rwsem once more.

Original fix generated by an LLM and sent in private by Josef.

Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Reported-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: avoid local variable, move and refine comment, description cleanups+simplifications ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 86fafd0782987..f8ad2efd472cb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7467,6 +7467,15 @@ void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
  */
 void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 {
-	if (is_vm_hugetlb_page(vma))
-		clear_vma_resv_huge_pages(vma);
+	if (!is_vm_hugetlb_page(vma))
+		return;
+
+	/*
+	 * Rmap walks might still find this VMA and take the lock
+	 * inside the reservation map for __vma_private_lock(). Don't clear
+	 * the reservation map while that is possible.
+	 */
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+	clear_vma_resv_huge_pages(vma);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 }

-- 
2.43.0


