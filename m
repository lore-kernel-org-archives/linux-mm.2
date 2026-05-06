Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77961CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 11:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58056B0005; Wed,  6 May 2026 07:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08676B0088; Wed,  6 May 2026 07:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7E96B008A; Wed,  6 May 2026 07:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC476B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 07:24:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C731A015E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:24:10 +0000 (UTC)
X-FDA: 84736761060.12.90607E2
Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	by imf06.hostedemail.com (Postfix) with ESMTP id 569B918000F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:24:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=aYJ5tFAh;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778066648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RAZoLQTv9r/26e1bwlN9bINGIKqm114i2HLArY7Q3jw=;
	b=77izustZV7esY/h1zgCIxPSDj0DtLWWdwhOAauRTppTKpOZDNamkOOaRuVssp1jOI7riP8
	EaG/O+oIB10oDBKP8kvVQG5BKozT2fh6KHNleUu9RSVySJ33BHTLgQbToB/NmOi/7XkOfM
	INhRI7jGeNpKHpA3cf6Hh1pyOE9aiTk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=aYJ5tFAh;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778066648; a=rsa-sha256;
	cv=none;
	b=rhUfba7eYE38pY03tCP7mtj5p/3g/VrKq8McBIWfqVQHkQV83B5MMndFt8HG5ELRH5kmLu
	Hnjj1hMtBbfvE25qCVMUbDKXc9oS9I2j0//lt1vp8k6hvMo/ZMgIdhCn1LPu8vC+3ETdl6
	ec2DjT8nqqbANzyNXpVQbxvYDbK6FsQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778066643; bh=RAZoLQTv9r/26e1bwlN9bINGIKqm114i2HLArY7Q3jw=;
	h=From:To:Cc:Subject:Date;
	b=aYJ5tFAhPjwl+zG37IKzIfomgXzeaaE0dWeh5EoN7xn/Q8xuzA8/3GelhzVEPfWeT
	 6vR9aVNelTWQiENnLRiYXN/9Ziv+HMManEPKkAvo25om0VNx1BQf+UlFyFHJ/2SMlg
	 yrQ8jihViFdjp8O/mSY5x6R/d2qZI+IJ1ScnhkzI=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 5FBAE665; Wed, 06 May 2026 19:23:59 +0800
X-QQ-mid: xmsmtpt1778066639tpmdwybvm
Message-ID: <tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com>
X-QQ-XMAILINFO: NwU6Bou9okj/buYd+9QBWbpsVasMPRPGt+xZAu9PwSvw3rkThXNsP6EMotjPK3
	 iKJGsRkQZIxNODmJV+ZjieSnaXNLbk/ZzZOOkBLzBJn62R61mphqYgIr7AdtZGhmMsAjecpecnXU
	 eKPyYgJB6uD1lytL2SZykkdSw53QaUTmoQ35pCGd3zKybazaiG1rtbLgc4UpEhOvKIjv5GegVr5J
	 bu91TFx0k0xIizjNY92/bg/ZQHqpG3lExb8gMpjy2yXobrK6HAzzPFvWstLsPF3X5YkxuLpiYVSu
	 voBcb6Q6pRqVAvGFwB20IXHDMFB8N9AxOGzEH4Mv116BWkHoPsprowTuEBugeUdv/fcCgF9A8VjG
	 ZNFAZDvF7nPZy04AXzeflIFt3lPVbc6Y514PD7B6vbViDP3Eb9SYUkqkX5A8rn193ASxmjGN/wMl
	 Hvj1BoAKT7WaijNlGny8agaS6fY6TtRp8vI4pP+se/zz/wNFK3jhEQe2/LBFeU9FP7nUrp3o+T7s
	 u7j/3MluD/qjnIts+PeY5CeJSufmO0w3LF4VHs6nZCgBMH9UHYdPTT3TpFnjpJP7sCgbjqG4VoAk
	 l3Oon/+NieOa20u4tZ13cvmCqG2bP7MZxodOQg8ESM1pi4kCVfQlUQi/mrWuxXbsGrCPLuFizHcE
	 mDt5Lp7AEJ8I3hfEp+53vUHsiXay3hC7tipPgSS3DpFQMQDoz+F6xPUDEsPjr2zEQenaJanbzeK2
	 xGnj10hpYbLUcWyvOE12arlVzJ0jVhcuAlIzvXdHm9TXJzwTstEHKy9vJVtzyrc4dC8BLPOGqTQj
	 XoaGnsEiVM8rpGa1LV67U4Zzp3NNFFIHR1TvSwkDGoW8k+/5PpiHGifCQNT9t0avoNHHmU92lXQ3
	 8zz7XAqGgBZTD5Qbzfth76mYYI9JQs5XhezaZG+TRuY3vj6lNFRpTsJpuOn6p62Tf02wdHz/uK6A
	 bZwttH/qLM1kDc+D80Ml1CYV4/WpMqkHKkKnXhSQh2skcMs6xJT1ei0/CzoyHsL3qqet8b5rTymN
	 SFLDQtiEX6mujI67eohQnpVM2iUBs=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/fadvise: avoid remote LRU drain for mapped folio failures
