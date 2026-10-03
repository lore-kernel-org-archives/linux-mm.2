Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E396CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB7C6B0093; Fri,  2 Oct 2026 21:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC36B6B0096; Fri,  2 Oct 2026 21:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07096B0099; Fri,  2 Oct 2026 21:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD5236B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:11:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C68CA0889
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:34 +0000 (UTC)
X-FDA: 85279537308.30.8B773A7
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8884A80005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2IHJk1vhpMhmiZcAtLhVlmxysij74ovfXQldT94sXpM=;
	b=hUy/apw2ahJADcvjSNPejNRhEvRGvQ+3rI51RVf77YqWAjc2s6D0t1w9pj9eYQpSrkMs/G
	0OgUEM7jsMO+ZWLvAwa7whkGKF+vRihZQhEYkljK4+ZddboxbjHHwiSd3k962vXGOY2G5q
	Hp11kvDnxBDyGrJRz6t1wlgIw4PfxnA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989892;
	b=8DXoMurPtTUI0X0ivbrUkmDa9wZop4YRwn7y4E/owE/YoYvju/8tG8+OQ1KYyDcpdawTK+
	qgjW7UhMHFKiT8SISbWgRc3h43cznmbyYFD/mLnGicyKDjRuHXSTtoGY1wQccjLk2xAE5s
	/97fpDHTzHfeWzBrskrU9YqTR+E3gBQ=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id bb32ca3e7bf7924e;
	Sat, 03 Oct 2026 01:11:31 +0000
X-Mizu-Trace-ID: bb32ca3e7bf7924e
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	tj@kernel.org,
	mkoutny@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 2/6] mm, swap: do not charge zswap-backed xswap entries
Date: Sat,  3 Oct 2026 09:11:07 +0800
Message-ID: <20261003011111.1003090-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
References: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8884A80005
X-Stat-Signature: w6g9f4zueq5eebuggy3ncoquhdwyyjc1
X-Rspam-User: 
X-HE-Tag: 1790989892-469999
X-HE-Meta: U2FsdGVkX1/S/xocwGTDgVVt7FiuokjrfWrAjHb9IrEwykI9gWzFWVANB/sNEzpIvUmRtHA1bjdUYTysefwJwgKGwbV7DJn7Cqt85CvqHV/f2T0/eclZAIJst67tefmZ4NKkEtMdy9Els/sMcIlOYebqBqdOyIOFgb2b4/RagwWz4FwHLuJextt9+w1WbQC/aXo4eKqxme9i8lmxmQhwL7Oc9J+IaiT84uPdO7W2fPl5zpw14OeicdilKJf1K5UW4/QVhMQsf69J1ptkfVhqY2s5ihcv80M+TeJVo56G5qzDtatETVJms4Slf/9GmmEdtOFbqj70I6JmFKQl0FfS10joVW5gdgxT4WDnDEF8R/1SwDTQDo3G/W9CuKw+uz/YDBxtjDckPKj2b6kCpDAQJwQI6hDrU95Mcj1d0Ai9cjTTESB4B6BjTwVfs8UNm6e2481FUnJ63YUUUC0N+gKxoOu9/xhAkmEuxbsFIv+57CEpU8o9J+ERMoOOXjUlYpzgWUOdktOrXcKpvrA+OxhlNiGFHmt7J9CPVzeOVy3KH07Tap2IpTLLGNlpdHNCySvod0rvqlm1PeWSc+jdri4mSCopsX34e37IQdr+YmIgJaE2PHdjj6GUA/Tj1I1TTbfbk80/3ApidOfGjQjz/EvdNgXclT8SkO0HK/OJfhYG41R1gmy6fzv/eEXCYdEoF1AJz04mbVmzcdndTURatmu3KxoVC41r+PbBcFz1mCbT7HymvXZ+y7zbjcZguXlAhKNFxFeiOWJbkcHEokDMRNugxCvxiWj2QkNxMbDFMinjyfdn6u2Bv1onhU9Q3mWzXo3FFrmfTDT3IxhqflLBtQpOYlBlNsWo0UNhSFlcUx3F/hFtdl9ZgdYO/QS2EcCu8ZPFjuy0Bx8YAWuAlAZHikW4S2xly/aZBa4N2jrJP/2gKKeGnszE8bqOt3clp6krvAgKPmP58sr9WL5FbfkmFma
 eEUzRKNx
 xJ5bXguppYpqVpGGxFmwlEEcuxJWEfKaB4fusOiSxxppm5lC8XYbunHiPHjafG3sAT1gcYuVGrodUFS99dOEKKjMYSJaeWEO7Edl37VkjbjCvwvVE0JhhSJdIZcIuMYW3/BXNkAP/bgN+Bl762kClukHMKuYAIiFgK67aBpdk/DDtUc5IGVUx8YxCYYi/C/g3rNKa6/maI/XtVZZSXKjaqBnim1T46qklg1FCTLiJrG2ak9McOBUbh3nWbeEuS1hohrisWVHjFovjNqwp7gfUJDTDqUYWgCcBblwojWedFMyds0tMl55g500bfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

