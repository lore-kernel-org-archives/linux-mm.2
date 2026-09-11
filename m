Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3718FC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0746B008C; Fri, 11 Sep 2026 05:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1586B0092; Fri, 11 Sep 2026 05:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297036B0095; Fri, 11 Sep 2026 05:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05BDA6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:14:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB9CBA015D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:14:24 +0000 (UTC)
X-FDA: 85200920448.07.482F13E
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1ABFA40005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:14:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789118063;
	b=vssUoazVJ4OhUb2PGDQhZRBIifejbl1G4K3UeXVUfuiOAZqzH7d6Xrf4nRqJdL/BhfVpCD
	ZrT4nXcy4eASLwqw2Bj9gPYKOCjww8Nnmg9pT5ew2dpy0nLnG/TMPF+jUW5R/kzIrf15u2
	vEe+Ju4JGljtE8FiekWU8Wp/pRZSQ8o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789118063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SA/8Mg8eu+L5I2G8vWvkfP11hf5i3Yxxao6tJRjNRuE=;
	b=JeHdnqo4aqe+nwHw41SRh+6PjW3VJ2bhFfMP5fvop8BLnx+Y4Or3z5dmhglqYDyrFwO5ts
	4F6zMbA6z5CrxLZXG3fQsYuJmQnUhb7v1ug1DPInA1Vu972QOcJ/naPdUGZcTZj71ZX81Z
	2xw8VrOeu1NJBfLouiG6Rp4OA90oTAo=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hh84W5WYJz8Xrr9;
	Fri, 11 Sep 2026 17:14:19 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 68B9E6JT058032;
	Fri, 11 Sep 2026 17:14:07 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 11 Sep 2026 17:14:09 +0800 (CST)
X-Zmail-TransId: 2af96aa3c661ec0-35e31
X-Mailer: Zmail v1.0
Message-ID: <20260911171409340O9nQbxkRZ18MVTGcrJgjV@zte.com.cn>
In-Reply-To: <20260911160942109wy2iDTGJslK6rHl8E56si@zte.com.cn>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn,20260911160942109wy2iDTGJslK6rHl8E56si@zte.com.cn
Date: Fri, 11 Sep 2026 17:14:09 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
        <surenb@google.com>, <rppt@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
        <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
        <chengming.zhou@linux.dev>, <usama.arif@linux.dev>,
        <gourry@gourry.net>, <harry@kernel.org>, <vbabka@kernel.org>,
        <peterz@infradead.org>, <borntraeger@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAyLzRdIG1tOiBtYWtlIGZvbGlvX3dhbGtfc3RhcnQoKSdzIGxvY2tpbmcgYXNzZXJ0cyBzY2FsYWJsZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 68B9E6JT058032
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 11 Sep 2026 17:14:19 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA3C66B.001/4hh84W5WYJz8Xrr9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1ABFA40005
X-Stat-Signature: uqfqoomw4hwgx9juk8wtnjf4gx5zyicd
X-HE-Tag: 1789118061-314652
X-HE-Meta: U2FsdGVkX19brE0F924tn7RGpeHsjPrgB/hlszk1dgNOMwVpFqLTI5XLqTLrDFN9CDcGMHP3WEN/6dHHI4jB2ttzgWa8AQNH/pYl2OL9pUV0aPZ/GAUiASbx5Rg3B3SpKR+MHtSykobzo5qQiEne1ubpshyfHvhArtoj+bMkoL3gGChMu8Y2mqdc0c8UxrRzOgfhjOPreMKwQcTmD0cEXHL7to8pZ9r06I26t36QCSedi3FYrJqt7whsM5jIQd6yQCcZkaK1ZCD6NoQ/Vqy4G0HvvSjdVb3kSVbtWOOr6QrAQp9tsCoKKrKtXDuFusBb5NBne3D177MDiw00UPZbtbPA7UnTehVk1MvRrTPeRqVQ063x4ufnLZwUD/k4gbSU6OSK3Pis5dVNDm1h4iaEMJAN2EFd8dbXAw4nQZ52wVFWFsRM6tO75SZoKM+SVtWzawATeiGLUNZG5DtDILj8juE6//HZMD8/IuAvknl6lEHlhgwsyiH1oK7sJhPYugqNhXq92pPo8bpfIjV9CF0dOCu0fTTzBesNTJLooFHq0Dgc4kN3l4Z1iZEI/q1PqeQy+F7+o5q8oGHE/zT3EnmUVCdGh6M3/2RTnoBB+dw5e69EfFPkNjlbj+ppUTKvP7Y0gkCrOOOUna2HEaFLdq0qkJ7Y33bXAOlI1j03zwux277kYp77GxuZqihLed2Iti5qSLP97TEY4gkqGOSQE4zc/y+CHe0Kjqy+x7QzpJV+AawWNKRNQarbnRjycdlg235fbPhmbQtb+9/Z11BccEGy8JfwWNX9FPyxBm5OjZ65d03mbj21d/+kO93kIo2rlwn0DEmDEIrhMP6xnQ8Ae908YMLOTowmsEJOeQaZBMMmkJLNcpALSv2xA39TfNep1XcInWk438vX9CleA3GrlBEfJnW/2GDfCZIwVFDhSl1KWBNgV7loTGQ3zVzG9ETx+Sd1KVymnFzuTZ/SszAyDp2
 XDwZitak
 6d9jsnUEamC3CIuiajBMD/rnQkim05b8f5pxqro4PonqNGvYcZugFs7knb9u28yzcV142I/ANIPdZhMyupD4/9paD63qKGrW9Wh8tDpKZIAao24zPGTIiIJBzl4/I3piCmO4p2jWQy20FBEqfMAagwzAY25gul71atNod8UEzHUbaMQx2OYhthGB9ibgSzbZ4APmZsbwArFHCoKYOIcB6LGw39x4AFpDgg5OLqwjaPQWyNtc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC: Lorenzo Stoakes <ljs@kernel.org>
