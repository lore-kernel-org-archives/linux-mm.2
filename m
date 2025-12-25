Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 668C5E7AD40
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CBE6B008A; Thu, 25 Dec 2025 03:22:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D166B008C; Thu, 25 Dec 2025 03:22:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84646B0092; Thu, 25 Dec 2025 03:22:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADD246B008A
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:22:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 436A0BA3E2
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:10 +0000 (UTC)
X-FDA: 84257300820.12.44A8927
Received: from sg-1-101.ptr.blmpb.com (sg-1-101.ptr.blmpb.com [118.26.132.101])
	by imf28.hostedemail.com (Postfix) with ESMTP id 460FCC0007
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=U85SMdZQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650928; a=rsa-sha256;
	cv=none;
	b=lidzFQPBd3+xS4PgYcBfI8mSt8Z9OzRAPLBYUmJ+QCMH8jFRZZYY7/DAXYizQEkB+3ylrD
	VxJVUFgml1EyUoRj/hNZrnX+67f9odm09sFs8C9J+f3fyeQl/6afFcRrxe2MNOoPQGuBT2
	lGJ9r/+/IVm4+al0f/SoilUKg2nHqYg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=U85SMdZQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7K6GkPYyCFR++S6aGBfoJNJnDFOzlltDzPDQoso/00A=;
	b=u1peZ1SpJgB/9rQ5rLHlI/5l9RA0/NMo9uH+tNm6SE9MAHtbJqQ3IjhYbRKpaxOjUWcK1f
	qX4grHpJgr9ih42XZhDTK9BxGrWIwlAb620bWiBlwmP0tnjoxrfJYWhtanPK2D9GOKrjYN
	l9Oz2tn0c3XfpIQbx29ZDKa951fA6aE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766650919; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=7K6GkPYyCFR++S6aGBfoJNJnDFOzlltDzPDQoso/00A=;
 b=U85SMdZQcuVuEGqqNtBjY6wwCReAVbjoh8N7d3Rty8cue0Q9D4pvF+oEXlGi03Zk0Wjo83
 QBYVwU7UkEv42plV6A0MPILvv4BtQ/1bAl+PmsbuFntC6lAn6YhX3c0Axczq7Pmba0GYej
 SRJwXNLfNrCOEbNooZEJcAMb1P/IMYt2bRRl3slbaTS++YW/O8NSIAVz3XiOtP4STDBrrD
 GgZU6++uUs23psCNtrjl9Kn6RrCBUT45uDHZB/VzXMGIAc10tAAmPYoItZCGThgcHmVBI6
 vweFSmMkX/4Hx+YuZZmm8fS6IQ+TBXuYdC4HgTPCH4/ndr0gZYItCbLNTP7YjQ==
Date: Thu, 25 Dec 2025 16:20:53 +0800
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2694cf426+c482f4+kvack.org+lizhe.67@bytedance.com>
Subject: [PATCH 2/8] mm/hugetlb: convert to prep_account_new_hugetlb_folio()
Message-Id: <20251225082059.1632-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Original-From: lizhe.67@bytedance.com
Content-Type: text/plain; charset=UTF-8
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
From: =?utf-8?q?=E6=9D=8E=E5=96=86?= <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 460FCC0007
X-Stat-Signature: x9jzk4oxcinrr4o8a4joao6arf3fyqge
X-Rspam-User: 
X-HE-Tag: 1766650926-568299
X-HE-Meta: U2FsdGVkX1/qsIvR0FwLToDrljpBRaWiBnm2wI8eIgh8d3SwAuQTaPT123I5JIN2LanHRxNnyvMz7CFahT/FXjAjWU2YCaLA4tg/p90HGRsEOa9IH8dYzTH9+w4GlhSX+0Ua0uPWA66EgxECAC6rOaRP8Iy1S3jc4R0INQKumAdNz/gEMMFSrcsPv4WakBT+M7S2Wz0Ku/kzNsmnDOBbUaN1d8Qo7f41Hi6A1laAyJmGbIddPpL6vKbhZCXFgIbaPGa+xPVU2JdRy59FOkr3QwzjNRaI5//4ELH4xwytHViduRCxy17/5b6D0UuxopjwTfYd6H1tNxX7adN9qvg8ZgWQudB0i3Ywc92/FTTi7UBxz3MrcQ/R42fbJlDuziMAf+1kV/SP+tcy2KRVJd+zANPwUKZeltBb+JeNw5WdGUDWu0m0dggfTY/zlnBhVNZkS4KNqbKZq6G1XY0yI4acSaM3m6bIetTgSjrR+iCO1C5HNRyolRBTbb3kInto+D/9I2sPJK7nLl6bjvqpmy0rLPaO6dqr8UvZoklTRG3amjsB03IXRSndcKD61ZHn1zvzN8D2JjEdYrbMehGuIVyzqCSbhCwVdp9zToVGPPPVHcsGl5/PBmYPSaV8pwGg307Q8Jf9DbWQ6DlhMN3DC1aqNkkZGKl1om4UsRujFMpsUVqbGQKBXoyaGuGRkNl3B1PK9JLmZIT9BEEZOcSJldEQ2smmceygFYn2mIi5GRYDiln6J0zJ9La1+bqdOkk5Bs2C7u4xRD3MSMFNwd9ca0SqUzokssNRNsnesMJpZf2AVNyB+xjEHjMB0lVr5bzoRfjhi1RWn5Azta4bTGCGvSu+RYjKqeDqc3MZerx5rtxOjQ1dhR3YooDlRdzcOYi8KZ7kHfBvcOlJ8ThcOjkiCKuCGCLcuWNKnuShqwhujG96MX5VsfDM0ywzE/7xc3NluFmGzWqq5pn97HA5i+GDGxT
 J7BCY2on
 NVyIGvs2/lYzphkg0UOedBz80pNHZEtyKsOUEYkbCDFBwBaz4ruvkQb5ZkcVH2UBNuHSSWDb3P6PKVxcJQKkKTPqFGGRBPz2a31oVY7O+Bm88Yf0TFFoAXGv01+thHIKq9Jp0tPGo6FdL3RkSGMLRo5onIJYeGXg5Rl8L4hCgn3jmlA2/laNIQtSPN1kYXaGD2r0MAI2UnNbG52MqbRmVL45FAqbqjDtVld6AK30uWFUauG25kCeDyN7k6yNoAmbx/G+YDGmAdmh03EBVga8VpOqTftKEzer3qN8IM1XrOTt+EHUiyBU5Jujx0y3grJM3fVyh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

