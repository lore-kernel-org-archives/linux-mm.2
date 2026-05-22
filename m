Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0ACBCD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 03:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4505E6B0093; Thu, 21 May 2026 23:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4288B6B0096; Thu, 21 May 2026 23:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365896B0098; Thu, 21 May 2026 23:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2593D6B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:01:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BECAD926D3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:01:18 +0000 (UTC)
X-FDA: 84793554636.01.82709C6
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 294C84000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:01:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779418876; a=rsa-sha256;
	cv=none;
	b=iB1fcCZcReZWxRhA0e5vCIj6jSGRxQtel9A4ga+urzOumpD4MBaHisvd+IVqQO5fWJz03M
	xN8+hnRmC0dcTvtUVDXfD/MZvF6oEm6G8QVpOMa7sWE5QVLwcZcLifylxjK169wzdKYgjx
	Rf3mc4h9kL3umOeeRgtJetY28ZCgUAY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779418876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFYzluw4wVZxsOPGF8RYpu47556eohkgroQQAX76KsA=;
	b=xNs/Lfau0rjjop0Nx/y9fCaUuhb7YFvnakzN39BTARvx7Lqiasn5zXWsu9YEUB/Jyfkvic
	eN3JJNqac8lzCR9tejV6+fnFmRrccPki2xcLk2GtvdBWVZHOoHL2iHeDD/eEGDlDyrTviV
	wy1z7NcJoiLajz9FRz9cyxRclSu4+aY=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gM95j631Dz57DCl;
	Fri, 22 May 2026 11:01:13 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 64M318fY023988;
	Fri, 22 May 2026 11:01:08 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 22 May 2026 11:01:09 +0800 (CST)
X-Zmail-TransId: 2afb6a0fc6f5df8-1136a
X-Mailer: Zmail v1.0
Message-ID: <20260522110109231BdqordSWkUPmdr47-ghXo@zte.com.cn>
In-Reply-To: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
References: 20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn
Date: Fri, 22 May 2026 11:01:09 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY2IDUvNl0ga3NtOiBPcHRpbWl6ZSBybWFwX3dhbGtfa3NtIGJ5IHBhc3NpbmcgYSBzdWl0YWJsZSBwZ29mZg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64M318fY023988
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Fri, 22 May 2026 11:01:13 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0FC6F9.000/4gM95j631Dz57DCl
X-Rspam-User: 
X-Rspamd-Queue-Id: 294C84000E
X-Rspamd-Server: rspam03
X-Stat-Signature: nqgzzac9wohkn6xk4d3arx543yt3okrp
X-HE-Tag: 1779418876-768301
X-HE-Meta: U2FsdGVkX1/uIn826Rextfws7Yu55SOeVg5YZAmSBywNdWiYPhM9vzjTHNOLnpIORB/+u34lcRZyqYzeNiDmIkDf5qPvKhDDAdogFbJnKepwGM0kCUvGikGm9WITSYzBaUnyARDRAqTXUXQKquoYbJSJCyL67yyrKZnOHbuv2/f/cajrE3r3yWR6ameimk+oXYGggiwSV9uk0nWoSBS4+5Ah3257LbdBuJeHpraDX/6lyd9GsDp8VznduY81p6alNCfCBf/lHfNtbpjPEXFv+I119GLcfBhS+wlZLEBvZtGCxueUDQyF9v0/kHkQf2mSGOtzoxQLip30N7hVmX5LnDG6ZMRVAv5wzrcYTyT0SbzmCiL6koc1+jMapN7awlBJvMg+ZtEnkBF5doTfmHUsr4mwonTGku8xXNkbR33RJ4TsC4IpfAcl/pLrg9r4/QTWvjJOV7Qt8jsfb6L9nBWi40+TJW0dLiR2OazcLIHmP7iufahzIX/c8s3EcmFMYoOIiAdxqGtBC6G67o+wtqw8ISyh5Lgf9Ub/CzVjiH9V/jEPUZKI20ejQwrWQmOH9Co4sZCafeSmG0EiLN6Ft6ga9rYyMQa72RU4OU4CNEzVzDULyL1OsQz1Ey1yu+aWHgjyWyJ+d5y0D9szwfgE/lxBHZEyMi0Vf+rEKvq1KKnEXNNA/LcWDwEcklepS9DO73TsWzV03RGBchbC7j/IDJnJBWDO2t2T+EcNq/+ZhO193vaMSUVh6YFrfHFMXrF5ddGiQi1LjmPGFtbwBM3E4nFY2+n8b80dhNQjWeInX931Kc4W6m5yQ+DXVUQ3Mt0qcgFAKi9X0KPPB4d4ak3S/wmlyIuM5WvepczEqpdHEiAeE98qC4ZstcDYSh9WIjXloRfKkYsYEXc790oZHvUBTgBOxesTnK6rBLz8SooQ2Sv2PKavI5LxiVQChD3h/6zN3WomYqQsGGt2DEfAhfsOSZT
 qCa77kiw
 S/EMKnD/HRMwT8ybD7sE2zEKzcFvy9ZBCPKUav8Dg1eXZKD4Nk3s6bdcLaNUbH4WfXs6mWK3e6X4EOkRXvvGreJnkjSUxSzXaPwAcE9zC44fIroT589HHAF55RBeRkUmbSJxRmhTJEjqO8EhvB3nuJrBhJ6/6dhe0oc+Bs60inXiIyBam4yN3pD1QY0sWirPvII7rbHqnoyEg8azpDygh4imyioGgf3mmDqxkjrKQPsdIPmAt0JirEqCaGz8MWtlPVZMtuV2+BCYr0pFJ5zMNM3GhoZLvHnfOUS0a00YeYKrFdnD98jkk2VUZlxTOgs3qaOXblTALryxls8BAdHYAyod5iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

