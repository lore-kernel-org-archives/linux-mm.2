Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8FF9606D80C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WrrhyJ/4
Received: by kanga.kvack.org (Postfix)
	id B7D7A6B05B6; Tue,  3 Nov 2026 01:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BF26B05B7; Tue,  3 Nov 2026 01:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43126B05B8; Tue,  3 Nov 2026 01:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75A136B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:17:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5157A04B0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:00 +0000 (UTC)
X-FDA: 85392799800.06.B784408
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA286140009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:16:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WrrhyJ/4";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793686618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99uxtdkQjWEJhSRcDS+4tTTQxZwaAUCdW62+5t5LY70=;
	b=oAjLVYA1OiX1zvdTaH1Tt9ARe+C4sP1v5OQiZrEkh4Q+Z7J0JVnJDBnjjzsIvtacQNNYkN
	5beAY5oGqkgFVOEWWm5EC7poAtoNwQrx/FdaGZEzgV4vNRZZVlbcMnQZMEZIvVhkgyvT+F
	dfAX9JNKktJWt2TvMUZEXXwb0WWRUJw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WrrhyJ/4";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793686618;
	b=KrUCRAaOF+Cj+kMNa+96SXzfc64LteNnn5iExqUa52nRSu4J1qRA5pQBh/YjDDmA7i1GDu
	J8dQzBXV+Se92qdK/i/52H+1MJL3Yvu4iZuA22lmEb+jDIdL+AdYtj7jdVn1KTgOX22TM3
	XRH1ZUhEOx2+VlgCFDfOLZMQiE0VI0g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=99uxtdkQjWEJhSRcDS+4tTTQxZwaAUCdW62+5t5LY70=;
	b=WrrhyJ/4ZP/mw10/P3FIUHX3/bRRFmnfLPea+FCFaDreVGMjQWF70KVr4mEuy7ivjrKUlp
	SFdhmnXLiqgPUCDdKAqZKn4tJnw7FO+JqHNxJEZbQ4Bqk7Stl+ePLPcJB/qJj34dPYN0Nu
	NcS6ArOlTwRDqaJ2t3NqrlyqO3quW5c=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-lGvu8xUcMGCaBp2We34I4g-1; Tue, 03 Nov 2026 01:16:56 -0500
X-MC-Unique: lGvu8xUcMGCaBp2We34I4g-1
X-Mimecast-MFC-AGG-ID: lGvu8xUcMGCaBp2We34I4g_1793686615
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3acd67793f2so2051461fa.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:16:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686615; x=1794291415;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=99uxtdkQjWEJhSRcDS+4tTTQxZwaAUCdW62+5t5LY70=;
        b=y8e0ZxcOydEk4rhNkCRE2mAC+Dlt2uYEt0zIUN05Qdm5+AI86Ng8ObpGiztAwl33w7
         owegW9mnqJPO7uQ6SuiE8rCCvQEA2X8A/vLQUfsP+YruV5c6ij+h05rdGXzk4VWNlxk4
         T2bfea7KKwpIY2xcLXeYn+3R74SFBG29Sba51ftbbr8VKpVqH2RpUSAsGEFnOvoPSPY0
         QCnzPS8Y1l3OyHko3ZyZDgQ+5L7J+4nYiG4RnNYGx60ZWVG6+ftjUjWb00wKBpU+lsr+
         x5ClFF+s9YiliQxEzs9S8rp4Vb+pM3xTaZjkppxWL+SRHyT/CNU0wTHXtrL6g5W+XMR4
         bxgA==
X-Gm-Message-State: APuU4Z/CHhl31mfi9sQoAgr42PDC9/VCho26Qqi0q9jdDJ9ecgSmjH2R
	QDhVVFHd9QxzXEmy962gQGXsi6zboGTFEUvgg4I+IVCMCiSxyMUlra38qDijrsSeYe1Xv6TwSdw
	EbqsFA+Jtm2mtOPoS+0RLSTRJ858DYNEOGfEx5Y1AcD7bkyewUyKZ2uuWFH6tpFmiomeggT1ZsR
	fHyylDQZV7p5W27PqrO7T+aZoSUFuBEwqOrz9gLA==
X-Gm-Gg: AYBFou0DSV2YcSoTDbsm/qPkRM3QHkvgQDPAezg9O8N0tKDuBKKZ9rpyBRMfEwdAk+E
	8Dvra0YKeBhQdz3MyMG7o7BDoQQ1CV4vQVn1fqDUogPlA8HtP3vtRcJD5N6g9zqmS1sZnBCdsX+
	5qQ33lm8ZY/ZMd5Ghad6tqe8v6hM/s9+fy/zF5eg79lXTbZ8TA8Ma1/qNK65myoOPdqVBoPP/MF
	rHqWkP2rvg+AXVeVJPIEEy7RJhqwtJdt1hd3iAztZEDd80nyZmMU1uvTxptlVyfrEQ0mF9gkAnT
	yxrSQkho8bSqu0XlUmjhyA4q/xKFqA8mZAiOUPykamniOhMH7upHXgIlf5M3+r3Bpt1pFcrz1/K
	yTaTrk+gP/rGXd9JJN/M0yG5hgNj+vm3JSV5umgiPZ43yRf3jtdWLohHrLB2I/2FRYSLpjg==
