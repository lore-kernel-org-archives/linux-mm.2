Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC46C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24C56B00C2; Tue,  4 Aug 2026 00:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC6F6B00C4; Tue,  4 Aug 2026 00:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4B16B00C5; Tue,  4 Aug 2026 00:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 703386B00C2
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCB45120872
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:15 +0000 (UTC)
X-FDA: 85062302430.18.25B3719
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 91B3240005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bNeuss6m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfGZlzkw7Q/Ct5X5pPytInsf700IjSbqTVJGP4dmkUY=;
	b=GCwqzuh2TAmyQm4yxAvWmVDHa/BBTDFzVdV2gn9n0gzhM3nh11ZW08WO8s1/x7Hh1vXoHe
	UXcpyfSzUYuX+BZm3E/EEgxRgwmPWpXYokITq89bhyT2H3Uc4Wm7ubmxWuSEZKAHjhOVSm
	Y+rWNKDBnqqZwGHSh/3q4B5swv9pS+I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bNeuss6m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817633;
	b=GK7VivkqrxmHnuJFe8aVZrQBMNKlCtKIbeVw6VXoX8vFxzQEPawk7vnEdjuwqEuFDX2qkt
	bcAKJpUk2qgO2A+c/vNwcvJYc4rZGbjnWj3ma//8Yf36VZNaLi2xXmT5UwKtPYyKu5z5e1
	aNvAkvjipPPOHhI8VswZgh6DB6xm8ME=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XfGZlzkw7Q/Ct5X5pPytInsf700IjSbqTVJGP4dmkUY=;
	b=bNeuss6mCGur5yBWo6R9k+Bce8lQaaOOAIWQI/y2yahhYCpFpDQRpD3Urgx7sTAkL88JSa
	Y+Qk/gWhwl6RDLlsarvJK/6qEnTbGZY99pXsATyUl05ZeOfQe25hSp5TPaN8F/xnnLsj7H
	yZ0mvWknpkyzZr9b8gzZrY+Ho30MX+I=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-3oheLVzEOWG84v-Cnxs2NQ-1; Tue, 04 Aug 2026 00:27:11 -0400
X-MC-Unique: 3oheLVzEOWG84v-Cnxs2NQ-1
X-Mimecast-MFC-AGG-ID: 3oheLVzEOWG84v-Cnxs2NQ_1785817630
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5aebd5e989cso2670789e87.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817630; x=1786422430;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XfGZlzkw7Q/Ct5X5pPytInsf700IjSbqTVJGP4dmkUY=;
        b=qknV2zVMmXACo3epTV4arn56VWttQemp/BYz8rYXvMZGtnW5+MX1mw/X+XvprPruc4
         E/qwrmVj1B1CipGMcd1Xd/f8QxEOdtrpX4GQsYxxCd6zX4nVqzhSh5rwsypNzpQoU9nj
         43hHqooM/k3jIImPQL7kTGb89mVHc4fvsDxoLetXNszsgEwYpYPo0LYI36o/7dcLj28C
         JsuUAb5aikO4AgJXS9EeFcPnpr2yiG8HGZPRtp1uJnpZBzcZOacDKForI3wdNCXtzunH
         Syt21DRLeYF+Z8hdIEp48JKDq/GEM1H2AZqFSKQsI07+nu1ZrsNWCRn7jHQfdpjDN27J
         3mMA==
X-Gm-Message-State: AOJu0YyGrP981JyMLXS/xACvxfxX2NsQvdtdMUoMcchqmx++77vZ9/4W
	z33hlWSALM2xsML0WNvKuKYxswKZ63t+HgLJPS1tzMdhXmN8P0pPHIOdw881ZdKF3H2dly+CyqZ
	F9jfGWuoht1SEz7AEImtrpL/MDh4fZ23BbmDPozpf1GyzozubeW9sBvIJUQPtXdwb6hDkKkORyo
	EJMVpuNH5Id8DBqytw56xJsuI21Dj/qBviGZFTGw==
