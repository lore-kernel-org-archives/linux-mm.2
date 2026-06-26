Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB19C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6CAC6B00AA; Fri, 26 Jun 2026 14:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43B26B0134; Fri, 26 Jun 2026 14:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5A146B0136; Fri, 26 Jun 2026 14:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 782CB6B00AA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:46:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3F0F14052E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:46:09 +0000 (UTC)
X-FDA: 84922943658.05.0F02B3B
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id ABCB5100009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:46:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MyVrd9zj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782499568;
	b=STvnFGOJslMwj3jMqMymDndNpuZHbtfhV+mc0mr5yaom67HzOwqeXbT0pUUnnAuQaScoCe
	GMXy7KMPNjPkatmmfXPeyd/5SX0W+9FC6rN9pQfpFuw/kjjDoo3kVoM7CRmiDLI2ucu9Di
	gI2vFpfWmhnQ91z+1vib706IgA/2W2Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782499568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRUa8/NlXmIFhVcnO4ujP3Pr9ZCPz2BLY08nhz5QtEA=;
	b=bDcEE7tZ2MDDZZZLMevcJASEb+lfmtiqeSxKd/IIHUHapfMbM23KTpqbWfx3tDIQCZA5a1
	UwuBh3urO6i8JBIpee4EyBOkB6F2yyBQAfWM68EI0kVzPVnUXuVIGJbLTnyGSYuA/uaV9W
	RHAihGuJOm6atbS7rEazgfW1jppIxwk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MyVrd9zj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782499565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hRUa8/NlXmIFhVcnO4ujP3Pr9ZCPz2BLY08nhz5QtEA=;
	b=MyVrd9zjCmgNmakL3DPqubIwuujWS+lu44rciG/sqA3thFiZQ3KgBFkv6NnDCim3dxa44p
	bswqAPYVdHJx7WukwXmTGhOF6jJ3EdrhQpppQB5s5xcTu3lHpfaYGHE+dO41BuWF07e8Ge
	GWsLV+Mv1f/tSWRHoKumUVQiCvugMr0=
Date: Fri, 26 Jun 2026 18:46:02 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Message-ID: <3fbebdd9b59c2fa39cc7c86a2af13e96b95ff0c8@linux.dev>
TLS-Required: No
Subject: [PATCH v5 1/2] mm: drop page refcount zero state semantics
To: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Cc: "Linus Torvalds" <torvalds@linuxfoundation.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, ivgorbunov@me.com, Liam.Howlett@oracle.com,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, foxido@foxido.dev, harry.yoo@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, vbabka@suse.cz, yuzhao@google.com,
 ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
