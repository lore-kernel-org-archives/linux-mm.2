Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 798EBC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A5C6B00D3; Mon, 27 Jul 2026 08:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842766B00D5; Mon, 27 Jul 2026 08:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F5C6B00D6; Mon, 27 Jul 2026 08:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 505466B00D3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:35:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D49E41A06D9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:35:49 +0000 (UTC)
X-FDA: 85034503218.29.C060499
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf10.hostedemail.com (Postfix) with ESMTP id EBF93C0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:35:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oOqyKSXw;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2FZl2/YzaMjC0aIAZHsTKk9OBnNm9ulSHwBzV0fwO8=;
	b=kjajMVZElQ2pjlz1PELVpqxHh2B4X44yMtqYuoRJaiGfx8hvNFUbJdQxIyOTc7JB0eXyGI
	ZZwPTek8W88U0Qhdiaw/NX+nTPlGVc+k1S/fls67vdsn+erscvbyTQK3YvQ0fLc9XRZJVd
	Xb2YYK58CpdNQfGvPnCfM6yXu5YYdBo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oOqyKSXw;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155747;
	b=nSYR4kqgpadzYNfPRxKtUsGl9E1DTfAeGd2p/pJOEp6JgokswPIa4I+YzyUx9hXed9NUff
	HgJaR7kI6jC+MR9UZ1NQjxj2ZChsAoCwVDvUfyN+h6GUE3PLXXG/NH6taN7O6SAqseilHV
	IJfkQnkd8Im8BLiFOMi+vPNn8fyFlG0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155743; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=z2FZl2/YzaMjC0aIAZHsTKk9OBnNm9ulSHwBzV0fwO8=;
 b=oOqyKSXwLOpVVJC8j54MdBlrwcfUpS6vT0ZCATMETVM+EoJeqYyf0F0//b+Amp+MleIXeS
 L0Pg94dSI1e5FxLv9uCtglaNojdlGTJUcsxu4DcMdneM+RZ5NDVoiIH+qQ/B0+3jAXIA/2
 iqA8FDGYoSAx93s9dEVxrhJ7f66jqVqJ22AVitfAPTh1JyqtVzdhzTZWE4E8ZFg6KZ+H+S
 5a29gLXIruZ7+fQoEAJnnPzdC9FKrPAGt1Lb7C/XCaLwNJTHPHLFy8fnjGIdeJ0YYyjiR5
 Gtew+Uc/ZNRPl+6IeDO2kxdaGfx3Wcb/91zRI03WOsIPlv7wY2TXG9iGViA5Dw==
