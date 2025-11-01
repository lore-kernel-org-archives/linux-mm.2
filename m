Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1106CCCF9FE
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 00:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936518E00CD; Fri, 31 Oct 2025 20:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761E28E0068; Fri, 31 Oct 2025 20:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F15C8E00CD; Fri, 31 Oct 2025 20:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFDF8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:29:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07C0A1A0674
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:29:45 +0000 (UTC)
X-FDA: 84060155130.11.776FFE5
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 323161C000A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:29:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S88Jodhp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761956983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=5QQsBWxf6ZndDud6eE2EiwoRGTksu9K2gB98XrVKWnA=;
	b=krtMfhZo486G1v36Hrdqs8LJMmSC0vcJ/Nk5R5dqLCT678qQkH6X7mX5oLS8Bqvr3MtzsV
	JD0bCqNQkn8S1EgpdkqUhZpO3OTynH91IKaTYG85cKydVjfk01uxxW8Y8ABQJGUeCggy6K
	6mULPDmmQ/XB7Gm3Qcq5diyqjkVelQw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S88Jodhp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761956983; a=rsa-sha256;
	cv=none;
	b=dUklEFVOyFxAEYpWAk2MnfZ/zCcUJuLFgeYysQXaJtm3eQ2I+eCHo5QOCW6XhGQEPmBIiX
	2v9Ewc2r9PYexRLvWI0K0ssWhne7BLgnjGpP05vnpQKkf/m9AaXamEWC0HTrHO4mq68ydV
	3xyEfvqj6DCliDVNcEtokIufESDCusw=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b6d5e04e0d3so532756966b.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761956982; x=1762561782; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5QQsBWxf6ZndDud6eE2EiwoRGTksu9K2gB98XrVKWnA=;
        b=S88JodhprR/SjBR+lySSsgXJBHidDYJJl9+I1fOIt389R5bHRk4eYsRjOLEx65lWL4
         cI+AvvchNV0nXGbvUKEgiHHlTfQtPWPBuechE4eqnfv31bAFgMju3+yrIDdRuNwkeYoK
         ZaouhoNjqCYAu4T/ryXPaGOLJ+ohuOgPX9ZeWJfqnwblm3l1XtJbM77PT1kTQFYXLU1I
         DU781XMmWWtfZP5ZwMVnBNg4S/nUsYoiu4X9RHQ/2aNt+6T3Mb3vL8YNLcE+nv6QTCG+
         k3DcxrZRY5YWb5p4cAFKfQpHnmMHkDGnMYcAB7f96A4S0H5WWN+yGRccIujHBD0NJN1+
         xmhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761956982; x=1762561782;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5QQsBWxf6ZndDud6eE2EiwoRGTksu9K2gB98XrVKWnA=;
        b=Q9F+rqS7d1WesDzEeB0CZUqc5GrXXlrTKSqPhbIpxJec5gVCS1rGxX/GSUqhpRHR0v
         dMaf6uTOwlDFFe5FDRCUXnhkCosvWuOxO2Na74u84OPUzyghjcCZ5SW/tIOWrpE5bDi1
         h9VoNYo+AzIhtqdKb3diu5InuUI+h2JQ0Pov/8Zns+AJv9w04uF/62HPiLnB/QhKC7VJ
         qigkg+a8X1tIcQLtDKxPp4s50/K2UaWhaIfXEOL8NpKZgONTO0VFI9Vrx/WQY0KHz/Ud
         Hsdi/6iRzE7TRLWYk50bWHbHLfX1twR2leS/nGqvLtb71vQu94D/gBkDVqbpRTbP3Xp9
         WdWA==
X-Gm-Message-State: AOJu0YxHyllGV7fhrYHa2+GFxrfhR1ATp9BPEqv3k1feW8hE27/UlHcQ
	hRS3K5aIRj5/VMAYdRK55qxuld5Zasm8VABmZGx9SQBX6KZbd2YzpHEM