X-Gm-Gg: AR+sD11Wr0gBU0aL7v564RczIrK1usqCbmu3HzqHu7Pv3WIvGTwDhqICWqNHZSXmvcM
	DQRPIQJoCXcft2KfNtkY4SQiX2IhTVNQKvVZ+SbOf5FTT3d6Btm7OM5y8ExzDDpaMxTeKAtDJ/h
	/rz7uPO4tQ7VotoDDVE89hh8hmsqzQVjh569vYqOCpG5ar0Y2mFUOddTAVNDjTEZzU6E1u40uQZ
	FKVTGVZa+Barcn0zV9zUnb5y+v2kxoqmTO/mmb85SHsSmsfptHO85ajb6GJ8k/+O8HMO9KaQOlQ
	AAJ3PTZ7WMqewwXiLnomYoKMIFLfmowtTFb1HCgGRQ0ycTC4K7nN5NmWPW59IzgZ7Rs54h9lUIR
	N4T0aJ4ktZbY6wAxv
X-Received: by 2002:ac2:55a1:0:b0:5b1:5ab5:e9f7 with SMTP id 2adb3069b0e04-5b2e4f6d5b9mr1644440e87.39.1785817629813;
        Mon, 03 Aug 2026 21:27:09 -0700 (PDT)
X-Received: by 2002:ac2:55a1:0:b0:5b1:5ab5:e9f7 with SMTP id 2adb3069b0e04-5b2e4f6d5b9mr1644415e87.39.1785817629185;
        Mon, 03 Aug 2026 21:27:09 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:27:06 -0700 (PDT)
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v13 04/11] mm/hmm: do the plumbing for HMM to participate in migration
Date: Tue,  4 Aug 2026 07:26:24 +0300
Message-ID: <20260804042631.2175585-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ty60HKbmkty7-Sf0lK3F-iURwZpUTHz_bR03gTS2dzw_1785817630
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4dipyru39jssy7fjyat73ct9h7yybkyn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91B3240005
X-HE-Tag: 1785817633-620874
X-HE-Meta: U2FsdGVkX1+84EvnFp6cqharkRZE/20UT9Cnroznabh1sxZfuoYhdYsfjLgY4kW8swimm9yaNeh2d0+p7PLiaKhSuwUT7cSeV9UTGAftPlJE+UQEE+APqLHTZLPvQS2T/y0yVSXPMJlPklAe8GJnJmVhjn1hKyK7RcQLRMqIUdlHE1OQe4mHncV7KJLhztY5gYgFNJs8hd5a3Lin8sBHbtwyLF6d2bNmybxY+RTq5peiqQZFlBsoRAQoAUTfoTQUm6gcPHW8GR25pnjhj9sdk7bRLLXt7jlWZFrX5cPafLuhN+w0GxPQcfIUgS3iNtuWn+FCsiL5uDqQ8vyMiH1IJpdf+poLiR0BFrZgMuQuf1pBb/mR8Kq6DJArjuerhSdQRh7QO2sLbIugR2KEWbCEJd+pfdVBQF92u5fvS1Qdh177Ylq6ENkXXpeeHQeywjfrcCfAa7G21EYLIVB9ZP0NebHzxfQUjrFSY96SNeEIfIdbYwk5ed+RkOqbWx6sUGB3s8cbM5Z5emtalNoYRy4Mz3tU9jB0jchY1Y77g98CcOEWY8pAm7lwbCrLjknxZ/1GWn7ECDcUH0zkWZCeTtJ/h0l7nXxA1/aYbbHKr2t+mUPlkDWkjtw8FPpZKb5iFe3IbjbUkd1/4AgOwAlnMpLbndzgEgztA282c2j1UtbsNeH88lESuUC2UaDeIqJKMaTijVv4VaiqWQ05o2eJSxH83oCjttrvgOcvmEFSfqS3zeg22VLUvYw3lLS64nT/iktFNgwQEjMdrgtU3SAjNTo5s3LOGrPtUOaw611mb7yqaf1cWVFYoBjEUWcM+LBsjiAEO25g5k7H5d+xkcO1VU/duTCU97KCYMtQozUUc9EhPCbYFvW46Pu/i9i+DOe2dAC+Ia2wzDreLoAxrZ+f4/II0wJs7odvBmsb42IgRTF/mc71TCPg52YUOopAVGMli/D1EAZIVIDtGzVEB1FXJEY
 8nU7wjtJ
 5tKcs0nEKdVh2oLzlviW9FuDwL5Dg+z0x71/SGYts3Z5KoGxpakjR15T7tlmoxrBemK2bkm+akmIHYZNaKNV/CjPTz5bLQ0GjhnwuZNp7Mq7WlIB1/QB6CyyKhz26XwOnQI/MCh5hjoWImTw0HrDiQRjnVJtC9EW1gDKp+0+2iCFKCrmcue5IiHM1wbFsVncFv0EvTRc32idUJQhsHecary5K0vc+qJjcaO3QipThv/mwckNkuGL9xE8lvBIpY0W35cxBn3IRb55XG5drCvAxIZSNgfSv2amGztWV8bH8kPy0Hztz0RawCLTd/5+8cFMlt0aevob7ScunsNXkVQP2NTWbKcbfy4+/fEE2rE5B1sEEX2gLC+OeEYY7Nl35f1IhnqojQx9fZ9PNlXVDC+vPpH4fnO8kbSuZ7jV+DOYQeHDNIU88QqbxYO9e3/QmyRYLpyp3CC+edGbI4A/ZqaOWW3mUlltw8gnMr4AFcbefII1HWR+z83k5YwbNHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Do the preparations in hmm_range_fault() and pagewalk callbacks to
