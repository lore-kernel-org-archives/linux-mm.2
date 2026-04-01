Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269CC10FCAC9
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 19:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917EB6B008C; Wed,  1 Apr 2026 15:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0346B0092; Wed,  1 Apr 2026 15:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4CE6B0093; Wed,  1 Apr 2026 15:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE926B008C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:11:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAF5E56E6F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:11:24 +0000 (UTC)
X-FDA: 84610930488.03.C6F4DE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DE122140004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:11:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SUnJBnGa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775070683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uxztzYD3eCHMyVwk1kRw2nL5v5tk4UTFzk933HDSrB8=;
	b=7hCJ+nrYl/Z2lDhwf1qHPz2GVebLGRg0wu3lr6z1GlJHci2Y1ZwbrafgyVSyju2Pr7DA0w
	y/JMK2Vv4VXTLxmFhXZ1N5IbvoB1l2mmBYnWV0NSOnNjLJenkxmPAcSjCVPyYuw5Qt0ZOZ
	EUA4Ez5oIniGo2kXQmZhdbZF/N3SevM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775070683; a=rsa-sha256;
	cv=none;
	b=M4W4uqjmpBXhbDDC8sAQPKBWPKD/QkjZJULkaqfN0utOvtOiBHHa4N6xHh+c/d0Pt80eO7
	Bwlb9Lq9FniocUKrrzQJEeb6Gl5H4imo46g3oy26spsGC3acSwip6tyoCEwSqp71wZbl8d
	w4achgj7LnvXOv1gRz0wAUOYVCVBkYA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SUnJBnGa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0342343A75;
	Wed,  1 Apr 2026 19:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E65C2BCB0;
	Wed,  1 Apr 2026 19:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775070681;
	bh=n7l9LGVOvDCd2+hzVMt9/rX50u2r86z4dGB9ckGBacs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SUnJBnGaMXzuGq2jfYs5fyq28qNIXelBnO41hoV9B/TDNXaFNLeaPBA2u3IMD422G
	 Ef6b8Zmsw7GAGQcn7TyhEIdCdl6Jn0ONVBWJw8mFzvClmoMfSUuUTRHcZgndSQjL7j
	 6Ix4yrbDHn/OGZLU/GQng+CtK6HHtIe1VsTa9haE1EululVtYpLj3/SzuMcZ7FCPlD
	 JzWsYwWE4BWEDLVp6nesvMuvbK3TlxevVn1b1OItdbzsPmXSXQGwe+atQUtZdQ728k
	 l9Fn9FKi6h6StO7mevqc6+hID5bh/R+NxiUbjVVkfjkQBRAA+yCWJx0IlRu5jmJFQO
	 zghBTtxY4mTXQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 01 Apr 2026 15:10:59 -0400
Subject: [PATCH 2/4] mm: add atomic flush guard for IOCB_DONTCACHE
 writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260401-dontcache-v1-2-1f5746fab47a@kernel.org>
References: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
In-Reply-To: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <msnitzer@kernel.org>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4833; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=n7l9LGVOvDCd2+hzVMt9/rX50u2r86z4dGB9ckGBacs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpzW3T1yRFo42zG4qubsASRC7nh36KGdmLOG0+u
 SYX0QTMzu+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCac1t0wAKCRAADmhBGVaC
 FXRND/wLxlUsyChusdT+tMPyQlfIoRYVZSMnojtBnUxpk4ci5Ejisdqd31zG5v6L9d8nO2CqZ/7
 XOkPlNuHLyCnnyvsNQfUoazU5/RyJKEmCUpAlVYl1p23ZACTrxj4dFv0rLIGuUf3i1hZU79WZ2V
 RZbFm0iLhHUS4IUYslnQm8Ybyn3AY1WtsM7n8aKqzF3ojSAZScFAkuiybXbkTL9J3x64/9e0Bsl
 e1NS+ojwLWQvZSy/D/dSYz0A6HuW81amiFk0cruWpqIBHIqpIDTzYXeXdqLbymCEYQV2yYdCGPN
 L4utfged3Ib93dMnGPE1gq1hP8Xc09bDojftaQ0Wjn2zJ//axjaMpLVZb/Auo2vfxY9h8RHWYmK
 mhJM6oR3tjgTf3FnUBoOqN5PIMObMl3fb6/VOZ3MybiSyx8jFCnR77b0+G2RLsuZhIqgGXjrhye
 2sQWYaohXVjIXg410jVNstXP8tO8z+UjNAY35AMkBuW5Od5sE5RMR1f6OCu9dGppesvkmHoDHzP
 3PlLqZOh8CjjS0gxnwq4jp2VWqSO0fr1ciFGtVF9CNytB/iIzXXhns1IJMTP0sbquNuM17N/HRt
 EIzcNuT3AxXLENvanZOvvzU9ooef3c62RM6qckIl2xdtB4wMoDEA/CaTKcji10x5zdyijBa7iiw
 p58BsgyOdBCCZsQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: DE122140004
