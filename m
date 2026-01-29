Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F090D73E80
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 18:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E906B0088; Thu, 29 Jan 2026 13:41:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC806B0089; Thu, 29 Jan 2026 13:41:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE196B008A; Thu, 29 Jan 2026 13:41:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC246B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:41:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C10E4138B08
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:41:28 +0000 (UTC)
X-FDA: 84385869456.21.915B863
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id E24DBC0004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:41:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EQTSuFqu;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769712087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xlnz6aumZlbTSchYue5J7VboFXhHLrpxFx7kxdM7jFE=;
	b=pTZlWVVtLOeLud5Pok09zcI7+5XVsWv6n/N6SKjPy7Y0GPBQy1IkMb59Qp14MTVEfKyAvL
	Gr+BByasAeH5UYElFMYj/OLgMlC9h1owAW843a74ZtzznLfFioRWIcQmhj6Wx8IPja7JrN
	GGfGK2tZbC3iNL91HBhCD0Zkj+628mU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769712087; a=rsa-sha256;
	cv=none;
	b=aUBU9WLmU4WnQwhwjqs2QYUTVZ8vt4o3wRBfzgQsX9Hdi6NOQ7MtgNdKHObcO+yb7QQ0eV
	IFJtG5ng3vwk5tCiFWQR0PWhZ9cVjP1c2SqPwjmIS6/2hno23Mt+/vztLiLuz+qDkUKq1U
	FJyKdUdYPe67SPY5qBH5OnrqHZEfSgw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EQTSuFqu;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769712084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xlnz6aumZlbTSchYue5J7VboFXhHLrpxFx7kxdM7jFE=;
	b=EQTSuFqu2W3JWsXY4FbUgQCd0SKbNN90pOEAd2Qp3H1CxbG+umwpCdeFrwFn5VozImAsV7
	P2i18zlTAQta3caaUmOBL2jwk+HHw6WVSXKd2mcH3MYqYrvfK+rEW73UDNfzPqey+njdS9
	ZCaq5KgPZNWPDSjkwN/KypqKs8hUWJM=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in collapse_file()
Date: Thu, 29 Jan 2026 10:40:54 -0800
Message-ID: <20260129184054.910897-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E24DBC0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gi8t1kum9dshzhaq8biezkriscs19wec
X-HE-Tag: 1769712086-341172
X-HE-Meta: U2FsdGVkX181/goI9hzqq6sDltF0K8E8pObic8z05HF5TuRPbp0DEV9fknnK/I5QRNQPDRimq0GaLGiSeLHNnsZEizLheIl1rKilxIyZUNgNAY9aj2yQFiS5pIq2yY5pK1FGZaB4PJOTB99zzTyTB/yz6mWZQdWOgm0J1V1zomOE/3y0zhz+PIAiTDNhfBHvGJx04EGMiyguuHcMq2lhNyG+ejejUuiMNn6CARQKvdSNfNUQ51/AOECKgfDvj6HSd0atLKA/upraV4O5vogLIzncvb/xlTQC6VMCgV3ryC1wCbC5w1ICZi492P3ZbaK0t4QJX22ZoJVr4PxWcl8chSNr0olvwHVSRHZKe5+091XJlOj+Uy6B/TXkhHQxFXpN0FjfWBHyKJCZJM8zfft8TsgLA9MoIY9bBZVsS6N39q+XOu84bvFpFTKLru7aIuPsOrLeCGwx9hmpVvT0q8X3yNxyFdI89OHq6vc24orup06/uDz0BlI0fIDdNqKxIHWpPHqw/tUxNVp5Xtu77bdSc/jcVfU7D3oGiaD6eKK1bj/zyTwkRSNpqXDEBXv1ZfBMboiX2vIxsrI8JEl6sC4rcxbki9PVukWy4CLfQELrVxHFhplyBJ2TRFpJriOC8xc70FLfUgpxHuselLgRoPYG07+YiPVsKEiSxz7RG32IaFSyeUcuot1a5T+s8gG1DLL1J1vexdNFRszev8A7mqWlaxBZc19BcpkqF/ZwrRjdbfUVAKKwI4lNr/S/Qjm3hfgITIvWW3nyhuJHpHuti/Sx81ZHW3BXyGpIkduVS6A8xGWI2IUTG1jymg1RFM+jQ0RYSgPI2+tw+c4xkCbpXIKniac8tJOA14ADwAZWjb+YJe/CctTb3/DlF2ApMdEj0HAWfrxXukKFbkSx1haw+rFJQO1XbZGnKz33dYrVF4ViaNSOpFpHOWauXyKguxPsRqnf78KUj+OGHChxJYlJ+dG
 e2e1wDBd
 aj3P1C0v10biWdrlp7LhsuN0maURrVIYmie7wRXTqR/TmV+xfHtfdql977wRjW2EjMInL8M3jx+kMXASiXfu/cdn3oGxcSPccYcTv/7f9/wo6LhljOI9MQQd7XyeMY+n/0gZBPl04CQpAboW9vYRKMCvmfKajpLTUrpBwVZdqTx50T+zExdUObt96yrq0u0m1MtOouQQ3omYrWT1+ckE9CmPqX4YSpKlKqH90/J6dwh6irSlSS2ranjLnCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In META's fleet, we are seeing high level cgroups with zero file memcg
