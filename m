Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD1FDE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000506B0089; Wed, 18 Feb 2026 04:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03AE6B008A; Wed, 18 Feb 2026 04:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E370F6B008C; Wed, 18 Feb 2026 04:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D344A6B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:16:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B7458BAB4
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:16:34 +0000 (UTC)
X-FDA: 84457021908.30.393340A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B3D3340003
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:16:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJzLebHv;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771406192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YKf48neRgeRPNcO7r8hdUoTC8NaiuqF5Y8+1LZ9j4oo=;
	b=D+WJ2kPK0z9UztVYN19vnGLvF25Yb3OirNyptyZdrVSMfQKRiT1C4htedz9jlq8ffi5dH8
	YFSWXe2Qvt2W8N6s4jnn/8wXP21kxuUpCH6RbYnMf9tYPR0RRZIxWtqnqTksLQ/xGMjhOG
	iPMnhp2v2fOk+Vm4d6Ub4uQzdMdEevI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771406192; a=rsa-sha256;
	cv=none;
	b=0kWq209MLjPuO9DqWeBCBtnIZlns3xKcO89t6BbXsJmKzdi5Q+MzUQwlAytjT9clHvU6+J
	L8Qdg3n8O6MU1kSLJpae0Tw83/o35s4pnpxtxzEOXcQfkUXDTdrCE+O/SHVH1CM2LTgZCK
	EyZanW03JvXpMyQMcFKYQglhvG1K2wI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJzLebHv;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F3BB43D78;
	Wed, 18 Feb 2026 09:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C11C19425;
	Wed, 18 Feb 2026 09:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771406191;
	bh=ppf9OvYdBJc2dErMbeYp649Jg27CTKyvZL34q7/d1x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJzLebHvw46Bwf+3ndXp1UQobNZ8HBCK+xk7JuTqBoFdQiF38q+b/cAP/YYQv4pgy
	 ICmtHt6f+n1JxdKleWo+hsiDruv+iEJrKFq8b3SjhXdMRhM1gOZwB2y89ijqJfBbzw
	 xRmBrEuLA5zO7IhUj/UrShkrcX3yZ0PCJNh8nOkUPwm4VLl4bVGoEPNmA8jKZ+G1Xk
	 NDgafYsgI/7HCYz8+62oILimCf1NiHUzDd9pX1pajG9+jjItBiDLiKsLupc5X1hU3e
	 BKGpeDHgxrxzZkN9AuH6BFMlZJc0ad9r9Cdl+xGOPmzvrBMKbLFOZjsWTZUS9Yw6pZ
	 92+mEjHGhdbow==
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
Subject: [PATCH 6.1.y 1/4] mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Wed, 18 Feb 2026 10:16:04 +0100
Message-ID: <20260218091608.25726-2-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218091608.25726-1-david@kernel.org>
References: <2026012605-uncorrupt-yanking-4155@gregkh>
 <20260218091608.25726-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j4xxk8t1mnos5j35z7af9tpnddj9jrnh
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B3D3340003
X-HE-Tag: 1771406192-734657
X-HE-Meta: U2FsdGVkX1/22S+I3aMDWGC6j7jcWcTdzKeMf3djHUI9YiunUHDKRBoIWBo//m3E2MlYu0yfm15s39Tfj4lH+FbiDz6JS4nFsJMjr4AL8g+RaXSBsTaGtYC8ClftckYeEy5ifY8xf26j6h/+GgSvqfv+u3vW36HJNE1K2G2mqQvzJTG3btCUQW191ukBstBkw47bY5RPWPHO2UZBU7mhUxT41QqU3iUjHGBcreiqNBJ0i0PL9cEZrQY6938ovrxzyM1puJW4UbRybPZ1NDyIzlF8G8bg8ZhvbcOCYu+59/m9Dbgrs5dG1aGX5FvyKUyNRTGdZcdxONDjR1y3hBVMC0oaYcb0ihu2z410c7iemjeBGmq51rA94rrWC10f7mE7G5NlFYNgPjSAzpklVM2CrL3VXsBItIqKwtwr4+BYz6ouA7FyisoWxPHS19EUC0kR8Qrc/ZeiKmOh9J/VLGAM/ITxXexeh57q0amtvXcckR6T0n5J83rwMmNX8ftFuJnK+0fDA8/4vZ+UZFWZMimcQNsBk52zh1YVxI6rYUb29URQ+tlRgAissUScSogqaZMPGz4bfuGqjX1mgbF4zbX4MC2xrovhLun6AmyVOH/VoUve5/Gw0tMMQXQYF0u5IKtWijmTXOy6dTl3AFj8INPIgyPU6U/OoeIYhiHedni6QBvQ9tQpTb20tNxPyk0bEfO0OPzCCO8SQlPorxVRjXkn27wJavI+E6g2D6XQ6cbS5ZhltkEVpSIOHINjxg1s7FNo4cji1qkmtMng/c0yk76uvd2KRh9PiXv9srSeyZXnY+WqmPEi48PzVXd2vdoIu5SBXUsb+K7xK3R4fwKhvdGs3bfVR+K0FxEdTauDfhofAQOW32x241Rgi/bsR6/StkjmUUcLPR4kkBdS2fAmqyIcWoEMT7dEQf890RP3Da7rrj+D3il5gAsFFioREtp11LEQf02Gli+xsqbteyCDHs4
 mB47dMGX
 lZzhN+4zX3eThxVH55oviGwa0jy4xTRQuVM/PVrxYNASsDW8WFQoN2yIwu525VS4NRL4764hcs5NFFgmuaffTWlQaS1+E34MgA29B4+A3zDyR914jMfAAK/zRd3GjYuys3Jeih2KqJ/yAgIuzloMCknd9otKkT6Wt+S86DNotV54/N4jxuNUehmIaPRwImGEFn/uNAZGZTsQMVaVcCY+BapXcHeyDFfanJyVMfJpEOGQaiH1prNvq2xp2VFaghN+BZ414HzQQHjZjVvWkMq3zz3WL371y/h6oW7Z34M7r60wB8FSsS3huyZvfI8W6sPcUDVZC7/OLXoMMm1tSDcJYvZ6O4vqdwKJGOI9Jh89qHbhlz7iPa041NCvSbfg03y84bg2Z6P87q3r6LXgILTa+j2yULuZPQ17O3Yc2PBSGGwpyiiIKmzgbIAs/Xw==
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
index e7bac08071de..b07b332beabb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5084,18 +5084,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
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
-		if (page_count(virt_to_page(dst_pte)) > 1) {
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+		/* If the pagetables are shared, there is nothing to do */
+		if (atomic_read(&virt_to_page(dst_pte)->pt_share_count)) {
 			addr |= last_addr_mask;
 			continue;
 		}
+#endif
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
-- 
2.43.0


