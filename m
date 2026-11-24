Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84166606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=tT1oFKWS
Received: by kanga.kvack.org (Postfix)
	id 999DE6B06CD; Tue, 24 Nov 2026 08:15:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971716B06CF; Tue, 24 Nov 2026 08:15:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8605E6B06D0; Tue, 24 Nov 2026 08:15:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B49C6B06CD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:15:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C139180B71
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:27 +0000 (UTC)
X-FDA: 85470059094.15.9FB0505
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf28.hostedemail.com (Postfix) with ESMTP id 85481C0004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tT1oFKWS;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf28.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526125;
	b=1VGii4wMSJLnVSOyPRr9fxkhh9WXlEgB9jRaz/O6pCU+vHmlt+yEZNzoLNkLet68K9H1ri
	Xjb/TzR+qUpWaJr8PEIgpIbeUPCjNBGhpryTx1pKMt4GN9U7QjlHzxKZQa8eDGQcQ8BGzD
	WHEAxNugFEOzW2xnoKrV6mT19Vmb7HE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgREQ6GozZUiaFaBbn49VJmR+sfNNw4LA+XKY2boE5g=;
	b=ZURkHQe9l3Uo3zeWlt8ilgMpxesYi+XOmQmUrhxnROmKW4BT3XLluwkjwDIjvi7J7PWwIG
	kt1W7DVRtNTbj2a4sUFaOkeupF1juoLywv0+23P/PHqa/e766D6ZW8xaMOHi+Vbl5jb7DO
	n/zzfjzlpGbfa0ozfgyhasuP4HfGAEE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tT1oFKWS;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf28.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795526125; x=1827062125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LgREQ6GozZUiaFaBbn49VJmR+sfNNw4LA+XKY2boE5g=;
  b=tT1oFKWSv3ncKPSAEEkgn7Gn7aU1wqoVLbghjq2KdZ6cQl/n6mkOfxaI
   NHNp3ou/yOUDC7A5SdZJwFw+JmL3aSs2E0OnSRzb1xyIc5lVfVX5d5w3h
   d8uOGNLn/DQ/knnex48Zd0j36UEN2qBWkhHOMxAeTWaqX5AcgLFCQWrkS
   O2/w2AAs+5C25ks1RJKs2BSDZg4y7v9cdC3rqoXUNaHV5/cu6spuICSJX
   4sx2UoiwraJpLzZRR6U0Kk/2JcZByKI31QUUADeIvNC05Q8uXu1ek4p+9
   Bx4tIZEc3yMIIgbmRAj2pjxDNZ9kF7gqAN7xrWyTEqtfPMek05Ax6YDiY
   g==;
X-CSE-ConnectionGUID: fAp7Ec0TRdaEPqhRmadFUw==
X-CSE-MsgGUID: oMowRQjST8uNiXdvgKQFIA==
X-IronPort-AV: E=Sophos;i="6.27,230,1787011200"; 
   d="scan'208";a="34810235"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 13:15:21 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:16676]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.13.177:2525] with esmtp (Farcaster)
 id f0e75d5b-9b2e-4e73-b2ab-d80ec00b33f2; Tue, 24 Nov 2026 13:15:21 +0000 (UTC)
X-Farcaster-Flow-ID: f0e75d5b-9b2e-4e73-b2ab-d80ec00b33f2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Tue, 24 Nov 2026 13:15:21 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Tue, 24 Nov 2026
 13:15:17 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zi Yan
	<ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v3 1/5] mm: add MMAP_TRACK_PFN action and track_pfn_range() for lazy PFN maps
