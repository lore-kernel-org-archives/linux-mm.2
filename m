Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06E1FCB61E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FFEC6B009E; Fri,  6 Mar 2026 11:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A586B00A0; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7ADC6B00A1; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C82BA6B0093
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AF341405BC
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:28 +0000 (UTC)
X-FDA: 84516115656.21.E2CDB28
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf19.hostedemail.com (Postfix) with ESMTP id B66B91A001D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=um+dgqwq;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmQ9hgnSXzc8ICiALHSxS12/8YYk8LAoyAkwViY9f/Q=;
	b=zput3gCbGnk3Q1olviYykEiNVzA8caCumDyRrinPaVXg7rT+RXCD5/jd1DNFKzfhgKuKPB
	BjU7/9O/p4hivf3i1Rxx/MR/JEAKjuQt2wZbvjXIM523STfyxbnOi18KeBK92JAi1GFrUF
	c5y2MBWvxwkZZJaEIHCoNKbiqvNK5QU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813186; a=rsa-sha256;
	cv=none;
	b=VVqE8oVY3C8Rp7ELqxWbjiAtu0pF2zCVD0vtUrmwuBNkKsHO7txBWdMf3GSJ6p6RKKuTnK
	ucat+UA8fuQw5915mDwIpEtv19igjg4gyYDiXoLxO23PqZdVQGMWBR0V561TxaikrqENj4
	rKqc+21Fxf0+ih3AVFGey5+3YzCHnUk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=um+dgqwq;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 01E31B3441;
	Fri, 06 Mar 2026 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772813185;
	bh=xmQ9hgnSXzc8ICiALHSxS12/8YYk8LAoyAkwViY9f/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=um+dgqwqwu+LOmxoH8jJjbUK5QsR6oD/Q8owfus/MFUmLPoQvDHx10/773Tr+Ir7Z
	 newCPiFftX7QukoybePCW3/XhauRad935KKymZgcdNSeqoYULRIJYBblBOQUcxg2G3
	 2vQJgyXcKoAGEqwuAp7EYootQejw9kF1m4nPQRvk=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/8] mm: use zone lock guard in unreserve_highatomic_pageblock()
Date: Fri,  6 Mar 2026 16:05:37 +0000
Message-ID: <f795893125583cb4c83ddcf457a0361c6632716e.1772811429.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B66B91A001D
X-Stat-Signature: smb9i9m3xsgy3qoh84xxkspydaf41sza
X-Rspam-User: 
X-HE-Tag: 1772813186-683229
X-HE-Meta: U2FsdGVkX1/csh8eGlcFoK8+feNYgRyDJIrHmJaBJPCC8Va1pvlIRFPCZghLTGaX5kM80yofdD6xAvDtL/zvDaiXFqmz6aHb+V8FOMAG++U5Xj6cSbRaIKe1RHG+KPdf95q2fzVYAXywHXBbeTPASq+9g5fCBCam6gfLHwAMA9ENnRSJo8yYyuVa/ZOQrxgKUfmxNnp2asFL71cMfanab8e/g1MSCzhNZuD5uMJGbGUlbvFC8JQmgEUDoTwOftbeBTxUE8qszghb30MgFqM5owug1gH32oGQl8E5V38v6xTgZuLAl1bFF+stzEpmQ6VSzKUdvtBJT34pXzO3MSUSBkRwr62hFDqRvU4o/fSYoYMuE8wo+VKRqshRb92Y2xG9r/QhGC+oA2U9xEbj4biZexZXw4ZOzgQbLA25W3hT92vNfzyZm+QX2SI7WbvSL0f5Y6QW7nAA2YxeuwPGBHbhsAWYZDlqUiYqvetOsX4Wefi0N3lyJNJPoHsB+8zCZPJPEANapo36VBEkk5CTbAE+UmxqEIkgANcd42eSY/wbxbQTW1Nq6fGhXlMr27QqBCu24gF9vM9Zx0A1ZxF/KHboky17IIWjxLoQaY/ufgJ6LR3ViVlpNjBWjvblNYk1QNTfP36/DCCj3ls/ewNhUaxNpE02JQc4cNc7RRxHIsG0Jug0wD50dLJGVZKE1jT/XWN/La6kl90QGeGSFsqe6qUsXh84qGqfosQQ7c0PLfLdUoSpPdyGMiYeWT1PHEgMh45Etqcb3FIku7SZnVA0FvxQ2fxr6Uj1yQqgFh73msfYK0VJXBtBGO0Mm/d4fFvNpguzsGCwVXEd9/UgTn939xy9fWtMt/JyBox7Onnq1KGlGhnQ6Htl4hpd8LGAOYCfxho9NVxH7zcHA32XxoNzklEiJepkEHZD6dlHC3YWT+AHHBlx5qu7Aq8jA24gqe6fwjKP/hPfLl73Nz3oCOIZ0aq
 mIumeIoI
 sAHSWSHBRbXmuDXChmj9A8tuHMGB5qjmIT8WbxaVuVPvJJMQZUQqVXAPDSFRiOlo6/zHpQVZW0oDg8swnUJHxl1+79qYs1Gf9ONjbUvlZ4SuiJUIRVN+qqv06NUme1tOswcAmeswC2B+s+Epuhh30Ew5JNCNcrXpBGmafxQx9eWx6xPV03NovUOSC5f3xFc59Z9gEDYXkPCyHMqOje4iXqMFZy9b1NWGzaUMeWG6/DJcmAyzGMzDA0EkO8yNVUgRWuzv3HgufnXO/KPLjZV68lSRhCSbNva98ZFfZ+PfrF2W3P6ZstcOB7ZOJsTOXiXia+hVOBPlvLYxr4UL6VajHHdmzEpR0PV+jxUPR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use zone_lock_irqsave lock guard in unreserve_highatomic_pageblock()
to replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 260fb003822a..2857daf6ebfd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3456,7 +3456,6 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 						bool force)
 {
 	struct zonelist *zonelist = ac->zonelist;
-	unsigned long flags;
 	struct zoneref *z;
 	struct zone *zone;
 	struct page *page;
@@ -3473,7 +3472,7 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 					pageblock_nr_pages)
 			continue;
 
-		zone_lock_irqsave(zone, flags);
+		guard(zone_lock_irqsave)(zone);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
 			unsigned long size;
@@ -3521,11 +3520,9 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 			 */
 			WARN_ON_ONCE(ret == -1);
 			if (ret > 0) {
-				zone_unlock_irqrestore(zone, flags);
 				return ret;
 			}
 		}
-		zone_unlock_irqrestore(zone, flags);
 	}
 
 	return false;
-- 
2.47.3