do the "collecting" part of migration, needed for migration.

These steps include locking for pmd/pte if migrating, and calling the
still dummy hmm_vma_handle_migrate_prepare_pmd() and
hmm_vma_handle_migrate_prepare()  functions in the pagewalk.

When doing migration, have to have pmd/pte table locked for the
duration of both hmm_vma_handle*() and hmm_vma_handle_migrate_prepare*()
walks, and unlock when handling the faults.

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
 mm/hmm.c | 360 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 309 insertions(+), 51 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 637c00188b3e..75e19be6ef76 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -39,8 +39,33 @@ struct hmm_vma_walk {
 	unsigned long			start;
 	unsigned long			end;
 	unsigned long			last;
+	/*
+	 * For migration we need pte/pmd
+	 * locked for the handle_* and
+	 * prepare_* regions. While faulting
+	 * we have to drop the locks and
+	 * start again.
+	 * ptelocked and pmdlocked
+	 * hold the state and tells if need
+	 * to drop locks before faulting.
+	 * ptl is the lock held for pte or pmd.
+	 *
+	 */
+	bool				ptelocked;
+	bool				pmdlocked;
+	spinlock_t			*ptl;
 };
 
+#define HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, locked)		\
+	WARN_ON_ONCE((hmm_vma_walk)->ptelocked != locked)
+
+#define HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, locked)		\
+	WARN_ON_ONCE((hmm_vma_walk)->pmdlocked != locked)
+
+#define HMM_ASSERT_UNLOCKED(hmm_vma_walk)			\
+	WARN_ON_ONCE((hmm_vma_walk)->ptelocked ||		\
+		     (hmm_vma_walk)->pmdlocked)
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -54,14 +79,38 @@ enum {
 };
 
 static int hmm_pfns_fill(unsigned long addr, unsigned long end,
-			 struct hmm_range *range, unsigned long cpu_flags)
+			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
 {
+	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
+	enum migrate_vma_info minfo;
+	bool migrate = false;
+
+	minfo = hmm_select_migrate(range);
+	if (cpu_flags != HMM_PFN_ERROR) {
+		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
+			cpu_flags |= HMM_PFN_MIGRATE;
+			migrate = true;
+		}
+	}
+
+	if (migrate && thp_migration_supported() &&
+	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
+	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
+	    IS_ALIGNED(end, HPAGE_PMD_SIZE) &&
+		end-addr == HPAGE_PMD_SIZE) {
+		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
+		addr += PAGE_SIZE;
+		i++;
+		cpu_flags = 0;
+	}
 
 	for (; addr < end; addr += PAGE_SIZE, i++) {
 		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
 		range->hmm_pfns[i] |= cpu_flags;
 	}
