Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09DBCCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 16:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2B36B008C; Thu, 28 May 2026 12:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564816B0092; Thu, 28 May 2026 12:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479EC6B0093; Thu, 28 May 2026 12:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3870E6B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:57:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFCA81620B3
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:57:02 +0000 (UTC)
X-FDA: 84817433484.03.1B5C583
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 226D8100010
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:57:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BZZc/ms8";
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779987421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPlFnYwCWz7+rdxCNeqNN0vuzrC3LBz56c9GLgbIR0Y=;
	b=pp2xnrpurv4/XugiKQ31H7ubVP4VQkoz4Lo0io8g95w0Z7xRtXQju2DLtyTgFuf8Rxa7bO
	9Y4nWJZCIoAulp0Ns93XY2ayen5FGwWma6Mfk62Xltqcz587O+pVaEOcIUJxfp0z6r6oyH
	AEzjo3hFt+9HqmDRnICzig6USJuUUtg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779987421; a=rsa-sha256;
	cv=none;
	b=Rk//mF9pYejvGS80+GwYeXenSSmarCpieug1tiQ7Tg+2ug9JM5sokyCg+Gf9k60aBDw2K6
	y7B/DSQi8IMjv1Wo9lnL+u/h5cYC3XEdv9GDkUsCLeQ5hdjwCiDd07psjsj9zDlwsZsshg
	m5w+WXoX/WytYRP7B5bRHCspNOR7mkM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BZZc/ms8";
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779987419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nPlFnYwCWz7+rdxCNeqNN0vuzrC3LBz56c9GLgbIR0Y=;
	b=BZZc/ms8dlyybEyEd97Qc3TtKn6BE7b3CTiqFTmXtlHzcU6PuSRN1DFtW97UC0epSY2v62
	F/XbJ1L0eo71OfYpoHTrPzv+yekeKLqrRmKFVwJyvhS9Fw1HV/CiygSLi8uiixVbvT++py
	UNXt8ater3KcJQTVMfd4V8UF9Q+Yv6c=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev,
	Liam R.Howlett <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 2/2] mm: use mapping_max_folio_order() for force_thp_readahead order
Date: Thu, 28 May 2026 09:55:20 -0700
Message-ID: <20260528165635.2068012-3-usama.arif@linux.dev>
In-Reply-To: <20260528165635.2068012-1-usama.arif@linux.dev>
References: <20260528165635.2068012-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: rdpfo98xco148nnmcc8u6p41aupwndak
X-Rspamd-Queue-Id: 226D8100010
X-Rspam-User: 
X-HE-Tag: 1779987420-426962
X-HE-Meta: U2FsdGVkX1/EASt7RFK0U17Y546j905nIWULQVsTx8JVycl6xJGQo2eeCfpN4G0ENUFhHF4n6QqzvksNyQRvwzCWQaDw4lHRrdE2Zzcq4m/WhlDwafue2lMx/TNoegRP8QBnrjl1ETvCtyW5YpVgK2N5VF4xtR2pfY/8/HqtxVrhRpKsjuYJ5cr0MlYJb/VWFfbOX+AHSzL/4t0ihvSFSOM5o/uYIJbq7iXDPM657agq3gIjtCylxWMfWyrFs6rrhyCOn2MAJjYZvlSqxBZ7gP0dGu8Oofsa060qG4QIed/giepLgRYwlcvMKxui9vd+0kH3oJq2KGvm4Vz0ZsTfLAXaN08RPr0q3OccBbJbEHaXh2W9RdMplV6q+tnj4IaJITWvCrn0meMATwEAKQFo+OINlxsFCtNrjkd3zSB3hcYUNl1aP07JiTgwcAeOmPTNTmKTdNcXqqqn4/3SnunT9QZI6gYbhk2vUAqLcrsOLW3E0nkuJD1pnLMEBA8upbDNKt64mgZR9zpYlQtQJYOloAc1Iv7EfMb4Sgu69Chb6XxtcB7G1K4aqU2c+J1GThvsHt3yEv8w/ZPNDKphvs9J1TovvcRxsQjO83PzQ5xAJyh6D2SypFAybmNW2FXYPAF58+zK3+CMjALkOTfweWowAs+VtSYqZzhThiKdKP/idNtPJLJgFhbjUVr8CwESkH/mQe3KIUs8n05bd/SY9p2ZrucgscIZSiQ8adl561JEY0jTxhEDBTVlBj3idutOHCHQJqovzqEGu+1fzLlDIb8pk3sjFm4tohYaHbDqpMUIYKi0MUofd5dZLLz5OGGMBrFnuqLQDNPEqpce95y6mTdYHqm22Tt0iAH72sFAwZTucupwsSp86ixsTKkfBhtiyMiXNxuhICSXzxe9TXhXkp7GocInHqcaX4p8EI34ZfYclyXpEY/+7cNp41qpI1GhGXpfKoTyXNiuNcDM9u8GdFf
 BAAOB/7y
 7FH03V81d1bZ/6VKFJg+8N559P8/tHf3QfHJRWIIqhTU2LN94rhZvU8FwKAY/H4C4gBVu6eGYg045Ed2nuxW2ujb1QwGhFyBWsF9Iaz6QnJvnBSta7NEat8x7HiARhHKHSKsGx/lWzjyLevhY1i7r+R+/o8xH2mvqAbdSu7xFvEUXqmBa4XLvMVz5xHndS1IHxs1E123GLvlKJ/pOOzb5a37GshEQyrcN3UqsuEfqXARdNItaxCXQzBgMmWFjhzpYc2+QokyKdgwSSY5fvZA6QMkdSITrP2BMMoFsZsEGFf73sOuWYixrXOZC1kzUniW/aEcY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The force_thp_readahead path in do_sync_mmap_readahead() is gated on
HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests
HPAGE_PMD_ORDER / HPAGE_PMD_NR. On configurations where HPAGE_PMD_ORDER
exceeds MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size,
VM_HUGEPAGE mappings cannot use this path and fall back to the non-forced
mmap readahead path even when the mapping supports useful large folios.

Keep the existing PMD-sized behavior when HPAGE_PMD_ORDER fits in the
page cache. When it does not, enable forced readahead for mappings that
support large folios and request an order capped by both
mapping_max_folio_order(mapping) and 2MB.

2MB is chosen as the cap because it matches the PMD size on x86_64
and on arm64 with 4K or 16K base pages, so the size/memory-pressure
tradeoff for folios of that size is already well understood. On arm64
with a 64K base page size, 2MB is also the contiguous-PTE (contpte)
block size, so the resulting folios coalesce into a single TLB entry
and reduce TLB pressure on the readahead path.

The final allocation order may still be clamped by page_cache_ra_order()
to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
on such configurations a large-folio readahead request instead of
dropping back to base-page readahead.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/filemap.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a16b33e0fc71..bfb891d9da1f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3312,14 +3312,23 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	struct file *fpin = NULL;
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
 	bool force_thp_readahead = false;
+	unsigned int thp_order = 0;
 	unsigned short mmap_miss;
 
 	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
 
 	/* Use the readahead code, even if readahead is disabled */
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
-		force_thp_readahead = true;
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
+		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
+			force_thp_readahead = true;
+			thp_order = HPAGE_PMD_ORDER;
+		} else if (mapping_large_folio_support(mapping)) {
+			force_thp_readahead = true;
+			thp_order = min_t(unsigned int,
+					  mapping_max_folio_order(mapping),
+					  get_order(SZ_2M));
+		}
+	}
 
 	if (!force_thp_readahead) {
 		/*
@@ -3354,17 +3363,19 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	}
 
 	if (force_thp_readahead) {
+		unsigned long folio_nr_pages = 1UL << thp_order;
+
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
-		ra->size = HPAGE_PMD_NR;
+		ractl._index &= ~(folio_nr_pages - 1);
+		ra->size = folio_nr_pages;
 		/*
-		 * Fetch two PMD folios, so we get the chance to actually
+		 * Fetch two folios so we get the chance to actually
 		 * readahead, unless we've been told not to.
 		 */
 		if (!(vm_flags & VM_RAND_READ))
 			ra->size *= 2;
-		ra->async_size = HPAGE_PMD_NR;
-		ra->order = HPAGE_PMD_ORDER;
+		ra->async_size = folio_nr_pages;
+		ra->order = thp_order;
 		page_cache_ra_order(&ractl, ra);
 		return fpin;
 	}
-- 
2.52.0


