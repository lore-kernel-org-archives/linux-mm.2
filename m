Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AC5C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5526B009C; Fri,  8 Aug 2025 08:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD746B009D; Fri,  8 Aug 2025 08:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509EA6B009E; Fri,  8 Aug 2025 08:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43F236B009C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:12:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 156B31401A8
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:34 +0000 (UTC)
X-FDA: 83753478228.21.A5C5E91
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42AF9140002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=PJMxNKsZ;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf23.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754655152; a=rsa-sha256;
	cv=none;
	b=X2UOcf4/aOeZ1icUUSoSwV7Ru8RoFDtnZMNocL3YfnAy6SWNG3+bv0EvgNK+vSyjpn4FEv
	MDDwA6LmHMqXUGFw4UwuihXM0eJXry6YWJ9JxF5rIarjh+pdi2qq9hDveUv9+fSmhqDW8h
	xIGofxhT1Ckw1g7YvG/dhyk1mgwv2fE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=PJMxNKsZ;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf23.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754655152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGL5eEa5uwcCLmAXZlfetw2P5FGhr6WsEt8mSkWOldU=;
	b=LTaVb3VuO/WFq3LwyNR5d0go393ArkNNJcXtHB1B5Pdo1NwMUR7GOuC8dCpuRxBlo8jclo
	hNuvxalZfFJdT3ct37D2S1VKekveisyW7m1qfD4YFdHR0ldYOhZe1QzxclrPOYUEaewTIT
	B4jxIAl2/eiKhm3cGr7tzG2BMrrNbbI=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4bz2wF0KySz9smd;
	Fri,  8 Aug 2025 14:12:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754655149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGL5eEa5uwcCLmAXZlfetw2P5FGhr6WsEt8mSkWOldU=;
	b=PJMxNKsZk4m/J8Lll3pMtNJbrGZzevbkVQu4ueEIF0nSztaHLC0UI4fO16+m8KraoOiWqu
	PSLidNADqIcpWREHJPzAmmB8VAoG0cHz6KRG7VTSpppdKinDUJ4mWh16hkU+bUmFweNvIk
	fqwuOxIHqyhLoCqJCesmeEG8vlun0lmzq+6Bweq654JV36rGms6WkVWVI1P+0ZoST3kwAj
	yGoiRY/KF7/9CVsv6zdi9M0yt9gd+tAM19PB8Ju/hUZq56c1Oxxelpn/yEnY9lEyy/kJpH
	q2oi9g06k70aoHZWvdJY/Zh01SAMBFhj5j99tvlAWx0yk0n2laTBhoAB2Q9PNg==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	willy@infradead.org,
	linux-mm@kvack.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 4/5] mm: add largest_zero_folio() routine
