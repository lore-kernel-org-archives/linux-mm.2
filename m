Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C677C44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685486B00A0; Sat, 18 Jul 2026 05:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C956B00A2; Sat, 18 Jul 2026 05:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599F86B00A3; Sat, 18 Jul 2026 05:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 228566B00A0
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:39:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F986C03D9
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:39:42 +0000 (UTC)
X-FDA: 85001400204.27.C833485
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8193A180002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:39:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784367580;
	b=W7HMwFkmOhP5Mlg1/AWfZdXGTS8T/VExz4YflREHL+FKjLyBMJ8Ah+NSGv0shAHA3oyKGx
	YIvmHnKE/dc420z/P2eopQ9SV7jiRt5dFbcBJLK0KOBFDG9Xb/TRCPP5aRTl2N/8LQsqH6
	a1IYWemQiOTHLfZjmeYstaRfeKqJSpk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784367580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vE5qnWP1U2l7kOylrL1frSt3U2Tj2uVF8K47/b9Rk7Y=;
	b=FauAgPDFDLjaG3f0NuIjMJpRYtNOoJLKVr6x6WVT1taGy8PmwKmLhBmPSNDazP0uX19HbU
	uZcFQVz/+h2133FCY8GNmOw9dK97T9O4lkHgc8inrpxqV0CjYI+Jlhrdrbt8RHwLFZOjGT
	m/zCpKjF+ojPkvrAbZkAJ3AnEciBtTA=
Received: by mail.gandi.net (Postfix) with ESMTPSA id A2C3A3EBD5;
	Sat, 18 Jul 2026 09:39:33 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 2/2] mm: zswap: deferred dropbehind free of writeback folios
Date: Sat, 18 Jul 2026 11:36:40 +0200
Message-ID: <20260718093723.153324-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260718093723.153324-1-alex@ghiti.fr>
References: <20260718093723.153324-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTF8N8FDhBG+ULGeA/tpivXlamys8SCRC9hw8AmIZZeZhHfHgZsjIMQIIKJDIcXWhlZShNQ6SGRvGvW1koQHuU31EcQnJcnqjvpzUumyw1oubhSxqHjpZTCpogQEHUFIy1njrfEKeZ7FlATmEDIn4sHp/IdI5V9AUcraW0OnEX7NFi7gDZAZFywdyZUgvWTXdb0MNa5S9BGOy+LgLL7566dREVpslYIC4AiTKoO2bUwNSztBnz5/ZJg4x4Opid2vlIqauvRtZcIfwTxM4Q+DtSuf86N6RzrvAG3Ts2dvB7g+u0yvCfreNKoWLhVr2Rg6Kabolf+tm3VB+BODI4CqvIkPZwKE080bH1j6mxQnkBeRsIDjBSM7WIFYG8oS6ZxsYLgvAlfEYBz3Aj0wV8dsVGQlss4hdZKdC17FK1I7EsGlcYwoUpSjBXUhF+pLFZpRxJ0RrW/RBSaQJzkYlO9yU0q9KRP+aGE7ENRfIIJFfq6fTR06RSZWYm9074OpmFxer/qKB1jij7sN974tl86cI/CgBfZ8vwNxM8kQoiQQmUNOyb24toN0CFqUaq3TY7k9fnE4zsFVZ3RQIsnq+1vSRqv53tXNJCLPD9iGxcwrtO59mOZrnWSDOwXlswCfEQeqUWFmx1oxrYabYzd/F2GIDCeNcim9RWmJHtTwdwpjIWUxKQ
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Queue-Id: 8193A180002
X-Rspam-User: 
X-Stat-Signature: boo9xjju8hrtgako1tq68oqpoysiqd8f
X-Rspamd-Server: rspam03
X-HE-Tag: 1784367580-684959
X-HE-Meta: U2FsdGVkX1/baVQ69qh8Z1BS8/37vUTxTkhGaX6LU477Tqv8ceoNSxCHOjWOWR53lkhXeWu3szqyUmEt9CIbMJo92mRMUtkXl/wY0a1PaXTKrCXL/LQXNBMAgEMA6Xz+itug8bVaWGY5scyQe7gZUp0W4RSeUuoPYr6vXz67iLLQ6kdV5aSMQ9i5nQnUq5AGJEJFizrlymL3ofG+q2nJow6SMuDA07EXGV59k+KU50woFnPj9Fy+kCzg0ORxw3v1K9cgFH0tZEiDAyH4wQH/JQVNZELND73s0XrkbRLQplBT0nDWtnRjM74l4nA355rFLkvvTrYnIEItVUtQ6+743tSdClOxyEcHxLUVC8yYV2g8CcZk9pWeEM9pjuTRF7fFP2HO5em3AQUhlaMUVMn7P7CVek25pjk/AJjB4N7tXeMbuKLNYqKOMHu/AqZFbUrgD+Mn3cKOetGc58V+SwH6p/aIJjGHvg+qFmDY7BdU4+8NW+lLI6sYC4I/547V8AEMIc9CWbhTxF4P5fNcuoiRELps25CCr7rb5qBdKUvKyTfL3UssRz+Nl+dmBbJ1sAatjByGK3hGV2FBeWkipMVSv6tpx+WDbinSafALSLdJKH+1A/Y8tLuG3MbhzHL0RlsYCKylhMc2tiUXbBKKc4SOp4DZK3a1UHhvA8wqLBMSz10cKEmsYdcNA3eok8cikN2l5KUlgPD/7jHBYxCaVBiYKrJ+CT5YYVCiq8M7WtLo808ypbyiG3bDgMlpHQBRXqfpNFOj7giH22bfEtMPAvVr+xsUquwo5Q5etJITB5pKoFsGzAaJ1z2wpn0axuEltbIJBnEwfDdFtqaLisbv+P+aSlkgZylbl1C/pxWF/drEjTwyQgl4cnVVQB88e9RyPuiOcFiEEvn1t65Gm0gQ32XhefXVW1wXnSYy2OPZ/Pc1UeQHTv88eLxkLuO5JHRfH72MbVNG0Qy/vFOLmhhezAV
 a1QyIupW
 /RMD2vuDW3bSzI9bm0M8XEPeocSEYFbMZuUqrGBYRepNStfgwGG0K8MWodSPescrysr8r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous change frees zswap writeback folios promptly for
