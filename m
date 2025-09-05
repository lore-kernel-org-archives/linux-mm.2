Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC05ECA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1074A8E0010; Fri,  5 Sep 2025 09:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8498E0009; Fri,  5 Sep 2025 09:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37B18E0010; Fri,  5 Sep 2025 09:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E197E8E0009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:14:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A663CB6B60
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:14:06 +0000 (UTC)
X-FDA: 83855239692.02.AFACE17
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf01.hostedemail.com (Postfix) with ESMTP id B5FE840013
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:14:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=usitMJHy;
	spf=pass (imf01.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757078045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vI0YATYp7h2PCES+jpwfqumtKhHQsNMcqq9Q5sVv1i8=;
	b=MUtVpkPtmCLZXuzNCV9HBAtCSXfMcMI74GXTEckTi2a8ggFvUwr+Pk7p1jD3+xQ3q2zyje
	9Y25TC0PH0qr8truObBBz5jOx5dMx//zZAI03MTjA/gNJ5UDMhWVN1Qi6G4S/S1BgzCmgI
	5gQ1UhrDxaXfKtAL2o4DQUVA5h4XVTc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=usitMJHy;
	spf=pass (imf01.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757078045; a=rsa-sha256;
	cv=none;
	b=HbQcE+GTiS7jgwZ+fQQ9CkWs5FDMoPu+tABdr9pdFgjuTCKj2tRi7PhyY55/Stw5pcMveD
	uLR+mojR4/jxehT+bBajV4H9VIO6NBJNBKG+xO24T8EoimlTsOtaceOGIDtZZpCRERabmp
	BRHTihgd/ebJSYrunLQk1ytrtuk+oE4=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4cJGyJ0HnJz9tlt;
	Fri,  5 Sep 2025 15:14:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1757078040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vI0YATYp7h2PCES+jpwfqumtKhHQsNMcqq9Q5sVv1i8=;
	b=usitMJHyN/fOige9DO7Nq3zdziseh+9Pv08/2JJP0L1e7y0s4fbFkJduVcfFHGzFe2+1sa
	nSNVjJNACSlQ7uvpVnkHD1+8jFylp7gWd9ee9gLijsKORXMBrk53kmC71teDQxdSSPJ2A6
	8D3077pM8ITeQOitBEmAPk8NAOmueP8OughNAf1SvI3KmUpKLs0Ehcs7MSVAs8wBwDqwzX
	wcf5XCYeWEgL0eTpdZpwMUsLHPEB04HijdV3v1jHxxF0QF3cYHNzMB7ttg3C18Joe/X326
	8D4mgF+cE1urIzgCW/aQLaK2h9q5W/VO+kzBAnT0Vg0LRwwpF2KgvoaTK7gMnQ==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	Pankaj Raghav <p.raghav@samsung.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v3] huge_memory: return -EINVAL in folio split functions when THP is disabled
Date: Fri,  5 Sep 2025 15:13:52 +0200
Message-ID: <20250905131352.88069-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5FE840013
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hia6417jz1q1ewbhzxhzz341aiin8gy1
X-HE-Tag: 1757078044-3905
X-HE-Meta: U2FsdGVkX19OBYa/PVUFJMu2/fzsO4Y2CBNPelob2uPXepKzHD0K7DG3/usMdi1a1miT7u9LnuZi7sBpOyG2DVcAwgkCHGtMJakpad2Xbw3YWsqb2gcDfOb45VutzfCzylV6cVpqUeZrzKD8lqJDq+7aUUSBUVVh3QQRG2hSdP/BT2f7fg3fmWlG4ov6xaKqCGC3qlC1Xi8Lrk2Sk5RWDq1GF1GoimTE3OmPgiD6NeNosyAh+FL4aASUV/doew+fzTijvLAcwQQDjhOb7tknoEqnODvAlWRkbUbmquAepkTDTSajQ380M+nVC+GJuBqUmACS0kHGIbx1yhSZxu+ybyovaHTy5Q0FrUMjTBvTuidnP9EZ4eKvQ3C0TAKXQgrRPXKL6xJd2U4f4Bphp33qI+Qb9azlzDNX+/Nrr4aC0sf2YV3QQgtlZ0MjyohLwvpwnuExooaHVYkB409srbNB0Ru9HVEHeE+SUH2HYW8Pysc1pPNyVHMMa+Mwgzjz2rvKHMZsWNuAG0+qC72FkoJGrmmqXx87+8FxkVUbMPSqv8Whgj3TIAB9qdceSN9Q4BnuS+S4uPwDTrdIfqaR32gHZD/rInihxYQ06Kcclb90n+GPezzemrAzwWltLVEAxxUa5XlxySrxV3SwfF3brp+CPtdWdKNHXk3pDKoO88xcMRRVEmBJ7V9D61JBCzUk94ij2LHjRoaew+xYkk7V8qtXCTKpvaGm+87x/Gw3wbS9J0hjpvbka61EjjHq58LOP9oKVP8MwSDtmgA4Q3UIcF7PfOR8GFyCtfAXdb/g/UJ6HKZtKfUErGUd2QnstycA0EjRdZhA4mTsboG1FLmomIA/DKSZ5l83/rUPnL2noURinfTEzf0O2igU3nQ5Ej2DYuZj63AYOTLKtBfC4D5woJ0XVJ7SipZjYSy/BET3gbbJU3lyArrxj1DPbzf+Romh8RlA3cpSqew1d9ELSvVHLcZ
 PBlhSgrW
 JsI93iSTeSjFTgwzUi3edT5nW4nIYQW+cAj6Fn4fSASxzmXnMNkNqbibvMKnQD3VrUkKzBk1FPZ+9i93n/svlFCKG5AYM0iueYIY9H7/fdx3EuH4UNGw0TMGNTaXaM1ghGAtAMayyhxzOR08Y3JgGPyESdFjBlh8e1SCbXMLAGtxi3qH0XL/mdFZ/emRfEZAuZ5A+HR5iqVYu4eWvqpEm1qXvT3PcqvPgfDfxGhuYmBe7UlKsec8cqLIvwUf46VV7gTL0pbeyYdlEmxm9dtAj4v70ep4ipzIUSk1MfoyJ/mmnbHhT2Ea/slX4ll6UFcUeQQvzWti+mK5tUPBZi365XgHcZAforMGMpBQU1tQqSXbKDIfU+SxsGbe0i7iih25O6AoV4FpPuiZGOFqVeL4aZYV7pRpCWvUab5VrZxHd7VeQbWO0GJiUhLvUnlBy5vxuMJVenmUdvJ8aoPbufHZj9wdbyLuJU76N1MRKn+sWOTsiPNEVV2wOmWkZi1FuKRXhPiKj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

split_huge_page_to_list_[to_order](), split_huge_page() and
try_folio_split() return 0 on success and error codes on failure.

When THP is disabled, these functions return 0 indicating success even
though an error code should be returned as it is not possible to split a
folio when THP is disabled.

Make all these functions return -EINVAL to indicate failure instead of
0. As large folios depend on CONFIG_THP, issue warning as this function
should not be called without a large folio.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509051753.riCeG7LC-lkp@intel.com/
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Changes since v2:
  - use page_folio(page) directly in VM_WARN_ON_ONCE_FOLIO

 include/linux/huge_mm.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..1aeec06a89f7 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -553,22 +553,26 @@ static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, page_folio(page));
+	return -EINVAL;
 }
 static inline int split_huge_page(struct page *page)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, page_folio(page));
+	return -EINVAL;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline int try_folio_split(struct folio *folio, struct page *page,
 		struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}

base-commit: e6b9dce0aeeb91dfc0974ab87f02454e24566182
-- 
2.50.1