Date: Tue, 24 Nov 2026 13:15:06 +0000
Message-ID: <20261124131510.38745-2-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124131510.38745-1-farbere@amazon.com>
References: <20261124131510.38745-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: c6ykc1uenu7ga1dikqhnm6in87pj6px5
X-Rspamd-Queue-Id: 85481C0004
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795526125-619516
X-HE-Meta: U2FsdGVkX18/p9aeIwBJdbwRHSAgmi9yYFWZqHBm/+kcA1vZnJpXyfFEU5bUA6+gMEw84phXuT7Edt5mbASY1fs5NsNphoWXPuc/F+Lgkygkf1/Y8NIfg3t+U65n2PArPqxZdO5Zzva/FB44DPuogb96cieLlsTE35DGOENNfYIx6Cif7C/9J3W5M0ESlGISIPqbYJYBjXuGtjef5cZwcddljS3MD+0jXHFkPbKjUYMafNxPRmj4/qEN8ITv0esWHkQY8VOb8KjSQel2To+2zGGcHilmsZEo84WSk95tSmiBzzpvfgd/GnCbf/qV3RybP7i7nbNUMD9KqOD1GBB2/P24Sw4gr+/hz1F2BnU+8xKAWtCzxio4XnOM0Li5tuNtpK5IjqcN1oaTfLsDXacyQ/eIeuIz6Rb022spmykCO2jn7iJR70d/BsPw2psk/Ec7QRVQ2hZ29yCrY0ds0ferfLmr442IREOmOrjxb+O2rwsPCeWy5LPdvGtYPbXEX98bjtF14IwPst8UAHYRO5EPjSH8OjzPrQeWv96dr1yA98paGIujoG2QzJYKg0xjic4GYTeZjfaktrzTPAhOpcU5EZBAlmRjgwUE39sVqhJmdjqcTpn8IS/puKva+AukIA5UMKBt8FrGglFTyvzQKmdl3ywWoNlEJAXVTF1pX9TuQ1PZU3Y+8lg/0ddbNQr0/ZPzt+Vyn4LHTFXOH20l8EcJn/Ze3qkVCqvhiqGwToDNCsZ/GVpLqyhNfbh73/ag534K6O+iDN4hLu37vmCiEaCgVHnPnvYzofx2RrOJlU06uc5+AyVAUxvAPw3BeLEjf3MvzxBaiBQwEAhaR90a0xdcVV4q2bcYlFxOQUTkU4/zIEr2qhhUfRShFhjce0Q2Rzq/vnY6+7SlHsRbdUV3sSKNYvIeNlu6RRgReNxb4qne/IGx2MwfToP91atMEP8n1kw512qCejTFX3zWvU1q8mo
 R85gR1+0
 PzkiSj66U/PXHqmULflkYgXy1wrHMoZhbCxlJRu/j1tTSMzMSWvd0lLr6DyVKScGeirrNvfXIe078zGijPlqVl1eXpuBOehRvOhhREvoIZAP+vI5nM3ua4UQ6PXx69isddaP3XB3P//zF/D0BUO7GoTSHOaaTDvdHXBHytKSA+JCrZpCqWCRHOr9VYbIVAVV98ZZeqxWx3W9r9T1kVOdyFDagcB+uGoxKIwf0aGN+IJ5lIevLfNP6uS0rT+WLZ9M0KkdiYmZvcDvzp1SGEXHkXDMv+G//jkccvg0YpOkfVIz2Aa1zoVaNLubSCCgqICBrrCONoK2welZKuNNCWEeyrfdLhUcR/0xigahg6KO0B9aliJ0ZuZniLAKfgIYC/Qv078W8m1EDYjtLrtB5icQK20i7bE8aj2Rz9H8Wg4xsk9pz65VZHBNdFv0bXf47t1Rd9c8heQaF/BfbB7Iwt7TBarlm3rRRFQt/je7CMH3bq69sIYopjwBpf1Ctb3JLLOShmLrsoJsou1TR/VDMOolPPCj0k2FHCLKN7RryN2hmJbwVowJV08AEm30mjM9aI3CtV+SY+Ij+v/Ukswo21qwkTe6ZtqKsDbt6MqG3blPeJBY4iVdTy1jotik6Loih1Q40SmDz+loBNIujOO771ZpJ5XoA/nS5g2XwZwLX7cRX01AQsznmx8sQizP0aI2dHkrGQwPJOL/dUzRMdunJsIpsfmHxFcwf7ZR1xY7CU0GkPY8t5fpdO0cvpBK5WKuskQodT0PwiQDnW0VhO4vI8PawWK9MYh8j3pTJXomMPDyaceZdhI4HO0m6abxm3ROjUTN7w/7EzhNr0AVBGTuU3gtp0xl02NfXBolsSsbba9iqELKv7yqfN8oXUEwSrJE90XsEdBWNwvBKCdSaQYzpITI6YuTA5hLRlC5Nm0T6Af2WHDkXHWOBCc5qyltDOHT/SupIOw31pIW/pNkU8Euw9FbqPasOsrZL
 mPLOd8Fl
 UteveUhgOgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

