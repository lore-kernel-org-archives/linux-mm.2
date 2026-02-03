Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D3BE87859
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 19:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95526B0089; Tue,  3 Feb 2026 14:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36936B008A; Tue,  3 Feb 2026 14:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17D66B0092; Tue,  3 Feb 2026 14:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 875B36B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:24:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32841596E8
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:24:00 +0000 (UTC)
X-FDA: 84404120640.22.101962C
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 591A7120010
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:23:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iDm9RCUo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3TUuCaQgKCEAlkcsk0cpiqqing.eqonkpwz-oomxcem.qti@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3TUuCaQgKCEAlkcsk0cpiqqing.eqonkpwz-oomxcem.qti@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770146638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYF1G0Gg7ErYo3r8AiHFjVFEHimFbEWfFEP1Omqr704=;
	b=SdFxvFYyw9ubBD//EhK+9iNy5/OtIyqpDgICveJMBia5gtvBtoat9XTibcjjkNY+v4D6VY
	3GYx4bCfFtvi2mcxUh6MiSLQD+ncaDFTDYLKIv3y/5Pmp8NjNxrdd6hYkhNvjdoVpF39d+
	/zgcNEMxXVLPQanXenP/ghMu3RIIKtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770146638; a=rsa-sha256;
	cv=none;
	b=TcnZapph7BiDwUQU9VJteZAGfMhgm0MJZxUzaQpry/sQoYn49jIEx2YJ1tmAR/wfpe2F3o
	1da1JOKtfHk9pgULdVnpROFhq/3p9HxcjBkL+OYSXc9yDDnZ7p899dK7+x4+7MdKyjmWhP
	KKghTA6qEAasb+2ZXb46c8xmEXXhFNw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iDm9RCUo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3TUuCaQgKCEAlkcsk0cpiqqing.eqonkpwz-oomxcem.qti@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3TUuCaQgKCEAlkcsk0cpiqqing.eqonkpwz-oomxcem.qti@flex--jiaqiyan.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a90db74672so26553145ad.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 11:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770146637; x=1770751437; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dYF1G0Gg7ErYo3r8AiHFjVFEHimFbEWfFEP1Omqr704=;
        b=iDm9RCUo/Gh6ANL+9YWh/v5C6ECE3gDnrEfQ6SM55Ad0ECQ0SEpLxPyRQE0u8sW5AC
         lOftM0V6IvihFTNthU00r4ak/Vj93F+a2Y82qXFYiC2RGfpZiHXrBVngx06HewlHFADF
         wE7dWqvq1vyaO8coSKO4Ii/kRN2bYZ6mQNzG2GHndGAbMlhBlIzpdCuG5IEbgPtjcUxX
         yERUNynz5+otKqGfdrc3l0iUw1vuuusgQRQM7Oo5iUbjxO75xQA10UW/Qm4SadT8Q0Fg
         652ksi0GfitFZj1j4cvKWBtPFOQBn3kdJtuIJoUeAtyEs22AN6G1Dt0z4vVXXOjZPNOm
         rKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770146637; x=1770751437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYF1G0Gg7ErYo3r8AiHFjVFEHimFbEWfFEP1Omqr704=;
        b=atxk0qw6a3yLfudksWPA2razhau5RBFIM+ZnkqEWXAw4fXuk6+V4yeKn8Bi2332HJo
         eMlrmUL5+5qO/VfcoZj71JnnqEC1NmIo6L5TD4fYpfx+2QQZhCzLoQBiF4YMMekH8tMJ
         HOZDTvqSGAWVN7xtPAc/WgQmXNhorb0ycKew7O3Q0PjUStIUbIqmfX4S1VOS9ilgD31B
         bq2ydN3Enhca0looVD7bTP7IoIuBmEcu0b9pp+rSnarL3oHVUch9RBzg67vF/P/wvoKP
         KyELiIelW8CXtFKGtE5lpZ9KON2ftbyWXYlMSuvorDA563mIVSRI+SSbwtWJtEDzxb9i
         4FhA==
X-Forwarded-Encrypted: i=1; AJvYcCXvV2ECoZxIT/PDfeCCuWNcvSMk2YzTvoAfvFrr89etpomx8QhUykT99BuFweSjqMuW6oCDayknUw==@kvack.org
X-Gm-Message-State: AOJu0YwU6T9ZK4y41vL6FpkRoeGOCw6ozyPC04gS4UwdBgqdDJ4hx00O
	1n5/D7pBxsRwnvVteKL6P25AGAH4nFIdgH6Vv5U9H2tspZIMNyF+a6WsEGp8qiLyZ2ZpXwtGgpm
	o1sBk5M6sBC7wbw==
