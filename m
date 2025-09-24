Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475FBCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE8C8E0026; Wed, 24 Sep 2025 11:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABC48E0025; Wed, 24 Sep 2025 11:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC118E0026; Wed, 24 Sep 2025 11:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6168E0025
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:11:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 912061408AC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:11:42 +0000 (UTC)
X-FDA: 83924483244.06.6ACC346
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5875114000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:11:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=lmu.de header.s=lm-postout21 header.b="a TWQsAl";
	spf=pass (imf23.hostedemail.com: domain of patrick.roy@campus.lmu.de designates 129.187.255.138 as permitted sender) smtp.mailfrom=patrick.roy@campus.lmu.de;
	dmarc=pass (policy=none) header.from=lmu.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5H/qTs1nudTxJ8yEOOcf+EAL5JPehCIC+Q0Q8OSONs=;
	b=OY5ROmBsYo8oIw+NHgAuUTWGdWma4AZ2p53VPIUvmFWmVBfVb0gGpPzkO4CdcKesoobl32
	KOTciLV0OfiUFNA/Fknz0NeUcd3iOeRWmsUvdKevi/LzON7tnwPmXGkqwB/wl8/gxvHXlc
	Hs1hXciEyT5y6CrjLH8lWet65AF6OZM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=lmu.de header.s=lm-postout21 header.b="a TWQsAl";
	spf=pass (imf23.hostedemail.com: domain of patrick.roy@campus.lmu.de designates 129.187.255.138 as permitted sender) smtp.mailfrom=patrick.roy@campus.lmu.de;
	dmarc=pass (policy=none) header.from=lmu.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726700; a=rsa-sha256;
	cv=none;
	b=SJP67JozC2o7y9f308VU4ey6S8yr8LqfjihYYw4iWJqp9wHMeNANvIoZ//veTSRftdkueN
	mV6KtnuRmq0qi5gC/XlDJopE/8mAQrQyeTE0It5YzMbPQ3If3RADeZ3FijFyLRwaAasiTE
	MB0JjvigXxWU3c+vcqmTi4THNp+R15w=
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4cX0gG6bRKzyY6;
	Wed, 24 Sep 2025 17:11:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lmu.de; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=lm-postout21; i=@campus.lmu.de; t=
	1758726698; bh=s5H/qTs1nudTxJ8yEOOcf+EAL5JPehCIC+Q0Q8OSONs=; b=a
	TWQsAlgrNglgs+ZOzs4A4g3yP0NbZA7xa7yJv1dQrtCrmPNR9oe2aPrP6n60uNyz
	vdQKVtijKBOYPzJT4+4Eo1DeQGbmsib9LAJV8wIs4tZ3KA2jSK4w4sFOj4l7n92L
	u4a34OujTQ0mUce9GnvVHv1Ju36UkjWAKtgGKmpdW1l48yBqv0jEkk0rqaob9iIz
	Sd78DABKFMX2EhqblYSrO4tQQknZK7fBslY6F0D5ytFZk7xhWJ6UdwpdDHdpsHnS
	LDfgecg4WG/t8ScywH3/ceR5IxRldot3Nfpj3JMQxHR54hahUTary03F315z2Dsu
	QooZMSxMtaenvG8URuc5A==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id qNGZltS5ra0v; Wed, 24 Sep 2025 17:11:38 +0200 (CEST)
