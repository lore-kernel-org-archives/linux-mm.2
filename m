Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A67D606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 07:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gcTtyRVM
Received: by kanga.kvack.org (Postfix)
	id 5EA866B05B4; Thu, 29 Oct 2026 03:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B3C6B05B5; Thu, 29 Oct 2026 03:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B20C6B05B6; Thu, 29 Oct 2026 03:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB2A6B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:41:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD6B61C0846
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:41:30 +0000 (UTC)
X-FDA: 85374868740.22.798B74C
Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id E674EC0003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:41:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gcTtyRVM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793259688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=55b5s+R9twQxElwt/hmg6vi8POgmGGaNVzc+dDZF88s=;
	b=cUw4X9t0/JAofmT6BW0GW1Xpy8OiD7Tw3gngWdrSi2lEMZTi/ubKV4z5VlzE9xrodJoXlT
	UYg0T3qZ42LwYZuSs83qdClbdPf1+xFpHS+iAzbg4sfMvjUndMb9/Act2LGdwkGzzxmpON
	0D5FVdOfNoTPTwQjhxTapXyJ8axu/eA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gcTtyRVM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793259688;
	b=seUazvl0Racu44pbjNvkp551LXgGlCAgB1nEU0qjardvlmaqitJ87CCY/gUb7XFg2BJDGk
	lUkdbBwDmmWSK8kSuEIMzmAO3//sV1SjlnoNgE/JlNZQZ+PrzSqJiCCOEceqCUNKGY0m9K
	0iam0iMBaPxbcMcCgOJdTroR5HW80Wk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kqXkXah7tJyY7/8XgkA0XpkEeCII2v4IbMiHYj6hQ9o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793259686; v=1; x=1793864486;
 b=gcTtyRVM6pdvEsNQWrKhRkJzdWMLLeOlqbc7qyRtEG6LQ6/2dJoz7jS4tooOBi3iZ1BJSjNo
 uNq4NU2/rrnQ7NbbwiLch45wDTmAygvq2KOX9+YtqvvD2Oliq62FyI++T2b3G9SAamLTiKZR5pW
 Q9Mhv2Rh4E+3nqMuGcXJ4jew=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 34ecf73c26048443;
	Thu, 29 Oct 2026 07:41:26 +0000
X-Mizu-Trace-ID: 34ecf73c26048443
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Thu, 29 Oct 2026 15:41:02 +0800
Subject: [PATCH] mm/huge_memory: use READ_ONCE() when cloning folio flags
 during split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev>
X-B4-Tracking: v=1; b=H4sIAI344moC/x3MQQqDMBBG4avIrBuI0QrtVUoJY/w1WSQtM7YI4
 t1Nu/wW7+2kkASle7OT4Js0vUpFe2koRC4LTJqqyVk3tNbdzMQre+EAHz8LfEY2vZs7Hqy9hr6
 jGr4Fc9r+08ezemSFGYVLiL9VZl0hdBwnD1VtJn0AAAA=
X-Change-ID: 20261029-data_race_huge_mem-42f3a6005c43
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E674EC0003
X-Stat-Signature: hnmxxddyq78rbs4qhgom6u16n4nre7kh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793259687-900232
X-HE-Meta: U2FsdGVkX18o7EGr+tIpYHeY1LVb5QB1chbvtOd5Wp62PAiu8iqp9Gzz1TPd6RVU5h20v1HhmGqXd+Bk2dC2Jf1SOGKkbgtEP3DaVlaueBpQghVxrbGsug28ePFzyiSfKyBkb9q3PZ7z5Ws+iDJ5LMzkcs0sXqntGBe3d0PfEWuiR3cfARFArJ3Oz7yeY5DgjgDGlhfWHcZ1L5DnIm9sVOHgDHZb/OamJa+wotz4bfQbp6++McGJWB+mwLqTwJmmrdfKXJ4LGNA6HTIn6Epg5U3feguVC7jWq5Q0APcgw8G13C5T62OPcnkMog3t30HuDdpFp028l4AzVcTum19Fj9+oVEkJVosOqKNyFI2yH/iHKFoxDLq0aOd7uTquHSl6Tx/aObsng+VkcKFg7UA/T7YKsjOZ+0bY/C1O5y8iXQsOAEdX+4iVcPLnYl44izeUaHoT9cmuHFQ6rvB1PoH90zTFStovU5919ZAnoBANufy5QEgzopQ6SqXcVS2rNzXlJZsIeMAL+Yr4tlEhurxgJNWA1snIaN8TfxPO5rUW05lJtiOXN/dFm5n4ej1Zzz2dCx4YoSccY76DnyQtAP8wpnx7u4p1rakXVHQqaX332k+su0JAd5GMpzZFRrdoTCsMTkb7z5Z39mnm9HQct9tx7QWGtffu5ovTRPU2Ch4H5zEvP7ncuAjSFmBcbcTlcG50P9QV1Yy4uLrW7oyr9iYCgzb/yGovoEJsQ5hWj6ZRMk3v9aGF3neqL6z2lhOCs6AMoA9oa6QAuSGdZbF5bWvzQFm9J8QXbv4pGngApnb4ka3nczvfSXpZI4M10btoW6qV6xddst9Fv5CRRaheoFtF93ShlMRFqwVTXsFIBYiyrZK+t6z/j0Yp9VWfvr/NIzMgYUX6XE5HH+DXHwqeWHSfd5pvJ6OBNogBNpNaWegvkfYSMpk3T6xSlyPjFEsAOrZnb2en7s9O11g55bNTbMC
 DRgrcjZR
 oKxFTWr/EkzOSB4jOBbtKZ/vTWSzXM5ZgGu6YBfQ+pglN3iAJ/TVpY4UMlptmFpZs0XTmqiW4iyYBhp0NOWVx8XOcaBvTo9c1CSB0kBHbiYRLXA+TukNaYSsjuhLFTj+AeUqiDW7USMQar0O76S48i5x+DXr2/JJ2QjXwKAeZOm5A/b0iIWWf+K3h4uyJhWvkGvg3b/txWQybM9498/xOgShwMG/ZmVhLCyMO0SQTKDgRQ/R7RQDa9hlNjCCzxixugKclC1dNFRcIxLoVovtLLI0xjaJbRb8r9c3K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ye Liu <liuye@kylinos.cn>

The head folio's flags are read as a whole word to clone specific bits
into tail folios during a THP split.  This plain read can race with
concurrent atomic flag modifications such as folio_set_waiters()
(PG_waiters), as reported by KCSAN:

  BUG: KCSAN: data-race in __split_huge_page_tail / migration_entry_wait_on_locked

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..aac91c972ced 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3731,7 +3731,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
 		 */
 		new_folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
-		new_folio->flags.f |= (folio->flags.f &
+		new_folio->flags.f |= (READ_ONCE(folio->flags.f) &
 				((1L << PG_referenced) |
 				 (1L << PG_swapbacked) |
 				 (1L << PG_swapcache) |

---
base-commit: 6d0933ae9d46674a6ea63a87e9e9ab4e662670c9
change-id: 20261029-data_race_huge_mem-42f3a6005c43

Best regards,
-- 
Ye Liu <ye.liu@linux.dev>


