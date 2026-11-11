Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E703E60A2608
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ohH/Hah2
Received: by kanga.kvack.org (Postfix)
	id 8EA706B05B5; Wed, 11 Nov 2026 06:31:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C12F6B05B6; Wed, 11 Nov 2026 06:31:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8936B05B7; Wed, 11 Nov 2026 06:31:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56B9E6B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:31:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCD481A027E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:31:02 +0000 (UTC)
X-FDA: 85422621564.12.34CFD15
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf02.hostedemail.com (Postfix) with ESMTP id A1B9A8000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:31:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="ohH/Hah2";
	spf=pass (imf02.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5hy2lmgZD/5AZxsU8Tl1ILJtqvLvPEUZjJf6dlzk2Y=;
	b=y7uuW0CzRxxwc1Zj2Cy/AuQwePQcKberaUeqfc1uH7V3fHddpDRpnLP5yUNSEMt6L4hlfH
	Qk+d8VIHHuZKxsMPyrl8AfsYpOWBPcK4sxF6boqQcR36cvK1m4lOQ05iZzb1+CNYf/5G1G
	xWtg/f/+DZkfI6xmyXX31ElG6r9Ss7E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396660;
	b=5lqOQ7awQIvk+JpwDQn7lcbwvozHAd/+UHPMsCNLwyCTiYWiKG5amUI7vobQzcLsTaNZAN
	vqHMFsAAvMKqYtxVVro2zK+WVVXY5CfWYODzwk6H5euki+BQHMvEP+8Grs1Lt0AMHSTNwc
	olALyr/0Z6oFlgwTVF0V39q7cewETz0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="ohH/Hah2";
	spf=pass (imf02.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794396660; x=1825932660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i5hy2lmgZD/5AZxsU8Tl1ILJtqvLvPEUZjJf6dlzk2Y=;
  b=ohH/Hah27I3a/apAaVTuLg+R3+w3WBAI84Ac3VZvXdyFHCZCbrhN0klq
   XSY5f+hMSIZl2MsylgFIVSSRr7Q2CfgfMzyd2lXtJeAza4yO0SVyv743K
   TQDQry+qrQ2KDhWKFrdvakT32fnlkiC1zTzT6+yBKP5tCBZo4z6NPlIk+
   dDy9K4Tf1hLkg0SpgL+iHA0vphEpUf0AsoxIigvE9qeEiBBFLqeYl7s8n
   fxMGNRC97/TYxA/aaZZ9099dwwn+FKHa3mbKDIEXIZ6baXPqJuAD+ILhP
   pYvUEWfa/UVXMmZDX5m3QF+6qrLJsbp2A4b7UitFPhpoWFxBOghZRdtPl
   Q==;
X-CSE-ConnectionGUID: im2s5TN3Quyoo/lC8X1kdw==
X-CSE-MsgGUID: g4ZRM8JkRxe0XlKxv9bZQQ==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33483459"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 11:30:57 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:1656]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id b69e9d91-cb6d-4ce2-b584-d80e29bdc93c; Wed, 11 Nov 2026 11:30:57 +0000 (UTC)
X-Farcaster-Flow-ID: b69e9d91-cb6d-4ce2-b584-d80e29bdc93c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 11:30:56 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 11:30:54 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 2/4] mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok() helpers
Date: Wed, 11 Nov 2026 11:30:43 +0000
Message-ID: <20261111113045.35368-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111113045.35368-1-farbere@amazon.com>
References: <20261111113045.35368-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qq77s9dbu4ruke79zpdy46sk3qabta8e
X-Rspamd-Queue-Id: A1B9A8000A
X-Rspam-User: 
X-HE-Tag: 1794396660-456099
X-HE-Meta: U2FsdGVkX18sq7IuuUslz/P7j+tcFpeNYciNlMZ1TFuj143YpCmhKSSoq4PjdXKQ+HJJFoMW+2zrPv4DQINl3cP7176s59oPW1XQDoEaKdBZOyaGBCP2AteCYARoeiJroz8VYLayOokpPFhNfMngqg6YFdaDti1O38Q0QOCpu9PqNgCjoXhGohbl0+8PLn3ZZBnmyerphnFRKm0dmVFcIJdQyJ31xmtOpXrwu9oLdPh004QaKkMntv2O5l0MR+14r9IgDIg9TCIrFb/qqxRbeVPqSpQaTy2TeLtRJdJbHMULrd7QP6QvFxhvNk3V1KaJX7PM12LDWNi95H29qOtShwf5fdPFKPKyrhbRoxxBsT09QA1xJLsoHoDyfDkm//E0CNHT6x1GSur1iq668evaMcu0tVnAWyvimZvxZChK14hi4hMHtljkV4CT6FnoMaipAYjPxR04fQuMObkxR9mT6iPNUsjSgEkgd6O+5sUjcEFINazRqhXT2rRe1mCj0Vf1baMUvPlSXKNgcvjJ/Qrikz3KHB1bA+Zs9XjKUbPGEJhqhplPl61Iq4mQe+oAFnyEw8phrywx6UJ+lZpA0fg7YG2rSdR8JWHkIIfr5yBux6AhDX7+uRPnIVx6Pnr/OWZ32WSl5SLrbGaPFm77QL8b4kvU6bRQlt6EZWBtYuH8y9abfZzFWWhOhCUoYBuiuHui2Kmr5YMq7mFVFM1vffzuiX170cfzhRW68kOwoVwjSijf0s8w+opIN4g4EDVK1C+23zJ2ALpiwiPjmRqncaQWLOtDOwMnNpaygNTiIlcsIJ9PGWSZIg7u7feeNKRme2ILdY5/rbyHQOc3J5PwWJh+GK3eUk0mVvfbMbUZFBqfo6lgcubfZLFyO3AqvwA0p0uB4CW/qEN+fZ3ZMs6S7XcAL3hx5YSehYfx+eUk1d22YKw+xvAGJ32yd49yVSbOHXX/VaGnaO87WOpBJZL/tsO
 2qFnVttV
 hJDi3I0l9eCBYobQqNyS+vDPDWpdJLxvWcC0Ktixx9mgfwClxsf1grrY5tevkHgRBB/ehjnPuESthaldrS8ZmpPfsVnGo/jjBVKdj5Qo9XGIfjIa/Ce6dvOrf4RfXwbXLWkKFNrRUiy1sFGNADdWoEhKfYS5ud9Mep3/TzrnHtEttJuKffucA1N+zRHyBlEWXOBLF6Iaej0cqvd71xGYFooX3U1W4qxFkEFHZiVJ4qG+5BGqsvsuk6CTNcDzZJYJnaI4l4Y+OdCpCsCWAc59WTmnJRqEaMNu6hKJKZg7QV338B4pzFPJX7iK9AJZJU8IXJIuaapU1LlvDOvP35WuDR3/ObwNX5tBG070eHEmU5vWpZTZ8JDNfvuBH0aGtuZBxEuG0rNrNpPFFE45iKDr4iT1izdY+dzxOX4KoBOpOF4utINZsoJX47J8zUZS7k6dUeRCnmWwzvTGT1BgY+YkF79Zs3cTzODcdxkhIQh3M1NZrYUBVyTmnzcnQA5ryeb6L9PMMf3J0y5PQNYXSTZ7jIrG7txkT9Py0Zo5t2pTGZn/EDoSeEMJJU2+wk/2yxhoT130vapFRM4nE2uvyRxsB3fmzORQJUyn9om2agVTQ4lxR22gy4/hzWYhEBV+4H9zNTJj/lNd6m+h7nSmyE39rsveXV3JaPhKEH6nJO4GUUnmRJoYUPS2DOBTVCKiEWGO2o0/L2ctBHbALKZnJOOWeU22SVdhrIAugwO+Jg7Ffx5x/Cl39iMGf5bKBvQyVpP5Wq57I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

->fault/->huge_fault handlers of VM_PFNMAP mappings that want huge PFN
mappings open-code the same steps: check that the order-aligned fault
window lies within the VMA and that the pfn is aligned to the order,
then call vmf_insert_pfn(), vmf_insert_pfn_pmd() or vmf_insert_pfn_pud()
depending on the order, guarded by
CONFIG_ARCH_SUPPORTS_{PMD,PUD}_PFNMAP, and fall back to a smaller order
otherwise. vfio-pci has its own is_aligned_for_order() and
vfio_pci_vmf_insert_pfn() for this.

Add vmf_pfn_order_ok() for the window and alignment check, and
vmf_insert_pfn_order() for the order dispatch. The latter also checks
pfn_modify_allowed() for huge orders: the order-0 vmf_insert_pfn() does
this, but vmf_insert_pfn_pmd() and vmf_insert_pfn_pud() do not. The two
are separate so that a driver can apply its own policy (access checks,
device locking) between them.

vmf_insert_pfn_order() passes the fault's write flag to
vmf_insert_pfn_pmd() and vmf_insert_pfn_pud(), as the DAX and DRM
->huge_fault handlers do. With write=false, insert_pmd() leaves a
read-only entry in place and returns VM_FAULT_NOPAGE, so a store to a
mapping that mm write-protected for tracking (soft-dirty, uffd-wp)
faults forever; wp_huge_pmd() splits the entry only when the handler
returns VM_FAULT_FALLBACK. Passing it marks the entry young, dirty and,
where the VMA allows, writable, as wp_page_reuse() does at PTE level.
The order-0 path needs nothing: wp_pfn_shared() resolves that fault.

The helper also declines the huge zero folio's pfn, which
vmf_insert_pfn_pmd() refuses with SIGBUS, so that the fault is retried
at PTE order where it maps.

They will be used by the /dev/mem and UIO huge_fault handlers added
later in this series.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/mm.h | 28 ++++++++++++++++++++++++++
 mm/memory.c        | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c11bdee1596a..57437b317709 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5010,6 +5010,34 @@ vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn);
