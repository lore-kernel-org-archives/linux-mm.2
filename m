Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68AB4E9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C812D6B008C; Wed, 18 Feb 2026 08:06:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B726B0092; Wed, 18 Feb 2026 08:06:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44896B0093; Wed, 18 Feb 2026 08:06:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A39916B008C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:06:16 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54F10138554
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:16 +0000 (UTC)
X-FDA: 84457600752.15.BF4B47A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9DDEE40014
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=byesko0H;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771419974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKXP2dU83lsWTJCMH4maYmSNZ/1m1vy5lDg82A4j50g=;
	b=UHK1X1NxAYbqT2n/V6G3z5O/lqM7ZQzYntijhUsVQHOVOPVPVHhSSJyP7sUCX9nFtjb8+b
	a5BU0i0xzlt9P3+B7FKo4lXlT2d5Iua0D5jr8O2hGn3jEvwDYehe7mgMNX/H8PVkYS6iDD
	LfpoCbmVxYojdRcYRw/HpgDc1TspFek=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=byesko0H;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771419974; a=rsa-sha256;
	cv=none;
	b=YGp/Q0ZMrojZFzk7xSQ6TNK1XJz4+dltMmkouIxGaCcIhVMLhHxrxsm+0RZwa4ZLTTW/oy
	zLXwYxPvg7A5sbutHyJunvHHXtnUA2NPzW08AJoXeziiKcQ5JjbcuhKlIfUHcd8o/Ce4E7
	8PdG3YNHcleEn0MZ3loMbLG7GsEjAng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C749F44484;
	Wed, 18 Feb 2026 13:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C9EC19425;
	Wed, 18 Feb 2026 13:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771419973;
	bh=sELUiTI6/PHGGIB3tYh4aGzx7GNn+Emzhk47tBilGpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byesko0HKQd1y3l+/FbQiLgz16Q0vDuOcHw9VdbMa4KgrLlk5Ltxss1hkkqU+wKLa
	 mGllECQcrMr4LtwO3xbOnYJUG9WyyrEbus1R6S/rY6CMKS7L3W/AHE+NAKCIWBQ268
	 eYbngke9r24N1EK1DXvsoBwlWju1zDhvguUoblxtmp1fFoEZ8dw25+SfXsTQ9voRJo
	 U/COOkiiHDX4zGX+l9n8tQN0fFokrgTlGdl6A2ewF4sIdUi8VjGK3cts2Q8Yz6pHrt
	 jervQxMkXtX67HAXj0D7yMv7FsJgfN+aFxg2qgQvANmK/nfiqLjmqroJ4dz3fjEpgC
	 OSBq/lVjRvOqQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.10.y 3/7] mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Wed, 18 Feb 2026 14:05:48 +0100
Message-ID: <20260218130552.55727-4-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218130552.55727-1-david@kernel.org>
References: <2026012610-absolve-ducktail-3c64@gregkh>
 <20260218130552.55727-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k866frdhfszhy6ogr31j9n43wbuc16gz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DDEE40014
X-Rspamd-Server: rspam01
X-HE-Tag: 1771419974-255778
X-HE-Meta: U2FsdGVkX1/KdVPnaLUmKZT8tOD/CXf88P8NiBhj2qor2/TKWpUmH66y04oTD8vd/Q5c8zO9frVv8bhm5rclTbkV5uTsWfuZW1MdA44K2n1JBLguBAdtxTkihANUfybBC+lSrvv9Pjae+zkwW+JaJwnnICdQzHhffuTErARApuCczQ7ruMwvPFDt++yaKzdaPBnbzNEqWVUe3RQtHNKqplFEKFyrRpKAa8FsiumI3naj9TqwnaOGx1ZjUwHtNwDW21XZPLb2TuEQLFtBgmA0Cw976KsdgOJ8ibXGEXImjGxHbP0AbQ4c6W6HRvXbZelCCryOAEjslL5BrsCvFz+hpByd2ILKR22OZU/nG7CdJj0MpTNxtzKFVHUlGmFjJnYX6+fNgBAVBup7gzmi8ywlrNnfsk1OPPUi6QivMTOPh3QMINN4pXPGEjtVdLcudYtFwI/AM+WwsorzL4pCA7R/mQ+8AlhxxNvg8VwM0N+0SN8bg21JoygLtwoqUd5ohf8Hl1hGtaM0vuOXjE0ETdKgHz+GP7uezosL/KSUnXFRncRkDXEvg1xK5eR7KiBeyh+BBneRqOIadJtKS3t4yS3tGts9vxB2K9JyIREuJbLOD4fPqiyzJpaFJkGVlHq4T+a4lHJw66JEO42ifDhWgnUkitFu5KJTUwluJoj/trWVzBSTfx3ve7AmrEq87m+PreDa6vvzaf6sL1YjbbUvXRl3vy4CroRAPOuCMF8ecIM8DxZ7p8KNwgBaw3OEf8DQqvOZEvfWoDGI7YJjPudJl+2HXoX5Kx+7tHCiIIltxZN038iRSaSNdAfykV/RGqKID4cf0owSGR88QfQQIU9k8zv3g+bHwcn4zJ07IWc9amC4pfjc9bOdOI1rV2Qty2zLqcPHFZI9rKsslzxXL/53nUADYHV/4SqUL44jTknE59j/7yn+kvt+EfMXmxcEA6xBtvkdfEad2kQFxxLlRZLb8J4
 VKq5J3BE
 u36XIfO56PKbb5SoZ33hezw5r+aRueiTIoh1puniRXTaYR1eNr8SoVJZQ8IYTe3FQpU4nZtYCd3Dzun7acxNnNFNGY94e+zmezoyoAvkryL0CYbtbTbT7myXYjZRbx8xi5n3bbw6qHZwd5inMoiqsb+3bh9hoB/K4TdXBdkJujVu0sdgwf5FfBcl82tcKgXH3F8MikMYJSM5k7m3QcWx88NkrvRS915lPRLaGdXtwymP97YA0GeF/z12rO6TGIQf3xHGzoN6lVWhu9av3sk9gmfq2X026UEeMNSXHOxd4KfPPdPnzLJdQVQTXd4jEistvQlEkP1EpgE3OojWRgoQ/pJi8Dl8I6v+dB83I/cl5r4Beeoz8bbXHNSVxF8FXCrVjLyerTDhd4h9tHuPr6jr2TLG8Lh4NRac2OCxxfUL9CAVUwKqk4LwBS/COSw==
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
index a2cab8f2190f..8fa34032bc17 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3865,16 +3865,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
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