stat but their descendants have non-zero file stat. This should not be
possible. On further inspection by looking at kernel data structures
though drgn, it was revealed that the high level cgroups have negative
file stat which was aggregated from their children.

Another interesting point was that this specific issue start happening
more often as we started deploying thp-always more widely which
indicates some correlation between file memory and THPs and indeed it
was found that file memcg stat accounting is buggy in the collapse code
path from the start.

When collapse_file() replaces small folios with a large THP, it fails to
properly update the NR_FILE_PAGES memcg stat for both the old folios
being freed and the new THP being added. It assumes the old and new
folios belong to the same cgroup. However this assumption breaks in
couple of scenarios:

1. Binary (executable) package downloader running in a different cgroup
   than the actual job executing the downloaded package.

2. File shared and mapped by processes running in different cgroups. One
   process read-in the file and the second process either through
   madvise(COLLAPSE) or khugepaged on behalf of second process
   collapsing the file.

So, the current code has two bugs:

1. For non-shmem files, NR_FILE_PAGES is never incremented for the new
   THP because nr_none is always 0 for non-shmem, and the stat update is
   inside the "if (nr_none)" block.

2. When freeing old folios, NR_FILE_PAGES is never decremented because
   folio->mapping is set to NULL directly without calling
   filemap_unaccount_folio().

These bugs cause incorrect per-memcg accounting when the process
triggering the collapse (MADV_COLLAPSE or khugepaged) belongs to a
different memcg than the process that originally faulted in the pages:

  - Process A (memcg X) reads file, creating 512 small page cache folios
    charged to memcg X (NR_FILE_PAGES += 512 for memcg X)

  - Process B (memcg Y) triggers collapse via MADV_COLLAPSE or khugepaged
    scans B's mm. The new THP is charged to memcg Y.

  - Old folios freed: NR_FILE_PAGES not decremented (bug)
    New THP added: NR_FILE_PAGES not incremented (bug)

  - Later, THP removed from page cache: NR_FILE_PAGES -= 512 for memcg Y

Result: memcg X has +512 inflated pages, memcg Y has -512 (negative!)

Fix this by:
1. Always incrementing NR_FILE_PAGES by HPAGE_PMD_NR for the new THP
2. Decrementing NR_FILE_PAGES for each old folio before clearing its
   mapping pointer

For shmem with holes (nr_none > 0), the net change is still +nr_none
since we decrement (HPAGE_PMD_NR - nr_none) old pages and increment
HPAGE_PMD_NR new pages.

Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1d994b6c58c6..1cf8e154e214 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2200,8 +2200,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	else
 		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
 
+	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
 	if (nr_none) {
-		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
 		/* nr_none is always 0 for non-shmem. */
 		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
 	}
@@ -2238,6 +2238,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 */
 	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
 		list_del(&folio->lru);
+		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
+				      -folio_nr_pages(folio));
 		folio->mapping = NULL;
 		folio_clear_active(folio);
 		folio_clear_unevictable(folio);
-- 
2.47.3