In-Reply-To: <bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev>
References: <bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ABCB5100009
X-Stat-Signature: ek44b1e9ehb57yrjfjasyonm6qen84ox
X-HE-Tag: 1782499567-595366
X-HE-Meta: U2FsdGVkX1/nmAZfePjRk8IvjHdAFzmnehq9HBI+P361s7ytq+VVAUfoOqrBqeH5k+QqrA0WLazjZ9Zdfevd+R8h0LAo8OEjRnH8J/xGA3IeD37icDJUPNRnspwM5kChi0U8oeR5MPhru1QIyVDfiaW+hGeikEhtZ2RJMwG/2U/SXwz7O4Ii6xdZjLAX0kcxsRtx1jm5p6fkaWQyF0938hrfE4VWS7Nlq/ZV7aCkrDwRKuSty13xeflqkHv/6djAZtV97u5/KmUkHhqoKLQ0TXNtQhkd4HNprQaSaSW1ZnrU5xFA5F41LwCIuvprtHn/hGVkDrjEFzE0oet2ArjCpW6YcxnCFDUxiyzG6VwKrJ1GRyE1jUu26BWaLL9gPhNKzY9yjgMJ8fYibxjm7LHPg1mtlpGAgbtd3gpE51Kk2gnGabbXlV41fgLbW0rcpX+Q4EEyDUooN3UDXn4Tdevd5xgUqjtaUjYRED1o0Bp7ohmUsq6qKuN6z3Nj8dtIt3OPXrpLneexr58f55iqYSdd3Su2BoMCYMfS5ApanfMZP0pHUgDlLLtk2f5NoFnIvTI3m2bmHoX8qPvGB35e0iC+PyYTtXYwNrb9+9vtFUybTQsAYiV5kWiFYyw0XqF1UxGBiHe8b3QSct+NhXErANRpu079z/thIGZ1Sx/6lrHq0Sj9Nli9RL7SCZTYyb8KRkv0+jLvKqgeFOoW872n2zwF4mJIyGnILCgs7QSWPXnzeCIN0yFuik1iC8KNqF9Bv9pXbKfhKxIjQB6nxOP2OkaTbm2TbOt5d7fvb2If7eygzAIXj5Ct5RkRsCyhStOEByl8KMUs6E9b1Kj7nb6DdxWJEeonPMZMGiaEOswWHpCkuhnajsfdd/B0X3UuX6Ro8vNOWaN4rnXxV39eIXhKm7ehwHpacWgzV0AM64QpavbAPzzFW1W8ArF5iG2jbRvU9iTQPRgV0jFgLj9hNCB+p/T
 +34MbSJg
 NqqNOYwaGadvbWgnFRURewE5Mu2sWrpJpusybQVwryNud+QmKbAq1mB4UUgLpoozWXE+70iGIsKLy/9ihWSZOhF+H8T1N0hlM31v/Knizhq99X5suH2bxm9CVW4KauDwFSza+nlHWTPhQrSprXlK88yurlPeR4i9LPs7HfADd4X3xgg6wtjV443LI0i4QVKPq3zyg8+Hd8xfor2komC7Bgl+p1/L2N73TjzNCyky3mBg600c03afytY0WWbqZiLKPmSRj6g5SB3dMDS477C5yShDWkNg5VbgpuB8V
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
 drivers/virtio/virtio_mem.c        |  2 +-
 include/linux/mm.h                 |  2 +-
 include/linux/page_ref.h           | 38 ++++++++++++++++++++++++------
 kernel/liveupdate/kexec_handover.c |  6 ++---
 lib/test_hmm.c                     |  4 ++--
 mm/hugetlb.c                       |  2 +-
 mm/internal.h                      |  2 +-
 mm/memremap.c                      |  4 ++--
 mm/mm_init.c                       |  6 ++---
 mm/page_alloc.c                    |  4 ++--
 11 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index b2d5266f8653..fca9a7a7759e 100644
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
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 11c441501582..6abaf984915a 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -1293,7 +1293,7 @@ static void virtio_mem_fake_offline_cancel_offline(=
unsigned long pfn,
 	 * when going offline.
 	 */
 	for (i =3D 0; i < nr_pages; i++)
-		page_ref_inc(pfn_to_page(pfn + i));
+		init_page_count(pfn_to_page(pfn + i));
 }
