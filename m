Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 523C1CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407888E001E; Tue, 23 Sep 2025 07:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342488E0001; Tue, 23 Sep 2025 07:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BB418E001E; Tue, 23 Sep 2025 07:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0582D8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:07:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8B981DE0C8
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:25 +0000 (UTC)
X-FDA: 83920238850.14.B3538BB
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf25.hostedemail.com (Postfix) with ESMTP id DDAF3A000F
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b YDfrPd";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=GoWm7xyg;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDBl7oJGV3fWpTYYjjz2yGgNlw4zY/i9bG+IwFihDok=;
	b=QXTAOGa0AV3RxN0yFvX5TRGCNs+W3Vfi3QssaNIxiNGBUsTyjAj8Ys8zv43qkxUuB3NQz/
	1zYNRZoV4EbwwVjlhdhTnl478ksly9/tzJv1m4MhTJ59P4WjzPHQsst1Dzd/p2WR6lcDGW
	RZWWkSERXyc5YQDXAIXKZLvEPdmSC6A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b YDfrPd";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=GoWm7xyg;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625644; a=rsa-sha256;
	cv=none;
	b=xbnartUJmz+HMERirNWe0lYZqD2W44+ymyoCY3YA5tuc3nMKrI2vTRN3rYqCmh8l7Ps+l2
	sPx9YBcjQO0Hv6qKbx393/y0f9TxOX+ZGx4tG6flX4QEgkV0luMy37Cz6/T91xVumr7LHz
	p90xb6TArBBRIeuXh022FJl91SDmt2w=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 5A1BDEC00D6;
	Tue, 23 Sep 2025 07:07:23 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Tue, 23 Sep 2025 07:07:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625643; x=
	1758712043; bh=BDBl7oJGV3fWpTYYjjz2yGgNlw4zY/i9bG+IwFihDok=; b=b
	YDfrPdIwLq3lpWq8Cp7n9DYO74ysd4WpJtuMPtFJV1iBLCNy8gx7HapavVe3MXHm
	RTOk95bFEv+ePlAaqUcHUnaA3pvsnDyqkQQVbncp/9BNX1gNRvPqmPV03Y/N1kEl
	Fd6Z3dANWDnVM9Hj9NrzKqi3swXNIMH1nuMVyr2COZJnQYOkSIG1JEgAQyCoj6tY
	2Ld8OolThZ3JZG4p3rHs+GxGJuP1noXcv1VlKXrf0ytWv5gbfCCHhK6DP8vESEMq
	Zl1lWt+8Wr+Ix+XF79QxD7g71o+BcsORjrS85M1jtuiUAZGHSAe8s2/5ZPm33Kw0
	z48EJBb6zyoMxZjh9SdVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625643; x=1758712043; bh=B
	DBl7oJGV3fWpTYYjjz2yGgNlw4zY/i9bG+IwFihDok=; b=GoWm7xygmn0tkjDqZ
	PlF1+IkarWlbQjFHpbOFCu38GtM/aAvtp4IAWfWnyFvYZCv36BaXhCr2iGRs3IOj
	LRvMdIi+Goe2J7bgVLivjD0EOEHJltnuLKJ1n4ckYsgk5mlt9LG7REDvvSTVZIJS
	7PxFqL0OxjshNDChp6wbgJ2UTKYZ/pWorkwlB9Z/GVDGKiJIPPhiRIUuJpUh50iv
	hocfaD9UHnYijdPFFS3KanNXvET14Y8+WsQxdTyNdNwr3KKpLZpDZDQ4lbytAODG
	Zg47EWCVG/KKuMvLcrKN2VMWmELwmQ0qq9iMUd5a11JrmTLVgrK56CLrWHYwop/3
	ZukCQ==
X-ME-Sender: <xms:an_SaIRKZT_LlqtT6TFRApLLCD2YUJWsf_R6HTMFJN__t6xoGbTlsA>
    <xme:an_SaBsRCHLkcr0QGPx34eUu-y3O-hxio5GqyiYDvPsYC_YgXaO36A2VjEf7KLuTo
    GS14zdxLh9GuioS2-_aANyOWv0_mGdgOf1xtI2zNXHuCYQOk80aLRo>
X-ME-Received: <xmr:an_SaL8mk77ZxZYpoqWQjHSC2WCcTBBU3UHB891XAn5GGKVmLyO6jxxZO3j_Og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:an_SaCbyMNbty62O3IgNwpDVjLq5JBPcIon3GbYPx26fpmK4voXHSw>
    <xmx:an_SaPrwLGismfNx7AILjtWNbF_LxbY68Tl53pR293SD6XWhMPiXGQ>
    <xmx:an_SaCbSQ0sO5q5CWfYT0DdkvN_xAyXM-gOQI67F2Lf7_PhiVP6mIw>
    <xmx:an_SaK69VfS9Gmb25htXtKfAVW-uxYPD8JiHXASCtF01rbHrgK7nsg>
    <xmx:a3_SaD3GTpiQ5FPCraKdOQhLDzSCIf9qcyFcXJ84ixrwUa3TPXKCTl9X>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:07:22 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 3/6] mm/rmap: mlock large folios in try_to_unmap_one()