----
From: Xu Xin (ZTE) <xu.xin@linux.dev>

Add an additional member 'walk_lock' to folio_walk to indicate
locking requirements for the walk. Similar to commit 49b0638502da0
("mm: enable page walking API to lock vmas during the walk").
But no change is made on any existing locking behavior,
all existing folio_walk_start() callers are currently still
under mmap_read_lock() protection.

This change is prepared for the latter patch to enable VMA locking
asserts. folio_walk_start now operate under write-locked mmap_lock.
With introduction of vma locks at the next patch, the vmas have to
be locked as well during such walks to prevent concurrent page
faults in these areas.

No functional change intended.

Signed-off-by: Xu Xin (ZTE) <xu.xin@linux.dev>
---
 arch/s390/mm/fault.c     |  4 +++-
 include/linux/pagewalk.h |  1 +
 kernel/events/uprobes.c  |  4 +++-
 mm/huge_memory.c         |  4 +++-
 mm/ksm.c                 |  4 +++-
 mm/migrate.c             |  8 ++++++--
 mm/pagewalk.c            | 10 +++++++++-
 mm/rmap.c                |  4 +++-
 8 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 46d828926009..968f128a5232 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -412,7 +412,9 @@ __context_unsafe(/* folio_walk_end() not instrumented */)
 	unsigned long addr = get_fault_address(regs);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct folio *folio;
 	int rc;

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index 1c397be0d092..455428eaf1fc 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -184,6 +184,7 @@ struct folio_walk {
 	};
 	/* private */
 	spinlock_t *ptl;
+	enum page_walk_lock walk_lock;
 };

 struct folio *folio_walk_start(struct folio_walk *fw,
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7709ea882477..054fdcb52136 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -507,7 +507,9 @@ int uprobe_write(struct arch_uprobe *auprobe, struct vm_area_struct *vma,
 	int ret, ref_ctr_updated = 0;
 	unsigned int gup_flags = FOLL_FORCE;
 	struct mmu_notifier_range range;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct folio *folio;
 	struct page *page;

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dd66c6ad5af1..b714677e2f20 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4795,7 +4795,9 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 	 */
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = vma_lookup(mm, addr);
-		struct folio_walk fw;
+		struct folio_walk fw = {
+			.walk_lock  = PGWALK_RDLOCK,
+		};
 		struct folio *folio;
 		struct address_space *mapping;
 		unsigned int target_order = new_order;
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..8df66b4e5de0 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -817,8 +817,10 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 	unsigned long addr = rmap_item->address;
 	struct vm_area_struct *vma;
 	struct page *page = NULL;
-	struct folio_walk fw;
 	struct folio *folio;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};

 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..fa638adfb0de 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2302,7 +2302,9 @@ static int add_folio_for_migration(struct mm_struct *mm, const void __user *p,
 		int node, struct list_head *pagelist, bool migrate_all)
 {
 	struct vm_area_struct *vma;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct folio *folio;
 	unsigned long addr;
 	int err = -EFAULT;
@@ -2464,7 +2466,9 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long addr = (unsigned long)(*pages);
 		struct vm_area_struct *vma;
-		struct folio_walk fw;
+		struct folio_walk fw = {
+			.walk_lock  = PGWALK_RDLOCK,
+		};
 		struct folio *folio;
 		int err = -EFAULT;

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 7411702a37f5..8eb29fba20ad 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -910,7 +910,15 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	pgd_t *pgdp;
 	p4d_t *p4dp;

-	mmap_assert_locked(vma->vm_mm);
+	/*
+	 * Other locking modes except for mmap or vma read locking are not
+	 * expected.
+	 */
+	if (fw->walk_lock != PGWALK_RDLOCK && fw->walk_lock != PGWALK_VMA_RDLOCK_VERIFY)
+		WARN_ONCE(1, "walk_lock is not expected!\n");
+	process_mm_walk_lock(vma->vm_mm, fw->walk_lock);
+	process_vma_walk_lock(vma, fw->walk_lock);
+
 	vma_pgtable_walk_begin(vma);

 	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
diff --git a/mm/rmap.c b/mm/rmap.c
index 5fefe5b060b1..fd8e1c9e4424 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2871,7 +2871,9 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 	struct mmu_notifier_range range;
 	struct folio *folio, *fw_folio;
 	struct vm_area_struct *vma;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct page *page;
 	swp_entry_t entry;
 	pte_t swp_pte;
-- 
2.25.1