Date: Wed,  6 May 2026 11:23:59 +0000
X-OQ-MSGID: <20260506112359.2269114-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 569B918000F
X-Rspamd-Server: rspam06
X-Stat-Signature: j5acmpqth8tasmrpp46a7ohogzo6eop6
X-HE-Tag: 1778066646-181429
X-HE-Meta: U2FsdGVkX183DaKLziqtrd573gbb5il+QT93ZFasD3Vl0xsJ1RTGhpq0TatqOMCraotwlYwhsJg0j1WwkvoAtVhfAAVNm9p14z9v6hCPPPysDAN5Jb4k77FVE9NYbmFbd9aKxYk3QxSKb2+F2L7PN3J0a1ivdO0tOrWDYAp/+c04WAyGrKxoD2o2TXIS28CQYC8Yyj/QM7nS8+c9sZL1hjFFka3WvIru8RHlVB5m2Oo5UPqfcu3vj54qz/qmMazpkp5ynHI8O+zMO8G58fgunRL5D7XhfsFDwQiOIkE7sdpLlaiu5YXsOygKGP5wcCFoWpTBVUhATl9j67MXdg+o4VLubFrhbmHEFeimTiUfvG09dfXYaFzP8TRpsP+e+bYKXOxsSA8NbvssD7DTmxdkrtwBbnBaxgIGveDZLi3K7+wSjjrM2hHiGxHNDEYq87mhEb/4Unv72eRckT1poCCR7aBiQfUe0kzY0pO0pI44BVncBBOSj+WCAtwBitI0GFGRwO139cFfE0k/y8cwXOVUPgwYtstVDBWjGJuzjqnf2whqFyCy0RHPF3jfUZqfMJpReDtC2t4OZhqCU8cgxzlPlAohgFNqSPOZWThj5/Sy7vSP67/XredFA2zPA1q6tLQ9ublT1QNldxGmpAYep/wx5fmW/idHcc61CPJ5GO9abTYvws73UxtddJOcACEKkuwicVihBFlQWMpJQnA1nKUCicJCJI2wumDkNy2OT5WNetaaB6Fn1CjD+2P4JsEBjRuPYBr0LevMKcNTDdP2lpSP2kvuuatf0KuGr3gBNIeLGUyLTuD3hafXTPAJ9Bb5HoyjSAbRduI35/Q0eQhsnng4i0dUkFDwRTRfwYANuzT5vhx4sGawcKvqZVVBmuCbexNIHUyb1rkPsIo1O6xrwKTMpZ4C2j5AW0mXI/5A2Hh3DmdNc2v63UwVvUgoy9LO1ohu0zWwTwAC7STEr/R6jra
 i0zzMoDb
 wytm2P0VFY2QTorZmIuPTRB+hbzELIFG8YLjtGMarTL5g4mfXD1wCLM26Zc6K0w3eUZL4PmeLP7tENxKhdjJprASCj3TTfZ0b0O9QAHId4V7ub9aMV/uHPPY8VAIElUg4SEYqykB6TGyJRJVlRNjhDjpBjVSUdYEctnQTYYljYv3svEnJ2vWTvl5ZL5Jx1I/pWiZ27gmuzy9XTNnVKY1BM0+8ZMv32ThAIMOOsT9/1/ZoiPMZsrfUJtwi57U/cqRjkymtXlwjq8JcIes=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generic_fadvise(POSIX_FADV_DONTNEED) drains the local LRU batch and
