Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BAA8CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FD98E0010; Mon, 15 Sep 2025 23:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0B38E0001; Mon, 15 Sep 2025 23:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF208E0010; Mon, 15 Sep 2025 23:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6DBC8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:08:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B27EC07FF
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:08:19 +0000 (UTC)
X-FDA: 83893629918.15.3997387
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD16A40006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:08:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N8A+NpMj;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757992097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1ch+TLn78TGl226hk/YBzIfpivaXLG3ewt/ogjQADY=;
	b=xNtFQ6mv+MMEpY1WvU/sFv05CNaPE/pWW+rc6xG31yFKnyvgKFMCIt8AOa1wuFyfwp8Bj4
	ys2M+upqpcZqk0Bu5Ri63WNCXTKQWmyN4bLPVH1e6bKzdg0OS+WB06f8uZfRuDMKurcE/1
	C258fxGKhltCGEcv/+DJ8b2atCk5i44=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757992097; a=rsa-sha256;
	cv=none;
	b=j7OD2WUpvh5ivIkZ1PN8BGVGvEeLAQUuaPgDgXj5PclWOGpzRbL0qgWsVC0108aJTVCC5T
	c9I0kk7zMC0z7auVpi+P8yh8B8x0or8RmICr9D8e/5Ej2r379SIjjEqr3zdmxT1t+6djmM
	tJA/5gKKiaMhi2M8TcGiq1sIANgIbko=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N8A+NpMj;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B11360054;
	Tue, 16 Sep 2025 03:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EC9C4CEF1;
	Tue, 16 Sep 2025 03:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757992096;
	bh=SzU9zd6gKPgO0BdktrwqDgUBQcmLllVJGEvbli/LrUs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N8A+NpMjB+OO2qFkCikHUYaXyurnUzhTBVaKoQWOUESt4QplPSf6y5gNUrLZdTnzH
	 NJHtWZhaZ92UXB7/08B/2cODdTaYBEELsRs1Okg4QdAKEJQVeQ3prjctU0f7uZBUuA
	 xZZ6jGQOsShojE+eX88M6C+jgKtO7J0y2OQceE3o=
Date: Mon, 15 Sep 2025 20:08:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@redhat.com, harry.yoo@oracle.com, osalvador@suse.de,
 liushixin2@huawei.com, muchun.song@linux.dev, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
Message-Id: <20250915200815.e2b844e0a3291fa994d333b4@linux-foundation.org>
In-Reply-To: <20250916004520.1604530-1-jane.chu@oracle.com>
References: <20250916004520.1604530-1-jane.chu@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3menpffoki75yqekt5dkpbiakwmcceoi
X-Rspam-User: 
X-Rspamd-Queue-Id: DD16A40006
X-Rspamd-Server: rspam10
X-HE-Tag: 1757992097-15217
X-HE-Meta: U2FsdGVkX19neo0AVmDARB4bWFzvLL8liOr0KVs8mZ+7kQnL4VpsR5hnUOfKyO+BgAC8X7X8jHaRMCOjB95Qvj9ajd0qqTFrRfjdtXmTL2fLEdnPVex72QsxoMtPkHQhqT+BCue3dZNzqw5cu+hsn07WW5fCH/R3i7AgkZcRS48Ughd82b41IV2lE4sA3U9AJQcxEct/4QSMGHhAJvwuuyBrzx8oiV791BAWJlWostmw09ZJ/21PQ2Om2Zdrme7/WHYCNMS8mi3nVR2l2vv5Sd+P7rOZ4P/99lG6ypJxT4eRZh/B/vq367o2pdh4i7w8MkiCQP7zm+EE3r6Hh41zj+rulXP2cJ4pXO9FEKJjLt7kkuDt19XaZ5L/kc9F1d3y4qtcH1npXcRb2zWKLLd8Dq8P8/NCUbEuGY5bcE0CqizVav7P6jO98Cv92cXqA03boyuj2BtaYgfyON2fBmRUoA5YLjqarfs03S+WwRy3gQ+f4aqR/xfXFUcKl7yxWuK9ovutYis8C37iJrlTxMR4FENYFxo/DHF7A5bHqxZUb2wsAYKukVz/6OoA0EDZuDzXl6NCHPx40EIlq/1CHJNNNuxoGwrP5Q0G/semPEDNHKjgrjmHqu3V+ZXnVudTDiUmewK6x8UTaltbSnTs6nX9GJ8li4ync9MI7bQ/LB+vXfNFVFWgiPiVu90PaZAYZA30LPL/DUZsP17Pb8z14b+ctyxQjr4HZ+N2/UTzaaZdP0j5rHyXPC5xo6Gw6COssiSK6SQ4/JKxbdMJL1NDSkUVWIfkC8lkWDWMfv2rFurQ4dN/qiIQCpCPZBIlCAQ809oAlaasLDsyMzdnL0Yh2lQJvgYN9ByFQjiLA4kv9nGgiGaGvvgbRQ0DD3sm1AfhyjXzLoXWXDfGDn6eTOFMqy53Lc2AO5OWSmvPmPeL0UAmkk2PYa4ZM4cl8S/g4Sthm/3tq7BXYB8Lq7xyocHDfy1
 56Kt3etv
 R1m0jxrI8smJwznt4uq1AXzZfO+7Gi3eZGrOhicrUS7FgHU6t21K/7vbzvIlLuZMjmrHntPm+e/ylLXmHhNHXnfftYHE07dUxvGyoF2vOkdyR2pydcON81s/893F4bohlbsspbbrIbg10NTbNFqcLpZVoVjJe/ncLFvUw2UrSM54/JsYAMVLSLYNStsiN0iXAVeDfohkkxC8QJDsJIwJEbznG+m+Oqq6AY9y/6d/vmt9F9C0It1WCFIzC/fW4aeVNnBrEdbVz2Y7XL58T651X4y7cTL8xf8oqS6zBxqMomO7tYOVFCqoNUPOWgj3fF3HaoJ2y3i8SSNtFyqQWyELv7y7JQBAtEladr6Z1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 18:45:20 -0600 Jane Chu <jane.chu@oracle.com> wrote:

> commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
> introduced ->pt_share_count dedicated to hugetlb PMD share count tracking,
> but omitted fixing copy_hugetlb_page_range(), leaving the function relying on
> page_count() for tracking that no longer works.
> 
> When lazy page table copy for hugetlb is disabled, that is, revert
> commit bcd51a3c679d ("hugetlb: lazy page table copies in fork()")
> fork()'ing with hugetlb PMD sharing quickly lockup -
> 
> [  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
> [  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
> [  239.446631] Call Trace:
> [  239.446633]  <TASK>
> [  239.446636]  _raw_spin_lock+0x3f/0x60
> [  239.446639]  copy_hugetlb_page_range+0x258/0xb50
> [  239.446645]  copy_page_range+0x22b/0x2c0
> [  239.446651]  dup_mmap+0x3e2/0x770
> [  239.446654]  dup_mm.constprop.0+0x5e/0x230
> [  239.446657]  copy_process+0xd17/0x1760
> [  239.446660]  kernel_clone+0xc0/0x3e0
> [  239.446661]  __do_sys_clone+0x65/0xa0
> [  239.446664]  do_syscall_64+0x82/0x930
> [  239.446668]  ? count_memcg_events+0xd2/0x190
> [  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
> [  239.446676]  ? syscall_exit_work+0x118/0x150
> [  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
> [  239.446681]  ? clear_bhb_loop+0x30/0x80
> [  239.446684]  ? clear_bhb_loop+0x30/0x80
> [  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> There are two options to resolve the potential latent issue:
>   1. warn against PMD sharing in copy_hugetlb_page_range(),
>   2. fix it.
> This patch opts for the second option.
> While at it, simplify the comment, the details are not actually relevant
> anymore.

Thanks.  I dropped the v2 patch from mm-hotfixes-stable and added this.

> Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  include/linux/mm_types.h |  5 +++++
>  mm/hugetlb.c             | 15 +++++----------
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 

It's conventional (and useful) to explain (beneath the "---") what
changed since the previous version.

Here's the v2->v3 diff, which appears to be based on David's review
comments:

--- a/include/linux/mm_types.h~mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count
+++ a/include/linux/mm_types.h
@@ -631,6 +631,11 @@ static inline int ptdesc_pmd_pts_count(s
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
+
+static inline bool ptdesc_pmd_is_shared(struct ptdesc *ptdesc)
+{
+	return !!ptdesc_pmd_pts_count(ptdesc);
+}
 #else
 static inline void ptdesc_pmd_pts_init(struct ptdesc *ptdesc)
 {
--- a/mm/hugetlb.c~mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count
+++ a/mm/hugetlb.c
@@ -5595,8 +5595,8 @@ int copy_hugetlb_page_range(struct mm_st
 		}
 
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
-		/* If the pagetables are shared don't copy or take references. */
-		if (ptdesc_pmd_pts_count(virt_to_ptdesc(dst_pte)) > 0) {
+		/* If the pagetables are shared, there is nothing to do */
+		if (ptdesc_pmd_is_shared(virt_to_ptdesc(dst_pte))) {
 			addr |= last_addr_mask;
 			continue;
 		}
@@ -7597,7 +7597,7 @@ int huge_pmd_unshare(struct mm_struct *m
 	hugetlb_vma_assert_locked(vma);
 	if (sz != PMD_SIZE)
 		return 0;
-	if (!ptdesc_pmd_pts_count(virt_to_ptdesc(ptep)))
+	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
 		return 0;
 
 	pud_clear(pud);
_


