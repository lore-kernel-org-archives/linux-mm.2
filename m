Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 119B4CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57D76B0088; Fri, 19 Jun 2026 07:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08A36B008A; Fri, 19 Jun 2026 07:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20266B008C; Fri, 19 Jun 2026 07:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8DAC6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:29:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FBCDC1E43
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:29:24 +0000 (UTC)
X-FDA: 84896441448.14.7788B3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 702DA14000B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:29:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SelOo/Ad";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781868562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XVCrf8HvVxE+bRl5h9tNkVxezrW+pDd7ettEGUKaEVs=;
	b=OuQvM0zWc2cqgBYXVDwd+mkTvKDNPg5wAhUjop3K43dyzYS6lc19pkD1a9RDGtYFR5sjDr
	ng9AUGWkScpybHHNq/G10v64aoT6+sjqshEdFhTAU3Pr81QId6XdsMDU45qjyz4MZA0A8i
	dVxHe3M44+jXd9UCv7PpRRkwz3rUGFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781868562;
	b=XmaRZxprs5bsRnQ1msApMkbdfHxkNonXILBRXcSmMoUG0m60QYZbi4ofzJAqsexI8Zg8ct
	ADhuyPFwumMb1u47vu9NbrGEv/62OUYybTv2aQnjTmOg0dXDEbK1+K/vTl7jl4MkEuTIQi
	Rnrqrr0/ICNOEzhjzw3qfDklcV9aBkY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SelOo/Ad";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F0B042B60;
	Fri, 19 Jun 2026 11:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE461F00A3A;
	Fri, 19 Jun 2026 11:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781868561;
	bh=XVCrf8HvVxE+bRl5h9tNkVxezrW+pDd7ettEGUKaEVs=;
	h=From:To:Cc:Subject:Date;
	b=SelOo/AdQuAQPpsjvtqYcU4+edYFOmKso1hIFDz4VNHx0xcz2YLDyxMzuy36UTYU7
	 ENjCp3PtBoSHMEdo7smxnYERQDVeRrS13nOai9nzAmb4fEDkkH6O8Go2jwieye0Qzv
	 tPhKNfA4mesrHRIIbGo3wT7kBFqhyLMhjJR4qtgqdcK8jjy6LrQPOOv3IfH41VmbDZ
	 5eZ0oVfoxFlkBuz8jNUbeXrU6sg+jOtFhIIsS+QwJJuvlRNuWbuRtATJTjfiwkro3Q
	 84Nr695J9D5QR1MQ2TxrUO4txh6pKyGZB+uDwv2+EoqlhfgWAPB/kPlo/CIw9TD8cf
	 uCFBIYIdZPl9w==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederick Mayle <fmayle@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead to VMA boundaries"
Date: Fri, 19 Jun 2026 12:28:51 +0100
Message-ID: <20260619112852.104213-1-ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 702DA14000B
X-Stat-Signature: j5j4mpik178r7ka1ppi38cp5fg1fcb5t
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781868562-257575
X-HE-Meta: U2FsdGVkX1+9vaHGl8TNFr2DUZLhtbOYpcJIz1VEeBy6hq9/55ueSUBqO72ho8BPlup40UjqUtObXtG2fZTgIJSMjT4B1+XfAwWXuxOsYwZS9y/5VDLJMmYIoG1Hh5HryxZX6YRcx6Lma6p+CyusmN75/MIo+HfKlipDbLvmrqGH5KQUKLyKzQ2KtkBoRPjrHRPHDOfez6DyEZz/KVmYL5/ml7XxVFStZFgA1kIfpZvPGz1HlYBiRBbbCKoAfLylTw8niKkdAjVP/5uV+J4s1KHDSqUpTnCTEEous+0X4nMRHcrg9FjbfiboPW/6m06RRFvwQLQVBcdHvaxv1O9ItBS5Kw3w3D8Aev511nzPBJP3Z1NWtl2uXaMIxMZ3jqRT+5+Zvbxp963KaHo7hglBmqAnpz1IOFYhlQUyK4Jgnylrd9UL0pu2QPCI6Ez4Z9qVRjs/nXphhuhPv5eWYeMCCzxuRSo4Q43vWgNtopHw13WA8rHlVZ9rYRaurGO003oSirQPdwshWGOKd4t9HZNYpasPG7zmIE/JML48q7HsK1+bAdKfGXN7EH7taRtDEFdUSWrHCkGDnw1/Xp7Ue2s9wgNbnmvQUYlMWssmkJn68D0SCA+m/aDdgkFL8dhwXChdNb6D3WKckzPYewcuQLgfiWOXrdgbgLNV5+2h+PB6wbCVcQeTcFSs+XCNzaS2cLU6CN55Tl442xxmgGDZ3mNSoRydQGWdwIVtobtCp33iW3GC0Z2mO7jwWFh9kzL/tJsi94b85m2bEjApjvlVIJGmUjwTp4xuxo5CaDUQF3QslVlfoUIizdRMqSArJ5Z5KngVdx+v32NK6VMIpMNK0qX15iGLeKte6z/3KwrM19qabu9OiJnXpxbRdpMQSFauo4evBqibgC+lapjqALaYf8eH3BA/fk/zqG2714Z+w3+EFfiY0MArZyLsY0/oywbbhCc5jY9y7fD9wJ7fSXcsdFW
 H3+p5j6P
 gu7Hsbxyw/Ffy9D4toDKgZA2tNnipJwY4IFew/pJOoOoBm9MzPKM5CBuNf4Z8QRVWaEZFpWRTDHR9wD8a4xyuB18T1fwnMpa9n8peOdWCAtKyLbztlkiuKWQicBuZ/hqEXX6QKMbemD7rxbwS0SK+zE7oeoSys+HmMrdOjllyU4G8hlCFPa8z/dsIXiyFZLaHMFqPm8aqG5Z6tlx1PHjZGGwlclWKq4G2FmI+Rgg/vGJJWGdXEvV6det3ch/yTOgM2u74d1X4qJhUFHQpNCA+Xie16scz0Na+06nevK1q237+rjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.

