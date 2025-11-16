Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB46CEB2F1
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 01:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE038E002B; Sat, 15 Nov 2025 20:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FD08E0005; Sat, 15 Nov 2025 20:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5008E002B; Sat, 15 Nov 2025 20:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09CEF8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 20:32:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC2BD1A0875
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:32:31 +0000 (UTC)
X-FDA: 84114745302.11.A691066
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id C673180017
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:32:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CE6nKo7C;
	spf=pass (imf02.hostedemail.com: domain of 3rCkZaQgKCLMcbTjbrTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3rCkZaQgKCLMcbTjbrTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763256749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mElrZvr1lPvE5jRSiZCRKZJSkzr/cE95z8Xvj1TadVk=;
	b=C2OB/CmWAIn9BySJCF+ezz6zXl6Hvwh/1OPrOh8JJh/bq8y0U38mqbpp/AJu8yNUlnpXZw
	tby9CaS+aWTbOx5IDU+tiSdXKhsG6c2I4CgRnD/xgOW3N3nRJ7TMEFMqYSZ0PhskeUpOT8
	p93pDjvX+BwdGcwg/BYgG4Seq+yZgbI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CE6nKo7C;
	spf=pass (imf02.hostedemail.com: domain of 3rCkZaQgKCLMcbTjbrTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3rCkZaQgKCLMcbTjbrTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763256749; a=rsa-sha256;
	cv=none;
	b=K+kFrjhPzvB9+iFYGY4C+pEB3BtAwBJ+KEumPg7fLUX8gPULZrcwofCmHswfDSBCBb6/k9
	VWlbrk7ijKtuH28uuf1e6HxHLA70g7yepxJmGGk+cciFEKx/oS9R5+ORQ7g8ehHEEJnpZq
	Ee5524rRnhrDYJPsxLB9hoIgs65oTKc=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29848363458so85924315ad.2
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763256749; x=1763861549; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mElrZvr1lPvE5jRSiZCRKZJSkzr/cE95z8Xvj1TadVk=;
        b=CE6nKo7C25X2ayHALxwPQK3FExq8NyNFLNS9tyEKsbhhmG+hZY/3Oy3m3jcfwhcrCo
         W7Zx6hzta0FZ6Mje22znthRYXlXuAZNYAfb9BZFIQAAi802hLO/slE4/AWkwuWfLwIbo
         FPahFrMa4rEbM1bokQQZcwbdSnisu+JTlSFB1dW+WCeIca6b3mLExxHIngC3sAXFrVV3
         JtOF97eJZyTnV/i3mgr0s2MnUWTEphU41PPG6HFmyFsmEmRCgb3zPIQyBue/xX0AgPUL
         xtgVbJMUiE2zVHT/7Ro8JquHwagI62uSJ7J/ioX4Z6vlwEns6+qp3IU627BjqJJN5iM7
         y0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763256749; x=1763861549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mElrZvr1lPvE5jRSiZCRKZJSkzr/cE95z8Xvj1TadVk=;
        b=Q59qn0tss5cNlOsulDjA6CNWX1cTajUC7pTjr1VNnlSkoKEoRJtDT28LDTajbDr5RY
         zwpzo5OJvGB/FDOY+A2ecVDsrYluhV1MXlcfcyWiDazHxZsqyAvkwORP7eRs43e9x8eL
         5MVZzgH+fZiAgtk1OsushD4JSfqUjqfdAtqtc5SvstvJm2fbkNLamwWFeq3oBMLHeUh9
         Qm82dIiwzUMpoXSqr6iNji7sESXtLns3tDoYyWSYjiGij72srx1Q1HOrd2o48FsNtyFq
         BiZLcJ63fJmoNB6tAFaVIZdc+qVDJoZb5jsdtn6aLrHhws5fTubsSgyYwM3kndoVVG8V
         UICA==
X-Forwarded-Encrypted: i=1; AJvYcCXzpCL09g/CoMpQRF6Rb0O73ABFvvHAnN7x3oAHrn7ciEW9iS5eW/NpE/64n68XGyMUHXf+YzrP4w==@kvack.org
X-Gm-Message-State: AOJu0YzASAZf9/lclBk2++puyS5+7dIH6ujbzMlv9cNLuXfDF/LihNm2
	pj45OCkjvjPO6p9IFeLTIIEWY+WtOAIiKmQK/oaPAVt8iREkp4zOo3FO/Azo9vnk6NEBcMYLmqE
	bMIaq2yGC9wjY1Q==
X-Google-Smtp-Source: AGHT+IHThMFUlqIR4nChA4BeB+xjZT0svLZVl/slvnZxtVlkEzUE+EHf2m7blg154xsjtpLJ/eetJxZRW2H4Gg==
X-Received: from plrc9.prod.google.com ([2002:a17:902:aa49:b0:297:eca4:1a62])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f705:b0:295:9871:81dd with SMTP id d9443c01a7336-2986a6f3f40mr92140665ad.25.1763256748692;
 Sat, 15 Nov 2025 17:32:28 -0800 (PST)
Date: Sun, 16 Nov 2025 01:32:21 +0000
In-Reply-To: <20251116013223.1557158-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20251116013223.1557158-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251116013223.1557158-2-jiaqiyan@google.com>
Subject: [PATCH v2 1/3] mm: memfd/hugetlb: introduce memfd-based userspace MFR policy
From: Jiaqi Yan <jiaqiyan@google.com>
To: nao.horiguchi@gmail.com, linmiaohe@huawei.com, william.roche@oracle.com, 
	harry.yoo@oracle.com
Cc: tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C673180017
X-Stat-Signature: x4mig7uorswjfi1nr963rm6bo3p5gxbc
X-Rspam-User: 
X-HE-Tag: 1763256749-656494
X-HE-Meta: U2FsdGVkX19hPKYkhLIMrYSttmlUFZGhYLccCClgt/DMgEV/Hm2O6N8tSPixJZokEukrVY7IbNsvRmVvxjf/Q+TzCHnBqLEIIEfwdz/xqICKvIt/3is5BfSt9vM37q11fQ4ceiTHz9O9O4qtnWmiw31dlfv4Cz/octuIlR2hdN3VoPB891JVgN9MwrpjKSRI7bmDiLkMWLBSMlgc+t1cw5z9rg9eDQ9Ge9JpN3EAyS9XYEqQU6mJplvH2tWQT0ENHZpqQf67QPP2ds0gT7JA5w6RB1mZeBTDDNLAjx6wm3FCmhlOiKa+IC3hYRm/n3xY6w8FgQiiSQk4qm49t1qybRkmx/ajQJC5BbegwdNsqT/PowGl/DzX//v/fU85SSx7QymvDTAi+BLa0wtoD7Iwh/IzWNoQLn/k3bQ78yaZI7CPg/W5f3eyLk/S0TpgqZ8wqMFAqWlvXBYzraZwi302kZ956RQ+vmIJ8qYW/8BeRVQO6pk1EOqe59xDoVYIiV97Q70MKHJuXXmjS0v8NEZgJHujKWV1MTlRdPuoMvbEO3cc3FM+DpjgLD9DTLsILcGZZ+muRcZGXL/dnamgXQyOcRC75TaXEhT9B+2K1zimEfL+zDDccyrIrhKYw2GkN+H6P8Sadbrnxc2CON4EQQgM6IcoEoF0G1EpEbJe0VLHKsRd6wum79JvPpr48he+2bu4MX7/Wrj4j1bxzOXuoeuWYkl2y0FHGw1ll7uAewoD/wUsqcLKDa+V1Ayx8THJuLVPKl62or5hhsv8YH5ve8xDEuBzmfnUALVbbsaKqF5BNbFO/w77Owfh08Oe4fcRL7ikPN4KPsTc6Bx+M96X0NF04VMEAXwWo37JPXhFZphpg4xXHxmhGGep/sMX4hXXwmk1MvtYY2I8Mskd6Z+d0cgm81kVVRoMZEJsnlxwoCLfuz6eBiOXGE67987Dz7cnmS7MfH6UwRcqT3JrXoPrbBA
 jdASzNsH
 vAhKZswi/8dHL/Vf8RzJWh3b4bveDOehTUp9kJXCis5he2582q+iSKZevh8h/dE28xV/2tPiSK3UVBZxnx6zQ3gJNuVw4ic1ZMrfTyB0GgJ7oucy32TlRZnvkVwRQ8wWWfJZURmmbXIPbPoI3ebZ97AvX1kPiQsIj1d3Jq/d0oD6oq2LZTc13pBmcguP+H04JsbEi1ws/5YeP1pbkrSJ+e3qWDhUxx+C2RH8X4wpjEOCdaRH3TzVzleI3OhdXNQB8ZpL7EoYfhpzpzzNFPeyFHrAcx0FSAMyxOx7VDMRgevUIkA7dNvE2+ReLsBPCgJTgLVm/2QrSNt5ONzGvmazv3D0cx9eNv43/IQa5o69IZOFPKuuIA07Fq7IgP6HG+x3Mrz45TpL72kBsmb6oSSvM9A7KkvNgKi1wQtPXMvY2kUQ7zboxlimBzOnVrbKumcunSVNQEp3aXouu3DYgPPtblvN3o2+SlM1TK0pN74uyFJO7u1Q19lZvUHWfYBxPMBcLJYhY+bTVF2W7MKTbhlC31Ybk0pxhC1ZrcvXO/yqGdlm40U6eTgq2h264J/iiHTlg1Z2l9PwbeWPAbD9ZTZkZZQ4THUibdLbCTXCvb9IzNdV0urTh8UyexIJvCVdQ0MJhvErwWPEqKb2o097bJxx7PAf/pA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes immediately hard offlining a large chunk of contigous memory
having uncorrected memory errors (UE) may not be the best option.
Cloud providers usually serve capacity- and performance-critical guest
memory with 1G HugeTLB hugepages, as this significantly reduces the
overhead associated with managing page tables and TLB misses. However,
for today's HugeTLB system, once a byte of memory in a hugepage is
hardware corrupted, the kernel discards the whole hugepage, including
the healthy portion. Customer workload running in the VM can hardly
recover from such a great loss of memory.

Therefore keeping or discarding a large chunk of contiguous memory
owned by userspace (particularly to serve guest memory) due to
recoverable UE may better be controlled by userspace process
that owns the memory, e.g. VMM in Cloud environment.

Introduce a memfd-based userspace memory failure (MFR) policy,
MFD_MF_KEEP_UE_MAPPED. It is intended to be supported for other memfd,
but the current implementation only covers HugeTLB.

For any hugepage associated with the MFD_MF_KEEP_UE_MAPPED enabled memfd,
whenever it runs into a UE, MFR doesn't hard offline the HWPoison-ed
huge folio. IOW the HWPoison-ed memory remains accessible via the memory
mapping created with that memfd. MFR still sends SIGBUS to the process
as required. MFR also still maintains HWPoison metadata for the hugepage
having the UE.

A HWPoison-ed hugepage will be immediately isolated and prevented from
future allocation once userspace truncates it via the memfd, or the
owning memfd is closed.

By default MFD_MF_KEEP_UE_MAPPED is not set, and MFR hard offlines
hugepages having UEs.

Tested with selftest in the follow-up commit.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Tested-by: William Roche <william.roche@oracle.com>
---
 fs/hugetlbfs/inode.c       |  25 +++++++-
 include/linux/hugetlb.h    |   7 +++
 include/linux/pagemap.h    |  24 +++++++
 include/uapi/linux/memfd.h |   6 ++
 mm/hugetlb.c               |  20 +++++-
 mm/memfd.c                 |  15 ++++-
 mm/memory-failure.c        | 124 +++++++++++++++++++++++++++++++++----
 7 files changed, 202 insertions(+), 19 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index f42548ee9083c..f8a5aa091d51d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -532,6 +532,18 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	}
 
 	folio_unlock(folio);
+
+	/*
+	 * There may be pending HWPoison-ed folios when a memfd is being
+	 * removed or part of it is being truncated.
+	 *
+	 * HugeTLBFS' error_remove_folio keeps the HWPoison-ed folios in
+	 * page cache until mm wants to drop the folio at the end of the
+	 * of the filemap. At this point, if memory failure was delayed
+	 * by MFD_MF_KEEP_UE_MAPPED in the past, we can now deal with it.
+	 */
+	filemap_offline_hwpoison_folio(mapping, folio);
+
 	return ret;
 }
 