+vm_fault_t vmf_insert_pfn_order(struct vm_fault *vmf, unsigned long pfn,
+				unsigned int order);
+
+/**
+ * vmf_pfn_order_ok - check that a pfn can be mapped at a given fault order
+ * @vmf: The fault being handled.
+ * @pfn: The pfn to map at the start of the order-aligned fault window.
+ * @order: The fault order (0 for a single page).
+ *
+ * For a huge (order > 0) fault, the order-aligned window around @vmf->address
+ * must lie within the VMA and @pfn must be aligned to @order. @pfn is only
+ * looked at once the window is known to lie within the VMA, so a caller may
+ * compute it before calling, even when the window starts below vm_start.
+ *
+ * Return: true if vmf_insert_pfn_order() may map @pfn at @order, false if the
+ * fault should fall back to a smaller order.
+ */
+static inline bool vmf_pfn_order_ok(const struct vm_fault *vmf,
+				    unsigned long pfn, unsigned int order)
+{
+	const struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+
+	return !order || (addr >= vma->vm_start &&
+			  addr + (PAGE_SIZE << order) <= vma->vm_end &&
+			  IS_ALIGNED(pfn, 1UL << order));
+}
+
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index ab29ec719ae1..0c583442e049 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3002,6 +3002,55 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vmf_insert_pfn);
 