Date: Tue, 23 Sep 2025 12:07:08 +0100
Message-ID: <20250923110711.690639-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110711.690639-1-kirill@shutemov.name>
References: <20250923110711.690639-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DDAF3A000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ytb1jzqtmnbnc56ixbkwyasyc1i5i633
X-HE-Tag: 1758625643-348299
X-HE-Meta: U2FsdGVkX18+DkG8BWxoHGA7AvQvtwdocfTrPabQFMR3G2p8GVVp+i3XBA/wFmmtvLSAtHdsxkORiBBAwcTNxGBDjYoRu7m29ly6YFgE4ae6Fl6z+8U1eo1ikerOI1s8Iq+p+XPL1FdcZrOmaPD6azxi46ebtAcG/3XhLhmECzwbQbc3WjLllFmZzQs/5cb3zWIK26Wvrc5yAV0vHEEgldf8W7PhKZXjDNDOuOVTSSVyN9xvyfOZojOgRnfu21dokeiOcsPLnkx9XJmy/f0LOjivo1zdx+UeoTJOGRhsVsLT0UT6aANEMBcPhij890pA+bWEu0X2MPj6M76AQq+ArD2QlaNSbUg/2yczUEl8jViKnNPHcputtaO3/OFrpZoYdgSYD4SJ0se4hkbwgopBkftpC7tZHxJ6Vu/P1B7BXGlwJj66J/AO1H3fs4ElDGOokUnbOmbtY+g3RLp1w3rayLVnPib58eD81VDVaKtqs7j/4vrRw80hH626B5tck9Dnj/0U2D3xbMSaACEct48krXxATxsnLTZr6BUMXl81ArUyVbqG+LpzouiAGOhFwC3nC+HJHxJM8zW/+sQkCiT2a0dTHTq9oz92xHnXCDJY1uKqZMVJ1y0tw4+HTqpvbBmPZXxVniZbkxgzqwohpUeXARdXYN2LQETPZeP8shaO3Bn+io+JXKuIRbqcrCCK+xDPHEe0MFvF44c9tZqvcIZZpiQwPYpJgTiETw9MAYxeAsq4JkQN9AEfd1bD4d+US74qpM6JdQkwkZJJvTFcAVBzcPm9h+LHe9Y2QqbaZdKfjFBqr47cGpybVMnwFuqD6MCWe8fzezzA+55OZpU9Qszjc42c0G5gxp1b7wOsWZclLH1ac9iFT5GFF2KirrZ+qutYicsGR6e3etlXRkQmfueNyGxySVXD2grbHsYTxifKAUhGArx9fRBmcCCTJTIEmeVEOUUpa8wCcMq66TTFxzJ
 D6pvxWyK
 B672LvBUNie4vE+k1OJ6+1LtmB01w+Wnd33jDvFReB7kvjVci9CsTXHf5LRXMsW56xQDs0nrq6LTorfE6FtqmLhnxj/BIGn2COBvCQSQDY47LRYEeNHZ4Wy7QJyZz32qqtULfUpahfYxZ1OqJIHRx+9La6Xv6u5irYYLLWCpDrdMbHBTeZiPy6EaN7bBZ/aHnIgJQk68XSSel0ePa2jm2yN9HOnWjLWU1MwIhFH8ymm4pBA8CmmhuOhkck4d1XMYUH1jTX1MLm76EbUlqxyK3CML1kH6IFo2khFU4jAlrl4eKrkzpIW18bEINl3/OV10xz1Q0LBOA3Tw3sj2lI1gSCvTXUsVlc1fv6gOAg/Hkug0Al06ZtsUORXAff6wOY5eily7I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Currently, try_to_unmap_once() only tries to mlock small folios.

Use logic similar to folio_referenced_one() to mlock large folios:
only do this for fully mapped folios and under page table lock that
protects all page table entries.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/rmap.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 3d0235f332de..a55c3bf41287 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1870,6 +1870,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	int ptes = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -1910,10 +1911,34 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
 		    (vma->vm_flags & VM_LOCKED)) {
+			ptes++;
+
+			/*
+			 * Set 'ret' to indicate the page cannot be unmapped.
+			 *
+			 * Do not jump to walk_abort immediately as additional
+			 * iteration might be required to detect fully mapped
+			 * folio an mlock it.
+			 */
+			ret = false;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				goto walk_done;
+
 			/* Restore the mlock which got missed */
-			if (!folio_test_large(folio))
-				mlock_vma_folio(folio, vma);
-			goto walk_abort;
+			mlock_vma_folio(folio, vma);
+			goto walk_done;
 		}
 
 		if (!pvmw.pte) {
-- 
2.50.1