X-Received: by 2002:a05:6512:400d:b0:5b8:f8f9:e080 with SMTP id 2adb3069b0e04-5bfd957ff38mr4223834e87.26.1793686615245;
        Mon, 02 Nov 2026 22:16:55 -0800 (PST)
X-Received: by 2002:a05:6512:400d:b0:5b8:f8f9:e080 with SMTP id 2adb3069b0e04-5bfd957ff38mr4223807e87.26.1793686614660;
        Mon, 02 Nov 2026 22:16:54 -0800 (PST)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe073e0f9sm1964634e87.54.2026.11.02.22.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:16:53 -0800 (PST)
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
Subject: [PATCH v17 04/12] mm/hmm: do the plumbing for HMM to participate in migration
Date: Tue,  3 Nov 2026 08:16:21 +0200
Message-ID: <20261103061629.972669-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103061629.972669-1-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q_pCFCU3n1ibhTCc21WeqNMnXW-ESEfCrayerMWmQZ0_1793686615
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA286140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ziwpypn5dgr856djyajai4fnkcaiew4g
X-HE-Tag: 1793686618-613864
X-HE-Meta: U2FsdGVkX18euLAotfGbpmQSCeiJZnvB21FU6cRic6OcW5xwJy/i+uI9km5aHkHqhpGYD5x87ynNB3h06dcuA70TbRY87ada361IYBRqjfprZnqnBN5o0hR8LVo2BJneePAGe07KlR5Yqoud2miymc7AvsPWhicBD2/LTxACyh2yb00IWoOFx/+EYXCRGH2vgEafUkSBbkI8vMdjYCc2cc2dDZGkqfCa0gGqBKCIealngKo1x3k/mmw79IIYHnkK+q48NVQsuMZH79fzzCyGUFRlx2n0s42Spj+DYQ7hexhueajx03UqfSjyCrhAEz4bpNGVZgUIRv3QKHSh6Lk66h7GhixkfppZWA+ORTLL1NLAAaAxTfsz/OoKi0hRqxQv9ygbVglfXa6JuzxFAV0VMJn8wU6MB1ITfrSm+zL53eD7JifPlo21bJdowii2EPxo3qHMgyy7Sxv4S0KxD3XI4mOZkhy8jXuzESVNcJMCap2D728DZb3KZ8uaegHjSZIugnl0DncAuaNZk1j65cXbKlKrjuNGMtpbBZI3VOYm23dzSwZ4almIlDcYeuxGl3jvMyXPriSZw+//vpEe3SXOT5gL0CpBemYy3VeP0uBrgJA9Cbop+G64GWNbnBsNeaMyChBrJbxCUXkYfUSpmm+9BOsNLnLMJ8cyMbcEhX4cs4iR2DyhxnSC3HGJPycR7w0jj9oVjpmUnyW1zWLir5iza0RmeZYbwLbHICTmIQs2d0dhrcequh1+fNs/CEH4dEtpRlRtzpZEG9O1iWPWAwQ6ek0igJyjGrIuS5ccPCF+qXH8onL4dVkwwAqmtzOSS8EzEZ44tQcoJO2MNwUZp5V39gCPlruPiTRN8S/r9/nXFsq6pDiGFVkbRt+IWee0T0eVtwsz95KX0bFFG6aYxK/SHfSW4klctgmdVT7XEYXYAsTFa+9QrAkPX/OWU2/GB0uRUv870WFgkByycsIHRPT
 H/51LNRb
 ev7zQcFSPA2zdXEhtHLj0z1zOiFNWEhJf7UQLETME32+3qw1pb2APZw5WTM/LIPZn3EPsDHlchqb9R0Jiuf9ti9kpGEeO84+V7PGEX0ouPdtXFShSB/VXUXSRQyklNqa+YDKvd6t/RJEiVvf3TxnAFKRjB0Y60Zk3Mlzuz1oO8/KN1EgxqqQydOB6XDyXmKKq6Jb1FSuyUxbB6koPDhoMNRml9A3IkWK+9sevt8pUZm1CEXUWFkdSRDb0AoSzITUVT5YbqmHQAh4xZ4tQ6uNEyeF0YXAF3qSWkfYlWuBugdsF9eKGfmepXWPqdWaEfLN/K36zdKdZH48EOcst8dDIKury9qRRW5yJhqAenZ72exdF/p3AsT80ORHqCsYtseM//+l2jVXeYsvpnwN7aJ13UeqlsS0tFZRSdgeJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 mm/hmm.c | 342 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 295 insertions(+), 47 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 9220e6648636..854d2c090b20 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -42,6 +42,16 @@ struct hmm_vma_walk {
 	unsigned long			start;
 	unsigned long			end;
 	unsigned long			last;
+	/*
+	 * For migration we need pte/pmd locked for the handle_* and
+	 * prepare_* regions. While faulting we have to drop the locks
+	 * and start again. ptelocked and pmdlocked hold the state
+	 * and tell  if need to drop locks before faulting.
+	 * ptl is the lock held for pte or pmd.
+	 */
+	bool				ptelocked;
+	bool				pmdlocked;
+	spinlock_t			*ptl;
 	/* fault and lock drop related fields */
 	bool				*mmlocked;
 	unsigned long			fault_end;