+/**
+ * vmf_insert_pfn_order - insert a pfn mapping of a given fault order
+ * @vmf: The fault being handled.
+ * @pfn: The pfn to map at the start of the order-aligned fault window.
+ * @order: The fault order (0 for a single page).
+ *
+ * Helper for ->fault and ->huge_fault handlers of VM_PFNMAP mappings: maps @pfn
+ * with a PTE for order 0, or with a PMD/PUD for PMD_ORDER/PUD_ORDER where the
+ * architecture supports huge PFN mappings. The caller must have checked the
+ * window and the pfn alignment with vmf_pfn_order_ok().
+ *
+ * vma cannot be a COW mapping.
+ *
+ * Return: vm_fault_t value; %VM_FAULT_FALLBACK if @order cannot be mapped, so
+ * that the fault is retried at a smaller order.
+ */
+vm_fault_t vmf_insert_pfn_order(struct vm_fault *vmf, unsigned long pfn,
+				unsigned int order)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+
+	if (!order)
+		return vmf_insert_pfn(vma, vmf->address, pfn);
+
+	/*
+	 * vmf_insert_pfn_pmd() refuses the huge zero folio's pfn with SIGBUS,
+	 * while a PTE mapping of it is fine, so fall back to a smaller order.
+	 */
+	if (is_huge_zero_pfn(pfn))
+		return VM_FAULT_FALLBACK;
+
+	/*
+	 * vmf_insert_pfn_pmd()/_pud() don't call pfn_modify_allowed(), unlike
+	 * the order-0 path, so check it explicitly for the L1TF mitigation.
+	 */
+	if (!pfn_modify_allowed(pfn, vma->vm_page_prot))
+		return VM_FAULT_FALLBACK;
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
+		return vmf_insert_pfn_pmd(vmf, pfn, write);
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
+		return vmf_insert_pfn_pud(vmf, pfn, write);
+
+	return VM_FAULT_FALLBACK;
+}
+EXPORT_SYMBOL_GPL(vmf_insert_pfn_order);
+
 static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
 			bool mkwrite)
 {
-- 
2.47.3