@@ -563,13 +575,13 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 	const pgoff_t end = lend >> PAGE_SHIFT;
 	struct folio_batch fbatch;
 	pgoff_t next, index;
-	int i, freed = 0;
+	int i, j, freed = 0;
 	bool truncate_op = (lend == LLONG_MAX);
 
 	folio_batch_init(&fbatch);
 	next = lstart >> PAGE_SHIFT;
 	while (filemap_get_folios(mapping, &next, end - 1, &fbatch)) {
-		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+		for (i = 0, j = 0; i < folio_batch_count(&fbatch); ++i) {
 			struct folio *folio = fbatch.folios[i];
 			u32 hash = 0;
 
@@ -584,8 +596,17 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 							index, truncate_op))
 				freed++;
 
+			/*
+			 * Skip HWPoison-ed hugepages, which should no
+			 * longer be hugetlb if successfully dissolved.
+			 */
+			if (folio_test_hugetlb(folio))
+				fbatch.folios[j++] = folio;
+
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
+		fbatch.nr = j;
+
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 8e63e46b8e1f0..b7733ef5ee917 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -871,10 +871,17 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn,
 
 #ifdef CONFIG_MEMORY_FAILURE
 extern void folio_clear_hugetlb_hwpoison(struct folio *folio);
+extern bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
+						struct address_space *mapping);
 #else
 static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
 {
 }
