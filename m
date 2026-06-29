Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF7FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2096B012F; Mon, 29 Jun 2026 11:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9996B0130; Mon, 29 Jun 2026 11:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8356B0131; Mon, 29 Jun 2026 11:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E61306B012F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E3B681A018A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:23 +0000 (UTC)
X-FDA: 84933271206.12.A55E5C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2A6DDA0019
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUPtlzEK;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745462;
	b=Xh7EiqKBZcEt3J111Oh/EkUIJMItpEyzw+S6gWkdZW+gs5vMMlvn8i/tngK2RULCpNOl1a
	bHKyYLgDytm6WyMJBV68o4qS2loIrmtiOt8LozlXgE0C40CHSVbbTFHD+GCjW/GBnWoszv
	WFctu04khkggaEgC2gfM0aazBTlh8bk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQuOZwRRSLgdq/8aIs43CiqhUZHBoxvkbrFwRYFQ2B8=;
	b=XCxrkPqci33ER4zIuwQmxxrDn1tUoBPW+VvVrTrb41zwEdYm97oZuL3ZXvloxMjN/VukRI
	xpYbbSWhIdI6ihCR3LRErxpogEZ23W/KdVjFZOT3JDXOguNjpgwqy/XPGXgE0wk2tEmgQm
	6z+LT/I6IwlUwbwhB80iVNP1n0G6LeA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUPtlzEK;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 672C2411F6;
	Mon, 29 Jun 2026 15:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C15E1F00A3D;
	Mon, 29 Jun 2026 15:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745461;
	bh=IQuOZwRRSLgdq/8aIs43CiqhUZHBoxvkbrFwRYFQ2B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUPtlzEKm/rkK6U+RL4o276C7CM2BimGalFca5bTDLE9z/wmgRZXass49O8oTQFHY
	 2KPBHFB1eeyPaLTY3yF3uCC324cMvlFBKDH6sFS+gtSHrhSWPjZChqeERZxNdtcabl
	 zMz+DfH+0Nh9+eojzTPBFkhNvZ99WcGVAlnr3492c26LktU4aUB3Ny9RZV2lHFDMHP
	 xPvgub2UUsQYVWdpclSUlc5izTcgxx+p6XqNIIrCLfEGBKj3ea2gK5V+iCcqysOW+0
	 r8Ls9jiToShkehH/mh2L1XdNB9gtAo+LXRheGe92dPtnMxNI47ugeLviDGLw+YUgl9
	 VaKLRv269RGcA==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 07/10] mm/rmap: track whether the page VMA mapped walk is anonymous
Date: Mon, 29 Jun 2026 16:03:47 +0100
Message-ID: <903a8f049fc04e82feba3fcb8b2b9b911551d275.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782745153.git.ljs@kernel.org>
References: <cover.1782745153.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A6DDA0019
X-Stat-Signature: x98ht5p6pdx3qgxdt4oarxdkm4cr7bft
X-HE-Tag: 1782745461-927793
X-HE-Meta: U2FsdGVkX1/KPiJlkIbzbINRo28rN966uRAZ7pfeH3RBW321kLV3HACE8z7j28vLG96dWUxauVF3BSkDY5M1v/LVkU2WiI/iNOX1aMzhfdM+xDil+WC74UAhoPuhRtX/XBNEEZ9VZbc1iSFRqHFsKmvUzKU2VV9/D9Ti+0RS7qB+Fe6+Skgj87DPGClUvDsqguexddr2TjA9Cw1d2xIAcnrK6MVDV8LwhcURqxjLxU2o5e6E0t4glWB1+chzYgWB7qcooqjP0cvMMSz/K0EXD1qmluJLP6Cyn4J+jGveqQ0ELRKtSjLq6IP1AgFfSJ4+k9qHb2lndpPCzPvXMOSLOo2z1H2Nc0ps2Jf+IEaJQDu2NZ9dOjiIVXR4HCmzFCWYrbP37TmcnPqsx4hpzFptz+kEXtLhP6uj773LR57Mr3RkRaRbM39E6SzjcC7Bqcyx/qPiFuFFJiB9AQ8Qltir8vPxHyVf6eSp60oUFtiXrrSQHWU5Ui9IDZy5Hp9UipiOMyrM6lsfoNDTgSVs/UIHLuS7jTjRpww/TivY4NsF9l+8Mw9AGqgKNZyJF6Ci7nGX5XPhU3K948N11ll6QQYyNYW2rmaP2uL5JO9PS4jH7UPOLyAF8SCKJnorZS1R/dkGkTtTCHLS4ayCMeinBLS8B+CxFERQCF+sCKyttKNJF/mho0TKZ/WBH0YBwqLWInuiuzrDWnLQVCU45Se0Bm0b4rMWdrzUhwg85giVlsxa00SdIM32AhtRceeejqj4qtdymIj1ti/cbvGtHLVjX9EfIVVVu6k0/M+vgzCsQ0twL4nVjTDRxXOWUSdimdh+nw6nTAk8agSpInsLwGhHTpjma04VsLL4cfDXDol7mPiwrWiFInFA1HDiDt8O01FuBvIUau53h5DiS6KMdUahkcWknDkcC7c6D/nAmMayV1lBOYHPfbMyi1xeygUek8UiXgn/o/nkTCKRbyp11Mcm4WC
 IeocjC72
 /SIsJGKqlb34BU8TerEO+eikb8JddLius9odQolEdFRr2p6psBxT3T2eAlI/5s+ma9qjD/e4l19OYrO28kZmZj+SAVJWSNiGhTuy6squIcZQ84ZWSTxCMv1R9iEg0buimupXgjAkB6U//a2wGMwQ3c0MW3Gze8+0TTtEcG14Co5L92layE9SHTUvI7vU5gDaz7awROhUKaeqZsUkbOGx+GTOtWjGIQ21z+2PcyEh92/F35O9u4nMLdfT1HPJqdx0oq9DjD60Rs8ZaR5Bj8Enip10ODGfFydLDlX649vVa56wXRWlpNCcYZrMGDdFmVk0BRG8c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the page_vma_mapped_walk structure to track whether the walk is over
