Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8630B606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 05:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=NsK73AF1
Received: by kanga.kvack.org (Postfix)
	id 97F0D6B05B0; Thu, 26 Nov 2026 00:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92EBE6B05B1; Thu, 26 Nov 2026 00:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8445C6B05B2; Thu, 26 Nov 2026 00:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9E66B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:34:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98446A8E2C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:34:47 +0000 (UTC)
X-FDA: 85476155814.08.34A1CFC
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 08E8380007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:34:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=NsK73AF1;
	spf=pass (imf30.hostedemail.com: domain of namjain@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=namjain@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795671286;
	b=hYi8Vnui2H5Eim2BqBBrwG+C6fPPpp6watNckTYx7+oHay+uAC8GkxL0npd0/MMYQTlIp0
	R69WoajlTj+Fjpn3h99mWECMjssi74kpqfeVCezGHU9kcX/O5CEqqeB6LB3vpuYmBVsi5o
	fIzI8EenRjDzmuKXX+yR8578/Xul3M0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795671286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UJ+8MsoQlMt7ippaBHIRpOExH3OMdJs3rL46l0+BjYY=;
	b=tdY0TC3AUeL3ryYsjEfxz/7Ym8oPU/qUULiilAj3zsjfpHlM+r2j1vj09xHMysglK9+Myn
	7P5y5YdH2agntyYMKvJedLzvRzv7S5cRipsMexmMxUohxclZPx663kWPRLfkPhIzqw0Hsh
	tu6kifYb4CddAj1AV2PSBts8bGVmrLI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=NsK73AF1;
	spf=pass (imf30.hostedemail.com: domain of namjain@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=namjain@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from CPC-namja-026ON.localdomain (unknown [4.213.232.22])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4B42420B7166;
	Wed, 25 Nov 2026 21:34:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4B42420B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795671279;
	bh=UJ+8MsoQlMt7ippaBHIRpOExH3OMdJs3rL46l0+BjYY=;
	h=From:To:Cc:Subject:Date:From;
	b=NsK73AF1/58D1ommrNJwFydZ1fP6q4zi10VfDT6LGHko+x/GK/EjL+6Z83cVawBi9
	 rWanWfrNs3ylGDS8BN/WX9mgTXEymSNGibKse2E6DyFzNoc7TFHzIDb3e9Qh3T0RtH
	 sBNHopDrk+M2KR5asloqhpWjOGdMWOdbCkK9/weM=
From: Naman Jain <namjain@linux.microsoft.com>
To: Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leon@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org,
	namjain@linux.microsoft.com
Subject: [PATCH] iov_iter: Fix direct I/O across compatible device pgmaps
Date: Thu, 26 Nov 2026 05:34:33 +0000
Message-ID: <20261126053433.88531-1-namjain@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 08E8380007
X-Rspam-User:
X-Stat-Signature: 8s94aem9tmq8xcj873d8eag491mzcc7h
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795671285-751009
X-HE-Meta: U2FsdGVkX1/+7VVUqDQ7igaxwuo56OT2moysKGkDHzrV8pSMbrVZmx/jNzLUCbenOsNGMzfAZLib/DIsb6s/UE3MokvWwt5xdUXrDfiqL9hM/Z+Ok7qwuEX1bb/QWtsdAtgGHUWLpmZNyRRSty2XJc0B6uIk3ZN+f4OoxRM7AsPgbF5Q5RjEFQJqBWQdSR8zzb+KqnR28VjZ1bvyuepTzslVSzJj2xYHpapoAANjkgyXqq0305KNQsfsfqH0Ss+N6AFlaFoXXgR6XtT0ELZElof3EcUsBcSc8VRXTiiwsjH8he3nWPvn7bACRXplXxgGqkIoSDwbh3utzDZ2h8z0YhkHLq1S0zXLZ9pvqFRDs/eDcjaShoL2V9S/IIvRIwgan+/JAvSlr7L+LbkLKxXgis52cTInpsASW2fEG389u7yBe6qELpTT5dYnKKY/sc8ncVGdZZtqN1fD3Gsj0Az7azVBDGa/+Alb2jkpa7DHbfZE3i5Gl1HsxUjlQHcl7SmJXEfvSQube0UIf7KFTLSQYgYE1V4Efzqe4Y4JaXnyJM8gBM4Hp5+XNS4Q5GCB+5e210HqOqL3/ZRDChcJ187U14NwDqZQ+fbZwRqQJmJdp3IKVVhkmz8thMD7QzHB5mfiGu84Ps4mavDOB0KGnh800+qg4bz1CHFjRzMdZyWHwSBk9/1dnW5nCweFUaClPhqUyB9n1llp9e5Y+odJddIYe4fvdJISoG10isqSDmg3JG7r/9ksh0UASpi6rpz8LUndGLWomC6tZOnQokVFa9eMIhkxDZOYhKPCMsXTv69IENiQrsGWtPkZAoZkE5rT2MOKq5yYBbKYNwkQhMzt/t/goPsu1omq3UcWJEhAUN5KupO3ZuW4EMosJUuU95Xte0KysH9hWrQHy1zquwmSJFrpELsp8PUFsUTSdCcE4NMZXh569PRv6eNfgHolvCv7816AlccXCu1LnsQe5iUYpxA
 Rsa3JNZv
 545qufHbaNtruNcQslfwpyAq+RoTVzKqZpoanrJ5m/2eEzrUtHPuYGaltSFX91mq7+m/tG8YmAicuBUBx6GYCUaH/t4wJ5Srk9e2EmY/c21eoxibizOmYJ/ipsGYZpnBdDx7c3tn1n/o2JazkMIBXN+gbrrNcrs7iyk3Dl6dIZmbXog5bavaE40imePqD/fMnYVK+ddrpIgweyRurkJQkjQ0JPj1jw92tdQXz1ydsNECQz9mkT0Z18gXSDc27uFwgJaFprtrkls3I5eLiYDnoAbAoeQMdk5GM5lfG7tJXEKIpdM55h7mYFafEUluecRa2Q+OrIsmfl8ATkkx8Z/tKZChVgM/6WSXTEOv1E4tjcVpOB+PYF4UvHX5aH4e/yZRvnUKVbILF6oyF4r7YuFwowM/OGibC39oJNvu7VDlDvxTdJbhusvzqy8Yd8doR1NS6qGzn1GS0bKGkPjxZALirfIupvdBYlGf+LFYEHQA6n0qTr/BMhhRYHNoO21eyP1EaHdcU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>

Commit 38446014648c ("block: don't merge different kinds of P2P transfers
in a single bio") made bio_add_page() reject pages from different
dev_pagemaps. This was needed for PCI P2PDMA, but also rejected pages
with compatible DMA mapping requirements.

Commit 41c665aae2b5 ("block: relax pgmap check in bio_add_page for
compatible zone device pages") allows these pages in separate bvecs.
Commit 13920e4b7b784 ("block: add pgmap check to biovec_phys_mergeable")
prevents physically contiguous bvecs from different pgmaps from being
merged into one segment.

But direct I/O now fills a bio using iov_iter_extract_bvecs(), which
retained the original restriction and bypasses bio_add_page().
For a non-atomic request handled by a single bio, only the data before
the pgmap boundary is submitted. The rest is not transferred, and the
request completes with fewer bytes than requested.

Fix this by moving zone_device_pages_compatible() from blk.h to
memremap.h and using it in iov_iter_extract_bvecs(). This allows
compatible pages to be added as separate bvecs without relaxing the
same-pgmap requirement for PCI P2PDMA.

Fixes: 38446014648c ("block: don't merge different kinds of P2P transfers in a single bio")
Cc: stable@vger.kernel.org
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
---
 block/blk.h              | 19 -------------------
 include/linux/memremap.h | 19 +++++++++++++++++++
 lib/iov_iter.c           |  3 ++-
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 50abfd9328861..460c064f1d1b0 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -142,25 +142,6 @@ static inline bool biovec_phys_mergeable(struct request_queue *q,
 	return true;
 }
 
-/*
- * Check if two pages from potentially different zone device pgmaps can
- * coexist as separate bvec entries in the same bio.
- *
- * The block DMA iterator (blk_dma_map_iter_start) caches the P2PDMA mapping
- * state from the first segment and applies it to all subsequent segments, so
- * P2PDMA pages from different pgmaps must not be mixed in the same bio.
- *
- * Other zone device types (FS_DAX, GENERIC) use the same dma_map_phys() path
- * as normal RAM.  PRIVATE and COHERENT pages never appear in bios.
- */
-static inline bool zone_device_pages_compatible(const struct page *a,
-						const struct page *b)
-{
-	if (is_pci_p2pdma_page(a) || is_pci_p2pdma_page(b))
-		return zone_device_pages_have_same_pgmap(a, b);
-	return true;
-}
-
 static inline bool __bvec_gap_to_prev(const struct queue_limits *lim,
 		struct bio_vec *bprv, unsigned int offset)
 {
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index c8a4979d4c780..a1d447a847990 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -202,6 +202,25 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 		folio_is_pci_p2pdma(page_folio(page));
 }
 
+/*
+ * Check if two pages from potentially different zone device pgmaps can
+ * coexist as separate bvec entries in the same bio.
+ *
+ * The block DMA iterator (blk_dma_map_iter_start) caches the P2PDMA mapping
+ * state from the first segment and applies it to all subsequent segments, so
+ * P2PDMA pages from different pgmaps must not be mixed in the same bio.
+ *
+ * Other zone device types (FS_DAX, GENERIC) use the same dma_map_phys() path
+ * as normal RAM.  PRIVATE and COHERENT pages never appear in bios.
+ */
+static inline bool zone_device_pages_compatible(const struct page *a,
+						const struct page *b)
+{
+	if (is_pci_p2pdma_page(a) || is_pci_p2pdma_page(b))
+		return zone_device_pages_have_same_pgmap(a, b);
+	return true;
+}
+
 static inline bool folio_is_device_coherent(const struct folio *folio)
 {
 	return folio_is_zone_device(folio) &&
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 56c59a2b589d3..a0c76b40a4f90 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -4,6 +4,7 @@
 #include <linux/fault-inject-usercopy.h>
 #include <linux/uio.h>
 #include <linux/pagemap.h>
+#include <linux/memremap.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -1968,7 +1969,7 @@ ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv,
 		unsigned int nr_to_add;
 
 		if (*nr_vecs > 0 &&
-		    !zone_device_pages_have_same_pgmap(bv[*nr_vecs - 1].bv_page,
+		    !zone_device_pages_compatible(bv[*nr_vecs - 1].bv_page,
 				pages[i]))
 			break;
 
-- 
2.43.0


