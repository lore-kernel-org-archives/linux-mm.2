Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE06606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MZHwVofJ
Received: by kanga.kvack.org (Postfix)
	id BA7B86B05C9; Tue,  3 Nov 2026 16:20:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F7C6B05CB; Tue,  3 Nov 2026 16:20:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A396B05C9; Tue,  3 Nov 2026 16:20:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6ADCD6B05C9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:20:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A85D51A056D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:41 +0000 (UTC)
X-FDA: 85395077082.09.C1A281F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id D0D45140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MZHwVofJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Byl+matXv/yCYuJAj/e9PAUdh4E2zhlMSJcT7pc2pOo=;
	b=XsNF/sBQ/sex4BVk+24Fvoz1tUS9+8/CTX3ZmbBvc+AMoyVy5N3T+vtNf7Lv7mkjnG9vMU
	yTpCHbRV0xIAMGHkJhkJd8ARqLUcpm8siPcpgAs78mD1/G4BOX9FW1HJR5sYCKpBP6K02M
	ajr0zqQyGgB1F6P1nvrymAuKle65Izs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MZHwVofJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740839;
	b=CER2gUAjQgesSbjfIcfZIm+jXl4HcWh9muuS6MZaRBmkZOx1efXJo68EJL6sGMKl3I1WI+
	aFPVXW5efNR+KnuSGObhGgKs3Bsdp8/HGTCini12gbUB7g8lzC8mDMl6NJtVoAP5s2QBZb
	71VSsrJCMSbHO7yZB9k8h/Z8O6CZiBE=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e977109392so81425ad.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793740839; x=1794345639; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Byl+matXv/yCYuJAj/e9PAUdh4E2zhlMSJcT7pc2pOo=;
        b=MZHwVofJJB9XDB/+uneI+IrbdE0fDy5GHKdwLwIMVaiW8ns0rMo1/jZWMSg9qnKMEq
         0H8+BD5pyKG64suO9ePGCt3G/fMoY44q4hLR1wXygFrbgxCq6mcLVAjbKtyd/qgu9NdK
         Xa8XaQPlZY0KF27ploq3CeuMI4FLQQnL4Kn5/uuoUBaQj4Vwp/AmsZUVRDN+HVCA5561
         cbCyxrKsoYcX8BsY2wKm6w2nKwzdM8JCeJPbKqGmD5YPeNdvA2egI6d9wbnWKSY88tFH
         LQHx/JyfgYGAEtU4gZu1Vc2JhTbcRwl+oLlz6KC04pU9V4e4bVoLCEPPHYnLtgMD1mZ9
         XlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740839; x=1794345639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Byl+matXv/yCYuJAj/e9PAUdh4E2zhlMSJcT7pc2pOo=;
        b=sgko3MZ92YIWq2bS6zyMuXiGgo3NHCYpiKQVshPJQZVIbRTOmuSe3XUHxqokemILD5
         y4kuMv+dbooVvGmunGflzltNNaZkweG/mcWetXgTjkxrrbN6KFE5XaAex4g0l6vf+WtX
         1nRn8bJMqHYnOFq/7QKUdjFyt60Sv1sfLBxREWIN7F2vo+ojaQglPhX+s6m6I6QCCMWh
         azATvctNihNVRQGjoBRomqECZdfsywqT110y/M63fP564b31eVB/MGW/icQZWkKQ7puH
         sCWE5M9w2i5MVXtpTMfiv/98MrGAytbCNTFffjSnuFp0YrvKviDy25kWvXPzWiOPMQ5M
         YStg==
X-Forwarded-Encrypted: i=1; AKwUvBwMLWI2PPUsULs2QywLwtKtTX5pxlA92zckrMXlEUexci9uAWsHqfMSvM9qzON6bmzMD+D2wBqvig==@kvack.org
X-Gm-Message-State: APuU4Z/ka45ErX8w1PeVN7RTMmhSDlIYqru7owZ+u90tWNWTmZoiHrNC
	MCd8beZw9X3h9WejNk2rDEWh2GvLZsYjYXu4qWbwZmD2X5jSSGXiHG4L
X-Gm-Gg: AYBFou2+niSzTUzoZQBVCrtG7lADV9HM4KDQo7YGumKbmaDKMi2FKWDhuMUdoaL3HP/
	Cw1ezwB607Fhqp/A3hwZvmi+XgimOLtToiyu0ZguwjoXO73YBfTBSxbu816cQ5Nq8Ub2780SElx
	X+vyZgZLqZDOJCba32799U4rI851UvpfQt50QUAx8es+wrvHqLhxmR9KhgbvUp5jmIGVEW5buy1
	TNnwSOMRO1HI1ByIwsi8r+QUY17dkJkm51pRtC3F7T/g4r7qBbR3RU5hJ8DQXRNjKGDsnPfo/1y
	T/cs3YaA0COymckiw5A/qx2eeSnAUQWDgPqtbRi/9hlqC2dkj9pKJd+JNRICAV1p3gGDUIoWbg8
	lz/SoooxJhj+PgL2OSobO9POrc7YVrjQGVfOCLApxwEz8C9AYeUGytDqMjLPB/voH5WR0cpjEgX
	0SKChibcfMC7AmD5s4LmMSV3BLrBs0C12g/QN5nFN2Vd/0dgtkmWn94Sl6dYY3lLKJH6Qudzaje
	09WT3jVk343cbezdXBUq5SA2QPZYoUPvgbzjIVEbIx6Z9oL802LKcR7cXVoCUrfA6avp4ydrhzW
	cfG4LeUG1ajecE3F6hbsyJk7VfIxCX2DwURfBWoawG53v+p6qD8dg6/aTPCKXk/j4r4rZW7tltC
	K3x8qaA==
