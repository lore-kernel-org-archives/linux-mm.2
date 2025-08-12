Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C99CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963078E0168; Tue, 12 Aug 2025 13:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871088E0151; Tue, 12 Aug 2025 13:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75EDF8E0168; Tue, 12 Aug 2025 13:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1438E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:39:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D17EB16011A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:39:13 +0000 (UTC)
X-FDA: 83768816586.02.34A848F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DD43840005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:39:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=0obx6wey;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755020352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4dXQTvoB/5ePOynIR3FBOM8n8MGAfxNnu/DxJRU7OA=;
	b=DDxK5Woe0/7qQr1gTvQWo+LJ6ksSVOmePhzWu4nDboUW9iZpOhJ4rjpozkQd8pzdtNUDj+
	2ky9Oz9riIFCCcyt/J3LtDAqCY47DHDO5cnCFf2j34lHc4E6ITph3T28o3XUm93tFv54V9
	Y0tQTX7+iLoexMqa53MEUsI1XROMvZM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=0obx6wey;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755020352; a=rsa-sha256;
	cv=none;
	b=KnW28TqYYutrpXMDJ1/M9wOmD/ljki0c4ZMHjBpmx+bVO2d3c5mFWS8pJzEukTFLh2o1s6
	AvTD/xRhlaE1a6JahAtl6cn1WIeEFl4b6BtemZQCKgB7+sWtFenjq6RCeZz5Khzvkxisjq
	TiRh0WAmjOecdZvg7M4Ks7JTZJSD9OQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE35C43384;
	Tue, 12 Aug 2025 17:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB58CC4CEF0;
	Tue, 12 Aug 2025 17:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020350;
	bh=tlgxY9KVtDAGBHDF8w6UKOLlb4O52So44vNYjQLzmro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0obx6weyfiKAtL60du0kPpMxZrjmRvRp3XpK6YPzEm8NXhy9fpyXPmoJTtWrq5jYm
	 doHCAhHIdT3fZUqJGojMMzSxlnQrW6cRSwrjFpj0eqZ8PHYc/UTNyObQ3+Win7wtXM
	 SKkBDs4vaqRbVhJLbf5UfTH+UbcD+TE/WYlr4Y2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@redhat.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Mattew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jakub Acs <acsjakub@amazon.de>,
	linux-mm@kvack.org
Subject: [PATCH 6.1 053/253] mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
Date: Tue, 12 Aug 2025 19:27:21 +0200
Message-ID: <20250812172950.985274317@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DD43840005
X-Rspamd-Server: rspam06
X-Stat-Signature: wrsywjtmoidh4rctsjq6ec4pd7jz1gk9
X-HE-Tag: 1755020351-423310
X-HE-Meta: U2FsdGVkX1/KjhPcdIXWm+qumx49Jco2Y0l5BjTacp+haxVO3kqjBz8sbq2A62pGwPxwguLUmZLTqR2bdIktm65StyKQW9l5PaM1SyD9h+8lqrdxE2gQXfVhZZK9Ry25ozP9M6mbzvm3jXVKvd20v97aWewCgtGeD3GQmyGY7/fiw1RzVwuCzYhi8v6CtExYJ4ocPMgEack8sQdNINA0ditnUOsK3ybnhizQPuEl3Yo8yAwV2jljtMpBj9QJo9a/2DxxzkAlm6sPQoKNP+1ZlOmFerYAaT34ebiUpTnQr3H0I3fLhCa1wieqhoVc7Me1TGYRpq1OajBfLQisADeQ+BtjHLj2Qzp09SZAiygfrKGalyG+4eSC73cYhMLkg2VNw8cdryndC5b8N7xTQL0ZoDnG4WJqHYZZCFHX7huxHO+5R9FC4hDjhIpWAd0Kvb/wFX4okztezCRyCSHtHY0QTyAkwzcemNtTVAIIfABTc1j/LR30YiMKtf6/5b9h8Af3E+zXym0eJ/h9L6vAlq+IMjbS3P0FsQRyXeH5lxU7uH/osbHTzOHqJZjX8GMzNUPKl3qYruS06qY2whVCjWvV7XEafrpKs89mdkLWDwerpJollyt74mnatR4oyYfmC3zWWCtwOK3yTklL+GOYZSvQtXM+oJvzpaUYLJvn7PHrsG9uToBC1UfepRekMGhNXJBdSGQXeHxyU13ZBVyvi0rBI9m//GUc7BK9+Us504hhRv4rnVL+DuC3AL4JT85eM+5dYT/DCWfqKVtD9QaNqMTFQ0p9Jze0ChN45+NYxwW6DPSrLAQUUQdfXc+z314DF0AKXJO9BQRJdtGThXofC2tx8AMlpwhsinEsgpVZX+cR3xiZTbHeYw0NaYrM3iPFA6W5Rh9pHdwWvJNMoBDG2MN1mFd9VNflBfm6WlUO5MkHC2Kc/lU/FXVqYtc+gG2YWRCXgeWSHidxB0+BDS4zoYb
 Wdypu63F
 g4QMWolj82UnVZ0SwHGI42oP1W4H+DZgUErsPEG1ANQxOOJoBC0m4c/qUsoN3ZQTdCHD9UyH7UO6lLhCzv4wV0nJadbnvOmBulNP04/iUnRLhJizfhVtb/Y/4+xpotzSese47pokGTDCyWsQlx93y0vRCnsfp7A1uXeT77yhxgz6YfML9MgKrZiwn+VwzgxIvD/9/HvUjRst9IxNO0Yh/G2FxTnBWBGNDdRPY5xik1GpLmajx0y6W0Mv09FLKQhN7gHcyB99414kPUTlou/54Vsct+kYFLDEKpI/acHc3dOHz1mmvMMxIF7e24YF67ButaYOzaTXeYqqI81MFdaW67Fly0BF6fpviB7+MMrRECKmEnTXffOdKaEL/fds3bUjbEZ58QXWYgee3puBrx+WG8yXEqRhK1dvhatU8eTNShfsQBEH8JX0K3fyWOzu8qIGQznUehUMOcxQrDF1cAhUsxvYelHCkDzjt7YmGkFQM96Qr5N5YQSnUVtCRl6qlGdCVm6Y2SngZgm1Tc0AtfUW3st7++2gUh8hDeMcDOpN/Atn+ib31tneAZVJXdfKTIBnsE2INlLkWAgySS7OnYcf9VNlaCN4BZ6FBlOHNmIQQNtrd5cGwnhTHhQaERq6D/89Dw1MAhpYHpwVu34UNCCSyRnsLPwCnzMlISxGceXAMA6lvl7ptvgjnxvs3YNCPLWMeOMCrmAe3S9PEzhH1zKJRFg7WAfnoZKf3H9K/ygRWbep9vPNap7T1Xs7g1jnWsHBI+U4nXi+jjzprB0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Shixin <liushixin2@huawei.com>