+
 	return 0;
 }
 
@@ -84,6 +133,7 @@ static int hmm_vma_fault(unsigned long addr, unsigned long end,
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 
 	WARN_ON_ONCE(!required_fault);
+	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
 	hmm_vma_walk->last = addr;
 
 	if (required_fault & HMM_NEED_WRITE_FAULT) {
@@ -177,11 +227,16 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 	if (!walk->vma) {
 		if (required_fault)
 			return -EFAULT;
-		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
 	}
-	if (required_fault)
+	if (required_fault) {
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
 		return hmm_vma_fault(addr, end, required_fault, walk);
-	return hmm_pfns_fill(addr, end, range, 0);
+	}
+	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
 }
 
 static inline unsigned long hmm_pfn_flags_order(unsigned long order)
@@ -214,8 +269,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 	cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
 	required_fault =
 		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
-	if (required_fault)
+	if (required_fault) {
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
 		return hmm_vma_fault(addr, end, required_fault, walk);
+	}
 
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
@@ -295,14 +355,25 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			goto fault;
 
 		if (softleaf_is_migration(entry)) {
-			pte_unmap(ptep);
-			hmm_vma_walk->last = addr;
-			migration_entry_wait(walk->mm, pmdp, addr);
-			return -EBUSY;
+			if (!hmm_select_migrate(range)) {
+				HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+				pte_unmap(ptep);
+				hmm_vma_walk->last = addr;
+				migration_entry_wait(walk->mm, pmdp, addr);
+				return -EBUSY;
+			}
+			return 0;
 		}
 
 		/* Report error for everything else */
-		pte_unmap(ptep);
+
+		if (hmm_vma_walk->ptelocked) {
+			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+			hmm_vma_walk->ptelocked = false;
+		} else {
+			pte_unmap(ptep);
+		}
+
 		return -EFAULT;
 	}
 
@@ -319,7 +390,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	if (!vm_normal_page(walk->vma, addr, pte) &&
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
-			pte_unmap(ptep);
+			if (hmm_vma_walk->ptelocked) {
+				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+				hmm_vma_walk->ptelocked = false;
+			} else {
+				pte_unmap(ptep);
+			}
+
 			return -EFAULT;
 		}
 		new_pfn_flags = HMM_PFN_ERROR;
@@ -332,7 +409,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	return 0;
 
 fault:
-	pte_unmap(ptep);
+	if (hmm_vma_walk->ptelocked) {
+		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+		hmm_vma_walk->ptelocked = false;
+	} else {
+		pte_unmap(ptep);
+	}
 	/* Fault any virtual address we were asked to fault */
 	return hmm_vma_fault(addr, end, required_fault, walk);
 }
@@ -376,13 +458,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
 					      npages, 0);
 	if (required_fault) {
-		if (softleaf_is_device_private(entry))
+		if (softleaf_is_device_private(entry)) {
+			if (hmm_vma_walk->pmdlocked) {
+				spin_unlock(hmm_vma_walk->ptl);
+				hmm_vma_walk->pmdlocked = false;
+			}
 			return hmm_vma_fault(addr, end, required_fault, walk);
+		}
 		else
 			return -EFAULT;
 	}
 
-	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 }
 #else
 static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
@@ -390,15 +477,72 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 				     pmd_t pmd)
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
-	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long npages = (end - start) >> PAGE_SHIFT;
 
 	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
 		return -EFAULT;