X-Received: from pjuj5.prod.google.com ([2002:a17:90a:d005:b0:34c:2f52:23aa])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e847:b0:2a9:29d4:1099 with SMTP id d9443c01a7336-2a933d12187mr2786895ad.24.1770146637002;
 Tue, 03 Feb 2026 11:23:57 -0800 (PST)
Date: Tue,  3 Feb 2026 19:23:50 +0000
In-Reply-To: <20260203192352.2674184-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203192352.2674184-2-jiaqiyan@google.com>
Subject: [PATCH v3 1/3] mm: memfd/hugetlb: introduce memfd-based userspace MFR policy
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, william.roche@oracle.com, harry.yoo@oracle.com, 
	jane.chu@oracle.com
Cc: nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 591A7120010
X-Stat-Signature: upopnrecaw5xtxdi9kxnuffuepk8hcws
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770146638-777308
X-HE-Meta: U2FsdGVkX1+IG38W4TZU+g2NgmpcIA7mD9EcxZw9v6T76XI8LvRSRkAEkyb8BVXEmvOTLlAE+FatWOlJaXT/qKfDAmHQTpLZIRbEXYtej0wGT50Jkt+8LU5dv8OFa/xFE1BYpztxgc47E+XkQLH+b2P2ecKbT6SwMC008XN4nq8YKafCl3/qT6HBvKvJSHyqUx1fW9IhaO9AAg7zuxLku1Ffcey336KfUY5CQBp5WR6H47a3xBRv1oouEqJsIJdVlWVbKd+aQ5EFsAL90dty1Fz7KcHkwm4TRuzIZNMY+Db78RTVQDsG7yZK5X26+7eHshYaUH0Pkl2onX2BM5Nd5s852VM9Fo6aQnhSTGYv7LFQcfseQoUtxy2IhfqLQCcg7bviuxunbiOa5tgihW13qG1gBfZDWAUh8ALGMuTOg+1JY47Gfh6ZkfdANNpzkJoJPo3VYoxVN67BfpPHOmEutAiDXF5KW+P7H8a328ZoAriIFLPv9P2oigkDqzqXpajjOmXJHCry1VL0yTMeh3CfLTWv3FMGkhTjqcBqONHbFcSDn37s5DvGse7c+C/ucj38IxDojfceTJu5H3s4mpmjwozeH6+5vW8x74gZBDXD7LYyfq6n4QCA4SpciEsTlvvnYZGxGVTr0WW6vr8JCwJHTQi+HSKEajwxXLVH/EoSVT4/icoEHGLrP+TSg81N9S0EGg6Kkjo3O9PB1zhAD+Xumaq/iehYA0dpZ2Vdo2y3SEL0tjna9+C9A5+c8lPGs9Azm8a+1erMcGXXhkL1kzeEAFyemePMShOeZtk6SOT83djqLO2BSWWLQ+NEoZYw7aPAR/5J5BvfJSvvGAeXvIsyD9RYx2QCeW82lVmB1puXjMJ0XuZ+vFHPqkJjkjZGBdgHAr41q9LCVJwc1rMOL8enOXpJRPB6KediSc30E/hry2gAZnlwwGI+jp+QnWBf/w5ZKrAXETlfs8PQdzJF9F1
 U/1goxNS
 qtYsg2DLEcALrrkgqOAHwjU0kSHd5gUV+C6hWIm6Xq5ocu/RCzzWDRt8IX4DJOsEnUoe7M1MMkRyM3yIy5A+txzrav3NWDAhfQN8DD4ZTHpvBeFkJ4bBvZrMsVtGJO11Nmxq/Wrb0Z+oYLEYz3b+72mvF4kcZcupd6gLHNDSjAxJbMYv9ktm9xFMWb8HSsUEyDv2q0CDJIX0rdhjrRFLOBtWwuaGdK9iA/mO81awlZlK1oIp/zTgBwswruAMTipNb4qxpG8wADNlk6D0y0U8AKWreMR5LPMVcTDDFd7xnF3T9AXE583/ErmtA4GStU5IM5Jp1p77NB87j+Mg87q4fqbjiSHM7gQ0NeyoY7oWfqzStR4HjH+LMn3skY8qa129EEz1jQvPktfbOQDuFNDhDx6nwl4Dw2PlbauH4AuBSiw0cWRRkpGZp2o5RbGBSD4ibBgRmvkK5r/xQlm9XSvmnzPoxFBbBC6BP+/G0pCDkXgUvlIDEnVP+HAO6VZPHlOOdwfRv3GFtWkyQk2XJArkGThO9ImnDu0Kq6Yhve3Jgf2fxkyoqFzMvhulz4A9qoILB2ji2PZPhD092kdpsDxV/4WKrnfxj8warXcTtm0jLY6gtOjEc9pn10U3/zHNeR8lgP9GRMw2wjdtNQmRbNwL1qJB679zU1rO+J1CxDNOVZVKQVudYCxEaf9LOQByhqHQ6qIJXtkXi5j7DJWOhsmoKXV1Sg7ysD5JdGEZhYn3Bnu4qodyLTgPgns8/HsJMurxQOywJyBbacIo7ylqsVQytdRR9ZteGyVazIHFHzvghdDTTFQTmhvoRq0xZBiUNsHH0Hozh
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
that owns the memory, e.g. VMM in the Cloud environment.

