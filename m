Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C502606A339
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A3C6B05B4; Wed,  4 Nov 2026 08:40:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB376B05B5; Wed,  4 Nov 2026 08:40:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02FC6B05B6; Wed,  4 Nov 2026 08:40:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB506B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:40:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60A591206E0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:39:59 +0000 (UTC)
X-FDA: 85397544918.17.1CD9F7C
Received: from outbound.baidu.com (outbound.baidu.com [180.76.5.236])
	by imf15.hostedemail.com (Postfix) with SMTP id 78758A000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:39:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=DEGrKpZp;
	spf=pass (imf15.hostedemail.com: domain of "prvs=md1762835C5C=zhangyili01@baidu.com" designates 180.76.5.236 as permitted sender) smtp.mailfrom="prvs=md1762835C5C=zhangyili01@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793799597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IkhbWLUwIsHVA5qbkZd1FvDfizz0mbHSzrjJWS7856E=;
	b=O+kXxZ9XrfSF2O4mTeFwQ+Sd1ZC97JK+XYIK2FRIZmIIGDL9u8RGsRMQoGqhyaYGs+OO1M
	9dghGRhzq1sglUbNQqhlT5MDg38cFjRY37Uddt3zyxGgQw9YvG6MeIJP3zJ6MgKIi+0Arx
	/vdC4EnNzreFg3vq3+f+ZxTc893xBh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793799597;
	b=PDqmVQaUTAL/Ukw+XnHfw107PsaoFP7pGRsostVMage+XI4iTKib+BMLPRCva+0hnGlI3k
	0w8FCS57Mwghr5XvNdef9/xl584O9tU5gElb0SGZcwsDnvM7N3Dxso2wyFr4G3O1LgPo9/
	6bOGoJxmh7MhvbF40xMRvdw+w/Pm3F4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=DEGrKpZp;
	spf=pass (imf15.hostedemail.com: domain of "prvs=md1762835C5C=zhangyili01@baidu.com" designates 180.76.5.236 as permitted sender) smtp.mailfrom="prvs=md1762835C5C=zhangyili01@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
X-MD-Sfrom: zhangyili01@baidu.com
X-MD-SrcIP: 172.31.51.15
From: Yili Zhang <zhangyili01@baidu.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <akpm@linux-foundation.org>
CC: <david@kernel.org>, <kas@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <rppt@kernel.org>, Yili Zhang
	<zhangyili01@baidu.com>
Subject: [PATCH] mm/hugetlb: do not invoke the OOM killer when optimizing vmemmap
Date: Wed, 4 Nov 2026 21:39:38 +0800
Message-ID: <20261104133938.50974-1-zhangyili01@baidu.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc12.internal.baidu.com (172.31.51.12) To
 BJKJY-Exc19.internal.baidu.com (172.31.51.15)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1793799589;
	bh=IkhbWLUwIsHVA5qbkZd1FvDfizz0mbHSzrjJWS7856E=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=DEGrKpZpvg+dC+n6PNW5iuA3y2vQTBc2UI/ca3IWigfKjgN6kEOaypSOh2vAfkb95
	 IlKnFbauvomSKB3e7iSq9xTg/En2KSi/Hw4tJYkCxmcoc+O4ndhpj6io8dT/aav2eK
	 9hxuMMAdLvbrj25g6/8uwEV59uIM5a8XujpN3Vjg1MFYeuR8jN5TK36EJ7g3vx7VRx
	 tzPsI2urySU2AKgzVhQh60nXCWdft7M89zQb+LmYmOqAoqT+g04iUkm8KmlfWB+eq0
	 QB4v5ziuWaFR9JBf4b8kh550dto7exx3qUiVc8GYMy/TuaMh1visMBS0ayeoGTlEMz
	 TOXb1ff+Je2DA==
