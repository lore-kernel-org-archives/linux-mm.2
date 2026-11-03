Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD7A606A330
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T+dfQc3d
Received: by kanga.kvack.org (Postfix)
	id 0FC046B05B8; Tue,  3 Nov 2026 01:17:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057B36B05B9; Tue,  3 Nov 2026 01:17:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88C06B05BA; Tue,  3 Nov 2026 01:17:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC6D66B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:17:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD1E2C03E9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:05 +0000 (UTC)
X-FDA: 85392800010.18.22B68BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 60F96C0007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T+dfQc3d;
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793686623;
	b=bdZAoO7i+uYKPq6Z8nnv8/PieghuKTrNaPpgktM0de7BRh9SmGWWCyN1qiWmB6dgnhKUQ/
	CvXX8dKC+CGGADwR2c4oNQhtXocJaU2IuSIsiCxVgIqKLXjfuJVc2rw98QouWh8U/EWmVJ
	Qnu5xlFeIIMry4gZzh6dYHeO8hWy+yY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793686623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zw9DY6JBG5hvTm4us+YQpe0Js+JZjCI3PBXegYRAl0M=;
	b=z2+Hfx8iUZa2GzpkfkPrM3rxAO/82SDyT3jXgIwOZhq23ZOn3rWJkf11HAwZkZUbCLTE3o
	V8PBAxnDN6HRuDXSM2rqyv2cVZS5P5gnYm5fJNIQSjN6ey7djno8qPiHzxPJqKMkvWCgz1
	1N1n+Yu/y/DXdGR16CGKzOAO4EvtSuE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T+dfQc3d;
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zw9DY6JBG5hvTm4us+YQpe0Js+JZjCI3PBXegYRAl0M=;
	b=T+dfQc3dWGa6DqcA+sQHbNJWNOxzzuXyozDMDUs9gzftnjfVUwC1lwpDlVVc/o4KvZrx1Q
	wA230FGhuA86Jk/EBzLzbPxO56qfoY+dFemTXWFT1//q6CPpZU/+BqH4H33Lkvk+7r41EG
	iRKmyGvSwDjThOdK4YFVR4PmP9WwQ60=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-ANAqRmH5NJegeuKdKhKd9w-1; Tue, 03 Nov 2026 01:16:59 -0500
X-MC-Unique: ANAqRmH5NJegeuKdKhKd9w-1
X-Mimecast-MFC-AGG-ID: ANAqRmH5NJegeuKdKhKd9w_1793686618
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3accf0b1addso9815381fa.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:16:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686618; x=1794291418;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zw9DY6JBG5hvTm4us+YQpe0Js+JZjCI3PBXegYRAl0M=;
        b=s5usHgYVk3aaBa1zJszoyHtS2PTkWBuHGhFq6ClssS/0vGAwpcAjWlybRziN7PCWOM
         uDzwbWC9Jv4zuPx8nnCX2cwtsEsirblf4uyUkk290CpoU22yTuD5WA0jmV427zD19Ufn
         0PmN3BPZ1yhxnl5UcqdBUAyspBGAY9acJiKA90ArS9UvsLVhjZVfcE5Gy+rM8lPm42te
         N/DO80T5Dw/xjg7oTyG7S+K/cEjKu8aycEHrrVyIT6wDVe1PTvrtG6kbpLBYy4n68gaW
         0b7MA4l8NAG+PZG1qlKyFew6p6iYDq2Z0PA1jpu0Hlx0ZXTwu0SsmbVIw3ZlkeQA/Gw1
         yAxw==
X-Gm-Message-State: APuU4Z/wXexShHyGgcxRe+ssOFaKENIEA+eSr9Ovaa6d0FtLImeXheaF
	Yis5JM2J8+5SbMdhPtCsPf+2iIu6ZF9isadHSQO6AlXmTwRsd35gGaiDjplXxvbxxZ2CCxj1Sxu
	JPU5YfNgr53v9toY7/UhmGjDEwLtqeAqn51l3IGlbRSlPxle3KrKrytTJEjXX2OrbLoau15r7TX
	+6sg0TQWrj0zthK2KPMuY3oHWifZ6Ic60J2VZ2RQ==