This patch caused a significant performance regression, so revert it, and
we can determine whether the approach is sensible or not moving forwards,
and if so how to avoid this.

There was a merge conflict with commit de97ae6222c1 ("mm/readahead: no
PG_readahead on EOF"), care was taken to ensure that the revert retained the
behaviour of this patch and cleanly reverts commit 7b32f64bc512 ("mm: limit
filemap_fault readahead to VMA boundaries") only.

Fixes: 7b32f64bc512 ("mm: limit filemap_fault readahead to VMA boundaries")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202606181547.617a6967-lkp@intel.com
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/pagemap.h | 2 --
 mm/filemap.c            | 4 ----
 mm/readahead.c          | 6 +-----
 3 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 627771e82eb1..2c3718d592d6 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1348,7 +1348,6 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
-	pgoff_t _max_index; /* limit readahead to _max_index, inclusive */
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
@@ -1362,7 +1361,6 @@ struct readahead_control {
 		.mapping = m,						\
 		.ra = r,						\
 		._index = i,						\
-		._max_index = ULONG_MAX,				\
 	}

 #define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
diff --git a/mm/filemap.c b/mm/filemap.c
index dc3a0e960b9f..17a64837597c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3312,8 +3312,6 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	unsigned int thp_order = 0;
 	unsigned short mmap_miss;

-	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
-
 	/* Use the readahead code, even if readahead is disabled */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
 		/*
@@ -3409,7 +3407,6 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * mmap read-around
 		 */
 		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
-		ra->start = max(ra->start, vmf->vma->vm_pgoff);
 		ra->size = ra->ra_pages;
 		ra->async_size = ra->ra_pages / 4;
 		ra->order = 0;
@@ -3457,7 +3454,6 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	}

 	if (folio_test_readahead(folio)) {
-		ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_async_ra(&ractl, folio, ra->ra_pages);
 	}
diff --git a/mm/readahead.c b/mm/readahead.c
index 38ce16e3fcbd..558c92957518 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -335,8 +335,6 @@ static void do_page_cache_ra(struct readahead_control *ractl,
 		return;

 	end_index = (isize - 1) >> PAGE_SHIFT;
-	if (end_index > ractl->_max_index)
-		end_index = ractl->_max_index;
 	if (index > end_index)
 		return;
 	/* Don't read past the page containing the last byte of the file */
@@ -487,7 +485,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	pgoff_t start = readahead_index(ractl);
 	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
-	pgoff_t limit;
+	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark;
 	unsigned int nofs;
 	int err = 0;
@@ -500,8 +498,6 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		goto fallback;
 	}

-	limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
-	limit = min(limit, ractl->_max_index);
 	if (limit > index + ra->size - 1) {
 		limit = index + ra->size - 1;
 		mark = index + ra->size - ra->async_size;
--
2.54.0

