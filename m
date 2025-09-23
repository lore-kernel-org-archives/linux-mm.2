Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32CCDCAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC598E0020; Tue, 23 Sep 2025 07:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E858E0021; Tue, 23 Sep 2025 07:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86818E0020; Tue, 23 Sep 2025 07:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A31058E0020
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:07:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 706651A02BE
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:31 +0000 (UTC)
X-FDA: 83920239102.06.3F1D41E
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf27.hostedemail.com (Postfix) with ESMTP id A48EE4000C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="e BrpSZe";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=PrhcBeG1;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBJQwyFG/mBuy6u3kCYzOX5EZriO4heRBy+k+i4RgPY=;
	b=XyXjI9q70C8Z0eVn95tJPAaTH1a6r+GlDNDI9gleLDoIp206hZYALuX2jjWwJ6jxLGPFcY
	B/tHgmqAcuYQHCB6hKjmhXVSnX9vClWAplgS1evXctiJoHh0aRfSZoyKOhWypwzh0VNgIU
	1qJQFS3kuVy9yMtnzpSabLMD999En+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625649; a=rsa-sha256;
	cv=none;
	b=dgLyQiGzVA8cCqxySzuF2pQSB3oz47SHKy7AA45eFciLQ22FP1CSvT00xfhwaxE3g8Hddj
	aFIsuklQ/vib+j9VcK1uB53RcgcWgnhO1R28hCIKaftPWbb93z6qgAkZnn7O2VLnyyJ1qL
	BzvnGFA3mfGQRZIGTJNUt95wQreXUa0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="e BrpSZe";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=PrhcBeG1;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 22A6FEC00DF;
	Tue, 23 Sep 2025 07:07:29 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 23 Sep 2025 07:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625649; x=
	1758712049; bh=gBJQwyFG/mBuy6u3kCYzOX5EZriO4heRBy+k+i4RgPY=; b=e
	BrpSZeDYT2luvIzf8C71a4BIoX44rg3deXZlRby5//Bqvi979R9rF8Rwykh7k3HY
	NDMBxDgxrom/QJk5RM0L+JywaBEWbQRVwMQ9szXMAdsMA5vbxzYuCuT2BcwPzG/9
	A5KbR+5eEtKnJus7x2o0el/ud1Fqszxt0/evfJroj10y+EnptwPBWaqv8tCjmoEP
	TyBqC2cjJgTuG6AdrwcCwA6YNu2HsKQGxxmXM2yK8ZLQw+osTrx76ibs37rVdHN0
	ilVg+/r9k/aQddk/X1vRmYsufIsUaUm8XDKj3rGEd2SCyPMsj7Mmjvx8yBBnQTAh
	zh89YKO0BCL34/5OoBZ/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625649; x=1758712049; bh=g
	BJQwyFG/mBuy6u3kCYzOX5EZriO4heRBy+k+i4RgPY=; b=PrhcBeG11yAJoPQux
	np5WlJHQZ2qybfofYscuCW9VHC3wik4Eqp24AFrZTaPXGC7Hac6YrbWjn72rwBr0
	aemGpmDjqZzD8SbIzquUN+S8hI3sXv4GYRjmJYKJdLwnAAuJ8thiaPltP907Uj6T
	um7EXgcYD7DSemAfDTP/1hHcLAyhY5vhMysM23XTphozrhayUVQ9Ty2Cz4P482a9
	DRoSrjix1yL28pGQJlz4DMjhydUitelwNZNb4yhAs1UAj3zmAGyyNQiRoqjIfeFz
	Mk9aM3pGgn7hgbVDzgCjE3MFbYkAYUVcCaCRP+elZxfvG7ncdy2Tp4r1kBltgsVo
	i1GyQ==
X-ME-Sender: <xms:cH_SaLU7RmgQ8p59ow7A4lLbZfOcvoEFOYHLvUnJOdVmAojw4EmizQ>
    <xme:cH_SaPjIrMm2m0mS5GbSyMAetNrJOtwHLPRkcjNggbkVM4vGHQIQ9PJtzI-d8nQhv
    -fvbbAyQ_kl88sg3XuMMoB86r7Vd0Qjy6nMEu5av7moGOfpx697mNI>
