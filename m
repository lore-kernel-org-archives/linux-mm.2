Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8652DCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3403D8E0020; Wed, 24 Sep 2025 16:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3185D8E0001; Wed, 24 Sep 2025 16:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211108E0020; Wed, 24 Sep 2025 16:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBC3C8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:44:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C167EB6F27
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:17 +0000 (UTC)
X-FDA: 83925321354.24.0922386
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE3FC40002
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=htbGVgnX;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fpXopbf9nrg842Iu+f16vQitKmYdsg5/JBu9HvQmTw=;
	b=EbCS406qKR6aiVgxfxo7M7ae/eZg9i+xgsq5D6kpaOleOiuhTXXrbOk12PFerulZNv8oby
	IYVa1SiR9ngBxjXTLK22eiMm1x+QhsrH7p4FBuEU87Y2+GEd7lrtTFt7xSvnNo+NcHsOfl
	CRK/wY0cyFbxXA6NEY5e2auFaPvolD4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=htbGVgnX;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746656; a=rsa-sha256;
	cv=none;
	b=siE5nxuL7T2CNb9mDS5kDtcatp+V1+UkKJt0mXcqrzklavfzsKWh6bBAqK9Stw+bXvaDnA
	48DoCzSSD6Ej+QaFw/ReKgh9C9tMOVDxRofY7eW1DUR1PEnnG8NRt/kW51UXsJSxg0kEEm
	08BtaISOdUqFXP6h0jM37z+oi7AlkFk=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d601859f5so2983537b3.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758746655; x=1759351455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/fpXopbf9nrg842Iu+f16vQitKmYdsg5/JBu9HvQmTw=;
        b=htbGVgnX4xwwjrt+47yARTdd/ZRM49Ef/8vh/81wUlO2yO3Vn9CHvD76eOYSiKVxZs
         uG6HPQqwLN0+KClfWuzcIrHq1J8azaO33ruYDNweKeWTbr303gUxjc2/VMcR4DZDgiLc
         4k05Q57V4DlL5khK3S0OKEzRG2jhMt2xNR6mVzq6yWDb4aov7eAGhytT6NbVQykkCbNr
         uIHvlLMSWNGb0OIqizoNUbnv/anh+rtGIr1oukcxv9KQEldhKzQwGBTgWwWpc5PajBi8
         SWthh/a8mBBdA6S2BVE7LJ2DNbjZ6lLnTajGcPMXDmsETDU+VnTkIeuMWRmT0xnMLN39
         lPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758746655; x=1759351455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/fpXopbf9nrg842Iu+f16vQitKmYdsg5/JBu9HvQmTw=;
        b=P//yX166PXWTmvk0+3iBW4drBuGj6JY92eF2jrh1IBtQ0/O24Ae70BbbY0c+K1alJZ
         IRxprS7gjHLYJbPxlYEXrUNEzADmxmoy/FZU5zGdMTowjbGcDM7rb+NGLWePxkudhkir
         Qbj4/hn5+DLtQmqgAMvQqlWo9ninuh52N0eUMyF7SkXJHox4G/ADt/es90snIok6KCcz
         tezigZ1EMBw9ZyJXneymeIp0HN9kmkaHZq81fA3dDRV1W+Fz+VN1g24ZKwqhDJieW8Jz
         QvbAS6zRrVYrJpw7JoBdkRQCwx+4DDo9JFs5KD8nck4MWgaiWh1kReBfu7Fy/LggIW/N
         tZWA==
X-Forwarded-Encrypted: i=1; AJvYcCWoZ71umFbX1bE9Ov8TMoRRviSgX2H+0Xk5BFZNCjP8YF6VJSx9vC7zKcYB5XpGmmclIU0e9DVOYw==@kvack.org
X-Gm-Message-State: AOJu0YxAifihRDcZneymqRNT9vldZ3/1531RM9zSHxxAnTvZBz6Hx6dM
	gH+V8zzcBVoxHAynCZ/mbg5pssfXwZgahGgiZ9uVTjjqfyBqS/rITMd8
