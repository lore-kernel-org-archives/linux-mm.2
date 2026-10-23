Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE0B606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JcIaELSk
Received: by kanga.kvack.org (Postfix)
	id 4A19A6B0906; Fri, 23 Oct 2026 19:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4803F6B0C01; Fri, 23 Oct 2026 19:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369766B0C02; Fri, 23 Oct 2026 19:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 098DC6B0906
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:01:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7DEDA801C3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:01:25 +0000 (UTC)
X-FDA: 85355414130.19.A2BA5C6
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id A37068000E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:01:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JcIaELSk;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792796483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2P3Jbrr2/EIDM+ssPhzBfG3772JonD3D72NASGpKnA=;
	b=aXP2lNLBhlYhnOWG9xCkIfU3Q9fNo6jkbZNWP1rjdRNoJepG71V/UvdqyX6xzkhmIm1H/G
	tPSBTLN0YgVASDb0OrVlg2bb6qAHYihQNmFapHaYZFSYqwrIoRhPe5Obx8y789OuFDOo+7
	N4PlrqtXPcQt+7chAj9AWmn3AHy4N0o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JcIaELSk;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792796483;
	b=YlC9sBYNBR6AFoFcK0Jtnq5iBDUmqEtGxuuZgBXnMxfxJmtUOVHFhwOBPl4vLnSi99X4bW
	8W01MicvSKyI6+MKGkYFFN20HrS/s9ilaB24DXTDjYPLryAtisr9mpDWeLrf4A3njd4+wc
	d/h5eMd+MYQ1X1YKqNJ8nMkb3qelIVU=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6740e7ae219so1429937d50.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796483; x=1793401283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K2P3Jbrr2/EIDM+ssPhzBfG3772JonD3D72NASGpKnA=;
        b=JcIaELSkerU0s+EuDWoOtFFbho9XKPWis7ktr21KbWhrxFX3YGUnw4gMbG845nCr+C
         Nm87YkWYtiDSnrONESbTBPaUmw/pugznmvu1DXInOFvggHizojgnmyyP7eIMgmdORF+N
         NZyb2Y3YOHLpANezSYHvAgYc23dTTHNq+LpABgz4NbIZLq4PfYs8Q5Z5epfGN6Nqe4Do
         eqwsvLteAbpXOXqjNMCBJUR+aQmgIte2iXqmeLAPApcTVJRo+BvjR42klPVuMRSWowpJ
         rdMIklR7IqnpCIMMZCUz/gVQmqWwJn7vNk8S92AMo1UWdnjYmPEmwj/u1JRSMXFM/yT/
         wSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796483; x=1793401283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K2P3Jbrr2/EIDM+ssPhzBfG3772JonD3D72NASGpKnA=;
        b=peYn2hYGvD6EmV2EF79qUKOffDCMyoxT7PyQaZ7pLxcl3mAV8/ETB+pv/lJlWRMsbt
         vxia6G9S/2wTxe1Ur6H6t9Rf+gjHQ8AQjTmdj7Cov03USqWandMbdUSeJ8pYOmnr29xm
         iItoqsKkbYwJmQAlP/yVY1bE/Q3fmrtklyRToiu7388DIsDEXF2KjZQ4tylk2lFR7VIv
         qjnDmNqnmBdoqlSPl/kNXcNJM4a46m8WLZPsmP2nJajLPqnFFX7HIxrOQEweMwAU1HmR
         WvfDbD1c/zrmreaeOQKptnij6vB5IrKnJfI9rwJKPrxn2saaB5OuCNUK8tZNNmW/XB3u
         rg2w==
X-Forwarded-Encrypted: i=1; AKwUvBx8eVKqFJwyQUUkB0kmMooo4MDIFaXiIqjKj+mIPkngLkvDh6Asj5gHJfG+K+xdZF1TDGVQEHGMVQ==@kvack.org
X-Gm-Message-State: AFq9FYJHK8sJ9bzOZjCeAuiAha+z2/XZpJfn4bc0e2blimJjc+5m8Pv8
	39dZ+h0ZN7PGUUTAGyD+CR32GaGDJrR6ovPMyyRlDb1LIWISpmIpi1SX
