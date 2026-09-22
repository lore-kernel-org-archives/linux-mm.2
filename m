Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4F2C98309
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9FB6B00A7; Tue, 22 Sep 2026 01:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1886B00A9; Tue, 22 Sep 2026 01:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4A86B00AA; Tue, 22 Sep 2026 01:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 033166B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:34:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 622C2120382
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:57 +0000 (UTC)
X-FDA: 85240284234.11.11B11BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2CEF716000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HOBNsqYZ;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AT0RwoJ8r2XRPNe8c9sAnpXjwtunlXN+XFUKufZZink=;
	b=3FUExlRwg+tqMDkWpWrAMuoYiU2/DuPaFxMFUPAu2n8C6NBj4x7C7uvxjgZQgEY2KYCMg8
	vJKz9GtLBjBDmaNiEZMrsqS5/VBjcvhlT/H1k0U52JA5Nfv6gYqzzx45egjkgs87UzMWRN
	X6Td2GVK3mXR1I6HU9CaWQq7FRuokl8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HOBNsqYZ;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055295;
	b=7fagNiYFO8Sm9ufA4LFqrMsVahihQJt7j30kRkCGgS5FwkLNnViXHlxieY+kQuJ0itP9Ok
	5UbBivvabnr9E8MZ+SNl9oE4+SHdnhjjTzLe3RtW9NfobZwaJzjDCpyXb1gCRU6qPmyuuF
	ks9JEIBb0rr69LUZRSFc0yLtELnVjKU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AT0RwoJ8r2XRPNe8c9sAnpXjwtunlXN+XFUKufZZink=;
	b=HOBNsqYZMM+GhWXjnf1OcFXuZe3S33usCEnkthb1xHvqOXodOlljgmm5MNw1qsaBNIOp2w
	DUX5NlYjx+TSn+an+XSJtF5/3x4j71r/ft/dAcjEYU6Qf0komstZzMjZkoFAwQDwx8SxND
	YDitMYol48fTFr8ioJR4zBu672B8MC4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-lA2BxQmyML2XSAenhjhNtw-1; Tue, 22 Sep 2026 01:34:53 -0400
X-MC-Unique: lA2BxQmyML2XSAenhjhNtw-1
X-Mimecast-MFC-AGG-ID: lA2BxQmyML2XSAenhjhNtw_1790055292
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3a2005c865aso15778451fa.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:34:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055292; x=1790660092;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AT0RwoJ8r2XRPNe8c9sAnpXjwtunlXN+XFUKufZZink=;
        b=kkN3+2eshHRKoHSW+EkzsLvMjSgr3XraqBC/T2Kx1/gEQJmQcSS0rQHNxd7rdn89BL
         1+cX5LuGDMUO9y0MSzXggFR/UVCG+Xb536CKIBh5XOQP46Dw66WuUtI/DVE3y2GLXJV2
         e9fJnEm6ojszOcdTzWkKYqcqcaZc5zFsdmzsmMMVnZgt6PnSzmS8CgdqVSfxG9Opr3LL
         Su5pMDdlUZfn9H0aE4OgVga4CQ+FC50rd6Y4mXporuaakihhCyEeElcJC8kebILx+/Vh
         N0FE1YeOYJwduPzRI/SgwWpmY2imvbydiPgFgnlfw/O5c0saQbw1jw6+4Bgx5/f5ACrh
         sfgA==
X-Gm-Message-State: AFuF++kwB/Rlg3G6GQn3ZfUkK1Hy5w+8pKzaUi/7ZIXZ4ijzAUSSLRUr
	W0uZb6zsjuBu3vigAXQdns9OfJTHZqClNtmJY9VN7rJ6Z+PXRiYvBt7g5A3OHZipyukpgeitfOM
	dgKG/I21Eo4qrp0VeZxXgfKn3oCHpP0m+uy7kgjc/jdsUnxEHAyvUaWRng6u1kSMOaZW+ecDaC5
	XLi54Xo4xWll+/ilmionzodVWeCEZCJH3zEOf3nQ==
