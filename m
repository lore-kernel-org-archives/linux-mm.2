Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10988C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125466B00C0; Wed, 22 Jul 2026 23:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD696B00C1; Wed, 22 Jul 2026 23:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30746B00C2; Wed, 22 Jul 2026 23:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C85B96B00C0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:08:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31454A0FE1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:08:33 +0000 (UTC)
X-FDA: 85018558506.29.F9E20E1
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8CF141A0004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:08:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NhdfXIrw;
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784776111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zh1iI5mLWpS+VDOHW4U6amM9imbdnYQ7KT34I489wBU=;
	b=faWDH6k4Tw3mvlczJ3Dd4ulU1yIkHp97apP4fW4JhD3L8mQsxmvVJvU3aw00kKVCF98Gq2
	AjAuS3ASprD8BpY2U+QpElq4joOGxF8aSrEIp4UGMvj7d5mZX1bqpUy8mZJYAnu3/fcdHv
	58i7uqCP9rIRovaXBpJMmMRmCSlw7R4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NhdfXIrw;
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784776111;
	b=BFDIGGe3q6L59PSe4Bc1orytk20ZM9QKAVrCpmAvl3cXzH0MGa8JDbkOFnUmmCKcK/sV3Z
	NhOIQWEZWu58iQCKbbSvWGm+QszJZoD4K5XGlJneOaw4I8LRtx60oHj9JQAj9JW6WJi4hx
	14WiEvRi6oTb9flTrAxaHLVG7ELqFMo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784776110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zh1iI5mLWpS+VDOHW4U6amM9imbdnYQ7KT34I489wBU=;
	b=NhdfXIrwsO0SAJE6eS2ihTQzVD7bTOUjzd2G6m2sDiOfn7RYt4rUE72Mp0/GFM9TD+Mv25
	qAmyRQ6ORtzakAFm5N2bsLy0ppXzjSZQGdSpEmd1Kc+p1r1GqTloszuf17VWBHsuhNrCTE
	JloJHT2tyJg6gororePhQOabkEK1Kb8=
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
Subject: [PATCH v2 1/2] mm: Use a folio in the softleaf_is_device_private path
Date: Thu, 23 Jul 2026 11:07:51 +0800
Message-ID: <20260723030752.16979-2-hongfu.li@linux.dev>
In-Reply-To: <20260723030752.16979-1-hongfu.li@linux.dev>
References: <20260723030752.16979-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CF141A0004
X-Stat-Signature: rbuozk1naprpyoxhie5gfwt4chxetomh
X-HE-Tag: 1784776111-405571
X-HE-Meta: U2FsdGVkX1/wb2zNgI2r5eUIdX9wwiBJF+TsQj+CbBB6YuTe+cnQCUMEqtyFAkoxnnMXOm26Rco+0j9lC2tRReN4seGnhWP66Ob2e3N1lwoogoUSQMPG893iuvzWobbRcONAeXUVE3O+/ir/epErH3eq97Qkws8z8aBnXh+h+Uh7mjSWWDARkm5DzSMiD+2UXycqLDvod1utzCugMGtQVA8UYT2OjYOwSt+GXDEVDkSaHysjIaNijSSRT5ExR2RqutTxCdotKR6zuMqxP7PKE9ngvvqnCJ4pfS6pqMXa33d8lmiLwk4hdvMCzWdqoTY3rZzTUupPw2+FgoBQ3ve2EPoG+zhn7Q/yjVJAiNjUPihDSuqHY8odZGrrir7UFGCBfwAotobCArVtdaDhBDVMRMu+r8OYSDGUudlk4JsIP4Vn2mds670SVrtkMNnI82CkBPFr54aDfBoEfTBnh+4Ae6IG52NqMBPoBMjW3wmiQQ9icSXWkBGpgbPr4ysYuGoXE0faeIXs5DJSHOFBwyggI8E2jS3Bba6LLau1U5lNPYAFn2bIs9Xxp1N0qIN1IeECxDc01xoE2Ro4HRnNICcnRK/3TQq50/XtTtLgj7n7Wv2WxYIWhXkVQu0NnGrrzlUPAD7vnwON/k6GFt139dbz+Y6gFTmOFdMT7mXpU8MdQBIh6b2yPDN67+idq2cRiFnLwZWdmgYzShcdUUHUfNxXS6Fnc6wKq8z1E2uT5gZcaJ9rRfbK1cTESoz2QT4DN48If/h36BDNHSEr6CBZhHmHzrlnFzOzav0p6vK6DQUuxCUNhnRA4mipZaBv9LltoZ/HhOC2WZiKuS5ykFmG70xuU6yE0q7E7Sz44ZH83imav9JMm1Kl/DwWxOdrF+VrwcFnZGnUQyUmmnTsVxgycVuruN71pkBAdXbQQkZDhSbeqcKkGidExHDyzcoyIuJ6egEnI+jSBK1Ql2vRy6cHylz
 yLagEDCp
 s0Jhv6aGeD7wwH3tPPJ4tYGYjSXNkBSolTs0T1TeMVJvb76xLqupIAYB1Itchrl+W/JdPJvW+Ap61UASAqaaRXCthEopKO3vrpsjQPvvpA57R38qPzx1d8g/YCAfkFxspTV6Rl5n6CtBjhqJsTYG7vve4fv10I8KkX4NLZ//r1zkQRVX4T3HJluCy1sk1voG+cMYQIm0K5WGTbZSR6YP7WgARbJAWRPMzVAuk2aQDt7qNCMk9+KFPQz3iQpWgp46PShdBcC4sblVpJGlK3iFDFhOBUQ==
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
---
 mm/memory.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d5e87624f692..ae521baa8c84 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4871,18 +4871,19 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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