X-Gm-Gg: AYBFou12WZVQPJ5YjwuZeOBZu8xYVex8xAywhXxpRwDDc7dFwlZlGigqQkZkcJ/RSyi
	juN/NcUochdbAsNmEjbq06zRnGv+4OMEre7ebjb3uNVU6PllaU/OEBYgILssGYDVKVRhayUblxa
	Af7LrSdO3v3Mmtx2pIlMDgkU4Sbl7PDGtda/kWoA23kCpv26yI2QJuB/TzznSYmeNze0oq0Pf6z
	TJMbMXVJcN5LgQ4nIWTJ+TxGtsehLtzo2g83twHBMF+ohrofvZzt70DGVKTyaQ9wE1RZKE3J8Uk
	oUozOxkRJsWx2HZuDTjQe8RiZhnxBm8fwBLo4AcD7mYnMct6o5ggWVwcw0seVOEJ81IsuMea5b7
	ctCsFqMHRpgUJ+5Vslo/LLiy9r91TczWBunUrW2I3cNbhNqQJF9BBQN0X2Rtrs8ZeVUyJTKg/xB
	H1l9cQGNrfZ/Ru7A/2LRAOAN5JgiXEt9WuGtWgg9ocPS0f4Y/jbrUkKItVAy7V6qF4wLbj1Iy5f
	Be5TLIbjcqPhXILFA2AcXbwEG1wXRho9C5kkc25K+QleU4PbZPStv8t27a+i8c04dgkUJnt6Ref
	3L8Xi85ExOrPfFP6NWfQ/d6zL1/RqEMl
X-Received: by 2002:a05:690e:4851:b0:672:f52d:aad6 with SMTP id 956f58d0204a3-67a453bfd29mr319587d50.70.1792796482520;
        Fri, 23 Oct 2026 16:01:22 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:5a::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a45ff901bsm237318d50.2.2026.10.23.16.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 16:01:21 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: baohua@kernel.org,
	usama.arif@linux.dev,
	hannes@cmpxchg.org,
	kas@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/3] mm/huge_memory: scale thp_underused() to the folio size
Date: Fri, 23 Oct 2026 16:00:04 -0700
Message-ID: <20261023230006.3759543-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261023230006.3759543-1-joannelkoong@gmail.com>
References: <20261023230006.3759543-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A37068000E
X-Stat-Signature: jhatk8ehuiea1xpuq37qzrahpq9pitdq
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792796483-375531
X-HE-Meta: U2FsdGVkX1+6evhTPv31gqx9uwiQiTZxxd1xVYKghFKnyrh6CjNISat6huxJXC6Ur6a6v6ERciCXBX8OD8G/7smC7F0fN7/EmTIfCUQ5LFcnfKiggmxbAL95dc+o3pdrWJ43MRltfqBa/pXJJt2BUxSz6hx6DSt44RFHAIBCVGOXfz64CGxyiJYvKBzCloU/jfUEkRuvT6i1U6yuG+omym3vskZ/qIeuyD9jEfkx/wCpnSzf1IQa3JzSqORSK1Xoq7s1W8bVy9ueVeeNWOAvZnhpxEe6GZrw4x9LgZG2eJ5lqlGHbgwe/w98Jf8P46qd7riAoCDvh6lNw8JPviD5frePXrlfIS9R1uM3UPKnx4/Sr6IdAngwyDtEvKiVw1XbIZ/v7lLELMgb8zS5QUej81Eqg2x0P4XM9X2E0ltGEDxPSyvh1fy8wyeNHxUV5MWaPvtNCYKLh2q/ECYfRAtOjbTzscg6I4iB2Ce2Kyyzw6w5zepobqtE12b27UfWjXBAJNnM7cTr+nc4UR5bnnghzccKqwV8BzYZTALQmdhziaxhYV/s11p9EWpGR7cIz6a9HQ6cPVSc4Htb3IgmdhLitGfY9uvmLx0WWLOI/kFJmTlCrlUq6q4hOQwWkh7TyfD8cijiQput25KkIQhWDR2ik6AmqspvsP/qoPYQ6pkagaM4lbiQIp5yDG6ASct5H4BuA8RQ+516/zfuISfPSwnLZfUnYlX7rPai1pox+b43Gh2Yz1QAsdM2IxP75F4yTSkcnDEYrCx62Vb61ZgYnC4Aq1sFBJour6RcULRQ6a+Vbggp0zZx0V5DYOfViDHNADBGMLG2LaEdwyrM6XzIBcqR9jRt3/055W/xju9KpbaMsYa/5NtPfbf4j5l2DXli3DbO+0JjPVtgFGkzog0mo6QhfMAJyS/a8lZQo5o+vUpxNMwaMWuG3AQjjCmIRhG26KKVCctYIp6LuqUyQg3ybcx
 LlRTBPd+
 SUNfd5gKPfJysa8htKznsibg+dgwqglGMkNGCSHk6lu8jITzhLNCMaDKlaHH/Nowpua6vYWoPpy+6HF6/2tpBeogrho9mpmGCUjyN7eU7sZEkEmKGihBwsbM1Mur7saZvcBnixbE4n90WivIbQVhLg5YcKhzCYzY3DJI4UvRY3ZOpYyng2Oh+Ac+n4kc2VPOE7NnP5NeWWtPQuO81+X7EyS6jxR6g50b4jPVEGEYyXZcGo2kl/7Y8ls35Qdywe3r0/IZ4JLe1978mjC2FSVgk0FxZsRKHC8DgSg501H7qL00G+b8wCEiOT4Hcm3cCh1XPG74DspYirHfASmNJM/81RJXSmRyWNX1Ie3tAyzdWl5myeCep8HWbPzgEKkhepEChyXO8qIQLtCRbWJD0N6fn1wvM+BvgsYwcic3f/2aS7BAotYEOl5u60GfEFF1esBIffytMVOq4v4bQVhVCUGgnwBh3BZDEyTHsCAVApgy6TupS0h4UHtCebxsb6HbdUsSlEmdl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