X-Gm-Gg: AYBFou1bg1jCdK6zmXsHNvyAlhpB6p8z376hUXt8ev0/EqphznqtnqIYjW3EiPC9Z/w
	Xq1SRkffpd6cYlBDR7KbO4GJV51d5UGyyqPr769CGmSuqzX5a1VGJLecQX+kmrxY7u7v76O46Ua
	HhjVC2X+lhpwIBRU1/VBYHabv3nhNNuGDUshpwRm6qHDSi8sxr59dL+lz14i4EOW9cKYDdp1EzC
	j/iO7mRpnG/BS+hV9aveP0mNkeZg6n4CwMmoNojPCqsYemDV97eYqGnsCuIuxg/oigU1eD8D1FT
	44MJuDUVsYO/VQZAMHrjEy/4Tu7Ee+S+u9jjfDgVsDCpQurnNqESWdniAat1c7nE35DT9kkHOSQ
	JcdybVxmr56av2xydPkuwUPoKtOc3QNK1yRp2GV1G2wBrGMD6hNo+57ZmFD2+8CnfGhWiSg==
X-Received: by 2002:a05:6512:3b2c:b0:5bf:a34f:7088 with SMTP id 2adb3069b0e04-5bfd9595d46mr4417785e87.61.1793686617964;
        Mon, 02 Nov 2026 22:16:57 -0800 (PST)
X-Received: by 2002:a05:6512:3b2c:b0:5bf:a34f:7088 with SMTP id 2adb3069b0e04-5bfd9595d46mr4417761e87.61.1793686617497;
        Mon, 02 Nov 2026 22:16:57 -0800 (PST)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe073e0f9sm1964634e87.54.2026.11.02.22.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:16:56 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v17 05/12] mm/hmm: migrate collection in HMM pagewalk - pte level
Date: Tue,  3 Nov 2026 08:16:22 +0200
Message-ID: <20261103061629.972669-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103061629.972669-1-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fmAB3GRuJ_cz2bsQrV3JRDfo01CBgg3oCnO7xK2Oom0_1793686618
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: 3gue31ewtziujra36fn1x18cqruz5pik
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 60F96C0007
X-HE-Tag: 1793686623-982254
X-HE-Meta: U2FsdGVkX1+ka24oumAzTx0irGKk61hOPB0/AfQDrzKt/Mk/jqxrD1H77qEyth0aWQCLcAeHARdXUZjh2V+//Aimu+bXS3gN+FdZOh4KtSyeE6CqxZFgP5szg2x5o1ehO9x7DABcTN0amnncSYU3GRrEBru67Tm86HYIE+c+/iYyOxamYI7BAvjeLWJTaXf0BsdPRzn7rR96gU+SmPSxP0h4ALc1v649wEBBq3wzjTzCW0KCqQeEefjVnl29meWxPXG05An1IIGO6R6jvHBzbg48SFTAiidvA6HbW+42mlW2wqjrO4f4SrI27c5mzEsfET6pNrV7CfDYqZMVYwPrPDirSDYq3RGWreF37B+HErsOXO/zpZHroU+Tn03QV/F71tQQPMflKaeEXcPnj6GbJlV57pMEr72jZOwnHCqe+xLN4iKoAq22RexFZ1aG4trfHKatFfK33vuhqCB+Jp1NMVxCnR6HO/rBU77EBazA5H3OBjVZta8pYQGrjgNmcbK5NtXO+DszACHDPDM/6Ep7PwYGeJiNP0PBfUstTbRDXPpppGX/aBslzShHeRENui5eEjT9hIaZzlRjWdj1IwE9tn1z/NOGM9NWHYIJGSazvLJSJBHf9hysciEgX0UanuwGZJ6IdYoXn666g0LtQp741R93tksF2XW6kr8bWzfK4kJwpcV9zfvVQ40Oa7cRw3xKsMnWwLpSW8Uen6R9HfsIA1DuX1EnsZAx8WpxGEfjXTs/XNLn9/WI22JH1SwxXa320SKHLSfli7vn3xT0cmAVSL00zZkI+3iqljyXvd1d6EGFMvz1M/22VmvPN4rK6gXHhjOD4sds3qTw/3A398ISzD7yxGAPltpNw2LAtpEsIXt1jfJ+1QzlQG6npSmLAvblCoX1ftUFSLEdd3MRVlo9YFRoGjI7XESvzMWPwD09W+zcvuuTpDK0LeC6Z2f9uFHd3Z5RmRm0J3l8+9x49g6
 V60VALrq
 6rx1ydHjsY4Y5rHYiogr2Yn3hgoBWH02HzkT9KH3QCZU8ezc88wfXbVAJ7rQ6yGXDW7NglG5SYmzBr9vC8ZyWf28nr6Ub/sJwPknSdwwOSJzjkVFVd2PmDfQ1EyD5/48v+kwKF4uT+hQ1wRBz8PhLFUoBdnfrOGNDodw3k+yBVY+c/yHE/jJT63FwVjO4GPxfHlZIPgUaMhR/79QP2YrWHtmxlGJ4T2XNPb02XLLwgiPScWVpHcPdtzsyOTIiFtBcVJfJmZEs7+I4aJvoX0ZMhfKtSpw2CKrgQffK6PS+9Mk+bqdgVDVqYDgdcgj0r7ujjzrITBki1uMuIwYvYK/XbkZae0mstkku1DZUYkSQzgRjCFJQu6MSUtlF4KzkLnnLO+KonpG2HC9sshoj869hmGU+CzChYAfOix13q4azYOJTvYOxoDNDUaHH5BfFPhJ9zbAxOEAs+wMHyP1jjjj7gKXAwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