@@ -63,6 +73,16 @@ struct hmm_vma_walk {
  */
 #define HMM_FAULT_UNLOCKED	-ENOLCK
 
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
@@ -76,14 +96,38 @@ enum {
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
 
@@ -103,6 +147,7 @@ static int hmm_record_fault(unsigned long addr, unsigned long end,
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 
 	WARN_ON_ONCE(!required_fault);
+	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
 	hmm_vma_walk->last = addr;
 	hmm_vma_walk->fault_end = end;
 	hmm_vma_walk->required_fault = required_fault;
@@ -187,11 +232,16 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 	if (!walk->vma) {
 		if (required_fault || hmm_select_migrate(range))
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
 		return hmm_record_fault(addr, end, required_fault, walk);
-	return hmm_pfns_fill(addr, end, range, 0);
+	}
+	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
 }
 
 static inline unsigned long hmm_pfn_flags_order(unsigned long order)
@@ -224,8 +274,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 	cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
 	required_fault =
 		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
-	if (required_fault)
+	if (required_fault) {
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
 		return hmm_record_fault(addr, end, required_fault, walk);
+	}
 
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
@@ -305,6 +360,14 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			goto fault;
 
 		if (softleaf_is_migration(entry)) {
+			/*
+			 * Someone else's migration: when migrating, wait in
+			 * handle_mm_fault() via hmm_do_fault(), outside the walk
+			 * and with the migrate invalidation closed.
+			 */
+			if (hmm_select_migrate(range))
+				goto fault;
+			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
 			pte_unmap(ptep);
 			hmm_vma_walk->last = addr;
 			migration_entry_wait(walk->mm, pmdp, addr);
@@ -312,7 +375,14 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
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
 
@@ -329,7 +399,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
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
@@ -342,7 +418,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
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
 	return hmm_record_fault(addr, end, required_fault, walk);
 }
@@ -386,13 +467,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
 					      npages, 0);
 	if (required_fault) {
-		if (softleaf_is_device_private(entry))
+		if (softleaf_is_device_private(entry)) {
+			if (hmm_vma_walk->pmdlocked) {
+				spin_unlock(hmm_vma_walk->ptl);
+				hmm_vma_walk->pmdlocked = false;
+			}
 			return hmm_record_fault(addr, end, required_fault, walk);
+		}
 		else
 			return -EFAULT;
 	}
 
-	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 }
 #else
 static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
@@ -400,15 +486,58 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
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
 #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
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
+#endif
+
 static int hmm_vma_capture_migrate_range(unsigned long start,
 					 unsigned long end,
 					 struct mm_walk *walk)
@@ -483,46 +612,124 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
+		unsigned int required_fault =
+			hmm_range_need_fault(hmm_vma_walk, hmm_pfns_start, npages, 0);
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
+
+		if (required_fault) {
+			/*
+			 * Someone else's migration: when migrating, wait in
+			 * handle_mm_fault() via hmm_do_fault(), outside the walk
+			 * and with the migrate invalidation closed.
+			 */
+			if (minfo)
+				return hmm_record_fault(addr, end, required_fault, walk);
 			hmm_vma_walk->last = addr;
 			pmd_migration_entry_wait(walk->mm, pmdp);
 			return -EBUSY;
 		}
-		return hmm_pfns_fill(start, end, range, 0);
+		for (i = 0; start < end; start += PAGE_SIZE, i++)
+			hmm_pfns_start[i] &= HMM_PFN_INOUT_FLAGS;
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
+		return r;
+	}
 
-		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
+	if (hmm_vma_walk->pmdlocked) {
+		spin_unlock(hmm_vma_walk->ptl);
+		hmm_vma_walk->pmdlocked = false;
 	}
 
 	/*
@@ -532,24 +739,65 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
+			if (unmapped)
+				flush_tlb_range(walk->vma, start, addr);
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
+			/*
+			 * Splitting the folio failed; migrate_vma_split_folio()
+			 * already dropped the PTE lock. Don't migrate the rest
+			 * of the pmd range; addr keeps its valid pfn.
+			 */
+			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+			if (unmapped)
+				flush_tlb_range(walk->vma, start, addr);
+			return 0;
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
 
@@ -696,7 +944,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 				 (end - start) >> PAGE_SHIFT, 0))
 		return -EFAULT;
 
-	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 
 	/* Skip this vma and continue processing the next vma. */
 	return 1;
@@ -833,9 +1081,9 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
 			hmm_vma_migrate_disarm(&hmm_vma_walk);
 			ret = hmm_do_fault(mm, &hmm_vma_walk);
 			if (ret == HMM_FAULT_UNLOCKED) {
-				if (fatal_signal_pending(current))
-					return -EINTR;
-				return -EBUSY;
+				ret = fatal_signal_pending(current) ? -EINTR :
+					-EBUSY;
+				break;
 			}
 		}
 		/*
-- 
2.55.0


