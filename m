Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18DBBC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24E56B009F; Wed, 29 Jul 2026 12:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAEC96B00A0; Wed, 29 Jul 2026 12:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEBC16B00A1; Wed, 29 Jul 2026 12:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 936B86B009F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:50:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 044C54077C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:05 +0000 (UTC)
X-FDA: 85042401612.09.F3F8B31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29F57A0008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZsre0Pw;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mOY2tRVEvGkY0yTiPgUewN8py54kSX5AHzNPcNUQhw=;
	b=uHnh5G9qOVLTYqqEZAeNK+NHD4O27U1bol36AiOjhU9z9WiDh1Klgg8EyjDQD0VvcmXzkg
	75xchbKW14ZWNlwN2jWbYuesk4SM2/Sd0Ne670YBtALPYzoxRrzo/Mk64jg05J1bkNw+y+
	ib3lKjzTRns3G83w6hGCZ8CBy7VQCVw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343804;
	b=WKH6BXvZ9ex27lY0mrBmaV9CKwaQhGg716OkoM5NevovqTS7wP/EwKcpeBF2lswALLP08C
	sMSsftJRDT/Zuc4NRilKkX2NGjn2F1u82a8nWkQb/P1uYTSSNLI0DnkDjzlUr7G5dPjAws
	ALidPCYBbKjceHz0kKiKZxOLA3IGPho=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZsre0Pw;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6632441FFD;
	Wed, 29 Jul 2026 16:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A6E1F000E9;
	Wed, 29 Jul 2026 16:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343803;
	bh=3mOY2tRVEvGkY0yTiPgUewN8py54kSX5AHzNPcNUQhw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NZsre0PwgRZlHfbyFdxByTmlEwRhYdKx0qIduaLvKEDkN0uCoghZNZ/B5msbqL9a0
	 oYejioiTMikzBdcYjzPvFSBJKlm4l8sm6p0Ce1aydSGIJkoPiDHGjIvZQ5yS5BO2Dq
	 9Qh7O4cLvimf6W5Bk8Z9KAjdKCN6n6Ru22kX1Ak8uIqGmddO1okfSix5nk7yenRYiY
	 f05taAA7627d2zrva0Ujn8f4tm9mDGw51Z0oydcWYc5M7Ycb4+BSMpI8sOZNps5SUA
	 6BJWAJqJR8/v3nwgzmhZyhfrQW5wQg97YtzMK5ubosrSGK5iPHtB9V4pPSJtX6AMxt
	 +bgxjF+mC/ZLg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:42 +0100
Subject: [PATCH v3 07/15] mm/rmap: track whether the page VMA mapped pgoff
 is anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-7-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3644; i=ljs@kernel.org;
 h=from:subject:message-id; bh=m5dOVubk6tLd79kxflPffqxGXd+ky2y8r1AEA3ss3P4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H7c8rqiKZSoE6R97d+2x8f66xpuneLSTE3aPcU+h
 f2oQ82cjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExEN4Lhf2jzX6nmjAWeN/lY
 +tnnv12y8WeK0bfoW67p0yQexwut2c/IsMDshdvckw9N3t/7IbRZr8d3rWha4/db7kWJtXvsJzp
 HsQMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 29F57A0008
