Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610F4606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gPTd+V4C
Received: by kanga.kvack.org (Postfix)
	id B36826B05B1; Sat, 21 Nov 2026 21:48:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7556B05B2; Sat, 21 Nov 2026 21:48:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23EB6B05B3; Sat, 21 Nov 2026 21:48:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71F636B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:48:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 504361A0629
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:01 +0000 (UTC)
X-FDA: 85461220362.17.40C49CB
Received: from mta1.migadu.com (out-150.mta1.migadu.com [95.215.58.150])
	by imf08.hostedemail.com (Postfix) with ESMTP id 39D8F160005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:47:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gPTd+V4C;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.150 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795315679;
	b=nKySD6dw/P8sv/ukv2QFeXim6LDCS5ZDTbmx/tMY/qca5KbmZD35JOIgWs05wbYzXN5cxk
	pmFkmRo/hls5ToddRdbilHsKMT9Iy8jgTGTaXMYEYe6Dur6m6F+iY3YwZ+gjLQNbk/NbIv
	moihviL07kJrm15Rxq3PNXqhc/ln66g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795315679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0ndatV38PZlrFixRGq/e4s2juhZcDcXxdZkxAcE0Zo=;
	b=Y6OA5pmDGEPOrbJeZ7Wb1ADA7bOJLHTsbOY39cX4PW0CjeyIiAbKgu3ocYa/2HYlAnGuT0
	dYgB93nGBsFnhTsQywreJG++66xygFiuC/pYv+GX1r0iFQj8TAKvIfo+sRswdt4AUlzIGy
	abi7bN5dkv67SZD1nuMiEgmFj8BVhI0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gPTd+V4C;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.150 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kDOoaIFLPqlwHJe2rIGpKq27GnOdOA9p/d3hHbZ9COc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315677; v=1; x=1795920477;
 b=gPTd+V4CFnWYspqTTUiO7bnZVGBGko8ooq/NO/iq9DNAYcGfBn1W7b5HdkAysargJrJVg1h8
 LQKcg3ltwXQ9cwCvES7aGsY+AyE3Zofd4HnN5/LyyeB6p9FuSW4tWcnE6WZSFCLH24cAh5AGUN+
 lne8Su+kY/WSYoQxAxrtYkbo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 70b8762278188cd6;
	Sun, 22 Nov 2026 02:47:57 +0000
X-Mizu-Trace-ID: 70b8762278188cd6
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/7] mm/gup: handle memory.high overage while populating
Date: Sat, 21 Nov 2026 18:47:32 -0800
Message-ID: <20261122024737.2741569-3-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 39D8F160005
X-Stat-Signature: dwkfa8859tzade8iycjiphxa9s1e6ebu
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795315678-991006
X-HE-Meta: U2FsdGVkX1+eIZoWGtKZjlq7go8QK2rAeP/s9xPO1MTIAbZKOZOF62kJ9whyQBHVTc6nRiNVYf18Bpf4fYX9MsXt1abtqWNTNMlGLqJUQKrV0f0d7yT0FcyGxlx9LhRQlPnlUMvoVnODbG7soN8Gf1SoCxIEh48FvTuAZVerUvZ6XRD2nK+Y3AX1qrg+vW2C1aWbx050cXvpXB04jVTkvJr5DZdjBckLZve6MW90GC14rHimf4Y3vsSy5j4lUBkIh/9bl9UbM5GWJmJ17FoCQdDAM8MrQdmCI1OkHVWZn5Q5DrXn+7RWElg/Sro52aAEU1Ri3MjCoX5SiVCCFMn0x/+aO9fEtBBE4Wo+UYeXfx85wCdAM0uVnkTMEdOjuLI3iAy7ppRPPFEfMKxrGP6ij98QSC9dPAchRPoFwi6t8ezPriRhrl1TY9r21wjZ3teFIDgVqQaAX1WtCO/bbg8xyXORodGsVIjbAB+90AXGFcp1sJLSyJeaozMD4HD2KC0tvn6zcd8iMUiiGhi93wGuTn2FBy/DXOtluObUqHPYmEvypKEW25JbDke7L5YbcuysN7RMjAOb/nBsTXVQwZ0Z7YO56MlSFjT9WcKc4u3GzBQrfV0sMlnw0Z5fgpYY+qDq96KjCUivgDjKj9vrWQRk0T69purdBC+NF66ZoQ/9lcDBYqHV/49GP9hdngk72PAStw5j3WL4cLcvzTq/E0A0zYDI2Io0Klkq772DCBHU6GFTlaON/UcOApULxfhY44aZEgFk08yzwcYejJrvJXG3Nm4Vzc4+mPEXyocYzBNkseRPZPHBGg1NUNrDdVOHUnbl2BQIg9dr3XODYcw/aDhoH1jnVRUWEwC0KWBIPcO0HscZEaZaT2Tcy4Oq5hnvx1nt5oqDzLzb0DuIPEodv2NZK5SgIgeuhOZwaPR5qSZoBEcuOJRYDSclRxM5OFrG6dWDdlsuv74Y3ewkfsLiA5O
 hGBfnC6Q
 DWHyGabR9Ip/QOc5eR9+A3HnorWbDDm1AMOnk5bh8qh4ulxSL1HFZLE44tcICMTI3NGCl/D6uRksJH2djanVhHbpHX9hAzXOQHTdPjTAl46SPlxOKYHJURQbVBAr16lzN5dkg5vni/r23tEcTlMUu+PUrfI/G5/Z91BVdl21ZDCIh1RLWAHDnGMmbSaHEVuUPBcPZlD9dXMc1tMJDhf+vvAcbotzw36pRm0exyezxI2+avBdWTtfDZQtm2BVONZBET52QPrGG3dePd/SvF6kLTAKLDlnMQavc/9vIvU/cwSo1+JPa191PsbXnXYm5fr7akWnv9XBXMXku5bPTKUcUMzRWaJh2vTW5HqzRP2LvWJX5M1E7M61hz1aNcrSMEwICtBcVFu5SZLTL9ukAKYGugmZbXSjVI3NkRZDOhNdBiMk33m5fSXT5WVqbjntHlXHfhsMc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mlock(), mlockall(), mmap() with MAP_POPULATE or MAP_LOCKED, and