User impact / Why this matters to Linux users
=============================================
When a system runs with KSM enabled and memory becomes tight, KSM pages
may be swapped out or migrated. The kernel then performs a reverse map
walk by rmap_walk_ksm to locate all page table entries that reference
these pages. If A large number of unrelated VMAs can attach to a single
anon_vma related with this KSM page, then rmap_walk might be severe
performance bottleneck.  In our embedded test environment, we observed
~20,000 VMAs sharing one anon_vma without any fork – purely from VMA
splits， which cause 200~700ms duration of rmap_walk_ksm.

When one of those VMAs mapped a KSM page, then this KSM page's rmapping
will become bottleneck with hold its anon_vma lock for a long time. The
anon_vma lock is not only used by KSM; it is a core lock protecting the
VMA interval tree and is acquired by many critical memory operations:

  • Page faults: do_anonymous_page(), do_wp_page() (especially during COW)
  • Memory reclaim: try_to_unmap()
  • Page migration & compaction: migrate_pages(), compact_zone()
  • mlock / munlock: mlock_fixup()
  • Process exit: exit_mmap() (tearing down VMAs)
  • Cgroup memory accounting: mem_cgroup_move_charge()

If one thread holds the anon_vma lock for hundreds of milliseconds
because of an inefficient KSM rmap walk, any other thread that tries to
acquire the same lock (e.g., an application taking a page fault, kswapd
reclaiming pages, or a migration thread) will block.  This leads to
stalled application threads, increased latency spikes, and in extreme
cases container timeouts or watchdog triggers.

This patch reduces the worst-case anon_vma lock hold time during KSM
rmap walk from >500 ms to <1 ms, thereby almost eliminating this
source of lock contention and improving system responsiveness under
memory pressure.

Real-world examples:
====================
 - JVM / Go runtime: These use mmap for heap regions and later call
mprotect(PROT_NONE) for garbage collection barriers or guard pages,
splitting the original VMA into thousands of small pieces over time.

 - Database engines (MySQL, PostgreSQL): Large shared memory buffers
or anonymous mappings are managed with madvise(MADV_DONTNEED) to release
specific pages, which also splits VMAs.

* Why the benchmark numbers are realistic: We observed ~20,000 VMAs sharing
one anon_vma on a production system running a Java application with KSM
enabled. The lock hold time before the patch was measured at 228 ms (max)
during rmap walks triggered by memory compaction and page migration.
The benchmark reproduces that VMA count and lock‑hold behavior in a
controlled environment.

Root Cause
==========
Through my local debugging trace analysis, we found that most of the latency
of rmap_walk_ksm occurs within anon_vma_interval_tree_foreach, leading to an
excessively long hold time on the anon_vma lock (even reaching 500ms or more),
which in turn causes upper-layer applications (waiting for the anon_vma lock)
to be blocked for extended periods.

Further investigation revealed that 99.9% of iterations inside the
anon_vma_interval_tree_foreach loop are skipped due to the first check
"if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
number of loop iterations are ineffective. This inefficiency arises because
the pgoff_start and pgoff_end parameters passed to
anon_vma_interval_tree_foreach span the entire address space from 0 to
ULONG_MAX, resulting in very poor loop efficiency.

Solution
========
We cannot rely solely on anon_vma to locate all PTEs mapping this page but
also need to have the original page's pgoff. Since the implementation of
anon_vma_interval_tree_foreach — it essentially iterates to find a suitable
VMA such that the provided pgoff falls within the candidate's vm_pgoff range.

vm_pgoff <= pgoff (original linear page offset) <= (vm_pgoff + vma_pages(v) - 1)

Fortunately, we have already pgoff in ksm_rmap_item in the previos patch
of series, so that we use it to get the pgoff to accelerate the searching.

Test results
============
We provide a rmap testbench: tools/testing/rmap/rmap_benchmark.c
The testing result in QEMU is shown as follows:

KSM rmapping	Maximum duration		Average duration

Before:		705.12 ms (705119858 ns)	532.04 ms (532041586 ns)
After:		1.67 ms (1665917 ns)		1.44 ms (1443784 ns)

Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 4761ca3fa984..7fe1a8753309 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3200,6 +3200,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const unsigned long pgoff = rmap_item->pgoff;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3213,8 +3214,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}

+		/*
+		 * Currently KSM folios are order-0 normal pages, so pgoff_end
+		 * should be the same as pgoff_start.
+		 */
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       pgoff, pgoff) {

 			cond_resched();
 			vma = vmac->vma;
-- 
2.25.1

