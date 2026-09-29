Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885E6C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE476B00A5; Tue, 29 Sep 2026 04:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5DA6B00A6; Tue, 29 Sep 2026 04:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E34C6B00A7; Tue, 29 Sep 2026 04:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0626B00A5
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:20:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD7311C2F2C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:20:00 +0000 (UTC)
X-FDA: 85266101760.15.295266E
Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	by imf31.hostedemail.com (Postfix) with ESMTP id BE4E320004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:19:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bCHkS0KB;
	spf=pass (imf31.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790669999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5p0z35PLjDhxSJAJpFZa8+/NjJgc0b83OIM1TsDgbRo=;
	b=s/PZh1imWflxMPBn8bRStGG1S4v+5SG23xuaBvFT0Z2ZwkO4J7K8J6eFdhHQVIe9krtL6G
	QqYd8NNO/e3bGwDqfEXvJ6EAqVcj6duY3mKzKTe5st9tyi585ADZi9Wh1ZWNiVBXxJ5gfk
	SvU7y1afebbO8/xb6H2P/rWiFXylkds=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bCHkS0KB;
	spf=pass (imf31.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790669999;
	b=Ts9t+Y2OwvDl7SWcR+QpvoS+m8ij6WThXxcTbEUWbfYrhGc+L9jPD+hAkkXD8zz4uYCZrT
	OyPCGQIRCmnuodvlbuZv/60emoKGuwqyVCY4O11/xNkOrskEMMGvmbCxfsxWGW6j/AAdwr
	9nA6u1TWydLDmB2j8uXUNIb8NLI6v/8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GTNtvhQM0BkduvLf1bxHQQa2gN5nenib1TDzHr3/lk4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790669997; v=1; x=1791274797;
 b=bCHkS0KBTqEhdz+P40C/mCNOxPFw545wTpDB1f73Qdn3UUAxchGURPR0qhch6Zf18DfY+W13
 9Iw+LmGRmODyXVVNKWZHRUvGvQ308u8S07IgvY8vZkici3FhTd+vzrQSpMF2te3zp38jE+9X2jV
 Raw0yV5imOXmcP1APBq5YOJg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 89245958c046eafb;
	Tue, 29 Sep 2026 08:19:57 +0000
X-Mizu-Trace-ID: 89245958c046eafb
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	=Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v11 2/7] mm/vmalloc: undo partial mappings inside the mapping functions
Date: Tue, 29 Sep 2026 16:20:09 +0800
Message-Id: <20260929082014.160587-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260929082014.160587-1-hao.ge@linux.dev>
References: <20260929082014.160587-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE4E320004
X-Rspam-User: 
X-Stat-Signature: ktc14uyxjiqzt9dezrk7gaus8motab4o
X-HE-Tag: 1790669998-474928
X-HE-Meta: U2FsdGVkX1/bYDI8OHGS2EfpBsG419ZQVEaKq+HTJt+QE2xcY2MDIc5myYE0QS6qniss/bZP6GbTA+DhMtrrp0KdUqrisH7WhsAMk6DYcFQV5T7vegUAKQl7TH6qhsek0T2p1GE6/UO3J6Vq9xKIF7/DKXTiZqr5MVtGTkWsA6Af8PT6UNlbUWLfB9TZoSqthABUeOGZSxMmGB5Q258Y/TKgYhbOI+Sby8HcILO/bbEpdNBE93ftl0HAupWiBO6Lh//eGtAMi7l+cEx3NM8FaVp2jSYvDOSqcrqCoa7K6pPevkHk1+KtA9Bdmrixa1k5MCFK2ZHZCK4KwKe2IWT3AoL8RRiR6DSVmmcqkB2YNbpD6yORaCC/SLxciHuOuYTVtQwe9Gy7VDCJXd3xFJXBEl4+sluBvC9l0m87qSIq6Gs1eugzOy1dz4XlB4CS/h6+fnfSQCkwiY9yKJNLDvxlooIqj7Cid93v4htEJaFURm6q0nT1WXQ2JgmBwAsY2uPeNaE1qaegsd4W3B1NHSz+8a/dX/n+C2M+8eCuniHAJrMDPWwzBRQ6hD43js1FDjtjT9XzuxbiGvNC0L4mzmSk0zQVy0jo68ZaTkBKjUM9Vt3ZY/LRrdLkB2OsrHKE+SGsW8Uqjac+0XK6oKX1z4SnQ4MMJIHFm0CYKUlqfs6J1PPbEJk6fH++BE18yDXvbnb7vfEOnrJCeBdtQN5LVWVc/GxSiJXLl7gpXbyEm1eLyWKBfeGosT/isNTwv0ne2mDoklsRmAnbLbs5KzQrXu+YNlX5d/DkMo0UeFDMrSERduYLVmoxxU/flAOaacZx4ckmr75JlpEE/eqeV2GSgqjxZAae4Cx9nZsy1NFB+P0+KJktmo2DKPrpAo9I0vkOQj2iJEfDRtn/t5oB06F31/7kmekPSrhQg+zGy7r9I/YYYtfHcRtMpdoL5vhsfbr0sLbN1L/Pj9Y+d/I3ijs+xx1
 L4EXY4/M
 kKgCmYrKY9LORZKe/HBgOy4plcUOZefAy5lsZJmVSpmvfQ+MqDz9iTK6wtPbKjdErA78N3sk0TyqcFpheZ7HrtfMH2esHP4dkSNWFvDU8S7xjvQ+lvF8cPF2sd8QZbS121k6uUGFOT5bQ/xxyLyWyBCw7qCURJS2z5wdaJuoEdtm1lPFtEp9BBoXHp+YCz7jOUMEXboYFv6Nzq0+vUntbN0+GRnB52q1GLANFQPafaBg+B9MNnKHRVN98J2LkIkJze3Kz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmap_pages_range_noflush() and friends can install some PTEs before
failing and leave them mapped, and the kernel callers do not agree on
who cleans them up. For example, pcpu_map_pages() and
kmsan_ioremap_page_range() unmap the leftovers themselves, while
vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
__vmalloc_area_node() relied on the mapping functions cleaning up and
did not call anything like vunmap_range() themselves. When the same
range is mapped again, the attempt hits the leftovers and fails, with
BUG() in vmap_pte_range() for huge mappings.

After discussing with Suren and Ulad, we decided the cleanup belongs
to __vmap_pages_range_noflush() and friends, so the callers no longer
need to unmap the partial mappings themselves. Each function now
undoes the PTEs it installed itself.

The rollback calls the low-level __vunmap_range_noflush(), it just
clears the PTEs of the range it is given, which is all a rollback
needs. It cannot use vunmap_range_noflush() because these mapping
functions also map the KMSAN shadow and origin, and for a metadata
range its hook would look up the metadata of the metadata, get 0
and BUG() on addr >= end. The failed mappings were never accessed,
no TLB flush needed.

Fixes: 9376130c390a ("mm/vmalloc: add support for __GFP_NOFAIL")
Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/kmsan/shadow.c |  4 ++++
 mm/vmalloc.c      | 31 +++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 0c88d89bf0d6..2166086d3dc3 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 					    o_pages, page_shift);
 	kmsan_leave_runtime();
 	if (mapped) {
+		/* Undo the shadow mapping set up above. */
+		kmsan_enter_runtime();
+		__vunmap_range_noflush(shadow_start, shadow_end);
+		kmsan_leave_runtime();
 		err = mapped;
 		goto ret;
 	}
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 859e6d2d57a3..9bbf75706627 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -349,6 +349,10 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);
 