remap_pfn_range() populates a PFN mapping and, on x86, reserves the
range's memory type, so a later conflicting mapping of the same range is
rejected or coerced. A driver that populates from a fault handler gets no
such reservation: vmf_insert_pfn() and friends only look the memory type
up, so a conflict goes undetected.

Add track_pfn_range(). It sets the VMA flags remap_pfn_range() would set
and reserves the whole VMA's PFN range for its lifetime, but populates
nothing: that is left to the caller's fault handler. COW mappings are
rejected, as vmf_insert_pfn*() cannot populate them.

For drivers that use ->mmap_prepare, where no VMA exists yet, add an
MMAP_TRACK_PFN action that describes the range as MMAP_REMAP_PFN does and
tracks it on completion. It must cover the whole VMA, as that is what
gets reserved.

The /dev/mem and UIO handlers later in this series are the first users.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---

Changes in v3:
- Renamed pfn_range_track() to track_pfn_range(), and MMAP_PFN_TRACK to
  MMAP_TRACK_PFN, to read like remap_pfn_range() and MMAP_REMAP_PFN.
- Dropped the addr and size arguments. The range is always the whole VMA.

 include/linux/mm.h              | 16 +++++++
 include/linux/mm_types.h        |  1 +
 mm/internal.h                   |  3 ++
 mm/memory.c                     | 80 +++++++++++++++++++++++++++++++++
 mm/util.c                       |  7 +++
 tools/testing/vma/include/dup.h |  1 +
 6 files changed, 108 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 040cff64381b..cab58a403a3d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4814,6 +4814,21 @@ static inline void mmap_action_ioremap_full(struct vm_area_desc *desc,
 	mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(desc));
 }
 