X-Gm-Gg: ASbGnctzY4WgJlC4CqrJtsFtcpnmRhmy+7Fap4nCwADud8YvcAlxRnF+7T8CF5uAL6Y
	xCUPfQKjswv5/2AtZwTOSmCYEC3n7CEe7aQn9E25cirdcLGSHUs5f55FEsUylCj6FTV7O58R0S9
	guHRigG9+Vp6L0GkAs54R/UfKRyKv86JElKuwKed+JXm1FhJ6UdNHEQszyaOOMcwiqLprtfuGB0
	7en9EtXTS99OlwzhuzMFEvWK11vwcgvx0a+aPvV1Yh2VoAWM53xWPzuXD9aYIqJC3ETn6bCZsfr
	155V8aOejjVyP42DSzyxlEszUAqL8rxB1HaukMoGAnui3xXMFreABdTZPHG5nfjV+VBKA6bWV9W
	4jSI6yit5kHpf7oc+IL3uHjXjUTpQ4Knj5+GswXL/EA5kZWYDzccqMQ==
X-Google-Smtp-Source: AGHT+IF10NXmJFuZ39y0IplwFjsDAIgIBgF/Cg8/CUpRd91k9Lu0+3DKjmDX74kTx+FAzC83Jfqj6Q==
X-Received: by 2002:a05:690c:6c08:b0:721:5b31:54ce with SMTP id 00721157ae682-76401b30aaemr10760517b3.31.1758746654908;
        Wed, 24 Sep 2025 13:44:14 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-739718b0046sm50848027b3.59.2025.09.24.13.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 13:44:14 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Wed, 24 Sep 2025 13:44:08 -0700
Message-ID: <20250924204409.1706524-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
References: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE3FC40002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 65q8io3qec3hh9ygthsheobwjysas73b
X-HE-Tag: 1758746655-121784
X-HE-Meta: U2FsdGVkX1/kr8DsEA547t/5cmsoAn5UYYEbp0R5X+reh/cqoJNOOfHf0Cj/Hh8DAzv4XfA5Uejo8t68MDBMjwsE5NEbvaOyUBZQ9J160KtrOlUBXgHhMvDJaoSQAi7o93sJmwOkRAvQktM5hNEUvonxDydBX380frxTjx5YX8hG/S0MvnNKc7xmHmFm22TSCpZZS/sqn9Rbki/2J5bAwoOx+XVzeTqub8VuIz+j3n2ujwjT7+/geVIoifqv9h3+gT1nPnf7tQ/3pvEkKcndodULu+9zFP5t6Jfzd0eKvetnCfrc5hWqg3vKt64Zp7LX/7JFLZR9lAplq6fOkz9nSLMrHD59AvReDaIDdjiBHEb/gj/JApDq//VzHSAiHvW511Z1b0JoFdQLbycAK/qJfQuuqDDTlDm5G7hwMLSOKUBJ4XXw0mMtsx/ML+0Loes2nLRy0W0cRHiZfB+AAidGBTJJBVwkYN+QFESNBK+MKUnjyFx0KxhgpjbHqnIIERcOhONbYBybi+Sv7VSsxi9awPw1mtNjymF8XtSurGUtENKJVTUu8EHfQxGALRfCv5YYrzHdt81G6XiC68GemcsGFHWG8/3VndYU1pttGnOLu+ZdgCemhL9JK56u6kW6CSXAblCDwNxGJz94YTd+qvmrIlz7nrp01Pt2W8+/Ll/UrNAKBwfUKr4VHl7wcPwrPfxkhNs/Q2WwiWXOpMHnT7eqYA+oFBjb14JTNwHPwMLJ0JPmBZgotuS0BEKX6UNXq/TIU9llJMSVf9omOgbBKGNOD7evn9uWhyBV3xU25lnVLkbj0NrxaDW2xhTNx2Gkv49mfqH40J+52iUqiukD7BztKRT1lXrUo3OG+K4UPN7WuloJSNDO2eeM6DvAfrVFY3GXbw/RL8ShwjcRAGrDANdgZpyPwX08YKGWjVZqFEMNt1NivfLjsbwPkBGEfxPZv0EkIb0JY9qYjZ3s4I/ZS3A
 2PA9/wR4
 u6xzrp/UEsNFU6pM6pAY/LWftDt2tLeOOxyJ4w8a28u4EZQAeN9/QNI8f+PaRW19Ssmdcqcbk0Bqj3ByHoNRcVbizk3baR/Dky52FqNUnuAoQcc2MDEQEf7yWhE+JbPXP9nZFFWPsVd/IMttoqtPtE1w6nB07xmUQyyPaboFfXxpGtg7Ghbo4oGJpcWDfh9VGu56X83NfRtW3kCNzHn+74Al13zRAMgKfCYBO+W4qpEsaqg0rkgLhXdGfrZ6+2NSj0IevyZmPHf/CYf8XEsEdqmz/yzYGLX4uDoQMbSlP0cZpaaZvsQIlfnaNsQK7LV8cPoyJv/Q080j+8Ei90QE8QG//FlXCfTJX+d2t2NGv5f2qCWuNf5sWouajLNZ5Gnnvocdj9sPpaIOkEZE18UbI0mmzXYL3TScErhIGNT3d0Hb1Zxy/CE0ez9qhxOrMu0kJYes9Ft74JRlBT2j95BEooZq0K5+8IYJ1tv0DtTvFGI/lEAgh/dHwyn4xCXz/ja1VSADHbeCTD/f38T8dIeHDhP1kr+JLeZYavJFuD4FWWxxQaU4E2X5lRMKGq6L79i6gBpW044ClN33CRID8KtdnTqECDlRVk22R+2ODdo5TzsWB5wt5ttt5KvdMjRAYeCoGrojW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before returning, free_frozen_page_commit calls free_pcppages_bulk using
