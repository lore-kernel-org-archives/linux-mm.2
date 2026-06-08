Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41594CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA4F6B0005; Mon,  8 Jun 2026 17:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81746B008C; Mon,  8 Jun 2026 17:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE9E6B0092; Mon,  8 Jun 2026 17:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DEEA6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:54:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 443C91A0323
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:54:14 +0000 (UTC)
X-FDA: 84858099228.30.BBB0B1A
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E7FC40002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:54:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PUZpmHLk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780955652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Nzbf92Rg2RFuKwxuKQMD7LFkVELfr0DE02iiQTNScM=;
	b=1D9ymoFp/dxNJWJwEogoEmSYB7QF4n4Zf5pITJqQr3JxElozoNqfsib5ExJdfBS6CxxFha
	3gHyJF6dy8n1TFbS9VTHKpPHY5Bp6RU8HGQ9ma9VkZOwUEyfVe6UMeRfnPmr5cYzY79Uf5
	3BbjcctWB2jX+jrNhYx6AjEez0AXnQY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PUZpmHLk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780955652;
	b=YgeyjLezrDQ3XU3KEuHmxHDM58AF+XJ/w9bzakdOd22QuZKvrBa/I6m3Vsh71aZH1RWRGy
	b86l7dWuXohdFxe5tFevd4BmchBTnJ11aTwLa33lhLbd5CFSbscZ3cPn3x/FLAokWimJqj
	+y2F0z8UA4D4Q90scQaWi++L6BiN1BA=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780955647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Nzbf92Rg2RFuKwxuKQMD7LFkVELfr0DE02iiQTNScM=;
	b=PUZpmHLkwuxb6lTcTcGTp2FqVbIL5ZGd9oa4qRnMd7qXTTXJ+/uvIw5TIPwEnGz2g/sapO
	y3FGdi/wotDTa1W1EwGmdfkTB8EPw7sP25EWdRi5nMa8OCsHYD3ec44B/mAKmQglXrO4Ku
	TwQZr1Tr7dAX8Vgv0MwzrChx3HToPq8=
Date: Mon, 08 Jun 2026 21:54:03 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ilya.gladyshev@linux.dev
Message-ID: <7e69c353ecfbbcdecfee2d85a35635cb9a07fec8@linux.dev>
TLS-Required: No
Subject: [PATCH v4 1/2] mm: drop page refcount zero state semantics
To: ivgorbunov@me.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org,
 vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com,
 pfalcato@suse.de, kirill@shutemov.name
In-Reply-To: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5E7FC40002
X-Rspam-User: 
X-Stat-Signature: g4ac59xz1tkuit5qmdujwffmbcfp4jh1
X-Rspamd-Server: rspam09
X-HE-Tag: 1780955649-371969
X-HE-Meta: U2FsdGVkX18JNatptlYuaPZt+Ptxcb5ka02sPco/hC2wcV+DzFUjP+wU9OpMtPfd0UgDwTEznohoGf57I7SWfxwauG8/taogQPCUMK2XYt58+QFhrmXe7vRJ/LhvpomfDk2vYZU635TTTRe4AHP+LmmhKA4eE2wHP9mEbT8aCPHRHC9NNaljzakiIFVSg+KhoNXD+i1DJn/weNoDLbkFs2GynoG6qysWpvhsg/gcU2QM99DwtuXP4KmSNl8/Wo0rMLDsERjMid0/bx135YOrQKrAGhrOsCBiDCKEt6S977C9b8SrQeHaqi3IHaUgK4rXDomvHreBMdr1hIM4xTzOCXALbbzP/b9jv/OgG6x4CJGaIakDrDSwOYX0vI924gSGgCcsFcqv8GmIWsvgHzQP6MqysMTuwKlW/R2zaiuwmF3ue+VjNPV4hKgKV+a5CdEdEXTTaNLdEp4PPG0f7TBIxz9PLhBENs4p0O4T2OXedzsKu7xquKWfGu2d+VebCBme03tvh+MEdwOpAft899zWtNB/pxOVGZuuIP8FRvnWpZkSyjcwFaIvR5tfQy47v+ukgfqOe/F9AD1Q2zWHsa7EFJtA8f5TDR5/YV1C6XlLZlM84ze/BHBjEDb+2tFoYpJRWOmeFslLyw4WvgDlWdox+wA42YlhuT4pBeq3uHpzUgzlS8HtlBYrZ1/VUV9kJIbM1szWERLW2go89r2QJQoGE1dx/m8sHPVXlCiVhprwBPEe6oLVcesWTP2KwxGIXRNpvdswtfbWVRUI2FgROTf9azAJU2ESMN0Ac9iWgCI9jfh0LCWQjBMdQ0eV4KrKE9ljQiCUkSArJm4TOsc95cPPj0AbWZp8p/oOQD/9Zaw3hiJOeVH3Pl1W9avASn1vxjCXzL2DCuQo1BImAPqUciEi6CZk1XHxhQwMgA6gKvGC623DQXsoYy/IWt6CrSKsoqLxaW4JAXevFFIkT2XGXyk
 yJB/o3O/
 jlRyGjLQpiEt4r7rpgDna8eeNsM33oa/kQodCgWbYqSmdTJzWhwksV65uoQ2CKHJxqaG2QJ4NzFwj7lGoonvSCQ4sJ3O0huDOVQjWPU9fgWM5Vj8Jwqjjl22qlManftJcO1G2vIe5yTThP3Om1gfTVtYNEM7TN3wuuZkOmEGBt81S6AJ0DSu1psQnszyclkrr94lP5fIC/Jro0NlddlPzIPDhP7fuKTwxvsR7dpdzqC4LOhh5F2wqsx4kYgsutpEZ3rbzTqQdL3oXQ2zY1rwU7hFlGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gorbunov Ivan <ivgorbunov@me.com>

