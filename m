Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F411C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772226B00A5; Mon, 17 Aug 2026 03:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723906B00AC; Mon, 17 Aug 2026 03:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6387B6B03A4; Mon, 17 Aug 2026 03:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40A166B00A5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:52:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D22AD4070C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:52:18 +0000 (UTC)
X-FDA: 85109993556.03.1DBE743
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf07.hostedemail.com (Postfix) with ESMTP id B2B3340003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:52:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=MPcDCT93;
	spf=pass (imf07.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786953136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9t9jRj7/HCFVCvKEHPg2zTk5Ak8y48z3aFyjzy9sL2Q=;
	b=nUu4iR/T7HM/BuzPqZsEeagRZREVZknA8bsFuEpiR2y1S11cSPB4qTKveeBXk0UgOmXujC
	/oPNAdgzchogMXmOzy/n504p/X6PcnSHquo9lvDzMxBiBjwu4epVC/3/0i/RGvFBcNNeyq
	KW+C4JUBctpyvZc8V0T4MkiqZiaUtHA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=MPcDCT93;
	spf=pass (imf07.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786953136;
	b=Bnfc4U5D+iNJNu46nXIYA8UVol/PCZZzcrNg81UU8qT/RMmJ/zc1nxNylJDQQvn1pU58I/
	IlGtD+ZMsMblXVpkOlUp6EqxBQxsHcjBFAD/fKJQzgi1w7XDUe2Hxa+dYZ0xQ/8JDDHAKK
	JquJoUgU60644CaP2Sm9ajqz5kR/+Ng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=9t
	9jRj7/HCFVCvKEHPg2zTk5Ak8y48z3aFyjzy9sL2Q=; b=MPcDCT937sbS0kfEU8
	fpGa+epsTdxlh/MMcVJluEWcH7Od7fh698QkiCpVzTM6RCbSBVwVrYNdXowVWM9r
	nw0IXe28T1JldNB8mR3par0kODh+hUCyzMYC2IqTzyzpJdIDre5N1zCJbAWKIKO9
	lefZH7KEcBV8UljzD30m5MNHQ=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wAHzAKTvYJqe4poOA--.32S2;
	Mon, 17 Aug 2026 15:51:48 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hui Su <sh_def@163.com>
Subject: [PATCH] mm/migrate_device: avoid out-of-bounds writes for compound folios
Date: Mon, 17 Aug 2026 15:43:51 +0800
Message-ID: <20260817074350.442493-2-sh_def@163.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAHzAKTvYJqe4poOA--.32S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7try3Gr1xXrW5tF17Xw4DXFb_yoW8Kry3pF
	4Fg3WUtrWUWry7GF13Zw1kZr13ur9xXa13GFnrJr929Fs8JF95ua4Iy3s8tr45J397tFyx
	ZFWaqa4xu3WUJw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-Originating-IP: [183.192.101.80]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6RTPL2qCvZQA7gAA3y
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B2B3340003
X-Stat-Signature: rc94mhibffwqbs8whjhaxbr7s1u9m1wi
X-Rspam-User: 
X-HE-Tag: 1786953134-781745
X-HE-Meta: U2FsdGVkX1/LYeCBBsM05Us8iHl4xjXORJJjVSaowiM1lOjOUVTXws92e+rdOSkdE9JxxzBEdVPaVnviYggYBIYeb/HzcroJbJ/rGgHR3n5Rzqwx/Fogiw5qbAQcEhu7ztqd6DncPlJ5ErZhLqcmFvGlJnkMpmxJrdwfkK1rr4XaDD3wHZ0xxLb/tKUj8GdTGe632JLJ0jcU+VYP+Hs9GlzF2nBLcAdvZ+6eqfEqFsGfS7nHVcGid3BZhEgYvdU7WtxkjCgr1jvFNPfln/Fk5TaMLx/lhZuTob2ZuyQ8MuGYF4SENG6rHcMmTK0WaPBDzq+ZeM2wnHHsJFcO9dzpqDaLOdw6LZy3BXevTtDY07OryMz2rqm8GSDEUziuEUjjx3VOwRSTF17DqmuiVVBJ7nrO8CjjKN92LWHnL61yb2HZPWzhTN4XHv1PKrvp44zdeHbSMWWUrGylQ60qxAEHIDQ53m2DLLN+9+nud/VwnYw6hzntaWuTg5iBUIWt1I1twCCQ5LW92o48n2tNKQBYz4ZOCMxLEurz+5Kd9xVOHcE43eL8KwPVRQqxTKqwouBqPEjKxjJy4qMYGrrGR/8USB8i8PoDPbMJfBDP+3RTntySRcUIyulDNDYoRcnYo3ZS1NGI02+Cf+TAIzIPx3/igZPr25UxtB3W4pRcMnGLbI1q+9LWICMQMwuTcJCKDvpDbX+rOWlFk7tfU8r5Mls654KAq7O10Z88A4UfWDTpClD45NWG53aTKMAk5+4mSdfuU2W2pMbT+E1llVYNebWjC2f6JDCUJ6eaKaznQwjWu4KfWYk32smH7YBKorhRVRDeIVONsmlcBQzimFyEJFz6mC0g5zHlkxY9uk8r6eLDUU/ntTf9/PlZ4NfFPGL+VA9vo7E+IiC43xBoFy5Zk/oZt6SArwtZ+bqJWsILbh2OUXPo1VyR/oEhtjlBT61xl7lwDJQv/EG0Dve4EuGE0VH
 VtS9EB5d
 B9ZlGLeFlLEOKDgNXotAobq/n3+SEbvDhsBYPOCq/n40XlaRIZAjoEniIrHUTzIZYlwJy0L5VzUkzZEhTHAd85Y9hnS1YxvptqghfJjhKSIBkM4SCwk/81xU2jx3dN5p8dQMiwugcFUkEbNqBhQhRghgSyXY+zJqXnp1fFxFcQ6VzWzXADCS90eHVJEZK8Oi1ypFKRGu1Xkps6RfISax1DDsMd+DedMudSJq5Pzb5KGDvd8VLSorcPd2itx1Bu4MzztMfKRTUEz2KAID+zx6sJaK1qtTvyCd7QiGvjcrb6FuPvMedyKoWsgfmJb+l1ACyfpRXO0sSkz+mI+L2EQfxXyqvUg9uF3LqcxgprOhiR8IbBlrgCjRSoiqfQlI9F6vUCKEy/gzIWUvM+EpuhF87Ynj2ofvq2QcMAwV+XlD+u10/GQ6odtt4oMb7P8JN6e80y/ZbLSolodYHIXP2AJ232plbvdi3mvuILQCY+FTE/nonVVUPCgGD1tyFh1oKxNsUHxzSm/Jr8cq3acC7mDCNdxjkAoxmwPl/YY6c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_device_range() and migrate_device_pfns() clear the entries
following a compound folio so that the PFN arrays retain their
page-granular representation.

If a compound folio extends beyond the end of the caller-provided range,
the loops clear all following folio entries without limiting them to the
number of slots remaining in the npages-sized array, causing an
out-of-bounds write.

Limit the number of entries updated and consumed to the remaining array
slots while keeping the actual number of pages in the folio unchanged.

Observed with a KASAN x86 QEMU kernel using the HMM
migrate_anon_huge_zero selftest. Closing /dev/hmm_dmirror0 after
migrating an anonymous huge page to device memory exercises:

  dmirror_fops_release()
    -> dmirror_device_evict_chunk()
      -> migrate_device_range()

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Hui Su <sh_def@163.com>
---
 mm/migrate_device.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 908d2d4ec43a..67bfc1af0b29 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1396,16 +1396,17 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
 	for (pfn = start, i = 0; i < npages; pfn++, i++) {
 		struct page *page = pfn_to_page(pfn);
 		struct folio *folio = page_folio(page);
-		unsigned int nr = 1;
+		unsigned long nr, slots;
 
 		src_pfns[i] = migrate_device_pfn_lock(pfn);
 		nr = folio_nr_pages(folio);
+		slots = min(nr, npages - i);
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
-			for (j = 1; j < nr; j++)
+			for (j = 1; j < slots; j++)
 				src_pfns[i+j] = 0;
-			i += j - 1;
-			pfn += j - 1;
+			i += slots - 1;
+			pfn += slots - 1;
 		}
 	}
 
@@ -1430,15 +1431,16 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
 	for (i = 0; i < npages; i++) {
 		struct page *page = pfn_to_page(src_pfns[i]);
 		struct folio *folio = page_folio(page);
-		unsigned int nr = 1;
+		unsigned long nr, slots;
 
 		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
 		nr = folio_nr_pages(folio);
+		slots = min(nr, npages - i);
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
-			for (j = 1; j < nr; j++)
+			for (j = 1; j < slots; j++)
 				src_pfns[i+j] = 0;
-			i += j - 1;
+			i += slots - 1;
 		}
 	}
 
-- 
2.54.0