+static inline bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio
+						       struct address_space *mapping)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878d..9ad511aacde7c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -213,6 +213,8 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	/* For MFD_MF_KEEP_UE_MAPPED. */
+	AS_MF_KEEP_UE_MAPPED = 11,
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -348,6 +350,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline bool mapping_mf_keep_ue_mapped(const struct address_space *mapping)
+{
+	return test_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
+}
+
+static inline void mapping_set_mf_keep_ue_mapped(struct address_space *mapping)
+{
+	set_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
@@ -1274,6 +1286,18 @@ void replace_page_cache_folio(struct folio *old, struct folio *new);
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct folio_batch *fbatch);
 bool filemap_release_folio(struct folio *folio, gfp_t gfp);
+#ifdef CONFIG_MEMORY_FAILURE
+/*
+ * Provided by memory failure to offline HWPoison-ed folio managed by memfd.
+ */
+void filemap_offline_hwpoison_folio(struct address_space *mapping,
+				    struct folio *folio);
+#else
+void filemap_offline_hwpoison_folio(struct address_space *mapping,
+				    struct folio *folio)
+{
+}
+#endif
 loff_t mapping_seek_hole_data(struct address_space *, loff_t start, loff_t end,
 		int whence);
 
diff --git a/include/uapi/linux/memfd.h b/include/uapi/linux/memfd.h
index 273a4e15dfcff..d9875da551b7f 100644
--- a/include/uapi/linux/memfd.h
+++ b/include/uapi/linux/memfd.h
@@ -12,6 +12,12 @@
 #define MFD_NOEXEC_SEAL		0x0008U
 /* executable */
 #define MFD_EXEC		0x0010U
