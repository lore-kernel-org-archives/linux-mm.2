Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6AE8C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9721C6B00B1; Tue,  7 Jul 2026 04:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9220C6B00B3; Tue,  7 Jul 2026 04:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812F26B00B4; Tue,  7 Jul 2026 04:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51BB06B00B1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:27:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB04712038E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:28 +0000 (UTC)
X-FDA: 84961301376.22.BE9C5A0
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id BADBC40003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YVTrCYc1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xV6i/G5pvlleZ0L2NE10sfLpZZEgkyaYGlgJlwxedI0=;
	b=mSuavQtH5vX6r8OgfJkDT3SF3QopXol096SpEiNi3+gfVKLnEo94A2bVpN4GS3uLOkMeZr
	3l8yXgLKDceAAp+0kSTW76zOrKGF/ZI8HPrq6dLHmYOOpv6/ApfmjSVyIuIDC9GJ/+bAP5
	gcjOWCoEXG6ocJFUfj3EVNJ6bdxpHb0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YVTrCYc1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412846;
	b=uxHUlmb5l2fe/5SlOZK0VpkonCqzVxzmUGb4nqPOrTp1lbJH1OWVjpSWgT1axhKFPvzJWI
	hEa2zCoguqclGgxj6ZNhdXLahCeJ6uZVuEcs6J8pBQt8P0+KPONLCxXBVnvqgeXEPi7T1O
	kQCc2Q+bIQNRDEkFRluZ9OZRjbMWQSQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xV6i/G5pvlleZ0L2NE10sfLpZZEgkyaYGlgJlwxedI0=;
	b=YVTrCYc1lk6biMb7/w3lGOo9ySjGlkCD96RgvbGRfxiWzBgO1Ut3rtMJofaE7o5gakhUkL
	HSCh/0bijy5lD28vCiOnxnR6cYkN9ZN8rKnitcM2mp6/cdmjYXLO8KMIM6a3XxSVr12wTW
	aAXhK3h22QY7XfE0HQLbHZHirouHW9U=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 07/10] mm/page_io: forward ghost swap reads to physical device via Redirect
Date: Tue,  7 Jul 2026 16:26:09 +0800
Message-ID: <20260707082614.95030-8-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BADBC40003
X-Stat-Signature: czrbbwczf4i4icmnfu6esh738w7f74th
X-HE-Tag: 1783412846-276257
X-HE-Meta: U2FsdGVkX1/aZmT2CU10D38Ro93yqL7zanZgIRGCmXr2N+1zkWsZW+Gqlb5vgT97sjA0vZiA106GKxvocR3GFWzHtwxpeySeMgK5phCG9qQnVz43FzFhXjoukpBaZms51Z1q2RnalscknkTs7B17ON5KRhiYn0JWYERYrm4BZR9CXME2PZ1BnUzCIm9D5fCOQU/hHDnN2nOXjb4TNkboqVy3HMrNr8osjaCLS6r0xLkL2hwGBrN7wL1iLqJ1WJQMSAtqBjQNJTiBfFmb0QiexJKySBuPt4v5F61jbr4T5vS9kg83NHk2XaGyq2qpHQh1emeTsvnQed8x6dg6dMD71htbdOjMTUXBZ/eqql0D0D0Yw0QpFVFSr+wfkJ9+1OWNg5/rpOvT8FRr74t7Q1TW3Epmq1CNvaqhShUE1sMrn1PUPl041qCt1cmaXPzrMs5aKdog28BzJv69AggDl6xXT6NgOLcdmAEo7lRN5hCgS1EgdPxnUIEq239wY3h7yt63ipvxGYGQZoWV2nRfA5PilzcBxm1Pn7zzWnLP9/XffSLyrtFTT//xXA4A0ywOun5NpMsJ7cBuDJqwq6+bQkehT0//iRVcBpQAoNJT6uNAvMtCkPac27L3FMoQNt5ycm/OoTCSp/T1teuSEpAqLo81hI1a6RJHTLrhsskSPgyugUBIQeWCjgiIHtJrjMq7Fq6O4ysngiU2Q11YIvhv+FhStW/rQj1rlk/JFtcreIYoW6Gct/00iqXANPiGoe+O4bkoarNJLahLF+l77835DJv0/ggm2DhZdXCtTTyQ7WlADwVWBqoaWMfGqEKCXxwsLtZ6sF8crq8Hdcma88yKOersEXfLbN3xD0vdvZD9sdKw8Es9yxdVQQ6I26szo4jZ/tNgBFLaGshF/H2KJpUPcrUuJ2lEXPmgk/YK5ePGpCvIcQE4mQm0hqoFxn3Hy6v4kYWXfcD21IDTFwdo8DWtpSI
 AtMec+M5
 3+3nkaLXsD3awaPaUl4mgPdb7FTFeN8CDdD0DBUOZu9xHTL6Ryh9hqFoBMQFv5iFnjv8qlK2CwaICHZdH6Z8wgH9KURT7xlpnIak/EggOO8KElJq07FFqv5MYNmaQDlvEpq/XrpOTIHIlr3BUuTh68GCirtGQnirK88YawaKBMYdbUC2fXJwWOrgEfwdeGcs2busqtGd5FItt9HKmLCulOk8oBLjU30yxOO8VEdLbtwa9REYwphKPjI3edg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When swap_read_folio() encounters a ghost swap entry (SWP_GHOST),
check if there is a Redirect mapping to a physical swap slot via
ghost_redirect_to_phys().  If a physical backing exists, forward
the I/O to that device:

1. Query the redirect_xa / swap table for the physical swp_entry_t.
2. Temporarily redirect folio->swap to the physical entry so the
   existing swap_read_folio_bdev_{sync,async} / swap_read_folio_fs
   path computes the correct sector from the physical offset.
3. Restore folio->swap to the original ghost entry after I/O.

This completes the backend-switching round trip:
- Swapout: PTE -> ghost entry -> zswap_store -> Pointer(zswap_entry)
- Writeback: Pointer -> decompress -> write to phys -> Redirect(phys)
- Swapin:  PTE -> ghost entry -> Redirect -> read from phys device

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/page_io.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/page_io.c b/mm/page_io.c
index 96e776f9a503..b87b46f05b2f 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -697,6 +697,39 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug, void *zentry)
 		goto finish;
 
 	if (unlikely(sis->flags & SWP_GHOST)) {
+		swp_entry_t phys_entry;
+		struct swap_info_struct *phys_si;
+
+		/*
+		 * Ghost swap entry: check if there's a Redirect to a
+		 * physical swap slot.  If so, read from the physical
+		 * device instead.
+		 */
+		phys_entry = ghost_redirect_to_phys(sis, swp_offset(folio->swap));
+		if (phys_entry.val) {
+			phys_si = __swap_entry_to_info(phys_entry);
+			if (phys_si && phys_si->bdev) {
+				swp_entry_t saved = folio->swap;
+
+				/*
+				 * Temporarily point the folio to the
+				 * physical entry so the bdev read path
+				 * computes the correct sector.
+				 */
+				folio->swap = phys_entry;
+				zswap_folio_swapin(folio);
+				if (data_race(phys_si->flags & SWP_FS_OPS))
+					swap_read_folio_fs(folio, plug);
+				else if (phys_si->flags & SWP_SYNCHRONOUS_IO)
+					swap_read_folio_bdev_sync(folio,
+								  phys_si);
+				else
+					swap_read_folio_bdev_async(folio,
+								   phys_si);
+				folio->swap = saved;
+				goto finish;
+			}
+		}
 		folio_unlock(folio);
 		goto finish;
 	}
-- 
2.54.0


