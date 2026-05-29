Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FDCCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723866B0099; Fri, 29 May 2026 08:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACD46B009B; Fri, 29 May 2026 08:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C656B009D; Fri, 29 May 2026 08:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2106B0099
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:19:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 133DC1C112C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:42 +0000 (UTC)
X-FDA: 84820363404.16.F7E291E
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	by imf10.hostedemail.com (Postfix) with ESMTP id 71E0EC000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=M7hGKodZ;
	spf=pass (imf10.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780057180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xut7uEA2LcmM4LrlZiZ/byyWZ1r0WI1YSP1vZ4Egj64=;
	b=vyFrI7vDh80/g1Bg+Ejxqjo8Ey7MQsNcoW/MbD00yiFlLh1GLSYQqznwrVm1/frLo5xLAS
	3QYZyQRDjyp13FwIv/Cdopl9tIQOdIJ0/Zs67dQPUQNWZZ/EnewbDm1EbIMVSAcHEIAlo9
	WSaRwiTotWqa3T/zI61gH9sZHp4Uluo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780057180; a=rsa-sha256;
	cv=none;
	b=J8nVPqvqBWLRSJHEdS1/FM11AeGYox6wwkx+fN0WGXhWR61GwEjjGhJvfy1IQ0IbPIUYwi
	G8b6F5ZWAJAZNhfF0LiZOcsRaDpC64soxnrmKUhTAYk5uWm+KI6+aZRLhqLe8VeZuuUIEY
	MAnlhE3lJxcvMo5HQXHNpNQ6YvDf+JE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=M7hGKodZ;
	spf=pass (imf10.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780057175; bh=xut7uEA2LcmM4LrlZiZ/byyWZ1r0WI1YSP1vZ4Egj64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7hGKodZsqPkt26jzW2LkQsc6xsh6OEcmg69gQ4tmGWLrp4MG/I8hglTllW2D/G6I
	 hJYW3mcxbVoEaTUTBlDhm/wscJUy0CZq0IvnfiT+rCGPsbS8LQLTRJMzJVtFrvPmcH
	 lZ3jATB+1ppOf+u95kPUyGtBEDxKAsX+KNDcWsI0=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 4DC10017; Fri, 29 May 2026 20:19:28 +0800
X-QQ-mid: xmsmtpt1780057172tac6i9zgh
Message-ID: <tencent_7D186EDC2C9AB9009F9915C1E68F3CF44609@qq.com>
X-QQ-XMAILINFO: OATpkVjS499uNEtWMEQWZx4ULda/MSJcXY82UGEO/ENJfG6dAYdIxvNqNQ/4b5
	 NHjOLjOuuAhYF6UBBQoNqJg19p5N8mZHmqoquhVxAR/rlpLMCNtE3cRRk9CUve/AaHFTV6ZXFrU3
	 yeqjsTFYNmxR+Z6ruyX+zd/HCdJUErIf/ytbubdXHsfjzdlwKC1+WwOAEbqwvha+9rvrow2rlZ2r
	 de35kdqnkk62m40gvQ4nKczdt55wpV+TC4gARpND2xGdEurKCsJ8ux8fsuUiB7GEdHs/C5viEize
	 xmxKjD++Fcux8yvlWSQsA+J8j8RkKagftsl+/BnbAxzpWzPs02kQMxZ+nhwPWT6L62yhP7VIEvbz
	 CkqqQPROLBg6XEQolIGukrp1iM98/n44SQQIILHJ5fjF1SInNRBDHJosBvHLYwqAf6x03xGGvZs4
	 A7QAvojdiXMbu4s6ZgPuGbcFWgt3PZQZvy4LTi03VfZdMn1ON+rEupb+q2TmFCuGGCM3FLnyg8O+
	 BrqU2yUT9YIXuLRkkjnDgpeIGjYYHBcj11odwImoAlTec1N+FbGQYCTAiClAYDu+9W5PMQvC66LE
	 ZbqeY6hgPE25rj8FfQ3JgHzKe9zepNn7LcyjFNIIVz0mfZvkvS6GVDM+KVt6IHDAKV7cGqnC7Hu7
	 8HF0j5RzVfZKlrIV30lt/445qaD/GXFN/Y4Q/gfCHl40YOw8FOSQP53iNY/9c8LZ5YbbFSxsU3UA
	 25Y7kBdc/3U64ORJ+85DGz0ruorUU8kHUl+0iNtnmJMMadp8+U/ivsXcbmbAXawixcUSqoSBKJ6j
	 rJcqAsEFIf63tN7SZdkbIP/DApDQW43Kf6872Ux5u3nWN6ihONCF+JR2GfLg+0CXpX+weqLikMAJ
	 1gQ/QN5S0UITTDoA7uJfSDz6pM2/u0J79ZiI0FKqKF41ZN20jVKFqt7R4WzMgjmBgB+1b4+z9fHJ
	 9NGej8Q9WFPgKD80I4VxxNc0qkjqriULetfmT1SM8IHDf83DRec0I18+2d8zcnDVlTsvTz+0O91n
	 OkhSF9Zac1BqRyUOPDKLT3IJa6Fe6SIy/9nQlOyxcwYknlSNNh
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@meta.com>,
	Kairui Song <kasong@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 3/9] mm/zswap: support fully zswap-backed large folio loads
Date: Fri, 29 May 2026 12:19:22 +0000
X-OQ-MSGID: <20260529121928.4115683-3-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 71E0EC000F
X-Stat-Signature: exjxxgmjcwmkfq6dqg1pcd4hupu3fx9k
X-Rspamd-Server: rspam06
X-HE-Tag: 1780057179-214449
X-HE-Meta: U2FsdGVkX19ogCVjrKG9XxSMXypWUmICe6kdLELk+ir7gugNsJcaUtobIx+TJYzsv/IMO8trAFe+Bd897z6suZ4R3Sb/V977VxL1Z/u+BQ2TD/Myi7bgsWVShjw20SZ37ODNAdG4dl3E2cTHo//KjHjo1HexQuvemmsBH8JuYqOiWIB+KQlwTaFr+HpY6pOmbyLpGcV8aBQuwWTgIsUFcRkIiA099Rvvh6cg8OppCe4+r1fOwPX22WZZhP6PkK8bPRYZ8BdkEs/dgN0WuCbZ6iW6i2NE/GtkyyIc0BxHwVFBDb5d+A/jj/WwGCMB5WIpVsU/4cVgNOmA0bhxmAIV8jprYGhDe66/D6Skslpci3QKAZf4396x/SxfAl7YIPWrvNcgab9rONee8tyQ2+z049ZRHZP4TOLBm/aqV17wsw5MytFSvCU6NjxOHYd4Kujg8EBYCr12gAo6Q9eJ7s5uu29YF9y0GuMXswI0upa0UpDOd1JUZnyEHKJHJfDDoNNo/e/etBnjoclVCiXiv2oTnVWrLBUqM1U+d769AOsVGgLZMiFDqOvXjvDKt6wtpH/TKej+6eklIFJ/E/Xvv/0AZDtDiaqLv0lJCqZUxBeTXRrDItPIcYcTxue5Z2uGoOp8EfhYwSaKSGUu/47bE2bjv2L5l7NIkN0aDor9VhhauHeSCFWHyeJX20SkpYJVmUo5NvR+Zx8+vZf6CW4MDqBsa0lcFcuMdnv6JTbXuMI0oKrzALkaebi+2ZHM4rrMEqBGng/gkokT6AHOTfL+5la7cr8V1bWk+XiFqEaBupiK/d6gZI+HY3PwYi1gn2DlwrWZDYp4BvP8jkrazloLfQGmjX+NbkTe85jfXBBIExDJjPtyte4r2tp12oq81JF5RcZe4ptaIkFTND6f5XCIksCaLN8l66M/FdGWpjeR7IjxXDSk94L4BkAYdHvSegxdkRd4c8lGLP/rySeNNoGkrVE
 0ibh2kMX
 1vLKz5LqhNl90mcbg76qhESOdf4HvcHIhi5SH+s+BzrSaQUCWupEmp5m46XG3UOCGNwKSzS7pxzqcA10I6QqitLd2vRCoMeMn//49Fv9Ben7bySjJ4Pq0vNG8a7Fgc4QONjtxt4HeECXcBUnFvs3WHaig4xHum+ID69I2PrmXb0AgQHzCD49JscVCx4qHS89W0rkfJMIyxZ8yP+a1xoiYzyvirrMcFcpQIuzRi00uzzjLVI6m10FQU69Mjk2dH9jIUUj8CkMXK960uEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap currently refuses large swapcache folios. That is correct for mixed
backend ranges, but it also prevents the common swapin path from loading a
range that is still fully backed by zswap.

Teach zswap_load() to fill a locked large swapcache folio by decompressing
each base-page entry into the matching folio offset, then flushing the
folio once. A missing entry after zswap data has been seen is reported as
-EAGAIN so the caller can drop the speculative large folio and retry
order-0.

The large load keeps the zswap entries in place. It is a clean speculative
fill: until the swap slots are freed, zswap remains the backing copy if
reclaim drops the large folio before PTEs are installed.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/zswap.c | 105 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 87 insertions(+), 18 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index da5297f7bd69..94ba112a2982 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -15,6 +15,8 @@
 
 #include <linux/module.h>
 #include <linux/cpu.h>
+#include <linux/mm.h>
+#include <linux/huge_mm.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -934,7 +936,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
-static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
+static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio,
+			     unsigned int page_idx, bool flush_dcache)
 {
 	struct zswap_pool *pool = entry->pool;
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
@@ -952,14 +955,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 		WARN_ON_ONCE(input->length != PAGE_SIZE);
 
-		dst = kmap_local_folio(folio, 0);
+		dst = kmap_local_folio(folio, page_idx * PAGE_SIZE);
 		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
 		dlen = PAGE_SIZE;
 		kunmap_local(dst);
-		flush_dcache_folio(folio);
+		if (flush_dcache)
+			flush_dcache_folio(folio);
 	} else {
 		sg_init_table(&output, 1);
-		sg_set_folio(&output, folio, PAGE_SIZE, 0);
+		sg_set_folio(&output, folio, PAGE_SIZE, page_idx * PAGE_SIZE);
 		acomp_request_set_params(acomp_ctx->req, input, &output,
 					 entry->length, PAGE_SIZE);
 		ret = crypto_acomp_decompress(acomp_ctx->req);
@@ -1042,7 +1046,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		goto out;
 	}
 