nr_pcp_free to determine how many pages can appropritately be freed,
based on the tunable parameters stored in pcp. While this number is an
accurate representation of how many pages should be freed in total, it
is not an appropriate number of pages to free at once using
free_pcppages_bulk, since we have seen the value consistently go above
2000 in the Meta fleet on larger machines.

As such, perform batched page freeing in free_pcppages_bulk by using
pcp->batch member. In order to ensure that other processes are not
starved of the pcp (and zone) lock, free the pcp lock.

Note that because free_frozen_page_commit now performs a spinlock inside the
function (and can fail), the function may now return with a freed pcp.
To handle this, return true if the pcp is locked on exit and false otherwise.

In addition, since free_frozen_page_commit must now be aware of what UP
flags were stored at the time of the spin lock, and because we must be
able to report new UP flags to the callers, add a new unsigned long*
parameter UP_flags to keep track of this.

Suggested-by: Chris Mason <clm@fb.com>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 467e524a99df..50589ff0a9c6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2821,11 +2821,19 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
 	return high;
 }
 
-static void free_frozen_page_commit(struct zone *zone,
+/*
+ * Tune pcp alloc factor and adjust count & free_count. Free pages to bring the
+ * pcp's watermarks below high.
+ *
+ * May return a freed pcp, if during page freeing the pcp spinlock cannot be
+ * reacquired. Return true if pcp is locked, false otherwise.
+ */
+static bool free_frozen_page_commit(struct zone *zone,
 		struct per_cpu_pages *pcp, struct page *page, int migratetype,
-		unsigned int order, fpi_t fpi_flags)
+		unsigned int order, fpi_t fpi_flags, unsigned long *UP_flags)
 {
 	int high, batch;
+	int to_free, to_free_batched;
 	int pindex;
 	bool free_high = false;
 
@@ -2864,17 +2872,34 @@ static void free_frozen_page_commit(struct zone *zone,
 		 * Do not attempt to take a zone lock. Let pcp->count get
 		 * over high mark temporarily.
 		 */
-		return;
+		return true;
 	}
 	high = nr_pcp_high(pcp, zone, batch, free_high);
-	if (pcp->count >= high) {
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-				   pcp, pindex);
+	to_free = nr_pcp_free(pcp, batch, high, free_high);
+	while (to_free > 0 && pcp->count >= high) {
+		to_free_batched = min(to_free, batch);
+		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
 		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
 		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
 				      ZONE_MOVABLE, 0))
 			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+
+		high = nr_pcp_high(pcp, zone, batch, free_high);
+		to_free -= to_free_batched;
+		if (pcp->count >= high) {
+			pcp_spin_unlock(pcp);
+			pcp_trylock_finish(*UP_flags);
+
+			pcp_trylock_prepare(*UP_flags);
+			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+			if (!pcp) {
+				pcp_trylock_finish(*UP_flags);
+				return false;
+			}
+		}
 	}
+
+	return true;
 }
 
 /*
@@ -2922,8 +2947,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_frozen_page_commit(zone, pcp, page, migratetype, order, fpi_flags);
-		pcp_spin_unlock(pcp);
+		if (free_frozen_page_commit(zone, pcp, page, migratetype, order,
+					    fpi_flags, &UP_flags))
+			pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
 	}
@@ -3022,8 +3048,9 @@ void free_unref_folios(struct folio_batch *folios)
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(&folio->page);
-		free_frozen_page_commit(zone, pcp, &folio->page, migratetype,
-					order, FPI_NONE);
+		if (!free_frozen_page_commit(zone, pcp, &folio->page,
+				migratetype, order, FPI_NONE, &UP_flags))
+			pcp = NULL;
 	}
 
 	if (pcp) {
-- 
2.47.3

