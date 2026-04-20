Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26202F36C41
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 08:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8946B0088; Mon, 20 Apr 2026 04:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA726B0089; Mon, 20 Apr 2026 04:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22736B008A; Mon, 20 Apr 2026 04:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A9B5C6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:02:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 71C751A08D9
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:02:03 +0000 (UTC)
X-FDA: 84678190926.11.404AAB1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CDC218000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:02:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf24.hostedemail.com: domain of gorbunov.ivan@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gorbunov.ivan@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776672121; a=rsa-sha256;
	cv=none;
	b=H5nFe2mYa1hCMx4E+F/GjjrL6JYSvzQGLYeLzx3AjhdqAZ+rRo0w69rWFl8SDiZVdu8fnr
	ZQYGnpiUtM/0OIuergBAlmA0HndyTj8mvgHDSiV4FX7Or8E0zHMIQae+NQwYFQgCyqZ+Gp
	/QZ+FVjc84SuQ8n1xA7kOERtZlbBFuI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf24.hostedemail.com: domain of gorbunov.ivan@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gorbunov.ivan@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776672121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L5V3esXhFSJtTr8zMOOvulnj2dtxRxcywr7J8YwLNQM=;
	b=eozCbYlU8cQygOcGCj3DIGhGfwNI74ZJDTK6CkO8kM83A8GXyODCDmJy0eKQRdlAWvfTqA
	pu4iB/85IziPdZzmpUoYE9Eeh4PQWUrxYC2xEwqCruvYG+9zC2o9Q50e30+tlW1cUqSdw6
	C0pS40Gjqnj/NXOonl8saedU9jdbbaQ=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fzdH11FGLzHnH3h;
	Mon, 20 Apr 2026 16:01:33 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id B75C440573;
	Mon, 20 Apr 2026 16:01:58 +0800 (CST)
Received: from mscphis04371.huawei.com (10.123.69.39) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Apr 2026 11:01:58 +0300
From: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
To: <gorbunov.ivan@h-partners.com>
CC: <david@kernel.org>, <Liam.Howlett@oracle.com>,
	<akpm@linux-foundation.org>, <apopple@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <gladyshev.ilya1@h-partners.com>,
	<harry.yoo@oracle.com>, <kirill@shutemov.name>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <muchun.song@linux.dev>,
	<rppt@kernel.org>, <surenb@google.com>, <torvalds@linuxfoundation.org>,
	<vbabka@suse.cz>, <willy@infradead.org>, <yuzhao@google.com>,
	<ziy@nvidia.com>, <artem.kuzin@huawei.com>