Date: Fri,  8 Aug 2025 14:11:40 +0200
Message-ID: <20250808121141.624469-5-kernel@pankajraghav.com>
In-Reply-To: <20250808121141.624469-1-kernel@pankajraghav.com>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 42AF9140002
X-Stat-Signature: qog7co4tz57xjp798rtczs1i8zdhq8ko
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754655151-336912
X-HE-Meta: U2FsdGVkX1/IutkAmjJKES+KAIpThugqr7Wh2UpYz6yXWsWVLrJdx+WGt5stFuopeln2GMrykucRKicNmxCkmUeYDzYYhV0ojkr5+CQcxyq55UUoKWsSA9gTSYNp2S1Sv5bpFgKe7nyZEozPQTy2O/2AVZTeNOEVQDMXsx7hFnGtFlOAiiTrOuJRUnc6wP8J0A9PbmB4ceP7ZDC/OUKA3lGXLiidcylcnvMYh8mw1VIsSSXCPSNWjgyI8llrFrgTjog20Q/4CJmqtofpLTN2qTXYFt6s5lLFtwK8PxF8edMBfWAniYhuUJAD3debE1kN7crltP063t4etNMaypmlbtxNTXXHkEwDWaqpfhs7esvpTTLW8g3HhE5dIpNoMrF1oMl9gI5j+hMAFLJrmZdrGYyf6tGs2Dhk48mzSjwXaLSi8l2lEeob5p2eedHsVHy1HfN0r4G5k3brd6n6aaEGuGf68OT6e22W/gZHLDIQWjCESjpXZfb+iPglpNilkqyPRCayi/AdGXkRrCAkLpL6n1u/8Mo4LKkkd+c0rYb+heW1p1y4saX9IIk+d7DRFRsJ7XQbIKvcHuSaQIHsrtyIzFbrtA1T5wWB+APKu7owBu0XBwU724jDYSk/gj+cSNmnwPqvBOAsbIIeB6Aajq7nee0AaKAF9e0Br7mwBWcfz+bchnVtw0v7kszI+Cm9Lm4RdgnIynkMiwDuw/Qj7aFbQzi3YbVimCa3prA4RNFE8mADNVUCKDtdsDiNyLiOdCCYSnZiEQrpyBVb4xwu9pfojwAmfhYR/VecEJcWH84IvPBk75GLjLEtn9kwkC6lo3m67biHOpPxPZn1IR6BwpzpkWHDbFCl84kziRR3fFFwa9audDKR5maPxT2Ry/Wk7hbXmlkLiDk/SBYlNZ5VV2g6sMF+KvMlIoBprIt6KHAixYVBLzb2+KIAszaF8bdhGawZ2imvHhtp4WiLRP6wmlg
 tZLaeUJm
 KrYOV545C9FdTp7EOUqytj3Y3SIkMS5yEdNxG1XOoh+fg3BXukA3/Kuxj1/28Te+HYXHvBJTJKCmG/XEUT1afUYt0fDmvHW1wDKCYoGvUVdK2H7DtuHBfUoIK8f5PuRfI41Q1QiYdnm+ORogDStZhFAlrDJ8+z7B0d7J9Z05Qlx9rXrF7hPbel//U+fNNHEMvgnhG1L6Xg3tpX6f1FsBBOfcdqx2Z0fmgyiJR2BALMGUl+2wusWNTG179TUiObD1Y52ItHzHOzxpqX5wJp3nxAc8F0chj461jXz427AvxRqv7TzdJHMjlWXSHS8j+Ghl8bzCe3CFrIy/49hZTogThdIyIGjKpUutW1nG4rADbsOo9CXUdXP2NX34i1dgwR6c4KAFSwObFV77+vIkwEVkpFe6dYNBcvECMRsxFWICohhIaKOQ2LxkLnmLO0xbLMemAIja/DWPOgnjXxsnQUG2lA99ZWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

The callers of mm_get_huge_zero_folio() have access to a mm struct and
the lifetime of the huge_zero_folio is tied to the lifetime of the mm
struct.

largest_zero_folio() will give access to huge_zero_folio when
PERSISTENT_HUGE_ZERO_FOLIO config option is enabled for callers that do not
want to tie the lifetime to a mm struct. This is very useful for
filesystem and block layers where the request completions can be async
and there is no guarantee on the mm struct lifetime.

This function will return a ZERO_PAGE folio if PERSISTENT_HUGE_ZERO_FOLIO
is disabled or if we failed to allocate a huge_zero_folio during early
init.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/huge_mm.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bd547857c6c1..14d424830fa8 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -714,4 +714,26 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
 	return split_folio_to_list_to_order(folio, NULL, new_order);
 }
 
+/**
+ * largest_zero_folio - Get the largest zero size folio available
+ *
+ * This function shall be used when mm_get_huge_zero_folio() cannot be
+ * used as there is no appropriate mm lifetime to tie the huge zero folio
+ * from the caller.
+ *
+ * Deduce the size of the folio with folio_size instead of assuming the
+ * folio size.
+ *
+ * Return: pointer to PMD sized zero folio if CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
+ * is enabled or a single page sized zero folio
+ */
+static inline struct folio *largest_zero_folio(void)
+{
+	struct folio *folio = get_persistent_huge_zero_folio();
+
+	if (folio)
+		return folio;
+
+	return page_folio(ZERO_PAGE(0));
+}
 #endif /* _LINUX_HUGE_MM_H */
-- 
2.49.0