Introduce a memfd-based userspace memory failure (MFR) policy,
MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memfd,
but the current implementation only covers HugeTLB.

For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memfd,
whenever it runs into a new UE,

* MFR defers hard offline operations, i.e., unmapping and
  dissolving. MFR still sets HWPoison flag, holds a refcount
  for every raw HWPoison page, record them in a list, sends SIGBUS
  to the consuming thread, but si_addr_lsb is reduced to PAGE_SHIFT.
  If userspace is able to handle the SIGBUS, the HWPoison hugepage
  remains accessible via the mapping created with that memfd.

* If the memory was not faulted in yet, the fault handler also
  allows fault in the HWPoison folio.

For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
when userspace process truncates its hugepages:

* When the HugeTLB in-memory file system removes the filemap's
  folios one by one, it asks MFR to deal with HWPoison folios
  on the fly, implemented by filemap_offline_hwpoison_folio().

* MFR drops the refcounts being held for the raw HWPoison
  pages within the folio. Now that the HWPoison folio becomes
  free, MFR dissolves it into a set of raw pages. The healthy pages
  are recycled into buddy allocator, while the HWPoison ones are
  prevented from re-allocation.

By default MFD_MF_KEEP_UE_MAPPED is not set, so MFR immediately hard
offlines hugepages having UEs.

Tested with new selftest hugetlb-mfr in the follow-up commit.

Co-developed-by: William Roche <william.roche@oracle.com>
Signed-off-by: William Roche <william.roche@oracle.com>
Tested-by: William Roche <william.roche@oracle.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 fs/hugetlbfs/inode.c       |  25 +++++++-
 include/linux/hugetlb.h    |   7 +++
 include/linux/pagemap.h    |  23 +++++++
 include/uapi/linux/memfd.h |   6 ++
 mm/hugetlb.c               |   8 ++-
 mm/memfd.c                 |  15 ++++-
 mm/memory-failure.c        | 124 ++++++++++++++++++++++++++++++++++---
 7 files changed, 193 insertions(+), 15 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3b4c152c5c73a..8b0f5aa49711f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -551,6 +551,18 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
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
 
@@ -582,13 +594,13 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
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
 