Implement the needed hmm_vma_handle_migrate_prepare() function
which is mostly carried over from migrate_device.c's
migrate_vma_collect_pmd() function.

Also implement the migrate_vma_split_folio(), for splitting
pte mapped large folios. It is also mostly from migrate_device.c,
with care taken to reference folio before releasing page table
lock.

With HMM pagewalk based migration, the idea is that
hmm_vma_handle_*() are responsible for faulting,
and the pfn collecting part. hmm_vma_handle_migrate_prepare*()
do the migration decisions (with HMM_PFN_MIGRATE), possibly split
folios, and insert migration ptes/pmds.

Collected folios stay locked while hmm_range_fault() may still fault
other pages of the range. This cannot self-deadlock: only anonymous
folios are collected, so no page cache or invalidate_lock ordering is
involved; faults are confined to the single vma, where a non-KSM
anonymous page is mapped only once (and that mapping is now our
migration entry); and when migrating only the faulting pte is faulted,
never our own entries. A KSM page's second mapping just fails the
collection trylock, and a swapcache folio still referenced by other
swap entries is not collected. Reclaim and direct compaction under the
fault only trylock folio locks.

HMM pagewalk based migration is enabled in later commit, for
now hmm_select_migrate() returns 0.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 mm/hmm.c | 294 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 293 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 854d2c090b20..ec9280ef2682 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -495,6 +495,71 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 #ifdef CONFIG_DEVICE_MIGRATION
+/**
+ * migrate_vma_split_folio() - Helper function to split a THP folio
+ * @folio: the folio to split
+ * @fault_page: struct page associated with the fault if any
+ * @hmm_vma_walk: walk in progress
+ * @ptep: pte_t * for unmap and unlock ptl
+ *
+ * Always drops the pte lock associated with @ptep.
+ *
+ * Returns 0 on success
+ */
+static int migrate_vma_split_folio(struct folio *folio,
+				   struct page *fault_page,
+				   struct hmm_vma_walk *hmm_vma_walk,
+				   pte_t *ptep)
+{
+	int ret;
+	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
+	struct folio *new_fault_folio = NULL;
+
+	/*
+	 * Take the reference while still holding the PTE lock, so the folio
+	 * cannot be freed once the lock is dropped. folio_lock() may sleep,
+	 * so it can only be taken after dropping the PTE spinlock. The fault
+	 * folio is already referenced and locked by do_swap_page().
+	 */
+	if (folio != fault_folio)
+		folio_get(folio);
+
+	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+	hmm_vma_walk->ptelocked = false;
+
+	if (folio != fault_folio)
+		folio_lock(folio);
+
+	ret = split_folio(folio);
+	if (ret) {
+		if (folio != fault_folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		return ret;
+	}
+
+	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
+
+	/*
+	 * Ensure the lock is held on the correct
+	 * folio after the split
+	 */
+	if (!new_fault_folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	} else if (folio != new_fault_folio) {
+		if (new_fault_folio != fault_folio) {
+			folio_get(new_fault_folio);
+			folio_lock(new_fault_folio);
+		}
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return 0;
+}
+
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
 					      unsigned long start,
@@ -505,6 +570,11 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 	return 0;
 }
 
+/*
+ * Install migration entries if migration requested, either from fault
+ * or migrate paths.
+ *
+ */
 static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 					  pmd_t *pmdp,
 					  pte_t *ptep,
@@ -512,8 +582,230 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 					  unsigned long *hmm_pfn,
 					  bool *unmapped)
 {
-	// TODO: implement migration entry insertion
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct mm_struct *mm = walk->vma->vm_mm;
+	struct folio *fault_folio = NULL;
+	enum migrate_vma_info minfo;
+	struct dev_pagemap *pgmap;
+	bool anon_exclusive;
+	struct folio *folio;
+	unsigned long pfn;
+	struct page *page;
+	softleaf_t entry;
+	pte_t pte, swp_pte;
+	bool writable = false;
+
+	// Do we want to migrate at all?
+	minfo = hmm_select_migrate(range);
+	if (!minfo)
+		return 0;
+
+	WARN_ON_ONCE(!migrate);
+	HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, true);
+
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
+	pte = ptep_get(ptep);
+
+	if (pte_none(pte)) {
+		if (vma_is_anonymous(walk->vma)) {
+			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
+			*hmm_pfn |= HMM_PFN_MIGRATE;
+			goto out;
+		}
+	}
+
+	/*
+	 * NUMA hinting (protnone) entries are not reported valid, but the
+	 * page can still be migrated as is.
+	 */
+	if (!(hmm_pfn[0] & HMM_PFN_VALID) &&
+	    !(pte_present(pte) && pte_protnone(pte)))
+		goto out;
+
+	if (!pte_present(pte)) {
+		/*
+		 * Only care about unaddressable device page special
+		 * page table entry. Other special swap entries are not
+		 * migratable, and we ignore regular swapped page.
+		 */
+		entry = softleaf_from_pte(pte);
+		if (!softleaf_is_device_private(entry))
+			goto out;
+
+		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
+			goto out;
+
+		page = softleaf_to_page(entry);
+		folio = page_folio(page);
+		if (folio->pgmap->owner != migrate->pgmap_owner)
+			goto out;
+
+		if (folio_test_large(folio)) {
+			int ret;
+
+			ret = migrate_vma_split_folio(folio,
+						      migrate->fault_page,
+						      hmm_vma_walk,
+						      ptep);
+			if (ret)
+				goto out_error;
+			return -EAGAIN;
+		}
+
+		pfn = page_to_pfn(page);
+		if (softleaf_is_device_private_write(entry))
+			writable = true;
+	} else {
+		pfn = pte_pfn(pte);
+		if (is_zero_pfn(pfn) &&
+		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			/* Like pte_none(): only anonymous memory can be populated */
+			if (!vma_is_anonymous(walk->vma))
+				goto out;
+			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
+			*hmm_pfn |= HMM_PFN_MIGRATE;
+			goto out;
+		}
+		page = vm_normal_page(walk->vma, addr, pte);
+		if (page && !is_zone_device_page(page) &&
+		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			goto out;
+		} else if (page && is_device_coherent_page(page)) {
+			pgmap = page_pgmap(page);
+
+			if (!(minfo &
+			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
+			    pgmap->owner != migrate->pgmap_owner)
+				goto out;
+		}
+
+		folio = page ? page_folio(page) : NULL;
+		if (folio && folio_test_large(folio)) {
+			int ret;
+
+			ret = migrate_vma_split_folio(folio,
+						      migrate->fault_page,
+						      hmm_vma_walk,
+						      ptep);
+			if (ret)
+				goto out_error;
+			return -EAGAIN;
+		}
+
+		writable = pte_write(pte);
+	}
+
+	/* Only anonymous memory can be migrated to device memory */
+	if (!page || !folio_test_anon(page_folio(page)))
+		goto out;
+
+	/*
+	 * By getting a reference on the folio we pin it and that blocks
+	 * any kind of migration. Side effect is that it "freezes" the
+	 * pte.
+	 *
+	 * We drop this reference after isolating the folio from the lru
+	 * for non device folio (device folio are not on the lru and thus
+	 * can't be dropped from it).
+	 */
+	folio = page_folio(page);
+	folio_get(folio);
+
+	/*
+	 * We rely on folio_trylock() to avoid deadlock between
+	 * concurrent migrations where each is waiting on the others
+	 * folio lock. If we can't immediately lock the folio we fail this
+	 * migration as it is only best effort anyway.
+	 *
+	 * If we can lock the folio it's safe to set up a migration entry
+	 * now. In the common case where the folio is mapped once in a
+	 * single process setting up the migration entry now is an
+	 * optimisation to avoid walking the rmap later with
+	 * try_to_migrate().
+	 */
+
+	if (fault_folio == folio || folio_trylock(folio)) {
+		/*
+		 * A swapcache folio still referenced by other swap entries
+		 * can't be migrated (see migrate_device_pages()), and faulting
+		 * one of those entries later in the walk, with no retry
+		 * allowed, would block on the lock we hold.
+		 */
+		if (folio_test_swapcache(folio) && !folio_free_swap(folio)) {
+			if (fault_folio != folio)
+				folio_unlock(folio);
+			folio_put(folio);
+			goto out;
+		}
+
+		anon_exclusive = folio_test_anon(folio) &&
+			PageAnonExclusive(page);
+
+		if (pte_present(pte))
+			flush_cache_page(walk->vma, addr, pfn);
+
+		if (anon_exclusive) {
+			pte = ptep_clear_flush(walk->vma, addr, ptep);
+
+			if (folio_try_share_anon_rmap_pte(folio, page)) {
+				set_pte_at(mm, addr, ptep, pte);
+				if (fault_folio != folio)
+					folio_unlock(folio);
+				folio_put(folio);
+				goto out;
+			}
+		} else {
+			pte = ptep_get_and_clear(mm, addr, ptep);
+		}
+
+		if (pte_present(pte) && pte_dirty(pte))
+			folio_mark_dirty(folio);
+
+		/* Setup special migration page table entry */
+		if (writable)
+			entry = make_writable_migration_entry(pfn);
+		else if (anon_exclusive)
+			entry = make_readable_exclusive_migration_entry(pfn);
+		else
+			entry = make_readable_migration_entry(pfn);
+
+		if (pte_present(pte)) {
+			if (pte_young(pte))
+				entry = make_migration_entry_young(entry);
+			if (pte_dirty(pte))
+				entry = make_migration_entry_dirty(entry);
+		}
+
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_present(pte)) {
+			if (pte_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (pte_uffd(pte))
+				swp_pte = pte_swp_mkuffd(swp_pte);
+		} else {
+			if (pte_swp_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (pte_swp_uffd(pte))
+				swp_pte = pte_swp_mkuffd(swp_pte);
+		}
+
+		set_pte_at(mm, addr, ptep, swp_pte);
+		folio_remove_rmap_pte(folio, page, walk->vma);
+		folio_put(folio);
+		*hmm_pfn |= HMM_PFN_VALID | HMM_PFN_MIGRATE;
+		if (pte_present(pte))
+			*unmapped = true;
+	} else {
+		folio_put(folio);
+	}
+out:
 	return 0;
+out_error:
+	return -EFAULT;
 }
 
 #else
-- 
2.55.0