X-Stat-Signature: g36hsao3uq1rmga56ee6xfjx9a9gn3tn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775070682-117448
X-HE-Meta: U2FsdGVkX19ZKR54Jl9SiRWRqF/GovZjQjj/kNI2telFGYCtxZLmqpevcdsQKi6XP323yeHuGcUmoyaegtcfe9oKRtzXEhK6L557nZfX+gSxTUHQxvJ71+VOgXycnsfRH6O9FUYE/E/FvMwl85ku0LJkJwOYXv+hMa88q6ECdhbecx2//Y+7O2uF45W9nDYpEZ5nIiIMmER3A5sIwE06ygeVLGiILWuQqiLAS8ZzMpQW4OEqTjmO2t5kJolt7eZrBcCQWmhYCL0rTsi6Ch7s8Hdv3FjfD8mGfKYaBicYRsIA6iaP3nW3JdCPp/9YjI3fJx9+tC9Gto9g+VPeZXFMTvumDd3QJ0OZvtwgRSH0jmPs39ia+Thqc35Q56WhrfC0h2NdmHYKxz/h8dzvHjm92FH1FpAjftf1UogM643ZKnZwhRQj07ZUgXlNdpvaNCjlUxZo60mowX+6I8eOHNjP1+6dZbHYLPjYFHOCtv7j02iUEjbw6nAFSF67zziebxIpEkMFsfoQ9Oxf1iFz93sVqggwsRR3qUF81JqM5tcL9uYenqggPGmLMhFENtN7jbZTMHChuyXU8LZeYttFWDOBSbaVTxjWNetQHTRzn9TjTD4zlxWzmHJUO0R+f9XDtFI2CyMojvWkFxbS1UTA3XVI6kh6V9LQuTRU9DiCBQwSUbYxWQZWrGPbrj0UNs50qaykgppdpka/04WpGK84ig5ML2D8p3yxmFl6JYpnyxCNn9b4icNIK4S6DHJUS+cfL7e0/W+eTolj8rPI83dqnefv4vtx8mCX7hfIpPfVSmTOoplnKiq4/n8PKD2f3x+z/3+iJKa5c+Lkaa/J353yOLL8k/sD6Xw/ueWrqZyZe862M3Eio415TEFX/kSwbZsP/362BlYOW5TVdQEHSWEuVgee6iV5K3Ifw1ctn2b/vp9H7CQVXWbaAMNUN7J2H1YxvwfXFqt/pPq6wb4sUUYPvAM
 VGI6KUo0
 JxtQCRCTaCYtRPuHC7qDroQabmjZJDIfnbRBUgl1xvgANzyTLerFlBjmADVz8RDvmt4pWBpEuObI9FCm3IXQD1AFxoIm2+cSTTnMksc4OfdXxvjhOKdM+RrVZBv+1qH4lwk23aFlmyVTQ4OaQao2SwB8rYfb1ofTlIf9CE2r74GwtGJb8qh/ZOv5rAdK0hCLU48mqHoVTuCjdZSHbSriUis2PYZJxsPObDeptwWcX1UThM5Cm56CSOL+piWoiLPN7Usm2hBU88ySa28SvhRuvO/LbwLdVbHsSvGx1uyIPUzm3A5UfVcfWjCxACtepYWVffFqBNZt/Ywy+FYMsMS+ZURLwSRVRBa7q7kGc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the PAGECACHE_TAG_WRITEBACK tag clears after a round of writeback