+/**
+ * mmap_action_track_pfn - helper for mmap_prepare hook to specify that the PFN
+ * range backing the entirety of a VMA should be tracked, but not mapped.
+ * @desc: The VMA descriptor for the VMA.
+ * @start_pfn: The first PFN in the range.
+ *
+ * Population is left to the driver's fault handler. Not for COW mappings.
+ */
+static inline void mmap_action_track_pfn(struct vm_area_desc *desc,
+					 unsigned long start_pfn)
+{
+	mmap_action_remap_full(desc, start_pfn);
+	desc->action.type = MMAP_TRACK_PFN;
+}
+
 /**
  * mmap_action_simple_ioremap - helper for mmap_prepare hook to specify that the
  * physical range in [start_phys_addr, start_phys_addr + size) should be I/O
@@ -5035,6 +5050,7 @@ struct vm_area_struct *find_extend_vma_locked(struct mm_struct *,
 		unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		    unsigned long pfn, unsigned long size, pgprot_t pgprot);
+int track_pfn_range(struct vm_area_struct *vma, unsigned long pfn);
 
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ed35d258d2e..f9f1866ad772 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -821,6 +821,7 @@ enum mmap_action_type {
 	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
 	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
 	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+	MMAP_TRACK_PFN,			/* Track PFN range, map on fault. */
 };
 
 enum discontig_kernel_page_action {
diff --git a/mm/internal.h b/mm/internal.h
index 85cf7becf858..5a599402c57d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1548,6 +1548,9 @@ int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
+int track_pfn_range_prepare(struct vm_area_desc *desc);
+int track_pfn_range_complete(struct vm_area_struct *vma,
+			     struct mmap_action *action);
 int simple_ioremap_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_complete(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index 7f019afc35ca..3d5706f8a7bf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3439,6 +3439,86 @@ int remap_pfn_range_complete(struct vm_area_struct *vma,
 	return do_remap_pfn_range(vma, start, pfn, size, prot);
 }
 
+#ifdef __HAVE_PFNMAP_TRACKING
+static int do_track_pfn_range(struct vm_area_struct *vma, unsigned long pfn)
+{
+	const unsigned long size = vma->vm_end - vma->vm_start;
+	struct pfnmap_track_ctx *ctx;
+
+	if (vma->pfnmap_track_ctx)
+		return -EINVAL;
+
+	ctx = pfnmap_track_ctx_alloc(pfn, size, &vma->vm_page_prot);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	vma->pfnmap_track_ctx = ctx;
+	return 0;
+}
+#else
+static int do_track_pfn_range(struct vm_area_struct *vma, unsigned long pfn)
+{
+	return 0;
+}
+#endif
+
+/**
+ * track_pfn_range - reserve a VMA's PFN range without populating it
+ * @vma: user vma to track the range for
+ * @pfn: page frame number at vma->vm_start
+ *
+ * Sets the VMA flags remap_pfn_range() would set and reserves the memory type
+ * of the whole VMA's PFN range for its lifetime. Creates no page table
+ * entries: the caller's fault handler populates the range, and must not map
+ * outside it.
+ *
+ * vma cannot be a COW mapping.
+ *
+ * Note: this is only safe if the mmap lock is held for writing when called.
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+int track_pfn_range(struct vm_area_struct *vma, unsigned long pfn)
+{
+	int err;
+
+	if (vma_is_cow_mapping(vma))
+		return -EINVAL;
+
+	err = remap_pfn_range_prepare_vma(vma, vma->vm_start, pfn,
+					  vma->vm_end - vma->vm_start);
+	if (err)
+		return err;
+
+	return do_track_pfn_range(vma, pfn);
+}
+EXPORT_SYMBOL_GPL(track_pfn_range);
+
+int track_pfn_range_prepare(struct vm_area_desc *desc)
+{
+	const struct mmap_action *action = &desc->action;
+
+	/* COW mappings cannot be populated on fault */
+	if (vma_desc_is_cow_mapping(desc))
+		return -EINVAL;
+
+	/* do_track_pfn_range() anchors start_pfn at the VMA start */
+	if (action->remap.start != desc->start)
+		return -EINVAL;
+
+	/* do_track_pfn_range() reserves the whole VMA, so the action must */
+	if (action->remap.size != vma_desc_size(desc))
+		return -EINVAL;
+
+	return remap_pfn_range_prepare(desc);
+}
+
+int track_pfn_range_complete(struct vm_area_struct *vma,
+			     struct mmap_action *action)
+{
+	return do_track_pfn_range(vma, action->remap.start_pfn);
+}
+
 static int __simple_ioremap_prep(unsigned long vm_len, pgoff_t vm_pgoff,
 				 phys_addr_t start_phys, unsigned long size,
 				 unsigned long *pfnp)
diff --git a/mm/util.c b/mm/util.c
index 80f6c714844f..5fad246b7a58 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1554,6 +1554,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return map_kernel_pages_prepare(desc);
 	case MMAP_DISCONTIG_KERNEL_PAGES:
 		return map_discontig_kernel_pages_prepare(desc);
+	case MMAP_TRACK_PFN:
+		return track_pfn_range_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1589,6 +1591,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_DISCONTIG_KERNEL_PAGES:
 		err = map_discontig_kernel_pages_complete(vma, action);
 		break;
+	case MMAP_TRACK_PFN:
+		err = track_pfn_range_complete(vma, action);
+		break;
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
@@ -1611,6 +1616,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
 	case MMAP_DISCONTIG_KERNEL_PAGES:
+	case MMAP_TRACK_PFN:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1633,6 +1639,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
 	case MMAP_DISCONTIG_KERNEL_PAGES:
+	case MMAP_TRACK_PFN:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index dc4927d26296..1bbcb92ab5a6 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -455,6 +455,7 @@ enum mmap_action_type {
 	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
 	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
 	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+	MMAP_TRACK_PFN,			/* Track PFN range, map on fault. */
 };
 
 /*
-- 
2.47.3