X-Lms-Return-Path: <lba+26a67509d+f45f00+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 27 Jul 2026 20:34:22 +0800
Message-Id: <20260727123429.5673-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v8 2/9] mm: factor zone-device page init helpers out of __init_zone_device_page
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EBF93C0009
X-Stat-Signature: fztm1kys7x594eamqbmry8i6kda986sd
X-HE-Tag: 1785155746-672079
X-HE-Meta: U2FsdGVkX1+9BaumjPKdbhYIyFqJNKFnHxiLJGjujxUyFENAwCKz/CE2Cr7sa0qz9019ecC0rP0zQTRcZ5RpfaTKZbqhjlDPLIXiorjatWsJt+nVl+VYSNMDbfcLXNIMVssY9NQKG/WTrggXoVUzNr2L6YSSxynBLultI5fLCo2zFPH84zK9zVfYnVtJWB7HkSrfP9Ny6nL6fIt2J1aRl8LtgxIhSanS39wouVfCQGLsptbqfd/502+nChT7i/p5ZY8xWo4arVjLmrTrclp0OSeqYRr6lEA50pXtZTfhzQb6dJB/nooeLZ/U1LB3M0tkEjCIpRtd+kwnLBe0ZYyy8EXyAfDNrYboqPALuWT6tTRLOkvIGQk/Hz2lEuL3xlHKlhw51e3csc3tOqdU0CpLn5o7qyOl6Y0YiPYwwUCC7ly1mF/5CSChYLzUgP2W+fxxcSxAQ/orJTkQFTHgkdCUQvA/GgAF7kq7N6WkOgl5MaDt4k07TZKoeKU8DM9L8enmP92ZXgbL2mpP+sWeYm3i3b07uMk1K23010k6sO/nYq+1D1pz7AibMNXFLTOt0tkAgdAVyi8rAq5RvntF+dKExdyysxaMV6PuUo1HcRNjpS7+3VB5bI2anHuOZtgj8EoYGb1wlPmMMCD1G8VjtCn2SFDZ0SeMOsDq3TjThXmkOsaqjQXMpu6kXcV9Ln5n6ZLAjR/D5742hGVfBlmc/EAw3evZ6t2bUAHzabjZZRCMX1rLEJ+cRONmqd4VnEPO4Yh3dULkny8dXU4g7fssRJLdGiLjPk7mKFoJ4iaiA6lpf0LsZLGvuXRLQPX+R5mXU5IRbz753/IeJanuZH4RN/CLmVzBlqrVFrA8xDzKNffnZnDmRyyp1A05/XAyFEG41L4wWzlwgj7ZY9ijhobl5hQrUAikW5Fz6EU0NAvfOfhDhzxbDn9P18cXvD6U5Kwlv/EUXCOmL+8BMbs28VH2LOx
 b0edVW/+
 CIaJsyRNcU9MM1jfnymGKJOa/T0ZGCMdZtVxZsJglPltVGvQloHc5twxC5uUsbeAJPLsNV5hGApJP/XjDtMASr/EGX5JHDPmivaEgr86lVasADn/EE+YpVijtK0gHC++l6BSHSLLF8hmNcBtgh0ERpzqZ9GQkHcW8HHXitF61xwbvkurl+ZwpClxCa3LWk0EzRRMEeGu0hi1CDF3vO9wTFXC9nRCQ3GZ/9ewv1JOb0biaVdjNFH2yrvk/PddN4HKMNxU3c+aPB4IkO15vB11W9AyPA7WbcATbHQxMiz0p7UgiGYbXndv47lUK1vXnn9keHumuZBcrTv8U/DeX2/jy3zODonGka+GT0ofzOpmeUmYDhMND67QoHQkzCa6k8+NPGII/GloG+WzciO9/DY2Tkod9FCFFPGedEFLGIo5tCV11YKHtt6cuIqDAEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() currently mixes refcount policy and core
ZONE_DEVICE page setup in a single helper.

Factor the refcount-reset predicate into pagemap_requires_refcount_reset(),
move the common page initialization into __zone_device_page_init(), and
wrap the existing slow path in zone_device_page_init_slow().

This keeps the slow-path behaviour unchanged and gives later patches
reusable helper boundaries.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 56 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 95808ab5cfdb..a70acb7431a6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+/*
+ * Return true when memmap_init_zone_device() must initialize the page
+ * refcount to 0. MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in
+ * the free path, while the remaining ZONE_DEVICE types start from 0 here
+ * and raise the count again when the allocator or driver hands the page
+ * out.
+ */
+static inline bool pagemap_requires_refcount_reset(const struct dev_pagemap *pgmap)
+{
+	/*
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
+	 */
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_FS_DAX:
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
+	case MEMORY_DEVICE_PCI_P2PDMA:
+		return true;
+	case MEMORY_DEVICE_GENERIC:
+		return false;
+	}
+
+	return false;
+}
+
+static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
 					  unsigned long zone_idx, int nid,
 					  struct dev_pagemap *pgmap)
 {
-
 	__init_single_page(page, pfn, zone_idx, nid);
 
 	/*
@@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	 */
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
+}
 
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
-	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
+static void __ref zone_device_page_init_slow(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap)
+{
+	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
+	if (pagemap_requires_refcount_reset(pgmap))
 		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
 }
 
 /*
@@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
@@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-- 
2.20.1