@@ -603,8 +615,17 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
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
index e51b8ef0cebd9..7fadf1772335d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -879,10 +879,17 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn,
 
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
index ec442af3f8861..53772c29451eb 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -211,6 +211,7 @@ enum mapping_flags {
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
 	AS_NO_DATA_INTEGRITY = 11, /* no data integrity guarantees */
+	AS_MF_KEEP_UE_MAPPED = 12, /* For MFD_MF_KEEP_UE_MAPPED. */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -356,6 +357,16 @@ static inline bool mapping_no_data_integrity(const struct address_space *mapping
 	return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
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
@@ -1303,6 +1314,18 @@ void replace_page_cache_folio(struct folio *old, struct folio *new);
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
+static inline void filemap_offline_hwpoison_folio(struct address_space *mapping,
+						  struct folio *folio)
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
index a1832da0f6236..2a161c281da2a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5836,9 +5836,11 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
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
index ab5312aff14b9..f9fdf014b67ba 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -340,7 +340,8 @@ long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg)
 #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
 #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
 
-#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
+#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | \
+		       MFD_NOEXEC_SEAL | MFD_EXEC | MFD_MF_KEEP_UE_MAPPED)
 
 static int check_sysctl_memfd_noexec(unsigned int *flags)
 {
@@ -414,6 +415,8 @@ static int sanitize_flags(unsigned int *flags_ptr)
 	if (!(flags & MFD_HUGETLB)) {
 		if (flags & ~MFD_ALL_FLAGS)
 			return -EINVAL;
+		if (flags & MFD_MF_KEEP_UE_MAPPED)
+			return -EINVAL;
 	} else {
 		/* Allow huge page size encoding in flags. */
 		if (flags & ~(MFD_ALL_FLAGS |
@@ -486,6 +489,16 @@ static struct file *alloc_file(const char *name, unsigned int flags)
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	file->f_flags |= O_LARGEFILE;
 
+	/*
+	 * MFD_MF_KEEP_UE_MAPPED can only be specified in memfd_create;
+	 * no API to update it once memfd is created. MFD_MF_KEEP_UE_MAPPED
+	 * is not seal-able.
+	 *
+	 * For now MFD_MF_KEEP_UE_MAPPED is only supported by HugeTLBFS.
+	 */
+	if (flags & MFD_MF_KEEP_UE_MAPPED)
+		mapping_set_mf_keep_ue_mapped(file->f_mapping);
+
 	if (flags & MFD_NOEXEC_SEAL) {
 		inode->i_mode &= ~0111;
 		file_seals = memfd_file_seals_ptr(file);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 58b34f5d2c05d..b9cecbbe08dae 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -410,6 +410,8 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
 			  unsigned long addr)
 {
 	struct to_kill *tk;
+	const struct folio *folio;
+	struct address_space *mapping;
 
 	tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
 	if (!tk) {
@@ -420,8 +422,19 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
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
@@ -844,6 +857,8 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 				  int flags)
 {
 	int ret;
+	struct folio *folio;
+	struct address_space *mapping;
 	struct hwpoison_walk priv = {
 		.pfn = pfn,
 	};
@@ -861,8 +876,14 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 	 * ret = 0 when poison page is a clean page and it's dropped, no
 	 * SIGBUS is needed.
 	 */
-	if (ret == 1 && priv.tk.addr)
+	if (ret == 1 && priv.tk.addr) {
+		folio = pfn_folio(pfn);
+		mapping = folio_mapping(folio);
+		if (mapping && mapping_mf_keep_ue_mapped(mapping))
+			priv.tk.size_shift = PAGE_SHIFT;
+
 		kill_proc(&priv.tk, pfn, flags);
+	}
 	mmap_read_unlock(p->mm);
 
 	return ret > 0 ? -EHWPOISON : 0;
@@ -1206,6 +1227,13 @@ static int me_huge_page(struct page_state *ps, struct page *p)
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
 
@@ -1602,6 +1630,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 {
 	LIST_HEAD(tokill);
 	bool unmap_success;
+	bool keep_mapped;
 	int forcekill;
 	bool mlocked = folio_test_mlocked(folio);
 
@@ -1629,8 +1658,12 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
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
 
@@ -1655,7 +1688,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 		    !unmap_success;
 	kill_procs(&tokill, forcekill, pfn, flags);
 
-	return unmap_success;
+	return unmap_success || keep_mapped;
 }
 
 static int identify_page_state(unsigned long pfn, struct page *p,
@@ -1896,6 +1929,13 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
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
@@ -1912,7 +1952,8 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
 	struct raw_hwp_page *p;
-	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
+	struct address_space *mapping = folio->mapping;
+	bool has_hwpoison = folio_test_set_hwpoison(folio);
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
@@ -1931,8 +1972,15 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
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
@@ -1947,7 +1995,8 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 		 */
 		__folio_free_raw_hwp(folio, false);
 	}
-	return ret;
+
+	return has_hwpoison ? -EHWPOISON : 0;
 }
 
 static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
@@ -1980,6 +2029,18 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	folio_free_raw_hwp(folio, true);
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
 /*
  * Called from hugetlb code with hugetlb_lock held.
  *
@@ -2037,6 +2098,51 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	return ret;
 }
 
+static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
+{
+	int ret;
+	struct llist_node *head;
+	struct raw_hwp_page *curr, *next;
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
+	 *
+	 * Set HWPoison flag on each page so that free_has_hwpoisoned()
+	 * can exclude them during dissolve_free_hugetlb_folio().
+	 */
+	llist_for_each_entry_safe(curr, next, head, node) {
+		folio_put(folio);
+		SetPageHWPoison(curr->page);
+		kfree(curr);
+	}
+
+	/* Refcount now should be zero and ready to dissolve folio. */
+	ret = dissolve_free_hugetlb_folio(folio);
+	if (ret)
+		pr_err("failed to dissolve hugetlb folio: %d\n", ret);
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
2.53.0.rc2.204.g2597b5adb4-goog


