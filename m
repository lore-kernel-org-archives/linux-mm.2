Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA48CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C84CD6B0088; Mon, 25 May 2026 23:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35AF6B0093; Mon, 25 May 2026 23:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B846B0095; Mon, 25 May 2026 23:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A23AB6B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:40:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A1BB1A026F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:40:17 +0000 (UTC)
X-FDA: 84808168074.23.48B59A7
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98D54140010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:40:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fEU5/DyU";
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779766815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhCjAMoSVz9odIihzeNS/7m2ssbSIYp4a1jvAvsbJjI=;
	b=eMzkRPLWRXcc2AhuTUAlD/Icrg84ZANPKJnbLcskOlJQRf5gmtV9Ok9C2NKfuMtM5jOCAf
	tuJgMX++DwUO25IYi3McWRwHr5fFEYziUOdqnceX2Z2brJ9Y5EeMXHai10/T/5zS4pBWBU
	qsyk5DaVlRUo9JGfikBwp6RrWF9i8oQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fEU5/DyU";
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779766815; a=rsa-sha256;
	cv=none;
	b=AvG7SuxExiV96C5zGS0PgVL5K7p3/WoLvvWFne5OKa6HVkEc16h/rlhZhfp+3oc9gZpD+/
	+Na4drJFHg+x+D+c0jKwvNq0LMeFVHheMfxzD/T8P9DmfmdifvSsaAPSYkQKb9nbjdtbhT
	T07dGpw3EJEr6+EVUcmaZl8zbom3OhM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779766814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DhCjAMoSVz9odIihzeNS/7m2ssbSIYp4a1jvAvsbJjI=;
	b=fEU5/DyU6aWgLcZRzwlOoaHUpbf3wC6CXYF4Nk89wq6qtBtJD7upZ9CgEWEORch3biQASN
	EK/+xE9Ae6KPnLk45aegdJiNG33fImRIlaTzZbbk24OtpfDivoumCYqjEmQFA6rNYfssCV
	LXdhdBGcizL2+3BW8PkvPs4ul0k2vYY=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v3 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
Date: Mon, 25 May 2026 20:39:29 -0700
Message-ID: <20260526033931.1760588-3-shakeel.butt@linux.dev>
In-Reply-To: <20260526033931.1760588-1-shakeel.butt@linux.dev>
References: <20260526033931.1760588-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: s8xxao8siaomsroihggnund7e7gxht94
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 98D54140010
X-HE-Tag: 1779766815-753607
X-HE-Meta: U2FsdGVkX1/2JqKKKTek/pnC7QjXZ2KxCV05CiMyrjQDpyL6eitjMiQk1LyBkEjho4ySLnr0ZVyReYMKmA7g7HMGEjTsHxh62qIs5oqVZGoS1ZFigbXBY1eDdAz4A2DEpkkoTnmnyRybJOwhxSd4wfE9QpyEKrqeAXe9xKtiYdLUts0bSgtwrnooZkMgve5UlYrWDIM4T8L3bCMLmuulG33rMxpV6M9cRxaESDeFeCpRQ4jD9qwVblQhCgeAa5P4GxVXetxgsEXWyVmGbpeM+TXdduz57/gopPeGaKD/OBEfNqb2e5N2H1V4/bwnpGh4R2VJWWKfbmHEFdZpYQ3kemcMBp6qib7pMhg/Z8bPsZLE+l4K/z1Hh6zegPd28WcdZ0hfkdh9JfOOcDC95L8/DxWBcc+40Fj7k1dCvDY16/MEIFI9LHTCEPmT07vAiyyB0t+jWUh8abQ9b3pD3ndSO90eD8vHSzJVR1/mib78nH3f5fmiYkppSs03jDOVuQ9OmXGKkzILsxL86VGaWs0w/A9++j8z7FapqGOgAXLlfG4L5noRgpvwGxbz8U7Gum/zd+r92YFQUBrjaOtIkPJ54B0gUxk7DJnrZn8voR2b6UF1OL0xOYsKYjeqanEvPTbPRc2meQkxkwCQ9K+/psQRQe3qMue4bFH5qQgQ8DhyuC/2kUcHOYi3F+xcjpkjrfa3MStLYuRaWVMykCHapq6brgV77cqeSbc65Xh3FRK8dsBAq55dZZGulqMhg0JvcFwtjC0HLgn5NILDapPveBvKs5o/Ye+zvvuWro6kAvjFhL3Gq0ma4gUiavveQ22diHhhZfBdBgm3trxP+iOg1kRJTkizNJodMQtBDZMEe8ZUfUjIZNkHGgmaQKp2rR7iEfSAAmCWdMIBKlrIGtnVQqW1o4jrLXb7Za34LnaJH7+BtEUltVZH5HcbNWOLEMalHmwtTnCkOJxz0AlybPwfS+N
 62NRGozW
 NA+kBu2oQWCq5L9sWolUh5AMa2DK8wjBQncAoLq/zz/nhS9uzdvlsgWeP1s14gr6YeuvUsCAVyWp7/hQD7kT4V1MH0W+TXwAIpJDSoZiAeacZWLy8JrPCtICq1AgUwwa+uxQS9CsYMUQXTbMPCi8F5r6R5O82cfqYfGJAyBpZtyspQZhJ9XoaEloDgYSImS/SQq9HNPteB7YVxebl3oJnTm2PyrnDQ36L0BRZlrt87llQ4LqT9cbpXXK5D/0G8gaghCRxTGuxjsMROOqjxSuBw+tBVE3SGww7mdXf9/ytgzM++1CTGVZW/5fZ2Tm5ynFQeDBMo5wJ5Vld069nRAGveTdqiG8fdfNJ2YskAYwUN5dOMyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