synchronous-IO swap, where writeback completes in the calling context.
Asynchronous block devices and filesystem-backed swap complete
writeback in interrupt context, where the folio cannot be freed, so
those cold folios are still left on the LRU for reclaim to clean up
later.

Free them promptly as well by deferring the work to a workqueue that
runs once writeback has completed.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/zswap.h |  2 ++
 mm/filemap.c          | 20 ++++++++++++++++++++
 mm/zswap.c            | 34 +++++++++++++++++++++++++++++++---
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..23dcde274964 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+void zswap_writeback_dropbehind_folio(struct folio *folio);
 #else
 
 struct zswap_lruvec_state {};
@@ -58,6 +59,7 @@ static inline void zswap_swapoff(int type) {}
 static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) {}
 static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
 static inline void zswap_folio_swapin(struct folio *folio) {}
+static inline void zswap_writeback_dropbehind_folio(struct folio *folio) {}
 
 static inline bool zswap_is_enabled(void)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index dc3a0e960b9f..548e465b5b9a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -21,6 +21,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
+#include <linux/zswap.h>
 #include <linux/leafops.h>
 #include <linux/syscalls.h>
 #include <linux/mman.h>
@@ -1680,6 +1681,8 @@ EXPORT_SYMBOL_GPL(folio_end_writeback_no_dropbehind);
  */
 void folio_end_writeback(struct folio *folio)
 {
+	bool swap_dropbehind;
+
 	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
 
 	/*
@@ -1689,7 +1692,24 @@ void folio_end_writeback(struct folio *folio)
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
+
+	/*
+	 * zswap writeback folios are off-LRU, so we must prevent a racing
+	 * swapin from removing the folio from the swap cache and keeping it
+	 * off-LRU: the writeback flag allows that. Afterwards a swapin may win
+	 * the race, but the folio is already queued and the worker puts it back
+	 * on the LRU in that case.
+	 */
+	swap_dropbehind = folio_test_swapcache(folio) &&
+			  folio_test_dropbehind(folio);
+
 	folio_end_writeback_no_dropbehind(folio);
+
+	if (swap_dropbehind) {
+		zswap_writeback_dropbehind_folio(folio);
+		return;
+	}
+
 	folio_end_dropbehind(folio);
 	folio_put(folio);
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index 3c494c5a671c..d185da85bb68 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -34,6 +34,7 @@
 #include <linux/writeback.h>
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
+#include <linux/llist.h>
 #include <linux/list_lru.h>
 #include <linux/zsmalloc.h>
 
@@ -990,12 +991,39 @@ static void zswap_writeback_free_folio(struct folio *folio)
 		goto out;
 
 	/* Raced: the folio is now owned by the swapin; put it back on the LRU. */
+	folio_clear_dropbehind(folio);
 	folio_add_lru(folio);
 out:
 	folio_unlock(folio);
 	folio_put(folio);
 }
 
+static DEFINE_PER_CPU(struct llist_head, zswap_dropbehind_llist);
+
+static void zswap_dropbehind_workfn(struct work_struct *work)
+{
+	struct llist_node *pos, *next;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		pos = llist_del_all(per_cpu_ptr(&zswap_dropbehind_llist, cpu));
+		llist_for_each_safe(pos, next, pos) {
+			struct folio *folio = container_of((struct list_head *)pos,
+							   struct folio, lru);
+			zswap_writeback_free_folio(folio);
+		}
+	}
+}
+
+static DECLARE_WORK(zswap_dropbehind_work, zswap_dropbehind_workfn);
+
+void zswap_writeback_dropbehind_folio(struct folio *folio)
+{
+	llist_add((struct llist_node *)&folio->lru,
+		  this_cpu_ptr(&zswap_dropbehind_llist));
+	schedule_work(&zswap_dropbehind_work);
+}
+
 /*
  * Attempts to free an entry by adding a folio to the swap cache,
  * decompressing the entry data into the folio, and issuing a
@@ -1027,7 +1055,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-				       NO_INTERLEAVE_INDEX, sync);
+				       NO_INTERLEAVE_INDEX, true);
 	put_swap_device(si);
 
 	/*
@@ -1071,9 +1099,9 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
-	/* move it to the tail of the inactive list after end_writeback */
+	/* Free the folio once writeback completes; see folio_end_writeback(). */
 	if (!sync)
-		folio_set_reclaim(folio);
+		folio_set_dropbehind(folio);
 
 	/* start writeback */
 	__swap_writepage(folio, NULL);
-- 
2.53.0-Meta


