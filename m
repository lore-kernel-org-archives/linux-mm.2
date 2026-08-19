Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34705C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505A36B0092; Wed, 19 Aug 2026 05:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6B26B0095; Wed, 19 Aug 2026 05:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC266B009E; Wed, 19 Aug 2026 05:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 213CC6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:52:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2EBE1C186C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:52:06 +0000 (UTC)
X-FDA: 85117553052.04.31614E4
Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68AB214000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:52:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kOec0YPi;
	spf=pass (imf09.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zw9QW6wJMW8G/D3886wu/KIEeuvDE0Qcq/15FXrlTSY=;
	b=l/HI3dssApCVyMWoLQzxPqWwqTJajRQjfJkOp55ilJD3N9MU6zgL8NzwwXac2uG09J1k5J
	nWCMSW5MYtewYlwzAx/rsJvy4y88YvsQADHt1prGGSdMyWalQ3t11wo6m4CKyMFup15Rsl
	k2YFFe/9I4HSsUCrIsFN0s39fiumK20=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kOec0YPi;
	spf=pass (imf09.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133123;
	b=zTxPjg6mtnfxshq/1lsrElAUi44145Ndq9L+Zbf2LbFrjXtvLcK4tOhZwQEQCNyyGRUjv2
	Y09x+6CcIctT0PGWN7zYDnhXTQxJJRJcH9nbY3+6wcEKcoU6bCyzMaKne5iGKdLGWNyADq
	U2qU+1PG75jLqUTadYWY0EQLa+NKrTQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CI9/mKbXLgZPePj0PuaizCdrPnCvZfojfp0mQaycTFk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787133121; v=1; x=1787737921;
 b=kOec0YPipAkj7WauptHufqCdUxwPl6wJMUULr6yGceNdM51kLlXK8Ia4h3ocn1sMRu+vFyON
 JZZkhC6d4vhgTi50pxKi+4FfHqqsCvM4z6eKHysRPzTMCh769FTEfu4amAnQLzWesLF7CvOBapd
 0UiWE7vS/OKWNMnLIzsaLX8c=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 26f8142df68d5de4;
	Wed, 19 Aug 2026 09:52:01 +0000
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH v5] mm: Use a folio in the softleaf_is_device_private path
Date: Wed, 19 Aug 2026 17:51:43 +0800
Message-ID: <20260819095144.45660-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kc9x4ned9385xbgmtnif858h7nafo4uw
X-Rspamd-Queue-Id: 68AB214000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787133123-497242
X-HE-Meta: U2FsdGVkX19x+sPHUv7mVoHGppmOoEg+z+Kun5VoRnuFk+FmyI6JYCWzQyZxW5uRZp5w8+MMcOGcMV+Zx0xHA2BUtvfVNglPDBSuLKVpkAirrG2SPLmtBdw9gIw2VeRA362mXK5fV+8A/ZJelO0VXUKrESE4/01KoD+/X8AQyk2nLDschwzjnS/0SNLY06y03bxoUyfX1VF4zxStptMamMhZPc9rcQerH6Ix59AeKeCeBcJuUqs70K80Ni+gU6Wu+ZSLFtLqlfGKP7mTxHU9aMhB+GPWxRVWKL7GdFC5C8iOBw9U979VoB3GXkhZA5sgZN4WQjgKf6dLMtueu9jj1fNEcphS8dEhIEj9KCo/H49ZlfI/90O1Y9q8wR3oO6sGhz5bBMmqLcqfmzURCPrF3n/mOQ/qSVzRydyKEozGikkuO26prZJLF1n/GPlyCR77mafVpKW0oDw2n9MEsibRUayc8TWMhajXk16QQageszt3E7ArdiIH4J7K6IErcEUyyBlVgrmuvfB0wLdzQL+wxEXlX1W0qU8QnAlGWzjTgFGe6D3NMZYCUak2jQc0EZzhJk7OSoxLXLJWoStctZswdJwNn/hXAVAACFBd55LLAz5CjNofrV4f1U987sc7BUAy1MCclZkYC0zX5+uz8f8Mbia6QOuEtZnWu65h8zyrPo4lN8Y61jx0vh8rgbFwTkhwQVbxhe9VEwValChdtN6TZpj6Roa0jZMVgFCO15Tz+5B4C91cbljcxyx1FYjP42eBw/2O9OI07Z2Uno6ckwsJnFbcwM7HGOwDR1bqGiu8IHf8nxKjYbOXsN+HjHmvUDvr6EswVfgrk1LfNcuapbpc0aFTyJ51zU5g6EmLz4h+YSQhllYHqqRo1LrjtXkjze/twesSHo54V7hMA5VU/459hV9zdIqyGcN3YOJ/rdesua7bPIu/M6ItJcT/GtSOwxs5BWaW408BBVf/FURRde/
 1OMVAdkn
 N/10bQAdfIgwQXD+POmIsM4JidvdkXrzNG9hoKx/yMi6keXQPDGTzvTBjmqhVjsm/8QGT9SM2LSMEipvh8CR3OBydVaEhsNoTgqRTYsmaReyRwT3WcLZwUvzhfrEyfpf/sCY+/X5W9c71MBsnRBYTPm1JRTcMDrIvzlhH2C9PQ6GiprTyByJZ9+hGFvf9pmIn26EH5MMuBFnolfVLsYDJvkN6fx7CJmv05UO+4orDhtteJn8G/6bUoaMRQohkCi/TSPFgaVeSZIevCto5ltHy3bsYB4K65kxJQpl6t5QtjQfhqFuYC0W/98d0cob8+k7HAVvugFXnKW6JRluMNVASF611a/y84vjS3KWiZouYbGf9Z5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Use the folio APIs in the device_private migration path of do_swap_page(),
replacing four calls to compound_head() with two page_folio() calls. The
second one re-fetches the folio from vmf->page after migrate_to_ram(),
which might have split the folio.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://lore.kernel.org/all/e20678ed-3fa1-4677-a1d7-e2af481e8302@kernel.org/
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
v5:
- Re-fetch the folio from vmf->page after migrate_to_ram(), which might
  have split it
- Update commit message
- Add Suggested-by and Reviewed-by tags
v4:
- Drop the do_non_swap_page() extraction (patch 2/2 from v2)
- Added Reviewed-by: Lorenzo Stoakes
- Link to v2: https://lore.kernel.org/all/20260723030752.16979-1-hongfu.li@linux.dev/
v3:
- Please ignore v3.
v2:
- Drop fault_folio, reuse the existing folio variable instead
- Refresh commit messages
- Update comment to use "folio" instead of "page" in the
  device_private path
- Add Acked-by: David Hildenbrand
- Add patch 2/2 to extract do_non_swap_page() from do_swap_page()
- Link to v1: https://lore.kernel.org/all/20260721013347.65698-1-hongfu.li@linux.dev/
---
 mm/memory.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c54943302553..c6a9242d1b5b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4926,18 +4926,21 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				goto unlock;
 
 			/*
-			 * Get a page reference while we know the page can't be
-			 * freed.
+			 * Get a folio reference while we know the folio can't
+			 * be freed.
 			 */
-			if (trylock_page(vmf->page)) {
+			folio = page_folio(vmf->page);
+			if (folio_trylock(folio)) {
 				struct dev_pagemap *pgmap;
 
-				get_page(vmf->page);
+				folio_get(folio);
 				pte_unmap_unlock(vmf->pte, vmf->ptl);
 				pgmap = page_pgmap(vmf->page);
 				ret = pgmap->ops->migrate_to_ram(vmf);
-				unlock_page(vmf->page);
-				put_page(vmf->page);
+				/* migrate_to_ram() might have split the folio. */
+				folio = page_folio(vmf->page);
+				folio_unlock(folio);
+				folio_put(folio);
 			} else {
 				pte_unmap(vmf->pte);
 				softleaf_entry_wait_on_locked(entry, vmf->ptl);
-- 
2.54.0