-	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+#ifdef CONFIG_DEVICE_MIGRATION
+static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
+					      pmd_t *pmdp,
+					      unsigned long start,
+					      unsigned long end,
+					      unsigned long *hmm_pfn)
+{
+	// TODO: implement migration entry insertion
+	return 0;
+}
+
+static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
+					  pmd_t *pmdp,
+					  pte_t *ptep,
+					  unsigned long addr,
+					  unsigned long *hmm_pfn,
+					  bool *unmapped)
+{
+	// TODO: implement migration entry insertion
+	return 0;
+}
+
+static int hmm_vma_walk_split(pmd_t *pmdp,
+			      unsigned long addr,
+			      struct mm_walk *walk)
+{
+	// TODO : implement split
+	return 0;
+}
+
+#else
+static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
+					      pmd_t *pmdp,
+					      unsigned long start,
+					      unsigned long end,
+					      unsigned long *hmm_pfn)
+{
+	return 0;
+}
+
+static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
+					  pmd_t *pmdp,
+					  pte_t *ptep,
+					  unsigned long addr,
+					  unsigned long *hmm_pfn,
+					  bool *unmapped)
+{
+	return 0;
+}
+
+static int hmm_vma_walk_split(pmd_t *pmdp,
+			      unsigned long addr,
+			      struct mm_walk *walk)
+{
+	return 0;
+}
+#endif
+
 static int hmm_vma_capture_migrate_range(unsigned long start,
 					 unsigned long end,
 					 struct mm_walk *walk)
@@ -457,46 +601,128 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 	struct hmm_range *range = hmm_vma_walk->range;
-	unsigned long *hmm_pfns =
-		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
 	unsigned long npages = (end - start) >> PAGE_SHIFT;
+	struct mm_struct *mm = walk->vma->vm_mm;
+	unsigned long *hmm_pfns, *hmm_pfns_start;
+	enum migrate_vma_info minfo;
 	unsigned long addr = start;
+	bool unmapped = false;
+	unsigned long i;
 	pte_t *ptep;
 	pmd_t pmd;
+	int r = 0;
 
+	minfo = hmm_select_migrate(range);
+	hmm_pfns_start = &range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
 again:
-	pmd = pmdp_get_lockless(pmdp);
-	if (pmd_none(pmd))
-		return hmm_vma_walk_hole(start, end, -1, walk);
+	hmm_pfns = &range->hmm_pfns[(addr - range->start) >> PAGE_SHIFT];
+	hmm_vma_walk->ptelocked = false;
+	hmm_vma_walk->pmdlocked = false;
+
+	if (minfo) {
+		hmm_vma_walk->ptl = pmd_lock(mm, pmdp);
+		hmm_vma_walk->pmdlocked = true;
+		pmd = pmdp_get(pmdp);
+	} else
+		pmd = pmdp_get_lockless(pmdp);
+
+	if (pmd_none(pmd)) {
+		r = hmm_vma_walk_hole(start, end, -1, walk);
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
+		return r;
+	}
 
 	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
-		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
-			hmm_vma_walk->last = addr;
-			pmd_migration_entry_wait(walk->mm, pmdp);
-			return -EBUSY;
+		if (!minfo) {
+			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns_start, npages, 0)) {
+				hmm_vma_walk->last = addr;
+				pmd_migration_entry_wait(walk->mm, pmdp);
+				return -EBUSY;
+			}
+			for (i = 0; start < end; start += PAGE_SIZE, i++)
+				hmm_pfns_start[i] &= HMM_PFN_INOUT_FLAGS;
 		}
-		return hmm_pfns_fill(start, end, range, 0);
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
+
+		return 0;
 	}
 
-	if (!pmd_present(pmd))
-		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
-						 pmd);
+	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
+		if (!pmd_present(pmd)) {
+			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns_start,
+						      pmd);
+			// If not migrating we are done
+			if (r || !minfo) {
+				if (hmm_vma_walk->pmdlocked) {
+					spin_unlock(hmm_vma_walk->ptl);
+					hmm_vma_walk->pmdlocked = false;
+				}
+				return r;
+			}
+		}
 
