Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97822C55174
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 03:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390086B007B; Sun,  2 Aug 2026 23:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341286B0088; Sun,  2 Aug 2026 23:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232FA6B008A; Sun,  2 Aug 2026 23:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E69406B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:16:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BFCA1A029B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:16:21 +0000 (UTC)
X-FDA: 85058494962.08.CC5A2C5
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id D0AF2180002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:16:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Fx/Z3Ul0";
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785726979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b+aMIKSO//d1fSg8tl4/EeetnqsPLo+vwdX9y23O+JA=;
	b=HJBZBWbBBi+Jz+isgad4lQPBdWdcoKPYBN2A/tzPXXm0XFoco4z1TcXqMXxnORN0z54bc3
	55v9+tViGPPYc0oDBm9I6nC/7dlzK1L66q+yUBrxqk3GG8FTqqxX/pBIjTZG/WqZLtKapl
	9XY009D8eKoXLRgkQ8uKW516+DpgSQs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785726979;
	b=tKRWJCBtjzx9eR8/rwd2FljyGUZanQnHV5cCR3yOQqKvDrYoX0lax0DabV3mzKzdyw2tWa
	d080odAVzwyjhb0LAyisMmT4J0SZXqnV/xSbG12Hi7fBRCYFO+ukg24+x9w/Kc2dnBfi1P
	bYkjdcvtXoy93O3h+wNr8CvLOAMBBgc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Fx/Z3Ul0";
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785726975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=b+aMIKSO//d1fSg8tl4/EeetnqsPLo+vwdX9y23O+JA=;
	b=Fx/Z3Ul0PW2clHWzK3++h8OorOKGBAsq/apRPKxJ8vQV3nrNGufpmkpaPpMZxb9LyFR6q1
	4muuRhUeJrp5TzISmabx7H+3pvefcRjxYG3Yn/xWpOqQwyPQ45JjDVL/HdiU44m/3F4A0G
	C2KCQSSMzudPO3+KRIJ6KcwoJL4NF+A=
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
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v4] mm: Use a folio in the softleaf_is_device_private path
Date: Mon,  3 Aug 2026 11:15:54 +0800
Message-ID: <20260803031554.30421-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0AF2180002
X-Stat-Signature: k7b3tuscyooddfn3j6zcuqm3m4quprje
X-Rspam-User: 
X-HE-Tag: 1785726977-827962
X-HE-Meta: U2FsdGVkX1+Fd1h482g9PBEyGRcpokn44AExqRl21jIs5sfTjme9UO3wrQU9z9vigSD8hRSrzIfMUos/E8Bn6YBBkrgi3Bal872qh0YXu48c1/tEe/g1y/Odp8fbLj7XPyicUsORA7i41KZPZBvYZAaWhbun9eswUOMHyXUnUnvgrMY7ihRamEKGWzetBLNCCrKEaR4nOC5+K6cTpLluzkkVvsTYBFtKTsXDNpA/gzgIOQvc7NkUxLND+uPQ/GiL3xhIljg7V+rSix47UvsdxCE6FpAlVIa0QexNkCxgAwoyHlHObPzi8e/RBRWN/rGer+dTbaTDI8kpYNkeCRhDF3vJZP0EhtDjLwNxM9VgZ7WbxE82MCTISW9jQtdP/2EhaOJZuXF/59xH966JOKzWcJMV0rpQKBUyvPa71hjaxJ4N7py0t/tlAcbzKlwLh7MoKbJmND+tpO/kvX+6qvk1FtpJqEViw8NYFISqYgAARQRhgqTCCnXeyGnLfpZw4syreTGCmA6QftHVIgbGRe2CJELlyU0UDnUWafUwwvpgoWax76DSrDOVHZ2lR4tnOuat2qDpBFq0efeOz1LYd1LTMmfmlAJVpSYYOi84pNFkZ7pY+yrBfB58nB3A19PKBC2L0IzBfGPiF8iIOjGD3QwmXhOmEmNRjWCwo+wjyTS1jYuWvrEhCaJsOVrgLlRsRnCnlmnT8Q1AW1JtpYzzKiKiN3x2u2/ukiI93gucfDPpN3nnUHJlpg03WkJMStdl/KSVg32xFLffTcdjsZ9OeMVVpZ3P9xMvXAss7tZaAvy79v+HvAYbmfD1MmoYGsX6ZvZcNHHOsmuF9uW09jy1PpRnjeuw7Zo2Z+0lfFt9zKnzllFRozbycr+BFzFbqJpYrz+V/dkYQa/+2AzCNy1AyrY+WA+tMlDO8nMTtdwBxQiNz2dAs9KW4Zc6Z1rUhzFnxj6P+bzYmJMlTvT+mjsBOLk
 sGkx144v
 /EvFyL0wh8ToBBWW30WiIiczZjV3odgQt46f/wkxGal89b3x2EebFnZpLgHnyGF8pPatPCgQMqQXiDePTrxiRaiQYp9jX39JIwZuzMR73/qnjp3oKSrKDOumlIjV0wOeYxPaoUB58ZqI0dFFyYyUrKJ9RPDf+nYbiiMbFgSiVw3e75auWrGmGvfej6msGQzPPbQwa+xXRjh1K7EQdO77d63efZr/seGXea3N9mkz+E2IL3ZsKYKalyHVX+l2y1UPuEVgYm7ZTGz1uYb9c93RDtWWEsSvbE0LmunDuQmg/5i1Il186mBPd2f9VLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Use the folio APIs in the device_private migration path of do_swap_page(),
replacing four calls to compound_head() with one.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
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
 mm/memory.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 56b244552f13..bbb289ba09d3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4873,18 +4873,19 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				goto unlock;
 
 			/*
-			 * Get a page reference while we know the page can't be
+			 * Get a folio reference while we know the folio can't be
 			 * freed.
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
+				folio_unlock(folio);
+				folio_put(folio);
 			} else {
 				pte_unmap(vmf->pte);
 				softleaf_entry_wait_on_locked(entry, vmf->ptl);
-- 
2.54.0