+/*
+ * Keep owned folios mapped when uncorrectable memory errors (UE) causes
+ * memory failure (MF) within the folio. Only at the end of the mapping
+ * will its HWPoison-ed folios be dealt with.
+ */
+#define MFD_MF_KEEP_UE_MAPPED	0x0020U
 
 /*
  * Huge page size encoding when MFD_HUGETLB is specified, and a huge page
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0455119716ec0..dd3bc0b75e059 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6415,6 +6415,18 @@ static bool hugetlb_pte_stable(struct hstate *h, struct mm_struct *mm, unsigned
 	return same;
 }
 
+bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
+					 struct address_space *mapping)
+{
+	if (WARN_ON_ONCE(!folio_test_hugetlb(folio)))
+		return false;
+
+	if (!mapping)
+		return false;
+
+	return mapping_mf_keep_ue_mapped(mapping);
+}
+
 static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
@@ -6537,9 +6549,11 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 		 * So we need to block hugepage fault by PG_hwpoison bit check.
 		 */
 		if (unlikely(folio_test_hwpoison(folio))) {
-			ret = VM_FAULT_HWPOISON_LARGE |
-				VM_FAULT_SET_HINDEX(hstate_index(h));
-			goto backout_unlocked;
+			if (!mapping_mf_keep_ue_mapped(mapping)) {
+				ret = VM_FAULT_HWPOISON_LARGE |
+				      VM_FAULT_SET_HINDEX(hstate_index(h));
+				goto backout_unlocked;
+			}
 		}
 
 		/* Check for page in userfault range. */
diff --git a/mm/memfd.c b/mm/memfd.c
index 1d109c1acf211..bfdde4cf90500 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -313,7 +313,8 @@ long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg)
 #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
 #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
 