Some call sites manipulate page refcount directly via
set_page_count() instead of using more direct API like set_frozen() /
init_refcount().

This conflicts with the next patch, which will stop treating zeroed
refcount as the indicator of a frozen page. To prepare for that change,
this patch:

- "Deprecates" the internal assumption that a frozen page has refcount=3D=
0
(and vice versa). Callers of page_ref_count() still see 0 for frozen
pages.

- Inserts VM_BUG_ON() checks in every refcount API function to prevent
  following errnous behaviour:

page =3D alloc_frozen_page() // page is frozen
page_ref_inc(page, 1) // BUG: Increment on frozen page instead of init

- Renames _unless_zero() functions into _unless_frozen()

Reviewed-by: Artem Kuzin <artem.kuzin@huawei.com>
Co-developed-by: Gladyshev Ilya <ilya.gladyshev@linux.dev>
Signed-off-by: Gladyshev Ilya <ilya.gladyshev@linux.dev>
Signed-off-by: Gorbunov Ivan <ivgorbunov@me.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com> # p2pdma.c
---
 drivers/pci/p2pdma.c               |  4 ++--
 include/linux/mm.h                 |  2 +-
 include/linux/page_ref.h           | 36 ++++++++++++++++++++++++------
 kernel/liveupdate/kexec_handover.c |  6 ++---
 lib/test_hmm.c                     |  4 ++--
 mm/hugetlb.c                       |  2 +-
 mm/internal.h                      |  2 +-
 mm/memremap.c                      |  4 ++--
 mm/mm_init.c                       |  6 ++---
 mm/page_alloc.c                    |  4 ++--
 10 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 7c898542af8d..43ed40a6183b 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -148,7 +148,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struc=
t kobject *kobj,
 		 * using it.
 		 */
 		VM_WARN_ON_ONCE_PAGE(page_ref_count(page), page);
-		set_page_count(page, 1);
+		init_page_count(page);
 		ret =3D vm_insert_page(vma, vaddr, page);
 		if (ret) {
 			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
@@ -158,7 +158,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struc=
t kobject *kobj,
 			 * because we don't want to trigger the
 			 * p2pdma_folio_free() path.
 			 */
-			set_page_count(page, 0);
+			set_page_count_frozen(page);
 			percpu_ref_put(ref);
 			return ret;
 		}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fc2acedf0b76..91482c868f66 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1780,7 +1780,7 @@ static inline int folio_put_testzero(struct folio *=
folio)
  */
 static inline bool get_page_unless_zero(struct page *page)
 {
-	return page_ref_add_unless_zero(page, 1);
+	return page_ref_add_unless_frozen(page, 1);
 }
=20
=20static inline struct folio *folio_get_nontail_page(struct page *page)
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 94d3f0e71c06..f784db6f775a 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -62,6 +62,16 @@ static inline void __page_ref_unfreeze(struct page *pa=
ge, int v)
=20
=20#endif
=20
+static=20inline bool __page_count_is_frozen(int count)
+{
+	return count =3D=3D 0;
+}
+
+static inline bool __page_is_frozen(const struct page *page)
+{
+	return __page_count_is_frozen(atomic_read(&page->_refcount));
+}
+
 static inline int page_ref_count(const struct page *page)
 {
 	return atomic_read(&page->_refcount);
@@ -101,9 +111,9 @@ static inline void set_page_count(struct page *page, =
int v)
 		__page_ref_set(page, v);
 }