Subject: [PATCH v2 1/2] mm: drop page refcount zero state semantics
Date: Mon, 20 Apr 2026 08:01:18 +0000
Message-ID: <9fd8ebbc0f4f45be611bae0d03dd25dd994233c0.1776350895.git.gorbunov.ivan@h-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
References: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.69.39]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 6CDC218000F
X-Rspamd-Server: rspam12
X-Stat-Signature: 9fx3asypc198tgubeyy3ywd7d6znprzh
X-Rspam-User: 
X-HE-Tag: 1776672121-65384
X-HE-Meta: U2FsdGVkX1+xb67fosUW0Rw8CQsSrhMuXSGGSoJKAH4PTuU6oUvux29ABilrlXCEyV320wmlWaNeWTpo7+DEG0ort+40PDlAwDNX1b5Tm7V6hw1GjCAnFOt7FZnpTWMo25HINGeRQmlPkoCrd5BlfDO7AAbMkLUI1dvzzoMNZ0viDegKni26T58/4/qUeHofRukiXEkfaxoP1OTiPWV0M8Ex+uPVw2QLyy+DZsE6JEV5l52gnEwPzjGZ8u2gJtAiMvQPi1Jm/8u9vcx8Bs1uO6iGhzAhv/qXyHNimYtJLziLW4B73KM3wJVt5RVAm4GdOiyUt2tr8sBFUHOLMAM6NIhYwAV34O9/tvCLM6h9ayifc1RhTM7Tm+1a0hBJQaxOdXnE697b+G7hPpRq3pB4L/9HrevanE5am2d1+aNcqMK3BzgDlyfR+lEZdvjqgz7dMgHoC4ZX3tDa5OdPIr9IRxyVpnOy1mi2k2TnzjvNcl9sn0hHugF1neL1yzcKTxKbSLQaroCZSS0x0ABkajKCC3kzCmq9vpQg02B+VDg52bmCopfgv55LqH5coznMJYUJBVWUtGfUjqSpbjZOUxB7pfYBREQet0Cd8SD/NJYVx4zs5+wFfMe8PEjV6OwwRh4jSVF/9A5JI36/62jjOnfqPi9GycF/WBXvrkUUqL0DJW3m3vW9dwOQKjL4DsksyuzzRePwk4BwNRotjHMfeeC0Rwxq6MOpXIFv11L++s++ate3kUoeejm+zhi9WjEcvDtM5uFy0Csr7XDkSWNOsrhAsiqetd12aJ7Y85w7qtjvqVuPr5rbYvW+528zysf+4lUVbi/X3Y59m5vsYZlK9CiA+eIcX31kbS0R1iA+VKpli85iJJWNg8UHg30+217g/wNvDltNNWMDBK6KYX2bAfj74b5bKZnC6zhwI8aN30jgkZzvb4iRTbVxVniYYg09ywNh1qtJ04f+X4Z/GQ15Qt9
 yk2hzYI4
 w6giwu+SRNik2R9gKZv1lqJXG7DoLAGzERYSRJChdKU2y4V+5aPLiNv/PN/eiadbKMc4W8Js7AShMFuWFhEEyCIis7uNIEFwnhwekgDj+yj+qqo+d+h3s3yPWALOGm2McZczYHXxitQvfAgJvIxDcUINuekQOQRff8p7vUJtJFWM4MZvwEP9QhMUGcNpi5EShB864HGHN2V9FCmj2T8PxEMEU+wEs/WcYr/JAjWuPaFpkDErSCYUd0XmsV1XIbyO/mdv6jLBGx+1ff70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Right now 'zero' state could be interpreted in 2 ways
1) Unfrozen page which right now has no explicit owner
2) Frozen page

This states can be 'logically' distinguished by operations such as
page_ref_add, page_ref_inc, etc. In the first we would want the counter to
increase.

For example one can write

page = alloc_frozen_page(...);
page_ref_inc(page, 1);

But in the second state increasing a counter of a frozen page, shouldn't be valid at all.

Another reason for change is our other patch (mm: implement page refcount locking via dedicated bit)
in which frozen pages do not have 0 value in refcount when frozen.

This patch proposes 2 changes
1) Deprecate invariant that the value stored in reference count of frozen page is 0
(Getter functions folio_ref_count/page_ref_count must still return 0 for frozen pages)
2) Allow modification operations like page_ref_add to be used only with
   pages with owners

We've looked at places where pages are allocated, and they are
always initialized via functions like set_page_count(page, 1). However, for
clarity, we've added a debug BUG_ON inside modification functions to ensure
that they are called only on pages with owners. In future those
checks can be improved by replacing operations with their results
returning analogs, if needed.

Co-developed-by: Gladyshev Ilya <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
---
 drivers/pci/p2pdma.c               |  2 +-
 include/linux/page_ref.h           | 17 +++++++++++++++++
 kernel/liveupdate/kexec_handover.c |  2 +-
 mm/hugetlb.c                       |  2 +-
 mm/mm_init.c                       |  6 +++---
 mm/page_alloc.c                    |  4 ++--
 6 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index e0f546166eb8..e060ae7e1644 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -158,7 +158,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 			 * because we don't want to trigger the
 			 * p2pdma_folio_free() path.
 			 */
-			set_page_count(page, 0);
+			set_page_count_as_frozen(page);
 			percpu_ref_put(ref);
 			return ret;
 		}
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 94d3f0e71c06..a7a07b61d2ae 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -62,6 +62,11 @@ static inline void __page_ref_unfreeze(struct page *page, int v)
 
 #endif
 
+static inline bool __page_count_is_frozen(int count)
+{
+	return count == 0;
+}
+
 static inline int page_ref_count(const struct page *page)
 {
 	return atomic_read(&page->_refcount);
@@ -115,8 +120,14 @@ static inline void init_page_count(struct page *page)
 	set_page_count(page, 1);
 }
 