MADV_POPULATE_READ/WRITE can fault in a lot of memory in one call,
with mmap_lock held. When their charges can block, the charge path
throttles them for memory.high with mmap_lock still held. In a VM with
THP on, mlock() of an 80M MADV_HUGEPAGE range under memory.high=64M
made another thread wait up to 17.2s to mmap(), and a task in another
cgroup wait up to 15.3s to read the process's /proc/<pid>/cmdline.
THP charges in VMAs without MADV_HUGEPAGE can't block under the
default defrag setting, so they are not throttled at all: mlock(512M)
reached 513M.

Throttle these calls with mmap_lock dropped instead. The populate
loops, __mm_populate() and madvise_populate(), now fault in at most
2MiB per GUP call. Between calls, if more than a batch of overage is
pending, they drop mmap_lock, handle it, and go on. GUP itself doesn't
change. One fault can still charge a whole folio.

With this patch, mlock(512M) stays at 84M, and populating 2G with no
limit takes as long as before. The mmap_lock stall goes away when a
later patch removes the synchronous step.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/gup.c      |  9 +++++++--
 mm/internal.h | 27 +++++++++++++++++++++++++++
 mm/madvise.c  | 11 +++++++++--
 3 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7605da0e06d8..d93d89f6aad0 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1951,6 +1951,7 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 	end = start + len;
 
 	for (nstart = start; nstart < end; nstart = nend) {
+		populate_handle_over_high(mm, &locked);
 		/*
 		 * We want to fault in pages for [nstart; end) address range.
 		 * Find first corresponding VMA.
@@ -1976,9 +1977,13 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 		/*
 		 * Now fault in a range of pages. populate_vma_page_range()
 		 * double checks the vma flags, so that it won't mlock pages
-		 * if the vma was already munlocked.
+		 * if the vma was already munlocked. Do one chunk at a time,
+		 * see POPULATE_CHUNK_SIZE. On error, nend skips the rest of
+		 * the VMA.
 		 */
-		ret = populate_vma_page_range(vma, nstart, nend, &locked);
+		ret = populate_vma_page_range(vma, nstart,
+					      populate_chunk_end(nstart, nend),
+					      &locked);
 		if (ret < 0) {
 			if (ignore_errors) {
 				ret = 0;
diff --git a/mm/internal.h b/mm/internal.h
index de4593b3e3b6..12f7b4b1254f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -948,6 +948,33 @@ extern long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *locked);
 extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, bool write, int *locked);
+
+/*
+ * __mm_populate() and madvise_populate() fault in at most
+ * POPULATE_CHUNK_SIZE at a time, and handle memory.high overage between
+ * chunks with mmap_lock dropped, so other tasks don't wait for them.
+ */
+#define POPULATE_CHUNK_SIZE	SZ_2M
+
+static inline unsigned long populate_chunk_end(unsigned long start,
+					       unsigned long end)
+{
+	return min(end, round_down(start, POPULATE_CHUNK_SIZE) +
+			POPULATE_CHUNK_SIZE);
+}
+
+static inline void populate_handle_over_high(struct mm_struct *mm,
+					     int *locked)
+{
+	if (!mem_cgroup_over_high_pending())
+		return;
+	if (*locked) {
+		mmap_read_unlock(mm);
+		*locked = 0;
+	}
+	mem_cgroup_handle_over_high(GFP_KERNEL);
+}
+
 bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
 		unsigned long bytes);
 
diff --git a/mm/madvise.c b/mm/madvise.c
index 2d54cb9863ea..c77924e52d79 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -992,8 +992,15 @@ static long madvise_populate(struct madvise_behavior *madv_behavior)
 	long pages;
 
 	while (start < end) {
-		/* Populate (prefault) page tables readable/writable. */
-		pages = faultin_page_range(mm, start, end, write, &locked);
+		/*
+		 * Populate (prefault) page tables readable/writable, at most a
+		 * chunk at a time, see POPULATE_CHUNK_SIZE.
+		 */
+		pages = faultin_page_range(mm, start,
+					   populate_chunk_end(start, end),
+					   write, &locked);
+		if (pages >= 0)
+			populate_handle_over_high(mm, &locked);
 		if (!locked) {
 			mmap_read_lock(mm);
 			locked = 1;
-- 
2.53.1-Meta