-	if (pmd_trans_huge(pmd)) {
-		/*
-		 * No need to take pmd_lock here, even if some other thread
-		 * is splitting the huge pmd we will get that event through
-		 * mmu_notifier callback.
-		 *
-		 * So just read pmd value and check again it's a transparent
-		 * huge or device mapping one and compute corresponding pfn
-		 * values.
-		 */
-		pmd = pmdp_get_lockless(pmdp);
-		if (!pmd_trans_huge(pmd))
-			goto again;
+		if (pmd_trans_huge(pmd)) {
+			/*
+			 * No need to take pmd_lock here if not migrating,
+			 * even if some other thread is splitting the huge
+			 * pmd we will get that event through mmu_notifier callback.
+			 *
+			 * So just read pmd value and check again it's a transparent
+			 * huge or device mapping one and compute corresponding pfn
+			 * values.
+			 */
+
+			if (!minfo) {
+				pmd = pmdp_get_lockless(pmdp);
+				if (!pmd_trans_huge(pmd))
+					goto again;
+			}
+
+			r = hmm_vma_handle_pmd(walk, start, end, hmm_pfns_start, pmd);
+
+			// If not migrating we are done
+			if (r || !minfo) {
+				if (hmm_vma_walk->pmdlocked) {
+					spin_unlock(hmm_vma_walk->ptl);
+					hmm_vma_walk->pmdlocked = false;
+				}
+				return r;
+			}
+		}
+
+		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns_start);
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
+
+		if (r == -ENOENT) {
+			r = hmm_vma_walk_split(pmdp, addr, walk);
+			if (r) {
+				/* Split not successful, skip */
+				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
+			}
+
+			/* Split successful, reloop */
+			hmm_vma_walk->last = addr;
+			return -EBUSY;
+		}
+		return r;
 
-		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
+	}
+
+	if (hmm_vma_walk->pmdlocked) {
+		spin_unlock(hmm_vma_walk->ptl);
+		hmm_vma_walk->pmdlocked = false;
 	}
 
 	/*
@@ -506,24 +732,56 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	 * recover.
 	 */
 	if (pmd_bad(pmd)) {
-		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
+		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns_start, npages, 0))
 			return -EFAULT;
-		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 	}
 
-	ptep = pte_offset_map(pmdp, addr);
-	if (!ptep)
+	if (minfo) {
+		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
+		if (ptep)
+			hmm_vma_walk->ptelocked = true;
+	} else {
+		ptep = pte_offset_map(pmdp, addr);
+	}
+	if (!ptep) {
+		addr = start;
 		goto again;
+	}
+
 	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
-		int r;
 
 		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
 		if (r) {
-			/* hmm_vma_handle_pte() did pte_unmap() */
+			/* hmm_vma_handle_pte() did pte_unmap() / pte_unmap_unlock */
 			return r;
 		}
+
+		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns, &unmapped);
+		if (r == -EAGAIN) {
+			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+			if (unmapped) {
+				flush_tlb_range(walk->vma, start, addr);
+				unmapped = false;
+			}
+			goto again;
+		}
+		if (r) {
+			hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
+			break;
+		}
+	}
+
+	if (unmapped)
+		flush_tlb_range(walk->vma, start, addr);
+
+	if (hmm_vma_walk->ptelocked) {
+		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
+		hmm_vma_walk->ptelocked = false;
+	} else {
+		pte_unmap(ptep - 1);
 	}
-	pte_unmap(ptep - 1);
+
 	return 0;
 }
 
@@ -684,7 +942,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 				 (end - start) >> PAGE_SHIFT, 0))
 		return -EFAULT;
 
-	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 
 	/* Skip this vma and continue processing the next vma. */
 	return 1;
-- 
2.55.0