After a huge folio is instantiated, it is always initialized through
the successive calls to prep_new_hugetlb_folio() and
account_new_hugetlb_folio(). To eliminate the risk that future changes
update one routine but overlook the other, the two functions have been
consolidated into a single entry point prep_account_new_hugetlb_folio().

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d20614b1c927..63f9369789b5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1874,18 +1874,14 @@ void free_huge_folio(struct folio *folio)
 /*
  * Must be called with the hugetlb lock held
  */
-static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
-{
-	lockdep_assert_held(&hugetlb_lock);
-	h->nr_huge_pages++;
-	h->nr_huge_pages_node[folio_nid(folio)]++;
-}
-
-static void prep_new_hugetlb_folio(struct folio *folio)
+static void prep_account_new_hugetlb_folio(struct hstate *h,
+					   struct folio *folio)
 {
 	lockdep_assert_held(&hugetlb_lock);
 	folio_clear_hugetlb_freed(folio);
 	prep_clear_zeroed(folio);
+	h->nr_huge_pages++;
+	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
 void init_new_hugetlb_folio(struct folio *folio)
@@ -2012,8 +2008,7 @@ void prep_and_add_allocated_folios(struct hstate *h,
 	/* Add all new pool pages to free lists in one lock cycle */
 	spin_lock_irqsave(&hugetlb_lock, flags);
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		prep_new_hugetlb_folio(folio);
-		account_new_hugetlb_folio(h, folio);
+		prep_account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 	}
 	spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2220,13 +2215,12 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
-	prep_new_hugetlb_folio(folio);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
 	 * as surplus_pages, otherwise it might confuse
 	 * persistent_huge_pages() momentarily.
 	 */
-	account_new_hugetlb_folio(h, folio);
+	prep_account_new_hugetlb_folio(h, folio);
 
 	/*
 	 * We could have raced with the pool size change.
@@ -2264,8 +2258,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
-	prep_new_hugetlb_folio(folio);
-	account_new_hugetlb_folio(h, folio);
+	prep_account_new_hugetlb_folio(h, folio);
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2831,18 +2824,17 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		/*
 		 * Ok, old_folio is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
-		 * incremented again when calling account_new_hugetlb_folio()
+		 * incremented again when calling prep_account_new_hugetlb_folio()
 		 * and enqueue_hugetlb_folio() for new_folio. The counters will
 		 * remain stable since this happens under the lock.
 		 */
 		remove_hugetlb_folio(h, old_folio, false);
 
-		prep_new_hugetlb_folio(new_folio);
 		/*
 		 * Ref count on new_folio is already zero as it was dropped
 		 * earlier.  It can be directly added to the pool free list.
 		 */
-		account_new_hugetlb_folio(h, new_folio);
+		prep_account_new_hugetlb_folio(h, new_folio);
 		enqueue_hugetlb_folio(h, new_folio);
 
 		/*
@@ -3318,8 +3310,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
-		prep_new_hugetlb_folio(folio);
-		account_new_hugetlb_folio(h, folio);
+		prep_account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
-- 
2.20.1