shrink the per-CPU cache.

The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
_256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
== U16_MAX, but on 256KiB pages PAGE_SIZE - 1 == 0x3FFFF exceeds
U16_MAX. The accumulator also needs to stay within uint16_t between
page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
U16_MAX + 1.

Accumulate the new total in an 'unsigned int' local, then on
PAGE_SHIFT <= 16 flush whenever the accumulator would hit U16_MAX;
together with the existing allow_uncharge flush at PAGE_SIZE this
keeps the uint16_t safe.

On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
powerpc 44x, both 32-bit), uint16_t cannot represent the sub-page
remainder. Define obj_stock_bytes_t as 'unsigned int' on those
archs so nr_bytes can hold the full remainder and the normal
page-boundary flush in __refill_obj_stock() and the page extraction
in drain_obj_stock() both work correctly.

The single-cache-line layout target only applies to PAGE_SHIFT <= 16;
those archs are 32-bit embedded and not the optimization target.

Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Tested-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes since v2:
- Based on Sashiko's concern regarding archs with 256KiB base pages, added
  special handling for such arch and simplify the code overall.
- Updated commit message.
- Have kept the review tags as overall code remains same mostly. 

Changes since v1:
- Collected tags
- Rearrange fields of obj_stock_pcp (David Laight)
- Fix comparison operator (Harry)

 mm/memcontrol.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9bee9031171f..8c1b65e6da5d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2020,8 +2020,17 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
 
 struct obj_stock_pcp {
 	local_trylock_t lock;
-	unsigned int nr_bytes;
 	struct obj_cgroup *cached_objcg;
+#if PAGE_SHIFT > 16
+	/*
+	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)
+	 * keep nr_bytes to unsigned int as uint16_t cannot represent the full
+	 * sub-page remainder.
+	 */
+	unsigned int nr_bytes;
+#else
+	uint16_t nr_bytes;
+#endif
 	int16_t node_id;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
@@ -3334,6 +3343,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			       bool allow_uncharge)
 {
 	unsigned int nr_pages = 0;
+	unsigned int stock_nr_bytes;
 
 	if (!stock) {
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3342,21 +3352,24 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		goto out;
 	}
 
+	stock_nr_bytes = stock->nr_bytes;
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
-		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
 		WRITE_ONCE(stock->cached_objcg, objcg);
 
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
 	}
-	stock->nr_bytes += nr_bytes;
+	stock_nr_bytes += nr_bytes;
 
-	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
-		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
-		stock->nr_bytes &= (PAGE_SIZE - 1);
+	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
+	    stock_nr_bytes > U16_MAX) {
+		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
+		stock_nr_bytes &= (PAGE_SIZE - 1);
 	}
+	stock->nr_bytes = stock_nr_bytes;
 
 out:
 	if (nr_pages)
-- 
2.53.0-Meta