+	/* Undo the PTEs installed before the failure. */
+	if (err)
+		__vunmap_range_noflush(start, end);
+
 	return err;
 }
 
@@ -363,6 +367,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
 	if (!err)
 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
 					       ioremap_max_page_shift);
+	if (err)
+		__vunmap_range_noflush(addr, end);
+
 	return err;
 }
 
@@ -667,6 +674,10 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);
 
+	/* Undo the PTEs installed before the failure. */
+	if (err)
+		__vunmap_range_noflush(start, end);
+
 	return err;
 }
 
@@ -683,6 +694,7 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
+	unsigned long start = addr;
 
 	WARN_ON(page_shift < PAGE_SHIFT);
 
@@ -696,8 +708,14 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
 					page_to_phys(pages[i]), prot,
 					page_shift);
-		if (err)
+		if (err) {
+			/*
+			 * vmap_range_noflush() undoes its own partial work,
+			 * discard the chunks that already mapped.
+			 */
+			__vunmap_range_noflush(start, addr);
 			return err;
+		}
 
 		addr += 1UL << page_shift;
 	}
@@ -714,7 +732,16 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	if (ret)
 		return ret;
-	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+
+	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+	/*
+	 * The page tables undo themselves on failure. Tear down the
+	 * metadata that was fully set up before the mapping failed.
+	 */
+	if (ret)
+		kmsan_vunmap_range_noflush(addr, end);
+
+	return ret;
 }
 
 static int __vmap_pages_range(unsigned long addr, unsigned long end,
-- 
2.25.1