X-Gm-Gg: ASbGncs/PtGKxPM2sqEtaqu/as7CNsr3WzN9y/Xo3gfFWehhPTSfeTq9ULRt8mKOo0W
	ufRfrLBQWwMUjU2RlDxr7cAkIr4kITXTy5gugNEbEAqHvstKn16ftYaPoB1Gu5YpgBV++5KKbaz
	Ler3+WOrBVaKFqXth2KqKCc5nxn61BpFOeKQpCutA0yXeOjbIH65bKkWYsBcoI+1sVt4cLSmkf/
	usTJ7Thbz2dPjuYZSpb5hz2HmgfdleZ4tuXwimNR/+gWMXP2mX0qN6w10kL5M8PZPU8lo5URpDK
	X57CwCaN8ab04IKwlpRs9stj0Gd0tQ8N3hwW7OVqwIKhjCVRAlDKztXdcE1MgSkJMKDx3MTMbiE
	JCajbDZyetmQh8jMhqig/rCc8oCR35qz1tQr42k3hUWTCIuLYDVqoFxC23eOnNACCVNG7pe1CKY
	XIOxeE88UDTg==
X-Google-Smtp-Source: AGHT+IEun2zCjnW7piDOJsK3iHJ45uT9SxW/AoWE02HAGMDvQvIQ8mLsBW6wzUCRtgRdudZFsq8K/g==
X-Received: by 2002:a17:907:7ba3:b0:b45:1063:fb62 with SMTP id a640c23a62f3a-b707019f735mr510472066b.24.1761956981630;
        Fri, 31 Oct 2025 17:29:41 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077cd2d48sm306637666b.60.2025.10.31.17.29.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Oct 2025 17:29:41 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 1/2] mm/huge_memory: introduce __split_folio_and_update_stats() to consolidate split task
Date: Sat,  1 Nov 2025 00:29:26 +0000
Message-Id: <20251101002927.2610-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251101002927.2610-1-richard.weiyang@gmail.com>
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 323161C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 3kwza9j3ihe6cpcot86nnuaw8ssa5ibw
X-HE-Tag: 1761956982-894414
X-HE-Meta: U2FsdGVkX18/uhnOAF8HbxX7wvFHIJ+Lkrg8fTlWOVBBjLBjqr298fePzYXTUYqS2g2DKeuqKNmoGshrWkdQ/DcKz6R+MPaQFZwwKl0xtswW86leozR119AgVs4Dmr/tAOwyZyuCCfD8ICrZSpPShj52/vu/FJ+fOV8nQi/6VGp0WBhd6tf8V0gzS7iXQOddnwRP6zZ+v7TuvManan5nviMfnIyKzQtzcyUPnQebAJ5Y3BDOsVowNwi2zWwPbxilQOiDQBMqQZU0EIR+3N/KCgDeZyFQgqStus86byxF2lSxK/b/6kQykJnmtVUKJfe6Zqou7YCJ7xv3m+kq5cAsIJA/yB8I3CfaZG/GJNfbt8ZjZqg42TmpQl5uG/bX7AJhPa0i0wIivkrifIa4+R+BDI6FuKLQ00MfUk4iNApCioMe+PdWP9l2YNwok8igtG36y7VAP49qBGdrhpI+4kIdVWINIrXmCC0VlbbLow7m46LhQI67O6ZLtkuxXLECi583CYBbRv0Ct/LiOFSxwN7iCAApQBLkeemifV1RPobVmwKBv5ZKb8S6CTcrl7svOU3zopvzVIJXNj/xjWbxn4Majq0KWTzwgkZi6y9tRkr9GeI6indKhv1KnOCRAvLBitdBjVFpfUso5nLz5R2zXr7qjCcrw7g3UrUVWeWtzT8+Lobce9qOA6H7W0bO020y+onfmHw9R9FYE5y7uKQh/p55OvjXBTZO89XWli1AgWI/2y1jb2BPO79Tz81ogne43jh5Y9NTXAJuz7i35Nn1U/t3W3xkXpGjEi4o7qbrvV5Yh+znpo584XwPPKZP3Y8zQ9iP3eLY9Wk+YVVCuwtnDTU+D6x49z17EQPWGy6ZFGaSqxHKBeDp3B7N9gjFipHJj6Q/uCoH6mqZ33sTbXSebKrVPfHbNaF9uBa5aTvZrx0WT41sq6oghDl1a1z6qs3EKpKdrKmG+Ya8IKAkUFwKbux
 gkkc7TP3
 kaPHUCq/Sy72OHN7Yd2zkMFBtuwxY5qQzS4KLhs2gdymDNcIXXFNoX1ehEuXxduQ7wMe/YvyHd93e8m0BOImofqB0m4s14PbFDRjTt0eNjjfrq3A1gyTvSKwd1ngfEkRTrZeYrwzzhHduFDyUGK8mK40fmQgZZSwYywBSGr/y29eAwHMtHTKGU2bI+79n2djRY8Z6uQuOYH/q9Oge0P2RMabqnOgGhs99rt1UkAaWZ7g7ymRUYk2XMsZt4Fq00Q1KczuEkplk0TtDDkIU5MrntGtSAouqoi+LrSjUclzVLDgsvjayqriHw5e3Stw8daQ9w+X+fsDJ2vnTn/YzMLISr19ic5E3R0/mtZ/eKbiXYdkRViwW6xujT+xxvXkp7tz990TxfCca1dOPjpVQ22GbeyP7b45yKgksAWgetC1BT/vL8CTtFxShkKZ8eaKUs2eWZbatUZr5enRQBmJA63nxFk3bZulFMTx2FQPNnD7DQJiCtBYvwdC+xJXUBTxxZeS77D0NTEW2O3eKm47nqeMvByUa+GG4Q6CcsYh/WE15mHDrvAXNmKkq/xpxPh7/KznkLZs3851oNtP1jAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio splitting process involves several related tasks that are