X-Stat-Signature: q4f45167d61b3m56en3xfgwdro97n879
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785343804-573406
X-HE-Meta: U2FsdGVkX18vBZtGukqRGVECZHwNlLCJ4OTZbodsa7CgLikrEyKhrnl1GMlUsn2u7C68rdV79/Z8rizHrfwrT/cSj2Wecvj0U1eQ8rz6ye3Erf+JOffHY6prwqeHH8jMa/S/E5/tIqmtQZbpWhdo/ntRhErdtn0vmfGuFc7QAa4cGw7c1SKzgKV+vNX9LCe2T1y6BkCRo7EgkYJmbk04+Axmzu97x9EtzQN47m/YpqUbG3q5IHu3KsvNcCZbLxCHXvKIuWhPQNT/15EmK6aP1L5dgiIWDWwbMPVDpNGlT4zoURRNPMoXMXMlwG3LnnQFIRhmJYR2s1NWdMzVDfv4ZVuUmcITKFtGboHlAztFUpooTooJBNPGMrong/Jm5K26fSG/6ACMfHin/4egOkFLbqMwsFm9vrI37C6kYxGljg0pY8YBgrl6nLbLYOx6tdc/zAucGnqCtbxdyJchMHE+dYNCgV7ImewHKZK16vgm94085zphlPlPw+cJc1GqWVtuEXD6qbayaXX99AMMgX8FVIS7zf2NB0oelUSSgEqX7W5Lg5l+uM1qL6pQ9y7syzYqk2oNiXMUHlchKBI0hyHAyqJIkApNz8llxeqBTVy2ZIV6auVUhQUU/n11jLBrhM8/3bmKsIwYLDdyQ0YOLfUjTGzYl7qIuMdkZZPolkKE5o5J2QBIYtcJdTc4F2ODuvD/T9QH2ahv2Al55OMlA10EN+hEA62VhL98ugdSh6FV+71MfRVzB05J2AIK0U/YVBK9FSyJQCqZXu2dKesV5Yi+bvw1/AguG71lF810zanmJ70F1huWzjM3CRxXWwC3/FCCLoXewXZ9voNxrPia9duXpojMHopw/O5q8MYxb1SU0hGXnNR1qxXa3ndoybatzYop2mRYCupq99FdXtAi48GMtODmBHa0EaFWr6YVvo25Cb4WpBmaEeImTEttFy8D31UgX3MZHxlsC4kk59FrkIY
 n6l0/KvO
 RbrFVgJkFYFht7PxHUJKNZn60uTJf0Xb4xjjSn47hXTuqObBJh1WPp+qdCVx7pqGX3kVX5BnI2k5O0mSZ6nOqFUMKMudrW8zAYN9cbctXPba/VQoJjbqHJV8+C8X+I3v3Ue9RAwgDECdDEe9GpDdp9KiQq58vJlH+UCovpIusRF7VTx412HuQiEgctiNbZEiZvucmsKh1/n+5Nnx26l7BowFvGXukYfbpsOCWEwq39lClFcov+RitP7c2k/7WdNdPIeVLtMdemkYh5phUQKRZUXuEgLUmrzJAceZVoTTmlWqrQVKLG08qooVGBa+kruA+2gt9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the page_vma_mapped_walk structure to track whether the pgoff being
tracked is an anonymous pgoff or not and update the comments to reflect
this.

This is necessary in order to determine the correct VMA page
offset in vma_address_end() when pvmw->nr_pages > 1.

Also document that pvmw->pgoff is meaningless for pvmw->nr_pages == 1 and
for KSM.

Do not set this field where pgoff is not specified.

This is laying the groundwork for eventually using anonymous page offsets
as the index for all anonymous folios.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/rmap.h |  4 +++-
 mm/internal.h        | 13 ++++++++-----
 mm/rmap.c            |  2 ++
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..0574537a355c 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -864,13 +864,14 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 struct page_vma_mapped_walk {
 	unsigned long pfn;
 	unsigned long nr_pages;
-	pgoff_t pgoff;
+	pgoff_t pgoff;	/* Only meaningful if nr_pages > 1 and not a KSM walk */
 	struct vm_area_struct *vma;
 	unsigned long address;
 	pmd_t *pmd;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned int flags;
+	bool pgoff_is_anon : 1;
 };
 
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
@@ -881,6 +882,7 @@ struct page_vma_mapped_walk {
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
+		.pgoff_is_anon = folio_test_anon(_folio),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
diff --git a/mm/internal.h b/mm/internal.h
index 920872904bda..fbfa68d8ecc3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1079,22 +1079,25 @@ static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
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
index 5798427d007f..ab3f879454de 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1240,6 +1240,7 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
 		.vma		= vma,
 		.address	= address,
 		.flags		= PVMW_SYNC,
+		.pgoff_is_anon	= false,
 	};
 
 	state->cleaned += page_vma_mkclean_one(&pvmw);
@@ -1317,6 +1318,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		.pgoff		= pgoff,
 		.vma		= vma,
 		.flags		= PVMW_SYNC,
+		.pgoff_is_anon	= false,
 	};
 
 	if (invalid_mkclean_vma(vma, NULL))

-- 
2.55.0