X-ME-Received: <xmr:cH_SaNj9oTLRawfXVH9jVVJz5nvjzS3AIskQxGu49EtTHbKnTu6ewIeam3vhWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:cH_SaMv9zo5_bgQDRBUmbzFAYGSRGBRRQPY06dOmgGwS4wHykJAi5g>
    <xmx:cH_SaDskCtT6HkROZodSBtL6mqfu8Ely1vORTN4t2raRWV1IP5g6RA>
    <xmx:cH_SaNMKa5Ll_GigGDB2eHBZ3B2gUdrNxBy3LgPWHZMqIx6EQPCVOw>
    <xmx:cH_SaFdNcMJ5AQYuVJZbhGOFKdqc1gDTWF0q4N2vhrlUjExAlZRwkQ>
    <xmx:cX_SaJbYLO4lVtx39J9mlP_dXCQutmzSXYNXFM4CvnSbSfBYEwvJn-mt>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:07:28 -0400 (EDT)
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
Subject: [PATCHv3 6/6] mm/rmap: Improve mlock tracking for large folios
Date: Tue, 23 Sep 2025 12:07:11 +0100
Message-ID: <20250923110711.690639-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110711.690639-1-kirill@shutemov.name>
References: <20250923110711.690639-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A48EE4000C
X-Stat-Signature: mdumzkdddprcm849qbu3udzfr4bc41hr
X-Rspam-User: 
X-HE-Tag: 1758625649-367364
X-HE-Meta: U2FsdGVkX1/tizjD0gFyIDeHoKuFtwcKACDuzmYvMbXdq8lokX6j6XQNpr7U/VcsKHAw/k/qmsK697c6e8jrKx2egDb+hxMpN5bFkK3PsO+u8Vjgu36P/EcKKxH5d8OQtl7IDGGovLxoxODWxCdYbnK6tDLod1i+MUqA05h4mgc4TjGhZSzpY8AqtDPgPPl+vG8Ksvlz2l5Zm2zqQbto2MSGu0ywv16lFWCXCk3IWejO/R+47isLHKafq5/J9TnsbLwfjWb4vJU2MBfRU/2JfXW1SIguZfiJpgTw+XncXcz4rwBOL8csi97qPTxFQ2U8EJA3if2RA97Zw3v/Tb8w1t03Lktte2AsbC1IBf9vYjZE60UOL6UarWRvQLYqk4HaG6JwaH7KccB7IU04SuO7RqdAsGFavGoAtYbOAOCh9wGqpf4dxytncU9dmW4j9FcbKjTWtRt5VRWnqzO6LPy9qFffWThmA01lV2QQBd9ywc212385vQGomHlGny456kkJy/DGEA48Qtquq7Yuvm3RePYP4L6HsVQpB9uyYMqkz9Fn5V6C6SeDOXc3V7SEdBJca7boWlnoyP7Yn0ms1hYRKaqC6bubMmd/KkvhOvc6hBjeG02ARlBspa2K/XNEMSdiKFtpKZlZJCjvdBThX9qTrcYj7x4vMvCqTV1+C2FOHfFFDOn5yTAsiUAVxssAMFWew0jrdkwY2li8tV3t0LLGAfqkKRag5CG8WaKF0e/idX/KnJAIUMoXEfO/io8XwqnJhYUWsJHjhhHl1aQLOXGuhwqwdJ4E25BhEqxY5mKmA5X00xj2bMuq5HcAX0O+XejtYUcJfdRiVMeRewIe5yKlO956GjsrplxCXuRqKrIpk3V3etNkOGslQVSy6uKSVAWYx7aqxXiT27wh6ztReTsuiaRmPbQazg4U9WP+3bDOZNkj/yqqNaPpNCw23YrOaUai
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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a55c3bf41287..d5b40800198c 100644
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


