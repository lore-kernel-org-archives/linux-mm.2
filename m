Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 937C6CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 12:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246E18E000A; Fri, 19 Sep 2025 08:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182AD8E0001; Fri, 19 Sep 2025 08:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17508E000A; Fri, 19 Sep 2025 08:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBE8B8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:40:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96BA986501
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:55 +0000 (UTC)
X-FDA: 83905959270.29.915140D
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9550C4000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="N msJzCb";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=R1+Sr7MG;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758285653; a=rsa-sha256;
	cv=none;
	b=eZPNGW5HT6iBYwBplqarWJZRT2avx4euIG1uSdNxDKUDQHbN5U7DkFOoW5EapsOTyzyf14
	V4dtM65TwbT/IJyFybupmovpRYHsh2BmowAs0bvlAvTUGtNUfEZor0iHRXqkyHxXq+1ko5
	8OslRjpxzo3wg+jDMEGCGEu9eez/XmA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="N msJzCb";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=R1+Sr7MG;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758285653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxh0csfVOqXEIeJ0PDZRZ2dOl352C/UceF+juPeU56o=;
	b=k3fyQD02QLx6HTNMXuFoYfdKvnkv0xNuuoXHQKr5Pl41XdGju5dwbEC850yP73vRJ4XfDA
	PT+dHcDIWpZ01f5gzq4e20747uDnANZji49Av2qTxnMFpIQQo0D4txWAfta/YbFY+175p9
	jTocGmOBgkiFRfdill1SiPh5MSetoYY=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 10F171400189;
	Fri, 19 Sep 2025 08:40:53 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 19 Sep 2025 08:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758285653; x=
	1758372053; bh=mxh0csfVOqXEIeJ0PDZRZ2dOl352C/UceF+juPeU56o=; b=N
	msJzCb7eLd2gI0Zfaco0EvDRWDj7CmihiaDFfishQMh/f1pRAkQMAUxmv1ls4dsZ
	GflJFsnfiRczd++qW8n0M52k5xF9grKIXYfTrf0j2yxEUPgEBpdOSXMVIp1ChtHf
	fxz7lfWg2UW3pBEs71cnG5hziGfPpxUWojvr+zot2Kg7/Yon95XhXYG9xa7CfNi+
	x6Okgvi1Yg0wigzpXuS2cULBwUUpFMEA5by++n8RtpBewT6QEL/vVJ16qofk0n+r
	ASwx1YG8QCZGKzvAQjOGO27VlkJ8OlLFPePXzqitCAL69ADBs4/o19P5rE837aFi
	dF3WXnvd87b0/hTeZIMRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758285653; x=1758372053; bh=m
	xh0csfVOqXEIeJ0PDZRZ2dOl352C/UceF+juPeU56o=; b=R1+Sr7MGq+aSYY4wH
	kOsTx/2EOwo1JplaQY3c6bXdLkWm352tdLHHJzoBUxpYDTWOW5ryoCBtXWkv9k7O
	zLgcqiTWtu4Vc3dDcJdeheOWhuQnHXWjFn2JEmxGxPUwg7G4Fea2JWBolCU3Lnld
	tsHctCtcYdVGie1CJQkNs57ZGtff+u9FcyU8bCGA5OwLzodMNw0nvrv70VXI/svG
	hU/cse3OmFEgYp1obWTMH0JDGRdvHicpCV0KEuc8HXGpyg7k+d+S3Y/htGnFDpcw
	fTC7zOqH7oSYtARBG1kpUklkQMuLOL32e6hcN1h6ctEdbATFMWUK+wi17oBMfIFE
	tPS7g==
X-ME-Sender: <xms:VE_NaPjba1MBPCTYbx0TAZaLkPJGs5ujl4V68d6TmEqxa6N46OwsPQ>
    <xme:VE_NaNgUDwjhfsa-D5cjLt04_orxOfzgzvUz7bcddWReeEUCIeh8FPh4-LTtw9v0-
    -UFbr9jY_VxW55Fh4g>
