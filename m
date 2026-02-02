Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB9C7E7DF13
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2182F6B00C6; Mon,  2 Feb 2026 12:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198406B00C7; Mon,  2 Feb 2026 12:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB55D6B00C8; Mon,  2 Feb 2026 12:20:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC0486B00C6
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:20:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4C12B7387
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:20:23 +0000 (UTC)
X-FDA: 84400180326.26.BA3AEA7
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id C6A9CC000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:20:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eR4pQx/G";
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770052821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6Dakk1p+cxLUZDPwt425oyyrOrpg/tog8dKsiFMjKg=;
	b=aFVG+he67II7W5H042fHuSZ5PmkhV1w/Uk9BtaQLqA6rqylwhdXiuW1Y8OTEBxLtqFXrFW
	lEhoR5H90DiifF6pYZtHz6c/tKWvX65bsT0z5sg75qeqdqzn2io/XlM+LX2HBWtRR8zlEN
	Aibzo533kFZ8x6XkLrJbIvnURWyrU3c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eR4pQx/G";
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770052821; a=rsa-sha256;
	cv=none;
	b=Ta3fFexAW3AZ4UT7pq1EZ7w4XZ0SUi1vNeHe7D/yln5TC3Qe8dN7Ul97PKecEEyfIIe1MM
	hUfQ7NGhjM1XxTgnkJvfy+G6ncskoAVR9yjmnCBo0ieIM1+r3wWYPEtIAE0Ral/wSIK+0U
	lDDUulIIwfQUpyEgyX4+B831AxkTBp0=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2b81ebac5d6so397433eec.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770052820; x=1770657620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6Dakk1p+cxLUZDPwt425oyyrOrpg/tog8dKsiFMjKg=;
        b=eR4pQx/GLZ2ja5fbGnTFKznMigvpAaksiWQd96AiwhP4y5uO8BKc9ee1c8cfm0T0Tq
         RCSQiRw/3un8DkP8iKJeAUB04SZJmGNhKPwLlLOW2ZXp6tk85FrzZ7aM84WoVp+pYFaC
         pFDizp88e7LYZKOIqbx59btVkeV30NsR9BBccawFfxCN1Wg/HN2h6SK3QSo0MK1DI95B
         SOSO67RIkC5s0GsaKv9rFCJzQFJe7I43/+2ioG54SgT3OHfDjQzN2RrjitvkvV6/P7tU
         20M+6skzl6ytIn1HjklfUm2hNxxuwvM0DFGc6RQsDV/yCJopi99szEI99MAuE93KiBy1
         MzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770052820; x=1770657620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L6Dakk1p+cxLUZDPwt425oyyrOrpg/tog8dKsiFMjKg=;
        b=Dj0DfVM/GogLUQXD4OXZEF9K4WAAQRIUAo8O2fovpKj+YxgnRfHeQ1GJhjosWdVLMz
         l7lXao8IeWVZEC4hhauRkfCO485q7NnPJVXVUZIpl/GetbC9XVUcU0p17E9Chx19W8QI
         6F19UzH9KnzoI86t/fX59fymZfhBn+dY6ivOg1b5l/Ev6cpg6f1LRK0AAeMDPqFGvvHL
         Mbq1AyGrXNyIJyRtxGiRebHBX5qQT6NUeYmJmhfMVw7lnFw4+tQGawtFPGJKBVqZ9SMB
         RTs2i+GsDeh7aYivV/KXCt5hrb0lOhbRnWDlP3EjIa5bx+FuMm3pD3laH1B5+OAnjiGa
         7WuQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/7L6+zmUy04kLb3iu7qPKIMt7Fg1wKy7zFASNpq3kfoWIkpEqxyav/dka4a+lVedRKVLooGlbmg==@kvack.org
X-Gm-Message-State: AOJu0YwmRpuwbS+yX/rtvdIdNL6wtP0ZBvanHHUAc9JHENgijT5MsoJn
	JPILTg++n10qD3LV8jKYo/DC7nGM1SIJJzyGVL0G1RsvbODs/lJn/Ccy
X-Gm-Gg: AZuq6aIii3udvKJT/e7AP2blJnykwwhGymQ+2xy68Onjl7OTYMYYCFpqt7QoTrAs2X+
	8Yc5mXdjf2wValE9Jkvrou4WS3pFbj5PzwZKbtHMdZ4EOguCC/Kgq9D2teLOG0PHFRjVjwgv7Eu
	QjlCMZ4LLCAVUMGdj8V1WngXMyF9oUinDsIEzxX0BaRAtwUC3/K4UGZjMA8qhlm8UULAsyL0Fxm
	ajB7IzJLE+F9ie7S1/lbyuT6uy60bD9+mbtaP26iiuryZCeib3wVrewfWovxGxFwYEvaPr7zb1f
	TvOmnLdAQ9iF9MK44BCF/0ncC99vZCgghEADO2RA8aN6vy0re1KG6TwCQ5gAW3jZPZfmFpbrkFY
	jXGogW7lIzksA19TS7lPNM8a+WjUfSndW54aD7oprgDzppMbxTk9Txtw3hVq+sAR8hS9b7DVUw7
	Lde1n60KeduqZqN3EVFoiHbjml5YYJ837H82JLch6kFzLBO85ciFmtP+U7xmI=
X-Received: by 2002:a05:693c:6094:b0:2b7:ee1e:75f4 with SMTP id 5a478bee46e88-2b7ee1e7aefmr2433754eec.42.1770052820338;
        Mon, 02 Feb 2026 09:20:20 -0800 (PST)