X-Gm-Gg: AYBFou136uzoda9MhWoQYLVmlMvHNe65ciKAJT2aC2yz95qJTFWj3h3WqTsh7xcmUnC
	jEwypCu78bKnHDqMQkwu13nw1w0RxL2FlZFUKH7uid9jnXu6Ej95a2Nj+IPlWJPG3/NP2qG2lsZ
	CU56u6+KnG8rmehf03jBPt+zPS6zjHah/tJ7SnYADsY0iRQmPu2ultI6zqORDdpeiWcds90TY0h
	RLb0biicG4mYW7uvDLhxQmMFqAb8c89mFdeUvuhKxtLxZ1hp3jVWfVEHoMArFTcYyDWdQDofv8G
	/aHWu83otbW0aOyEcZXa2VPR6lmh25IhC+FCPXOFsQNEeV956N4ykCSlGpIj2PmR93UlbITzCDV
	AY2Te6E4ppekPuVd1To/f
X-Received: by 2002:a05:6512:39d1:b0:5b4:24a3:ecf9 with SMTP id 2adb3069b0e04-5b8c180b6ffmr4840065e87.21.1790055291567;
        Mon, 21 Sep 2026 22:34:51 -0700 (PDT)
X-Received: by 2002:a05:6512:39d1:b0:5b4:24a3:ecf9 with SMTP id 2adb3069b0e04-5b8c180b6ffmr4840036e87.21.1790055290968;
        Mon, 21 Sep 2026 22:34:50 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:34:49 -0700 (PDT)
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
Subject: [PATCH v14 04/12] mm/hmm: do the plumbing for HMM to participate in migration
Date: Tue, 22 Sep 2026 08:34:13 +0300
Message-ID: <20260922053421.4092027-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nViFkGb8BB6ue36hLWqBkhw9QeAjhddPei-h7xm64NM_1790055292
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mwuxy6zcrm899c95tq4zjjanbb4o6fn9
X-Rspamd-Queue-Id: 2CEF716000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1790055294-481652
X-HE-Meta: U2FsdGVkX19/oE26WzBnfIR/ggEhhlkLrHASYXiguEmhrWzJAW2mS7WaoHD3fgyDZa8P+qYn0jqJfsE8fTQFLcubvVKrQYPR/pPRWBHZfd0H2y9khX7NeapWBdhqGvYtHVu4fRDrM0wx738syMBNCdk/uthjv5ESrpFimQQgfeLlbxe4kA0DA1KhWfos6CV8Hs8veVuJVMktKnLsiNKMqG/rXPyQaFvn087sSC3ZEOEIH/l30iIUMm/7uJMiyGt0arr/1V9xsPD7QmDuzzqhG9ppy6mfwbv7dAiMvAbNIwYdQdnUcHcvKIDePldJuAZhdA1USn9s3tLxdpEBGfciaQ9fcSEmfRHshBhDFJxSRLt//uw4FnVE9fRcd2ZBX270SQ8bNVwLcigTUrnwVcCuKcOvyeDGyHw6iI0iAKsfM1kYKinsnbNPgKeLwq1GD/C0/5GTO4zPhSW4rj3HpKfm9jM+HoXHUSjuQkthfF4DNEhXC0/qEPcnK0kmwM0n2JtBVsZL6eipmUwDSgVwUtds5Blf44uGo3Uej8YZyw7y/NXzQX0ym2gotYr3NyKyDshKqpGS2/anhuCTZW99woeKZ+DgMrl858HePD1rNII4d1M3DDUzhAEzTIVwvIxok4RMxw1CzlqDpqhWTTVDq1aYwtgcL8NFDBEAibnjjMSwvLZzjHyK0HrZ/OV5cjLlb9KperhF01HpaVxBzng2mzDLkcbrQmmi3vCCnSCg++EF9O1q3Bxq7VaiQBDxo11KAbqZo7WtL2SkAXJIaxiN+9Q0SXdQUrWiu0OIODPVxSljtRQoVInaBwaNKSF3bHe2OGuLB9vMcCOfdWuxaMcUddenImKSafApNqIxQ3QJm66bjr+L8I6AyioOrkSU85y3ptcyKMVnx7AJPMOzs6pA1TRxqhPaD/hswU2tu2ETh7zH7yKgHe5DODeMCp2Aw6QMYBkWKOSMB85DVVjps9y/rad
 lkIYG27U
 AIVpHk/ZUtLqmLQAl99L3T5IhfSKlVlKEuV+B/ZKDk3b6Qp2aX6RAHygdtG8RHt5U3yAEl0z035ax24jtzCGc82mKxQeNn1/1KQf9fnH9Nbbi7Frz3/07Y99PrhwK39E8VzPWNlOP8ujqTwTfujbwm1CqpzkgAyvrWdv/wdape77LsbJIRQLCrT+EBW6VPv0CrzEeNN269ifxj1/O7N3XLZXQdVAzGzxH9THwNkqm2OrfE5QzYi0xrgrsS17EzYr6Vmk3sZqaLKLJPScylFHzdq52vk5rjrwEip6VJ48GNYmScG75ff6Gvcj/HMRCykeK3E4t57h1vmzXj/qMrrFVHokrjCQCvldU3ZZdtCTRiqS9CUvYAl//zJF/yyUvHChOXcR0QkTYY5ROCr1/TpZmn3T1kW/SRkcedPSFsWgi+LWljFONgy/pIFGkT9HQRdizFJBIayVDFHEJh3uTaKRCG6wkynZFJQ6FKy+u+7RN261ua7PEIDP5ssQ8xg==
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
 mm/hmm.c | 361 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 310 insertions(+), 51 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index be39d2e5403a..4805c88347e6 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -40,6 +40,16 @@ struct hmm_vma_walk {
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
@@ -61,6 +71,16 @@ struct hmm_vma_walk {
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
@@ -74,14 +94,38 @@ enum {
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
 
@@ -101,6 +145,7 @@ static int hmm_record_fault(unsigned long addr, unsigned long end,
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 
 	WARN_ON_ONCE(!required_fault);
+	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
 	hmm_vma_walk->last = addr;
 	hmm_vma_walk->fault_end = end;
 	hmm_vma_walk->required_fault = required_fault;
@@ -185,11 +230,16 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
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
 		return hmm_record_fault(addr, end, required_fault, walk);
-	return hmm_pfns_fill(addr, end, range, 0);
+	}
+	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
 }
 
 static inline unsigned long hmm_pfn_flags_order(unsigned long order)
@@ -222,8 +272,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
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
@@ -303,14 +358,25 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
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
 
@@ -327,7 +393,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
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
@@ -340,7 +412,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
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
@@ -384,13 +461,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
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
@@ -398,15 +480,72 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
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
@@ -465,46 +604,128 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
+		}
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
 		}
-		return hmm_pfns_fill(start, end, range, 0);
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
 
-		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
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
+
+	}
+
+	if (hmm_vma_walk->pmdlocked) {
+		spin_unlock(hmm_vma_walk->ptl);
+		hmm_vma_walk->pmdlocked = false;
 	}
 
 	/*
@@ -514,24 +735,62 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
+			/* A non -EAGAIN error here means migrate_vma_split_folio()
+			 * already dropped the PTE lock and cleared ptelocked.
+			 */
+			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+			if (unmapped)
+				flush_tlb_range(walk->vma, start, addr);
+			hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
+			return 0;
+		}
 	}
-	pte_unmap(ptep - 1);
+
+	if (unmapped)
+		flush_tlb_range(walk->vma, start, addr);
+
+	if (hmm_vma_walk->ptelocked) {
+		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
+		hmm_vma_walk->ptelocked = false;
+	} else {
+		pte_unmap(ptep - 1);
+	}
+
 	return 0;
 }
 
@@ -679,7 +938,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 				 (end - start) >> PAGE_SHIFT, 0))
 		return -EFAULT;
 
-	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 
 	/* Skip this vma and continue processing the next vma. */
 	return 1;
-- 
2.55.0