+static inline void set_page_count_as_frozen(struct page *page)
+{
+	set_page_count(page, 0);
+}
+
 static inline void page_ref_add(struct page *page, int nr)
 {
+	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
 	atomic_add(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, nr);
@@ -129,6 +140,7 @@ static inline void folio_ref_add(struct folio *folio, int nr)
 
 static inline void page_ref_sub(struct page *page, int nr)
 {
+	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
 	atomic_sub(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, -nr);
@@ -142,6 +154,7 @@ static inline void folio_ref_sub(struct folio *folio, int nr)
 static inline int folio_ref_sub_return(struct folio *folio, int nr)
 {
 	int ret = atomic_sub_return(nr, &folio->_refcount);
+	VM_BUG_ON(__page_count_is_frozen(ret + nr));
 
 	if (page_ref_tracepoint_active(page_ref_mod_and_return))
 		__page_ref_mod_and_return(&folio->page, -nr, ret);
@@ -150,6 +163,7 @@ static inline int folio_ref_sub_return(struct folio *folio, int nr)
 
 static inline void page_ref_inc(struct page *page)
 {
+	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
 	atomic_inc(&page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, 1);
@@ -162,6 +176,7 @@ static inline void folio_ref_inc(struct folio *folio)
 
 static inline void page_ref_dec(struct page *page)
 {
+	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
 	atomic_dec(&page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, -1);
@@ -189,6 +204,7 @@ static inline int folio_ref_sub_and_test(struct folio *folio, int nr)
 static inline int page_ref_inc_return(struct page *page)
 {
 	int ret = atomic_inc_return(&page->_refcount);
+	VM_BUG_ON(__page_count_is_frozen(ret - 1));
 
 	if (page_ref_tracepoint_active(page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, 1, ret);
@@ -217,6 +233,7 @@ static inline int folio_ref_dec_and_test(struct folio *folio)
 static inline int page_ref_dec_return(struct page *page)
 {
 	int ret = atomic_dec_return(&page->_refcount);
+	VM_BUG_ON(__page_count_is_frozen(ret + 1));
 
 	if (page_ref_tracepoint_active(page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, -1, ret);
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b64f36a45296..36c21f3d8250 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -390,7 +390,7 @@ static void kho_init_folio(struct page *page, unsigned int order)
 
 	/* For higher order folios, tail pages get a page count of zero. */
 	for (unsigned long i = 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
+		set_page_count_as_frozen(page + i);
 
 	if (order > 0)
 		prep_compound_page(page, order);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1d41fa3dd43e..b364fda29111 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3186,7 +3186,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
 		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
+		set_page_count_as_frozen(page);
 	}
 }
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index cec7bb758bdd..e4ec672a9f51 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1066,7 +1066,7 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	case MEMORY_DEVICE_PRIVATE:
 	case MEMORY_DEVICE_COHERENT:
 	case MEMORY_DEVICE_PCI_P2PDMA:
-		set_page_count(page, 0);
+		set_page_count_as_frozen(page);
 		break;
 
 	case MEMORY_DEVICE_GENERIC:
@@ -1112,7 +1112,7 @@ static void __ref memmap_init_compound(struct page *head,
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		set_page_count_as_frozen(page);
 	}
 	prep_compound_head(head, order);
 }
@@ -2250,7 +2250,7 @@ void __init init_cma_reserved_pageblock(struct page *page)
 
 	do {
 		__ClearPageReserved(p);
-		set_page_count(p, 0);
+		set_page_count_as_frozen(p);
 	} while (++p, --i);
 
 	init_pageblock_migratetype(page, MIGRATE_CMA, false);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65e702fade61..27734cf795da 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1639,14 +1639,14 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		for (loop = 0; loop < nr_pages; loop++, p++) {
 			VM_WARN_ON_ONCE(PageReserved(p));
 			__ClearPageOffline(p);
-			set_page_count(p, 0);
+			set_page_count_as_frozen(p);
 		}
 
 		adjust_managed_page_count(page, nr_pages);
 	} else {
 		for (loop = 0; loop < nr_pages; loop++, p++) {
 			__ClearPageReserved(p);
-			set_page_count(p, 0);
+			set_page_count_as_frozen(p);
 		}
 
 		/* memblock adjusts totalram_pages() manually. */
-- 
2.43.0


