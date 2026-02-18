Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D95CE9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA30D6B008A; Wed, 18 Feb 2026 06:01:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E266A6B008C; Wed, 18 Feb 2026 06:01:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29286B0092; Wed, 18 Feb 2026 06:01:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B75C76B008A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:01:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D5A95905E
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:45 +0000 (UTC)
X-FDA: 84457286970.13.DC175C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9D9F11A0013
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GDknwJ8H;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771412503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bA3CahaMMdxywwsqVTVTf8q36FxFQ3rPgJpDWoTf2hc=;
	b=3HAi5YaTP/Z/mmEJaaGyXeQY7coYCjA55paT4XUKl+Pz/w/dcO9NMpAyANTWsJOAIMVNOO
	kDu925RIehbGgrSfr2dJIInpHQFgEZ3S6EVwNyFDj971TNcKHu5U3xYiQ4RF3d0Q9oWvD3
	DKXfuBNK9WFV/HVqif2/vwojW5wvZA8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GDknwJ8H;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771412503; a=rsa-sha256;
	cv=none;
	b=ZL0w2djNx8awsMim/0sybIbsA7OScrk7+9U5z+Wpi6480h4OlZ0mBodY15epo+g1lL5Lnt
	6PfwNJN839BYnTNp4HpehTlK2vS/776U5PQrWtqkC/t2Alv5tf7oQ2BYfb5vhmOPE0KCkU
	vpus42QaNjpF5REr5+1A0cb7vah8z3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22FB961858;
	Wed, 18 Feb 2026 11:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367C3C19423;
	Wed, 18 Feb 2026 11:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771412502;
	bh=At1F7reDT+xPZZHxkhFsCwDp5yvuWAQ6KFfw4mUuytU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDknwJ8HcRhOqT37R1NBcIhBpefZ/P+to6KKEA0paxo4VkGwimSYx6qTHkolCsohC
	 WfJ4LYZ3vXPe9GWTBsMwzhjT1cRS50S1uKI0v5yAh50szYhQjQktb8rdVW7ytpKW5t
	 2VVpNkWG0xC0V/O9n/B5DeAoFVBI5tc+0mbQ/QBjp3AIpVSWC/emdHV1BxkFVa++O5
	 TF13GzxzY0n+C7FtMsmHNNmVxhUW/dMiSYVxmyvhMM+sEbLvKYY8/M7kKk79WmUQe+
	 S7NMZKVQwTzeLHeLng7U8TdG8rd6gxsaVhRL8sMhWErrQrfIVgd3zXKGX2AivGUook
	 QBWCnRTHIy8Wg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH 5.15.y 2/6] mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Wed, 18 Feb 2026 12:01:25 +0100
Message-ID: <20260218110129.41578-3-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218110129.41578-1-david@kernel.org>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D9F11A0013
X-Stat-Signature: tzwhde7t19t1ums7jsw3uob68int53dz
X-HE-Tag: 1771412503-611311
X-HE-Meta: U2FsdGVkX19hkzMeiM0OMKWfDRMBd5czIGcjhzqC/rUXRMJ+j56cXgSV4tE6ZOWwrDuP6dnP+DvNNvhG4jslSlu+gh9+vEE90/L6Ikm6NZaxGvpmfOM7hp2Is1YqMUaFSJC6JeGD09JdJ54L8YEqTZ5rcnNrCeFQruC//Y33bC7MA329QInNs3mL+I+YgkQIzLyeqfcPQY6RldDBXMWf/YTSICnBEKsxzGMR8k/m6pM4IKOYU2lQr5nyFpg8T8r53wHUMneRtPKprRRoTpU6ks8fIIcZGmx+mfV+UJ2lD/QyFEUhK9N5YzjvDm4N6dHA7qIqOSrCLZyenLEHWcyUz64Q5U1ZiUwWPdvfrStc54rZ2pcdqRjbAowa+mI1442G5XWV2ATPK6aGBsl4eZEK3F0e0y1YEV18SZzL1IJ727LGthhUrAyhZ3M/YgUN1sKL1qGp88GKySa3d+bbPHdAal4rpRKlvXIZFGXDGCQ+v021VxH2CcQFSGFQoDEcaQTpi9ahN0WRi6hlpZ7y28GvwDLj8FutJkY5OGQEHaaPPGBP+yKQ+/xfrcCBhBjMGz8EiKN6hZBDcGM6MNJ8XS43G5YnkXVxrCTTeLIn98mWHHn0pBrIs4GxBq2IuLfg+lhZ2e3NU0YHeGxkbE3+kPoM6qVYRdtcBQW9esDyvtJEYglqE1A9K2uKTxyQtHX9E5JScJoot+cMDPIjfj+2Pw6bb60dDHE8YKj7BnNTamWd2Q70aPqJfX/qj2VDmRpiiX5Hfe8NNKfhRz8UNv71Tc+8LQl79SqW7XwxIX3suma5xV4vGRZp8YHKcpTK9jWXum8kJ+6zIpL3YbOOm2QoQKUvNl4yr4ihBhwWINHMTSXuRcI06OqcmnIZpUyEZNi80h03iduPfEVxrjVu8ggF7P5/jT2HF/NIk6qa9rBYTI91+Z8mcBByE6rdvxNApzubL7MDyPkXohgv+y5CVeI8EHp
 H11kGnsv
 LLmr5i3zc+4IRObb+s+RcfTUM8TptWrw105nVaJ0As6HOrVF0NSVuBxUkvizpaTsRtYjNgsjPAay0COf4ouoKeUdsG3TcaJfT/fVhGcaMBWLVErmkGjVzX11Th9qjOq/MaSxpAZgWiLG1pgHCb8IZGMH94vDdyNII+Ne+3dL4j8haR9/ITUnP15mjBPw1TkFIhk/vebUIhry0jh4yvC9uj5fURR7eF6b2OrrBhAE/vpG06l/qS17UQtnd+fVUtpa4jArRCrN/0i9aBYL23FseK7xYnjNbdFSTZESFsHaOO9MHY3vM8d5WkHvozO6uU5R6yQOa4R4MEFw31G3wPD1tNdH4vDycn3rES9TkgAgLbPPXVs2IlqvXqBKdGvVAq8IxmiAdjzrQEgo6H8azpxY39Jn6GKLuzSqCfNofQqXBnS3aowY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jane Chu <jane.chu@oracle.com>

commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared
count") introduced ->pt_share_count dedicated to hugetlb PMD share count
tracking, but omitted fixing copy_hugetlb_page_range(), leaving the
function relying on page_count() for tracking that no longer works.

When lazy page table copy for hugetlb is disabled, that is, revert commit
bcd51a3c679d ("hugetlb: lazy page table copies in fork()") fork()'ing with
hugetlb PMD sharing quickly lockup -

[  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
[  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
[  239.446631] Call Trace:
[  239.446633]  <TASK>
[  239.446636]  _raw_spin_lock+0x3f/0x60
[  239.446639]  copy_hugetlb_page_range+0x258/0xb50
[  239.446645]  copy_page_range+0x22b/0x2c0
[  239.446651]  dup_mmap+0x3e2/0x770
[  239.446654]  dup_mm.constprop.0+0x5e/0x230
[  239.446657]  copy_process+0xd17/0x1760
[  239.446660]  kernel_clone+0xc0/0x3e0
[  239.446661]  __do_sys_clone+0x65/0xa0
[  239.446664]  do_syscall_64+0x82/0x930
[  239.446668]  ? count_memcg_events+0xd2/0x190
[  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
[  239.446676]  ? syscall_exit_work+0x118/0x150
[  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
[  239.446681]  ? clear_bhb_loop+0x30/0x80
[  239.446684]  ? clear_bhb_loop+0x30/0x80
[  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

There are two options to resolve the potential latent issue:
  1. warn against PMD sharing in copy_hugetlb_page_range(),
  2. fix it.
This patch opts for the second option.
While at it, simplify the comment, the details are not actually relevant
anymore.

Link: https://lkml.kernel.org/r/20250916004520.1604530-1-jane.chu@oracle.com
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 14967a9c7d247841b0312c48dcf8cd29e55a4cc8)
[ David: We don't have ptdesc and the wrappers, so work directly on the
  page->pt_share_count. CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING is still
  called CONFIG_ARCH_WANT_HUGE_PMD_SHARE. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c0719ece2b7f..8268943e05eb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4341,16 +4341,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			break;
 		}
 
-		/*
-		 * If the pagetables are shared don't copy or take references.
-		 *
-		 * dst_pte == src_pte is the common case of src/dest sharing.
-		 * However, src could have 'unshared' and dst shares with
-		 * another vma. So page_count of ptep page is checked instead
-		 * to reliably determine whether pte is shared.
-		 */
-		if (page_count(virt_to_page(dst_pte)) > 1)
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+		/* If the pagetables are shared, there is nothing to do */
+		if (atomic_read(&virt_to_page(dst_pte)->pt_share_count))
 			continue;
+#endif
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
-- 
2.43.0