An xswap entry occupies no physical swap space: its data lives in zswap
until a backend is taken.  It was nevertheless charged against
memcg->swap at allocation, as if it did.

Record the memcg at allocation but do not charge.  The charge is taken
when the entry acquires physical backing, and released with it.

memory.swap.current therefore counts only on-disk swap usage, not
zswap-backed xswap entries.  A cgroup can reclaim its anon memory with
memory.swap.max set to 0, provided zswap is allowed for it.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8e52ace44de8..0310b474f08d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2147,7 +2147,12 @@ int folio_alloc_swap(struct folio *folio)
 	 * The owner is taken here, then charged and recorded.
 	 */
 	if (mem_cgroup_swap_get(folio, &swap_id)) {
-		if (unlikely(mem_cgroup_swap_charge(swap_id, size))) {
+		/*
+		 * An xswap entry has no physical swap yet, so only record the
+		 * owner here.  Its backing is charged when one is taken.
+		 */
+		if (!(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP) &&
+		    unlikely(mem_cgroup_swap_charge(swap_id, size))) {
 			mem_cgroup_swap_put(swap_id, size);
 			swap_cache_del_folio(folio);
 			goto failed;
@@ -2298,10 +2303,15 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return ERR_PTR(-EIO);
 }
 
-/* Uncharge a batch of freed swap slots and drop their owner refs. */
-static void memcg_swap_free(unsigned short id, unsigned int nr)
+/*
+ * An xswap entry was not charged at allocation, so there is nothing to
+ * uncharge here and only the owner refs go.  Its backing, if any, was
+ * uncharged when it was released.
+ */
+static void memcg_swap_free(unsigned short id, unsigned int nr, bool is_xswap)
 {
-	mem_cgroup_swap_uncharge(id, nr);
+	if (!is_xswap)
+		mem_cgroup_swap_uncharge(id, nr);
 	mem_cgroup_swap_put(id, nr);
 }
 
@@ -2318,6 +2328,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned long ci_head = cluster_offset(si, ci);
 	unsigned int batch_off = ci_off;
+	bool is_xswap = si->flags & SWP_XSWAP;
 
 	VM_WARN_ON(ci->count < nr_pages);
 
@@ -2347,14 +2358,14 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
 		if (batch_id != id_cur) {
 			if (batch_id)
-				memcg_swap_free(batch_id, ci_off - batch_off);
+				memcg_swap_free(batch_id, ci_off - batch_off, is_xswap);
 			batch_id = id_cur;
 			batch_off = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
 	if (batch_id)
-		memcg_swap_free(batch_id, ci_off - batch_off);
+		memcg_swap_free(batch_id, ci_off - batch_off, is_xswap);
 
 	swap_range_free(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
-- 
2.54.0