-#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
+#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | \
+		       MFD_NOEXEC_SEAL | MFD_EXEC | MFD_MF_KEEP_UE_MAPPED)
 
 static int check_sysctl_memfd_noexec(unsigned int *flags)
 {
@@ -387,6 +388,8 @@ static int sanitize_flags(unsigned int *flags_ptr)
 	if (!(flags & MFD_HUGETLB)) {
 		if (flags & ~MFD_ALL_FLAGS)
 			return -EINVAL;
+		if (flags & MFD_MF_KEEP_UE_MAPPED)
+			return -EINVAL;
 	} else {
 		/* Allow huge page size encoding in flags. */
 		if (flags & ~(MFD_ALL_FLAGS |
@@ -447,6 +450,16 @@ static struct file *alloc_file(const char *name, unsigned int flags)
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	file->f_flags |= O_LARGEFILE;
 
+	/*
+	 * MFD_MF_KEEP_UE_MAPPED can only be specified in memfd_create; no API
+	 * to update it once memfd is created. MFD_MF_KEEP_UE_MAPPED is not
+	 * seal-able.
+	 *
+	 * For now MFD_MF_KEEP_UE_MAPPED is only supported by HugeTLBFS.
+	 */
+	if (flags & (MFD_HUGETLB | MFD_MF_KEEP_UE_MAPPED))
+		mapping_set_mf_keep_ue_mapped(file->f_mapping);
+
 	if (flags & MFD_NOEXEC_SEAL) {
 		struct inode *inode = file_inode(file);
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3edebb0cda30b..c5e3e28872797 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -373,11 +373,13 @@ static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
  */
-static void __add_to_kill(struct task_struct *tsk, const struct page *p,
+static void __add_to_kill(struct task_struct *tsk, struct page *p,
 			  struct vm_area_struct *vma, struct list_head *to_kill,
 			  unsigned long addr)
 {
 	struct to_kill *tk;
+	struct folio *folio;
+	struct address_space *mapping;
 
 	tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
 	if (!tk) {
@@ -388,8 +390,19 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
 	tk->addr = addr;
 	if (is_zone_device_page(p))
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
-	else
-		tk->size_shift = folio_shift(page_folio(p));
+	else {
+		folio = page_folio(p);
+		mapping = folio_mapping(folio);
+		if (mapping && mapping_mf_keep_ue_mapped(mapping))
+			/*
+			 * Let userspace know the radius of HWPoison is
+			 * the size of raw page; accessing other pages
+			 * inside the folio is still ok.
+			 */
+			tk->size_shift = PAGE_SHIFT;
+		else
+			tk->size_shift = folio_shift(folio);
+	}
 
 	/*
 	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
@@ -414,7 +427,7 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
 	list_add_tail(&tk->nd, to_kill);
 }
 
-static void add_to_kill_anon_file(struct task_struct *tsk, const struct page *p,
+static void add_to_kill_anon_file(struct task_struct *tsk, struct page *p,
 		struct vm_area_struct *vma, struct list_head *to_kill,
 		unsigned long addr)
 {
@@ -535,7 +548,7 @@ struct task_struct *task_early_kill(struct task_struct *tsk, int force_early)
  * Collect processes when the error hit an anonymous page.
  */
 static void collect_procs_anon(const struct folio *folio,
-		const struct page *page, struct list_head *to_kill,
+		struct page *page, struct list_head *to_kill,
 		int force_early)
 {
 	struct task_struct *tsk;
@@ -573,7 +586,7 @@ static void collect_procs_anon(const struct folio *folio,
  * Collect processes when the error hit a file mapped page.
  */
 static void collect_procs_file(const struct folio *folio,
-		const struct page *page, struct list_head *to_kill,
+		struct page *page, struct list_head *to_kill,
 		int force_early)
 {
 	struct vm_area_struct *vma;
@@ -655,7 +668,7 @@ static void collect_procs_fsdax(const struct page *page,
 /*
  * Collect the processes who have the corrupted page mapped to kill.
  */
-static void collect_procs(const struct folio *folio, const struct page *page,
+static void collect_procs(const struct folio *folio, struct page *page,
 		struct list_head *tokill, int force_early)
 {
 	if (!folio->mapping)
@@ -1173,6 +1186,13 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		}
 	}
 
+	/*
+	 * MF still needs to holds a refcount for the deferred actions in
+	 * filemap_offline_hwpoison_folio.
+	 */
+	if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
+		return res;
+
 	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
@@ -1569,6 +1589,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 {
 	LIST_HEAD(tokill);
 	bool unmap_success;
+	bool keep_mapped;
 	int forcekill;
 	bool mlocked = folio_test_mlocked(folio);
 
@@ -1596,8 +1617,12 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 	 */
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
-	unmap_success = !unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
-	if (!unmap_success)
+	keep_mapped = hugetlb_should_keep_hwpoison_mapped(folio, folio->mapping);
+	if (!keep_mapped)
+		unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
+
+	unmap_success = !folio_mapped(folio);
+	if (!keep_mapped && !unmap_success)
 		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
 		       pfn, folio_mapcount(folio));
 
@@ -1622,7 +1647,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 		    !unmap_success;
 	kill_procs(&tokill, forcekill, pfn, flags);
 
-	return unmap_success;
+	return unmap_success || keep_mapped;
 }
 
 static int identify_page_state(unsigned long pfn, struct page *p,
@@ -1862,6 +1887,13 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	unsigned long count = 0;
 
 	head = llist_del_all(raw_hwp_list_head(folio));
+	/*
+	 * If filemap_offline_hwpoison_folio_hugetlb is handling this folio,
+	 * it has already taken off the head of the llist.
+	 */
+	if (head == NULL)
+		return 0;
+
 	llist_for_each_entry_safe(p, next, head, node) {
 		if (move_flag)
 			SetPageHWPoison(p->page);
@@ -1878,7 +1910,8 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
 	struct raw_hwp_page *p;
-	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
+	struct address_space *mapping = folio->mapping;
+	bool has_hwpoison = folio_test_set_hwpoison(folio);
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
@@ -1897,8 +1930,15 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 	if (raw_hwp) {
 		raw_hwp->page = page;
 		llist_add(&raw_hwp->node, head);
+		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
+			/*
+			 * A new raw HWPoison page. Don't return HWPOISON.
+			 * Error event will be counted in action_result().
+			 */
+			return 0;
+
 		/* the first error event will be counted in action_result(). */
-		if (ret)
+		if (has_hwpoison)
 			num_poisoned_pages_inc(page_to_pfn(page));
 	} else {
 		/*
@@ -1913,7 +1953,8 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 		 */
 		__folio_free_raw_hwp(folio, false);
 	}
-	return ret;
+
+	return has_hwpoison ? -EHWPOISON : 0;
 }
 
 static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
@@ -2002,6 +2043,63 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	return ret;
 }
 
+static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
+{
+	int ret;
+	struct llist_node *head;
+	struct raw_hwp_page *curr, *next;
+	struct page *page;
+	unsigned long pfn;
+
+	/*
+	 * Since folio is still in the folio_batch, drop the refcount
+	 * elevated by filemap_get_folios.
+	 */
+	folio_put_refs(folio, 1);
+	head = llist_del_all(raw_hwp_list_head(folio));
+
+	/*
+	 * Release refcounts held by try_memory_failure_hugetlb, one per
+	 * HWPoison-ed page in the raw hwp list.
+	 */
+	llist_for_each_entry(curr, head, node) {
+		SetPageHWPoison(curr->page);
+		folio_put(folio);
+	}
+
+	/* Refcount now should be zero and ready to dissolve folio. */
+	ret = dissolve_free_hugetlb_folio(folio);
+	if (ret) {
+		pr_err("failed to dissolve hugetlb folio: %d\n", ret);
+		return;
+	}
+
+	llist_for_each_entry_safe(curr, next, head, node) {
+		page = curr->page;
+		pfn = page_to_pfn(page);
+		drain_all_pages(page_zone(page));
+		if (!take_page_off_buddy(page))
+			pr_err("%#lx: unable to take off buddy allocator\n", pfn);
+
+		page_ref_inc(page);
+		kfree(curr);
+		pr_info("%#lx: pending hard offline completed\n", pfn);
+	}
+}
+
+void filemap_offline_hwpoison_folio(struct address_space *mapping,
+				    struct folio *folio)
+{
+	WARN_ON_ONCE(!mapping);
+
+	if (!folio_test_hwpoison(folio))
+		return;
+
+	/* Pending MFR currently only exist for hugetlb. */
+	if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
+		filemap_offline_hwpoison_folio_hugetlb(folio);
+}
+
 /*
  * Taking refcount of hugetlb pages needs extra care about race conditions
  * with basic operations like hugepage allocation/free/demotion.
-- 
2.52.0.rc1.455.g30608eb744-goog