=20
=20static void virtio_mem_online_page(struct virtio_mem *vm,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..9e87095fd032 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1824,7 +1824,7 @@ static inline int folio_put_testzero(struct folio *=
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
index 9f5c75d06f76..61a2c9b9b73c 100644
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
@@ -119,9 +129,9 @@ static inline void set_page_count(struct page *page, =
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
@@ -133,8 +143,14 @@ static inline void init_page_count(struct page *page=
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
+	VM_WARN_ON_ONCE_PAGE(__page_is_frozen(page), page);
 	atomic_add(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, nr);
@@ -147,6 +163,7 @@ static inline void folio_ref_add(struct folio *folio,=
 int nr)
=20
=20static inline void page_ref_sub(struct page *page, int nr)
 {
+	VM_WARN_ON_ONCE_PAGE(__page_is_frozen(page), page);
 	atomic_sub(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, -nr);
@@ -160,6 +177,7 @@ static inline void folio_ref_sub(struct folio *folio,=
 int nr)
 static inline int folio_ref_sub_return(struct folio *folio, int nr)
 {
 	int ret =3D atomic_sub_return(nr, &folio->_refcount);
+	VM_WARN_ON_ONCE_FOLIO(__page_count_is_frozen(ret + nr), folio);
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_and_return))
 		__page_ref_mod_and_return(&folio->page, -nr, ret);
@@ -168,6 +186,7 @@ static inline int folio_ref_sub_return(struct folio *=
folio, int nr)
=20
=20static inline void page_ref_inc(struct page *page)
 {
+	VM_WARN_ON_ONCE_PAGE(__page_is_frozen(page), page);
 	atomic_inc(&page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, 1);
@@ -180,6 +199,7 @@ static inline void folio_ref_inc(struct folio *folio)
=20
=20static inline void page_ref_dec(struct page *page)
 {
+	VM_WARN_ON_ONCE_PAGE(__page_is_frozen(page), page);
 	atomic_dec(&page->_refcount);
 	if (page_ref_tracepoint_active(page_ref_mod))
 		__page_ref_mod(page, -1);
@@ -193,6 +213,7 @@ static inline void folio_ref_dec(struct folio *folio)
 static inline int page_ref_sub_and_test(struct page *page, int nr)
 {
 	int ret =3D atomic_sub_and_test(nr, &page->_refcount);
+	VM_WARN_ON_ONCE_PAGE(__page_count_is_frozen(ret + nr), page);
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -nr, ret);
@@ -207,6 +228,7 @@ static inline int folio_ref_sub_and_test(struct folio=
 *folio, int nr)
 static inline int page_ref_inc_return(struct page *page)
 {
 	int ret =3D atomic_inc_return(&page->_refcount);
+	VM_WARN_ON_ONCE_PAGE(__page_count_is_frozen(ret - 1), page);
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, 1, ret);
@@ -221,6 +243,7 @@ static inline int folio_ref_inc_return(struct folio *=
folio)
 static inline int page_ref_dec_and_test(struct page *page)
 {
 	int ret =3D atomic_dec_and_test(&page->_refcount);
+	VM_WARN_ON_ONCE_PAGE(__page_count_is_frozen(ret + 1), page);
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -1, ret);
@@ -235,6 +258,7 @@ static inline int folio_ref_dec_and_test(struct folio=
 *folio)
 static inline int page_ref_dec_return(struct page *page)
 {
 	int ret =3D atomic_dec_return(&page->_refcount);
+	VM_WARN_ON_ONCE_PAGE(__page_count_is_frozen(ret + 1), page);
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, -1, ret);
@@ -246,7 +270,7 @@ static inline int folio_ref_dec_return(struct folio *=
folio)
 	return page_ref_dec_return(&folio->page);
 }
=20
-static=20inline bool page_ref_add_unless_zero(struct page *page, int nr)
+static inline bool page_ref_add_unless_frozen(struct page *page, int nr)
 {
 	bool ret =3D atomic_add_unless(&page->_refcount, nr, 0);
=20
@@=20-255,9 +279,9 @@ static inline bool page_ref_add_unless_zero(struct =
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
@@ -273,12 +297,12 @@ static inline bool folio_ref_add_unless_zero(struct=
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
index 4834a809985a..1f2ed4837d60 100644
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
index 9c59d1ceb5b5..a033bf73d6be 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1746,7 +1746,7 @@ static void dmirror_devmem_folio_split(struct folio=
 *head, struct folio *tail)
 	if (tail =3D=3D NULL) {
 		folio_reset_order(rfolio);
 		rfolio->mapping =3D NULL;
-		folio_set_count(rfolio, 1);
+		folio_init_count(rfolio);
 		return;
 	}
=20
@@=20-1760,7 +1760,7 @@ static void dmirror_devmem_folio_split(struct fol=
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
index 571212b80835..622e5fed3d17 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3134,7 +3134,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(=
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
index 181e79f1d6a2..6895c6500805 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -586,7 +586,7 @@ static inline void set_page_refcounted(struct page *p=
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
index 81766d822400..9ffb006bc307 100644
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
index 0f64909e8d20..5b6da9d21dfa 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1043,7 +1043,7 @@ static void __ref __init_zone_device_page(struct pa=
ge *page, unsigned long pfn,
 	case MEMORY_DEVICE_PRIVATE:
 	case MEMORY_DEVICE_COHERENT:
 	case MEMORY_DEVICE_PCI_P2PDMA:
-		set_page_count(page, 0);
+		set_page_count_frozen(page);
 		break;
=20
=20	case MEMORY_DEVICE_GENERIC:
@@ -1096,7 +1096,7 @@ static void __ref memmap_init_compound(struct page =
*head,
=20
=20		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		set_page_count_frozen(page);
 	}
 	prep_compound_head(head, order);
 }
@@ -2227,7 +2227,7 @@ void __init init_cma_reserved_pageblock(struct page=
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
index ee902a468c2f..5db92c51a0d5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1605,14 +1605,14 @@ void __meminit __free_pages_core(struct page *pag=
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

