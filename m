Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B177BC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563666B009A; Mon,  4 Aug 2025 08:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A116B009B; Mon,  4 Aug 2025 08:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428B16B009C; Mon,  4 Aug 2025 08:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 337236B009A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:14:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF2E21D9C96
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:43 +0000 (UTC)
X-FDA: 83738968446.12.1C53C4D
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B18BC0002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=JogdjNc8;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf22.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754309682; a=rsa-sha256;
	cv=none;
	b=g3joWK7FY0l095QXqWgR9AXi7NbzUS8qpcr3FaNVuUY76FE6X2g2sv/gEppOJq870LkfNj
	NVH0ydnY3poZww8G+g8nSjmrL+ShJWc8zu5hut7sBLu2YbeZBwOur0zGkp9f7CitV0HWK/
	D0VJlmTCennA7t67E8auGAe4yWpur6Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=JogdjNc8;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf22.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754309682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgGhybuB+tAZvqsghR5tZCuaExpLC7iQdGM6Ue4YApc=;
	b=vlxOvBp8vjsWDBGWjldHiG5l7DA07aNr+ei+Uai21n2cP9jzLI77j7jOy/vQe8s9mT5mKr
	YoT1HsmfCc1a7FvpsD9T7WrK9xF1Vc6yhxqGMWKF+G2yXyKpeJMoVNzm+M7FhrsesPAIlJ
	N3KJCuIGaQlLfFt3E0v0Tz2ae6K8YDo=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4bwb8Z5DNqz9sy6;
	Mon,  4 Aug 2025 14:14:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754309678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kgGhybuB+tAZvqsghR5tZCuaExpLC7iQdGM6Ue4YApc=;
	b=JogdjNc8TbOYGaRal6ul2EdZ36M2+wgOdqzDmdw3o4etELnbmBQeg79oT/sOzxB33y0cQN
	qRMI/4ZoRg0HAWSBDELzHTQzWLCs4YFWROruNL1nq9mQc5FC1/70hgrFl/zGwM3N7u+6V4
	KHw5BFNEg0Lu+8WStXiP05uU6wg/0Jis8IHzu52cYC6YBI1Niros/a1LLyH5Xxz4STWBwy
	J+WhOF6PhL3+9tOHYwpg3yftiilUDt9aL01rwjXaVo49+tWVlwqK+UReV2OsJTo96uRAd/
	lriRpdwu9IdqxW56eCKiIwtkfKb21aEBKqavjMlzLVrVV5vJWJhbQExhq+qnGg==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
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
	linux-mm@kvack.org,
	willy@infradead.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 4/5]  mm: add largest_zero_folio() routine
Date: Mon,  4 Aug 2025 14:13:55 +0200
Message-ID: <20250804121356.572917-5-kernel@pankajraghav.com>
In-Reply-To: <20250804121356.572917-1-kernel@pankajraghav.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B18BC0002
X-Stat-Signature: 8ecki5i8tsmnbt9riyexno3iuixkgf9q
X-Rspam-User: 
X-HE-Tag: 1754309681-880345
X-HE-Meta: U2FsdGVkX1/vpLmjnJQFIGYzrG17ceKOlMsNPJsO8YUfoXxmGM0Bv/P684VRdTRPUGz++8MrYIJcPxW8F5Cmmnc0ss5kpb2aEPvz/EzKRP/1/9hczgdZ/wEhhIvS9AGjgRJElTslm/BWcu9N06YsKSbajm8yUc1NR+flPNkgg1cyGN4Yrt5NfFASKpfq9CCkLtu0vh85uKbotnLQfKpcUqWL+8iwt7Ibcfv63VXnlxnjCDI0nBsOKnncizVSmkrMxag9D8DPQeSSQp1HMRNT7veDD/ZH0Tt3kgHfUYYzynsdlL0IlHIZYKqt9YWYj2Wer4d6GI5fYnwC1suDGNM3aOU+BzJ04HGyDScurEbLxgwxCwli5tqv5D9evPorAzE8Gfh6LFfMarmEOc5GCq539EVFcBaeK1ozdf69T8t0SqCzN0gmiAZ5bkeaSqTXCC/hWACi4ObWJoanQmkn7uP+wcBQZOJKLKFzPIa3Abvb5tTZh2GtGZX6c+AG9LV8/djs3qEEx/klaW9oKvILFTYph7JN/RjsKuom82D/QdIqloswlb3nuy6gOR87Asrzh3U2hy5HsxYxvYtrrvSQFsaHY8GEH6HbvzA4KU58pf8mfSRRmVUGTbsqZw+IVpxrvuZWc82ANHth472lEAuflerUlIIHezI/0GQvFAAKXi7e3h6KO+41ZzA4IZi3F6MWDQDrBxZw6KeGRTFvehfzyrE3qjPLeOr3vB7GtfzHUzK1HGrxwEnMyJqswT1OdH3czK3aGAHUGAw9jM8nZqRkzLpMfbQQI+ewOe9hBWUUAaVjL922ATRP7qSXD83g7CbwJzt1JcH/O8kmeoybObQv4wQWPWo249W2bRR4kRheKCJEXk+P8aQ+3c+j5nWvHkWZRUoWhtuu/6A15d5yW5GMsDPtTPvwxewJ9Z0wgu1Lspz16Uhp/+Tz83DAIC7efJ/2KohW1U6PB3WV6qe4JQuYxXM
 MLTtN7Rc
 4WFnZxR21qz2SkWKCjY8Ss6RDWMzhlb/rYCuplvSthwYOjh5DdfyWbfhNpbCmn7iLkJPQ4e0APCWXAGjr6FAhxfJWi4664AZZnVVpi8GuYJpPQuMRxwbsnIGH3lvtIAqRij/M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

Add largest_zero_folio() routine so that huge_zero_folio can be
used directly when CONFIG_STATIC_HUGE_ZERO_FOLIO is enabled. This will
return ZERO_PAGE folio if CONFIG_STATIC_HUGE_ZERO_FOLIO is disabled or
if we failed to allocate a huge_zero_folio.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/huge_mm.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 78ebceb61d0e..c44a6736704b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -716,4 +716,21 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
 	return split_folio_to_list_to_order(folio, NULL, new_order);
 }
 
+/*
+ * largest_zero_folio - Get the largest zero size folio available
+ *
+ * This function will return huge_zero_folio if CONFIG_STATIC_HUGE_ZERO_FOLIO
+ * is enabled. Otherwise, a ZERO_PAGE folio is returned.
+ *
+ * Deduce the size of the folio with folio_size instead of assuming the
+ * folio size.
+ */
+static inline struct folio *largest_zero_folio(void)
+{
+	struct folio *folio = get_static_huge_zero_folio();
+
+	if (folio)
+		return folio;
+	return page_folio(ZERO_PAGE(0));
+}
 #endif /* _LINUX_HUGE_MM_H */
-- 
2.49.0