X-Stat-Signature: m4d7sce1ybdxbbayftgmwzwwg7ebf4j4
X-Rspamd-Queue-Id: 78758A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793799594-409731
X-HE-Meta: U2FsdGVkX187x7l1gxppGpBtIgjwNbmzZKJ8oLgxp6JTYFt1agela1guskxZ6pCb8kxVxavndhCf4n0WeFTakjkC3A7y5Sj/9nDJGEJqZzuTybD4+9VpaXvGQPPOjS6He7vGEeeiWn/D0fZkbrVB8qc2R56cXb6vgbnWhCOd02BPIz3m65U46QPM7vrSq0oi46RvtuTc1AwnCP9boAqGzGfOCMi9YRGLTRUlRDsjcPOVOH+7ZN1Ru2UfWKgQm30iijlShE1VACk0HJCfCbXyQNWhHk2jowNLMFD8KSX2eH/vfqJiqqbq7FChfNviw/b7adijumANTP5Q/vcibEAVeczhPCalZHMtAOoN+UeBGKswYHZJepBwdcVtQfumVJkWQC7bHGfc2chI3716QQv6IymL3JF0CkgNN2sRzwWr05mE1dyR4AbQT8DIGomusKfDCnuMHR/kPsWb5KmCQLo94LqLMxdXfLloxbvEopsC8o21gWWUgbMpwPmbioc9J1b32cN3D0L9kjZJDm451KXXFn7sS0Wz1czJyoGnPqIlXe+QT42ZB/enTRMmbZEvCE32vjEZjI/Vbglo7Vz5giVxcfYv0QekH8rrDlcO/e+NJ7vuiIDzDyZ5WthxwTMHtvzWiCmCkRGmUkpns3Lapqbv9suDSC52hpnExjA3/llMtAAJZCG1SllsElf1vYNyE1ShKIrVyavaFc5wVjzY4qGJKNRdXzV3ekzfkNkZMK3DVmlQKt8yd8G2RJCbOvRl1aYUr9enoRsbOkVP9fQygPXNA0cIe79ArKbAfNKK9fw9YW3LHi38zOpEBnOcHHPR4m/yConzzPHjPxz/m76bWJDtrKKHeAnvxYeCFog/iQIBFnGF2IhwFGI65J59X00+5xQ2uDCXHBV4P890O6v1jwUPoY/hT107HJKZevCajLvU88JuFG92FV3urxHxvPYtiNre97zOEYpu9gqHgZ1mXvs
 EVLO5YZB
 oOOwOUYyBjHbZu8sBG9/Ru/aoqhiT3HX8MBsNMSgZ1t0dlYwoVP/kwdiVMtvlNTuUIahjO60S5o2GqGdyPCkGXiI95YDjuozTmxiGrHfnqD5bAa/VUHx6LCcGaBhzVp7COLCo7GCh7qQk568+wKneqOG+SLZ1WRcQYrsvCe6a/bWqd/snXaq5h8sjyMZtjRFJfGUNpKBg1bQhn6VYaAsmqPCuiqkciF/6eOLEka2J5RXl0m/E7BhZFP5jKNIYVfbXRir6chfsMsbA1zL+aaPuDN8xEyGQkOYsHBz9w1aH1kq+GLYMTSBvFoKPT3FsQpOa9+zvYlB9rH8OzxpulpZuAuH5PolUrnGX5CTVaTMs93UOun/1hiGzkeJ81FIx6EajVwmXK+hh4kDVsvn+h4l43J5uxEbG//zItHBP0pDHQGDbAyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time hugepage allocation is designed to drain all free memory and
let the vmemmap optimization reclaim vmemmap pages, so that more
hugepages can be allocated afterwards:
hugetlb_pages_alloc_boot_node() flushes the folios accumulated so far
once si_mem_available() drops to zero, and hugetlb_pages_alloc_boot()
keeps retrying as long as progress is being made.  The allocation is
parallelized with padata and runs on many threads at once.

The page that will back the new head struct page of a folio being
optimized is allocated with a bare GFP_KERNEL mask in
__hugetlb_vmemmap_optimize_folio():

	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);

Once the workers have consumed all free memory, this allocation enters
the OOM path.  During boot-time allocation, at the do_one_initcall()
stage, there are no user processes yet, so out_of_memory() finds
nothing to kill and panics:

  Out of memory and no killable processes...
  Kernel panic - not syncing: System is deadlocked on memory
  CPU: 74 UID: 0 PID: 1 Comm: swapper/0
  Call Trace:
    vpanic+0x32f/0x360
    panic+0x57/0x60
    out_of_memory+0x581/0x590
    __alloc_pages_slowpath.constprop.115+0x97d/0xed0
    __alloc_frozen_pages_noprof+0x303/0x330
    __alloc_pages_noprof+0xa/0x20
    __hugetlb_vmemmap_optimize_folio+0xa3/0x210
    __hugetlb_vmemmap_optimize_folios+0x190/0x230
    prep_and_add_allocated_folios+0x16/0x90
    hugetlb_pages_alloc_boot_node+0x152/0x180
    padata_mt_helper+0x5b/0xb0
    padata_do_multithreaded+0x294/0x3a0
    hugetlb_hstate_alloc_pages+0x2e1/0x3b0
    hugetlb_init+0x3b5/0x640
    do_one_initcall+0x49/0x200

Optimizing the vmemmap is best-effort by design: on allocation failure,
__hugetlb_vmemmap_optimize_folios() frees the vmemmap pages reclaimed
from the folios it has processed so far and retries once, and folios
that still cannot be optimized are put into the pool unoptimized by
prep_and_add_allocated_folios().  The worst outcome of a failure is a
higher vmemmap overhead and, as a consequence, fewer hugepages being
allocated (along with a warning) - waking up the OOM killer is never
the right thing to do here.  Note that the same code also runs for
runtime hugepage allocations, where an OOM invocation may kill an
unrelated process instead of failing the optimization gracefully.

The head page is a vmemmap page, and every other vmemmap page
allocation involved is prepared to fail gracefully:
vmemmap_alloc_block() - which vmemmap_shared_tail_page() also uses
to allocate the shared tail vmemmap pages - uses
GFP_KERNEL|__GFP_RETRY_MAYFAIL|__GFP_NOWARN, and
alloc_vmemmap_page_list() uses GFP_KERNEL|__GFP_RETRY_MAYFAIL.

Align it with the other vmemmap page allocations by using the same mask
that vmemmap_alloc_block() uses for vmemmap pages, so that a failure
returns -ENOMEM to the caller instead of going through the OOM path.

This was observed on a 384-CPU machine with ~1.5TiB of RAM booting
with a hugepages= reservation close to the total memory size and
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=y, where the boot
panicked intermittently, depending on how the parallel allocation
workers interleaved.

Fixes: c0b495b91a47b ("mm/hugetlb: refactor code around vmemmap_walk")
Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
---
 mm/hugetlb_vmemmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0057fa2a16a8..3a759b930ed9 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -499,6 +499,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 {
 	unsigned long vmemmap_start, vmemmap_end;
 	struct page *vmemmap_head, *vmemmap_tail;
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -525,7 +526,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
+	vmemmap_head = alloc_pages_node(nid, gfp_mask, 0);
 	if (!vmemmap_head) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.27.0