then tries to invalidate the requested page-cache range. If any folio
could not be evicted, it assumes that a remote per-cpu LRU batch might
be pinning the folio, calls lru_add_drain_all(), and walks the mapping
again.

mapping_try_invalidate() currently treats every failed
mapping_evict_folio() as a possible remote-LRU-batch failure. But
mapping_evict_folio() also fails for dirty or writeback folios, mapped
folios, and folios whose filesystem-private state cannot be released. A
global drain cannot make those folios evictable, so the drain adds
latency and cross-CPU work without addressing those failure reasons.

Mapped folios are a common false positive. They may also have transient
references, but while any page in the folio is mapped, a remote LRU drain
cannot remove the page-table references that keep the folio unevictable.
POSIX_FADV_DONTNEED does not unmap userspace mappings.

Teach the folio eviction path to report whether a failure hit the
existing refcount check on a clean, unmapped folio. Only request the
global drain for that case. This preserves the existing fallback for
failures that a remote LRU drain can plausibly fix, while avoiding it
for failure reasons that a remote drain is not expected to resolve.

On a 4-vCPU, 8G QEMU/KVM guest, a mmap streaming workload scanned a
128 MiB MAP_SHARED file in 2 MiB chunks. It called POSIX_FADV_DONTNEED
on each chunk after reading it while keeping the mapping in place. 5
rounds with 256 fadvise calls per round showed:

  baseline: 112116 ns/call, 256 lru_add_drain_all() calls/round
  patched:   79012 ns/call,   0 lru_add_drain_all() calls/round

A separate cross-CPU fallback test exercised the case this fallback was
originally intended to protect: CPU 0 created and wrote an 8-page file,
then CPU 1 called fsync() and POSIX_FADV_DONTNEED on it. On the patched
kernel, 10/10 rounds still called lru_add_drain_all() once and the
subsequent mincore() check saw 0 resident pages. This shows that the
patch does not remove the global drain path from this cross-CPU case.