Received: from fedora (104-57-70-139.lightspeed.sntcca.sbcglobal.net. [104.57.70.139])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2b7a1adef97sm20129902eec.29.2026.02.02.09.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 09:20:19 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 1/3] x86/mm/pat: Convert pte code to use ptdescs
Date: Mon,  2 Feb 2026 09:20:03 -0800
Message-ID: <20260202172005.683870-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260202172005.683870-1-vishal.moola@gmail.com>
References: <20260202172005.683870-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9agxy513pf1w9sf4ty9814xjgyjuqzrr
X-Rspamd-Queue-Id: C6A9CC000C
X-Rspam-User: 
X-HE-Tag: 1770052821-973841
X-HE-Meta: U2FsdGVkX19COSpzIh3vK0lYQnpEa+EvqLYWddmpM50W37fXFahxPjNkUD8Bbh1ZT1JEJ10jpUkVKdznGp8etgjjq/kIkwW1k7LlvndsUvrltP0mL5QxQNy57ewpLaKnRDJ2EiebUlgzI+fxVCYnlyROdvUqSsa0OtvvlrTO9Iqd31uqIN/dZ7wy+P+iOyJ7Ng2OUQERXKFD2ABp7nh111ZKwGHTsFXH2O95JdBzzSwTCfpFOSYPejZf6Gxy5eDPbINZGVDeOHLXqot3BlxdQ663az+A9cBya37fvs1dMt86RvKTeJYZYZaWRkFGSnb7Pxg/sK+DWPpH9yK3wLusVlb1KVq+0hPoneR+fG3iUM52riC9NEiifoSD7jIJjxZ7XJshLZ1zs3Plg+rkjSy7q0V8VS2Zyz68LzYKjHhFH/TwNCJJ7XEkCplNx0Q2PRdS78Kq5dyb9wXzPqr13+g1F6QY6clm8pJwW6zQ0nU/DW/36f+TYuMh4xRU86V2R4N9oRTdkAz8VovQBUI3s70UPYN7Gxt45EHOlN4Rc29L/OJc87zD85MK+rMn5k4ASO0yS4FD+mNfdMTtsvzst9B+HtljdFZjUC50zrRZ+Fr4UU4phPftjW4tUYnDnBdjqKhuL4fBHJRYU6xPjyh2TgtNkBnB2plPuQRwfFjdTb7JRn3g1TNmnCFQ6dzCs7IQ7CG8jV6F0CedyVoH9AlyhNO5Z9c3vbE6j9Df1a5MoH3OFGkvkzfkGvyANdCwW9YJU63ImiaMHFqk5PoKa8uxQ0W57nQ5RLDbGciOh3XNxOFyqdO+kSHbt0uz69gtafmExRjRL8bG8iZvZ/wGBxel3Bf59+UgYg+G+lwxY12JpOQ0HyLGSPKKKQK5GS4V4VGZ7blHtR3kVV1fIt67UdOjuqaPaeZtVRWsJG6xn9CQs11OzJbJaZ/HiEI569sbWm/xWpm2C6qE5ZHw6XOiXL1avMc
 TqFwuRDI
 Fx37XyYynaxa5yGn80kb0FRSnS9o9mFoI0DebXKIjH3t10mkz1k1+tcmzK8oQk/3tc4oF6HprHPRlzZ9wLYNnRPW4XQtxRJ148aweQARGYfNOUq++eWhUn395HYc9dwIAH6Usk5WE/1pNbDhRjLc2mKCsDMAslDAoXBP7FONDkdFcHajuLctQjNoyxYKVZJWvlCah6BMTKUkq9L4KNCtDQGDP5Y5wDINxuEBtGWKSkM6eYugQonA6g7/uXxYka9mm44VFN6SeKsqXaBVQcrcDYm8M0fAlnY7cLNwVjn0iBggbxLhdLsfmJqM5FTLBnvMGt4yt88umVTZZSAGEAGvFlxWHTrtFVVTqLixSvmuYzfLmE/9jfbo227m65UAPyd9pKWTp4VAGgQ7rtViwvjCmzzZ1G9INBfk72RUyUOeOplUJMqTLM6DGSi3zWHFX5iOJnxqnnJDHM0aepOboOhqo8oG+G/Zfpx0QHB5CSgnhDpxGSwlJVwJjoR4ZfEhjHasSogv1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions. Convert these pte
allocation/free sites to use ptdescs.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 6c6eb486f7a6..f9f9d4ca8e71 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	pagetable_free(virt_to_ptdesc((void *)pte));
 	return true;
 }
 
@@ -1537,12 +1537,15 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 	 */
 }
 
-static int alloc_pte_page(pmd_t *pmd)
+static int alloc_pte_ptdesc(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
-	if (!pte)
+	pte_t *pte;
+	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	if (!ptdesc)
 		return -1;
 
+	pte = (pte_t *) ptdesc_address(ptdesc);
 	set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
 	return 0;
 }
@@ -1600,7 +1603,7 @@ static long populate_pmd(struct cpa_data *cpa,
 		 */
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte_ptdesc(pmd))
 				return -1;
 
 		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
@@ -1641,7 +1644,7 @@ static long populate_pmd(struct cpa_data *cpa,
 	if (start < end) {
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte_ptdesc(pmd))
 				return -1;
 
 		populate_pte(cpa, start, end, num_pages - cur_pages,
-- 
2.52.0