X-Received: by 2002:a17:90b:57c5:b0:3ad:eb29:3383 with SMTP id 98e67ed59e1d1-3ae897cc800mr11915117a91.22.1793740838640;
        Tue, 03 Nov 2026 13:20:38 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5b::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b096994650sm119975a91.2.2026.11.03.13.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:20:38 -0800 (PST)
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
Subject: [PATCH v4 1/4] mm/huge_memory: scale thp_underused() to the folio size
Date: Tue,  3 Nov 2026 13:20:01 -0800
Message-ID: <20261103212004.1356327-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103212004.1356327-1-joannelkoong@gmail.com>
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D0D45140006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: n7dzpryzdzni3i8mtw3mij15apkqbdr5
X-HE-Tag: 1793740839-199490
X-HE-Meta: U2FsdGVkX1+YHvFSTmdinr8NmFtNXMF7+8eaRwf50gfEcyPvlPNwMiv8DZ+go3WfP5FbWUyrdZYbrZon6RaPdm7jEq6SXonGUB9aiu3QMfsd/jgR/qLvJExxvp+9O9bT2W241DoYh0HDNK0SHA/UQgow+BL0bZBdGq3zzcVX94Qvw9yfa4QiinwJPxfsrtcfJo3nH3U/feL9bZ/zydtWkxMXi3PQ+XIDewTHOEzIh6FnJJ5pdzQZLqQ38+2HtS5QWWI4gMmXZ6oqMoABasQG/OGeEcWqbMYv2c89LH9JXbcfVYw7pvZAM24vTqtM9rkOZ4QRY6E9vZsGlWOsG3x8fxtrBrMlCNx+sKXu2OeIURJ4Zmt0uf/5gmjz5o7HPWpAIo8OmaWsnkBs5FJ1P7X9jtB1bsn50J1gAZr3pYqCTIXjYaAfYdWFuRtT8RwMCfg4NEWofnIt+gqLd6X3e30C7cUwuy4CRH7VofwDvrkMe77HUZsGhytb2KLSTAh74bkJrExsg4CvwK1SFDlVUSZ5U+RB3lDV+k/KKLXuGOBpRcB6Ep1ZNBy8Vz/A5yfElh3Qi0LYz5jFqcHqy4e43hiUkzo1uzitM43BJystGz8xOrTZQ2jBZ4KB/Wkwn5/cJws0VqT3nceQMsRIZyJfdd2MOiNIjdkj/rTeExuuyZJFLzdoir0YRca9h6Z8iAqQ6f/tSMGq1WSO3hALsCyvGVi09v69r711b3NYKC7Sd6eGcEmJqc1HzciFu2dB98akeNWKrYUD3ngD1jJ4SkkRsk18T031nU22kfVz//+4JA5GxDXrMtUZbYOOfuuU8ze+NVMAZM5AMv+au1Ka8Fxd4wgpVm1hfDhOUJpT4Q9Lm3FgrZ2ha7pDRO8XB2A11q/3kA1uaSh89fBHiMcp0wFWkM3cg4tkkQBWVhP3QsoBzGuvDSA6J2J26pJmUtLPfen+pwNpsJGM+YBQhoPV5YQRALh
 II15zV6u
 gAgUutqLrQqwwVmeyaw5+E5+wA97a5zbpu3GK5LRe8V/DnSMnOzrZpp0Hci2QJzF9DhRGRqrk+yaTWtw2lCMF84gd1lpAn7XeqCSjij8oSmgrDixVuWpxjlM1lRU/be8nLxn5g+yXC16oKlZvL3+jR13hTCdO6fRQ0BPYUjEq/pHF7I8+DzJzjm4ZiT+wpNwWLBzG5H7kmM2XGC+tfVQ+CARcJKdzP1nME5zsGsNz2fZr0tmgLTUpp0iOUonoPiFKcSfIGWod9Nfne1CpFPaBe8Jm2G7QtLUFab0XGDIk3WOGOdYv0mmC5ikYVCzsl2vPQ6LqQe2bcFiXMCizsB+/U3iafoYJXSFMXvvyq4hXw2nVmgcPmsVd6W+Ll5J0ExK92+ZR7JLhMcUShTXBBMtpnRRY5PHWtSRbV577g4/lJFi2wk3po0ETyNuNj4ktigjgKFfCVGStYOhcGPsG1kMdBzT4RFKxEOGa6qcSWX/n+SLf5hPiG8yXvEm5yt4DUQoLBvRbHynrWWI0bOQ=
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
 mm/huge_memory.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 14599d0fff01..3720c12bdb0d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4625,25 +4625,33 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
 
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
+	 * Scale it to this folio's size.
+	 */
+	max_ptes_none = max_ptes_none * nr_pages / HPAGE_PMD_NR;
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