thp_underused() decides whether a large folio on the deferred split list
is underused and should be split so that its zero-filled subpages can be
reclaimed.

Today it only ever runs on PMD-sized folios, so it assumes that the
folio has HPAGE_PMD_NR pages and compares the zero-filled page count
directly against khugepaged_max_ptes_none. A later patch will queue
anonymous mTHP folios onto the deferred split list as well, at which
point that assumption will no longer hold.

Make thp_underused() folio-size-aware, and scale
khugepaged_max_ptes_none proportionally to the number of pages in the
folio (eg every folio tolerates the same fraction of zero-filled pages
the user configured for a PMD-sized folio).

khugepaged deliberately doesn't scale intermediate values when
collapsing to mTHP orders (to avoid the memory footprint creeping up
through repeated collapses), but if/when collapse later gains support
for intermediate values, a folio that khugepaged collapses won't then be
split right back by the shrinker (and vice versa) since both collapse
and split would use the same threshold for a given folio size.

There is no functional change for PMD-sized folios, as for those,
nr_pages is HPAGE_PMD_NR.

Suggested-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/huge_memory.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..218259940f24 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4613,25 +4613,35 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
 
 static bool thp_underused(struct folio *folio)
 {
-	int num_zero_pages = 0, num_filled_pages = 0;
-	int i;
+	const unsigned long nr_pages = folio_nr_pages(folio);
+	unsigned long num_zero_pages = 0, num_filled_pages = 0;
+	unsigned long max_ptes_none = khugepaged_max_ptes_none;
+	unsigned long i;
 
-	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
+	if (max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
 	if (folio_contain_hwpoisoned_page(folio))
 		return false;
 
-	for (i = 0; i < folio_nr_pages(folio); i++) {
+	/*
+	 * khugepaged_max_ptes_none is a number of pages out of HPAGE_PMD_NR.
+	 * Scale it to this folio's size (rounding up so that the folio is never
+	 * split when fewer than the configured fraction of its pages are
+	 * zero-filled).
+	 */
+	max_ptes_none = DIV_ROUND_UP(max_ptes_none * nr_pages, HPAGE_PMD_NR);
+
+	for (i = 0; i < nr_pages; i++) {
 		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
-			if (++num_zero_pages > khugepaged_max_ptes_none)
+			if (++num_zero_pages > max_ptes_none)
 				return true;
 		} else {
 			/*
 			 * Another path for early exit once the number
 			 * of non-zero filled pages exceeds threshold.
 			 */
-			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
+			if (++num_filled_pages >= nr_pages - max_ptes_none)
 				return false;
 		}
 	}
-- 
2.52.0