The workload is a controlled test, not production workload proof. It
exercises the fadvise path and shows that mapped folio failures no
longer trigger global drains in this setup while the cross-CPU fallback
test continues to pass.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/fadvise.c  | 16 ++++++++-----
 mm/internal.h |  2 +-
 mm/truncate.c | 64 +++++++++++++++++++++++++++++++++------------------
 3 files changed, 52 insertions(+), 30 deletions(-)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index b63fe21416ff2..ef26c23bf35c6 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -141,7 +141,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		}
 
 		if (end_index >= start_index) {
-			unsigned long nr_failed = 0;
+			unsigned long nr_lru_refs = 0;
 
 			/*
 			 * It's common to FADV_DONTNEED right after
@@ -155,14 +155,18 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 			lru_add_drain();
 
 			mapping_try_invalidate(mapping, start_index, end_index,
-					&nr_failed);
+					&nr_lru_refs);
 
 			/*
-			 * The failures may be due to the folio being
-			 * in the LRU cache of a remote CPU. Drain all
-			 * caches and try again.
+			 * Some clean, unmapped folios can fail invalidation
+			 * because they are still sitting in remote per-cpu LRU
+			 * batches.  Failures caused by dirty/writeback state,
+			 * user mappings or filesystem-private release state are
+			 * not helped by a remote drain, so avoid it unless
+			 * mapping_try_invalidate() found a failure that could
+			 * plausibly be resolved by it.
 			 */
-			if (nr_failed) {
+			if (nr_lru_refs) {
 				lru_add_drain_all();
 				invalidate_mapping_pages(mapping, start_index,
 						end_index);
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b6..e95e691fb4a01 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -562,7 +562,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
+		pgoff_t start, pgoff_t end, unsigned long *nr_lru_refs);
 
 /**
  * folio_evictable - Test whether a folio is evictable.
diff --git a/mm/truncate.c b/mm/truncate.c
index 12cc89f89afcf..abd72f3d358eb 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -311,19 +311,11 @@ int generic_error_remove_folio(struct address_space *mapping,
 }
 EXPORT_SYMBOL(generic_error_remove_folio);
 
-/**
- * mapping_evict_folio() - Remove an unused folio from the page-cache.
- * @mapping: The mapping this folio belongs to.
- * @folio: The folio to remove.
- *
- * Safely remove one folio from the page cache.
- * It only drops clean, unused folios.
- *
- * Context: Folio must be locked.
- * Return: The number of pages successfully removed.
- */
-long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
+static long __mapping_evict_folio(struct address_space *mapping,
+				  struct folio *folio, bool *lru_refs)
 {
+	if (lru_refs)
+		*lru_refs = false;
 	/* The page may have been truncated before it was locked */
 	if (!mapping)
 		return 0;
@@ -331,14 +323,38 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
 		return 0;
 	/* The refcount will be elevated if any page in the folio is mapped */
 	if (folio_ref_count(folio) >
-			folio_nr_pages(folio) + folio_has_private(folio) + 1)
+			folio_nr_pages(folio) + folio_has_private(folio) + 1) {
+		/*
+		 * A remote LRU drain can only help with extra references on
+		 * otherwise evictable folios.  Mapped folios also have an
+		 * elevated refcount, but draining LRU caches cannot unmap them.
+		 */
+		if (lru_refs && !folio_mapped(folio))
+			*lru_refs = true;
 		return 0;
+	}
 	if (!filemap_release_folio(folio, 0))
 		return 0;
 
 	return remove_mapping(mapping, folio);
 }
 
+/**
+ * mapping_evict_folio() - Remove an unused folio from the page-cache.
+ * @mapping: The mapping this folio belongs to.
+ * @folio: The folio to remove.
+ *
+ * Safely remove one folio from the page cache.
+ * It only drops clean, unused folios.
+ *
+ * Context: Folio must be locked.
+ * Return: The number of pages successfully removed.
+ */
+long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
+{
+	return __mapping_evict_folio(mapping, folio, NULL);
+}
+
 /**
  * truncate_inode_pages_range - truncate range of pages specified by start & end byte offsets
  * @mapping: mapping to truncate
@@ -526,13 +542,15 @@ EXPORT_SYMBOL(truncate_inode_pages_final);
  * @mapping: the address_space which holds the folios to invalidate
  * @start: the offset 'from' which to invalidate
  * @end: the offset 'to' which to invalidate (inclusive)
- * @nr_failed: How many folio invalidations failed
+ * @nr_lru_refs: Optional counter for failures which may be due to remote
+ *                per-cpu LRU refs
  *
- * This function is similar to invalidate_mapping_pages(), except that it
- * returns the number of folios which could not be evicted in @nr_failed.
+ * This function is similar to invalidate_mapping_pages(), except that callers
+ * may request the number of folio eviction failures that may be resolved by
+ * draining remote per-cpu LRU batches in @nr_lru_refs.
  */
 unsigned long mapping_try_invalidate(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_failed)
+		pgoff_t start, pgoff_t end, unsigned long *nr_lru_refs)
 {
 	pgoff_t indices[FOLIO_BATCH_SIZE];
 	struct folio_batch fbatch;
@@ -548,6 +566,7 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 
 		for (i = 0; i < nr; i++) {
 			struct folio *folio = fbatch.folios[i];
+			bool lru_refs = false;
 
 			/* We rely upon deletion not changing folio->index */
 
@@ -557,18 +576,17 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 				continue;
 			}
 
-			ret = mapping_evict_folio(mapping, folio);
+			ret = __mapping_evict_folio(mapping, folio,
+						    nr_lru_refs ? &lru_refs : NULL);
+			if (!ret && lru_refs)
+				(*nr_lru_refs)++;
 			folio_unlock(folio);
 			/*
 			 * Invalidation is a hint that the folio is no longer
 			 * of interest and try to speed up its reclaim.
 			 */
-			if (!ret) {
+			if (!ret)
 				deactivate_file_folio(folio);
-				/* Likely in the lru cache of a remote CPU */
-				if (nr_failed)
-					(*nr_failed)++;
-			}
 			count += ret;
 		}
 

base-commit: 1b55f8358e35a67bf3969339ea7b86988af92f66
-- 
2.34.1