X-ME-Received: <xmr:VE_NaMvI66RrkR06KiA8GNu1anMpaFCDbW14KbatjGSUocnXOSGOVKiTCq8slQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegledvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:VE_NaDuTrkARgMiI_JyIa9QOhf6m_vdjp-9paw6zpUx_29TPkF1S3Q>
    <xmx:VE_NaNNNKORfVFQhVCobk2UtXn9WgQJGi0Q4y_AM27czdpSNphGBFA>
    <xmx:VE_NaFfUN16EFA3pJWLVE2Uw_g6SRbpC5wv1MKv9gLd3By5l6u_msA>
    <xmx:VE_NaEkq2tpUtT7xKf8rBXGwacTHNgbkj3gR0900nxpcfsaPY_W0WA>
    <xmx:VU_NaIrpBwudk1qRhkHwkbHukUm9TJO0LRz2tm9iAg-gwd_BYF2EtpYF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Sep 2025 08:40:52 -0400 (EDT)
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
Subject: [PATCHv2 5/5] mm/rmap: Improve mlock tracking for large folios
Date: Fri, 19 Sep 2025 13:40:36 +0100
Message-ID: <20250919124036.455709-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919124036.455709-1-kirill@shutemov.name>
References: <20250919124036.455709-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9550C4000A
X-Stat-Signature: 6dkippspcyaydw8bw5m6gtgsc1j5sd9w
X-Rspam-User: 
X-HE-Tag: 1758285653-981779
X-HE-Meta: U2FsdGVkX19hgxGe/lv6p9qmsR6hv5QuyaBg3yVidMDMvzOGbsnMuN5vj4w9DvcaOQ3BC9PzSDMtGY6pkqhTLXoJh7XaeVT7nt9b5xcoKuI4f6MV3U/i0XxbMJ3/9/7ub0XtXzvMgPgPeGZfMR06HbIrdVqysXJoc6VokLpNne8YRjPrtd+L6+mqQOJUX1epeWFDFAq686BqaNAac3FCpyY/wr67Z/EyprJoGbsflstTCdukOzuH88hd4rqfVPnPibygrD7Dzzzx5j4KcL4bYDcIrwlWTzJuw+8/rtFr8cvBVFV98vuYXnV656woeYIHDvtzHudIQjj3wQHfD/Yc8yYcGjGdK+f4LDQjT6SA3Tp/A2fTxfqxQMGeXLcy+PkvJooMM8vYNhVutf19Lp8rzuq0Tk4TjMicnCzi0qHu4fsPMt4uUpoqZ4r7k+UOVZiW3m+LCEOTMdzPJKjZLxMAE15s1TwB7zUV5y7pp3v3P+eWvTy4zymB5c37H4E5CnNGYpbwH9W14xC7OzU2E7dWNp/DOUwspQNuq1tjaKY4b18aT5GAdch0SfegSKTZ19MCx4A0+vwT17iL4H/FcpW6ONh0iCYj+fOT7fqyA5yvEgi5CkUWSXN2iaYqIu+AxQMD4IXDbqRsOwmgV2+SFZP7OohOsO8s6N616J9tpuDjpTtvzKnUUDJqabaDRlMGzwPFE9feqvJ5mzF3bJY4D1+vsWONjJnH3GxaafCzB1m6Zm7dNRTLwyrKjvtWUbo4rJV1qnxBtOyQ0yB/FwzxwzydQVvyglrrqvyNBEXyLwJCeKwZtPw/BGJBuyri4GUZo4+FA+y1zx8adzVrjkVTTFUPAfYDMebswDPaddFErvjs1MC0mI+ac5O6YVyZjGIdNMA8y0bDy8EU9zmN4WKdnqB4ZkPOQo4f32GwDd5xQ1/7ogUDXwWZ5kkCvSNZkvyaoYMtNF68Ii3yrjhzFwHAtAc
 ewfv98/g
 Ci1u3JTlgN9vOKGIb/HvLLoEZ2XmNp2Q+7dEY4rlGcoYp4UlnBZUX+soJPJk2BX/H1+NO5nEODlM8/ByfBFvXibe4zsHUr93X92xotMiOEsXffdw5EanyhixEN0mWfsOCM4lPch203EargJD4EKc60vgDdb+Ik/qvueQukpfWP12Iq9LO73OCERYlU9NGBdUhtCn9IJVpjrm9mZ9sBaMBTeWXrqDmMCF7uiAEVRsP2S69BIGaTbDlPUMIwHB9J1jTLBujHTH51/9eiQrvm7xuwrDDZYLLpKKxpaGLDfarHtgdUZILLYYL0/KoiPSR+D9JPOpA2VG/etzM1fqWAtxOmxf4INCYoxohVgoV+GQa0rKI5yklhUo+iu9Z8GFL5dO7zhgvjNGT6HaGQAbDhROyMjlfBd2avfIdVcivSMctGFUbknide/qK7hEeURCkJcHmmJ8p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The kernel currently does not mlock large folios when adding them to
rmap, stating that it is difficult to confirm that the folio is fully
mapped and safe to mlock it.

This leads to a significant undercount of Mlocked in /proc/meminfo,
causing problems in production where the stat was used to estimate
system utilization and determine if load shedding is required.

However, nowadays the caller passes a number of pages of the folio that
are getting mapped, making it easy to check if the entire folio is
mapped to the VMA.

mlock the folio on rmap if it is fully mapped to the VMA.

Mlocked in /proc/meminfo can still undercount, but the value is closer
the truth and is useful for userspace.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 482e6504fa88..6e09956670f4 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1462,12 +1462,12 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 	}
 
 	/*
-	 * For large folio, only mlock it if it's fully mapped to VMA. It's
-	 * not easy to check whether the large folio is fully mapped to VMA
-	 * here. Only mlock normal 4K folio and leave page reclaim to handle
-	 * large folio.
+	 * Only mlock it if the folio is fully mapped to the VMA.
+	 *
+	 * Partially mapped folios can be split on reclaim and part outside
+	 * of mlocked VMA can be evicted or freed.
 	 */
-	if (!folio_test_large(folio))
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
@@ -1603,8 +1603,13 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
 	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 
-	/* See comments in folio_add_anon_rmap_*() */
-	if (!folio_test_large(folio))
+	/*
+	 * Only mlock it if the folio is fully mapped to the VMA.
+	 *
+	 * Partially mapped folios can be split on reclaim and part outside
+	 * of mlocked VMA can be evicted or freed.
+	 */
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
-- 
2.50.1