commit f1897f2f08b28ae59476d8b73374b08f856973af upstream.

syzkaller reported such a BUG_ON():

 ------------[ cut here ]------------
 kernel BUG at mm/khugepaged.c:1835!
 Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
 ...
 CPU: 6 UID: 0 PID: 8009 Comm: syz.15.106 Kdump: loaded Tainted: G        W          6.13.0-rc6 #22
 Tainted: [W]=WARN
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : collapse_file+0xa44/0x1400
 lr : collapse_file+0x88/0x1400
 sp : ffff80008afe3a60
 ...
 Call trace:
  collapse_file+0xa44/0x1400 (P)
  hpage_collapse_scan_file+0x278/0x400
  madvise_collapse+0x1bc/0x678
  madvise_vma_behavior+0x32c/0x448
  madvise_walk_vmas.constprop.0+0xbc/0x140
  do_madvise.part.0+0xdc/0x2c8
  __arm64_sys_madvise+0x68/0x88
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x34/0x128
  el0t_64_sync_handler+0xc8/0xd0
  el0t_64_sync+0x190/0x198

This indicates that the pgoff is unaligned.  After analysis, I confirm the
vma is mapped to /dev/zero.  Such a vma certainly has vm_file, but it is
set to anonymous by mmap_zero().  So even if it's mmapped by 2m-unaligned,
it can pass the check in thp_vma_allowable_order() as it is an
anonymous-mmap, but then be collapsed as a file-mmap.

It seems the problem has existed for a long time, but actually, since we
have khugepaged_max_ptes_none check before, we will skip collapse it as it
is /dev/zero and so has no present page.  But commit d8ea7cc8547c limit
the check for only khugepaged, so the BUG_ON() can be triggered by
madvise_collapse().

Add vma_is_anonymous() check to make such vma be processed by
hpage_collapse_scan_pmd().

Link: https://lkml.kernel.org/r/20250111034511.2223353-1-liushixin2@huawei.com
Fixes: d8ea7cc8547c ("mm/khugepaged: add flag to predicate khugepaged-only behavior")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[acsjakub: backport, clean apply]
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Cc: linux-mm@kvack.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2345,7 +2345,7 @@ skip:
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
-			if (IS_ENABLED(CONFIG_SHMEM) && vma->vm_file) {
+			if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
 				struct file *file = get_file(vma->vm_file);
 				pgoff_t pgoff = linear_page_index(vma,
 						khugepaged_scan.address);
@@ -2694,7 +2694,7 @@ int madvise_collapse(struct vm_area_stru
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
 		nodes_clear(cc->alloc_nmask);
-		if (IS_ENABLED(CONFIG_SHMEM) && vma->vm_file) {
+		if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
 			struct file *file = get_file(vma->vm_file);
 			pgoff_t pgoff = linear_page_index(vma, addr);
 