=20
-static=20inline void folio_set_count(struct folio *folio, int v)
+static inline void folio_init_count(struct folio *folio)
 {
-	set_page_count(&folio->page, v);
+	set_page_count(&folio->page, 1);
 }
=20
=20/*
@@ -115,8 +125,14 @@ static inline void init_page_count(struct page *page=
)
 	set_page_count(page, 1);
 }
=20
+static=20inline void set_page_count_frozen(struct page *page)
+{
+	set_page_count(page, 0);
+}
+
 static inline void page_ref_add(struct page *page, int nr)
 {
+	VM_BUG_ON_PAGE(__page_is_frozen(page), page);
 	atomic_add(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, nr);
@@ -129,6 +145,7 @@ static inline void folio_ref_add(struct folio *folio,=
 int nr)
=20
=20static inline void page_ref_sub(struct page *page, int nr)
 {
+	VM_BUG_ON_PAGE(__page_is_frozen(page), page);
 	atomic_sub(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, -nr);
@@ -142,6 +159,7 @@ static inline void folio_ref_sub(struct folio *folio,=
 int nr)
 static inline int folio_ref_sub_return(struct folio *folio, int nr)
 {
 	int ret =3D atomic_sub_return(nr, &folio->_refcount);
+	VM_BUG_ON_FOLIO(__page_count_is_frozen(ret + nr), folio);
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_and_return))
 		__page_ref_mod_and_return(&folio->page, -nr, ret);
@@ -150,6 +168,7 @@ static inline int folio_ref_sub_return(struct folio *=
folio, int nr)
=20
=20static inline void page_ref_inc(struct page *page)
 {
+	VM_BUG_ON_PAGE(__page_is_frozen(page), page);
 	atomic_inc(&page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, 1);
@@ -162,6 +181,7 @@ static inline void folio_ref_inc(struct folio *folio)
=20
=20static inline void page_ref_dec(struct page *page)
 {
+	VM_BUG_ON_PAGE(__page_is_frozen(page), page);
 	atomic_dec(&page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, -1);
@@ -189,6 +209,7 @@ static inline int folio_ref_sub_and_test(struct folio=
 *folio, int nr)
 static inline int page_ref_inc_return(struct page *page)
 {
 	int ret =3D atomic_inc_return(&page->_refcount);
+	VM_BUG_ON_PAGE(__page_count_is_frozen(ret - 1), page);
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, 1, ret);
@@ -217,6 +238,7 @@ static inline int folio_ref_dec_and_test(struct folio=
 *folio)
 static inline int page_ref_dec_return(struct page *page)
 {
 	int ret =3D atomic_dec_return(&page->_refcount);
+	VM_BUG_ON_PAGE(__page_count_is_frozen(ret + 1), page);
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, -1, ret);
@@ -228,7 +250,7 @@ static inline int folio_ref_dec_return(struct folio *=
folio)
 	return page_ref_dec_return(&folio->page);
 }
=20
-static=20inline bool page_ref_add_unless_zero(struct page *page, int nr)
+static inline bool page_ref_add_unless_frozen(struct page *page, int nr)
 {
 	bool ret =3D atomic_add_unless(&page->_refcount, nr, 0);
=20
@@=20-237,9 +259,9 @@ static inline bool page_ref_add_unless_zero(struct =
page *page, int nr)
 	return ret;
 }
=20
-static=20inline bool folio_ref_add_unless_zero(struct folio *folio, int =
nr)
+static inline bool folio_ref_add_unless_frozen(struct folio *folio, int =
nr)
 {
-	return page_ref_add_unless_zero(&folio->page, nr);
+	return page_ref_add_unless_frozen(&folio->page, nr);
 }
=20
=20/**
@@ -255,12 +277,12 @@ static inline bool folio_ref_add_unless_zero(struct=
 folio *folio, int nr)
  */
 static inline bool folio_try_get(struct folio *folio)
 {
-	return folio_ref_add_unless_zero(folio, 1);
+	return folio_ref_add_unless_frozen(folio, 1);
 }
=20
=20static inline bool folio_ref_try_add(struct folio *folio, int count)
 {
-	return folio_ref_add_unless_zero(folio, count);
+	return folio_ref_add_unless_frozen(folio, count);
 }