completes, all concurrent IOCB_DONTCACHE writers see the tag clear
simultaneously and submit proportional flushes at once — a thundering
herd that causes p99.9 tail latency spikes.

Add an AS_DONTCACHE_FLUSHING flag to the address_space and use
test_and_set_bit() to ensure at most one IOCB_DONTCACHE writer
flushes at a time.  Other writers that find the bit set skip their
flush entirely.  The bit is cleared when the flush completes.

Together with the existing skip-if-busy check on
PAGECACHE_TAG_WRITEBACK (which provides temporal rate limiting by
skipping flushes while prior writeback is still draining), this
creates a two-level guard: the writeback tag paces flush frequency
to match device speed, while the atomic flag prevents the thundering
herd at tag-clear transitions.

Additionally, add a dirty pressure escape hatch: when dirty pages
exceed 75% of the dirty_ratio threshold, bypass the WRITEBACK tag
skip and attempt to flush anyway.  Under heavy multi-writer load,
the skip-if-busy check can cause dirty pages to accumulate (most
writers skip because writeback is always in progress), eventually
triggering balance_dirty_pages() throttling with severe tail latency.
By forcing extra flushes when dirty pressure is high, dontcache
writers help drain dirty pages before the throttle threshold is hit.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 36 +++++++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9d9850d37185418349b89e6efe420..e71bf75f6c22d0da5330c17c6e525cb12d254dfe 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_DONTCACHE_FLUSHING = 11, /* dontcache writeback in progress */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
diff --git a/mm/filemap.c b/mm/filemap.c
index af2024b736bef74571cc22ab7e3cde2c8e872efe..1b5577bd4eda8ad8ee182e58acd50d99f0a8f9f5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -444,11 +444,21 @@ EXPORT_SYMBOL_GPL(filemap_flush_range);
  * @end:	last byte offset (inclusive) for writeback
  * @nr_written:	number of bytes just written by the caller
  *
- * Rate-limited writeback for IOCB_DONTCACHE writes.  Skips the flush
- * entirely if writeback is already in progress on the mapping (skip-if-busy),
- * and when flushing, caps nr_to_write to the number of pages just written
- * (proportional cap).  Together these avoid writeback contention between
- * concurrent writers and prevent I/O bursts that starve readers.
+ * Rate-limited writeback for IOCB_DONTCACHE writes.  Uses three guards to
+ * avoid writeback contention between concurrent writers:
+ *
+ *  1. Skip-if-busy: if writeback is already in progress on the mapping
+ *     (PAGECACHE_TAG_WRITEBACK set), skip the flush — unless dirty pages
+ *     are approaching the dirty_ratio threshold, in which case flush anyway
+ *     to help drain before balance_dirty_pages() throttles all writers.
+ *
+ *  2. Atomic flush guard: use test_and_set_bit(AS_DONTCACHE_FLUSHING) so
+ *     that at most one dontcache writer flushes at a time, preventing a
+ *     thundering herd when the writeback tag clears and multiple writers
+ *     try to flush simultaneously.
+ *
+ *  3. Proportional cap: cap nr_to_write to the number of pages just written,
+ *     preventing any single flush from starving concurrent readers.
  *
  * Return: %0 on success, negative error code otherwise.
  */
@@ -456,13 +466,25 @@ int filemap_dontcache_writeback_range(struct address_space *mapping,
 		loff_t start, loff_t end, ssize_t nr_written)
 {
 	long nr;
+	int ret;
+
+	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
+		unsigned long thresh, bg_thresh, dirty;
 
-	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+		global_dirty_limits(&bg_thresh, &thresh);
+		dirty = global_node_page_state(NR_FILE_DIRTY);
+		if (dirty < thresh * 3 / 4)
+			return 0;
+	}
+
+	if (test_and_set_bit(AS_DONTCACHE_FLUSHING, &mapping->flags))
 		return 0;
 
 	nr = (nr_written + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	return filemap_writeback(mapping, start, end, WB_SYNC_NONE, &nr,
+	ret = filemap_writeback(mapping, start, end, WB_SYNC_NONE, &nr,
 			WB_REASON_BACKGROUND);
+	clear_bit(AS_DONTCACHE_FLUSHING, &mapping->flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(filemap_dontcache_writeback_range);
 

-- 
2.53.0