executed together:

    Adjusting memcg (memory control group) accounting.
    Updating page owner tracking.
    Splitting the folio to the target size (new_order).
    Updating necessary folio statistics.

This commit introduces the new helper function,
__split_folio_and_update_stats(), to gather all these tasks. This
consolidation improves modularity and is a necessary preparation step
for further cleanup and simplification of the surrounding folio
splitting logic.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c37fe6ad0c96..abde0f1aa8ff 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3567,6 +3567,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		ClearPageCompound(&folio->page);
 }
 
+static void __split_folio_and_update_stats(struct folio *folio, int old_order,
+		int new_order, bool is_anon)
+{
+	int nr_new_folios = 1UL << (old_order - new_order);
+
+	folio_split_memcg_refs(folio, old_order, new_order);
+	split_page_owner(&folio->page, old_order, new_order);
+	pgalloc_tag_split(folio, old_order, new_order);
+	__split_folio_to_order(folio, old_order, new_order);
+
+	if (is_anon) {
+		mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
+		mod_mthp_stat(new_order, MTHP_STAT_NR_ANON, nr_new_folios);
+	}
+}
+
 /**
  * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
  * two ways: uniform split or non-uniform split.
@@ -3623,8 +3639,6 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		int nr_new_folios = 1UL << (old_order - split_order);
-
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
 			continue;
@@ -3645,15 +3659,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			}
 		}
 
-		folio_split_memcg_refs(folio, old_order, split_order);
-		split_page_owner(&folio->page, old_order, split_order);
-		pgalloc_tag_split(folio, old_order, split_order);
-		__split_folio_to_order(folio, old_order, split_order);
-
-		if (is_anon) {
-			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
-			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
-		}
+		__split_folio_and_update_stats(folio, old_order, split_order, is_anon);
 		/*
 		 * If uniform split, the process is complete.
 		 * If non-uniform, continue splitting the folio at @split_at
-- 
2.34.1