=20
=20static inline int page_ref_freeze(struct page *page, int count)
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
index 1b592d86dc48..d436f6d6913f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -361,7 +361,7 @@ EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
 {
 	for (unsigned long i =3D 0; i < nr_pages; i++) {
-		set_page_count(page + i, 1);
+		init_page_count(page + i);
 		/* Clear each page's codetag to avoid accounting mismatch. */
 		clear_page_tag_ref(page + i);
 	}
@@ -372,13 +372,13 @@ static void kho_init_folio(struct page *page, unsig=
ned int order)
 	unsigned long nr_pages =3D (1 << order);
=20
=20	/* Head page gets refcount of 1. */
-	set_page_count(page, 1);
+	init_page_count(page);
 	/* Clear head page's codetag to avoid accounting mismatch. */
 	clear_page_tag_ref(page);
=20
=20	/* For higher order folios, tail pages get a page count of zero. */
 	for (unsigned long i =3D 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
+		set_page_count_frozen(page + i);
=20
=20	if (order > 0)
 		prep_compound_page(page, order);
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..0cbcf9da4911 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1715,7 +1715,7 @@ static void dmirror_devmem_folio_split(struct folio=
 *head, struct folio *tail)
 	if (tail =3D=3D NULL) {
 		folio_reset_order(rfolio);
 		rfolio->mapping =3D NULL;
-		folio_set_count(rfolio, 1);
+		folio_init_count(rfolio);
 		return;
 	}
=20
@@=20-1729,7 +1729,7 @@ static void dmirror_devmem_folio_split(struct fol=
io *head, struct folio *tail)
=20
=20	folio_page(tail, 0)->mapping =3D folio_page(head, 0)->mapping;
 	tail->pgmap =3D head->pgmap;
-	folio_set_count(page_folio(rpage_tail), 1);
+	folio_init_count(page_folio(rpage_tail));
 }
=20
=20static const struct dev_pagemap_ops dmirror_devmem_ops =3D {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c921287489de..f2fec6b1b1df 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3133,7 +3133,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(=
struct folio *folio,
 	for (pfn =3D head_pfn + start_page_number; pfn < end_pfn; page++, pfn++=
) {
 		__init_single_page(page, pfn, zone, nid);
 		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
+		set_page_count_frozen(page);
 	}
 }
=20
diff=20--git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..3f2a91de8a80 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -595,7 +595,7 @@ static inline void set_page_refcounted(struct page *p=
age)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(page_ref_count(page), page);
-	set_page_count(page, 1);
+	init_page_count(page);
 }
=20
=20static inline void set_pages_refcounted(struct page *page, unsigned lo=
ng nr_pages)
diff --git a/mm/memremap.c b/mm/memremap.c
index 053842d45cb1..8025cc27b408 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -462,7 +462,7 @@ void free_zone_device_folio(struct folio *folio)
 		 * Reset the refcount to 1 to prepare for handing out the page
 		 * again.
 		 */
-		folio_set_count(folio, 1);
+		folio_init_count(folio);
 		break;
=20
=20	case MEMORY_DEVICE_FS_DAX:
@@ -519,7 +519,7 @@ void zone_device_page_init(struct page *page, struct =
dev_pagemap *pgmap,
 	 * memunmap_pages().
 	 */
 	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order=
));
-	set_page_count(page, 1);
+	init_page_count(page);
 	lock_page(page);
=20
=20	if (order)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..96fcace24b6d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1040,7 +1040,7 @@ static void __ref __init_zone_device_page(struct pa=
ge *page, unsigned long pfn,
 	case MEMORY_DEVICE_PRIVATE:
 	case MEMORY_DEVICE_COHERENT:
 	case MEMORY_DEVICE_PCI_P2PDMA:
-		set_page_count(page, 0);
+		set_page_count_frozen(page);
 		break;
=20
=20	case MEMORY_DEVICE_GENERIC:
@@ -1086,7 +1086,7 @@ static void __ref memmap_init_compound(struct page =
*head,
=20
=20		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		set_page_count_frozen(page);
 	}
 	prep_compound_head(head, order);
 }
@@ -2224,7 +2224,7 @@ void __init init_cma_reserved_pageblock(struct page=
 *page)
=20
=20	do {
 		__ClearPageReserved(p);
-		set_page_count(p, 0);
+		set_page_count_frozen(p);
 	} while (++p, --i);
=20
=20	init_pageblock_migratetype(page, MIGRATE_CMA, false);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d49c254174da..730dc6301a07 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1599,14 +1599,14 @@ void __meminit __free_pages_core(struct page *pag=
e, unsigned int order,
 		for (loop =3D 0; loop < nr_pages; loop++, p++) {
 			VM_WARN_ON_ONCE(PageReserved(p));
 			__ClearPageOffline(p);
-			set_page_count(p, 0);
+			set_page_count_frozen(p);
 		}
=20
=20		adjust_managed_page_count(page, nr_pages);
 	} else {
 		for (loop =3D 0; loop < nr_pages; loop++, p++) {
 			__ClearPageReserved(p);
-			set_page_count(p, 0);
+			set_page_count_frozen(p);
 		}
=20
=20		/* memblock adjusts totalram_pages() manually. */
--=20
2.54.0