-	if (!zswap_decompress(entry, folio)) {
+	if (!zswap_decompress(entry, folio, 0, true)) {
 		ret = -EIO;
 		goto out;
 	}
@@ -1615,10 +1619,9 @@ enum zswap_range_state zswap_probe_range(swp_entry_t swp,
  *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
  *  will SIGBUS).
  *
- *  -EINVAL: if the swapped out content was in zswap, but the page belongs
- *  to a large folio, which is not supported by zswap. The folio is unlocked,
- *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
- *  do_swap_page() will SIGBUS).
+ *  -EAGAIN: if the swapped out content belongs to a large folio, but the
+ *  range is mixed or raced with writeback. The folio remains locked so the
+ *  caller can drop the large swapcache folio and retry order-0.
  *
  *  -ENOENT: if the swapped out content was not in zswap. The folio remains
  *  locked on return.
@@ -1626,9 +1629,12 @@ enum zswap_range_state zswap_probe_range(swp_entry_t swp,
 int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
+	unsigned int nr_pages = folio_nr_pages(folio);
+	unsigned int type = swp_type(swp);
 	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
+	struct xarray *tree;
 	struct zswap_entry *entry;
+	unsigned int i;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1636,21 +1642,84 @@ int zswap_load(struct folio *folio)
 	if (zswap_never_enabled())
 		return -ENOENT;
 
-	/*
-	 * Large folios should not be swapped in while zswap is being used, as
-	 * they are not properly handled. Zswap does not properly load large
-	 * folios, and a large folio may only be partially in zswap.
-	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
+	if (folio_test_large(folio)) {
+		struct obj_cgroup *first_objcg = NULL;
+		bool same_objcg = true;
+		bool saw_zswap = false;
+		bool saw_non_zswap = false;
+
+		/*
+		 * The locked large swapcache folio now covers the range and
+		 * conflicts with zswap writeback's order-0 swapcache allocation.
+		 * If the range is mixed or an entry disappears, retry order-0.
+		 */
+		for (i = 0; i < nr_pages; i++) {
+			tree = swap_zswap_tree(swp_entry(type, offset + i));
+			entry = xa_load(tree, offset + i);
+			if (!entry) {
+				if (saw_zswap)
+					return -EAGAIN;
+				saw_non_zswap = true;
+				continue;
+			}
+			if (saw_non_zswap)
+				return -EAGAIN;
+
+			if (!saw_zswap)
+				first_objcg = entry->objcg;
+			else if (entry->objcg != first_objcg)
+				same_objcg = false;
+			saw_zswap = true;
+		}
+		if (!saw_zswap)
+			return -ENOENT;
+
+		for (i = 0; i < nr_pages; i++) {
+			tree = swap_zswap_tree(swp_entry(type, offset + i));
+			entry = xa_load(tree, offset + i);
+			if (!entry)
+				return -EAGAIN;
+
+			if (!zswap_decompress(entry, folio, i, false)) {
+				folio_unlock(folio);
+				return -EIO;
+			}
+		}
+
+		flush_dcache_folio(folio);
+		/*
+		 * Keep zswap entries until swap slots are freed. This is a clean
+		 * speculative fill; zswap remains the backing copy if reclaim
+		 * drops the large folio before PTEs are installed.
+		 */
+		folio_mark_uptodate(folio);
+		count_vm_events(ZSWPIN, nr_pages);
+		count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
+
+		if (same_objcg) {
+			if (first_objcg)
+				count_objcg_events(first_objcg, ZSWPIN, nr_pages);
+		} else {
+			for (i = 0; i < nr_pages; i++) {
+				tree = swap_zswap_tree(swp_entry(type, offset + i));
+				entry = xa_load(tree, offset + i);
+				if (WARN_ON_ONCE(!entry))
+					continue;
+				if (entry->objcg)
+					count_objcg_events(entry->objcg, ZSWPIN, 1);
+			}
+		}
+
 		folio_unlock(folio);
-		return -EINVAL;
+		return 0;
 	}
 
+	tree = swap_zswap_tree(swp);
 	entry = xa_load(tree, offset);
 	if (!entry)
 		return -ENOENT;
 
-	if (!zswap_decompress(entry, folio)) {
+	if (!zswap_decompress(entry, folio, 0, true)) {
 		folio_unlock(folio);
 		return -EIO;
 	}
-- 
2.34.1