Received: from spacestation.cable.virginm.net (oxfd-27-b2-v4wan-164230-cust474.vm42.cable.virginm.net [86.22.133.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4cX0gC06QHzyXY;
	Wed, 24 Sep 2025 17:11:34 +0200 (CEST)
From: Patrick Roy <patrick.roy@campus.lmu.de>
To: 
Cc: Patrick Roy <roypat@amazon.co.uk>,
	pbonzini@redhat.com,
	corbet@lwn.net,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	song@kernel.org,
	jolsa@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	jannh@google.com,
	pfalcato@suse.de,
	shuah@kernel.org,
	seanjc@google.com,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	xmarcalx@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.co.uk,
	derekmn@amazon.co.uk,
	tabba@google.com,
	ackerleytng@google.com
Subject: [PATCH v7 03/12] mm: introduce AS_NO_DIRECT_MAP
Date: Wed, 24 Sep 2025 16:10:43 +0100
Message-ID: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5875114000B
X-Stat-Signature: q9aoggxs4z4z4cdwejrchz4akruwgc55
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758726700-71167
X-HE-Meta: U2FsdGVkX19U3JKltK660F+39yIvgnvqgltM3s9Mjc86GunRnue7pLb0NzEYX1ClYGLOAZ/ZtxVTgN4Kc/kwO/xBnpT9z3f7oGnjF/7dxIO6/sG/0FDuU8LcVu3I9AcuVchyVxUOw1tucb9Vd4+LQK7oLgy76memrZFOVogbM4tUEsgYze6UuRhO7M8UdNwoisBdMTrKukDX6dgKeW5eCdXnAsrARQ9wvZ+vgiXIZuY66ya0uPtX+IIfLrVc8/GVhgsutyOtF00Mf6jSqEJVhLxdKkDP3YlsvSctWG76j7SEF7bJ+1t5LY+hsdyzBQvZpZcyWEfXiNWN9KTGuR/H5AFEw9P2oo2TDLBeeMA8a73Ydj/JI34+1DT+UkBuf+f8p/7QGZMaXU5kLd4s/hpAfU1AiDiJUfi+F9f/J0L8D60FGiIt6AURmlllRf/XO9/7QeKR1PhOgBZxxJjesx2nbfgGd95Gyrt2rRyN7u0PKICIRWZTcwkAqPmCmNyIjT+OL+bu4PHUnOhYGJdRa/aj0qljIfJgv2E5PcDebLGUiroGSeLmLCaD69siGqZC0vvcShj9mIzli/TQs/4ngfq+MgcZea29zxJjOgAQFO2PAlji5VqlRycLzvN3/THKqJsjymUv176lT0ZSVebW8h22/zbM89vsfAVyX91oj/FnR5Ru+GiSZiy8CDDXzfAYVX7PH0Av5Pxg5NQxI3jdF05Jhgc/esyq/dohxHCj1/ngG7DEyZriHHYijQECqxrJkCk52ZYQwhw+8gXpXRjzNcH/4ydf4cbzb8MgXFXR1wayIYgxZIGyq6vuBwPv+abExxKF2FL0rZo3Y/mfrZpSAIQW+e6crwjJN8BWVd0P4F3JAZd9GM8FHMxYDbKBa5CPRI+AAq1zx9yoP2g03EQxO1ryJORqi3usdWgqDEB3hIGK79dLBqL+Mk2y8izNjm+aI1QUmUAk1vGP2NhQ7BU7w8K
 3e2H1KrX
 G/PXx6+Qwb/KChbwS1dsiUbN9YzopQfKhKdEB/Q4+Nmj1L4e7AIe6oiDElhutd71tE5Xz+APxwLpVMHrl0od4dzKaWLqr43zdWtGrlqy8oEhA6dZOVGnMZj4bLzf8xFFaZ04ypn7tFYGyYmvvKYO0/l52Mb0I/LcizTmcOtgNjx75Vvwd+e9JH8QhH87ZEEQ4FBP7HyNXm1QvnprqO/nGC1/0UrAywVmRzib3prlVAlmnaRXdI43QUqUkkkjTEoilDbNSPAG2+G1FGwJzDMZgaPEiJ+4w17/wscSR/0V3LmBhAx4l5+ODG8sBFx/pyX7H07l95mt1wsfGRFpGKT/MvG1Oz8MpJJms11FW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <roypat@amazon.co.uk>

Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
set to not present . Currently, mappings that match this description are
secretmem mappings (memfd_secret()). Later, some guest_memfd
configurations will also fall into this category.

Reject this new type of mappings in all locations that currently reject
secretmem mappings, on the assumption that if secretmem mappings are
rejected somewhere, it is precisely because of an inability to deal with
folios without direct map entries, and then make memfd_secret() use
AS_NO_DIRECT_MAP on its address_space to drop its special
vma_is_secretmem()/secretmem_mapping() checks.

This drops a optimization in gup_fast_folio_allowed() where
secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
by default"), so the secretmem check did not actually end up elided in
most cases anymore anyway.

Use a new flag instead of overloading AS_INACCESSIBLE (which is already
set by guest_memfd) because not all guest_memfd mappings will end up
being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
can be mapped to userspace should also be GUP-able, and generally not
have restrictions on who can access it).

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/linux/pagemap.h   | 16 ++++++++++++++++
 include/linux/secretmem.h | 18 ------------------
 lib/buildid.c             |  4 ++--
 mm/gup.c                  | 19 +++++--------------
 mm/mlock.c                |  2 +-
 mm/secretmem.c            |  8 ++------
 6 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 12a12dae727d..1f5739f6a9f5 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -211,6 +211,7 @@ enum mapping_flags {
 				   folio contents */
 	AS_INACCESSIBLE = 8,	/* Do not attempt direct R/W access to the mapping */
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
+	AS_NO_DIRECT_MAP = 10,	/* Folios in the mapping are not in the direct map */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline void mapping_set_no_direct_map(struct address_space *mapping)
+{
+	set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
+}
+
+static inline bool mapping_no_direct_map(const struct address_space *mapping)
+{
+	return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
+}
+
+static inline bool vma_has_no_direct_map(const struct vm_area_struct *vma)
+{
+	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
+}
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return mapping->gfp_mask;
diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
index e918f96881f5..0ae1fb057b3d 100644
--- a/include/linux/secretmem.h
+++ b/include/linux/secretmem.h
@@ -4,28 +4,10 @@
 
 #ifdef CONFIG_SECRETMEM
 
-extern const struct address_space_operations secretmem_aops;
-
-static inline bool secretmem_mapping(struct address_space *mapping)
-{
-	return mapping->a_ops == &secretmem_aops;
-}
-
-bool vma_is_secretmem(struct vm_area_struct *vma);
 bool secretmem_active(void);
 
 #else
 
-static inline bool vma_is_secretmem(struct vm_area_struct *vma)
-{
-	return false;
-}
-
-static inline bool secretmem_mapping(struct address_space *mapping)
-{
-	return false;
-}
-
 static inline bool secretmem_active(void)
 {
 	return false;
diff --git a/lib/buildid.c b/lib/buildid.c
index c4b0f376fb34..89e567954284 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -65,8 +65,8 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
 
 	freader_put_folio(r);
 
-	/* reject secretmem folios created with memfd_secret() */
-	if (secretmem_mapping(r->file->f_mapping))
+	/* reject folios without direct map entries (e.g. from memfd_secret() or guest_memfd()) */
+	if (mapping_no_direct_map(r->file->f_mapping))
 		return -EFAULT;
 
 	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
diff --git a/mm/gup.c b/mm/gup.c
index adffe663594d..75a0cffdf37d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -11,7 +11,6 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
-#include <linux/secretmem.h>
 
 #include <linux/sched/signal.h>
 #include <linux/rwsem.h>
@@ -1234,7 +1233,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
 		return -EOPNOTSUPP;
 
-	if (vma_is_secretmem(vma))
+	if (vma_has_no_direct_map(vma))
 		return -EFAULT;
 
 	if (write) {
@@ -2736,7 +2735,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  * This call assumes the caller has pinned the folio, that the lowest page table
  * level still points to this folio, and that interrupts have been disabled.
  *
- * GUP-fast must reject all secretmem folios.
+ * GUP-fast must reject all folios without direct map entries (such as secretmem).
  *
  * Writing to pinned file-backed dirty tracked folios is inherently problematic
  * (see comment describing the writable_file_mapping_allowed() function). We
@@ -2751,7 +2750,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 {
 	bool reject_file_backed = false;
 	struct address_space *mapping;
-	bool check_secretmem = false;
 	unsigned long mapping_flags;
 
 	/*
@@ -2763,18 +2761,10 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 		reject_file_backed = true;
 
 	/* We hold a folio reference, so we can safely access folio fields. */
-
-	/* secretmem folios are always order-0 folios. */
-	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
-		check_secretmem = true;
-
-	if (!reject_file_backed && !check_secretmem)
-		return true;
-
 	if (WARN_ON_ONCE(folio_test_slab(folio)))
 		return false;
 
-	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
+	/* hugetlb neither requires dirty-tracking nor can be without direct map. */
 	if (folio_test_hugetlb(folio))
 		return true;
 
@@ -2812,8 +2802,9 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 	 * At this point, we know the mapping is non-null and points to an
 	 * address_space object.
 	 */
-	if (check_secretmem && secretmem_mapping(mapping))
+	if (mapping_no_direct_map(mapping))
 		return false;
+
 	/* The only remaining allowed file system is shmem. */
 	return !reject_file_backed || shmem_mapping(mapping);
 }
diff --git a/mm/mlock.c b/mm/mlock.c
index a1d93ad33c6d..36f5e70faeb0 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
+	    vma_is_dax(vma) || vma_has_no_direct_map(vma) || (oldflags & VM_DROPPABLE))
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 60137305bc20..f4d767c3fe2e 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -134,11 +134,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc *desc)
 	return 0;
 }
 
-bool vma_is_secretmem(struct vm_area_struct *vma)
-{
-	return vma->vm_ops == &secretmem_vm_ops;
-}
-
 static const struct file_operations secretmem_fops = {
 	.release	= secretmem_release,
 	.mmap_prepare	= secretmem_mmap_prepare,
@@ -156,7 +151,7 @@ static void secretmem_free_folio(struct folio *folio)
 	folio_zero_segment(folio, 0, folio_size(folio));
 }
 
-const struct address_space_operations secretmem_aops = {
+static const struct address_space_operations secretmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
 	.free_folio	= secretmem_free_folio,
 	.migrate_folio	= secretmem_migrate_folio,
@@ -205,6 +200,7 @@ static struct file *secretmem_file_create(unsigned long flags)
 
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_unevictable(inode->i_mapping);
+	mapping_set_no_direct_map(inode->i_mapping);
 
 	inode->i_op = &secretmem_iops;
 	inode->i_mapping->a_ops = &secretmem_aops;
-- 
2.51.0


