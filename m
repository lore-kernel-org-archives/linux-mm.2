Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12465C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7706B00A9; Sun, 20 Sep 2026 03:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E7E6B00AA; Sun, 20 Sep 2026 03:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5CF6B00AB; Sun, 20 Sep 2026 03:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 044776B00A9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:22:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 851EB1603E2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:28 +0000 (UTC)
X-FDA: 85233297576.19.8A075BE
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9215B20003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PymPlOdr8TwGpFl7UZnobkrxmtAh67vBD7lpZYfWspc=;
	b=B53nCxLlrAN+j0SmEr+OtyFNSOo6Mj3Bso4k0qvZ+Z7nZD0ULs0regJ554JpqUVbexsmkK
	yA8sM/No/E6T98iyIXZY8Gm/pYpxzhCD3PKZUqmEsiRq2o3yabXn2iOhXiukrClD29wvVT
	rH02sl5hSOYFEa2r1kdxBKzyx/4hPYM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888946;
	b=2fPFVbUdcrCOgPDHrk405PSLw5W0Nwbg+D+amUADTt+BBbQ1bzLnYV2kY5gTElgymVMFih
	zLCR4MV3H+s2Pp3UD3eBcxFGgo6kE+BX/0hd79iAScw+ob+kbqewE93ubC4hYWImfGFh59
	ZoQmHklmk7jySMSK9kVtXW577z6qkRU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 650f319537020d57;
	Sun, 20 Sep 2026 07:22:23 +0000
X-Mizu-Trace-ID: 650f319537020d57
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 13/17] mm, swap: do not charge zswap-backed xswap entries
Date: Sun, 20 Sep 2026 15:20:39 +0800
Message-ID: <20260920072043.430390-14-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9215B20003
X-Stat-Signature: y9ynw4f97psrsgzdajtkbi5zf6qp6ris
X-HE-Tag: 1789888946-974129
X-HE-Meta: U2FsdGVkX1/66t02EtH3yjR2+JF1PyRsk/O3sOYh696wimdT+SE+PUtewsvm9N3hP2irH1yug7mNRTc/4ObUAvaAhranoaxZKUrlYEa2uUIsBnwpMER74tnLQ68dIs+4J0BcNxIqP7MEsr20bHlCdtUJGXB6NNQy0HgZn/+k1BCzIL0g5i63GvHkE9cbjs02lB6+LPX7vSWVNDnJm1FTz7YlQTdop6Q3eqezI7BLAm8Nk0EzKLYd4lgeMLmvlIvD1sh+lRgo9W9a5CQaXKFySBxJDmpE/5ZV6p+HbCSdSB31aRKTGU+3Hol0Csbx7KNOxd8GBkjHJI4Jg1qNA3GdoYA6XxZfDJDjk4HH5/WaeIpGMkShGQARzDBlaMLN6cyci6NYzMIhatemvh7cdkberY3/Eo8+ULupdornMyW9yWEQ1fqQT5IM0bWzKkbPdbYgLuwtDT6CUC3AciUW/LTydIi5+lLcveDnl0Kp79ibOLv4y1vm4BVbEJIS1qAHEsnmt55DlTFXyuOSXwzHp785ODQfGRG6w3P4bObz3xyzUJiCE/fjYkLqCkgwdNzQM/YkNJMPg2UxlapgAwGBBEeVnlliq7U+NY4rOe9U0XCuJVh5t5qRjYa6r7LSSj5PTFhdtOCLZL5ssiwjfe1PEuhKRmku9HtSHVrTNTIAGkqvugxRG3k5Hq7JRK/7uWlZjJd7as8pxPRD0WGH4nQKLfiGoH2p9scDe5VIEMBVsgU/PLksRfPXHNkQUslr/UoFekGKC7q1XccPpYfwLTcIt7PZi5e4IeJNjuuExCix0EfPl+m4gjcimwcnfDWOvsDEG/Rmc+UanHT57KZp6+0l1bO2GkV/3toh44ZYxwip9ggDU8Bv6+fgJGS20I88hFlmlwpp7P9AzhCx20x9RlJiiEV256DzaOXRF5bKcFgyGGnYKWcexR0USviPpnHBP2T1cqKWK/IU9pqP184Vb637hH/
 fv5wp4Wn
 CHFPf5thKH0kF0tI1gTo6D6nqHah9SzGWNgRkWNwdsPCRsyDFkrHqrtCrPktZT2CdZDPpkYTi/eaIIcCoRnLEWBsEpPtIP0db2HnilnTQPvthoCZX/bneP62RyvP/AfciuzKAigICf1TIJ9onzRb/9IW8bFvjx/xVyuvAHY/umETxxfh/epW5yaoZrRw6uULRWlFQun7Eipd2NzAFmiP156ON4OA3Um64kcYRrxqG0rgQcUzJhqO8BDNQeooEFU8X96tBjA3MYIXDe91HZ3HKsCVQZw3sc/pmSFyuB/Mq/mSWg8YTlYG+QwFGPMtpquzxflHNniIkROktwKffF9jr+hyQzKWFo++R9xvyP+iaAqGXEWFp9gfDdUCbHDb2U+YQ+5H+
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
 mm/swapfile.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7dcb4b48645d..627f2cab8077 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2002,7 +2002,12 @@ int folio_alloc_swap(struct folio *folio)
 	 */
 	memcg = mem_cgroup_swap_get(folio);
 	if (memcg) {
-		if (unlikely(mem_cgroup_swap_charge(memcg, size))) {
+		/*
+		 * An xswap entry has no physical swap yet, so only record the
+		 * memcg here.  Its backing is charged when one is taken.
+		 */
+		if (!(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP) &&
+		    unlikely(mem_cgroup_swap_charge(memcg, size))) {
 			mem_cgroup_swap_put(memcg, size);
 			swap_cache_del_folio(folio);
 			goto failed;
@@ -2153,14 +2158,19 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return ERR_PTR(-EIO);
 }
 
-static void memcg_swap_free(unsigned short id, unsigned int nr)
+static void memcg_swap_free(unsigned short id, unsigned int nr, bool is_xswap)
 {
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
 	if (memcg) {
-		mem_cgroup_swap_uncharge(memcg, nr);
+		/*
+		 * An xswap entry was not charged here; its backing, if any,
+		 * was uncharged when it was released.
+		 */
+		if (!is_xswap)
+			mem_cgroup_swap_uncharge(memcg, nr);
 		mem_cgroup_swap_put(memcg, nr);
 	}
 	rcu_read_unlock();
@@ -2179,6 +2189,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned long ci_head = cluster_offset(si, ci);
 	unsigned int batch_off = ci_off;
+	bool is_xswap = si->flags & SWP_XSWAP;
 
 	VM_WARN_ON(ci->count < nr_pages);
 
@@ -2208,14 +2219,14 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
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