an anonymous folio or not.

This is necessary in order to determine the correct VMA page
offset (virtual or not) in vma_address_end() ready for a subsequent change
which adjusts which page offset to use depending on this parameter, and
update the comment slightly.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/rmap.h |  2 ++
 mm/internal.h        | 13 ++++++++-----
 mm/rmap.c            |  3 +++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..a48ae9575bd2 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -871,6 +871,7 @@ struct page_vma_mapped_walk {
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned int flags;
+	bool is_anon_walk;
 };
 
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
@@ -881,6 +882,7 @@ struct page_vma_mapped_walk {
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
+		.is_anon_walk = folio_test_anon(_folio),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
diff --git a/mm/internal.h b/mm/internal.h
index f1e7e6256b4c..120957a7850c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1298,22 +1298,25 @@ static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
 }
 
 /*
- * Then at what user virtual address will none of the range be found in vma?
+ * At what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
 static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
 {
-	struct vm_area_struct *vma = pvmw->vma;
-	pgoff_t pgoff;
+	const struct vm_area_struct *vma = pvmw->vma;
+	const pgoff_t pgoff = pvmw->pgoff;
+	pgoff_t pgoff_vma_start;
 	unsigned long address;
+	pgoff_t pgoff_end;
 
 	/* Common case, plus ->pgoff is invalid for KSM */
 	if (pvmw->nr_pages == 1)
 		return pvmw->address + PAGE_SIZE;
 
-	pgoff = pvmw->pgoff + pvmw->nr_pages;
+	pgoff_vma_start = vma_start_pgoff(vma);
+	pgoff_end = pgoff + pvmw->nr_pages;
 	address = vma->vm_start +
-		((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
+		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
 	/* Check for address beyond vma (or wrapped through 0?) */
 	if (address < vma->vm_start || address > vma->vm_end)
 		address = vma->vm_end;
diff --git a/mm/rmap.c b/mm/rmap.c
index 0bdb65852222..a3e926a708b1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1240,8 +1240,10 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
 		.vma		= vma,
 		.address	= address,
 		.flags		= PVMW_SYNC,
+		.is_anon_walk   = false,
 	};
 
+	VM_WARN_ON_ONCE(folio_test_anon(folio));
 	state->cleaned += page_vma_mkclean_one(&pvmw);
 
 	return true;
@@ -1317,6 +1319,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		.pgoff		= pgoff,
 		.vma		= vma,
 		.flags		= PVMW_SYNC,
+		.is_anon_walk   = false,
 	};
 
 	if (invalid_mkclean_vma(vma, NULL))
-- 
2.54.0


